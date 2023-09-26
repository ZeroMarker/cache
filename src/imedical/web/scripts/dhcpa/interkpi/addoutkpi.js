function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addFun = function(KPIGrid,outKpiDs,outKpiGrid,outKpiPagingToolbar){
	
		var rowObj=KPIGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'提示',msg:'请选择要对照的指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
				fieldLabel:'接口套',
				width:230,
				listWidth : 230,
				allowBlank: false,
				store: locSetDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择接口套...',
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
				fieldLabel:'指标规则',
				width:230,
				listWidth : 230,
				allowBlank: false,
				store: outKPIRlueDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择指标规则...',
				name:'outKPIRlueField',
				minChars:1,
				pageSize:10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});
					
			
			var remarkField = new Ext.form.TextField({
				id:'remarkField',
				fieldLabel: '备注',
				allowBlank: true,
				//width:140,
				//listWidth : 140,
				emptyText:'备注...',
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
				text:'添加'
			});
					
			//添加处理函数
			var addHandler = function(){
				
				var locSetDr = Ext.getCmp('locSetField').getValue();
				var outKPIRlue = Ext.getCmp('outKPIRlueField').getValue();
				var remark = Ext.getCmp('remarkField').getValue();
				locSetDr = trim(locSetDr);
				outKPIRlue = trim(outKPIRlue);
				remark = trim(remark);
				if(locSetDr==""){
					Ext.Msg.show({title:'提示',msg:'请选择接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				if(outKPIRlue==""){
					Ext.Msg.show({title:'提示',msg:'请选择规则指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				};
				var data = KPIDr+'^'+outKPIRlue+'^'+encodeURIComponent(remark);
				Ext.Ajax.request({
					url:KPIUrl+'?action=add&data='+data,
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize,locSetDr:locSetDr,dir:'asc',sort:'rowid'}});
						}else{
							if(jsonData.info=='RepKPI'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
							}
						}
					},
					scope: this
				});
			}

			//添加按钮的响应事件
			addButton.addListener('click',addHandler,false);

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
				title: '添加KPI指标',
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