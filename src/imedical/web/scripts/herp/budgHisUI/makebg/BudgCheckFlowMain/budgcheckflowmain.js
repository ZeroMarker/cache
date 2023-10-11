/*
Creator: zhouwenjie
CreatDate: 2018-11-21
Description: ȫ��Ԥ�����-������Ϣά��-������
CSPName: herp.budg.hisui.budgcheckflowain.csp
ClassName: herp.budg.hisui.udata.uBudgCheckFlow,
herp.budg.hisui.udata.uBudgCheckFlowMain,
herp.budg.hisui.udata.uBudgCheckFlowDetail,
 */
var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
 
 $(function(){//��ʼ��
    Initmain();
}); 
function Initmain(){
	MainColumns=[[{
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'compNa',
			title: 'ҽ�Ƶ�λ',
			halign: 'center',
			hidden: true
		}, {
			field: 'code',
			title: '����',
			halign: 'center',
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'name',
			title: '����',
			halign: 'center',
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'sysno',
			title: '����ģ��',
			halign: 'center',
			allowBlank: false,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					required: true,
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '��Ŀ֧��'
						}, {
							rowid: '2',
							name: 'Ԥ�����'
						},{
							rowid: '3',
							name: 'һ��֧��'
						}, {
							rowid: '4',
							name: '��Ŀ����'
						}
					]}}
}]]
	
//���Ӱ�ť
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '����',
	handler: function () {
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{rowid: '',compNa: '',code: '',name: '',sysno: ''}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}
	}
}

//���水ť
var SaveBtn = {
	id: 'Save',
	iconCls: 'icon-save',
	text: '����',
	handler: function () {
		Save();
	}
}

//ɾ����ť
var DelBtn = {
	id: 'Del',
	iconCls: 'icon-cancel',
	text: 'ɾ��',
	handler: function () {
		Del();
	}
}
var mainGridObj = $HUI.datagrid('#MainGrid', {
		fit: true,
		url: $URL,
		loadMsg:"���ڼ��أ����Եȡ�",
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'List',
			groupid:groupid,
			hospid: hospid,
			userid: userid
		},
		columns: MainColumns, 
        onClickRow:onClickRow,
		fitColumns:true,
		singleSelect:true,
		rownumbers: true, //�к�
		pagination: true, //��ҳ
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn]  //AutoAddBtn, 
	});
	
        var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickRow(index){
	        $('#MainGrid').datagrid('endEdit', editIndex);
	        var row = $('#MainGrid').datagrid('getSelected');
	        $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgCheckFlow",
                MethodName:"ListDetail",
                hospid: hospid,
                userid: userid,
                checkmainid: row.rowid
            });
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex)}
			}}
			
//����ǰУ��
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined)) {
						var info = title + "��Ϊ���������Ϊ�գ�";
						$.messager.popover({
							msg: info,
							type: 'info',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 1
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}
			
			
//���淽��
function Save() {
	var grid = $('#MainGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "";
	if (rows.length > 0) {
		$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function (t) {
			if (t) {
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + '^' + hospid
							 + '^' + row.code
							 + '^' + row.name
							 + '^' + row.sysno;
						if (mainData == "") {
							mainData = tempdata;
						} else {
							mainData = mainData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				if (flag == 1) {
					DoSave(mainData);
				}
				grid.datagrid("reload");
				$('#DetailGrid').datagrid("reload");
			}
		})
	}
}

//���������̨����
var DoSave = function (mainData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
		MethodName: 'Save',
		mainData: mainData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '��ӳɹ���',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '���ʧ�ܣ�' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 1
				}
			});
		}
	});
}

var mainData = ""
//ɾ������	
function Del() {
	var row = $('#MainGrid').datagrid("getSelected");
	var rowDetail = $('#DetailGrid').datagrid('getRows').length;
	
	if((rowDetail>0)&&(row.rowid>0)){
		$.messager.popover({
			msg: '�������ϸ������ɾ����',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 1
			}
		});
		return;

		}
	if (row.length == 0) {
		$.messager.popover({
			msg: '��ѡ��Ҫɾ���ļ�¼��',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 1
			}
		});
		return;
	}
	$.messager.confirm('ȷ��', 'ȷ��Ҫɾ��ѡ����������', function (t) {
		    if (t) {
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//��������ɾ��
		            editIndex= $('#MainGrid').datagrid('getRows').length-1;
					$('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					return;
					}		
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
				MethodName: 'Del',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: 'ɾ���ɹ���',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 1
						}
					});
				} else {
					$.messager.popover({
						msg: 'ɾ��ʧ�ܣ�' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 1
						}
					});
				}
			});
			$('#MainGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
			$('#MainGrid').datagrid("reload");
			$('#DetailGrid').datagrid("reload");
		}
	)
}
	
	}
