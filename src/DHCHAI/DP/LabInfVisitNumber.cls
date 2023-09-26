/// 名称: DHCHAI.DP.LabInfVisitNumber
/// 描述: 院感检验标本记录表（检验号为唯一索引）
/// 编写者：zhufei
/// 编写日期: 2020-10-28
Class DHCHAI.DP.LabInfVisitNumber Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 条码号
Property LabEpisodeNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 申请院感检验项目
Property LabInfTestSetDr As DHCHAI.DP.LabInfTestSet;

/// 检验外部码（检验医嘱/检验组套）
Property LabInfTSExtCodeDr As DHCHAI.DP.LabInfTestSetExt;

/// 标本
Property LabSpecimen As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 业务类型（1环境卫生学、2职业暴露）
Property LabType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记状态(1登记，2初审，3审核，4复查，5取消审核，6作废，A审核)
Property LabStatus As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 申请科室|送检科室
Property LabLocDr As DHCHAI.BT.Location;

/// 申请日期
Property LabApplyDate As %Date;

/// 申请时间
Property LabApplyTime As %Time;

/// 申请者（ID|Code|Desc）
Property LabApplyUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 采集日期
Property LabCollDate As %Date;

/// 采集时间
Property LabCollTime As %Time;

/// 采集者（ID|Code|Desc）
Property LabCollUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接收日期
Property LabRecDate As %Date;

/// 接收时间
Property LabRecTime As %Time;

/// 接收者（ID|Code|Desc）
Property LabRecUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property LabSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property LabXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property LabIsActive As %Boolean [ Required ];

/// 更新日期
Property LabUpdateDate As %Date [ Required ];

/// 更新时间
Property LabUpdateTime As %Time [ Required ];

/// 子系统代码+记录索引码索引
Index IndexSCodeXCode On (LabSCode As Exact, LabXCode As Exact);

/// 检验条码索引
Index IndexLabEpisodeNo On LabEpisodeNo [ Unique ];

/// 业务类型+检验条码索引
Index IndexLabTypeNo On (LabType As Exact, LabEpisodeNo As Exact);

/// 接收日期时间索引
Index IndexRecDateTime On (LabSCode, LabRecDate, LabRecTime);

