package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.OAuthUtil;
  import com.adobe.net.URI;

  public class OAuthUtilTest extends TestCase {

    public function OAuthUtilTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthUtilTest("testRandom") );
      ts.addTest( new OAuthUtilTest("testEncoding") );
      ts.addTest( new OAuthUtilTest("testHeader") );
      ts.addTest( new OAuthUtilTest("testNormalizeURL") );
      ts.addTest( new OAuthUtilTest("testSignatureBaseString") );
      return ts;
    }

    public function testRandom():void {
      var random:String = OAuthUtil.getRandom(8);
      assertTrue(/^[a-fA-F0-9]{8}$/.test(random));
      var random2:String = OAuthUtil.getRandom(10);
      assertTrue(/^[a-fA-F0-9]{10}$/.test(random2));
    }

    public function testEncoding():void {
      var s1:String = '123 @#$%&hoge hoge+._-~';
      var encoded1:String = OAuthUtil.encode(s1);
      assertEquals('123%20%40%23%24%25%26hoge%20hoge%2B._-~', encoded1);
      var decoded1:String = OAuthUtil.decode(encoded1);
      assertEquals(s1, decoded1);
    }

    public function testNormalizeURL():void {
      var url1:URI = new URI("http://Example.com:80/path?query");
      var url2:URI = new URI("https://Example.com:443/path?query");
      var url3:URI = new URI("http://Example.com:8080/path?query");
      var url4:URI = new URI("http://Example.com/path?query");

      assertEquals('', url4.port);
      var normalized1:String = OAuthUtil.normalizeURI(url1);
      assertEquals('http://example.com/path', normalized1);
      var normalized2:String = OAuthUtil.normalizeURI(url2);
      assertEquals('https://example.com/path', normalized2);
      var normalized3:String = OAuthUtil.normalizeURI(url3);
      assertEquals('http://example.com:8080/path', normalized3);
      var normalized4:String = OAuthUtil.normalizeURI(url4);
      assertEquals('http://example.com/path', normalized4);

      var requestURL:String = "http://photos.example.net/photos";
      assertEquals('http%3A%2F%2Fphotos.example.net%2Fphotos', OAuthUtil.encode(requestURL));
      var normalizedURL:String = OAuthUtil.normalizeURI(new URI(requestURL));
      assertEquals('http://photos.example.net/photos', normalizedURL);
      assertEquals('http%3A%2F%2Fphotos.example.net%2Fphotos', OAuthUtil.encode(normalizedURL))
    }

    public function testHeader():void {
      var realm:String = "http://example.org/realm";
      var params:Object = {
        oauth_consumer_key: 'foobar',
        oauth_timestamp: '11000011',
        oauth_nonce: 'nonce',
        oauth_version: '1.0',
        oauth_token: 'hoge', 
        oauth_signature_method: 'HMAC-SHA1',
        oauth_signature: 'sig'
      };
      var header:String = OAuthUtil.buildAuthHeader(realm, params);
      assertEquals('OAuth realm="http://example.org/realm", oauth_consumer_key="foobar", oauth_nonce="nonce", oauth_signature="sig", oauth_signature_method="HMAC-SHA1", oauth_timestamp="11000011", oauth_token="hoge", oauth_version="1.0"', header);

      var decodedParam:Object = OAuthUtil.parseAuthHeader(header);
      assertEquals('foobar', decodedParam.oauth_consumer_key);
      assertEquals('1.0', decodedParam.oauth_version);
      assertEquals('11000011', decodedParam.oauth_timestamp);
      assertEquals('nonce', decodedParam.oauth_nonce);
      assertEquals('hoge', decodedParam.oauth_token);
      assertEquals('HMAC-SHA1', decodedParam.oauth_signature_method);
      assertEquals('sig', decodedParam.oauth_signature);
    }

    public function testSignatureBaseString():void {
      var httpMethod:String = "GET";
      var requestURL:String = "http://photos.example.net/photos";
      var params:Object = {
        oauth_consumer_key     : 'dpf43f3p214k3103',
        oauth_token            : 'nnch734d00s12jdk',
        oauth_signature_method : 'HMAC-SHA1',
        oauth_timestamp        : '1191242096',
        oauth_nonce            : 'kllo9940pd9333jh',
        oauth_version          : '1.0',
        file                   : 'vacation.jpg',
        size                   : 'original'
      };
      var base:String = OAuthUtil.createSignatureBaseString(httpMethod, new URI(requestURL), params);
      assertEquals('GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p214k3103%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00s12jdk%26oauth_version%3D1.0%26size%3Doriginal', base);
    }

  }

}
