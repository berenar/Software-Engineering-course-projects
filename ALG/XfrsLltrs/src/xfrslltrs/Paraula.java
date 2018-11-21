/*
 */
package xfrslltrs;

import java.util.Arrays;
import java.util.Objects;

/**
 * @author Ahmed Antonio Boutaour Sanchez, Bernat Pericàs Serra
 * @DNIs 43202227Q, 43212796M
 */
public class Paraula {

    public String paraulaLLtrs;
    public int[] paraulaFreq;
    public int llarg;

    public static final char[] abecedari //possibles lletres
            = new char[]{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
                'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
                'X', 'Y', 'Z'}; //0...25
    public static final char[] vocals = {'A', 'E', 'I', 'O', 'U'};
    public static final char[] consonants = {'B', 'C', 'D', 'F', 'G', 'H', 'J',
        'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z'};

    public Paraula() {
    }

    /**
     * Constructor Paraula donat un String de la paraula en llenguatge natural.
     *
     * @param paraulaLLtrs paraula normal
     */
    public Paraula(String paraulaLLtrs) {
        this.paraulaLLtrs = paraulaLLtrs;
        this.paraulaFreq = lletresToFreq(paraulaLLtrs.toCharArray());
        this.llarg = paraulaLLtrs.length();
    }

    /**
     * Constructor Paraula donat un int[] de la paraula en freqüències.
     *
     * @param parFreq paraula en freqüències
     */
    public Paraula(int[] parFreq) {
        this.paraulaLLtrs = freqToLletres(parFreq);
        this.paraulaFreq = parFreq;
        this.llarg = paraulaLLtrs.length();
    }

    /**
     * A partir de la paraula donada en un array de chars (lletres), retorna un
     * array de ints que es correspon a la seva representació segons la
     * freqüència de lletres.
     *
     * @param linia Paraula donada en un array de chars
     * @return paraula en freqüència de lletres
     */
    public int[] lletresToFreq(char[] linia) {
        int[] parFreq = new int[26];
        try {
            for (int i = 0; i < linia.length; i++) {

                parFreq[index(linia[i])] = parFreq[index(linia[i])] + 1;

            }
        } catch (Exception e) {
            System.out.println("Error convertint a freqüència de lletres");
        }
        return parFreq;
    }

    /**
     * A partir d'un array de ints (paraula donada per la seva freqüència de
     * lletres), retorna un array de chars de la paraula corresponent.
     *
     * @param lletresFreq
     * @return
     */
    public String freqToLletres(int[] lletresFreq) {
        try {
            int llarg = 0;  //llargaria de lltrsTransf
            for (int i = 0; i < lletresFreq.length; i++) {
                llarg += lletresFreq[i];
            }
            char[] lltrsTransf = new char[llarg];
            int indx = 0; //índex de lltrsTransf
            for (int i = 0; i < lletresFreq.length; i++) {
                int j = 0;//nº de vegades que es repeteix una lletra
                while (j < lletresFreq[i]) {
                    lltrsTransf[indx] = abecedari[i];//escriure lletra
                    j++;
                    indx++;
                }
            }
            return Arrays.toString(lltrsTransf);
        } catch (ArrayIndexOutOfBoundsException e) {
            return null;
        }
    }

    /**
     * Retorna l'índex corresponent a una lletra donada en char segons l'alfabet
     * català.
     *
     * @param lletra
     * @return
     */
    private int index(char lletra) {
        switch (lletra) {
            case 'A':
                return 0;
            case 'B':
                return 1;
            case 'C':
                return 2;
            case 'D':
                return 3;
            case 'E':
                return 4;
            case 'F':
                return 5;
            case 'G':
                return 6;
            case 'H':
                return 7;
            case 'I':
                return 8;
            case 'J':
                return 9;
            case 'K':
                return 10;
            case 'L':
                return 11;
            case 'M':
                return 12;
            case 'N':
                return 13;
            case 'O':
                return 14;
            case 'P':
                return 15;
            case 'Q':
                return 16;
            case 'R':
                return 17;
            case 'S':
                return 18;
            case 'T':
                return 19;
            case 'U':
                return 20;
            case 'V':
                return 21;
            case 'W':
                return 22;
            case 'X':
                return 23;
            case 'Y':
                return 24;
            case 'Z':
                return 25;
            default:
                return -1;
        }
    }

    /**
     * Imprimeix els atributs d'un objecte Paraula
     */
    public void imprimeixPar() {
        System.out.println("Paraula " + paraulaLLtrs
                + " : " + Arrays.toString(paraulaFreq)
                + " length= " + llarg);
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 29 * hash + Objects.hashCode(this.paraulaLLtrs);
        hash = 29 * hash + Arrays.hashCode(this.paraulaFreq);
        hash = 29 * hash + this.llarg;
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Paraula other = (Paraula) obj;
        if (!Objects.equals(this.paraulaLLtrs, other.paraulaLLtrs)) {
            return false;
        }
        if (!Arrays.equals(this.paraulaFreq, other.paraulaFreq)) {
            return false;
        }
        return true;
    }

}
