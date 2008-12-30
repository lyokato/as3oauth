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
  import org.coderepos.oauth.OAuthSignatureMethod;

  /**
   * PLAINTEXT signature method class
   */
  public class PLAINTEXT extends OAuthSignatureMethod {

    /**
     * Constructor
     *
     * @param consumerSecret
     * @param tokenSecret
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function PLAINTEXT(consumerSecret:String='', tokenSecret:String='') {
      super(consumerSecret, tokenSecret);
    }

    /**
     * returns methodName "PLAINTEXT"
     *
     * @returns methodName
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    override public function get methodName():String {
      return "PLAINTEXT";
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
      var key:ByteArray = getKeyBytes();
      key.position = 0;
      return key.readUTFBytes(key.bytesAvailable);
    }

  }

}

