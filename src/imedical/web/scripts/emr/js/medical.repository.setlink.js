$(function(){
	//初始化加载两个页面的数据
	initialize();
});

function initialize(){
	//全部科室
	$('#LocList').tree({
		url: '../EMRservice.Ajax.Repository.cls?Action=GetLocList',
		method: 'get',
        checkbox: true,
		checked: false,
		onCheck:function(node,checked){
			if(checked){
				if(SltLoc!="") SltLoc=SltLoc+'^';
				SltLoc = SltLoc+node.id;
			}else{
				var id = node.id;
				var re1 =new RegExp('^'+id+'\\^|\\^'+id+'$|^'+id+'$'); // re为/^id\^|\^id$|^id$/
				var re2 =new RegExp('\\^'+id+'\\^'); // re为/\^id\^/
				if(r = SltLoc.match(re1)) SltLoc = SltLoc.replace(r[0],'');
				else if(r = SltLoc.match(re2)) SltLoc = SltLoc.replace(r[0],'^');
			}
		}
    });
	//全部目录
	$('#CateList').tree({
		url: '../EMRservice.Ajax.Repository.cls?Action=GetCateList',
		method: 'get',
        animate: true,
		checkbox: true,
		checked: false,
		onlyLeafCheck:true,
		onLoadSuccess:function(node,data){
			for(var i=0;i<data.length;i++){
				for(var j=0;j<data[i].children.length;j++){
					if (unSltCate!="") unSltCate = unSltCate+"^";
					unSltCate = unSltCate+data[i].children[j].id.substr(2);
				}
			}
		},
		onCheck:function(node,checked){
			//如果在Slt中，删除Slt，添加unSlt；如果不在反之
			var id = node.id.substr(2);
			var re1 =new RegExp('^'+id+'\\^|\\^'+id+'$|^'+id+'$'); // re为/^id\^|\^id$|^id$/
			if(r = SltCate.match(re1)){
				SltCate = SltCate.replace(r[0],'');
				if (unSltCate!="") unSltCate = unSltCate+"^";
				unSltCate = unSltCate+id;
				return;
			}
			var re2 =new RegExp('\\^'+id+'\\^'); // re为/\^id\^/
			if(r = SltCate.match(re2)){
				SltCate = SltCate.replace(r[0],'^');
				if (unSltCate!="") unSltCate = unSltCate+"^";
				unSltCate = unSltCate+id;
				return;
			}
			if(r = unSltCate.match(re1)){
				unSltCate = unSltCate.replace(r[0],'');
				if (SltCate!="") SltCate = SltCate+"^";
				SltCate = SltCate+id;
				return;
			}
			if(r = unSltCate.match(re2)){
				unSltCate = unSltCate.replace(r[0],'^');
				if (SltCate!="") SltCate = SltCate+"^";
				SltCate = SltCate+id;
				return;
			}
		}
    });
}

//配置关联主功能
document.getElementById('SetLocCateLink').onclick = function(){
	$.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLiBookLink",
			"Method":"SetCateLocLink",
			"p1":SltLoc,
			"p2":SltCate,
			"p3":unSltCate
		},
		success: function(d){
			if(d==1) alert('配置成功');
		},
		error: function(d){
			alert("error");
		}
	});
};

//搜索科室
function doSearchLoc(value,name){
	var treedata = $('#'+name).tree('getRoots');
	var curNode = $('#'+name).tree('getSelected');
	if(curNode == null) curNode = 0;
	else curNode = curNode.attributes.index+1;
	for(var i=curNode; i<treedata.length; i++){
		if(treedata[i].text.indexOf(value)>=0){
			$('#'+name).tree('select',treedata[i].target);
			var offset = $(treedata[i].target).offset().top-$('#'+name).offset().top;
			$('#Locbox').scrollTop(offset);
			return;
		}
	}
	for(var i=0; i<curNode; i++){
		if(treedata[i].text.indexOf(value)>=0){
			$('#'+name).tree('select',treedata[i].target);
			var offset = $(treedata[i].target).offset().top-$('#'+name).offset().top;
			$('#Locbox').scrollTop(offset);
			return;
		}
	}
};

//搜索文献目录
function doSearchCate(value,name){
	var treedata = $('#'+name).tree('getRoots');
	var curNode = $('#'+name).tree('getSelected');
	var curCate = 0;
	if(curNode == null){
		curNode = 0;
	}
	else if($('#'+name).tree('isLeaf',curNode.target)){
		curCate = $('#'+name).tree('getParent',curNode.target).attributes.index;
		curNode = curNode.attributes.index+1;
	}
	else{
		curCate = curNode.attributes.index;
		curNode = 0;
	}
	for(var i=curCate; i<treedata.length; i++){
		var children = $('#'+name).tree('getChildren',treedata[i].target);
		var start = 0;
		if(i==curCate) start = curNode;
		for(var j=start; j<children.length; j++){
			if(children[j].text.indexOf(value)>=0){
				$('#'+name).tree('select',children[j].target);
				var offset = $(children[j].target).offset().top-$('#'+name).offset().top;
				$('#Catebox').scrollTop(offset);
				return;
			}			
		}
	}
	for(var i=0; i<curCate; i++){
		var children = $('#'+name).tree('getChildren',treedata[i].target);
		var end = children.length;
		if(i==curCate) end = curNode;
		for(var j=0; j<end; j++){
			if(children[j].text.indexOf(value)>=0){
				$('#'+name).tree('select',children[j].target);
				var offset = $(children[j].target).offset().top-$('#'+name).offset().top;
				$('#Catebox').scrollTop(offset);
				return;
			}			
		}
	}
};