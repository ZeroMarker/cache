var hospid = session['LOGON.HOSPID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var adjustURL='herp.budg.budgadjustexe.csp';
 
var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function() {
		/******************
		var schemDs = new Ext.data.Store({
	proxy:"",
	url : ComBoxURL+'?action=bsm&flag=1&start=0&limit=10&str=',
	autoLoad : true,  
	fields: ['rowid','name'],
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

schemDs.on("load", function(){
	
    var year=YearComb.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择预算年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	var Num=schemDs.getCount();
    if (Num!=0){
	var id=schemDs.getAt(0).get('rowid');
		schemField.setValue(id);  
    } 

});
*****************/
		var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxURL+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});			
		var yearField = new Ext.form.TextField({
			id: 'yearField',
			fieldLabel: '会计年度',
			allowBlank: false,
			emptyText: '会计年度...',
			anchor: '90%'
		});
		var adjustNoField = new Ext.form.TextField({
			id: 'adjustNoField',
			fieldLabel: '调整序号',
			allowBlank: false,
			emptyText: '调整序号...',
			anchor: '90%'
		});
		var adjustDateField = new Ext.form.DateField({
			id:'adjustDateField',
			fieldLabel: '调整日期',
			//width:120,
			anchor: '90%',
			readonly:true ,
			value:new Date(),
			allowBlank:true,
			format:'Y-m-d',
			editable:false,
			selectOnFocus:'true'
		});
		var adjustFileField = new Ext.form.TextField({
			id: 'adjustFileField',
			fieldLabel: '调整文号',
			allowBlank: true,
			emptyText: '调整文号...',
			anchor: '90%'
		});	
		var memoField = new Ext.form.TextField({
			id: 'memoField',
			fieldLabel: '调整说明',
			allowBlank: true,
			emptyText: '调整说明...',
			anchor: '90%'
		});
		
		var schemeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name2'])
		});
		schemeDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:commonboxURL+'?action=bsm&flag=2&year='+yearField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('schemeField').getRawValue()),method:'POST'});
		});
		var schemeField = new Ext.form.ComboBox({
			id: 'schemeField',
			fieldLabel: '对应方案',
			//width:200,
			listWidth : 300,
			allowBlank: true,
			store: schemeDs,
			valueField: 'rowid',
			displayField: 'name2',
			triggerAction: 'all',
			emptyText:'请选择对应方案...',
			name: 'schemeField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			anchor: '90%'
		});
		// create form panel
  		var formPanel = new Ext.form.FormPanel({
  			baseCls: 'x-plain',
    		labelWidth: 80,
    		items: [
    			AddCompDRCombo,
    			yearField,
				adjustNoField,
     			//adjustDateField,
      			adjustFileField,
      			memoField,
      			schemeField
      		]
		});
  		// define window and show it in desktop
  		var window = new Ext.Window({
  			title: '添加预算调整',
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
      				var CompDR = AddCompDRCombo.getValue()
      				var Year = yearField.getValue();
      				var AdjustNo = adjustNoField.getValue();
      				var AdjustDate = adjustDateField.getRawValue();
					var AdjustFile = adjustFileField.getValue();
					var Memo = encodeURIComponent(memoField.getValue());
					var schemeID = schemeField.getValue();

					//alert(AdjustDate);	
      				AdjustNo = AdjustNo.trim();
					AdjustFile = AdjustFile.trim();
					Memo = Memo.trim();
					
					if(CompDR=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'医疗单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
					if(Year=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'会计年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(AdjustNo=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'调整序号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(AdjustDate=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'调整日期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				/*
      				if(AdjustFile=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'调整文号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(Memo=="")
      				{
      					Ext.Msg.show({title:'错误',msg:'调整说明为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				*/
      				if(schemeID==""&&AdjustNo!=="0")
      				{
      					Ext.Msg.show({title:'错误',msg:'对应方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
        			//var data = adjustNo+'^'+adjustDate+'^'+adjustFile+'^'+meno;
					if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: adjustURL+'?action=add&CompDR='+CompDR+'&Year='+Year+'&AdjustNo='+AdjustNo+'&AdjustDate='+AdjustDate+'&AdjustFile='+AdjustFile+'&Memo='+Memo+'&schemeID='+schemeID,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  		if (jsonData.success=='true') {
						  			Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params : {start: 0,limit: 25}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的编号已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							}//,scope: this
						});
        			}
        			else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
					window.close();
	    		}
    		},
    		{
				text: '取消',
        		handler: function(){window.close();}
      		}]
    	});
    	window.show();
	}					
});
