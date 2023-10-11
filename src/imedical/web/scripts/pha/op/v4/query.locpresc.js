/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.09-05
 *  Description 门诊药房--处方集中打印
 *  JS          scripts/pha/op/v4/query.locpresc.js
 */
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
var COM_PID = "";
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    InitGridPrescList();    //  处方列表
    InitGridPrescDetail();  //  处方明细
    InitDict();             
    InitEvent();            //  按钮事件
    ResizePanel();          //  布局调整    
    Clean();                //  包含初始化查询条件
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    //表格 toolbar
    PHA_EVENT.Bind('#btnRePrint',       'click', function () {RePrint();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnExport',        'click', function () {Export();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryPrescList();
            }
        }
    });
    //卡号回车事件
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            if (cardNo != "") {
                ReadCard();
            }
        }
    });
}
// 布局调整
function ResizePanel(){ 
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
    // 医生科室--  医生科室、急诊、手术科室
    PHA.ComboBox('docLoc',{
        blurValidValue:true,
        url:  PHAOP_STORE.CTLOC().url+"&TypeStr="+"E,EM,OP" 
    });
     PHA.ComboBox('prescType',{
        blurValidValue:true,
        panelHeigh:"auto",
        url:  PHA_STORE.ComDictionary("PrescType").url 
    });
    
}
// 初始化查询条件
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#fyFlag").checkbox('setValue', true);
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridPrescList(){
    var frozenCol=[[
        {field:'gridSelect',        checkbox: true },
        {field:'prescStat',         title: ("状态-todo"),     width:100,      align:'center',     hidden:true},
        {field:'docLocDesc',        title: ("开单科室"),        width:140,      align:'left'},
        {field:'patNo',             title: ("登记号"),         width:90,       align:'center',
            formatter: function (value, rowData, index) {
                return '<a class="pha-op-grid-link">' + value + '</a>';
            }
        },  
        {field:'patName',           title: ("姓名"),          width:100,      align:'left'},   
        {field:'spAmt',             title: ("药费"),          width:75,       align:'right'},
        {field:'prescNo',           title: ("处方号"),         width:125,      align:'center'},
        {field:'prescType',         title: ("处方类型"),        width:75,       align:'center'},
    ]];
    var normalCol = [[
        {field:'diagDesc',          title: ("诊断"),          width:200,      align:'left'},
        {field:'prtDate',           title: ("收费日期"),        width:90,       align:'center'},
        {field:'prtTime',           title: ("收费时间"),        width:90,       align:'center'},
        {field:'fyDate',            title: ("发药日期"),        width:90,       align:'center'},
        {field:'fyTime',            title: ("发药时间"),        width:90,       align:'center'},
        {field:'pyUserName',        title: ("配药人"),         width:90,       align:'left'},
        {field:'fyUserName',        title: ("发药人"),         width:90,       align:'left'},
        {field:'winDesc',           title: ("发药窗口"),        width:90,       align:'left'},
        {field:'encryptLevel',      title: ("病人密级"),        width:100,      align:'left',       hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'patLevel',          title: ("病人级别"),        width:100,      align:'left',       hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'admId',             title:"admId",              width:100,      align:'left',       hidden:true},
        {field:'pid',               title:"pid",                width:100,      align:'left',       hidden:true}
            
    ]]
    COMPOMENTS.ComomGrid("gridPrescList",{
        columns: normalCol,
        frozenColumns: frozenCol,
        toolbar : '#gridPrescListBar',
        onSelect : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridPrescList').datagrid("selectRow",0);
                COM_PID = $('#gridPrescList').datagrid("getRows")[0].pid;
                $('#gridPrescList').datagrid("options").queryParams.pid =COM_PID;
            }else{
                $('#gridPrescDetail').datagrid('clear');
            }
        }
    })
    var eventClassArr = [];
    eventClassArr.push('pha-op-grid-link');
    PHA.GridEvent('gridPrescList', 'click', eventClassArr, function(rowIndex, rowData, className){
        PHA_UX.AdmDetail({},{
            AdmId:rowData.admId
        })
    })
}
function InitGridPrescDetail(){
    var normalCol = [[
         {field:'oeoriStatDesc',        title: ("状态"),      width:60,       align:'center',
            styler: function(value, rowData, index) {
                var styleCls = "";
                if ((value.indexOf($g("作废")) > -1) || (value.indexOf("停止") > -1)) {
                    styleCls = {class:'pha-op-grid-ordstop'};
                }
                return styleCls;
            }
        }, 
        {field:'arcItmDesc',            title: ("药品"),      width:200,      align:'left'},  
        {field:'oeoriQty',              title: ("医嘱数量"),    width:65,       align:'right'},     
        {field:'uomDesc',               title: ("单位"),      width:80,       align:'center'},    
        {field:'sp',                    title: ("价格"),      width:80,       align:'right'},
        {field:'spAmt',                 title: ("金额"),      width:80,       align:'right'},
        {field:'dosage',                title: ("剂量"),      width:80,       align:'left'},    
        {field:'freqDesc',              title: ("频次"),      width:80,       align:'left'},
        {field:'instrucDesc',           title: ("用法"),      width:80,       align:'left'},    
        {field:'duraDesc',              title: ("疗程"),      width:80,       align:'left'},
        {field:'dispQty',               title: ("已发药"),     width:50,       align:'left'}, 
        {field:'retQty',                title: ("已退药"),     width:50,       align:'left'},    
        {field:'oeoriRemark',           title: ("医嘱备注"),    width:120,      align:'left'}
    ]];
    COMPOMENTS.ComomGrid("gridPrescDetail",{
        columns: normalCol
    })
}
function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    pJson.locId = PHAOP_COM.LogonData.LocId;
    return pJson;
}
// 查询处方列表
function QueryPrescList(){
    COM_PID = "";
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreBatPrt.Api' ,
        pMethodName:'GetPrescList',
        pPlug:'datagrid',
        pid:"",
        pJson: JSON.stringify(pJson)
    }); 

}

// 查询处方明细
function QueryPrescDetail(){    
    var $grid =  $("#gridPrescDetail");
    var rowData = $("#gridPrescList").datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "请选择处方数据！");
        return false;
    }
    var pJson = {};
    pJson.prescNo = rowData.prescNo;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreBatPrt.Api' ,
        pMethodName:'GetPrescDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescList').datagrid("uncheckAll")
    $('#gridPrescDetail').datagrid('clear');
    InitDefVal();
    KillTmpGloal();
    COM_PID = "";
}
// 打印
function RePrint(){
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    for (var i = 0; i < checkedRows.length; i++) {
        var rowData = checkedRows[i];
        var prescNo = rowData.prescNo;
        OP_PRINTCOM.Presc(prescNo,"正方", "");
    }
}

function Export(){
    PHAOP_COM.ExportGrid("gridPrescList");
}
// 读卡
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
// 清除临时global
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("PreBatPrt.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}