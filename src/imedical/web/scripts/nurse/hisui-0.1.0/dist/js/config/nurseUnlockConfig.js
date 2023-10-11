/*
* @author: yaojining
* @discription: 护理病历异常锁管理
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
        text: '解锁',
        iconCls: 'icon-unlock',
        handler: unlock
    }, '-', {
        text: '查询所有',
        iconCls: 'icon-search',
        handler: find
    }, '-', {
        text: '查询异常',
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
            { field: 'Item5', title: '模板类型', width: 80},
            { field: 'Item1', title: '模板名称', width: 200 },
            { field: 'Item6', title: '模板关键字段', width: 220 },
            { field: 'Item2', title: '模板ID', width: 300 },
            { field: 'Item4', title: '锁定时间', width: 180 },
            { field: 'Item7', title: '模板打开时长', width: 150 },
			{ field: 'Item8', title: '锁定情况', width: 150 },
			{ field: 'Item3', title: '进程号', width: 100 },
        ]],
		rowStyler: function (rowIndex, rowData) {
			if (rowData.Item8 == '异常') {
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
        $.messager.popover({msg:'请选择一条记录!',type:'info'});
        return;
    }
	var openTime = record.Item7;
	if ((openTime.indexOf('天')<0) && ((openTime.indexOf('小时')<0) && (parseInt(openTime.split('分')[0]) < 15))) {
		$.messager.confirm('再确认一下', '你确定要解锁？打开时长为'+ openTime + ',没有达到标准解锁时长（15分钟）', function (r) {
			if (r) {              
				$cm({
					ClassName: GLOBAL.ClassName,
					MethodName: "LockSub",
					type: record.Item5,
					code: record.Item2
				}, function (result) {
					if (result == '0') {
						$.messager.popover({ msg: '解锁成功！', type: 'success', timeout: 1000 });
						$('#unlockGrid').datagrid('reload')
					}
					else {
						$.messager.popover({ msg: '解锁失败:' + result, type: 'error', timeout: 1000 });
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
				$.messager.popover({ msg: '解锁成功！', type: 'success', timeout: 1000 });
				$('#unlockGrid').datagrid('reload')
			}
			else {
				$.messager.popover({ msg: '解锁失败:' + result, type: 'error', timeout: 1000 });
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

