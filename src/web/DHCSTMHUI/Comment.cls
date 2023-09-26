Import sqluser

/// Descript:点评高值
/// Creater: wxj
/// CreateDate: 2019-10-25
Class web.DHCSTMHUI.Comment Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMCOMMENT";

/// Descript:   查询点评单
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Comment","Query",^tempxj("001"))
Query Query(Params As %String) As Query(ROWSPEC = "RowId,ComNo,Status,CreateDate,CreateTime,CreateUser,Conditions")
{
}

/// Descript:查询点评单
/// CreateDate: 2019-10-25
ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
    n (qHandle,Params)
    s ^tempxj("001")=Params
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:Params="" $$$OK
    s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
    d PJobj.%FromJSON(Params)
    s StartDate=PJobj.%Get("StartDate")
    s EndDate=PJobj.%Get("EndDate") 
    s FComNo=PJobj.%Get("FComNo")
    s FResult=PJobj.%Get("FResult")
    s FStatus=PJobj.%Get("FStatus")
    q:StartDate="" $$$OK
    q:EndDate="" $$$OK
    s StartDate=..DH2L(StartDate)
    s EndDate=..DH2L(EndDate)
    s sqlStr = "select * from DHC_MatComments where MATCNT_CreateDate between "_StartDate_" and "_EndDate
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err  q $$$OK
    While(result.Next())
    {
        s RowId = result.Data("ID")
        s Status=##class(web.DHCSTMHUI.CommentCommon).GetMainStatus(RowId)
        continue:(FStatus'="")&&(Status'=FStatus)
        s Result=##class(web.DHCSTMHUI.CommentCommon).ChkComResult(RowId,FResult)
        continue:Result'=1
        s ComNo = result.Data("MATCNT_No")
        s CreateDate = result.Data("MATCNT_CreateDate")
        s:CreateDate'="" CreateDate=..DL2H(CreateDate)
        s CreateTime=result.Data("MATCNT_CreateTime")
        s:CreateTime'="" CreateTime=..TL2H(CreateTime)
        s CreateUserId = result.Data("MATCNT_CreateUser")
        s CreateUser=""
        s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
        s Conditions=result.Data("MATCNT_Conditions")
        d OutPutRow
    }
	Quit $$$OK

OutPutRow
	s Data=$lb(RowId,ComNo,Status,CreateDate,CreateTime,CreateUser,Conditions)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:根据点评单ID获取点评明细信息
