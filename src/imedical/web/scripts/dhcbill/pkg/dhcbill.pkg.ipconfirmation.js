/*
 * FileName:	dhcbill.pkg.ipconfirmation.js
 * User:		tangzf
 * Date:		2019-09-23
 * Function:	
 * Description: סԺ�ײ�ȷ��
 */
var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:'',
	editRowIndex:-1,
	FixFlag:'' ,//�Ƿ���й�����ۿ� 1 : �Ѿ����й�����ۿ�
	deleteStr:'', // ɾ��������ۿ۴�
	OrdExItms:{}  ,//ҽ��ִ�м�¼
	EditIndex: undefined,
	curRowIndex:-1,
    curRow:{},
    curVal:0.0,
    ed:{},
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
	init_CTLoc();
	initAdmList();
	
	//��ʼ���ۿ۽��
	$('#DiscAmt').numberbox({
		precision:2,
		min:0
	})
	/*
	// �ײ����ۿ۽���¼� (ֻ��δ���й��ۿ۵Ĳſ��Բ���)
	if(GV.FixFlag!='1'){
		$("#DiscAmt").keyup(function(e){ 
			if(e.keyCode===13){
				calDatagridRate(this.value);	
			}
		
		})
		$('#DiscAmt').bind('change',function(){
				calDatagridRate(this.value);
	  		
		})
	}
	*/
	///init_DiscReason();
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
	
}
/*
 * 
 */
function init_dg() {
	var dgColumns = [[
			{field:'billTotalAmt',title:'���',width:150,align:'right'},
			{field:'billPashareAmt',title:'�Ը����',width:150,align:'right'},
			{field:'billQty',title:'�˵�����',width:100 },			
			{field:'Amt',title:'�Żݽ��',width:150 ,align:'right',
				/*editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}*/
			},
			{field:'execStDatTime',title:'Ҫ��ִ��ʱ��',width:220 },
			{field:'execDatTime',title:'ִ��ʱ��',width:220},
			{field:'execStatus',title:'ִ��״̬',width:150},
			{field:'billFlag',title:'�˵�״̬',width:150},
			{field:'ordItm',title:'ҽ��rowid',width:150},
			{field:'pboRowId',title:'�˵�ҽ��ID',width:150},
			{field:'oeore',title:'ִ�м�¼ID',width:220},
			{field:'itmCatDesc',title:'ҽ������',150:150},
			{field:'execUserName',title:'ִ����',width:150},
			{field:'recDeptName',title:'���տ���',width:150 },
			{field:'userDeptName',title:'��������',width:150},
			{field:'RemainingQty',title:'ʣ������',width:150},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true}
		]];
GV.OrdExItms=$HUI.datagrid("#dg",{
		//idField:'ordItm',
		//sortName:'ProductFlag',
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		pageSize: 80,
		pageList: [80, 120, 160, 200],
		columns: dgColumns,
		rownumbers: true,
		///pageList: [99999],
		frozenColumns: [[
							{title: 'ck', field: 'ck', checkbox: true,
								styler:function(value,row,index){
									return true
								}
							},
							{field:'arcimDesc',title:'ҽ����',width:220},
							{field:'ProductFlag',title:'�ײͱ�ʶ',width:80,
								formatter:function(value,data,row){
									value=='1'?value='�ײ���':value='�ײ���';
									return value;
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}			
							},
							{
								field:'FixFlag',title:'�ۿ۱�־',width:80,
								formatter:function(value,data,row){
									if(value=='1') {
										if(GV.deleteStr==''){
											GV.deleteStr=data.FixSubRowId;
											GV.FixFlag='1';	
										}else{
											GV.deleteStr=GV.deleteStr+'^'+data.FixSubRowId;
										}
									}else{
											GV.FixFlag='';	
										}
									value=='1'?value='���ۿ�':value='δ�ۿ�';
									return value;
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}
							},
							{field:'NoDisFag',title:'�ɷ����',width:60,
								formatter:function(value,data,row){
									value=='1'?value='��':value='��';
									return value;
								},
								styler:function(value,row,index){
									return value=='0'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}}
						]],					
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			data.rows.length>0?GV.BILL=data.rows[0].pboRowId.split('||')[0]:'';
		},
		onSelect:function(index,rowData){
	
		},
		
	    onBeginEdit: function (index, row) {
			   //OrdExBeginEdit(index, row);
    	},
		onAfterEdit:function(rowIndex, rowData, changes){
			//OrdExAfterEdit(rowIndex, rowData, changes);
			
		},
		onCheck:function(index,rowData){
		},
		onUncheck:function(index,rowData){
			//clearDatagridDiscrate(index,rowData);
		}
		,
	    onClickCell: function (index, field, value) {
			   //OrdExEditCell(index, field, value);
		},
		
		
		
	});
}

