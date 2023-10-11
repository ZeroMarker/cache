/**
 * @author yongyang
 * @description 重症监护科室显示模板的配置界面
 */
var displayTemplateEditing = {
    /**
     * 模板数据表格
     */
    templateGrid: null,
    /**
     * 模板数据编辑模态框
     */
    templateDialog: null,
    /**
     * 模板数据编辑模态框中表单
     */
    templateDialogForm: null,

    /**
     * 模板项目数据表格
     */
    templateItemGrid: null,
    /**
     * 模板项目数据编辑模态框
     */
    templateItemDialog: {
        /**
         * 模板项目数据编辑模态框的按钮
         */
        buttons: null
    },
    /**
     * 模板项目数据编辑模态框中表单
     */
    templateItemDialogForm: {
        /**
         * 模板项目数据编辑模态框中表单项目
         */
        items: {

        }
    }
};

/**
 * @description 界面初始化
 */
$(document).ready(function() {
    initiateTemplateArea();
    initiateTemplateDialog();
    initiateTemplateItemArea();
    initiateTemplateItemDialog();
    initiateTemplateItemPropertyArea();
});

/**
 * @description 初始化模板区域
 */
function initiateTemplateArea() {
    displayTemplateEditing.templateGrid = $("#template_datagrid");
    displayTemplateEditing.templateGrid.datagrid({
        title: "科室模板",
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        fit: true,
        singleSelect: true,
        rownumber: true,
        pagination: true,
        pageSize: 50,
        pageList: [10, 20, 50, 100, 200, 500],
		displayMsg:'',
        bodyCls: "panel-body-gray",
        toolbar: [{
            id: 'template_add',
            iconCls: 'icon-add',
            text: '新增',
            handler: function() {
                displayTemplateEditing.templateDialog.dialog({
                    title: "新增科室模板",
					iconCls: 'icon-w-add'
                });
                displayTemplateEditing.templateDialog.buttons.ok.linkbutton({
                    text: "确定"
                });
                displayTemplateEditing.templateDialog.dialog("open");
                var options = displayTemplateEditing.templateGrid.datagrid("options");
                displayTemplateEditing.templateGrid.datagrid("reload");
            }
        }, {
            id: 'template_edit',
            iconCls: 'icon-write-order',
            disabled: true,
            text: '修改',
            handler: function() {
                displayTemplateEditing.templateDialog.dialog({
                    title: "修改科室模板",
                    iconCls: 'icon-w-edit'
                });
                displayTemplateEditing.templateDialog.buttons.ok.linkbutton({
                    text: "保存"
                });
                displayTemplateEditing.templateDialog.dialog("open");
                var selectedRecord = displayTemplateEditing.templateGrid.datagrid("getSelected");
                displayTemplateEditing.templateDialogForm.form("load", {
                    TemplateRowId: selectedRecord.TTemplateID,
                    LocId: selectedRecord.TDeptID,
                    TemplateName: selectedRecord.TTemplateName
                });
            }
        }, {
            id: 'template_remove',
            iconCls: 'icon-cancel',
            disabled: true,
            text: '删除',
            handler: function() {
                $.messager.confirm("删除确认", "<span style='color:red'>当前操作为：删除当前选中的模板<br/>风险：删除后应用程序可能报错<br/>是否继续？</span>", function(confirmed) {
                    if (confirmed) {
                        var selectedRecord = displayTemplateEditing.templateGrid.datagrid("getSelected");
                        if (Number(selectedRecord.TTemplateID)) {
                            $.m({
                                    ClassName: "web.DHCICUPara",
                                    MethodName: "DeleteICUPara",
                                    IcuParaId: selectedRecord.TTemplateID
                                },
                                function(response) {
                                    if ($.trim(response) === "0") {
                                        $.messager.alert("提示","删除成功！");
                                        displayTemplateEditing.templateGrid.datagrid("reload");
                                    } else {
                                        $.messager.alert("删除错误!", response);
                                    }
                                });
                        }
                    }
                });
            }
        }],
        url: "dhcclinic.jquery.csp",
        idField: "TTemplateID",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindICUPara",
            ArgCnt: 0
        },
        frozenColumns: [
            [

            ]
        ],
        columns: [
            [
                { field: "TTemplateID", title: "ID", width: 60 },
                { field: "TDeptName", title: "科室", width: 200 },
                { field: "TDeptID", title: "科室ID", width: 60 },
                { field: "TTemplateName", title: "模板名", width: 160 }
            ]
        ],
        onSelect: function(index, record) {
            $("#template_edit,#template_remove").linkbutton("enable");
            $("#item_add,#item_query").linkbutton("enable");

            var options = displayTemplateEditing.templateItemGrid.datagrid("options");
            displayTemplateEditing.templateItemGrid.datagrid("reload", $.extend(options.queryParams, {
                Arg1: record.TDeptID || "",
                Arg2: "",
                Arg3: "",
                Arg4: ""
            }));

            propertyArea.emptyItemPropertyContainer();
        }
    });
}

