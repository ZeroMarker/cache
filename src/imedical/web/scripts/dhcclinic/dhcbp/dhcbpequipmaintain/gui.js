//20170307+dyl
function InitViewScreen(){
	var obj=new Object();
	//�ı�1
	obj.equipName = new Ext.form.TextField({
		id : 'equipName'
		,fieldLabel : '�豸����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	// �豸�ͺ�
	obj.equipTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.equipTypeStore = new Ext.data.Store({
		proxy: obj.equipTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tID'
		}, 
		[
			{name: 'tID', mapping: 'tID'}
			,{name: 'tBPCEMDesc', mapping: 'tBPCEMDesc'}
			,{name: 'tBPCEMAbbreviation', mapping: 'tBPCEMAbbreviation'}
		])
	});	
	obj.equipType = new Ext.form.ComboBox({
		id : 'equipType'
		,minChars : 1
		,fieldLabel : '�豸�ͺ�'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.equipTypeStore
		,displayField : 'tBPCEMDesc'
		,valueField : 'tID'
		,anchor : '95%'
	});
	obj.equipTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEModel';
		//param.Arg1 = "";
		param.ArgCnt = 0;
	});
	obj.equipTypeStore.load({});
	
	
	//��������
	obj.manufactNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.manufactNameStore = new Ext.data.Store({
		proxy: obj.manufactNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'BPCMDesc', mapping: 'BPCMDesc'}
		])
	});	
	obj.manufactName = new Ext.form.ComboBox({
		id : 'manufactName'
		,minChars : 1
		,fieldLabel : '��������'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.manufactNameStore
		,displayField : 'BPCMDesc'
		,valueField : 'tRowId'
		,anchor : '95%'
	});	
	obj.manufactNameStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCManufacturer';
		param.QueryName = 'FindEManufacturer';
		param.Arg1 = "";
		param.ArgCnt = 1;
	});
	obj.manufactNameStore.load({});
		
	obj.tRowId = new Ext.form.TextField({
		id : 'tRowId'
		,hidden : true
    });
    	
	//��λ��
	obj.bpbeBedDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextbed(v, record) { 
         return record.tRowId+" || "+record.tBPCBDesc; 
    } 
	obj.bpbeBedDrstore = new Ext.data.Store({
		proxy: obj.bpbeBedDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
		     {name: 'tRowId', mapping: 'tRowId'}
			,{ name: 'selecttext', convert:seltextbed }
			//,{name: 'tBPCBDesc', mapping: 'tBPCBDesc'}
		])
	});	
	
    obj.bedNo = new Ext.form.ComboBox({
		id : 'bedNo'
		,minChars : 1
		,fieldLabel : '��λ��'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.bpbeBedDrstore
		,displayField : 'selecttext'
		,valueField : 'tRowId'
		,anchor : '95%'
	});
	obj.bpbeBedDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCBed';
		param.QueryName = 'FindBPCBed';
		param.ArgCnt = 0;
	});
	obj.bpbeBedDrstore.load({});
	
	//�豸״̬
	var Statusdata=[
		['US','����'],
		['SP','����'],
		['SC','����']
	]
	obj.equipStatusStoreProxy = new Ext.data.MemoryProxy(Statusdata),
	
	obj.equipStatusStore = new Ext.data.Store({
		proxy: obj.equipStatusStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.equipStatusStore.load({});
	obj.equipStatus=new Ext.form.ComboBox({
		id : 'equipStatus'
		,minChars : 1
		,fieldLabel : '�豸״̬'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.equipStatusStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '95%'
	});
	
	obj.buyDate = new Ext.form.DateField({
		id : 'buyDate'
		//,value : new Date()
		//,format : 'Y-m-d'
		,fieldLabel:'��������'
		,anchor : '95%'
	});
	
	obj.buyMoney = new Ext.form.TextField({
		id : 'buyMoney'
		,fieldLabel : '������(��)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.note = new Ext.form.TextField({
		id : 'note'
		,fieldLabel : '��ע'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.guarYears = new Ext.form.TextField({
		id : 'guarYears'
		,fieldLabel : '��������(��)'
		,labelSeparator: ''
		,anchor : '95%'
	});
		

	obj.installPersonOut = new Ext.form.TextField({
		id : 'installPersonOut'
		,fieldLabel : '��װ��Ա(��)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.installPersonInStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.installPersonInStore = new Ext.data.Store({
	    proxy : obj.installPersonInStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'Name',mapping:'Name'}
			,{name:'Id',mapping:'Id'}
		])
	
	});
	
	//obj.installPersonInStore.load({})
	//obj.installPersonInStore.load({});
	obj.installPersonIn = new Ext.ux.form.LovCombo({
	    id : 'installPersonIn'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '��װ��Ա(��)'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '95%'
	}); 

	obj.takeCarePerson = new Ext.ux.form.LovCombo({
	    id : 'takeCarePerson'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '������Ա'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,multiSelect:true  
		,anchor : '95%'
		,showSelectAll :true
	}); 
	obj.installPersonInStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindUserByLoc';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.Arg2 = session['LOGON.USERID'];
		param.ArgCnt = 2;
	});
	
	obj.equipSeqNo = new Ext.form.TextField({
		id : 'equipSeqNo'
		//,allowBlank : false
		,fieldLabel : '�豸���к�'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.equipHosNo = new Ext.form.TextField({
		id : 'equipHosNo'
		//,allowBlank : false
		,fieldLabel : '�豸Ժ�ڱ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.manufactName
			,obj.buyDate
			,obj.installPersonIn
			//,obj.bedNo
		]
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipType
			,obj.equipStatus
			,obj.installPersonOut 
		]
	});
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipSeqNo
			,obj.buyMoney
			,obj.takeCarePerson
		]
	});	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth:110
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.equipHosNo
			,obj.guarYears
			,obj.note
			,obj.tRowId
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
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
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls:'icon-add'
		,text : '����'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls:'icon-edit'
		,style:'margin-left:10px'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls:'icon-delete'
		,text : 'ɾ��'
		,style:'margin-left:10px'
		,hidden : true
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,width:86
		,iconCls:'icon-find'
		,style:'margin-left:10px'
		,text : '����'
		//,hidden : true // ����
	});
	
	obj.maintainBtn = new Ext.Button({
		id : 'maintainBtn'
		,width:100
		,iconCls:'icon-normalinfo'
		,style:'margin-left:10px'
		,text : 'ά����¼'
		//,hidden : true // ����
	});
	
	obj.ExportExlBtn = new Ext.Button({
		id : 'ExportXlsBtn'
		,width:100
		,style:'margin-left:10px'
		,iconCls:'icon-export'
		,text : '����Excel'
		//,hidden : true // ����
	});
	
	obj.labelUsing=new Ext.form.Label(
	{
		id:'labColorUsing'
		,style:'margin-left:10px'
		,cls:'icon-onuse'
		,width:100
		,height:25
	})
	obj.labelSpare=new Ext.form.Label(
	{
		id:'labColorSpare'
		,cls:'icon-preparetouse'
		,width:100
		,height:25
	})
	
	obj.labelScrap=new Ext.form.Label(
	{
		id:'labColorScrap'
		,style:'margin-left:10px'
		,cls:'icon-nouse'
		,width:100
		,height:25
	})
	


	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .70
		,layout : 'column'
        ,items:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.findbutton
            ,obj.maintainBtn
            ,obj.ExportExlBtn
			,obj.deletebutton
			,obj.labelUsing
            ,obj.labelSpare
            ,obj.labelScrap
       ]
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,height : 30
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	
	obj.detectionPanel = new Ext.Panel({
		id : 'detectionPanel'
		,buttonAlign : 'center'
		,height : 150
		,title : '�豸����ά��'
		,region : 'north'
		,iconCls:'icon-manage'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.buttonPanel
		]
    });
	
	//gridview����
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tBPCERowId'
		}, 
	    [
			{name: 'tBPCERowId', mapping: 'tBPCERowId'} //ROWID
			,{name: 'tBPCECode', mapping: 'tBPCECode'}//�豸Ժ�ڱ��
			,{name: 'tBPCEDesc', mapping: 'tBPCEDesc'}//�豸����
			,{name: 'tBPCENo', mapping: 'tBPCENo'}//�豸���к�
			,{name: 'tBPCEFromDate', mapping: 'tBPCEFromDate'}//
			,{name: 'tBPCEToDate', mapping: 'tBPCEToDate'}//
			,{name: 'tBPCEStatus', mapping: 'tBPCEStatus'}//
			,{name: 'tBPCEStatusD', mapping: 'tBPCEStatusD'}//�豸״̬
			,{name: 'tBPCENote', mapping: 'tBPCENote'}//��ע
			,{name: 'tBPCEBPCEquipModelDr', mapping: 'tBPCEBPCEquipModelDr'}//�豸�ͺ�id
			,{name: 'tBPCEBPCEquipModel', mapping: 'tBPCEBPCEquipModel'}//�豸�ͺ�
			,{name: 'tBPCEBPCEAbbre', mapping: 'tBPCEBPCEAbbre'}//�豸�ͺ���д
			,{name: 'tBPCEMType', mapping: 'tBPCEMType'}//�豸����
			,{name: 'tBPCEBPCEquipMFDr', mapping: 'tBPCEBPCEquipMFDr'}//����id
			,{name: 'tBPCEBPCEquipMFDesc', mapping: 'tBPCEBPCEquipMFDesc'}//��������
			,{name: 'tBPCESoftwareVersion', mapping: 'tBPCESoftwareVersion'}//�汾
			,{name: 'tBPCEPart', mapping: 'tBPCEPart'}//����
			,{name: 'tBPCEInstallDate', mapping: 'tBPCEInstallDate'}//��װ����
			,{name: 'tBPCETotalWorkingHour', mapping: 'tBPCETotalWorkingHour'}//������ʱ��
			,{name: 'tBPCEPurchaseDate', mapping: 'tBPCEPurchaseDate'}//��������
			,{name: 'tBPCEPurchaseAmount', mapping: 'tBPCEPurchaseAmount'}//������
			,{name: 'tBPCEWarrantyYear', mapping: 'tBPCEWarrantyYear'}//��������
			,{name: 'installPerIdLtIn', mapping: 'installPerIdLtIn'}//��װ��Ա(��)IDlist
			,{name: 'installPerNameLtIn', mapping: 'installPerNameLtIn'}//��װ��Ա(��)Namelist
			,{name: 'installPersonOut', mapping: 'installPersonOut'}//��װ��Ա(Ժ��)
			,{name: 'keepPerIdList', mapping: 'keepPerIdList'}//������ԱIDlist
			,{name: 'keepPerNameList', mapping: 'keepPerNameList'}//������ԱNamelist
			,{name: 'tBPBEBedDr', mapping: 'tBPBEBedDr'}//��λID
			,{name: 'tBPBEBed', mapping: 'tBPBEBed'}//��λ����
			
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
			,{header: 'ϵͳ��', width: 50, dataIndex: 'tBPCERowId', sortable: true}
			,{header: '��λ', width: 80, dataIndex: 'tBPBEBed', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'tBPCEBPCEquipMFDesc', sortable: true}
			,{header: '�豸�ͺ�', width: 180, dataIndex: 'tBPCEBPCEquipModel', sortable: true}
			,{header: '�豸���к�', width: 180, dataIndex: 'tBPCENo', sortable: true}
			,{header: '�豸Ժ�ڱ��', width: 180, dataIndex: 'tBPCECode', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'tBPCEPurchaseDate', sortable: true}
			,{header: '�豸״̬', width: 100, dataIndex: 'tBPCEStatusD', sortable: true}
			,{header: '�豸����', width: 100, dataIndex: 'tBPCEMType', sortable: true}
			,{header: '������(��)', width: 100, dataIndex: 'tBPCEPurchaseAmount', sortable: true}
			,{header: '��������(��)', width: 100, dataIndex: 'tBPCEWarrantyYear', sortable: true}
			,{header: '��װ��Ա(Ժ��)', width: 100, dataIndex: 'installPerNameLtIn', sortable: true}
			,{header: '��װ��Ա(Ժ��)', width: 100, dataIndex: 'installPersonOut', sortable: true}
			,{header: '������Ա', width: 100, dataIndex: 'keepPerNameList', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'tBPCENote', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
		,viewConfig:
		{
			forceFit: false,
			//Return CSS class to apply to rows depending upon data values

			getRowClass: function(record, index)
			{
				var status = record.get('tBPCEStatus');
				//var type=record.get('jzstat');

				switch (status)
				{
					case 'US':
						return 'white'; //blue /refuse
						break;
					case 'SP':
						return 'palegreen';  //green //arranged
						break;
					case 'SC':
						return 'red' ;//yellow //finish
						break;
				}
			}
		}
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
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
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
	
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.detectionPanel
			,obj.resultPanel
		]
	});
	
	//***���ݰ󶨴���***
	//gridview
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindEquip';
		param.Arg1 = obj.equipType.getValue();
		param.Arg2 = obj.buyDate.getRawValue();
		param.Arg3 = obj.equipHosNo.getValue();
		param.Arg4 = obj.equipSeqNo.getValue();	
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({});
 
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.ExportExlBtn.on("click",obj.ExportExlBtn_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.findbutton.on("click", obj.selectbutton_click, obj);
	obj.maintainBtn.on("click", obj.maintainBtn_click, obj);
	obj.equipType.on("select",obj.equipType_select,obj);
	obj.manufactName.on("select",obj.manufactName_select,obj);
  	obj.LoadEvent(arguments);
	return obj;
}


