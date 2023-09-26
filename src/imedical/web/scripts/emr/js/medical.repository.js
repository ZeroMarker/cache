$(function(){
	initCategory();
});

//从后台获得目录数据
function initCategory()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLiBookCategory",
			"Method":"GetCategoryJson",
			"p1":0,
			"p2":userLocID
		},
		success: function(d){
			setCategory(eval('['+d+']'));
		},
		error: function(d){
			alert("error");
		}
	});
}

//加载目录明细到页面
function setCategory(data)
{
	for (var k=0;k<data.length;k++)
	{
		$('#navcategory').accordion("add",{
			id: data[k].id,
			title: data[k].text,
			selected: false,
			cls:"new-item"
		});
		var children = data[k].children;
		for(var i = 0; i<children.length; i++)
		{
			var subitem = $('<div class="subitem" style="width:auto"></div>');
			var content = $('<dl></dl>');
			$(content).append('<dt><a href="#">'+children[i].text+'</a></dt>');
			$(content).attr("id",children[i].id);
			var sub = $('<dd></dd>');
			var tData =  children[i].children; 
			//if ((tData == "")||(tData == undefined)) continue;
			for (var j=0;j<tData.length;j++)
			{
				//判断客户端浏览器IE及其版本
				if ($.browser.msie && $.browser.version == '6.0')
				{
					var link = $('<a href="#" class="list"></a>');
				}else
				{
					var link = $('<p class="list"></p>');
				}
				$(link).attr({"id":tData[j].id,"text":tData[j].text});
				$(link).append('<div class="ibook">'+tData[j].text+'</div>');
				if (tData[j].children != undefined)
				{
					if (tData[j].children.length > 0)
					{
						var titleInfo = setTitleByDocId(tData[j].children);
						if (titleInfo != "") $(link).append(titleInfo);				
					}
				}
				$(sub).append(link);
			}
			$(content).append(sub);
			$(subitem).append(content);
			$('#'+data[k].id).append(subitem);
			//判断客户端浏览器IE版本，好像是刷样式的，但是非ie6在哪刷样式没找到
			if ($.browser.msie && $.browser.version == '6.0')
			{
				$('.ibook').hover(function(){
					$(this).css("font-weight","bold");
				},function(){
					$(this).css("font-weight","normal");
				});
				$('.info').hover(function(){
					$(this).css("font-weight","bold");
				},function(){
					$(this).css("font-weight","normal");
				});
			}
		}
		//右键菜单
		$('#'+data[k].id).bind('contextmenu',function(e){
			e.preventDefault();
			var target = $(e.target);
			while(target[0].id == "") target = target.parent();
			$('#mm').attr('targetID', target[0].id);
			$('#mm').menu('disableItem',$('#deleteCate')[0]);
			$('#mm').menu('disableItem',$('#deleteFile')[0]);
			if($('#mm').attr('targetID').substr(0,2) == 'IB'){
				$('#mm').menu('enableItem',$('#deleteFile')[0]);
			}	
			else{
				var targetID = $('#mm').attr('targetID');
				if((targetID.substr(2,1) != "0")&&(parseInt(targetID.substr(2))>=7)&&($('#'+targetID)[0].childNodes[1].hasChildNodes()==false)) $('#mm').menu('enableItem',$('#deleteCate')[0]);
			}
			$('#mm').menu('show', {left: e.pageX, top: e.pageY});
		});
	}
	//自动选中“法律法规”页
	$('#navcategory').accordion("select",data[0].text);
}

//点击文档名打开文档
$('.subitem>dl>dd>.list>.ibook').live('click',function(){
	var obj = $(this).parent();
	var event = {};
	if (obj[0].id.substr(0,2) == 'IB'){
		var OpeniBook = '<iframe id = "ibdisplay" frameborder="0" src="emr.medical.repository.ibook.csp?iBookID='+obj[0].id.substr(2)+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		$('#framiBook').empty();
		$('#framiBook').append(OpeniBook);
	}
});

