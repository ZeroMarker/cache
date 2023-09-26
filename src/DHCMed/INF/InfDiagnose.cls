/// 名称: DHCMed.INF.InfDiagnose
/// 描述: 医政管理感染诊断
/// 编写者：ChenJB
/// 编写日期: 2010-05-11
Class DHCMed.INF.InfDiagnose Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// ICD编码
Property ICD As %String [ Required ];

/// 疾病名称
Property DiseaseName As %String [ Required ];

/// 疾病类型
Property Type As %String;

/// 是否有效
Property Active As %Boolean;

/// 拼音
Property Alias As %String [ Required ];

/// 备注
Property ResumeText As %String;

/// 拼音别名
Index Alias On Alias;

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  将对象格式化为字符串
/// Table：       DHCMed_INF.InfDiagnose
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ICD_separete
	set return=return_..DiseaseName_separete
	set return=return_..Type_separete
	set return=return_..Active_separete
	set return=return_..Alias_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取疾病信息
/// Table：       DHCMed_INF.InfDiagnose
/// Input：       ID:    DHCMed.INF.InfDiagnose.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfDiagnose).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfDiagnose
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfDiagnose).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfDiagnose).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取疾病信息
/// Table：       DHCMed_INF.InfDiagnose
/// Input：       ID:    DHCMed.INF.InfDiagnose.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfDiagnose).GetStringById(1)
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  更新疾病信息
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfDiagnose).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfDiagnose).%OpenId(ID)
		}
	set obj.ICD=$p(InStr,separete,2)
	set obj.DiseaseName=$p(InStr,separete,3)
	set obj.Type=$p(InStr,separete,4)
	set obj.Active=+$p(InStr,separete,5)
	set obj.Alias=$p(InStr,separete,6)
	set obj.ResumeText=$p(InStr,separete,7)
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  删除疾病
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfDiagnose).%DeleteId(+Id)
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
<Data name="InfDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>DiseaseName</Value>
</Value>
<Value name="5">
<Value>ICD</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfDiagnoseD</DataLocation>
<DefaultData>InfDiagnoseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfDiagnoseD</IdLocation>
<IndexLocation>^DHCMed.INF.InfDiagnoseI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
