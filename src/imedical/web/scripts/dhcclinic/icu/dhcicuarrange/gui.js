function InitViewScreen(){
	///alert(1);
	var obj = new Object();
	obj.startdate = new Ext.form.DateField({
		id : 'startdate'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel:'��ʼ����'
		,anchor : '95%'
	});  
	
	obj.enddate = new Ext.form.DateField({
		id : 'enddate'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel:'��������'
		,anchor : '95%'
	}); 
	 
	obj.Bedid = new Ext.form.TextField({
		id : 'Bedid'
		,hidden : true
    });	
    	
   	obj.Panellist1 = new Ext.Panel({
		id : 'Panellist1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.startdate
			,obj.enddate
            ,obj.Bedid
			
		]
	});

	obj.patname = new Ext.form.TextField({
		id : 'patname'
		,fieldLabel : '��������'
		,anchor : '95%'
	});	

	obj.liststatusstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.liststatusstore = new Ext.data.Store({
		proxy: obj.liststatusstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'statCode'
		}, 
		[
		     {name: 'statCode', mapping: 'statCode'}
			,{name: 'statDesc', mapping: 'statDesc'}
		])
	});	
	obj.liststatus = new Ext.form.ComboBox({
		id : 'liststatus'
		,store:obj.liststatusstore
		,minChars:1	
		,displayField:'statDesc'	
		,fieldLabel : '״̬'
		,valueField : 'statCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.liststatusstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUArrange';
		param.QueryName = 'FindICUStatus';
		param.ArgCnt = 0;
	});
	obj.liststatusstore.load({});	
		
	obj.Panellist2 = new Ext.Panel({
		id : 'Panellist2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.patname
			,obj.liststatus
		]
	});
	
	obj.listregno = new Ext.form.TextField({
		id : 'listregno'
		,fieldLabel : '����ID'
		,anchor : '95%'
	});	

    obj.listmedno = new Ext.form.TextField({
		id : 'listmedno'
		,fieldLabel : '������'
		,anchor : '95%'
	});	
			
	obj.Panellist3 = new Ext.Panel({
		id : 'Panellist3'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.listregno
			,obj.listmedno
		]
	});
	
	obj.labelarr=new Ext.form.Label(
	{
		id:'labelarr'
		,text:'����'
		,cls:'palegreen'
		,width:40
		,height:20
	})	
	obj.labelinroom=new Ext.form.Label(
	{
		id:'labelinroom'
		,text:'�໤'
		,cls:'emergency'
		,width:40
		,height:20
	})	
		
	obj.labelstop=new Ext.form.Label(
	{
		id:'labelstop'
		,text:'ֹͣ'
		,cls:'lightblue'
		,width:40
		,height:20
	})	
	obj.btnmonitor = new Ext.Button({
		id : 'btnmonitor'
		,text : '�໤'
	});
		
	obj.btnfindlist = new Ext.Button({
		id : 'btnfindlist'
		,text : '��ѯ'
	});		
	obj.Panellist4 = new Ext.Panel({
		id : 'Panellist4'
		,buttonAlign : 'left'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		     obj.labelarr
		     ,obj.labelinroom
		     ,obj.labelstop
		
		]
		,buttons:
		[
		    obj.btnmonitor
		    ,obj.btnfindlist
		]

	});

	obj.listpanel = new Ext.form.FormPanel({
		id : 'listpanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,height : 80
		,layout : 'column'
		,frame : true
		,items:[
			obj.Panellist1
			,obj.Panellist2
			,obj.Panellist3
			,obj.Panellist4
			
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
			idProperty: 'icuaId'
		}, 
	    [
			{name: 'tStartDateTime', mapping : 'tStartDateTime'}
			,{name: 'tEndDateTime', mapping: 'tEndDateTime'}
			,{name: 'tRegNo', mapping: 'tRegNo'}
			,{name: 'tPatName', mapping: 'tPatName'}
			,{name: 'tAdmLocDesc', mapping: 'tAdmLocDesc'}
			,{name: 'tStatus', mapping: 'tStatus'}
			,{name: 'tBedCode', mapping: 'tBedCode'}
			,{name: 'tDiagDesc', mapping: 'tDiagDesc'}
			,{name: 'tWardDesc', mapping: 'tWardDesc'}
			,{name: 'icuaId', mapping: 'icuaId'}
			,{name: 'tEpisodeID', mapping: 'tEpisodeID'}
			,{name: 'tMedCareNo', mapping: 'tMedCareNo'}
			,{name: 'tIcuaType', mapping: 'tIcuaType'}
			,{name: 'tICUANormalStartDate', mapping: 'tICUANormalStartDate'}
			,{name: 'tICUANormalStartTime', mapping: 'tICUANormalStartTime'}
			,{name: 'tPatHeight', mapping: 'tPatHeight'}
			,{name: 'tPatWeight', mapping: 'tPatWeight'}
			,{name: 'tBodySquare', mapping: 'tBodySquare'}
			,{name: 'icuBedId', mapping: 'icuBedId'}
			,{name: 'curWardId', mapping: 'curWardId'}

		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��ʼ����', width: 150, dataIndex: 'tStartDateTime', sortable: true}
			,{header: '��������', width: 150, dataIndex: 'tEndDateTime', sortable: true}
			,{header: '�ǼǺ�', width: 100, dataIndex: 'tRegNo', sortable: true}
			,{header: '��������', width: 60, dataIndex: 'tPatName', sortable: true}
			,{header: '���˿���', width: 160, dataIndex: 'tAdmLocDesc', sortable: true}
			,{header: '����״̬', width: 60, dataIndex: 'tStatus', sortable: true}
			,{header: '���˴�λ', width: 60, dataIndex: 'tBedCode', sortable: true}
			//,{header: '���', width: 50, dataIndex: 'tDiagDesc', sortable: true}
			,{header: '����', width: 250, dataIndex: 'tWardDesc', sortable: true}
			,{header: 'icuaId', width: 50, dataIndex: 'icuaId', sortable: true}
			,{header: 'tEpisodeID', width: 80, dataIndex: 'tEpisodeID', sortable: true}
			,{
				header: '���'
				, width: 50
				, dataIndex: 'tPatHeight'
				, sortable: true
			    , editor: new Ext.form.TextField({})
			  }
			,{
				header: '����'
				, width: 50
				, dataIndex: 'tPatWeight'
				, sortable: true
				, editor: new Ext.form.TextField({})
				}
			,{header: '������', width: 100, dataIndex: 'tMedCareNo', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'tBodySquare', sortable: true}
			,{header: 'icuBedId', width: 80, dataIndex: 'icuBedId', sortable: true}
			,{header: 'curWardId', width: 80, dataIndex: 'curWardId', sortable: true}
		]
		,viewConfig:
		{
			forceFit: false,
			//Return CSS class to apply to rows depending upon data values

			getRowClass: function(record, index)
			{
				var status = record.get('tStatus');
				switch (status)
				{
					case 'R':
						return 'palegreen'; 
						break;
					case 'M':
						return 'emergency';
						break;
					case 'T':
						return 'lightblue' ;
						break;
					default:
						return 'exec'; 
						break; 
				}
			}
		}
		});
    //alert(obj.startdate.getRawValue()+"^"+obj.enddate.getRawValue());
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUArrange';
		param.QueryName = 'FindICUArrange';
		param.Arg1 = obj.startdate.getRawValue();
		param.Arg2 = obj.enddate.getRawValue();
		param.Arg3 = obj.listregno.getValue();
		param.Arg4 = "";
		param.Arg5 = obj.liststatus.getValue();
		param.Arg6 = obj.listmedno.getValue();
		param.Arg7 = obj.patname.getValue();
		param.ArgCnt = 7;
	});
	obj.retGridPanelStore.load({});
	
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
	obj.listresult = new Ext.Panel({
		id : 'listresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
			
		]
	});
	obj.functionlist = new Ext.Panel({
		id : 'functionlist'
		,buttonAlign : 'center'
		,height : 450
		,title : '�໤�б�'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.listpanel
			,obj.listresult
		]
	});
	