/// CreateDate: 2019-10-25
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Comment","QueryDetail","{""Parref"":""1"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}","")
Query QueryDetail(Parref As %String, RetStatus As %String = "") As Query(ROWSPEC = "RowId,ComNo,CurRet,ORIRowId,Barcode,Inci,InciCode,InciDesc,Spec,Oeori,OeoriDate,OeoriTime,OeoriDoctor,Arcim,OeoriLoc,OeoriRecLoc,OeoriNum:%Float,OeoriUom,Adm")
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String, RetStatus As %String = "") As %Status
{
	n (qHandle,Parref,RetStatus)
	;s ^tempxj("002")=$lb(Params,RetStatus)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT * FROM DHC_MatCommentsItm WHERE MATCNTI_ParRef= "_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
        s RowId = result.Data("ID")
        s CurRet =##class(web.DHCSTMHUI.CommentCommon).GetDeatilStatus(RowId)
        continue:(RetStatus'="")&&(CurRet'=RetStatus)
        s ComNo=$lg(^User.DHCMatCommentsD(Parref),2)
        s ORIRowId = result.Data("MATCNTI_HvOrdItm_DR")
        s Barcode=$p(^DHCHVMORI(ORIRowId,1),"^",24)	//高值条码
        s Inci=$p(^DHCHVMORI(ORIRowId,1),"^",34)
        s InciCode=$p(^INCI(Inci,1),"^",1) ;物资代码
		s InciDesc=$p(^INCI(Inci,1),"^",2) ;物资名称
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
        s Oeori=$p(^DHCHVMORI(ORIRowId,1),"^",1)
        s (OeoriDate,OeoriTime,OeoriDoctor,Arcim,OeoriUom,OeoriLoc,OeoriRecLoc)=""
		s OeoriDate=$p(^DHCHVMORI(ORIRowId,1),"^",2)	//医嘱日期
		s:OeoriDate'="" OeoriDate=..DL2H(OeoriDate)
		s OeoriTime=$p(^DHCHVMORI(ORIRowId,1),"^",3)	//医嘱时间
		s:OeoriTime'="" OeoriTime=..TL2H(OeoriTime)
		s OeoriUseradd=$p(^DHCHVMORI(ORIRowId,1),"^",4)	//开单医生		
		s:OeoriUseradd'="" OeoriDoctor=$p($g(^SSU("SSUSR",OeoriUseradd)),"^",2 )
		s ArcimId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2) ;医嘱项rowid	
		s Arcim=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s OeoriLocId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",3)	//医嘱开单科室
		s:OeoriLocId'="" OeoriLoc=$p(^CTLOC(OeoriLocId),"^",2)
        s OeoriRecLocId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6) //医嘱接收科室
        s:OeoriRecLocId'="" OeoriRecLoc=$p(^CTLOC(OeoriRecLocId),"^",2)
		s OeoriNum=$p(^DHCHVMORI(ORIRowId,1),"^",19)	//数量
		s OeoriUomId=$p(^DHCHVMORI(ORIRowId,1),"^",18)	//单位
		s:OeoriUomId'="" OeoriUom=$P(^CT("UOM",OeoriUomId),"^",2)	//单位
		s OeoriRp =$p(^DHCHVMORI(ORIRowId,1),"^",20)
		s OeoriSp =$p(^DHCHVMORI(ORIRowId,1),"^",21)
		s Adm=$p(^OEORD(+Oeori),"^",1)
        d OutPutRowDetail
    }
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(RowId,ComNo,CurRet,ORIRowId,Barcode,Inci,InciCode,InciDesc,Spec,Oeori,OeoriDate,OeoriTime,OeoriDoctor,Arcim,OeoriLoc,OeoriRecLoc,OeoriNum,OeoriUom,Adm)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   提交点评单
/// w ##class(web.DHCSTMHUI.Comment).Submit()
ClassMethod Submit(ComId) As RtnObj
{
    n (ComId)
    s RtnObj=##class(RtnObj).%New()
    i ((ComId="")||('$d(^User.DHCMatCommentsD(ComId))))  d RtnObj.Err(-1,"","提交失败,点评单不存在")
 	q:RtnObj.success'=0 RtnObj
    s comStatus=##class(web.DHCSTMHUI.CommentCommon).GetMainStatus(ComId)
	i comStatus=3  d RtnObj.Err(-2,"","该点评单已提交,无需重复提交！","",0)
	q:RtnObj.success'=0 RtnObj
	i comStatus'=2  d RtnObj.Err(-3,"","该点评单未全部点评完成,不能提交","",0)
	q:RtnObj.success'=0 RtnObj
	s submitflag="Y"
	&sql(update DHC_MatComments set MATCNT_SubmFlag=:submitflag where %ID=:ComId)
	i SQLCODE'=0 d RtnObj.Err(-4,"","处理单据失败!")
    q RtnObj
}

/// w ##class(web.DHCSTMHUI.Comment).SaveLogItm("20||3","{""Result"":""Y"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod SaveLogItm(DetailId As %String, Params As %String = "") As RtnObj
{
 n (DetailId,Params)
 ;s ^tempxj("SaveLogItm")=$lb(DetailId,Params)
 s RtnObj=##class(RtnObj).%New()
 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 s Sc=PJObj.%FromJSON(Params)
 i Sc'=0 s Sc=RtnObj.Err(-1,"","入参解析失败!")
 q:RtnObj.success'=0 RtnObj
 s ComUser=PJObj.%Get("gUserId")
 s ComLoc=PJObj.%Get("gLocId")
 s ComDate=+$h    //点评日期
 s ComTime=$p($h,",",2)  //点评时间 
 s Result=PJObj.%Get("Result")
 s Reason=PJObj.%Get("Reason")
 s Advice=PJObj.%Get("Advice")
 s Remark=PJObj.%Get("Remark")
 s MainId=$p(DetailId,"||",1)
 s MainStatus=##class(web.DHCSTMHUI.CommentCommon).GetMainStatus(MainId)
 s DetailStatus=##class(web.DHCSTMHUI.CommentCommon).GetDeatilStatus(DetailId)
 ;点评单已提交且点评明细未申诉，不允许修改点评结果
 i (MainStatus=3)&&(DetailStatus'=2) s Sc=RtnObj.Err(-2,"","已提交的点评单不允许修改点评结果","",0)
 q:RtnObj.success'=0 RtnObj
 s OriLoc=$LG(^User.DHCMatCommentsD(+DetailId,"ChildDHCMatCommentsItm",$p(DetailId,"||",2)),5)
 s LocUserRet=##class(web.DHCSTMHUI.CommentLocUser).IfAllowDo(OriLoc,ComLoc,ComUser)
 i (LocUserRet'=0) s Sc=RtnObj.Err(-3,"","当前登录人没有点评权限，需先在点评人员权限界面维护后才可点评","",0)
 q:RtnObj.success'=0 RtnObj
 ts
 &sql(update DHC_MatCommentsItm set MATCNTI_CurrRet=:Result where %ID=:DetailId)
 i SQLCODE'=0  s Sc=RtnObj.Err(-4,"","更新点评子表失败")
 i RtnObj.success'=0 {
	 tro
	 q RtnObj
 }
 i DetailStatus=2 {
 	s AuditDate=+$h
 	s AuditTime=$p($h,",",2)
 	s recheckid="",ActiveFlag=""
 	f  {
	 	s recheckid=$o(^User.DHCMatCNTOrdReCheckI("DHCSTMCRCIndex",DetailId,recheckid)) 
	 	q:recheckid=""
	 	s ActiveFlag=$lg(^User.DHCMatCNTOrdReCheckD(recheckid),12)
	 	q:ActiveFlag="Y"
 	}
 	i +recheckid>0 {
 		&sql(update DHC_MatCNT_OrdReCheck set MCNTOR_Result=:Result,MCNTOR_User=:ComUser, MCNTOR_Loc=:ComLoc, MCNTOR_Date=:AuditDate,MCNTOR_Time=:AuditTime,MCNTOR_ActiveFlag='N' where %ID=:recheckid)
 		i SQLCODE'=0  s Sc=RtnObj.Err(-5,"","更新医嘱复核信息失败")
 	}
 }
 i RtnObj.success'=0 {
	 tro
	 q RtnObj
 }
 s Obj=##class(User.DHCMatCommentsLog).%New(DetailId)
 d Obj.MATCNTLParRefSetObjectId(DetailId)
 s Obj.MATCNTLCommentDate=ComDate
 s Obj.MATCNTLCommentTime=ComTime
 d Obj.MATCNTLCommentUserSetObjectId(ComUser)
 s Obj.MATCNTLResult=Result
 s Obj.MATCNTLReasonDR=Reason
 s Obj.MATCNTLAdviceDR=Advice
 s Obj.MATCNTLRemark=Remark
 s Sc=Obj.%Save()
 i $$$ISERR(Sc) d RtnObj.Err(-6,"","更新点评日志失败!")
 i RtnObj.success'=0 {
	 tro
	 q RtnObj
 }
 s RowId=Obj.%Id()
 tc
 s RtnObj.rowid=MainId
 q RtnObj
}

/// w ##class(web.DHCSTMHUI.Comment).GetPaInfo(781)
/// //取病人的相关信息
ClassMethod GetPaInfo(adm As %String) As %String
{
	 n (adm)
	 ;s ^tempxj("GetPaInfo")=adm
	 q:adm="" ""
	 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
	 s paadmtype=$p($g(^PAADM(adm)),"^",2)
	 s patNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
	 s patName=$p($g(^PAPER(papmidr,"ALL")),"^",1)	;姓名
	 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
	 s admloc=""
	 s sexDesc=$s(+sexdr'=0:$p($g(^CT("SEX",+sexdr)),"^",2),1:"")	;性别
	 s patAge=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPapmiAge(papmidr,adm)	;年龄
	 s ward=$p($g(^PAADM(adm)),"^",70)	
	 s bed=$p($g(^PAADM(adm)),"^",73)	
	 s wardcode="",warddesc="",bedno=""
	 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2) ;病区
	 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1) ;床号
	 s depcode=$p($g(^PAADM(adm)),"^",4)	
	 i depcode'="" s depdesc=$p(^CTLOC(depcode),"^",2) 	;就诊科室
	 s Medicare=$p(^PAPER(papmidr,"PAT",1),"^",22)  ;住院号
	 s diag=..MrDiagnose(adm,",","GX") 		//诊断
     s Data=papmidr_"^"_ patNo_"^"_adm_"^"_patName_"^"_sexDesc_"^"_patAge_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_depcode_"^"_depdesc_"^"_Medicare_"^"_diag_"^"_paadmtype
     s Title="papmidr^patNo^adm^patName^sexDesc^patAge^wardcode^warddesc^bedno^depcode^depdesc^Medicare^diag^paadmtype"
     s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
     q Rtn
}

