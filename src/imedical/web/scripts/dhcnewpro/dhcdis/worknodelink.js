
/** sufan 
  * 2018-04-09
  *
  * 医嘱项关联维护
 */
var NodeDr=""  ;  // 岗位Id
/// 定义界面tab列表

var tabsObjArr = [
	//{"tabTitle":"工作位置","tabCsp":"dhcdis.worklocation.csp"},
	{"tabTitle":"配送类型","tabCsp":"dhcdis.worktype.csp"},
	{"tabTitle":"岗位人员","tabCsp":"dhcdis.workuser.csp"},
	{"tabTitle":"服务组","tabCsp":"dhcdis.nodelinksergro.csp"}
	];

function initPageDefault(){
	
	initDefaultInfo();	/// 初始化界面默认信息
	initNodeList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}

/// 初始化界面默认信息
function initDefaultInfo(){
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// 初始化界面datagrid
function initNodeList()
{
	
	// 定义columns
	var columns=[[
		{field:"NodeCode",title:'岗位代码',width:220,align:'center'},
		{field:"NodeDesc",title:'岗位描述',width:220,align:'center'},
		{field:"NodeRowId",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			NodeDr = rowData.NodeRowId;
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.NodeRowId)}});
	    }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNode&MethodName=QueryDisNode";
	new ListComponent('nodelist', columns, uniturl, option).Init(); 
}
/// 初始化事件
function initButton(){

    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,NodeDr)}});
		   }
	 });
	
	///  查询
	$('#find').bind("click",findNodeist);
	
		//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findNodeist(); //调用查询
        }
    });
    
     //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findNodeist(); //调用查询
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
function createFrame(tabUrl, NodeDr){
	tabUrl = tabUrl.split("?")[0];
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?NodeDr='+ NodeDr +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

/// 查询
function findNodeist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#nodelist').datagrid('load',{params:params}); 
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })