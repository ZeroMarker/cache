/*
��Һ������
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

//��ʼ��
function initTabs()
{

	var href="DHCST.PIVA.ADDBATTIME.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('ʱ�����',content);

	var href="DHCST.PIVA.SETFREQRULE.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('Ƶ�ι���',content);

	var href="dhcst.piva.setwardbat.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('�ݻ�����',content);

	var href="DHCST.PIVA.SETOTHRULE.csp";
	var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	AddTab('��������',content);



}

//����tab
function AddTab(text,content)
{
		$('#tt').tabs('add',{ 
		   title:text, 
		   closable:false,
		   border:false,
		   content:content
		 });
}

//ˢ��tab
function RefTab()
{
	var tab = $('#tt').tabs('getSelected');
	tab.panel('refresh');

}