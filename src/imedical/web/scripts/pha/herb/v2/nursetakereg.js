/**
 * @ģ��:     ��ҩ������ʿ��ҩ�Ǽ�
 * @��д����: 2023-01-03
 * @��д��:   MaYuqiang
 * csp:pha.herb.v2.nursetakereg.csp
 * js: pha/herb/v2/nursetakereg.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "��ҩ����"
PHA_COM.App.Csp = "pha.herb.v2.nursetakereg.csp"
PHA_COM.App.Name = "��ҩ������ʿ��ҩ�Ǽ�"
var ComPropData;	// ��������
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var prescArr = []	// ��ɨ�봦��
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
$(function () {
	InitGridPrescList();
	InitSetDefVal();
	$('#btnExecuteReg').on('click', ExecuteReg);
	$('#btnClear').on('click', Clear);
	
	//�����Żس��¼�
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				AddPrescInfo(prescNo);
				//ExecuteScan(prescNo)
			}	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	//��������	
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
	}, false)
}
	
	/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 120,
				hidden:false
			}, {
				field: 'TOrdLocDesc',
				title: '��������',
				align: 'left',
				width: 120,
				hidden: false
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100
			}, {
				field: 'TPatName',
				title: '��������',
				align: 'left',
				width: 100,
				hidden:false
			}, {
				field: 'TPatSex',
				title: '�����Ա�',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TPrescFac',
				title: '����',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TInstruc',
				title: '�÷�',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TDispUser',
				title: '��ҩ��',
				align: 'left',
				width: 100,
				hidden:false
			}, {
				field: 'TDispDate',
				title: '��ҩ����',
				align: 'left',
				width: 200,
				hidden:false
			}, {
				field: 'TPhbdId',
				title: 'ҵ������Id',
				align: 'left',
				width: 70,
				hidden:true
			}
			
		]
	];
	
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		exportXls: false,
		pagination: false,
		singleSelect: false,
		url: $URL
	};
	PHA.Grid("gridPrescList", dataGridOption);
}

/// ����ִ����ȡ����
function ExecuteReg(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ҩ�ǼǵĴ���!","info");
		return;
	}
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('��ʾ',"��ҩ�˹��Ų���Ϊ��!","info");
		return;	
	}

	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId + tmpSplit + UserCode ;
		var ret = $.m({
			ClassName: "PHA.HERB.NurseTakeReg.Biz",
			MethodName: "ExecuteReg",
			params: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] == 0) {

		}
		else {
			$.messager.alert('��ʾ', prescNo + retArr[1], 'warning');
			return;
		}
	}
	Clear();
}

/**
 * ��ҩ����״ִ̬�� ɨ����
 * @method AddPrescInfo
 */
function AddPrescInfo(prescNo){	
	var jsonData = $.cm({
			ClassName: "PHA.HERB.NurseTakeReg.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			LogonInfo: LogonInfo,
			dataType: 'json'
		}, false);
	
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert',
			timeout: 2000
		});
		return;
	}
	
	var prescNo = jsonData.TPrescNo ;
	
	if ((prescArr.indexOf(prescNo)>-1)&&(prescArr.length>0)){
		PHA.Popover({
			showType: "show", 
			msg: "�ô����ڵ�ǰ�����Ѿ�ɨ���������ظ�ɨ�룡", 
			type: 'alert', 
			timeout:2000
		});
		return ;
	}
	else {
		prescArr.push(prescNo)	
	}	
	
	$('#gridPrescList').datagrid('insertRow', {
		index: 0,
		row: jsonData
	});
	
	$('#txtPrescNo').val('');	
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridPrescList').datagrid('clear');
	$('#gridPrescList').datagrid('uncheckAll');
	prescArr = []
}

