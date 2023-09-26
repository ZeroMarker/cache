function InitviewScreen() {

	var obj = new Object();

	// ******************************Start****************************
	// 查询条件开始日期、结束日期、医院、执行科室查询条件
	obj.dtFromDate = new Ext.form.DateField({
				id : 'dtFromDate',
				//format : 'Y-m-d',
				format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),
				width : 100,
				fieldLabel : '开始日期',
				anchor : '99%',
				altFormats : 'Y-m-d|d/m/Y'
				// ,plugins: 'monthPickerPlugin'
				,value : new Date()
			});
			
	obj.pConditionChild1 = new Ext.Panel({
				id : 'pConditionChild1',
				buttonAlign : 'center',
				columnWidth : .20,
				layout : 'form',
				items : [obj.dtFromDate]
			});
			
	obj.dtToDate = new Ext.form.DateField({
				id : 'dtToDate',
				//format : 'Y-m-d',
				format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),
				width : 100,
				fieldLabel : '结束日期',
				anchor : '99%',
				altFormats : 'Y-m-d|d/m/Y'
				// ,plugins: 'monthPickerPlugin'
				,value : new Date()
			});
			
	obj.pConditionChild2 = new Ext.Panel({
				id : 'pConditionChild2',
				buttonAlign : 'center',
				columnWidth : .20,
				layout : 'form',
				items : [obj.dtToDate]
			});
			
	obj.cboHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboHospitalStore = new Ext.data.Store({
				proxy : obj.cboHospitalStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'rowid'
						}, [
								/*{ name : 'checked',mapping : 'checked'}
								,{ name : 'rowid',mapping : 'rowid'}
								,{ name : 'hosName',mapping : 'hosName'}
								*/
								{name: 'CTHospID', mapping: 'CTHospID'}
								,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
							])
			});
	obj.cboHospital = new Ext.form.ComboBox({
				id : 'cboHospital',
				width : 100,
				store : obj.cboHospitalStore,
				minChars : 1,
				displayField : 'CTHospDesc',
				fieldLabel : '医院',
				editable : true,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'CTHospID'
			});
	obj.cboHospitalStoreProxy.on('beforeload', function(objProxy, param) {
				/* param.ClassName = 'DHCMed.Base.Hospital';
				param.QueryName = 'QueryHosInfo';
				param.ArgCnt = 0; */
				param.ClassName = 'DHCMed.SSService.HospitalSrv';
				param.QueryName = 'QrySSHospByCode';
				param.Arg1      = SSHospCode;
				param.Arg2      = "EPD";
				param.ArgCnt    = 2;
			});
			
	obj.pConditionChild3 = new Ext.Panel({
				id : 'pConditionChild3',
				buttonAlign : 'center',
				columnWidth : .20,
				layout : 'form',
				items : [obj.cboHospital]
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
						}, [
							/*	{ name : 'checked',mapping : 'checked'}
								,{name : 'CTLocID',mapping : 'CTLocID'}
								,{ name : 'CTLocDesc',mapping : 'CTLocDesc'} */
								{name: 'LocRowId', mapping: 'LocRowId'}
								,{name: 'LocDesc', mapping: 'LocDesc'}
								,{name: 'LocDesc1', mapping: 'LocDesc1'}
							])
			});
	obj.cboLoc = new Ext.form.ComboBox({
				id : 'cboLoc',
				width : 100,
				store : obj.cboLocStore,
				minChars : 1,
				displayField : 'LocDesc',
				fieldLabel : '科室',
				editable : true,
				triggerAction : 'all',
				anchor : '99%',
				valueField : 'LocRowId'
			});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param) {
				/*
				param.ClassName = 'DHCMed.Base.Ctloc';
				param.QueryName = 'QryCTLoc';
				param.Arg1 = obj.cboLoc.getRawValue();
				param.Arg2 = '';      //fix bug 112202 门诊传染病统计-科室下拉框不显示急诊科室
				param.Arg3 = "" + "-" + obj.cboHospital.getValue(); // 关联科室和医院放一个字段中
				param.ArgCnt = 3;
				*/
				param.ClassName = 'DHCMed.SSService.HospitalSrv';
				param.QueryName = 'QueryLoction';
				param.Arg1 = obj.cboLoc.getRawValue();
				param.Arg2 = '';
				param.Arg3 = '';
				param.Arg4 = 'E|EM';
				param.Arg5 = '';
				param.Arg6 = '';
				param.Arg7 = obj.cboHospital.getValue();
				param.ArgCnt = 7;
			});
			
	obj.pConditionChild4 = new Ext.Panel({
				id : 'pConditionChild4',
				buttonAlign : 'center',
				columnWidth : .20,
				layout : 'form',
				items : [obj.cboLoc]
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
			
	obj.pConditionChild5 = new Ext.Panel({
				id : 'pConditionChild5',
				buttonAlign : 'center',
				columnWidth : .20,
				layout : 'form',
				items : [obj.cboRepPlace]
			});
			
	obj.btnQuery = new Ext.Button({
				id : 'btnQuery',
				iconCls : 'icon-find',
				text : '查询'
			});
	obj.btnExport = new Ext.Button({
				id : 'btnExport',
				iconCls : 'icon-export',
				text : '导出'
			});
	obj.ConditionPanel = new Ext.form.FormPanel({
				id : 'ConditionPanel',
				buttonAlign : 'center',
				labelAlign : 'right',
				labelWidth : 60,
				bodyBorder : 'padding:0 0 0 0',
				layout : 'column',
				region : 'north',
				frame : true,
				height : 80,
				items : [obj.pConditionChild1, obj.pConditionChild2, obj.pConditionChild3, obj.pConditionChild4, obj.pConditionChild5],
				buttons : [obj.btnQuery, obj.btnExport]
			});
	// ****************************** End ****************************

	// ******************************Start****************************
	// 查询列表显示
	try {
		var objClass = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicOPSta");
		if (objClass) {
			var JsonExp = objClass.BuildJsonToOPStatHeader();
			eval(JsonExp);  //fix IE11 点开页面报错“ 无法获取未定义或 null 引用的属性“rows””，页面不能正常使用
			//window.eval(JsonExp); // 返回数组:gridHeader、gridColumn、storeFields
			
		}
	} catch (e) {
		var gridHeader = "", gridColumn = "", storeFields = "";
		ExtTool.alert("错误", "获取动态Json数据错误!");
	}
	if ((gridHeader == "") || (gridColumn == "") || (storeFields == "")) {
		return;
	}
	obj.gridHeader = gridHeader;
	obj.gridColumn = gridColumn;
	obj.storeFields = storeFields;

	obj.GridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : './dhcmed.store.csp',
				timeout : 300000,
				method : 'POST'
			}));
	obj.GridStore = new Ext.data.Store({
				proxy : obj.GridStoreProxy,
				reader : new Ext.data.JsonReader({
					root : 'record',
					totalProperty : 'total'
						// ,idProperty: 'RstNo'
					}, obj.storeFields)
			});
	obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
				rows : [obj.gridHeader]
			});
	obj.RstGridPanel = new Ext.grid.GridPanel({
				id : 'RstGridPanel',
				loadMask : true,
				store : new Ext.data.ArrayStore({}),
				animCollapse : false,
				region : 'center',
				plugins : obj.GridColumnHeaderGroup,
				columns : obj.gridColumn,
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
	// ****************************** End ****************************

	obj.winCtrInPatient = new Ext.Viewport({
				id : 'winCtrInPatient',
				layout : 'border',
				items : [obj.RstGridPanel, obj.ConditionPanel]
			});
	obj.GridStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPDService.EpidemicOPSta';
				param.MethodName = 'BuildJsonToOPStatStore';
				param.Arg1 = obj.dtFromDate.getRawValue();
				param.Arg2 = obj.dtToDate.getRawValue();
				param.Arg3 = obj.cboHospital.getValue();
				param.Arg4 = obj.cboLoc.getValue();
				param.Arg5 = obj.cboRepPlace.getValue();
				param.ArgCnt = 5;
			});

	InitviewScreenEvent(obj);
	
	// 事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
