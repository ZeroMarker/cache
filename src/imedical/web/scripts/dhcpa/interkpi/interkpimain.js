var interKpiUrl = 'dhc.pa.interkpiexe.csp';
var interKpiProxy;

//�ⲿָ��
var interKpiDs = new Ext.data.Store({
	proxy: interKpiProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid','KPIDr','kpirule','KPIName','code','name','locSetDr','locSetName','remark','active'
	]),
	remoteSort: true
});

interKpiDs.setDefaultSort('rowid', 'asc');
var interKpiCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'KPIָ�����',
		dataIndex: 'code',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "KPIָ������",
		dataIndex: 'name',
		width: 120,
		align: 'left',
		sortable: true
	},/*{
		header: "��ע",
		dataIndex: 'remark',
		width: 120,
		align: 'left',
		sortable: true
	},*/{
		header: "��Ч��־",
		dataIndex: 'active',
		width: 120,
		align: 'center',
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);


//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���KPIָ��',
    tooltip:'���KPIָ��',        
    iconCls:'add',
	handler:function(){
		addFun(KPIGrid,interKpiDs,interKpiGrid,interKpiPagingToolbar);
	}
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�KPIָ��',
    tooltip:'�޸�KPIָ��',        
    iconCls:'add',
	handler:function(){
		editFun(KPIGrid,interKpiDs,interKpiGrid,interKpiPagingToolbar);
	}
});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��KPIָ��',
    tooltip:'ɾ��KPIָ��',        
    iconCls:'remove',
	handler:function(){
		var rowObj = interKpiGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����KPIָ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						var active=rowObj[0].get("active");
						if((active=="Y")||(active=="Yes")){
							Ext.Msg.show({title:'��ʾ',msg:'��������Ч,����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							return false;
						}else{
							Ext.Ajax.request({
								url:KPIUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"asc"}});
									}else{
										Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
							});
						}
					}
				}
			)
		}
	}
});

var interKpiSearchField = 'name';

var interKpiFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'interKpiFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'interKpiFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		interKpiSearchField = item.value;
		interKpiFilterItem.setText(item.text + ':');
	}
};

var interKpiSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
		if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				interKpiDs.proxy = new Ext.data.HttpProxy({url:interKpiUrl+'?action=outkpirulelist&interkpi='+KPISetGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				interKpiDs.proxy = new Ext.data.HttpProxy({
				url: interKpiUrl+'?action=outkpirulelist&interkpi='+KPIGrid.getSelections()[0].get("rowid")+'&searchField='+interKpiSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=asc'});
				interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize}});
			}
		}
	});
	var interKpiPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:interKpiDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:[interKpiFilterItem,'-',interKpiSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['interkpi']=KPIGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var interKpiGrid = new Ext.grid.GridPanel({//���
		title: 'KPIָ����Ϣ',
		region: 'center',
		xtype: 'grid',
		store: interKpiDs,
		cm: interKpiCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: interKpiPagingToolbar
	});