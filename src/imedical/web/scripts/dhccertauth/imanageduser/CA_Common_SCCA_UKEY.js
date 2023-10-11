var TCA = {};
(function() {
	function TCACErr(r) {
        this._errarr = [],
        r instanceof TCACErr && (this._errarr = r._errarr),
        this.addErr = function(r) {
            var t = r.code,
            e = r.msg;
            this.number = t > 0 ? t: 4294967296 + t,
            this.description = e,
            this._errarr.push({
                code: this.number.toString(16).toUpperCase(),
                msg: e
            })
        },
        this.toStr = function() {
            for (var r = "",
            t = 0; t < this._errarr.length; t++) r += this._errarr[t].msg + ", 错误码：0x" + this._errarr[t].code + ", \r\n";
            return r.substr(0, r.length - 4)
        }
    }
    function tcu() {}
    TCA = {};
    TCA.config = function(r) {
        TCACore.getInstance(r)
    },
    TCA.SOF_SetSignMethod = function(r) {
        var t = {
            SignMethod: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_SetSignMethod", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_GetSignMethod = function() {
        var r = {
            t: ""
        };
        r = tcu.json2Str(r);
        var t, e = TCACore.getInstance();
        try {
            t = e.call("SOF_GetSignMethod", r)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return t.r
    },
    TCA.SOF_SetEncryptMethod = function(r) {
        var t = {
            EncryptMethod: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_SetEncryptMethod", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_GetEncryptMethod = function() {
        var r = {
            t: ""
        };
        r = tcu.json2Str(r);
        var t, e = TCACore.getInstance();
        try {
            t = e.call("SOF_GetEncryptMethod", r)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return t.r
    },
    TCA.SOF_GetCertInfo = function(r, t) {
        var e = {
            inCert: r,
            inType: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_GetCertInfo", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_GetCertInfoByOid = function(r, t) {
        var e = {
            inCert: r,
            inOid: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_GetCertInfoByOid", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_ValidateCert = function(r) {
        var t = {
            inCert: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_ValidateCert", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_SignData = function(r, t, e) {
        var n = {
            inCertId: r,
            inData: t,
            inDataLen: e
        };
        n = tcu.json2Str(n);
        var c, a = TCACore.getInstance();
        try {
            c = a.call("SOF_SignData", n)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return c.r
    },
    TCA.SOF_VerifySignedData = function(r, t, e, n) {
        var c = {
            SignMethod: SignMethod,
            inData: t,
            InDataLen: e,
            SignValue: n
        };
        c = tcu.json2Str(c);
        var a, o = TCACore.getInstance();
        try {
            a = o.call("SOF_VerifySignedData", c)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return a.r
    },
    TCA.SOF_SignFile = function(r, t) {
        var e = {
            inCertId: r,
            inFile: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_SignFile", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_VerifySignedFile = function(r, t, e) {
        var n = {
            inCertId: r,
            inFile: t,
            inSignValue: e
        };
        n = tcu.json2Str(n);
        var c, a = TCACore.getInstance();
        try {
            c = a.call("SOF_VerifySignedFile", n)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return c.r
    },
    TCA.SOF_EncryptData = function(r, t) {
        var e = {
            inSymmKey: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_EncryptData", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_DecryptData = function(r, t) {
        var e = {
            inSymmKey: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_DecryptData", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_EncryptFile = function(r, t, e) {
        var n = {
            inSymmKey: r,
            inFile: t,
            inOutFile: e
        };
        n = tcu.json2Str(n);
        var c, a = TCACore.getInstance();
        try {
            c = a.call("SOF_EncryptFile", n)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return c.r
    },
    TCA.SOF_DecryptFile = function(r, t, e) {
        var n = {
            inSymmKey: r,
            inFile: t,
            inOutFile: e
        };
        n = tcu.json2Str(n);
        var c, a = TCACore.getInstance();
        try {
            c = a.call("SOF_DecryptFile", n)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return c.r
    },
    TCA.SOF_PubKeyEncrypt = function(r, t) {
        var e = {
            inCert: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_PubKeyEncrypt", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_PriKeyDecrypt = function(r, t) {
        var e = {
            inCertId: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_PriKeyDecrypt", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_SignDataByP7 = function(r, t) {
        var e = {
            inCertId: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_SignDataByP7", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_VerifySignedDataByP7 = function(r) {
        var t = {
            inP7Data: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_VerifySignedDataByP7", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_GetP7SignDataInfo = function(r, t) {
        var e = {
            inP7Data: r,
            inData: inData
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_GetP7SignDataInfo", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_SignDataXML = function(r, t) {
        var e = {
            inCertId: r,
            inData: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_SignDataXML", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_VerifySignedDataXML = function(r) {
        var t = {
            inData: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_VerifySignedDataXML", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_GetXMLSignatureInfo = function(r, t) {
        var e = {
            inXMLSignedData: r,
            inType: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_GetXMLSignatureInfo", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_GenRandom = function(r) {
        var t = {
            len: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_GenRandom", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_GetVersion = function() {
        var r = {
            t: ""
        };
        r = tcu.json2Str(r);
        var t, e = TCACore.getInstance();
        try {
            t = e.call("SOF_GetVersion", r)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return t.r
    },
    TCA.SOF_GetUserList = function() {
        var r = {
            t: ""
        };
        r = tcu.json2Str(r);
        var t, e = TCACore.getInstance();
        try {
            t = e.call("SOF_GetUserList", r)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return t.r
    },
    TCA.SOF_ExportExChangeUserCert = function(r) {
        var t = {
            inCertId: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_ExportExChangeUserCert", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_ExportUserCert = function(r) {
        var t = {
            inCertId: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("SOF_ExportUserCert", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return e.r
    },
    TCA.SOF_Login = function(r, t) {
        var e = {
            inCertId: r,
            inPassWd: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_Login", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_ChangePassWd = function(r, t, e) {
        var n = {
            SignMethod: r,
            inOldPassWd: t,
            inNewPassWd: e
        };
        n = tcu.json2Str(n);
        var c, a = TCACore.getInstance();
        try {
            c = a.call("SOF_ChangePassWd", n)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return c.r
    },
    TCA.SOF_GetUserInfo = function(r, t) {
        var e = {
            inCertId: r,
            inType: t
        };
        e = tcu.json2Str(e);
        var n, c = TCACore.getInstance();
        try {
            n = c.call("SOF_GetUserInfo", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return n.r
    },
    TCA.SOF_CheckSupport = function() {
        var r = {
            t: ""
        };
        r = tcu.json2Str(r);
        var t, e = TCACore.getInstance();
        try {
            t = e.call("SOF_CheckSupport", r)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return t.r
    };
    
    var TCACore = function() {
        function r(r) {
            C.config = {},
            C.config.ajaxHdl = void 0 !== r.ajaxHdl ? r.ajaxHdl: tcu.ajax,
            C.config.str2JsonHdl = void 0 !== r.str2JsonHdl ? r.str2JsonHdl: tcu.convStr2Json,
            C.config.certkitClsID = "40CAB063-EF31-4ff6-B512-E1E4E454EB19",
            C.config.certKitSrvHost = "127.0.0.1",
            C.config.certKitSrvPort = "7256",
            C.config.certKitSrvUrl = "https://" + C.config.certKitSrvHost + ":" + C.config.certKitSrvPort + "/",
            C.config.certKitSrvVer = "3.6.0.2",
            C.config.certKitActiveXVer = "3.6.0.2",
            C.config.licver = "3.6.0.2",
            C.config.licsoftver = "3.6.0.2",
            C.config.selfNameFmt = "TopCertKit-\\d+(\\.\\d+)*.js",
            C.config.selfPath = t(),
            C.config.useAlias = void 0 === r.useAlias || r.useAlias,
            C.config.disableExeUrl = void 0 !== r.disableExeUrl && r.disableExeUrl,
            void 0 !== r.cspAlias ? C.config.cspAlias = r.cspAlias: C.config.cspAlias = {
                "RSA软证书": "Microsoft Enhanced Cryptographic Provider v1.0",
                "飞天 ePass 3000 GM": "EnterSafe ePass3000GM CSP v1.0",
                "华大智宝 SJK102": "CIDC Cryptographic Service Provider v3.0.0",
                "SM2软证书": "iTrusChina Cryptographic Service Provider v1.0.0",
                "神州龙芯": "ChinaCpu USB Key CSP v1.0"
            },
            C.config.addCspAlias = void 0 !== r.addCspAlias ? r.addCspAlias: {};
            for (var e in C.config.addCspAlias) C.config.cspAlias[e] = C.config.addCspAlias[e];
            C.config.disableWhiteList = void 0 !== r.disableWhiteList && r.disableWhiteList,
            void 0 !== r.whiteList ? C.config.whiteList = r.whiteList: C.config.whiteList = ["Microsoft Enhanced Cryptographic Provider v1.0", "iTrusChina Cryptographic Service Provider v1.0.0"],
            C.config.addWhiteList = void 0 !== r.addWhiteList ? r.addWhiteList: [];
            for (var n = 0; n < C.config.addWhiteList.length; n++) C.config.whiteList.push(C.config.addWhiteList[n]);
            C.config.lic = void 0 !== r.license ? r.license: null,
            C.config.licinfo = null,
            C.config.urlArr = null,
            C.config.autoExePath = void 0 !== r.autoExePath && r.autoExePath,
            C.config.installMode = void 0 === r.installMode || r.installMode,
            C.config.exportKeyAble = void 0 === r.exportKeyAble || r.exportKeyAble,
            void 0 === r.exepath ? C.config.exepath = C.config.selfPath + "TopCertKit-" + C.config.exeVer + ".exe": C.config.exepath = r.exepath,
            C.config.genKeySpec = void 0 !== r.genKeySpec ? r.genKeySpec: 1,
            1 != C.config.genKeySpec && 2 != C.config.genKeySpec && (C.config.genKeySpec = 1),
            C.config.genCsrUseSHA256 = void 0 !== r.genCsrUseSHA256 && r.genCsrUseSHA256,
            C.config.signPkcs7WithAttr = void 0 !== r.signPkcs7WithAttr && r.signPkcs7WithAttr,
            C.config.enableAutoAuth = void 0 !== r.enableAutoAuth && r.enableAutoAuth,
            C.config.autoAuthUrl = void 0 !== r.autoAuthUrl ? r.autoAuthUrl: ""
        }
        function t() {
            for (var r, t = document.getElementsByTagName("script"), e = new RegExp("(.*/)+"), n = 0; n < t.length; n++) if (r = t[n].getAttribute("src"), null !== r && !(r.search("TopCertKit-\\d{5}.js") < 0)) {
                r = r.match(e)[0];
                break
            }
            return r
        }
        function e() {
            return ! 0
        }
        function n() {
            try {
                var r = "<object id='TopCertKit' classid='clsid:" + C.config.certkitClsID + "' ";
                r += "></object>";
                var t = document.getElementById("CertKitDiv");
                null !== t && "" !== t || (t = document.createElement("div"), t.setAttribute("id", "CertKitDiv"), t.innerHTML = r, document.body.appendChild(t)),
                C.certKitSrvActiveX = document.getElementById("TopCertKit")
            } catch(r) {
                throw r
            }
        }
        function c() {
            var r = navigator.userAgent;
            return r.indexOf("MSIE") > 0 || r.toLocaleLowerCase().indexOf("trident") > -1
        }
        function a() {
            return c() ? n() : e()
        }
        function o(r, t) {
            var e = C.config.certKitSrvUrl + r,
            n = {},
            c = !1,
            a = function(r) {
                c = !0,
                n = r
            },
            o = function(r, t, e) {
                c = !1,
                n.request = r,
                n.status = t,
                n.err = e
            };
            if (C.config.ajaxHdl({
                type: "POST",
                url: e,
                async: !1,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: t,
                success: a,
                error: o
            }), !c) {
                var i = "[" + n.request.readyState + "][" + n.request.status + "][" + n.status + "][" + n.err.toString() + "]";
                throw new TCACErr(4278190081, i)
            }
            return n.retCode != ERRMAP.SUPER_SUCCESS.code && TCACErr.throwErr(TCACErr.newErr(ERRMAP.CALL_HTTP_CLIENT_ERR), {
                code: n.retCode,
                msg: n.retMsg
            }),
            n
        }
        function i(r, t, e) {
            var n = C.config.certKitSrvUrl + r,
            c = {},
            a = !1,
            o = function(r) {
                a = !0,
                c = r,
                e(r)
            },
            i = function(r, t, e) {
                TCACErr.throwErr(TCACErr.newErr(ERRMAP.CALL_HTTP_CLIENT_ERR), {
                    code: c.retCode,
                    msg: c.retMsg
                }),
                a = !1,
                c.request = r,
                c.status = t,
                c.err = e
            };
            C.config.ajaxHdl({
                type: "POST",
                url: n,
                async: !0,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: t,
                success: o,
                error: i
            })
        }
        function u(r, t) {
            var e = null;
            try {
                r = r,
                e = C.certKitSrvActiveX.reqHdl(r, t)
            } catch(r) {
                var n = TCACErr.newErr({
                    code: r.number,
                    msg: r.description
                });
                return TCACErr.throwErr(n, ERRMAP.CALL_ACTIVEX_ERR),
                null
            }
            if (e = C.config.str2JsonHdl(e), 0 != e.retCode) {
                var c = TCACErr.newErr(ERRMAP.CALL_ACTIVEX_ERR_METHOD);
                return TCACErr.throwErr(c, {
                    code: e.retCode,
                    msg: e.retMsg
                }),
                null
            }
            return e
        }
        function s(r, t, e) {
            var n = null;
            try {
                r = r,
                n = C.certKitSrvActiveX.reqHdl(r, t)
            } catch(r) {
                var c = TCACErr.newErr({
                    code: r.number,
                    msg: r.description
                });
                return TCACErr.throwErr(c, ERRMAP.CALL_ACTIVEX_ERR),
                null
            }
            if (n = C.config.str2JsonHdl(n), 0 != n.retCode) {
                var a = TCACErr.newErr(ERRMAP.CALL_ACTIVEX_ERR_METHOD);
                return TCACErr.throwErr(a, {
                    code: n.retCode,
                    msg: n.retMsg
                }),
                null
            }
            e(n)
        }
        var C = {};
        C.config = null,
        C.cacheKeyStoreList = null,
        C.certKitSrvActiveX = null,
        r({});
        var R = function() {
            this.getCfg = function(r) {
                return C.config[r]
            },
            this.setKeyStoreListCache = function(r) {
                C.cacheKeyStoreList = r
            },
            this.getLicInfo = function(r) {
                return null == C.config.licinfo,
                C.config.licinfo[r]
            },
            this.full2Alias = function(r) {
                for (var t in C.config.cspAlias) if (C.config.cspAlias.hasOwnProperty(t) && C.config.cspAlias[t] == r) return t;
                return r
            },
            this.alias2Full = function(r) {
                var t = C.config.cspAlias[r];
                return void 0 === t ? r: t
            },
            this.certInLic = function(r) {
                return ! 0
            };
            var r = {};
            r.query = c() ? u: o,
            r.queryAsyn = c() ? s: i,
            this.call = function(t, e) {
                return r.query(t, e)
            },
            this.callAsyn = function(t, e, n) {
                return r.queryAsyn(t, e, n)
            }
        },
        E = null,
        l = function(t) {
            return void 0 !== t && null !== t && r(t),
            null === E && (E = new R, a()),
            E
        };
        return {
            getInstance: l
        }
    } ();
    
    TCACErr.newErr = function(r, t) {
        var e = null;
        return r instanceof TCACErr ? (e = new TCACErr(r), e.addErr(t)) : (e = new TCACErr, e.addErr(r)),
        e
    },
    TCACErr.throwErr = function(r, t) {
        throw r instanceof TCACErr ? TCACErr.newErr(r, t) : TCACErr.newErr(r)
    };
    
    var ERRMAP_ZHCN = {
        CERTSTORE_INIT_WRONGTYPE: {
            code: 16777217,
            msg: "CertStore实例初始化失败，参数类型不匹配"
        },
        LIST_STORE_ERROR: {
            code: 16777218,
            msg: "列举密钥库错误"
        },
        BY_CERT_ERR_TYPE: {
            code: 16777219,
            msg: "根据证书获取CertStore实例时失败，参数类型不匹配"
        },
        LIST_CERT_ERROR: {
            code: 16777220,
            msg: "列举证书错误"
        },
        GEN_CSR_ERROR_PARAMS: {
            code: 16777221,
            msg: "产生CSR失败，输入参数错误"
        },
        GEN_CSR_ERR_PUBKEY_ALG: {
            code: 16777222,
            msg: "产生CSR失败，未知的证书公钥算法"
        },
        GEN_CSR_ERROR: {
            code: 16777223,
            msg: "产生CSR失败"
        },
        INSTALL_CERT_ERR_PARAMS: {
            code: 16777224,
            msg: "安装证书失败，输入参数错误"
        },
        INSTALL_CERT_ERR_UNKNOWN_SYMMALG: {
            code: 16777225,
            msg: "安装加密证书失败，未知的对称加密算法"
        },
        INSTALL_CERT_ERR: {
            code: 16777226,
            msg: "安装证书失败"
        },
        CERTIFICATE_INIT_WRONGTYPE: {
            code: 33554433,
            msg: "Certificate实例初始化失败，参数类型不匹配"
        },
        CERTIFICATE_PARSE_ERROR: {
            code: 33554434,
            msg: "从Base64解析证书失败"
        },
        CERTIFICATE_DELETE_ERROR: {
            code: 33554435,
            msg: "删除证书失败"
        },
        CERT_SET_INIT_ERROR_TYPE: {
            code: 50331649,
            msg: "初始化CertSet实例失败，错误的输入类型"
        },
        CERT_SET_INIT_ERROR_TYPE_2: {
            code: 50331650,
            msg: "初始化CertSet实例失败，错误的输入类型"
        },
        CERT_SET_INIT_ERROR_TYPE_3: {
            code: 50331651,
            msg: "初始化CertSet实例失败，错误的输入类型"
        },
        CERT_SET_FILTER_KEYUSAGE_ERROR: {
            code: 50331652,
            msg: "通过密钥用法过滤失败，错误的输入类型"
        },
        CSR_INIT_ERROR_TYPE: {
            code: 67108865,
            msg: "初始化Csr实例失败，错误的输入类型"
        },
        PKCS7_INIT_ERROR_TYPE: {
            code: 83886081,
            msg: "初始化Pkcs7实例失败，错误的输入类型"
        },
        PKCS7_INIT_PARSE_ERROR: {
            code: 83886082,
            msg: "初始化Pkcs7实例失败，解析Pkcs7数据失败"
        },
        SIGN_ERROR: {
            code: 2684354561,
            msg: "签名操作失败"
        },
        SIGN_ERROR_HASH_ALG: {
            code: 100663297,
            msg: "哈希算法与签名算法不匹配"
        },
        VERIFY_ERROR: {
            code: 2684354562,
            msg: "验证签名操作失败"
        },
        ENCRYPT_ERROR: {
            code: 2684354563,
            msg: "加密操作失败"
        },
        DECRYPT_ERROR: {
            code: 2684354564,
            msg: "解密操作失败"
        },
        ERROR_HASH_ALG: {
            code: 2952790017,
            msg: "指定了错误的Hash算法算法"
        },
        ERROR_JSON_TYPE: {
            code: 2952790018,
            msg: "错误的json类型"
        },
        ERROR_CALL_SRV_VER: {
            code: 2952790019,
            msg: "查询服务版本失败"
        },
        CALL_HTTP_CLIENT_ERR: {
            code: 4026531841,
            msg: "执行本地方法失败"
        },
        INVALID_LICENSE: {
            code: 4026531842,
            msg: "使用了无效的License"
        },
        INVALID_CERTKIT_VER: {
            code: 4026531843,
            msg: "不匹配的CertKit版本"
        },
        CALL_ACTIVEX_ERR: {
            code: 4026531844,
            msg: "执行本地方法失败"
        },
        CALL_ACTIVEX_ERR_METHOD: {
            code: 4026531845,
            msg: "执行操作失败"
        },
        INSTALL_ACTIVEX_ERR: {
            code: 4026531846,
            msg: "无法加载ActiveX控件"
        },
        INVALID_LICENSE_2: {
            code: 4026531847,
            msg: "使用了无效的License"
        },
        INVALID_CONFIG: {
            code: 4026531848,
            msg: "无效的配置"
        },
        AUTOAUTH_ERROR: {
            code: 4026531849,
            msg: "autoautherror"
        },
        AUTOAUTH_ERROR_2: {
            code: 4026531850,
            msg: "autoautherror2"
        },
        ERROR_FILE_DIALOG: {
            code: 218103810,
            msg: "打开对话框失败"
        },
        UNIMPLEMENTED: {
            code: 1,
            msg: "未实现的方法"
        },
        BIG_ERROR: {
            code: 4294967295,
            msg: "错误"
        },
        SUPER_SUCCESS: {
            code: 0,
            msg: "成功"
        }
    },
    ERRMAP = ERRMAP_ZHCN;
    TCACErr.prototype = new Error,
    tcu.extKeyUsageMap = {
        "1.3.6.1.5.5.7.3.1": "serverAuth",
        "1.3.6.1.5.5.7.3.2": "clientAuth",
        "1.3.6.1.5.5.7.3.3": "codeSigning",
        "1.3.6.1.5.5.7.3.4": "emailProtection",
        "1.3.6.1.5.5.7.3.5": "ipsecEndSystem",
        "1.3.6.1.5.5.7.3.6": "ipsecTunnel",
        "1.3.6.1.5.5.7.3.7": "ipsecUser",
        "1.3.6.1.5.5.7.3.8": "timeStamping",
        "1.3.6.1.5.5.7.3.9": "OCSPSigning",
        "1.3.6.1.5.5.7.3.10": "dvcs",
        "1.3.6.1.5.5.7.3.11": "sbgpCertAAServerAuth",
        "1.3.6.1.5.5.7.3.12": "scvpResponder",
        "1.3.6.1.5.5.7.3.13": "eapOverPPP",
        "1.3.6.1.5.5.7.3.14": "eapOverLAN",
        "1.3.6.1.5.5.7.3.15": "scvpServer",
        "1.3.6.1.5.5.7.3.16": "scvpClient",
        "1.3.6.1.5.5.7.3.17": "ipsecIKE",
        "1.3.6.1.5.5.7.3.18": "capwapAC",
        "1.3.6.1.5.5.7.3.19": "capwapWTP",
        "1.3.6.1.4.1.311.20.2.2": "smartcardlogon"
    },
    tcu.isStr = function(r) {
        return "string" == typeof r
    },
    tcu.isNum = function(r) {
        return "number" == typeof r
    },
    tcu.isBool = function(r) {
        return "boolean" == typeof r
    },
    tcu.isUndef = function(r) {
        return "undefined" == typeof r
    },
    tcu.isNull = function(r) {
        return "null" == typeof r
    },
    tcu.isObj = function(r) {
        return "object" == typeof r
    },
    tcu.isArr = function(r) {
        return "[object Array]" === Object.prototype.toString.call(r)
    },
    tcu.urlDec = function(r) {
        var t = decodeURIComponent(r);
        return t.replace(/[\r\n]/g, "")
    },
    tcu.convKeyUsageArr2Num = function(r) {
        for (var t = 0,
        e = 0; e < r.length; e++)"digitalSignature" != r[e] ? "nonRepudiation" != r[e] ? "keyEncipherment" != r[e] ? "dataEncipherment" != r[e] ? "keyAgreement" != r[e] ? "keyCertSign" != r[e] ? "cRLSign" != r[e] ? "encipherOnly" != r[e] ? "decipherOnly" != r[e] ? "contentCommitment" == r[e] && (t |= TCA.contentCommitment) : t |= TCA.decipherOnly: t |= TCA.encipherOnly: t |= TCA.cRLSign: t |= TCA.keyCertSign: t |= TCA.keyAgreement: t |= TCA.dataEncipherment: t |= TCA.keyEncipherment: t |= TCA.nonRepudiation: t |= TCA.digitalSignature;
        return t
    },
    tcu.convKeyUsageNum2Arr = function(r) {
        var t = [];
        return 0 === r ? t: (r & TCA.digitalSignature && t.push("digitalSignature"), r & TCA.nonRepudiation && t.push("nonRepudiation"), r & TCA.keyEncipherment && t.push("keyEncipherment"), r & TCA.dataEncipherment && t.push("dataEncipherment"), r & TCA.keyAgreement && t.push("keyAgreement"), r & TCA.keyCertSign && t.push("keyCertSign"), r & TCA.cRLSign && t.push("cRLSign"), r & TCA.encipherOnly && t.push("encipherOnly"), r & TCA.decipherOnly && t.push("decipherOnly"), r & TCA.contentCommitment && t.push("contentCommitment"), t)
    },
    tcu.convSignAlg2Str = function(r) {
        switch (r) {
        case 81:
            return "SM3WithSM2";
        case 98:
            return "SHA1WithRSA"
        }
        return "UnknownSignAlg"
    },
    tcu.convAlg2SignAlgId = function(r) {
        return r == TCA.RSA1024 ? 98 : r == TCA.RSA2048 ? 98 : r == TCA.SM2 ? 81 : -1
    },
    tcu.convPubKeyAlg2Str = function(r) {
        switch (r) {
        case 1:
        case 2:
        case 3:
        case 16:
            return "RSA";
        case 17:
            return "SM2"
        }
        return "UnknownAlg"
    },
    tcu.convPubKeyAlg2Size = function(r) {
        switch (r) {
        case 1:
            return 1024;
        case 2:
            return 2048;
        case 3:
            return 4096;
        case 17:
            return 256
        }
        return - 1
    },
    tcu.convExtKeyUsageOID2Name = function(r) {
        for (var t = [], e = 0; e < r.length; e++) t.push(tcu.extKeyUsageMap[r[e]]);
        return t
    },
    tcu.convStr2Json = function(jsonStr) {
        return eval("(" + jsonStr + ")")
    },
    tcu.convKeySize2CSP = function(r) {
        return r == TCA.RSA1024 ? 67108864 : r == TCA.RSA2048 ? 134217728 : r == TCA.SM2 ? 16777216 : -1
    },
    tcu.strInList = function(r, t) {
        if (t.length <= 0) return ! 1;
        for (var e = 0; e < t.length; e++) if (r === t[e]) return ! 0;
        return ! 1
    },
    tcu.tcaAlg2SDKAlg = function(r) {
        switch (r) {
        case TCA.SM4:
            return 65;
        case TCA.DES:
            return 67;
        case TCA.DES3:
            return 68;
        case TCA.AES:
            return 69;
        case TCA.RC4:
            return 70;
        case TCA.SM2:
            return 17;
        case TCA.RSA1024:
            return 1;
        case TCA.RSA2048:
            return 2;
        case TCA.SHA256:
            return 50;
        case TCA.SHA1:
            return 49;
        case TCA.SM3:
            return 33;
        case TCA.MD5:
            return 51;
        case TCA.SM1:
        default:
            return 0
        }
    },
    tcu.arr2Str = function(r) {
        for (var t = "",
        e = 0; e < r.length; e++) {
            var n = r[e];
            n = n.replace(/\r/g, "\\r").replace(/\n/g, "\\n"),
            t = t + '"' + n + '", '
        }
        return t.length > 0 && (t = t.substr(0, t.length - 2)),
        "[" + t + "]"
    },
    tcu.json2Str = function(r) {
        var t = "{";
        for (var e in r) {
            t += '"' + e + '":';
            var n = r[e];
            tcu.isStr(n) ? (n = n.replace(/\r/g, "\\r").replace(/\n/g, "\\n").replace(/\"/g, '\\"').replace(/\\/g, "\\\\"), t += '"' + n + '",') : tcu.isNum(n) || tcu.isBool(n) ? t += n + ",": tcu.isArr(n) ? t += tcu.arr2Str(n) + ",": TCACErr.throwErr(ERRMAP.ERROR_JSON_TYPE)
        }
        return t += '"_jsonEnd":"_jsonEnd"}'
    },
    tcu.sign = function(r, t, e, n, c, a, o, i, u, s, C, R) {
        var E = {
            certStore: r,
            certIDArr: t,
            hash: e,
            bSignHash: n,
            bSignP7: c,
            bAttr: a,
            bIncCtx: o,
            bIncCert: i,
            inType: u,
            inParam: s,
            outType: C,
            outParam: R
        };
        E = tcu.json2Str(E);
        var l, A = TCACore.getInstance();
        try {
            l = A.call("Sign/sign", E)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.SIGN_ERROR),
            null
        }
        return l
    },
    tcu.verify = function(r, t, e, n, c, a, o, i, u) {
        var s = {
            b64Cert: r,
            isHashSign: t,
            isPkcs7: e,
            hash: n,
            verifyOption: c,
            signInType: a,
            signInParam: o,
            plainInType: i,
            plainInParam: u
        };
        s = tcu.json2Str(s);
        var C, R = TCACore.getInstance();
        try {
            C = R.call("Verify/verify", s)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.VERIFY_ERROR),
            null
        }
        return C
    },
    tcu.enc = function(r, t, e, n, c, a, o) {
        var i = {
            certArr: r,
            symmAlg: t,
            bEncP7: e,
            inType: n,
            inParam: c,
            outType: a,
            outParam: o
        };
        i = tcu.json2Str(i);
        var u, s = TCACore.getInstance();
        try {
            u = s.call("Enc/enc", i)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.ENCRYPT_ERROR),
            null
        }
        return u
    },
    tcu.dec = function(r, t, e, n, c, a, o) {
        var i = {
            certStore: r,
            certIDArr: t,
            bIsP7: e,
            inType: n,
            inParam: c,
            outType: a,
            outParam: o
        };
        i = tcu.json2Str(i);
        var u, s = TCACore.getInstance();
        try {
            u = s.call("Dec/dec", i)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.DECRYPT_ERROR),
            null
        }
        return u
    },
    tcu.checkHashAlg = function(r, t) {
        if ("SM2" === this.publicKeyAlg() && t != TCA.SM3 || "RSA" === this.publicKeyAlg() && t === TCA.SM3) return TCACErr.throwErr(ERRMAP.SIGN_ERROR_HASH_ALG),
        null
    },
    tcu.getSrvVersion = function() {
        var r, t = TCA.IO.MSG,
        e = '{"outType" :' + t + "}",
        n = TCACore.getInstance();
        try {
            r = n.call("Server/version", e)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.ERROR_CALL_SRV_VER),
            null
        }
        return r
    },
    tcu.ajax = function(jsonParam) {
        var url = jsonParam.url,
        data = jsonParam.data,
        successCallback = jsonParam.success,
        errorCallback = jsonParam.error,
        request = new XMLHttpRequest;
        try {
            if (request.open("POST", url, !1), request.setRequestHeader("Content-Type", "application/json; charset=UTF-8"), request.send(data), 200 == request.status) {
                var ret = eval("(" + request.responseText + ")");
                return void successCallback(ret)
            }
            //if (request.open("POST", url, !1), request.setRequestHeader("Content-Type", "application/json; charset=UTF-8"), request.send(data), 200 == request.status) return void successCallback(eval("(" + request.responseText + ")"))
        } catch(r) {
            return void errorCallback(request, request.statusText, "send error & no error thrown")
        }
        errorCallback(request, request.statusText, "no error thrown")
    },
    tcu.hash = function(r, t, e, n, c) {
        var a = {
            hash: r,
            inType: t,
            inParam: e,
            outType: n,
            outParam: c
        };
        a = tcu.json2Str(a);
        var o, i = TCACore.getInstance();
        try {
            o = i.call("Hash/hash", a)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.DECRYPT_ERROR),
            null
        }
        return o
    },
    tcu.random = function(r) {
        var t = {
            byteLen: r
        };
        t = tcu.json2Str(t);
        var e, n = TCACore.getInstance();
        try {
            e = n.call("rand/rand", t)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.DECRYPT_ERROR),
            null
        }
        return e
    },
    tcu.symm = function(r, t, e, n, c, a, o, i) {
        var u = {
            isEnc: n,
            b64Key: r,
            b64IV: t,
            symmAlg: e,
            inType: c,
            inParam: a,
            outType: o,
            outParam: i
        };
        u = tcu.json2Str(u);
        var s, C = TCACore.getInstance();
        try {
            s = C.call("symm/symm", u)
        } catch(r) {
            return TCACErr.throwErr(r, ERRMAP.DECRYPT_ERROR),
            null
        }
        return s
    };
})();

var ca_key = (function() {
    var Const_Vender_Code = "SCCA";
    var Const_Sign_Type = "UKEY";

	 wsbClientObj = TCA  
     try{
        // 初始化
        wsbClientObj.config({});
     }catch(e){
        // TopESA接口的错误处理使用异常机制。
        // 接口抛出的异常均为TCACErr类型，以下处理方式仅为示例
        if( e instanceof TCACErr ){
            alert(e.toStr());
        }else{
            alert("other JS Error");
            alert(e);
        }
     }
   
    var nRetryCount = 0;
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

    //提供给业务系统的接口01: 获取Ukey列表
    //返回串格式为    证书名称||硬件UKey的SN(之后获取信息使用)&&&..
    function GetUserList(){        
        var result = ""
        var userList0 = wsbClientObj.SOF_GetUserList();
        if (userList0 == "")
            return "";
        
        var userListArr = userList0.split("&&&");
        for (var i =0; i < userListArr.length; i++) {
            var tmpkey = userListArr[i].split("||")[1];
            var tmpName = userListArr[i].split("||")[0];
            var isValid = isValidCert(tmpkey);
            if (!isValid) continue;
            
            if (result == "") {
                result = tmpName + "||" + tmpkey;
            } else {
                result = result + "&&&" + tmpName + "||" + tmpkey ;
            }
        }
        return result;
    }
    
    //判断证书是否有效  
    function isValidCert(key) {
        var cert = GetSignCert(key)
        var ret = wsbClientObj.SOF_ValidateCert(cert);
        return ret;
    }

    //提供给业务系统的接口02：验证Ukey密码
    function Login(strFormName, strCertID, strPin) {
	    //var ret = wsbClientObj.SOF_Login(strCertID, strPin, nRetryCount); 
        var ret = wsbClientObj.SOF_Login(strCertID, strPin); 
        if (!ret) {
            nRetryCount = nRetryCount + 1; 
            alert("密码输入错误");
            return false;
        }
        return true;
    }

    //提供给业务系统的接口03: 数据Hash
    function HashData(inData){
        if (inData == "") return "";
        
        var rtn = iGetData("HashData",inData);
        if ((rtn.retCode == "0")) {
            return rtn.hashData;
        } else {
            return "";
        }
    }

    //提供给业务系统的接口04：数据签名
    function SignedData(content,key){        
        var signedValue = wsbClientObj.SOF_SignDataByP7(key, content);
        return signedValue;    
    }

    //提供给业务系统的接口04：数据签名, 兼容性支持医生站
    function SignedOrdData(content, key) {
        return SignedData(content,key);
    }

    //提供给业务系统的接口05：获取指定Ukey的信息
    function getUsrSignatureInfo(key){
        var usrSignatureInfo = new Array();
        var usrSignatureInfo = {};
        
        var certB64 = GetSignCert(key);
        usrSignatureInfo["certificate"] = certB64;
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64,key);
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        usrSignatureInfo["VenderCode"] = "SCCA";
        usrSignatureInfo["SignType"] = "UKEY";
        return usrSignatureInfo;
    }

    //获取Ukey证书
    function GetSignCert(key){
        var cert = wsbClientObj.SOF_ExportUserCert(key);
        return cert;
    }

    //获取用户唯一标识UsrCertCode  这里获取的身份证号
    function GetUniqueID(cert,key){
        var oid = "1.2.156.112646.8";
        var ret = wsbClientObj.SOF_GetCertInfoByOid(cert, oid);
        return ret;
    }

    //获取用户身份证号
    function GetIdentityID(key) {
        var IdentityIDwithSF = wsbClientObj.SOF_GetUserInfo(key, 2);
        var IdentityID = IdentityIDwithSF.split("SF0")[1]
        return IdentityID;
    }

    //获取证书编号CertificateNo  这里获取的是证书序列号
    function GetCertNo(key) {
        return key;
    }

    //证书序列号CertificateSN
    function GetCertSN(key) {
        return key;
    }

    function GetKeySN(key) {
        return "Not Included";
    }

    //根据Ukey获取签名图base64位编码
    function GetPicBase64Data(key){
	    var IdentityIDwithSF = wsbClientObj.SOF_GetUserInfo(key, 2);
        var IdentityID = IdentityIDwithSF.split("SF0")[1]
        var rtn = iGetData("GetSeal",IdentityID);
        if ((rtn.retCode == "0")) {
            return rtn.signSeal;
        } else {
            return "";
        }
    }

    //获取证书名称
    function GetCertCNName(key) {
        var CertCNName = wsbClientObj.SOF_GetUserInfo(key, 1);
        return CertCNName;
    }

    function getErrorMsg() {
        return "";
    }
    
    ///无记住密码功能IsLogin
    function SOF_IsLogin(key) {
        return false;
    }
    
    function LoginForm(paraObj) {
        return {retCode:"-1"};
    }
    
    return {
        OCX: wsbClientObj,
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetUserList: function() {
            return GetUserList();
        },
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        HashData: function(inData) {
            return HashData(inData);
        },
        SignedData: function(content,key) {
            return SignedData(content,key);
        },
        SignedOrdData: function(content,key) {
            return SignedOrdData(content,key);
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert,key) {
            return GetUniqueID(cert,key);
        },
        GetRealKey: function(key) {
            return key;
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        GetLastError: function() {
            return getErrorMsg();
        },
        IsLogin: function(key) {
            return SOF_IsLogin(key);
        },
        LoginForm:function(paraObj) {
            return LoginForm(paraObj);
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
function HashData(content) {
    return ca_key.HashData(content);
}
///对待签数据的Hash值做签名
function SignedData(contentHash,key) {
    return ca_key.SignedData(contentHash,key);
}
function SignedOrdData(contentHash, key) {
    return ca_key.SignedOrdData(contentHash, key);
}

///5.其他
function LoginForm(paraObj) {
    return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}