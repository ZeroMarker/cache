/**
 * FileName: dhcbill.pkg.opcharge.paymshw.js
 * Anchor: DingSh
 * Date: 2019-10-19
 * Description: 门诊结算时支付方式弹窗(展示收费员) 
 */

 var GV = {
	PayMList:{},
	PayAllAmt:0.0
};
 $(function () {
	 
	 $(document).keydown(function(e){
		 banBackSpace(e);
		 frameEnterKeyCode(e);
		 })
	 
	  InitPatBanner();
	  initPayMList();
	  initPaymWinMenu();
	  
	  

	$HUI.linkbutton("#win-btn-confirm", {
		onClick: function () {
			 
		}
	});	  
	  
	
  
	  
 //找零计算	  
  $("#winPreSum").keydown(
	    function(e)
	    {
		 preSumKeydown(e)
		 }
	 
	   )
	   
 focusById('winPreSum')
 
});

	 
function frameEnterKeyCode(e)
{
   var key=websys_getKey(e)
	switch(key)
	{
		case 120:
		//alert(123)
		
		break;
		
		default:
		
		
		
		}	 
		 
 }
    
 //加载病人基本信息Banner   
 function InitPatBanner()
 {
	 var papmi = getParam('papmiDr');
	 refreshBar(papmi, ""); 
 }
 
 //加载已经支付方式列表
function initPayMList() {
	GV.PayMList = $HUI.datagrid('#paymList', {
		fit: true,
		border: true,
		title: "",
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		pageSize: 999999999,
		columns: [[{
					title: '支付方式',
					field: 'PayMode',
					width: 100,
					}, {
					title: '金额',
					field: 'PayAtm',
					align: 'right',
					width: 140,
					editor: {
						type: 'numberbox',
						options: {
							precision: 2
						}
					}
				}, {
					title: 'PayModeCode',
					field: 'PayModeCode',
					hidden: true
				}, {
					title: 'PayModeDr',
					field: 'PayModeDr',
					hidden: true
				}
			]],
		queryParams: {
			ClassName: "BILL.PKG.COM.BLCommon",
			QueryName: "FindPayModeInfo",
			PrtStr:getParam('PrtStr') ,
			
			
		},
		onLoadSuccess: function (data) {
			InitPayText()
			
		},
		
		
	});
}
 
 

function initPaymWinMenu() {
	$HUI.linkbutton("#win-btn-sell", {
		onClick: function () {

		}
	});
	//关闭
	$HUI.linkbutton("#win-btn-close", {
		onClick: function () {
			$("#paymWin").dialog("close");
		}
	});
}

/**
* 初始化界面text
*/
function InitPayText() {
	
	
	var paymAll = 0;
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.PayAtm;
		var paymCode = row.PayModeCode;
		paymAll = numCompute(paymAll, paymAmt, "+");
		if (paymCode == "CASH") 
		 {
			 setValueById("winPayAmt", toNumber(paymAmt).toFixed(2))
		 }
	});
	
	GV.PayAllAmt= paymAll;
	setValueById('winTotalAmt',paymAll)
	setValueById('winDiscAmt',getParam('DiscAmt'))
	setValueById('receiptNo',getParam('receiptNo'))
	
}


function preSumKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cashAmt = 0;   
		$.each(GV.PayMList.getRows(), function (index, row) {
			var paymAmt = row.PayAtm;
			var paymCode = row.PayModeCode;
			if (paymCode == "CASH") {
			    cashAmt=paymAmt
				setValueById("winPayAmt", toNumber(paymAmt).toFixed(2))
			}
		});
	  
	   
	   
	    var preSum = $(e.target).val();
		var change = preSum - cashAmt;
		setValueById("winChange", toNumber(change).toFixed(2)); //找零
	}
}


function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}
 