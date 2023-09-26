 
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
//====================================================
 var InciRowId="" ;
 
 var IMC="";
 var MCSA=""
 //名称
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	InciRowId = record.get("InciDr");
	// var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(InciDesc);
	// Ext.getCmp("M_InciCode").setValue(InciCode);
	findSA.handler();
}
		
var conditionDescField = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	width : 150,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = ""
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});	

  //注册证
 var certNo = new Ext.form.TextField({
    id:'certNo',
    fieldLabel:'注册证',
    allowBlank:true,
    listWidth:150,
    emptyText:'注册证...',
    anchor:'90%',
    selectOnFocus:true
});

 //厂商
var PhManufacturer = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'PhManufacturer',
	name : 'PhManufacturer',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
	// ,
	// params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
});

//供应商
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	listWidth : 250,
	rcFlag:true
	// ,
	// params : {LocId : 'locField',ScgId : 'groupField'}
});
 
 			
				
var itmManfCertSAGrid="";
//配置数据源
var itmManfCertSAUrl = 'dhcstm.itmmanfcertsaaction.csp';
var itmManfCertSAGridProxy= new Ext.data.HttpProxy({
	url:itmManfCertSAUrl+'?actiontype=querySAByManf'
	// ,
	// method:'POST'
});
var itmManfCertSADs = new Ext.data.GroupingStore({
    proxy:itmManfCertSAGridProxy,
	sortInfo:{field: 'manf', direction: 'ASC'},
	 groupOnSort: true,
	groupField:'manf',
    reader:new Ext.data.JsonReader({
		 idProperty:'RowId',
        root:'rows',
        totalProperty:'results'
    }, [
	    {name:'RowId'}, 
        {name:'manf'},
        {name:'certNo'},
        {name:'certNoExpDate'},
        {name:'vendor1'},
        {name:'vendor1ExpDate'},
        {name:'vendor2'},
        {name:'vendor2ExpDate'},
        {name:'vendor3'},
        {name:'vendor3ExpDate'},
		'vendor4', 'vendor4ExpDate',
        {name:'active'}
    ])
});


		
var itmManfCertSAGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
		hidden:true,
        align:'left',
        sortable:true
    },
     {
        header:"厂商",
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"注册证",
        dataIndex:'certNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"注册证效期",
        dataIndex:'certNoExpDate',
        width:120,
        align:'left',
        sortable:true
		// ,
        // editor:new Ext.grid.GridEditor(SlgG),
        // renderer : Ext.util.Format.comboRenderer2(SlgG,"SlgId","SlgDesc")
    },{
        header:"供应商(一级)",
        dataIndex:'vendor1',
        width:150,
        align:'left',
        sortable:true
		// ,
        // editor:new Ext.grid.GridEditor(LigG),
        // renderer : Ext.util.Format.comboRenderer2(LigG,"LigId","LigDesc")
    },{
        header:"供应商(一级)效期",
        dataIndex:'vendor1ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
        header:"供应商(二级)",
        dataIndex:'vendor2',
        width:150,
        align:'left',
        sortable:true

    },{
        header:"供应商(二级)效期",
        dataIndex:'vendor2ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
        header:"供应商(三级)",
        dataIndex:'vendor3',
        width:150,
        align:'left',
        sortable:true
		
    },{
        header:"供应商(三级)效期",
        dataIndex:'vendor3ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
		header:"供应商(四级)",
		dataIndex:'vendor4',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"供应商(四级)效期",
		dataIndex:'vendor4ExpDate',
		width:120,
		align:'left',
		sortable:true
	},{
		header:'资质',
		 tooltip: "资质图片",  
		 width:50,
		 renderer: function (value, meta, record) {  
  
			 var formatStr = "<button  onclick=browsePics() class='order_bit'>查看</button>";   
			 var resultStr = String.format(formatStr);  
			 return "<div class='controlBtn'>" + resultStr + "</div>";  
		 } .createDelegate(this),  
		 css: "text-align:center;height:8",  
		 sortable: false  
	}
]);
 