function InitwinScreen()
{
	var obj = new Object();

	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
	    [
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tDBPCEquipDr', mapping: 'tDBPCEquipDr'}
			,{name: 'tDBPCEquipDesc', mapping: 'tDBPCEquipDesc'}
			,{name: 'tDBPEquipPartDr', mapping: 'tDBPEquipPartDr'}
			,{name: 'tDBPEquipPartDesc', mapping: 'tDBPEquipPartDesc'}
			,{name: 'tBPEMType', mapping: 'tBPEMType'}
			,{name: 'tBPEMTypeDesc', mapping: 'tBPEMTypeDesc'}
			,{name: 'tBPEMPartType', mapping: 'tBPEMPartType'}
			,{name: 'tBPEMPartTypeDesc', mapping: 'tBPEMPartTypeDesc'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'EndDate', mapping: 'EndDate'}
			,{name: 'EndTime', mapping: 'EndTime'}
			,{name: 'Note', mapping: 'Note'}
			,{name: 'tBPEMExpense', mapping: 'tBPEMExpense'}
			,{name: 'UserID', mapping: 'UserID'}
			,{name: 'userNameList', mapping: 'userNameList'}
			,{name: 'userIdList', mapping: 'userIdList'}
			,{name: 'userNameOut', mapping: 'userNameOut'} // Ժ��μ���
		])
	});

    obj.retGridPanel1 = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel1'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'ά��ʱ��', width: 100, dataIndex: 'StartDate', sortable: true}
		,{header: '��������', width: 150, dataIndex: 'tDBPEquipPartDesc', sortable: true}
		,{header: 'ά������', width: 100, dataIndex: 'tBPEMTypeDesc', sortable: true}
		,{header: 'ά������', width: 100, dataIndex: 'tBPEMExpense', sortable: true}
		,{header: '�μ���(Ժ��)', width: 180, dataIndex: 'userNameList', sortable: true}
		,{header: '�μ���(Ժ��)', width: 180, dataIndex: 'userNameOut', sortable: true}
		,{header: '��ע', width: 180, dataIndex: 'Note', sortable: true}
		]

		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});

	obj.winMaintainDate = new Ext.form.DateField({
		id : 'winMaintainDate'
		//,value : new Date()
		,labelSeparator: ''
		,fieldLabel:'ά��ʱ��'
		,anchor : '95%'
	});
	
	//��������		
	obj.winEquipReplace = new Ext.form.TextField({
		id : 'winEquipReplace'
		,fieldLabel : '��������'
		,labelSeparator: ''
		,anchor : '95%'
	});
	var data=[
		['C','����'],
		['M','����'],
		['R','ά��']
	]
	obj.winMainDescStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.winMainDescStore = new Ext.data.Store({
		proxy: obj.winMainDescStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.winMainDescStore.load({});
	obj.winMainDesc = new Ext.form.ComboBox({
		id : 'winMainDesc'
		,minChars : 1
		,fieldLabel : 'ά������'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.winMainDescStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'95%'
	});
	
	obj.winMaintainMoney = new Ext.form.TextField({
		id : 'winMaintainMoney'
		,labelSeparator: ''
		,fieldLabel : 'ά������'
		,anchor : '95%'
	});
	
	obj.installPersonInStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.installPersonInStore = new Ext.data.Store({
	    proxy : obj.installPersonInStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'Name',mapping:'Name'}
			,{name:'Id',mapping:'Id'}
		])
	
	});
	obj.winPersonMIn = new Ext.ux.form.LovCombo({
	    id : 'winPersonMIn'
		,store : obj.installPersonInStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : 'Ժ�ڲμ���'
		,valueField : 'Id'
		,labelSeparator: ''
		,triggerAction : 'all'
		,anchor : '95%'
		,emptyText:'��ѡ��'
		,allowBlank : false
		
	}); 
	obj.installPersonInStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindUserByLoc';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.Arg2 = session['LOGON.USERID'];
		param.ArgCnt = 2;
	});
	obj.installPersonInStore.load({});
	
	obj.winNote = new Ext.form.TextField({
		id : 'winNote'
		,fieldLabel : '��ע'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.winPersonMOut = new Ext.form.TextField({
		id : 'winPersonMOut'
		,fieldLabel : 'Ժ��μ���'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.winTxtRowId = new Ext.form.TextField({
		id : 'winTxtRowId'
		,fieldLabel : ''
		,anchor : '75%'
		,hidden : true
	});
	obj.winEquipInfo = new Ext.form.TextField({
		id : 'winEquipInfo'
		//,allowBlank : false
		,fieldLabel : ''
		,anchor : '75%'
		,hidden : true
	});
	
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		//,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winMaintainDate
			,obj.winMaintainMoney
			,obj.winNote
		]
	});
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .35
		,layout : 'form'
		,labelWidth:80
		,items:[
			obj.winEquipReplace
			,obj.winPersonMIn
			,obj.winEquipInfo
		]
	});
	obj.Panel13= new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,labelWidth:70
		,items:[
			obj.winMainDesc
			,obj.winPersonMOut
			,obj.winTxtRowId
		]
	});
	obj.basePanel = new Ext.Panel({
		id : 'basePanel'
		,buttonAlign : 'center'
		,labelWidth:60
		,layout : 'column'
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
		]
	});
	
	obj.winBtnSave = new Ext.Button({
		id : 'winBtnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.winBtnCancle = new Ext.Button({
		id : 'winBtnCancle'
		,iconCls : 'icon-cancel'
		,text : 'ȡ��'
	});
	obj.winBtnExcel = new Ext.Button({
		id : 'winBtnExcel'
		,iconCls : 'icon-export'
		,text : '����Excel'
	});
	
	obj.admInfPanel = new Ext.form.FormPanel({
	    id : 'admInfPanel'
		,buttonAlign : 'center'
		,labelWidth : 100
		,title : 'ά����Ϣ'
		,iconCls:'icon-manage'
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'form'
		,height : 150
		,frame : true
		,items : [
		     obj.basePanel
			//,obj.Panel21
		]
		,buttons:[
			obj.winBtnSave
			,obj.winBtnCancle
			,obj.winBtnExcel
		]
	});
	
	obj.hiddenPanel = new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[	
	    ]
    });

	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 400
		,buttonAlign : 'center'
		,width : 800
		,title : '�༭'
		,modal : true
		,layout : 'border'
		,items:[
			obj.admInfPanel
			,obj.retGridPanel1
			,obj.hiddenPanel
		]
	});
	InitwinScreenEvent(obj);
	//�¼��������
	obj.winBtnCancle.on("click", obj.winBtnCancle_click, obj);
	obj.winBtnSave.on("click", obj.winBtnSave_click, obj);
	obj.winBtnExcel.on("click", obj.winBtnExcel_click, obj);
	obj.retGridPanel1.on("rowclick", obj.retGridPanel1_rowclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}
