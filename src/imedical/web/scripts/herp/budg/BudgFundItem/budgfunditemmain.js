var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var FundItemDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
FundItemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfunditemexe.csp'+'?action=GetFund&str='+encodeURIComponent(Ext.getCmp('FundItemField').getRawValue()),method:'POST'});
});
var FundItemField = new Ext.form.ComboBox({
	id: 'FundItemField',
	fieldLabel: '现金流量科目',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: FundItemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择现金流量科目...',
	name: 'FundItemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//////////////////医疗单位////////////////////
var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});	
var ItemDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
ItemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfunditemexe.csp'+'?action=GetItem&str='+encodeURIComponent(Ext.getCmp('ItemField').getRawValue()),method:'POST'});
});
var ItemField = new Ext.form.ComboBox({
	id: 'ItemField',
	fieldLabel: '科目名称',
	width:200,
	listWidth :300,
	allowBlank: false,
	store: ItemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科目名称...',
	name: 'ItemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询年度
var yearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojestablishmainexe.csp'+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});
var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var FundItem2Ds = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
FundItem2Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfunditemexe.csp'+'?action=GetFund&str='+encodeURIComponent(Ext.getCmp('FundItem2Field').getRawValue()),method:'POST'});
});
var FundItem2Field = new Ext.form.ComboBox({
	id: 'FundItem2Field',
	fieldLabel: '现金流量科目',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: FundItem2Ds,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择现金流量科目...',
	name: 'FundItem2Field',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var Item2Ds = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
Item2Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfunditemexe.csp'+'?action=GetItem&str='+encodeURIComponent(Ext.getCmp('Item2Field').getRawValue()),method:'POST'});
});
var Item2Field = new Ext.form.ComboBox({
	id: 'Item2Field',
	fieldLabel: '科目名称',
	width:200,
	listWidth :300,
	allowBlank: false,
	store: Item2Ds,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科目名称...',
	name: 'Item2Field',
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
	
	var year=yearField.getValue();
	var FundDR=FundItem2Field.getValue();
	var ItemDR=Item2Field.getValue();
	itemGrid.load(({params:{start:0, limit:25,year:year,FundDR:FundDR,ItemDR:ItemDR}}));
	}
});


//rowid^ FundDR ^ FundCode ^ FundName ^ ItemDR ^ ItemCode ^ ItemName
var itemGrid = new dhc.herp.Grid({
        title: '现金流量表',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'herp.budg.budgfunditemexe.csp',
		//autoLoad:true,
		tbar:['年度：',yearField,'预算科目：',Item2Field,'现金流量科目：',FundItem2Field,searchButton],
		atLoad : true, // 是否自动刷新
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        }, {
           	id:'CompName',
            header: '医疗单位',
			calunit:true,
			allowBlank: true,
			width:120,
			hidden: true,
            dataIndex: 'CompName',
			type:AddCompDRCombo
        },{
            id:'Year',
            header: '年度',
			width:80,
			editable:false,
            dataIndex: 'Year'
        }, {
            id:'FundCode',
            header: '现金流量科目编码',
			width:120,
			editable:false,
            dataIndex: 'FundCode'
        }, {
            id:'FundDR',
            header: '现金流量科目',
			allowBlank: false,
			width:250,
            dataIndex: 'FundDR',
            type:FundItemField
        },{
            id:'ItemCode',
            header: '预算科目编码',
			editable:false,
			width:170,
            dataIndex: 'ItemCode'
        },{
            id:'ItemDR',
            header: '预算科目',
			allowBlank: false,
			width:170,
            dataIndex: 'ItemDR',
            type:ItemField
        }]
    
    });
	itemGrid.btnResetHide();
	itemGrid.btnPrintHide();
