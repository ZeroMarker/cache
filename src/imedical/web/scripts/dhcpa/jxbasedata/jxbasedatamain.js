/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

var uploadUrl = 'http://10.0.1.142:8080/uploadexcel/uploadexcel';
//var uploadUrl = 'http://127.0.0.1:8080/uploadexcel/uploadexcel';
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
	width:130,
	listWidth : 200,
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
	width:130,
	listWidth : 200,
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
		'desc',
		'calUnitName'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
JXBaseDataTabDs.setDefaultSort('KPIName', 'desc');

//���ݿ�����ģ��
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.CheckboxSelectionModel(),
	
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
		width: 210,
		sortable: true
	}


	,{
		header: '������λ',
		dataIndex: 'calUnitName',
		width: 90,
		sortable: true,
		align: 'center'
	}



	,{
		header: "ʵ��ֵ",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right',
		editor:new Ext.form.TextField({
		
		//regex:/^\d$/, 
		//regex:/^[0-9]+\.{0,1}[0-9]{0,2}$/,
		regex:/[-]?\d+(?:\.\d+)?$/,
		
		regexText:"ֻ�ܹ���������",
		allowBlank:false
		
		
		})
		
		
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
var addButton = {
	text: '�������',
    tooltip:'���', 
	disabled:((userCode=='demo')||(userCode=='jx001'))?false:true,	
    iconCls:'add',
	handler:function(){
		addFun(Ext.getCmp('pType').getValue(),Ext.getCmp('periodField').getRawValue(),JXBaseDataTabDs,JXBaseDataTabPagingToolbar);
	}
};

//���밴ť
var importButton = {
	text: '����ӿ�����',
    tooltip:'����ӿ�����',
	disabled:((userCode=='demo')||(userCode=='jx001'))?false:true,	
    iconCls:'add',
	handler:function(){
	var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'���',
	width:200,
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
	
	
	
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '�����ڼ�',
			allowBlank: false,
			width:200,
			listWidth : 200,
			emptyText:'����д�����ڼ�...',
			anchor: '90%',
			selectOnFocus:'true'
		});

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
		});
		var PeriodType3 = new Ext.form.ComboBox({
			id: 'PeriodType3',
			fieldLabel: '�ڼ�����',
			width:200,
			listWidth : 200,
			allowBlank: false,
			store: periodTypeStore,
			//anchor: '90%',
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
		
				PeriodType3.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['01','1~6�ϰ���'],['02','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField1 = new Ext.form.ComboBox({
	id: 'periodField1',
	fieldLabel: '�ڼ�',
	width:200,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
		
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				cycleField,
				PeriodType3,
				periodField1
			]
		});
		
		//���尴ť
		var importB = new Ext.Toolbar.Button({
			text:'����'
		});
			
		//��Ӵ�����
		var importHandler = function(){
		var cycle = cycleField.getRawValue();
			var period = periodField1.getValue();
			period = trim(period);
			cycle=cycle.substr(0,4);
			var Period=cycle+period;
			//alert(Period);
			if(cycle==""){
				Ext.Msg.show({title:'��ʾ',msg:'���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var periodTypeDr = PeriodType3.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			//alert(Period+"^"+periodTypeDr);
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=import&period='+Period+'&periodType='+periodTypeDr,
				waitMsg:'�����..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
					    JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Period,periodType:periodTypeDr,dir:'asc',sort:'childSub',userID:userID}});
					
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
			height:180,
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
};


