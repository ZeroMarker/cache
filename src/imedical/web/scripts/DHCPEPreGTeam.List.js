/// DHCPEPreGTeam.List.js
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	//�½���ĿBNewItem_click
	obj=document.getElementById("BNewItem");
	if (obj){ 
		//obj.onclick=NewItem_click; 
		obj.onclick=BNewItem_click;
		websys_disable(obj)
	}
	
	//ɾ������  Delete_click  //Delete_click
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }	
	                 
	//ԤԼ���
	obj=document.getElementById("BTeamPreOver");
	if (obj){ obj.onclick=BTeamPreOver_click; }
	
	obj=document.getElementById("BRegister");
	if (obj){ obj.onclick=BRegister_click; }
	obj=document.getElementById("BArrived");
	if (obj){ obj.onclick=BArrived_click; }
	
	//�������ӡ����ƾ��
	obj=document.getElementById("PrintTeamPerson");
	if (obj){ obj.onclick=PrintTeamPerson_click2; }
	//����
	obj=document.getElementById("ContinuePrintTeamPer");
	if (obj){ obj.onclick=ConPrintTPerson_click; }
	
	obj=document.getElementById("BCopyTeam");
	if (obj){ obj.onclick=BCopyTeam_click; 
		      websys_disable(obj);
		    }
		    
	obj=document.getElementById("ContinueRegNo"); 
	if (obj) {
		 obj.onkeydown= ContinueRegNo_keydown;
	}

	//��ӡ���ﵥ
	obj=document.getElementById("BPrintPatItem");
	if (obj){ obj.onclick=BPrintPatItem_click; }

	iniForm();
	StatusContralEnabled();
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");

}

function BPrintPatItem_click()
{
	var Instring,PAADM
	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) 
	{alert("����ѡ�����");
	 return false;}
	var IDS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetTeamIADM",iRowId)
	if (IDS=="")
	{
		alert("û����Ҫ��ӡ������")
		return
		
		}
	var temprow=IDS.split("^");
	for(i=0;i<=(temprow.length-1);i++)
	{
		PAADM=temprow[i]
		Instring=PAADM+"^1^PAADM";
		var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);

		Print(value,1,"N"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
		var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
		
		}
	
	}

function PrintTeamPerson_click2()
{
	PrintTeamPerson_click("");
}
//�������ӡ
function PrintTeamPerson_click(ConRegNo)
{
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
    var myDate = new Date();
    myDate.getFullYear();
    
    var obj=document.getElementById("RowId");
    if(obj)  {var PGADMID=obj.value;} 	//team
    if ((""==PGADMID)){
		alert("δѡ�����");
		return false;	}
    var Instring=PGADMID;
    var obj=document.getElementById("DataBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    var returnval=cspRunServerMethod(encmeth,Instring,"Y",ConRegNo);
    var str=returnval; 
    var temprow=str.split("^");
   	if(temprow=="")
   	{
		alert("��������Ա����Ϊ��")
	   	return;
	} 
   	encmeth=document.getElementById("GetOneInfoClass").value;
   	
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i]);
	    var tempcol=row.split("^");
	    var j=(i+1)%6;
	    var Rows,Cols;
	    if (j==1){
	        Rows=0; 
	        Cols=0; 
	    }
	    if (j==2){
	        Rows=0;  
	        Cols=7; 		    
	    }
	    if (j==3){
	        Rows=12;  
	        Cols=0;    
	    }
	    if (j==4){
	        Rows=12; 
	        Cols=7; 	    
	    }
	    if (j==5){
	        Rows=24;  
	        Cols=0; 		    
	    }
	    if (j==0){
	   	    Rows=24;
	   	    Cols=7;
	    } 
	   // alert(" "+j+"^"+Rows+"^"+Cols+"^"+tempcol)
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //����
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //�Ա�
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //����
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //�绰
		  xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; //����
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //��Ż�����
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9]; //��λ����
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //��������
	    
	    
  		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"��"+HospitalName+"���ƾ��";

	    xlsheet.cells(Rows+2,Cols+1)="����:";
	    xlsheet.cells(Rows+2,Cols+3)="�Ա�:";
	    xlsheet.cells(Rows+2,Cols+5)="����:";
	   // xlsheet.cells(Rows+3,Cols+1)="��ϵ�绰:";
		xlsheet.cells(Rows+3,Cols+1)="����:";
	    xlsheet.cells(Rows+4,Cols+1)="���(�����):";
	    xlsheet.cells(Rows+6,Cols+1)="��λ���ƣ�";
	    xlsheet.cells(Rows+7,Cols+1)="��������:";
	    xlsheet.cells(Rows+8,Cols+1)="��ע:��Ѫʱ��:����8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    	xlsheet.cells(Rows+10,Cols+1)="���绰: ";    
		    xlsheet.cells(Rows+8,Cols+1)="��ע:�Ǽ�ʱ��:����7:45---10:00";
		}
		else
		{
	    if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰: ";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰:";
	    	}
		}
	    if(j==0){
		    //alert("ccc");
		    xlsheet.printout;
            for(m=1;m<40;m++){
	            for(n=1;n<20;n++){
		            xlsheet.cells(m,n)="";
		            }
	            }
		    }
	}
	/*
xlsheet.SaveAs("d:\\�������ƾ��.xls");
xlApp.Visible = true;
xlApp.UserControl = true;	
idTmr   =   window.setInterval("Cleanup();",1); 
*/
//alert(j+"aa");
 	if(j!=0){
	 
	xlsheet.printout;
	} 	
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
	
	
	
	
}
function ContinueRegNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		ConPrintTPerson_click();
	    return false;
	}
}



