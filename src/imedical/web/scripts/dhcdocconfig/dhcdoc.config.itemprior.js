var ItemPriorDataGrid;
var node = "";
nodeId = "" //标识例外列点击行
var IsCellCheckFlag = false; //标示例外科室是否点击
$(function() {
    InitHospList();
    //$('#Confirm').click(SaveOutOrderOtherContral);
    $('#SaveutOrderNotPoison').click(SaveutOrderNotPoison);
    $('#SaveutOutOrderNotItemCat').click(SaveutOutOrderNotItemCat);
    $('#SaveutOutOrderNotFreq').click(SaveutOutOrderNotFreq);
    $('#BSaveLessLoc').click(BSaveLessLoc);
})

function InitHospList() {
    var hospComp = GenHospComp("Doc_BaseConfig_ItemPrior");
    hospComp.jdata.options.onSelect = function(e, t) {
        Init();
    }
    hospComp.jdata.options.onLoadSuccess = function(data) {
        Init();
    }
}

function Init() {
    //InitListPoison("List_Poison","OutOrderNotPoison");
    //InitListItemCat("List_ItemCat","OutOrderNotItemCat")
    InittabItemPrior();
    InitPoisonListTab();
    InitItemCatListTab();
    InitFreqListTab();
}
/*function InitListPoison(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 QueryName:"FindPoison",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue(),
		 rows:9999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.PHCPORowId + ">" + n.PHCPODesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}
function InitListItemCat(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 QueryName:"FindCatList",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue(),
		 rows:9999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}*/
