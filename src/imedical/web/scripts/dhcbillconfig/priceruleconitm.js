/*
 * FileName:	priceruleconitm.js
 * User:		tanfb
 * Date:		2022-12-29
 * Function:
 * Description: 优惠类型关联收费项目
 */

var GV =
{
    SelectEdIndex: -1,
    EditIndex: -1,
    RuleId: -1,
    Rate: "",	//选中优惠条件的建议比例
    Amt: ""		//选中优惠条件的建议金额
};

$(function ()
{

    initHospital();	//初始化医院下拉框
    initRuleDg();	//初始化优惠类型表格
    loadRuleDg();	//优惠类型表格加载数据
    initItmDg();	//初始化收费项目表格
    loadItmDg();	//收费项目表格加载数据
    initQueryMenu();	//判断按钮是否按下
      
});

//判断按钮是否按下
function initQueryMenu(){
	
	//回车查询优惠类型
	$("#ruleKeyCode").keydown(function (e){
    	var key = websys_getKey(e);
    	if (key == 13)
    	{
        	loadRuleDg();
    	}
	});

	//回车查询优惠条件
	$("#itmKeyCode").keydown(function (e){
    	var keycode = getValueById('itmKeyCode');
		var key = websys_getKey(e);
    	if (key == 13)
    	{
        	loadItmDg(keycode, "");
   		}
	});
	
	// 查询优惠类型
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			FindRule();
		}
	});
	
	// 收费项目新增
	$HUI.linkbutton("#btnAdd", {
		onClick: function () {
			AddItm();
		}
	});
	
	// 收费项目修改
	$HUI.linkbutton("#btnUpdate", {
		onClick: function () {
			UpdateItm();
		}
	});
	
	// 收费项目保存
	$HUI.linkbutton("#btnSave", {
		onClick: function () {
			SaveItm();
		}
	});
	
	// 收费项目停用
	$HUI.linkbutton("#btnStop", {
		onClick: function () {
			StopItm();
		}
	});
	
	// 查询收费项目
	$HUI.linkbutton("#btnFindItm", {
		onClick: function () {
			FindItm();
		}
	});
	
	// 收费项目导入
	$HUI.linkbutton("#btnImport", {
		onClick: function () {
			Import();
		}
	});
	
	// 收费项目导出
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
                    type: 'text'
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
                            param.ResultSetType = 'array';
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
                    type: 'datebox'
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
                            param.ResultSetType = 'array';
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
       	}
	]];

    $('#ruletable').datagrid(
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
        onSelect: function (index, rowData)
        {
            GV.RuleId = rowData.ROWID,
            GV.Rate = rowData.Rate;
            GV.Amt = rowData.Amt;
            loadItmDg("", GV.RuleId);
        }
    });
}

