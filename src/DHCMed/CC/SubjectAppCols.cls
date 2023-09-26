/// 名称: DHCMed.CC.SubjectAppColsCols
/// 描述: 监控主题应用列表属性
/// 编写者：zhufei
/// 编写日期: 2010-05-07
Class DHCMed.CC.SubjectAppCols Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship SACParref As DHCMed.CC.SubjectApp [ Cardinality = parent, Inverse = ChildAppCols ];

/// 列名称
Property SACName As %String;

/// 列描述
Property SACDesc As %String;

/// 是否隐藏
Property SACIsHide As %Boolean;

/// 宽度
Property SACWidth As %Integer;

/// 是否排序
Property SACIsSort As %Boolean;

/// 列序号
Property SACIndex As %String;

/// 根据列序号建索引
Index IndexSort On (SACParref As String, SACIndex As String);

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SACName 3:SACDesc 4:SACIsHide 5:SACWidth 6:SACIsSort 7:SACIndex
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..SACName_separete
	set return=return_..SACDesc_separete
	set return=return_..SACIsHide_separete
	set return=return_..SACWidth_separete
	set return=return_..SACIsSort_separete
	set return=return_..SACIndex
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题应用列表属性
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       ID:    DHCMed.CC.SubjectAppCols.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectAppCols).GetObjById("1||1")
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectAppCols
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectAppCols).%ExistsId(id) return
	set obj=##Class(DHCMed.CC.SubjectAppCols).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题应用列表属性
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       ID:    DHCMed.CC.SubjectAppCols.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectAppCols).GetStringById("1||1")
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
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:SACName 3:SACDesc 4:SACIsHide 5:SACWidth 6:SACIsSort 7:SACIndex
/// w ##class(DHCMed.CC.SubjectAppCols).Update("ID^SACName^SACDesc^SACIsHide^SACWidth^SACIsSort^SACIndex")
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
		set obj=##class(DHCMed.CC.SubjectAppCols).%New()
	} else {
		set obj=##class(DHCMed.CC.SubjectAppCols).%OpenId(ID)
	}
	set objParref=##class(DHCMed.CC.SubjectApp).%OpenId(Parref)
	set obj.SACParref=objParref
	set obj.SACName=$p(InStr,"^",2)
	set obj.SACDesc=$p(InStr,"^",3)
	set obj.SACIsHide=$p(InStr,"^",4)
	set obj.SACWidth=$p(InStr,"^",5)
	set obj.SACIsSort=$p(InStr,"^",6)
	set obj.SACIndex=$p(InStr,"^",7)
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
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       SubjectAppId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CC.SubjectAppCols).DeleteById("1||1")
ClassMethod DeleteById(Id As %String) As %Boolean
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectAppCols).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	} else {
		set ret=0
	}
	quit ret
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.CC.SubjectAppCols","QueryAll")
Query QueryAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,SACName:%String,SACDesc:%String,SACIsHide:%String,SACWidth:%String,SACIsSort:%String,SACIndex:%String")
{
	SELECT %ID,SACName,SACDesc,SACIsHide,SACWidth,SACIsSort,SACIndex FROM DHCMed_CC.SubjectAppCols Order by SACIndex desc
}

/// Creator：     zhufei
/// CreatDate：   2010-05-31
/// Description:  添加内容
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       多条主题监控列属性设置值
/// Return：      成功：返回1，失败：返回0
/// w ##class(DHCMed.CC.SubjectAppCols).InsertDataToSubAppCols(argInput)
ClassMethod InsertDataToSubAppCols(argInput As %String) As %Integer
{
	New (argInput)
	Set return=0
	
	TStart
	Set ChildID=""
	For {
		Set ChildID=$o(^DHCMed.CC.SubjectAppD(+argInput,"ChildAppCols",ChildID))
		Quit:ChildID=""
		Set ID=+argInput_"||"_ChildID
		Set return=..DeleteById(ID)
		If return<0 TRollBack
		Quit:return<0
	}
	Quit:return<0 return
	
	For Ind=1:1:$l(argInput,$c(1))
	{
		Set Input=$p(argInput,$c(1),Ind)
		Set return=..Update(Input)
		If return<0 TRollBack
		Quit:return<0
	}
	Quit:return<0 return
	TCommit
	
	Set return=1
	Quit return
}

Storage Default
{
<Data name="SubjectAppColsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SACName</Value>
</Value>
<Value name="3">
<Value>SACDesc</Value>
</Value>
<Value name="4">
<Value>SACIsHide</Value>
</Value>
<Value name="5">
<Value>SACWidth</Value>
</Value>
<Value name="6">
<Value>SACIsSort</Value>
</Value>
<Value name="7">
<Value>SACIndex</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildAppCols")</DataLocation>
<DefaultData>SubjectAppColsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildAppCols")</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectAppColsI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectAppColsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
