<script setup>
import { computed, onMounted, ref } from "vue";

const props = defineProps({
  apiRequest: { type: Function, required: true }
});

const laedt = ref(true);
const speichert = ref(false);
const speichertFormatierung = ref(false);
const fehler = ref("");
const erfolg = ref("");
const vorlagen = ref([]);
const ausgewaehlterTyp = ref("tablet");
const ausgewaehlteVorlageId = ref(null);
const formular = ref({
  typ: "tablet",
  name: "",
  briefkopf_pfad: "",
  briefkopf_upload: "",
  briefkopf_vorschau_url: "",
  seitenrand_oben_mm: 14,
  seitenrand_rechts_mm: 12,
  seitenrand_unten_mm: 18,
  seitenrand_links_mm: 12,
  sections: []
});

const vorlagenDesTyps = computed(() =>
  vorlagen.value.filter((eintrag) => eintrag.typ === ausgewaehlterTyp.value)
);

const aktiveVorlage = computed(
  () => vorlagenDesTyps.value.find((eintrag) => eintrag.aktiv) || vorlagenDesTyps.value[0] || null
);

const ausgewaehlteVorlage = computed(
  () => vorlagen.value.find((eintrag) => eintrag.v_vorlage_id === ausgewaehlteVorlageId.value) || null
);

function setzeFormular(vorlage) {
  if (!vorlage) {
      formular.value = {
        typ: ausgewaehlterTyp.value,
        name: `Leihvertrag ${ausgewaehlterTyp.value.toUpperCase()}`,
        briefkopf_pfad: "",
        briefkopf_upload: "",
        briefkopf_vorschau_url: "",
        seitenrand_oben_mm: 14,
        seitenrand_rechts_mm: 12,
        seitenrand_unten_mm: 18,
        seitenrand_links_mm: 12,
        sections: []
      };
    ausgewaehlteVorlageId.value = null;
    return;
  }

  ausgewaehlteVorlageId.value = vorlage.v_vorlage_id;
  formular.value = {
    typ: vorlage.typ,
    name: vorlage.name,
    briefkopf_pfad: vorlage.briefkopf_pfad || "",
    briefkopf_upload: "",
    briefkopf_vorschau_url: vorlage.briefkopf_preview_url || "",
    seitenrand_oben_mm: Number(vorlage.seitenrand_oben_mm ?? 14),
    seitenrand_rechts_mm: Number(vorlage.seitenrand_rechts_mm ?? 12),
    seitenrand_unten_mm: Number(vorlage.seitenrand_unten_mm ?? 18),
    seitenrand_links_mm: Number(vorlage.seitenrand_links_mm ?? 12),
    sections: vorlage.sections.map((section) => ({
      titel: section.titel,
      abschnitt_art: section.abschnitt_art,
      sortier_nr: section.sortier_nr,
      html_inhalt: section.html_inhalt
    }))
  };
}

async function ladeVorlagen(bevorzugteVorlageId = null) {
  laedt.value = true;
  fehler.value = "";

  try {
    const response = await props.apiRequest("/vertragsvorlagen");
    vorlagen.value = response;
    if (!vorlagenDesTyps.value.length && response.length > 0) {
      ausgewaehlterTyp.value = response[0].typ;
    }
    const bevorzugteVorlage = bevorzugteVorlageId
      ? response.find((eintrag) => eintrag.v_vorlage_id === bevorzugteVorlageId)
      : null;
    setzeFormular(bevorzugteVorlage || aktiveVorlage.value);
  } catch (error) {
    fehler.value = error.message;
  } finally {
    laedt.value = false;
  }
}

function wechsleTyp(typ) {
  ausgewaehlterTyp.value = typ;
  setzeFormular(vorlagen.value.find((eintrag) => eintrag.typ === typ && eintrag.aktiv) || vorlagen.value.find((eintrag) => eintrag.typ === typ) || null);
  erfolg.value = "";
  fehler.value = "";
}

function fuegeAbschnittHinzu() {
  formular.value.sections.push({
    titel: `Neuer Abschnitt ${formular.value.sections.length + 1}`,
    abschnitt_art: "rechtstext",
    sortier_nr: formular.value.sections.length + 1,
    html_inhalt: "<p>Bitte Rechtstext ergaenzen.</p>"
  });
}

async function briefkopfDateiAuswaehlen(event) {
  const datei = event.target.files?.[0];

  if (!datei) {
    return;
  }

  if (datei.type !== "image/png") {
    fehler.value = "Bitte eine PNG-Datei fuer den Briefkopf auswaehlen.";
    event.target.value = "";
    return;
  }

  if (datei.size > 2.5 * 1024 * 1024) {
    fehler.value = "Der Briefkopf ist zu gross (max. 2,5 MB).";
    event.target.value = "";
    return;
  }

  fehler.value = "";

  try {
    const datenUrl = await new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(String(reader.result || ""));
      reader.onerror = () => reject(new Error("PNG-Datei konnte nicht gelesen werden."));
      reader.readAsDataURL(datei);
    });

    formular.value.briefkopf_upload = datenUrl;
    formular.value.briefkopf_vorschau_url = datenUrl;
  } catch (error) {
    fehler.value = error.message;
  } finally {
    event.target.value = "";
  }
}

