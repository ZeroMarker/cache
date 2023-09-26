/// 名称: DHCMed.INF.RepDrug
/// 描述: 医政管理 感染报告 抗生素应用信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepDrug Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告
Property InfRepDr As %Integer [ Required ];

/// 抗生素医嘱DR  OE_OrdItem
Property OEORIDR As %String;

/// 抗生素名称
Property DrugDesc As %String;

/// 给药途径 字典Code
Property Instr As %String;

/// 开始日期 
Property DateFrom As %Date;

/// 截至日期 日期
Property DateTo As %Date;

/// 日期
Property Days As %Integer;

/// 用药方式 字典Code
Property Mode As %String;

/// 目的 字典Code
Property Aim As %String;

/// 治疗用药方式 字典Code
Property CureDrugMode As %String;

/// 预防用药方式 字典发code
Property PrevDrugMode As %String;

/// 预防用药指针 Y/N
Property PrevDrugFlag As %String;

/// 预防用药效果 字典code
Property PrevDrugEffect As %String;

/// 联合用药字典 code
Property UniteDrug As %String;

/// 围术期 用药 Y/N
Property OprDrugFlag As %String;

/// 术前用药时间 格式: 日期 时间
Property PreDrugTime As %String;

/// 术后用药天数 integer
Property AftDrugDays As %String;

/// 合理性 字典code
Property RightFlag As %String;

/// 不合理 原因字典code
Property Impertinency As %String;

/// 疗效 字典code
Property Effect As %String;

/// 备注
Property ResumeText As %String;

/// 术前情况
Property OprBeforInfo As %String;

/// 术后情况
Property OprAfterInfo As %String;

/// 待用1
Property Text1 As %String;

/// 报告类型索引
Index InfRepDr On InfRepDr;

