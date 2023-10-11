EditFun = function(itemGrid) {
		var userdr = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];
		var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
		var records = itemGrid.getSelectionModel().getSelections();
		var BillState=records[0].get("BillState");
			//定义并初始化行对象长度变量
			var len = records.length;
			//判断是否选择了要修改的数据
		if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
		}else{
		var rowid=records[0].get("rowid");
		var BillState=records[0].get("BillState");
		var BillCode=records[0].get("Code");
		var yearmonth=BillCode.substr(0, 6);
		//alert(yearmonth);
		var tmpProjDR=records[0].get("ProjDR");
		var ProjName=records[0].get("Name");
		var tmpdeptdr=records[0].get("deptdr");
		//alert(deptdr);
		var dname=records[0].get("dname");
		var tmpApplyerDR=records[0].get("ApplyerDR");
		var uName=records[0].get("uName");
		var ApplyMoney=records[0].get("ApplyMoney");
		var Desc=records[0].get("Desc");
		}
		
		/*if((BillState=="提交")||(BillState=="完成"))
		{
			Ext.Msg.show({
						title : '注意',
						msg : '已提交或审核的数据不能修改!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
				return;
		}	*/
					
			var ApplBillCodeField = new Ext.form.TextField({
				fieldLabel: '申请单号',
				width:180,
				value:BillCode,
				disabled: true,
				anchor: '95%',
				selectOnFocus:'true'
			});
//****************************************************//
			var yearmonthDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['year', 'year'])
			});
			yearmonthDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=year&flag=1',
							method : 'POST'
						})
			});
			var yearmonthField = new Ext.form.ComboBox({
				fieldLabel : '年月',
				width : 100,
				allowBlank : false,
				value:yearmonth,
				store : yearmonthDs,
				displayField : 'year',
				valueField : 'year',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				listWidth : 225,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners:{
            	"select":function(combo,record,index){
	            	projDs.removeAll();     
					projField.setValue('');
					projDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgschemaselfexe.csp?action=deptNList&yearmonth='+combo.value,method:'POST'})  
					projDs.load({params:{start:0,limit:10}});      					
				}
	   			}
			});			
//****************************************************//
			var projDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});
			projDs.on('beforeload', function(ds, o) {
				var yearmonth =yearmonthField.getValue();
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgprojfundreqexe.csp?action=projList&userdr='+userdr+'&yearmonth='+yearmonth,
							method : 'POST'
						})
			});
			var projField = new Ext.form.ComboBox({
				fieldLabel : '项目名称',
				width : 100,
				allowBlank : false,
				store : projDs,
				value:ProjName,
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				listWidth : 225,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			projField.on('select',function(combo, record, index){
						tmpProjDR = combo.getValue();
					});
					
			///////////////申请人////////////////////////
var ApplyerDRDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

ApplyerDRDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=username',
						method : 'POST'
					});
		});

var ApplyerDRField = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : ApplyerDRDs,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			value:uName,
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			anchor: '95%',
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(appuName.getValue()!==""){
						Descfield.focus();
					}else{
					Handler = function(){appuName.focus();};
					Ext.Msg.show({title:'错误',msg:'申请人不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
	ApplyerDRField.on('select',function(combo, record, index){
						tmpApplyerDR = combo.getValue();
					});
						

//****************************************************//
			var deptDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});
			deptDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url :commonboxUrl+'?action=dept',
							method : 'POST'
						})
			});
			var deptField = new Ext.form.ComboBox({
				fieldLabel : '申请科室',
				width : 100,
				allowBlank : false,
				store : deptDs,
				displayField : 'name',
				value:dname,
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				listWidth : 225,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			deptField.on('select',function(combo, record, index){
						tmpdeptdr = combo.getValue();
					});

			var ApplyMoneyField = new Ext.form.TextField({												
				fieldLabel: '申领额度',
				width:180,
				anchor: '95%',
				value:ApplyMoney,
				allowBlank :false,
				selectOnFocus:'true'
			});
			var DescField = new Ext.form.TextField({												
				fieldLabel: '资金申请说明',
				width:180,
				value:Desc,
				anchor: '95%',
				selectOnFocus:'true'
			});
		

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									ApplBillCodeField,				
									ApplyMoneyField,				
									ApplyerDRField,
									DescField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [	
									yearmonthField,
									projField,
									deptField
										
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
    
			addButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			addHandler = function(){
      			var records = itemGrid.getSelectionModel().getSelections();	
      			var store = itemGrid.getStore();
      			var dataindex = store.indexOf(records[0]);//获取行号	
				var ProjDR				= tmpProjDR;
				var ApplyerDR			= tmpApplyerDR;
				var YearMonth			= yearmonthField.getValue();
				var ApplyMoney			= ApplyMoneyField.getValue();
				var Desc				= DescField.getValue();
				var deptdr				= tmpdeptdr;
				//alert(deptdr);
				if((ProjDR== "")||(ApplyMoney== "")||(YearMonth== "")||(ApplyerDR== "")||(deptdr== ""))
				{
					Ext.Msg.show({title:'注意',msg:'请信息添加完整后再试！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}		
				
			var data = ProjDR+"|"+ApplyerDR+"|"+YearMonth+"|"+ApplyMoney+"|"+Desc+"|"+deptdr
			//alert(data);
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojfundreqexe.csp?action=edit&rowid='+rowid+'&data='+encodeURIComponent(data),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
							itemGrid.store.on("load",function(){ 
					        itemGrid.getSelectionModel().selectRow(dataindex,true);

					 });	
						}else
						{
							var message="";
							if(jsonData.info=='RepCode') message='该科室已经申请过!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			
			addwin.close();
		}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '修改申请单',
				width: 500,
				height: 300,
				//autoHeight: true,
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
			
		if((BillState=="提交")||(BillState=="完成")){
			
			addButton.hidden = "true";
			cancelButton.hidden = "true";
			deptField.readOnly = true;
			ApplyerDRField.readOnly = true;
			yearmonthField.readOnly = true;
			projField.readOnly = true;
			ApplBillCodeField.disabled= true;
			}	
			addwin.show();			
	
	}


