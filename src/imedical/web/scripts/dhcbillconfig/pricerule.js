/*
 * FileName:	pricerule.js
 * User:		tanfb
 * Date:		2022-11-30
 * Function:
 * Description: 收费优惠类型维护
 */

var GV =
{
	SelectEdIndexR: -1,
    EditIndexR: -1,
    SelectEdIndexA: -1,
    EditIndexA: -1,
    RuleId: "", //新增优惠条件时的优惠类型指针
    RuleTypeId: "", //选中优惠条件的优惠分类ID
    AllowPointCode: "AdmLoc"
}

$(function ()
{

    initHospital();	//初始化医院下拉框
    initRuleDg();	//初始化优惠类型表格
    loadRuleDg();	//优惠类型表格加载数据
    initAllowPointDg();	//初始化优惠条件表格
    loadAllowPointDg();	//优惠条件表格加载数据
    initQueryMenu();	//判断按钮是否按下

});

//判断按钮是否按下
function initQueryMenu(){
	
	//回车查询事件
	$("#search").keydown(function (e){
    	var key = websys_getKey(e);
    	if (key == 13)
    	{
        	loadRuleDg();
    	}
	});
	
	// 查询
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			FindRule();
		}
	});
	
	// 优惠类型新增
	$HUI.linkbutton("#rBtnAdd", {
		onClick: function () {
			AddRule();
		}
	});
	
	// 优惠类型修改
	$HUI.linkbutton("#rBtnUpdate", {
		onClick: function () {
			UpdateRule();
		}
	});
	
	// 优惠类型保存
	$HUI.linkbutton("#rBtnSave", {
		onClick: function () {
			SaveRule();
		}
	});
	
	// 优惠条件新增
	$HUI.linkbutton("#aBtnAdd", {
		onClick: function () {
			AddAllowPoint();
		}
	});
	
	// 优惠条件修改
	$HUI.linkbutton("#aBtnUpdate", {
		onClick: function () {
			UpdateAllowPoint();
		}
	});
	
	// 优惠条件保存
	$HUI.linkbutton("#aBtnSave", {
		onClick: function () {
			SaveAllowPoint();
		}
	});
	
	// 优惠类型停用
	$HUI.linkbutton("#rBtnStop", {
		onClick: function () {
			StopRule();
		}
	});
	
	// 优惠条件停用
	$HUI.linkbutton("#aBtnStop", {
		onClick: function () {
			StopAllowPoint();
		}
	});
	
	// 优惠条件导入
	$HUI.linkbutton("#btnImport", {
		onClick: function () {
			Import();
		}
	});
	
	// 优惠条件导出
	$HUI.linkbutton("#btnExport", {
		onClick: function () {
			Export();
		}
	});
	
}

