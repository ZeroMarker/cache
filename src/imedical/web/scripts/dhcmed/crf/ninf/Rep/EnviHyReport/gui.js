var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	
	obj.CurrDate = new Date();
	obj.LastDate = new Date();
	obj.LastDate.setMonth(obj.LastDate.getMonth()-1);
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	} else {
		obj.AdminPower  = AdminPower;
	}
	
    obj.txtDate = Common_DateFieldToDate("txtDate","<b style='color:red'>*</b>检测日期");
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");
	obj.cboLoc = Common_ComboToLoc("cboLoc","<b style='color:red'>*</b>采样科室","","","","cboSSHosp");
	obj.cboItem = new Ext.form.ComboBox({
		id : 'cboItem'
		,fieldLabel : "<b style='color:red'>*</b>检测项目"
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.EnviHyLocItems';
						param.QueryName = 'QryEHItemsByLoc';
						param.Arg1      = Common_GetValue('cboLoc');
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'EnviHyItemID'
			}, 
			[
				{name: 'EnviHyItemID', mapping: 'EnviHyItemID'}
				,{name: 'EnviHyItem', mapping: 'EnviHyItem'}
			])
		})
		,minChars : 0
		,displayField : 'EnviHyItem'
		,valueField : 'EnviHyItemID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	obj.cboNorm = new Ext.form.ComboBox({
		id : 'cboNorm'
		,fieldLabel : "<b style='color:red'>*</b>检测范围"
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.EnviHyLocItems';
						param.QueryName = 'QryEHNormsByLocItem';
						param.Arg1      = Common_GetValue('cboLoc');
						param.Arg2      = Common_GetValue('cboItem');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'NormID'
			}, 
			[
				{name: 'NormID', mapping: 'NormID'}
				,{name: 'EHNCateg', mapping: 'EHNCateg'}
				,{name: 'SpecimenTypeID', mapping: 'SpecimenTypeID'}
				,{name: 'SpecimenType', mapping: 'SpecimenType'}
				,{name: 'EHNRange', mapping: 'EHNRange'}
				,{name: 'EHNNorm', mapping: 'EHNNorm'}
				,{name: 'ItemObj', mapping: 'ItemObj'}
				,{name: 'EHNNormMin', mapping: 'EHNNormMin'}
				,{name: 'EHNNormMax', mapping: 'EHNNormMax'}
				,{name: 'SpecimenNum', mapping: 'SpecimenNum'}
				,{name: 'CenterNum', mapping: 'CenterNum'}
				,{name: 'SurroundNum', mapping: 'SurroundNum'}
			])
		})
		,minChars : 0
		,displayField : 'EHNRange'
		,valueField : 'NormID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	obj.txtItemObj = Common_TextField("txtItemObj","<b style='color:red'>*</b>项目对象");
	obj.cboSpecType = Common_ComboToDic("cboSpecType","<b style='color:red'>*</b>标本类型","NINFEnviHySpecimenType");
	obj.txtSpecNum = Common_NumberField("txtSpecNum","<b style='color:red'>*</b>标本数量");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.lblCurrMonth = new Ext.form.Label({
		text : obj.CurrDate.dateFormat('Y年m月'),
		width : 60
	});
	
	obj.lblLastMonth = new Ext.form.Label({
		text : obj.LastDate.dateFormat('Y年m月'),
		width : 60
	});
	
	obj.btnQuery = new Ext.Toolbar.Button({
		id : 'btnQuery'
		,iconCls : 'icon-Find'
		,width: 70
		,text : '查询'
	});
	obj.btnSave = new Ext.Toolbar.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width: 70
		,text : '保存'
	});
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 70
		,text : '删除'
	});
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-Update'
		,width: 70
		,text : '修改'
	});
	obj.btnExit = new Ext.Toolbar.Button({
		id : 'btnExit'
		,iconCls : 'icon-exit'
		,width: 70
		,text : '退出'
	});
	obj.btnPrintBar = new Ext.Toolbar.Button({
		id : 'btnPrintBar'
		,iconCls : 'icon-Print'
		,width: 70
		,text : '打印条码'
	});
	
	obj.btnPrintRep = new Ext.Button({
		id : 'btnPrintRep'
		,iconCls : 'icon-Print'
		,width: 70
		,text : '打印报告'
	});
	
	obj.btnPrintLastBar = new Ext.Toolbar.Button({
		id : 'btnPrintLastBar'
		,iconCls : 'icon-Print'
		,width: 70
		,text : '打印条码'
	});
	
	obj.btnPrintLastRep = new Ext.Button({
		id : 'btnPrintLastRep'
		,iconCls : 'icon-Print'
		,width: 70
		,text : '打印报告'
	});
	
	obj.btnCopy = new Ext.Toolbar.Button({
		id : 'btnCopy'
		,iconCls : 'icon-Edit'
		,width: 70
		,text : '复制到本月'
	});
	obj.lastMonth = new Ext.Toolbar.Button({
		id : 'lastMonth'
		,iconCls : 'icon-update'
		,width: 70
		,text : '上一月'
	});
	obj.nextMonth = new Ext.Toolbar.Button({
		id : 'nextMonth'
		,iconCls : 'icon-update'
		,width: 70
		,text : '下一月'
	});
	
    //未保存记录 
	obj.gridCurrEnviHyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCurrEnviHyReportStore = new Ext.data.Store({
		proxy: obj.gridCurrEnviHyReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'},
			{name: 'ItemID', mapping : 'ItemID'},
			{name: 'LocID', mapping : 'AskForLocID'},
			{name: 'LocDesc', mapping : 'AskForLocDesc'},
			{name: 'ItemDesc', mapping : 'ItemDesc'},
			{name: 'ItemCategDesc', mapping : 'EHICategDesc'},
			{name: 'NormID', mapping : 'NormID'},
			{name: 'NormMax', mapping : 'NormMax'},
			{name: 'NormMin', mapping : 'NormMin'},
			{name: 'NormRange', mapping : 'NormRange'},
			{name: 'ItemObj', mapping : 'ItemObj'},
			{name: 'EHRRepLocDesc', mapping : 'EHRRepLocDesc'},
			{name: 'EHRRepUserDesc', mapping : 'EHRRepUserDesc'},
			{name: 'EHRDate', mapping : 'EHRDate'},
			{name: 'SpecimenTypeID', mapping : 'SpecimenTypeID'},
			{name: 'SpecimenTypeDesc', mapping : 'SpecimenTypeDesc'},
			{name: 'EHRResult', mapping : 'EHRResult'},
			{name: 'EHRAutoIsNorm', mapping : 'EHRAutoIsNorm'},
			{name: 'SpecimenNum', mapping : 'SpecimenNum'},
			{name: 'CenterNum', mapping : 'CenterNum'},
			{name: 'SurroundNum', mapping : 'SurroundNum'},
			{name: 'RepStatusDesc', mapping : 'RepStatusDesc'},
			{name: 'RepResume', mapping : 'RepResume'},
			{name: 'EHRBarCode', mapping : 'EHRBarCode'}
		])
	});
	obj.gridCurrSM = new Ext.grid.CheckboxSelectionModel({width:25});
	obj.gridCurrEnviHyReport = new Ext.grid.GridPanel({
		id : 'gridCurrEnviHyReport'
		,store : obj.gridCurrEnviHyReportStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,sm :obj.gridCurrSM
		,columns: [
			new Ext.grid.RowNumberer(),
			obj.gridCurrSM,
			{header: '申请单', width: 60, dataIndex: 'EHRBarCode', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测项目', width: 180, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '申请科室', width: 120, dataIndex: 'EHRRepLocDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '状态', width: 70, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '检测范围', width: 120, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '项目对象', width: 60, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测日期', width: 70, dataIndex: 'EHRDate', sortable: false, menuDisabled:true, align: 'center'},
			{header: '标本类型', width: 60, dataIndex: 'SpecimenTypeDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '标本<br>数量', width: 50, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center'},
			{header: '申请人', width: 70, dataIndex: 'EHRRepUserDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测<br>结果', width : 50,dataIndex: 'EHRResult',sortable: false,menuDisabled:true,align: 'center',
				renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value == ""){
						return "";
					}else{
						return "<a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'><font size='2'>结果</font></a>";
					}
				}
			},
			{header: '是否<br>合格', width: 50, dataIndex: 'EHRAutoIsNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value=="合格")
					{
						return "<b style='color:green;'>"+value+"</b>";
					}else{
					    return "<b style='color:red;'>"+value+"</b>";
					}
				}
			}
		]
		,viewConfig : {
			//forceFit : true
		}
    });
   //上月数据
	obj.gridLastEnviHyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLastEnviHyReportStore = new Ext.data.Store({
		proxy: obj.gridLastEnviHyReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'},
			{name: 'ItemID', mapping : 'ItemID'},
			{name: 'LocID', mapping : 'AskForLocID'},
			{name: 'LocDesc', mapping : 'AskForLocDesc'},
			{name: 'ItemDesc', mapping : 'ItemDesc'},
			{name: 'ItemCategDesc', mapping : 'EHICategDesc'},
			{name: 'NormID', mapping : 'NormID'},
			{name: 'NormMax', mapping : 'NormMax'},
			{name: 'NormMin', mapping : 'NormMin'},
			{name: 'NormRange', mapping : 'NormRange'},
			{name: 'ItemObj', mapping : 'ItemObj'},
			{name: 'EHRRepLocDesc', mapping : 'EHRRepLocDesc'},
			{name: 'EHRRepUserDesc', mapping : 'EHRRepUserDesc'},
			{name: 'EHRDate', mapping : 'EHRDate'},
			{name: 'SpecimenTypeID', mapping : 'SpecimenTypeID'},
			{name: 'SpecimenTypeDesc', mapping : 'SpecimenTypeDesc'},
			{name: 'EHRResult', mapping : 'EHRResult'},
			{name: 'EHRAutoIsNorm', mapping : 'EHRAutoIsNorm'},
			{name: 'SpecimenNum', mapping : 'SpecimenNum'},
			{name: 'CenterNum', mapping : 'CenterNum'},
			{name: 'SurroundNum', mapping : 'SurroundNum'},
			{name: 'RepStatusDesc', mapping : 'RepStatusDesc'},
			{name: 'RepResume', mapping : 'RepResume'},
			{name: 'EHRBarCode', mapping : 'EHRBarCode'}
		])
	});
	obj.gridLastSM = new Ext.grid.CheckboxSelectionModel({width:25});
	obj.gridLastEnviHyReport = new Ext.grid.GridPanel({
		id : 'gridLastEnviHyReport'
		,store : obj.gridLastEnviHyReportStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,sm :obj.gridLastSM
		,columns: [
			new Ext.grid.RowNumberer(),
			obj.gridLastSM,
			{header: '申请单', width: 60, dataIndex: 'EHRBarCode', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测项目', width: 180, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '申请科室', width: 120, dataIndex: 'EHRRepLocDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '状态', width: 70, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '检测范围', width: 120, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},
			{header: '项目对象', width: 60, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测日期', width: 70, dataIndex: 'EHRDate', sortable: false, menuDisabled:true, align: 'center'},
			{header: '标本类型', width: 60, dataIndex: 'SpecimenTypeDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '标本<br>数量', width: 50, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center'},
			{header: '申请人', width: 70, dataIndex: 'EHRRepUserDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '检测<br>结果', width : 50,dataIndex: 'EHRResult',sortable: false,menuDisabled:true,align: 'center',
				renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value == ""){
						return "";
					}else{
						return "<a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'><font size='2'>结果</font></a>";
					}
				}
			},
			{header: '是否<br>合格', width: 50, dataIndex: 'EHRAutoIsNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value=="合格")
					{
						return "<b style='color:green;'>"+value+"</b>";
					}else{
					    return "<b style='color:red;'>"+value+"</b>";
					}
				}
			}
		]
		,viewConfig : {
			//forceFit : true
		}
    });
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1',
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 65,
				layout : 'fit',
				//tbar : ['<b>录入申请单</b>'],
				items : [
					{
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 270
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboSSHosp]
									},{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtDate]
									},{
										width : 280
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboLoc]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 270
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboItem]
									},{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboNorm]
									},{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtItemObj]
									},{
										width : 140
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboSpecType]	
									},{
										width : 100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtSpecNum]
									}
								]
							}
						]
					}
				]
			},{
				region: 'center',
				layout : 'fit',
				tbar : ['<b>本月申请单</b>','-',obj.lblCurrMonth,'-',obj.btnSave,'-',obj.btnDelete,'-',obj.btnPrintBar,'-',obj.btnPrintRep,'-'],
				items : [
					obj.gridCurrEnviHyReport
				]
			},{
				region: 'south',
				layout : 'fit',
				split:true,
				collapsible: true,
				collapsed : true,
				lines:false,
				animCollapse:false,
				animate: false,
				collapseMode:'mini',
				collapseFirst:false,
				hideCollapseTool:true,
				border:true,
				boxMinHeight : 300,
				boxMaxHeight : 450,
				height:300,
				tbar : ['<b>历史申请单</b>','-',obj.lblLastMonth,'-',obj.lastMonth,'-',obj.nextMonth,'-',obj.btnPrintLastBar,'-',obj.btnPrintLastRep,'-',obj.btnCopy,'-'],
				items : [
					obj.gridLastEnviHyReport
				]
			}
		]
	});
	obj.gridCurrEnviHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.EnviHyReport';
		param.QueryName = 'QryEnviHyRep';
		param.Arg1 = obj.CurrDate.dateFormat('Y-m');
		var LocID = Common_GetValue('cboLoc');
		param.Arg2 = (LocID == '' ? '0' : LocID);
		param.ArgCnt = 2;
	});
	obj.gridLastEnviHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.EnviHyReport';
		param.QueryName = 'QryEnviHyRep';
		param.Arg1 = obj.LastDate.dateFormat('Y-m');
		var LocID = Common_GetValue('cboLoc');
		param.Arg2 = (LocID == '' ? '0' : LocID);
		param.ArgCnt = 2;
	});
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}