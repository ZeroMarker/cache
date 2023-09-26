var JXQMLocTypeUrl = 'dhc.qm.jxloctypeexe.csp';
var JXQMLocTypeProxy = new Ext.data.HttpProxy({url: JXQMLocTypeUrl+'?action=list'});


var JXQMLocTypeDs = new Ext.data.Store({
	proxy: JXQMLocTypeProxy,
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

JXQMLocTypeDs.setDefaultSort('rowid', 'DESC');


var addJXQMLocTypeButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '�������������ҷ���',
		iconCls: 'add',
		handler: function(){addJXQMLocTypeFun(JXQMLocTypeDs,JXQMLocTypeMain,JXQMLocTypePagingToolbar);}
});

var delJXQMLocTypeButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ���Ŀ��ҷ���',
		iconCls: 'remove',
		handler: function(){delFun(JXQMLocTypeDs, JXQMLocTypeMain, JXQMLocTypePagingToolbar);}
});

var JXQMLocTypeCm = new Ext.grid.ColumnModel([
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



	
var JXQMLocTypeSearchField = 'Name';

var JXQMLocTypeFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'JXQMLocTypeFilter',checkHandler: onJXQMLocTypeItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'JXQMLocTypeFilter',checkHandler: onJXQMLocTypeItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'desc',checked: false,group: 'JXQMLocTypeFilter',checkHandler: onJXQMLocTypeItemCheck })
		]}
});

function onJXQMLocTypeItemCheck(item, checked)
{
		if(checked) {
				JXQMLocTypeSearchField = item.value;
				JXQMLocTypeFilterItem.setText(item.text + ':');
		}
};

var JXQMLocTypeSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				JXQMLocTypeDs.proxy = new Ext.data.HttpProxy({url: JXQMLocTypeUrl + '?action=list'});
				JXQMLocTypeDs.load({params:{start:0, limit:JXQMLocTypePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				JXQMLocTypeDs.proxy = new Ext.data.HttpProxy({
				url: JXQMLocTypeUrl + '?action=list&searchField=' + JXQMLocTypeSearchField + '&searchValue=' + this.getValue()});
				JXQMLocTypeDs.load({params:{start:0, limit:JXQMLocTypePagingToolbar.pageSize}});
	    	}
		}
});
JXQMLocTypeDs.each(function(record){
    alert(record.get('tieOff'));

});
var JXQMLocTypePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: JXQMLocTypeDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',JXQMLocTypeFilterItem,'-',JXQMLocTypeSearchBox]
});

var JXQMLocTypeMain = new Ext.grid.EditorGridPanel({//���
		title: '���ҷ���ά��',
		store: JXQMLocTypeDs,
		cm: JXQMLocTypeCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addJXQMLocTypeButton,'-',delJXQMLocTypeButton,'-'],
		bbar: JXQMLocTypePagingToolbar
});


JXQMLocTypeMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=JXQMLocTypeDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: JXQMLocTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
JXQMLocTypeMain.on("afteredit", afterEdit, JXQMLocTypeMain);    
JXQMLocTypeDs.load({params:{start:0, limit:JXQMLocTypePagingToolbar.pageSize}});
