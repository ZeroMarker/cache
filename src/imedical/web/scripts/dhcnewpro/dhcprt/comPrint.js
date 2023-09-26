/**
 * �ṩ�������¼���ӡ����
 * ��ӡ�Ѿ�����IE8,ά��ģ�����ùȸ����IE11���ϵ������
 */
 
/*
*��ӡ��������Ҫ�����ʼ��Lodop��ӡ
*Input: ��ӡģ���code,��ֵ��json���ݣ�json��name��ģ��ID��Ӧ
*		setObj:��ӡ���ã�
*setObj:
*	marginLeft:��߾�
*/
function dhcprtPrint(prtCode,prtData,setObj){
	var defSetObj={
			"model":"print",
			"marginTop":"3mm",
			"marginLeft":"3mm",
			"marginRight":"0mm",
			"marginBottom":"3mm",
			"orient":1,
			"pageName":"A4",
			"oIndexOrName":"",
			"heardAndBot":"",
			"pagingGranularity":"",
			"tablePosTop":""
		}
	var tempAllObj={},tempSetObj={},tempDomArr=[];
	
	var prtTempData = serverCall("web.DHCPRTMain","GetTmpData",{MACode:prtCode});
	var retObj={};
	PageWidth = prtTempData.split("&&")[3]+"mm";
	PageHeight = prtTempData.split("&&")[4]+"mm";
	prtTempData = prtTempData.split("&&")[7];
	
	if((prtTempData=="")||(prtTempData==undefined)){
		retObj.code=-1001;
		retObj.errInfo="ģ���ȡ����!���ģ�������Ƿ����!";
		return retObj;
	}
	
	if(!typeof(prtData) == 'object') {
		retObj.code=-1002;
		retObj.errInfo="��ӡ��δ���,��ʽӦΪObject����";
		return retObj;
	}
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	
	var err="";
	var lodopIndex=1;	///index��ţ����ô�ӡԪ����Ҫ
	err = prePrintInit();
	html = prtTempData.saveOrShowDataFormatNew("show");
	html = html.prtDataFormatDom(prtData);
	html = html.prtDataFormatCheck(prtData);
	html = html.prtDataFormat(prtData);
	tempAllObj=html.prtTempPageSet();
	tempDomArr=tempAllObj.objDom;	  ///��ͷ����
	tempSetObj=tempAllObj.objPage;    ///��������
	html = html.prtClearHideDataFormat();
	err = proPrintInit();
	
	tempSetObj = $.extend(defSetObj,tempSetObj);
	setObj = $.extend(tempSetObj,setObj);
	LODOP.SET_PRINT_PAGESIZE(setObj.orient,"","",setObj.pageName)
	LODOP.SET_PRINT_MODE("TRYLINKPRINTER_NOALERT",true);
	defSetObj.oIndexOrName==""?"":LODOP.SET_PRINTER_INDEX(defSetObj.oIndexOrName);
	setObj.tablePosTop==""?setObj.marginTopHasTab=setObj.marginTop:setObj.marginTopHasTab=parseFloat(setObj.marginTop)+parseFloat(setObj.tablePosTop)+"mm";
	LODOP.ADD_PRINT_HTM(setObj.marginTopHasTab,setObj.marginLeft,"RightMargin:"+setObj.marginRight,"BottomMargin:"+setObj.marginBottom,html);
	setObj.pagingGranularity==""?LODOP.SET_PRINT_STYLEA(0,"TableRowThickNess",30):LODOP.SET_PRINT_STYLEA(0,"TableRowThickNess",setObj.pagingGranularity);
	
	if(tempDomArr.length!=0){
		var len = tempDomArr.length;
		for (var i=0;i<len;i++){
			var itmDomObj=tempDomArr[i];
			var tagName=itmDomObj.domTagName;
			var left=(parseFloat(setObj.marginLeft)+parseFloat(itmDomObj.domMarLeft))+"mm";
			var top=(parseFloat(setObj.marginTop)+parseFloat(itmDomObj.domMarTop))+"mm";
			var width=itmDomObj.domWidth+"mm";
			var height=itmDomObj.domHeight+"mm";
			var url = itmDomObj.domUrl;
			var text=itmDomObj.domText;
			var html=itmDomObj.domHtml;
			var fontSize=itmDomObj.fontSize;
			var fontWeight=(itmDomObj.fontWeight>400?1:0);
			if(tagName=="IMG"){
				lodopIndex++;
				var imgUrlHtml="<img src='"+url+"' border='0'>";
				LODOP.ADD_PRINT_IMAGE(top,left,width,height,imgUrlHtml);
				LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",1000)//������һ���ӳٳ��ı�����1000����
				LODOP.SET_PRINT_STYLEA(0,"Stretch",1);
			}else{
				lodopIndex++;
				LODOP.ADD_PRINT_TEXT(top,left,width,height,text);
				LODOP.SET_PRINT_STYLEA(lodopIndex,"FontSize",fontSize);
				fontWeight==1?LODOP.SET_PRINT_STYLEA(lodopIndex,"Bold",1):"";
			}
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		}	
	}
	
	if(setObj.heardAndBot!=""){
		var heardAndBotArr = setObj.heardAndBot.split("!!");
		var len = heardAndBotArr.length;
		for(var j=0;j<len;j++){
			var itmArr = heardAndBotArr[j].split("@@");
			var text = itmArr[0];
			var left = itmArr[1]+"mm";
			var top = itmArr[2]+"mm";
			var page =itmArr[3]; 
			lodopIndex++;
			LODOP.ADD_PRINT_TEXT(top,left,"40mm","10mm",text);
			page=="1"?LODOP.SET_PRINT_STYLEA(0,"ItemType",2):LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		}
	}
	
	var prtRet="";
	if(setObj.model=="print"){
		prtRet=LODOP.PRINT();
	}else if(setObj.model=="view"){
		prtRet=LODOP.PREVIEW();
	}
	retObj.code=prtRet;
	if(prtRet) retObj.errInfo="�ɹ���ӡ��";
	if(!prtRet) retObj.errInfo="ʧ�ܣ�";
	return retObj;
}