function browsePics()
{
  
  var sm=Ext.getCmp('mcsagrid').getSelectionModel();
  var rec=sm.getSelected();
  if (!rec)
  {
	  return;  
  }
  var rowid=rec.get('RowId');
  
	var PicUrl = 'dhcstm.itmmanfcertsaaction.csp?actiontype=GetSaPic';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : PicUrl,
		method : "POST"
	});
	
	// 指定列参数
	var fields = ["rowid", "venid","vendesc", "picsrc","type"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		// id : "rowid",
		fields : fields
	});
	// 数据集
	var PicStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var FnDel=function(rowid,picsrc)
		{
			   var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url:'dhcstm.apcvendoraction.csp?actiontype=DeletePic&rowid='+rowid+'&picsrc='+picsrc,
					waitMsg:'删除中...',
					failure: function(result, request) {
						 mask.hide();
						Msg.info("error", "请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success", "删除成功!");
				  
						}else{ 
								Msg.info("error", "删除失败!");
						}
					},
					scope: this
				});
			}

	ShowPicWindow(PicStore,rowid,FnDel)  
}
var clearSA = new Ext.Toolbar.Button({
    text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
    width : 70,
    height : 30,
    handler:function(){
		Ext.getCmp('PhManufacturer').setValue('');
		Ext.getCmp('Vendor').setValue('');
		Ext.getCmp('certNo').setValue('');
		
		itmManfCertSAGrid.getStore().removeAll();
        itmManfCertSAGrid.getView().refresh();
    }
});

var findSA = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){	
    	// itmManfCertSADs.setBaseParam("sort",'Rowid');
		var manf=Ext.getCmp('PhManufacturer').getValue();
		var cert=Ext.getCmp('certNo').getValue();
		var vendor=Ext.getCmp('Vendor').getValue();
		if(Ext.getCmp('M_InciDesc').getValue() == ''){
			InciRowId = '';
		}
		var inci=InciRowId;  //品种
        itmManfCertSADs.load({params:{start:0,limit:itmManfCertSAToolBar.pageSize,manf:manf,cert:cert,vendor:vendor,inci:inci}});
    }
});

var findItmListButton=new Ext.Toolbar.Button({
	text:'供货品种列表...',
	iconCls:'page_refresh',
	width:70,
	height:30,
	handler:function()
	{
		var sm=itmManfCertSAGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning", "请选择授权链!");
			return;
		}
		var sa=rec.get('RowId');
		if (sa==''){return;}
		//检索
		
		MCSAItmList(sa);
		
	}
});


var formPanel = new Ext.ux.FormPanel({
	title:'物资供货与授权信息',
    tbar:[findSA,'-',clearSA,'-',findItmListButton],
    items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,columnWidth : .33,xtype:'fieldset'},
		items : [{
				items : [PhManufacturer,certNo]
			}, {
				items : [Vendor]
			}, {
				items : [conditionDescField]
		}]
    }]
});

//分页工具栏
var itmManfCertSAToolBar = new Ext.PagingToolbar({
    store:itmManfCertSADs,
    pageSize:PageSize,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
itmManfCertSAGrid = new Ext.grid.EditorGridPanel({
	title:'供货授权链',
	id:'mcsagrid',
    store:itmManfCertSADs,
    cm:itmManfCertSAGridCm,
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
	view: new Ext.grid.GroupingView({
        forceFit: true,
		headersDisabled :true,
			hideGroupedColumn :true,
        // custom grouping text template to display the number of items per group
        groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "条" : "条"]})'
    }),
    sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    // plugins: [ActiveF,ReqAllItmF],
    //plugins:[B,BB] ReqAllItmF,
    
    loadMask:true,
    bbar:itmManfCertSAToolBar,
    clicksToEdit:2
});

//=========================科室扩展信息=============================

//===========模块主页面=============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'物资供货与授权信息',
        activeTab:0,
        region:'north',
        height:170,
        layout:'fit',
        items:[formPanel]
    });
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,itmManfCertSAGrid],
        renderTo:'mainPanel'
    });
});
//===========模块主页面=============================================