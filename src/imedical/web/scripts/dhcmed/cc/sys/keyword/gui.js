function InitviewScreen(){
	var obj = new Object();
	
	// ���ݲ�ѯ������ѯ�ؼ��ֱ��е���Ϣ
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'TimeLineCode', mapping: 'TimeLineCode'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,height : 80
		,frame:'ture'
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			//new Ext.grid.RowNumberer()
			{header: 'ID', width: 50, dataIndex: 'rowid', sortable: true}
			,{header: '����', width: 150, dataIndex: 'Code', sortable: true}
			,{header: 'ʱ�����������', width: 150, dataIndex: 'TimeLineCode', sortable: true}
			,{header: '����', width: 250, dataIndex: 'Description', sortable: true}
			,{header: '��Ч', width: 100, dataIndex: 'IsActive', sortable: true, 
					renderer : function(v)
					{
						if(v == "1")
							return "<IMG SRC='../scripts/dhcmed/img/accept.png' height='16px' width='16px'/>";
						else
							return "";	
					}
				}
			,{header: '��ע', width: 100, dataIndex: 'Resume', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,width : 50
		,anchor : '100%'
		,fieldLabel : '����'
	});
	obj.txtTimeLineCode = new Ext.form.TextField({
		id : 'txtTimeLineCode'
		,width : 50
		,anchor : '100%'
		,fieldLabel : 'ʱ�����������'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,width : 50
		,anchor : '100%'
		,fieldLabel : '����'
	});

	obj.cboIsActive = new Ext.form.Checkbox({
		id : 'cboIsActive'
		,width : 50
		,anchor : '100%'
		,fieldLabel : '��Ч'
	});
	
	obj.ResumeText = new Ext.form.TextField({
		id : 'ResumeText'
		,width : 50
		,anchor : '100%'
		,fieldLabel : '��ע'
		
	});

	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});

	obj.KeywordInfo = new Ext.form.FormPanel({
		id : 'obj.KeywordInfo'
		,buttonAlign : 'center'
		,height: 140
		,labelWidth : 290
		,labelAlign : 'right'
		,anchor : '95%'
		//,title : '�ؼ��ֱ༭'
		,region : 'south'
		,layout : 'form'
		,frame:'ture'
		,items:[
			{
				layout : 'column',
				items : [
					{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtCode]
					},{
						width:240
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 110
						,items: [obj.txtTimeLineCode]
					},{
						columnWidth:1
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtDesc]
					},{
						width:100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboIsActive]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						columnWidth:1
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.ResumeText]
					}
				]
			}
		]
		,bbar : ['<b>ע�ͣ�ʱ�����������������Χ(101-199)�����������������Χ���޸ļ�عؼ��֣���Ҫͬ���޸�ʱ�������</b>','->','...']
		,buttons : [
			obj.btnSave
		]
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.gridResult
			,obj.KeywordInfo
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Sys.KeywordSrv';
		param.QueryName = 'QryAll';
		param.ArgCnt =0;
	});
	obj.gridResultStore.load({});
	
	InitviewScreenEvent(obj);
	//�¼���������
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.gridResult.on("rowdblclick", obj.gridResult_rowdblclick, obj);
	obj.gridResult.on("rowclick", obj.gridResult_rowclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}  
	
	
	
	
	
	
	