function InittabItemPrior() {
    var ItemPriorToolBar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { //添加列表的操作按钮添加,修改,删除等
            if (editRow != undefined) {
                //ItemPriorDataGrid.datagrid("endEdit", editRow);
                return;
            } else {
                //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                ItemPriorDataGrid.datagrid("insertRow", {
                    index: 0,
                    // index start with 0
                    row: {

                    }
                });
                //将新插入的那一行开户编辑状态
                ItemPriorDataGrid.datagrid("beginEdit", 0);
                //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                //给当前编辑的行赋值
                editRow = 0;
            }

        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            //删除时先获取选择行
            var rows = ItemPriorDataGrid.datagrid("getSelections");
            //选择要删除的行
            if (rows.length > 0) {
                $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowid);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var rowid = ids.join(',');
                            if (rowid == "") {
                                editRow = undefined;
                                ItemPriorDataGrid.datagrid("rejectChanges");
                                ItemPriorDataGrid.datagrid("unselectAll");
                                return;
                            }
                            var value = $.m({
                                ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
                                MethodName: "delete",
                                RowId: rowid
                            }, false);
                            if (value == "0") {
                                ItemPriorDataGrid.datagrid('load');
                                ItemPriorDataGrid.datagrid('unselectAll');
                                $.messager.show({ title: "提示", msg: "删除成功" });
                            } else {
                                $.messager.alert('提示', "删除失败:" + value);
                            }
                            editRow = undefined;
                        }
                    });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
            var rows = ItemPriorDataGrid.datagrid("getSelections");
            if (editRow != undefined) {
                var rows = ItemPriorDataGrid.datagrid("selectRow", editRow).datagrid("getSelected");
                if (rows.rowid) {
                    var rowid = rows.rowid
                } else {
                    var rowid = ""
                }
                var editors = ItemPriorDataGrid.datagrid('getEditors', editRow);
                var BillTypeRowid = rows.BillTypeRowid; //editors[0].target.combobox('getValue');
                if (!BillTypeRowid) {
                    $.messager.alert('提示', "请选择费别!")
                    return false;
                }
                var ItemCatRowid = rows.ItemCatRowid; //editors[1].target.combobox('getValue');
                if (!ItemCatRowid) {
                    $.messager.alert('提示', "请选择医嘱子类!")
                    return false;
                }
                var DurationRowid = rows.DurationRowid; //editors[2].target.combobox('getValue');
                if (!DurationRowid) {
                    $.messager.alert('提示', "请选择疗程不能为空!")
                    return false;
                }
                var Drugspecies = editors[3].target.val();
                if (Drugspecies != "") {
                    if (isNaN(Number(Drugspecies)) == true) {
                        $.messager.alert('提示', "药品种类请填写数字!")
                        return false;
                    }
                }
                var Para = rowid + "^" + ItemCatRowid + "^" + BillTypeRowid + "^" + DurationRowid + "^" + Drugspecies;
                var value = $.m({
                    ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
                    MethodName: "save",
                    Para: Para,
                    HospId: $HUI.combogrid('#_HospList').getValue()
                }, false);
                if (value == 0) {
                    ItemPriorDataGrid.datagrid("endEdit", editRow);
                    editRow = undefined;
                    ItemPriorDataGrid.datagrid('load').datagrid('unselectAll');
                } else if (value == "repeat") {
                    $.messager.alert('提示', "保存失败!记录重复!");
                    return false;
                } else {
                    $.messager.alert('提示', "保存失败:" + value);
                    return false;
                }
                editRow = undefined;
            }
        }
    }, {
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
            editRow = undefined;
            ItemPriorDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
        }
    }];
    var ItemPriorColumns = [
        [
            { field: 'rowid', title: '', width: 100, hidden: true },
            { field: 'BillTypeRowid', title: '', hidden: true },
            {
                field: 'BillType',
                title: '费别',
                width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value=&HospId=" + $HUI.combogrid('#_HospList').getValue(),
                        valueField: 'BillTypeRowid',
                        textField: 'BillTypeDesc',
                        required: false,
                        loadFilter: function(data) {
                            return data['rows'];
                        },
                        onSelect: function(rec) {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            rows.BillTypeRowid = rec.BillTypeRowid;
                        },
                        onChange: function(newValue, oldValue) {
                            if (newValue == "") {
                                var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                                rows.BillTypeRowid = "";
                            }
                        },
                        onHidePanel: function() {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            if (!$.isNumeric($(this).combobox('getValue'))) return;
                            rows.BillTypeRowid = $(this).combobox('getValue');
                        }
                    }
                }
            },
            { field: 'ItemCatRowid', title: '', hidden: true },
            {
                field: 'ItemCat',
                title: '医嘱子类',
                width: 250,
                editor: {
                    type: 'combobox',
                    options: {
                        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindCatList&value=&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
                        valueField: 'ARCICRowId',
                        textField: 'ARCICDesc',
                        required: false,
                        loadFilter: function(data) {
                            return data['rows'];
                        },
                        onSelect: function(rec) {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            rows.ItemCatRowid = rec.ARCICRowId;
                        },
                        onChange: function(newValue, oldValue) {
                            if (newValue == "") {
                                var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                                rows.ItemCatRowid = "";
                            }
                        },
                        onHidePanel: function() {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            if (!$.isNumeric($(this).combobox('getValue'))) return;
                            rows.ItemCatRowid = $(this).combobox('getValue');
                        }
                    }
                }
            },
            { field: 'DurationRowid', title: '', width: 100, hidden: true },
            {
                field: 'Duration',
                title: '限定疗程',
                width: 100,
                align: 'center',
                sortable: true,
                editor: {
                    type: 'combobox',
                    options: {
                        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value=&Type=XY",
                        valueField: 'DurRowId',
                        textField: 'DurCode',
                        required: false,
                        loadFilter: function(data) {
                            return data['rows'];
                        },
                        onSelect: function(rec) {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            rows.DurationRowid = rec.DurRowId;
                        },
                        onChange: function(newValue, oldValue) {
                            if (newValue == "") {
                                var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                                rows.DurationRowid = "";
                            }
                        },
                        onHidePanel: function() {
                            var rows = $("#tabItemPrior").datagrid("selectRow", editRow).datagrid("getSelected");
                            if (!$.isNumeric($(this).combobox('getValue'))) return;
                            rows.DurationRowid = $(this).combobox('getValue');
                        }
                    }
                }
            },
            {
                field: 'Drugspecies',
                title: '限定药品种类',
                width: 100,
                editor: { type: 'text', options: {} }
            }
        ]
    ];
    ItemPriorDataGrid = $("#tabItemPrior").datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=Find&Alias=&HospId=" + $HUI.combogrid('#_HospList').getValue(),
        loadMsg: '加载中..',
        pagination: true, //
        rownumbers: true, //
        idField: "rowid",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: ItemPriorColumns,
        toolbar: ItemPriorToolBar,
        onLoadSuccess: function(data) {
            editRow = undefined;
        },
        onDblClickRow: function(rowIndex, rowData) {
            if (editRow !== undefined) {
                $.messager.alert("提示", "有正在编辑的行,请选保存或取消编辑!");
                return false;
            }
            editRow = rowIndex;
            $("#tabItemPrior").datagrid("beginEdit", rowIndex);
        },
        onBeforeLoad: function(param) {
            $("#tabItemPrior").datagrid('unselectAll');
        }
    });
}

