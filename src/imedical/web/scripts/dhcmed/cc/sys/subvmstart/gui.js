function InitStartConfig(SubjectID){
	var obj = new Object();
	obj.SubjectID = "";
	if (!SubjectID) {
		obj.SubjectID = SubjectID;
	}
	
  obj.IDListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.IDListStore = new Ext.data.Store({
		proxy: obj.IDListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'VarName', mapping: 'VarName'}
			,{name: 'RunType', mapping: 'RunType'} 
			,{name: 'SubjectID', mapping: 'SubjectID'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'StartIndex', mapping: 'StartIndex'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
	])});
	obj.IDListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.IDList = new Ext.grid.GridPanel({
		store : obj.IDListStore
		,loadMask : true
		,region : 'center'
		,height : 130
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 100, dataIndex: 'Description', sortable: true}
			,{header: '������', width: 100, dataIndex: 'VarName', sortable: true}
			,{header: '��Ч', width: 100, dataIndex: 'IsActive', sortable: true, 
					renderer : function(v)
					{
						if(v == "1")
							return "<IMG SRC='../scripts/dhcmed/img/accept.png' height='16px' width='16px'/>";
						else
							return "";	
					}
				}
			,{header: '���ʽ', width: 100, dataIndex: 'Expression', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	
	obj.IDCode = new Ext.form.TextField({
		fieldLabel : '����'
		,anchor : '99%'
	});
	obj.Description = new Ext.form.TextField({
		fieldLabel : '����'
		,anchor : '99%'
	});
	obj.VarName = new Ext.form.TextField({
		anchor : '99%'
		,fieldLabel : '������'
	});
	
	var myRunTypeData = [
		['S', '��ʼ�������ʱ����'],
		['L', '���ÿ������ʱ����']
	];
	
	
	obj.cboRunTypeStore = new Ext.data.ArrayStore({
        fields: [
           {name: 'Code'},
           {name: 'Desc'}
        ]
    });
 	obj.cboRunTypeStore.loadData(myRunTypeData);	   
	obj.cboRunType = new Ext.form.ComboBox({
				width : 215,
				store : obj.cboRunTypeStore,
				fieldLabel : '�������',
        displayField:'Desc',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
				valueField : 'Code',
				editable : false
			});

	obj.IsActive = new Ext.form.Checkbox({
		checked : true
		,fieldLabel : '��Ч'
	});
	obj.pnExpression = new Ext.form.TextField({
		buttonAlign : 'center'
		,fieldLabel : '���ʽ'
		,anchor : '99%'
	});
	obj.cboStartIndex = new Ext.form.NumberField({
					
					name:'number'
    			,fieldLabel:"����˳��"
    			,allowNegative: false       //���������븺��
    			,allowDecimals: false  //����������С��
    			,nanText: "��������Ч����" //��Ч������ʾ
    			,minValue : 0
					,maxValue : 150
					,minText : "��������ֱ������0"
					,maxText : "��������ֱ���С��150"
					,anchor : '99%'
 					
   });
	obj.pnResumeText = new Ext.form.TextArea({
		fieldLabel : '��ע'
		,anchor : '75%'	
});
	obj.btnFind = new Ext.Button({
	  iconCls : 'icon-find'
		,anchor : '99%'
		,text : '��ѯ'
	});
	obj.btnSave = new Ext.Button({
		iconCls : 'icon-save'
		,anchor : '99%'
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		iconCls : 'icon-delete'
		,anchor : '99%'
		,text : 'ɾ��'
	});
	
	obj.pnfItemLeft = new Ext.Panel({
		layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 60
		,columnWidth : .50
		,items:[
			obj.IDCode
			,obj.Description
			,obj.VarName
			,obj.cboRunType
		]
	});
	obj.pnfItemRight = new Ext.Panel({
		layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 90
		,columnWidth : .50
		,items:[
			//obj.cboTitle,
			obj.IsActive
			,obj.pnExpression
			,obj.cboStartIndex
			
		]
	}); 
	 
	obj.pnItemUp = new Ext.Panel({
		layout : 'column'
		,anchor : '100%'
		,items:[
			obj.pnfItemLeft
			,obj.pnfItemRight
		]
	});
	obj.Panel = new Ext.Panel({
		buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,columnWidth : .70
		,region : 'south'
		,layout : 'form'
		,height: 280
		,title:'��Ϣ�༭'
		,frame : true
		,items:[
			obj.pnItemUp
			,obj.pnResumeText
		]
		,buttons:[
			obj.btnFind
			,obj.btnSave
			,obj.btnDelete
		]
	});
		obj.winStartConfig = new Ext.Window({
		title : '�Զ������������'
		,layout : 'border'
		,height : 500
		,width : 600
		,modal : true
		,items:[
			obj.IDList
			,obj.Panel
		]
	});
	obj.IDListStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'DHCMed.CCService.Sys.VMStartConfigSrv';
				param.QueryName = 'QryBySubject';
				//alert(obj.SubjectID);
				param.Arg1 = SubjectID;
				param.Arg2 = "";
				param.ArgCnt =2;
	});
	obj.IDListStore.load({});
	InitStartConfigEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}