/// 标本 索引
Index IndexSpecimen On LabSpecimen;

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取院感检验标本记录表信息
/// Table：       DHCHAI.DP.LabInfVisitNumber
/// Input：       aId : DHCHAI.DP.LabInfVisitNumber.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfVisitNumber).GetObjById(62)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.LabInfVisitNumber
{
	New (aId)
	Quit:'##class(DHCHAI.DP.LabInfVisitNumber).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.LabInfVisitNumber).%OpenId(aId)
	
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2021-08-31
/// 根据条码号获取标本信息
/// w ##class(DHCHAI.DP.LabInfVisitNumber).GetObjByCode("00000601")
ClassMethod GetObjByCode(aBarCode As %String) As %String
{
	New (aBarCode)
	Set return=""
	Quit:(aBarCode="") return
	
	// 检验条码索引 唯一性
	Set LabVID = $o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_aBarCode,0))
	Set:LabVID="" LabVID=$o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_aBarCode,0))
	
	Set objLab = ##class(DHCHAI.DP.LabInfVisitNumber).GetObjById(LabVID)
	Quit:('$IsObject(objLab)) return
	
	Set return=objLab.%Id()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-09-02
/// 保存职业暴露检验标本
/// w ##class(DHCHAI.DP.LabInfVisitNumber).SaveOCCLabBarcode("6")
ClassMethod SaveOCCLabBarcode(aReportID As %String) As %String
{
	New (aReportID)
	Set return = ""
	Quit:aReportID="" return
	
	Set objRep = ##Class(DHCHAI.IR.OccExpReg).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.OEExpLocDr) return
	Set LabLocDr     = objRep.OEExpLocDr.%Id()
	Set OEName       = objRep.OEName     // 暴露者
	Set OEExpDate    = objRep.OEExpDate  // 暴露日期
	Set OEExpTime    = objRep.OEExpTime
	Set LabApplyDate = ""
	Set LabApplyTime = ""
	//申请者（ID|Code|Desc）
	Set ApplyUserID  = objRep.OERegUserDr.%Id()
	Set BTXCode      = objRep.OERegUserDr.BTXCode  // 记录索引码（HIS中用户ID）
	Set:BTXCode'="" BTXCode=$p(BTXCode,"||",2)
	Set AUserCode    = objRep.OERegUserDr.BTCode
	Set AUserDesc    = objRep.OERegUserDr.BTDesc
	Set LabApplyUser = BTXCode_"|"_AUserCode_"|"_AUserDesc
	Set LabCollDate  = ""
	Set LabCollTime  = ""
	Set LabCollUser  = ""
	Set LabRecDate   = ""
	Set LabRecTime   = ""
	Set LabRecUser   = ""
	Set LabSCode     = "LIS01"
	Set LabXCode     = ""
	Set LabIsActive  = "1"
	
	Set objRegType = objRep.OERegTypeDr
	Quit:'$IsObject(objRegType) return
	Set TypeID = objRegType.%Id()
	Set xSubID=0	
	For {
		Set xSubID=$o(^DHCHAI.IR.OccExpTypeD(TypeID,"LAB",xSubID))
		Quit:xSubID=""
		
		Set LabID=TypeID_"||"_xSubID
		Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objLAB)
		
	    Set IsActive  = objLAB.BTIsActive
		Continue:(IsActive'=1)
	    Set Desc = objLAB.BTDesc
	    Set SpecDesc = Desc_"("_OEName_")"           // 标本
	    Set EHExtItemDr="",LabInfTSExtCodeDr=""
	    If $IsObject(objLAB.BTExtItemDr) {	
			Set EHExtItemDr = objLAB.BTExtItemDr.%Id()  
			Set LabInfTSExtCodeDr = $o(^DHCHAI.DP.LabInfTestSetExtI("IdxofParRef",EHExtItemDr,""),-1)
	    }
	    Set LabType      = 2  //（1环境卫生学、2职业暴露）
		Set LabStatus    = 1  //登记状态(1登记，2初审，3审核，4复查，5取消审核，6作废，A审核)
		Set BTDays       = +objLAB.BTDays
		Set LabApplyDate = OEExpDate+BTDays  // (暴露日期+对应天数)
		Set LabApplyTime = OEExpTime
		// 职业暴露条码规则：报告ID+血清学检查计划（SubID）
		Set SpenBarCode=##class(DHCHAI.IR.OccExpReg).GetSpenBarCode(aReportID,xSubID)
		
		Set InputStr = "^O"_SpenBarCode_"^"_EHExtItemDr_"^"_LabInfTSExtCodeDr_"^"_SpecDesc_"^"_LabType_"^"_LabStatus_"^"_LabLocDr_"^"_LabApplyDate_"^"_LabApplyTime_"^"_LabApplyUser
		Set InputStr = InputStr_"^"_LabCollDate_"^"_LabCollTime_"^"_LabCollUser_"^"_LabRecDate_"^"_LabRecTime_"^"_LabRecUser_"^"_LabSCode_"^"_LabXCode_"^"_LabIsActive_"^^"
		Set return = ..Update(InputStr,"^")
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-08-31
/// 保存环境卫生学监测检验标本
/// w ##class(DHCHAI.DP.LabInfVisitNumber).SaveLabBarcode("6")
ClassMethod SaveLabBarcode(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set SpecDesc=""           //标本(监测对象)
	Set EHItemObj     = objRep.EHItemObjDr
	//Quit:'$IsObject(EHItemObj) return
	Set EHItemObjTxt  = objRep.EHItemObjTxt
	Set:$IsObject(EHItemObj) SpecDesc      = EHItemObj.EHObjDesc
	Set:EHItemObjTxt'="" SpecDesc = SpecDesc_"("_EHItemObjTxt_")"
	
	Set EHItemDr      = objRep.EHItemDr
	Quit:'$IsObject(EHItemDr) return
	Set EHExtItemobj  = EHItemDr.EHExtItemDr  //检验外部项目
	Set LabInfTSExtCodeDr="",EHExtItemDr=""
	If ($IsObject(EHExtItemobj)){
		Set EHExtItemDr = EHExtItemobj.%Id()
		Set LabInfTSExtCodeDr = $o(^DHCHAI.DP.LabInfTestSetExtI("IdxofParRef",EHExtItemDr,""),-1)
	}
	Set LabType      = 1  //（1环境卫生学、2职业暴露）
	Set LabStatus    = 1  //登记状态(1登记，2初审，3审核，4复查，5取消审核，6作废，A审核)
	Set LabLocDr     = objRep.EHMonitorLocDr.%Id()
	Set LabApplyDate = objRep.EHApplyDate
	Set LabApplyTime = objRep.EHApplyTime
	//申请者（ID|Code|Desc）
	Set ApplyUserID  = objRep.EHApplyUserDr.%Id()
	Set BTXCode      = objRep.EHApplyUserDr.BTXCode  // 记录索引码（HIS中用户ID）
	Set:BTXCode'="" BTXCode=$p(BTXCode,"||",2)
	Set AUserCode    = objRep.EHApplyUserDr.BTCode
	Set AUserDesc    = objRep.EHApplyUserDr.BTDesc
	Set LabApplyUser = BTXCode_"|"_AUserCode_"|"_AUserDesc
	
	Set LabCollDate  = objRep.EHCollDate
	Set LabCollTime  = objRep.EHCollTime
	Set LabCollUser  = ""
	If ($IsObject(objRep.EHCollUserDr)){
		Set BTXCode     = objRep.EHCollUserDr.BTXCode  // 记录索引码（HIS中用户ID）
		Set:BTXCode'="" BTXCode=$p(BTXCode,"||",2)
		Set AUserCode   = objRep.EHCollUserDr.BTCode
		Set AUserDesc   = objRep.EHCollUserDr.BTDesc
		Set LabCollUser = BTXCode_"|"_AUserCode_"|"_AUserDesc
	}
	
	Set LabRecDate   = objRep.EHRecDate
	Set LabRecTime   = objRep.EHRecTime
	Set LabRecUser   = ""
	If ($IsObject(objRep.EHRecUserDr)){
		Set BTXCode    = objRep.EHRecUserDr.BTXCode  // 记录索引码（HIS中用户ID）
		Set:BTXCode'="" BTXCode=$p(BTXCode,"||",2)
		Set AUserCode  = objRep.EHRecUserDr.BTCode
		Set AUserDesc  = objRep.EHRecUserDr.BTDesc
		Set LabRecUser = BTXCode_"|"_AUserCode_"|"_AUserDesc
	}
	Set LabSCode     = "LIS01"
	Set LabXCode     = ""
	Set LabIsActive  = "1"
	
	For indBar=1:1:objRep.EHSpecimenNum {
		Set SpenBarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aReportID,indBar)
		
		Set InputStr = "^E"_SpenBarCode_"^"_EHExtItemDr_"^"_LabInfTSExtCodeDr_"^"_SpecDesc_"^"_LabType_"^"_LabStatus_"^"_LabLocDr_"^"_LabApplyDate_"^"_LabApplyTime_"^"_LabApplyUser
		Set InputStr = InputStr_"^"_LabCollDate_"^"_LabCollTime_"^"_LabCollUser_"^"_LabRecDate_"^"_LabRecTime_"^"_LabRecUser_"^"_LabSCode_"^"_LabXCode_"^"_LabIsActive_"^^"
		Set return = ..Update(InputStr,"^")
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  更新标本记录信息
/// Table：       DHCHAI.DP.LabInfVisitNumber
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitNumber).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			   = $p(aInputStr,aSeparete,1)
	Set EpisodeNo      = $p(aInputStr,aSeparete,2)
	Set InfTestSetDr   = $p(aInputStr,aSeparete,3)
	Set InfTSExtCodeDr = $p(aInputStr,aSeparete,4)
	Set LabSpecimen	   = $p(aInputStr,aSeparete,5)
	Set LabType		   = $p(aInputStr,aSeparete,6)
	Set LabStatus	   = $p(aInputStr,aSeparete,7)
	Set LabLocDr	   = $p(aInputStr,aSeparete,8)
	Set LabApplyDate   = $p(aInputStr,aSeparete,9)
	Set LabApplyTime   = $p(aInputStr,aSeparete,10)
	Set LabApplyUser   = $p(aInputStr,aSeparete,11)
	Set LabCollDate	   = $p(aInputStr,aSeparete,12)
	Set LabCollTime	   = $p(aInputStr,aSeparete,13)
	Set LabCollUser	   = $p(aInputStr,aSeparete,14)
	Set LabRecDate	   = $p(aInputStr,aSeparete,15)
	Set LabRecTime	   = $p(aInputStr,aSeparete,16)
	Set LabRecUser     = $p(aInputStr,aSeparete,17)
	Set LabSCode       = $p(aInputStr,aSeparete,18)
	Set LabXCode       = $p(aInputStr,aSeparete,19)
	Set LabIsActive    = $p(aInputStr,aSeparete,20)
	Set UpdateDate     = $p(aInputStr,aSeparete,21)
	Set UpdateTime     = $p(aInputStr,aSeparete,22)									   
	Quit:(EpisodeNo="")||(LabSpecimen="")||(LabType="") return
	
	Set:LabApplyDate'="" LabApplyDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabApplyDate)
	Set:LabApplyTime[":" LabApplyTime = $zth(LabApplyTime,1)
	Set:LabApplyDate="" LabApplyDate=+$h
	Set:LabApplyTime="" LabApplyTime=$p($h,",",2)
	
	Set:LabCollDate'="" LabCollDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabCollDate)
	Set:LabCollTime[":" LabCollTime = $zth(LabCollTime,1)
	Set:LabCollDate="" LabCollDate=+$h
	Set:LabCollTime="" LabCollTime=$p($h,",",2)
	
	Set:LabRecDate'="" LabRecDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabRecDate)
	Set:LabRecTime[":" LabRecTime = $zth(LabRecTime,1)
	Set:LabRecDate="" LabRecDate=+$h
	Set:LabRecTime="" LabRecTime=$p($h,",",2)
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set objTestSet = ##class(DHCHAI.DP.LabInfTestSet).GetObjById(InfTestSetDr)
	Set objTSExt   = ##class(DHCHAI.DP.LabInfTestSetExt).GetObjById(InfTestSetDr_"||"_InfTSExtCodeDr)
	Set objLabLoc  = ##class(DHCHAI.BT.Location).GetObjById(LabLocDr)
	
	// 检验条码索引 唯一性
	Set ID =$o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_EpisodeNo,0)) 
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabInfVisitNumber).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabInfVisitNumber).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabEpisodeNo      = EpisodeNo
	Set obj.LabInfTestSetDr   = objTestSet
	Set obj.LabInfTSExtCodeDr = objTSExt
	Set obj.LabSpecimen	      = LabSpecimen
	Set obj.LabType	          = LabType
	Set obj.LabStatus	      = LabStatus
	Set obj.LabLocDr	      = objLabLoc
	Set obj.LabApplyDate	  = LabApplyDate
	Set obj.LabApplyTime	  = LabApplyTime
	Set obj.LabApplyUser	  = LabApplyUser
	Set obj.LabCollDate	      = LabCollDate
	Set obj.LabCollTime		  = LabCollTime
	Set obj.LabCollUser 	  = LabCollUser
	Set obj.LabRecDate 	      = LabRecDate
	Set obj.LabRecTime 	      = LabRecTime
	Set obj.LabRecUser        = LabRecUser
	Set obj.LabSCode          = LabSCode
	Set obj.LabXCode          = LabXCode						
	Set obj.LabIsActive       = LabIsActive
	Set obj.LabUpdateDate     = UpdateDate
	Set obj.LabUpdateTime     = UpdateTime
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  删除标本记录信息
/// Table：       DHCHAI.DP.LabInfVisitNumber
/// Input：       aId : DHCHAI.DP.LabInfVisitNumber.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitNumber).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.LabInfVisitNumber).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="LabInfVisitNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabEpisodeNo</Value>
</Value>
<Value name="3">
<Value>LabInfTestSetDr</Value>
</Value>
<Value name="4">
<Value>LabInfTSExtCodeDr</Value>
</Value>
<Value name="5">
<Value>LabSpecimen</Value>
</Value>
<Value name="6">
<Value>LabType</Value>
</Value>
<Value name="7">
<Value>LabStatus</Value>
</Value>
<Value name="8">
<Value>LabLocDr</Value>
</Value>
<Value name="9">
<Value>LabApplyDate</Value>
</Value>
<Value name="10">
<Value>LabApplyTime</Value>
</Value>
<Value name="11">
<Value>LabApplyUser</Value>
</Value>
<Value name="12">
<Value>LabCollDate</Value>
</Value>
<Value name="13">
<Value>LabCollTime</Value>
</Value>
<Value name="14">
<Value>LabCollUser</Value>
</Value>
<Value name="15">
<Value>LabRecDate</Value>
</Value>
<Value name="16">
<Value>LabRecTime</Value>
</Value>
<Value name="17">
<Value>LabRecUser</Value>
</Value>
<Value name="18">
<Value>LabSCode</Value>
</Value>
<Value name="19">
<Value>LabXCode</Value>
</Value>
<Value name="20">
<Value>LabIsActive</Value>
</Value>
<Value name="21">
<Value>LabUpdateDate</Value>
</Value>
<Value name="22">
<Value>LabUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabInfVisitNumberD</DataLocation>
<DefaultData>LabInfVisitNumberDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabInfVisitNumberD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabInfVisitNumberI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabInfVisitNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
