//websys.menu.security.js
// underscore 防抖
function debounce(func, wait, immediate) {

    var timeout, result;

    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };

    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };

    return debounced;
}
var init=function(){
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	$('#title').keywords({
	    singleSelect:true,
	    items:[
	        {text:'头菜单',id:'tab-H',selected:true},
	        {text:'侧菜单',id:'tab-S'},
	        {text:'组件菜单',id:'tab-C'},
	        {text:'手风琴菜单',id:'tab-A'}
	    ],
	    onClick:function(v){
		    //console.log(v)
		    var type=v.id.split("tab-")[1];
		    if ($('#part-'+type).hasClass('part-hidden')){
			    $('.part').not(".part-hidden").addClass('part-hidden');
			    $('#part-'+type).removeClass('part-hidden');
			}
			$('#update').data('menutype',type);
			$('#search').data('menutype',type);
		},
	})
	$('.part .tree-container').height(GV.maxHeight-39-10-10-2);
	$(window).resize(debounce(function(){
		GV.maxHeight=$(window).height()||550;
		$('.part .tree-container').height(GV.maxHeight-39-10-10-2);
	},200))
	
	
	
	//getDataS(1);
	initTree();
	getDataH();
	
}

var getDataH=function(){
	$.m({ClassName:'websys.Menu',MethodName:'TreeJson',id:0,GroupId:GV.groupid,Authorize:0,type:'H',allload:'1',HospId:GV.HospId||''},function(rtn){
		GV.dataH=$.parseJSON(rtn);
		refreshTree("H");
		$('#Loading').fadeOut('fast');
		getDataS();
	})
};
var getDataS=function(){
	$.m({ClassName:'websys.Menu',MethodName:'TreeJson',id:0,GroupId:GV.groupid,Authorize:0,type:'SG',allload:'1',HospId:GV.HospId||''},function(rtn){
		GV.dataS=$.parseJSON(rtn);
		refreshTree("S");
		getDataC();
	})
};
var getDataC=function(){
	$.m({ClassName:'websys.Menu',MethodName:'TreeJson',id:0,GroupId:GV.groupid,Authorize:0,type:'C',allload:'1',HospId:GV.HospId||''},function(rtn){
		GV.dataC=$.parseJSON(rtn);
		refreshTree("C");
		getDataA();
	})
};
var getDataA=function(){
	$.m({ClassName:'websys.Menu',MethodName:'TreeJson',id:0,GroupId:GV.groupid,Authorize:0,type:'A',allload:'1',HospId:GV.HospId||''},function(rtn){
		GV.dataA=$.parseJSON(rtn);
		refreshTree("A");
		
	})
};
var initTree=function(){
	$('#tree-h').tree({
		data:[],
		checkbox:true,
		cascadeCheck:false,
		onCheck:onCheckHandler,
		onClick:function(node){
			if (node.checked){
				$('#tree-h').tree('uncheck',node.target);
			}else{
				$('#tree-h').tree('check',node.target);
			}
		},
		onLoadSuccess:onLoadSuccessHandler,
		formatter:treeNodeFormatter
	});
	
//	$('#search-h').searchbox({
//		searcher:searcherHandler
//	})
	$('#tree-s').tree({
		data:[],
		checkbox:true,
		cascadeCheck:false,
		onCheck:onCheckHandler,
		onClick:function(node){
			if (node.checked){
				$('#tree-s').tree('uncheck',node.target);
			}else{
				$('#tree-s').tree('check',node.target);
			}
		},
		onLoadSuccess:onLoadSuccessHandler,
		formatter:treeNodeFormatter
	});
//	$('#search-s').searchbox({
//		searcher:searcherHandler
//	});
	$('#tree-c').tree({
		data:[],
		checkbox:true,
		cascadeCheck:false,
		onCheck:onCheckHandler,
		onClick:function(node){
			if (node.checked){
				$('#tree-c').tree('uncheck',node.target);
			}else{
				$('#tree-c').tree('check',node.target);
			}
		},
		onLoadSuccess:onLoadSuccessHandler,
		formatter:treeNodeFormatter
	})
//	$('#search-c').searchbox({
//		searcher:searcherHandler
//	});
	$('#tree-a').tree({
		data:[],
		checkbox:true,
		cascadeCheck:false,
		onCheck:onCheckHandler,
		onClick:function(node){
			if (node.checked){
				$('#tree-a').tree('uncheck',node.target);
			}else{
				$('#tree-a').tree('check',node.target);
			}
		},
		onLoadSuccess:onLoadSuccessHandler,
		formatter:treeNodeFormatter
	})
//	$('#search-a').searchbox({
//		searcher:searcherHandler
//	});
	
//	$('#update-h,#update-s,#update-c,#update-a').click(updateClickHandler);
	$('#search').searchbox({
		searcher:searcherHandler
	});
	$('#update').click(updateClickHandler);
	$('#export').click(exportClickHandler);
}
var refreshTree=function(type){
	if (type=="H") $('#tree-h').tree('loadData',GV.dataH);
	if (type=="S") $('#tree-s').tree('loadData',GV.dataS);
	if (type=="C") $('#tree-c').tree('loadData',GV.dataC);
	if (type=="A") $('#tree-a').tree('loadData',GV.dataA);
}

