/*
 * FileName:	dhcbill.pkg.refundbill.js
 * User:		TianZJ/tangzf
 * Date:		2019-09-23
 * Function:	
 * Description: �����ײ�ȷ�� �ý���Ҳ���Խ�������ۿ۲���
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
	//�ǼǺŻس���ѯ�¼�
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event)
  		}
	})
	//���Żس���ѯ�¼�
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	//����
	$HUI.linkbutton("#btn-ReadCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	setValueById('RefundAmt','0.00');
	setValueById('ProAmt','0.00');
	//������
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
// ����
$HUI.linkbutton("#btn-Clear", {
	onClick: function () {
		clearClick();
	}
});
// �˷�
$HUI.linkbutton("#btn-Refund", {
	onClick: function () {
		refund_Click();
	}
});
/*
 * ��ʼ��Dg
 */
function init_dg(){
	var dgColumns = [[
			{field:'ProDesc',title:'�ײ�����',width:150},
			{field:'ArcDesc',title:'ҽ����',width:200},
			{field:'Quantity',title:'��������',width:80},
			{field:'PatStatus',title:'�ײ�״̬',width:80,
				styler:function(value,row,index){
					return value=='��ʹ��'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				},
			},
			{field:'RefundAtm',title:'�˷ѽ��',width:100,align:'right',
				formatter:function(value,rowData,index){
					return parseFloat(value).toFixed(2);
				}	
			},
			{field:'RemainingQty',title:'�˷�����',width:100},
			{field:'ProSalesPrice',title:'�ײ��ۼ�',width:100,align:'right'},
			{field:'PriceperUnit',title:'����',width:100,align:'right'},
			{field:'TotalAmount',title:'�ܽ��',width:100,align:'right'},
			{field:'DiscPrice',title:'�ۿ۵���',width:100,align:'right'},
			{field:'DiscAmount',title:'�ۿ��ܶ�',width:100,align:'right'},
			{field:'PatsharePrice',title:'�Ը�����',width:100,align:'right'},
			{field:'PatshareAmount',title:'�Ը��ܶ�',width:100,align:'right'},
			{field:'ProCreatDate',title:'��������',width:100},
			{field:'ProCreateTime',title:'����ʱ��',width:100},
			{field:'ProUser',title:'������',width:150},
			{field:'ValidstartDate',title:'��ʼ����',width:150},
			{field:'ValidendDate',title:'��������',width:150},
			{field:'OrdRowId',title:'ҽ��dr',width:150,},
			{field:'OrdExcRowId',title:'ִ�м�¼dr',width:150},
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
 * ����dg
 */
function initLoadGrid(){
	if(GV.ADMTYPE==''){
		$.messager.alert('��ʾ','���������Ϊ��','info');	
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
 * �ǼǺŻس�
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
			$.messager.alert('��ʾ', '�ǼǺŴ���', 'error');
		} else {
			GV.PAPMI=myAry[1];
			refreshBar(GV.PAPMI,'');
			init_Package();
		}
	});
}

/*
 * �ײͲ�Ʒ��Ϣ
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
			{field:"ProDesc",title:"�ײ�����",width:100},
			{field:"ProRefundStandard",title:"�˷ѱ�׼",width:80},
			{field:"ProIsshare",title:"�Ƿ���",width:80},
			{field:"ProIndependentpricing",title:"��������",width:80,
				formatter:function(value,rowData,index){
					return value==0?value="��":value="��";
				}
			},
			{field:"ProSalesPrice",title:"�ۼ�",width:100,align:'right'},
			{field:"ProPrice",title:"��׼�۸�",width:100,align:'right'},
			{field:"PatProRowId",title:"�ͻ��ײ�ROWID",width:100,hidden:true},

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
 * ��ʼ��Dg
 */
 function init_AdmType(){
	$HUI.combobox('#AdmType',{
		valueField: 'value',
		textField: 'text',
		data: [{value: 'OP', text: '����', selected: true},
			   {value: 'EP', text: '����'},
			   {value: 'PE', text: '���'},
			   {value: 'IP', text: 'סԺ'}
		],
		onSelect: function (record) {
			GV.ADMTYPE=record.value;
		},		
	})
}
/*
 * �����˷���Ϣ
 */
function calRefundAmt(data){
	var refundAmt=0; 	// �˷ѽ��
	var ProAmt=0; // ��Ʒ���
	var ProSaleAmt=0; // �ײ��ۼ�
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
				title: '����',
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
			$.messager.alert('��ʾ', "���ײͲ������˷�", 'info');
		}
	});	
}
/**
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
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
 * ����
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
			$.messager.alert("��ʾ", "����Ч", "info", function () {
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
					$.messager.alert("��ʾ", "����Ч", "info", function () {
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
