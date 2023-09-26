/// 数据导出
Class web.DHCFHQ.DHCFEXPORT Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 病区床位
ClassMethod WardBed(PacWardId)
{
	
	s del="^"
	s WardId=$g(PacWardId)
	if $g(WardId)="" s WardId=0
	else  s WardId=$o(^PAWARD(PacWardId),-1)
	s DateTmp=+$h
	f  s WardId=$o(^PAWARD(WardId)) q:((WardId="")!(($g(PacWardId)'="")&(PacWardId'=WardId)))  d
	.Q:(+WardId=0)
	.s WardCode=$p(^PAWARD(WardId),del,1),WardDesc=$p(^PAWARD(WardId),del,2)
	.s BedId=0
	.f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
	..S BedNo=$p(^PAWARD(WardId,"BED",BedId),del,1)
	..s BedTypeDr=$p(^PAWARD(WardId,"BED",BedId),del,2)
	..if $g(BedTypeDr)'="" s BedType=$p(^PAC("BEDTP",BedTypeDr),del,2)
	..S BedRoomDr=$p(^PAWARD(WardId,"BED",BedId),del,3)
	..if $g(BedRoomDr)'=""  d 
	...s BedRoom=$p(^PAROOM(BedRoomDr),del,2)
	...s RoomTypeDr=$p(^PAROOM(BedRoomDr),del,3)
	...s RoomType=$p(^PAC("ROOMT",RoomTypeDr),del,2)
	...s RetStr=WardCode_del_WardDesc_del_BedNo_del_BedType_del_BedRoom_del_RoomType
	...w RetStr,!
}

ClassMethod OrdCat(CatId)
{
	s del="^"
	s OrdCatId=$g(CatId)
	if $g(OrdCatId)="" s OrdCatId=0
	else  s OrdCatId=$o(^OEC("ORCAT",OrdCatId),-1)
	f  s OrdCatId=$o(^OEC("ORCAT",OrdCatId)) q:((OrdCatId="")!(($g(CatId)'="")&(CatId'=OrdCatId)))  d    //OEC_OrdCatRecLoc
	.s OrdCatCode=$p(^OEC("ORCAT",OrdCatId),del,1),OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),del,2)
	.s OrdCatRecId=0,OrdCatPatLocId=0,OrdCatRlLocId=0,OrdCatRlLocStr="",OrdCatPatLocStr=""
	.f  s OrdCatRecId=$o(^OEC("ORCAT",OrdCatId,"RL",OrdCatRecId)) q:OrdCatRecId=""  d
	..q:(($p(^OEC("ORCAT",OrdCatId,"RL",OrdCatRecId),del,9)<$h)&($p(^OEC("ORCAT",OrdCatId,"RL",OrdCatRecId),del,9)'=""))  //停用的不显示
	..s OrdCatPatLocId=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatRecId),del,2)
	..if $g(OrdCatPatLocId)="" s OrdCatPatLoc=""
	..else  s OrdCatPatLoc=$p(^CTLOC(OrdCatPatLocId),del,2)
	..s OrdCatRlLocId=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatRecId),del,3)
	..s OrdCatRlLoc=$p(^CTLOC(OrdCatRlLocId),del,2)
	..if $g(OrdCatRlLocStr)'="" s OrdCatRlLocStr=OrdCatRlLocStr_"/"_OrdCatRlLoc
	..if $g(OrdCatRlLocStr)="" s OrdCatRlLocStr=OrdCatRlLoc
	..if $g(OrdCatPatLocStr)'="" s OrdCatPatLocStr=OrdCatPatLocStr_"/"_OrdCatPatLoc
	..if $g(OrdCatPatLocStr)="" s OrdCatPatLocStr=OrdCatPatLoc
	.//取医嘱子类
	.s OrdCatSubId=0
	.f  s OrdCatSubId=$o(^ARC("IC",0,"OrdCat",OrdCatId,OrdCatSubId)) q:OrdCatSubId=""  d
	..s OrdCatSubCode=$p(^ARC("IC",OrdCatSubId),del,1),OrdCatSubDesc=$p(^ARC("IC",OrdCatSubId),del,2)
	..s OrdCatSubRecId=0,OrdCatSubPatLocStr="",OrdCatSubRlLocStr=""
	..f  s OrdCatSubRecId=$o(^ARC("IC",OrdCatSubId,"RL",OrdCatSubRecId)) q:OrdCatSubRecId=""  d    //ARC_ItemCatRecLoc
	...s OrdCatSubPatLocId=$p(^ARC("IC",OrdCatSubId,"RL",OrdCatSubRecId),del,2)
	...if $g(OrdCatSubPatLocId)="" s OrdCatSubPatLoc=""
	...else  s OrdCatSubPatLoc=$p(^CTLOC(OrdCatSubPatLocId),del,2)
	...if $g(OrdCatSubPatLocStr)'="" s OrdCatSubPatLocStr=OrdCatSubPatLocStr_"/"_OrdCatSubPatLoc
	...if $g(OrdCatSubPatLocStr)="" s OrdCatSubPatLocStr=OrdCatSubPatLoc
	...s OrdCatSubRlLocId=$p(^ARC("IC",OrdCatSubId,"RL",OrdCatSubRecId),del,3)
	...s OrdCatSubRlLoc=$p(^CTLOC(OrdCatSubRlLocId),del,2)
	...if $g(OrdCatSubRlLocStr)'="" s OrdCatSubRlLocStr=OrdCatSubRlLocStr_"/"_OrdCatSubPatLoc
	...if $g(OrdCatSubRlLocStr)="" s OrdCatSubRlLocStr=OrdCatSubRlLoc
	..w OrdCatCode_del_OrdCatDesc_del_OrdCatPatLocStr_del_OrdCatRlLocStr_del_OrdCatSubCode_del_OrdCatSubDesc_del_OrdCatSubPatLocStr_del_OrdCatSubRlLocStr,!
	..s:$g(OrdCatPatLocStr)'="" OrdCatPatLocStr=""
	..s:$g(OrdCatRlLocStr)'="" OrdCatRlLocStr=""
}

