// /名称: 订单查询
// /描述: 订单查询
// /编写者：zhangdongmei
// /编写日期: 2012.10.08
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//获取参数，并初始化数据 STATR
	Ext.getUrlParam = function(param) {
		var params = Ext.urlDecode(location.search.substring(1));
		return param ? params[param] : params;
	};
	UsrFlag = Ext.getUrlParam('UsrFlag');
	
	//订购科室
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '订购科室...',
		stkGrpId : 'StkGrpType',
		childCombo : 'apcVendorField'
	});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});
	
	var StkGrpType = new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		anchor : '90%',
		StkType : App_StkTypeCode,
		LocId : gLocId,
		UserId : gUserId,
		childCombo : 'DHCStkCatGroup'
	});
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId : 'StkGrpType'}
	});
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : '未入库',
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : '部分入库',
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : '全部入库',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	if (UsrFlag==1){
		var apcVendorField = new Ext.ux.UsrVendorComboBox({
		fieldLabel : '供应商',
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		userId :gUserId,
		emptyText : '供应商...'
		});
	}else{
		// 供应商
		var apcVendorField=new Ext.ux.VendorComboBox({
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor:'90%',
			params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
		});
	}
	// 是否发送平台
	var SendSCIflagdata = [['全部','0'],['已发送','1'],['未发送','2']];
	var SendSCIflagStore = new Ext.data.SimpleStore({
		fields : ['SendSCIDesc','SendSCIId'],
		data :  SendSCIflagdata
	});
		
	var SendSCIFlag = new Ext.form.ComboBox({
	    fieldLabel : '是否发送平台',
	    mode: 'local',
	    id : 'SendSCIFlag',
	    name : 'SendSCIFlag',
	    anchor : '90%',
	    emptyText : '',
	    store : SendSCIflagStore,
	    displayField : 'SendSCIDesc',
	    valueField : 'SendSCIId',
	    triggerAction :'all'/**/
	});
	Ext.getCmp("SendSCIFlag").setValue("0");	
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询订单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
	});
	
	var SaveDetaliBT = new Ext.Toolbar.Button({
				id : "SaveDetaliBT",
				text : '另存订单明细信息',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					if(MasterGrid.getSelectionModel().getSelected ()==undefined||MasterGrid.getSelectionModel().getSelected ()==""){
				      Msg.info("warning","请选择订单!")
					  return;
					}
					var name =MasterGrid.getSelectionModel().getSelected ().get('PoNo')
					ExportAllToExcel(DetailGrid,name);
				}
	});
	var SaveMainBT = new Ext.Toolbar.Button({
				id : "SaveMainBT",
				text : '另存订单信息',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					ExportAllToExcel(MasterGrid,new Date().format(ARG_DATEFORMAT));
				}
	});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
			
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		Ext.getCmp("AllImp").setValue(true);     //清空这三项应该恢复默认
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("DHCStkCatGroup").setValue("");
		if(INPoInfoPanel.rendered){
			document.getElementById("frameINPoInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		if(LocInfoPanel.rendered){
			document.getElementById("frameLocInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

    var SendInPoBT = new Ext.Toolbar.Button({
				id : "SendInPoBT",
				text : '发送订单到云平台',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					    var rowDataArr=MasterGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "请选择需要发送的订单!");
							return false;
						}
						var PoIdStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoId = rowData.get("PoId");
							if (PoIdStr==""){
								PoIdStr=PoId;
							}else{
								PoIdStr=PoIdStr+"^"+PoId;
							}
						}
						if (PoIdStr=="") {
							Msg.info("warning", "请选择需要发送的订单!");
							return false;
						}
						sendinpo(PoIdStr);
					
				}
	});
	function sendinpo(PoIdStr){
		 var url = DictUrl
                    + "inpoaction.csp?actiontype=sendinpo";
            var loadMask=ShowLoadMask(Ext.getBody(),"发送订单中...");
            Ext.Ajax.request({
                        url : url,
                        method : 'POST',
                        params:{InPo:PoIdStr},
                        waitMsg : '处理中...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            var infoArr=jsonData.info.split("^");
                            var allcount=infoArr[0];
                            var failcount=infoArr[1];
                            var succount=allcount-failcount;
                            Msg.info("success","共"+allcount+ "条记录，发送成功："+succount);
                            Query();
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}
	/// 撤销发送平台的订单明细
	var CancelInPoiBT = new Ext.Toolbar.Button({
				id : "CancelInPoiBT",
				text : '撤销发送',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					    var rowDataArr=DetailGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "请选择需要撤销的订单明细!");
							return false;
						}
						var PoIdiStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoItmId = rowData.get("PoItmId");
							if (PoIdiStr==""){
								PoIdiStr=PoItmId;
							}else{
								PoIdiStr=PoIdiStr+"^"+PoItmId;
							}
						}
						if (PoIdiStr=="") {
							Msg.info("warning", "请选择需要撤销的订单明细!");
							return false;
						}
						cancelinpoi(2,PoIdiStr);
					
				}
	});
	function cancelinpoi(Type,PoIdiStr){
		 var cancelurl = DictUrl
                    + "inpoaction.csp?actiontype=cancelinpoi";
            var loadMask=ShowLoadMask(Ext.getBody(),"撤销中...");
            Ext.Ajax.request({
                        url : cancelurl,
                        method : 'POST',
                        params:{Type:Type,InPo:PoIdiStr},
                        waitMsg : '处理中...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            if (jsonData.success == 'true') {
	                            Msg.info("success","撤销成功！");
	                            Query();
                            }else{
	                            var retinfo=jsonData.info;
	                            Msg.info("success","撤销失败:"+retinfo);
	                            Query();
	                        }
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}
	/// 催单
	var UrgeInPoiBT = new Ext.Toolbar.Button({
				id : "UrgeInPoiBT",
				text : '催单',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					    var rowDataArr=DetailGrid.getSelectionModel().getSelections();
					    var rowcount=rowDataArr.length;
						if (Ext.isEmpty(rowDataArr)) {
							Msg.info("warning", "请选择需要催促送货的订单明细!");
							return false;
						}
						var PoItmStr="";
						for (var i=0;i<rowcount;i++){
							var rowData=rowDataArr[i];
							var PoItmId = rowData.get("PoItmId");
							if (PoItmStr==""){
								PoItmStr=PoItmId;
							}else{
								PoItmStr=PoItmStr+"^"+PoItmId;
							}
						}
						if (PoItmStr=="") {
							Msg.info("warning", "请选择需要催促送货的订单明细!");
							return false;
						}
						urgeinpoi(1,PoItmStr);
					
				}
	});
	function urgeinpoi(type,PoItmStr){
	 	var urgeurl = DictUrl
                    + "inpoaction.csp?actiontype=urgeinpoi";
            var loadMask=ShowLoadMask(Ext.getBody(),"发送中...");
            Ext.Ajax.request({
                        url : urgeurl,
                        method : 'GET',
                        params:{Type:type,InPo:PoItmStr},
                        waitMsg : '处理中...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            if (jsonData.success == 'true') {
	                            Msg.info("success","消息发送成功！");
	                            //Query();
                            }else{
	                            var retinfo=jsonData.info;
	                            Msg.info("success","消息发送失败:"+retinfo);
	                            Query();
	                        }
                            
                        },
                        scope : this
                    });
            loadMask.hide();
	}

	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '起始日期不可为空');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		var Scg = Ext.getCmp('StkGrpType').getValue();
		var Incsc = Ext.getCmp('DHCStkCatGroup').getValue();
		var SendSCIFlag = Ext.getCmp('SendSCIFlag').getValue();
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^Y^'+Status+'^^'
			+'^^'+userId+'^^N^'+Scg+'^'+Incsc+'^'+SendSCIFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='未入库';
		}else if(value==1){
			PoStatus='部分入库';
		}else if(value==2){
			PoStatus='全部入库';
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","Email","ReqLocDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		listeners : {
			load : function(store,records,options){
				if(records.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var sm =new Ext.grid.CheckboxSelectionModel({});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "RowId",
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "订单号",
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "订购科室",
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "申请科室",
				dataIndex : 'ReqLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "订单状态",
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : "订单日期",
				dataIndex : 'PoDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "供应商邮箱",
				dataIndex : 'Email',
				width : 120,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
				region:'west',
				collapsible: true,
				split: true,
				width: 400,
				minSize: 175,
				maxSize: 450,
				id : 'MasterGrid',
				title : '订单',
				cm : MasterCm,
				sm : sm,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		DetailPanel.fireEvent('tabchange',DetailPanel,DetailPanel.getActiveTab());
//		var PoId = r.get("PoId");
//		var Size=DetailPagingToolbar.pageSize;
//		DetailStore.setBaseParam('Parref',PoId);
//		DetailStore.removeAll();
//		DetailStore.load({params:{start:0,limit:Size}});
	});
	
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// 指定列参数
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty",
		"Spec", "ImpQtyAudited", "SpecDesc","Cancleflag","DemandDate","PlatSentFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	// 数据集
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true
	});
		
	var nm = new Ext.grid.RowNumberer();
	var dsm =new Ext.grid.CheckboxSelectionModel({});
	var DetailCm = new Ext.grid.ColumnModel([nm,dsm, {
			header : "订单明细id",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "物资RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "单位",
			dataIndex : 'PurUom',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "订购数量",
			dataIndex : 'PurQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "入库制单数量",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "未到货数量",
			dataIndex : 'NotImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "入库审核数量",
			dataIndex : 'ImpQtyAudited',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "具体规格",
			dataIndex : 'SpecDesc',
			width : 80,
			align : 'left'
		}, {
			header : "是否撤销验收",
			dataIndex : 'Cancleflag',
			width : 80,
			align : 'left'
		}, {
			header : "要求送达日期",
			dataIndex : 'DemandDate',
			width : 80,
			align : 'left'
		}, {
			header : "是否发送平台",
			dataIndex : 'PlatSentFlag',
			width : 80,
			align : 'left'
		}]);

	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		title : '',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : dsm,///new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:new Ext.Toolbar({items:[CancelInPoiBT,UrgeInPoiBT]}),
		bbar:[DetailPagingToolbar]
	});
				
	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		title : '订单到货情况查询',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-',  ClearBT,'-',SaveMainBT,'-',SaveDetaliBT,'-',SendInPoBT],
		bodyStyle : 'padding:10px 0px 0px 0px;',
		layout: 'fit',
		items : [{
			xtype : 'fieldset',
			title : '查询信息',
			layout : 'column',
			autoHeight:true,
			defaults : {border : false},
			items : [{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [PhaLoc,apcVendorField,StkGrpType]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate,EndDate,DHCStkCatGroup]
			},{
				columnWidth: 0.2,
				xtype: 'fieldset',
				items: [AllImp,NotImp,PartlyImp]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [SendSCIFlag]
			}]
		}]
	});
	
	var DetailGridPanel = new Ext.Panel({
		title : '订单明细',
		id : 'DetailGridPanel',
		layout:'fit',
		items : DetailGrid
	});
	
	var INPoInfoPanel = new Ext.Panel({
		title : '物资明细',
		id : 'INPoInfoPanel',
		layout:'fit',
		html:'<iframe id="frameINPoInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	var LocInfoPanel = new Ext.Panel({
		title : '科室请领明细',
		id : 'LocInfoPanel',
		layout:'fit',
		html:'<iframe id="frameLocInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	var DetailPanel = new Ext.TabPanel({
		region: 'center',
		activeTab : 0,
		deferredRender : true,
		items : [DetailGridPanel,INPoInfoPanel,LocInfoPanel],
		listeners : {
			tabchange : function(tabpanel,panel){
				var PoRec = MasterGrid.getSelectionModel().getSelected();
				if(Ext.isEmpty(PoRec)){
					return;
				}
				var PoId = PoRec.get('PoId');
				if(panel.id == 'DetailGridPanel'){
					var Size=DetailPagingToolbar.pageSize;
					DetailStore.setBaseParam('Parref',PoId);
					DetailStore.removeAll();
					DetailStore.load({params:{start:0,limit:Size}});
				}else if(panel.id == 'INPoInfoPanel'){
					var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPO_ReqInfo.raq'
						+"&Parref=" + PoId;
					var reportFrame=document.getElementById("frameINPoInfo");
					reportFrame.src=p_URL;
				}else if(panel.id == 'LocInfoPanel'){
					var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPO_ReqLocInfo.raq'
						+"&Parref=" + PoId;
					var reportFrame=document.getElementById("frameLocInfo");
					reportFrame.src=p_URL;
				}
			}
		}
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab, MasterGrid,DetailPanel]
	});
	
	SearchBT.handler();
});