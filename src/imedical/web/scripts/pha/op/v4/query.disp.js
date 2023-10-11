/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.24
 *  Description ����ҩ��--��ҩ��ѯ
 *  JS          scripts/pha/op/v4/query.disp.js
 */
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
var COM_PID = "";
$(function () {
    var $lyBody = $('#layout-op��condition');
    $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-op-con-more-less').toggle();
        var tHeight = $('.pha-op-con-more-less').css('display') === 'none' ? 138 : 178;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });
    COMPOMENTS = OP_COMPOMENTS;
    InitGridPrescList();        //  �����б�
    InitGridPrescIncDetail();   //  ������ϸ--��ҩƷ
    InitGridPrescInclbDetail(); //  ������ϸ--������
    InitDict();                 //  
    InitEvent();                //  ��ť�¼�
    ResizePanel();              //  ���ֵ���    
    Clean();                    //  ������ʼ����ѯ����
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    //��� toolbar
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
    //���Żس��¼�
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            if (cardNo != "") {
                ReadCard();
            }
        }
    });
}
// ���ֵ���
function ResizePanel(){ 
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid',
            region: 'east',
            width: 0.2 
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid-presc',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
    // ҩƷ�������
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
     // ��ҩ�˴���
    PHA.ComboBox('fyPerId',{
        blurValidValue:true, 
        url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=1"
    });
     // ��ҩ�˴���
    PHA.ComboBox('pyPerId',{
        blurValidValue:true, 
        url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=2"
    });
    InitDispStat()
}
//��ʼ����ҩ״̬
function InitDispStat(){
    var data = [
        { RowId: 1, Description: $g("�ѷ�ҩ") },
        { RowId: 2, Description: $g("δ��ҩ") },
        { RowId: 3, Description: $g("δ��ҩȷ��") }, 
        { RowId: 4, Description: $g("����ҩδȷ��") }, 
        { RowId: 0, Description: $g("����ҩδ��ҩ") }
     ];
    PHA.ComboBox('dispState',{
        editable:false, 
        data: data,
        onSelect:function(data){
            QueryPrescList()
        }
    }); 
}
// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#dispState").combobox("setValue",1) ;
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridPrescList(){
    var frozenCol=[[
        {field:'pid',               title: ("���̺�"),         width:100,      align:'left',   hidden:true},
        {field:'docLocDesc',        title: ("��������"),        width:120,      align:'left'},
        {field:'admId',             title:"admId",              width:100,      align:'left',   hidden:true},
        {field:'patNo',             title: ("�ǼǺ�"),         width:90,       align:'left',
            formatter: function (value, rowData, index) {
                return '<a class="pha-op-grid-link">' + value + '</a>';
            }
        }, 
        {field:'patName',           title: ("����"),          width:100,      align:'left'},
        {field:'admReasonDesc',     title: ("�ѱ�"),          width:80,       align:'left'},
        {field:'prescNo',           title: ("������"),         width:120,      algin:'left'},
        {field:'fyWinDesc',         title: ("��ҩ����"),        width:80,       algin:'left'}
        
    ]];
    var normalCol = [[
        {field:'spAmt',             title: ("ҩ��"),          width:80,       align:'right'},
        {field:'prtDate',           title: ("�շ�����"),        width:90,       align:'left'}, 
        {field:'pyDate',            title: ("��ҩ����"),        width:90,       align:'left'}, 
        {field:'fyDate',            title: ("��ҩ����"),        width:90,       align:'left'}, 
        {field:'pyUserName',        title: ("��ҩ��"),         width:80,       align:'left'},
        {field:'fyUserName',        title: ("��ҩ��"),         width:80,       align:'left'},
        {field:'prtTime',           title: ("�շ�ʱ��"),        width:70,       align:'left'}, 
        {field:'pyTime',            title: ("��ҩʱ��"),        width:70,       align:'left'}, 
        {field:'fyTime',            title: ("��ҩʱ��"),        width:70,       align:'left'}, 
        {field:'oeoriDateTime',     title: ("ҽ��ʱ��"),        width:90,       align:'left'},
        {field:'prescRemark',       title: ("������ע"),        width:80,       align:'left'},
        {field:'diagDesc',          title: ("���"),          width:200,      align:'left'},
        {field:'rpAmt',             title: ("���۽��"),        width:100,      align:'right',  hidden:true},
        {field:'encryptLevel',      title: ("�����ܼ�"),        width:80,       align:'left',   hidden: PHAOP_COM.ColHidden.PatLevel},
        {field:'patLevel',          title: ("���˼���"),        width:80,       align:'left',   hidden: PHAOP_COM.ColHidden.PatLevel},
        {field:'phdId',             title: ("��ҩ��Id"),       width:80,       align:'left',   hidden:true},
        {field:'phdOweId',          title: ("Ƿҩָ��Id"),  width:80,       align:'left',   hidden:true}
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
        {field:'incDesc',           title: ("ҩƷ����"),        width:200,      align:'left'}, 
        {field:'dspQty',            title: ("ҽ������"),        width:60,       align:'right'},   
        {field:'qty',               title: ("ʵ������"),        width:60,       align:'right'},
        {field:'uomDesc',           title: ("��λ"),          width:80,       align:'left'},
        {field:'spAmt',             title: ("���"),          width:80,       align:'right'},
        {field:'oeoriStatDesc',     title: ("״̬"),          width:60,       align:'left'},
        {field:'dosage',            title: ("����"),          width:70,       align:'left'},
        {field:'freqDesc',          title: ("Ƶ��"),          width:70,       align:'left'},
        {field:'instrucDesc',       title: ("�÷�"),          width:70,       align:'left'},
        {field:'duraDesc',          title: ("�Ƴ�"),          width:70,       align:'left'},
        //{field:'docName',             title: ("ҽʦ"),          width:70,       align:'left'    ,hidden:true},
        {field:'stkBinStr',         title: ("��λ"),          width:100,      align:'left'},
        {field:'retQty',            title: ("��ҩ"),          width:70,       align:'left'},
        {field:'oeoriRemark',       title: ("ҽ����ע"),        width:100,      align:'left'},
        {field:'cInsuCode',         title: ("����ҽ������"),  width:120,      align:'left'},
        {field:'cInsuDesc',         title: ("����ҽ������"),  width:120,      align:'left'}
    ]];
    COMPOMENTS.ComomGrid("gridPrescIncDetail",{
        columns: normalCol
    })
}
function InitGridPrescInclbDetail(){
    var normalCol = [[      
        {field:'incDesc',           title: ("ҩƷ����"),        width:200,      align:'left'}, 
        {field:'qty',               title: ("ʵ������"),        width:60,       align:'right'},
        {field:'uomDesc',           title: ("��λ"),          width:80,       align:'left'},
        {field:'sp',                title: ("�ۼ�"),          width:80,       align:'right'},
        {field:'spAmt',             title: ("�ۼ۽��"),        width:80,       align:'right'},
        {field:'batNo',             title: ("����"),          width:60,       align:'left'},
        {field:'expDate',           title: ("��Ч��"),             width:70,       align:'left'},
        {field:'retQty',            title: ("��ҩ"),          width:70,       align:'left'},
        {field:'inclb',             title: ("����id"),            width:100,      align:'left'    ,hidden:true},
        {field:'cInsuCode',         title: ("����ҽ������"),  width:120,      align:'left'},
        {field:'cInsuDesc',         title: ("����ҽ������"),  width:120,      align:'left'}
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
// ��ѯ�����б�
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
            title:"��ҩ�����б�"
        });
    }else{
        $("#divInclbDetail").hide();
        $("#divIncDetail").show();
        $("#divDetail").panel({
            title:"ҩƷ�б�"
        });
    }
    QueryPrescDetail();
}
// ��ѯ������ϸ
// ��ѯ������ϸ
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
        PHAOP_COM._Msg('error', "��ѡ�񴦷����ݣ�");
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
        PHAOP_COM._Msg('error', "��ѡ�񴦷����ݣ�");
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
// ����
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescIncDetail').datagrid('clear');
    $('#gridPrescInclbDetail').datagrid('clear');
    $('#prescTimeLine').children().remove();
    InitDefVal();
    KillTmpGloal();
}

// ��ӡ
function Export(){

}
// ����
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
// �����ʱglobal
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("DispQuery.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}

