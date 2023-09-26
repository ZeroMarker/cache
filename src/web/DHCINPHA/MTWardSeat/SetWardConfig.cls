/// Description:设置病区列表参数配置相关
/// Creator:    hulihua
/// CreateDate: 2017-03-01
/// Table:      
Class web.DHCINPHA.MTWardSeat.SetWardConfig Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:保存病区列表设置的相关信息
/// Creator:	hulihua
/// CreateDate:	2017-03-01
/// Table:      
/// Input:
/// Output:
/// Return：    成功:0
ClassMethod SaveSetWardSeat(Input As %String, LocId As %String) As %Library.String
{
	n (Input,LocId)
    s WardSeatSize=$p(Input,"^",1)
    s:WardSeatSize="" WardSeatSize=6*10
    s WardSeatTime=$p(Input,"^",2)
    s:WardSeatTime="" WardSeatTime=10
	s ^DHCINPHAPID("DHCINPHA","SetWardSeat",LocId)=WardSeatSize_"^"_WardSeatTime
 	q 0
}

/// Description:通过科室ID查询病区总数
/// Table：^DHCEMPSE
/// Input：LocName:科室ID
/// Return：病床信息以及病人信息
/// w ##class(web.DHCINPHA.MTWardSeat.SetWardConfig).SelAllWardSeatInfo("^102")
ClassMethod SelAllWardSeatInfo(params As %String)
{
	N (params)
	s LocId=$p(params,"^",2)
	s ParamPropStr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp(params)
	S SeatSize=$p(ParamPropStr,"^",1)_"*"_$p(ParamPropStr,"^",2)
	S RefreshTime=$p(ParamPropStr,"^",3) 
	S PhaFlagStr=##class(web.DHCSTPHALOC).GetPhaflag(LocId)
	S StartDate=$p(PhaFlagStr,"^",3)
	S StartDate=##class(web.DHCSTKUTIL).GetDate("","",StartDate)
	S EndDate=$p(PhaFlagStr,"^",4)
	S EndDate=##class(web.DHCSTKUTIL).GetDate("","",EndDate)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	D ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"SelAllWardSeatInfo",pid,"WARDQUE")
	S WardLoc=""
	F  S WardLoc=$o(^DHCPHSLi("PHLOC",LocId,WardLoc)) Q:WardLoc=""  D
	.S PhlsId=$o(^DHCPHSLi("PHLOC",LocId,WardLoc,""),-1)	
	.S WardQue=$p(^DHCPHSL(PhlsId),"^",7)
	.S:WardQue="" WardQue=10000
	.S Index=WardQue
	.S ^TMP("DHCINPHA",$this,"SelAllWardSeatInfo",pid,"WARDQUE",Index,WardLoc)=""
	;
	S Index="",StrRs=""
	F  S Index=$O(^TMP("DHCINPHA",$this,"SelAllWardSeatInfo",pid,"WARDQUE",Index))  Q:Index=""  D
	.S WardLoc=""
	.F  S WardLoc=$O(^TMP("DHCINPHA",$this,"SelAllWardSeatInfo",pid,"WARDQUE",Index,WardLoc))  Q:WardLoc=""  D
	..S WardDesc=$p(^CTLOC(WardLoc),"^",2)
	..S WardCode=$p(^CTLOC(WardLoc),"^",51)
	..i WardCode="" s WardCode=$p(^CTLOC(WardLoc),"^",2)
	..S WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
	..S ReqStrNum=##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).GetReqTypeNum(StartDate,EndDate,LocId,WardLoc,"10")
	..I ReqStrNum="0^0^0^0" d
	...k ^DHCINPHAPID("DHCINPHA","SetMessageByAudit",LocId,WardLoc)
	..S AuditConFlag=$s($D(^DHCINPHAPID("DHCINPHA","SetMessageByAudit",LocId,WardLoc)):1,1:0)
	..S StrRs=StrRs_"^"_WardCode_"^"_WardDesc_"^"_WardLoc_"^"_WardId_"^"_ReqStrNum_"^"_AuditConFlag_"$$"
	.
	S jsonRs = ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData("size@refreshtime@text",SeatSize_"@"_RefreshTime_"@"_StrRs,"@")
	D ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"SelAllWardSeatInfo",pid,"WARDQUE")
	Q jsonRs
}

/// Description:改变护士领药审核给药房发送开始备药的信息
/// Creator:	hulihua
/// CreateDate:	2017-03-13
/// Table: 		^DHCINPHAPID("DHCINPHA","SetMessageByAudit")     
/// Input:		PhLoc-药房科室ID,WardId-病区ID
/// Output:
/// Return：    成功：0，药房科室为空：-1，病区为空：-2
ClassMethod UpdateMessageByAudit(PhLoc As %String, WardId As %String) As %Library.String
{
	N (PhLoc,WardId)
	Q:PhLoc="" -1
	Q:WardId="" -2
	S WardLoc=$p(^PAWARD(WardId),"^",5)
	S ^DHCINPHAPID("DHCINPHA","SetMessageByAudit",PhLoc,WardLoc)=""
 	Q 0
}

/// zhangxiangbo
/// 20180823
/// 护士点开始备药的时候  把当天内没有置备药时间和备药人的请领单全部置上当前时间和当前登录人
/// w ##class(web.DrugAuditNew).SetReadyDrugInfo("11","246")
/// ^DHCINPHREQi("WardDate",246,64882,712)=
ClassMethod SetReadyDrugInfo(userId As %String, WardId As %String) As %String
{
	N (userId,WardId)
	i WardId="" q ""
	S WardLocId=$p(^PAWARD(WardId),"^",5)
	f date=(+$H-1):1:(+$H) d
	.s id="" 
	.f  s id=$O(^DHCINPHREQi("WardDate",WardLocId,date,id)) q:(id="")  d
	..s ReadDate=$P($G(^DHCINPHREQ(id)),"^",15)
	..q:(ReadDate'="")   //等于空说明已经发起过开始备药
	..s objPhr=##class(User.DHCInPhReq).%OpenId(id)
	..s objPhr.PHRStartDateDrug=+$H
	..s objPhr.PHRStartTimeDrug=$P($H,",",2)
	..d objPhr.PHRReadyDrugUserSetObjectId(userId)
	..d objPhr.%Save()
	.
	q 0
}

Storage Default
{
<Data name="SetWardConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHAD931.SetWardConfigD</DataLocation>
<DefaultData>SetWardConfigDefaultData</DefaultData>
<IdLocation>^web.DHCINPHAD931.SetWardConfigD</IdLocation>
<IndexLocation>^web.DHCINPHAD931.SetWardConfigI</IndexLocation>
<StreamLocation>^web.DHCINPHAD931.SetWardConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
