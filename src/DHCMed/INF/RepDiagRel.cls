/// 名称: DHCMed.INF.RepDiagRel
/// 描述: 存储和诊断相关的信息
/// 编写者：ChenJB
/// 编写日期: 2010-09-14
Class DHCMed.INF.RepDiagRel Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 关联类型A   TypeCode
Property TypeA As %String;

/// A Rowid
Property Arowid As %String;

/// B Rowid
Property ICDDr As %String;

/// 诊断日期
Property DiagDate As %Date;

/// 诊断时间
Property DiagTime As %Time;

/// DiagDesc 诊断描述
Property DiagDesc As %String;

/// DiagDoc 诊断医生
Property DiagDoc As %String;

/// DiagType 诊断类型
Property DiagType As %String;

/// ICD10 标准ICD10编码
Property ICD10 As %String;

/// ICD10Desc 标准诊断描述
Property ICD10Desc As %String;

/// Resume 备注
Property Resume As %String;

/// 报告类型及诊断 索引
Index TypeA On (TypeA, Arowid, ICDDr) [ Unique ];

/// Creator：     ChenJB
/// CreatDate：   2010-09-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: TypeA 3: Arowid 4: ICDDr 5: DiagDate 6: DiagTime 7: DiagDoc
/// 8: DiagType 9: ICD10 10: ICD10Desc 11: Resume
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..TypeA_separete
	set return=return_..Arowid_separete
	set return=return_..ICDDr_separete
	set return=return_..DiagDate_separete
	set return=return_..DiagTime_separete
	set return=return_..DiagDesc_separete
	set return=return_..DiagDoc_separete
	set return=return_..DiagType_separete
	set return=return_..ICD10_separete
	set return=return_..ICD10Desc_separete
	set return=return_..Resume_separete
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-12
/// Description:  根据ID 取对象
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       ID:    DHCMed.INF.RepDiagRel.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepDiagRel).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepDiagRel
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepDiagRel).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepDiagRel).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-12
/// Description:  根据ID信息字符串
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       ID:    DHCMed.INF.RepDiagRel.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepDiagRel).GetStringById(1)
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
/// Description:  更新感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: TypeA 3: Arowid 4: ICDDr 5: DiagDate 6: DiagTime 7: DiagDoc
/// 8: DiagType 9: ICD10 10: ICD10Desc 11: Resume
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepDiagRel).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepDiagRel).%OpenId(ID)
		}
	
	set obj.TypeA=$p(InStr,separete,2)
	set obj.Arowid=$p(InStr,separete,3)
	set obj.ICDDr=$p(InStr,separete,4)
	set DiagDate=$p(InStr,separete,5)
	set DiagTime=$p(InStr,separete,6)
	set:DiagDate["-" DiagDate=$zdh(DiagDate,3)
	set:DiagDate["/" DiagDate=$zdh(DiagDate,4)   //  14/05/2010
	set:DiagTime[":" DiagTime=$zth(DiagTime,1)
	set obj.DiagDate=DiagDate
	set obj.DiagTime=DiagTime
	set obj.DiagDoc=$p(InStr,separete,7)
	set obj.DiagType=$p(InStr,separete,8)
	set obj.ICD10=$p(InStr,separete,9)
	set obj.ICD10Desc=$p(InStr,separete,10)
	set obj.Resume=$p(InStr,separete,11)
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
/// Description:  删除感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepDiagRel).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-12
/// Description:  删除关联信息
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteByTypeA(TypeA, Arowid)
{
	new (TypeA,Arowid)
	s ret=-1
	q:(TypeA="")!(Arowid="") ret
	s TypeAIdx=" "_$zcvt(TypeA,"U")
	s ArowidIdx=" "_$zcvt(Arowid,"U")
	s Browid=""
	f  s Browid=$o(^DHCMed.INF.RepDiagRelI("TypeA",TypeAIdx,ArowidIdx,Browid)) q:Browid=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.RepDiagRelI("TypeA",TypeAIdx,ArowidIdx,Browid,rowid)) q:rowid=""  d
	..s ret=..DeleteById(rowid)
	quit ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-12
/// Description:  判断 记录是否存在
/// Table：       DHCMed.INF.RepDiagRel
/// Input：       Id
/// Return：      成功：返回1，失败：返回<0的代码
ClassMethod HaveRel(TypeA, Arowid, Browid) As %String
{
	new (TypeA,Arowid,TypeB,Browid)
	s ret=-1
	q:(TypeA="")!(Arowid="")!(Browid="") ret
	s TypeAIdx=" "_$zcvt(TypeA,"U")
	s ArowidIdx=" "_$zcvt(Arowid,"U")
	s BrowidIdx=" "_$zcvt(Browid,"U")
	s:$d(^DHCMed.INF.RepDiagRelI("TypeA",TypeAIdx,ArowidIdx,BrowidIdx)) ret=1
	quit ret
}

Storage Default
{
<Data name="RepDiagRelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Arowid</Value>
</Value>
<Value name="3">
<Value>DiagDate</Value>
</Value>
<Value name="4">
<Value>DiagDesc</Value>
</Value>
<Value name="5">
<Value>DiagDoc</Value>
</Value>
<Value name="6">
<Value>DiagTime</Value>
</Value>
<Value name="7">
<Value>DiagType</Value>
</Value>
<Value name="8">
<Value>ICD10</Value>
</Value>
<Value name="9">
<Value>ICDDesc</Value>
</Value>
<Value name="10">
<Value>ICDDr</Value>
</Value>
<Value name="11">
<Value>Resume</Value>
</Value>
<Value name="12">
<Value>TypeA</Value>
</Value>
<Value name="13">
<Value>ICD10Desc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepDiagRelD</DataLocation>
<DefaultData>RepDiagRelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepDiagRelD</IdLocation>
<IndexLocation>^DHCMed.INF.RepDiagRelI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepDiagRelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
