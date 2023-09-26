/// 名称: DHCMed.SS.CasesXDtl
/// 描述: 病例筛查明细
/// 编写者：pylian
/// 编写日期: 2020-07-28
Class DHCMed.SS.CasesXDtl Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.SS.CasesX [ Cardinality = parent, Inverse = ChildDtl ];

/// 筛查类型（Key诊断关键词、LIS检验项目、RIS检查项目、CC主诉症状、PH药品名称）
Property CXDScreenType As %String(DISPLAYLIST = ",KEY,LIS,RIS,CCK,PHK", VALUELIST = ",K,L,R,C,P");

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

/// 结果ID(诊断ID、检查ID、检验ID)
Property CXDResultID As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexScreenDateTime On (Parref As Exact, CXDScreenType As Exact, CXDHappenDate As Exact, CXDHappenTime As Exact);

Index IndexScreenResultID On (Parref As Exact, CXDScreenType As Exact, CXDResultID As Exact);

/// Creator：     liuzhenhe
/// CreatDate：   2020-08-04
/// Description:  根据ID取病例筛查明细
/// Table：       DHCMed.SS.CasesXDtl
/// Input：       ID
/// Return：      返回Object
/// w ##class(DHCMed.SS.CasesXDtl).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMed.SS.CasesXDtl
{
	New (aId)
	Set return=""
	Quit:'..%ExistsId(aId) return
	Set obj=..%OpenId(aId)
	Do:obj'="" obj.%Close()
	
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-08-04
/// Description:  删除病例筛查明细
/// Table：       DHCMed.SS.CasesXDtl
/// Input：       ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.SS.CasesXDtl).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)

	Set sc = ..%Delete(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	
	quit ret
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-08-04
/// Description:  更新病例筛查明细
/// Table：       DHCMed.SS.CasesXDtl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SS.CasesXDtl).Update("","^")
ClassMethod Update(aInStr As %String, separator As %String) As %String
{
	New (aInStr,separator)
	Set return=0
	Quit:aInStr="" return
	Set:$g(separator)="" separator=..#SEPARATE

	Set Parref      = $p(aInStr,separator,1)
	Set ChildSub    = $p(aInStr,separator,2)
	Set ScreenType	= $p(aInStr,separator,3)
	Set Content		= $p(aInStr,separator,4)
	Set HappenDate	= $p(aInStr,separator,5)
	Set HappenTime	= $p(aInStr,separator,6)
	Set IsActive	= $p(aInStr,separator,7)
	Set ActDate		= $p(aInStr,separator,8)
	Set ActTime		= $p(aInStr,separator,9)
	Set ActUser		= $p(aInStr,separator,10)
	Set ResultID	= $p(aInStr,separator,11)

	Quit:(Parref="")||(ScreenType="") return
	
	Set objParref=##class(DHCMed.SS.CasesX).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set:HappenDate'="" HappenDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(HappenDate)
	Set:HappenTime[":" CXDHappenTime = $zth(CXDHappenTime,1)
	Set:ActDate'="" ActDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ChildSub="" {
		Set obj=..%New()
	}Else{
		Set obj=..%OpenId(objParref.%Id()_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.CXDScreenType  = ScreenType
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CXDScreenType</Value>
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
<DataLocation>{%%PARENT}("Dtl")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Dtl")</IdLocation>
<IndexLocation>^MA.SS.CasesXI("Dtl")</IndexLocation>
<StreamLocation>^MA.SS.CasesXIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
