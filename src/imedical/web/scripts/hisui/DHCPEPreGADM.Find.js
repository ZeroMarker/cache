
//����	DHCPEPreGADM.Find.js
//����	����ԤԼ��ѯ
//���	DHCPEPreGADM.Find	
//����	2018.09.10
//������  xy

var TFORM="tDHCPEPreGADM_Find";	//�����¼��Ԫ��

var CurrentSel=0;	//��ǰ�����¼

var CurrentConponent="";	//����Ŀ�������

var CurrentAdmType="";	//��ǰ��������

function BodyLoadHandler() {

	var obj;
	
	//��ѯ
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }

	//����
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	//��ӡ������Ա����
	obj=document.getElementById("PrintGroupPerson");
	if (obj){ obj.onclick=PrintGroupPerson_Click; }
	
	//����ɷ�
	obj=document.getElementById("BAllowToCharge");
	if (obj){ obj.onclick=BAllowToCharge_Click; }
	
	var obj=document.getElementById("Contract");
	if (obj) obj.onchange=Contract_change;
	
	//�����趨
	obj=document.getElementById("HomeSet");
	if (obj){obj.onclick=HomeSet_Click; }
	
	//��ӡ�������ƾ��
	obj=document.getElementById("PrintTeamPerson");
	if (obj){ obj.onclick=PrintTeamPerson_Click; }
	
	//��ӡ������Ϣ����
	obj=document.getElementById("BPrintBaseInfo");
	if (obj){ obj.onclick=BPrintBaseInfo_Click; }
	
	//���Ʒ���
	obj=document.getElementById("BCopyTeam");
	if (obj){ obj.onclick=BCopyTeam_click; }
	
	//�޸�ԤԼ��Ϣ
	obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_click;}
	
	//�м����
	obj=document.getElementById("BModifyItem");
	if (obj){obj.onclick=ModifyItem_click;}
	
	//ȡ��ԤԼ
	obj=document.getElementById("BCancelPre");
	if (obj){obj.onclick=BCancelPre_click;}
	
	//ȡ�����
	obj=document.getElementById("CancelPE");
	if (obj){ obj.onclick=CancelPE; }

	//����ȡ�����
	obj=document.getElementById("UnCancelPE");
	if (obj){ obj.onclick=UnCancelPE; }
	obj=document.getElementById("PEFinish");
	if (obj){obj.onclick=PEFinish;}
	
	//����
	obj=document.getElementById("BFee");
	if (obj){ obj.onclick=UpdatePreAudit; }

	//������������嵥
	obj=document.getElementById("BPrintGroupItem");
	if (obj){ obj.onclick=BPrintGroupItem_click; }
	initlookupWidth();
	//initButtonWidth();
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	iniForm();	

}
function PEFinish()
{
	if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ�������������壡","info");
		return false;
	}
	 
	var objtbl = $("#tDHCPEPreGADM_Find").datagrid('getRows'); 
	var iComplete=objtbl[selectrow].PGADM_CompleteStatus;
	if(iComplete=="δ���"){var status="������";}
	else{var status="ȡ��������";}
	
		$.messager.confirm("ȷ��", "ȷ��Ҫ"+status+"��", function(r){
		if (r){
				FinishPECommon("G",0);
				BFind_click();
		}
	});
		
	
	
}

function FinishPECommon(Type,DoType)
{
	
	
	var Id="";
	
    var objtbl=$("#tDHCPEPreGADM_Find").datagrid('getRows');
	var Id=objtbl[selectrow].PGADM_RowId;
	
	if(Id==""){
		$.messager.alert("��ʾ","δѡ�������������壡","info");
		    return false;
		}
		
	var Status=objtbl[selectrow].PGADM_Status;
	if(Status=="CANCELPE"){
			$.messager.alert("��ʾ","��������ȡ����죡","info");
		    return false;
	} 

	var Ret=tkMakeServerCall("web.DHCPE.PreGADM","UpdatePEComplete",Id)
	
	$.messager.alert("��ʾ","�����ɹ���","info");
	selectrow="-1"
	
	
}
function initlookupWidth()
{
	$("#Name").lookup({
		panelHeight:380,
		columns:[[ 
                {field:'GBI_Desc',title:'��������',width:200}, 
                {field:'GBI_Code',title:'����',width:100},
                {field:'GBI_RowId',title:'ID',width:10},
                
            ]]
      
	});

}
function BPrintGroupItemNew_click(){
	
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		  var obj=document.getElementById("RowId");
	    if(obj)  {var PIADM=obj.value;} 
	  	if (PIADM=="")  {
		  	$.messager.alert("��ʾ","����ѡ������","info");
	  		return false;
	  	}
	  	
	  	var StrNew = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         
         var obj=document.getElementById("GetGroupPersonBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var locType="";
	    var ExecFlag="";
	    var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }
	    var ReturnStr=cspRunServerMethod(encmeth,PIADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		var ret=""
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		    if(ret==""){ret="xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';" }
		    else{ret=ret+"xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';"}
		  
		   }
		   
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		    var obj=document.getElementById("GetGroupItemBox");
	        if (obj) {var encmeth=obj.value} else{var encmeth=""}
			
	        var FeeStr=cspRunServerMethod(encmeth,IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   var rownew=row+1;
		   if(ret==""){ret="xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';"}
		  
		   }
		 
    	
	    }
	    
	    
	    var n=row+2;

	    var obj=document.getElementById("GetItemFeeBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var TotalFeeString=cspRunServerMethod(encmeth);
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   
    	    if(ret==""){ret="xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';"}
		  }
		var GroupDesc=""
		var obj=document.getElementById('RowId_Name');
		if (obj) GroupDesc=obj.value;
		
	    var StrNew=StrNew+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+n+","+Cols+")).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(StrNew)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(StrNew);   //ͨ���м�����д�ӡ���� 
		return ;
	   

}
//������������嵥
function BPrintGroupItem_click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
		var obj;
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		  var obj=document.getElementById("RowId");
	    if(obj)  {var PIADM=obj.value;} 
	  	if (PIADM=="")  {
		  	$.messager.alert("��ʾ","����ѡ������","info");
	  		return false;
	  	}
		xlApp = new ActiveXObject("Excel.Application");  //�̶�
		xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
	  	var obj=document.getElementById("GetGroupPersonBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var locType="";
	    var ExecFlag="";
	    var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }
	    var ReturnStr=cspRunServerMethod(encmeth,PIADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		 
		   xlsheet.cells(1,+Col).value=DataStr
		   }
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		    var obj=document.getElementById("GetGroupItemBox");
	        if (obj) {var encmeth=obj.value} else{var encmeth=""}
			
	        var FeeStr=cspRunServerMethod(encmeth,IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   xlsheet.cells(row+1,+FeeCol).value=FeeData
		  
		   }
		 
    	
	    }
	   
	    var n=row+2

	    var obj=document.getElementById("GetItemFeeBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var TotalFeeString=cspRunServerMethod(encmeth);
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   xlsheet.cells(n,+TFeeCol).value=TFeeData}
    	   
	    
		var GroupDesc=""
		var obj=document.getElementById('RowId_Name');
		if (obj) GroupDesc=obj.value;
	
	   
	 	xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(n,Cols)).Borders.LineStyle=1;	
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
	}
	    
    
	catch(e)
	{
		$.messager.alert("��ʾ","�������󣺴���Ϊ"+e.message,"info");
	  	return false;
	}
}else{
	BPrintGroupItemNew_click();
}
}

