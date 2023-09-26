//名称: 高值跟踪相关公共方法及变量
//wangjiabin	2013-10-16

//保存参数值的object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
//是否启用高值跟踪
var UseItmTrack=ItmTrackParamObj.UseItmTrack=='Y'?true:false;

//起始日期
function TrackDefaultStDate(){
	var Today = new Date();
	var DefaStartDate = ItmTrackParamObj.DefaStartDate;
	if(isEmpty(DefaStartDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);		
}

//结束日期
function TrackDefaultEdDate(){
	var Today = new Date();
	var DefaEndDate = ItmTrackParamObj.DefaEndDate;
	if(isEmpty(DefaEndDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

/**
 * 检查类组关联关系,若Scg是CheckScg的子类,返回true, 否则返回false
 * @param {} CheckScg
 * @param {} Scg
 * @return {Boolean}
 */
function CheckScgRelation(CheckScg, Scg){
	if(isEmpty(CheckScg) || isEmpty(Scg)){
		return true;
	}
	var ChildScg = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetAllChildScgStr', CheckScg, ',');
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
	}else if(value=="P" || value=="MP"){
		TypeDesc="住院医嘱";
	}else if(value=="Y" || value=="MY"){
		TypeDesc="住院医嘱取消";
	}else if(value=="A"){
		TypeDesc="库存调整";
	}else if(value=="D"){
		TypeDesc="库存报损";
	}else if(value=="F" || value=="MF"){
		TypeDesc="门诊医嘱";
	}else if(value=="H" || value=="MH"){
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

function StatusFormatter(value){
	var Status = value;
	if (value=="Enable"){
	   Status="可用";
	}else if(value=="Return"){
		Status="退货";
	}else if(value=="Used"){
		Status="已使用";
	}else if(value=="InScrap"){
		Status="报损";
	}else if(value=="InAdj"){
		Status="调整";
	}else if(value=="InIsTrf"){
		Status="出库";
	}else if(value==""){
		Status="注册";
	}
	return Status;
}

/**
 * 检查明细部分高值材料条码是否相符
 * @param {业务台账类型} Type
 * @param {业务主表rowid} Main
 * @return {Boolean} true:满足, false:不满足
 */
function CheckHighValueLabels(Type, Main){
	var CheckResult = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'CheckLabelsByPointer', Type, Main);
	if(!isEmpty(CheckResult)){
		$UI.msg('error', '高值材料 ' + CheckResult + ' 没有录入条码或录入的条码数与入库数量不符!')
		return false;
	}
	return true;
}
