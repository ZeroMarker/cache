var ItemPriorDataGrid;
var node = "";
nodeId = "" //��ʶ�����е����
var IsCellCheckFlag = false; //��ʾ��������Ƿ���
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
        text: '����',
        iconCls: 'icon-add',
        handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
            if (editRow != undefined) {
                //ItemPriorDataGrid.datagrid("endEdit", editRow);
                return;
            } else {
                //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                ItemPriorDataGrid.datagrid("insertRow", {
                    index: 0,
                    // index start with 0
                    row: {

                    }
                });
                //���²������һ�п����༭״̬
                ItemPriorDataGrid.datagrid("beginEdit", 0);
                //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                //����ǰ�༭���и�ֵ
                editRow = 0;
            }

        }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
            //ɾ��ʱ�Ȼ�ȡѡ����
            var rows = ItemPriorDataGrid.datagrid("getSelections");
            //ѡ��Ҫɾ������
            if (rows.length > 0) {
                $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowid);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
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
                                $.messager.show({ title: "��ʾ", msg: "ɾ���ɹ�" });
                            } else {
                                $.messager.alert('��ʾ', "ɾ��ʧ��:" + value);
                            }
                            editRow = undefined;
                        }
                    });
            } else {
                $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
            }
        }
    }, {
        text: '����',
        iconCls: 'icon-save',
        handler: function() {
            //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
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
                    $.messager.alert('��ʾ', "��ѡ��ѱ�!")
                    return false;
                }
                var ItemCatRowid = rows.ItemCatRowid; //editors[1].target.combobox('getValue');
                if (!ItemCatRowid) {
                    $.messager.alert('��ʾ', "��ѡ��ҽ������!")
                    return false;
                }
                var DurationRowid = rows.DurationRowid; //editors[2].target.combobox('getValue');
                if (!DurationRowid) {
                    $.messager.alert('��ʾ', "��ѡ���Ƴ̲���Ϊ��!")
                    return false;
                }
                var Drugspecies = editors[3].target.val();
                if (Drugspecies != "") {
                    if (isNaN(Number(Drugspecies)) == true) {
                        $.messager.alert('��ʾ', "ҩƷ��������д����!")
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
                    $.messager.alert('��ʾ', "����ʧ��!��¼�ظ�!");
                    return false;
                } else {
                    $.messager.alert('��ʾ', "����ʧ��:" + value);
                    return false;
                }
                editRow = undefined;
            }
        }
    }, {
        text: 'ȡ���༭',
        iconCls: 'icon-redo',
        handler: function() {
            //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
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
                title: '�ѱ�',
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
                title: 'ҽ������',
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
                title: '�޶��Ƴ�',
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
                title: '�޶�ҩƷ����',
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
        loadMsg: '������..',
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
                $.messager.alert("��ʾ", "�����ڱ༭����,��ѡ�����ȡ���༭!");
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
        $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
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
        $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
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
	$.messager.show({title:"��ʾ",msg:"����ɹ�"});
}*/
function InitPoisonListTab() {
    var Columns = [
        [
            { field: 'PHCPORowId', checkbox: true },
            { field: 'PHCPODesc', title: '���Ʒ���', width: 100 },
            {
                field: 'id',
                title: '�в���',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotPoisonLessLoc(' + (rec.PHCPORowId) + ')">�������</a>';
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
        loadMsg: '������..',
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
            { field: 'ARCICDesc', title: '��������', width: 100 },
            {
                field: 'id',
                title: '�в���',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotItemCatLessLoc(' + (rec.ARCICRowId) + ')">�������</a>';
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
        loadMsg: '������..',
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
            title: '�������',
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
            { field: 'FreqDesc', title: 'Ƶ��', width: 100 },
            {
                field: 'id',
                title: '�в���',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OutOrderNotFreqLessLoc(' + (rec.FreqID) + ')">�������</a>';
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
        loadMsg: '������..',
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
        $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
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
        if (str.charCodeAt(i) > 255) //����Ǻ��֣����ַ������ȼ�2
            strlen += 1;
    }
    return strlen;
}