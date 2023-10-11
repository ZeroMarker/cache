addfun = function(itemGrid) {
	
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var editrUrl ='herp.budg.budgdeptuserexe.csp';	
var unituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituseField').getRawValue()),method:'POST'});
});
var unituseField = new Ext.form.ComboBox({
	id: 'unituseField',
	fieldLabel: '人员名称',
	width:180,
	listWidth :300,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'unituseField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var groupDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','desc'])
});
groupDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:editrUrl+'?action=methodsafegroup&str='+encodeURIComponent(Ext.getCmp('safegroupField').getRawValue()),method:'POST'});
});
var safegroupField = new Ext.form.ComboBox({
	id: 'safegroupField',
	fieldLabel: '安全组',
	width:180,
	listWidth :300,
	store: groupDs,
	valueField: 'rowid',
	displayField: 'desc',
	triggerAction: 'all',
	emptyText:'请选择所属安全组...',
	name: 'safegroupField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var deptdrDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


deptdrDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('unitdept1Field').getRawValue()),method:'POST'});
});

var unitdept1Field = new Ext.form.ComboBox({
	id: 'unitdept1Field',
	fieldLabel: '科室名称',
	width:180,
	listWidth : 300,
	allowBlank: false,
	store: deptdrDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'unitdept1Field',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


	var DeptTypeDs = new Ext.data.Store({
		//autoLoad : true,
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : 'results',
			root : 'rows'
			}, ['rowid', 'code', 'name'])
	});

	DeptTypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : commonboxURL+'?action=deptType',
			method : 'POST'
		})
	});

	var TypeCodeField = new Ext.form.ComboBox({
		fieldLabel : '科室类别',
		width : 180,
		listWidth :300,
		allowBlank : true,
		store : DeptTypeDs,
		valueField : 'code',
		displayField : 'name',
		triggerAction : 'all',
		emptyText : '选择科室所属类别',
		minChars : 1,
		//anchor: '95%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : 'true',
		editable : true
	});
	

var managerdrDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

managerdrDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituseField').getRawValue()),method:'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			fieldLabel : '上级领导',
			store : managerdrDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '上级领导',
			width : 180,
			listWidth : 300,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

var IsbigField = new Ext.form.Checkbox({												
				fieldLabel: '是否大类科室'
				});
				
				
var checkActive = new Ext.form.Checkbox({
						fieldLabel: '用于一般预算'								
					});
var checkActive2 = new Ext.form.Checkbox({
						fieldLabel: '用于项目预算'								
					});
var checkActive3 = new Ext.form.Checkbox({
						fieldLabel: '能否项目审核'								
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
				  unituseField,				
				  unitdept1Field,
				  userCombo,
				  checkActive,
				  checkActive3
				  ]
			  },{
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				  safegroupField,
				  TypeCodeField,
				  IsbigField,
				  checkActive2
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
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '批量添加',
    width: 600,
    height:230,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    // atLoad : true, // 是否自动刷新
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		//科室名称
           	var deptdr      = unitdept1Field.getValue();
         	//人员名称
           	var unituser    = unituseField.getValue();
           	//安全组
           	var group       = safegroupField.getValue();
           	//科室类别
      		var type 		= TypeCodeField.getValue();
           	
           	//是否是大类科室
           	var isbudg		= IsbigField.getValue();
				if(isbudg){
					isbudg = "1"
				}else{
					isbudg = "0"
				}	
			//上级领导
           	var managerdr   = userCombo.getValue();
           	//是否用于一般预算
			var IsBase		= checkActive.getValue();
				if( IsBase){
					 IsBase = "Y"
				}else{
					 IsBase = "N"
				}
			//是否用于项目预算	
			var IsProj		= checkActive2.getValue();
				if(IsProj){
					IsProj = "Y"
				}else{
					IsProj = "N"
				}	
			//能否用于项目审核
			var IsFinance		= checkActive3.getValue();
				if(IsFinance){
					IsFinance = "Y"
				}else{
					IsFinance = "N"
				}	
				//alert("你好");
		   if(unituser==""&&group=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'人员名称和安全组不能同时为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
      	   if(managerdr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'上级领导不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}						
      		Ext.Ajax.request({
				url: editrUrl+'?action=Batchadd&&deptdr='+deptdr+'&unituser='+unituser+'&group='+group+'&type='+type+'&isbudg='+isbudg+'&managerdr='+managerdr+'&IsBase='+IsBase+'&IsProj='+IsProj+'&IsFinance='+IsFinance,
				
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					///alert("好");
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                itemGrid.load();
						window.close();
					}
					else {
						
						var tmpMsg = jsonData.info+"!";
						Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			  	scope: this
			});

	}
},
{
		text: '取消',
handler: function(){window.close();}
}]
});

window.show();
};