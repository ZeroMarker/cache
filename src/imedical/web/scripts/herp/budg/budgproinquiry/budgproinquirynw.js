
var BudgProInquiryNWUrl = '../csp/herp.budg.budgproinquirynwexe.csp';
var UserID = session['LOGON.USERID'];

//立项年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProInquiryNWUrl+'?action=yearlist',method:'POST'});
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '立项年度',
	width:100,
	listWidth : 200,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();

	itemNW.load(({params:{start:0, limit:25,Year:Year,UserID:UserID}}));
	
	}
});
var itemNW = new dhc.herp.Grid({
    title: '项目预算查询',
    //width: 400,
    region : 'north',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgproinquirynwexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,
	
	tbar:['立项年度:',yearField,'-',searchButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
	     id : 'CompName',
	       header : '医疗单位',
                        width : 130,
	      editable : false,
                     dataIndex : 'CompName'

	    },{
        id:'projyear',
        header: '立项年度',
        dataIndex: 'projyear',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: true
    },{ 
        id:'projcode',
        header: '项目编码',
        dataIndex: 'projcode',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'projname',
        header: '项目名称',
        width:150,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
    	    cellmeta.css="cellColor3";
        	var rid = record.data['rowid'];  
                if ( rid!=="") {
                	cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
                    return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
              }else{
					return '<span style="color:black;cursor:hand">'+value+'</span>';
				}

        	},
        dataIndex: 'projname'
		
    }, {
        id:'projdutydr',
        header: '项目负责人(号)',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'projdutydr',	
        hidden: true
    },{
        id:'projdeptdr',
        header: '项目责任科室(号)',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'projdeptdr',	
        hidden: true
    }, {
        id:'username',
        header: '责任人',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'username'
    }, {
        id:'deptname',
        header: '责任科室',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'deptname'
    }, {
        id:'bdeptname',
        header: '预算科室',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bdeptname'
    },  {
        id:'projfundtotal',
        header: '预算总金额',
        width:120,
        align:'right',
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'projfundtotal'
		
    },{
    	id:'projfundown',
        header: '自筹金额',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfundown'
    },{
    	id:'projfundgov',
        header: '政府支付',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfundgov'
    },{ 
        id:'brand1',
        header: '推荐品牌1',
        dataIndex: 'brand1',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'spec1',
        header: '规格型号1',
        dataIndex: 'spec1',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'brand2',
        header: '推荐品牌2',
        dataIndex: 'brand2',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'spec2',
        header: '规格型号2',
        dataIndex: 'spec2',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'brand3',
        header: '推荐品牌3',
        dataIndex: 'brand3',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'spec3',
        header: '规格型号3',
        dataIndex: 'spec3',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    }
	],
	
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
	viewConfig : {
		forceFit : true
	},
	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});
itemNW.load(({params:{start:0, limit:25, UserID:UserID}}));

itemNW.btnAddHide();  //隐藏增加按钮
itemNW.btnSaveHide();  //隐藏保存按钮
itemNW.btnResetHide();  //隐藏重置按钮
itemNW.btnDeleteHide(); //隐藏删除按钮
itemNW.btnPrintHide();  //隐藏打印按钮

itemNW.load({	
	params:{start:0, limit:12},

	callback:function(record,options,success ){
		//alert("a")
	itemNE.fireEvent('cellclick',this,0);
	itemSW.fireEvent('cellclick',this,0);
	}
});

itemNW.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var id='';
    //alert(rowIndex);
	var selectedRow = itemNW.getSelectionModel().getSelections();
	id=selectedRow[0].data['rowid'];
	//alert(id);
	itemNE.load({params:{start:0, limit:12,ID:id}});
	itemSW.load({params:{start:0, limit:12,ID:id}});
				
});

//单击gird的单元格事件
itemNW.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 6) {
		//alert(columnIndex);
		var records = itemNW.getSelectionModel().getSelections();
		var childid = records[0].get("rowid");
		//alert(childid);

		// 维护数据页面
		ChildFun(childid);
		//connectFun(offshootID);
		
	}
});



