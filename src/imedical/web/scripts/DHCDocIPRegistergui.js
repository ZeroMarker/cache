var IPBookID = "";
var IPAppID = "";
var PatientID = "";
var RegisterguiObject=new Object();
function InitviewScreen() {

	var obj = new Object();

	obj.PAPMIMedicare = new Ext.form.TextField({
		id: 'PAPMIMedicare',
		width: 100,
		anchor: '80%',
		fieldLabel: 'סԺ֤��'
	});

	obj.pConditionChild11 = new Ext.Panel({
		id: 'pConditionChild11',
		buttonAlign: 'center',
		columnWidth: .24,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAPMIMedicare]
	});

	obj.MedicalNo = new Ext.form.TextField({
		id: 'MedicalNo',
		width: 100,
		anchor: '80%',
		fieldLabel: '������'
	});
	obj.pConditionChild12 = new Ext.Panel({
		id: 'pConditionChild12',
		buttonAlign: 'center',
		columnWidth: .24,
		layout: 'form',
		items: [obj.MedicalNo]
	});

	obj.PAPMINo = new Ext.form.TextField({
		id: 'PAPMINo',
		width: 100,
		anchor: '80%',
		fieldLabel: '�ǼǺ�'
	});

	obj.GetNCSInfo = new Ext.Button({
		id: 'btnGetNCSInfo',
		//iconCls : 'icon-export',
		height: 25,
		text: '��ȡNCS��Ϣ'
	});

	obj.btnUpdateAllBed = new Ext.Button({
		id: 'btnUpdateAllBed'
			//,fieldLabel : ''
			//,anchor : '55%'
			//,hideLabel:true
			//,xtype: 'tbfill' 
			//,xtype : 'tbspacer'
			,
		height: 25,
		text: '���Ŵ�λȨ��'
			//,margins : {top:0, right:0, bottom:0, left:100}

	});

	// obj.btnCloseAllBed = new Ext.Button({
	// 	id : 'btnCloseAllBed'
	// 	//,anchor : '55%'
	// 	//,hideLabel:true
	// 	//,xtype: 'tbfill' 
	// 	//,xtype : 'tbspacer'
	// 	//,width : 100
	// 	,height : 25
	// 	,text : '�ջ�����Ȩ��'
	// 	//,margins : {top:0, right:0, bottom:0, left:100}

	// });


	obj.pConditionChild13 = new Ext.Panel({
		id: 'pConditionChild13',
		buttonAlign: 'center',
		columnWidth: .24,
		layout: 'form',
		items: [obj.PAPMINo]
	});
	obj.pConditionChild103 = new Ext.Panel({
		id: 'pConditionChild103',
		buttonAlign: 'center',
		columnWidth: .1,
		layout: 'form',
		items: [obj.GetNCSInfo]
	});
	obj.pConditionChild104 = new Ext.Panel({
		id: 'pConditionChild104',
		buttonAlign: 'center',
		columnWidth: .1,
		layout: 'form',
		items: [obj.btnUpdateAllBed]
	});


	///////////////
	var Authstatus = tkMakeServerCall("Nur.DHCBedManager", "GetAuthstatus");
	//alert("Authstatus=="+Authstatus);
	obj.pConditionChild14 = new Ext.Panel({
		id: 'pConditionChild14',
		buttonAlign: 'center',
		columnWidth: .08,
		layout: 'form',
		html: "<font color='red'>" + Authstatus + "</font>"
	});
	///////////////

	obj.pFieldSet1 = new Ext.form.FieldSet({
		id: 'pFieldSet1',
		buttonAlign: 'center',
		labelAlign: 'center',
		height: 47,
		layout: 'column',
		border: true,
		frame: true,
		anchor: '100%'
			//,labelWidth:100 //label�Ŀ��,�����Խ����Ŵ�����������
			,
		items: [obj.pConditionChild11,
			obj.pConditionChild12,
			obj.pConditionChild13,
			//obj.pConditionChild103,
			obj.pConditionChild104
			//obj.pConditionChild14

		]
	});

	obj.PAPMIName = new Ext.form.TextField({
		id: 'PAPMIName',
		width: 70,
		height: 25,
		anchor: '90%',
		fieldLabel: '����'
	});
	obj.pConditionChild21 = new Ext.Panel({
		id: 'pConditionChild21',
		buttonAlign: 'center'
			//,labelAligh:'center'
			//,labelWidth:70
			,
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPMIName]
	});

	obj.PAPMISexStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.PAPMISexStore = new Ext.data.Store({
		proxy: obj.PAPMISexStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'sexid'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'sexid',
			mapping: 'sexid'
		}, {
			name: 'sexdesc',
			mapping: 'sexdesc'
		}, {
			name: 'sexcode',
			mapping: 'sexcode'
		}])
	});

	obj.PAPMISex = new Ext.form.ComboBox({
		id: 'PAPMISex'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'sexdesc',
		fieldLabel: '�Ա�',
		store: obj.PAPMISexStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50,
		height: 25,
		anchor: '90%',
		valueField: 'sexid'
	});
	obj.PAPMISexStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.UDHCJFIPReg';
		param.QueryName = 'patsexlookup';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	 obj.PAPMISex = new Ext.form.TextField({
		id : 'PAPMISex' 
		,width : 50
		,height : 25
		,anchor : '90%'
		,fieldLabel : '�Ա�' 
	});
	*/
	obj.pConditionChild22 = new Ext.Panel({
		id: 'pConditionChild22',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPMISex]
	});
	obj.PAPMIAge = new Ext.form.TextField({
		id: 'PAPMIAge',
		width: 50,
		height: 25,
		anchor: '90%',
		fieldLabel: '����'
	});
	obj.pConditionChild23 = new Ext.Panel({
		id: 'pConditionChild23',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPMIAge]
	});
	obj.PAPMIDOB = new Ext.form.DateField({
		id: 'PAPMIDOB',
		//format: 'Y-m-d',
		width: 70,
		height: 25,
		fieldLabel: '��������',
		anchor: '90%',
		//altFormats: 'Y-m-d|d/m/Y'
			//value : new Date()
	});
	obj.pConditionChild24 = new Ext.Panel({
		id: 'pConditionChild24',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPMIDOB]
	});
	obj.PAPERID = new Ext.form.TextField({
		id: 'PAPERID',
		width: 125,
		height: 25,
		anchor: '90%',
		fieldLabel: '���֤��'
	});
	obj.pConditionChild25 = new Ext.Panel({
		id: 'pConditionChild25',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .4,
		layout: 'form',
		items: [obj.PAPERID]
	});

	obj.PAPERNationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.PAPERNationStore = new Ext.data.Store({
		proxy: obj.PAPERNationStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'nationidid'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'nationidid',
			mapping: 'nationidid'
		}, {
			name: 'nation',
			mapping: 'nation'
		}])
	});

	obj.PAPERNation = new Ext.form.ComboBox({
		id: 'PAPERNation'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'nation',
		fieldLabel: '����',
		store: obj.PAPERNationStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 70,
		height: 25,
		anchor: '90%',
		valueField: 'nationidid'
	});
	obj.PAPERNationStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.UDHCJFIPReg';
		param.QueryName = 'nationlookup';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	obj.PAPERNation = new Ext.form.TextField({
		id : 'PAPERNation' 
		,width : 70
		,height : 25
		,anchor : '90%'
		,fieldLabel : '����' 
		//,boxMinHeight : 100
	});
	*/
	obj.pConditionChild31 = new Ext.Panel({
		id: 'pConditionChild31',
		buttonAlign: 'center',
		labelAligh: 'center',
		labelWidth: 70,
		columnWidth: .15,
		layout: 'form',
		items: [obj.PAPERNation]
	});

	obj.PAPERMaritalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.PAPERMaritalStore = new Ext.data.Store({
		proxy: obj.PAPERMaritalStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'Code',
			mapping: 'Code'
		}, {
			name: 'Description',
			mapping: 'Description'
		}])
	});

	obj.PAPERMarital = new Ext.form.ComboBox({
		id: 'PAPERMarital'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'Description',
		fieldLabel: '����',
		store: obj.PAPERMaritalStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50,
		height: 25,
		anchor: '90%',
		valueField: 'Code'
	});
	obj.PAPERMaritalStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.CTMarital';
		param.QueryName = 'LookUpNC';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	 obj.PAPERMarital = new Ext.form.TextField({
		id : 'PAPERMarital' 
		,width : 50
		,height : 25
		,anchor : '90%'
		,fieldLabel : '����' 
	});
	*/
	obj.pConditionChild32 = new Ext.Panel({
		id: 'pConditionChild32',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .15,
		layout: 'form',
		items: [obj.PAPERMarital]
	});

	obj.PAPEROccupationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.PAPEROccupationStore = new Ext.data.Store({
		proxy: obj.PAPEROccupationStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'occupationid'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'occupationid',
			mapping: 'occupationid'
		}, {
			name: 'occupation',
			mapping: 'occupation'
		}])
	});

	obj.PAPEROccupation = new Ext.form.ComboBox({
		id: 'PAPEROccupation'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'occupation',
		fieldLabel: 'ְҵ',
		store: obj.PAPEROccupationStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50,
		height: 25,
		anchor: '90%',
		valueField: 'occupationid'
	});
	obj.PAPEROccupationStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.UDHCJFIPReg';
		param.QueryName = 'occulookup';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	obj.PAPEROccupation = new Ext.form.TextField({
		id : 'PAPEROccupation' 
		,width : 50
		,height : 25
		,anchor : '90%'
		,fieldLabel : 'ְҵ' 
	});
	*/
	obj.pConditionChild33 = new Ext.Panel({
		id: 'pConditionChild33',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .15,
		layout: 'form',
		items: [obj.PAPEROccupation]
	});

	obj.PAPERBirthPlace = new Ext.form.TextField({
		id: 'PAPERBirthPlace',
		width: 80,
		height: 25,
		anchor: '90%',
		fieldLabel: '����'
	});

	obj.pConditionChild34 = new Ext.Panel({
		id: 'pConditionChild34',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPERBirthPlace]
	});

	obj.PAPERSocialStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.PAPERSocialStatusStore = new Ext.data.Store({
		proxy: obj.PAPERSocialStatusStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'RowId',
			mapping: 'RowId'
		}, {
			name: 'Desc',
			mapping: 'Desc'
		}])
	});

	obj.PAPERSocialStatus = new Ext.form.ComboBox({
		id: 'PAPERSocialStatus'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'Desc',
		fieldLabel: '��������',
		store: obj.PAPERSocialStatusStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50,
		height: 25,
		anchor: '100%',
		valueField: 'RowId'
	});
	obj.PAPERSocialStatusStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'GetPatType';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	obj.PAPERSocialStatus = new Ext.form.TextField({
		id : 'PAPERSocialStatus' 
		,width : 50
		,height : 25
		,anchor : '90%'
		,fieldLabel : '��������' 
	});
	*/
	obj.pConditionChild35 = new Ext.Panel({
		id: 'pConditionChild35',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .2,
		layout: 'form',
		items: [obj.PAPERSocialStatus]
	});
	obj.PAPERMobPhone = new Ext.form.TextField({
		id: 'PAPERMobPhone',
		width: 125,
		height: 25,
		anchor: '86%',
		fieldLabel: '��ϵ�绰'
	});
	obj.pConditionChild36 = new Ext.Panel({
		id: 'pConditionChild36',
		buttonAlign: 'center',
		labelAligh: 'center',
		columnWidth: .3,
		layout: 'form',
		items: [obj.PAPERMobPhone]
	});
	obj.PAPERNokName = new Ext.form.TextField({
		id: 'PAPERNokName',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '������λ'
	});
	obj.pConditionChild41 = new Ext.Panel({
		id: 'pConditionChild41',
		buttonAlign: 'center',
		columnWidth: .33,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAPERNokName]
	});
	obj.PAPERNokAddress = new Ext.form.TextField({
		id: 'PAPERNokAddress',
		width: 100,
		height: 25,
		anchor: '93.5%',
		fieldLabel: '��λ��ַ'
	});
	obj.pConditionChild42 = new Ext.Panel({
		id: 'pConditionChild42',
		buttonAlign: 'center',
		columnWidth: .32,
		layout: 'form',
		items: [obj.PAPERNokAddress]
	});
	obj.PAPERNokPhone = new Ext.form.NumberField({
		id: 'PAPERNokPhone',
		width: 100,
		height: 25,
		anchor: '80%',
		fieldLabel: '��λ�绰'
	});
	obj.pConditionChild43 = new Ext.Panel({
		id: 'pConditionChild43',
		buttonAlign: 'center',
		columnWidth: .34,
		layout: 'form',
		items: [obj.PAPERNokPhone]
	});

	obj.RegisterPlace = new Ext.form.TextField({
		id: 'RegisterPlace',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '���ڵ�ַ'
	});
	obj.pConditionChild51 = new Ext.Panel({
		id: 'pConditionChild51',
		buttonAlign: 'center',
		columnWidth: .33,
		labelWidth: 70,
		layout: 'form',
		items: [obj.RegisterPlace]
	});
	obj.Address = new Ext.form.TextField({
		id: 'Address',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: 'סַ'
	});
	obj.pConditionChild52 = new Ext.Panel({
		id: 'pConditionChild52',
		buttonAlign: 'center',
		columnWidth: .5,
		layout: 'form',
		items: [obj.Address]
	});
	obj.TelH = new Ext.form.TextField({
		id: 'TelH',
		width: 100,
		height: 25,
		anchor: '80%',
		fieldLabel: '��ͥ�绰'
	});
	obj.pConditionChild53 = new Ext.Panel({
		id: 'pConditionChild53',
		buttonAlign: 'center',
		columnWidth: .3,
		layout: 'form',
		items: [obj.TelH]
	});
	obj.PAPERForeignName = new Ext.form.TextField({
		id: 'PAPERForeignName',
		width: 70,
		height: 25,
		anchor: '90%',
		fieldLabel: '��ϵ������'
	});
	obj.pConditionChild61 = new Ext.Panel({
		id: 'pConditionChild61',
		buttonAlign: 'center',
		columnWidth: .2,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAPERForeignName]
	});
	obj.PAPERForeignAddress = new Ext.form.TextField({
		id: 'PAPERForeignAddress',
		width: 200,
		height: 25,
		anchor: '90%',
		fieldLabel: '��ϵ�˵�ַ'
	});
	obj.pConditionChild62 = new Ext.Panel({
		id: 'pConditionChild62',
		buttonAlign: 'center',
		columnWidth: .3,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAPERForeignAddress]
	});
	obj.PAPERForeignPhone = new Ext.form.NumberField({
		id: 'PAPERForeignPhone',
		width: 150,
		height: 25,
		anchor: '90%',
		fieldLabel: '��ϵ�˵绰'
	});
	obj.pConditionChild63 = new Ext.Panel({
		id: 'pConditionChild63',
		buttonAlign: 'center',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAPERForeignPhone]
	});

	obj.CTRelationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.CTRelationStore = new Ext.data.Store({
		proxy: obj.CTRelationStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctrltid'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'ctrltid',
			mapping: 'ctrltid'
		}, {
			name: 'ctrlt',
			mapping: 'ctrlt'
		}])
	});

	obj.CTRelation = new Ext.form.ComboBox({
		id: 'CTRelation'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'ctrlt',
		fieldLabel: '��ϵ',
		store: obj.CTRelationStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 70,
		height: 25,
		anchor: '90%',
		valueField: 'ctrltid'
	});
	obj.CTRelationStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.UDHCJFIPReg';
		param.QueryName = 'ctrltlookup';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	/*
	obj.CTRelation = new Ext.form.TextField({
		id : 'CTRelation' 
		,width : 70
		,height : 25
		,anchor : '90%'
		,fieldLabel : '��ϵ' 
	});
	*/
	obj.pConditionChild64 = new Ext.Panel({
		id: 'pConditionChild64',
		buttonAlign: 'center',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.CTRelation]
	});

	obj.pFieldSet2 = new Ext.form.FieldSet({
		id: 'pFieldSet2',
		title: '���˻�����Ϣ',
		buttonAlign: 'center',
		labelAlign: 'right'
			//,boxMinHeight : 100
			,
		height: 150,
		layout: 'column',
		border: true,
		frame: true,
		anchor: '100%',

			//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
		items: [obj.pConditionChild21, obj.pConditionChild25, obj.pConditionChild22, obj.pConditionChild23, obj.pConditionChild24

			/*,obj.pConditionChild31
			,obj.pConditionChild32
			,obj.pConditionChild33
			,obj.pConditionChild34*/
			, obj.pConditionChild35, obj.pConditionChild36
			/*,obj.pConditionChild41
			,obj.pConditionChild42
			,obj.pConditionChild43
			,obj.pConditionChild51*/
			, obj.pConditionChild53, obj.pConditionChild52

			/*,obj.pConditionChild61
			,obj.pConditionChild62
			,obj.pConditionChild63
			,obj.pConditionChild64*/
		]
	});

	obj.PAINSCardNo = new Ext.form.NumberField({
		id: 'PAINSCardNo',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: 'ƾ֤����'
	});
	obj.pConditionChild71 = new Ext.Panel({
		id: 'pConditionChild71',
		buttonAlign: 'center',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.PAINSCardNo]
	});
	obj.socialSecurityNo = new Ext.form.NumberField({
		id: 'socialSecurityNo',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '�籣��'
	});
	obj.pConditionChild72 = new Ext.Panel({
		id: 'pConditionChild72',
		buttonAlign: 'center',
		columnWidth: .25,
		layout: 'form',
		items: [obj.socialSecurityNo]
	});
	obj.AdmInsuranceType = new Ext.form.TextField({
		id: 'AdmInsuranceType',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '��ְ����'
	});
	obj.pConditionChild73 = new Ext.Panel({
		id: 'pConditionChild73',
		buttonAlign: 'center',
		labelAligh: 'right',
		labelWidth: 70,
		columnWidth: .25,
		layout: 'form',
		items: [obj.AdmInsuranceType]
	});
	obj.guaranteeName = new Ext.form.TextField({
		id: 'guaranteeName',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '������'
	});
	obj.pConditionChild74 = new Ext.Panel({
		id: 'pConditionChild64',
		buttonAlign: 'center',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.guaranteeName]
	});

	obj.guaranteeEntity = new Ext.form.TextField({
		id: 'guaranteeEntity'
			//,width : 200
			,
		height: 25,
		anchor: '95%',
		fieldLabel: '��������'
	});
	obj.pConditionChild81 = new Ext.Panel({
		id: 'pConditionChild81',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.guaranteeEntity]
	});
	obj.guaranteePhone = new Ext.form.NumberField({
		id: 'guaranteePhone',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '�����˵绰'
	});
	obj.pConditionChild82 = new Ext.Panel({
		id: 'pConditionChild82',
		buttonAlign: 'center',
		labelAligh: 'right',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.guaranteePhone]
	});
	obj.guaranteeRelation = new Ext.form.TextField({
		id: 'guaranteeRelation',
		width: 100,
		height: 25,
		anchor: '90%',
		fieldLabel: '������ϵ'
	});
	obj.pConditionChild83 = new Ext.Panel({
		id: 'pConditionChild83',
		buttonAlign: 'center',
		columnWidth: .25,
		labelWidth: 70,
		layout: 'form',
		items: [obj.guaranteeRelation]
	});

	obj.pFieldSet3 = new Ext.form.FieldSet({
		id: 'pFieldSet3',
		title: 'ҽ����Ϣ',
		buttonAlign: 'center',
		labelAlign: 'right'
			//,boxMinHeight : 100
			,
		height: 90,
		layout: 'column',
		border: true,
		frame: true,
		anchor: '100%'
			//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
			,
		items: [obj.pConditionChild71, obj.pConditionChild72, obj.pConditionChild73, obj.pConditionChild74, obj.pConditionChild81, obj.pConditionChild82, obj.pConditionChild83]
	});

	obj.CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.CTLocStore = new Ext.data.Store({
		proxy: obj.CTLocStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'CTLocID',
			mapping: 'CTLocID'
		}, {
			name: 'CTLocCode',
			mapping: 'CTLocCode'
		}, {
			name: 'CTLocDesc',
			mapping: 'CTLocDesc'
		}])
	});
	obj.CTLoc = new Ext.form.ComboBox({
		id: 'CTLoc'
			//,width : 100
			,
		store: obj.CTLocStore,
		hiddenName: 'CTLocID',
		minChars: 1,
		displayField: 'CTLocDesc'
			//,fieldLabel : 'סԺ����'
			,
		fieldLabel: '<span style="color:red;">סԺ����</span>',
		editable: true,
		triggerAction: 'all'
			//,mode : 'remote' //Ϊ��ҳ��׼��
			//,pageSize : 5 //ÿҳ��ʾ�ļ�¼����
			//,minListWidth : 220 //��ҳ������С��ȣ�������ܲ�����ʾ�����ķ�ҳ��
			,
		anchor: '90%',
		valueField: 'CTLocID'
	});
	obj.pConditionChild91 = new Ext.Panel({
		id: 'pConditionChild91',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.CTLoc]
	});
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'CTLocID',
			mapping: 'CTLocID'
		}, {
			name: 'CTLocCode',
			mapping: 'CTLocCode'
		}, {
			name: 'CTLocDesc',
			mapping: 'CTLocDesc'
		}])
	});
	obj.cboWard = new Ext.form.ComboBox({
		id: 'cboWard'
			//,width : 100
			,
		minChars: 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
			//,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
			//,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
			,
		store: obj.cboWardStore,
		hiddenName: 'CTLocID',
		displayField: 'CTLocDesc'
			//,fieldLabel : 'סԺ����'
			,
		fieldLabel: '<span style="color:red;">סԺ����</span>',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		triggerAction: 'all' //�������������ʱ��Ҫִ�еĲ�����
			,
		anchor: '90%',
		valueField: 'CTLocID'
	});
	obj.pConditionChild92 = new Ext.Panel({
		id: 'pConditionChild92',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.cboWard]
	});

	obj.relevance = new Ext.form.CheckboxGroup({
		id: 'relevance',
		xtype: 'checkboxgroup'
			//,width : 150
			,
		anchor: '90%',
		items: [{
			boxLabel: '�����벡������',
			name: 'relevance',
			checked: true
		}]
	});
	obj.pConditionChild95 = new Ext.Panel({
		id: 'pConditionChild95',
		buttonAlign: 'center',
		columnWidth: 1,
		labelWidth: 70,
		layout: 'form',
		items: [obj.relevance]
	});

	obj.CTDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.CTDoctorStore = new Ext.data.Store({
		proxy: obj.CTDoctorStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'CTPCPRowId',
			mapping: 'CTPCPRowId'
		}, {
			name: 'CTPCPCode',
			mapping: 'CTPCPCode'
		}, {
			name: 'CTPCPDesc',
			mapping: 'CTPCPDesc'
		}])
	});

	obj.CTDoctor = new Ext.form.ComboBox({
		id: 'CTDoctor'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'CTPCPDesc',
		fieldLabel: 'ԤԼҽ��',
		store: obj.CTDoctorStore,
		hiddenName: 'CTPCPRowId',
		width: 100
			//,mode : 'local'  //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		anchor: '90%',
		valueField: 'CTPCPRowId'
	});
	obj.pConditionChild93 = new Ext.Panel({
		id: 'pConditionChild93',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.CTDoctor]
	});

	obj.orderInDate = new Ext.form.DateField({
		id: 'orderInDate',
		//format: 'Y-m-d',
		width: 100,
		//fieldLabel : '��֤����',  //ͬ�������޸� ԤԼ����=>��֤����
		fieldLabel: '<span style="color:red;">ԤԼ����</span>',
		anchor: '90%',
		//altFormats: 'Y-m-d|d/m/Y' //,
			//value : new Date()
	});
	obj.pConditionChild94 = new Ext.Panel({
		id: 'pConditionChild94',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.orderInDate]
	});

	obj.advancePayment = new Ext.form.NumberField({
		id: 'advancePayment',
		width: 100
			//,height : 25
			,
		anchor: '90%',
		fieldLabel: 'Ԥ��Ѻ��'
	});
	obj.pConditionChild01 = new Ext.Panel({
		id: 'pConditionChild01',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.advancePayment]
	});

	obj.specialtyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.specialtyStore = new Ext.data.Store({
		proxy: obj.specialtyStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'TMURowid',
			mapping: 'TMURowid'
		}, {
			name: 'TCTMUCode',
			mapping: 'TCTMUCode'
		}, {
			name: 'TCTMUDesc',
			mapping: 'TCTMUDesc'
		}])
	});

	obj.specialty = new Ext.form.ComboBox({
		id: 'specialty'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'TCTMUDesc',
		fieldLabel: 'רҵ',
		store: obj.specialtyStore
			//,mode : 'local'  //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		anchor: '90%',
		valueField: 'TMURowid'
	});

	obj.pConditionChild02 = new Ext.Panel({
		id: 'pConditionChild02',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.specialty]
	});
	/*
	obj.TreatLevelStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['O', '����'],['E', '����']]
	});
	*/
	obj.TreatLevelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.TreatLevelStore = new Ext.data.Store({
		proxy: obj.TreatLevelStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'RowId',
			mapping: 'RowId'
		}, {
			name: 'Desc',
			mapping: 'Desc'
		}])
	});

	obj.TreatLevel = new Ext.form.ComboBox({
		id: 'TreatLevel',
		width: 100,
		store: obj.TreatLevelStore,
		minChars: 1,
		triggerAction: 'all',
		displayField: 'Desc',
		fieldLabel: '���Ｖ��',
		editable: true,
		triggerAction: 'all',
		anchor: '90%',
		valueField: 'RowId',
		mode: "local"
	});

	obj.TreatLevelStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'GetAcuityList';
		param.ArgCnt = 0;
	});
	/*
	obj.bedNo = new Ext.form.NumberField({
		id : 'bedNo' 
		,width : 100
		,height : 25
		,anchor : '90%'
		,fieldLabel : '���˴���' 
	});
	*/
	obj.pConditionChild03 = new Ext.Panel({
		id: 'pConditionChild03',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.TreatLevel] //obj.bedNo
	});

	obj.CTHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.CTHospitalStore = new Ext.data.Store({
		proxy: obj.CTHospitalStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HosCode'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'HosDesc',
			mapping: 'HosDesc'
		}, {
			name: 'HosCode',
			mapping: 'HosCode'
		}])
	});

	obj.CTHospital = new Ext.form.ComboBox({
		id: 'CTHospital'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'HosDesc',
		fieldLabel: 'ԤԼԺ��',
		store: obj.CTHospitalStore
			//,mode : 'local'  //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		anchor: '90%',
		valueField: 'HosCode'
	});
	obj.pConditionChild04 = new Ext.Panel({
		id: 'pConditionChild04',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.CTHospital]
	});

	////�㴲���Ա�
	obj.IfAccompany = new Ext.form.CheckboxGroup({
		id: 'IfAccompany',
		xtype: 'checkboxgroup'
			//,width : 150
			,
		anchor: '90%',
		items: [{
			boxLabel: '�Ƿ���Ҫ�㴲',
			name: 'IfAccompany'
		}]
	});
	obj.pConditionChild05 = new Ext.Panel({
		id: 'pConditionChild05',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.IfAccompany]
	});
	obj.AccompanySexStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.AccompanySexStore = new Ext.data.Store({
		proxy: obj.AccompanySexStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'sexid'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'sexid',
			mapping: 'sexid'
		}, {
			name: 'sexdesc',
			mapping: 'sexdesc'
		}, {
			name: 'sexcode',
			mapping: 'sexcode'
		}])
	});

	obj.AccompanySex = new Ext.form.ComboBox({
		id: 'AccompanySex'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'sexdesc',
		fieldLabel: '�㴲���Ա�',
		store: obj.AccompanySexStore,
		mode: 'local' //remote
			,
		typeAhead: true,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50
			//,height : 25
			,
		anchor: '90%',
		valueField: 'sexid'
	});
	obj.AccompanySexStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.UDHCJFIPReg';
		param.QueryName = 'patsexlookup';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	obj.pConditionChild06 = new Ext.Panel({
		id: 'pConditionChild06',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.AccompanySex]
	});
	////end

	///���
	//obj.MRDiagnos = new
	obj.MRDiagnosStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url: ExtToolSetting.RunQueryPageURL
	}));
	obj.MRDiagnosStore = new Ext.data.Store({
		proxy: obj.MRDiagnosStoreProxy,
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HIDDEN'
		}, [{
			name: 'checked',
			mapping: 'checked'
		}, {
			name: 'HIDDEN',
			mapping: 'HIDDEN'
		}, {
			name: 'desc',
			mapping: 'desc'
		}, {
			name: 'code',
			mapping: 'code'
		}])
	});

	obj.MRDiagnos = new Ext.form.ComboBox({
		id: 'MRDiagnos'
			//,selectOnFocus : true
			//,forceSelection : true
			,
		minChars: 1,
		displayField: 'desc',
		fieldLabel: '���',
		store: obj.MRDiagnosStore
			//,mode : 'local'  //remote
			//,typeAhead : true
			,
		triggerAction: 'all',
		editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
			,
		width: 50
			//,height : 25
			,
		anchor: '90%',
		valueField: 'HIDDEN'
	});
	obj.MRDiagnosStoreProxy.on('beforeload', function(objProxy, param) {

		if (obj.MRDiagnos.getRawValue() != "") {
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName = 'LookUpWithAlias';
			param.Arg1 = obj.MRDiagnos.getRawValue();
			param.Arg2 = '';
			param.Arg3 = '';
			param.Arg4 = '';
			param.ArgCnt = 4;
		}
	});
	obj.pConditionChild07 = new Ext.Panel({
		id: 'pConditionChild07',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.MRDiagnos]
	});
	///end

	/// ��֤����
	obj.acceptDate = new Ext.form.DateField({
		id: 'acceptDate',
		//format: 'Y-m-d',
		width: 100,
		fieldLabel: '��֤����',
		anchor: '90%',
		//altFormats: 'Y-m-d|d/m/Y' //,
			//value : new Date()
	});
	obj.pConditionChild08 = new Ext.Panel({
		id: 'pConditionChild08',
		buttonAlign: 'center',
		columnWidth: .5,
		labelWidth: 70,
		layout: 'form',
		items: [obj.acceptDate]
	});
	/// end

	obj.pFieldSet4 = new Ext.form.FieldSet({
		id: 'pFieldSet4',
		title: 'ԤԼ��Ϣ',
		buttonAlign: 'center',
		labelAlign: 'right'
			//,boxMinHeight : 100
			,
		height: 250
			//,width : 100
			,
		layout: 'column',
		border: true,
		frame: true,
		anchor: '100%'
			//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
			,
		items: [obj.pConditionChild95, obj.pConditionChild91, obj.pConditionChild92, obj.pConditionChild93, obj.pConditionChild94, obj.pConditionChild01, obj.pConditionChild02, obj.pConditionChild03, obj.pConditionChild05, obj.pConditionChild06, obj.pConditionChild07, obj.pConditionChild08 // ��֤����
		//items: [obj.pConditionChild95, obj.pConditionChild91, obj.pConditionChild92, obj.pConditionChild93, obj.pConditionChild94, obj.pConditionChild01, obj.pConditionChild02, obj.pConditionChild04, obj.pConditionChild03, obj.pConditionChild05, obj.pConditionChild06, obj.pConditionChild07, obj.pConditionChild08 // ��֤����
		]
	});

	obj.btnTransferInpCard = new Ext.Button({
		id: 'btnTransferInpCard',
		height: 25,
		//iconCls : 'icon-find',
		text: '��סԺ֤'
	});

	obj.btnTransferFiles = new Ext.Button({
		id: 'btnTransferFiles',
		//iconCls : 'icon-export',
		height: 25,
		text: '����'
	});
	obj.btnReadCard = new Ext.Button({
		id: 'btnReadCard',
		//iconCls : 'icon-find',
		height: 25,
		text: '����'
	});
	obj.btnReset = new Ext.Button({
		id: 'btnReset',
		//iconCls : 'icon-export',
		height: 25,
		text: '����'
	});
	obj.btnSave = new Ext.Button({
		id: 'btnSave',
		//iconCls : 'icon-find',
		height: 25,
		text: '����'
	});
	obj.btnSaveAndPrint = new Ext.Button({
		id: 'btnSaveAndPrint',
		//iconCls : 'icon-export',
		height: 25,
		text: '���沢��ӡ'
	});

	//alert(document.body.clientHeight)
	obj.ConditionPanel = new Ext.form.FormPanel({
		id: 'ConditionPanel',
		buttonAlign: 'center', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
		labelAlign: 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
		labelWidth: 60,
		bodyBorder: false,
		border: true,
		layout: 'form',
		frame: true,
		width: "auto",
		height: document.body.clientHeight,
		anchor: '100%',
		title: winTitle,
		items: [
			obj.pFieldSet1, obj.pFieldSet2
			//,obj.pFieldSet3
			, obj.pFieldSet4
		],
		buttons: [
			obj.btnTransferInpCard, obj.btnTransferFiles, obj.btnReadCard, obj.btnReset, obj.btnSave
			//,obj.btnSaveAndPrint
		]
	});

	obj.ConditionPanel.render(document.body)
	// obj.pnScreen = new Ext.Panel({
	// 	id: 'pnScreen',
	// 	buttonAlign: 'center',
	// 	frame: true,
	// 	layout: 'border',
	// 	items: [
	// 		obj.ConditionPanel
	// 	]
	// });

	// obj.viewScreen = new Ext.Viewport({
	// 	id: 'viewScreen',
	// 	frame: true,
	// 	layout: 'fit',
	// 	items: [
	// 		obj.pnScreen

	// 	]
	// });

	RegisterguiObject=obj;

	obj.CTLocStoreProxy.on('beforeload', function(objProxy, param) {
		var cboWardId = "";
		if (obj.relevance.items.itemAt(0).checked) {
			cboWardId = obj.cboWard.getValue();
		}
		var hospitalId = session['LOGON.HOSPID'];
		if (obj.CTHospital.getValue() != "") {
			hospitalId = obj.CTHospital.getValue();
		}
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.CTLoc.getRawValue();
		param.Arg2 = 'E';
		param.Arg3 = cboWardId;
		param.Arg4 = hospitalId;
		param.ArgCnt = 4;
	});
	//obj.CTLocStore.load({});

	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param) {
		var CTLocId = "";
		if (obj.relevance.items.itemAt(0).checked) {
			CTLocId = obj.CTLoc.getValue();
		}
		var hospitalId = session['LOGON.HOSPID'];
		if (obj.CTHospital.getValue() != "") {
			hospitalId = obj.CTHospital.getValue();
		}
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.cboWard.getRawValue();
		param.Arg2 = 'W';
		param.Arg3 = CTLocId;
		param.Arg4 = hospitalId;
		param.ArgCnt = 4;
	});
	//obj.cboWardStore.load({}); 

	obj.CTDoctorStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'FindCTCareProvByLoc';
		param.Arg1 = obj.CTLoc.getValue();
		param.ArgCnt = 1;
	});

	obj.CTHospitalStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'Nur.DHCBedManager';
		param.QueryName = 'GetHospital';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});

	obj.CTDoctorStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'FindCTCareProvByLoc';
		param.Arg1 = obj.CTLoc.getValue();
		param.ArgCnt = 1;
	});

	//////רҵ//////
	obj.specialtyStoreProxy.on('beforeload', function(objProxy, param) {

		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'GetLocMedUnit';
		param.Arg1 = obj.CTLoc.getValue();
		param.ArgCnt = 1;
	});
	////////////////

	Ext.get('CTLoc').on('blur', function() {
		obj.cboWardStore.load({});
		obj.CTDoctorStore.load({});
	});
	Ext.get('cboWard').on('blur', function() {
		obj.CTLocStore.load({});
		obj.CTDoctorStore.load({});
	});

	Ext.get('PAPMIAge').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {
			var PAPMIDOB = Ext.get('PAPMIDOB').getValue();
			if (PAPMIDOB == "") {
				var CurrentDate = new Date();
				var CurrentYear = CurrentDate.getFullYear();
				var PAPMIAge = Ext.getCmp('PAPMIAge').getValue();
				var DOBYear = CurrentYear - PAPMIAge;
				var DOB = DOBYear + "-01-01";
				Ext.getCmp("PAPMIDOB").setValue(DOB);
			}
		}
	});

	Ext.get('MedicalNo').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {
			var MedicalNo = Ext.get("MedicalNo").getValue();
			//alert("MedicalNo=="+MedicalNo);
			Ext.Ajax.request({
				url: 'DHCDocIPAppointmentdata.csp',
				params: {
					action: 'GetPatInfoByMedicalNo',
					MedicalNo: MedicalNo
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);

					if (jsonData.PatInfo != '') {
						//alert(jsonData.PatInfo)
						var PatInfoStr = jsonData.PatInfo.split("$")[0];
						var BookInfoStr = jsonData.PatInfo.split("$")[1];
						var PAPMINo = jsonData.PatInfo.split("$")[2].toString();
						Ext.getCmp("PAPMINo").setValue(PAPMINo);
						//�������Ա����䡢�������ڡ����֤�š����塢����״����ְҵ�����ᡢ�������͡�������λ����λ��ַ����λ�绰�����ڵ�ַ��סַ����ϵ����������ϵ�˵�ַ����ϵ�˵绰
						var PatInfoArr = PatInfoStr.split("^");
						PatientID = PatInfoArr[0];
						Ext.getCmp("PAPMIName").setValue(PatInfoArr[1]);
						Ext.getCmp("PAPMISex").setValue(PatInfoArr[2]);
						Ext.getCmp("PAPMIAge").setValue(PatInfoArr[3]);
						Ext.getCmp("PAPMIDOB").setValue(PatInfoArr[4]);
						Ext.getCmp("PAPERID").setValue(PatInfoArr[5]);
						Ext.getCmp("PAPERNation").setValue(PatInfoArr[6]);
						Ext.getCmp("PAPERMarital").setValue(PatInfoArr[7]);
						Ext.getCmp("PAPEROccupation").setValue(PatInfoArr[8]);
						Ext.getCmp("PAPERBirthPlace").setValue(PatInfoArr[9]);
						Ext.getCmp("PAPERSocialStatus").setValue(PatInfoArr[10]);
						Ext.getCmp("PAPERNokName").setValue(PatInfoArr[11]);
						Ext.getCmp("PAPERNokAddress").setValue(PatInfoArr[12]);
						Ext.getCmp("PAPERNokPhone").setValue(PatInfoArr[13]);
						Ext.getCmp("RegisterPlace").setValue(PatInfoArr[14]);
						Ext.getCmp("Address").setValue(PatInfoArr[15]);
						Ext.getCmp("PAPERForeignName").setValue(PatInfoArr[16]);
						Ext.getCmp("PAPERForeignAddress").setValue(PatInfoArr[17]);
						Ext.getCmp("PAPERForeignPhone").setValue(PatInfoArr[18]);
						Ext.getCmp("MedicalNo").setValue(PatInfoArr[19]);
						Ext.getCmp("PAPERMobPhone").setValue(PatInfoArr[20]);
						Ext.getCmp("TelH").setValue(PatInfoArr[21]);

						//zhenduan
						Ext.getCmp("MRDiagnos").setValue(PatInfoArr[22]);
						if (PatInfoArr[22] != "") {
							Ext.getCmp('MRDiagnos').disable();
						}

						//סԺ���ҡ�סԺ������ԤԼҽ����ԤԼ���ڡ�Ԥ��Ѻ��רҵ�Ͳ��˴�λָ��
						var BookInfoArr = BookInfoStr.split("^");
						//alert(BookInfoStr);
						IPBookID = BookInfoArr[0];
						IPAppID = BookInfoArr[1];
						if (BookInfoArr[2] != "") {
							var AppLoc = RegisterguiObject.CTLocStore.getById(BookInfoArr[2]);
							var CTLocDesc = AppLoc.data.CTLocDesc;
							//Ext.getCmp("CTLoc").setValue(AppLoc.data.CTLocDesc);
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue(CTLocDesc);
						} else {
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue("");
						}
						if (BookInfoArr[3] != "") {
							var AppWard = RegisterguiObject.cboWardStore.getById(BookInfoArr[3]);
							var WardDesc = AppWard.data.CTLocDesc;
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue(WardDesc);
						} else {
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue("");
						}
						RegisterguiObject.CTDoctorStore.load({
							callback: function() {
								if (BookInfoArr[4] != "") {
									var AppDoc = RegisterguiObject.CTDoctorStore.getById(BookInfoArr[4]);
									if (AppDoc != undefined) {
										var CTPCPDesc = AppDoc.data.CTPCPDesc;
										Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
										Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
									}
								} else {
									Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
									Ext.getCmp("CTDoctor").setRawValue("");
								}
							}
						});
						/*
						if(BookInfoArr[4]!="") {
							var AppDoc=obj.CTDoctorStore.getById(BookInfoArr[4]);
							if (AppDoc!=undefined) {
								var CTPCPDesc=AppDoc.data.CTPCPDesc;
								Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
								Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
							}
						}else {
							Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
							Ext.getCmp("CTDoctor").setRawValue("");
						}
						*/
						Ext.getCmp("orderInDate").setValue(BookInfoArr[5]);
						Ext.getCmp("advancePayment").setValue(BookInfoArr[6]);
						if (BookInfoArr[7] != "") {
							var Specialty = RegisterguiObject.specialtyStore.getById(BookInfoArr[7]);
							var SpecialtyDesc = Specialty.data.TCTMUDesc;
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue(SpecialtyDesc);
						} else {
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue("");
						}
						//Ext.getCmp("bedNo").setValue(BookInfoArr[8]);
						if (BookInfoArr[9] != "") {
							var TreatLevel = RegisterguiObject.TreatLevelStore.getById(BookInfoArr[9]);
							var TreatLevelDesc = TreatLevel.data.Desc;
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							Ext.getCmp("TreatLevel").setRawValue(TreatLevelDesc);
						} else {
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							Ext.getCmp("TreatLevel").setRawValue("");
						}
					}

				},
				scope: this
			});
		}
	});

	Ext.get('PAPMINo').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {
			GetPatInfoByPAPMINo();
		}
	});

	Ext.get('PAPMIName').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {
			var PAPMIName = Ext.getCmp('PAPMIName').getValue();
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPAPERInfo&PAPERName=" + PAPMIName + "&PAPERNo=" + "&PAPERRowid=" + "&Sex=" + "&SexDr=" + "&PAPERID=" + "&BirthDate=" + "&InsuNo=";
			win = open(lnk, "UDHCJFIPReg", "scrollbars=1,top=100,left=10,width=1000,height=600");
		}
	});

	Ext.get('PAPERID').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {
			var PAPERID = Ext.get("PAPERID").getValue();
			if (PAPERID.length == 18) {

				var Year = PAPERID.substring(6, 10);
				var Month = PAPERID.substring(10, 12);
				var Day = PAPERID.substring(12, 14);
				var PAPMIDOB = Year + "-" + Month + "-" + Day;
				Ext.getCmp("PAPMIDOB").setValue(PAPMIDOB);
				var Sex = PAPERID.substring(16, 17) % 2;
				if (Sex == 0) {
					Sex = 2;
				}
				var PatSex = obj.PAPMISexStore.getById(Sex);
				if (PatSex != undefined) {
					var SexDesc = PatSex.data.sexdesc;
					Ext.getCmp("PAPMISex").setValue(Sex);
					Ext.getCmp("PAPMISex").setRawValue(SexDesc);
				}
				var CurrentDate = new Date();
				var CurrentYear = CurrentDate.getFullYear();
				//alert("CurrentYear=="+CurrentYear);
				var age = CurrentYear - Year;
				Ext.getCmp("PAPMIAge").setValue(age);
				/////////////////////////////////////
				Ext.Ajax.request({
					url: 'DHCDocIPAppointmentdata.csp',
					params: {
						action: 'GetPatInfoByPAPERID',
						PAPERID: PAPERID
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);

						if (jsonData.PatInfo != '') {
							//alert(jsonData.PatInfo)

							var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPAPERInfo&PAPERName=" + "&PAPERNo=" + "&PAPERRowid=" + "&Sex=" + "&SexDr=" + "&PAPERID=" + PAPERID + "&BirthDate=" + "&InsuNo=";
							win = open(lnk, "UDHCJFIPReg", "scrollbars=1,top=100,left=10,width=1000,height=600");

							/*
							var PatInfoStr=jsonData.PatInfo.split("$")[0];
							var BookInfoStr=jsonData.PatInfo.split("$")[1];
							var PAPMINo=jsonData.PatInfo.split("$")[2].toString();
							Ext.getCmp("PAPMINo").setValue(PAPMINo);
							//�������Ա����䡢�������ڡ����֤�š����塢����״����ְҵ�����ᡢ�������͡�������λ����λ��ַ����λ�绰�����ڵ�ַ��סַ����ϵ����������ϵ�˵�ַ����ϵ�˵绰
							var PatInfoArr=PatInfoStr.split("^");
							PatientID=PatInfoArr[0];
							Ext.getCmp("PAPMIName").setValue(PatInfoArr[1]);
							Ext.getCmp("PAPMISex").setValue(PatInfoArr[2]);
							Ext.getCmp("PAPMIAge").setValue(PatInfoArr[3]);
							Ext.getCmp("PAPMIDOB").setValue(PatInfoArr[4]);
							Ext.getCmp("PAPERID").setValue(PatInfoArr[5]);
							Ext.getCmp("PAPERNation").setValue(PatInfoArr[6]);
							Ext.getCmp("PAPERMarital").setValue(PatInfoArr[7]);
							Ext.getCmp("PAPEROccupation").setValue(PatInfoArr[8]);
							Ext.getCmp("PAPERBirthPlace").setValue(PatInfoArr[9]);
							Ext.getCmp("PAPERSocialStatus").setValue(PatInfoArr[10]);
							Ext.getCmp("PAPERNokName").setValue(PatInfoArr[11]);
							Ext.getCmp("PAPERNokAddress").setValue(PatInfoArr[12]);
							Ext.getCmp("PAPERNokPhone").setValue(PatInfoArr[13]);
							Ext.getCmp("RegisterPlace").setValue(PatInfoArr[14]);
							Ext.getCmp("Address").setValue(PatInfoArr[15]);
							Ext.getCmp("PAPERForeignName").setValue(PatInfoArr[16]);
							Ext.getCmp("PAPERForeignAddress").setValue(PatInfoArr[17]);
							Ext.getCmp("PAPERForeignPhone").setValue(PatInfoArr[18]);
							Ext.getCmp("MedicalNo").setValue(PatInfoArr[19]);
							Ext.getCmp("PAPERMobPhone").setValue(PatInfoArr[20]);
							Ext.getCmp("TelH").setValue(PatInfoArr[21]);
							
							Ext.getCmp("MRDiagnos").setValue(PatInfoArr[22]);
							if (PatInfoArr[22]!="") {
								Ext.getCmp('MRDiagnos').disable(); 
							}
							
							//סԺ���ҡ�סԺ������ԤԼҽ����ԤԼ���ڡ�Ԥ��Ѻ��רҵ�Ͳ��˴�λָ��
							var BookInfoArr=BookInfoStr.split("^");
							//alert(BookInfoStr);
							IPBookID=BookInfoArr[0];
							IPAppID=BookInfoArr[1];
							if(BookInfoArr[2]!="") {
								var AppLoc=obj.CTLocStore.getById(BookInfoArr[2]);
								var CTLocDesc=AppLoc.data.CTLocDesc;
								//Ext.getCmp("CTLoc").setValue(AppLoc.data.CTLocDesc);
								Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
								Ext.getCmp("CTLoc").setRawValue(CTLocDesc);
							}else {
								Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
								Ext.getCmp("CTLoc").setRawValue("");
							}
							if(BookInfoArr[3]!=""){
								var AppWard=obj.cboWardStore.getById(BookInfoArr[3]);
								var WardDesc=AppWard.data.CTLocDesc;
								Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
								Ext.getCmp("cboWard").setRawValue(WardDesc);
							}else {
								Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
								Ext.getCmp("cboWard").setRawValue("");
							}
							obj.CTDoctorStore.load({
								callback : function() {
									if(BookInfoArr[4]!="") {
										var AppDoc=obj.CTDoctorStore.getById(BookInfoArr[4]);
										if (AppDoc!=undefined) {
											var CTPCPDesc=AppDoc.data.CTPCPDesc;
											Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
											Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
										}
									}else {
										Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
										Ext.getCmp("CTDoctor").setRawValue("");
									}
								}
							});
							Ext.getCmp("orderInDate").setValue(BookInfoArr[5]);
							Ext.getCmp("advancePayment").setValue(BookInfoArr[6]);
							if(BookInfoArr[7]!="") {
								var Specialty=obj.specialtyStore.getById(BookInfoArr[7]);
								var SpecialtyDesc=Specialty.data.TCTMUDesc;
								Ext.getCmp("specialty").setValue(BookInfoArr[7]);
								Ext.getCmp("specialty").setRawValue(SpecialtyDesc);
							}else {
								Ext.getCmp("specialty").setValue(BookInfoArr[7]);
								Ext.getCmp("specialty").setRawValue("");
							}
							//Ext.getCmp("bedNo").setValue(BookInfoArr[8]);
							if(BookInfoArr[9]!="") {
								var TreatLevel=obj.TreatLevelStore.getById(BookInfoArr[9]);
								var TreatLevelDesc=TreatLevel.data.Desc;
								Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
								Ext.getCmp("TreatLevel").setRawValue(TreatLevelDesc);
							}else {
								Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
								Ext.getCmp("TreatLevel").setRawValue("");
							}
							*/
						}

					},
					scope: this
				});
				/////////////////////////////////////
			}
		}
	});
	Ext.get('PAPMIMedicare').on("keydown", function(e) {
		keycode = websys_getKey(e);

		if ((keycode == 13) || (keycode == 9)) {

			Ext.Ajax.request({
				url: 'DHCDocIPAppointmentdata.csp',
				params: {
					action: 'GetPatInfo',
					IPBookNo: Ext.get("PAPMIMedicare").getValue()
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.PatInfo != '') {
						//alert(jsonData.PatInfo)
						if (jsonData.PatInfo < 0) {
							if (jsonData.PatInfo == "-103") {
								alert("��סԺ֤�Ѿ�����ԤԼ");
							} else if (jsonData.PatInfo == "-100") {
								alert("��סԺ֤�Ѿ�������Ժ");
							} else if (jsonData.PatInfo == "-101") {
								alert("��סԺ֤�Ѿ����䴲λ");
							} else if (jsonData.PatInfo == "-102") {
								alert("��סԺ֤�Ѿ�ȡ��ԤԼ");
							} else if (jsonData.PatInfo == "-102") {
								alert("��סԺ֤�Ѿ�ȡ��ԤԼ");
							} else if (jsonData.PatInfo == "-104") {
								alert("��סԺ֤�Ѿ�����");
							} else if (jsonData.PatInfo == "-404") {
								alert("��סԺ֤������");
							} else if (jsonData.PatInfo == "-500") {
								alert("�˲���ԤԼ�Ŀ��ҿ��Բ�����ԤԼֱ�Ӱ���סԺ!");
							}
							Reset_onclick();
							return;
						}
						var PatInfoStr = jsonData.PatInfo.split("$")[0];
						var BookInfoStr = jsonData.PatInfo.split("$")[1];
						var PAPMINo = jsonData.PatInfo.split("$")[2].toString();
						Ext.getCmp("PAPMINo").setValue(PAPMINo);
						//�������Ա����䡢�������ڡ����֤�š����塢����״����ְҵ�����ᡢ�������͡�������λ����λ��ַ����λ�绰�����ڵ�ַ��סַ����ϵ����������ϵ�˵�ַ����ϵ�˵绰
						var PatInfoArr = PatInfoStr.split("^");
						PatientID = PatInfoArr[0];
						Ext.getCmp("PAPMIName").setValue(PatInfoArr[1]);
						Ext.getCmp("PAPMISex").setValue(PatInfoArr[2]);
						Ext.getCmp("PAPMIAge").setValue(PatInfoArr[3]);
						Ext.getCmp("PAPMIDOB").setValue(PatInfoArr[4]);
						Ext.getCmp("PAPERID").setValue(PatInfoArr[5]);
						Ext.getCmp("PAPERNation").setValue(PatInfoArr[6]);
						Ext.getCmp("PAPERMarital").setValue(PatInfoArr[7]);
						Ext.getCmp("PAPEROccupation").setValue(PatInfoArr[8]);
						Ext.getCmp("PAPERBirthPlace").setValue(PatInfoArr[9]);
						Ext.getCmp("PAPERSocialStatus").setValue(PatInfoArr[10]);
						Ext.getCmp("PAPERNokName").setValue(PatInfoArr[11]);
						Ext.getCmp("PAPERNokAddress").setValue(PatInfoArr[12]);
						Ext.getCmp("PAPERNokPhone").setValue(PatInfoArr[13]);
						Ext.getCmp("RegisterPlace").setValue(PatInfoArr[14]);
						Ext.getCmp("Address").setValue(PatInfoArr[15]);
						Ext.getCmp("PAPERForeignName").setValue(PatInfoArr[16]);
						Ext.getCmp("PAPERForeignAddress").setValue(PatInfoArr[17]);
						Ext.getCmp("PAPERForeignPhone").setValue(PatInfoArr[18]);
						Ext.getCmp("MedicalNo").setValue(PatInfoArr[19]);
						Ext.getCmp("PAPERMobPhone").setValue(PatInfoArr[20]);
						Ext.getCmp("TelH").setValue(PatInfoArr[21]);

						Ext.getCmp("MRDiagnos").setValue(PatInfoArr[22]);
						if (PatInfoArr[22] != "") {
							Ext.getCmp('MRDiagnos').disable();
						}

						//סԺ���ҡ�סԺ������ԤԼҽ����ԤԼ���ڡ�Ԥ��Ѻ��רҵ�Ͳ��˴�λָ��
						var BookInfoArr = BookInfoStr.split("^");
						//alert(BookInfoStr);
						IPBookID = BookInfoArr[0];
						IPAppID = BookInfoArr[1];
						if (BookInfoArr[2] != "") {
							var AppLoc = obj.CTLocStore.getById(BookInfoArr[2]);
							var CTLocDesc = AppLoc.data.CTLocDesc;
							//Ext.getCmp("CTLoc").setValue(AppLoc.data.CTLocDesc);
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue(CTLocDesc);
						} else {
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue("");
						}
						if (BookInfoArr[3] != "") {
							var AppWard = obj.cboWardStore.getById(BookInfoArr[3]);
							var WardDesc = AppWard.data.CTLocDesc;
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue(WardDesc);
						} else {
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue("");
						}
						obj.CTDoctorStore.load({
							callback: function() {
								if (BookInfoArr[4] != "") {
									var AppDoc = obj.CTDoctorStore.getById(BookInfoArr[4]);
									if (AppDoc != undefined) {
										var CTPCPDesc = AppDoc.data.CTPCPDesc;
										Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
										Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
									}
								} else {
									Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
									Ext.getCmp("CTDoctor").setRawValue("");
								}
							}
						});
						/*
						if(BookInfoArr[4]!="") {
							var AppDoc=obj.CTDoctorStore.getById(BookInfoArr[4]);
							if (AppDoc!=undefined) {
								var CTPCPDesc=AppDoc.data.CTPCPDesc;
								Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
								Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
							}
						}else {
							Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
							Ext.getCmp("CTDoctor").setRawValue("");
						}
						*/
						Ext.getCmp("orderInDate").setValue(BookInfoArr[5]);
						Ext.getCmp("advancePayment").setValue(BookInfoArr[6]);
						if (BookInfoArr[7] != "") {
							var Specialty = obj.specialtyStore.getById(BookInfoArr[7]);
							var SpecialtyDesc = Specialty.data.TCTMUDesc;
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue(SpecialtyDesc);
						} else {
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue("");
						}
						//Ext.getCmp("bedNo").setValue(BookInfoArr[8]);
						if (BookInfoArr[9] != "") {
							var TreatLevel = obj.TreatLevelStore.getById(BookInfoArr[9]);
							var TreatLevelDesc = TreatLevel.data.Desc;
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							Ext.getCmp("TreatLevel").setRawValue(TreatLevelDesc);
						} else {
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							Ext.getCmp("TreatLevel").setRawValue("");
						}

					}

				},
				scope: this
			});
		}
	});

	Ext.get('btnTransferInpCard').on("click", function(e) {

		var IPBookingListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
		var IPBookingListStore = new Ext.data.Store({
			proxy: IPBookingListStoreProxy,
			autoLoad: true,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'RowID'
			}, [{
				name: 'checked',
				mapping: 'checked'
			}, {
				name: 'RowID',
				mapping: 'RowID'
			}, {
				name: 'patientId',
				mapping: 'patientId'
			}, {
				name: 'PatName',
				mapping: 'PatName'
			}, {
				name: 'PatId',
				mapping: 'PatId'
			}, {
				name: 'IPBookNo',
				mapping: 'IPBookNo'
			}, {
				name: 'Ward',
				mapping: 'Ward'
			}, {
				name: 'Loc',
				mapping: 'Loc'
			}, {
				name: 'Doc',
				mapping: 'Doc'
			}])
		});
		var IPBookingListCheckCol = new Ext.grid.CheckColumn({
			header: '',
			dataIndex: 'checked',
			width: 100
		});
		var IPBookingList = new Ext.grid.GridPanel({
			id: 'IPBookingList',
			store: IPBookingListStore,
			region: 'center',
			layout: 'fit',
			autoHeight: true
				//,autoScroll:true
				,
			buttonAlign: 'center',
			loadMask: {
				msg: '���ڶ�ȡ����,���Ժ�...'
			},
			columns: [
				new Ext.grid.RowNumberer({
					header: "���",
					width: 60
				}), {
					header: 'RowID',
					width: 100,
					dataIndex: 'RowID',
					sortable: true,
					hidden: true
				}, {
					header: 'patientId',
					width: 100,
					dataIndex: 'patientId',
					sortable: true,
					hidden: true
				}, {
					header: '��������',
					width: 100,
					dataIndex: 'PatName',
					sortable: true
				}, {
					header: '���֤��',
					width: 100,
					dataIndex: 'PatId',
					sortable: true
				}, {
					header: 'סԺ֤��',
					width: 100,
					dataIndex: 'IPBookNo',
					sortable: true
				}, {
					header: 'ԤԼ����',
					width: 100,
					dataIndex: 'Ward',
					sortable: true
				}, {
					header: 'ԤԼ����',
					width: 100,
					dataIndex: 'Loc',
					sortable: true
				}, {
					header: '��֤ҽ��',
					width: 100,
					dataIndex: 'Doc',
					sortable: true
				}
			]
		});

		IPBookingListStoreProxy.on('beforeload', function(objProxy, param) {
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'GetBookPatientList';
			param.Arg1 = winPAPMIName.getValue();
			param.Arg2 = wincboWard.getValue();
			param.Arg3 = winCTLoc.getValue();
			param.Arg4 = winCTDoctor.getValue();
			param.ArgCnt = 4;
		});

		var Define = new Ext.Button({
			id: 'Define',
			fieldLabel: '',
			width: 100,
			text: 'ȷ��'
		});
		var winConditionChild1 = new Ext.Panel({
			id: 'winConditionChild1',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [Define]
		});

		var Find = new Ext.Button({
			id: 'Find',
			fieldLabel: '',
			width: 100,
			text: '��ѯ'
		});
		var winConditionChild2 = new Ext.Panel({
			id: 'winConditionChild2',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [Find]
		});

		var winPAPMIName = new Ext.form.TextField({
			id: 'winPAPMIName',
			width: 70,
			height: 25,
			anchor: '90%',
			fieldLabel: '����'
				/*,listeners: {
					'keydown' : function(e) {alert("-----");
		
						keycode=websys_getKey(e);
						if ((keycode==13)||(keycode==9)){alert("======");
							IPBookingListStore.load({});
						}
					}
				}*/
		});
		var winConditionChild3 = new Ext.Panel({
			id: 'winConditionChild3',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [winPAPMIName]
		});
		/*
		winPAPMIName.on("keydown", function(e) {alert("-----");
		//winPAPMIName.on('keydown', function() {
			keycode=websys_getKey(e);
			if ((keycode==13)||(keycode==9)){alert("======");
				IPBookingListStore.load({});
			}
		});
		*/
		var winCTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
		var winCTLocStore = new Ext.data.Store({
			proxy: winCTLocStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'CTLocID'
			}, [{
				name: 'checked',
				mapping: 'checked'
			}, {
				name: 'CTLocID',
				mapping: 'CTLocID'
			}, {
				name: 'CTLocCode',
				mapping: 'CTLocCode'
			}, {
				name: 'CTLocDesc',
				mapping: 'CTLocDesc'
			}])
		});
		var winCTLoc = new Ext.form.ComboBox({
			id: 'winCTLoc',
			width: 100,
			store: winCTLocStore,
			minChars: 1,
			displayField: 'CTLocDesc',
			fieldLabel: 'ԤԼ����',
			editable: true,
			triggerAction: 'all',
			anchor: '90%',
			valueField: 'CTLocID'
		});
		winCTLocStoreProxy.on('beforeload', function(objProxy, param) {
			var hospitalId = session['LOGON.HOSPID'];
			if (obj.CTHospital.getValue() != "") {
				hospitalId = obj.CTHospital.getValue();
			}
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = winCTLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = wincboWard.getValue();
			param.Arg4 = hospitalId;
			param.ArgCnt = 4;
		});
		var winConditionChild4 = new Ext.Panel({
			id: 'winConditionChild4',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [winCTLoc]
		});

		var wincboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
		var wincboWardStore = new Ext.data.Store({
			proxy: wincboWardStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'CTLocID'
			}, [{
				name: 'checked',
				mapping: 'checked'
			}, {
				name: 'CTLocID',
				mapping: 'CTLocID'
			}, {
				name: 'CTLocCode',
				mapping: 'CTLocCode'
			}, {
				name: 'CTLocDesc',
				mapping: 'CTLocDesc'
			}])
		});
		var wincboWard = new Ext.form.ComboBox({
			id: 'wincboWard',
			width: 100,
			minChars: 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
				,
			selectOnFocus: true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
				,
			forceSelection: true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
				,
			store: wincboWardStore,
			displayField: 'CTLocDesc',
			fieldLabel: 'ԤԼ����',
			editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
				,
			triggerAction: 'all' //�������������ʱ��Ҫִ�еĲ�����
				,
			anchor: '90%',
			valueField: 'CTLocID'
		});
		wincboWardStoreProxy.on('beforeload', function(objProxy, param) {
			var hospitalId = session['LOGON.HOSPID'];
			if (obj.CTHospital.getValue() != "") {
				hospitalId = obj.CTHospital.getValue();
			}
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = wincboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = winCTLoc.getValue();
			param.Arg4 = hospitalId;
			param.ArgCnt = 4;
		});
		var winConditionChild5 = new Ext.Panel({
			id: 'winConditionChild5',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [wincboWard]
		});

		var winCTDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
		var winCTDoctorStore = new Ext.data.Store({
			proxy: winCTDoctorStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'CTPCPRowId'
			}, [{
				name: 'checked',
				mapping: 'checked'
			}, {
				name: 'CTPCPRowId',
				mapping: 'CTPCPRowId'
			}, {
				name: 'CTPCPCode',
				mapping: 'CTPCPCode'
			}, {
				name: 'CTPCPDesc',
				mapping: 'CTPCPDesc'
			}])
		});

		var winCTDoctor = new Ext.form.ComboBox({
			id: 'winCTDoctor'
				//,selectOnFocus : true
				//,forceSelection : true
				,
			minChars: 1,
			displayField: 'CTPCPDesc',
			fieldLabel: '��֤ҽ��',
			store: winCTDoctorStore
				//,mode : 'local'  //remote
				,
			typeAhead: true,
			triggerAction: 'all',
			editable: true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
				,
			anchor: '100%',
			valueField: 'CTPCPRowId'
		});
		winCTDoctorStoreProxy.on('beforeload', function(objProxy, param) {
			param.ClassName = 'web.DHCDocIPAppointment';
			param.QueryName = 'FindCTCareProvByLoc';
			param.Arg1 = winCTLoc.getValue();
			param.ArgCnt = 1;
		});
		var winConditionChild6 = new Ext.Panel({
			id: 'winConditionChild6',
			buttonAlign: 'center',
			labelAligh: 'center',
			labelWidth: 70,
			columnWidth: .3,
			layout: 'form',
			items: [winCTDoctor]
		});

		var QueryCondition = new Ext.form.FormPanel({
			id: 'QueryCondition',
			buttonAlign: 'center',
			labelAlign: 'center',
			labelWidth: 100,
			bodyBorder: 'padding:0 0 0 0',
			layout: 'column',
			region: 'north',
			frame: true,
			height: 80,
			//,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
			//,columnWidth : .60 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
			//,layout : 'form' //���ַ�ʽ
			items: [winConditionChild4, winConditionChild5, winConditionChild6, winConditionChild3, winConditionChild2, winConditionChild1]
		});

		var win = new Ext.Window({
			width: 900,
			collapsible: true, //�������
			height: 300,
			autoScroll: true,
			autoHeight: true,
			items: [{
				region: "north",
				height: 60,
				items: [QueryCondition]
			}, {
				region: "center",
				height: 240,
				split: true,
				border: true,
				collapsible: true,
				autoScroll: true,
				title: "סԺ֤�б�",
				items: [IPBookingList]
			}]
		});

		Find.on("click", function() {
			IPBookingListStore.load({});
		});

		winCTLoc.on('blur', function() {
			wincboWardStore.load({});
			winCTDoctorStore.load({});
		});

		wincboWard.on('blur', function() {
			winCTLocStore.load({});
			winCTDoctorStore.load({});
		});
		//////////////////////////
		IPBookingList.on("rowdblclick", function(grid, rowIndex, e) {
			//alert("rowIndex=="+rowIndex);
			//var winselections=IPBookingList.getSelectionModel().getSelections();
			//var winrecord = winselections[rowIndex];
			Define.fireEvent('click');
		});
		//////////////////////////
		//winPAPMIName.on('keydown', function(e){alert("======");});	
		Define.on("click", function() {
			var winselections = IPBookingList.getSelectionModel().getSelections();
			//alert("selections=="+selections.length);
			if (winselections.length == 0) {
				alert("����ѡ���¼!");
				return;
			}
			var IPBookNo = ""
			for (var i = 0; i < winselections.length; i++) {
				var winrecord = winselections[i];
				IPBookID = winrecord.get("RowID");
				PatientID = winrecord.get("patientId");
				IPBookNo = winrecord.get("IPBookNo");
				//var CancleID=winrecord.get("RowId");
				//alert("CancleID=="+CancleID);

			}
			//alert("IPBookID=="+IPBookID+"  PatientID=="+PatientID);
			Ext.getCmp("PAPMIMedicare").setValue(IPBookNo);
			//alert("IPBookNo"+Ext.get("PAPMIMedicare").getValue());
			Ext.Ajax.request({
				url: 'DHCDocIPAppointmentdata.csp',
				params: {
					action: 'GetPatInfo',
					IPBookNo: Ext.get("PAPMIMedicare").getValue()
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.PatInfo != '') {
						//alert(jsonData.PatInfo)
						var PatInfoStr = jsonData.PatInfo.split("$")[0];
						var BookInfoStr = jsonData.PatInfo.split("$")[1];
						var PAPMINo = jsonData.PatInfo.split("$")[2].toString();
						Ext.getCmp("PAPMINo").setValue(PAPMINo);
						//�������Ա����䡢�������ڡ����֤�š����塢����״����ְҵ�����ᡢ�������͡�������λ����λ��ַ����λ�绰�����ڵ�ַ��סַ����ϵ����������ϵ�˵�ַ����ϵ�˵绰
						var PatInfoArr = PatInfoStr.split("^");
						PatientID = PatInfoArr[0];
						Ext.getCmp("PAPMIName").setValue(PatInfoArr[1]);
						Ext.getCmp("PAPMISex").setValue(PatInfoArr[2]);
						Ext.getCmp("PAPMIAge").setValue(PatInfoArr[3]);
						Ext.getCmp("PAPMIDOB").setValue(PatInfoArr[4]);
						Ext.getCmp("PAPERID").setValue(PatInfoArr[5]);
						Ext.getCmp("PAPERNation").setValue(PatInfoArr[6]);
						Ext.getCmp("PAPERMarital").setValue(PatInfoArr[7]);
						Ext.getCmp("PAPEROccupation").setValue(PatInfoArr[8]);
						Ext.getCmp("PAPERBirthPlace").setValue(PatInfoArr[9]);
						Ext.getCmp("PAPERSocialStatus").setValue(PatInfoArr[10]);
						Ext.getCmp("PAPERNokName").setValue(PatInfoArr[11]);
						Ext.getCmp("PAPERNokAddress").setValue(PatInfoArr[12]);
						Ext.getCmp("PAPERNokPhone").setValue(PatInfoArr[13]);
						Ext.getCmp("RegisterPlace").setValue(PatInfoArr[14]);
						Ext.getCmp("Address").setValue(PatInfoArr[15]);
						Ext.getCmp("PAPERForeignName").setValue(PatInfoArr[16]);
						Ext.getCmp("PAPERForeignAddress").setValue(PatInfoArr[17]);
						Ext.getCmp("PAPERForeignPhone").setValue(PatInfoArr[18]);
						Ext.getCmp("MedicalNo").setValue(PatInfoArr[19]);
						Ext.getCmp("PAPERMobPhone").setValue(PatInfoArr[20]);
						Ext.getCmp("TelH").setValue(PatInfoArr[21]);

						Ext.getCmp("MRDiagnos").setValue(PatInfoArr[22]);
						if (PatInfoArr[22] != "") {
							Ext.getCmp('MRDiagnos').disable();
						}

						//סԺ���ҡ�סԺ������ԤԼҽ����ԤԼ���ڡ�Ԥ��Ѻ��רҵ�Ͳ��˴�λָ��
						var BookInfoArr = BookInfoStr.split("^");
						//alert(BookInfoStr);
						IPBookID = BookInfoArr[0];
						IPAppID = BookInfoArr[1];
						if (BookInfoArr[2] != "") {
							var AppLoc = obj.CTLocStore.getById(BookInfoArr[2]);
							var CTLocDesc = AppLoc.data.CTLocDesc;
							//Ext.getCmp("CTLoc").setValue(AppLoc.data.CTLocDesc);
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue(CTLocDesc);
						} else {
							Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
							Ext.getCmp("CTLoc").setRawValue("");
						}
						if (BookInfoArr[3] != "") {
							var AppWard = obj.cboWardStore.getById(BookInfoArr[3]);
							var WardDesc = AppWard.data.CTLocDesc;
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue(WardDesc);
						} else {
							Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
							Ext.getCmp("cboWard").setRawValue("");
						}
						obj.CTDoctorStore.load({
							callback: function() {
								if (BookInfoArr[4] != "") {
									var AppDoc = obj.CTDoctorStore.getById(BookInfoArr[4]);
									if (AppDoc != undefined) {
										var CTPCPDesc = AppDoc.data.CTPCPDesc;
										Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
										Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
									}
								} else {
									Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
									Ext.getCmp("CTDoctor").setRawValue("");
								}
							}
						});
						/*
						if(BookInfoArr[4]!="") {
							var AppDoc=obj.CTDoctorStore.getById(BookInfoArr[4]);
							if (AppDoc!=undefined) {
								var CTPCPDesc=AppDoc.data.CTPCPDesc;
								Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
								Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
							}
						}else {
							Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
							Ext.getCmp("CTDoctor").setRawValue("");
						}
						*/
						Ext.getCmp("orderInDate").setValue(BookInfoArr[5]);
						Ext.getCmp("advancePayment").setValue(BookInfoArr[6]);
						if (BookInfoArr[7] != "") {
							var Specialty = obj.specialtyStore.getById(BookInfoArr[7]);
							var SpecialtyDesc = Specialty.data.TCTMUDesc;
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue(SpecialtyDesc);
						} else {
							Ext.getCmp("specialty").setValue(BookInfoArr[7]);
							Ext.getCmp("specialty").setRawValue("");
						}
						//Ext.getCmp("bedNo").setValue(BookInfoArr[8]);
						if (BookInfoArr[9] != "") {
							var TreatLevel = obj.TreatLevelStore.getById(BookInfoArr[9]);
							//var TreatLevelDesc = TreatLevel.data.Desc;
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							//Ext.getCmp("TreatLevel").setRawValue(TreatLevelDesc);
						} else {
							Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
							Ext.getCmp("TreatLevel").setRawValue("");
						}

					}

				},
				scope: this
			});

			win.close();
		});

		win.show();
	});
	Ext.get('btnTransferFiles').on("click", function(e) {

		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPAPERInfo&PAPERName=" + "&PAPERNo=" + "&PAPERRowid=" + "&Sex=" + "&SexDr=" + "&PAPERID=" + "&BirthDate=" + "&InsuNo=";
		win = open(lnk, "UDHCJFIPReg", "scrollbars=1,top=100,left=10,width=1000,height=600");
	});
	Ext.get('btnSave').on("click", function(e) {
		//סԺ֤ID^ԤԼסԺ��ID^����ID^����ԱID^ԤԼ����ID^ԤԼ����ID^ԤԼҽ��ID^ԤԼ����^Ԥ��Ѻ��
		var UserID = session["LOGON.USERID"];
		var AppWardID = Ext.getCmp('cboWard').getValue();
		var AppLocID = Ext.getCmp('CTLoc').getValue();
		var AppDocID = Ext.getCmp('CTDoctor').getValue();
		var AppDate = Ext.get('orderInDate').getValue();
		var AppCash = Ext.get('advancePayment').getValue();
		var specialty = Ext.get('specialty').getValue();
		var BookNo = Ext.get('PAPMIMedicare').getValue();
		var TreatLevel = Ext.getCmp('TreatLevel').getValue();
		var AppHospital = Ext.getCmp('CTHospital').getValue();

		var acceptDate = Ext.get('acceptDate').getValue(); //��֤����

		/// ������У��
		if (AppWardID == "") {
			alert("סԺ��������Ϊ�գ�");
			return;
		}
		if (AppLocID == "") {
			alert("סԺ���Ҳ���Ϊ�գ�");
			return;
		}
		if (AppDate == "") {
			alert("ԤԼ���ڲ���Ϊ�գ�");
			return;
		}
		/// end

		var IfAccompany = "N"
		if (obj.IfAccompany.items.itemAt(0).checked) {
			IfAccompany = "Y";
		}
		var AccompanySex = Ext.getCmp('AccompanySex').getValue();

		//���˻�����Ϣ
		var PAPMIName = Ext.getCmp('PAPMIName').getValue();
		var PAPMISex = Ext.getCmp('PAPMISex').getValue();
		var PAPMIAge = Ext.getCmp('PAPMIAge').getValue();
		var PAPMIDOB = Ext.get('PAPMIDOB').getValue();
		var PAPERID = Ext.get('PAPERID').getValue();
		var PAPERNation = Ext.getCmp('PAPERNation').getValue();
		var PAPERMarital = Ext.getCmp('PAPERMarital').getValue();
		var PAPEROccupation = Ext.getCmp('PAPEROccupation').getValue();
		var PAPERBirthPlace = Ext.getCmp('PAPERBirthPlace').getValue();
		var PAPERSocialStatus = Ext.getCmp('PAPERSocialStatus').getValue();
		var PAPERMobPhone = Ext.getCmp('PAPERMobPhone').getValue();
		var PAPERNokName = Ext.getCmp('PAPERNokName').getValue();
		var PAPERNokAddress = Ext.getCmp('PAPERNokAddress').getValue();
		var PAPERNokPhone = Ext.getCmp('PAPERNokPhone').getValue();
		var RegisterPlace = Ext.getCmp('RegisterPlace').getValue();
		var Address = Ext.getCmp('Address').getValue();
		var PAPERForeignName = Ext.getCmp('PAPERForeignName').getValue();
		var PAPERForeignAddress = Ext.getCmp('PAPERForeignAddress').getValue();
		var PAPERForeignPhone = Ext.getCmp('PAPERForeignPhone').getValue();
		var CTRelation = Ext.getCmp('CTRelation').getValue();
		var TelH = Ext.getCmp('TelH').getValue();
		var MRDiagnos = Ext.getCmp("MRDiagnos").getValue();

		var MRDiagnosDesc = Ext.get("MRDiagnos").getValue();
		if (MRDiagnos == MRDiagnosDesc) {
			MRDiagnos = ""
		};

		var PatientInfo = PAPMIName + "^" + PAPMISex + "^" + PAPMIAge + "^" + PAPMIDOB + "^" + PAPERID + "^" + PAPERNation + "^" + PAPERMarital + "^" + PAPEROccupation + "^" + PAPERBirthPlace + "^" + PAPERSocialStatus;
		PatientInfo = PatientInfo + "^" + PAPERMobPhone + "^" + PAPERNokName + "^" + PAPERNokAddress + "^" + PAPERNokPhone + "^" + RegisterPlace + "^" + Address + "^" + PAPERForeignName + "^" + PAPERForeignAddress;
		PatientInfo = PatientInfo + "^" + PAPERForeignPhone + "^" + CTRelation + "^" + TelH;
		//alert("PatientInfo=="+PatientInfo);
		//end

		var para = IPBookID + "^" + IPAppID + "^" + PatientID + "^" + UserID + "^" + AppWardID + "^" + AppLocID + "^" + AppDocID + "^" + AppDate + "^" + AppCash + "^" + specialty + "^" + BookNo + "^" + TreatLevel + "^" + AppHospital + "^" + IfAccompany + "^" + AccompanySex + "^" + MRDiagnos + "^" + acceptDate
			//alert("para=="+para);
		Ext.Ajax.request({
			url: 'DHCDocIPAppointmentdata.csp',
			params: {
				action: 'SavaIPInfo',
				IPInfoStr: para,
				PatientInfo: PatientInfo
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				//alert("jsonData="+jsonData);
				if (jsonData.PatInfo != '') {
					//alert(jsonData.success)
					if (jsonData.success == "true") {
						alert("����ɹ�!");
						Reset_onclick();
					} else {
						if (jsonData.info == "-500") {
							alert("������Ϣ��ȫ!");
						} else if (jsonData.info == "-305") {
							alert("סԺ���Ѿ�����!");
						} else if (jsonData.info == "-300") {
							alert("�����Ѿ�����!");
						} else if (jsonData.info == "-301") {
							alert("�����Ѿ���Ժ!");
						} else if (jsonData.info == "-302") {
							alert("��סԺ֤�Ѿ�����!");
						} else if (jsonData.info == "-303") {
							alert("�����Ѿ�����ԤԼ!")
						} else if (jsonData.info == "-304") {
							alert("��סԺ֤�Ѿ�����!");
						} else if (jsonData.info == "-306") {
							alert("���˳������������֤��Ϣ����!");
						} else {
							alert("����ʧ��!�������:" + jsonData.info);
						}
					}
				}

			},
			scope: this
		});

	});

	Ext.get('btnReset').on("click", Reset_onclick);
	//***************
	var logongroupid = session['LOGON.GROUPID'];
	//if (logongroupid != "189") {
		//Ext.get('btnUpdateAllBed').hide();
	//}
	//******************************************
	Ext.get('btnUpdateAllBed').on("click", btnUpdateAllBed_onclick);
	var ret = tkMakeServerCall("Nur.DHCBedManager", "GetBedStatus");
	if (ret == "1") {
		var btnUpdateAllBed = Ext.getCmp("btnUpdateAllBed");
		btnUpdateAllBed.setText("�ջ�����Ȩ��");
	} else {
		var btnUpdateAllBed = Ext.getCmp("btnUpdateAllBed");
		btnUpdateAllBed.setText("��������Ȩ��");
	}
	Ext.get('btnReadCard').on("click", ReadCard_onclick);
	//Ext.get('btnGetNCSInfo').on("click", GetNCSInfo_onclick);
	Ext.getCmp('AccompanySex').disable(); ///��ʼ��ʱ���ܱ༭
	Ext.get('IfAccompany').on("click", function() {
		if (obj.IfAccompany.items.itemAt(0).checked) {
			Ext.getCmp('AccompanySex').enable();
		} else {
			Ext.getCmp('AccompanySex').disable();
		}
	});

	//2014.04.25

	var HospitalId = session['LOGON.HOSPID'];
	obj.CTHospitalStore.load({
		callback: function() {
			var HospitalObj = obj.CTHospitalStore.getById(HospitalId);
			if (HospitalObj != undefined) {
				var HospitalDesc = HospitalObj.data.HosDesc;
				Ext.getCmp("CTHospital").setValue(HospitalId);
				Ext.getCmp("CTHospital").setRawValue(HospitalDesc);
			}
		}
	});

	//end
	Getmessage();
	//�¼��������
	InitviewScreenEvent(obj);

	obj.LoadEvent(arguments);
	return obj;
}

