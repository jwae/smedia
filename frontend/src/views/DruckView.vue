<script setup>
import { computed, onBeforeUnmount, ref } from 'vue';
import LeihvertraegePanel from "../components/LeihvertraegePanel.vue";
import { API_BASE } from "../utils/api.js";

const props = defineProps({
  apiRequest: { type: Function, required: true },
  barcodeDruckEintraege: { type: Array, required: true },
  ausgabebelegEintraege: { type: Array, required: true },
  druckKategorie: { type: String, required: true },
  druckCodeFormat: { type: String, required: true },
  druckFilter: { type: Object, required: true },
  druckFilterAktiv: { type: Boolean, required: true },
  ausgabebelegFilter: { type: Object, required: true },
  ausgabebelegFilterAktiv: { type: Boolean, required: true },
  ausgabebelegLayout: { type: String, required: true },
  inventarTypenFuerDruck: { type: Array, required: true },
  statuswerteFuerDruck: { type: Array, required: true },
  standorteFuerDruck: { type: Array, required: true },
  klassenFuerDruck: { type: Array, required: true },
  fachbereicheFuerDruck: { type: Array, required: true },
  ausgabebelegGruppen: { type: Array, required: true },
  leihvertraegeSammeldruckEintraege: { type: Array, required: true },
  qrCodeSvgMap: { type: Object, required: true },
  code39Svg: { type: Function, required: true }
});

const emit = defineEmits([
  "update:druck-kategorie",
  "update:druck-code-format",
  "update:ausgabebeleg-layout",
  "drucke-barcodes",
  "druckfilter-zuruecksetzen",
  "drucke-ausgabebelege",
  "ausgabebelegfilter-zuruecksetzen"
]);

const aktiverDruckBereich = ref("ausgabebelege");
const leihvertraegeSammeldruckAuswahl = ref([]);
const nurOhneDruckdatum = ref(false);
const vorschauAktiv = ref(true);
const schuelerTabletVertragKlasseFilter = ref("");
const erzeugtTabletVertraege = ref(false);
const tabletVertraegeFehler = ref("");
const tabletVertraegeErfolg = ref("");
let tabletVertraegeErfolgTimeout = null;

const druckBereiche = computed(() => [
  {
    id: "ausgabebelege",
    label: "Ausgabebelege",
    beschreibung: `${props.ausgabebelegEintraege.length} Belege`
  },
  {
    id: "leihvertraege",
    label: "Leihvertrag",
    beschreibung: "Einzelnen Leihvertrag drucken."
  },
  {
    id: "schueler-tablet-vertrag",
    label: "Schueler Tablet Vertrag",
    beschreibung: "Tablet-Vertraege fuer Schueler gesammelt vorbereiten."
  },
  {
    id: "rueckgabeprotokoll",
    label: "Rueckgabeprotokoll",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "schadensprotokoll",
    label: "Schadensprotokoll",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "mahnungen",
    label: "Mahnungen",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "inventarlisten",
    label: "Inventarlisten",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "inventurlisten",
    label: "Inventurlisten",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "barcode",
    label: "QR-/Barcode-Etiketten",
    beschreibung: `${props.barcodeDruckEintraege.length} Etiketten`
  },
  {
    id: "klassensatzlisten",
    label: "Klassensatz-Listen",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "verlustmeldungen",
    label: "Verlustmeldungen",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "reparaturbegleitblatt",
    label: "Reparaturbegleitblatt",
    beschreibung: "Vorlage folgt"
  },
  {
    id: "jahresabschluss",
    label: "Jahresabschluss",
    beschreibung: "Vorlage folgt"
  }
]);

const aktiverDruckBereichMeta = computed(
  () => druckBereiche.value.find((bereich) => bereich.id === aktiverDruckBereich.value) || druckBereiche.value[0]
);

const gefilterteLeihvertraegeSammeldruckEintraege = computed(() => {
  return props.leihvertraegeSammeldruckEintraege.filter((eintrag) => {
    if (nurOhneDruckdatum.value && eintrag.erzeugungsdatum && eintrag.erzeugungsdatum !== "-") {
      return false;
    }
    if (schuelerTabletVertragKlasseFilter.value && eintrag.klasse !== schuelerTabletVertragKlasseFilter.value) {
      return false;
    }
    return true;
  });
});