//初始化优惠类型表格
function initRuleDg()
{
    var dgColumns = [[
            {
                field: 'ROWID',
                title: 'ROWID',
                width: 70,
                hidden: true
            },
            {
                field: 'RuleCode',
                title: '优惠代码',
                width: 70,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'RuleDesc',
                title: '优惠名称',
                width: 100,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'Priority',
                title: '优先级',
                width: 90,
                editor:
                {
                    type: 'combobox',
                    options:
                    {
                        valueField: 'DicCode',
                        textField: 'DicDesc',
                        editable: false,
                        url: $URL,
                        onBeforeLoad: function (param)
                        {
                            param.ClassName = "BILL.CFG.COM.DictionaryCtl";
                            param.QueryName = "QueryDicDataInfo";
                            param.Type = "PriceManageRulePriority";
                            param.KeyCode = "";
                            param.ResultSetType = 'array'
                        },
                    }
                }
            },
            {
                field: 'AllowAddDesc',
                title: '是否允许叠加',
                width: 100,
                editor:
                {
                    type: 'combobox',
                    options:
                    {
                        valueField: 'DicCode',
                        textField: 'DicDesc',
                        editable: false,
                        url: $URL,
                        onBeforeLoad: function (param)
                        {
                            param.ClassName = "BILL.CFG.COM.DictionaryCtl";
                            param.QueryName = "QueryDicDataInfo";
                            param.Type = "YesOrNo";
                            param.KeyCode = "";
                            param.ResultSetType = 'array'
                        },
                        onLoadSuccess: function (data)
                        {
                            //$(this).combobox('select', defHospId);
                        },
                        onSelect: function (data)
                        {
                            var ed = $('#ruleTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndexR,
                                    field: 'AllowAddCode'
                                }
                                );
                            ed.target[0].value = data.DicCode;
                        }
                    }
                }
            },
            {
                field: 'ActiveStartDate',
                title: '生效日期',
                width: 120,
                editor:
                {
                    type: 'datebox',                    
                    options:
                    {
                    	onShowPanel : function () 
                    	{
	                    	setDateRange("ruleTable",GV.EditIndexR);
                    	}
                    }
                }
            },
            {
                field: 'ActiveEndDate',
                title: '失效日期',
                width: 120,
                editor:
                {
                    type: 'datebox',             
                }
            },
            {
                field: 'RuleTypeDesc',
                title: '优惠分类',
                width: 100,
                editor:
                {
                    type: 'combobox',
                    options:
                    {
                        valueField: 'DicCode',
                        textField: 'DicDesc',
                        editable: false,
                        url: $URL,
                        onBeforeLoad: function (param)
                        {
                            param.ClassName = "BILL.CFG.COM.DictionaryCtl";
                            param.QueryName = "QueryDicDataInfo";
                            param.Type = "PriceManageRuleType";
                            param.KeyCode = "";
                            param.ResultSetType = 'array'
                        },
                        onSelect: function (data)
                        {
                            var ed = $('#ruleTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndexR,
                                    field: 'RuleTypeCode'
                                });
                            ed.target[0].value = data.DicCode;
                        }
                    }
                }
            },
            {
                field: 'Rate',
                title: '建议比例',
                width: 70,
                align: 'right',
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'Amt',
                title: '建议金额',
                width: 70,
                align: 'right',
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'Memo',
                title: '备注',
                width: 90,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'AllowAddCode',
                title: 'AllowAddCode',
                width: 150,
                hidden: true,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'RuleTypeCode',
                title: 'RuleTypeCode',
                width: 150,
                hidden: true,
                editor:
                {
                    type: 'text'
                }
            },
        ]];

    $('#ruleTable').datagrid(
    {
        fit: true,
        fitColumns: false,
        border: false,
        striped: false,
        singleSelect: true,
        pagination: true,
        rownumbers: false,
        pageSize: 20,
        columns: dgColumns,
        toolbar: '#rToolBar',
        onLoadSuccess: function (data)
        {
            GV.SelectEdIndexR = -1;
            GV.EditIndexR = -1;
        },
        onSelect: function (index, rowData)
        {
            GV.SelectEdIndexR = index;
            GV.RuleId = rowData.ROWID;
            var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl", "getIDByTypeValue", "PriceManageRuleType", rowData.RuleTypeCode);
            GV.RuleTypeId = rtn.split("^")[1];
            loadAllowPointDg();
        },
        onUnselect: function (index, rowData)
        {
            GV.SelectEdIndexR = -1;
        },
        onDblClickRow: function (index, rowData)
        {
	        
            loadAllowPointDg(rowData.ROWID);
            GV.SelectEdIndexR = index;
            GV.RuleId = rowData.ROWID;
            UpdateRule();
        },
    }
    );
}

