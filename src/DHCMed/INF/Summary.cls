/// 名称: DHCMed.INF.Summary
/// 描述: 医政管理 感染报告:院内感染摘要信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.Summary Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告 DHC_Med.INF.Report
Property InfRepDr As %Integer [ Required ];

/// 疾病转归
Property LapseTo As %String;

/// 死亡关系
Property DeathConnection As %String;

/// 入住ICU情况
Property ICUFlag As %String;

/// 药物不良反应 Y/N
Property DrugEffect As %String;

/// 二重感染 Y/N
Property DblInfFlag As %String;

/// 感染发生地
Property InfPlace As %String;

/// 诊断依据
Property Treatment As %String;

/// 病程及原因分析
Property Analysis As %String;

/// 备注-->感染科室
Property ResumeText As %Integer;

/// 感染报告父子索引
Index InfRepDr On InfRepDr;

Index InfRepDrCL On (InfRepDr, ResumeText);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.Summary
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: LapseTo 4: DeathConnection 5: ICUFlag 6: DrugEffect 7: DblInfFlag 8: InfPlace 9: Treatment 10: Analysis 11: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..LapseTo_separete
	set return=return_..DeathConnection_separete
	set return=return_..ICUFlag_separete
	set return=return_..DrugEffect_separete
	set return=return_..DblInfFlag_separete
	set return=return_..InfPlace_separete
	set return=return_..Treatment_separete
	set return=return_..Analysis_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告摘要信息
/// Table：       DHCMed.INF.Summary
/// Input：       ID:    DHCMed.INF.Summary.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.Summary).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.Summary
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.Summary).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.Summary).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告摘要信息
/// Table：       DHCMed.INF.Summary
/// Input：       ID:    DHCMed.INF.Summary.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.Summary).GetStringById(1)
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
/// Description:  更新感染报告摘要信息
/// Table：       DHCMed.INF.Summary
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: LapseTo 4: DeathConnection 5: ICUFlag 6: DrugEffect 7: DblInfFlag 8: InfPlace 9: Treatment 10: Analysis 11: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.Summary).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.Summary).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.LapseTo=$p(InStr,separete,3)
	set obj.DeathConnection=$p(InStr,separete,4)
	set obj.ICUFlag=$p(InStr,separete,5)
	set obj.DrugEffect=$p(InStr,separete,6)
	set obj.DblInfFlag=$p(InStr,separete,7)
	set obj.InfPlace=$p(InStr,separete,8)
	set obj.Treatment=$p(InStr,separete,9)
	set obj.Analysis=$p(InStr,separete,10)
	set obj.ResumeText=+$p(InStr,separete,11)
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
/// Description:  删除感染报告摘要
/// Table：       DHCMed.INF.Summary
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.Summary).%DeleteId(+Id)
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
<Data name="SummaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Analysis</Value>
</Value>
<Value name="3">
<Value>DblInfFlag</Value>
</Value>
<Value name="4">
<Value>DeathConnection</Value>
</Value>
<Value name="5">
<Value>DrugEffect</Value>
</Value>
<Value name="6">
<Value>ICUFlag</Value>
</Value>
<Value name="7">
<Value>InfPlace</Value>
</Value>
<Value name="8">
<Value>InfRepDr</Value>
</Value>
<Value name="9">
<Value>LapseTo</Value>
</Value>
<Value name="10">
<Value>ResumeText</Value>
</Value>
<Value name="11">
<Value>Treatment</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.SummaryD</DataLocation>
<DefaultData>SummaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.SummaryD</IdLocation>
<IndexLocation>^DHCMed.INF.SummaryI</IndexLocation>
<StreamLocation>^DHCMed.INF.SummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