//�ֹ���ʼ����ť
var initButton = {
	text: '��ʼ������',
       tooltip:'��ʼ������',  
	
	disabled:userCode!='demo'?false:true,    
       iconCls:'add',
	handler:function(){
	var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'���',
	width:200,
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

		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
		});
		var PeriodType1= new Ext.form.ComboBox({
			id: 'PeriodType1',
			fieldLabel: '�ڼ�����',
			width:200,
			listWidth : 200,
			allowBlank: false,
			store: periodTypeStore,
			//anchor: '90%',
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
		
		
		
		PeriodType1.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6�ϰ���'],['2','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField1 = new Ext.form.ComboBox({
	id: 'periodField1',
	fieldLabel: '�ڼ�',
	width:200,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				cycleField,
				PeriodType1,
				periodField1
			]
		});
		
		//���尴ť
		var initB = new Ext.Toolbar.Button({
			text:'��ʼ��'
		});
			
		//��Ӵ�����
		var importHandler = function(){
			var cycle = cycleField.getRawValue();
			var period = periodField1.getValue();
			period = trim(period);
			
			var Period=cycle+period
			//alert(Period);
			if(cycle==""){
				Ext.Msg.show({title:'��ʾ',msg:'���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var periodTypeDr = PeriodType1.getValue();
			periodTypeDr = trim(periodTypeDr);
			if(periodTypeDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'dhc.pa.jxbasedataexe.csp?action=init&period='+Period+'&periodType='+periodTypeDr+'&userID='+userID,
				waitMsg:'�����..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'��ʼ���ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						
						
						//JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID}});
						JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Period,periodType:periodTypeDr,dir:'asc',sort:'childSub',userID:userID}});
					
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
		initB.addListener('click',importHandler,false);

		//����ȡ����ť
		var cancelB = new Ext.Toolbar.Button({
			text:'ȡ  ��'
		});

		//ȡ��������
		var cancelHandler = function(){
			win.close();
		}

		//ȡ����ť����Ӧ�¼�
		cancelB.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '���ݳ�ʼ��',
			width: 355,
			height:200,
			minWidth: 355,
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				initB,
				cancelB
			]
		});
		win.show();
	}
};

var aduitButton1  = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	disabled:userCode=='1'?false:true,
	iconCls:'remove',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
			
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
			
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����˵Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���?',
				function(btn) {
					if(btn == 'yes'){
					for(var i = 0; i < len; i++){
					
						Ext.Ajax.request({
							
						
							url:'dhc.pa.jxbasedataexe.csp?action=aduit&period='+period+'&periodType='+periodTypeDr+'&userCode='+userCode+'&rowid='+rowObj[i].get("rowid"),
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
								
								if (jsonData.info==100) {
								var message="û����Ҫ��˵����ݣ�";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="��˴���";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
					
					}
				}
				)
				
				}
	}
});
////////////////////ȡ����˰�ť/////////////////////////////////


var aduitButton  = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	disabled:userCode!='demo1'?false:true,
	iconCls:'remove',
	handler: function(){
			
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
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
								
								if (jsonData.info==100) {
								var message="û����Ҫ��˵����ݣ�";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="��˴���";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
				}
				)
	}
});


var CancelAduitButton  = new Ext.Toolbar.Button({
	text:'ȡ�����',
	tooltip:'ȡ�����',
	//disabled:(userCode!='demo')&(userCode!='512')?false:true,
	disabled:(userCode!='demo')?false:true,
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��ȡ����˵Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȡ��?',
				function(btn) {
					if(btn == 'yes'){
					for(var i = 0; i < len; i++){
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=canceladuit&rowid='+rowObj[i].get("rowid"),
							waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ȡ����˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
				}
	
				)
				}
	}
});
/////////////////////////////////////////////////

