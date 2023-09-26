var objAddAndSwitch = new Object();
//纸单号输入
function InitAddAndSwitch()
{	
	objAddAndSwitch.SwitchPrint = Common_CheckboxGroupToDic("SwitchPrint","选择打印","SwitchPrint",1);
	objAddAndSwitch.AddPrintFlag = Common_CheckboxGroupToDic("AddPrintFlag","是否补打","AddPrintFlag",1);
	objAddAndSwitch.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	objAddAndSwitch.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
	});
	objAddAndSwitch.mainWindow = new Ext.Panel
	({
		id : 'mainWindow'
		,height : 200
		,buttonAlign : 'center'
		,width : 400
		,title : '请选择要打印哪联并选择是否补打'
		,layout : 'border'
		,modal:true
		,defaults:{
			split: false,                  //是否有分割线
			collapsible: false,           //是否可以折叠
			//frame:false,
			border:false
		}
		,items : [
			/*
			//是否补打标志
			{
				items:objAddAndSwitch.AddPrintFlag,
				region: 'north',
				height: 35,
				layout : 'fit'
			}
			//选择打印哪联
			,{
				items:objAddAndSwitch.SwitchPrint,
				region: 'center',
				layout : 'fit'
			}
			*/
			{
				items:"",
				region: 'west',
				width: 35,
				layout : 'fit',
				unstyled: true
			},
			{
				region: 'center',
				layout:'border',
				split: true,
				defaults:{
					split: false,                  //是否有分割线
					collapsible: false,           //是否可以折叠
					//frame:false,
					border:false
				},
				items:[
					//是否补打标志
					{
						items:objAddAndSwitch.AddPrintFlag,
						region: 'north',
						height: 40,
						layout : 'fit',
						margins: '10 auto -10 auto',  //这个10加上后，向下移动了10像素，但是有背景色，加上下面的配置，背景色变成有色，怎么才能取得那是个像素的背景色呢？
						unstyled: true  //该组件显示背景色
					}
					//选择打印哪联
					,{
						items:objAddAndSwitch.SwitchPrint,
						region: 'center',
						layout : 'fit',
						unstyled: true
					}
				]
			}
		]
		,buttons : [
			objAddAndSwitch.saveBtn
			,objAddAndSwitch.exitBtn
		]
	});
	
	objAddAndSwitch.MainView=new Ext.Viewport({
        id:'MainViewId'
        ,layout : 'fit'
		,items:[
			objAddAndSwitch.mainWindow
		]
    });
	InitAddAndSwitchEvent(objAddAndSwitch);
	
	objAddAndSwitch.saveBtn.on("click", objAddAndSwitch.saveBtn_click, objAddAndSwitch);
	objAddAndSwitch.exitBtn.on("click", objAddAndSwitch.exitBtn_click, objAddAndSwitch);
	objAddAndSwitch.LoadEvent(arguments);
	return objAddAndSwitch;
}