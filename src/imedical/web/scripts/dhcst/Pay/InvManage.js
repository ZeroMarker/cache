// /名称: 发票管理
// /编写者：gwj
// /编写日期: 2012.09.18
var invURL="dhcst.invmanageaction.csp"
var gIncId="";
var bfparref=""
var gGroupId=session['LOGON.GROUPID'];
//var deptId = 0;
//var arr = window.status.split(":");
//var length = arr.length;

// 采购科室
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:$g('采购科室'),
	//width:210,
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%'

});

var INVNo = new Ext.form.TextField({
	fieldLabel : $g('发票号'),
	id : 'INVNo',
	name : 'INVNo',
	anchor : '90%'
	//,
	//width : 120
});

var SXNo = new Ext.form.TextField({
	fieldLabel : $g('随行单号'),
	id : 'SXNo',
	name : 'SXNo',
	anchor : '90%'
	//,
	//width : 120
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('供应商'),
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : $g('供应商...')
});
	
// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : $g('起始日期'),
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	width : 120,
	value : new Date().add(Date.DAY, - 30)
});

// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : $g('截止日期'),
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	//width : 120,
	value : new Date()
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : $g('药品名称'),
	id : 'InciDesc',
	name : 'InciDesc',
	anchor : '90%',
	//width : 140,
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				GetPhaOrderInfo(field.getValue(),'');
			}
		}
	}
});
		/**
 * 调用药品窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	
	gIncId=""	;
	if (record == null || record == "") {
		gIncId="";	
		return;
	}
	gIncId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(inciDesc);
}

// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
	text : $g('查询'),
	tooltip : $g('点击查询'),
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		Query();
	}
});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	text : $g('清屏'),
	tooltip : $g('点击清屏'),
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});
// 保存按钮
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : $g('保存'),
	tooltip : $g('点击保存'),
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

/**
 * 查询方法
 */
function Query() {
	var phaLoc = Ext.getCmp("locField").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", $g("请选择采购科室!"));
		return;
	}
	MasterStore.load();
	MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
		
	
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}



/**
 * 清空方法
 */
function clearData() {
	//Ext.getCmp("locField").setValue("");
	SetLogInDept(PhaDeptStore, "locField");
	Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
    Ext.getCmp("EndDate").setValue(new Date());
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("INVNo").setValue("");
	Ext.getCmp("SXNo").setValue("");
	Ext.getCmp("InciDesc").setValue("");
	MasterGrid.store.removeAll();
	MasterGrid.store.load({params:{start:0,limit:0}})
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailStore.setBaseParam('parref','')
	DetailGrid.store.load({params:{start:0,limit:0}})
	DetailGrid.getView().refresh();
	gIncId="";
    bfparref=""
	GridPagingToolbar.updateInfo();
	GridDetailPagingToolbar.updateInfo();
	
}


/**
 * 保存发票信息
 */
function Save() {
	var k=0
	var rowCount = DetailGrid.getStore().getCount();
	if(rowCount==0){Msg.info("warning",$g("无可用保存数据!"));return;}
	for (var i = 0; i < rowCount; i++) {
		//alert(12)
		var rowData = DetailStore.getAt(i);	
		//新增或数据发生变化时执行下述操作
         
		if(rowData.data.newRecord || rowData.dirty){
			//alert('save')
			var ingri=rowData.get("Ingri");
			var invNo = rowData.get("InvNo");
			var invAmt = rowData.get("InvAmt");
			var invDate = Ext.util.Format.date(rowData.get("InvDate"),App_StkDateFormat);
			var sxNo=rowData.get("SxNo");
			//alert(invURL+'?actiontype=updInv&InGrId='+ingri+'&invNo='+invNo+'&invAmt='+invAmt+'&invDate='+invDate+"&sxNo="+sxNo);
			Ext.Ajax.request({
				url: invURL+'?actiontype=updInv&InGrId='+ingri+'&invNo='+invNo+'&invAmt='+invAmt+'&invDate='+invDate+"&sxNo="+sxNo,
				method : 'POST',
				waitMsg : $g('处理中...'),
				failure: function(result,request) {
					Msg.info("error",$g("请检查网络连接!"));
				},
				success: function(result,request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						//Msg.info("success","保存成功!");
						k=k+1
					}
					//======
					if(k==1)
					{Msg.info("success",$g("保存成功!"));}
					//========
				},
				scope: this
				
			});
		}
	}
	DetailStore.load({params:{start:0,limit:GridPagingToolbar.pageSize,parref:bfparref}});
}
		