//���ӿɱ༭�б�
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#tDHCPEPreGADM_Find').datagrid({
	//�����н����༭
	onSelect: function (rowIndex, rowData) {	
		if (editFlag!="undefined") 
		{
	    	jQuery('#tDHCPEPreGADM_Find').datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    	var Mark=rowData.TMark;
			var PGADM=rowData.PGADM_RowId;

			if(PGADM!="") {
				var rtn=tkMakeServerCall("web.DHCPE.PreGADM","UpDateGMark",PGADM,Mark)
			}
	    }
    },
})

//˫���п�ʼ�༭
function DblClickRowHandler(index,rowdata)	{
		
	var Value1=$('#tDHCPEPreGADM_Find').datagrid('getColumnOption','TMark');
	//alert(Value1)
	Value1.editor={type:'validatebox'};
	if (editFlag!="undefined")
	{
    	jQuery('#tDHCPEPreGADM_Find').datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#tDHCPEPreGADM_Find').datagrid('beginEdit', index);
    editFlag =index;
}

function BCopyTeam_click()
{
	var ID=$("#RowId").val();
	if ((ID=="")||(ID==undefined)){
		$.messager.alert("��ʾ","����ѡ������","info");

		return;	
	}
	/*
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var repUrl="dhcpeteamcopy.csp?ToGID="+ID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(repUrl,"_blank",nwin)	
	*/
	var repUrl="dhcpeteamcopy.csp?ToGID="+ID;
	websys_lu(repUrl,false,'width=1020,height=545,hisui=true,title=���Ʒ���') 
}

function BAllowToCharge_Click()
{
	var obj,encmeth="",ID;
	 var objtbl = $("#tDHCPEPreGADM_Find").datagrid('getRows');
	 if (selectrow=="-1") {
		 $.messager.alert("��ʾ","����ѡ������","info");
	 	 return false;
	 }
	 var ID=objtbl[selectrow].PGADM_RowId;		
	
	var encmethobj=document.getElementById("AllowToChargeClass");
	if (encmethobj) var encmeth=encmethobj.value;
	var Type="Group";
	var ReturnStr=cspRunServerMethod(encmeth,ID+"^"+"1",Type,"Pre");
	if (ReturnStr==""){
		$.messager.alert("��ʾ","�޸����","info");
		
	}else{
		$.messager.alert("��ʾ","��û�еǼ�,������ɷ�","info");
	
	}
}

function BCancelPre_click()
{
	var obj,encmeth="",ID,Status;
	
	obj=document.getElementById("BCancelPre");
	if (obj && obj.disabled){ return false; }
	var Type=trim($("#BCancelPre").text());
	Status="PREREG"
	if (Type=="ȡ��ԤԼ") Status="CANCELPREREG"
	obj=document.getElementById("StatusBox");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	if (selectrow==-1){
		 $.messager.alert("��ʾ","����ѡ������","info");
		 return false;
	}
	 var objtbl = $("#tDHCPEPreGADM_Find").datagrid('getRows');
	 var ID=objtbl[selectrow].PGADM_RowId;
	  var PGADMStatus=objtbl[selectrow].PGADM_Status_Desc;
	
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.PreGADM.UpdateStatus"))
	var Flag=cspRunServerMethod(encmeth,ID,Status);
	if (Flag!="0")
	{
		$.messager.alert("��ʾ", "��������״̬ʧ��", 'error');
		return;
	}else{
		if (Type=="ȡ��ԤԼ") {$.messager.alert("��ʾ", "ȡ��ԤԼ�ɹ�", 'success');}
		else{$.messager.alert("��ʾ", "ԤԼ�ɹ�", 'success');}
		BFind_click();
		selectrow="-1"

	}

}

function iniForm(){
	var obj;

	obj=document.getElementById("Status_REGISTERED");
	if (obj) { setValueById("Status_REGISTERED",true); }

	// ��ѯ���� ԤԼ״̬
	obj=document.getElementById("Status");
	if (obj) {
		var iStatus=obj.value;
		if (""==iStatus) { SetStatus(iStatus); }
		else { SetStatus(iStatus); }
	}
	
	 	//ԤԼ�޸�
 	 	obj=document.getElementById("Update");
		if (obj) {
		 DisableBElement("Update",true);
		
		}
		
		//ȡ��ԤԼ
		obj=document.getElementById("BCancelPre");
		if (obj) {
			DisableBElement("BCancelPre",true);
		}
		
		//��Ŀ�޸�
		obj=document.getElementById("BModifyItem");
		if (obj) {
			DisableBElement("BModifyItem",true);
		}
	
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function GetURL(ConponentName,AdmType) {
	
	//�������
	var obj;
	obj=document.getElementById('RowId');
	if (obj) {
		var iRowId=obj.value; 
		if (""==iRowId) { return false; }
	}
	
	//��������
	obj=document.getElementById('RowId_Name');
	if (obj) {
		var iName=obj.value; 
		if (""==iName) { return false; }
	}
	var GBookDate="",GBookTime="";
	obj=document.getElementById('GBookDate');
	if (obj ) { GBookDate=obj.value; }
	
	obj=document.getElementById('GBookTime');
	if (obj ) { GBookTime=obj.value; }
	
	// 
	parent.SetGADM(iRowId+"^"+iName+"^"+GBookDate+"^"+GBookTime+"^"+"Q");
	return true;
	
	/*
	//������
	var lnk="dhcpepregadm.edit.csp"+"?IsQuery="+"Y"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"Q"; //�������� ��ѯ
			;

	parent.frames["DHCPEPreTeam"].location.href=lnk;
	*/
}

//˫�������¼
function PreGADM_click() {

	var eSrc=window.event.srcElement;
	
	var obj=document.getElementById(TFORM);
	if (obj){ var tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	/*
	if (selectrow==CurrentSel)
	{
	    CurrentSel=0;
	    return;
	}
	*/
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);
 	//GetURL(CurrentConponent,CurrentAdmType);
}

//���������¼ ѡ���¼
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	var iRowId="";
	var iComplete=""  
	 
	var objtbl = $("#tDHCPEPreGADM_Find").datagrid('getRows');    
	if (selectrow=="-1")
	{
		$("#Update").linkbutton('disable');		
		$("#BCancelPre").linkbutton('disable');		
		$("#BModifyItem").linkbutton('disable');			
	}
	 
	 var PGADMRowId=objtbl[selectrow].PGADM_RowId;
	  setValueById("RowId",PGADMRowId);
	  
	  var PGBIName=objtbl[selectrow].PGADM_PGBI_DR_Name;
	  setValueById("RowId_Name",PGBIName);
	  
	  var PGADMBookDate=objtbl[selectrow].PGADM_BookDate;
	  setValueById("GBookDate",PGADMBookDate);
	  
	 var PGADMBookTime=objtbl[selectrow].PGADM_BookTime;
	  setValueById("GBookTime",PGADMBookTime);
	  
	 var iComplete=objtbl[selectrow].PGADM_CompleteStatus;
	 var Status=objtbl[selectrow].PGADM_Status;
	 
	SetCElement("PEFinish","������");
	if (Status!="ARRIVED"){
		 $("#PEFinish").linkbutton('disable');		
	}else{
		$("#PEFinish").linkbutton('enable');
		if(iComplete=="�����"){
			SetCElement("PEFinish","ȡ�����");
		}
	}
	
	
		if (Status=="PREREG")
		{
			 $("#Update").linkbutton('enable');
	
			 $("#BModifyItem").linkbutton('enable');
			
			obj=document.getElementById("BCancelPre");
			if(obj){
				DisableBElement("BCancelPre",false);
				SetCElement("BCancelPre","ȡ��ԤԼ");
			
			}
			
			return;
		}
		if (Status=="CANCELPREREG")
		{
			 $("#Update").linkbutton('enable');
	
			 $("#BModifyItem").linkbutton('enable');
				
			obj=document.getElementById("BCancelPre");
			if(obj){
				DisableBElement("BCancelPre",false);
				SetCElement("BCancelPre","ԤԼ");
				$("#BCancelPre").css({"width":"118px"});
			//obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>ԤԼ";
			}
			return;
		}

		if (Status=="CANCELPE")
		{
			 $("#Update").linkbutton('disable');
			 $("#BModifyItem").linkbutton('disable');
			 $("#HomeSet").linkbutton('disable');
			 $("#BCopyTeam").linkbutton('disable');
			
			 return;
		}

		$("#HomeSet").linkbutton('enable');
		$("#BCopyTeam").linkbutton('enable');

		$("#Update").linkbutton('enable');
		if (iComplete=="�����"){                         
			$("#Update").linkbutton('disable');
		}  
		   
		 $("#BModifyItem").linkbutton('enable');                         
		if (iComplete=="�����"){                         
		 	$("#BModifyItem").linkbutton('disable');    
		} 
		                            
		$("#BCancelPre").linkbutton('disable');    

		
		return;
		
}

// �м����
function ModifyItem_click() {
	

	var obj;
	
	obj=document.getElementById("BModifyItem");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	var iName="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if(iRowId==""){
		$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}

	obj=document.getElementById('RowId_Name');
	if (obj){ iName=obj.value; }
	
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"T"
			;
	//var wwidth=1250;
	//var wheight=1150;
	//var xposition = (screen.width - wwidth) / 2;
	//var yposition = (screen.height - wheight) / 2;
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;		
	parent.location.href=lnk;


}

