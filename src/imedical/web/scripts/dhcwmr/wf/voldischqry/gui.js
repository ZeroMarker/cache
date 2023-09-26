var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.BackDays = 0;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","出院日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	
	//科室组
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocGroupStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocGroupStore = new Ext.data.Store({
		proxy: obj.cboLocGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'GroupID'
		},[
			{name: 'GroupID', mapping : 'GroupID'}
			,{name: 'GroupCode', mapping: 'GroupCode'}
			,{name: 'GroupDesc', mapping: 'GroupDesc'}
		])
	});
	obj.cboLocGroup = new Ext.form.ComboBox({
		id : 'cboLocGroup'
		,fieldLabel : '回收组'
		,labelSeparator :''
		,store : obj.cboLocGroupStore
		,minChars : 1
		,valueField : 'GroupID'
		,displayField : 'GroupDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	//科室
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,fieldLabel : '科室'
		,labelSeparator :''
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	obj.btnDischQry = new Ext.Button({
		id : 'btnDischQry'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '出院查询'
	});
	
	obj.btnNoBack = new Ext.Button({
		id : 'btnNotBack'
		,iconCls : 'icon-cancel'
		,width : 50
		,anchor : '100%'
		,text : '未回收'
	});
	
	obj.btnBatBack = new Ext.Button({
		id : 'btnBatBack'
		,iconCls : 'icon-update'
		,width : 60
		,anchor : '100%'
		,text : '批量回收'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 50
		,anchor : '100%'
		,text : '打印'
	});
	
	obj.btnBack = new Ext.Button({
		id : 'btnBack'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '已回收'
	});
	
	obj.btn2DaysLate = new Ext.Button({
		id : 'btn2DaysLate'
		,iconCls : 'icon-cancel'
		,width : 60
		,anchor : '100%'
		,text : '2日迟归'
	});
	
	obj.btn3DaysLate = new Ext.Button({
		id : 'btn3DaysLate'
		,iconCls : 'icon-cancel'
		,width : 60
		,anchor : '100%'
		,text : '3日迟归'
	});
	
	obj.btn7DaysLate = new Ext.Button({
		id : 'btn7DaysLate'
		,iconCls : 'icon-cancel'
		,width : 60
		,anchor : '100%'
		,text : '7日迟归'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 60
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.DischAdmGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.DischAdmGridStore = new Ext.data.Store({
		proxy: obj.DischAdmGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'VolID', mapping : 'VolID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			//,{name: 'ChiefProfessor', mapping: 'ChiefProfessor'}
			//,{name: 'Professor', mapping: 'Professor'}
			//,{name: 'VistingDoctor', mapping: 'VistingDoctor'}
			//,{name: 'ResidentDoctor', mapping: 'ResidentDoctor'}
			,{name: 'EprDocStatus', mapping: 'EprDocStatus'}
			,{name: 'EprDocStatusDesc', mapping: 'EprDocStatusDesc'}
			,{name: 'EprNurStatus', mapping: 'EprNurStatus'}
			,{name: 'EprNurStatusDesc', mapping: 'EprNurStatusDesc'}
			,{name: 'BackDays', mapping: 'BackDays'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
			,{name: 'IsDeathPat', mapping: 'IsDeathPat'}
			,{name: 'DeathDate', mapping: 'DeathDate'}
		])
	});
	obj.DischAdmGrid = new Ext.grid.GridPanel({
		id : 'DischAdmGrid'
		,store : obj.DischAdmGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msgDischAdmGrid',text:'出院查询列表',style:'font-weight:bold;font-size:14px;',xtype:'label'},
		'->','-',obj.btnNoBack,'-',obj.btnBatBack,'-',obj.btnBack,'-',obj.btnDischQry,'-',obj.btn2DaysLate,'-',obj.btn3DaysLate,'-',obj.btn7DaysLate,'-',obj.btnPrint,'-',obj.btnExport,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '当前<br>步骤', width: 50, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '医生提交', width: 60, dataIndex: 'EprDocStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '护士提交', width: 60, dataIndex: 'EprNurStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', width: 80, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '迟归<br>天数', width: 60, dataIndex: 'BackDays', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否死亡', width: 80, dataIndex: 'IsDeathPat', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '死亡日期', width: 80, dataIndex: 'DeathDate', sortable: true, menuDisabled:true, align: 'center'}
			//,{header: '科主任', width: 70, dataIndex: 'ChiefProfessor', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '主任医师', width: 70, dataIndex: 'Professor', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '主治医师', width: 70, dataIndex: 'VistingDoctor', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '住院医师', width: 70, dataIndex: 'ResidentDoctor', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 1, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.DischAdmGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			//forceFit : true
			scrollOffset:30 //为右侧下拉滚动条设置预留列宽
			,getRowClass : function(record,rowIndex,rowParams,store){
				if(record.get('IsDeathPat')){
					if(record.get('IsDeathPat')=="是"){
						return 'x-grid-record-red'
					}
				}
			}
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.cboLocGroup]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboLoc]
					}
				]
			}
			,obj.DischAdmGrid
		]
	});
	
	obj.cboLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocGroup';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = ''; //obj.cboLocGroup.getRawValue(); update by cpj 2015-04-10 修改:"回收组"查询只显示"1组"和"全院"两个下拉选项
		param.ArgCnt = 2;
	});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocList';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = Common_GetValue('cboLocGroup');
		param.Arg3 = obj.cboLoc.getRawValue();
		param.ArgCnt = 3;
	});
	
	obj.DischAdmGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.VolDischQry';
			param.QueryName = 'QryVolumeList';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = Common_GetValue("cboMrType");
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.Arg5 = Common_GetValue("cboLocGroup");
			param.Arg6 = Common_GetValue("cboLoc");
			param.Arg7 = obj.BackDays;
			param.ArgCnt = 7;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}