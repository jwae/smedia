import { createRouter, createWebHistory } from 'vue-router'
import StartView from './views/StartView.vue'
import BuchungView from './views/BuchungView.vue'
import MedienverwaltungView from './views/MedienverwaltungView.vue'
import ObjekteView from './views/ObjekteView.vue'
import SchadenView from './views/SchadenView.vue'
import HistorieView from './views/HistorieView.vue'
import DruckView from './views/DruckView.vue'
import TagesfokusView from './views/TagesfokusView.vue'
import EinstellungenView from './views/EinstellungenView.vue'
import DbView from './views/DbView.vue'

const routes = [
  { path: '/', redirect: '/start' },
  { path: '/start', name: 'start', component: StartView },
  { path: '/manuelle-buchung', name: 'manuelle-buchung', component: BuchungView },
  { path: '/buecher', name: 'buecher', component: MedienverwaltungView },
  { path: '/objekte', name: 'objekte', component: ObjekteView },
  { path: '/rueckgabe', name: 'rueckgabe', component: ObjekteView },
  { path: '/schaden', name: 'schaden', component: SchadenView },
  { path: '/historie', name: 'historie', component: HistorieView },
  { path: '/druck', name: 'druck', component: DruckView },
  { path: '/tagesfokus', name: 'tagesfokus', component: TagesfokusView },
  { path: '/einstellungen', name: 'einstellungen', component: EinstellungenView },
  { path: '/db', name: 'db', component: DbView }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