function ReadCard_onclick() {
	var ReadAccExpEncryptObj = document.getElementById("ReadAccExpEncrypt");
	ReadAccExpEncryptObj.value = ReadAccExpEncrypt;
	var ReadAccExpEncrypt11 = document.getElementById("ReadAccExpEncrypt");
	var myrtn = DHCACC_GetAccInfo(2, myoptval);
	//alert("myrtn=="+myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	if (rtn == "0") {
		var PAPMINo = myary[5];
		//alert("PAPMINo"+PAPMINo);
		Ext.getCmp("PAPMINo").setValue(PAPMINo);
		GetPatInfoByPAPMINo();

	}
}

function GetNCSInfo_onclick() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPatInfoFromNCS&PatientID=";
	win = open(lnk, "DHCDocIPRegistergui", "status=1,scrollbars=1,top=100,left=100,width=400,height=200");
	return;
}


function btnUpdateAllBed_onclick() {
	var btnUpdateAllBed = Ext.getCmp("btnUpdateAllBed");

	if (btnUpdateAllBed.text == "��������Ȩ��") {
		var ret = tkMakeServerCall("Nur.DHCBedManager", "UpdateAllBed");
		if (ret == "0") {
			alert("����Ȩ�޳ɹ�")
			btnUpdateAllBed.setText("�ջ�����Ȩ��");
		}
	} else {
		var ret = tkMakeServerCall("Nur.DHCBedManager", "CloseAllBed");
		if (ret == "0") {
			alert("�ջ�Ȩ�޳ɹ�")
			btnUpdateAllBed.setText("��������Ȩ��");
		}
	}
}