//����ƾ��
function ConPrintTPerson_click()
{
	var obj,ConRegNo,iRegNo
	obj=document.getElementById("ContinueRegNo");
	if (obj) {
		ConRegNo=obj.value;
		if(ConRegNo==""){
			alert("����������������")
			return false;
		}
		var flag=tkMakeServerCall("web.DHCPE.PrintGroupPerson","IsHPNo",ConRegNo);
		if(flag=="1"){
			alert("��������Ų���ȷ");
			return false;
		}

		//iRegNo=RegNoMask(ConRegNo);
		PrintTeamPerson_click(iRegNo);
		}
	else {alert("��������������!")}
}
function BCopyTeam_click()
{
	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var encmeth=""
	var obj=document.getElementById("CopyTeamDataBox");
	if (obj) encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,iRowId);
	if (flag=="Notice"){
		alert("�����,���˼�����ȡ�����!");
		return false;
	}
    if (flag!="") {
	   	alert(t['ErrSave']+":"+flag);
	   	return false;
    }
	parent.location.reload();
}
  
function BTeamPreOver_click()
{
	//register("1");
	//return
	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var encmeth=""
	var obj=document.getElementById("TeamPreOver");
	if (obj) encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,iRowId);
	if (flag=="NoItem")
	{
		alert(t[flag]);
		return false;
	}
	if (flag!=0){
		alert(t["PreOver Err"]);
		return false;
	}
	parent.location.reload();
}
function StatusContralEnabled()
{
	var GStatus=document.getElementById("GStatus");
	if (GStatus) GStatus=GStatus.value;
	if (GStatus!="PREREG")
	{
		//�½���Ŀ
		//obj=document.getElementById("BNewItem");
		//if (obj){obj.disabled=true;}
		//ɾ������
		//obj=document.getElementById("Delete");
		//if (obj){ obj.disabled=true; }	
		//ɾ������
		//obj=document.getElementById("BNew");
		//if (obj){ obj.disabled=true; }
		//���ٷ���
		var obj=document.getElementById("RapidNew");
		if (obj){ 
			  obj.disabled=true;
		     obj.style.color = "gray";
			}
	}
}
function iniForm() {
	var obj;
	obj=document.getElementById("OperType");
	if (obj && "Q"==obj.value) {
		//�½�����
		obj=document.getElementById("BNew");
		if (obj) { obj.style.display = "none"; }
		
		//ɾ������
		obj=document.getElementById("Delete");
		if (obj) { obj.style.display = "none"; }
		
		//�½���Ŀ
		obj=document.getElementById("BNewItem");
		if (obj) { obj.style.display = "none"; }
		
		//ԤԼ���
		obj=document.getElementById("BTeamPreOver");
		if (obj) { obj.style.display = "none"; }
		
		//���ٷ���
		obj=document.getElementById("RapidNew");
		if (obj) { obj.style.display = "none"; }
		
		//���Ʒ���
		obj=document.getElementById("BCopyTeam");
		if (obj) { obj.style.display = "none"; }
		
	}else{

		//�½�����
		obj=document.getElementById("BNew");
		//if (obj) { obj.style.display = "inline"; }
		
		//ɾ������
		obj=document.getElementById("Delete");
		//if (obj) { obj.style.display = "inline"; }
		
		//�½���Ŀ
		obj=document.getElementById("BNewItem");
		//if (obj) { obj.style.display = "inline"; }
		//ԤԼ���
		obj=document.getElementById("BTeamPreOver");
		//if (obj) { obj.style.display = "inline"; }
		//���ٷ���
		obj=document.getElementById("RapidNew");
		//if (obj) { obj.style.display = "inline"; }
	}
	

	// ��ʾ��ǰҳ�������
	obj=document.getElementById("ParRefName");
	if (obj) { 
		var iParRefName=obj.value; 
		obj=document.getElementById("cGName");
		if (obj) { obj.innerText=iParRefName; }
	}else{
		obj=document.getElementById("cGName");
		if (obj) { obj.innerText=""; }	
	}

	ShowCurRecord(0);
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// ///////////////////////////////////////////////////////////////////////////////
// ˢ��ҳ��
function GetLocationHref() {
	var obj;
	var iParRef="", iParRefName="", iOperType="", iGBookDate="", iGBookTime="";
	

	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
		
	obj=document.getElementById("ParRefName");
	if (obj) { iParRefName=obj.value; }
		
	obj=document.getElementById("OperType");
	if (obj) { iOperType=obj.value; }

	obj=document.getElementById("GBookDate");
	if (obj) { iGBookDate=obj.value; }
	
	obj=document.getElementById("GBookDate");
	if (obj) { iGBookDate=obj.value; }

	obj=document.getElementById("GBookTime");
	if (obj) { iGBookTime=obj.value; }
		
		
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGTeam.List"
	var lnk="dhcpepregadm.team.csp?"
			+"ParRef="+iParRef
			+"&ParRefName="+iParRefName
			+"&OperType="+iOperType
			+"&GBookDate="+iGBookDate
			+"&GBookTime="+iGBookTime
			;
	return lnk;
}

// �½����� �½�����  ���غ���
function NewWondowReturn(value) {
	var Data=value.split("^");

	if ("1"==Data[0]) {
		//ˢ�´���
		var lnk=GetLocationHref();
		
		parent.parent.ReloadIFRAMEWindow(lnk);
	}
		
}
//alert(parent.GBookDate.value);
// ��ť ������Ŀ ����ҽ����Ŀ�༭ҳ��
function BNewItem_click() {
	
	//var eSrc=window.event.srcElement;
	var eSrc=document.getElementById("BNewItem");
	if (eSrc.disabled) { return false;}

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var PreOrAdd="PRE"
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=TEAM"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd

	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return websys_cancel();
}
// ��ť ɾ���������
function Delete_click() {
     
	var eSrc=document.getElementById("Delete");
	if (eSrc.disabled) { return false;}
	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }

	if (iRowId=="")	{
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if (flag=='0') {}
			else{
				var Errs=flag.split("^");
				
				//ɾ��������������Աʱ��������
				if ("IADM Err"==Errs[0]) {
					alert(t['IADM Err']+t['05']+Errs[1])
				}
				
				//ɾ��������ʱ��������
				if ("GTeam Err"==Errs[0]) {
					alert(t['GTeam Err']+t['05']+Errs[1])
				}
				
				if ("2"==Errs[0]) {
					alert("������������Ա")
				}
				
				return false;				
				//alert("Delete error.ErrNo="+flag)
				//alert(t['05']+flag)
			}

			var lnk=GetLocationHref();//location.href;

			parent.parent.ReloadIFRAMEWindow(lnk);
		}
	}
}
// ///////////////////////////////////////////////////////////////////////////////

