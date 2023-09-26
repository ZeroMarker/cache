//rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'代码',dataIndex:'code'}, 					//1
	{header:'方案名称',dataIndex:'name'},               //2
	{header:'方案描述',dataIndex:'desc'},               //3
	{header:'方案类别',dataIndex:'SchemeTypeName'},               //4
	{header:'创建人员',dataIndex:'createPerson'},       //5
	{header:'调整人员',dataIndex:'adjustPerson'},       //6
	{header:'方案状态',dataIndex:'schemeState'},        //7
	{header:'调整时间',dataIndex:'adjustDate'},         //8
	{header:'审核人员',dataIndex:'auditingPerson'},     //9
	{header:'审核时间',dataIndex:'auditingDate'},       //10
	{header:'是否有效',dataIndex:'isValid'}		        //11
);



var schemeUrl = 'dhc.bonus.scheme01exe.csp';
var schemeProxy = new Ext.data.HttpProxy({url: schemeUrl + '?action=schemelist&start=0&limit=25'});

var scheme1Ds = new Ext.data.Store({
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
		schemeValue[11].dataIndex
	]),
	remoteSort: true
});

scheme1Ds.setDefaultSort('rowid', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: schemeValue[1].header,
		dataIndex: schemeValue[1].dataIndex,
		width: 60,
		sortable: true
	},
	{
		header: schemeValue[2].header,
		dataIndex:schemeValue[2].dataIndex,
		width: 150,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[4].header,
		dataIndex: schemeValue[4].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[7].header,
		dataIndex:schemeValue[7].dataIndex,
		width: 80,
		align: 'left',
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return schemeStateValue[value];
		},
		sortable: true
	}
]);

var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '方案类别',
			name : 'type',
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			//mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择',
			selectOnFocus : true,
			anchor : '100%'
		});
schemeTypeCombo.on('select', function() {
			scheme1Ds.proxy = new Ext.data.HttpProxy({
						url : schemeUrl + '?action=schemelist&start=0&limit=25&searchField=SchemeType&searchValue='
								+ schemeTypeCombo.getValue(),
						method : 'GET'
					});
			scheme02Ds.removeAll();
			// -------------------
			scheme1Ds.load({
						params : {
							start : 0,
							limit : 25
						},
						callback : function(record, options, success) {
							// schemeMain.fireEvent('rowclick',this,0);
							// schemeMain.getSelectionModel().selectAll();
							inDeptsCm.fireEvent('rowselect', this, 0);
						}
					});

});
var schemePagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: scheme1Ds,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});

var schemeSM= new Ext.grid.RowSelectionModel({singleSelect:true});

var scheme1Main = new Ext.grid.GridPanel({
	title:'奖金核算方案',
	region:'west',
	width:450,
	store: scheme1Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['奖金方案类别:',schemeTypeCombo],
	bbar: schemePagingToolbar
	

});

scheme1Ds.load({
	params:{start:0, limit:schemePagingToolbar.pageSize},
	callback:function(record,options,success ){
		scheme1Main.fireEvent('rowclick',this,0);
		//rsm.selectFirstRow();
	}
});

var tmpSelectedScheme='';

scheme1Main.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = scheme1Ds.data.items[rowIndex];

	//单击接口核算部门后刷新接口核算部门单元
	tmpSelectedScheme=selectedRow.data['rowid'];
	scheme02Ds.proxy = new Ext.data.HttpProxy({url: scheme02Url + '?action=scheme02list&scheme='+tmpSelectedScheme});
	scheme02Ds.load({params:{start:0, limit:scheme02PagingToolbar.pageSize}});
	//itemDs.proxy = new Ext.data.HttpProxy({url: itemUrl + '?action=itemlist&type='+tmpSelectedScheme});
	//itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});
	
});
