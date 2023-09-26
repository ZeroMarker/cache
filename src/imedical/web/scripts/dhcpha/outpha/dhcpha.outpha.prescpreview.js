//dhcpha.outphap.printview.js
//门诊处方预览
var App_LogonHospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
// 设定访问地址
var PatientInfo = new Array();
var MyList = new Array();
var accessURL = "../../web/web.DHCPrintDesigner.cls";
var ReportId=""
var XMLTemplateCY="DHCOutPrescCY"
var XMLTemplateXY="DHCOutPrescXYPrt"
var phdispid="";
var prescno="";
var prtrowid="";
var phlrowid="";
var cyflag="";
$(function() {
	frm_onload("")
});
//页面加载
function frm_onload(paramsstr) {
		if ((paramsstr!="")&&(paramsstr!=undefined)){
			paramsarr=paramsstr.split("^");
		    phdispid=paramsarr[0];
			prescno=paramsarr[1];
			prtrowid=paramsarr[2];
			phlrowid=paramsarr[3];
			cyflag=paramsarr[4];
			MyList = new Array();
			PatientInfo = new Array();
		}
		if ((prescno=="")||(prescno==undefined)){
			return;
		}
	    if (cyflag ==1) {
	    	ReportId=tkMakeServerCall("web.DHCDocPrescript","GetXMLTemplateId",XMLTemplateCY)
	    	GetPrintPrescCY(phdispid,prescno,prtrowid,phlrowid);
	    }
	    else {
		    ReportId=tkMakeServerCall("web.DHCDocPrescript","GetXMLTemplateId",XMLTemplateXY)
	        GetPrintPrescXY(phdispid,prescno,prtrowid,phlrowid);
	    }
    	OpenReport();    	
}
function GetPrintPrescXY(phdrowid,prescno,prtrowid,phlrowid){
    var zf='[正方]'
    var retval=""
    if (phdrowid!=""){
	    retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phdrowid)
    }else{
	   	retval=tkMakeServerCall("web.DHCOutPhPrint","GetOrdInfoByPresc",prescno,prtrowid,phlrowid)
	}
    var tmparr=retval.split("!!")
    var patinfo=tmparr[0]
    var patarr=tmparr[0].split("^")
    var PatNo=patarr[0];
    var PatientName=patarr[1];
    var PatientSex=patarr[3];
    var PatientAge=patarr[2];
    var ReclocDesc=patarr[11];
    var AdmDate=patarr[13] //就诊日期
    var PatH=patarr[5];
    var PyName=patarr[6];
    var FyName=patarr[7];
    var PatientCompany=patarr[12];  //工作单位
    var PatientMedicareNo=patarr[14]; //医保编号
    var PrescNo=patarr[15] 
    var AdmDepDesc=patarr[23]
	var Doctor=patarr[24]
    var Hospital=patarr[32]
    var diag=patarr[4];
    var DiagnoseArray=diag.split(",")
    var DiagnoseArrayLen=DiagnoseArray.length
    var m=0;

    var PrescTitle=""
    var BillType=""
    var PoisonClass="";
    var MRNo=patarr[33] 
    var TotalSum=0 
    PatientInfo["PrescTitle"]=PrescTitle; //与xml mypara保持一致            
    PatientInfo["zf"]=zf;
    PatientInfo["PresType"]="处方笺";
    PatientInfo["PatientMedicareNo"]=PatientMedicareNo;
    PatientInfo["PrescNo"]=PrescNo;
    PatientInfo["MRNo"]=MRNo;
	PatientInfo["PANo"]=PatNo;
	PatientInfo["RecLoc"]=ReclocDesc;
	PatientInfo["Name"]=PatientName;
	PatientInfo["Sex"]=PatientSex;
	PatientInfo["Age"]=PatientAge;
	PatientInfo["Company"]=PatientCompany;
	PatientInfo["AdmDate"]=AdmDate;
	PatientInfo["PatH"]=PatH;
	PatientInfo["PyName"]=PyName;
	PatientInfo["FyName"]=FyName;
	PatientInfo["HosName"]=Hospital+'处方笺';
   	for (var i=0;i<DiagnoseArrayLen;i++) {
		var m=m+1;
		PatientInfo['Diagnose' + m] = DiagnoseArray[i];
	}
    ////////////////////////////////////////////
    var sum=0;
    var medinfo=tmparr[1]
    var medarr=medinfo.split("@")
    var mlength=medarr.length
    for (h=0;h<mlength;h++)
     {
	       var medrow=medarr[h]
	       var rowarr=medrow.split("^")
	       var OrderName=rowarr[0]
	       var PackQty=rowarr[1]+rowarr[2]
	       var DoseQty=rowarr[3]
	       var Inst=rowarr[4]
	       var Freq=rowarr[5]
	       var Lc=rowarr[6]
	       var totalprice=rowarr[8]
	       var Ordremark=rowarr[10] 
	       var tmpdoseinfo=" 每次"+DoseQty
	       if (DoseQty==""){
		   		tmpdoseinfo="";
		   }
	       var firstdesc=OrderName+' X '+" / "+PackQty +tmpdoseinfo+" "+Inst+" "+Freq+" "+Lc+" "+Ordremark;		     
	       MyList.push(firstdesc);;
	   	   var sum=parseFloat(sum)+parseFloat(totalprice);  
     } 
     var TotalSum=sum.toFixed(2)
     PatientInfo["Sum"]=TotalSum+'元';
     PatientInfo["AdmDep"]=AdmDepDesc;
     PatientInfo["UserAddName"]=Doctor;
}
function GetPrintPrescCY(phdrowid,prescno,prtrowid,phlrowid){
    var zf='[正方]'
    var retval=""
    if (phdrowid!=""){
	    retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phdrowid)
    }else{
	   	retval=tkMakeServerCall("web.DHCOutPhPrint","GetOrdInfoByPresc",prescno,prtrowid,phlrowid)
	}
    var tmparr=retval.split("!!")
    var patinfo=tmparr[0]
    var ordinfo=tmparr[1]
    var patarr=patinfo.split("^")
    var Quefac=patarr[26]
    var Queinst=patarr[25]
    var Queqty=patarr[27]
    var PyName=patarr[6];
    var FyName=patarr[7];
    var FyDate=patarr[8];
    var PrescNo=patarr[15];
    var PatNo=patarr[0];
    var Patloc=patarr[16];
    var PatientName=patarr[1];
    var PatientSex=patarr[3];
    var Doctor=patarr[24];
    var PatientAge=patarr[2];
    var Patcall=patarr[18];
    var Pataddress=patarr[19];
    var Orddate=patarr[31];
    var Quecook=patarr[20];
    var Diag=patarr[4];
	var Hospital=patarr[32]           
   	//for (var i=0;i<DiagnoseArrayLen;i++) {
	//	var m=m+1;
	//	PatientInfo['Diagnose' + m] = DiagnoseArray[i];
	//}
	var totalmoney=0;
	var ordarr=ordinfo.split("@")
    var OrdRows=ordarr.length
    var pc= new Array(new Array(),new Array());	    
    for (i=0;i<OrdRows;i++){ 	
    	var ordstr=ordarr[i];
       	var SStr=ordstr.split("^")
       	pc[i]=new Array();
        var OrderName=SStr[11]
        var Quenote=SStr[10]
        var Queuom=SStr[2]
        var Oneqty=(SStr[1]*1) /parseFloat(Quefac)
        var Price= SStr[7]
        var money=SStr[8]
       	totalmoney=totalmoney+parseFloat(money);//金额	    
        pc[i][1]=OrderName+""+Quenote+""+Oneqty.toFixed(4)+Queuom+" "+Price
   	
    }
	var yfpc="共"+Quefac+"剂"+" "+"用法:"+Queinst+"  一次用量:"+Queqty
	var singlemoney=(totalmoney/parseFloat(Quefac)).toFixed(2)
	totalmoney=totalmoney.toFixed(2);
	totalmoney="一付金额:"+singlemoney+"  合计金额:"+totalmoney+"   "
	var yfpc=yfpc+"  "+totalmoney
	var lastrow="配药人:"+PyName+"     发药人:"+FyName+"     发药时间:"+FyDate
    //PatientInfo["PrescTitle"]=PrescTitle; //与xml mypara保持一致 
    PatientInfo["PrescNo"]=PrescNo;
	PatientInfo["PatNo"]=PatNo;  
	PatientInfo["PatLoc"]=Patloc;
	PatientInfo["PyName"]=FyName;
	PatientInfo["PatName"]=PatientName;		    	
	PatientInfo["PatSex"]=PatientSex;
	PatientInfo["Doctor"]=Doctor;
	PatientInfo["PatAge"]=PatientAge;
	PatientInfo["jytype"]=Quecook;
	PatientInfo["AdmDate"]=Orddate;
	PatientInfo["PatICD"]=Diag;
	PatientInfo["PatCall"]=Patcall;
	PatientInfo["PatAdd"]=Pataddress;
	PatientInfo["TotalMoney"]="";
	PatientInfo["YFSM"]=yfpc;
	PatientInfo["HosName"]=Hospital+'处方笺';
	PatientInfo["PrintSign"]=lastrow;
	var k=0;	   
	for (k=1;k<OrdRows+1;k++){
		var l=0;
		for (l=1;l<2;l++){
			PatientInfo["txt"+k+l]=pc[k-1][l];
		}
	}

}

