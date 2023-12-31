///DHCPrtComm.js
PrtAryData = new Array();
/**
 *@author : wanghc
 *@date : 2017-2-9
 *@param : {int} printWidth 打印纸宽度
 *@param : {String} str 打印内容
 *@param : {int} wordWidth 一个字的宽度
 * var x  = getCenterX(190,"北京地坛医院",4)
 */
function getCenterX(printWidth, str, wordWidth) {
  var titleLen = str.length * wordWidth;
  var x = (printWidth - titleLen) / 2;
  return x;
}
/**
 *@author : wanghc
 *@date : 2017-2-9
 *@param : {String} str 超过一行长的字符串
 *@param : {int} lineWordNum  一行显示多少个汉字。一个汉字相当二个字母
 *@other label不能自动换行,要加\n能换行
 *var str = "处理方法：1.	关闭报表工具2.	把东华智能报表工具安装下jdbc目录打开注释p8以下的驱动包(CacheDB.jar)如图 3.	在cache2010安装目录下如：\Dev\java\lib\JDK15 复制cacheDB.jar（文件大小是2098kb）到东华智能报表工具安装下jdbc中；（不能用JDK16下的cacheDB.jar）4.	在通过studio打开您报错的query类，修改您所调用的query 中sqlproc属性（如果为false请设置成true 编译此类 p5与2010需要设置）如图："
 *str = autoWordEnter(str,46);
 */
