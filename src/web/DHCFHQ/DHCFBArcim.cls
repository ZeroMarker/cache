Class web.DHCFHQ.DHCFBArcim Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetArcimPrice(arcimdr, pattype)
{
 S del="^",ErrFlag="False"
 if $g(pattype)="" s pattype=""
 s taridr="",tarprice=0,ordprice=0
 if pattype="" s pattype=$o(^PAC("ADMREA",0))
 f  s taridr=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr)) q:taridr=""  d
 .s startdate=""
 .f  s startdate=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr,startdate)) q:startdate=""  d
 ..q:startdate>+$h
 ..s oltrid=""
 ..f  s oltrid=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr,startdate,oltrid)) q:oltrid=""  d
 ...s enddate=$p(^DHCOLT(oltrid),del,5)
 ...q:((enddate'="") & (enddate<+$h))
 ...S qty=$p(^DHCOLT(oltrid),del,3)
 ...if $g(qty)="" s qty=1
 ...s tarprice=##class(web.DHCFHQ.DHCFBTARI).GetTarPrice(taridr,pattype)
 ...q:$p(tarprice,del,1)=ErrFlag
 ...s tarprice=$p(tarprice,del,1) * qty
 ...s ordprice=ordprice+tarprice
 q $fn(ordprice,"",2)
}

ClassMethod GetArcimByAlia(repid As %Integer, ArcAlia As %String) As %Integer
{
	S RetNum=1
	s del="^"
 S ArcAlia=$$ALPHAUP^SSUTIL4(ArcAlia),aliaval=ArcAlia
 s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" "),-1)
 f  s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" ")) q:(ArcAlia="")!(ArcAlia'[aliaval)  d
 .S desc=""
 .f  s desc=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc)) q:desc=""  d
 ..s aliaid=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc,""))
 ..s ArcId=$p(^ARC("ALIAS",aliaid),del,1)
 ..Q:($g(ArcId)="")
 ..s ArcId1=$p(ArcId,"||",1),ArcId2=$p(ArcId,"||",2)
 ..q:'$d(^ARCIM(ArcId1,ArcId2))
 ..s ArcInfo=##class(web.DHCFBArcimGet).GetArcimById(ArcId)
 ..q:ArcInfo=""
	 ..s ArcCode=$p(ArcInfo,del,2)
	 ..s ArcDesc=$p(ArcInfo,del,3)
	 ..s SubCat=$p(ArcInfo,del,4)
	 ..s drug=$p(ArcInfo,del,5)
	 ..s startdate=$p(ArcInfo,del,6)
	 ..s enddate=$p(ArcInfo,del,7)
	 ..s Priority=$p(ArcInfo,del,8)
 ..s drug=$p(^ARCIM(ArcId1,ArcId2,1),del,12)
 ..i $g(drug)'="" d
 ...s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
 ..q:(($g(stopflag)'="")&(enddate<$zd($h,3)))
 ..s ^CacheTempFHQ(repid,RetNum)=ArcId_del_ArcDesc_del_ArcCode_del_SubCat_del_drug_del_startdate_del_enddate_del_Priority
 ..s RetNum=RetNum+1
 Q RetNum-1
}

ClassMethod GetArcimById(ArcimId As %String) As %String
{
 q:$g(ArcimId)="" ""
 s ArcimId1=$p(ArcimId,"||",1)
 q:ArcimId1="" 
 s del="^"
 q:'$d(^ARCIM(ArcimId1)) "医嘱ID不存在"
 f  s ArcimId1=$o(^ARCIM(ArcimId1)) q:ArcimId1=""  d
 .s ArcimId2=0
 .f  s ArcimId2=$o(^ARCIM(ArcimId1,ArcimId2)) q:ArcimId2=""  d
 ..s i=1
 ..k TarStr
 ..s ArcCode="",ArcDesc="",subcat="",drug="",startdate="",enddate="",Priority="",Unit=""
 ..s TmpStr1=$g(^ARCIM(ArcimId1,ArcimId2,1)) 
 ..s ArcCode=$p(^ARCIM(ArcimId1,ArcimId2,1),del,1)
 ..s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
 ..s ArcCode=$TR(ArcCode,$C(10,13),"")
 ..s ArcDesc=$TR(ArcDesc,$C(10,13),"")
 ..s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 ..s SubCatRecId=0,CtLocDesc="",CtLocDescAdd=""
 ..s ArcOemMesg=""
 ..s:$d(^ARCIM(ArcimId1,ArcimId2,"OEM",1)) ArcOemMesg=^ARCIM(ArcimId1,ArcimId2,"OEM",1)
 ..s:$g(ArcOemMesg)'="" ArcOemMesg=$tr(ArcOemMesg,$c(13)_$c(10))
 ..s CatDesc=""
 ..if subcat'="" d
 ...s CatDr=$p(^ARC("IC",subcat),del,8)
 ...s:$g(CatDr)'="" CatDesc=$p(^OEC("ORCAT",CatDr),"^",2)
 ..;q:$g(CatDr)'=11
 ..q:$g(CatDesc)'="检查"
 ..s:subcat'="" subcat=$p(^ARC("IC",subcat),del,2)
 ..s Sentive=""
 ..if $d(^ARCIM(ArcimId1,ArcimId2,9)) d
 ...s Sentive=$p(^ARCIM(ArcimId1,ArcimId2,9),del,18)
 ...s Sentive=$g(Sentive)
 ..s UnitDr=$p(^ARCIM(ArcimId1,ArcimId2,8),del,14)
 ..s:$g(UnitDr)'="" Unit=$p(^CT("UOM",UnitDr),del,2)
 ..s drug=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
 ..i $g(drug)'="" d
 ...s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2)
 ...if $d(^PHCD(drug1,drug2)) s drug=$p(^PHCD(drug1,drug2),del,2)
 ...else  s drug=""
 ..s startdate=$P($p(^ARCIM(ArcimId1,ArcimId2,1),del,13),"Z",1)
 ..if $g(startdate)'="" s startdate=$zd(startdate,3)
 ..s ArcEndDate=$p(^ARCIM(ArcimId1,ArcimId2,7),del,1)
 ..if $g(ArcEndDate)'="" s ArcEndDate=$zd(ArcEndDate,3)
 ..q:(($g(stopflag)'="")&(ArcEndDate<$zd($h,3)))
 ..s Priority=$p(^ARCIM(ArcimId1,ArcimId2,8),del,22)
 ..IF $G(Priority)'="" S Priority=$p(^OECPR(Priority),del,2)
 ..//取价格
 ..s OrdPrice=##class(web.DHCFBArcimGet).GetArcimPrice(ArcimId,"")
 ..
 ..s EqId=0,RbcSvrId=0,EqStr=""
 ..
 ..//取设备
 ..f  s RbcSvrId=$o(^RBC("SER",0,"ARCIM",ArcimId,RbcSvrId)) q:RbcSvrId=""  d
 ...s RbcSvrStr=^RBC("SER",RbcSvrId)
 ...s EqId=$p(RbcSvrStr,del,5)
 ...q:$g(EqId)=""
 ...s aa=$p(^RBC("EQ",EqId),del,2)
 ...s:EqStr'="" EqStr=EqStr_"/"_aa
 ...s:EqStr="" EqStr=aa
 ..//取别名
 ..S ArcRecLoc="",CtLocDescAdd1="",CtLocDesc="",CtLocDescAdd="",Sentive=""
 ..s ArcAliaId=0,FirstFlag=1,AliaStr=""
 ..f  s ArcAliaId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,ArcAliaId)) q:ArcAliaId=""  d
 ...s:AliaStr'="" AliaStr=AliaStr_"/"_$p(^ARC("ALIAS",ArcAliaId),del,6)
 ...s:AliaStr="" AliaStr=$p(^ARC("ALIAS",ArcAliaId),del,6)
 ..if $d(^DHCArcimBPSi(0,"Arcim",ArcimId)) d
 ...s ArcBodyPartId=$o(^DHCArcimBPSi(0,"Arcim",ArcimId,""))
 ...s ArcParts=$p(^DHCArcimBPS(ArcBodyPartId),del,2)
 ...s num=$l(ArcParts,"$")
 ...s ArcPartStr=""
 ...f j=1:1:num d
 ....s PartId=$p(ArcParts,"$",j)
 ....s BodyPart=$p(^MRC("BODP",PartId),del,1)
 ....s:ArcPartStr'="" ArcPartStr=ArcPartStr_"/"_BodyPart
 ....s:ArcPartStr="" ArcPartStr=BodyPart
 ....;s RetStr=ArcCode_del_BodyPart_ArcDesc_del_subcat_del_CatDesc_del_ArcOemMesg_del_Unit_del_OrdPrice_del_EqStr_del_drug_del_ArcEndDate_del_$TR(AliaStr,$C(10,13),"")_del_Sentive
 ..s RetStr=ArcCode_del_ArcPartStr_del_ArcDesc_del_subcat_del_CatDesc_del_ArcOemMesg_del_Unit_del_OrdPrice_del_EqStr_del_drug_del_ArcEndDate_del_$TR(AliaStr,$C(10,13),"")_del_Sentive
  w RetStr,!
 ;c f
  Q RetStr
}

