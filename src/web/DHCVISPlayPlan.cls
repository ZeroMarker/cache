Import SQLUser

Class web.DHCVISPlayPlan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//w ##Class(web.DHCVISPlayPlan).GetPlayPlan("192.168.1.188")

ClassMethod GetPlayPlan(clientIP As %String) As %String
{
	s retStr="",retStr1="",retStr2="",retStr3=""
	i $G(clientIP)="" s clientIP=$ZUTIL(67,15,$JOB)
	s clientId=$O(^DHCVISClienti(0,"ClientIP",clientIP,""))
	i clientId'="" d 
	.s planDR=""
	.f  s planDR=$O(^DHCVISPlani(0,"ClientDR",clientId,planDR)) q:planDR=""  d
	..s planStr=$G(^DHCVISPlan(planDR))
	..q:planStr=""
	..s URL=$P(planStr,"^",5)
	..q:URL=""
	..s SeqNo=""
	..f  s SeqNo=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo)) q:SeqNo=""  d
	...s planItemDR=""
	...f  s planItemDR=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo,planItemDR)) q:planItemDR=""  d
	....s planItemStr=$G(^DHCVISPlanItem(planItemDR))
	....q:planItemStr=""
	....s fileName=$P(planItemStr,"^",2)
	....s activeFlag=$P(planItemStr,"^",3)
	....q:activeFlag="N"
	....i retStr1="" s retStr1=URL_fileName
	....e  s retStr1=retStr1_"!"_URL_fileName
	s serverId=$O(^DHCVISServeri(0,"ServerIP",clientIP,""))
	i serverId'="" d
	.s planDR=""
	.f  s planDR=$O(^DHCVISPlani(0,"ServerDR",serverId,planDR)) q:planDR=""  d
	..s planStr=$G(^DHCVISPlan(planDR))
	..q:planStr=""
	..s URL=$P(planStr,"^",5)
	..q:URL=""
	..s SeqNo=""
	..f  s SeqNo=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo)) q:SeqNo=""  d
	...s planItemDR=""
	...f  s planItemDR=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo,planItemDR)) q:planItemDR=""  d
	....s planItemStr=$G(^DHCVISPlanItem(planItemDR))
	....q:planItemStr=""
	....s fileName=$P(planItemStr,"^",2)
	....s activeFlag=$P(planItemStr,"^",3)
	....q:activeFlag="N"
	....i retStr2="" s retStr2=URL_fileName
	....e  s retStr2=retStr2_"!"_URL_fileName
	s planDR=""
	f  s planDR=$O(^DHCVISPlani(0,"SysFlag","Y",planDR)) q:planDR=""  d
	.s planStr=$G(^DHCVISPlan(planDR))
	.q:planStr=""
	.s URL=$P(planStr,"^",5)
	.q:URL=""
	.s SeqNo=""
	.f  s SeqNo=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo)) q:SeqNo=""  d
	..s planItemDR=""
	..f  s planItemDR=$O(^DHCVISPlanItemi(0,"PlanSeqNo",planDR,SeqNo,planItemDR)) q:planItemDR=""  d
	...s planItemStr=$G(^DHCVISPlanItem(planItemDR))
	...q:planItemStr=""
	...s fileName=$P(planItemStr,"^",2)
	...s activeFlag=$P(planItemStr,"^",3)
	...q:activeFlag="N"
	...i retStr3="" s retStr3=URL_fileName
	...e  s retStr3=retStr3_"!"_URL_fileName
	i retStr1'="" s retStr=retStr1
	i (retStr2'="")&&(retStr'="") s retStr=retStr_"!"_retStr2
	e  i retStr2'="" s retStr=retStr2
	i (retStr3'="")&&(retStr'="") s retStr=retStr_"!"_retStr3
	e  i retStr3'="" s retStr=retStr3
	q retStr
}

