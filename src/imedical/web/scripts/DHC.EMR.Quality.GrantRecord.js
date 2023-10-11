$(function(){
	InitDataList();
});
function InitDataList()
{
	$('#ListTable').treegrid({ 
			title:"病历整改授权",
			headerCls:'panel-header-gray',
			idField: 'id',
			treeField: 'text',
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			fitColumns:true,
			url:'../EPRservice.Quality.Ajax.GrantRecord.cls',
			queryParams: {
				EpisodeID:EpisodeID
            },
			fit:true,
			checkbox:true,
			columns:[[			
				{field:'text',title:'病历名称',width:130},
				//{field:'id',title:'病历id',width:100},				
				{field:'happendatetime',title:'完成时间',width:90},
				{field:'creator',title:'医生',width:50},
				
			]],
			onClickCell: function(rowIndex, field, value) {
			}
			
			}); 		
			
}


function Grant()
{
	var GrantList=$('#ListTable').treegrid('getCheckedNodes')
	if (GrantList.length == 0) 
	{	
		$.messager.alert("提示","请选择退回病历！");
		return;
	}	
	var GrantID = "";
	for(var i=0; i<GrantList.length; i++){		
		var id = GrantList[i].id.replace("-","||");
		if (id.indexOf("||")==-1) continue
		if (GrantID=="")
		{
			GrantID=id
		}else{
			GrantID=GrantID+"^"+id
		}
	}	
	if (typeof parent.entryFrame.window.BackAndGrant == "function")
	{
		parent.entryFrame.window.BackAndGrant(GrantID)
	}else if (typeof parent.entryFrame.frames[1].window.BackAndGrant == "function"){
		parent.entryFrame.frames[1].window.BackAndGrant(GrantID)
	}
	parent.closeDialog('QualityRecordGrant')
	
}

