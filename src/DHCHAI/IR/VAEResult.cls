/// 名称: DHCHAI.IR.VAEResult
/// 描述: VAE监测结果
/// 编写者: zhoubo
/// 编写日期: 2022-03-15
Class DHCHAI.IR.VAEResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property EpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// VAE监测项目
Property VAEMonitItemDr As DHCHAI.IR.VAEMonitItem [ Required ];

/// VAE日期
Property VAEDate As %Date [ Required ];

/// 触发项目 多值#分割--DHCHAI.IR.VAESubItem
Property VAEItemIDs As %String(MAXLEN = 100000, TRUNCATE = 1) [ Required ];

/// 处置状态 1：确诊 2：排除
Property ActStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 院感科确诊VAE日期
Property MonitVAEDate As %Date;

/// 院感科确诊VAE类型
Property VAEType As %String(MAXLEN = 200, TRUNCATE = 1);

/// 排除原因
Property ExclReason As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 操作日期
Property VAEActDate As %Date;

/// 操作时间
Property VAEActTime As %Time;

/// 操作人
Property VAEActUserDr As DHCHAI.BT.SysUser;

/// 更新日期
Property VAEUpdateDate As %Date;

/// 更新时间
Property VAEUpdateTime As %Time;

/// 是否有效
Property VAEIsActive As %Boolean;

/// 监测项目索引
Index IndexMonitItemDr On VAEMonitItemDr As Exact;

/// VAE日期索引
Index IndexVAEDate On VAEDate As Exact;

/// VAE确诊日期索引
Index IndexMonitVAEDate On MonitVAEDate As Exact;

/// 就诊+监测项目
Index IndexEpiMonitItem On (EpisodeDr, VAEMonitItemDr);

/// 就诊+VAE日期+监测项目
Index IndexEpiDateItem On (EpisodeDr, VAEDate, VAEMonitItemDr) [ Unique ];

/// Creator：     zhoubo
/// CreatDate：   2022-03-15
/// Description:  根据ID取VAE监测结果
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aId : DHCHAI.IR.VAEResult.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.VAEResult).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.VAEResult
{
	New (aId)
	Quit:'##class(DHCHAI.IR.VAEResult).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.VAEResult).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-29
/// Description:  根据就诊号获取患者最近的VAE筛查记录ID 
/// Table：       DHCHAI.IR.VAEResult
/// aEpisodeID：  就诊号
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEResult).GetVAERstID("17")
ClassMethod GetVAERstID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID),-1)
	   	Quit:(xItemID="")||(return'="")
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID),-1)
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set return=xRstID
			Quit
	   	}
   	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-29
