var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var BudgIsNotBaseDataUrl = '../csp/herp.budg.budgisnotbasedataexe.csp';

tmpInv="";
//年度
var yearDs  = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=year',method:'POST'});
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:145,
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
	            BIDnameDs.removeAll();     
				BIDnameField.setValue('');
				BIDnameDs.proxy = new Ext.data.HttpProxy({url:BudgIsNotBaseDataUrl+'?action=bidnamelist'+'&year='+combo.value,method:'POST'})  
				BIDnameDs.load({params:{start:0,limit:10}});      					
			}
	}
});


//预算项分类
var BITnameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

BITnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=itemtype&flag=1',method:'POST'});
		});

var BITnameField = new Ext.form.ComboBox({
	id: 'BITnameField',
	fieldLabel: '预算项分类',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BITnameDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项分类...',
	name: 'BITnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});


//科室名称
var deptnmDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

deptnmDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('deptnmField').getRawValue()),method:'POST'})
});
var deptnmField = new Ext.form.ComboBox({
	id: 'deptnmField',
	fieldLabel: '科室名称',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: deptnmDs,
	valueField: 'name',
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



//预算项名称
var BIDnameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['bidcode','name'])
});

BIDnameDs.on('beforeload', function(ds, o){
	var year=yearField.getValue();
	if(year==""){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgIsNotBaseDataUrl+'?action=bidnamelist'+'&year='+year,method:'POST'})
		});

var BIDnameField = new Ext.form.ComboBox({
	id: 'BIDnameField',
	fieldLabel: '预算项名称',
	width:120,
	listWidth : 245,
	allowBlank: false,
	store: BIDnameDs,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项名称...',
	name: 'BIDnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
	/*listeners:{
		 "select":function(combo,record,index){
		 	itemGrid.load({
							params : {
								start: 0,
								limit: 25,
								year:yearField.getValue()
							}
			});    
		}
	}*/
});

BIDnameField.on('select',function(combo,record, index){
	var rcs=itemGrid.getSelectionModel().getSelected();
	rcs.set('BIDName',record.get('name'));
	findFun(record.data.name,itemGrid);
	//tmpInv=combo.getValue();
});


////剔除金额
//var bibbrejectmoneyField = new Ext.form.NumberField({
//	id: 'bibbrejectmoneyField',
//	//fieldLabel: '预算项编码',
//	width:215,
//	listWidth : 215,
//	name: 'bibbrejectmoneyField',
//	minChars: 1,
//	pageSize: 10,
//	selectOnFocus:true,
//	forceSelection:'true',
//	editable:true
//});

//剔除金额
var bibbrejectmoneyField = new Ext.form.TextField({
	id: 'bibbrejectmoneyField',
	//fieldLabel: '预算项编码',
	width:215,
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",

	name: 'bibbrejectmoneyField',
	editable:true
});


//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();
	
	var BITName=BITnameField.getValue();
	
	var DeptNM=deptnmField.getValue();
	
	itemGrid.load(({params:{start:0, limit:25,Year:Year,BITName:BITName,DeptNM:DeptNM}}));
	
	}
});
	
var itemGrid = new dhc.herp.Grid({
    title: '收支异常数据调整',
    width: 400,
    //edit:false,                   //是否可编辑
    //readerModel:'local',
    region: 'center',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgisnotbasedataexe.csp',
	
	tbar:['年度:',yearField,'-','预算项分类:',BITnameField,'-','科室名称：',deptnmField,'-',findButton],
	
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

	    },{
        id:'bfryear',
        header: '年度',
        dataIndex: 'bfryear',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'bfrmonth',
        header: '月份',
        dataIndex: 'bfrmonth',
        width:75,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bdeptname',
        header: '科室名称',
		//tip:true,
		allowBlank: true,
		width:220,
		editable:false,
        dataIndex: 'bdeptname'
	
    }, {
        id:'bfritemcode',
        header: '预算项编码',
        width:150,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        dataIndex: 'bfritemcode'
		
    }, {
        id:'bidname',
        header: '预算项名称',
        width:250,
		//tip:true,
		allowBlank: false,
		editable:true,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store){
    	cellmeta.css="cellColor3";
    },
        dataIndex: 'bidname',
        type:BIDnameField
		
    }, {
        id:'bibbrejectmoney',
        header: '剔除金额',
        align:'right',
        width:120,
		//tip:true,
		allowBlank: true,
		editable:true,
        dataIndex: 'bibbrejectmoney'
        	,
//        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store){
//    	cellmeta.css="cellColor3";
//    },
        type:bibbrejectmoneyField
	
    }, {
        id:'bibbrejectreason',
        header: '剔除原因',
        width:250,
		//tip:true,
		allowBlank: true,
		editable:true,
//		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store){
//    	cellmeta.css="cellColor3";
//    },
        dataIndex: 'bibbrejectreason'
		
    },{
    	id:'bibbrealdatadr',
        header: '科室执行数据ID',
        width:100,
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bibbrealdatadr',
        hidden: true
    }
	]
//	,
//	viewConfig : {
//		forceFit : true
//	}

});

//itemGrid.btnAddHide();  //隐藏增加按钮
//itemGrid.btnSaveHide();  //隐藏保存按钮
itemGrid.btnResetHide();  //隐藏重置按钮
//itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮
