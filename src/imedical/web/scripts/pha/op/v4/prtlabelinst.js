/*
*Creator	zhaozhiduan
*CreatDate	2021-01-22
*Description门诊打印标签用法维护
*js			scripts/pha/op/v4/labelinst.js
*/
var GridCmbInst="";
$(function () {
    InitGridDict();
    InitEvent();
    InitOPInstGrid();
})
function InitGridDict(){
	GridCmbInst=PHA.EditGrid.ComboBox({
		required: true,
        tipPosition: 'top',
        width:150,
       	url:PHAOP_STORE.Instruction().url,
        defaultFilter: 5,
        mode:'remote',
        onSelect: function (index, rowData) {
            var editIndex = $("#gridOPInstLab").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var instId = $(this).combobox("getValue");  //当前combobox的值
            if ((instId == "") || (instId == null)) {
                return;
            }
            var gridSelect = $('#gridOPInstLab').datagrid("getSelected");            
            gridSelect.instRowId = instId;
        },
	    onBeforeLoad: function(param) {
            if (param.q == undefined) {
                param.q = $('#gridOPInstLab').datagrid("getSelected").instDesc;
            }
            param.QText = param.q; 
            param.HospId = PHA_COM.Session.HOSPID; 
        }
	
	})
}
function InitEvent()
{
	$('#btnAdd').on('click', function () {
        $('#gridOPInstLab').datagrid('addNewRow', {
            editField: 'instDesc',
            defaultRow:{
	            locDesc:session['LOGON.CTLOCDESC'],
	        	locId:PHA_COM.Session.CTLOCID
            }
        });
    });
    $('#btnSave').on('click', SaveInstLabel);
    $('#btnDelete').on('click', DelInstLabel);
}
function InitOPInstGrid(){
	var columns = [[
		{
            field: 'opInstId',
            title: '标签用法id',
            hidden: true,
            width: 100
        },
        {
            field: 'locId',
            title: '科室id',
            hidden: true,
            width: 150
        },
        {
            field: 'locDesc',
            title: '科室描述',
            width: 150
        },
        {
            field: 'instDesc',
            title: '用法',
            descField: 'instDesc',
            width: 150,
            editor: GridCmbInst,
            formatter: function(value, row, index) {
                return row.instDesc;
            }
        },
        {
            field: 'instRowId',
            title: '用法描述id',
            hidden: true,
            width: 150
        }
	]];
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.CfPrtLab.Query',
            QueryName: 'QueryInstLabel',
            pJsonStr: JSON.stringify({locId: PHA_COM.Session.CTLOCID }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridOPInstLabBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'instDesc'
                });
            }
        },
        onLoadSuccess: function (data) {
        }
    };

    PHA.Grid('gridOPInstLab', dataGridOption);
}
function SaveInstLabel(){
	var $grid = $('#gridOPInstLab');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var dataArr = [];
    var gridChanges = $grid.datagrid('getChanges',"updated");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var iJson = {
	  		opInstId:rowData.opInstId || '',
	  		locId:rowData.locId || '',
            instRowId:rowData.instRowId || ''
           
        };
        dataArr.push(iJson);
    }
    var gridChanges = $grid.datagrid('getChanges',"inserted");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var iJson = {
	  		opInstId:rowData.opInstId || '',
	  		locId:rowData.locId || '',
            instRowId:rowData.instRowId || ''
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.CfPrtLab.OperTab',
            pMethodName: 'SaveOpInstLab',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
	    msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
	    PHA.Popover({
	        msg: '保存成功',
	        type: 'success'
	    });
    }
	$grid.datagrid('reload');

}
function DelInstLabel(){
	var $grid = $('#gridOPInstLab');
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHAOP_COM._Confirm("", $g("您确定删除当前标签用法吗") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
		if (r == true) {
		    var opInstId = gridSelect.opInstId || '';
		    if(opInstId!==""){
				var dataArr = [];
				var iJson = {
					opInstId:opInstId,
				};
			    dataArr.push(iJson);
			    var retJson = $.cm(
			        {
			            ClassName: 'PHA.OP.Data.Api',
			            MethodName: 'HandleInOne',
			            pClassName: 'PHA.OP.CfPrtLab.OperTab',
			            pMethodName: 'DelOpInstLab',
			            pJsonStr:JSON.stringify(dataArr)
			        },false
			    );
			    if (retJson.success === 'N') {
				    msg=PHAOP_COM.DataApi.Msg(retJson)
			        PHA.Alert('提示', msg, 'warning');
			        return;
			    }
		    }
		    PHA.Popover({
		        msg: '删除成功',
		        type: 'success'
		    });
		 	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
		    $grid.datagrid('deleteRow', rowIndex);
		} 
	}); 
}