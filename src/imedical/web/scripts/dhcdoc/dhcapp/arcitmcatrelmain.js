/// zhouxin
/// 2016-04-11
/// 医嘱分类关联维护
var cat="" //定义cat全局变量
/// 定义界面tab列表
var tabsObjArr = [
	{"tabTitle":"其它项目","tabCsp":"dhcapp.catotheropt.csp"},
	{"tabTitle":"打印模板","tabCsp":"dhcapp.prttemp.csp"},
	///{"tabTitle":"部位","tabCsp":"dhcapp.catlinkpart.csp"},
	///{"tabTitle":"监护级别","tabCsp":"dhcpha.clinical.pharcaremonlevel.csp"},
	];

$(function(){
	///初始化界面按钮事件
	InitWidListener();
})

$(function(){
//给描述绑定一个回车事件
$('#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //queryAdrPatImpoInfo(this.id+"^"+$('#'+this.id).val()); //调用查询
           commonQuery(); //调用查询 
                    
        }
    });

// 查找按钮绑定单击事件
$('#find').bind('click',function(event){
         commonQuery(); //调用查询
    })
    
//重置按钮绑定单击事件
$('#reset').bind('click',function(event){
		$('#desc').val("");
		commonQuery(); //调用查询
	})		
	
})
///查询
function commonQuery()
{
	//alert(params)
	$('#datagrid').datagrid('load',{
			desc:$.trim($('input[name="desc"]').val())
		
		})
	
	//$.messager.alert("提示","查询没反应111！！！")
}

/// 界面元素监听事件
function InitWidListener(){
    //tab事件
    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,cat)}});
		    }
		    });
}
///get iframe from frames 
function getTabWindow() {
	var curTabWin = null;
	var curTab = $('#tabs').tabs('getSelected');
	if (curTab && curTab.find('iframe').length > 0) {
		curTabWin = curTab.find('iframe')[0].contentWindow;
	}
	return curTabWin;
}
$(function(){
    ///huaxiaoying 2016-05-17 复制功能
    $("#copy").on('click', function() {    
		var row = $("#datagrid").datagrid('getSelected'); 
	    if (row==null) {
		    $.messager.alert("提示","请选一个检查分类!");
		    return;
		    }
		$('#detail').dialog('open');
		$('#detail').dialog('move',{
				left:280,
				top:180
			});
	    $('#detailgrid').datagrid({  
	    	
	    	url:LINK_CSP+'?ClassName=web.DHCAPPCommonUtil&MethodName=QueryArcCatList',
	    	    method:'get',
	    	    fit:true,
	    	    loadMsg:'加载数据中.....',
	    	    pagination:true,
	    	    fitColumns:true,
	    	    rownumbers:true,
	    	    //onClickRow:detailonClickRow,
	    	    onDblClickRow:onDblClickRow,
	    	    columns:[[ 
			            {field:'ACCatCode',title:'代码',width:100},
			            {field:'ACCatDesc',title:'描述',width:120},
			            {field:'ID',title:'id',hidden:true,width:50}
	    	  	        ]]
	    	  	
		    });   
 	}); //复制功能END
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
	
   
})

///复制功能调用
function onDblClickRow(rowIndex, rowData){
	$.messager.confirm('确认','您确认将以该项为模板吗？',function(r){    
    if (r){
	    var currRow =$('#detailgrid').datagrid('getSelected'); 
	    if(rowData.ID==cat){
		$.messager.alert("提示","相同!不用复制！");
		return;
		}else{
	         runClassMethod(
	 				"web.DHCAPPCatLinkPart",
	 				"SaveCopy",
	 				{
		 				'CatRowIdTwo':rowData.ID,
	 				    'CatRowId':cat
	 				 },
	 				 function(data){
		 				 
		 				  })
		 				   
	        $('#detail').window('close');
			getTabWindow().reloadTreeGrid();//调用刷新
	        }
    }
    });
	}

/// 添加选项卡
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// 创建框架
function createFrame(tabUrl, cat){
	tabUrl = tabUrl.split("?")[0];
	if(typeof websys_writeMWToken=='function') tabUrl=websys_writeMWToken(tabUrl);
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?cat='+ cat +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

function onClickRow(rowIndex, rowData){
	cat=rowData.ID;//得到cat值
	var currTab =$('#tabs').tabs('getSelected'); 
	var iframe = $(currTab.panel('options').content);
	var src = iframe.attr('src');
	$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.ID)}});
}