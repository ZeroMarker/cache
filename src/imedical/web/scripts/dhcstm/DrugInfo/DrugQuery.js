// /名称: 物资信息查询
// /描述: 物资信息查询
// /编写者：zhangdongmei
// /编写日期: 2012.06.15

var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gParam="";
var defaRp="";
var SEL_REC;

Ext.onReady(function() {
		Ext.Ajax.timeout = 120000;	//响应时间改为2min
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		gParam=GetParams();
		var defaRp=GetParam(gParam,"ItmQueryDefaRp");
		
		//==========函数==========================
		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
		}
		

		/*
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		
		function editIncAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的物资！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				IncAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editArcAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的物资！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				OrdAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editDoseEquivInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的物资！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				DoseEquivEdit(DrugInfoStore, IncRowid);								
			}
		}
		*/

		//==========函数==========================
		
		//==========控件==========================
		// 物资编码
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '物资编码',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});
		
		// 物资名称
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
	
		// 物资别名
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '物资别名',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});
		// 规格
		var Spec = new Ext.form.TextField({
			fieldLabel : '规格',
			id : 'Spec',
			name : 'Spec',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var Brand = new Ext.form.TextField({
			fieldLabel : '品牌',
			id : 'Brand',
			name : 'Brand',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var Abbrev = new Ext.form.TextField({
			fieldLabel : '简称',
			id : 'Abbrev',
			name : 'Abbrev',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var BRp = new Ext.ux.NumberField({
			formatType : 'FmtRP',
			fieldLabel : '进价',
			id : 'BRp',
			anchor : '90%',
			allowNegative : false
		});
		
		var BSp = new Ext.ux.NumberField({
			formatType : 'FmtSP',
			fieldLabel : '售价',
			id : 'BSp',
			anchor : '90%',
			allowNegative : false
		});
		
		// 物资类组
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor:'90%',
			LocId:gLocId,
			UserId:userId,
			DrugInfo:"Y",
			listWidth : 200,
			listeners:{
				change:function(field,newValue,oldValue){
					M_StkCat.setValue("");
				}
			}
		}); 
			var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor:'90%'
		});
		// 库存分类
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '库存分类',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'StkCatName',
			params:{StkGrpId:'M_StkGrpType'}
		});

		// 全部
		/*
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : '全部',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			anchor : '90%',
			width : 150,
			checked : false
		});
		*/
		var FindTypeData=[['全部','1'],['可用','2'],['不可用','3']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});

		var FindTypeCombo = new Ext.form.ComboBox({
			store: FindTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'FindTypeCombo',
			fieldLabel : '统计方式',
			triggerAction:'all', //取消自动过滤
			valueField : 'typeid'
		});
		Ext.getCmp("FindTypeCombo").setValue("1");
		
		// 高值标志
		var M_HighPrice = new Ext.form.RadioGroup({
			id:'M_HighPrice',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'M_HighPrice',id:'HighPrice_All',inputValue:'',checked:true},
				{boxLabel:'高值',name:'M_HighPrice',id:'HighPrice_Yes',inputValue:'Y'},
				{boxLabel:'非高值',name:'M_HighPrice',id:'HighPrice_No',inputValue:'N'}
			]
		});
		// 收费标志
		var M_ChargeFlag = new Ext.form.RadioGroup({
			id:'M_ChargeFlag',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'M_ChargeFlag',id:'ChargeFlag_All',inputValue:'',checked:true},
				{boxLabel:'收费',name:'M_ChargeFlag',id:'ChargeFlag_Yes',inputValue:'Y'},
				{boxLabel:'不收费',name:'M_ChargeFlag',id:'ChargeFlag_No',inputValue:'N'}
			]
		});
		// 植入标志
		var M_ImplantationMat = new Ext.form.RadioGroup({
			id:'M_ImplantationMat',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'M_ImplantationMat',id:'ImplantationMat_All',inputValue:'',checked:true},
				{boxLabel:'植入',name:'M_ImplantationMat',id:'ImplantationMat_Yes',inputValue:'Y'},
				{boxLabel:'非植入',name:'M_ImplantationMat',id:'ImplantationMat_No',inputValue:'N'}
			]
		});
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '变更起始',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%'
	});
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '变更截止',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%'
		
	});
	var CreateUser = new Ext.ux.ComboBox({
			fieldLabel:'新建人',	
			id:'CreateUser',
			anchor : '90%',
			store:AllUserStore,
			valueField:'RowId',
			displayField:'Description',
			filterName:'Desc',
			params:{}
	});
	
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
	});
	var ImportFlag = new Ext.form.ComboBox({
		fieldLabel : '进口标志',
		id : 'ImportFlag',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor : '90%',
		mode : 'local',
		triggerAction : 'all'
	});
	
		//配置数据源
		var DspPhaUrl = 'dhcstm.druginfomaintainaction.csp';
		var proxy= new Ext.data.HttpProxy({url:DspPhaUrl+'?actiontype=GetItm',method:'POST'});

	
		// 指定列参数
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","brand","PurUom", "Sp", "Rp", "MaxSp", "BUom", "BillUom",
				"StkCat", "NotUseFlag","vendor","vendorName","registerNo","registerNoExpDate","productionlicense","businesscertificate","businesslicense","contactperson","authorizationdate","contacttel",
				"Marginnow","bRp","highpriceflag","chargeflag","implantationmat","model","PhcdCode","Supervision","Origin","regCertDateOfIssue","regItmDesc","regCertNoFull","CreateUser","print","INCIBarCode",
				"ImportFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id:'InciRowid',
			pageSize:30,
			fields : fields
		});
	
		// 数据集
		var DrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: true
		});
	
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				var inciDesc = Ext.getCmp("M_InciDesc").getValue();
				var inciCode = Ext.getCmp("M_InciCode").getValue();
				var alias = Ext.getCmp("M_GeneName").getValue();
				var stkCatId = Ext.getCmp("M_StkCat").getValue();
				var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
				var Vendor= Ext.getCmp("Vendor").getValue();
				var spec=Ext.getCmp("Spec").getValue();
				var brand=Ext.getCmp("Brand").getValue();
				var abbrev=Ext.getCmp("Abbrev").getValue();
				var brp=Ext.getCmp("BRp").getValue();
				var bsp=Ext.getCmp("BSp").getValue();
				var allFlag=Ext.getCmp("FindTypeCombo").getValue();
				var highPrice = Ext.getCmp('M_HighPrice').getValue().getGroupValue();
				var charge = Ext.getCmp('M_ChargeFlag').getValue().getGroupValue();
				var implantation = Ext.getCmp('M_ImplantationMat').getValue().getGroupValue();
				var StartDate=Ext.getCmp("DateFrom").getValue()
				if(!Ext.isEmpty(StartDate)){StartDate=StartDate.format(ARG_DATEFORMAT).toString()}
				var EndDate=Ext.getCmp("DateTo").getValue()
				if(!Ext.isEmpty(EndDate)){EndDate=EndDate.format(ARG_DATEFORMAT).toString()}
				var CreatUserid=Ext.getCmp("CreateUser").getValue();
				var ImportFlag = Ext.getCmp('ImportFlag').getValue();
				//^^^类组id
				var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+defaRp+"^"+spec+"^"+brand+"^"+abbrev+"^"+brp+"^"+bsp
					+"^^^"+StartDate+"^"+EndDate+"^"+CreatUserid+"^"+ImportFlag;
				if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")&&(Vendor=="")) {
					Msg.info("warning", "请选择查询条件!");
					return false;
				}
				DrugInfoStore.setBaseParam('InciDesc',inciDesc);
				DrugInfoStore.setBaseParam('InciCode',inciCode);
				DrugInfoStore.setBaseParam('Alias',alias);
				DrugInfoStore.setBaseParam('StkCatId',stkCatId);
				DrugInfoStore.setBaseParam('AllFlag',allFlag);
				DrugInfoStore.setBaseParam('Others',others);
				DrugInfoStore.setBaseParam('HighPrice',highPrice);
				DrugInfoStore.setBaseParam('Charge',charge);
				DrugInfoStore.setBaseParam('Implantation',implantation);
				DrugInfoStore.setBaseParam('Vendor',Vendor);
				DrugInfoStore.setBaseParam('sort', 'InciCode');
				DrugInfoStore.setBaseParam('dir', 'ASC');
				DrugInfoStore.removeAll();
				DrugInfoStore.load({
					params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
					callback : function(r,options, success) {
						if(success==false){
							Msg.info("error", "查询错误，请查看日志!");
							//DrugInfoGrid.loadMask.hide();
							//return "{results:0,rows:[]}";
						}
					}
				});
			}
		});

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkGrpType.getStore().load();
				M_StkCat.setValue("");	
				M_GeneName.setValue("");
				Ext.getCmp("FindTypeCombo").setValue("1");
				M_HighPrice.setValue('');
				M_ChargeFlag.setValue('');
				M_ImplantationMat.setValue('');
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				Vendor.setValue("");
				StatuTabPagingToolbar.getComponent(4).setValue(1);   //设置当前页码
				StatuTabPagingToolbar.getComponent(5).setText("页,共 1 页");//设置共几页
				StatuTabPagingToolbar.getComponent(12).setText("没有记录"); //设置记录条数
			}
		});
		
		//		
		// 导出按钮
		var ExportAllToExcelBT = new Ext.Toolbar.Button({
			text : '整体另存',
			tooltip : '整体另存',
			width : 70,
			height : 30,
			iconCls : 'page_excel',
			handler : function() {
				ExportAllToExcel(DrugInfoGrid);
			}
		});
		
		var printInciBarCode = new Ext.Toolbar.Button({
			text : '打印条码',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_InciBarcode");
				var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
				if (selectRows.length == 0) {
					Msg.info("warning", "请选择要打印条码的物资！");
					return;
				}
				for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
					var RowData = selectRows[rowIndex];
					var InciBarcode = RowData.get("INCIBarCode");
					if(InciBarcode==""){
						continue;
					}
					var IncDesc= RowData.get("InciDesc");
					var Spec=RowData.get("Spec");
					var Rp=RowData.get("Rp");
					var MyPara = 'InciBarcode' + String.fromCharCode(2) + "*" + InciBarcode + "*"
								+ '^IncDesc' + String.fromCharCode(2) + IncDesc
								+ '^Spec' + String.fromCharCode(2) + Spec
								+ '^Rp' + String.fromCharCode(2) + Rp;
					DHCP_PrintFun(MyPara, "");
				}
			}
		});
		var printInciBarCodeAll = new Ext.Toolbar.Button({
				text : '打印本页条码',
				iconCls : 'page_print',
				width : 70,
				height : 30,
				handler : function(button, e) {
					DHCP_GetXMLConfig("DHCSTM_InciBarcode");
					var count = DrugInfoGrid.getStore().getCount();
					for (var i = 0; i < count; i++) {
						var RowData = DrugInfoGrid.getStore().getAt(i);
						var InciBarcode = RowData.get("INCIBarCode");
						if(InciBarcode==""){
							continue;
						}
						var IncDesc= RowData.get("InciDesc");
						var Spec=RowData.get("Spec");
						var Rp=RowData.get("Rp");
						var MyPara = 'InciBarcode' + String.fromCharCode(2) + "*" + InciBarcode + "*"
									+ '^IncDesc' + String.fromCharCode(2) + IncDesc
									+ '^Spec' + String.fromCharCode(2) + Spec
									+ '^Rp' + String.fromCharCode(2) + Rp;
						DHCP_PrintFun(MyPara, "");
					}
				}
			});
		var BatchSave = new Ext.Toolbar.Button({
			text : '批量修改',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function(button, e) {
				var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
				if (selectRows.length == 0) {
					Msg.info("warning", "请选择需要批量修改的物资");
					return;
				}
				var InciIdStr=""
				for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
					var RowData = selectRows[rowIndex];
					var InciId = RowData.get("InciRowid");
					if(InciIdStr==""){InciIdStr=InciId;}
					else{InciIdStr=InciIdStr+"^"+InciId;}
				}
				BatchSaveWin(InciIdStr,DrugInfoStore)
			}
		});
		var SendInciBT = new Ext.Toolbar.Button({
					id : "SendInciBT",
					text : '发送物资信息到平台',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
						if (selectRows.length == 0) {
							Msg.info("warning", "请选择需要同步的物资");
							return;
						}
						var InciIdStr=""
						for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
							var RowData = selectRows[rowIndex];
							var InciId = RowData.get("InciRowid");
							if(InciIdStr==""){InciIdStr=InciId;}
							else{InciIdStr=InciIdStr+"^"+InciId;}
						}
						var Synresult=tkMakeServerCall("web.DHCSTM.ServiceForSCI","getHopInc",InciIdStr);
						if (Synresult==""){Msg.info("success","同步成功");}
						else{Msg.info("warning","同步存在失败："+Synresult);}
					}
		});
		var nm = new Ext.grid.RowNumberer();
		var	sm=new Ext.grid.CheckboxSelectionModel({
			singleSelect : false,
			checkOnly:true
		});
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, sm,
			{
				header : "库存项id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "物资代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : '物资名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				renderer : InciPicRenderer('InciRowid'),
				sortable : true
			},{
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "型号",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "品牌",
				dataIndex : 'brand',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "监管级别",
				dataIndex : 'Supervision',
				width : 60,
				align : 'center',
				sortable : true
			},{
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : "产地",
				dataIndex : 'Origin',
				width : 80
			},{
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			},{
				header : "进价(入库单位)",
				dataIndex : 'Rp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "售价(入库单位)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "加成",
				dataIndex : 'Marginnow',
				width : 60,
				align : 'right',
				sortable : true
			},{
				header : "最高售价(入库单位)",
				dataIndex : 'MaxSp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "基本单位",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "计价单位",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "库存分类",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			},{
				header : "不可用",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				xtype:'checkcolumn',
				sortable : true
			},{
				header:'供应商rowid',
				dataIndex:'vendor',
				align:'left',
				hidden:true
			},{
				header:'供应商',
				dataIndex:'vendorName',
				align:'left',
				width:150
			},{
				header:'注册证号',
				dataIndex:'registerNo',
				align:'left',
				width:150
			},{
				header:'注册证效期',
				dataIndex:'registerNoExpDate',
				align:'left',
				width:150
			},{
				header:'注册证发证日期',
				dataIndex:'regCertDateOfIssue',
				align:'left',
				width:150
			},
			/*{
				header:'注册证号全称',
				dataIndex:'regCertNoFull',
				align:'left',
				width:150
			},*/
			{
				header:'注册证名称',
				dataIndex:'regItmDesc',
				align:'left',
				width:150
			},{
				header:'生产商-生产许可证号',
				dataIndex:'productionlicense',
				align:'left',
				xtype:'',
				width:150
			},{
				header:'供应商-经营许可证号',
				dataIndex:'businesscertificate',
				align:'left',
				width:150
			},{
				header:'供应商-营业执照号',
				dataIndex:'businesslicense',
				align:'left',
				width:150
			},{
				header:'供应商-联系人',
				dataIndex:'contactperson',
				align:'left',
				width:150
			},{
				header:'供应商-授权到期',
				dataIndex:'authorizationdate',
				align:'left',
				width:150
			},{
				header:'供应商-联系电话',
				dataIndex:'contacttel',
				align:'left',
				width:150
			},{
				header : "进价(基本单位)",
				dataIndex : 'bRp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'高值标志',
				dataIndex:'highpriceflag',
				align:'left',
				xtype:'checkcolumn',
				width:80,
				sortable : true
			},{
				header : "植入标志",
				dataIndex :'implantationmat',
				xtype:'checkcolumn',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "药学项代码",
				dataIndex :'PhcdCode',
				width : 80
				
			},{
				header:'新建人',
				dataIndex:'CreateUser',
				align:'left',
				width:150
			}, {
				header : "物资条码",
				dataIndex : 'INCIBarCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进口标志",
				dataIndex : 'ImportFlag',
				width : 80
			}
		]);
		
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DrugInfoStore,
			pageSize : 30,
			displayInfo : true
		});
		
		var DrugInfoGrid = new Ext.ux.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
