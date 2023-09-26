/*!
 * ��д����:2010-04-27
 * ���ߣ������
 * ˵�����ٴ�·����ά������
 * ���ƣ�EditPathWay.js
 */
function EditPathWay(WayRowid){
	var obj = new Object();
	obj.pathWayRowid=""
	obj.updateType=""
	//obj.pageSize=50
	obj.PathWayStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.PathWayStore = new Ext.data.Store({
		proxy: obj.PathWayStoreProxy,
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
			,{name: 'type', mapping: 'type'}
			,{name: 'typeDesc', mapping: 'typeDesc'}
			,{name: 'cost', mapping: 'cost'}
			,{name: 'CPWDays', mapping: 'CPWDays'}
			,{name: 'CPWICD', mapping: 'CPWICD'}
			,{name: 'CPWLabel', mapping: 'CPWLabel'}
		])
	});
	obj.PathWayGrid = new Ext.grid.GridPanel({
		id : 'PathWayGrid'
		,store : obj.PathWayStore
		,buttonAlign : 'center',
		region:"center"
		,height : 270
		,width:590
		,columns: [
			{header: '����', width: 80, dataIndex: 'code', sortable: true}
			,{header: '����', width: 200, dataIndex: 'desc', sortable: true}
			,{header: '�����־', width: 50, dataIndex: 'active', sortable: true}
			,{header: '��ʼ����', width: 80, dataIndex: 'dateFrom', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'dateTo', sortable: true}
			,{header: '����', width: 100, dataIndex: 'typeDesc', sortable: true}
			,{header: '�ο�����', width: 80, dataIndex: 'cost', sortable: false}
			,{header: '�ο�����', width: 60, dataIndex: 'CPWDays', sortable: false}
			,{header: '׼��ICD', width: 60, dataIndex: 'CPWICD', sortable: false}
			,{header: '׼����ʾ', width: 60, dataIndex: 'CPWLabel', sortable: false}
		]
		/*,bbar: new Ext.PagingToolbar({
			pageSize : obj.pageSize,
			store : obj.PathWayStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})*/

});
	obj.PathWayLab1 = new Ext.form.Label({
		id : 'PathWayLab1'
		,height : 10
		,width : 100
		,anchor : '99%'
});
	obj.PathCode = new Ext.form.TextField({
		id : 'PathCode'
		,width : 200
		,anchor : '99%'
		,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '����'
});
	obj.PathDesc = new Ext.form.TextField({
		id : 'PathDesc'
		,width : 200
		,anchor : '99%'
		,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '����'
});
	obj.PathActive = new Ext.form.ComboBox({
		id:'cpwActive'
		,fieldLabel:"�����־"
		,width:200
		,anchor : '99%'
		,msgTarget:'under'
		,validationEvent: false
    	,validateOnBlur: false
		,displayField:'active'
		,valueField:'active'
		,editable:false
		,triggerAction: 'all'
		,mode:'local'
    	,store:new Ext.data.ArrayStore({
	      	fields:['active']
	      	,data:	[[''],['Yes'],['No']]
      	})
	});
	obj.PathDateFrom = new Ext.form.DateField({
		id : 'PathDateFrom'
		,fieldLabel : '��ʼ����'
		,allowBlank:false
		,validateOnBlur: false
		,format:"Y-m-d"
		,width : 200
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
	});
	obj.PathDateTo = new Ext.form.DateField({
		id : 'PathDateTo'
		,fieldLabel : '��������'
		,format:"Y-m-d"
		,width : 200
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
	});
	obj.PathCost = new Ext.form.TextField({
		id : 'PathCost'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '�ο�����'
	});
	obj.PathDays = new Ext.form.TextField({
		id : 'PathDays'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '�ο�����'
	});
	obj.PathICD = new Ext.form.TextField({
		id : 'PathICD'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '׼��ICD'
	});
	obj.PathLabel = new Ext.form.TextField({
		id : 'PathLabel'
		,width : 200
		,anchor : '99%'
		//,allowBlank:false
		,validateOnBlur: false
		,fieldLabel : '׼����ʾ'
	});
	obj.PathTypeComStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathTypeComStore = new Ext.data.Store({
		proxy: obj.PathTypeComStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			id: 'Rowid'
		}, 
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'code'}
			,{name: 'Desc', mapping: 'desc'}
		])
	});
	obj.PathTypeCom = new Ext.form.ComboBox({
		id:'com_pathType',
		width:200,
		anchor : '99%',
		store:obj.PathTypeComStore,
		displayField:'Desc',
		fieldLabel:"����",
		triggerAction:'all',
		valueField:'Rowid',
		editable:false,
		pageSize:15
		//forceSelection:true,
		//selectOnfocus:true,
		//validationEvent:false,
		//validateOnBlur:false,
		//msgTarget:'under',
		//mode:'remote'
	});
	
	obj.PathAdd = new Ext.Button({
		id : 'PathAdd'
		,text : '���',
		iconCls:"icon-add"
	});
	
	obj.PathUpdate = new Ext.Button({
		id : 'PathUpdate'
		,text : '����',
		iconCls:"icon-save"
	});
	
	obj.ClearBtn = new Ext.Button({
		id : 'Path_ClearBtn'
		,text : '���',
		iconCls:"icon-cancel"
	});
	
	obj.PathDelete = new Ext.Button({
		id : 'PathDelete'
		,text : 'ɾ��',
		iconCls:"icon-delete"
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,text : '��ѯ',
		iconCls:"icon-find"
	});

	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel4 = new Ext.Panel({
		id : 'SubPanel4'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .49
		,layout : 'form'
		,items:[
			obj.PathDateFrom
			,obj.PathDateTo
			,obj.PathCost
			,obj.PathDays
			,obj.PathLabel
		]
	});
obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .49
		,layout : 'form'
		,items:[
				obj.PathCode
				,obj.PathDesc
				,obj.PathActive
				,obj.PathTypeCom
				,obj.PathICD
		]
	});

obj.formPanel=new Ext.form.FormPanel({
					id : 'panelTitle'
					,buttonAlign : 'center'
					,labelWidth : 70
					,labelAlign : 'right'
					,height : 150
					,frame : true
					,layout:'column'
					,region : 'south'
					,items:[
						obj.SubPanel1
						,obj.SubPanel2
						,obj.SubPanel3
						,obj.SubPanel4
					]
				})

	obj.PathWayWin = new Ext.Window({
		id : 'PathWayWin'
		,height : 650
		,buttonAlign : 'center'
		,width : 900
		,title : '�ٴ�·��ά��'
		,layout : 'border'
		,closeAction: 'close',
		resizable:false
		,closable:true
		,modal: true
		,items:[
			obj.PathWayGrid,
			obj.formPanel
		]
		,buttons:[
			obj.btnQuery
			,obj.PathUpdate
			,obj.ClearBtn
			,obj.PathAdd
			,obj.PathDelete
			
		]
	});
	obj.PathWayStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.CliPathWay';
			param.QueryName = 'GetPathWays';
			param.Arg1=obj.PathTypeCom.getValue();
			param.ArgCnt = 1;
	});
	obj.PathWayStore.load({});
	obj.PathTypeComStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayType';
			param.QueryName = 'GetPathWayType';
			param.ArgCnt = 0;
	});
	obj.PathTypeComStore.load({});
	EditPathWayEvent(obj,WayRowid);
	
	//�¼��������
	obj.LoadEvent();
  
	return obj;
}

