/// 名称: DHCMed.INF.ICUDias
/// 描述: 医政管理 感染报告 入住ICU诊断
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.ICUDias Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 入住ICU插管 指向
Property ICUInfoDr As %Integer;

/// 入ICU诊断 MRC_ICDDx
Property ICUDiaDr As %Integer;

/// 诊断描述
Property ICUDiaDesc As %String;

/// 备注
Property ResumeText As %String;

/// 插管 父子索引
Index ICUInfoDr On ICUInfoDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.ICUDias
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: ICUInfoDr 3: ICUDiaDr 4: ICUDiaDesc 5: ResumeText 
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ICUInfoDr_separete
	set return=return_..ICUDiaDr_separete
	set return=return_..ICUDiaDesc_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 icu诊断
/// Table：       DHCMed.INF.ICUDias
/// Input：       ID:    DHCMed.INF.ICUDias.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.ICUDias).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.ICUDias
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.ICUDias).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.ICUDias).%OpenId(+id)
	set return=obj
	do obj.%Close()
	k obj
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 icu诊断
/// Table：       DHCMed.INF.ICUDias
/// Input：       ID:    DHCMed.INF.ICUDias.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUDias).GetStringById(1)
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
/// Description:  更新感染报告 icu 诊断
/// Table：       DHCMed.INF.ICUDias
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: ICUInfoDr 3: ICUDiaDr 4: ICUDiaDesc 5: ResumeText 
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.ICUDias).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.ICUDias).%OpenId(ID)
		}
	set obj.ICUInfoDr=$p(InStr,separete,2)
	set obj.ICUDiaDr=$p(InStr,separete,3)
	set obj.ICUDiaDesc=$p(InStr,separete,4)
	set obj.ResumeText=$p(InStr,separete,5)
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
/// Description:  删除感染报告 icu诊断
/// Table：       DHCMed.INF.ICUDias
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.ICUDias).%DeleteId(+Id)
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
<Data name="ICUDiasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICUDiaDesc</Value>
</Value>
<Value name="3">
<Value>ICUDiaDr</Value>
</Value>
<Value name="4">
<Value>ICUInfoDr</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ICUDiasD</DataLocation>
<DefaultData>ICUDiasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ICUDiasD</IdLocation>
<IndexLocation>^DHCMed.INF.ICUDiasI</IndexLocation>
<StreamLocation>^DHCMed.INF.ICUDiasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
