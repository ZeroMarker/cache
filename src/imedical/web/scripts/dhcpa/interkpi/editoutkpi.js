var InterLocSetTabUrl = '../csp/dhc.pa.interlocsetexe.csp';
var outKpiUrl = '../csp/dhc.pa.outkpiruleexe.csp';
editFun = function(KPIGrid,outKpiDs,outKpiGrid,outKpiPagingToolbar){
	var rowObj = outKpiGrid.getSelections();
	var KPIObj = KPIGrid.getSelections();
	var KPIDr = KPIObj[0].get("rowid");
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�KPIָ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		fieldLabel:'�ӿ���',
		width:230,
		listWidth : 230,
		allowBlank: false,
		store: interLocSetDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		valueNotFoundText:rowObj[0].get('locSetName'),
		triggerAction: 'all',
		emptyText:'��ѡ��ӿ���...',
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
			fieldLabel:'ָ�����',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: outkpiRuleDs,
			valueField: 'rowid',
			displayField: 'name',
			valueNotFoundText:rowObj[0].get('name'),
			triggerAction: 'all',
			emptyText:'��ѡ��ָ������е�ָ��...',
			//name: 'outkpiRuleField',			
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
		});
	
		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '��ע',
			name: 'remark',
			allowBlank: true,
			//width:180,
			//listWidth : 180,
			emptyText:'��ע...',
			anchor: '90%',
			selectOnFocus:'true'
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '��Ч��־:',
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
			text:'�޸�'
		});
				
		//��Ӵ�����
		var editHandler = function(){
			   var locSetDr = Ext.getCmp('interLocSetField').getValue();
				var outKPIRlue = Ext.getCmp('outkpiRuleField').getValue();
				var remark = Ext.getCmp('remarkField').getValue();
				var active = (activeField.getValue()==true)?'Y':'N';
				locSetDr = trim(locSetDr);
				outKPIRlue = trim(outKPIRlue);
				remark = trim(remark);
				if(locSetDr==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				if(outKPIRlue==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿڹ���ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				var data = KPIDr+'^'+outKPIRlue+'^'+remark+'^'+active;

				var rowid=rowObj[0].get("rowid");
				Ext.Ajax.request({
					url:KPIUrl+'?action=edit&data='+encodeURIComponent(data)+'&rowid='+rowid,
					waitMsg:'�����..',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							outKpiDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
							win.close();
						}else{
							if(jsonData.info=='RepKPI'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
							if(jsonData.info=='rowidEmpt'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
							if(jsonData.info=='EmptyRecData'){
								Handler = function(){CodeField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
						}
					},
					scope: this
				});
		}

		//��Ӱ�ť����Ӧ�¼�
		editButton.addListener('click',editHandler,false);

		//����ȡ����ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});

		//ȡ��������
		var cancelHandler = function(){
			win.close();
		}

		//ȡ����ť����Ӧ�¼�
		cancelButton.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '�޸�KPIָ��',
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