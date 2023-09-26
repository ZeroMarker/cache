/// 名称: DHCMed.CC.ContentDic
/// 描述: 监控内容字典
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CC.ContentDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 监控内容代码
Property CDCode As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 监控内容描述
Property CDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 类型
Property CDType As %String(TRUNCATE = 1) [ Required ];

/// 监控表达式
Property CDExpression As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property CDResume As %String(MAXLEN = 100, TRUNCATE = 1);

Index CDCodeIndex On CDCode [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.ContentDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:CDCode 3:CDDesc 4:CDType 5:CDExpression 6:CDResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CDCode_separete
	set return=return_..CDDesc_separete
	set return=return_..CDType_separete
	set return=return_..CDExpression_separete
	set return=return_..CDResume
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控内容字典信息
/// Table：       DHCMed.CC.ContentDic
/// Input：       ID:    DHCMed.CC.ContentDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ContentDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.ContentDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.ContentDic).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.ContentDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控内容字典信息
/// Table：       DHCMed.CC.ContentDic
/// Input：       ID:    DHCMed.CC.ContentDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ContentDic).GetStringById(1)
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

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  更新监控内容字典
/// Table：       DHCMed.CC.ContentDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CDCode 3:CDDesc 4:CDType 5:CDExpression 6:CDResume
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.ContentDic).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.ContentDic).%OpenId(ID)
		}
	set obj.CDCode=$p(InStr,"^",2)
	set obj.CDDesc=$p(InStr,"^",3)
	set obj.CDType=$p(InStr,"^",4)
	set obj.CDExpression=$p(InStr,"^",5)
	set obj.CDResume=$p(InStr,"^",6)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  删除监控内容
/// Table：       DHCMed.CC.ContentDic
/// Input：       ContentDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.ContentDic).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CDCode,CDDesc,CDType,CDExpression,CDResume FROM ContentDic Order by %ID desc
}

Storage Default
{
<Data name="ContentDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDCode</Value>
</Value>
<Value name="3">
<Value>CDDesc</Value>
</Value>
<Value name="4">
<Value>CDExpression</Value>
</Value>
<Value name="5">
<Value>CDResume</Value>
</Value>
<Value name="6">
<Value>CDType</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.ContentDicD</DataLocation>
<DefaultData>ContentDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.ContentDicD</IdLocation>
<IndexLocation>^DHCMed.CC.ContentDicI</IndexLocation>
<StreamLocation>^DHCMed.CC.ContentDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
