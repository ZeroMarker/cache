/**
 * @Title: 基础数据平台-翻译功能配置
 * @Author: 谷雪萍 DHC-BDP
 * @Description: 用于 各个页面的元素翻译配置
 * @Created on 2015-4-23
 * @Updated on 2015-5-24 by guxueping
 * @LastUpdated on 2015-4-27 by guxueping(修复BUG)
 */

/**----------------------------------调用元素授权控件JS--------------------------------------**/	 
	var BDPItemJS1 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.ux.Multiselect.js';		//菜单授权部分
	var BDPItemJS2 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/DDView.js';  		//元素功能授权部分	
	var BDPItemJS3 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.form.MultiSelect.js';  		//元素功能授权部分	
	var BDPItemCSS = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Multiselect.css';
	
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS1+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS2+'"></scr' + 'ipt>');
    document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS3+'"></scr' + 'ipt>');
    document.write('<link rel="stylesheet"' + 'ipt type="text/css" href="'+BDPItemCSS+'"></scr' + 'ipt>');
/**----------------------------------调用元素授权控件JS--------------------------------------**/	
    
    var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDPAuthorize_Item/BDPAuthorize_Item.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
/**----------------------------------调用附属JS--------------------------------------**/		
	var BDPItemJS = '../scripts/bdp/App/BDPSystem/BDPTranslationAut.js';  		//元素功能授权部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS+'"></scr' + 'ipt>');
	
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
/**----------------------------------调用附属JS--------------------------------------**/	


	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量

Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();

	/** 初始化TabPanel */
	var ItemPanel = new Ext.Panel({
		region:"center",
		layout : 'border',
		id:'ExecutablePanel',
		items:[ExecutabletreePanel,TABPANEL]
	}); 
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[ItemPanel]
    	});
    	
});