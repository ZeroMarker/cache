Import sqluser

Class web.DHCSTMHUI.INRequestTemplate Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Creator:XuChao
/// Date:2018-5-18
/// Description:  检索某科室的请求单模板
/// Arguments:
///   loc - 科室rowid，reqType-申请类型（'O'库存请求，'C'申领计划），HVflag-高值标志（'Y'高值 'N'非高值 ''全部）
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestTemplate","ReqTem","{""ReqLoc"":""1"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""HvFlag"":"""",""ReqType"":""O""}")
Query ReqTem(Params As %String) As websys.Query(ROWSPEC = "RowId,ReqNo,Date,Time,UserName,Remark,Complete,SupLocDesc") [ SqlProc ]
{
}

ClassMethod ReqTemExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("ReqLoc")
	s ReqType=PJObj.%Get("ReqType")
	s pHvFlag=PJObj.%Get("HvFlag")
	q:Loc="" $$$OK
	
	s Req=0
	f  s Req=$o(^DHCINRQ(0,"LocTem","Y",Req)) q:Req=""  d
	.q:'$d(^INRQ(0,"RecLoc",Loc,Req))  //此模板非当前科室
	.&sql(select 
		inrq_no,inrq_date,inrq_time,inrq_ssusr_dr->ssusr_name,
		inrq_remarks,inrq_usercompleted,INRQ_ReqLoc_DR
		into
		:ReqNo,:Date,:Time,:User,
		:Remark,:Complete,:SupLocId
		from in_request
		where inrq_rowid=:Req and INRQ_Status=:ReqType
	 )
	.q:SQLCODE
	.s HvFlag=##class(web.DHCSTMHUI.INRequest).GetReqHVFlag(Req)
	.q:(pHvFlag'="")&&(pHvFlag'=HvFlag)
	.s Date=..DL2H(Date)
	.s Time=..TL2H(Time)
	.s Remark=$LTS(Remark)
	.s SupLocDesc=$s(SupLocId'="":$p(^CTLOC(SupLocId),"^",2),1:"")
	.d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(Req,ReqNo,Date,Time,User,
		Remark,Complete,SupLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:另存生成请求模板
/// CreateDate:	2022-08-02
/// w ##class(web.DHCSTMHUI.INRequestTemplate).jsSaveAsTem()
ClassMethod jsSaveAsTem(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveAsTem(Params)
	q RtnObj.Json()
}

ClassMethod SaveAsTem(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s ReqId=PJObj.%Get("ReqId")
	s UserId=PJObj.%Get("gUserId")
	q:ReqId="" RtnObj.Err(-1,"","入参错误!")
	
	s DHCInrq=$o(^DHCINRQ(0,"INRQ",ReqId,""),-1)
	
	s SupLoc=$p(^INRQ(ReqId),"^",5)
	s ReqLoc=$p(^INRQ(ReqId),"^",6)
	s (ReqType,ScgId,StkType)=""
	i DHCInrq'="" d
	.s ReqType=$p(^DHCINRQ(DHCInrq),"^",1)
	.s ScgId=$p(^DHCINRQ(DHCInrq),"^",10)
	.s StkType=$p(^DHCINRQ(DHCInrq),"^",31)
	i StkType'=..sssCode() q RtnObj.Err(-1,"","非耗材系统单据,不允许另存","",0)
	
	ts
	s Template="Y"
	s MainData=SupLoc_"^"_ReqLoc_"^"_UserId_"^"_ScgId_"^"_ReqType_"^"_Template
	s MainTitle="SupLoc^ReqLoc^gUserId^ScgStk^ReqType^Template"
	s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	s RtnObj=##class(web.DHCSTMHUI.INRequest).Update(Main)
	i RtnObj.success<0 tro  q RtnObj
	s Inrq=RtnObj.rowid
	
	s Ch=0
	f  s Ch=$o(^INRQ(ReqId,"RQI",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	.s ReqQty=$p(^INRQ(ReqId,"RQI",Ch),"^",3)
	.s Inci=$p(^INRQ(ReqId,"RQI",Ch),"^",4)
	.s UomId=$p(^INRQ(ReqId,"RQI",Ch),"^",5)
	.s ItmArr=[]
	.s ItmObj={}
	.s ItmObj.Inci=Inci
	.s ItmObj.Uom=UomId
	.s ItmObj.Qty=ReqQty
	.d ItmArr.%Push(ItmObj)
	.s Detail=ItmArr.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.INReqItm).Save(Inrq,Detail)
	.q:RtnObj.success<0
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=Inrq
	q RtnObj
}

}
