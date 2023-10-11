var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var BudgFactYearDeptUrl = '../csp/herp.budg.budgfactyeardeptexe.csp';
//年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=year',method:'POST'
	})	
});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:65,
	listWidth : 285,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择...',
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
				//nameDs.proxy = new Ext.data.HttpProxy({url:BudgFactYearDeptUrl+'?action=bsmnamelist&year='+combo.value,method:'POST'})  
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
		Ext.Msg.show({title:'注意',width:200,msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		ds.proxy=new Ext.data.HttpProxy({url:commonboxUrl+'?action=bsm&flag=2',method:'POST'})
		return ;
	}else{
		ds.proxy=new Ext.data.HttpProxy({url:commonboxUrl+'?action=bsm&flag=2&year='+year,method:'POST'})
	}
});

var nameField = new Ext.form.ComboBox({
	id: 'nameField',
	fieldLabel: '预算编制方案',
	width:145,
	listWidth : 285,
	//allowBlank: false,
	store: nameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择预算编制方案...',
	name: 'nameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            deptnmDs.removeAll();     
				deptnmField.setValue('');
				//deptnmDs.proxy = new Ext.data.HttpProxy({url:BudgFactYearDeptUrl+'?action=deptnmlist&Schemdr='+combo.value,method:'POST'})  
				deptnmDs.load({params:{start:0,limit:10,Schemdr:combo.value}});      					
			}
	}
});

//科室名称
var deptnmDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptnmDs.on('beforeload', function(ds, o){
    var Schemdr=nameField.getValue();	
	if(Schemdr==""){
		Ext.Msg.show({title:'注意',width:200,msg:'请先选择预算方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		ds.proxy=new Ext.data.HttpProxy({
			url:commonboxUrl+'?action=dept&flag=1&Schemdr=',method:'POST'})
		return ;
	}else{
		ds.proxy=new Ext.data.HttpProxy({
			url:commonboxUrl+'?action=dept&flag=1&Schemdr='+Schemdr,method:'POST'})
	}
});
var deptnmField = new Ext.form.ComboBox({
	id: 'deptnmField',
	fieldLabel: '科室名称',
	width:145,
	listWidth : 285,
	//allowBlank: false,
	store: deptnmDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptnmField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

///////////////////////预算项类别///////////////////////////////////////////////////////////
var ItemTypeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name']
			)
});

ItemTypeDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
					url : commonboxUrl+'?action=itemtype&flag=1',
					method : 'POST'
				});
});

var ItemTyCombo = new Ext.form.ComboBox({
	fieldLabel : '科目类别',
	store : ItemTypeDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '请选择...',
	width : 80,
	listWidth : 285,
	pageSize : 10,
	minChars : 1,
	columnWidth : .13,
	selectOnFocus : true
});

