function NewWindow(){
	var obj=new Object();
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	//var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var dhcObj=""
	if(reason=="D") dhcObj=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	if(reason=="C") dhcObj=ExtTool.StaticServerObject('web.DHCANOPCom');
	//alert(reason)
	var ret=_UDHCANOPArrange.FindRefusesReasonStr();
	var reasonList=ret.split("^");
	var Data = [];
	obj.listSurgeonStoreProxy=Data;
	obj.listStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(Data),
		reader: new Ext.data.ArrayReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
			}, 
		[
			{name: 'Id'}
			,{name: 'desc'}
		])
	});
	
	for(i=0;i<reasonList.length;i++){
		var record=new Ext.data.Record(['Id','desc'])
		var reasItemList=reasonList[i];
		var reasItem=reasItemList.split('|');
		record.set('Id',reasItem[0]);
		record.set('desc',reasItem[1]);
		obj.listStore.add(record)
	}
	obj.comRefusesReason = new Ext.form.ComboBox({
	    id : 'comRefusesReason'
		,store : obj.listStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : ''
		,valueField : 'Id'
		,mode:'local'
		,typeAhead: true
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.listStore.load({});
	obj.win = new Ext.Viewport({  
		title: '拒绝/取消',  
		resizable: true,  
		modal: true,  
		closable: true, 
		items : new Ext.form.FormPanel({ 
			bodyStyle: "padding:8px",
			id : 'login-form', 
			labelWidth :10,
			labelAlign : 'right', 
			buttonAlign : 'center', 
			baseCls : 'header', 
			layout : 'form', 
			defaults : { 
				width : 240
			},
			// 默认字段类型 
			items:[
				new Ext.form.Label({id:"lbRefusesReason",text:"拒绝/取消原因",style:'color:red;font-size:20px;font-weight:bold'}),
				obj.comRefusesReason
			],
			// 初始化按钮 
			buttons:[
				{text:'是',itemId : 'btn_Yes',handler:function(){
					var refuseId=obj.comRefusesReason.getValue();
					if(refuseId=="") {alert("拒绝或取消原因不能为空！");return;}
					var opaidList=opaId.split('^');
					for(i=0;i<opaidList.length;i++){
						opid=opaidList[i];
						var ret=dhcObj.UpdateReasSusp(opid,refuseId)
						if(ret==""){
							window.returnValue=1
						}else{
							window.returnValue=2
							window.close();
							return;
						}
						window.close()
					}
				}},
				{text:'否',itemId : 'btn_No',handler:function(){//点击时触发的事件
					window.returnValue=0
					window.close()
				}}
			]
		}) 
	});  
	return obj;
}