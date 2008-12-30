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

package org.coderepos.oauth {

  import flash.utils.ByteArray;
  import com.hurlant.util.Hex;

  /**
   * Signature method base class.
   * Don't use this class directly, but use subclass.
   */
  public class OAuthSignatureMethod {

    protected var _consumerSecret:String;
    protected var _tokenSecret:String;

    /**
     * Constructor
     *
     * @param consumerSecret
     * @param tokenSecret
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthSignatureMethod(consumerSecret:String='',
      tokenSecret:String='') {
      _consumerSecret = consumerSecret;
      _tokenSecret = tokenSecret;
    }

    protected function getKeyBytes():ByteArray {
      var keys:String = OAuthUtil.encode(_consumerSecret)
                      + '&' 
                      + OAuthUtil.encode(_tokenSecret);
      return Hex.toArray(Hex.fromString(keys));
    }

    /**
     * getter for method name
     *
     * @returns methodName
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get methodName():String {
      return "";
    }

    /**
     * generate signature from base string
     *
     * @param baseString
     * @returns signature
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function sign(baseString:String):String {
      return null;
    }

    /**
     * verify signature
     *
     * @param baseString
     * @param signature
     * @returns Boolean
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function verify(baseString:String, signature:String):Boolean {
      return (signature == sign(baseString)) ? true : false;
    }

  }

}

