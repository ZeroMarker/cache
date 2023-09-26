var objSwitchPrint = new Object();
//纸单号输入
function InitSwitchPrint()
{	
	objSwitchPrint.SwitchPrint = Common_CheckboxGroupToDic("SwitchPrint","选择打印","SwitchPrint",1);
	objSwitchPrint.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	objSwitchPrint.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
	});
	objSwitchPrint.mainWindow = new Ext.Panel
	({
		id : 'mainWindow'
		,height : 200
		,buttonAlign : 'center'
		,width : 400
		,title : '请选择要打印哪联'
		,layout : 'border'
		,modal:true
		/*
		,items : [
			objSwitchPrint.SwitchPrint
		]
		*/
		,items : [
			{
				items:objSwitchPrint.SwitchPrint,
				region: 'center',
				layout : 'fit',
				margins: '20 auto -10 30',
				unstyled: true
			}
		]
		,buttons : [
			objSwitchPrint.saveBtn
			,objSwitchPrint.exitBtn
		]
	});
	
	objSwitchPrint.MainView=new Ext.Viewport({
        id:'MainViewId'
        ,layout : 'fit'
		,items:[
			objSwitchPrint.mainWindow
		]
    });
	InitSwitchPrintEvent(objSwitchPrint);
	
	objSwitchPrint.saveBtn.on("click", objSwitchPrint.saveBtn_click, objSwitchPrint);
	objSwitchPrint.exitBtn.on("click", objSwitchPrint.exitBtn_click, objSwitchPrint);
	objSwitchPrint.LoadEvent(arguments);
	return objSwitchPrint;
}