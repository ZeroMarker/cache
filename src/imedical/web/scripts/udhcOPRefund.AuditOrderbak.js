/////udhcOPRefund.AuditOrder.js

function BodyLoadHandler()
{  
	IntDoument();	
	document.onkeydown = DHCWeb_EStopSpaceKey;
}

function tRefundOrder_Click()
{  
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	if (rowObj.tagName=='TH') return;
	var row=rowObj.rowIndex;
	var sExcute=document.getElementById('TExcuteflagz'+row).value;
	var sSelect=document.getElementById('Tselectz'+row);
	var ExQty=document.getElementById('TOrderQtyz'+row).innerText;
	var ReturnQty=document.getElementById('TReturnQtyz'+row).innerText;
	if ((sExcute=="1")||((ReturnQty<ExQty)&&(ReturnQty!=0)))
	{
		sSelect.disabled=true;
	}
}

function IntDoument()
{
	////check OEOrder is Enable or disable
	var tabOPList=document.getElementById('tudhcOPRefund_AuditOrder');
	var rows=tabOPList.rows.length;
	for (var row=1;row<rows;row++){
		var sExcute=document.getElementById('TExcuteflagz'+row).value;
		var sSelect=document.getElementById('Tselectz'+row);
		var ExQty=document.getElementById('TOrderQtyz'+row).innerText;
		var ReturnQty=document.getElementById('TReturnQtyz'+row).innerText;
		
		if ((sExcute=="1"))
		{
			/////||((ReturnQty<ExQty)&&(ReturnQty!=0))
			sSelect.disabled=true;
		}else{
			sSelect.disabled=false;
		}
	}
	CalCurRefund();
	
}

function CalCurRefund()
{
	////
	var ListObj=parent.frames["udhcOPRefund_AuditOrder"];
	var mainobj=parent.frames["udhcOPRefund_main"];
	if ((mainobj)&&(ListObj)) {
		var obj=mainobj.document.getElementById("RefundSum");
		var rtn=DHCWebD_CalListCol(ListObj,"RefSum","Tselect");
		if (obj){
			obj.value=rtn;
		}
	}
	return rtn;
}

function SelectRowHandler() {
	//fdfd能够继承table表的Click事件?
	////tRefundOrder_Click();
	CalCurRefund();
}

function GetAuditInfo()
{
	////format ^^^_$c(2)
	var StopOrderstr="",ToBillOrderstr=""
	var myAuditAry=new Array();
	var myIdx=0;
	var mystr="";
	var AllExecute=1
	var myUser=session['LOGON.USERID'];
	var objtbl=document.getElementById('tudhcOPRefund_AuditOrder');
	var Rows=objtbl.rows.length;
	for (var j=1; j<Rows; j++)
	{
		var sExcute=document.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}
		var TSelect=document.getElementById("Tselectz"+j);
		var myObj=document.getElementById('TOrderRowidz'+j);
		var sOrderRowid=DHCWebD_GetCellValue(myObj);
		var mySelFlag=DHCWebD_GetCellValue(TSelect);
		//if ((mySelFlag)&&(!TSelect.disabled)){
		if (mySelFlag){	
			var myary=new Array();
			myary[0]="";
			myary[3]=sOrderRowid;
			myary[4]=myUser;
			myary[5]="";
			myary[7]="";			////IOA_AuRefundQty
			myary[8]="P"			////IOA_Flag
			var mystr=myary.join("^");
			myAuditAry[myIdx]=mystr;
			myIdx=myIdx+1;
			///mystr=+"^"+;
		}
		
	}
	
	var myAuditInfo=myAuditAry.join(String.fromCharCode(2));
	
	return myAuditInfo;
}


document.body.onload = BodyLoadHandler;
