var objPaperNo = new Object();
//纸单号输入
function InitPaperNo()
{	
	var PanelTitle ='请录入纸单号：1~7位数字';
	if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
		PanelTitle ='纸单号';
	}
	objPaperNo.PaperNo = new Ext.form.TextField
	({
		id : "PaperNo"
		,fieldLabel : "纸单号"
		,anchor : '100%'
	});
	
	
	objPaperNo.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	objPaperNo.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
	});
	objPaperNo.mainWindow = new Ext.Panel
	({
		id : 'mainWindow'
		,height : 150
		,buttonAlign : 'center'
		,width : 400
		,title : PanelTitle
		,layout : 'fit'
		,modal:true
		,items : [
			objPaperNo.PaperNo 
		]
		,buttons : [
			objPaperNo.saveBtn
			,objPaperNo.exitBtn
		]
	});
	
	objPaperNo.MainView=new Ext.Viewport({
        id:'MainViewId'
        ,layout : 'fit'
		,items:[
			objPaperNo.mainWindow
		]
    });
	InitPaperNoEvent(objPaperNo);
	objPaperNo.LoadEvent(arguments);
	return objPaperNo;
}