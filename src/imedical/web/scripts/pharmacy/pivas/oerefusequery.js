/**
 * 模块:     拒绝配液医嘱查询
 * 编写日期: 2018-06-25
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
$(function() {
    InitDict();
    InitGridOrdExe();
    $("#btnFind").on('click', Query);
    setTimeout(Query, 500);
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var patNo = PIVAS.PadZero(patNo, hisPatNoLen);
                $("#txtPatNo").val(patNo);
                Query();
            }
        }
    });
});

function InitDict() {
    // 日期
    PIVAS.Date.Init({ Id: 'dateOrdStart', DateT: "t-1" });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', DateT: "t+1" });
}

// 医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'wardDesc', title: '病区', width: 150, hidden: true },
            { field: 'operReason', title: '配液拒绝原因', width: 150 },
            { field: 'doseDateTime', title: '用药日期', width: 95 },
            { field: 'bedNo', title: '床号', width: 75 },
            { field: 'patNo', title: '登记号', width: 100 },
            { field: 'patName', title: '姓名', width: 100 },
            {
                field: 'batNo',
                title: '批次',
                width: 50,
                styler: function(value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != "") {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                align: 'center',
                styler: function(value, row, index) {
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // 偶数行变色,按病人的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: '药品', width: 250 },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 75 },
            { field: 'priDesc', title: '优先级', width: 75 },
            { field: "packFlag", title: '打包', width: 85, hidden: true },
            { field: 'ordRemark', title: '备注', width: 75 },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: false },
            { field: 'colColor', title: 'colColor', width: 50, hidden: true },
            { field: "pogId", title: 'pogId', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        view: scrollview,
        toolbar: "#gridOrdExeBar",
        onSelect: function(rowIndex, rowData) {
            /* scrollview行数需按页计算,且分页间隔处有问题
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
            */
        },
        onUnselect: function(rowIndex, rowData) {
            $('#gridOrdExe').datagrid("unselectAll");
        },
        onClickCell: function(rowIndex, field, value) {},
        rowStyler: function(index, row) {}
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

function Query() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.OeRefuseQuery",
        QueryName: "QueryOeRefuse",
        inputStr: LoadAdmId + "^" + SessionLoc + "^" + $('#dateOrdStart').datebox('getValue') + "^" + $('#dateOrdEnd').datebox('getValue')+ "^" + $.trim($("#txtPatNo").val()),
        ResultSetType: "array",
        page: 1,
        rows: 9999
    }, function(retJson) {
        $("#gridOrdExe").datagrid("loadData", retJson)
    })
}