/// 取医嘱的部位
ClassMethod GetBodyParts(OeordId As %String) As %String
{
	;d ##class(web.DHCFHQ.DHCFBArcim).GetBodyParts("488||3")
	s OeordId1=$p(OeordId,"||",1),OeordId2=$p(OeordId,"||",2)
	q:'$d(^OEORD(OeordId1)) ""
	q:'$d(^OEORD(OeordId1,"I",OeordId2)) ""
	q:'$d(^OEORD(OeordId1,"I",OeordId2,"DHC")) ""
	s BodyStr=""
	s BodyParts=$p(^OEORD(OeordId1,"I",OeordId2,"DHC"),"^",22)
	if BodyParts'=""  d
	.s num=$l(BodyParts,",")
	.s i=0,BodyStr=""
	.f  s i=i+1 q:i>num  d
	..s BodyId=$p(BodyParts,",",i)
	..q:'$d(^MRC("BODP",+BodyId))
	..s BodyPart=$p(^MRC("BODP",+(BodyId)),"^",2)
	..s:BodyStr'="" BodyStr=BodyStr_","_BodyPart
	..s:BodyStr="" BodyStr=BodyPart
	q BodyStr
}

ClassMethod ListAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListAllExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ListAllExecute(ByRef qHandle As %Library.Binary, Surname As %Library.String = "", GivenName As %Library.String = "", DefLoginLoc As %Library.String = "", NewStaffOnly As %Library.String = "", UserInputID As %Library.String, UserName As %Library.String, SSGRPDesc As %Library.String = "", CTCPTDesc As %Library.String = "", HOSPDesc As %Library.String = "", RUDesc As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	s index=1
	;SSUSRRowId,SSUSRLoginID,SSUSRInitials,SSUSRName,CTLOCDesc,SSGRPDesc,SSUSRSurname,SSUSRGivenName,SSGRPSecurityLevel
 	Set rset=##class(%ResultSet).%New("web.SSUser.ListAll")
	;Set SSUSRRowId=##class(web.DHCDocOrderCommon).UnEscape(SSUSRRowId)
	;Set SSUSRLoginID=##class(web.DHCDocOrderCommon).UnEscape(SSUSRLoginID)
	;Set SSUSRInitials=##class(web.DHCDocOrderCommon).UnEscape(SSUSRInitials)
	;Set SSUSRName=##class(web.DHCDocOrderCommon).UnEscape(SSUSRName)
	;Set CTLOCDesc=##class(web.DHCDocOrderCommon).UnEscape(CTLOCDesc)
	;Set SSGRPDesc=##class(web.DHCDocOrderCommon).UnEscape(SSGRPDesc)
	;Set SSUSRSurname=##class(web.DHCDocOrderCommon).UnEscape(SSUSRSurname)
	;Set SSUSRGivenName=##class(web.DHCDocOrderCommon).UnEscape(SSUSRGivenName)
	;Set SSGRPSecurityLevel=##class(web.DHCDocOrderCommon).UnEscape(SSGRPSecurityLevel)
	d rset.Execute(Surname , GivenName , DefLoginLoc, NewStaffOnly , UserInputID , UserName, SSGRPDesc, CTCPTDesc, HOSPDesc, RUDesc)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s Data=""
		/*
		for i=1:1:columns {
		Write rset.GetColumnName(i),": "
			s $List(Data,i)=rset.GetData(i)
		}*/
		Set SSUSRRowId=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(1))
		Set SSUSRLoginID=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(2))
		Set SSUSRInitials=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(3))
		Set SSUSRName=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(4))
		Set CTLOCDesc=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(5))
		Set SSGRPDesc=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(6))
		Set SSUSRSurname=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(7))
		Set SSUSRGivenName=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(8))
		Set SSGRPSecurityLevel=##class(web.DHCDocOrderCommon).UnEscape(rset.GetData(9))
		set Data=$lb(SSUSRRowId,SSUSRLoginID,SSUSRInitials,SSUSRName,CTLOCDesc,SSGRPDesc,SSUSRSurname,SSUSRGivenName,SSGRPSecurityLevel)
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
	 }
	d rset.Close()
	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
}

ClassMethod ListAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ListAll(Surname As %String, GivenName As %String, DefLoginLoc As %String, NewStaffOnly As %String, UserInputID As %String, UserName As %String, SSGRPDesc As %String, CTCPTDesc As %String, HOSPDesc As %String, RUDesc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SSUSRRowId,SSUSRLoginID,SSUSRInitials,SSUSRName,CTLOCDesc,SSGRPDesc,SSUSRSurname,SSUSRGivenName,SSGRPSecurityLevel")
{
}

}
