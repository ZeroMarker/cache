/**
  *Ŀ�����ά������
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ

var KPITargetUrl = '../csp/dhc.pa.nYearKPITargetexe.csp';
var KPITargetTabProxy= new Ext.data.HttpProxy({url:KPITargetUrl + '?action=list'});
var KPITargetTabDs = new Ext.data.Store({
	proxy: KPITargetTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'kpiDr',
		'targetName',
		'targetCode',
		'coefficient',
		'changeNum'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
KPITargetTabDs.setDefaultSort('rowid', 'kpiDr');

//���ݿ�����ģ��
var KPITargetTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: 'ָ������',
        dataIndex: 'kpiDr',
        width: 200,
        sortable: true
    },{
        header: "Ŀ����������",
        dataIndex: 'targetName',
        width: 100,
        align: 'left',
        sortable: true
    },{
        header: "Ŀ�����͵Ĵ���",
        dataIndex: 'targetCode',
        width: 100,
        align: 'center',
        sortable: true
    },{
        header: "����",
        dataIndex: 'coefficient',
        width: 60,
        align: 'center',
        sortable: true
    },{
        header: "������",
        dataIndex: 'changeNum',
        width: 100,
        align: 'right',
        sortable: true
    }
]);
var KPIIndexProxy = new Ext.data.HttpProxy({url: 'dhc.pa.kpiindexexe.csp?action=kpi&start=0&limit=25'});	
	var KPIIndexDs = new Ext.data.Store({
			proxy:KPIIndexProxy,
			reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
            	'rowid','name'
 
			]),
    	remoteSort: true
	});
	KPIIndexDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.kpiindexexe.csp?action=kpi&&start=0&limit=999&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue())});
	});
//��ʼ��Ĭ��������
KPITargetTabCm.defaultSortable = true;
//��Ӱ�ť
var addKPITarget = new Ext.Toolbar.Button({
	text: '���Ŀ��',
    tooltip:'���Ŀ��',        
    iconCls:'add',
	handler:function(){
		add();
	}
});

//�޸İ�ť
var editKPITarget = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){
		edit();
	}
});

//ɾ����ť
var delKPITarget = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'����',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		//var rowObj=KPITargetTab.getSelections();
		var rowObj=KPITargetTab.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			
					Ext.Ajax.request({
						url:'../csp/dhc.pa.nYearKPITargetexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});
/*
//��ʼ�������ֶ�
var KPITargetSearchField ='name';

//����������
var KPITargetFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'KPITargetFilter',
			checkHandler: onKPITargetItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'targetName',
			checked: false,
			group: 'KPITargetFilter',
			checkHandler: onKPITargetItemCheck 
		})/*,
		new Ext.menu.CheckItem({ 
			text: 'Ӧ��ϵͳ���',
			value: 'appSysName',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})*/
/*	]}
});

//����������Ӧ����
function onKPITargetItemCheck(item, checked){
	if(checked) {
		KPITargetSearchField = item.value;
		KPITargetFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var KPITargetSearchBox = new Ext.form.TwinTriggerField({
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
			KPITargetTabDs.proxy = new Ext.data.HttpProxy({url: KPITargetUrl + '?action=list'});
			KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			KPITargetTabDs.proxy = new Ext.data.HttpProxy({
				url: KPITargetUrl + '?action=list&searchField=' + KPITargetSearchField + '&searchValue=' + this.getValue()});
	        	KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});
	    	}
	}
});
*/
//��ҳ������
var KPITargetTabPagingToolbar = new Ext.PagingToolbar({
    store: KPITargetTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼"
	//buttons: ['-',KPITargetFilterItem,'-',KPITargetSearchBox]
});

//���
var KPITargetTab = new Ext.grid.GridPanel({
	title: 'Ŀ�����ά������',
	store: KPITargetTabDs,
	cm: KPITargetTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addKPITarget,'-',editKPITarget,'-',delKPITarget],
	bbar:KPITargetTabPagingToolbar
});

//����
KPITargetTabDs.load({params:{start:0, limit:KPITargetTabPagingToolbar.pageSize}});

/*
DimensTypeTab.on('contextmenu',function(e){
    if(!this.menu){
		this.menu = new Ext.menu.Menu({
			items:[
				{
					text: 'Add Product',
					handler: addProduct
				},{
					text: 'Edit Product(s)'
					//handler: editProduct
				},{
					text: 'Delete Product(s)'
					//handler: deleteProduct
				}
			]
		});
    }
	e.preventDefault(); 
    this.menu.showAt(e.getXY());
});
	
addProduct=function(){
	alert("�������!");
	edit();
}

*/
