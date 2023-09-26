$(function(){
	strXml = convertToXml(scheme);
	var interface = $(strXml).find("interface").text();
	var display = $(strXml).find("display").text();
	$('#currentEpisode').attr("checked",true);
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGird(display,interface);	
	$('#seekform').find(':radio').change(function () {
		if (this.id == "allEpisode")
		{
			$("#comboxEpisode").show();
		}
		else
		{
			$("#comboxEpisode").hide();
			queryData();
		}
	});
	$('#tabOrders').tabs({
		onSelect:function(title){  
	  		queryData();
		} 
	});
});


	
///初始化界面
function setDataGird(display,interface)
{
	var columns = getColumnScheme("scheme>show>parent>item");
	initDataGrid('#norders',columns,'N',display,interface);
	initDataGrid('#sorders',columns,'S',display,interface);
	initDataGrid('#oorders',columns,'O',display,interface);
}

//设置数据
function initDataGrid(id,columns,type,display,interface)
{
	var param = getParam();
	$(id).datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.orderData.cls?Action=GetOrderData&OrderType='+type+'&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    idField:'OEItemID',
	    fit:true,
	    columns:columns,
	    remoteSort:false,
	    sortName:['OrdCreateDate','OrdCreateTime'],
	    sortOrder:'desc',
	    rowStyler:function(index,row){
		    if (row.Reflag == "Parent"){
			    return 'background-color:#CBE8F6;';
			}
		},
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			if (rowData.Reflag == "Parent"){
				return '<div style="padding:2px"><table id="Sub-' + rowIndex + '"></table></div>';
			}
		},
		onExpandRow: function(index,row){
			if(row.Reflag == "Parent")
			{
				var epsodeIds = episodeID;
				if ($('#allEpisode')[0].checked)
				{
					epsodeIds = "";
					var values = $('#EpisodeList').combogrid('getValues');
					for (var i=0;i< values.length;i++)
					{
						epsodeIds = (i==0)?"":epsodeIds + ",";
						epsodeIds = epsodeIds + values[i];
					}	
				}
				$('#Sub-'+index).datagrid({
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					url:'../EMRservice.Ajax.orderData.cls?Action=GetSubOrderData&OrderType='+type+'&EpisodeID='+epsodeIds+'&OEItemID='+row.OEItemID+'&InterFace='+encodeURI(encodeURI(interface)),
					rownumbers:true,
					singleSelect:false,
					idField:'OEItemID',
					columns:getColumnScheme("scheme>show>child>item"),
					sortName:['OrdCreateDate','OrdCreateTime'],
					sortOrder:'desc',
					onResize:function(){
						$(id).datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$(id).datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$(id).datagrid('fixDetailRowHeight',index);
			}else{
				$(id).datagrid('collapseRow',index);
				
			}
		},
		onCheck:function(rowIndex,rowData){
			if (rowData.Reflag == "Parent"){
				$('#Sub-'+rowIndex).datagrid('checkAll');
			}
		},
		onUncheck:function(rowIndex,rowData){
			if (rowData.Reflag == "Parent"){
				$('#Sub-'+rowIndex).datagrid('uncheckAll');
			}
		},
		onCheckAll:function(rows){
			for(var i=0;i<rows.length;i++){
				if (rows[i].Reflag == "Parent"){
					$('#Sub-'+i).datagrid('checkAll');
				}
			}
		},
		onUncheckAll:function(rows){
			for (var i=0;i<rows.length;i++){
				if (rows[i].Reflag == "Parent"){
					$('#Sub-'+i).datagrid('uncheckAll');
				}
			}
		},
		onLoadSuccess: function(data){
			if (display == "Y")
			{
				$.each(data.rows,function(idx,val){
					if (val.Reflag == "Parent"){
						$(id).datagrid('expandRow',idx);
					}
				});
			}
		}
  });
}
// 查询
function queryData()
{
	var param = getParam();
	var id = getSelectGridId();
	$('#'+id).datagrid('load',param);
}

//获取查询参数
function getParam()
{
	var epsodeIds = episodeID; 
	if ($('#allEpisode')[0].checked)
	{
		epsodeIds = "";
		var values = $('#EpisodeList').combogrid('getValues');
		for (var i=0;i< values.length;i++)
		{
			epsodeIds = (i==0)?"":epsodeIds + ",";
			epsodeIds = epsodeIds + values[i];
		}	
	}
	var param = {
		EpisodeID:epsodeIds
	};
	return param;		
}

