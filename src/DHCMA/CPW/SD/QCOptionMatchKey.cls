/// 描述: 单病种质控项目选项对照（关键字）
Class DHCMA.CPW.SD.QCOptionMatchKey Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目字典
Property ItemOptionDr As DHCMA.CPW.SD.Dictionary;

/// 关键字包含
Property DicKey As %String;

/// 关键字过滤
Property DicFilter As %String;

Index IdxDicDR On ItemOptionDr;

/// w ##class(DHCMA.CPW.SD.QCOptionMatchKey).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCOptionMatchKey
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCOptionMatchKey).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCOptionMatchKey).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCOptionMatchKey).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ItemOptionDr	= $p(aInputStr,aSeparete,1)
	Set DicKey       	= $p(aInputStr,aSeparete,2)
	Set DicFilter       = $p(aInputStr,aSeparete,3)
	Quit:ItemOptionDr="" return
	Set RowID=$o(^DHCMA.CPW.SD.QCOptionMatchKeyI("IdxDicDR",ItemOptionDr,0))
	If (RowID="") { 
		Set obj=##class(DHCMA.CPW.SD.QCOptionMatchKey).%New()
	}else{
		Set obj=##class(DHCMA.CPW.SD.QCOptionMatchKey).%OpenId(RowID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ItemOptionDr	= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemOptionDr)
	Set obj.DicKey        	=  DicKey
	Set obj.DicFilter       =  DicFilter
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

/// w ##class(DHCMA.CPW.SD.QCOptionMatchKey).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCOptionMatchKey).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCOptionMatchKey).GetKeyInfoByDicId(10817)
ClassMethod GetKeyInfoByDicId(aDicId As %String) As %String
{
	New (aDicId)
	Set return=""
	Quit:aDicId="" return
	Set RowID=$o(^DHCMA.CPW.SD.QCOptionMatchKeyI("IdxDicDR",aDicId,0))
	
	//Quit:RowID="" return
	Set obj=##Class(DHCMA.CPW.SD.QCOptionMatchKey).GetObjById(RowID)
	If ($IsObject(obj)) {
		//从值域对照获取关键字信息
		Set DicKey=obj.DicKey
		Set DicFilter=obj.DicFilter
		Set return=DicKey_"^"_DicFilter
		//Do obj.%Close()
	}else{
		//从常用短语获取关键字信息
		Set Dicobj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(aDicId)
		Set DicDesc=Dicobj.BTDesc
		Set xDicId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",DicDesc,0))
		Quit:xDicId="" return
		Set xDicSubId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",DicDesc,xDicId,0))
		Set objDic=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(xDicId_"||"_xDicSubId)
		//Continue:'$IsObject(objDic) 
		
		Set DicID=objDic.%Id()
		Set KeyId=$o(^DHCMA.CPW.SD.Stand.KeyInfoI("IdxDic",DicID,0))
		Quit:KeyId="" return
		Set Keyobj=##class(DHCMA.CPW.SD.Stand.KeyInfo).GetObjById(KeyId)
		Set DicKey=Keyobj.ResultKeys
		Set DicFilter=Keyobj.ResultFilter
		Set return=DicKey_"^"_DicFilter
	}
	Quit return
}

Storage Default
{
<Data name="QCOptionMatchKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemOptionDr</Value>
</Value>
<Value name="3">
<Value>AntiItem</Value>
</Value>
<Value name="4">
<Value>DicKey</Value>
</Value>
<Value name="5">
<Value>DicFilter</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCOptionMatchKeyD</DataLocation>
<DefaultData>QCOptionMatchKeyDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCOptionMatchKeyD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCOptionMatchKeyI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCOptionMatchKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
