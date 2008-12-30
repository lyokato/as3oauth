package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.OAuthRequest;
  import flash.utils.ByteArray;

  public class OAuthRequestTest extends TestCase {

    public function OAuthRequestTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthRequestTest("testBuild") );
      return ts;
    }

    public function testBuild():void {

      var req1:OAuthRequest = new OAuthRequest("GET");
      assertEquals("GET", req1.method);
      assertFalse(req1.hasRequestBody);
      assertTrue(req1.hasResponseBody);

      var content:ByteArray = new ByteArray();
      content.writeUTFBytes("FooBar");

      var content2:ByteArray = new ByteArray();
      content2.writeUTFBytes("FooBarBuz");

      var req2:OAuthRequest = new OAuthRequest("POST");
      req2.body = content;
      assertEquals(content.length, req2.header.getValue("Content-Length"));
      assertEquals("POST", req2.method);
      assertTrue(req2.hasRequestBody);
      assertTrue(req2.hasResponseBody);

      var req3:OAuthRequest = new OAuthRequest("PUT");
      req3.body = content2;
      assertEquals(content2.length, req3.header.getValue("Content-Length"));

      assertEquals("PUT", req3.method);
      assertTrue(req3.hasRequestBody);
      assertTrue(req3.hasResponseBody);

      var req4:OAuthRequest = new OAuthRequest("DELETE");
      assertEquals("DELETE", req4.method);
      assertFalse(req4.hasRequestBody);
      assertTrue(req4.hasResponseBody);

      var req5:OAuthRequest = new OAuthRequest("HEAD");
      assertEquals("HEAD", req5.method);
      assertFalse(req5.hasRequestBody);
      assertFalse(req5.hasResponseBody);
    }

  }

}