function autoWordEnter(str, lineWordNum) {
  var charWordNum = lineWordNum * 2; //一汉字长度为二个char长度
  if (str == null) return str;
  if (typeof str != "string") {
    return str;
  }
  var tmp,
    rtn = "";
  var arr = [];
  var charLen = 0;
  for (var i = 0; i < str.length; i++) {
    var chr = str.charAt(i);
    arr.push(chr);
    if (chr.charCodeAt(0) > 127 || chr.charCodeAt(0) == 9) {
      charLen += 2; //汉字
    } else {
      charLen++;
    }
    if (charLen >= charWordNum) {
      arr.push("\n");
      charLen = 0;
    }
  }
  return arr.join("");
}
function evalXMLVal(val) {
  return val
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/&/g, "&amp;")
    .replace(/'/g, "&apos;")
    .replace(/\"/g, "&quot;");
}
/**
 *@author : wanghc
 *@date : 2016-03-10
 *@param : {ClsBillPrint} VB打印对象
 *          如: <object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,43' VIEWASTEXT></object>
 *          或: d ##Class(web.DHCBillPrint).InvBillPrintCLSID()
 *		   或: var PObj = new ActiveXObject("DHCOPPrint.ClsBillPrint");
 *
 *@param : {String}   文本数据   $c(2)分割键与值, ^为多组键值分割符.
 *          如: name_$c(2)_王二^patno_$c(2)_000009
 *
 *@param : {String}   列表数据	^分割列, $c(2)为行间分割符.
 *          如: DrugName^Price^DrugUnit^Qty^PaySum_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
 *
 *@param : {Object} jsonArr 增加的自定义打印数据   可以不传, 2017-10-25 可以修改打印机
 *          如: [{type:"invoice",PrtDevice:"pdfprinter"},{type:"line",sx:1,sy:1,ex:100,ey:100},{type:"text",name:"patno",value:"0009",x:10,y:10,isqrcode:true,lineHeigth:5}]
 *              text类型name,value,x,y为必填,
 * 			可选属性有: fontsize,fontbold,fontname, 默认值为12,false,宋体
 *@param : invHeight 票据的高度----cab中判断打印换页是：发现元素位置top超过height就会换页打印，如果发现一个元素超过一页后，后面元素top-height就可以实现分页打印
 * 2018-09-20 增加invHeight 分页处理
 *
 */
function DHCP_XMLPrint(PObj, inpara, inlist, jsonArr, invHeight) {
  var c2 = String.fromCharCode(2);
  jsonArr = jsonArr || [];
  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }
    inpara = DHCP_TextEncoder(inpara);
    inlist = DHCP_TextEncoder(inlist);
    /*处理inpara中换行数据,对齐问题,生成jsonArr*/
    var inparaArr = inpara.split("^");
    var tmpArr = [];
    for (var tmpInd = 0; tmpInd < inparaArr.length; tmpInd++) {
      var inParaItemArr = inparaArr[tmpInd].split(c2);
      var itemName = inParaItemArr[0];
      if (inParaItemArr.length > 1 && inParaItemArr[1].indexOf("\n") > -1) {
        var ritem = new RegExp(
          'txtdatapara.+?name=\\"' + itemName + '\\"(.+)>'
        );
        var tmprItem = mystr.match(ritem);
        if (tmprItem != null) {
          //alert(tmprItem[1])
          //var rx = new RegExp('name=\\"'+inParaItemArr[0]+'\\".+?xcol=\\"(.+?)\\"');
          var rx = tmprItem[1].match(/xcol=\"(.+?)\"/)[1];
          var ry = tmprItem[1].match(/yrow=\"(.+?)\"/)[1];
          var rfs = tmprItem[1].match(/fontsize=\"(.+?)\"/)[1];
          var rfb = tmprItem[1].match(/fontbold=\"(.+?)\"/)[1];
          var rfn = tmprItem[1].match(/fontname=\"(.+?)\"/)[1];
          //alert(rx+","+ry+","+rfs+","+rfb+","+rfn);
          var inParaItemValueArr = inParaItemArr[1].split("\n");
          for (var j = 1; j < inParaItemValueArr.length; j++) {
            jsonArr.push({
              type: "text",
              name: itemName + "ntr" + j,
              value: inParaItemValueArr[j],
              x: rx,
              y: parseFloat(ry) + j * 5,
              fontsize: rfs,
              fontbold: rfb,
              fontname: rfn
            });
          }
          tmpArr.push(itemName + c2 + inParaItemValueArr[0]);
        }
      } else {
        tmpArr.push(inparaArr[tmpInd]);
      }
    }
    inpara = tmpArr.join("^");
    //-----jsonArr处理
    if (jsonArr.length > 0) {
      if (jsonArr.length > 0 && jsonArr[0].type.toLowerCase() == "invoice") {
        var invObj = jsonArr[0];
        for (var p in invObj) {
          if (p != "type") {
            mystr = mystr.replace(new RegExp(p + '=".*?"', "mi"), function() {
              return p + '="' + invObj[p] + '"';
            });
          }
        }
      }
      var itemJson = "",
        exLineXml = "",
        exTextXml = "";
      for (var j = 0; j < jsonArr.length; j++) {
        itemJson = jsonArr[j];
        if (itemJson.value) {
          itemJson.value = evalXMLVal(itemJson["value"]);
        }
        if (itemJson["type"]) {
          if (itemJson["type"].toLowerCase() == "invoice") {
          } else if (itemJson["type"].toLowerCase() == "line") {
            exLineXml +=
              '<PLine BeginX="' +
              itemJson.sx +
              '" BeginY="' +
              itemJson.sy +
              '" EndX="' +
              itemJson.ex +
              '" EndY="' +
              itemJson.ey +
              '"></PLine>';
          } else if (itemJson["type"].toLowerCase() == "text") {
            if (itemJson.isqrcode) {
              exTextXml +=
                '<txtdatapara width="' +
                (itemJson.width || 100) +
                '" height="' +
                (itemJson.height || 100) +
                '" name="' +
                itemJson.name +
                '" xcol="' +
                itemJson.x +
                '" yrow="' +
                itemJson.y +
                '" fontsize="' +
                (itemJson.fontsize || 12) +
                '" fontbold="' +
                (itemJson.fontbold || "false") +
                '" fontname="' +
                (itemJson.fontname || "宋体") +
                '" defaultvalue="" printvalue="' +
                itemJson.value +
                '" isqrcode="true"></txtdatapara>';
            } else {
              var textValueArr = itemJson.value.split("\n");
              var tmpStartY = itemJson.y;
              for (var tmpInd = 0; tmpInd < textValueArr.length; tmpInd++) {
                exTextXml +=
                  '<txtdatapara name="' +
                  itemJson.name +
                  tmpInd +
                  '" xcol="' +
                  itemJson.x +
                  '" yrow="' +
                  tmpStartY +
                  '" fontsize="' +
                  (itemJson.fontsize || 12) +
                  '" fontbold="' +
                  (itemJson.fontbold || "false") +
                  '" fontname="' +
                  (itemJson.fontname || "宋体") +
                  '" defaultvalue="' +
                  textValueArr[tmpInd] +
                  '" printvalue="' +
                  textValueArr[tmpInd] +
                  '"></txtdatapara>';
                tmpStartY += parseInt(itemJson.lineHeigth || 5);
              }
              //exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"宋体")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>';
            }
          }
        }
      }
      //console.log(exLineXml+","+exTextXml);
      var txtDataIndex = mystr.indexOf("</TxtData>");
      mystr =
        mystr.slice(0, txtDataIndex) + exTextXml + mystr.slice(txtDataIndex);
      var lineDataIndex = mystr.indexOf("</PLData>");
      mystr =
        mystr.slice(0, lineDataIndex) + exLineXml + mystr.slice(lineDataIndex);
      //console.log(mystr);
    }
    // 处理分页
    var page2 = false; //是否是第二页
    var mystr = mystr.replace(/\syrow\s*?=\s*?"(.+?)"\s/gi, function(
      str,
      str2
    ) {
      if (parseFloat(str2) > invHeight) {
        if (page2) {
          return ' yrow="' + (parseFloat(str2) - invHeight) + '" ';
        } else {
          page2 = true;
        }
      }
      return ' yrow="' + str2 + '" ';
    });
    if ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb) {
      //("undefined"==typeof isIECore || isIECore){
      var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
      //docobj.async = false;    //
      var rtn = docobj.loadXML(mystr);
      if (rtn) {
        var rtn = PObj.ToPrintHDLP(inpara, inlist, docobj);
      }
    } else {
      var rtn = DHCOPPrint.ToPrintHDLPStr(inpara, inlist, mystr);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}

function DHCP_XMLPrintDoc(PObj, inpara, inlist, jsonArr) {
  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }
    inpara = DHCP_TextEncoder(inpara);
    inlist = DHCP_TextEncoder(inlist);
    if (arguments.length > 3 && jsonArr != "") {
      if (jsonArr.length > 0 && jsonArr[0].type.toLowerCase() == "invoice") {
        var invObj = jsonArr[0];
        for (var p in invObj) {
          if (p != "type") {
            mystr = mystr.replace(new RegExp(p + '=".*?"', "mi"), function() {
              return p + '="' + invObj[p] + '"';
            });
          }
        }
      }
      var itemJson = "",
        exLineXml = "",
        exTextXml = "";
      for (var j = 0; j < jsonArr.length; j++) {
        itemJson = jsonArr[j];
        if (itemJson["type"]) {
          if (itemJson["type"].toLowerCase() == "invoice") {
          } else if (itemJson["type"].toLowerCase() == "line") {
            exLineXml +=
              '<PLine BeginX="' +
              itemJson.sx +
              '" BeginY="' +
              itemJson.sy +
              '" EndX="' +
              itemJson.ex +
              '" EndY="' +
              itemJson.ey +
              '"></PLine>';
          } else if (itemJson["type"].toLowerCase() == "text") {
            exTextXml +=
              '<txtdatapara name="' +
              itemJson.name +
              '" xcol="' +
              itemJson.x +
              '" yrow="' +
              itemJson.y +
              '" fontsize="' +
              (itemJson.fontsize || 12) +
              '" fontbold="' +
              (itemJson.fontbold || "false") +
              '" fontname="' +
              (itemJson.fontname || "宋体") +
              '" defaultvalue="' +
              itemJson.value +
              '" printvalue="' +
              itemJson.value +
              '"></txtdatapara>';
          }
        }
      }
      //console.log(exLineXml+","+exTextXml);
      var txtDataIndex = mystr.indexOf("</TxtData>");
      mystr =
        mystr.slice(0, txtDataIndex) + exTextXml + mystr.slice(txtDataIndex);
      var lineDataIndex = mystr.indexOf("</PLData>");
      mystr =
        mystr.slice(0, lineDataIndex) + exLineXml + mystr.slice(lineDataIndex);
      //console.log(mystr);
    }
    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    //docobj.async = false;    //
    var rtn = docobj.loadXML(mystr);
    if (rtn) {
      //ToPrintHDLP
      var rtn = PObj.ToPrintDoc(inpara, inlist, docobj);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}
// name^小二$c(2)age^24岁
function DHCP_PrintFun(PObj, inpara, inlist) {
  ////myframe=parent.frames["DHCOPOEOrdInput"];
  ////DHCPrtComm.js

  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }

    inpara = DHCP_TextEncoder(inpara);
    inlist = DHCP_TextEncoder(inlist);
    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    docobj.async = false; //
    var rtn = docobj.loadXML(mystr);

    if (rtn) {
      // 打印条码时如果值没有二边带*,则自动补*,加*后可以扫码。2019-4-1兰大一院start
      var barcodeItemNameObj = {};
      var inv = docobj.documentElement.childNodes[0];
      var xmlTxtData = inv.getElementsByTagName("TxtData");
      var txtDatas = xmlTxtData[0].getElementsByTagName("txtdatapara");
      if (txtDatas) {
        for (var j = 0; j < txtDatas.length; j++) {
          var item = txtDatas[j];
          var fontname = item.getAttribute("fontname");
          if (fontname == "C39P36DmTt") {
            barcodeItemNameObj[item.getAttribute("name")] = true;
          }
        }
      }
      // inpara拆成对象
      var c2 = String.fromCharCode(2);
      var inparaArr = inpara.split("^");
      for (var i = 0; i < inparaArr.length; i++) {
        var arr = inparaArr[i].split(c2);
        if (barcodeItemNameObj[arr[0]] && arr[1].indexOf("*") == -1) {
          inparaArr[i] = arr[0] + c2 + "*" + arr[1] + "*";
        }
      }
      inpara = inparaArr.join("^");
      // end
      ////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
      var rtn = PObj.ToPrintDoc(inpara, inlist, docobj);

      ////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
    }
  } catch (e) {
    //alert(e.message);
    //return;
  }
}
function DHCP_PrintFunNew(PObj, inpara, inlist) {
  ////myframe=parent.frames["DHCOPOEOrdInput"];
  ////DHCPrtComm.js
  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }
    inpara = DHCP_TextEncoder(inpara);
    inlist = DHCP_TextEncoder(inlist);

    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    docobj.async = false; //
    var rtn = docobj.loadXML(mystr);

    if (rtn) {
      // 打印条码时如果值没有二边带*,则自动补*。兰大一院start
      var barcodeItemNameObj = {};
      var inv = docobj.documentElement.childNodes[0];
      var xmlTxtData = inv.getElementsByTagName("TxtData");
      var txtDatas = xmlTxtData[0].getElementsByTagName("txtdatapara");
      if (txtDatas) {
        for (var j = 0; j < txtDatas.length; j++) {
          var item = txtDatas[j];
          var fontname = item.getAttribute("fontname");
          if (fontname == "C39P36DmTt") {
            barcodeItemNameObj[item.getAttribute("name")] = true;
          }
        }
      }
      // inpara拆成对象
      var c2 = String.fromCharCode(2);
      var inparaArr = inpara.split("^");
      for (var i = 0; i < inparaArr.length; i++) {
        var arr = inparaArr[i].split(c2);
        if (barcodeItemNameObj[arr[0]] && arr[1].indexOf("*") == -1) {
          inparaArr[i] = arr[0] + c2 + "*" + arr[1] + "*";
        }
      }
      inpara = inparaArr.join("^");
      // end
      ////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
      var rtn = PObj.ToPrintDocNew(inpara, inlist, docobj);

      ////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}
function DHCP_GetXMLConfig(encName, PFlag) {
  ////
  /////InvPrintEncrypt
  try {
    PrtAryData.length = 0;
    var obj = document.getElementById(encName);
    var encmeth = obj.value;

    var PrtConfig = cspRunServerMethod(encmeth, "DHCP_RecConStr", PFlag);
    for (var i = 0; i < PrtAryData.length; i++) {
      PrtAryData[i] = DHCP_TextEncoder(PrtAryData[i]);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}

function PisDHCP_GetXMLConfig(encName, PFlag) {
  ////
  /////InvPrintEncrypt
  try {
    PrtAryData.length = 0;
    var PrtConfig = tkMakeServerCall(
      "web.DHCXMLIO",
      "ReadXML",
      "DHCP_RecConStr",
      PFlag
    ); //"DHCPisLabel");
    for (var i = 0; i < PrtAryData.length; i++) {
      PrtAryData[i] = DHCP_TextEncoder(PrtAryData[i]);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}
function DHCP_mytest(encmeth, PFlag, PObj) {
  ////myframe=parent.frames["DHCOPOEOrdInput"];
  ////DHCPrtComm.js
  ////
  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }
    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    docobj.async = false; //
    var rtn = docobj.loadXML(mystr);
    if (rtn) {
      ////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
      var rtn = PObj.ToPrintDoc(myinstr, myList, docobj);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
  return rtn;
}

function DHCP_RecConStr(ConStr) {
  ///var myIdx=PrtAryData.length
  PrtAryData[PrtAryData.length] = ConStr;
}

function DHCP_TextEncoder(transtr) {
  if (transtr.length == 0) {
    return "";
  }
  var dst = transtr;
  try {
    dst = DHCP_replaceAll(dst, '\\"', '"');
    dst = DHCP_replaceAll(dst, "\\r\\n", "\r\t");
    dst = DHCP_replaceAll(dst, "\\r", "\r");
    dst = DHCP_replaceAll(dst, "\\n", "\n");
    dst = DHCP_replaceAll(dst, "\\t", "\t");
  } catch (e) {
    alert(e.message);
    return "";
  }
  return dst;
}

function DHCP_replaceAll(src, fnd, rep) {
  //rep:replace
  //src:source
  //fnd:find
  if (src.length == 0) {
    return "";
  }
  try {
    var myary = src.split(fnd);
    var dst = myary.join(rep);
  } catch (e) {
    alert(e.message);
    return "";
  }
  return dst;
}
function DHCWeb_replaceAll(src, fnd, rep) {
  if (src.length == 0) {
    return "";
  }
  try {
    var myary = src.split(fnd);
    var dst = myary.join(rep);
  } catch (e) {
    alert(e.message);
    return "";
  }
  return dst;
}
function strlen(str) {
  var len = 0;
  for (var i = 0; i < str.length; i++) {
    var c = str.charCodeAt(i);
    //单字节加1
    if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
      len++;
    } else {
      len += 2;
    }
  }
  return len;
}

function GetStrInfo(str, Needlen) {
  var Output1 = "",
    Output2 = "";
  var len = 0;
  for (var i = 0; i < str.length; i++) {
    var c = str.charCodeAt(i);
    //单字节加1
    if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
      len++;
    } else {
      len += 2;
    }
    //alert("c======:"+c)
    if (len < Needlen) {
      Output1 = Output1 + String.fromCharCode(c);
    } else {
      Output2 = Output2 + String.fromCharCode(c);
    }
    //alert(Output1+"^^^^^"+Output2)
  }
  return Output1 + "^" + Output2;
}
function DHCP_PrintFunHDLP(PObj, inpara, inlist) {
  try {
    var mystr = "";
    for (var i = 0; i < PrtAryData.length; i++) {
      mystr = mystr + PrtAryData[i];
    }
    inpara = DHCP_TextEncoder(inpara);
    inlist = DHCP_TextEncoder(inlist);
    if ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb) {
      //if ("undefined"==typeof isIECore || isIECore){
      var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
      docobj.async = false; //
      var rtn = docobj.loadXML(mystr);
      if (rtn) {
        var rtn = PObj.ToPrintHDLP(inpara, inlist, docobj);
      }
    } else {
      var rtn = PObj.ToPrintHDLPStr(inpara, inlist, mystr);
    }
  } catch (e) {
    alert(e.message);
    return;
  }
}

function GetGifInfo(USERID) {
  var ImgBase64 = tkMakeServerCall(
    "web.UDHCPrescript",
    "GetDocGifCode",
    USERID
  );
  //alert(ImgBase64)
  //读取流数据写入c盘成为.gif文件
  var myobj = document.getElementById("ClsSaveBase64IMG");
  if (myobj && ImgBase64 != "") {
    var sReigstNo = USERID;
    var sFiletype = "gif";
    var rtn = myobj.WriteFile(sReigstNo, ImgBase64, sFiletype);
    if (!rtn) {
      alert("签名图片转换错误");
      return -1;
    }
    return 0;
  }
  return -1;
}
/// SaveImg("http://127.0.0.1/dthealth/web/images/logon_btn.bmp","D:\\Signature\\btn.bmp")
function SaveImg(httpName, pathName) {
  try {
    cspXMLHttp = new ActiveXObject("Microsoft.XMLHTTP");
  } catch (e) {
    try {
      cspXMLHttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (E) {
      cspXMLHttp = null;
    }
  }
  cspXMLHttp.open("GET", httpName, false);
  cspXMLHttp.send();
  var adodbStream = new ActiveXObject("ADODB.Stream");
  adodbStream.Type = 1; //1=adTypeBinary
  adodbStream.Open(); //"http://127.0.0.1/dthealth/web/images/logon_btn.bmp");
  adodbStream.write(cspXMLHttp.responseBody);
  adodbStream.SaveToFile(pathName, 2);
  adodbStream.Close();
  adodbStream = null;
}
function LODOP_CreateLine(LODOP, invXMLDoc, inpara, inlist, jsonArr) {
  //lodop推荐先打画线
  var xmlPLine = invXMLDoc.getElementsByTagName("PLData");
  if (xmlPLine && xmlPLine.length > 0) {
    var xmlPlineRePrtHeadFlag = xmlPLine[0].getAttribute("RePrtHeadFlag");
    var pLines = xmlPLine[0].getElementsByTagName("PLine");
    for (var j = 0; j < pLines.length; j++) {
      var item = pLines[j];
      var pleft1 = item.getAttribute("BeginX");
      var ptop1 = item.getAttribute("BeginY");
      var pleft2 = item.getAttribute("EndX");
      var ptop2 = item.getAttribute("EndY");
      LODOP.ADD_PRINT_LINE(
        ptop1 + "mm",
        pleft1 + "mm",
        ptop2 + "mm",
        pleft2 + "mm",
        0,
        1
      ); //0=实线,1=线宽
      if (xmlPlineRePrtHeadFlag == "Y")
        LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
    }
  }
}
function LODOP_CreateImg(LODOP, invXMLDoc, inpara, inlist, jsonArr) {
  // inpara拆成对象
  var c2 = String.fromCharCode(2);
  var inparaArr = inpara.split("^");
  var inparaObj = {};
  for (var i = 0; i < inparaArr.length; i++) {
    var arr = inparaArr[i].split(c2);
    inparaObj[arr[0]] = arr[1];
  }
  var xmlPICData = invXMLDoc.getElementsByTagName("PICData");
  if (xmlPICData && xmlPICData.length > 0) {
    var xmlPICDataRePrtHeadFlag = xmlPICData[0].getAttribute("RePrtHeadFlag");
    var picDataParas = xmlPICData[0].getElementsByTagName("PICdatapara");
    for (var j = 0; j < picDataParas.length; j++) {
      var item = picDataParas[j];
      var pname = item.getAttribute("name");
      var pleft = item.getAttribute("xcol");
      var ptop = item.getAttribute("yrow");
      var pheight = item.getAttribute("height");
      var pwidth = item.getAttribute("width");
      var pdval = item.getAttribute("defaultvalue");
      var ppval = item.getAttribute("printvalue");
      var pfbold = item.getAttribute("fontbold"); //false
      var pfname = item.getAttribute("fontname");
      var pfsize = item.getAttribute("fontsize");
      var pval = inparaObj[pname] || pdval;
      if (pval.indexOf("http:") == 0 || pval.indexOf("data:") == 0) {
        pval = "<img border='0' src='" + pval + "'/>"; //"URL:"+pval;--导致浏览器崩溃
      }
      if (null == pheight) {
        pheight = 20;
      }
      if (null == pwidth) {
        pwidth = 20;
      }
      if (pval != "") {
        //LODOP.ADD_PRINT_IMAGE(ptop+"mm",pleft+"mm",pwidth+"mm",pheight+"mm","<img border='0' src='http://s1.sinaimg.cn/middle/4fe4ba17hb5afe2caa990&690' />");
        //alert(ptop+"mm,"+pleft+"mm,"+pwidth+"mm,"+pheight+"mm,"+pval);
        LODOP.ADD_PRINT_IMAGE(
          ptop + "mm",
          pleft + "mm",
          pwidth + "mm",
          pheight + "mm",
          pval
        );
        //   LODOP.SET_PRINT_STYLEA(0,"Stretch",2);//按原图比例(不变形)缩放模式
        LODOP.SET_PRINT_STYLEA(0, "Stretch", 1); //(可变形)扩展缩放模式
        if (xmlPICDataRePrtHeadFlag == "Y")
          LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
      }
    }
  }
}
function LODOP_CreateTxt(LODOP, invXMLDoc, inpara, inlist, jsonArr, otherCfg) {
  // inpara拆成对象
  var c2 = String.fromCharCode(2);
  var inparaArr = inpara.split("^");
  var inparaObj = {};
  for (var i = 0; i < inparaArr.length; i++) {
    var arr = inparaArr[i].split(c2);
    inparaObj[arr[0]] = arr[1];
  }
  var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData");
  if (xmlTxtData && xmlTxtData.length > 0) {
    var xmlTxtDataRePrtHeadFlag = xmlTxtData[0].getAttribute("RePrtHeadFlag");
    var txtDataParas = xmlTxtData[0].getElementsByTagName("txtdatapara");
    for (var j = 0; j < txtDataParas.length; j++) {
      var itm = txtDataParas[j];
      var pname = itm.getAttribute("name");
      var pleft = itm.getAttribute("xcol");
      var ptop = itm.getAttribute("yrow");
      var pdval = itm.getAttribute("defaultvalue");
      var ppval = itm.getAttribute("printvalue");
      var pfbold = itm.getAttribute("fontbold"); //false
      var pfname = itm.getAttribute("fontname");
      var pfsize = itm.getAttribute("fontsize");
      var pisqrcode = itm.getAttribute("isqrcode");
      var pbarcodetype = itm.getAttribute("barcodetype");
      var pval = inparaObj[pname] || pdval;
      var pangle = itm.getAttribute("angle");
      LODOP.SET_PRINT_STYLE("Angle", 0);
      if (pangle > 0) LODOP.SET_PRINT_STYLE("Angle", pangle);
      //LODOP.SET_PRINT_STYLEA(0,"AngleOfPageInside",90) //angle
      if (pisqrcode == "true") {
        var pheight = itm.getAttribute("height");
        var pwidth = itm.getAttribute("width");
        if (pval != "") {
          LODOP.ADD_PRINT_BARCODE(
            ptop + "mm",
            pleft + "mm",
            pwidth + "mm",
            pheight + "mm",
            "QRCode",
            pval
          );
          if (xmlTxtDataRePrtHeadFlag == "Y")
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
        }
        //LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",1);
      } else if ("undefined" != typeof pbarcodetype && pbarcodetype != null) {
        var pheight = itm.getAttribute("height");
        var pwidth = itm.getAttribute("width");
        if (pval != "") {
          LODOP.ADD_PRINT_BARCODE(
            ptop + "mm",
            pleft + "mm",
            pwidth + "mm",
            pheight + "mm",
            pbarcodetype,
            pval
          );
          if (xmlTxtDataRePrtHeadFlag == "Y")
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
        }
        //LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",1);
      } else {
        //console.log(pleft+"mm"+","+ptop+"mm"+",pfbold="+pfbold+",80cm"+","+"5mm"+","+pval);
        var pheight = "800";
        var pwidth = "800";
        try {
          //=null
          if (itm.getAttribute("height") > 0)
            pheight = itm.getAttribute("height");
          if (itm.getAttribute("width") > 0) pwidth = itm.getAttribute("width");
        } catch (e) {}
        LODOP.ADD_PRINT_TEXT(
          ptop + "mm",
          pleft + "mm",
          pwidth + "mm",
          pheight + "mm",
          pval
        );
        if ("undefined" != typeof otherCfg && !!otherCfg.LetterSpacing) {
          LODOP.SET_PRINT_STYLEA(0, "LetterSpacing", otherCfg.LetterSpacing);
        }
        LODOP.SET_PRINT_STYLEA(0, "FontSize", pfsize);
        LODOP.SET_PRINT_STYLEA(0, "FontName", pfname);
        if (pfbold == "true") {
          LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
        }
        if (xmlTxtDataRePrtHeadFlag == "Y")
          LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
      }
    }
  }
}
///按照TEXT模式打印List数据
function LODOP_CreateListByText(LODOP, invXMLDoc, inpara, inlist, jsonArr) {
  var c2 = String.fromCharCode(2);
  var xmlListData = invXMLDoc.getElementsByTagName("ListData");
  if (xmlListData && xmlListData.length > 0) {
    var xmlYStep = parseFloat(xmlListData[0].getAttribute("YStep"));
    var xmlPageRows = parseInt(xmlListData[0].getAttribute("PageRows"));
    var xmlBackSlashWidth = parseInt(
      xmlListData[0].getAttribute("BackSlashWidth")
    );
    var rowHeight = xmlYStep;
    //		<ListData PrintType="List" YStep="9.524" XStep="0" CurrentRow="1" PageRows="6" RePrtHeadFlag="Y" BackSlashWidth="150">
    //		<Listdatapara name="Listdatapara0" xcol="17.196" yrow="36.772" defaultvalue="第一列" printvalue="" fontbold="false" fontname="宋体" fontsize="11" />
    //		<Listdatapara name="Listdatapara1" xcol="42.063" yrow="36.772" defaultvalue="第二列" printvalue="" fontbold="false" fontname="宋体" fontsize="12" />
    //		<Listdatapara name="Listdatapara2" xcol="71.958" yrow="36.772" defaultvalue="第三列" printvalue="" fontbold="false" fontname="宋体" fontsize="12" />
    //		<Listdatapara name="listItem3" xcol="106.085" yrow="42.063" defaultvalue="第四列" printvalue="" fontbold="false" fontname="宋体" fontsize="11" />
    //		<Listdatapara name="listItem4" xcol="137.302" yrow="42.328" defaultvalue="第五列" printvalue="" fontbold="false" fontname="宋体" fontsize="11" />
    //		<Listdatapara name="listItem5" xcol="169.048" yrow="43.651" defaultvalue="第六列" printvalue="" fontbold="false" fontname="宋体" fontsize="11" />
    //		</ListData>
    var tableTop = 0,
      tableLeft = 0,
      colsArr = [];
    var Listdataparas = xmlListData[0].getElementsByTagName("Listdatapara");
    for (var j = 0; j < Listdataparas.length; j++) {
      var itm = Listdataparas[j];
      var pname = itm.getAttribute("name");
      var pleft = itm.getAttribute("xcol");
      var ptop = itm.getAttribute("yrow");
      var pdval = itm.getAttribute("defaultvalue");
      var ppval = itm.getAttribute("printvalue");
      var pfbold = itm.getAttribute("fontbold"); //false
      var pfname = itm.getAttribute("fontname");
      var pfsize = itm.getAttribute("fontsize");
      colsArr.push({
        pname: pname,
        pleft: parseFloat(pleft),
        ptop: parseFloat(ptop),
        pdval: pdval,
        ppval: ppval,
        pfbold: pfbold,
        pfname: pfname,
        pfsize: parseFloat(pfsize)
      });
      if (tableTop > 0) tableTop = Math.min(tableTop, ptop);
      else tableTop = ptop;
      if (tableLeft > 0) tableLeft = Math.min(tableLeft, pleft);
      else tableLeft = pleft;
    }
    var inlistArr = inlist.split(c2);
    var inlistDataArr = [],
      tableStr = "",
      inlistArrValidCount = 0;
    var currRowNo = 0,
      currPageRowNo = 0,
      currPage = 0;
    for (var i = 0; i < inlistArr.length; i++) {
      if (inlistArr[i] != "") {
        currRowNo++; //当前总行号
        currPage = Math.floor((currRowNo - 1) / xmlPageRows) + 1; //当前页数
        currPageRowNo = ((currRowNo - 1) % xmlPageRows) + 1; //当前页当前行

        var dataArr = inlistArr[i].split("^");
        var padTop = currPageRowNo * xmlYStep;

        for (var j = 0; j < colsArr.length; j++) {
          var col = colsArr[j];
          if (typeof dataArr[j] == "undefined") var pval = col.ppval;
          else var pval = dataArr[j];
          LODOP.ADD_PRINT_TEXT(
            col.ptop + padTop + "mm",
            col.pleft + "mm",
            "800mm",
            "5mm",
            pval
          );
          LODOP.SET_PRINT_STYLEA(0, "FontSize", col.pfsize);
          LODOP.SET_PRINT_STYLEA(0, "FontName", col.pfname);
          if (col.pfbold == "true") {
            LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
          }
        }

        if (currPageRowNo == xmlPageRows && i != inlistArr.length - 1) {
          LODOP.NEWPAGE();
        }

        if (
          i == inlistArr.length - 1 &&
          currPageRowNo != xmlPageRows &&
          xmlBackSlashWidth > 0
        ) {
          //到了最后 且不满行 且 斜线宽度大于0
          var slash2Top = parseInt(tableTop) + (currPageRowNo + 1) * rowHeight;
          var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
          var slash1Top =
            parseInt(tableTop) + parseInt((xmlPageRows + 1) * rowHeight);
          var slash1Left = tableLeft;
          LODOP.ADD_PRINT_LINE(
            slash2Top + "mm",
            slash2Left + "mm",
            slash1Top + "mm",
            slash1Left + "mm",
            0,
            1
          ); //0=实线,1=线宽
        }
      }
    }
  }
}
function LODOP_CreateList(LODOP, invXMLDoc, inpara, inlist, jsonArr) {
  var c2 = String.fromCharCode(2);
  var xmlListData = invXMLDoc.getElementsByTagName("ListData");
  if (xmlListData && xmlListData.length > 0) {
    var xmlYStep = xmlListData[0].getAttribute("YStep");
    var xmlPageRows = xmlListData[0].getAttribute("PageRows");
    var xmlBackSlashWidth = xmlListData[0].getAttribute("BackSlashWidth");
    var rowHeight = xmlYStep;
    var tableOneHeight = parseInt(rowHeight * xmlPageRows); //一页表格高度
    // PrintType="List" YStep="4.762" XStep="0" CurrentRow="1" PageRows="20" RePrtHeadFlag="Y" BackSlashWidth="150"
    var tableTop = 0,
      tableLeft = 0,
      colsArr = [];
    var Listdataparas = xmlListData[0].getElementsByTagName("Listdatapara");
    for (var j = 0; j < Listdataparas.length; j++) {
      var itm = Listdataparas[j];
      var pname = itm.getAttribute("name");
      var pleft = itm.getAttribute("xcol");
      var ptop = itm.getAttribute("yrow");
      var pdval = itm.getAttribute("defaultvalue");
      var ppval = itm.getAttribute("printvalue");
      var pfbold = itm.getAttribute("fontbold"); //false
      var pfname = itm.getAttribute("fontname");
      var pfsize = itm.getAttribute("fontsize");
      if (j == 0) {
        tableTop = ptop;
        tableLeft = pleft;
      }
      colsArr.push({
        left: pleft,
        fbold: pfbold,
        fsize: pfsize,
        fname: pfname
      });
    }
    colsArr.sort(function(a, b) {
      return a.left - b.left;
    });
    for (var j = 0; j < colsArr.length - 1; j++) {
      colsArr[j].width = colsArr[j + 1].left - colsArr[j].left;
    }
    //inlist拆分
    var inlistArr = inlist.split(c2);
    var inlistDataArr = [],
      tableStr = "",
      inlistArrValidCount = 0;
    for (var i = 0; i < inlistArr.length; i++) {
      if (inlistArr[i] != "") {
        var tr = "<tr>";
        var arr = inlistArr[i].split("^");
        for (var j = 0; j < arr.length; j++) {
          if (colsArr.length > j) {
            tr += '<td style="';
            if (colsArr[j]["width"]) {
              tr +=
                "width:" +
                ((colsArr[j]["width"] / 0.68) * 1).toFixed(1) +
                "mm;";
            }
            if (colsArr[j]["fname"] != "") {
              tr += "font-family:'" + colsArr[j]["fname"] + "';";
            }
            if (colsArr[j]["fsize"]) {
              tr +=
                "font-size:" + (colsArr[j]["fsize"] / 0.68).toFixed(1) + "pt;";
            }
            if (colsArr[j]["fbold"] == "true") {
              tr += "font-weight:700;";
            }
            tr += '" >' + arr[j] + "</td>";
          } else {
            tr += "<td>" + arr[j] + "</td>";
          }
        }
        tr += "</tr>";
        tableStr += tr;
        inlistArrValidCount++;
        if (
          inlistArrValidCount % xmlPageRows == 0 ||
          i == inlistArr.length - 1
        ) {
          LODOP.ADD_PRINT_TABLE(
            tableTop + "mm",
            tableLeft + "mm",
            "2000mm",
            tableOneHeight + "mm",
            "<table cellpadding='0' padding='0' margin='0' border='0'>" +
              tableStr +
              "</table>"
          );
          if (i != inlistArr.length - 1) {
            LODOP.NEWPAGE();
          }

          tableStr = "";
        }
      }
    }
    if (inlistArr.length > 0 && xmlBackSlashWidth > 0) {
      // && invOrient!="Z"){
      if (inlistArrValidCount % xmlPageRows != 0) {
        //没打满才打印slash
        var remainRow = inlistArrValidCount % xmlPageRows;
        var slash2Top = parseInt(tableTop) + remainRow * rowHeight;
        var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
        var slash1Top = parseInt(tableTop) + parseInt(tableOneHeight);
        var slash1Left = tableLeft;
        /*
				var tableCount = Math.ceil(inlistArrValidCount / xmlPageRows); //会打印出n张
				var tableTotalMaxHeight = parseInt(tableCount * tableOneHeight); //n张表格的高度
				var tableTotalHeight = parseInt(inlistArrValidCount * rowHeight) ; //打印数据的总高度
				var slash2Top = parseInt(tableTop)+parseInt(tableTotalHeight);  //表格结束处top
				var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
				var slash1Top = parseInt(tableTop)+parseInt(tableTotalMaxHeight);
				var slash1Left = tableLeft ;*/

        LODOP.ADD_PRINT_LINE(
          slash2Top + "mm",
          slash2Left + "mm",
          slash1Top + "mm",
          slash1Left + "mm",
          0,
          1
        ); //0=实线,1=线宽
        //var lastTop = parseFloat(LODOP.GET_VALUE("ItemTop",'last')); //只有设计时才能用
        //var lastLeft = parseFloat(LODOP.GET_VALUE("ItemLeft",'last'));
      }
    }
  }
}
// link只从json中取
function LODOP_CreateLink(LODOP, inv, inpara, inlist, jsonArr) {
  if (
    arguments.length > 4 &&
    jsonArr !== null &&
    jsonArr != "" &&
    "undefined" != typeof jsonArr
  ) {
    for (var j = 0; j < jsonArr.length; j++) {
      var item = jsonArr[j];
      if (item["type"]) {
        if (item["type"].toLowerCase() == "linkedqrcode") {
          LODOP.ADD_PRINT_BARCODE(
            item["y"] + "mm",
            item["x"] + "mm",
            item["width"] + "mm",
            item["height"] + "mm",
            "QRCode",
            item["value"]
          );
          LODOP.SET_PRINT_STYLEA(0, "LinkedItem", item["linkedItem"]);
        } else if (item["type"].toLowerCase() == "linkedtext") {
          LODOP.ADD_PRINT_TEXT(
            item["y"] + "mm",
            item["x"] + "mm",
            item["width"] + "mm",
            item["height"] + "mm",
            item["value"]
          );
          LODOP.SET_PRINT_STYLEA(0, "LinkedItem", item["linkedItem"]);
        }
      }
    }
  }
}
/*大小与方向*/
function LODOP_CreateInv(LODOP, invXMLDoc) {
  var invAttr = invXMLDoc.attributes;
  var invHeight = invAttr.getNamedItem("height").value;
  var invWidth = invAttr.getNamedItem("width").value;
  var invOrient = "X";
  if (invAttr.getNamedItem("LandscapeOrientation")) {
    //老版设计器,默认情况下没有此属性
    invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=纵向,Y=横向
  }
  //var invPrtDirect = invAttr.getNamedItem("PrtDirection").value; //Y----无效
  var invPrtPaperSet = invAttr.getNamedItem("PrtPaperSet").value; //WIN
  var invPrtDevice = invAttr.getNamedItem("PrtDevice").value; //xps
  var invPrtPage = invAttr.getNamedItem("PrtPage").value; //A5
  //var invPrtDesc = invAttr.getNamedItem("PaperDesc").value; //----无效
  var intOrient = 1; //默认1=纵向
  if (invOrient == "Y") intOrient = 2;
  else if (invOrient == "X") intOrient = 1;
  else if (invOrient == "Z") {
    intOrient = 3; /*按内容高度算*/
  }
  if (invPrtPaperSet == "HAND") {
    var lodopPageWidth = invWidth * 10 + "mm";
    var lodopPageHeight = invHeight * 10 + "mm";
    var lodopPageName = "";
  } else {
    var lodopPageWidth = 0; //表示无效
    var lodopPageHeight = 0;
    var lodopPageName = invPrtPage;
  }
  //alert(intOrient+","+lodopPageWidth+","+lodopPageHeight+","+lodopPageName);
  LODOP.SET_PRINT_PAGESIZE(
    intOrient,
    lodopPageWidth,
    lodopPageHeight,
    lodopPageName
  );
  //LODOP.SET_PRINT_PAGESIZE(3,1385,45,""); //这里3表示纵向打印且纸高“按内容的高度”；1385表示纸宽138.5mm；45表示页底空白4.5mm
  if (invPrtDevice != "") {
    invPrtDevice = invPrtDevice.toUpperCase();
    // containt invPrtDevice
    for (var i = 0; i < LODOP.GET_PRINTER_COUNT(); i++) {
      if (
        LODOP.GET_PRINTER_NAME(i)
          .toUpperCase()
          .indexOf(invPrtDevice) > -1
      ) {
        LODOP.SET_PRINTER_INDEX(i);
        break;
      }
    }
  } else {
    LODOP.SET_PRINTER_INDEX(-1); //set default printer
  }
}
/**
*@author : wanghc 
*@date : 2018-09-29
* 通这xml模板生成lodop打印内容

*@param : {DLLObject} LODOP对象  getLodop()获得
*
*@param :  mystr --- xml模板内容
*
*@param : {String}   inpara文本数据   $c(2)分割键与值, ^为多组键值分割符. 
*          如: name_$c(2)_王二^patno_$c(2)_000009
*
*@param : {String}   inlist列表数据	^分割列, $c(2)为行间分割符. 
*          如: DrugName^Price^DrugUnit^Qty^PaySum_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
*
*@param : {Object} jsonArr 增加的自定义打印数据   可以不传, 2017-10-25 可以修改打印机
*          如: [{type:"invoice",PrtDevice:"pdfprinter"},{type:"line",sx:1,sy:1,ex:100,ey:100},{type:"text",name:"patno",value:"0009",x:10,y:10,isqrcode:true,lineHeigth:5}]
*              text类型name,value,x,y为必填,
*@param : {String}  reportNote  打印名称
*
*@param : {Object}  otherCfg  其它配置项  otherCfg.printListByText true以text形式打印list数据 默认false
*
*/
function DHC_CreateByXMLStr(
  LODOP,
  mystr,
  inpara,
  inlist,
  jsonArr,
  reportNote,
  otherCfg
) {
  otherCfg = otherCfg || {};
  if (
    LODOP == null ||
    (typeof LODOP.VERSION == "undefined" &&
      ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb))
  ) {
    //("undefined"==typeof isIECore || isIECore))){
    return -404;
  }
  //try{
  if (
    arguments.length > 4 &&
    jsonArr !== null &&
    jsonArr != "" &&
    "undefined" != typeof jsonArr
  ) {
    if (jsonArr.length > 0 && jsonArr[0].type.toLowerCase() == "invoice") {
      var invObj = jsonArr[0];
      for (var p in invObj) {
        if (p != "type") {
          mystr = mystr.replace(new RegExp(p + '=".*?"', "mi"), function() {
            return p + '="' + invObj[p] + '"';
          });
        }
      }
    }
    var itemJson = "",
      exLineXml = "",
      exTextXml = "",
      exImgXml = "";
    for (var j = 0; j < jsonArr.length; j++) {
      itemJson = jsonArr[j];
      if (itemJson["type"]) {
        if (itemJson["type"].toLowerCase() == "invoice") {
        } else if (itemJson["type"].toLowerCase() == "line") {
          exLineXml +=
            '<PLine BeginX="' +
            itemJson.sx +
            '" BeginY="' +
            itemJson.sy +
            '" EndX="' +
            itemJson.ex +
            '" EndY="' +
            itemJson.ey +
            '"></PLine>';
        } else if (itemJson["type"].toLowerCase() == "text") {
          if (itemJson["isqrcode"]) {
            exTextXml +=
              '<txtdatapara name="' +
              itemJson.name +
              '" xcol="' +
              itemJson.x +
              '" yrow="' +
              itemJson.y +
              '" isqrcode="' +
              itemJson.isqrcode +
              '" width="' +
              itemJson.width +
              '" height="' +
              itemJson.height +
              '" fontsize="' +
              (itemJson.fontsize || 12) +
              '" fontbold="' +
              (itemJson.fontbold || "false") +
              '" fontname="' +
              (itemJson.fontname || "宋体") +
              '" defaultvalue="' +
              itemJson.value +
              '" printvalue="' +
              itemJson.value +
              '"></txtdatapara>';
          } else {
            exTextXml +=
              '<txtdatapara name="' +
              itemJson.name +
              '" xcol="' +
              itemJson.x +
              '" yrow="' +
              itemJson.y +
              '" ';
            if (itemJson.width > 0)
              exTextXml += 'width="' + itemJson.width + '" ';
            if (itemJson.height > 0)
              exTextXml += 'height="' + itemJson.height + '" ';
            exTextXml +=
              'fontsize="' +
              (itemJson.fontsize || 12) +
              '" fontbold="' +
              (itemJson.fontbold || "false") +
              '" fontname="' +
              (itemJson.fontname || "宋体") +
              '" defaultvalue="' +
              itemJson.value +
              '" printvalue="' +
              itemJson.value +
              '"></txtdatapara>';
          }
        } else if (itemJson["type"].toLowerCase() == "img") {
          exImgXml +=
            '<PICdatapara name="' +
            itemJson.name +
            '" xcol="' +
            itemJson.x +
            '" yrow="' +
            itemJson.y +
            '" width="' +
            itemJson.width +
            '" height="' +
            itemJson.height +
            '" defaultvalue="' +
            itemJson.value +
            '" printvalue="" />';
        }
      }
    }
    //console.log(exLineXml+","+exTextXml);
    var txtDataIndex = mystr.indexOf("</TxtData>");
    mystr =
      mystr.slice(0, txtDataIndex) + exTextXml + mystr.slice(txtDataIndex);
    var lineDataIndex = mystr.indexOf("</PLData>");
    mystr =
      mystr.slice(0, lineDataIndex) + exLineXml + mystr.slice(lineDataIndex);
    var imgDataIndex = mystr.indexOf("</PICData>");
    mystr = mystr.slice(0, imgDataIndex) + exImgXml + mystr.slice(imgDataIndex);
    //console.log(mystr);
  }
  inpara = DHCP_TextEncoder(inpara);
  inlist = DHCP_TextEncoder(inlist);
  //一个xml模板多次打印但希望在同一次任务中,多次调用当前方法 2018-10-31
  if ("undefined" != typeof reportNote && LODOP.GET_VALUE("ItemCount", 1) == 0)
    LODOP.PRINT_INIT(reportNote); //一次任务,不用多次init。
  /*var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		//docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);*/
  var docobj = DHC_parseXml(mystr);
  if (docobj) {
    if (docobj.parsed) {
      LODOP.SET_LICENSES(
        "东华医为科技有限公司",
        "4EF6E3D5AB0D478F5A07D05CDDDE2365",
        "東華醫為科技有限公司",
        "7C4A2B70D17D01CCD5CB2A3A6B4D3200"
      );
      LODOP.SET_LICENSES(
        "THIRD LICENSE",
        "",
        "DHC Medical Science & Technology Co., Ltd.",
        "604523CF08513643CB90BACED8EFF303"
      );
      var inv = docobj.documentElement.childNodes[0];
      if (LODOP.GET_VALUE("ItemCount", 1) == 0) LODOP_CreateInv(LODOP, inv); //一次任务,纸张不会多种
      //lodop推荐先打印线
      LODOP_CreateLine(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop打印文本
      LODOP_CreateTxt(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop推荐再打印图片
      LODOP_CreateImg(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop打印列表
      if (otherCfg.printListByText == true) {
        LODOP_CreateListByText(LODOP, inv, inpara, inlist, jsonArr);
      } else {
        LODOP_CreateList(LODOP, inv, inpara, inlist, jsonArr);
      }

      //LODOP.ADD_PRINT_TEXT(15,200,200,25,"制表人:guest");
      //LODOP.SET_PRINT_STYLEA(0,"LinkedItem-1); 		",-1);
      LODOP_CreateLink(LODOP, inv, inpara, inlist, jsonArr);
    }
  }
  /*}catch(e){
		alert(e.message);
		return;
	}*/
}
///移除对象中的text节点
function DHC_removeTextNode(doc) {
  if (!doc.childNodes) return;
  for (var i = 0; i < doc.childNodes.length; i++) {
    var node = doc.childNodes[i];
    if (node.nodeName == "#text") {
      doc.removeChild(node);
      i--;
    } else {
      DHC_removeTextNode(node);
    }
  }
}
///解析xml字符串为对象
function DHC_parseXml(strXml) {
  if (!!window.ActiveXObject || "ActiveXObject" in window) {
    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    //docobj.async = false;    //
    var rtn = docobj.loadXML(strXml);
    if (rtn) return docobj;
  } else {
    //Chrome
    var parser = new DOMParser();
    var docobj = parser.parseFromString(strXml, "text/xml");
    DHC_removeTextNode(docobj);
    docobj.parsed = true; //后面有判断docobj.parsed  强行赋值
    return docobj;
  }
  return null;
}
function DHC_CreateByXMLName(
  LODOP,
  XMLName,
  inpara,
  inlist,
  jsonArr,
  otherCfg
) {
  //var mystr = tkMakeServerCall("web.DHCXMLPConfig","ReadXmlByName",XMLName);
  //DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,XMLName);
}
function DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg) {
  var mystr = "";
  for (var i = 0; i < PrtAryData.length; i++) {
    mystr = mystr + PrtAryData[i];
  }
  DHC_CreateByXMLStr(
    LODOP,
    mystr,
    inpara,
    inlist,
    jsonArr,
    reportNote,
    otherCfg
  );
}
/*
入参见DHC_CreateByXML方法
@return 
成功 返回打印内容保存图片后对应的BASE64字符串
失败 返回""
*/
function DHC_GetBase64ByLodop(
  LODOP,
  inpara,
  inlist,
  jsonArr,
  reportNote,
  otherCfg
) {
  var mystr = "";
  for (var i = 0; i < PrtAryData.length; i++) {
    mystr = mystr + PrtAryData[i];
  }
  return DHC_GetBase64ByLodopByStr(
    LODOP,
    mystr,
    inpara,
    inlist,
    jsonArr,
    reportNote,
    otherCfg
  );
}
/* myxmlstr-->base64 */
function DHC_GetBase64ByLodopByStr(
  LODOP,
  mystr,
  inpara,
  inlist,
  jsonArr,
  reportNote,
  otherCfg
) {
  if (
    LODOP == null ||
    (typeof LODOP.VERSION == "undefined" &&
      ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb))
  ) {
    return -404;
  }
  LODOP.PRINT_INIT(""); //清除上次打印元素
  DHC_CreateByXMLStr(
    LODOP,
    mystr,
    inpara,
    inlist,
    jsonArr,
    reportNote,
    otherCfg
  );
  LODOP.SET_SAVE_MODE("FILE_PROMPT", "0");
  LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME", ".png");
  LODOP.SET_SAVE_MODE("RETURN_FILE_NAME", "1");
  var diskName = "D"; //LODOP.GET_SYSTEM_INFO("DiskDrive.1.Label"); //有电脑取的是1121i221_12
  if (LODOP.SAVE_TO_FILE(diskName + ":dhclodop.png")) {
    return LODOP.FORMAT("FILE:EncodeBase64", diskName + ":dhclodop.png");
  } else {
    alert("保存打印图片失败!");
    return "";
  }
  //LODOP.FORMAT("FILE:WAVE,c:/lodoptest.wav","Hello,您好！")
  return;
}

/**
*@author : wanghc 

*@param : {DLLObject} LODOP 
*		   expample: var LODOP = getLodop();

*@param : {String}   inpara 
*          expample: name_$c(2)_zhangsha^patno_$c(2)_000009
*
*@param : {String}   inlist 
*         expample: DrugName^Price^DrugUnit^Qty^PaySum_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
*
*@param : {Object} jsonArr
*         expample: [
					{type:"invoice",PrtDevice:"pdfprinter"},
					{type:"line",sx:1,sy:1,ex:100,ey:100},
					{type:"text",name:"patno",value:"0009",x:10,y:10,isqrcode:true,lineHeigth:5}
					]
*        <text>=>name,value,x,y is require
*@param : {String}  reportNote     print task name,  example: PrintText
*
*@param : {Object}  otherCfg  
          example: {LetterSpacing:-2,printListByText:false}
*
*/
function DHC_PrintByLodop(
  LODOP,
  inpara,
  inlist,
  jsonArr,
  reportNote,
  otherCfg
) {
  if (
    LODOP == null ||
    (typeof LODOP.VERSION == "undefined" &&
      ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb))
  ) {
    return -404;
  }
  if (
    "undefined" != typeof EnableLocalWeb &&
    1 == EnableLocalWeb &&
    LODOP.clear
  ) {
    LODOP.clear();
  }
  /* 打印完后,不刷新界面再打印时，走打印机不对---add 2018-12-11*/
  LODOP.PRINT_INIT(""); /*清除上次打印元素*/
  DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
  var rtn = LODOP.PRINT();
  if (
    "undefined" != typeof EnableLocalWeb &&
    1 == EnableLocalWeb &&
    LODOP.invk
  ) {
    rtn = LODOP.invk();
  }
  return rtn;
}