//预算项编码
var codeField = new Ext.form.TextField({
	id: 'codeField',
	fieldLabel: '预算项名称',
	width:145,
	listWidth : 285,
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
var bfincreaserateField = new Ext.form.NumberField({
	id: 'bfincreaserateField',
	name: 'bfincreaserateField',
	//fieldLabel: '增长比例',
	//regex : /^(-?\d+)(\.\d+)?$/,
	//regexText : "只能输入数字",
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
    iconCls:'find',
	handler:function(){
	
		var year=yearField.getValue();
		
		var Schemdr=nameField.getValue();
		
		var Code=codeField.getValue();
		
		var Deptdr=deptnmField.getValue();
		
		var itemty=ItemTyCombo.getValue();
		
		if(year==""){
			Ext.Msg.show({title:'注意',width:200,msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(Schemdr==""){
			Ext.Msg.show({title:'注意',width:200,msg:'请选择预算编制方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else if(Deptdr==""){
			Ext.Msg.show({title:'注意',width:200,msg:'请选择科室名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		itemGrid.load(({params:{start:0, limit:25,year:year,Schemdr:Schemdr,Deptdr:Deptdr,Code:Code,itemty:itemty}}));
	
	}
});


var editButton = new Ext.Toolbar.Button({
	text: '批量(选中记录)',
    tooltip:'批量处理选中的记录',        
    iconCls:'option',
	handler:function(){
		editFun();
	}
});

var setButton = new Ext.Toolbar.Button({
	text: '批量(科目类别)',
    tooltip:'按科目类别',        
    iconCls:'option',
	handler:function(){
		
		var Year=yearField.getValue();	
		var Schemid=nameField.getValue();
		var Deptdr=deptnmField.getValue();
		var ItemTy=ItemTyCombo.getValue();
		
		if(Year == ""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(Schemid == ""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择预算编制方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(Deptdr==""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择科室名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(ItemTy==""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择科目类别!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
	      	var data=Year+"^"+Schemid+"^"+Deptdr+"^"+ItemTy
		}
      			
		Ext.MessageBox.confirm('提示', '确定按预算项类别批量设置比例?', handler);
		function handler(id) {

			if (id == 'yes') {

				setFun(data);
			}
		}

	}
});

var upSumButton = new Ext.Toolbar.Button({
	text: '汇总到上级',
    tooltip:'计算上级科目值',        
    iconCls:'option',
	handler:function(){
		var year=yearField.getValue();
		var schemname=nameField.getRawValue();
		var schemdr=nameField.getValue();
		var deptname=deptnmField.getRawValue();
		var deptdr=deptnmField.getValue();
		
		if(year==""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请先选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(schemdr == ""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择预算编制方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else if(deptdr==""){
			Ext.Msg.show({title:'注意',width:'200',msg:'请选择科室名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var msg='确定汇总"'+'年:'+year+',方案:'+schemname+',科室:'+deptname+'"的上级科目预算值?'			
			var data=year+"^"+schemdr+"^"+deptdr
		}		
		Ext.MessageBox.confirm('提示', msg, handler);
		function handler(id) {
				if (id == 'yes') {
					var surl =BudgFactYearDeptUrl+'?action=setsupvalue'+'&data='+data;	
					itemGrid.saveurl(surl)
				}
		}
	}
});


var searchPanel = new Ext.form.FormPanel({
	id : 'searchPanel',
	width : 1000,
	labelWidth : 60,
	labelAlign : 'left',
	frame : true,
	bodyStyle : 'padding:5px;',
	layout : "form",
	items : [{
		xtype: 'panel',
		layout:"column",
		items: [{
			xtype:'displayfield',
			value:'<center><p style="font-weight:bold;font-size:180%">'+'科室年度预算增量比例维护'+'</p></center>',
			columnWidth:1,
			height:'50'
		}]
	},{
		layout:'column',
		items:[{
			columnWidth:.1,
			layout:'form',
			labelWidth : 33,
			items:yearField
			},{
			layout:'form',
			columnWidth:.01
			},{
			columnWidth:.21,
			layout:'form',
			labelWidth : 80,
			items:nameField
			},{
			layout:'form',
			columnWidth:.01
			},{
			columnWidth:.19,
			layout:'form',
			items:deptnmField
			},{
			layout:'form',
			columnWidth:.01
			},{
			columnWidth:.14,
			layout:'form',
			items:ItemTyCombo
			},{
			layout:'form',
			columnWidth:.01
			},{
			columnWidth:.2,
			layout:'form',
			labelWidth : 70,
			items:codeField						  
			},{
			layout:'form',
			columnWidth:.01
			},{
			columnWidth:.05,
			layout:'form',
			items:findButton						  
			}
		]
	}]
});

var itemGrid = new dhc.herp.Grid({
    //title: '科室年度预算增量比例维护',
    width: 400,
    region: 'center',
    url: 'herp.budg.budgfactyeardeptexe.csp',
	
		listeners : {
            'cellclick' : function(grid, rowIndex, columnIndex, e) {
                var record = grid.getStore().getAt(rowIndex);
                  // 根据条件设置单元格点击编辑是否可用  1是末级0不是
                  //alert(columnIndex);
                 //alert(record.get('IsLast'))
                    if ((record.get('IsLast') == '0')&& (columnIndex == 8)) {
                         return false;
                    } else {return true;}
            },
            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				// 预算项目公式编辑
				if ((record.get('IsLast') == '0')&& (columnIndex == 8)) {
				
					return false;
				} else {
					return true;
				}
			}
        },	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        dataIndex: 'rowid',
        hidden: true
    },{
	    id : 'CompName',
	    header : '医疗单位',
        width : 90,
	    editable : false,
	    hidden: true,
        dataIndex : 'CompName'

	},
    {
        id:'bfdeptname',
        header: '科室名称',
        width:200,
        dataIndex: 'bfdeptname',
		editable:false,
		hidden: false
    },
    {
        id:'bfyear',
        header: '会计年度',
        width:90,
        dataIndex: 'bfyear',
		editable:false,
		hidden: false
    },{
        id:'bfitemcode',
        header: '科目编码',
        width:150,
        dataIndex: 'bfitemcode',
		editable:false,
		hidden: false
    }, {
        id:'bfitemcodename',
        header: '科目名称',
        width:250,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfitemcodename'
	
    }, {
        id:'bfrealvaluelast',
        header: '上年执行',
        width:120,
		//tip:true,
		align:'right',
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
		editable:true,
//		renderer : function(v, p, r){
//        return '<span style="color:blue;cursor:hand"><u>'+v+'</u></span>';
//        },

        dataIndex: 'bfincreaserate',
        type:bfincreaserateField
	
    }, {
        id:'bfplanvalue',
        header: '本年计划',
        width:120,
		//tip:true,
        align: 'right',
		allowBlank: true,
		editable:false,
        dataIndex: 'bfplanvalue'
		
    }, {
        id:'bsdcalflag',
        header: '计算方法',
        width:120,
		editable:false,
		hidden:true,
		update:true,
        dataIndex: 'bsdcalflag'
		
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

itemGrid.addButton(editButton)
itemGrid.addButton(setButton)
itemGrid.addButton(upSumButton)

itemGrid.btnAddHide();  //隐藏增加按钮
//itemGrid.btnSaveHide();  //隐藏保存按钮
itemGrid.btnResetHide();  //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮



