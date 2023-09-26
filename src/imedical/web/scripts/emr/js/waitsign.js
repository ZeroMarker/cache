$(function(){
	InitInPatientList();
});

//Desc:病人列表信息
function InitInPatientList()
{
	$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:20,
			pageList:[10,20,30,50,80,100], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.TemplateSign.cls?Action=GetPatientList&PatListType=InPat&RadioValue=' + defaultRadio + '&SignAction=Check',
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			sortName:"PAAdmBedNO",
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAPMINO',title:'登记号',width:85,sortable:true},
				{field:'PAPMIName',title:'姓名',width:65,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAAdmWard',title:'病区',width:150,sortable:true},
				{field:'PAAdmBedNO',title:'床号',width:60,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},			
				{field:'PAAdmDate',title:'就诊日期',width:80,sortable:true},
				{field:'PAAdmTime',title:'就诊时间',width:90,sortable:true},
				{field:'PAAdmDischgeDate',title:'出院日期',width:80,sortable:true},
				{field:'PAAdmDischgeTime',title:'出院时间',width:80,sortable:true},
				{field:'waitsign',title:'待签病历',width:70,sortable:true}
			]],
			view: detailview,
			detailFormatter: function(rowIndex, rowData){
				return '<div style="padding:2px"><table id="Sub-' + rowIndex + '"></table></div>';
			},
			onExpandRow: function(index,row){
				$('#Sub-'+index).datagrid({
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					url:'../EMRservice.Ajax.TemplateSign.cls?Action=GetRecord&InstanceIDs='+row.WaitSignInstance,
					rownumbers:true,
					singleSelect:false,
					idField:'instanceID',
					sortName:['recordName'],
					sortOrder:'desc',
					columns:[[  
						{field:'PatientID',title:'PatientID',width:80,hidden: true},
						{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
						{field:'instanceID',title:'instanceID',width:80,hidden: true},
						{field:'record',title:'电子病历',width:60,sortable:true},
						{field:'text',title:'病历名称',width:400,sortable:true},	
						{field:'happendate',title:'病历日期',width:80,sortable:true},
						{field:'happentime',title:'病历时间',width:90,sortable:true},
						{field:'status',title:'病历状态',width:80,sortable:true,formatter: StatusOperate}
					]],
					onResize:function(){
						$('#patientListData').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$('#patientListData').datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$('#patientListData').datagrid('fixDetailRowHeight',index);
			}
		});
 }

//查询按钮点击事件
$("#PatientListQuery").click(function () {
	GetData();
});

//查询数据
function GetData()
{
	var signAction =  $("input[name='SignAction']:checked").val();
	var searchType =  $("input[name='SearchType']:checked").val();
	var outStartDate = "";
	var outEndDate = "";
	var papmiNo = "";
	var PatListType = "InPat";
	var DateGap = "";
	if ($('#outthreedays').attr('checked') == "checked")
	{
		DateGap = $('#outthreedays').attr('value');
		PatListType = "OutPat";
	}
	else if ($('#outsevendays').attr('checked') == "checked")
	{
		DateGap = $('#outsevendays').attr('value');
		PatListType = "OutPat";
	}
	else if (searchType == "outdate")
	{
		var outStartDate = $('#startDate').datebox('getText');
		var outEndDate = $('#endDate').datebox('getText');
		PatListType = "OutPat";
	}
	else if(searchType == "papmiNo")
	{
		 papmiNo = $("#patientNo").val();
		 PatListType = "PapmiNo";
	}
	var radioValue = "";
	if($('#currentUser').attr('checked') == "checked")
	{
		radioValue = "currentUser";
	}
	else if($('#currentGroup').attr('checked') == "checked")
	{
		radioValue = "currentGroup";
	}
	else if($('#currentLoc').attr('checked') == "checked")
	{
		radioValue = "currentLoc";
	}
	$('#patientListData').datagrid('load', {
		SignAction: signAction,
		PatListType: PatListType,
   	 	OutStartDate: outStartDate,
   	 	OutEndDate: outEndDate,
   	 	PapmiNo: papmiNo,
    	RadioValue: radioValue,
    	DateGap:DateGap
	});
}

//签名状态设置
function StatusOperate(val,row,index)
{
	if((row.status == "完成")&&(row.isWaitsign != "1"))
	{
		var span = '<a>待签</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}

function changeType()
{
	$('#currentLoc').attr('checked',true);
}

document.getElementById("GroupSign").onclick = function(){
 	window.open("emr.record.group.sign.csp?DocID="+docID+ "&SignType=Doc", "GroupSign", "channelmode,scrollbars=yes,resizable=yes,status=no,center=yes,minimize=no,maximize=yes");	
};