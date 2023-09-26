function InitviewScreen(){
	var obj = new Object();
	
	//��ʼ������ģ��
	var arrTabItems = [];
	if (typeof InitLIS == 'function') {
		obj = InitLIS(obj);                      //���� ����ϵͳ
		arrTabItems = arrTabItems.concat([obj.LISDATA_ViewPort]);
	}
	if (typeof InitOPR == 'function') {
		obj = InitOPR(obj);                      //���� ����ϵͳ
		arrTabItems = arrTabItems.concat([obj.OPRDATA_ViewPort]);
	}
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen',
		layout : 'border',
		items : [
			{
				region : 'north',
				layout : 'form',
				height : 45,
				frame : true,
				html : '<table border="0" width="100%" height="100%"><tr><td align="center" ><big><b>' + Title + '</b></big></td></tr></table>'
			},{
				region : 'center',
				layout : 'anchor',
				autoScroll : true,
				items : arrTabItems,
				bbar : ['->',"�����ͬ��ʱ�䡯Ϊ�գ���ʾ����δͬ����"]
			}
		]
	});
	
  InitviewScreenEvent(obj);
  obj.LoadEvent(arguments);
  return obj;
}


