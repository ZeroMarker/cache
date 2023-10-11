var userid = session['LOGON.USERID'];

///////////////////////// ���///////////////////////////////////
var projUrl = 'herp.budg.budgprojclaimapplymainexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '�������',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//��Ŀ����

var projnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


projnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojsubmitauditexe.csp'+'?action=projname',method:'POST'});
});

var projnameField = new Ext.form.ComboBox({
	id: 'projnameField',
	fieldLabel: '��Ŀ����',
	width:150,
	listWidth : 300,
	store: projnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	name: 'projnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//������///
var reponserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

reponserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getreponser',method:'POST'});
});

var reponserField = new Ext.form.ComboBox({
	id: 'reponserField',
	fieldLabel: '������',
	width:150,
	listWidth : 300,
	store: reponserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	name: 'reponserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var year = yearCombo.getValue();
	    var prjname = projnameField.getValue();
	    var reponser = reponserField.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,prjname:prjname,reponser:reponser}});
	}
});
var itemGrid = new dhc.herp.Grid({
		    title: '��Ŀ֧����������',
		    region : 'north',
		    url: 'herp.budg.budgprojclaimapplymainexe.csp',
			fields : [{
						header : '��ĿID',
						dataIndex : 'rowid',
						editable:false,
						hidden : true
					}, {
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
						width : 200,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'name'

					}, {
						id : 'deptdr',
						header : '���ο���ID',
						editable:false,
						width : 120,
						dataIndex : 'deptdr',
						hidden : true
					}, {
						id : 'deptname',
						header : '���ο���',
						editable:false,
						width : 120,
						dataIndex : 'deptname'

					},{
						id : 'username',
						header : '������',
						width : 80,
						editable:false,
						dataIndex : 'username'

					}, {
						id : 'FundTotal',
						header : 'Ԥ���ܶ�',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'FundTotal'
						
					},{
						id : 'ReqMoney',
						header : '�����ʽ�',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ReqMoney'

					},{
						id : 'ActPayWait',
						header : '��;����',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait'

					},{
						id : 'ActPayMoney',
						header : '�Ѿ�ִ��',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney'

					},{
						id : 'ReqExeMoney',
						header : '���ִ��',
						width : 120,
						align : 'right',
						editable:false,
						xtype:'numbercolumn',
						dataIndex : 'ReqExeMoney'

					},{
						id : 'budgco',
						header : 'Ԥ�����',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : 'Ԥ�����',
						width : 100,
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
						tbar:['�������:',yearCombo,'-','��Ŀ����:',projnameField,'-','������','-',reponserField,findButton],
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

	if (columnIndex == 4) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("name");
		var projDr		 = records[0].get("prowid");
		projnamefun(FundBillDR,projDr,Name);
	}
});


