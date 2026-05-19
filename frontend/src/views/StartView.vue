<script setup>
import StartModule from "../components/StartModule.vue";

defineProps({
  scannerGeraetLabel: { type: String, required: true },
  manuelleCodeEingabe: { type: String, required: true },
  scannerStatus: { type: String, required: true },
  scanResult: { type: String, required: true },
  scanType: { type: String, required: true },
  lastError: { type: String, required: true },
  scanDialog: { type: Object, required: true },
  scanBereitZurAusleihe: { type: Boolean, required: true },
  scanBereitZurRueckgabe: { type: Boolean, required: true },
  scanDialogHinweis: { type: String, required: true },
  scanOffeneAusleihenDesAusleihers: { type: Array, required: true },
  markierteScanAusleihen: { type: Array, required: true },
  startAusleiheGeoeffnet: { type: Boolean, required: true },
  startRueckgabeGeoeffnet: { type: Boolean, required: true },
  startVerlaengerungGeoeffnet: { type: Boolean, required: true },
  ausleiheForm: { type: Object, required: true },
  rueckgabeForm: { type: Object, required: true },
  verlaengerungForm: { type: Object, required: true },
  scanOffeneAusleiheZurRueckgabe: { type: Object, required: false, default: null },
  lehrkraftAusleiher: { type: Array, required: true },
  schuelerAusleiher: { type: Array, required: true },
  klassenAusleiher: { type: Array, required: true },
  standardfristText: { type: Function, required: true },
  formatDatum: { type: Function, required: true },
  ausleiherDetailText: { type: Function, required: true },
  istAusleiheUeberfaellig: { type: Function, required: true },
  tageUeberfaellig: { type: Function, required: true },
  exemplarHatWarnstatus: { type: Function, required: true },
  exemplarWarntext: { type: Function, required: true }
});

const emit = defineEmits([
  "update:manuelle-code-eingabe",
  "update:markierte-scan-ausleihen",
  "manuelle-pruefung",
  "scan-bestaetigen",
  "ausleihe-starten",
  "ausleihe-abbrechen",
  "scan-rueckgabe",
  "scan-verlaengern",
  "rueckgabe-buchen",
  "rueckgabe-abbrechen",
  "verlaengerung-speichern",
  "verlaengerung-abbrechen",
  "scan-zuruecksetzen"
]);
</script>

<template>
  <StartModule
    :scanner-geraet-label="scannerGeraetLabel"
    :manuelle-code-eingabe="manuelleCodeEingabe"
    :scanner-status="scannerStatus"
    :scan-result="scanResult"
    :scan-type="scanType"
    :last-error="lastError"
    :scan-dialog="scanDialog"
    :scan-bereit-zur-ausleihe="scanBereitZurAusleihe"
    :scan-bereit-zur-rueckgabe="scanBereitZurRueckgabe"
    :scan-dialog-hinweis="scanDialogHinweis"
    :scan-offene-ausleihen-des-ausleihers="scanOffeneAusleihenDesAusleihers"
    :markierte-scan-ausleihen="markierteScanAusleihen"
    :start-ausleihe-geoeffnet="startAusleiheGeoeffnet"
    :start-rueckgabe-geoeffnet="startRueckgabeGeoeffnet"
    :start-verlaengerung-geoeffnet="startVerlaengerungGeoeffnet"
    :ausleihe-form="ausleiheForm"
    :rueckgabe-form="rueckgabeForm"
    :verlaengerung-form="verlaengerungForm"
    :scan-offene-ausleihe-zur-rueckgabe="scanOffeneAusleiheZurRueckgabe"
    :lehrkraft-ausleiher="lehrkraftAusleiher"
    :schueler-ausleiher="schuelerAusleiher"
    :klassen-ausleiher="klassenAusleiher"
    :standardfrist-text="standardfristText"
    :format-datum="formatDatum"
    :ausleiher-detail-text="ausleiherDetailText"
    :ist-ausleihe-ueberfaellig="istAusleiheUeberfaellig"
    :tage-ueberfaellig="tageUeberfaellig"
    :exemplar-hat-warnstatus="exemplarHatWarnstatus"
    :exemplar-warntext="exemplarWarntext"
    @update:manuelle-code-eingabe="emit('update:manuelle-code-eingabe', $event)"
    @update:markierte-scan-ausleihen="emit('update:markierte-scan-ausleihen', $event)"
    @manuelle-pruefung="emit('manuelle-pruefung')"
    @scan-bestaetigen="emit('scan-bestaetigen')"
    @ausleihe-starten="emit('ausleihe-starten')"
    @ausleihe-abbrechen="emit('ausleihe-abbrechen')"
    @scan-rueckgabe="emit('scan-rueckgabe')"
    @scan-verlaengern="emit('scan-verlaengern')"
    @rueckgabe-buchen="emit('rueckgabe-buchen')"
    @rueckgabe-abbrechen="emit('rueckgabe-abbrechen')"
    @verlaengerung-speichern="emit('verlaengerung-speichern')"
    @verlaengerung-abbrechen="emit('verlaengerung-abbrechen')"
    @scan-zuruecksetzen="emit('scan-zuruecksetzen')"
  />
</template>
