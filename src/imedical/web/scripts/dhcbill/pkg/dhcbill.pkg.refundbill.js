/*
 * FileName:	dhcbill.pkg.refundbill.js
 * User:		TianZJ/tangzf
 * Date:		2019-09-23
 * Function:	
 * Description: 门诊套餐确认 该界面也可以进行灵活折扣操作
 */
var GV={
	 PAPMI:'',
	 ADMTYPE:'OP',
	 PACKAGEID:''
 };
 $(function () {
	 

	initQueryMenu();
	init_dg();
	init_AdmType();
});
function initQueryMenu(){
	//登记号回车查询事件
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event)
  		}
	})
	//卡号回车查询事件
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	//读卡
	$HUI.linkbutton("#btn-ReadCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	setValueById('RefundAmt','0.00');
	setValueById('ProAmt','0.00');
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox("getValue");
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
}
// 清屏
$HUI.linkbutton("#btn-Clear", {
	onClick: function () {
		clearClick();
	}
});
// 退费
$HUI.linkbutton("#btn-Refund", {
	onClick: function () {
		refund_Click();
	}
});
/*
 * 初始化Dg
 */
function init_dg(){
	var dgColumns = [[
			{field:'ProDesc',title:'套餐名称',width:150},
			{field:'ArcDesc',title:'医嘱项',width:200},
			{field:'Quantity',title:'购买数量',width:80},
			{field:'PatStatus',title:'套餐状态',width:80,
				styler:function(value,row,index){
					return value=='已使用'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				},
			},
			{field:'RefundAtm',title:'退费金额',width:100,align:'right',
				formatter:function(value,rowData,index){
					return parseFloat(value).toFixed(2);
				}	
			},
			{field:'RemainingQty',title:'退费数量',width:100},
			{field:'ProSalesPrice',title:'套餐售价',width:100,align:'right'},
			{field:'PriceperUnit',title:'单价',width:100,align:'right'},
			{field:'TotalAmount',title:'总金额',width:100,align:'right'},
			{field:'DiscPrice',title:'折扣单价',width:100,align:'right'},
			{field:'DiscAmount',title:'折扣总额',width:100,align:'right'},
			{field:'PatsharePrice',title:'自付单价',width:100,align:'right'},
			{field:'PatshareAmount',title:'自付总额',width:100,align:'right'},
			{field:'ProCreatDate',title:'创建日期',width:100},
			{field:'ProCreateTime',title:'创建时间',width:100},
			{field:'ProUser',title:'创建人',width:150},
			{field:'ValidstartDate',title:'开始日期',width:150},
			{field:'ValidendDate',title:'结束日期',width:150},
			{field:'OrdRowId',title:'医嘱dr',width:150,},
			{field:'OrdExcRowId',title:'执行记录dr',width:150},
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			calRefundAmt(data);
		},
		onSelect:function(index,rowData){

		},
	});	
}
/*
 * 加载dg
 */
function initLoadGrid(){
	if(GV.ADMTYPE==''){
		$.messager.alert('提示','就诊类别不能为空','info');	
		return;
	}
	var queryParams={
			ClassName:'BILL.PKG.BL.PatientBill',
			QueryName:'FindRefundOrderDetailsByPatDr',
			PatDr:GV.PAPMI,
			Type:GV.PACKAGEID,
			ProRowId:GV.PACKAGEID	
	}
	loadDataGridStore('dg',queryParams);
}
/*
 * 登记号回车
 */
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $(e.target).val();
		if (!patientNo) {
			return;
		}
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: patientNo,
			HOSPID: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (rtn) {
			$(e.target).val(rtn);
			getPatInfo();
		});
	}
}
function getPatInfo() {
	var patientNo = getValueById('RegNo');
	$.m({
		ClassName: 'web.UDHCJFBaseCommon',
		MethodName: 'GetCardNOByPAPMI',
		patNO: patientNo,
		papmiDr: '',
		adm: ''
	}, function (rtn) {
		var myAry = rtn.split('^');
		if (!myAry[1]) {
			GV.PAPMI='';
			$.messager.alert('提示', '登记号错误', 'error');
		} else {
			GV.PAPMI=myAry[1];
			refreshBar(GV.PAPMI,'');
			init_Package();
		}
	});
}

/*
 * 套餐产品信息
 */
