import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class SubTest {

    @Test
    public void testSubPositiveNumbers() {
        sub calculator = new sub();
        int result = calculator.sub(10, 5);
        assertEquals(5, result);
    }

    @Test
    public void testSubNegativeNumbers() {
        sub calculator = new sub();
        int result = calculator.sub(-3, -2);
        assertEquals(-1, result);
    }

    @Test
    public void testSubZero() {
        sub calculator = new sub();
        int result = calculator.sub(0, 0);
        assertEquals(0, result);
    }

    @Test
    public void testSubMixedNumbers() {
        sub calculator = new sub();
        int result = calculator.sub(5, -3);
        assertEquals(8, result);
    }
}

