/// 名称: DHCHAI.MK.BTDictionary（对应原有类：DHCMed.NINF.Srv.MKDictionary）
/// 描述: 民科字典项目
/// 编写者：李阳
/// 编写日期: 2012-12-14
Class DHCHAI.MK.BTDictionary Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 主代码
/// 民科系统每个字典项目均带有一个主代码
/// 可以当做唯一标示使用
Property IDCode As %String(TRUNCATE = 1);

/// 字典代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 拼写
Property Spell As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

/// 代码索引
Index IndexCode On Code;

/// 描述索引
Index IndexDesc On Description;

/// 拼写索引
Index IndexSpell On Spell;

/// 主代码索引
Index IndexIDCode On IDCode [ Unique ];

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  取民科院感字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       DHCHAI.MK.BTDictionary.ID
/// Return：      返回obj
/// w ##class(DHCHAI.MK.BTDictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.MK.BTDictionary
{
	New (aId)
	Set obj=##Class(DHCHAI.MK.BTDictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  更新民科院感字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.MK.BTDictionary).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set IDCode=$p(aInput,aSeparate,1)
	Set ID=$o(^DHCHAI.MK.BTDictionaryI("IndexIDCode"," "_$zcvt(IDCode,"U"),""))
	If (ID="") {
		Set obj=##class(DHCHAI.MK.BTDictionary).%New()
	} Else {
		Set obj=##class(DHCHAI.MK.BTDictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IDCode=$p(aInput,aSeparate,1)
	Set obj.Code=$p(aInput,aSeparate,2)
	Set obj.Description=$p(aInput,aSeparate,3)
	Set obj.Spell=$p(aInput,aSeparate,4)
	Set obj.IsActive=+$p(aInput,aSeparate,5)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  删除民科院感字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       DHCHAI.MK.BTDictionary.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.MK.BTDictionary).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  清空民科院感字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       
/// Return：      return>0:成功  return<=0:失败
/// Do ##class(DHCHAI.MK.BTDictionary).ClearData()
ClassMethod ClearData()
{
	Kill ^DHCHAI.MK.BTDictionaryD
	Kill ^DHCHAI.MK.BTDictionaryI
	Quit 1
}

/// Creator：     liyang
/// CreatDate：   2013-01-25
/// Description:  通过主代码、别名查询民科字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.MK.BTDictionary","QryMKDicByType","999999001","")
Query QryMKDicByType(aTypeCode As %String, aAlias As %String) As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String,DicSpell:%String")
{
}

ClassMethod QryMKDicByTypeExecute(ByRef qHandle As %Binary, aTypeCode As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aTypeCode="" $$$OK
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Count=0
 	Set xIDCode=" "_aTypeCode
 	For {
	 	Set xIDCode=$o(^DHCHAI.MK.BTDictionaryI("IndexIDCode",xIDCode))
	 	Quit:xIDCode=""
	 	Quit:$e(xIDCode,2,$l(aTypeCode)+1)'=aTypeCode
	 	Quit:Count>50
	 	
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCHAI.MK.BTDictionaryI("IndexIDCode",xIDCode,xID))
		 	Quit:xID=""
		 	Quit:Count>50
		 	
		 	Set objDic=..GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IsActive=objDic.IsActive
			Continue:IsActive'=1
			Set IDCode=objDic.IDCode
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set Spell=objDic.Spell
			Continue:($zcvt(Desc,"U")'[aAlias)&&($zcvt(Spell,"U")'[aAlias)
			//过滤民科字典中的分类项目
			Set SubIDCode=$o(^DHCHAI.MK.BTDictionaryI("IndexIDCode"," "_IDCode_"0"))
			Continue:$e(SubIDCode,2,$l(IDCode)+1)=IDCode
			
			Set Count=Count+1
			
			Set Data=$lb(xID,Code,Desc,Spell)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMKDicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMKDicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMKDicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMKDicByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Spell</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.MK.BTDictionaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCHAI.MK.BTDictionaryD</IdLocation>
<IndexLocation>^DHCHAI.MK.BTDictionaryI</IndexLocation>
<StreamLocation>^DHCHAI.MK.BTDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
