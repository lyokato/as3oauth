package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.*;
  import com.adobe.net.URI;
  import flash.utils.ByteArray;

  public class OAuthConsumerTest extends TestCase {

    public function OAuthConsumerTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthConsumerTest("testParams") );
      ts.addTest( new OAuthConsumerTest("testHeader") );
      ts.addTest( new OAuthConsumerTest("testQuery") );
      return ts;
    }

    public function testQuery():void {
      var consumerKey:String = 'key';
      var consumerSecret:String = 'secret'
      var consumer:OAuthConsumer = new OAuthConsumer(consumerKey, consumerSecret);
      var token:OAuthToken = new OAuthToken();
      token.token = "foo";
      var extraParams:Object = new Object();
      extraParams.extra = "foo";
      var queryString:String = consumer.genOAuthQuery("GET", new URI("http://example.org/"));
      assertTrue(queryString.match(/oauth_consumer_key=key&oauth_nonce=[a-fA-F0-9]+&oauth_signature=[^\&]+&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\d+&oauth_version=1.0/));
      var queryString2:String = consumer.genOAuthQuery("GET", new URI("http://example.org/"), token);
      assertTrue(queryString2.match(/oauth_consumer_key=key&oauth_nonce=[a-fA-F0-9]+&oauth_signature=[^\&]+&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\d+&oauth_token=foo&oauth_version=1.0/));
      var queryString3:String = consumer.genOAuthQuery("GET", new URI("http://example.org/"), null, extraParams);
      assertTrue(queryString3.match(/extra=foo&oauth_consumer_key=key&oauth_nonce=[a-fA-F0-9]+&oauth_signature=[^\&]+&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\d+&oauth_version=1.0/));
      var queryString4:String = consumer.genOAuthQuery("GET", new URI("http://example.org/"), token, extraParams);
      assertTrue(queryString4.match(/extra=foo&oauth_consumer_key=key&oauth_nonce=[a-fA-F0-9]+&oauth_signature=[^\&]+&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\d+&oauth_token=foo&oauth_version=1.0/));
    }

    public function testParams():void {
      var consumerKey:String = 'key';
      var consumerSecret:String = 'secret'
      var consumer:OAuthConsumer = new OAuthConsumer(consumerKey, consumerSecret);
      var params:Object = consumer.genOAuthParams("GET", new URI("http://example.org/"));
      assertNull(params.oauth_token);
      assertNotNull(params.oauth_signature);
      assertEquals(consumerKey, params.oauth_consumer_key);
      assertEquals('HMAC-SHA1', params.oauth_signature_method);
      //assertEquals('8vqsDTcMwKNGblxtgmRVrHtn29I=', params.oauth_signature);
      assertEquals("1.0", params.oauth_version);
      assertTrue(/^\d+$/.test(params.oauth_timestamp));
      assertTrue(/^[a-fA-F0-9]+$/.test(params.oauth_nonce));

      var token1:OAuthToken = new OAuthToken();
      token1.token = "foo";
      var params2:Object = consumer.genOAuthParams("POST", new URI("http://example.org/"), token1);
      assertNotNull(params2.oauth_token);
      assertEquals(consumerKey, params2.oauth_consumer_key);
      assertNotNull(params2.oauth_signature);
      assertEquals("HMAC-SHA1", params2.oauth_signature_method);
      //assertEquals("HMAC-SHA1", params2.oauth_signature);
      assertEquals("foo", params2.oauth_token);
      assertEquals("1.0", params2.oauth_version);
      assertTrue(/^\d+$/.test(params2.oauth_timestamp));
      assertTrue(/^[a-fA-F0-9]+$/.test(params2.oauth_nonce));
    }

    public function testHeader():void {
      var consumerKey:String = 'key';
      var consumerSecret:String = 'secret'
      var consumer:OAuthConsumer = new OAuthConsumer(consumerKey, consumerSecret);
      var header1:String = consumer.genOAuthHeader("GET", new URI("http://example.org/"));
      assertTrue(header1.match(/OAuth realm="", oauth_consumer_key="key", oauth_nonce="[a-fA-F0-9]+", oauth_signature=".+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\d+", oauth_version="1.0"/));
      var token1:OAuthToken = new OAuthToken();
      token1.token = "foo";
      var header2:String = consumer.genOAuthHeader("POST", new URI("http://example.org/"), 'realm', token1);
      assertTrue(header2.match(/OAuth realm="realm", oauth_consumer_key="key", oauth_nonce="[a-fA-F0-9]+", oauth_signature=".+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\d+", oauth_token="foo", oauth_version="1.0"/));
    }

  }

}
