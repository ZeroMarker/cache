/// 名称: DHCHAI.DP.LabVisitRepRstRes
/// 描述: 耐药机制结果
/// 编写者：pylian
/// 编写日期: 2019-05-30
Class DHCHAI.DP.LabVisitRepRstRes Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验结果
Property LabResultDr As DHCHAI.DP.LabVisitRepResult [ Required ];

/// 耐药项目编码
Property LabResItemCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 耐药项目描述
Property LabResItemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果值编码
Property LabResRstCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果值描述
Property LabResRstName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验结果索引
Index IndexLabResultDr On LabResultDr;

/// 检验结果耐药项目索引
Index IndexLabRstItem On (LabResultDr, LabResItemCode As Exact);

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  根据ID取耐药机制结果
/// Table：       DHCHAI.DP.LabVisitRepRstRes
/// Input：       ID:    DHCHAI.DP.LabVisitRepRstRes.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepRstRes).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitRepRstRes
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitRepRstRes).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabVisitRepRstRes).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  根据耐药项目代码耐药机制结果
/// Table：       DHCHAI.DP.LabVisitRepRstRes
/// Input：       aResultDr:DHCHAI.DP.LabVisitRepRstRes.LabResultDr
/// 			  aItemCode:DHCHAI.DP.LabVisitRepRstRes.LabResItemCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepRstRes).GetObjByItemCode("1269","A0001")
ClassMethod GetObjByItemCode(aResultDr As %String, aItemCode As %String) As DHCHAI.DP.LabVisitRepRstRes
{
	New (aResultDr,aItemCode)
	Set return=""
	Quit:(aResultDr="")||(aItemCode="") return
	
	Set id = $o(^DHCHAI.DP.LabVisitRepRstResI("IndexLabRstItem",aResultDr,aItemCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  更新耐药机制结果
/// Table：       DHCHAI.DP.LabVisitRepRstRes
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitRepRstRes).Update("^1^代码^描述^结果代码^结果描述")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set ResultDr   	= $p(InStr,aSeparete,2)
	Set ResItemCode = $p(InStr,aSeparete,3)
	Set ResItemName = $p(InStr,aSeparete,4)
	Set ResRstCode 	= $p(InStr,aSeparete,5)
	Set ResRstName 	= $p(InStr,aSeparete,6)
	Quit:(ResultDr="")||(ResRstName="") return
	
	//耐药机制唯一性
	Set tID =$o(^DHCHAI.DP.LabVisitRepRstResI("IndexLabRstItem",ResultDr,ResItemCode,"")) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultDr)
	Quit:'$isobject(objResult) return
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitRepRstRes).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitRepRstRes).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabResultDr     = objResult
	Set obj.LabResItemCode	= ResItemCode
	Set obj.LabResItemName	= ResItemName
	Set obj.LabResRstCode   = ResRstCode
	Set obj.LabResRstName   = ResRstName

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  删除耐药机制结果
/// Table：       DHCHAI.DP.LabVisitRepRstRes
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitRepRstRes).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="LabVisitRepRstResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabResultDr</Value>
</Value>
<Value name="3">
<Value>LabResItemCode</Value>
</Value>
<Value name="4">
<Value>LabResItemName</Value>
</Value>
<Value name="5">
<Value>LabResRstCode</Value>
</Value>
<Value name="6">
<Value>LabResRstName</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitRepRstResD</DataLocation>
<DefaultData>LabVisitRepRstResDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitRepRstResD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitRepRstResI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitRepRstResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
