/*
模块:门诊药房
子模块:门诊药房-拒绝退药原因维护
createdate:2016-06-13
creator:yunhaibao
*/
var HospId = session['LOGON.HOSPID'];
var editRow = ''; //当前编辑行号
var url = 'dhcpha.outpha.returnrefusereason.action.csp';
var titleNotes = '<span style="font-weight:bold;font-size:14px;font-family:Mictosoft YaHei;color:#800000;"><'+$g("双击行即可编辑")+'></span>';
$(function () {
    // 定义columns
    var columns = [
        [
            { field: 'ID', title: 'ID', width: 90, align: 'center', hidden: true },
            { field: 'Code', title: $g("代码"), width: 160, editor: texteditor },
            { field: 'Desc', title: $g("描述"), width: 300, editor: texteditor }
        ]
    ];

    // 定义datagrid
    $('#reasongrid').datagrid({
        title: $g("拒绝退药原因维护") + titleNotes,
        url: url + '?action=QueryReason&hosp=' + HospId,
        fit: true,
        striped: true,
        rownumbers: true,
        columns: columns,
        singleSelect: true,
        loadMsg: $g("正在加载信息")+"...",
        onDblClickRow: function (rowIndex, rowData) {
            //双击选择行编辑
            if (editRow != '' || editRow == '0') {
                $('#reasongrid').datagrid('endEdit', editRow);
            }
            $('#reasongrid').datagrid('beginEdit', rowIndex);
            editRow = rowIndex;
        }
    });

    initScroll('#reasongrid'); //初始化显示横向滚动条

    //按钮绑定事件
    $('#insert').on('click', insertRow);
    $('#delete').on('click', deleteRow);
    $('#save').on('click', saveRow);
    $('#reasongrid').datagrid('reload');
	InitHospCombo();
});

// 插入新行
function insertRow() {
    var row = $('#reasongrid').datagrid('getData').rows[0];
    //if(row["ID"]==""){
    //	return ;
    //}
    if (editRow >= '0') {
        $('#reasongrid').datagrid('endEdit', editRow); //结束编辑，传入之前编辑的行
    }
    $('#reasongrid').datagrid('insertRow', {
        //在指定行添加数据，appendRow是在最后一行添加数据
        index: 0, // 行数从0开始计算
        row: { ID: '', Code: '', Desc: '' }
    });
    $('#reasongrid').datagrid('beginEdit', 0); //开启编辑并传入要编辑的行
    editRow = 0;
}

// 删除选中行
function deleteRow() {
    var rows = $('#reasongrid').datagrid('getSelections'); //选中要删除的行
    if (rows.length > 0) {
        $.messager.confirm($g("提示"), $g("您确定要删除这些数据吗？"), function (res) {
            //提示是否删除
            if (res) {
                $.post(url + '?action=DeleteReason', { params: rows[0].ID, hosp:HospId }, function (data) {
                    $('#reasongrid').datagrid('reload'); //重新加载
                });
            }
        });
    } else {
        $.messager.alert($g("提示"), $g("请选择要删除的项"), 'warning');
        return;
    }
}

// 保存编辑行
function saveRow() {
    if (editRow >= '0') {
        $('#reasongrid').datagrid('endEdit', editRow);
    }
    var rows = $('#reasongrid').datagrid('getChanges');
    if (rows.length <= 0) {
        $.messager.alert($g("提示"), $g("没有待保存数据!"));
        return;
    }
    var dataList = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].Code == '' || rows[i].Desc == '') {
            $.messager.alert($g("提示"), $g("代码或描述不能为空!"));
            return false;
        }
        var tmp = rows[i].ID + '^' + rows[i].Code + '^' + rows[i].Desc;
        var existret = tkMakeServerCall('PHA.OP.CfRefRes.Query', 'CheckRefuseReason', rows[i].ID, rows[i].Code, rows[i].Desc, HospId);
        if (existret == '-1') {
            $.messager.alert($g("提示"), rows[i].Code + ','+$g("代码已存在,不能维护重复数据!"), 'info');
            return false;
        } else if (existret == '-2') {
            $.messager.alert($g("提示"), rows[i].Desc + ','+$g("描述已存在,不能维护重复数据!"), 'info');
            return false;
        }
        dataList.push(tmp);
    }
    var rowstr = dataList.join('||');

    //保存数据
    $.post(url + '?action=SaveReason', { params: rowstr, hosp: HospId}, function (data) {
		debugger
        $('#reasongrid').datagrid('reload'); //重新加载
    });
}

// 编辑格
var texteditor = {
    type: 'text', //设置编辑格式
    options: {
        required: true //设置编辑规则属性
    }
};


function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'PHR_RefuseReason'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$('#reasongrid').datagrid('options').queryParams.hosp=HospId;			
				$('#reasongrid').datagrid('reload');		
			}
        };
	}
}