function formatData(data,search,parent){
	
	var flag=false,
		pok=(parent && parent.ok),
		search=search.toLowerCase();
	for(var i=0;i<data.length;i++){
		var item=data[i];
		item.ok=false;
		if(pok){
			item.ok=true;
		}else{
			var text=item.text.toLowerCase();
			var name=item.attributes.Name.toLowerCase();
			if(text.indexOf(search)>-1 || name.indexOf(search)>-1){
				item.ok=true;
			}
		}
		if (item.children ){
			formatData(item.children,search,item);
		}
		if (item.ok) flag=true;
	}
	if (flag && parent) parent.ok=true;
}
function formatNode(data,search){
	for(var i=0;i<data.length;i++){
		var item=data[i];
		
		if (item.children ){
			formatNode(item.children,search);
		}
		var t=$("#"+item.domId);
		
		if (item.ok) {
			var html=treeNodeFormatter(item);
			if(search!=""){
				var reg=new RegExp(search, 'ig');
				html=html.replace(reg,"<span class='reg-word'>"+search+"</span>");
			}
			t.find('.tree-title').html(html);
			//t.show();
			t.removeClass('tree-node-hidden');  
		}else{
			//t.hide();  //用hide 不知为啥在iframe中特别慢 得10几秒 奇怪
			t.addClass('tree-node-hidden');
		}
	}
}

function onLoadSuccessHandler(node,data){
	var type=this.id.split("tree-")[1].toUpperCase();
	GV['change'+type]={};
	fixCheckedStyle(data);
}
function fixCheckedStyle(data){
	for(var i=0;i<data.length;i++){
		var item=data[i];
		
		if (item.children ){
			fixCheckedStyle(item.children);
		}
		var t=$("#"+item.domId);
		if (t.find(".tree-checkbox1").length>0) {
			t.addClass('tree-node-checked');
		}else{
			t.removeClass('tree-node-checked');
		}
	}
}
//onCheck事件 记录改变的id 提交时只提交改变的
function onCheckHandler(node,checked){
	var type=this.id.split("tree-")[1].toUpperCase();
	var t=$(node.target);
	if(checked){
		t.addClass('tree-node-checked');
	}else{
		t.removeClass('tree-node-checked');
	}
	GV['change'+type][node.id]=node.domId;   //
};
function searcherHandler(value){
	//var type=this.id.split("search-")[1].toUpperCase();
	var type=$(this).data("menutype");
	if (type!=""){
		//console.log(new Date());
		formatData(GV["data"+type],value);//console.log(new Date());
		formatNode(GV["data"+type],value);//console.log(new Date());
	}
}
function treeNodeFormatter(node){
	return node.text+" ["+node.attributes.Name+']';
}
function exportClickHandler(){
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"group("+ GV.groupDesc+")Menu", //默认DHCCExcel
		ClassName:"web.Util.Menu",
		QueryName:"SelectGroupMenu",
		GroupId: GV.groupid
	},false);
	//var rtn = tkMakeServerCall("websys.Query","ToExcel","group("+groupDesc+")Menu","web.Util.Menu","SelectGroupMenu",groupId);
	location.href = rtn 
}
///更新保存按钮
function updateClickHandler(){
	//var type=this.id.split("update-")[1].toUpperCase();
	var type=$(this).data("menutype");
	var changed=GV['change'+type];
	var arr1=[],arr0=[];
	for (var i in changed){
		if(i>0){
			if($('#'+changed[i]).find('.tree-checkbox1').length>0){
				arr1.push(i);
			} else{
				arr0.push(i);
			}
			
		}
	}
	var data={ClassName:'epr.GroupSettings',MethodName:'SaveGroupMenuSecurity',groupid:GV.groupid,menuid1:arr1.join("^"),menuid0:arr0.join("^")};
	$.m(data,function(rtn){
		if(rtn>0){
			//$.messager.alert('成功','授权更新成功');
			$.messager.popover({msg:'授权更新成功',type:'success'});
			GV['change'+type]={};
		}else{
			//$.messager.alert('失败',rtn.split("^")[1]||"失败",'error');
			$.messager.popover({msg:rtn.split("^")[1]||"失败",type:'error',timeout:0});
		}
	})

}
$(init);