document.getElementById('addCate').onclick = function(){
	//自动获取目录位置
	var Category = $('#navcategory').accordion('getSelected');
	var CategoryID = $(Category).attr("id").substr(2);
	var CategoryName = $(Category).panel('options').title;
	var NewCategory = '<iframe id = "ibdisplay" frameborder="0" src="emr.medical.repository.newcategory.csp?ParentID='+CategoryID+'&ParentName='+CategoryName+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
	$('#framiBook').empty();
	$('#framiBook').append(NewCategory);
	//输入目录代码和目录名称，目录位置，自动生成的用户信息
	//返回1表示创建成功，返回0表示创建失败
}

document.getElementById('deleteCate').onclick = function(){
	//自动获取次级目录
	var CategoryID = $('#mm').attr('targetID');
	var issubCategory = CategoryID.substr(2,1);
	if(issubCategory == "0")
		CategoryID = CategoryID.substr(3);
	else
		CategoryID = CategoryID.substr(2);
	//传入目录位置，用户信息
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLiBookCategory",
			"Method":"RemoveCategory",
			"p1":CategoryID,
			"p2":userID+'^'+userLocID+'^'+ssgroupID+'^'
		},
		//返回1表示删除成功，其他表示删除失败
		success: function(d){
			if(d==1){				
				alert('删除成功');
				//左侧结构中删除对应条目
				$('#'+$('#mm').attr('targetID')).parent().remove();
			}else{
				alert(d);
			}
		},
		error: function(d){
			alert("error");
		}
	});
}

document.getElementById('addFile').onclick = function(){
	//根据位置判断目录位置
	var CategoryID = $('#mm').attr('targetID');
	var CategoryName = '';
	//如果目标为文档，那么Category为其目录ID，否则直接看目标ID
	if(CategoryID.substr(0,2) == 'IB'){
		var CategoryID = $('#'+CategoryID).parent().parent().attr('id');
	}
	//如果目标ID为CG0**（其他）则在上级目录新建，否则在当前目录新建
	var issubCategory = CategoryID.substr(2,1);
	if(issubCategory == "0")
	{
		CategoryID = CategoryID.substr(3);
		CategoryName = $('#CG'+CategoryID).panel('options').title;
	}
	else
	{
		CategoryID = CategoryID.substr(2);
		if(CategoryID<7){
			CategoryName = $('#CG'+CategoryID).panel('options').title;
		}else{
			CategoryName = $('#CG'+CategoryID)[0].childNodes[0].innerText;
		}
	}
	var NewiBook = '<iframe id = "ibdisplay" frameborder="0" src="emr.medical.repository.newibook.csp?ParentID='+CategoryID+'&ParentName='+CategoryName+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
	$('#framiBook').empty();
	$('#framiBook').append(NewiBook);
	//alert(CategoryID);
	//输入文档题目，作者，文件路径，目录位置，用户信息
}

document.getElementById('deleteFile').onclick = function(){
	//自动获取文档编号
	var iBookID = $('#mm').attr('targetID').substr(2);
	//传入文档号，目录位置
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLiBook",
			"Method":"RemoveiBook",
			"p1":iBookID,
			"p2": userID+'^'+userLocID+'^'+ssgroupID+'^'
		},
		//返回1表示删除成功，其他表示删除失败
		success: function(d){
			if(d==1){				
				alert('删除成功');
				//左侧结构中删除条目，若为其他中的最后一条顺手删除其他
				var CateElement = $('#'+$('#mm').attr('targetID')).parent();
				if((CateElement.parent()[0].id.substr(0,3) == 'CG0')&&(CateElement[0].childNodes.length == 1))
					CateElement.parent().parent().remove();
				else
					$('#'+$('#mm').attr('targetID')).remove();
			}else{
				alert(d);
			}
		},
		error: function(d){
			alert("error");
		}
	});
}