// ����ԤԼ�༭
function Update_click() {
	
	var obj;
	
	obj=document.getElementById("Update");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	var iName="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if(iRowId==""){
		$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}

	obj=document.getElementById('RowId_Name');
	if (obj){ iName=obj.value; }
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"E"
			;
	//var wwidth=1250;
	//var wheight=1150;
	//var xposition = (screen.width - wwidth) / 2;
	//var yposition = (screen.height - wheight) / 2;
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;		
	parent.location.href=lnk;

}
//��ѯ����
function BFind_click() {
	
	var obj;
	
	var iCode="";
	var iName="";
	var iBookDate="";
	var iBookTime="";
	var iStatus="";
	var iBeginDate="";   //Add
	var iEndDate="";     //Add
	var iRegDateFrom="";
	var iRegDateTo="";

	
    iCode=getValueById("Code");
	
	iName=getValueById("Name");
	 
	iBookDate=getValueById("BookDate");
	
	iBookTime=getValueById("BookTime");
	
	iBeginDate=getValueById("BeginDate");
	 
	iEndDate=getValueById("EndDate");
	
	iStatus=GetStatus();
	
	iCSta=getValueById("ChargeStatus");
   	if(iCSta==undefined){iCSta="";}


	var ShowPrintGroup=getValueById("ShowPrintGroup")
	if(ShowPrintGroup){iReportGroup="1";}
	else{iReportGroup="0";}	
	
	iRegDateFrom=getValueById("RegDateFrom");
	
	iRegDateTo=getValueById("RegDateTo");
	
	iPersonNum=getValueById("PersonNum");
	
	iContractID=getValueById("ContractID");
	 

	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Find"
			+"&Code="+iCode
			+"&Name="+iName
			+"&BookDate="+iBookDate
			+"&BookTime="+iBookTime
			+"&Status="+iStatus
			+"&ReportGroup="+iReportGroup
			+"&BeginDate="+iBeginDate     
			+"&EndDate="+iEndDate         
			+"&ChargeStatus="+iCSta  
			+"&RFind=1"
			+"&RegDateFrom="+iRegDateFrom  
			+"&RegDateTo="+iRegDateTo
			+"&PersonNum="+iPersonNum
			+"&ContractID="+iContractID
			;

	$("#tDHCPEPreGADM_Find").datagrid('load',{ComponentID:56642,Code:iCode,Name:iName,BookDate:iBookDate,BookTime:iBookTime,Status:iStatus,ReportGroup:iReportGroup,BeginDate:iBeginDate,EndDate:iEndDate,ChargeStatus:iCSta,RFind:"1",RegDateFrom:iRegDateFrom,RegDateTo:iRegDateTo,PersonNum:iPersonNum,ContractID:iContractID});	
    
	$("#RowId").val("");
	SelectRowHandler(-1);

	//location.href=lnk;
}

