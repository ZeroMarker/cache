var CalUnitUrl = 'dhc.pa.catunitexe.csp';
var CalUnitProxy = new Ext.data.HttpProxy({url: CalUnitUrl+'?action=list'});


var CalUnitDs = new Ext.data.Store({
		proxy: CalUnitProxy,
		reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'shortcut',
			'desc',
			'active'
 
		]),
    remoteSort: true
});

CalUnitDs.setDefaultSort('rowid', 'DESC');


var addCalUnitButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µļ�����λ',
		iconCls: 'add',
		handler: function(){addCalUnitFun(CalUnitDs,CalUnitMain,CalUnitPagingToolbar);}
});

var editCalUnitButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ�������',
		iconCls: 'remove',
		handler: function(){editCalUnitFun(CalUnitDs,CalUnitMain,CalUnitPagingToolbar);}
});
var CalUnitCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })
		},
		{
			header: '����',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })

		},
		{
			header: '����',
			dataIndex: 'desc',
			width: 100,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })

		}
	]);
	
var CalUnitSearchField = 'Name';

var CalUnitFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'desc',checked: false,group: 'CalUnitFilter',checkHandler: onCalUnitItemCheck })
		]}
});

function onCalUnitItemCheck(item, checked)
{
		if(checked) {
				CalUnitSearchField = item.value;
				CalUnitFilterItem.setText(item.text + ':');
		}
};

var CalUnitSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				CalUnitDs.proxy = new Ext.data.HttpProxy({url: CalUnitUrl + '?action=list'});
				CalUnitDs.load({params:{start:0, limit:CalUnitPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				CalUnitDs.proxy = new Ext.data.HttpProxy({
				url: CalUnitUrl + '?action=list&searchField=' + CalUnitSearchField + '&searchValue=' + this.getValue()});
				CalUnitDs.load({params:{start:0, limit:CalUnitPagingToolbar.pageSize}});
	    	}
		}
});
CalUnitDs.each(function(record){
    alert(record.get('tieOff'));

});
var CalUnitPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: CalUnitDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',CalUnitFilterItem,'-',CalUnitSearchBox]
});

var CalUnitMain = new Ext.grid.EditorGridPanel({//���
		title: '������λ����',
		store: CalUnitDs,
		cm: CalUnitCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addCalUnitButton,'-'],
		bbar: CalUnitPagingToolbar
});


CalUnitMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
////
function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=CalUnitDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: CalUnitUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									this.store.commitChanges(); //��ԭ�����޸���ʾ
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
CalUnitMain.on("afteredit", afterEdit, CalUnitMain);    
CalUnitDs.load({params:{start:0, limit:CalUnitPagingToolbar.pageSize}});
