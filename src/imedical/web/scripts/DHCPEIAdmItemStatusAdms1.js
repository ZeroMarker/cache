///	DHCPEIAdmItemStatusAdms.js
///	ǰ̨����վ
///	2006/05/24  ����888-TT
///	-----------------------
///	modified by SongDeBo 2006/5/25
///	Description: add function "CancelArrived"

var gPEIAdmId="", gIAdmId="", gIAdmStatus="";
var TFORM="DHCPEIAdmItemStatusAdms";
var SelectedRow=0

function BodyLoadHandler(){
	
	var obj;
	
	obj=document.getElementById("BDietSelect");
	if (obj) { obj.onclick=BDietSelect_click;}
	
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_Click; }
	
	obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }	
	
	obj=document.getElementById("txtGroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	
	obj=document.getElementById("TFORM");
	if (obj && ""!=obj.value) { TFORM=obj.value; }
	
	obj=document.getElementById("txtAdmNo");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	obj=document.getElementById("txtPatName");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	
	//alert('BodyLoadHandler 1');
	// ��ӡ ��ӡ��
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	//alert('BodyLoadHandler 2');
	ShowCurRecord(1);
	//alert('BodyLoadHandler 3');
	websys_setfocus("txtAdmNo");
	//ColorTblColumn();
}
function GroupName_Change()
{
	var obj=document.getElementById("txtGroupId");
	if (obj) { obj.value=""; }
}
function Reg_No_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		btnQuery_click();
	}
}
//����
function Clear_Click(){
	/*
	var Data=GetSelectId("TAdmId^TAdmStatus^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");

	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		
		FData=Datas[iLLoop].split("^");
		alert(FData);
		if (""!=FData) {
			iIAdmId=FData[2];
			
		}
	}
	
	return;
	*/
	var obj;
	obj=document.getElementById('txtAdmNo');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtGroupName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtPatName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtAdmDate');
	if (obj) { obj.value=""; }
}

function AfterGroupSelected(value){
	//ROWSPEC = "GBI_Desc:%String, GBI_Code:%String, GBI_RowId:%String"	
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[2],true);
	SetCtlValueByID("txtGroupName",aiList[0],true);
}

// ******************************************************************************
// ******************************************************************************
// ************************        ǰ̨����          *****************************

//���������ӡ
function BarCodePrint() 
{
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
		return ;
	}
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2]
			var iOEOriId="";
			var InString=iIAdmId+"^"+iOEOriId;
			
			//��ȡ��Ϣ
			var Ins=document.getElementById("PatOrdItemInfo");
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,"BarPrint","",InString);
		}
	}


}