ClassMethod TarType()
{
	s EndFlag=0
	s RetStr="",del="^"
	s ArcbgId=0,TarCcId=0,TarTicId=0,TarTocId=0,TarTecId=0,TarTacId=0,TarTmcId=0
	k ^TmpFhq
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s ArcbgId=$o(^ARCBG(ArcbgId))
	.if $g(ArcbgId)'=""  d
	..q:(+ArcbgId=0)
	..s ArcbgDesc=$p(^ARCBG(ArcbgId),del,2)
	..s ArcbgSubId=0
	..f  s ArcbgSubId=$o(^ARCBG(ArcbgId,"SG",ArcbgSubId)) q:ArcbgSubId=""  d
	...s ArcbgSubDesc=$p(^ARCBG(ArcbgId,"SG",ArcbgSubId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,1)=ArcbgDesc,$p(^TmpFhq(j),del,2)=ArcbgSubDesc
	...else  s ^TmpFhq(j)=ArcbgDesc_del_ArcbgSubDesc_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_""_del_""_del_""
	.if ArcbgId="" s i=101
	
	//收费大类
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarCcId=$o(^DHCTarC("CC",TarCcId))
	.if $g(TarCcId)'=""  d
	..s TarCcDesc=$p(^DHCTarC("CC",TarCcId),del,2)
	..s TarScId=0
	..f  s TarScId=$o(^DHCTarC("SC",0,"TCC",TarCcId,TarScId)) q:TarScId=""  d
	...s TarScDesc=$p(^DHCTarC("SC",TarScId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,3)=TarCcDesc,$p(^TmpFhq(j),del,4)=TarScDesc
	...else  s ^TmpFhq(j)=""_del_""_del_TarCcDesc_del_TarScDesc_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_""_del_""_del_""
	.if TarCcId="" s i=101
	 
	 //住院发票
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarTicId=$o(^DHCTarC("TIC",TarTicId)) 
	.if $g(TarTicId)'=""  d
	..s TarTicDesc=$p(^DHCTarC("TIC",TarTicId),del,2)
	..s TarIcId=0
	..f  s TarIcId=$o(^DHCTarC("IC",0,"TIC",TarTicId,TarIcId)) q:TarIcId=""  d
	...s TarIcDesc=$p(^DHCTarC("IC",TarIcId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,5)=TarTicDesc,$p(^TmpFhq(j),del,6)=TarIcDesc
	...else  s ^TmpFhq(j)=""_del_""_del_""_del_""_del_TarTicDesc_del_TarIcDesc_del_""_del_""_del_""_del_""_del_""_del_""_""_del_""_del_""
	.if TarTicId="" s i=101
	//门诊发票
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarTocId=$o(^DHCTarC("TOC",TarTocId)) 
	.if $g(TarTocId)'=""  d
	..s TarTocDesc=$p(^DHCTarC("TOC",TarTocId),del,2)
	..s TarOcId=0
	..f  s TarOcId=$o(^DHCTarC("OC",0,"TOC",TarTocId,TarOcId)) q:TarOcId=""  d
	...s TarOcDesc=$p(^DHCTarC("OC",TarOcId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,7)=TarTocDesc,$p(^TmpFhq(j),del,8)=TarOcDesc
	...else  s ^TmpFhq(j)=""_del_""_del_""_del_""_del_""_del_""_del_TarTocDesc_del_TarOcDesc_del_""_del_""_del_""_del_""_""_del_""_del_""
	.if TarTocId="" s i=101
	//核算分类
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarTecId=$o(^DHCTarC("TEC",TarTecId)) 
	.if $g(TarTecId)'=""  d
	..s TarTecDesc=$p(^DHCTarC("TEC",TarTecId),del,2)
	..s TarEcId=0
	..f  s TarEcId=$o(^DHCTarC("EC",0,"TEC",TarTecId,TarEcId)) q:TarEcId=""  d
	...s TarEcDesc=$p(^DHCTarC("EC",TarEcId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,9)=TarTecDesc,$p(^TmpFhq(j),del,10)=TarEcDesc
	...else  s ^TmpFhq(j)=""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_TarTecDesc_del_TarEcDesc_del_""_del_""_""_del_""_del_""
	.if TarTecId="" s i=101
	//会计分类
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarTacId=$o(^DHCTarC("TAC",TarTacId)) 
	.if $g(TarTacId)'=""  d
	..s TarTacDesc=$p(^DHCTarC("TAC",TarTacId),del,2)
	..s TarAcId=0
	..f  s TarAcId=$o(^DHCTarC("AC",0,"TAC",TarTacId,TarAcId)) q:TarAcId=""  d
	...s TarAcDesc=$p(^DHCTarC("AC",TarAcId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,11)=TarTacDesc,$p(^TmpFhq(j),del,12)=TarAcDesc
	...else  s ^TmpFhq(j)=""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_TarTacDesc_del_TarAcDesc_""_del_""_del_""
	.if TarTacId="" s i=101
	//病案分类
	s i=1,j=0
	f  s i=i+1 q:i>100  d 
	.s TarTmcId=$o(^DHCTarC("TMC",TarTmcId)) 
	.if $g(TarTmcId)'=""  d
	..s TarTmcDesc=$p(^DHCTarC("TMC",TarTmcId),del,2)
	..s TarMcId=0
	..f  s TarMcId=$o(^DHCTarC("MC",0,"TMC",TarTmcId,TarMcId)) q:TarMcId=""  d
	...s TarMcDesc=$p(^DHCTarC("MC",TarMcId),del,2)
	...s j=j+1
	...if $d(^TmpFhq(j)) s $p(^TmpFhq(j),del,13)=TarTmcDesc,$p(^TmpFhq(j),del,14)=TarMcDesc
	...else  s ^TmpFhq(j)=""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_TarTmcDesc_del_TarMcDesc
	.if TarTmcId="" s i=101
	 
	s ArcbgSubId=0,TarScId=0,TarIcId=0,TarOcId=0,TarEcId=0,TarAcId=0,TarMcId=0
	s i=0
	f  s i=i+1 q:i>100  d
	.q:'$d(^TmpFhq(i))
	.s RetStr=^TmpFhq(i)	
	.w RetStr,!
	.
}

}
