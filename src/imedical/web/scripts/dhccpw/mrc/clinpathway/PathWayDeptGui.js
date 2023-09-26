
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
		/*Modified By LiYang 2011-02-26 �˳������������ṹǰд�ģ����Ի���������鱨����������  23���ٴ�·��ά��--�ٴ�·���ֵ�-�½����ٴ�·���ڿ��ҳ���·�����ʱ������
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
	
	obj.AllPathWayCheckCol = new Ext.grid.CheckColumn({header:'ѡ��', dataIndex: 'checked', width: 50 });
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
			{header: '·���б�', width: 200, dataIndex: 'Desc', sortable: true} //Modified By LiYang 2011-02-26
		]
		,plugins : obj.AllPathWayCheckCol
	});
	
	obj.CPWKey = new Ext.form.TextField({
			id : 'CPWKey'
			,fieldLabel : '�ؼ���'
			,emptyText:"����������ؼ���"
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
		,fieldLabel : '·������'
		,emptyText:"ѡ��·������"
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
		//,tabTip : '���'
		//,text : '���'             //by wuqk 2011-07-21
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
		//,text : '�Ƴ�'
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
	obj.DeptPathStoreCheckCol = new Ext.grid.CheckColumn({header:'ѡ��', dataIndex: 'checked', width: 50 });
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
			{header: '�����ҳ���·��', width: 200, dataIndex: 'desc', sortable: true}
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
		,fieldLabel : '����'
		,emptyText:"��ѡ�����"
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
		title:"���ҳ����ٴ�·��ά��"
		,height : 442
		,buttonAlign : 'center'
		,width : 646
		,columnWidth : .4
		,modal:true
		,resizable:false
		,layout : 'fit' //Modified By LiYang 2011-04-08
		,items:[
			//Add By LiYang 2011-02-26 �޸�Bug:6--�ٴ�·��ά��-���ҳ����ٴ�·��ά��-������Ӳ�����ʾ��Ϣ
			/*{
				xtype : 'panel',
				id : 'lblNotice',
				frame : true,
				html : '<B>ʹ�÷�����1.ѡ�п���  2.ѡ����Ҫָ�ɵ�"�ٴ�·��" 3.��"���"��ť</B>'
			},*/
			obj.Panel22
		]
	});
	
	/******************************֧����ק**********************************************/
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
	                      
	                      //��obj.DeptPathGrid���Ƴ��ٴ�·��
	                      return true
	              }
	      });
	      
		var secondGridDropTargetEl = obj.DeptPathGrid.getEl();
		
		var secondGridDropTarget = new Ext.dd.DropTarget(secondGridDropTargetEl, {
	              ddGroup    : 'secondGridDDGroup',
	              notifyDrop : function(ddSource, e, data){
	                      var records =  ddSource.dragData.selections;
	                      //��obj.DeptPathGrid����Ӽ�¼
	                      obj.ToDeptPathGrid(records)
	                      return true
	              }
	      }); 
	})
	*/
	/******************************֧����ק**********************************************/	
	
	obj.AllPathWayProxy.on('beforeload', function(objProxy, param){
			/*Modified By LiYang 2011-02-26 �޸�Bug:6--�ٴ�·��ά��-���ҳ����ٴ�·��ά��-������Ӳ�����ʾ��Ϣ
			param.ClassName = 'web.DHCCPW.MRC.CliPathWay';
			param.QueryName = 'GetPathWays';
			*/
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.Arg1="N";
			param.Arg2="Y";      //add by wuqk 2011-11-17 ֻ��ʾ��Ч·��
			param.Arg3=obj.CPWKey.getValue();
			var DeptComValue = obj.DeptCom.getValue();
			if (DeptComValue=="") { DeptComValue = "Null"; }
			param.Arg4=DeptComValue;
			param.Arg5=obj.CPWType.getValue();
			param.ArgCnt = 5;    //add by wuqk 2011-07-21 ���˲���֢
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
	
	//�¼��������
	obj.LoadEvent();
	return obj;
}

