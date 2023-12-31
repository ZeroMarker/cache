/**
 * 通用数据表单
 * @param {Object} options - 数据表单初始化选项
 * @author chenchangqing 20170811
 */
function DataForm(options) {
    this.options = options;
    //this.initDataForm();
}

/**
 * 数据表单原型对象
 * @author chenchangqing 20170811
 */
DataForm.prototype = {
    constructor: DataForm,
    /**
     * 初始化数据表单
     * @author chenchangqing 20170811
     */
    initDataForm: function() {
        this.datagrid = this.options.datagrid;
        this.form = this.options.form;
        this.datamodel = {
            idName: this.options.modelIdName ? this.options.modelIdName : "RowId",
            type: this.options.modelType,
            queryName: this.options.queryName,
            queryType: this.options.queryType
        };
        this.addButton = this.options.addButton;
        this.editButton = this.options.editButton;
        this.delButton = this.options.delButton;
        this.queryButton = this.options.queryButton;
        this.saveButton = this.options.saveButton;
        this.clearButton=this.options.clearButton;
        this.dialog = this.options.dialog;

        this.datagridSelectCallBack=this.options.datagridSelectCallBack;
        this.submitAction=this.options.submitAction;
        this.delAction=this.options.delAction;
        this.curAction="";

        this.initDelegates();
        this.initDataGrid();
        this.initForm(this.options.submitCallBack, this.options.onSubmitCallBack);
        this.initDialog(this.options.openCallBack, this.options.closeCallBack);
    },

    /**
     * 初始化按钮点击处理函数
     * @author chenchangqing 20170811
     */
    initDelegates: function() {
        var dataForm = this;
        if (this.addButton) {
            this.addButton.linkbutton({
                onClick: function() {
                    var precondition=true;
                    if(dataForm.beforeAddCallBack){
                        precondition=dataForm.beforeAddCallBack();
                    }
                    if(precondition){
                        dataForm.addData(dataForm);
                    }
                    
                }
            });
        }
        if (this.editButton) {
            this.editButton.linkbutton({
                onClick: function() {
                    console.log(dataForm);
                    dataForm.editData(dataForm);
                }
            });
        }
        if (this.delButton) {
            this.delButton.linkbutton({
                onClick: function() {
                    dataForm.delData(dataForm);
                }
            })
        }
        if (this.queryButton) {
            this.queryButton.linkbutton({
                onClick: function() {
                    dataForm.queryData(dataForm);
                }
            })
        }

        if (this.saveButton) {
            this.saveButton.linkbutton({
                onClick: function() {
                    dataForm.saveData(dataForm);
                }
            });
        }

        if(this.clearButton){
            this.clearButton.linkbutton({
                onClick:function(){
                    dataForm.clearForm(dataForm);
                }
            });
        }
    },

    /**
     * 初始化数据表格
     * @author chenchangqing 20170811
     */
    initDataGrid: function() {
        var dataForm = this;
        var singleSelect=dataForm.options.singleSelect;
        if (singleSelect===undefined || singleSelect===null){
            singleSelect=true;
        }
        this.datagrid.datagrid({
            iconCls:"icon-template",
            headerCls: 'panel-header-gray',
            title: dataForm.options.gridTitle,
            columns: dataForm.options.gridColumns,
            fit: true,
            singleSelect: singleSelect,
            rownumbers: true,
            pagination: (dataForm.options.pagination!==undefined)?dataForm.options.pagination:true,
            pageList: [10, 20, 30, 40, 50, 100, 200],
            pageSize: 200,
            toolbar: dataForm.options.gridTool,
            url: ANCSP.DataQuery,
            queryParams: $.extend({
                ClassName: dataForm.datamodel.queryType,
                QueryName: dataForm.datamodel.queryName,
                ArgCnt: 0
            }, dataForm.options.queryParams || {}),
            onSelect: function(index, row) {
                dataForm.form.form("load", row);
                if(dataForm.datagridSelectCallBack){
                    dataForm.datagridSelectCallBack(row);
                }
            }
        });
    },

    /**
     * 初始化编辑表单
     * @param {function} callback - 提交成功后的回调函数
     * @author chenchangqing 20170811
     */
    initForm: function(callback, onSubmitCallBack) {
        var dataForm = this;
        if (dataForm.form) {
            dataForm.form.form({
                url: dhccl.csp.dataService,
                onSubmit: function(param) {
                    param.ClassName = dataForm.datamodel.type;
                    if (onSubmitCallBack) {
                        onSubmitCallBack(param);
                    }
                    var isValid = $(this).form("validate");
                    if(dataForm.submitAction && isValid){
                        if(dataForm.curAction==="Add"){
                            param.RowId="";
                        }
                        dataForm.submitAction(param);
                        return false;
                    }
                    
                    return isValid;
                },
                // queryParams: {
                //     ClassName: this.datamodel.type  //queryParams 支持1.4以上版本
                // },
                success: function(data) {
                    dataForm.form.form("clear");
                    if (callback) {
                        callback(data);
                    }
                    dataForm.datagrid.datagrid("reload");
                    if (dataForm.dialog) {
                        dataForm.dialog.dialog("close");
                    }
                }
            });
        }
    },

    /**
     * 初始化编辑表单对话框
     * @param {function} openCallBack - 打开对话框时调用的回调函数
     * @param {function} closeCallBack - 关闭对话框时调用的回调函数
     * @author chenchangqing 20170811
     */
    initDialog: function(openCallBack, closeCallBack) {
        var dataForm = this;
        if (!dataForm.dialog) return;
        dataForm.dialog.dialog({
            buttons: [{
                text: "保存",
                iconCls: "icon-w-save",
                handler: function() {
                    dataForm.form.submit();
                }
            }, {
                text: "取消",
                iconCls: "icon-w-cancel",
                handler: function() {
                    dataForm.dialog.dialog("close");
                }
            }],
            onClose: function() {
                dataForm.form.form("clear");
                if (closeCallBack) closeCallBack();
            },
            onOpen: function() {
                if (openCallBack) openCallBack(dataForm);
            }
        });
    },

    /**
     * 新增按钮处理函数
     * @param {DataForm} dataForm - 数据表单对象
     * @author chenchangqing 20170811
     */
    addData: function(dataForm) {
        //var dataForm = this;
        dataForm.curAction="Add";
        if (dataForm.dialog) {
            dataForm.dialog.dialog({
                title: dataForm.options.addTitle?dataForm.options.addTitle:"新增",
                iconCls: "icon-add"
            });
            if (dataForm.form[0].RowId) {
                dataForm.form[0].RowId.value = "";
            }
            dataForm.dialog.dialog("open")
        } else {
            if (dataForm.form[0].RowId) {
                dataForm.form[0].RowId.value = "";
            }
            dataForm.form.submit();
        }
    },

    /**
     * 修改按钮处理函数
     * @param {DataForm} dataForm - 数据表单对象
     * @author chenchangqing 20170811
     */
    editData: function(dataForm) {

        if (dataForm.hasRowSelected(true)) {
            dataForm.curAction="Edit";
            if (dataForm.dialog) {
                dataForm.dialog.dialog({
                    title: dataForm.options.editTitle?dataForm.options.editTitle:"修改",
                    iconCls: "icon-edit"
                });
                var selectedRow = dataForm.datagrid.datagrid("getSelected");
                dataForm.form.form("load", selectedRow);
                dataForm.dialog.dialog("open")
            } else {
                dataForm.form.submit();
            }
        }
    },

    /**
     * 保存按钮处理函数
     * @param {DataForm} dataForm - 数据表单对象
     * @author chenchangqing 20170811
     */
    saveData: function(dataForm) {
        if (dataForm.dialog) {
            dataForm.dialog.dialog({
                title: dataForm.options.saveTitle?dataForm.options.saveTitle:"保存",
                iconCls: "icon-save"
            });
            var selectedRow = dataForm.datagrid.datagrid("getSelected");
            dataForm.form.form("load", selectedRow);
            dataForm.dialog.dialog("open")
        } else {
            dataForm.form.submit();
        }
    },

    /**
     * 删除按钮处理函数
     * @param {DataForm} dataForm - 数据表单对象
     * @author chenchangqing 20170811
     */
    delData: function(dataForm) {
        if (dataForm.hasRowSelected(true)) {
            dataForm.curAction="Del";
            $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
                if (result) {
                    if(dataForm.delAction){
                        dataForm.delAction();
                    }else{
                        var selectedRow = dataForm.datagrid.datagrid("getSelected");
                        var rowId = selectedRow[dataForm.datamodel.idName];
                        var msg = dhccl.removeData(dataForm.datamodel.type, rowId);
                        dhccl.showMessage(msg, "删除", null, null, function() {
                            dataForm.form.form("clear");
                            dataForm.datagrid.datagrid("reload");
                            if (dataForm.options.delCallBack) {
                                dataForm.options.delCallBack();
                            }
                        });
                    }
                    
                }
            });
        }
    },

    /**
     * 查询按钮处理函数
     * @param {DataForm} dataForm - 数据表单对象
     * @author chenchangqing 20170811
     */
    queryData: function(dataForm) {
        dataForm.datagrid.datagrid("reload");
    },

    clearForm:function(dataForm){
        dataForm.form.form("clear");
    },

    /**
     * 判断数据表格是否选中一行
     * @param {string} showPrompt - 未选中行时是否提示
     * @param {object} selectedRow - 选中行的对象
     * @author chenchangqing 20170811
     */
    hasRowSelected: function(showPrompt) {
        var result = false;
        if (this.datagrid) {
            var selectedRow = this.datagrid.datagrid("getSelected");
            if (selectedRow) {
                result = true;
            } else {
                result = false;
            }
        }
        if (!result && showPrompt) {
            $.messager.alert("提示", "请先选择一行再进行操作！", "warning");
        }
        return result;
    }
}