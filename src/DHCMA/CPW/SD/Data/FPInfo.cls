Class DHCMA.CPW.SD.Data.FPInfo Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 主要诊断ICD-10四位亚目编码
Property M4DICD10 As %String(TRUNCATE = 1);

/// 主要诊断ICD-10六位临床扩展编码
Property M6DICD10 As %String(TRUNCATE = 1);

/// 主要诊断名称
Property MDignosDesc As %String(TRUNCATE = 1);

/// 主要手术操作栏中提取ICD-9-CM-3四位亚目编码与名称
Property M4OCM3 As %String(TRUNCATE = 1);

/// 主要手术操作栏中提取ICD-9-CM-3六位临床扩展编码
Property M6OCM3 As %String(TRUNCATE = 1);

/// 主要手术名称
Property MOperDesc As %String(TRUNCATE = 1);

/// 第一次要诊断编码
Property ODICD10 As %String(TRUNCATE = 1);

/// 第一次要诊断描述
Property ODICDDesc As %String(TRUNCATE = 1);

Index IdxAdm On EpisodeID As Exact;

/// 获取编目内容对象
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.FPInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.FPInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.FPInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-10-20
/// Description:  更新编目
/// Table：       DHCMA.CPW.SD.Data.FPInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.FPInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID= $p(aInputStr,aSeparete,1)
	Set M4DICD10	= $p(aInputStr,aSeparete,2)
	Set M6DICD10	= $p(aInputStr,aSeparete,3)
	Set MDignosDesc	= $p(aInputStr,aSeparete,4)
	Set M4OCM3		= $p(aInputStr,aSeparete,5)
	Set M6OCM3		= $p(aInputStr,aSeparete,6)
	Set MOperDesc	= $p(aInputStr,aSeparete,7)
	Set ODICD10		= $p(aInputStr,aSeparete,8)
	Set ODICDDesc	= $p(aInputStr,aSeparete,9)
	Quit:(EpisodeID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.FPInfoI("IdxAdm",EpisodeID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.FPInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.FPInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	//写入数据
	Set obj.EpisodeID	= EpisodeID	
	Set obj.M4DICD10	= M4DICD10	
	Set obj.M6DICD10	= M6DICD10	
	Set obj.MDignosDesc	= MDignosDesc	
	Set obj.M4OCM3		= M4OCM3		
	Set obj.M6OCM3		= M6OCM3		
	Set obj.MOperDesc	= MOperDesc	
	Set obj.ODICD10		= ODICD10		
	Set obj.ODICDDesc	= ODICDDesc	
     
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除费用
/// Table：       DHCMA.CPW.SD.Data.FPInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.FPInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.FPInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.FPInfo).%DeleteId(aId)
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
<Data name="FPInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>M4DICD10</Value>
</Value>
<Value name="4">
<Value>M6DICD10</Value>
</Value>
<Value name="5">
<Value>M4OCM3</Value>
</Value>
<Value name="6">
<Value>M6OCM3</Value>
</Value>
<Value name="7">
<Value>MOOperDesc</Value>
</Value>
<Value name="8">
<Value>ODICD10</Value>
</Value>
<Value name="9">
<Value>OOCM3</Value>
</Value>
<Value name="10">
<Value>MOperDesc</Value>
</Value>
<Value name="11">
<Value>MDignosDesc</Value>
</Value>
<Value name="12">
<Value>ODICDDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.FPInfoD</DataLocation>
<DefaultData>FPInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.FPInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.FPInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.FPInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