function ShowCurRecord(selectrow) {

	//var selectrow=CurRecord;
	var SelRowObj,obj;
	if (selectrow==0)
	{
		obj=document.getElementById("BNewItem");
		if (obj){ 
				 websys_disable(obj)
		        }
		obj=document.getElementById("Delete");
		if (obj){ 
				  websys_disable(obj)
		}
		//ԤԼ���
		obj=document.getElementById("BTeamPreOver");
		if (obj){ 
				 websys_disable(obj)
		 }
		return	;
	}
	SelRowObj=document.getElementById('PGT_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	else{ obj.value=""; }

	if (""!=obj.value) {
		//��ť �½���Ŀ
		obj=document.getElementById("BNewItem");
		if (obj){ 
		 		websys_enable(obj,BNewItem_click)
		 		}	
		//���ٷ���
		var obj=document.getElementById("RapidNew");
		if (obj){ 
		
				  obj.disabled=false; 
		          obj.style.color = "blue";
				}	
		obj=document.getElementById("Delete");
		if (obj){ 
		          websys_enable(obj,Delete_click);
		  		}
		//ԤԼ���
		obj=document.getElementById("BTeamPreOver");
		if (obj){ 
		        websys_enable(obj,BTeamPreOver_click);
		
		 		}
		obj=document.getElementById("BCopyTeam");  
		if (obj){
			websys_enable(obj,BCopyTeam_click); 
		
		 		}           
		
	}
	StatusContralEnabled();
	
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	//if (eSrc.id.split("PGT_Desc").length>1) return false;
	if ((eSrc.id.split("PGT_Desc").length>1)||(eSrc.id.split("PGT_Item").length>1)||(eSrc.id.split("THadChecked").length>1)||(eSrc.id.split("TNoCheckDetail").length>1)) return false;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (CurrentSel==selectrow)
	{
		CurrentSel=0
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);
	SetFramLink(CurrentSel);
}
function SetFramLink(Row)
{
	var obj,iGTeam,iParRef,iParRefName,iOperType,iGTeanName
	iGTeam=""
	iGTeanName=""
	if (Row!=0)
	{
		obj=document.getElementById("PGT_RowIdz"+Row);
		if (obj) {
			iGTeam=obj.value; 
			if (""==iGTeam) { return false; }
		}
		obj=document.getElementById("PGT_Descz"+Row);
		if (obj) {
			iGTeanName=obj.innerText; 
			if (""==iGTeanName) { return false; }
		}
	}
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	obj=document.getElementById("ParRefName");
	if (obj) { iParRefName=obj.value; }
	var iOperType="";
	obj=document.getElementById("OperType");
	if (obj){ iOperType=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Team"
			+"&GTeam="+iGTeam
			+"&ParRef="+iParRef
			+"&GTeamName="+iGTeanName
			+"&ParRefName="+iParRefName
			+"&OperType="+iOperType
			;
	//var myFrame=parent.frames['DHCPEPreIADM.Team'];
	var myFrame=parent.document.getElementById('DHCPEPreIADM.Team');
	//myFrame.location.href=lnk;
	myFrame.src=lnk;

}
function DHCPEPreIADMTeam_Load ()
{
	var myFrame=parent.document.getElementById('DHCPEPreIADM.Team');
	var lnk=parent.document.getElementById('DHCPEPreIADM.Team').src
	myFrame.src=lnk;
}

function PatItemPrint() {
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"T");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		var Instring=ID+"^"+DietFlag+"^CRM";
		var Ins=document.getElementById('GetOEOrdItemBox');
		if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
		var value=cspRunServerMethod(encmeth,'','',Instring);
		Print(value);
	}
	
}
function PrintRisRequest() {
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"T");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintRisRequestApp(ID,"","PreIADM");
	}
	
}
function PrintReportRJ()
{
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	
	
	var value=cspRunServerMethod(encmeth,CRMId,"T");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop];
		PrintReportRJApp(ID,"PreIADM");
	}
	
}
function CancelPE()
{
	if (!confirm(t["06"])) return;
	CancelPECommon('PGT_RowIdz',"T",CurrentSel,0)
}
function UnCancelPE()
{
	if (!confirm(t["07"])) return;
	CancelPECommon('PGT_RowIdz',"T",CurrentSel,1)
}
function CancelPECommon(ElementName,Type,CurRow,DoType)
{
	var obj=document.getElementById(ElementName+CurRow);
	if (obj)
	{
		var Id=obj.value;
	}
	else
	{
		return false;
	}
	
	var obj=document.getElementById("CancelPEClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return false;
	}
	var Ret=cspRunServerMethod(encmeth,Id,Type,DoType);
	Ret=Ret.split("^");
	alert(Ret[1]);
}
 /*
 /
	
	//�������
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//��������
	obj=document.getElementById("ParRefName");
	if (obj) { iParRefName=obj.value; }
	
	//Ŀ�����
	var tForm="";
	obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	var iOperType="";
	obj=document.getElementById("OperType");
	if (obj){ iOperType=obj.value; }
	
	
	
	location.href=lnk;
}*/

