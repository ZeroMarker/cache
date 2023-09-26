//dhcpha.outpha.printview.js
//���ﴦ��Ԥ��
$(function(){
	var PrePrescParamStrArr=PrePrescParamStr.split("^");
	var prescNo=PrePrescParamStrArr[1]||"";
	var phdId=PrePrescParamStrArr[0]||"";
	var prtType=PrePrescPrtType||"";
	$("#divPreReport").html("");
	var prtData=tkMakeServerCall("web.DHCOUTPHA.Common.Print","PrescPrintData",prescNo,"",prtType);
	if (prtData=="{}"){
		return;
	}
	var prtJson=JSON.parse(prtData);
	var preHtml=DHCSTXMLPrint_Preview.JsonToHtml(prtJson);
	$("#divPreReport").html(preHtml);
	
});


//��ͼƬת��Ϊhtml
function xmlToImg(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        if (oneNode.nodeType==3){
	    	continue;
	    }
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

//��xml�е�list ת��Ϊhtml�е�list
function xmlToList(xmlNode) {
    var cList = MyList.length;
    for (var num = 0; num <=cList; num++) {
        if (xmlNode.childNodes[num].nodeType==3){
	    	continue;
	    }
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
        var listItemData=MyList[0] //MyList[num];
        alert(listItemData)
        ///���뻻�е�תΪhtml��ģʽ  
        for (var index = 0; index <count; index++) {
            var oneNode = xmlNode.childNodes[index];
        if (oneNode.nodeType==3){
	    	continue;
	    }
            var listItemArr=listItemData.split("^");
            var StrListSub=listItemArr[0].toString() //listItemArr[index].toString();
            //alert(index+"!!!"+StrListSub)
            if (StrListSub.indexOf(String.fromCharCode(2))>=0)
            {   
            	var StrListSubArry=MyList[num].split(String.fromCharCode(2))
	            StrListSub=StrListSubArry.join("<BR>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp")
	        }
            childHtml = childHtml + xmlToListItem(oneNode, postion[0], postion[1] , StrListSub);
	       
        }
        ctrlHtml = ctrlHtml + childHtml + "</div>";
        setCtrlHtml(cId, ctrlHtml);
    }
}

//��list�е�һ��ת��Ϊhtml list�е�һ��
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
    if (oneNode.getAttribute("fontname") != "����") {
        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
    }else{
		ctrlHtml = ctrlHtml + "font-family:" + "����" + ";";
	}
    ctrlHtml = ctrlHtml + "' ";
    if (showValue == "") {
        if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
        }
    }
    else {
        ctrlHtml = ctrlHtml + ">" + showValue.replace("", "&nbsp;&nbsp;") + "</label>";
    }
    return ctrlHtml;
}

//ȡ�ÿ�ʼ����
function getStartXY(xmlNode) {
    var count = xmlNode.childNodes.length;
    var startX = null;
    var startY = null;
    var endX = null;
    var endY = null;
    for (var index = 0; index <count; index++) {
        var oneNode = xmlNode.childNodes[index];
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
    result.push(convertPtToPx(startX));
    result.push(convertPtToPx(startY));
    result.push(convertPtToPx(endX - startX));
    result.push(convertPtToPx(endY - startY));
    return result;
}



//��xml�е���zת��Ϊhtml�е���
function xmlToLine(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        if (oneNode.nodeType==3){
	    	continue;
	    }
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

        setCtrlHtml(cId, ctrlHtml);
    }
}

//ȡ���¿ؼ�Id
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

//�趨�¿ؼ���html
function setCtrlHtml(cId, ctrlHtml) {
    var divReport = document.getElementById(ShowDivId);
    //$("#divReport .mCSB_container").append(ctrlHtml);
    divReport.innerHTML += ctrlHtml;

    
    return;
};