/// description: 诊断
/// w ##class(PHA.COM.Order).MrDiagnose("2082",",")
ClassMethod MrDiagnose(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	n (MRAdmRowid,DelimStr,Type)
	q:MRAdmRowid="" ""
	s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
	q:MRAdmRowid="" ""
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.i CodeRowid'=""  d
	..s ZXFlag=$p($g(^MRC("ID",+CodeRowid)),"^",13) 	;证型标志
	..s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) 	;中医诊断标志
	..i ZYZDFlag'="Y" d
	...s DiagnosCat="西医"
	..e  i (ZYZDFlag="Y")&&(ZXFlag'="Y") d
	...s DiagnosCat="中医"
	..e  d
	...s DiagnosCat="证型"
	.e  d
	..//非ICD诊断
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..s DiagnosCat=$s(Questionnaire=1:"西医",Questionnaire=2:"中医",Questionnaire=3:"证型",1:"")
	.i DiagnosCat="" s DiagnosCat="西医"
	.q:(Type="GC")&&(DiagnosCat="西医")  				;中医诊断
	.q:(Type="GX")&&(DiagnosCat'="西医")  				;西医诊断
	.q:(Type="ZX")&&(DiagnosCat'="证型")  				;证型  
	.i MRDesc'="" d
	..s MRDesc=$LIST(MRDesc,1)
	.i Desc="" d
	..s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.i DiagnosCat'="证型"  d
	..s i=i+1
	..s Desc=i_"."_Desc
	.i retval="" d
	..s retval=Desc
	.e  d
	..s retval=$s(DiagnosCat="证型":retval_" "_Desc,1:retval_DelimStr_Desc)
	.
	d obj.Close()
	q retval
}

}
