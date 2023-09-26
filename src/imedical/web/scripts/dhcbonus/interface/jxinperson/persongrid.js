var personUrl = 'dhc.pa.jxinpersonexe.csp';
var personProxy;

//�ⲿָ��
var personDs = new Ext.data.Store({
	proxy: personProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'jxUnitDr',
		'rowid',
		'userDr',
		'userCode',
		'userName',
		'remark',
		'active'
	]),
	remoteSort: true
});

personDs.setDefaultSort('rowid', 'asc');
var personCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '��Ա����',
		dataIndex: 'userCode',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "��Ա����",
		dataIndex: 'userName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "��Ա��ע",
		dataIndex: 'remark',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "��Ч��־",
		dataIndex: 'active',
		width: 80,
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
	text: '����ڲ���Ա',
    tooltip:'����ڲ���Ա',        
    iconCls:'add',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��Ч��Ԫ��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var jxUnitDr=rowObj[0].get("rowid");
			addFun(jxUnitDr,personDs,personGrid,personPagingToolbar);
		}
	}
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸��ڲ���Ա',
    tooltip:'�޸��ڲ���Ա',        
    iconCls:'add',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��Ч��Ԫ��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("rowid");
		}
		
		editFun(jxUnitDr,personDs,personGrid,personPagingToolbar);
	}
});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ���ڲ���Ա',
    tooltip:'ɾ���ڲ���Ա',        
    iconCls:'remove',
	handler:function(){
		var rowObj = JXUnitGrid.getSelections();
		var len = rowObj.length;
		var jxUnitDr=0;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��Ч��Ԫ��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			jxUnitDr=rowObj[0].get("rowid");
		}
		
		var rowObj = personGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ�����ڲ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxinpersonexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,sort:"rowid",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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

var personSearchField = 'userName';

var personFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '����',value: 'userCode',checked: false,group: 'personFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'userName',checked: true,group: 'personFilter',checkHandler: onCheck })
	]}
});
function onCheck(item, checked)
{
	if(checked) {
		personSearchField = item.value;
		personFilterItem.setText(item.text + ':');
	}
};

var personSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=personlist&jxUnitDr='+JXUnitGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				personDs.proxy = new Ext.data.HttpProxy({
				url: personUrl+'?action=personlist&jxUnitDr='+JXUnitGrid.getSelections()[0].get("rowid")+'&searchField='+personSearchField+'&searchValue='+this.getValue()+'&sort=rowid&dir=asc'});
				personDs.load({params:{start:0,limit:personPagingToolbar.pageSize}});
			}
		}
	});
	var personPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:personDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:[personFilterItem,'-',personSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['jxUnitDr']=JXUnitGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var personGrid = new Ext.grid.GridPanel({//���
		title: '�ڲ���Ա��Ϣ',
		region: 'center',
		xtype: 'grid',
		store: personDs,
		cm: personCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: personPagingToolbar
	});