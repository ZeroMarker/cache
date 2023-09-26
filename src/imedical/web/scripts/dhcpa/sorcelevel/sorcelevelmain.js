var SorceLevelUrl = 'dhc.pa.sorcelevelexe.csp';
var SorceLevelProxy = new Ext.data.HttpProxy({url:SorceLevelUrl+'?action=list&active=Y'});


var SorceLevelDs = new Ext.data.Store({
	proxy: SorceLevelProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'sorce',
			'code',
			'name',
			'shortcut',
			'py',
			'active'
 
		]),
    remoteSort: true
});

SorceLevelDs.setDefaultSort('rowid', 'DESC');


var addSorceLevelButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µĵȼ���',
		iconCls: 'add',
		handler: function(){addSorceLevelFun(SorceLevelDs,SorceLevelMain,SorceLevelPagingToolbar);}
});

var editSorceLevelButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ���ĵȼ�',
		iconCls: 'remove',
		handler: function(){editSorceLevelFun(SorceLevelDs,SorceLevelMain,SorceLevelPagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = SorceLevelMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:SorceLevelUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
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
var SorceLevelCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '��ݼ�',
			dataIndex: 'py',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'sorce',
			width: 200,
			align: 'left',
			sortable: true
		},{
			header: "��Ч��־",
			dataIndex: 'active',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		}
	]);
	
var SorceLevelSearchField = 'Name';

var SorceLevelFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'SorceLevelFilter',checkHandler: onSorceLevelItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'SorceLevelFilter',checkHandler: onSorceLevelItemCheck })
		]}
});

function onSorceLevelItemCheck(item, checked)
{
		if(checked) {
				SorceLevelSearchField = item.value;
				SorceLevelFilterItem.setText(item.text + ':');
		}
};

var SorceLevelSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				SorceLevelDs.proxy = new Ext.data.HttpProxy({url: SorceLevelUrl + '?action=list'});
				SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SorceLevelDs.proxy = new Ext.data.HttpProxy({
				url: SorceLevelUrl + '?action=list&searchField=' + SorceLevelSearchField + '&searchValue=' + this.getValue()});
				SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
	    	}
		}
});
SorceLevelDs.each(function(record){
    alert(record.get('tieOff'));

});
var SorceLevelPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: SorceLevelDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',SorceLevelFilterItem,'-',SorceLevelSearchBox]
});

var SorceLevelMain = new Ext.grid.EditorGridPanel({//���
		title: '�ȼ�������',
		store: SorceLevelDs,
		cm: SorceLevelCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addSorceLevelButton,'-',editSorceLevelButton,'-',delButton],
		bbar: SorceLevelPagingToolbar
});


SorceLevelMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=SorceLevelDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: SorceLevelUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
SorceLevelMain.on("afteredit", afterEdit, SorceLevelMain);    
SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
