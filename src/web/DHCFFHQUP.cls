Class web.DHCFFHQUP Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

ClassMethod UpArcim() As %String
{
	s RetStr="",del="^",j=0
	s ArcimId1=27
	f  s ArcimId1=$o(^ARCIM(ArcimId1)) q:ArcimId1=""  d
	.q:ArcimId1>3544
	.s ArcimId2=0
	.f  s ArcimId2=$o(^ARCIM(ArcimId1,ArcimId2)) q:ArcimId2=""  d
	..s ArcimId=ArcimId1_"||"_ArcimId2
	..s TarId=0,i=0
	..f  s TarId=$o(^DHCOLT(0,"ARTTA",ArcimId,TarId)) q:TarId=""  d
	...s i=i+1
	..if i>1  d
	...&sql(update SQLUser.arc_itmmast set ARCIM_BillingUOM_DR=1 where Arcim_rowid=:ArcimId)
	...w $G(SQLCODE)
	...s j=j+1
	...
	q j
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
	...i $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"Mrc_Icddx -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 Q RetStr
}

ClassMethod UpOrdCat() As %String
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
	....IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
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
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=3,PLIST(6)="Y"
	..
	..&sql(insert into SQLUser.SS_GroupOrderCategory VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=6,PLIST(6)="Y"
	..&sql(insert into SQLUser.SS_GroupOrderCategory VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderCategory"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
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
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=4
	..
	..&sql(insert into SQLUser.SS_GroupOrderStatus VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	..S PLIST(3)=6
	..&sql(insert into SQLUser.SS_GroupOrderStatus VALUES :PLIST() )
	..IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"SS_GroupOrderStatus"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..w "."
	Q ""
}

/// 修改收费项目的类别
ClassMethod UpTarItem(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^",j=0
	SET RowStr=$tr(RowStr," ","")
	SET TarCode=$P(RowStr,del,1),TarSubCate=$P(RowStr,del,2)
	q:TarCode=""
	q:TarSubCate=""
	s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),0))
	if $g(TarId)="" s TarId=$o(^DHCTARI(0,"Code",TarCode,0))
	q:TarId="" "取收费项目指针出错"_TarCode
	s TarSubId=$o(^DHCTarC("SC",0,"Code",$$ALPHAUP^SSUTIL4(TarSubCate),0))
	q:TarSubId="" "取收费项子类指针出错"_TarSubCate
	&sql(update sqluser.dhc_taritem set Tari_SubCate=:TarSubId where Tari_Rowid=:TarId)
	IF $g(SQLCODE) s RetStr=##class(web.DHCFFHQ).RetErrorValue(RetStr,"dhc_taritem"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	Q RetStr
}

ClassMethod UpPhcGe() As %String
{
	s del="^",j=0
	s PhcGeId=0
	f  s PhcGeId=$o(^PHCGE("GE",PhcGeId)) q:PhcGeId=""  d
	.s ^PHCGE("GE",PhcGeId)=$tr(^PHCGE("GE",PhcGeId),$c(13,10),"")
	q ""
}

}
