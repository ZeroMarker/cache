// /名称: 调价相关公用方法
// /描述: 调价相关公用方法
// /编写者：zhangdongmei
// /编写日期: 2012.12.27

var gParam=[];

function GetParams(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+'inadjpriceaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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

//取是否根据定价类型计算售价标志:1:计算；0：不计算
function GetCalSpFlag(){
	if(gParam.length<1){
		GetParams();
	}
	var flag=0;
	if(gParam.length>0){
		flag=gParam[0];
	}
	return flag;
}
//是否根据上一行的值默认新录行的调价原因
function IfSetAspReason(){
	if(gParam.length<1){
		GetParams();
	}
	return gParam[1];
}
// 取是否验证最高售价参数
function ValidateMaxSp(){
	if(gParam.length<1){
		GetParams();
		}
	return gParam[5];
	}