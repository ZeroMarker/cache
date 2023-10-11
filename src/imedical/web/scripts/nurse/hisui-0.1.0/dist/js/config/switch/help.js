/*
 * @Descripttion: 页面介绍
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
 * @description 加载授权列表
 */
function loadHelpGrid() {
	if (Page == 'DischAuth') {
		var data1 = [{
			Desc: '病案归档限制',
			Remark: '启用后病案归档限制护士对出院病历的操作，需要向护理部申请授权。标准版默认护士提交归档后，不允许再操作该出院病历。自定义节点控制可以在限制接口中输入其他病案组接口。病案归档限制范围包括护理病历、体温单、血糖单、产程图'
		}, {
			Desc: '出院天数控制',
			Remark: '启用后超出出院天数限制出院病历权限，需要向护理部申请授权。出院天数不填默认一个月'
		}, {
			Desc: '权限控制',
			Remark: '选择不同出院病历类型的控制权限，勾选受到限制的权限，其他权限默认放开，不受出院限制'
		}, {
			Desc: '出院体征申请模式',
			Remark: '出院体征的申请授权模式包括两种：整体和单时间点。单时间点需要选择申请授权的某日期某时间下的体征项，整体是出院患者的所有生命体征数据'
		}, {
			Desc: '病案归档限制出院病历授权',
			Remark: '启用后护理部授权前需要先判断出院病历的病案归档流程是否允许授权，默认病案编目后不允许授权。自定义节点控制可以在限制接口中输入其他病案组接口'
		}, {
			Desc: '类型和模式的代码对照',
			Remark: 'V：查看； 修改：S； 新建：N； 作废：C； 删除：D； 打印：P； 撤销执行：U；整体：whole；单时间点：singleTime'
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
				{ field: 'Desc', title: '配置项', width: 200, align: 'left' },
				{ field: 'Remark', title: '说明', width: 550, align: 'left' }
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
					{ field: 'Desc', title: '配置项', width: 200, align: 'left' },
					{ field: 'Remark', title: '说明', width: 550, align: 'left' },
					{ field: 'Key', title: '代码', width: 200, hidden: false },
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
 * @description: 更新备注
 */
function updateRemark() {
	var items = getChanges();
    if (items.length == 0) {
        $.messager.popover({ msg: $g("没有需要更新的数据！"), type: "info" });
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
 * @description: 事件
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