var CorrectButton  = new Ext.Toolbar.Button({
	text:'�޸�',
	tooltip:'�޸�',
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ���޸ĵĻ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		else{
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�޸�?',
				function(btn) {
					if(btn == 'yes'){
					if(rowObj[0].get("dataStateName") == '���ͨ��'){
					Ext.Msg.show({title:'ע��',msg:'���ͨ�������ݲ������޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return false;
					
					}
						else{
						CorrectFun(rowObj[0].get("rowid"),rowObj[0].get("parRefName"),rowObj[0].get("period"),rowObj[0].get("KPIName"),rowObj[0].get("actualValue"));
						}
					}
				}
				)
				}
	}
});
//////////////////���水ť//////////////////////////////////
//���尴ť
		var saveB = new Ext.Toolbar.Button({
			text:'����',
			tooltip:'����',
			iconCls:'remove',
	handler: function(){
	
			
		var rowObj = JXBaseDataTab.getStore().getModifiedRecords();  //��������޸ĵļ�¼ ��������
		var length=rowObj.length;
		
		if(length < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�񱣴�Ļ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
			
		else{

			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȷ��Ҫ����?',
					function(btn) {
						if(btn == 'yes'){
						
						
						for(var i = 0; i < length; i++){
							
							var aValue = rowObj[i].get("actualValue");
							aValue = trim(aValue);
							
							
							Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=update&rowid='+rowObj[i].get("rowid")+'&aValue='+aValue,
							waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'���ݱ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
									JXBaseDataTab.getStore().modified =[];  //���store���޸�������ļ�¼
								
								
								}else{
									var message="���ݱ���ʧ��";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
						}
						
						}
					}
					)
					
			}
	}
		});



////////////////////////////////////////////////////
//���밴ť
var excelButton = {
	text: '����excel����',
    tooltip:'����',
	//disabled:userCode=='demo1'?false:true,	
    iconCls:'add',
	handler:function(){importExcel()}
			
};
var delButton  = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	disabled:userCode=='demo'?false:true,
	iconCls:'remove',
	
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
					for(var i = 0; i < len; i++){
					
					
						if (rowObj[i].get("dataState")==1)
		
						{
			
							Ext.Msg.show({title:'����',msg:'���ͨ�������ݲ���ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return false;
						}
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
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
				}
			)
		}
	}
});




var delButton1  = new Ext.Toolbar.Button({
	text:'ɾ���ӿ�ָ��',
	tooltip:'ɾ���ӿ�ָ��',
	disabled:userCode=='demo'?false:true,
	iconCls:'remove',
	handler: function(){
		var rowObj = JXBaseDataTab.getSelections();
		var len = rowObj.length;
		
			var period = periodField.getValue();
			periodTypeDr = pType.getValue();
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			if(periodTypeDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};



			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��������?',
				function(btn) {
					if(btn == 'yes'){
					
					
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=del1&period='+period+'&periodType='+periodTypeDr,
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
									
									if (jsonData.info==100) {
								var message="û����Ҫɾ�������ݣ�";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else
								{
									var message="ɾ������";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								
								}
								}
							},
							scope: this
						
					
					
				}
			)
		
	}
});

}});


var initSum  = new Ext.Toolbar.Button({
	text:'���ɼ��ȡ����ꡢ������',
	tooltip:'���ɼ��ȡ����ꡢ������',
	disabled:false,
	iconCls:'add',
	handler: function(){
		var period = periodField.getValue();
			period = trim(period);
			//alert(period);
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
			if(periodTypeDr=="M"){
				Ext.Msg.show({title:'��ʾ',msg:'�������·�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=initSum&period='+period+'&periodType='+periodTypeDr+'&userID='+userID,
							waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'���ɳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
								}else{
								
								if (jsonData.info==100) {
								var message="û����Ҫ���ɵ����ݣ�";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if (jsonData.info=="re") {
								var message="���ڴ˴������·����ݣ�";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								else{
									var message="���ɴ���";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							},
							scope: this
						});
					}
				}
				)
	}
});


/**
//��ťȨ��
if(userCode!='demo')
{	addButton.setDisabled(true);
	importButton.setDisabled(true);
	aduitButton.setDisabled(true);
	CancelAduitButton.setDisabled(true);
	delButton.setDisabled(true);
	delButton1.setDisabled(true);  

};
**/


var addMenu = new Ext.menu.Menu({
    id: 'addMenu',
    items: [importButton,excelButton,addButton] //initButton,  
});
var addMenu = new Ext.Toolbar([{
    text: '��������',
    iconCls: 'add',
	//disabled:true,
    menu: addMenu
}]);





