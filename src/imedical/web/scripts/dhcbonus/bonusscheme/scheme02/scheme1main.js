//rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'����',dataIndex:'code'}, 					//1
	{header:'��������',dataIndex:'name'},               //2
	{header:'��������',dataIndex:'desc'},               //3
	{header:'�������',dataIndex:'SchemeTypeName'},               //4
	{header:'������Ա',dataIndex:'createPerson'},       //5
	{header:'������Ա',dataIndex:'adjustPerson'},       //6
	{header:'����״̬',dataIndex:'schemeState'},        //7
	{header:'����ʱ��',dataIndex:'adjustDate'},         //8
	{header:'�����Ա',dataIndex:'auditingPerson'},     //9
	{header:'���ʱ��',dataIndex:'auditingDate'},       //10
	{header:'�Ƿ���Ч',dataIndex:'isValid'}		        //11
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
			fieldLabel : '�������',
			name : 'type',
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			//mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��',
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
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,

});

var schemeSM= new Ext.grid.RowSelectionModel({singleSelect:true});

var scheme1Main = new Ext.grid.GridPanel({
	title:'������㷽��',
	region:'west',
	width:450,
	store: scheme1Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['���𷽰����:',schemeTypeCombo],
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

	//�����ӿں��㲿�ź�ˢ�½ӿں��㲿�ŵ�Ԫ
	tmpSelectedScheme=selectedRow.data['rowid'];
	scheme02Ds.proxy = new Ext.data.HttpProxy({url: scheme02Url + '?action=scheme02list&scheme='+tmpSelectedScheme});
	scheme02Ds.load({params:{start:0, limit:scheme02PagingToolbar.pageSize}});
	//itemDs.proxy = new Ext.data.HttpProxy({url: itemUrl + '?action=itemlist&type='+tmpSelectedScheme});
	//itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});
	
});
