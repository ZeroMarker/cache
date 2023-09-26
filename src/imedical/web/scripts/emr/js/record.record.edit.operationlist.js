$(function(){
	getData();	
});

///加载手术信息
function getData()
{
	$('#eventValues').datagrid({
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.eventData.cls?Action=GetData&EventType=Operation&EpisodeID='+episodeId, 
	    singleSelect:true,
	    toolbar:'#toolbar',
	    idField:'ID',
	    fitColumns:false,
	    rowStyler: function(index,row){
			if ((row.OperPAStatus == "拒绝")||(row.OperPAStatus == "撤销"))
			{
				return 'color:#CCCCCC;';
			}
		},
	    onClickRow: function(rowIndex, rowData){
		if ((rowData.OperPAStatus == "拒绝")||(rowData.OperPAStatus == "撤销")) {
	            $('#eventValues').datagrid('unselectRow', rowIndex);
	        }
	    },
	    columns:[[
		     {field:'ID',title:'ID',hidden:true},
		     {field:'OpaID',title:'OpaID',hidden:true},
		     {field:'OperID',title:'OperID',hidden:true},
		     {field:'OperDesc',title:'手术名称',width:100},
		     {field:'OperLevel',title:'手术级别',width:100},
		     {field:'OperDocID',title:'OperDocID',hidden:true},
		     {field:'OperDocName',title:'术者',width:100},
		     {field:'OperAssistFirstID',title:'OperAssistFirstID',hidden:true},
		     {field:'OperAssistFirstDesc',title:'一助',width:100},
		     {field:'OperAssistSecondID',title:'OperAssistSecondID',hidden:true},
		     {field:'OperAssistSecondDesc',title:'二助',width:100},
		     {field:'OperDate',title:'手术日期',width:100},
		     {field:'OperTime',title:'手术时间',width:100},
		     {field:'OperPAStatus',title:'手术状态',width:100}									     
		]]
	});	
}
$("#btnAdd").click(function(){
	var returnValues = window.showModalDialog("emr.record.library.navoperation.addoperation.csp?PatientID="+patientId+"&EpisodeID="+episodeId,"","dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
	if ((returnValues == "")||(returnValues == undefined)) return;
	var datetime = returnValues.OperDateTime.split(" ");
	$('#eventValues').datagrid('appendRow',{
		ID: returnValues.ID,
		OperDesc: 	returnValues.OperDesc,
		OperLevel:	returnValues.OperLevel,
		OperDocName: returnValues.OperDoc,
		OperAssistFirstDesc:returnValues.OperAssistFirst,
		OperAssistSecondDesc:returnValues.OperAssistSecond,
		OperDate:datetime[0],
		OperTime:datetime[1]
	})
});

$("#btnSure").click(function(){
	var data = $('#eventValues').datagrid('getSelected');
	if (data == null)
	{
		alert("请选择一条记录创建病历");
		return;
	}
	window.returnValue = data.ID + "^" + eventType;
	windowClose();
});

function windowClose()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}	  	
