/**
 * ����:	 ҩ��ҩ��-ҩѧ��ҳ-��ҳ(����̨)
 * ��д��:	 Huxt
 * ��д����: 2020-04-13
 * csp:  	 pha.sys.v1.homepage.csp
 * js:		 pha/sys/v1/homepage.js
 */
PHA_COM.App.Csp = "pha.sys.v1.homepage.csp"
PHA_COM.App.CspDesc = "ҩѧ��ҳ"
PHA_COM.App.ProDesc = "����ҵ��"

$(function() {
	// ���岼��
	PHA_HOMEPAGE.Layout();
	// ���ð�ť
	PHA_HOMEPAGE.InitSetBtn();
	// ��Ƭ����
	PHA_HOMEPAGE.InitCards();
});