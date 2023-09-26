var objScreen = new Object();
function InitviewScreen(){
	var obj = new Object();
	objScreen = obj;
	
	obj.RepTypeCode = "";
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"SMD");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","报告科室","","","","cboSSHosp");
	obj.cboRepType = Common_ComboToDic("cboRepType","类型","SMDRepType","^全部类型","",CTHospID);
	obj.dtDateFrom = Common_DateFieldToDate("dtDateFrom","查询日期");
	obj.dtDateTo = Common_DateFieldToDate("dtDateTo","至");
	obj.cbgRepStatus = Common_CheckboxGroupToDic("cbgRepStatus","报告状态","SMDRepStatus",6);
	obj.cbgAdmType = Common_CheckboxGroupToDic("cbgAdmType","报卡类型","SMDAdmType",2);
	obj.txtPatName = Common_TextField("txtPatName","患者姓名");
	
	obj.chkSelectAll = Common_Checkbox("chkSelectAll","全选");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '导出Excel'
	});
	obj.btnExportXml = new Ext.Button({
		id : 'btnExportXml'
		,iconCls : 'icon-export'
		,text : '导出XML'
	});
	obj.btnBatchCheck = new Ext.Button({
		id : 'btnBatchCheck'
		,iconCls : 'icon-update'
		,text : '批量审核'
	});
	
	obj.btnSelAll = new Ext.Button({
		id : 'btnSelAll'
		,iconCls : 'icon-update'
		,text : '全选'
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ReportID', mapping: 'ReportID'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'RepTypeID', mapping: 'RepTypeID'}
			,{name: 'RepTypeDesc', mapping: 'RepTypeDesc'}
			,{name: 'StatusID', mapping: 'StatusID'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'CardNo', mapping: 'CardNo'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Birthday', mapping: 'Birthday'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'PatTypeID', mapping: 'PatTypeID'}
			,{name: 'PatTypeDesc', mapping: 'PatTypeDesc'}
			,{name: 'DiseaseID', mapping: 'DiseaseID'}
			,{name: 'DiseaseICD', mapping: 'DiseaseICD'}
			,{name: 'DiseaseDesc', mapping: 'DiseaseDesc'}
			,{name: 'DisCatID', mapping: 'DisCatID'}
			,{name: 'DisCatDesc', mapping: 'DisCatDesc'}
			,{name: 'Contactor', mapping: 'Contactor'}
			,{name: 'ContactorTel', mapping: 'ContactorTel'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepUserID', mapping: 'RepUserID'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime', mapping: 'RepTime'}			
			,{name: 'CheckUserID', mapping: 'CheckUserID'}
			,{name: 'CheckUserDesc', mapping: 'CheckUserDesc'}
			,{name: 'CheckDate', mapping: 'CheckDate'}
			,{name: 'CheckTime', mapping: 'CheckTime'}
		])
	});
	
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : true
		,tbar : [{id:'msgSearch',text:'精神疾病报卡查询',style:'font-weight:bold;font-size:16px;',xtype:'label'},
		'->','-',obj.btnQuery,'-',obj.btnExport,'-',obj.chkSelectAll,"全选",'-',obj.btnBatchCheck,'-',obj.btnExportXml,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 35, dataIndex: 'checked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var checked = rd.get("checked");
					if (checked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '报告类别', width: 140, dataIndex: 'RepTypeDesc', sortable: true, align:'left'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: true, align:'center'}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: true, align:'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true, align:'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true, align:'center'}
			,{header: '身份证号', width: 120, dataIndex: 'PersonalID', sortable: true, align:'center'}
			,{header: '诊断', width: 150, dataIndex: 'DiseaseDesc', sortable: true, align:'center'}
			,{header: '卡片编号', width: 80, dataIndex: 'CardNo', sortable: true, align:'center'
				,renderer : function(v, m, rd, r, c, s){
					return " <a href='#' onclick='objScreen.DisplayReportWindow(\""+r+"\",\"\");'>"+ v +"</a>";
				}
			}
			,{header: '报告<br>状态', width: 80, dataIndex: 'StatusDesc', sortable: true, align:'center'
				,renderer: function(v, m, rd, r, c, s){
					if (v == "草稿"){
						return "<span style='color:magenta'>"+ v +"</span>";
					} else if (v == "提交"){
						return "<span style='color:red'>"+ v +"</span>";
					} else if (v == "删除"){
						return "<span style='color:green'>"+ v +"</span>";
					} else if (v == "审核"){
						return "<span style='color:blue'>"+ v +"</span>";
					} else if (v == "取消审核"){
						return "<span style='color:pink'>"+ v +"</span>";
					} else {
						return  v;
					}
				}
			}
			,{header: '报告科室', width: 150, dataIndex: 'RepLocDesc', sortable: true, menuDisabled:true, align:'left'}
			,{header: '报告人', width: 60, dataIndex: 'RepUserDesc', sortable: true, menuDisabled:true, align:'center'}
			,{header: '报告日期', width: 80, dataIndex: 'RepDate', sortable: true, menuDisabled:true, align:'center'}
			,{header: '报告时间', width: 70, dataIndex: 'RepTime', sortable: true, menuDisabled:true, align:'center'}
			,{header: '审核人', width: 60, dataIndex: 'CheckUserDesc', sortable: true, menuDisabled:true, align:'center'}
			,{header: '审核日期', width: 80, dataIndex: 'CheckDate', sortable: true, menuDisabled:true, align:'center'}
			,{header: '审核时间', width: 80, dataIndex: 'CheckTime', sortable: true, menuDisabled:true, align:'center'}
			,{header: '联系人<br>姓名', width: 80, dataIndex: 'Contactor', sortable: true, align:'left'}
			,{header: '联系人<br>电话', width: 100, dataIndex: 'ContactorTel', sortable: true, align:'left'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridResultStore,
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
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						height: 60,
						layout : 'form',
						//frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboSSHosp]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.dtDateFrom]
									},{
										width:140
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 30
										,items: [obj.dtDateTo]
									},{
										width:240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboRepLoc]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtPatName]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboRepType]
									},{
										width:560
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cbgRepStatus]
									},{
										width:240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cbgAdmType]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridResult
						]
					}
				]
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, params){
		params.ClassName = 'DHCMed.SMDService.ReportSrv';
		params.QueryName = 'QryReportByDate';
		params.Arg1 = Common_GetValue("cboRepType");
		params.Arg2 = Common_GetValue("dtDateFrom");
		params.Arg3 = Common_GetValue("dtDateTo");
		params.Arg4 = Common_GetValue("cboSSHosp");
		params.Arg5 = Common_GetValue("cboRepLoc");
		params.Arg6 = Common_GetValue("cbgRepStatus");
		params.Arg7 = Common_GetValue("cbgAdmType");
		params.Arg8 = Common_GetValue("txtPatName");
		params.ArgCnt = 8;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
  return obj;
}

