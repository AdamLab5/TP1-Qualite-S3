public class Add{

    public int add(int a, int b){
        return a+b;
    }


    public static void main (String args []){
        int a = 2;
        int b = 2;
        Add plus = new Add();
        int resultat=plus.add(a,b);
        System.out.println(resultat);
    }
}
