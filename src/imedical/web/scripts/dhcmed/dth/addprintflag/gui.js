var AddPrintFlag = new Object();
//纸单号输入
function InitAddPrintFlag()
{	
	AddPrintFlag.AddPrintFlag = Common_CheckboxGroupToDic("AddPrintFlag","是否补打","AddPrintFlag",1);
	AddPrintFlag.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	AddPrintFlag.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
	});
	AddPrintFlag.mainWindow = new Ext.Panel
	({
		id : 'mainWindow'
		,height : 200
		,buttonAlign : 'center'
		,width : 400
		,title : '是否补打'
		,layout : 'border'
		,modal:true
		/*
		,items : [
			AddPrintFlag.AddPrintFlag

		]
		*/
		,items : [
			{
				items:AddPrintFlag.AddPrintFlag,
				region: 'center',
				layout : 'fit',
				margins: '0 auto 0 30',
				unstyled: true
			}
		]
		,buttons : [
			AddPrintFlag.saveBtn
			,AddPrintFlag.exitBtn
		]
	});
	
	AddPrintFlag.MainView=new Ext.Viewport({
        id:'MainViewId'
        ,layout : 'fit'
		,items:[
			AddPrintFlag.mainWindow
		]
    });
	InitAddPrintFlagEvent(AddPrintFlag);
	
	AddPrintFlag.saveBtn.on("click", AddPrintFlag.saveBtn_click, AddPrintFlag);
	AddPrintFlag.exitBtn.on("click", AddPrintFlag.exitBtn_click, AddPrintFlag);
	AddPrintFlag.LoadEvent(arguments);
	return AddPrintFlag;
}