function BarPrint(value) {	
	if (""==value) {
		alert("δ�ҵ�������Ŀ");
		return false;
	}
	var Ords=value.split(";");
	var iLLoop=1;
	for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{

		OrdItems=Ords[iLLoop].split("^");
		
		var Bar;  
		Bar= new ActiveXObject("PEPrintBar.PrnBar");
		Bar.PrintName="tm";//��ӡ������
        Bar.SetPrint()
		// �ǼǺ�
		Bar.RegNo=OrdItems[0]; 	
		// ����
		Bar.PatName=OrdItems[1];
		// ����
		Bar.Age=OrdItems[2];
		// �Ա�
		Bar.Sex=OrdItems[3];
		// ����
		Bar.PatLoc=OrdItems[4];	
		// �걾��
		Bar.SpecNo=OrdItems[6];	
		
		// ��Ŀ����
		var OrdNameArray=Ords[iLLoop].split("\\!");
		Bar.OrdName=OrdNameArray[1];	
		Bar.RecLoc=OrdNameArray[2];
        Bar.BedCode="";  
		Bar.PrintZebraBar();		
	}

}
function PrintOneBarCode()
{
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	var OneSpecNo=parent.frames[targetFrame].GetOneSpecNo();
	var Info=OneSpecNo.split("^");
	var IAdmId=Info[0];
	var SpecNo=Info[1];
	if (SpecNo=="") {alert("��ѡ��һ���걾��");return;}
	if (IAdmId=="") return;
	if (!confirm("ȷʵ��ӡ�걾��Ϊ"+SpecNo+"��������")) return;
	var InString=IAdmId+"^"
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,"","",InString);
	var Ords=value.split(";");
	
	var iLLoop=1;
	for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{

		var OrdItems=Ords[iLLoop].split("^");
		var OneSpecNo=OrdItems[6];
		if (OneSpecNo!=SpecNo) continue;
		/*
		var Bar;  
		Bar= new ActiveXObject("PEPrintBar.PrintBar");
		// �ǼǺ�
		var RegNo=OrdItems[0]; 	
		// ����
		var PatName=OrdItems[1];
		// ����
		var Age=OrdItems[2];
		// �Ա�
		var Sex=OrdItems[3];
		//alert("Bar.Sex:"+Bar.Sex);
		// ����
		var PatLoc=OrdItems[4];	
		// �걾��
		var SpecNo=OrdItems[6];	
		
		
		// ��Ŀ����
		var OrdNameArray=Ords[iLLoop].split("\!");
		var OrdName=OrdNameArray[1];
		var RecLoc=OrdNameArray[2];
		var BedCode="";
 		Bar.PrintBar(RegNo,PatName,Age,Sex,PatLoc,SpecNo,OrdName,RecLoc,BedCode)
		*/
		var Bar;  
		Bar= new ActiveXObject("PEPrintBar.PrnBar");
		Bar.PrintName="tm";//��ӡ������
        Bar.SetPrint()
		// �ǼǺ�
		Bar.RegNo=OrdItems[0]; 	
		// ����
		Bar.PatName=OrdItems[1];
		// ����
		Bar.Age=OrdItems[2];
		// �Ա�
		Bar.Sex=OrdItems[3];
		//alert("Bar.Sex:"+Bar.Sex);
		// ����
		Bar.PatLoc=OrdItems[4];	
		// �걾��
		Bar.SpecNo=OrdItems[6];	
		
		// ��Ŀ����
		var OrdNameArray=Ords[iLLoop].split("\\!");
		Bar.OrdName=OrdNameArray[1];	
		Bar.RecLoc=OrdNameArray[2];
        Bar.BedCode="";  
		Bar.PrintZebraBar();
	}
}
///վ��Ⱥ��ѯ
function StationWaitList() {	

	DAlert("test");	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
			;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=300,left=100,top=100';
	window.open(lnk,"_blank",nwin)
}

///�Ͳ� Create by MLH
function Diet() {

	var Data=GetSelectId("TPEIAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2];
			var encmeth=GetCtlValueById('DietBox',1);        
    		var flag=cspRunServerMethod(encmeth,iIAdmId)///////////
    		if (flag!='0') {
				alert(FData[2]+" "+t['ErrFailed']+"  error="+flag);
				return false
			}

		}
	}

    alert(t['Completed']);
    location.reload();

}

///ȡ��ȡ��
function IAdmAlterStatus(){
	var Data=GetSelectId("TPEIAdmId^TAdmStatus^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			iIAdmId=FData[2];
			IAdmStatus=FData[3];
			var newStatus=""
			//if (IAdmStatus=="ARRIVED") {newStatus="REGISTERED"}
			//if (IAdmStatus=="REGISTERED") {newStatus="ARRIVED"}
			if (IAdmStatus=="ARRIVED") {newStatus="CANCELARRIVED"}
			if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
			if (newStatus==""){
				alert(t['ErrNotStatus']+IAdmStatus);
				return false;
			}
	
			DAlert(gPEIAdmId);
			var encmeth=GetCtlValueById('AlterStatusBox',1);        
			var flag=cspRunServerMethod(encmeth,iIAdmId,newStatus)///////////
			if (flag!='0') {
				alert(FData[2]+" "+t['ErrFailed']+"  error="+flag);
				return false
			}
		}
	}

    alert(t['Completed']);
    location.reload(0);
}

