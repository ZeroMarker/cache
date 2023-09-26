/// 名称: DHCHAI.IR.PDCAFileUrl
/// 描述: PDCA文件路径
/// 编写者：ShenC
/// 编写日期: 2022-06-28
Class DHCHAI.IR.PDCAFileUrl Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// PDCA报告
Property PARepDr As DHCHAI.IR.PDCARep [ Required ];

/// 文件框ID
Property PADivID As %String [ Required ];

/// 路径
Property PAPath As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 名称
Property PAName As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 更新日期
Property PAUpdateDate As %Date;

/// 更新时间
Property PAUpdateTime As %Time;

/// 更新人
Property PAUpdateUserDr As DHCHAI.BT.SysUser;

/// 索引-报告+名称
Index IndexRepName On (PARepDr, PAName As Exact);

/// 索引-报告+ID
Index IndexRepDiv On (PARepDr, PADivID As Exact);

/// Creator：     ShenC
/// CreatDate：   2022-07-20
/// Description:  根据ID取PDCA文件路径
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aID : DHCHAI.IR.PDCAFileUrl.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCAFileUrl).GetObjById(1)
ClassMethod GetObjById(aID As %String) As DHCHAI.IR.PDCAFileUrl
{
	New (aID)
	Quit:'##class(DHCHAI.IR.PDCAFileUrl).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCAFileUrl).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-07-20
/// Description:  更新PDCA文件路径
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAFileUrl).Update("^1^UpLoad_1^治疗前送检2.txt^上传日期^上传时间^上传人")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID				= $p(aInputStr,aSeparete,1)		
	Set RepID			= $p(aInputStr,aSeparete,2)				//报告ID
	Set objRep=##class(DHCHAI.IR.PDCARep).GetObjById(RepID)
	Quit:'$ISObject(objRep) return
	Set DivID			= $p(aInputStr,aSeparete,3)				//关联Div
	Set Path			= $p(aInputStr,aSeparete,4)				//路径
	Set Name			= $p(aInputStr,aSeparete,5)				//名称
	Quit:(DivID="")||(Path="")||(Name="") return
	Set UpdateDate		= $p(aInputStr,aSeparete,6)				//更新日期
	Set UpdateTime		= $p(aInputStr,aSeparete,7)				//更新时间
	Set UpdateUserDr	= $p(aInputStr,aSeparete,8)				//更新人
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime'="" UpdateTime = ##class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical(UpdateTime)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.PDCAFileUrl).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.PDCAFileUrl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PARepDr	    	= objRep
	Set obj.PADivID	    	= DivID
	Set obj.PAPath			= Path
	Set obj.PAName			= Name
	Set obj.PAUpdateDate	= UpdateDate
	Set obj.PAUpdateTime	= UpdateTime
	Set obj.PAUpdateUserDr		= objUser
	
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

/// Creator：     ShenC
/// CreatDate：   2022-07-20
/// Description:  删除PDCA文件路径
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aID : DHCHAI.IR.PDCAFileUrl.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAFileUrl).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCAFileUrl).%DeleteId(aID)
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
<Data name="PDCAFileUrlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PARepDr</Value>
</Value>
<Value name="3">
<Value>PADivID</Value>
</Value>
<Value name="4">
<Value>PAPath</Value>
</Value>
<Value name="5">
<Value>PAName</Value>
</Value>
<Value name="6">
<Value>PAUpdateDate</Value>
</Value>
<Value name="7">
<Value>PAUpdateTime</Value>
</Value>
<Value name="8">
<Value>PAUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.PDCAFileUrlD</DataLocation>
<DefaultData>PDCAFileUrlDefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.PDCAFileUrlD</IdLocation>
<IndexLocation>^MA.HAI.IR.PDCAFileUrlI</IndexLocation>
<StreamLocation>^MA.HAI.IR.PDCAFileUrlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
