///DHCPrtComm.js
PrtAryData=new Array()
/**
*@author : wanghc
*@date : 2017-2-9
*@param : {int} printWidth 打印纸宽度
*@param : {String} str 打印内容 
*@param : {int} wordWidth 一个字的宽度
* var x  = getCenterX(190,"北京地坛医院",4)
*/
function getCenterX(printWidth, str, wordWidth){
	var titleLen = str.length * wordWidth;
	var x = (printWidth-titleLen)/2;
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
function autoWordEnter(str,lineWordNum){
    var charWordNum = lineWordNum*2;  //一汉字长度为二个char长度
	if (str == null) return str;
	if (typeof str != "string"){
		return str;
	}
	var tmp, rtn="";
	var arr=[];
	var charLen=0 ;
	for(var i=0;i<str.length;i++){
	    var chr = str.charAt(i);
	    arr.push(chr);
	    if (chr.charCodeAt(0)>127 || chr.charCodeAt(0)==9) {  
            charLen += 2;  //汉字
        }else{  
            charLen ++;  
        }  
	    if (charLen>=charWordNum){
	        arr.push('\n');
	        charLen=0;
	    }
	}
	return arr.join('');
}
function evalXMLVal(val){
	if ('string'==typeof val && val!="") return val.replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/&/g,"&amp;").replace(/'/g,"&apos;").replace(/\"/g,"&quot;");
	return val;	
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
function DHCP_XMLPrint(PObj, inpara, inlist, jsonArr,invHeight){
	var c2 = String.fromCharCode(2);
	jsonArr = jsonArr||[];
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		mystr = DHCP_replaceAll(mystr, "   =   ", "=");
		mystr = DHCP_replaceAll(mystr, "  =  ", "=");
		mystr = DHCP_replaceAll(mystr, " = ", "=");
		inpara=DHCP_TextEncoder(inpara);
		inlist=DHCP_TextEncoder(inlist);
		/*处理inpara中换行数据,对齐问题,生成jsonArr*/
		var inparaArr = inpara.split('^');
		var tmpArr = [];
		for(var tmpInd=0; tmpInd<inparaArr.length; tmpInd++){
			var inParaItemArr = inparaArr[tmpInd].split(c2);
			var itemName = inParaItemArr[0];
			if(inParaItemArr.length>1 && inParaItemArr[1].indexOf("\n")>-1){
				var ritem = new RegExp('txtdatapara.+?name=\\"'+itemName+'\\"(.+)>');
				var tmprItem = mystr.match(ritem);
				if (tmprItem!=null){
					//alert(tmprItem[1])
					//var rx = new RegExp('name=\\"'+inParaItemArr[0]+'\\".+?xcol=\\"(.+?)\\"');
					var rx = tmprItem[1].match(/xcol=\"(.+?)\"/)[1];
					var ry = tmprItem[1].match(/yrow=\"(.+?)\"/)[1];
					var rfs = tmprItem[1].match(/fontsize=\"(.+?)\"/)[1];
					var rfb = tmprItem[1].match(/fontbold=\"(.+?)\"/)[1];
					var rfn = tmprItem[1].match(/fontname=\"(.+?)\"/)[1];
					//alert(rx+","+ry+","+rfs+","+rfb+","+rfn);	
					var inParaItemValueArr = inParaItemArr[1].split('\n');
					for (var j=1;j<inParaItemValueArr.length;j++){
						jsonArr.push({
							type:'text',name:itemName+'ntr'+j,value:inParaItemValueArr[j],
							x:rx,y:parseFloat(ry)+(j*5),fontsize:rfs,fontbold:rfb,fontname:rfn
						});
					}
					tmpArr.push(itemName+c2+inParaItemValueArr[0]);
					
				}
			}else{
				tmpArr.push(inparaArr[tmpInd]);
			}
		}
		inpara = tmpArr.join('^');
		//-----jsonArr处理
		if (jsonArr.length>0){
			if (jsonArr.length>0 && jsonArr[0].type.toLowerCase()=="invoice"){
				var invObj = jsonArr[0];
				for (var p in invObj){
					if (p!="type"){
						mystr = mystr.replace(new RegExp(p+'=".*?"','mi'), function(){
							return p+"=\""+invObj[p]+"\"";
						})
					}
				}
			}
			var itemJson="", exLineXml = "",exTextXml="";
			for(var j = 0; j < jsonArr.length; j++){
			    itemJson = jsonArr[j];
			    if (itemJson.value){ itemJson.value = evalXMLVal(itemJson["value"]);}
				if (itemJson["type"]){
					if (itemJson["type"].toLowerCase()=="invoice"){
					}else if (itemJson["type"].toLowerCase()=="line"){
						exLineXml += '<PLine BeginX="'+itemJson.sx+'" BeginY="'+itemJson.sy+'" EndX="'+itemJson.ex+'" EndY="'+itemJson.ey+'"></PLine>'
					}else if (itemJson["type"].toLowerCase()=="text"){
						if (itemJson.isqrcode){
							exTextXml += '<txtdatapara width="'+(itemJson.width||100)+'" height="'+(itemJson.height||100)+'" name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"宋体")+'" defaultvalue="" printvalue="'+(itemJson.value)+'" isqrcode="true"></txtdatapara>';
						}else{
							var textValueArr = itemJson.value.split("\n");
							var tmpStartY = itemJson.y;
							for (var tmpInd=0; tmpInd<textValueArr.length; tmpInd++){
								exTextXml += '<txtdatapara name="'+itemJson.name+tmpInd+'" xcol="'+itemJson.x+'" yrow="'+tmpStartY+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"宋体")+'" defaultvalue="'+(textValueArr[tmpInd])+'" printvalue="'+(textValueArr[tmpInd])+'"></txtdatapara>';
								tmpStartY += parseInt(itemJson.lineHeigth||5);
							}
							//exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"宋体")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>';
						}
					}
				}
			}
			//console.log(exLineXml+","+exTextXml);
			var txtDataIndex = mystr.indexOf("</TxtData>");
			mystr = mystr.slice(0,txtDataIndex)+exTextXml+mystr.slice(txtDataIndex);
			var lineDataIndex = mystr.indexOf("</PLData>");
			mystr = mystr.slice(0,lineDataIndex)+exLineXml+mystr.slice(lineDataIndex);
			//console.log(mystr);
		}
		// 处理分页
		var page2 = false; //是否是第二页
		var mystr = mystr.replace(/\syrow\s*?=\s*?"(.+?)"\s/ig,function(str,str2){
			if (parseFloat(str2)>invHeight){
				if (page2){
					return ' yrow="'+(parseFloat(str2)-invHeight)+'" '; 
				}else{
					page2 = true;
				}
			}
			return ' yrow="'+str2+'" ';
		})
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){ //("undefined"==typeof isIECore || isIECore){
			var docobj= CreateXMLDOM();
			//docobj.async = false;    //
			var rtn=docobj.loadXML(mystr); 
			if (rtn){
				var rtn=PObj.ToPrintHDLP(inpara,inlist,docobj);
			}
		}else{
			if (PObj && 'undefined'!=typeof PObj.ToPrintHDLPStr){  /*增加PObj判断,老的对象没有ToPrintHDLPStr导致到catch中*/
				var rtn = PObj.ToPrintHDLPStr(inpara,inlist,mystr);
			}else{
				var rtn = DHCOPPrint.ToPrintHDLPStr(inpara,inlist,mystr);
			}
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DHCP_XMLPrintDoc(PObj, inpara, inlist, jsonArr){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		if (arguments.length>3 && jsonArr!==""){
			if (jsonArr.length>0 && jsonArr[0].type.toLowerCase()=="invoice"){
				var invObj = jsonArr[0];
				for (var p in invObj){
					if (p!="type"){
						mystr = mystr.replace(new RegExp(p+'=".*?"','mi'), function(){
							return p+"=\""+invObj[p]+"\"";
						})
					}
				}
			}
			var itemJson="", exLineXml = "",exTextXml="";
			for(var j = 0; j < jsonArr.length; j++){
			    itemJson = jsonArr[j];
				if(itemJson["type"]){
					if (itemJson["type"].toLowerCase()=="invoice"){
					}else if (itemJson["type"].toLowerCase()=="line"){
						exLineXml += '<PLine BeginX="'+itemJson.sx+'" BeginY="'+itemJson.sy+'" EndX="'+itemJson.ex+'" EndY="'+itemJson.ey+'"></PLine>'
					}else if (itemJson["type"].toLowerCase()=="text"){
						exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"宋体")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>'
					}
				}
			}
			//console.log(exLineXml+","+exTextXml);
			var txtDataIndex = mystr.indexOf("</TxtData>");
			mystr = mystr.slice(0,txtDataIndex)+exTextXml+mystr.slice(txtDataIndex);
			var lineDataIndex = mystr.indexOf("</PLData>");
			mystr = mystr.slice(0,lineDataIndex)+exLineXml+mystr.slice(lineDataIndex);
			//console.log(mystr);
		}
		var docobj= CreateXMLDOM();
		//docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		if (rtn){
			//ToPrintHDLP
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
// name^小二$c(2)age^24岁
function DHCP_PrintFun(PObj,inpara,inlist){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js

	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}

		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)			
		var docobj= CreateXMLDOM();
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);

		if ((rtn)){
			// 打印条码时如果值没有二边带*,则自动补*,加*后可以扫码。2019-4-1兰大一院start
			var barcodeItemNameObj = {}; 
			var inv = docobj.documentElement.childNodes[0];
			var xmlTxtData = inv.getElementsByTagName("TxtData");
			var txtDatas=  xmlTxtData[0].getElementsByTagName("txtdatapara");
			if (txtDatas){
				for (var j=0;j<txtDatas.length; j++){
					var item = txtDatas[j];
					var fontname = item.getAttribute('fontname');
					if (fontname=="C39P36DmTt"){
						barcodeItemNameObj[item.getAttribute('name')]=true ;
						
					}
				}
			}
			// inpara拆成对象
			var c2 = String.fromCharCode(2);
			var inparaArr = inpara.split('^');
			for(var i=0; i<inparaArr.length; i++){
				var arr = inparaArr[i].split(c2);
				if (barcodeItemNameObj[arr[0]] && arr[1].indexOf("*")==-1) {
					inparaArr[i] = arr[0]+c2+"*"+arr[1]+"*";
				}
			}
			inpara = inparaArr.join("^");
			// end
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		//alert(e.message);
		//return;
	}
}
function DHCP_PrintFunNew(PObj,inpara,inlist){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
				
		var docobj= CreateXMLDOM();
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		
		if ((rtn)){
			// 打印条码时如果值没有二边带*,则自动补*。兰大一院start
			var barcodeItemNameObj = {}; 
			var inv = docobj.documentElement.childNodes[0];
			var xmlTxtData = inv.getElementsByTagName("TxtData");
			var txtDatas=  xmlTxtData[0].getElementsByTagName("txtdatapara");
			if (txtDatas){
				for (var j=0;j<txtDatas.length; j++){
					var item = txtDatas[j];
					var fontname = item.getAttribute('fontname');
					if (fontname=="C39P36DmTt"){
						barcodeItemNameObj[item.getAttribute('name')]=true ;
					}
				}
			}
			// inpara拆成对象
			var c2 = String.fromCharCode(2);
			var inparaArr = inpara.split('^');
			for(var i=0; i<inparaArr.length; i++){
				var arr = inparaArr[i].split(c2);
				if (barcodeItemNameObj[arr[0]] && arr[1].indexOf("*")==-1) {
					inparaArr[i] = arr[0]+c2+"*"+arr[1]+"*";
				}
			}
			inpara = inparaArr.join("^");
			// end
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DHCP_PrintFunNewCustom(PObj,inpara,inlist,cuspara){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js
	try{
		//alert(cuspara);
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)		
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //
		
		if (cuspara!="")
		{
			var exTextXml=cuspara;
			var txtDataIndex = mystr.indexOf("</TxtData>");
			mystr = mystr.slice(0,txtDataIndex)+exTextXml+mystr.slice(txtDataIndex);
		}

		
		var rtn=docobj.loadXML(mystr);
		
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}

function DHCP_GetXMLConfig(encName,PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0
		var obj=document.getElementById(encName);
		if (obj){
			var encmeth=obj.value;
			var PrtConfig=cspRunServerMethod(encmeth,"DHCP_RecConStr",PFlag);
		}else{
			var PrtConfig=tkMakeServerCall("web.DHCXMLIO", "ReadXML","DHCP_RecConStr",PFlag);
		}
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function PisDHCP_GetXMLConfig(encName,PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0
		var PrtConfig=tkMakeServerCall("web.DHCXMLIO", "ReadXML","DHCP_RecConStr",PFlag); //"DHCPisLabel");
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
function DHCP_mytest(encmeth,PFlag,PObj){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js
	////
	try{		
		
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		var docobj= CreateXMLDOM();
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);			
		}
	}catch(e){
		alert(e.message);
		return;
	}
	return rtn;
}

function DHCP_RecConStr(ConStr){
	///var myIdx=PrtAryData.length
	PrtAryData[PrtAryData.length]=ConStr;
	
}

function DHCP_TextEncoder(transtr){
	if (!transtr){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCP_replaceAll(dst, '\\"', '\"');
		dst = DHCP_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCP_replaceAll(dst, "\\r", "\r");
		dst = DHCP_replaceAll(dst, "\\n", "\n");
		dst = DHCP_replaceAll(dst, "\\t", "\t");
	}catch(e){
		alert(e.message);
		return "";
	}
	return dst;
}

function DHCP_replaceAll(src,fnd,rep) 
{ 
	//rep:replace
	//src:source
	//fnd:find
	if (src.length==0) 
	{ 
		return ""; 
	} 
	try{
		var myary=src.split(fnd);
		var dst=myary.join(rep);
	}catch(e){
		alert(e.message);
		return ""
	}
	return dst; 
} 
function DHCWeb_replaceAll(src,fnd,rep) 
{ 
	return DHCP_replaceAll(src,fnd,rep);
}
function strlen(str){
	var len = 0;
	for (var i=0; i<str.length; i++) { 
		var c = str.charCodeAt(i); 
		//单字节加1 
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) { 
			len++; 
		} 
		else { 
			len+=2; 
		} 
	} 
	return len;

}

function GetStrInfo(str,Needlen){
	var Output1="",Output2=""
	var len = 0;
	for (var i=0; i<str.length; i++) { 
		var c = str.charCodeAt(i); 
		//单字节加1 
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) { 
			len++; 
		} 
		else { 
			len+=2; 
		}
		//alert("c======:"+c)
		if (len<Needlen){
			Output1=Output1+String.fromCharCode(c)
		}else{
			Output2=Output2+String.fromCharCode(c)
		}
		//alert(Output1+"^^^^^"+Output2)
	} 
	return Output1+"^"+Output2;

}
function DHCP_PrintFunHDLP(PObj,inpara,inlist){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){ //if ("undefined"==typeof isIECore || isIECore){	
			var docobj= CreateXMLDOM();
			docobj.async = false;    //
			var rtn=docobj.loadXML(mystr);
			if ((rtn)){
				var rtn=PObj.ToPrintHDLP(inpara,inlist,docobj);
			}
		}else{
			if ('undefined'!=typeof PObj.ToPrintHDLPStr){
				var rtn = PObj.ToPrintHDLPStr(inpara,inlist,mystr);
			}else{
				var rtn = DHCOPPrint.ToPrintHDLPStr(inpara,inlist,mystr);
			}
			
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function GetGifInfo(USERID)
{
	var ImgBase64=tkMakeServerCall("web.UDHCPrescript","GetDocGifCode",USERID)
	//alert(ImgBase64)
	//读取流数据写入c盘成为.gif文件
	var myobj=document.getElementById('ClsSaveBase64IMG');
	if ((myobj)&&(ImgBase64!=""))
	{
		var sReigstNo = USERID
		var sFiletype= "gif"
		var rtn=myobj.WriteFile(sReigstNo,ImgBase64,sFiletype);
		if(!rtn)
		{
			alert("\u7B7E\u540D\u56FE\u7247\u8F6C\u6362\u9519\u8BEF");
			return -1;
		}
		return 0;
	}
	return -1;
}
/// SaveImg("http://127.0.0.1/dthealth/web/images/logon_btn.bmp","D:\\Signature\\btn.bmp")
function SaveImg(httpName,pathName){
    try {
		cspXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
	} catch (e) {
		try {
	 		cspXMLHttp=new ActiveXObject("Msxml2.XMLHTTP");
		} catch (E) {
			cspXMLHttp=null;
		}
	}
	cspXMLHttp.open("GET", httpName, false);
	cspXMLHttp.send();
	var adodbStream=new ActiveXObject("ADODB.Stream"); 
	adodbStream.Type=1;//1=adTypeBinary 
	adodbStream.Open(); //"http://127.0.0.1/dthealth/web/images/logon_btn.bmp"); 
	adodbStream.write(cspXMLHttp.responseBody); 
	adodbStream.SaveToFile(pathName,2); 
	adodbStream.Close(); 
	adodbStream=null; 
}
/*
{type:'line', sy:1,sx:1,ey:11,ex:11,rePrtHeadFlag:"Y"},
{type:'img', name:'', x:1, y:2, rePrtHeadFlag:"Y", value:"http://xx.png", width:24, height:24 },
{type:"text",name:"patno",value:"1024988919",x:10,y:10},
{type:"text",name:"invno",value:"1024988919",x:140,y:12,width:24,height:11,barcodetype:"128C",LetterSpacing:"-2"},
{type:"text",name:"invno",value:"1024988919",x:140,y:12,width:24,height:11,isqrcode:"true",qrcodeversion:1,LetterSpacing:"-2"},
{type:"img", y:(col.ptop+padTop)+"mm", x:col.pleft+"mm",  width:"800mm",  height:rowHeight+"mm",  value:pval,  FontSize:col.pfsize,  FontName:col.pfname, Bold:col.pfbold } 
*/
function LODOP_PrintItem(LODOP, item){
	var height = item.height||200, width = item.width||200;
	if ("string"==typeof item.height){
		if (item.height.indexOf('mm')>-1 || item.height.indexOf('%')>-1){
			height = item.height;
		}else{
			height = parseFloat(height) + "mm";
		}
	}else{
		height = parseFloat(height) + "mm";
	}
	if ("string"==typeof item.width){
		if (item.width.indexOf('mm')>-1 || item.width.indexOf('%')>-1){
			width = item.width;
		}else{
			width = parseFloat(width) + "mm";
		}
	}else{
		width = width + "mm";
	}
	item.x = item.x||item.xcol;
	item.y = item.y||item.yrow;
	var x = item.x||0, y = item.y||0, value = item.value||item.defaultvalue||"";
	item.sy =item.sy||item.BeginY,item.sx =item.sx||item.BeginX;
	item.ey =item.ey||item.EndY,item.ex =item.ex||item.EndX;
	var fname = item.fname||"宋体", fbold = item.fbold||item.fontbold||"false", fsize = item.fsize||item.fontsize||12,fcolor=item.fcolor||item.fontcolor||"";
	var rePrtHeadFlag = item.rePrtHeadFlag||item.RePrtHeadFlag|| "N";
	var barcodetype = item.barcodetype||null, isqrcode = item.isqrcode||null, qrcodeversion=item.qrcodeversion||"Auto";
	
	var isshowtext = item.isshowtext||"Y", angle=item.angle||0;
	if(item["type"]){
				if (item["type"].toLowerCase()=="invoice"){
			return;			
		}if (item["type"].toLowerCase()=="newpage"){
			LODOP.NEWPAGE();		
		}else if (item["type"].toLowerCase()=="img" || item["type"].toLowerCase()=="picdatapara" ){
				if (value.indexOf("http")==0 || value.indexOf("data:")==0){
					value = "<img border='0' src='"+value+"'/>" //"URL:"+pval;--导致浏览器崩溃
				}
				if (value!=""){
					LODOP.ADD_PRINT_IMAGE(item.y+"mm",item.x+"mm",width,height,value);
					if(value.indexOf("http")>-1) LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",500);
					if (height=="100%" && width=="100%"){
						//LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",100);//延迟100毫秒
						//LODOP.SET_PRINT_STYLEA(0,"Stretch",2);//图片显示原大小
					}else{
						LODOP.SET_PRINT_STYLEA(0,"Stretch",1);//(可变形)扩展缩放模式
					}
				}
		}else if (item["type"].toLowerCase()=="line" || item["type"].toLowerCase()=="pline"){
			if (item.sy) LODOP.ADD_PRINT_LINE(item.sy+"mm",item.sx+"mm",item.ey+"mm",item.ex+"mm",0,1); //0=实线,1=线宽
			if (fcolor!="") LODOP.SET_PRINT_STYLEA(0,"FontColor", fcolor);
		}else{
			if ('string'==typeof barcodetype){
				if (barcodetype=="128C") value = value.replace(/\D/gi,function(word){return "";})
				LODOP.ADD_PRINT_BARCODE(y+"mm",x+"mm",width, height ,barcodetype,value);
				if (isshowtext=="N") LODOP.SET_PRINT_STYLEA(0,"ShowBarText",0);
			}else if('string'==typeof isqrcode ){
				if (isqrcode=="true"){						
						// if(value.indexOf("http") > -1) {
						// 	value = encodeURI(value);
						// }
						LODOP.ADD_PRINT_BARCODE(y+"mm",x+"mm",width, height, "QRCode",value);
						if(",1,2,3,5,7,10,14,".indexOf(","+qrcodeversion+",")>-1){
							LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",qrcodeversion);		
						}else{
							//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",3);
						}
						LODOP.SET_PRINT_STYLEA(0,"DataCharset","UTF-8");
						// LODOP.SET_PRINT_STYLEA(0,"DataCharset","GB2312");
					}
			}else{ /*label*/
				LODOP.ADD_PRINT_TEXT(y+"mm",x+"mm",width, height, value);
				LODOP.SET_PRINT_STYLEA(0,"FontSize",fsize);
				LODOP.SET_PRINT_STYLEA(0,"FontName",fname);
				if (fbold=="true"){LODOP.SET_PRINT_STYLEA(0,"Bold",1);}
			}
			if (fcolor!="") LODOP.SET_PRINT_STYLEA(0,"FontColor", fcolor);
			if ("undefined"!=typeof item && !!item.LetterSpacing) {
				LODOP.SET_PRINT_STYLEA(0, "LetterSpacing", item.LetterSpacing);
			}
		}
		LODOP.SET_PRINT_STYLEA(0,"Angle",0);
		if (angle>0) LODOP.SET_PRINT_STYLEA(0,"Angle",angle);
		if (rePrtHeadFlag=="Y") LODOP.SET_PRINT_STYLEA(0,"ItemType",1); //1=页眉页脚
	}
};
function LODOP_CreateLine(LODOP,invXMLDoc,inpara,inlist,jsonArr){
	//lodop推荐先打画线
	var xmlPLine = invXMLDoc.getElementsByTagName("PLData");
	if (xmlPLine && xmlPLine.length>0){
		for(var myind=0; myind<xmlPLine.length; myind++){
			var xmlPlineRePrtHeadFlag = xmlPLine[myind].getAttribute("RePrtHeadFlag");
			var pLines = xmlPLine[myind].getElementsByTagName("PLine");
			for (var j=0;j<pLines.length;j++){
				var item = pLines[j]
				var pleft1 = item.getAttribute("BeginX");	
				var ptop1 = item.getAttribute("BeginY");	
				var pleft2 = item.getAttribute("EndX");	
				var ptop2 = item.getAttribute("EndY");
				var pfontcolor = item.getAttribute("fontcolor");
				LODOP_PrintItem(LODOP, {
					type:'line',
					sy:ptop1,
					sx:pleft1,
					ey:ptop2,
					ex:pleft2,
					rePrtHeadFlag:xmlPlineRePrtHeadFlag,
					fcolor:pfontcolor
				});
			}
		}
	}
}
function LODOP_CreateImg(LODOP,invXMLDoc,inpara,inlist,jsonArr){
	// inpara拆成对象
	var c2 = String.fromCharCode(2);
	var inparaArr = inpara.split('^');
	var inparaObj = {};
	for(var i=0; i<inparaArr.length; i++){
		var arr = inparaArr[i].split(c2);
		inparaObj[arr[0]] = arr[1];
	}
	var xmlPICData = invXMLDoc.getElementsByTagName("PICData");
	if (xmlPICData && xmlPICData.length>0){
		for(var myind=0; myind<xmlPICData.length; myind++){
			var xmlPICDataRePrtHeadFlag = xmlPICData[myind].getAttribute("RePrtHeadFlag");
			var picDataParas = xmlPICData[myind].getElementsByTagName("PICdatapara");
			for (var j=0;j<picDataParas.length;j++){
				var item = picDataParas[j]
				var pname = item.getAttribute("name");	
				var pleft = item.getAttribute("xcol");	
				var ptop = item.getAttribute("yrow");	
				var pheight = item.getAttribute("height");
				var pwidth = item.getAttribute("width");
				var pdval = item.getAttribute("defaultvalue");	
				var ppval = item.getAttribute("printvalue");	
				var pfbold = item.getAttribute("fontbold");	//false
				var pfname = item.getAttribute("fontname");
				var pfsize = item.getAttribute("fontsize");
				var pval = inparaObj[pname]||pdval;
				if (null == pheight){
					pheight = 20
				}
				if (null==pwidth){
					pwidth = 20
				}
				LODOP_PrintItem(LODOP,{type:"img", value:pval, x:pleft, y:ptop, width: pwidth, height:pheight, fname:pfname, fbold:pfbold, fsize:pfsize, rePrtHeadFlag:xmlPICDataRePrtHeadFlag});
			}
		}
	}
}
function LODOP_CreateTxt(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	// inpara拆成对象
	var c2 = String.fromCharCode(2);
	var inparaArr = inpara.split('^');
	var inparaObj = {};
	for(var i=0; i<inparaArr.length; i++){
		var arr = inparaArr[i].split(c2);
		inparaObj[arr[0]] = arr[1];
	}
	var invAttr = invXMLDoc.attributes;
	var invOrient = "X";
	if (invAttr.getNamedItem("LandscapeOrientation")){ //老版设计器,默认情况下没有此属性
		invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=纵向,Y=横向,Z=即打即停
	}
	var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData");
	if (xmlTxtData && xmlTxtData.length>0){
		for(var myInd =0; myInd<xmlTxtData.length; myInd++){
			var xmlTxtDataRePrtHeadFlag = xmlTxtData[myInd].getAttribute("RePrtHeadFlag");
			var txtDataParas = xmlTxtData[myInd].getElementsByTagName("txtdatapara");
			for (var j=0;j<txtDataParas.length;j++){
				var itm = txtDataParas[j]
				var pname = itm.getAttribute("name");	
				var pleft = itm.getAttribute("xcol");	
				var ptop = itm.getAttribute("yrow");	
				var pdval = itm.getAttribute("defaultvalue");	
				var ppval = itm.getAttribute("printvalue");	
				var pfbold = itm.getAttribute("fontbold");	//false
				var pfname = itm.getAttribute("fontname");
				var pfsize = itm.getAttribute("fontsize");
				var pcolor = itm.getAttribute("fontcolor");
				var pisqrcode = itm.getAttribute("isqrcode");
				var pbarcodetype = itm.getAttribute("barcodetype");
				var pqrcodeversion = itm.getAttribute("qrcodeversion");
				var pval = inparaObj[pname]||pdval;
				var pangle = itm.getAttribute("angle");
				var isshowtext = itm.getAttribute("isshowtext");
				var pheight = "800";
				if (invOrient=="Z"){pheight="30";}
				var pwidth = "800";
				try{
					//=null
					if (itm.getAttribute("height")>0) pheight = itm.getAttribute("height");
					if (itm.getAttribute("width")>0) pwidth = itm.getAttribute("width");
				}catch(e){}
				//LODOP.SET_PRINT_STYLEA(0,"AngleOfPageInside",90) //angle
				var printItem = {type:'text',y:ptop, x:pleft, width:pwidth, height:pheight, value:pval, angle:pangle, rePrtHeadFlag:xmlTxtDataRePrtHeadFlag,fcolor:pcolor};
				if (pisqrcode=="true"){
					if (pval!=""){
						printItem.isqrcode = pisqrcode;
						printItem.qrcodeversion = pqrcodeversion;
						LODOP_PrintItem(LODOP, printItem);
					}
				}else if (("undefined"!=typeof pbarcodetype) &&( pbarcodetype!=null)){
					if (pval!=""){
						printItem.barcodetype = pbarcodetype;
						printItem.isshowtext = isshowtext;
						LODOP_PrintItem(LODOP,printItem);
					}					
				}else{
					//console.log(pleft+"mm"+","+ptop+"mm"+",pfbold="+pfbold+",80cm"+","+"5mm"+","+pval);
					printItem.LetterSpacing = otherCfg.LetterSpacing;
					printItem.fsize = pfsize;
					printItem.fname = pfname;
					printItem.fbold = pfbold;
					printItem.isshowtext = isshowtext;
					if (itm.getAttribute("width")>0) {
						// 自定义了宽度的时候，根据宽度拆分元素。
						var printItemList = splitTextByWidth(printItem);
						for (var plt = 0; plt < printItemList.length; plt++) {
							LODOP_PrintItem(LODOP,printItemList[plt]);
						}			
					} else {
						LODOP_PrintItem(LODOP,printItem);
					}
					// LODOP_PrintItem(LODOP,printItem);
				}
			}
		}
	}
}
function LODOP_CreateList(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	if(otherCfg && otherCfg.listHtmlTableWordWrapFlag) {
		// 临时特别处理一下换行的 下面的代码有改动的，一定记得在这里同步修改。
		CreateListHtmlWithWordWrapTemp(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg);
		return;
	}
	var c2 = String.fromCharCode(2);
	var xmlListData = invXMLDoc.getElementsByTagName("ListData");
	if (xmlListData && xmlListData.length>0){
		var xmlYStep = xmlListData[0].getAttribute("YStep");
		var xmlPageRows = xmlListData[0].getAttribute("PageRows");
		var xmlBackSlashWidth = xmlListData[0].getAttribute("BackSlashWidth");
		var rowHeight = xmlYStep;
		var tableOneHeight = parseInt(rowHeight*xmlPageRows); //一页表格高度
		// PrintType="List" YStep="4.762" XStep="0" CurrentRow="1" PageRows="20" RePrtHeadFlag="Y" BackSlashWidth="150"
		var tableTop = 0,tableLeft=0, colsArr=[];
		var Listdataparas = xmlListData[0].getElementsByTagName("Listdatapara");
		for(var j=0;j<Listdataparas.length;j++){
			var itm = Listdataparas[j];
			var pname = itm.getAttribute("name");	
			var pleft = itm.getAttribute("xcol");	
			var ptop = itm.getAttribute("yrow");	
			var pdval = itm.getAttribute("defaultvalue");	
			var ppval = itm.getAttribute("printvalue");	
			var pfbold = itm.getAttribute("fontbold");	//false
			var pfname = itm.getAttribute("fontname");
			var pfsize = itm.getAttribute("fontsize");
			var pwidth = itm.getAttribute("width");
			var pheight = itm.getAttribute("height");			
			var coltype = itm.getAttribute("coltype");
			if(j==0){tableTop=ptop;tableLeft=pleft;}
			colsArr.push({left:pleft,fbold:pfbold,fsize:pfsize,fname:pfname,width:pwidth,height:pheight,coltype:coltype});
		}
		colsArr.sort(function(a,b){return a.left-b.left});
		for(var j=0;j<colsArr.length-1;j++){
			colsArr[j].width = colsArr[j+1].left - colsArr[j].left;
		}
		//inlist拆分
		var inlistArr = inlist.split(c2);
		var inlistDataArr = [],tableStr="",inlistArrValidCount=0;
		for(var i=0; i<inlistArr.length; i++){
			if(inlistArr[i]!=""){
				var tr='<tr>';
				var arr = inlistArr[i].split("^");
				for(var j=0;j<arr.length;j++){
					if (colsArr.length>j){
						tr += '<td style="';
						if (colsArr[j]["width"]){
							tr+="width:"+(colsArr[j]["width"]/0.68*1).toFixed(1)+"mm;";
						}
						if (colsArr[j]["height"]){
							tr+=" height:"+(colsArr[j]["height"]/0.68*1).toFixed(1)+"mm; ";
						}
						
						if (colsArr[j]["fname"]!=""){tr+="font-family:'"+colsArr[j]["fname"]+"';";}
						if (colsArr[j]["fsize"]){tr+="font-size:"+(colsArr[j]["fsize"]/0.68).toFixed(1)+"pt;";}
						if (colsArr[j]["fbold"]=="true"){tr+='font-weight:700;';}
						if (colsArr[j].coltype == "img") {
							tr += '" >';
							var value = arr[j];
							if (value.indexOf("http:")==0 || value.indexOf("data:")==0){
                                value = "<img border='0' style='" +  
								"width:" + (colsArr[j]["width"]/0.68*1).toFixed(1)+"mm; " +
								"height:" + (colsArr[j]["height"]/0.68*1).toFixed(1)+"mm; '" +
								"src='" + value + "'/>"; //"URL:"+pval;--导致浏览器崩溃                                
							}
							tr += value + '</td>';
						} else {
							tr += '" >'+arr[j]+'</td>'
						}						
					}else{
						tr+='<td>'+arr[j]+"</td>";
					}
				}
				if (colsArr.length>arr.length){ //如果xml定义中多出列加上空内容列,解决最后一列宽度问题
					tr+='<td></td>';
				}
				tr+="</tr>";
				tableStr += tr;
				inlistArrValidCount++;
				if (((inlistArrValidCount%xmlPageRows)==0) || i==(inlistArr.length-1)) {
					var tableString = listHtmlTableSettings(tableStr, otherCfg);
					if(otherCfg && otherCfg.rightMarginNum) {
						// RightMargin 产品组反馈，定义右边距，可以自动调整列宽，均匀分布列。
						LODOP.ADD_PRINT_TABLE(tableTop+"mm",tableLeft+"mm", "RightMargin:" + otherCfg.rightMarginNum + "mm", tableOneHeight+"mm", tableString);
					} else {
						LODOP.ADD_PRINT_TABLE(tableTop+"mm",tableLeft+"mm","2000mm",tableOneHeight+"mm", tableString);	
					}
					if (i!=(inlistArr.length-1)) {LODOP.NEWPAGE();}
					
					tableStr="";
				}
			}
		}	
		if (inlistArr.length>0 && xmlBackSlashWidth>0){ // && invOrient!="Z"){
			if ((inlistArrValidCount%xmlPageRows)!=0){ //没打满才打印slash
				var remainRow = inlistArrValidCount%xmlPageRows;
				var slash2Top =  parseInt(tableTop) + (remainRow*rowHeight);
				var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
				var slash1Top = parseInt(tableTop)+parseInt(tableOneHeight);
				var slash1Left = tableLeft ;
				/*
				var tableCount = Math.ceil(inlistArrValidCount / xmlPageRows); //会打印出n张
				var tableTotalMaxHeight = parseInt(tableCount * tableOneHeight); //n张表格的高度
				var tableTotalHeight = parseInt(inlistArrValidCount * rowHeight) ; //打印数据的总高度
				var slash2Top = parseInt(tableTop)+parseInt(tableTotalHeight);  //表格结束处top
				var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
				var slash1Top = parseInt(tableTop)+parseInt(tableTotalMaxHeight);
				var slash1Left = tableLeft ;*/
				
				LODOP.ADD_PRINT_LINE(slash2Top+"mm",slash2Left+"mm",slash1Top+"mm",slash1Left+"mm",0,1); //0=实线,1=线宽
				//var lastTop = parseFloat(LODOP.GET_VALUE("ItemTop",'last')); //只有设计时才能用
				//var lastLeft = parseFloat(LODOP.GET_VALUE("ItemLeft",'last'));
			}
		}
	}
}
/**
*@author : hz
*@date : 2022-3-28
*@param : 临时特别处理一下换行的 下面的代码有改动的，一定记得在上面 同步修改。
*/
function CreateListHtmlWithWordWrapTemp(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	var c2 = String.fromCharCode(2);
	var xmlListData = invXMLDoc.getElementsByTagName("ListData");
	if (xmlListData && xmlListData.length>0){
		var xmlYStep = xmlListData[0].getAttribute("YStep");
		var xmlPageRows = xmlListData[0].getAttribute("PageRows");
		var xmlBackSlashWidth = xmlListData[0].getAttribute("BackSlashWidth");
		var rowHeight = xmlYStep;
		var tableOneHeight = parseInt(rowHeight*xmlPageRows); //一页表格高度
		// PrintType="List" YStep="4.762" XStep="0" CurrentRow="1" PageRows="20" RePrtHeadFlag="Y" BackSlashWidth="150"
		var tableTop = 0,tableLeft=0, colsArr=[];
		var Listdataparas = xmlListData[0].getElementsByTagName("Listdatapara");
		for(var j=0;j<Listdataparas.length;j++){
			var itm = Listdataparas[j];
			var pname = itm.getAttribute("name");	
			var pleft = itm.getAttribute("xcol");	
			var ptop = itm.getAttribute("yrow");	
			var pdval = itm.getAttribute("defaultvalue");	
			var ppval = itm.getAttribute("printvalue");	
			var pfbold = itm.getAttribute("fontbold");	//false
			var pfname = itm.getAttribute("fontname");
			var pfsize = itm.getAttribute("fontsize");
			var pwidth = itm.getAttribute("width");
			var pheight = itm.getAttribute("height");			
			var coltype = itm.getAttribute("coltype");
			if(j==0){tableTop=ptop;tableLeft=pleft;}
			colsArr.push({left:pleft,fbold:pfbold,fsize:pfsize,fname:pfname,width:pwidth,height:pheight,coltype:coltype});
		}
		colsArr.sort(function(a,b){return a.left-b.left});
		for(var j=0;j<colsArr.length-1;j++){
			colsArr[j].width = colsArr[j+1].left - colsArr[j].left;
		}
		//inlist拆分
		var inlistArr = inlist.split(c2);
		var inlistDataArr = [],tableStr="",inlistArrValidCount=0;
		for(var i=0; i<inlistArr.length; i++){
			if(inlistArr[i]!=""){
				var tr='<tr>';
				var arr = inlistArr[i].split("^");
				for(var j=0;j<arr.length;j++){
					if (colsArr.length>j){
						tr += '<td style="';
						if (colsArr[j]["width"]){
							tr+="width:"+(colsArr[j]["width"]/0.68*1).toFixed(1)+"mm;";
						}
						if (colsArr[j]["height"]){
							tr+=" height:"+(colsArr[j]["height"]/0.68*1).toFixed(1)+"mm; ";
						}
						tr+="word-break:break-all;";
						if (colsArr[j]["fname"]!=""){tr+="font-family:'"+colsArr[j]["fname"]+"';";}
						if (colsArr[j]["fsize"]){tr+="font-size:"+(colsArr[j]["fsize"]/0.68).toFixed(1)+"pt;";}
						if (colsArr[j]["fbold"]=="true"){tr+='font-weight:700;';}
						if (colsArr[j].coltype == "img") {
							tr += '" >';
							var value = arr[j];
							if (value.indexOf("http:")==0 || value.indexOf("data:")==0){
								value = "<img border='0' style='" +  
								"width:" + (colsArr[j]["width"]/0.68*1).toFixed(1)+"mm; " +
								"height:" + (colsArr[j]["height"]/0.68*1).toFixed(1)+"mm; '" +
								"src='" + value + "'/>"; //"URL:"+pval;--导致浏览器崩溃
							}
							tr += value + '</td>';
						} else {
							tr += '" >'+arr[j]+'</td>'
						}						
					}else{
						tr+='<td>'+arr[j]+"</td>";
					}
				}
				if (colsArr.length>arr.length){ //如果xml定义中多出列加上空内容列,解决最后一列宽度问题
					tr+='<td></td>';
				}
				tr+="</tr>";
				tableStr += tr;
				inlistArrValidCount++;
				if (i==(inlistArr.length-1)) {
					var tableString = listHtmlTableSettings(tableStr, otherCfg);
					if(otherCfg && otherCfg.rightMarginNum) {
						// RightMargin 产品组反馈，定义右边距，可以自动调整列宽，均匀分布。
						LODOP.ADD_PRINT_TABLE(tableTop+"mm",tableLeft+"mm", "RightMargin:" + otherCfg.rightMarginNum + "mm", tableOneHeight+"mm", tableString);
					} else {
						LODOP.ADD_PRINT_TABLE(tableTop+"mm",tableLeft+"mm","2000mm",tableOneHeight+"mm", tableString);	
					}
					tableStr="";
				}
			}
		}		
	}
}

function listHtmlTableSettings(tableStr, otherCfg) {
	var rtn = "<table  padding='0' margin='0' ";
	if(otherCfg && otherCfg.listHtmlTableWordWrapFlag) 
		rtn += " table-layout='fixed' ";
	if(otherCfg && otherCfg.listHtmlTableBorder) {
		var tableBorder = parseInt(otherCfg.listHtmlTableBorder);
	} else {
		var tableBorder = 0;
	}
	var tableCellPadding=0
	if(otherCfg && otherCfg.tableCellPadding) {
		tableCellPadding = parseInt(otherCfg.tableCellPadding);
	} 
	if(tableCellPadding>0)  {rtn += " cellpadding='"+tableCellPadding+"' "}
	else {rtn += " cellpadding='0' "}
	if(tableBorder > 0) rtn += " border='" + tableBorder +"' " + "style='border-collapse:collapse;'";
	// border-collapse 用于表格属性, 表示表格的两边框合并为一条。
	rtn += ">" + tableStr + "</table>"
	return rtn;
}

// link只从json中取
function LODOP_CreateLink(LODOP,inv,inpara,inlist,jsonArr){
	// jsonArr!="" jsonArr为xmlObj时,在IE6下会报"对象不支持此属性或方法",修改成jsonArr!==""即可,业务调用时把xmlObj传到jsonAr中了
	if (arguments.length>4 && jsonArr!==null&& jsonArr!=="" && "undefined"!==typeof jsonArr){
		for(var j = 0; j < jsonArr.length; j++){
		    var item = jsonArr[j];
			if(item["type"]){
				if (item["type"].toLowerCase()=="linkedqrcode"){
					LODOP.ADD_PRINT_BARCODE(item['y']+"mm",item['x']+"mm",item['width']+"mm",item['height']+"mm","QRCode",item['value']);
					LODOP.SET_PRINT_STYLEA(0,"LinkedItem",item['linkedItem']); 
				}else if (item["type"].toLowerCase()=="linkedtext"){
					LODOP.ADD_PRINT_TEXT(item['y']+"mm",item['x']+"mm",item['width']+"mm",item['height']+"mm",item['value']);
					LODOP.SET_PRINT_STYLEA(0,"LinkedItem",item['linkedItem']); 
				}		
			}
		}		
	}
}
/*大小与方向*/
function LODOP_CreateInv(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	var rtn = {notFindPrtDevice:false};
	var invAttr = invXMLDoc.attributes;
	var invHeight = invAttr.getNamedItem("height").value;
	var invWidth = invAttr.getNamedItem("width").value;
	var invOrient = "X"; 
	if (invAttr.getNamedItem("LandscapeOrientation")){ //老版设计器,默认情况下没有此属性
		invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=纵向,Y=横向
	}
	//var invPrtDirect = invAttr.getNamedItem("PrtDirection").value; //Y----无效
	var invPrtPaperSet = invAttr.getNamedItem("PrtPaperSet").value; //WIN
	var invPrtDevice = invAttr.getNamedItem("PrtDevice").value; //xps
	if ("undefined"!=typeof otherCfg && "string"==typeof otherCfg.PrtDevice){
		invPrtDevice = otherCfg.PrtDevice;
	}
	var invPrtPage = invAttr.getNamedItem("PrtPage").value; //A5
	//var invPrtDesc = invAttr.getNamedItem("PaperDesc").value; //----无效
	// 2021-05-20 header ,footer
	//var invPageHeader = invAttr.getNamedItem("PageHeader").value;
	var invPageFooterVal = "",invNotFindPrtDeviceVal="",invDuplexVal="";
	var invPageFooter = invAttr.getNamedItem("PageFooter");
	if (invPageFooter) invPageFooterVal = invPageFooter.value;
	var invNotFindPrtDevice = invAttr.getNamedItem("NotFindPrtDevice");
	if (invNotFindPrtDevice) invNotFindPrtDeviceVal = invNotFindPrtDevice.value;
	var invDuplex = invAttr.getNamedItem("Duplex");
	if (invDuplex) invDuplexVal = invDuplex.value;	
	
	var intOrient=1 ;//默认1=纵向
	if (invOrient=="Y") intOrient=2;
	else if(invOrient=="X") intOrient=1;
	else if(invOrient=="Z"){intOrient=3;/*按内容高度算*/}
	if (invPrtPaperSet=="HAND"){
		var lodopPageWidth = invWidth*10+"mm"
		var lodopPageHeight = invHeight*10+"mm";
		var lodopPageName = "";	
	}else{
		var lodopPageWidth = 0 //表示无效
		var lodopPageHeight = 0;
		var lodopPageName = invPrtPage;
	}
	if (invPageFooterVal!=""){
		var positionValues = [invPageFooterVal,"92mm","8mm","40mm","10mm"] ;
		if (invPageFooterVal.indexOf('$')>-1) positionValues = invPageFooterVal.split("$");
		if (invPageFooterVal.indexOf('^')>-1) positionValues = invPageFooterVal.split("^");
		LODOP.ADD_PRINT_TEXT(positionValues[1],positionValues[2],positionValues[3],positionValues[4],positionValues[0]);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
		if (invPageFooterVal.indexOf('$')==-1 && invPageFooterVal.indexOf('^')==-1) {
			LODOP.SET_PRINT_STYLEA(0,"Horient",2);//0-左边距锁定 1-右边距锁定 2-水平方向居中 3-左边距和右边距同时锁定-中间拉伸
			LODOP.SET_PRINT_STYLEA(0,"Vorient",1);//0-上边距锁定 1-下边距锁定 2-垂直方向居中 3-上边距和下边距同时锁定-中间拉伸
		}
	}
	if (invDuplexVal!=""){
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX",invDuplexVal);
	}
	//alert(intOrient+","+lodopPageWidth+","+lodopPageHeight+","+lodopPageName);
	LODOP.SET_PRINT_PAGESIZE(intOrient,lodopPageWidth,lodopPageHeight,lodopPageName);
	//LODOP.SET_PRINT_PAGESIZE(3,1385,45,""); //这里3表示纵向打印且纸高“按内容的高度”；1385表示纸宽138.5mm；45表示页底空白4.5mm
	// 先精准查询，优先
	var myPrtDeviceIndex = -1;
	if (invPrtDevice!=""){
		for(var i=0;i< LODOP.GET_PRINTER_COUNT(); i++){
			if (LODOP.GET_PRINTER_NAME(i) == invPrtDevice){ 
				myPrtDeviceIndex = i;
				break;
			}
		}
	}
	if (myPrtDeviceIndex == -1 && invPrtDevice!=""){
		invPrtDevice = invPrtDevice.toUpperCase();
		for(var i=0;i< LODOP.GET_PRINTER_COUNT(); i++){
			if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(invPrtDevice)>-1){ 
				myPrtDeviceIndex = i;
				break;
			}
		}
	}
	if (myPrtDeviceIndex==-1 && invNotFindPrtDeviceVal=="SELF"){
		//LODOP.SELECT_PRINTER(false);
		rtn.notFindPrtDevice = true;
	}else{
		LODOP.SET_PRINTER_INDEX(myPrtDeviceIndex);
	}
	return rtn;
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
function DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg){
	var rtn = {};
	otherCfg=otherCfg||{};
	if ((LODOP==null)||(typeof(LODOP.VERSION)=="undefined" && ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb))){ //("undefined"==typeof isIECore || isIECore))){
		return -404 ;
	}
	//try{
		if (arguments.length>4 && jsonArr!==null&& jsonArr!=="" && "undefined"!==typeof jsonArr){
			mystr = addJsonArrModel(mystr,jsonArr);
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		//一个xml模板多次打印但希望在同一次任务中,多次调用当前方法 2018-10-31 
		if ("undefined"!=typeof reportNote){
			if (LODOP.strHostURI){  //LODOP.webskt
				if (LODOP.ItemDatas.count==0){
					//LODOP.PRINT_INIT(reportNote); //一次任务,不用多次init。
					LODOP.PRINT_INITA(0,0,"100mm","100mm",reportNote); //2021-05-20 默认纸张与边距，后面重设置，为了实现底部眉脚
				}
			}else if(LODOP.GET_VALUE("ItemCount",1)==0) {
				//LODOP.PRINT_INIT(reportNote); //一次任务,不用多次init。
				LODOP.PRINT_INITA(0,0,"100mm","100mm",reportNote); //2021-05-20
			}
		}
		
		/*var docobj= CreateXMLDOM();
		//docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);*/
		var docobj=DHC_parseXml(mystr);
		if (docobj){
			if (docobj.parsed){
				//LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);    //宽度溢出缩放
				LODOP.SET_LICENSES('\u4E1C\u534E\u533B\u4E3A\u79D1\u6280\u6709\u9650\u516C\u53F8',"4EF6E3D5AB0D478F5A07D05CDDDE2365","\u6771\u83EF\u91AB\u70BA\u79D1\u6280\u6709\u9650\u516C\u53F8","7C4A2B70D17D01CCD5CB2A3A6B4D3200");
	        	LODOP.SET_LICENSES("THIRD LICENSE","","DHC Medical Science & Technology Co., Ltd.","604523CF08513643CB90BACED8EFF303");
				var inv = docobj.documentElement.childNodes[0];
				var createInvRtn = {};
				if (LODOP.strHostURI){  //LODOP.webskt
					if (LODOP.ItemDatas.count==0){
						createInvRtn = LODOP_CreateInv(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
					}
				}else if(LODOP.GET_VALUE("ItemCount",1)==0) {
					createInvRtn = LODOP_CreateInv(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				}
				rtn.notFindPrtDevice = createInvRtn.notFindPrtDevice;
				//lodop推荐再打印图片
				LODOP_CreateImg(LODOP,inv,inpara,inlist,jsonArr,otherCfg);

				// 一次任务,纸张不会多种 //CLodop返回有值 20200319去掉判断
				// if (LODOP.GET_VALUE("ItemCount",1)==0) LODOP_CreateInv(LODOP,inv);
				//lodop推荐先打印线
				LODOP_CreateLine(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				
				//lodop打印文本
				LODOP_CreateTxt(LODOP,inv,inpara,inlist,jsonArr,otherCfg);

				//lodop打印列表
				if (otherCfg.printListByText==true){
					LODOP_CreateListByText(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				}else{
					LODOP_CreateList(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				}
				
				//LODOP.ADD_PRINT_TEXT(15,200,200,25,"制表人:guest");
				//LODOP.SET_PRINT_STYLEA(0,"LinkedItem-1); 		",-1); 
				LODOP_CreateLink(LODOP,inv,inpara,inlist,jsonArr);
			}
		}
	/*}catch(e){
		alert(e.message);
		return;
	}*/
	return rtn;
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
function DHC_parseXml(strXml){
	if (!strXml) return null;
	if (!!window.ActiveXObject || "ActiveXObject" in window){
		var docobj= CreateXMLDOM();
		//docobj.async = false;    //
		var rtn=docobj.loadXML(strXml);
		if (rtn) return docobj;
	}else{  //Chrome 
		var parser=new DOMParser();
		var docobj=parser.parseFromString(strXml,"text/xml");
		DHC_removeTextNode(docobj);
		docobj.parsed=true;  //后面有判断docobj.parsed  强行赋值
		return docobj;
	}
	return null;
}
function DHC_CreateByXMLName(LODOP,XMLName,inpara,inlist,jsonArr,otherCfg){
	//var mystr = tkMakeServerCall("web.DHCXMLPConfig","ReadXmlByName",XMLName);
	//DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,XMLName);
}
function DHC_CreateByXML(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg){
	var mystr="";
	for (var i= 0; i<PrtAryData.length;i++){
		mystr=mystr + PrtAryData[i];
	}
	if(otherCfg && otherCfg.PFlag) {
		var PFlagXmlStr = tkMakeServerCall("web.DHCXMLPConfig", "ReadXmlStrByName", otherCfg.PFlag);
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XML模板名称错误，找不到模板！
		PFlagXmlStr = DHCP_TextEncoder(PFlagXmlStr);
		mystr = PFlagXmlStr;
	}
	return DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg);
}
/*
入参见DHC_CreateByXML方法
@return 
成功 返回打印内容保存图片后对应的BASE64字符串
失败 返回""
*/
function DHC_GetBase64ByLodop(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg){
	var mystr="";
	for (var i= 0; i<PrtAryData.length;i++){
		mystr=mystr + PrtAryData[i];
	}	
	if(otherCfg && otherCfg.PFlag) {
		var PFlagXmlStr = tkMakeServerCall("web.DHCXMLPConfig", "ReadXmlStrByName", otherCfg.PFlag);
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XML模板名称错误，找不到模板！
		PFlagXmlStr = DHCP_TextEncoder(PFlagXmlStr);
		mystr = PFlagXmlStr;
	}
	return DHC_GetBase64ByLodopByStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg);
}
/* myxmlstr-->base64 */
function DHC_GetBase64ByLodopByStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg){
	if ((LODOP==null)||(typeof(LODOP.VERSION)=="undefined" && ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb))){
		return -404 ;
	}
	LODOP.PRINT_INIT(""); //清除上次打印元素
	DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg);
	LODOP.SET_SAVE_MODE("FILE_PROMPT","0");
	LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".png");
	LODOP.SET_SAVE_MODE("RETURN_FILE_NAME","1");
	var diskName = "D"; //LODOP.GET_SYSTEM_INFO("DiskDrive.1.Label"); //有电脑取的是1121i221_12
	if (LODOP.SAVE_TO_FILE(diskName+":\dhclodop.png")){
		return LODOP.FORMAT("FILE:EncodeBase64",diskName+":\dhclodop.png");
	}else{
		alert("\u4FDD\u5B58\u6253\u5370\u56FE\u7247\u5931\u8D25!");
		return "";
	}
	//LODOP.FORMAT("FILE:WAVE,c:/lodoptest.wav","Hello,您好！")
	return ;
}

/**
*@author : wanghc 

*@param : {DLLObject} LODOP 
*		   expample: var LODOP = getLodop();

*@param : {String}   inpara 
*          expample: name_$c(2)_zhangsha^patno_$c(2)_000009
*
*@param : {String}   inlist 
*         expample: DrugName^Price^DrugUnit^Qty^PaySum_$c(1)_img_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
*
*@param : {Object} jsonArr
*         expample: [
					{type:"invoice",PrtDevice:"pdfprinter"},
					{type:"line",sx:1,sy:1,ex:100,ey:100},
					{type:"text",name:"patno",value:"1024988919",x:10,y:10,isqrcode:true,lineHeigth:5},
					{type:"text",name:"invno",value:"1024988919",x:140,y:12,width:24,height:11,barcodetype:"128C"}
					]
*        <text>=>name,value,x,y is require
*@param : {String}  reportNote     print task name,  example: PrintText
*
*@param : {Object}  otherCfg  
          example: {LetterSpacing:-2,printListByText:false,tdnowrap:true, preview:0,PrtDevice:'强制打印机名称',onPrintEnd:myPrintEnd,onCreatePDFBase64:mypdfBase64,pdfPath:'C:\\imedical\\xmlprint\\'}
		  listHtmlTableWordWrapFlag:true; 打印 list 使用HTML打印的时候，文字自动根据宽度换行。宽度由两列的X坐标差决定。
		  listHtmlTableBorder:1; 打印 list 使用HTML打印的时候，table的border大小。是否有边框。
		  tdnowrap:true ---> not break line 
		  pdfDownload:false 
		  onCreatePDFBase64:undefined
		  PFlag:"打印模板的ID" // 1、可以不调用加载模板的方法了。2、一次打印多个模板的时候，避免模板覆盖，必须送这个，避免风险。
		  rightMarginNum:打印区域相对于纸张的右边距,已毫米为单位，请送数字，不带单位的。产品组反馈，定义右边距，可以自动调整列宽，均匀分布列。
		  tableBorderColumnArr:[1,2,3] // 从左往右数，第 1、2、3 列的左侧需要打印竖线。索引是从1开始的，不是0开始的。tableBorderColumnArr:[0] 不打印任何竖线。前提：printListByText:true的时候。
		  tableBorderRowFlag:true|false // 表格打印边框的横线，只有送 tableBorderColumnArr printListByText:true的时候。
		  tableHeader:true|false // 是否每页的第一行打印表格头（表格头是模板中定义的列的元素名）
		  pageTableStartPostion:// 打印表格数据换页的时候，第二页列表的起始位置yrow默认是与第一页打印的相同。如果想不同，送此入参，换页时列表的起始位置yrow值，单位mm，不要送单位。比如，第二页想从纸张顶格开始打印。
		  DHC_PrintByLodop("","","",[],"YKYZLYYPrescriptPrint",{onCreatePDFBase64:function(b){console.log(b);}});
*
*/
function DHC_PrintByLodopB(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg){
	
	if (otherCfg &&"function"==typeof window.addEventListener && "function"==typeof otherCfg.onCreatePDFBase64){
		var mypre = window.open('dhctt.xmlpreview.c.csp',"_blank","width=50,height=50,left=0,top="+(screen.availHeight-10)+",titlebar=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
		var initPreview = function(times){
			if (times<0) return ;
			var initPreviewTimer = setTimeout(function(){
				times--;
				if (mypre.init){
					 mypre.init(inpara,inlist,[],reportNote,otherCfg);
					 clearTimeout(initPreviewTimer);
				}else{
					
					initPreview(times);
				}
			},200);
		};
		initPreview(100);
		return ;
	}

	var rtn = "";
	if ((LODOP==null)||(typeof(LODOP.VERSION)=="undefined" &&("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb))){
		return -404;
	}
	otherCfg = otherCfg||{};
	otherCfg.pdfPath = otherCfg.pdfPath ||"C:\\imedical\\xmlprint\\";
	/* 打印完后,不刷新界面再打印时，走打印机不对---add 2018-12-11*/
	LODOP.PRINT_INIT(""); /*清除上次打印元素*/
	var createByXMLRtn = DHC_CreateByXML(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg);
	
	if ("undefined"!=typeof otherCfg.preview && 1==otherCfg.preview) {
		LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED",true);
		rtn = LODOP.PREVIEW();
	}else{
		if ("object"==typeof createByXMLRtn && createByXMLRtn.notFindPrtDevice){
			rtn = LODOP.PRINTA();
		}else{
			rtn = LODOP.PRINT();
		}
		if (LODOP.strHostURI){
			if ("function"==typeof otherCfg.onCreatePDFBase64){
				LODOP.On_Return=(function(n,o){
					var _n = n, _o=o;
					return function(t,v){
						if (v==true){
							setTimeout (function(){
								LODOP.FORMAT("FILE:EncodeBase64",_o.pdfPath+_n+".pdf");
								LODOP.On_Return=function(pdfTaskId,pdfBase64){
									_o.onCreatePDFBase64.call(this,pdfBase64);
								}
							},1000);
						}
					}
				})(reportNote,otherCfg);
			}else if ("function"==typeof otherCfg.onPrintEnd){
				LODOP.On_Return=function(TaskID,Value){otherCfg.onPrintEnd(Value);};
			}
		}else{
			var onCreatePDFBase64Fun = function(t){
				clearTimeout(t); //"打印成功！";
				LODOPWaitForCount = 0;
				var iePdfBase64 = LODOP.FORMAT("FILE:EncodeBase64",otherCfg.pdfPath+reportNote+".pdf");
				otherCfg.onCreatePDFBase64.call(this,iePdfBase64);
			}
			var printWaitFor = function (P_ID,cb){
				LODOPWaitForCount = LODOPWaitForCount+1;
				window.LODOPWaitForTimer = setTimeout(function(){printWaitFor(P_ID,cb)},500);    
				if (LODOP.GET_VALUE("PRINT_STATUS_OK",P_ID)) {
					cb.call(this,LODOPWaitForTimer);
				}
				if ((!LODOP.GET_VALUE("PRINT_STATUS_EXIST",P_ID))&&(LODOPWaitForCount>0)) {
					cb.call(this,LODOPWaitForTimer);
				} else if (LODOPWaitForCount>30){
					clearTimeout(LODOPWaitForTimer); // "打印超过30秒没捕获到成功状态！";
					LODOPWaitForCount=0;
				};
			}
			if ("function"==typeof otherCfg.onCreatePDFBase64){
				window.LODOPWaitForCount = 0;
				printWaitFor(rtn,onCreatePDFBase64Fun);
			}else if ("function"==typeof otherCfg.onPrintEnd){
				otherCfg.onPrintEnd.call(this,rtn);
			}
		}
	}
	return rtn;
}
/**
通过打印机名获得打印机索引,查询是包含查找
@param : {String} 打印机名称
@return : {Int} 打印机索引,从0开始。如果未找到返回-1
*/
function GetPrintIndexByLodop(LODOP,printName){
	printName = printName.toUpperCase();
	for(var i=0;i<LODOP.GET_PRINTER_COUNT(); i++){
		if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(printName)>-1){ 
			return i;
		}
	}
	return -1
}
/**
* @param {String}    Printer Name 
* @param {Integer}   0 = upChannel = woman Barcode , 1 = downChannel = man Barcode
* BOS demand no 2563906
*/
function BPLPrinterModifyChannel(printerName , channelFlag){
	// 
	var str = 'var printerM= new ActiveXObject("BPLPrinter.BBPrinterM");'
	+'var newPrinter = printerM.GetUHFPrinter("'+printerName+'");'
	+'newPrinter.modifyChannel('+channelFlag+');'
	+'newPrinter.SubmitCommand();'
	+'newPrinter.Release();'
	CmdShell.EvalJs(str,function(){
		
	});
}

/**
 * 入参查看 DHC_PrintByLodopB
 * 标准版bug，HTTPS的图片没有证书无法打印出来，转为base64的图片打印 20220427 huangzhi
 * @param {} LODOP 
 * @param {*} inpara 
 * @param {*} inlist 
 * @param {*} jsonArr 
 * @param {*} reportNote 
 * @param {*} otherCfg 
 */
 function DHC_PrintByLodop(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg) {
    var pictureArr = getHttpsPicture(inpara, jsonArr, otherCfg);
    if (pictureArr.length > 0) {
        var returnFun = function(base64Arr) {
            inpara = setInpara(inpara, pictureArr, base64Arr);
            DHC_PrintByLodopB(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
        }
		var pictureDataObj = {};
		for (var i = 0; i < pictureArr.length; i++) {
			var c2 = String.fromCharCode(2);
			var url = pictureArr[i].split(c2)[1];
            pictureDataObj[url] = 1; // 可以去重复URL
        }
		var pictureDataArr = [];
		for (var url in pictureDataObj) {
			pictureDataArr.push(url);
		}
        urlsToBase64Data(pictureDataArr, returnFun);
    } else {
        DHC_PrintByLodopB(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
    }
}
/**
 * 根据链接转为base64的字符串
 * @param {http链接 数组} url 
 * @param {转为base64的字符串后的回调函数，入参为 base64Arr {} 对象} callback
 */
function urlsToBase64Data(urlArr, endCallback) {
    var count = 0;
	var base64Arr = {};
    function itemCallback(base64Str, url) {
        count++;
        base64Arr[url] = base64Str;
        if (count == urlArr.length) {
            endCallback.call(this, base64Arr);
        }
    }
    for (var i = 0; i < urlArr.length; i++) {
        urlToBase64Data(urlArr[i], itemCallback);
    }
}
/**
 * 根据链接转为base64的字符串
 * @param {http链接} url 
 * @param {转为base64的字符串后的回调函数} callback 
 */
function urlToBase64Data(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onload = function() {
        var reader = new FileReader();
        reader.onloadend = function() {
            callback(reader.result, url);
        }
        reader.readAsDataURL(xhr.response);
    };
    xhr.open('GET', url);
    xhr.responseType = 'blob';
    xhr.send();
}
/**
 * 获取https的图片路径的数组
 * @param {变量入参} inpara 
 * @param {额外元素} jsonArr 
 * @returns https的图片路径的数组
 */
function getHttpsPicture(inpara, jsonArr, otherCfg) {
    var pictureArr = [];
    var invXMLDoc = getInvXmlModel(jsonArr, otherCfg);
    var inparaObj = handelInParam(inpara);
	if (invXMLDoc){ // XML模板名写错时会报错
		var xmlPICData = invXMLDoc.getElementsByTagName("PICData");
		if (xmlPICData && xmlPICData.length > 0) {
			for (var myind = 0; myind < xmlPICData.length; myind++) {
				var xmlPICDataRePrtHeadFlag = xmlPICData[myind].getAttribute("RePrtHeadFlag");
				var picDataParas = xmlPICData[myind].getElementsByTagName("PICdatapara");
				for (var j = 0; j < picDataParas.length; j++) {
					var item = picDataParas[j];
					var pname = item.getAttribute("name");
					var pdval = item.getAttribute("defaultvalue");
					var pval = inparaObj[pname] || pdval;
					if (pval.indexOf("https") != -1) {
						var c2 = String.fromCharCode(2);
						pictureArr.push(pname + c2 + pval);
					}
				}
			}
		}
	}
    return pictureArr;
}

function getInvXmlModel(jsonArr, otherCfg) {
    var mystr = "";
	if(otherCfg && otherCfg.PFlag) {
		var PFlagXmlStr = tkMakeServerCall("web.DHCXMLPConfig", "ReadXmlStrByName", otherCfg.PFlag);
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XML模板名称错误，找不到模板！
		PFlagXmlStr = DHCP_TextEncoder(PFlagXmlStr);
		mystr = PFlagXmlStr;
	} else {
		for (var i = 0; i < PrtAryData.length; i++) {
			mystr = mystr + PrtAryData[i];
		}
	}
    if (jsonArr) mystr = addJsonArrModel(mystr, jsonArr);
    var docObj = DHC_parseXml(mystr);
    if (docObj && docObj.parsed) {
        var inv = docObj.documentElement.childNodes[0];
        return inv;
    } else {
        return "";
    }
}

function addJsonArrModel(mystr, jsonArr) {
	// 模板是空的，全部都是jsonArr进来的，需要添加模板的默认值。
	if (!mystr && !!jsonArr) {
		mystr = '<?xml version="1.0" encoding="gb2312" ?><appsetting><invoice height="27.99" width="19.58" PrtPaperSet="HAND" PrtDevice="" PrtPage="" PaperDesc=""><ListData PrintType="List" YStep="4.497" XStep="0" CurrentRow="1" PageRows="30" RePrtHeadFlag="Y" BackSlashWidth="0"></ListData><PLData RePrtHeadFlag="Y"></PLData><PICData RePrtHeadFlag="N"></PICData><TxtData RePrtHeadFlag="N"></TxtData></invoice></appsetting>';
	}
    if (jsonArr.length > 0 && jsonArr[0].type.toLowerCase() == "invoice") {
        var invObj = jsonArr[0];
        for (var p in invObj) {
            if (p != "type") {
                mystr = mystr.replace(new RegExp(p + '=".*?"', 'mi'),
                function() {
                    return p + "=\"" + invObj[p] + "\"";
                })
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
            if (itemJson.value) {
                var val = evalXMLVal(itemJson["value"]);  /*不能修改itemJson.value的值,会影响原入参jsonArr的值,如果多次调用addJsonArrModel会导致多次转义特殊字符&<*/
            }
            if (itemJson["type"].toLowerCase() == "invoice") {} else if (itemJson["type"].toLowerCase() == "line") {
                exLineXml += '<PLine BeginX="' + itemJson.sx + '" BeginY="' + itemJson.sy + '" EndX="' + itemJson.ex + '" EndY="' + itemJson.ey + '"></PLine>'
            } else if (itemJson["type"].toLowerCase() == "text") {
                if (itemJson["isqrcode"]) {
                    exTextXml += '<txtdatapara name="' + itemJson.name + '" xcol="' + itemJson.x + '" yrow="' + itemJson.y + '" isqrcode="' + itemJson.isqrcode + '" width="' + itemJson.width + '" height="' + itemJson.height + '" fontsize="' + (itemJson.fontsize || 12) + '" fontbold="' + (itemJson.fontbold || "false") + '" fontname="' + (itemJson.fontname || "宋体") + '" defaultvalue="' + (val) + '" printvalue="' + (val) + '" qrcodeversion="' + (itemJson.qrcodeversion || "") + '" ></txtdatapara>'
                } else {
                    exTextXml += '<txtdatapara name="' + itemJson.name + '" xcol="' + itemJson.x + '" yrow="' + itemJson.y + '" '
                    if (itemJson.width > 0) exTextXml += 'width="' + itemJson.width + '" ';
                    if (itemJson.height > 0) exTextXml += 'height="' + itemJson.height + '" ';
                    if (itemJson["barcodetype"]) exTextXml += 'barcodetype="' + itemJson["barcodetype"] + '" ';
                    exTextXml += 'fontsize="' + (itemJson.fontsize || 12) + '" fontbold="' + (itemJson.fontbold || "false") + '" fontname="' + (itemJson.fontname || "宋体") + '" defaultvalue="' + (val) + '" printvalue="' + (val) + '"></txtdatapara>'
                }
            } else if (itemJson["type"].toLowerCase() == "img") {
                exImgXml += '<PICdatapara name="' + itemJson.name + '" xcol="' + itemJson.x + '" yrow="' + itemJson.y + '" width="' + itemJson.width + '" height="' + itemJson.height + '" defaultvalue="' + (val) + '" printvalue="" />'
            }
        }
    }
    //console.log(exLineXml+","+exTextXml);
    var txtDataIndex = mystr.indexOf("</TxtData>");
    mystr = mystr.slice(0, txtDataIndex) + exTextXml + mystr.slice(txtDataIndex);
    var lineDataIndex = mystr.indexOf("</PLData>");
    mystr = mystr.slice(0, lineDataIndex) + exLineXml + mystr.slice(lineDataIndex);
    var imgDataIndex = mystr.indexOf("</PICData>");
    mystr = mystr.slice(0, imgDataIndex) + exImgXml + mystr.slice(imgDataIndex);
    //console.log(mystr);
    return mystr;
}

function handelInParam(itmInfo) {
    var inpara = DHCP_TextEncoder(itmInfo);
    // inpara拆成对象
    var c2 = String.fromCharCode(2);
    var inparaArr = inpara.split('^');
    var inparaObj = {};
    for (var i = 0; i < inparaArr.length; i++) {
        var arr = inparaArr[i].split(c2);
        inparaObj[arr[0]] = arr[1];
    }
    return inparaObj;
}

function setInpara(inpara, pictureArr, base64Arr) {
    var c2 = String.fromCharCode(2);
    var inparaObj = handelInParam(inpara);
    for (var i = 0; i < pictureArr.length; i++) {
        var value = pictureArr[i];
        var key = value.split(c2)[0];
        inparaObj[key] = base64Arr[value.split(c2)[1]];
    }
    var str = "";
    for (var i in inparaObj) {
        str += "^" + i + c2 + inparaObj[i];
    }
    return str.substr(1); // 第一个"^"去掉
}

/*
/// 问题二、原来使用的是 DHC_CreateByXML 方法打印的，图片打印不出来，处理说明：
比如旧代码：
	for (i in printData){
		// .... 逻辑处理
		DHC_CreateByXML(LODOP,myPara,ListInfo,[],"PRINT-CST-NT",{printListByText:true});  //MyPara 为xml打印要求的格式 /y 2021-06-04 add {printListByText:true} 是list支持base64的必须参数，因为封装里没默认上
		LODOP.NEWPAGE();
	}
	var printRet = LODOP.PRINT();
	
新代码的修改参考：
	for (i in printData){
		// .... 逻辑处理 不变
		// 定义一个新的回调方法，包含进来
		var handelHttpsPicCallback = function (LODOP, inpara, inlist, jsonArr, reportNote, otherCfg){
			DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);  //MyPara 为xml打印要求的格式 //hxy 2021-06-04 add {printListByText:true} 是list支持base64的必须参数，因为封装里没默认上
			LODOP.NEWPAGE();
			// 最后一页了，要调用打印了。
			if(i == printData.length - 1) {
				LODOP.PRINT();	
			}
		}
		// 将原来 DHC_CreateByXML 的入参copy到此方法的入参，加最后一个回调函数的入参 handelHttpsPicCallback
		handelHttpsPic(LODOP,myPara,ListInfo,[],"PRINT-CST-NT",{printListByText:true}, handelHttpsPicCallback);
	}
*/
/**
 * 入参查看 DHC_PrintByLodopB
 * 标准版bug，HTTPS的图片没有证书无法打印出来，转为base64的图片打印 20220427 huangzhi
 * @param {} LODOP 
 * @param {*} inpara 
 * @param {*} inlist 
 * @param {*} jsonArr 
 * @param {*} reportNote 
 * @param {*} otherCfg 
 * @param {*} handelHttpsPicCallback 图片的值转为base64之后的回调函数
 */
function handelHttpsPic(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg, handelHttpsPicCallback) {
	var pictureArr = getHttpsPicture(inpara, jsonArr, otherCfg);
    if (pictureArr.length > 0) {
        var returnFun = function(base64Arr) {
            inpara = setInpara(inpara, pictureArr, base64Arr);
            handelHttpsPicCallback(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
        }
		var pictureDataObj = {};
		for (var i = 0; i < pictureArr.length; i++) {
			var c2 = String.fromCharCode(2);
			var url = pictureArr[i].split(c2)[1];
            pictureDataObj[url] = 1; // 可以去重复URL
        }
		var pictureDataArr = [];
		for (var url in pictureDataObj) {
			pictureDataArr.push(url);
		}
        urlsToBase64Data(pictureDataArr, returnFun);
    } else {
        handelHttpsPicCallback(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
    }
}

/**
 * inlist = splitInlistByLen(inlist, 20); hz
 * @param inlist 列表数据
 * @param len 长度
 * @returns 拆分好的列表数据
 */
function splitInlistByLen(inlist, len) {
    if(!inlist) {
        return inlist;
    }
    var arrResult = [];
    var c2 = String.fromCharCode(2);
    var trArr = inlist.split(c2); // 行
    for (var index = 0; index < trArr.length; index++) {
        var tdArr = trArr[index].split("^"); // 列
        var longString = tdArr[0];
        var strArr = subStrByByteLen(longString, len);
        if (strArr.length > 1) {
            tdArr[0] = strArr[0];
            arrResult.push(tdArr.join("^"));
            var temp = "";
            for (var i = 1; i < tdArr.length; i++) {
                temp += "^";                
            }
            for (var i = 1; i < strArr.length; i++) {
                arrResult.push(strArr[i] + temp);                
            }
        } else{
            arrResult.push(trArr[index]);
        }
    }
    return arrResult.join(c2);
}
/**
 * 按字节数拆分字符为数组返回 hz
 * @param str 
 * @param len 
 * @returns 
 */
function subStrByByteLen(str, len) {
    var array = [];
    if ((!str && typeof(str) != 'undefined')) {return array;}
    var num = 0;
    var str1 = str;
    var str = '';
    for (var i = 0,lens = str1.length; i < lens; i++) {
        num += ((str1.charCodeAt(i) > 255) ? 2 : 1);
        if (num > len) {
            array.push(str);
            num = 0;
            num += ((str1.charCodeAt(i) > 255) ? 2 : 1);
            str = str1.charAt(i);
        } else {
            str += str1.charAt(i);
        }
    }
    array.push(str);
    return array;
}

function CreateXMLDOM() {
	var ActiveX = new Array("MSXML2.DOMDocument.5.0",
		"MSXML2.DOMDocument.4.0",
		"MSXML2.DOMDocument.3.0",
		"MSXML2.DOMDocument",
		"Microsoft.XMLDOM",
		"MSXML.DOMDocument");
	for (var i = 0; i < ActiveX.length; i++) {
		try {
			return new ActiveXObject(ActiveX[i]);
		}
		catch (e) { }
	}
	return null;
}
function fileExists(filename){
	var fso = new ActiveXObject("Scripting.FileSystemObject");  
	if (fso.FileExists(filename)){   
		return true;   
	}else{   
		return false;   
	}
}
function getBase64FromFile(urlpath){
	if (urlpath!=""){
		var base64str = null;
		var x = new ActiveXObject('Msxml2.XMLHTTP.4.0') // Msxml2.XMLHTTP.6.0
		x.onreadystatechange = function( ){
			if(x.readyState < 4) return
			debugger;
			var xmldom = CreateXMLDOM();
			var tmpNode = xmldom.createElement('tmpNode')
			tmpNode.dataType = 'bin.base64';
			tmpNode.nodeTypedValue = x.responseBody;
			base64str = tmpNode.text.replace(/\n/g,'')
		}
		x.open('get',urlpath,false);
		x.send('')
		return base64str;
	}
	return null;
}
///按照TEXT模式打印List数据
function LODOP_CreateListByText(LODOP, invXMLDoc, inpara, inlist, jsonArr, otherCfg) {
    if (!inlist) return;
    var modelConfig = getListModelConfig(invXMLDoc, otherCfg);
	if (!modelConfig && !modelConfig.prtItemArr) return;
    // 生成每行的打印数据，按行分组。 pageDataArr[i] = oneLineItems
    var pageDataArr = getAllPrintData(inlist, modelConfig);
	// 每页添加表格头数据
	pageDataArr = addTableHeader(otherCfg, modelConfig, pageDataArr);
    // 处理分页 依次设置行高。
    var pageArr = splitDataToPage(modelConfig, pageDataArr, otherCfg);
    // 结束反斜线
    var slashPrintItem = printBackSlash(pageArr[pageArr.length - 1], modelConfig);
    // 统一打印。
    for (var i = 0; i < pageArr.length; i++) {
        var onePageItem = pageArr[i]; // 打印每页。先打印所有的线条，再打印元素
        printTableLine(LODOP, onePageItem, otherCfg, modelConfig); // 打印线
		// 打印每页的 每个元素
        for (var j = 0; j < onePageItem.length; j++) {
            var oneLineItem = onePageItem[j];
            for (var k = 0; k < oneLineItem.length; k++) {
                LODOP_PrintItem(LODOP, oneLineItem[k]);
            }
        }
        if (i + 1 != pageArr.length) {
            LODOP.NEWPAGE();
        } else {
			// 最后一页，结束反斜线
            if (slashPrintItem && slashPrintItem.type) LODOP_PrintItem(LODOP, slashPrintItem);
			// 最后一页，特殊打印反斜线
			printBackSlashSpecial(LODOP, otherCfg, pageArr[pageArr.length - 1], modelConfig);
        }
    }
}
function addTableHeader(otherCfg, modelConfig, pageDataArr) {
	if (!otherCfg || !otherCfg.tableHeader) {
		return pageDataArr;
	}
	var headerLine = cloneObj(modelConfig.prtItemArr); // cloneObj 很重要，否则，每页会共用一个引用类型的对象
	for (var i = 0; i < headerLine.length; i++) {
		headerLine[i].value = modelConfig.colsArr[i].pname;
	}
	var pageDataArrNew = [];
	for (var i = 0; i < pageDataArr.length; i++) {
		if (i % (modelConfig.xmlPageRows - 1) == 0) {
			pageDataArrNew.push(cloneObj(headerLine));
		}
		pageDataArrNew.push(pageDataArr[i]);
	}
	return pageDataArrNew;
}
// var pageDataArr = [];
function getAllPrintData(inlist, modelConfig) {
	var pageDataArr = [];
    var c2 = String.fromCharCode(2);
    var c1 = String.fromCharCode(1);
    var inlistArr = inlist.split(c2);
    for (var ila = 0; ila < inlistArr.length; ila++) {
        if (!inlistArr[ila]) continue;
        var oneLineItem = []; // 每行开始初始化
        var dataArr = inlistArr[ila].split("^");
        var oneLineWrapFlag = false;
        for (var j = 0; j < modelConfig.prtItemArr.length; j++) {
            var prtItemModel = modelConfig.prtItemArr[j];
            var prtItem = cloneObj(prtItemModel);
            if (dataArr[j]) {
                prtItem.value = dataArr[j];
            }
            // 特殊值的，包含类型的处理   
            if (dataArr[j] && dataArr[j].indexOf(c1) > -1) { // 1234_c1_qrcode ^ c:\1.jpg_c1_img ^ 1234_c1_barcode:128C 
                var ptype = dataArr[j].split(c1)[1];
                if (ptype == 'img') {
                    prtItem.type = ptype;
                    prtItem.value = dataArr[j].split(c1)[0];
                } else if (ptype.indexOf("barcode:") > -1) {
                    prtItem.barcodetype = ptype.split(':')[1];
                    prtItem.height = rowHeight;
                    if ('undefined' != typeof colsArr[j + 1]) {
                        prtItem.width = (colsArr[j + 1].pleft - col.pleft).toFixed(3);
                    } else {
                        prtItem.width = "30";
                    }
                    prtItem.value = dataArr[j].split(c1)[0];
                }
            }
            // 检查文本超长的，并处理
            if (prtItem.type == "text" && prtItem.value) {
                var printItemList = splitTextByWidth(prtItem, 2); // 2 表示只拆元素，不用调整Y坐标
				if (printItemList.length > 1) {
					oneLineItem.push(printItemList); // 多行的，放的是数组[]，单行的放的是{}
				} else {
					oneLineItem.push(printItemList[0]); // 多行的，放的是数组[]，单行的放的是{}
				}				
                for (var plt = 1; plt < printItemList.length; plt++) {
                    var printItemListObj = printItemList[plt];
                    printItemListObj.textWrapFlag = true; // 同一行文本的标记，用于边框划线的判断。
                    oneLineWrapFlag = true;
                }                
            } else {
                oneLineItem.push(prtItem);
            }
        }
        if (oneLineWrapFlag) {
            var lineArr = splitOneLineToLines(oneLineItem);
            for (var la = 0; la < lineArr.length; la++) {
                pageDataArr.push(lineArr[la]);
            }
        } else {
            pageDataArr.push(oneLineItem);
        }
    }
	return pageDataArr;
}
// var lineArr = splitOneLineToLines(oneLineItem);
function splitOneLineToLines(oneLineItem) {
	var lineArr = [];
	for (var i = 0; i < oneLineItem.length; i++) {
		if (oneLineItem[i] instanceof Array) {
			var arr = oneLineItem[i];
			for (var j = 0; j < arr.length; j++) {
				if (!lineArr[j]) lineArr[j] = [];
				lineArr[j].push(arr[j]);
			}
		} else {
			if (!lineArr[0]) lineArr[0] = [];
			lineArr[0].push(oneLineItem[i]);
		}
	}
	return lineArr;
}
function getListModelConfig(invXMLDoc, otherCfg) {
    var XMLModelConfig = {};
    if (!invXMLDoc) return null;
    var xmlListData = invXMLDoc.getElementsByTagName("ListData");
    if (!xmlListData || xmlListData.length < 1) return null;
    var xmlYStep = parseFloat(xmlListData[0].getAttribute("YStep"));
    XMLModelConfig.rowHeight = xmlYStep;
    var xmlPageRows = parseInt(xmlListData[0].getAttribute("PageRows"));
    XMLModelConfig.xmlPageRows = xmlPageRows;
    var xmlBackSlashWidth = parseInt(xmlListData[0].getAttribute("BackSlashWidth"));
    XMLModelConfig.xmlBackSlashWidth = xmlBackSlashWidth; // 斜线宽
    var tableTop = 0,
    tableLeft = 0,
    colsArr = [],
    prtItemArr = [];
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
        var pfcolor = itm.getAttribute("fontcolor");
        var pcoltype = itm.getAttribute("coltype") || "text";
        var pwidth = itm.getAttribute("width") || "";
        var pheight = itm.getAttribute("height") || "";
        var pbarcodetype = itm.getAttribute("barcodetype") || "";
        var pisshowtext = itm.getAttribute("isshowtext") || "";
        var pqrcodeversion = itm.getAttribute("qrcodeversion") || "";
        colsArr.push({
            pname: pname,
            pleft: parseFloat(pleft),
            ptop: parseFloat(ptop),
            pdval: pdval,
            ppval: ppval,
            pfbold: pfbold,
            pfcolor: pfcolor,
            pfname: pfname,
            pfsize: parseFloat(pfsize),
            pcoltype: pcoltype,
            pwidth: pwidth,
            pheight: pheight,
            pbarcodetype: pbarcodetype,
            pisshowtext: pisshowtext,
            pqrcodeversion: pqrcodeversion
        });
        if (tableTop > 0) tableTop = Math.min(tableTop, ptop);
        else tableTop = ptop;
        if (tableLeft > 0) tableLeft = Math.min(tableLeft, pleft);
        else tableLeft = pleft;
    }
    for (var j = 0; j < colsArr.length; j++) {
        var col = colsArr[j];
        if (!col.pwidth) {
			if (colsArr[j + 1]) {
				col.pwidth = (colsArr[j + 1].pleft - col.pleft).toFixed(3);
			} else {
				col.pwidth = 800;
			}
            // otherCfg.tdnowrap 定义了不换行，则给 800 的宽度，否则，用后一行的位置计算宽度。
            if (otherCfg && otherCfg.tdnowrap) {
                col.pwidth = 800;
            }
        }
        if (!col.pheight) {
            col.pheight = XMLModelConfig.rowHeight;
        }
        col.isqrcode = col.pcoltype == "qrcode" ? "true": "";
    }
    for (var j = 0; j < colsArr.length; j++) {
        var col = colsArr[j];
        var prtItem = {
            type: col.pcoltype,
            y: col.ptop,
            x: col.pleft,
            width: col.pwidth,
            height: col.pheight,
            value: col.ppval,
            fsize: col.pfsize,
            fname: col.pfname,
            fbold: col.pfbold,
            fcolor: col.pfcolor,
            barcodetype: col.pbarcodetype,
            isshowtext: col.pisshowtext,
            qrcodeversion: col.pqrcodeversion,
            isqrcode: col.isqrcode
        };
        prtItemArr.push(prtItem);
    }
    XMLModelConfig.tableTop = tableTop;
    XMLModelConfig.tableLeft = tableLeft;
    XMLModelConfig.colsArr = colsArr;
    XMLModelConfig.prtItemArr = prtItemArr;
	return XMLModelConfig;
}
function splitDataToPage(modelConfig, pageDataArr, otherCfg) {
    var pageArr = [],
    onePageItem = [],
    oneLineItem = [];
    for (var i = 0; i < pageDataArr.length; i++) {
        oneLineItem = pageDataArr[i];
        if (i % modelConfig.xmlPageRows == 0) {
            // 这里是新的一页了。
			if (i != 0) pageArr.push(onePageItem);			
            onePageItem = []; // 每页开始初始化
            onePageItem.push(oneLineItem);
        } else {
            for (var j = 0; j < oneLineItem.length; j++) {
                oneLineItem[j].y += (i % modelConfig.xmlPageRows) * modelConfig.rowHeight;
            }
            onePageItem.push(oneLineItem);
        }
    }
	pageArr.push(onePageItem);
	for (var i = 1; i < pageArr.length; i++) {
		modifyNextPageY(pageArr[i], otherCfg);
	}
    return pageArr;
}
// 第二页打印表格的时候，希望从纸张的顶上开始打印。
function modifyNextPageY(onePageItem, otherCfg) {
	if (!otherCfg || !otherCfg.pageTableStartPostion) return;
	var modify = onePageItem[0][0].y - otherCfg.pageTableStartPostion;
	for (var i = 0; i < onePageItem.length; i++) {
		for (var j = 0; j < onePageItem[i].length; j++) {
			onePageItem[i][j].y = onePageItem[i][j].y - modify;
		}
	}
}
function printTableLine(LODOP, onePageItem, otherCfg, modelConfig) {
    if (!otherCfg || !otherCfg.listHtmlTableBorder) {
		var border = 0;
	} else {
		var border = parseInt(otherCfg.listHtmlTableBorder);
	}
    if (otherCfg && otherCfg.tableBorderColumnArr && border < 1) {
        border = 1;
    }
    if (border < 1) return;
	var rowHeight = modelConfig.rowHeight;
	var xPoint = []; // 统计边框线的X坐标列表
    var modify = 0.66;
	// x 坐标不用打印数据统计，因为第一行有的列为空，就统计不到了，用模板里面的统计。
    var oneLineItem = modelConfig.prtItemArr;
    for (var i = 0; i < oneLineItem.length; i++) {
        xPoint.push(oneLineItem[i].x - modify);
    }
    xPoint.push(oneLineItem[oneLineItem.length - 1].x + parseFloat(oneLineItem[oneLineItem.length - 1].width));
    var yPoint = [];
	// y 坐标可以用打印数据统计，因为每一行的oneLineItem的第一个元素，不一定是第一列的，一定是非空的。但是 y 都是一样的值。
    for (var i = 0; i < onePageItem.length; i++) {
        yPoint.push(onePageItem[i][0].y - modify);
    }
    yPoint.push(onePageItem[onePageItem.length - 1][0].y + parseFloat(rowHeight));
    // 画竖线
    if (otherCfg && otherCfg.tableBorderColumnArr) {
        for (var i = 0; i < otherCfg.tableBorderColumnArr.length; i++) {
            var index = otherCfg.tableBorderColumnArr[i] - 1; // 只画出配置了的竖线。
			if (index < 0) break;
            LODOP_PrintItem(LODOP, {
                type: 'line',
                sy: yPoint[0],
                sx: xPoint[index],
                ey: yPoint[yPoint.length - 1],
                ex: xPoint[index],
                rePrtHeadFlag: "N",
                fcolor: ""
            });
        }
    } else {
        for (var i = 0; i < xPoint.length; i++) {			
            LODOP_PrintItem(LODOP, {
                type: 'line',
                sy: yPoint[0],
                sx: xPoint[i],
                ey: yPoint[yPoint.length - 1],
                ex: xPoint[i],
                rePrtHeadFlag: "N",
                fcolor: ""
            });
        }
    }
	if (otherCfg && otherCfg.tableBorderColumnArr && !otherCfg.tableBorderRowFlag) {
		return;
	} else {
		// 画横线
		for (var i = 0; i < yPoint.length; i++) {
			var mustPrintFlag = false;
			if (otherCfg && otherCfg.tableHeader && i == 1) {
				mustPrintFlag = true; // 换页打印，且打印了表头的，底下要画横线。
			}
			if (!mustPrintFlag && i < yPoint.length - 1 && onePageItem[i][0].textWrapFlag) continue; // 中间换行的，不画横线。
			LODOP_PrintItem(LODOP, {
				type: 'line',
				sy: yPoint[i],
				sx: xPoint[0],
				ey: yPoint[i],
				ex: xPoint[xPoint.length - 1],
				rePrtHeadFlag: "N",
				fcolor: ""
			});
		}
	}
}
function printBackSlash(onePageItem, modelConfig) {
    var slashPrintItem = null;
    if (modelConfig.xmlBackSlashWidth < 1) return slashPrintItem;
    if (modelConfig.xmlPageRows == onePageItem.length) return slashPrintItem; // 满行
	var sx = onePageItem[0][0].x;
	var sy = onePageItem[onePageItem.length - 1][0].y + (modelConfig.xmlPageRows - onePageItem.length + 1) * modelConfig.rowHeight;
	var ex = onePageItem[0][0].x + parseInt(modelConfig.xmlBackSlashWidth);
	var ey = onePageItem[onePageItem.length - 1][0].y + modelConfig.rowHeight;
    slashPrintItem = {
        type: 'line',
        sy: sy,
        sx: sx,
        ey: ey,
        ex: ex,
        rePrtHeadFlag: "N",
        fcolor: ""
    }
    return slashPrintItem;
}
function printBackSlashSpecial(LODOP, otherCfg, onePageItem, modelConfig) {
	// list打印完后,回调
	if (otherCfg && 'function' == typeof otherCfg.listAfterCallback) {
		otherCfg.listAfterCallback({
			PrinterObj: LODOP,
			tableTop: modelConfig.tableTop, // 表格的top位置
			tableLeft: modelConfig.tableLeft, // 表格的left位置
			rowHeight: modelConfig.rowHeight, // 每一行的行高多少
			y: modelConfig.tableTop + ((onePageItem.length + 1) * modelConfig.rowHeight), // 行的起始y位置
			x: modelConfig.tableLeft, // 行的起始x位置
			currPageRowNo: onePageItem.length, // *当前行号
			pageRows: modelConfig.xmlPageRows, // 一页打印多少行数据
			backSlashWidth: modelConfig.xmlBackSlashWidth // 表格反斜线宽度
		});
	}
}
// type ：2 表示只拆元素，不用调整Y坐标
// var printItemList = splitTextByWidth(printItem);
function splitTextByWidth(printObj, type) {
    var width = printObj.width;
    var fontSize = printObj.fsize;
    var text = printObj.value;
	if(!text) return [""];
    var textList = splitStringByFontSize(fontSize, width, text);
    var rtn = [];
    var unitWidth = getFontSizeWidth(fontSize);
    for (var i = 0; i < textList.length; i++) {
        var item = cloneObj(printObj);
        item.value = textList[i];
        if (!type || type == 1) item.y = i * unitWidth + item.y * 1;
        rtn.push(item);
    }
    return rtn;
}
function splitStringByFontSize(fontSize, oneLineWidth, str) {
    var rtn = [];
    var tempLen = 0;
    var strObj = "";
    var unitWidth = getFontSizeWidth(fontSize);
    var charArr = str.split("");
    for (var i = 0; i < charArr.length; i++) {
        var charCode = charArr[i];
        if (charCode >= 0 && charCode <= 128) {
            var len = 0.5;
        } else {
            var len = 1;
        }
        len = len * unitWidth;
		// oneLineWidth - unitWidth 多预留一个字符的间隔。
        if (tempLen + len > oneLineWidth - unitWidth) {
            rtn.push(strObj);
            strObj = charCode;
            tempLen = len;
        } else {
            tempLen += len;
            strObj += charCode;
        }
    }
    rtn.push(strObj);
    return rtn;
}
function getFontSizeWidth(fontSize) {
    // 磅值是指打印的字符的高度的度量单位的数值。1 磅等于 1/72 英寸，或大约等于 1 厘米的 1/28 0.376毫米
    var num = fontSize * 0.376;
    num = num.toFixed(3); // 返回长度是以毫米为单位的数值。
    return num;
}
// 原文链接：https://blog.csdn.net/weixin_46074961/article/details/122412958
var cloneObj = function(obj) {
    var newObj = {};
    if (obj instanceof Array) {
        newObj = [];
    }
    for (var key in obj) {
        var val = obj[key];
        newObj[key] = typeof val === 'object' ? cloneObj(val) : val;
    }
    return newObj;
}