function SaveutOrderNotPoison() {
    var PoisonStr = ""
    var rows = $("#PoisonListTab").datagrid('getSelections');
    for (var i = 0; i < rows.length; i++) {
        var PHCPORowId = rows[i].PHCPORowId;
        if (PoisonStr == "") PoisonStr = PHCPORowId;
        else PoisonStr = PoisonStr + "^" + PHCPORowId;
    }
    $.m({
        ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
        MethodName: "SaveConfig",
        node: "OutOrderNotPoison",
        value: PoisonStr,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function(rtn) {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
    });
}

function SaveutOutOrderNotItemCat() {
    var CatStr = "";
    var rows = $("#ItemCatListTab").datagrid('getSelections');
    for (var i = 0; i < rows.length; i++) {
        var ARCICRowId = rows[i].ARCICRowId;
        if (CatStr == "") CatStr = ARCICRowId;
        else CatStr = CatStr + "^" + ARCICRowId;
    }
    $.m({
        ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
        MethodName: "SaveConfig",
        node: "OutOrderNotItemCat",
        value: CatStr,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function() {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
    });
}
/*function SaveOutOrderOtherContral()
{
   var PoisonStr=""
   var size = $("#List_Poison" + " option").size();
   if(size>0){
	   $.each($("#List_Poison"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (PoisonStr=="") PoisonStr=svalue
			  else PoisonStr=PoisonStr+"^"+svalue
			})
   } 
   var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 MethodName:"SaveConfig",
		 node:"OutOrderNotPoison",
		 value:PoisonStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
   var CatStr=""
   var size = $("#List_ItemCat" + " option").size();
   if(size>0){
	   $.each($("#List_ItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatStr=="") CatStr=svalue
			  else CatStr=CatStr+"^"+svalue
		})
   } 
   var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 MethodName:"SaveConfig",
		 node:"OutOrderNotItemCat",
		 value:CatStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	$.messager.show({title:"提示",msg:"保存成功"});
}*/
function InitPoisonListTab() {
    var Columns = [
        [
            { field: 'PHCPORowId', checkbox: true },
            { field: 'PHCPODesc', title: '管制分类', width: 100 },
            {
                field: 'id',
                title: '列操作',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotPoisonLessLoc(' + (rec.PHCPORowId) + ')">例外科室</a>';
                }
            }
        ]
    ];
    PoisonListTabDataGrid = $("#PoisonListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindPoison&value=OutOrderNotPoison&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
        loadMsg: '加载中..',
        pagination: false, //
        rownumbers: false, //
        idField: "PHCPORowId",
        columns: Columns,
        onLoadSuccess: function(data) {
            for (var i = 0; i < data.total; i++) {
                if (data.rows[i].selected) {
                    $("#PoisonListTab").datagrid('selectRow', i);
                }
            }
        },
        onBeforeSelect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeUnselect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeLoad: function(param) {
            $("#PoisonListTab").datagrid('unselectAll');
        }
    });
}

function OutOrderNotPoisonLessLoc(PHCPORowId) {
    node = "OutOrderNotPoison";
    nodeId = PHCPORowId;
    ShowHolidaysRecSetWin();
    IsCellCheckFlag = true;
    setTimeout(function() {
        IsCellCheckFlag = false;
    })
}

function InitItemCatListTab() {
    var Columns = [
        [
            { field: 'ARCICRowId', checkbox: true },
            { field: 'ARCICDesc', title: '子类名称', width: 100 },
            {
                field: 'id',
                title: '列操作',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotItemCatLessLoc(' + (rec.ARCICRowId) + ')">例外科室</a>';
                }
            }
        ]
    ];
    PoisonListTabDataGrid = $("#ItemCatListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindCatList&value=OutOrderNotItemCat&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
        loadMsg: '加载中..',
        pagination: false, //
        rownumbers: false, //
        idField: "ARCICRowId",
        columns: Columns,
        onLoadSuccess: function(data) {
            for (var i = 0; i < data.total; i++) {
                if (data.rows[i].selected) {
                    $("#ItemCatListTab").datagrid('selectRow', i);
                }
            }
        },
        onBeforeSelect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeUnselect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeLoad: function(param) {
            $("#ItemCatListTab").datagrid('unselectAll');
        }
    });
}

function OutOrderNotItemCatLessLoc(ARCICRowId) {
    node = "OutOrderNotItemCat";
    nodeId = ARCICRowId;
    ShowHolidaysRecSetWin();
    IsCellCheckFlag = true;
    setTimeout(function() {
        IsCellCheckFlag = false;
    })
}

function ShowHolidaysRecSetWin() {
    if ($("#LocWin").hasClass('window-body')) {
        $('#LocWin').window('open');
    } else {
        $('#LocWin').window({
            title: '例外科室',
            zIndex: 9999,
            iconCls: 'icon-w-edit',
            inline: false,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            closable: true
        });
    }
    LoadLoc();
}

function BSaveLessLoc() {
    var LocStr = "";
    var recobj = $("#List_Dept").find("option:selected");
    for (var j = 0; j < recobj.length; j++) {
        if (LocStr == "") LocStr = recobj[j].value;
        else LocStr = LocStr + "^" + recobj[j].value;
    }
    var rtn = $.cm({
        ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
        MethodName: "SaveLessLocConfig",
        node: node,
        nodeId: nodeId,
        value: LocStr,
        HospId: $HUI.combogrid('#_HospList').getValue(),
        dataType: "text"
    }, false);
    $("#LocWin").window('close');
}