//初始化优惠条件表格
function initAllowPointDg()
{
    var dgColumns = [[
            {
                title: '选择',
                field: 'CheckOrd',
                checkbox: true,
                width: 50,
                showTip: true
            },
            {
                field: 'RuleId',
                title: '优惠类型指针',
                width: 70,
                hidden: true,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'AllowPointCode',
                title: '准入点代码',
                width: 90,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'AllowPointDesc',
                title: '条件',
                width: 100,
                editor:
                {
                    type: 'combobox',
                    options:
                    {
                        valueField: 'desc',
                        textField: 'desc',
                        editable: false,
                        url: $URL,
                        onBeforeLoad: function (param)
                        {
                            param.ClassName = "BILL.CFG.COM.GeneralCfg";
                            param.QueryName = "GetResultForQuery";
                            param.RelaCode = "PROMGT.RuleTypeMatain.YHTJPZ";
                            param.SourceData = GV.RuleTypeId;
                            param.TgtData = "";
                            param.HospId = getValueById('hospital');
                            param.ResultSetType = 'array'
                        },
                        onSelect: function (data)
                        {
                            var ed = $('#AllowPointTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndexA,
                                    field: 'AllowPointCode'
                                }
                                );
                            ed.target[0].value = data.code;
                            GV.AllowPointCode = data.code;
                            var ed = $('#AllowPointTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndexA,
                                    field: 'ConfigDesc'
                                }
                                );
                            $(ed.target).combobox("reload");
                        },
                        onLoadSuccess: function (data)
                        {
                        }
                    }
                }
            },
            {
                field: 'ConfigValue',
                title: '条件值',
                width: 100,
                editor:
                {
                    type: 'text'
                }
            },
            {
                field: 'ConfigDesc',
                title: '值描述',
                width: 100,
                editor:
                {
                    type: 'combobox',
                    options:
                    {
                        panelHeight: 150,
                        url: $URL,
                        editable: true,
                        valueField: 'desc',
                        textField: 'desc',
                        defaultFilter: 4,
                        onBeforeLoad: function (param)
                        {
                            param.ClassName = "BILL.CFG.COM.BL.PriceRuleCtl";
                            param.QueryName = "FindAllowPoint";
                            param.AllowPoint = GV.AllowPointCode;
                            param.Key = getValueById('ConfigDesc');
                            param.HospId = getValueById('hospital');
                            param.ResultSetType = 'array'
                        },
                        onSelect: function (data)
                        {
                            if (GV.AllowPointCode.indexOf("Age") == -1)
                            {
                                var ed = $('#AllowPointTable').datagrid('getEditor',
                                    {
                                        index: GV.EditIndexA,
                                        field: 'ConfigValue'
                                    }
                                    );
                                ed.target[0].value = data.id;
                            }
                        }
                    }
                }
            },
            {
                field: 'ActiveStartDate',
                title: '生效日期',
                width: 120,
                editor:
                {
                    type: 'datebox',
                    options:
                    {
                    	onShowPanel : function () 
                    	{
	                    	setDateRange("AllowPointTable",GV.EditIndexA);
                    	}
                    }
                }
            },
            {
                field: 'ActiveEndDate',
                title: '失效日期',
                width: 120,
                editor:
                {
                    type: 'datebox'
                }
            },
            {
                field: 'ROWID',
                title: 'ROWID',
                width: 150,
                hidden: true
            }
        ]];

    $('#AllowPointTable').datagrid(
    {
        fit: true,
        fitColumns: false,
        border: false,
        striped: false,
        singleSelect: false,
        checkOnSelect: true, 
        selectOnCheck: false,
        pagination: true,
        rownumbers: false,
        pageSize: 20,
        columns: dgColumns,
        toolbar: '#aToolBar',
        onLoadSuccess: function (data)
        {
            GV.SelectEdIndexA = -1;
            GV.EditIndexA = -1;
        },
        onSelect: function (index, rowData)
        {
            GV.SelectEdIndexA = index;
            GV.AllowPointCode = rowData.AllowPointCode;
        },
        onUnselect: function (index, rowData)
        {
            GV.SelectEdIndexA = -1;
        },
        onDblClickRow: function (index, rowData)
        {
            GV.SelectEdIndexA = index;
            UpdateAllowPoint();          
        },
        onEndEdit: function (index, rowData, changes)
        {
            $('#AllowPointTable').datagrid('checkRow', index);
        }
    }
    );
}

