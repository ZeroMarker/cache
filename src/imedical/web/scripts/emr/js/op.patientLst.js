///门诊患者列表
function GetPatientList() {

    $('#patientLst').datagrid({
        width: '100%',
        height: '100%',
        pageSize: 30,
        pageList: [30, 40, 50],
        fitColumns: true,
        border: true,
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=OPatient',
        singleSelect: true,
        idField: 'EpisodeID',
        rownumbers: true,
        pagination: false,
        fit: true,
        columns: [
            [{
                field: 'PatientID',
                title: 'PatientID',
                hidden: true
            }, {
                field: 'EpisodeID',
                title: 'EpisodeID',
                hidden: true
            }, {
                field: 'mradm',
                title: 'mradm',
                hidden: true
            }, {
                field: 'PAPMINO',
                title: '登记号',
                width: 80
            }, {
                field: 'PAPMIName',
                title: '姓名',
                width: 80
            }, {
                field: 'PAPMISex',
                title: '性别',
                width: 40
            }, {
                field: 'PAPMIDOB',
                title: '出生年月',
                width: 40
            }, {
                field: 'PAAdmReason',
                title: '付费方式'
            }]
        ],
        onDblClickRow: function(index, row) {
            if (row){
                switchPatient(row.PatientID, row.EpisodeID, row.mradm); 
            }
        }        
    });    
}   
    
$(function() {    
    GetPatientList();
});   