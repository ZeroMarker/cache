

BonusEmpReportEditFun = function() {
	
	var tmpBonusEmployeeID,tmpBonusReportID;
	
    var rowObj=itemGrid.getSelectionModel().getSelections(); //选中行的记录
	var len = rowObj.length; //判断选中多少行
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var RowId = rowObj[0].get("RowId");
		var tmpBonusEmployeeID = rowObj[0].get("BonusEmployeeID");
		var tmpBonusReportID = rowObj[0].get("BonusReportID");
		//alert(RowId+"___"+tmpBonusEmployeeID+"___"+tmpBonusReportID);
	}
//-----------------	
var BonusEmployeeDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])  //需跟后台程序中while中获取的字段一样
});


BonusEmployeeDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'dhc.bonus.uBonusEmpReportexe.csp'
	                     + '?action=listEmployee&str='
	                     + encodeURIComponent(Ext.getCmp('BonusEmployeeDsField').getRawValue()),
	               method:'POST'
	              });
	});

var BonusEmployeeDsField = new Ext.form.ComboBox({
		id: 'BonusEmployeeDsField',
		fieldLabel: '人员名称',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: BonusEmployeeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '',
		name: 'BonusEmployeeDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
});

BonusEmployeeDsField.on('select',function(combo, record, index){
		 tmpBonusEmployeeID = combo.getValue();
	});

//---------------------
	var BonusReportDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
   });


	BonusReportDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'dhc.bonus.uBonusEmpReportexe.csp'
		                     + '?action=listReport&str='
		                     + encodeURIComponent(Ext.getCmp('BonusReportDSField').getRawValue()),
		               method:'POST'
		              });
   	});
   
	var BonusReportDSField = new Ext.form.ComboBox({
			id: 'BonusReportDSField',
			fieldLabel: '报表名称',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: BonusReportDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '',
			name: 'BonusReportDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});
	
BonusReportDSField.on('select',function(combo, record, index){
		 tmpBonusReportID = combo.getValue();
	});
//--------------------------			                                                                                            //
    //点击按钮后的面板加载	
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [BonusEmployeeDsField,BonusReportDSField]
		});

     formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			BonusEmployeeDsField.setValue(rowObj[0].get("EmployeeName"));	
			BonusReportDSField.setValue(rowObj[0].get("ReportName"));	

			                                                                      
    });   
    
	    //定义并初始化保存修改按钮
 var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		 //定义修改按钮响应函数方法
	 editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var RowId = rowObj[0].get("RowId");
		        var Person=BonusEmployeeDsField.getValue();
		        var Report=BonusReportDSField.getValue();  
		               
				if(Ext.getCmp('BonusEmployeeDsField').getRawValue()==""){var BonusEmployeeID="";}
				else{var BonusEmployeeID =tmpBonusEmployeeID;}
				if(Ext.getCmp('BonusReportDSField').getRawValue()==""){var BonusReportID="";}
				else{var BonusReportID = tmpBonusReportID;}
				//alert(RowId+"^"+BonusEmployeeID+"^"+BonusReportID);
				
				Person = Person.trim();
				Report = Report.trim();
				
				if(Person=="")
      			{
      			Ext.Msg.show({title:'错误',msg:'人员名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      			};
      			if(Report=="")
      			{
      			Ext.Msg.show({title:'错误',msg:'报表名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      			};
      			
				if (formPanel.form.isValid()) {
                Ext.Ajax.request({
				url:'dhc.bonus.uBonusEmpReportexe.csp?action=edit&RowId='+RowId+'&BonusEmployeeID='+BonusEmployeeID
				+'&BonusReportID='+BonusReportID,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{	
						var message="SQLErr: "+jsonData.info;
						if(jsonData.info=='RepName') message='已存在相同记录';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			},
				scope: this
			});
			editwin.close();
				}};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改人员报表权限',
			width : 400,
			height : 300,    
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
		//窗口显示
		editwin.show();
	};
