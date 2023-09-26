var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlg = "";
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","开始日期");
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
		,fieldLabel : '编码员'
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
	
	obj.btnCodQry = new Ext.Button({
		id : 'btnCodQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '编目查询'
	});
	
	obj.btnNotCodQry = new Ext.Button({
		id : 'btnNotCodQry'
		,iconCls : 'icon-cancel'
		,width : 70
		,anchor : '100%'
		,text : '未编查询'
	});
	
	obj.btnRepQry = new Ext.Button({
		id : 'btnRepQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '报告查询'
	});
	
	obj.gridPathologRepProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridPathologRep = new Ext.data.Store({
		proxy: obj.gridPathologRepProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PathRepID'
		},[
			{name: 'PathRepID', mapping : 'PathRepID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'AdmitDept', mapping : 'AdmitDept'}
			,{name: 'AdmitDate', mapping : 'AdmitDate'}
			,{name: 'AdmitDeptDesc', mapping : 'AdmitDeptDesc'}
			,{name: 'EstimDischDate', mapping : 'EstimDischDate'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'Number', mapping : 'Number'}
			,{name: 'RepDate', mapping : 'RepDate'}
			,{name: 'RepTime', mapping : 'RepTime'}
			,{name: 'RepUser', mapping : 'RepUser'}
			,{name: 'RepUserDesc', mapping : 'RepUserDesc'}
			,{name: 'Diagnos', mapping : 'Diagnos'}
			,{name: 'IsCoding', mapping : 'IsCoding'}
			,{name: 'CodDate', mapping : 'CodDate'}
			,{name: 'CodTime', mapping : 'CodTime'}
			,{name: 'CodUser', mapping : 'CodUser'}
			,{name: 'CodUserDesc', mapping : 'CodUserDesc'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'FrontPageID', mapping : 'FrontPageID'}
		])
	});
	obj.gridPathologRep = new Ext.grid.GridPanel({
		id : 'gridPathologRep'
		,store : obj.gridPathologRep
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [
			{id:'msggridPathologRep',text:'病理查询列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'',width:50,xtype:'label'},'-',obj.btnNotCodQry,'-',obj.btnCodQry,'-',obj.btnRepQry,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '编目状态', width: 50, dataIndex: 'IsCoding', sortable: true, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IsCoding = rd.get("IsCoding");
					var FrontPageID = rd.get("FrontPageID");
					var VolID = rd.get("VolID");
					
					var PathRepID = rd.get("PathRepID");
					if (IsCoding==1){
						var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"" + FrontPageID + "\",\"" + VolID + "\",\"" + PathRepID + "\")'><font size='2'>" + '已编目' + "</font></a>";
					}else{
						if (FrontPageID != ''){
							var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"" + FrontPageID + "\",\"\",\"" + PathRepID + "\")'><font size='2'>" + '未编目' + "</font></a>";
						}else{
							var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"\",\"" + VolID + "\",\"" + PathRepID + "\")'><font size='2'>" + '未编目' + "</font></a>";
						}
					}
					return ret;
				}
			}
			,{header: '报告日期', width: 60, dataIndex: 'RepDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告人', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病理诊断', width: 100, dataIndex: 'Diagnos', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '编目日期', width: 60, dataIndex: 'CodDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '编目人', width: 60, dataIndex: 'CodUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊科室', width: 120, dataIndex: 'AdmitDeptDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmitDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 60, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridPathologRep,
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
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:130
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
			,obj.gridPathologRep
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
	
	obj.gridPathologRepProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.PathologRepSrv';
		param.QueryName = 'QryPathologRep';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("cboLocGroup");
		param.Arg6 = Common_GetValue("cboLoc");
		param.Arg7 = obj.QryFlg;
		param.ArgCnt =7;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}