/// 接口字典项目
/// 创建者：zhufei
/// 创建日期：2015-02-25
Class DHCMed.SMD.IODictionary Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 主代码
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

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  取接口字典
/// Table：       DHCMed.SMD.IODictionary
/// Input：       DHCMed.SMD.IODictionary.ID
/// Return：      返回obj
/// w ##class(DHCMed.SMD.IODictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SMD.IODictionary
{
	New (aId)
	Set obj=##Class(DHCMed.SMD.IODictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  更新接口字典
/// Table：       DHCMed.SMD.IODictionary
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.SMD.IODictionary).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set IDCode=$p(aInput,aSeparate,1)
	Set ID=$o(^DHCMed.SMD.IODictionaryI("IndexIDCode"," "_$zcvt(IDCode,"U"),""))
	If (ID="") {
		Set obj=##class(DHCMed.SMD.IODictionary).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.IODictionary).%OpenId(ID)
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

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  删除接口字典
/// Table：       DHCMed.SMD.IODictionary
/// Input：       DHCMed.SMD.IODictionary.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.SMD.IODictionary).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  通过主代码、别名查询接口字典
/// Table：       DHCMed.SMD.IODictionary
/// Input：       
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.SMD.IODictionary","QryIODicByType","000001006","hl")
Query QryIODicByType(aTypeCode As %String, aAlias As %String) As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String,DicSpell:%String")
{
}

ClassMethod QryIODicByTypeExecute(ByRef qHandle As %Binary, aTypeCode As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aTypeCode="" $$$OK
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Count=0
 	Set xIDCode=" "_aTypeCode
 	For {
	 	Set xIDCode=$o(^DHCMed.SMD.IODictionaryI("IndexIDCode",xIDCode))
	 	Quit:xIDCode=""
	 	Quit:$e(xIDCode,2,$l(aTypeCode)+1)'=aTypeCode
	 	Quit:Count>50
	 	
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCMed.SMD.IODictionaryI("IndexIDCode",xIDCode,xID))
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
			
			//过滤接口字典中的分类项目
			Set SubIDCode=$o(^DHCMed.SMD.IODictionaryI("IndexIDCode"," "_IDCode_"0"))
			Continue:$e(SubIDCode,2,$l(IDCode)+1)=IDCode
			
			Set Count=Count+1
			
			Set Data=$lb(xID,Code,Desc,Spell)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryIODicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIODicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIODicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIODicByTypeExecute ]
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
<DataLocation>^DHCMed.SMD.IODictionaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SMD.IODictionaryI</IdLocation>
<IndexLocation>^DHCMed.SMD.IODictionaryI</IndexLocation>
<StreamLocation>^DHCMed.SMD.IODictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
