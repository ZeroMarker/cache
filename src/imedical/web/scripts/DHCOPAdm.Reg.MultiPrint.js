document.body.onload = BodyLoadHandler;
document.body.onunload = DocumentUnloadHandler;
var SelectedRow=0;

function DocumentUnloadHandler(e){
}
function BodyLoadHandler() {
	//得到挂号条打印的参数
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");

	GetReceiptNo();
	
	var MarkCodeStr=DHCC_GetElementData('MarkCodeStr')
	combo_MarkCode=dhtmlXComboFromStr("RegMark",MarkCodeStr);
	combo_MarkCode.enableFilteringMode(true);
	var obj=document.getElementById('Print');
	if (obj) obj.onclick=Print_click;

}
function GetReceiptNo(){
	var encmeth=DHCC_GetElementData('GetreceipNO');
	var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']
	if (encmeth!=""){
		if (cspRunServerMethod(encmeth,'SetReceipNO','',p1)!='0') {
			alert(t['InvalidReceiptNo']);
			return false;
		}
	}
}


function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	DHCC_SetElementData('ReceiptNo',ls_ReceipNo);
	
	//DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///如果张数小于最小提示额change the Txt Color
	if (myary[1]!="0"){	obj.className='clsInvalid';}
}

function Print_click(){
	var PrintCount=DHCC_GetElementData('RegCount');
	if (PrintCount==""){PrintCount=0}
	if (PrintCount==0){
		alert(t['NoRegCount']);
		return;
	}

	var PatientID=DHCC_GetElementData('CommonPatientID');
	if (PatientID==""){
		alert('无公共卡');
		return;
	}
	
	var RegDate=DHCC_GetElementData('RegDate');
	if (RegDate==""){
		alert('没有输入日期');
		return;
	}

	var ResRowId=combo_MarkCode.getSelectedValue();
	var ResDesc=combo_MarkCode.getSelectedText();
	if ((ResDesc=="")||(ResRowId=="")){
		alert('请选择号别');
		return;
	}

	var encmeth=DHCC_GetElementData('GetGetAvailRAMethod');
	var ret=cspRunServerMethod(encmeth,ResRowId, RegDate, "","");
	if (ret==""){
		alert('该号别没有排班');
		return;
	}
	var temparr=ret.split("^");
	var ASRowId=temparr[0];
	
	var ret=confirm((t['ConfirmPrint']),false);
	if (ret==false) return false;	

	try {
		var UserID=session['LOGON.USERID'];
		var GroupID=session['LOGON.GROUPID'];
		
		var encmeth=DHCC_GetElementData('OPRapidRegistEncrypt');
		for (i=0;i<PrintCount;i++){
			var RegDate=DHCC_GetElementData("RegDate");
			//alert(PatientID+"^"+ASRowId+"^"+UserID+"^"+GroupID);
			var PayModeCode="";
			var AdmReason="";
			var AccRowId="";
			var ret=cspRunServerMethod(encmeth,PatientID,ASRowId,AdmReason,PayModeCode,AccRowId,UserID,GroupID);
			var retarr=ret.split("$");	
			if (retarr[0]=="0"){
				PrintOut(retarr[1]);
			}else{
				var errmsg="";
				//alert(t['RegFail']+","+errmsg+","+"ErrCode:"+retarr[0]);
				alert(t['RegFail']+",code:"+retarr[0]);
				websys_setfocus('RegCount');
				return;
			}
		}
		//更新金额和数量,这种方式不是很好
		alert(t["RegOK"]);
	}catch(e){alert(e.message)}	
}

function PrintOut(PrintData) {
	try {
		//alert(PrintData);
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc+"("+SessionType+")";
		
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[11];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];

		if (AppFee!=0){AppFee="预约费:"+AppFee+"元"}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="处置费:"+OtherFee+"元"}else{OtherFee=""}
		if (RegFee!=0){RegFee=RegFee+"元"}else{RegFee=""}
		if (Total!=0){Total=Total+"元"}else{Total=""}

		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	} catch(e) {alert(e.message)};
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}