//引用数据
function getData()
{
	var id = getSelectGridId();
	var checkedItems = $('#'+id).datagrid('getChecked');
	if (checkedItems.length == 0) return;
	var refScheme = getRefScheme("scheme>reference>"+id+">parent>item");
	var refSubScheme = getRefScheme("scheme>reference>"+id+">child>item");
	var separate = $(strXml).find("scheme>reference>"+id+">separate").text();
	separate = separate=="enter"?"\n":separate;
	var seq = $(strXml).find("scheme>reference>"+id+">seq").text();
	seq = seq==""?"parent":seq;
	var result = "";
	if (seq == "parent")
	{
		result = getParentSeqData(id,checkedItems,refScheme,refSubScheme,separate);
	}else if (seq == "child"){
		result = getChildSeqData(id,checkedItems,refScheme,refSubScheme,separate);
	}
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);            
	//去掉选择
	$("#"+id).datagrid("uncheckAll");
}
//关联医嘱父项在前的引用格式
function getParentSeqData(id,checkedItems,refScheme,refSubScheme,separate)
{
	var result = "",num = 1;
	$.each(checkedItems, function(index, item){
		var rowIndex = $('#'+id).datagrid('getRowIndex',item["OEItemID"]);
		result = result + num + ".";
		var checkedsubItems = "";
		if (item["Reflag"] == "Parent"){
			checkedsubItems = $('#Sub-'+rowIndex).datagrid('getChecked');
		}
		for (i=0;i<refScheme.length;i++ ){
			//判断引用字段是否为空
			if (item[refScheme[i].code] != "")
			{
				result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;
			}
			if (i == refScheme.length-1)
			{
				if ((result != "")&&(item[refScheme[i].code] == "")&&(refScheme[i-1].separate != ""))
				{
					result = result.substring(0,result.length-1);
				}
			}
		}
		//关联医嘱
		if (checkedsubItems.length != 0){
			result = result + separate + "  ";
			$.each(checkedsubItems, function(index, item){
				for (i=0;i<refSubScheme.length;i++ ){
					if (item[refSubScheme[i].code] != ""){
						result = result + refSubScheme[i].desc + item[refSubScheme[i].code] + refSubScheme[i].separate;
					}
					if (i == refSubScheme.length-1){
						if ((result != "")&&(item[refSubScheme[i].code] == "")&&(refSubScheme[i-1].separate != "")){
							result = result.substring(0,result.length-1);
						}
					}
				}
				if (checkedsubItems.length-1 > index){
					result = result + separate + "  ";
				}
			});
			$('#Sub-'+rowIndex).datagrid('uncheckAll');
		}
		if (checkedItems.length-1 > index)
		{
			result = result + separate;
		}
		num = num + 1;
	}); 
	return result;        
}
//关联医嘱子项在前的引用格式
function getChildSeqData(id,checkedItems,refScheme,refSubScheme,separate)
{
	var result = "",num = 1;
	$.each(checkedItems, function(index, item){
		var rowIndex = $('#'+id).datagrid('getRowIndex',item["OEItemID"]);
		result = result + num + ".";
		var checkedsubItems = "";
		if (item["Reflag"] == "Parent"){
			checkedsubItems = $('#Sub-'+rowIndex).datagrid('getChecked');
		}
		//关联医嘱
		if (checkedsubItems.length != 0){
			//result = result + separate + "  ";
			$.each(checkedsubItems, function(index, item){
				for (i=0;i<refSubScheme.length;i++ ){
					if (item[refSubScheme[i].code] != ""){
						result = result + refSubScheme[i].desc + item[refSubScheme[i].code] + refSubScheme[i].separate;
					}
					if (i == refSubScheme.length-1){
						if ((result != "")&&(item[refSubScheme[i].code] == "")&&(refSubScheme[i-1].separate != "")){
							result = result.substring(0,result.length-1);
						}
					}
				}
				/*if (checkedsubItems.length-1 > index){
					result = result + separate + "  ";
				}*/
			});
			result = result + "入";
			$('#Sub-'+rowIndex).datagrid('uncheckAll');
		}
		for (i=0;i<refScheme.length;i++ ){
			//判断引用字段是否为空
			if (item[refScheme[i].code] != "")
			{
				result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;
			}
			if (i == refScheme.length-1)
			{
				if ((result != "")&&(item[refScheme[i].code] == "")&&(refScheme[i-1].separate != ""))
				{
					result = result.substring(0,result.length-1);
				}
			}
		}
		if (checkedItems.length-1 > index)
		{
			result = result + separate;
		}
		num = num + 1;
	}); 
	return result;
}

//获取选中gird的ID
function getSelectGridId()
{
	var pp = $('#tabOrders').tabs('getSelected');
	var tab = pp.panel('options').tab; 	
	var id = "";
	switch(tab[0].innerText)
	{
		case "临时医嘱":
		  id = "norders";
		  break;
		case "长期医嘱":
		  id = "sorders";
		  break;
		case "出院带药":
		  id = "oorders";
		  break;	  	  
	}
	return id;
}