/// 名称: DHCMed.INF.RepReason
/// 描述: 医政管理 感染报告:院内感染易感因素信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.RepReason Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告 DHC_Med.INF.Report
Property InfRepDr As %Integer [ Required ];

/// 易感因素 字典
Property InfReason As %String;

/// 开始日期
Property ReasonStDate As %Date;

/// 开始时间
Property ReasonStTime As %Time;

/// 结束日期
Property ReasonEdDate As %Date;

/// 结束时间
Property ReasonEdTime As %Time;

/// 备注
Property ResumeText As %String;

/// 感染报告父子索引
Index InfRepDr On InfRepDr;

/// 感染因素索引
Index RepDrInfReason On (InfRepDr, InfReason) [ Unique ];

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepReason
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: InfReason 4: ReasonStDate 5: ReasonStTime 6: ReasonEdDate 7: ReasonEdTime 8: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..InfReason_separete
	set return=return_..ReasonStDate_separete
	set return=return_..ReasonStTime_separete
	set return=return_..ReasonEdDate_separete
	set return=return_..ReasonEdTime_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告易感因素信息
/// Table：       DHCMed.INF.RepReason
/// Input：       ID:    DHCMed.INF.RepReason.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepReason).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepReason
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepReason).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepReason).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告易感因素信息
/// Table：       DHCMed.INF.RepReason
/// Input：       ID:    DHCMed.INF.RepReason.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepReason).GetStringById(1)
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
/// Description:  更新感染报告易感因素信息
/// Table：       DHCMed.INF.RepReason
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: InfReason 4: ReasonStDate 5: ReasonStTime 6: ReasonEdDate 7: ReasonEdTime 8: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepReason).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepReason).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.InfReason=$p(InStr,separete,3)
	set ReasonStDate=$p(InStr,separete,4)
	set ReasonStTime=$p(InStr,separete,5)
	set:ReasonStDate["-" ReasonStDate=$zdh(ReasonStDate,3)
	set:ReasonStDate["/" ReasonStDate=$zdh(ReasonStDate,4)   //  14/05/2010
	set:ReasonStTime[":" ReasonStTime=$zth(ReasonStTime,1)
	set:ReasonStDate="" ReasonStDate=+$h
	set:ReasonStTime="" ReasonStTime=$p($h,",",2)
	set obj.ReasonStDate=+ReasonStDate
	set obj.ReasonStTime=+ReasonStTime
	//to
	set ReasonEdDate=$p(InStr,separete,6)
	set ReasonEdTime=$p(InStr,separete,7)
	set:ReasonEdDate["-" ReasonEdDate=$zdh(ReasonEdDate,3)
	set:ReasonEdDate["/" ReasonEdDate=$zdh(ReasonEdDate,4)   //  14/05/2010
	set:ReasonEdTime[":" ReasonEdTime=$zth(ReasonEdTime,1)
	set:ReasonEdDate="" ReasonEdDate=+$h
	set:ReasonEdTime="" ReasonEdTime=$p($h,",",2)
	set obj.ReasonEdDate=+ReasonEdDate
	set obj.ReasonEdTime=+ReasonEdTime
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
/// Description:  删除感染报告易感因素
/// Table：       DHCMed.INF.RepReason
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepReason).%DeleteId(+Id)
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
<Data name="RepReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfReason</Value>
</Value>
<Value name="3">
<Value>InfRepDr</Value>
</Value>
<Value name="4">
<Value>ReasonEdDate</Value>
</Value>
<Value name="5">
<Value>ReasonEdTime</Value>
</Value>
<Value name="6">
<Value>ReasonStDate</Value>
</Value>
<Value name="7">
<Value>ReasonStTime</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepReasonD</DataLocation>
<DefaultData>RepReasonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepReasonD</IdLocation>
<IndexLocation>^DHCMed.INF.RepReasonI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
