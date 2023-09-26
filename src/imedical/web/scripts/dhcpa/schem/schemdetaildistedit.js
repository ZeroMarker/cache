editSchemDetailDistFun = function(dataStore,grid,pagingTool) {
	//alert(grid);
	var centergrid = Ext.getCmp('SchemDetailDistGrid1');
	var rowObj = centergrid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}
	if(rowObj[0].get("calUnite")=="")
	{
		
		Ext.Msg.show({title:'注意',msg:'不能修改非末层!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
var monthField = new Ext.form.ComboBox({
			id:'monthField',
			fieldLabel: '考核频率',
			editable:false,
			name:'frequency',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			valueNotFoundText:rowObj[0].get('frequency'),
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
			})			
		});

var appSysDs = new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','全院'],['2','科室'],['3','护理'],['4','医疗'],['5','个人']]
			});		
var appSysField = new Ext.form.ComboBox({
			id:'appSysField',
			fieldLabel: '应用系统号',
			name:'appSysDr',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			forceSelection: true,
			valueNotFoundText:rowObj[0].get('appSysDr'),
			selectOnFocus: true,
			store:appSysDs	
		});

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
	ds.proxy=new Ext.data.HttpProxy({url:KPIIndexUrl+'?action=kpi&&start=0&limit=25'});
});

var KPIIndexField = new Ext.form.ComboBox({
	id: 'KPIIndexField',
	fieldLabel: '结果指标',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: KPIIndexDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	valueNotFoundText:rowObj[0].get('KPIName'),
	emptyText:'请选择指标...',
	name: 'KPIName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

	var lower1Field = new Ext.form.TextField({
		id: 'lower1Field',
		fieldLabel: '区间1起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower1',
		anchor: '90%'
	});

	var up1Field = new Ext.form.TextField({
		id: 'up1Field',
		fieldLabel: '区间1终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup1',
		anchor: '90%'
	});

	var lower2Field = new Ext.form.TextField({
		id: 'lower2Field',
		fieldLabel: '区间2起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower2',
		anchor: '90%'
	});

	var up2Field = new Ext.form.TextField({
		id: 'up2Field',
		fieldLabel: '区间2终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup2',
		anchor: '90%'
	});
	
	var lower3Field = new Ext.form.TextField({
		id: 'lower3Field',
		fieldLabel: '区间3起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower3',
		anchor: '90%'
	});

	var up3Field = new Ext.form.TextField({
		id: 'up3Field',
		fieldLabel: '区间3终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup3',
		anchor: '90%'
	});
	
	var lower4Field = new Ext.form.TextField({
		id: 'lower4Field',
		fieldLabel: '区间4起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower4',
		anchor: '90%'
	});

	var up4Field = new Ext.form.TextField({
		id: 'up4Field',
		fieldLabel: '区间4终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup4',
		anchor: '90%'
	});
	
	var lower5Field = new Ext.form.TextField({
		id: 'lower5Field',
		fieldLabel: '区间5起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower5',
		anchor: '90%'
	});

	var up5Field = new Ext.form.TextField({
		id: 'up5Field',
		fieldLabel: '区间5终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup5',
		anchor: '90%'
	});
	
	var lower6Field = new Ext.form.TextField({
		id: 'lower6Field',
		fieldLabel: '区间6起始分',
		//allowBlank: false,
		emptyText: '起始分...',
		name: 'scorelower6',
		anchor: '90%'
	});

	var up6Field = new Ext.form.TextField({
		id: 'up6Field',
		fieldLabel: '区间6终止分',
		//allowBlank: false,
		emptyText: '终止分...',
		name: 'scoreup6',
		anchor: '90%'
	});

	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){

	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			lower1Field,
            up1Field,
			lower2Field,
            up2Field,
			lower3Field,
            up3Field,
			lower4Field,
            up4Field
		]
	});
}
else{
   var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			lower1Field,
            up1Field,
			lower2Field,
            up2Field,
			lower3Field,
            up3Field,
			lower4Field,
            up4Field,
			lower5Field,
            up5Field,
			lower6Field,
            up6Field
		]
	});
}
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			lower1Field.setValue(rowObj[0].get("scorelower1"));
			up1Field.setValue(rowObj[0].get("scoreup1"));
			lower2Field.setValue(rowObj[0].get("scorelower2"));
			up2Field.setValue(rowObj[0].get("scoreup2"));
			lower3Field.setValue(rowObj[0].get("scorelower3"));
			up3Field.setValue(rowObj[0].get("scoreup3"));
			lower4Field.setValue(rowObj[0].get("scorelower4"));
			up4Field.setValue(rowObj[0].get("scoreup4"));
			lower5Field.setValue(rowObj[0].get("scorelower5"));
			up5Field.setValue(rowObj[0].get("scoreup5"));
			lower6Field.setValue(rowObj[0].get("scorelower6"));
			up6Field.setValue(rowObj[0].get("scoreup6"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改绩效方案',
    width: 400,
    height:400,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      	// check form value
      		var lower1=lower1Field.getValue();
            var up1=up1Field.getValue();
			var lower2=lower2Field.getValue();
            var up2=up2Field.getValue();
			var lower3=lower3Field.getValue();
            var up3=up3Field.getValue();
			var lower4=lower4Field.getValue();
            var up4=up4Field.getValue();
			
			var lower1=lower1.trim();
            var up1=up1.trim();
			var lower2=lower2.trim();
            var up2=up2.trim();
			var lower3=lower3.trim();
            var up3=up3.trim();
			var lower4=lower4.trim();
            var up4=up4.trim();
			var data = lower1+"^"+up1+"^"+lower2+"^"+up2+"^"+lower3+"^"+up3+"^"+lower4+"^"+up4;
			
			if(extremum.getValue()=='M'){
			var lower5=lower5Field.getValue();
            var up5=up5Field.getValue();
			var lower6=lower6Field.getValue();
            var up6=up6Field.getValue();
			
			var lower5=lower5.trim();
            var up5=up5.trim();
			var lower6=lower6.trim();
            var up6=up6.trim();
			var data = data+"^"+lower5+"^"+up5+"^"+lower6+"^"+up6;
			}
     	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=schemdetaildistedit&data='+data+'&schem='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								    dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });
    window.show();
};