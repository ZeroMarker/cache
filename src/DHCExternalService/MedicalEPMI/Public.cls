/// 本接口公共通用方法
/// 
Class DHCExternalService.MedicalEPMI.Public Extends %RegisteredObject [ Abstract, Not ProcedureBlock ]
{

/// ;根据身份证取最近的患者病人ID,需要配置，根据配置确定是否在多ID的情况下返回空
ClassMethod GetHighestLevelPAPMIByIDNo(IDNo As %String) As %String
{
	n (IDNo)
	;w ##class(DHCDoc.Interface.Outside.OPAlloc.SelfRegPlulic).GetHighestLevelPAPMIByIDNo("412726199104176977")
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

}
