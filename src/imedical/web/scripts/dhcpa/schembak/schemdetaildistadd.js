addSchemDetailDistFun = function(dataStore,grid,pagingTool) {
if(schemedistField.getValue()==""){
  Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
  return false;
}
if(extremum.getValue()==""){
  Ext.Msg.show({title:'注意',msg:'请选择极值!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
  return false;
}

if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
var rangeDr = new Ext.form.ComboBox({
			id:'rangeDr',
			fieldLabel: '区间',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','区间1'],['2','区间2'],['3','区间3'],['4','区间4']]
			})			
		});
}
else{
var rangeDr = new Ext.form.ComboBox({
			id:'rangeDr',
			fieldLabel: '区间',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','区间1'],['2','区间2'],['3','区间3'],['4','区间4'],['5','区间5'],['6','区间6']]
			})			
		});
}	
	var SchemDetailDs = new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetail&&start=0&limit=25&schem='+schemedistField.getValue()+'&trend='+extremum.getValue()}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
	});
	SchemDetailDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetail&&start=0&limit=25&schem='+schemedistField.getValue()+'&trend='+extremum.getValue()});
	});

	var SchemDetailDrField = new Ext.form.ComboBox({
		id: 'SchemDetailDrField',
		fieldLabel: '方案明细',
		width:180,
		listWidth : 180,
		allowBlank: false,
		store: SchemDetailDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择方案明细...',
		name: 'SchemDetailDrField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});

	var scorelower = new Ext.form.TextField({
		id: 'scorelower',
		fieldLabel: '起始分',
		allowBlank: true,
		emptyText:'添加起始分...',
		anchor: '90%'
	});
	
	var scoreup = new Ext.form.TextField({
		id: 'scoreup',
		fieldLabel: '终止分',
		allowBlank: true,
		emptyText:'添加终止分...',
		anchor: '90%'
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
	        SchemDetailDrField,
			rangeDr,
			scorelower,
			scoreup			
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '设置区间',
    width: 400,
    height:300,
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
      		
			var rangeId = rangeDr.getValue();
			var lower = scorelower.getValue();
			var up = scoreup.getValue();
			var SchemDetailDr= SchemDetailDrField.getValue();
		
      		rangeId = rangeId.trim();
			lower = lower.trim();
			up = up.trim();
			SchemDetailDr = SchemDetailDr.trim();
      		
        	var data = rangeId+'^'+lower+'^'+up+'^'+SchemDetailDr;

			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=schemdetaildistadd&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepRange') message='区间已存在!';
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