//初始化收费项目表格
function initItmDg()
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
        	title: '类型指针',
        	width: 70,
        	hidden: true,
          	editor:
                {
                    type: 'text'
                }
     	},
     	{
        	field: 'TarItemId',
        	title: '收费项指针',
         	width: 90,
         	hidden: true,
       		editor:
                {
                    type: 'text'
                }
     	},
     	{
        	field: 'TarItemCode',
         	title: '收费项代码',
          	width: 90,
           	editor:
                {
                    type: 'text'
                }
     	},
     	{
        	field: 'TarItemDesc',
         	title: '收费项名称',
         	width: 100,
         	editor:
            	{
                    type: 'combobox',
                    options:
                    {
                        panelHeight: 200,
                        url: $URL + '?ClassName=BILL.CFG.COM.BL.PriceRuleConItmCtl&QueryName=QueryTarItm&ResultSetType=array',
                        mode: 'remote',
                        method: 'get',
                        delay: 500,
                        blurValidValue: true,
                        valueField: 'id',
                        textField: 'desc',
                        onBeforeLoad: function (param)
                        {
                            if (!param.q)
                            {
                                return false;
                            }
                            $.extend(param,
                            {
                                KeyCode: param.q,
                                HospId: getValueById('hospital') //医院
                            }
                            );
                            return true;
                        },
                        onSelect: function (data)
                        {
                        	var ed = $('#ConitmTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndex,
                                    field: 'TarItemCode'
                                }
                                );
                            ed.target[0].value = data.code;
                            var ed = $('#ConitmTable').datagrid('getEditor',
                                {
                                    index: GV.EditIndex,
                                    field: 'TarItemId'
                                }
                                );
                            ed.target[0].value = data.id;
                        }
                    }
                }
      	},
      	{
       		field: 'ActiveStartDate',
        	title: '生效日期',
          	width: 100,
          	editor:
                {
                    type: 'datebox',
                    options:
                    {
	                    onShowPanel : function () 
                    	{
	                    	setDateRange("ConitmTable",GV.EditIndex);
                    	}                    	
                    }
                }
     	},
      	{
        	field: 'ActiveEndDate',
         	title: '失效日期',
         	width: 100,
          	editor:
                {
                    type: 'datebox'
                }
      	},
      	{
        	field: 'Rate',
        	title: '调整比例',
         	width: 120,
          	align: 'right',
          	editor:
                {
                    type: 'text'
                }
    	},
     	{
         	field: 'Amt',
         	title: '调整金额',
         	width: 120,
           	align: 'right',
          	editor:
                {
                    type: 'text'
                }
      	},
     	{
        	field: 'HospId',
         	title: '院区指针',
         	width: 120,
          	hidden: true,
          	editor:
                {
                    type: 'text'
                }
      	},
      	{
        	field: 'AuditStatus',
        	title: '审核标志',
         	width: 120,
          	formatter: function (value, row, index)
                {
                    if (row.AuditStatus == "1")
                    {
                        return "审核通过";
                    }
                    else if ((row.AuditStatus == "2") && (row.AuditUser != ""))
                    {
                        return "审核拒绝";
                    }
                    else
                    {
                        return "未审核";
                    }
                }
      	},
      	{
        	field: 'AuditUser',
        	title: '审核人',
        	width: 120
     	},
      	{
        	field: 'AuditDate',
        	title: '审核日期',
         	width: 120
       	},
      	{
        	field: 'AuditTime',
        	title: '审核时间',
         	width: 120
      	},
       	{
        	field: 'Memo',
          	title: '审核备注',
          	width: 120
      	},
    	{
         	field: 'ItemType',
         	title: '项目类型',
          	width: 120,
          	formatter: function (value, row, index)
                {
               		return (value == "Tar") ? "<font>收费项</font>" : "<font>value</font>";
                }
      	},
      	{
        	field: 'ROWID',
          	title: 'ROWID',
         	width: 150,
          	hidden: true
     	}
	]];
    $('#ConitmTable').datagrid(
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
            GV.SelectEdIndex = -1;
            GV.EditIndex = -1;
        },
        onSelect: function (index, rowData)
        {
            GV.SelectEdIndex = index;
        },
        onUnselect: function (index, rowData)
        {
            GV.SelectEdIndex = -1;
        },
        onDblClickRow: function (index, rowData)
        {
            GV.SelectEdIndex = index;
            UpdateItm();
        },
        onEndEdit: function (index, rowData, changes)
        {
            $('#ConitmTable').datagrid('checkRow', index);
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
        KeyCode: getValueById('ruleKeyCode')
    }
    loadDataGridStore('ruletable', queryParams);

}

//收费项目表格加载数据
function loadItmDg(KeyCode, rule)
{
    var queryParams =
    {
        ClassName: 'BILL.CFG.COM.BL.PriceRuleConItmCtl',
        QueryName: 'QueryInfo',
        KeyCode: KeyCode,
        rule: GV.RuleId,
        type: 'Tar'
    }
    loadDataGridStore('ConitmTable', queryParams);

}

//优惠类型查询
function FindRule()
{
    loadRuleDg();
}

//收费项目查询
function FindItm(KeyCode, rule)
{
    var KeyCode = getValueById('itmKeyCode');
    loadItmDg(KeyCode, GV.RuleId);
}

