///名称:		提醒窗口公共方法
///描述:		提醒窗口公共方法
///编写者:	    hulihua
///编写日期:	2014-11-20（写于长治二院）

/*保存参数配置属性：
*/
var userId = session['LOGON.USERID'];
var groupId=session['LOGON.GROUPID'];
var locId=session['LOGON.CTLOCID'];
var warnswinParam=[]; 
///获取配置的分钟数
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
	GetWarnsParam();  //初始化参数配置
}

var task = {
	run: function(){
		var htmlstr=''
		Ext.Ajax.request({
			url : 'dhcst.warnswinaction.csp?actiontype=GetWarns&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					if(jsonData.info!=""){
						htmlstr=jsonData.info;
						if(htmlstr!=""){
							var warnswin=new Ext.ux.WarnsWindow({
								title:"<img src="+"../scripts/dhcst/ExtUX/images/tipswarning.gif"+">"+"<font color=#15428b size=2>待处理单据提醒<font>",
								autoHide:warnswinParam[2],///自动关闭时间 配置
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
	interval: 1000*60*warnswinParam[0], //取配置的分钟数值
	repeat:Number(warnswinParam[1])     //重复次数
}
Ext.TaskMgr.start(task);
