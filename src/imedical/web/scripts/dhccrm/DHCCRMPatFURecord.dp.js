Ext.onReady(LoadPage);
//Ext.BLANK_IMAGE_URL = 'pic/blank.gif';
function LoadPage()
{
	//Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL='../scripts/DHCCRM/Ext2/resources/images/default/s.gif';
    // turn on validation errors beside the field globally
    //Ext.form.Field.prototype.msgTarget = 'side';
	
	//Ext.lib.Ajax.defaultPostHeader += ";charset=utf-8"; //Ajax的传输方式都统一为了utf-8编码
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());  //状态管理，这里采用了cookie的状态管理方式，也就是一些状态的数据保存在cookie中

	//CreateMainPanel();
	
	CreateMainWindow();
	panel.show()
	//View();
}

function View()
{
	mainView = new Ext.Viewport({
    
        layout: 'border',
        collapsible: true,
        items: [panel]
    
    });
}