//����Ĭ��ʱ��
function Initdate()
{
	var today = getDefStDate(0-10);
	$("#BeginDate").datebox('setValue', today);
	//$("#EndDate").datebox('setValue', today);
}

function Clear_click() {
	var obj;
	
	//�������
	 setValueById("Code","") 
	
	//��������
	setValueById("Name","")
	
	//ԤԼ��ʼ����
	//setValueById("BeginDate","")
	Initdate()

	//ԤԼ��������
	setValueById("EndDate","")
	
	//�Ǽǿ�ʼ����
	setValueById("RegDateFrom","")
	
	//�Ǽǽ�ֹ����
	setValueById("RegDateTo","")
	
	//����
	setValueById("Depart","")
	
	//����
	setValueById("PersonNum","")
	
	//��ͬ
	setValueById("Contract","")
	setValueById("ContractID","")
   
   //ƾ������
	setValueById("VIPLevel","")
	
	//�շ�״̬
	setValueById("ChargeStatus","")
  
  	$(".hisui-checkbox").checkbox('setValue',false);
	
	  BFind_click()
   
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	
	if(index==selectrow)
	{
		
		ShowCurRecord(selectrow);
	
		
	}else
	{
		SelectedRow=-1;
		
	}


}
		

function SetStatus(value) {
	var obj;

	obj=document.getElementById("Status_PREREG");
	if (obj) {
		if (value.indexOf("^PREREG")>-1) { setValueById("Status_PREREG",true); }
		else { setValueById("Status_PREREG",false); }
	}
	
	obj=document.getElementById("Status_CHECKED");
	if (obj) {
		if (value.indexOf("^CHECKED")>-1) { setValueById("Status_CHECKED",true); }
		else { setValueById("Status_CHECKED",false); }
	}
	
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED")>-1) { setValueById("Status_REGISTERED",true);  }
		else { setValueById("Status_REGISTERED",false);  }
	}
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj) {
		if (value.indexOf("^CANCELPREREG")>-1) { setValueById("Status_CANCELPREREG",true);  }
		else { setValueById("Status_CANCELPREREG",false);  }
	}
	obj=document.getElementById("Status_CANCELPE");
	if (obj) {
		if (value.indexOf("^CANCELPE")>-1) { setValueById("Status_CANCELPE",true);  }
		else { setValueById("Status_CANCELPE",false); }
	}
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED")>-1) {setValueById("Status_ARRIVED",true);  }
		else { setValueById("Status_ARRIVED",false);  }
	}

}
function GetStatus() {
	var iStatus="";
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED";}
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPREREG"; }
	obj=document.getElementById("Status_CANCELPE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPE"; }
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }
	return iStatus;
}

