function InitViewport1(){
	var EpisodeID=""
	var obj = new Object();
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.tplBaseInfo = new Ext.XTemplate(
			'<table border=.1 width=99% align=center>',
				'<tr>',
					"<td width=15%><font color='red'>*注意:该患者符合多条临床路径，请选择一条入径!</font></td>",
				'</tr>',

			'</table>');

	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,anchor : '95%'
		,text : '确认'
});
	obj.InCPWListStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.InCPWListStore = new Ext.data.Store({
		proxy: obj.InCPWListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CLPOSRowId', mapping: 'CLPOSRowId'}
			,{name: 'CLPOSDesc', mapping: 'CLPOSDesc'}
			,{name: 'ShootFlag', mapping: 'ShootFlag'}
		])
	});
	sm = new Ext.grid.CheckboxSelectionModel({header:'', width: 25, singleSelect:true})
	obj.InCPWList = new Ext.grid.GridPanel({
		id : 'EPDRepList'
		,store : obj.InCPWListStore
		,region : 'center'
		//,hideHeaders:true
		,buttonAlign : 'center'
		,sm:sm
		,anchor : "95%"
		,title : '符合路径列表'
		,columns: [
			sm
			,{header: '路径名称', width: 200, dataIndex: 'Desc', sortable: true}
			//,{header: '分支路径', width: 80, dataIndex: 'ShootFlag', sortable: true}
			//,{header: '治疗方案', width: 200, dataIndex: 'CLPOSDesc', sortable: true}
		]
		,buttons:[
			obj.BtnSave
		]});
	

	obj.GradePanle = new Ext.form.FormPanel({
		id : 'GradePanle'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 90
		,height : 50
		,region : 'north'
		,layout : 'column'
		,frame : true
		,items:[
			obj.tplBaseInfo
		]

	});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.GradePanle
			,obj.InCPWList
			//,obj.GradePanle
		]
	});
	obj.InCPWListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BuildSimpleJson';
			param.QueryName = 'BuildJosonQryByStr';
			param.Arg1 = CPWIDStr ;
			param.ArgCnt = 1;
	});
	obj.InCPWListStore.load({});
	InitViewport1Event(obj);
	//事件处理代码

  obj.LoadEvent(arguments);
  return obj;
}