//			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : sm,
			loadMask : true,
			bbar:StatuTabPagingToolbar,
			listeners:
			{
				rowcontextmenu : function(grid,rowindex,e){
					
					e.preventDefault();
					grid.getSelectionModel().selectRow(rowindex);
					SEL_REC=grid.getStore().getAt(rowindex);
					
					rightClick.showAt(e.getXY());
				}
			}
		});

		var HisListTab = new Ext.ux.FormPanel({
			labelWidth: 60,
			title:'物资信息查询',
			tbar : [SearchBT, '-', ClearBT,'-',ExportAllToExcelBT,'-',printInciBarCode,'-',printInciBarCodeAll,'-',BatchSave,'-',SendInciBT],
			items:[{
				xtype:'fieldset',
				title:'查询条件',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults : {xtype: 'fieldset', border : false},
				style:'padding:0px 0px 0px 5px',
				items : [{
					columnWidth: 0.2,
					items: [M_InciCode,M_InciDesc,M_GeneName,DateFrom]
				}, {
					columnWidth: 0.2,
					items : [M_StkGrpType,M_StkCat,Vendor,DateTo]
				}, {
					columnWidth: 0.2,
					items : [FindTypeCombo,Spec,Brand,CreateUser]
				}, {
					columnWidth: 0.15,
					labelWidth: 60,
					items : [Abbrev,BRp,BSp,ImportFlag]
				}, {
					columnWidth: 0.25,
					items : [M_HighPrice,M_ChargeFlag,M_ImplantationMat]
				}]
			}]
		});
		
		
		/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		function editPHCDF()
		{		
			gParam=GetParams();
			var EnablePhcdForMat=GetParam(gParam,"EnablePhcdForMat");
			if (EnablePhcdForMat!='Y')
			{
				Msg.info('error','当前设置不允许维护物资材料的药学项目，请通知系统管理员！');
				return ;
			}
			if (SEL_REC)
			{
				var inci=SEL_REC.get("InciRowid");
				ShowPhc(inci);
			}
			
		}
		
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{
					id: 'mnuPhcdf', 
					handler: editPHCDF, 
					text: ' 药学项维护...' 
				}
				
			] 
		}); 
		
		//======Grid点击事件===================================
		
		//RefreshGridColSet(DrugInfoGrid,"dhcstm.DrugQuery");   //根据自定义列设置重新配置列             
		
		var viewport = new Ext.ux.Viewport({
            layout: 'border',           
            title: '物资列表',
            items: [ HisListTab,DrugInfoGrid ]
        });
       
   function GetParams(){
		var userId = session['LOGON.USERID'];
		var groupId=session['LOGON.GROUPID'];
		var locId=session['LOGON.CTLOCID'];
		var hospId=session['LOGON.HOSPID'];
		var url='dhcstm.druginfomaintainaction.csp?actiontype=GetParamPropNew&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId+"&HospId="+hospId;
		var response=ExecuteDBSynAccess(url);
		var jsonData=Ext.util.JSON.decode(response);
		if(jsonData.success=='true'){
			var info=jsonData.info;
			return info;	
		}
	}

	function GetParam(G,P)
	{
		var len=G.length;
		for (var i=0;i<len;i++)
		{
			var obj=G[i];
			if  (obj.APCode==P)
			{
				return  obj.APValue;
			}
		}
	}

})