var KpiScoreTypeUrl = 'dhc.pa.kpiscoretypeexe.csp';
var KpiScoreTypeProxy = new Ext.data.HttpProxy({url:KpiScoreTypeUrl+'?action=list&active=Y'});
var userCode = session['LOGON.USERCODE'];

var KpiScoreTypeDs = new Ext.data.Store({
	proxy: KpiScoreTypeProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','KpiDr','KPIName','directScore','levelScore','active'
 
		]),
    remoteSort: true
});

KpiScoreTypeDs.setDefaultSort('rowid', 'DESC');


var addKpiScoreTypeButton = new Ext.Toolbar.Button({
		text: '��ʼ��',
		tooltip: '��ʼ��ָ������',
		iconCls: 'add',
		handler: function(){init();}
});

var editKpiScoreTypeButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ���ĵ����ʾ�ָ��',
		iconCls: 'remove',
		handler: function(){editKpiScoreTypeFun(KpiScoreTypeDs,KpiScoreTypeMain,KpiScoreTypePagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = KpiScoreTypeMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���ĵ����ʾ�ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KpiScoreTypeUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
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
var KpiScoreTypeCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: 'ָ������',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "ֱ�ӷ���",
			dataIndex: 'directScore',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: "�ȼ�����",
			dataIndex: 'levelScore',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
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
	
var KpiScoreTypeSearchField = 'Name';

var KpiScoreTypeFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: false,group: 'KpiScoreTypeFilter',checkHandler: onKpiScoreTypeItemCheck })
		]}
});

function onKpiScoreTypeItemCheck(item, checked)
{
		if(checked) {
				KpiScoreTypeSearchField = item.value;
				KpiScoreTypeFilterItem.setText(item.text + ':');
		}
};

var KpiScoreTypeSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				KpiScoreTypeDs.proxy = new Ext.data.HttpProxy({url: KpiScoreTypeUrl + '?action=list'});
				KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KpiScoreTypeDs.proxy = new Ext.data.HttpProxy({
				url: KpiScoreTypeUrl + '?action=list&searchField=' + KpiScoreTypeSearchField + '&searchValue=' + this.getValue()});
				KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
	    	}
		}
});
KpiScoreTypeDs.each(function(record){
    alert(record.get('tieOff'));

});
var KpiScoreTypePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: KpiScoreTypeDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',KpiScoreTypeFilterItem,'-',KpiScoreTypeSearchBox]
});

var KpiScoreTypeMain = new Ext.grid.EditorGridPanel({//���
		title: '�����ʾ�ָ��ά��',
		store: KpiScoreTypeDs,
		cm: KpiScoreTypeCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKpiScoreTypeButton,'-',editKpiScoreTypeButton,'-',delButton],
		bbar: KpiScoreTypePagingToolbar
});

init = function(){
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ��������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:KpiScoreTypeUrl+'?action=add',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'���ݳ�ʼ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
						}else{
							if(jsonData.info=='ERROR'){
								Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='No'){
								Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='false'){
								Ext.Msg.show({title:'��ʾ',msg:'��ǰս����ָ�����ͳ�ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
						}
					},
					scope: this
				});
			}
		}
	)
}
KpiScoreTypeMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=KpiScoreTypeDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KpiScoreTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
KpiScoreTypeMain.on("afteredit", afterEdit, KpiScoreTypeMain);    
KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
