function InitOpaInfoWindow(obj){
	obj.opaInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opaInfoStore = new Ext.data.Store({
		proxy: obj.opaInfoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opaInfoId'   
		}, 
		[
			{name:'opaInfoId',mapping: 'opaInfoId'}
			,{name: 'opaInfo', mapping: 'opaInfo'}
		])
	});
	obj.opaInfoStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'FindOpaInfo';
		param.Arg1 = obj.infoAnciId;
		param.Arg2 = obj.infoSearchLevel;
		param.Arg3 = obj.infoAnciiSub;
		param.Arg4 = obj.infoOpaId;
		param.ArgCnt = 4;
	});
	var tpl = new Ext.XTemplate(
		'<div class="thumb-wrap">',
		'<tpl for=".">',
			'<p><span style="color:#FF0000;">{opaInfoId}</span>:{opaInfo}</p><br>',
		'</tpl>',
		'</div>',
		'<div class="x-clear"></div>'
	);
	obj.opaInfoPanel = new Ext.Panel({
		id : 'opaInfoPanel'
		,frame:true
		,layout:'fit'
		,title:'明细'
		,autoScroll:true
		,items: new Ext.DataView({
			store: obj.opaInfoStore
			,tpl: tpl
			,autoHeight:true
			,multiSelect: true
			//,overClass:'x-view-over'
			,itemSelector:'div.thumb-wrap'
			,emptyText: '无明细信息'
		})
	});
	obj.winScreenOpaInfo = new Ext.Window({
		id : 'winScreenOpaInfo'
		,height : 300
		,buttonAlign : 'center'
		,width : 365
		,title : '查询项目信息明细'
		,modal : false
		,draggable : true
		,resizable : true
		,closeAction : 'hide'
		,layout : 'fit'
		,items:[
			obj.opaInfoPanel
		]
	});

	obj.ShowOpaInfoWindow = function(anciId,searchLevel,anciiSub,opaId)
	{
		obj.infoAnciId=anciId;
		obj.infoSearchLevel=searchLevel;
		obj.infoAnciiSub=anciiSub;
		obj.infoOpaId=opaId;
		obj.opaInfoStore.load({});
		obj.opaInfoPanel.setTitle(obj._DHCANOPStat.GetOpaInfoTitle(anciId,anciiSub));
		obj.winScreenOpaInfo.show();
	}
}
function ShowOpaInfo(anciId,searchLevel,anciiSub,opaId)
{
	objControlArry['ViewScreen'].winScreenOpaInfo.setAnimateTarget("a_"+anciId+"_"+searchLevel+"_"+anciiSub+"_"+opaId);
	objControlArry['ViewScreen'].ShowOpaInfoWindow(anciId,searchLevel,anciiSub,opaId);
}