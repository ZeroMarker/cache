/**
 * main.js 抗菌药物主界面
 * 
 * Copyright (c) 2016-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-07-24
 * 
 */
$(function(){
	//初始化组件显示状态
	$.DHCAnt.initKSSConfig(KSSConfig);
	$.DHCAnt.doBaseInfo(KSSConfig);
	$.DHCAnt.initConfigLayout(KSSConfig);
	
	$.DHCAnt.drawMainInerface();
	$.DHCAnt.extendFunction();
	$.DHCAnt.doUI();
});
 