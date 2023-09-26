/// 传染病疑似检验项目
Class DHCMed.EPD.SuspTestCode Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 外部码（检验系统）
Relationship ChildExt As DHCMed.EPD.SuspTestCodeExt [ Cardinality = children, Inverse = Parref ];

/// 项目代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 说明
Property BTNote As %String(MAXLEN = 1000, TRUNCATE = 1);

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  根据ID取传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       aId : DHCMed.EPD.SuspTestCode.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.SuspTestCode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.SuspTestCode
{
	New (aId)
	Quit:'##class(DHCMed.EPD.SuspTestCode).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.SuspTestCode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  更新传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspTestCode).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID    = $p(aInputStr,aSeparete,1)
	Set Code  = $p(aInputStr,aSeparete,2)
	Set Desc  = $p(aInputStr,aSeparete,3)
	Set Note  = $p(aInputStr,aSeparete,4)
    Quit:(Code="")||(Desc="") return
    
    Set tID=$o(^DHCMed.EPD.SuspTestCodeI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.SuspTestCode).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.SuspTestCode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode  = Code    
	Set obj.BTDesc  = Desc    
	Set obj.BTNote  = Note
	
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
/// Description:  删除传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       aId : DHCMed.EPD.SuspTestCode.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspTestCode).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.EPD.SuspTestCode")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMed.EPD.SuspTestCode).%DeleteId(aId)
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
<Data name="SuspTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTCCode</Value>
</Value>
<Value name="3">
<Value>BTTCDesc</Value>
</Value>
<Value name="4">
<Value>BTCode</Value>
</Value>
<Value name="5">
<Value>BTDesc</Value>
</Value>
<Value name="6">
<Value>BTNote</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.SuspTestCodeD</DataLocation>
<DefaultData>SuspTestCodeDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.SuspTestCodeD</IdLocation>
<IndexLocation>^DHCMed.EPD.SuspTestCodeI</IndexLocation>
<StreamLocation>^DHCMed.EPD.SuspTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