//读取报表模板
function OpenReport() {
	if(ReportId == "") {
		return;
	}
    var param = [{ name: 'ExcuteAction', value: 'ReadOne' }, { name: 'reportID', value: ReportId}];
    //读取报表
    jQuery.ajax({
        type: 'POST',
        url: accessURL,
        data: param,
        dataType: 'text',
        success: function(data) {
            showDesinerFromXml(data);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("获取报表失败!");
        }
    });
}

/*************xml转html相关******************/
//将xml转化为html显示出来
function showDesinerFromXml(strXml) {
    var docobj = CreateXMLDOM();
    docobj.async = false;
    var rtn = docobj.loadXML(strXml);
    var bdLayout = document.getElementById("dbLayout");
    if (rtn) {
        var pageNode = docobj.childNodes[1].childNodes[0];
        bdLayout.style.height = convertPtToPx(parseFloat(pageNode.getAttribute("height")) * 10) + "px";
        bdLayout.style.width = convertPtToPx(parseFloat(pageNode.getAttribute("width")) * 10) + "px";
        var count = pageNode.childNodes.length;
        for (var index = 0; index < count; index++) {
            var oneNode = pageNode.childNodes[index];
            var childCount = oneNode.childNodes.length;
            switch (oneNode.nodeName.toUpperCase()) {
                case "TXTDATA":
                    if (childCount > 0) {
                        xmlToLabel(oneNode);
                    }
                    break;
                case "PLDATA":
                    xmlToLine(oneNode);
                    break;
                case "LISTDATA":
                    if (childCount > 0) {
                        //xmlToTable(oneNode);
                        xmlToList(oneNode);
                    }
                    break;
                case "PICDATA":
                    if (childCount > 0) {
                        xmlToImg(oneNode);
                    }
                    break;
                case "TESTPARAMDATA":
                    break;
                default:
                    break;
            }
        }

    }
    var tempXmlData = jQuery("#srcHtml").text();
    jQuery("#srcHtml").text("");
    innitHtml = document.getElementById("dbLayout").innerHTML;
    jQuery("#srcHtml").text(tempXmlData);
}
//将图片转化为html
function xmlToImg(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("img");
        var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;' ";
        if (oneNode.getAttribute("defaultvalue") != "") {
            ctrlHtml = ctrlHtml + "imgSrc='" + oneNode.getAttribute("defaultvalue") + "' ";
        }
        if (RePrtHeadFlag != "N") {
            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
        }
        ctrlHtml = ctrlHtml + "/>";
        setCtrlHtml(cId, ctrlHtml);
    }
}

