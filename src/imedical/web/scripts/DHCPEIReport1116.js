    
var CurrentSel=0;
var ComponentRows=0;
function BodyLoadHandler() {
	var obj;
	//alert('s')
	//�������
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
		
	obj=document.getElementById("BPrintView");
	if (obj){ obj.onclick = BPrintView; }
	//��ӡ��ť
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick = BPrintView; }
	obj=document.getElementById("SimPrint");
	if (obj){ obj.onclick = BPrintView; }
	//����Word
	obj=document.getElementById("BExport");
	if (obj){ obj.onclick = BPrintView; }
	//����Html
	obj=document.getElementById("BExportHtml");
	if (obj){ obj.onclick = BPrintView; }
	//���Ͱ�ť
	obj=document.getElementById("BSend");
	if (obj){ obj.onclick = BSend_click; }
	
	//���Ͱ�ť
	obj=document.getElementById("BSendSMS");
	if (obj){ obj.onclick = SendSMS_click; }	
	
	//��ѯ��ť
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick = BQuery_click; }
	
	//�Ѵ򱨸�
	obj=document.getElementById("IReportHistory");
	if (obj){ obj.onclick = IReportHistory_click; }	
	                        //BQuery_click
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	obj=document.getElementById("PatName");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	iniForm();
	var obj=document.getElementById("GroupName");
	if (obj) obj.onchange=GroupNameChanged;
	var obj=document.getElementById("TeamName");
	if (obj) obj.onchange=TeamNameChanged;
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}


	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById("BDriverPrint");
	if (obj) {obj.onclick=PrintDriverCard;}


	obj=document.getElementById("RuzhiCoverPrint");
	//alert("obj")
	if (obj) {obj.onclick=RuzhiCoverPrintt_Click;}
	
	
	obj=document.getElementById("BenyuanCoverPrint");
	if (obj) {obj.onclick=BenyuanCoverPrintt_Click;}
	
	ComponentRows=GetCompoentRows("DHCPEIReport");
	SetSort("tDHCPEIReport","TSort",ComponentRows)
	obj=document.getElementById("ExportPersonalResult");
	if (obj) {obj.onclick=ExportPersonalResult_Click;}
	
	//ȫ��ѡ��
	obj=document.getElementById("SelectAll");
	if (obj) {obj.onclick=SelectAll_Click;}
	
	obj=document.getElementById("NoCoverPrint");
	if (obj) {obj.onclick=NoCoverPrint_Click;}
	
	//initialReadCardButton()
	//ShowCurRecord(1);
	Muilt_LookUp('GroupName'+'^'+'TeamName');
}
function RuzhiCoverPrintt_Click()
{  
    //alert('a')
    var obj=document.getElementById("HosCode")
    if(obj){var HosCode=obj.value}
    var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value; 
		if (HosCode=="YY")
		{ 
	   var Templatefilepath=prnpath+'DHCPERuzhiPrint.xls';}
		else{
			var Templatefilepath=prnpath+'DHCPERuzhiPrint.xls';}
		}
		else{
		alert("��Чģ��·��");
		return;
	}
	 
	xlApp = new ActiveXObject("Excel.Application");

    // xlApp.ActivePrinter="Zabra TLP2844"
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1")
    var obj=document.getElementById("PAPMIDR");
	if (obj) { var PAADMID=obj.value}
	var Instring=PAADMID                  
	var Ins=document.getElementById('GetReportCoverInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring);
	if (value=="") return;	
	var Str=value.split("^");
	
	
      if (HosCode=="YY")
      {	xlsheet.cells(1,2).Value=Str[1]; //����
		xlsheet.cells(2,2).Value=Str[2]; //�ǼǺ�
		xlsheet.cells(3,2).Value=Str[3]; //�������	
		xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(3,2)).Font.Name = "����" 
	      }

	   else{
	   //alert(Str)
		var GroupTitle=xlsheet.cells(4,1).Value
		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,2)).mergecells=true; 
		xlsheet.cells(35,4).Value=Str[2];  // dengjihao
		xlsheet.cells(36,4).Value=Str[1]; //����
		xlsheet.cells(37,4).Value=Str[5]; //�Ա�
		xlsheet.cells(38,4).Value=Str[8];
		xlsheet.cells(39,4).Value=Str[6].split(":")[1]; // ��������
		xlsheet.cells(40,4).Value=Str[9]; // ReportDate
		//xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(4,2)).Font.Name = "����" 
	   }
	    xlsheet.printout(1,1,1,false,"tj");
	   

	xlBook.Close (savechanges=false);
	
	xlApp=null;
	
	xlsheet=null;
		
 
}

function BenyuanCoverPrintt_Click()
{  
    
    var obj=document.getElementById("HosCode")
    if(obj){var HosCode=obj.value}
    var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value; 
		if (HosCode=="YY")
		{ 
	   var Templatefilepath=prnpath+'DHCPEBenyuanPrint.xls';}
		else{
			var Templatefilepath=prnpath+'DHCPEBenyuanPrint.xls';}
		}
		else{
		alert("��Чģ��·��");
		return;
	}
	 
	xlApp = new ActiveXObject("Excel.Application");

    // xlApp.ActivePrinter="Zabra TLP2844"
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1")
    var obj=document.getElementById("PAPMIDR");
	if (obj) { var PAADMID=obj.value}
	var Instring=PAADMID                  
	var Ins=document.getElementById('GetReportCoverInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring);
	if (value=="") return;	
	var Str=value.split("^");
	
	
      if (HosCode=="YY")
      {	xlsheet.cells(1,2).Value=Str[1]; //����
		xlsheet.cells(2,2).Value=Str[2]; //�ǼǺ�
		xlsheet.cells(3,2).Value=Str[3]; //�������	
		xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(3,2)).Font.Name = "����" 
	      }

	   else{
	   //alert(Str)
		var GroupTitle=xlsheet.cells(4,1).Value
		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,2)).mergecells=true; 
		xlsheet.cells(35,4).Value=Str[2];  // dengjihao
		xlsheet.cells(36,4).Value=Str[1]; //����
		xlsheet.cells(37,4).Value=Str[5]; //�Ա�
		xlsheet.cells(38,4).Value=Str[8];
		xlsheet.cells(39,4).Value=Str[6].split(":")[1]; // ��������
		xlsheet.cells(40,4).Value=Str[9]; // ReportDate
		//xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(4,2)).Font.Name = "����" 
	   }
	    xlsheet.printout(1,1,1,false,"tj");
	   

	xlBook.Close (savechanges=false);
	
	xlApp=null;
	
	xlsheet=null;
		
 
}



