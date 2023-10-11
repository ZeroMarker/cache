/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: ȫ��Ԥ�����-Ԥ����ƹ���-��ڿ������Ԥ�����
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */
 
//ȫ�ֱ�������checkbox״̬�仯
var isLast = 1;

//���ѡ���¼�
var YearSelect = function () {
	$('#schemcb').combobox('clear');
	$('#schemcb').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&ResultSetType=array');
	Search();
}

//�����������ʼ��
function schemBefLoad(param) {
	param.str = param.q;
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = 2;
	param.year = $('#yearcb').combobox('getValue');
}

//�����������ʼ��
function deptBefLoad(param) {
	param.str = param.q;
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = 1;
	param.year = $('#yearcb').combobox('getValue');
	param.audept = '';
	param.schemedr = '';
}


MainColumns = [[{
			field: 'Rowid',
			title: '�������ID',
			//halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'CompName',
			title: 'ҽ�Ƶ�λ',
			//halign: 'center',
			width: 200,
			hidden: true
		}, {
			field: 'Year',
			title: '���',
			//halign: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'SchemId',
			title: '����ID',
			//halign: 'center',
			width: 100,
			hidden: true
		}, {
			field: 'Code',
			title: '�������',
			halign: 'center',
			width: 100
		}, {
			field: 'Name',
			title: '��������',
			//halign: 'center',
			width: 150
		}, {
			field: 'ObjDeptId',
			title: '�������ÿ���ID',
			halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'ObjDeptNa',
			title: '�������ÿ���',
			//halign: 'center',
			width: 120
		}, {
			field: 'OrderBy',
			title: '����˳��',
			halign: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'ItemName',
			title: '���Ԥ����',
			//halign: 'center',
			width: 100
		}, {
			field: 'IsHelpEdit',
			title: '�Ƿ����',
			halign: 'center',
			align: 'center',
			width: 80,
			formatter: isChecked
		}, {
			field: 'CHKFlowDR',
			title: '����������ID',
			halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'ChkFlowName',
			title: '����������',
			//halign: 'center',
			width: 120
		}, {
			field: 'File',
			title: '����',
			halign: 'center',
			width: 50
		}, {
			field: 'ChkStep',
			title: '���Ʋ���',
			//halign: 'center',
			align: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'StateDesc',
			title: '����״̬',
			halign: 'center',
			width: 80,
			align: 'center',
			hidden: true
		}, {
			field: 'IsTwoUpDown',
			title: '��������ģʽ',
			//halign: 'center',
			align: 'center',
			width: 100,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '��'
						}, {
							rowid: '0',
							name: '��'
						}
					]
				}
			}
		}, {
			field: 'IsEconItem',
			title: '���ÿ�Ŀģʽ',
			//halign: 'center',
			align: 'center',
			width: 100,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '��'
						}, {
							rowid: '0',
							name: '��'
						}
					]
				}
			}

		}
	]];

var schemGridObj = $HUI.datagrid("#schemGrid", {
		title: '����Ԥ����Ʒ���',
		headerCls: 'panel-header-gray',
		url: $URL,
		loadMsg: "���ڼ��أ����Եȡ�",
		autoRowHeight: true,
		rownumbers: true, //�к�
		singleSelect: true, //ֻ����ѡ��һ��
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
		pagination: true, //��ҳ
		fit: true,
		columns: MainColumns,
		onClickCell: function (index, field, value) {
			var rows = $('#schemGrid').datagrid('getRows');
			var row = rows[index];
			if (field == 'StateDesc') {
				schemastatefun(rows[index].rowid, userid, rows[index].SchemId);
			}
		},
		onClickRow: function (index, row) {
			//���¼���Ԥ����Ŀ������
			$('#itemcb').combobox('clear');
			$('#itemcb').combobox('reload',
				$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
				 + '&year=' + row.Year);

			$('#LowerPartGrid').datagrid('load', {
				ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
				MethodName: "ListDetail",
				hospid: hospid,
				userid: userid,
				schemAuditId: row.Rowid,
				itemTyCode: $('#typecb').combobox('getValue'),
				itemcode: $('#itemcb').combobox('getValue'),
				isLast: isLast
			});
		},
		toolbar: '#tb'
	});
// ��ѯ����
function Search() {

	schemGridObj.load({
		ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
		MethodName: "List",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		schemId: $('#schemcb').combobox('getValue'),
		detpId: $('#deptcb').combobox('getValue'),
		deptIsBudg: $('#deptIsBudg').combobox('getValue')
	})
}

// �����ѯ��ť
$("#FindBn").click(Search);
