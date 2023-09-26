/// 检查医嘱+诊断结果信息
Class DHCMA.CPW.SD.Data.RisInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 报告ID
Property RBRepID As %String(TRUNCATE = 1);

/// 检查号
Property RBStudyNo As %String(TRUNCATE = 1);

/// 医嘱ID
Property OEItemID As %String;

/// 医嘱项ID
Property ARCMastID As %String;

/// 登记日期
Property RegDate As %String;

/// 登记时间
Property RegTime As %String;

/// 登记日期时间-输出用
Property RegDateT As %String;

/// 报告日期
Property RepDate As %String;

/// 报告时间
Property RepTime As %String;

/// 报告日期时间-输出用
Property RepDateT As %String;

/// 报告状态Code
Property RepStatusCode As %String;

/// 报告状态
Property RepStatus As %String;

/// 检查所见-输出
Property RepResult As %String(MAXLEN = 10000);

/// 检查诊断-输出
Property RepDianog As %String(MAXLEN = 10000);

Index IdxAdmStudy On (EpisodeID As Exact, RBStudyNo As Exact);

Index IdxAdmOEItem On (EpisodeID As Exact, OEItemID As Exact);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.RisInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.RisInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.RisInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.RisInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.RisInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.RisInfo).%OpenId(aId)
	Set obj.RepDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.RepDate)
	Set obj.RepTime=$zt(obj.RepTime,1)
	Set obj.RepDateT=obj.RepDate_" "_obj.RepTime
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-04-12
/// Description:  更新检查记录
/// Table：       DHCMA.CPW.SD.Data.RisInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.RisInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID		= $p(aInputStr,aSeparete,1)
	Set RBRepID			= $p(aInputStr,aSeparete,2)
	Set RBStudyNo       = $p(aInputStr,aSeparete,3)
	Set OEItemID		= $p(aInputStr,aSeparete,4)
	Set ARCMastID		= $p(aInputStr,aSeparete,5)
	Set RegDate			= $p(aInputStr,aSeparete,6)
	Set RegTime			= $p(aInputStr,aSeparete,7)
	Set RepDate			= $p(aInputStr,aSeparete,8)
	Set RepTime			= $p(aInputStr,aSeparete,9)
	Set RepStatusCode	= $p(aInputStr,aSeparete,10)
	Set RepStatus		= $p(aInputStr,aSeparete,11)
	Set RepResult		= $p(aInputStr,aSeparete,12)
	Set RepDianog		= $p(aInputStr,aSeparete,13)
	Quit:(EpisodeID="")||(OEItemID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.RisInfoI("IdxAdmOEItem",EpisodeID,OEItemID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.RisInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.RisInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	//写入数据
	Set obj.EpisodeID		=EpisodeID	
	Set obj.RBRepID			=RBRepID	        
	Set obj.RBStudyNo   	=RBStudyNo       
	Set obj.OEItemID		=OEItemID	
	Set obj.ARCMastID		=ARCMastID	
	Set obj.RegDate			=RegDate	        
	Set obj.RegTime			=RegTime	        
	Set obj.RepDate			=RepDate	        
	Set obj.RepTime			=RepTime	        
	Set obj.RepStatusCode	=RepStatusCode   
	Set obj.RepStatus		=RepStatus	
	Set obj.RepResult		=RepResult	
	Set obj.RepDianog		=RepDianog
	
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

/// Description:  删除项检查记录
/// Table：       DHCMA.CPW.SD.Data.RisInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.RisInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.RisInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.RisInfo).%DeleteId(aId)
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
<Data name="RisInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RBRepID</Value>
</Value>
<Value name="4">
<Value>RBStudyNo</Value>
</Value>
<Value name="5">
<Value>OEItemID</Value>
</Value>
<Value name="6">
<Value>ARCMastID</Value>
</Value>
<Value name="7">
<Value>RegDate</Value>
</Value>
<Value name="8">
<Value>RegTime</Value>
</Value>
<Value name="9">
<Value>RegDateT</Value>
</Value>
<Value name="10">
<Value>RepDate</Value>
</Value>
<Value name="11">
<Value>RepTime</Value>
</Value>
<Value name="12">
<Value>RepDateT</Value>
</Value>
<Value name="13">
<Value>RepStatusCode</Value>
</Value>
<Value name="14">
<Value>RepStatus</Value>
</Value>
<Value name="15">
<Value>RepResult</Value>
</Value>
<Value name="16">
<Value>RepDianog</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.RisInfoD</DataLocation>
<DefaultData>RisInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.RisInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.RisInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.RisInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
