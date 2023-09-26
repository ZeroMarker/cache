var jxUnitUrl = '../csp/dhc.pa.deptschemexe.csp';
var jxUnitProxy;

//��Ч��Ԫ
var bonusItemDs = new Ext.data.Store({
	proxy: jxUnitProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'd1',
		'd2',
		'd3'
	]),
	remoteSort: true
});

var jxUnitCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '���㵥Ԫ����',
		dataIndex: 'parRefCode',
		width: 100,
		sortable: true
	},{
		header: "��Ŀ����",
		dataIndex: 'parRefName',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "������Դ",
		dataIndex: 'jxLocTypeName',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "������",
		dataIndex: 'jxLocTypeName',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "��ʽ����",
		dataIndex: 'jxLocTypeName',
		width: 180,
		align: 'left',
		sortable: true
	},{
		header: "������ϸ",
		dataIndex: 'jxLocTypeName',
		width: 180,
		align: 'left',
		sortable: true
	}
]);

	var jxUnitPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:bonusItemDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		//buttons:[jxUnitFilterItem,'-',jxUnitSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['schemDr']=SchemGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var bonusitemgrid = new Ext.grid.GridPanel({//���
		title: '�������������',
		region: 'center',
		xtype: 'grid',
		store: bonusItemDs,
		cm: jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		bbar: jxUnitPagingToolbar
	});