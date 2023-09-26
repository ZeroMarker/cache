/**
  *name:tab of jxgroup
  *author:limingzhong
  *Date:2010-8-5
 */
//=============���岿��ȫ�ֱ���======================
var deptIDStr=""; //���ڴ洢
var deptNameStr=""; //������ʾ
var KPIDrStr=""; //���ڴ洢
var KPINameStr=""; //������ʾ
var IDSet=""; //ID�ַ���
//===================================================
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

var typeDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['1','1-ָ��'],['2','2-��Ч��Ԫ']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '�������',
	listWidth : 230,
	selectOnFocus: true,
	allowBlank: false,
	store: typeDs,
	anchor: '90%',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ��������...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

typeField.on("select",function(cmb,rec,id){
	JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:cmb.getValue()}});
});

var find = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
	}
});

//�������Դ
var JXGroupTabUrl = '../csp/dhc.pa.jxgroupexe.csp';
var JXGroupTabProxy= new Ext.data.HttpProxy({url:JXGroupTabUrl + '?action=list'});
var JXGroupTabDs = new Ext.data.Store({
	proxy: JXGroupTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'IDSet',
		'NameStr',
		'isInput',
		'type',
		'typeName',
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
JXGroupTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var JXGroupTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '�������',
        dataIndex: 'code',
        width: 80,
        sortable: true
    },{
        header: "��������",
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "����ָ���Ч��Ԫ",
        dataIndex: 'NameStr',
        width: 600,
        align: 'left',
        sortable: true
    },{
        header: "�Ƿ�¼��",
        dataIndex: 'isInput',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "�������",
        dataIndex: 'typeName',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header:'����',
		width:120,
		dataIndex:'desc',
		sortable: true
    }
]);

//��ʼ��Ĭ��������
JXGroupTabCm.defaultSortable = true;

//��Ӱ�ť
var addJXGroup = new Ext.Toolbar.Button({
	text: '��ӷ���',
    tooltip:'��ӷ���',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		addFun(type,JXGroupTabDs,JXGroupTabPagingToolbar);
	}
});

//�޸İ�ť
var editJXGroup = new Ext.Toolbar.Button({
	text: '�޸ķ���',
    tooltip:'�޸ķ���',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		editFun(type,JXGroupTabDs,JXGroupTab,JXGroupTabPagingToolbar);
	}
});

//ɾ����ť
var delJXGroup = new Ext.Toolbar.Button({
	text: 'ɾ������',
    tooltip:'ɾ������',        
    iconCls:'add',
	handler:function(){
		var type=Ext.getCmp('typeField').getValue();
		//���岢��ʼ���ж���
		var rowObj=JXGroupTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.jxgroupexe.csp?action=del&rowid='+rowid,
					waitMsg:'ɾ����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							JXGroupTabDs.load({params:{start:0,limit:JXGroupTabPagingToolbar.pageSize,type:type}});
						}else{
							Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});

//��ʼ�������ֶ�
var JXGroupSearchField ='name';

//����������
var JXGroupFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'name',
			checked: false,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '�������',
			value: 'typeName',
			checked: false,
			group: 'JXGroupFilter',
			checkHandler: onJXGroupItemCheck 
		})
	]}
});

//����������Ӧ����
function onJXGroupItemCheck(item, checked){
	if(checked) {
		JXGroupSearchField = item.value;
		JXGroupFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var JXGroupSearchBox = new Ext.form.TwinTriggerField({
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
			var type=Ext.getCmp('typeField').getValue();			
			JXGroupTabDs.proxy = new Ext.data.HttpProxy({url: JXGroupTabUrl + '?action=list'});
			JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			var type=Ext.getCmp('typeField').getValue();
			JXGroupTabDs.proxy = new Ext.data.HttpProxy({
				url: JXGroupTabUrl + '?action=list&searchField=' + JXGroupSearchField + '&searchValue=' + this.getValue()});
	        	JXGroupTabDs.load({params:{start:0, limit:JXGroupTabPagingToolbar.pageSize,type:type}});
	    	}
	}
});

//��ҳ������
var JXGroupTabPagingToolbar = new Ext.PagingToolbar({
    store: JXGroupTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',JXGroupFilterItem,'-',JXGroupSearchBox]
});

//���
var JXGroupTab = new Ext.grid.GridPanel({
	title: '��ʾ����ά��',
	store: JXGroupTabDs,
	cm: JXGroupTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['�������:',typeField,'-',find,'-',addJXGroup,'-',editJXGroup,'-',delJXGroup],
	bbar:JXGroupTabPagingToolbar
});