//优惠类型表格加载数据
function loadRuleDg()
{
    var queryParams =
    {
        ClassName: 'BILL.CFG.COM.BL.PriceRuleCtl',
        QueryName: 'QueryInfo',
        HospID: getValueById('hospital'),
        KeyCode: getValueById('search')
    }
    loadDataGridStore('ruleTable', queryParams);
    GV.RuleId = "";
}

//优惠条件表格加载数据
function loadAllowPointDg()
{

    var queryParams =
    {
        ClassName: 'BILL.CFG.COM.BL.PriceRuleAllowPointCtl',
        QueryName: 'QueryInfo',
        rule: GV.RuleId
    }
    loadDataGridStore('AllowPointTable', queryParams);

}

//优惠类型查询
function FindRule()
{
    loadRuleDg();
}

//优惠类型新增
function AddRule()
{
    if (GV.SelectEdIndexR > -1 && GV.EditIndexR != -1)
    {
        $.messager.alert('提示', '只能操作一条数据', 'info');
        return;
    }
    $('#ruleTable').datagrid('insertRow',
    {
        index: 0, // index start with 0
        row:
        {
            ROWID: '',
            RuleCode: '',
            RuleDesc: '',
            Priority: '',
            AllowAdd: '',
            ActiveStartDate: '',
            ActiveEndDate: '',
            RuleType: '',
            HospId: '',
            Rate: '',
            Amt: '',
            Memo: ''
        }
    }
    );
    $('#ruleTable').datagrid('beginEdit', 0);
    GV.SelectEdIndexR = 0;
    GV.EditIndexR = 0;
    setDateRange("ruleTable",GV.EditIndexR);
}

//优惠类型修改
function UpdateRule()
{
	
    if (GV.SelectEdIndexR < 0)
    {
        $.messager.alert('提示', '请选择一条数据', 'info');
        return;
    }

    if (GV.SelectEdIndexR != GV.EditIndexR && GV.EditIndexR > -1 && GV.EditIndexR != -1)
    {
        $.messager.alert('提示', '一次只能修改一条数据', 'info');
        return;
    }
    $('#ruleTable').datagrid('beginEdit', GV.SelectEdIndexR);
    GV.EditIndexR = GV.SelectEdIndexR;   	

}

//优惠类型保存
function SaveRule()
{
    if (GV.SelectEdIndexR < 0)
    {
        $.messager.alert('提示', '请选择要保存的记录', 'info');
        return;
    }
    try
    {
        $('#ruleTable').datagrid('acceptChanges');
        $('#ruleTable').datagrid('selectRow', GV.EditIndexR);
        var selRow = $('#ruleTable').datagrid('getSelected');
		if (selRow.RuleCode == '')
        {
        	$.messager.alert('错误', '优惠代码不能为空', 'error');
        	$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        	return;
		}
		if (selRow.AllowAddDesc == '')
       	{
        	$.messager.alert('提示', '请选择该优惠类型是否允许叠加', 'info');
         	$('#ruletable').datagrid('beginEdit', GV.EDITINDEXR);
          	return;
      	}
		if (selRow.AllowAddDesc == '')
		{
        	$.messager.alert('提示', '请选择该优惠类型是否允许叠加', 'info');
        	$('#ruletable').datagrid('beginEdit', GV.EDITINDEXR);
        	return;
    	}
    	if (selRow.ActiveStartDate == '')
    	{
        	$.messager.alert('错误', '生效日期不能为空', 'error');
        	$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        	return;
    	}
    	if (selRow.ActiveEndDate != '' && selRow.ActiveStartDate > selRow.ActiveEndDate)
    	{
        	$.messager.alert('错误', '失效日期不能小于生效日期', 'error');
        	$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        	return;
    	}
   		if (selRow.RuleTypeDesc == '')
     	{
    		$.messager.alert('错误', '优惠分类不能为空', 'error');
     		$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        	return;
        }
    	var HospId = getValueById('hospital');
    	var inputStr = selRow.ROWID + "^" + selRow.RuleCode + "^" + selRow.RuleDesc + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + HospId + "^" + selRow.Priority + "^" + selRow.AllowAddCode;
     	var inputStr = inputStr + "^" + selRow.RuleTypeCode + "^" + selRow.Rate + "^" + selRow.Amt + "^" + selRow.Memo;
     	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleCtl", "Save", inputStr, session['LOGON.USERID']);
        if (rtn < "0")
        {
            $.messager.alert('提示', "保存失败:" + rtn.split('^')[1], 'error');
        }
        else
        {
            $.messager.alert('提示', "保存成功", 'info', function ()
            {
                loadRuleDg();
            });
        }
    }
    catch (ex)
    {
        $.messager.alert('提示', '保存优惠类型数据异常：' + ex.message, 'error');
        return;
	}
}

