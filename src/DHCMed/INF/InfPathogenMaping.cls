/// 名称: DHCMed.INF.InfPathogenMaping
/// 描述: 医政管理 辅助检查的病原体对照表
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.InfPathogenMaping Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 辅助检查病原体Code
Property Code As %String [ Required ];

/// 辅助检查病原体描述
Property Description As %String(MAXLEN = 1000) [ Required ];

/// 标准病原体 DHC_Med.INF.InfPathogenDic
Property PatID As %String [ Required ];

/// 有效
Property Active As %Boolean;

/// 开始日期
Property DateFrom As %Date;

/// 结束日期
Property DateTo As %Date;

/// 备注
Property ResumeText As %String;

/// 抗生素编码索引
Index Code On Code [ Unique ];

/// 名称索引
Index Description On Description;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: Code 3: Description 4: PatID 5: Active 6: DateFrom 7: DateTo 8: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..PatID_separete
	set return=return_..Active_separete
	set return=return_..DateFrom_separete
	set return=return_..DateTo_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取病原体对照信息
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       ID:    DHCMed.INF.InfPathogenMaping.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfPathogenMaping).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfPathogenMaping
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfPathogenMaping).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfPathogenMaping).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取病原体对照信息
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       ID:    DHCMed.INF.InfPathogenMaping.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfPathogenMaping).GetStringById(1)
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
/// CreatDate：   2010-05-12
/// Description:  更新病原体对照信息
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: Code 3: Description 4: PatID 5: Active 6: DateFrom 7: DateTo 8: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfPathogenMaping).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfPathogenMaping).%OpenId(ID)
		}
	set obj.Code=$p(InStr,separete,2)
	set obj.Description=$p(InStr,separete,3)
	set obj.PatID=$p(InStr,separete,4)
	set obj.Active=+$p(InStr,separete,5)
	set DateFrom=$p(InStr,separete,6)
	set DateTo=$p(InStr,separete,7)
	set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	set:DateFrom["/" DateFrom=$zdh(DateFrom,4)   //  14/05/2010
	set:DateTo["-" DateTo=$zdh(DateTo,3)
	set:DateTo["/" DateTo=$zdh(DateTo,4)
	set obj.DateFrom=+DateFrom
	set obj.DateTo=+DateTo
	set obj.ResumeText=$p(InStr,separete,8)
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
/// CreatDate：   2010-05-12
/// Description:  删除病原体对照
/// Table：       DHCMed.INF.InfPathogenMaping
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfPathogenMaping).%DeleteId(+Id)
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
<Data name="InfPathogenMapingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>DateFrom</Value>
</Value>
<Value name="5">
<Value>DateTo</Value>
</Value>
<Value name="6">
<Value>Desc</Value>
</Value>
<Value name="7">
<Value>PatID</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfPathogenMapingD</DataLocation>
<DefaultData>InfPathogenMapingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfPathogenMapingD</IdLocation>
<IndexLocation>^DHCMed.INF.InfPathogenMapingI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfPathogenMapingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
