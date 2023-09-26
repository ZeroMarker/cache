/**
 * 名称:	 处方点评-注射剂用法和剂型维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.instruc.csp";
PHA_COM.App.Name = "PRC.ConFig.Instruc";
PHA_COM.App.Load = "";
$(function () {
	InitGridInst();
    InitGridForm();
    InitGridPrcInst();
    InitEvents();
    InitSetDefVal();
});

function InitEvents(){
	$("#btnAddInst").on("click", SavePrcInstBat);
	$("#btnAddForm").on("click", SavePrcInstBat);	
	$("#btnDel").on("click", DelPrcInstBat);
}


// 表格-用法
function InitGridInst() {
    var columns = [
        [
            { field: "instId", title: 'instRowId',width: 100, hidden: true },
            { field: "insCheck", title: '选择', checkbox:'true',align:'center',width:30 },
            { field: "instDesc", title: '用法',align:'left',width: 280 }

        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectInstruc',
            rows:999
        },
        columns: columns,
        fitColumns:true,
        showHeader:true,
        singleSelect:false,
        pagination:false,
        toolbar: "#gridInstBar",
        onDblClickRow:function(rowIndex,rowData){
	        var instId = rowData.instId;
	        SavePrcInst(instId,'');
		}   
		
    };
    PHA.Grid("gridInst", dataGridOption);
}

//表格-剂型
function InitGridForm() {
    var columns = [
        [
            { field: "formId", title: 'formRowId',width: 100, hidden: true },
            { field: "formCheck", title: '选择', checkbox:'true',align:'center',width:30 },
            { field: "formDesc", title: '剂型',align:'left',width: 280 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectForm',
            rows:999
        },
        columns: columns,
        fitColumns:true,
        showHeader:true,
        pagination:false,
        singleSelect:false,
        toolbar: "#gridFormBar",
        onDblClickRow:function(rowIndex,rowData){
	        var formId = rowData.formId;
	        SavePrcInst('',formId);
		}   
		
    };
    PHA.Grid("gridForm", dataGridOption);
}

//表格-已维护列表
function InitGridPrcInst() {
    var columns = [
        [
            { field: "prcInstId", title: 'prcInstId',width: 100, hidden: true },
            { field: "prcInstCheck", title: '选择', checkbox:'true',align:'center',width:30 },
            { field: "prcInstDesc", title: '用法',align:'left',width: 270 },
            { field: "prcFormDesc", title: '剂型',align:'left',width: 280 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Instruc',
            QueryName: 'SelectPrcInst',
            rows:999
        },
        columns: columns,
        singleSelect:false,
        pagination:false,
        toolbar: "#gridPrcInstBar",
        onDblClickRow:function(rowIndex,rowData){
	        var prcInstId = rowData.prcInstId;
			var delInfo = "您确认删除吗?"
			PHA.Confirm("删除提示", delInfo, function () {
				Delete(prcInstId);
			})
	        
		}   
    };
    PHA.Grid("gridPrcInst", dataGridOption);
}

/// 界面信息初始化
function InitSetDefVal() {
	
	var type=tkMakeServerCall("PHA.PRC.ConFig.Instruc","GetPrcInstType")
	//alert("type:"+type)
	if (type=="form"){
		$('#tabsInstForm').tabs('select', "剂型");
		$('#tabsInstForm').tabs('disableTab', "用法");
	}
	else if (type=="inst"){
		$('#tabsInstForm').tabs('select', "用法");
		$('#tabsInstForm').tabs('disableTab', "剂型");	
	}
	else{
		$('#tabsInstForm').tabs('enableTab', "用法");	
		$('#tabsInstForm').tabs('enableTab', "剂型");	
		}
	

}

/// 批量增加注射剂用法
function SavePrcInstBat(){
	var selTabObj = $('#tabsInstForm').tabs('getSelected');	
	var tabIndex = $('#tabsInstForm').tabs('getTabIndex',selTabObj);
	var instStr="",formStr=""
	if (tabIndex=="0"){		//按用法保存
		var rows = $('#gridInst').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("提示", "请先勾选需要增加的用法", "warning");
	        return;
	    }
	    for (var pnum = 0; pnum < rows.length; pnum++) {
	        var instId = rows[pnum].instId;
	        if (instStr==""){
		        instStr = instId
		    }else{
			    instStr = instStr + "^" + instId
			}
	    
    	}
	}
    else if (tabIndex=="1"){
	    var rows = $('#gridForm').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("提示", "请先勾选需要增加的剂型", "warning");
	        return;
	    }
	    for (var pnum = 0; pnum < rows.length; pnum++) {
	        var formId = rows[pnum].formId;
	        if (formStr==""){
		        formStr = formId
		    }else{
			    formStr = formStr + "^" + formId
			}
	    
    	}
	}

    var saveBatRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "SavePrcInstByBat", instStr, formStr);
    var saveBatArr = saveBatRet.split("^");
    var saveBatVal = saveBatArr[0];
    var saveBatInfo = saveBatArr[1];
    if (saveBatVal < 0) {
        $.messager.alert("提示", saveBatInfo, "warning");
    }
    else{
	    $.messager.alert("提示", "增加成功", "success");
	}
	$('#gridInst').datagrid("reload");
	$('#gridForm').datagrid("reload");
    $('#gridPrcInst').datagrid("reload");
	
}

function SavePrcInst(instId,formId) {
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "SavePrcInst",instId, formId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    else{
	    $.messager.alert("提示", "增加成功", "success");
	}
    $('#gridPrcInst').datagrid("reload");
    InitSetDefVal() ;
}

/// 批量删除
function DelPrcInstBat(){
	
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		var rows = $('#gridPrcInst').datagrid('getSelections')
	    if (rows.length == 0) {
		    $.messager.alert("提示", "请先勾选需要删除的记录", "warning");
	        return;
	    }
	    var prcInstIdStr=""
	    for (var cnum = 0; cnum < rows.length; cnum++) {
	        var prcInstId = rows[cnum].prcInstId;
	        if (prcInstIdStr==""){
		        prcInstIdStr = prcInstId
		    }else{
			    prcInstIdStr = prcInstIdStr + "^" + prcInstId
			}
		    
	    }

	    var delBatRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "DelPrcInstByBat", prcInstIdStr);
	    var delBatArr = delBatRet.split("^");
	    var delBatVal = delBatArr[0];
	    var delBatInfo = delBatArr[1];
	    if (delBatVal < 0) {
	        $.messager.alert("提示", delBatInfo, "warning");
	    }
	    else{
		    $.messager.alert("提示", "删除成功", "success");
		}
	    $('#gridPrcInst').datagrid("reload");
	    InitSetDefVal() ;
    })
}

function Delete(prcInstId) {
	
    var saveRet = tkMakeServerCall("PHA.PRC.ConFig.Instruc", "DelPrcInst", prcInstId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    else{
	    $.messager.alert("提示", "删除成功", "success");
	}
    $('#gridPrcInst').datagrid("reload");
    InitSetDefVal() ;
}





