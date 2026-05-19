<script setup>
import KlassensatzModule from "../components/KlassensatzModule.vue";
import NeueAusleiheModule from "../components/NeueAusleiheModule.vue";
import RueckgabeModule from "../components/RueckgabeModule.vue";

defineProps({
  ausleiheForm: { type: Object, required: true },
  ausleiheManuelleExemplarEingabe: { type: String, required: true },
  ausleiheScanExemplarEingabe: { type: String, required: true },
  standardfristText: { type: Function, required: true },
  rueckgabeForm: { type: Object, required: true },
  verlaengerungForm: { type: Object, required: true },
  formatDatum: { type: Function, required: true },
  klassensatzForm: { type: Object, required: true },
  klassensatzGruppen: { type: Array, required: true },
  istKlassensatzGruppeAusgewaehlt: { type: Function, required: true },
  scanBereitZurAusleihe: { type: Boolean, required: true },
  scanDialog: { type: Object, required: true }
});

const emit = defineEmits([
  "update:ausleihe-manuelle-exemplar-eingabe",
  "update:ausleihe-scan-exemplar-eingabe",
  "suche-manuell",
  "scan-uebernehmen",
  "ausleihe-speichern",
  "rueckgabe-speichern",
  "verlaengerung-speichern",
  "toggle-klassensatz-gruppe",
  "klassensatz-speichern"
]);
</script>

<template>
  <section class="arbeitsflaeche">
    <NeueAusleiheModule
      :ausleihe-form="ausleiheForm"
      :ausleihe-manuelle-exemplar-eingabe="ausleiheManuelleExemplarEingabe"
      :ausleihe-scan-exemplar-eingabe="ausleiheScanExemplarEingabe"
      :standardfrist-text="standardfristText"
      @update:ausleiheManuelleExemplarEingabe="emit('update:ausleihe-manuelle-exemplar-eingabe', $event)"
      @update:ausleiheScanExemplarEingabe="emit('update:ausleihe-scan-exemplar-eingabe', $event)"
      @suche-manuell="emit('suche-manuell')"
      @scan-uebernehmen="emit('scan-uebernehmen')"
      @speichern="emit('ausleihe-speichern')"
    />

    <RueckgabeModule
      :rueckgabe-form="rueckgabeForm"
      :verlaengerung-form="verlaengerungForm"
      :format-datum="formatDatum"
      @speichern="emit('rueckgabe-speichern')"
      @verlaengerung-speichern="emit('verlaengerung-speichern')"
    />
  </section>

  <KlassensatzModule
    :klassensatz-form="klassensatzForm"
    :klassensatz-gruppen="klassensatzGruppen"
    :standardfrist-text="standardfristText"
    :ist-klassensatz-gruppe-ausgewaehlt="istKlassensatzGruppeAusgewaehlt"
    :scan-bereit-zur-ausleihe="scanBereitZurAusleihe"
    :scan-dialog="scanDialog"
    @toggle-gruppe="emit('toggle-klassensatz-gruppe', $event)"
    @speichern="emit('klassensatz-speichern')"
  />
</template>
