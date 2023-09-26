/** 
 * 模块:	统计报表相关类型维护
 * 编写日期: 2019-01-22
 * 编写人:  zhaoxinlong
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId=""
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
    //别名
	$('#txtAlias').on('keypress', function(event) {
    if (event.keyCode == "13") {
            QueryDetail();
        }
    });
});

function InitHospCombo() {
    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
    if (hospAutFlag === 'Y') {
        $('#lyMainView').layout('add', {
            region: 'north',
            border: false,
            title: '',
            height: '40',
            bodyCls: 'pha-ly-hosp',
            content:
                '<div style="padding-left:10px;">' +
                '   <div class="pha-row">' +
                '       <div class="pha-col">' +
                '           <label id="_HospListLabel" style="color:red;" class="r-label">医院</label>' +
                '       </div>' +
                '   	<div class="pha-col">' +
                '       	<input id="_HospList" class="textbox"/>' +
                '   	</div>' +
                '	</div>' +
                '</div>'
        });

        var genObj = GenHospComp('PHAIN_StatType');
        //增加选择事件
        $('#_HospList').combogrid('options').onSelect = function (index, record) {
            HospId= record.HOSPRowId;
				    $('#gridTypeLink').datagrid('query', {
				        inputStr: HospId
				    });
            
            	
           
        };
    }
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
                halign: 'center',
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
                halign: 'center',
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
                halign: 'center',
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
            QueryName: "QueryStatType"
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
    DHCPHA_HUI_COM.Grid.Init("gridTypeLink", dataGridOption);
}

/// 保存统计报表类型
function SaveTypeLink() {
    $('#gridTypeLink').datagrid('endEditing');
    var HospId=$('#_HospList').combogrid("getValue");
    
    var gridChanges = $('#gridTypeLink').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.rowid || "") + "^" + (iData.code || "")+"^" + (iData.desc || "")+"^" + (iData.remarks || "")+"^"+HospId;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatType", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridTypeLink').datagrid("reload");
}

/// 删除统计报表类型
function DeleteType() {
    var gridSelect = $("#gridTypeLink").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
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
                $('#gridTypeLink').datagrid("reload");
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
                halign: 'center',
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
                halign: 'center',
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
    DHCPHA_HUI_COM.Grid.Init("gridTypeCat", dataGridOption);
}

//初始化已分类药品列表
function InitStatInciDetail() {
    //定义columns
    var columns = [
        [	      
                
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
            { field: "code", title: '代码',width: 100,halign: 'center',align: 'left'},
            { field: 'desc', title: '描述', width: 240,halign: 'center',align: 'left'},
            { field: 'operate', title: '操作', width: 60,halign: 'center',align: 'center',formatter: statusFormatter}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatInci"
        },
        pagination: true,
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
    DHCPHA_HUI_COM.Grid.Init("StatInciDetail", dataGridOption);
    
}
//初始化未分类药品列表
function InitInciDetail() {
    //定义columns
    var columns = [
        [	
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
            { field: "code", title: '代码',width: 100,halign: 'center',align: 'left'},
            { field: 'desc', title: '描述', width: 240,halign: 'center',align: 'left'},
            { field: 'operate', title: '操作', width: 60,halign: 'center',align: 'center',formatter: statusFormatter}
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
    DHCPHA_HUI_COM.Grid.Init("InciDetail", dataGridOption);
}
/// 保存报表分类
function SaveTypeCat() {
    var gridPOLSelect = $('#gridTypeLink').datagrid('getSelected');
    var phaLocId=$('#_HospList').combobox("getValue")||"";
    var pinst = gridPOLSelect.rowid;
    if (pinst == "") {
        $.messager.alert("提示", "上面请报表类型", "warning");
        return;
    }
    $('#gridTypeCat').datagrid('endEditing');
    var gridChanges = $('#gridTypeCat').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =pinst  + "^" +(iData.rowid|| "")+ "^" +(iData.code|| "")+"^"+ (iData.desc || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatTypeCat", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
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
        pinst: pinst
    });
}

/// 删除报表分类
function DeleteTypeCat() {
    var gridSelect = $("#gridTypeCat").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
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
                $('#gridTypeCat').datagrid("reload");
            }
        }
    })
}

/// 报表类型增加
function AddTypeLink() {
    $("#gridTypeLink").datagrid('addNewRow', {
        editField: 'code'
    });
    $("#gridTypeCat").datagrid("clear");
}

/// 报表分类增加
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
        $.messager.alert("提示", "请先选中需要增加分类的报表类型", "warning");
        return "";
    }
    var pinst = gridSelect.rowid || "";
    if (pinst == "") {
        $.messager.alert("提示", "请先保存报表类型", "warning");
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
//查询未分类药品
function QueryDetail()
{
	var incAlias = $("#txtAlias").val().trim();
	var SelectrowData = $('#gridTypeCat').datagrid('getSelected');
	var pinsc = SelectrowData.rowid || "";
	if (pinsc=="") { 
		$.messager.alert("提示", "请选择报表分类", "warning");
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
	var IndexString=JSON.stringify(rowIndex)
	if (value=="0"){
		
		//return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
		return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>";
	}else{
		
		//return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
		return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/></a>";

	}  
}

/// 添加药品 haha--对象
function addInci(rowData,Index) {
	 //alert(JSON.stringify(rowData))
	
    var selectRowData = $('#gridTypeCat').datagrid('getSelected');
    var pinsc = selectRowData.rowid || "";
    if (pinsc=="") {
		$.messager.alert("提示", "请选择报表分类或保存已选分类", "warning");
		return;
		}
	var inci=rowData.rowid || ""
	if (inci=="") {
		$.messager.alert("提示", "请选择要添加的药品", "warning");
		return;
		}
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "addInci", pinsc,inci);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#InciDetail').datagrid("deleteRow", Index);
    $('#InciDetail').datagrid("reload");
    $('#StatInciDetail').datagrid("reload");

    
}

/// 删除药品
function delInci(rowData,Index) {
    if (rowData == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
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