// /名称: 物资信息维护
// /描述: 物资信息维护
// /编写者：zhangdongmei
// /编写日期: 2011.12.16
// /修改：2012-06-14，调整布局
var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var SEL_REC;
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
		//==========函数==========================
		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				//GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			
			search();
		}
		/***
		**添加右键菜单方法,20170222
		**/
		//设置为可用
		function setUse()
		{		
			if (SEL_REC)
			{
		        var NotUseFlag=SEL_REC.get("NotUseFlag");   //N可用  Y不可用
				if(NotUseFlag=="N")
				{
					Msg.info('error','当前已设置为"可用"，重复设置！');
					return;
				}
				var inci=SEL_REC.get("InciRowid");
				SetNotUseFlag(inci,"N");
			}
			
		}
		//设置为不可用
		function setNotUse()
		{	
			if (SEL_REC)
			{
		        var NotUseFlag=SEL_REC.get("NotUseFlag");   //N可用  Y不可用
				if(NotUseFlag=="Y")
				{
					Msg.info('error','当前已设置为"不可用"，重复设置！');
					return;
				}
				var inci=SEL_REC.get("InciRowid");
				SetNotUseFlag(inci,"Y");
			}
		}
		//更新“不可用”状态
		function SetNotUseFlag(inci,NotUseFlag)
		{
			var clsName="web.DHCSTM.INCITM";
		    var methodName="UpdNotUseFlag";
		    var ret=tkMakeServerCall(clsName,methodName,inci,NotUseFlag) ;
			if(ret<0){
				Msg.info('error','设置失败！');
				return ret;
			}
			else{
				Msg.info("success", "设置成功!");
				DrugInfoStore.reload();
			}
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
			fieldLabel : '<font color=blue>物资编码</font>',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});
		
		// 物资名称
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>物资名称</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
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
			fieldLabel : '<font color=blue>物资别名</font>',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});

		// 物资类组
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel:'<font color=blue>类组</font>',
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			UserId:userId,
			LocId:gLocId,
			DrugInfo:"Y",
			anchor : '90%',
			//scgset:"'MM'",
			listWidth : 200,
			listeners:{
				'select':function(){
					Ext.getCmp("M_StkCat").setValue('');
				}
			}
		});
		
		// 库存分类
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '<font color=blue>库存分类</font>',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'StkCatName',
			params:{StkGrpId:'M_StkGrpType'}
		});

		// 全部
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
		
		var M_HighPriceFlag = new Ext.form.RadioGroup({
			id : 'M_HighPriceFlag',
			hideLabel : true,
			items : [
				{boxLabel:'全部',name:'M_HighPriceFlag',id:'HighPrice_All',inputValue:'',checked:true},
				{boxLabel:'高值',name:'M_HighPriceFlag',id:'HighPrice_Yes',inputValue:'Y'},
				{boxLabel:'非高值',name:'M_HighPriceFlag',id:'HighPrice_No',inputValue:'N'}
			]
		});
		// 收费标志
		var M_ChargeFlag = new Ext.form.RadioGroup({
			id : 'M_ChargeFlag',
			hideLabel : true,
			items : [
				{boxLabel:'全部',name:'M_ChargeFlag',id:'Charge_All',inputValue:'',checked:true},
				{boxLabel:'收费',name:'M_ChargeFlag',id:'Charge_Yes',inputValue:'Y'},
				{boxLabel:'不收费',name:'M_ChargeFlag',id:'Charge_No',inputValue:'N'}
			]
		});
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor:'90%'
		});
		
		var M_AckSpFlag = new Ext.form.Checkbox({
			id : 'M_AckSpFlag',
			hideLabel : true,
			boxLabel : '仅未确认医嘱项'
		});
		
		// 建档时间
		var CreateDayData=[['','全部'],['1','最近1天'],['2','最近2天'],['3','最近3天'],['4','最近4天'],['5','最近5天'],['10','最近10天'],['20','最近20天'],['30','最近30天']];
		var CreateDayStore = new Ext.data.SimpleStore({
			fields: ['dayid','daydesc'],
			data : CreateDayData
		});
		var CreateDay = new Ext.form.ComboBox({
			store: CreateDayStore,
			displayField:'daydesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'CreateDay',
			fieldLabel : '建档日期',
			triggerAction:'all', 
			valueField : 'dayid'
		});
		Ext.getCmp("CreateDay").setValue("");
		
		//更新时间
		var UpdateDayData=[['','全部'],['1','最近1天'],['2','最近2天'],['3','最近3天'],['4','最近4天'],['5','最近5天'],['10','最近10天'],['20','最近20天'],['30','最近30天']];
		var UpdateDayStore = new Ext.data.SimpleStore({
			fields: ['dayid','daydesc'],
			data : UpdateDayData
		});
		var UpdateDay = new Ext.form.ComboBox({
			store: UpdateDayStore,
			displayField:'daydesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'UpdateDay',
			fieldLabel : '更新日期',
			triggerAction:'all', 
			valueField : 'dayid'
		});
		Ext.getCmp("UpdateDay").setValue("");
		
		//==========控件==========================
	
		// 访问路径
		var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// 指定列参数
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Rp", "Sp", "BillUom",  "StkCat","NotUseFlag","model","brand","incicreateDate","inciupdateDate","ArcId"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
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
				search();
			}
		});

		function search(){
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
			clearData();
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "请选择查询条件!");
				return false;
			}
			var Vendor= Ext.getCmp("Vendor").getValue();
			var allFlag=Ext.getCmp("FindTypeCombo").getValue();
			var highPrice = Ext.getCmp("M_HighPriceFlag").getValue().getGroupValue();
			var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
			var AckSpFlag = Ext.getCmp('M_AckSpFlag').getValue()?'N':'';	//Y:已确认,N:未确认,'':所有
			var Createday= Ext.getCmp("CreateDay").getValue();
			var Updateday= Ext.getCmp("UpdateDay").getValue();
			// ^^^类组id^进价取法参数^规格^品牌^简称^基本单位进价^建档时间^更新时间
			var others = ""+"^"+""+"^"+AckSpFlag+"^"+StkGrpType+"^^^^^^^"+Createday+"^"+Updateday;
			// 分页加载数据
			DrugInfoStore.setBaseParam('InciDesc',inciDesc);
			DrugInfoStore.setBaseParam('InciCode',inciCode);
			DrugInfoStore.setBaseParam('Alias',alias);
			DrugInfoStore.setBaseParam('StkCatId',stkCatId);
			DrugInfoStore.setBaseParam('AllFlag',allFlag);
			DrugInfoStore.setBaseParam('HighPrice',highPrice);
			DrugInfoStore.setBaseParam('Charge',charge);
			DrugInfoStore.setBaseParam('Others',others);
			DrugInfoStore.setBaseParam('Vendor',Vendor);
			DrugInfoStore.setBaseParam('sort','InciRowid');
			DrugInfoStore.setBaseParam('dir','ASC');
			var pageSize=DrugInfoToolbar.pageSize;
			DrugInfoStore.load({params:{start:0, limit:pageSize},
				callback : function(r,options, success) {
					if(success==false){
						Msg.info("error", "查询错误，请查看日志!");
					}else{
						if(r.length>=1){
							DrugInfoGrid.getSelectionModel().selectFirstRow();
							DrugInfoGrid.getView().focusRow(0);
						}
					}
				}
			});
		}
		
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
				M_StkCat.setValue("");
				M_StkGrpType.getStore().load();
				M_StkCat.setRawValue("");
				M_GeneName.setValue("");
				Ext.getCmp("FindTypeCombo").setValue("1");
				M_HighPriceFlag.setValue('');
				M_ChargeFlag.setValue('');
				Vendor.setValue("");
				M_AckSpFlag.setValue('');
				DrugInfoGrid.getStore().removeAll();
				Common_ClearPaging(DrugInfoToolbar);
				DrugInfoGrid.getView().refresh();
				drugRowid="";
				CreateDay.setValue("");
				UpdateDay.setValue("");
				clearData();
			}
		});
		
		var AckSpButton = new Ext.ux.Button({
			text : '确认不需维护医嘱项',
			iconCls : 'page_gear',
			handler : function(b,e){
				var rowData = DrugInfoGrid.getSelectionModel().getSelected();
				if(Ext.isEmpty(rowData)){
					Msg.info('warning', '请选择需要维护的库存项');
					return false;
				}
				var InciId = rowData.get('InciRowid');
				var AckFlag = 'Y';
				var result = tkMakeServerCall('web.DHCSTM.INCITM', 'SetAckSpFlag', InciId, AckFlag, userId);
				if(result == ''){
					Msg.info('success', '维护成功!');
				}else{
					Msg.info('error', '维护失败:' + result);
				}
			}
		});
		///发送物资信息到平台
		var SendToSCMFlagData=[['全部','1'],['发送','2'],['未发送','3']];
		var SendToSCMFlagStore = new Ext.data.SimpleStore({
			fields: ['STSCMdesc', 'STSCMid'],
			data : SendToSCMFlagData
		});
		var SendToSCMFlagCombo = new Ext.form.ComboBox({
			store: SendToSCMFlagStore,
			displayField:'STSCMdesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'SendToSCMFlagCombo',
			fieldLabel : '是否发送',
			triggerAction:'all', //取消自动过滤
			valueField : 'STSCMid'
		});
		Ext.getCmp("SendToSCMFlagCombo").setValue("1");
		var SendInciBT = new Ext.Toolbar.Button({
					id : "SendInciBT",
					text : '发送物资信息到平台',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						    var rowData=DrugInfoGrid.getSelectionModel().getSelected();
							if (rowData ==null) {
								Msg.info("warning", "请选择需要发送的物资信息!");
								return;
							}
							var InciRowid = rowData.get("InciRowid");
							SendInci(InciRowid);
					}
		});
		function SendInci(InciRowid){
			 var url = "dhcstm.druginfomaintainaction.csp?actiontype=SendInci";
		        var loadMask=ShowLoadMask(Ext.getBody(),"发送信息中...");
		        Ext.Ajax.request({
		                    url : url,
		                    method : 'POST',
		                    params:{InciRowid:InciRowid},
		                    waitMsg : '处理中...',
		                    success : function(result, request) {
		                        var jsonData = Ext.util.JSON.decode(result.responseText);
		                        if (jsonData.success == 'true') {
		                            var IngrRowid = jsonData.info;
		                            Msg.info("success", "发送成功!");
		                            search();
		                        } else {
		                            var ret=jsonData.info;
		                            Msg.info("error", jsonData.info);
		                            search();
		                        }
		                    },
		                    scope : this
		                });
		        loadMask.hide();
		}
		
		var nm = new Ext.grid.RowNumberer();
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
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
			}, { 
				header : '物资名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "型号",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "品牌",
				dataIndex : 'brand',
				width : 50,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "进价(入库单位)",
				dataIndex : 'Rp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价(入库单位)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
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
			}, {
				header : '创建日期',
				dataIndex : 'incicreateDate',
				width : 80,
				align : 'left'
			}, {
				header : '更新日期',
				dataIndex : 'inciupdateDate',
				width : 80,
				align : 'left'
			}, {
				xtype : 'checkcolumn',
				header : "不可用",
				dataIndex : 'NotUseFlag',
				width : 45,
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		
		var DrugInfoToolbar = new Ext.PagingToolbar({
			store:DrugInfoStore,
			pageSize:PageSize,
			id:'DrugInfoToolbar',
			displayInfo:true
		});
		
		var DrugInfoGrid = new Ext.ux.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			tbar:[AckSpButton],
			bbar:DrugInfoToolbar,
			viewConfig:{
				getRowClass : function(record,rowIndex,rowParams,store){ 
					var ArcId=parseInt(record.get("ArcId"));
					if(!isNaN(ArcId)&& ArcId>0){
						return 'classGreen';
					}
								
				}
			},
			listeners:
			{
				rowcontextmenu : function(grid,rowindex,e){
					e.preventDefault();
					SEL_REC=grid.getStore().getAt(rowindex);
					rightClick.showAt(e.getXY());
				}
			}
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			labelWidth: 60,
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'查询条件--<font color=red>类组、库存分类、物资编码、物资名称、物资别名不能全部为空</font>',
				layout: 'column',
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items : [{
					columnWidth: 0.5,
					items: [M_InciCode,M_InciDesc,M_GeneName,Vendor,CreateDay,UpdateDay]
				}, {
					columnWidth: 0.5,
					items : [M_StkGrpType,M_StkCat,FindTypeCombo,M_ChargeFlag,M_HighPriceFlag,M_AckSpFlag]
				}]
			}]
		});
		//==== 添加表格选取行事件=============
		DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//查询三大项信息
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}
			
			GetDetail(drugRowid);
		});
		
		/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		//右键菜单
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [			
				{
					id: 'Rbtn_UseFlag', 
					handler: setUse, 
					text: '可用' 
				},
				{
					id: 'Rbtn_NotUseFlag', 
					handler: setNotUse, 
					text: '不可用' 
				}
			] 
		});
		
		var viewport = new Ext.ux.Viewport({
			layout: 'border',
			items: [{
				region: 'center',
				title: '物资列表',
				split: true,
				width: 500,
				minSize: 470,
				maxSize: 600,
				margins: '0 5 0 0',
				layout: 'border', 
				items : [HisListTab,DrugInfoGrid]
			},talPanel]
		});

		InitDetailForm();
		var btnids="Rbtn_UseFlag^Rbtn_NotUseFlag";
		Authorization(btnids);
});