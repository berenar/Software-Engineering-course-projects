package xfrslltrs;

import java.util.ArrayList;

/**
 * @author Ahmed Antonio Boutaour Sanchez, Bernat Pericàs Serra
 * @DNIs 43202227Q, 43212796M
 */
public class XfrsLltrs {

    public static void main(String[] args) {
        XfrsLltrs joc = new XfrsLltrs();
        joc.inici();
    }

    private void inici() {
        //instanciar LLtrs, crear i imprimir diccionari
        Lltrs L = new Lltrs();
        L.creaDicc("DISC2-LP.txt");
//        L.printArr(L.diccionari, "DISC2-LP.txt");

        //A
        String nLletres = a(L);

        //B
        ArrayList<Paraula> solucionsSist = b(L, nLletres);

        //C
        ArrayList<Paraula> solucionsUsu = new ArrayList();
        boolean usuariGuanya = c(L, solucionsUsu, solucionsSist, nLletres.length());
        System.out.println(usuariGuanya);
    }

    private String a(Lltrs L) {
        System.out.println("a) N lletres aleatòries");
        int n = 8;                                                              //VALOR Q CANVIA
        char[] nLltrs = L.generaNlletres(n);
        String nLletres = String.valueOf(nLltrs);
        System.out.println(nLletres);
        System.out.println(" ");
        return nLletres;

    }

    private ArrayList<Paraula> b(Lltrs L, String nLletres) {
        System.out.println("b) paraules vàlides");
        int llargUsu = 5;                                                       //VALOR Q CANVIA
        System.out.println("de tamany major o igual a " + llargUsu);
        Paraula p = new Paraula(nLletres);
        ArrayList<Paraula> solucionsSist = new ArrayList();
        L.printArr(L.solucions(p, 0, solucionsSist, llargUsu),
                "paraules que pertanyen al dicc");
        System.out.println(" ");
        return solucionsSist;
    }

    private boolean c(Lltrs L, ArrayList<Paraula> solucionsUsu,
            ArrayList<Paraula> solucionsSist, int nLletres) {
        for (int i = 0; i < solucionsUsu.size(); i++) {
            //si les solucions de l'usuari superen la llargària màxima
            if (!(solucionsUsu.get(i).llarg <= nLletres)) {
                return false; //false si supera el límit
            } else {//comprovar que estiguin dins el conjunt de solucions trobades 
                //pel backtracking
                if (!(solucionsSist.contains(solucionsUsu.get(i)))) {
                    return false; //false si no ho conté
                }
            }
        }
        return true;
    }

}
