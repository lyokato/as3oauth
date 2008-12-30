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

package org.coderepos.oauth.signaturemethods {

  import flash.utils.ByteArray;
  import com.hurlant.crypto.Crypto;
  import com.hurlant.crypto.hash.HMAC;
  import com.hurlant.util.Hex;
  import com.hurlant.util.Base64;
  import org.coderepos.oauth.OAuthSignatureMethod;

  /**
   * HMAC-SHA1 signature method class
   */
  public class HMAC_SHA1 extends OAuthSignatureMethod {

    /**
     * Constructor
     *
     * @param consumerSecret
     * @param tokenSecret
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function HMAC_SHA1(consumerSecret:String='', tokenSecret:String='') {
      super(consumerSecret, tokenSecret);
    }

    /**
     * returns methodName "HMAC-SHA1"
     *
     * @returns methodName
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    override public function get methodName():String {
      return "HMAC-SHA1";
    }

    /**
     * generate signature from passed baseString
     *
     * @param baseString
     * @returns signature
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    override public function sign(baseString:String):String {
      var hmac:HMAC = Crypto.getHMAC("sha1");
      var encoded:ByteArray = hmac.compute(getKeyBytes(), Hex.toArray(Hex.fromString(baseString)));
      var signature:String = Base64.encodeByteArray(encoded);
      return signature;
    }

  }

}

