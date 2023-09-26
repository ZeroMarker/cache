/// 名称: DHCHAI.IRC.OEAntiUseSrv
/// 描述: 器械相关治疗医嘱检查规则
/// 编写者：zhufei
/// 编写日期: 2017-08-17
Class DHCHAI.IRC.OEOrdItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-17
/// Description:  检查规则-器械相关治疗医嘱
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
	
	Kill arrOEOrdItem
	
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate")
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate")
	//就诊医嘱开始日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,0,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,0,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	//就诊医嘱停止日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,0,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,0,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	Kill arrOEOrdItem
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  检查规则-器械相关治疗医嘱
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
	
	//就诊更新日期索引
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				If $IsObject(objOEItem){
					Set SCode=objOEItem.OESCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aOEItemID As %String, aItmMastID As %String) As %String
{
	New (aOEItemID,aItmMastID)
	Set return=0
	Quit:(aOEItemID="")||(aItmMastID="") return
	
	Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(aOEItemID)
	Quit:'$IsObject(objOEItem) return
	Quit:'$IsObject(objOEItem.OEEpisodeDr) return
	Set IsActive=objOEItem.OEIsActive
	Quit:IsActive'=1 return
	
	Set OEItemID=objOEItem.%Id()
	Set EpisodeID=objOEItem.OEEpisodeDr.%Id()
	Set SCode=objOEItem.OESCode             //子系统代码
	Set OrdDesc=objOEItem.OEOrdDesc         //医嘱名称
	Set SttDate=objOEItem.OESttDate         //医嘱开始日期
	Set SttTime=objOEItem.OESttTime         //医嘱开始时间
	Set Doctor=objOEItem.OEDoctor           //开医嘱人
	Set DocName=$p(Doctor,"|",3)
	Set XDate=objOEItem.OEXDate             //停医嘱日期
	Set XTime=objOEItem.OEXTime             //停医嘱时间
	
	Set objItmMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(SCode,OrdDesc)
	Quit:'$IsObject(objItmMap) return
	Quit:'$IsObject(objItmMap.BTMapItemDr) return
	Set objItmCat=objItmMap.BTMapItemDr.BTCatDr
	Quit:'$IsObject(objItmCat) return
	Quit:'$IsObject(objItmCat.BTTypeDr) return
	Set MapItmCatCode=objItmCat.BTCode
	Set MapItmTypeCode=objItmCat.BTTypeDr.BTCode
	Quit:MapItmTypeCode'="DRT" //器械相关治疗
	Quit:MapItmCatCode["DRT-E-" //过滤排除类型插管
	
	Set KeyWord=""
	Set:MapItmCatCode["PICC" KeyWord="中心静脉置管"
	Set:MapItmCatCode["VAP" KeyWord="呼吸机"
	Set:MapItmCatCode["UC" KeyWord="导尿管"
	Set:MapItmCatCode["IDT" KeyWord="留置引流管"
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = OrdDesc      //医嘱名称
	Set obj.CCTextRes   = ""           //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActDate   = SttDate      //医嘱开始日期
	Set obj.CCActTime   = SttTime      //医嘱开始时间
	Set obj.CCActUser   = DocName      //开医嘱人
	Set obj.CCRepDate   = XDate        //停止日期
	Set obj.CCRepTime   = XTime        //停止时间
	Set obj.CCRepUser   = ""           //停止人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = OEItemID
	Set obj.CCParams    = "OEItemID="_OEItemID
	
	Set obj.CCKeyWord   = KeyWord      //关键词
	Set obj.CCSummary   = OrdDesc      //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
