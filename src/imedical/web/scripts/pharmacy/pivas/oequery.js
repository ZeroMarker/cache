/**
 * 模块:     配液医嘱查询
 * 编写日期: 2018-03-01
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || "";
$(function() {
    InitDict();
    InitGridPat();
    InitGridOrdItm();
    //InitGridRecord();
    $('#btnFind').bind("click", Query);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            Query();
        }
    });
});
window.onbeforeunload = function() {
    Clear();
}

function InitDict() {
    // 日期
    PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.ComboBox.Init({ Id: 'cmbPivasLoc', Type: 'PivaLoc' }, {
        placeholder: "配液中心...",
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivasLoc").combobox("getData");
            if (datas.length == 1) {
                $("#cmbPivasLoc").combobox("select", datas[0].RowId);

            } else {
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                        break;
                    }
                }
            }
        }
    });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {
        placeholder: "病区...",
        readonly: (SessionWard != "") ? true : false,
        onLoadSuccess: function() {
	        if(SessionWard != ""){
               $("#cmbWard").combobox("setValue", SessionWard);
	        }
        }
    });
}

// 医嘱明细列表
function InitGridOrdItm() {
    var columns = [
        [{
                field: 'pivaState',
                title: '状态',
                width: 75,
                styler: PIVAS.Grid.Styler.PivaState
            },
            { field: "passResult", title: '配伍结果', width: 85,
            	 styler: function(value, row, index) {
                    if (value.indexOf("审核通过")>=0) {
                        return 'background-color:#019BC1;color:white;'; //绿色
                    } else if (value.indexOf("审核拒绝")>=0) {
                        return 'background-color:#C33A30;color:white;'; //红色
                    } else if (value.indexOf("医生申诉")>=0) {
                        return 'background-color:#FFB63D;color:white;'; //浅黄色
                    } 
                }
            },{
                field: 'batNo',
                title: '批次',
                width: 50
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: '药品', width: 300 },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 75 },
            { field: 'doseDateTime', title: '用药时间', width: 100 },
            { field: 'priDesc', title: '医嘱优先级', width: 80 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'uomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 80, hidden:true },
            { field: "mOeore", title: 'mOeore', width: 100, hidden: true },
            { field: "colColor", title: 'colColor', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar:[],
        onLoadSuccess: function() {
	    	$(this).datagrid("options").checking = "";
	    },
        onSelect: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItm',
                Field: 'mOeore',
                Check: true,
                Value: rowData.mOeore,
                Type: 'Select'
            });
            $(this).datagrid("options").checking = "";
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        },
        onClickRow: function(rowIndex, rowData) {
            //var mOeore = rowData.mOeore;
            //QueryRecord(mOeore);
        },
        onClickCell: function(rowIndex, field, value) {
            var mOeore = $(this).datagrid("getRows")[rowIndex].mOeore;
            PIVASTIMELINE.Init({
                Params: mOeore,
                Field: 'oeoriSign',
                ClickField: field
            })
        },
        rowStyler: function(index, row) {
            /*
            var colColor = row.colColor;
            var colorStyle = "";
            if ((colColor % 2) == 0) { // 按成组的背景色
                colorStyle = PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;
            */
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdItm", dataGridOption);
}

// 追踪记录列表
function InitGridRecord() {
    var columns = [
        [
            { field: 'pivasState', title: '状态', width: 80, halign: 'center' },
            { field: 'dateTime', title: '时间', width: 120, halign: 'center', align: 'center' },
            { field: 'userName', title: '处理人', width: 80, halign: 'center' }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'LabelExeRecords'
        },
        toolbar:[],
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridRecord", dataGridOption);
}
// 病人列表
function InitGridPat() {
    var columns = [
        [
            { field: 'patId', title: 'PatId', width: 80, halign: 'center', hidden: true },
            { field: 'bedNo', title: '床号', width: 75 },
            { field: 'patName', title: '姓名', width: 80 },
            { field: 'patNo', title: '登记号', width: 100 },
            { field: 'patSex', title: '性别', width: 60 },
            { field: 'patAge', title: '年龄', width: 75 },
            { field: 'wardDesc', title: '病区', width: 200 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OeQuery",
            QueryName: "OeQueryPat"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar:[],
        onSelect: function(rowIndex, rowData) {
            var paramsArr = QueryParams();
            paramsArr[5] = rowData.patNo;
            var params = paramsArr.join("^");
            $('#gridOrdItm').datagrid({
                url: PIVAS.URL.COMMON + '?action=JsGetOeQueryDetail',
                queryParams: {
                    params: params
                }
            });
            $('#gridRecord').datagrid('clear');
        },
        onLoadSuccess: function(data) {
			$('#gridOrdItm').datagrid('clear');
			if (data.rows.length==1){
				$("#gridPat").datagrid("selectRow",0);
			}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPat", dataGridOption);
}

function Query() {
    var paramsArr = QueryParams();
    var params = paramsArr.join("^");
    $('#gridPat').datagrid('query', {
        inputStr: params,
        rows:9999
    });
}
//清空
function Clear() {
    InitDict();
    $('#txtPatNo').val("");
    $('#gridPat').datagrid('clear');
    $('#gridOrdItm').datagrid('clear');
    $('#gridRecord').datagrid('clear');
}

function QueryParams() {
    var paramsArr = [];
    var ordStDate = $('#dateOrdStart').datebox('getValue'); //起始日期
    var ordEdDate = $('#dateOrdEnd').datebox('getValue'); //截止日期
    var ordStTime = $('#timeOrdStart').timespinner('getValue');
    var ordEdTime = $('#timeOrdEnd').timespinner('getValue');
    var patNo = $('#txtPatNo').val();
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    paramsArr[0] = ordStDate;
    paramsArr[1] = ordEdDate;
    paramsArr[2] = ordStTime;
    paramsArr[3] = ordEdTime;
    paramsArr[4] = locId;
    paramsArr[5] = patNo;
    paramsArr[6] = wardId;
    return paramsArr;
}