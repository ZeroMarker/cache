/*将所选的项目加入到某供货链 */
function SelectItmToAdd(Fn)
{
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
			Ext.getCmp("M_InciDesc2").setValue(InciDesc);
			Ext.getCmp("M_InciCode2").setValue(InciCode);
			
			search();
		}
		
		// 物资编码
		var M_InciCode2 = new Ext.form.TextField({
			fieldLabel : '<font color=blue>物资编码</font>',
			id : 'M_InciCode2',
			name : 'M_InciCode2',
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
		var M_InciDesc2 = new Ext.form.TextField({
			fieldLabel : '<font color=blue>物资名称</font>',
			id : 'M_InciDesc2',
			name : 'M_InciDesc2',
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
			if(e.getKey() == e.ENTER){
					search();
				}			}
		}
	});
	
	// 物资类组
	var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'<font color=blue>类组</font>',
		id : 'M_StkGrpType',
		name : 'M_StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		UserId:gUserId,
		LocId:gLocId,
		DrugInfo:"Y",
		anchor : '90%',
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
		params:{StkGrpId:'M_StkGrpType'}
	});
		var Vendor2=new Ext.ux.VendorComboBox({
		id : 'Vendor2',
		name : 'Vendor2',
		anchor:'90%'
	});

	// 访问路径
	var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url:DspPhaUrl,
		method : "POST"
	});
	// 指定列参数
	var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp",  "BillUom",  "StkCat","NotUseFlag"];
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
		remoteSort: false
	});
	// 添加排序方式
	DrugInfoStore.setDefaultSort('InciCode', 'ASC');
	var chkSm=new Ext.grid.CheckboxSelectionModel({
			// singleSelect:true
		});	
		
	var nm = new Ext.grid.RowNumberer();
	var DrugInfoCm = new Ext.grid.ColumnModel([nm,chkSm, 
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
			header : "售价(入库单位)",
			dataIndex : 'Sp',
			width : 100,
			align : 'right',
			sortable : true
		},  {
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
			header : "不可用",
			dataIndex : 'NotUseFlag',
			width : 45,
			align : 'center',
			renderer : function(v) {
				if (v == "Y")
					return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
				else
					return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
			},
			sortable : true
		}
	]);
	DrugInfoCm.defaultSortable = true;
	
	var DrugInfoToolbar = new Ext.PagingToolbar({
		store:DrugInfoStore,
		pageSize:PageSize,
		id:'DrugInfoToolbar',
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var DrugInfoGrid = new Ext.grid.GridPanel({
		id:'DrugInfoGrid',
		region:'center',
		//height:420,
		//width : 495,
		autoScroll:true,
		cm:DrugInfoCm,
		store:DrugInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		// sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		sm:chkSm,
		loadMask : true,
		//plugins: [ColumnNotUseFlag],
		// tbar:{items:[{text:'列设置',handler:function(){	GridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAINM");}}]},
		bbar:DrugInfoToolbar
		/*view: new Ext.ux.grid.BufferView({
			rowHeight: 30,
			// forceFit: true,
			scrollDelay: false
		})*/
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
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			 M_InciCode2.setValue("");
			 M_InciDesc2.setValue("");
			M_StkGrpType.setValue("");
			M_StkCat.setValue("");
			M_StkGrpType.getStore().load();
			M_StkCat.setRawValue("");
			M_GeneName.setValue("");
			Vendor2.setValue("")
			// //M_AllFlag.setValue(false);
			// Ext.getCmp("FindTypeCombo").setValue("1");
			// M_HighPrice.setValue(false);
			// M_NoHighPrice.setValue(false);
			// M_ChargeFlag.setValue(false);
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
			// drugRowid="";
			// clearData();
		}
	});
	
	/*确定加入*/
	var OkAddBtn = new Ext.Toolbar.Button({
		text:'确定',
		height: 30,
		width : 70,
		iconCls : 'page_save',
		handler:function()
		{
			var sm=Ext.getCmp('DrugInfoGrid').getSelectionModel();
			var arr=sm.getSelections();
			if (arr.length<1)
			{
				Msg.info('error','请选择项目!');
				return;
			}
			var inciS="";
			for (var i=0;i<arr.length;i++)
			{
				var r=arr[i];
				var inci=r.get('InciRowid');
				if (inciS=="")	{inciS=inci;}
				else { inciS=inciS+"^"+inci;}
			}
			if (inciS==""){
				Msg.info('error','请选择项目!');
				return;
			}
			Fn(inciS);
		}
	});
	
	var CloseAdd = new Ext.Toolbar.Button({
		text:'取消',
		height: 30,
		width : 70,
		iconCls : 'page_delete',
		handler:function()
		{
			Ext.getCmp('addItemToSa').close();
		}
	});
	
	function search(){
		DrugInfoGrid.getStore().removeAll();
		DrugInfoGrid.getView().refresh();
		// clearData();
		 var inciDesc = Ext.getCmp("M_InciDesc2").getValue();
		 var inciCode = Ext.getCmp("M_InciCode2").getValue();
		var alias = Ext.getCmp("M_GeneName").getValue();
		var stkCatId = Ext.getCmp("M_StkCat").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
		var Vendor= Ext.getCmp("Vendor2").getValue();
		// if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
			// Msg.info("error", "请选择查询条件!");
			// return false;
		// }
		var allFlag='Y' ;
		//var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
		// var allFlag=Ext.getCmp("FindTypeCombo").getValue();
		// var highPrice=""
		// if(highPrice==""){
			// highPrice= (Ext.getCmp("M_HighPrice").getValue()==true?'Y':'');
		// }
		// if(highPrice==""){
			// highPrice= (Ext.getCmp("M_NoHighPrice").getValue()==true?'N':'');
		// }
		// var charge = (Ext.getCmp("M_ChargeFlag").getValue()==true?'Y':'N');
		
		//类组id
		var others = ""+"^"+""+"^"+""+"^"+StkGrpType;
		//var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetItm'+ '&InciDesc=' + inciDesc + '&InciCode=' + inciCode+ '&Alias=' + alias + '&StkCatId=' + stkCatId + '&AllFlag='+ allFlag + '&Others=' + others;
		/*
		DrugInfoStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		*/
		/*Store异常处理方法一
		DrugInfoStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST",
			listeners : {
				'loadexception' : function(e) {
					Msg.info("warning", "数据访问异常!");
				}
			}
		});
		*/
		// 分页加载数据
		var highPrice="";
		var charge="";
		
		DrugInfoStore.setBaseParam('InciDesc',inciDesc);
		DrugInfoStore.setBaseParam('InciCode',inciCode);
		DrugInfoStore.setBaseParam('Alias',alias);
		DrugInfoStore.setBaseParam('StkCatId',stkCatId);
		DrugInfoStore.setBaseParam('AllFlag',allFlag);
		DrugInfoStore.setBaseParam('HighPrice',highPrice);
		DrugInfoStore.setBaseParam('Charge',charge);
		DrugInfoStore.setBaseParam('Others',others);
		DrugInfoStore.setBaseParam('Vendor',Vendor);
		var pageSize=DrugInfoToolbar.pageSize;
		DrugInfoStore.load({params:{start:0, limit:pageSize},
			callback : function(r,options, success) {					//Store异常处理方法二
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
					//DrugInfoGrid.loadMask.hide();

					//return "{results:0,rows:[]}";
				}else{
					//只有一条记录的话选中此记录
					if(r.length>=1){
						DrugInfoGrid.getSelectionModel().selectFirstRow();
						DrugInfoGrid.getView().focusRow(0);
					}
				}
			}
		});
	}

	var HisListTab = new Ext.form.FormPanel({
		height:150,
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoScroll : false,
		region : 'north',	
		bodyStyle:'padding:5px',
		tbar : [SearchBT, '-', ClearBT,'-',OkAddBtn,'-',CloseAdd],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			style:'padding:0px 0px 0px 5px',
			defaults: {border:false},
			items : [
				{layout:'form',columnWidth:.3,items:[M_InciCode2,M_StkGrpType]},
				{layout:'form',columnWidth:.3,items:[M_InciDesc2,M_StkCat]},
				{layout:'form',columnWidth:.3,items:[Vendor2,M_GeneName]}
				]					
		}]			
	});		
	var winx=new Ext.Window({
		title:'选择项目',
		id:'addItemToSa',
		modal:true,
		width:800,
		height:600,
		layout:'border',
		items:[HisListTab,DrugInfoGrid]
		// ,
		// tbar:[SearchBT]

	});
	winx.show();
}
