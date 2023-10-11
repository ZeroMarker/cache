/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.24
 *  Description 门诊药房--发药查询
 *  JS          scripts/pha/op/v4/query.disp.js
 */
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
var COM_PID = "";
$(function () {
    var $lyBody = $('#layout-op—condition');
    $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-op-con-more-less').toggle();
        var tHeight = $('.pha-op-con-more-less').css('display') === 'none' ? 138 : 178;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });
    COMPOMENTS = OP_COMPOMENTS;
    InitGridPrescList();        //  处方列表
    InitGridPrescIncDetail();   //  处方明细--按药品
    InitGridPrescInclbDetail(); //  处方明细--按批次
    InitDict();                 //  
    InitEvent();                //  按钮事件
    ResizePanel();              //  布局调整    
    Clean();                    //  包含初始化查询条件
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    //表格 toolbar
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnExportMain',        'click', function () {
        PHAOP_COM.ExportGrid("gridPrescList");
    });
    PHA_EVENT.Bind('#btnExportDetail',      'click', function () {
        if($("#divInclbDetail").css("display")=="none"){
            PHAOP_COM.ExportGrid("gridPrescIncDetail");
        }else{
            PHAOP_COM.ExportGrid("gridPrescInclbDetail");
        }
    });
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
            layoutId: 'layout-op—grid',
            region: 'east',
            width: 0.2 
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid-presc',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
    // 药品下拉表格
    PHA_UX.ComboBox.INCItm('inci', {
        width: 236,
        qParams: {
            pJsonStr: {
                stkType: App_StkType,
                scgId: "",
                locId: PHAOP_COM.LogonData.LocId
            }
        }
    });
     // 发药人窗口
    PHA.ComboBox('fyPerId',{
        blurValidValue:true, 
        url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=1"
    });
     // 配药人窗口
    PHA.ComboBox('pyPerId',{
        blurValidValue:true, 
        url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=2"
    });
    InitDispStat()
}
//初始化发药状态
function InitDispStat(){
    var data = [
        { RowId: 1, Description: $g("已发药") },
        { RowId: 2, Description: $g("未发药") },
        { RowId: 3, Description: $g("未配药确认") }, 
        { RowId: 4, Description: $g("已配药未确认") }, 
        { RowId: 0, Description: $g("已配药未发药") }
     ];
    PHA.ComboBox('dispState',{
        editable:false, 
        data: data,
        onSelect:function(data){
            QueryPrescList()
        }
    }); 
}
// 初始化查询条件
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#dispState").combobox("setValue",1) ;
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridPrescList(){
    var frozenCol=[[
        {field:'pid',               title: ("进程号"),         width:100,      align:'left',   hidden:true},
        {field:'docLocDesc',        title: ("开单科室"),        width:120,      align:'left'},
        {field:'admId',             title:"admId",              width:100,      align:'left',   hidden:true},
        {field:'patNo',             title: ("登记号"),         width:90,       align:'left',
            formatter: function (value, rowData, index) {
                return '<a class="pha-op-grid-link">' + value + '</a>';
            }
        }, 
        {field:'patName',           title: ("姓名"),          width:100,      align:'left'},
        {field:'admReasonDesc',     title: ("费别"),          width:80,       align:'left'},
        {field:'prescNo',           title: ("处方号"),         width:120,      algin:'left'},
        {field:'fyWinDesc',         title: ("发药窗口"),        width:80,       algin:'left'}
        
    ]];
    var normalCol = [[
        {field:'spAmt',             title: ("药费"),          width:80,       align:'right'},
        {field:'prtDate',           title: ("收费日期"),        width:90,       align:'left'}, 
        {field:'pyDate',            title: ("配药日期"),        width:90,       align:'left'}, 
        {field:'fyDate',            title: ("发药日期"),        width:90,       align:'left'}, 
        {field:'pyUserName',        title: ("配药人"),         width:80,       align:'left'},
        {field:'fyUserName',        title: ("发药人"),         width:80,       align:'left'},
        {field:'prtTime',           title: ("收费时间"),        width:70,       align:'left'}, 
        {field:'pyTime',            title: ("配药时间"),        width:70,       align:'left'}, 
        {field:'fyTime',            title: ("发药时间"),        width:70,       align:'left'}, 
        {field:'oeoriDateTime',     title: ("医嘱时间"),        width:90,       align:'left'},
        {field:'prescRemark',       title: ("处方备注"),        width:80,       align:'left'},
        {field:'diagDesc',          title: ("诊断"),          width:200,      align:'left'},
        {field:'rpAmt',             title: ("进价金额"),        width:100,      align:'right',  hidden:true},
        {field:'encryptLevel',      title: ("病人密级"),        width:80,       align:'left',   hidden: PHAOP_COM.ColHidden.PatLevel},
        {field:'patLevel',          title: ("病人级别"),        width:80,       align:'left',   hidden: PHAOP_COM.ColHidden.PatLevel},
        {field:'phdId',             title: ("发药表Id"),       width:80,       align:'left',   hidden:true},
        {field:'phdOweId',          title: ("欠药指针Id"),  width:80,       align:'left',   hidden:true}
    ]]
    COMPOMENTS.ComomGrid("gridPrescList",{
        columns: normalCol,
        frozenColumns: frozenCol,
        onSelect : function(rowIndex, rowData) {
            QueryPrescDetail();
            ShowPrescTimeLine();
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridPrescList').datagrid("selectRow",0);
                COM_PID = $('#gridPrescList').datagrid("getRows")[0].pid;
                $('#gridPrescList').datagrid("options").queryParams.pid =COM_PID;
            }else{
                $('#gridPrescIncDetail').datagrid('clear');
                $('#gridPrescInclbDetail').datagrid('clear');
                $('#prescTimeLine').children().remove();
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
function InitGridPrescIncDetail(){
    var normalCol = [[      
        {field:'incDesc',           title: ("药品名称"),        width:200,      align:'left'}, 
        {field:'dspQty',            title: ("医嘱数量"),        width:60,       align:'right'},   
        {field:'qty',               title: ("实发数量"),        width:60,       align:'right'},
        {field:'uomDesc',           title: ("单位"),          width:80,       align:'left'},
        {field:'spAmt',             title: ("金额"),          width:80,       align:'right'},
        {field:'oeoriStatDesc',     title: ("状态"),          width:60,       align:'left'},
        {field:'dosage',            title: ("剂量"),          width:70,       align:'left'},
        {field:'freqDesc',          title: ("频次"),          width:70,       align:'left'},
        {field:'instrucDesc',       title: ("用法"),          width:70,       align:'left'},
        {field:'duraDesc',          title: ("疗程"),          width:70,       align:'left'},
        //{field:'docName',             title: ("医师"),          width:70,       align:'left'    ,hidden:true},
        {field:'stkBinStr',         title: ("货位"),          width:100,      align:'left'},
        {field:'retQty',            title: ("退药"),          width:70,       align:'left'},
        {field:'oeoriRemark',       title: ("医嘱备注"),        width:100,      align:'left'},
        {field:'cInsuCode',         title: ("国家医保编码"),  width:120,      align:'left'},
        {field:'cInsuDesc',         title: ("国家医保名称"),  width:120,      align:'left'}
    ]];
    COMPOMENTS.ComomGrid("gridPrescIncDetail",{
        columns: normalCol
    })
}
function InitGridPrescInclbDetail(){
    var normalCol = [[      
        {field:'incDesc',           title: ("药品名称"),        width:200,      align:'left'}, 
        {field:'qty',               title: ("实发数量"),        width:60,       align:'right'},
        {field:'uomDesc',           title: ("单位"),          width:80,       align:'left'},
        {field:'sp',                title: ("售价"),          width:80,       align:'right'},
        {field:'spAmt',             title: ("售价金额"),        width:80,       align:'right'},
        {field:'batNo',             title: ("批号"),          width:60,       align:'left'},
        {field:'expDate',           title: ("有效期"),             width:70,       align:'left'},
        {field:'retQty',            title: ("退药"),          width:70,       align:'left'},
        {field:'inclb',             title: ("批次id"),            width:100,      align:'left'    ,hidden:true},
        {field:'cInsuCode',         title: ("国家医保编码"),  width:120,      align:'left'},
        {field:'cInsuDesc',         title: ("国家医保名称"),  width:120,      align:'left'}
    ]];
    COMPOMENTS.ComomGrid("gridPrescInclbDetail",{
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
    COM_PID = ""
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DispQuery.Api' ,
        pMethodName:'GetDispMain',
        pPlug:'datagrid',
        pid:"",
        pJson: JSON.stringify(pJson)
    }); 

}
function ChangShowDetailType(){
    if($("#divInclbDetail").css("display")=="none"){
        $("#divIncDetail").hide();
        $("#divInclbDetail").show();
        $("#divDetail").panel({
            title:"发药批次列表"
        });
    }else{
        $("#divInclbDetail").hide();
        $("#divIncDetail").show();
        $("#divDetail").panel({
            title:"药品列表"
        });
    }
    QueryPrescDetail();
}
// 查询处方明细
// 查询处方明细
function QueryPrescDetail(){    
    if($("#divIncDetail").css("display")=="block"){
        QueryPrescIncDetail();
    }else if ($("#divInclbDetail").css("display")=="block"){
        QueryPrescInclbDetail()
    }
}
function QueryPrescIncDetail(){ 
    var $grid =  $("#gridPrescIncDetail");
    var rowData = $("#gridPrescList").datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "请选择处方数据！");
        return false;
    }
    var pJson = {
        phdId:rowData.phdId,
        prescNo:rowData.prescNo,
        locId:PHAOP_COM.LogonData.LocId
    };
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DispQuery.Api' ,
        pMethodName:'GetDispIncDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryPrescInclbDetail(){   
    var $grid =  $("#gridPrescInclbDetail");
    var rowData = $("#gridPrescList").datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "请选择处方数据！");
        return false;
    }
    var pJson = {
        phdId:rowData.phdId,
        prescNo:rowData.prescNo,
        locId:PHAOP_COM.LogonData.LocId
    };
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DispQuery.Api' ,
        pMethodName:'GetDispInclbDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescIncDetail').datagrid('clear');
    $('#gridPrescInclbDetail').datagrid('clear');
    $('#prescTimeLine').children().remove();
    InitDefVal();
    KillTmpGloal();
}

// 打印
function Export(){

}
// 读卡
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
function ShowPrescTimeLine(){
    var rowData = $('#gridPrescList').datagrid('getSelected');
    if(rowData==null){
        var prescNo="";
    }else{
        var prescNo=rowData.prescNo;
    }
    PHAOP_COM.PrescTimeLine({
        prescNo:prescNo,
        timeLine:'prescTimeLine'
    })

}
// 清除临时global
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("DispQuery.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}

