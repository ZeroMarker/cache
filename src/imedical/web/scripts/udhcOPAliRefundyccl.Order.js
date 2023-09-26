///udhcOPAliRefundyccl.Order.js

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
	//var sSelect=document.getElementById('Tselectz'+row);
	var ExQty=document.getElementById('TOrderQtyz'+row).innerText;
	var ReturnQty=document.getElementById('TReturnQtyz'+row).innerText;
	/*
	if ((sExcute=="1")||((ReturnQty<ExQty)&&(ReturnQty!=0)))
	{
		sSelect.disabled=true;
	}   */
}

function IntDoument()
{
	var tabOPList=document.getElementById('tudhcOPAliRefundyccl_Order');
	var rows=tabOPList.rows.length;
	for (var row=1;row<rows;row++){
		var sExcute=document.getElementById('TExcuteflagz'+row).value;
		//var sSelect=document.getElementById('Tselectz'+row);
		var ExQty=document.getElementById('TOrderQtyz'+row).innerText;
		var ReturnQty=document.getElementById('TReturnQtyz'+row).innerText;
		/*
		if ((sExcute=="1"))
		{
			/////||((ReturnQty<ExQty)&&(ReturnQty!=0))
			sSelect.disabled=true;
		}else{
			sSelect.disabled=false;
		}  */
		var myAuditObj=document.getElementById("AuditFlagz"+row);
		var myAuditFlag=DHCWebD_GetCellValue(myAuditObj);
		////AuditCheckDis=Y   disable
		var myobj=document.getElementById("AuditCheckDisz"+row);
		var myAuditCheckDis="";
		var myAuditCheckDis=DHCWebD_GetCellValue(myobj);
		
		if (myAuditCheckDis=="Y"){
			//sSelect.disabled=true;
		}else{
			////sSelect.disabled=false;
		}
		var myobj=document.getElementById("AuditSelFlagz"+row);
		var myAuditSelFlag=DHCWebD_GetCellValue(myobj);
		
		myAuditSelFlag=parseInt(myAuditSelFlag);
		//DHCWebD_SetListValueA(sSelect,myAuditSelFlag);
		
	}
	CalCurRefund();
	
}

function CalCurRefund()
{
	////
	var ListObj=parent.frames["udhcOPRefundyccl_Order"];
	var mainobj=parent.frames["udhcOPRefundYCCL"];	
	if ((mainobj)&&(ListObj)) {
		var obj=mainobj.document.getElementById("RefundSum");
		var rtn=DHCWebD_CalListCol(ListObj,"RefSum","Tselect");
		/*
		if (obj){
			obj.value=rtn;
		}  */
		var obj=mainobj.document.getElementById("FactRefSum");
		if (obj){
			obj.value=rtn;
		}
	}
	return rtn;
}

function SelectRowHandler() {
	//fdfdÄÜ¹»¼Ì³Ðtable±íµÄCl
	////tRefundOrder_Click();
	CalCurRefund();
}

function ReturnOrder()
{
	var StopOrderstr="",ToBillOrderstr=""
	var AllExecute=1
	var objtbl=document.getElementById('tudhcOPRefundyccl.Order');
	var Rows=objtbl.rows.length;
	for (var j=1; j<Rows; j++)
	{
		var sExcute=document.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}
		//var TSelect=document.getElementById("Tselectz"+j);
		var sOrderRowid=document.getElementById('TOrderRowidz'+j).innerText;
		/*
		if (TSelect.innerText==1)
		{
			if (ToBillOrderstr==""){ToBillOrderstr=sOrderRowid;}
			else
			{ToBillOrderstr=ToBillOrderstr+'^'+sOrderRowid;}
		}
		else
		{
			if (StopOrderstr==""){StopOrderstr=sOrderRowid;}
			else
			{StopOrderstr=StopOrderstr+'^'+sOrderRowid;}
		}  */
		
	}
}

document.body.onload = BodyLoadHandler;
