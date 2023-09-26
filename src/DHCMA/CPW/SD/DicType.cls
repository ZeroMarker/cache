/// 单病种值域字典类型
Class DHCMA.CPW.SD.DicType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 病种
Property BTQCDr As DHCMA.CPW.SD.QCEntity;

/// 病种项目信息
Property QCItemDr As DHCMA.CPW.SD.QCEntityItem;

/// 病种版本
Property QCVersion As DHCMA.CPW.SD.QCEntityVersion;

/// 备注
Property BTResume As %String;

/// 备注2
Property BTResume2 As %String;

/// 备注3
Property BTResume3 As %String;

Property IsActive As %Boolean;

/// 加入版本信息后，根据Code直接索引作废（2020-10-20）
Index IdxofCode On BTCode;

/// 病种+版本+Code索引
Index IdxofQCVerCode On (BTQCDr, QCVersion, BTCode) [ Unique ];

/// 版本索引
Index IdxofVersion On QCVersion;

/// 项目索引
Index IdxofItemDR On QCItemDr;

Index IdxofQCDr On BTQCDr;

/// Table：       DHCMA.CPW.SD.DicType
/// Input：       aId : DHCMA.CPW.SD.DicType.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.DicType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.DicType
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.DicType).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.DicType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Description:  根据Code取值域字典类型
/// Table：       DHCMA.CPW.SD.DicType
/// Input：       aCode : DHCMA.CPW.SD.DicType.Code
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.DicType).GetObjByCode("33","2","VTE-0-1-1-c")
ClassMethod GetObjByCode(aQCID, aVersion, aCode As %String) As DHCMA.CPW.SD.DicType
{
	New (aQCID,aVersion,aCode)
	Quit:(aQCID="")||(aVersion="")||(aCode="") ""
	Set ID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",aQCID,aVersion," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Description:  更新值域字典类型
/// Table：       DHCMA.CPW.SD.DicType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.DicType).Update("^STK-8-5-0^是否出院时有高血压^1^1^^^2","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set QCDr	 = $p(aInputStr,aSeparete,4)
	Set Active	 = $p(aInputStr,aSeparete,5)
	Set Resume	 = $p(aInputStr,aSeparete,6)
	Set ItemDr 	 = $p(aInputStr,aSeparete,7)
	Set QCVersion = $p(aInputStr,aSeparete,8)
	Set Resume2 = $p(aInputStr,aSeparete,9)
	Set Resume3 = $p(aInputStr,aSeparete,10)
	If (ItemDr="") {
		//自动与当前版本项目对照
		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(QCVersion,QCDr,Code)
		Quit:'$IsObject(ItemObj) return	
		Set ItemDr=ItemObj.%Id()
	}
	Quit:(Code="")||(Desc="")||(ItemDr="")||(QCVersion="") return 
	Set objQC=##class(DHCMA.CPW.SD.QCEntity).GetObjById(QCDr)
	Quit:'$IsObject(objQC) return
	Set tID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",QCDr,QCVersion," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2

	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.DicType).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.DicType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTQCDr     = objQC
	Set obj.IsActive   = Active
	Set obj.BTResume   = Resume
	Set obj.BTResume2  = Resume2
	Set obj.BTResume3  = Resume3
	
	//如果有版本、关联项目信息进行更新
	If (ItemDr'="") {
		Set obj.QCItemDr   = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemDr)
	}
	If (QCVersion'="") {
		Set obj.QCVersion=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjById(QCVersion)
	}
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

/// Table：       DHCMA.CPW.SD.DicType
/// Input：       aId : DHCMA.CPW.SD.DicType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.DicType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.DicType).%DeleteId(aId)
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
<Data name="DicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTQCDr</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>BTResume</Value>
</Value>
<Value name="7">
<Value>BTResume2</Value>
</Value>
<Value name="8">
<Value>BTResume3</Value>
</Value>
<Value name="9">
<Value>QCItemDr</Value>
</Value>
<Value name="10">
<Value>QCVersion</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.DicTypeD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.DicTypeD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.DicTypeI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.DicTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
