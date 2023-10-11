/*
ģ��:		ҩ������
��ģ��:		ҩ������-xml����ת������ȫ�ڴ�(jsonתxml,xmlתhtmlԤ��)
Creator:	hulihua
CreateDate:	2019-01-12
������ pha/dec/v2/xmlprint.js
xmlprint.js
*/
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
//shr ����7.0 20150811
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
/// Json��ʽ��Ϊxml��ӡ�ĸ�ʽ
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

///
/// Json��ʽ��Ϊxml��ӡ�ĸ�ʽ(��ҳ��ʽ��)
function DHCPHACOMXMLPrint_JsonToXml(prtJson,preView){
	var para=prtJson.Para||"";
	var list=prtJson.List||[];
	var templet=prtJson.Templet||"";
	var morePara=prtJson.MorePara||"";
	var pageItms="";
	if (morePara!=""){
		pageItms=morePara.PageItms||"";
	}
	//Param
	var xmlPara="";
	for (var mId in para){
		var mIdData=para[mId]||"";
		if (xmlPara==""){
			xmlPara=mId+String.fromCharCode(2)+mIdData;
		}else{
			xmlPara+="^"+mId+String.fromCharCode(2)+mIdData;
		}
	}
	//����Ϊ��ҳ
	var templetCode=prtJson.Templet;
	if (templetCode.indexOf("Ver")<0){
		var Onepagenum=12; 			//һҳ����
	}else{
		var Onepagenum=16; 
	}	      
    var Lastpagenum="";			 	//���һҳ������
    var PageNums="" ;   			//ҳ��
	var listLen=list.length;    	//ҩƷ������
    if(listLen%Onepagenum=="0"){
	    PageNums=listLen/Onepagenum;
	    Lastpagenum=Onepagenum;
	}else{
		PageNums=parseInt(listLen/Onepagenum)+1;
		Lastpagenum=listLen%Onepagenum;
	}
	for(var i=1;i<=PageNums;i++)
	{
		if(i==PageNums){ 
			Nums=Lastpagenum;
		}else{ 
			Nums=Onepagenum;
		}
		// List
		var xmlList="",xmlList1="";
		var n=parseInt((i-1)*Onepagenum);
		var k=n+parseInt(Nums);
		for (var listI=n;listI<k;listI++){
			var listIData=list[listI];
			if (xmlList==""){
				xmlList=listIData;
			}else{
				xmlList+=String.fromCharCode(2)+listIData;
			}
		}
		DHCSTGetXMLConfig(templet);
		DHCSTPrintFun(xmlPara,xmlList);	
	}				
}

