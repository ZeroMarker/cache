/**
 * 模块:     不合理处方查询(医生)
 * 编写日期: 2018-05-15
 * 编写人:   QianHuanjuan
 */

var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitGridOrdItm();
    InitGridCommentLog();
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbComResult',
        data: {
            data: [
                { RowId: 0, Description: "不合格" },
                { RowId: 1, Description: "已接受" },
                { RowId: 2, Description: "已申诉" }
            ]
        }
    }, {
	    editable:false,
        placeholder: '点评结果...',
        onSelect:function(selData){
	    	Query();
	    }
    });
    $("#cmbComResult").combobox("setValue",0)
    $("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#btnFind").on("click", Query);
    $("#btnComplain").on("click", function() {
        MainTain("C");
    });
    $("#btnAccept").on("click", function() {
        MainTain("A");
    });
    window.resizeTo(screen.availWidth, screen.availHeight);
    //$("#txtDocNote").width($("#layoutEast").width()-8);
    setTimeout(Query,300);
});

function InitGridOrdItm() {
    var columns = [
        [
            { title: '开单时间', field: 'oeoriDateTime', width: 155 },
            { title: '组', field: 'oeoriSign', width: 30, align:'center',
            	formatter: DHCPHA_HUI_COM.Grid.Formatter.OeoriSign
            },
            { title: '医嘱名称', field: 'incDesc', width: 200 },
            { title: '数量', field: 'qty', width: 50, align: 'right' },
            { title: '单位', field: 'uomDesc', width: 50},
            { title: '剂量', field: 'dosage', width: 60},
            { title: '用法', field: 'instrucDesc', width: 60 },
            { title: '频率', field: 'freqDesc', width: 60},
            { title: '疗程', field: 'duraDesc', width: 60},
            { title: '规格', field: 'spec', width: 60 ,hidden: true},
            { title: '优先级', field: 'priDesc', width: 60 },
            { title: '医生', field: 'docName', width: 60},
            { title: '备注', field: 'remark', width: 100 },
            { title: 'mOeori', field: 'mOeori', width: 60, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTCNTS.FindForDoctor&MethodName=JsGetOrdDataForDoctor",
        queryParams: {},
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
        onSelect: function(rowIndex, rowData) {
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItm',
                Field: 'mOeori',
                Check: true,
                Value: rowData.mOeori,
                Type: 'Select'
            });
        },
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                QueryCommentLog();
            }
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onLoadSuccess: function() {
			$("#gridCommentLog").datagrid("clear");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdItm", dataGridOption);
}

function InitGridCommentLog() {
    var columns = [
        [
            { title: '组号', field: 'comReaGrpNo', width: 40},
            { title: '点评原因', field: 'comReasonDesc', width: 260},
            { title: '点评日期', field: 'comDate', width: 100},
            { title: '点评时间', field: 'comTime', width: 100},
            { title: '点评人', field: 'comUserName', width: 80 },
            { title: '点评结果', field: 'comResult', width: 100},
            { title: '不合格警示值', field: 'comFactorDesc', width: 80, hidden: true},
            { title: '药师建议', field: 'comAdviceDesc', width: 150},
            { title: '医生反馈', field: 'comDocAdviceDesc', width: 100, hidden: true},
            { title: '药师备注', field: 'comPhNotes', width: 200 },
            { title: '医生备注', field: 'comDocNotes', width: 200 },
            { title: '有效', field: 'comActive', width: 50},
            { title: 'logRowId', field: 'logRowId', width: 100, hidden: false }
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTCNTS.FindForDoctor&MethodName=JsGetLogForDoctor",
        queryParams: {},
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 500,
        pageList: [500],
        pagination: false,
        onSelect: function(rowIndex, rowData) {
	        if (rowData.comActive!="Y"){
		    	$(this).datagrid("unselectAll");
		    }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridCommentLog',
                Field: 'logRowId',
                Check: true,
                Value: rowData.logRowId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onLoadSuccess: function() {
			DHCPHA_HUI_COM.Grid.CellTip({ TipArr: ['comReasonDesc'] });
        },
		rowStyler:function(index,row){ 
			if (row.comActive!="Y"){
				return "background:#f5f6f5";	
			}
		} 
    }
    DHCPHA_HUI_COM.Grid.Init("gridCommentLog", dataGridOption);
}

// 获取参数
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var comResult=$('#cmbComResult').combobox('getValue')||'';
    return stDate + "^" + edDate + "^" + SessionUser+"^"+comResult;
}
// 查询
function Query() {
    var params = QueryParams();
    $('#gridOrdItm').datagrid({
        queryParams: {
            inputStr: params
        }
    });

}
// 查询点评原因
function QueryCommentLog() {
    var gridSelect = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelect==null){
	    $('#gridCommentLog').datagrid('clear');	
	    return;
	}
    var mOeori = gridSelect.mOeori;
    $('#gridCommentLog').datagrid({
        queryParams: {
            inputStr: mOeori
        }
    });
}

//申诉或者接受不合理处方
function MainTain(type) {
    var gridSelOrdItm = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelOrdItm == null) {
        $.messager.alert("提示", "请先选中医嘱明细", "warning");
        return;
    }
    var gridSelComment = $('#gridCommentLog').datagrid('getSelected');
    if (gridSelComment == null) {
        $.messager.alert("提示", "请先选中需要" + ((type == "A") ? "接受" : "申诉") + "的点评不合理原因记录!", "warning");
        return;
    }
    var comActive = gridSelComment.comActive;
    if (comActive != "Y") {
        $.messager.alert("提示", "请选择有效的原因记录", "warning");
        return;
    }
    var logRowId = gridSelComment.logRowId;
    if (type == "C") {
        var docNote = $("#txtDocNote").val().trim(); // 医生备注	  
        if (docNote == "") {
            $.messager.alert("提示", "请在下方原因录入中填写申诉原因", "warning");
            return;
        }
    } else if (type == "A") {
        var docNote = "Accept"; 					// 医生备注	  
    }
    var params = logRowId + "^" + docNote;
    var saveRet = tkMakeServerCall("web.DHCSTCNTS.FindForDoctor","SaveDocAdvice", params);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
        return;
    }
    $("#txtDocNote").val("");
    Query();
    if(top && top.HideExecMsgWin) {
	    top.HideExecMsgWin();

	}

}