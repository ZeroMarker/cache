/// 名称: DHCHAI.IRC.ORHealingSrv
/// 描述: 手术愈合等级检查规则
/// 编写者：pylian
/// 编写日期: 2019-12-11
Class DHCHAI.IRC.ORHealingSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-12-11
/// Description:  检查规则-手术愈合等级
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEOrdItemSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"

	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Do ..GetCheck(xID,aItmMastID)
		}
	}
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-12-11
/// Description:  检查规则-手术愈合等级
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEOrdItemSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperationI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objOperAnaes=##class(DHCHAI.DP.OROperation).GetObjById(xID)
				If $IsObject(objOperAnaes){
					Set SCode=objOperAnaes.ORSCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aOperAnaesID As %String, aItmMastID As %String) As %String
{
	New (aOperAnaesID,aItmMastID)
	Set return=0
	Quit:(aOperAnaesID="")||(aItmMastID="") return
	
	Set objOperAnaes=##class(DHCHAI.DP.OROperation).GetObjById(aOperAnaesID)
	Quit:'$IsObject(objOperAnaes) return
	Quit:'$IsObject(objOperAnaes.OREpisodeDr) return
	Set IsActive=objOperAnaes.ORIsActive
	Quit:IsActive'=1 return
	
	Set OperAnaesID=objOperAnaes.%Id()
	Set EpisodeID=objOperAnaes.OREpisodeDr.%Id()
	Set SCode=objOperAnaes.ORSCode             //子系统代码
	Set OperDesc=objOperAnaes.OROperDesc       //手术名称
	Set OperDate=objOperAnaes.OROperDate       //手术日期
	Set SttTime=objOperAnaes.ORSttTime         //手术开始时间
	Set Opertor=objOperAnaes.OROpertor         //术者
	Set OpertorName=$p(Opertor,"|",3)
	Set EndDate=objOperAnaes.OREndDate         //手术结束日期
	Set EndTime=objOperAnaes.OREndTime         //手术结束时间
	Set Incision=objOperAnaes.ORIncision       //手术切口等级
	Set Healing =objOperAnaes.ORHealing        //手术愈合等级类型
	Set MapIncision=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)
	Set MapHealing=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",Healing)
	Quit:$p(MapHealing,"^",3)'="丙" return  //手术愈合等级不是丙 退出
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = OperDesc     //手术名称
	Set obj.CCTextRes   = ""           //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActDate   = OperDate     //手术日期
	Set obj.CCActTime   = SttTime      //手术开始时间
	Set obj.CCActUser   = OpertorName  //术者
	Set obj.CCRepDate   = EndDate      //手术结束日期
	Set obj.CCRepTime   = EndTime      //手术结束时间
	Set obj.CCRepUser   = ""           //无
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = OperAnaesID
	Set obj.CCParams    = "OperAnaesID="_OperAnaesID
	
	Set obj.CCKeyWord   = "丙级愈合"   //关键词
	Set obj.CCOperDate  = OperDate     //手术日期
	Set obj.CCIncision  = Incision     //切口类型
	Set obj.CCSummary   = OperDesc_":"_MapIncision_"/"_MapHealing      //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
