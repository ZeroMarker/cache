
function InitNOTE(obj)
{
	var NoticeInfo="1��ϵͳ���Զ����ر��ξ����������Ϣ����ԭѧ���顢����ҩ��ʹ����Ϣ��" ;
	NoticeInfo = NoticeInfo + '<br>';
	NoticeInfo = NoticeInfo + "2�������ʱ�㡾��ȡ����ťѡ�����Ⱦ��ؼ�¼�;����Ҫ�ļ�¼ѡ�С�ɾ�������ɡ�";
	NoticeInfo = NoticeInfo + '<br>';
	NoticeInfo = NoticeInfo + "3����Ⱦ������д��ɺ�㡾�ύ����ť������ʾδ��ɣ�����ʾ��ɱ��桾�ύ�����ɡ�";
	obj.NOTE_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 100,
		anchor : '-20',
		tbar : ['<b>ע������</b>'],
		items : [
			{
				layout : 'fit',
				frame : true,
				html: '<table border="0" width="100%" height="100%" style="color:red;"><tr><td align="left" >' + NoticeInfo + '</td></tr></table>'
			}
		]
	}
	return obj;
}