//停用优惠类型
function StopRule()
{
    if (GV.SelectEdIndexR < 0)
    {
        $.messager.alert('提示', '请选择要停用的记录', 'info');
        return;
    }
    try
    {
        $.messager.confirm("提示", "是否停用？", function (r)
        { 
            if (r)
            {
                //停用优惠类型
                $('#ruleTable').datagrid('updateRow',
                {
                    index: GV.SelectEdIndexR,
                    row:
                    {
                        ActiveEndDate: getDefStDate(0),
                    }
                });
                var selRow = $('#ruleTable').datagrid('getSelected');
            	var HospId = getValueById('hospital');
             	var inputStr = selRow.ROWID + "^" + selRow.RuleCode + "^" + selRow.RuleDesc + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + HospId + "^" + selRow.Priority + "^" + selRow.AllowAddCode;
             	var inputStr = inputStr + "^" + selRow.RuleTypeCode + "^" + selRow.Rate + "^" + selRow.Amt + "^" + selRow.Memo;
             	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleCtl", "Save", inputStr, session['LOGON.USERID']);
                if (rtn < "0")
                {
                    $.messager.alert('提示', "该优惠类型停用失败:" + rtn.split('^')[1], 'error');
                    loadRuleDg();
                }
                else
                {
                    $.messager.alert('提示', "停用成功", 'info', function ()
                    {
                        loadRuleDg();
                    });
                }
            }
            else
            {
                return false;
            }
        })
    }
    catch (ex)
    {
        $.messager.alert('提示', '停用优惠类型数据异常：' + ex.message, 'error');
        return;
	}
}

//优惠条件新增
function AddAllowPoint()
{
    if (GV.SelectEdIndexA > -1 && GV.EditIndexA != -1)
    {
        $.messager.alert('提示', '只能操作一条数据', 'info');
        return;
    }
    if (GV.RuleId == "")
    {
        $.messager.alert('提示', '请先选中优惠类型', 'info');
        return;
    }
    $('#AllowPointTable').datagrid('insertRow',
    {
        index: 0, // index start with 0
        row:
        {
            ROWID: '',
            RuleId: GV.RuleId,
            AllowPointCode: '',
            AllowPointDesc: '',
            ConfigValue: '',
            ConfigDesc: '',
            ActiveStartDate: getValueById('ActiveStartDate'),
            ActiveEndDate: getValueById('ActiveEndDate')
        }
    });
    $('#AllowPointTable').datagrid('beginEdit', 0);
    $('#AllowPointTable').datagrid('checkRow', 0);
    GV.SelectEdIndexA = 0;
    GV.EditIndexA = 0;
}

//优惠条件修改
function UpdateAllowPoint()
{
    $('#AllowPointTable').datagrid('endEdit', GV.EditIndexA);
    if (GV.SelectEdIndexA < 0)
    {
        $.messager.alert('提示', '请选择一条数据', 'info');
        return;
    }
    $('#AllowPointTable').datagrid('beginEdit', GV.SelectEdIndexA);
    GV.EditIndexA = GV.SelectEdIndexA;
}