function LoadLoc() {
    $("#List_Dept").find("option").remove();
    $('#SearchLoc').searchbox('setValue', "")
    $.cm({
        ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
        QueryName: "GetLocList",
        HospId: $HUI.combogrid('#_HospList').getValue(),
        rows: "99999",
    }, function(objScope) {
        var vlist = "";
        var selectlist = "";
        jQuery.each(objScope.rows, function(i, n) {
            selectlist = selectlist + "^" + n.selected
            vlist += "<option title=" + n.PYFristStr + " value=" + n.LocRowID + ">" + n.LocDesc + "</option>";
        });
        if ($("#List_Dept option").length == 0) {
            $("#List_Dept").append(vlist);
        }
        $.cm({
            ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
            MethodName: "GetLessLocConfig",
            node: node,
            nodeId: nodeId,
            HospId: $HUI.combogrid('#_HospList').getValue(),
            dataType: "text"
        }, function(locStr) {
            for (var i = 0; i < locStr.split("^").length; i++) {
                var locId = locStr.split("^")[i];
                $("#List_Dept").find("option[value='" + locId + "']").attr("selected", true);
            }
        });
    });
}

function InitFreqListTab() {
    var Columns = [
        [
            { field: 'FreqID', checkbox: true },
            { field: 'FreqDesc', title: '频次', width: 100 },
            {
                field: 'id',
                title: '列操作',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotFreqLessLoc(' + (rec.FreqID) + ')">例外科室</a>';
                }
            }
        ]
    ];
    $("#FreqListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindFreq&value=OutOrderNotFreq&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
        loadMsg: '加载中..',
        pagination: false, //
        rownumbers: false, //
        idField: "FreqID",
        columns: Columns,
        onLoadSuccess: function(data) {
            for (var i = 0; i < data.total; i++) {
                if (parseFloat(data.rows[i].selected)) {
                    $(this).datagrid('selectRow', i);
                }
            }
        },
        onBeforeSelect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeUnselect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeLoad: function(param) {
            $(this).datagrid('unselectAll');
        }
    });
}

function OutOrderNotFreqLessLoc(FreqID) {
    node = "OutOrderNotFreq";
    nodeId = FreqID;
    ShowHolidaysRecSetWin();
    IsCellCheckFlag = true;
    setTimeout(function() {
        IsCellCheckFlag = false;
    })
}

function SaveutOutOrderNotFreq() {
    var FreqIDStr = "";
    var rows = $("#FreqListTab").datagrid('getSelections');
    for (var i = 0; i < rows.length; i++) {
        if (FreqIDStr == "") FreqIDStr = rows[i].FreqID;
        else FreqIDStr = FreqIDStr + "^" + rows[i].FreqID;
    }
    $.m({
        ClassName: "DHCDoc.DHCDocConfig.ItemPrior",
        MethodName: "SaveConfig",
        node: "OutOrderNotFreq",
        value: FreqIDStr,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function() {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
    });
}
var FindLocNo = ""
var SearchLocCFflag = ""

function SearchLessLoc() {
    var SearchLoc = $('#SearchLoc').searchbox('getValue')
    if ((FindLocNo != "") && (typeof(FindLocNo) != "undefined")) {
        $("#List_Dept").find("option")[FindLocNo].className = ""
    }
    if (SearchLoc == "") return "";
    var ListDeplen = $("#List_Dept").find("option").length
    var startNo = 0
    if (SearchLocCFflag == SearchLoc) {
        startNo = FindLocNo + 1
    }
    FindLocNo = ""
    var SearchLocPY = GetLocPY(SearchLoc)
    for (var i = startNo; i < ListDeplen; i++) {
        var locname = $("#List_Dept").find("option")[i].innerHTML
        var locnamePY = $("#List_Dept").find("option")[i].title
        if ((locname.indexOf(SearchLoc) != -1) && (SearchLocPY > 0)) {
            FindLocNo = i
            break
        } else if (locnamePY.indexOf(SearchLocPY) != -1) {
            FindLocNo = i
            break
        }
    }
    if (FindLocNo == "") return "";
    $("#List_Dept").find("option")[FindLocNo].className = "optioncolor"
    $("#List_Dept").animate({ scrollTop: 18.49 * parseFloat(FindLocNo) }, "slow");
    SearchLocCFflag = SearchLoc
}

function GetLocPY(locname) {
    if (chkstrlen(locname) > 0) {
        return 10;
    }
    var value = $.m({
        ClassName: "web.DHCINSUPort",
        MethodName: "GetCNCODE",
        HANZIS: locname,
        FLAG: "4",
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, false);
    return value

}

function chkstrlen(str) {
    var strlen = 0;
    for (var i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 255) //如果是汉字，则字符串长度加2
            strlen += 1;
    }
    return strlen;
}