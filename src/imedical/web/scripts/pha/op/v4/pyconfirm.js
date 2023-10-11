/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.09.02
 *  Description ������ҩȷ��
 */
var COMPOMENTS ={};
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    InitGridPrescDetail();  //  ������ϸ
    InitGridPyRanking();    //
    InitEvent();            //  ��ť�¼�
    ResizePanel();          //  ���ֵ���
    Clean();                //  ������ʼ����ѯ����
})
function InitEvent(){
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnPyConfirm',     'click', function () {PyConfirm();});
    //���Żس��¼�
    $('#prescNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            QueryPrescDetail();
            $("#prescNo").val("");
        }
    });
    $('#userCode').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var userCode = $.trim($("#userCode").val());
            if (userCode != "") {
                PyConfirm();
            }
        }
    });
}
// ���ֵ���
function ResizePanel(){
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��condition',
            region: 'west',
            width: 0.25
        });
    }, 0);
}
function InitGridPrescDetail(){
    var normalCol=[[
        {field:'patNo',             title: ("�ǼǺ�"),             width:100,      align:'left'},
        {field:'patName',           title: ("����"),          width:100,      align:'left'},
        {field:'phwDesc',           title: ("��ҩ����"),        width:100,      align:'left'},
        {field:'incDesc',           title: ("ҩƷ����"),        width:200,      align:'left'},
        {field:'qty',               title: ("����"),          width:120,      align:'left'},
        {field:'uomDesc',           title: ("��λ"),          width:100,      align:'left'},
        {field:'sp',                title: ("����"),          width:100,      align:'left'},
        {field:'spAmt',             title: ("���"),          width:120,      align:'left'},
        {field:'dosage',            title: ("����"),          width:100,      align:'left'},
        {field:'freqDesc',          title: ("Ƶ��"),          width:100,      align:'left'},
        {field:'instrucDesc',       title: ("�÷�"),          width:120,      align:'left'},
        {field:'duraDesc',          title: ("�Ƴ�"),          width:100,      align:'left'},
        {field:'oeoriStat',         title: ("ҽ��״̬"),        width:100,      align:'left'},
        {field:'docName',           title: ("ҽ��"),          width:120,      algin:'left',   hidden:true},
        {field:'encryptLevel',      title: ("�����ܼ�"),        width:120,      align:'left',   hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'patLevel',          title: ("���˼���"),        width:100,      align:'left',   hidden:PHAOP_COM.ColHidden.PatLevel}
    ]];
    COMPOMENTS.ComomGrid("gridPrescDetail",{
        columns: normalCol,
        toolbar:"#gridPrescDetailBar",
        onLoadSuccess:function(data){
            if(data.total>0){
                $('#prescNo').val("");
                $('#userCode').focus();
            }
        }
    })
}
function InitGridPyRanking(){
    var normalCol=[[
        {field:'ordNum',            title: ("����"),          width:100,      align:'left',
            formatter:function(value, rowData, index) {
                var rankNum = rowData.ordNum;
                var nocolor ="" ;
                if (rankNum == "1") {
                    nocolor = "#FF5152";
                } else if (rankNum == "2") {
                    nocolor = "#FD9563";
                } else if (rankNum == "3") {
                    nocolor = "#FFCE33";
                } else {
                    nocolor = "#7F7F7F";
                }
                if (rankNum != $g("δ������")){
                    rankNum = "NO."+rankNum;
                }
                return '<span style="color:' + nocolor + ';font-weight:bold">' +
                '<em>' + rankNum + '</em>' +
                '</span>��';
            }
        },
        {field:'name',              title: ("����"),          width:80,       align:'left'},
        {field:'count',             title: ("����"),          width:80,       align:'right',
            formatter:function(value, rowData, index) {
                var nobackgroudcolor = "#45D28E";
                return '<span class="badge" style="background-color:' + nobackgroudcolor + ';margin:2px;">' + rowData.count + '</span>'
            }
        },
        {field:'id',                title: ("�û�id"),        width:200,      align:'left',   hidden:true}
    ]];
    COMPOMENTS.ComomGrid("gridPyRanking",{
        pagination: false,
        rownumbers:false,
        showHeader: false,
        columns: normalCol,
        fitColumns:true,
        idField :"id",
        onLoadSuccess:function(){
            var index = $("#gridPyRanking").datagrid('getRowIndex',PHAOP_COM.LogonData.UserId);
            if(index>=0){
                var pyNum = $("#gridPyRanking").datagrid('getData').rows[index].count;
                $("#lbl-dispcount").text(pyNum)
            }
            var panel = $(this).datagrid('getPanel');
            var tr = panel.find('div.datagrid-body tr');
            tr.each(function () {
                var td = $(this).children('td');
                td.css({
                    "border-width": "0 0px 1px 0"
                });
                ;
            });
            var head = panel.find('div.datagrid-header');
            head.css({
                    "border-width": "0 0 0px",
                    //"border":"1px solid red"
                });
        }
    })
}

