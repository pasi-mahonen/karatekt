package examples.features;

import com.intuit.karate.junit5.Karate;

public class KtRunner {

    @Karate.Test
    Karate testKt() {
        return Karate.run().relativeTo(getClass());
    }
}
