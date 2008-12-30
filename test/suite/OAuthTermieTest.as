package suite {

  import flexunit.framework.TestSuite;
  import flexunit.framework.TestCase;
  import org.coderepos.oauth.*;
  import org.coderepos.oauth.events.*;
  import com.adobe.net.URI;
  import flash.utils.ByteArray;

  public class OAuthTermieTest extends TestCase {

    private var consumer:OAuthConsumer;

    public function OAuthTermieTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthTermieTest("testAccess") );
      return ts;
    }

    public function testAccess():void {

      var consumerKey:String = "key";
      var consumerSecret:String = "secret";

      var requestTokenURI:URI = new URI("http://term.ie/oauth/example/request_token.php");

      consumer = new OAuthConsumer(consumerKey, consumerSecret);
      consumer.timeout = 10;
      consumer.addEventListener( OAuthEvent.GET_REQUEST_TOKEN_COMPLETED, addAsync( onCompletedToGetToken, 1000 ) );
      //consumer.addEventListener( OAuthEvent.GET_REQUEST_TOKEN_FAILED, addAsync( onFailedToGetToken, 1000 ) );
      consumer.getRequestToken( requestTokenURI );

    }

    private function onFailedToGetToken(e:OAuthEvent):void {
      assertEquals('failed');
    }

    private function onCompletedToGetToken(e:OAuthEvent):void {
      var requestToken:OAuthToken = e.result.token;
      assertEquals('requestkey', requestToken.token);
      assertEquals('requestsecret', requestToken.secret);
      consumer.addEventListener( OAuthEvent.GET_ACCESS_TOKEN_COMPLETED, addAsync( onCompletedToAccessToken, 1000 ) );
      var accessTokenURI:URI = new URI("http://term.ie/oauth/example/access_token.php");
      consumer.getAccessToken( accessTokenURI, requestToken );
    }

    private function onCompletedToAccessToken(e:OAuthEvent):void {
      var accessToken:OAuthToken = e.result.token;
      assertEquals('accesskey', accessToken.token);
      assertEquals('accesssecret', accessToken.secret);
      var resourceURI:URI = new URI("http://term.ie/oauth/example/echo_api.php");
      consumer.addEventListener( OAuthEvent.REQUEST_COMPLETED, addAsync( onCompletedToRequest, 1000 ) );
      //var option:OAuthRequestOption = new OAuthRequestOption();
      //option.httpMethod = "GET";
      //consumer.request( resourceURI, option );
      consumer.request( resourceURI );
    }

    private function onCompletedToRequest(e:OAuthEvent):void {
      var content:ByteArray = e.result.content;
      content.position = 0;
      var data:String = content.readUTFBytes(content.bytesAvailable);
      assertEquals(data);
    }

  }

}
