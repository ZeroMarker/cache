Class DHCMed.NINF.Aim.UTI Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 临床上报表ID
Property CRReportDR As %String(TRUNCATE = 1) [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

/// 转入ICU日期
Property InICUDate As %String(TRUNCATE = 1);

/// 留置导管指针
Property PipePoint As %String(TRUNCATE = 1);

/// 插管操作正确
Property ActionRight As %String(TRUNCATE = 1);

/// 引用闭环引流系统
Property AirtightSYS As %String(TRUNCATE = 1);

/// 引流系统通常完整
Property Unobstructed As %String(TRUNCATE = 1);

/// 损坏后导管更换
Property DamageChange As %String(TRUNCATE = 1);

/// 疑似阻塞导管更换
Property ObstructionChange As %String(TRUNCATE = 1);

/// 膀胱冲洗
Property BladderFlush As %String(TRUNCATE = 1);

/// 是否使用含消毒剂或抗菌药物的生理盐水进行膀胱冲洗或灌注
Property FluchwithDrug As %String(TRUNCATE = 1);

/// 导尿管是否1次/2周更换
Property HalfPerWeek As %String(TRUNCATE = 1);

/// 集尿袋是否2次/周更换
Property TwoPerWeek As %String(TRUNCATE = 1);

/// 每次使用清洁干净的尿壶倒出集尿袋内尿液
Property ContainersClear As %String(TRUNCATE = 1);

/// 每日是否评价留置导管的必要性
Property EVAPerDay As %String(TRUNCATE = 1);

/// Creator：    ZGZ
/// CreatDate：   2012-04-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Aim.UTI
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..InICUDate _separete
	set return=return_..PipePoint_separete
	set return=return_..ActionRight_separete
	set return=return_..AirtightSYS_separete
	set return=return_..Unobstructed_separete
	set return=return_..DamageChange_separete
	set return=return_..ObstructionChange_separete
	set return=return_..BladderFlush_separete
	set return=return_..FluchwithDrug_separete
	set return=return_..HalfPerWeek_separete
	set return=return_..TwoPerWeek_separete
	set return=return_..ContainersClear_separete
	set return=return_..EVAPerDay_separete

	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-12
/// Description:  根据ID取UTI干预核查表对象
/// Table：       DHCMed.NINF.Aim.UTI
/// Input：       ID:    DHCMed.NINF.Aim.CVDP.ID
///               separete: 指定的分隔符
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Aim.UTI).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.UTI
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.UTI).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.UTI).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-12
/// Description:  根据ID取UTI干预核查表对象
/// Table：       DHCMed.NINF.Aim.UTI
/// Input：       id: DHCMed.NINF.Aim.UTI.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Aim.UTI).GetStringById(1)
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

/// Creator：     ZGZ
/// CreatDate：   2012-04-14
/// Description:  更新UTI干预核查表对象
/// Table：       DHCMed.NINF.Aim.UTI
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// d ##class(DHCMed.NINF.Aim.UTI).Update(^2^3^4^^^^^^)
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.UTI).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.UTI).%OpenId(ID)
		}
	
	set obj.CRReportDR=$p(InStr,"^",2)
	set obj.InICUDate  =$p(InStr,"^",3)
	set obj.PipePoint =$p(InStr,"^",4)
	set obj.ActionRight =$p(InStr,"^",5)
	set obj.AirtightSYS =$p(InStr,"^",6)
	set obj.Unobstructed =$p(InStr,"^",7)
	set obj.DamageChange =$p(InStr,"^",8)
	set obj.ObstructionChange =$p(InStr,"^",9)
	set obj.BladderFlush =$p(InStr,"^",10)
	set obj.FluchwithDrug =$p(InStr,"^",11)
	set obj.HalfPerWeek =$p(InStr,"^",12)
	set obj.TwoPerWeek =$p(InStr,"^",13)
	set obj.ContainersClear =$p(InStr,"^",14)
	set obj.EVAPerDay =$p(InStr,"^",15)
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

/// Creator：    ZGZ
/// CreatDate：   2012-04-12
/// Description:  删除UTI干预核查表对象
/// Table：       DHCMed.NINF.Aim.UTI
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.UTI).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// w ##class(DHCMed.NINF.Aim.UTI).UpdateDataFromEPR(2999419,"91||2")
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	s ret=-1
	
	q:CRReportDR="" ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.UTII("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.UTII("CRReportDR"," "_CRReportDR,""),-1)
	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport)
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	
	s tmp = RepID
	s tmp = tmp _ "^" _ CRReportDR	
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转入日期D0006#TYPE:Simple#TID:654#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置尿管指征M0009#TYPE:Simple#TID:654#TVER:0#SCODE:M0009#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"插管严格无菌操作，动作轻柔，避免尿道粘膜损伤M0010#TYPE:Simple#TID:654#TVER:0#SCODE:M0010#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"是否采用密闭式引流系统M0011#TYPE:Simple#TID:654#TVER:0#SCODE:M0011#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"保持尿液引流系统通畅完整，不轻易打开导尿管与集尿袋的接口M0012#TYPE:Simple#TID:654#TVER:0#SCODE:M0012#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"导尿管不慎脱落或密闭系统被破坏，更换导尿管M0013#TYPE:Simple#TID:654#TVER:0#SCODE:M0013#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"疑似导尿管阻塞是否更换导管M0014#TYPE:Simple#TID:654#TVER:0#SCODE:M0014#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"是否行膀胱冲洗M0015#TYPE:Simple#TID:654#TVER:0#SCODE:M0015#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"是否使用含消毒剂或抗菌药物的生理盐水进行膀胱冲洗或灌注M0016#TYPE:Simple#TID:654#TVER:0#SCODE:M0016#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"615^导尿管是否1次/2周更换M0017#TYPE:Simple#TID:654#TVER:0#SCODE:M0017#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"集尿袋是否2次/周更换M0018#TYPE:Simple#TID:654#TVER:0#SCODE:M0018#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"每次使用清洁干净的尿壶倒出集尿袋内尿液M0019#TYPE:Simple#TID:654#TVER:0#SCODE:M0019#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"每日是否评价留置导管的必要性M0020#TYPE:Simple#TID:654#TVER:0#SCODE:M0020#VTYPE:V",InstanceDataID)
	s ret=..Update(tmp)
	
	q ret
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	q ret
}

Storage Default
{
<Data name="UTIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionRight</Value>
</Value>
<Value name="3">
<Value>AirtightSYS</Value>
</Value>
<Value name="4">
<Value>BladderFlush</Value>
</Value>
<Value name="5">
<Value>ContainersClear</Value>
</Value>
<Value name="6">
<Value>DamageChange</Value>
</Value>
<Value name="7">
<Value>EVAPerDay</Value>
</Value>
<Value name="8">
<Value>FluchwithDrug</Value>
</Value>
<Value name="9">
<Value>HalfPerWeek</Value>
</Value>
<Value name="10">
<Value>InICUDate</Value>
</Value>
<Value name="11">
<Value>InstanceDataID</Value>
</Value>
<Value name="12">
<Value>ObstructionChange</Value>
</Value>
<Value name="13">
<Value>PaadmDR</Value>
</Value>
<Value name="14">
<Value>PipePoint</Value>
</Value>
<Value name="15">
<Value>TwoPerWeek</Value>
</Value>
<Value name="16">
<Value>Unobstructed</Value>
</Value>
<Value name="17">
<Value>CRReportDR</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.UTID</DataLocation>
<DefaultData>UTIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.UTID</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.UTII</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.UTIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