function PrintGroupPersonNew_Click(){
	
	var obj;
	var HospID=session['LOGON.HOSPID']
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	}else{
		$.messager.alert("��ʾ","��Чģ��·��","info");
		return;
	}
	
	 var obj=document.getElementById("RowId");
    if(obj)  {var PIADM=obj.value;} 
    if ((""==PIADM)){
	    $.messager.alert("��ʾ","��ѡ������","info");
		return false;	}
    var Instring=PIADM;
    
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
 
    var obj=document.getElementById("RowId_Name");
    if(obj)  {var PIADMName=obj.value;} 
    var returnval=cspRunServerMethod(encmeth,Instring,"N");
   	
	var str=returnval; //[0]
	//ѭ����
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("��ʾ","��������Ա����Ϊ��","info");
	   	return;
	}

	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
    var ret="";
	var k=2; 
   	var tmp=0; 
  	// xlsheet.cells(2,1)="��������:"+PIADMName;
   	encmeth=document.getElementById("GetOneInfoClass").value;
   
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i],HospID);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//������rowid�������ϴ���rowid���Ҳ��ǵ�һ��ʱ���м�2
		if((itemrowid != tmp))
		{   
			var count=1;
			k=k+1;
			//xlsheet.Rows(k+1).insert();
			k=k+1;
			//xlsheet.Rows(k+1).insert(); 
			var m=k-1;
			
			if(ret==""){
			 
		     ret="xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //�ϲ���Ԫ��
	         "xlSheet.Cells("+k+",1).Value='���';"+
	         "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"+ 
	         "xlSheet.Cells("+k+",3).Value='����';"+ 
	         "xlSheet.Cells("+k+",4).Value='�Ա�';"+ 
	         "xlSheet.Cells("+k+",5).Value='����';"+
	         "xlSheet.Cells("+k+",6).Value='����';"+ 
	         "xlSheet.Cells("+k+",7).Value='���֤��';"+ 
	         "xlSheet.Cells("+k+",8).Value='�շ�״̬';"+  
	         "xlSheet.Cells("+k+",9).Value='�Էѽ��';"+ 
	         "xlSheet.Cells("+k+",10).Value='���ѽ��';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //���õǼǺ�Ϊ�ı���
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}else{
				ret=ret+
				"xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //�ϲ���Ԫ��
	         "xlSheet.Cells("+k+",1).Value='���';"+
	         "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"+ 
	         "xlSheet.Cells("+k+",3).Value='����';"+ 
	         "xlSheet.Cells("+k+",4).Value='�Ա�';"+ 
	         "xlSheet.Cells("+k+",5).Value='����';"+
	         "xlSheet.Cells("+k+",6).Value='����';"+ 
	         "xlSheet.Cells("+k+",7).Value='���֤��';"+ 
	         "xlSheet.Cells("+k+",8).Value='�շ�״̬';"+  
	         "xlSheet.Cells("+k+",9).Value='�Էѽ��';"+ 
	         "xlSheet.Cells("+k+",10).Value='���ѽ��';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //���õǼǺ�Ϊ�ı���
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}

		}
		//tempcol[0]=count;
		count=count+1;
		//xlsheet.Rows(k+1).insert();         //����һ��
		//alert(tempcol)
		var n=k+1
		 if(ret==""){ret="xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }else{
			 ret=ret+"xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }
				 
	   tmp=itemrowid;   //��������rowid����һ����ʱ����?�����´�ȡ�õ���rowid�Ƚ�
	   k=k+1;
	  
	}
	
	
	///ɾ�����Ŀ���
///xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
//xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
//xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
//xlsheet.Rows(k+1).Delete;
	  var Str=Str+ret+
	  
	  		"xlSheet.Cells(2,1).Value='��������:"+PIADMName+"(��"+id+"��)';"+
	  		 "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",10)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ;
	
}
   //ZHOULI 2008-04-21