function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    if(PHAOP_COM.DEFAULT.phlId == ""){return false;}
    pJson.phlId = PHAOP_COM.DEFAULT.phlId;
    pJson.winIdStr = PHAOP_COM.DEFAULT.winIdStr;
    pJson.phPerId = PHAOP_COM.DEFAULT.phPerId;

    return pJson;
}
// ��ѯ�����б�
function QueryPrescList(){
    var $grid =  $("#gridPrescDetail");
    var pJson = GetParams();
    if(pJson==false){return;}

    
}

// ��ѯ������ϸ
function QueryPrescDetail(){        
    var $grid =  $("#gridPrescDetail");
    var pJson = {};
    var prescNo = $("#prescNo").val();
    if(prescNo == ""){
        PHAOP_COM._Msg('error', "������Ϊ��,���ʵ!");
        return false;
    }
    pJson.prescNo = prescNo
    PHA.CM({
            pClassName: 'PHA.OP.PyConfirm.Api',
            pMethodName: 'GetConfirmPYData',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(data){
            if(data.total<1){
                PHAOP_COM._Msg('error', "�ô��������ڻ�ô�����ȷ��,���ʵ!");
                return false;
            }
            $grid.datagrid('loadData', data);
        }
    ); 
}
// ����
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescDetail').datagrid('clear');
    QueryRankOfConfirm();
}

// ��ҩȷ��
function PyConfirm(){
    var $grid = $("#gridPrescDetail");
    var rowsData = $grid.datagrid('getRows');
    if (rowsData.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        $('#prescNo').focus();
        return false;
    }
    
    var userCode = $.trim($("#userCode").val());
    if (userCode == "") {
        PHAOP_COM._Alert("���Ų���Ϊ��!");
        $("#userCode").val("");
        $("#prescNo").val("");
        $('#userCode').focus();
        return false;
    }
    var firstRowData = rowsData[0]; //��ȡ��һ������
    var phdId = firstRowData.phdId;
    if ((phdId == "") || (phdId == undefined)) {
        PHAOP_COM._Alert("����ϵ����ʦ��֤�����Ƿ��������!");
        return false;
    }
    var pJson = {
        phdId : phdId,
        userCode:userCode,
        locId :PHAOP_COM.LogonData.LocId,
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.PyConfirm.Api',
        pMethodName: 'PYConfirm',
        pJson: JSON.stringify(pJson)
    },false); 
    if (retVal.code < 0){
        PHAOP_COM._Alert(retVal.msg);
        $("#userCode").val("");
        $("#prescNo").val("");
        $('#prescNo').focus();
        return false;
    }else{
        $('#gridPrescDetail').datagrid('clear');
        $('#userCode').val("");
        $('#prescNo').focus();
        PHAOP_COM._Msg("success","��ҩȷ�ϳɹ�");
    }
    QueryRankOfConfirm();
}
function QueryRankOfConfirm(){
    var $grid= $("#gridPyRanking");
    var pJson = {};
    pJson.locId = PHAOP_COM.LogonData.LocId;
    pJson.userId = PHAOP_COM.LogonData.UserId;
    pJson.pyUserCode = $("#userCode").val();
    PHA.CM({
            pClassName: 'PHA.OP.PyConfirm.Api',
            pMethodName: 'RankOfDispConfirm',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(data){
            $grid.datagrid('loadData', data);
        }
    );  
    $("#userCode").val("");
    $("#prescNo").val("");
}
