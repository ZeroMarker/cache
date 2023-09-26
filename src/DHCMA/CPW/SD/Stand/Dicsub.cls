/// 名称: DHCMA.CPW.SD.Stand.Dicsub
/// 描述: 项目标准化字典子项
/// 编写者：zqy
/// 编写日期: 2021-03-30
Class DHCMA.CPW.SD.Stand.Dicsub Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.Stand.Dic [ Cardinality = parent, Inverse = ChildSub ];

/// 子项代码
Property DicCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 子项名称
Property DicDesc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 备注说明
Property Resume As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxDicDesc On DicDesc As Exact;

Index IdxCatDicDesc On (Parref, DicDesc As Exact);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.Dicsub
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.Dicsub).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.Dicsub).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新项目标准化字典子项
/// Table：       DHCMA.CPW.SD.Stand.Dicsub
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.Dicsub).Update("342^^2^患者体重（kg）^^体重(单位:公斤(kg))^NurInfo^weight^^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefId		 = $p(aInputStr,aSeparete,1)
	Set ID          	 = $p(aInputStr,aSeparete,2)
	Set DicCode          = $p(aInputStr,aSeparete,3)
	Set DicDesc      	 = $p(aInputStr,aSeparete,4)
	Set Resume       	 = $p(aInputStr,aSeparete,5)
	Set AddMsg       	 = $p(aInputStr,aSeparete,6)
	Quit:(DicCode="")||(DicDesc="") return
	Set tID=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxCatDicDesc",ParrefId,DicDesc,0))
	Set:ID="" ID=tID
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.Dicsub).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.Dicsub).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.Parref        =##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(ParrefId)
	Set obj.DicCode   	  = DicCode
	Set obj.DicDesc    	  = DicDesc
	Set obj.Resume 	  	  = Resume
	
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
/// Description:  删除项目标准化字典子项
/// Table：       DHCMA.CPW.SD.Stand.Dicsub
/// Input：       aId :  DHCMA.CPW.SD.Stand.Dicsub.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.Dicsub).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.Dicsub).%DeleteId(aId)
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
<Data name="DicsubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DicCode</Value>
</Value>
<Value name="3">
<Value>DicDesc</Value>
</Value>
<Value name="4">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.DicsubD</DataLocation>
<DefaultData>DicsubDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.DicsubD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.DicsubI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.DicsubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
