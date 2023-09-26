Import sqluser

/// 请求单分流相关
/// 2015-5-12
/// 徐超
Class web.DHCSTMHUI.INRequestSplit Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod jsSetSplit(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=..SetSplit(Params)
	q RtnObj.Json()
}

/// Description:设置采购量(dhc_inreqitm中的INRQI_ProReqQty字段)
/// 
ClassMethod SetSplit(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!","")
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Inrqi=Obj.%Get("RowId")
		s NoTransQty=Obj.%Get("NotTransQty")
		continue:Inrqi=""
		continue:+NoTransQty'>0
		
		s DHCInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""),-1)
		i DHCInrqi'="" d
		.s InrqiObj=##class(User.DHCINReqItm).%OpenId(DHCInrqi)
		e  d
		.s InrqiObj=##class(User.DHCINReqItm).%New()
		.d InrqiObj.INRQIINRQIDRSetObjectId(Inrqi)
		s InrqiObj.INRQIProReqQty=NoTransQty
		s Sc=InrqiObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,Inrqi,"记录数据失败:"_Inrqi)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// 处理请求单明细数据
/// Author:徐超
/// Date:2015-05-12
/// Argu:
/// 	  Cstr-生成采购计划数据
/// 	  Ostr-出库数据
/// Return:
///    0 - success
///    <0 - failure
ClassMethod SplitDetail(Cstr As %String, Ostr As %String, StrParam As %String) As %String
{
  n (Cstr,Ostr,StrParam)
  s ^xuchaotmp("SplitDetail")=Cstr_","_Ostr_","_StrParam
  q:((Cstr="")&&(Ostr="")) -1
  s ret=0
  i Cstr'="" d
  .s ret=..UpdateC(Cstr,StrParam)
  q:ret'=0 ret
  i Ostr'="" d
  .s ret=..UpdateO(Ostr,StrParam)
  q ret
}

/// 根据请求明细生成采购计划
/// Author:徐超
/// Date:
/// ARgu:请求单明细串
/// Return:
///   0 -success
///   <0 -failure  
ClassMethod UpdateC(Cstr As %String, StrParam As %String) As %String
{
  n (Cstr,StrParam)
  s LocId=$p(StrParam,"^",1)
  s GroupId=$p(StrParam,"^",2)
  s UserId=$p(StrParam,"^",3)
  q:..sssLock("CstrOstr")<0 -99
  s Pid=..NewPid()
  s Len=$l(Cstr,"^")
  f i=1:1:Len d
  .s ReqId=$p(Cstr,"^",i)
  .q:ReqId=""
  .s Parref=+ReqId
  .s Chl=$p(ReqId,"||",2)
  .s IncId=$p(^INRQ(Parref,"RQI",Chl),"^",4)
  .q:IncId=""
  .s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
  .s scg=$p(scgInfo,"^",5)  //类组
  .q:scg=""
  .s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
  .s:HVFlag'="Y" HVFlag="N"
  .i '$d(^TMPINRequestSplit(Pid,"INRequestSplit",scg_"^"_HVFlag))  d
  ..s ^TMPINRequestSplit(Pid,"INRequestSplit",scg_"^"_HVFlag)=ReqId
  .e  d
  ..s ^TMPINRequestSplit(Pid,"INRequestSplit",scg_"^"_HVFlag)=^TMPINRequestSplit(Pid,"INRequestSplit",scg_"^"_HVFlag)_"^"_ReqId
  s ret=0
  s Scg=""
  f  s Scg=$o(^TMPINRequestSplit(Pid,"INRequestSplit",Scg)) q:(Scg="")!(ret'=0)  d
  .s Cstr2=^TMPINRequestSplit(Pid,"INRequestSplit",Scg)
  .ts
  .s ret=##class(web.DHCSTMHUI.INPurPlanAuxByReq).Create(LocId,UserId,Cstr2,$p(Scg,"^",1),GroupId)
  .d ##class(web.DHCSTMHUI.INPurPlan).SetComplete(ret)
  .i ret<0 tro
  .q:ret<0
  .s ret=..Update(Cstr2,"1",UserId)
  .i ret'=0 tro
  .q:ret'=0
  .tc
  d ..sssUnLock("CstrOstr")
  q ret
}

/// 处理请求单明细字段 INRQI_Type  C采购计划 O可出库
/// Author:徐超
/// Date:
/// ARgu:请求单明细串
/// Return:
///   0 -success
///   <0 -failure  
ClassMethod UpdateO(Ostr As %String, StrParam As %String) As %String
{
 n (Ostr,StrParam)
 s UserId=$p(StrParam,"^",3)
 s ret=0
 ts
 s ret=..Update(Ostr,"0",UserId)
 i ret'=0 tro
 q:ret'=0 ret
 tc
 q ret
}

ClassMethod Update(str As %String, Type As %String, UserId As %String) As %String
{
 n (str,Type,UserId)
 s ret=0 
 s d=+$h,t=$p($h,",",2)
 s Len=$l(str,"^")
 f i=1:1:Len d
 .s Reqi=$p(str,"^",i)
 .s Req=+Reqi
 .&sql(update DHC_INReqItm set INRQI_HandleType=:Type where INRQI_INRQI_DR=:Reqi)
 .i SQLCODE'=0 s ret =-1 
 .q:SQLCODE'=0
 .&sql(update dhc_inrequest set inrq_audituser_prov_dr=:UserId,inrq_auditdate_prov=:d,inrq_audittime_prov=:t where INRQ_INRQ_DR=:Req)
 .d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Req,"EA",UserId,"RQ")
 .i SQLCODE'=0  s ret=-6
 .q:SQLCODE'=0
 q ret
}

/// /更新标志
ClassMethod UpdateType(str As %String, Type As %String) As %String
{
 n (str,Type)
 s Len=$l(str,"^")
 f i=1:1:Len d
 .s Reqi=$p(str,"^",i)
 .&sql(update DHC_INReqItm set INRQI_HandleType=:Type where INRQI_INRQI_DR=:Reqi)
 q 0
}

/// 更新批准数量
ClassMethod UpdateQtyApproved(Reqi As %String, QtyApproved As %String) As %String
{
 n (Reqi,QtyApproved)
 &sql(update DHC_INReqItm set INRQI_QtyApproved=:QtyApproved where INRQI_INRQI_DR=:Reqi)
 q SQLCODE
}

}