//将xml中的list 转化为html中的list
function xmlToList(xmlNode) {
    var cList = MyList.length;
    for (var num = 0; num < cList; num++) {
        var count = xmlNode.childNodes.length;
        var cId = getNewCtrlId("list");
        var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
        ctrlHtml = ctrlHtml + "CurrentRow='" + xmlNode.getAttribute("CurrentRow") + "' ";
        if (xmlNode.getAttribute("PageRows") != "1") {
            ctrlHtml = ctrlHtml + "PageRows='" + xmlNode.getAttribute("PageRows") + "' ";
        }
        if (xmlNode.getAttribute("XStep") != "0") {
            ctrlHtml = ctrlHtml + "XStep='" + xmlNode.getAttribute("XStep") + "' ";
        }
        var postion = getStartXY(xmlNode);
        var padTop = 0;
        if (xmlNode.getAttribute("CurrentRow") != "0") {
            padTop = convertPtToPx(xmlNode.getAttribute("YStep")) * parseInt(xmlNode.getAttribute("CurrentRow"), 10);
        }
        var yPosition = num * convertPtToPx(xmlNode.getAttribute("YStep"));
        ctrlHtml = ctrlHtml + "style='position:absolute; margin:0px; padding:0px;left:" + postion[0] + "px;top:" + (postion[1] + padTop + yPosition) + "px;width:" + (postion[2] + 100) + "px;height:" + convertPtToPx(xmlNode.getAttribute("YStep")) + "px;'>";
        var childHtml = "";
        ///加入换行的转为html的模式  
        for (var index = 0; index < count; index++) {
            var oneNode = xmlNode.childNodes[index];
            var StrListSub=MyList[num];
            if (MyList[num].indexOf(String.fromCharCode(2))>=0)
            {   var StrListSubArry=MyList[num].split(String.fromCharCode(2))
	            StrListSub=StrListSubArry.join("<BR>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp")
	        }
            childHtml = childHtml + xmlToListItem(oneNode, postion[0], postion[1] , StrListSub);
	       
        }
        ctrlHtml = ctrlHtml + childHtml + "</div>";
        setCtrlHtml(cId, ctrlHtml);
    }
}

