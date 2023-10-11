var itemGridUrl = '../csp/herp.acct.acctsubjvindicmainexe.csp';

//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'SubjCode',
		'SubjName',
		'SubjNature',
                'SubjType',
                'SubjLevel',
                'BalanceDirc',
                'SubjNameAll',
                'SuperCode',
                'Spell',
                'SelfCode',
                'IsLast',
                'Iscrash',
                'Unit',
                'ischeck'
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

var sysStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','预算编制'],['1','项目支出']]
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



//输入框
var acctsubjField = new Ext.form.TextField({
	id: 'acctsubjField ',
	fieldLabel: '',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	//store: yearDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'acctsubjField ',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询', 
        tooltip:'查询',        
        iconCls:'find',
	handler:function(){	
	var acctsubj=acctsubjField.getValue();
	itemGridDs.load(({params:{start:0,limit:25,acctsubj:acctsubj}}));
	
	}
});



//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 150,		  
        hidden: true,
        sortable: true
	    
    },{ 
        id:'SubjCode',
    	header: '科目编码',
        dataIndex: 'SubjCode',
        width: 80,		  
        sortable: true
    },{
        id:'SubjName',
    	header: '科目名称',
        dataIndex: 'SubjName',
        width: 150,
        sortable: true
    },{           
         id:'SubjNature',
         header: '科目性质',
         width:100,
         hidden: true,
         dataIndex: 'SubjNature',
         type: syscomb
    
    },{           
         id:'SubjType',
         header: '科目类别',
   ///   allowBlank: false,
         width:80,
         dataIndex: 'SubjType',
         type: syscomb
    
    },{           
         id:'SubjLevel',
         header: '科目级别',
         width:60,
         align:'right',
         hidden: true,
         dataIndex: 'SubjLevel',
         type: syscomb
    
    },{           
         id:'BalanceDirc',
         header: '余额方向',
         allowBlank: true,
         width:60,
         dataIndex: 'BalanceDirc',
         type: syscomb
    
    },{           
         id:'SubjNameAll',
         header: '科目全称',
         allowBlank: true,
         width:170,
         dataIndex: 'SubjNameAll',
         type: syscomb
    
    },{           
         id:'SuperCode',
         header: '上级编码',
         allowBlank: true,
         width:80,
         dataIndex: 'SuperCode',
         type: syscomb
    
    },{           
         id:'Spell',
         header: '拼音码',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Spell',
         type: syscomb
    
    },{           
         id:'SelfCode',
         header: '自定义编码',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'SelfCode',
         type: syscomb
    
    },{           
         id:'IsLast',
         header: '是否末级',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'IsLast',
         type: syscomb
    
    },{           
         id:'Iscrash',
         header: '现金标志',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Iscrash',
         type: syscomb
    
    },{           
         id:'Unit',
         header: '计量单位',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Unit',
         type: syscomb
    
    },{           
         id:'ischeck',
         header: '',
         hidden: true,
         width:40,
         dataIndex: 'ischeck',
         type: syscomb
    
    }
    
]);



//初始化默认排序功能
itemGridCm.defaultSortable = true;


//添加按钮
var addButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
         
            addFun();
      
	}	
});





//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'option',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid     = rowObj[0].get("rowid");
                        var SubjCode  = rowObj[0].get("SubjCode");
                        var SubjName  = rowObj[0].get("SubjName");
                        var SubjNature= rowObj[0].get("SubjNature");
                        var SubjType  = rowObj[0].get("SubjType");
                        var SubjNameAll= rowObj[0].get("SubjNameAll");
    
                        var SuperCode = rowObj[0].get("SuperCode");
                        var Spell     = rowObj[0].get("Spell");
                        var SelfCode  = rowObj[0].get("SelfCode");
                        var IsLast    = rowObj[0].get("IsLast");
                        var Iscrash   = rowObj[0].get("Iscrash");
                        var Unit      = rowObj[0].get("Unit");
    
                        var SubjLevel  = rowObj[0].get("SubjLevel");
                        var BalanceDirc= rowObj[0].get("BalanceDirc");
                        
                        var ischeck    = rowObj[0].get("ischeck");
                        
                        editFun(rowid,SubjCode,SubjName,SubjNature,SubjType,SubjLevel,BalanceDirc,SubjNameAll,SuperCode,Spell,SelfCode,IsLast,Iscrash,Unit,ischeck);
		}
	
	       	       
	}

});


///删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.acct.acctsubjvindicmainexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});


//表格
var itemGrid = new Ext.grid.GridPanel({
    title: '会计科目维护',
    region: 'center',
    layout:'fit',
    width:800,
    readerModel:'local',
    url: 'herp.acct.acctsubjvindicmainexe.csp',
    atLoad : true, // 是否自动刷新
    store: itemGridDs,
    cm: itemGridCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({singleSelect:false}),
    loadMask: true,
    tbar:[addButton,'-',editButton,'-',delButton,'-',acctsubjField,'-',findButton],
    bbar:itemGridPagingToolbar
});
//itemGridDs.load({params:{start:0, limit:25}});

  itemGridDs.load({	
	params:{start:0, limit:itemGridPagingToolbar.pageSize},
        callback:function(record,options,success ){
	///itemGrid.fireEvent('rowclick',this,0);
	}
});
	
itemGrid.on('rowclick',function(grid,rowIndex,e){
	
	//var object = itemGrid.getSelectionModel().getSelections();
	//var rowid = object[0].get("rowid");
	
	var selectedRow = itemGridDs.data.items[rowIndex];
	var rowids = selectedRow.data['rowid'];
        var ischeck = selectedRow.data['ischeck'];
        ///alert(rowids);
        if(ischeck==1)
        {
	detailGrid.load({params:{start:0,limit:12,AcctSubjID:rowids}});
        } 
	
});


