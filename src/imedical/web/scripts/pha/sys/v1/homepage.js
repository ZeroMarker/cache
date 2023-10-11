/**
 * 名称:	 药房药库-药学首页-主页(工作台)
 * 编写人:	 Huxt
 * 编写日期: 2020-04-13
 * csp:  	 pha.sys.v1.homepage.csp
 * js:		 pha/sys/v1/homepage.js
 */
PHA_COM.App.Csp = "pha.sys.v1.homepage.csp"
PHA_COM.App.CspDesc = "药学首页"
PHA_COM.App.ProDesc = "公共业务"

$(function() {
	// 整体布局
	PHA_HOMEPAGE.Layout();
	// 设置按钮
	PHA_HOMEPAGE.InitSetBtn();
	// 卡片内容
	PHA_HOMEPAGE.InitCards();
});