///Descript:String��չ���ش�ӡ���ݷ���
String.prototype.prtDataFormat = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	_s = _s.replace(new RegExp("��", "g"), "");
	
	if(typeof(param) == 'object') {
	for(var key in param)
		_s = _s.replace(new RegExp("\\[" + key + "\\]", "g"), param[key]);
	} else {
		for(var i = 0; i < arguments.length; i++)
		_s = _s.replace(new RegExp("\\[" + i + "\\]", "g"), arguments[i]);
	}
	_s = _s.replace(new RegExp("\\[.*?\\]", "g"), "");  ///δƥ��ֱֵ�����
	return _s;
}

///Descript:�ú�ģ�������ϴ�ӡֽ�ŵ�����
String.prototype.prtTempPageSet = function(){
	var _s = this;
	var doc="";
	if (typeof window.DOMParser != "undefined") {   ///Google����IE11�߰汾�����
		parser = new DOMParser();
		doc = parser.parseFromString(_s, "text/html");
	}else{
		$("#domFomatArea").html(_s);
		doc = $("#domFomatArea");
	}
	
	var allRet={},objPage={},objDom=[];    			///������������������ҳ�����ã���ͷԪ�أ��Լ��������λ��
	var printerName = $getValue($("#p-panel",doc).attr("printerName"));
	var prtDirection = $getValue($("#p-panel",doc).attr("prtDirection"));
	var prtPageName = $getValue($("#p-panel",doc).attr("prtPageName"));
	
	var marginTop = $getValue($("#p-panel",doc).attr("marginTop"));
	var marginBottom = $getValue($("#p-panel",doc).attr("marginBottom"));
	var marginLeft = $getValue($("#p-panel",doc).attr("marginLeft"));
	var marginRight = $getValue($("#p-panel",doc).attr("marginRight"));
	var heardAndBot = $getValue($("#p-panel",doc).attr("heardAndBot"));
	var pagingGranularity = $getValue($("#p-panel",doc).attr("pagingGranularity"));
	var tablePosTop = $getValue($("#p-panel>table",doc)[0].style.marginTop);
	
	var $tabDomDoc = $(".p-itmp-tabTitle",doc);
	var tabDomDocLen=$tabDomDoc.length;
	for(var i=0;i<tabDomDocLen;i++){
		var objDomItem={};
		objDomItem.domTagName=$tabDomDoc[i].tagName;
		objDomItem.domMarLeft=objDomItem.domTagName=="IMG"?parseFloat($getValue($tabDomDoc[i].style.marginLeft)):parseFloat($getValue($tabDomDoc[i].style.left));
		objDomItem.domMarTop=objDomItem.domTagName=="IMG"?parseFloat($getValue($tabDomDoc[i].style.marginTop)):parseFloat($getValue($tabDomDoc[i].style.top));
		objDomItem.domWidth=$getValue($tabDomDoc[i].style.width)==""?40:parseFloat($tabDomDoc[i].style.width);
		objDomItem.domHeight=$getValue($tabDomDoc[i].style.height)==""?10:parseFloat($tabDomDoc[i].style.height);
		objDomItem.fontSize=$getValue($tabDomDoc[i].style.fontSize)==""?10:parseFloat($tabDomDoc[i].style.fontSize);
		objDomItem.fontWeight=$getValue($tabDomDoc[i].style.fontWeight)==""?0:parseFloat($tabDomDoc[i].style.fontWeight);
		objDomItem.domUrl = $getValue($tabDomDoc[i].src);
		objDomItem.domHtml=$getValue($tabDomDoc[i].outerHTML);
		objDomItem.domText=$getValue($tabDomDoc[i].innerHTML);
		objDom.push(objDomItem);
	}
	
	
	prtDirection==""?"":objPage.orient = prtDirection;
	prtPageName==""?"":objPage.pageName=prtPageName;
	prtDirection==""?"":objPage.oIndexOrName=prtDirection;
	marginTop==""?"":objPage.marginTop=parseFloat(marginTop)+"mm";
	marginLeft==""?"":objPage.marginLeft=parseFloat(marginLeft)+"mm";
	marginRight==""?"":objPage.marginRight=parseFloat(marginRight)+"mm";
	marginBottom==""?"":objPage.marginBottom=parseFloat(marginBottom)+"mm";
	heardAndBot==""?"":objPage.heardAndBot = heardAndBot;
	pagingGranularity==""?"":objPage.pagingGranularity = pagingGranularity;
	tablePosTop==""?"":objPage.tablePosTop = parseFloat(tablePosTop)+"mm";
	
	allRet.objPage=objPage;
	allRet.objDom=objDom;
	return allRet;
}

