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

  import com.adobe.net.URI;
  import com.hurlant.util.Hex;

  /**
   * Class provides utility functions for OAuth
   */
  public class OAuthUtil {
    /**
     * escape character
     *
     * @param originalString
     * @returns encodedString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function encode(origin:String):String {
      var encoded:String = "";
      var length:int = origin.length;
      for (var i:uint = 0; i < length; i++) {
        var char:String = origin.charAt(i);
        if (char.match(/^[\d\w\^\-\.\~]$/)) {
          encoded += char;
        } else {
          var hex:String = Hex.fromString(char);
          encoded += "%" + hex.toUpperCase();
        }
      }
      return encoded;
    }

    /**
     * unescape character
     *
     * @param encodedString
     * @returns originalString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function decode(encoded:String):String {
      var origin:String = encoded.replace(/%([a-fA-F\d]{2})/g,
        function():String { return Hex.toString(arguments[1]); })
      return origin;
    }

    /**
     * generates and returns random hex string.
     *
     * @param digit
     * @returns randomString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function getRandom(digit:uint):String {
      var random:String = '';
      var sets:String = "abcdefABCDEF0123456789";
      var n:Number;
      for (var i:uint = 0; i < digit; i++) {
        n = Math.random() * sets.length;
        random += sets.charAt(Math.floor(n));
      }
      return random;
    }

    /**
     * generate and returns signature base string.
     *
     * @param httpMethod
     * @param uri
     * @param params
     * @returns signatureBaseString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function createSignatureBaseString(method:String,
      uri:URI, params:Object):String {
      method = method.toUpperCase();
      var normalizedURI:String = normalizeURI(uri);
      var normalizedParams:String = normalizeParams(params);
      var baseString:String = encode(method)
                            + '&'
                            + encode(normalizedURI)
                            + '&'
                            + encode(normalizedParams);
      return baseString;
    }

    /**
     * normalize uri.
     *
     * @param uri
     * @returns normalizedURI
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function normalizeURI(uri:URI):String {
      var scheme:String = uri.scheme;
      if (scheme != "http" && scheme != "https") {
        throw new ArgumentError("uri is invalid.");
      }
      var normalized:String = scheme.toLowerCase()
        + "://" + uri.authority.toLowerCase();
      var port:uint = uint(uri.port);
      if (uri.port && (port != 80 && port != 443)) {
        normalized += ":" + String(port);
      }
      normalized += uri.path;
      return normalized.toLowerCase();
    }

    /*
     * normalize params.
     *
     * @param params
     * @returns normalizedParamString
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function normalizeParams(params:Object):String {
      var pairs:Array = [];
      for (var prop:String in params) {
        if (prop != "realm" && prop != "oauth_signature") {
              var pair:String = encode(prop)
                              + "="
                              + encode(params[prop]);
              pairs.push(pair);
        }
      }
      pairs.sort();
      return pairs.join('&');
    }

    /*
     * parse HTTP WWW-Authentication header, and if it matches OAuth,
     * gathers each parameters and returns them as an Object.
     *
     * @param header
     * @returns params
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function parseAuthHeader(header:String):Object {
      header = header.replace(/^\s*OAuth\s*/, '');
      var pairs:Array = header.split(/\,\s*/);
      var params:Object = {};
      var i:int;
      for (i = 0; i < pairs.length; i++) {
        var pair:Array = pairs[i].split(/=/);
        if (pair[1] != null) {
          var value:String = pair[1].replace(/^\"/, '').replace(/\"$/, '');
          params[pair[0]] = decode(value);
        }
      }
      return params;
    }

    /**
     * build HTTP Authorization header.
     *
     * @param realm
     * @param otherParams
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public static function buildAuthHeader(realm:String, params:Object):String {
      var head:String = "OAuth realm=\"" + realm + "\"";
      var pairs:Array = [];
      for (var prop:String in params) {
        if (prop.match(/^x?oauth_/)) {
          var pair:String = encode(prop)
                          + "=\""
                          + encode(params[prop])
                          + "\"";
          pairs.push(pair);
        }
      }
      pairs.sort();
      pairs.unshift(head);
      return pairs.join(", ");
    }

  }

}

