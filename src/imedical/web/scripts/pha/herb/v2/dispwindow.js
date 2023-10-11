/**
 * ����:	 ��ҩ������-��ҩ����
 * ��д��:	 MaYuqiang
 * ��д����: 2022-06-14
 */
var DispWinDialog = {
	callback: ""
}

function InitDispWinDialog(opts){	
	DispWinDialog.callback = opts.callback;
	$('#btnSelectWin').on('click', SelectWindow);
	InitWinDict();
	InitGridWindow();
}
		
//��ʼ��
function InitWinDict(){
	//��ʼ����ҩ����
	PHA.ComboBox("dispWindow", {
		url: PHA_HERB_STORE.WindowStore(gLocId).url,
		width: 200
	});
}

function InitGridWindow(){
	var columns = [
		[	
			{
				field: 'TPhwId',
				title: '����Id',
				align: 'center',
				hidden: true,
				width: 90
			}, {
				field: 'TPhwDesc',
				title: 'ҩ������',
				align: 'center',
				width: 200
			}, {
				field: 'TPhwState',
				title: '����״̬',
				align: 'center',
				width: 200,
				editor:{
					type:'switchbox',
					options:{
						onClass:'primary',
						offClass:'gray',
						onText:'����',
						offText:'����',
						onSwitchChange: function (e,obj) {
							if (obj.value == true){
								var state = "1"
							}
							else{
								var state = "0"
							}
							var selRowData = $('#gridDispWindow').datagrid('getSelected');
							var phwId = selRowData.TPhwId;
							var ret = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag", phwId, state, LogonInfo);
							if (ret == 0) {
								return true;
							} else if (ret == -11) {
								$.messager.alert('��ʾ',"��ȷ������һ������Ϊ����״̬!","info");
								return false;
							} else {
								$.messager.alert('��ʾ',"�޸Ĵ���״̬ʧ��,�������:" + ret,"info");
								return false;
							}
						}
					}
				}
			}
		]
	];
	var dataGridOption = {
		fit: true,
		rownumbers: false,
		columns: columns,
		nowrap:false ,
		pagination: false,
		//pageSize:100,
		//pageList:[100,300,500,999],
		singleSelect: true,
		fitcolumns: true,
		toolbar: gridDispWindowBar,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetWindowList"
		},
		onClickRow: function (index){
			EditRow();
		},
		onLoadSuccess: function () {
			
		}
	};
	PHA.Grid("gridDispWindow", dataGridOption);

}

function EditRow() {
	$('#gridDispWindow').datagrid('endEditing');
	var selRow = $('#gridDispWindow').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "����ѡ��Ҫ�༭�����ݣ�",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridDispWindow').datagrid('getRowIndex', selRow);
	$('#gridDispWindow').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
	

}

function InitDialogDispWin(){
	var title = "��ҩ����ѡ��"
	$('#diagDispWindow').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closable: false,
		isTopZindex:true ,
		width: 424,
		height: 300
	});
}
// �򿪴��ڽ���
function ShowWindowInfo() {
	InitDialogDispWin();
	$('#diagDispWindow').dialog('open');
	/* ���ؽ���֮���Զ�ִ�в�ѯ���ӳٲ�ѯ�����ⴰ�ڻ�û�򿪾�ִ�в�ѯ */
	setTimeout("QueryDispWindow()",200);
	
}

// ���ط�ҩ������Ϣ
function SelectWindow(){
	var windowId = $('#dispWindow').combobox('getValue') ;
	var windowDesc = $('#dispWindow').combobox('getText') ;
	if (windowId == ""){
		$.messager.alert('��ʾ',"����ѡ��ҩ����!","info");
		return;	
	}

	var param = {
		windowId: windowId,	
		windowDesc: windowDesc
	}
	if(DispWinDialog.callback){
		DispWinDialog.callback(param);	
	}
	$('#diagDispWindow').dialog('close');
}

function QueryDispWindow(){
	$('#gridDispWindow').datagrid('query', {
        phaLocId: gLocId
    });
}
