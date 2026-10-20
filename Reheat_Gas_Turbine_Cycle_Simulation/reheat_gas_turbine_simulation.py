# Tämä koodi laskee kaasuturbiinilaitoksen tarkat ominaisentalpiat ja kompressorin sekä turbiinin tehon valitulle ilman massavirralle. Lähtöarvoina on luennon esimerkki, jolle laskimme luennolla 53 % hyötysuhteen.
# Koodin tarkoituksena on suorittaa laskut tarkemmin hyödyntämällä NASA-polynomeilla laskettuja ominaisentalpioita. Aja koodi ja vertaile tuloksia luennon 5 esimerkkiin.


# Ensin tuodaan cantera paketti koodiin
import cantera as ct

# tuodaan numpy koodiin. Tätä kirjastoa käytetään usein matriisien ja listojen käsittelemisessä
import numpy as np

# määritellään kemiallinen mekanismi
mekanismi = 'chem.yaml'

# Määritellään paine ja lämpötila ennen kompressoria.
T_kompressoriin = 293.15
paine = 100000

# Ilman massavirta kompressoriin kg/s
ilman_massavirta = 10

# Kompressorin isentrooppinen hyötysuhde
eta_ic = 0.9


def laske(valipaine):

    # Ensin luodaan olio gas1, joka edustaa kompressorissa olevaa ilmaa. Tämä olio sisältää nyt kemiallisen
    # mekanismin ensimmäisenä listatun molekyylin tai atomin (tässä tapauksessa argon).
    gas1 = ct.Solution(mekanismi)

    # Seuraavalla komennolla vaihdetaan gas1 olion tila ja koostumus ilmaksi, joka kulkee kompressorin läpi.
    # Ilma on koostumukseltaan 79 mol-% typpeä ja 21 mol-% happea. Muutetaan koostumus ja tila kommennolla "olion_nimi.TPX", jossa T viittaa kaasun
    # lämpötilaan, P paineeseen ja X mooliperusteiseen koostumukseen. Cantera laskee NASA-polynomeilla uudet arvot esim. suureille gas1.s (ominaisentropia) ja
    # gas1.h (ominaisentalpia).

    gas1.TPX = T_kompressoriin, paine, 'O2:0.21, N2:0.79'
    entalpia_kompressoriin = gas1.h


    # Tulostetaan olion sisältö terminaaliin
    print('Ilman tila ennen kompressoria')
    gas1()


    # Määritetään paine kompressorin ulostulolle, eli sama paine missä kaasu tulee turbiiniin. Käytämme samaa kuin luennolla 5 esimerkissä, eli 22 bar
    p_turbiiniin = 2200000
    välilämmitinpaine = valipaine

    # Olio gas.1 sisältää nyt kompressorin sisääntulon tilan suureet, mukaan lukien ominaisentropia. Seuraavaksi selvitetään isentrooppisen puristuksen lopputila
    # Eli pidetään ominaisentropian vakiona, mutta päivitetään paineen ulostulon arvoon (22 bar)
    gas1.SP = gas1.s, p_turbiiniin


    # Tulostetaan olio, joka nyt sisältää isentrooppisesti lasketun tilan
    print('Ilman tila isentrooppisen puristuksen jälkeen')
    gas1()


    # Lasketaan irreversiibelin kompressorin jälkeinen ominaisentalpia. gas1.h sisältää nyt isentrooppisen prosessin lopputilan ominaisentalpian ilmalle
    entalpia_kompressorin_jalkeen = entalpia_kompressoriin + (gas1.h - entalpia_kompressoriin) / eta_ic


    # päivitetään olio irreversiibelin kompressorin ulostulon ominaisentalpialla (paine on sama kuin isentrooppisen prosessin lopussa)
    gas1.HP = entalpia_kompressorin_jalkeen, p_turbiiniin


    # Haetaan irreversiibelin kompressorin ulostulon lämpötila päivitetystä oliosta
    T_kompressorin_jalkeen = gas1.T

    # Tulostetaan olio uudestaan, jotta nähdään ero reversiibelin ja irreversiibelin puristuksen välillä terminaalissa
    print('Ilman tila irreversiibelin puristuksen jälkeen')
    gas1()

    # Siirrytään seuraavaksi polttimen energiataseeseen
    # Määritetään ensin turbiinin sisääntulolämpötila (eli pakokaasujen lämpötila polttimen jälkeen)
    T_turbiiniin = 1973.15

    # Seuraavaksi laskemme lambda-arvo. Jos poltetaan metaania (josta maakaasu
    # enimmäkseen koostuu) saadaan energiatase, joka perustuu metaanin palamisreaktion
    # reaktioyhtälön kertoimiin ja mooliperusteisiin ominaisentalpioihin

    # 1 CH4 + lambda*2 O2 + lambda*2*3.76 N2 => CO2 + 2 H2O + (lambda-1)*2 O2 + lambda*2*3.76 N2

    # Polttimen energiatase:
    # 1 * h(CH4, 298.15 K) + lambda * 2* h(O2, kompressorin ulostulo) + lambda*2*3,76*h(N2, kompressorin ulostulo)
    # = lambda*2*3,76*h(N2, turbiinin sisääntulo) + (lambda-1)*2*h(O2, turbiinin sisääntulo) + 1*h(CO2, turbiinin sisääntulo) + 2*h(H2O, turbiinin sisääntulo)

    # Tästä yhtälöstä ratkaistaan lambda:
    # lambda=(1 h(CH4,298.15 K)+2*h(O2, turbiinin sisääntulo)-1*h(CO2, turbiinin sisääntulo) - 2*h(H2O, turbiinin sisääntulo))
    # /(2*3,76*h(N2, turbiinin sisääntulo)+2*h(O2, turbiinin sisääntulo)-2* h(O2, kompressorin ulostulo)-2*3,76*h(N2, kompressorin ulostulo))


    # Lasketaan jokaisen energiataseen molekyylin mooliperusteiset ominaisentalpiat Nasa-polynomeilla.
    # Kompressorista polttimelle tulevalle ilmalle ja polttimesta turbiiniin poistuville pakokaasumolekyyleille tiedämme jo lämpötilat ja paineet, mutta metaanin lämpötila on vielä määrittämättä.
    polttoaineen_lampotila = 298.15

    # Luomme jokaiselle energiataseen komponentille omat oliot, joihin syötämme sen lämpötilan, paineen ja koostumuksen. Cantera laskee ominaisentalpiat energiatasetta varten


    # Metaani ruiskutetaan polttokammioon huoneenlämpötilassa
    gas_ch4 = ct.Solution(mekanismi)
    gas_ch4.TPX = polttoaineen_lampotila, p_turbiiniin, 'CH4:1'

    # Happi kompressorista saapuu äsken määritellyssä irreversiibelin kompressorin ulostulon lämpötilassa
    gas_o2_kompressorista = ct.Solution(mekanismi)
    gas_o2_kompressorista.TPX = T_kompressorin_jalkeen, p_turbiiniin, 'O2:1'

    # Typpi kompressorista saapuu samassa lämpötilassa kuin happikin
    gas_N2_kompressorista = ct.Solution(mekanismi)
    gas_N2_kompressorista.TPX = T_kompressorin_jalkeen, p_turbiiniin, 'N2:1'

    # Typpi siirtyy polttokammiosta turbiiiniin äsken määritellyssä (1973.15 K) lämpötilassa
    gas_N2_turbiiniin = ct.Solution(mekanismi)
    gas_N2_turbiiniin.TPX = T_turbiiniin, p_turbiiniin, 'N2:1'

    # Happi polttimesta turbiiiniin
    gas_o2_turbiiniin = ct.Solution(mekanismi)
    gas_o2_turbiiniin.TPX = T_turbiiniin, p_turbiiniin, 'O2:1'

    # Hiilidioksiidi polttimesta turbiiniin
    gas_CO2_turbiiniin = ct.Solution(mekanismi)
    gas_CO2_turbiiniin.TPX = T_turbiiniin, p_turbiiniin, 'CO2:1'

    # Vesihöyry polttimesta turbiiniin
    gas_H2O_turbiiniin = ct.Solution(mekanismi)
    gas_H2O_turbiiniin.TPX = T_turbiiniin, p_turbiiniin, 'H2O:1'

    # Kun kaikki komponentit on määritelty oliohin, voidaan ratkaista lambda yllä määritellyllä energiataseen yhtälöllä. Jokaisen termin ominaisentalpia saadaan komennolla "olion_nimi.enthalpy_mole"


    lambd = (
            (
                        gas_ch4.enthalpy_mole + 2 * gas_o2_turbiiniin.enthalpy_mole - gas_CO2_turbiiniin.enthalpy_mole - 2 * gas_H2O_turbiiniin.enthalpy_mole) /
            (
                        2 * 3.76 * gas_N2_turbiiniin.enthalpy_mole + 2 * gas_o2_turbiiniin.enthalpy_mole - 2 * gas_o2_kompressorista.enthalpy_mole - 2 * 3.76 * gas_N2_kompressorista.enthalpy_mole)
    )

    # Nyt tiedämme palamisen lambda-arvo, eli voidaan määritellä turbiiniin saapuvan pakokaasun koostumus reaktioyhtälön mukaisesti
    # Seuraavaksi lasketaan turbiinin läpi kulkeville pakokaasuille ulostulolämpötila.

    # Luodaan taas yksi olio, johon syötetään  pakokaasujen lämpötila, paine, ja molekyylien ainemäärien suhteet reaktioyhtälön mukaisesti
    gas2 = ct.Solution(mekanismi)
    koostumus_turbiiniin = 'N2:{},O2:{},H2O:{},CO2:{}'.format(lambd * 2 * 3.76, (lambd - 1) * 2, 2, 1)
    gas2.TPX = T_turbiiniin, p_turbiiniin, koostumus_turbiiniin



    # Oliossa gas2 on nyt turbiinin sisääntulon tila, joten voidaan selvittää pakokaasun ominaisentalpia
    entalpia_turbiiniin = gas2.h
    # Tulostetaan olion sisältö terminaaliin
    print('Kaasun tila turbiinin sisääntulossa')
    gas2()



    # Seuraavaksi päivitämme turbiinin olion tila käyttämällä sisääntulevan pakokaasun ominaisentropiaa
    # (eli selvitetään isentrooppisen paisunnan lopputila). Syötämme ominaisentropian ja turbiinin ulostulon paineen (joka on sama kuin ennen kompressoria)
    gas2.SP = gas2.s, välilämmitinpaine

    # Tulostetaan olio, joka nyt sisältää isentrooppisesti lasketun paisunnan lopputilan
    print('Kaasun tila isentrooppisen paisunnan jälkeen')
    gas2()

    # Turbiinin isentrooppinen hyötysuhde
    eta_it = 0.9

    # Määritellään irreversiibelin turbiinin jälkeinen ominaisentalpia ottaen huomioon isentrooppinen hyötysuhde.
    # gas2.h sisältää nyt isentrooppisen turbiinin jälkeisen pakokaasun ominaisentalpian

    entalpia_turbiinin_jalkeen = entalpia_turbiiniin - (entalpia_turbiiniin - gas2.h) * eta_it

    # Päivitetään olion tila juuri laskettuun irreversiibelin prosessin lopputilan ominaisentalpiaan.
    gas2.HP = entalpia_turbiinin_jalkeen, välilämmitinpaine

    # Haetaan irreversiibelin turbiinin ulostulon lämpötila päivitetystä oliosta
    T_turbiinin_jalkeen = gas2.T
    # Tulostetaan olio uudestaan, jotta nähdään ero reversiibelin ja irreversiibelin turbiinin välillä
    print('Kaasun tila irreversiibelin paisunnan jälkeen')
    gas2()



    #### Lasketaan tilapisteiden kokonaisentalpiat per kilomooli polttokammioon syötettyä metaania, jotta voidaan laskea myöhemmin hyötysuhde ja turbiinin teho

    # Luomme tätä varten oliot kompressoriin tulevalle hapelle ja typelle ja määritämme lämpötilan sekä paineen
    gas_o2_kompressoriin = ct.Solution(mekanismi)
    gas_o2_kompressoriin.TPX = T_kompressoriin, paine, 'O2:1'



    gas_N2_kompressoriin = ct.Solution(mekanismi)
    gas_N2_kompressoriin.TPX = T_kompressoriin, paine, 'N2:1'



    # Laskemme näillä kompressoriin tulevan kokonaisentalpia per kilomooli metaania polttokammiossa
    entalpia_kompressoriin_mol = lambd * 2 * gas_o2_kompressoriin.enthalpy_mole + lambd * 2 * 3.76 * gas_N2_kompressoriin.enthalpy_mole

    # kompressorista poistuville ilman molekyyleille luotiin jo oliot polttokammion energiatasetta varten. Lasketaan kokonaisentalpia per kilomooli metaania
    entalpia_kompressorista_ilman_CH4 = lambd * 2 * gas_o2_kompressorista.enthalpy_mole + lambd * 2 * 3.76 * gas_N2_kompressorista.enthalpy_mole

    # Turbiinille tuleva kokonaisentalpia per kilomooli metaania. Oliot luotiin polttokammion energiatasetta laskiessa.
    entalpia_turbiiniin_mol = (
            lambd * 2 * 3.76 * gas_N2_turbiiniin.enthalpy_mole + (lambd - 1) * 2 * gas_o2_turbiiniin.enthalpy_mole
            + 2 * gas_H2O_turbiiniin.enthalpy_mole + gas_CO2_turbiiniin.enthalpy_mole
    )

    # Tulostetaan vielä laskettu turbiinille saapuva kokonaisentalpia per kilomooli metaania
    print(
        f'Energiataseessa lasketun turbiinille saapuvan ilman ja metaanin kokonaisentalpia per kilomooli metaania: {entalpia_turbiiniin_mol:.1f} J/kmol CH4. Tämän pitäisi täsmätä polttokammioon saapuvan kokonaisentalpian kanssa')

    # Luodaan oliot pakokaasujen jokaiselle molekyylille turbiinin jälkeen (teimme jo aiemmin vastaavat oliot näille molekyyleille ennen turbiinia)
    # Syötämme jokaiseen olioon irreversiibelin turbiinin jälkeinen lämpötila ja paine

    gas_N2_turbiinista = ct.Solution(mekanismi)
    gas_N2_turbiinista.TPX = T_turbiinin_jalkeen, välilämmitinpaine, 'N2:1'



    gas_o2_turbiinista = ct.Solution(mekanismi)
    gas_o2_turbiinista.TPX = T_turbiinin_jalkeen, välilämmitinpaine, 'O2:1'



    gas_CO2_turbiinista = ct.Solution(mekanismi)
    gas_CO2_turbiinista.TPX = T_turbiinin_jalkeen, välilämmitinpaine, 'CO2:1'



    gas_H2O_turbiinista = ct.Solution(mekanismi)
    gas_H2O_turbiinista.TPX = T_turbiinin_jalkeen, välilämmitinpaine, 'H2O:1'

    # Lasketaan turbiinista poistuvan pakokaasun kokonaisentalpia per kilomooli metaania hyötysuhdelaskelmaa varten
    entalpia_turbiinista_mol = (
            lambd * 2 * 3.76 * gas_N2_turbiinista.enthalpy_mole + (lambd - 1) * 2 * gas_o2_turbiinista.enthalpy_mole
            + 2 * gas_H2O_turbiinista.enthalpy_mole + gas_CO2_turbiinista.enthalpy_mole)


    # Tarkistetaan, vielä, että laskut meni oikein. Polttokammiolle tulevan kaasuseoksen (metaani+happi+typpi) on oltava samassa kokonaisentalpiassa
    # kuin polttokammiosta poistuvat pakokaasut (typpi, hiilidioksiidi, vesihöyry ja ylijäämä happi)

    # Polttokammiolle tuleva kokonaisentalpia per kilomooli metaania
    entalpia_polttokammiolle = gas_ch4.enthalpy_mole + lambd * 2 * gas_o2_kompressorista.enthalpy_mole + lambd * 2 * 3.76 * gas_N2_kompressorista.enthalpy_mole
    print(
        f'Energiataseessa lasketun polttokammiolle saapuvan ilman ja metaanin kokonaisentalpia: {entalpia_polttokammiolle:.1f} J/kmol CH4')

    # lasketaan vielä polttoaineesta tuotu lämpö. Määritetään lämpö LHV:nä
    # LHV = stoikiometrisen palamisen reaktiotuotteiden kokonaisentalpia - lähtöaineiden kokonaisentalpia
    # HUOM! sekä lähtöaineet että reaktiotuotteet annetaan alla samoissa lämpötiloissa olioihin
    # --> LHV määritelmänä: miten paljon lämpöä saadaan palamisreaktiosta ulos, jos systeemi pidetään vakiolämpötilassa. Paineella ei ole väliä, koska ideaalikaasu

    gas_CO2_palamisesta = ct.Solution(mekanismi)
    gas_CO2_palamisesta.TPX = polttoaineen_lampotila, p_turbiiniin, 'CO2:1'

    gas_H2O_palamisesta = ct.Solution(mekanismi)
    gas_H2O_palamisesta.TPX = polttoaineen_lampotila, p_turbiiniin, 'H2O:1'

    gas_o2_palamisesta = ct.Solution(mekanismi)
    gas_o2_palamisesta.TPX = polttoaineen_lampotila, p_turbiiniin, 'O2:1'



    # lasketaan palamisesta saatava lämpö per kilomooli metaania --> Tästä tulee negatiivinen arvo koska eksotermisellä reaktiolla on negatiivinen reaktioentalpia
    lampo_polttoaineesta = gas_CO2_palamisesta.enthalpy_mole + 2 * gas_H2O_palamisesta.enthalpy_mole - gas_ch4.enthalpy_mole - 2 * gas_o2_palamisesta.enthalpy_mole


    #CO2 ja 2H2O menevät välilämmityksestä läpi reagoimatta palamisreaktiossa.

    #välilämmityksessä sisään menee: x * CH4 + (lambda-1) * 2 O2 + lambda * 2 * 3.76 N2 + CO2 + 2 H2O => 2 CO2 + 4 H2O + ((lambda-1)-1) * 2 O2 + lambda * 2 * 3.76 N2

    #Välilämmittimen energiatase
    # x * h(CH4, 298.15 K) + (lambda -1) * 2 *h(O2, turbiinin ulostulo) + lambda *  2 * 3.76 * h(N2, turbiinin ulostulo) + h(CO2, turbiinin ulostulo) + 2 * h(H2O, turbiinin ulostulo)
    # = lambda * 2 * 3.76 * h(N2, turbiinin sisääntulo) + (lambda-1-x) * 2 * h(O2, turbiinin sisääntulo) + (1+x) * h(CO2, turbiinin sisääntulo) + (2+2x)* h(H2O,turbiinin sisääntulo)


    #määritellään loput komponentit.

    gas_H2O_2turbiiniin = ct.Solution(mekanismi)
    gas_H2O_2turbiiniin.TPX = T_turbiiniin, välilämmitinpaine, 'H2O:1'

    gas_o2_2turbiiniin = ct.Solution(mekanismi)
    gas_o2_2turbiiniin.TPX = T_turbiiniin, välilämmitinpaine, 'O2:1'

    gas_CO2_2turbiiniin = ct.Solution(mekanismi)
    gas_CO2_2turbiiniin.TPX = T_turbiiniin, välilämmitinpaine, 'CO2:1'

    gas_ch4_2turbiiniin = ct.Solution(mekanismi)
    gas_ch4_2turbiiniin.TPX = polttoaineen_lampotila, välilämmitinpaine, 'CH4:1'

    gas_N2_2turbiiniin = ct.Solution(mekanismi)
    gas_N2_2turbiiniin.TPX = T_turbiiniin, välilämmitinpaine, 'N2:1'

    # ratkaistaan energiataseesta x ja saadaan:
    x = ((
         (lambd * 2 * 3.76 * (gas_N2_2turbiiniin.enthalpy_mole - gas_N2_turbiinista.enthalpy_mole))
        + (lambd-1) * 2 * (gas_o2_2turbiiniin.enthalpy_mole - gas_o2_turbiinista.enthalpy_mole)
         + (gas_CO2_2turbiiniin.enthalpy_mole - gas_CO2_turbiinista.enthalpy_mole)
         + 2 * (gas_H2O_2turbiiniin.enthalpy_mole - gas_H2O_turbiinista.enthalpy_mole)
             )/(
        gas_ch4_2turbiiniin.enthalpy_mole + 2 * gas_o2_2turbiiniin.enthalpy_mole - gas_CO2_2turbiiniin.enthalpy_mole - 2 * gas_H2O_2turbiiniin.enthalpy_mole
    ))

    #tässä lasketaan entalpia 2. turbiiniin per mooli
    # x * h(CH4, 298.15 K) + (lambda -1) * 2 *h(O2, turbiinin ulostulo) + lambda *  2 * 3.76 * h(N2, turbiinin ulostulo) + h(CO2, turbiinin ulostulo) + 2 * h(H2O, turbiinin ulostulo)

    entalpia_turbiiniin2_mol = (
        lambd * 2 * 3.76 * gas_N2_2turbiiniin.enthalpy_mole
        + (lambd - 1 - x) * 2 * gas_o2_2turbiiniin.enthalpy_mole
        + (1 + x) * gas_CO2_2turbiiniin.enthalpy_mole
        + (2 + 2*x) * gas_H2O_2turbiiniin.enthalpy_mole
                                )

    # lasketaan turbiiniin menevän entalpia ja sen jälkeen isentrooppihyötysuhteella lasketaan turbiinin jälkeinen entalpia

    koostumus_turbiiniin2 = 'N2:{},O2:{},H2O:{},CO2:{}'.format(lambd * 2 * 3.76, (lambd - (1+x)) * 2, (2 + 2*x), (1+x))
    gas3 = ct.Solution(mekanismi)
    gas3.TPX = T_turbiiniin, välilämmitinpaine, koostumus_turbiiniin2
    entalpia_turbiiniin2 = gas3.h
    gas3.SP = gas3.s, paine

    entalpia_turbiin2_jalkeen =entalpia_turbiiniin2 - (entalpia_turbiiniin2 - gas3.h) * eta_it
    gas3.HP = entalpia_turbiin2_jalkeen, paine
    T_turbiinin2_jalkeen = gas3.T

    #määritellään entalpiat 2. turbiinin jälkeen

    gas_H2O_2turbiinista = ct.Solution(mekanismi)
    gas_H2O_2turbiinista.TPX = T_turbiinin2_jalkeen, paine, 'H2O:1'

    gas_o2_2turbiinista = ct.Solution(mekanismi)
    gas_o2_2turbiinista.TPX = T_turbiinin2_jalkeen, paine, 'O2:1'

    gas_CO2_2turbiinista = ct.Solution(mekanismi)
    gas_CO2_2turbiinista.TPX = T_turbiinin2_jalkeen, paine, 'CO2:1'

    gas_ch4_2turbiinista = ct.Solution(mekanismi)
    gas_ch4_2turbiinista.TPX = T_turbiinin2_jalkeen, paine, 'CH4:1'

    gas_N2_2turbiinista = ct.Solution(mekanismi)
    gas_N2_2turbiinista.TPX = T_turbiinin2_jalkeen, paine, 'N2:1'


    #seuraavaksi lasketaan entalpia 2. turbiinista ulos
    # lambda * 2 * 3.76 * h(N2, turbiinin sisääntulo) + (lambda-1-x) * 2 * h(O2, turbiinin sisääntulo) + (1+x) * h(CO2, turbiinin sisääntulo) + (2+2x)* h(H2O,turbiinin sisääntulo)

    entalpia_turbiinista2_mol =(

        lambd * 2 * 3.76 * gas_N2_2turbiinista.enthalpy_mole +
        (lambd -1 - x) * 2 * gas_o2_2turbiinista.enthalpy_mole +
        (1+x) * gas_CO2_2turbiinista.enthalpy_mole +
        (2+2*x) * gas_H2O_2turbiinista.enthalpy_mole
    )

    lampo_yht = abs((1+x) * lampo_polttoaineesta)
    # Nyt lasketaan terminen hyötysuhde
    eta = ((entalpia_turbiiniin_mol - entalpia_turbiinista_mol) +(entalpia_turbiiniin2_mol - entalpia_turbiinista2_mol)- (
    entalpia_kompressorista_ilman_CH4 - entalpia_kompressoriin_mol)) /lampo_yht

    # Lasketaan ilman massa per kilomooli metaania polttokammiossa. Yksiköksi tulee kg(ilmaa)/kmol(CH4)
    Massa_ilma = lambd * 2 * gas_o2_kompressorista.mean_molecular_weight + lambd * 2 * 3.76 * gas_N2_kompressorista.mean_molecular_weight

    # Lasketaan turbiinin teho määritetyllä massavirralla. Kerromme osoittajan 1e-9:llä,
    # koska Cantera antaa mooliperusteisen ominaisentalpian yksikössä J/kmol ja haluamme sen muotoon MJ/mol(CH4).
    # Nimittäjä kerrotaan 0.001:llä, koska nyt se on kg(ilmaa)/kmol(CH4) ja haluamme kg(ilmaa)/mol(CH4).
    teho_turbiinista = ilman_massavirta * 1e-9 * (entalpia_turbiiniin_mol - entalpia_turbiinista_mol) / (1e-3 * Massa_ilma)
    teho_turbiinista2 = ilman_massavirta * 1e-9 * (entalpia_turbiiniin2_mol-entalpia_turbiinista2_mol) / (1e-3 * Massa_ilma)
    teho_yht = teho_turbiinista + teho_turbiinista2

    vasen = x * gas_ch4_2turbiiniin.enthalpy_mole + entalpia_turbiinista_mol
    oikea = entalpia_turbiiniin2_mol
    print(f' balance: vasen {vasen}, oikea {oikea}, ero (pitäis olla 0) {vasen - oikea}')

    return [eta, teho_turbiinista, teho_turbiinista2, teho_yht,x,lambd]


