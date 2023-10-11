/** 
 * 模块:	统计报表相关类型维护
 * 编写日期: 2019-01-22
 * 编写人:  zhaoxinlong
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId=session['LOGON.HOSPID'];
$(function() {
	InitHospCombo(); //加载医院
    InitGridDict();
    InitStatType();
    InitTypeCat();
    InitStatInciDetail()
    InitInciDetail()
    //报表类型
    $("#btnAdd").on("click", AddTypeLink);
    $("#btnSave").on("click", SaveTypeLink);
    $("#btnDelete").on("click", DeleteType);
    //报表分类
    $("#btnAddPoli").on("click", AddTypeCat);
    $("#btnSavePoli").on("click", SaveTypeCat);
    $("#btnDelPoli").on("click", DeleteTypeCat);

    /// 未维护药品别名
    $('#txtAlias').searchbox({
	    searcher:function(value,name){
	    QueryDetail();
	    },
	    width:400,
	    prompt:$g('请选择分类小类后输入别名进行检索...')
	}); 
	$(".icon-help").popover({title:$g('提示'),width:"400",content:$g("1.不用于业务管控，只用于统计的，都在这里维护添加;<br> 2.没有分类标准的，医院自己定标准，只用于统计的，在这里维护;")});
});

function InitHospCombo() {
    var hospComp = GenHospComp("PHAIN_StatType",'', { width: 300 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        Query();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHAIN_StatType',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitGridDict() {
}

/// 初始化统计报表类型
function InitStatType() {
    var columns = [
        [
            { field: "rowid", title: 'rowid', hidden: true, align: 'center' },
            {
                field: 'code',
                title: '代码',
                width: 200,
                halign: 'left',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },            {
                field: 'desc',
                title: '描述',
                width: 200,
                halign: 'left',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },            {
                field: 'remarks',
                title: '备注',
                width: 200,
                halign: 'left',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatType",
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar: "#gridTypeLinkBar",
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                QueryTypeCat();
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'desc'
            });
        },
        onLoadSuccess: function() {
            QueryTypeCat();
        }
    };
    PHA.Grid("gridTypeLink", dataGridOption);
}

/// 保存统计报表类型
function SaveTypeLink() {
    $('#gridTypeLink').datagrid('endEditing');
    var HospId = $('#_HospList').combogrid("getValue");
    if (CheckEditorVal('gridTypeLink', ['code', 'desc']) == false) {
	    return;
	}
	
    var gridChanges = $('#gridTypeLink').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
	    PHA.Popover({ showType: 'show', msg: $g('没有需要保存的数据'), type: 'alert' });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var rowid = (iData.rowid || "");
        var code = (iData.code || "");
        var desc = (iData.desc || "");
        var remarks = (iData.remarks || "");
        var params = rowid + "^" + code + "^" + desc + "^" + remarks + "^" + HospId;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatType", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
    }
    $('#gridTypeLink').datagrid("reload");
}

/// 删除统计报表类型
function DeleteType() {
    var gridSelect = $("#gridTypeLink").datagrid("getSelected");
    if (gridSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"请选择需要删除的记录!", type: 'alert' });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pinst = gridSelect.rowid || "";
            if (pinst == "") {
                var rowIndex = $('#gridTypeLink').datagrid('getRowIndex', gridSelect);
                $('#gridTypeLink').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "DeleteType", pinst);
                var delRetArr = delRet.split('^')
                if (delRetArr[0] == 0) {
                    $('#gridTypeLink').datagrid("reload");
                }
                else {
                    PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                     return;
                }
                
            }
        }
    })
}

/// 初始化报表分类
function InitTypeCat() {
    var columns = [
        [
            { field: "rowid", title: 'rowid', hidden: true },
            {
                field: 'code',
                title: '代码',
                width: 200,
                halign: 'left',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                field: 'desc',
                title: '描述',
                width: 200,
                halign: 'left',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatTypeCat",
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar: "#gridTypeCatBar",
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            
            QueryStatInciDetail(rowData);
            QueryInciDetail(rowData);
            
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'desc'
            });
        },
        onLoadSuccess: function() {
            $("#StatInciDetail").datagrid("clear");
            $("#InciDetail").datagrid("clear");
        }
    };
    PHA.Grid("gridTypeCat", dataGridOption);
}

//初始化已分类药品列表
function InitStatInciDetail() {
    //定义columns
    var columns = [
        [	      
                
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
        	{ field: 'operate', title: '操作', width: 60,halign: 'center',align: 'left',formatter: statusFormatter},
            { field: "code", title: '代码',width: 100,halign: 'left',align: 'left'},
            { field: 'desc', title: '描述', width: 240,halign: 'left',align: 'left'}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatInci"
        },
        pagination: true,
        showRefresh: false,
        showPageList: false,
        afterPageText:'',
        beforePageText:'',
        displayMsg:'共 {total} 条记录',
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar:[],
        onClickRow: function(rowIndex, rowData) {
            
        },
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
        }
    };
    PHA.Grid("StatInciDetail", dataGridOption);
    
}
//初始化未分类药品列表
function InitInciDetail() {
    //定义columns
    var columns = [
        [	
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
        	{ field: 'operate', title: '操作', width: 60,halign: 'center',align: 'center',formatter: statusFormatter},
            { field: "code", title: '代码',width: 100,halign: 'left',align: 'left'},
            { field: 'desc', title: '描述', width: 240,halign: 'left',align: 'left'}
            
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryInci"
        },
        toolbar:"#toolbar",  //保持不改变高度
        pagination: true,
        showRefresh: false,
        showPageList: false,
        afterPageText:'',
        beforePageText:'',
        displayMsg:'共 {total} 条记录',
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar:"#InciDetailBar",
        onClickRow: function(rowIndex, rowData) {
        
        },
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
        }
    };
    PHA.Grid("InciDetail", dataGridOption);
}
/// 保存报表分类
function SaveTypeCat() {
    var gridPOLSelect = $('#gridTypeLink').datagrid('getSelected');
    if (gridPOLSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"上面请报表类型!", type: 'alert' });
        return;
    }
    var phaLocId = $('#_HospList').combobox("getValue")||"";
    var pinst = gridPOLSelect.rowid;
    if (pinst == "") {
	    PHA.Popover({ showType: 'show', msg:"上面请报表类型", type: 'alert' });
        return;
    }
    $('#gridTypeCat').datagrid('endEditing');
    if (CheckEditorVal('gridTypeCat', ['code', 'desc']) == false) {
	    return;
	}
    var gridChanges = $('#gridTypeCat').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
	    PHA.Popover({ showType: 'show', msg:"没有需要保存的数据", type: 'alert' });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var rowid = (iData.rowid|| "");
        var code = (iData.code|| "");
        var desc = (iData.desc || "");
        var params = pinst  + "^" + rowid + "^" + code + "^" + desc;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatTypeCat", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
	    PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
    }
    $('#gridTypeCat').datagrid("reload");
}
//获取报表分类
function QueryTypeCat() {
    var gridSelect = $('#gridTypeLink').datagrid('getSelected');
    var pinst = "";
    if (gridSelect){
        pinst=gridSelect.rowid || "";
    }
    $('#gridTypeCat').datagrid('query', {
        pinst: pinst,
        page	: 1, 
        rows	: 99999
    });
}

/// 删除报表分类
function DeleteTypeCat() {
    var gridSelect = $("#gridTypeCat").datagrid("getSelected");
    if (gridSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"请选择需要删除的记录!", type: 'alert' });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pinsc = gridSelect.rowid || "";
            if (pinsc == "") {
                var rowIndex = $('#gridTypeCat').datagrid('getRowIndex', gridSelect);
                $('#gridTypeCat').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "DeleteTypeCat", pinsc);
                var delRetArr = delRet.split('^')
                if (delRetArr[0] == 0) {
                    $('#gridTypeCat').datagrid("reload");
                }
                else {
                    PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                     return;
                }
            }
        }
    })
}

/// 报表类型新增
function AddTypeLink() {
    $("#gridTypeLink").datagrid('addNewRow', {
        editField: 'code'
    });
    $("#gridTypeCat").datagrid("clear");
}

/// 报表分类新增
function AddTypeCat() {
    var pinst = GetSelectrowid();
    if (pinst == "") {
        return;
    }
    $("#gridTypeCat").datagrid('addNewRow', {
        editField: 'code'
    });
}
function GetSelectrowid() {
    var gridSelect = $('#gridTypeLink').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"请先选中需要新增分类小类的大类！", type: 'alert' });
        return "";
    }
    var pinst = gridSelect.rowid || "";
    if (pinst == "") {
	    PHA.Popover({ showType: 'show', msg:"请先保存分类大类！", type: 'alert' });
        return "";
    }
    return pinst;
}
//查询已分类药品
function QueryStatInciDetail(SelectrowData) {
    var pinsc = SelectrowData.rowid || "";
    $('#StatInciDetail').datagrid('query', {
        pinsc: pinsc
    });
}
//查询未分类药品,点击行事件更为精确
function QueryInciDetail(SelectrowData) {
	var incAlias = $("#txtAlias").val().trim();
    var pinsc = SelectrowData.rowid || "";
    var param=pinsc+"!!"+incAlias+"!!"+HospId;
    $('#InciDetail').datagrid('query', {
        inputStr: param
    });
}

function Query(){
	$('#gridTypeLink').datagrid('query', {
        inputStr: PHA_COM.Session.HOSPID,
        page	: 1, 
        rows	: 99999
    });
}


//查询未分类药品
function QueryDetail()
{
	var incAlias = $('#txtAlias').searchbox("getValue");
	var SelectrowData = $('#gridTypeCat').datagrid('getSelected');
	var pinsc = SelectrowData.rowid || "";
	if (pinsc=="") { 
		PHA.Popover({ showType: 'show', msg:"请选择分类小类", type: 'alert' });
        return ;
        }
	var param=pinsc+"!!"+incAlias+"!!"+HospId;
    $('#InciDetail').datagrid('query', {
        inputStr: param
    });
	
	
	}
function statusFormatter(value, rowData, rowIndex){
	//好像对象传不进去,转成字符串就传进去了,对应函数内再取值又成了对象
	var dataString=JSON.stringify(rowData)
    var IndexString = JSON.stringify(rowIndex)
    if (value == "0") {
        if (PHA_COM.IsLiteCss) {
            return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'></span>";
        }
        else {
            return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
        }
    }
    else {
        if (PHA_COM.IsLiteCss) {
            return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'></span>";
        }
        else {
            return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
        }
    }

   /* 
	if (value=="0" && PHA_COM.IsLiteCss){
		
		//return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
		return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'></span>";
	}else if(value=="0" && (!PHA_COM.IsLiteCss)){
        return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
    }else if(value=='1' && PHA_COM.IsLiteCss){
		
		//return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
		return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'></span>";

	} else{
        return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
    }
    */
}

