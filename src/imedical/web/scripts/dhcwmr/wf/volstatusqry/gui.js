var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlag = 0;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","查询日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	obj.cboWFItem = Common_ComboToWFItem("cboWFItem","操作项目","cboMrType");
	obj.cboWFItem.setWidth(120);
	
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
		,fieldLabel : '科室组'
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
	//操作员
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboOperaUserStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboOperaUserStore = new Ext.data.Store({
		proxy: obj.cboOperaUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'UserRowid'
		},[
			{name: 'UserRowid', mapping : 'UserRowid'}
			,{name: 'UserCode', mapping: 'UserCode'}
			,{name: 'UserName', mapping: 'UserName'}
		])
	});
	obj.cboOperaUser = new Ext.form.ComboBox({
		id : 'cboOperaUser'
		,fieldLabel : '操作员'
		,labelSeparator :''
		,store : obj.cboOperaUserStore
		,minChars : 1
		,valueField : 'UserRowid'
		,displayField : 'UserName'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	obj.btnControlStatus = new Ext.Button({
		id : 'btnControlStatus'
		,iconCls : 'icon-cancel'
		,width : 80
		,anchor : '100%'
		,text : '问题病历'
	});
	
	obj.btnUnProcess = new Ext.Button({
		id : 'btnUnProcess'
		,iconCls : 'icon-cancel'
		,width : 80
		,anchor : '100%'
		,text : '未处理'
	});
	
	obj.btnCurrentStatus = new Ext.Button({
		id : 'btnCurrentStatus'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '当前状态'
	});
	
	obj.btnHistoryStatus = new Ext.Button({
		id : 'btnHistoryStatus'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '历史操作'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="8%">批次号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作项目</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">操作人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">接收人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">撤销标记</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">撤销日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">撤销人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">撤销原因</td>',
				'</tr>',
				'<tbody>',
					'<tpl for="Record">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{BatchNumber}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ItemDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActDate} {ActTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UserDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ToUserDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoOperaDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoDate} {UpdoTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoUserDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{UpdoReason}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divStatusList-{VolID}"></div>'
        )
    });
	
	obj.VolStatusListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.VolStatusListStore = new Ext.data.Store({
		proxy: obj.VolStatusListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IndexNo'
		},[
			{name: 'IndexNo', mapping : 'IndexNo'}
			,{name: 'VolID', mapping : 'VolID'}
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
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.VolStatusList = new Ext.grid.GridPanel({
		id : 'VolStatusList'
		,store : obj.VolStatusListStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgVolStatusList',text:'状态查询',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-','操作项目：',obj.cboWFItem,{text:'',width:50,xtype:'label'},'-',obj.btnUnProcess,'-',obj.btnCurrentStatus,'-',obj.btnHistoryStatus,'-',obj.btnExport,'-'
		]
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
			,{header: MrClass=='O'?'初诊科室':'科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', id : 'AdmWardDesc', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: MrClass=='O'?'初诊日期':'就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', id : 'DischDate', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', id : 'BackDate', width: 80, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科主任', id : 'ChiefProfessor', width: 70, dataIndex: 'ChiefProfessor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主任医师', id : 'Professor', width: 70, dataIndex: 'Professor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主治医师', id : 'VistingDoctor', width: 70, dataIndex: 'VistingDoctor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'初诊医师':'住院医师', width: 70, dataIndex: 'ResidentDoctor', sortable: false, menuDisabled:true, align: 'center'}
		]
		,plugins: obj.RowExpander
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.VolStatusListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : MrClass=='O'?true:false
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
					},{	
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.cboOperaUser]
					}
				]
			}
			,obj.VolStatusList
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
	
	obj.cboOperaUserStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.SSUserSrv';
		param.QueryName = 'QueryByName';
		param.Arg1 = CTHospID;
		param.Arg2 = obj.cboOperaUser.getRawValue();
		param.Arg3 = CTLocID;
		param.ArgCnt = 3;
	});
	
	obj.VolStatusListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.VolStatusQry';
		param.QueryName = 'QryVolumeList';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("cboWFItem");
		param.Arg4 = Common_GetValue("dfDateFrom");
		param.Arg5 = Common_GetValue("dfDateTo");
		param.Arg6 = Common_GetValue("cboLocGroup");
		param.Arg7 = Common_GetValue("cboLoc");
		param.Arg8 = Common_GetValue("cboOperaUser");
		param.Arg9 = obj.QryFlag;
		param.ArgCnt = 9;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}