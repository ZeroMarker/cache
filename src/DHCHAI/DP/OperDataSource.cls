/// 名称: DHCHAI.BT.OperDataSource
/// 描述: 手术数据源配置
/// 编写者：liutao
/// 编写日期: 2022-11-17
Class DHCHAI.DP.OperDataSource Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property ODCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property ODDesc As %String(TRUNCATE = 1) [ Required ];

/// 数据源
Property DataSourceDr As DHCHAI.BT.Dictionary;

Index IdxofCode On ODCode As Exact;

/// Creator：     liutao
/// CreatDate：   2022-11-17
/// Description:  根据ID取数据源信息
/// Table：       DHCHAI.DP.OperDataSource
/// Input：       aId : DHCHAI.DP.OperDataSource.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.OperDataSource).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.OperDataSource
{
	New (aId)
	Quit:'##class(DHCHAI.DP.OperDataSource).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.OperDataSource).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liutao
/// CreatDate：   2022-11-17
/// Description:  更新数据源信息
/// Table：       DHCHAI.DP.OperDataSource
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OperDataSource).Update("^Incision^切口等级^2","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       	= $p(aInputStr,aSeparete,1)
	Set Code     	= $p(aInputStr,aSeparete,2)
	Set Desc     	= $p(aInputStr,aSeparete,3)
	Set SourceCode  = $p(aInputStr,aSeparete,4)
	
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	Set tID=$o(^CT.MA.HAI.DP.OperDataSourceI("IdxofCode",Code,0))
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.OperDataSource).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.OperDataSource).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set DataSourceDr =##class(DHCHAI.BT.Dictionary).GetObjById(SourceCode)
	Set obj.ODCode     		 = Code
	Set obj.ODDesc    		 = Desc
	Set obj.DataSourceDr     = DataSourceDr
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

/// Creator：     liutao
/// CreatDate：   2022-11-28
/// Description:  根据Code取数据源信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aCode : DHCHAI.DP.OperDataSource.Code
/// Return：      返回obj
/// w ##class(DHCHAI.DP.OperDataSource).GetObjByCode("Incision")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.Dictionary
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^CT.MA.HAI.DP.OperDataSourceI("IdxofCode",aCode,""))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)	
	Quit obj
}

/// Creator：     liutao
/// CreatDate：   2022-11-17
/// Description:  删除数据源信息
/// Table：       DHCHAI.DP.OperDataSource
/// Input：       aId : DHCHAI.DP.OperDataSource.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OperDataSource).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.OperDataSource).%DeleteId(aId)
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
<Data name="OperDataSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ODCode</Value>
</Value>
<Value name="3">
<Value>ODDesc</Value>
</Value>
<Value name="4">
<Value>DataSourceDr</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.DP.OperDataSourceD</DataLocation>
<DefaultData>OperDataSourceDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.DP.OperDataSourceD</IdLocation>
<IndexLocation>^CT.MA.HAI.DP.OperDataSourceI</IndexLocation>
<StreamLocation>^CT.MA.HAI.DP.OperDataSourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
