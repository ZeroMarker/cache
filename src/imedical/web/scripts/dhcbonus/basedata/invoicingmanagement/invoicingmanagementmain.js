/**
  *name:tab of database
  *author:zhaoliguo
  *Date:2016-8-29
 */
 function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};
var InvoicingManagementTabUrl = '../csp/dhc.bonus.invoicingmanagementexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ

var InvoicingManagementTabProxy= new Ext.data.HttpProxy({url:InvoicingManagementTabUrl + '?action=list'});
var InvoicingManagementTabDs = new Ext.data.Store({
	proxy: InvoicingManagementTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	
		'rowid',
		'bonusYear',
		'bonusPeriod',
		'flag',
		'updateDate',
		'type',
		'flag1',
		{name:'updateDate',type:'date',dateFormat:'Y-m-d'},
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
InvoicingManagementTabDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ��
var InvoicingManagementTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '�������',
        dataIndex: 'bonusYear',
        width: 100,		  
        sortable: true
    },{
    	header: '�����·�',
        dataIndex: 'bonusPeriod',
        width: 100,
        sortable: true
    },{
    	header: '״̬',
        dataIndex: 'flag',
        width: 150,
        sortable: true
    },{
    	header: '����ʱ��',
        dataIndex: 'updateDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    }
    
]);

//��ʼ��Ĭ��������
InvoicingManagementTabCm.defaultSortable = true;


//��ʼ�������ֶ�
var InvoicingManagementSearchField ='name';

//����������
var InvoicingManagementFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '�������',
			value: 'bonusYear',
			checked: false ,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '�����·�',
			value: 'bonusPeriod',
			checked: true,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '״̬',
			value: 'flag',
			checked: true,
			group: 'InvoicingManagementFilter',
			
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����ʱ��',
			value: 'updateDate',
			checked: true,
			renderer:formatDate,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '״̬(����)',
			value: 'flag1',
			checked: true,
			
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		})
	]}
});

//����������Ӧ����
function onInvoicingManagementItemCheck (item, checked){
	if(checked) {
		InvoicingManagementSearchField = item.value;
		InvoicingManagementFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var InvoicingManagementSearchBox = new Ext.form.TwinTriggerField({
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
			InvoicingManagementTabDs.proxy = new Ext.data.HttpProxy({url:  InvoicingManagementTabUrl + '?action=list'});
			InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				InvoicingManagementTabDs.proxy = new Ext.data.HttpProxy({
				url: InvoicingManagementTabUrl + '?action=list&searchField=' + InvoicingManagementSearchField + '&searchValue=' + this.getValue()});
	        	InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
	    	}
	}
});

//�������
var accountingButton = new Ext.Toolbar.Button({
	text: '�������',
    tooltip:'�������ں�����',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=InvoicingManagementTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=0){
			Ext.Msg.show({title:'ע��',msg:'���ǡ������㡱״̬�����ܽ��к���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=accounting&rowid='+rowid,
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���������¼��?',handler);
	}
});

//ȡ������
var cancelaccountingButton = new Ext.Toolbar.Button({
	text: 'ȡ������',
    tooltip:'ȡ������󣬽���ָ��ɼ���¼���',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=InvoicingManagementTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=1){
			Ext.Msg.show({title:'ע��',msg:'���ǡ����㡱״̬������ȡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=cancelaccounting&rowid='+rowid,
						waitMsg:'ȡ��������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ȡ������ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ȡ������ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�Ը�����¼ȡ��������?',handler);
	}
});

//�������
var invoicingButton = new Ext.Toolbar.Button({
	text: '�������',
    tooltip:'���˺󣬽������ٺ���',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=InvoicingManagementTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=1){
			Ext.Msg.show({title:'ע��',msg:'���ǡ����㡱״̬�����ܽ��н���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=invoicing&rowid='+rowid,
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'���˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���˸�����¼��?',handler);
	}
});

//ȡ������
var cancelinvoicingButton = new Ext.Toolbar.Button({
	text: 'ȡ������',
    tooltip:'ȡ������',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=InvoicingManagementTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ�����˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=2){
			Ext.Msg.show({title:'ע��',msg:'����δ���ˣ�����ȡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=cancelinvoicing&rowid='+rowid,
						waitMsg:'ȡ��������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ȡ�����˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ȡ������ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�Ը�����¼ȡ��������?',handler);
	}
});



//��ҳ������
var InvoicingManagementTabPagingToolbar = new Ext.PagingToolbar({
    store: InvoicingManagementTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',InvoicingManagementFilterItem,'-',InvoicingManagementSearchBox]
	
	
});

//���
var InvoicingManagementTab = new Ext.grid.EditorGridPanel({
	title: '�����������',
	store: InvoicingManagementTabDs,
	cm: InvoicingManagementTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[accountingButton,'-',cancelaccountingButton,'-',invoicingButton,'-',cancelinvoicingButton],
	bbar:InvoicingManagementTabPagingToolbar
});
InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
