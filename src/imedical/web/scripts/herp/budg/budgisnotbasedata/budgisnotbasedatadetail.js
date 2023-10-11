findFun = function(BIDNM,itemGrid) {
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//查询年月
var yearmonDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearmonDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=year&flag=1',method:'POST'});
});

var yearmonField = new Ext.form.ComboBox({
	id: 'yearmonField',
	fieldLabel: '年月',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearmonDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年月...',
	name: 'yearmonField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//科室名称
var deptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept',method:'POST'})
});
var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室名称',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: deptDs,
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

//获取科目名称

var descDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


descDs.on('beforeload', function(ds, o){
	var yearmonth=yearmonField.getValue();
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailexe.csp'+'?action=desc&Year='+yearmonth+'&str='+encodeURIComponent(Ext.getCmp('descField').getRawValue()),method:'POST'});
});

var descField = new Ext.form.ComboBox({
	id: 'descField',
	fieldLabel: '项目名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: descDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择项目名称...',
	name: 'descField',
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
	
	var Yearmonth=yearmonField.getValue();
	
	var deptdr=deptField.getValue();
	
	var itemcode=descField.getValue();
	
	NMFormPanel.load(({params:{start:0, limit:25,BIDNM:BIDNM,Yearmonth:Yearmonth,deptdr:deptdr,itemcode:itemcode}}));
	
	}
});


	var NMFormPanel = new dhc.herp.Grid({
        width: 1500,
		height:400,
		tbar:['年月:',yearmonField,'-','科室名称：',deptField,'-',findButton],
		urlParam:{BIDNM:BIDNM},
        url: 'herp.budg.budgisnotbasedatadetailexe.csp', 
		fields: [
			{
				id:'nrowid',
		        header: 'ID',
		        dataIndex: 'nrowid',
		        hidden: true
		    },{
		        id:'nbfryear',
		        header: '年度',
		        dataIndex: 'nbfryear',
		        width:75,
		        update:true,
				editable:false,
				hidden: false
		    },{ 
		        id:'nbfrmonth',
		        header: '月份',
		        dataIndex: 'nbfrmonth',
		        width:75,
				editable:false,
				hidden: false
		    }, {
		        id:'nbdeptname',
		        header: '科室名称',
				//tip:true,
				allowBlank: false,
				width:220,
				editable:false,
		        dataIndex: 'nbdeptname'
			
		    }, {
		        id:'nbfritemcode',
		        header: '预算项编码',
		        width:150,
				//tip:true,
				//allowBlank: false,
		        editable:false,
		        dataIndex: 'nbfritemcode'
				
		    }, {
		        id:'nbidname',
		        header: '预算项名称',
		        width:250,
				//tip:true,
				allowBlank: false,
				editable:true,
		        dataIndex: 'nbidname'
		    }
		]
	});
	
	var invWindow = new Ext.Window({
		layout: 'fit',
		title:"请选择科室月执行数据",
		plain:true,
		width : 900,
		height : 600,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: [NMFormPanel]
	});
	
	
	NMFormPanel.btnAddHide();  //隐藏增加按钮
	NMFormPanel.btnSaveHide();  //隐藏保存按钮
	NMFormPanel.btnResetHide();  //隐藏重置按钮
	NMFormPanel.btnDeleteHide(); //隐藏删除按钮
	NMFormPanel.btnPrintHide();  //隐藏打印按钮
	
	var Yearmonth=yearmonField.getValue();	
	var deptdr=deptField.getValue();	
	var itemcode=descField.getValue();

	NMFormPanel.load({params:{BIDNM:BIDNM,Yearmonth:Yearmonth,deptdr:deptdr,itemcode:itemcode}});
	invWindow.show();              

	NMFormPanel.on('celldblclick',function( g,i,c,e ){
		var rowO = g.getSelectionModel().getSelections();
		var nlen = rowO.length;
		var nrowid = rowO[0].get("nrowid");
		var nbfryear = rowO[0].get("nbfryear"); 
		var nbfrmonth = rowO[0].get("nbfrmonth"); 
		var nbdeptname = rowO[0].get("nbdeptname"); 
		var nbdeptname = rowO[0].get("nbdeptname"); 
		var nbfritemcode = rowO[0].get("nbfritemcode"); 
//		var cannum = rowO[0].get("cannum"); 
		var rcs=itemGrid.getSelectionModel().getSelected();
		rcs.set('bibbrealdatadr',nrowid);
		rcs.set('bfryear',nbfryear);
		rcs.set('bfrmonth',nbfrmonth);
		rcs.set('bdeptname',nbdeptname);
		rcs.set('bfritemcode',nbfritemcode);
//		nowcannum=cannum;
		invWindow.close();  	
		
	});	
	
	}