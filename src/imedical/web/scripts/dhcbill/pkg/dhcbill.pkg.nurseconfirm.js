/*
 * FileName:	dhcbill.pkg.nurseconfirm.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: ��ʿȷ���ײ�
 */
 
 var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:''
}

$(function () {
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event);
  		}
	})
	$('#MedicalNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		MedicalNoKeydown(event);
  		}
	})
	init_dg();
	init_ArcItm();
	init_ArcCat();
	init_CTLoc();
	initAdmList();
	setValueById('StartDate',getDefStDate(-31));
	setValueById('EndDate',getDefStDate(31));
});

function init_CTLoc(){
	// ��������
	$HUI.combobox('#CTLoc',{
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&desc=&gLoc=" + PUBLIC_CONSTANT.SESSION.CTLOCID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			initLoadGrid();
		},
		onChange: function (newValue, oldValue) {
		}		
	})	
	//���տ���
	$HUI.combobox('#recDep',{
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&desc=&gLoc=" + PUBLIC_CONSTANT.SESSION.CTLOCID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			initLoadGrid();
		},
		onChange: function (newValue, oldValue) {
		}		
	})		
	
}
function init_ArcItm(){
	$HUI.combobox("#ArcItm",{	
		valueField:'ItemDr',
		textField:'ItemDesc',
		url:$URL,
		onBeforeLoad:function(para){
			para.ClassName='BILL.PKG.BL.NoDiscountsConfig';
			para.QueryName='QueryNoDiscountsConfig';
	  		para.OrdCatDr='';
	  		para.OrdCatSubDr='';
	 		para.ArcItmDr='';
	 		para.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
	 		para.ResultSetType='Array';
		},	
		onLoadSuccess:function(){
				
		},
		onLoadError:function(err){

		},
		onSelect:function(rec){
			
		}	
	})
}
function init_ArcCat(){
	$HUI.combobox('#ArcCat',{
			valueField:'ordcatid',
			textField:'ordcat',
			url:$URL,
			defaultFilter:4,
			onBeforeLoad:function(param){
				param.ResultSetType='Array';
				param.ClassName='web.UDHCJFORDCHK';
				param.QueryName='ordcatlookup';	
			},
			onSelect:function(rec){
				initLoadGrid();
			}	
		
		
	})	
}
/*
 * ��ʿ�ײ�ȷ��Dg
 */
function init_dg() {
	var dgColumns = [[
			{field:'execDatTime',title:'ִ��ʱ��',width:220},
			{field:'billTotalAmt',title:'���',width:150,align:'right'},
			{field:'billQty',title:'�˵�����',width:100 },
			{field:'execStDatTime',title:'Ҫ��ִ��ʱ��',width:150 },
			{field:'execStatus',title:'ִ��״̬',width:150},
			{field:'billFlag',title:'�˵�״̬',width:150},
			{field:'ordItm',title:'ҽ��rowid',width:150},
			{field:'pboRowId',title:'�˵�ҽ��ID',width:150},
			{field:'oeore',title:'ִ�м�¼ID',width:220},
			{field:'itmCatDesc',title:'ҽ������',150:150},
			{field:'execUserName',title:'ִ����',width:150},
			{field:'recDeptName',title:'���տ���',width:150 },
			{field:'userDeptName',title:'��������',width:150},
			{field:'RemainingQty',title:'ʣ������',width:150}
		]];
	$('#dg').datagrid({
		//idField:'ordItm',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		///pageList: [9999],
		columns: dgColumns,
		frozenColumns: [[
							{title: 'ck', field: 'ck', checkbox: true},
							{field:'arcimDesc',title:'ҽ������',width:220},
							{field:'ProductFlag',title:'�ײͱ�ʶ',width:150,
								formatter:function(value,data,row){
									return  value=='1' ? value='�ײ���': '�ײ���';
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}
							},
						]],					
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
		},
		onCheck:function(index,rowData){
		},
		onCheckAll:function(data){
		}	
	});
}
/*
 * ����Datagrid
 */
function initLoadGrid(){
	var queryParam={
		ClassName:'BILL.PKG.BL.PackageConfirmation',
		QueryName:'FindProOrdDetail',
		episodeId:GV.ADM,
		itmCateId:getValueById('ArcCat'),
		arcimId:getValueById('ArcItm'),
		recDeptId:getValueById('recDep'),
		userDeptId:getValueById('CTLoc'),
		stDate:getValueById('StartDate'),
		endDate:getValueById('EndDate'),
		billStatus:''
	}
	loadDataGridStore('dg',queryParam);		
}
/*
 * ��ѯ
 */