function entferneBriefkopf() {
  formular.value.briefkopf_pfad = "";
  formular.value.briefkopf_upload = "";
  formular.value.briefkopf_vorschau_url = "";
}

function buildPayload() {
  return {
    typ: formular.value.typ,
    name: formular.value.name,
    briefkopf_pfad: formular.value.briefkopf_pfad,
    briefkopf_upload: formular.value.briefkopf_upload,
    seitenrand_oben_mm: formular.value.seitenrand_oben_mm,
    seitenrand_rechts_mm: formular.value.seitenrand_rechts_mm,
    seitenrand_unten_mm: formular.value.seitenrand_unten_mm,
    seitenrand_links_mm: formular.value.seitenrand_links_mm,
    sections: formular.value.sections
  };
}

function entferneAbschnitt(index) {
  formular.value.sections.splice(index, 1);
  formular.value.sections = formular.value.sections.map((section, sectionIndex) => ({
    ...section,
    sortier_nr: sectionIndex + 1
  }));
}

async function speichereNeueVersion() {
  if (!formular.value.sections.length) {
    fehler.value = "Bitte mindestens einen Rechtstext-Abschnitt pflegen.";
    return;
  }

  speichert.value = true;
  fehler.value = "";
  erfolg.value = "";
  const zielTyp = formular.value.typ;

  try {
    const response = await props.apiRequest("/vertragsvorlagen", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(buildPayload())
    });

    erfolg.value = response.meldung;
    ausgewaehlterTyp.value = zielTyp;
    await ladeVorlagen(response.vorlage?.v_vorlage_id || null);
  } catch (error) {
    fehler.value = error.message;
  } finally {
    speichert.value = false;
  }
}

