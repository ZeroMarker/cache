var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlg = "";
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","查询日期");
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
		,fieldLabel : '科室组'
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
	
	obj.txtMrNo =  new Ext.form.TextField({
		id : 'txtMrNo'
		,selectOnFocus:true
		,fieldLabel : '病案号'
		,emptyText : ''  //'病案号/条码号'
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.btnDisNotFP = new Ext.Button({
		id : 'btnDisNotFP'
		,iconCls : 'icon-cancel'
		,width : 70
		,anchor : '100%'
		,text : '未编目'
	});
	
	obj.btnCurrFPQry = new Ext.Button({
		id : 'btnCurrFPQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '当日查询'
	});
	
	obj.btnDischQry = new Ext.Button({
		id : 'btnDischQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '出院查询'
	});
	
	obj.btnFPQry = new Ext.Button({
		id : 'btnFPQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '编目查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
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
	
	obj.gridFrontPageStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFrontPageStore = new Ext.data.Store({
		proxy: obj.gridFrontPageStoreProxy,
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
			,{name: 'FrontPageID', mapping: 'FrontPageID'}
			,{name: 'FPIsFinish', mapping: 'FPIsFinish'}
			,{name: 'FPBuildDate', mapping: 'FPBuildDate'}
			,{name: 'FPBuildTime', mapping: 'FPBuildTime'}
			,{name: 'FPUpdateDate', mapping: 'FPUpdateDate'}
			,{name: 'FPUpdateTime', mapping: 'FPUpdateTime'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.gridFrontPage = new Ext.grid.GridPanel({
		id : 'gridFrontPage'
		,store : obj.gridFrontPageStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msgGridFrontPage',text:'编目查询列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}]
		,tbar : [
			{id:'msgGridFrontPage',text:'编目查询列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'病案号：',style:'font-weight:bold;font-size:18px;',xtype:'label'},obj.txtMrNo,{text:'',width:50,xtype:'label'}
			,'-',obj.btnCurrFPQry,'-',obj.btnDisNotFP,'-',obj.btnFPQry,'-',obj.btnDischQry,'-',obj.btnExport,'-'
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
			//,{header: '当前步骤', width: 60, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '编目状态', width: 60, dataIndex: 'FPIsFinish', sortable: true, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var FPIsFinish = rd.get("FPIsFinish");
					var FrontPageID = rd.get("FrontPageID");
					var VolID = rd.get("VolID");
					//FixBug:6492 病案管理系统-住院病案-病案编目-[导出Excel],导出的Excel中编目状态显示为数字
					if (FrontPageID != '') {
						var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"" + FrontPageID + "\",\"\")'><font size='2'>" + v + "</font></a>";
						if (v == '草稿') m.attr = 'style="background:#FF5151;"';
					} else {
						var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"\",\"" + VolID + "\")'><font size='2'>" + v + "</font></a>";
					}
					return ret;
				}
			}
			,{header: '编目日期', width: 60, dataIndex: 'FPBuildDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '修改日期', width: 60, dataIndex: 'FPUpdateDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 60, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 0, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,plugins: obj.RowExpander
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridFrontPageStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
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
			,obj.gridFrontPage
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
	
	obj.gridFrontPageStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.FPVolumeQry';
		param.QueryName = 'QryVolumeList';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = FPType;
		param.Arg4 = Common_GetValue("txtMrNo");
		param.Arg5 = Common_GetValue("dfDateFrom");
		param.Arg6 = Common_GetValue("dfDateTo");
		param.Arg7 = Common_GetValue("cboLocGroup");
		param.Arg8 = Common_GetValue("cboLoc");
		param.Arg9 = obj.QryFlg;
		param.ArgCnt = 9;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}