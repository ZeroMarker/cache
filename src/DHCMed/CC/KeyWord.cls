Class DHCMed.CC.KeyWord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property IsActive As %Boolean;

Property Resume As %String(TRUNCATE = 1);

/// 时间线子项代码  只允许(10101-19901)  //form 101 to 10101 by wuqk 2013-04-08
Property TimeLineCode As %String(TRUNCATE = 1);

/// 代码索引（唯一索引）
Index IndexCode On Code [ Unique ];

Method ToString(seperator As %String = "^")
{
	Set ret=..%Id()_seperator
	Set ret=ret_..Code_seperator
	Set ret=ret_..Description_seperator
	Set ret=ret_..IsActive_seperator
	Set ret=ret_..Resume_seperator
	Set ret=ret_..TimeLineCode
	Quit ret
}

/// Creator：     liuyh
/// CreatDate：   2012-06-15
/// Description:  根据ID取关键字信息
/// Table：       DHCMed.CC.KeywordInfo
/// Input：       ID:    DHCMed.CC.KeywordInfo.ProductID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// d ##class(DHCMed.CC.KeyWord).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.KeyWord
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.KeyWord).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.KeyWord).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

ClassMethod GetObjByCode(Code As %String) As DHCMed.CC.KeyWord
{
	new (Code)
	set return=""
	quit:Code="" return
	Set Code=$ZConvert(Code,"T")
	Set id=$o(^DHCMed.CCi("Keyword","IndexCode"," "_Code,""))
	quit:'##class(DHCMed.CC.KeyWord).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.KeyWord).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

ClassMethod GetIDByCode(Code As %String) As %String
{
	new (Code)
	set return=""
	quit:Code="" return
	Set Code=$ZConvert(Code,"T")
	Set id=$o(^DHCMed.CCi("Keyword","IndexCode"," "_Code,""))
	Quit id
}

/// Creator：     likai
/// CreatDate：   2012-06-15
/// Description:  根据ID取关键字信息
/// Table：       DHCMed.CC.KeywordInfo
/// Input：       ID:    DHCMed.CC.KeywordInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.KeywordInfo).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     likai
/// CreatDate：   2012-06-15
/// Description:  更新关键字信息字典
/// Table：       DHCMed.CC.KeywordInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ProductID 3:Code 4:Description 5 IsActive 6 Resume
///  w ##class(DHCMed.CC.KeyWord).Update("6^05^体温^3^0^liyi")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	
	//处理重复导数据的问题
	set ID=$p(InStr,"^",1)
	set Code=$p(InStr,"^",2)
	quit:Code="" -1
	if ID="" {
		set ID=$o(^DHCMed.CCi("Keyword","IndexCode"," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.CC.KeyWord).%New()
	} else {
		set obj=##class(DHCMed.CC.KeyWord).%OpenId(ID)
	}
	set obj.Code=$p(InStr,"^",2)
	set obj.Description=$p(InStr,"^",3)
	set obj.IsActive=+$p(InStr,"^",4)
	set obj.Resume=$p(InStr,"^",5)
	
	//时间线子项代码  只允许(10101-19901)
	set TimeLineCode=+$p(InStr,"^",6)
	if (TimeLineCode>19901)||(TimeLineCode<10101) {
		set TimeLineCode=""
	}
	set obj.TimeLineCode=TimeLineCode  //时间线子项代码
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     likai
/// CreatDate：   2012-06-15
/// Description:  删除关键字信息
/// Table：       DHCMed.CC.KeyWord
/// Input：       ProductID
/// Return：      成功：返回0，失败：返回<0的代码
///  w ##class(DHCMed.CC.KeyWord).Update("^2^3^4^0^6")
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.KeyWord).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

ClassMethod ClearKeyWord() As %String
{
	New
	Set RowID=0
	For {
		Set RowID=$o(^DHCMed.CC("Keyword",RowID))
		Quit:RowID=""
		Set flg=..DeleteById(RowID)
	}
	Quit 1
}

Storage Default
{
<Data name="KeyWordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeLineCode</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("Keyword")</DataLocation>
<DefaultData>KeyWordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("Keyword")</IdLocation>
<IndexLocation>^DHCMed.CCi("Keyword")</IndexLocation>
<StreamLocation>^DHCMed.CCS("Keyword")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
