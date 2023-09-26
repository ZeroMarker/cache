function InitviewScreen() {
	var obj = new Object();
	obj.ReportUrl = "";
	obj.ReportFileName = "";
	
	// ******************************Start****************************
	// 查询条件开始日期、结束日期、医院、执行科室查询条件
	obj.dtFromDate = new Ext.form.DateField({
				id : 'dtFromDate',
				format : 'Y-m-d',
				width : 100,
				fieldLabel : '开始日期',
				anchor : '99%',
				altFormats : 'Y-m-d|d/m/Y'
				// ,plugins: 'monthPickerPlugin'
				,
				value : new Date()
			});
	obj.dtToDate = new Ext.form.DateField({
				id : 'dtToDate',
				format : 'Y-m-d',
				width : 100,
				fieldLabel : '结束日期',
				anchor : '99%',
				altFormats : 'Y-m-d|d/m/Y'
				// ,plugins: 'monthPickerPlugin'
				,
				value : new Date()
			});

	obj.cboMIFKindStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));

	obj.cboMIFKindStore = new Ext.data.Store({
				proxy : obj.cboMIFKindStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'myid'
						}, [{
									name : 'v_code',
									mapping : 'Code'
								}, {
									name : 'v_description',
									mapping : 'Description'
								}])
			});

	obj.cboMIFKind = new Ext.form.ComboBox({
				id : 'cboMIFKind',
				fieldLabel : '疾病类别',
				width : 100,
				anchor : '99%',
				store : obj.cboMIFKindStore,
				emptyText : '请选择',
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'v_code',
				displayField : 'v_description'
			});

	obj.cboHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboHospitalStore = new Ext.data.Store({
				proxy : obj.cboHospitalStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'rowid'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'rowid',
									mapping : 'rowid'
								}, {
									name : 'hosName',
									mapping : 'hosName'
								}])
			});
	obj.cboHospital = new Ext.form.ComboBox({
				id : 'cboHospital',
				width : 100,
				store : obj.cboHospitalStore,
				minChars : 1,
				displayField : 'hosName',
				fieldLabel : '医院',
				editable : true,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'rowid'
			});
	obj.cboHospitalStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.Base.Hospital';
				param.QueryName = 'QueryHosInfo';
				param.ArgCnt = 0;
			});
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboLocStore = new Ext.data.Store({
				proxy : obj.cboLocStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'CTLocID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'CTLocID',
									mapping : 'CTLocID'
								}, {
									name : 'CTLocDesc',
									mapping : 'CTLocDesc'
								}])
			});
	obj.cboLoc = new Ext.form.ComboBox({
				id : 'cboLoc',
				width : 100,
				store : obj.cboLocStore,
				minChars : 1,
				emptyText : '请选择',
				displayField : 'CTLocDesc',
				fieldLabel : '报告科室',
				editable : true,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'CTLocID'
			});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.Base.Ctloc';
				param.QueryName = 'QryCTLoc';
				param.Arg1 = obj.cboLoc.getRawValue();
				param.Arg2 = '';
				param.Arg3 = "" + "-" + obj.cboHospital.getValue(); // 关联科室和医院放一个字段中
				param.ArgCnt = 3;
			});
	obj.cboRepPlaceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboRepPlaceStore = new Ext.data.Store({
				proxy : obj.cboRepPlaceStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboRepPlace = new Ext.form.ComboBox({
				id : 'cboRepPlace',
				width : 100,
				store : obj.cboRepPlaceStore,
				minChars : 1,
				displayField : 'Description',
				fieldLabel : '上报位置',
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				editable : false,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'Code'
			});
	obj.cboRepPlaceStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'RepPlace';
				param.ArgCnt = 1;
			});
	obj.cboRepPlaceStore.load({
		callback : function() {
					obj.cboRepPlace.setValue("ALL");
				}
	});
	
	obj.cboCDCStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboCDCStatusStore = new Ext.data.Store({
				proxy : obj.cboCDCStatusStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboCDCStatus = new Ext.form.ComboBox({
				id : 'cboCDCStatus',
				width : 100,
				store : obj.cboCDCStatusStore,
				minChars : 1,
				displayField : 'Description',
				fieldLabel : '是否上报CDC',
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				editable : false,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'Code'
			});
	obj.cboCDCStatusStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpdRepUploadStatus';
				param.ArgCnt = 1;
			});
	obj.cboCDCStatusStore.load({
		callback : function() {
					obj.cboCDCStatus.setValue("ALL");
				}
	});

	obj.cboMIFKindStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpdemicType';
				param.ArgCnt = 1;
			});
	obj.cboMIFKindStore.load({});

	var arrItem = new Array();
	var objCommonSrv = ExtTool.StaticServerObject("DHCMed.EPDService.CommonSrv");
	var strDicList = objCommonSrv.GetDicList("EpidemicReportStatus", 1);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			boxLabel : dicSubList[1],
			name : dicSubList[0],
			checked : (dicSubList[0] == 1)
		}
		arrItem.push(chkItem);
	}

	obj.cbgRepStatus = new Ext.form.CheckboxGroup({
				id : 'cbgRepStatus',
				xtype : 'checkboxgroup',
				fieldLabel : '报告状态',
				columns : 4,
				items : arrItem
			});
	obj.btnQuery = new Ext.Button({
				id : 'btnQuery',
				iconCls : 'icon-find',
				text : '查询'
			});
	obj.btnExport = new Ext.Button({
				id : 'btnExport',
				iconCls : 'icon-export',
				text : '选择导出'
			});
	obj.btnExportAll = new Ext.Button({
				id : 'btnExportAll',
				iconCls : 'icon-export',
				text : '全部导出'
			});
	obj.pConditionChild1 = new Ext.Panel({
				id : 'pConditionChild1',
				buttonAlign : 'center',
				columnWidth : .30,
				layout : 'form',
				items : [obj.dtFromDate, obj.dtToDate,obj.cboCDCStatus]
			});
	obj.pConditionChild2 = new Ext.Panel({
				id : 'pConditionChild2',
				buttonAlign : 'center',
				columnWidth : .30,
				layout : 'form',
				items : [obj.cboHospital, obj.cboLoc,obj.cboRepPlace]
			});
	obj.pConditionChild3 = new Ext.Panel({
				id : 'pConditionChild3',
				buttonAlign : 'center',
				columnWidth : .40,
				layout : 'form',
				items : [obj.cboMIFKind,obj.cbgRepStatus]
			});
	obj.ConditionPanel = new Ext.form.FormPanel({
				id : 'ConditionPanel',
				buttonAlign : 'center',
				labelAlign : 'right',
				labelWidth : 100,
				bodyBorder : 'padding:0 0 0 0',
				layout : 'column',
				region : 'north',
				frame : true,
				height : 130,
				items : [
					obj.pConditionChild1
					,obj.pConditionChild2
					,obj.pConditionChild3
				]
				,buttons : [
					obj.btnQuery
					,obj.btnExport
					,obj.btnExportAll
				]
			});
	// ****************************** End ****************************
	obj.DataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL,
				timeout : 300000,
				method : 'POST'
			}));
	obj.DataGridPanelStore = new Ext.data.Store({
				proxy : obj.DataGridPanelStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'RowID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'RowID',
									mapping : 'RowID'
								}, {
									name : 'PatientID',
									mapping : 'PatientID'
								}, {
									name : 'RegNo',
									mapping : 'RegNo'
								}, {
									name : 'PatientName',
									mapping : 'PatientName'
								}, {
									name : 'Sex',
									mapping : 'Sex'
								}, {
									name : 'Age',
									mapping : 'Age'
								}, {
									name : 'DiseaseICD',
									mapping : 'DiseaseICD'
								}, {
									name : 'DiseaseName',
									mapping : 'DiseaseName'
								}, {
									name : 'ReportDep',
									mapping : 'ReportDep'
								}, {
									name : 'RepPlace',
									mapping : 'RepPlace'
								}, {
									name : 'RepUserCode',
									mapping : 'RepUserCode'
								}, {
									name : 'RepUserName',
									mapping : 'RepUserName'
								}, {
									name : 'RepDate',
									mapping : 'RepDate'
								}, {
									name : 'RepTime',
									mapping : 'RepTime'
								}, {
									name : 'Paadm',
									mapping : 'Paadm'
								}, {
									name : 'IsUpload',
									mapping : 'IsUpload'
								}, {
									name : 'Status',
									mapping : 'Status'
								}, {
									name : 'StatusCode',
									mapping : 'StatusCode'
								}, {
									name : 'CheckUserCode',
									mapping : 'CheckUserCode'
								}, {
									name : 'CheckUserName',
									mapping : 'CheckUserName'
								}, {
									name : 'CheckDate',
									mapping : 'CheckDate'
								}, {
									name : 'CheckTime',
									mapping : 'CheckTime'
								}, {
									name : 'RepKind',
									mapping : 'RepKind'
								}, {
									name : 'RepRank',
									mapping : 'RepRank'
								}, {
									name : 'FamName',
									mapping : 'FamName'
								}, {
									name : 'Occupation',
									mapping : 'Occupation'
								}, {
									name : 'Company',
									mapping : 'Company'
								}, {
									name : 'Address',
									mapping : 'Address'
								}, {
									name : 'IDAddress',
									mapping : 'IDAddress'
								}, {
									name : 'TelPhone',
									mapping : 'TelPhone'
								}, {
									name : 'SickDate',
									mapping : 'SickDate'
								}, {
									name : 'DiagDate',
									mapping : 'DiagDate'
								}, {
									name : 'DeathDate',
									mapping : 'DeathDate'
								}, {
									name : 'RepNo',
									mapping : 'RepNo'
								}, {
									name : 'PersonalID',
									mapping : 'PersonalID'
								}, {
									name : 'DelReason',
									mapping : 'DelReason'
								}, {
									name : 'DemoInfo',
									mapping : 'DemoInfo'
								}])
			});

	// Add By PanLei 2012-11-09
	// 增加传染病报告查询序号列描述和显示宽度
	obj.DataRowNumberer = new Ext.grid.RowNumberer({
				header : '序号',
				width : 40
	});

	obj.DataCheckColumn = new Ext.grid.CheckColumn({
				header : '选择',
				dataIndex : 'checked',
				width : 40
			});
	obj.DataGridPanel = new Ext.grid.GridPanel({
				id : 'DataGridPanel',
				loadMask : true,
				buttonAlign : 'center',
				region : 'center',
				store : obj.DataGridPanelStore,
				columns : [obj.DataRowNumberer, obj.DataCheckColumn, {
							header : '是否上报CDC',
							width : 80,
							dataIndex : 'IsUpload',
							sortable : false,
							align : 'center'
						}, {
							header : '报告状态',
							width : 80,
							dataIndex : 'Status',
							align : 'center',
							renderer : function(value, metaData, record, rowIndex, colIndex, store) {
								var strRet = "";
								switch (record.get("StatusCode")) {
									case "1" :
										strRet = "<div style='color:red'>" + value + "</div>";
										break;
									case "2" :
										strRet = "<div style='color:green'>" + value + "</div>";
										break;
									case "3" :
										strRet = "<div style='color:orange'>" + value + "</div>";
										break;
									case "4" :
										strRet = "<div style='color:olive'>" + value + "</div>";
										break;
									case "5" :
										strRet = "<div style='color:black'>" + value + "</div>";
										break;
									case "6" :
										strRet = "<div style='color:blue'>" + value + "</div>";
										break;
									case "7" :
										strRet = "<div style='color:gray'>" + value + "</div>";
										break;
									default :
										strRet = "<div style='color:black'>" + value + "</div>";
										break;
								}
								return strRet;
							}
						}, {
							header : '登记号',
							width : 80,
							dataIndex : 'RegNo',
							sortable : false,
							align : 'center'
						}, {
							header : '患者姓名',
							width : 80,
							dataIndex : 'PatientName',
							sortable : false,
							align : 'center'
						}, {
							header : '性别',
							width : 40,
							dataIndex : 'Sex',
							sortable : false,
							align : 'center'
						}, {
							header : '年龄',
							width : 40,
							dataIndex : 'Age',
							sortable : false,
							align : 'center'
						}, {
							header : '现住址',
							width : 250,
							dataIndex : 'Address',
							sortable : false
						}, {
							header : '疾病名称',
							width : 120,
							dataIndex : 'DiseaseName',
							sortable : false
						}, {
							header : '病例分类',
							width : 100,
							dataIndex : 'RepKind',
							sortable : false
						}, {
							header : '联系电话',
							width : 100,
							dataIndex : 'TelPhone',
							sortable : false
						}, {
							header : '报告人',
							width : 80,
							dataIndex : 'RepUserName',
							sortable : false,
							align : 'center'
						}, {
							header : '报告科室',
							width : 120,
							dataIndex : 'ReportDep',
							sortable : true,
							align : 'center'
						}, {
							header : '上报位置',
							width : 80,
							dataIndex : 'RepPlace',
							sortable : false,
							align : 'center'
						}, {
							header : '卡片编号',
							width : 120,
							dataIndex : 'RepNo',
							sortable : true,
							align : 'center'
						}, {
							header : '家长姓名',
							width : 80,
							dataIndex : 'FamName',
							sortable : false,
							align : 'center'
						}, {
							header : '身份证号',
							width : 100,
							dataIndex : 'PersonalID',
							sortable : false,
							align : 'center'
						}, {
							header : '职业',
							width : 80,
							dataIndex : 'Occupation',
							sortable : false,
							align : 'center'
						}, {
							header : '工作单位',
							width : 150,
							dataIndex : 'Company',
							sortable : false,
							align : 'center'
						}, {
							header : '户籍地址',
							width : 200,
							dataIndex : 'IDAddress',
							sortable : false
						}, {
							header : '疾病等级',
							width : 100,
							dataIndex : 'RepRank',
							sortable : false,
							align : 'center'
						}, {
							header : '发病日期',
							width : 80,
							dataIndex : 'SickDate',
							sortable : false,
							align : 'center'
						}, {
							header : '诊断日期',
							width : 80,
							dataIndex : 'DiagDate',
							sortable : false,
							align : 'center'
						}, {
							header : '死亡日期',
							width : 80,
							dataIndex : 'DeathDate',
							sortable : false,
							align : 'center'
						}, {
							header : '报告人工号',
							width : 80,
							dataIndex : 'RepUserCode',
							sortable : false,
							align : 'center'
						}, {
							header : '报告日期',
							width : 80,
							dataIndex : 'RepDate',
							sortable : true,
							align : 'center'
						}, {
							header : '报告时间',
							width : 80,
							dataIndex : 'RepTime',
							sortable : false,
							align : 'center'
						}, {
							header : '审核人',
							width : 80,
							dataIndex : 'CheckUserName',
							sortable : false,
							align : 'center'
						}, {
							header : '审核人工号',
							width : 80,
							dataIndex : 'CheckUserCode',
							sortable : false,
							align : 'center'
						}, {
							header : '审核日期',
							width : 80,
							dataIndex : 'CheckDate',
							sortable : false,
							align : 'center'
						}, {
							header : '审核时间',
							width : 80,
							dataIndex : 'CheckTime',
							sortable : false,
							align : 'center'
						}, {
							header : '退回/删除原因',
							width : 80,
							dataIndex : 'DelReason',
							sortable : false
						}, {
							header : '备注',
							width : 80,
							dataIndex : 'DemoInfo',
							sortable : false
						}]
				// ,bbar: new Ext.PagingToolbar({
				// pageSize : 20,
				// store : obj.DataGridPanelStore,
				// displayMsg: '显示记录： {0} - {1} 合计： {2}',
				// displayInfo: true,
				// emptyMsg: '没有记录'
				// })
				,
				plugins : obj.DataCheckColumn,
				iconCls : 'icon-grid',
				viewConfig : {
					// forceFit : true
					enableRpwBody : true,
					showPreview : true,
					layout : function() {
						if (!this.mainBody) {
							return;
						}
						var g = this.grid;
						var c = g.getGridEl();
						var csize = c.getSize(true);
						var vw = csize.width;
						if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
							return;
						}
						if (g.autoHeight) {
							if (this.innerHd) {
								this.innerHd.style.width = (vw) + 'px';
							}
						} else {
							this.el.setSize(csize.width, csize.height);
							var hdHeight = this.mainHd.getHeight();
							var vh = csize.height - (hdHeight);
							this.scroller.setSize(vw, vh);
							if (this.innerHd) {
								this.innerHd.style.width = (vw) + 'px';
							}
						}
						if (this.forceFit) {
							if (this.lastViewWidth != vw) {
								this.fitColumns(false, false);
								this.lastViewWidth = vw;
							}
						} else {
							this.autoExpand();
							this.syncHeaderScroll();
						}
						this.onLayout(vw, vh);
					}
				}
			});
	obj.DataGridPanelStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPDService.EpidemicSrv';
				param.QueryName = 'QueryEpdRepByDate';
				param.Arg1 = obj.dtFromDate.getRawValue(); // 开始日期
				param.Arg2 = obj.dtToDate.getRawValue(); // 结束日期
				param.Arg3 = obj.cboLoc.getValue(); // 报告科室
				param.Arg4 = obj.GetStatusList(); // 报告状态
				param.Arg5 = obj.cboRepPlace.getValue(); // 上报位置
				param.Arg6 = obj.cboHospital.getValue(); // 医院
				param.Arg7 = obj.cboCDCStatus.getValue(); // 是否上报CDC
				param.Arg8 = obj.cboMIFKind.getValue(); // 疾病类别
				param.ArgCnt = 8;
			});

	obj.viewScreen = new Ext.Viewport({
				id : 'viewScreen',
				layout : 'border',
				items : [obj.ConditionPanel, obj.DataGridPanel]
			});
			
	InitviewScreenEvent(obj);
	
	// 事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}