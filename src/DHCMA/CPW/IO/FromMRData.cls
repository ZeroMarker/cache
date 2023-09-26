/// 名称: 			DHCMA.CPW.IO.FromMRData
/// 描述: 			此类记录从综合查询组获取数据接口
/// 编写者：		yankai
/// 编写日期: 		2022-12-14
Class DHCMA.CPW.IO.FromMRData Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：      	yankai
/// CreatDate：    	2022-12-14
/// Description： 	获取某科某段时间内入院人数
/// Table/Global：  ^MRIPdaily("MRIPloc",{MRIP_loc_dr},"MRIPdate",{MRIP_date},{MRIP_rowid})
/// Input:			
/// Return：       	
/// w ##class(DHCMA.CPW.IO.FromMRData).GetRYRSByLocDate("2020-07-01","2020-07-31",127)
ClassMethod GetRYRSByLocDate(aSttDate As %String, aEndDate As %String, aLocID As %String) As %String
{
	New (aSttDate,aEndDate,aLocID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aLocID="") "-1"
	
	Set aSttDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:+aSttDate>+aEndDate "-2"
	
	For xDate=aSttDate:1:aEndDate {
		Set xMRID=0
		For {
			Set xMRID=$o(^MRIPdaily("MRIPloc",+aLocID,"MRIPdate",xDate,xMRID))
			Quit:xMRID=""
			
			Set ryrs=$p(^MRIPdaily(xMRID),"^",8)  //入院人数
			Set return=return+ryrs
		}	
	}
	
	Quit return
}

/// Creator：      	yankai
/// CreatDate：    	2022-12-14
/// Description： 	获取某科某段时间内出院人数
/// Table/Global：  ^MRIPdaily("MRIPloc",{MRIP_loc_dr},"MRIPdate",{MRIP_date},{MRIP_rowid})
/// Input:			
/// Return：       	
/// w ##class(DHCMA.CPW.IO.FromMRData).GetCYRSByLocDate("2020-07-01","2020-07-31",127)
ClassMethod GetCYRSByLocDate(aSttDate As %String, aEndDate As %String, aLocID As %String) As %String
{
	New (aSttDate,aEndDate,aLocID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aLocID="") "-1"
	
	Set aSttDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:+aSttDate>+aEndDate "-2"
	
	For xDate=aSttDate:1:aEndDate {
		Set xMRID=0
		For {
			Set xMRID=$o(^MRIPdaily("MRIPloc",+aLocID,"MRIPdate",xDate,xMRID))
			Quit:xMRID=""
			
			Set cyrs=$p(^MRIPdaily(xMRID),"^",5)  //出院人数
			Set return=return+cyrs
		}	
	}
	
	Quit return
}

/// Creator：      	yankai
/// CreatDate：    	2022-12-14
/// Description： 	获取某科某段时间内转入人数
/// Table/Global：  ^MRIPdaily("MRIPloc",{MRIP_loc_dr},"MRIPdate",{MRIP_date},{MRIP_rowid})
/// Input:			
/// Return：       	
/// w ##class(DHCMA.CPW.IO.FromMRData).GetZRRSByLocDate("2020-07-01","2020-07-31",127)
ClassMethod GetZRRSByLocDate(aSttDate As %String, aEndDate As %String, aLocID As %String) As %String
{
	New (aSttDate,aEndDate,aLocID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aLocID="") "-1"
	
	Set aSttDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:+aSttDate>+aEndDate "-2"
	
	For xDate=aSttDate:1:aEndDate {
		Set xMRID=0
		For {
			Set xMRID=$o(^MRIPdaily("MRIPloc",+aLocID,"MRIPdate",xDate,xMRID))
			Quit:xMRID=""
			
			Set zrrs=$p(^MRIPdaily(xMRID),"^",9)  //转入人数
			Set return=return+zrrs
		}	
	}
	
	Quit return
}

/// Creator：      	yankai
/// CreatDate：    	2022-12-14
/// Description： 	获取某科某段时间内转出人数
/// Table/Global：  ^MRIPdaily("MRIPloc",{MRIP_loc_dr},"MRIPdate",{MRIP_date},{MRIP_rowid})
/// Input:			
/// Return：       	
/// w ##class(DHCMA.CPW.IO.FromMRData).GetZCRSByLocDate("2020-07-01","2020-07-31",127)
ClassMethod GetZCRSByLocDate(aSttDate As %String, aEndDate As %String, aLocID As %String) As %String
{
	New (aSttDate,aEndDate,aLocID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aLocID="") "-1"
	
	Set aSttDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:+aSttDate>+aEndDate "-2"
	
	For xDate=aSttDate:1:aEndDate {
		Set xMRID=0
		For {
			Set xMRID=$o(^MRIPdaily("MRIPloc",+aLocID,"MRIPdate",xDate,xMRID))
			Quit:xMRID=""
			
			Set zcrs=$p(^MRIPdaily(xMRID),"^",12)  //转出人数
			Set return=return+zcrs
		}	
	}
	
	Quit return
}

}