const schuelerTabletVertragKlassen = computed(() =>
  [...new Set(props.leihvertraegeSammeldruckEintraege.map((eintrag) => eintrag.klasse).filter(Boolean))]
    .sort((a, b) => a.localeCompare(b, "de"))
);

function toggleLeihvertragSammeldruckAuswahl(eintragId) {
  if (leihvertraegeSammeldruckAuswahl.value.includes(eintragId)) {
    leihvertraegeSammeldruckAuswahl.value = leihvertraegeSammeldruckAuswahl.value.filter((id) => id !== eintragId);
    return;
  }
  leihvertraegeSammeldruckAuswahl.value = [...leihvertraegeSammeldruckAuswahl.value, eintragId];
}

function zeigeTabletVertraegeErfolg(nachricht) {
  tabletVertraegeErfolg.value = nachricht;
  if (tabletVertraegeErfolgTimeout) {
    window.clearTimeout(tabletVertraegeErfolgTimeout);
  }
  tabletVertraegeErfolgTimeout = window.setTimeout(() => {
    tabletVertraegeErfolg.value = "";
    tabletVertraegeErfolgTimeout = null;
  }, 5000);
}

async function druckeMarkierteTabletvertraege() {
  const markierteEintraege = props.leihvertraegeSammeldruckEintraege.filter((eintrag) =>
    leihvertraegeSammeldruckAuswahl.value.includes(eintrag.id)
  );

  if (markierteEintraege.length === 0) {
    tabletVertraegeFehler.value = "Bitte mindestens einen Schueler markieren.";
    tabletVertraegeErfolg.value = "";
    return;
  }

  erzeugtTabletVertraege.value = true;
  tabletVertraegeFehler.value = "";
  tabletVertraegeErfolg.value = "";

  try {
    const vertragIds = [];
    for (const eintrag of markierteEintraege) {
      const response = await props.apiRequest("/leihvertraege", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ausleiher_id: Number(eintrag.ausleiher_id),
          vertragstyp: "tablet",
          artikel_exemplar_ids: eintrag.artikel_exemplar_ids
        })
      });
      vertragIds.push(response.vertrag.id);
    }

    const exportResponse = await fetch(`${API_BASE}/leihvertraege/export`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        vertrag_ids: vertragIds,
        modus: vorschauAktiv.value ? "preview" : "zip"
      })
    });

    if (!exportResponse.ok) {
      let fehlermeldung = "Export der Leihvertraege fehlgeschlagen.";
      try {
        const daten = await exportResponse.json();
        fehlermeldung = daten?.fehler || fehlermeldung;
      } catch {
        // Fallback auf Standardfehler.
      }
      throw new Error(fehlermeldung);
    }

    const blob = await exportResponse.blob();
    const objektUrl = URL.createObjectURL(blob);

    if (vorschauAktiv.value) {
      window.open(objektUrl, "_blank", "noopener");
    } else {
      const downloadLink = document.createElement("a");
      downloadLink.href = objektUrl;
      downloadLink.download = "tabletvertraege.zip";
      document.body.appendChild(downloadLink);
      downloadLink.click();
      downloadLink.remove();
    }

    window.setTimeout(() => URL.revokeObjectURL(objektUrl), 60_000);
    zeigeTabletVertraegeErfolg(
      vorschauAktiv.value
        ? `${markierteEintraege.length} Tablet-Vertraege wurden als Vorschau erzeugt.`
        : `${markierteEintraege.length} Tablet-Vertraege wurden als ZIP heruntergeladen.`
    );
  } catch (error) {
    tabletVertraegeFehler.value = error.message;
  } finally {
    erzeugtTabletVertraege.value = false;
  }
}

onBeforeUnmount(() => {
  if (tabletVertraegeErfolgTimeout) {
    window.clearTimeout(tabletVertraegeErfolgTimeout);
  }
});
</script>