/**
 * @description 初始化模板编辑模态框
 */
function initiateTemplateDialog() {
    displayTemplateEditing.templateDialog = $("#template_dialog");
    displayTemplateEditing.templateDialog.dialog({
        onBeforeOpen: function() {

        },
        onOpen: function() {

        },
        onBeforeClose: function() {

        },
        onClose: function() {
            displayTemplateEditing.templateDialogForm.form("clear");
        }
    });

    initiateTemplateDialogForm();
    initiateTemplateDialogTool();
}

/**
 * @description 初始化模板对话框中表单
 */
function initiateTemplateDialogForm() {
    var form = $(displayTemplateEditing.templateDialog).find("form");
    displayTemplateEditing.templateDialogForm = form;
    displayTemplateEditing.templateDialogForm.form({
        onValidate: function() {

        },
        onSubmit: function() {

        },
        onLoadSuccess: function(data) {
            form.items.LocId.combobox("setValue", data.LocId);
        }
    });

    form.items = {};
    form.items.LocId = $(form).find("input[name='LocId']");

    form.items.LocId.combobox({
        textField: "ctlocDesc",
        valueField: "ctlocId",
        url: $URL + "?ClassName=web.DHCClinicCom&QueryName=FindLocList&desc=&locListCodeStr=&EpisodeID=&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCClinicCom",
            QueryName: "FindLocList",
            desc: "",
            locListCodeStr: "",
            EpisodeID: ""
        },
		onHidePanel: function () {//20190110 YuanLin 下拉框只能选择不允许手写
		var valueField = $(this).combobox("options").valueField;
		var val = $(this).combobox("getValue");
		var allData = $(this).combobox("getData");
		var result = true;
		if (val=="") result=false;
		for (var i = 0; i < allData.length; i++) {
			if (val == allData[i][valueField]) {
				result = false;
				break;
			}
		}
		if (result){
			$(this).combobox("clear");
			$.messager.alert("提示","请从下拉框选择","info");
			$(this).combobox("reload");
			return;
		}
        }
    });
}

/**
 * @description 初始化模板对话框工具
 */
function initiateTemplateDialogTool() {
    displayTemplateEditing.templateDialog.buttons = {};

    displayTemplateEditing.templateDialog.onSaveSuccess = function(response) {
        response = $.trim(response);
        if (response === "0") {
            displayTemplateEditing.templateItemGrid.datagrid("loadData", { rows: [], count: 0 });
            displayTemplateEditing.templateGrid.datagrid("reload");
            displayTemplateEditing.templateDialog.dialog("close");
            $.messager.alert("保存模板成功！", "保存模板成功！");
        } else {
            $.messager.alert("保存模板错误!", "错误信息：<br/>" + response);
        }
    }

    displayTemplateEditing.templateDialog.buttons.ok = $("#template_dialog_okay");
    displayTemplateEditing.templateDialog.buttons.cancel = $("#template_dialog_cancel");

    displayTemplateEditing.templateDialog.buttons.ok.linkbutton({
        onClick: function() {
            if (displayTemplateEditing.templateDialogForm.form("validate")) {
                var data = displayTemplateEditing.templateDialogForm.serializeJson();
                if (data.TemplateRowId) {
                    $.m({
                        ClassName: "web.DHCICUPara",
                        MethodName: "UpdateICUPara",
                        IcuParaId: data.TemplateRowId,
                        LocId: data.LocId,
                        ICUPICUADr: "",
                        TemplateName: data.TemplateName
                    }, displayTemplateEditing.templateDialog.onSaveSuccess);
                } else {
                    $.m({
                        ClassName: "web.DHCICUPara",
                        MethodName: "AddICUPara",
                        LocId: data.LocId,
                        TemplateName: data.TemplateName
                    }, displayTemplateEditing.templateDialog.onSaveSuccess)
                }
            }
        }
    });

    displayTemplateEditing.templateDialog.buttons.cancel.linkbutton({
        onClick: function() {
            displayTemplateEditing.templateDialog.dialog("close");
        }
    });
}