// ��ӡ���쵥
function PatItemPrint() {
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var Instring=FData[2]+"^"+FData[3];
			//alert("aaaa");
			var Ins=document.getElementById('GetOEOrdItemBox');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var value=cspRunServerMethod(encmeth,'','',Instring);
			//alert(value);
			Print(value);
			//alert("value:"+value);
			//alert("a:"+a);
		}
	}	
}
/*
function Print(value)
{	
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	
	// ������Ϣ
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // ��ǩ
	var PatInf=PatInfos[1].split("^"); // ֵ

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	
	// ������Ŀ
	ListInfo="";
	var OEItems=vals[1].split(";");
	var ShortLine="_____________";
	var NullLine="             ";
	var Line1="__________________________"
	var Line2="_______________________________________";
	var Line3="______"
	var LineStr="";
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
		if (""!=OEItem[0]) var ItemName=OEItem[0]
		
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (NextItem==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^";}
		}
		if (0==(iLLoop+1) % 31) {LineStr="^^^";}   //����Ǳ�ҳ�������ȥ������
		if (1==(iLLoop+1) % 31) {OEItem[0]=ItemName;} //����Ǻ���ҳ��ӡ�������������
		 				 // ����	      ������� 1	��Ŀ 2		ע������ 3
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^"+OEItem[1]+"^"+OEItem[2]+Char_2;  //
		//��ҳ ÿҳ24��
		
		if ((0==(iLLoop+1) % 31)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			//if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;
			//alert(ListInfo);
			ListInfo="";
		}
	}
	if (ListInfo!=""){
	var myobj=document.getElementById("ClsBillPrint");
	if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;}
	//alert("���쵥��ӡ���");

}
*/
// ********************************************************************

// ����ɵ�ԤԼ���ʾ?��ɫ
function ColorTblColumn(){
	var tbl=document.getElementById('t'+TFORM);	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById('TCompletedz'+j);
		var sTD=sLable.parentElement;
		var strCell=sLable.innerText;
		strCell=strCell.replace(" ","")
		if (strCell=='') {
			sTD.className="DentalSel";
		}
		else{
			sTD.className="Govement";
		}
	}
}

// ********************************************************************
function GetSelectId(FiledName) 
{
	var tbl=document.getElementById('t'+TFORM);	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	var vals="";
	var val=""
	var FNames=FiledName.split('^');

	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
			
			obj=document.getElementById('TPatNAME'+'z'+iLLoop);
			if (obj) { val=iLLoop+'^'+obj.innerText+'^'; }
			
			for (var iFLoop=0;iFLoop<FNames.length-1;iFLoop++){			
				obj=document.getElementById(FNames[iFLoop]+'z'+iLLoop);
				if (obj) {if (obj.type!='checkbox') val=val+obj.value+'^'; 
				if (obj.type=='checkbox') val=val+obj.checked+"^"}
				
			}
			
			vals=vals+val+";";
		}
	}
	if (""==vals) { alert("δѡ���ܼ���,������ֹ!"); }
	return vals;
}
function BDietSelect_click()
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('t'+TFORM);	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TDeitFlag'+'z'+iLLoop);
		if (obj) { obj.checked=!obj.checked; }
	}
}
function SelectALL_Click() 
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('t'+TFORM);	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}
///ѡ�� ��ʾ����Ŀ
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//�����¼���
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusAdms');	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    ///�˴�֮ǰ��Ϊ�̶�?�����޸�document.getElementById('tINSUPatTypeC
    
    if (!selectrow) return;

	ShowCurRecord(selectrow)
}	
function ShowCurRecord(CurRecord) {
	var SelRowObj
	var obj	
	var selectrow=CurRecord;
	var equipmentId;
	
	var admId="";
	gIAdmId="";
	gPEIAdmId="";
	gIAdmStatus="";	
	
	SelCellObj=document.getElementById('TAdmIdz'+selectrow);
	//admId=SelCellObj.innerText;	
	if (SelCellObj) {
		admId=SelCellObj.value;	
		gIAdmId=SelCellObj.value;	
	}
	
	SelCellObj=document.getElementById('TPEIAdmIdz'+selectrow);
	if (SelCellObj) {
		gPEIAdmId=SelCellObj.value;
	}
	SelCellObj=document.getElementById('TAdmStatusz'+selectrow);
	if (SelCellObj) {
		gIAdmStatus=SelCellObj.value;	
	}
	
	targetFrame=GetCtlValueById("txtTargetFrame");
	targetComponet=GetCtlValueById("txtTargetComponent");
	paramName=GetCtlValueById("txtParamName");

	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targetComponet+"&" +paramName+"="+admId ;
    parent.frames[targetFrame].location.href=lnk;
	
}
document.body.onload = BodyLoadHandler;

