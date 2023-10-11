var selRowIndex="";
$(function(){
	InitDiagnosList();
});
function InitDiagnosList()
{
	var Columns=[[ 
        { field: 'MRDIARowId', checkbox:true}, 
		{ field: 'MRCIDRowId', hidden:true},
		{ field: 'TCMTreatmentID', hidden:true},
		{ field: 'DiagnosCat', title: '����', width: 40},
		{ field: 'DiagnosType', title: '�������', width: 80},
		{ field: 'DiagnosLeavel', title: '����', width: 40},
		{ field: 'DiagnosPrefix', title: '���ǰ׺', width: 80},
		{ field: 'DiagnosICDDesc', title: '���', width: 200},
		{ field: 'DiagnosNotes', title: '���ע��', width: 80},
		{ field: 'SDSDesc', title: '�ṹ�����', width: 250},
		{ field: 'TCMTreatment', title: '��ҽ�η�', width: 150},
		{ field: 'MainDiagFlag', title: '�����', width: 60},
		{ field: 'MRCIDCode', title: 'ICD����', width: 80},
		{ field: 'DiagnosStatus', title: '���״̬', width: 75},
		{ field: 'DiagnosOnsetDate', title: '��������', width: 95},
		{ field: 'DiagnosDate', title: '�������', width: 95},
		{ field: 'DiagnosDoctor', title: 'ҽ��', width: 80}
	 ]];
	 $("#tabDiagnosList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'MRDIARowId',
		url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid&ClassName=web.DHCDocDiagnosEntryV8&QueryName=DiagnosList&MRADMID='+ServerObj.mradm,
		columns :Columns,
		/*loadFilter: function(data){
			//{"total":0,"rows":[]}
			var obj=new Object();
			obj.total=data['data'].length;
			obj.rows=data['data'];
			return obj;
		},*/
		onCheck:function(rowIndex, rowData){
			var MRDIARowId=rowData.MRDIARowId;
			if ((selRowIndex!=="")||(MRDIARowId.indexOf("||")<0)){
				return false;
			}
			var MRDIAMRDIADR=rowData.MRDIAMRDIADR;
	        var rows = $("#tabDiagnosList").datagrid('getRows');
			//��ѡ�����
			if (MRDIAMRDIADR==""){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myMRDIAMRDIADR=rows[idx].MRDIAMRDIADR;
					if (myMRDIAMRDIADR==MRDIARowId){
						selRowIndex=idx;
						$("#tabDiagnosList").datagrid('checkRow',idx);
					}
				}
			}else if (MRDIAMRDIADR.indexOf("||")>=0){ //��ѡ��ҽ�� ���ڿ��е����
				var MasterrowIndex=$("#tabDiagnosList").datagrid('getRowIndex',MRDIAMRDIADR);
				if (MasterrowIndex>=0){
					$("#tabDiagnosList").datagrid('checkRow',MasterrowIndex);
				}
			}
			selRowIndex="";
		},
		onUncheck:function(rowIndex, rowData){
			var MRDIARowId=rowData.MRDIARowId;
			if ((selRowIndex!=="")||(MRDIARowId.indexOf("||")<0)) return false;
			var MRDIAMRDIADR=rowData.MRDIAMRDIADR;
	        var rows = $("#tabDiagnosList").datagrid('getRows');
			//ȡ����ѡ�����
			if (MRDIAMRDIADR==""){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myMRDIAMRDIADR=rows[idx].MRDIAMRDIADR;
					if (myMRDIAMRDIADR==MRDIARowId){
						selRowIndex=idx;
						$("#tabDiagnosList").datagrid('uncheckRow',idx);
					}
				}
			}else if (MRDIAMRDIADR!=""){ //��ѡ�����
				var MasterrowIndex=$("#tabDiagnosList").datagrid('getRowIndex',MRDIAMRDIADR);
				if (MasterrowIndex>=0){
					$("#tabDiagnosList").datagrid('uncheckRow',MasterrowIndex);
				}
			}
			selRowIndex="";
		},
		onBeforeLoad:function(param){
			$("#tabDiagnosList").datagrid("uncheckAll");
		}
	});
}
//AddCopyItemToList
function getRefData(){
	var rtnObj= {data:"",toTitle:"",msg:"",success:true};
	var rows=$("#tabDiagnosList").datagrid("getChecked");
	if ((!rows)||(rows.length==0)) {
		$.extend(rtnObj, { msg: "δѡ����Ҫ������������!",success:false});
		return rtnObj;
	}
	var ids = [];
	for (var i=0;i<rows.length;i++) {
		var MRDIARowId=rows[i].MRDIARowId;
		var MRDIAMRDIADR=rows[i].MRDIAMRDIADR;
		if (MRDIAMRDIADR=="") {
			/*var GroupICDRowIDStr=$.cm({
				ClassName:"web.DHCDocDiagnosEntryV8",
				MethodName:"GetGroupICDRowIDStr",
				MRDiagnosRowid:MRDIARowId,
				dataType:"text"
			},false);
			if (GroupICDRowIDStr=="") continue;
			var DiagnosICDDesc=$.trim(rows[i].DiagnosICDDesc);
			var DiagnosNotes=$.trim(rows[i].DiagnosNotes);
			var DiagnosPrefix=$.trim(rows[i].DiagnosPrefix);
			var desc=DiagnosNotes;
			ids.push(GroupICDRowIDStr+String.fromCharCode(1)+desc+String.fromCharCode(1)+DiagnosPrefix);*/
			ids.push(MRDIARowId);
		}
	}
	var DataGridCopyData=ids.join("^"); //String.fromCharCode(2)
	$.extend(rtnObj, { data: DataGridCopyData,toTitle:$g("���¼��")});
	return rtnObj;
}