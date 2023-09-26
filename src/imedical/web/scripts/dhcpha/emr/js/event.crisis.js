$(function(){
	initCategory();
});
//从后台获得目录数据
function initCategory(){
	jQuery.ajax({
		type:"post",
		dataType:"text",
		url:'../EMRservice.Ajax.eventData.cls',
		async:false,
		data:{
			"Action": "GetEventCategory",
			"EpisodeID": episodeID,
			"EventType": "CriticalValue"
		},
		success:function(d) {
			setCategory(eval("["+d+"]"));
		},
		error:function(d) { alert("CriticalValue error");}
	});
}
//加载目录明细到页面
function setCategory(data)
{
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		var link = $('<a>'+ data[i].EventDesc +'</a>');
		$(link).attr("id",data[i].ID);       
		$(link).attr("href","javascript:void(0);");
		$(link).attr("EventCode",data[i].EventCode);
		$(link).attr("EventType",data[i].EventType); 
		$(li).append(link);  
		$('.navcategory').append(li);
		if (i == 0)
		{
			categoryClick(link);
		}
	}
}
//目录点击事件
$('.navcategory li a').live('click',function(){
	categoryClick(this);
});
function categoryClick(obj)
{
	$('#crisis').datagrid({
		loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.eventData.cls?Action=GetData&EventType='+"CriticalValue"+'&EpisodeID='+episodeID,
	    singleSelect:true,
	    idField:'ID',
	    fitColumns:true,
	    fit:true,
	    autoRowHeight:true,
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'ck',checkbox:true},
	    	{field:'ID',title:'rowId',hidden:true},
	    	{field:'CriticalValueDate',title:'审核日期',width:200},
	    	{field:'CriticalValueTime',title:'审核时间',width:200},
	    	{field:'LabNo',title:'危机值唯一标示符',hidden:true},
	    	{field:'CriticalValueDesc',title:'危机值描述',width:150},
	    	{field:'CriticalValue',title:'危机值',width:150},
	    	{field:'ItemUnit',title:'单位',width:100},
	    	{field:'ItemRanges',title:'值范围',width:150},
	    	{field:'OEordItemRowID',title:'OEordID',hidden:true},
	    	{field:'OEordItemDesc',title:'医嘱名称',width:200},
	    	{field:'IsActive',title:'是否创建',width:100},
	    	{field:'TextDesc',title:'病历名称',width:100,formatter:setTextDesc}
	    ]],
	    rowStyler: function(index,row){
			if (row.IsActive == "已创建")
			{
				return 'color:#CCCCCC;';
			}
		},
	    onLoadSuccess:function(data){
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					if (data.rows[i].IsActive == "已创建") 
					{	
						$("input[type='checkbox']").eq(i + 1).attr("disabled",'disabled');
					}
				}
			}     
		},
		onClickRow: function(rowIndex, rowData){
			if (rowData.TextDesc != ""){
				openClick(rowData);
			}else{
				var text = '是否确定创建？';
				var returnValues = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
				if (returnValues == "confirm"){
					createClick(rowIndex);
				}
			}
			$('#crisis').datagrid("uncheckRow",rowIndex);
		}
	});
	$(".datagrid-header-check").attr("disabled","disabled");
}
//设置病历名称
function setTextDesc(val,row,index)
{
	if (row.IsActive  == "已创建"){
		if (row.TextDesc == ""){
			var span = '<a style="color:#000000;text-decoration:none;">已删除</a>';
			return span;	
		}else{
			var span = '<a style="text-decoration:none;">'+row.TextDesc+'</a>';
			return span;
		}
	}

}
//打开"已创建"病历的操作
function openClick(rowData)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.Event.BLLinkDocument",
			"Method":"GetInstanceInfo",
			"p1": episodeID,
			"p2": "Save",
			"p3": "CriticalValue",
			"p4": rowData.ID
		},
		success: function(d){
			if (d != ""){
				var data = eval("["+d+"]");
				var tabParam = {
					"id":data[0].id,
					"text":data[0].text,
					"pluginType":data[0].documentType,
					"chartItemType":data[0].chartItemType,
					"emrDocId":data[0].emrDocId,
					"templateId":data[0].templateId,
					"isLeadframe":data[0].isLeadframe,
					"isMutex":data[0].isMutex,
					"categoryId":data[0].categoryId,
					"characteristic":data[0].characteristic,
					"IsActive":"",
					"actionType":"LOAD",
					"status":"NORMAL",
					"closable":true
				};
				if ((tabParam == "")||(tabParam == undefined)) return;
				parent.operateRecord(tabParam);
			}
		},
		error : function(d){ alert("GetInstanceInfo error");}
	});
}
//"未创建"病历的创建操作
function createClick(rowIndex)
{
	var obj = new Object();
	obj.rowIndex = rowIndex;
	var returnValues = "";
	returnValues = window.showModalDialog("emr.event.csp?EpisodeID="+episodeID+"&EventType="+"CriticalValue",obj,"dialogHeight:500px;dialogWidth:700px;resizable:no;status:no");
	if (returnValues.length != 0)
	{
		var Values = eval("("+returnValues+")");
		if ((Values == "")||(Values == undefined)) return;
		parent.operateRecord(Values);
	}
}
//重新加载
function Reload(){
	$('#crisis').datagrid('reload');
}

