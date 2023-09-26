/// 名称: DHCMed.INF.RepStatusDtls
/// 描述: 医政管理 感染报告状态明细
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.RepStatusDtls Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告 DHC_Med.INF.Report
Property InfRepDr As %Integer [ Required ];

/// 报告状态
Property StatusCode As %String [ Required ];

/// 操作人
Property UserDr As %Integer [ Required ];

/// 操作日期
Property UpdateDate As %String;

/// 操作时间
Property UpdateTime As %String;

/// 备注
Property ResumeText As %String;

/// 感染报告父子索引
Index InfRepDr On InfRepDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepStatusDtls
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: StatusCode 4: UserDr 5: UpdateDate 6: UpdateTime 7: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..StatusCode_separete
	set return=return_..UserDr_separete
	set return=return_..UpdateDate_separete
	set return=return_..UpdateTime_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告操作明细信息
/// Table：       DHCMed.INF.RepStatusDtls
/// Input：       ID:    DHCMed.INF.RepStatusDtls.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepStatusDtls).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepStatusDtls
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepStatusDtls).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepStatusDtls).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告状态明细信息
/// Table：       DHCMed.INF.RepStatusDtls
/// Input：       ID:    DHCMed.INF.RepStatusDtls.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepStatusDtls).GetStringById(1)
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
/// Description:  更新感染报告状态明细信息
/// Table：       DHCMed.INF.RepStatusDtls
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: StatusCode 4: UserDr 5: UpdateDate 6: UpdateTime 7: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepStatusDtls).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepStatusDtls).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.StatusCode=$p(InStr,separete,3)
	set obj.UserDr=$p(InStr,separete,4)
	set UpdateDate=$p(InStr,separete,5)
	set UpdateTime=$p(InStr,separete,6)
	set:UpdateDate["-" UpdateDate=$zdh(RepDate,3)
	set:UpdateDate["/" UpdateDate=$zdh(RepDate,4)   //  14/05/2010
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	set:UpdateDate="" UpdateDate=+$h
	set:UpdateTime="" UpdateTime=$p($h,",",2)
	set obj.UpdateDate=+UpdateDate
	set obj.UpdateTime=+UpdateTime
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
/// Description:  删除感染报告明细
/// Table：       DHCMed.INF.RepStatusDtls
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepStatusDtls).%DeleteId(+Id)
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
<Data name="RepStatusDtlsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfRepDr</Value>
</Value>
<Value name="3">
<Value>ResumeText</Value>
</Value>
<Value name="4">
<Value>StatusCode</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>UserDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepStatusDtlsD</DataLocation>
<DefaultData>RepStatusDtlsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepStatusDtlsD</IdLocation>
<IndexLocation>^DHCMed.INF.RepStatusDtlsI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepStatusDtlsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
