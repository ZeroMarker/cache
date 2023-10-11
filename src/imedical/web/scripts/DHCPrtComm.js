///DHCPrtComm.js
PrtAryData=new Array()
/**
*@author : wanghc
*@date : 2017-2-9
*@param : {int} printWidth ��ӡֽ���
*@param : {String} str ��ӡ���� 
*@param : {int} wordWidth һ���ֵĿ��
* var x  = getCenterX(190,"������̳ҽԺ",4)
*/
function getCenterX(printWidth, str, wordWidth){
	var titleLen = str.length * wordWidth;
	var x = (printWidth-titleLen)/2;
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
function autoWordEnter(str,lineWordNum){
    var charWordNum = lineWordNum*2;  //һ���ֳ���Ϊ����char����
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
            charLen += 2;  //����
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
		/*����inpara�л�������,��������,����jsonArr*/
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
		//-----jsonArr����
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
							exTextXml += '<txtdatapara width="'+(itemJson.width||100)+'" height="'+(itemJson.height||100)+'" name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"����")+'" defaultvalue="" printvalue="'+(itemJson.value)+'" isqrcode="true"></txtdatapara>';
						}else{
							var textValueArr = itemJson.value.split("\n");
							var tmpStartY = itemJson.y;
							for (var tmpInd=0; tmpInd<textValueArr.length; tmpInd++){
								exTextXml += '<txtdatapara name="'+itemJson.name+tmpInd+'" xcol="'+itemJson.x+'" yrow="'+tmpStartY+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"����")+'" defaultvalue="'+(textValueArr[tmpInd])+'" printvalue="'+(textValueArr[tmpInd])+'"></txtdatapara>';
								tmpStartY += parseInt(itemJson.lineHeigth||5);
							}
							//exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"����")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>';
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
		// �����ҳ
		var page2 = false; //�Ƿ��ǵڶ�ҳ
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
			if (PObj && 'undefined'!=typeof PObj.ToPrintHDLPStr){  /*����PObj�ж�,�ϵĶ���û��ToPrintHDLPStr���µ�catch��*/
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
						exTextXml += '<txtdatapara name="'+itemJson.name+'" xcol="'+itemJson.x+'" yrow="'+itemJson.y+'" fontsize="'+(itemJson.fontsize||12)+'" fontbold="'+(itemJson.fontbold||"false")+'" fontname="'+(itemJson.fontname||"����")+'" defaultvalue="'+(itemJson.value)+'" printvalue="'+(itemJson.value)+'"></txtdatapara>'
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
// name^С��$c(2)age^24��
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
			// ��ӡ����ʱ���ֵû�ж��ߴ�*,���Զ���*,��*�����ɨ�롣2019-4-1����һԺstart
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
			// inpara��ɶ���
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
			// ��ӡ����ʱ���ֵû�ж��ߴ�*,���Զ���*������һԺstart
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
			// inpara��ɶ���
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
		//���ֽڼ�1 
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
		//���ֽڼ�1 
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
	//��ȡ������д��c�̳�Ϊ.gif�ļ�
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
	var fname = item.fname||"����", fbold = item.fbold||item.fontbold||"false", fsize = item.fsize||item.fontsize||12,fcolor=item.fcolor||item.fontcolor||"";
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
					value = "<img border='0' src='"+value+"'/>" //"URL:"+pval;--�������������
				}
				if (value!=""){
					LODOP.ADD_PRINT_IMAGE(item.y+"mm",item.x+"mm",width,height,value);
					if(value.indexOf("http")>-1) LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",500);
					if (height=="100%" && width=="100%"){
						//LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",100);//�ӳ�100����
						//LODOP.SET_PRINT_STYLEA(0,"Stretch",2);//ͼƬ��ʾԭ��С
					}else{
						LODOP.SET_PRINT_STYLEA(0,"Stretch",1);//(�ɱ���)��չ����ģʽ
					}
				}
		}else if (item["type"].toLowerCase()=="line" || item["type"].toLowerCase()=="pline"){
			if (item.sy) LODOP.ADD_PRINT_LINE(item.sy+"mm",item.sx+"mm",item.ey+"mm",item.ex+"mm",0,1); //0=ʵ��,1=�߿�
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
		if (rePrtHeadFlag=="Y") LODOP.SET_PRINT_STYLEA(0,"ItemType",1); //1=ҳüҳ��
	}
};
function LODOP_CreateLine(LODOP,invXMLDoc,inpara,inlist,jsonArr){
	//lodop�Ƽ��ȴ���
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
	// inpara��ɶ���
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
	// inpara��ɶ���
	var c2 = String.fromCharCode(2);
	var inparaArr = inpara.split('^');
	var inparaObj = {};
	for(var i=0; i<inparaArr.length; i++){
		var arr = inparaArr[i].split(c2);
		inparaObj[arr[0]] = arr[1];
	}
	var invAttr = invXMLDoc.attributes;
	var invOrient = "X";
	if (invAttr.getNamedItem("LandscapeOrientation")){ //�ϰ������,Ĭ�������û�д�����
		invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=����,Y=����,Z=����ͣ
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
						// �Զ����˿�ȵ�ʱ�򣬸��ݿ�Ȳ��Ԫ�ء�
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
		// ��ʱ�ر���һ�»��е� ����Ĵ����иĶ��ģ�һ���ǵ�������ͬ���޸ġ�
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
		var tableOneHeight = parseInt(rowHeight*xmlPageRows); //һҳ���߶�
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
		//inlist���
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
								"src='" + value + "'/>"; //"URL:"+pval;--�������������                                
							}
							tr += value + '</td>';
						} else {
							tr += '" >'+arr[j]+'</td>'
						}						
					}else{
						tr+='<td>'+arr[j]+"</td>";
					}
				}
				if (colsArr.length>arr.length){ //���xml�����ж���м��Ͽ�������,������һ�п������
					tr+='<td></td>';
				}
				tr+="</tr>";
				tableStr += tr;
				inlistArrValidCount++;
				if (((inlistArrValidCount%xmlPageRows)==0) || i==(inlistArr.length-1)) {
					var tableString = listHtmlTableSettings(tableStr, otherCfg);
					if(otherCfg && otherCfg.rightMarginNum) {
						// RightMargin ��Ʒ�鷴���������ұ߾࣬�����Զ������п����ȷֲ��С�
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
			if ((inlistArrValidCount%xmlPageRows)!=0){ //û�����Ŵ�ӡslash
				var remainRow = inlistArrValidCount%xmlPageRows;
				var slash2Top =  parseInt(tableTop) + (remainRow*rowHeight);
				var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
				var slash1Top = parseInt(tableTop)+parseInt(tableOneHeight);
				var slash1Left = tableLeft ;
				/*
				var tableCount = Math.ceil(inlistArrValidCount / xmlPageRows); //���ӡ��n��
				var tableTotalMaxHeight = parseInt(tableCount * tableOneHeight); //n�ű��ĸ߶�
				var tableTotalHeight = parseInt(inlistArrValidCount * rowHeight) ; //��ӡ���ݵ��ܸ߶�
				var slash2Top = parseInt(tableTop)+parseInt(tableTotalHeight);  //��������top
				var slash2Left = parseInt(tableLeft) + parseInt(xmlBackSlashWidth);
				var slash1Top = parseInt(tableTop)+parseInt(tableTotalMaxHeight);
				var slash1Left = tableLeft ;*/
				
				LODOP.ADD_PRINT_LINE(slash2Top+"mm",slash2Left+"mm",slash1Top+"mm",slash1Left+"mm",0,1); //0=ʵ��,1=�߿�
				//var lastTop = parseFloat(LODOP.GET_VALUE("ItemTop",'last')); //ֻ�����ʱ������
				//var lastLeft = parseFloat(LODOP.GET_VALUE("ItemLeft",'last'));
			}
		}
	}
}
/**
*@author : hz
*@date : 2022-3-28
*@param : ��ʱ�ر���һ�»��е� ����Ĵ����иĶ��ģ�һ���ǵ������� ͬ���޸ġ�
*/
function CreateListHtmlWithWordWrapTemp(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	var c2 = String.fromCharCode(2);
	var xmlListData = invXMLDoc.getElementsByTagName("ListData");
	if (xmlListData && xmlListData.length>0){
		var xmlYStep = xmlListData[0].getAttribute("YStep");
		var xmlPageRows = xmlListData[0].getAttribute("PageRows");
		var xmlBackSlashWidth = xmlListData[0].getAttribute("BackSlashWidth");
		var rowHeight = xmlYStep;
		var tableOneHeight = parseInt(rowHeight*xmlPageRows); //һҳ���߶�
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
		//inlist���
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
								"src='" + value + "'/>"; //"URL:"+pval;--�������������
							}
							tr += value + '</td>';
						} else {
							tr += '" >'+arr[j]+'</td>'
						}						
					}else{
						tr+='<td>'+arr[j]+"</td>";
					}
				}
				if (colsArr.length>arr.length){ //���xml�����ж���м��Ͽ�������,������һ�п������
					tr+='<td></td>';
				}
				tr+="</tr>";
				tableStr += tr;
				inlistArrValidCount++;
				if (i==(inlistArr.length-1)) {
					var tableString = listHtmlTableSettings(tableStr, otherCfg);
					if(otherCfg && otherCfg.rightMarginNum) {
						// RightMargin ��Ʒ�鷴���������ұ߾࣬�����Զ������п����ȷֲ���
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
	// border-collapse ���ڱ������, ��ʾ�������߿�ϲ�Ϊһ����
	rtn += ">" + tableStr + "</table>"
	return rtn;
}

// linkֻ��json��ȡ
function LODOP_CreateLink(LODOP,inv,inpara,inlist,jsonArr){
	// jsonArr!="" jsonArrΪxmlObjʱ,��IE6�»ᱨ"����֧�ִ����Ի򷽷�",�޸ĳ�jsonArr!==""����,ҵ�����ʱ��xmlObj����jsonAr����
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
/*��С�뷽��*/
function LODOP_CreateInv(LODOP,invXMLDoc,inpara,inlist,jsonArr,otherCfg){
	var rtn = {notFindPrtDevice:false};
	var invAttr = invXMLDoc.attributes;
	var invHeight = invAttr.getNamedItem("height").value;
	var invWidth = invAttr.getNamedItem("width").value;
	var invOrient = "X"; 
	if (invAttr.getNamedItem("LandscapeOrientation")){ //�ϰ������,Ĭ�������û�д�����
		invOrient = invAttr.getNamedItem("LandscapeOrientation").value; //X=����,Y=����
	}
	//var invPrtDirect = invAttr.getNamedItem("PrtDirection").value; //Y----��Ч
	var invPrtPaperSet = invAttr.getNamedItem("PrtPaperSet").value; //WIN
	var invPrtDevice = invAttr.getNamedItem("PrtDevice").value; //xps
	if ("undefined"!=typeof otherCfg && "string"==typeof otherCfg.PrtDevice){
		invPrtDevice = otherCfg.PrtDevice;
	}
	var invPrtPage = invAttr.getNamedItem("PrtPage").value; //A5
	//var invPrtDesc = invAttr.getNamedItem("PaperDesc").value; //----��Ч
	// 2021-05-20 header ,footer
	//var invPageHeader = invAttr.getNamedItem("PageHeader").value;
	var invPageFooterVal = "",invNotFindPrtDeviceVal="",invDuplexVal="";
	var invPageFooter = invAttr.getNamedItem("PageFooter");
	if (invPageFooter) invPageFooterVal = invPageFooter.value;
	var invNotFindPrtDevice = invAttr.getNamedItem("NotFindPrtDevice");
	if (invNotFindPrtDevice) invNotFindPrtDeviceVal = invNotFindPrtDevice.value;
	var invDuplex = invAttr.getNamedItem("Duplex");
	if (invDuplex) invDuplexVal = invDuplex.value;	
	
	var intOrient=1 ;//Ĭ��1=����
	if (invOrient=="Y") intOrient=2;
	else if(invOrient=="X") intOrient=1;
	else if(invOrient=="Z"){intOrient=3;/*�����ݸ߶���*/}
	if (invPrtPaperSet=="HAND"){
		var lodopPageWidth = invWidth*10+"mm"
		var lodopPageHeight = invHeight*10+"mm";
		var lodopPageName = "";	
	}else{
		var lodopPageWidth = 0 //��ʾ��Ч
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
			LODOP.SET_PRINT_STYLEA(0,"Horient",2);//0-��߾����� 1-�ұ߾����� 2-ˮƽ������� 3-��߾���ұ߾�ͬʱ����-�м�����
			LODOP.SET_PRINT_STYLEA(0,"Vorient",1);//0-�ϱ߾����� 1-�±߾����� 2-��ֱ������� 3-�ϱ߾���±߾�ͬʱ����-�м�����
		}
	}
	if (invDuplexVal!=""){
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX",invDuplexVal);
	}
	//alert(intOrient+","+lodopPageWidth+","+lodopPageHeight+","+lodopPageName);
	LODOP.SET_PRINT_PAGESIZE(intOrient,lodopPageWidth,lodopPageHeight,lodopPageName);
	//LODOP.SET_PRINT_PAGESIZE(3,1385,45,""); //����3��ʾ�����ӡ��ֽ�ߡ������ݵĸ߶ȡ���1385��ʾֽ��138.5mm��45��ʾҳ�׿հ�4.5mm
	// �Ⱦ�׼��ѯ������
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
		//һ��xmlģ���δ�ӡ��ϣ����ͬһ��������,��ε��õ�ǰ���� 2018-10-31 
		if ("undefined"!=typeof reportNote){
			if (LODOP.strHostURI){  //LODOP.webskt
				if (LODOP.ItemDatas.count==0){
					//LODOP.PRINT_INIT(reportNote); //һ������,���ö��init��
					LODOP.PRINT_INITA(0,0,"100mm","100mm",reportNote); //2021-05-20 Ĭ��ֽ����߾࣬���������ã�Ϊ��ʵ�ֵײ�ü��
				}
			}else if(LODOP.GET_VALUE("ItemCount",1)==0) {
				//LODOP.PRINT_INIT(reportNote); //һ������,���ö��init��
				LODOP.PRINT_INITA(0,0,"100mm","100mm",reportNote); //2021-05-20
			}
		}
		
		/*var docobj= CreateXMLDOM();
		//docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);*/
		var docobj=DHC_parseXml(mystr);
		if (docobj){
			if (docobj.parsed){
				//LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);    //����������
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
				//lodop�Ƽ��ٴ�ӡͼƬ
				LODOP_CreateImg(LODOP,inv,inpara,inlist,jsonArr,otherCfg);

				// һ������,ֽ�Ų������ //CLodop������ֵ 20200319ȥ���ж�
				// if (LODOP.GET_VALUE("ItemCount",1)==0) LODOP_CreateInv(LODOP,inv);
				//lodop�Ƽ��ȴ�ӡ��
				LODOP_CreateLine(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				
				//lodop��ӡ�ı�
				LODOP_CreateTxt(LODOP,inv,inpara,inlist,jsonArr,otherCfg);

				//lodop��ӡ�б�
				if (otherCfg.printListByText==true){
					LODOP_CreateListByText(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				}else{
					LODOP_CreateList(LODOP,inv,inpara,inlist,jsonArr,otherCfg);
				}
				
				//LODOP.ADD_PRINT_TEXT(15,200,200,25,"�Ʊ���:guest");
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
		docobj.parsed=true;  //�������ж�docobj.parsed  ǿ�и�ֵ
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
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XMLģ�����ƴ����Ҳ���ģ�壡
		PFlagXmlStr = DHCP_TextEncoder(PFlagXmlStr);
		mystr = PFlagXmlStr;
	}
	return DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg);
}
/*
��μ�DHC_CreateByXML����
@return 
�ɹ� ���ش�ӡ���ݱ���ͼƬ���Ӧ��BASE64�ַ���
ʧ�� ����""
*/
function DHC_GetBase64ByLodop(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg){
	var mystr="";
	for (var i= 0; i<PrtAryData.length;i++){
		mystr=mystr + PrtAryData[i];
	}	
	if(otherCfg && otherCfg.PFlag) {
		var PFlagXmlStr = tkMakeServerCall("web.DHCXMLPConfig", "ReadXmlStrByName", otherCfg.PFlag);
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XMLģ�����ƴ����Ҳ���ģ�壡
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
	LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	DHC_CreateByXMLStr(LODOP,mystr,inpara,inlist,jsonArr,reportNote,otherCfg);
	LODOP.SET_SAVE_MODE("FILE_PROMPT","0");
	LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".png");
	LODOP.SET_SAVE_MODE("RETURN_FILE_NAME","1");
	var diskName = "D"; //LODOP.GET_SYSTEM_INFO("DiskDrive.1.Label"); //�е���ȡ����1121i221_12
	if (LODOP.SAVE_TO_FILE(diskName+":\dhclodop.png")){
		return LODOP.FORMAT("FILE:EncodeBase64",diskName+":\dhclodop.png");
	}else{
		alert("\u4FDD\u5B58\u6253\u5370\u56FE\u7247\u5931\u8D25!");
		return "";
	}
	//LODOP.FORMAT("FILE:WAVE,c:/lodoptest.wav","Hello,���ã�")
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
          example: {LetterSpacing:-2,printListByText:false,tdnowrap:true, preview:0,PrtDevice:'ǿ�ƴ�ӡ������',onPrintEnd:myPrintEnd,onCreatePDFBase64:mypdfBase64,pdfPath:'C:\\imedical\\xmlprint\\'}
		  listHtmlTableWordWrapFlag:true; ��ӡ list ʹ��HTML��ӡ��ʱ�������Զ����ݿ�Ȼ��С���������е�X����������
		  listHtmlTableBorder:1; ��ӡ list ʹ��HTML��ӡ��ʱ��table��border��С���Ƿ��б߿�
		  tdnowrap:true ---> not break line 
		  pdfDownload:false 
		  onCreatePDFBase64:undefined
		  PFlag:"��ӡģ���ID" // 1�����Բ����ü���ģ��ķ����ˡ�2��һ�δ�ӡ���ģ���ʱ�򣬱���ģ�帲�ǣ������������������ա�
		  rightMarginNum:��ӡ���������ֽ�ŵ��ұ߾�,�Ѻ���Ϊ��λ���������֣�������λ�ġ���Ʒ�鷴���������ұ߾࣬�����Զ������п����ȷֲ��С�
		  tableBorderColumnArr:[1,2,3] // �������������� 1��2��3 �е������Ҫ��ӡ���ߡ������Ǵ�1��ʼ�ģ�����0��ʼ�ġ�tableBorderColumnArr:[0] ����ӡ�κ����ߡ�ǰ�᣺printListByText:true��ʱ��
		  tableBorderRowFlag:true|false // ����ӡ�߿�ĺ��ߣ�ֻ���� tableBorderColumnArr printListByText:true��ʱ��
		  tableHeader:true|false // �Ƿ�ÿҳ�ĵ�һ�д�ӡ���ͷ�����ͷ��ģ���ж�����е�Ԫ������
		  pageTableStartPostion:// ��ӡ������ݻ�ҳ��ʱ�򣬵ڶ�ҳ�б����ʼλ��yrowĬ�������һҳ��ӡ����ͬ������벻ͬ���ʹ���Σ���ҳʱ�б����ʼλ��yrowֵ����λmm����Ҫ�͵�λ�����磬�ڶ�ҳ���ֽ�Ŷ���ʼ��ӡ��
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
	/* ��ӡ���,��ˢ�½����ٴ�ӡʱ���ߴ�ӡ������---add 2018-12-11*/
	LODOP.PRINT_INIT(""); /*����ϴδ�ӡԪ��*/
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
				clearTimeout(t); //"��ӡ�ɹ���";
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
					clearTimeout(LODOPWaitForTimer); // "��ӡ����30��û���񵽳ɹ�״̬��";
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
ͨ����ӡ������ô�ӡ������,��ѯ�ǰ�������
@param : {String} ��ӡ������
@return : {Int} ��ӡ������,��0��ʼ�����δ�ҵ�����-1
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
 * ��β鿴 DHC_PrintByLodopB
 * ��׼��bug��HTTPS��ͼƬû��֤���޷���ӡ������תΪbase64��ͼƬ��ӡ 20220427 huangzhi
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
            pictureDataObj[url] = 1; // ����ȥ�ظ�URL
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
 * ��������תΪbase64���ַ���
 * @param {http���� ����} url 
 * @param {תΪbase64���ַ�����Ļص����������Ϊ base64Arr {} ����} callback
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
 * ��������תΪbase64���ַ���
 * @param {http����} url 
 * @param {תΪbase64���ַ�����Ļص�����} callback 
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
 * ��ȡhttps��ͼƬ·��������
 * @param {�������} inpara 
 * @param {����Ԫ��} jsonArr 
 * @returns https��ͼƬ·��������
 */
function getHttpsPicture(inpara, jsonArr, otherCfg) {
    var pictureArr = [];
    var invXMLDoc = getInvXmlModel(jsonArr, otherCfg);
    var inparaObj = handelInParam(inpara);
	if (invXMLDoc){ // XMLģ����д��ʱ�ᱨ��
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
		if (!PFlagXmlStr) alert("xml\u6a21\u677f\u540d\u79f0\u9519\u8bef\uff0c\u627e\u4e0d\u5230\u6a21\u677f\uff01"); // XMLģ�����ƴ����Ҳ���ģ�壡
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
	// ģ���ǿյģ�ȫ������jsonArr�����ģ���Ҫ���ģ���Ĭ��ֵ��
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
                var val = evalXMLVal(itemJson["value"]);  /*�����޸�itemJson.value��ֵ,��Ӱ��ԭ���jsonArr��ֵ,�����ε���addJsonArrModel�ᵼ�¶��ת�������ַ�&<*/
            }
            if (itemJson["type"].toLowerCase() == "invoice") {} else if (itemJson["type"].toLowerCase() == "line") {
                exLineXml += '<PLine BeginX="' + itemJson.sx + '" BeginY="' + itemJson.sy + '" EndX="' + itemJson.ex + '" EndY="' + itemJson.ey + '"></PLine>'
            } else if (itemJson["type"].toLowerCase() == "text") {
                if (itemJson["isqrcode"]) {
                    exTextXml += '<txtdatapara name="' + itemJson.name + '" xcol="' + itemJson.x + '" yrow="' + itemJson.y + '" isqrcode="' + itemJson.isqrcode + '" width="' + itemJson.width + '" height="' + itemJson.height + '" fontsize="' + (itemJson.fontsize || 12) + '" fontbold="' + (itemJson.fontbold || "false") + '" fontname="' + (itemJson.fontname || "����") + '" defaultvalue="' + (val) + '" printvalue="' + (val) + '" qrcodeversion="' + (itemJson.qrcodeversion || "") + '" ></txtdatapara>'
                } else {
                    exTextXml += '<txtdatapara name="' + itemJson.name + '" xcol="' + itemJson.x + '" yrow="' + itemJson.y + '" '
                    if (itemJson.width > 0) exTextXml += 'width="' + itemJson.width + '" ';
                    if (itemJson.height > 0) exTextXml += 'height="' + itemJson.height + '" ';
                    if (itemJson["barcodetype"]) exTextXml += 'barcodetype="' + itemJson["barcodetype"] + '" ';
                    exTextXml += 'fontsize="' + (itemJson.fontsize || 12) + '" fontbold="' + (itemJson.fontbold || "false") + '" fontname="' + (itemJson.fontname || "����") + '" defaultvalue="' + (val) + '" printvalue="' + (val) + '"></txtdatapara>'
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
    // inpara��ɶ���
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
    return str.substr(1); // ��һ��"^"ȥ��
}

/*
/// �������ԭ��ʹ�õ��� DHC_CreateByXML ������ӡ�ģ�ͼƬ��ӡ������������˵����
����ɴ��룺
	for (i in printData){
		// .... �߼�����
		DHC_CreateByXML(LODOP,myPara,ListInfo,[],"PRINT-CST-NT",{printListByText:true});  //MyPara Ϊxml��ӡҪ��ĸ�ʽ /y 2021-06-04 add {printListByText:true} ��list֧��base64�ı����������Ϊ��װ��ûĬ����
		LODOP.NEWPAGE();
	}
	var printRet = LODOP.PRINT();
	
�´�����޸Ĳο���
	for (i in printData){
		// .... �߼����� ����
		// ����һ���µĻص���������������
		var handelHttpsPicCallback = function (LODOP, inpara, inlist, jsonArr, reportNote, otherCfg){
			DHC_CreateByXML(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);  //MyPara Ϊxml��ӡҪ��ĸ�ʽ //hxy 2021-06-04 add {printListByText:true} ��list֧��base64�ı����������Ϊ��װ��ûĬ����
			LODOP.NEWPAGE();
			// ���һҳ�ˣ�Ҫ���ô�ӡ�ˡ�
			if(i == printData.length - 1) {
				LODOP.PRINT();	
			}
		}
		// ��ԭ�� DHC_CreateByXML �����copy���˷�������Σ������һ���ص���������� handelHttpsPicCallback
		handelHttpsPic(LODOP,myPara,ListInfo,[],"PRINT-CST-NT",{printListByText:true}, handelHttpsPicCallback);
	}
*/
/**
 * ��β鿴 DHC_PrintByLodopB
 * ��׼��bug��HTTPS��ͼƬû��֤���޷���ӡ������תΪbase64��ͼƬ��ӡ 20220427 huangzhi
 * @param {} LODOP 
 * @param {*} inpara 
 * @param {*} inlist 
 * @param {*} jsonArr 
 * @param {*} reportNote 
 * @param {*} otherCfg 
 * @param {*} handelHttpsPicCallback ͼƬ��ֵתΪbase64֮��Ļص�����
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
            pictureDataObj[url] = 1; // ����ȥ�ظ�URL
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
 * @param inlist �б�����
 * @param len ����
 * @returns ��ֺõ��б�����
 */
function splitInlistByLen(inlist, len) {
    if(!inlist) {
        return inlist;
    }
    var arrResult = [];
    var c2 = String.fromCharCode(2);
    var trArr = inlist.split(c2); // ��
    for (var index = 0; index < trArr.length; index++) {
        var tdArr = trArr[index].split("^"); // ��
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
 * ���ֽ�������ַ�Ϊ���鷵�� hz
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
///����TEXTģʽ��ӡList����
function LODOP_CreateListByText(LODOP, invXMLDoc, inpara, inlist, jsonArr, otherCfg) {
    if (!inlist) return;
    var modelConfig = getListModelConfig(invXMLDoc, otherCfg);
	if (!modelConfig && !modelConfig.prtItemArr) return;
    // ����ÿ�еĴ�ӡ���ݣ����з��顣 pageDataArr[i] = oneLineItems
    var pageDataArr = getAllPrintData(inlist, modelConfig);
	// ÿҳ��ӱ��ͷ����
	pageDataArr = addTableHeader(otherCfg, modelConfig, pageDataArr);
    // �����ҳ ���������иߡ�
    var pageArr = splitDataToPage(modelConfig, pageDataArr, otherCfg);
    // ������б��
    var slashPrintItem = printBackSlash(pageArr[pageArr.length - 1], modelConfig);
    // ͳһ��ӡ��
    for (var i = 0; i < pageArr.length; i++) {
        var onePageItem = pageArr[i]; // ��ӡÿҳ���ȴ�ӡ���е��������ٴ�ӡԪ��
        printTableLine(LODOP, onePageItem, otherCfg, modelConfig); // ��ӡ��
		// ��ӡÿҳ�� ÿ��Ԫ��
        for (var j = 0; j < onePageItem.length; j++) {
            var oneLineItem = onePageItem[j];
            for (var k = 0; k < oneLineItem.length; k++) {
                LODOP_PrintItem(LODOP, oneLineItem[k]);
            }
        }
        if (i + 1 != pageArr.length) {
            LODOP.NEWPAGE();
        } else {
			// ���һҳ��������б��
            if (slashPrintItem && slashPrintItem.type) LODOP_PrintItem(LODOP, slashPrintItem);
			// ���һҳ�������ӡ��б��
			printBackSlashSpecial(LODOP, otherCfg, pageArr[pageArr.length - 1], modelConfig);
        }
    }
}
function addTableHeader(otherCfg, modelConfig, pageDataArr) {
	if (!otherCfg || !otherCfg.tableHeader) {
		return pageDataArr;
	}
	var headerLine = cloneObj(modelConfig.prtItemArr); // cloneObj ����Ҫ������ÿҳ�Ṳ��һ���������͵Ķ���
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
        var oneLineItem = []; // ÿ�п�ʼ��ʼ��
        var dataArr = inlistArr[ila].split("^");
        var oneLineWrapFlag = false;
        for (var j = 0; j < modelConfig.prtItemArr.length; j++) {
            var prtItemModel = modelConfig.prtItemArr[j];
            var prtItem = cloneObj(prtItemModel);
            if (dataArr[j]) {
                prtItem.value = dataArr[j];
            }
            // ����ֵ�ģ��������͵Ĵ���   
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
            // ����ı������ģ�������
            if (prtItem.type == "text" && prtItem.value) {
                var printItemList = splitTextByWidth(prtItem, 2); // 2 ��ʾֻ��Ԫ�أ����õ���Y����
				if (printItemList.length > 1) {
					oneLineItem.push(printItemList); // ���еģ��ŵ�������[]�����еķŵ���{}
				} else {
					oneLineItem.push(printItemList[0]); // ���еģ��ŵ�������[]�����еķŵ���{}
				}				
                for (var plt = 1; plt < printItemList.length; plt++) {
                    var printItemListObj = printItemList[plt];
                    printItemListObj.textWrapFlag = true; // ͬһ���ı��ı�ǣ����ڱ߿��ߵ��жϡ�
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
    XMLModelConfig.xmlBackSlashWidth = xmlBackSlashWidth; // б�߿�
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
            // otherCfg.tdnowrap �����˲����У���� 800 �Ŀ�ȣ������ú�һ�е�λ�ü����ȡ�
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
            // �������µ�һҳ�ˡ�
			if (i != 0) pageArr.push(onePageItem);			
            onePageItem = []; // ÿҳ��ʼ��ʼ��
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
// �ڶ�ҳ��ӡ����ʱ��ϣ����ֽ�ŵĶ��Ͽ�ʼ��ӡ��
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
	var xPoint = []; // ͳ�Ʊ߿��ߵ�X�����б�
    var modify = 0.66;
	// x ���겻�ô�ӡ����ͳ�ƣ���Ϊ��һ���е���Ϊ�գ���ͳ�Ʋ����ˣ���ģ�������ͳ�ơ�
    var oneLineItem = modelConfig.prtItemArr;
    for (var i = 0; i < oneLineItem.length; i++) {
        xPoint.push(oneLineItem[i].x - modify);
    }
    xPoint.push(oneLineItem[oneLineItem.length - 1].x + parseFloat(oneLineItem[oneLineItem.length - 1].width));
    var yPoint = [];
	// y ��������ô�ӡ����ͳ�ƣ���Ϊÿһ�е�oneLineItem�ĵ�һ��Ԫ�أ���һ���ǵ�һ�еģ�һ���Ƿǿյġ����� y ����һ����ֵ��
    for (var i = 0; i < onePageItem.length; i++) {
        yPoint.push(onePageItem[i][0].y - modify);
    }
    yPoint.push(onePageItem[onePageItem.length - 1][0].y + parseFloat(rowHeight));
    // ������
    if (otherCfg && otherCfg.tableBorderColumnArr) {
        for (var i = 0; i < otherCfg.tableBorderColumnArr.length; i++) {
            var index = otherCfg.tableBorderColumnArr[i] - 1; // ֻ���������˵����ߡ�
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
		// ������
		for (var i = 0; i < yPoint.length; i++) {
			var mustPrintFlag = false;
			if (otherCfg && otherCfg.tableHeader && i == 1) {
				mustPrintFlag = true; // ��ҳ��ӡ���Ҵ�ӡ�˱�ͷ�ģ�����Ҫ�����ߡ�
			}
			if (!mustPrintFlag && i < yPoint.length - 1 && onePageItem[i][0].textWrapFlag) continue; // �м任�еģ��������ߡ�
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
    if (modelConfig.xmlPageRows == onePageItem.length) return slashPrintItem; // ����
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
	// list��ӡ���,�ص�
	if (otherCfg && 'function' == typeof otherCfg.listAfterCallback) {
		otherCfg.listAfterCallback({
			PrinterObj: LODOP,
			tableTop: modelConfig.tableTop, // ����topλ��
			tableLeft: modelConfig.tableLeft, // ����leftλ��
			rowHeight: modelConfig.rowHeight, // ÿһ�е��и߶���
			y: modelConfig.tableTop + ((onePageItem.length + 1) * modelConfig.rowHeight), // �е���ʼyλ��
			x: modelConfig.tableLeft, // �е���ʼxλ��
			currPageRowNo: onePageItem.length, // *��ǰ�к�
			pageRows: modelConfig.xmlPageRows, // һҳ��ӡ����������
			backSlashWidth: modelConfig.xmlBackSlashWidth // ���б�߿��
		});
	}
}
// type ��2 ��ʾֻ��Ԫ�أ����õ���Y����
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
		// oneLineWidth - unitWidth ��Ԥ��һ���ַ��ļ����
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
    // ��ֵ��ָ��ӡ���ַ��ĸ߶ȵĶ�����λ����ֵ��1 ������ 1/72 Ӣ�磬���Լ���� 1 ���׵� 1/28 0.376����
    var num = fontSize * 0.376;
    num = num.toFixed(3); // ���س������Ժ���Ϊ��λ����ֵ��
    return num;
}
// ԭ�����ӣ�https://blog.csdn.net/weixin_46074961/article/details/122412958
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
