/*
*Creator    zhaozhiduan
*CreatDate  2021-01-27
*Descrption ���ﴦ��״̬��ѯ
*/

var hisPatNoLen;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    GetPhaHisCommonParmas();
    InitDict();
    InitGridPrescStatus();
    $("#btnFind").on("click", QueryPrescStatus);
    $("#btnClean").on("click", CleanConditions);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#conPatNo").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, hisPatNoLen);
                $(this).val(newpatno);
                if(newpatno==""){return;}
                QueryPrescStatus();
            }
        }
    });
})
function InitDict(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    
}

function InitGridPrescStatus(){
    var columns = [[{
                field: 'admId',
                title: 'admId',
                width: 100,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '���տ���',
                width: 100
            },
            {
                field: 'winDesc',
                title: '����',
                width: 100
            },
            {
                field: 'billFlag',
                title: '�շ�״̬',
                width: 100
            },
            {
                field: 'prescAudited',
                title: '��˽��',
                width: 100
            },
            {
                field: 'pyFlag',
                title: '��ҩ״̬',
                width: 80
            },
            {
                field: 'fyFlag',
                title: '��ҩ״̬',
                width: 80
            },
            {
                field: 'repInfo',
                title: '��ҩ�豨��',
                width: 100
            },
            {
                field: 'baseMedLocDesc',
                title: '����ҩ����',
                width: 100
            },
            {
                field: 'specialLocDesc',
                title: '���ۿ���',
                width: 100
            },
            {
                field: 'ipDispFlag',
                title: '��ҩ��ʽ',
                width: 100
            },
            {
                field: 'cesFlag',
                title: 'Ӧ���ָ���־',
                width: 100
            },
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 150,
                hidden:true
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 200
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 80
            },
            {
                field: 'detailDispStatus',
                title: '��ϸ��ҩ״̬',
                width: 60
            },
            {
                field: 'oeStatus',
                title: 'ҽ��״̬',
                width: 80
            },
            {
                field: 'skinDesc',
                title: 'Ƥ��״̬',
                width: 80
            },
            {
               field: 'priDesc',
                title: 'ҽ������',
                width: 100
            },
            {
                field: 'dosage',
                title: '����',
                width: 80
            },
            {
                field: 'instDesc',
                title: '�÷�',
                width: 100
            },
            {
                field: 'stkQtyFlag',
                title: '������',
                width: 100
            },
            {
                field: 'reqFlagDesc',
                title: '�˷�����',
                width: 100
            },{
                field: 'ordItmId',
                title: 'ҽ��id',
                width: 100
            },{
                field: 'retQty',
                title: '��ҩ����',
                width: 100
            }
           
        
    ]];
   var frozenColumns=[[
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'prescNo',
                title: '������',
                width: 140
            }
        ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Query.PrescStatus',
            QueryName: 'QueryPrescStatus',
            pJsonStr:  JSON.stringify({ locId: PHA_COM.Session.CTLOCID }),
            rows: 999
        },
        pagination: true,
        columns: columns,
        frozenColumns:frozenColumns,
        fitColumns: false,
        titleNoWrap:false,/*��ͷ�Զ�����*/
        exportXls: false,
        rownumbers: true,
        toolbar: '#gridPrescStatusBar'
    };
    PHA.Grid('gridPrescStatus', dataGridOption);
}
function QueryPrescStatus(){
    var startDate =  $("#conPhStDate").datebox("getValue")|| ""; 
    var endDate = $("#conPhEndDate").datebox("getValue") || ""; 
    var patNo=$("#conPatNo").val() || ""; 
    var prescNo=$("#conPrescNo").val() || "";
    var pJson = {};
    pJson.locId = PHA_COM.Session.CTLOCID ; 
    pJson.startDate = startDate;    
    pJson.endDate = endDate;    
    pJson.patNo = patNo;    
    pJson.prescNo = prescNo;    
    $("#gridPrescStatus").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  

}
function CleanConditions(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#conPatNo").val('')
    $("#conPrescNo").val('')
    $('#gridPrescStatus').datagrid('clear');
}