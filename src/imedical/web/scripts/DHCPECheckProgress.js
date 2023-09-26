var CurRows="";
function BodyLoadHandler(){
	var obj=document.getElementById("BPISPrint");
	if (obj) obj.onclick=BPisRequestPrint_click;
	var  obj=document.getElementById("GADMDesc");
	if (obj) obj.onchange=GADMDesc_change;
	var  obj=document.getElementById("BAddItem");
	if (obj) obj.onclick=BAddItem_click;
	obj=document.getElementById("BSendMessage");
	if (obj){ obj.onclick=BSendMessage_click; }
	obj=document.getElementById('RegNo')
	if (obj) {obj.onkeydown=RegNoKeyDown;}
	//alert('d');
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	obj=document.getElementById("BSelectAll");
	if (obj){ obj.onclick=BSelectAll_click; }
	
	//报告预览
	obj=document.getElementById("BReportView");
	if (obj){ obj.onclick=ReportView; }

	var obj=GetObj("Content");
	if (obj) obj.ondblclick=DealRemark_DBLClick;
	
}

//报告预览 
function ReportView()
{
	if (""==CurRows) {
		 alert("请先选择人员");
	   return false;
	   }
    var PAADM="";
	var obj=document.getElementById("TPAADMz"+CurRows);
	if (obj) PAADM=obj.value;

	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetNewVerReport",session['LOGON.CTLOCID']);
	if(NewVerReportFlag=="Y"){
		if (PAADM==""){
			alert("就诊ID为空");
		    return false;
		}else{
			calPEReportProtocol("BPrintView",PAADM);
		} 
		return false;
	}else{
	
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	
	var repUrl="dhcpeireport.normal.csp?PatientID="+PAADM+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(repUrl,"_blank",nwin)
	}
}

function calPEReportProtocol(sourceID,jarPAADM){
	var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

document.body.onload = BodyLoadHandler;
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function DealRemark_DBLClick()
{
	//alert('a')
	//var Name=GetValue("Name");
	//var IDCard=GetValue("IDCard");
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.MessageTemplet:FindMessageTemplet";
	url += "&TLUJSF=SetDealRemak";
	websys_lu(url,1,'');
	return websys_cancel();
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName);
	if (obj) obj.value=value;
}
function SetDealRemak(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("Content",Arr[1]);
}

///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}
function BSelectAll_click()
{
	var tbl=document.getElementById("tDHCPECheckProgress");	//取表格元素?名称
	var row=tbl.rows.length;
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('IFSelect'+'z'+iLLoop);
		if (obj) obj.checked=!obj.checked;
	}
}
function GetSelectId() 
{   
	//alert('sdss3')
	var tbl=document.getElementById("tDHCPECheckProgress");	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val="";
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('IFSelect'+'z'+iLLoop);
		if (obj && obj.checked) {
			
			var obj=document.getElementById("TPAADMz"+iLLoop);
			if (obj) var ID=obj.value;
			
			var obj=document.getElementById("TRegNoz"+iLLoop);
			if (obj) var RegNo=obj.innerText;
			
			var obj=document.getElementById("TTelz"+iLLoop);
			if (obj) var TTel=obj.value;
			
			trim(TTel)
			if (TTel=="") 
			{
				alert("电话不能为空");
				continue;
			}
			if (!isMoveTel(TTel))
			{
				alert("电话号码不正确");
				 continue;
			}
			
			var obj=document.getElementById("Content");
			if (obj) var Content=obj.value;
			
			
			if (vals=="") {vals=ID+"^"+RegNo+"^"+TTel+"^"+Content;}
			else {vals=vals+";"+ID+"^"+RegNo+"^"+TTel+"^"+Content;}
		}
	}
	//if (""==vals) { alert("未选择受检人,操作中止!"); }
	return vals;
}


function BSendMessage_click()
{
	//alert('aha!');
	var Type="PAADM",flag=0;
	var InfoStr=GetSelectId();
	//alert(InfoStr)
	var Stars=InfoStr.split(";")
	for(var PSort=0;PSort<Stars.length;PSort++)
	{
		//alert("PSortsss"+PSort)
		var Star=Stars[PSort];
		//alert(Star)
		var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,Star);
		if (ret!=0) {var flag=1;}
	
	
	
	}
	
	
	
	BFind_click();

	

	
}

function BAddItem_click()
{
		if (""==CurRows) {
			 alert("请先选择要加项的人");
			return false;
	   }

	var PreOrAdd="PRE";
	var GroupFlag=0;
	///如果是团体中的个人当作额外加项
	var obj=document.getElementById("TGroupDescz"+CurRows);
	if (obj)
	{
		if ((obj.innerText!="")&&(obj.innerText!=" ")){
			PreOrAdd="ADD";
			GroupFlag=1;
		}
	}
	var obj=document.getElementById("AddType");
	if (obj&&obj.checked)
	{
		PreOrAdd="PRE";
	}
	var Name="";
	var obj=document.getElementById("TNamez"+CurRows);
	if (obj) Name=obj.innerText;
	if (GroupFlag==1){
		var AddType="自费";
		if (PreOrAdd=="PRE") AddType="公费"
		if (!confirm("确实要给"+Name+AddType+"加项吗")) return false;
	}else{
		if (!confirm("确实要给"+Name+"加项吗")) return false;
	}
	var iRowId="";
	var obj=document.getElementById("TPreIADMz"+CurRows);
	if (obj) iRowId=obj.value;
	/*
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
		*/
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;

	var wwidth=1000;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function BPisRequestPrint_click()
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('tDHCPECheckProgress');	//取表格元素?名称
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		/*
		var Sex="男";
		var obj=document.getElementById("TSexz"+iLLoop);
		if (obj) Sex=obj.innerText;
		if (Sex=="男") continue;
		*/
		var obj=document.getElementById("TPrintz"+iLLoop);
		if (obj&&obj.checked){
			var obj=document.getElementById("TPAADMz"+iLLoop);
			if (!obj) return false;
			var PAAdmId=obj.value;
			PrintByTemplate(PAAdmId);
		}
	}
	/*
	var obj=document.getElementById("TPAADMz"+CurRows);
	if (!obj) return false;
	var PAAdmId=obj.value;
	PrintByTemplate(PAAdmId);
	*/
	return false;
}
function PrintByTemplate(iPAADMDR)
{
	var Template="DHCPEPISRequest"
	var Data=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetSpecialReportInfo",iPAADMDR,Template);
	if (Data==""){
		alert("没有打印的数据");
		return false;
	}
	if (Data!=""){
		PrintReportByXml(Data,Template);
		return false;
	}else{
		alert("没有设置打印格式对应的数据");
		return false;
	}	
}
function PrintReportByXml(ReportData,Template)
{
	DHCP_GetXMLConfig("InvPrintEncrypt",Template);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,ReportData,"");
	return false
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	CurRows=selectrow;
}
function GADMDesc_change()
{
	var  obj=document.getElementById("GADMID");
	if (obj) obj.value="";
}
function RegNoKeyDown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}
function GADMDescSelectAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var  obj=document.getElementById("GADMDesc");
	if (obj) obj.value=Arr[1];
	var  obj=document.getElementById("GADMID");
	if (obj) obj.value=Arr[0];
}