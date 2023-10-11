/// bill.einv.invupconfig.js

$(function () {   
    //设置发票列表信息
    SetPatInfoItem();
});

function importData() {
	//功能说明：导入字典信息
    var UserDr = "1";
    var GlobalDataFlg = "0"; //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
    var ClassName = "BILL.EINV.BL.COM.InvUpConfigCtl"; //导入处理类名
    var MethodName = "ImportInvUpConfigByExcel"; //导入处理方法名
    var ExtStrPam = ""; //备用参数()
    ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
}

//获取父窗口datagrid选择数据
function GetInvUpConfig(ID) {
    $m({
        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
        MethodName: "getInvUpConfigInfo",
        ID: ID
    }, function (value) {
        if (value == "") {
            return;
        }
        var rtnAry = value.split('^');
        $('#IUCServer').val(rtnAry[0]);
        $('#IUCPort').val(rtnAry[1]);
        $('#IUCTimeout').val(rtnAry[2]);
        $('#IUCSerPath').val(rtnAry[3]);
        $('#IUCVersion').val(rtnAry[4]);
        $('#IUCAPPID').val(rtnAry[5]);
        $('#IUCSecretKey').val(rtnAry[6]);
        $('#IUCInvoiceType').combobox('setValue', rtnAry[7]);
        $('#IUCActiveFlag').combobox('setValue', rtnAry[8]);
        $('#IUCUploadWay').combobox('setValue', rtnAry[9]);
        $('#IUCStyle').combobox('setValue', rtnAry[10]);
        $('#FactoryCode').combobox('setValue', rtnAry[12]);
      	$('#Hospital').combobox('setValue', rtnAry[14]);
    });
}

//加载数据
function loadInvConfig() {
    $('#invList').datagrid('load', {
        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
        QueryName: "QueryInvUpConfigInfo"
    });
}

//增加
function addData() {
    $('#add').show().dialog({
        title: "添加数据",
        iconCls: 'icon-w-add',
        closable: false,
        onBeforeOpen: function() {
	    	initinvconfigCombo();
	    },
        buttons: [{
                text: '保存',
                handler: function () {
                    //获取弹出框的值的串
                    var DataStr = $("IUCServer").val() + "^" + $("#IUCPort").val() + "^" + $("#IUCTimeout").val() + "^" +
                        $("#IUCSerPath").val() + "^" + $("#IUCVersion").val() + "^" + $("#IUCAPPID").val() + "^" + $("#IUCSecretKey").val() + "^" +
                        $('#IUCInvoiceType').combobox('getValue') + "^" + $('#IUCActiveFlag').combobox('getValue') + "^" + $('#IUCUploadWay').combobox('getValue') + "^" + $('#IUCStyle').combobox('getValue') + "^" + $('#Hospital').combobox('getValue') + "^" +
                        $('#FactoryCode').combobox('getValue') + "^" + $('#FactoryCode').combobox('getText');
                    $m({
                        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                        MethodName: "SaveInvUpConfigInfo",
                        DataStr: DataStr
                    }, function (value) {
                        if (value.length != 0) {
                            $.messager.alert('提示', value);
                            loadInvConfig();
                        } else {
                            $.messager.alert('提示', '服务器错误');
                        }
                    });
                    $('#add').dialog('close');
                }
            }, {
                text: '关闭',
                handler: function () {
                    $('#add').dialog('close');
                }
            }
        ]
    });
}

//增加信息中的下拉框
function initinvconfigCombo() {
    $('#IUCInvoiceType').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'E',
                text: '电子票据',
                selected: true
            }, {
                value: 'P',
                text: '纸质发票'
            }
        ]
    }),
    $('#IUCActiveFlag').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'Y',
                text: '启用',
                selected: true
            }, {
                value: 'N',
                text: '关闭'
            }
        ]
    }),
    $('#IUCUploadWay').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'N',
                text: '实时',
                selected: true
            }, {
                value: 'B',
                text: '批量'
            }
        ]
    }),
    $('#IUCStyle').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'V',
                text: '增值税发票',
                selected: true
            }, {
                value: 'C',
                text: '普票'
            }
        ]
    }),
    
    $('#Hospital').combobox({
        panelHeight: 160,
        valueField: 'id',
        textField: 'text',
        url: $URL + '?ClassName=BILL.EINV.BL.COM.InvUpConfigCtl&QueryName=QryHospital&ResultSetType=array',
        blurValidValue: true,
        value: session['LOGON.HOSPID']
    });
    
    $HUI.combobox('#FactoryCode', {
	 	panelHeight: 'auto',
        valueField: 'DicCode',
        textField: 'DicDesc',
        url: $URL + '?ClassName=BILL.EINV.BL.COM.DicDataCtl&QueryName=QueryDicDataInfo&ResultSetType=array',
        editable: false,
        onBeforeLoad: function (param) {
            param.Type = "EInv_Factory_List";
        },
        onLoadSuccess: function () {
            $('#FactoryCode').combobox('setValue', 'BS');
        }
    });
}

//删除
function removeData() {
    var selectedRow = $('#invList').datagrid('getSelected');
    if (!selectedRow) {
        $.messager.alert('提示', '请选择需要删除的行');
        return;
    }
    $.messager.confirm('提示', '您确定要删除该条记录吗?', function (r) {
        if (r) {
            var ID = selectedRow.ID;
            $m({
                ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                MethodName: "DeleteInvUpConfigInfo",
                ID: ID
            }, function (value) {
                if (value.length != 0) {
                    $.messager.alert('提示', value);
                    loadInvConfig();
                } else {
                    $.messager.alert('提示', '服务器错误')
                }
            });
        }
    });
}

