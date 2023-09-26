/**
  *name:tab of database
  *author:wang ying
  *Date:2011-09-05
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
function toUTF8(a){
       var wch,x,uch="",szRet="";
       for (x=0; x<a.length; x++){
       wch=a.charCodeAt(x);
       if (!(wch & 0xFF80)){
       szRet += a.charAt(x);
       }
       else if (!(wch & 0xF000)){
       uch = "%" + (wch>>6 | 0xC0).toString(16) +
       "%" + (wch & 0x3F | 0x80).toString(16);
       szRet += uch;
       }
       else{
       uch = "%" + (wch >> 12 | 0xE0).toString(16) +
       "%" + (((wch >> 6) & 0x3F) | 0x80).toString(16) +
       "%" + (wch & 0x3F | 0x80).toString(16);
       szRet += uch;
       }
       }
       return(szRet);
       }
//�������Դ
var KPIProTabUrl = 'dhc.pa.kpiproexe.csp';
var KPIProTabProxy= new Ext.data.HttpProxy({url:KPIProTabUrl + '?action=list'});
var userCode=session['LOGON.USERCODE'];
var KPIProTabDs = new Ext.data.Store({
	proxy: KPIProTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'KPIDr',
		'KPIName',
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
KPIProTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var KPIProTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "ָ������",
		dataIndex: 'KPIName',
		width: 150,
		sortable: true
	},{
		header: "����",
		dataIndex: 'desc',
		width: 150,
		sortable: true
	}
]);

//��ʼ��Ĭ��������
KPIProTabCm.defaultSortable = true;

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
		addFun(KPIProTabDs,KPIProTabPagingToolbar);
	}
});

//���밴ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){
		editFun(KPIProTabDs,KPIProTab,KPIProTabPagingToolbar);
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'add',
	handler: function(){
		var rowObj = KPIProTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KPIProTabUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KPIProTabDs.load({params:{start:KPIProTabPagingToolbar.cursor, limit:KPIProTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
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
var KPIProSearchField ='jxUnitName';

//����������
var KPIProFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: 'ָ������',
			value: 'KPIName',
			checked: true,
			group: 'KPIProFilter',
			checkHandler: onKPIProItemCheck 
		})
	]}
});

//����������Ӧ����
function onKPIProItemCheck(item, checked){
	if(checked) {
		KPIProSearchField = item.value;
		KPIProFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var KPIProSearchBox = new Ext.form.TwinTriggerField({
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
			KPIProTabDs.proxy = new Ext.data.HttpProxy({url: KPIProTabUrl + '?action=list'});
			KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			KPIProTabDs.proxy = new Ext.data.HttpProxy({
				url: KPIProTabUrl + '?action=list&searchField=' + KPIProSearchField + '&searchValue=' + this.getValue()});
	        	KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize}});
	    	}
	}
});

//��ҳ������
var KPIProTabPagingToolbar = new Ext.PagingToolbar({
    store: KPIProTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',KPIProFilterItem,'-',KPIProSearchBox],
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
var KPIProTab = new Ext.grid.GridPanel({
	title: 'ƽ��ֵָ�����',
	store: KPIProTabDs,
	cm: KPIProTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:KPIProTabPagingToolbar
});

KPIProTabDs.load({params:{start:0, limit:KPIProTabPagingToolbar.pageSize,dir:'asc',sort:'rowid'}});
