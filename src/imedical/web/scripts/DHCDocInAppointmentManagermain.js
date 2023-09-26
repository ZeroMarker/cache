
function InitviewScreen(){
//*****************查询条件************************
	var obj = new Object();

	obj.paadmInNo = new Ext.form.TextField({  //住院号
		id : 'paadmInNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '住院证号'
	});

	obj.startDate = new Ext.form.DateField({  //开始日期
		id : 'startDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '开始日期' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' 
		//,value : new Date()
	});

	obj.papminame = new Ext.form.TextField({
		id : 'papminame'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '姓名'
	});

	obj.paadmNo = new Ext.form.TextField({  //登记号
		id : 'paadmNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '登记号'
	});

	obj.endDate = new Ext.form.DateField({  //结束日期
		id : 'endDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '结束日期' 
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
			{boxLabel: '已分配', name: 'noBed'}
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
		,fieldLabel : '预约科室'
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
		,fieldLabel : '预约病区'
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
		,fieldLabel : '预约医生'
		,store : obj.CTDoctorStore
		//,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
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
			,fieldLabel : '排序方式'
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
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.printButton = new Ext.Button({
		id : 'printButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '打印'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.allotButton = new Ext.Button({
		id : 'allotButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '分配'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.CancleallotButton = new Ext.Button({
		id : 'CancleallotButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '取消分配'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	obj.CancleButton = new Ext.Button({
		id : 'CancleButton'
		,fieldLabel : ''
		,width : 120
		//,iconCls : 'icon-find'
		,text : '作废'
		,margins : {top:0, right:0, bottom:0, left:100}
	});

	/////陪床人性别下拉框
	obj.AccompanySexStore = new Ext.data.SimpleStore({
		//id : 'AccompanySexStore'
		fields : ['Code', 'value']
		,data : [['0', ''],['1', '男'],['2', '女'],['3', '未知性别'],['4', '未说明性别']]
	});

	obj.AccompanySex = new Ext.form.ComboBox({
		id : 'AccompanySex'
		,width : 100
		,store : obj.AccompanySexStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : '性别'
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

	//*****************查询条件************************
	//***************预约病人列表**********************
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
			,{name: 'paname', mapping: 'myPatName'}   //姓名
			,{name: 'paadmInNo', mapping: 'myIPBookNo'}  //住院号	
			,{name: 'paadmno', mapping: 'myPAPMINO'}  //登记号
			,{name: 'myMedicalNo', mapping: 'myMedicalNo'}  //病案号
			,{name: 'Sex', mapping: 'myPatSex'}  //性别
			,{name: 'myPatAge', mapping: 'myPatAge'}  //年龄
			,{name: 'registerDate', mapping: 'myBookDate'}  //登记日期
			,{name: 'CTLoc', mapping: 'myAppLoc'}  //预约科室  
			,{name: 'pabedNo', mapping: 'BedNo'}  //床位号
			,{name: 'CTDoc', mapping: 'CTDoc'}  //预约医生
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
			,loadMask : { msg : '正在读取数据,请稍后...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"序号"	,width:30})
			,{header: 'IPAppID', width: 100, dataIndex: 'IPAppID', sortable: true,hidden:true}
			,{header: 'AppLocID', width: 100, dataIndex: 'AppLocID', sortable: true,hidden:true}
			,{header: 'BedNoDr', width: 100, dataIndex: 'BedNoDr', sortable: true,hidden:true}
			,{header: '患者姓名', width: 80, dataIndex: 'paname', sortable: true}
			,{header: '住院号', width: 100, dataIndex: 'paadmInNo', sortable: true}
			,{header: '登记号', width: 100, dataIndex: 'paadmno', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'myMedicalNo', sortable: true}
			,{header: '性别', width: 70, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'myPatAge', sortable: true}
			,{header: '登记日期', width: 100, dataIndex: 'registerDate', sortable: true}
			,{header: '预约科室', width: 100, dataIndex: 'CTLoc', sortable: true}
			,{header: '床位号', width: 100, dataIndex: 'pabedNo', sortable: true}
			,{header: '预约医生', width: 100, dataIndex: 'CTDoc', sortable: true}		
			,{header: '住址', width: 100, dataIndex: 'PatAddress', sortable: true}	
			,{header: '联系电话', width: 100, dataIndex: 'PatMobPhone', sortable: true}	
			,{header: '家庭电话', width: 100, dataIndex: 'TelH', sortable: true}	
			]
			,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.AppPatientStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,  //是否显示数据信息
			emptyMsg: '没有记录'
		})
	});
		
		

	//***************预约病人列表**********************
	//*****************床位列表************************

	obj.ConditionDate = new Ext.form.DateField({  //查询日期
		id : 'ConditionDate' 
		,format : 'Y-m-d' 
		,width : 100 
		,fieldLabel : '查询日期' 
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
			{boxLabel: '明天',columnWidth : .3, id: 'Tomorrow'}
			,{boxLabel: '后天',columnWidth : .3, id: 'AfterTomorrow'}
			,{boxLabel: '大后天',columnWidth : .4, id: 'DHT'}
		]
	});

	////////////////////床位列表病区combox//////////////////
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
		,fieldLabel : '病区'
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
		//,labelWidth:65 //label的宽度,此属性将会遗传到子容器。
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
				,{name: 'BedNo', mapping: 'BedNo'}   //床位号
				,{name: 'BedState', mapping: 'BedState'}  //床位状态
				//,{name: 'BedLoc', mapping: 'BedLoc'}  //床位科室
				,{name: 'BedWard', mapping: 'BedWard'}  //床位病区
				,{name: 'BedSex', mapping: 'BedSex'}  //床位性别
				,{name: 'BedBill', mapping: 'BedBill'}  //床位费  
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
			,loadMask : { msg : '正在读取数据,请稍后...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"序号"	,width:35})
				,{header: 'BedRowId', width: 100, dataIndex: 'BedRowId', sortable: true,hidden:true}
				,{header: '床位号', width: 80, dataIndex: 'BedNo', sortable: true}
				,{header: '床位状态', width: 80, dataIndex: 'BedState', sortable: true}
				//,{header: '床位科室', width: 100, dataIndex: 'BedLoc', sortable: true}
				,{header: '床位病区', width: 150, dataIndex: 'BedWard', sortable: true}
				,{header: '床位性别', width: 70, dataIndex: 'BedSex', sortable: true}
				,{header: '床位费', width: 80, dataIndex: 'BedBill', sortable: true}		
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
		//,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		//,columnWidth : .60 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		
		items : [
				obj.ConditionFieldSet,
				obj.AppBed
				]
	});
	//*****************床位列表************************
	//*****************病人信息************************
			
	obj.paInfoStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url:''}),//paInfoStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total'//,
				//idProperty: 'paadmno'
			}, 
			[
					{name: 'checked', mapping : 'checked'}
			,{name: 'PatientName', mapping: 'PatientName'}  //病人姓名
			,{name: 'PatientSex', mapping: 'PatientSex'}  //病人性别  
			,{name: 'PatientLoc', mapping: 'PatientLoc'}  //预约科室
			,{name: 'RegisterDate', mapping: 'RegisterDate'}  //登记日期
			,{name: 'PatAge', mapping: 'PatAge'}  //登记日
			,{name: 'PatMobPhone', mapping: 'PatMobPhone'}  //联系电话
			,{name: 'TelH', mapping: 'TelH'}  //家庭电话
			,{name: 'PatAddress', mapping: 'PatAddress'}  //住址
			,{name: 'PatientInNo', mapping: 'PatientInNo'}  //住院号
			,{name: 'PatientType', mapping: 'PatientType'}  //病人费别
			,{name: 'PatientWard', mapping: 'PatientWard'}  //预约病区
			//,{name: 'AppDate', mapping: 'AppDate'}  //预约日期
			,{name: 'AllocateDate', mapping: 'AllocateDate'}
			//,{name: 'AdmissionDate', mapping: 'AdmissionDate'}  //入院日期
			,{name: 'PatientBed', mapping: 'PatientBed'}  //病人床位
			,{name: 'PatientState', mapping: 'PatientState'}  //状态(预约，已分配，入院)
			,{name: 'AdmissionEvid', mapping: 'AdmissionEvid'}  //入院凭证
			,{name: 'MedicalNo', mapping: 'MedicalNo'}   //病案号
			,{name: 'PatientAdmNo', mapping: 'PatientAdmNo'}  //登记号
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
			,loadMask : { msg : '正在读取数据,请稍后...'}  
			,columns: [
				new Ext.grid.RowNumberer({header:"序号"	,width:20})
			,{header: '病人姓名', width: 80, dataIndex: 'PatientName', sortable: true}
			,{header: '病人性别', width: 80, dataIndex: 'PatientSex', sortable: true}
			,{header: '预约科室', width: 100, dataIndex: 'PatientLoc', sortable: true}
			,{header: '预约病区', width: 100, dataIndex: 'PatientWard', sortable: true}
			,{header: '登记日期', width: 100, dataIndex: 'RegisterDate', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'PatAge', sortable: true}
			,{header: '病案号', width: 100, dataIndex: 'MedicalNo', sortable: true}
			,{header: '预约入院日期', width: 100, dataIndex: 'AllocateDate', sortable: true}	
			//,{header: '入院日期', width: 100, dataIndex: 'AdmissionDate', sortable: true}	
			,{header: '陪床人性别', width: 80, dataIndex: 'AccompanySex', sortable: true}
			,{header: '联系电话', width: 100, dataIndex: 'PatMobPhone', sortable: true}
			,{header: '家庭电话', width: 100, dataIndex: 'TelH', sortable: true}
			,{header: '住址', width: 150, dataIndex: 'PatAddress', sortable: true}
			,{header: '住院证号', width: 100, dataIndex: 'PatientInNo', sortable: true}
			,{header: '登记号', width: 100, dataIndex: 'PatientAdmNo', sortable: true}
			,{header: '病人费别', width: 100, dataIndex: 'PatientType', sortable: true}	
			,{header: '预约日期', width: 100, dataIndex: 'AppDate', sortable: true}
			,{header: '病人床位', width: 100, dataIndex: 'PatientBed', sortable: true}
			,{header: '状态', width: 100, dataIndex: 'PatientState', sortable: true}
			,{header: '入院凭证', width: 100, dataIndex: 'AdmissionEvid', sortable: true}
			,{header: '预约信息录入人', width: 100, dataIndex: 'myInfoEnterUser', sortable: true}
			,{header: '床位分配人', width: 100, dataIndex: 'myBedDistributeUser', sortable: true}
			,{header: '预约信息作废人', width: 100, dataIndex: 'myInfoCancelUser', sortable: true}
			]
		});
	//*****************病人信息************************
		obj.viewScreen=new Ext.Viewport({
			enableTabScroll:true,
			collapsible:true,
			layout:"border",
			items:[
			{region:"north",layout:"fit",height:120,title:"查询条件",items:[obj.ConditionPanel]},
			{region:"south",layout:"fit",height:100,split:true,border:true,collapsible:true,autoScroll:true,title:"病人信息",items:[obj.paInfo]},
			{region:"west",layout:"fit",width:700,split:true,border:true,collapsible:true,autoScroll:true, title:"预约病人列表",items:[obj.AppPatient]},
			{region:"center",layout:"fit",split:true,border:true,collapsible:true,autoScroll:true,title:"床位列表",items:[obj.BedFormPanel]}]
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
		Ext.getCmp("SortMethod").setRawValue("登记时间");
		
		Getmessage();
		
		//事件处理代码
		InitviewScreenEvent(obj);
		//alert("gg")
		//obj.btnQuery_OnClick();
		obj.LoadEvent(arguments);	
		return obj;
}

	////弹框程序
	/*
	function Getmessage()
	{
	obj.message=tkMakeServerCall("web.DHCBedManager","GetChangebedAppnum");
	obj.Authstatus=tkMakeServerCall("web.DHCBedManager","GetAuthstatus");   //当前床位权限状态 

	if (message!="0")
	{

	//$.messager.show("<font color='red'>信息提示</font>","<a href='DHCBedAuditingManager.csp' onclick='window.open('href','_blank','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')'>"+gg+"</a>",0);

	//$.messager.show("<font color='red'>信息提示</font>","<a href='#' onclick='BedAudit()'>"+message+"</a>",0);
	$.messager.show("<font color='red'>"+Authstatus+"</font>","<a href='#' onclick='BedAudit()'>"+message+"</a>",0);

	}
	else
	{
	$.messager.show("<font color='red'>"+Authstatus+"</font>","<a href='#' onclick='BedAudit()'>"+"暂无换床申请"+"</a>",0);
	}
	setTimeout(Getmessage,30000);


	}

	function BedAudit()
	{

	obj.lnk='DHCBedAuditingManager.csp'
	 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1890,height=680,left=120,top=0')
	//window.close();
	}
	
	//singleSelect:true //如果值是false，表明可以选择多行；否则只能选择一行
	}*/