etat = {}
tehot_yht = {}
xt = {}
lambdt ={}

for p in [4e5,5e5,6e5,7e5,8e5,9e5,10e5, 11e5,12e5,13e5,14e5,15e5,16e5,17e5,18e5,19e5,20e5,21e5]:
    eta, teho_turbiinista, teho_turbiinista2, teho_yht, x, lambd = laske(p)
    etat[p] = eta
    tehot_yht[p] = teho_yht
    xt[p] = x
    lambdt[p] = lambd




print(f"hyötysuhteet: {etat}")
print(f"tehot yht: {tehot_yht}")
print(f"x: {xt}")
print(f"lambd: {lambdt}")





import matplotlib.pyplot as plt

p_bar = [p / 1e5 for p in etat]      # pressures in bar (dict keys, in insertion order)
eta_lista = list(etat.values())
teho_lista = list(tehot_yht.values())

plt.figure()
plt.plot(p_bar, eta_lista)
plt.xlabel('Välilämmittimen paine (bar)')
plt.ylabel('Terminen hyötysuhde')

plt.figure()
plt.plot(p_bar, teho_lista)
plt.xlabel('Välilämmittimen paine (bar)')
plt.ylabel('Turbiinien yhteisteho (MW)')
happi_riittaa = []

for p in etat:
    jaannos = lambdt[p] - 1 - xt[p]   # ylimääräisen hapen määrä
    if jaannos >= 0:
        happi_riittaa.append(1)       # happi riittää
    else:
        happi_riittaa.append(0)       # happi ei riitä

plt.figure()
plt.plot(p_bar, happi_riittaa)
plt.xlabel('Välilämmittimen paine (bar)')
plt.ylabel('Happi riittää (1 = kyllä, 0 = ei)')
plt.yticks([0, 1])
plt.ylim(-0.1, 1.1)
plt.show()