///Descript:String��չ���ش�ӡ���ݷ���:����������չ����DOm����
String.prototype.prtDataFormatDom = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	_s = _s.replace(new RegExp("��", "g"), "");
	
	if (typeof window.DOMParser != "undefined") {   ///Google����IE11�߰汾�����
		parser = new DOMParser();
		doc = parser.parseFromString(_s, "text/html");
		_l=doc.getElementsByClassName("extendTr").length;
		for (i=0;i<_l;i++){
			_id=doc.getElementsByClassName("extendTr")[0].getAttribute("id");
			if(_id==null) continue;
			
			doc.getElementsByClassName("extendTr")[0].removeAttribute("class");
			_nh = $("#"+_id,doc)[0].outerHTML;
			if(typeof(param[_id])=="object"){
				_i=param[_id].length;
				for(j=1;j<_i;j++){
					$("#"+_id,doc).after(_nh);
				}
				
				for (ii in param[_id]){
					for (j in param[_id][ii]){
						if($("td[id='"+j+"']",doc)[ii]){
							$("td[id='"+j+"']",doc)[ii].innerHTML=param[_id][ii][j];
						}
					}
				}
			}
		}
		return $("body",doc).html();
	}else{
		$("#domFomatArea").html(_s);
		$doc = $("#domFomatArea");
		_l=$doc.find(".extendTr").length;
		for (i=0;i<_l;i++){
			_id=$doc.find(".extendTr")[0].getAttribute("id");
			if(_id==null) continue;
			
			$doc.find(".extendTr").eq(0).removeAttr("class");
			_nh = $doc.find("#"+_id)[0].outerHTML;
			if(typeof(param[_id])=="object"){
				_i=param[_id].length;
				for(j=1;j<_i;j++){
					$($doc.find("#"+_id)[0],$doc).after(_nh);
				}
				
				for (ii in param[_id]){
					for (j in param[_id][ii]){
						if($("td[id='"+j+"']",$doc)[ii]){
							$("td[id='"+j+"']",$doc)[ii].innerHTML=param[_id][ii][j];
						}
					}
				}
			}
		}
		return $("#domFomatArea").html();
	}
}
String.prototype.prtDataFormatCheck=function(){
	if(arguments.length == 0) return this;
	var param = $getValue(arguments[0].CheckItem);
	if(param=="") return this;
	var paramArr=param.split(",");
	var len=paramArr.length;
	var _s = this;
	if (typeof window.DOMParser != "undefined") {   ///Google����IE11�߰汾�����
		parser = new DOMParser();
		doc = parser.parseFromString(_s, "text/html");
		for(var i=0;i<len;i++){
			$("input[type='checkbox'][id='"+paramArr[i]+"']",doc).attr("checked",true);
			$("input[type='radio'][id='"+paramArr[i]+"']",doc).attr("checked",true);
		}
		return $("body",doc).html();
	}else{
		$("#domFomatArea").html(_s);
		$doc = $("#domFomatArea");
		for(var i=0;i<len;i++){
			$("input[type='checkbox'][id='"+paramArr[i]+"']",$doc).attr("checked",true);
			$("input[type='radio'][id='"+paramArr[i]+"']",$doc).attr("checked",true);
		}
		return $("#domFomatArea").html();
	}
}