function rendorPoFlag(value){
    return value=='Y'? $g('是'): $g('否');
}
function rendorCmpFlag(value){
    return value=='Y'? $g('完成'): $g('未完成');
}


// 访问路径
var MasterUrl = invURL	+ '?actiontype=query';
// 通过AJAX方式调用后台数据
var mProxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});
		
// 指定列参数
var mFields = [{name:"RowId",mapping:'ingr'}, {name:"vendorName",mapping:'vendorName'},  
	{name:"phaLoc",mapping:'locDesc'}, {name:"IngrNo",mapping:'ingrNo'}, 
		{name:"CreateDate",mapping:'ingrDate'},{name:"CreateUser",mapping:'ingrUserName'}, 
			{name:"AuditDate",mapping:'auditDate'},{name:"AuditUser",mapping:'auditUserName'},{name:"rpAmt",mapping:'rpAmt'},
				{name:"payedAmt",mapping:'payedAmt'}, {name:"PayedFlag",mapping:'payOverFlag'}];

//var mFields =["ingr","vendorName","ingrNo","ingrDate","ingrUserName","auditDate","auditUserName","rpAmt","spAmt","payedAmt","payOverFlag"]

// 支持分页显示的读取方式
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : mFields
});
// 数据集
var MasterStore = new Ext.data.Store({
	proxy : mProxy,
	reader : mReader,
	remoteSort:true,
	listeners:
	{
		'beforeload':function(ds){
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var invno = Ext.getCmp("INVNo").getValue();
			var sxno = Ext.getCmp("SXNo").getValue();
			
			if (Ext.getCmp('InciDesc').getValue()=='')
			{gIncId=''}
			else
			{}
			var inciid = gIncId  ;  //Ext.getCmp("InciDesc").getValue();
			
			var phaLoc=Ext.getCmp("locField").getValue();
			
			//科室id^开始日期^截止日期^供应商id^发票号^随行单号^药品id
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid;
			var Page=GridPagingToolbar.pageSize;
			//alert(ListParam);
			ds.baseParams={start:0, limit:Page,strParam:ListParam};
			
			
		
		}
	}
});



		
var MasterCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : $g("供应商"),
		dataIndex : 'vendorName',
		width : 240,
		align : 'left',
		sortable : true
	}, {
		header : $g("采购科室"),
		dataIndex : 'phaLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("入库单号"),
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("制单日期"),
		dataIndex : 'CreateDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : $g("制单人"),
		dataIndex : 'CreateUser',
		width : 50,
		align : 'left',
		sortable : true
	}, {
		header : $g("审核日期"),
		dataIndex : 'AuditDate',
		width : 100,
		align : 'left',
		sortable : true
		//,
		//renderer:rendorPoFlag
	}, {
		header : $g("审核人"),
		dataIndex : 'AuditUser',
		width : 100,
		align : 'left',
		sortable : true
		//,
		//renderer:rendorCmpFlag
	}, {
		header : $g("进价金额"),
		dataIndex : 'rpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("已付金额"),
		dataIndex : 'payedAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("结清标志"),
		dataIndex : 'PayedFlag',
		width : 100,
		align : 'left',
		sortable : true
	}]);
	
MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
});

var MasterGrid = new Ext.grid.GridPanel({
	title : '',
	height : 170,
	cm : MasterCm,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	store : MasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:GridPagingToolbar
});

// 添加表格单击行事件
MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	var parref = MasterStore.getAt(rowIndex).get("RowId");
	bfparref=parref
	DetailStore.setBaseParam('parref',parref)
	DetailStore.load({params:{start:0,limit:GridPagingToolbar.pageSize}});
	
});

