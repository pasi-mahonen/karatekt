package examples.users;

import com.intuit.karate.junit5.Karate;

public class UsersTest {

    @Karate.Test
    Karate testUsers() {
        return Karate.run().relativeTo(getClass());
    }

}