function GetDocName(value){
	var aiList=value.split("^");
	if (""==value){return false;}
	
	obj=document.getElementById("DocName");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("DocDR");
	if (obj) { obj.value=aiList[1]; }
	
	
	
}
function SendEMail(infor, subject)
{
    var jMail = new ActiveXObject("Jmail.message");     
    jMail.Silent = true;
    jMail.Charset = "utf-8";    
    
    jMail.FromName = "��������ɷݹ�˾������ҽ����ҵ��"    //������
    jMail.From = "wangrenzhong@dhcc.com.cn";   //�����˵��ʼ���ַ
    
    //�����ռ���
    jMail.AddRecipient("renzwang@126.com");  //�ռ��˵��ʼ���ַ
  	//�����ܼ��ռ��� 
	jMail.AddRecipientBCC("renzwang@126.com");
	//���ӳ����ռ��� 
	jMail.AddRecipientCC("renzwang@126.com"); 
  	
  	jMail.Subject = "***������챨���ѳ�";
    jMail.Body = "tests";   
    
    //��һ���ļ�����׷�ӵ����ĺ� 
	jMail.AppendBodyFromFile("E:\\worktool\\����\\js\\Excel��PrintOut��ʹ��.txt"); 
	//׷���ż����������� 
	jMail.AppendText("Text   appended   to   message   Body "); 
    
    //����û������X-header��message 
	jMail.AddHeader("Originating-IP ","193.15.14.623"); 
	//�����ͷ 
	jMail.AddNativeHeader("MTA-Settings ","route"); 
    
    jMail.MailServerUserName="wangrenzhong@dhcc.com.cn";
    jMail.MailServerPassWord="7520836";        
    
    jMail.AddURLAttachment("http://127.0.0.1/DTHealth/web/csp/dhcpeireport.normal.csp?PatientID=343958&ReportID=389","AAA.html")     
    //����ļ��������ż� 
	jMail.AddAttachment("E:\\worktool\\����\\js\\Excel��PrintOut��ʹ��.txt"); 
	//A����Զ��帽��.   This   can   be   used   to   attach   "virtual   files "   like   a   generated   text   string   or   certificate   etc. 
	jMail.AddCustomAttachment("readme.txt","Contents   of   file "); 
    //��������б� 
	//jMail.ClearAttachments(); 
	//����ռ����б� 
	//jMail.ClearRecipients(); 
	//��������Զ������ͷ 
	//jMail.ClearCustomHeaders(); 

    var ret = jMail.Send("mail.dhcc.com.cn");  
    if(ret == false)
    {
        alert("fail");
    }
    else
    {
        alert("success");
    }
    jMail.Close();
    
} 
function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BQuery_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","BQuery_click()","CardNo");
	
}

function AfterGroupSelected(value){
	//ROWSPEC = "GBI_Desc:%String, GBI_Code:%String, GBI_RowId:%String"	
	if (""==value){return false}
	var aiList=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=aiList[0];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=aiList[1];
	/*var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[2],true);
	SetCtlValueByID("txtGroupName",aiList[0],true);*/
}
function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=aiList[1];
	var obj=document.getElementById("TeamName");
	if (obj) obj.value=aiList[0];
	
}
function GroupNameChanged()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamName");
	if (obj) obj.value="";
}
function TeamNameChanged()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}

//ȫ����ӡ����
function SelectAll_Click()
{
	var tbl=document.getElementById('tDHCPEIReport');
	var row=tbl.rows.length;

	for (var iLLoop=1;iLLoop<=row;iLLoop++) 
	{
	obj=document.getElementById('TSelect'+'z'+iLLoop);
	if (obj) { obj.checked=!obj.checked; }
	}

	
}

