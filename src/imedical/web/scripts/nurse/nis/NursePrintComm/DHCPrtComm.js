///DHCPrtComm.js
PrtAryData = new Array();
/**
 *@author : wanghc
 *@date : 2017-2-9
 *@param : {int} printWidth ��ӡֽ���
 *@param : {String} str ��ӡ����
 *@param : {int} wordWidth һ���ֵĿ��
 * var x  = getCenterX(190,"������̳ҽԺ",4)
 */
function getCenterX(printWidth, str, wordWidth) {
  var titleLen = str.length * wordWidth;
  var x = (printWidth - titleLen) / 2;
  return x;
}
/**
 *@author : wanghc
 *@date : 2017-2-9
 *@param : {String} str ����һ�г����ַ���
 *@param : {int} lineWordNum  һ����ʾ���ٸ����֡�һ�������൱������ĸ
 *@other label�����Զ�����,Ҫ��\n�ܻ���
 *var str = "��������1.	�رձ�����2.	�Ѷ������ܱ����߰�װ��jdbcĿ¼��ע��p8���µ�������(CacheDB.jar)��ͼ 3.	��cache2010��װĿ¼���磺\Dev\java\lib\JDK15 ����cacheDB.jar���ļ���С��2098kb�����������ܱ����߰�װ��jdbc�У���������JDK16�µ�cacheDB.jar��4.	��ͨ��studio���������query�࣬�޸��������õ�query ��sqlproc���ԣ����Ϊfalse�����ó�true ������� p5��2010��Ҫ���ã���ͼ��"
 *str = autoWordEnter(str,46);
 */
