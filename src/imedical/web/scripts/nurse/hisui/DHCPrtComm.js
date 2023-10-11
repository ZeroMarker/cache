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
                '" defaultvalue="' +
                itemJson.value +
                '" printvalue="' +
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

    var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
    //docobj.async = false;    //
    var rtn = docobj.loadXML(mystr);
    if (rtn) {
      //ToPrintHDLP
      var rtn = PObj.ToPrintHDLP(inpara, inlist, docobj);
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
    //var obj=document.getElementById(encName);
    //var encmeth=obj.value;
    //alert(encName)
    //var PrtConfig=cspRunServerMethod(encName,"DHCP_RecConStr",PFlag);
    var PrtConfig = tkMakeServerCall(
      "web.DHCXMLIO",
      "ReadXML",
      "DHCP_RecConStr",
      "DHCPisLabel"
    );
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
    //alert(2+"rtn"+mystr)
    if (rtn) {
      ////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
      var rtn = PObj.ToPrintHDLP(inpara, inlist, docobj);

      //var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
    }
    //alert(3)
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
      if (pval.indexOf("http:") == 0) {
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
function LODOP_CreateTxt(
  LODOP,
  invXMLDoc,
  inpara,
  inlist,
  jsonArr,
  reportNote
) {
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
          LODOP.SET_PRINT_STYLEA(0, "ShowBarText", 0);
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
          LODOP.SET_PRINT_STYLEA(0, "ShowBarText", 0);
          if (xmlTxtDataRePrtHeadFlag == "Y")
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=页眉页脚
        }
        //LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",1);
      } else {
        //console.log(pleft+"mm"+","+ptop+"mm"+",pfbold="+pfbold+",80cm"+","+"5mm"+","+pval);
        LODOP.ADD_PRINT_TEXT(ptop + "mm", pleft + "mm", "800mm", "5mm", pval);
        if (reportNote === "infant") {
          LODOP.SET_PRINT_STYLEA(0, "LetterSpacing", -2);
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
*/
function DHC_CreateByXMLStr(LODOP, mystr, inpara, inlist, jsonArr, reportNote) {
  //try{
  if (arguments.length > 4 && jsonArr != "" && "undefined" != typeof jsonArr) {
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
  inpara = DHCP_TextEncoder(inpara);
  inlist = DHCP_TextEncoder(inlist);
  //一个xml模板多次打印但希望在同一次任务中,多次调用当前方法 2018-10-31
  if ("undefined" != typeof reportNote && LODOP.GET_VALUE("ItemCount", 1) == 0)
    LODOP.PRINT_INIT(reportNote); //一次任务,不用多次init。
  var docobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
  //docobj.async = false;    //
  var rtn = docobj.loadXML(mystr);
  if (rtn) {
    if (docobj.parsed) {
      var inv = docobj.documentElement.childNodes[0];
      LODOP_CreateInv(LODOP, inv); //一次任务,纸张不会多种 20190920update by wanghuicai if (LODOP.GET_VALUE("ItemCount",1)==0)
      //lodop推荐先打印线
      LODOP_CreateLine(LODOP, inv, inpara, inlist, jsonArr);
      //lodop推荐再打印图片
      LODOP_CreateImg(LODOP, inv, inpara, inlist, jsonArr);
      //lodop打印文本
      LODOP_CreateTxt(LODOP, inv, inpara, inlist, jsonArr, reportNote);
      //lodop打印列表
      LODOP_CreateList(LODOP, inv, inpara, inlist, jsonArr);
    }
  }
  /*}catch(e){
		alert(e.message);
		return;
	}*/
}
function DHC_CreateByXMLName(LODOP, XMLName, inpara, inlist, jsonArr) {
  //var mystr = tkMakeServerCall("web.DHCXMLPConfig","ReadXmlByName",XMLName);
  //DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,XMLName);
}
function DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote) {
  var mystr = "";
  for (var i = 0; i < PrtAryData.length; i++) {
    mystr = mystr + PrtAryData[i];
  }
  DHC_CreateByXMLStr(LODOP, mystr, inpara, inlist, jsonArr, reportNote);
}
/*
入参见DHC_CreateByXML方法
@return 
成功 返回打印内容保存图片后对应的BASE64字符串
失败 返回""
*/
function DHC_GetBase64ByLodop(LODOP, inpara, inlist, jsonArr, reportNote) {
  LODOP.PRINT_INIT(""); //清除上次打印元素
  DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote);
  LODOP.SET_SAVE_MODE("FILE_PROMPT", "0");
  LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME", ".png");
  LODOP.SET_SAVE_MODE("RETURN_FILE_NAME", "1");
  var diskName = LODOP.GET_SYSTEM_INFO("DiskDrive.1.Label");
  if (LODOP.SAVE_TO_FILE(diskName + ":dhclodop.png")) {
    return LODOP.FORMAT("FILE:EncodeBase64", diskName + ":dhclodop.png");
  } else {
    alert("保存打印图片失败!");
    return "";
  }
  //LODOP.FORMAT("FILE:WAVE,c:/lodoptest.wav","Hello,您好！")
  return;
}
function DHC_PrintByLodop(LODOP, inpara, inlist, jsonArr, reportNote) {
  // 打印完后,不刷新界面再打印时，走打印机不对---add 2018-12-11
  LODOP.PRINT_INIT(""); //清除上次打印元素
  DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote);
  return LODOP.PRINT();
}
