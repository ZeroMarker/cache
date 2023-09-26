editFun = function(ds,grid,pagingToolbar){
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var KPIDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	KPIDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPIProTabUrl+'?action=kpi&str='+toUTF8(Ext.getCmp('KPI').getRawValue())+'&userCode='+userCode,method:'POST'})
	});

	var KPI = new Ext.form.ComboBox({
		id:'KPI',
		fieldLabel:'ָ��',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:KPIDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		emptyText:'��ѡ��ָ��...',
		triggerAction:'all',
		name: 'KPI',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		valueNotFoundText:rowObj[0].get("KPIName"),
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(KPI.getValue()!=""){
						userField.focus();
					}else{
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'����',msg:'ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:70,
		items: [
			KPI
		]
	});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			KPI.setValue(rowObj[0].get("KPIDr"));
		});	
		
		editButton = new Ext.Toolbar.Button({
				text:'�޸�'
		});

		editHandler = function(){
			var kpidr = Ext.getCmp('KPI').getValue();
			if(kpidr==""){
				Ext.Msg.show({title:'��ʾ',msg:'ָ��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var data = kpidr;
			Ext.Ajax.request({
				url: KPIProTabUrl+'?action=edit&data='+data+'&rowid='+rowObj[0].get("rowid"),
				waitMsg: '�޸���...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,kpidr:kpidr,dir:'asc',sort:'rowid'}});
						window.close();
					}else{
						var message = "";
						if(jsonData.info=='RepRecode') message='ָ�����ݼ�¼�ظ�!';
						if(jsonData.info=='dataEmpt') message='������!';
						if(jsonData.info=='rowidEmpt') message='��������!';
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
		};
	
		editButton.addListener('click',editHandler,false);
		
		cancel = new Ext.Toolbar.Button({
			text:'�˳�'
		});
			
		cancelHandler1 = function(){
			window.close();
		}

		cancel.addListener('click',cancelHandler1,false);
			
		var window = new Ext.Window({
			title: '�޸�ƽ��ֵָ�����',
			width: 350,
			height:200,
			minWidth: 350,
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons:[editButton,cancel]
		});
		window.show();
	}
}