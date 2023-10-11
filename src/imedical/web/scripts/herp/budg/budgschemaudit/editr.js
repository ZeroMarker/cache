editrFun = function(itemGrid,schid) {
	
	var editrUrl ='../csp/herp.budg.budgschemauditexe.csp';
	
	var unituserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgschemauditexe.csp'+'?action=userNamelist&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField2').getRawValue()),method:'POST'});
});
var unituserField2 = new Ext.form.ComboBox({
	id: 'unituserField2',
	fieldLabel: '编制责任人',
	width:200,
	listWidth :300,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'unituserField2',
	minChars: 1,
	pageSize: 10,
	anchor: '95%',
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});	
	/////////////////科室名称/////////////////////////////////
	var DnameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	DnameDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemauditexe.csp'+'?action=descNamelist&flag=1&str='+encodeURIComponent(Ext.getCmp('DnameComb').getRawValue()),method:'POST'});		
	});		
	var DnameComb = new Ext.form.ComboBox({
		id: 'DnameComb',
		fieldLabel:'编制科室',
		store: DnameDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		name: 'DnameComb',
		width: 150,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		anchor: '95%',
		selectOnFocus:true
	});

	///////////////////////科室类别///////////////////////////
	var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptTypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemauditexe.csp?action=deptType',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'适用科室类别',
		store: deptTypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'为空默认显示所有科室...',
		width: 110,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		anchor: '95%',
		selectOnFocus:true
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
				  unituserField2,
				  DnameComb
				  ]
			  },{
				  xtype: 'fieldset',
				  autoHeight: true,
				  items: [
				 deptTypeCombo
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
  	title: '批量设置',
    width: 600,
    height:200,
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
      		//schid UserDR EditType ObjType
      		var UserDR 		= unituserField2.getValue();
      		var Editdr	 	= DnameComb.getValue();
      		var ObjType 	= deptTypeCombo.getValue();
			//alert(editrUrl+'?action=editr&&UserDR='+UserDR+'&Editdr='+Editdr+'&ObjType='+ObjType+'&schid='+schid);
      		if((UserDR=="")||(Edit=""))
      		{
      			Ext.Msg.show({title:'错误',msg:'编制用户和编制科室均不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		}
	
      		Ext.Ajax.request({
				url: editrUrl+'?action=editr&&UserDR='+UserDR+'&Editdr='+Editdr+'&ObjType='+ObjType+'&schid='+schid,
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGrid.load({params:{start:0,limit:12,schemeDr:schid}});
						window.close();
					}
					else {
						if (jsonData.info="RepName") {var tmpMsg="重复添加"}
						else {tmpMsg = jsonData.info+"处理失败!";}
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