/// xmlתhtmlԤ��
var DHCSTXMLPrint_Preview={
	NewCtrlArr:[],
	Html:"",
	JsonData:{},
	JsonToHtml:function(jsonData){
		this.NewCtrlArr=[];
		this.Html="";
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
            if (oneNode.nodeType==3){	// #text,ֱ�ӹ���
	        	continue;
	        }
            var childCount = oneNode.childNodes.length;
            var oneNodeName=oneNode.nodeName.toUpperCase();
            //alert("oneNodeName:"+oneNodeName+" oneNode:"+oneNode)
			if (childCount > 0) {
	            switch (oneNodeName) {
	                case "TXTDATA":
	                    this.ToLabel(oneNode);
	                    break;
		           	case "PLDATA":
	                    this.ToLine(oneNode);
	                    break;
                	case "LISTDATA":
                        this.ToList(oneNode);
                    	break;
                	case "PICDATA":
                        //this.ToImage(oneNode);
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
	        url: "web.DHCPrintDesigner.cls",
	        async:false,		// ͬ��
	        data: xmlParam,
	        dataType: 'xml',
	        success: function(xmlData) {
		        retXml=xmlData;
	        },
	        error: function(XMLHttpRequest, textStatus, errorThrown) {
	            alert("��ȡxmlģ��ʧ��!");
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
		    // ��ʾ���� Huxt 2020-05-23
	        var cId = this.GetNewCtrlId("label");
	        var barcodetype = oneNode.getAttribute("barcodetype") || "";
		    if (barcodetype != "") {
			    var ctrlHtml = "<label ctrlType='label' id='" + cId + "' name='" + oneNode.getAttribute("name") + "' ";
		        ctrlHtml += "style='position:absolute;white-space:nowrap;left:" + this.ConvertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + this.ConvertPtToPx(oneNode.getAttribute("yrow")) + "px;";
		        ctrlHtml += "font-size:" + 30 + "pt;";
		        ctrlHtml += "font-family:C39P36DmTt;";
		        ctrlHtml += "' >";
		        var printValue = this.JsonData.Para[oneNode.getAttribute("name")];
		        if (printValue) {
		             ctrlHtml += printValue.replace(/  /g, "&nbsp;") + "</label>";
		        } else {
		            ctrlHtml += "</label>";
		        }
		        this.Html+=ctrlHtml;
			    return;
			}
			// --------------
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
		       	ctrlHtml = ctrlHtml + "font-family:" + "����" + ";";
		    }
	        ctrlHtml = ctrlHtml + "' ";
	        var printValue = this.JsonData.Para[oneNode.getAttribute("name")];
	        if (printValue) {
	            ctrlHtml = ctrlHtml + ">" + printValue.replace(/\s/g, "&ensp;") + "</label>";
	        }
	        else if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
	            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue").replace(/\s/g, "&ensp;") + "</label>";
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
	ToImage:function(xmlNode){
		var count = xmlNode.childNodes.length;
	    for (var index = 0; index < count; index++) {
	        var oneNode = xmlNode.childNodes[index];
	        if (oneNode.nodeType==3){
		    	continue;
		    }
	        var cId = this.GetNewCtrlId("img");
	        var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneNode.getAttribute("name");
	        ctrlHtml = ctrlHtml + " style='position:absolute;left:" + this.ConvertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + this.ConvertPtToPx(oneNode.getAttribute("yrow")) + "px;' ";
	        if (oneNode.getAttribute("defaultvalue") != "") {
	            ctrlHtml = ctrlHtml + "imgSrc='" + oneNode.getAttribute("defaultvalue") + "' ";
	        }
			/*
	        if (RePrtHeadFlag != "N") {
	            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
	        }
			*/
	        ctrlHtml = ctrlHtml + "/>";
	        setCtrlHtml(cId, ctrlHtml);	
	     }
	},
	ToList:function(listNodes){
		// ����list��,һ��xmlģ��Ҳ��һ��list,���ٴ�����
		var listLen=listNodes.childNodes.length;
		if(listLen==0){
			return;
		}
		var currentRow = parseFloat(listNodes.getAttribute("CurrentRow") || 0);
  		var listData=this.JsonData.List;
		var listDataLen=listData.length;
		var listHtml="";
    	for (var listDataI = 0; listDataI <listDataLen; listDataI++) {	// ��������		
	        var cId = this.GetNewCtrlId("list");
	        var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
	        ctrlHtml = ctrlHtml + "CurrentRow='" + currentRow + "' ";
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
	        // xcol yrow Ϊ���꣬List�ڣ���list����Ϊ0
	        var padTop = 0;
	        //if (listNodes.getAttribute("CurrentRow") != "0") {
	        //    padTop = listHeight * parseInt(listNodes.getAttribute("CurrentRow"), 10);
	        //}
	        //var yPosition = postion[1]+(listDataI+1)*listHeight;				// cab��ӡ����bug��
	        var yPosition = postion[1]+((listDataI + currentRow)*listHeight);  	// ����currentRow��ȷ�� Huxt 2020-03-27
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
		// ����,��Ϊһ��Сlistitm
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
			ctrlHtml = ctrlHtml + "font-family:" + "����" + ";";
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
		// ��xml�е�ptת��Ϊpx
    	return this.SubFloat((parseFloat(ptValue, 10)) * 3.78, 0);
	},
	GetStartXY:function(xyNode){
		// ����
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