//收费项目新增
function AddItm()
{
    if (GV.SelectEdIndex > -1 && GV.EditIndex != -1)
    {
        $.messager.alert('提示', '只能操作一条数据', 'info');
        return;
    }
    if (GV.RuleId == -1)
    {
        $.messager.alert('提示', '未选择优惠类型,无法新增', 'info');
        return;
    }
    $('#ConitmTable').datagrid('insertRow',
    {
        index: 0, // index start with 0
        row:
        {
            ROWID: '',
            RuleId: GV.RuleId,
            TarItemCode: '',
            TarItemDesc: '',
            ActiveStartDate: getValueById('ActiveStartDate'),
            ActiveEndDate: getValueById('ActiveEndDate'),
            Rate: GV.Rate,
            Amt: GV.Amt,
            HospId: getValueById('hospital'),
            AuditStatus: '',
            AuditUser: '',
            AuditDate: '',
            AuditTime: '',
            Memo: '',
            ItemType: 'Tar'
        }
    }
    );
    $('#ConitmTable').datagrid('beginEdit', 0);
    $('#ConitmTable').datagrid('checkRow', 0);
    GV.SelectEdIndex = 0;
    GV.EditIndex = 0;
}

//收费项目修改
function UpdateItm()
{
    $('#ConitmTable').datagrid('endEdit', GV.EditIndex);
    if (GV.SelectEdIndex < 0)
    {
        $.messager.alert('提示', '请选择一条数据', 'info');
        return;
    }
    var row = $('#ConitmTable').datagrid('getSelected');
    if(row.AuditStatus == 1)
    {
        $.messager.alert('提示', '审核状态为未审核或审核拒绝的才能进行修改', 'info');
        return;
    }
    $('#ConitmTable').datagrid('beginEdit', GV.SelectEdIndex);
    GV.EditIndex = GV.SelectEdIndex;
}

//收费项目保存
function SaveItm()
{
    try
    {
        $('#ConitmTable').datagrid('acceptChanges');
        var row = $('#ConitmTable').datagrid('getChecked');
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
            if (selRow.TarItemDesc == '')
            {
                $.messager.alert('错误', '收费项名称不能为空', 'error');
                $('#ConitmTable').datagrid('beginEdit', GV.EditIndex);
                return;
            }
            if (selRow.ActiveStartDate == '')
            {
                $.messager.alert('错误', '生效日期不能为空', 'error');
                $('#ConitmTable').datagrid('beginEdit', GV.EditIndex);
                return;
            }
            if (selRow.ActiveEndDate != '' && selRow.ActiveStartDate > selRow.ActiveEndDate)
    		{
        		$.messager.alert('错误', '失效日期不能小于生效日期', 'error');
        		$('#ruleTable').datagrid('beginEdit', GV.EditIndexR);
        		return;
    		}
            if (selRow.Rate == '' && selRow.Amt == '')
            {
                $.messager.alert('错误', '调整比例和调整金额不能同时为空', 'error');
                return;
            }
            var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt;
       		var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType;
         	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr, session['LOGON.USERID']);
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
                };
            }
            else
            {
                sucRowNums = sucRowNums + 1;
            }
        }
        if (ErrMsg == "")
        {
            $.messager.alert('提示', '数据正确保存完成', 'info');
        }
        else
        {
            var tmpErrMsg = "保存成功：" + sucRowNums + "条，失败：" + errRowNums + "条。";
            tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>" + ErrMsg;
            $.messager.alert('提示', tmpErrMsg, 'info');
        }
        loadItmDg();
        return;
    }
    catch (ex)
    {
        $.messager.alert('提示', '保存收费项目数据异常：' + ex.message, 'error');
        return;	
	}
}

//停用收费项目
function StopItm()
{
    if (GV.SelectEdIndex < 0)
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
          		//停用收费项
                $('#ConitmTable').datagrid('updateRow',
                {
                    index: GV.SelectEdIndex,
                    row:
                    {
                        ActiveEndDate: getDefStDate(0),
                    }
                }
                );
                var selRow = $('#ConitmTable').datagrid('getSelected');
             	var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt;
              	var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType;
             	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr, session['LOGON.USERID']);
                if (rtn < "0")
                {
                    $.messager.alert('提示', "停用失败:" + rtn.split('^')[1], 'error');
                    loadItmDg();
                }
                else
                {
                    $.messager.alert('提示', "停用成功", 'info');
                    loadItmDg();
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
        $.messager.alert('提示', '停用收费项目数据异常：' + ex.message, 'error');
        return;
	}

}

