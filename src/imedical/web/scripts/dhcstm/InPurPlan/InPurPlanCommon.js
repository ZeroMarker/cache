// /名称: 采购计划相关公共方法及变量
// /描述: 采购计划相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.09.27

//保存参数值的object
var InPurPlanParamObj = GetAppPropValue('DHCSTPURPLANAUDITM');

/*保存参数配置属性：
 * 进价是否可以为空^是否自动审批^默认查找起始日期^默认查找截止日期^供应商必填
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-27
 * description:取采购计划相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.inpurplanaction.csp?actiontype=GetParamProp&groupId='+groupId+'&locId='+locId+'&userId='+userId;
	var response=ExecuteDBSynAccess(url);
	//var jsonData=Ext.util.JSON.decode(response);
	//if(jsonData.success=='true'){
		//var info=jsonData.info;
		if(response!=null || response!=''){
			gParam=response.split('^');
		}
	//}
	/*
	Ext.Ajax.request({
		url:'dhcstm.ingdrecaction.csp',
		method:'post',
		params:{actiontype:'GetParamProp',GroupId:groupId,LocId:locId,UserId:userId},
		success:function(response,opts){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			if(jsonData.success=='true'){
				var info=jsonData.info;
				if(info!=null || info!=''){
					gParam=info.split('^');
				}
			}
		}
	
	});
	*/
	return;
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate(){
	if(gParam.length<1){
		GetParam();
	}
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	if(gParam.length<1){
		GetParam();
	}
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}