//将list中的一项转化为html list中的一项
function xmlToListItem(oneNode, startX, startY,showValue) {
    var cId = getNewCtrlId("label");
    var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
    ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + (convertPtToPx(oneNode.getAttribute("xcol")) - startX) + "px;top:" + (convertPtToPx(oneNode.getAttribute("yrow")) - startY) + "px;"
    if (oneNode.getAttribute("fontsize") != "12") {
        ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
    }else{
	   	ctrlHtml = ctrlHtml + "font-size:" +12 + "pt;";
	}
    if (oneNode.getAttribute("fontbold") != "false") {
        ctrlHtml = ctrlHtml + "font-weight:bold;";
    }
    if (oneNode.getAttribute("fontname") != "宋体") {
        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
    }else{
		ctrlHtml = ctrlHtml + "font-family:" + "宋体" + ";";
	}
    ctrlHtml = ctrlHtml + "' ";
    if (showValue == "") {
        if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
        }
    }
    else {
        ctrlHtml = ctrlHtml + ">" + showValue.replace("", "&nbsp;&nbsp;") + "</label>";
    }
    return ctrlHtml;
}

//取得开始坐标
function getStartXY(xmlNode) {
    var count = xmlNode.childNodes.length;
    var startX = null;
    var startY = null;
    var endX = null;
    var endY = null;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
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
    result.push(convertPtToPx(startX));
    result.push(convertPtToPx(startY));
    result.push(convertPtToPx(endX - startX));
    result.push(convertPtToPx(endY - startY));
    return result;
}