//优惠类型关联收费项目导出
function Export()
{
    try
    {
        $.messager.progress(
        {
            title: "提示",
            msg: '正在导出优惠类型关联收费项目',
            text: '导出中....'
        }
        );
        $cm(
        {
            ResultSetType: "ExcelPlugin",
            ExcelName: "优惠类型关联收费项目表",
            PageName: "QueryInfo",
            ClassName: "BILL.CFG.COM.BL.PriceRuleConItmCtl",
            QueryName: 'QueryInfo',
            rule: GV.RuleId,
            type: "Tar",
            KeyCode: getValueById('itmKeyCode')
        }, function (date)
        {
            setTimeout('$.messager.progress("close");', 3 * 1000);
        }
        );

    }
    catch (ex)
    {
        $.messager.alert("警告", ex.message, 'error');
        $.messager.progress('close');
    };
}

//优惠类型关联收费项目导入
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
        msg: '优惠类型关联收费项目表导入',
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
    var rowCnt = arr.length;
	$.messager.progress(
    	{
            title: "提示",
            msg: '优惠类型关联收费项目表导入',
            text: '导入中，共：' + (rowCnt - 1) + '条'
        }
	);
    $.ajax(
    {
        async: true,
        complete: function ()
        {
            ItmArrSave(arr);
        }
    }
    );
}

//优惠类型关联收费项目数据保存
function ItmArrSave(arr)
{

    //读取保存数据
    var ErrMsg = ""; //错误数据
    var errRowNums = 0; //错误行数
    var sucRowNums = 0; //导入成功的行数
    var rowCnt = arr.length;
	try
    	{
        	for (i = 1; i < rowCnt; i++)
            {
                var rowArr = arr[i];
            	var ROWID = rowArr[0];
             	var TarItemId = rowArr[1];
            	var TarItemCode = rowArr[2];
             	var TarItemDesc = rowArr[3];
             	var RuleId = rowArr[4];
             	var RuleDesc = rowArr[5];
             	var ActiveStartDate = rowArr[6];
             	var ActiveEndDate = rowArr[7];
              	var Rate = rowArr[8];
              	var Amt = rowArr[9];
            	var HospId = rowArr[10];
           		var AuditStatus = rowArr[11];
              	var AuditUser = rowArr[12];
              	var AuditDate = rowArr[13];
              	var AuditTime = rowArr[14];
             	var Memo = rowArr[15];
              	var ItemType = rowArr[16];
             	var inputStr = ROWID + "^" + TarItemId + "^" + RuleId + "^" + ActiveStartDate + "^" + ActiveEndDate + "^" + Rate + "^" + Amt;
              	var inputStr = inputStr + "^" + HospId + "^" + AuditStatus + "^" + AuditUser + "^" + AuditDate + "^" + AuditTime + "^" + Memo + "^" + ItemType;
              	var rtn = tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
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
                $.messager.alert('提示', '数据正确导入完成', 'info');
            }
            else
            {
                $.messager.progress("close");
                var tmpErrMsg = "导入成功：" + sucRowNums + "条，失败：" + errRowNums + "条。";
                tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>" + ErrMsg;
                $.messager.alert('提示', tmpErrMsg, 'info');
            }
            loadItmDg();
            return;
        }
        catch (ex)
        {
            $.messager.progress("close");
            $.messager.alert('提示', '保存优惠类型关联收费项目数据异常：' + ex.message, 'error');
            return;
        }
        return;

}

//初始化医院下拉框
function initHospital()
{
	var tableName = "CF_BILL_COM.PriceRule";
    var defHospId = session['LOGON.HOSPID'];
    var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.LOCID'] + "^" + defHospId; // 用户ID^安全组ID^科室ID^当前登录医院ID
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
	console.log(NowDate)
	var startDate = new Date(NowDate);
	console.log(startDate)
	console.log(NowDate===startDate)
	datebox.datebox('calendar').calendar({
    	validator: function(date) {
	       
        	return date >=startDate   ;
    	} 
	});

}
