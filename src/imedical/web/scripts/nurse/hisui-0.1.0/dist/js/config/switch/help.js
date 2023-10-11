/*
 * @Descripttion: ҳ�����
 * @Author: yaojining
 */
var GLOBAL = {
	ClassName: 'NurMp.Service.Switch.Config',
	EditGrid: '#gridHelp'
};

function initUI() {
	loadHelpGrid();
	listenEvent();
}
$(initUI);

/**
 * @description ������Ȩ�б�
 */
function loadHelpGrid() {
	if (Page == 'DischAuth') {
		var data1 = [{
			Desc: '�����鵵����',
			Remark: '���ú󲡰��鵵���ƻ�ʿ�Գ�Ժ�����Ĳ�������Ҫ����������Ȩ����׼��Ĭ�ϻ�ʿ�ύ�鵵�󣬲������ٲ����ó�Ժ�������Զ���ڵ���ƿ��������ƽӿ�����������������ӿڡ������鵵���Ʒ�Χ���������������µ���Ѫ�ǵ�������ͼ'
		}, {
			Desc: '��Ժ��������',
			Remark: '���ú󳬳���Ժ�������Ƴ�Ժ����Ȩ�ޣ���Ҫ����������Ȩ����Ժ��������Ĭ��һ����'
		}, {
			Desc: 'Ȩ�޿���',
			Remark: 'ѡ��ͬ��Ժ�������͵Ŀ���Ȩ�ޣ���ѡ�ܵ����Ƶ�Ȩ�ޣ�����Ȩ��Ĭ�Ϸſ������ܳ�Ժ����'
		}, {
			Desc: '��Ժ��������ģʽ',
			Remark: '��Ժ������������Ȩģʽ�������֣�����͵�ʱ��㡣��ʱ�����Ҫѡ��������Ȩ��ĳ����ĳʱ���µ�����������ǳ�Ժ���ߵ�����������������'
		}, {
			Desc: '�����鵵���Ƴ�Ժ������Ȩ',
			Remark: '���ú�����Ȩǰ��Ҫ���жϳ�Ժ�����Ĳ����鵵�����Ƿ�������Ȩ��Ĭ�ϲ�����Ŀ��������Ȩ���Զ���ڵ���ƿ��������ƽӿ�����������������ӿ�'
		}, {
			Desc: '���ͺ�ģʽ�Ĵ������',
			Remark: 'V���鿴�� �޸ģ�S�� �½���N�� ���ϣ�C�� ɾ����D�� ��ӡ��P�� ����ִ�У�U�����壺whole����ʱ��㣺singleTime'
		}];
		var data2 = [];
		var mark_filter = $('#sbSearch').searchbox('getValue');
		if (!!mark_filter) {
			$.each(data1, function(index, mark) {
				var desc = mark.Desc;
				if (desc.indexOf(mark_filter) > -1) {
					data2.push(mark);
				}
			});
		} else {
			data2 = data1;
		}
		$(GLOBAL.EditGrid).datagrid({
			columns: [[
				{ field: 'Desc', title: '������', width: 200, align: 'left' },
				{ field: 'Remark', title: '˵��', width: 550, align: 'left' }
			]],
			data: data2,
			singleSelect: true,
			nowrap: false
		});
	}else {
		var elements = parent.elementsToArray('.switchTable tr td, .form_table tr td');
		$cm({
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindRemarkList',
			Page: Page,
			Desc: $('#sbSearch').searchbox('getValue')
		}, function (data) {
			// console.log(data);
			var clone = new Object();
			var rows = new Array();
			var k = 0;
			$.each(elements, function (i, key) {
				$.each(data.rows, function (j, row) {
					if (key == row.Key) {
						rows[k] = row;
						k++;
						return true;
					}
				});
			});
			clone['rows'] = rows;
			clone['total'] = rows.length;
			clone['curPage'] = 1;
			// console.log(clone);
			$(GLOBAL.EditGrid).datagrid({
				columns: [[
					{ field: 'Desc', title: '������', width: 200, align: 'left' },
					{ field: 'Remark', title: '˵��', width: 550, align: 'left' },
					{ field: 'Key', title: '����', width: 200, hidden: false },
					{ field: 'ID', title: 'ID', width: 60, hidden: false },
				]],
				data: clone,
				singleSelect: true,
				nowrap: false,
				onClickRow: clickRow
			});
		});
	}
}

/**
 * @description: ���±�ע
 */
function updateRemark() {
	var items = getChanges();
    if (items.length == 0) {
        $.messager.popover({ msg: $g("û����Ҫ���µ����ݣ�"), type: "info" });
        return;
    }
	var params = new Array();
	$.each(items, function(index, item) {
		var param = new Object();
		param['RowID'] = item.ID;
		param['SIRemark'] = item.Remark;
		params.push(param);
	});
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CT.NUR.EMR.SettingsItem',
        Param: JSON.stringify(params)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: result.msg, type: "success" });
			accept();
            $(GLOBAL.EditGrid).datagrid('reload');
        } else {
            $.messager.popover({ msg: result.msg, type: "error" });
            return;
        }
    });
    
}

/**
 * @description: �¼�
 */
function listenEvent() {
	$('#sbSearch').searchbox("textbox").keydown(function (e) {
		if (e.keyCode == 13) {
			$("#btnSearch").click();
		}
	});
	$('.searchbox-button').bind('click', function () {
		$('#btnSearch').click();
	});
	$('#btnSearch').click(function (e) {
		loadHelpGrid();
	});
	$('#btnUpdate').click(function (e) {
		updateRemark();
	});
}