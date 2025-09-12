import static org.junit.Assert.assertEquals; 
import org.junit.Test;

public class AddTest {

    @Test
    public void testAddPositiveNumber(){
        Add plus = new Add();
        int resultat = plus.add(10,5);
        assertEquals(15, resultat);
    }

    @Test
    public void testAddNegativeNumbers(){
        Add plus = new Add();
        int resultat = plus.add(-20, -3);
        assertEquals(-23, resultat);
    }

    @Test
    public void testAddZeros(){
        Add plus = new Add();
        int resultat = plus.add(0, 0);
        assertEquals(0, resultat);
    }

    @Test
    public void testAddMixedSigns(){
        Add plus = new Add();
        int resultat = plus.add(-6, 5);
        assertEquals(-1, resultat);
    }
}
