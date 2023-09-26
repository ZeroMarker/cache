var SurveyScoreUrl = 'dhc.pa.surveyscoreexe.csp';
var SurveyScoreProxy = new Ext.data.HttpProxy({url:SurveyScoreUrl+'?action=list&active=Y'});
var userCode = session['LOGON.USERCODE'];

var SurveyScoreDs = new Ext.data.Store({
	proxy: SurveyScoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','userDr','userName','unitDr','unitName','unitType','unitTypeName','acceptUnitDr','acceptUnitName','acceptUnitType','acceptUnitTypeName','kpiDr','KPIName','scoreLevelDr','scoreLevel','directScore','period','periodType','schemDr','schemName','active'
 
		]),
    remoteSort: true
});

SurveyScoreDs.setDefaultSort('rowid', 'DESC');


var addSurveyScoreButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '��ӵ����ʾ�ָ��',
		iconCls: 'add',
		handler: function(){addSurveyScoreFun(SurveyScoreDs,SurveyScoreMain,SurveyScorePagingToolbar);}
});

var editSurveyScoreButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ���ĵ����ʾ�ָ��',
		iconCls: 'remove',
		handler: function(){editSurveyScoreFun(SurveyScoreDs,SurveyScoreMain,SurveyScorePagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = SurveyScoreMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���ĵ����ʾ�ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:SurveyScoreUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//alert("ɾ���ɹ�!");
									SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize,active:"Y"}});
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
var SurveyScoreCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '�û�',
			dataIndex: 'userName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: '��ֿ���',
			dataIndex: 'unitName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: '��ֿ�������',
			dataIndex: 'unitTypeName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: '���ܿ���',
			dataIndex: 'acceptUnitName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: '���ܿ�������',
			dataIndex: 'acceptUnitTypeName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: 'ָ������',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "ֱ�ӷ���",
			dataIndex: 'directScore',
			width: 60,
			align: 'right',
			sortable: true
		},
		{
			header: "�ȼ�",
			dataIndex: 'scoreLevel',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header: "�ڼ�",
			dataIndex: 'period',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: "�ڼ�����",
			dataIndex: 'periodType',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'schemName',
			width: 100,
			align: 'left',
			sortable: true
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
	
var SurveyScoreSearchField = 'Name';

var SurveyScoreFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'active',checked: false,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck })
		]}
});

function onSurveyScoreItemCheck(item, checked)
{
		if(checked) {
				SurveyScoreSearchField = item.value;
				SurveyScoreFilterItem.setText(item.text + ':');
		}
};

var SurveyScoreSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				SurveyScoreDs.proxy = new Ext.data.HttpProxy({url: SurveyScoreUrl + '?action=list'});
				SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SurveyScoreDs.proxy = new Ext.data.HttpProxy({
				url: SurveyScoreUrl + '?action=list&searchField=' + SurveyScoreSearchField + '&searchValue=' + this.getValue()});
				SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
	    	}
		}
});
SurveyScoreDs.each(function(record){
    alert(record.get('tieOff'));

});
var SurveyScorePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: SurveyScoreDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',SurveyScoreFilterItem,'-',SurveyScoreSearchBox]
});

var SurveyScoreMain = new Ext.grid.EditorGridPanel({//���
		title: '�����ʾ�ָ����ϸ',
		store: SurveyScoreDs,
		cm: SurveyScoreCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addSurveyScoreButton,'-',editSurveyScoreButton,'-',delButton],
		bbar: SurveyScorePagingToolbar
});


SurveyScoreMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});


 
SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
