/// 名称: DHCHAI.IRS.CRuleOBSSrv
/// 描述: 检查护理管理（发热、腹泻）规则相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-13
Class DHCHAI.IRS.CRuleOBSSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  根据护理项目发热(术后3天不检查)
/// Table：       DHCHAI.DP.MRObservations、DHCHAI.DP.OROperation
/// Input：       aValue : 筛查项目
///               objResult : 检验结果
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsFever()
ClassMethod CheckIsFever(obj As DHCHAI.DP.MRObservations) As %String
{
	New (obj)
	Set return=0
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.OBEpisodeDr) return
	Quit:'$IsObject(obj.OBEpisodeDr.PAAdmLocDr) return
	Set AdmLocDr=obj.OBEpisodeDr.PAAdmLocDr.%Id()
	
	Set ItemValue=obj.OBItemValue
	Set ItemValue=+ItemValue
	
	Set Args=##class(DHCHAI.IRS.CRuleLocArgsSrv).GetArgsByLocDr(AdmLocDr)
	Set FeverMax=+$p(Args,"^",1)
	Set FeverMin=+$p(Args,"^",2)
	
	If (FeverMax>35)&(ItemValue>35) {
		Set:ItemValue>FeverMax return=1
	}
	If (FeverMin>35)&(ItemValue>35) {
		Set:ItemValue<FeverMin return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  根据护理项目筛查腹泻
/// Table：       
/// Input：       aItemCode : 筛查项目
///               objResult : 检验结果
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsDiarr()
ClassMethod CheckIsDiarr(obj As DHCHAI.DP.MRObservations) As %String
{
	New (obj)
	Set return=0
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.OBEpisodeDr) return
	Quit:'$IsObject(obj.OBEpisodeDr.PAAdmLocDr) return
	Set AdmLocDr=obj.OBEpisodeDr.PAAdmLocDr.%Id()
	Set PatAge=obj.OBEpisodeDr.PAAge
	Quit:PatAge="" return
	If PatAge["岁" {
		Set PatAge=+PatAge
	} Else {
		If (PatAge["月")||(PatAge["天") {
			Set PatAge=1
		} Else {
			Set PatAge=+PatAge
		}
	}
	
	//例子："1 1/E"表示自行排便一次，灌肠后排便一次
	Set ItemValue=obj.OBItemValue
	Set ItemValue=$p(ItemValue," ",1)
	Set:(ItemValue["E")&&(ItemValue["/") ItemValue=""  //灌肠后排便
	;Set:ItemValue["※" ItemValue="4"  //大便失禁
	Set:ItemValue["☆" ItemValue=""  //人工肛门
	//Set ItemValue=+ItemValue
	Set Args=##class(DHCHAI.IRS.CRuleLocArgsSrv).GetArgsByLocDr(AdmLocDr)
	Set DiarrMin=+$p(Args,"^",3)
	Set DiarrMin2=$p(Args,"^",4)
	
	Set DiarrMin2Age=$p(DiarrMin2,"|",1)
	Set DiarrMin2=$p(DiarrMin2,"|",2)
	
	Set:DiarrMin2="" DiarrMin2Age=""  //儿童维护格式不对则无效
	If (DiarrMin2Age'="")&(+DiarrMin2Age<=PatAge) {
		If (DiarrMin2>0)&(ItemValue>0) {
			If ItemValue="※" {
				Set return=1
			} Else {
				Set:ItemValue>DiarrMin2 return=1
				
				Set:(ItemValue["次以上")&(+ItemValue>=+DiarrMin2) return=1 
			}
		}
	} Else {
		If (DiarrMin>0)&(ItemValue'="") {
			If ItemValue="※" {
				Set return=1
			} Else {
				Set:ItemValue>DiarrMin return=1
				Set:(ItemValue["次以上")&(+ItemValue>=+DiarrMin) return=1 
			}
		}
	}
	Quit return
}

}