$('#BtnFind').bind('click', function () {
	FindClick();
});
function FindClick() {
	initLoadGrid();
}

/*
 * ����
 */
$('#BtnClear').bind('click', function () {
	clear_Click();	
})
function clear_Click(){
	var GV={
		ADM:'',
		BILL:'',
		PAPMI:'',
		PACKAGEID:''
	}
	refreshBar('','');
	$("#searchTable").form("clear");
	initLoadGrid();	
}
/*
 * �޸�
 */
$('#BtnUpdate').bind('click', function () {
	var OEOREStr=getOEOREStr();
	if(OEOREStr==''){
		$.messager.alert('��ʾ','û�п��Ը��µ�����','info');	
		return;
	}
	$.m({
		ClassName: "BILL.PKG.BL.PackageConfirmation",
		MethodName: "UpdateOrdExecByExeStr",
		OEExcStr:OEOREStr, 
		Guser:PUBLIC_CONSTANT.SESSION.USERID, 
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
				$.messager.alert('��ʾ','ƥ��ɹ�','info');	
			}else{
				$.messager.alert('��ʾ','ƥ��ʧ��rtn='+rtn,'error');		
			}
			initLoadGrid();
	});

});
/*
 * �ײ�ȷ���Զ�ƥ��
 */
$('#BtnSave').bind('click', function () {
	$.messager.confirm('ȷ��','�Ƿ�����Զ�ƥ��?',function(r){
		if(r){
			$.m({
				ClassName: "BILL.PKG.BL.PackageConfirmation",
				MethodName: "AutoPackageConfirm",
				AdmDr:GV.ADM, 
				Guser:PUBLIC_CONSTANT.SESSION.USERID,
			}, function(rtn){
				if(rtn.split('^')[0]=='0'){
					$.messager.alert('��ʾ','ƥ��ɹ�','info');	
				}else{
					$.messager.alert('��ʾ','ƥ��ʧ��rtn='+rtn,'error');		
				}
				initLoadGrid();
			});		
		}	
	})			
});
/*
 * �ײ�ȡ���Զ�ƥ��
 */
$('#BtnCancel').bind('click', function () {
	$.messager.confirm('ȷ��', '��ȷ����Ҫȡ��ƥ���������', function (r) {
		if (r) {
			$.m({
				ClassName: "BILL.PKG.BL.PackageConfirmation",
				MethodName: "CancelAutoPackageConfirm",
				AdmDr:GV.ADM, 
				Guser:PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn.split('^')[0] == "0") {
					$.messager.alert('��ʾ', "ȡ���ɹ�", 'success',function(){	
					});
				} else {
					$.messager.alert('��ʾ', "ȡ��ʧ�ܣ�������룺" + rtn, 'error',function(){	
					});
				}
				initLoadGrid();
			});
		}
	});
});

$('#BtnFind').bind('click', function () {
	FindClick();
});


function FindClick() {
	initLoadGrid();
}
/*
 * �˵�
 */
$('#BtnBill').bind('click', function () {
	billClick();
});
/*
 * �˵�  
 */