//优惠条件保存
function SaveAllowPoint()
{
    try
    {
        $('#AllowPointTable').datagrid('acceptChanges');
        var row = $('#AllowPointTable').datagrid('getChecked');
     	if (row.length == 0)
     	{
        	$.messager.alert('提示', '请勾选需要保存的记录。', 'info');
        	return;
      	}
    	var ErrMsg = ""; //错误数据
        var errRowNums = 0; //保存失败的条数
        var sucRowNums = 0; //保存成功的条数
        for (var i = 0; i < row.length; i++)
        {
            var selRow = row[i];
            if (selRow.AllowPointCode == '')
            {
                $.messager.alert('错误', '准入点代码不能为空', 'error');
                $('#AllowPointTable').datagrid('beginEdit', GV.EditIndexA);
                return;
            }
            if (selRow.ConfigDesc == '')
            {
                $.messager.alert('错误', '值描述不能为空', 'error');
                $('#AllowPointTable').datagrid('beginEdit', GV.EditIndexA);
                return;
            }
            if (selRow.ConfigValue == '')
            {
                $.messager.alert('错误', '条件值不能为空', 'error');
                $('#AllowPointTable').datagrid('beginEdit', GV.EditIndexA);
                return;
            }
            if (selRow.ActiveStartDate == '')
            {
                $.messager.alert('错误', '生效日期不能为空', 'error');
                $('#AllowPointTable').datagrid('beginEdit', GV.EditIndexA);
                return;
            }
            if (selRow.ActiveEndDate != '' && selRow.ActiveStartDate > selRow.ActiveEndDate)
    		{
        		$.messager.alert('错误', '失效日期不能小于生效日期', 'error');
        		$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        		return;
    		}
            if (selRow.AllowPointCode.match("Age"))
            {
                if (!selRow.ConfigValue.match(","))
                {
                    $.messager.alert('提示', '年龄条件值不符合填写格式，如：0,19。', 'info');
                    return;
                }
            }
            var inputStr = selRow.ROWID + "^" + selRow.RuleId + "^" + selRow.AllowPointCode + "^" + selRow.AllowPointDesc + "^" + selRow.ConfigValue + "^" + selRow.ConfigDesc + "^" + selRow.ActiveStartDate;
        	var inputStr = inputStr + "^" + selRow.ActiveEndDate;
      		var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleAllowPointCtl", "Save", inputStr, session['LOGON.USERID']);
            if (rtn < "0")
            {
                errRowNums = errRowNums + 1;
                if (ErrMsg == "")
                {
                    ErrMsg = "行号:" + i + " 失败原因:" + rtn.split('^')[1];
                }
                else
                {
                    ErrMsg = ErrMsg  + "<br>" + "行号:" + i + " 失败原因:" + rtn.split('^')[1];
                }
            }
            else
            {
                sucRowNums = sucRowNums + 1;
            }
        }
        if (ErrMsg == "")
        {
            $.messager.alert('提示', '数据正确保存完成','info');
        }
        else
        {
            var tmpErrMsg = "保存成功：" + sucRowNums + "条，失败：" + errRowNums + "条。";
            tmpErrMsg = tmpErrMsg + "<br>失败数据：<br>" + ErrMsg;
            $.messager.alert('提示', tmpErrMsg, 'info');
        }
        loadAllowPointDg();
        return;
    }
    catch (ex)
    {
        $.messager.alert('提示', '保存优惠条件数据异常：' + ex.message, 'error');
        return;
	}
}

