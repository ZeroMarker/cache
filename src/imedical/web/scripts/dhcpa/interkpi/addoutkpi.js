function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addFun = function(KPIGrid,outKpiDs,outKpiGrid,outKpiPagingToolbar){
	
		var rowObj=KPIGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ���յ�ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			var KPIDr=rowObj[0].get("rowid");
			var locSetDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});

			locSetDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.interperiodexe.csp?action=locset&str='+encodeURIComponent(Ext.getCmp('locSetField').getRawValue()),method:'POST'})
			});

			var locSetField = new Ext.form.ComboBox({
				id: 'locSetField',
				fieldLabel:'�ӿ���',
				width:230,
				listWidth : 230,
				allowBlank: false,
				store: locSetDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'��ѡ��ӿ���...',
				name:'locSetField',
				minChars:1,
				pageSize:10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});
					
			locSetField.on("select",function(cmb,rec,id){
				outKPIRlueDs.proxy=new Ext.data.HttpProxy({
					url:'dhc.pa.outkpiruleexe.csp?action=kpilist&locSetDr='+Ext.getCmp('locSetField').getValue()+'&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('outKPIRlueField').getRawValue()),method:'POST'})
				outKPIRlueDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,locSetDr:cmb.getValue()}});
			});
			
			var outKPIRlueDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
			});

			outKPIRlueDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'dhc.pa.outkpiruleexe.csp?action=kpilist&locSetDr='+Ext.getCmp('locSetField').getValue()+'&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('outKPIRlueField').getRawValue()),method:'POST'})
			});

			var outKPIRlueField = new Ext.form.ComboBox({
				id: 'outKPIRlueField',
				fieldLabel:'ָ�����',
				width:230,
				listWidth : 230,
				allowBlank: false,
				store: outKPIRlueDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'��ѡ��ָ�����...',
				name:'outKPIRlueField',
				minChars:1,
				pageSize:10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});
					
			
			var remarkField = new Ext.form.TextField({
				id:'remarkField',
				fieldLabel: '��ע',
				allowBlank: true,
				//width:140,
				//listWidth : 140,
				emptyText:'��ע...',
				anchor: '90%',
				selectOnFocus:'true'
			});
		
			var formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth:60,
				items: [
					locSetField,
					outKPIRlueField,
					remarkField
				]
			});
		
			var addButton = new Ext.Toolbar.Button({
				text:'���'
			});
					
			//��Ӵ�����
			var addHandler = function(){
				
				var locSetDr = Ext.getCmp('locSetField').getValue();
				var outKPIRlue = Ext.getCmp('outKPIRlueField').getValue();
				var remark = Ext.getCmp('remarkField').getValue();
				locSetDr = trim(locSetDr);
				outKPIRlue = trim(outKPIRlue);
				remark = trim(remark);
				if(locSetDr==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				if(outKPIRlue==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				var data = KPIDr+'^'+outKPIRlue+'^'+encodeURIComponent(remark);
				Ext.Ajax.request({
					url:KPIUrl+'?action=add&data='+data,
					waitMsg:'�����..',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize,locSetDr:locSetDr,dir:'asc',sort:'rowid'}});
						}else{
							if(jsonData.info=='RepKPI'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
						}
					},
					scope: this
				});
			}

			//��Ӱ�ť����Ӧ�¼�
			addButton.addListener('click',addHandler,false);

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
				title: '���KPIָ��',
				width: 355,
				height:200,
				minWidth: 355,
				minHeight: 200,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});
			win.show();
	    }
}