var userCode = session['LOGON.USERCODE'];
var DeptAuditUrl = 'dhc.pa.deptschemauditexe.csp';
var DeptAuditProxy = new Ext.data.HttpProxy({url: DeptAuditUrl+'?action=list'});
var DeptIndexProxy = new Ext.data.HttpProxy({url: DeptAuditUrl+'?action=name&start=0&parent=0&limit=25'});
var DeptAuditDs = new Ext.data.Store({
	proxy: DeptAuditProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'DSArowid','ssusr_name','dsc_name'
 
		]),
    remoteSort: true
});




DeptAuditDs.setDefaultSort('DSArowid', 'DESC');




var DeptAuditCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		
		{
			header: '�û�����',
			dataIndex: 'ssusr_name',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '�Բ�����',
			dataIndex: 'dsc_name',
			width: 150,
			align: 'left',
			sortable: true
		}
	]);
	
var DeptAuditSearchField = 'name';

var DeptAuditFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '�Բ�����',value: 'DSA_userDr',checked: false,group: 'DeptAuditFilter',checkHandler: onDeptAuditItemCheck }),
			new Ext.menu.CheckItem({ text: '�û�����',value: 'SSUSR_RowId',checked: false,group: 'DeptAuditFilter',checkHandler: onDeptAuditItemCheck })
		]}
});
function onDeptAuditItemCheck(item, checked)
{
		if(checked) {
				DeptAuditSearchField = item.value;
				DeptAuditFilterItem.setText(item.text + ':');
		}
}

var DeptAuditSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 100,
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
				DeptAuditDs.proxy = new Ext.data.HttpProxy({url:DeptAuditUrl + '?action=list'});
				DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				DeptAuditDs.proxy = new Ext.data.HttpProxy({
				url: DeptAuditUrl + '?action=list&searchField=' + DeptAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
	    	}
		}
});
DeptAuditDs.each(function(record){
    alert(record.get('tieOff'));

});
var DeptAuditPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: DeptAuditDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',DeptAuditFilterItem,'-',DeptAuditSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µķ���',
		iconCls: 'add',
		handler: function(){addSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});
var editAdjustButton = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸��µķ���',
		iconCls: 'add',
		handler: function(){editSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});
var delAdjustButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ��ķ���',
		iconCls: 'remove',
		handler: function(){delSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});

var DeptAuditMain = new Ext.grid.EditorGridPanel({//���
		title: '�Բ�Ȩ������',
		store: DeptAuditDs,
		cm: DeptAuditCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		width:550,
		//clicksToEdit: 2,
		stripeRows: true, 
        tbar:[addAdjustButton,editAdjustButton,delAdjustButton],		
		bbar: DeptAuditPagingToolbar
});


DeptAuditMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=DeptAuditDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   
               //var data = Ext.getCmp('editcom').getValue()+"^"+userCode;
               var Dept = Ext.getCmp('editcom').getValue();
				var userDr = userCode;
				
	 Ext.Ajax.request({
							url: DeptAuditUrl+'?action=edit&DschemDr='+Dept+'&DuserDr='+userDr+'&rowid='+myRowid,
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
									if(jsonData.info=='') message='���������Ϊ��!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
DeptAuditMain.on("afteredit", afterEdit, DeptAuditMain);  
DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
