Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-06-20
/// Descript: 用药建议
Class web.DHCSTPHCMMedicineSuggest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存建议信息
ClassMethod SaveMedSuggInfo(dataList As %String) As %String
{
	 N (dataList)
	 S AdmDr=$p(dataList,"#",1)
	 S UserID=$p(dataList,"#",2)
	 S OrdList=$p(dataList,"#",3)
	 S SuggestInfo=$p(dataList,"#",4)
	 S OpDate=+$H
	 S OpTime=$P($H,",",2)
	 S EndDate=+$H+15   //有效期15天
	 S EndTime=$P($H,",",2)
	 TS
	 S PhmsDr=..InsertPHMediSug(AdmDr,UserID,OpDate,OpTime,EndDate,EndTime,OrdList)
	 I PhmsDr<=0 Tro
	 Q:+PhmsDr<=0 PhmsDr
	 S retVal=..InsertPHMediSugItm(PhmsDr,"P",SuggestInfo)
	 I retVal'=0 Tro
	 Q:retVal'=0 "-2"
	 TC
	 Q "0"
}

/// Descript:获取病人用药建议信息
ClassMethod GetPatMedSuggInfo(AdmDr As %String) As %String
{
	 N (AdmDr)
	 Q ""
}

/// w ##class(web.DHCSTPHCMMedicineSuggest).InsertPHMediSug(1,3,63447,85654,63447,85654,"63447||1^63447||2")
ClassMethod InsertPHMediSug(AdmDr, UserID, Date, Time, EndDate, EndTime, OrdList) As %String
{
	N (AdmDr,UserID,Date,Time,EndDate,EndTime,OrdList)
	&SQL(Insert Into DHCPH_MediSuggest(PHMS_User_Dr,PHMS_Adm_Dr,PHMS_Date,PHMS_Time,PHMS_EndDate,
		PHMS_EndTime,PHMS_OrdList) Values(:UserID,:AdmDr,:Date,:Time,:EndDate,:EndTime,:OrdList))
	Q:SQLCODE'=0 "-1"
	Q $p($g(%ROWID),$c(1))
}

/// w ##class(web.DHCSTPHCMMedicineSuggest).InsertPHMediSugItm(3,3,63447)
ClassMethod InsertPHMediSugItm(Parref, IdentityMark, Suggestion) As %String
{
	N (Parref,IdentityMark,Suggestion)
	S Chl=1+$o(^DHCPHMSI(Parref,"I",""),-1)
	&SQL(Insert Into DHCPH_MediSugItm(PHMSI_PHMS_ParRef,PHMSI_ChildSub,PHMSI_IdentityMark,PHMSI_Suggestion) 
		Values(:Parref,:Chl,:IdentityMark,:Suggestion))
	Q SQLCODE
}

/// Descript:获取病人建议信息
/// w ##class(web.DHCSTPHCMMedicineSuggest).GetPatSugguestInfo("15226878")
ClassMethod GetPatSugguestInfo(AdmDr As %String) As %String
{
	N (AdmDr)
	S TmpPatSugStr=""
	S ID=""
	F  S ID=$o(^DHCPHMS(0,"ADM",AdmDr,ID)) Q:ID=""  D
	.S User=$p(^DHCPHMS(ID),"^",1)
	.S:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.S opDate=$p(^DHCPHMS(ID),"^",3)
	.S opTime=$p(^DHCPHMS(ID),"^",4)
	.S EndDate=$p(^DHCPHMS(ID),"^",5)
	.S:opDate'="" opDate=$zd(opDate,3)
	.S:opTime'="" opTime=$zt(opTime,2)
	.S:EndDate'="" EndDate=$zd(EndDate,3)
	.S OrdIDStr=$p(^DHCPHMS(ID),"^",8) //建议医嘱串
	.S OrdStr=..getOrdInfo(OrdIDStr)
	.S PatSugStr="有效期:"_opDate_" "_opTime_" 至 "_EndDate_" "_opTime_"^"_"   已接受"
	.S PatSugStr=PatSugStr_"^"_OrdStr
	.S ch=$o(^DHCPHMSI(ID,"I","")) 
	.Q:ch=""
	.S IdentityMark=$p(^DHCPHMSI(ID,"I",ch),"^",1) //身份标示
	.S Suggestion=$p(^DHCPHMSI(ID,"I",ch),"^",2) //建议信息
	.S SignInfo=User_" "_opDate_" "_opTime
	.S PatSugStr=PatSugStr_"^"_Suggestion_"^"_"药师 "_SignInfo
	.If TmpPatSugStr="" S TmpPatSugStr=PatSugStr
	.E  S TmpPatSugStr=TmpPatSugStr_"#"_PatSugStr
	Q TmpPatSugStr
}

/// Descript:获取医嘱信息
ClassMethod getOrdInfo(OrdStr As %String) As %String
{
	N (OrdStr)
	S OrdInfoStr=""
	S Len=$L(OrdStr,",")
	F i=1:1:Len d
	.S orditm=$p(OrdStr,",",i)
	.S retStr=..getOeoriInfo(orditm)
	.If OrdInfoStr="" S OrdInfoStr=retStr
	.E  S OrdInfoStr=OrdInfoStr_"&"_retStr
	Q OrdInfoStr
}

/// Descript:获取医嘱信息
ClassMethod getOeoriInfo(oeori As %String) As %String
{
	N (oeori)
	S ord=+oeori
	S chl=$p(oeori,"||",2)
	S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    Q:priDr=0 
    S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    Q:priorty["OM" //自备药
    S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
	S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	Q:inci=""  //医嘱名称
	S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	S dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) //剂量
	S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	S duration=$p($g(^PHCDU(durId)),"^",1) //用药疗程
	S StartDate="2014-04-02"
	Q StartDate_" "_priorty_" "_inciDesc_" "_dosage_" "_instru_" "_duration_" "_freq
}

Storage Default
{
<Data name="DHCSTPHCMMedicineSuggestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPHCMMedicineSuggestD</DataLocation>
<DefaultData>DHCSTPHCMMedicineSuggestDefaultData</DefaultData>
<IdLocation>^web.DHCSTPHCMMedicineSuggestD</IdLocation>
<IndexLocation>^web.DHCSTPHCMMedicineSuggestI</IndexLocation>
<StreamLocation>^web.DHCSTPHCMMedicineSuggestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
