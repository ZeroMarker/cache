var userid = session['LOGON.USERID'];

var commonboxUrl = 'herp.srm.PrjReimbursemenmainexe.csp';
///////////////////////// 年度///////////////////////////////////
var projUrl = 'herp.srm.PrjReimbursemenmainexe.csp';

///立项年度
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('yearCombo').getRawValue()),
	method:'POST'});
});

var yearCombo = new Ext.form.ComboBox({
	id: 'yearCombo',
	fieldLabel: '立项年度',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'yearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});
//项目名称
var projnameField = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true,
	labelSeparator:''

});



var findButton = new Ext.Toolbar.Button({
	text: '查询',
	//tooltip: '查询',
	iconCls: 'search',
	handler: function(){
	    var year = yearCombo.getValue();
	    var prjname = projnameField.getValue();
	    //alert(budgdeptname);
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,prjname:prjname}});
	}
});
var itemGrid = new dhc.herp.Grid({
		    title: '项目支出报销申请',
		    iconCls: 'list',
		    region : 'north',
		    url: 'herp.srm.PrjReimbursemenmainexe.csp',
			fields : [{
						id : 'rowid',
						header : '项目ID',
						dataIndex : 'rowid',
						editable:false,
						hidden : true
					},{
						id : 'year',
						header : '立项年度',
						editable:false,
						width : 60,
						dataIndex : 'year'

					},{
						id : 'code',
						header : '项目编号',
						width : 100,
						editable:false,
						dataIndex : 'code'

					},{
						id : 'name',
						header : '项目名称',
						editable:false,
						width : 180,

						dataIndex : 'name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'username',
						header : '负责人',
						width : 60,
						editable:false,
						dataIndex : 'username'

					}, {
						id : 'FundTotal',
						header : '编制总额(万元)',
						width : 100,
						editable : false,
						align:'right',
						renderer: function(val,cellmeta, record,rowIndex, columnIndex, store)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return '<span style="color:blue;cursor:hand"><u>'+val+'</u></span>'
		 },
						
						dataIndex : 'FundTotal'
						
						
					},{
						id : 'ActPayWait',
						header : '在途报销(万元)',
						width : 100,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }				
					},{
						id : 'ActPayMoney',
						header : '已经执行(万元)',
						width : 100,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						

					},{
						id : 'budgco',
						header : '编制结余(万元)',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgco',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'PrjFundMatched',
						header : '到位资金(万元)',
						editable:false,
						width : 100,
						align:'right',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return '<span style="color:blue;cursor:hand"><u>'+val+'</u></span>'
		 },
						dataIndex : 'PrjFundMatched'
					},{
						id : 'PrjFundMatchedSY',
						header : '到位资金结余(万元)',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'PrjFundMatchedSY',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }

					},{
						id : 'GraFunds',
						header : '批准经费(万元)',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'GraFunds',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						tbar:['','立项年度','',yearCombo,'','项目名称','',projnameField,'-',findButton],
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:25,userid:userid},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){	
    var projdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	projdr=selectedRow[0].data['rowid'];
	itemDetail.load({params:{start:0,limit:25,userid:userid,projdr:projdr}});	
});


////////////// 单击项目名称 单击gird的单元格事件 /////////////////
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("name");
		FundTotalfun(FundBillDR,Name);
	}
	
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("name");
		PrjFundMatchedfun(FundBillDR,Name);
	}
});



