Class web.DHCHM.QuestionDetailSet Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionDetailSet","FindQDetail","","姓","","","","","")
Query FindQDetail(Code, Desc, Type, Sex, LinkCode, Required, Active) As %Query(ROWSPEC = "QDID:%String:QDID,QDActive:%String:QDActive,QDCode:%String:QDCode,QDDesc:%String:QDDesc,QDElementNum:%String:QDElementNum,QDLinkCode:%String:QDLinkCode,QDNote:%String:QDNote,QDRemark:%String:QDRemark,QDRequired:%String:QDRequired,QDSex:%String:QDSex,QDType:%String:QDType,QDUnit:%String:QDUnit")
{
}

ClassMethod FindQDetailExecute(ByRef qHandle As %Binary, Code, Desc, Type, Sex, LinkCode, Required, Active) As %Status
{
	s ^tmpwgy("FindQDetail")=$lb(Code, Desc, Type, Sex, LinkCode, Required, Active)
 	new repid,index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if Code'=""
	{
	s Code=$zcvt(Code,"u")
	s Code=" "_Code
	s tcode=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex",Code),-1)
	f  s tcode=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex",tcode)) q:(tcode="")||(tcode'[Code)  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex",tcode,ID))  quit:ID=""  d
	..d BuildDataFindQDetail
	}
	/*
	elseif Desc'=""
	{
	s Desc=" "_Desc
	s tdesc=$o(^User.DHCHMCQuestionsDetailI("QDDescIndex",Desc),-1)
	f  s tdesc=$o(^User.DHCHMCQuestionsDetailI("QDDescIndex",tdesc)) q:(tdesc="")||(tdesc'[Desc)  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCQuestionsDetailI("QDDescIndex",tdesc,ID))  quit:ID=""  d
	..d BuildDataFindQDetail
	}*/
	else
	{
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionsDetailD(ID)) quit:ID=""  d
	.d BuildDataFindQDetail
	}
	Quit $$$OK
