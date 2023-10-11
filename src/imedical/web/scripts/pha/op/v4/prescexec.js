var hisPatNoLen=""; //登记号长度

$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    GetPhaHisCommonParmas();    //登记号长度
    InitDict();
    InitPrescExecGrid();
    $("#btnFind").on("click", Query);
    $("#btnExec").on("click", Exectuce);
    $("#btnClean").on("click", Clean);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#conPatNo").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, hisPatNoLen);
                $(this).val(newpatno);
                if(newpatno==""){return;}
                Query();
            }
        }
    });
    $('#conPrescNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            Query();
            
        }
    });
    

})
function InitDict(){
    var comWidth=180;
    var extendWIdth = 0;
    if(PHA_UX.IsLiteCss){extendWIdth=7;}
    $('#conPhStDate').datebox('setValue', 't-1');
    $('#conPhEndDate').datebox('setValue', 't');
    
    PHA.ComboBox("conExecFlag",{
        required: false,
        width:comWidth+extendWIdth,
        data:[
            {RowId:"0",Description:$g("未执行")},
            {RowId:"1",Description:$g("已执行")}
        ]
    })
    $('#conExecFlag').combobox('setValue', "0");

    var opts = $.extend({}, PHAOP_STORE.PhlocFlow(), {
        width: comWidth,
        onLoadSuccess:function(data){
        
        }
    });
    PHA.LookUp('conPrescState', opts);

    
}
function InitPrescExecGrid(){
    var columns = [[
        {field: 'CheckFlag',checkbox:true,checked:true },
        {field: 'PapmiId',title: 'AdmId',width: 100,hidden: true},
        {field: 'AdmId',title: 'AdmId',width: 100,hidden: true},
        {field: 'PatNo',title: '登记号',width: 100},
        {field: 'PatName',title: '姓名',width: 100},
        {field: 'PrescNo',title: '处方号',width: 100},
        {field: 'PatAge',title: '年龄',width: 100,hidden: true},
        {field: 'PatSex',title: '性别',width: 100,hidden: true},
        {field: 'DiagDesc',title: '诊断',width: 100},
        {field: 'PrescItmArr',title: '药品名称',width: 250,formatter: PHA_OP.Grid.Formatter.InciGroup},
        {field: 'Qty',title: '数量',width: 60,formatter: PHA_OP.Grid.Formatter.QtyUomGroup},
        {field: 'InstDesc',title: '用法',width: 60,formatter: PHA_OP.Grid.Formatter.InstGroup},
        {field: 'DoseQty',title: '剂量',width: 60,formatter: PHA_OP.Grid.Formatter.DosageGroup},
        {field: 'FreqDesc',title: '频次',width: 60,formatter: PHA_OP.Grid.Formatter.FreqGroup}
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {            
            ClassName: 'PHA.OP.PrescExec.Query',
            QueryName: 'QueryPresc',
            pJsonStr: JSON.stringify({ hospId: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        columns: columns,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers:true,
        fitColumns: true,
        pagination: false,
        onRowContextMenu:"",
        pageSize:9999,
        toolbar: '#gridPrescExecBar',
        onLoadSuccess: function(data) {
            if(data.total>0){
                $('#gridPrescExec').datagrid("checkAll"); 
            }
        }
    };
    PHA.Grid('gridPrescExec', dataGridOption);
}
function Query(){
    var pJson = {};
    pJson.locId = session['LOGON.CTLOCID']; 
    pJson.startDate =  $("#conPhStDate").datebox("getValue")|| ""; ;
    pJson.endDate =  $("#conPhEndDate").datebox("getValue")|| ""; ; 
    var patNo=$("#conPatNo").val() || "";
    var prescNo=$("#conPrescNo").val() || "";
    var prescState=$("#conPrescState").lookup("getValue")|| ""; 
    var execFlag=$("#conExecFlag").combobox("getValue")|| ""; 
    pJson.patNo =  patNo;
    pJson.prescNo = prescNo;
    
    pJson.prescState =  prescState;
    if(prescState==""){
        PHA.Popover({
            msg: '请选择流程状态',
            type: 'alert'
        });
        return;
    }
    
    pJson.execFlag =  execFlag;
    if((execFlag=="0")&&(patNo=="")&&(prescNo=="")){
        PHA.Popover({
            msg: '请输入登记号或者处方号',
            type: 'alert'
        });
        return;
    }
    $("#gridPrescExec").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}
function Exectuce(){
    var checkData=$("#gridPrescExec").datagrid('getChecked');
    dataRows=checkData.length;
    if(dataRows==0){ 
        PHA.Popover({
            msg: '没有选中数据',
            type: 'alert'
        });
        return;
    }
    var prescState=$("#conPrescState").lookup("getValue")|| ""; 
    var execFlag=$("#conExecFlag").combobox("getValue")|| ""; 
    if(execFlag=="1"){
        PHA.Popover({
            msg: '执行状态为已执行',
            type: 'alert'
        });
        return;
    }
    
    var dataArr = [];
    for (var i = 0; i < dataRows; i++) {
        var rowData = checkData[i];
        var prescNo=rowData.PrescNo;
        var iJson = {
            prescNo:prescNo,
            userId: session['LOGON.USERID'],
            opFlowDr:prescState
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.PrescExec.OperTab',
            pMethodName: 'SavePrescState',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $('#gridPrescExec').datagrid('reload');
}
function Clean(){
    $('#conPhStDate').datebox('setValue', 't-1');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#conPatNo").val('');
    $("#conPrescNo").val('');
    $("#conPrescState").lookup("setValue", '');
    $("#conPrescState").lookup("setText", '');
    $('#conExecFlag').combobox('setValue', "0");
    $('#gridPrescExec').datagrid('clear');
}
 