//停用优惠条件
function StopAllowPoint()
{
    if (GV.SelectEdIndexA < 0)
    {
        $.messager.alert('提示', '请选择要停用的记录', 'info');
        return;
    }
    try
    {
        $.messager.confirm("提示", "是否停用？", function (r)
        { // prompt 此处需要考虑为非阻塞的
            if (r)
            {
                //停用优惠条件
                $('#AllowPointTable').datagrid('updateRow',
                {
                    index: GV.SelectEdIndexA,
                    row:
                    {
                        ActiveEndDate: getDefStDate(0),
                    }
                }
                );
                var selRow = $('#AllowPointTable').datagrid('getSelected');
            	var inputStr = selRow.ROWID + "^" + selRow.RuleId + "^" + selRow.AllowPointCode + "^" + selRow.AllowPointDesc + "^" + selRow.ConfigValue + "^" + selRow.ConfigDesc + "^" + selRow.ActiveStartDate;
           		var inputStr = inputStr + "^" + selRow.ActiveEndDate;
           		var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleAllowPointCtl", "Save", inputStr, session['LOGON.USERID']);
                if (rtn < "0")
                {
                    $.messager.alert('提示', "停用失败:" + rtn.split('^')[1], 'error');
                    loadAllowPointDg();
                }
                else
                {
                    $.messager.alert('提示', "停用成功", 'info');
                    loadAllowPointDg();
                }
            }
            else
            {
                return false;
            }
        }
        )
    }
    catch (ex)
    {
        $.messager.alert('提示', '停用优惠条件数据异常：' + ex.message, 'error');
        return;
	}

}

//重置
function Reset()
{
    var row = $('#AllowPointTable').datagrid('getChecked')
	if (row.length !== 0)
 	{
    	$.messager.confirm("提示", "有未保存的数据，是否继续重置?", function (r)
     	{
        	if (r)
        	{
            	loadAllowPointDg();
        	}
     	})
            return;
	}
	loadAllowPointDg();
    $('#ActiveStartDate').datebox('setValue', '');	//生效日期输入框初始化
    $('#ActiveEndDate').datebox('setValue', '');	//失效日期输入框初始化
}

//优惠类型导出
function Export()
{
    try
    {
        $.messager.progress(
        {
            title: "提示",
            msg: '正在导出优惠类型表',
            text: '导出中....'
        }
        );
        $cm(
        {
        	ResultSetType: "ExcelPlugin",
            ExcelName: "优惠类型表",
            PageName: "QueryInfo",
            ClassName: "BILL.CFG.COM.BL.PriceRuleCtl",
            QueryName: 'QueryInfo',
            HospID: getValueById('hospital'),
            KeyCode: getValueById('search')
        }, function (date)
        {
            setTimeout('$.messager.progress("close");', 3 * 1000);
        });
    }
    catch (ex)
    {
        $.messager.alert("警告", ex.message ,'error');
        $.messager.progress('close');
    };
}

//优惠类型导入
function Import()
{
    var filePath = "";
	var exec = '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	+ 'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	+ 'if (!fName){fName="";}'
	+ 'xlApp.Quit();'
	+ 'xlSheet=null;'
	+ 'xlApp=null;'
	+ 'return fName;}());';
	CmdShell.notReturn = 0;
    var rs = CmdShell.EvalJs(exec);
    if (rs.msg == 'success')
    {
        filePath = rs.rtn;
        importItm(filePath);
    }
    else
    {
        $.messager.alert('提示', '打开文件错误！' + rs.msg, 'error');
    }
}
function importItm(filePath)
{
    if (filePath == "")
    {
        $.messager.alert('提示', '请选择文件！', 'info');
        return;
    }
    $.messager.progress(
    {
        title: "提示",
        msg: '优惠类型导入',
        text: '数据读取中...'
    }
    );
    $.ajax(
    {
        async: true,
        complete: function ()
        {
            ReadItmExcel(filePath);
        }
    }
    );

}
//读取Excel数据
function ReadItmExcel(filePath)
{
    //读取excel
    var arr;
    try
    {
        arr = websys_ReadExcel(filePath);
        $.messager.progress("close");
    }
    catch (ex)
    {
        $.messager.progress("close");
        $.messager.alert('提示', '调用websys_ReadExcel异常：' + ex.message, 'error');
        return;
    }
    var rowCnt = arr.length
	$.messager.progress(
	{
    	title: "提示",
    	msg: '优惠类型表导入',
    	text: '导入中，共：' + (rowCnt - 1) + '条'
	});
    $.ajax(
    {
        async: true,
        complete: function ()
        {
            ItmArrSave(arr);
        }
    });
}

