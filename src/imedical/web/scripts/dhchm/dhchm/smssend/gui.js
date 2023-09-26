

//弹出窗口

function InitSMSWin()
{
	var obj = new Object();

    
    	obj.btClose= new Ext.Button({
		id : 'btClose'
		,iconCls : 'icon-find'
		,text : '关闭'
});

obj.btAdd = new Ext.Button({
		id : 'btAdd'
		,iconCls : 'icon-find'
		,text : '添加用户'
});
    obj.SMSWin = new Ext.Window({
		id : 'SMSWin'
	//,closeAction :'hide'
		,height : 420
		,buttonAlign : 'center'
		,width : 900
		,region : 'center'
   	,closable:false
	 	//,layout : 'border'
,modal:true
		,items:[
			
			//obj.GridPanelES
		]
		,buttons:[
		obj.btAdd,
		obj.btClose
		]
		,constrain:true
	});
	TheSMSobj=obj;

	
	InitSMSWinEvent(obj);
     
    //事件处理代码
    obj.btAdd.on("click", obj.btAdd_click, obj);
    
    obj.btClose.on("click",obj.btClose_click,obj);
    obj.SMSWin.on("activate",obj.SMSWin_activate,obj);
    obj.SMSWin.on("hide",obj.SMSWin_hide,obj);
    obj.LoadEvent(arguments);
    return obj;
}
