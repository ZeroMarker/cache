var page = {}
$(function(){
	initCombobox();
	initDatagrid();
	initDialog();
	initButton();
})
///初始化下来框控件
function initCombobox()
{
	/*var Loc = $HUI.combobox("#Loc",{	///科室
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
			{id:'210',text:'ICU二区'}
			,{id:'234',text:'ICU三区'}
			,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#LocSearch",{	///科室
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindICULoc&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
		onBeforeLoad:function(param){
			//param.desc=param.q,
            //param.locListCodeStr="",
            //param.EpisodeID=""
		}
	});
	var Loc = $HUI.combobox("#Loc",{	///科室
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindICULoc&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
		onBeforeLoad:function(param){
			//param.desc=param.q,
            //param.locListCodeStr="",
            //param.EpisodeID=""
		}
	})
	
	
	$("#CategoryInSearch").combobox({	///分类
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	});
	$("#CategoryIn").combobox({	///分类
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	})

}
function initDatagrid()
{
	page.datagrid = $("#deptcathetercat_datagrid");
	var catheterDatagrid=$("#deptcathetercat_datagrid").datagrid({	///列表数据
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"科室关联导管分类",
        pageSize: 20,
        pageList: [20, 50, 100],
		border:false,			 
        url:$URL,
        queryParams:{
            ClassName:"Clinic.ICU.Catheter",
            QueryName:"FindDeptCatheterCat",
        },
        onBeforeLoad:function(param){
	        param.locId=$("#LocSearch").combobox("getValue");
	        param.catheterCategoryId=$("#CategoryInSearch").combobox("getValue");
	    },
        columns:[[
        	{ field: "RowId", title: "ID", width: 100, sortable: true },
        	{ field: "DeptID", title: "科室ID", width: 100, sortable: true },
        	{ field: "DeptDesc", title: "科室名称", width: 150, sortable: true },
        	{ field: "CatId", title: "分类ID", width: 100, sortable: true },
        	{ field: "CatDesc", title: "分类", width: 150, sortable: true }
       	]],
		onClickRow:function(){
            var row=$("#deptcathetercat_datagrid").datagrid('getSelected');
			$("#Loc").combobox('setValue',row.DeptID);
			$("#Loc").combobox('setText',row.DeptDesc);
			$("#CategoryIn").combobox('setValue',row.CatId);
			$("#CategoryIn").combobox('setText',row.CatDesc);
		},
        	onSelect: function(record) {
            	$("#editToolBarBtn,#removeToolBarBtn").linkbutton("enable");
        },
		toolbar: [{
            	id: 'addToolBarBtn',
            	iconCls: 'icon-add',
            	text: '添加',
            	handler: function() {
                	page.dialog.dialog({
                  		title: "添加置管位置",
                   		iconCls: "icon-add"
                	});
                	page.dialog.buttons.ok.linkbutton({
                    	text: "添加",
                    	iconCls: "icon-add"
                	});
                	page.dialog.dialog("open");
            	}
        	}, {
            	id: 'editToolBarBtn',
            	iconCls: 'icon-edit',
            	disabled: true,
            	text: '编辑',
            	handler: function() {
                	page.dialog.dialog({
                    	title: "修改置管位置",
                    	iconCls: "icon-edit"
                	});
                	page.dialog.buttons.ok.linkbutton({
                   		text: "修改",
                    	iconCls: "icon-edit"
                	});
                	page.dialog.dialog("open");
                	var selectedRecord = page.datagrid.datagrid("getSelected");
                	page.dialogForm.form("load", selectedRecord);
            	}
        	}, {
            	id: 'removeToolBarBtn',
            	iconCls: 'icon-remove',
            	disabled: true,
            	text: '删除',
            	handler: function() {
	            	$.messager.confirm("删除确认", "当前操作为：删除当前选中的科室关联导管分类\n风险：删除后应用程序可能报错\n是否继续？", function(confirmed) {
                    	if(confirmed){
	                    	var selectedRecord = page.datagrid.datagrid("getSelected");
                    		if (Number(selectedRecord.RowId)) {
                        		$.m({
                                	ClassName: "Clinic.ICU.Catheter",
                                	MethodName: "RemoveDeptCatheterCat",
                                	rowId: selectedRecord.RowId
                            	},
                            	function(response) {
                                	if ($.trim(response) === "0") {
                                 	   $.messager.alert("提示","删除成功！","info");
                                	    page.datagrid.datagrid("reload");
                                	} else {
                                	    $.messager.alert("提示","删除错误!", response);
                                	}
                            	});
                    		}
                    	}
                	});
                }
            	}
        	]
	});
}
function initDialog(){
		page.dialog = $("#loc_catheter_dialog");
    	page.dialog.dialog({
        	onBeforeOpen: function() {},
        	onOpen: function() {},
        	onBeforeClose: function() {},
        	onClose: function() {
            	page.dialogForm.form("clear");
        	}
    	});
    	
    	initiateDialogForm();
    	initiateDialogTool();
}
/**
 	* @description 初始化对话框表单
 	*/
	function initiateDialogForm() {
    	var form = $(page.dialog).find("form");
    	page.dialogForm = form;
    	page.dialogForm.form({
        	onValidate: function() {},
        	onSubmit: function() {},
        	onLoadSuccess: function(data) {}
    	});
    	
    	form.items = {};
	}
	
	/**
 	* @description 初始化对话框按钮
 	*/
	function initiateDialogTool() {
    	page.dialog.buttons = {};
    	var buttons = page.dialog.buttons;
    	buttons.ok = $("#dialog_okay");
    	buttons.cancel = $("#dialog_cancel");
    	buttons.ok.linkbutton({
        	onClick: function() {
            	var data = page.dialogForm.serializeJson();
            	data.ClassName="Clinic.ICU.Catheter";
            	//ajax post: saving data
            	$.m({
                	ClassName: "Clinic.ICU.Catheter",
                	MethodName: "SaveDeptCatheterCat",
                	rowId: data.RowId || "",
                	Location: data.Loc,
                	Category: data.CategoryIn
            	}, function(response) {
                	response = $.trim(response);
                	if (Number(response) > 0) {
                    	if (data.RowId) {
                        	var rowIndex = page.datagrid.datagrid("getRowIndex", data.RowId);
                        	page.datagrid.datagrid("updateRow", {
                            	index: rowIndex,
                            	row: data
                        	});
                    	} else {
                        	data.RowId = Number(response);
                        	page.datagrid.datagrid("appendRow", data);
                    	}
                    	page.dialog.dialog("close");
                	} else {
                    	//$.messager.show("Error!", response);
                    	if (response=="0"){
	                    	$.messager.alert("提示","保存成功","info");
                    	}
                    	else{
                    	$.messager.alert("提示",response,"info");
                    	}
                	}
            	});
        	}
    	});

    	buttons.cancel.linkbutton({
        	onClick: function() {
            	page.dialog.dialog("close");
        	}
    	});
	}
function initButton()
{
	$("#btnSearch").click(function(){	///查询
		$("#deptcathetercat_datagrid").datagrid('reload');
	})
	$HUI.linkbutton("#btnRefresh",{	///重置
		onClick: function(){
			//$("#deptcathetercat_datagrid").datagrid('reload');
			$("#Loc").combobox('setValue',"");
			$("#Loc").combobox('setText',"");
			$("#CategoryIn").combobox('setValue',"");
			$("#CategoryIn").combobox('setText',"");
        }
	})
}

 /// jQuery扩展函数
	(function($) {
    	$.fn.serializeJson = function() {
        	var serializeObj = {};
        	$(this.serializeArray()).each(function() {
            	serializeObj[this.name] = $.trim(this.value);
        	});
        	return serializeObj;
    	};
	})(jQuery);