function PrintGroupPerson_Click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
	var obj;
	
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	}else{
		$.messager.alert("��ʾ","��Чģ��·��","info");
		return;
	}
	
	 var obj=document.getElementById("RowId");
    if(obj)  {var PIADM=obj.value;} 
    if ((""==PIADM)){
	    $.messager.alert("��ʾ","��ѡ������","info");
		return false;	}
    var Instring=PIADM;
    
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
 
    var obj=document.getElementById("RowId_Name");
    if(obj)  {var PIADMName=obj.value;} 
    var returnval=cspRunServerMethod(encmeth,Instring,"N");
   	
	var str=returnval; //[0]
	//var num=info[1]      //��ĸ���
	//ѭ����
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("��ʾ","��������Ա����Ϊ��","info");
	   	return;
	}


	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
	

   
   	k=2; 
   	var tmp=0; 
  	// xlsheet.cells(2,1)="��������:"+PIADMName;
   	encmeth=document.getElementById("GetOneInfoClass").value;
   
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//������rowid�������ϴ���rowid���Ҳ��ǵ�һ��ʱ���м�2
		if((itemrowid != tmp))
		{   var count=1;
			k=k+1;
			xlsheet.Rows(k+1).insert();
			k=k+1;
			xlsheet.Rows(k+1).insert(); 
			xlsheet.cells(k-1,1)=tempcol[8]; 
			var Range=xlsheet.Cells(k-1,1);
	        xlsheet.Range(xlsheet.Cells(k-1,1),xlsheet.Cells(k-1,10)).mergecells=true; //�ϲ���Ԫ��
			xlsheet.cells(k,1)="���"
			xlsheet.cells(k,2)="�ǼǺ�" 
			xlsheet.cells(k,3)="����" 
			xlsheet.cells(k,4)="�Ա�"
			xlsheet.cells(k,5)="����"
			//xlsheet.cells(k,6)="����״��"
			xlsheet.cells(k,6)="����"
			xlsheet.cells(k,7)="���֤��"
			xlsheet.cells(k,8)="�շ�״̬"
			xlsheet.cells(k,9)="�Էѽ��"
			xlsheet.cells(k,10)="���ѽ��"
			//xlsheet.cells(k,8)="�Żݽ��"
			//xlsheet.cells(k,9)="ʵ�ʽ��"
			//var Range=xlsheet.Cells(k,1)
			//xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,5)).HorizontalAlignment =-4108;//����
			//xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment =-4108;//����
			
			
			xlsheet.Columns(2).NumberFormatLocal="@";  //���õǼǺ�Ϊ�ı��� 
			xlsheet.Columns(5).NumberFormatLocal="@"; 
			xlsheet.Columns(7).NumberFormatLocal="@"; 
			xlsheet.Columns(9).NumberFormatLocal="@"; 
			xlsheet.Columns(10).NumberFormatLocal="@";   

		}
		//tempcol[0]=count;
		count=count+1;
		xlsheet.Rows(k+1).insert();         //����һ��
		//alert(tempcol)
		
			xlsheet.cells(k+1,1).Value=tempcol[0];
			xlsheet.cells(k+1,2).Value=tempcol[1];
			xlsheet.cells(k+1,3).Value=tempcol[2];
			xlsheet.cells(k+1,4).Value=tempcol[3];
			xlsheet.cells(k+1,5).Value=tempcol[4];
			xlsheet.cells(k+1,6).Value=tempcol[6];  
			xlsheet.cells(k+1,9).Value=tempcol[17];  
			xlsheet.cells(k+1,10).Value=tempcol[16];
			xlsheet.cells(k+1,7).Value=tempcol[18];  
			xlsheet.cells(k+1,8).Value=tempcol[19]; 
				 

				 
	   tmp=itemrowid;   //��������rowid����һ����ʱ����?�����´�ȡ�õ���rowid�Ƚ�
	   k=k+1;
	   xlsheet.cells(2,1)="��������:"+PIADMName+"(��"+id+"��)";
	}
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
/*
xlsheet.SaveAs("d:\\������Ա����.xls");
xlApp.Visible = true;
xlApp.UserControl = true;	
idTmr   =   window.setInterval("Cleanup();",1); 
  */
  xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
  
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
}else{
	PrintGroupPersonNew_Click()
}
}

