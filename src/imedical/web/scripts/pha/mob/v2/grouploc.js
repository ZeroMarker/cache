/**
 * desc:    安全组关联科室维护(库存授权)
 * creator: Huxt 2019-09-12
 * scripts/pha/mob/v2/grouploc.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
$(function() {
	$g('是');
	$g('否');
	InitDict();
    InitGridGroup();
    InitGridGroupLoc();
});

// 初始化 - 安全组列表
function InitDict(){
	PHA.SearchBox('groupText', {
		searcher: Query,
		width: 417,
		placeholder: $g("输入安全组的名称或简拼") + "..."
	});
	PHA.SearchBox('groupLocText', {
		searcher: QueryGroupLoc,
		width: 417,
		placeholder: $g("输入科室的名称或简拼") + "..."
	});
	InitHospCombo();
}

// 初始化 - 安全组列表
function InitGridGroup() {
    var columns = [
        [
            { field: "RowId", title: 'RowId', hidden: true },
            { field: 'Description', title: '安全组名称', width: 225, sortable: 'true'}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.STORE.Org',
            QueryName: 'SSGroup',
            HospId: HospId
        },
        columns: columns,
        fitColumns: true,
        toolbar: "#gridGroupBar",
        onClickRow: function(rowIndex, rowData) {
            QueryGroupLoc();
        }
    };
    PHA.Grid("gridGroup", dataGridOption);
}

// 初始化 - 安全组科室列表
function InitGridGroupLoc() {
    var columns = [
        [
        	{ field: "grpLocRowId", title: 'grpLocRowId', hidden: true},
            { field: "locId", title: 'locId', hidden: true},
            { field: 'locCode', title: '科室代码', width: 225, sortable: true},
            { field: 'locDesc', title: '科室名称', width: 225, sortable: true},
            { field: 'activeFlag', title: '是否启用', align:'center', formatter: FormatterYes}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.GroupLoc.Query',
            QueryName: 'GroupLoc'
        },
        singleSelect: true,
        columns: columns,
        toolbar: "#gridGroupLocBar",
        onDblClickCell: function(index, field, value){
	        var retActiveFlag = "N";
	        if(value == "Y"){
		        retActiveFlag = "N";
		    } else {
			    retActiveFlag = "Y";
			}
			SaveGroupLoc(index, retActiveFlag); 
	    }
        
    };
    PHA.Grid("gridGroupLoc", dataGridOption);
}

// 查询 - 安全组
function Query(){
	var groupText = $('#groupText').searchbox('getValue') || "";
	$('#gridGroup').datagrid("load", {
		ClassName: 'PHA.STORE.Org',
		QueryName: 'SSGroup',
		QText: groupText,
		HospId: HospId
	});
	$('#gridGroupLoc').datagrid('clear');
}

// 查询 - 安全组下对应的科室
function QueryGroupLoc(){
	var groupLocText = $('#groupLocText').searchbox('getValue') || "";
	var gridSelect = $('#gridGroup').datagrid("getSelected");
    if (gridSelect == null) {
        return;
    }
    var groupId = gridSelect.RowId || "";
    if(groupId == ""){
	    return;
	}
	var pJsonStr = JSON.stringify({
		groupId: groupId
	});
	$('#gridGroupLoc').datagrid("load", {
		ClassName: 'PHA.MOB.GroupLoc.Query',
		QueryName: 'GroupLoc',
		QText: groupLocText,
		pJsonStr: pJsonStr
	});
}

// 保存安全组可以下科室的可用状态
function SaveGroupLoc(index, activeFlag){
	var eaRows = $('#gridGroupLoc').datagrid('getRows');
	var grpLocRowId = eaRows[index].grpLocRowId || "";
	var retStr = tkMakeServerCall("PHA.MOB.GroupLoc.Save", "SaveGroupLoc", grpLocRowId, activeFlag);
	var retArr = retStr.split("^");
	if(retArr[0] < 0) {
		$.messager.alert("提示", "更新失败" + retArr[1], "warning");
	} else {
		$.messager.popover({
			msg: "保存成功!",
			type: "success",
			timeout: 1000
		});
		QueryGroupLoc();
	}
}

// 帮助信息
function ShowHelpTips(){
	var winId = "helpWin";
	var winContentId = "helpWin_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 400,
	    	height: 300,
	    	modal: true,
	    	title: '帮助',
	    	iconCls: 'icon-w-list',
	    	content: "<div id='" + winContentId + "'style='margin:10px;'>" + GetContentHtml() + "</div>",
	    	closable: true
		});
	}
	$('#' + winId).dialog('open');
	
	// 内容
	function GetContentHtml(){
		var cHtml = "";
		cHtml += "<p style='line-height:28.5px;'>1、选择左侧安全组列表中的安全组，查询出右侧的科室列表；<p>";
		cHtml += "<p style='line-height:28.5px;'>2、如果右侧的没有对应的科室信息，则需要到“基础数据->安全组->库存授权”下添加需要的科室；<p>";
		cHtml += "<p style='line-height:28.5px;'>3、双击“是否启用”列可以维护该安全组下，移动端获取处方时是否可以获取该安全组下该科室的处方。<p>";
		return cHtml;
	}
}

// 格式化
function FormatterYes(value, row, index) {
	if (value == "Y"){
		return '<label style="cursor:pointer;"><font color="#21ba45">是</font></label>';
	} else {
		return '<label style="cursor:pointer;"><font color="#f16e57">否</font></label>';
	}
}

function InitHospCombo() {
	var genHospObj=PHA_COM.GenHospCombo({tableName:'PHAIP_LabelConfig'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                
            }
        }
    }
}
