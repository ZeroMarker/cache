$(function(){
	InitOperationPatientList();
});
//Desc:病人列表信息
function InitOperationPatientList()
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
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=OperationPat&DateGap=2', 
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
				{field:'opdatestr',title:'手术日期',width:130,sortable:true},
				{field:'PAAdmBedNO',title:'床号',width:50,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},  
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'opdes',title:'手术名称',width:260,sortable:true}, 
				{field:'OPCategory',title:'手术级别',width:60,sortable:true},
				{field:'PreOPConferURL',title:'术前讨论',width:80},
				{field:'OPRecordURL',title:'手术记录',width:60},
				{field:'AfterOPFirstURL',title:'术后首程',width:90}
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
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=OperationPat&DateGap=2', 
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
				{field:'opdatestr',title:'手术日期',width:130,sortable:true},
				{field:'PAAdmBedNO',title:'床号',width:50,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},  
				{field:'PAPMIName',title:'姓名',width:50,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'opdes',title:'手术名称',width:260,sortable:true}, 
				{field:'OPCategory',title:'手术级别',width:60,sortable:true},
				{field:'PreOPConferURL',title:'术前讨论',width:80},
				{field:'OPRecordURL',title:'手术记录',width:60},
				{field:'AfterOPFirstURL',title:'术后首程',width:90}
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

//查询按钮点击事件
/*
$("#PatientListQuery").click(function () {
    var startDate = $('#startDate').datebox('getText');
	var endDate = $('#endDate').datebox('getText');
	$('#patientListData').datagrid('load', {
    	StartDate: startDate,
    	EndDate: endDate	
	}); 
});
*/

//切换按钮
function radioCheck()
{
	GetData();
}

//查询数据
function GetData()
{
	if ($('#DateGap1Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap1Radio').attr('value');
	}
	else if ($('#DateGap3Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap3Radio').attr('value');
	}
	else if ($('#DateGap7Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap7Radio').attr('value');
	}
	else if ($('#DateGap30Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap30Radio').attr('value');
	}
	else if ($('#DateGap60Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap60Radio').attr('value');
	}
	else if ($('#DateGap90Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap90Radio').attr('value');
	}
	$('#patientListData').datagrid('load', {
    	DateGap: DateGap	
	});
}

 //浏览相应的病历
function BrowserRecord(id,pluginType,chartItemType,emrDocId)
{
	//alert(id);
	//alert(pluginType);
	//alert(chartItemType);
	//alert(emrDocId);
	window.open("emr.record.browse.browsform.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId,"");
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	parent.doSwitch(PatientID,EpisodeID,mradm);
}