//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addButton,'-',
//initButton,'-',importButton,'-',excelButton,
//'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
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
			checked: false,
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
		    //alert(this.getValue());
			JXBaseDataTabDs.proxy = new Ext.data.HttpProxy({
				url: JXBaseDataTabUrl + '?action=list&searchField=' + JXBaseDataSearchField + '&searchValue=' + this.getValue()});
	        	JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),userID:userID}});
	    	}
	    else{
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
        B['userID']=userID;
		B['dir']="asc";
		B['sort']="childSub";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});



 var tbar1 = new Ext.Toolbar({  
                
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				
				{xtype:'label',text: '��ʾ��'}
				
				]  
            }) ; 
 var tbar2 = new Ext.Toolbar({  
				//height:25,
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '1.�����������->��ʼ�����ݣ���ע��ָ�����ƺͼ�����λ������дָ��ʵ��ֵ!'}
				//new Ext.form.TextField({  
                //    fieldLabel:"����"  
                //  width:100  
                    //height:30  
                //})
				]  
            }) ; 
			
 var tbar3 = new Ext.Toolbar({  
				
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '2.���ָ��ֵ�޸ģ�������д������λ������80%����дΪ80!'}
				
				]  
            }) ; 
			
			
var tbar4 = new Ext.Toolbar({  
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '3.�в���ָ��ֵΪ�Ƿ��꣬�����100��δ�����0����Ҫ��д����!'}
				
				]  
            }) ;


var tbar5 = new Ext.Toolbar({  
                renderTo: Ext.grid.GridPanel.tbar,  
                items:[
				{columnWidth:.01,xtype:''},
				{xtype:'label',text: '4.������д��ϣ������![ ����ˡ��ǰ����ڼ䡢�ڼ����͡�Ȩ���˵�������ݵģ����Բ���Ҫѡ�񣻡�ȡ����ˡ���Ҫѡ�����ݣ��������ȡ����ˣ�]'}
				
				]  
            }) ;






//���
var JXBaseDataTab = new Ext.grid.EditorGridPanel({
	title: '�������ݹ���',
	store: JXBaseDataTabDs,
	
	cm: JXBaseDataTabCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel(),
	loadMask: true,
	//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addButton,'-',initButton,'-',importButton,'-',excelButton,'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
	//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addMenu,'-',saveB,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addMenu,'-',initSum,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	 listeners : { 
       'render': function(){ 
            tbar1.render(this.tbar); 
			tbar2.render(this.tbar); 
			tbar3.render(this.tbar); 
			tbar4.render(this.tbar); 
			tbar5.render(this.tbar); 
        } 
     } ,



	bbar:JXBaseDataTabPagingToolbar
	});


JXBaseDataTab.on('cellclick',function( g, rowIndex, columnIndex, e ){

//alert(columnIndex);
JXBaseDataTabCm.setEditable (7,true);
	if(columnIndex==7){

	var tmpRec=JXBaseDataTab.getStore().data.items[rowIndex];


	if (tmpRec.data['dataState']==1)
		
		{
			JXBaseDataTabCm.setEditable (7,false);
			Ext.Msg.show({title:'����',msg:'���ͨ�������ݲ����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
			}
		
		}

});

//----------------------------------ʵ��ֵ�޸ĺ�ֱ�ӱ���---------------------------------------------------------


function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=JXBaseDataTabDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
       
				var actualValue = mr[i].data["actualValue"].trim();
             
				var myRowid = mr[i].data["rowid"].trim();
     }  
	Ext.Ajax.request({
							url:'dhc.pa.jxbasedataexe.csp?action=update&rowid='+myRowid+'&aValue='+actualValue,
							//waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									//Ext.Msg.show({title:'ע��',msg:'���ݱ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load({params:{start:0, limit:JXBaseDataTabPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),periodType:Ext.getCmp('pType').getValue(),dir:'asc',sort:'childSub',userID:userID }});
									//JXBaseDataTab.getStore().modified =[];  //���store���޸�������ļ�¼
								   //this.store.commitChanges(); 
								
								}else{
									var message="���ݱ���ʧ��,�������ݸ�ʽ��";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
	 
}
JXBaseDataTab.on("afteredit", afterEdit, JXBaseDataTab);    

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
