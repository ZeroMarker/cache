/// 患者送检报告信息 数据池
Class DHCMA.CPW.SD.Data.LisInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 检验报告ID
Property LisRepID As %String;

/// 报告状态
Property LisRepStatus As %String;

/// 医嘱ID
Property OEItemID As %String;

/// 医嘱项名称
Property LabOrdTSDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医嘱项代码
Property LabOrdTSCode As %String(MAXLEN = 500, TRUNCATE = 1);

/// 检验号/标本号
Property LabEpisodeNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标本
Property LabSpecimen As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 申请科室|送检科室
Property LabLocDr As %String;

/// 采集日期-输出
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

/// 检验报告日期
Property LisRepDate As %Date;

/// 检验报告时间
Property LisRepTime As %Time;

/// 检验报告日期时间-输出
Property LisRepDateT As %String;

Index IdxAdmOEItem On (EpisodeID As exact, OEItemID As exact);

Index IdxAdmLabNo On (EpisodeID As exact, LabEpisodeNo As exact);

Index IdxAdmLabOERep On (EpisodeID As exact, OEItemID As exact, LisRepID As exact);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.LisInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.LisInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.LisInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.LisInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.LisInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.LisInfo).%OpenId(aId)
	Set obj.LisRepDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.LisRepDate)
	Set obj.LabRecTime=$zt(obj.LabRecTime,1)
	Set obj.LisRepDateT=obj.LisRepDate_" "_obj.LabRecTime
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-04-12
/// Description:  更新检验记录
/// Table：       DHCMA.CPW.SD.Data.LisInfo
/// Input：       各属性列表 默认^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.LisInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID		= $p(aInputStr,aSeparete,1)
	Set LisRepID		= $p(aInputStr,aSeparete,2)					
	Set OEItemID		= $p(aInputStr,aSeparete,3)
	Set LabOrdTSDesc	= $p(aInputStr,aSeparete,4)
	Set LabOrdTSCode	= $p(aInputStr,aSeparete,5)
	Set LabEpisodeNo	= $p(aInputStr,aSeparete,6)
	Set LabSpecimen		= $p(aInputStr,aSeparete,7)
	Set LabLocDr		= $p(aInputStr,aSeparete,8)
	Set LabCollDate		= $p(aInputStr,aSeparete,9)
	Set LabCollTime		= $p(aInputStr,aSeparete,10)
	Set LabCollUser		= $p(aInputStr,aSeparete,11)
	Set LabRecDate		= $p(aInputStr,aSeparete,12)
	Set LabRecTime		= $p(aInputStr,aSeparete,13)
	Set LabRecUser		= $p(aInputStr,aSeparete,14)
	Set LisRepDate		= $p(aInputStr,aSeparete,15)
	Set LisRepTime		= $p(aInputStr,aSeparete,16)
	Set LisRepStatus	= $p(aInputStr,aSeparete,17)
	Quit:(EpisodeID="")||(OEItemID="")||(LisRepID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.LisInfoI("IdxAdmLabOERep",EpisodeID,OEItemID,LisRepID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.LisInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.LisInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.EpisodeID		= EpisodeID	
	Set obj.LisRepID		= LisRepID						
	Set obj.OEItemID		= OEItemID	
	Set obj.LabOrdTSDesc	= LabOrdTSDesc
	Set obj.LabOrdTSCode	= LabOrdTSCode
	Set obj.LabEpisodeNo	= LabEpisodeNo
	Set obj.LabSpecimen		= LabSpecimen	
	Set obj.LabLocDr		= LabLocDr	
	Set obj.LabCollDate		= LabCollDate	
	Set obj.LabCollTime		= LabCollTime	
	Set obj.LabCollUser		= LabCollUser	
	Set obj.LabRecDate		= LabRecDate	
	Set obj.LabRecTime		= LabRecTime
	Set obj.LabRecUser		= LabRecUser	
	Set obj.LisRepDate		= LisRepDate	
	Set obj.LisRepTime		= LisRepTime	
	Set obj.LisRepStatus	= LisRepStatus
	//检验Save是否成功
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

/// Description:  删除项检验记录
/// Table：       DHCMA.CPW.SD.Data.LisInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.LisInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.LisInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.LisInfo).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检验删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="LisInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>OEItemID</Value>
</Value>
<Value name="4">
<Value>LabOrdTSDesc</Value>
</Value>
<Value name="5">
<Value>LabOrdTSCode</Value>
</Value>
<Value name="6">
<Value>LabEpisodeNo</Value>
</Value>
<Value name="7">
<Value>LabSpecimen</Value>
</Value>
<Value name="8">
<Value>LabLocDr</Value>
</Value>
<Value name="9">
<Value>LabCollDate</Value>
</Value>
<Value name="10">
<Value>LabCollTime</Value>
</Value>
<Value name="11">
<Value>LabCollUser</Value>
</Value>
<Value name="12">
<Value>LabRecDate</Value>
</Value>
<Value name="13">
<Value>LabRecTime</Value>
</Value>
<Value name="14">
<Value>LabRecUser</Value>
</Value>
<Value name="15">
<Value>LisRepID</Value>
</Value>
<Value name="16">
<Value>LisRepDate</Value>
</Value>
<Value name="17">
<Value>LisRepTime</Value>
</Value>
<Value name="18">
<Value>LisRepDateT</Value>
</Value>
<Value name="19">
<Value>LisRepStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.LisInfoD</DataLocation>
<DefaultData>LisInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.LisInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.LisInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.LisInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