/// 报告类型及医嘱项索引
Index InfRepOeIdx On (InfRepDr, OEORIDR);

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepDrug
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: OEORIDR 4: DrugDesc 5: Instr 6: DateFrom 7: DateTo 8: Days
/// 9: Mode 10: Aim 11: CureDrugMode 12: PrevDrugMode 13: PrevDrugFlag 14: PrevDrugEffect 15: UniteDrug
/// 16: OprDrugFlag 17: PreDrugTime 18: AftDrugDays 19: RightFlag 20: Impertinency 21: Effect 22: ResumeText 23: OprBeforInfo 24: OprAfterInfo 25: Text1
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..OEORIDR_separete
	set return=return_..DrugDesc_separete
	set return=return_..Instr_separete
	set return=return_..DateFrom_separete
	set return=return_..DateTo_separete
	set return=return_..Days_separete
	set return=return_..Mode_separete
	set return=return_..Aim_separete
	set return=return_..CureDrugMode_separete
	set return=return_..PrevDrugMode_separete
	set return=return_..PrevDrugFlag_separete
	set return=return_..PrevDrugEffect_separete
	set return=return_..UniteDrug_separete
	set return=return_..OprDrugFlag_separete
	set return=return_..PreDrugTime_separete
	set return=return_..AftDrugDays_separete
	set return=return_..RightFlag_separete
	set return=return_..Impertinency_separete
	set return=return_..Effect_separete
	set return=return_..ResumeText_separete
	set return=return_..OprBeforInfo_separete
	set return=return_..OprAfterInfo_separete
	set return=return_..Text1
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 抗生素应用信息
/// Table：       DHCMed.INF.RepDrug
/// Input：       ID:    DHCMed.INF.RepDrug.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepDrug).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepDrug
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepDrug).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepDrug).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 抗生素应用信息
/// Table：       DHCMed.INF.RepDrug
/// Input：       ID:    DHCMed.INF.RepDrug.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepDrug).GetStringById(1)
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
/// Description:  更新感染报告抗生素应用信息
/// Table：       DHCMed.INF.RepDrug
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: OEORIDR 4: DrugDesc 5: Instr 6: DateFrom 7: DateTo 8: Days
/// 9: Mode 10: Aim 11: CureDrugMode 12: PrevDrugMode 13: PrevDrugFlag 14: PrevDrugEffect 15: UniteDrug
/// 16: OprDrugFlag 17: PreDrugTime 18: AftDrugDays 19: RightFlag 20: Impertinency 21: Effect 22: ResumeText  23: OprBeforInfo 24: OprAfterInfo 25: Text1
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepDrug).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepDrug).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.OEORIDR=$p(InStr,separete,3)
	set obj.DrugDesc=$p(InStr,separete,4)
	set obj.Instr=$p(InStr,separete,5)
	set DateFrom=$p(InStr,separete,6)
	set DateTo=$p(InStr,separete,7)
	set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	set:DateFrom["/" DateFrom=$zdh(DateFrom,4)   //  14/05/2010
	//set:TimeFrom[":" TimeFrom=$zth(TimeFrom,1)
	set obj.DateFrom=+DateFrom                   //为空时用零默认时间日期值
	//set obj.TimeFrom=+TimeFrom
	set:DateTo["-" DateTo=$zdh(DateTo,3)
	set:DateTo["/" DateTo=$zdh(DateTo,4)   //  14/05/2010
	set obj.DateTo=+DateTo
	set obj.Days=$p(InStr,separete,8)
	set obj.Mode=$p(InStr,separete,9)
	set obj.Aim=$p(InStr,separete,10)
	set obj.CureDrugMode=$p(InStr,separete,11)
	set obj.PrevDrugMode=$p(InStr,separete,12)
	set obj.PrevDrugFlag=$p(InStr,separete,13)
	set obj.PrevDrugEffect=$p(InStr,separete,14)
	set obj.UniteDrug=$p(InStr,separete,15)
	set obj.OprDrugFlag=$p(InStr,separete,16)
	set obj.PreDrugTime=$p(InStr,separete,17)
	set obj.AftDrugDays=$p(InStr,separete,18)
	set obj.RightFlag=$p(InStr,separete,19)
	set obj.Impertinency=$p(InStr,separete,20)
	set obj.Effect=$p(InStr,separete,21)
	set obj.ResumeText=$p(InStr,separete,22)
	set obj.OprBeforInfo=$p(InStr,separete,23)
	set obj.OprAfterInfo=$p(InStr,separete,24)
	set obj.Text1=$p(InStr,separete,25)
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
/// Description:  删除感染报告 抗生素应用
/// Table：       DHCMed.INF.RepDrug
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepDrug).%DeleteId(+Id)
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
<Data name="RepDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AftDrugDays</Value>
</Value>
<Value name="3">
<Value>Aim</Value>
</Value>
<Value name="4">
<Value>CureDrugMode</Value>
</Value>
<Value name="5">
<Value>DateFrom</Value>
</Value>
<Value name="6">
<Value>DateTo</Value>
</Value>
<Value name="7">
<Value>Days</Value>
</Value>
<Value name="8">
<Value>DrugDesc</Value>
</Value>
<Value name="9">
<Value>Effect</Value>
</Value>
<Value name="10">
<Value>Impertinency</Value>
</Value>
<Value name="11">
<Value>InfRepDr</Value>
</Value>
<Value name="12">
<Value>Instr</Value>
</Value>
<Value name="13">
<Value>Mode</Value>
</Value>
<Value name="14">
<Value>OEORIDR</Value>
</Value>
<Value name="15">
<Value>OprDrugFlag</Value>
</Value>
<Value name="16">
<Value>PreDrugTime</Value>
</Value>
<Value name="17">
<Value>PrevDrugEffect</Value>
</Value>
<Value name="18">
<Value>PrevDrugFlag</Value>
</Value>
<Value name="19">
<Value>PrevDrugMode</Value>
</Value>
<Value name="20">
<Value>ResumeText</Value>
</Value>
<Value name="21">
<Value>RightFlag</Value>
</Value>
<Value name="22">
<Value>UniteDrug</Value>
</Value>
<Value name="23">
<Value>OprAfterInfo</Value>
</Value>
<Value name="24">
<Value>OprBeforInfo</Value>
</Value>
<Value name="25">
<Value>Text1</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepDrugD</DataLocation>
<DefaultData>RepDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepDrugD</IdLocation>
<IndexLocation>^DHCMed.INF.RepDrugI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
