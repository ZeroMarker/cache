$(function(){
	//就诊类型
	$('#episodeType').combobox({  
		valueField:'id',  
		textField:'text',
		panelHeight:100,
		//width:60,
		data:[
				{"id":"","text":"全部"},
				{"id":"O","text":"门诊"},
				{"id":"E","text":"急诊"},
				{"id":"I","text":"住院"}
			 ],
	    onLoadSuccess:function()
	    {
		    //设置默认就诊类型
		    $('#episodeType').combobox('setValue', patientEpisodeType);
	    }
	}); 	
	//就诊列表
	$("#episodeList").datagrid({ 
	    width:'100%',
	    height:'100%', 
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientID+'&EpisodeType='+$('#episodeType').combobox('getValue'),
	    singleSelect:false,
	    rownumbers:true,
	    pagination:true,
	    pageSize:20,	    
	    idField:'EpisodeID',
	    fit:true,
	    columns:[[  
	    	{field:'ck',checkbox:true},
	        {field:'EpisodeDate',title:'就诊日期',width:65},
			{field:'DischargeDate',title:'出院日期',width:65},
	        {field:'EpisodeType',title:'类型',width:35,formatter:formatColor}, 
	        {field:'EpisodeDeptDesc',title:'科室',width:100},   
	        {field:'MainDocName',title:'主治医生',width:65}, 
	        {field:'Diagnosis',title:'诊断',width:100}, 
			{field:'MedicareNo',title:'病案号',width:50},
	        {field:'EpisodeID',title:'就诊号',width:40,hidden:true},
	        {field:'EpisodeDeptID',title:'科室ID',width:30,hidden:true}
	    ]],
	    onDblClickRow:function(rowIndex,rowData){
		   $("#episodeList").datagrid('unselectAll');
		   $("#episodeList").datagrid('selectRow',rowIndex);
		   LoadBrowsePage(patientID,rowData.EpisodeID,rowData.EpisodeType,rowData.EpisodeDeptID); 
	    }
		//默认选中当前就诊记录，打开相应的病历浏览  add by niucaicai 2016-8-19
		,onLoadSuccess: function(data) {
			var rowsLength = data.rows.length;
			for (i=0;i<rowsLength;i++)
			{
				if (data.rows[i].EpisodeID == episodeID)
				{
					$("#episodeList").datagrid('selectRow',i);
					LoadBrowsePage(patientID,data.rows[i].EpisodeID,data.rows[i].EpisodeType,data.rows[i].EpisodeDeptID);
					break;
				}
			}
		}
  });	
	$("#episodeSeek").click(function(){
		queryData();
	});
	
	var pager = $('#episodeList').datagrid('getPager'); 
	pager.pagination({
		showPageList:false
	});

	$("#authorizesrequest").click(function(){
		var SelectedRow = $("#episodeList").datagrid('getSelected');
		if (SelectedRow == null)
		{
			alert("请选择一条就诊记录，再申请权限！")
			return;
		}
		else
		{
			//var returnValues = window.open("emr.authorizes.request.csp?EpisodeID="+SelectedRow.EpisodeID+"&PatientID="+patientID,"requestWin","resizable:no;status:no,width=700,height=470");
			//var returnValues = window.open("emr.authappoint.request.csp?EpisodeID="+SelectedRow.EpisodeID+"&PatientID="+patientID,"requestWin","width=1200,height=650");
			var iWidth = 1200;
			var iHeight = 600;
			var iTop = (window.screen.height-30-iHeight)/2;
			var iLeft = (window.screen.width-10-iWidth)/2;
			window.open("emr.authappoint.request.csp?EpisodeID="+SelectedRow.EpisodeID+"&PatientID="+patientID,"requestWin",'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no'); 
		}
		
	});

});

function formatColor(val,row)
{
	if (row.EpisodeType == "住院")
	{
		return '<span style="color:green;">'+val+'</span>';
	}
	else if (row.EpisodeType == "门诊")
	{
		return '<span style="color:red;">'+val+'</span>';
	}
	else if (row.EpisodeType == "急诊")
	{
		return '<span style="color:blue;">'+val+'</span>';
	}	
}

//加载病历浏览页面
function LoadBrowsePage(patientID,episodeID,episodeType,episodeLocID)
{
	var admType = "";
	if (episodeType == "急诊")
	{
		admType = "E";
	}
	else if (episodeType == "门诊")
	{
		admType = "O";
	}
	else
	{
		admType = "I";
	}
	var url = "emr.record.browse.browseform.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&AdmType="+admType;
	$('#frameBrowsepage').attr("src",url);
}

//查询就诊列表
function queryData()
{
	var queryItem = document.getElementById("diagnosDesc").value;
	var startDate = $('#startDate').datebox('getText');
	var endDate = $('#endDate').datebox('getText');
	//alert(startDate);
	//alert(endDate);
	$("#episodeList").datagrid('load', {
		Action: "GetEpisodeList",
		PatientID: patientID,
		QueryItem: (queryItem == "请输入诊断内容")? "":queryItem,
		EpisodeType: $('#episodeType').combobox('getValue'),
		StartDate: startDate,
		EndDate: endDate
	});	
}
//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
