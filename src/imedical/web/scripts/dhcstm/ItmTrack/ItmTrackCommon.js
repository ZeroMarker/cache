//名称: 高值跟踪相关公共方法及变量
//wangjiabin	2013-10-16

//保存参数值的object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');

/*保存参数配置属性：
 *  物资库是否使用高值跟踪功能^默认查找起始日期^默认查找截止日期
*/
var gItmTrackParam=[];

//取高值跟踪参数
function GetItmTrackParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.itmtrackaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gItmTrackParam=info.split('^');
		}
	}

	return;
}

//起始日期
function DefaultStDate(){
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
	}
	var today=new Date();
	if(gItmTrackParam.length<2){
		return today;
	}
	
	var defaStDate=gItmTrackParam[1];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

//结束日期
function DefaultEdDate(){
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
	}
	var today=new Date();
	if(gItmTrackParam.length<3){
		return today;
	}

	var defaEdDate=gItmTrackParam[2];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}

/**
 * 检查类组关联关系,若Scg是CheckScg的子类,返回true, 否则返回false
 * @param {} CheckScg
 * @param {} Scg
 * @return {Boolean}
 */
function CheckScgRelation(CheckScg, Scg){
	if(Ext.isEmpty(CheckScg) || Ext.isEmpty(Scg)){
		return true;
	}
	var ChildScg = tkMakeServerCall('web.DHCSTM.Common.DrugInfoCommon', 'GetAllChildScgStr', CheckScg, ',');
	var ChildScgArr = ChildScg.split(',');
	return (ChildScgArr.indexOf(Scg) >= 0);
}

function TypeRenderer(value){
	var TypeDesc=value;
	if(value=="G"){
		TypeDesc="入库";
	}else if(value=="R"){
		TypeDesc="退货";
	}else if(value=="T"){
		TypeDesc="转移出库";
	}else if(value=="K"){
		TypeDesc="转移接收";
	}else if(value=="P"){
		TypeDesc="住院医嘱";
	}else if(value=="Y"){
		TypeDesc="住院医嘱取消";
	}else if(value=="MP"){
		TypeDesc="住院医嘱";
	}else if(value=="MY"){
		TypeDesc="住院医嘱取消";
	}else if(value=="A"){
		TypeDesc="库存调整";
	}else if(value=="D"){
		TypeDesc="库存报损";
	}else if(value=="F"){
		TypeDesc="门诊医嘱";
	}else if(value=="H"){
		TypeDesc="门诊医嘱取消";
	}else if(value=="MF"){
		TypeDesc="门诊医嘱";
	}else if(value=="MH"){
		TypeDesc="门诊医嘱取消";
	}else if(value=="RD"){
		TypeDesc="请求";
	}else if(value=="PD"){
		TypeDesc="采购";
	}else if(value=="POD"){
		TypeDesc="订单";
	}else if(value=='SG'){
		TypeDesc="补录入库";
	}else if(value=='ST'){
		TypeDesc="补录出库";
	}else if(value=='SK'){
		TypeDesc="补录出库-接收";
	}else if(value=='SR'){
		TypeDesc="补录入库-退货";
	}else if(value=='SP'){
		TypeDesc="补录医嘱消减";
	}
	return TypeDesc;
}
function PrintRenderer(value){
	var printFlag=value;
	if (value=="Y"){
	   printFlag="已打印";
	}
	return printFlag;
}
function statusRenderer(value){
    var Status=value;
	if (value=="Enable"){
	   Status="可用";
	}
	else if(value=="Return"){
		Status="退货";
	}
	else if(value=="Used"){
		Status="已使用";
	}
	else if(value=="InScrap"){
		Status="报损";
	}
	else if(value=="InAdj"){
		Status="调整";
	}
	else{
		Status=value;
	}
	return Status;
}
