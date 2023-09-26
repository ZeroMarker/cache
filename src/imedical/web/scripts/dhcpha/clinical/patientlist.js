var searchLocID=parent.drugSearchLocID;
var input="";
if(searchLocID==""){
	searchLocID=parent.userLocID;
	input=searchLocID+"^"+"";
}
else{
	input=""+"^"+searchLocID;
}

$(function(){
	tabPatientList();
	QueryPatList();
	//新增回车补全登记号方法
	$('#patientNo').bind('keypress', function(event) {
		if (event.keyCode == "13") {
			setPatientNoLength();
		}
	});

});

///绑定病人列表信息 dws 2016-12-12
function tabPatientList()
{
	$('#patientListData').datagrid({ 
    width:'100%',
    height:90, 
    pageSize:30,
    pageList:[30,60], 
    fitColumns: true,
    loadMsg:'数据装载中......',
    autoRowHeight: true,
    url:'dhcapp.broker.csp?ClassName=web.DHCCM.drugbrowse&MethodName=GetAdmList',	
    singleSelect:true,
    rownumbers:true,
    pagination:true,
    fit:true,
    columns:[[  
    	{field:'patward',title:'病区',width:120,align:'center'},
    	{field:'patbed',title:'床号',width:50,align:'center'},
    	{field:'patno',title:'登记号',width:80,align:'center',styler:function(){return 'color:blue'}},
    	{field:'patname',title:'姓名',width:80,align:'center'}, 
    	{field:'patsex',title:'性别',width:40,align:'center'},
    	{field:'patindate',title:'就诊日期',width:80,sortable:true,align:'center'},
    	{field:'patroom',title:'病房',width:80,sortable:true,align:'center'},
    	{field:'patdoctor',title:'主治医师',width:80,align:'center'},
    	{field:'patdiag',title:'诊断',width:150},
        {field:'PatientID',title:'PatientID',hidden: true,width:80},
        {field:'patadm',title:'EpisodeID',hidden: true,width:80}
    ]],
  	onDblClickRow: function() {
	  
	  var seleRow = $('#patientListData').datagrid('getSelected');
	  if (seleRow){
		  parent.doSwitch(seleRow.PatientID,seleRow.patadm,seleRow.patadm); 
	  }},
	  queryParams:{
			PapmiNo:$("#patientNo").val(),
			Input:input
			}
  	}); 
}

///查询绑定病人列表信息 dws 2016-12-12
function QueryPatList(){
	$("#PatientListQuery").click(function () {
    	$('#patientListData').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCCM.drugbrowse&MethodName=GetAdmList',
			queryParams:{
				PapmiNo:$("#patientNo").val(),
				Input:input
			}
		});
	});
}


///Desc:设置患者号长度
function setPatientNoLength(){
	var pateinetNo = $("#patientNo").val();
	if (pateinetNo != '') 
	{
		if (pateinetNo.length < PatientNoLength) 
		{
			for (var i=(PatientNoLength-pateinetNo.length-1); i>=0; i--)
			{
				pateinetNo ="0"+ pateinetNo;
			}
		}
	}
	$("#patientNo").val(pateinetNo);
}