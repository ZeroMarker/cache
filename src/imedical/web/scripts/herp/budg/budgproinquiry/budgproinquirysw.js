
var BudgProInquirySWUrl = '../csp/herp.budg.budgproinquiryswexe.csp';

var UserID = session['LOGON.USERID'];

var itemSW = new dhc.herp.Gridwolf({
    title: '项目预算编制记录',
    region : 'center',
    
    layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	viewConfig : {
		forceFit : true
	},		
	loadMask: true,
	atLoad: true,
	height : 250,
	trackMouseOver: true,
	stripeRows: true,

    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgproinquiryswexe.csp',
    
    tbar:[],
    fields: [
//       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'projcode',
        header: '项目编码',
        dataIndex: 'projcode',
        width:100,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'projname',
        header: '项目名称',
        dataIndex: 'projname',
        width:250,
        allowBlank: true,
		editable:false,
		hidden: false
    }
	]
});

itemSW.load({	
	params:{start:0, limit:12},

	callback:function(record,options,success ){
		//alert("a")
	itemSE.fireEvent('cellclick',this,0);
	}
});

itemSW.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var id='';
    //alert(rowIndex);
	var selectedRow = itemSW.getSelectionModel().getSelections();
	id=selectedRow[0].data['rowid'];
	//alert(stepno);
	itemSE.load({params:{start:0, limit:12,ID:id}});
				
});







