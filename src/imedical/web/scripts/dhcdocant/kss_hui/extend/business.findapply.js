/**
 * main.js ����ҩ��������
 * 
 * Copyright (c) 2016-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-07-24
 * 
 */
$(function(){
	//��ʼ�������ʾ״̬
	$.DHCAnt.initKSSConfig(KSSConfig);
	$.DHCAnt.doBaseInfo(KSSConfig);
	$.DHCAnt.initConfigLayout(KSSConfig);
	
	$.DHCAnt.drawMainInerface();
	$.DHCAnt.extendFunction();
	$.DHCAnt.doUI();
});
 