//xml中的label转化为html中的label
function xmlToLabel(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("label");
        var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;";
        if (oneNode.getAttribute("fontsize") != "12") {
            ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
        }else{
	       	ctrlHtml = ctrlHtml + "font-size:" + 12 + "pt;";
	    }
        if (oneNode.getAttribute("fontbold") != "false") {
            ctrlHtml = ctrlHtml + "font-weight:bold;";
        }
        if (oneNode.getAttribute("fontname") != "宋体") {
            ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
        }else{
	       	ctrlHtml = ctrlHtml + "font-family:" + "宋体" + ";";
	    }
        ctrlHtml = ctrlHtml + "' ";
        var printValue = PatientInfo[oneNode.getAttribute("name")];
        if (printValue) {
            ctrlHtml = ctrlHtml + ">" + printValue.replace(/\s/g, "&nbsp;&nbsp;") + "</label>";
        }
        else if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue").replace(/\s/g, "&nbsp;&nbsp;") + "</label>";
        }
        else {
            ctrlHtml = ctrlHtml + "></label>";
        }

        setCtrlHtml(cId, ctrlHtml);
    }
}

//将xml中的线z转化为html中的线
function xmlToLine(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("shape");
        //var ctrlHtml = '<v:line ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
        var ctrlHtml='<div ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
        var BeginX = convertPtToPx(oneNode.getAttribute("BeginX"));
        var BeginY = convertPtToPx(oneNode.getAttribute("BeginY"));
        var EndX = convertPtToPx(oneNode.getAttribute("EndX"));
        var EndY = convertPtToPx(oneNode.getAttribute("EndY"));
        var width = EndX - BeginX;
        var height = EndY - BeginY;
        if (height == 0 && width != 0) {
            if (width > 0) {
                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-top-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;" </div>';
            }
            else {
                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-bottom-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;" </div>';
            }
        }
        else if (width == 0 && height != 0) {
            if (height > 0) {
                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:'+height+'px;" </div>';
            }
            else {
                ctrlHtml = ctrlHtml + 'style="POSITION: absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:'+height+'px;" </div>';
            }
        }
        /*小于0的暂不考虑
        else if (height < 0 && width > 0) {
            height = BeginY - EndY;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width < 0) {
            width = BeginX - EndX;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width > 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,0" to = "' + width + 'px,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height < 0 && width < 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:' + Math.abs(height) + 'px;"  from = "0,0" to = "' + Math.abs(width) + 'px,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }*/
        setCtrlHtml(cId, ctrlHtml);
    }
}

//取得新控件Id
function getNewCtrlId(ctrlType) {
    var index = 0;
    while (true) {
        index++;
        var cId = ctrlType + index;
        if (jQuery("#" + cId).length == 0) {
            return cId;
        }
    }
};

//设定新控件的html
function setCtrlHtml(cId, ctrlHtml) {
    var divReport = document.getElementById("divReport");
    divReport.innerHTML += ctrlHtml;
    return;
};

//创建xml读取对象
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

//将xml中的pt转化为px
function convertPtToPx(ptValue) {
    return subFloat((parseFloat(ptValue, 10)) * 3.78, 0);
}
//对数据四舍五入
function subFloat(num, v) {
    var vv = Math.pow(10, v);
    return Math.round(num * vv) / vv;
}