async function speichereFormatierung() {
  if (!ausgewaehlteVorlageId.value) {
    fehler.value = "Bitte zuerst eine vorhandene Vertragsvorlage auswaehlen.";
    return;
  }

  if (!formular.value.sections.length) {
    fehler.value = "Bitte mindestens einen Rechtstext-Abschnitt pflegen.";
    return;
  }

  speichertFormatierung.value = true;
  fehler.value = "";
  erfolg.value = "";
  const zielTyp = formular.value.typ;

  try {
    const response = await props.apiRequest(`/vertragsvorlagen/${ausgewaehlteVorlageId.value}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(buildPayload())
    });

    erfolg.value = response.meldung;
    ausgewaehlterTyp.value = zielTyp;
    await ladeVorlagen(response.vorlage?.v_vorlage_id || ausgewaehlteVorlageId.value);
  } catch (error) {
    fehler.value = error.message;
  } finally {
    speichertFormatierung.value = false;
  }
}

onMounted(() => {
  ladeVorlagen().catch(() => {});
});
</script>

<template>
  <div class="vertragsvorlagen-stack">
    <header class="einstellungen-detail-head">
      <div>
        <p class="eyebrow">Vertragsvorlagen</p>
        <h2>Versionierte Rechtstexte</h2>
        <p class="subtle">Formatierungs-Aenderungen koennen direkt gespeichert werden. Inhaltliche neue Stufen lassen sich weiterhin als neue aktive Version ablegen. Layout und PDF-Technik bleiben im Backend fest hinterlegt.</p>
      </div>
    </header>

    <p v-if="fehler" class="feedback error">{{ fehler }}</p>
    <p v-if="erfolg" class="feedback success">{{ erfolg }}</p>

    <div v-if="laedt" class="empty-state">Vertragsvorlagen werden geladen...</div>
    <template v-else>
      <article class="einstellungen-card">
        <div class="template-type-row">
          <button
            v-for="typ in ['tablet', 'laptop', 'wlan']"
            :key="typ"
            type="button"
            :class="['segmented-control-button', ausgewaehlterTyp === typ ? 'is-active' : '']"
            @click="wechsleTyp(typ)"
          >
            {{ typ }}
          </button>
        </div>
      </article>

      <section class="template-admin-layout">
        <aside class="einstellungen-records">
          <div class="einstellungen-records-head">
            <strong>{{ vorlagenDesTyps.length }} Versionen</strong>
            <span class="subtle">Historie</span>
          </div>

          <button
            v-for="vorlage in vorlagenDesTyps"
            :key="vorlage.v_vorlage_id"
            type="button"
            :class="['einstellungen-record', ausgewaehlteVorlageId === vorlage.v_vorlage_id ? 'is-active' : '']"
            @click="setzeFormular(vorlage)"
          >
            <span class="einstellungen-record-title">
              v{{ vorlage.version }} · {{ vorlage.name }}
            </span>
            <span class="einstellungen-record-copy">
              {{ vorlage.aktiv ? 'aktiv' : 'archiviert' }} · {{ vorlage.sections.length }} Abschnitte
            </span>
          </button>
        </aside>

        <div class="einstellungen-form-panel">
          <p v-if="ausgewaehlteVorlage && !ausgewaehlteVorlage.aktiv" class="feedback">
            Diese Vorlage ist archiviert. Neue PDFs verwenden nur die aktive Vorlage dieses Typs.
          </p>

          <div class="einstellungen-stack">
            <article class="einstellungen-card">
              <h3>Metadaten</h3>
              <div class="form-grid">
                <label class="field">
                  <span>Typ</span>
                  <select v-model="formular.typ">
                    <option value="tablet">tablet</option>
                    <option value="laptop">laptop</option>
                    <option value="wlan">wlan</option>
                  </select>
                </label>

                <label class="field field-wide">
                  <span>Name der Vorlage</span>
                  <input v-model="formular.name" type="text" />
                </label>

                <div class="field field-wide">
                  <span>Briefkopf Seite 1 (PNG)</span>
                  <div class="briefkopf-upload">
                    <input type="file" accept="image/png" @change="briefkopfDateiAuswaehlen" />
                    <button
                      v-if="formular.briefkopf_vorschau_url"
                      type="button"
                      class="ghost small-button"
                      @click="entferneBriefkopf"
                    >
                      Briefkopf entfernen
                    </button>
                  </div>
                  <p class="subtle">Das PNG wird direkt in der Vertragsvorlage gespeichert und nur auf der ersten PDF-Seite angezeigt.</p>
                  <div v-if="formular.briefkopf_vorschau_url" class="briefkopf-preview-box">
                    <img :src="formular.briefkopf_vorschau_url" alt="Briefkopf Vorschau" class="briefkopf-preview-image" />
                  </div>
                </div>

                <div class="field field-wide">
                  <span>Seitenraender PDF (mm)</span>
                  <div class="seitenrand-grid">
                    <label class="field">
                      <span>Oben</span>
                      <input v-model.number="formular.seitenrand_oben_mm" type="number" min="0" max="50" step="0.5" />
                    </label>
                    <label class="field">
                      <span>Rechts</span>
                      <input v-model.number="formular.seitenrand_rechts_mm" type="number" min="0" max="50" step="0.5" />
                    </label>
                    <label class="field">
                      <span>Unten</span>
                      <input v-model.number="formular.seitenrand_unten_mm" type="number" min="0" max="50" step="0.5" />
                    </label>
                    <label class="field">
                      <span>Links</span>
                      <input v-model.number="formular.seitenrand_links_mm" type="number" min="0" max="50" step="0.5" />
                    </label>
                  </div>
                  <p class="subtle">Diese Werte steuern die PDF-Raender der Vorlage. Der untere Rand sollte wegen der Fusszeile nicht zu klein werden.</p>
                </div>
              </div>
            </article>

            <article
              v-for="(abschnitt, index) in formular.sections"
              :key="`${formular.typ}-${index}`"
              class="einstellungen-card"
            >
              <div class="section-toolbar">
                <h3>Abschnitt {{ index + 1 }}</h3>
                <button type="button" class="ghost small-button" @click="entferneAbschnitt(index)">Entfernen</button>
              </div>

              <div class="form-grid">
                <label class="field">
                  <span>Titel</span>
                  <input v-model="abschnitt.titel" type="text" />
                </label>

                <label class="field">
                  <span>Abschnittsart</span>
                  <input v-model="abschnitt.abschnitt_art" type="text" />
                </label>

                <label class="field field-wide">
                  <span>HTML-Inhalt</span>
                  <textarea v-model="abschnitt.html_inhalt" rows="9"></textarea>
                </label>
              </div>
            </article>
          </div>

          <div class="button-row">
            <button class="ghost" @click="fuegeAbschnittHinzu">Abschnitt hinzufuegen</button>
            <button class="secondary" :disabled="speichert || speichertFormatierung" @click="speichereFormatierung">
              {{ speichertFormatierung ? "Speichert..." : "Formatierung speichern" }}
            </button>
            <button class="primary" :disabled="speichert || speichertFormatierung" @click="speichereNeueVersion">
              {{ speichert ? "Speichert..." : "Neue Version speichern" }}
            </button>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.vertragsvorlagen-stack {
  display: grid;
  gap: 18px;
}

.template-type-row {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.template-admin-layout {
  display: grid;
  grid-template-columns: minmax(240px, 310px) minmax(0, 1fr);
  gap: 20px;
}

.section-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.briefkopf-upload {
  display: flex;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.briefkopf-preview-box {
  margin-top: 10px;
  padding: 12px;
  border: 1px solid var(--border-color, #d6d9e0);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.85);
}

.briefkopf-preview-image {
  display: block;
  width: 100%;
  max-height: 180px;
  object-fit: contain;
  object-position: left top;
}

.seitenrand-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

@media (max-width: 1100px) {
  .template-admin-layout {
    grid-template-columns: 1fr;
  }

  .seitenrand-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
