function InitViewScreen()
{
	var obj = new Object();
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '��ʼ����'
		,anchor : '95%'
	});	
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '��������'
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});
	obj.comOperStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperStatStore = new Ext.data.Store({
		proxy: obj.comOperStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	obj.comOperStat = new Ext.form.ComboBox({
		id : 'comOperStat'
		,store : obj.comOperStatStore
		,minChars : 1
		,displayField : 'tDesc'
		,fieldLabel : '����״̬'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOperStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'OpaStatus';
		param.ArgCnt = 1;
	});
	obj.comOperStatStore.load({});
	obj.comPatWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comPatWardStore = new Ext.data.Store({
		proxy: obj.comPatWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'desc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'rw', mapping: 'rw'}
		])
	});
	obj.comPatWard = new Ext.form.ComboBox({
		id : 'comPatWard'
		,store : obj.comPatWardStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '���˲���'
		,valueField : 'rw'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comPatWardStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCLCNUREXCUTE';
		param.QueryName = 'GetWard';
		param.Arg1 = obj.comPatWard.getRawValue();
		param.ArgCnt = 1;
	});
	obj.comPatWardStore.load({});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.comOperStat
			,obj.comPatWard
		]
	});
	obj.txtMedCareNo = new Ext.form.TextField({
		id : 'txtMedCareNo'
		,fieldLabel : '������'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.comOpRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpRoomStore = new Ext.data.Store({
		proxy: obj.comOpRoomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'oprId', mapping: 'oprId'}
			,{name: 'oprDesc', mapping: 'oprDesc'}
			,{name: 'oprCode', mapping: 'oprCode'}
		])
	});
	obj.comOpRoom = new Ext.form.ComboBox({
		id : 'comOpRoom'
		,store : obj.comOpRoomStore
		,minChars : 1
		,value:''
		,displayField : 'oprDesc'
		,fieldLabel : '������'
		,valueField : 'oprId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOpRoomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindAncOperRoom';
		param.Arg1 = obj.comOpRoom.getRawValue();		
		param.Arg2 = '';
		param.Arg3 = 'OP^OUTOP^EMOP';
		param.Arg4 = '';
		param.Arg5 = ''
		param.Arg6 = 'T';
		param.Arg7 = '';
		param.ArgCnt = 7;
	});
	obj.comOpRoomStore.load({});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
			,obj.comOpRoom
		]
	});
	obj.txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '�ǼǺ�'
		,anchor : '95%'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
		,fieldLabel : 'opaId'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtRegNo
			,obj.opaId
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '��ѯ'
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,text : '����'
	});
	obj.schSubChildPl = new Ext.Panel({
		id : 'schSubChildPl'
		,buttonAlign : 'left'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		]
		,buttons:[
			obj.btnSch
			,obj.btnExport
		]
	});
	obj.chkFormPanel = new Ext.form.FormPanel({
		id : 'chkFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 48
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.schSubChildPl
		]
	});
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 142
		,title : '����ҩ���ղ�ѯ'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.chkFormPanel
		]
	});
	
	//ҩƷ����
	obj.DrugListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
	}));
	obj.DrugListStore = new Ext.data.Store({
		proxy: obj.DrugListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'drugId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'drugId', mapping: 'drugId'}
			,{name: 'drugDesc', mapping: 'drugDesc'}
			,{name: 'Specification', mapping: 'Specification'}
			,{name: 'Unit', mapping: 'Unit'}
			,{name: 'orderdoctor', mapping: 'orderdoctor'}
		])
	});
	
	
	//ִ����/������/������
		obj.NurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.NurseStore = new Ext.data.Store({
		proxy: obj.NurseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opaId'
		}, 
	    [
			{name: 'opdate', mapping : 'opdate'}
			,{name: 'comOpRoom', mapping: 'comOpRoom'}
			,{name: 'regNo', mapping : 'regNo'}
			,{name: 'patName', mapping : 'patName'}
			,{name: 'sex', mapping : 'sex'}
			,{name: 'age', mapping: 'age'}
			,{name: 'PDVAnumber', mapping : 'PDVAnumber'}
			,{name: 'diag', mapping: 'diag'}
			,{name: 'DrugDesc', mapping: 'DrugDesc'}
			,{name: 'Specification', mapping: 'Specification'}
			,{name: 'Unit', mapping: 'Unit'}
			,{name: 'Quantity', mapping: 'Quantity'}
			,{name: 'BatchNo', mapping: 'BatchNo'}
			,{name: 'orderdoctor', mapping: 'orderdoctor'}
			,{name: 'usecount', mapping: 'usecount'}
			,{name: 'DisposalMeasures', mapping: 'DisposalMeasures'}
			,{name: 'Handler', mapping: 'Handler'}
			,{name: 'Reviewer', mapping: 'Reviewer'}
			,{name: 'Recipient', mapping: 'Recipient'}
			,{name: 'Note', mapping: 'Note'}
			,{name: 'opaId', mapping: 'opaId'}
		])
	});
	  obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,height : 450
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,obj.csm=new Ext.grid.CheckboxSelectionModel({ header:''})
		,{header: 'ʹ������', width: 100, dataIndex: 'opdate', sortable: true}
		,{header: '������', width: 80, dataIndex: 'comOpRoom', sortable: true}
		,{header: '�����ǼǺ�', width: 100, dataIndex: 'regNo', sortable: true}
		,{header: '��������', width: 80, dataIndex: 'patName', sortable: true}
		,{header: '�Ա�', width: 40, dataIndex: 'sex', sortable: true}
		,{header: '����', width:50, dataIndex: 'age', sortable: true}
		,{header: '���֤���', width: 160, dataIndex: 'PDVAnumber', sortable: true}
		,{header: '�ٴ����', width: 160, dataIndex: 'diag', sortable: true}
		,{header: 'ҩƷ����'
			, width: 160
				, dataIndex: 'DrugDesc'
				, sortable: true
				,editor: new Ext.form.ComboBox({
					id:'scrLovCombo'
      			    , minChars : 1
					,displayField : 'drugDesc'
					,store : obj.DrugListStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'drugId'
					,mode: 'local'
					,lazyRender : true
		            ,selectOnFocus:false
					,forceSelection : false
					,resizable:false 
          	})
          ,renderer: function(value,metadata,record){
					var index = obj.DrugListStore.find('drugId',value);
					if(index!=-1)
					{  
						record.data.Specification=obj.DrugListStore.getAt(index).data.Specification;
						record.data.Unit=obj.DrugListStore.getAt(index).data.Unit;
						record.data.orderdoctor=obj.DrugListStore.getAt(index).data.orderdoctor;
						return obj.DrugListStore.getAt(index).data.drugDesc;
					}
					return value;
        	}
		}
		,{header: '���', width: 40, dataIndex: 'Specification', sortable: true}
		,{header: '��λ', width: 40, dataIndex: 'Unit', sortable: true}
		,{header: '����', width: 40, dataIndex: 'Quantity', sortable: true,editor: new Ext.form.TextField}
		,{header: '����', width: 100, dataIndex: 'BatchNo', sortable: true,editor: new Ext.form.TextField}
		,{header: '����ҽʦ', width: 80, dataIndex: 'orderdoctor', sortable: true}
		,{header: '��ҩ��', width: 80, dataIndex: 'usecount', sortable: true,editor: new Ext.form.TextField}
		,{header: '����ҩҺ���ô�ʩ', width: 120, dataIndex: 'DisposalMeasures', sortable: true,editor: new Ext.form.TextField}
		,{header: 'ִ����'
			, width: 80
				, dataIndex: 'Handler'
				, sortable: true
				,editor: new Ext.form.ComboBox({
      			    minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.NurseStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,lazyRender : true
		            ,selectOnFocus:false
					,forceSelection : false
					,resizable:false 
          	})
          ,renderer: function(value,metadata,record){
					var index = obj.NurseStore.find('ctcpId',value);
					if(index!=-1)
					{  
						return obj.NurseStore.getAt(index).data.ctcpDesc;
					}
					return value;
        	}
		}
		,{header: '������'
			, width: 80
				, dataIndex: 'Reviewer'
				, sortable: true
				,editor: new Ext.form.ComboBox({
      			    minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.NurseStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,lazyRender : true
		            ,selectOnFocus:false
					,forceSelection : false
					,resizable:false 
          	})
          ,renderer: function(value,metadata,record){
					var index = obj.NurseStore.find('ctcpId',value);
					if(index!=-1)
					{  
						return obj.NurseStore.getAt(index).data.ctcpDesc;
					}
					return value;
        	}
		}
		,{header: '�հ�곻���(������)'
			, width: 120
				, dataIndex: 'Recipient'
				, sortable: true
				,editor: new Ext.form.ComboBox({
      			    minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.NurseStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,lazyRender : true
		            ,selectOnFocus:false
					,forceSelection : false
					,resizable:false 
          	})
          ,renderer: function(value,metadata,record){
					var index = obj.NurseStore.find('ctcpId',value);
					if(index!=-1)
					{  
						return obj.NurseStore.getAt(index).data.ctcpDesc;
					}
					return value;
        	}
		}
		,{header: '��ע', width: 100, dataIndex: 'Note', sortable: true,editor: new Ext.form.TextField}
		,{header: 'opaId', width: 80, dataIndex: 'opaId', sortable: true,hidden:true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 300,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {1}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	var sessLoc=session['LOGON.CTLOCID'];
	obj.DrugListStoreProxy.on('beforeload', function(objProxy, param){
	    param.ClassName = 'web.DHCANControlledDrug';
	    param.QueryName = 'FindDrugList';
	    param.Arg1 = obj.opaId.getValue();
		param.ArgCnt = 1;
	});
	obj.NurseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'FindCtcp';
			param.Arg1 = '';
			param.Arg2 = 'OP^OUTOP^EMOP';
			param.Arg3 = sessLoc;
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'N';
			param.Arg7 = 'N';
			param.ArgCnt = 7;
	});
	obj.NurseStore.load();
	Ext.getCmp('scrLovCombo').on("expand",scrLovCom_expand)
	Ext.getCmp('scrLovCombo').on("focus",scrLovCom_focus)
	function scrLovCom_expand(comb)
	{ 
	    comb.setWidth(160);
	}
	function scrLovCom_focus()
	{
	    obj.DrugListStore.load()
	}
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '����ҩ���ղ�ѯ���'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,tbar:obj.tb
		,items:[
			obj.Panel23
			,obj.Panel25
			,obj.retGridPanel
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.schPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	//�¼��������
	obj.txtMedCareNo.on("keyup", obj.txtMedCareNo_keyup, obj);
	obj.dateFrm.on("blur",obj.date_blur,obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnExport.on("click", obj.btnExport_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.retGridPanel.on("validateedit",obj.retGridPanel_validateedit,obj);
	obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
	obj.LoadEvent(arguments);
	return obj;
}