/**
 * @description 初始化模板项目区域
 */
function initiateTemplateItemArea() {
    displayTemplateEditing.templateItemGrid = $("#item_datagrid");
    displayTemplateEditing.templateItemGrid.datagrid({
        fit: true,
        singleSelect: true,
        rownumber: true,
        pagination: true,
        pageSize: 200,
        pageList: [10, 20, 50, 100, 200, 500],
        bodyCls: "panel-body-gray",
        toolbar: [{
            id: 'item_add',
            iconCls: 'icon-add',
            disabled: true,
            text: '新增',
            handler: function() {
                displayTemplateEditing.templateItemDialog.dialog({
                    title: "新增科室模板",
					iconCls: 'icon-w-add'
                });
                displayTemplateEditing.templateItemDialog.buttons.ok.linkbutton({
                    text: "确定",
                });
                displayTemplateEditing.templateItemDialog.dialog("open");
                var selectedTemplate = displayTemplateEditing.templateGrid.datagrid("getSelected");
                displayTemplateEditing.templateItemDialogForm.form("load", {
                    TemplateRowId: selectedTemplate.TTemplateID
                });
            }
        }, {
            id: 'item_edit',
            iconCls: 'icon-write-order',
            disabled: true,
            text: '修改',
            handler: function() {
                displayTemplateEditing.templateItemDialog.dialog({
                    title: "修改科室模板",
                    iconCls: 'icon-w-edit'
                });
                displayTemplateEditing.templateItemDialog.buttons.ok.linkbutton({
                    text: "保存"
                });
                displayTemplateEditing.templateItemDialog.dialog("open");
                var selectedRecord = displayTemplateEditing.templateItemGrid.datagrid("getSelected");
                displayTemplateEditing.templateItemDialogForm.form("load", {
                    TemplateRowId: selectedRecord.TTemplateID,
                    ItemRowId: selectedRecord.TID,
                    ViewCat: selectedRecord.TViewCatID,
                    ComOrd: selectedRecord.TComOrdID,
                    Code: selectedRecord.TItemCode,
                    Desc: selectedRecord.TItemDesc,
                    SeqNo: selectedRecord.TSeqNo
                });
            }
        }, {
            id: 'item_remove',
            iconCls: 'icon-cancel',
            disabled: true,
            text: '删除',
            handler: function() {
                $.messager.confirm("删除确认", "<span style='color:red'>当前操作为：删除当前选中的模板项目<br/>风险：删除后应用程序可能报错<br/>是否继续？</span>", function(confirmed) {
                    if (confirmed) {
                        var selectedRecord = displayTemplateEditing.templateItemGrid.datagrid("getSelected");
                        if (selectedRecord.TID !== "") {
                            $.m({
                                    ClassName: "web.DHCICUPara",
                                    MethodName: "DeleteICUParaItem",
                                    IcuParaItemId: selectedRecord.TID
                                },
                                function(response) {
                                    if ($.trim(response) === "0") {
                                        $.messager.alert("提示","删除成功！");
                                        displayTemplateEditing.templateItemGrid.datagrid("reload");
                                    } else {
                                        $.messager.alert("删除错误!", response);
                                    }
                                });
                        }
                    }
                });
            }
        }],
        url: "dhcclinic.jquery.csp",
        idField: "TID",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindICUParaItem",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: "",
            ArgCnt: 4
        },
        frozenColumns: [
            [

            ]
        ],
        columns: [
            [
                { field: "TID", title: "ID", width: 60 },
                { field: "TItemCode", title: "代码", width: 100 },
                { field: "TItemDesc", title: "名称", width: 100 },
                { field: "TViewCatDesc", title: "显示分类", width: 100 },
                { field: "TViewCatID", title: "显示分类ID", width: 60 },
                { field: "TComOrdDesc", title: "常用医嘱", width: 100 },
                { field: "TComOrdCode", title: "常用医嘱代码", width: 100 },
                { field: "TComOrdID", title: "常用医嘱ID", width: 60 },
                { field: "TSeqNo", title: "排序号", width: 60 },
                { field: "TTemplateID", title: "ID", width: 60, hidden: true }
            ]
        ],
        onSelect: function(index, record) {
            $("#item_edit,#item_remove").linkbutton("enable");

            $.cm({
                ClassName: "web.DHCICUPara",
                QueryName: "FindICUParaItemDetails",
                DisplayItemID: record.TID,
                ResultSetType: "array"
            }, function(data) {
                propertyArea.render(data);
            });

            propertyArea.refreshTitle(record.TItemDesc);
        }
    });

    initiateTemplateItemQuery();
}