function RegNo_KeyDown(){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BQuery_click();
	}
}
function iniForm() {
	
	SetUpdateStatus("");
	var iReportStatus="";
	var obj;
	
	obj=document.getElementById("ReportStatus");
	if (obj) { iReportStatus=obj.value; }

	//���� δ���
	var obj=document.getElementById("STatusIsNoAudit");
	if (obj && (iReportStatus.indexOf("NA^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	//if (""==iReportStatus) { obj.checked=true; }
	
	//���� ���
	obj=document.getElementById("STatusIsCheched");
	if (obj && (iReportStatus.indexOf("Audited^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	if (""==iReportStatus) { obj.checked=true; }
	//���� ��ӡ
 	obj=document.getElementById("STatusIsPrint");
	if (obj && (iReportStatus.indexOf("PRINTED^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	
	//���� ����
 	obj=document.getElementById("STatusIsSend");
	if (obj && (iReportStatus.indexOf("SEND^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	//���� ��ճ��
 	obj=document.getElementById("HadCompete");
	if (obj && (iReportStatus.indexOf("COMPLETE")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function NoCoverPrint_Click()
{
	//�һ�״̬,�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
		
	var rows;
	var objtbl=document.getElementById('tDHCPEIReport');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	var iRowID="";
	var iPAADM="";
	//alert('1')
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			var RowIDObj=document.getElementById('RPT_RowId'+'z'+i);
			if (RowIDObj){
				var RowID=RowIDObj.value;
				if (iRowID==""){
					iRowID=RowID
				}else{
					iRowID=iRowID+"^"+RowID;
				}
			}
		}
	}
	//alert('2')
	//alert(iRowID)
	if (iRowID!=""){
		Update_click("P",iRowID);
	}else{
		alert("��ѡ�����ӡ����");
	}
	return false;
	//alert('3')
	//�һ�״̬?�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update_click("P");
}
function BPrint_click()
{
		//�һ�״̬,�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
		
	var rows;
	var objtbl=document.getElementById('tDHCPEIReport');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	var iRowID="";
	var iPAADM="";
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			var RowIDObj=document.getElementById('RPT_RowId'+'z'+i);
			if (RowIDObj){
				var RowID=RowIDObj.value;
				if (iRowID==""){
					iRowID=RowID
				}else{
					iRowID=iRowID+"^"+RowID;
				}
			}
		}
	}
	if (iRowID!=""){
		Update_click("P",iRowID);
	}else{
		alert("��ѡ�����ӡ����");
	}
	return false;
	//�һ�״̬?�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update_click("P");
}
function BSend_click()
{
	//�һ�״̬?�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update_click("S");
}
function BSendSMS_click()
{
	//�һ�״̬?�˳�
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update_click("S");
}
// *****************************************************
// ����״̬���� 
function Update_click(iStatus,iRowID){
	 //alert(CoverFlag)
	var iUserUpdateDR="", iDateUpdate="" //,iStatus="";
	var obj;
	
	
	
	
	//�û�����	ȡ��ҳ�ϵ�(�Ự session )�û����� 
	iUserUpdateDR=session['LOGON.USERID'];
  	
  	//ȡ������ʱ��
  	iDateUpdate="";
  	
  	/*if ("BPrint"==eSrc.id) { iStatus="P"; }
  	if ("BSend"==eSrc.id) { iStatus="S"; }
  	if ("BSendSMS"==eSrc.id) { iStatus="S"; }
  	*/
	//obj=document.getElementById("Status");
	//if (obj) { iStatus=obj.value; }
	//alert(iStatus)
	//var CoverFlags=CoverFlag
	if ("P"==iStatus) {
		if (!ShowPrintWindows(iRowID,"")) return true;
		return true;
	}
	//alert('ss')
	//�������	
	var iRowId=""
	
	obj=document.getElementById("RowId");  
	if (obj) { iRowId=obj.value; }

	var Instring=trim(iRowId)				// 1
				+"^"+iStatus				// 2
				+"^"+trim(iUserUpdateDR)	// 3
				+"^"+trim(iDateUpdate)		// 4
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };

	var flag=cspRunServerMethod(encmeth,'','',Instring);

 	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}
	
	//location.reload(); 

}
function SendSMS_click() {
	//
	var iPAADMDR='',iPAPMIDR="",iReportID="";
	var iReceiveType="I"; //DHC_PE_SendMessage.{ SM_ReceiveType }���շ�����
	var iSendType="ReportComplete"; 
	obj=document.getElementById("PAADMDR");
	if (obj){ iPAADMDR=obj.value; }

	obj=document.getElementById("PAPMIDR");
	if (obj){ iPAPMIDR=obj.value; }

	obj=document.getElementById("RowId");
	if (obj){ iReportID=obj.value; }


	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPESendMessage'
			+"&ReceiveID="+iPAPMIDR
			+"&EpisodeID="+iPAADMDR
			+"&ReportID="+iReportID
			+"&SMSType="+iSendType
			+"&ReceiveType="+iReceiveType
			;

	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=400,left=150,top=150';
	window.open(lnk,"_blank",nwin)
}
function SetStyle(obj,Status) {

	if ("H"==Status){
		//����
		obj.disabled=true;
	}
	else{
		//��ʾ
		obj.disabled=false;
	}	
	
}

//���ݵ�ǰ���ߵ�״̬?��ʾ���Խ��еĲ���
function SetUpdateStatus(aStatus){
	var obj;

	obj=document.getElementById("BAudit");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BPrint");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BSend");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BSendSMS");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BDriverPrint");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BAudit");
	if (("NA"==aStatus)) { 
		if (obj) { SetStyle(obj,"V"); }
		return true;
	}

	obj=document.getElementById("BPrint");
	if (("A"==aStatus)||("P"==aStatus)||("S"==aStatus)) {
		if (obj) { SetStyle(obj,"V"); }
	}
	obj=document.getElementById("BDriverPrint");
	if (("A"==aStatus)||("P"==aStatus)||("S"==aStatus)) {
		if (obj) { SetStyle(obj,"V"); }
	}
	obj=document.getElementById("BSend");
	if (("P"==aStatus)||("S"==aStatus)) { 
		if (obj) { SetStyle(obj,"V"); }
	}
	
	obj=document.getElementById("BSendSMS");
	if (("P"==aStatus)||("S"==aStatus)||("C"==aStatus)) {
		if (obj) { SetStyle(obj,"V"); }
	}

	
}


// *************************************************************
/// //////		����ָ����������� ��ʾ��������������Ա�ı������	////////
///web.DHCPE.DHCPEGAdm	bGADMQuery
function BQuery_click() {

	var iRegNo="";			//�ǼǺ�
	var iPatName="";		//��������
	var iDateFrom="",iDateTo="";
	var iSTatus="";	//Ĭ����ʾδ���	
	var iGADM=""
	var iTeamID=""
	var iAuditDateFrom="",iAuditDateEnd="";
	var IsSecret="N";
	var obj;
	var DocDR="";
	
  	obj=document.getElementById("RegNo");
    if (obj){ iRegNo=obj.value; }
    if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); }

  	obj=document.getElementById("PatName");
    if (obj){ iPatName=obj.value; }	
    
	obj=document.getElementById("DateFrom");
	if (obj){ iDateFrom=obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj){ iDateTo=obj.value; }	

 	obj=document.getElementById("STatusIsNoAudit");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"NA"+"^"+"NoAudit"+"^"+"UNCHECKED"; }

 	obj=document.getElementById("STatusIsCheched");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"CHECKED"+"^"+"Audited"+"^"+"A"; }

 	obj=document.getElementById("STatusIsPrint");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"PRINTED"+"^"+"P"; }

	obj=document.getElementById("HadCompete");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"COMPLETE"+"^"+"S"; }

 	obj=document.getElementById("STatusIsSend");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"SEND"+"^"+"S"; }
	
	obj=document.getElementById("GroupID");
	if (obj){ iGADM=obj.value; }
	
	obj=document.getElementById("TeamID");
	if (obj){ iTeamID=obj.value; }	
	
	obj=document.getElementById("AuditDateFrom");
	if (obj){ iAuditDateFrom=obj.value; }
	
	obj=document.getElementById("AuditDateEnd");
	if (obj){ iAuditDateEnd=obj.value; }
	
	obj=document.getElementById("IsSecret");
	if (obj){IsSecret=obj.value;}
	
	obj=document.getElementById("DocDR");
	if (obj){ DocDR=obj.value; }	
	
	obj=document.getElementById("DocName");
	if (obj){var DocName=obj.value; }
	obj=document.getElementById("VIPLevel");
	if (obj){var VIPLevel=obj.value; }
	//alert("DocName="+DocName)
	//alert("DocDR="+DocDR)
	if (DocName==""){DocDR="";}
	//alert("DocName="+DocName)
	//alert("DocDR="+DocDR)
	//alert(VIPLevel)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIReport"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&ReportStatus="+iSTatus
			+"&GroupID="+iGADM
			+"&TeamID="+iTeamID
			+"&AuditDateFrom="+iAuditDateFrom
			+"&AuditDateEnd="+iAuditDateEnd
			+"&IsSecret="+IsSecret
			+"&DocDR="+DocDR
			+"&VIPLevel="+VIPLevel
			;
	
    location.href=lnk; 

}

