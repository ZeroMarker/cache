schemeEditFun = function() {

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
				fieldLabel : '核算年度',
				name:'BonusYear',
				allowBlank : false,
				store : cycleDs,
				valueField : 'BonusYear',
				displayField : 'BonusYear',
				triggerAction : 'all',
				emptyText : '请选择核算年度...',
				mode : 'local', // 本地模式
				minChars : 1,
				anchor : '100%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : true
				//editable : true
			});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月份'],['Q','季度'],['H','半年'],['Y','年度']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	//allowBlank: false,
	store: periodTypeStore,
	anchor: '100%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['M01','01月'],['M02','02月'],['M03','03月'],['M04','04月'],['M05','05月'],['M06','06月'],['M07','07月'],['M08','08月'],['M09','09月'],['M10','10月'],['M11','11月'],['M12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['Q01','01季度'],['Q02','02季度'],['Q03','03季度'],['Q04','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['H01','上半年'],['H02','下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
	//id: 'periodField',
	fieldLabel: '所属期间',
	name:'BonusPeriod',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '100%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var AdjustDescField = new Ext.form.TextField({
	id: 'AdjustDescField',
	name:'AdjustDesc',
	fieldLabel: '调整说明',
	emptyText: '',
	anchor: '100%'
});

var schemeTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'方案类别',
	name:'type',
	store: schemeTypeSt,
	displayField:'name',
	//allowBlank: false,
	valueField:'rowid',
	typeAhead: true,
	mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'方案类别',
	selectOnFocus:true,
	anchor: '100%'
});

schemeTypeCombo.on('select',function(){
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue(),method:'GET'});
	schemeCombo.setRawValue('');
	schemeDs.load({params:{start:0, limit:10}});
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue(),method:'GET'});
});

var schemeCombo = new Ext.form.ComboBox({
	id: 'schemeCombo',
	name:'BonusSchemeName',
	fieldLabel: '方案名称',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'必选',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var bonusTargetCombo = new Ext.form.ComboBox({
	id: 'bonusTargetCombo',
	name:'BonusTargetName',
	fieldLabel: '参数指标',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: bonusTargetDs,
	valueField: 'rowid',
	displayField: 'BonusTargetName',
	triggerAction: 'all',
	emptyText:'必选',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true//,
	//forceSelection: true
});
	
	var rowObj = scheme04Main.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	var tmpRowid2 = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("rowid");
		tmpRowid2 = rowObj[0].get("rowid2");
	}

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
	
	var t1=rowObj[0].get("BonusSchemeID");		//
	var t2=rowObj[0].get("BonusTargetID");	
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

	var editWin = new Ext.Window({
		title: '修改',
		width: 300,
		height: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			id:'saveButton',
			text: '保存',
			handler: function() {
				if (formPanel.form.isValid()) {
					
					if(schemeCombo.getValue()!=schemeCombo.getRawValue()){      //                                                          //
						t1=schemeCombo.getValue();                                  //                                                          //
					}      
					if(bonusTargetCombo.getValue()!=bonusTargetCombo.getRawValue()){      //                                                          //
						t2=bonusTargetCombo.getValue();                                  //                                                          //
					}    
					
					tmpData=t1+"^"+periodField.getValue()+"^"+BonusYearField.getValue().trim()+"^"+AdjustDescField.getValue().trim()+"^"+dt+"^"+t2;
					Ext.Ajax.request({
						url: schemeUrl+'?action=schemeedit&data='+tmpData+'&rowid='+tmpRowid+'&rowid2='+tmpRowid2,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								scheme04Ds.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
								editWin.close();
							}
							else
							{
								Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: '取消',
			handler: function(){editWin.close();}
		}]
	});

	editWin.show();
};