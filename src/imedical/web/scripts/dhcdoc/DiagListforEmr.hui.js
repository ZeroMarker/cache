var selRowIndex="";
$(function(){
	InitDiagnosList();
});
function InitDiagnosList()
{
	var Columns=[[ 
        { field: 'MRDIARowId', checkbox:true}, 
		{ field: 'MRCIDRowId', title:'', hidden:true},
		{ field: 'DiagnosCat', title: '分类', width: 40},
		{ field: 'DiagnosType', title: '诊断类型', width: 80},
		{ field: 'DiagnosLeavel', title: '级别', width: 40},
		{ field: 'DiagnosPrefix', title: '诊断前缀', width: 80},
		{ field: 'DiagnosICDDesc', title: '诊断', width: 150},
		{ field: 'MainDiagFlag', title: '主诊断', width: 60},
		{ field: 'DiagnosNotes', title: '诊断注释', width: 80},
		{ field: 'MRCIDCode', title: 'ICD代码', width: 80},
		{ field: 'DiagnosStatus', title: '诊断状态', width: 75},
		{ field: 'DiagnosOnsetDate', title: '发病日期', width: 95},
		{ field: 'DiagnosDate', title: '诊断日期', width: 95},
		{ field: 'DiagnosDoctor', title: '医生', width: 80}
	 ]];
	 var QueStateQryTabDataGrid=$("#tabDiagnosList").datagrid({
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
		url:'oeorder.oplistcustom.new.request.csp?action=GetDiagList&USERID='+session['LOGON.USERID']+"&MRADM="+ServerObj.mradm,
		columns :Columns,
		loadFilter: function(data){
			//{"total":0,"rows":[]}
			var obj=new Object();
			obj.total=data['data'].length;
			obj.rows=data['data'];
			return obj;
		},
		onCheck:function(rowIndex, rowData){
			var MRDIARowId=rowData.MRDIARowId;
			if ((selRowIndex!=="")||(MRDIARowId.indexOf("||")<0)){
				return false;
			}
			var MRDIAMRDIADR=rowData.MRDIAMRDIADR;
	        var rows = $("#tabDiagnosList").datagrid('getRows');
			//勾选主诊断
			if (MRDIAMRDIADR==""){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myMRDIAMRDIADR=rows[idx].MRDIAMRDIADR;
					if (myMRDIAMRDIADR==MRDIARowId){
						selRowIndex=idx;
						$("#tabDiagnosList").datagrid('checkRow',idx);
					}
				}
			}else if (MRDIAMRDIADR.indexOf("||")>=0){ //勾选子医嘱 存在空行的情况
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
			//取消勾选主诊断
			if (MRDIAMRDIADR==""){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myMRDIAMRDIADR=rows[idx].MRDIAMRDIADR;
					if (myMRDIAMRDIADR==MRDIARowId){
						selRowIndex=idx;
						$("#tabDiagnosList").datagrid('uncheckRow',idx);
					}
				}
			}else if (MRDIAMRDIADR!=""){ //勾选子诊断
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
		$.extend(rtnObj, { msg: "未选择需要操作的行数据!",success:false});
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
	$.extend(rtnObj, { data: DataGridCopyData,toTitle:$g("诊断录入")});
	return rtnObj;
}