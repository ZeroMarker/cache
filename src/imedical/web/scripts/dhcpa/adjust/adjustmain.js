var ParamUrl = 'dhc.pa.adjustexe.csp';
var ParamProxy = new Ext.data.HttpProxy({url: ParamUrl+'?action=list'});
var StratagemTabUrl = '../csp/dhc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '��������',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
cycleField.on("select",function(cmb,rec,id ){
    stratagemDs.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=stratagem&cycle='+Ext.getCmp('cycleField').getValue()});
	stratagemDs.load({params:{start:0, limit:stratagemField.pageSize}});
});

var stratagemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

stratagemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:ParamUrl+'?action=stratagem&cycle='+Ext.getCmp('cycleField').getValue()})
});

var stratagemField = new Ext.form.ComboBox({
	id: 'stratagemField',
	fieldLabel: 'ս��',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: stratagemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ս��...',
	name: 'stratagemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
stratagemField.on("select",function(cmb,rec,id ){
    sunfind(cmb.getValue());    
});

function sunfind(str){
	ParamDs.proxy=new Ext.data.HttpProxy({url:ParamUrl+'?action=list&stratagem='+str});
	ParamDs.load({params:{start:0, limit:stratagemField.pageSize}});
};
var ParamDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'parId',
			'parRef',
			{name:'date',type:'date',dateFormat:'Y-m-d'},
			'yearName',
			'user',
			'userId',
			'info',
 
		]),
    remoteSort: true
});

ParamDs.setDefaultSort('rowid', 'DESC');



var ParamCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '���',
			dataIndex: 'yearName',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: 'ս��Ŀ��',
			dataIndex: 'parRef',
			width: 100,
			align: 'left',
			sortable: true			
		},
		{
			header: '������',
			dataIndex: 'user',
			width:100,
			align: 'left',
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'date',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '����˵��',
			dataIndex: 'info',
			width: 250,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextArea({
           })
		}
	]);
	
var ParamSearchField = 'name';

var ParamFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'info',checked: false,group: 'ParamFilter',checkHandler: onParamItemCheck })
		]}
});

function onParamItemCheck(item, checked)
{
		if(checked) {
				ParamSearchField = item.value;
				ParamFilterItem.setText(item.text + ':');
		}
};

var ParamSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				ParamDs.proxy = new Ext.data.HttpProxy({url: ParamUrl + '?action=list'});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				ParamDs.proxy = new Ext.data.HttpProxy({
				url: ParamUrl + '?action=list&searchField=' + ParamSearchField + '&searchValue=' + this.getValue()});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
	    	}
		}
});
ParamDs.each(function(record){
    alert(record.get('tieOff'));

});
var ParamPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: ParamDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',ParamFilterItem,'-',ParamSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µķ�������',
		iconCls: 'add',
		handler: function(){addAdjustFun(ParamDs,ParamMain,ParamPagingToolbar);
		}
});

var ParamMain = new Ext.grid.EditorGridPanel({//���
		title: 'ս�Ե�������',
		store: ParamDs,
		cm: ParamCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true, 
        tbar:['���:',cycleField,'-','ս��:',stratagemField,'-',addAdjustButton],		
		bbar: ParamPagingToolbar
});


ParamMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=ParamDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('stratagemField').getValue().trim()+"^"+userCode+"^"+mr[i].data["info"].trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: ParamUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
ParamMain.on("afteredit", afterEdit, ParamMain);    
ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