function billClick() {
	if(GV.ADM === "") {
		$.messager.alert('�˵�','��ѡ������¼','info');
		return false;
	} else {
		var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getmotheradm", GV.ADM);
		if(rtn === "true") {
			$.messager.alert('�˵�', '�˲���ΪӤ�����������˵�.','info');
			return false;
		}
		var computerName = '';//getComputerName();
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GV.ADM, PUBLIC_CONSTANT.SESSION.HOSPID, GV.BILL, computerName);
		if(rtn == 0) {
			$.messager.alert('�˵�', '�˵��ɹ�', "info", function() {
				initLoadGrid();
			});
		} else if(rtn == "AdmNull") {
			$.messager.alert('�˵�', "����Ų���Ϊ��.",'info');
			return false;
		} else if(rtn == "PBNull") {
			$.messager.alert('�˵�', '�˵���Ϊ��,�˵�ʧ��.','info');
			return false;
		} else if(rtn == "OrdNull") {
			$.messager.alert('�˵�', '����û��ҽ��,�����˵�.','info');
			return false;
		} else if(rtn == "2") {
			$.messager.alert('�˵�', 'ͬʱ��������δ���˵�,���������˵�.','info');
			return false;
		} else {
			$.messager.alert('�˵�', '�˵�ʧ��.','info');
			return false;
		}
	}

	return true;
}
/**
* �����������ݱ��
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		idField: "TadmId",
		textField: "TadmLoc",
		columns: [[{field: "TadmId", title: "�����",width: 100}, 
				   {field: 'TadmDate',	title: '����ʱ��', width: 150},
				   {field: 'TadmLoc', title: '�������', width: 90},
				   {field: 'TadmWard', title: '���ﲡ��', width: 130},
				   {field: 'TdisDate', title: '��Ժʱ��', width: 150}
			]],
		onLoadSuccess:function(data) {
			var admGrid=$('#admList').combogrid('grid');
			if(admGrid.datagrid('getRows').length>0){
				admGrid.datagrid('selectRow',0)	
			}			
	    },
		onSelect: function (rowIndex, rowData) {
			GV.ADM=rowData.TadmId;
			initLoadGrid();
		}
	});
	loadAdmList();
}

/**
* ���ؾ����б�
*/
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "searchAdm",
		papmi: GV.PAPMI
	}
	loadComboGridStore("admList", queryParams);
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
			clear_Click();
			$(e.target).val(rtn);
			getPatInfo();
		});
	}
}
/*
 * ��ȡ������Ϣ
 */
function getPatInfo() {
	var patientNo = getValueById('RegNo');
	var MedicalNo = getValueById('MedicalNo');
	///alert("patientNo="+patientNo)
	$.m({
		ClassName: 'BILL.PKG.COM.PatInfo',
		MethodName: 'GetPatInfo',
		patNO: patientNo,
		Medical:MedicalNo
	}, function (rtn) {
		///alert("rtn="+rtn)
		var myAry = rtn.split('^');
		if (!myAry[0]) {
			GV.PAPMI='';
			$.messager.alert('��ʾ', '�ǼǺŴ���', 'error');
		} else {
			GV.PAPMI=myAry[0];
			setValueById('RegNo',myAry[1]);
			setValueById('MedicalNo',myAry[2]);
			refreshBar(GV.PAPMI,'');
			loadAdmList();
		}
	});
	/*
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
			loadAdmList();
		}
	});*/
}
/*
 * ��ȡ��ѡ��ִ�м�¼��
 */
function getOEOREStr(){
	var OEOREStr='';
	var selectRowData=$('#dg').datagrid('getChecked');
	$.each(selectRowData,function(index, row){
		OEOREStr==''?OEOREStr=row.oeore:OEOREStr=OEOREStr+'^'+row.oeore;
	})
	return OEOREStr;
}
/*
 * ��ʼ���ײ�
 */
function init_PackageDesc(){
	$HUI.combogrid('#PackageDesc',{
		panelWidth:500,   
	    editable:true,
	    panelHeight:300,  
      	fit: true,
     	pagination: true,
      	singleSelect: true,
      	multiple: false,
        onBeforeLoad:function(param){
	        param.ClassName='BILL.PKG.BL.Coupon';
	        param.QueryName='FindProductInfoByPatDr';
	        param.PatDr=GV.PAPMI;
		},
		url: $URL,
		idField: 'PatProRowId',
		textField: 'ProDesc',
		columns: [[
			{field:"ProDesc",title:"�ײ�����",width:100},
			{field:"ProRefundStandard",title:"�˷ѱ�׼",width:80},
			{field:"ProIndependentpricing",title:"�Ƿ���������",width:100,
				formatter:function(value,rowData,index){
					return value==0?value="��":value="��"
				}
			},
			{field:"ProSalesPrice",title:"�ۼ�",width:100,align:'right'},
			{field:"ProPrice",title:"��׼�۸�",width:100,align:'right'},
			{field:"PatProRowId",title:"�ͻ��ײ�ROWID",width:100,hidden:true},

		]],
		onSelect:function(index,rowData){
			GV.PACKAGEID=rowData.PatProRowId		    
		},
	})	
}
/*
 * סԺ�Żس�
 */
function MedicalNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PatMedicare = $(e.target).val();
		if (!PatMedicare) {
			return;
		}
		getPatInfo();
	}
}