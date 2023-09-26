function InitviewMain(){
	var obj = new Object();
	obj.CurrentGrid = '';
	
	obj.panelToolBar = new Ext.Panel({
		id : 'panelToolBar'
		,height : 30
		,buttonAlign : 'left'
		,region : 'north'
		,frame : true
		,items:[
		]
	});
	obj.panelCenter = new Ext.Panel({
		id : 'panelCenter'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'fit'
		,tbar:[
			{
				xtype:'button',
				id:"AllDoc",
				text:'首页'	
			},
			{
				xtype:'button',
				id:"DocPathWay",
				text:''	
			}
		]
		
	});
	obj.viewMain = new Ext.Viewport({
		id : 'viewMain'
		,layout : 'border'
		,renderTo : document.body
		,items:[
			//obj.panelToolBar
			obj.panelCenter
		]
	});
	
	InitviewMainEvent(obj);
	Ext.getCmp('AllDoc').on('click',obj.GetAllDoc,obj)
	Ext.getCmp('DocPathWay').on('click',obj.GetDocPathWay,obj)
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