String.prototype.prtClearHideDataFormat=function(){
	var _s = this;
	var doc;
	if (typeof window.DOMParser != "undefined") {
		parser = new DOMParser();
		doc = parser.parseFromString(_s, "text/html");
	}else{
		$("#domFomatArea").html(_s);
		doc = $("#domFomatArea")[0];
	}
	
	$("#p-panel>table",doc).removeCss("margin-top");
	$("#p-panel>table",doc).removeCss("MARGIN-TOP");
	$("#p-panel>table",doc).find("tr").each(function(){
		$(this).removeCss("height");
		$(this).removeCss("HEIGHT");	
	})
	$("td[style*='display']",doc).remove();
	$(".p-itmp-tabTitle",doc).remove();
	
	if (typeof window.DOMParser != "undefined") {
		return $("body",doc).html();
	}else{
		return $("#domFomatArea").html();
	}
}

///Descript:���淽���ֶι������滻�����ظ��ַ�Ϊ�̶���ʽ
String.prototype.saveOrShowDataFormat = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	if(param=="save"){
		_s=_s.replace(new RegExp('<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;',"g"),'Ms.H');
	}else if(param=="show"){
		_s=_s.replace(new RegExp('Ms.H',"g"),'<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;');
	}
	return _s;
}


///Descript:���淽���ֶι������滻�����ظ��ַ�Ϊ�̶���ʽ:ԭ�з������ַ�����̫ʵ�ã�
String.prototype.saveOrShowDataFormatNew = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	if(param=="save"){
		_s=_s.replace(new RegExp('<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;',"g"),'Ms.H');  //�ϰ汾����
		_s=_s.replace(new RegExp('<td class="p-itmp" style="font-size:',"g"),'Ms.A');
		_s=_s.replace(new RegExp('mm; box-sizing: border-box; border-left: 1px solid rgb\\(0\\, 0\\, 0\\); border-top: 1px solid rgb\\(0\\, 0\\, 0\\);',"g"),'Ms.B');
		_s=_s.replace(new RegExp('mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;',"g"),'Ms.B');
		_s=_s.replace(new RegExp('mm; width:',"g"),'Ms.C');
		_s=_s.replace(new RegExp('mm;width:',"g"),'Ms.C');
		_s=_s.replace(new RegExp('display: none;',"g"),'Ms.D');
		_s=_s.replace(new RegExp('display:none;',"g"),'Ms.D');
		_s=_s.replace(new RegExp('max-width:',"g"),'Ms.E');
		_s=_s.replace(new RegExp('mm;">',"g"),'Ms.F');
		_s=_s.replace(new RegExp('mm"></td>">',"g"),'Ms.G');
		_s=_s.replace(new RegExp('<td class="p-itmp" style="width:',"g"),'Ms.I');
		_s=_s.replace(new RegExp('border-top-color: rgb\\(0\\, 0\\, 0\\); border-left-color: rgb\\(0\\, 0\\, 0\\); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;',"g"),'Ms.J');
		_s=_s.replace(new RegExp('mm; box-sizing: border-box;',"g"),'Ms.K');
		_s=_s.replace(new RegExp('mm;box-sizing:border-box;',"g"),'Ms.K');
		_s=_s.replace(new RegExp('mm; font-size:',"g"),'Ms.L');	
		_s=_s.replace(new RegExp('<div class="p-panel" id="p-panel" style="width:',"g"),'Ms.M');
		_s=_s.replace(new RegExp('display: inline-block; position: relative; min-height:',"g"),'Ms.N');
		_s=_s.replace(new RegExp('border-right-color: rgb\\(0\\, 0\\, 0\\); border-bottom-color: rgb\\(0\\, 0\\, 0\\); border-right-width: 1px; border-bottom-width: 1px; border-right-style: solid; border-bottom-style: solid; table-layout: fixed; box-sizing: border-box;" cellspacing="0" cellpadding="0">',"g"),'Ms.O');
		_s=_s.replace(new RegExp('mm; border-top:1px solid #000; border-left:1px solid #000;',"g"),'Ms.P');
		_s=_s.replace(new RegExp('</td><td class="p-itmp" id="',"g"),'Ms.Q');
		_s=_s.replace(new RegExp('               ',"g"),'');
		_s=_s.replace(new RegExp('       ',"g"),'');
		_s=_s.replace(new RegExp('              ',"g"),'');
	}else if(param=="show"){
		_s=_s.replace(new RegExp('Ms.H',"g"),'<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;');  ///�ϰ汾����
		_s=_s.replace(new RegExp('Ms.A',"g"),'<td class="p-itmp" style="font-size: ');
		_s=_s.replace(new RegExp('Ms.B',"g"),'mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;');
		_s=_s.replace(new RegExp('Ms.C',"g"),'mm;width:');
		_s=_s.replace(new RegExp('Ms.D',"g"),'display:none;');
		_s=_s.replace(new RegExp('Ms.E',"g"),'max-width: ');
		_s=_s.replace(new RegExp('Ms.F',"g"),'mm;">');
		_s=_s.replace(new RegExp('Ms.G',"g"),'mm"></td>');
		_s=_s.replace(new RegExp('Ms.I',"g"),'<td class="p-itmp" style="width:');
		_s=_s.replace(new RegExp('Ms.J',"g"),'border-top:1px solid #000; border-left:1px solid #000;');
		_s=_s.replace(new RegExp('Ms.K',"g"),'mm;box-sizing:border-box;');
		_s=_s.replace(new RegExp('Ms.L',"g"),'mm;font-size:');
		_s=_s.replace(new RegExp('Ms.M',"g"),'<div class="p-panel" id="p-panel" style="width:');
		_s=_s.replace(new RegExp('Ms.N',"g"),'display: inline-block; position: relative; min-height:');
		_s=_s.replace(new RegExp('Ms.O',"g"),'border-right: 1px solid #000; border-bottom: 1px solid #000;table-layout:fixed; box-sizing: border-box;" cellspacing="0" cellpadding="0">');
		_s=_s.replace(new RegExp('Ms.P',"g"),'mm; border-top:1px solid #000; border-left:1px solid #000;');
		_s=_s.replace(new RegExp('Ms.Q',"g"),'</td><td class="p-itmp" id="');
	}
	return _s;
}