/**
 * 初始化模板项目查询部分
 */
function initiateTemplateItemQuery() {
    $("#param_viewcat").combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCEViewCat&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCEViewCat"
        },
        onSelect: function(record) {
            $("#param_comord").combobox("reload", $URL +
                "?ClassName=web.DHCICUPara&QueryName=FindANCComOrd&ANCEViewCatId=" + record.ID + "&ComDesc=&ResultSetType=array");
        }
    });

    $("#param_comord").combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCComOrd&ANCEViewCatId=&ComDesc=&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCComOrd",
            ANCEViewCatId: "",
            ComDesc: ""
        }
    });

    $("#item_query").linkbutton({
        onClick: function() {
            var options = displayTemplateEditing.templateItemGrid.datagrid("options");
            displayTemplateEditing.templateItemGrid.datagrid("reload", $.extend(options.queryParams, {
                Arg2: $("#param_viewcat").combobox("getValue") || "",
                Arg3: $("#param_comord").combobox("getValue") || "",
                Arg4: $("#param_desc").val() || ""
            }));

            propertyArea.emptyItemPropertyContainer();
        }
    });
	//YuanLin 20181227
	$("#LocId").combobox({
        textField: "ctlocDesc",
        valueField: "ctlocId",
        url: $URL + "?ClassName=web.DHCClinicCom&QueryName=FindLocList&desc=&locListCodeStr=&EpisodeID=&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCClinicCom",
            QueryName: "FindLocList",
			desc: "",
            locListCodeStr: "",
            EpisodeID: ""
        }
    });
}

/**
 * @description 初始化模板项目对话框
 */
function initiateTemplateItemDialog() {
    displayTemplateEditing.templateItemDialog = $("#item_dialog");
    displayTemplateEditing.templateItemDialog.dialog({
        onBeforeOpen: function() {

        },
        onOpen: function() {

        },
        onBeforeClose: function() {

        },
        onClose: function() {
            displayTemplateEditing.templateItemDialogForm.form("clear");
        }
    });

    initiateTemplateItemDialogForm();
    initiateTemplateItemDialogTool();
}

/**
 * @description 初始化模板项目编辑框中表单
 */
