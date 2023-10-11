var page = {}
$(function(){
	initCombobox();
	initDatagrid();
	initDialog();
	initButton();
})
///��ʼ��������ؼ�
function initCombobox()
{
	/*var Loc = $HUI.combobox("#Loc",{	///����
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
			{id:'210',text:'ICU����'}
			,{id:'234',text:'ICU����'}
			,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#LocSearch",{	///����
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
	var Loc = $HUI.combobox("#Loc",{	///����
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
	
	
	$("#CategoryInSearch").combobox({	///����
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	});
	$("#CategoryIn").combobox({	///����
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
	var catheterDatagrid=$("#deptcathetercat_datagrid").datagrid({	///�б�����
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"���ҹ������ܷ���",
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
        	{ field: "DeptID", title: "����ID", width: 100, sortable: true },
        	{ field: "DeptDesc", title: "��������", width: 150, sortable: true },
        	{ field: "CatId", title: "����ID", width: 100, sortable: true },
        	{ field: "CatDesc", title: "����", width: 150, sortable: true }
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
            	text: '���',
            	handler: function() {
                	page.dialog.dialog({
                  		title: "����ù�λ��",
                   		iconCls: "icon-add"
                	});
                	page.dialog.buttons.ok.linkbutton({
                    	text: "���",
                    	iconCls: "icon-add"
                	});
                	page.dialog.dialog("open");
            	}
        	}, {
            	id: 'editToolBarBtn',
            	iconCls: 'icon-edit',
            	disabled: true,
            	text: '�༭',
            	handler: function() {
                	page.dialog.dialog({
                    	title: "�޸��ù�λ��",
                    	iconCls: "icon-edit"
                	});
                	page.dialog.buttons.ok.linkbutton({
                   		text: "�޸�",
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
            	text: 'ɾ��',
            	handler: function() {
	            	$.messager.confirm("ɾ��ȷ��", "��ǰ����Ϊ��ɾ����ǰѡ�еĿ��ҹ������ܷ���\n���գ�ɾ����Ӧ�ó�����ܱ���\n�Ƿ������", function(confirmed) {
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
                                 	   $.messager.alert("��ʾ","ɾ���ɹ���","info");
                                	    page.datagrid.datagrid("reload");
                                	} else {
                                	    $.messager.alert("��ʾ","ɾ������!", response);
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
 	* @description ��ʼ���Ի����
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
 	* @description ��ʼ���Ի���ť
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
	                    	$.messager.alert("��ʾ","����ɹ�","info");
                    	}
                    	else{
                    	$.messager.alert("��ʾ",response,"info");
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
	$("#btnSearch").click(function(){	///��ѯ
		$("#deptcathetercat_datagrid").datagrid('reload');
	})
	$HUI.linkbutton("#btnRefresh",{	///����
		onClick: function(){
			//$("#deptcathetercat_datagrid").datagrid('reload');
			$("#Loc").combobox('setValue',"");
			$("#Loc").combobox('setText',"");
			$("#CategoryIn").combobox('setValue',"");
			$("#CategoryIn").combobox('setText',"");
        }
	})
}

 /// jQuery��չ����
	(function($) {
    	$.fn.serializeJson = function() {
        	var serializeObj = {};
        	$(this.serializeArray()).each(function() {
            	serializeObj[this.name] = $.trim(this.value);
        	});
        	return serializeObj;
    	};
	})(jQuery);