//更新
function updateData() {
    var selectedRow = $('#invList').datagrid('getSelected');
    if (!selectedRow || !selectedRow.ID) {
        $.messager.alert('提示', '请选择需要修改的行');
        return;
    }
    var ID = selectedRow.ID;
    $('#add').show().dialog({
        title: "修改数据",
        iconCls: 'icon-w-edit',
        closable: false,
        onBeforeOpen: function() {
	   		initinvconfigCombo();
	   		//获取数据
	     	GetInvUpConfig(ID);
	    },
        buttons: [{
                text: '保存',
                handler: function () {
                    //获取弹出框的值的串
                    var DataStr = ID + "^" + $("#IUCServer").val() + "^" + $("#IUCPort").val() + "^" + $("#IUCTimeout").val() + "^" +
                        $("#IUCSerPath").val() + "^" + $("#IUCVersion").val() + "^" + $("#IUCAPPID").val() + "^" + $("#IUCSecretKey").val() + "^" +
                        $('#IUCInvoiceType').combobox('getValue') + "^" + $('#IUCActiveFlag').combobox('getValue') + "^" + $('#IUCUploadWay').combobox('getValue') + "^" + $('#IUCStyle').combobox('getValue') + "^" + $('#Hospital').combobox('getValue') + "^" +
                        $('#FactoryCode').combobox('getValue') + "^" + $('#FactoryCode').combobox('getText');
                    $m({
                        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                        MethodName: "UpdateInvUpConfigInfo",
                        DataStr: DataStr
                    }, function (value) {
                        if (value.length != 0) {
                            $.messager.alert('提示', value);
                            loadInvConfig();
                        } else {
                            $.messager.alert('提示', '服务器错误');
                        }
                    });
                    $('#add').dialog('close');
                }
            }, {
                text: '关闭',
                handler: function () {
                    $('#add').dialog('close');
                    $('#invList').datagrid('clearSelections');
                    clearDialog();
                }
            }
        ]
    });
}

//清除内容
function clearDialog() {
    $('#IUCServer').val("");
    $('#IUCPort').val("");
    $('#IUCTimeout').val("");
    $('#IUCSerPath').val("");
    $('#IUCVersion').val("");
    $('#IUCAPPID').val("");
    $('#IUCSecretKey').val("");
    $('#IUCInvoiceType').combobox('setValue', 'E');
    $('#IUCActiveFlag').combobox('setValue', 'Y');
    $('#IUCUploadWay').combobox('setValue', 'N');
    $('#IUCStyle').combobox('setValue', 'V');
    $('#Hospital').combobox('setValue', '');
    $('#FactoryCode').combobox('setValue', 'BS');
}

//设置发票列表信息
function SetPatInfoItem() {
    $('#invList').datagrid({
		fit: true,
		striped: true,
		singleSelect: true,
		bodyCls: 'panel-body-gray',
        pagination: true,
        pageSize: 20,
        rownumbers: true,
    	toolbar: [{
                iconCls: 'icon-add',
                text: '增加',
                handler: addData
            }, {
                iconCls: 'icon-write-order',
                text: '修改',
                handler: updateData
            }, {
                iconCls: 'icon-remove',
                text: '删除',
                handler: removeData
            }, {
                iconCls: 'icon-import',
                text: '导入',
                handler: importData
            }
        ],
     	columns: [[{
                    field: 'ID',
                    title: 'ID',
                    hidden: true
                }, {
                    field: 'FactoryCode',
                    title: '开发商编码',
                    width: 100
                }, {
                    field: 'FactoryDesc',
                    title: '开发商名称',
                    width: 100
                }, {
                    field: 'IUCAPPID',
                    title: '应用帐号',
                    width: 150
                }, {
                    field: 'IUCActiveFlag',
                    title: '是否启用',
                    width: 80,
                    formatter: function (value) {
	                    return (value == "Y") ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
                    }
                }, {
                    field: 'IUCInvoiceType',
                    title: '票据监管类型',
                    width: 100,
                    formatter: function (value) {
                        if (value == "E") {
                            return "电子票据";
                        } else {
                            return "纸质发票";
                        }
                    }
                }, {
                    field: 'IUCPort',
                    title: '端口号',
                    width: 80
                }, {
                    field: 'IUCSecretKey',
                    title: '单位校验KEY',
                    width: 180
                }, {
                    field: 'IUCSerPath',
                    title: '路径',
                    width: 180
                }, {
                    field: 'IUCServer',
                    title: '票据服务器地址',
                    width: 130
                }, {
                    field: 'IUCStyle',
                    title: '票据种类',
                    width: 120,
                    formatter: function (value) {
                        if (value == "V") {
                            return "增值税发票";
                        } else {
                            return "普票";
                        }
                    }
                }, {
                    field: 'IUCTimeout',
                    title: '服务延时',
                    width: 100
                }, {
                    field: 'IUCUploadWay',
                    title: '票据开具或上传方式',
                    width: 150,
                    formatter: function (value) {
                        if (value == "N") {
                            return "实时";
                        } else {
                            return "批量";
                        }
                    }
                }, {
                    field: 'IUCVersion',
                    title: '版本号',
                    width: 80
                }, {
                    field: 'HospDesc',
                    title: '医院',
                    width: 100
                }
            ]],
        url: $URL,
        queryParams: {
            ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
            QueryName: "QueryInvUpConfigInfo"
        }
    });
}