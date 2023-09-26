scheme04AddFun = function() {

	var cycleDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'BonusYear'])
			});

	cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : StratagemTabUrl
									+ '?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});
			

			
	
			
	var BonusYearField = new Ext.form.ComboBox({
				id : 'cycle',
				fieldLabel : '�������',

				allowBlank : false,
				store : cycleDs,
				valueField : 'BonusYear',
				displayField : 'BonusYear',
				triggerAction : 'all',
				emptyText : '��ѡ��������...',
				//name : 'cycleField',
				//mode : 'local', // ����ģʽ
				minChars : 1,
				anchor : '100%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : true
				//editable : true
			});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','�·�'],['Q','����'],['H','����'],['Y','���']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:80,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '100%',
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

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['M01','01��'],['M02','02��'],['M03','03��'],['M04','04��'],['M05','05��'],['M06','06��'],['M07','07��'],['M08','08��'],['M09','09��'],['M10','10��'],['M11','11��'],['M12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['Q01','01����'],['Q02','02����'],['Q03','03����'],['Q04','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['H01','�ϰ���'],['H02','�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','00']];
	}
	periodStore.loadData(data);

});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '�����ڼ�',
	width:80,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '100%',
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

var AdjustDescField = new Ext.form.TextField({
	id: 'AdjustDescField',
	name:'AdjustDesc',
	fieldLabel: '����˵��',
	emptyText: '',
	anchor: '100%'
});

var schemeTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'�������',
	name:'type',
	store: schemeTypeSt,
	displayField:'name',
	allowBlank: false,
	valueField:'rowid',
	typeAhead: true,
	//mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

schemeTypeCombo.on('select',function(){
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue()+'&state=1',method:'GET'});
	schemeCombo.setRawValue('');
	schemeDs.load({params:{start:0, limit:10}});
	
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue()+'&state=1',method:'GET'});
});

var schemeCombo = new Ext.form.ComboBox({
	id: 'schemeCombo',
	name:'name',
	fieldLabel: '��������',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


schemeCombo.on('select',function(){
	bonusTarget1Ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme04exe.csp?action=targetlist&scheme='+schemeCombo.getValue(),method:'GET'});
	bonusTargetCombo.setRawValue('');
	bonusTarget1Ds.load({params:{start:0, limit:10}});
	
});

var bonusTarget1Ds = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','BonusTargetCode','BonusTargetName'])
});
bonusTarget1Ds.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme04exe.csp?action=targetlist&scheme='+schemeCombo.getValue(),method:'GET'});
});

var bonusTargetCombo = new Ext.form.ComboBox({
	//id: 'bonusTargetCombo',
	//name:'ParameterTargetName',
	fieldLabel: '�漰Ŀ��',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: bonusTarget1Ds,
	valueField: 'rowid',
	displayField: 'BonusTargetName',
	triggerAction: 'all',
	emptyText:'��ѡ',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			schemeTypeCombo,
			schemeCombo,
			BonusYearField,
			periodTypeField,
			periodField,
			//BonusPeriodField,
			AdjustDescField,
			bonusTargetCombo
		]
	});

	var addWin = new Ext.Window({
		title: '���',
		width: 300,
		height: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '����',
				handler: function() {
					if (formPanel.form.isValid()) {
						//BonusSchemeID^BonusPeriod^BonusYear^AdjustDesc^AdjustDate^BonusTargetID
						tmpData=schemeCombo.getValue()+"^"+periodField.getValue()+"^"+BonusYearField.getValue().trim()+"^"+AdjustDescField.getValue().trim()+"^"+dt+"^"+bonusTargetCombo.getValue();
						Ext.Ajax.request({
							url: schemeUrl+'?action=schemeadd&data='+tmpData,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									scheme04Ds.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'����', msg:tmpWrongName+'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: 'ȡ��',
				handler: function(){addWin.close();}
			}
		]
		
	});

	addWin.show();

};
