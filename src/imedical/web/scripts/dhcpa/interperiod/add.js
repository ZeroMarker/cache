addFun = function(locSetField,grid,ds,pagingToolbar){
		var locsetName=Ext.getCmp('locSetField').getRawValue();
		var locsetDr=Ext.getCmp('locSetField').getValue();
	
		var periodField = new Ext.form.NumberField({
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
		
		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
		});
		var periodTypeField = new Ext.form.ComboBox({
			id: 'periodTypeField',
			fieldLabel: '期间类型',
			width:220,
			listWidth : 220,
			selectOnFocus: true,
			allowBlank: false,
			store: periodTypeStore,
			anchor: '90%',
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
		
		var monthCombo = new Ext.ux.form.LovCombo({
			id:'monthCombo',
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
			disabled:false,
			emptyText:'请选择引用期间...',
			editable:false,
			anchor: '90%'
		});
		
		//定义起始时间控件
		var startDate = new Ext.form.DateField({
			id:'startDate',
			//format:'Y-m-d',
			fieldLabel:'起始时间',
			width:220,
			disabled:false,
			emptyText: '请选择起始时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(startDate.getValue()!=""){
							endDate.focus();
						}else{
							Handler = function(){startDate.focus();}
							Ext.Msg.show({title:'提示',msg:'起始时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		//定义结束时间控件
		var endDate = new Ext.form.DateField({
			id:'endDate',
			//format:'Y-m-d',
			fieldLabel:'结束时间',
			width:220,
			disabled:false,
			emptyText: '请选择结束时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(endDate.getValue()!=""){
							remarkField.focus();
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'提示',msg:'结束时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '备注',
			allowBlank: true,
			width:220,
			listWidth : 220,
			emptyText:'备注...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
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
					periodField,
					periodTypeField,
					monthCombo,
					remarkField
				]
			});
		}else{
			//初始化面板
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					periodField,
					periodTypeField,
					startDate,
					endDate,
					remarkField
				]
			});
		}
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
			var period = periodField.getRawValue();
			
			if(!judge(period)){
				Ext.Msg.show({title:'提示',msg:'绩效期间格式不对!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			
			var periodType = periodTypeField.getValue();
			var remark = remarkField.getValue();
		
			var data="";
			//alert(locsetName);
			if(locsetName=="成本核算系统"){
				var monthDrStr = Ext.getCmp('monthCombo').getValue();
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
				data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+newMonthDrStr+"^"+corrType;
			}else{
				var startDate = Ext.getCmp('startDate').getValue();
				if(startDate!=""){
					startDate = startDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'提示',msg:'开始日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				var endDate = Ext.getCmp('endDate').getValue();
				if(endDate!=""){
					endDate = endDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'提示',msg:'结束日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(startDate,endDate)){
					var corrType="I";
					data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+startDate+"^"+endDate+"^"+corrType;
				}else{
					Ext.Msg.show({title:'提示',msg:'开始日期大于结束日期',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
			}
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=add&data='+encodeURIComponent(data),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locsetDr}});
					}else{
						if(jsonData.info=='RepRecord'){
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'提示',msg:'此记录已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='dataEmpt'){
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'提示',msg:'记录为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				},
				scope: this
			});
		}
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '添加接口期间记录',
			width: 343,
			height:220,
			minWidth: 343, 
			minHeight: 220,
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
	
		//窗口显示
		addwin.show();
		
}