function init_Package(){
	$HUI.combogrid('#PackageDesc',{
		panelWidth:500,   
	    editable:true,
	    panelHeight:300,  
      	fit: true,
     	pagination: true,
      	singleSelect: true,
      	multiple: false,
        onBeforeLoad:function(param){
	        param.ClassName='BILL.PKG.BL.PatientBill';
	        param.QueryName='FindProductInfoByPatDr';
	        param.PatDr=GV.PAPMI;
		},
		url: $URL,
		idField: 'PatProRowId',
		textField: 'ProDesc',
		columns: [[
			{field:"ProDesc",title:"套餐名称",width:100},
			{field:"ProRefundStandard",title:"退费标准",width:80},
			{field:"ProIsshare",title:"是否共享",width:80},
			{field:"ProIndependentpricing",title:"自主定价",width:80,
				formatter:function(value,rowData,index){
					return value==0?value="否":value="是";
				}
			},
			{field:"ProSalesPrice",title:"售价",width:100,align:'right'},
			{field:"ProPrice",title:"标准价格",width:100,align:'right'},
			{field:"PatProRowId",title:"客户套餐ROWID",width:100,hidden:true},

		]],
		onSelect:function(index,rowData){
			GV.PACKAGEID=rowData.PatProRowId
			initLoadGrid();
		    
		},
		onLoadSuccess:function(){
			var PackageGrid=$('#PackageDesc').combogrid('grid');
			if(PackageGrid.datagrid('getRows').length>0){
				PackageGrid.datagrid('selectRow',0)	
			}	
		}
	})	
}
function clearClick(){
	window.location.reload(true);		
}
/*
 * 初始化Dg
 */
 function init_AdmType(){
	$HUI.combobox('#AdmType',{
		valueField: 'value',
		textField: 'text',
		data: [{value: 'OP', text: '门诊', selected: true},
			   {value: 'EP', text: '急诊'},
			   {value: 'PE', text: '体检'},
			   {value: 'IP', text: '住院'}
		],
		onSelect: function (record) {
			GV.ADMTYPE=record.value;
		},		
	})
}
/*
 * 计算退费信息
 */
function calRefundAmt(data){
	var refundAmt=0; 	// 退费金额
	var ProAmt=0; // 产品金额
	var ProSaleAmt=0; // 套餐售价
	setValueById('RefundAmt',refundAmt);
	setValueById('ProAmt',ProAmt);
	$.each(data.rows, function (index, row) {
		refundAmt=refundAmt+parseFloat(row.RefundAtm);
		ProAmt=ProAmt+parseFloat(row.TotalAmount);
		ProSaleAmt=row.ProSalesPrice;
	});
	setValueById('ProAmt',parseFloat(ProAmt).toFixed(2));	
	setValueById('RefundAmt',parseFloat(refundAmt).toFixed(2));
	setValueById('ProSaleAmt',parseFloat(ProSaleAmt).toFixed(2));
}
function refund_Click(){
	$.m({
		ClassName: 'BILL.PKG.BL.RefundBill',
		MethodName: 'CheckPackageFlag',
		PackageDR: GV.PACKAGEID
	}, function (rtn) {
		if(getValueById('RefundAmt')!='0'&&rtn=='0'){
			$("#paymWin").show();
			$("#paymWin").dialog({
				iconCls: 'icon-w-inv',
				title: '订购',
				draggable: false,
				modal: true,
				onBeforeOpen: function() {
					$("#paymWin").form("clear");
					setValueById("winTotalAmt", getValueById('ProAmt'));
					setValueById("winRefundAmt", getValueById('RefundAmt'));
					setValueById("winDiscAmt", '0.00');
					initPaymWinMenu();
					initPayMList();
				}
			});
		}else{
			$.messager.alert('提示', "此套餐不允许退费", 'info');
		}
	});	
}
/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("btn-ReadCard");
			$("#cardNo").attr("readOnly", false);
			focusById("cardNo");
		} else {
			enableById("btn-ReadCard");
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
			focusById("btn-ReadCard");
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-ReadCard").linkbutton("options").disabled) {
		return;
	}
	try {
		var cardType = getValueById("cardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatDetail(myAry[4]);
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-ReadCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatDetail(myAry[4]);
			break;
		default:
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("cardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("cardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var cardAccountRelation = cardTypeAry[24];
			var securityNo = "";
			var myRtn = "";
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")){
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "");
			}else {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("RegNo", myAry[5]);
				GV.PAPMI=myAry[4]
				getPatInfo();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 10);
				break;
			case "-201":
				setValueById("cardNo", myAry[1]);
				setValueById("RegNo", myAry[5]);
				GV.PAPMI=myAry[4]
				getPatInfo(myAry[4]);
				break;
			default:
			}
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}
