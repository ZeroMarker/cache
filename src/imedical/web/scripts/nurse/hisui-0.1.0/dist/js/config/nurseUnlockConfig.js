/*
* @author: yaojining
* @discription: �������쳣������
* @date: 2019-12-29
*/
var GLOBAL = {
    ClassName: "NurMp.Template.Lock",
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ConfigTableName: 'Nur_IP_DHCNurEmrInfoMethod'
};

$(initUI);

function initUI() {
	initHosp(initPageDom);
}

function initPageDom() {
	initHosp();
    var toolbar = [{
        text: '����',
        iconCls: 'icon-unlock',
        handler: unlock
    }, '-', {
        text: '��ѯ����',
        iconCls: 'icon-search',
        handler: find
    }, '-', {
        text: '��ѯ�쳣',
        iconCls: 'icon-inv-search',
        handler: findAbnormal
    }];
    $HUI.datagrid('#unlockGrid', {
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: "getLockNew"
        },
        toolbar: toolbar,
        columns: [[
            { field: 'Item5', title: 'ģ������', width: 80},
            { field: 'Item1', title: 'ģ������', width: 200 },
            { field: 'Item6', title: 'ģ��ؼ��ֶ�', width: 220 },
            { field: 'Item2', title: 'ģ��ID', width: 300 },
            { field: 'Item4', title: '����ʱ��', width: 180 },
            { field: 'Item7', title: 'ģ���ʱ��', width: 150 },
			{ field: 'Item8', title: '�������', width: 150 },
			{ field: 'Item3', title: '���̺�', width: 100 },
        ]],
		rowStyler: function (rowIndex, rowData) {
			if (rowData.Item8 == '�쳣') {
				return 'color:red;';
			}
		},
        idField: 'id',
        rownumbers: true,
        singleSelect:true
    })
}

function unlock() {
    var record = $('#unlockGrid').datagrid('getSelected');
    if (!record) {
        $.messager.popover({msg:'��ѡ��һ����¼!',type:'info'});
        return;
    }
	var openTime = record.Item7;
	if ((openTime.indexOf('��')<0) && ((openTime.indexOf('Сʱ')<0) && (parseInt(openTime.split('��')[0]) < 15))) {
		$.messager.confirm('��ȷ��һ��', '��ȷ��Ҫ��������ʱ��Ϊ'+ openTime + ',û�дﵽ��׼����ʱ����15���ӣ�', function (r) {
			if (r) {              
				$cm({
					ClassName: GLOBAL.ClassName,
					MethodName: "LockSub",
					type: record.Item5,
					code: record.Item2
				}, function (result) {
					if (result == '0') {
						$.messager.popover({ msg: '�����ɹ���', type: 'success', timeout: 1000 });
						$('#unlockGrid').datagrid('reload')
					}
					else {
						$.messager.popover({ msg: '����ʧ��:' + result, type: 'error', timeout: 1000 });
					}
				});
			}
		});
	}else{
		$cm({
			ClassName: GLOBAL.ClassName,
			MethodName: "LockSub",
			type: record.Item5,
			code: record.Item2
		}, function (result) {
			if (result == '0') {
				$.messager.popover({ msg: '�����ɹ���', type: 'success', timeout: 1000 });
				$('#unlockGrid').datagrid('reload')
			}
			else {
				$.messager.popover({ msg: '����ʧ��:' + result, type: 'error', timeout: 1000 });
			}
		});
	}
}
function findAbnormal() {
    var flag = 1;
    $('#unlockGrid').datagrid('reload',{
        ClassName: GLOBAL.ClassName,
        QueryName: "getLockNew",
        parr: flag,
        HospitalID: GLOBAL.HospitalID
    });
}

function find() {
    var flag = 0;
    $('#unlockGrid').datagrid('reload',{
        ClassName: GLOBAL.ClassName,
        QueryName: "getLockNew",
        parr: flag,
        HospitalID: GLOBAL.HospitalID
    });
}
initUI();

