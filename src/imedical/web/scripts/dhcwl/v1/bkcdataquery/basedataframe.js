
	var showQryObj=function()
	{		
		$('#qryObj-addDlg').dialog('destroy');
		$('#qryObj-showItemDlg').dialog('destroy');
		url = "dhcwl/v1/bkcdataquery/qryobjmaintain.csp";
		$('#iframeContext').panel('open').panel('refresh',url);
	}

	var showRptCfg=function()
	{
		url = "dhcwl/v1/bkcdataquery/bdqbrowserpt.csp";
		//var content = '<iframe frameborder="0" src="/dthealth/web/csp/dhcwlredirect.csp?url='+url+'" style="width:100%;height:100%;"></iframe>';
		$('#iframeContext').panel('open').panel('refresh',url);
	}


var initFrame = function(){
	//showRptCfg();
	$("#frameToolBar").keywords({
		singleSelect:true,
		labelCls:'red',
		items:[
			{text:'��������',id:'showRptCfg',selected:true},
			{text:'��ѯ��������',id:'showQryObj'},
		],
		onClick:function(v){
			if (v.text=="��������") showRptCfg();
			else if (v.text=="��ѯ��������") showQryObj();
		},
		onUnselect:function(v){},
		onSelect:function(v){}
	})
	
	showRptCfg();
}
$(initFrame);