function initiateTemplateItemDialogForm() {
    var form = $(displayTemplateEditing.templateItemDialog).find("form");
    displayTemplateEditing.templateItemDialogForm = form;
    displayTemplateEditing.templateItemDialogForm.form({
        onValidate: function() {

        },
        onSubmit: function() {

        },
        onLoadSuccess: function(data) {
            form.items.ViewCat.combobox("setValue", data.ViewCat);
            form.items.ComOrd.combobox("setValue", data.ComOrd);
        }
    });

    form.items = {};
    form.items.ViewCat = $(form).find("input[name='ViewCat']");
    form.items.ComOrd = $(form).find("input[name='ComOrd']");
    form.items.Code = $(form).find("input[id='item_code']");
    form.items.Desc = $(form).find("input[id='item_desc']");
    form.items.SeqNo = $(form).find("input[id='item_seq_no']");

    form.items.ViewCat.combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCEViewCat&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCEViewCat"
        },
        onSelect: function(record) {
            form.items.ComOrd.combobox("reload", $URL +
                "?ClassName=web.DHCICUPara&QueryName=FindANCComOrd&ANCEViewCatId=" + record.ID + "&ComDesc=&ResultSetType=array");
        },
		onHidePanel: function () {//20190110 YuanLin 下拉框只能选择不允许手写
		var valueField = $(this).combobox("options").valueField;
		var val = $(this).combobox("getValue");
		var allData = $(this).combobox("getData");
		var result = true;
		if (val=="") result=false;
		for (var i = 0; i < allData.length; i++) {
			if (val == allData[i][valueField]) {
				result = false;
				break;
			}
		}
		if (result){
			$(this).combobox("clear");
			$.messager.alert("提示","请从下拉框选择","info");
			$(this).combobox("reload");
			return;
		}
        }
    });

    form.items.ComOrd.combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCComOrd&ANCEViewCatId=&ComDesc=&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCComOrd",
            ANCEViewCatId: "",
            ComDesc: ""
        },
        onSelect: function(record) {
            form.items.Code.val(record.Code);
            form.items.Desc.val(record.Desc);
        },
		onHidePanel: function () {//20190110 YuanLin 下拉框只能选择不允许手写
		var valueField = $(this).combobox("options").valueField;
		var val = $(this).combobox("getValue");
		var allData = $(this).combobox("getData");
		var result = true;
		if (val=="") result=false;
		for (var i = 0; i < allData.length; i++) {
			if (val == allData[i][valueField]) {
				result = false;
				break;
			}
		}
		if (result){
			$(this).combobox("clear");
			$.messager.alert("提示","请从下拉框选择","info");
			$(this).combobox("reload");
			return;
		}
        }
    });
	//YuanLin 20181227
	$("#ViewCat").combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCEViewCat&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCEViewCat"
        }
    });
	$("#ComOrd").combobox({
        textField: "Desc",
        valueField: "ID",
        url: $URL + "?ClassName=web.DHCICUPara&QueryName=FindANCComOrd&ANCEViewCatId=&ComDesc=&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUPara",
            QueryName: "FindANCComOrd",
            ANCEViewCatId: "",
            ComDesc: ""
        }
    });
}

function initiateTemplateItemDialogTool() {
    displayTemplateEditing.templateItemDialog.buttons = {};

    displayTemplateEditing.templateItemDialog.onSaveSuccess = function(response) {
        response = $.trim(response);
        if (response === "0") {
            displayTemplateEditing.templateItemGrid.datagrid("reload");
            displayTemplateEditing.templateItemDialog.dialog("close");
            $.messager.alert("保存模板项目成功！", "保存模板项目成功！");
        } else {
            $.messager.alert("保存模板项目错误!", "错误信息：<br/>" + response);
        }
    }

    displayTemplateEditing.templateItemDialog.buttons.ok = $("#item_dialog_okay");
    displayTemplateEditing.templateItemDialog.buttons.cancel = $("#item_dialog_cancel");

    displayTemplateEditing.templateItemDialog.buttons.ok.linkbutton({
        onClick: function() {
            if (displayTemplateEditing.templateItemDialogForm.form("validate")) {
                var data = displayTemplateEditing.templateItemDialogForm.serializeJson();
                if (data.ItemRowId) {
                    $.m({
                        ClassName: "web.DHCICUPara",
                        MethodName: "UpdateICUParaItem",
                        ICUPIComOrdDr: data.ComOrd,
                        ICUPISeqNo: data.SeqNo,
                        ICUPIViewCatDr: data.ViewCat,
                        ICUPICode: data.Code,
                        ICUPIDesc: data.Desc,
                        tICUPIId: data.TemplateRowId,
                        RowId3: data.ItemRowId
                    }, displayTemplateEditing.templateItemDialog.onSaveSuccess);
                } else {
                    $.m({
                        ClassName: "web.DHCICUPara",
                        MethodName: "AddICUParaItem",
                        ICUPIComOrdDr: data.ComOrd,
                        ICUPISeqNo: data.SeqNo,
                        ICUPIViewCatDr: data.ViewCat,
                        ICUPICode: data.Code,
                        ICUPIDesc: data.Desc,
                        ICUPIId: data.TemplateRowId
                    }, displayTemplateEditing.templateItemDialog.onSaveSuccess)
                }
            }
        }
    });

    displayTemplateEditing.templateItemDialog.buttons.cancel.linkbutton({
        onClick: function() {
            displayTemplateEditing.templateItemDialog.dialog("close");
        }
    });
}

