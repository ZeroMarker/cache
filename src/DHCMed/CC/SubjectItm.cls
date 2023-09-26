/// 名称: DHCMed.CC.SubjectItm
/// 描述: 监控主题监控项目
/// 编写者：zhufei
/// 编写日期: 2010-11-04
Class DHCMed.CC.SubjectItm Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 所属的Subject的ID
Property SubjectID As %Integer;

/// 代码
Property Code As %String;

/// 相关的监控项目字典
Property ItemDic As %Integer;

/// 是否生效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String;

/// 分数
Property Score As %Float;

/// 多次扣分  Add  By LiYang 2010-10-19
Property MultiTimes As %Boolean;

/// 是否绝对条件
Property IsAbsolute As %Boolean;

/// 是否是敏感条件 Add By LiYang 2012-07-06
Property IsSensitive As %Boolean;

/// 是否是特异性条件 Add By LiYang 2012-07-06
Property IsSpecificity As %Boolean;

/// 只运行一次
Property IsRunOnce As %Boolean;

/// 就诊类型
Property AdmType As %String;

Index IndexSubjectID On (SubjectID, IsActive);

Index SubjectCodeIndex On (SubjectID, Code);

Index IndexItemDic On (SubjectID, ItemDic) [ Unique ];

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectItm
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:SubjectID 2:Code 3:ItemDic 4:IsActive 5:Score 6:ResumeText 7:MultiTimes
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..SubjectID_separete
	set return=return_..Code_separete
	set return=return_..ItemDic_separete
	set return=return_..IsActive_separete
	set return=return_..Score_separete
	set return=return_..ResumeText_separete
	set retutn=return_..MultiTimes_separete
	set return=return_..IsAbsolute_separete
	set return=return_..IsSensitive_separete
	set return=return_..IsSpecificity_separete
	set return=return_..AdmType
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题信息
/// 
/// Table：       DHCMed.CC.Subject
/// Input：       ID:    DHCMed.CC.SubjectItm.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectItm).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectItm
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectItm).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectItm).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取监控主题信息
/// 
/// Table：       DHCMed.CC.SubjectItm
/// Input：       ID:    DHCMed.CC.SubjectItm.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectItm).GetStringById(1)
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

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取监控主题信息
/// 
/// Table：       DHCMed.CC.SubjectItm
/// 输入格式： RowID^SubjectID^ItemDic^Score^IsActive^ResumeText^MultiTimes
/// d ##class(DHCMed.CC.SubjectItm).Update("^1^1^1^100^1^备注^")
ClassMethod Update(InStr As %String, seperator As %String = "^") As %Integer
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectItm).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectItm).%OpenId(ID)
		}
	set obj.SubjectID=$p(InStr,seperator,2)
	set obj.Code=$p(InStr,seperator,3)
	set obj.ItemDic=$p(InStr,seperator,4)
	set obj.Score=+$p(InStr,seperator,5)
	set obj.IsActive=$s($p(InStr,seperator,6)["Y":1,1:0)
	set obj.ResumeText=$p(InStr,seperator,7)
	set obj.MultiTimes=$s($p(InStr,seperator,8)["Y":1,1:0)
	set obj.IsAbsolute=$s($p(InStr,seperator,9)["Y":1,1:0)
	set obj.IsSensitive=$s($p(InStr,seperator,10)["Y":1,1:0)
	set obj.IsSpecificity=$s($p(InStr,seperator,11)["Y":1,1:0)
	Set obj.IsRunOnce=$s($p(InStr,seperator,12)["Y":1,1:0)
	Set obj.AdmType=$p(InStr,seperator,13)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取监控主题条目的信息
/// 参数：SubjectID  监控主题的ID
ClassMethod GetItmListBySubjectID(SubjectID As %Integer) As %ListOfObjects
{
	n (SubjectID)
	s arry=##class(%Library.ListOfObjects).%New()
	s rowid="" f  s rowid=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,1,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.SubjectItm).GetObjById(rowid)
	.d obj.%Close()
	.d arry.Insert(obj)
	q arry
}

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  删除监控项目
/// Table：       DHCMed.CC.SbujectItm
/// Input：       ItemId
/// Return：      ret>0:成功  ret<0:失败
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectItm).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功

   		//d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="SubjectItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Expression</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>SubjectID</Value>
</Value>
<Value name="8">
<Value>Score</Value>
</Value>
<Value name="9">
<Value>ItemDic</Value>
</Value>
<Value name="10">
<Value>MultiTimes</Value>
</Value>
<Value name="11">
<Value>IsAbsolute</Value>
</Value>
<Value name="12">
<Value>IsSensitive</Value>
</Value>
<Value name="13">
<Value>IsSpecificity</Value>
</Value>
<Value name="14">
<Value>IsRunOnce</Value>
</Value>
<Value name="15">
<Value>AdmType</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("SItem")</DataLocation>
<DefaultData>SubjectItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("SItem")</IdLocation>
<IndexLocation>^DHCMed.CCi("SItem",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
