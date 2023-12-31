//提交
submitFun = function(itemGrid){
   
    var userdr = session['LOGON.USERID'];
	var rowObj = itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;

var schemrowid = rowObj[0].get("schemrowid");

var addPeriod = rowObj[0].get("checkperiod");
var addSchem=rowObj[0].get("schemname");
var addUser=session['LOGON.USERNAME'];

///////////////////核算期间/////////////////////////////  
var addPeriodDate = new Ext.form.TextField({
				fieldLabel: '核算期间',
				width:100,
				value:addPeriod,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////核算方案/////////////////////////////  
var addSchemText = new Ext.form.TextField({
				fieldLabel: '核算方案',
				width:180,
				value:addSchem,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	
///////////////////提交人/////////////////////////////  
var addUserText = new Ext.form.TextField({
				fieldLabel: '提交人',
				width:180,
				value:addUser,
				disabled:true,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});	

/* ///////////////////科室/////////////////////////////  	
var DeptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['deptdr','deptname'])
	});
	
DeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.basicuintpacaluexe.csp?action=listschemdepts&schemrowid='+schemrowid,method:'POST'});
				});
var DeptField  = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '科室',
	width : 180,
	anchor:'100%',
	store: DeptDs,
	valueField: 'deptdr',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
}); */
///////////////////功能描述/////////////////////////////  
var addProcDescText = new Ext.form.TextField({
                id:'addProcDescText',
				fieldLabel: '功能描述',
				width:180,
				allowBlank : true, 
				anchor: '100%',
				selectOnFocus:'true'
			});			
/////////// 处理意见
var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
				height : 120,
				anchor: '100%',
				fieldLabel : '处理意见',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '请填写处理意见……'
			});

	 var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									addPeriodDate,
					                addSchemText,
					                addUserText,
									addProcDescText,
									textArea							
								]
							 }]
					}
				]			
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
		frame: true,
		items: colItems
	});
	
	addButton = new Ext.Toolbar.Button({
		text:'确定'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
		addHandler = function(){      			
						

		   var view= encodeURIComponent(Ext.getCmp('addProcDescText').getRawValue());
           var procdesc = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		   //var deptdr = DeptField.getValue();
		   
		   if(formPanel.form.isValid()){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:'dhc.pa.basicuintpacaluexe.csp'+'?action=submit&schemrowid='+rowObj[i].get("schemrowid")+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc+'&desc='+view,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'提交成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'提交失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else{
				Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
			addwin.close();
   }
	////// 添加监听事件 ////////////////	
		addButton.addListener('click',addHandler,false);

		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
		
		cancelHandler = function(){
			addwin.close();
		}
		
		cancelButton.addListener('click',cancelHandler,false);

		addwin = new Ext.Window({
			title: '提交',
			width: 450,
			height: 400,
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
		addwin.show();			
};