// 转移明细
// 访问路径
var DetailUrl =  invURL	+ '?actiontype=queryItem';;;
// 通过AJAX方式调用后台数据
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// 指定列参数
var dFields = ["Ingri", "IncId","IncCode","IncDesc", "Spec", "Manf", "BatchNo","ExpDate",{name:"Qty",mapping:'RecQty'},{name:"UomId",mapping:'IngrUomId'},
{name:"Uom",mapping:'IngrUom'}, "Rp", "Sp","RpAmt","SpAmt","InvNo", {name:'InvDate',type:'date',dateFormat:App_StkDateFormat}, {name:"InvAmt",mapping:'InvMoney'}, "SxNo"];
// 支持分页显示的读取方式
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// 数据集
var DetailStore = new Ext.data.Store({
	proxy : dProxy,
	reader : dReader,
	remoteSort:true
});

var DetailCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g("药品Id"),
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g('药品代码'),
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g('药品名称'),
		dataIndex : 'IncDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : $g("规格"),
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g("厂商"),
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : $g("批号"),
		dataIndex : 'BatchNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("效期"),
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("入库数量"),
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : $g("单位"),
		dataIndex : 'Uom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g("进价"),
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("售价"),
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("进价金额"),
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("售价金额"),
		dataIndex : 'SpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("发票号"),
		dataIndex : 'InvNo',
		width : 80,
		align : 'center',
		sortable : true,
		editable:true,
		editor:new Ext.form.TextField({
			listeners:{
				'blur':function(field){
					var invNo=field.getValue();
					var IngrRecord=MasterGrid.getSelectionModel().getSelected();
					var Ingr=IngrRecord.get('RowId');
					var flag=InvNoValidator(invNo,Ingr);
					if(flag==false){
						Msg.info("warning",$g("发票号")+invNo+$g("存在于其他入库单中!"));
						field.setValue("");
					}
				}
				
			}
		})
	}, {
		header : $g("发票日期"),
		dataIndex : 'InvDate',
		width : 100,
		align : 'center',
		sortable : true,
		editable:true,
		renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
		})
		
	}, {
		header : $g("发票金额"),
		dataIndex : 'InvAmt',
		width : 100,
		align : 'right',
		sortable : true,
		editable:true,
		editor:new Ext.form.NumberField({
		})
	}, {
		header : $g("随行单号"),
		dataIndex : 'SxNo',
		width : 80,
		align : 'center',
		sortable : true,
		editable:true,
		editor:new Ext.form.TextField({
		})
	}]);
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
});

var DetailGrid = new Ext.grid.EditorGridPanel({
	title : $g('入库单明细'),
	height : 200,
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	bbar:GridDetailPagingToolbar,
	loadMask : true
});

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	autoHeight: true,
	//bodyStyle : 'padding:5px;',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT],
	items:[{
		xtype:'fieldset',
		title:$g('查询条件'),
		layout:'column',
		autoHeight:true,
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{ 		
			columnWidth: 0.34,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [locField,Vendor]
		
		},{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [StartDate,EndDate]
		
		},{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [INVNo,SXNo]
		
		},
		{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [InciDesc]
		
		}]
	}]
	
});
			
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var CtLocId = session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	GetGroupDeptStore.load();
	// 页面布局
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [            // create instance immediately
            {
                title:$g('发票管理'),
                region: 'north',
                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
                layout: 'fit', // specify layout manager for items
                items:HisListTab
            }, {
                region: 'center',
                title: $g('入库单'),			               
                layout: 'fit', // specify layout manager for items
                items: MasterGrid       
               
            }, {
                region: 'south',
                split: true,
    			height: 300,
    			minSize: 200,
    			maxSize: 350,
    			//collapsible: true,
                //title: '入库单明细',
                layout: 'fit', // specify layout manager for items
                items: DetailGrid                     
            }
		],
		renderTo : 'mainPanel'
	});	
})