BuildDataFindQDetail
	d ResetVariablesFindQDetail
	s obj=##class(User.DHCHMCQuestionsDetail).%OpenId(ID)
	s QDActive = obj.QDActive
	i QDActive = "Y" s QDActive = "true"
	e  s QDActive = "false" 
	s QDCode = obj.QDCode
	s QDDesc = obj.QDDesc
	q:(Desc'="")&&(QDDesc'[Desc)
	s QDElementNum = obj.QDElementNum
	s QDLinkCode = obj.QDLinkCode
	s QDNote = obj.QDNote
	s QDRemark = obj.QDRemark
	s QDRequired = obj.QDRequired
	i QDRequired = "Y" s QDRequired = "true"
	e  s QDRequired = "false" 
	q:(Active'="")&&(QDActive'=Active)
	s QDSex = obj.QDSex
	s QDType = obj.QDType
	s QDUnit = obj.QDUnit
	d OutputRowFindQDetail
	quit
OutputRowFindQDetail
	s Data=$lb(ID,QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQDetail
	s (QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit)=""
	quit
}

ClassMethod FindQDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionDetailSet","FindQDOption",1,"Y")
Query FindQDOption(ParRef, Active = "") As %Query(ROWSPEC = "QDOID:%String:QDOID,QDOActive:%String:QDOActive,QDOClass:%String:QDOClass,QDODefault:%String:QDODefault,QDODesc:%String:QDODesc,QDONote:%String:QDONote,QDOOrder:%String:QDOOrder,QDOSex:%String:QDOSex,QDOCode:%String:QDOCode")
{
}

ClassMethod FindQDOptionExecute(ByRef qHandle As %Binary, ParRef, Active = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Sub=0
	f  s Sub=$o(^User.DHCHMCQuestionsDetailD(ParRef,"QDOptions",Sub))  quit:Sub=""  d
	.s ID=ParRef_"||"_Sub
	.d BuildDataFindQDOption
	Quit $$$OK
BuildDataFindQDOption
	d ResetVariablesFindQDOption
	s obj=##class(User.DHCHMCQDOptions).%OpenId(ID)
	s QDOActive = obj.QDOActive
	q:(Active'="")&&(QDOActive'=Active)
	i QDOActive = "Y" s QDOActive = "true"
	e  s QDOActive = "false"
	s QDOClass = obj.QDOClass
	s QDODefault = obj.QDODefault
	i QDODefault = "Y" s QDODefault = "true"
	e  s QDODefault = "false"
	s QDODesc = obj.QDODesc
	
	s QDONote = obj.QDONote
	i QDONote = "Y" s QDONote = "true"
	e  s QDONote = "false"
	s QDOOrder = obj.QDOOrder
	s QDOSex = obj.QDOSex
	s QDOCode = obj.QDOCode
	d OutputRowFindQDOption
	quit
OutputRowFindQDOption
	s Data=$lb(ID,QDOActive,QDOClass,QDODefault,QDODesc,QDONote,QDOOrder,QDOSex,QDOCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQDOption
	s (QDOActive,QDOClass,QDODefault,QDODesc,QDONote,QDOOrder,QDOSex,QDOCode)=""
	quit
}

ClassMethod FindQDOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQDOptionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQDOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQDOptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QDSave(id, value, property)
{
	set ret=##class(User.DHCHMCQuestionsDetail).SaveData(id,value,property)
	q ret
}

ClassMethod QDOSave(id, value, property, type, default, parref)
{
	S Desc=$P(value,"^",3)
	S QDODesc=""
	if id="" d
	.s obj=##class(User.DHCHMCQDOptions).%New()
	e  d
	.s obj=##class(User.DHCHMCQDOptions).%OpenId(id)
	.S QDODesc=obj.QDODesc
	//q:(QDODesc'=Desc)&&($d(^User.DHCHMCQDOptionsI("QDODescIndex"," "_Desc))) "-1^描述重复!"

	
	
	i (type="S")&&(default="Y") d
	.s order=""
	.f  s order=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",parref,order)) q:order=""  d
	..s sub=""
	..f  s sub=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",parref,order,sub)) q:sub=""  d
	...s qdoid=parref_"||"_sub
	...s obj=##class(User.DHCHMCQDOptions).%OpenId(qdoid)
	...s obj.QDODefault="N"
	...s sc=obj.%Save()
	...d obj.%Close()
	set ret=##class(User.DHCHMCQDOptions).SaveData(id,value,property)
	q ret
}

// d ##class(web.DHCHM.QuestionDetailSet).CopyOption("源COde","目标Code")

ClassMethod CopyOption(source, to)
{
	s source=$ZCVT(source,"U")
	s to=$ZCVT(to,"U")
	s sourceID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_source,0))
	w:sourceID="" source_"源不存在",!
	s toID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_to,0))
	w:toID="" to_"目标不存在",!
	//s obj=##class(User.DHCHMCQDOptions).GetObj(sourceID)
	s Flag=0
	s sub=0
	f  s sub=$O(^User.DHCHMCQuestionsDetailD(sourceID,sub)) q:(sub="")||(Flag<0)  d
	.s sourceOID=sourceID_"||"_sub
	.s obj=##class(User.DHCHMCQDOptions).GetObj(sourceOID)
	.s propertieStr="QDOParRef^QDODesc^QDOOrder^QDOClass^QDOSex^QDOActive^QDODefault^QDONote"
	.s valueStr=toID_"^"_obj.QDODesc_"^"_obj.QDOOrder_"^"_obj.QDOClass_"^"_obj.QDOSex_"^"_obj.QDOActive_"^"_obj.QDODefault_"^"_obj.QDONote
	.s rstr=##class(User.DHCHMCQDOptions).SaveData("",valueStr,propertieStr)
	.s Flag=+rstr
	w:Flag<0 to_"保存错误,错误号:"_SQLCODE
}

