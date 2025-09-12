public class Subnum {
    public int sub(int a, int b) {
        return a - b;
    }

   public static void main(String[] args) {
        int x = 10;
        int y = 4;
        Subnum s1 = new Subnum();
        int result = s1.sub(x, y);

        System.out.println("Résultat de " + x + " - " + y + " = " + result);
    }
}