/* 此注释部分为document.write形式
function OutPrescView()
{
	var cyflag=tkMakeServerCall("web.DHCOutPhDispFY","CheckCyFlag",phdispid);
	if(cyflag=="1"){var htmlstr=OutPrescViewCY(phdispid);}
	else{var htmlstr=PreviewPrescViewXY(phdispid);}
	document.write(htmlstr)
}
/// 处方阅览 [门诊草药]
function OutPrescViewCY(phd)
{
	//获取处方信息
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('警告:提取处方信息出错！');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //病人信息
	var DrgInfo=SStr[1]; //医嘱信息

	//病人信息
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //处方号
	var AdmLoc=PatArr[16];    //科别
	var PatNo=PatArr[0];      //登记号
	var PatName=PatArr[1];    //病人姓名
	var PatAge=PatArr[2];     //年龄
	var PatSex=PatArr[3];     //性别
	var Patweight=PatArr[5];  //体重
	var DiagnoDesc=PatArr[4]; //诊断
	var OrdDate=PatArr[18];   //开方日期
	var tel=PatArr[19];       //电话
	var address=PatArr[20];   //地址
	var Doctor=PatArr[17];    //医生
	var PyName=PatArr[9];     //配药人
	var FyName=PatArr[10];    //发药人
	var PyDate=PatArr[11];    //配药日期
	var sumamt=PatArr[28];   //处方费用
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	var nbsp3='&nbsp;&nbsp;&nbsp;';

	//准备处方阅览的html
	var htmlstr="";
	//主DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//标题
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'处方笺</span>';
	htmlstr=htmlstr+'</div>';
	//基本信息
	htmlstr=htmlstr+'<div style="width:750px;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">处方号:</span><span class="btn-ui-width5 font16">&nbsp;'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 180px;" class="font16">'+"科"+nbsp3+"别:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"姓"+nbsp3+"名:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"性"+nbsp3+"别:"+'</span><span style="width:40px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"年"+nbsp3+"龄:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"登记号:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"日"+nbsp3+"期:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 40px;" class="font16">'+"电话:"+'</span><span style="width:130px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"地"+nbsp3+"址:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+"诊"+nbsp3+"断:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'</div>';
	
	//画线
	htmlstr=htmlstr+'<hr style="margin:0px 0px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//医嘱信息
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//药品信息
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var col=2;
	var rowcol=col;
	var row=Math.ceil(Len/col);
	var lastrowcol=col;
	if(Len%col!=0){lastrowcol=Len%col;}
	for(var i=1;i<=row;i++)
	{
		if(i==row){rowcol=lastrowcol;}
		for(var n=1;n<=rowcol;n++)
		{
			var j=(i-1)*col+n-1;
			var MedArr=DrgInfoArr[j].split("^");
			var specinstr=MedArr[11];  //草药备注
			if(n==1){var px=110;}
			else{var px=130;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:200px;"+'" class="font12">'+specinstr+'</span>';
		}
		//htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
		if(i==row){rowcol=lastrowcol;}
		for(var n=1;n<=rowcol;n++)
		{
			var j=(i-1)*col+n-1;
			var MedArr=DrgInfoArr[j].split("^");
			var InciDesc=MedArr[0];  //名称
			var qty=MedArr[1]
			qty=qty/quefac;
			if(qty.indexOf(".")>-1)
			{
				qty=Number(qty).toFixed(2);
			}
			var QtyUom=qty+MedArr[2];     //数量+单位
			var freqCY=MedArr[12];
			if(n==1){var px=80;}
			else{var px=30;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:300px;"+'" class="font16">'+InciDesc+"&nbsp;"+"&nbsp;"+QtyUom+'</span>';
		}
		htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	PrescSingPrice=Number(sumamt/quefac).toFixed(2)
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	//处方尾部
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;font-weight:bold;" class="font16">用法:'+freqCY+"&nbsp;"+queinst+"&nbsp;"+queqty+"&nbsp;"+"&nbsp;"+"&nbsp;"+"共: "+quefac+" 剂"+"&nbsp;"+"&nbsp;"+"&nbsp;"+quecook+'</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">金额:'+PrescSingPrice+"元"+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //画线
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">审核:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">核对:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">日期:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">调配:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">发药:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}



/// 处方阅览 [门诊西药](福永)
function OutPrescViewXY(phd)
{
	//获取处方信息
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('警告:提取处方信息出错！');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //病人信息
	var DrgInfo=SStr[1]; //医嘱信息

	//病人信息
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //处方号
	var AdmLoc=PatArr[16];    //科别
	var PatNo=PatArr[0];      //登记号
	var PatName=PatArr[1];    //病人姓名
	var PatAge=PatArr[2];     //年龄
	var PatSex=PatArr[3];     //性别
	var Patweight=PatArr[5];  //体重
	var DiagnoDesc=PatArr[4]; //诊断
	var OrdDate=PatArr[18];   //开方日期
	var tel=PatArr[19];       //电话
	var address=PatArr[20];   //地址
	var Doctor=PatArr[17];    //医生
	var PyName=PatArr[9];     //配药人
	var FyName=PatArr[10];    //发药人
	var PyDate=PatArr[11];    //配药日期
	var PrescSingPrice=PatArr[28]+"元";  //处方费用
	var presctype=PatArr[30]; //费别
	var cardno=PatArr[6];     //卡号
	var nbsp3='&nbsp;&nbsp;&nbsp;&nbsp;';

	//准备处方阅览的html
	var htmlstr="";
	//主DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//标题
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'处方笺</span>';
	htmlstr=htmlstr+'</div>';
	//基本信息
	htmlstr=htmlstr+'<div style="width:750px;height:140px;margin:0px 0px 0px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"费别:"+'&nbsp;'+presctype+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">登记号:&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">处方号:&nbsp;'+PrescNo+'</span>';
	//画线
	//htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"姓名:"+'</span><span class="btn-ui-width2 font16" style="width:140px;">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"性别:"+'</span><span style="width:60px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"年龄:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"科别:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"电话:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"体重:"+'</span><span style="width:80px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+Patweight+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"卡号:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+cardno+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"日期:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"地址:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"诊断:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'</div>';
	//画线
	htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//医嘱信息
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 25px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//药品信息
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var lastmoeori="";
	var ordNo=0
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var InciDesc=MedArr[0]; //品名		
		var QtyUom=MedArr[1]+MedArr[2];     //数量+单位
		var Durtion=MedArr[6]; //疗程		
		var Intrus=MedArr[4];  //用法
		var Dosage=MedArr[3];  //剂量
		var freq=MedArr[5];    //频次
		//var moeori=MedArr[13];  //主医嘱ID
		var spec=MedArr[13];   //规格
		var SeqFlag=MedArr[14];   //是否关联医嘱
		var moeori=MedArr[15];    //主医嘱ID
		var phdur=MedArr[16];    //疗程
		var nextseflag=0;
		var nextmoeori="";
		var m=Len-1;
		if(i!=m)
		{
			var nextdata=DrgInfoArr[i+1].split("^");
			var nextseflag=nextdata[14];
			var nextmoeori=nextdata[15];
		}
		//alert("SeqFlag="+SeqFlag+";lastmoeori="+lastmoeori+";moeori="+moeori)
		if(SeqFlag=="1")  
		{
			if(lastmoeori!=moeori)
			{
				ordNo=(parseInt(ordNo)+1)
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>';
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"、"+InciDesc+"("+spec+")"+'</span>';
				//htmlstr=htmlstr+'<span style="margin:0px 0px 0px 400px;" class="font16">'+'</span>';
				htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">'+Dosage+nbsp3+"("+QtyUom+")"+'</span>';
			}
			else
			{
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+nbsp3+InciDesc+"("+spec+")"+'</span>';
				htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">'+Dosage+nbsp3+"("+QtyUom+")"+'</span>';
			}
			htmlstr=htmlstr+'</br>';
			if((nextseflag!="1")||(nextmoeori!=moeori))
			{
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">用法:'+nbsp3+freq+" x "+phdur+nbsp3+nbsp3+Intrus+'</span>';
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>'
			}
		}
		else
		{
			ordNo=(parseInt(ordNo)+1)
			if((lastmoeori!="")&&(lastmoeori!=moeori))
			{
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>'
			}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"、"+InciDesc+nbsp3+nbsp3+spec+" x "+QtyUom+'</span>';
			htmlstr=htmlstr+'</br>';
			
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">用法:'+nbsp3+Dosage+nbsp3+freq+nbsp3+Intrus+'</span>';
			htmlstr=htmlstr+'</p>';
			htmlstr=htmlstr+'</br>';
		}
		lastmoeori=moeori;
	}
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 100px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	
	//处方尾部
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">金额:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //画线
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">审核:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">核对:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">日期:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">调配:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">发药:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}*/