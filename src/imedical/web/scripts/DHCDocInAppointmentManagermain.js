
function InitviewScreen(){
//*****************��ѯ����************************
	var obj = new Object();

	obj.paadmInNo = new Ext.form.TextField({  //סԺ��
		id : 'paadmInNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : 'סԺ֤��'
	});

	obj.startDate = new Ext.form.DateField({  //��ʼ����
		id : 'startDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '��ʼ����' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' 
		//,value : new Date()
	});

	obj.papminame = new Ext.form.TextField({
		id : 'papminame'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����'
	});

	obj.paadmNo = new Ext.form.TextField({  //�ǼǺ�
		id : 'paadmNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '�ǼǺ�'
	});

	obj.endDate = new Ext.form.DateField({  //��������
		id : 'endDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '��������' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' 
		//,value : new Date()
	});

	obj.noBedInPaadm = new Ext.form.CheckboxGroup({
		id : 'noBedInPaadm'
		,xtype: 'checkboxgroup'
		,width : 150
		,anchor : '100%'
		,items: [
			{boxLabel: '�ѷ���', name: 'noBed'}
		]
	});

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
		,minChars : 1
		,selectOnFocus : true 
		,forceSelection : true  
		,store : obj.cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : 'ԤԼ����'
		,editable : true 
		,triggerAction : 'all' 
		,anchor : '100%'
		,valueField : 'CTLocID'
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
		,width : 100
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

	obj.findButton = new Ext.Button({
		id : 'findButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '��ѯ'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.printButton = new Ext.Button({
		id : 'printButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '��ӡ'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.allotButton = new Ext.Button({
		id : 'allotButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '����'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.CancleallotButton = new Ext.Button({
		id : 'CancleallotButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : 'ȡ������'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.CancleButton = new Ext.Button({
		id : 'CancleButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '����'
		,margins : {top:0, right:0, bottom:0, left:100}
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
		,anchor : '80%'
		,valueField : 'Code'
		,mode:"local"
	});
	/////end

	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'center',
		labelAlign : 'center', 
		labelWidth : 60,
		bodyBorder : 'padding:0 0 0 0',
		layout : 'column',
		//region : 'north',
		frame : true,
		height : 90,
		items : [
			{buttonAlign : 'center',
			columnWidth : .2,
			layout : 'form',
			items : [obj.paadmInNo,obj.startDate,obj.papminame]
			},
			{buttonAlign : 'center',
			columnWidth : .2,
			layout : 'form',
			items : [obj.paadmNo,obj.endDate,obj.SortMethod]
			},
			{buttonAlign : 'center',
			columnWidth : .2,
			layout : 'form',
			items : [obj.cboWard,obj.CTLoc,obj.CTDoctor]
			},
			{buttonAlign : 'center',
			columnWidth : .2,
			layout : 'form',
			items : [obj.noBedInPaadm,obj.AccompanySex,obj.findButton]
			},
			{buttonAlign : 'center',
			columnWidth : .2,
			layout : 'form',
			items : [obj.allotButton,obj.CancleButton,obj.CancleallotButton]
			}
		]
	});

	obj.CTLocStoreProxy.on('beforeload', function(objProxy, param){
		var HospitalId = session['LOGON.HOSPID'];
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.CTLoc.getRawValue();
		param.Arg2 = 'E';
		param.Arg3 = obj.cboWard.getValue();
		param.Arg4 = HospitalId;
		param.ArgCnt = 4;
	});

	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
		var HospitalId = session['LOGON.HOSPID'];
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.cboWard.getRawValue();
		param.Arg2 = 'W';
		param.Arg3 = obj.CTLoc.getValue();
		param.Arg4 = HospitalId;
		param.ArgCnt = 4;
	});

	obj.CTDoctorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'FindCTCareProvByLoc';			
		param.Arg1 = obj.CTLoc.getValue();
		param.ArgCnt = 1;
	});

	//*****************��ѯ����************************
	//***************ԤԼ�����б�**********************
	obj.AppPatientStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));	
	obj.AppPatientStore = new Ext.data.Store({
			proxy:obj.AppPatientStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'IPAppID'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
			,{name: 'IPAppID', mapping : 'IPAppID'}
			,{name: 'AppLocID', mapping : 'myAppLocDr'}
			,{name: 'BedNoDr', mapping : 'BedNoDr'}	
			,{name: 'paname', mapping: 'myPatName'}   //����
			,{name: 'paadmInNo', mapping: 'myIPBookNo'}  //סԺ��	
			,{name: 'paadmno', mapping: 'myPAPMINO'}  //�ǼǺ�
			,{name: 'myMedicalNo', mapping: 'myMedicalNo'}  //������
			,{name: 'Sex', mapping: 'myPatSex'}  //�Ա�
			,{name: 'myPatAge', mapping: 'myPatAge'}  //����
			,{name: 'registerDate', mapping: 'myBookDate'}  //�Ǽ�����
			,{name: 'CTLoc', mapping: 'myAppLoc'}  //ԤԼ����  
			,{name: 'pabedNo', mapping: 'BedNo'}  //��λ��
			,{name: 'CTDoc', mapping: 'CTDoc'}  //ԤԼҽ��
			,{name: 'PatAddress', mapping: 'PatAddress'}
			,{name: 'PatMobPhone', mapping: 'PatMobPhone'}
			,{name: 'TelH', mapping: 'TelH'}
			])
		});
		
	obj.AppPatientCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });
		
	obj.AppPatient = new Ext.grid.GridPanel({
			id : 'AppPatient'
			,store : obj.AppPatientStore
			,buttonAlign : 'center'
			,autoScroll:true
			//,bodyStyle : 'overflow-x:scroll; overflow-y:scroll'   
			,sm:new Ext.grid.RowSelectionModel({
				singleSelect:true
				})
			,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"���"	,width:30})
			,{header: 'IPAppID', width: 100, dataIndex: 'IPAppID', sortable: true,hidden:true}
			,{header: 'AppLocID', width: 100, dataIndex: 'AppLocID', sortable: true,hidden:true}
			,{header: 'BedNoDr', width: 100, dataIndex: 'BedNoDr', sortable: true,hidden:true}
			,{header: '��������', width: 80, dataIndex: 'paname', sortable: true}
			,{header: 'סԺ��', width: 100, dataIndex: 'paadmInNo', sortable: true}
			,{header: '�ǼǺ�', width: 100, dataIndex: 'paadmno', sortable: true}
			,{header: '������', width: 80, dataIndex: 'myMedicalNo', sortable: true}
			,{header: '�Ա�', width: 70, dataIndex: 'Sex', sortable: true}
			,{header: '����', width: 50, dataIndex: 'myPatAge', sortable: true}
			,{header: '�Ǽ�����', width: 100, dataIndex: 'registerDate', sortable: true}
			,{header: 'ԤԼ����', width: 100, dataIndex: 'CTLoc', sortable: true}
			,{header: '��λ��', width: 100, dataIndex: 'pabedNo', sortable: true}
			,{header: 'ԤԼҽ��', width: 100, dataIndex: 'CTDoc', sortable: true}		
			,{header: 'סַ', width: 100, dataIndex: 'PatAddress', sortable: true}	
			,{header: '��ϵ�绰', width: 100, dataIndex: 'PatMobPhone', sortable: true}	
			,{header: '��ͥ�绰', width: 100, dataIndex: 'TelH', sortable: true}	
			]
			,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.AppPatientStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,  //�Ƿ���ʾ������Ϣ
			emptyMsg: 'û�м�¼'
		})
	});
		
		

	//***************ԤԼ�����б�**********************
	//*****************��λ�б�************************

	obj.ConditionDate = new Ext.form.DateField({  //��ѯ����
		id : 'ConditionDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '��ѯ����' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' 
		,value:new Date()  //.add(Date.DAY, +1)
		//,value : new Date()
	});

	obj.DateCheckBox = new Ext.form.CheckboxGroup({
		id : 'DateCheckBox'
		,xtype: 'checkboxgroup'
		,width : 150
		,anchor : '70%'
		,items: [
			{boxLabel: '����',columnWidth : .3, id: 'Tomorrow'}
			,{boxLabel: '����',columnWidth : .3, id: 'AfterTomorrow'}
			,{boxLabel: '�����',columnWidth : .4, id: 'DHT'}
		]
	});

	////////////////////��λ�б���combox//////////////////
	obj.bedcboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.bedcboWardStore = new Ext.data.Store({
		proxy: obj.bedcboWardStoreProxy,
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

	obj.bedcboWard = new Ext.form.ComboBox({
		id : 'bedcboWard'
		,width : 100
		,minChars : 1
		,selectOnFocus : true 
		,forceSelection : true  
		,store : obj.bedcboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '����'
		,editable : true 
		,triggerAction : 'all' 
		,anchor : '100%'
		,valueField : 'CTLocID'
	});

	obj.bedcboWardStoreProxy.on('beforeload', function(objProxy, param){
		var HospitalId = session['LOGON.HOSPID'];
		param.ClassName = 'web.DHCDocIPAppointment';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.bedcboWard.getRawValue();
		param.Arg2 = 'W';
		param.Arg3 = "";  //CTLoc.getValue();
		param.Arg4 = HospitalId;
		param.ArgCnt = 4;
	});

	obj.bedcboWardCondition=new Ext.Panel({
		id : 'bedcboWardCondition'
		,buttonAlign : 'center'
		,columnWidth : .35
		,labelWidth : 70
		,layout:'form'
		,items:[obj.bedcboWard]  
	});

	obj.DateCheckBoxCondition=new Ext.Panel({
		id : 'DateCheckBoxCondition'
		,buttonAlign : 'center'
		,columnWidth : .65
		,labelWidth : 50
		,layout:'form'
		,items:[obj.DateCheckBox]  
	});

	obj.BedCondition=new Ext.Panel({
		id : 'BedCondition'
		,buttonAlign : 'center'
		,columnWidth : .35
		,labelWidth : 70
		,layout:'form'
		,items:[obj.ConditionDate]  
	});

	obj.ConditionFieldSet = new Ext.form.FieldSet({
		id : 'ConditionFieldSet'
		,region:'north'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height: 80
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [obj.BedCondition,obj.DateCheckBoxCondition,obj.bedcboWardCondition]
	});

	obj.AppBedStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url:''}),//AppBedStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total'//,
				//idProperty: 'paadmno'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'BedRowId', mapping : 'BedRowId'}
				,{name: 'BedNo', mapping: 'BedNo'}   //��λ��
				,{name: 'BedState', mapping: 'BedState'}  //��λ״̬
				//,{name: 'BedLoc', mapping: 'BedLoc'}  //��λ����
				,{name: 'BedWard', mapping: 'BedWard'}  //��λ����
				,{name: 'BedSex', mapping: 'BedSex'}  //��λ�Ա�
				,{name: 'BedBill', mapping: 'BedBill'}  //��λ��  
			])
		});
		
	obj.AppBedCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		
	obj.AppBed = new Ext.grid.GridPanel({
			id : 'AppBed'
			,store : obj.AppBedStore
			,region : 'center'
			//,layout: 'fit'
			,height:'auto'
			,buttonAlign : 'center'
			,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"���"	,width:35})
				,{header: 'BedRowId', width: 100, dataIndex: 'BedRowId', sortable: true,hidden:true}
				,{header: '��λ��', width: 80, dataIndex: 'BedNo', sortable: true}
				,{header: '��λ״̬', width: 80, dataIndex: 'BedState', sortable: true}
				//,{header: '��λ����', width: 100, dataIndex: 'BedLoc', sortable: true}
				,{header: '��λ����', width: 150, dataIndex: 'BedWard', sortable: true}
				,{header: '��λ�Ա�', width: 70, dataIndex: 'BedSex', sortable: true}
				,{header: '��λ��', width: 80, dataIndex: 'BedBill', sortable: true}		
			]
		});

	obj.BedFormPanel = new Ext.form.FormPanel({
		id : 'BedFormPanel',
		buttonAlign : 'center',
		labelAlign : 'center', 
		labelWidth : 100,
		layout : 'border',
		//region : 'north',
		frame : true,
		//height : 30,
		//,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		//,columnWidth : .60 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		
		items : [
				obj.ConditionFieldSet,
				obj.AppBed
				]
	});
	//*****************��λ�б�************************
	//*****************������Ϣ************************
			
	obj.paInfoStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url:''}),//paInfoStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total'//,
				//idProperty: 'paadmno'
			}, 
			[
					{name: 'checked', mapping : 'checked'}
			,{name: 'PatientName', mapping: 'PatientName'}  //��������
			,{name: 'PatientSex', mapping: 'PatientSex'}  //�����Ա�  
			,{name: 'PatientLoc', mapping: 'PatientLoc'}  //ԤԼ����
			,{name: 'RegisterDate', mapping: 'RegisterDate'}  //�Ǽ�����
			,{name: 'PatAge', mapping: 'PatAge'}  //�Ǽ���
			,{name: 'PatMobPhone', mapping: 'PatMobPhone'}  //��ϵ�绰
			,{name: 'TelH', mapping: 'TelH'}  //��ͥ�绰
			,{name: 'PatAddress', mapping: 'PatAddress'}  //סַ
			,{name: 'PatientInNo', mapping: 'PatientInNo'}  //סԺ��
			,{name: 'PatientType', mapping: 'PatientType'}  //���˷ѱ�
			,{name: 'PatientWard', mapping: 'PatientWard'}  //ԤԼ����
			//,{name: 'AppDate', mapping: 'AppDate'}  //ԤԼ����
			,{name: 'AllocateDate', mapping: 'AllocateDate'}
			//,{name: 'AdmissionDate', mapping: 'AdmissionDate'}  //��Ժ����
			,{name: 'PatientBed', mapping: 'PatientBed'}  //���˴�λ
			,{name: 'PatientState', mapping: 'PatientState'}  //״̬(ԤԼ���ѷ��䣬��Ժ)
			,{name: 'AdmissionEvid', mapping: 'AdmissionEvid'}  //��Ժƾ֤
			,{name: 'MedicalNo', mapping: 'MedicalNo'}   //������
			,{name: 'PatientAdmNo', mapping: 'PatientAdmNo'}  //�ǼǺ�
			,{name: 'AccompanySex', mapping: 'AccompanySex'}
			,{name: 'myInfoEnterUser', mapping: 'myInfoEnterUser'}
			,{name: 'myBedDistributeUser', mapping: 'myBedDistributeUser'}
			,{name: 'myInfoCancelUser', mapping: 'myInfoCancelUser'}
			])
		});
		
	obj.paInfoCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		
	obj.paInfo = new Ext.grid.GridPanel({
			id : 'paInfo'
			,store : obj.paInfoStore
			//,region : 'center'
			,buttonAlign : 'center'
			,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"���"	,width:20})
			,{header: '��������', width: 80, dataIndex: 'PatientName', sortable: true}
			,{header: '�����Ա�', width: 80, dataIndex: 'PatientSex', sortable: true}
			,{header: 'ԤԼ����', width: 100, dataIndex: 'PatientLoc', sortable: true}
			,{header: 'ԤԼ����', width: 100, dataIndex: 'PatientWard', sortable: true}
			,{header: '�Ǽ�����', width: 100, dataIndex: 'RegisterDate', sortable: true}
			,{header: '����', width: 50, dataIndex: 'PatAge', sortable: true}
			,{header: '������', width: 100, dataIndex: 'MedicalNo', sortable: true}
			,{header: 'ԤԼ��Ժ����', width: 100, dataIndex: 'AllocateDate', sortable: true}	
			//,{header: '��Ժ����', width: 100, dataIndex: 'AdmissionDate', sortable: true}	
			,{header: '�㴲���Ա�', width: 80, dataIndex: 'AccompanySex', sortable: true}
			,{header: '��ϵ�绰', width: 100, dataIndex: 'PatMobPhone', sortable: true}
			,{header: '��ͥ�绰', width: 100, dataIndex: 'TelH', sortable: true}
			,{header: 'סַ', width: 150, dataIndex: 'PatAddress', sortable: true}
			,{header: 'סԺ֤��', width: 100, dataIndex: 'PatientInNo', sortable: true}
			,{header: '�ǼǺ�', width: 100, dataIndex: 'PatientAdmNo', sortable: true}
			,{header: '���˷ѱ�', width: 100, dataIndex: 'PatientType', sortable: true}	
			,{header: 'ԤԼ����', width: 100, dataIndex: 'AppDate', sortable: true}
			,{header: '���˴�λ', width: 100, dataIndex: 'PatientBed', sortable: true}
			,{header: '״̬', width: 100, dataIndex: 'PatientState', sortable: true}
			,{header: '��Ժƾ֤', width: 100, dataIndex: 'AdmissionEvid', sortable: true}
			,{header: 'ԤԼ��Ϣ¼����', width: 100, dataIndex: 'myInfoEnterUser', sortable: true}
			,{header: '��λ������', width: 100, dataIndex: 'myBedDistributeUser', sortable: true}
			,{header: 'ԤԼ��Ϣ������', width: 100, dataIndex: 'myInfoCancelUser', sortable: true}
			]
		});
	//*****************������Ϣ************************
		obj.viewScreen=new Ext.Viewport({
			enableTabScroll:true,
			collapsible:true,
			layout:"border",
			items:[
			{region:"north",layout:"fit",height:120,title:"��ѯ����",items:[obj.ConditionPanel]},
			{region:"south",layout:"fit",height:100,split:true,border:true,collapsible:true,autoScroll:true,title:"������Ϣ",items:[obj.paInfo]},
			{region:"west",layout:"fit",width:700,split:true,border:true,collapsible:true,autoScroll:true, title:"ԤԼ�����б�",items:[obj.AppPatient]},
			{region:"center",layout:"fit",split:true,border:true,collapsible:true,autoScroll:true,title:"��λ�б�",items:[obj.BedFormPanel]}]
		});

		Ext.get('CTLoc').on('blur', function(){
			obj.cboWardStore.load({});
			obj.TDoctorStore.load({});
		});
		Ext.get('cboWard').on('blur', function(){
			obj.CTLocStore.load({});
			obj.CTDoctorStore.load({});
		});
		Ext.getCmp("SortMethod").setValue(1);
		Ext.getCmp("SortMethod").setRawValue("�Ǽ�ʱ��");
		
		Getmessage();
		
		//�¼��������
		InitviewScreenEvent(obj);
		//alert("gg")
		//obj.btnQuery_OnClick();
		obj.LoadEvent(arguments);	
		return obj;
}

	////�������
	/*
	function Getmessage()
	{
	obj.message=tkMakeServerCall("web.DHCBedManager","GetChangebedAppnum");
	obj.Authstatus=tkMakeServerCall("web.DHCBedManager","GetAuthstatus");   //��ǰ��λȨ��״̬ 

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

	obj.lnk='DHCBedAuditingManager.csp'
	 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1890,height=680,left=120,top=0')
	//window.close();
	}
	
	//singleSelect:true //���ֵ��false����������ѡ����У�����ֻ��ѡ��һ��
	}*/
