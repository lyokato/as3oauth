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

  /**
   * Class contains three constants that represents type of OAuth scheme.
   */
  public class OAuthParamMethod {

    /**
     * includes each OAuth params in authorization header
     */
    public static const AUTH_HEADER:uint = 1;
    /**
     * includes each OAuth params in body on POST request
     */
    public static const POST_BODY:uint = 2;
    /**
     * includes each OAuth params in query string
     */
    public static const URL_QUERY:uint = 3;
  }

}

