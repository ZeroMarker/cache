var targetSetUrl = 'dhc.pa.targetsetexe.csp';
var targetSetProxy = new Ext.data.HttpProxy({url: targetSetUrl+'?action=list'});

var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

KPIDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:targetSetUrl+'?action=kpi&str='+encodeURIComponent(Ext.getCmp('KPIField').getRawValue()),method:'POST'})
});

var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel:'ָ��',
	width:220,
	listWidth : 220,
	allowBlank: false,
	store: KPIDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ָ��...',
	name: 'KPIField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var periodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
});

periodDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:targetSetUrl+'?action=period&start=0&str='+encodeURIComponent(Ext.getCmp('periodField').getRawValue())+'&limit='+targetSetPagingToolbar.pageSize,method:'POST'})
});
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '�����ڼ�',
	width:210,
	listWidth : 210,
	allowBlank: false,
	store: periodDs,
	valueField: 'period',
	displayField: 'period',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺��ڼ�...',
	name: 'periodField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeDataStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var pType = new Ext.form.ComboBox({
	id: 'pType',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeDataStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


pType.on("select",function(cmb,rec,id){
	//alert(Ext.getCmp('periodField').getRawValue());
	KPIDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,str:KPIField.getRawValue()}})
});

KPIField.on("select",function(cmb,rec,id){
	//alert(Ext.getCmp('periodField').getRawValue());
	targetSetDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
});

var targetSetDs = new Ext.data.Store({
	proxy: targetSetProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','jxUnitDr','jxUnitName','tValue','jxUnitCode','bValue','baseValue'
 
		]),
    remoteSort: true
});

targetSetDs.setDefaultSort('rowid', 'DESC');



var targetSetCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��Ч��Ԫ����',
			dataIndex: 'jxUnitCode',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: '��Ч��Ԫ����',
			dataIndex: 'jxUnitName',
			width:150,
			align: 'left',
			sortable: true

		},
		{
			header: 'Ŀ��ֵ',
			dataIndex: 'tValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		},
		{
			header: '���ֵ',
			dataIndex: 'bValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		},
		{
			header: '��׼ֵ',
			dataIndex: 'baseValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		}
	]);



	
var targetSetSearchField = 'Name';

var targetSetFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '��Ч��Ԫ����',value: 'jxUnitCode',checked: false,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ч��Ԫ����',value: 'jxUnitName',checked: true,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'tValue',checked: false,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck })
		]}
});

function ontargetSetItemCheck(item, checked)
{
		if(checked) {
				targetSetSearchField = item.value;
				targetSetFilterItem.setText(item.text + ':');
		}
};

var targetSetSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				targetSetDs.proxy = new Ext.data.HttpProxy({url: targetSetUrl + '?action=list'});
				targetSetDs.load({targetSets:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				targetSetDs.proxy = new Ext.data.HttpProxy({
				url: targetSetUrl + '?action=list&searchField=' + targetSetSearchField + '&searchValue=' + this.getValue()});
				targetSetDs.load({targetSets:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
	    	}
		}
});
targetSetDs.each(function(record){
    alert(record.get('tieOff'));

});
var targetSetPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: targetSetDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',targetSetFilterItem,'-',targetSetSearchBox],
		doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodField').getRawValue();
		B['frequency']=Ext.getCmp('pType').getValue();
		B['KPIDr']=Ext.getCmp('KPIField').getValue()
		B['dir']="asc";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	   }
});

var targetSetMain = new Ext.grid.EditorGridPanel({//���
		title: 'Ŀ��ֵ����',
		store: targetSetDs,
		cm: targetSetCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,
		tbar:['�ڼ�:',periodField,'-','�ڼ�����:',pType,'-','ָ��:',KPIField],
		bbar: targetSetPagingToolbar
});


////
function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=targetSetDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var tValue = mr[i].data["tValue"].trim();
				var bValue = mr[i].data["bValue"].trim();
				var baseValue = mr[i].data["baseValue"].trim();
                var KPIDr = KPIField.getValue().trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: targetSetUrl+'?action=edit&tValue='+tValue+'&bValue='+bValue+'&baseValue='+baseValue+'&rowid='+myRowid+'&KPIDr='+KPIDr,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								//Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									this.store.commitChanges(); //��ԭ�����޸���ʾ
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='NourRowid') message='��Ҫ�޸ĵ�rowidΪ��';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
targetSetMain.on("afteredit", afterEdit, targetSetMain);    
targetSetDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
