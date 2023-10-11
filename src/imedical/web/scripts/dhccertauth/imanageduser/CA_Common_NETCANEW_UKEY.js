var ca_key = (function() {
    
    var Const_Vender_Code = "NETCANEW";
    var Const_Sign_Type = "UKEY";
    
    _CurEncryptedToken = "";

    //全局统一入口
    //TODO:时间戳地址配置，根据需要自己修改
    //确信时间戳测试地址
    //var PKCSTimeStampURL="http://60.216.47.169:8880/tsa";

    //网证通时间戳测试地址
    var PKCSTimeStampURL="http://tsa.cnca.net/NETCATimeStampServer/TSAServer.jsp";
    //使用时间戳开关
    var GNetcaUserTimeStamp=false;

    var NetcaPKI = (function(){
        

           //使用严格模式
           "use strict";
            
            var PKIObject = {};

                //Certificate类
                function Certificate(inCertObject)
                {
              
                    var _this=this;
                    //下层的证书对象
                    _this._cert=inCertObject;
                    
                    if(_this._cert==null)
                        return ; 
                      
                       _this.serialNumber  =_this._cert.SerialNumber;;//Hex编码的证书序列号
                     //todo:crypto 2.0.0以下版本的com会抛异常，这里如果异常设置为"".
                     //2.0.0版本就不抛异常，而且是属性值了，这里这是兼容处理下。                
                     try    
                     {
                         _this.subjectO  =_this._cert.GetStringInfo(NetcaPKI.CERT_ATTRIBUTE_SUBJECT_O);//主体名O
                     }
                     catch(e)
                     {                    
                         _this.subjectO  ="";
                     }   
                                   
                     try    
                     {
                         _this.subjectCN =_this._cert.GetStringInfo(NetcaPKI.CERT_ATTRIBUTE_SUBJECT_CN);//主体名CN
                     }
                     catch(e)
                     {
                         _this.subjectCN ="";
                     }        
                
                    
                }
                /*     声明：
                function encode(type)
                参数：
                    type：编码类型，可选参数，参见2.1.4。缺省值为DER编码
                返回值：
                    返回证书编码。如果type为CERT_ENCODE_DER,则为字节数组，否则为字符串
                说明：
                    获取证书的编码
                */
                 Certificate.prototype.encode=function(type)
                {
                    if(this._cert==null)
                        return null;
                                
                    return this._cert.Encode(type);
                };
                /*声明：
                function getStringExtensionValue(extOid)
                参数：
                    extOid：扩展的OID，字符串类型
                返回值：
                    成功返回字符串扩展的值（字符串类型），没有该扩展返回空串””。
                说明：
                    获取OID为extOid的字符串类型的扩展的值
                */
                Certificate.prototype.getStringExtensionValue=function(extOid)
                {
                    if(this._cert==null)
                        return null;
                     
                     try    
                     {

                            var NETCAPKI_UTF8STRING=1;
                            var utf8data= this._cert.GetExtension(extOid);
                            return NetcaPKI._baseObject.DecodeASN1String(NETCAPKI_UTF8STRING,utf8data);
                     }
                     catch(e)
                     {                    
                            return  "";
                     }              
                
                };
                /*
                声明：
                function computeThumbprint (algo)
                参数：
                    algo：Hash算法，参见2.1.5
                返回值：
                    成功返回Hex编码的证书微缩图的值（字符串类型）
                说明：
                    根据Hash算法计算证书的微缩图
                */
                Certificate.prototype.computeThumbprint=function(algo)
                {
                    if(this._cert==null)
                        return null;
                                 
                    return NetcaPKI.hexEncode(this._cert.ThumbPrint(algo));
                };
                /*
                声明：
                function verifyPwd(pwd)
                参数：
                    pwd：用户密码，字符串类型
                返回值：
                    成功返回true，失败返回false
                说明：
                    验证证书对应私钥的用户密码
                */
                Certificate.prototype.verifyPwd=function(pwd)
                {
                    if(this._cert==null)
                        return null;
                        
                    return  this._cert.VerifyPwd(pwd);              
                };
              
                /*
                声明：
                function getIntegerAttribute (attrId)
                参数：
                    attrId：证书属性ID，参见2.16
                返回值：
                    返回证书整数类型的属性（返回值为数字类型）
                说明：
                    获取整数类型的属性值
                */
                Certificate.prototype.getIntegerAttribute=function(attrId)
                {
                    if(this._cert==null)
                        return null;
            
                    return  this._cert.GetIntInfo(attrId);    
                        
                };   
                
            
                /*
                声明：
                function getStringAttribute (attrId)
                参数：
                    attrId：证书属性ID，参见2.16
                返回值：
                    返回证书字符串类型的属性（返回值为字符串类型），如果是字符串数组类型的，取第一个
                说明：
                    获取证书字符串类型的属性
                */
                Certificate.prototype.getStringAttribute=function(attrId)
                {
                    if(this._cert==null)
                        return null;
            
                    return  this._cert.GetStringInfo(attrId);    
                        
                };  
                
                /* 声明：
                function verifyPwd(pwd)
                参数：
                    pwd：用户密码，字符串类型
                返回值：
                    成功返回true，失败返回false
                说明：
                    验证证书对应私钥的用户密码
                */
                Certificate.prototype.verifyPwd=function(pwd)
                {
                    if(this._cert==null)
                        return null;
                        
                    return  this._cert.VerifyPwd(pwd);              
                };
     
                
            //Certificates类      
            function Certificates()
            {
                this._array= new Array();
                this.length=0;
            }
            /*
            模仿索引访问实现
            */
            Certificates.prototype.resetIndexArray=function()
            {
                var i=0;
                if(this.length>this._array.length)
                {
                    for(i=0;i<this.length;++i)
                    {
                        this[i]=null;
                    }
                }
                this.length=this._array.length;
                for(i=0;i<this.length;++i)
                {
                    this[i]=this._array[i];
                }
            }
            
            Certificates.prototype.push_back=function(data)
            {    
                
                this._array.push(data);       
                this.resetIndexArray();      
            }
            
            try
            {
                PKIObject._baseObject= new ActiveXObject("NetcaPki.Utilities");
            }
            catch(e)
            {
                alert("请检查证书应用环境是否正确安装!");
                return PKIObject;
            }
            
            
            
          function initializeObject(obj)
          {   
                /*
                常量
                */
                //2.1.1公钥类型
                obj.PUBLICKEY_TYPE_RSA=1;//SA类型的公钥
                obj.PUBLICKEY_TYPE_SM2=2;//SM2类型的公钥
                obj.PUBLICKEY_TYPE_ECC=3;//非SM2类型的ECC公钥
                //2.1.2 证书的类别     
                obj.CERT_CLASS_SELFSIGN  =1 ;//自签证书
                obj.CERT_CLASS_SELFISSUER=2	;//自颁发证书
                obj.CERT_CLASS_CA	     =3;//CA证书
                obj.CERT_CLASS_TSA		 =4;//TSA证书
                obj.CERT_CLASS_OCSP		 =5;//OCSP证书
                obj.CERT_CLASS_ORGANIZATION=6;//机构证书
                obj.CERT_CLASS_BUSINESS	=7;//业务证书
                obj.CERT_CLASS_EMPLOYEE	=8;//单位员工证书
                obj.CERT_CLASS_INDIVIDUAL	=9;//	自然人证书
                obj.CERT_CLASS_SERVER	=10	;//服务器证书
                obj.CERT_CLASS_SMIME	=11	;//S/MIME证书
                obj.CERT_CLASS_CODESIGN	=12	;//代码签名证书
                obj.CERT_CLASS_OTHER	=0	;//其他证书
                /*2.1.3 密钥用法
                密钥用法是逐位或的。
                */
                obj.KEYUSAGE_DIGITALSIGNATURE =1;	//签名
                obj.KEYUSAGE_NONREPUDIATION	  =2;	//不可否认
                obj.KEYUSAGE_CONTENTCOMMITMENT	=2;	//不可否认
                obj.KEYUSAGE_KEYENCIPHERMENT	=4;	//加密密钥
                obj.KEYUSAGE_DATAENCIPHERMENT	=8;	//加密数据
                obj.KEYUSAGE_KEYAGREEMENT	=16;	//密钥协商
                obj.KEYUSAGE_KEYCERTSIGN	=32;	//签证书
                obj.KEYUSAGE_CRLSIGN	=64;	//签CRL
                obj.KEYUSAGE_ENCIPHERONLY	=128;	//密钥协商中的只加密
                obj.KEYUSAGE_DECIPHERONLY	=256;	//密钥协商中的只解密
                /*2.1.4 证书的编码类型：*/  
                obj.CERT_ENCODE_DER	=1;	//DER编码
                obj.CERT_ENCODE_BASE64	=2;	//带头和尾的Base64编码
                obj.CERT_ENCODE_BASE64_NO_NL	=3;	//不分行的Base64编码
                /*2.1.5 Hash算法*/           
                obj.MD5	=0x1000;	//MD5算法
                obj.SHA1	=0x2000;	//SHA-1算法
                obj.SHA224	=0x3000;	//SHA-224算法
                obj.SHA256	=0x4000;	//SHA-256算法
                obj.SHA384	=0x5000;	//SHA-384算法
                obj.SHA512	=0x6000;	//SHA-512算法
                obj.SM3	=0x7000;	//SM3算法
                obj.SHA512_224	=0x8000;	//SHA-512/224算法
                obj.SHA512_256	=0x9000;	//SHA-512/256算法
                obj.SHA3_224	=0xA000;	//SHA3-224算法
                obj.SHA3_256	=0xB000;	//SHA3-256算法
                obj.SHA3_384	=0xC000;	//SHA3-384算法
                obj.SHA3_512	=0xD000;	//SHA3-512算法
                /*2.1.6 证书属性*/
     
                obj.CERT_ATTRIBUTE_PRIVKEY_ATTRIBUTE	=1;	//私钥属性，内部使用，不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_VERSION	=2;	//版本号，整型，只读
                obj.CERT_ATTRIBUTE_SIGNALGO	=3;	//签名算法，整型，只读
                obj.CERT_ATTRIBUTE_PUBKEYALGO	=4;	//公钥算法，整型，只读
                obj.CERT_ATTRIBUTE_PUBKEYBITS	=5;	//公钥的位数，整型，只读
                obj.CERT_ATTRIBUTE_KEYUSAGE	=6;	//密钥用法，整型，只读
                obj.CERT_ATTRIBUTE_HAS_PRIVKEY_ATTRIBUTE	=7;	//是否有私钥属性，整型，不在证书编码里，只读
                obj.CERT_ATTRIBUTE_ISSUER	=8;	//颁发者，字符串类型，只读
                obj.CERT_ATTRIBUTE_ISSUER_DISPLAY_NAME	=9;	//颁发者的显示名，字符串类型，只读。如果颁发者有CN则是最后一个CN，有OU则是最后一个OU，有O则是最后一个O，否则是最后一个颁发者项，如果不存在颁发者项则为第一个颁发者备用名
                obj.CERT_ATTRIBUTE_ISSUER_C	=10;	//颁发者的C值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_O	=11;	//颁发者的O值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_OU	=12;	//颁发者的OU值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_CN	=13;	//颁发者的CN值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_EMAIL	=14;	//颁发者的Email值，字符串类型。包含颁发者备用名称里的Email值。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT	=15;	//主体，字符串类型，只读
                obj.CERT_ATTRIBUTE_SUBJECT_DISPLAY_NAME	=16;	//主体的显示名，字符串类型，只读。如果主体有CN则是最后一个CN，有OU则是最后一个OU，有O则是最后一个O，否则是最后一个主体项，如果不存在主体项则为第一个主体备用名
                obj.CERT_ATTRIBUTE_SUBJECT_C	=17;	//主体的C值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_O	=18;	//主体的O值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_OU	=19;	//主体的OU值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_CN	=20;	//主体的CN值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_EMAIL	=21;	//主体的Email值，字符串类型。包含主体用名称里的Email值。可能多值，只读
                obj.CERT_ATTRIBUTE_EX_FRIENDLY_NAME	=22;	//好记的名字，字符串类型。不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_EX_NAME	=23;	//证书拥有者的名称，字符串类型。不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_EX_ORGANIZATION	=24;	//证书拥有者的单位，字符串类型。不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_EX_DEPARTMENT	=25;	//证书拥有者的部门，字符串类型。不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_EX_EMAIL	=26;	//证书拥有者的Email，字符串类型。不在证书编码里。可能多值，可读可写
                obj.CERT_ATTRIBUTE_GET_KEYPAIR_HADNLE_NEED_PWD = 27;	//	获取私钥是否需要密码，证书类型，不在证书编码里，只读
                obj.CERT_ATTRIBUTE_KEYPAIR_HADNLE	=28;	//私钥句柄，内部使用，不在证书编码里，可读可写
                obj.CERT_ATTRIBUTE_PREVCERT_THUMBPRINT=	29;	//更新前的证书的姆印，字符串类型。只读
                obj.CERT_ATTRIBUTE_VALIDITY_START=	30;	//证书的有效期开始时间，字符串类型。格式为YYYYMMDDhhmmssZ或者YYYYMMDDhhmmss.xxxZ的UTC时间，只读
                obj.CERT_ATTRIBUTE_VALIDITY_END	=31;	//证书的有效期结束时间，字符串类型。格式为YYYYMMDDhhmmssZ或者YYYYMMDDhhmmss.xxxZ的UTC时间，只读
                obj.CERT_ATTRIBUTE_SN_DEC	=32;	//10进制的证书序列号，字符串类型。只读
                obj.CERT_ATTRIBUTE_SN_HEX	=33;	//HEX编码的证书序列号，字符串类型。只读
                obj.CERT_ATTRIBUTE_IN_VALIDITY	=34;	//证书是否在有效期内，整型，只读
                obj.CERT_ATTRIBUTE_PRIVATE_ISCSP	=35;	//证书的私钥是否是使用CSP，整型，不在证书编码里，只读
                obj.CERT_ATTRIBUTE_UPN	=36;	//证书的UPN，字符串类型。只读
                obj.CERT_ATTRIBUTE_ISSUER_ST	=37;	//颁发者的ST值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_L	=38;	//颁发者的L值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_ST	=39;	//主体的ST值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_L	=40;	//主体的L值，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_EX_DEVICE_TYPE=	41;	//证书对应私钥的设备的类型，整型，不在证书编码里，只读
                obj.CERT_ATTRIBUTE_EX_DEVICE_SN	=42;	//证书对应私钥的设备的序列号，字符串类型，不在证书编码里，只读
                obj.CERT_ATTRIBUTE_PUBKEY_ECC_CURVE	=43;	//ECC证书的曲线号，整型，只读
                obj.CERT_ATTRIBUTE_THUMBPRINT	=44;	//证书的微缩图，Hash值
                obj.CERT_ATTRIBUTE_HASH_ISSUER	=45;	//证书的颁发者的编码的Hash值，Hash值。
                obj.CERT_ATTRIBUTE_HASH_SUBJECT	=46;	//证书的主体的编码的Hash值，Hash值。
                obj.CERT_ATTRIBUTE_HASH_PUBKEY	=47;	//证书的公钥的编码的Hash值，Hash值。
                obj.CERT_ATTRIBUTE_ISSUER_LDAP_NAME	=48;	//证书颁发者名的LDAP表示，字符串类型。只读
                obj.CERT_ATTRIBUTE_ISSUER_XMLSIG_NAME	=49;	//证书颁发者名的XML签名要求的字符串表示，字符串类型。只读
                obj.CERT_ATTRIBUTE_SUBJECT_LDAP_NAME	=50;	//证书主体名的LDAP表示，字符串类型。只读
                obj.CERT_ATTRIBUTE_SUBJECT_XMLSIG_NAME	=51;	//证书主体名的XML签名要求的字符串表示，字符串类型。只读
                obj.CERT_ATTRIBUTE_SUBJECT_HEX_ENCODE	=52;	//证书主体的DER编码再Hex编码，字符串类型，只读
                obj.CERT_ATTRIBUTE_ISSUER_HEX_ENCODE	=53;	//证书颁发者的DER编码再Hex编码，字符串类型，只读
                obj.CERT_ATTRIBUTE_CHECK_PRIVKEY	=54;	//不验证密码连接设备检测是否存在密钥对。整型，只读
                obj.CERT_ATTRIBUTE_CSP_NAME	=55;	//私钥对应的CSP名称，字符串类型，只读
                obj.CERT_ATTRIBUTE_CRL_URL	=56;	//证书CRL发布点扩展里的URL，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_DELTA_CRL_URL	=57;	//证书FreshCRL扩展里的URL，字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_OCSP_URL	=58;	//证书AIA扩展里的OCSP URL。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_IP	=59;	//主体备用名里的IP地址。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_DNS_NAME	=60;	//主体备用名里的DNS。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_CERT_POLICY_OID	=61;	//证书策略OID。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_EXTENDED_KEY_USAGE	=62;	//扩展密钥用法OID。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_HASH_SUBJECT_PUBKEY_INFO	=63;	//主体公钥信息的DER编码的Hash, Hash值。
                obj.CERT_ATTRIBUTE_SMIMECAPABILITIES	=65;	//SmimeCapabilities扩展。字符串类型，只读。是个JSON数组，每个项是个数组，数组里的有一到两项，第一项为字符串，OID。第二项如果存在的话，为字符串，参数的Hex编码。
                obj.CERT_ATTRIBUTE_SUBJECT_KEYID	=66;	//主体密钥标识符的Hex编码。字符串类型，只读。
                obj.CERT_ATTRIBUTE_ISSUER_DN_QUALIFIER	=67;	//颁发者的DN Qualifier。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_SUBJECT_DN_QUALIFIER	=68;	//主体的DN Qualifier。字符串类型。可能多值，只读
                obj.CERT_ATTRIBUTE_ISSUER_SN	=69;	//颁发者的序列号。字符串类型。可能多值，只读。注意：不是证书的序列号
                obj.CERT_ATTRIBUTE_SUBJECT_SN	=70;	//主体的序列号。字符串类型。可能多值，只读。注意：不是证书的序列号
                obj.CERT_ATTRIBUTE_ISSUER_TITLE	=71;	//颁发者的Title。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_TITLE	=72;	//主体的Title。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_SURNAME	=73;	//颁发者的surname。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_SURNAME	=74;	//主体的surname。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_GIVEN_NAME	=75;	//颁发者的given name。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_GIVEN_NAME	=76;	//主体的given name。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_INITIALS	=77;	//颁发者的initials。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_INITIALS	=78;	//主体的initials。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_PSEUDONYM	=79;	//颁发者的pseudonym。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_PSEUDONYM	=80;	//主体的pseudonym。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_GENERATION_QUALIFIER	=81;	//颁发者的generation qualifier。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_GENERATION_QUALIFIER	=82;	//主体的generation qualifier。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_DC	=83;	//颁发者的DC。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_DC	=84;	//主体的DC。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_UID	=85;	//颁发者的UID。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_UID	=86;	//主体的UID。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_STREET	=87;	//颁发者的street。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_STREET	=88;	//主体的street。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_CAISSUERS_URL	=89;	//颁发者证书的URL，字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_JURISDICTION_L	=90;	//主体的管辖地的L, 字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_JURISDICTION_ST	=91;	//主体的管辖地的ST, 字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_JURISDICTION_C	=92;	//主体的管辖地的C, 字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_SUBJECT_BUSINESS_CATEGORY	=93;	//主体的business category, 字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_GB_IDENTITY_CODE	=94;	//国标的个人身份识别码。字符串类型。只读
                obj.CERT_ATTRIBUTE_CRICAL_EXTENSIONS	=95;	//所有的关键扩展的OID。字符串类型。可能多值，只读。
                obj.CERT_ATTRIBUTE_ISSUER_AND_SERIALNUMBER	=96;	//颁发者名和序列号的DER编码后再Hex编码。字符串类型。只读
                obj.CERT_ATTRIBUTE_ISSUER_REVERSE	=97;	//反序的颁发者。字符串类型。只读
                obj.CERT_ATTRIBUTE_SUBJECT_REVERSE	=98;	//反序的主体。字符串类型。只读
                obj.CERT_ATTRIBUTE_CERT_CLASS	=99;	//证书的类别。整型，只读。参见4.1.58
                obj.CERT_ATTRIBUTE_CERT_CLASS_EXT_VALUE	=100;	//1.3.6.1.4.1.18760.1.12.12.2证书类别扩展的值，字符串类型。只读
                obj.CERT_ATTRIBUTE_SHENZHEN_SUBJECT_UNIQUE_ID	=101;	//2.16.156.112548深圳地标用户唯一标识的值，字符串类型。只读
                obj.CERT_ATTRIBUTE_NETCA_SUBJECT_UNIQUE_ID	=102;	//1.3.6.1.4.1.18760.1.12.11NETCA用户唯一标识的值，字符串类型。只读
                obj.CERT_ATTRIBUTE_KEYPAIR_INFO_STRING	=103;	//证书相关密钥对的连接信息的字符串表示，字符串类型。只读
         
                /*2.1.7 过滤表达式比较操作*/           
                obj.CONDITION_TYPE_EQUAL	=1;	//相等
                obj.CONDITION_TYPE_NOT_EQUAL	=2;	//不等
                obj.CONDITION_TYPE_CONTAIN	=3;	//包含
                obj.CONDITION_TYPE_NOT_CONTAIN	=4;	//不包含  
                /*2.1.7弹出UI的方式*/          
                obj.UIFLAG_DEFAULT_UI	=1;	//没有或者仅有一个不弹对话框选择
                obj.UIFLAG_NO_UI	=2;	//从不弹对话框选择，如果不是仅有一个返回null
                obj.UIFLAG_ALWAYS_UI	=3;	//总是弹对话框选择          
                /*2.1.8用户证书的类型*/
                //可以或起来使用            
                obj.GET_USERCERT_TYPE_ENCRYPT	=1;//解密证书
                obj.GET_USERCERT_TYPE_SIGN	=2;	   //签名证书        
                    
                /*2.1.9 SignedData验证的结果*/      
                obj.SUCCESS	=1;	//成功
                obj.FAIL	=0;//失败
                obj.VERIFY_SIGNEDDATA_PARTLY_FAIL	=-32;	//验证SignedData时，至少一个签名成功，但存在验证签名的签名
                obj.VERIFY_SIGNEDDATA_CERT_FAIL	=-36;	//验证SignedData的证书失败
                obj.SIGNEDDATA_BAD_DATA	=-41;	//SignedData格式错误
                obj.SIGNEDDATA_VERIFY_CONTENT_TYPE_FAIL	=-42;	//验证SignedData的Content-Type失败
                obj.SIGNEDDATA_VERIFY_HASH_FAIL	=-43;	//验证SignedData的Hash失败
                obj.SIGNEDDATA_VERIFY_SIGNATURE_FAIL	=-44;	//验证SignedData的签名失败
                obj.SIGNEDDATA_NO_MATCH_CERT	=-45;	//没有签名证书用于验证SignedData的签名
                obj.SIGNEDDATA_TBS_MISMATCH	=-84;	//SignedData的原文不匹配
                obj.SIGNEDDATA_SIGNEDCERT_MISMATCH	=-85;	//SignedData的签名证书不匹配
                obj.SIGNEDDATA_UNACCEPTABLE_SIGNALGO	=-86;	//不可接受的SignedData签名算法
                obj.SIGNEDDATA_OUTER_CONTENTINFO_MISMATCH	=-87;	//SignedData的ContentInfo不匹配
                obj.SIGNEDDATA_UNACCEPTABLE_SIGNINGCERT_ATTRIBUTE	=-88;	//不可接受的SigningCert属性                    
                /*2.1.10 签名算法*/            
                obj.SHA1WITHRSA	=2;	//SHA1WthRSA签名算法
                obj.SHA224WITHRSA	=3;//	SHA224WthRSA签名算法
                obj.SHA256WITHRSA	=4;//	SHA256WthRSA签名算法
                obj.SHA384WITHRSA	=5;//	SHA384WthRSA签名算法
                obj.SHA512WITHRSA	=6;	//SHA512WthRSA签名算法
                obj.SM3WITHSM2	=25;//SM3WithSM2签名算法           
                /*2.1.11 数字信封的对称加密算法*/           
                obj.AES128CBC	=4;	//AES-128
                obj.AES192CBC	=5;//AES-192
                obj.AES256CBC	=6;	//AES-256
                obj.SM4CBC	=9;	//SM4            
                /*2.1.12 SignedData的包含证书的选项*/           
                obj.INCLUDE_CERT_OPTION_NONE	=1	;//不包含任何证书
                obj.INCLUDE_CERT_OPTION_SELF	=2	;//仅包含签名的证书
                obj.INCLUDE_CERT_OPTION_CERTPATH	=3;	//包含整个证书链，不包含根证书
                obj.INCLUDE_CERT_OPTION_CERTPATHWITHROOT	=4;	//包含整个证书链，且包含根证书
                
                /*2.1.13 密码缓存选项*/
                
                obj.NO_CACHE_PWD	=1;	//不缓存密码
                obj.CACHE_PWD	=0;	//缓存密码
                obj.NO_CACHE_PWD_AND_CLEAR_CACHE	=-1;	//不缓存密码，且清掉以前的缓存
                /*2.1.14 证书的状态*/            
                obj.CERT_STATUS_UNREVOKED	=1;	//证书有效
                obj.CERT_STATUS_UNDETERMINED	=-1;	//证书的状态不能确定
                obj.CERT_STATUS_REVOKED	 =0	;//证书已作废
                obj.CERT_STATUS_CA_REVOKED	=-2;	//上级CA证书已作废
                obj.CERT_STATUS_NOT_IN_VALIDITY	=-100;	//证书不在有效期内
                obj.CERT_STATUS_BULID_CERTPAT_FAIL	=-101;	//没有安装证书链
                obj.CERT_STATUS_VERIFY_CERTPATH_FAIL	=-102;	//验证证书链失败
                obj.CERT_STATUS_NO_REVOKE_INFO	=-103;	//没有合适的作废信息
                obj.CERT_STATUS_ON_HOLD	=-104;	//证书已挂失           
                /*2.1.15 验证证书的标识*/
                /*或起来使用。
                0为仅仅验证证书路径，不验证证书的作废状态*/           
                obj.CERT_VERIFY_FLAG_VERIFY_REVOKE	=1;	//验证作废状态
                obj.CERT_VERIFY_FLAG_ONLINE	=2;	//在线获取作废信息
                obj.CERT_VERIFY_FLAG_VERIFY_CACERT_REVOKE	=4;	//验证CA证书的作废状态
                obj.CERT_VERIFY_FLAG_VERIFY_OCSP	=0x10;	//通过OCSP验证证书的作废状态
                obj.CERT_VERIFY_FLAG_VERIFY_CRL	=0x20;	//通过CRL验证证书的作废状态
                
                
                obj.BASE64_NO_NL	=1;
                obj.BASE64_STRICT	=2;
                 
                //证书库类型
                obj.CERT_STORE_TYPE_CURRENT_USER=0;
                obj.CERT_STORE_TYPE_LOCAL_MACHINE=	1;
                obj.CERT_STORE_TYPE_MEMORY	=		2;
                
                obj.CERT_STORE_NAME_MY	=	"my";
                obj.CERT_STORE_NAME_OTHERS="others";
                obj.CERT_STORE_NAME_CA	=	"ca";
                obj.CERT_STORE_NAME_ROOT	="root";
                obj.CERT_STORE_NAME_DEVICE  ="device";
                
                obj.OK	=0;	//调用成功
                //obj._baseObject.SetErrorMode(false);

       }
       

        //获取设备信息
        PKIObject.GetDeviceFromCert = function(certObj)
        {

            var NETCAPKI_DEVICETYPE_ANY = -1;
            var NETCAPKI_DEVICEFLAG_CACHE_PIN_IN_PROCESS = 0;
            var NETCA_PKI_CERT_ENCODE_BASE64_NO_NL = 3;
            var checkEncode = certObj._cert.Encode(NETCA_PKI_CERT_ENCODE_BASE64_NO_NL);


            try {

                var deviceSet = PKIObject._baseObject.CreateDeviceSetObject();
                deviceSet.GetAllDevice(NETCAPKI_DEVICETYPE_ANY, NETCAPKI_DEVICEFLAG_CACHE_PIN_IN_PROCESS);
                var count = deviceSet.Count;
                for (var index = 1; index <= count; ++index) {
                    var device = deviceSet.Item(index);

                    var keyPair = null;

                    var paircount = device.GetKeyPairCount();

                    for (var s = 1; s <= paircount; ++s) {
                        keyPair = device.GetKeyPair(s);
                        var certCount = keyPair.GetCertificateCount();
                        for (var n = 1; n <= certCount; ++n) {
                            var cert = keyPair.GetCertifcate(n);
                            if (cert.Encode(NETCA_PKI_CERT_ENCODE_BASE64_NO_NL) == checkEncode) {
                                return device;
                            }


                        }
                        keyPair = null;
                    }


                }
            }
            catch(e)
            {
                return null;
            }

          
            
            return  null;
        };

       
        /***
        *获取USBKey设备中满足指定条件的所有的证书
        *@params
        *              device, 设备对象
        *@return
        *           成功返回证书对象数组，失败抛出异常。
        *@reamrk, 应该处理异常信息
        ***/
        PKIObject.GetCertificatesInDevice = function(device)
        {


            var certArray = new Array();
            var keyPair = null;
            try
            {
                var count = device.GetKeyPairCount();
                
                for( var s = 1; s <= count; ++s)
                {
                    keyPair = device.GetKeyPair(s);
                    var certCount = keyPair.GetCertificateCount();
                    for( var n = 1; n <= certCount; ++n)
                    {
                        var cert = keyPair.GetCertifcate(n);
                
                         certArray.push(cert);
                
                    }
                    keyPair = null; 
                }
            }
            finally
            {
                keyPair= null;
            }
            
            return  certArray;
        };


       PKIObject.getCertsFromDevice=function()
        {
            var NETCAPKI_DEVICETYPE_ANY = -1;
            var NETCAPKI_DEVICEFLAG_CACHE_PIN_IN_PROCESS = 0;
            
            //var signatureKeyUseageFlg = 1 | 2 | 16 | 32 | 64;
            var signatureKeyUseageFlg = 1 | 2 ;
            var now=new Date();

            var deviceSet = null;
            var device = null;
            try
            {
            
               
               var certArray = new Certificates();
      
               deviceSet =  PKIObject._baseObject.CreateDeviceSetObject();
               deviceSet.GetAllDevice(NETCAPKI_DEVICETYPE_ANY,NETCAPKI_DEVICEFLAG_CACHE_PIN_IN_PROCESS);
               
               var count = deviceSet.Count;

               for( var index = 1; index <= count; ++index)
               {
                   device = deviceSet.Item(index);
                   var certs= PKIObject.GetCertificatesInDevice(device);
                   for( var s = 0; s < certs.length; ++s)
                   {    

                     if(certs[s].ValidFromDate<=now && certs[s].ValidToDate>=now && 
                     (certs[s].KeyUsage &signatureKeyUseageFlg)!=0)
                     {
                       certArray.push_back(new Certificate(certs[s]));
                     }
                    
                  }
                   
                   device = null;
               }

               return certArray;
            }
            finally
            {
                deviceSet = null;
                device = null;
            }

              return certArray;
        };// 
     
        /*  声明：
        function getCertsFromDevice()
        参数：
            无
        返回值：
            成功返回设备里所有证书组成的Certificates对象，失败返回null
        */
       /* PKIObject.getCertsFromDevice=function()
        {
         
            var signatureKeyUseageFlg = 1 | 2 | 16 | 32 | 64;
            var n = 1;
            var now=new Date();
            var store = PKIObject._baseObject.CreateStoreObject();
            store.Open(NetcaPKI.CERT_STORE_TYPE_CURRENT_USER,NetcaPKI.CERT_STORE_NAME_DEVICE);
            
            var certCount = store.GetCertificateCount();    
            var certArray = new Certificates();
            var cert;
            for(n = 1; n <= certCount; ++n)
            {
                
                cert = store.GetCertificate(n);
                if(cert.ValidFromDate<=now && cert.ValidToDate>=now && 
                (cert.KeyUsage &signatureKeyUseageFlg)!=0)
                {
                   certArray.push_back(new Certificate(cert));
                }
                
            }
            
            store.close();
            store=null;
            if(certArray.length<=0)
            {
                certArray=null;
                return null;
            }   
            return certArray;
        }  */
        
        /*声明：
        function getCerts(certs)
        参数：
            certs:Certificate数组，可以为空数组
        返回值：
            成功返回数组所有证书组成的Certificates对象，失败返回null
        说明：
            根据证书数组构造Certificates对象
        */
        PKIObject.getCerts=function(certs)
        {
            
            if(certs==null)
             return null;
             
            if (!(typeof certs === 'object' && !isNaN(certs.length)))
            { 
                return null;
            }
            var index = 0;
            var CertificatesArray = new Certificates(); 
            for( index = 0; index < certs.length; ++index)
            {
                  CertificatesArray.push_back(certs[index]);
            
            }
            return CertificatesArray;
        }
       
      
       
        
        PKIObject.isSM2Cert=function(cert)
        {

            if(cert==null)
            {
                return false;
            }
            //证书的公钥算法
            var NETCA_PKI_ALGORITHM_ECC = 4;
            var NETCA_PKI_ECC_CURVE_SM2= 7;

            var publicAlgo=cert._cert.GetIntInfo(PKIObject.CERT_ATTRIBUTE_PUBKEYALGO);    
            if(publicAlgo == NETCA_PKI_ALGORITHM_ECC)
            {        
                var  curve=cert._cert.GetIntInfo(PKIObject.CERT_ATTRIBUTE_PUBKEY_ECC_CURVE);
                if(NETCA_PKI_ECC_CURVE_SM2 ==curve)
                {
                   return true;
                }
            }
                
            return false;
            

        }
        
        
        /*3.2.15 signPKCS7ByCert
        声明：
        function signPKCS7ByCert(cert,detached,tbs)
        参数：
            detached:为真表示不带原文，为假表示带原文。布尔类型
            tbs：原文，可以是Byte数组，也可以是字符串，如果是字符串，则是对其UTF-8编码后才进行签名
        返回值：
            成功返回SignedData签名得到的结果，BASE64字符串
        说明：
            SignedData签名。
        */
        PKIObject.signPKCS7ByCert=function(cert,detached,tbs)
        { 
            
            if(cert==null)
            {
                return null;
            }     
            var utf8tbs=PKIObject.stringEncode(tbs);
            var NETCAPKI_CMS_ENCODE_BASE64=2;
            var signedDataObject=PKIObject._baseObject.CreateSignedDataObject();  
            signedDataObject.SetSignCertificate(cert._cert,"", false);

            if(PKIObject.isSM2Cert(cert))
            {
                signedDataObject.SetSignAlgorithm(-1, NetcaPKI.SM3WITHSM2);
            }
            else
            {    
                signedDataObject.SetSignAlgorithm(-1, NetcaPKI.SHA1WITHRSA);      
            }
            
            signedDataObject.Detached = false;
            signedDataObject.SetIncludeCertificateOption(NetcaPKI.INCLUDE_CERT_OPTION_SELF);
            if(GNetcaUserTimeStamp)
            {
                return  signedDataObject.SignWithTSATimeStamp(PKCSTimeStampURL,utf8tbs,NETCAPKI_CMS_ENCODE_BASE64);
            }
            else
            {
        
       

                return  signedDataObject.Sign(utf8tbs,NETCAPKI_CMS_ENCODE_BASE64);
            }
         
        }
       
        
        
        
        /* 声明：
        function hash(algo,data)
        参数：
            algo:Hash算法,参见2.1.5
            data:要进行Hash的数据，可以是Byte数组，也可以是字符串，如果是字符串，则是对其UTF-8编码后才进行hash
        返回值：
            返回Hex编码的Hash值
        说明：
            Hash运算
        */
        PKIObject.hash=function(algo,data)
        {   
            //算摘要前采用（UTF-16LE）
            var utf8data=PKIObject.stringEncode(data); 
            var deviceObject=PKIObject._baseObject.CreateDeviceObject();              
            var pVal = deviceObject.Hash(algo,utf8data);
            return  PKIObject._baseObject.BinaryToHex(pVal, true);
        }
        
        
        /*
        声明：
        function hexEncode(data)
        参数：
            data：要进行编码的数据，Byte数组
        返回值：
            返回Hex编码的字符串，字符串类型
        说明：
            Hex编码
        */
        PKIObject.hexEncode=function(data)
        {       
            //这里默认都是大写
            return PKIObject._baseObject.BinaryToHex(data, true);       
        }
        /*声明：
        function hexDecode(hex)
        参数：
            hex：要进行Hex解码的字符串，字符串类型
        返回值：
            返回Hex解码后的数据，Byte数组
        说明：
            Hex解码
        */
        PKIObject.hexDecode=function(hex)
        {       
            return PKIObject._baseObject.HexToBinary(hex);       
        }
        
        /*声明：
        function base64Encode(data[,multiLine])
        参数：
            data：要进行编码的数据，Byte数组
            multiLine:为真表示多行编码，为假表示不分行。布尔类型，可选参数，默认为false
        返回值：
            返回Base64编码的字符串，字符串类型
        说明：
            Base64编码
        */
        PKIObject.base64Encode=function(data,multiLine)
        {   
            var   NETCA_PKI_BASE64_NO_NL	=1;
            var   NETCA_PKI_BASE64_STRICT	=2;
            var bmultiLine=NETCA_PKI_BASE64_NO_NL;
            if(multiLine!=null&&multiLine)
            {
                bmultiLine=NETCA_PKI_BASE64_STRICT;
            }
            return PKIObject._baseObject.Base64Encode(data,bmultiLine);       
        }
        /* 声明：
        function base64Decode(b64Str[,strict])
        参数：
            b64Str：Base64编码的字符串，字符串类型
            strict:为真表示仅仅处理不分行的Base64编码，为假表示分行和不分行都可以解码。布尔类型，可选参数，默认为false
        返回值：
            返回Base64解码后的数据，Byte数组
        说明：
            Base64解码
        */
        
        PKIObject.base64Decode=function(data,strict)
        {     
            
           var   NETCA_PKI_BASE64_NO_NL		=1;
           var   NETCA_PKI_BASE64_STRICT	=2;
           var   bStrict=NETCA_PKI_BASE64_NO_NL;

            if(strict!=null&&strict)
            {
                bStrict=NETCA_PKI_BASE64_STRICT;
            }
            return PKIObject._baseObject.Base64Decode(data,bStrict);       
        }
        /*声明：
        function stringEncode(str[,charset])
        参数：
            str：要进行编码的字符串，字符串类型
            charset:字符集，字符串类型，可选参数，默认为utf-8。
        返回值：
            返回字符串的编码，Byte数组
        说明：
            字符串编码
        */
        PKIObject.stringEncode=function(str,charset)
        {
            var NETCAPKI_CP_UTF8	=	65001;     
            var incharset=NETCAPKI_CP_UTF8;
            if(charset!=null)
            {
                incharset=charset;
            }
            return PKIObject._baseObject.Encode(str,incharset);       
        }
        
        /*声明：
        function newString (data[,charset])
        参数：
            data：字符串的编码，Byte数组
            charset:字符集，字符串类型，可选参数，默认为utf-8。
        返回值：
            返回字符串的编码，Byte类型
        说明：
            根据字符串编码构造字符串
        */
        PKIObject.newString=function(data,charset)
        {
            var NETCAPKI_CP_UTF8	=	65001;     
            var incharset=NETCAPKI_CP_UTF8;
            if(charset!=null)
            {
                incharset=charset;
            }
            return PKIObject._baseObject.Decode(data,incharset);       
        }
      
          /*声明：
        function DecodeCert (data)
        参数：
            data：字符串的编码，Byte数组
           
        返回值：
            返回证书对象
        说明：
            根据字符串编码证书对象
        */
        PKIObject.DecodeCert=function(data)
        {
            var certObject=PKIObject._baseObject.CreateCertificateObject();   
            certObject.Decode(data);     
            return  new Certificate(certObject);
        }
      

        initializeObject(PKIObject);
        
        return PKIObject;
        
    }());
    
    
	//根据获取用户列表的name值
    //参数 cert是certificate对象
    function getUserListName(cert)
    {
        //获取逻辑:证书的主题的CN项,没有就O项
         if(cert.subjectCN=="")
         {
             return cert.subjectO;
         }
         
         return cert.subjectCN;
    }

    //根据获取用户列表的Key值
    //参数 cert是certificate对象
    function getUserListKey(cert)
    {
        //获取逻辑:获取netca拓展oid
        //1.3.6.1.4.1.18760.1.12.11
        //如果没有用sha1算法的证书拇印
         var oidString=cert.getStringExtensionValue("1.3.6.1.4.1.18760.1.12.11");
         if(oidString=="")
         {
             return cert.computeThumbprint(NetcaPKI.SHA1);
         }

         if(typeof oidString === "string")
         {
             return oidString;
         }
         
         return "";
    }
    //根据key获取设备证书库的证书
    function getCertByValue(key)
    {
        var certArray = NetcaPKI.getCertsFromDevice();
        var i=0;
        for (i = 0; i < certArray.length; i++) 
        {     
            var localkey=getUserListKey(certArray[i]);
            if(localkey=="")
            {
                continue;
            }
            if(key==localkey)
            {
                return certArray[i];
            }
           
        }
        return null;
    }

    // 1.function GetUserList() 返回当前插入的UsbKey中用户列表,格式 Name||key&&& Name||key
    // 注:Name是用于登录,选择UsbKey时,显示的名称,
    // Key为证书号或者用以取UsbKey相关数据的信息

    function GetUserList() {
        var rt = "";
        var i=0;
        
        var certArray = null;
        if (NetcaPKI) var certArray = NetcaPKI.getCertsFromDevice();
        
        if (certArray==null) 
        {
            return rt;
        };
        for (i = 0; i < certArray.length; i++) 
        {
            var oCert = certArray[i];
            if (i == 0) 
            {
                rt = rt + getUserListName(oCert)+ "||" + getUserListKey(oCert);
            }
            else 
            {
                rt = rt + "&&&" + getUserListName(oCert) + "||" + getUserListKey(oCert);
            }
        }

        return rt;
    }



    // 2. function HashData(InData) 对传入的数据生成Hash值
    function HashData(InData) {
        
        return NetcaPKI.hash(NetcaPKI.SHA1,InData);
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
        
        var oCert = getCertByValue(key);
        if(oCert==null)
        {
            
            alert("签名错误，未找到证书!");
            return "";
        }
        try{
            return NetcaPKI.signPKCS7ByCert(oCert,true,content);
        }
        catch (e){
            alert("签名错误，请检查是否插入KEY");
            return "";
        }
    }

    // 4. function GetSignCert(key) 获取证书pem字符串, key参见function 1
    function GetSignCert(key) 
    {
        var oCert = getCertByValue(key);
        if(oCert==null)
        {		
            return "";
        }
        
        var certPem = oCert.encode(NetcaPKI.CERT_ENCODE_BASE64_NO_NL);
        return certPem;
    }


    // 5. function GetUniqueID(cert)
    // 获取证书唯一编码,
    // 参数为Base64编码的证书
    function GetUniqueID(cert) 
    {
        var oCert = NetcaPKI.DecodeCert(cert);
        return getUserListKey(oCert);
    }

    // 6. function GetCertNo(key) 证书序列号hex
    function GetCertNo(key) {
        var oCert = getCertByValue(key);
        return oCert.serialNumber;
    }

    function GetNetcaSealImage(oCert)
    {
        var sealimage="";

        try
        {		
                var Base64CertPem = oCert.encode(NetcaPKI.CERT_ENCODE_BASE64_NO_NL);
                var iUtilTool = new ActiveXObject("Netca.UtilTool");
                sealimage = iUtilTool.GetBase64ImgFrmDevByCert(Base64CertPem);
        
        }
        catch (e)
        {

                sealimage="";
        
        }
        if (typeof sealimage === "undefined"||sealimage=="")
        {
                sealimage="";
        }

        return  sealimage;
    }


    // 7.获取UsbKey中的信息
    function getUsrSignatureInfo(key)
    {
        
        var oCert = getCertByValue(key);

        if(oCert==null)
        {
            return null;
        }



        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = ""; // 身份证号;
        usrSignatureInfo["certificate"]  =   GetSignCert(key); // 证书; GetSignCert(key)

        usrSignatureInfo["certificateNo"] = getUserListKey(oCert); // 证书号;
        usrSignatureInfo["CertificateSN"] = oCert.serialNumber; // 证书序列号;

        usrSignatureInfo["uKeyNo"] = ""; // 我们壳子上面没有Key的编号,有客户的名字是否可以?
        usrSignatureInfo["signImage"] = GetNetcaSealImage(oCert); // sealArry[0]; // 签名图是否指的是电子印章/或手写签名图片?
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(usrSignatureInfo["certificate"]); // 证书唯一编码,由于CA公司不同,所以此处为可区别证书的编码(可为uKeyNo或CertificateNo等等)
        usrSignatureInfo["CertName"] = getUserListName(oCert); // 证书中文名;

       
        return usrSignatureInfo;
    }

    function Login(form, key, pwd) {
        
        if(pwd=="")
        {
         alert("请输入密码");
         return false;
        }
        var oCert = getCertByValue(key);
        if(oCert==null){
            alert("未找到证书!");
            return false;
        }
        
        var PinOk=false;
        try
        {		
            PinOk=oCert.verifyPwd(pwd);

        }
        catch (e) {
            var  NETCA_PKI_USER_PWD	=1;
            var device = NetcaPKI.GetDeviceFromCert(oCert);
            if (device != null)
            { 
                alert("验证密码失败，密码剩余次数: " + device.GetPwdRetryNumber(NETCA_PKI_USER_PWD) + "\n请检查：\n1、KEY的密码是否输入正确\n2、KEY是否插在USB口\n3、更换USB口并检查网证通安全客户端有没有显示证书信息");
            }
            else
            {
                alert("无法识别到KEY，可能原因\n1、KEY没有插在USB口或USB口接触不良\n2、网证通安全客户端有没有显示证书信息");
            }
            return false;
        }
        
        if(!PinOk)
        {
            var NETCA_PKI_USER_PWD = 1;
            var device = NetcaPKI.GetDeviceFromCert(oCert);
            if (device != null) {
            alert("验证密码失败，密码剩余次数: " + device.GetPwdRetryNumber(NETCA_PKI_USER_PWD) + "\n请检查：\n1、KEY的密码是否输入正确\n2、KEY是否插在USB口\n3、更换USB口并检查网证通安全客户端有没有显示证书信息");
            }
           else {
               alert("无法识别到KEY，可能原因\n1、KEY没有插在USB口或USB口接触不良\n2、网证通安全客户端有没有显示证书信息");
            }
     
            return false;
            
        }
        //以下三个已经赋值
        //strServerRan  随机数
        //strServerSignedData 服务器对随机数的签名 
        //strServerCert 服务器证书
        return true;
    }
    
    function SOF_IsLogin(strKey) {
	    return false;
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
            return SignedData(contentHash, key);
        },
        SignedOrdData: function(contentHash, key) {
            return SignedData(contentHash, key);
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content);
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