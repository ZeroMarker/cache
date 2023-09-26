
function InitNOTE(obj)
{
	var NoticeInfo="1、系统不自动加载本次就诊的手术信息、病原学检验、抗菌药物使用信息。" ;
	NoticeInfo = NoticeInfo + '<br>';
	NoticeInfo = NoticeInfo + "2、填报报告时点【提取】按钮选择与感染相关记录填报;不需要的记录选中【删除】即可。";
	NoticeInfo = NoticeInfo + '<br>';
	NoticeInfo = NoticeInfo + "3、感染报告填写完成后点【提交】按钮，如提示未完成，按提示完成报告【提交】即可。";
	obj.NOTE_ViewPort = {
		layout : 'fit',
		//frame : true,
		height : 100,
		anchor : '-20',
		tbar : ['<b>注意事项</b>'],
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