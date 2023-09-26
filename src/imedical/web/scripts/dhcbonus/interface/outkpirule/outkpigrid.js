var outKpiUrl = 'dhc.bonus.outkpiruleexe.csp';
var outKpiProxy;

//�ⲿָ��
var outKpiDs = new Ext.data.Store({
	proxy: outKpiProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'inLocSetDr',
		'inLocSetName',
		'interMethodDr',
		'methodDesc',
		'location',
		'active'
	]),
	remoteSort: true
});

outKpiDs.setDefaultSort('rowid', 'asc');
var outKpiCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'ָ�����',
		dataIndex: 'code',
		width: 60,
		align: 'left',
		sortable: true
	},{
		header: "ָ������",
		dataIndex: 'name',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "�ӿڷ���",
		dataIndex: 'methodDesc',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "ȡֵλ��",
		dataIndex: 'location',
		width: 50,
		align: 'left',
		sortable: true
	},{
		header: "��Ч��־",
		dataIndex: 'active',
		width: 60,
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
	text: '��ӽ���ָ��',
    tooltip:'��ӽ���ָ��',        
    iconCls:'add',
	handler:function(){
		var rowObj = LocSetGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ��׼�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var locSetDr=rowObj[0].get("rowid");
			addFun(locSetDr,outKpiDs,LocSetGrid,outKpiPagingToolbar);
		}//LocSetGrid
	}
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸Ľ���ָ��',
    tooltip:'�޸Ľ���ָ��',        
    iconCls:'add',
	handler:function(){
		editFun(outKpiDs,outKpiGrid,outKpiPagingToolbar);
	}
});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ������ָ��',
    tooltip:'ɾ������ָ��',        
    iconCls:'remove',
	handler:function(){
		var rowObj = outKpiGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ľ���ָ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						var active=rowObj[0].get("active");
						active= "NO"
						if((active=="Y")||(active=="Yes")){
							Ext.Msg.show({title:'��ʾ',msg:'��������Ч,����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							return false;
						}else{
							Ext.Ajax.request({
								url:'dhc.bonus.outkpiruleexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize,locSetDr:LocSetGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"asc"}});
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

var outKpiSearchField = 'name';

var outKpiFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'outKpiFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'outKpiFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		outKpiSearchField = item.value;
		outKpiFilterItem.setText(item.text + ':');
	}
};

var outKpiSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				outKpiDs.proxy = new Ext.data.HttpProxy({url:outKpiUrl+'?action=kpilist&locSetDr='+LocSetGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outKpiDs.proxy = new Ext.data.HttpProxy({
				url: outKpiUrl+'?action=kpilist&locSetDr='+LocSetGrid.getSelections()[0].get("rowid")+'&searchField='+outKpiSearchField+'&searchValue='+this.getValue()+'&sort=rowid&dir=asc'});
				outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
			}
		}
	});
	var outKpiPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:outKpiDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:[outKpiFilterItem,'-',outKpiSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['locSetDr']=LocSetGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var outKpiGrid = new Ext.grid.GridPanel({//���
		title: '����ָ����Ϣ',
		region: 'center',
		xtype: 'grid',
		store: outKpiDs,
		cm: outKpiCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: outKpiPagingToolbar
	});