// /名称: 批次锁定
// /编写者：徐超
// /编写日期: 2015.05.019
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
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
			search();
		}

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
					search();	
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
					search();	
				}
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
		var FindTypeData=[['全部','1'],['可用','2'],['不可用','3']];
	   var FindTypeStore = new Ext.data.SimpleStore({
		    fields: ['typedesc', 'typeid'],
		    data : FindTypeData
		})
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
		//==========控件==========================
	
		// 访问路径
		var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// 指定列参数
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "StkCat","NotUseFlag"];
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
		DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
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
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "请选择查询条件!");
				return false;
			}
			var allFlag=Ext.getCmp("FindTypeCombo").getValue();
			//药学大类id^药学子类id^药学更小分类id^类组id
			var others = ""+"^"+""+"^"+""+"^"+StkGrpType;
			// 分页加载数据
			DrugInfoStore.setBaseParam('InciDesc',inciDesc);
			DrugInfoStore.setBaseParam('InciCode',inciCode);
			DrugInfoStore.setBaseParam('Alias',alias);
			DrugInfoStore.setBaseParam('StkCatId',stkCatId);
			DrugInfoStore.setBaseParam('AllFlag',allFlag);
			DrugInfoStore.setBaseParam('Others',others);
			var pageSize=DrugInfoToolbar.pageSize;
			DrugInfoStore.load({params:{start:0, limit:pageSize},
				callback : function(r,options, success) {					//Store异常处理方法二
					if(success==false){
     					Msg.info("error", "查询错误，请查看日志!");
     				}else{
     					if(r.length>0){
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
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				ItmBatGrid.getStore().removeAll();
				
			}
		});
		
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
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
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
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 70,
				align : 'center',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BUom',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			},  {
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
		var DrugInfoToolbar = new Ext.PagingToolbar({
			store:DrugInfoStore,
			pageSize:PageSize,
			id:'DrugInfoToolbar',
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
		});
		
		var DrugInfoGrid = new Ext.ux.GridPanel({
			title:'物资信息',
			id:'DrugInfoGrid',
			region:'center',
			cm:DrugInfoCm,
			store:DrugInfoStore,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			bbar:DrugInfoToolbar
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			height:170,
			title:'物资批次锁定',
			region : 'north',	
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'查询条件--<font color=red>类组、库存分类、物资编码、物资名称、物资别名不能全部为空</font>',
				layout: 'column',   
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [M_InciCode,M_StkGrpType]					
				}, {
					columnWidth: 0.25,
	            	xtype: 'fieldset',
					items : [M_InciDesc,M_StkCat]
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [M_GeneName,FindTypeCombo]					
				}
				]					
			}]			
		});
		
		//==== 添加表格选取行事件=============
	   DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			ItmBatStore.setBaseParam('Inci',InciRowid)
			ItmBatStore.load()
		});
		
		var ItmBatStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:'dhcstm.itmbatlockaction.csp?actiontype=GetBatInfo',
		root : 'rows',
		totalProperty : "results",	
		fields :["incib","incibno","incibexp","apcname","phmname","recallflag"],
		pruneModifiedRecords:true
		
	});
var recallflag = new Ext.grid.CheckColumn({
	header:'是否锁定',
	dataIndex:'recallflag',
	sortable:true,
	width:60
});
	var ItmBatCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : "批次RowID",
				dataIndex : 'incib',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "批号",
				dataIndex : 'incibno',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '效期',
				dataIndex : 'incibexp',
				width : 80,
				align : 'left',
				sortable : true
				
			}, {
				header : "供应商",
				dataIndex : 'apcname',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'phmname',
				width : 150,
				align : 'left',
				sortable : true
			},recallflag
		]);
	var saveB = new Ext.ux.Button({
	iconCls:'page_save',
	text:'保存',
	handler:function(){
		//获取所有的新记录
		var mr=ItmBatStore.getModifiedRecords();
		var listData="";
		for(var i=0;i<mr.length;i++){
			var rowId=mr[i].data["incib"];
			var recallflag = mr[i].data["recallflag"];
			var dataRow = rowId+"^"+recallflag;
			if(listData==""){
				listData = dataRow;
			}else{
				listData = listData+xRowDelim()+dataRow;
			}
		}
		if(listData!=""){
			Ext.Ajax.request({
				url: 'dhcstm.itmbatlockaction.csp?actiontype=Save',
				params: {listData:listData},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						ItmBatStore.reload();
					}else{
						Msg.info("error", "保存失败!");
					}
				},
				scope: this
			});
		}
	}
});
	var ItmBatGrid = new Ext.ux.EditorGridPanel({
		id : 'ItmBatGrid',
		title : '批次信息',
		width:600,
		cm : ItmBatCm,
		tbar:[saveB],
		plugins:recallflag,
		store : ItmBatStore,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		region : 'east',
		clicksToEdit : 1
	});
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
            layout: 'border',
            items: [HisListTab,DrugInfoGrid,ItmBatGrid]
        });
})