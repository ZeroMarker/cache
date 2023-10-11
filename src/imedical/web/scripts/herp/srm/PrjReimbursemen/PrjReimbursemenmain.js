var userid = session['LOGON.USERID'];

var commonboxUrl = 'herp.srm.PrjReimbursemenmainexe.csp';
///////////////////////// ���///////////////////////////////////
var projUrl = 'herp.srm.PrjReimbursemenmainexe.csp';

///�������
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
	fieldLabel: '�������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'yearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});
//��Ŀ����
var projnameField = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true,
	labelSeparator:''

});



var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	//tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
	    var year = yearCombo.getValue();
	    var prjname = projnameField.getValue();
	    //alert(budgdeptname);
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,prjname:prjname}});
	}
});
var itemGrid = new dhc.herp.Grid({
		    title: '��Ŀ֧����������',
		    iconCls: 'list',
		    region : 'north',
		    url: 'herp.srm.PrjReimbursemenmainexe.csp',
			fields : [{
						id : 'rowid',
						header : '��ĿID',
						dataIndex : 'rowid',
						editable:false,
						hidden : true
					},{
						id : 'year',
						header : '�������',
						editable:false,
						width : 60,
						dataIndex : 'year'

					},{
						id : 'code',
						header : '��Ŀ���',
						width : 100,
						editable:false,
						dataIndex : 'code'

					},{
						id : 'name',
						header : '��Ŀ����',
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
						header : '������',
						width : 60,
						editable:false,
						dataIndex : 'username'

					}, {
						id : 'FundTotal',
						header : '�����ܶ�(��Ԫ)',
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
						header : '��;����(��Ԫ)',
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
						header : '�Ѿ�ִ��(��Ԫ)',
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
						header : '���ƽ���(��Ԫ)',
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
						header : '��λ�ʽ�(��Ԫ)',
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
						header : '��λ�ʽ����(��Ԫ)',
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
						header : '��׼����(��Ԫ)',
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
						header : 'Ԥ�����',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "����Ԥ��") {
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
						tbar:['','�������','',yearCombo,'','��Ŀ����','',projnameField,'-',findButton],
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    itemGrid.btnAddHide();  //�������Ӱ�ť
   	itemGrid.btnSaveHide();  //���ر��水ť
    itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnDeleteHide(); //����ɾ����ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť


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


////////////// ������Ŀ���� ����gird�ĵ�Ԫ���¼� /////////////////
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



