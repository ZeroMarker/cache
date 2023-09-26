/// 名称: DHCHAI.DI.DHS.SyncNisInfo
/// 描述: 同步东华护理数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncNisInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-05
/// Description:  根据日期同步东华患者护理信息
/// Input：       aEpisodeID ：就诊号
///               aDateFrom : 开始日期
/// 			  aDateTo ：结束日期
/// Return：      处理同步护理的数量
/// w ##class(DHCHAI.DI.DHS.SyncNisInfo).SyncNisByDateAdm()
ClassMethod SyncNisByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="SyncNisByDateAdmErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="NIS" return  //护理管理
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=aDateFrom-3   //同步日期向前3天，用于同步补录生命体征的情况
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromNisSrv:GetThreeList")
  	Set sc=rs.Execute(EpisodeID,aDateFrom,aDateTo,"","")   // Item1:体温代码   Item11:腹泻代码
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                      // 就诊号（DHCHAI.DP.PAAdm.ID）
	    Do rowData.SetAt(rs.Data("OBsID"),"OBsID")                   // 记录ID
		Do rowData.SetAt(rs.Data("OBItemCode"),"ItemCode")           // 护理项目代码
		Do rowData.SetAt(rs.Data("OBItemDesc"),"ItemDesc")           // 护理项目描述
		Do rowData.SetAt(rs.Data("OBItemValue"),"ItemValue")         // 项目值
		Do rowData.SetAt(rs.Data("OBEntryDate"),"EntryDate")         // 录入日期
		Do rowData.SetAt(rs.Data("OBEntryTime"),"EntryTime")         // 录入时间
		Do rowData.SetAt(rs.Data("OBEntryUserID"),"EntryUserID")     // 录入人ID
		Do rowData.SetAt(rs.Data("OBEntryUserCode"),"EntryUserCode") // 录入人代码
		Do rowData.SetAt(rs.Data("OBEntryUserName"),"EntryUserName") // 录入人姓名
		
		Set IsActive=1
		Set:rs.Data("OBItemValue")="" IsActive=0
		Continue:rs.Data("OBItemValue")=""  //和表设计逻辑一致，值不可以为空！
		Do rowData.SetAt(IsActive,"IsActive")  //是否有效
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("ItemDesc")
		Set objItemMap=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(aSCode,ItemDesc)
		Set BTItemCode=""  // 标准项目代码
		If $IsObject(objItemMap) {
			Continue:objItemMap.BTIsActive'=1
			//同步腹泻数据过程中，过滤一天腹泻次数超过30次的记录
			If $IsObject(objItemMap.BTMapItemDr) {
				Set BTItemCode = objItemMap.BTMapItemDr.BTItemCode  
			}
			Continue:((BTItemCode=5)&&(+rs.Data("OBItemValue")>30))
		}
		
		//保存护理记录
		Set MRObsDr=..SaveObsInfo(rowData,aSCode)
		Continue:(+MRObsDr)<1
		
		//计数
		Set Count=Count+1
    }
    
	Set return=Count
	Quit return
	
SyncNisByDateAdmErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveObsInfo(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveObsInfoErr"
	
	Set EpisodeID     = rd.GetAt("EpisodeID")
	Set EpisodeDr     = rd.GetAt("EpisodeDr")
	Set XCode         = rd.GetAt("OBsID")
	Set ItemCode      = rd.GetAt("ItemCode")
	Set ItemDesc      = rd.GetAt("ItemDesc")
	Set ItemValue     = rd.GetAt("ItemValue")
	Set EntryDate     = rd.GetAt("EntryDate")
	Set EntryTime     = rd.GetAt("EntryTime")
	Set EntryUserID   = rd.GetAt("EntryUserID")
	Set EntryUserCode = rd.GetAt("EntryUserCode")
	Set EntryUserName = rd.GetAt("EntryUserName")
	Set IsActive      = rd.GetAt("IsActive")
	Quit:(XCode="")||(EpisodeDr="")||(ItemDesc="") return
	
	Set MRObsDr=""
	Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjByXCode(aSCode,XCode)
	If $isobject(objMRObs){
		Set MRObsDr=objMRObs.%Id()
	}
	
	Set InputStr = MRObsDr
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_ItemCode
	Set InputStr = InputStr_"^"_ItemDesc
	Set InputStr = InputStr_"^"_ItemValue
	Set InputStr = InputStr_"^"_EntryDate
	Set InputStr = InputStr_"^"_EntryTime
	Set InputStr = InputStr_"^"_EntryUserID_"|"_EntryUserCode_"|"_EntryUserName
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_IsActive
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_$p($h,",",2)
	
	Set MRObsDr=##class(DHCHAI.DP.MRObservations).Update(InputStr,"^")
	If (+MRObsDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.MRObservations"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+MRObsDr)<1 return
	Set return=MRObsDr
	
	//保存护理项目（重复记录不再处理）
	If ItemDesc'="" {
		//保存护理项目对照
		Set objItemMap=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(aSCode,ItemDesc)
		If '$isobject(objItemMap){
			Set MapItemDr=""
			Set objMapItem=##class(DHCHAI.DP.MROBSItem).GetObjByCodeDesc("",ItemDesc)
			Set:$IsObject(objMapItem) MapItemDr=objMapItem.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_ItemDesc		// 护理项目名称
			Set InputStr = InputStr_"^"_MapItemDr		// 标准项目名称
			Set InputStr = InputStr_"^"_""				// 标准备注
			Set InputStr = InputStr_"^"_aSCode			// 子系统代码
			Set InputStr = InputStr_"^"_1				// 有效标志
			Set InputStr = InputStr_"^"_""				// 处置日期
			Set InputStr = InputStr_"^"_""				// 处置时间
			Set InputStr = InputStr_"^"_""				// 处置人
			Set ItemMapDr=##class(DHCHAI.DP.MROBSItemMap).Update(InputStr,"^")
			If (+ItemMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.MROBSItemMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	Quit return
	
SaveObsInfoErr
	Set return="-999^"_$ZError
	Quit return
}

}
