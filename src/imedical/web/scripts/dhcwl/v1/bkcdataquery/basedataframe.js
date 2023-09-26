
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
			{text:'报表配置',id:'showRptCfg',selected:true},
			{text:'查询对象配置',id:'showQryObj'},
		],
		onClick:function(v){
			if (v.text=="报表配置") showRptCfg();
			else if (v.text=="查询对象配置") showQryObj();
		},
		onUnselect:function(v){},
		onSelect:function(v){}
	})
	
	showRptCfg();
}
$(initFrame);



