var jxUnitUrl = '../csp/dhc.pa.deptschemexe.csp';
var jxUnitProxy;

//��Ч��Ԫ
var jxUnitDs = new Ext.data.Store({
	proxy: jxUnitProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'parRef',
		'parRefCode',
		'parRefName',
		'jxLocTypeDr',
		'jxLocTypeName',
		'rowid',
		'childSub',
		'schemDr'
	]),
	remoteSort: true
});

jxUnitDs.setDefaultSort('rowid', 'Desc');
var jxUnitCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '��Ч��Ԫ����',
		dataIndex: 'parRefCode',
		width: 120,
		sortable: true
	},{
		header: "��Ч��Ԫ����",
		dataIndex: 'parRefName',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "�����������",
		dataIndex: 'jxLocTypeName',
		width: 120,
		align: 'left',
		sortable: true
	}
]);


//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '��Ӽ�Ч��Ԫ',
    tooltip:'��Ӽ�Ч��Ԫ',        
    iconCls:'add',
	handler:function(){
		addJXUnitFun(SchemGrid,jxUnitDs,jxUnitGrid,jxUnitPagingToolbar);
	}
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸ļ�Ч��Ԫ',
    tooltip:'�޸ļ�Ч��Ԫ',        
    iconCls:'add',
	handler:function(){
		editJXUnitFun(SchemGrid,jxUnitDs,jxUnitGrid,jxUnitPagingToolbar);
	}
});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ����Ч��Ԫ',
    tooltip:'ɾ����Ч��Ԫ',        
    iconCls:'remove',
	handler:function(){
		var rowObj = jxUnitGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.deptschemexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									jxUnitDs.load({params:{start:jxUnitPagingToolbar.cursor, limit:jxUnitPagingToolbar.pageSize,schemDr:SchemGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"DESC"}});
								}else{
									var message="ɾ������";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

var jxUnitSearchField = 'parRefName';

var jxUnitFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
            text: '����',
            value: 'parRefCode',
            checked: false,
            group: 'jxUnitFilter',
            checkHandler: onBusItemItemCheck 
        }),
        new Ext.menu.CheckItem({ 
            text: '����',
            value: 'parRefName',
            checked: false,
            group: 'jxUnitFilter',
            checkHandler: onBusItemItemCheck 
        }),
        new Ext.menu.CheckItem({ 
            text: '�������',
            value: 'jxLocTypeName',
            checked: false,
            group: 'jxUnitFilter',
            checkHandler: onBusItemItemCheck
        })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		jxUnitSearchField = item.value;
		jxUnitFilterItem.setText(item.text + ':');
	}
};

var jxUnitSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&schemDr='+SchemGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=DESC'});
				jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				jxUnitDs.proxy = new Ext.data.HttpProxy({
				url: jxUnitUrl+'?action=jxunitlist&schemDr='+SchemGrid.getSelections()[0].get("rowid")+'&searchField='+jxUnitSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=DESC'});
				jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
			}
		}
	});
	var jxUnitPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:jxUnitDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:[jxUnitFilterItem,'-',jxUnitSearchBox],
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
	var jxUnitGrid = new Ext.grid.GridPanel({//���
		title: '��Ч��Ԫ��Ϣ',
		region: 'center',
		xtype: 'grid',
		store: jxUnitDs,
		cm: jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: jxUnitPagingToolbar
	});