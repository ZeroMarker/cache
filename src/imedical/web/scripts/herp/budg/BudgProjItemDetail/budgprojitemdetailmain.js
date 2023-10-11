var yearDs  = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:'herp.budg.budgprojitemdetailexe.csp?action=Getyear',method:'POST'})
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
	            upperDs.removeAll();     
				upperField.setValue('');
				upperDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgprojitemdetailexe.csp'+'?action=GetUpper&year='+combo.value,method:'POST'})  
				upperDs.load({params:{start:0,limit:10,year:combo.value}});      					
			}
	   }	
});

var year2Ds  = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','year'])
});

year2Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:'herp.budg.budgprojitemdetailexe.csp?action=Getyear',method:'POST'})
		});

var yearField2  = new Ext.form.ComboBox({
	id: 'yearField2',
	fieldLabel: '年度',
	width:120,
	listWidth : 245,
	//allowBlank: false,
	store: year2Ds,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField2',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            upper2Ds.removeAll();     
				upperField2.setValue('');
				upper2Ds.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgprojitemdetailexe.csp'+'?action=GetUpper&year='+combo.value,method:'POST'})  
				upper2Ds.load({params:{start:0,limit:10,year:combo.value}});      					
			}
	   }	
});

var upperDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

upperDs.on('beforeload', function(ds, o){
	var year=yearField.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	//ds.proxy=new Ext.data.HttpProxy({
	//url:'herp.budg.budgprojitemdetailexe.csp'+'?action=GetUpper&str='+encodeURIComponent(Ext.getCmp('upperField').getRawValue()),method:'POST'});
});

var upperField = new Ext.form.ComboBox({
	id: 'upperField',
	fieldLabel: '上级项目',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: upperDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择上级...',
	name: 'upperField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var upper2Ds = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

upper2Ds.on('beforeload', function(ds, o){
	var year=yearField2.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	//ds.proxy=new Ext.data.HttpProxy({
	//url:'herp.budg.budgprojitemdetailexe.csp'+'?action=GetUpper&str='+encodeURIComponent(Ext.getCmp('upperField2').getRawValue()),method:'POST'});
});

var upperField2 = new Ext.form.ComboBox({
	id: 'upperField2',
	fieldLabel: '上级项目',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: upper2Ds,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择上级...',
	name: 'upperField2',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//名称或编码%
var ProjitemField = new Ext.form.TextField({
	id: 'ProjitemField',
	fieldLabel: '项目明细名称',
	width:215,
	//regex : /^(-?\d+)(\.\d+)?$/,
	//regexText : "只能输入数字",
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
    iconCls:'add',
	handler:function(){
	
	var year=yearField.getValue();
	var upper=upperField.getValue();
	var strs=ProjitemField.getValue();
	
	itemGrid.load(({params:{start:0, limit:25,year:year,strs:strs,upper:upper}}));	
	}
});


var itemGrid = new dhc.herp.Grid({
        title: '项目科目明细维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'herp.budg.budgprojitemdetailexe.csp',
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                    if ((record.get('rowid') !=="")&&((columnIndex == 2)||(columnIndex == 3)||(columnIndex == 4))) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('rowid') !=="")&&((columnIndex == 2)||(columnIndex == 3)||(columnIndex == 4))) {
		                       return false;
						} else {
							return true;
						}
					}
        },	
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        }, {
            id:'Year',
            header: '年度',
			allowBlank: false,
			width:80,
			edit:true,
            dataIndex: 'Year',
            type:yearField2
        }, {
            id:'Code',
            header: '明细编码',
			allowBlank: false,
			width:120,
			edit:true,
            dataIndex: 'Code'
        },{
           id:'Name',
            header: '明细名称',
			allowBlank: false,
			width:200,
            dataIndex: 'Name'
        },{
           id:'NameAll',
            header: '明细全称',
			allowBlank: false,
			width:200,
            dataIndex: 'NameAll'
        },{
            id:'Spell',
            header: '明细拼音码',
			calunit:true,
			allowBlank: false,
			width:180,
            dataIndex: 'Spell'
        },{
            id:'SuperCode',
            header: '明细所属项',
			calunit:true,
			allowBlank: false,
			width:200,
            dataIndex: 'SuperCode',
			type:upperField2
        }],
        tbar:['年度:',yearField,'-','所属科目:',upperField,'-','明细项名称:',ProjitemField,findButton]
    
    });

	itemGrid.btnResetHide();  //隐藏重置按钮
	itemGrid.btnPrintHide();  //隐藏打印按钮
