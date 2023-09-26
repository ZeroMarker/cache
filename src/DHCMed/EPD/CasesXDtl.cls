/// 名称: DHCMed.EPD.CasesXDtl
/// 描述: 传染病例筛查明细
/// 编写者：zhufei
/// 编写日期: 2018-11-28
Class DHCMed.EPD.CasesXDtl Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.EPD.CasesX [ Cardinality = parent, Inverse = ChildDtl ];

/// 疑似筛查条件
Property CXDScreeningDr As DHCMed.EPD.SuspScreening;

/// 筛查内容
Property CXDContent As %String(MAXLEN = 500, TRUNCATE = 1);

/// 发生日期
Property CXDHappenDate As %Date;

/// 发生时间
Property CXDHappenTime As %Time;

/// 有效标志
Property CXDIsActive As %Boolean;

/// 更新日期
Property CXDActDate As %Date;

/// 更新时间
Property CXDActTime As %Time;

/// 更新用户
Property CXDActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果ID
Property CXDResultID As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexScreenDateTime On (Parref As Exact, CXDScreeningDr As Exact, CXDHappenDate As Exact, CXDHappenTime As Exact);

Index IndexScreenResultID On (Parref As Exact, CXDScreeningDr As Exact, CXDResultID As Exact);

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  根据ID取传染病例筛查明细
/// Table：       DHCMed.EPD.CasesXDtl
/// Input：       aId : DHCMed.EPD.CasesXDtl.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.CasesXDtl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.CasesXDtl
{
	New (aId)
	Quit:'##class(DHCMed.EPD.CasesXDtl).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.CasesXDtl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  更新传染病例筛查明细
/// Table：       DHCMed.EPD.CasesXDtl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.CasesXDtl).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set Parref      = $p(aInputStr,aSeparete,1)
	Set ChildSub    = $p(aInputStr,aSeparete,2)
	Set ScreeningDr = $p(aInputStr,aSeparete,3)
	Set Content     = $p(aInputStr,aSeparete,4)
	Set HappenDate  = $p(aInputStr,aSeparete,5)
	Set HappenTime  = $p(aInputStr,aSeparete,6)
	Set IsActive    = $p(aInputStr,aSeparete,7)
	Set ActDate     = $p(aInputStr,aSeparete,8)
	Set ActTime     = $p(aInputStr,aSeparete,9)
	Set ActUser     = $p(aInputStr,aSeparete,10)
	Set ResultID     = $p(aInputStr,aSeparete,11)
	Quit:(Parref="")||(ScreeningDr="") return
	
	Set objParref=##class(DHCMed.EPD.CasesX).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objScreening=##class(DHCMed.EPD.SuspScreening).GetObjById(ScreeningDr)
	Quit:'$IsObject(objScreening) return
	
	Set:HappenDate'="" HappenDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(HappenDate)
	Set:HappenTime[":" HappenTime = $zth(HappenTime,1)
	Set:ActDate'="" ActDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ChildSub="" {
		Set obj=##class(DHCMed.EPD.CasesXDtl).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.CasesXDtl).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.CXDScreeningDr = objScreening
	Set obj.CXDContent     = Content
	Set obj.CXDHappenDate  = HappenDate
	Set obj.CXDHappenTime  = HappenTime
	Set obj.CXDIsActive    = IsActive
	Set obj.CXDActDate     = ActDate
	Set obj.CXDActTime     = ActTime
    Set obj.CXDActUser     = ActUser
    Set obj.CXDResultID    = ResultID
    
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

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  删除传染病例筛查明细
/// Table：       DHCMed.EPD.CasesXDtl
/// Input：       aId : DHCMed.EPD.CasesXDtl.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.CasesXDtl).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.CasesXDtl).%DeleteId(aId)
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
<Data name="CasesXDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CXDScreeningDr</Value>
</Value>
<Value name="3">
<Value>CXDContent</Value>
</Value>
<Value name="4">
<Value>CXDHappenDate</Value>
</Value>
<Value name="5">
<Value>CXDHappenTime</Value>
</Value>
<Value name="6">
<Value>CXDIsActive</Value>
</Value>
<Value name="7">
<Value>CXDActDate</Value>
</Value>
<Value name="8">
<Value>CXDActTime</Value>
</Value>
<Value name="9">
<Value>CXDActUser</Value>
</Value>
<Value name="10">
<Value>CXDResultID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>CasesXDtlDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^DHCMed.EPD.CasesXI("DTL")</IndexLocation>
<StreamLocation>^DHCMed.EPD.CasesXDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
