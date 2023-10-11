
var sysStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['2','预算编制'],['1','项目支出'],['3','一般支出']]
});
var syscomb = new Ext.form.ComboBox({
	id: 'sysno',
	fieldLabel: '应用系统',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: sysStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});

var itemGrid = new dhc.herp.Grid({
        title: '审批流程1',
        width: 400,
        //readerModel:'local',
        region:'center',
        url: 'herp.budg.budgcheckflowmainexe.csp',
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        }, {
            id:'code',
            header: '审批流编号',
			allowBlank: false,
			width:100,
			edit:true,
            dataIndex: 'code'
        },{
           id:'name',
            header: '审批流名称',
			allowBlank: false,
			width:100,
			edit:true,
            dataIndex: 'name'
        },{
            id:'sysno',
            header: '审批流应用系统',
			allowBlank: false,
			width:100,
			edit:true,
            dataIndex: 'sysno',
            type: syscomb
        }],
        //atLoad : true, // 是否自动刷新
        trackMouseOver: true,
		stripeRows: true,
		//loadMask: true,
		viewConfig: {forceFit:true}
    
   });
	/*itemGrid.on('afteredit',function(){
itemGrid.save();
//formPanel.load({params:{start:0, limit:25}});
itemGrid.load();
});*/
	//itemGrid.load();
	itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
	
//	var tmpSelectedScheme='';

  itemGrid.load({	
	params:{start:0, limit:12},
    callback:function(record,options,success ){
		//alert("a")
	detailGrid.fireEvent('rowclick',this,0);
	}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	
	var object = itemGrid.getSelectionModel().getSelections();

	var rowid = object[0].get("rowid");

	detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});

	
});
	
	
	
	
	
	