/**
 * @description 初始化模板项目属性区域
 */
function initiateTemplateItemPropertyArea() {
    propertyArea.container = $("#property_container");
    propertyArea.propertyMenu = $("#property_split_menu");
    propertyArea.propertyMenu.menu({
        onClick: propertyArea.onMenuItemClick
    })
    propertyArea.propertyForm = $("#property_form");
    propertyArea.itemPropertyContainer = propertyArea.propertyForm.find("table tbody");
    propertyArea.saveButton = $("#property_save");
    propertyArea.saveButton.linkbutton({
        onClick: propertyArea.saveItemProperties
    })
	$("#PropertyAdd").combobox({
        textField: "tICUCPDesc",
        valueField: "tICUCPRowID",
        url: $URL + "?ClassName=web.DHCICUCProperty&QueryName=FindICUCProperty&ResultSetType=array",
        queryParams: {
            ClassName: "web.DHCICUCProperty",
            QueryName: "FindICUCProperty"          
        }
    });
     
     $("#PropertyItemAdd").linkbutton({
	      onClick:propertyArea.onMenuItemClick
	        
     })
	/*
    $.cm({
        ClassName: "web.DHCICUCProperty",
        QueryName: "FindICUCProperty",
        ResultSetType: "array"
    }, function(data) {
        propertyArea.properties = data;
        propertyArea.init();
    });
	*/
}

/**
 * @description 模板项目属性区域的构造对象
 */
