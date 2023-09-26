var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlag = 0;
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
		,fieldLabel : '质控组'
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
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	obj.btnNoReview = new Ext.Button({
		id : 'btnNoReview'
		,iconCls : 'icon-cancel'
		,width : 70
		,anchor : '100%'
		,text : '未复核'
	});
	
	obj.btnReview = new Ext.Button({
		id : 'btnReview'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '已复核'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.MrReviewGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.MrReviewGridStore = new Ext.data.Store({
		proxy: obj.MrReviewGridStoreProxy,
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
			,{name: 'ChiefProfessor', mapping: 'ChiefProfessor'}
			,{name: 'Professor', mapping: 'Professor'}
			,{name: 'VistingDoctor', mapping: 'VistingDoctor'}
			,{name: 'ResidentDoctor', mapping: 'ResidentDoctor'}
			,{name: 'EprDocStatus', mapping: 'EprDocStatus'}
			,{name: 'EprDocStatusDesc', mapping: 'EprDocStatusDesc'}
			,{name: 'EprNurStatus', mapping: 'EprNurStatus'}
			,{name: 'EprNurStatusDesc', mapping: 'EprNurStatusDesc'}
			,{name: 'EprPdfStatus', mapping: 'EprPdfStatus'}
			,{name: 'EprPdfStatusDesc', mapping: 'EprPdfStatusDesc'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
			,{name: 'FinishFlag', mapping: 'FinishFlag'}
		])
	});
	obj.MrReviewGrid = new Ext.grid.GridPanel({
		id : 'MrReviewGrid'
		,store : obj.MrReviewGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msgMrReviewGrid',text:'病历复核列表',style:'font-weight:bold;font-size:14px;',xtype:'label'},
		'->','-',obj.btnNoReview,'-',obj.btnReview,'-',obj.btnExport,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '当前<br>步骤', width: 50, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID = rd.get("VolID");
					return "<a href='#' onclick='objScreen.LnkVolStatusWin(\"" + VolumeID + "\");'>" + v + "</a>";
				}
			}
			,{header: '医生提交', width: 60, dataIndex: 'EprDocStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '护士提交', width: 60, dataIndex: 'EprNurStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '生成PDF', width: 60, dataIndex: 'EprPdfStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '三单一致', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var FinishFlag  = rd.get("FinishFlag");
					var VolumeID = rd.get("VolID");
					var EpisodeID = rd.get("EpisodeID");
					var ReviewFlag = 'N'; //是否可以进行病历复核
					if (rd.get("EprDocStatusDesc")=='是') { //临床医生已做病历归档，可以进行病历复核
						ReviewFlag = 'Y'; 
					}
					if (FinishFlag == '1') {
						return "<a href='#' onclick='objScreen.LnkReviewWin(\"" + VolumeID + "\",\"" + EpisodeID + "\",\"" + ReviewFlag + "\");'>查看</a>";
					} else { 
						return "<a href='#' onclick='objScreen.LnkReviewWin(\"" + VolumeID + "\",\"" + EpisodeID + "\",\"" + ReviewFlag + "\");'>复核</a>";
					}
				}
			}
			,{header: '科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', width: 80, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科主任', width: 70, dataIndex: 'ChiefProfessor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主任医师', width: 70, dataIndex: 'Professor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主治医师', width: 70, dataIndex: 'VistingDoctor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '住院医师', width: 70, dataIndex: 'ResidentDoctor', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.MrReviewGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			//forceFit : true
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
			,obj.MrReviewGrid
		]
	});
	
	obj.cboLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocGroup';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = obj.cboLocGroup.getRawValue();
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
	
	obj.MrReviewGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.ReviewQry';
			param.QueryName = 'QryVolumeList';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = Common_GetValue("cboMrType");
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.Arg5 = Common_GetValue("cboLocGroup");
			param.Arg6 = Common_GetValue("cboLoc");
			param.Arg7 = obj.QryFlag;
			param.ArgCnt = 7;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}