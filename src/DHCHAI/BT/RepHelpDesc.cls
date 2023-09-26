/// 名称: DHCHAI.BT.RepHelpDesc
/// 描述: 系统报表指标项说明
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.RepHelpDesc Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property RepCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property RepName As %String(MAXLEN = 250, TRUNCATE = 1) [ Required ];

/// 描述
Property RepDesc As %String(MAXLEN = 25000, TRUNCATE = 1);

/// 代码索引
Index IdxofCode On RepCode As Exact;

/// Creator：     chenjb
/// CreatDate：   2020-05-07
/// Description:  根据ID取信息
/// Table：       DHCHAI.BT.RepHelpDesc
/// Input：       aId : DHCHAI.BT.RepHelpDesc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.RepHelpDesc).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.RepHelpDesc
{
	New (aId)
	Quit:'##class(DHCHAI.BT.RepHelpDesc).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.RepHelpDesc).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCHAI.BT.RepHelpDesc).GetHelpDoc("1")
ClassMethod GetHelpDoc(aID As %String) As %String
{
	New (aID)
	Quit:'##class(DHCHAI.BT.RepHelpDesc).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.BT.RepHelpDesc).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj.RepDesc
}

/// w ##class(DHCHAI.BT.RepHelpDesc).GetHelpDocByCode("1")
ClassMethod GetHelpDocByCode(aCode As %String) As %String
{
	New (aCode)
	Quit:aCode="" ""
	Set aID=$o(^DHCHAI.BT.RepHelpDescI("IdxofCode",aCode,0))
	Quit:'##class(DHCHAI.BT.RepHelpDesc).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.BT.RepHelpDesc).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj.RepDesc
}

/// w ##class(DHCHAI.BT.RepHelpDesc).UpdateDoc("1","<p><span style=""white-space: nowrap;"">IIHAI-1 医院感染发病率</span></p><p><br/></p>")
ClassMethod UpdateDoc(aID As %String, aDoc As %String) As %String
{
	New (aID,aDoc)
	Set ^DHCHAI("CJBDOC")=aDoc
	Set return=0
	Quit:aDoc="" return	
	Set obj=##class(DHCHAI.BT.RepHelpDesc).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Set obj.RepDesc = aDoc
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

/// Creator：     chenjianbo
/// CreatDate：   2020-05-07
/// Description:  根据Code取参数配置信息
/// Table：       DHCHAI.BT.RepHelpDesc
/// Input：       aCode : DHCHAI.BT.RepHelpDesc
///               aHospDr : DHCHAI.BT.RepHelpDesc
/// Return：      返回String
/// w ##class(DHCHAI.BT.RepHelpDesc).GetValByCode("")
ClassMethod GetValByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCHAI.BT.RepHelpDescI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	If $IsObject(obj) {
		Set return=obj.RepDesc
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新信息
/// Table：       DHCHAI.BT.RepHelpDesc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.RepHelpDesc).Update("^c001^您好，测试数据","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set RepName     = $p(aInputStr,aSeparete,3)
	Set Desc     = $p(aInputStr,aSeparete,4)	
	Quit:(Code="")||(RepName="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
		
	Set tID=$o(^DHCHAI.BT.RepHelpDescI("IdxofCode",Code,0))

	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.RepHelpDesc).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.RepHelpDesc).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.RepCode     = Code
	Set obj.RepDesc     = Desc
	Set obj.RepName     = RepName
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

/// Creator：     chenjb
/// CreatDate：   2020-01-10
/// Description:  删除信息
/// Table：       
/// Input：       aId : .ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.RepHelpDesc).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.RepHelpDesc).%DeleteId(aId)
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
<Data name="RepHelpDescDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepCode</Value>
</Value>
<Value name="3">
<Value>RepDesc</Value>
</Value>
<Value name="4">
<Value>RepName</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.RepHelpDescD</DataLocation>
<DefaultData>RepHelpDescDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.RepHelpDescD</IdLocation>
<IndexLocation>^DHCHAI.BT.RepHelpDescI</IndexLocation>
<StreamLocation>^DHCHAI.BT.RepHelpDescS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
