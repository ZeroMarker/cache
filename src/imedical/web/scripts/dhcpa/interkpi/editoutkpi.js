var InterLocSetTabUrl = '../csp/dhc.pa.interlocsetexe.csp';
var outKpiUrl = '../csp/dhc.pa.outkpiruleexe.csp';
editFun = function(KPIGrid,outKpiDs,outKpiGrid,outKpiPagingToolbar){
	var rowObj = outKpiGrid.getSelections();
	var KPIObj = KPIGrid.getSelections();
	var KPIDr = KPIObj[0].get("rowid");
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的KPI指标记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		
	var interLocSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	interLocSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:InterLocSetTabUrl+'?action=list&searchValue='+encodeURIComponent(Ext.getCmp('interLocSetField').getRawValue())+'&searchField=name',method:'POST'})
	});

	var interLocSetField = new Ext.form.ComboBox({
		id: 'interLocSetField',
		fieldLabel:'接口套',
		width:230,
		listWidth : 230,
		allowBlank: false,
		store: interLocSetDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		valueNotFoundText:rowObj[0].get('locSetName'),
		triggerAction: 'all',
		emptyText:'请选择接口套...',
		//name: 'interLocSetField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
			
		var outkpiRuleDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','active'])
		});
	   
	   interLocSetField.on("select",function(cmb,rec,id){
					outkpiRuleDs.proxy=new Ext.data.HttpProxy({
						url:'dhc.pa.outkpiruleexe.csp?action=kpilist&locSetDr='+Ext.getCmp('interLocSetField').getValue()+'&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('outkpiRuleField').getRawValue()),method:'POST'})
					outkpiRuleDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,locSetDr:cmb.getValue()}});
		});
		outkpiRuleDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.outkpiruleexe.csp?action=kpilist&locSetDr='+Ext.getCmp('interLocSetField').getValue()+'&sort=rowid&dir=asc'+'&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('outkpiRuleField').getRawValue()),method:'POST'})
		});

		var outkpiRuleField = new Ext.form.ComboBox({
			id: 'outkpiRuleField',
			fieldLabel:'指标规则',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: outkpiRuleDs,
			valueField: 'rowid',
			displayField: 'name',
			valueNotFoundText:rowObj[0].get('name'),
			triggerAction: 'all',
			emptyText:'请选择指标规则中的指标...',
			//name: 'outkpiRuleField',			
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
		});
	
		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '备注',
			name: 'remark',
			allowBlank: true,
			//width:180,
			//listWidth : 180,
			emptyText:'备注...',
			anchor: '90%',
			selectOnFocus:'true'
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '有效标志:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false
		});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:80,
			items: [
				interLocSetField,
				outkpiRuleField,
				remarkField,
				activeField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			interLocSetField.setValue(rowObj[0].get("locSetDr"));
			//alert(rowObj[0].get("rowid"));
			outkpiRuleField.setValue(rowObj[0].get("kpirule"));
		});	
		
		interLocSetField.on("select",function(cmb,rec,id ){
		outkpiRuleDs.proxy=new Ext.data.HttpProxy({url:outKpiUrl+'?action=kpilist&locSetDr='+interLocSetField.getValue+'&sort=rowid&dir=asc'+'&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('outKPIRlueField').getRawValue())});
		outkpiRuleDs.load({params:{start:0, limit:outkpiRuleField.pageSize}});
		});
		var editButton = new Ext.Toolbar.Button({
			text:'修改'
		});
				
		//添加处理函数
		var editHandler = function(){
			   var locSetDr = Ext.getCmp('interLocSetField').getValue();
				var outKPIRlue = Ext.getCmp('outkpiRuleField').getValue();
				var remark = Ext.getCmp('remarkField').getValue();
				var active = (activeField.getValue()==true)?'Y':'N';
				locSetDr = trim(locSetDr);
				outKPIRlue = trim(outKPIRlue);
				remark = trim(remark);
				if(locSetDr==""){
					Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				if(outKPIRlue==""){
					Ext.Msg.show({title:'提示',msg:'请选择接口规则指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				var data = KPIDr+'^'+outKPIRlue+'^'+remark+'^'+active;

				var rowid=rowObj[0].get("rowid");
				Ext.Ajax.request({
					url:KPIUrl+'?action=edit&data='+encodeURIComponent(data)+'&rowid='+rowid,
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							outKpiDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
							win.close();
						}else{
							if(jsonData.info=='RepKPI'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
							if(jsonData.info=='rowidEmpt'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'提示',msg:'错误数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
							if(jsonData.info=='EmptyRecData'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'提示',msg:'输入数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
						}
					},
					scope: this
				});
		}

		//添加按钮的响应事件
		editButton.addListener('click',editHandler,false);

		//定义取消按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});

		//取消处理函数
		var cancelHandler = function(){
			win.close();
		}

		//取消按钮的响应事件
		cancelButton.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '修改KPI指标',
			width: 355,
			height:200,
			minWidth: 355,
			minHeight: 200,
			layout:'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		win.show();	
	}
}