/*
 */
package xfrslltrs;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;

/**
 * @author Ahmed Antonio Boutaour Sanchez, Bernat Pericàs Serra
 * @DNIs 43202227Q, 43212796M
 */
public class Lltrs {

    Random rnd = new Random();

    public ArrayList<Paraula> diccionari = new ArrayList(569265);

    //nombre de paraules totals - (paraules amb Ç ò L·L)
    /**
     * Calcula totes les possibles solucions donada una paraula en freqüència de
     * lletres i imprimeix les que pertanyen al diccionari.
     *
     * @param par
     * @param iteracio
     * @param solucionsSist
     * @param llargUsu
     * @return
     */
    public ArrayList<Paraula> solucions(Paraula par, int iteracio,
            ArrayList<Paraula> solucionsSist, int llargUsu) {

        int[] parFreq = par.paraulaFreq;
        int t = 0;
        int aux = parFreq[iteracio];
        while (parFreq[iteracio] - t >= 0) {

            parFreq[iteracio] -= t;

            if (iteracio + 1 == parFreq.length) {
                Paraula p = apareixFreq(parFreq);
                //paraula q apareix al diccionari, null si no apareix
                if (p != null) {//afegirla si apareix
                    solucionsSist.add(p);
                }
            } else if (quantitat(parFreq) >= llargUsu) {//poda
                //només es seguirà desenvolupant l'arbre si la llargaria de la 
                //paraula és major o igual a la de l'usuari
                iteracio++;
                Paraula p = new Paraula(parFreq);
                solucions(p, iteracio, solucionsSist, llargUsu); //backtrack
                iteracio--;
            }
            t++;
            parFreq[iteracio] = aux;
        }
        return solucionsSist;
    }

    private int quantitat(int[] parFreq) {
        int quantitat = 0;
        for (int i = 0; i < parFreq.length; i++) {
            quantitat += parFreq[i];
        }
        return quantitat;
    }

    /**
     * cerca la paraula al diccionari i la retorna, si no, retorna null
     *
     * @param parFreq
     * @return
     */
    public Paraula apareixFreq(int[] parFreq) {
        Paraula p = null;
        for (int i = 0; i < diccionari.size(); i++) {
            if (Arrays.equals(diccionari.get(i).paraulaFreq, parFreq)) {
                p = diccionari.get(i);
            }
        }
        return p;
    }

    /**
     * Transforma el diccionari donat en paraules en la seva forma segons la
     * freqüència de lletres.
     *
     * @param nomDicc
     */
    public void creaDicc(String nomDicc) {
        File f = new File(nomDicc);
        Scanner s = null;
        try {
            s = new Scanner(f);
        } catch (FileNotFoundException ex) {
            System.out.println("Fitxer no trobat");
        }
        while (s.hasNext()) {
            String linia = s.next();
            if (!(linia.contains("Ç") || (linia.contains("L·L")))) {
                Paraula par = new Paraula(linia);
                diccionari.add(par);
            }
        }
    }

    /**
     *
     * @param diccionari
     * @param titol
     */
    public void printArr(ArrayList<Paraula> diccionari, String titol) {
        System.out.println(titol);
        for (int i = 0; i < diccionari.size(); i++) {
            diccionari.get(i).imprimeixPar();
        }
        System.out.println("Conjunt size: " + (diccionari.size()) + "\n");
    }

    /**
     * Genera n lletres aleatories. Mínim 30%vocals i 40%consonants
     *
     * @param n
     * @return
     */
    public char[] generaNlletres(int n) {
        char[] nLletres = new char[n];
        for (int i = 0; i < n / 3; i++) {
            nLletres[i] = Paraula.vocals[new Random().nextInt(5)];
        }
        for (int i = n / 3; i < ((n / 3) + n / 4); i++) {
            nLletres[i] = Paraula.consonants[new Random().nextInt(20)];
        }
        for (int i = ((n / 3) + n / 4); i < n; i++) {
            nLletres[i] = Paraula.abecedari[new Random().nextInt(20)];

        }
        return nLletres;
    }
}
