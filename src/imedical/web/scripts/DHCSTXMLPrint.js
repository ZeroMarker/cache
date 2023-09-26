//DHCSTXMLPrint.js
//liangjiaquan 2016-01-19
//last: xml所有转换处理全在此(json转xml,xml转html预览)
PrtAryData=new Array()
function DHCSTPrintFun(inpara,inlist){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
			
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false; 
		var rtn=docobj.loadXML(mystr);
        
		if ((rtn)){
			var PObj=new ActiveXObject("DHCOPPrint.ClsBillPrint")
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}
//shr 妇幼7.0 20150811
function DHCSTPrintFunNew(inpara,inlist){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
				
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		
		if ((rtn)){
			var PObj=new ActiveXObject("DHCOPPrint.ClsBillPrint")
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}



function DHCSTGetXMLConfig(PFlag){
	try{		
		PrtAryData.length=0
		var PrtConfig=tkMakeServerCall("web.DHCXMLIO","ReadXML","DHCP_RecConStr",PFlag);
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}


function DHCP_RecConStr(ConStr){
	PrtAryData[PrtAryData.length]=ConStr;
	
}

function DHCP_TextEncoder(transtr){
	if (transtr.length==0){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCWeb_replaceAll(dst, '\\"', '\"');
		dst = DHCWeb_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCWeb_replaceAll(dst, "\\r", "\r");
		dst = DHCWeb_replaceAll(dst, "\\n", "\n");
		dst = DHCWeb_replaceAll(dst, "\\t", "\t");
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

function DHCWeb_replaceAll(src,fnd,rep) { 
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
///
/// Json格式化为xml打印的格式
function DHCSTXMLPrint_JsonToXml(prtJson,preView){
	var para=prtJson.Para||"";
	var list=prtJson.List||[];
	var templet=prtJson.Templet||"";
	var morePara=prtJson.MorePara||"";
	var pageItms="";
	if (morePara!=""){
		pageItms=morePara.PageItms||"";
	}
	// Param
	var xmlPara="";
	for (var mId in para){
		var mIdData=para[mId]||"";
		if (xmlPara==""){
			xmlPara=mId+String.fromCharCode(2)+mIdData;
		}else{
			xmlPara+="^"+mId+String.fromCharCode(2)+mIdData;
		}
	}
	// List
	var xmlList="",xmlList1="";
	var listLen=list.length;
	for (var listI=0;listI<listLen;listI++){
		var listIData=list[listI];
		if (xmlList==""){
			xmlList=listIData
		}else{
			xmlList+=String.fromCharCode(2)+listIData
		}
	}
	return {
		xmlPara:xmlPara,
		xmlList:xmlList,
		xmlTemplet:templet,
		xmlList1:xmlList1
	}			
}

/// xml转html预览
var DHCSTXMLPrint_Preview={
	NewCtrlArr:[],
	Html:"",
	JsonData:{},
	JsonToHtml:function(jsonData){
		this.NewCtrlArr=[];
		if (jsonData==null){
			return;
		}
		this.JsonData=jsonData;
		var templetCode=jsonData.Templet;
		var xmlData=this.GetTempXml(templetCode);
		var pageNode = xmlData.childNodes[0].childNodes[1];
		var count = pageNode.childNodes.length; 
	    for (var index = 0; index <count; index++) {
            var oneNode = pageNode.childNodes[index];
            if (oneNode.nodeType==3){	// #text,直接过滤
	        	continue;
	        }
            var childCount = oneNode.childNodes.length;
            var oneNodeName=oneNode.nodeName.toUpperCase();
			if (childCount > 0) {
	            switch (oneNodeName) {
	                case "TXTDATA":
	                	//break
	                    this.ToLabel(oneNode);
	                    break;
		           	case "PLDATA":
		           		//break
	                    this.ToLine(oneNode);
	                    break;
                	case "LISTDATA":
                        this.ToList(oneNode);
                    	break;
                	case "PICDATA":
                	break
                        this.ToImage(oneNode);
                        break;
	                default:
	                    break;
	            }
			}
        }
        return this.Html;
	},
	GetTempXml:function(templetCode){
		var templetId=tkMakeServerCall("web.DHCDocPrescript","GetXMLTemplateId",templetCode);
		var xmlParam = [{ name: 'ExcuteAction', value: 'ReadOne' }, { name: 'reportID', value: templetId}];
		var retXml;
	    $.ajax({
	        type: 'POST',
	        url: "../../web.DHCPrintDesigner.cls",
	        async:false,		// 同步
	        data: xmlParam,
	        dataType: 'xml',
	        success: function(xmlData) {
		        retXml=xmlData;
	        },
	        error: function(XMLHttpRequest, textStatus, errorThrown) {
	            alert("获取xml模板失败!");
	        }
	    });
	    return retXml
		
	},
	ToLabel:function(labelNodes){
	    var count = labelNodes.childNodes.length;
	    for (var index = 0; index <count; index++) {
	        var oneNode = labelNodes.childNodes[index];
	        if (oneNode.nodeType==3){
		    	continue;
		    }
	        var cId = this.GetNewCtrlId("label");
	        var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
	        ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + this.ConvertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + this.ConvertPtToPx(oneNode.getAttribute("yrow")) + "px;";
	        if (oneNode.getAttribute("fontsize") != "12") {
	            ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
	        }else{
		       	ctrlHtml = ctrlHtml + "font-size:" + 12 + "pt;";
		    }
	        if (oneNode.getAttribute("fontbold") == "true") {
	            ctrlHtml = ctrlHtml + "font-weight:bold;";
	        }else{
		        ctrlHtml = ctrlHtml + "font-weight:normal;";
		    }
	        if (oneNode.getAttribute("fontname") != "") {
	            ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
	        }else{
		       	ctrlHtml = ctrlHtml + "font-family:" + "宋体" + ";";
		    }
	        ctrlHtml = ctrlHtml + "' ";
	        var printValue = this.JsonData.Para[oneNode.getAttribute("name")];
	        if (printValue) {
	            ctrlHtml = ctrlHtml + ">" + printValue.replace(/\s/g, "&nbsp;") + "</label>";
	        }
	        else if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
	            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue").replace(/\s/g, "&nbsp;") + "</label>";
	        }
	        else {
	            ctrlHtml = ctrlHtml + "></label>";
	        }
	        this.Html+=ctrlHtml;
	    }
	},
	ToLine:function(lineNodes){
	    var count = lineNodes.childNodes.length;
	    for (var index = 0; index < count; index++) {
	        var oneNode = lineNodes.childNodes[index];
	        if (oneNode.nodeType==3){
		    	continue;
		    }
	        var cId = this.GetNewCtrlId("shape");
	        var ctrlHtml='<div ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
	        var BeginX = this.ConvertPtToPx(oneNode.getAttribute("BeginX"));
	        var BeginY = this.ConvertPtToPx(oneNode.getAttribute("BeginY"));
	        var EndX = this.ConvertPtToPx(oneNode.getAttribute("EndX"));
	        var EndY = this.ConvertPtToPx(oneNode.getAttribute("EndY"));
	        BeginX=BeginX<0?0:BeginX;
	        BeginY=BeginY<0?0:BeginY;
	       	EndX=EndX<0?0:EndX;
	       	EndY=EndY<0?0:EndY;
	        var width = EndX - BeginX;
	        var height = EndY - BeginY;
	        width=width<0?0:width;
	        height=height<0?0:height;
	        if (height == 0 && width != 0) {
	            if (width > 0) {
	                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-top-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;"></div>';
	            }
	            else {
	                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-bottom-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;"></div>';
	            }
	        }
	        else if (width == 0 && height != 0) {
	            if (height > 0) {
	                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:'+height+'px;"></div>';
	            }
	            else {
	                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:'+height+'px;"></div>';
	            }
	        }
			this.Html+=ctrlHtml;
	    }
	},
	ToImage:function(){},
	ToList:function(listNodes){
		// 几个list啊,一个xml模板也就一个list,至少处方是
		var listLen=listNodes.childNodes.length;
		if(listLen==0){
			return;
		}
  		var listData=this.JsonData.List;
		var listDataLen=listData.length;
		var listHtml=""
    	for (var listDataI = 0; listDataI <listDataLen; listDataI++) {	// 数据行数		
	        var cId = this.GetNewCtrlId("list");
	        var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
	        ctrlHtml = ctrlHtml + "CurrentRow='" + listNodes.getAttribute("CurrentRow") + "' ";
	        if (listNodes.getAttribute("PageRows") != "1") {
	            ctrlHtml = ctrlHtml + "PageRows='" + listNodes.getAttribute("PageRows") + "' ";
	        }
	        var listYStep=listNodes.getAttribute("YStep");
	        var listXStep=listNodes.getAttribute("XStep");
	        if ( listXStep!= "0") {
	            ctrlHtml = ctrlHtml + "XStep='" + listXStep + "' ";
	        }
	        var listHeight=this.ConvertPtToPx(listYStep);
	        var postion = this.GetStartXY(listNodes);
	        // xcol yrow 为坐标，List内，以list左上为0
	        var padTop = 0;
	        //if (listNodes.getAttribute("CurrentRow") != "0") {
	        //    padTop = listHeight * parseInt(listNodes.getAttribute("CurrentRow"), 10);
	       // }
	        var yPosition = postion[1]+(listDataI+1)*listHeight;	// cab打印这有bug啊
	        ctrlHtml = ctrlHtml + "style='position:absolute;left:" +0 + "px;top:" + yPosition + "px;width:" + (postion[2] + 100) + "px;height:" + listHeight + "px;'>";		
			var listItmData=listData[listDataI]
			var listICnt=0
			for (var listI=0;listI<listLen;listI++){
				var oneNode=listNodes.childNodes[listI];
				if (oneNode.nodeType==3){
					continue;
				}
				var oneListItm=listItmData.split("^")[listICnt]||"";
				oneListItm=oneListItm.toString();	
	            childHtml =  this.FmtToListItm(oneNode, postion[0], postion[1], oneListItm);
	            ctrlHtml=ctrlHtml+childHtml
	        	listICnt++;		
			}
			listHtml+=ctrlHtml+"</div>";
	    }
	    this.Html+=listHtml;

	},
	FmtToListItm:function(oneNode, startX, startY,showValue){
		// 返回,仅为一个小listitm
	    var cId = this.GetNewCtrlId("label");
	    var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
	    ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + (this.ConvertPtToPx(oneNode.getAttribute("xcol"))) + "px;top:" + (this.ConvertPtToPx(oneNode.getAttribute("yrow")) -startY) + "px;"
	    if (oneNode.getAttribute("fontsize") != "12") {
	        ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
	    }else{
		   	ctrlHtml = ctrlHtml + "font-size:" +12 + "pt;";
		}
	    if (oneNode.getAttribute("fontbold") == "true") {
	        ctrlHtml += "font-weight:bold;";
	    }else{
		    ctrlHtml +=  "font-weight:normal;";
		}
	    if (oneNode.getAttribute("fontname") != "") {
	        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
	    }else{
			ctrlHtml = ctrlHtml + "font-family:" + "宋体" + ";";
		}
	    ctrlHtml = ctrlHtml + "' ";
	    if (showValue == "") {
	        if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
	            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
	        }else{
		        ctrlHtml = ctrlHtml + ">" + "</label>";
		    }
	    }else {
	        //ctrlHtml = ctrlHtml + ">" + showValue.replace("", "&nbsp;&nbsp;") + "</label>";
	        ctrlHtml = ctrlHtml + ">" + showValue + "</label>";
	    }
	    return ctrlHtml;		
	},
	SubFloat:function(num, v) {
	    var vv = Math.pow(10, v);
	    return Math.round(num * vv) / vv;
	},
	ConvertPtToPx:function(ptValue) {
		// 将xml中的pt转化为px
    	return this.SubFloat((parseFloat(ptValue, 10)) * 3.78, 0);
	},
	GetStartXY:function(xyNode){
		// 坐标
	    var count = xyNode.childNodes.length;
	    var startX = null;
	    var startY = null;
	    var endX = null;
	    var endY = null;
	    for (var index = 0; index <count; index++) {
	        var oneNode = xyNode.childNodes[index];
	        if (oneNode.nodeType==3){
		    	continue;
		    }
	        var xcol = parseFloat(oneNode.getAttribute("xcol"), 10);
	        var yrow = parseFloat(oneNode.getAttribute("yrow"), 10);
	        if (startX == null) {
	            startX = xcol;
	        }
	        else {
	            if (xcol < startX) {
	                startX = xcol;
	            }
	        }
	        if (startY == null) {
	            startY = yrow;
	        }
	        else {
	            if (yrow < startY) {
	                startY = yrow;
	            }
	        }

	        if (endX == null) {
	            endX = xcol;
	        }
	        else {
	            if (xcol > endX) {
	                endX = xcol;
	            }
	        }
	        if (endY == null) {
	            endY = yrow;
	        }
	        else {
	            if (yrow > endY) {
	                endY = yrow;
	            }
	        }
	    }
	    var result = Array();
	    result.push(this.ConvertPtToPx(startX));
	    result.push(this.ConvertPtToPx(startY));
	    result.push(this.ConvertPtToPx(endX - startX));
	    result.push(this.ConvertPtToPx(endY - startY));
	    return result;

	},
	GetNewCtrlId:function(ctrlType) {
		if (this.NewCtrlArr[ctrlType]) {
			this.NewCtrlArr[ctrlType]++;
		} else {
			this.NewCtrlArr[ctrlType] = 1;
		}
		return ctrlType + "_" + this.NewCtrlArr[ctrlType];
	}
}