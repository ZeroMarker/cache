var outUrl = '../csp/dhc.pa.interpersonexe.csp';
var outProxy;

//�ⲿָ��
var outDs = new Ext.data.Store({
	proxy: outProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'userDr',
		'code',
		'name',
		'inLocSetDr',
		'LocSetName',
		'remark',
		'active'
	]),
	remoteSort: true
});

outDs.setDefaultSort('rowid', 'asc');
var outCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '�ӿ���Ա����',
		dataIndex: 'code',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "�ӿ���Ա����",
		dataIndex: 'name',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "�����ӿ���",
		dataIndex: 'LocSetName',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "��ע",
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
	text: '��ӽӿ���Ա',
    tooltip:'��ӽӿ���Ա',        
    iconCls:'add',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ���ڲ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var userDr=rowObj[0].get("userDr");
			addFun(userDr,outDs,outPagingToolbar);
		}
	}
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸Ľӿ���Ա',
    tooltip:'�޸Ľӿ���Ա',        
    iconCls:'add',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		var userDr=0;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ���ڲ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			userDr=rowObj[0].get("userDr");
		}
		
		editFun(userDr,outDs,OutGrid,outPagingToolbar);
	}
});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ���ӿ���Ա',
    tooltip:'ɾ���ӿ���Ա',        
    iconCls:'remove',
	handler:function(){
		var rowObj = InGrid.getSelections();
		var len = rowObj.length;
		var userDr=0;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ���ڲ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			userDr=rowObj[0].get("userDr");
		}
		
		var rowObj = OutGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ľӿ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.interpersonexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									outDs.load({params:{start:outPagingToolbar.cursor,limit:outPagingToolbar.pageSize,inDr:userDr,sort:"rowid",dir:"asc"}});
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

var outSearchField = 'name';

var outFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'outFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'outFilter',checkHandler: onCheck }),
		new Ext.menu.CheckItem({ text: '�ӿ���',value: 'LocSetName',checked: false,group: 'outFilter',checkHandler: onCheck })
	]}
});
function onCheck(item, checked)
{
	if(checked) {
		outSearchField = item.value;
		outFilterItem.setText(item.text + ':');
	}
};

var outSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				outDs.proxy = new Ext.data.HttpProxy({url:outUrl+'?action=outlist&inDr='+InGrid.getSelections()[0].get("userDr")+'&sort=rowid&dir=asc'});
				outDs.load({params:{start:0, limit:outPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outDs.proxy = new Ext.data.HttpProxy({
				url: outUrl+'?action=outlist&inDr='+InGrid.getSelections()[0].get("userDr")+'&searchField='+outSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=asc'});
				outDs.load({params:{start:0, limit:outPagingToolbar.pageSize}});
			}
		}
	});
	var outPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:25,
		store:outDs,
		displayInfo:true,
		displayMsg:'��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg:"û������",
		buttons:[outFilterItem,'-',outSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['inDr']=InGrid.getSelections()[0].get("userDr");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var OutGrid = new Ext.grid.GridPanel({//���
		title: '�ӿ���Ա��Ϣ',
		region: 'center',
		xtype: 'grid',
		store: outDs,
		cm: outCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: outPagingToolbar
	});