function Reset_onclick() {
	IPBookID = "";
	IPAppID = "";
	PatientID = "";

	Ext.getCmp("PAPMIMedicare").setValue("");
	Ext.getCmp("PAPMINo").setValue("");
	Ext.getCmp("MedicalNo").setValue("");
	Ext.getCmp("PAPMIName").setValue("");
	Ext.getCmp("PAPMISex").setValue("");
	Ext.getCmp("PAPMIAge").setValue("");
	Ext.getCmp("PAPMIDOB").setValue("");
	Ext.getCmp("PAPERID").setValue("");
	Ext.getCmp("PAPERNation").setValue("");
	Ext.getCmp("PAPERMarital").setValue("");
	Ext.getCmp("PAPEROccupation").setValue("");
	Ext.getCmp("PAPERBirthPlace").setValue("");
	Ext.getCmp("PAPERSocialStatus").setValue("");
	Ext.getCmp("PAPERMobPhone").setValue("");
	Ext.getCmp("PAPERNokName").setValue("");
	Ext.getCmp("PAPERNokAddress").setValue("");
	Ext.getCmp("PAPERNokPhone").setValue("");
	Ext.getCmp("RegisterPlace").setValue("");
	Ext.getCmp("Address").setValue("");
	Ext.getCmp("PAPERForeignName").setValue("");
	Ext.getCmp("PAPERForeignAddress").setValue("");
	Ext.getCmp("PAPERForeignPhone").setValue("");
	Ext.getCmp("CTRelation").setValue("");
	Ext.getCmp("PAINSCardNo").setValue("");
	Ext.getCmp("socialSecurityNo").setValue("");
	Ext.getCmp("AdmInsuranceType").setValue("");
	Ext.getCmp("guaranteeName").setValue("");
	Ext.getCmp("guaranteeEntity").setValue("");
	Ext.getCmp("guaranteePhone").setValue("");
	Ext.getCmp("guaranteeRelation").setValue("");

	//Ext.getCmp("CTLoc").setValue("");
	//Ext.getCmp("CTLoc").setRawValue("");
	Ext.getCmp("CTLoc").clearValue();
	Ext.getCmp("CTLoc").getStore().load({});
	Ext.getCmp("cboWard").setValue("");
	Ext.getCmp("cboWard").setRawValue("");

	Ext.getCmp("CTDoctor").setValue("");
	Ext.getCmp("CTDoctor").setRawValue("");

	Ext.getCmp("orderInDate").setValue("");
	Ext.getCmp("advancePayment").setValue("");
	Ext.getCmp("specialty").setValue("");
	Ext.getCmp("specialty").setRawValue("");
	//Ext.getCmp("bedNo").setValue("");
	Ext.getCmp("TreatLevel").setValue("");
	Ext.getCmp('TreatLevel').setRawValue("");
	Ext.getCmp("CTHospital").setValue("");
	Ext.getCmp('CTHospital').setRawValue("");
	Ext.getCmp('TelH').setRawValue("");
	Ext.getCmp('MRDiagnos').setRawValue("");

	//Ext.getCmp("PAPMISex").setValue("");
	Ext.getCmp("AccompanySex").setValue("");
	Ext.getCmp("acceptDate").setValue("");
}

