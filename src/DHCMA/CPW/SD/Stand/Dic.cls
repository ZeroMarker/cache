/// 名称: DHCMA.CPW.SD.Stand.Dic
/// 描述: 项目标准化字典
/// 编写者：zqy
/// 编写日期: 2021-03-30
Class DHCMA.CPW.SD.Stand.Dic Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSub As DHCMA.CPW.SD.Stand.Dicsub [ Cardinality = children, Inverse = Parref ];

/// 来源类型
Property SourceDr As DHCMA.Util.BT.Dictionary;

/// 字典代码
Property DicCatCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 字典名称
Property DicCatDesc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 备注说明
Property Resume As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxSource On SourceDr;

Index IdxDicDesc On DicCatDesc As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.Dic
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.Dic).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.Dic).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新项目标准化字典
/// Table：       DHCMA.CPW.SD.Stand.Dic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          	 = $p(aInputStr,aSeparete,1)
	Set Source           = $p(aInputStr,aSeparete,2)
	Set DicCatCode       = $p(aInputStr,aSeparete,3)
	Set DicCatDesc       = $p(aInputStr,aSeparete,4)
	Set Resume           = $p(aInputStr,aSeparete,5)
	Set AddMsg           = $p(aInputStr,aSeparete,6)
	Quit:(Source="")||(DicCatDesc="") return
	Set objSource=##class(DHCMA.Util.BT.Dictionary).GetObjById(Source)
	Quit:'$IsObject(objSource) return
	Set tID=$o(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",DicCatDesc,0))
	Set:ID="" ID=tID
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.Dic).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.Dic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.SourceDr   	  = ##class(DHCMA.Util.BT.Dictionary).GetObjById(Source)
	Set obj.DicCatCode    = DicCatCode
	Set obj.DicCatDesc 	  = DicCatDesc
	Set obj.Resume  	  = Resume
	
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	If (AddMsg'="")&&(return>0) {
		Set Addret=##class(DHCMA.CPW.SD.StandSrv.DicSrv).AddOtherMsg(return,AddMsg)
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  删除项目标准化字典
/// Table：       DHCMA.CPW.SD.Stand.Dic
/// Input：       aId :  DHCMA.CPW.SD.Stand.Dic.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.Dic).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.Dic).%DeleteId(aId)
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
<Data name="DicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceDr</Value>
</Value>
<Value name="3">
<Value>DicCatCode</Value>
</Value>
<Value name="4">
<Value>DicCatDesc</Value>
</Value>
<Value name="5">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.DicD</DataLocation>
<DefaultData>DicDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.DicD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.DicI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.DicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
