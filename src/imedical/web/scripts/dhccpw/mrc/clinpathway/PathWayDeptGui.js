
function PathWayDept(){
	var obj = new Object();
	obj.addDeptPath=[]
	obj.deleteDeptPath=[]
	obj.AllPathWayProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AllPathWayStore = new Ext.data.Store({
		proxy: obj.AllPathWayProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		/*Modified By LiYang 2011-02-26 此程序是在升级结构前写的，所以会引起测试组报告遇到问题  23。临床路径维护--临床路径字典-新建的临床路径在科室常用路径添加时看不到
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'active', mapping: 'active'}
			,{name: 'dateFrom', mapping: 'dateFrom'}
			,{name: 'dateTo', mapping: 'dateTo'}
			,{name: 'type', mapping: 'type'}
			,{name: 'typeDesc', mapping: 'typeDesc'}
		])*/
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'CurrVersion', mapping: 'CurrVersion'}
		])
	});
	
	obj.AllPathWayCheckCol = new Ext.grid.CheckColumn({header:'选择', dataIndex: 'checked', width: 50 });
	obj.AllPathWayGrid = new Ext.grid.GridPanel({
		id : 'AllPathWayGrid'
		,ddGroup: 'secondGridDDGroup'
		,enableDragDrop   : false //Modified By LiYang 2011-04-08
		,store : obj.AllPathWayStore
		,stripeRows: true
		,buttonAlign : 'center'
		,height : 300
		,region : 'center'
		,viewConfig: {
			forceFit: true
		}
		,columns: [
			//obj.AllPathWayCheckCol
			{header: '路径列表', width: 200, dataIndex: 'Desc', sortable: true} //Modified By LiYang 2011-02-26
		]
		,plugins : obj.AllPathWayCheckCol
	});
	
	obj.CPWKey = new Ext.form.TextField({
			id : 'CPWKey'
			,fieldLabel : '关键字'
			,emptyText:"请输入检索关键字"
			,width : 120
	});
	obj.CPWTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CPWTypeStore = new Ext.data.Store({
		proxy: obj.CPWTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.CPWType = new Ext.form.ComboBox({
		id : 'CPWType'
		,minChars : 1
		,store : obj.CPWTypeStore
		,valueField : 'Rowid'
		,fieldLabel : '路径类型'
		,emptyText:"选择路径类型"
		,displayField : 'desc'
		,triggerAction : 'all'
	});
	obj.Panel34 = new Ext.Panel({
		id : 'Panel34'
		,height : 55
		,width:200
		,buttonAlign : 'center'
		,region : 'north'
		,layout:'form'
		,labelWidth:80
		,labelAlign : 'right'
		,items:[
			obj.CPWType
			,obj.CPWKey
		]
	});
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,height : 500
		,buttonAlign : 'center'
		//,width : 280
		//,region : 'west'
		,layout : 'border'
		//frame:true
		,columnWidth : 0.45
		,items:[
			obj.AllPathWayGrid
			,obj.Panel34
		]
	});
	obj.Panel35 = new Ext.Panel({
		id : 'Panel35'
		,height : 180
		,width : 50
	});
	obj.BtnRight = new Ext.Button({
		id : 'BtnRight'
		,height : 30
		//,width : 50
		,anchor : '95%'
		//,tabTip : '添加'
		//,text : '添加'             //by wuqk 2011-07-21
		,iconCls:'icon-moveright'
	});
	obj.Panel37 = new Ext.Panel({
		id : 'Panel37'
		,height : 50
		,width : 50
	});
	obj.BtnLeft = new Ext.Button({
		id : 'BtnLeft'
		,height : 30
		,anchor : '95%'
		//,width : 50
		//,text : '移除'
		,iconCls:'icon-moveleft'
	});
	obj.Panel24 = new Ext.Panel({
		id : 'Panel24'
		,columnWidth : 0.1    //by wuqk  2011-07-21
		,layout : 'form'
		//,buttonAlign : 'center'
		//,region : 'center'
		,items:[
			obj.Panel35
			,obj.BtnRight
			,obj.Panel37
			,obj.BtnLeft
		]
	});
	
	obj.DeptPathStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DeptPathStore = new Ext.data.Store({
		proxy: obj.DeptPathStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'active', mapping: 'active'}
			,{name: 'dateFrom', mapping: 'dateFrom'}
			,{name: 'dateTo', mapping: 'dateTo'}
			,{name: 'typeDesc', mapping: 'typeDesc'}
		])
	});
	obj.DeptPathStoreCheckCol = new Ext.grid.CheckColumn({header:'选择', dataIndex: 'checked', width: 50 });
	obj.DeptPathGrid = new Ext.grid.GridPanel({
		id : 'DeptPathGrid1'
		,store : obj.DeptPathStore,
		ddGroup: 'firstGridDDGroup',
		enableDragDrop   : false, //Modified By LiYang 2011-04-08
		stripeRows: true
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			//obj.DeptPathStoreCheckCol
			{header: '本科室常用路径', width: 200, dataIndex: 'desc', sortable: true}
		]
		,plugins : obj.DeptPathStoreCheckCol
	});
	obj.DeptComStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DeptComStore = new Ext.data.Store({
		proxy: obj.DeptComStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.DeptCom = new Ext.form.ComboBox({
		id : 'DeptCom1'
		,minChars : 1
		,store : obj.DeptComStore
		,valueField : 'Rowid'
		,fieldLabel : '科室'
		,emptyText:"请选择科室"
		,displayField : 'desc'
		,triggerAction : 'all'
	});
	
	obj.FormPanel31 = new Ext.form.FormPanel({
		id : 'FormPanel31'
		,height : 30
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,region : 'north'
		,items:[
			obj.DeptCom
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,columnWidth : 0.45
		,buttonAlign : 'center'
		//,width : "30"
		,height : 500 
		//,autoHeight : true
		//,region : 'east'
		,layout : 'border'
		,items:[
			obj.DeptPathGrid
			,obj.FormPanel31
		]
	});
	obj.Panel22 = new Ext.Panel({
		id : 'Panel22'
		//,height : 400
		//,width : 630
		,buttonAlign : 'center'
		,frame : true
		,layout : 'column'
		,items:[
			obj.Panel23
			,obj.Panel24
			,obj.Panel25
		]
	});
	obj.PathDeptWin = new Ext.Viewport({
		id : 'PathDeptWin',
		title:"科室常用临床路径维护"
		,height : 442
		,buttonAlign : 'center'
		,width : 646
		,columnWidth : .4
		,modal:true
		,resizable:false
		,layout : 'fit' //Modified By LiYang 2011-04-08
		,items:[
			//Add By LiYang 2011-02-26 修复Bug:6--临床路径维护-科室常用临床路径维护-建议添加操作提示信息
			/*{
				xtype : 'panel',
				id : 'lblNotice',
				frame : true,
				html : '<B>使用方法：1.选中科室  2.选中需要指派的"临床路径" 3.按"添加"按钮</B>'
			},*/
			obj.Panel22
		]
	});
	
	/******************************支持拖拽**********************************************/
	/*
	obj.PathDeptWin.on('show',function(){
		var firstGridDropTargetEl =  obj.AllPathWayGrid.getEl();
		var firstGridDropTarget = new Ext.dd.DropTarget(firstGridDropTargetEl, {
	              ddGroup    : 'firstGridDDGroup',
	              notifyDrop : function(ddSource, e, data){
	                      var records =  ddSource.dragData.selections;
	                      Ext.each(records, function(item){
	                      	var pathRowid=item.get('Rowid')
	                      	var delVal=obj.deleteDeptPath(obj.DeptCom.getValue(),pathRowid);
	                      	if(delVal){  
	                      		ddSource.grid.store.remove(item)
	                      	}
	                      });
	                      
	                      //从obj.DeptPathGrid里移出临床路径
	                      return true
	              }
	      });
	      
		var secondGridDropTargetEl = obj.DeptPathGrid.getEl();
		
		var secondGridDropTarget = new Ext.dd.DropTarget(secondGridDropTargetEl, {
	              ddGroup    : 'secondGridDDGroup',
	              notifyDrop : function(ddSource, e, data){
	                      var records =  ddSource.dragData.selections;
	                      //向obj.DeptPathGrid里添加记录
	                      obj.ToDeptPathGrid(records)
	                      return true
	              }
	      }); 
	})
	*/
	/******************************支持拖拽**********************************************/	
	
	obj.AllPathWayProxy.on('beforeload', function(objProxy, param){
			/*Modified By LiYang 2011-02-26 修复Bug:6--临床路径维护-科室常用临床路径维护-建议添加操作提示信息
			param.ClassName = 'web.DHCCPW.MRC.CliPathWay';
			param.QueryName = 'GetPathWays';
			*/
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.Arg1="N";
			param.Arg2="Y";      //add by wuqk 2011-11-17 只显示有效路径
			param.Arg3=obj.CPWKey.getValue();
			var DeptComValue = obj.DeptCom.getValue();
			if (DeptComValue=="") { DeptComValue = "Null"; }
			param.Arg4=DeptComValue;
			param.Arg5=obj.CPWType.getValue();
			param.ArgCnt = 5;    //add by wuqk 2011-07-21 过滤并发症
			//param.ArgCnt = 0;  //Modified By LiYang 2011-02-26
	});
	obj.AllPathWayStore.load({});
	obj.DeptPathStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.DeptPahtWay';
			param.QueryName = 'GetPathWays';
			param.Arg1 = obj.DeptCom.getValue();
			param.ArgCnt=1;
	});
	//obj.DeptPathStore.load({});
	obj.DeptComStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.DeptPahtWay';
			param.QueryName = 'GetDept';
			param.Arg1 = obj.DeptCom.getRawValue();
			param.Arg2 = 'E';	// Add by zhaoyu 2013-03-13
			param.Arg3 = '';	// Add by zhaoyu 2013-03-13
			param.ArgCnt=3;	// Modified by zhaoyu 2013-03-13 'param.ArgCnt=1' -> 'param.ArgCnt=3'
	});
	obj.DeptComStore.load({});
	
	obj.CPWTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayType';
			param.QueryName = 'GetPathWayType';
			param.Arg1 = obj.CPWType.getRawValue();
			param.ArgCnt=1;	
	});
	obj.CPWTypeStore.load({});
	PathWayDeptEvent(obj);
	obj.DeptCom.on('select',obj.SelectDept)
	obj.BtnRight.on('click',obj.BtnRightClick)
	obj.AllPathWayGrid.on('rowclick',obj.onRowClick)
	obj.DeptPathGrid.on('rowclick',obj.onRowClick_Dept)
	obj.BtnLeft.on('click',obj.BtnLeftClick)
	obj.CPWKey.on('specialKey',obj.CPWKey_specialKey,obj);
	obj.CPWType.on('select',obj.SelectCPWType)
	
	//事件处理代码
	obj.LoadEvent();
	return obj;
}

