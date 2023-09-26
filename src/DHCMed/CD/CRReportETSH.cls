/// 名称: DHCMed.CD.CRReportETSH
/// 描述: 儿童伤害卡
/// 编写者： chenrui
/// 编写日期: 2021-10-12
Class DHCMed.CD.CRReportETSH Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildETSH ];

/// 监测医院编号
Property HospNumber As %String;

/// 就诊科室类型(急诊，门诊)
Property AdmLocType As DHCMed.SS.Dictionary;

/// 卡片编号
Property CRKPBH As %String;

/// 体重
Property ChildWeight As %String;

/// 身高
Property ChildHeight As %String;

/// 就学情况
Property ChildSchool As DHCMed.SS.Dictionary;

/// 户籍
Property ChildRegister As DHCMed.SS.Dictionary;

/// 父亲教育程度
Property FatherEdc As DHCMed.SS.Dictionary;

/// 母亲教育程度
Property MotherEdc As DHCMed.SS.Dictionary;

/// 伤害发生时间
Property HappenTime As %String;

/// 就诊时间
Property AdmTime As %String;

/// 伤害发生的原因
Property HappenResaon As DHCMed.SS.Dictionary;

/// 伤害发生的其他原因
Property OtherResaon As %String;

/// 伤害发生的地点
Property HappenPlace As DHCMed.SS.Dictionary;

/// 伤害发生的其他地点
Property OtherPlace As %String;

/// 伤害发生时活动
Property HappenActivity As DHCMed.SS.Dictionary;

/// 伤害发生的其他活动
Property OtherActivity As %String;

/// 是否故意
Property IsWillfully As DHCMed.SS.Dictionary;

/// 其他故意行为
Property OtherWillfully As %String;

/// 伤者是否饮酒
Property IsDrink As DHCMed.SS.Dictionary;

/// 是否有看护人在场
Property IsCaregiver As DHCMed.SS.Dictionary;

/// 看护人类别
Property CaregiverType As DHCMed.SS.Dictionary;

/// 受伤时看护人状态
Property CaregiverStatus As DHCMed.SS.Dictionary;

/// 看护人其他状态
Property OtherStatus As %String;

/// 伤害性质
Property Injure As DHCMed.SS.Dictionary;

/// 其他伤害性质
Property Otherinjure As %String;

/// 伤害部位
Property InjurePalce As DHCMed.SS.Dictionary;

/// 其他伤害部位
Property OtherInjurePalce As %String;

/// 伤害累及系统
Property InjureSystem As DHCMed.SS.Dictionary;

/// 其他伤害累及系统
Property OtherInjureSystem As %String;

/// 儿童创伤评分
Property PTSScore As %String;

/// 气道状态
Property AirwayStatus As DHCMed.SS.Dictionary;

/// 收缩期血压
Property SBP As DHCMed.SS.Dictionary;

/// 中枢神经系统
Property CentralSystem As DHCMed.SS.Dictionary;

/// 开放性伤口
Property OpenWound As DHCMed.SS.Dictionary;

/// 骨折
Property Fracture As DHCMed.SS.Dictionary;

/// 伤害严重程度
Property InjurySeverity As DHCMed.SS.Dictionary;

/// 伤害临床诊断
Property InjuryDiag As %String;

/// 伤害结局
Property InjuryEnd As DHCMed.SS.Dictionary;

/// 其他结局
Property OtherEnd As %String;

/// 以卡片编号为索引
Index IndexCardNo On CRKPBH;

/// Creator:	chenrui
/// CreatDate:	2021-10-12
/// Description:根据ID取儿童伤害卡
/// w ##class(DHCMed.CD.CRReportETSH).GetObjByParRef("") 
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportETSH
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"ETSH",0))
	Set obj=##class(DHCMed.CD.CRReportETSH).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-10-13
