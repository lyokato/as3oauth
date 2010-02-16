package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.OAuthToken;
  import org.coderepos.oauth.OAuthResponse;

  public class OAuthResponseTest extends TestCase {

    public function OAuthResponseTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthResponseTest("testParse") );
      return ts;
    }

    public function testParse():void {
        // for xAuth
      var encoded:String = "oauth_token=foo&oauth_token_secret=bar&x_oauth_expires=1000";
      var r:OAuthResponse = OAuthResponse.fromString(encoded);
      var t:OAuthToken = r.token;
      assertEquals('foo', t.token);
      assertEquals('bar', t.secret);
      assertTrue(r.hasParam("x_oauth_expires"));
      assertEquals('1000', r.getParam("x_oauth_expires"));
    }

  }

}

