var userCode = session['LOGON.USERCODE'];


var KPIAuditUrl = 'dhc.pa.kpiauditexe.csp';
var KPIAuditProxy = new Ext.data.HttpProxy({url: KPIAuditUrl+'?action=list'});
var KPIIndexUrl = 'dhcc.pa.kpiindexexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIAuditUrl+'?action=kpi&start=0&parent=0&limit=25'});
var KPIAuditDs = new Ext.data.Store({
	proxy: KPIAuditProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','KPIDr','KPIName','UserDr','UserName'
 
		]),
    remoteSort: true
});


//alert(KPIAuditDs.getAt(2));

KPIAuditDs.setDefaultSort('rowid', 'DESC');


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
	ds.proxy=new Ext.data.HttpProxy({
		url:KPIAuditUrl+'?action=kpi&start=0&parent=0&limit=25'});
});

var KPIAuditCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: 'KPIָ��',
			dataIndex: 'KPIName',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '�û���',
			dataIndex: 'UserName',
			width: 150,
			align: 'left',
			sortable: true
		}
	]);
	
var KPIAuditSearchField = 'name';

var KPIAuditFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '�û���',value: 'UserDr',checked: false,group: 'KPIAuditFilter',checkHandler: onKPIAuditItemCheck }),
			new Ext.menu.CheckItem({ text: 'KPIָ��',value: 'KPIDr',checked: false,group: 'KPIAuditFilter',checkHandler: onKPIAuditItemCheck })
		]}
});

function onKPIAuditItemCheck(item, checked)
{
		if(checked) {
				KPIAuditSearchField = item.value;
				KPIAuditFilterItem.setText(item.text + ':');
		}
}

var KPIAuditSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				KPIAuditDs.proxy = new Ext.data.HttpProxy({url: KPIAuditUrl + '?action=list'});
				KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPIAuditDs.proxy = new Ext.data.HttpProxy({
				url: KPIAuditUrl + '?action=list&searchField=' + KPIAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
	    	}
		}
});
KPIAuditDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPIAuditPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: KPIAuditDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',KPIAuditFilterItem,'-',KPIAuditSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µķ���',
		iconCls: 'add',
		handler: function(){addSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});
var editAdjustButton = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸��µķ���',
		iconCls: 'add',
		handler: function(){editSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});
var delAdjustButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��ѡ��ķ���',
		iconCls: 'remove',
		handler: function(){delSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});

var KPIAuditMain = new Ext.grid.EditorGridPanel({//���
		title: '�û�KPIȨ������',
		store: KPIAuditDs,
		cm: KPIAuditCm,
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
		bbar: KPIAuditPagingToolbar
});


KPIAuditMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=KPIAuditDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('editcom').getValue()+"^"+userCode;
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KPIAuditUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
									if(jsonData.info=='RepKPI') message='�����KPI�Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
KPIAuditMain.on("afteredit", afterEdit, KPIAuditMain);  
KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
