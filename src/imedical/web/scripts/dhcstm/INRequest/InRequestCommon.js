///名称:		库存请求相关公共方法及变量
///描述:		库存请求相关公共方法及变量
///编写者:	wangjiabin
///编写日期:	2014-04-11

//保存参数值的object
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
//科室类型全局变量
var INREQUEST_LOCTYPE = '';
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	INREQUEST_LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

/*保存参数配置属性：
是否需要请求方审核^是否需要供方审核
*/
var gParam=[]; 

function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.inrequestaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParam=info.split('^');
		}
	}
	return;
}
GetParam();

///是否需要请求方审核
function RecLocAuditRequired(){
	var result="";
	if (gParam.length>0) result=gParam[0];   
	return	result;
}

///是否需要供方审核
function ProvLocAuditRequired(){
	var result="";
	if (gParam.length>1) result=gParam[1];   
	return	result;
}

///return:起始日期
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

///return:截止日期
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

function IsSplit()
{
	if(gParam.length<1){
		GetParam();
	}

	return gParam[4];
	}
	