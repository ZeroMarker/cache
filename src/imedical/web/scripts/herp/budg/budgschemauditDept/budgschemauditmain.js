//科室rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var schemeValue = new Array(

	{header:'方案主键',dataIndex:'rowid'},				//0
	{header:'预算年度',dataIndex:'year'}, 				//1
	{header:'方案编码',dataIndex:'code'},                //2
	{header:'方案名称',dataIndex:'name'},                //3
	{header:'预算分类',dataIndex:'type'},                //4
	{header:'方案分类',dataIndex:'unitType'},            //5
	{header:'编制顺序',dataIndex:'orderBy'},             //6
	{header:'计算结果对应预算项',dataIndex:'itemCode'},    //7
	{header:'方案审核状态',dataIndex:'ischeck'},          //8
	{header:'审核时间',dataIndex:'checkDate'},           //9
	{header:'审核人',dataIndex:'checker'},               //10
	{header:'连接说明文件',dataIndex:'file'},		        //11
	{header:'是否为代编方案',dataIndex:'isHelpEdit'},	    //12
	{header:'审批流ID',dataIndex:'CHKFlowdr'}	,	        //13
	{header:'系统方案',dataIndex:'isSys'},		            //14
	{header:'医疗单位',dataIndex:'CompName'}               //15
);



var schemeUrl = 'herp.budg.budgschemauditdeptexe.csp';
var schemeProxy = new Ext.data.HttpProxy({url: schemeUrl + '?action=schemelist&start=0&limit=25'});

var budgschemauditDs = new Ext.data.Store({
	proxy: schemeProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		schemeValue[0].dataIndex,
		schemeValue[1].dataIndex,
		schemeValue[2].dataIndex,
		schemeValue[3].dataIndex,
		schemeValue[4].dataIndex,
		schemeValue[5].dataIndex,
		schemeValue[6].dataIndex,
	    schemeValue[7].dataIndex,
		schemeValue[8].dataIndex,
		schemeValue[9].dataIndex,
		schemeValue[10].dataIndex,
		schemeValue[11].dataIndex,
		schemeValue[12].dataIndex,
		schemeValue[13].dataIndex,
		schemeValue[14].dataIndex,
		schemeValue[15].dataIndex
	]),
	remoteSort: true
});

budgschemauditDs.setDefaultSort('year', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: schemeValue[0].header,
		dataIndex: schemeValue[0].dataIndex,
		width: 75,
		hidden:true,
		sortable: true
	},{
		header: schemeValue[15].header,
		dataIndex: schemeValue[15].dataIndex,
		width: 70,
		hidden:true,
		sortable: true
	},{
		header: schemeValue[1].header,
		dataIndex: schemeValue[1].dataIndex,
		width: 45,
		sortable: true
	},
	{
		header: schemeValue[2].header,
		dataIndex:schemeValue[2].dataIndex,
		width: 50,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[3].header,
		dataIndex: schemeValue[3].dataIndex,
		width: 115,
		align: 'left',
		//renderer:function(value,metadata,record,rowIndex,colIndex,store){
		//	return schemeTypeValue[value];
		//},
		sortable: true
	},
	{
		header: schemeValue[8].header,
		dataIndex:schemeValue[8].dataIndex,
		width: 60,
		align: 'left',
		//renderer:function(value,metadata,record,rowIndex,colIndex,store){
		//	return schemeStateValue[value];
		//},
		sortable: true
	},
	{
		header: schemeValue[13].header,
		dataIndex:schemeValue[13].dataIndex,
		width: 75,
		align: 'left',
		sortable: true,
		hidden:true
	}
]);

////////////////////////////1:计划指标2：收支预算3: 费用标准4：预算结果表
var schemeType = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1','计划指标'],            
				['2','科目预算'],            
				['3','费用标准']
			]                                 
});              
//	'4','预算结果表'    

var schemeTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'方案分类',
	store: schemeType,
	displayField:'name',
	valueField:'rowid',
	typeAhead: true,
	mode: 'local',
	
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'选择...',
	width: 110,
	listWidth : 245,
	selectOnFocus:true,
	columnWidth:.10
});

/////////////////年/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['year','year'])
	});

	YearDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:commonboxURL+'?action=year&flag=',method:'POST'});
		
	});
		
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'年度',
		store: YearDs,
		displayField:'year',
		valueField:'year',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 110,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		//columnWidth:.2,
		selectOnFocus:true
		//columnWidth:.15
	});

	
//**************************************************
var nameField = new Ext.form.Field({
	id: 'nameField',
	fieldLabel: '方案名称',
	width:110,
	listWidth : 245,
	//allowBlank: false,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'请填写方案名称',
	name: 'nameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var searchbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
	    var name=Ext.getCmp('nameField').getValue();
		budgschemauditDs.proxy = new Ext.data.HttpProxy({
						url : schemeUrl + '?action=schemelist&year='+YearCombo.getValue()
						+'&type='+schemeTypeCombo.getValue()+'&name='+encodeURIComponent(Ext.getCmp('nameField').getValue())+'&start=0&limit=25',
						method : 'POST'
					});
			//schemItemDs.removeAll();			
			budgschemauditDs.load({
						params : {
							start : 0,
							limit : 25
						},
						callback : function(record, options, success) {
							inDeptsCm.fireEvent('rowselect', this, 0);
						}
					});
	
	}
});


//复制按钮
var CopyButton = new Ext.Toolbar.Button({
	text: '复制',
	tooltip: '复制往年归口科室',
	iconCls: 'add',
	handler: function(){
		var rowObj = budgschemauditmain.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:'160'});
			return;
		}
		var fromschemdr=rowObj[0].get("rowid");
		CopyFun(fromschemdr);
	}
});

var schemePagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: budgschemauditDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});

var schemeSM= new Ext.grid.RowSelectionModel({singleSelect:true})

var budgschemauditmain = new Ext.grid.GridPanel({
	title:'科室预算归口设置',
	region:'center',
	//region:'center',
	//width:550,
	layout:"fit",
	store: budgschemauditDs,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	//autoScroll:true,
	viewConfig: {forceFit:true},
	tbar:['预算年度',YearCombo,'方案类别',schemeTypeCombo,'方案名称:',nameField,'-',searchbotton,'-',CopyButton],
	bbar: schemePagingToolbar
	

});

budgschemauditDs.load({
	params:{start:0, limit:schemePagingToolbar.pageSize},

	callback:function(record,options,success ){
		budgschemauditmain.fireEvent('rowclick',this,0);
		//rsm.selectFirstRow();
	}
});

var tmpSelectedScheme='';

budgschemauditmain.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = budgschemauditDs.data.items[rowIndex];
    //alert(selectedRow);
	//单击接口核算部门后刷新接口核算部门单元
	tmpSelectedScheme=selectedRow.data['rowid'];
	
	schemeaudititemMain.load({params:{start:0, limit:12,schemeDr:tmpSelectedScheme}})
	
});