/// Description:  根据ID取儿童伤害卡信息
/// Table：       DHCMed.CD.CRReportETSH
/// Input：       ID:   DHCMed.CD.CRReportETSH.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportETSH).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportETSH
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportETSH).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportETSH).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator:      chenrui
/// CreatDate:    2021-04-06
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.CD.CRReportETSH
/// Input：       ID:    DHCMed.CD.CRReportETSH.ID
/// Return：      返回String
/// w ##class(DHCMed.CD.CRReportETSH).GetStringByParRef(26)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..HospNumber_separete
	Set return=return_..GetDicByObj(..AdmLocType)_separete	
	Set return=return_..CRKPBH_separete
	Set return=return_..ChildWeight_separete
	Set return=return_..ChildHeight_separete
	Set return=return_..GetDicByObj(..ChildSchool)_separete		
	Set return=return_..GetDicByObj(..ChildRegister)_separete	
	Set return=return_..GetDicByObj(..FatherEdc)_separete	
	Set return=return_..GetDicByObj(..MotherEdc)_separete	
	Set return=return_..HappenTime_separete
	Set return=return_..AdmTime_separete
	Set return=return_..GetDicByObj(..HappenResaon)_separete	
	Set return=return_..OtherResaon_separete
	Set return=return_..GetDicByObj(..HappenPlace)_separete	
	Set return=return_..OtherPlace_separete
	Set return=return_..GetDicByObj(..HappenActivity)_separete	
	Set return=return_..OtherActivity_separete
	Set return=return_..GetDicByObj(..IsWillfully)_separete	
	Set return=return_..OtherWillfully_separete
	Set return=return_..GetDicByObj(..IsDrink)_separete	
	Set return=return_..GetDicByObj(..IsCaregiver)_separete	
	Set return=return_..GetDicByObj(..CaregiverType)_separete	
	Set return=return_..GetDicByObj(..CaregiverStatus)_separete	
	Set return=return_..OtherStatus_separete
	Set return=return_..GetDicByObj(..Injure)_separete	
	Set return=return_..Otherinjure_separete
	Set return=return_..GetDicByObj(..InjurePalce)_separete	
	Set return=return_..OtherInjurePalce_separete
	Set return=return_..GetDicByObj(..InjureSystem)_separete	
	Set return=return_..OtherInjureSystem_separete	
	Set return=return_..PTSScore_separete
	Set return=return_..GetDicByObj(..AirwayStatus)_separete
	Set return=return_..GetDicByObj(..SBP)_separete
	Set return=return_..GetDicByObj(..CentralSystem)_separete
	Set return=return_..GetDicByObj(..OpenWound)_separete
	Set return=return_..GetDicByObj(..Fracture)_separete
	Set return=return_..GetDicByObj(..InjurySeverity)_separete
	Set return=return_..InjuryDiag_separete
	Set return=return_..GetDicByObj(..InjuryEnd)_separete
	Set return=return_..OtherEnd_separete
	
	quit return
}

/// w ##class(DHCMed.FBD.SusAbRep).GetDicByObj()
ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.Description
	quit return
}