function initLoadGrid(){
	var queryParam={
		ClassName:'BILL.PKG.BL.PackageConfirmation',
		QueryName:'FindProOrdDetail',
		episodeId:GV.ADM,
		userDeptId:getValueById('CTLoc'),
		billStatus:'',
	}
	loadDataGridStore('dg',queryParam);		
	GV.OrdExItms=$HUI.datagrid("#dg");
}

/*
 * ����
 */
$('#BtnClear').bind('click', function () {
	clear_Click();	
})
function clear_Click(){
	GV={
		ADM:'',
		BILL:'',
		PAPMI:'',
		PACKAGEID:'',
		editRowIndex:-1,
		FixFlag:'' ,
		deleteStr:'' ,
	    OrdExItms:{}  ,//ҽ��ִ�м�¼
	    EditIndex: undefined,
	    curRowIndex:-1,
        curRow:{},
        curVal:0.0,
        ed:{},
	}
	refreshBar('','');
	$("#searchTable").form("clear");
	initLoadGrid();	
}
/*
 * ȡ��
 */
$('#BtnCancel').bind('click', function () {
		$.messager.confirm('ȷ��', '��ȷ����Ҫȡ��ȫ��ƥ���������', function (r) {
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
})
/*
 * �޸��ײ�
 */
$('#BtnUpdate').bind('click', function () {
	var OEOREStr=getOEOREStr();
	if(OEOREStr!=''){
		$.m({
			ClassName: "BILL.PKG.BL.PackageConfirmation",
			MethodName: "UpdateOrdExecByExeStr",
			OEExcStr:OEOREStr,
			Guser:PUBLIC_CONSTANT.SESSION.USERID,
		},function(rtn){
			if(rtn.split('^')[0]==='0'){
				$.messager.alert('��ʾ','����ɹ�','info',function(){
				});
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn.split('^')[1],'info');
			}
			initLoadGrid();

		})
	}else{
		$.messager.alert('��ʾ','û�и��µļ�¼','info');	
	}
});
/*
 * ����ۿ�
 */
$('#BtnSave').bind('click', function () {
	if(GV.FixFlag=='1'){
		$.messager.alert('��ʾ','�û����Ѿ����й�����ۿ�','info');
		return;
	}
	if(getValueById('DiscReason')==''){
		$.messager.alert('��ʾ','�������Ų���Ϊ��','info');
		return;
	}
	$.m({  
		ClassName: "BILL.PKG.BL.Flexiblediscount",
		MethodName: "FlexibleIPdiscountSave",
		AdmDr:GV.ADM,
		OrdStr:'',
		Acount:getValueById('OutPackageAmt'), 
		DiscRate:'', 
		DiscAcount:getValueById('DiscAmt'), 
		DiscReason:getValueById('DiscReason'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
		UserDr:PUBLIC_CONSTANT.SESSION.USERID
		},function(rtn){
			if(rtn.split('^')[0]==='0'){
				$.messager.alert('��ʾ','����ɹ�','info',function(){
					initLoadGrid();	
			});
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn.split('^')[1],'info');
			}
	})		
});
/*
 * ɾ������ۿ�
 */
$('#BtnDelete').bind('click', function () {
	dleteFlexDisClick();
});

$('#BtnFind').bind('click', function () {
	FindClick();
});
/*
 * ��ѯ
 */
function FindClick() {
	initLoadGrid();
	CheckPackage();
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
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GV.ADM, PUBLIC_CONSTANT.SESSION.USERID, GV.BILL, computerName);
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
/*
 * ���������˵�
 */
$('#BtnReBill').bind('click', function () {
	reBillClick();
});
/*
 * ���������˵�  
 */
function reBillClick() {
	if(GV.BILL == "") {
		$.messager.alert("�˵�", "δѡ���˵������������������˵�!",'info');
		return;
	}
	if(GV.ADM == "") {
		$.messager.alert('�˵�','��ѡ����','info');
		return;
	} else {
		var insuUpFlag=getInsuUpFlag();
		if(insuUpFlag == 1){
			$.messager.alert('��ʾ','�˵�ҽ�����ϴ�,���������������˵�!','info');
			return;
		}else if (insuUpFlag == 2){
			$.messager.alert('��ʾ','�˵�ҽ���ѽ���,���������������˵�!','info');
			return;			
		}
		var rebillnum = tkMakeServerCall("web.DHCIPBillCashier", "JudgeBabyDeposit", 	GV.ADM);
		if(rebillnum != ""){
			$.messager.alert('�˵�','Ӥ����δ����Ѻ��,�������������˵�����Ӥ��Ѻ��!','info');
			return;
		}
		var billNum = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", GV.ADM);
		if(billNum == 1) {
			_rebill();
		} else if (billNum >= 2) {
			$.messager.confirm("ȷ��", "��������������δ������˵�,�Ƿ�ȷ�����������˵�?", function(r) {
				if(r) {
					_rebill();
				} else {
					return;
				}
			});
		} else if (billNum == 0) {
			$.messager.alert("�˵�",  "δ�����˵���Ϊ0,��ȷ�ϸ�����¼�Ƿ��ѽ���.",'info')
			retur
		} else {
			$.messager.alert("�˵�",  "���������˵�ʧ��" + ",����ֵ��" + billNum,'info');
			return;
		}
	}
	
	function _rebill() {
		var rtn = tkMakeServerCall("web.UDHCJFREBILL", "REBILL", "", "", GV.ADM, GV.BILL, PUBLIC_CONSTANT.SESSION.USERID);
		if(rtn == 0) {
			$.messager.alert("�˵�", "���������˵��ɹ�.", "info", function() {
				initLoadGrid();
			});
		} else if(rtn == "ExtItmErr") {
			$.messager.alert("�˵�", "�˵���ִ�м�¼�и��ӵ��շ���Ŀ,�������������˵�.",'info');
			return;
		} else if(rtn == "BabyErr") {
			//$.messager.alert("�˵�", "ĸӤ�˵��ϲ�,��ѡ��ĸ���˵��������������˵�!");
			$.messager.alert("�˵�", "��ѡ��ĸ���˵��������������˵�!",'info');
			return;
		} else {	
			$.messager.alert("�˵�", "���������˵�ʧ��.",'info');
			return;
		}
	}
}
//��ȡҽ��������Ϣ
//����ֵ:
// 	1:ҽ�����ϴ���ϸ
// 	2:ҽ���ѽ���
// 	С��0:ҽ��δ����δ�ϴ�
function getInsuUpFlag(){
	var insuUpFlag = tkMakeServerCall("web.DHCIPBillCashier","JudgePBInsuUpFlag",GV.BILL,"");
	return insuUpFlag;
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
		columns: [[
				   {field: 'TadmDate',	title: '����ʱ��', width: 150},
				   {field: 'TadmLoc', title: '�������', width: 90},
				   {field: 'TadmWard', title: '���ﲡ��', width: 130},
				   {field: 'TdisDate', title: '��Ժʱ��', width: 150},
				   {field: "TadmId", title: "TadmId", width: 150}
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
			getAdmInfo();// ���ر�ͷ ������Ϣ
			CheckPackage();
		}
	});
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
 * ��ȡ���߻�����Ϣ
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
 * ��ȡ���߾�����Ϣ
 */
function getAdmInfo() {
	try
	{
		$.m({
			ClassName: 'BILL.PKG.BL.PackageConfirmation',
			MethodName: 'GetPatInfo',
			AdmDr: GV.ADM
		}, function (rtn) {
			var myAry = rtn.split('^');
			if (myAry[0]=='101') {
				$.messager.alert('��ʾ', '��ȡ������Ϣʧ��'+rtn, 'error');
			} else {
				setValueById('Deposit',parseFloat(myAry[5]).toFixed(2));
				setValueById('OutPackageAmt',parseFloat(myAry[8]).toFixed(2));
				setValueById('InPackageAmt',parseFloat(myAry[7]).toFixed(2));
				setValueById('PackageAmt',parseFloat(myAry[9]).toFixed(2));
			}
		});
	}
	catch (e)
	{
		$.messager.alert('�쳣������dhcbill.pkg.ipconfirmation.js��getAdmInfo', e,'error');
	}
}

/*
 * ��ȡִ�м�¼�� �޸��ײ�ʱʹ��
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
 * ����ۿ����
 *
 * ---------Start----------  
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}

/*
 * ͨ�����ʵ�ս�����datagrid�ۿ���
 * value ʵ�ս��
 */
function calDatagridRate(value){
	var OutTotal=parseFloat($('#OutPackageAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('��ʾ','ʵ�ս��ܴ����ܽ��','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	rate=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}

/*
 * ɾ���ۿ�
 */
function dleteFlexDisClick(){
	///alert(GV.ADM)
	$.messager.confirm('��ʾ','�Ƿ�ɾ������ۿۼ�¼��',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountIPDelete",
					AdmDr:GV.ADM,
					HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ','ɾ���ɹ�','info',function(){
							initLoadGrid();	
						});
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��:'+rtn.split('^')[1],'info');
						initLoadGrid();
					}
				})
				
			}		
		})				
}
/*
 * datagrid�ۿ۱����༭��س��¼�
 */
 /*
function datagridRateEnter(){
	$('td[field="DisRate"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//alert("GV.editRowIndex="+GV.editRowIndex)
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
	  		//var rowData=$('#dg').datagrid('getSelected');
	  		//setRowRate(this.value, GV.editRowIndex, rowData);
			//setValueById('DiscAmt','');
  		}
	})
	$('td[field="DisRate"] .datagrid-editable-input').bind('change',function(){
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
	  		//var rowData=$('#dg').datagrid('getSelected');
	  		//calcRowRate(this.value, GV.editRowIndex, rowData);
			//setValueById('DiscAmt','');
  		
	})
}*/
/*
 * datagridʵ�ս��༭��س��¼�
 */
 /*
function datagridAmtEnter(){
	$('td[field="Amt"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="Amt"] .datagrid-editable-input').bind('change',function(){
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/
/*
 * ����ʵ�ս����㵥��ҽ���ۿ���
 * amt ����ҽ��ʵ�ս��
 */
 /*
function calcRowRate(amt, index, rowData){
	var amt=parseFloat(amt);
	var OERDAmt=rowData.billTotalAmt;
	if(OERDAmt<amt){
		$.messager.alert('��ʾ','��д���ܴ���ҽ�����','info');
			HISUIDataGrid.setFieldValue('Amt', 0, index, 'dg');	
			HISUIDataGrid.setFieldValue('DisRate', 0, index, 'dg');
		}else{
			var rate=amt/parseFloat(OERDAmt);
			HISUIDataGrid.setFieldValue('DisRate',parseFloat(rate).toFixed(4), index, 'dg');
		}
}*/
/*
 * ���ݵ���ҽ���ۿ��ʼ���ʵ�ս��
 * rate ����ҽ���ۿ���
 */
 /*
function setRowRate(rate,index,rowData){
	var amt=rowData.billTotalAmt * rate;
	//alert("amt="+amt)
	HISUIDataGrid.setFieldValue('DiscAmt', rate, index, 'dg');	
	HISUIDataGrid.setFieldValue('Amt', parseFloat(amt).toFixed(2), index, 'dg');
	//alert("rate="+rate)	
	$('#dg').datagrid('endEdit', GV.editRowIndex);
}*/

