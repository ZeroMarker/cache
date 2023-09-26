/// 名称: DHCHAI.IRC.MRObsDiarrSrv
/// 描述: 护理操作（腹泻）检查规则
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.MRObsDiarrSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  检查规则-腹泻
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.MRObsDiarrSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc))
			Quit:xItemDesc=""
			
			//根据体温筛查“腹泻”项目
			Set objOBSIM=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(xSCode,xItemDesc)
			Continue:'$IsObject(objOBSIM)
			Continue:'$IsObject(objOBSIM.BTMapItemDr)
			Set OBSItemCat=objOBSIM.BTMapItemDr.BTCatDr
			Continue:'$IsObject(OBSItemCat)
			Set LabType=OBSItemCat.BTDesc
			Continue:(LabType'="大便次数")
			
			Set xDate=aSttDate-1
			For {
				Set xDate=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate))
				Quit:xDate=""
				Quit:xDate>aEndDate
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate,xID))
					Quit:xID=""
					
					//获取筛查结果
					Do ..GetCheck(xID,aItmMastID)
				}
			}
		}
	}
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  检查规则-腹泻
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.MRObsDiarrSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.MRObservationsI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(xID)
				If $IsObject(objMRObs){
					Set SCode=objMRObs.OBSCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aMRObsID As %String, aItmMastID As %String) As %String
{
	New (aMRObsID,aItmMastID)
	Set return=0
	Quit:(aMRObsID="")||(aItmMastID="") return
	
	Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(aMRObsID)
	Quit:'$IsObject(objMRObs) return
	Quit:'$IsObject(objMRObs.OBEpisodeDr) return
	Set IsActive=objMRObs.OBIsActive
	Quit:IsActive'=1 return
	
	Set MRObsID=objMRObs.%Id()
	Set EpisodeID=objMRObs.OBEpisodeDr.%Id()
	Set SCode=objMRObs.OBSCode            //子系统代码
	Set ItemDesc=objMRObs.OBItemDesc      //护理项目
	Set ItemCode=objMRObs.OBItemCode      //护理项目代码
	Set EntryDate=objMRObs.OBEntryDate    //录入日期
	Set EntryTime=objMRObs.OBEntryTime    //录入时间
	Set EntryUser=objMRObs.OBEntryUser    //录入人
	Set:EntryUser'="" EntryUser=$p(EntryUser,"^",3)
	
	//根据体温筛查“腹泻”项目
	Set objOBSIM=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(SCode,ItemDesc)
	Quit:'$IsObject(objOBSIM) return
	Quit:'$IsObject(objOBSIM.BTMapItemDr) return
	Set OBSItemCat=objOBSIM.BTMapItemDr.BTCatDr
	Quit:'$IsObject(OBSItemCat) return
	Set LabType=OBSItemCat.BTDesc
	Quit:(LabType'="大便次数") return
	Set OBSItemDr=objOBSIM.BTMapItemDr.%Id()
	
	Set ItemValue=objMRObs.OBItemValue    //结果
	Quit:ItemValue="" return    //腹泻标准
	Set IsFever=##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsDiarr(objMRObs)
	Quit:IsFever<1 return  //检查腹泻规则（不同科室、不同年龄可能不同）
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = +ItemValue   //大便次数
	Set obj.CCTextRes   = (+ItemValue)_"次"    //定性结果
	Set obj.CCUnit      = "次"         //单位
	Set obj.CCActDate   = EntryDate    //登记日期
	Set obj.CCActTime   = EntryTime    //登记时间
	Set obj.CCActUser   = EntryUser    //登记人
	Set obj.CCRepDate   = ""           //登记日期
	Set obj.CCRepTime   = ""           //登记时间
	Set obj.CCRepUser   = ""           //登记人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = MRObsID
	Set obj.CCParams    = "MRObsID="_MRObsID
	
	Set obj.CCKeyWord   = "腹泻"       //关键词
	Set obj.CCIsAbFlag  = 1            //是否腹泻
	Set obj.CCSummary   = ItemDesc_":"_(+ItemValue)_"次"  //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
