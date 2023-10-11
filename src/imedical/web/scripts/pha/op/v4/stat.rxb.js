/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.09.06
 *  Description ����ҩ��--������ͳ��
 *  JS          scripts/pha/op/v4/stat.rxb.js
 */
var COMPOMENTS ={};
var COM_PID = "" ;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    COMPOMENTS = OP_COMPOMENTS;
    InitGridDailyConsume(); //  �����б�
    InitGridOrder();
    InitDict();
    InitEvent();            //  ��ť�¼�
    Clean();                //  ������ʼ����ѯ����
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryDailyConsume();});
    //��� toolbar
    PHA_EVENT.Bind('#btnPrint',         'click', function () {Print();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnExport',        'click', function () {Export();});
}
function InitDict(){
    // ҩƷ�������
    PHA_UX.ComboBox.INCItm('inci', {
        qParams: {
            pJsonStr: {
                stkType: App_StkType,
                scgId: "",
                locId: PHAOP_COM.LogonData.LocId
            }
        }
    });
    /* // ��ҩ��
    PHA.ComboBox('fyPerId',{
        blurValidValue:true, 
        //url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=1",
        url: PHA_STORE.SSUser(PHAOP_COM.LogonData.LocId,"").url

    });*/
     // ��ҩ��
     PHA.ComboBox('fyUserId',{
        blurValidValue:true, 
        url: PHA_STORE.SSUser(PHAOP_COM.LogonData.LocId,"").url
    });
     // ������
    PHA.ComboBox('incCatId',{
        blurValidValue:true, 
        url: PHA_STORE.INCStkCat().url
    });
     // ������
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
// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridDailyConsume(){
    var normalCol = [[
        {field: 'incCode',          title: ("ҩƷ����"),            width: 120,         align: 'left'},
        {field: 'incDesc',          title: ("ҩƷ����"),            width: 250,         align: 'left',
            formatter: function (value, rowData, index) {
                if((rowData.incCode == $g("�ϼ�"))||(rowData.incCode == undefined)){           
                    return value
                }else{
                    return '<a class="pha-op-grid-link incDesc">' + value + '</a>';
                }
            }
        },
        {field: 'qty',              title: ("��������"),            width: 100,         align: 'right',         sortable: true},
        {field: 'uomDesc',          title: ("��λ"),                width: 100,         align: 'left'},
        {field: 'sp',               title: ("�ۼ�"),                width: 75,          align: 'right',         sortable: true},
        {field: 'spAmt',            title: ("�������"),            width: 100,         align: 'right',         sortable: true},
        {field: 'rp',               title: ("����"),                width: 75,          align: 'right',         sortable: true},
        {field: 'rpAmt',            title: ("���۽��"),            width: 100,         align: 'right',         sortable: true},
        {field: 'manfDesc',         title: ("������ҵ"),            width: 200,         align: 'left'},
        {field: 'pid',              title: ("���̺�"),              width: 200,         align: 'left',          hidden: true},  
        {field: 'incId',            title: ("ҩƷid"),              width: 200,         align: 'left',          hidden: true},  
        {field: 'detail',           title: ("��ϸ"),                width: 100,         align: 'left',
             formatter: function (value, rowData, index) {
                if((rowData.incCode == $g("�ϼ�"))||(rowData.incCode == undefined)){           
                    return ""
                }else{
                    return '<a class="pha-op-grid-link detail">' + $g("������ϸ")+">>" + '</a>';
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
                title: '��������'
            },
            {
                field: 'locDesc',
                title: '��ҩ����'
            },
            {
                field: 'bedNo',
                title: '����'
            },
            {
                field: 'patNo',
                title: '�ǼǺ�'
            },
            {
                field: 'patName',
                title: '����'
            },
            {
                field: 'dosage',
                title: '����'
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��'
            },
            {
                field: 'instrucDesc',
                title: '�÷�'
            },
            {
                field: 'busiType',
                title: '����',                
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
                    if (value === 'HC') return $g("������ҩ")
                    return value === 'P' || value === 'F' ? $g('��ҩ') : $g('��ҩ');
                }
            },
            {
                field: 'qtyUom',
                title: '����'
            },
            {
                field: 'spAmt',
                title: '���',
                align: 'right'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
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
                title: '������',
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
                title: '����ʱ��',
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '��ʿ����ҽ����Ϣ',
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '��ҩ�����Ϣ'
            },
            {
                field: 'phaInfo',
                title: '������ҩ��Ϣ'
            },
            {
                field: 'phaNo',
                title: 'ҵ�񵥺�'
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
// ��ѯ��ҩ����
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
// ����
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
// ��ӡ
function Print(){
    var $grid = $("#gridDailyConsume");
    var rowNum = $grid.datagrid('getData').rows.length;
    if(rowNum == 0){
        PHAOP_COM._Alert("ҳ��û������,�޷���ӡ!");
        return;
    }
    var stDateTime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
    var endDateTime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
    var dateTimeRange=stDateTime+" �� "+endDateTime;
    var hospDesc = PHAOP_COM.LogonData.HospDesc;
    var footerData=$("#gridDailyConsume").datagrid('getFooterRows')
    var rpAmtTotal=footerData[0].rpAmt;
    var spAmtTotal=footerData[0].spAmt;

    var Para = {
        title: PHAOP_COM.LogonData.LocDesc + "������",
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
        page: {rows:30, x:20, y:2, fontname:'����', fontbold:'true', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'},
        aptListFields: ["label9", "spamtTotal"]
    });
    /* ��ӡ��־ */
    OP_PRINTCOM.PrintLog("page",{
            Para: Para
        },{},{
            remarks: "������",
            pointer: App_MenuCsp || ""
        }
    )
}
// �����ʱglobal
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("PreBatPrt.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}