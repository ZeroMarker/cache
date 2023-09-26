Import sqluser

/// Descript:点评申诉处理
/// Creater: wxj
/// CreateDate: 2019-11-05
Class web.DHCSTMHUI.CommentComPlain Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:查询医嘱信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CommentComPlain","QueryOrdInfo","{""StartDate"":""2019-11-18"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""EndDate"":""2019-11-18"",""ComResultBox"":""3""}")
Query QueryOrdInfo(Params As %String) As Query(ROWSPEC = "ComitmId,OeoriUseradd,Arcim,OrdItmQty:%Float,Doctor,OeoriDate,OrdReCheckId,CurrRet")
{
}

ClassMethod QueryOrdInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^tempxj("001")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Result=PJObj.%Get("ComResultBox")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	q:StartDate="" ""
	q:EndDate="" ""
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
    s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT * FROM DHC_MatCommentsItm WHERE MATCNTI_ParRef->MATCNT_CreateDate Between '"_StartDate_"' and '"_EndDate_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
        s ComitmId = result.Data("ID")
        s Mainstatus=##class(web.DHCSTMHUI.CommentCommon).GetMainStatus(+ComitmId)
        continue:Mainstatus'=3 ;过滤未提交的点评单
        s CurrRet=##class(web.DHCSTMHUI.CommentCommon).GetDeatilStatus(ComitmId)
        continue:(Result'="")&&(CurrRet'=Result)
        s MainId=+ComitmId
        s ComNo=$lg(^User.DHCMatCommentsD(MainId),2)
        s ORIRowId=$LG(^User.DHCMatCommentsD(MainId,"ChildDHCMatCommentsItm",$p(ComitmId,"||",2)),2)
        s Oeori=$p($g(^DHCHVMORI(ORIRowId,1)),"^",1)
        continue:Oeori=""
		s OrdItmQty=$p(^DHCHVMORI(ORIRowId,1),"^",19)	//数量
		s (Doctor,Arcim,OeoriUom)=""
		s OeoriUseradd=$p(^DHCHVMORI(ORIRowId,1),"^",4)	//开单医生		
		s:OeoriUseradd'="" Doctor=$p($g(^SSU("SSUSR",OeoriUseradd)),"^",2 )
		s OeoriDate=$p(^DHCHVMORI(ORIRowId,1),"^",2)	//医嘱日期
		s:OeoriDate'="" OeoriDate=..DL2H(OeoriDate)
		s OeoriTime=$p(^DHCHVMORI(ORIRowId,1),"^",3)	//医嘱时间
		s ArcimId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2) ;医嘱项rowid
		s Arcim=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s OrdRecheckId=""
        d OutPutRowItm
    }
	Quit $$$OK

OutPutRowItm
	s Data=$lb(ComitmId,OeoriUseradd,Arcim,OrdItmQty,Doctor,OeoriDate,OrdReCheckId,CurrRet)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:根据点评单明细ID获取点评日志信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CommentComPlain","QueryLog","11||2")
Query QueryLog(DetailId As %String) As Query(ROWSPEC = "RowId,Arcim,ComDate,ComNo,ComTime,ComUser,ComReason,ComAdvice,ComResult,ComRemark")
{
}