ClassMethod GetShowInfo(clientIP As %String) As %String
{
	s retStr=""
	i $G(clientIP)="" s clientIP=$ZUTIL(67,15,$JOB)
    s clientId=$O(^DHCVISClienti(0,"ClientIP",clientIP,""))
	i clientId="" d
	.s roomDesc=""
	.s locDesc=""
	.s docDesc=""
	.s markDesc=""
	.s notice=""
	e  d
	.s roomDesc=$P($G(^DHCVISClient(clientId)),"^",3)
	.s docDR=$P($G(^DHCVISClient(clientId)),"^",10)
	.i docDR="" d
	..s docDesc=""
	..s markDesc=""
	.e  d
	..s docDesc=$P($G(^SSU("SSUSR",docDR)),"^",2)
	..s markDesc="副教授"
	.s locDR=$P($G(^DHCVISClient(clientId)),"^",11)
	.i locDR="" s locDesc=""
	.e  s locDesc=$P($G(^CTLOC(locDR)),"^",2)
	.i $P(locDesc,"-",2)'="" s locDesc=$P(locDesc,"-",2)
	.s notice=$P($G(^DHCVISClient(clientId)),"^",12)
	.i notice="" s notice="抽烟有害身体健康"
	s retStr=locDesc_"!"_roomDesc_"!"_docDesc_"!"_markDesc_"!"_notice
	q retStr
}