/*
 * ��дdatagrid�ۿ���
 * rate : �ۿ���
 */
function setDatagridRate(rate){
	var eachRowobj=$('#dg').datagrid('getData'); 
	for(var index=0;index<eachRowobj.total;index++){
		if((eachRowobj.rows[index].ProductFlag=='0')&&(eachRowobj.rows[index].NoDisFag=='1')){ // ֻ���ײ���ſ���ʹ���ۿ���
			rate=parseFloat(rate).toFixed(4);
			HISUIDataGrid.setFieldValue('DisRate', parseFloat(rate).toFixed(4), index, 'dg');
			var amt=eachRowobj.rows[index].billTotalAmt * rate;
			HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
			$('#dg').datagrid('checkRow',index);
		}
	}	
}
/*
 * ����datagrid�ۿ���
 * value ʵ�ս��
 * ����ʵ�ս����ײ���ҽ���������ۿ���
 */

function calDatagridRate(value){
	var OutTotal=parseFloat($('#OutPackageAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('��ʾ','ʵ�ս��ܴ����ײ���ҽ�����','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
 /*
 * datagrid ��ʼ��һ�б༭��������һ�б༭
 * index ��Ҫ�༭���к�
 */ 
/*
function datagridEditRow(index,rowData){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	if(rowData.ProductFlag=='1'||rowData.ordCateType=='R'){return;} // �ײ��ڲ��ܱ༭
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
*/
/*
 * ����ۿ����
 *
 * ---------End----------  
 */
/*
 * ȡ����ѡ���datagrid�ۿ���
 */
function clearDatagridDiscrate(index,rowData){
	if (rowData.ProductFlag!='1'&&GV.FixFlag!='1'){ // �ײ��� δ���й��ۿ�
		HISUIDataGrid.setFieldValue('DisRate', '', index, 'dg');
		HISUIDataGrid.setFieldValue('Amt','', index, 'dg');
	}

}
/*
*	��ʾ�ײ��Ƿ���
*/
function CheckPackage()
{
	try
	{
		$.m({
			ClassName: 'BILL.PKG.BL.PackageConfirmation',
			MethodName: 'GetPatInfo',
			AdmDr: GV.ADM
		}, function (rtn) {
			var myAry = rtn.split('^');
			if (myAry[0]=='101') {
				$.messager.alert('��ʾ', '��ȡ������Ϣʧ��'+rtn, 'error');
			} else {
				var TnTotal = parseFloat(myAry[9]);
				var TnShare = parseFloat(myAry[7]);
				if (TnShare<TnTotal){
					$.messager.alert('��ʾ',"����ҽ���ܶ"+TnShare+"С���ײ��ۼۣ�"+TnTotal+"��������ʹ���ײ�",'info');
				}

			}
		});
	}
	catch (e)
	{
		$.messager.alert('�쳣������dhcbill.pkg.ipconfirmation.js��getAdmInfo', e,'error');
	}
}






/**
* ҽ��ִ�м�¼��Ԫ��༭
*/
function OrdExEditCell(index, field, value) {
	GV.OrdExItms.selectRow(index);   //ѡ���趨��
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.OrdExItms.editCell({
			index: index,
			field: field
		});
		var ed = GV.OrdExItms.getEditor({
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
	}
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.OrdExItms.validateRow(GV.EditIndex)) {
		GV.OrdExItms.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}


/**
* ��Ԫ���Ƿ�ɱ༭
* true: �ɱ༭, false: ���ɱ༭ ,,
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.OrdExItms.getRows()[index];
	if ((field != "DisRate") && (field != "Amt")) {
	
			return false;
		
	}
	
	if((row.NoDisFag==0)||(row.NoDisFag=="��")){
		return false
		}
	if(row.ProductFlag=='1'||row.ordCateType=='R')	{
		
			return false
		}
	return true;
}

/**
*��ʼ�༭
*/
function OrdExBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowAmtEnter(index, row);
     
}

/**
* �����༭
*/
function OrdExAfterEdit(index, rowData, changes) {
	GV.OrdExItms.endEdit(index);
	GV.EditIndex = undefined;
	//CalcSalesAmt();
}


/**
*��ֵת��
*/	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}

/**
*��Ԫ��-�����ۿ��ʼ���ʵ�ս��
*/
function RowDisRateEnter(index, row)
{
	var ed = GV.OrdExItms.getEditor({index: index, field: "DisRate"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowDisRateEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowDisRateEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowDisRateEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PashareAmt=toNumber(row.billPashareAmt)
	 if (newVal=="") return ;
	 if (toNumber(newVal) > 1)
             {
               $.messager.alert('��ʾ', '��д�ۿ��ʲ��ܴ��� 1', 'error',function() {
	           $(ed.target).numberbox("setValue", 1);
				GV.OrdExItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	              var SalesAmount = toNumber(newVal) *  PashareAmt 
		        	if (PashareAmt <SalesAmount)
		       		 {
			        
			          	 $.messager.alert('��ʾ', 'ʵ�ս��ܴ����Ը���'+TotalAmt, 'error',function() {
			              $(ed.target).numberbox("setValue", 1);
			              GV.OrdExItms.endEdit(index);
				          GV.EditIndex = undefined;
				          //calcRowOrdExAmt(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('Amt', SalesAmount.toFixed(2), index, 'dg');
				         GV.OrdExItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				     }
	             }
	
}






/**
*��Ԫ��-����ʵ�ս������ۿ���
*/
function RowAmtEnter(index, row)
{
	var ed = GV.OrdExItms.getEditor({index: index, field: "Amt"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowAmtEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowAmtEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowAmtEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PashareAmt=toNumber(row.billPashareAmt)
	if (newVal=="") return ;
	 if (toNumber(newVal) > PashareAmt)
             {
               $.messager.alert('��ʾ', '��дʵ�ս��ܴ����Ը����', 'error',function() {
	           $(ed.target).numberbox("setValue", PashareAmt);
				GV.OrdExItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	                     var DisRate = toNumber(newVal) / PashareAmt 
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dg');
				         GV.OrdExItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				    
	             }
	
}

/*
 * סԺ����ۿ�
 */
$('#FlexButton').bind('click', function () {
	FlexButton_Click();	
})

function FlexButton_Click()
{
	var patNo = getValueById('RegNo');
	var str="&patNo="+patNo+"&AdmDr="+GV.ADM;
    var lnk = 'dhcbill.pkg.ipflexiblediscount.csp?'+str;
	var nwin = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no,titlebar=no,left=' + 0 + ',top=' + 0;
	websys_showModal({
		width: '90%',
		height: '90%',
		iconCls: 'icon-w-find',
		title: 'סԺ���ִ���' ,
		url:encodeURI(lnk) ,
		onClose: function (){
			ClrDocWin(myAdmstr, "");
			var FixRowID=top.window.returnValue;
			document.getElementById("FixRowID").value=FixRowID;
		}
	});
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