ClassMethod QueryLogExecute(ByRef qHandle As %Binary, DetailId As %String) As %Status
{
	n (qHandle,DetailId)
	;s ^tempxj("002")=DetailId
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:DetailId="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT * FROM DHC_MatCommentsLog WHERE MATCNTL_ParRef= "_"'"_DetailId_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
        s RowId = result.Data("ID")
        s MainId=+RowId
        s ComNo=$lg(^User.DHCMatCommentsD(MainId),2)
        s ORIRowId=$LG(^User.DHCMatCommentsD(MainId,"ChildDHCMatCommentsItm",$p(DetailId,"||",2)),2)
        s Oeori=$p(^DHCHVMORI(ORIRowId,1),"^",1)
        s ArcimId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2) ;医嘱项rowid	
		s Arcim=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
        s ComDate = result.Data("MATCNTL_CommentDate")
        s:ComDate'="" ComDate=..DL2H(ComDate)
        s ComTime = result.Data("MATCNTL_CommentTime")
        s:ComTime'="" ComTime=..TL2H(ComTime)
        s ComUserId = result.Data("MATCNTL_CommentUser")
        s ComUser=""
        s:ComUserId'="" ComUser=$p(^SSU("SSUSR",ComUserId),"^",2)
        s ComResult = result.Data("MATCNTL_Result")
        s ComRemark = result.Data("MATCNTL_Remark")
        s ComReasonDR = result.Data("MATCNTL_Reason_DR")        
        s ComAdviceDR = result.Data("MATCNTL_Advice_DR")
        s ComReason=""
        i ComReasonDR'=""  d
        .s ReasonLen=$l(ComReasonDR,",")
		.f i=1:1:ReasonLen d
		..s ReasonId=$p(ComReasonDR,",",i)
		..s Reason=$LG(^User.DHCMatCNTReasonD(ReasonId),3)
		..i ComReason="" d
		...s ComReason=i_"."_Reason
		..e  d 
		...s ComReason=ComReason_i_"."_Reason
		s ComAdvice=""
		i ComAdviceDR'="" d
		.s AdviceLen=$l(ComAdviceDR,",")
		.f i=1:1:AdviceLen d
		..s AdviceId=$p(ComAdviceDR,",",i)
		..s Advice=$LG(^User.DHCMatCNTAdviceD(AdviceId),3)
		..i ComAdvice="" d
		...s ComAdvice=i_"."_Advice
		..e  d 
		...s ComAdvice=ComAdvice_i_"."_Advice
        d OutPutRowDetail
    }
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(RowId,Arcim,ComDate,ComNo,ComTime,ComUser,ComReason,ComAdvice,ComResult,ComRemark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存医嘱复核信息
/// w ##class(web.DHCSTMHUI.CommentComPlain).Save()
ClassMethod jsSave(Params, DocNote) As %Library.String
{
    n (Params,DocNote)
    ;s ^tempxj("jsSave")=$lb(Params,DocNote)
    s RtnObj=##class(RtnObj).%New()
    ts
    s RtnObj=..Save(Params, DocNote)
    i RtnObj.success'=0 tro  q RtnObj.Json()
    tc
    q RtnObj.Json()
}

/// Descript:插入医嘱复核表记录
/// w ##class(web.DHCSTMHUI.CommentComPlain).Save(^tempxj("p"))
ClassMethod Save(Params, DocNote) As RtnObj
{
    n (Params,DocNote)
    ;s ^tempxj("p")=$lb(Params,DocNote)
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.d RtnObj.Err(-1,"","Save入参解析失败!")
	q:RtnObj.success<0 RtnObj
	s RowId=PJObj.%Get("OrdReCheckId")	;医嘱复核表ID
	s ComitmId=PJObj.%Get("ComitmId")		//点评明细RowId
	s ORResult=PJObj.%Get("ORResult")
	s User=PJObj.%Get("gUserId")
	s Loc=PJObj.%Get("gLocId")
	s Date=+$h
	s Time=$p($h,",",2)	
	i RowId="" d
	.s obj=##class(User.DHCMatCNTOrdReCheck).%New()
	.d obj.MCNTORComitmDRSetObjectId(ComitmId)
	.s obj.MCNTORActiveFlag="Y"
	e  d
	.s obj=##class(User.DHCMatCNTOrdReCheck).%OpenId(RowId)
	d obj.MCNTORDocDRSetObjectId(User)
	s obj.MCNTORDocNote=DocNote
	s obj.MCNTORDocDate=Date
	s obj.MCNTORDocTime=Time
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
	.d RtnObj.Err(-1,"","医嘱复核表保存失败:"_sc)
	q:RtnObj.success<0 RtnObj
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

}