//////////////////////////////////////////////////////	
    obj.btnstartstop= new Ext.Button({
		id : 'btnstartstop'
		//,cls:'red'
		,width:100
		,text : ' '
		//,hidden:true
	});	
	obj.Panelequip1 = new Ext.Panel({
		id : 'Panelequip1'
		,buttonAlign : 'center'
		,columnWidth : 0.5

	});		
	obj.Panelequip2 = new Ext.Panel({
		id : 'Panelequip2'
		,buttonAlign : 'center'
		,columnWidth : 0.2
		,layout : 'form'
		,items:[
		   obj.btnstartstop
		]
	});
	obj.equippanel = new Ext.form.FormPanel({
		id : 'equippanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,height : 40
		,layout : 'column'
		,frame : true
		,items:[
			obj.Panelequip1
			,obj.Panelequip2
			
		]
	});

	obj.retGridPanelequipStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelequipStore = new Ext.data.Store({
		proxy: obj.retGridPanelequipStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
	    [
			{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TBedRowid', mapping: 'TBedRowid'}
			,{name: 'TBed', mapping: 'TBed'}
			,{name: 'TEquipRowid', mapping: 'TEquipRowid'}
			,{name: 'TEquip', mapping: 'TEquip'}
			,{name: 'TDefaultInterval', mapping: 'TDefaultInterval'}
			,{name: 'TInterfaceProgram', mapping: 'TInterfaceProgram'}
			,{name: 'TPort', mapping: 'TPort'}
			,{name: 'TTcpipAddress', mapping: 'TTcpipAddress'}
			,{name: 'TEditTcpipAddress', mapping: 'TEditTcpipAddress'}
			,{name: 'TWardId', mapping: 'TWardId'}
			,{name: 'TWardDesc', mapping: 'TWardDesc'}
			,{name: 'TInterfaceProgramID', mapping: 'TInterfaceProgramID'}
			,{name: 'TStat', mapping: 'TStat'}

		])
	});

    obj.retGridPanelequip = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelequip'
		,store : obj.retGridPanelequipStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'TRowid', width: 50, dataIndex: 'TRowid', sortable: true}
			,{header: '��λ', width: 50, dataIndex: 'TBed', sortable: true}
			,{header: '�豸', width: 100, dataIndex: 'TEquip', sortable: true}
			,{header: 'ȱʡ�������', width: 100, dataIndex: 'TDefaultInterval', sortable: true}
			,{header: '�ɼ�����', width: 150, dataIndex: 'TInterfaceProgram', sortable: true}
			,{header: '�豸�˿�', width: 100, dataIndex: 'TPort', sortable: true}
			,{header: '�豸IP', width: 100, dataIndex: 'TTcpipAddress', sortable: true}
			,{header: 'TBedRowid', width: 100, dataIndex: 'TBedRowid', sortable: true}
			,{header: 'TEquipRowid', width: 100, dataIndex: 'TEquipRowid', sortable: true}
			,{header: '�û�IP', width: 100, dataIndex: 'TEditTcpipAddress', sortable: true}
			,{header: '����', width: 250, dataIndex: 'TWardDesc', sortable: true}
			//,{header: '����ID', width: 250, dataIndex: 'TWardId', sortable: true}
			,{header: 'TInterfaceProgramID', width: 150, dataIndex: 'TInterfaceProgramID', sortable: true}
			,{header: 'TStat', width: 50, dataIndex: 'TStat', sortable: true}
		]});
	
	obj.Panelequip23 = new Ext.Panel({
		id : 'Panelequip23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panelequip25 = new Ext.Panel({
		id : 'Panelequip25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	obj.equipresult = new Ext.Panel({
		id : 'equipresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panelequip23
			,obj.Panelequip25
		    ,obj.retGridPanelequip
			
		]
	});
	
	obj.functionequip = new Ext.Panel({
		id : 'functionequip'
		,buttonAlign : 'center'
		,title:'�໤�豸'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.equippanel
			,obj.equipresult
		]
	});

	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionlist
			,obj.functionequip
		]
	});
	
	
	InitViewScreenEvent(obj);
	
    obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.btnmonitor.on("click", obj.btnmonitor_click, obj);
    obj.btnfindlist.on("click", obj.btnfindlist_click, obj);
    obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
    
    obj.retGridPanelequip.on("rowclick", obj.retGridPanelequip_rowclick, obj);
    obj.btnstartstop.on("click", obj.btnstartstop_click, obj)
    obj.LoadEvent(arguments);    
    return obj;	
	
}