function Clear_click() {
	
	obj=document.getElementById("RegNo");
    if (obj){ obj.value=""; }


  	obj=document.getElementById("PatName");
    if (obj){ obj.value=""; }
    
	obj=document.getElementById("DateFrom");
	if (obj){ obj.value=""; }
	
	obj=document.getElementById("DateTo");
	if (obj){ obj.value=""; }
	
 	obj=document.getElementById("ReportStatus");
	if (obj){ obj.value=""; }
		
 		obj=document.getElementById("STatusIsNoAudit");
		if (obj) { obj.checked=true; }
		
 		obj=document.getElementById("STatusIsCheched");
		if (obj) { obj.checked=false; }
 		
 		obj=document.getElementById("STatusIsPrint");
		if (obj) { obj.checked=false; }
 		
 		obj=document.getElementById("STatusIsSend");
		if (obj) { obj.checked=false; }
}
function BPrintView(){
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) {return false;}
		
	var rows;
	var objtbl=document.getElementById('tDHCPEIReport');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	var iPAADMStr="";
	var iRowID="";
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			//�һ�״̬,�˳�
			obj=document.getElementById("RPT_PAADM_DRz"+i);
			if (obj){ iPAADMDR=obj.value; }
			var Template=tkMakeServerCall("web.DHCPE.Report","GetTemplateName",iPAADMDR);
			if (Template!=""){
				if (iPAADMStr==""){
					iPAADMStr=iPAADMDR+";"+Template;
				}else{
					iPAADMStr=iPAADMStr+"^"+iPAADMDR+";"+Template;
				}
			}else{
				var RowIDObj=document.getElementById('RPT_RowId'+'z'+i);
				if (RowIDObj){
					var RowID=RowIDObj.value;
					if (iRowID==""){
						iRowID=RowID
					}else{
						iRowID=iRowID+"^"+RowID;
					}
				}
			}
		}
	}
	if ((iRowID!="")||(iPAADMStr!="")){
		//alert(iRowID+"  @@iPAADMStr"+iPAADMStr);
		ShowPrintWindows(iRowID,iPAADMStr);
	}else{
		alert("��ѡ�����ӡ����");
	}
	return false;
}
// ��ʾ ��ӡ����  ����
function ShowPrintWindows(iRowID,iPAADMStr) {
	//alert(iPAADMStr+"iPAADMStr")
	var iPAADMDR='',iPAPMIDR="",iReportID="",iprnpath="",VipReturn="1"
	obj=document.getElementById("PAADMDR");
	if (obj){ iPAADMDR=obj.value; }
	obj=document.getElementById("PAPMIDR");
	if (obj){ iPAPMIDR=obj.value; }	
	obj=document.getElementById("GetIReportStatus");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,iPAPMIDR,"I");
	//alert(flag)
	if (flag!=0)
	{	var eSrc=window.event.srcElement;
		if (eSrc.id!="BPrintView")
		{
			
			if (!confirm(t[flag])) {
			//alert('1')
			return false;
			}
		}
	}
	var Type="Export",OnlyAdvice="";
	var eSrc=window.event.srcElement;
	//alert(eSrc.id)
	if (eSrc.id=="BPrintView"){
		Type="View"
	}else if(eSrc.id=="BPrint"){
		Type="Print"
		var CoverFlag="0"
	}else if(eSrc.id=="BExportHtml"){
		Type="ExportHTML"
	}else if(eSrc.id=="SimPrint"){
		Type="Print"
		OnlyAdvice="N";
		var CoverFlag="0"
	}else if(eSrc.id=="NoCoverPrint"){
		Type="Print"
		var CoverFlag="1"
		//OnlyAdvice="N";
	}
	
	//alert(Type);
	obj=document.getElementById("prnpath");
	if (obj){ iprnpath=obj.value; }
	//alert(iPAADMStr);
	
	if (iPAADMStr!=""){
		alert("iPAADMStr"+iPAADMStr);
		PrintTemplateReport(iPAADMStr);
	}
	if (iRowID=="") return true;
	obj=document.getElementById("ReportNameBox");
	if (obj) { var iReportName=obj.value; }
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
	var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+iRowID+"&prnpath="+iprnpath+"&Type="+Type+"&OnlyAdvice="+OnlyAdvice+"&CoverFlag="+CoverFlag;
	
	//alert("lnk="+lnk)
	open(lnk,"_blank",nwin);
	return true;
}
// *******************************************************
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('RPT_RowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		if (obj) { obj.value=SelRowObj.value; }	
		//alert("RowId"+obj.value)
	}
	
	SelRowObj=document.getElementById('RPT_PAADM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PAADMDR");
		if (obj) { obj.value=SelRowObj.value; }
		//alert("PAADMDR"+obj.value)
	}
	
	SelRowObj=document.getElementById('RPT_IADM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("PAPMIDR");
		if (obj) { obj.value=SelRowObj.value; }	
		//alert("PAPMIDR"+obj.value)
	}

	SelRowObj=document.getElementById('RPT_Status'+'z'+selectrow);
	if (SelRowObj) {
		
		obj=document.getElementById("Status");
		if (obj) { 
			obj.value=trim(SelRowObj.value); 
			SetUpdateStatus(obj.value);
		}
	}
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {	    
		CurrentSel=0
		return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
function SetSort(TableName,ElementName,RowsOfPages)
{    
	var obj=document.getElementsByTagName("SMALL");
	var Page=1
	if(obj[0]) Page=obj[0].innerText;
	var AddRows=(+Page-1)*RowsOfPages
	var obj=document.getElementById(TableName);	
	if (obj) { var rows=obj.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ElementName+"z"+j)
		if (obj) obj.innerText=AddRows+(+j)
	}
	
}
function GetCompoentRows(ComponentName)
{
	var obj=document.getElementById("GetRowsClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return 0;
	}
	var ComponentRows=cspRunServerMethod(encmeth,session['CONTEXT'],ComponentName)
	if (ComponentRows=="") ComponentRows=25;
	return ComponentRows
}
/*
//��ӡ������� 2008-05-09 zhouli
function PrintReportCoverInfo()
{
    var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintReportCoverInfo.xls';
		//alert("path:"+Templatefilepath);
		}
		else{
		alert("��Чģ��·��");
		return;
	}
	//alert("prnpath:"+Templatefilepath);
	//alert("4444");
	xlApp = new ActiveXObject("Excel.Application");
	//alert("5555");
	
   	// xlApp.ActivePrinter="Zabra TLP2844"
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1")
    
	
    //var Obj=document.getElementById("PAADMDR");modified by gwj
    var Obj=document.getElementById("PAPMIDR");
	if (Obj) { var PAADMID=Obj.value}
	var Instring=PAADMID                 
	var Ins=document.getElementById('GetReportCoverInfoBox');
	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	
	var value=cspRunServerMethod(encmeth,Instring);
	
	if (value=="") return;	
	var Str=value.split("^");
      
		xlsheet.cells(1,2).Value=Str[1]; //����
		
		
		xlsheet.cells(2,2).Value=Str[2]; //�ǼǺ�
		
		xlsheet.cells(3,2).Value=Str[3]; //�������
		
		//xlsheet.cells(4,2).Value=Str[4]; //��ϵ�绰
		
		xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(3,2)).Font.Name = "����" 
	   
	    xlsheet.printout(1,1,1,false,"tj");
	   
	 //xlsheet.SaveAs("d:\\������Ա����.xls");
	xlBook.Close (savechanges=false);
	
	xlApp=null;
	
	xlsheet=null;
		
  // xlApp.Visible = true;
  // xlApp.UserControl = true;
 
}
*/
function PrintReportCoverInfo()
{  
    
    var obj=document.getElementById("HosCode")
    if(obj){var HosCode=obj.value}
    var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value; 
		if (HosCode=="YY")
		{ 
	   var Templatefilepath=prnpath+'DHCPEPrintReportCoverInfo.xls';}
		else{
			var Templatefilepath=prnpath+'DHCPEPrintReportCoverInfoAZ.xls';}
		}
		else{
		alert("��Чģ��·��");
		return;
	}
	 
	xlApp = new ActiveXObject("Excel.Application");

    // xlApp.ActivePrinter="Zabra TLP2844"
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1")
    var obj=document.getElementById("PAPMIDR");
	if (obj) { var PAADMID=obj.value}
	var Instring=PAADMID                  
	var Ins=document.getElementById('GetReportCoverInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring);
	if (value=="") return;	
	var Str=value.split("^");
	
	
      if (HosCode=="YY")
      {	xlsheet.cells(1,2).Value=Str[1]; //����
		xlsheet.cells(2,2).Value=Str[2]; //�ǼǺ�
		xlsheet.cells(3,2).Value=Str[3]; //�������	
		xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(3,2)).Font.Name = "����" 
	      }

	   else{
		var GroupTitle=xlsheet.cells(4,1).Value
		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,2)).mergecells=true; 
		xlsheet.cells(1,1).Value=Str[1]; //����
		xlsheet.cells(2,2).Value=Str[3]; //�������	
		xlsheet.cells(4,1).Value=Str[6]; // ��������
		xlsheet.cells(3,2).Value=Str[7]; // ReportDate
		//xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(4,2)).Font.Name = "����" 
	   }
	    xlsheet.printout(1,1,1,false,"tj");
	   

	xlBook.Close (savechanges=false);
	
	xlApp=null;
	
	xlsheet=null;
		
 
}
function PrintDriverCard()
{
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEDriverCard';
	}else{
		alert("��Чģ��·��");
		return;
	}
	var DataObj=document.getElementById("GetDriverInfo");
	var encmeth="";
	if (DataObj) encmeth=DataObj.value;
	if (encmeth=="") return true;
	var ResultObj=document.getElementById("GetResultValue");
	var ResultEncmeth=""
	if (ResultObj) ResultEncmeth=ResultObj.value;
	if (ResultEncmeth=="") return true;
	var obj=document.getElementById("PAADMDR");
	var PAADM="";
	if (obj) PAADM=obj.value;
	var InfoData=cspRunServerMethod(encmeth,PAADM);
	var DataArr=InfoData.split("^");
	var Flag=DataArr[0];
	Templatefilepath=Templatefilepath+Flag+".xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.cells(3,4)=DataArr[1];
	xlsheet.cells(3,8)=DataArr[2];
	xlsheet.cells(11,23)=DataArr[4];
	FillDriverData(xlsheet,9,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,9,18,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,10,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,11,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,12,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,13,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,14,5,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,12,18,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,13,18,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,14,18,PAADM,ResultEncmeth);
	FillDriverData(xlsheet,15,18,PAADM,ResultEncmeth);
	xlsheet.printout;
	xlsheet = xlBook.WorkSheets("Sheet2");
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;

}
function FillDriverData(xlsheet,Row,Col,PAADM,ResultEncmeth)
{
	var VData=xlsheet.cells(Row,Col).value;
	var VArr=VData.split("^");
	var ODID=VArr[1];
	var Value=VArr[0];
	var ResultValue=cspRunServerMethod(ResultEncmeth,PAADM,ODID);
	Value=Value+ResultValue;
	xlsheet.cells(Row,Col)=Value;

}
function ExportPersonalResult_Click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
    
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
  	var obj=document.getElementById("PAADMDR");
	if (obj) var PAADMPara=obj.value;
	var Ins=document.getElementById('PersonalResultBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	if (PAADMPara=="") {alert("��ѡ��һ��������¼")}
	var flag=cspRunServerMethod(encmeth,PAADMPara);
 	var IADMInfo=flag.split("#");

 	var GName=""
 	for (var i=0;i<IADMInfo.length;i++)
 	{    
	 	GName=IADMInfo[i].split("^")[5];
	 	xlsheet.cells(i+3,1)=IADMInfo[i].split("^")[0];
	 	xlsheet.cells(i+3,2)=IADMInfo[i].split("^")[1];
	 	xlsheet.cells(i+3,3)=IADMInfo[i].split("^")[2];
	 	xlsheet.cells(i+3,4)=IADMInfo[i].split("^")[3];
	 	xlsheet.cells(i+3,5)=IADMInfo[i].split("^")[4];
	 	xlsheet.cells(i+3,6)=IADMInfo[i].split("^")[5];
	 	xlsheet.cells(i+3,7)=IADMInfo[i].split("^")[6];
	    xlsheet.cells(i+3,8)=IADMInfo[i].split("^")[7];
	    xlsheet.cells(i+3,9)=IADMInfo[i].split("^")[8];
	
	 	var PAADM=IADMInfo[i].split("^")[9];
	    var PIADM=IADMInfo[i].split("^")[10];
	 	var Ins=document.getElementById('PersonalInfoBox');
		if (Ins) { var encmeth=Ins.value; } 
		else { var encmeth=''; };
	
	 	var Result=cspRunServerMethod(encmeth,PAADM);
	
	    var NKJWS="" ,WKJWS="",JWS=""
	 	//Result��ʽ:  ҽ��ID_":"_ϸ��ID_":"_ϸ����_"^"_ҽ��ID_":"_ϸ��ID_":"_ϸ����
 		  var ResultString=Result.split("^");
 		  var ResultCount=ResultString.length  
 		  for (var j=0;j<ResultCount;j++)
 		  {
	      
 		  var ARCIMDR=ResultString[j].split("@")[0]
 		  var ODDR=ResultString[j].split("@")[1]
 		  var ODResult=ResultString[j].split("@")[2]
 		  if ((ODDR=="1||18")&&(ARCIMDR=="15336||1"))
 		   { if (ODResult!="��") var JWS=JWS+" "+ODResult}   
 		  if ((ODDR=="1||19")&&(ARCIMDR=="15336||1")) 
 		  { if (ODResult!="��") var JWS=JWS+"  "+ODResult}   
 		   xlsheet.cells(i+3,10)=JWS ;//����ʷ 

 		  if ((ODDR=="1||21")&&(ARCIMDR=="15336||1"))   {xlsheet.cells(i+3,11)=ODResult };//����ʷ
 	      if ((ODDR=="1||6")&&(ARCIMDR=="15336||1"))     {xlsheet.cells(i+3,12)=ODResult} ;   //����ʷ
 		  if ((ODDR=="1||5")&&(ARCIMDR=="15336||1"))      xlsheet.cells(i+3,13)=ODResult  ;  //����ʷ
 	      if ((ODDR=="1||22")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,14)=ODResult ;  //�˶�ʷ
 		  if ((ODDR=="1||1")&&(ARCIMDR=="15336||1"))     xlsheet.cells(i+3,15)=ODResult 	 
 		  if ((ODDR=="1||2")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,16)=ODResult;    //����
 	      if ((ODDR=="1||3")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,17)=ODResult ;   //BMI
 		  if ((ODDR=="1||8")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,18)=ODResult ;   //��Χ
 		  if ((ODDR=="1||15")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,19)=ODResult;   //����ѹ
 	      if ((ODDR=="1||9")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,20)=ODResult  ;  //����ѹ
 		  if ((ODDR=="1||17")&&(ARCIMDR=="15336||1"))    xlsheet.cells(i+3,21)=ODResult ;   //����
 		    
 	      //Ѫ������Ŀ:
 	      //	ע	��ע ����ϸ����	�ȼ�ϸ����	�ȼ�ϸ���ٷֱ�	*��ϸ��	*Ѫ�쵰��	*��ϸ��ѹ��	*ƽ����ϸ�����
 	      //*ƽ��Ѫ�쵰����	*ƽ��Ѫ�쵰��Ũ��	*ѪС��	ѪС��ƽ�����	������ϸ���ٷֱ�	�ܰ�ϸ���ٷֱ�	����ϸ���ٷֱ�	
 	      //����ϸ���ٷֱ�	�ȼ�ϸ���ٷֱ�	������ϸ����	�ܰ�ϸ����	����ϸ����	����ϸ����	�ȼ�ϸ����	ѪС��ѹ��	ѪС��ֲ����	
 	      //�к�ϸ���ٷֱ�	�к˺�ϸ������	��ϸ���ֲ����-SDֵ	��ϸ���ֲ����-CVֵ	��ѪС�����	DIFF	��ϸ���ֲ����	CBC	����ϸ���ٷֱ�	*��ϸ��
 	      
 		  if ((ODDR=="8||1")&&(ARCIMDR=="12147||1"))     xlsheet.cells(i+3,22)=ODResult ;
 		  if ((ODDR=="8||2")&&(ARCIMDR=="12147||1"))     xlsheet.cells(i+3,23)=ODResult ; 
 		  if ((ODDR=="8||412")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,24)=ODResult ;
 		  if ((ODDR=="8||414")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,25)=ODResult ;
 		  if ((ODDR=="8||415")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,26)=ODResult ;
 		  if ((ODDR=="8||356")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,27)=ODResult ;
 		  if ((ODDR=="8||417")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,28)=ODResult ;
 		  if ((ODDR=="8||418")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,29)=ODResult ;
 		  if ((ODDR=="8||419")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,30)=ODResult ;
 		  if ((ODDR=="8||420")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,31)=ODResult ;
 		  if ((ODDR=="8||421")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,32)=ODResult ;
 		  if ((ODDR=="8||423")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,33)=ODResult     //*ѪС��
 		  if ((ODDR=="8||424")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,34)=ODResult 
 		  if ((ODDR=="8||357")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,35)=ODResult 
 		  if ((ODDR=="8||358")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,36)=ODResult 
 		  if ((ODDR=="8||425")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,37)=ODResult 
 		  if ((ODDR=="8||426")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,38)=ODResult 
 		  if ((ODDR=="8||427")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,39)=ODResult 
 		  if ((ODDR=="8||428")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,40)=ODResult 
 		  if ((ODDR=="8||429")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,41)=ODResult 
 		  if ((ODDR=="8||430")&&(ARCIMDR=="12147||1"))   xlsheet.cells(i+3,42)=ODResult 
 		  if ((ODDR=="8||431")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,43)=ODResult    
 		  if ((ODDR=="8||432")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,44)=ODResult   
 	      if ((ODDR=="8||433")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,45)=ODResult  
 		  if ((ODDR=="8||434")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,46)=ODResult    //ѪС��ֲ����
 		  if ((ODDR=="8||435")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,47)=ODResult   
 	      if ((ODDR=="8||436")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,48)=ODResult    
 		  if ((ODDR=="8||437")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,49)=ODResult    
 		  if ((ODDR=="8||438")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,50)=ODResult  
 	      if ((ODDR=="8||439")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,51)=ODResult   
 		  if ((ODDR=="8||1191")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,52)=ODResult    
 		  if ((ODDR=="8||422")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,53)=ODResult    
 		  if ((ODDR=="8||1190")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,54)=ODResult  
 		  if ((ODDR=="8||413")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,55)=ODResult    
 		  if ((ODDR=="8||416")&&(ARCIMDR=="12147||1"))    xlsheet.cells(i+3,56)=ODResult    
 	      
 	   
 	      //����������Ŀ:
 	      //ע	��ע	���������˾�����
 	      if ((ODDR=="8||1")&&(ARCIMDR=="3299||1"))     xlsheet.cells(i+3,57)=ODResult  
 		  if ((ODDR=="8||2")&&(ARCIMDR=="3299||1"))     xlsheet.cells(i+3,58)=ODResult    
 		  if (ODDR=="8||73")    xlsheet.cells(i+3,59)=ODResult   
       
 	      
 	      //�򳣹���Ŀ�G
 	      //ע	��ע	RBC(��ϸ��)	WBC(��ϸ��)	����	������	ͪ��	����	����
 	      //��Ԫ	��������	ǱѪ	��ϸ���]LEU�^	ά����C	����
 	      if ((ODDR=="8||1")&&(ARCIMDR=="3032||1"))      xlsheet.cells(i+3,60)=ODResult 
 	      if ((ODDR=="8||260")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,61)=ODResult 
 	      if ((ODDR=="8||261")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,62)=ODResult 
 	      if ((ODDR=="8||262")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,63)=ODResult 
          if ((ODDR=="8||263")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,64)=ODResult 
          if ((ODDR=="8||264")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,65)=ODResult 
          if ((ODDR=="8||265")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,66)=ODResult 
          if ((ODDR=="8||267")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,67)=ODResult  //���� 
          if ((ODDR=="8||268")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,68)=ODResult 
          if ((ODDR=="8||269")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,69)=ODResult 
          if ((ODDR=="8||270")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,70)=ODResult 
          if ((ODDR=="8||271")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,71)=ODResult 
          if ((ODDR=="8||272")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,72)=ODResult 
          if ((ODDR=="8||273")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,73)=ODResult 
          if ((ODDR=="8||266")&&(ARCIMDR=="3032||1"))    xlsheet.cells(i+3,74)=ODResult 
          
          //�Ҹ�������ֵ  ע ��ע *�Ҹα��濹ԭ *�Ҹα��濹�� *�Ҹ�e��ԭ *�Ҹ�e���� *�Ҹκ��Ŀ���
 	      if ((ODDR=="8||1")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,75)=ODResult  
          if ((ODDR=="8||2")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,76)=ODResult 
          if ((ODDR=="8||324")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,77)=ODResult
          if ((ODDR=="8||351")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,78)=ODResult  
          if ((ODDR=="8||352")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,79)=ODResult 
          if ((ODDR=="8||353")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,80)=ODResult
          if ((ODDR=="8||354")&&(ARCIMDR=="10752||1"))    xlsheet.cells(i+3,81)=ODResult
          
 	      //���������������Ŀ:CEA  AFP  CA19-9 FER B2MG   CA125 CA153 BHCG   ǰ����ϵͳ  SCC �ײͶ�Ӧ��ϸ�����¡G
          //���߿�ԭ  ��̥���� ������ԭ199  ������ Ѫ��?2-΢�򵰰�  ������ԭ125 ������ԭ153
          //?����ëĤ�����ټ��� FPSA/TPSA ǰ�������쿹ԭ ����ǰ���������Կ�ԭ
          //ע��GSCC�ײ�����״��Ƥϸ������ԭ�ⶨ(TLA)ҽ�� û����
 	      if ((ODDR=="8||1147")&&(ARCIMDR=="10765||1"))    xlsheet.cells(i+3,82)=ODResult  //���߿�ԭ
          if ((ODDR=="8||1146")&&(ARCIMDR=="10766||1"))    xlsheet.cells(i+3,83)=ODResult 
          if ((ODDR=="8||1148")&&(ARCIMDR=="10764||1"))    xlsheet.cells(i+3,84)=ODResult 
 	      if ((ODDR=="8||333")&&(ARCIMDR=="10779||1"))     xlsheet.cells(i+3,85)=ODResult 
          if ((ODDR=="8||697")&&(ARCIMDR=="10780||1"))     xlsheet.cells(i+3,86)=ODResult 
          if ((ODDR=="8||1152")&&(ARCIMDR=="10763||1"))    xlsheet.cells(i+3,87)=ODResult 
          if ((ODDR=="8||1151")&&(ARCIMDR=="10784||1"))    xlsheet.cells(i+3,88)=ODResult 
          if ((ODDR=="8||542")&&(ARCIMDR=="10776||1"))     xlsheet.cells(i+3,89)=ODResult 
          if ((ODDR=="8||544")&&(ARCIMDR=="11807||1"))     xlsheet.cells(i+3,90)=ODResult      // FPSA/TPSA  
          if ((ODDR=="8||1149")&&(ARCIMDR=="11807||1"))    xlsheet.cells(i+3,91)=ODResult      //ǰ�������쿹ԭ
          if ((ODDR=="8||1150")&&(ARCIMDR=="11807||1"))    xlsheet.cells(i+3,92)=ODResult      //����ǰ���������Կ�ԭ
           if ((ODDR=="8||1205")&&(ARCIMDR=="20389||1"))    xlsheet.cells(i+3,93)=ODResult   // ��״��Ƥϸ������ԭ�ⶨ(TLA

 	      //����������Ŀ:����I(TLA) �Bͬ�Ͱ��װ���(TLA)
 	      //����1(TLA)���ϸ��33���G ��ע ע  *�ȱ�ת��ø *�Ȳ�ת��ø *�ܵ����� *ֱ�ӵ����� *��������ø *����
 	      // *���� *���� *�������� *�ܵ��̴� ���ܶ�֬���׵��̴� ���ܶ�֬���׵��̴�   ���ἤøͬ��ø����
          //*���ἡ�ἤø    *��������ø   *������  *�ܵ���   *�׵���   ǰ�׵���  *?�Ȱ���ת��ø  *��
          //    *��   �ܵ�֭��   �ܶ�����̼    *��  *�� *�� þ �׵��ױ��򵰰� �����Ӽ�϶ �����Ѱ�ø ����C-��Ӧ����	����֬ø


 	      if ((ODDR=="8||2")&&(ARCIMDR=="19609||1"))     xlsheet.cells(i+3,94)=ODResult  //    
 	      if ((ODDR=="8||1")&&(ARCIMDR=="19609||1"))     xlsheet.cells(i+3,95)=ODResult  //	      
 	      if (ODDR=="8||457")    xlsheet.cells(i+3,96)=ODResult  //	      
 	      if (ODDR=="8||458")    xlsheet.cells(i+3,97)=ODResult  // 	      
 	      if (ODDR=="8||462")   xlsheet.cells(i+3,98)=ODResult  //      
 	      if (ODDR=="8||463")    xlsheet.cells(i+3,99)=ODResult  //      
 	      if (ODDR=="8||355")   xlsheet.cells(i+3,100)=ODResult  //
 	      if (ODDR=="8||468")   xlsheet.cells(i+3,101)=ODResult  //
 	      if (ODDR=="8||469")   xlsheet.cells(i+3,102)=ODResult  //
 	      if (ODDR=="8||470")    xlsheet.cells(i+3,103)=ODResult  //
 	      if (ODDR=="8||483")   xlsheet.cells(i+3,104)=ODResult  //  
 	      if (ODDR=="8||484")   xlsheet.cells(i+3,105)=ODResult  //
 	      if (ODDR=="8||485")    xlsheet.cells(i+3,106)=ODResult  //  
 	      if (ODDR=="8||486")    xlsheet.cells(i+3,107)=ODResult  //   
 	      if (ODDR=="8||480")  xlsheet.cells(i+3,108)=ODResult 
 	      if (ODDR=="8||481")     xlsheet.cells(i+3,109)=ODResult 
          if (ODDR=="8||482")    xlsheet.cells(i+3,110)=ODResult 
          if (ODDR=="8||471")    xlsheet.cells(i+3,111)=ODResult 
          if (ODDR=="8||459")   xlsheet.cells(i+3,112)=ODResult 
          if (ODDR=="8||460")     xlsheet.cells(i+3,113)=ODResult 
          if (ODDR=="8||464")    xlsheet.cells(i+3,114)=ODResult      //  
          if (ODDR=="8||465")   xlsheet.cells(i+3,115)=ODResult      //
          if (ODDR=="8||477")    xlsheet.cells(i+3,116)=ODResult
          if (ODDR=="8||478")    xlsheet.cells(i+3,117)=ODResult  //
 	      
 	      if (ODDR=="8||466")     xlsheet.cells(i+3,118)=ODResult 
          if (ODDR=="8||472")     xlsheet.cells(i+3,119)=ODResult 
          if (ODDR=="8||473")    xlsheet.cells(i+3,120)=ODResult 
          if (ODDR=="8||474")   xlsheet.cells(i+3,121)=ODResult 
          if (ODDR=="8||475")     xlsheet.cells(i+3,122)=ODResult 
          if (ODDR=="8||479")     xlsheet.cells(i+3,123)=ODResult      
          if (ODDR=="8||461")    xlsheet.cells(i+3,124)=ODResult     
          if (ODDR=="8||476")   xlsheet.cells(i+3,125)=ODResult 
          if (ODDR=="8||467")   xlsheet.cells(i+3,126)=ODResult  
          if (ODDR=="8||1153")    xlsheet.cells(i+3,127)=ODResult 
          if (ODDR=="8||1166")    xlsheet.cells(i+3,128)=ODResult              
 	      //ͬ�Ͱ��װ���(TLA)ҽ��ϵͳû����ϸ��
 	      if ((ODDR=="8||334")&&(ARCIMDR=="10781||1"))    xlsheet.cells(i+3,129)=ODResult        
 	      //������ж�ҽ��ID
 	      //�������� 	     
 	       if (ARCIMDR=="11219||1")    xlsheet.cells(i+3,130)=ODResult 
 	      //�ӹ���������
 	     if (ARCIMDR=="3736||1")    xlsheet.cells(i+3,131)=ODResult 
 	      //���ٳ���
 	     if (ARCIMDR=="3763||1")    xlsheet.cells(i+3,132)=ODResult 
 	      //��״�ٳ���	
 	     if (ARCIMDR=="11223||1")    xlsheet.cells(i+3,133)=ODResult 
 	      //��͸	
 	     if ((ARCIMDR=="15381||1")||(ARCIMDR=="3480||1") )    xlsheet.cells(i+3,134)=ODResult 

 	      //�������
 	     if (ARCIMDR=="3563||1")    xlsheet.cells(i+3,135)=ODResult 
 	     if (ARCIMDR=="3562||1")    xlsheet.cells(i+3,136)=ODResult	
 	     if (ARCIMDR=="3561||1")    xlsheet.cells(i+3,137)=ODResult	
 	      //TCT�G	���Ʋ���B�ͱ���ϸ��ѧ���
       if ((ODDR=="7||1")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,138)=ODResult        
 	   if ((ODDR=="7||2")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,139)=ODResult 
 	   if ((ODDR=="7||4")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,140)=ODResult 
 	   if ((ODDR=="7||6")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,141)=ODResult 
 	   if ((ODDR=="7||7")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,142)=ODResult 
 	   if ((ODDR=="7||8")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,143)=ODResult 
 	   if ((ODDR=="7||9")&&(ARCIMDR=="15342||1"))    xlsheet.cells(i+3,144)=ODResult 
                                                             
 	   if (ARCIMDR=="12226||1")    xlsheet.cells(i+3,145)=ODResult
 	    //��׵
        if (ARCIMDR=="15348||1")    xlsheet.cells(i+3,146)=ODResult
 	   //�ĵ�ͼ
 	   if (ARCIMDR=="15346||1")    xlsheet.cells(i+3,147)=ODResult
 	   //���ܶ�
 	    if (ARCIMDR=="13604||1")    xlsheet.cells(i+3,148)=ODResult
 	     //MRA
        if (ARCIMDR=="3699||1")    xlsheet.cells(i+3,149)=ODResult
 	   //MRI
 	   if (ARCIMDR=="3652||1")    xlsheet.cells(i+3,150)=ODResult
 	   //CT
 	    if (ARCIMDR=="15367||1")    xlsheet.cells(i+3,151)=ODResult
 		  }
	 
	//if (xlsheet.cells(i+3,10)=="") {xlsheet.cells(i+3,10)="��"	}
	  	
	}
    var fdir="d:\\�������"
     var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(fdir)){
		fso.CreateFolder(fdir);
	}
	xlsheet.SaveAs(fdir+"\\"+GName+"�������.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlsheet=null;
	xlApp=null;
	
	
}
function PrintTemplateReport(PAADMStr)
{
	//alert('1')
	alert(PAADMStr);
	var Arr=PAADMStr.split("^");
	var ArrLength=Arr.length;
	for (i=0;i<ArrLength;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(";");
		alert(OneArr[0]);
		alert(OneArr[1]);
		PrintReportByTemplate(OneArr[0],OneArr[1]);
	}
}
function PrintReportByTemplate(iPAADMDR,Template)
{
	//alert("iPAADMDR"+iPAADMDR+"   Template"+Template);
	var Data=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetSpecialReportInfo",iPAADMDR,Template);
	if (Data!=""){
		if (Template.split(".xls").length>1){
			PrintReportExcel(Data,Template);
		}else{
			PrintReportXml(Data,Template);
		}
	}else{
		alert("û�����ô�ӡ��ʽ��Ӧ������");
		return false;
	}
	
}
function PrintReportExcel(ReportData,Template)
{
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+Template;
	}else{
		alert("��Чģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	//xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet = xlBook.ActiveSheet;
	var char_2=String.fromCharCode(2);
	var DataArr=ReportData.split("^");
	var Length=DataArr.length;
	for (i=0;i<Length-1;i++)
	{
		var OneInfo=DataArr[i];
		var OneArr=OneInfo.split(char_2);
		var Result=OneArr[1];
		var Position=OneArr[0];
		if (Position=="") continue;
		var PositionArr=Position.split(";");
		var Row=+PositionArr[0];
		var Col=+PositionArr[1];
		//var OldInfo=xlsheet.cells(Row,Col).Value;
		//alert(Row)
		//alert(Col)
		//alert(Result)
		xlsheet.cells(Row,Col).value=Result
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}

function PrintReportXml(ReportData,Template)
{
	DHCP_GetXMLConfig("InvPrintEncrypt",Template);
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,ReportData,"");
}
function BSimPrint()
{
	var rows,obj;
	var objtbl=document.getElementById('tDHCPEIReport');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	var iPAADMStr="";
	var iRowID="";
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			//�һ�״̬,�˳�
			obj=document.getElementById("RPT_PAADM_DRz"+i);
			if (obj){ iPAADMDR=obj.value; }
		
			var RowIDObj=document.getElementById('RPT_RowId'+'z'+i);
			if (RowIDObj){
			var iRowID=RowIDObj.value;
			}
		}
	}
	
	obj=document.getElementById("ReportNameBoxSim");
	if (obj) { var iReportName=obj.value; }
	alert(iReportName)
	obj=document.getElementById("prnpath");
	if (obj){ iprnpath=obj.value; }	
	
	var Type=""
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
	var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+iRowID+"&prnpath="+iprnpath+"&Type="+Type;
	alert(lnk)
	open(lnk,"_blank",nwin);
	return true;
}
function IReportHistory_click()
{
	var iGADM="",obj;
	var iTeamID=""
	var iVIPLevel=""
	obj=document.getElementById("GroupID");
	if (obj){ iGADM=obj.value; }
	
	obj=document.getElementById("TeamID");
	if (obj){ iTeamID=obj.value; }	
	

	obj=document.getElementById("VIPLevel");
	if (obj){var iVIPLevel=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIReportPHistory"
			+"&ID="+""
			+"&PDateFrom="+""
			+"&PDateTo="+""
			+"&GroupID="+iGADM
			+"&TeamID="+iTeamID
			+"&VIPLevel="+iVIPLevel
			;
	var wwidth=800;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	window.open(lnk,"_blank",nwin)	

}
document.body.onload = BodyLoadHandler;
