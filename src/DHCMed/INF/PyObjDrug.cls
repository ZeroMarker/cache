/// 名称: DHCMed.INF.PyObjDrug
/// 描述: 医政管理 感染报告 辅助检查病原体 抗生素药敏
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.PyObjDrug Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 病原体 指向
Property InfPyObjDr As %Integer [ Required ];

/// 抗生素字典 指向
Property DrugDR As %Integer;

/// 药敏结果 Y/N/C
Property Flag As %String;

/// 病原体 父子表索引
Index InfPyObjDr On InfPyObjDr;

/// 抗菌药物索引
Index PathDrDrugIdx On (InfPyObjDr, DrugDR);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.PyObjDrug
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfPyObjDr 3: DrugDR 4: Flag
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfPyObjDr_separete
	set return=return_..DrugDR_separete
	set return=return_..Flag
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 辅助检查 病原体 抗生素药敏
/// Table：       DHCMed.INF.PyObjDrug
/// Input：       ID:    DHCMed.INF.PyObjDrug.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.PyObjDrug).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.PyObjDrug
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.PyObjDrug).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.PyObjDrug).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 辅助检查 病原体 抗生素药敏
/// Table：       DHCMed.INF.PyObjDrug
/// Input：       ID:    DHCMed.INF.PyObjDrug.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.PyObjDrug).GetStringById(1)
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
/// Description:  更新感染报告 辅助检查 病原体 抗生素药敏
/// Table：       DHCMed.INF.PyObjDrug
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfPyObjDr 3: DrugDR 4: Flag
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.PyObjDrug).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.PyObjDrug).%OpenId(ID)
		}
	set obj.InfPyObjDr=$p(InStr,separete,2)
	set obj.DrugDR=$p(InStr,separete,3)
	set obj.Flag=$p(InStr,separete,4)
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
/// Description:  删除感染报告 辅助检查 病原体 抗生素药敏
/// Table：       DHCMed.INF.PyObjDrug
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.PyObjDrug).%DeleteId(+Id)
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
<Data name="PyObjDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrugDR</Value>
</Value>
<Value name="3">
<Value>Flag</Value>
</Value>
<Value name="4">
<Value>InfPyObjDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.PyObjDrugD</DataLocation>
<DefaultData>PyObjDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.PyObjDrugD</IdLocation>
<IndexLocation>^DHCMed.INF.PyObjDrugI</IndexLocation>
<StreamLocation>^DHCMed.INF.PyObjDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
