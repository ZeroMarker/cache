$(function(){
	//就诊类型
	$('#episodeType').combobox({  
		valueField:'id',  
		textField:'text',
		panelHeight:100,
		width:60,
		data:[
				{"id":"I","text":"住院"},
				{"id":"O","text":"门诊"},
				{"id":"E","text":"急诊"}
			 ],
		onSelect: function(){
			queryData();
		},
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
	    singleSelect:true,
	    rownumbers:true,
	    pagination:true,
	    pageSize:20,	    
	    idField:'EpisodeID',
	    fit:true,
	    columns:[[  
			{field:'AdmSequence',title:'住院次序',width:60},
	        {field:'EpisodeDate',title:'就诊日期',width:80},
	        {field:'Diagnosis',title:'诊断',width:100}, 
	        {field:'EpisodeType',title:'类型',width:60,formatter:formatColor}, 
	        {field:'EpisodeDeptDesc',title:'科室',width:100},    
	        {field:'MainDocName',title:'主治医生',width:80}, 
	        {field:'DischargeDate',title:'出院日期',width:60},
	        {field:'EpisodeID',title:'就诊号',width:40}
	    ]],
	    onDblClickRow:function(rowIndex,rowData){
		    var tab = $('#centerTab').tabs('getSelected');
		    if (tab.id != "recordList") $('#centerTab').tabs('select','病历列表');
			setRecordList(rowData.EpisodeID);
	    }
	});
  	
	$("#episodeSeek").click(function(){
		queryData();
	});
	
	var pager = $('#episodeList').datagrid('getPager'); 
	pager.pagination({
		showPageList:false
	});
	
	
	$('#recordList').treegrid({  
	 loadMsg:'数据装载中......',                           
	 fit:true,                                 
	 nowrap: true,                 
	 rownumbers: true,                 
	 collapsible:true, 
	 singleSelect:true,         
	 url:'../EMRservice.Ajax.quotation.cls?Action=GetRecordList',                 
	 idField:'id',                 
	 treeField:'text',                                                  
	 columns:[[   
	     {field:'id',title:'id',hidden:true},                    
		 {field:'text',title:'病历名称',width:200},
		 {field:'summary',title:'备注',width:200},                  
		 {field:'happendate',title:'发生日期',width:150},                     
		 {field:'happentime',title:'发生时间',width:150},
		 {field:'creator',title:'创建者',width:150}                 
	 ]],
	 onDblClickRow:function(rowIndex,rowData){   
	 	$('#centerTab').tabs('select','病历浏览');
	 }            
	}); 
		
	//病历浏览
	$("#btBrowse").click(function(){ 
		$('#centerTab').tabs('select','病历浏览');
	});
	
	//引用
	$("#btQuotation").click(function(){
		var selectNode = $('#recordList').treegrid('getSelected');
		if ((selectNode)&&(selectNode != ""))
		{ 
			var text= "病历模板可能有问题，是否继续引用？"
			var id = selectNode.id.replace("_","||");
			if((quatationCheckFlag=="1")&&(!quatationCheck(id))){
				$.messager.confirm('Confirm',text,function(r){
    			if (r){
	    			window.returnValue = id;
					windowClose();
    			}	
				})
			
			}else{
				window.returnValue = id;
				windowClose();
			}
		}
		else
		{
			alert("请选择要引用的病历");
		}
			
	});
	
	//选择tab页签
	$('#centerTab').tabs({
	  onSelect: function(title,index){
		  if (title == "病历浏览")
		  {
		  	  browseRecords();
		  }
	  }
	});
	
	//目录点击事件
	$(".navcategory li a").live('click',function(){
		loadRecords(this);
	});
	
});

//加载引用病历列表
function setRecordList(episodeId)
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.quotation.cls?Action=GetRecordList",
		async : true,
		data : {"EpisodeID":episodeId,"CTLocID":userLocID,"DocID":docID},
		success : function(d) {
			if (d != "")
			{
				$('#recordList').treegrid('loadData',eval(d));
			}
		},
		error : function(d) {
			alert("error");
		}
	});
}

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

//查询就诊列表
function queryData()
{
	var queryItem = document.getElementById("diagnosDesc").value
	$("#episodeList").datagrid('load', {
		Action: "GetEpisodeList",
		PatientID: patientID,
		QueryItem: (queryItem == "诊断内容")? "":queryItem,
		EpisodeType: $('#episodeType').combobox('getValue')
	});	
}

//浏览病历
function browseRecords()
{
	var catalog = $('#recordList').treegrid('getSelections');
	setCategory(catalog);
}

//加载页面病历目录
function setCategory(data)
{
	$('.navcategory').empty();
	for (var i=0;i<data.length;i++)
	{
		if (data[i].id.indexOf("_") <=0) continue;
		var li = $('<li></li>');
		var link = $('<a>'+ data[i].text +'</a>');
		$(link).attr("id",data[i].id.replace("_","||")); 
		$(link).attr("chartItemType",data[i].chartItemType);
		$(link).attr("pluginType",data[i].documentType);
		$(link).attr("emrDocId",data[i].emrDocId);
		$(link).attr("href","javascript:void(0);");
		$(link).attr("type",data[i].type); 
		$(li).append(link);  
		$('.navcategory').append(li);
		if (i == 0)
		{
			loadRecords(link);
		}
	}
}

//取调用数据
function setTempParam(obj)
{
	var id = $(obj).attr("id");
    var chartItemType = $(obj).attr("chartItemType");
    var pluginType = $(obj).attr("pluginType");
    var emrDocId = $(obj).attr("emrDocId");
	var tempParam = {"id":id,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"url":""};
	return tempParam;
}

//加载病历
function loadRecords(obj)
{
	if (window.frames["framebrowse"])
	{
	 	window.frames["framebrowse"].loadDocument(setTempParam(obj));
	}
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

function windowClose()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}
//判断引用的病历和当前版本是否一致
function quatationCheck(instanceID){
	var result=true;
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLQuotation",
			"Method":"quatationCheck",
			"p1":instanceID,
			"p2":docID
			},
		success : function(d) {
			if (d=="1"){
				result =false;	
			}
		},
		error : function(d) {
			alert("error");
		}
	});
	return result
}