function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
//��ӡ������Ϣ����
function BPrintBaseInfo_Click()
{
	var obj=document.getElementById("RowId");
   	if(obj)  {var PIADM=obj.value;} 
    //alert(PIADM)
   	if ((""==PIADM)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
   	var Instring=PIADM;
   	var obj=document.getElementById("DateBox");
   	if (obj) {var encmeth=obj.value} else{var encmeth=""}
   	var NewHPNo="",VIPLevel="";
	var obj=document.getElementById("Code");
    if(obj)  {NewHPNo=obj.value;}
   
     var VIPLevel=$("#VIPLevel").combobox("getValue")

   	var returnval=cspRunServerMethod(encmeth,Instring,"Y",NewHPNo,VIPLevel);
   	var str=returnval; 
	var temprow=str.split("^");
	if(temprow=="")
	{
		$.messager.alert("��ʾ","��������Ա����Ϊ��","info");
   		return;
	} 
	encmeth=document.getElementById("GetOneInfoClass").value;
	for(i=0;i<=(temprow.length-1);i++)
	{  
    	var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
    	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",temprow[i]); 
		var FactAmount=Amount.split('^')[1]+'Ԫ';
   		//var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo;
		var Info=tempcol[1]+"^"+tempcol[2]+"  "+FactAmount+"^"+"^"+"^"+"^"+tempcol[3]+String.fromCharCode(1)+"^"+tempcol[4]+"^"+tempcol[1]+"^"+"";
		//alert(Info)
		PrintBarRis(Info);
	}

}
//��ӡ�������ƾ��
function PrintTeamPerson_Click (){
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
		//alert(Templatefilepath);
	}else{
		alert("��Чģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	    var obj=document.getElementById("RowId");
    if(obj)  {var PIADM=obj.value;} 
   
    if ((""==PIADM)){
	    $.messager.alert("��ʾ","��ѡ������","info");
		return false;	}
    var myDate = new Date();
    myDate.getFullYear();
   
    var PGADMID=PIADM;
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    
    var obj=document.getElementById("RowId_Name");
    if(obj)  {var PIADMName=obj.value;}
    
	var ConRegNo="",VIPLevel="";
	var obj=document.getElementById("Code");
    if(obj)  {ConRegNo=obj.value;}
    
   
     var VIPLevel=$("#VIPLevel").combobox("getValue")
    //alert(ConRegNo+"^"+VIPLevel+"&"+PGADMID)
	var returnval=cspRunServerMethod(encmeth,PGADMID,"Y",ConRegNo,VIPLevel);
    var str=returnval; 
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
		$.messager.alert("��ʾ","��������û�пɴ�ӡ��ƾ��","info");
		
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
	    xlsheet.cells(Rows+6,Cols+3)=PIADMName; //��λ����
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //��������
	    //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"�걱��Э��ҽԺ����������ƾ��";
		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"��"+HospitalName+"���ƾ��";

	    xlsheet.cells(Rows+2,Cols+1)="����:";
	    xlsheet.cells(Rows+2,Cols+3)="�Ա�:";
	    xlsheet.cells(Rows+2,Cols+5)="����:";
	    //xlsheet.cells(Rows+3,Cols+1)="��ϵ�绰:";
	    xlsheet.cells(Rows+3,Cols+1)="����:";
	    xlsheet.cells(Rows+4,Cols+1)="���(�����):";
	    xlsheet.cells(Rows+6,Cols+1)="��λ���ƣ�";
	    xlsheet.cells(Rows+7,Cols+1)="��������:";
	    xlsheet.cells(Rows+8,Cols+1)="��ע:��Ѫʱ��:����8:00---9:30";
	    xlsheet.cells(Rows+11,Cols+1)="ԤԼ��ַ:";
	    if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    	xlsheet.cells(Rows+10,Cols+1)="���绰:";    
		    xlsheet.cells(Rows+8,Cols+1)="��ע:�Ǽ�ʱ��:����7:45---10:00";
		}
		else
		{
			if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰:";
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


// ��ӡ���쵥
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
	var value=cspRunServerMethod(encmeth,CRMId,"G");
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
		//Print(value,iLLoop+1);
		Print(value,1);
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
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintRisRequestApp(ID,"","PreIADM")
	}
	
}
function PrintReportRJ()
{
	obj=document.getElementById("RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintReportRJApp(ID,"PreIADM");
	}
	
}

function CancelPE()
{
	if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ���ȡ����������","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫȡ�������", function(r){
		if (r){
				CancelPECommon("G",0);
				BFind_click();
		}
	});
}

function UnCancelPE()
{
	var PGADM="",Status="";
	var objtbl=$("#tDHCPEPreGADM_Find").datagrid('getRows');
	if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ�������ȡ����������","info");
		return false;
	}
	var PGADM=objtbl[selectrow].PGADM_RowId;
	if(PGADM==""){
		$.messager.alert("��ʾ","δѡ�������ȡ����������","info");
		return false;
	}
	var Status=objtbl[selectrow].PGADM_Status_Desc;
	if(Status!="ȡ�����"){
		$.messager.alert("��ʾ","����ȡ�����״̬,���ܳ���ȡ�����","info");
		return false;
	}

    $.messager.confirm("ȷ��", "ȷ��Ҫ����ȡ�������", function(r){
		if (r){
				CancelPECommon("G",1);
	 			BFind_click();
		}
	});
	
}

function CancelPECommon(Type,DoType)
{
	
	var Id="";
	
    var objtbl=$("#tDHCPEPreGADM_Find").datagrid('getRows');
	var Id=objtbl[selectrow].PGADM_RowId;
	
	if(Id==""){
		$.messager.alert("��ʾ","δѡ���ȡ����������","info");
		    return false;
		}
		
	var obj=document.getElementById("CancelPEClass");
	if (obj){var encmeth=obj.value;}
	else{ return false;}
	var Ret=cspRunServerMethod(encmeth,Id,Type,DoType);
	Ret=Ret.split("^");
	$.messager.alert("��ʾ",Ret[1],"info");
		selectrow="-1"
	
}

function Getinfody()
{  
var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPERGdy.xls';
	}else{
		$.messager.alert("��ʾ","��Чģ��·��","info");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������

	 
    var Ins=document.getElementById('Getgroupinfo');
     
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth);
	
	var String=value.split(";");
	
	for (var i=0;i<String.length;i++){
	
		FData=String[i].split("^");	
		xlsheet.cells(6+i,1).Value=FData[0];
        xlsheet.cells(2,2).Value=FData[1];
		xlsheet.cells(3,2).Value=FData[2]; 
		xlsheet.cells(6+i,2).Value=FData[3]; 
		xlsheet.cells(6+i,3).Value=FData[4]; 
		xlsheet.cells(6+i,4).Value=FData[5]; 
        xlsheet.cells(6+i,5).Value=FData[6]; 

	}
	//xlsheet.printout;
	//xlBook.Close (savechanges=false);
	//xlApp=null;
	//xlsheet=null;
	
    xlsheet.SaveAs("d:\\�����ӡ.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;	
}

document.body.onload = BodyLoadHandler;

