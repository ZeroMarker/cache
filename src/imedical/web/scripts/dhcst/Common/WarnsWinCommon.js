///����:		���Ѵ��ڹ�������
///����:		���Ѵ��ڹ�������
///��д��:	    hulihua
///��д����:	2014-11-20��д�ڳ��ζ�Ժ��

/*��������������ԣ�
*/
var userId = session['LOGON.USERID'];
var groupId=session['LOGON.GROUPID'];
var locId=session['LOGON.CTLOCID'];
var warnswinParam=[]; 
///��ȡ���õķ�����
function GetWarnsParam(){
	
	var url='dhcst.warnswinaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			warnswinParam=info.split('^');
		}
	}
	return;
}

if(warnswinParam.length<1){
	GetWarnsParam();  //��ʼ����������
}

var task = {
	run: function(){
		var htmlstr=''
		Ext.Ajax.request({
			url : 'dhcst.warnswinaction.csp?actiontype=GetWarns&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					if(jsonData.info!=""){
						htmlstr=jsonData.info;
						if(htmlstr!=""){
							var warnswin=new Ext.ux.WarnsWindow({
								title:"<img src="+"../scripts/dhcst/ExtUX/images/tipswarning.gif"+">"+"<font color=#15428b size=2>������������<font>",
								autoHide:warnswinParam[2],///�Զ��ر�ʱ�� ����
								html:htmlstr
							});
							warnswin.show();
						}
					}
				}
			},
			scope : this
		});
	},
	interval: 1000*60*warnswinParam[0], //ȡ���õķ�����ֵ
	repeat:Number(warnswinParam[1])     //�ظ�����
}
Ext.TaskMgr.start(task);
