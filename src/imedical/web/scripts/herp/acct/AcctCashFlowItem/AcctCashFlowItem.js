//var userdr = session['LOGON.USERID'];
var acctbookid=IsExistAcctBook();


var itemGridUrl = '../csp/herp.acct.acctcashflowitemmainexe.csp';
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';

//输入框模糊查询
var acctcashitemField = new Ext.form.TextField({
	id: 'acctcashitemField ',
	fieldLabel: '',
	width:200,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'名称/ 编码/ 拼音码模糊查询...',
	name: 'acctcashitemField ',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'+'&acctbookid='+acctbookid});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'ItemCode',
		'ItemName',
		'supers',
                'Cilevel',
                'isLast',
                'isStop',
                'cfdirection',
                'spell',
                'acctbookid' 
	]),
    remoteSort: true
});
itemGridDs.on('beforeload',function(store,op){
	var acctcashitem=acctcashitemField.getValue();
	//alert(acctcashitem);
	 itemGridDs.baseParams = {
                                acctcashitem: acctcashitem, 
								acctbookid:acctbookid
                        }

});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	plugins : new dhc.herp.PageSizePlugin(),
	atLoad : false,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
});

//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');


//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询', 
    tooltip:'查询',        
    iconCls:'find',
	width:80,
	height:25,
	handler:function(){	
	var acctcashitem=acctcashitemField.getValue();
	 var limit=Ext.getCmp("PageSizePlugin").getValue();
	if(limit==""||limit==0){limit=25};
	//alert(Ext.getCmp("ext-comp-1001").getValue());
	itemGridDs.load(({params:{start:0,limit:limit,acctcashitem:acctcashitem,acctbookid:acctbookid}}));
	
	}
});

//添加按钮
var addButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){        
            funadd();
	}	
});

//修改按钮
var editButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip:'修改',        
    iconCls:'edit',
	handler:function(){ 
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }else if (len==1){
			for(var i = 0; i < len; i++){
			  funedit(); 
			  }
			
			}else {Ext.Msg.show({title:'注意',msg:'选择需要修改的数据过多! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;}   
	}	
});

//删除按钮
var delButton  = new Ext.Toolbar.Button({
    text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){     
            fundel();
	}	
});

//导入按钮 
var uploadButton = new Ext.Toolbar.Button({
	text: '导入', 
    tooltip:'导入',        
    iconCls:'in',
	handler:function(){	
	doimport();
	
	}
});

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
		id: 'rowid',
		header: '<div style="text-align:center">rowid</div>',
    	dataIndex: 'rowid',
    	width: 150,		  
   		hidden: true,
    	sortable: true
	    
    },{ 
        id:'ItemCode',
    	header: '<div style="text-align:center">项目编码</div>',
        dataIndex: 'ItemCode',
        width: 100,
        align:'left',	
        hidden: false,	  
        sortable: true
    },{
        id:'ItemName',
    	header: '<div style="text-align:center">项目名称</div>',
    	allowBlank: true,
        dataIndex: 'ItemName',
        width: 350,
        align:'left',
        hidden: false,
        sortable: true
    },{           
         id:'supers',
         header: '<div style="text-align:center">上级编码</div>',
         allowBlank: true,
         width:100,
         align:'left',
         hidden: false,
         dataIndex: 'supers'
    
    },{           
         id:'Cilevel',
         header: '<div style="text-align:center">项目级别</div>',
         allowBlank: true,
         width:100,
         align:'center',
         hidden: false,
         dataIndex: 'Cilevel'
    
    },{           
         id:'isStop',
         header: '<div style="text-align:center">是否停用</div>',
         allowBlank: true,
         hidden: false,
         width:100,
         align:'center',
         dataIndex: 'isStop'
    },{           
         id:'isLast',
         header: '<div style="text-align:center">是否末级</div>',
         allowBlank: true,
         hidden: false,
         width:100,
         align:'center',
         dataIndex: 'isLast'
    
    },{           
         id:'cfdirection',
         header: '<div style="text-align:center">流量方向</div>',
         allowBlank: true,
         width:100,
         align:'center',
         hidden: false,
         dataIndex: 'cfdirection'
    
    },{           
         id:'spell',
         header: '<div style="text-align:center">拼音码</div>',
         allowBlank: true,
         hidden: false,
         align:'center',
         width:150,
         dataIndex: 'spell'
    
    }
    
]);



//初始化默认排序功能
itemGridCm.defaultSortable = true;

var queryPanel = new Ext.form.FormPanel({
		title: '现金流量项目维护',
		iconCls:'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
            xtype : 'panel',
            layout : 'column',
            items : [
				acctcashitemField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},findButton]
        }]
});


//表格
var itemGrid = new Ext.grid.GridPanel({
    //title: '现金流量项目表维护',
	iconCls:'maintain',
    region: 'center',
    layout:'fit',
    width:800,
    readerModel:'local',
    url: 'herp.acct.acctcashflowitemmainexe.csp',
    atLoad : false, // 是否自动刷新
    store: itemGridDs,
    cm: itemGridCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    loadMask: true,
    tbar:[addButton,'-',editButton,'-',uploadButton],
    bbar:itemGridPagingToolbar
});

  itemGridDs.load({	
	params:{start:0, limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid},
    callback:function(record,options,success ){
	}
});
	