Query LookUpPlan() As %Query(ROWSPEC = "PlanDR:%String,PlanName:%String,SysFlag:%String,ServerDR:%String,ServerName:%String,ClientDR:%String,ClientName:%String,URL:%String,Note:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod LookUpPlanExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s PlanDR=""
	f  s PlanDR=$O(^DHCVISPlan(PlanDR)) q:PlanDR=""  d
	.s PlanStr=$G(^DHCVISPlan(PlanDR))
	.q:PlanStr=""
	.s PlanName=$P(PlanStr,"^",1)
	.s SysFlag=$P(PlanStr,"^",2)
	.s ServerDR=$P(PlanStr,"^",3)
	.i ServerDR="" s ServerName=""
	.e  s ServerName=$P($G(^DHCVISServer(ServerDR)),"^",2)
	.s ClientDR=$P(PlanStr,"^",4)
	.i ClientDR'="" s ClientName=$P($G(^DHCVISClient(ClientDR)),"^",3)
	.e  s ClientName=""
	.s URL=$P(PlanStr,"^",5)
	.s Note=$P(PlanStr,"^",6)
	.s UpdateUserDR=$P(PlanStr,"^",7)
	.i UpdateUserDR="" s UpdateUser=""
	.e  s UpdateUser=$P($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
	.s UpdateDate=$P(PlanStr,"^",8)
	.i UpdateDate'="" s UpdateDate=$ZD(UpdateDate,3)
	.s UpdateTime=$P(PlanStr,"^",9)
	.i UpdateTime'="" s UpdateTime=$ZT(UpdateTime)
	.d OutPlanRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPlanRow
	s Data=$lb(PlanDR,PlanName,SysFlag,ServerDR,ServerName,ClientDR,ClientName,URL,Note,UpdateUser,UpdateDate,UpdateTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPlanExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPlanExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod PlanInsert(PlanName As %String, SysFlag As %String, ServerDR As %String = "", ClientDR As %String = "", URL As %String = "", Note As %String = "", UserId As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	q:(PlanName="")!(SysFlag="") "信息不完整!"
	&SQL(insert into DHC_VIS_PlayPlan(PlanName,SysFlag,ServerDR,ClientDR,URL,Note,UpdateUser,UpdateDate,UpdateTime) 
	values (:PlanName,:SysFlag,:ServerDR,:ClientDR,:URL,:Note,:UserId,:NowDate,:NowTime))
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod PlanUpdate(PlanDR As %String, PlanName As %String, SysFlag As %String, ServerDR As %String = "", ClientDR As %String = "", URL As %String = "", Note As %String = "", UserId As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	q:(PlanDR="")!(PlanName="")!(SysFlag="") "信息不完整!"
	&SQL(update DHC_VIS_PlayPlan set PlanName=:PlanName,SysFlag=:SysFlag,ServerDR=:ServerDR,ClientDR=:ClientDR,URL=:URL,Note=:Note,UpdateUser=:UserId,UpdateDate=:NowDate,UpdateTime=:NowTime where ID=:PlanDR)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod PlanDelete(PlanDR As %String) As %String
{
	q:(PlanDR="") "信息不完整!"
	&SQL(Delete from DHC_VIS_PlayPlan where ID=:PlanDR)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

Query LookUpPlanItem(txtPlanDR As %String = "") As %Query(ROWSPEC = "PlanDR:%String,PlanName:%String,PlanItemDR:%String,FileName:%String,ActiveFlag:%String,SeqNo:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod LookUpPlanItemExecute(ByRef qHandle As %Binary, txtPlanDR As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s PlanDR=txtPlanDR
 	i PlanDR'="" d
 	.s SeqNo=""
 	.f  s SeqNo=$O(^DHCVISPlanItemi(0,"PlanSeqNo",PlanDR,SeqNo)) q:SeqNo=""  d
 	..s PlanItemDR=""
 	..f  s PlanItemDR=$O(^DHCVISPlanItemi(0,"PlanSeqNo",PlanDR,SeqNo,PlanItemDR)) q:PlanItemDR=""  d
 	...s PlanItemStr=$G(^DHCVISPlanItem(PlanItemDR))
 	...q:PlanItemStr=""
 	...s PlanName=$P($G(^DHCVISPlan(PlanDR)),"^",1)
 	...s FileName=$P(PlanItemStr,"^",2)
 	...s ActiveFlag=$P(PlanItemStr,"^",3)
 	...s SeqNo=$P(PlanItemStr,"^",4)
 	...s UpdateUserDR=$P(PlanItemStr,"^",5)
 	...i UpdateUserDR'="" s UpdateUser=$P($G(^SSU("SSUSR",UpdateUserDR)),"^",2) 
 	...e  s UpdateUser=""
 	...s UpdateDate=$P(PlanItemStr,"^",6)
 	...i UpdateDate'="" s UpdateDate=$ZD(UpdateDate,3)
 	...s UpdateTime=$P(PlanItemStr,"^",7)
 	...i UpdateTime'="" s UpdateTime=$ZT(UpdateTime)
 	...d OutPlanItemRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPlanItemRow
	s Data=$lb(PlanDR,PlanName,PlanItemDR,FileName,ActiveFlag,SeqNo,UpdateUser,UpdateDate,UpdateTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpPlanItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPlanItemExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpPlanItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPlanItemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod PlanItemInsert(PlanDR As %String, FileName As %String, ActiveFlag As %String, SeqNo As %String, UserId As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	q:(PlanDR="")!(FileName="")!(ActiveFlag="")!(SeqNo="") "信息不完整!"
	&SQL(insert into DHC_VIS_PlayPlanItem(PlanDR,FileName,ActiveFlag,SeqNo,UpdateUser,UpdateDate,UpdateTime) 
	values (:PlanDR,:FileName,:ActiveFlag,:SeqNo,:UserId,:NowDate,:NowTime))
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod PlanItemUpdate(PlanItemDR As %String, PlanDR As %String, FileName As %String, ActiveFlag As %String, SeqNo As %String, UserId As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	q:(PlanItemDR="")!(PlanDR="")!(FileName="")!(ActiveFlag="")!(SeqNo="") "信息不完整!"
	&SQL(update DHC_VIS_PlayPlanItem set PlanDR=:PlanDR,FileName=:FileName,ActiveFlag=:ActiveFlag,SeqNo=:SeqNo,UpdateUser=:UserId,UpdateDate=:NowDate,UpdateTime=:NowTime where ID=:PlanItemDR)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod PlanItemDelete(PlanItemDR As %String) As %String
{
	q:(PlanItemDR="") "信息不完整!"
	&SQL(Delete from DHC_VIS_PlayPlanItem where ID=:PlanItemDR)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

}