ClassMethod GetAreaByObj(obj As DHCMed.SS.AreaDic) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.ShortDesc
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-10-13
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportETSH
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportETSH).Update("26^HX001^5670^^183^75^875^5673^5682^5684^2021-10-13 14:40:22^2021-10-13 14:40:25^5689^^5708^^5717^^5727^^5733^5737^5740^5744^^5749^^5759^^5768^^15^5777^5781^5785^5789^5793^5797^轻度烧伤^5801^","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"ETSH",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportETSH).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportETSH).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	
	Set HospNumber	=$p(aInput,separete,2)	// 监测医院编号
	Set LocType		=$p(aInput,separete,3)	// 就诊科室类型
	Set CardNo		=$p(aInput,separete,4)	// 卡片编号
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("ETSH")
	}
	Set Height				=$p(aInput,separete,5)	// 身高
	Set Weight				=$p(aInput,separete,6)	// 体重
	Set Register			=$p(aInput,separete,7)	// 户籍
	Set School				=$p(aInput,separete,8)	// 就学情况
	Set Father				=$p(aInput,separete,9)	// 父亲教育程度
	Set Mother				=$p(aInput,separete,10)	// 母亲教育程度
	Set InjuryHappenTime	=$p(aInput,separete,11)	// 伤害发生时间
	Set AdmTime				=$p(aInput,separete,12)	// 患者就诊时间
	Set InjuryReason		=$p(aInput,separete,13)	// 伤害发生原因
	Set OtherReason			=$p(aInput,separete,14)	// 其他原因
	Set Injuryplace			=$p(aInput,separete,15)	// 伤害发生地点
	Set OtherPlace			=$p(aInput,separete,16)	// 其他发生地点
	Set InjuryActivity		=$p(aInput,separete,17)	// 伤害发生时活动
	Set OtherActivity		=$p(aInput,separete,18)	// 其他活动
	Set IsWillfully			=$p(aInput,separete,19)	// 是否故意
	Set OtherWillfully		=$p(aInput,separete,20)	// 其他故意
	Set IsDrink				=$p(aInput,separete,21)	// 伤者饮酒情况
	Set IsCaregiver			=$p(aInput,separete,22)	// 是否有看护人在场
	Set CaregiverType		=$p(aInput,separete,23)	// 受伤时看护人类别
	Set CaregiverStatus		=$p(aInput,separete,24)	// 受伤时看护人状态
	Set OtherStatus			=$p(aInput,separete,25)	// 其他看护人状态
	Set Injure				=$p(aInput,separete,26)	// 伤害性质
	Set Otherinjure			=$p(aInput,separete,27)	// 其他伤害性质
	Set InjurePalce			=$p(aInput,separete,28)	// 伤害部位
	Set OtherInjurePalce	=$p(aInput,separete,29)	// 其他伤害部位
	Set InjureSystem		=$p(aInput,separete,30)	// 伤害累及系统
	Set OtherInjureSystem	=$p(aInput,separete,31)	// 其他累及系统
	Set PTSScore			=$p(aInput,separete,32)	// 儿童创伤评分
	Set AirwayStatus		=$p(aInput,separete,33)	// 气道状态
	Set SBP					=$p(aInput,separete,34)	// 收缩期血压
	Set CentralSystem		=$p(aInput,separete,35)	// 中枢神经系统
	Set OpenWound			=$p(aInput,separete,36)	// 开放性伤口
	Set Fracture			=$p(aInput,separete,37)	// 骨折
	Set InjurySeverity		=$p(aInput,separete,38)	// 伤害严重程度
	Set InjuryDiag			=$p(aInput,separete,39)	// 伤害临床诊断
	Set InjuryEnd			=$p(aInput,separete,40)	// 伤害结局
	Set OtherEnd			=$p(aInput,separete,41)	// 其他伤害结局
	
	// 保存
	Set obj.HospNumber 			= HospNumber
	Set obj.AdmLocType 			= ##class(DHCMed.SS.Dictionary).GetObjById(LocType)
	Set obj.CRKPBH 				= CardNo
	Set obj.ChildWeight 		= Weight
	Set obj.ChildHeight 		= Height
	Set obj.ChildSchool 		= ##class(DHCMed.SS.Dictionary).GetObjById(School)
	Set obj.ChildRegister 		= ##class(DHCMed.SS.Dictionary).GetObjById(Register)
	Set obj.FatherEdc 			= ##class(DHCMed.SS.Dictionary).GetObjById(Father)
	Set obj.MotherEdc 			= ##class(DHCMed.SS.Dictionary).GetObjById(Mother)
	Set obj.HappenTime 			= InjuryHappenTime
	Set obj.AdmTime 			= AdmTime
	Set obj.HappenResaon 		= ##class(DHCMed.SS.Dictionary).GetObjById(InjuryReason)
	Set obj.OtherResaon 		= OtherReason
	Set obj.HappenPlace 		= ##class(DHCMed.SS.Dictionary).GetObjById(Injuryplace)
	Set obj.OtherPlace 			= OtherPlace
	Set obj.HappenActivity 		= ##class(DHCMed.SS.Dictionary).GetObjById(InjuryActivity)
	Set obj.OtherActivity 		= OtherActivity
	Set obj.IsWillfully 		= ##class(DHCMed.SS.Dictionary).GetObjById(IsWillfully)
	Set obj.OtherWillfully 		= OtherWillfully
	Set obj.IsDrink 			= ##class(DHCMed.SS.Dictionary).GetObjById(IsDrink)
	Set obj.IsCaregiver 		= ##class(DHCMed.SS.Dictionary).GetObjById(IsCaregiver)
	Set obj.CaregiverType 		= ##class(DHCMed.SS.Dictionary).GetObjById(CaregiverType)
	Set obj.CaregiverStatus 	= ##class(DHCMed.SS.Dictionary).GetObjById(CaregiverStatus)
	Set obj.OtherStatus 		= OtherStatus
	Set obj.Injure 				= ##class(DHCMed.SS.Dictionary).GetObjById(Injure)
	Set obj.Otherinjure 		= Otherinjure
	Set obj.InjurePalce 		= ##class(DHCMed.SS.Dictionary).GetObjById(InjurePalce)
	Set obj.OtherInjurePalce 	= OtherInjurePalce
	Set obj.InjureSystem 		= ##class(DHCMed.SS.Dictionary).GetObjById(InjureSystem)
	Set obj.OtherInjureSystem 	= OtherInjureSystem
	Set obj.PTSScore 			= PTSScore
	Set obj.AirwayStatus 		= ##class(DHCMed.SS.Dictionary).GetObjById(AirwayStatus)
	Set obj.SBP 				= ##class(DHCMed.SS.Dictionary).GetObjById(SBP)
	Set obj.CentralSystem 		= ##class(DHCMed.SS.Dictionary).GetObjById(CentralSystem)
	Set obj.OpenWound 			= ##class(DHCMed.SS.Dictionary).GetObjById(OpenWound)
	Set obj.Fracture 			= ##class(DHCMed.SS.Dictionary).GetObjById(Fracture)
	Set obj.InjurySeverity 		= ##class(DHCMed.SS.Dictionary).GetObjById(InjurySeverity)
	Set obj.InjuryDiag	 		= InjuryDiag
	Set obj.InjuryEnd 			= ##class(DHCMed.SS.Dictionary).GetObjById(InjuryEnd)
	Set obj.OtherEnd 			= OtherEnd
	
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="CRReportETSHDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospNumber</Value>
</Value>
<Value name="3">
<Value>AdmLocType</Value>
</Value>
<Value name="4">
<Value>CardNo</Value>
</Value>
<Value name="5">
<Value>ChildWeight</Value>
</Value>
<Value name="6">
<Value>ChildHeight</Value>
</Value>
<Value name="7">
<Value>ChildSchool</Value>
</Value>
<Value name="8">
<Value>ChildRegister</Value>
</Value>
<Value name="9">
<Value>FatherEdc</Value>
</Value>
<Value name="10">
<Value>MotherEdc</Value>
</Value>
<Value name="11">
<Value>HappenTime</Value>
</Value>
<Value name="12">
<Value>AdmTime</Value>
</Value>
<Value name="13">
<Value>HappenResaon</Value>
</Value>
<Value name="14">
<Value>OtherResaon</Value>
</Value>
<Value name="15">
<Value>HappenPlace</Value>
</Value>
<Value name="16">
<Value>OtherPlace</Value>
</Value>
<Value name="17">
<Value>HappenActivity</Value>
</Value>
<Value name="18">
<Value>OtherActivity</Value>
</Value>
<Value name="19">
<Value>IsWillfully</Value>
</Value>
<Value name="20">
<Value>OtherWillfully</Value>
</Value>
<Value name="21">
<Value>IsDrink</Value>
</Value>
<Value name="22">
<Value>IsCaregiver</Value>
</Value>
<Value name="23">
<Value>CaregiverType</Value>
</Value>
<Value name="24">
<Value>CaregiverStatus</Value>
</Value>
<Value name="25">
<Value>OtherStatus</Value>
</Value>
<Value name="26">
<Value>Injure</Value>
</Value>
<Value name="27">
<Value>Otherinjure</Value>
</Value>
<Value name="28">
<Value>InjurePalce</Value>
</Value>
<Value name="29">
<Value>OtherInjurePalce</Value>
</Value>
<Value name="30">
<Value>InjureSystem</Value>
</Value>
<Value name="31">
<Value>OtherInjureSystem</Value>
</Value>
<Value name="32">
<Value>PTSScore</Value>
</Value>
<Value name="33">
<Value>AirwayStatus</Value>
</Value>
<Value name="34">
<Value>SBP</Value>
</Value>
<Value name="35">
<Value>CentralSystem</Value>
</Value>
<Value name="36">
<Value>OpenWound</Value>
</Value>
<Value name="37">
<Value>Fracture</Value>
</Value>
<Value name="38">
<Value>InjurySeverity</Value>
</Value>
<Value name="39">
<Value>InjuryDiag</Value>
</Value>
<Value name="40">
<Value>InjuryEnd</Value>
</Value>
<Value name="41">
<Value>OtherEnd</Value>
</Value>
<Value name="42">
<Value>CRKPBH</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ETSH")</DataLocation>
<DefaultData>CRReportETSHDefaultData</DefaultData>
<IdLocation>^DHCMed.CD.CRReportC("ETSH")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportETSHI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportETSHS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
