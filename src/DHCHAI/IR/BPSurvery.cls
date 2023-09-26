/// 名称: DHCHAI.IR.BPSurvery
/// 描述: 血透个案登记表
/// 编写者: zhoubo
/// 编写日期: 2022-10-13
Class DHCHAI.IR.BPSurvery Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCHAI.IR.BPSurvLog [ Cardinality = children, Inverse = Parref ];

/// 模板类型
Property BPRegTypeDr As DHCHAI.IR.ComTemplateDef [ Required ];

/// 血透登记ID
Property BPRegDr As DHCHAI.DP.BPRegister [ Required ];

/// 就诊记录
Property BPEpisodeDr As DHCHAI.DP.PAAdm;

/// 调查编号ID
Property BPSurvNumber As %String(TRUNCATE = 1) [ Required ];

/// 调查日期
Property BPRegDate As %Date;

/// 调查时间
Property BPRegTime As %Time;

/// 调查科室
Property BPRegLocDr As DHCHAI.BT.Location;

/// 调查人
Property BPRegUserDr As DHCHAI.BT.SysUser;

/// 状态 InfReportStatus
Property BPStatusDr As DHCHAI.BT.Dictionary;

/// 病人编号-血透登记ID
Property BPPatNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查编号 + 血透登记
Index IndexSurBPRegDr On (BPSurvNumber, BPRegDr);

/// 模板类型
Index IndexTypeDr On BPRegTypeDr;

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  根据ID取血透个案登记表
/// Table：       DHCHAI.IR.BPSurvery
/// Input：       aId : DHCHAI.IR.BPSurvery.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.BPSurvery).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.BPSurvery
{
	New (aId)
	Quit:'##class(DHCHAI.IR.BPSurvery).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.BPSurvery).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  更新血透个案登记表
/// Table：       DHCHAI.IR.BPSurvery
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.BPSurvery).Update("1^3^1||3^与上次间隔时间^T^^^1年^^^9")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set ID           = $p(aInputStr,aSeparete,1)
	Set BPRegTypeDr  = $p(aInputStr,aSeparete,2)
	Set BPRegDr	     = $p(aInputStr,aSeparete,3)
	Set HISEpisodeDr = $p(aInputStr,aSeparete,4)
	Set BPSurvNumber = $p(aInputStr,aSeparete,5)
	Set BPRegDate    = $p(aInputStr,aSeparete,6)
	Set BPRegTime    = $p(aInputStr,aSeparete,7)
	Set BPRegLocDr   = $p(aInputStr,aSeparete,8)
	Set BPRegUserDr  = $p(aInputStr,aSeparete,9)
	Set BPStatusDr   = $p(aInputStr,aSeparete,10)
	Set BPPatNo      = $p(aInputStr,aSeparete,11)
	
	Quit:(BPRegTypeDr="")||(BPRegDr="")||(BPSurvNumber="") return
	Set objType = ##class(DHCHAI.IR.ComTemplateDef).GetObjById(BPRegTypeDr)
	Quit:'$IsObject(objType) return
	Set objBPReg  = ##class(DHCHAI.DP.BPRegister).GetObjById(BPRegDr)
	Quit:'$IsObject(objBPReg) return
	Set:BPRegDate'="" BPRegDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(BPRegDate)	
	Set:BPRegTime[":" BPRegTime=$zth(BPRegTime,1)
	Set:BPRegDate="" BPRegDate=+$h
	Set:BPRegTime="" BPRegTime=$p($h,",",2)
	Set EpisodeDr = ##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(HISEpisodeDr)
	Set objAdm    = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Set objUser   = ##class(DHCHAI.BT.SysUser).GetObjById(BPRegUserDr)
	Set objLoc    = ##class(DHCHAI.BT.Location).GetObjById(BPRegLocDr)
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjById(BPStatusDr)
	
	Set ID =$o(^MA.HAI.IR.BPSurveryI("IndexSurBPRegDr"," "_BPSurvNumber,BPRegDr,0)) 
	If (ID="") {
		Set obj=##class(DHCHAI.IR.BPSurvery).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.BPSurvery).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BPRegTypeDr  = objType
	Set obj.BPRegDr	     = objBPReg	  
	Set obj.BPEpisodeDr  = objAdm  
	Set obj.BPSurvNumber = BPSurvNumber  
	Set obj.BPRegDate    = BPRegDate
	Set obj.BPRegTime    = BPRegTime 
	Set obj.BPRegLocDr   = objLoc
	Set obj.BPRegUserDr  = objUser 
	Set obj.BPStatusDr   = objStatus 
	Set obj.BPPatNo      = BPPatNo
	
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
/// CreatDate：   2022-10-14
/// Description:  删除血透个案登记表
/// Table：       DHCHAI.IR.BPSurvery
/// Input：       aId : DHCHAI.IR.BPSurvery.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.BPSurvery).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.BPSurvery).%DeleteId(aId)
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
<Data name="BPSurveryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPRegTypeDr</Value>
</Value>
<Value name="3">
<Value>BPRegDr</Value>
</Value>
<Value name="4">
<Value>BPEpisodeDr</Value>
</Value>
<Value name="5">
<Value>BPSurvNumber</Value>
</Value>
<Value name="6">
<Value>BPRegDate</Value>
</Value>
<Value name="7">
<Value>BPRegTime</Value>
</Value>
<Value name="8">
<Value>BPRegLocDr</Value>
</Value>
<Value name="9">
<Value>BPRegUserDr</Value>
</Value>
<Value name="10">
<Value>BPStatusDr</Value>
</Value>
<Value name="11">
<Value>BPPatNo</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.BPSurveryD</DataLocation>
<DefaultData>BPSurveryDefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.BPSurveryD</IdLocation>
<IndexLocation>^MA.HAI.IR.BPSurveryI</IndexLocation>
<StreamLocation>^MA.HAI.IR.BPSurveryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
