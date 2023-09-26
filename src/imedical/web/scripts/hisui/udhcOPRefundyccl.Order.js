///udhcOPRefundyccl.Order.js
var trefundSum=0;
var trefundSumFlag=0
function BodyLoadHandler()
{  
	init_Layout();
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
	// formmater
	var columns=$('#tudhcOPRefundyccl_Order').datagrid('options').columns;
	var TExcuteflag2Field = columns[0][13];
	TExcuteflag2Field.formatter = function(val,rowData,index){
		return val=='0'?'Î´Ö´ÐÐ':'ÒÑÖ´ÐÐ';	
	}
	columns[0][13] = TExcuteflag2Field
	//
	$HUI.datagrid('#tudhcOPRefundyccl_Order', {
		onBeforeLoad: function () {
		 trefundSum = 0;
		},
		columns:columns,
		onLoadSuccess: function (data) {
		
		$('.panel-body-noheader')[0].style.height = parseInt($('.panel-body-noheader')[0].style.height) + 1  + 'px';
         if (trefundSumFlag != 0) return;
         var rows = data.rows.length;
         for (var row = 0; row < rows; row++) {
			trefundSumFlag = trefundSumFlag + 1
			var rowObj = data.rows[row];
			var sExcute = rowObj.TExcuteflag;//document.getElementById('TExcuteflagz'+row).value;
			var ExQty = rowObj.TOrderQty;//document.getElementById('TOrderQtyz'+row).innerText;
			var ReturnQty = rowObj.TReturnQty;// document.getElementById('TReturnQtyz'+row).innerText;
			trefundSum = trefundSum + parseFloat(rowObj.TOrderSum);
			trefundSum = Math.round(trefundSum * 100) / 100;
			var myAuditObj = document.getElementById("AuditFlagz" + row);
			var myAuditFlag = rowObj.AuditFlag;//DHCWebD_GetCellValue(myAuditObj);
			var myobj = document.getElementById("AuditCheckDisz" + row);
			var myAuditCheckDis = "";
			var myAuditCheckDis = rowObj.AuditCheckDis;//DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("AuditSelFlagz" + row);
			var myAuditSelFlag = rowObj.AuditSelFlag;//DHCWebD_GetCellValue(myobj);

			myAuditSelFlag = parseInt(myAuditSelFlag);
		};
		CalCurRefund();
      }	
   });
}


function CalCurRefund()
{
	////
	var ListObj=parent.frames["udhcOPRefundyccl_Order"];
	var mainobj=parent.frames["udhcOPRefundYCCL"];	
	if ((mainobj)&&(ListObj)) {
		var obj=mainobj.document.getElementById("RefundSum");
		//var rtn=DHCWebD_CalListCol(ListObj,"RefSum","Tselect");
		
		if (obj){
			obj.value=trefundSum;
		}  
		var obj=mainobj.document.getElementById("FactRefSum");
		if (obj){
			obj.value=trefundSum;
		}
	}
}

function SelectRowHandler() {
	//fdfd????table??Cl
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
function init_Layout(){
	DHCWeb_ComponentLayout();
	 
}
function NoHideAlert(info){
	DHCWeb_HISUIalert(info);
}
document.body.onload = BodyLoadHandler;
