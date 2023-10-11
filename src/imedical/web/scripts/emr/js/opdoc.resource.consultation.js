$(function(){
	var consultation = document.getElementById("consultation");
	consultation.setAttribute("src",url);
	consultation.onload = function(){
		window.addEventListener("message",function(event){
			insertSection(event.data.value);
			});
	};
},0);

function insertSection(datajson)
{
	if ((datajson == undefined)||(datajson == "")) return;
	var data = $.parseJSON(datajson.replace(/\'/g, "\""));
	
	//获取meta-tree,发送同步命令：
    var metaDataTree = parent.iEmrPlugin.GET_METADATA_TREE({isSync:true}); 
	var metaArry = metaDataTree.items;
	for(var i=0;i<metaArry.length;i++)
	{
		if (metaArry[i].Type && metaArry[i].DisplayName && metaArry[i].Type==="Section")
		{
			var sectionName = metaArry[i].DisplayName.replace(/[\uFF1A:]/g,"").replace(/\s/g,"")
			if (data.hasOwnProperty(sectionName))
			{ 
				//发送光标定位命令【同步】
				parent.iEmrPlugin.FOCUS_ELEMENT({Path:metaArry[i].Code,actionType:'Last',InstanceID:'',isSync:true});
				//发送插入命令【同步】
				parent.iEmrPlugin.INSERT_TEXT_BLOCK({args:data[sectionName],isSync:true});
			}
		}
	}
}
