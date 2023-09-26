/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

var uploadUrl = 'http://132.147.160.114:8080/uploadexcel/uploadexcel';
var userCode = session['LOGON.USERCODE'];
var userID = session['LOGON.USERID'];
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};


var periodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
});

periodDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.jxbasedataexe.csp?action=period&str='+Ext.getCmp('periodField').getRawValue(),method:'POST'})
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '�����ڼ�',
	width:210,
	listWidth : 210,
	allowBlank: false,
	store: periodDs,
	valueField: 'period',
	displayField: 'period',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺��ڼ�...',
	name: 'periodField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeDataStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var pType = new Ext.form.ComboBox({
	id: 'pType',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeDataStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


pType.on("select",function(cmb,rec,id){
	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID }});
});


 
//�������Դ
var JXBaseDataTabUrl = 'dhc.pa.jxbasedataexe.csp';
var JXBaseDataTabProxy= new Ext.data.HttpProxy({url:JXBaseDataTabUrl + '?action=list'});
var JXBaseDataTabDs = new Ext.data.Store({
	proxy: JXBaseDataTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'parRef',
		'parRefName',
		'rowid',
		'childSub',
		'period',
		'periodType',
		'periodTypeName',
		'KPIDr',
		'KPIName',
		'actualValue',
		'auditDate',
		'auditUserDr',
		'auditUserName',
		'dataState',
		'dataStateName',
		'desc'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
JXBaseDataTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "������Ч��Ԫ",
		dataIndex: 'parRefName',
		width: 130,
		sortable: true
	},{
		header: "�����ڼ�",
		dataIndex: 'period',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '�ڼ�����',
		dataIndex: 'periodTypeName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '����ָ��',
		dataIndex: 'KPIName',
		width: 170,
		sortable: true
	},{
		header: "ʵ��ֵ",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right'
	},{
		header: "���ʱ��",
		dataIndex: 'auditDate',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "�����Ա",
		dataIndex: 'auditUserName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "����״̬",
		dataIndex: 'dataStateName',
		width: 90,
		sortable: true,
		align: 'center'
	},
	{
		header: "����",
		dataIndex: 'desc',
		width:400,
		sortable: true,
		align: 'left'
	}
]);

//��ʼ��Ĭ��������
JXBaseDataTabCm.defaultSortable = true;

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
		addFun(Ext.getCmp('pType').getValue(),Ext.getCmp('periodField').getRawValue(),JXBaseDataTabDs,JXBaseDataTabPagingToolbar);
	}
});

//���밴ť
var importButton = new Ext.Toolbar.Button({
	text: '����ӿ�����',
    tooltip:'����ӿ�����',        
    iconCls:'add',
	handler:function(){
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '�����ڼ�',
			allowBlank: false,
			width:230,
			listWidth : 230,
			emptyText:'����д�����ڼ�...',
			anchor: '90%',
			selectOnFocus:'true'
		});

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
		});
		var PeriodType = new Ext.form.ComboBox({
			id: 'PeriodType',
			fieldLabel: '�ڼ�����',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: periodTypeStore,
			anchor: '90%',
			value:'', //Ĭ��ֵ
			valueNotFoundText:'',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ���ڼ�����...',
			mode: 'local', //����ģʽ
			editable:false,
			selectOnFocus: true,
			forceSelection: true
		});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				PeriodField,
				PeriodType
			]
		});
		
		//���尴ť
		var importB = new Ext.Toolbar.Button({
			text:'����'
		});
			
		//��Ӵ�����
		var importHandler = function(){
			var period = PeriodField.getValue();
			period = trim(period);
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var periodTypeDr = PeriodType.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=import&period='+period+'&periodType='+periodTypeDr,
				waitMsg:'�����..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						store.load({params:{start:0,limit:pagingToolbar.pageSize,parRef:parRef,period:periodValue,periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
					}else{
						if(jsonData.info==''){
							Ext.Msg.show({title:'��ʾ',msg:'���ݲ�����ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info==1){
							Ext.Msg.show({title:'����',msg:'���ݵ���ʧ��,�ѻع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				scope: this
			});
		}

		//��Ӱ�ť����Ӧ�¼�
		importB.addListener('click',importHandler,false);

		//����ȡ����ť
		var cancelB = new Ext.Toolbar.Button({
			text:'ȡ��'
		});

		//ȡ��������
		var cancelHandler = function(){
			win.close();
		}

		//ȡ����ť����Ӧ�¼�
		cancelB.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '����ӿ�����',
			width: 355,
			height:150,
			minWidth: 355,
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				importB,
				cancelB
			]
		});
		win.show();
	}
});

var aduitButton  = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'remove',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var periodTypeDr = pType.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=aduit&period='+period+'&periodType='+periodTypeDr+'&userCode='+userCode,
							waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
									var message="��˴���";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
				)
	}
});

var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'add',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
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

//��ʼ�������ֶ�
var JXBaseDataSearchField ='KPIName';

//����������
var JXBaseDataFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '��Ч��Ԫ',
			value: 'parRefName',
			checked: false ,
			group: 'JXBaseDataFilter',
			checkHandler: onJXBaseDataItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����ָ��',
			value: 'KPIName',
			checked: true,
			group: 'JXBaseDataFilter',
			checkHandler: onJXBaseDataItemCheck 
		})
	]}
});

//����������Ӧ����
function onJXBaseDataItemCheck(item, checked){
	if(checked) {
		JXBaseDataSearchField = item.value;
		JXBaseDataFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var JXBaseDataSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({url: JXBaseDataTabUrl + '?action=list'});
			JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({
				url: JXBaseDataTabUrl + '?action=list&searchField=' + JXBaseDataSearchField + '&searchValue=' + this.getValue()});
	        	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
	    	}
	}
});

//��ҳ������
var JXBaseDataTabPagingToolbar = new Ext.PagingToolbar({
    store: JXBaseDataTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',JXBaseDataFilterItem,'-',JXBaseDataSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodField').getRawValue();
		B['periodType']=Ext.getCmp('pType').getValue();
              B['userID']=userID
		B['dir']="asc";
		B['sort']="childSub";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
var JXBaseDataTab = new Ext.grid.GridPanel({
	title: '�������ݹ���',
	store: JXBaseDataTabDs,
	cm: JXBaseDataTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addButton,'-',importButton,'-',delButton],
	bbar:JXBaseDataTabPagingToolbar
});


