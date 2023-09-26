/**
 * FileName: dhcbill.pkg.opcharge.paymshw.js
 * Anchor: DingSh
 * Date: 2019-10-19
 * Description: �������ʱ֧����ʽ����(չʾ�շ�Ա) 
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
	  
	
  
	  
 //�������	  
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
    
 //���ز��˻�����ϢBanner   
 function InitPatBanner()
 {
	 var papmi = getParam('papmiDr');
	 refreshBar(papmi, ""); 
 }
 
 //�����Ѿ�֧����ʽ�б�
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
					title: '֧����ʽ',
					field: 'PayMode',
					width: 100,
					}, {
					title: '���',
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
	//�ر�
	$HUI.linkbutton("#win-btn-close", {
		onClick: function () {
			$("#paymWin").dialog("close");
		}
	});
}

/**
* ��ʼ������text
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
		setValueById("winChange", toNumber(change).toFixed(2)); //����
	}
}


function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}
 