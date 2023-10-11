//Creator	zhaozhiduan
//CreatDate	2021-01-21
//门诊配置--拒绝退药原因维护
//scripts/pha/op/v4/refuseretreason.js
$(function () {
    InitHosp();
    InitEvent();
    InitRefRetReasonGrid();
})

function InitEvent(){
	//基数药维护
	$('#btnAdd').on('click', function () {
        $('#gridRefRetReason').datagrid('addNewRow', {
            editField: 'refRetReaCode'
        });
    });
    $('#btnSave').on('click', SaveRefRetRea);
    $('#btnDelete').on('click', DelRefRetRea);
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridRefRetReason', idField: 'refRetReaId', sqlTableName: 'PHR_RefuseReason' });
}
function InitRefRetReasonGrid(){
	var columns = [[
		{
            field: 'refRetReaId',
            title: 'id',
            hidden: true,
            width: 100
        },
        {
            field: 'refRetReaCode',
            title: '代码',
            descField: 'baseMedTypeDesc',
            width: 150,
            editor: {
	        	type: 'validatebox',
                options: {
	                required: true
                }
	        }
        },
        {
            field: 'refRetReaDesc',
            title: '描述',
            width: 150,
            editor: {
	        	type: 'validatebox',
                options: {
	                required: true
                }
                
	        }
        }
	]];
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.CfRefRes.Query',
            QueryName: 'QueryRefRetReason',
            pJsonStr: JSON.stringify({hospId: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridRefRetReasonBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $('#gridRefRetReason').datagrid('endEditing');
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $('#gridRefRetReason').datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'refRetReaDesc'
                });
            }
        },
        onLoadSuccess: function (data) {
        }
    };

    PHA.Grid('gridRefRetReason', dataGridOption);
}
function InitHosp(){
	var hospComp = GenHospComp('PHR_RefuseReason','',{width:280});
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        Query();
    };
}
function Query(){
	var pJson = {};
	pJson.hospId = PHA_COM.Session.HOSPID;	
	$("#gridRefRetReason").datagrid("query",{
		pJsonStr: JSON.stringify(pJson),
	});
}
function SaveRefRetRea(){
	var $grid = $('#gridRefRetReason');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var hospId = PHA_COM.Session.HOSPID;	
    var dataArr = [];
    var gridChanges = $grid.datagrid('getChanges',"updated");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var iJson = {
	        hospId:hospId,
	  		refRowId:rowData.refRetReaId || '',
	  		refCode:rowData.refRetReaCode || '',
            refDesc:rowData.refRetReaDesc || '',
        };
        dataArr.push(iJson);
    }
    var gridChanges = $grid.datagrid('getChanges',"inserted");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var iJson = {
	        hospId:hospId,
	  		refRowId:rowData.refRetReaId || '',
	  		refCode:rowData.refRetReaCode || '',
            refDesc:rowData.refRetReaDesc || '',
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
            pClassName: 'PHA.OP.CfRefRes.OperTab',
            pMethodName: 'SaveHandler',
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
function DelRefRetRea(){
	var gridSelect = $('#gridRefRetReason').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
	PHAOP_COM._Confirm("", $g("您确定删除当前拒绝退药原因吗") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
		if (r == true) {
		    var hospId = PHA_COM.Session.HOSPID;	
		    var refRowId = gridSelect.refRetReaId || '';
		    if(refRowId!==""){
				var dataArr = [];
				var iJson = {
					refRowId:refRowId,
					hospId:hospId
				};
			    dataArr.push(iJson);
			    var retJson = $.cm(
			        {
			            ClassName: 'PHA.OP.Data.Api',
			            MethodName: 'HandleInOne',
			            pClassName: 'PHA.OP.CfRefRes.OperTab',
			            pMethodName: 'DelHandler',
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
		 	var rowIndex = $('#gridRefRetReason').datagrid('getRowIndex', gridSelect);
		    $('#gridRefRetReason').datagrid('deleteRow', rowIndex);
    	} 
	});    
}