function prePrintInit(){
	addPrintParmasAndDom();  ///IE8�����Դ���
}

function addPrintParmasAndDom(){
	if(!$("#domFomatArea").lenght){
		$("body").append("<div style='display:none' id='domFomatArea'></div>");
	}
	return 1;
}

function proPrintInit(){
	$("#domFomatArea").remove();
	return 1;	
}


var LINK_CSP="dhcapp.broker.csp";
/**
 * �����к�̨����
 * @creater zhouxin
 * @descript ����������HISUI�ģ��˷�����������
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص�����
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
 
if(!typeof $.cm=="function"){
	runClassMethod=function (className,methodName,datas,successHandler,datatype,sync){
		var _options = {
			url : LINK_CSP,
			async : true,
			dataType : "json", // text,html,script,json
			type : "POST",
			data : {
					'ClassName':className,
					'MethodName':methodName
				   }
		};
		$.extend(_options.data, datas);
		var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
		_options=$.extend(_options, option);
		return $.ajax(_options).done(successHandler);
	}
	
	serverCall=function(className,methodName,datas){
		ret=runClassMethod(className,methodName,datas,function(){},"",false)
		return ret.responseText;
	}
}

///nice small method
function $getValue(value){
	return value==undefined?"":value;
}

///��չ���ܣ����jq�ṩɾ��ĳ��cssԪ�صĹ���
$.fn.removeCss=function(toDelete) {
	if($(this).attr('style')==undefined){
		return;
	}
	var props = $(this).attr('style').split(';');
	var tmp = -1;
	for( var p=0; p<props.length; p++) {
		if(props[p].indexOf(toDelete)!== -1 ) {
		    tmp=p
		}
	}
	if(tmp !== -1) {
        props.splice(tmp,1);
    }
    
	return $(this).attr('style',props.join(';'));
}