/// Description:  更新VAE监测结果-确诊、排除
/// Table：       DHCHAI.IR.VAEResult
/// aRstID：      结果表ID
/// aActStatus    1：确诊 2：排除
/// aVAEDate      VAE日期
/// aVAEType      VAE类型
/// aOperUser     操作人
/// aExclReason   排除原因
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEResult).UpdateVAERstOper("")
ClassMethod UpdateVAERstOper(aRstID As %String, aActStatus As %String, aVAEDate As %String, aVAEType As %String, aOperUser As %String, aExclReason As %String) As %String
{
	New (aRstID,aActStatus,aVAEDate,aVAEType,aOperUser,aExclReason)
	Set return=0
	Quit:(aRstID="")||(aActStatus="") return
	
	Set aVAEDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aVAEDate)
	
	Set VAEActDate=+$h
	Set VAEActTime=$p($h,",",2)
	Set ObjActUser=##class(DHCHAI.BT.SysUser).GetObjById(aOperUser)
	
	Set obj=##class(DHCHAI.IR.VAEResult).%OpenId(aRstID)
	Quit:'$IsObject(obj) return
	
	Set obj.MonitVAEDate = aVAEDate
	Set obj.VAEType      = aVAEType
	Set obj.VAEActDate   = VAEActDate
	Set obj.VAEActTime   = VAEActTime
	Set obj.VAEActUserDr = ObjActUser
	Set obj.ActStatus    = aActStatus
	Set obj.ExclReason   = aExclReason
		
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        // 检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-15
/// Description:  更新VAE监测结果
/// Table：       DHCHAI.IR.VAEResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEResult).Update("^1^1^2022-01-01^1#2^^^^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			   = $p(aInputStr,aSeparete,1)
	Set EpisodeDr      = $p(aInputStr,aSeparete,2)
	Set VAEMonitItemDr = $p(aInputStr,aSeparete,3)
	Set VAEDate        = $p(aInputStr,aSeparete,4)
	Set VAEItemIDs     = $p(aInputStr,aSeparete,5)
	Set MonitVAEDate   = $p(aInputStr,aSeparete,6)
	Set VAEType        = $p(aInputStr,aSeparete,7)
	Set VAEActDate     = $p(aInputStr,aSeparete,8)
	Set VAEActTime     = $p(aInputStr,aSeparete,9)
	Set VAEActUserDr   = $p(aInputStr,aSeparete,10)
	Set VAEUpdateDate  = $p(aInputStr,aSeparete,11)
	Set VAEUpdateTime  = $p(aInputStr,aSeparete,12)
	Set VAEIsActive    = +$p(aInputStr,aSeparete,13)
	Set ActStatus      = $p(aInputStr,aSeparete,14)
	Set ExclReason     = $p(aInputStr,aSeparete,15) 
	
	Quit:(EpisodeDr="")||(VAEMonitItemDr="")||(VAEDate="")||(VAEItemIDs="") return
	
	Set:VAEDate'="" VAEDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VAEDate)
	Set:MonitVAEDate'="" MonitVAEDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(MonitVAEDate)
	
	Set:VAEUpdateDate'="" VAEUpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VAEUpdateDate)
	Set:VAEUpdateDate="" VAEUpdateDate=+$h
	Set:VAEUpdateTime[":" VAEUpdateTime = $zth(VAEUpdateTime,1)
	Set:VAEUpdateTime="" VAEUpdateTime=$p($h,",",2)
	
	Set:VAEActDate'="" VAEActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VAEActDate)
	Set:VAEActTime[":" VAEActTime = $zth(VAEActTime,1)
	Set ObjActUser=##class(DHCHAI.BT.SysUser).GetObjById(VAEActUserDr)
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set ObjMonit=##class(DHCHAI.BT.SysUser).GetObjById(VAEMonitItemDr)
	Quit:'$IsObject(ObjMonit) return
	// 就诊+VAE日期+监测项目   唯一索引
	Set:ID="" ID=$o(^DHCHAI.IR.VAEResultI("IndexEpiDateItem",EpisodeDr,VAEDate,VAEMonitItemDr,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.VAEResult).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.VAEResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeDr      = objEpisode
	Set obj.VAEMonitItemDr = ObjMonit
	Set obj.VAEDate        = VAEDate
	Set obj.VAEItemIDs     = VAEItemIDs
	Set obj.VAEUpdateDate  = VAEUpdateDate
	Set obj.VAEUpdateTime  = VAEUpdateTime
	Set obj.VAEIsActive    = VAEIsActive
	If (ActStatus'=""){
		Set obj.MonitVAEDate = MonitVAEDate
		Set obj.VAEType      = VAEType
		Set obj.VAEActDate   = VAEActDate
		Set obj.VAEActTime   = VAEActTime
		Set obj.VAEActUserDr = ObjActUser
		Set obj.ActStatus    = ActStatus
		Set obj.ExclReason   = ExclReason
	}
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        // 检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-15
/// Description:  删除VAE监测结果
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aId : DHCHAI.IR.VAEResult.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEResult).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.VAEResult).%DeleteId(aId)
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
<Data name="VAEResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeDr</Value>
</Value>
<Value name="3">
<Value>VAEMonitItemDr</Value>
</Value>
<Value name="4">
<Value>VAEDate</Value>
</Value>
<Value name="5">
<Value>VAEItemIDs</Value>
</Value>
<Value name="6">
<Value>MonitVAEDate</Value>
</Value>
<Value name="7">
<Value>VAEType</Value>
</Value>
<Value name="8">
<Value>VAEActDate</Value>
</Value>
<Value name="9">
<Value>VAEActTime</Value>
</Value>
<Value name="10">
<Value>VAEActUserDr</Value>
</Value>
<Value name="11">
<Value>VAEUpdateDate</Value>
</Value>
<Value name="12">
<Value>VAEUpdateTime</Value>
</Value>
<Value name="13">
<Value>VAEIsActive</Value>
</Value>
<Value name="14">
<Value>ActStatus</Value>
</Value>
<Value name="15">
<Value>ExclReason</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.VAEResultD</DataLocation>
<DefaultData>VAEResultDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.VAEResultD</IdLocation>
<IndexLocation>^DHCHAI.IR.VAEResultI</IndexLocation>
<StreamLocation>^DHCHAI.IR.VAEResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