<template>
  <section class="druck-layout">
    <transition name="toast-fade">
      <div v-if="tabletVertraegeErfolg" class="druck-toast-overlay">
        {{ tabletVertraegeErfolg }}
      </div>
    </transition>

    <aside class="panel einstellungen-nav-panel">
      <p class="eyebrow einstellungen-eyebrow">Druck</p>
      <h2>Druckbereiche</h2>

      <nav class="einstellungen-nav" aria-label="Druckbereiche">
        <button
          v-for="bereich in druckBereiche"
          :key="bereich.id"
          type="button"
          :class="['einstellungen-link', aktiverDruckBereich === bereich.id ? 'is-active' : '']"
          @click="aktiverDruckBereich = bereich.id"
        >
          <span class="einstellungen-link-title">{{ bereich.label }}</span>
          <span class="einstellungen-link-copy">{{ bereich.beschreibung }}</span>
        </button>
      </nav>
    </aside>

    <section class="panel druck-detail-panel">
      <template v-if="aktiverDruckBereich === 'barcode'">
        <header class="einstellungen-detail-head">
          <div>
            <p class="eyebrow">Barcode</p>
            <h2>Barcode-Druck</h2>
            <p class="subtle">Etiketten fuer Inventar, Schueler, Lehrkraefte und Klassen.</p>
          </div>
        </header>

        <div class="form-grid">
          <label class="field">
            <span>Kategorie</span>
            <select :value="druckKategorie" @change="emit('update:druck-kategorie', $event.target.value)">
              <option value="inventar">Inventar</option>
              <option value="schueler">Schueler</option>
              <option value="lehrkraefte">Lehrkraefte</option>
              <option value="klassen">Klassen</option>
            </select>
          </label>

          <label class="field">
            <span>Codeformat</span>
            <select :value="druckCodeFormat" @change="emit('update:druck-code-format', $event.target.value)">
              <option value="barcode">Barcode (Code 39)</option>
              <option value="qr">QR-Code</option>
            </select>
          </label>

          <div class="field field-actions">
            <span>Druck</span>
            <div class="button-row">
              <button class="primary" @click="emit('drucke-barcodes')">Barcodes drucken</button>
              <button class="ghost" @click="emit('druckfilter-zuruecksetzen')" :disabled="!druckFilterAktiv">
                Filter zuruecksetzen
              </button>
            </div>
          </div>
        </div>

        <div class="form-grid">
          <label class="field field-wide">
            <span>Suche</span>
            <input
              v-model="druckFilter.suchtext"
              type="text"
              placeholder="Name, Inventarnummer oder Barcode"
            />
          </label>

          <label v-if="druckKategorie === 'inventar'" class="field">
            <span>Inventartyp</span>
            <select v-model="druckFilter.inventar_typ">
              <option value="">Alle</option>
              <option v-for="typ in inventarTypenFuerDruck" :key="typ" :value="typ">
                {{ typ }}
              </option>
            </select>
          </label>

          <label v-if="druckKategorie === 'inventar'" class="field">
            <span>Status</span>
            <select v-model="druckFilter.status">
              <option value="">Alle</option>
              <option v-for="status in statuswerteFuerDruck" :key="status" :value="status">
                {{ status }}
              </option>
            </select>
          </label>

          <label v-if="druckKategorie === 'inventar'" class="field">
            <span>Standort</span>
            <select v-model="druckFilter.standort">
              <option value="">Alle</option>
              <option v-for="standort in standorteFuerDruck" :key="standort" :value="standort">
                {{ standort }}
              </option>
            </select>
          </label>

          <label v-if="druckKategorie === 'schueler' || druckKategorie === 'klassen'" class="field">
            <span>Klasse</span>
            <select v-model="druckFilter.klasse">
              <option value="">Alle</option>
              <option v-for="klasse in klassenFuerDruck" :key="klasse" :value="klasse">
                {{ klasse }}
              </option>
            </select>
          </label>

          <label v-if="druckKategorie === 'lehrkraefte'" class="field">
            <span>Fachbereich</span>
            <select v-model="druckFilter.fachbereich">
              <option value="">Alle</option>
              <option v-for="fach in fachbereicheFuerDruck" :key="fach" :value="fach">
                {{ fach }}
              </option>
            </select>
          </label>
        </div>

        <p class="helper-text compact-helper">
          Druckt die aktuell gewaehlte Kategorie als Etikettenbogen. Klassen erhalten automatisch Barcodes im Format
          <code>K-07A</code>, <code>K-11</code>, <code>K-EF</code>. QR-Codes verwenden denselben hinterlegten Textinhalt wie die Barcodes.
        </p>

        <div v-if="barcodeDruckEintraege.length === 0" class="empty-state">
          Fuer diese Kategorie sind aktuell keine Barcodes vorhanden.
        </div>
        <div v-else class="barcode-etiketten">
          <article
            v-for="eintrag in barcodeDruckEintraege"
            :key="eintrag.id"
            class="barcode-etikett"
          >
            <strong>{{ eintrag.titel }}</strong>
            <span>{{ eintrag.untertitel }}</span>
            <div
              :class="['barcode-svg', druckCodeFormat === 'qr' ? 'is-qr' : '']"
              v-html="druckCodeFormat === 'qr' ? (qrCodeSvgMap[eintrag.id] || '') : code39Svg(eintrag.barcode)"
            ></div>
            <code>{{ eintrag.barcode }}</code>
          </article>
        </div>
      </template>

      <template v-else-if="aktiverDruckBereich === 'ausgabebelege'">
        <header class="einstellungen-detail-head">
          <div>
            <p class="eyebrow">Ausgabebelege</p>
            <h2>Ausgabebelege</h2>
            <p class="subtle">Belege auf Basis der aktuell offenen Ausleihen.</p>
          </div>
        </header>

        <div class="form-grid">
          <label class="field field-wide">
            <span>Suche</span>
            <input
              v-model="ausgabebelegFilter.suchtext"
              type="text"
              placeholder="Ausleiher, Inventarnummer, Titel oder Barcode"
            />
          </label>

          <label class="field">
            <span>Ausleiher-Typ</span>
            <select v-model="ausgabebelegFilter.ausleiher_typ">
              <option value="">Alle</option>
              <option value="schueler">Schueler</option>
              <option value="lehrkraft">Lehrkraefte</option>
              <option value="klasse">Klassen</option>
            </select>
          </label>

          <div class="field">
            <span>Druck-Layout</span>
            <div class="segmented-control" role="group" aria-label="Ausgabebeleg-Layout">
              <button
                type="button"
                :class="['segmented-control-button', ausgabebelegLayout === 'karten' ? 'is-active' : '']"
                @click="emit('update:ausgabebeleg-layout', 'karten')"
              >
                Kaertchen
              </button>
              <button
                type="button"
                :class="['segmented-control-button', ausgabebelegLayout === 'tabelle' ? 'is-active' : '']"
                @click="emit('update:ausgabebeleg-layout', 'tabelle')"
              >
                Tabelle
              </button>
            </div>
          </div>

          <label v-if="ausgabebelegFilter.ausleiher_typ === 'schueler'" class="field">
            <span>Klasse</span>
            <select v-model="ausgabebelegFilter.klasse">
              <option value="">Alle</option>
              <option v-for="klasse in klassenFuerDruck" :key="`beleg-klasse-${klasse}`" :value="klasse">
                {{ klasse }}
              </option>
            </select>
          </label>

          <label v-if="ausgabebelegFilter.ausleiher_typ === 'lehrkraft'" class="field">
            <span>Fachbereich</span>
            <select v-model="ausgabebelegFilter.fachbereich">
              <option value="">Alle</option>
              <option v-for="fach in fachbereicheFuerDruck" :key="`beleg-fach-${fach}`" :value="fach">
                {{ fach }}
              </option>
            </select>
          </label>

          <div class="field field-actions">
            <span>Druck</span>
            <div class="button-row">
              <button class="primary" @click="emit('drucke-ausgabebelege')">Ausgabebelege drucken</button>
              <button class="ghost" @click="emit('ausgabebelegfilter-zuruecksetzen')" :disabled="!ausgabebelegFilterAktiv">
                Filter zuruecksetzen
              </button>
            </div>
          </div>
        </div>

        <p class="helper-text compact-helper">
          Druckt Belege mit Ausleiher, Medium, Ausgabe-, Faelligkeitsdatum und Ausgabezustand. Die Tabellenansicht gruppiert automatisch je Ausleiher-Typ.
        </p>

        <div v-if="ausgabebelegEintraege.length === 0" class="empty-state">
          Fuer die aktuelle Auswahl sind keine Ausgabebelege vorhanden.
        </div>
        <div v-else-if="ausgabebelegLayout === 'karten'" class="barcode-etiketten">
          <article
            v-for="eintrag in ausgabebelegEintraege"
            :key="eintrag.id"
            class="barcode-etikett ausgabebeleg-karte"
          >
            <strong>{{ eintrag.titel }}</strong>
            <span>{{ eintrag.untertitel }}</span>
            <code v-if="eintrag.barcode">{{ eintrag.barcode }}</code>
            <div class="ausgabebeleg-meta">
              <span><strong>Typ:</strong> {{ eintrag.ausleiherTyp || "-" }}</span>
              <span><strong>Bereich:</strong> {{ eintrag.bereich || "-" }}</span>
              <span><strong>Ausgabe:</strong> {{ eintrag.ausgabeAm }}</span>
              <span><strong>Faellig:</strong> {{ eintrag.faelligAm }}</span>
              <span><strong>Zustand:</strong> {{ eintrag.zustand || "-" }}</span>
            </div>
          </article>
        </div>
        <div v-else class="ausgabebeleg-tabellen">
          <section
            v-for="gruppe in ausgabebelegGruppen"
            :key="`gruppe-${gruppe.typ || 'ohne-typ'}`"
            class="ausgabebeleg-tabelle-block"
          >
            <header class="ausgabebeleg-tabellenkopf">
              <h3>{{ gruppe.label }}</h3>
              <span>{{ gruppe.eintraege.length }} Eintraege</span>
            </header>

            <div class="ausgabebeleg-table-wrap">
              <table class="ausgabebeleg-tabelle">
                <thead>
                  <tr>
                    <th>Ausleiher</th>
                    <th>Bereich</th>
                    <th>Inventarnr.</th>
                    <th>Medium</th>
                    <th>Barcode</th>
                    <th>Ausgabe</th>
                    <th>Faellig</th>
                    <th>Zustand</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="eintrag in gruppe.eintraege" :key="eintrag.id">
                    <td>{{ eintrag.ausleiherName }}</td>
                    <td>{{ eintrag.bereich || "-" }}</td>
                    <td>{{ eintrag.inventarnummer }}</td>
                    <td>{{ eintrag.medienTitel }}</td>
                    <td>{{ eintrag.barcode || "-" }}</td>
                    <td>{{ eintrag.ausgabeAm }}</td>
                    <td>{{ eintrag.faelligAm }}</td>
                    <td>{{ eintrag.zustand || "-" }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </div>
      </template>

      <template v-else-if="aktiverDruckBereich === 'leihvertraege'">
        <LeihvertraegePanel :api-request="apiRequest" />
      </template>

      <template v-else-if="aktiverDruckBereich === 'schueler-tablet-vertrag'">
        <header class="einstellungen-detail-head">
          <div>
            <p class="eyebrow">Sammeldruck</p>
            <h2>Schüler Tablet Verträge drucken</h2>
            <p class="subtle">Alle Schueler mit mindestens einer aktiven Ausleihe der Kategorie Tablet.</p>
          </div>
        </header>

        <div class="button-row" style="margin: 14px 0 10px; justify-content: space-between; align-items: center;">
          <div class="button-row" style="align-items: center;">
            <label class="field" style="min-width: 180px; margin: 0;">
              <span>Klasse</span>
              <select v-model="schuelerTabletVertragKlasseFilter" style="min-height: 44px;">
                <option value="">Alle</option>
                <option v-for="klasse in schuelerTabletVertragKlassen" :key="klasse" :value="klasse">
                  {{ klasse }}
                </option>
              </select>
            </label>
            <label class="toggle-row">
              <input v-model="nurOhneDruckdatum" class="toggle-input" type="checkbox" />
              <span class="toggle-label" aria-hidden="true"><span class="toggle-knob"></span></span>
              <span class="toggle-text">Ohne Druckdatum</span>
            </label>
            <label class="toggle-row">
              <input v-model="vorschauAktiv" class="toggle-input" type="checkbox" />
              <span class="toggle-label" aria-hidden="true"><span class="toggle-knob"></span></span>
              <span class="toggle-text">Vorschau</span>
            </label>
          </div>
          <button
            class="primary"
            type="button"
            :disabled="erzeugtTabletVertraege || leihvertraegeSammeldruckAuswahl.length === 0"
            @click="druckeMarkierteTabletvertraege"
          >
            {{ erzeugtTabletVertraege ? "PDF wird erzeugt..." : "Leihvertrag als PDF erzeugen" }}
          </button>
        </div>

        <div v-if="gefilterteLeihvertraegeSammeldruckEintraege.length === 0" class="empty-state">
          Aktuell gibt es keine aktiven Tablet-Ausleihen von Schuelern.
        </div>
        <div v-else class="ausgabebeleg-tabellen">
          <section class="ausgabebeleg-tabelle-block">
            <header class="ausgabebeleg-tabellenkopf">
              <h3>Tablet-Ausleihen</h3>
              <span>{{ gefilterteLeihvertraegeSammeldruckEintraege.length }} Eintraege</span>
            </header>

            <p v-if="tabletVertraegeFehler" class="error-banner">{{ tabletVertraegeFehler }}</p>

            <div class="ausgabebeleg-table-wrap">
              <table class="ausgabebeleg-tabelle">
                <thead>
                  <tr>
                    <th>Markieren</th>
                    <th>Klasse</th>
                    <th>Name</th>
                    <th>Vorname</th>
                    <th>Artikel</th>
                    <th>Druckdatum</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="eintrag in gefilterteLeihvertraegeSammeldruckEintraege" :key="eintrag.id">
                    <td>
                      <input
                        type="checkbox"
                        :checked="leihvertraegeSammeldruckAuswahl.includes(eintrag.id)"
                        @change="toggleLeihvertragSammeldruckAuswahl(eintrag.id)"
                      />
                    </td>
                    <td>{{ eintrag.klasse }}</td>
                    <td>{{ eintrag.name }}</td>
                    <td>{{ eintrag.vorname }}</td>
                    <td>
                      <p v-for="artikel in eintrag.tablet_artikel" :key="`${eintrag.id}-${artikel}`" style="margin: 0;">
                        {{ artikel }}
                      </p>
                      <p
                        v-for="artikel in eintrag.tablet_zubehoer_artikel"
                        :key="`${eintrag.id}-z-${artikel}`"
                        style="margin: 0;"
                      >
                        {{ artikel }}
                      </p>
                    </td>
                    <td>{{ eintrag.erzeugungsdatum }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </div>
      </template>

      <template v-else>
        <header class="einstellungen-detail-head">
          <div>
            <p class="eyebrow">{{ aktiverDruckBereichMeta.label }}</p>
            <h2>{{ aktiverDruckBereichMeta.label }}</h2>
            <p class="subtle">Dieser Druckbereich ist vorgemerkt und kann als naechstes inhaltlich ausgearbeitet werden.</p>
          </div>
        </header>

        <article class="json-block">
          <strong>{{ aktiverDruckBereichMeta.label }}</strong>
          <p style="margin: 10px 0 0;">
            Fuer diesen Bereich ist das Layout im Menue bereits vorbereitet. Die konkrete Druckvorlage ist aktuell noch nicht hinterlegt.
          </p>
        </article>
      </template>
    </section>
  </section>
</template>
