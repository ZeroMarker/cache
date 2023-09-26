/*
配液规则定义
liangqiang
2016.01.05
*/

$(function(){

	initTabs();

	$('#tt').tabs({ 
		border:false, 
		onSelect:function(title,index){ 
			RefTab(); 
		} 
	});


});

//初始化
function initTabs()
{

	var href="DHCST.PIVA.ADDBATTIME.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('时间规则',content);

	var href="DHCST.PIVA.SETFREQRULE.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('频次规则',content);

	var href="dhcst.piva.setwardbat.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('容积规则',content);

	var href="DHCST.PIVA.SETOTHRULE.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('其它规则',content);



}

//增加tab
function AddTab(text,content)
{
		$('#tt').tabs('add',{ 
		   title:text, 
		   closable:false,
		   border:false,
		   content:content
		 });
}

//刷新tab
function RefTab()
{
	var tab = $('#tt').tabs('getSelected');
	tab.panel('refresh');

}