/// 添加药品 haha--对象
function addInci(rowData,Index) {
	 //alert(JSON.stringify(rowData))
	
    var selectRowData = $('#gridTypeCat').datagrid('getSelected');
    var pinsc = selectRowData.rowid || "";
    if (pinsc=="") {
	    PHA.Popover({ showType: 'show', msg:"请选择一个条分类小类！", type: 'alert' });
		return;
		}
	var inci=rowData.rowid || ""
	if (inci=="") {
		PHA.Popover({ showType: 'show', msg:"请选择要添加的药品！", type: 'alert' });
		return;
		}
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "addInci", pinsc,inci);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
	    PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
    }
    $('#InciDetail').datagrid("deleteRow", Index);
    $('#InciDetail').datagrid("reload");
    $('#StatInciDetail').datagrid("reload");

    
}

/// 删除药品
function delInci(rowData,Index) {
    if (rowData == null) {
	    PHA.Popover({ showType: 'show', msg:"请选择需要删除的记录!", type: 'alert' });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pinsd = rowData.rowid || "";
            if (pinsd == "") {
                $('#StatInciDetail').datagrid("deleteRow", Index);
            } else {
                var Ret = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "delInci", pinsd);
                $('#InciDetail').datagrid("reload");
                $('#StatInciDetail').datagrid("reload");
            }
        }
    })
}

// 验证表格编辑框的值
// Huxt 2020-09-21
function CheckEditorVal(gridId, fieldsArr){
	var fieldTitle = GetFieldTitle(gridId);
	var $GRID = $('#' + gridId);
	var rowsData = $GRID.datagrid('getRows');
	var mRows = rowsData.length;
	for (var i = 0; i < mRows; i++) {
		var mRowData = rowsData[i];
		for (var j = 0; j < fieldsArr.length; j++) {
			var oneField = fieldsArr[j];
			var cellVal = mRowData[oneField] || "";
			var cellEdVal = "";
			var ed = $GRID.datagrid('getEditor', {index:i, field:oneField});
			if (ed != null && ed !== undefined) {
				cellEdVal = $(ed.target).val();
			}
			if (cellVal == "" && cellEdVal == "") {
				$.messager.popover({
					msg: "第" + (i + 1) + "行, " + fieldTitle[oneField] + "不能为空!!!",
					type: 'alert',
					timeout: 1000
				});
				return false;
			}
		}
	}
	return true;
}

// 获取field与title的对照, 返回格式: {field:title, field:title, ...}
function GetFieldTitle(gridId){
	var $GRID = $('#' + gridId);
	var gridOpts = $GRID.datagrid('options');
	if (gridOpts.FieldTitle) {
		return $GRID.datagrid('options').FieldTitle;
	}
	var mFieldTitle = {};
	var columns = gridOpts.columns;
	var sColumns = columns[0];
	for (var c = 0; c < sColumns.length; c++) {
		var oneCol = sColumns[c];
		mFieldTitle[oneCol.field] = oneCol.title;
	}
	gridOpts.FieldTitle = mFieldTitle;
	return mFieldTitle;
}

function OpenHelpWin()
{	
	//$(".icon-help").popover({trigger:'manual',placement:'bottom',title:'HUI关于',content:'content'});
	//$(".icon-help").popover('show');
}