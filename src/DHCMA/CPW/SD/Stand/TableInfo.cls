/// 名称: DHCMA.CPW.SD.Stand.TableInfo
/// 描述: 标准化-表取值字段信息
/// 编写者：zgz
/// 编写日期: 2021-05-19
Class DHCMA.CPW.SD.Stand.TableInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = "" ]
{

/// 标准化字典项/子项
Property DicId As %String;

/// 表名
Property TableName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字段名
Property FieldName As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxDic On DicId As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.TableInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.TableInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.TableInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新标准化-表取值信息
/// Table：       DHCMA.CPW.SD.Stand.TableInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          	= $p(aInputStr,aSeparete,1)
	Set DicId        	= $p(aInputStr,aSeparete,2)
	Set TableName      	= $p(aInputStr,aSeparete,3)
	Set FieldName    	= $p(aInputStr,aSeparete,4)
	Quit:(DicId="") return
	Set ID=$o(^DHCMA.CPW.SD.Stand.TableInfoI("IdxDic",DicId,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.TableInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.TableInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.DicId		= DicId
	Set obj.TableName	= TableName
	Set obj.FieldName	= FieldName
	
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

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  删除标准化-基础信息关键字
/// Table：       DHCMA.CPW.SD.Stand.TableInfo
/// Input：       aId :  DHCMA.CPW.SD.Stand.TableInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.BaseMatch).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.TableInfo).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic("6||55")
ClassMethod GetTableStrByDic(aDicID) As %String
{
	New (aDicID)
	Set return=""
	Set ID=$o(^DHCMA.CPW.SD.Stand.TableInfoI("IdxDic",aDicID,0))
	Quit:ID="" return
	Set obj=##class(DHCMA.CPW.SD.Stand.TableInfo).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set TableName=obj.TableName
	Set FieldName=obj.FieldName
	Set return=TableName_"^"_FieldName
	Quit return
}

Storage Default
{
<Data name="TableInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DicId</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>FieldName</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.TableInfoD</DataLocation>
<DefaultData>TableInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.TableInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.TableInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.TableInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