function ExportTeamItem_click()
{   
   var obj;
   obj=document.getElementById("prnpath");
   if (obj && ""!=obj.value) 
   {
	    var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPETeamItem.xls';
		}else{
			alert("��Чģ��·��");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  //�̶�


		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�

		xlsheet = xlBook.WorkSheets("Sheet1");       //Excel�±������

		
    var iRowId="";
	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	if (""==iRowId) 
	{alert(t["NoSelTeam"]);
	 return false;}
	var encmeth=""
	var obj=document.getElementById("GetTItemData");
	if (obj) encmeth=obj.value;
	var ReturnStr=cspRunServerMethod(encmeth,iRowId);
	var Value=ReturnStr.split("$$")

	var TItemStr=Value[0]
	var GName=Value[1]
	var TeamName=Value[2]
	if(TeamItem=="")
	{alert(t["NoHasItem"]);
	   return false;}
	var TeamItem=TItemStr.split("^")
    var i=TeamItem.length;
    
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{

		xlsheet.cells(2+iLLoop,1).Value=TeamItem[iLLoop]; 
		xlsheet.cells(1,1).Value=GName+"("+TeamName+")"+"ԤԼ��Ŀ�嵥"; 
		xlsheet.Range(xlsheet.Cells(2+iLLoop,1),xlsheet.Cells(2+iLLoop,7)).mergecells=true; //�ϲ���Ԫ��
	}

   xlsheet.printout;
   
   //xlApp.UserControl = true;
   xlsheet=null;
   xlBook.Close (savechanges=false);
   xlApp.quit();              //�˳�EXCEL����
   xlApp=null;
   //xlApp.Visible = true;
   
   
	
}
var DoType="";
function BArrived_click()
{
	DoType=3;
	register();
}
function BRegister_click()
{   
	DoType=2;
	register();
	
}
var OKNumTotal=0,ErrNumTotal=0;
var LastTeamRowID="";
function register()
{
	var OneNum=19;  //ÿ�β�������OneNum+1
	var obj=document.getElementById("RowId");
	if (obj) { 
		iRowId=obj.value; 
		if((LastTeamRowID!="")&&(LastTeamRowID!=iRowId)) {var OKNumTotal=0,ErrNumTotal=0;}
		var LastTeamRowID=iRowId;	
	}

	if (""==iRowId) 
	{alert(t["NoSelTeam"]);
	 return false;}
	 var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateTeamInfo",iRowId,DoType,OneNum);
	 var Arr=ret.split("^")
	 var Num=Arr[1]
	 if (Num>OneNum){
		 var OKNum=Arr[1];
		 var ErrNum=Arr[2];
		 OKNumTotal=OKNumTotal+(+OKNum);
		 ErrNumTotal=ErrNumTotal+(+ErrNum);
		 var obj=document.getElementById("cRegisterInfo");
		 if (obj) obj.innerText="�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��";
		 setTimeout("register()",500);
		 //register(Type);
	 }else{
		 var OKNum=Arr[1];
		 var ErrNum=Arr[2];
		 OKNumTotal=OKNumTotal+(+OKNum);
		 ErrNumTotal=ErrNumTotal+(+ErrNum);
		 var obj=document.getElementById("cRegisterInfo");
		 if (obj) obj.innerText="�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��";
	 	 //OKNumTotal=0;
	 	 //ErrNumTotal=0;
	 	 //alert("�������"+ret);
		 alert("�������!"+"�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��");
	 }
	  try{
	 	    window.DHCPEPreIADMTeam_Load();
	 	    }catch(e){}

}
/*
function BArrived_click()
{
	register("3");
}
function BRegister_click()
{   
	register("2");
	
}
function register(Type)
{   
	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
    
	if (""==iRowId) 
	{alert(t["NoSelTeam"]);
	 return false;}
	 var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateTeamInfo",iRowId,Type);
	 var Arr=ret.split("^")
	 var Num=Arr[1]
	 if (Num>20){
		 register(Type);
	 }else{
	 	//alert("�������"+ret);
	 	alert("�������: �ɹ�"+Arr[1]+"��,δ�ɹ�"+Arr[2]+"��");
	 }
}*/

function UpdatePreAudit()
{
	alert("���������������ԤԼ��ѯ����鿴");
	return false;
}

document.body.onload = BodyLoadHandler;