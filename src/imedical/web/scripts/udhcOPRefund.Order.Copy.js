///udhcOPRefund.Order.Copy.js

function BodyLoadHandler()
{  
	var myobj=document.getElementById("AllSelect");
	if (myobj){
		myobj.onclick=AllSelect_OnClick;
	}
	//IntDoument();	
	
	document.onkeydown = document_OnKeyDown;
}

function AllSelect_OnClick()
{
	var mycheck=DHCWebD_GetObjValue("AllSelect");
	
	SelectAll(mycheck);
	
}

function SelectAll(myCheck){
	///var myRLStr="";
	var myRows=DHCWeb_GetTBRows("tudhcOPRefund_Order_Copy");
	
	for (var i=1;i<=myRows;i++){
		
		var obj=document.getElementById("Tselectz"+i);
		///var mySelFlag=DHCWebD_GetCellValue(obj);
		var sSelect=document.getElementById('Tselectz'+i);
		if (!sSelect.disabled){
			
			DHCWebD_SetListValueA(obj,myCheck);
		}
	}
	
	if (myRows>0){
		
		CalCurRefund();
	}
}

function document_OnKeyDown()
{
	var e=window.event;
	///alert(e.keyCode);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
	
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
	var tabOPList=document.getElementById('tudhcOPRefund_Order_Copy');
	var rows=tabOPList.rows.length;
	for (var row=1;row<rows;row++){
		var sExcute=document.getElementById('TExcuteflagz'+row).value; //执行标志
		var sSelect=document.getElementById('Tselectz'+row);
		var ExQty=document.getElementById('TOrderQtyz'+row).innerText; //医嘱数量
		var ReturnQty=document.getElementById('TReturnQtyz'+row).innerText; //退费数量
		if ((sExcute=="1"))
		{
			/////||((ReturnQty<ExQty)&&(ReturnQty!=0))
			sSelect.disabled=true;  
		}else{
			sSelect.disabled=false;
		}
		var myAuditObj=document.getElementById("AuditFlagz"+row);
		var myAuditFlag=DHCWebD_GetCellValue(myAuditObj);
		////AuditCheckDis=Y   disable
		var myobj=document.getElementById("AuditCheckDisz"+row);
		var myAuditCheckDis="";
		var myAuditCheckDis=DHCWebD_GetCellValue(myobj);
		
		if (myAuditCheckDis=="Y"){
			sSelect.disabled=true;
		}else{
			////sSelect.disabled=false;
		}
		var myobj=document.getElementById("AuditSelFlagz"+row);
		var myAuditSelFlag=DHCWebD_GetCellValue(myobj);
		
		myAuditSelFlag=parseInt(myAuditSelFlag);
		DHCWebD_SetListValueA(sSelect,myAuditSelFlag);
		
	}
	CalCurRefund();
	
}

function CalCurRefund()
{
	////
	var myRefSum=0;
	var ListObj=parent.frames["udhcOPRefund_Order_Copy"];
	var mainobj=parent.frames["udhcOPRefund_main_Copy"];

	if ((mainobj)&&(ListObj)) {
		var myRoundNum=0;
		var obj=mainobj.document.getElementById("RoundNum");
		myRoundNum=DHCWebD_GetObjValueA(obj);
		if ((isNaN(myRoundNum))||(myRoundNum=="")){
			myRoundNum=0;
		}
		myRoundNum=parseFloat(myRoundNum);
		var obj=mainobj.document.getElementById("Sum");
		var myINVSum=DHCWebD_GetObjValueA(obj);
		
		var rtn=DHCWebD_CalListCol(ListObj,"RefSum","Tselect");
		
		var obj=mainobj.document.getElementById("RefundSum");
		if (obj){
			obj.value=rtn;
		}
		var obj=mainobj.document.getElementById("FactRefSum");
		if (obj){
			obj.value=rtn;
		}
		
	}
	return myRefSum;
}

function SelectRowHandler() {
	//fdfd能够继承table表的Click事件?
	////tRefundOrder_Click();
	CalCurRefund();
}

function ReturnOrder()
{
	var StopOrderstr="",ToBillOrderstr=""
	var AllExecute=1
	var objtbl=document.getElementById('tudhcOPRefund.Order.Copy');
	var Rows=objtbl.rows.length;
	for (var j=1; j<Rows; j++)
	{
		var sExcute=document.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}
		var TSelect=document.getElementById("Tselectz"+j);
		var sOrderRowid=document.getElementById('TOrderRowidz'+j).innerText;
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
		}
		
	}
}


document.body.onload = BodyLoadHandler;