/* ��ע�Ͳ���Ϊdocument.write��ʽ
function OutPrescView()
{
	var cyflag=tkMakeServerCall("web.DHCOutPhDispFY","CheckCyFlag",phdispid);
	if(cyflag=="1"){var htmlstr=OutPrescViewCY(phdispid);}
	else{var htmlstr=PreviewPrescViewXY(phdispid);}
	document.write(htmlstr)
}
/// �������� [�����ҩ]
function OutPrescViewCY(phd)
{
	//��ȡ������Ϣ
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('����:��ȡ������Ϣ����');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //������Ϣ
	var DrgInfo=SStr[1]; //ҽ����Ϣ

	//������Ϣ
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //������
	var AdmLoc=PatArr[16];    //�Ʊ�
	var PatNo=PatArr[0];      //�ǼǺ�
	var PatName=PatArr[1];    //��������
	var PatAge=PatArr[2];     //����
	var PatSex=PatArr[3];     //�Ա�
	var Patweight=PatArr[5];  //����
	var DiagnoDesc=PatArr[4]; //���
	var OrdDate=PatArr[18];   //��������
	var tel=PatArr[19];       //�绰
	var address=PatArr[20];   //��ַ
	var Doctor=PatArr[17];    //ҽ��
	var PyName=PatArr[9];     //��ҩ��
	var FyName=PatArr[10];    //��ҩ��
	var PyDate=PatArr[11];    //��ҩ����
	var sumamt=PatArr[28];   //��������
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	var nbsp3='&nbsp;&nbsp;&nbsp;';

	//׼������������html
	var htmlstr="";
	//��DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//����
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'������</span>';
	htmlstr=htmlstr+'</div>';
	//������Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">������:</span><span class="btn-ui-width5 font16">&nbsp;'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 180px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:40px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"�ǼǺ�:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 40px;" class="font16">'+"�绰:"+'</span><span style="width:130px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"ַ:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'</div>';
	
	//����
	htmlstr=htmlstr+'<hr style="margin:0px 0px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//ҽ����Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//ҩƷ��Ϣ
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
			var specinstr=MedArr[11];  //��ҩ��ע
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
			var InciDesc=MedArr[0];  //����
			var qty=MedArr[1]
			qty=qty/quefac;
			if(qty.indexOf(".")>-1)
			{
				qty=Number(qty).toFixed(2);
			}
			var QtyUom=qty+MedArr[2];     //����+��λ
			var freqCY=MedArr[12];
			if(n==1){var px=80;}
			else{var px=30;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:300px;"+'" class="font16">'+InciDesc+"&nbsp;"+"&nbsp;"+QtyUom+'</span>';
		}
		htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	PrescSingPrice=Number(sumamt/quefac).toFixed(2)
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	//����β��
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;font-weight:bold;" class="font16">�÷�:'+freqCY+"&nbsp;"+queinst+"&nbsp;"+queqty+"&nbsp;"+"&nbsp;"+"&nbsp;"+"��: "+quefac+" ��"+"&nbsp;"+"&nbsp;"+"&nbsp;"+quecook+'</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">���:'+PrescSingPrice+"Ԫ"+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">���:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">�˶�:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">����:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">����:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">��ҩ:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}



/// �������� [������ҩ](����)
function OutPrescViewXY(phd)
{
	//��ȡ������Ϣ
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('����:��ȡ������Ϣ����');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //������Ϣ
	var DrgInfo=SStr[1]; //ҽ����Ϣ

	//������Ϣ
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //������
	var AdmLoc=PatArr[16];    //�Ʊ�
	var PatNo=PatArr[0];      //�ǼǺ�
	var PatName=PatArr[1];    //��������
	var PatAge=PatArr[2];     //����
	var PatSex=PatArr[3];     //�Ա�
	var Patweight=PatArr[5];  //����
	var DiagnoDesc=PatArr[4]; //���
	var OrdDate=PatArr[18];   //��������
	var tel=PatArr[19];       //�绰
	var address=PatArr[20];   //��ַ
	var Doctor=PatArr[17];    //ҽ��
	var PyName=PatArr[9];     //��ҩ��
	var FyName=PatArr[10];    //��ҩ��
	var PyDate=PatArr[11];    //��ҩ����
	var PrescSingPrice=PatArr[28]+"Ԫ";  //��������
	var presctype=PatArr[30]; //�ѱ�
	var cardno=PatArr[6];     //����
	var nbsp3='&nbsp;&nbsp;&nbsp;&nbsp;';

	//׼������������html
	var htmlstr="";
	//��DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//����
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'������</span>';
	htmlstr=htmlstr+'</div>';
	//������Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:140px;margin:0px 0px 0px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"�ѱ�:"+'&nbsp;'+presctype+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">�ǼǺ�:&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">������:&nbsp;'+PrescNo+'</span>';
	//����
	//htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"����:"+'</span><span class="btn-ui-width2 font16" style="width:140px;">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"�Ա�:"+'</span><span style="width:60px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"�Ʊ�:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"�绰:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:80px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+Patweight+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+cardno+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"��ַ:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"���:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'</div>';
	//����
	htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//ҽ����Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 25px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//ҩƷ��Ϣ
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var lastmoeori="";
	var ordNo=0
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var InciDesc=MedArr[0]; //Ʒ��		
		var QtyUom=MedArr[1]+MedArr[2];     //����+��λ
		var Durtion=MedArr[6]; //�Ƴ�		
		var Intrus=MedArr[4];  //�÷�
		var Dosage=MedArr[3];  //����
		var freq=MedArr[5];    //Ƶ��
		//var moeori=MedArr[13];  //��ҽ��ID
		var spec=MedArr[13];   //���
		var SeqFlag=MedArr[14];   //�Ƿ����ҽ��
		var moeori=MedArr[15];    //��ҽ��ID
		var phdur=MedArr[16];    //�Ƴ�
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
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"��"+InciDesc+"("+spec+")"+'</span>';
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
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">�÷�:'+nbsp3+freq+" x "+phdur+nbsp3+nbsp3+Intrus+'</span>';
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
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"��"+InciDesc+nbsp3+nbsp3+spec+" x "+QtyUom+'</span>';
			htmlstr=htmlstr+'</br>';
			
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">�÷�:'+nbsp3+Dosage+nbsp3+freq+nbsp3+Intrus+'</span>';
			htmlstr=htmlstr+'</p>';
			htmlstr=htmlstr+'</br>';
		}
		lastmoeori=moeori;
	}
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 100px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	
	//����β��
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">���:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">���:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">�˶�:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">����:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">����:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">��ҩ:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}*/