function LinkGFeeCat()
{
	var obj,iRowId
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGroupFeeCat&GroupID="+iRowId;
	var wwidth=560;
	var wheight=300;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

function GetCStatus() {
	var iCStatus="";
	obj=document.getElementById("Status_UNCHARGED");
	if (obj && obj.checked){ iCStatus=0; }
	obj=document.getElementById("Status_CHARGED");
	if (obj && obj.checked){ iCStatus=1;}
	obj=document.getElementById("Status_PartCHARGED");
	if (obj && obj.checked){ iCStatus=2;}
	return iCStatus;
}

function BExport_click()
{
	try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGUncharged.xls';
	}else{
		alert("��Ч�Ĵ�ӡģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application"); //??
	xlBook = xlApp.Workbooks.Add(Templatefilepath); //??
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	obj=document.getElementById('GetRowNum');
		if(obj){NumStr=obj.value}
		var Num=NumStr.split("^")
		k=3
		for (j=0;j<Num.length;j++)
		{ 
			var Ins=document.getElementById('GetInfoBox');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var DataStr=cspRunServerMethod(encmeth,Num[j]);
		 if (""==DataStr) { return false; }
		 //alert(DataStr);
		 var Data=DataStr.split("^")
		 xlsheet.cells(k+j,1)=Data[8]
		 xlsheet.cells(k+j,2)=Data[1] 
			xlsheet.cells(k+j,3)=Data[9] 
			xlsheet.cells(k+j,4)=Data[10]
			xlsheet.cells(k+j,5)=Data[2]
			xlsheet.cells(k+j,6)=Data[3]
			xlsheet.cells(k+j,7)=Data[6]	
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,7)).Borders.LineStyle = 1
       
			 
		} 
		obj=document.getElementById('savepath');
		if(obj){var SaveDir=obj.value}
		//"d:\????.xls";
		xlsheet.SaveAs(SaveDir);
		xlApp.Visible = true;
		xlApp.UserControl = true; 
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}

function PEComplete()
{
	
	
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("PECompleteBox");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID)
	if (Return==""){(alert("Update Success!"));
	window.location.reload();}
	
}
//ԤԼ��������
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("RowId");  
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="G"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintCashierNotes()
{
	
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { 
	 alert(t["NoRecord"])
	 return false;}
	var obj=document.getElementById('PGADM_PGBI_DR_Name'+'z'+CurrentSel);
	if (obj) var Name=obj.innerText;
	var Type="G"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPrintCashierNotes"
			+"&ID="+ID+"&Name="+Name+"&Type="+Type
		var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
function CancelCashierNotes()    
{     	var obj=""
        obj=document.getElementById('RowId');
       
		if(obj){
			var PGADM=obj.value
		 
			if (PGADM=="")
			{ alert(t["NoRecord"])
			  return;}
			
			}
         var Ins=document.getElementById('Cancel');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
		 var Flag=cspRunServerMethod(encmeth,"G",PGADM,"");
         if (Flag==""){alert(t["CancelSuccess"])}
         if (Flag=="NoCashier"){alert(t["NoCashier"])} 
	
	
	}
function UpdatePreAudit()
{
	var Type="G",ID="";
	var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	if (ID=="") {
		$.messager.alert("��ʾ","��ѡ�������������","info");
		//alert("��ѡ�������������");
		return false;
		}
	//var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+""+"&RowID="+"";
   // websys_lu(lnk,false,'width=1280,height=600,hisui=true,title=����')
	var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=600,hisui=true,title=����')

	return true;
}
function PrintGroupItem_Click()
{ 
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		}else{
			alert("��Чģ��·��");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  //�̶�
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
		
	    var obj=document.getElementById("RowId");
	    if(obj)  {var PIADM=obj.value;} 
	  	if (PIADM=="")  return false;
	    
	    
	  	var obj=document.getElementById("GetGroupPersonBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var locType="";
	    var ExecFlag="";
	    var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }
	    var ReturnStr=cspRunServerMethod(encmeth,PIADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		 
		   xlsheet.cells(1,+Col).value=DataStr}
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		    var obj=document.getElementById("GetGroupItemBox");
	        if (obj) {var encmeth=obj.value} else{var encmeth=""}
			
	        var FeeStr=cspRunServerMethod(encmeth,IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   xlsheet.cells(row+1,+FeeCol).value=FeeData
		  
		   }
		 
    	
	    }
	   
	    var n=row+2

	    var obj=document.getElementById("GetItemFeeBox");
	    if (obj) {var encmeth=obj.value} else{var encmeth=""}
	    var TotalFeeString=cspRunServerMethod(encmeth);
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   xlsheet.cells(n,+TFeeCol).value=TFeeData}
    	   
	    
		var GroupDesc=""
		var obj=document.getElementById('RowId_Name');
		if (obj) GroupDesc=obj.value;
		xlsheet.SaveAs("d:\\"+GroupDesc+"�����嵥.xls");
		//xlBook.Close (savechanges=false);
		//xlApp=null;
		//xlsheet=null;
	   xlApp.Visible = true;
	   xlApp.UserControl = true;
	 
	}
	    
    
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}
function Contract_change()
{
	var obj=document.getElementById("ContractID");
	if (obj) obj.value="";
}
function ContractFindAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	
	var obj=document.getElementById("Contract");
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("ContractID");
	if (obj) obj.value=Arr[0];
}

function HomeSet_Click()
{
	var obj,encmeth="",ID;
	obj=document.getElementById('RowId');
	if (obj) {var ID=obj.value; }
	
	if (ID=="" || ID==undefined){
		$.messager.alert("��ʾ","��ѡ����趨����������","info");
		return;	
	}
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=G";
	var wwidth=900;
	var wheight=650;
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin) 

}


