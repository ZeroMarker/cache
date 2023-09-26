function InitViewScreen(){
    var obj=new Object();
	obj.CancelReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CancelReasonStore = new Ext.data.Store({
	    proxy : obj.CancelReasonStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[
		    
			{name:'Id',mapping:'Id'}
			,{name:'Desc',mapping:'Desc'}
		])
	
	});
	obj.CancelReason = new Ext.form.ComboBox({
	    id : 'CancelReason'
		,store : obj.CancelReasonStore
		,minChars : 1
		,value : ''
		,displayField : 'Desc'
		,fieldLabel : '撤销原因'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '85%'
	});
	obj.CancelReasonStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPCancelOper';
		    param.QueryName = 'FindCancelReason';
	    	param.ArgCnt = 0;
	    });
	obj.CancelReasonStore.load();
	
	 obj.Panel1=new Ext.Panel({
	    id:'Panel1'
	    ,columnWidth:.9
	    ,layout:'form'
	    ,items:[
	    	obj.CancelReason
	    ]
    });
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,labelAlign:'right'
		,labelWidth : 80
		,layout : 'column'
		,items:[
			obj.Panel1
		]
	});
	obj.btnUpdate = new Ext.Button({
	    id : 'btnUpdate'
		,text : '更新'
		,width:76
		,iconCls : 'icon-updateSmall'
		,anchor :'95%'
	});
	obj.btnClose = new Ext.Button({
	    id : 'btnClose'
		,text : '关闭'
		,width:76
		,iconCls : 'icon-close'
		,anchor :'95%'
	});

	obj.Panelbt1 = new Ext.Panel({
	    id : 'Panelbt1'
		,buttonAlign : 'center'
		,columnWidth : .4
		,items : [
			obj.btnUpdate
		]
	});
	obj.Panelbt2 = new Ext.Panel({
	    id : 'Panelbt2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,items : [
			obj.btnClose
		]
	});
	obj.Panelbt3 = new Ext.Panel({
	    id : 'Panelbt3'
		,columnWidth : .1
		,width:15
		,items : [
			
		]
	});
	obj.Panelbt4 = new Ext.Panel({
	    id : 'Panelbt4'
		,columnWidth : .1
		,width:20
		,items : [
			
		]
	});
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,align:'center'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
		]
        ,buttons:[
        obj.Panelbt3
    	,obj.Panelbt1
		,obj.Panelbt4
		,obj.Panelbt2
        
       ]
	});
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 40
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 100
		,title : '<span style=\'font-size:14px;\'>撤销手术</span>'
		,region : 'center'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.buttonPanel
		]
    });
		obj.winScreen = new Ext.Viewport({
		id : 'winScreen'
		,layout : 'border'
		,items:[
			 obj.functionPanel
		]
	});

	
	InitViewScreenEvent(obj);

	obj.btnUpdate.on('click',obj.btnUpdate_click,obj);
	obj.btnClose.on('click',obj.btnClose_click,obj);
	
	obj.LoadEvent(arguments);
	return obj;
}
