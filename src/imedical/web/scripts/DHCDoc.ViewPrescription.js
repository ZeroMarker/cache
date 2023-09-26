// 设定访问地址
var MyList = new Array();
var accessURL = "../../web/web.DHCPrintDesigner.cls";
jQuery(document).ready(function() {
    frm_onload();
});

//页面加载
function frm_onload() {
        GetData();
        OpenReport(ReportId,function(data){
            showDesinerFromXml(data);
        })
        
        var obj=document.getElementById("PrintOne");
        if (obj) obj.onclick=PrintOnePresc
        //打印全部处方
        var obj=parent.document.getElementById("PrintAll");
        if (obj) obj.onclick=PrintAll
 
        
}
function PrintAll()
{
    var LengthFarm=parent.frames.length
    for (var IForm=0;IForm<LengthFarm;IForm++)
    {
        var Obj=parent.frames[IForm].document.getElementById("PrintOne");
        if (Obj){Obj.click();}
    }
    
}

function PrintOnePresc() {
    SaveSupplyInfoCom();
    if (IsCYPrescType ==1) {
        PrintPrescCYInfo();
    }
    else {
        PrintOnePrescXY();
    }
}
function SaveSupplyInfoCom(){
    var PerSupply=""
    var PerSupplyCard=""
    var PerSupplyTel=""
    if (parent.frames.DMPrescInfo){
        //代办人姓名
        var obj=parent.frames.DMPrescInfo.elements.PerSupply;
        if (obj) {var PerSupply=obj.value;}
        //代办人身份证信息
        var obj=parent.frames.DMPrescInfo.elements.PerSupplyCrad;
        if (obj) {var PerSupplyCard=obj.value;}
        //代办人电话
        var obj=parent.frames.DMPrescInfo.elements.PerSupplyTel;
        if (obj) {var PerSupplyTel=obj.value;}
        //本人身份证
        var obj=parent.frames.DMPrescInfo.elements.RealCrad;
        if (obj) {var PAPMIDVAnumber=obj.value;}
        var PatInfo=PAPMIDVAnumber+"^"+PerSupply+"^"+PerSupplyCard+"^"+PerSupplyTel;
        var rtn=tkMakeServerCall("web.DHCDocCheckPoison","UpdateAgencyInfo",EpisodeID,PatInfo);
    }
}
function PrintPrescCYInfo() {
    var flag1="",flag2="";
        DHCP_GetXMLConfig("InvPrintEncrypt", XMLTemplateCY);
        var myobj = document.getElementById("ClsBillPrint");
        var PrescNo=OrderPrescInfo["PrescNo"];
        var ObjOnlyZF=parent.document.getElementById("OnlyZF");
        var ObjOnlyDF=parent.document.getElementById("OnlyDF")
        if (ObjOnlyZF){
            if ((ObjOnlyZF.checked)||(!ObjOnlyDF)){ 
                flag1="Y";
            }   
        }
        
        if (ObjOnlyDF){
            if (ObjOnlyDF.checked){ 
                flag2="Y";
            }
        }
        if (ObjOnlyZF && ObjOnlyDF){
            if((!ObjOnlyZF.checked)&&(!ObjOnlyDF.checked)){
                flag1="Y";
                flag2="Y";
                SavePrescEventLog();
                SavePrescPrintLog(PrescNo);
            }
        }
        PrintOnePrescCY("","",flag1,flag2)
        SavePrescEventLog();
            SavePrescPrintLog(PrescNo);
}
function PrintOnePrescXY() {
    var MyParaStr="";
    var MyListStr="";
    var PrescNo=OrderPrescInfo['PrescNo'];
    if (OrderPrescInfo.hasOwnProperty("PrescSerialNo")){
		var SerialNo=OrderPrescInfo['PrescSerialNo'];
	}else{
	    var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",PrescNo,"");
		if (SerialNo==""){
			SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","InsertPrtSerial",PrescNo,"",session['LOGON.USERID']);
		}
		OrderPrescInfo['PrescSerialNo']=SerialNo;
	}
	
    
        for (x in OrderPrescInfo) {
            if (x=="indexOf") continue;
            if (typeof(x)=="function") continue;
        if (MyParaStr=="") {
            MyParaStr = x + String.fromCharCode(2) + OrderPrescInfo[x];
        }else{
            MyParaStr = MyParaStr + '^' + x + String.fromCharCode(2) + OrderPrescInfo[x];
        }
        }
        var PrescNo=OrderPrescInfo['PrescNo'];
        for (y in MyList) {
            if (y=="indexOf") continue;
            if (typeof(y)=="function") continue;
        if (MyListStr=="") {
            MyListStr = MyList[y];
        }else{
            MyListStr = MyListStr + String.fromCharCode(2) + MyList[y];
        }
        }
     
        var PerSupply=""
        var PerSupplyCrad=""
        var PerSupplyTel=""
        var RealCrad=""
        var RealName=""
        if (parent.frames.DMPrescInfo){
              ///代办人姓名
              var obj=parent.frames.DMPrescInfo.elements.PerSupply //parent.frames.DMPrescInfo.document.getElementById('PerSupply');
              if (obj) {var PerSupply=obj.value;}
              //代办人身份证信息
              var obj=parent.frames.DMPrescInfo.elements.PerSupplyCrad //parent.frames.DMPrescInfo.document.getElementById('PerSupplyCrad');
              if (obj) {
                  var PerSupplyCrad=obj.value;
                  //var Rtn=DHCWeb_IsIdCardNo(PerSupplyCrad)
                 // if (!Rtn){return;}
              
              }
               //代办人电话
              var obj=parent.frames.DMPrescInfo.elements.PerSupplyTel //parent.frames.DMPrescInfo.document.getElementById('PerSupplyTel');
              if (obj) {var PerSupplyTel=obj.value;}
              //本人身份证号
              var obj=parent.frames.DMPrescInfo.elements.RealCrad //parent.frames.DMPrescInfo.document.getElementById('RealCrad');
              if (obj) {var RealCrad=obj.value;}
              //本人姓名
              var obj=parent.frames.DMPrescInfo.elements.RealName //parent.frames.DMPrescInfo.document.getElementById('RealName');
              if (obj) {var RealName=obj.value;}
              //毒麻处方标志DMCFFlag="Y"是毒麻处方
        }
        //alert(PerSupply+","+PerSupplyCrad+","+PerSupplyTel+","+RealCrad+","+RealName)
        var DMCFFlag="N"
        var PrescNo=OrderPrescInfo['PrescNo'];
        for(var J=0;J<parent.frames.length;J++){
            var name=parent.frames[J].name;
            if ((name.indexOf(PrescNo)>=0)&&(name.indexOf("DMCF")>=0))
            { 
            DMCFFlag="Y"
            }
        }
     
     
        DHCP_GetXMLConfig("InvPrintEncrypt", XMLTemplateXY);
      
        var myobj = document.getElementById("ClsBillPrint");
        var ObjOnlyZF=parent.document.getElementById("OnlyZF")
        var ObjOnlyDF=parent.document.getElementById("OnlyDF")
        if (ObjOnlyZF){
            if ((ObjOnlyZF.checked)||(!ObjOnlyDF)){ 
                var MyParaStr=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[正方]"
                if (DMCFFlag=="Y"){
                    var PerSupply="代办人姓名:"+PerSupply;
                    var MyParaStr=MyParaStr+"^"+"PerSupply"+String.fromCharCode(2)+PerSupply
                    var PerSupplyCrad="代办人身份证号:"+PerSupplyCrad;
                    var MyParaStr=MyParaStr+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCrad;
                }
                DHCP_PrintFunHDLP(myobj, MyParaStr, MyListStr);
                SavePrescEventLog();
                SavePrescPrintLog(PrescNo);
            }
        }
        
        if (ObjOnlyDF){
            if (ObjOnlyDF.checked){ 
                var MyParaStr=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[底方]"
                if (DMCFFlag=="Y"){
                    var PerSupply="代办人姓名:"+PerSupply;
                    var MyParaStr=MyParaStr+"^"+"PerSupply"+String.fromCharCode(2)+PerSupply
                    var PerSupplyCrad="代办人身份证号:"+PerSupplyCrad;
                    var MyParaStr=MyParaStr+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCrad;
                }
                
                DHCP_PrintFunHDLP(myobj, MyParaStr, MyListStr);
                SavePrescEventLog();
                SavePrescPrintLog(PrescNo);
            }
        }
        if (ObjOnlyZF && ObjOnlyDF){
            if((!ObjOnlyZF.checked)&&(!ObjOnlyDF.checked)){
                var MyParaStr1=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[正方]"
                if (DMCFFlag=="Y"){
                    var PerSupply="代办人姓名:"+PerSupply;
                    var MyParaStr1=MyParaStr1+"^"+"PerSupply"+String.fromCharCode(2)+PerSupply
                    var PerSupplyCard="代办人身份证号:"+PerSupplyCrad;
                    var MyParaStr1=MyParaStr1+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCard;
                }
                DHCP_PrintFunHDLP(myobj, MyParaStr1, MyListStr);
                var MyParaStr2=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[底方]"
                if (DMCFFlag=="Y"){
                    var PerSupply="代办人姓名:"+PerSupply;
                    var MyParaStr2=MyParaStr2+"^"+"PerSupply"+String.fromCharCode(2)+PerSupply
                    var PerSupplyCard="代办人身份证号:"+PerSupplyCrad;
                    var MyParaStr2=MyParaStr2+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCard;
                }
                DHCP_PrintFunHDLP(myobj, MyParaStr2, MyListStr);
              
                SavePrescEventLog();
                SavePrescPrintLog(PrescNo);
            }
        }
       	var rtn=tkMakeServerCall("User.PAQue1PrtSerial","SavePrintLog",SerialNo,session['LOGON.USERID']);
        //DHCP_PrintFunHDLP(myobj, MyParaStr, MyListStr);
}


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
    innitHtml = document.getElementById("dbLayout").outerHTML;
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
    }
    if (oneNode.getAttribute("fontbold") != "false") {
        ctrlHtml = ctrlHtml + "font-weight:bold;";
    }
    if (oneNode.getAttribute("fontname") != "宋体") {
        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
    }
    ctrlHtml = ctrlHtml + "' ";
    if (showValue == "") {
        if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
        }else{
            ctrlHtml = ctrlHtml + "></label>";
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
        }
        if (oneNode.getAttribute("fontbold") != "false") {
            ctrlHtml = ctrlHtml + "font-weight:bold;";
        }
        if (oneNode.getAttribute("fontname") != "宋体") {
            ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
        }
        ctrlHtml = ctrlHtml + "' ";
        var printValue = OrderPrescInfo[oneNode.getAttribute("name")];
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
        var ctrlHtml = '<v:line ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
        var BeginX = convertPtToPx(oneNode.getAttribute("BeginX"));
        var BeginY = convertPtToPx(oneNode.getAttribute("BeginY"));
        var EndX = convertPtToPx(oneNode.getAttribute("EndX"));
        var EndY = convertPtToPx(oneNode.getAttribute("EndY"));
        var width = EndX - BeginX;
        var height = EndY - BeginY;
        if (height == 0 && width != 0) {
            if (width > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:10px;"  from = "0,0" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:10px;"  from = "0,0" to = "' + Math.abs(width) + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
        else if (width == 0 && height != 0) {
            if (height > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + height + 'px;"  from = "0,0" to = "0,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + Math.abs(height) + 'px;"  from = "0,0" to = "0,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
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
        }
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

//获取显示的数据
function GetData() {
    if ((NeedChildweight==1)&&(Childweight=="")){
      var PrintOneObj=document.getElementById("PrintOne"); 
      var PrintAllObj=parent.document.getElementById("PrintAll");
      PrintOneObj.disabled=true;
      PrintAllObj.disabled=true;
   }
   if ((ReportData=="OK")||(ReportData=="")){
        return  
    }
    if (IsCYPrescType ==1) {
        PrintPrescCY("", "",ReportData);
    }
    else {
        PrintPrescXY("", "");
    }
}

///西药打印
function PrintPrescXY(prescno, PreFlag) {
        var phl = "", prt = "";
        var zf = ''
        var tmparr = ReportData.split("!!")
        var patinfo = tmparr[0]
        var patarr = tmparr[0].split("^")
        //
        var PatNo = patarr[0];
        var PatientName = patarr[1];
        var PatientSex = patarr[2];
        var PatientAge = patarr[3];
        var ReclocDesc = patarr[11];
        var AdmDate = patarr[13] //就诊日期
        var PatH = patarr[5];
        var PyName = patarr[6];
        var FyName = patarr[7];
        var PatientCompany = patarr[12];  //工作单位
        var PatientMedicareNo = patarr[14]; //医保编号
        var PrescNo = patarr[15]
        var AdmDepDesc = patarr[23]
        var Doctor = patarr[24]
        var Paddress = patarr[19]
        var TelNo = patarr[18]
        var OrdDate = patarr[31]
        var PayDate = patarr[32]
        var PrtDate = patarr[10]
        var DMFlag = patarr[22]
        if (DMFlag != "") var DMFlag = '[' + DMFlag + ']'
        var BillFlag = patarr[33]
        var BillFlag = '[' + BillFlag + ']'
        var TelNo = patarr[18]
        var BillAuditFlag = patarr[34]
        var PoliticalLevel = patarr[36]
        var Medcare=patarr[37]
        var HosName=patarr[38]+"处方笺"
        var EpisodeID=patarr[39]
        var deplocdr=patarr[40]
        var PAAdmType=patarr[41]
        var PAAdmBed=patarr[42]
        //
        var diag = patarr[4];
        var DiagnoseArray = diag.split(",")
        var DiagnoseArrayLen = DiagnoseArray.length
        var m = 0;

        var PrescTitle = ""
        var BillType = ""
        var PoisonClass = "";
        var MRNo = ""
        var TotalSum = 0

        var barcode = "" //"*"+PrescNo+"*"

        //var MyPara = 'PrescTitle' + String.fromCharCode(2) + PrescTitle;
        //OrderPrescInfo['PrescTitle'] = PrescTitle;
        //MyPara = MyPara + '^zf' + String.fromCharCode(2) + zf;
        OrderPrescInfo['zf'] = zf;
        //MyPara = MyPara + '^PresType' + String.fromCharCode(2) + '处方笺';
        OrderPrescInfo['PresType'] = '处方笺';
        //MyPara = MyPara + '^PatientMedicareNo' + String.fromCharCode(2) + PatientMedicareNo;
        OrderPrescInfo['PatientMedicareNo'] = PatientMedicareNo;
        //MyPara = MyPara + '^PrescNo' + String.fromCharCode(2) + PrescNo;
        OrderPrescInfo['PrescNo'] = PrescNo;
        //MyPara = MyPara + '^MRNo' + String.fromCharCode(2) + MRNo;
        OrderPrescInfo['MRNo'] = MRNo;
        //MyPara = MyPara + '^PANo' + String.fromCharCode(2) + PatNo;
        OrderPrescInfo['PANo'] = PatNo;
        //MyPara = MyPara + '^RecLoc' + String.fromCharCode(2) + ReclocDesc;
        OrderPrescInfo['RecLoc'] = ReclocDesc;
        //MyPara = MyPara + '^Name' + String.fromCharCode(2) + PatientName;
        OrderPrescInfo['Name'] = PatientName;
        OrderPrescInfo['PoliticalLevel'] = PoliticalLevel;
        //MyPara = MyPara + '^Sex' + String.fromCharCode(2) + PatientSex;
        OrderPrescInfo['Sex'] = PatientSex;
        //MyPara = MyPara + '^Age' + String.fromCharCode(2) + PatientAge;
        OrderPrescInfo['Age'] = PatientAge;
        //MyPara = MyPara + '^Address' + String.fromCharCode(2) + Paddress;
        OrderPrescInfo['Address'] = Paddress;
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        OrderPrescInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^PatH' + String.fromCharCode(2) + PatH;
        //OrderPrescInfo['PatH'] = PatH; //Childweight
        /*var Childweight="";
        var CTLocPrintTypeID=tkMakeServerCall("web.DHCDocPrescript","GetCTLocPrintTypeID",deplocdr)
        if(CTLocPrintTypeID==1){
            var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
            if (rtn!='') {              
                var str=rtn.split("^");
                if((str[0]=="1")&&(str[1]=="")){
                     //alert("儿科必须填写体重!");
                     if (PreFlag==0){
                         var PrintOneObj=document.getElementById("PrintOne"); 
                         var PrintAllObj=parent.document.getElementById("PrintAll");
                         PrintOneObj.disabled=true;
                         PrintAllObj.disabled=true;
                     }else{
                         return false;
                     }
                }
                Childweight="体重:"+str[1]+"Kg";
            }
            PrescTitle="[儿科]";
        }*/
        if(CTLocPrintTypeID==1){
            PrescTitle="[儿科]";
            Childweight="体重:"+Childweight+"Kg";
        }
        if(CTLocPrintTypeID==2){
            PrescTitle="[急]";
        }
        /*if (AdmDepDesc.indexOf("儿科")!=-1) {
            var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
            if (rtn!='') {              
                var str=rtn.split("^");
                if((str[0]=="1")&&(str[1]=="")){
                     alert("儿科必须填写体重!");
                     return "";
                }
                Childweight="体重:"+str[1];
            }
            PrescTitle="[儿科]";
        }else if (AdmDepDesc.indexOf("急")!=-1) {
            PrescTitle="[急]";
        }*/
        OrderPrescInfo['PrescTitle'] = PrescTitle;
        OrderPrescInfo['Childweight'] = Childweight; 
        //MyPara = MyPara + '^PyName' + String.fromCharCode(2) + PyName;
        OrderPrescInfo['PyName'] = PyName;
        //MyPara = MyPara + '^FyName' + String.fromCharCode(2) + FyName;
        OrderPrescInfo['FyName'] = FyName;
        //MyPara = MyPara + '^Barcode' + String.fromCharCode(2) + barcode;
        OrderPrescInfo['Barcode'] = barcode;
        //MyPara = MyPara + '^OrdDate' + String.fromCharCode(2) + OrdDate;
        OrderPrescInfo['OrdDate'] = OrdDate;
        //MyPara = MyPara + '^PayDate' + String.fromCharCode(2) + PayDate;
        OrderPrescInfo['PayDate'] = PayDate;
        //MyPara = MyPara + '^PrtDate' + String.fromCharCode(2) + PrtDate;
        OrderPrescInfo['PrtDate'] = PrtDate;
        //MyPara = MyPara + '^DMFlag' + String.fromCharCode(2) + DMFlag;
        OrderPrescInfo['DMFlag'] = DMFlag;
        //MyPara = MyPara + '^BillFlag' + String.fromCharCode(2) + BillFlag;
        OrderPrescInfo['BillFlag'] = BillFlag;
        //MyPara = MyPara + '^TelNo' + String.fromCharCode(2) + TelNo;
        OrderPrescInfo['TelNo'] = TelNo;
        //MyPara = MyPara + '^PrtRemark' + String.fromCharCode(2) + "说明:药品名称前有";
        OrderPrescInfo['PrtRemark'] = "说明:药品名称前有";
        //MyPara = MyPara + '^PrtRemark1' + String.fromCharCode(2) + String.fromCharCode(9650) + "表示需皮试药品";
        OrderPrescInfo['PrtRemark1'] = String.fromCharCode(9650) + "表示需皮试药品";
        //MyPara = MyPara + '^BillAuditFlag' + String.fromCharCode(2) + BillAuditFlag
        OrderPrescInfo['BillAuditFlag'] = BillAuditFlag;
        OrderPrescInfo['BillType'] = BillFlag;
        OrderPrescInfo['Company']=PatientCompany;
        OrderPrescInfo['MRNo']=Medcare;
        OrderPrescInfo['HosName']=HosName
        OrderPrescInfo['AdmDate']=AdmDate
        var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",PrescNo,"");
        if (SerialNo!=""){
	    	OrderPrescInfo['PrescSerialNo']=SerialNo;   
	    }
        var intLen = 8
        for (var i = 0; i < DiagnoseArrayLen; i++) {

            ss = DiagnoseArray[i]
            strContent = DiagnoseArray[i]

            var m = m + 1;
            var diaglen = DiagnoseArray[i].length

            if (diaglen > 8) {

                while (strContent.length > intLen) {

                    strTemp = strContent.substr(0, intLen);
                    //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strTemp;
                    OrderPrescInfo['Diagnose' + m] = strTemp;
                    m = m + 1
                    strContent = strContent.substr(intLen, strContent.length);

                }

                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strContent;
                OrderPrescInfo['Diagnose' + m] = strContent;

            }
            else {
                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + ss;
                OrderPrescInfo['Diagnose' + m] = ss;

            }

        }

        var sum = 0;
        var medinfo = tmparr[1]
        var medarr = medinfo.split("@")
        var mlength = medarr.length
        for (h = 0; h < mlength; h++) {
            var medrow = medarr[h]
            var rowarr = medrow.split("^")
            var OrderName = rowarr[0]
            var PackQty = rowarr[1] + rowarr[2]
            var DoseQty = rowarr[3]
            var Inst = rowarr[4]
            var Freq = rowarr[5]
            var Lc = rowarr[6]
            var totalprice = rowarr[8]
            var Ordremark = rowarr[10]
            var Testflag = rowarr[9]
            var Seqno = rowarr[11]
            var ISLongOrderPrior= rowarr[13]
            var Priority= rowarr[14]
            
            
            if (Testflag != "") {
                Seqno = Seqno + String.fromCharCode(9650)
            }
            if (Ordremark.length > 10) {
                Ordremark = Ordremark.substr(0, 10) + "...";
            }

            var OrderName = Seqno + " " + OrderName
            ///项目要求在备注存在用法：的时候使用备注覆盖单次计量
            if (ISLongOrderPrior=="1"){
                var firstdesc = OrderName + ' (' + Priority+")"
            }else{
                var firstdesc = OrderName + ' X ' + PackQty
            }
            var inststring = "              用法:每次" + DoseQty + "     " + Freq + "     " + Inst + "     " + Ordremark +" "+Testflag

            var firstdesc = firstdesc + String.fromCharCode(2) + inststring

            if (MyList == '') {
                MyList.push(firstdesc);
            } else {
                //MyList = MyList + String.fromCharCode(2) + firstdesc;
                MyList.push(firstdesc);
            }

            var sum = parseFloat(sum) + parseFloat(totalprice);
        }


        var TotalSum = sum.toFixed(2)
        //MyPara = MyPara + '^Sum' + String.fromCharCode(2) + TotalSum + '元';
        if (PAAdmType!="I"){
            OrderPrescInfo['Sum'] = TotalSum + '元';
        }
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        OrderPrescInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^UserAddName' + String.fromCharCode(2) + Doctor;
        OrderPrescInfo['UserAddName'] = Doctor;
        if (PAAdmBed!="") OrderPrescInfo['PAAdmBed'] = "床号:"+PAAdmBed;
		
        //DHCP_GetXMLConfig(XMLElementName, "DHCOutPrescXYPrt");
        //var myobj = document.getElementById("ClsBillPrint");
        //DHCP_PrintFunHDLP(myobj, MyPara, MyList);

}


///日志保存
function SavePrescEventLog(){
        var infoarr=EventLogData.split("^");
        var ModelName="PrintPrescCY";
        var Condition="{RegNo:"+infoarr[0]+"}";
        var Content="{EpisodeId:"+infoarr[1]+"}";
        var SecretCode=infoarr[2];
        if (SecretCode!="") {
            websys_EventLog(ModelName,Condition,Content,SecretCode);
            //alert("ok");
        }
    return 0;
}

///处方打印日志信息保存
function SavePrescPrintLog(PrescNo){
        var User=session['LOGON.USERID'];
        var PerSupply=""
        var PerSupplyCard=""
        var PerSupplyTel=""
        if (parent.frames.DMPrescInfo){
            //代办人姓名
            var obj=parent.frames.DMPrescInfo.elements.PerSupply;
            if (obj) {var PerSupply=obj.value;}
            //代办人身份证信息
            var obj=parent.frames.DMPrescInfo.elements.PerSupplyCrad;
            if (obj) {var PerSupplyCard=obj.value;}
            //代办人电话
            var obj=parent.frames.DMPrescInfo.elements.PerSupplyTel;
            if (obj) {var PerSupplyTel=obj.value;}
        }
        var SaveInfo=PrescNo+"^"+User+"^"+PerSupplyCard+"^"+PerSupply+"^"+PerSupplyTel;
        var rtn=tkMakeServerCall("web.DHCDocCheckPoison","InsertPAQPrintLog",SaveInfo);
    
}