function getpatinfo1() {

	var PAPMINo = document.getElementById("Regno").value;
	Ext.getCmp("PAPMINo").setValue(PAPMINo);
	GetPatInfoByPAPMINo();
}

function GetPatInfoByPAPMINo() {
	var PAPMINo = Ext.get("PAPMINo").getValue();
	if (PAPMINo.length < 10) {
		for (var i = (10 - PAPMINo.length - 1); i >= 0; i--) {
			PAPMINo = "0" + PAPMINo
		}
	}
	//alert("PAPMINo=="+PAPMINo);
	Ext.getCmp('PAPMINo').setValue(PAPMINo);
	Ext.Ajax.request({
		url: 'DHCDocIPAppointmentdata.csp',
		params: {
			action: 'GetPatInfoByPAPMINo',
			PAPMINo: PAPMINo
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			lastPAPMINo=PAPMINo
			if (jsonData.PatInfo != '') {
				//alert(jsonData.PatInfo)
				var PatInfoStr = jsonData.PatInfo.split("$")[0];
				var BookInfoStr = jsonData.PatInfo.split("$")[1];
				var PAPMINo = jsonData.PatInfo.split("$")[2].toString();
				Ext.getCmp("PAPMINo").setValue(PAPMINo);
				//�������Ա����䡢�������ڡ����֤�š����塢����״����ְҵ�����ᡢ�������͡�������λ����λ��ַ����λ�绰�����ڵ�ַ��סַ����ϵ����������ϵ�˵�ַ����ϵ�˵绰
				var PatInfoArr = PatInfoStr.split("^");
				PatientID = PatInfoArr[0];
				Ext.getCmp("PAPMIName").setValue(PatInfoArr[1]);
				Ext.getCmp("PAPMISex").setValue(PatInfoArr[2]);
				Ext.getCmp("PAPMIAge").setValue(PatInfoArr[3]);
				Ext.getCmp("PAPMIDOB").setValue(PatInfoArr[4]);
				Ext.getCmp("PAPERID").setValue(PatInfoArr[5]);
				Ext.getCmp("PAPERNation").setValue(PatInfoArr[6]);
				Ext.getCmp("PAPERMarital").setValue(PatInfoArr[7]);
				Ext.getCmp("PAPEROccupation").setValue(PatInfoArr[8]);
				Ext.getCmp("PAPERBirthPlace").setValue(PatInfoArr[9]);
				Ext.getCmp("PAPERSocialStatus").setValue(PatInfoArr[10]);
				Ext.getCmp("PAPERNokName").setValue(PatInfoArr[11]);
				Ext.getCmp("PAPERNokAddress").setValue(PatInfoArr[12]);
				Ext.getCmp("PAPERNokPhone").setValue(PatInfoArr[13]);
				Ext.getCmp("RegisterPlace").setValue(PatInfoArr[14]);
				Ext.getCmp("Address").setValue(PatInfoArr[15]);
				Ext.getCmp("PAPERForeignName").setValue(PatInfoArr[16]);
				Ext.getCmp("PAPERForeignAddress").setValue(PatInfoArr[17]);
				Ext.getCmp("PAPERForeignPhone").setValue(PatInfoArr[18]);
				Ext.getCmp("MedicalNo").setValue(PatInfoArr[19]);
				Ext.getCmp("PAPERMobPhone").setValue(PatInfoArr[20]);
				Ext.getCmp("TelH").setValue(PatInfoArr[21]);

				Ext.getCmp("MRDiagnos").setValue(PatInfoArr[22]);
				if (PatInfoArr[22] != "") {
					Ext.getCmp('MRDiagnos').disable();
				}
				//סԺ���ҡ�סԺ������ԤԼҽ����ԤԼ���ڡ�Ԥ��Ѻ��רҵ�Ͳ��˴�λָ��
				var BookInfoArr = BookInfoStr.split("^");
				//alert(BookInfoStr);
				IPBookID = BookInfoArr[0];
				IPAppID = BookInfoArr[1];
				if (BookInfoArr[2] != "") {
					var AppLoc = obj.CTLocStore.getById(BookInfoArr[2]);
					var CTLocDesc = AppLoc.data.CTLocDesc;
					//Ext.getCmp("CTLoc").setValue(AppLoc.data.CTLocDesc);
					Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
					Ext.getCmp("CTLoc").setRawValue(CTLocDesc);
				} else {
					Ext.getCmp("CTLoc").setValue(BookInfoArr[2]);
					Ext.getCmp("CTLoc").setRawValue("");
				}
				if (BookInfoArr[3] != "") {
					var AppWard = obj.cboWardStore.getById(BookInfoArr[3]);
					var WardDesc = AppWard.data.CTLocDesc;
					Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
					Ext.getCmp("cboWard").setRawValue(WardDesc);
				} else {
					Ext.getCmp("cboWard").setValue(BookInfoArr[3]);
					Ext.getCmp("cboWard").setRawValue("");
				}
				obj.CTDoctorStore.load({
					callback: function() {
						if (BookInfoArr[4] != "") {
							var AppDoc = obj.CTDoctorStore.getById(BookInfoArr[4]);
							if (AppDoc != undefined) {
								var CTPCPDesc = AppDoc.data.CTPCPDesc;
								Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
								Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
							}
						} else {
							Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
							Ext.getCmp("CTDoctor").setRawValue("");
						}
					}
				});
				/*
				if(BookInfoArr[4]!="") {
					var AppDoc=obj.CTDoctorStore.getById(BookInfoArr[4]);
					if (AppDoc!=undefined) {
						var CTPCPDesc=AppDoc.data.CTPCPDesc;
						Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
						Ext.getCmp("CTDoctor").setRawValue(CTPCPDesc);
					}
				}else {
					Ext.getCmp("CTDoctor").setValue(BookInfoArr[4]);
					Ext.getCmp("CTDoctor").setRawValue("");
				}
				*/
				Ext.getCmp("orderInDate").setValue(BookInfoArr[5]);
				Ext.getCmp("advancePayment").setValue(BookInfoArr[6]);
				if (BookInfoArr[7] != "") {
					var Specialty = obj.specialtyStore.getById(BookInfoArr[7]);
					var SpecialtyDesc = Specialty.data.TCTMUDesc;
					Ext.getCmp("specialty").setValue(BookInfoArr[7]);
					Ext.getCmp("specialty").setRawValue(SpecialtyDesc);
				} else {
					Ext.getCmp("specialty").setValue(BookInfoArr[7]);
					Ext.getCmp("specialty").setRawValue("");
				}
				//Ext.getCmp("bedNo").setValue(BookInfoArr[8]);
				if (BookInfoArr[9] != "") {
					var TreatLevel = obj.TreatLevelStore.getById(BookInfoArr[9]);
					var TreatLevelDesc = TreatLevel.data.Desc;
					Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
					Ext.getCmp("TreatLevel").setRawValue(TreatLevelDesc);
				} else {
					Ext.getCmp("TreatLevel").setValue(BookInfoArr[9]);
					Ext.getCmp("TreatLevel").setRawValue("");
				}
			}else{
				alert("�ǼǺŲ�����")
				Ext.getCmp('PAPMINo').setValue(lastPAPMINo);
			}

		},
		scope: this
	});
}

////�������
/*
function Getmessage()
{
var message=tkMakeServerCall("Nur.DHCBedManager","GetChangebedAppnum");
var Authstatus=tkMakeServerCall("Nur.DHCBedManager","GetAuthstatus");   //��ǰ��λȨ��״̬ 

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
//// end