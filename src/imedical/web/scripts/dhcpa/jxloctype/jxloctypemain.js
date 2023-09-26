var JXLocTypeUrl = 'dhc.pa.jxloctypeexe.csp';
var JXLocTypeProxy = new Ext.data.HttpProxy({url: JXLocTypeUrl+'?action=list'});


var JXLocTypeDs = new Ext.data.Store({
	proxy: JXLocTypeProxy,
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

JXLocTypeDs.setDefaultSort('rowid', 'DESC');


var addJXLocTypeButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����¼�Ч���ҷ���',
		iconCls: 'add',
		handler: function(){addJXLocTypeFun(JXLocTypeDs,JXLocTypeMain,JXLocTypePagingToolbar);}
});

var delJXLocTypeButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ���Ŀ��ҷ���',
		iconCls: 'remove',
		handler: function(){delFun(JXLocTypeDs, JXLocTypeMain, JXLocTypePagingToolbar);}
});

var JXLocTypeCm = new Ext.grid.ColumnModel([
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



	
var JXLocTypeSearchField = 'Name';

var JXLocTypeFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'JXLocTypeFilter',checkHandler: onJXLocTypeItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'JXLocTypeFilter',checkHandler: onJXLocTypeItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'desc',checked: false,group: 'JXLocTypeFilter',checkHandler: onJXLocTypeItemCheck })
		]}
});

function onJXLocTypeItemCheck(item, checked)
{
		if(checked) {
				JXLocTypeSearchField = item.value;
				JXLocTypeFilterItem.setText(item.text + ':');
		}
};

var JXLocTypeSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				JXLocTypeDs.proxy = new Ext.data.HttpProxy({url: JXLocTypeUrl + '?action=list'});
				JXLocTypeDs.load({params:{start:0, limit:JXLocTypePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				JXLocTypeDs.proxy = new Ext.data.HttpProxy({
				url: JXLocTypeUrl + '?action=list&searchField=' + JXLocTypeSearchField + '&searchValue=' + this.getValue()});
				JXLocTypeDs.load({params:{start:0, limit:JXLocTypePagingToolbar.pageSize}});
	    	}
		}
});
JXLocTypeDs.each(function(record){
    alert(record.get('tieOff'));

});
var JXLocTypePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: JXLocTypeDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',JXLocTypeFilterItem,'-',JXLocTypeSearchBox]
});

var JXLocTypeMain = new Ext.grid.EditorGridPanel({//���
		title: '��Ч���ҷ���',
		store: JXLocTypeDs,
		cm: JXLocTypeCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addJXLocTypeButton,'-',delJXLocTypeButton,'-'],
		bbar: JXLocTypePagingToolbar
});


JXLocTypeMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=JXLocTypeDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: JXLocTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
JXLocTypeMain.on("afteredit", afterEdit, JXLocTypeMain);    
JXLocTypeDs.load({params:{start:0, limit:JXLocTypePagingToolbar.pageSize}});
