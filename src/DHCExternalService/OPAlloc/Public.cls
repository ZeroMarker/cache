/// 本接口公共通用方法
Class DHCExternalService.OPAlloc.Public Extends %RegisteredObject [ Abstract, Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date：2017-08-17
/// desc：通过患者Id得到卡信息，如果是多个输出以逗号分隔的字符串
ClassMethod GetCardNoInfo(PersonRowId)
{
	Q:PersonRowId="" ""
	s CardNO=""
	s CardID=""
	f  s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,CardID)) q:CardID=""  d
	.s Flag=$P(^DHCCARD("CF",CardID),"^",10)
	.q:Flag'="N"
	.s cCardNo=$P(^DHCCARD("CF",CardID),"^",2)
	.s CardTypeDR=$p($g(^DHCCARD("CF",CardID)),"^",16)
	.q:CardTypeDR=""
	.s CardType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",2)
	.//卡号拼接 卡类型首字母
	.s cCardNo=CardType_$c(1)_cCardNo
	.i CardNO="" d
	..s CardNO=cCardNo
	.e  d
	..s CardNO=CardNO_","_cCardNo
	q CardNO
}

/// ;根据身份证取最近的患者病人ID,需要配置，根据配置确定是否在多ID的情况下返回空
ClassMethod GetHighestLevelPAPMIByIDNo(IDNo As %String) As %String
{
	n (IDNo)
	;w ##class(DHCExternalService.OPAlloc.Public).GetHighestLevelPAPMIByIDNo("412726199104176977")
	q:IDNo="" ""
	s PAPMI=""
	s IDNo=$$ALPHAUP^SSUTIL4(IDNo)
	i $L(IDNo)=18 {
		s IDCard=##class(DHCDoc.Util.Base).ID18to15(IDNo)
	}elseif $L(IDNo)=15 {
		s IDCard=##class(DHCDoc.Util.Base).ID15to18(IDNo)
	}elseif $L(IDNo)'="" {
		s IDCard=""
	}
	s IDNoStr=IDNo_"^"_IDCard
	s PAPMIRowIdStr=""
	s MulIDCount=0
	
	for IDLoop=1:1:$l(IDNoStr,"^") {
		s IDNo=$p(IDNoStr,"^",IDLoop)
		continue:IDNo=""
		s PAPMIRowId=0
		for {
			s PAPMIRowId=$O(^PAPERi("DVA",IDNo,PAPMIRowId)) q:PAPMIRowId=""
			s PatMasActive=$P($G(^PAPER(PAPMIRowId,"PAT",1)),"^",6)
			continue:PatMasActive="N"
			s MulIDCount=MulIDCount+1
			i PAPMIRowIdStr="" s PAPMIRowIdStr=PAPMIRowId
			e  s PAPMIRowIdStr=PAPMIRowIdStr_"^"_PAPMIRowId
		}
	}
	;TODO 需要配置，根据配置确定是否在多ID的情况下返回空
	i PAPMIRowIdStr'="" s PAPMI=$P(PAPMIRowIdStr,"^",$L(PAPMIRowIdStr,"^"))
	
	q PAPMI_"^"_MulIDCount
}

ClassMethod PatientIDToNo(PatientID As %String = "") As %String
{
	n (PatientID)
	q:PatientID="" ""
	q $P($g(^PAPER(PatientID,"PAT",1)),"^",1)
}

ClassMethod GetAdmitAddress(RBASID As %String) As %String
{
	set AdmitAddress="",LocAddress=""
	if $piece(RBASID,"||",2)="" quit AdmitAddress
	set LocDr=$piece($get(^RB("RES",+RBASID)),"^",1)
	S AddDr=$o(^CTLOC(LocDr,"ADDR",""),-1)
	if (AddDr'="") set LocAddress=$get(^CTLOC(LocDr,"ADDR",AddDr))
	set RoomDr=$piece($get(^RBAS(+RBASID,$piece(RBASID,"||",2),"DHC")),"^",5)
	if (RoomDr="") quit LocAddress
	S AddDr=$o(^CTLOC(RoomDr,"ADDR",""),-1)
	if (AddDr'="") set AdmitAddress=$get(^CTLOC(RoomDr,"ADDR",AddDr))
	quit AdmitAddress
}

}
