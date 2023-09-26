/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ
var JXUnitAuditTabUrl = '../csp/dhc.pa.jxunitauditexe.csp';
var JXUnitAuditTabProxy= new Ext.data.HttpProxy({url:JXUnitAuditTabUrl + '?action=list'});
var JXUnitAuditTabDs = new Ext.data.Store({
	proxy: JXUnitAuditTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'jxUnitDr',
		'jxUnitName',
		'userDr',
		'userName',
		'isRead',
		'isWrite'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
JXUnitAuditTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var JXUnitAuditTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "�û�����",
		dataIndex: 'userName',
		width: 150,
		sortable: true
	},{
		header: "������Ԫ",
		dataIndex: 'jxUnitName',
		width: 150,
		sortable: true
	},{
		header:'��Ȩ��',
		align: 'center',
		width:120,
		sortable: true,
		dataIndex:'isRead',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
		header:'дȨ��',
		align: 'center',
		width:120,
		sortable: true,
		dataIndex:'isWrite',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);

//��ʼ��Ĭ��������
JXUnitAuditTabCm.defaultSortable = true;

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
		addFun(JXUnitAuditTabDs,JXUnitAuditTabPagingToolbar);
	}
});

//���밴ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){
		editFun(JXUnitAuditTabDs,JXUnitAuditTab,JXUnitAuditTabPagingToolbar);
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'add',
	handler: function(){
		var rowObj = JXUnitAuditTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.jxunitauditexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXUnitAuditTabDs.load({params:{start:JXUnitAuditTabPagingToolbar.cursor, limit:JXUnitAuditTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
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

//��ʼ�������ֶ�
var JXUnitAuditSearchField ='jxUnitName';

//����������
var JXUnitAuditFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '�û�����',
			value: 'userName',
			checked: false ,
			group: 'JXUnitAuditFilter',
			checkHandler: onJXUnitAuditItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��Ч��Ԫ',
			value: 'jxUnitName',
			checked: false,
			group: 'JXUnitAuditFilter',
			checkHandler: onJXUnitAuditItemCheck 
		})
	]}
});

//����������Ӧ����
function onJXUnitAuditItemCheck(item, checked){
	if(checked) {
		JXUnitAuditSearchField = item.value;
		JXUnitAuditFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var JXUnitAuditSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			JXUnitAuditTabDs.proxy = new Ext.data.HttpProxy({url: JXUnitAuditTabUrl + '?action=list'});
			JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			JXUnitAuditTabDs.proxy = new Ext.data.HttpProxy({
				url: JXUnitAuditTabUrl + '?action=list&searchField=' + JXUnitAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
	        	JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize}});
	    	}
	}
});

//��ҳ������
var JXUnitAuditTabPagingToolbar = new Ext.PagingToolbar({
    store: JXUnitAuditTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',JXUnitAuditFilterItem,'-',JXUnitAuditSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
var JXUnitAuditTab = new Ext.grid.GridPanel({
	title: '��Ч��ԪȨ�����ù���',
	store: JXUnitAuditTabDs,
	cm: JXUnitAuditTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:JXUnitAuditTabPagingToolbar
});

JXUnitAuditTabDs.load({params:{start:0, limit:JXUnitAuditTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