/*/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionDetailSet","QueryQDONOSInfo","1||1",4)
Query QueryQDLOrdSetsInfo(ParRef, OrdSetsDR) As %SQLQuery(ROWSPEC = "QDLSID:%String,OrdSetsDesc:%String,QDLSlevance:%String,QDONOSActive:%String")
{
 select ID,QDONOS_NetSetsDR,QDONOS_NetSetsDR->NOS_HisSetsID,QDONOS_NetSetsDR->NOS_Desc,QDONOS_Relevance,(CASE WHEN QDONOS_Active='Y' THEN 'true' ELSE 'false' END) AS QDONOS_Active 
 	from Sqluser.DHC_HM_CQDONetOrdSets 
 	where QDONOS_ParRef=:ParRef AND(:NetSetsDR IS NULL OR QDONOS_NetSetsDR=:NetSetsDR)
}*/
/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionDetailSet","QueryQDLOrdSetsInfo",2,4)
Query QueryQDLOrdSetsInfo(ParRef, OrdSetsDR) As %SQLQuery(ROWSPEC = "QDLSID:%String,QDLSSetsDR:%String,OrdSetsDesc:%String,QDLSlevance:%String,QDLSExpression:%String,QDLSNote:%String")
{
 select ID,QDLS_OrdSetsDR,QDLS_OrdSetsDR->ARCOS_Desc,QDLS_Relevance,QDLS_Expression,QDLS_Note
 	from Sqluser.DHC_HM_CQDLinkOrdSets
 	where QDLS_ParRef=:ParRef AND(:OrdSetsDR IS NULL OR QDLS_OrdSetsDR=:OrdSetsDR)
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionDetailSet","QueryQDOLSInfo",2)
Query QueryQDOLSInfo(ParRef, OrdSetsDR, Relevance, Active) As %SQLQuery(ROWSPEC = "QDOLSID:%String,QDOLSSetsDR:%String,OrdSetsDesc:%String,QDOLSlevance:%String,QDOLSActive:%String")
{
 select ID,QDOLS_OrdSetsDR,QDOLS_OrdSetsDR->ARCOS_Desc,QDOLS_Relevance,QDOLS_Active
 	from Sqluser.DHC_HM_CQDOLinkOrdSets
 	where QDOLS_ParRef=:ParRef AND(:OrdSetsDR IS NULL OR QDOLS_OrdSetsDR=:OrdSetsDR)
 	AND (:Relevance IS NULL OR QDOLS_Relevance=:Relevance)
 	AND (:Active IS NULL OR QDOLS_Active=:Active)
}

ClassMethod QDOLOSSave(id, value, property)
{
	s parRef=$P(value,"^",1)
	s QD=$P(parRef,"||",1)
	s QDO=$P(parRef,"||",2)
	s OrdSetsDR=$P(value,"^",2)
	q:$D(^User.DHCHMCQDOLinkOrdSetsI("OrdSetsDRIndex",QD,QDO,OrdSetsDR)) "-1^该套餐已存在"
	set ret=##class(User.DHCHMCQDOLinkOrdSets).SaveData(id,value,property)
	q ret
}

ClassMethod QDOLOSDelete(id, value, property)
{
	set ret=##class(User.DHCHMCQDOLinkOrdSets).Delete(id)
	q ret
}

ClassMethod QDNLSave(id, value, property)
{
	s ^wgy("QDNLSave")=$LB(id, value, property)
	s parRef=$P(value,"^",1)
	s OrdSetsDR=$P(value,"^",2)
	s Expression=$ZCVT(($P(value,"^",4)),"U")
	set ret=##class(User.DHCHMCQDLinkOrdSets).SaveData(id,value,property)
	q ret
}

ClassMethod QDLSDelete(id)
{
	set ret=##class(User.DHCHMCQDLinkOrdSets).Delete(id)
	q ret
}

/// w ##class(web.DHCHM.QuestionDetailSet).IsValidExpression("val>100","D")
ClassMethod IsValidExpression(Expression)
{
	q:Expression'["val" 0
	s Val="ABCD"
	s $ZT="ExpressionErr"
	s Ret=##class(web.DHCPE.PreCommon).CalcExpression(Val,Expression)
	b ;Ret
	q 1
ExpressionErr
	s $zt=""
	q 0
}

ClassMethod CheckQDCodeExist(Code, ID)
{
	q:Code="" 0
	i ID="" q $D(^User.DHCHMCQuestionsDetailI("QDCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code)))
	s CID=$O(^User.DHCHMCQuestionsDetailI("QDCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code),""))
	i (ID=CID)||(CID="") q 0
	e  q 1
}

ClassMethod CheckOLinkOrdSetsExist(OrdSetsDr, OptionId)
{
	q:(OrdSetsDr="")||(OptionId="") 0
	q $D(^User.DHCHMCQDOLinkOrdSetsI("OrdSetsDRIndex",$P(OptionId,"||",1),$P(OptionId,"||",1),OrdSetsDr))
}

}
