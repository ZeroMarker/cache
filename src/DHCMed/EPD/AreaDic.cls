/// 名称: DHCMed.EPD.AreaDic
/// 描述: 省市区县字典
/// 编写者：zhufei
/// 编写日期: 2012-07-31
Class DHCMed.EPD.AreaDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 缩写
Property ShortDesc As %String(TRUNCATE = 1);

/// 全名
Property LongDesc As %String(TRUNCATE = 1);

/// 等级   1:省级 2:市级 3:县级 4:乡镇街道
Property RankCode As %String(TRUNCATE = 1);

/// 父节点
Property ParentId As %String(TRUNCATE = 1);

/// 别名1
Property Alias1 As %String(TRUNCATE = 1);

/// 别名2
Property Alias2 As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

/// 代码 索引
Index CodeIndex On Code As SqlString;

/// 别名1 索引
Index AliasIndex On Alias1 As AlphaUp;

/// 父节点 索引
Index ParentIndex On ParentId As SqlString;

/// w ##Class(DHCMed.EPD.AreaDic).GetObjById(1)
ClassMethod GetObjById(argId As %String) As DHCMed.EPD.AreaDic
{
	New (argId)
	Set obj=##Class(DHCMed.EPD.AreaDic).%OpenId(argId)
	If obj'="" Do obj.%Close()
	Quit obj
}

/// w ##class(DHCMed.EPD.AreaDic).GetShordDescById(103)
ClassMethod GetShordDescById(argId) As %String
{
	New (argId)
	Set return=""
	Quit:argId="" return
	Quit:'##class(DHCMed.EPD.AreaDic).%ExistsId(argId) return
	Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(argId)
	Quit:'$IsObject(obj) return
	Set return=obj.ShortDesc
	Quit return
}

/// Do ##class(%ResultSet).RunQuery("DHCMed.EPD.AreaDic","QryArea","","1","","","","1")
Query QryArea(aId As %String, aParentId As %String, aCode As %String, aAlias As %String, aShortDesc As %String, aFlag As %String = "") As %Query(ROWSPEC = "ID:%String,Alias1:%String,Alias2:%String,Code:%String,LongDesc:%String,ParentId:%String,RankCode:%String,ShortDesc:%String")
{
}

ClassMethod QryAreaExecute(ByRef qHandle As %Binary, aId As %String, aParentId As %String, aCode As %String, aAlias As %String, aShortDesc As %String, aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aId'="") {
		Set Data=$$BuildQryArea(aId,aFlag)
		If Data'="" {
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit:aParentId="" $$$OK
	Set objParent=##Class(DHCMed.EPD.AreaDic).GetObjById(aParentId)
	Quit:'$IsObject(objParent) $$$OK
	Set ParentCode=objParent.Code
	
	If ParentCode="0" {
		Set ParentCode=""
	} ElseIf ParentCode="00000000" {
		Set ParentCode=""
	} ElseIf $e(ParentCode,3,8)="000000" {
		Set ParentCode=$e(ParentCode,1,2)
	} ElseIf $e(ParentCode,5,8)="0000" {
		Set ParentCode=$e(ParentCode,1,4)
	} ElseIf $e(ParentCode,7,8)="00" {
		Set ParentCode=$e(ParentCode,1,6)
	} Else {
		Set ParentCode=ParentCode
	}
	For indDic=1:1:99 {
		Set Code=indDic
		Set:$l(Code)<2 Code="0"_Code
		Set Code=ParentCode_Code
		If $l(Code)=2 {
			Set Code=Code_"000000"
		} ElseIf $l(Code)=4 {
			Set Code=Code_"0000"
		} ElseIf $l(Code)=6 {
			Set Code=Code_"00"
		} Else {
			Set Code=Code
		}
		
		Set RowID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_Code,0))
		Continue:RowID=""
		Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Set IsActive=obj.IsActive
		Continue:IsActive'=1
		Continue:((aCode'="")&&($e(obj.Code,1,$l(aCode))'[aCode))
		Continue:((aAlias'="")&&($e(obj.Alias1,1,$l(aAlias))'[aAlias))
		Continue:((aShortDesc'="")&&($e(obj.ShortDesc,1,$l(aShortDesc))'[aShortDesc))
		
		Set Data=$$BuildQryArea(RowID,aFlag)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
	
BuildQryArea(xId,aflag)
	New (xId,aflag,%session)
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(xId)
	Quit:'$IsObject(obj) ""
	Set Data=$lb("")
	Set $li(Data,1)=obj.%Id()
	Set $li(Data,2)=obj.Alias1
	Set $li(Data,3)=obj.Alias2
	Set $li(Data,4)=obj.Code
	Set $li(Data,5)=obj.LongDesc
	Set $li(Data,6)=obj.ParentId
	Set $li(Data,7)=obj.RankCode
	Set ShortDesc  =obj.ShortDesc
	if (aflag=1){
		Set ShortDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,obj.ShortDesc)	
	}
	if (aflag=2){
		Set ShortDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,obj.ShortDesc)
	}
	if (aflag=3){
		Set ShortDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,obj.ShortDesc)
	}
	if (aflag=4){
		Set ShortDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,obj.ShortDesc)
	}
	Set $li(Data,8)=ShortDesc
	Quit Data
}

ClassMethod QryAreaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMed.EPD.AreaDic).Update("^2^3^4^1^2^3^4^1")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	
	set ID=$p(InStr,"^",1)
	set Code=$p(InStr,"^",2)
	quit:Code="" id
	;Set ID=$o(^DHCMed.EPD.AreaDicI("CodeIndex"," "_Code,0))
	Set:ID="" ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_Code,0)) //修改传染病管理中省市县乡维护的保存问题
	
	
	if ID="" {
		set obj=##class(DHCMed.EPD.AreaDic).%New()
	} else {
		set obj=##class(DHCMed.EPD.AreaDic).%OpenId(ID)
	}
	set obj.Code=$p(InStr,"^",2)
	set obj.ShortDesc=$p(InStr,"^",3)
	set obj.LongDesc=$p(InStr,"^",4)
	set obj.RankCode =$p(InStr,"^",5)
	set obj.ParentId =$p(InStr,"^",6)
	set obj.Alias1 =$p(InStr,"^",7)
	set obj.Alias2 =$p(InStr,"^",8)
	set obj.IsActive =$p(InStr,"^",9)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// 检查增加数据时代码是否重复
/// w ##class(DHCMed.EPD.AreaDic).CheckCode("21000000")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=0
	Quit:aCode="" return
	
	Set xID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_aCode,0))
	Set:(xID>0) return=1
	Quit return
}

/// 设置无效
/// w ##class(DHCMed.EPD.AreaDic).CheckCode("21000000")
ClassMethod CheckActive(aCode As %String, aIsActive As %String = "1") As %String
{
	New (aCode,aIsActive)
	Set return=0
	Quit:aCode="" return
	
	Set xID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_aCode,0))
	Set obj=##class(DHCMed.EPD.AreaDic).%OpenId(xID)
	Set obj.IsActive=aIsActive
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ShortDesc</Value>
</Value>
<Value name="4">
<Value>LongDesc</Value>
</Value>
<Value name="5">
<Value>RankCode</Value>
</Value>
<Value name="6">
<Value>ParentId</Value>
</Value>
<Value name="7">
<Value>Alias1</Value>
</Value>
<Value name="8">
<Value>Alias2</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPDC("AREADIC")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.EPDC("AREADIC")</IdLocation>
<IndexLocation>^DHCMed.EPDCi("AREADIC")</IndexLocation>
<StreamLocation>^DHCMed.EPD.AreaDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
