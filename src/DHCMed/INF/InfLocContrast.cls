/// 名称: DHCMed.INF.InfLocContrast
/// 描述: 医政管理感染标准部门与系统科室对照
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.InfLocContrast Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// Tran科室
Property CtlocDR As %Integer [ Required ];

/// 标准科室 DHCMed.INF.InfLocDic
Property InflocDR As %Integer [ Required ];

/// 有效
Property Active As %Boolean;

/// 开始日期
Property DateFrom As %Date;

/// 结束日期
Property DateTo As %Date;

/// 备注
Property ResumeText As %String;

/// 系统科室索引
Index CtlocDR On CtlocDR [ Unique ];

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: CtlocDR 3: InflocDR 4: Active 5: DateFrom 6: DateTo 7: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CtlocDR_separete
	set return=return_..InflocDR_separete
	set return=return_..Active_separete
	set return=return_..DateFrom_separete
	set return=return_..DateTo_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染部门对照信息
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       ID:    DHCMed.INF.InfLocContrast.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfLocContrast).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfLocContrast
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfLocContrast).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfLocContrast).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染部门对照信息
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       ID:    DHCMed.INF.InfLocContrast.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfLocContrast).GetStringById(1)
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
/// Description:  更新感染科室对照信息
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: CtlocDR 3: InflocDR 4: Active 5: DateFrom 6: DateTo 7: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfLocContrast).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfLocContrast).%OpenId(ID)
		}
	set obj.CtlocDR=$p(InStr,separete,2)
	set obj.InflocDR=$p(InStr,separete,3)
	set obj.Active=+$p(InStr,separete,4)
	set DateFrom=$p(InStr,separete,5)
	set DateTo=$p(InStr,separete,6)
	set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	set:DateFrom["/" DateFrom=$zdh(DateFrom,4)   //14/05/2010
	set:DateTo["-" DateTo=$zdh(DateTo,3)
	set:DateTo["/" DateTo=$zdh(DateTo,4)
	set obj.DateFrom=+DateFrom
	set obj.DateTo=+DateTo
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
/// CreatDate：   2010-05-12
/// Description:  删除感染部门对照
/// Table：       DHCMed.INF.InfLocContrast
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfLocContrast).%DeleteId(+Id)
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
<Data name="InfLocContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>CtlocDR</Value>
</Value>
<Value name="4">
<Value>DateFrom</Value>
</Value>
<Value name="5">
<Value>DateTo</Value>
</Value>
<Value name="6">
<Value>InflocDR</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfLocContrastD</DataLocation>
<DefaultData>InfLocContrastDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfLocContrastD</IdLocation>
<IndexLocation>^DHCMed.INF.InfLocContrastI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfLocContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
