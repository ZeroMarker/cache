

function InitviewScreen() {
	
	var obj = new Object();
	
	obj.paadmadmno = new Ext.form.TextField({
		id : 'paadmadmno' //唯一的组件id（默认为自动分配的id）。出于你打算用id来获取组件引用这一目的（像使用Ext.ComponentMgrgetCmp的情形），你就会送入一个你写好的id到这个方法。提示：容器的元素即HTML元素也会使用该id渲染在页面上。如此一来你就可以采用CSS id匹配的规则来定义该组件的样式。换句话说，实例化该组件时，送入不同的Id，就有对应不同的样式效果。
		,width : 100
		,anchor : '100%'
		,fieldLabel : '住院证号' //在组件旁边那里显示的label文本（默认为''）。此组件只有在FormLayout布局管理器控制的容器下渲染才有用.
	});
	
	obj.papminame = new Ext.form.TextField({
		id : 'papminame'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '姓名'
	});
	
	obj.paadmno = new Ext.form.TextField({
		id : 'paadmno'
		,width : 100
		,anchor : '100%'
		,fieldLabel : '登记号'
	});
		
	obj.registerStartDate = new Ext.form.DateField({ //提供一个下拉的Ext.DatePicker日期选择、自动效验控件的日期输入字段。
		id : 'registerStartDate' 
		,format : 'Y-m-d' //用以覆盖本地化的默认日期格式化字串。字串必须为符合指定DateparseDate的形式(默认为 'm/d/y')。
		,width : 80 
		,fieldLabel : '登记开始日期' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' //用 "|" 符号分隔的多个日期格式化字串，当输入的日期与默认的格式不符时用来尝试格式化输入值(默认为 'm/d/Y|m-d-y|m-d-Y|m/d|m-d|d')。
		//,value : new Date()  //字段初始化的值（默认为undefined）。
	});
	
	obj.registerEndDate = new Ext.form.DateField({ //提供一个下拉的Ext.DatePicker日期选择、自动效验控件的日期输入字段。
		id : 'registerEndDate' 
		,format : 'Y-m-d' //用以覆盖本地化的默认日期格式化字串。字串必须为符合指定DateparseDate的形式(默认为 'm/d/y')。
		,width : 80 
		,fieldLabel : '登记结束日期' 
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y' //用 "|" 符号分隔的多个日期格式化字串，当输入的日期与默认的格式不符时用来尝试格式化输入值(默认为 'm/d/Y|m-d-y|m-d-Y|m/d|m-d|d')。
		//,value : new Date()  //字段初始化的值（默认为undefined）。
	});
	
	obj.IfAllocateStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['B', '已预约'],['Al', '已分配'],['Ar', '已入院'],['C', '已作废'],['H', '已挂起']]
	});
	
	obj.IfAllocate = new Ext.form.ComboBox({
		id : 'IfAllocate'
		,width : 100
		,store : obj.IfAllocateStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : '病人状态'
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
		,data : [['1', '开证时间'],['2', '登记时间'],['3', '门诊优先'],['4', '急诊优先']]
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
	
	/*
	obj.IfAllocate = new Ext.form.CheckboxGroup({
		id : 'IfAllocate'
		,xtype: 'checkboxgroup'
		,width : 150
		//,anchor : '95%'
		,items: [
			{boxLabel: '门急诊', name: 'noBed'}
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
		,fieldLabel : '预约科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'CTLocID'
});

	obj.orderInDate = new Ext.form.DateField({
		id : 'orderInDate',
		format : 'Y-m-d',
		width : 100,
		fieldLabel : '预约入院日期',
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
		,minChars : 1 //在自动完成和typeAhead 激活之前，用户必须输入的最少字符数
		,selectOnFocus : true //true 将会在获得焦点时理解选中表单项中所有存在的文本。 仅当editable = true 时应用(默认为false)。 
		,forceSelection : true //true 将会限定选择的值是列表中的值之一， false将会允许用户向表单项中设置任意值 (默认为false) 
		,store : obj.cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '预约病区'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
		,triggerAction : 'all'  //当触发器被点击时需要执行的操作。
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
		,text : '查询'
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
		,fieldLabel : '预约医生'
		,store : obj.CTDoctorStore
		//,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
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
		,fieldLabel : '预约院区'
		,store : obj.CTHospitalStore
		//,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
		,anchor : '100%'
		,valueField : 'HosCode'
	});
	
	obj.CTHospitalStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';			
			param.Arg1 = '';
			param.ArgCnt = 1;
	}); 
	
	//时间范围
	obj.DateConditionStore = new Ext.data.SimpleStore({
		//id : 'IfAllocateStore'
		fields : ['Code', 'value']
		,data : [['0', '所有'],['1', '三个月前'],['2', '半年前'],['3', '一年前'],['4', '两年前']]
	});
	obj.DateCondition = new Ext.form.ComboBox({
		id : 'DateCondition'
		,width : 100
		,store : obj.DateConditionStore
		//,minChars : 1
		,displayField : 'value'
		,fieldLabel : '时间范围'
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
		,text : '作废'
	});
	
	obj.btnReCancle = new Ext.Button({
		id : 'btnReCancle'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '取消作废'
	});
	
	obj.btnCancleAllocate = new Ext.Button({
		id : 'btnCancleAllocate'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '取消分配'
	});
	
	///挂起
	obj.btnHang = new Ext.Button({
		id : 'btnHang'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '挂起'
	});
	obj.btnCancleHang = new Ext.Button({
		id : 'btnCancleHang'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '取消挂起'
	});
	///end
	obj.ChangeAppInfo = new Ext.Button({
		id : 'ChangeAppInfo'
		,width : 100
		//,iconCls : 'icon-export'
		,text : '更改预约信息'
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
		text : '导出'
	});
	*/
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [obj.paadmadmno,
				obj.cboWard,
				obj.registerStartDate,
				obj.DateCondition,
				obj.AccompanySex]  //一个单独项，或子组件组成的数组，加入到此容器中。
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
		buttonAlign : 'right', //添加到当前panel的所有 buttons 的对齐方式。 
		labelAlign : 'right', //该容器中可用的文本对齐值，合法值有 "left", "top" 和 "right" (默认为 "left").
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
		,loadMask : { msg : '正在读取数据,请稍后...'} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
		//,plugins: obj.expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
		,columns: [
			obj.gridResultsm
			,new Ext.grid.RowNumberer({header:"序号"	,width:40})
			,{header: 'IPAppID', width: 100, dataIndex: 'IPAppID', sortable: true,hidden:true}
			,{header: '登记日期', width: 100, dataIndex: 'myBookDate', sortable: true}
			,{header: '患者姓名', width: 100, dataIndex: 'myPatName', sortable: true}
			,{header: '性别', width: 70, dataIndex: 'myPatSex', sortable: true}
			,{header: '类型', width: 70, dataIndex: 'PatType', sortable: true}
			,{header: '预约科室', width: 100, dataIndex: 'myAppLoc', sortable: true}
			,{header: '预约入院日期', width: 100, dataIndex: 'myAppDate', sortable: true}
			,{header: '陪床人性别', width: 100, dataIndex: 'AccompanySex', sortable: false}
			,{header: '床号', width: 100, dataIndex: 'BedNo', sortable: false}
			,{header: '状态', width: 100, dataIndex: 'IPStatus', sortable: true}
			,{header: '联系电话', width: 100, dataIndex: 'PatMobPhone', sortable: true}
			,{header: '家庭电话', width: 100, dataIndex: 'TelH', sortable: true}
			//,{header: '入院日期', width: 100, dataIndex: 'IPDate', sortable: true}	
			,{header: '住址', width: 100, dataIndex: 'PatAddress', sortable: true}	
			,{header: '登记号', width: 100, dataIndex: 'myPAPMINO', sortable: true}
		]
		,sm:obj.gridResultsm
		
	});
	// ,bbar: new Ext.PagingToolbar({
	// 		pageSize : 1000,
	// 		store : obj.gridResultStore,
	// 		displayMsg: '显示记录： {0} - {1} 合计： {2}',
	// 		displayInfo: true,
	// 		emptyMsg: '没有记录'
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
	Ext.getCmp("SortMethod").setRawValue("登记时间");
	//end
    
    Getmessage();
    
	//事件处理代码
	InitviewScreenEvent(obj);
	obj.btnQuery_OnClick();
	obj.LoadEvent(arguments);
	return obj;
}

////弹框程序
/*
function Getmessage()
{
var message=tkMakeServerCall("web.DHCBedManager","GetChangebedAppnum");
var Authstatus=tkMakeServerCall("web.DHCBedManager","GetAuthstatus");   //当前床位权限状态 

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

var lnk='DHCBedAuditingManager.csp'
 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1890,height=680,left=120,top=0')
//window.close();
}
*/