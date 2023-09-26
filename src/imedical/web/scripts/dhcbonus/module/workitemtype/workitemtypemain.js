var WorkItemTypeUrl = 'dhc.bonus.module.WorkItemTypeexe.csp';
var WorkItemTypeProxy = new Ext.data.HttpProxy({url: WorkItemTypeUrl+'?action=list'});


var WorkItemTypeDs = new Ext.data.Store({
	proxy:WorkItemTypeProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			
 
		]),
    remoteSort: true
});

WorkItemTypeDs.setDefaultSort('rowid', 'DESC');


var addWorkItemTypeButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '�����Ŀ���',
		iconCls: 'add',
		handler: function(){addWorkItemTypeFun(WorkItemTypeDs,WorkItemTypeMain,WorkItemTypePagingToolbar);}
});

var delWorkItemTypeButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ������Ŀ���',
		iconCls: 'remove',
		handler: function(){delFun(WorkItemTypeDs,WorkItemTypeMain,WorkItemTypePagingToolbar);}
});

var WorkItemTypeCm = new Ext.grid.ColumnModel([
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

		}

	]);



	
var WorkItemTypeSearchField = 'Name';

var WorkItemTypeFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'WorkItemTypeFilter',checkHandler: onWorkItemTypeItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'WorkItemTypeFilter',checkHandler: onWorkItemTypeItemCheck })
		]}
});

function onWorkItemTypeItemCheck(item, checked)
{
		if(checked) {
				WorkItemTypeSearchField = item.value;
				WorkItemTypeFilterItem.setText(item.text + ':');
		}
};

var WorkItemTypeSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				WorkItemTypeDs.proxy = new Ext.data.HttpProxy({url:WorkItemTypeUrl + '?action=list'});
				WorkItemTypeDs.load({params:{start:0, limit:WorkItemTypePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {     
			if(this.getValue()) {
				WorkItemTypeDs.proxy = new Ext.data.HttpProxy({
				url:WorkItemTypeUrl + '?action=list&searchField=' +WorkItemTypeSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				WorkItemTypeDs.load({params:{start:0, limit:WorkItemTypePagingToolbar.pageSize}});
	    	}
		}
});
WorkItemTypeDs.each(function(record){
    alert(record.get('tieOff'));

});
var WorkItemTypePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store:WorkItemTypeDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',WorkItemTypeFilterItem,'-',WorkItemTypeSearchBox]
});

var WorkItemTypeMain = new Ext.grid.EditorGridPanel({//���
		title: '������',
		store:WorkItemTypeDs,
		cm:WorkItemTypeCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addWorkItemTypeButton,'-',delWorkItemTypeButton,'-'],
		bbar:WorkItemTypePagingToolbar
});


WorkItemTypeMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=WorkItemTypeDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim();
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url:WorkItemTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
WorkItemTypeMain.on("afteredit", afterEdit,WorkItemTypeMain);    
WorkItemTypeDs.load({params:{start:0, limit:WorkItemTypePagingToolbar.pageSize}});
