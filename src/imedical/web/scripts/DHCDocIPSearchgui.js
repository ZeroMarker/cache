

function InitviewScreen() {
	
	var obj = new Object();
	
	obj.paadmadmno = new Ext.form.TextField({
		id : 'paadmadmno' //Ψһ�����id��Ĭ��Ϊ�Զ������id���������������id����ȡ���������һĿ�ģ���ʹ��Ext.ComponentMgrgetCmp�����Σ�����ͻ�����һ����д�õ�id�������������ʾ��������Ԫ�ؼ�HTMLԪ��Ҳ��ʹ�ø�id��Ⱦ��ҳ���ϡ����һ����Ϳ��Բ���CSS idƥ��Ĺ�����������������ʽ�����仰˵��ʵ���������ʱ�����벻ͬ��Id�����ж�Ӧ��ͬ����ʽЧ����
		,width : 100
		,anchor : '100%'
		,fieldLabel : 'סԺ֤��' //������Ա�������ʾ��label�ı���Ĭ��Ϊ''���������ֻ����FormLayout���ֹ��������Ƶ���������Ⱦ������.
	});
	
	obj.papminame = new Ext.form.TextField({
		id : 'papminame'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����'
	});
	
	obj.paadmno = new Ext.form.TextField({
		id : 'paadmno'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '�ǼǺ�'
	});
		
	obj.registerStartDate = new Ext.form.DateField({ //�ṩһ��������Ext.DatePicker����ѡ���Զ�Ч��ؼ������������ֶΡ�
		id : 'registerStartDate' 
		,format : 'Y-m-d' //���Ը��Ǳ��ػ���Ĭ�����ڸ�ʽ���ִ����ִ�����Ϊ����ָ��DateparseDate����ʽ(Ĭ��Ϊ 'm/d/y')��
		,width : 80 
		,fieldLabel : '�Ǽǿ�ʼ����' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' //�� "|" ���ŷָ��Ķ�����ڸ�ʽ���ִ����������������Ĭ�ϵĸ�ʽ����ʱ�������Ը�ʽ������ֵ(Ĭ��Ϊ 'm/d/Y|m-d-y|m-d-Y|m/d|m-d|d')��
		//,value : new Date()  //�ֶγ�ʼ����ֵ��Ĭ��Ϊundefined����
	});
	
	obj.registerEndDate = new Ext.form.DateField({ //�ṩһ��������Ext.DatePicker����ѡ���Զ�Ч��ؼ������������ֶΡ�
		id : 'registerEndDate' 
		,format : 'Y-m-d' //���Ը��Ǳ��ػ���Ĭ�����ڸ�ʽ���ִ����ִ�����Ϊ����ָ��DateparseDate����ʽ(Ĭ��Ϊ 'm/d/y')��
		,width : 80 
		,fieldLabel : '�Ǽǽ�������' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' //�� "|" ���ŷָ��Ķ�����ڸ�ʽ���ִ����������������Ĭ�ϵĸ�ʽ����ʱ�������Ը�ʽ������ֵ(Ĭ��Ϊ 'm/d/Y|m-d-y|m-d-Y|m/d|m-d|d')��
		//,value : new Date()  //�ֶγ�ʼ����ֵ��Ĭ��Ϊundefined����
	});
	
	obj.IfAllocateStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['B', '��ԤԼ'],['Al', '�ѷ���'],['Ar', '����Ժ'],['C', '������'],['H', '�ѹ���']]
	});
	
	obj.IfAllocate = new Ext.form.ComboBox({
		id : 'IfAllocate'
		,width : 100
		,store : obj.IfAllocateStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : '����״̬'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'Code'
		,mode:"local"
});

	/*
	obj.SortMethodStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['1', '��֤ʱ��'],['2', '�Ǽ�ʱ��'],['3', '��������'],['4', '��������']]
	});
	*/
	obj.SortMethodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SortMethodStore = new Ext.data.Store({
		proxy: obj.SortMethodStoreProxy,
		autoLoad : true, 
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowId', mapping: 'RowId'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});

	obj.SortMethod = new Ext.form.ComboBox({
		id : 'SortMethod'
		,width : 100
		,store : obj.SortMethodStore
		//,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '����ʽ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'RowId'
		,mode:"local"
	});
	obj.SortMethodStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'GetSortMethodList';
			param.ArgCnt = 0;
	});
	
	/*
	obj.IfAllocate = new Ext.form.CheckboxGroup({
		id : 'IfAllocate'
		,xtype: 'checkboxgroup'
		,width : 150
		//,anchor : '95%'
		,items: [
			{boxLabel: '�ż���', name: 'noBed'}
		]
	});
	*/
	
	obj.CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CTLocStore = new Ext.data.Store({
		proxy: obj.CTLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.CTLoc = new Ext.form.ComboBox({
		id : 'CTLoc'
		,width : 100
		,store : obj.CTLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : 'ԤԼ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'CTLocID'
});

	obj.orderInDate = new Ext.form.DateField({
		id : 'orderInDate',
		format : 'Y-m-d',
		width : 100,
		fieldLabel : 'ԤԼ��Ժ����',
		anchor : '100%',
		altFormats : 'Y-m-d|d/m/Y'//,
		//value : new Date()
	});
	
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,minChars : 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
		,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
		,store : obj.cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : 'ԤԼ����'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,triggerAction : 'all'  //�������������ʱ��Ҫִ�еĲ�����
		,anchor : '100%'
		,valueField : 'CTLocID'
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,iconCls : 'icon-find'
		,text : '��ѯ'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	
	obj.CTDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CTDoctorStore = new Ext.data.Store({
		proxy: obj.CTDoctorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTPCPRowId', mapping: 'CTPCPRowId'}
			,{name: 'CTPCPCode', mapping: 'CTPCPCode'}
			,{name: 'CTPCPDesc', mapping: 'CTPCPDesc'}
		])
	});
	
	obj.CTDoctor = new Ext.form.ComboBox({
		id : 'CTDoctor'
		//,selectOnFocus : true
		//,forceSelection : true
		,minChars : 1
		,displayField : 'CTPCPDesc'
		,fieldLabel : 'ԤԼҽ��'
		,store : obj.CTDoctorStore
		//,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,anchor : '100%'
		,valueField : 'CTPCPRowId'
	});
	
	obj.CTHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CTHospitalStore = new Ext.data.Store({
		proxy: obj.CTHospitalStoreProxy,
		autoLoad : true, 
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HosCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'HosDesc', mapping: 'HosDesc'}
			,{name: 'HosCode', mapping: 'HosCode'}
		])
	});
	
	obj.CTHospital = new Ext.form.ComboBox({
		id : 'CTHospital'
		//,selectOnFocus : true
		//,forceSelection : true
		,minChars : 1
		,displayField : 'HosDesc'
		,fieldLabel : 'ԤԼԺ��'
		,store : obj.CTHospitalStore
		//,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,anchor : '100%'
		,valueField : 'HosCode'
	});
	
	obj.CTHospitalStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';			
			param.Arg1 = '';
			param.ArgCnt = 1;
	}); 
	
	//ʱ�䷶Χ
	obj.DateConditionStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['0', '����'],['1', '������ǰ'],['2', '����ǰ'],['3', 'һ��ǰ'],['4', '����ǰ']]
	});
	obj.DateCondition = new Ext.form.ComboBox({
		id : 'DateCondition'
		,width : 100
		,store : obj.DateConditionStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : 'ʱ�䷶Χ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'Code'
		,mode:"local"
	});
	//end
	
	obj.btnCancle = new Ext.Button({
		id : 'btnCancle'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '����'
	});
	
	obj.btnReCancle = new Ext.Button({
		id : 'btnReCancle'
		,width : 100
		//,iconCls : 'icon-export'
		,text : 'ȡ������'
	});
	
	obj.btnCancleAllocate = new Ext.Button({
		id : 'btnCancleAllocate'
		,width : 100
		//,iconCls : 'icon-export'
		,text : 'ȡ������'
	});
	
	///����
	obj.btnHang = new Ext.Button({
		id : 'btnHang'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '����'
	});
	obj.btnCancleHang = new Ext.Button({
		id : 'btnCancleHang'
		,width : 100
		//,iconCls : 'icon-export'
		,text : 'ȡ������'
	});
	///end
	obj.ChangeAppInfo = new Ext.Button({
		id : 'ChangeAppInfo'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '����ԤԼ��Ϣ'
	});
	
	/////�㴲���Ա�������
	obj.AccompanySexStore = new Ext.data.SimpleStore({
		//id : 'AccompanySexStore'
		fields : ['Code', 'value']
		,data : [['0', ''],['1', '��'],['2', 'Ů'],['3', 'δ֪�Ա�'],['4', 'δ˵���Ա�']]
	});
	
	obj.AccompanySex = new Ext.form.ComboBox({
		id : 'AccompanySex'
		,width : 100
		,store : obj.AccompanySexStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : '�Ա�'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'Code'
		,mode:"local"
	});
	/////end
	
	/*
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,width : 120
		,iconCls : 'icon-export',
		text : '����'
	});
	*/
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .20 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [obj.paadmadmno,
				obj.cboWard,
				obj.registerStartDate,
				obj.DateCondition,
				obj.AccompanySex]  //һ����������������ɵ����飬���뵽�������С�
	});
	
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items : [
				obj.paadmno,
				obj.CTLoc,
				obj.registerEndDate,
				obj.ChangeAppInfo]	
	});
	
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3',
		buttonAlign : 'center',
		columnWidth : .20,
		layout : 'form',
		items : [obj.papminame,
				obj.CTDoctor,
				obj.orderInDate,
				obj.btnHang]
	});
	
	obj.pConditionChild4= new Ext.Panel({
		id : 'pConditionChild4',
		buttonAlign : 'center'
		,labelSeparator : ' ',
		columnWidth : .20,
		layout : 'form',
		items : [obj.IfAllocate,obj.SortMethod,obj.btnCancleHang]
		//items : [obj.IfAllocate,obj.SortMethod,obj.CTHospital,obj.btnCancleHang]
	});
	
	obj.pConditionChild5= new Ext.Panel({
		id : 'pConditionChild5',
		buttonAlign : 'center',
		columnWidth : .20,
		layout : 'form',
		items : [obj.btnQuery,obj.btnCancle,obj.btnReCancle,obj.btnCancleAllocate]
	});

	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'right', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
		labelAlign : 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
		labelWidth : 100,
		bodyBorder : 'padding:0 0 0 0',
		layout : 'column',
		region : 'north',
		frame : true,
		height : 140,
		//title : winTitle,
		items : [
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild4
			,obj.pConditionChild5
		]
		//buttons : [
			//obj.btnQuery
			//,obj.btnExport
		//]
	});
	

	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	
	obj.gridResultsm = new Ext.grid.CheckboxSelectionModel();
		
	obj.gridResultStore = new Ext.data.Store({
		id: 'gridResultStoretore',
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IPAppID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'IPAppID', mapping: 'IPAppID'}
			,{name: 'myPAPMINO', mapping: 'myPAPMINO'}
			,{name: 'myBookDate', mapping: 'myBookDate'}
			,{name: 'myPatName', mapping: 'myPatName'}
			,{name: 'myPatSex', mapping: 'myPatSex'}
			,{name: 'PatType', mapping: 'PatType'}
			,{name: 'myAppLoc', mapping: 'myAppLoc'}
			,{name: 'myAppDate', mapping: 'myAppDate'}
			,{name: 'AccompanySex', mapping: 'AccompanySex'}
			,{name: 'BedNo', mapping: 'BedNo'}
			,{name: 'IPStatus', mapping: 'IPStatus'}
			//,{name: 'IPDate', mapping: 'IPDate'}
			,{name: 'PatAddress', mapping: 'PatAddress'}
			,{name: 'PatMobPhone', mapping: 'PatMobPhone'}
			,{name: 'TelH', mapping: 'TelH'}
		])
	});
	
	/*obj.expCtrlDetail = new Ext.ux.grid.RowExpander({
      tpl : new Ext.Template(
          '<p>{CtrlDtl}</p><br>'
      )
  });*/
	
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: obj.expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			obj.gridResultsm
			,new Ext.grid.RowNumberer({header:"���"	,width:40})
			,{header: 'IPAppID', width: 100, dataIndex: 'IPAppID', sortable: true,hidden:true}
			,{header: '�Ǽ�����', width: 100, dataIndex: 'myBookDate', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'myPatName', sortable: true}
			,{header: '�Ա�', width: 70, dataIndex: 'myPatSex', sortable: true}
			,{header: '����', width: 70, dataIndex: 'PatType', sortable: true}
			,{header: 'ԤԼ����', width: 100, dataIndex: 'myAppLoc', sortable: true}
			,{header: 'ԤԼ��Ժ����', width: 100, dataIndex: 'myAppDate', sortable: true}
			,{header: '�㴲���Ա�', width: 100, dataIndex: 'AccompanySex', sortable: false}
			,{header: '����', width: 100, dataIndex: 'BedNo', sortable: false}
			,{header: '״̬', width: 100, dataIndex: 'IPStatus', sortable: true}
			,{header: '��ϵ�绰', width: 100, dataIndex: 'PatMobPhone', sortable: true}
			,{header: '��ͥ�绰', width: 100, dataIndex: 'TelH', sortable: true}
			//,{header: '��Ժ����', width: 100, dataIndex: 'IPDate', sortable: true}	
			,{header: 'סַ', width: 100, dataIndex: 'PatAddress', sortable: true}	
			,{header: '�ǼǺ�', width: 100, dataIndex: 'myPAPMINO', sortable: true}
		]
		,sm:obj.gridResultsm
		
	});
	// ,bbar: new Ext.PagingToolbar({
	// 		pageSize : 1000,
	// 		store : obj.gridResultStore,
	// 		displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
	// 		displayInfo: true,
	// 		emptyMsg: 'û�м�¼'
	// 	})
	obj.pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
		
			obj.ConditionPanel,
			obj.gridResult
		]
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			obj.pnScreen
			
		]
	});
	
	obj.CTLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.CTLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = obj.cboWard.getValue();
			//param.Arg4 = obj.CTHospital.getValue();
			param.Arg4 = "";
			param.ArgCnt = 4;
	 });
    //obj.CTLocStore.load({});
     
    obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = obj.CTLoc.getValue();
			//param.Arg4 = obj.CTHospital.getValue();
			param.Arg4 = "";
			param.ArgCnt = 4;
	});
	//obj.cboWardStore.load({}); 

	obj.CTDoctorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'FindCTCareProvByLoc';			
			param.Arg1 = obj.CTLoc.getValue();
			param.ArgCnt = 1;
	});
	 
	//obj.CTDoctorStore.load({}); 
	
    obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
	    
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'GetIPAppPatientList';
			param.Arg1 = obj.paadmadmno.getValue();
			param.Arg2 = obj.paadmno.getValue();
			param.Arg3 = obj.papminame.getValue();
			param.Arg4 = obj.registerStartDate.getRawValue();
			param.Arg5 = obj.registerEndDate.getRawValue();
			param.Arg6 = obj.orderInDate.getRawValue();
			param.Arg7 = obj.cboWard.getRawValue();
			param.Arg8 = obj.CTLoc.getRawValue();
			param.Arg9 = obj.CTDoctor.getRawValue();
			param.Arg10 = Ext.getCmp('IfAllocate').getValue();
			param.ArgCnt = 10; 
    });
    
 //    Ext.get('CTHospital').on('blur', function(){
	// 	obj.CTLocStore.load({});
	// 	obj.cboWardStore.load({});
	// });
    Ext.get('CTLoc').on('blur', function(){
		obj.cboWardStore.load({});
		obj.CTDoctorStore.load({});
	});
	Ext.get('cboWard').on('blur', function(){
		obj.CTLocStore.load({});
		obj.CTDoctorStore.load({});
	});
	
	//2014.04.25
	
	var HospitalId=session['LOGON.HOSPID'];
	// obj.CTHospitalStore.load({
	// 	callback : function() {
	// 		var HospitalObj=obj.CTHospitalStore.getById(HospitalId);
	// 		if (HospitalObj!=undefined) {
	// 			var HospitalDesc=HospitalObj.data.HosDesc;
	// 			Ext.getCmp("CTHospital").setValue(HospitalId);
	// 			Ext.getCmp("CTHospital").setRawValue(HospitalDesc);
	// 		}
	// 	}
	// });
	obj.IfAllocate.setValue("B");
	//obj.SortMethod.setValue(1);
	Ext.getCmp("SortMethod").setValue(1);
	Ext.getCmp("SortMethod").setRawValue("�Ǽ�ʱ��");
	//end
    
    Getmessage();
    
	//�¼��������
	InitviewScreenEvent(obj);
	obj.btnQuery_OnClick();
	obj.LoadEvent(arguments);
	return obj;
}

////�������
/*
function Getmessage()
{
var message=tkMakeServerCall("web.DHCBedManager","GetChangebedAppnum");
var Authstatus=tkMakeServerCall("web.DHCBedManager","GetAuthstatus");   //��ǰ��λȨ��״̬ 

if (message!="0")
{

//$.messager.show("<font color='red'>��Ϣ��ʾ</font>","<a href='DHCBedAuditingManager.csp' onclick='window.open('href','_blank','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')'>"+gg+"</a>",0);

//$.messager.show("<font color='red'>��Ϣ��ʾ</font>","<a href='#' onclick='BedAudit()'>"+message+"</a>",0);
$.messager.show("<font color='red'>"+Authstatus+"</font>","<a href='#' onclick='BedAudit()'>"+message+"</a>",0);

}
else
{
$.messager.show("<font color='red'>"+Authstatus+"</font>","<a href='#' onclick='BedAudit()'>"+"���޻�������"+"</a>",0);
}
setTimeout(Getmessage,30000);


}

function BedAudit()
{

var lnk='DHCBedAuditingManager.csp'
 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1890,height=680,left=120,top=0')
//window.close();
}
*/