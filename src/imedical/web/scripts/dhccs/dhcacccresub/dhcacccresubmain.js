var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccre', method:'GET'}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['creCode','rowid'])	
});

//unitTypeDs.on(
//	'beforeload',
//	function(ds, o){
//		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
//	}
//);

var unitTypeSelecter = new Ext.form.ComboBox({
		id:'unitTypeSelecter',
		fieldLabel:'����',
		store: unitTypeDs,
		valueField:'rowid',
		displayField:'creCode',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'unitTypeSelecter',
		selectOnFocus: true,
		forceSelection: true 
});

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
		searchFun(cmb.getValue());
	}
);

var unitTypeRowid = "";

function searchFun(unitTypeDr)
{
		unitTypeRowid = unitTypeDr;
		unitsDs.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccresub&creSubParRef='+unitTypeRowid});
		unitsDs.load();
};

var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccresub&creSubParRef='+unitTypeRowid, method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
		
			'rowid',
			'creSubParRef',
			'creSubDesc',
			'creSubDataSource',
			'creSubPatType',
			'creSubAccItem',
			'creSubadmreason',
			'creSubpaymode',
			'creSubcat',
			'creSubLoc',
			'creSubFlag1',
			'creSubFlag2',
			'creSubFlag3',
			'creSubFlag4',
			'creSubFlag5',
			'creSubPrePrtFlag',
			'creSubIncluAbort',
			'creSubDFContains',
			'creSubJFContains'

		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '����',
        dataIndex: 'creSubDesc',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "ҵ������",
        dataIndex: 'creSubDataSource',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '���ݷ���',
        dataIndex: 'creSubPatType',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "��Ʒ���",
        dataIndex: 'creSubAccItem',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '��������',
        dataIndex: 'creSubadmreason',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "֧����ʽ",
        dataIndex: 'creSubpaymode',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '�շ���Ŀ',
        dataIndex: 'creSubcat',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "������Ժ����",
        dataIndex: 'creSubLoc',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '����1',
        dataIndex: 'creSubFlag1',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "����2",
        dataIndex: 'creSubFlag2',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '����3',
        dataIndex: 'creSubFlag3',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "����4",
        dataIndex: 'creSubFlag4',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
    	header: '����5',
        dataIndex: 'creSubFlag5',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "�����ش�",
        dataIndex: 'creSubPrePrtFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
    	header: '��������',
        dataIndex: 'creSubIncluAbort',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
        header: "����",
        dataIndex: 'creSubDFContains',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "�跽",
        dataIndex: 'creSubJFContains',
        width: 80,
        align: 'left',
        sortable: true
    }
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip:'����µ�λ��Ϣ',        
		iconCls:'add',
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'ע��',msg:'����ѡ��DHCAccCre!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				addFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ĵ�λ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			if(unitTypeRowid==""){
				Ext.Msg.show({title:'ע��',msg:'����ѡ��DHCAccCre!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				editFun(unitsDs,unitsMain,unitsPagingToolbar,unitTypeRowid);
			}
		}
	});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			delFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var unitsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: unitsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
	});

var unitsMain = new Ext.grid.GridPanel({//���
		title: 'ƾ֤ģ���ӱ�',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: ['DHCAccCre:',unitTypeSelecter,'-',addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
	});

unitsDs.load();