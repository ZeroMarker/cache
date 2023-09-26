/// 名称: DHCMed.SS.Message
/// 描述: 消息记录表
/// 编写者：zhufei
/// 编写日期: 2010-06-17
Class DHCMed.SS.Message Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// MessageDr 消息 指向 SS_Message
Property MessageDr As %Integer;

/// PaadmDr 病人 指向 PA_Adm
Property PaadmDr As %Integer;

/// 根据就诊号建的索引
Index IndexPaadm On PaadmDr;

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.Message
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:MessageDr 3:PaadmDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..MessageDr_separete
	set return=return_..PaadmDr
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  根据ID取消息记录
/// Table：       DHCMed.SS.Message
/// Input：       ID:    DHCMed.SS.Message.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Message).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Message
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Message).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Message).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  根据ID消息记录
/// Table：       DHCMed.SS.Message
/// Input：       id: DHCMed.SS.Message.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Message).GetStringById(1,"")
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
/// CreatDate：   2010-06-24
/// Description:  更新消息记录
/// Table：       DHCMed.SS.Message
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CDCode 3:CDDesc 4:CDType 5:CDExpression 6:CDResume
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.SS.Message).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.Message).%OpenId(ID)
		}
	set obj.MessageDr=$p(InStr,"^",2)
	set obj.PaadmDr=$p(InStr,"^",3)
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
/// CreatDate：   2010-06-24
/// Description:  删除消息记录
/// Table：       DHCMed.SS.Message
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.SS.Message).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageDr</Value>
</Value>
<Value name="3">
<Value>PaadmDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.MessageD</IdLocation>
<IndexLocation>^DHCMed.SS.MessageI</IndexLocation>
<StreamLocation>^DHCMed.SS.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
