/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
*/

package org.coderepos.oauth
{

  /**
   * Class represents OAuth's token.
   */
  public class OAuthToken {

    /**
     * token value
     */
    public var token:String;
    /**
     * token secret value
     */
    public var secret:String;

    /**
     * Constructor
     *
     * @param token
     * @param secret
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthToken(_token:String='', _secret:String='') {
      token = _token;
      secret = _secret;
    }

    /**
     * generate new OAuthToken object with random token and secret values.
     *
     * @param digit
     * @returns OAuthToken
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function genRandom(digit:uint=8):OAuthToken {
      var t:OAuthToken = new OAuthToken();
      t.token = OAuthUtil.getRandom(digit);
      t.secret = OAuthUtil.getRandom(digit);
      return t;
    }

    /**
     * [Deprecated]
     * decodes string and returns it as OAuthToken object.
     *
     * @param encodedString
     * @returns OAuthTokens
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function fromString(encoded:String):OAuthToken {
      var pairs:Array = encoded.split(/&/);
      var param:Object = {
        oauth_token: '',
        oauth_token_secret: ''
      };
      for(var i:uint=0; i < pairs.length; i++) {
        var pair:Array = pairs[i].split(/=/);
        var key:String = pair[0];
        if (key == 'oauth_token' || key == 'oauth_token_secret') {
          param[key] = OAuthUtil.decode(pair[1]);
        }
      }
      var t:OAuthToken = new OAuthToken();
      t.token = param.oauth_token;
      t.secret = param.oauth_token_secret;
      return t;
    }

    /**
     * Converts token to encoded value.
     *
     * @returns encodedString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function toString():String {
      var encoded:String = "oauth_token="
                         + OAuthUtil.encode(token)
                         + "&oauth_token_secret="
                         + OAuthUtil.encode(secret);
      return encoded;
    }

  }

}

