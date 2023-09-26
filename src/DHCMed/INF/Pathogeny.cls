/// 名称: DHCMed.INF.Pathogeny
/// 描述: 医政管理 感染报告
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.Pathogeny Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告
Property InfRepDr As %Integer [ Required ];

/// 培养医嘱 指向检验项目DR 或检验医嘱EP_VisitTestSet 配置
Property OEORIDR As %String;

/// 培养名称
Property PathDesc As %String;

/// 标本 字典code
Property Sample As %String;

/// 感染部位 DHCMed.INF.InfPosition
Property InfPosDR As %Integer;

/// 送检日期
Property PathDate As %Date;

/// 送检方法 字典code
Property Method As %String;

/// 培养结果标志 Y/N/C
Property DrugFlag As %String;

/// 备注
Property ResumeText As %String;

/// 报告类型索引
Index InfRepDr On InfRepDr;

/// 报告类型医嘱项索引
Index InfRepInfOeordIdx On (InfRepDr, OEORIDR);

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.Pathogeny
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: OEORIDR 4: PathDesc 5: Sample 6: InfPosDR 7: PathDate 8: Method
/// 9: DrugFlag 10: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..OEORIDR_separete
	set return=return_..PathDesc_separete
	set return=return_..Sample_separete
	set return=return_..InfPosDR_separete
	set return=return_..PathDate_separete
	set return=return_..Method_separete
	set return=return_..DrugFlag_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 辅助检查信息
/// Table：       DHCMed.INF.Pathogeny
/// Input：       ID:    DHCMed.INF.Pathogeny.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.Pathogeny).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.Pathogeny
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.Pathogeny).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.Pathogeny).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 辅助检查信息
/// Table：       DHCMed.INF.Pathogeny
/// Input：       ID:    DHCMed.INF.Pathogeny.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.Pathogeny).GetStringById(1)
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
/// CreatDate：   2010-05-17
/// Description:  更新感染报告 辅助检查信息
/// Table：       DHCMed.INF.Pathogeny
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: OEORIDR 4: PathDesc 5: Sample 6: InfPosDR 7: PathDate 8: Method
/// 9: DrugFlag 10: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.Pathogeny).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.Pathogeny).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.OEORIDR=$p(InStr,separete,3)
	set obj.PathDesc=$p(InStr,separete,4)
	set obj.Sample=$p(InStr,separete,5)
	set obj.InfPosDR=$p(InStr,separete,6)
	set PathDate=$p(InStr,separete,7)
	set:PathDate["-" PathDate=$zdh(PathDate,3)
	set:PathDate["/" PathDate=$zdh(PathDate,4)   //  14/05/2010
	set obj.PathDate=+PathDate
	set obj.Method=$p(InStr,separete,8)
	set obj.DrugFlag=$p(InStr,separete,9)
	set obj.ResumeText=$p(InStr,separete,10)
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
/// CreatDate：   2010-05-17
/// Description:  删除感染报告 辅助检查
/// Table：       DHCMed.INF.Pathogeny
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.Pathogeny).%DeleteId(+Id)
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
<Data name="PathogenyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrugFlag</Value>
</Value>
<Value name="3">
<Value>InfPosDR</Value>
</Value>
<Value name="4">
<Value>InfRepDr</Value>
</Value>
<Value name="5">
<Value>Method</Value>
</Value>
<Value name="6">
<Value>OEORIDR</Value>
</Value>
<Value name="7">
<Value>PathDate</Value>
</Value>
<Value name="8">
<Value>PathDesc</Value>
</Value>
<Value name="9">
<Value>ResumeText</Value>
</Value>
<Value name="10">
<Value>Sample</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.PathogenyD</DataLocation>
<DefaultData>PathogenyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.PathogenyD</IdLocation>
<IndexLocation>^DHCMed.INF.PathogenyI</IndexLocation>
<StreamLocation>^DHCMed.INF.PathogenyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
