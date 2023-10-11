var ca_key = (function() {
    var Const_Vender_Code = "FAKE";
    var Const_Sign_Type = "UKEY";

	function GetUserList(){
		var userList = "测试证书YS01||8A1D45A5C4E189B7&&&测试证书HS01||A8B9D7A20C12A401&&&测试证书PIVAS||2D288A905F5546FE&&&测试证书YF01||AFFA43DCF38B1346"
        userList = userList + "&&&测试证书HS02||5F68CEE9CA7543D0&&&测试证书YS02||76ECA42E894F4D1D&&&测试证书ZYYS01||3DAE643A0047406A"
        userList = userList + "&&&测试证书LIS01||716ED190BD3B47B0&&&测试证书LIS02||7A4664E5090C4352"
		return userList;
	}

	function HashData(inData){
		return b64_sha1(inData);
	}
	function SignedData(content,key){
		return b64_sha1(content);
	}

	function GetSignCert(key){
		if (key == "8A1D45A5C4E189B7") {
			return "FAKECERT1"
		}
		if (key == "A8B9D7A20C12A401") {
			return "FAKECERT2"
		}
        if (key == "2D288A905F5546FE") {
			return "FAKECERT3"
		}
        if (key == "AFFA43DCF38B1346") {
			return "FAKECERT4"
		}
        if (key == "5F68CEE9CA7543D0") {
			return "FAKECERT5"
		}
		if (key == "76ECA42E894F4D1D") {
			return "FAKECERT6"
		}
        if (key == "3DAE643A0047406A") {
			return "FAKECERT7"
		}
        if (key == "716ED190BD3B47B0") {
			return "FAKECERT8"
		}
        if (key == "7A4664E5090C4352") {
			return "FAKECERT9"
		}
        return ""
	}

	function GetUniqueID(cert) {
		if (cert == "FAKECERT1") {
			return "SF12345678901234567X"
		}
		if (cert == "FAKECERT2") {
			return "SF22345678901234567X"
		}
        if (cert == "FAKECERT3") {
			return "SF32345678901234567X"
		}
        if (cert == "FAKECERT4") {
			return "SF42345678901234567X"
		}
        if (cert == "FAKECERT5") {
			return "SF52345678901234567X"
		}
		if (cert == "FAKECERT6") {
			return "SF62345678901234567X"
		}
        if (cert == "FAKECERT7") {
			return "SF72345678901234567X"
		}
        if (cert == "FAKECERT8") {
			return "SF82345678901234567X"
		}
        if (cert == "FAKECERT9") {
			return "SF92345678901234567X"
		}
        return ""
	}

	function GetIdentityID(key)
	{
		if (key == "8A1D45A5C4E189B7") {
			return "12345678901234567X"
		}
		if (key == "A8B9D7A20C12A401") {
			return "22345678901234567X"
		}
        if (key == "2D288A905F5546FE") {
			return "32345678901234567X"
		}
        if (key == "AFFA43DCF38B1346") {
			return "42345678901234567X"
		}
        if (key == "5F68CEE9CA7543D0") {
			return "52345678901234567X"
		}
		if (key == "76ECA42E894F4D1D") {
			return "62345678901234567X"
		}
        if (key == "3DAE643A0047406A") {
			return "72345678901234567X"
		}
        if (key == "716ED190BD3B47B0") {
			return "82345678901234567X"
		}
        if (key == "7A4664E5090C4352") {
			return "92345678901234567X"
		}
        return ""
	}

	function GetCertNo(key) {
		return key;
	}

	function GetCertSN(key) {
		return key;
	}

	function GetKeySN(key) {
		return key;
	}

	function GetPicBase64Data(key) {
		if (key == "8A1D45A5C4E189B7") {
			return "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";
		} 
        else if (key == "A8B9D7A20C12A401") {
			return "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"
		} 
        else if (key == "2D288A905F5546FE") {
			return "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";
        }
        else if (key == "AFFA43DCF38B1346") {
			return "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";
        }
        else if (key == "5F68CEE9CA7543D0") {
			return "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"
		} 
        else if (key == "76ECA42E894F4D1D") {
			return "iVBORw0KGgoAAAANSUhEUgAAAL4AAAA6CAIAAACBN3QEAAAIlklEQVR4Ae1bC5arKBCl57zVtFlOm1lOm+U808sxvR3n4qe4FGgETX8m5OR0K1L/SwEleen73pRP8UC6B/5JJykUxQPWAwU6BQeZHijQyXRcISvQKRjI9ECBTqbjClmBTsFApgcKdDIdV8gKdAoGMj1QoJPpuEJWoFMwkOmBAp1MxxWyAp2CgUwP/FLo3MzpxbwM3/PF3DKNL2R7PPDyW9+cX8/mfJ0tr03fztfl/xd54JdmHWNeK+ehiq5da7l6rAf+5LO/Xc3nQP36ar4+eNWr0xwKhB9JS9CtfjfvddjlF7Tcxsm4Mgmj4+Zm8IfGBRNW5gezhJFv1TddJp9Msq6vZulx0V2vNExSsGv6qpq/zaKObT33QedYt3bg4xwFnau+bvp1ZbrWsvWoTF+3i2rYB13f1JrEcqj6dl3YKtflh2b50d0niA2bV98lcB062NnYb75Vd6EDadQHToyG1umkrnzaeNTW+yj/zEAXQCzZDjhKH3VRLTjZQi3gz7RptitXxG/3QGfg6OxcsMrJ7XoMQQ9tg7V3BpOj968obC6uENHarxtmFL9U9znTFmC31oHUkxDq6Fak52wc8wQhsFIjsREsIla0GmohFVjFc/MsN/3/buhAJFKIDZgL16BGN7Uji4a5d/QmLGxc2BOVp9hANIadAiUjctSBWzYJIxFQWGu6+rThfExTBvQcbZ88oOY4/6kLtj/5uvbBDJ6X4VKOg1KDH23ywFqnI6AT5a9Gz+QvLImQEvZZAHIEAAmMYxC9TsZKYAlboYb7yiM1UapIYxXltPUTD0daiQNyHRUleI8btU+m+PhWmgTmJjU8DDpKCxkZmeFcncsFjp4f/agofbbe+q7nxCMWIaLcDs531WBaF04GR0x5BpZIZFbSyNYxlZPFPTKvv6quU89746vU8ZK2xrXpOtPUBnzqxrSdvZX96ms9VQd4x44NuXRIEuV1rrxd/eUyPbxdjNhRNWY2ziOdblC5CJux2Z6/U4XDmNtY6hg6V7AooHojMeLG9860rWka07RxNaKVi4B3TkMm5FLJJL3rPJzKSPpTPpDRxsNdGoUi84IESYJZH+ushpDclc7pIZ6bKS1tdyOz/SlZByPvdJq+FxmDOfB9AA2S01Fcg8RzN+VUb17OOJ9djW6jUpKkvf6UwKZSofc4dnMz19vcXpm3MJXNDzP+3x0MsQ5h9Sk2NzOlZJ34eOKuG68pGUiCESnbB+UmaSTLrVWHDbOIVnxEk6n/sD9QfdTteiaznVmNcEWs2A23rMbBPulT1jpAOiZ7+8r6ZBo/zWQsLMBt69BJHxGY4LEawHAf367jr3tXms4NOST6HmNllVNj/cFD/GaaQZlN7/krE3uzYqCGa//ckMkQLwrT+3uG5WskMaxG26g0bosH2GDTIPAGn7TT2wmBP2hVmUcXhKLSw0aRgmJXa2vwKJ2plKBv76XGUIhrIXHC1rPadXVXWPRwNU8IIy8imP+yni4zLfcR8bzKOTrlQMiezblYGyRPAYqZLVQrRzgRAIIHt+NGyjm2uooXRlRgtSFBy4CesTgppSNVgtszXTqjBtHbg2FfYyltB4W9Ras4E48CfwoatkPHc/gcBeFzxMUR0Amd6PSevSAt24OHqEcgMseAU9fa6OeQ7PQgswpqOXeDAXNUvRuId95g5rPTQp5bocPc0lUN5cZaUtY6a/Oe/4zrK/4Ts/JI96zNX0zPc/0DpQ6ULlDOGVKl6f7iSdonWixJY7GjN6TbclTjqY2TIdNqJHUdQ7utUKnzya2EsOo6bLPpSdpxXge1rHHfFyk6DYbJrtCTmHIDd3c77Z6VhNj6LUX2Y/pW76Z7sxUNcQ7W8vqI482WCSMDY2i/q9flNMMRTFA+3enARXmPyToi7qFHjUTKyoUr0R5d1VgRClyM+8f4FrIyfxuinsHNvvoUZFFHvuTO3I401ggtBB29qyJZR0Bn+xxEgr/o8mPenX7lbIX5whVLJZBkseexOZdw8naIJ6rbh8tV3Fm6oFbJNQjMj5HUJb33XuyAjjIP502Re1G3sB+eufequIOeaqlRX+9gfTwpV5DlFRWLkWGARg98Qyf4/9S47k33oCWOiNgBHeGBC+TJ07Diax+YIVngwjWwcrXfcb64/OuGKQdmgfiwZp5Nrh8Rtt6ok2HGL0+u5qLSFQ0DjEz1SsHi5uwEYWn8/siEM0qKbbu2tak6h5RwRupxGyn7dtmcjwckUH3B6dKpQjMcAUZ72of2n0xqt/TzBl5KcCuVkgShJBGcWahiIsaOCnj1G3T1+YiL7JOGqpp+KWGtvkevRb0Nv1Lr4NsddR1XYxhCpVw5QaceDpX6RyRdRFWMl+sZEaspAEo0YrOuW4TbliaSuA4dMFMK2PLxeGwyKA8q5T3C8WScKgj5kNKycCJxOGIb/7vvkJ3vpGzo+EgfBxZGvD19vAAUW98bCr5IMKNhkzfn2+2VZWsDBVJ53z4l9fSgt4+zPiTxLnRYvcWhEj0v7EsJaZU5XqJSQzG45QyX5QImyoUOz1ZSEuVGazNeNSDr8CFzFr3zWlwcjMKRMZSx0g8cZyJxCEkEr8oiOlEfIgCjaEU3vJILSeDPkET7PIAL8zkUOrk/HJYfyGEdrypaUzEj6VdnboWXcHV+GWpflXdiMIE+vSvXaXgtvM4Jy/ZPrNzHTvg94auxxxrXafAU6+KP+bQNqN5MvUDDWt3hemRQcqEDw8aSKDaBX7CYj3pkgk6A3Wjn0ni0B7JfRGCsI6f+gM/20f8DlP0/qXBQXedbXDKWan7Cm6lvMf+7hWZPWN+teJH/3R74zVnnu3335PILdJ4cAPnmF+jk++7JKQt0nhwA+eYX6OT77skpC3SeHAD55hfo5PvuySkLdJ4cAPnmF+jk++7JKQt0nhwA+eYX6OT77skpC3SeHAD55v8HS9Ij8RMuBH8AAAAASUVORK5CYII="
        }
        else if (key == "3DAE643A0047406A") {
			return "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";
        }
        else if (key == "716ED190BD3B47B0") {
			return "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"
		} 
        else if (key == "7A4664E5090C4352") {
			return "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";
        }
        else {
			return "";
		}
	}

	function GetCertCNName(key) {
		if (key == "8A1D45A5C4E189B7") {
			return "测试证书YS01"
		}
		if (key == "A8B9D7A20C12A401") {
			return "测试证书HS01"
		}
        if (key == "2D288A905F5546FE") {
			return "测试证书PIVAS"
		}
        if (key == "AFFA43DCF38B1346") {
			return "测试证书YF01"
		}
        if (key == "5F68CEE9CA7543D0") {
			return "测试证书HS02"
		}
		if (key == "76ECA42E894F4D1D") {
			return "测试证书YS02"
		}
        if (key == "3DAE643A0047406A") {
			return "测试证书ZYYS01"
		}
        if (key == "716ED190BD3B47B0") {
			return "测试证书LIS01"
		}
        if (key == "7A4664E5090C4352") {
			return "测试证书LIS02"
		}
        return ""
	}

	function Login(form, key, password) {
		if (password != "123456")
		{
			alert("密码错误！");
			return 0;
		}
		
		return 1;
	}

	function CheckPWD(strCertID, strPin) {
	    if (strCertID == null || strCertID == "") {
	        return "获取用户信息失败";
	    }
	    if (strPin == null || strPin == "") {
	        return "请输入证书密码";
	    }
	    if (strPin.length < 6 || strPin.length > 16) {
	        return "密码长度应该在4-16位之间";
	    }

	    if (password != "123456")
		{
			return "密码错误";
		}
		
	    return "";
	}

	//校验随机数
	function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {

	    var result = {};

	    result.errMsg = '';
	    result.UserSignedData = '';
	    result.UserCert = '';
	    result.ContainerName = '';
   
	    return result;
	}
	
	function getUsrSignatureInfo(key){
		var usrSignatureInfo = new Array();
		usrSignatureInfo["identityID"] = GetIdentityID(key);
		usrSignatureInfo["certificate"] = GetSignCert(key);
		usrSignatureInfo["certificateNo"] = GetCertNo(key);
		usrSignatureInfo["CertificateSN"] = GetCertSN(key);
		usrSignatureInfo["uKeyNo"] = GetKeySN(key);
		usrSignatureInfo["signImage"] = GetPicBase64Data(key);
		var certB64 = GetSignCert(key);
		usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64);
		usrSignatureInfo["CertName"] = GetCertCNName(key);
		return usrSignatureInfo;
	}

	/* 
	 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined 
	 * in FIPS PUB 180-1 
	 * Version 2.1-BETA Copyright Paul Johnston 2000 - 2002. 
	 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet 
	 * Distributed under the BSD License 
	 * See http://pajhome.org.uk/crypt/md5 for details. 
	 */
	/* 
	 * Configurable variables. You may need to tweak these to be compatible with 
	 * the server-side, but the defaults work in most cases. 
	 */
	var hexcase = 0; /* hex output format. 0 - lowercase; 1 - uppercase             */
	var b64pad = ""; /* base-64 pad character. "=" for strict RFC compliance     */
	var chrsz = 8; /* bits per input character. 8 - ASCII; 16 - Unicode         */

	/* 
	 * These are the functions you'll usually want to call 
	 * They take string arguments and return either hex or base-64 encoded strings 
	 */
	function hex_sha1(s) {
		return binb2hex(core_sha1(str2binb(s), s.length * chrsz));
	}

	function b64_sha1(s) {
		return binb2b64(core_sha1(str2binb(s), s.length * chrsz));
	}

	function str_sha1(s) {
		return binb2str(core_sha1(str2binb(s), s.length * chrsz));
	}

	function hex_hmac_sha1(key, data) {
		return binb2hex(core_hmac_sha1(key, data));
	}

	function b64_hmac_sha1(key, data) {
		return binb2b64(core_hmac_sha1(key, data));
	}

	function str_hmac_sha1(key, data) {
		return binb2str(core_hmac_sha1(key, data));
	}

	/* 
	 * Perform a simple self-test to see if the VM is working 
	 */
	function sha1_vm_test() {
		return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
	}

	/* 
	 * Calculate the SHA-1 of an array of big-endian words, and a bit length 
	 */
	function core_sha1(x, len) {
		/* append padding */
		x[len >> 5] |= 0x80 << (24 - len % 32);
		x[((len + 64 >> 9) << 4) + 15] = len;

		var w = Array(80);
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var e = -1009589776;

		for (var i = 0; i < x.length; i += 16) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			var olde = e;

			for (var j = 0; j < 80; j++) {
			if (j < 16) w[j] = x[i + j];
			else w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
			var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
			e = d;
			d = c;
			c = rol(b, 30);
			b = a;
			a = t;
			}

			a = safe_add(a, olda);
			b = safe_add(b, oldb);
			c = safe_add(c, oldc);
			d = safe_add(d, oldd);
			e = safe_add(e, olde);
		}
		return Array(a, b, c, d, e);

	}

	/* 
	 * Perform the appropriate triplet combination function for the current 
	 * iteration 
	 */
	function sha1_ft(t, b, c, d) {
		if (t < 20) return (b & c) | ((~b) & d);
		if (t < 40) return b ^ c ^ d;
		if (t < 60) return (b & c) | (b & d) | (c & d);
		return b ^ c ^ d;
	}

	/* 
	 * Determine the appropriate additive constant for the current iteration 
	 */
	function sha1_kt(t) {
		return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 : (t < 60) ? -1894007588 : -899497514;
	}

	/* 
	 * Calculate the HMAC-SHA1 of a key and some data 
	 */
	function core_hmac_sha1(key, data) {
		var bkey = str2binb(key);
		if (bkey.length > 16) bkey = core_sha1(bkey, key.length * chrsz);

		var ipad = Array(16),
			opad = Array(16);
		for (var i = 0; i < 16; i++) {
			ipad[i] = bkey[i] ^ 0x36363636;
			opad[i] = bkey[i] ^ 0x5C5C5C5C;
		}

		var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
		return core_sha1(opad.concat(hash), 512 + 160);
	}

	/* 
	 * Add integers, wrapping at 2^32. This uses 16-bit operations internally 
	 * to work around bugs in some JS interpreters. 
	 */
	function safe_add(x, y) {
		var lsw = (x & 0xFFFF) + (y & 0xFFFF);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return (msw << 16) | (lsw & 0xFFFF);
	}

	/* 
	 * Bitwise rotate a 32-bit number to the left. 
	 */
	function rol(num, cnt) {
		return (num << cnt) | (num >>> (32 - cnt));
	}

	/* 
	 * Convert an 8-bit or 16-bit string to an array of big-endian words 
	 * In 8-bit function, characters >255 have their hi-byte silently ignored. 
	 */
	function str2binb(str) {
		var bin = Array();
		var mask = (1 << chrsz) - 1;
		for (var i = 0; i < str.length * chrsz; i += chrsz)
		bin[i >> 5] |= (str.charCodeAt(i / chrsz) & mask) << (24 - i % 32);
		return bin;
	}

	/* 
	 * Convert an array of big-endian words to a string 
	 */
	function binb2str(bin) {
		var str = "";
		var mask = (1 << chrsz) - 1;
		for (var i = 0; i < bin.length * 32; i += chrsz)
		str += String.fromCharCode((bin[i >> 5] >>> (24 - i % 32)) & mask);
		return str;
	}

	/* 
	 * Convert an array of big-endian words to a hex string. 
	 */
	function binb2hex(binarray) {
		var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
		var str = "";
		for (var i = 0; i < binarray.length * 4; i++) {
			str += hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8 + 4)) & 0xF) + hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8)) & 0xF);
		}
		return str;
	}

	/* 
	 * Convert an array of big-endian words to a base-64 string 
	 */
	function binb2b64(binarray) {
		var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		var str = "";
		for (var i = 0; i < binarray.length * 4; i += 3) {
			var triplet = (((binarray[i >> 2] >> 8 * (3 - i % 4)) & 0xFF) << 16) | (((binarray[i + 1 >> 2] >> 8 * (3 - (i + 1) % 4)) & 0xFF) << 8) | ((binarray[i + 2 >> 2] >> 8 * (3 - (i + 2) % 4)) & 0xFF);
			for (var j = 0; j < 4; j++) {
			if (i * 8 + j * 6 > binarray.length * 32) str += b64pad;
			else str += tab.charAt((triplet >> 6 * (3 - j)) & 0x3F);
			}
		}
		return str;
	}

	return {
    	OCX: "",
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return key;
    	},
        CheckPWD: function(key, pwd) {
            return CheckPWD(key, pwd);
        },
        CheckForm: function(key, strServerCert, strServerRan, strServerSignedData) {
            return CheckForm(key, strServerCert, strServerRan, strServerSignedData);
        },
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        IsLogin: function(strKey) {
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
		getUserList2: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert, key) {
            return GetUniqueID(cert, key);
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        SignedData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedOrdData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content)  
	    },
	  	GetPicBase64Data:function(key) {
	    	return GetPicBase64Data(key);
		},
		GetLastError:function() {
	    	return "";
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
function GetUniqueID(cert,key) {
	return ca_key.GetUniqueID(cert,key);
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

///5.其他
function CheckPWD(key, pin) {
    return ca_key.CheckPWD(key, pin);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}
function GetLastError() {
    return ca_key.GetLastError();
}
