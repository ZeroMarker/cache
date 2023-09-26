$(function(){
	InitCriticallyPatientList();
});
//Desc:病人列表信息
function InitCriticallyPatientList()
{
	if (HasPatEncryptLevel == "Y")
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=CriticallyPat', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'SecAlias',title:'病人密级',width:80,sortable:true},
				{field:'EmployeeFunction',title:'病人级别',width:80,sortable:true},
				{field:'PAAdmBedNO',title:'床号',width:40,sortable:true},
				{field:'PAPMINO',title:'登记号',width:60,sortable:true},  
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:30,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:30,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'CareClass',title:'护理级别',width:80,sortable:true},
				{field:'Vitalsigns',title:'生命体征',width:200}, 
				{field:'PAAdmDocCodeDR',title:'主管医师',width:50,sortable:true},
				{field:'HeadUniteDoc',title:'带组医师',width:50,sortable:true},
				{field:'ChiefDoc',title:'主任医师',width:50,sortable:true},
				{field:'Diagnosis',title:'诊断',width:80,sortable:true} 
			]],
			onDblClickRow: function() {
			var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
				doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			}
		}); 
	}
	else
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=CriticallyPat', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAAdmBedNO',title:'床号',width:40,sortable:true},
				{field:'PAPMINO',title:'登记号',width:60,sortable:true},  
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:30,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:30,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'CareClass',title:'护理级别',width:80,sortable:true},
				{field:'Vitalsigns',title:'生命体征',width:200}, 
				{field:'PAAdmDocCodeDR',title:'主管医师',width:50,sortable:true},
				{field:'HeadUniteDoc',title:'带组医师',width:50,sortable:true},
				{field:'ChiefDoc',title:'主任医师',width:50,sortable:true},
				{field:'Diagnosis',title:'诊断',width:80,sortable:true} 
			]],
			onDblClickRow: function() {
			var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
				doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			}
		}); 
	}
 }

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	parent.doSwitch(PatientID,EpisodeID,mradm);
}