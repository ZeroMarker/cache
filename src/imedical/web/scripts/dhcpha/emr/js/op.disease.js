//加载病种
function GetDisease()
{
	InitDiseaseTree();
	GetDiseaseTreeData();
}

//Desc:定义病种树
function InitDiseaseTree()
{
	$('#disease').combotree({
		panelWidth: 160,
		onBeforeSelect: function(node){
			//只能选中叶子节点
			if (!$('#disease').tree('isLeaf',node.target))
			{
				return false;
			}
		},
		onLoadSuccess: function(node, data){
			var id = ''==invoker.emrEditor.DiseaseID ? '0' : invoker.emrEditor.DiseaseID;
			$('#disease').combotree('setValue', id);
			/*for (var i=0;i<data.length;i++){
				if (SetDisease == "0")
				{
					SetTree(data[i].id);
				}
				else if (SetDisease == "1")
				{
					return;
				}
			}*/
			
		},
		onSelect: function(node){
			invoker.emrEditor.DiseaseID = node.id;
			try
			{						
				//if (!window.frames["kbDataFrame"]) return;
				//window.frames["kbDataFrame"].setDiseaseData(node.id);
				setDiseaseData(node.id);
			} catch(error) {};
		}
	}); 	
}

function SetTree(id)
{
	var tt = $('#disease').combotree('tree');
	var node = tt.tree('find',id);
	//alert(node.text);
	if (tt.tree('isLeaf',node.target))
	{
		if (node.attributes.isUsed == "1")
		{
			$('#disease').combotree('setValue',node.id);
			SetDisease = "1";
		}
	}
	else
	{
		var children = tt.tree('getChildren',node.target);
		for (var j=0;j<children.length;j++){
			if (SetDisease == "0")
			{
				SetTree(children[j].id);
			}
			else if (SetDisease == "1")
			{
				return;
			}
		}
	}
}

//Desc:获取病种数据
function GetDiseaseTreeData()
{
	//debugger;
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbDisease.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CurAction":"List","KBDiagnos":"","UserLocID":userLocID},
		success : function(d) {
			//debugger;
			$('#disease').combotree('loadData',eval(d));		
		},
		error : function(d) {
			alert("get disease error");
		}
	});
	
	
}

//保存选择病种
function SaveDiseaseToAdmPatType(kbDiagnos)
{
    jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbDisease.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CurAction":"Select","KBDiagnos":kbDiagnos},
		success : function(d) { if(d == "failed") alert("save disease failed") },
		error : function(d) {
			alert("save disease failed");
		}
	});
}﻿

$(function() {
	GetDisease();	
});