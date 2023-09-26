/// 名称: DHCMed.INF.InfPosSubDia
/// 描述: 医政管理感染部位
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.InfPosSubDia Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 关联感染部位
Property InfPosDr As %Integer [ Required ];

/// 关联的疾病
Property InfDiaDr As %Integer [ Required ];

/// 备注
Property ResumeText As %String;

/// 父索引
Index InfPosDr On InfPosDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfPosSubDia
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfPosDr 3: InfDiaDr 4: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfPosDr_separete
	set return=return_..InfDiaDr_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取感染部位诊断信息信息
/// Table：       DHCMed.INF.InfPosSubDia
/// Input：       ID:    DHCMed.INF.InfPosSubDia.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfPosSubDia).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfPosSubDia
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfPosSubDia).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfPosSubDia).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取感染部位诊断信息
/// Table：       DHCMed_INF.InfPosition
/// Input：       ID:    DHCMed.INF.InfPosSubDia.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfPosSubDia).GetStringById(1)
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
/// Description:  更新感染部位诊断信息
/// Table：       DHCMed.INF.InfPosSubDia
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfPosDr 3: InfDiaDr 4: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfPosSubDia).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfPosSubDia).%OpenId(ID)
		}
	set obj.InfPosDr=$p(InStr,separete,2)
	set obj.InfDiaDr=$p(InStr,separete,3)
	set obj.ResumeText=$p(InStr,separete,4)
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
/// Description:  删除感染部位诊断
/// Table：       DHCMed.INF.InfPosSubDia
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfPosSubDia).%DeleteId(+Id)
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
<Data name="InfPosSubDiaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfDiaDr</Value>
</Value>
<Value name="3">
<Value>InfPosDr</Value>
</Value>
<Value name="4">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfPosSubDiaD</DataLocation>
<DefaultData>InfPosSubDiaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfPosSubDiaD</IdLocation>
<IndexLocation>^DHCMed.INF.InfPosSubDiaI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfPosSubDiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
