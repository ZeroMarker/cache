Class web.DHCFHQ.DHCFFHQUP Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod PatInfo() As %String
{
	s RowStr="^^^未用^^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s Country="中国"
	S Country="ZG-"_Country
	//q:$g(CardNo)="" "卡号为空"
	s i=0
	s Name="未用"
	f i = 1:1:10000 
	{s PatNo=##class(web.DHCFBPat).ConvertPatNo(i)
	//s ^FHQ(PatNo)=RowStr
	//if $l(RowStr,"?")>1 S ^FHQ(PatNo)=RowStr
	//q "" 
	s Dob=""
	s Sex=""
	s PatType="自费"
	if $g(PatType)'="" d
	.s PatType=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
	if $g(Country)'="" d 
	.s Country=$o(^CT("COU",0,"Desc",$$ALPHAUP^SSUTIL4(Country),""))
	k PLIST
	s PLIST(8)=PatNo
	s PLIST(4)=Name,PLIST(120)=Country
	s PLIST(11)=Dob
	s PLIST(15)=1
	&sql(insert into SQLUSER.Pa_PatMas VALUES :PLIST())
 if $g(SQLCODE) d
	.w !,($tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	S PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.q:PatId=""
	.&sql(Update SQLUSER.Pa_Person set PAPER_SocialStatus_DR=:PatType where PAPER_ROWID=:PatId)
	.w !,($tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

}
		
	q i
}

ClassMethod UpArcim(ChangeType As %String = "", RowStr As %String = "") As %String
{
   ;s ^fhq=RowStr
  
	s RetStr="",del="^",j=0
	S OrdCode=$P(RowStr,del,1),SpecDescs=$P(RowStr,del,3)
	S SpecId=0
	s CircleFlag=1
	s ArcimCode=$$ALPHAUP^SSUTIL4(OrdCode)
	s ArcimId=0
	s ArcimId=$o(^ARCIM(0,"Code",ArcimCode,ArcimId))
	q:$g(ArcimId)="" "取医嘱指针出错 "_OrdCode
	k ^ARCIM(ArcimId,"1","SPEC")
	s ArcimSpeId=0
	s CircleFlag=1
	s i=1
	f  s SpecDesc=$p(SpecDescs,"/",i) q:SpecDesc=""  d
	.s SpecId=0
	.s i=i+1
	.f  s SpecId=$o(^TTAB("SPEC",SpecId)) q:((SpecId="")!(CircleFlag'=1))  d
	..s SpecDesc1=$p(^TTAB("SPEC",SpecId),"\",1)
	..
	..if SpecDesc1=SpecDesc s CircleFlag=0,SpecRowid=SpecId
	.if CircleFlag=1 s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"取标本出错:"_OrdCode_"^"_SpecDesc)
	.q:(CircleFlag=1)
	.
	.s CircleFlag=1,ArcimSpeId=0
	.
	.f  s ArcimSpeId=$o(^ARCIM(ArcimId,"1","SPEC",ArcimSpeId)) q:((ArcimSpeId="")!(CircleFlag'=1))  d
	..s SpecRowidTmp=$p(^ARCIM(ArcimId,"1","SPEC",ArcimSpeId),del,1)
	..;w SpecRowidTmp_" "_SpecRowid,!
	..if SpecRowidTmp=SpecRowid s CircleFlag=0
	.;w CircleFlag,!
	.b ;2
	.if CircleFlag=1  d
	..K PLIST
	..S PLIST(0)=ArcimId_"||1",PLIST(3)=SpecRowid
	..b
	..&sql(insert INTO SQLUSER.ARC_ItemSpecimen VALUES :PLIST())
    ..i $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"ARC_ItemSpecimen -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	Q RetStr
}

ClassMethod UpArcim1(ChangeType As %String = "", RowStr As %String = "") As %String
{
   ;s ^fhq=RowStr
   	s RetStr="",del="^",j=0
	S OrdCode=$P(RowStr,del,2),Other=$P(RowStr,del,3)
	s ArcimCode=$$ALPHAUP^SSUTIL4(OrdCode)
	s ArcimId=0
	s ArcimId=$o(^ARCIM(0,"Desc",ArcimCode,ArcimId))
	q:$g(ArcimId)="" "取医嘱指针出错 "_OrdCode
	q:$g(Other)="" "确认点为空"
	if ChangeType'="Test" s ^ARCIM(ArcimId,"1","RB",0)=1,^ARCIM(ArcimId,"1","RB",1)=Other
	q RetStr
}

ClassMethod UpICDCode(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    IcdCode1    IcdCode2  IcdDesc  Alia
	;

	s RetStr="",del="^"
	;S RowStr=$TR(RowStr," ","")
	S Code=$P(RowStr,del,1),IcdCode1=$P(RowStr,del,2),IcdCode2=$P(RowStr,del,3),IcdDesc=$P(RowStr,del,4),Alias=$P(RowStr,del,5)
	
	if ((Code'="")&(IcdCode1'="")) d
	.IF ($D(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code))) & $D(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(IcdDesc)))) d
	..s TmpId=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	..q:$g(TmpId)=""
	..s IcdC1=$p(^MRC("ID",TmpId),del,4)
	..if (($$ALPHAUP^SSUTIL4(IcdC1)=$$ALPHAUP^SSUTIL4(IcdCode1))&(IcdC1'=IcdCode1)) d
	...&SQL(update SQLUser.Mrc_Icddx set mrcid_icd9cm_Code=:IcdCode1 where mrcid_rowid=:TmpId)
	...i $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"Mrc_Icddx -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 Q RetStr
}

ClassMethod UpOrdCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	s RetStr="",del="^",j=0
	S ArcCode=$P(RowStr,del,1),ArcSubCat=$P(RowStr,del,3)
	if $d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode))) d
	.s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),""))
	.q:ArcimId1=""
	.s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,""))
	.q:ArcimId2=""
	.s ArcSubCatId=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),""))
	.q:ArcSubCatId="" 
	.s ArcimId=ArcimId1_"||"_ArcimId2
	.&sql(update sqluser.arc_itmmast set ARCIM_ItemCat_DR=:ArcSubCatId where Arcim_rowid=:ArcimId )
	.IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,ArcCode_","_ArcSubCat_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpArcCat() As %String
{
	
	s RetStr="",del="^"
	s CatId=4
	f  s CatId=$o(^ARC("IC",CatId)) q:CatId=""  d
	.s SubId=""
	.f  s SubId=$o(^ARC("IC",CatId,"RL",SubId)) q:SubId=""  d
	..s PatLoc=$p(^ARC("IC",CatId,"RL",SubId),del,2)
	..if $g(PatLoc)'="" d
	...s RecLoc=$p(^ARC("IC",CatId,"RL",SubId),del,3)
	...s SubId2="",CircleFlag=1
	...f  s SubId2=$o(^ARC("IC",CatId,"RL",SubId2)) q:((SubId2="")!(CircleFlag'=1))  d
	....s PatLoc1=$p(^ARC("IC",CatId,"RL",SubId2),del,2)
	....s RecLoc1=$p(^ARC("IC",CatId,"RL",SubId2),del,3)
	....if (($g(PatLoc1)="")&(RecLoc1=RecLoc)) s CircleFlag=0
	...if CircleFlag=1 d
	....SET PLIST(0)=CatId,PLIST(4)=RecLoc,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....w "."
 q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpSsGOrdCat() As %String
{
	s RetStr="",del="^",j=0
	s SsgrpId=71
	f  s SsgrpId=$o(^SSU("SSGRP",SsgrpId)) q:SsgrpId=""  d
	.s OstId=0
	.if '$d(^SSU("SSGRP",SsgrpId,"SSORD")) d
	..k PLIST
	..S PLIST(0)=SsgrpId,PLIST(3)=2,PLIST(6)="Y"
	..&sql(insert into SQLUser.SS_GroupOrderCategory VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=3,PLIST(6)="Y"
	..
	..&sql(insert into SQLUser.SS_GroupOrderCategory VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=6,PLIST(6)="Y"
	..&sql(insert into SQLUser.SS_GroupOrderCategory VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	Q ""
}

/// 修改安全组的医嘱壮态
ClassMethod UpSsGOrdStatus() As %String
{
	s RetStr="",del="^",j=0
	s SsgrpId=71
	f  s SsgrpId=$o(^SSU("SSGRP",SsgrpId)) q:SsgrpId=""  d
	.s OstId=0
	.if '$d(^SSU("SSGRP",SsgrpId,"OSTAT")) d
	..k PLIST
	..S PLIST(0)=SsgrpId,PLIST(3)=1
	..&sql(insert into SQLUser.SS_GroupOrderStatus VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=4
	..
	..&sql(insert into SQLUser.SS_GroupOrderStatus VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=6
	..&sql(insert into SQLUser.SS_GroupOrderStatus VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	Q ""
}

/// 修改收费项目的类别
ClassMethod UpTarItem(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET TarCode=$P(RowStr,del,1),TarDesc=$P(RowStr,del,2)
	
 if ((TarCode="") & (TarDesc="")) d
 else  d
 .if TarCode="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费项代码为空:")
 .if TarDesc="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费项名称为空:")
 if (($g(TarCode)'="")&($g(TarDesc)'="")) d
 .;s:($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode)))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .;s:($D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc)))&('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)

 
 //收费项目
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .if (($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))&($D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) d
	..s TarSubCatDr="",OUTPDR="",INPDR="",EMCDR="",ACCTDR="",ACCTDR="",MRDR=""
	..s TarSubCat=$P(RowStr,del,4)
	..SET INP=$P(RowStr,del,6),OUTP=$P(RowStr,del,8),EMC=$P(RowStr,del,10),ACCT=$P(RowStr,del,12),MR=$P(RowStr,del,14)
	..;s:TarSubCat="" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费子类为空:"_TarCode)
	..;q:TarSubCat=""
	..;SET:TarSubCat'="" TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
	..;s:TarSubCatDr="" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费子指针出错:"_TarCode_","_TarSubCat)
	..;Q:TarSubCatDr=""
	..;if OUTP="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"门诊子类为空:"_TarCode) 
	..;SET:OUTP'="" OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	..;if OUTPDR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"门诊子类指针出错:"_TarCode_","_OUTP) 
	..;if INP="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"住院子类为空:"_TarCode) 
	..;SET:INP'="" INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	..;if INPDR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"住院子类指针出错:"_TarCode_","_INP) 
	..if EMC="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"核算子类为空:"_TarCode) 
	..SET:EMC'="" EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	..if EMCDR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"核算子类指针出错:"_TarCode_","_EMC) 
	..q:EMCDR=""
	..;if ACCT="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"会计科目子类为空:"_TarCode) 
	..;SET:ACCT'="" ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	..;if ACCTDR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"会计科目指针出错:"_TarCode_","_ACCT) 
	..
	..;if MR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"病案子类为空:"_TarCode) 
	..;SET:MR'="" MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	..;if MRDR="" s RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"病案指针出错:"_TarCode_","_MRDR) 
	..if ChangeType'="Test" d
 ...s TarId=$o(^DHCTARI(0,"Code",TarCode,""))
 ...if TarId="" s RetStr=RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"收费项指针出错"_TarCode)
 ...q:TarId=""
 ...;q
 ...&SQL(update SQLUser.dhc_taritem set TARI_EMCCate=:EMCDR where TARI_RowId=:TarId)
 ...s:$g(SQLCODE) RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"dhc_taritem -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpPhcGe() As %String
{
	s del="^",j=0
	s PhcGeId=0
	f  s PhcGeId=$o(^PHCGE("GE",PhcGeId)) q:PhcGeId=""  d
	.s ^PHCGE("GE",PhcGeId)=$tr(^PHCGE("GE",PhcGeId),$c(13,10),"")
	q ""
}

ClassMethod UpPrice() As %String
{
	;s del="^",j=0,i=0
	;s TarId=0,PatInsId=0,StarDate=0
	;f  s TarId=$o(^DHCTARIi("TARI",TarId)) q:TarId=""  d
	;.s PatInsId=0
	;.f  s PatInsId=$o(^DHCTARIi("TARI",TarId,PatInsId)) q:PatInsId=""  d
	;..s StarDate=0
	;..f  s StarDate=$o(^DHCTARIi("TARI",TarId,PatInsId,StarDate)) q:StarDate=""  d
	;...s ChildId=0,j=j+1
	;...f  s ChildId=$o(^DHCTARIi("TARI",TarId,PatInsId,StarDate,ChildId)) Q:ChildId=""  D
	;....s killid=ChildId
	;....f  s killid=$o(^DHCTARI(TarId,"P",killid)) q:killid=""  d
	;.....s i=i+1
	;.....k ^DHCTARI(TarId,"P",ChildId)
	;q j_"^"_i
	Set Itm=0
	For  Set Itm=$O(^DHCTARI(Itm)) Quit:Itm=""  Do
	.Set PrItm=$O(^DHCTARI(Itm,"P",""),-1)
	.If PrItm="" W !,Itm Quit
	.Set ^DHCTARI(Itm,"P",0)=PrItm
	Quit 0
}

ClassMethod UpOrd() As %String
{
	s OrdCatId=17,del="^"
	s ArcimId1=0,ArcimId2=0,ArcSubCatId=0
	f  s ArcSubCatId=$o(^ARCIM(0,"ARCIC_DR",ArcSubCatId)) q:ArcSubCatId=""  d
	.s ArcimCatId=$p(^ARC("IC",ArcSubCatId),del,8)
	.q:(ArcimCatId=60)
	.q:(ArcimCatId=8)
	.s ArcimId1=0
	.f  s ArcimId1=$o(^ARCIM(0,"ARCIC_DR",ArcSubCatId,ArcimId1)) q:ArcimId1=""  d
	..s ArcimId2=0
	..f  s ArcimId2=$o(^ARCIM(0,"ARCIC_DR",ArcSubCatId,ArcimId1,ArcimId2)) q:ArcimId2=""  d
	...
	...s ArcimDesc=$p($g(^ARCIM(ArcimId1,ArcimId2,9)),del,38)
	...q:ArcimDesc'=""
	...;s ArcimDesc=ArcimDesc_"(门诊用)"
	...s ArcimId=ArcimId1_"||"_ArcimId2
	...&sql(update sqluser.Arc_itmmast set ARCIM_MaxQty=100 where arcim_rowid=:ArcimId)
	...w ArcimId,!
}

ClassMethod UpBed() As %String
{
	s WardId=0,del="^"
	f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
	.s BedId=0
	.q:WardId=17
	.f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
	..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
	..s BedDescTmp=BedDesc
	..q:BedDescTmp="无效床位"
	..q:($l(BedDescTmp,"加")>1)
	..q:($l(BedDescTmp,"+")>1)
	..q:($l(BedDescTmp,"推")>1)
	..s BedDescTmp=$tr(BedDescTmp,"床","")
	..q:$l(BedDescTmp)>2
	..;w BedDescTmp_" "
	..q:$l(BedDescTmp)'=2
	..s Rid=WardId_"||"_BedId
	..if $l(BedDescTmp)=2 s BedDesc="0"_BedDesc
	..;w BedDesc_" "
	..&sql(update sqluser.pac_bed set BED_Code=:BedDesc where BED_RowID=:Rid )
	..w BedDesc_" "_Rid_" "
}

}
