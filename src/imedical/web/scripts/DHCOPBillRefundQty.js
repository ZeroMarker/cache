///DHCOPBillRefundQty.js
///Lid
///2012-08-22
///门诊退费数量申请
var m_SelectedRow="-1";
function BodyLoadHandler() {
	InitDocument();	
	InitTableCellHandler();
	
}
function InitDocument(){
	var ApplyRefundObj=websys_$("ApplyRefund");
	if(ApplyRefundObj){
		DHCWeb_DisBtn(ApplyRefundObj);
	}
	//
	var EpisodeID=websys_$V("EpisodeID");
	SetPatientInfo(EpisodeID);
}
function SetPatientInfo(EpisodeID){
	var PatInfo=tkMakeServerCall("web.DHCOPBillOERefundQty","GetPatientInfo",EpisodeID);
	var TMPAry=PatInfo.split("^");
	websys_$("PatientNO").value=TMPAry[0];
	websys_$("PatientName").value=TMPAry[1];
	var EncryptLevelObj=document.getElementById('EncryptLevel')
    if(EncryptLevelObj) {EncryptLevelObj.value=TMPAry[11]}
    var PatLevelObj=document.getElementById('PatLevel')
    if(PatLevelObj) {PatLevelObj.value=TMPAry[12]}
}
function InitTableCellHandler(){
	var objtbl=document.getElementById('tDHCOPBillRefundQty');	
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		var ApplyRefQtyCellObj=websys_$("TApplyRefundQtyz"+i)
		if((ApplyRefQtyCellObj)&&(ApplyRefQtyCellObj.id)){
			ApplyRefQtyCellObj.onkeydown = function(){
				var mykey=event.keyCode;
				if (mykey==13){
					//ValidateRefundQty(this);
				}	
			};
			ApplyRefQtyCellObj.onkeypress= function(){
				var mykey=event.keyCode;
				if (mykey==13){
					return;
				}
				if ((mykey>57)||(mykey<46)||(mykey==47)||(mykey==110)){
					event.keyCode=0;
					return;
				}	
			};
			ApplyRefQtyCellObj.onblur = function(){
				ValidateRefundQty(this);
			};
		}
	}	
}
function ValidateRefundQty(Me){
	var ApplyRefundObj=websys_$("ApplyRefund");
	var SelRowObj=Me.parentNode.parentNode;
	var RowIndex=SelRowObj.rowIndex;
	var bool=true;
	var ApplyRefQty=Me.value;
	
	ApplyRefQty=ApplyRefQty.split(".")
	ApplyRefQtylen=ApplyRefQty.length

	if (ApplyRefQtylen>1)
	{
		alert("请输入整数")
		return
	}
	var FactRefQty=GetColumnData("TFactReufndQty",RowIndex);
	var TotalQty=GetColumnData("TPackQty",RowIndex);
	var OEORIDR=GetColumnData("TOEORIRowid",RowIndex);
	//alert(OEORIDR+"^"+TotalQty+"^"+FactRefQty+"^"+ApplyRefQty);
	var MaxRefQty=(eval(TotalQty)-eval(FactRefQty));		//最大退费数量，此处没有考虑医嘱执行数量。
	if(eval(MaxRefQty)<eval(ApplyRefQty)){
		alert(t["MSG03"]+" "+MaxRefQty);
		websys_setfocus(Me.name);
		bool=false;
	}
	///
	if(bool){
		if(ApplyRefundObj){
			//ApplyRefundObj.disabled=false;
			//ApplyRefundObj.onclick=ApplyRefund_OnClick;
			DHCWeb_AvailabilityBtnA(ApplyRefundObj,ApplyRefund_OnClick)
		}	
	}else{
		if(ApplyRefundObj){
			DHCWeb_DisBtn(ApplyRefundObj);	
		}	
	}
}
function ApplyRefund_OnClick(){
	var Guser=session['LOGON.USERID'];
	var ApplyRefQtyStr=GetApplyRefundData();
	if(ApplyRefQtyStr==""){
		alert(t["MSG02"]);
		return;	
	}
	var myrtn=window.confirm(t["MSG01"]);
    if(!myrtn){
       return myrtn;
	}
	var ExpStr="";
	var myrtn=tkMakeServerCall("web.DHCOPBillOERefundQty","InertApplyRefundQty",ApplyRefQtyStr,Guser,ExpStr);
	if(myrtn==0){
		alert(t["Success"]);	
	}else{
		alert(myrtn+t["Failed"]);	
	}
}
function GetApplyRefundData(){
	var ApplyRefQtyStr=""
	var Objtbl=document.getElementById('tDHCOPBillRefundQty');
	var Rows=Objtbl.rows.length;
	for(var i=1;i<Rows;i++){
		var OEORIDR=GetColumnData("TOEORIRowid",i);
		var ApplyRefQty=GetColumnData("TApplyRefundQty",i);
		var FactRefQty=GetColumnData("TFactReufndQty",i);
		var TotalPackQty=GetColumnData("TPackQty",i);
		var RefundQtyInfo=tkMakeServerCall("web.DHCOPBillOERefundQty","GetRefundQTY",OEORIDR,"");
		var myApplyRefQty=RefundQtyInfo.split("^")[1];
		if(myApplyRefQty==ApplyRefQty)continue;
		if(eval(TotalPackQty)<(eval(ApplyRefQty)+eval(FactRefQty)))continue;
		if(ApplyRefQtyStr==""){
			ApplyRefQtyStr=OEORIDR+"^"+eval(ApplyRefQty).toFixed(2);
		}else{
			ApplyRefQtyStr=ApplyRefQtyStr+"!"+OEORIDR+"^"+eval(ApplyRefQty).toFixed(2);
		}		
	}
	return ApplyRefQtyStr;
}

function SelectRowHandler()	{   
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	var Objtbl=document.getElementById('tDHCOPBillRefundQty');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var frm =dhcsys_getmenuform();
		if (frm) {
			frm.EpisodeID.value=websys_$V("EpisodeID");	//头菜单传Adm
			if(frm.PatientID) frm.PatientID.value ="";
		}
		m_SelectedRow = selectrow;
	}else{
		
	}
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value
			}
		}
	}
	return "";
}
function getloc(str){ 
		var loc=str.split("^");
		var locdes=document.getElementById("lulocdes")
		locdes.value=loc[1];
		var obj=document.getElementById("luloc")
		obj.value=loc[0];
}
document.body.onload = BodyLoadHandler;