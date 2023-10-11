var ca_key = (function() {  
    //常量定义
    var Const_Vender_Code = "HuNCA";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    try {
        if (window.ActiveXObject || "ActiveXObject" in window) {
            HWPostil1obj = document.createElement("object");
            HWPostil1obj.setAttribute("width",1);
            HWPostil1obj.setAttribute("height",1);
            HWPostil1obj.setAttribute("id","HWPostil1");
            HWPostil1obj.setAttribute("name","HWPostil1");
            HWPostil1obj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HWPostil1obj.setAttribute("classid","clsid:FF1FE7A0-0578-4FEE-A34E-FB21B277D561");
        } else {
            HWPostil1obj = document.createElement("embed");
            HWPostil1obj.setAttribute("width",1);
            HWPostil1obj.setAttribute("height",1);
            HWPostil1obj.setAttribute("id","HWPostil1");
            HWPostil1obj.setAttribute("name","HWPostil1");
            HWPostil1obj.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
            HWPostil1obj.setAttribute("type","application/x-itst-activex");
            HWPostil1obj.setAttribute("clsid","{FF1FE7A0-0578-4FEE-A34E-FB21B277D561}");
        }
        document.documentElement.appendChild(HWPostil1obj);
    } catch (e) {
        alert("请检查证书应用环境是否正确安装!");
    }

    var token = new mToken("mTokenPlugin");

    try {
        var ret = token.SOF_LoadLibrary(1);
        if (ret != 0) {
            alert("加载控件失败,错误码:" + token.SOF_GetLastError());
        }
    } catch (e) {
        alert("加载控件失败!");
    }

    //////////////////////////////////////CA支撑函数//////////////////////////////////////////
    var split;
    // Avoid running twice; that would break the `nativeSplit` reference
    split = split || function (undef) {

        var nativeSplit = String.prototype.split,
            compliantExecNpcg = /()??/.exec("")[1] === undef, // NPCG: nonparticipating capturing group
            self;

        self = function (str, separator, limit) {
            // If `separator` is not a regex, use `nativeSplit`
            if (Object.prototype.toString.call(separator) !== "[object RegExp]") {
                return nativeSplit.call(str, separator, limit);
            }
            var output = [],
                flags = (separator.ignoreCase ? "i" : "") +
                        (separator.multiline ? "m" : "") +
                        (separator.extended ? "x" : "") + // Proposed for ES6
                        (separator.sticky ? "y" : ""), // Firefox 3+
                lastLastIndex = 0,
                // Make `global` and avoid `lastIndex` issues by working with a copy
                separator = new RegExp(separator.source, flags + "g"),
                separator2, match, lastIndex, lastLength;
            str += ""; // Type-convert
            if (!compliantExecNpcg) {
                // Doesn't need flags gy, but they don't hurt
                separator2 = new RegExp("^" + separator.source + "$(?!\\s)", flags);
            }
            /* Values for `limit`, per the spec:
             * If undefined: 4294967295 // Math.pow(2, 32) - 1
             * If 0, Infinity, or NaN: 0
             * If positive number: limit = Math.floor(limit); if (limit > 4294967295) limit -= 4294967296;
             * If negative number: 4294967296 - Math.floor(Math.abs(limit))
             * If other: Type-convert, then use the above rules
             */
            limit = limit === undef ?
                -1 >>> 0 : // Math.pow(2, 32) - 1
                limit >>> 0; // ToUint32(limit)
            while (match = separator.exec(str)) {
                // `separator.lastIndex` is not reliable cross-browser
                lastIndex = match.index + match[0].length;
                if (lastIndex > lastLastIndex) {
                    output.push(str.slice(lastLastIndex, match.index));
                    // Fix browsers whose `exec` methods don't consistently return `undefined` for
                    // nonparticipating capturing groups
                    if (!compliantExecNpcg && match.length > 1) {
                        match[0].replace(separator2, function () {
                            for (var i = 1; i < arguments.length - 2; i++) {
                                if (arguments[i] === undef) {
                                    match[i] = undef;
                                }
                            }
                        });
                    }
                    if (match.length > 1 && match.index < str.length) {
                        Array.prototype.push.apply(output, match.slice(1));
                    }
                    lastLength = match[0].length;
                    lastLastIndex = lastIndex;
                    if (output.length >= limit) {
                        break;
                    }
                }
                if (separator.lastIndex === match.index) {
                    separator.lastIndex++; // Avoid an infinite loop
                }
            }
            if (lastLastIndex === str.length) {
                if (lastLength || !separator.test("")) {
                    output.push("");
                }
            } else {
                output.push(str.slice(lastLastIndex));
            }
            return output.length > limit ? output.slice(0, limit) : output;
        };

        // For convenience
        String.prototype.split = function (separator, limit) {
            return self(this, separator, limit);
        };

        return self;

    }();

    function mToken(obj) {
        this.obj = obj;

        this.SAR_OK = 0;
        this.SAR_FALSE = 1;

        //分组加密算法标识
        this.SGD_SM1_ECB = 0x00000101;
        this.SGD_SM1_CBC = 0x00000102;
        this.SGD_SM1_CFB = 0x00000104;
        this.SGD_SM1_OFB = 0x00000108;
        this.SGD_SM1_MAC = 0x00000110;
        this.SGD_SSF33_ECB = 0x00000201;
        this.SGD_SSF33_CBC = 0x00000202;
        this.SGD_SSF33_CFB = 0x00000204;
        this.SGD_SSF33_OFB = 0x00000208;
        this.SGD_SSF33_MAC = 0x00000210;
        this.SGD_SM4_ECB = 0x00000401;
        this.SGD_SM4_CBC = 0x00000402;
        this.SGD_SM4_CFB = 0x00000404;
        this.SGD_SM4_OFB = 0x00000408;
        this.SGD_SM4_MAC = 0x00000410;

        this.SGD_VENDOR_DEFINED = 0x80000000;
        this.SGD_DES_ECB = this.SGD_VENDOR_DEFINED + 0x00000211
        this.SGD_DES_CBC = this.SGD_VENDOR_DEFINED + 0x00000212

        this.SGD_3DES168_ECB = this.SGD_VENDOR_DEFINED + 0x00000241
        this.SGD_3DES168_CBC = this.SGD_VENDOR_DEFINED + 0x00000242

        this.SGD_3DES112_ECB = this.SGD_VENDOR_DEFINED + 0x00000221
        this.SGD_3DES112_CBC = this.SGD_VENDOR_DEFINED + 0x00000222

        this.SGD_AES128_ECB = this.SGD_VENDOR_DEFINED + 0x00000111
        this.SGD_AES128_CBC = this.SGD_VENDOR_DEFINED + 0x00000112

        this.SGD_AES192_ECB = this.SGD_VENDOR_DEFINED + 0x00000121
        this.SGD_AES192_CBC = this.SGD_VENDOR_DEFINED + 0x00000122

        this.SGD_AES256_ECB = this.SGD_VENDOR_DEFINED + 0x00000141
        this.SGD_AES256_CBC = this.SGD_VENDOR_DEFINED + 0x00000142


        //非对称密码算法标识
        this.SGD_RSA = 0x00010000;
        this.SGD_SM2_1 = 0x00020100; //ECC签名
        this.SGD_SM2_2 = 0x00020200; //ECC密钥交换
        this.SGD_SM2_3 = 0x00020400; //ECC加密

        //密码杂凑算法标识
        this.SGD_SM3 = 0x00000001;
        this.SGD_SHA1 = 0x00000002;
        this.SGD_SHA256 = 0x00000004;
        this.SGD_RAW = 0x00000080;
        this.SGD_MD5 = 0x00000081;
        this.SGD_SHA384 = 0x00000082;
        this.SGD_SHA512 = 0x00000083;

        this.SGD_CERT_VERSION = 0x00000001;
        this.SGD_CERT_SERIAL = 0x00000002;
        this.SGD_CERT_ISSUE = 0x00000005;
        this.SGD_CERT_VALID_TIME = 0x00000006;
        this.SGD_CERT_SUBJECT = 0x00000007;
        this.SGD_CERT_DER_PUBLIC_KEY = 0x00000008;
        this.SGD_CERT_DER_EXTENSIONS = 0x00000009;
        this.SGD_CERT_NOT_BEFORE = 0x00000010;
        this.SGD_CERT_ISSUER_CN = 0x00000021;
        this.SGD_CERT_ISSUER_O = 0x00000022;
        this.SGD_CERT_ISSUER_OU = 0x00000023;
        this.SGD_CERT_ISSUER_C = 0x00000024;
        this.SGD_CERT_ISSUER_P = 0x00000025;
        this.SGD_CERT_ISSUER_L = 0x00000026;
        this.SGD_CERT_ISSUER_S = 0x00000027;
        this.SGD_CERT_ISSUER_EMAIL = 0x00000028;

        this.SGD_CERT_SUBJECT_CN = 0x00000031;
        this.SGD_CERT_SUBJECT_O = 0x00000032;
        this.SGD_CERT_SUBJECT_OU = 0x00000033;
        this.SGD_CERT_SUBJECT_EMALL = 0x00000034;
        this.SGD_REMAIN_TIME = 0x00000035;
        this.SGD_SIGNATURE_ALG = 0x00000036;
        this.SGD_CERT_SUBJECT_C = 0x00000037;
        this.SGD_CERT_SUBJECT_P = 0x00000038;
        this.SGD_CERT_SUBJECT_L = 0x00000039;
        this.SGD_CERT_SUBJECT_S = 0x0000003A;

        this.SGD_CERT_CRL = 0x00000041;
        
        this.SGD_DEVICE_SORT = 0x00000201;
        this.SGD_DEVICE_TYPE = 0x00000202;
        this.SGD_DEVICE_NAME = 0x00000203;
        this.SGD_DEVICE_MANUFACTURER = 0x00000204;
        this.SGD_DEVICE_HARDWARE_VERSION = 0x00000205;
        this.SGD_DEVICE_SOFTWARE_VERSION = 0x00000206;
        this.SGD_DEVICE_STANDARD_VERSION = 0x00000207;
        this.SGD_DEVICE_SERIAL_NUMBER = 0x00000208;
        this.SGD_DEVICE_SUPPORT_SYM_ALG = 0x00000209;
        this.SGD_DEVICE_SUPPORT_ASYM_ALG = 0x0000020A;
        this.SGD_DEVICE_SUPPORT_HASH_ALG = 0x0000020B;
        this.SGD_DEVICE_SUPPORT_STORANGE_SPACE = 0x0000020C;
        this.SGD_DEVICE_SUPPORT_FREE_SAPCE = 0x0000020D;
        this.SGD_DEVICE_RUNTIME = 0x0000020E;
        this.SGD_DEVICE_USED_TIMES = 0x0000020F;
        this.SGD_DEVICE_LOCATION = 0x00000210;
        this.SGD_DEVICE_DESCRIPTION = 0x00000211;
        this.SGD_DEVICE_MANAGER_INFO = 0x00000212;
        this.SGD_DEVICE_MAX_DATA_SIZE = 0x00000213;

        this.TRUE = 1;
        this.FALSE = 0;

        this.GM3000 = 1;
        this.SJK1137 = 2;
        this.K5 = 3;
        this.TF = 4;
        this.HT20522 = 5;

        var g_mTokenPlugin = null;
        var g_deviceNames = null;


        this.SOF_GetLastError = function () {
            if (g_mTokenPlugin == null) {
                return -1;
            }

            return g_mTokenPlugin.SOF_GetLastError();
        }

        function isIe() {
            return ("ActiveXObject" in window);
        }

        function isMobile() {
            var browser = {
                versions: function () {
                    var u = navigator.userAgent, app = navigator.appVersion;
                    return {//移动终端浏览器版本信息   
                        trident: u.indexOf('Trident') > -1, //IE内核  
                        presto: u.indexOf('Presto') > -1, //opera内核  
                        webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核  
                        gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核  
                        mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端  
                        ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端  
                        android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器  
                        iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器  
                        iPad: u.indexOf('iPad') > -1, //是否iPad    
                        webApp: u.indexOf('Safari') == -1
                        //是否web应该程序，没有头部与底部  
                    };
                }(),
                language: (navigator.browserLanguage || navigator.language).toLowerCase()
            }

            if ((browser.versions.mobile) && (browser.versions.ios || browser.versions.android || browser.versions.iPhone || browser.versions.iPad)) {
                return true;
            }
            else {
                return false;
            }
        }

        this.SOF_LoadLibrary = function (type) {
            os = check_os();
            var ret;
            if (g_mTokenPlugin == null) {
                g_mTokenPlugin = new mTokenPlugin();
            }

            if (type == this.GM3000) {
                if (isMobile()) {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("1", "mToken OTG", "com.longmai.security.plugin.driver.otg.OTGDriver");
                }
                else {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("mtoken_gm3000_hnca.dll", "libgm3000.1.0.so", "libgm3000.1.0.dylib");
                }
            }
            else if (type == this.SJK1137) {
                ret = g_mTokenPlugin.SOF_LoadLibrary("SKF_APP.dll", "SKF_APP.so", "SKF_APP.dylib");
            }
            else if (type == this.K5) {
                if (isMobile()) {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("2", "mToken K5 Bluetooth", "com.longmai.security.plugin.driver.ble.BLEDriver");
                }
                else {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("mtoken_k5.dll", "libgm3000.1.0.so", "libk5.1.0.dylib");
                }
            }
            else if (type == this.TF) {
                if (isMobile()) {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("0", "mToken TF/SD Card", "com.longmai.security.plugin.driver.tf.TFDriver");
                } else {
                    ret = g_mTokenPlugin.SOF_LoadLibrary("mtoken_tf.dll", "libgm3000.1.0.so", "libtf.dylib");
                }
            }
            else if (type == this.HT20522){
                ret = g_mTokenPlugin.SOF_LoadLibrary("HUNCA_HT_20522_SKF.dll", "libhunca_ht_h2070f63_skfapi.so", "libhunca_ht_h2070f63_skfapi.dylib");
            }
            else {
                return -1;
            }

            if (ret != 0) {
                return -2;
            }
            return this.SAR_OK;
        };

        this.SOF_EnumDevice = function () {
            if (g_mTokenPlugin == null) {
                return null;
            }

            var array = g_mTokenPlugin.SOF_EnumDevice();
            if (array == null || array.length <= 0) {
                return null;
            }
            return array.split("||");

        };

        this.SOF_GetDeviceInstance = function (DeviceName, ApplicationName) {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_GetDeviceInstance(DeviceName, ApplicationName);
        };

        this.SOF_GetUserList = function () {
            if (g_mTokenPlugin == null) {
                return "";
            }
            var list = g_mTokenPlugin.SOF_GetUserList();
            return list;
        };

        this.SOF_ExportUserCert = function (ContainerName, KeySpec) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_ExportUserCert(ContainerName, KeySpec);
        };

        this.SOF_GetDeviceInfo = function (Type) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_GetDeviceInfo(Type);
        };

        this.SOF_GetCertInfo = function (Base64EncodeCert, Type) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_GetCertInfo(Base64EncodeCert, Type);
        };

        this.SOF_GetCertInfoByOid = function (Base64EncodeCert, OID) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_GetCertInfoByOid(Base64EncodeCert, OID);
        }

        this.SOF_Login = function (PassWd) {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_Login(PassWd);
        };

        this.SOF_LogOut = function () {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_LogOut();
        };

        this.SOF_GetPinRetryCount = function () {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_GetPinRetryCount();
        };

        this.SOF_SetDigestMethod = function (DigestMethod) {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_SetDigestMethod(DigestMethod);
        };

        this.SOF_SetUserID = function (UserID) {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_SetUserID(UserID);
        };

        this.SOF_SignData = function (ContainerName, ulKeySpec, InData, InDataLen) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_SignData(ContainerName, ulKeySpec, InData, InDataLen);
        };

        this.SOF_SignDataToPKCS7 = function (ContainerName, ulKeySpec, InData, ulDetached) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_SignDataToPKCS7(ContainerName, ulKeySpec, InData, ulDetached);
        };

        this.SOF_VerifySignedData = function (Base64EncodeCert, digestMethod, InData, SignedValue) {
            if (g_mTokenPlugin == null) {
                return -1;
            }
            return g_mTokenPlugin.SOF_VerifySignedData(Base64EncodeCert, digestMethod, InData, SignedValue);
        };

        this.SOF_EncryptDataPKCS7 = function (Base64EncodeCert, InData, InDataLen) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_EncryptDataPKCS7(Base64EncodeCert, InData, InDataLen);
        };

        this.SOF_DecryptDataPKCS7 = function (ContainerName, ulKeySpec, InData) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_DecryptDataPKCS7(ContainerName, ulKeySpec, InData);
        };

        this.SOF_GenRemoteUnblockRequest = function () {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_GenRemoteUnblockRequest();
        };

        this.SOF_GenResetpwdResponse = function (request, soPin, userPin) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_GenResetpwdResponse(request, soPin, userPin);
        };

        this.SOF_RemoteUnblockPIN = function (request) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_RemoteUnblockPIN(request);
        };

        this.SOF_SignDataToPKCS7 = function (ContainerName, ulKeySpec, InData, ulDetached) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_SignDataToPKCS7(ContainerName, ulKeySpec, InData, ulDetached);
        };

        this.SOF_VerifyDataToPKCS7 = function (strPkcs7Data, OriginalText, ulDetached) {
            if (g_mTokenPlugin == null) {
                return null;
            }
            return g_mTokenPlugin.SOF_VerifyDataToPKCS7(strPkcs7Data, OriginalText, ulDetached);
        };
    }

    //判断插件名称是否存在
    function hasPlugin(name) {
        name = name.toLowerCase();
        for (var i = 0; i < navigator.plugins.length; i++) {
            if (navigator.plugins[i].name.toLowerCase().indexOf(name) > -1) {
                return true;
            }
        }
        return false;
    }

    //判断系统
    function check_os() {
        windows = (navigator.userAgent.indexOf("Windows", 0) != -1) ? 1 : 0;
        mac = (navigator.userAgent.indexOf("mac", 0) != -1) ? 1 : 0;
        linux = (navigator.userAgent.indexOf("Linux", 0) != -1) ? 1 : 0;
        unix = (navigator.userAgent.indexOf("X11", 0) != -1) ? 1 : 0;
        if (windows) os_type = "MS Windows";
        else if (linux) os_type = "Lunix";
        if (hasPlugin("mPlugin1.0.0.1")) {
            linuxWin = 2;
            return "id_mPluginV2Router";
        } else {
            linuxWin = 1;
            return "mTokenPlugin";
        }
    }

    var linuxWin = 0;
    var os;

    function mTokenPlugin() {
        var _xmlhttp;
        var retJSON = "";

        function AjaxIO(json_in) {
            //id_mPluginV2Router mTokenPlugin
            if (os == "id_mPluginV2Router") {
                var router = null;
                //var url = "http://192.168.1.25:51235/alpha";
                var url = "http://127.0.0.1:51235/alpha";

                router = document.getElementById("id_mPluginV2Router");
                if (null == router) {
                    alert("无法获取到插件，请确认已经安装好插件！");
                }
                /*
                if("https:" == document.location.protocol)
                {
                url = "https://127.0.0.1:51245/alpha";
                }
                */
                var json = json_in;

                retJSON = router.invoke(url, json);
                return retJSON;
            } else {

                var _curDevName = "";
                var _url = "http://127.0.0.1:51235/alpha";
                var json = json_in;
                if (_xmlhttp == null) {
                    if (window.XMLHttpRequest) { // code for IE7+, Firefox, Chrome, Opera, Safari
                        _xmlhttp = new XMLHttpRequest();
                    } else { // code for IE6, IE5
                        _xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                }
                if ("https:" == document.location.protocol) {
                    _url = "https://127.0.0.1:51245/alpha";
                }
                _xmlhttp.open("POST", _url, false);
                _xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                _xmlhttp.send("json=" + json);
            }
        };

        function GetHttpResult() {
            if (_xmlhttp.readyState == 4 && _xmlhttp.status == 200) {
                var obj = eval("(" + _xmlhttp.responseText + ")");
                return obj;
            }
            else {
                return null;
            }
        }

        this.SOF_GetLastError = function () {
            var json = '{"function":"SOF_GetLastError"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.errorCode;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        }

        this.SOF_LoadLibrary = function (windows, linux, mac) {
            var json = '{"function":"SOF_LoadLibrary", "winDllName":"' + windows + '", "linuxSOName":"' + linux + '", "macDylibName":"' + mac + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;

                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_EnumDevice = function () {
            var json = '{"function":"SOF_EnumDevice"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.array;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.array;
                }
                return -2;
            }
        };
        
        this.SOF_GetDeviceInstance = function (DeviceName, ApplicationName) {
            var json = '{"function":"SOF_GetDeviceInstance", "deviceName":"' + DeviceName + '", "applicationName":"' + ApplicationName + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    _curDevName = DeviceName;
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    if (ret.rtn == 0) {
                        _curDevName = DeviceName;
                    }
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_GetUserList = function () {
            var json = '{"function":"SOF_GetUserList", "deviceName":"' + _curDevName + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.array;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.array;
                }
                return -2;
            }
        };

        this.SOF_ExportUserCert = function (ContainerName, KeySpec) {
            var json = '{"function":"SOF_ExportUserCert", "deviceName":"' + _curDevName + '", "containerName":"' + ContainerName + '", "keySpec":' + KeySpec + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.cert;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.cert;
                }
                return -2;
            }
        };

        this.SOF_GetDeviceInfo = function (Type) {
            var json = '{"function":"SOF_GetDeviceInfo", "deviceName":"' + _curDevName + '", "type":' + Type + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.info;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.info;
                }
                return -2;
            }
        };


        this.SOF_GetCertInfo = function (Base64EncodeCert, Type) {
            var json = '{"function":"SOF_GetCertInfo", "base64EncodeCert":"' + Base64EncodeCert + '", "type":' + Type + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.info;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.info;
                }
                return -2;
            }
        };


        this.SOF_GetCertInfoByOid = function (Base64EncodeCert, OID) {
            var json = '{"function":"SOF_GetCertInfoByOid", "base64EncodeCert":"' + Base64EncodeCert + '", "oid":"' + OID + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.info;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                }
                catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.info;
                }
                return null;
            }
        };

        this.SOF_Login = function (PassWd) {
            var json = '{"function":"SOF_Login", "deviceName":"' + _curDevName + '", "passWd":"' + PassWd + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };


        this.SOF_LogOut = function () {
            var json = '{"function":"SOF_LogOut", "deviceName":"' + _curDevName + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_GetPinRetryCount = function () {
            var json = '{"function":"SOF_GetPinRetryCount", "deviceName":"' + _curDevName + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.retryCount;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.retryCount;
                }
                return -2;
            }
        };

        this.SOF_SetDigestMethod = function (DigestMethod) {
            var json = '{"function":"SOF_SetDigestMethod","deviceName":"' + _curDevName + '", "digestMethod":' + DigestMethod + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }

                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_SetUserID = function (UserID) {
            var json = '{"function":"SOF_SetUserID","deviceName":"' + _curDevName + '", "userID":"' + UserID + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_SetEncryptMethodAndIV = function (EncryptMethod, EncryptIV) {
            var json = '{"function":"SOF_SetEncryptMethodAndIV","deviceName":"' + _curDevName + '", "encryptMethod":' + EncryptMethod + ', "encryptIV":"' + EncryptIV + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_SignData = function (ContainerName, ulKeySpec, InData, InDataLen) {
            var json = '{"function":"SOF_SignDataEx", "deviceName":"' + _curDevName + '", "containerName":"' + ContainerName + '", "keySpec":' + ulKeySpec + ', "inData":"' + InData + '", "inDataLen":' + InDataLen + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.signed;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.signed;
                }
                return -2;
            }
        };

        this.SOF_VerifySignedData = function (Base64EncodeCert, digestMethod, InData, SignedValue) {
            var json = '{"function":"SOF_VerifySignedDataEx","deviceName":"' + _curDevName + '", "base64EncodeCert":"' + Base64EncodeCert + '", "digestMethod":' + digestMethod + ', "inData":"' + InData + '", "signedValue":"' + SignedValue + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_EncryptDataPKCS7 = function (Base64EncodeCert, InData, InDataLen) {
            var json = '{"function":"SOF_EncryptDataPKCS7", "deviceName":"' + _curDevName + '", "base64EncodeCert":"' + Base64EncodeCert + '", "inData":"' + InData + '", "inDataLen":' + InDataLen + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.encrypedData;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.encrypedData;
                }
                return -2;
            }

        };

        this.SOF_DecryptDataPKCS7 = function (ContainerName, ulKeySpec, InData) {
            var json = '{"function":"SOF_DecryptDataPKCS7", "deviceName":"' + _curDevName + '", "containerName":"' + ContainerName + '", "keySpec":' + ulKeySpec + ', "inData":"' + InData + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.decryptedData;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.decryptedData;
                }
                return -2;
            }
        };

        this.SOF_GenRemoteUnblockRequest = function () {
            var json = '{"function":"SOF_GenRemoteUnblockRequest", "deviceName":"' + _curDevName + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.request;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.request;
                }
                return -2;
            }
        };

        this.SOF_GenResetpwdResponse = function (request, soPin, userPin) {
            var json = '{"function":"SOF_GenResetpwdResponse", "deviceName":"' + _curDevName + '",  "request":"' + request + '", "soPin":"' + soPin + '", "userPin":"' + userPin + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.request;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.request;
                }
                return -2;
            }
        };

        this.SOF_RemoteUnblockPIN = function (request) {
            var json = '{"function":"SOF_RemoteUnblockPIN", "deviceName":"' + _curDevName + '", "request":"' + request + '"}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.rtn;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.rtn;
                }
                return -2;
            }
        };

        this.SOF_SignDataToPKCS7 = function (ContainerName, ulKeySpec, InData, ulDetached) {
            var json = '{"function":"SOF_SignDataToPKCS7", "deviceName":"' + _curDevName + '", "containerName":"' + ContainerName + '", "keySpec":' + ulKeySpec + ', "inData":"' + InData + '",  "detached":' + ulDetached + '}';
            if (linuxWin == 2) {
                var retJSON = "";
                try {
                    retJSON = AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                if (retJSON.length > 3) {
                    var obj = eval("(" + retJSON + ")");
                    return obj.pkcs7;
                } else {
                    return -2;
                }
            } else {
                try {
                    AjaxIO(json);
                } catch (e) {
                    return -3;
                }
                var ret = GetHttpResult();
                if (ret) {
                    return ret.pkcs7;
                }
                return -2;
            }
        };
    }

    /*******************************************************
     * 函数名称：Base64encode()
     * 功    能：对数据进行Base64加密
     * 说    明：函数中将数据使用_utf8_encode()进行编码转换后再加密,保证数据完整
     **********************************************************/
    var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    function _Base64encode(input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = _utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output + _keyStr.charAt(enc1) + _keyStr.charAt(enc2) + _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
        }
        return output;
    }

    /*******************************************************
     * 函数名称：Base64decode()
     * 功    能：对数据进行Base64解密
     * 说    明：函数中将数据使用_utf8_decode()将解密后的数据编码,保证数据完整
     **********************************************************/
    function _Base64decode(input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        //input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = _keyStr.indexOf(input.charAt(i++));
            enc2 = _keyStr.indexOf(input.charAt(i++));
            enc3 = _keyStr.indexOf(input.charAt(i++));
            enc4 = _keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    }

    /*******************************************************
     * 函数名称：_utf8_encode()
     * 功    能：将数据进行utf8编码
     * 说    明：
     **********************************************************/
    function _utf8_encode(in_string) {
        string = "" + in_string;
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;
    }

    /*******************************************************
     * 函数名称：_utf8_decode()
     * 功    能：将数据进行utf8解码
     * 说    明：
     **********************************************************/
    function _utf8_decode(utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
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
    //////////////////////////////////////////CA支撑函数END/////////////////////////////////////////////




    //对CA接口的通用封装 初始化指定的证书对象
    function getDeviceInstance(key) {
        key = key.split("|")[1];
        var ret = token.SOF_GetDeviceInstance(key, "");
        if (ret != 0) {
            alert("实例化证书失败,错误码:" + token.SOF_GetLastError());
            return false;
        }
        return true;
    }

    //获取证书列表
    function GetUserList(){
        var userList = "";
        //获取设备
        var deviceName = token.SOF_EnumDevice();
        if (deviceName == null) {
            alert("未找到任何key");
            return "";
        } 
        
        //获取证书
        for (var i = 0; i < deviceName.length; i ++) {
            var ret = token.SOF_GetDeviceInstance(deviceName[i], "");
            if (ret != 0) {
                alert("实例化证书失败,错误码:" + token.SOF_GetLastError());
                continue;
            }
            
            var cerList = token.SOF_GetUserList();
            if (cerList != ""){
                if (userList != "") userList = userList + "&&&"
                userList = userList + cerList + "|" + deviceName[i]
            } else {
                alert("获取证书列表失败,错误码:" + token.SOF_GetLastError());
                continue;
            }
        }
        return userList;
    }

    function HashData(inData){
        return b64_sha1(inData);
    }

    function SignedData(content,key){
        if (!getDeviceInstance(key))
            return "";
        
        key = key.split("|")[0];
        var DigestMethod = 1;  //129 - SGD_MD5      1 - SGD_SM3      2 - SGD_SHA1     4 - SGD_SHA256     130 - SGD_SHA384       131 - SGD_SHA512
        var selectType = 1;  //0 - 加密证书    1 - 签名证书
        
        //var userID = document.getElementById("userID").value;
        //var inData = document.getElementById("originalData").value;
        var ret = token.SOF_SetDigestMethod(Number(DigestMethod));
        //ret = token.SOF_SetUserID(userID);

        var b64Data = _Base64encode(content);
        var signed = token.SOF_SignData(key, selectType, _Base64encode(content), b64Data.length);
        if (signed != null && signed != "") {
            return signed;
        } else {
            alert("签名失败,错误码:" + token.SOF_GetLastError());
            return "";
        }
    }

    function SignedOrdData(content,key){
        return SignedData(content,key);
    }

    function GetSignCert(key){
        if (!getDeviceInstance(key))
            return "";

        key = key.split("|")[0];
        var selectType = 1;  //0 - 加密证书    1 - 签名证书
        var cert = token.SOF_ExportUserCert(key, selectType);
        if (cert != null && cert != "") {
            return cert;
        } else {
            alert("获取证书信息失败,错误码:" + token.SOF_GetLastError());
            return "";
        }
    }

    function GetUniqueID(cert,key) {
        if (!getDeviceInstance(key))
            return "";
        try {
            var result = token.SOF_GetCertInfo(cert, token.SGD_CERT_SUBJECT);
            result = result.split("UNDEF=")[1];
            result = result.split(",")[0];
        }
        catch(e) {
            var result = "";
        }
        return result;
    }

    function GetCertNo(key) {
        var cert = GetSignCert(key);
        var result = token.SOF_GetCertInfo(cert, token.SGD_CERT_SERIAL);
        return result;
    }

    function GetIdentityID(key)
    {
        return "";
    }

    function GetCertSN(key) {
        return key.split("|")[0];
    }

    function GetKeySN(key) {
        return key.split("|")[1];
    }

    function GetPicBase64Data(key) {
        try {
            var result = HWPostil1.GetValueEx('GET_SEAL_PREDEFBMP',0,'gif',0,'');
            result = result.split("@@@")[1];
        }
        catch(e) {
            var result = ""; 
        }
        return result;
    }

    function GetCertCNName(key) {
        var cert = GetSignCert(key);
        var result = token.SOF_GetCertInfo(cert, token.SGD_CERT_SUBJECT_CN);
        return result;
    }

    function Login(form_,key,password_) {
        if (!getDeviceInstance(key))
            return false;
        
        if (key == null || key == "") {
            alert("获取用户信息失败");
            return false;
        }
        if (password_ == null || password_ == "") {
            alert("请输入证书密码");
            return false;
        }
        if (password_.length < 6 || password_.length > 16) {
            alert("密码长度应该在4-16位之间");
            return false;
        }
        
        var ret = token.SOF_Login(password_);
        if (ret != 0) {
            var retryCount = token.SOF_GetPinRetryCount();
            if (retryCount > 0) {
                alert("校验证书密码失败!您还有" + retryCount + "次机会重试!");
                return false;
            } else if (retryCount == 0) {
                alert("您的证书密码已被锁死,请联系CA进行解锁!");
                return false;
            } else {
                alert("登录失败!");
                return false;
            }
        }
        return true;
    }

    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();

        var count = GetUserList().split("&&&").length;
        if (count > 1) {
            alert("由于CA原因，关联证书时不可插入多个key，请拔出多余Ukey后在进行操作！");
            return usrSignatureInfo;
        }    
        
        var certB64 = GetSignCert(key);
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        usrSignatureInfo["certificate"] = certB64;
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64,key);
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        return usrSignatureInfo;
    }

    //校验输入的密码 正确返回空
    function CheckPWD(key, password_) {
        if (!getDeviceInstance(key))
            return "";
    
        if (key == null || key == "") 
            return "获取用户信息失败";
        
        if (password_ == null || password_ == "")
            return "请输入证书密码";

        if (password_.length < 6 || password_.length > 16)
            return "密码长度应该在4-16位之间";

    
        var ret = token.SOF_Login(password_);
        if (ret != 0) {
            var retryCount = token.SOF_GetPinRetryCount();
            if (retryCount > 0) {
                return "校验证书密码失败!您还有" + retryCount + "次机会重试!";
            } else if (retryCount == 0) {
                return "您的证书密码已被锁死,请联系CA进行解锁!";
            } else {
                return "登录失败!";
            }
        }
        return "";
    }

    //校验随机数
    function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {
        
        var result = {};

        // 导出客户端证书
        //var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
        var userCert = GetSignCert(strCertID, KEY_SIGNOREXCHANGE);
        if (userCert == null || userCert == "") {
            result.errMsg("导出用户证书失败!");
            return result;
        }

        // 对随机数做签名
        //var strClientSignedData = SOF_SignData(strCertID, strServerRan);
        var strClientSignedData = SignedData(strServerRan,strCertID);
        if (strClientSignedData == null || strClientSignedData == '') {
            result.errMsg = '客户端签名失败!';
            return result;
        }

        result.errMsg = '';
        result.UserSignedData = strClientSignedData;
        result.UserCert = userCert;
        result.ContainerName = strCertID;
   
        return result;
    }

    function SOF_IsLogin(strKey) {
        return false;
    }

    function oGetLastError() {
        token.SOF_GetLastError();
    }
    
    function iGetLoginedInfo() {
        var result = iGetData("GetLoginedInfo");
        return result;
    }
    
    function iKeyExist(key) {
        var strUserList = GetUserList();
        var arrUsers = strUserList.split('&&&');
        for (var i = 0; i < arrUsers.length; i++) {
            var user = arrUsers[i];
            if (user != "") {
                if (key == user.split('||')[1]) return true;
            }
        }
        return false;
    }
    
    function oLoginForm(paraObj) {
        paraObj = paraObj||"";
        var forceLogin = paraObj.forceLogin||false;

        if ((!forceLogin)) {
            var loginedCert = iGetLoginedInfo();
            if ((loginedCert.retCode == 0)&&(loginedCert.certContainer != "")) {
                if (iKeyExist(loginedCert.certContainer)&&(SOF_IsLogin(loginedCert.certContainer))) {
                    loginedCert.signCert = GetSignCert(loginedCert.certContainer);
                    loginedCert.userCertCode = GetUniqueID(loginedCert.signCert);
                    loginedCert.certNo = GetCertNo(loginedCert.certContainer);
                    Global_Last_Login_CertInfo = loginedCert;
                    return Global_Last_Login_CertInfo;
                }
            }    
        }
        
        var url = "../csp/dhc.certauth.login.ukey.csp?venderCode=" + Const_Vender_Code + "&signType=" + Const_Sign_Type;
        var para = {
            GetUserList: function() {
                return GetUserList();
            },
            CheckPWD: function(key, pin) {
                return CheckPWD(key, pin);
            },
            GetSignCert: function(key) {
                return GetSignCert(key);
            },
            GetCertNo: function(key) {
                return GetCertNo(key);
            },
            GetUniqueID: function(cert,key) {
                return GetUniqueID(cert);
            }
        };
        var rtnStr = window.showModalDialog(url,para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
        
        if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
            return {retCode:"-2",retMsg:"登录失败"};
        }
        
        var rtn = $.parseJSON(rtnStr);
        if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
            Global_Last_Login_CertInfo = rtn;
        }
        
        return rtn||{retCode:"-2",retMsg:"登录失败"};
    }
    
    
    function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
        
        var result = "";
        var para = {
              CAFunc: Func,
              CAVenderCode:Const_Vender_Code,
              CASignType:Const_Sign_Type,
              P1:P1||"",
              P2:P2||"",
              P3:P3||"",
              P4:P4||"",
              P5:P5||"",
              P6:P6||"",
              P7:P7||"",
              P8:P8||"",
              P9:P9||""
          };
          
          $.ajax({
            url: "../CA.Ajax.DS.cls",
            type: "POST",
            dataType: "JSON",
            async: false,
            global:false,
            data: para,
            success: function(ret) {
                if (ret && ret.retCode == "0") {
                    result = ret;
                } else {
                    alert(ret.retMsg);
                }
            },
            error: function(err) {
                alert(err.retMsg || err);
            }
          });
          
          return result;
    }
    
    return {
        OCX: token,
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
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strFormName, strCertID, strPin, forceCheck);
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
            return SignedOrdData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
            return HashData(content)  
        },
        LoginForm:function(paraObj) {
            return oLoginForm(paraObj);
        },
          GetPicBase64Data:function(key) {
            return GetPicBase64Data(key);
        },
        GetLastError:function() {
            return oGetLastError();
        }
    }
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin, forceCheck) {
    return ca_key.Login(strFormName, key, pin, forceCheck);
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
function CheckPWD(key, pwd) {
    return ca_key.CheckPWD(key, pwd);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}
function LoginForm(paraObj) {
    return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}