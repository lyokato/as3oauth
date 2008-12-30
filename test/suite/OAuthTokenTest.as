package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.OAuthToken;

  public class OAuthTokenTest extends TestCase {

    public function OAuthTokenTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthTokenTest("testBuild") );
      ts.addTest( new OAuthTokenTest("testRandomBuild") );
      ts.addTest( new OAuthTokenTest("testParse") );
      return ts;
    }

    public function testBuild():void {
      var t:OAuthToken = new OAuthToken();
      assertEquals('', t.token);
      assertEquals('', t.secret);
      t.token = "foo";
      t.secret = "bar";
      assertEquals("foo", t.token);
      assertEquals("bar", t.secret);
      var encoded:String = t.toString();
      assertEquals('oauth_token=foo&oauth_token_secret=bar', encoded);
    }

    public function testRandomBuild():void {
      var t:OAuthToken = OAuthToken.genRandom();
      assertTrue(/^[a-fA-F0-9]+$/.test(t.token));
      assertTrue(/^[a-fA-F0-9]+$/.test(t.secret));
    }

    public function testParse():void {
      var encoded:String = "oauth_token=foo&oauth_token_secret=bar";
      var t:OAuthToken = OAuthToken.fromString(encoded);
      assertEquals('foo', t.token);
      assertEquals('bar', t.secret);
    }

  }

}

