CorrectFun = function(rowid,unitName,Period,KPIName,actualValue){
	
var UnitField = new Ext.form.TextField({
		id:'UnitField',
		fieldLabel: '科室名称',
		allowBlank: false,
		width:180,
		disabled:true,
		value:unitName,
		listWidth : 180,
		//emptyText:'请填写科室名称...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(UnitField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){UnitField.focus();}
						Ext.Msg.show({title:'错误',msg:'科室名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	
	
var PeriodField = new Ext.form.TextField({
		id:'PeriodField',
		fieldLabel: '期间',
		allowBlank: false,
		width:180,
		disabled:true,
		value:Period,
		listWidth : 180,
		//emptyText:'请填写期间...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(PeriodField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'错误',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var KpiField = new Ext.form.TextField({
		id:'KpiField',
		fieldLabel: '指标名称',
		allowBlank: false,
		width:180,
		disabled:true,
		value:KPIName,
		listWidth : 180,
		//emptyText:'请填写期间...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(KpiField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){KpiField.focus();}
						Ext.Msg.show({title:'错误',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var actualValueField = new Ext.form.TextField({
		id:'actualValueField',
		fieldLabel: '实际值',
		allowBlank: false,
		width:180,
		listWidth : 180,
		value:actualValue,
		emptyText:'请填写实际值...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(actualValueField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){actualValueField.focus();}
						Ext.Msg.show({title:'错误',msg:'实际值不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var descField = new Ext.form.TextArea({
		id:'descField',
		fieldLabel: '描述',
		allowBlank: true,
		width:180,
		listWidth : 180,
		emptyText:'请填写描述...',
		anchor: '90%',
		selectOnFocus:'true'
	});
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:60,
		items: [
	
			UnitField,
			PeriodField,
			KpiField,
			actualValueField,
			descField
		]
	});
	
	//定义添加按钮
	var CorrectButton = new Ext.Toolbar.Button({
		text:'修改'
	});
			
	//添加处理函数
	var addHandler = function(){
		
		
		var actualValue = actualValueField.getValue();
		var desc = descField.getValue();
		
	
		
		actualValue = trim(actualValue);
		if(actualValue==""){
			Ext.Msg.show({title:'提示',msg:'实际值为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		desc = trim(desc);
		if(desc==""){
			Ext.Msg.show({title:'提示',msg:'描述为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		var data = rowid+"^"+actualValue+"^"+desc;
		
		Ext.Ajax.request({
			url:'dhc.pa.jxbasedataexe.csp?action=correct&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'修正成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,period:periodValue,periodType:type,dir:'asc',sort:'childSub'}});
				}
				else{
					var message="修正错误";
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});
	}

	//添加按钮的响应事件
	CorrectButton.addListener('click',addHandler,false);

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
		title: '修正数据记录',
		width: 415,
		height:280,
		minWidth: 415,
		minHeight: 280,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			CorrectButton,
			cancelButton
		]
	});
	win.show();
}