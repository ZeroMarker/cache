/// DHCBillMenuLeft.js

//var _QUERY_URL='./jQueryTest.csp';

$(function() {

	/*
	$.messager.alert('消息',XMLHttpRequest.readyState);
	$.messager.alert('消息',XMLHttpRequest.statusText);
	$.messager.alert('消息',XMLHttpRequest.responseText);
	$.messager.alert('消息',XMLHttpRequest.status);
	var obj = new DHCMenu();
	obj.InitMenu(_menus,"basic",'#wnav',"tt1");
	obj.addNav();
	obj.InitLeftMenu();
	*/
	// 初始化折叠菜单
	$.dhc.util.runServerMethod("web.DHCBillMenu","jQueryWriteJson","false",function testget(value){
		var obj = new DHCMenu();
		obj.Clearnav();
		
		obj.InitMenu(value,"basic",'#wnav',"tt1");
		obj.addNav();
		obj.InitLeftMenu();
	    obj.tabClose();
	    obj.tabCloseEven();
	},"","","basic");
	
});

/*
var _menus={
	"basic": [{"menuid" : "7", "icon" : "icon-sys", "menuname" : "����ά��", "menus" : [{ "menuid" : "14", "icon" : "icon-nav", "menuname" : "�շ���Ŀ����", "menus" : [{ "menuid" : "21", "icon" : "icon-nav", "menuname" : "�շ���Ŀ����", "url" : "dhcopbillmenu.settarcatetype.csp"},{ "menuid" : "22", "icon" : "icon-nav", "menuname" : "�շ���Ŀ����", "url" : "dhcopbillmenu.settarsubcatetype.csp"}]},{ "menuid" : "15", "icon" : "icon-nav", "menuname" : "סԺ���÷���", "menus" : [{ "menuid" : "23", "icon" : "icon-nav", "menuname" : "סԺ���ô���", "url" : "dhcopbillmenu.settarictype.csp"},{ "menuid" : "24", "icon" : "icon-nav", "menuname" : "סԺ��������", "url" : "dhcopbillmenu.settarinpatcatetype.csp"}]},{ "menuid" : "16", "icon" : "icon-nav", "menuname" : "������÷���", "menus" : [{ "menuid" : "25", "icon" : "icon-nav", "menuname" : "������ô���", "url" : "dhcopbillmenu.settaroctype.csp"},{ "menuid" : "26", "icon" : "icon-nav", "menuname" : "�����������", "url" : "dhcopbillmenu.settaroutpatcatetype.csp"}]},{ "menuid" : "17", "icon" : "icon-nav", "menuname" : "���ú�����÷���", "menus" : [{ "menuid" : "27","icon" : "icon-nav", "menuname" : "���ú������", "url" : "dhcopbillmenu.settarectype.csp"},{ "menuid" : "28", "icon" : "icon-nav", "menuname" : "���ú�������", "url" : "dhcopbillmenu.settaremccatetype.csp"}]},{ "menuid" : "18", "icon" : "icon-nav", "menuname" : "������ҳ���÷���", "menus" : [{ "menuid" : "29", "icon": "icon-nav", "menuname" : "������ҳ����", "url" : "dhcopbillmenu.settarmctype.csp"},{ "menuid" : "30", "icon" : "icon-nav", "menuname" : "������ҳ����", "url": "dhcopbillmenu.settarmrcatetype.csp"}]},{ "menuid" : "19", "icon" : "icon-nav", "menuname" : "��Ʒ��÷���", "menus" : [{ "menuid" : "31", "icon" : "icon-nav", "menuname" : "��Ʒ��ô���", "url" : "dhcopbillmenu.settaractype.csp"},{ "menuid" : "32", "icon" : "icon-nav", "menuname" : "��Ʒ�������", "url" : "dhcopbillmenu.settaracctcatetype.csp"}]},{ "menuid" : "20", "icon" : "icon-nav", "menuname" : "�²�����ҳ���÷���", "menus" : [{ "menuid" : "33", "icon" : "icon-nav", "menuname" : "�²�����ҳ����", "url" : "dhcopbillmenu.settarnmrtype.csp"},{ "menuid" : "34", "icon" : "icon-nav", "menuname" : "�²�����ҳ����", "url" : "dhcopbillmenu.settarnmrcatetype.csp"}]}]},{"menuid" : "8", "icon" : "icon-sys", "menuname" : "�������", "menus" : [{ "menuid" : "35", "icon" : "icon-nav", "menuname" : "���˾������", "url" : "dhcopbillmenu.setepisodesubtype.csp"},{ "menuid" : "36", "icon" : "icon-nav", "menuname" : "�����շ����", "url" : "dhcopbillmenu.setadmreasontype.csp"}]},{"menuid" : "9", "icon" : "icon-sys", "menuname" : "�շ���Ŀ", "menus" : [{ "menuid" : "37", "icon" : "icon-nav", "menuname" : "�շ���Ŀ��ѯ", "url" : "dhcopbillmenu.settaritem.csp"},{ "menuid" : "38", "icon" : "icon-nav", "menuname" : "ҽ�����շ���Ŀ��Ӧ��", "url" : "dhcopbillmenu.setorderlinktar.csp"},{ "menuid" : "39", "icon" : "icon-nav", "menuname" : "�շ���Ŀ�޸Ĳ�ѯ","url" : ""}]},{"menuid" : "10", "icon" : "icon-sys", "menuname" : "�Ʒ�����", "menus" : [{ "menuid" : "40", "icon" : "icon-nav", "menuname" : "ҽ���Ʒѵ�����","url" : "dhcopbillmenu.setbillconditiontype.csp"},{ "menuid" : "41", "icon" : "icon-nav", "menuname" : "����������׼�۸�", "url" : "dhcopbillmenu.settarepisodetype.csp"},{ "menuid" : "42", "icon" : "icon-nav", "menuname" : "�����ۿۼ���ϵ���", "url" : "dhcopbillmenu.settarfactortype.csp"},{ "menuid" : "43", "icon" : "icon-nav", "menuname" : "ϵͳ���ò����", "url" : ""},{ "menuid" : "44", "icon" : "icon-nav", "menuname" : "סԺҵ������", "url" : ""}]},{"menuid" : "11", "icon" : "icon-sys", "menuname" : "Ƿ�ѹ���", "menus" : [{ "menuid" : "45", "icon" : "icon-nav", "menuname" : "Ƿ�ѿ��Ƽ���", "url" : ""},{ "menuid" : "46", "icon" : "icon-nav", "menuname" : "����ɫͨ��Ƿ�Ѷ��", "url" : ""},{ "menuid" : "47", "icon" : "icon-nav", "menuname" : "Ƿ�ѹ��?�ܿ��Ƶĵ�½����", "url" : ""}]},{"menuid" : "12", "icon" : "icon-sys", "menuname" : "��������", "menus" : [{ "menuid" : "48", "icon" : "icon-nav", "menuname" : "Ѻ���վݺͷ�Ʊ��Ա����", "url" : ""},{ "menuid" : "49", "icon" : "icon-nav", "menuname" : "ҽԺ��������", "url" : ""},{ "menuid" : "50", "icon" : "icon-nav", "menuname" : "��Ѻ��ԭ������", "url" : ""},{ "menuid" : "51", "icon" : "icon-nav", "menuname" : "��ӡҽ������������", "url" : ""},{ "menuid" : "52", "icon" : "icon-nav", "menuname" : "�޸ļ۸�ȫ������", "url" : ""},{ "menuid" : "53", "icon" : "icon-nav", "menuname" :"������Ч��������", "url" : ""}]}]
} */