//优惠类型数据保存
function ItmArrSave(arr)
{
    //读取保存数据
    var ErrMsg = "";	//错误数据
    var errRowNums = 0;	//错误行数
    var sucRowNums = 0;	//导入成功的行数
    var rowCnt = arr.length;
        try
        {
            for (i = 1; i < rowCnt; i++)
            {
                var rowArr = arr[i];
            	var ROWID = rowArr[0];
           		var RuleCode = rowArr[1];
            	var RuleDesc = rowArr[2];
            	var ActiveStartDate = rowArr[3];
            	var ActiveEndDate = rowArr[4];
            	var HospId = rowArr[5];
             	var Priority = rowArr[6];
            	var AllowAddCode = rowArr[7];
            	var AllowAddDesc = rowArr[8];
            	var RuleTypeCode = rowArr[9];
             	var RuleTypeDesc = rowArr[10];
             	var Rate = rowArr[11];
            	var Amt = rowArr[12];
            	var Memo = rowArr[13];
            	var inputStr = ROWID + "^" + RuleCode + "^" + RuleDesc + "^" + ActiveStartDate + "^" + ActiveEndDate + "^" + HospId + "^" + Priority + "^" + AllowAddCode;
            	var inputStr = inputStr + "^" + RuleTypeCode + "^" + Rate + "^" + Amt + "^" + Memo;
            	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleCtl", "Save", inputStr);
              	if (rtn >= 0)
                	{
                    	sucRowNums = sucRowNums + 1;
                	}
             	else
                	{
                    	errRowNums = errRowNums + 1;
                    	if (ErrMsg == "")
                        	{
                            	ErrMsg = i + ":" + rtn;
                        	}
                    	else
                            {
                                ErrMsg = ErrMsg + "<br>" + i + ":" + rtn;
                            }
               		}
            }
            if (ErrMsg == "")
            {
                $.messager.progress("close");
                $.messager.alert('提示', '数据正确导入完成','info');
            }
            else
            {
                $.messager.progress("close");
                var tmpErrMsg = "导入成功：" + sucRowNums + "条，失败：" + errRowNums + "条。";
                tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>" + ErrMsg;
                $.messager.alert('提示', tmpErrMsg, 'info');
            }
            loadRuleDg();
            return;
        }
        catch (ex)
        {
            $.messager.progress("close");
            $.messager.alert('提示', '保存优惠类型数据异常：' + ex.message, 'error');
            return;
        }
        return;
}

//初始化医院下拉框
function initHospital()
{
    var tableName = "CF_BILL_COM.PriceRule";
    var defHospId = session['LOGON.HOSPID'];
    var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.LOCID'] + "^" + defHospId;	// 用户ID^安全组ID^科室ID^当前登录医院ID
    $("#hospital").combobox(
    {
        panelHeight: 150,
        url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName + '&SessionStr=' + SessionStr,
        method: 'GET',
        valueField: 'HOSPRowId',
        textField: 'HOSPDesc',
        editable: false,
        blurValidValue: true,
        onLoadSuccess: function (data)
        {
            $(this).combobox('select', defHospId);
        },
        onChange: function (newValue, oldValue)
        {
            loadRuleDg();
        }
    }
    );
}

//给日期框设定可选范围
function setDateRange(DatagridId,index){
	var dg =  $('#'+DatagridId) // 获取datagrid
	var dateEditor = dg.datagrid('getEditor', {index:index, field:'ActiveStartDate'}); // 获取当前行的日期单元格编辑器
	// 设置可选日期范围
	var datebox = $(dateEditor.target);
	var today = new Date();
	var Month=(today.getMonth() + 1);
	var FromtMonth=(Month<10?('0'+Month):Month);
	var day=today.getDate();
	var FromtDay=(day<10?('0'+day):day)
	var NowDate = today.getFullYear() + '-' + FromtMonth + '-' + FromtDay;
	var NowDate=new Date(NowDate)
	datebox.datebox('calendar').calendar({
    	validator: function(date) {
        	return date >=NowDate  ;
    	}
	});
}




	


