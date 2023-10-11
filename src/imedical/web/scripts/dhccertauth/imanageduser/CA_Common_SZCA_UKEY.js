var ca_key = (function() {
    
    var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var base64DecodeChars = new Array(
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
        -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
        -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);

    function base64encode(str) {
        var out, i, len;
        var c1, c2, c3;

        len = str.length;
        i = 0;
        out = "";
        while(i < len) {
        c1 = str.charCodeAt(i++) & 0xff;
        if(i == len)
        {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt((c1 & 0x3) << 4);
            out += "==";
            break;
        }
        c2 = str.charCodeAt(i++);
        if(i == len)
        {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
            out += base64EncodeChars.charAt((c2 & 0xF) << 2);
            out += "=";
            break;
        }
        c3 = str.charCodeAt(i++);
        out += base64EncodeChars.charAt(c1 >> 2);
        out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
        out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >>6));
        out += base64EncodeChars.charAt(c3 & 0x3F);
        }
        return out;
    }

    function base64decode(str) {
        var c1, c2, c3, c4;
        var i, len, out;

        len = str.length;
        i = 0;
        out = "";
        while(i < len) {
        /* c1 */
        do {
            c1 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
        } while(i < len && c1 == -1);
        if(c1 == -1)
            break;

        /* c2 */
        do {
            c2 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
        } while(i < len && c2 == -1);
        if(c2 == -1)
            break;

        out += String.fromCharCode((c1 << 2) | ((c2 & 0x30) >> 4));

        /* c3 */
        do {
            c3 = str.charCodeAt(i++) & 0xff;
            if(c3 == 61)
            {
                out = out.substring(0, out.length-1);
                return out;
            }        
            c3 = base64DecodeChars[c3];
        } while(i < len && c3 == -1);
        if(c3 == -1)
            break;

        out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));

        /* c4 */
        do {
            c4 = str.charCodeAt(i++) & 0xff;
            if(c4 == 61)
            {
                out = out.substring(0, out.length-1);
                return out;
            }
            c4 = base64DecodeChars[c4];
        } while(i < len && c4 == -1);
        if(c4 == -1)
            break;
        out += String.fromCharCode(((c3 & 0x03) << 6) | c4);
        }
        out = out.substring(0, out.length-1);
        return out;
    }

    function utf16to8(str) {
        var out, i, len, c;

        out = "";
        len = str.length;
        for(i = 0; i < len; i++) {
        c = str.charCodeAt(i);
        if ((c >= 0x0001) && (c <= 0x007F)) {
            out += str.charAt(i);
        } else if (c > 0x07FF) {
            out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
            out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));
            out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
        } else {
            out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));
            out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
        }
        }
        return out;
    }

    function utf8to16(str) {
        var out, i, len, c;
        var char2, char3;

        out = "";
        len = str.length;
        i = 0;
        while(i < len) {
        c = str.charCodeAt(i++);
        switch(c >> 4)
        { 
          case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
            // 0xxxxxxx
            out += str.charAt(i-1);
            break;
          case 12: case 13:
            // 110x xxxx   10xx xxxx
            char2 = str.charCodeAt(i++);
            out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
            break;
          case 14:
            // 1110 xxxx  10xx xxxx  10xx xxxx
            char2 = str.charCodeAt(i++);
            char3 = str.charCodeAt(i++);
            out += String.fromCharCode(((c & 0x0F) << 12) |
                           ((char2 & 0x3F) << 6) |
                           ((char3 & 0x3F) << 0));
            break;
        }
        }

        return out;
    }

    function CharToHex(str) {
        var out, i, len, c, h;
        out = "";
        len = str.length;
        i = 0;
        while(i < len) 
        {
            c = str.charCodeAt(i++);
            h = c.toString(16);
            if(h.length < 2)
                h = "0" + h;
            
            out += "\\x" + h + " ";
            if(i > 0 && i % 8 == 0)
                out += "\r\n";
        }

        return out;
    }


        //SZCA Code start, szcapki.js ******************************************************
        
    function getXmlHttp() 
    {
        var xmlHttp;
        if (window.XMLHttpRequest)
        { // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlHttp = new XMLHttpRequest();
        } 
        else
        { // code for IE6, IE5
            xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
        }
        return xmlHttp;
    }

    var sslEnable = false;


    function getHttpObj(actionName)
    {
        var httpObj = getXmlHttp();
        var URL = "http://127.0.0.1:21317/Service1.asmx";
        if(sslEnable)
        {
            URL = "https://127.0.0.1:18981/Service1.asmx";
        }
        httpObj.open('POST', URL, false);//同步请求数据,异步是true
        httpObj.setRequestHeader('Content-Type', 'text/xml; charset=utf-8');//设置请求头类型及编码
        //httpObj.setRequestHeader('Content-Security-Policy', 'upgrade-insecure-requests');
        //httpObj.setRequestHeader('Access-Control-Allow-Origin', '*');
        httpObj.setRequestHeader('SOAPAction', 'http://tempuri.org/' + actionName);//设置Action
        //httpObj.setRequestHeader('If-Modified-Since', '0');
        httpObj.setRequestHeader('Cache-Control', 'no-cache');
        //httpObj.setRequestHeader('Connection', 'keey-alive');
        //httpObj.setRequestHeader('Keep-Alive', '600');
        return httpObj;
    }

    function getRequestData(actionName, actionObj)
    {
        var data = '<?xml version="1.0" encoding="utf-8"?>';
        
      data += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
      data += '<soap:Body>';

        
        if(actionObj != null)
        {
            data += '<' + actionName + ' xmlns="http://tempuri.org">';
            for(items in actionObj)
            {
                data += '<' + items + '>' + actionObj[items] + '</' + items + '>';  
            }
            data += '</' + actionName + '>';
        }
        else
        {
            data += '<' + actionName + ' xmlns="http://tempuri.org" />';
        }
        data += '</soap:Body>';
        data += '</soap:Envelope>';
        return data;
    }

    function getResponseData(actionName, response)
    {
        var parseXml;
        var xmlDoc;
        var ret;
        if (typeof window.DOMParser != "undefined") 
        {    
            parseXml = new window.DOMParser();
            xmlDoc = parseXml.parseFromString(response, "text/xml");
            
            if(actionName == 'SZCAInit')
            {
                ret = xmlDoc.getElementsByTagName('bInit')[0].textContent;
            }
            else if(actionName == 'SZCAKeyIsExist')
            {
                ret = xmlDoc.getElementsByTagName('isExist')[0].textContent;
            }
            else if(actionName == 'SZCASign')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAGetCertData')
            {
                ret = xmlDoc.getElementsByTagName('certData')[0].textContent;
            }    
            else if(actionName == 'SZCAGetCertInfo')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
            }
            else if(actionName == 'SZCAVerify')
            {
                ret = xmlDoc.getElementsByTagName('bVerify')[0].textContent;
            }
            else if(actionName == 'SZCASignMessage')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAVerifyMessage')
            {
                ret = xmlDoc.getElementsByTagName('bVerify')[0].textContent;
            }
            else if(actionName == 'SZCAParseSignMessage')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
            }
            else if(actionName == 'SZCAParseCertData')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
            }
            else if(actionName == 'SZCAVerifyUserPin')
            {
                ret = xmlDoc.getElementsByTagName('bPass')[0].textContent;
            }
            else if(actionName == 'SZCAGetKeyAlgType')
            {
                ret = xmlDoc.getElementsByTagName('algType')[0].textContent;
            }
            else if(actionName == 'SZCAGetKey')
            {
                ret = xmlDoc.getElementsByTagName('keyData')[0].textContent;
            }
            else if(actionName == 'SZCASymmEncryptData')
            {
                ret = xmlDoc.getElementsByTagName('cipherData')[0].textContent;
            }
            else if(actionName == 'SZCASymmDecryptData')
            {
                ret = xmlDoc.getElementsByTagName('originalData')[0].textContent;
            }
            else if(actionName == 'SZCASymmEncryptFile')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCASymmDecryptFile')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCAEnvelopData')
            {
                ret = xmlDoc.getElementsByTagName('cipherData')[0].textContent;
            }
            else if(actionName == 'SZCADevelopData')
            {
                ret = xmlDoc.getElementsByTagName('originalData')[0].textContent;
            }
            else if(actionName == 'SZCASetTimeStamp')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCASetTimeStampEnable')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCASetTimeStampFailedReturn')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCAGetLastErrMsg')
            {
                ret = xmlDoc.getElementsByTagName('errMsg')[0].textContent;
            }
            else if(actionName == 'SZCAGetLastErrCode')
            {
                ret = xmlDoc.getElementsByTagName('errCode')[0].textContent;
            }
            else if(actionName == 'SZCAClearPINCache')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCAGetOcxVersion')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
            }
            else if(actionName == 'SZCAGetClientVersion')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
            }
            else if(actionName == 'SZCASetSymmAlg')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCASignByB64')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCASignMessageByB64')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCASetUserPINStrong')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            ///////////////////////////////
            else if(actionName == 'SZCAGetKeySeriesNumber')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
            }
            else if(actionName == 'SZCAGetEncCertBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAGetCertList')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAVerifyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCACreateSymmKeyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCASymmEncryptFileBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCAEnveEncryptDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAEnveDecryptDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCASymmDecryptFileBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCASignMessageBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCALoginKeyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bPass')[0].textContent;
            }
            else if(actionName == 'SZCAIsLoginBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
            }
            else if(actionName == 'SZCAGetImageBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAGetCertDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            else if(actionName == 'SZCAGetItemDataByCertData')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
            }
            //////////////////
            return ret;
        } 
        else if (typeof window.ActiveXObject != "undefined" &&
           new window.ActiveXObject("Microsoft.XMLDOM")) 
        {
            xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
            xmlDoc.async = false;
            var loadSucc = xmlDoc.loadXML(response);        
            if(actionName == 'SZCAInit')
            {
                ret = xmlDoc.getElementsByTagName('bInit')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bInit')[0].text;
                }
            }
            else if(actionName == 'SZCAKeyIsExist')
            {
                ret = xmlDoc.getElementsByTagName('isExist')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('isExist')[0].text;
                }
            }
            else if(actionName == 'SZCASign')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAGetCertData')
            {
                ret = xmlDoc.getElementsByTagName('certData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('certData')[0].text;
                }
            }    
            else if(actionName == 'SZCAGetCertInfo')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('infoData')[0].text;
                }
            }
            else if(actionName == 'SZCAVerify')
            {
                ret = xmlDoc.getElementsByTagName('bVerify')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bVerify')[0].text;
                }
            }
            else if(actionName == 'SZCASignMessage')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAVerifyMessage')
            {
                ret = xmlDoc.getElementsByTagName('bVerify')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bVerify')[0].text;
                }
            }
            else if(actionName == 'SZCAParseSignMessage')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('infoData')[0].text;
                }
            }
            else if(actionName == 'SZCAParseCertData')
            {
                ret = xmlDoc.getElementsByTagName('infoData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('infoData')[0].text;
                }
            }
            else if(actionName == 'SZCAVerifyUserPin')
            {
                ret = xmlDoc.getElementsByTagName('bPass')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bPass')[0].text;
                }
            }
            else if(actionName == 'SZCAGetKeyAlgType')
            {
                ret = xmlDoc.getElementsByTagName('algType')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('algType')[0].text;
                }
            }
            else if(actionName == 'SZCAGetKey')
            {
                ret = xmlDoc.getElementsByTagName('keyData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('keyData')[0].text;
                }
            }
            else if(actionName == 'SZCASymmEncryptData')
            {
                ret = xmlDoc.getElementsByTagName('cipherData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('cipherData')[0].text;
                }
            }
            else if(actionName == 'SZCASymmDecryptData')
            {
                ret = xmlDoc.getElementsByTagName('originalData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('originalData')[0].text;
                }
            }
            else if(actionName == 'SZCASymmEncryptFile')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCASymmDecryptFile')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCAEnvelopData')
            {
                ret = xmlDoc.getElementsByTagName('cipherData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('cipherData')[0].text;
                }
            }
            else if(actionName == 'SZCADevelopData')
            {
                ret = xmlDoc.getElementsByTagName('originalData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('originalData')[0].text;
                }
            }
            else if(actionName == 'SZCASetTimeStamp')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCASetTimeStampEnable')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCASetTimeStampFailedReturn')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCAGetLastErrMsg')
            {
                ret = xmlDoc.getElementsByTagName('errMsg')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('errMsg')[0].text;
                }
            }
            else if(actionName == 'SZCAGetLastErrCode')
            {
                ret = xmlDoc.getElementsByTagName('errCode')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('errCode')[0].text;
                }
            }
            else if(actionName == 'SZCAClearPINCache')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCAGetOcxVersion')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('verString')[0].text;
                }
            }
            else if(actionName == 'SZCAGetClientVersion')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('verString')[0].text;
                }
            }
            else if(actionName == 'SZCASetSymmAlg')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCASignByB64')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCASignMessageByB64')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCASetUserPINStrong')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            
            //////////////////////////////////////
            else if(actionName == 'SZCAGetKeySeriesNumber')
            {
                ret = xmlDoc.getElementsByTagName('verString')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('verString')[0].text;
                }
            }
            else if(actionName == 'SZCAGetEncCertBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAGetCertList')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAVerifyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCACreateSymmKeyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCASymmEncryptFileBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCAEnveEncryptDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAEnveDecryptDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCASymmDecryptFileBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCASignMessageBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCALoginKeyBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bPass')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bPass')[0].text;
                }
            }
            else if(actionName == 'SZCAIsLoginBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('bSucc')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('bSucc')[0].text;
                }
            }
            else if(actionName == 'SZCAGetImageBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAGetCertDataBySignSN')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            else if(actionName == 'SZCAGetItemDataByCertData')
            {
                ret = xmlDoc.getElementsByTagName('outData')[0].textContent;
                if(ret == undefined)
                {
                    ret = xmlDoc.getElementsByTagName('outData')[0].text;
                }
            }
            //////////////////////////////////////
            return ret;
        } 
        else 
        {
            throw new Error("No XML parser found");
        }    
    }

    function NotifyClient() {
        alert("您没有安装SZCA客户端软件或您的客户端软件版本较低！");
    }

    function SZCASSLEnable(bEnable)
    {
        sslEnable = bEnable;
    }
        
    function SZCAInit()
    {
        var xmlHttp = getHttpObj('SZCAInit');
        var data = getRequestData('SZCAInit', null);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {    var retValue = getResponseData('SZCAInit', xmlHttp.response);
                if(parseInt(retValue) != 0)
                {
                    return true;
                }
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAInit', xmlHttp.responseText);
                if(parseInt(retValue) != 0)
                {
                    return true;
                }
            }
            
        }
        else
        {
            NotifyClient();
        }
        return false;
    }
        
    function SZCAKeyIsExist()
    {
        var xmlHttp = getHttpObj('SZCAKeyIsExist');
        var data = getRequestData('SZCAKeyIsExist', null);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAKeyIsExist', xmlHttp.response);
                if(parseInt(retValue) != 0)
                {
                    return true;
                }
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAKeyIsExist', xmlHttp.responseText);
                if(parseInt(retValue) != 0)
                {
                    return true;
                }
            }
            
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASign(inData)
    {
        var xmlHttp = getHttpObj('SZCASign');
        var obj = new Object();
        var inDataB64 = base64encode(utf16to8(inData));
        obj.inData = inDataB64;
        var data = getRequestData('SZCASign', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASign', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASign', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASignByB64(inData)
    {
        var xmlHttp = getHttpObj('SZCASignByB64');
        var obj = new Object();
        var inDataB64 = base64encode(utf16to8(inData));
        obj.inData = inDataB64;
        var data = getRequestData('SZCASignByB64', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASignByB64', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASignByB64', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAVerify(signedData, certData, srcData)
    {
        var xmlHttp = getHttpObj('SZCAVerify');
        var obj = new Object();
        var signedDataB64 = base64encode(utf16to8(signedData));
        var certDataB64 = base64encode(utf16to8(certData));
        var srcDataB64 = base64encode(utf16to8(srcData));    
        obj.signedData = signedDataB64;
        obj.certData = certDataB64;
        obj.srcData = srcDataB64;    
        var data = getRequestData('SZCAVerify', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAVerify', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAVerify', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASignMessage(inData, bDetach)
    {
        var xmlHttp = getHttpObj('SZCASignMessage');
        var obj = new Object();
        var inDataB64 = base64encode(utf16to8(inData));
        obj.inData = inDataB64;
        obj.bDetach = bDetach;
        var data = getRequestData('SZCASignMessage', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASignMessage', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASignMessage', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASignMessageByB64(inData, bDetach)
    {
        var xmlHttp = getHttpObj('SZCASignMessageByB64');
        var obj = new Object();
        var inDataB64 = base64encode(utf16to8(inData));
        obj.inData = inDataB64;
        obj.bDetach = bDetach;
        var data = getRequestData('SZCASignMessageByB64', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASignMessageByB64', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASignMessageByB64', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAVerifyMessage(signedData, srcData)
    {
        var xmlHttp = getHttpObj('SZCAVerifyMessage');
        var obj = new Object();
        var signedDataB64 = base64encode(utf16to8(signedData));
        var srcDataB64 = base64encode(utf16to8(srcData));
        obj.signedData = signedDataB64;
        obj.srcData = srcDataB64;
        var data = getRequestData('SZCAVerifyMessage', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAVerifyMessage', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAVerifyMessage', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetCertData(certType, dataType)
    {
        var xmlHttp = getHttpObj('SZCAGetCertData');
        var obj = new Object();
        obj.certType = certType;
        obj.dataType = dataType;
        var data = getRequestData('SZCAGetCertData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetCertData', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetCertData', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetCertInfo(infoType, infoKey)
    {
        var xmlHttp = getHttpObj('SZCAGetCertInfo');
        var obj = new Object();
        obj.infoType = infoType;
        obj.infoKey = infoKey;
        var data = getRequestData('SZCAGetCertInfo', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAGetCertInfo', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAGetCertInfo', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAParseSignMessage(signedData, nType)
    {
        var xmlHttp = getHttpObj('SZCAParseSignMessage');
        var obj = new Object();
        var signedDataB64 = base64encode(utf16to8(signedData));
        obj.signedData = signedDataB64;
        obj.nType = nType;
        var data = getRequestData('SZCAParseSignMessage', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAParseSignMessage', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAParseSignMessage', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAParseCertData(certData, nType)
    {
        var xmlHttp = getHttpObj('SZCAParseCertData');
        var obj = new Object();
        var certDataB64 = base64encode(utf16to8(certData));
        obj.certData = certDataB64;
        obj.nType = nType;
        var data = getRequestData('SZCAParseCertData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAParseCertData', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAParseCertData', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAVerifyUserPin(userPin)
    {
        var xmlHttp = getHttpObj('SZCAVerifyUserPin');
        var obj = new Object();
        var userPinB64 = base64encode(utf16to8(userPin));
        obj.userPin = userPinB64;
        var data = getRequestData('SZCAVerifyUserPin', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAVerifyUserPin', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAVerifyUserPin', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }


    function SZCAGetKeyAlgType()
    {
        var xmlHttp = getHttpObj('SZCAGetKeyAlgType');
        var data = getRequestData('SZCAGetKeyAlgType', null);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetKeyAlgType', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetKeyAlgType', xmlHttp.responseText);
                return parseInt(retValue);
            }
            
        }
        else
        {
            NotifyClient();
        }
        return false;
    }


    function SZCAGetKey()
    {
        var xmlHttp = getHttpObj('SZCAGetKey');
        var data = getRequestData('SZCAGetKey', null);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetKey', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetKey', xmlHttp.responseText);
                return retValue;
            }
            
        }
        else
        {
            NotifyClient();
        }
        return "";
    }


    function SZCASymmEncryptData(keyData, originalData)
    {
        var xmlHttp = getHttpObj('SZCASymmEncryptData');
        var obj = new Object();
        var originalDataB64 = base64encode(utf16to8(originalData));
        obj.originalData = originalDataB64;    
        var keyDataB64 = base64encode(utf16to8(keyData));
        obj.keyData = keyDataB64;
        var data = getRequestData('SZCASymmEncryptData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASymmEncryptData', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASymmEncryptData', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASymmDecryptData(keyData, cipherData)
    {
        var xmlHttp = getHttpObj('SZCASymmDecryptData');
        var obj = new Object();
        var cipherDataB64 = base64encode(utf16to8(cipherData));
        obj.cipherData = cipherDataB64;    
        var keyDataB64 = base64encode(utf16to8(keyData));
        obj.keyData = keyDataB64;
        var data = getRequestData('SZCASymmDecryptData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCASymmDecryptData', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCASymmDecryptData', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASymmEncryptFile(keyData, originalFile, cipherFile)
    {
        var xmlHttp = getHttpObj('SZCASymmEncryptFile');
        var obj = new Object();
        var originalFileB64 = base64encode(utf16to8(originalFile));
        obj.originalFile = originalFileB64;
        var cipherFileB64 = base64encode(utf16to8(cipherFile));
        obj.cipherFile = cipherFileB64;
        var keyDataB64 = base64encode(utf16to8(keyData));
        obj.keyData = keyDataB64;
        var data = getRequestData('SZCASymmEncryptFile', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASymmEncryptFile', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASymmEncryptFile', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASymmDecryptFile(keyData, cipherFile, originalFile)
    {
        var xmlHttp = getHttpObj('SZCASymmDecryptFile');
        var obj = new Object();
        var originalFileB64 = base64encode(utf16to8(originalFile));
        obj.originalFile = originalFileB64;
        var cipherFileB64 = base64encode(utf16to8(cipherFile));
        obj.cipherFile = cipherFileB64;
        var keyDataB64 = base64encode(utf16to8(keyData));
        obj.keyData = keyDataB64;
        var data = getRequestData('SZCASymmDecryptFile', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASymmDecryptFile', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASymmDecryptFile', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAEnvelopData(pubKeyData, originalData)
    {
        var xmlHttp = getHttpObj('SZCAEnvelopData');
        var obj = new Object();
        var originalDataB64 = base64encode(utf16to8(originalData));
        obj.originalData = originalDataB64;
        var pubKeyDataB64 = base64encode(utf16to8(pubKeyData));
        obj.pubKeyData = pubKeyDataB64;
        var data = getRequestData('SZCAEnvelopData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAEnvelopData', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAEnvelopData', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCADevelopData(cipherData)
    {
        var xmlHttp = getHttpObj('SZCADevelopData');
        var obj = new Object();
        var cipherDataB64 = base64encode(utf16to8(cipherData));
        obj.cipherData = cipherDataB64;
        var data = getRequestData('SZCADevelopData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCADevelopData', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCADevelopData', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASetTimeStamp(tsURL, tsUserName, tsPassword)
    {
        var xmlHttp = getHttpObj('SZCASetTimeStamp');
        var obj = new Object();
        var tsURLB64 = base64encode(utf16to8(tsURL));
        obj.tsURL = tsURLB64;
        var tsUserNameB64 = base64encode(utf16to8(tsUserName));
        obj.tsUserName = tsUserNameB64;
        var tsPasswordB64 = base64encode(utf16to8(tsPassword));
        obj.tsPassword = tsPasswordB64;
        var data = getRequestData('SZCASetTimeStamp', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetTimeStamp', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetTimeStamp', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASetTimeStampEnable(bEnable)
    {
        var xmlHttp = getHttpObj('SZCASetTimeStampEnable');
        var obj = new Object();
        obj.bEnable = bEnable;
        var data = getRequestData('SZCASetTimeStampEnable', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetTimeStampEnable', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetTimeStampEnable', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASetTimeStampFailedReturn(bReturn)
    {
        var xmlHttp = getHttpObj('SZCASetTimeStampFailedReturn');
        var obj = new Object();
        obj.bReturn = bReturn;
        var data = getRequestData('SZCASetTimeStampFailedReturn', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetTimeStampFailedReturn', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetTimeStampFailedReturn', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASetUserPINStrong(bStrong)
    {
        var xmlHttp = getHttpObj('SZCASetUserPINStrong');
        var obj = new Object();
        obj.bStrong = bStrong;
        var data = getRequestData('SZCASetUserPINStrong', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetUserPINStrong', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetUserPINStrong', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAGetLastErrMsg()
    {
        var xmlHttp = getHttpObj('SZCAGetLastErrMsg');
        var obj = new Object();
        var data = getRequestData('SZCAGetLastErrMsg', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAGetLastErrMsg', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAGetLastErrMsg', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetLastErrCode()
    {
        var xmlHttp = getHttpObj('SZCAGetLastErrCode');
        var obj = new Object();
        var data = getRequestData('SZCAGetLastErrCode', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetLastErrCode', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetLastErrCode', xmlHttp.responseText);
                return parseInt(retValue);
            }
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAClearPINCache()
    {
        var xmlHttp = getHttpObj('SZCAClearPINCache');
        var obj = new Object();
        var data = getRequestData('SZCAClearPINCache', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAClearPINCache', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAClearPINCache', xmlHttp.responseText);
                return parseInt(retValue);
            }
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAGetOcxVersion()
    {
        var xmlHttp = getHttpObj('SZCAGetOcxVersion');
        var obj = new Object();
        var data = getRequestData('SZCAGetOcxVersion', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetOcxVersion', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetOcxVersion', xmlHttp.responseText);
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetClientVersion()
    {
        var xmlHttp = getHttpObj('SZCAGetClientVersion');
        var obj = new Object();
        var data = getRequestData('SZCAGetClientVersion', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetClientVersion', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetClientVersion', xmlHttp.responseText);
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }


    function SZCASetSymmAlg(symmAlg)
    {
        var xmlHttp = getHttpObj('SZCASetSymmAlg');
        var obj = new Object();
        obj.symmAlg = symmAlg;
        var data = getRequestData('SZCASetSymmAlg', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetSymmAlg', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetSymmAlg', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASetUserPINStrong(bStrong)
    {
        var xmlHttp = getHttpObj('SZCASetUserPINStrong');
        var obj = new Object();
        obj.bStrong = bStrong;
        var data = getRequestData('SZCASetUserPINStrong', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASetUserPINStrong', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASetUserPINStrong', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }


    ///////////////////////////////////
    function SZCAGetKeySeriesNumber()
    {
        var xmlHttp = getHttpObj('SZCAGetKeySeriesNumber');
        var obj = new Object();
        var data = getRequestData('SZCAGetKeySeriesNumber', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetKeySeriesNumber', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetKeySeriesNumber', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetEncCertBySignSN(signSN)
    {
        var xmlHttp = getHttpObj('SZCAGetEncCertBySignSN');
        var obj = new Object();
        obj.signSN = signSN;
        var data = getRequestData('SZCAGetEncCertBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetEncCertBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetEncCertBySignSN', xmlHttp.responseText);
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAGetCertList()
    {
        var xmlHttp = getHttpObj('SZCAGetCertList');
        var obj = new Object();
        var data = getRequestData('SZCAGetCertList', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAGetCertList', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAGetCertList', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAVerifyBySignSN(signSN, signedStr)
    {
        var xmlHttp = getHttpObj('SZCAVerifyBySignSN');
        var obj = new Object();
        obj.signSN = (utf16to8(signSN));
        obj.signedStr = (utf16to8(signedStr));
        var data = getRequestData('SZCAVerifyBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValueB64 = getResponseData('SZCAVerifyBySignSN', xmlHttp.response);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
            catch(e)
            {
                var retValueB64 = getResponseData('SZCAVerifyBySignSN', xmlHttp.responseText);
                var retValue = utf8to16(base64decode(retValueB64));
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCACreateSymmKeyBySignSN(signSN)
    {
        var xmlHttp = getHttpObj('SZCACreateSymmKeyBySignSN');
        var obj = new Object();
        obj.signSN = (utf16to8(signSN));
        var data = getRequestData('SZCACreateSymmKeyBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCACreateSymmKeyBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCACreateSymmKeyBySignSN', xmlHttp.responseText);
                return retValue;
            }
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASymmEncryptFileBySignSN(plainFile, cipherFile, b64Key, signSN)
    {
        var xmlHttp = getHttpObj('SZCASymmDecryptFile');
        var obj = new Object();
        var plainFileB64 = base64encode(utf16to8(plainFile));
        obj.plainFile = plainFileB64;
        var cipherFileB64 = base64encode(utf16to8(cipherFile));
        obj.cipherFile = cipherFileB64;
        obj.b64Key = (utf16to8(b64Key));
        obj.signSN = (utf16to8(signSN));
        var data = getRequestData('SZCASymmEncryptFileBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASymmEncryptFileBySignSN', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASymmEncryptFileBySignSN', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAEnveEncryptDataBySignSN(plainStr, b64Cert, signSN)
    {
        var xmlHttp = getHttpObj('SZCAEnveEncryptDataBySignSN');
        var obj = new Object();
        var plainStrBase64 = base64encode(utf16to8(plainStr));
        obj.plainStr = plainStrBase64;
        obj.b64Cert = (utf16to8(b64Cert));
        obj.signSN = (utf16to8(signSN));
        var data = getRequestData('SZCAEnveEncryptDataBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAEnveEncryptDataBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAEnveEncryptDataBySignSN', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCAEnveDecryptDataBySignSN(cipherStr, signSN)
    {
        var xmlHttp = getHttpObj('SZCAEnveDecryptDataBySignSN');
        var obj = new Object();
        obj.cipherStr = (utf16to8(cipherStr));
        obj.signSN = (utf16to8(signSN));
        var data = getRequestData('SZCAEnveDecryptDataBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAEnveDecryptDataBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAEnveDecryptDataBySignSN', xmlHttp.responseText);
                return retValue;
            }
                
        }
        else
        {
            NotifyClient();
        }
        return "";
    }

    function SZCASymmDecryptFileBySignSN(cipherFile, plainFile, b64Key, signSN)
    {
        var xmlHttp = getHttpObj('SZCASymmDecryptFileBySignSN');
        var obj = new Object();
        var cipherFileB64 = base64encode(utf16to8(cipherFile));
        obj.cipherFile = cipherFileB64;
        var plainFileB64 = base64encode(utf16to8(plainFile));
        obj.plainFile = plainFileB64;
        obj.b64Key = (utf16to8(b64Key));
        obj.signSN = (utf16to8(signSN));
        var data = getRequestData('SZCASymmDecryptFileBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASymmDecryptFileBySignSN', xmlHttp.response);
                return parseInt(retValue);
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASymmDecryptFileBySignSN', xmlHttp.responseText);
                return parseInt(retValue);
            }
                
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCASignMessageBySignSN(signSN, inData, bDetach)
    {
        var xmlHttp = getHttpObj('SZCASignMessageBySignSN');
        var obj = new Object();
        var inDataB64 = base64encode(utf16to8(inData));
        obj.inData = inDataB64;
        obj.bDetach = bDetach;
        obj.signSN = utf16to8(signSN);
        var data = getRequestData('SZCASignMessageBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCASignMessageBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCASignMessageBySignSN', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCALoginKeyBySignSN(signSN, strPIN)
    {
        var xmlHttp = getHttpObj('SZCALoginKeyBySignSN');
        var obj = new Object();
        var strPINB64 = base64encode(utf16to8(strPIN));
        obj.strPIN = strPINB64;
        obj.signSN = utf16to8(signSN);
        var data = getRequestData('SZCALoginKeyBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCALoginKeyBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCALoginKeyBySignSN', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAIsLoginBySignSN(signSN)
    {
        var xmlHttp = getHttpObj('SZCAIsLoginBySignSN');
        var obj = new Object();
        obj.signSN = utf16to8(signSN);
        var data = getRequestData('SZCAIsLoginBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAIsLoginBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAIsLoginBySignSN', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAGetImageBySignSN(signSN)
    {
        var xmlHttp = getHttpObj('SZCAGetImageBySignSN');
        var obj = new Object();
        obj.signSN = utf16to8(signSN);
        var data = getRequestData('SZCAGetImageBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetImageBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetImageBySignSN', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }

    function SZCAGetCertDataBySignSN(signSN)
    {
        var xmlHttp = getHttpObj('SZCAGetCertDataBySignSN');
        var obj = new Object();
        obj.signSN = utf16to8(signSN);
        var data = getRequestData('SZCAGetCertDataBySignSN', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetCertDataBySignSN', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetCertDataBySignSN', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }


    function SZCAGetItemDataByCertData(certData, OID)
    {
        var xmlHttp = getHttpObj('SZCAGetItemDataByCertData');
        var obj = new Object();
        var certDataB64 = base64encode(utf16to8(certData));
        obj.certData = certDataB64;
        obj.OID = utf16to8(OID);
        var data = getRequestData('SZCAGetItemDataByCertData', obj);
        try
        {
            xmlHttp.send(data);
        }
        catch(e)
        {
            NotifyClient();
            return false;
        }
        if(xmlHttp.status == 200)
        {
            try
            {
                var retValue = getResponseData('SZCAGetItemDataByCertData', xmlHttp.response);
                return retValue;
            }
            catch(e)
            {
                var retValue = getResponseData('SZCAGetItemDataByCertData', xmlHttp.responseText);
                return retValue;
            }        
        }
        else
        {
            NotifyClient();
        }
        return false;
    }
    
    //SZCA Code end, szcapki.js **************************************************************************
    
    
    
    var Const_Vender_Code = "SZCA";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    
    // 1.function GetUserList() 返回当前插入的UsbKey中用户列表,格式 Name||key&&& Name||key
    // 注:Name是用于登录,选择UsbKey时,显示的名称,
    // Key为证书号或者用以取UsbKey相关数据的信息
    function GetUserList() {
        var rt = "";
        
        var certList = SZCAGetCertList();
        var certArray = certList.split(";");
        if(certArray.length > 0)
        {
            if(certArray[certArray.length-1] == "")
            {
                certArray.pop();
            }
        }
        
        for (var i = 0; i < certArray.length; i++) 
        {
            // 测试#3ed84804aeaf412f866f5eb99988dcfa#SZCA SM2 CA
            var certInfo = certArray[i];
            var infoArray = certInfo.split("#");
            
            if (i == 0) 
            {
                rt = rt + infoArray[0] + "||" + infoArray[1];
            }
            else 
            {
                rt = rt + "&&&" + infoArray[0] + "||" + infoArray[1];
            }
        }
        
        return rt;
    }

    // 2. function HashData(InData) 对传入的数据生成Hash值
    function iHashData(inData) {
        /*
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            Global_Last_Error_Msg = rtn.retMsg;
            return "";
        }
        */
        var hashResult = "";
        
        try {
            var para = {InData:inData,HashType:"SHA1"};
            $.ajax({
                url: "../CA.Ajax.Hash.cls",
                type: "POST",
                dataType: "JSON",
                async: false,
                global:false,
                data: para,
                success: function(ret) {
                    if (ret && ret.retCode == "0") {
                        hashResult = ret.hashData;
                    } else {
                        alert(ret.retMsg);
                        Global_Last_Error_Msg = rtn.retMsg;
                    }
                },
                error: function(err) {
                    alert(err);
                    Global_Last_Error_Msg = rtn.retMsg;
                }
              });
        } catch (error) {
            alert(error.message);
            Global_Last_Error_Msg = error.message;
        }
          
        return hashResult;
    }

    function SignedOrdData(content, key) {
        return SignedData(content, key);
    }

    function SignedOrdDataS(content, key, keyToken) {
        return "";
    }

    // 3. function SignedData(content, key) 对传入的数据进行签名, key 参见function 1
    function SignedData(content, key) {
        
        if ("" == content)
        {
            return "";
        }
        
        if(key=="")
        {
            return "";
        }
        
        var rt = "";
        
        var detach = false; //是否包含原文
        var withTsa = false; //是否进行时间戳签名
        
        var response = SZCASignMessageBySignSN(key, content, 0);
        /*
        var verRes = SZCAVerifyBySignSN(val, signData);
        alert("P7验签结果：" + verRes);
        
        var srcData = SZCAParseSignMessage(signData, 1);
        alert("签名原文是：" + srcData);
        
        var certData = SZCAParseSignMessage(signData, 2);
        alert("签名证书是：" + certData);
        
        var certDN = SZCAParseCertData(certData, 0x00000007);
        alert("签名值证书主题是：" + certDN);
        
        var signValue = SZCAParseSignMessage(signData, 3);
        alert("签名值是：" + signValue);
        */
        if (null == response || response.length == 0) {
            alert('PKCS7签名：失败!');
            return rt;
        }
        
        return response;
    }

    // 4. function GetSignCert(key) 获取证书pem字符串, key参见function 1
    function GetSignCert(key) 
    {
        var base64Cert = SZCAGetCertDataBySignSN(key);
        return base64Cert || "";
    }

    // 5. function GetUniqueID(cert)
    // 获取证书唯一编码,
    // 参数为Base64编码的证书
    function GetUniqueID(cert, key) 
    {
        var sOID = "1.2.156.1002";                //扩展项，身份信息加密数据
        var response = SZCAGetItemDataByCertData(cert, sOID);
        
        if (null == response || response.length == 0) {
            alert('获取证书唯一标识：失败!');
            return "";
        }
        
        return response;
    }

    // 6. function GetCertNo(key) 证书序列号hex
    function GetCertNo(key) {
        /*
        var oCert = getCertByValue(key);
        return oCert.serialNumber;
        */
        return key;
    }

    function GetSealImage(key)
    {
        var rt = "";
        
        var response = SZCAGetImageBySignSN(key);
        if (response === false) {
            alert('获取签章图片：失败!');
            return rt;
        }
        
        if (null == response || response.length == 0) {
            alert('获取签章图片：失败!');
            return rt;
        }
        
        return response;
    }

    function getCNName(certB64) {
        if (certB64 == "") return "";
        
        var ret = SZCAParseCertData(certB64, 0x00000031);
        if (ret === false) {
            alert("获取用户CN项失败");
            return "";
        }
        
        return ret;
    }

    function getIdentityID(certB64) {
        if (certB64 == "") return "";
        
        var ret = SZCAParseCertData(certB64, 0x00000033);
        if (ret === false) {
            alert("获取用户OU项失败");
            return "";
        }
        
        return ret;
    }
    
    
    // 7.获取UsbKey中的信息
    function getUsrSignatureInfo(key)
    {
        var base64Cert = GetSignCert(key);
        if(base64Cert == null || base64Cert == "")
        {
            return null;
        }
        
        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = getIdentityID(base64Cert); // 身份证号;
        usrSignatureInfo["certificate"]  =   base64Cert; // 证书; GetSignCert(key)
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        
        usrSignatureInfo["CertificateSN"] = GetCertNo(key); // 证书序列号;

        usrSignatureInfo["uKeyNo"] = ""; // 我们壳子上面没有Key的编号,有客户的名字是否可以?
        usrSignatureInfo["signImage"] = GetSealImage(key); // sealArry[0]; // 签名图是否指的是电子印章/或手写签名图片?
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(base64Cert, key); // 证书唯一编码,由于CA公司不同,所以此处为可区别证书的编码(可为uKeyNo或CertificateNo等等)
        usrSignatureInfo["CertName"] = getCNName(base64Cert); // 证书中文名;

        return usrSignatureInfo;
    }

    function Login(form, key, pwd, forceCheck) {
        
        if ((SOF_IsLogin(key)) && (pwd == "") && (!forceCheck)) {
            return true;
        }
        
        if(pwd=="")
        {
         alert("请输入密码");
         return false;
        }
        
        var response = SZCALoginKeyBySignSN(key,pwd);
        if (null == response || response.length == 0) {
            alert('证书登录：失败!');
            return false;
        }
        
        if (0 != response) {
            alert('证书登录：失败!\n返回结果:\n' + response);
            return false;
        }
        
        //以下三个已经赋值
        //strServerRan  随机数
        //strServerSignedData 服务器对随机数的签名 
        //strServerCert 服务器证书
        return true;
    }
    
    function SOF_IsLogin(strKey) {
        var ret = SZCAIsLoginBySignSN(strKey);
        ret = ret || "";
        if (ret == 0) {
            return true;
        } else {
            return false;
        }
    }
    
    return {
        OCX: "",
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetRealKey: function(key) {
            return key;
        },
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        IsLogin: function(strKey) {
            if ('undefined' != SOF_IsLogin) {
                return SOF_IsLogin(strKey);
            }
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert,key) {
            return GetUniqueID(cert,key);
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        SignedData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedOrdData: function(contentHash, key) {
            return SignedOrdData(contentHash, key)
        },
        SignedOrdDataS: function(contentHash, key) {
            return SignedOrdDataS(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
            return iHashData(content);
        }
    }
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin) {
    return ca_key.Login(strFormName, key, pin);
}
///是否登陆过
function IsLogin(key) {
    return ca_key.IsLogin(key);
}
function SOF_IsLogin(key) {
    return ca_key.IsLogin(key);
}

///2.证书列表
///获取证书列表
function GetUserList() {
    return ca_key.GetUserList();
}
function GetList_pnp() {
    return ca_key.GetUserList();
}
function getUserList2() {
    return ca_key.GetUserList();
}
function getUserList_pnp() {
    return ca_key.GetUserList();
}

///3.证书信息
///获取containerName
function GetRealKey(key) {
    return ca_key.GetRealKey(key);
}
///获取证书base64编码
function GetSignCert(key) {
    return ca_key.GetSignCert(key);
}
///获取CA用户唯一标识
function GetUniqueID(cert, key) {
    return ca_key.GetUniqueID(cert, key);
}
///获取证书唯一标识
function GetCertNo(key) {
    return ca_key.GetCertNo(key);
}
///获取证书信息集合
function getUsrSignatureInfo(key) {
    return ca_key.getUsrSignatureInfo(key);
}

///4.签名相关
///对待签数据做Hash
function HashData(content){
    return ca_key.HashData(content) 
}
///对待签数据的Hash值做签名
function SignedData(contentHash, key) {
    return ca_key.SignedData(contentHash, key)
}
function SignedOrdData(contentHash, key) {
    return ca_key.SignedOrdData(contentHash, key)
}
function SignedOrdDataS(contentHash, key) {
    return ca_key.SignedOrdDataS(contentHash, key)
}