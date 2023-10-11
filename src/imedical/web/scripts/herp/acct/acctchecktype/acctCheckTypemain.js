var acctCheckTypeUrl = '../csp/herp.acct.acctchecktypeexe.csp';
/*
var bookDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
bookDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:acctCheckTypeUrl+'?action=getbookname'});
});

var BookField = new Ext.form.ComboBox({
	id: 'BookField',
	fieldLabel: '单位套帐',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: bookDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择单位套帐...',
	name: 'BookField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});
*/
var acctCheckTypeGrid = new dhc.herp.GridMain({
        title: '核算类别',
        loadMask: true,
        width: 400,
        region: 'center',
        url: 'herp.acct.acctchecktypeexe.csp',      
		    atLoad : true, // 是否自动刷新
        fields:[
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
            header: 'ID',
            id:'rowid',
            dataIndex: 'rowid',
			editable:false,
            hidden: true,
            print:false
        },{
            id:'typecode',
            header: '类别编码',
			allowBlank: false,
			editable:true,
			width:100,
            dataIndex: 'typecode'
        },{
            id:'typename',
            header: '类别名称',
			allowBlank: false,
			editable:true,
			width:100,
            dataIndex: 'typename'
        }, {
            id:'chkname',
            header: '简称',
			allowBlank: false,
			width:100,
			editable:true,
            dataIndex: 'chkname'
            
        }, {
            id:'fromtable',
            header: '数据源定义表',
			allowBlank: false,
			width:100,
			editable:true,
            dataIndex: 'fromtable'
          
        }],
        trackMouseOver: true,
		    stripeRows: true,
		    sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        //viewConfig : {
		 //    forceFit : true
		//   }
    });
	acctCheckTypeGrid.hhiddenButton(3);
	acctCheckTypeGrid.hiddenButton(4);
/* acctCheckTypeGrid.on('rowclick', function(g, rowIndex,e) {
	var id='';
	var selectedRow = acctCheckTypeGrid.getSelectionModel().getSelections();
	id=selectedRow[0].data['rowid'];
	acctCheckItemGrid.load({params:{start:0, limit:12,Rowid:id}});			
});
*/


 /** acctCheckTypeGrid.on(
	"rowclick",
	function(grid,rowIndex,e ){
		var rowObj = grid.getSelectionModel().getSelections();
		initemrowid = rowObj[0].get("rowid");
        var url='herp.acct.acctchecktypeexe.csp?action=listdetail&rowid='+initemrowid;
	});
///SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
**/



/**
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var id='';
	var paid='';
    //alert(rowIndex);
	var selectedRow = itemMain.getSelectionModel().getSelections();
	id=selectedRow[0].data['rowid'];
	paid=selectedRow[0].data['parowid'];
	//projcode=selectedRow[0].data['projcode'];
	//alert(paid);
	itemDetail.load({params:{start:0, limit:12,Rowid:id,ID:paid}});
				
});

**/
