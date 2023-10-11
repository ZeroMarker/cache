var auditreplaceURL='herp.budg.budgauditreplaceexe.csp';

auditreplaceEdit = function(rowid) {

var begindateField= new Ext.form.DateField({
	format:'Y-m-d',
	fieldLabel: '开始时间',
	emptyText:'开始时间...',
	type: "dateField",
	columnWidth:1
});

var enddateField= new Ext.form.DateField({
	format:'Y-m-d',
	fieldLabel: '结束时间',
	emptyText:'结束时间...',
	columnWidth:1,
	type: "dateField"	
});


var putdateField= new Ext.form.DateField({
	format:'Y-m-d',
	fieldLabel: '提交时间',
	emptyText:'提交时间...',
	columnWidth:1,
	type: "dateField"	
});

var unituserDs = new Ext.data.Store({
	atLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:auditreplaceURL+'?action=username&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var userField = new Ext.form.ComboBox({
	id: 'userField',
	fieldLabel: '当事人',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'userField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var fstField = new Ext.form.ComboBox({
	id: 'fstField',
	fieldLabel: '第一替代人',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'fstField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var sndField = new Ext.form.ComboBox({
	id: 'sndField',
	fieldLabel: '第二替代人',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'sndField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

		var rowObj=itemGrid.getSelectionModel().getSelections();
		var rowid = rowObj[0].get("rowid");
	


	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 70,
				items : [userField, fstField, sndField,
						begindateField, enddateField, putdateField
				]
			});
	//面板加载后自动加载修改数据
        formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);

		userField.setValue(rowObj[0].get("username"));
    	fstField.setValue(rowObj[0].get("fstname"));	
	    sndField.setValue(rowObj[0].get("sndname"));
		begindateField.setValue(rowObj[0].get("begindate"));
	    enddateField.setValue(rowObj[0].get("enddate"));	
	    putdateField.setValue(rowObj[0].get("putdate"));
	});


       //定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	       //定义添加按钮响应函数
	 	    editHandler = function(){
            //alert("wwww")
			var username = userField.getValue();
			//alert(username);
			var fstname = fstField.getValue();
			var sndname = sndField.getValue();
			var begindate = begindateField.getValue();
			var enddate = enddateField.getValue();
			var putdate = putdateField.getValue();

			if(username==""){
				Ext.Msg.show({title:'错误',msg:'当事人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(fstname==""){
				Ext.Msg.show({title:'错误',msg:'第一替代人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(sndname==""){
				Ext.Msg.show({title:'错误',msg:'第二替代人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(begindate==""){
				Ext.Msg.show({title:'错误',msg:'开始时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(enddate==""){
				Ext.Msg.show({title:'错误',msg:'结束时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(putdate==""){
				Ext.Msg.show({title:'错误',msg:'提交时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
				Ext.Ajax.request({
				url: '../csp/herp.budg.budgauditreplaceexe.csp?action=edit&rowid='+rowid+'&username='+username+'&fstname='+fstname+'&sndname='+sndname+'&begindate='+begindate+'&enddate='+enddate+'&putdate='+putdate,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
						//alert(rowid);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//itemGridDs.load({params:{start:0, limit:12}});
						editwin.close();						
					}
					
					else
						{
							var message="";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						
				},
				
				scope: this
			});
		}
	
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width: 400,
			height:250,
			minWidth: 400, 
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
	
		//窗口显示
		editwin.show();
};
		