function autoWordEnter(str, lineWordNum) {
  var charWordNum = lineWordNum * 2; //һ���ֳ���Ϊ����char����
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
      charLen += 2; //����
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
 *@param : {ClsBillPrint} VB��ӡ����
 *          ��: <object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,43' VIEWASTEXT></object>
 *          ��: d ##Class(web.DHCBillPrint).InvBillPrintCLSID()
 *		   ��: var PObj = new ActiveXObject("DHCOPPrint.ClsBillPrint");
 *
 *@param : {String}   �ı�����   $c(2)�ָ����ֵ, ^Ϊ�����ֵ�ָ��.
 *          ��: name_$c(2)_����^patno_$c(2)_000009
 *
 *@param : {String}   �б�����	^�ָ���, $c(2)Ϊ�м�ָ��.
 *          ��: DrugName^Price^DrugUnit^Qty^PaySum_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
 *
 *@param : {Object} jsonArr ���ӵ��Զ����ӡ����   ���Բ���, 2017-10-25 �����޸Ĵ�ӡ��
 *          ��: [{type:"invoice",PrtDevice:"pdfprinter"},{type:"line",sx:1,sy:1,ex:100,ey:100},{type:"text",name:"patno",value:"0009",x:10,y:10,isqrcode:true,lineHeigth:5}]
 *              text����name,value,x,yΪ����,
 * 			��ѡ������: fontsize,fontbold,fontname, Ĭ��ֵΪ12,false,����
 *@param : invHeight Ʊ�ݵĸ߶�----cab���жϴ�ӡ��ҳ�ǣ�����Ԫ��λ��top����height�ͻỻҳ��ӡ���������һ��Ԫ�س���һҳ�󣬺���Ԫ��top-height�Ϳ���ʵ�ַ�ҳ��ӡ
 * 2018-09-20 ����invHeight ��ҳ����
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
    /*����inpara�л�������,��������,����jsonArr*/
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
    //-----jsonArr����
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
                (itemJson.fontname || "����") +
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
                  (itemJson.fontname || "����") +
                  '" defaultvalue="' +
                  textValueArr[tmpInd] +
                  '" printvalue="' +
                  textValueArr[tmpInd] +
                  '"></txtdatapara>';
                tmpStartY += parseInt(itemJson.lineHeigth || 5);
              }
              //exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"����")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>';
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
    // �����ҳ
    var page2 = false; //�Ƿ��ǵڶ�ҳ
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
              (itemJson.fontname || "����") +
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
// name^С��$c(2)age^24��
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
      // ��ӡ����ʱ���ֵû�ж��ߴ�*,���Զ���*,��*�����ɨ�롣2019-4-1����һԺstart
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
      // inpara��ɶ���
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
      // ��ӡ����ʱ���ֵû�ж��ߴ�*,���Զ���*������һԺstart
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
      // inpara��ɶ���
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
    //���ֽڼ�1
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
    //���ֽڼ�1
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
  //��ȡ������д��c�̳�Ϊ.gif�ļ�
  var myobj = document.getElementById("ClsSaveBase64IMG");
  if (myobj && ImgBase64 != "") {
    var sReigstNo = USERID;
    var sFiletype = "gif";
    var rtn = myobj.WriteFile(sReigstNo, ImgBase64, sFiletype);
    if (!rtn) {
      alert("ǩ��ͼƬת������");
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
  //lodop�Ƽ��ȴ���
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
      ); //0=ʵ��,1=�߿�
      if (xmlPlineRePrtHeadFlag == "Y")
        LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=ҳüҳ��
    }
  }
}
function LODOP_CreateImg(LODOP, invXMLDoc, inpara, inlist, jsonArr) {
  // inpara��ɶ���
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
        pval = "<img border='0' src='" + pval + "'/>"; //"URL:"+pval;--�������������
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
        //   LODOP.SET_PRINT_STYLEA(0,"Stretch",2);//��ԭͼ����(������)����ģʽ
        LODOP.SET_PRINT_STYLEA(0, "Stretch", 1); //(�ɱ���)��չ����ģʽ
        if (xmlPICDataRePrtHeadFlag == "Y")
          LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=ҳüҳ��
      }
    }
  }
}
function LODOP_CreateTxt(LODOP, invXMLDoc, inpara, inlist, jsonArr, otherCfg) {
  // inpara��ɶ���
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
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=ҳüҳ��
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
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=ҳüҳ��
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
          LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //1=ҳüҳ��
      }
    }
  }
}
///����TEXTģʽ��ӡList����
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
    //		<Listdatapara name="Listdatapara0" xcol="17.196" yrow="36.772" defaultvalue="��һ��" printvalue="" fontbold="false" fontname="����" fontsize="11" />
    //		<Listdatapara name="Listdatapara1" xcol="42.063" yrow="36.772" defaultvalue="�ڶ���" printvalue="" fontbold="false" fontname="����" fontsize="12" />
    //		<Listdatapara name="Listdatapara2" xcol="71.958" yrow="36.772" defaultvalue="������" printvalue="" fontbold="false" fontname="����" fontsize="12" />
    //		<Listdatapara name="listItem3" xcol="106.085" yrow="42.063" defaultvalue="������" printvalue="" fontbold="false" fontname="����" fontsize="11" />
    //		<Listdatapara name="listItem4" xcol="137.302" yrow="42.328" defaultvalue="������" printvalue="" fontbold="false" fontname="����" fontsize="11" />
    //		<Listdatapara name="listItem5" xcol="169.048" yrow="43.651" defaultvalue="������" printvalue="" fontbold="false" fontname="����" fontsize="11" />
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
        currRowNo++; //��ǰ���к�
        currPage = Math.floor((currRowNo - 1) / xmlPageRows) + 1; //��ǰҳ��
        currPageRowNo = ((currRowNo - 1) % xmlPageRows) + 1; //��ǰҳ��ǰ��

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
          //������� �Ҳ����� �� б�߿�ȴ���0
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
          ); //0=ʵ��,1=�߿�
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
    var tableOneHeight = parseInt(rowHeight * xmlPageRows); //һҳ���߶�
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
    //inlist���
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
        //û�����Ŵ�ӡslash
        var remainRow = inlistArrValidCount % xmlPageRows;
        var slash2Top = parseInt(tableTop) + remainRow * rowHeight;
        var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
        var slash1Top = parseInt(tableTop) + parseInt(tableOneHeight);
        var slash1Left = tableLeft;
        /*
				var tableCount = Math.ceil(inlistArrValidCount / xmlPageRows); //���ӡ��n��
				var tableTotalMaxHeight = parseInt(tableCount * tableOneHeight); //n�ű��ĸ߶�
				var tableTotalHeight = parseInt(inlistArrValidCount * rowHeight) ; //��ӡ���ݵ��ܸ߶�
				var slash2Top = parseInt(tableTop)+parseInt(tableTotalHeight);  //��������top
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
        ); //0=ʵ��,1=�߿�
        //var lastTop = parseFloat(LODOP.GET_VALUE("ItemTop",'last')); //ֻ�����ʱ������
        //var lastLeft = parseFloat(LODOP.GET_VALUE("ItemLeft",'last'));
      }
    }
  }
}
// linkֻ��json��ȡ
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
/*��С�뷽��*/
function LODOP_CreateInv(LODOP, invXMLDoc) {
  var invAttr = invXMLDoc.attributes;
  var invHeight = invAttr.getNamedItem("height").value;
  var invWidth = invAttr.getNamedItem("width").value;
  var invOrient = "X";
  if (invAttr.getNamedItem("LandscapeOrientation")) {
    //�ϰ������,Ĭ�������û�д�����
    invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=����,Y=����
  }
  //var invPrtDirect = invAttr.getNamedItem("PrtDirection").value; //Y----��Ч
  var invPrtPaperSet = invAttr.getNamedItem("PrtPaperSet").value; //WIN
  var invPrtDevice = invAttr.getNamedItem("PrtDevice").value; //xps
  var invPrtPage = invAttr.getNamedItem("PrtPage").value; //A5
  //var invPrtDesc = invAttr.getNamedItem("PaperDesc").value; //----��Ч
  var intOrient = 1; //Ĭ��1=����
  if (invOrient == "Y") intOrient = 2;
  else if (invOrient == "X") intOrient = 1;
  else if (invOrient == "Z") {
    intOrient = 3; /*�����ݸ߶���*/
  }
  if (invPrtPaperSet == "HAND") {
    var lodopPageWidth = invWidth * 10 + "mm";
    var lodopPageHeight = invHeight * 10 + "mm";
    var lodopPageName = "";
  } else {
    var lodopPageWidth = 0; //��ʾ��Ч
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
  //LODOP.SET_PRINT_PAGESIZE(3,1385,45,""); //����3��ʾ�����ӡ��ֽ�ߡ������ݵĸ߶ȡ���1385��ʾֽ��138.5mm��45��ʾҳ�׿հ�4.5mm
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
* ͨ��xmlģ������lodop��ӡ����

*@param : {DLLObject} LODOP����  getLodop()���
*
*@param :  mystr --- xmlģ������
*
*@param : {String}   inpara�ı�����   $c(2)�ָ����ֵ, ^Ϊ�����ֵ�ָ��. 
*          ��: name_$c(2)_����^patno_$c(2)_000009
*
*@param : {String}   inlist�б�����	^�ָ���, $c(2)Ϊ�м�ָ��. 
*          ��: DrugName^Price^DrugUnit^Qty^PaySum_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
*
*@param : {Object} jsonArr ���ӵ��Զ����ӡ����   ���Բ���, 2017-10-25 �����޸Ĵ�ӡ��
*          ��: [{type:"invoice",PrtDevice:"pdfprinter"},{type:"line",sx:1,sy:1,ex:100,ey:100},{type:"text",name:"patno",value:"0009",x:10,y:10,isqrcode:true,lineHeigth:5}]
*              text����name,value,x,yΪ����,
*@param : {String}  reportNote  ��ӡ����
*
*@param : {Object}  otherCfg  ����������  otherCfg.printListByText true��text��ʽ��ӡlist���� Ĭ��false
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
              (itemJson.fontname || "����") +
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
              (itemJson.fontname || "����") +
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
  //һ��xmlģ���δ�ӡ��ϣ����ͬһ��������,��ε��õ�ǰ���� 2018-10-31
  if ("undefined" != typeof reportNote && LODOP.GET_VALUE("ItemCount", 1) == 0)
    LODOP.PRINT_INIT(reportNote); //һ������,���ö��init��
  /*var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		//docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);*/
  var docobj = DHC_parseXml(mystr);
  if (docobj) {
    if (docobj.parsed) {
      LODOP.SET_LICENSES(
        "����ҽΪ�Ƽ����޹�˾",
        "4EF6E3D5AB0D478F5A07D05CDDDE2365",
        "�|�A�t��Ƽ����޹�˾",
        "7C4A2B70D17D01CCD5CB2A3A6B4D3200"
      );
      LODOP.SET_LICENSES(
        "THIRD LICENSE",
        "",
        "DHC Medical Science & Technology Co., Ltd.",
        "604523CF08513643CB90BACED8EFF303"
      );
      var inv = docobj.documentElement.childNodes[0];
      if (LODOP.GET_VALUE("ItemCount", 1) == 0) LODOP_CreateInv(LODOP, inv); //һ������,ֽ�Ų������
      //lodop�Ƽ��ȴ�ӡ��
      LODOP_CreateLine(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop��ӡ�ı�
      LODOP_CreateTxt(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop�Ƽ��ٴ�ӡͼƬ
      LODOP_CreateImg(LODOP, inv, inpara, inlist, jsonArr, otherCfg);

      //lodop��ӡ�б�
      if (otherCfg.printListByText == true) {
        LODOP_CreateListByText(LODOP, inv, inpara, inlist, jsonArr);
      } else {
        LODOP_CreateList(LODOP, inv, inpara, inlist, jsonArr);
      }

      //LODOP.ADD_PRINT_TEXT(15,200,200,25,"�Ʊ���:guest");
      //LODOP.SET_PRINT_STYLEA(0,"LinkedItem-1); 		",-1);
      LODOP_CreateLink(LODOP, inv, inpara, inlist, jsonArr);
    }
  }
  /*}catch(e){
		alert(e.message);
		return;
	}*/
}
///�Ƴ������е�text�ڵ�
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
///����xml�ַ���Ϊ����
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
    docobj.parsed = true; //�������ж�docobj.parsed  ǿ�и�ֵ
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
��μ�DHC_CreateByXML����
@return 
�ɹ� ���ش�ӡ���ݱ���ͼƬ���Ӧ��BASE64�ַ���
ʧ�� ����""
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
  LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
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
  var diskName = "D"; //LODOP.GET_SYSTEM_INFO("DiskDrive.1.Label"); //�е���ȡ����1121i221_12
  if (LODOP.SAVE_TO_FILE(diskName + ":dhclodop.png")) {
    return LODOP.FORMAT("FILE:EncodeBase64", diskName + ":dhclodop.png");
  } else {
    alert("�����ӡͼƬʧ��!");
    return "";
  }
  //LODOP.FORMAT("FILE:WAVE,c:/lodoptest.wav","Hello,���ã�")
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
  /* ��ӡ���,��ˢ�½����ٴ�ӡʱ���ߴ�ӡ������---add 2018-12-11*/
  LODOP.PRINT_INIT(""); /*����ϴδ�ӡԪ��*/
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
