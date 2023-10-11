var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var BudgFactYearUrl = '../csp/herp.budg.budgfactyearexe.csp';
//年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=year',method:'POST'})
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:120,
	listWidth : 245,
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
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            nameDs.removeAll();     
				nameField.setValue('');
				nameDs.proxy = new Ext.data.HttpProxy({url:commonboxUrl+'?action=bsm&flag=1&year='+combo.value,method:'POST'})  
				nameDs.load({params:{start:0,limit:10}});      					
			}
	   }	
});

//预算编制方案
var nameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

nameDs.on('beforeload', function(ds, o){
    var year=yearField.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	//ds.proxy=new Ext.data.HttpProxy({
	
		//url:BudgFactYearUrl+'?action=bsmnamelist',method:'POST'})
});

var nameField = new Ext.form.ComboBox({
	id: 'nameField',
	fieldLabel: '预算编制方案',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: nameDs,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择预算编制方案...',
	name: 'nameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//预算项编码
var codeField = new Ext.form.TextField({
	id: 'codeField',
	fieldLabel: '预算项名称',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	//store: yearDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//增长比例%
var bfincreaserateField = new Ext.form.TextField({
	id: 'bfincreaserateField',
	//fieldLabel: '预算项编码',
	width:145,
	listWidth : 245,
	name: 'bfincreaserateField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

// 是否末级
var IsLastStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});

var IsLastStoreField = new Ext.form.ComboBox({
	id: 'IsLastStoreField',
	fieldLabel: '是否末级',
	store: IsLastStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false
});

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();	
	var Name=nameField.getValue();	
	var Code=codeField.getValue();
	
	if(Name < 1){
		Ext.Msg.show({title:'注意',msg:'请选择预算编制方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
		
	//alert(InDeptSetsPagingToolbar.cursor);

	itemGrid.load(({params:{start:InDeptSetsPagingToolbar.cursor, limit:25,Year:Year,Name:Name,Code:Code}}));
	
	}
});


var editButton = new Ext.Toolbar.Button({
	text: '批量处理',
    tooltip:'批量处理',        
    iconCls:'add',
	handler:function(){
	editFun();
	}
});
var SETButton = new Ext.Toolbar.Button({
	text: '计算上级科目值',
    tooltip:'计算上级科目值',        
    iconCls:'add',
	handler:function(){
	var Year=yearField.getValue();
	var Name=nameField.getValue();	
	
	if((Year=="")||(Name=="")){
		Ext.Msg.show({title:'注意',msg:'请先选择年度和方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var surl = 'herp.budg.budgfactyearexe.csp?action=setsupvalue&Year='+Year+'&Schemdr='+Name;
	Ext.MessageBox.confirm('提示', '确定汇总本方案的所有科目吗?', handler);
		function handler(id) {

			if (id == 'yes') {

				itemGrid.saveurl(surl)
			}
		}
	
	
	}
});
	
var itemGrid = new dhc.herp.Grid({
    title: '全院预算科目增长预算比例维护',
    width: 400,
    //edit:false,                   //是否可编辑
    //readerModel:'local',
    region: 'center',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgfactyearexe.csp',
	
			listeners : {
            'cellclick' : function(grid, rowIndex, columnIndex, e) {
                var record = grid.getStore().getAt(rowIndex);
                  // 根据条件设置单元格点击编辑是否可用  1是末级0不是
                  //alert(columnIndex);
                 //alert(record.get('IsLast'))
                    if ((record.get('IsLast') == '0')&& (columnIndex == 7)) {
                         return false;
                     } else {return true;}
               },
            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				// 预算项目公式编辑
				if ((record.get('IsLast') == '0')&& (columnIndex == 7)) {
				
					return false;
				} else {
					return true;
				}
			}
            },
	
	tbar:['年度:',yearField,'-','预算编制方案:',nameField,'-','预算项名称',codeField,'-',findButton,SETButton],
	//tbar:months,
    //urlParam: {
    //   month: 1
    //},
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        hidden: true,
        dataIndex: 'rowid'
        
    },{
	     id : 'CompName',
	     header : '医疗单位',
         width : 90,
	     editable : false,
	     hidden: true,
         dataIndex : 'CompName'

	    },{
        id:'bfyear',
        header: '会计年度',
        dataIndex: 'bfyear',
        width:90,
		editable:false,
		hidden: false
    },{ 
        id:'bfitemcode',
        header: '科目编码',
        dataIndex: 'bfitemcode',
        width:150,
		editable:false,
		hidden: false
    }, {
        id:'bfitemcodename',
        header: '科目名称',
		//tip:true,
		allowBlank: false,
		width:250,
		editable:false,
        dataIndex: 'bfitemcodename'
	
    }, {
        id:'bfrealvaluelast',
        header: '上年执行',
        width:100,
		//tip:true,
		//allowBlank: false,
        editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
        id:'bfincreaserate',
        header: '增长比例%',
        width:100,
		//tip:true,
        align: 'right',
		allowBlank: true,
//		renderer : function(v, p, r){
//        return '<span style="color:blue;cursor:hand"><u>'+v+'</u></span>';
//        },
        dataIndex: 'bfincreaserate',
        type:bfincreaserateField
	
    }, {
        id:'bfplanvalue',
        header: '本年计划',
        width:120,
        align: 'right',
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'bfplanvalue'
		
    }, {
        id:'bsdcalflag',
        header: '计算方法',
        width:150,
		update:true,
		editable:false,
        dataIndex: 'bsdcalflag',
        hidden: true
		
    }, {
        id:'CalFlag',
        header: '计算方法',
        width:150,
		editable:false,
        dataIndex: 'CalFlag'
		
    }, {
        id:'IsLast',
        header: '是否末级',
        width:150,
		editable:false,
		hidden:true,
        dataIndex: 'IsLast',
        type:IsLastStoreField
		
    }
	],
	viewConfig : {
		forceFit : true
	}

});
var InDeptSetsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: itemGrid,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,
		//buttons: ['-',InDeptSetsFilterItem,'-',InDeptSetsSearchBox]
});


itemGrid.addButton(editButton)


itemGrid.btnAddHide();  //隐藏增加按钮
//itemGrid.btnSaveHide();  //隐藏保存按钮
itemGrid.btnResetHide();  //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮



