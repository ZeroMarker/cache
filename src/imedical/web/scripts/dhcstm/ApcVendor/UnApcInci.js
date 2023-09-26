/*供应商待授权物资列表 */
function SelectItmToApcInci(Venid,Fn)
{
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
						var stktype = Ext.getCmp("M_StkGrpType2").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
	// 物资别名
	var M_GeneName2 = new Ext.form.TextField({
		fieldLabel : '<font color=blue>物资别名</font>',
		id : 'M_GeneName2',
		name : 'M_GeneName2',
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
	var M_StkGrpType2=new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'<font color=blue>类组</font>',
		id : 'M_StkGrpType2',
		name : 'M_StkGrpType2',
		StkType:App_StkTypeCode,     //标识类组类型
		UserId:gUserId,
		LocId:gLocId,
		DrugInfo:"Y",
		anchor : '90%',
		listeners:{
			'select':function(){
				Ext.getCmp("M_StkCat2").setValue('');
			}
		}
	}); 
	
	
	// 库存分类
	var M_StkCat2 = new Ext.ux.ComboBox({
		fieldLabel : '<font color=blue>库存分类</font>',
		id : 'M_StkCat2',
		name : 'M_StkCat2',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'M_StkGrpType2'}
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
	var chkSm=new Ext.grid.CheckboxSelectionModel({});	
		
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
		autoScroll:true,
		cm:DrugInfoCm,
		store:DrugInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		sm:chkSm,
		loadMask : true,
		bbar:DrugInfoToolbar
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
			M_StkGrpType2.setValue("");
			M_StkCat2.setValue("");
			M_StkGrpType2.getStore().load();
			M_StkCat2.setRawValue("");
			M_GeneName2.setValue("");
			Vendor2.setValue("")
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
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
				Msg.info('error','请选择需要添加的物资记录!');
				return;
			}
			var InciStr="";
			for (var i=0;i<arr.length;i++)
			{
				var r=arr[i];
				var inci=r.get('InciRowid');
				if (InciStr=="")	{InciStr=inci;}
				else { InciStr=InciStr+"^"+inci;}
			}
			if (InciStr==""){
				Msg.info('error','请选择需要添加的物资记录!');
				return;
			}
			Ext.Ajax.request({
				url: 'dhcstm.venincitmaction.csp?actiontype=Save',
				params: {InciStr:InciStr, Venid:Venid},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "授权成功!");
						Fn();
					}else{
						var retinfo=jsonData.info;
						Msg.info("error", "授权失败!"+retinfo);
					}
				},
				scope: this
			});
			Ext.getCmp('UnInciToApc').close();
			Fn();
		}
	});
	
	var CloseAdd = new Ext.Toolbar.Button({
		text:'取消',
		height: 30,
		width : 70,
		iconCls : 'page_delete',
		handler:function()
		{
			Ext.getCmp('UnInciToApc').close();
		}
	});
	
	function search(){
		DrugInfoGrid.getStore().removeAll();
		DrugInfoGrid.getView().refresh();
		var inciDesc = Ext.getCmp("M_InciDesc2").getValue();
		var inciCode = Ext.getCmp("M_InciCode2").getValue();
		var alias = Ext.getCmp("M_GeneName2").getValue();
		var stkCatId = Ext.getCmp("M_StkCat2").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType2").getValue();
		var Vendor= Ext.getCmp("Vendor2").getValue();
		if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
			Msg.info("error", "请选择查询条件!");
			return false;
		}
		var allFlag=2 ;
		var others = "^^^"+StkGrpType;
		
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
		DrugInfoStore.load({params:{start:0, limit:pageSize}});
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
				{layout:'form',columnWidth:.3,items:[M_InciCode2,M_StkGrpType2]},
				{layout:'form',columnWidth:.3,items:[M_InciDesc2,M_StkCat2]},
				{layout:'form',columnWidth:.3,items:[Vendor2,M_GeneName2]}
				]					
		}]			
	});		
	var UnInciToApc=new Ext.Window({
		title:'选择项目',
		id:'UnInciToApc',
		modal:true,
		width:800,
		height:600,
		layout:'border',
		items:[HisListTab,DrugInfoGrid]

	});
	UnInciToApc.show();
}
