/**
*   author:     zhaoxinlong 
*   creatDate:  2022-03-02
*   descrption: ��ҩǰ�˷�ҽ����ѯ
*/

var hisPatNoLen;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    GetPhaHisCommonParmas();
    InitDict();
    InitGrid();
    $("#btnFind").on("click", Query);
    $("#btnExport").on("click", Export);
    $("#btnClean").on("click", CleanConditions);
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
})
function InitDict(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    
}

function InitGrid(){
    var columns = [[{
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
            },{
                field: 'recLocDesc',
                title: '���տ���',
                width: 150
            },{
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 150
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 300
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 100
            },
            {
                field: 'oeFlag',
                title: 'ҽ��״̬',
                width: 80
            },
            {
               field: 'priDesc',
                title: '���ȼ�',
                width: 100
            },
            {
                field: 'doseQty',
                title: '����',
                width: 100
            },
            {
                field: 'instDesc',
                title: '�÷�',
                width: 100
            }
           
        
    ]];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Query.RefBeforeDisp',
            QueryName: 'Query',
            pJsonStr:  JSON.stringify({ locId: PHA_COM.Session.CTLOCID }),
            rows: 999
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        titleNoWrap:false,/*��ͷ�Զ�����*/
        exportXls: false,
        rownumbers: true,
        toolbar: '#gridBar'
    };
    PHA.Grid('grid', dataGridOption);
}
function Query(){
    var startDate =  $("#conPhStDate").datebox("getValue")|| ""; 
    var endDate = $("#conPhEndDate").datebox("getValue") || ""; 
    var patNo=$("#conPatNo").val() || ""; 
    var pJson = {};
    pJson.locId = PHA_COM.Session.CTLOCID ; 
    pJson.startDate = startDate;    
    pJson.endDate = endDate;    
    pJson.patNo = patNo;    
    $("#grid").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  

}
function Export()
{
    if ($("#grid").datagrid("getData").rows.length == 0){
        PHA.Popover({
            msg: 'û������,���ܵ���!',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHA_COM.ExportGrid("grid")
    //PHA_COM.PrintGrid("grid")
    }
function CleanConditions(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#conPatNo").val('')
    $('#grid').datagrid('clear');
}