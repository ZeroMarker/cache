/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.09.06
 *  Description 门诊药房--日消耗统计
 *  JS          scripts/pha/op/v4/stat.rxb.js
 */
var COMPOMENTS ={};
var COM_PID = "" ;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    COMPOMENTS = OP_COMPOMENTS;
    InitGridDailyConsume(); //  处方列表
    InitGridOrder();
    InitDict();
    InitEvent();            //  按钮事件
    Clean();                //  包含初始化查询条件
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryDailyConsume();});
    //表格 toolbar
    PHA_EVENT.Bind('#btnPrint',         'click', function () {Print();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnExport',        'click', function () {Export();});
}
function InitDict(){
    // 药品下拉表格
    PHA_UX.ComboBox.INCItm('inci', {
        qParams: {
            pJsonStr: {
                stkType: App_StkType,
                scgId: "",
                locId: PHAOP_COM.LogonData.LocId
            }
        }
    });
    /* // 发药人
    PHA.ComboBox('fyPerId',{
        blurValidValue:true, 
        //url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=1",
        url: PHA_STORE.SSUser(PHAOP_COM.LogonData.LocId,"").url

    });*/
     // 发药人
     PHA.ComboBox('fyUserId',{
        blurValidValue:true, 
        url: PHA_STORE.SSUser(PHAOP_COM.LogonData.LocId,"").url
    });
     // 库存分类
    PHA.ComboBox('incCatId',{
        blurValidValue:true, 
        url: PHA_STORE.INCStkCat().url
    });
     // 管理组
    PHA.ComboBox('manGrpId',{
        blurValidValue:true, 
        url: PHA_STORE.LocManGrp(PHAOP_COM.LogonData.LocId).url
    });
    PHA.TriggerBox('phcCatId', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('phcCatId', {}, function (data) {
                $('#phcCatId').triggerbox('setValue', data.phcCatDescAll);
                $('#phcCatId').triggerbox('setValueId', data.phcCatId);
            });
        },
        width: 396
    });
}
// 初始化查询条件
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridDailyConsume(){
    var normalCol = [[
        {field: 'incCode',          title: ("药品代码"),            width: 120,         align: 'left'},
        {field: 'incDesc',          title: ("药品名称"),            width: 250,         align: 'left',
            formatter: function (value, rowData, index) {
                if((rowData.incCode == $g("合计"))||(rowData.incCode == undefined)){           
                    return value
                }else{
                    return '<a class="pha-op-grid-link incDesc">' + value + '</a>';
                }
            }
        },
        {field: 'qty',              title: ("发出数量"),            width: 100,         align: 'right',         sortable: true},
        {field: 'uomDesc',          title: ("单位"),                width: 100,         align: 'left'},
        {field: 'sp',               title: ("售价"),                width: 75,          align: 'right',         sortable: true},
        {field: 'spAmt',            title: ("发出金额"),            width: 100,         align: 'right',         sortable: true},
        {field: 'rp',               title: ("进价"),                width: 75,          align: 'right',         sortable: true},
        {field: 'rpAmt',            title: ("进价金额"),            width: 100,         align: 'right',         sortable: true},
        {field: 'manfDesc',         title: ("生产企业"),            width: 200,         align: 'left'},
        {field: 'pid',              title: ("进程号"),              width: 200,         align: 'left',          hidden: true},  
        {field: 'incId',            title: ("药品id"),              width: 200,         align: 'left',          hidden: true},  
        {field: 'detail',           title: ("明细"),                width: 100,         align: 'left',
             formatter: function (value, rowData, index) {
                if((rowData.incCode == $g("合计"))||(rowData.incCode == undefined)){           
                    return ""
                }else{
                    return '<a class="pha-op-grid-link detail">' + $g("消耗明细")+">>" + '</a>';
                }
            }
        }    
    ]];
    COMPOMENTS.ComomGrid("gridDailyConsume",{
        toolbar : '#gridDailyConsumeBar',
        columns: normalCol,
        showFooter: true,
        onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridDailyConsume').datagrid("selectRow",0);
                COM_PID = $('#gridDailyConsume').datagrid("getRows")[0].pid;
                $('#gridDailyConsume').datagrid("options").queryParams.pid =COM_PID;
                PHA_COM.SumGridFooter('#gridDailyConsume' , ['rpAmt', 'spAmt']);
            }
        }
    })
    var eventClassArr = [];
    eventClassArr.push('pha-op-grid-link incDesc');
    eventClassArr.push('pha-op-grid-link detail');
    PHA.GridEvent('gridDailyConsume', 'click', eventClassArr, function(rowIndex, rowData, className){
        if (className === 'pha-op-grid-link incDesc') {
            PHA_UX.DrugDetail({},{
                inci:rowData.incId
            })
        }
        if (className === 'pha-op-grid-link detail') {
            QueryOrderHandler({
                inci:rowData.incId,
                pid:rowData.pid
            })
        }
    })
}
function InitGridOrder() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '开单科室'
            },
            {
                field: 'locDesc',
                title: '领药科室'
            },
            {
                field: 'bedNo',
                title: '床号'
            },
            {
                field: 'patNo',
                title: '登记号'
            },
            {
                field: 'patName',
                title: '姓名'
            },
            {
                field: 'dosage',
                title: '剂量'
            },
            {
                field: 'freqDesc',
                title: '频次'
            },
            {
                field: 'instrucDesc',
                title: '用法'
            },
            {
                field: 'busiType',
                title: '类型',                
                styler: function (value, row, index) {
                    if (value === 'P' || value === 'F' ) {
                        //return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'Y' || value === 'H') {
                        return { class: 'op-grid-cell-ret' };
                    } else if (value === 'HC') {
                        return { class: 'op-grid-cell-ret' };
                    }
                },
                formatter: function (value, row, index) {
                    if (value === 'HC') return $g("撤消退药")
                    return value === 'P' || value === 'F' ? $g('发药') : $g('退药');
                }
            },
            {
                field: 'qtyUom',
                title: '数量'
            },
            {
                field: 'spAmt',
                title: '金额',
                align: 'right'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
                formatter: function (value, row, index) {
                    var busiType = row.busiType;
                    if (busiType === 'P' || busiType === 'Y') {
                        return '<a class="pha-op-grid-link oeore">' + value + '</a>';
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'prescNo',
                title: '处方号',
                align: 'center',
                formatter: function (value, row, index) {
                    var busiType = row.busiType;
                    if (busiType === 'F' || busiType === 'H'|| busiType === 'HC') {
                        return '<a class="pha-op-grid-link prescno">' + value + '</a>';
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'oeoriDateTime',
                title: '开单时间',
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '护士处理医嘱信息',
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '领药审核信息'
            },
            {
                field: 'phaInfo',
                title: '发、退药信息'
            },
            {
                field: 'phaNo',
                title: '业务单号'
            }
        ]
    ];
    COMPOMENTS.ComomGrid("gridOrder",{
        toolbar : "",
        border: true,
        columns: columns
    })
    
    PHA.GridEvent('gridOrder', 'click', ['pha-op-grid-link oeore', 'pha-op-grid-link prescno'], function (rowIndex, rowData, className) {
        var winOpts = $('#winOrder').window('options');
        var winTop = winOpts.top;
        var winWidth = winOpts.width;
        var winLeft = winOpts.left;
        if (className === 'pha-op-grid-link oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { oeore: rowData.oeore }
            );
        }
        if (className === 'pha-op-grid-link prescno') {
            PHA_OP.PrescTimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { prescNo: rowData.prescNo }
            );
        }
    });
}
function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    pJson.locId = PHAOP_COM.LogonData.LocId;
    return pJson;
}
// 查询退药汇总
function QueryDailyConsume(){
    KillTmpGloal();
    COM_PID = "";
    var $grid =  $("#gridDailyConsume");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DayCons.Api' ,
        pMethodName:'GetRXBStat',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryOrderHandler(pJson) {
    var $grid =  $("#gridOrder");
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DayCons.Api' ,
        pMethodName:'GetDetailData',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 

    $('#winOrder')
        .window({
            width: $('body').width()*0.8,
            height: $('body').height() * 0.8,
            //top: 20,
            //left: 20,
            closed: true,
            iconCls: 'icon-w-clock',
            resizable: true,
            modal:function(){
                try {
                    return $('#winOrder').window('options').modal;
                }catch(e){
                    return true
                }
            }(),
            isTopZindex: true,
            maximizable: false,
            minimizable: false,
            collapsible: false
        })
        .window('open');
     $('#winOrder').window('setModalable');
}
// 清屏
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridDailyConsume').datagrid('clear');
    InitDefVal();
    KillTmpGloal();
    COM_PID = "";
}
function Export(){
    PHAOP_COM.ExportGrid("gridDailyConsume");
}
// 打印
function Print(){
    var $grid = $("#gridDailyConsume");
    var rowNum = $grid.datagrid('getData').rows.length;
    if(rowNum == 0){
        PHAOP_COM._Alert("页面没有数据,无法打印!");
        return;
    }
    var stDateTime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
    var endDateTime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
    var dateTimeRange=stDateTime+" 至 "+endDateTime;
    var hospDesc = PHAOP_COM.LogonData.HospDesc;
    var footerData=$("#gridDailyConsume").datagrid('getFooterRows')
    var rpAmtTotal=footerData[0].rpAmt;
    var spAmtTotal=footerData[0].spAmt;

    var Para = {
        title: PHAOP_COM.LogonData.LocDesc + "日消耗",
        daterange: dateTimeRange,
        rpamtTotal:rpAmtTotal,
        spamtTotal:spAmtTotal
    }
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAOPDailyConsum',
        data: {
            Para: Para,
            Grid: {type:'hisui', grid:'gridDailyConsume'}
        },
        listBorder: {style:4, startX:1, endX:170},
        page: {rows:30, x:20, y:2, fontname:'黑体', fontbold:'true', fontsize:'12', format:'第{1}页/共{2}页'},
        aptListFields: ["label9", "spamtTotal"]
    });
    /* 打印日志 */
    OP_PRINTCOM.PrintLog("page",{
            Para: Para
        },{},{
            remarks: "日消耗",
            pointer: App_MenuCsp || ""
        }
    )
}
// 清除临时global
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("PreBatPrt.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}