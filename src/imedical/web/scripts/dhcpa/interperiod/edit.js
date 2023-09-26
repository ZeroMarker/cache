editFun = function(locSetField,grid,ds,pagingToolbar){
		var rowObj=PeriodGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'提示',msg:'请选择需要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
	

		var locsetDr=Ext.getCmp('locSetField').getValue();
		var locsetName=Ext.getCmp('locSetField').getRawValue();
	
		var PeriodField = new Ext.form.NumberField({
			id:'periodField',
			fieldLabel:'绩效期间',
			allowBlank:false,
			emptyText:'绩效期间...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			name:'period',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodField.getValue()!=""){
							periodTypeField.focus();
						}else{
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'提示',msg:'绩效期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var PeriodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
		});
		var PeriodTypeField = new Ext.form.ComboBox({
			id: 'PeriodTypeField',
			fieldLabel: '期间类型',
			width:220,
			listWidth : 220,
			selectOnFocus: true,
			allowBlank: false,
			store: PeriodTypeStore,
			anchor: '90%',
			value:'', //默认值
			valueNotFoundText:rowObj[0].get('periodTypeName'),
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
		
		var MonthCombo = new Ext.ux.form.LovCombo({
			id:'MonthCombo',
			fieldLabel: '引用期间',
			hideOnSelect: false,
			store: new Ext.data.Store({
				autoLoad: true,
				proxy: new Ext.data.HttpProxy({url:'dhc.pa.interperiodexe.csp?action=quotelist&locSetDr='+locsetDr}),
				reader: new Ext.data.JsonReader({
					root: 'rows',
					totalProperty: 'results',
					id: 'rowid'
				},[
					'rowid',
					'name'
				])
			},[
				'rowid', 'name'
			]),
			valueField:'rowid',
			displayField:'name',
			typeAhead: false,
			triggerAction: 'all',
			pageSize:18,
			width:220,
			listWidth:220,
			allowBlank: false,
			emptyText:'请选择引用期间...',
			editable:false,
			anchor: '90%'
		});
		
		var StartDate = new Ext.form.DateField({
			id:'StartDate',
			//format:'Y-m-d',
			fieldLabel:'起始时间',
			width:220,
			emptyText: '请选择起始时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(StartDate.getValue()!=""){
							EndDate.focus();
						}else{
							Handler = function(){StartDate.focus();}
							Ext.Msg.show({title:'提示',msg:'起始时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var EndDate = new Ext.form.DateField({
			id:'EndDate',
			//format:'Y-m-d',
			fieldLabel:'结束时间',
			width:220,
			emptyText: '请选择结束时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(EndDate.getValue()!=""){
							remarkField.focus();
						}else{
							Handler = function(){EndDate.focus();}
							Ext.Msg.show({title:'提示',msg:'结束时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var RemarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '备注',
			allowBlank: true,
			width:220,
			listWidth : 220,
			emptyText:'备注...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'remark',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '有效标志:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		if(locsetName=="成本核算系统"){
			//初始化面板
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					PeriodField,
					PeriodTypeField,
					MonthCombo,
					RemarkField,
					activeField
				]
			});
			formPanel.on('afterlayout', function(panel, layout){
				this.getForm().loadRecord(rowObj[0]);
				PeriodTypeField.setValue(rowObj[0].get('periodType'));
				Ext.getCmp('MonthCombo').setValue("");
			});
		}else{
			//初始化面板
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					PeriodField,
					PeriodTypeField,
					StartDate,
					EndDate,
					RemarkField,
					activeField
				]
			});
			formPanel.on('afterlayout', function(panel, layout){
				this.getForm().loadRecord(rowObj[0]);
				PeriodTypeField.setValue(rowObj[0].get('periodType'));
				Ext.getCmp('StartDate').setRawValue(rowObj[0].get("startDate"));
				Ext.getCmp('EndDate').setRawValue(rowObj[0].get("endDate"));
			});
		}
		
		
		
		editButton = new Ext.Toolbar.Button({
			text:'修 改'
		});
		
		editHandler = function(){
			var period = PeriodField.getRawValue();
			
			if(!judge(period)){
				Ext.Msg.show({title:'提示',msg:'绩效期间格式不对!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			
			var periodType = PeriodTypeField.getValue();
			var remark = RemarkField.getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
		
			var data="";
			if(locsetName=="成本核算系统"){
				var monthDrStr = Ext.getCmp('MonthCombo').getValue();
				var arr=monthDrStr.split(",");
				var newMonthDrStr="";
				for(var i=0;i<arr.length;i++){
					if(newMonthDrStr==""){
						newMonthDrStr=arr[i];
					}else{
						newMonthDrStr=newMonthDrStr+"-"+arr[i];
					}
				}
				var corrType="R";
				data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+active+"^"+newMonthDrStr+"^"+corrType;
			}else{
				var startDate = Ext.getCmp('StartDate').getValue();
				if(startDate!=""){
					startDate = startDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'提示',msg:'开始日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				var endDate = Ext.getCmp('EndDate').getValue();
				if(endDate!=""){
					endDate = endDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'提示',msg:'结束日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(startDate,endDate)){
					var corrType="I";
					data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+active+"^"+startDate+"^"+endDate+"^"+corrType;
				}else{
					Ext.Msg.show({title:'提示',msg:'开始日期大于结束日期',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
			}
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=edit&rowid='+rowid+'&data='+encodeURIComponent(data),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locsetDr}});
						editwin.close();
					}else{
						if(jsonData.info=='RepRecord'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'提示',msg:'此记录已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='EmptyRowid'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'提示',msg:'rowid丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='EmptyData'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'提示',msg:'记录为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				},
				scope: this
			});
		}
	
		editButton.addListener('click',editHandler,false);
	
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		cancelHandler = function(){
			editwin.close();
		}
	
		cancelButton.addListener('click',cancelHandler,false);
	
		editwin = new Ext.Window({
			title: '修改接口期间记录',
			width: 343,
			height:250,
			minWidth: 343, 
			minHeight: 250,
			layout: 'fit',
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
	
		editwin.show();
		
}