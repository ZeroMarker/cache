/// 名称: DHCMed.CC.SubjectAppSub
/// 描述: 监控主题应用监控项目
/// 编写者：zhufei
/// 编写日期: 2010-05-07
Class DHCMed.CC.SubjectAppSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship SASParref As DHCMed.CC.SubjectApp [ Cardinality = parent, Inverse = ChildAppSub ];

/// 监控项目
Property SASItemDr As %Integer;

/// 项目类型
Property SASItemType As %Integer;

/// 项目分值
Property SASItemScore As %Integer;

/// 分科监控
Property SASLocDr As %Integer;

/// 分组监控
Property SASGroupDr As %Integer;

/// 备注
Property SASResume As %String(TRUNCATE = 1);

/// 以项目类型建索引
Index IndexItemType On SASItemType;

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectAppSub
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SASItemDr 3:SASItemType 4:SASItemScore 5:SASLocDr 6:SASGroupDr 7:SASResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..SASItemDr_separete
	set return=return_..SASItemType_separete
	set return=return_..SASItemScore_separete
	set return=return_..SASLocDr_separete
	set return=return_..SASGroupDr_separete
	set return=return_..SASResume
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题应用监控项目
/// Table：       DHCMed.CC.SubjectAppSub
/// Input：       ID:    DHCMed.CC.SubjectAppSub.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectAppSub).GetObjById("1||1")
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectAppSub
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectAppSub).%ExistsId(id) return
	set obj=##Class(DHCMed.CC.SubjectAppSub).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题应用监控项目
/// Table：       DHCMed.CC.SubjectAppSub
/// Input：       ID:    DHCMed.CC.SubjectAppSub.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectAppSub).GetStringById("1||1")
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

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  更新SubjectAppCols
/// Table：       DHCMed.CC.SubjectAppSub
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:SASItemDr 3:SASItemType 4:SASItemScore 5:SASLocDr 6:SASGroupDr 7:SASResume
/// w ##class(DHCMed.CC.SubjectAppSub).Update("ID^SASItemDr^SASItemType^SASItemScore^SASLocDr^SASGroupDr^SASResume")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=-1
	set ID=$p(InStr,"^",1)
	set Parref=$p(ID,"||",1)
	set ChildSub=$p(ID,"||",2)
	quit:Parref="" id
	quit:'##class(DHCMed.CC.SubjectApp).%ExistsId(Parref) id
	if ChildSub="" {
		set obj=##class(DHCMed.CC.SubjectAppSub).%New()
	} else {
		set obj=##class(DHCMed.CC.SubjectAppSub).%OpenId(ID)
	}
	set objParref=##class(DHCMed.CC.SubjectApp).%OpenId(Parref)
	set obj.SASParref=objParref
	set obj.SASItemDr=$p(InStr,"^",2)
	set obj.SASItemType=$p(InStr,"^",3)
	set obj.SASItemScore=$p(InStr,"^",4)
	set obj.SASLocDr=$p(InStr,"^",5)
	set obj.SASGroupDr=$p(InStr,"^",6)
	set obj.SASResume=$p(InStr,"^",7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do objParref.%Close()
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  删除SubjectApp
/// Table：       DHCMed.CC.SubjectAppSub
/// Input：       SubjectAppId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CC.SubjectAppSub).DeleteById("1||1")
ClassMethod DeleteById(Id As %String) As %Boolean
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectAppSub).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	} else {
		set ret=0
	}
	quit ret
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.CC.SubjectAppSub","QueryAll")
Query QueryAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,SASItemDr:%String,SASItemType:%String,SASItemScore:%String,SASLocDr:%String,SASGroupDr:%String,SASResume:%String")
{
	SELECT %ID,SASItemDr,SASItemType,SASItemScore,SASLocDr,SASGroupDr,SASResume FROM DHCMed_CC.SubjectAppSub Order by SASItemType desc
}

Storage Default
{
<Data name="SubjectAppSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SASItemDr</Value>
</Value>
<Value name="3">
<Value>SASItemType</Value>
</Value>
<Value name="4">
<Value>SASItemScore</Value>
</Value>
<Value name="5">
<Value>SASLocDr</Value>
</Value>
<Value name="6">
<Value>SASGroupDr</Value>
</Value>
<Value name="7">
<Value>SASResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildAppSub")</DataLocation>
<DefaultData>SubjectAppSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildAppSub")</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectAppSubI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectAppSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