var propertyArea = {
    /**
     * 属性区域容器
     */
    container: null,
    /**
     * 属性选择菜单
     */
    propertyMenu: null,
    /**
     * 属性填写表单
     */
    propertyForm: null,
    /**
     * 保存按钮
     */
    saveButton: null,
    /**
     * 属性值填写容器
     */
    itemPropertyContainer: null,
    /**
     * 所有属性项
     */
    properties: [],
    /**
     * 属性菜单项目ID前缀
     */
    propertyMenuItemPrefix: "property_menu_item_",
    /**
     * 初始化
     */
    init: function() {
        $.each(this.properties, function(index, row) {
            propertyArea.addMenuItem(row);
        });
    },
    /**
     * 添加菜单项目
     */
    addMenuItem: function(property) {
        if (propertyArea.propertyMenu) {
            var id = propertyArea.propertyMenuItemPrefix + property.tICUCPRowID;
            propertyArea.propertyMenu.menu("appendItem", {
                id: id,
                text: property.tICUCPDesc
            });
            $("#" + id).data("data", property);
        }
    },
    /**
     * 当点击菜单项目时处理
     */
    onMenuItemClick: function(item) {
       //var data = $(item.target).data("data");	
		var selectedTemplateItem = displayTemplateEditing.templateItemGrid.datagrid("getSelected");
		var value=$("#PropertyAdd").combobox("getValue");
		var text=$("#PropertyAdd").combobox("getText");
		var TItemDesc=selectedTemplateItem.TItemDesc
		var TDisplayItemID=selectedTemplateItem.TID				
		var selectID=selectedTemplateItem.TTemplateID
		var newItemProperty = {
            TTemplateID: selectID,
            TDisplayItemID: TDisplayItemID,
            TPropertyValueID: "",
            TPropertyItemID: value,
            TPropertyValue: "",
            TPropertyItemDesc: text,
            TDisplayItemDesc: TItemDesc
        };
       
        if (selectedTemplateItem) {			
			var areas= new Array();
			//var trList = $("#PropertyItemTale").children("tr");
			var trList = $(propertyArea.itemPropertyContainer).find('tr'); //YuanLin 20191104
			for (var i=0;i<trList.length;i++) {
				var tdArr = trList.eq(i).find("td");
					var PropertyItem1=tdArr.eq(0).find("label").text();
					var PropertyItem2=tdArr.eq(2).find("label").text();
					areas.push(PropertyItem1);
					areas.push(PropertyItem2);			
				}
			if(areas.indexOf(newItemProperty.TPropertyItemDesc)==-1){
				    propertyArea.addItemProperty(newItemProperty);
				}else{
					
					$.messager.alert("提示", "已有该属性！");
					}
		}
    },
    /**
     * 隐藏菜单项目
     */
    hideMenuItem: function(propertyId) {
        var menuItem = propertyArea.propertyMenu.menu("getItem", $("#" + propertyArea.propertyMenuItemPrefix + propertyId));
        $(menuItem.target).hide();
    },
    /**
     * 显示菜单项目
     */
    showMenuItem: function(propertyId) {
        var menuItem = propertyArea.propertyMenu.menu("getItem", $("#" + propertyArea.propertyMenuItemPrefix + propertyId));
        $(menuItem.target).show();
    },
    /**
     * 显示所有菜单项目
     */
    showAllMenuItem: function() {
        $.each(propertyArea.properties, function(index, row) {
            propertyArea.showMenuItem(row.tICUCPRowID);
        });
    },
    /**
     * 渲染方法
     */
    render: function(itemProperties) {
        propertyArea.itemPropertyContainer.empty();
        propertyArea.showAllMenuItem();
        $.each(itemProperties, function(index, row) {
            propertyArea.addItemProperty(row);
        });
    },
    /**
     * 清空所有模板项目属性的显示
     */
    emptyItemPropertyContainer: function() {
        propertyArea.itemPropertyContainer.empty();
        propertyArea.refreshTitle("");
        propertyArea.saveButton.linkbutton("disable");
    },
    /**
     * 通过属性项和模板项得到一个新的属性值对象
     */
    getItemProperty: function(property, item) {
        var newItemProperty = {
            TTemplateID: item.TTemplateID,
            TDisplayItemID: item.TID,
            TPropertyValueID: "",
            TPropertyItemID: property.tICUCPRowID,
            TPropertyValue: "",
            TPropertyItemDesc: property.tICUCPDesc,
            TDisplayItemDesc: item.TItemDesc
        };

        return newItemProperty;
    },
    /**
     * 添加表单属性值填写
     */
    addItemProperty: function(itemProperty) {
		this.propertyCount=(this.propertyCount||0)+1;
		var rows=$(this.itemPropertyContainer).find('tr');
		var lastRow=rows[rows.length-1];
		var input;
		if (lastRow&&this.propertyCount%2==0){
			input = $("<input class = \"hisui-validatebox textbox\" type = \"text\" data-options = \"width:150\" style=\"margin-top:4px;\" value=\"" + itemProperty.TPropertyValue + "\">");
			$("<td width=160 style=\"text-align:right;padding-right:7px;\"><label>" + itemProperty.TPropertyItemDesc + "</label></td>").append(input)
			    .appendTo(lastRow)
				.data("data",itemProperty);
			$("<td class='property-cell'></td>").append(input)
			    .appendTo(lastRow)
				.data("data",itemProperty);
			//$("<td width=160 style=\"text-align: right;padding-right:7px;\"><label>" + itemProperty.TPropertyItemDesc + "</label></td><td class='property-cell'><input class = \"hisui-validatebox textbox\" type = \"text\" data-options = \"width:150\" style=\"margin-top:1px;\" value=\"" + itemProperty.TPropertyValue + "\"></td>").append("<td></td>").appendTo(lastRow).data("data",itemProperty);
		}
		else{
			var itemPropertyHtml = $("<tr></tr>");
            input = $("<input class = \"hisui-validatebox textbox\" type = \"text\" data-options = \"width:150\" style=\"margin-top:4px;\" value=\"" + itemProperty.TPropertyValue + "\">");
            itemPropertyHtml.append("<td width=160 style=\"text-align:right;padding-right:7px;\"><label>" + itemProperty.TPropertyItemDesc + "</label></td>");
            itemPropertyHtml.append($("<td></td>").append(input));
            itemPropertyHtml.data("data", itemProperty);
            $(propertyArea.itemPropertyContainer).append(itemPropertyHtml);
        }
        input.validatebox({
        });

        propertyArea.hideMenuItem(itemProperty.TPropertyItemID);
        propertyArea.saveButton.linkbutton("enable");
    },
    /**
     * 保存模板项目属性
     */
    saveItemProperties: function() {
        var itemProperties = [];
        var counter = 0,
            total = 0,
            errorCounter = 0;

        propertyArea.itemPropertyContainer.find(".property-cell").each(function(index, e) {
            var itemProperty = $(e).data("data");
            var input = $(e).find("input");
            itemProperty.TPropertyValue = input.val();
            itemProperties.push(itemProperty);
        });
		propertyArea.itemPropertyContainer.find('tr').each(function(index, e) {
            var itemProperty = $(e).data("data");
            var input = $(e).find("input");
            itemProperty.TPropertyValue = input.val();
            itemProperties.push(itemProperty);
        });

        if (itemProperties.length) {
            $.each(itemProperties, function(index, row) {
                if (row.TPropertyValue.length > 0) {
					//20190110 YuanLin 部分模板属性只能填写true/false
					if(row.TPropertyItemDesc.indexOf("是否")>=0){
						if(row.TPropertyValue!=="true"){
							if(row.TPropertyValue!=="false"){
								$.messager.alert("提示", row.TPropertyItemDesc+"只能填写true/false");
								return;
							}
						}
					}
					if(row.TPropertyItemDesc==="显示简写"){
						if(row.TPropertyValue!=="true"){
							if(row.TPropertyValue!=="false"){
								$.messager.alert("提示", row.TPropertyItemDesc+"只能填写true/false");
								return;
							}
						}
					}
                    if (row.TPropertyValueID === "") {
                        insert(row);
                        total++;
                    } else {
                        update(row);
                        total++;
                    }
                } else {
                    if (row.TPropertyValueID === "") {} else {
                        remove(row);
                        total++;
                    }
                }
            })
        }

        function insert(row) {
            $.m({
                ClassName: "web.DHCICUPara",
                MethodName: "AddICUParaItemDetails",
                ICUPIDICUCPDr: row.TPropertyItemID,
                ICUPIDValue: row.TPropertyValue,
                IcuParaItemId: row.TDisplayItemID
            }, function(response) {
                counter++;
                response = $.trim(response);
                if (response !== "0") {
                    $.messager.alert("Error!", response);
                    errorCounter++;
                }
                if (counter == total) {
                    $.messager.alert("提示", "保存成功！");
                }
            })
        }

        function update(row) {
            $.m({
                ClassName: "web.DHCICUPara",
                MethodName: "UpdateICUParaItemDetails",
                IcuParaItemDetailsId: row.TPropertyValueID,
                ICUPIDICUCPDr: row.TPropertyItemID,
                ICUPIDValue: row.TPropertyValue,
                IcuParaItemId: row.TDisplayItemID
            }, function(response) {
                counter++;
                response = $.trim(response);
                if (response !== "0") {
                    $.messager.alert("Error!", response);
                    errorCounter++;
                }
                if (counter == total) {
                    $.messager.alert("提示", "保存成功！");
                }
            })
        }

        function remove(row) {
            $.m({
                ClassName: "web.DHCICUPara",
                MethodName: "DeleteICUParaItemDetails",
                IcuParaItemDetailsId: row.TPropertyValueID
            }, function(response) {
                counter++;
                response = $.trim(response);
                if (response !== "0") {
                    $.messager.alert("Error!", response);
                    errorCounter++;
                }
                if (counter == total) {
                    if (errorCounter) $.messager.alert("保存错误！", "保存过程中发生错误！");
                    else $.messager.alert("提示", "保存成功！");
                }
            })
        }
    },
    /**
     * 通过属性项获取属性
     */
    getPropertyById: function(propertyId) {

    },
    /**
     * 更新属性区域标题
     */
    refreshTitle: function(itemName) {
        propertyArea.container.panel({
            title: "模板项目属性" + (itemName === "" ? "" : (" - " + itemName))
        })
    }
};

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