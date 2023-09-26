var JXQMConditionUrl = 'dhc.qm.conditionexe.csp';
var JXQMConditionProxy = new Ext.data.HttpProxy({url: JXQMConditionUrl+'?action=list'});


var JXQMConditionDs = new Ext.data.Store({
	proxy: JXQMConditionProxy,
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

JXQMConditionDs.setDefaultSort('rowid', 'DESC');


var addJXQMConditionButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���������������',
		iconCls: 'add',
		handler: function(){addJXQMConditionFun(JXQMConditionDs,JXQMConditionMain,JXQMConditionPagingToolbar);}
});

var delJXQMConditionButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ��������',
		iconCls: 'remove',
		handler: function(){delFun(JXQMConditionDs, JXQMConditionMain, JXQMConditionPagingToolbar);}
});

var JXQMConditionCm = new Ext.grid.ColumnModel([
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



	
var JXQMConditionSearchField = 'Name';

var JXQMConditionFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'desc',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck })
		]}
});

function onJXQMConditionItemCheck(item, checked)
{
		if(checked) {
				JXQMConditionSearchField = item.value;
				JXQMConditionFilterItem.setText(item.text + ':');
		}
};

var JXQMConditionSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				JXQMConditionDs.proxy = new Ext.data.HttpProxy({url: JXQMConditionUrl + '?action=list'});
				JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				JXQMConditionDs.proxy = new Ext.data.HttpProxy({
				url: JXQMConditionUrl + '?action=list&searchField=' + JXQMConditionSearchField + '&searchValue=' + this.getValue()});
				JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
	    	}
		}
});
JXQMConditionDs.each(function(record){
    alert(record.get('tieOff'));

});
var JXQMConditionPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: JXQMConditionDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',JXQMConditionFilterItem,'-',JXQMConditionSearchBox]
});

var JXQMConditionMain = new Ext.grid.EditorGridPanel({//���
		title: '����ά��',
		store: JXQMConditionDs,
		cm: JXQMConditionCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addJXQMConditionButton,'-',delJXQMConditionButton,'-'],
		bbar: JXQMConditionPagingToolbar
});


JXQMConditionMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=JXQMConditionDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: JXQMConditionUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
JXQMConditionMain.on("afteredit", afterEdit, JXQMConditionMain);    
JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
