/// 名称: DHCMed.NINF.CSS.ClinReport
/// 描述: 横断面调查登记表
/// 编写者：zhufei
/// 编写日期: 2014-05-05
Class DHCMed.NINF.CSS.ClinReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.CSS.ClinReportLog [ Cardinality = children, Inverse = ParRef ];

/// 就诊号
Property CREpisodeID As %String(TRUNCATE = 1);

/// 调查编号
Property CRSurvNumber As %String(TRUNCATE = 1);

/// 调查日期
Property CRSurvDate As %Date;

/// 调查科室
Property CRSurvLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查人(人员名称)
Property CRSurvUser As %String(TRUNCATE = 1);

/// 是否有效
Property CRIsActive As %Boolean;

/// 更新日期
Property CRUpdateDate As %Date;

/// 更新时间
Property CRUpdateTime As %Time;

/// 更新日期
Property CRUpdateLoc As %String(TRUNCATE = 1);

/// 更新时间
Property CRUpdateUser As %String(TRUNCATE = 1);

/// 病案号
Property CRMRNo As %String(TRUNCATE = 1);

/// 病人编号
Property CRPatNo As %String(TRUNCATE = 1);

/// 姓名
Property CRName As %String(TRUNCATE = 1);

/// 性别（男、女）
Property CRSex As %String(TRUNCATE = 1);

/// 年龄（岁）
Property CRAgeY As %String(TRUNCATE = 1);

/// 年龄（月）
Property CRAgeM As %String(TRUNCATE = 1);

/// 年龄（天）
Property CRAgeD As %String(TRUNCATE = 1);

/// 科室(标准科室)
Property CRLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 床号
Property CRBed As %String(TRUNCATE = 1);

/// 入院日期
Property CRAdmDate As %String(TRUNCATE = 1);

/// 基础疾病诊断（多值"#"分隔）
Property CRDiagnos As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否感染
Property CRIsInfection As %String(TRUNCATE = 1);

/// 感染分类
Property CRInfCategory As %String(TRUNCATE = 1);

/// 医院感染部位1
Property CRInfPos1 As %String(TRUNCATE = 1);

/// 医院感染日期1
Property CRInfDate1 As %String(TRUNCATE = 1);

/// 医院感染病原体1（多值"#"分隔）
Property CRPathogen1 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院感染部位2
Property CRInfPos2 As %String(TRUNCATE = 1);

/// 医院感染日期2
Property CRInfDate2 As %String(TRUNCATE = 1);

/// 医院感染病原体2（多值"#"分隔）
Property CRPathogen2 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院感染部位3
Property CRInfPos3 As %String(TRUNCATE = 1);

/// 医院感染日期3
Property CRInfDate3 As %String(TRUNCATE = 1);

/// 医院感染病原体3（多值"#"分隔）
Property CRPathogen3 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 社区感染部位1
Property CRComInfPos1 As %String(TRUNCATE = 1);

/// 社区感染日期1
Property CRComInfDate1 As %String(TRUNCATE = 1);

/// 社区感染病原体1（多值"#"分隔）
Property CRComPathogen1 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 社区感染部位2
Property CRComInfPos2 As %String(TRUNCATE = 1);

/// 社区感染日期2
Property CRComInfDate2 As %String(TRUNCATE = 1);

/// 社区感染病原体2（多值"#"分隔）
Property CRComPathogen2 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 社区感染部位3
Property CRComInfPos3 As %String(TRUNCATE = 1);

/// 社区感染日期3
Property CRComInfDate3 As %String(TRUNCATE = 1);

/// 社区感染病原体3（多值"#"分隔）
Property CRComPathogen3 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 细菌耐药情况（多值"#","`"分隔）
Property CRBugsAntiSen As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 抗菌药物使用(是、否)
Property CRAnti1 As %String(TRUNCATE = 1);

/// 目的(治疗用药、预防用药、治疗+预防)
Property CRAnti2 As %String(TRUNCATE = 1);

/// 联用(单用、二联、三联、四联及以上)
Property CRAnti3 As %String(TRUNCATE = 1);

/// 治疗用药前后送细菌培养(是、否)
Property CRAnti4 As %String(TRUNCATE = 1);

/// 手术(是、否)
Property CROper1 As %String(TRUNCATE = 1);

/// 术前应用抗菌药物(是、否)
Property CROper2 As %String(TRUNCATE = 1);

/// 手术切口等级(Ⅰ、Ⅱ、Ⅲ、Ⅳ、无)
Property CROper3 As %String(TRUNCATE = 1);

/// Ⅰ、Ⅱ级切口围手术期用药(是、否)
Property CROper4 As %String(TRUNCATE = 1);

/// 动静脉插管(是、否)
Property CRAddOns1 As %String(TRUNCATE = 1);

/// 泌尿道插管(是、否)
Property CRAddOns2 As %String(TRUNCATE = 1);

/// 使用呼吸机(是、否)
Property CRAddOns3 As %String(TRUNCATE = 1);

/// 过去24小时内是否有≥3次的腹泻(是、否)
Property CRAddOns4 As %String(TRUNCATE = 1);

/// 手术后肺炎(是、否)
Property CRAddOns5 As %String(TRUNCATE = 1);

Index IndexEpisodeID On (CRSurvNumber, CREpisodeID, CRIsActive);

/// w ##class(DHCMed.NINF.CSS.ClinReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.CSS.ClinReport
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.CSS.ClinReport).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.CSS.ClinReport).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator     ：zhufei
/// CreatDate   ：2014-05-05
/// input       : aInput
/// w ##Class(DHCMed.NINF.CSS.ClinReport).Update("")
ClassMethod Update(aInput As %String) As %String
{
	new (aInput)
	set return=0
	quit:aInput="" return
	
	set ID=$p(aInput,"^",1)
	set EpisodeID=$p(aInput,"^",2)
	set SurvNumber=$p(aInput,"^",3)
	quit:(SurvNumber="")||(EpisodeID="") return
	
	set SurvDate=$p(aInput,"^",4)
	;set:SurvDate["-" SurvDate=$zdh(SurvDate,3)
	set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SurvDate)
	set:SurvDate="" SurvDate=+$h
	
	if ID="" {
		set ID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID"," "_SurvNumber," "_EpisodeID,1,0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.NINF.CSS.ClinReport).%New()
	} else {
		set obj=##class(DHCMed.NINF.CSS.ClinReport).%OpenId(ID)
	}
	
	set obj.CREpisodeID   = EpisodeID
	set obj.CRSurvNumber  = SurvNumber
	set obj.CRSurvDate    = SurvDate
	set obj.CRSurvLoc     = $p(aInput,"^",5)
	set obj.CRSurvUser    = $p(aInput,"^",6)
	set obj.CRIsActive    = +$p(aInput,"^",7)
	set obj.CRMRNo        = $p(aInput,"^",8)
	set obj.CRName        = $p(aInput,"^",9)
	set obj.CRSex         = $p(aInput,"^",10)
	set obj.CRAgeY        = $p(aInput,"^",11)
	set obj.CRAgeM        = $p(aInput,"^",12)
	set obj.CRAgeD        = $p(aInput,"^",13)
	set obj.CRLoc         = $p(aInput,"^",14)
	set obj.CRBed         = $p(aInput,"^",15)
	set obj.CRAdmDate     = $p(aInput,"^",16)
	set obj.CRDiagnos     = $p(aInput,"^",17)
	set obj.CRIsInfection = $p(aInput,"^",18)
	set obj.CRInfPos1     = $p(aInput,"^",19)
	set obj.CRInfDate1    = $p(aInput,"^",20)
	set obj.CRPathogen1   = $p(aInput,"^",21)
	set obj.CRInfPos2     = $p(aInput,"^",22)
	set obj.CRInfDate2    = $p(aInput,"^",23)
	set obj.CRPathogen2   = $p(aInput,"^",24)
	set obj.CRInfPos3     = $p(aInput,"^",25)
	set obj.CRInfDate3    = $p(aInput,"^",26)
	set obj.CRPathogen3   = $p(aInput,"^",27)
	set obj.CRAnti1       = $p(aInput,"^",28)
	set obj.CRAnti2       = $p(aInput,"^",29)
	set obj.CRAnti3       = $p(aInput,"^",30)
	set obj.CRAnti4       = $p(aInput,"^",31)
	set obj.CROper1       = $p(aInput,"^",32)
	set obj.CROper2       = $p(aInput,"^",33)
	set obj.CROper3       = $p(aInput,"^",34)
	set obj.CROper4       = $p(aInput,"^",35)
	set obj.CRAddOns1     = $p(aInput,"^",36)
	set obj.CRAddOns2     = $p(aInput,"^",37)
	set obj.CRAddOns3     = $p(aInput,"^",38)
	set obj.CRAddOns4     = $p(aInput,"^",39)
	set UpdateDate=$p(aInput,"^",40)
	;set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate'="" UpdateDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(UpdateDate)
	set:UpdateDate="" UpdateDate=+$h
	set UpdateTime=$p(aInput,"^",41)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	set:UpdateTime="" UpdateTime=$p($h,",",2)
	set obj.CRUpdateDate  = UpdateDate
	set obj.CRUpdateTime  = UpdateTime
	set obj.CRUpdateLoc   = $p(aInput,"^",42)
	set obj.CRUpdateUser  = $p(aInput,"^",43)
	
	set obj.CRPatNo         = $p(aInput,"^",44)
	set obj.CRInfCategory   = $p(aInput,"^",45)
	set obj.CRComInfPos1    = $p(aInput,"^",46)
	set obj.CRComInfDate1   = $p(aInput,"^",47)
	set obj.CRComPathogen1  = $p(aInput,"^",48)
	set obj.CRComInfPos2    = $p(aInput,"^",49)
	set obj.CRComInfDate2   = $p(aInput,"^",50)
	set obj.CRComPathogen2  = $p(aInput,"^",51)
	set obj.CRComInfPos3    = $p(aInput,"^",52)
	set obj.CRComInfDate3   = $p(aInput,"^",53)
	set obj.CRComPathogen3  = $p(aInput,"^",54)
	set obj.CRAddOns5       = $p(aInput,"^",55)
	set obj.CRBugsAntiSen   = $p(aInput,"^",56)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {    //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2014-05-05
/// Description:  删除
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(DHCMed.NINF.CSS.ClinReport).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CREpisodeID</Value>
</Value>
<Value name="3">
<Value>CRSurvNumber</Value>
</Value>
<Value name="4">
<Value>CRSurvDate</Value>
</Value>
<Value name="5">
<Value>CRSurvLoc</Value>
</Value>
<Value name="6">
<Value>CRSurvUser</Value>
</Value>
<Value name="7">
<Value>CRIsActive</Value>
</Value>
<Value name="8">
<Value>CRMRNo</Value>
</Value>
<Value name="9">
<Value>CRName</Value>
</Value>
<Value name="10">
<Value>CRSex</Value>
</Value>
<Value name="11">
<Value>CRAgeY</Value>
</Value>
<Value name="12">
<Value>CRAgeM</Value>
</Value>
<Value name="13">
<Value>CRAgeD</Value>
</Value>
<Value name="14">
<Value>CRLoc</Value>
</Value>
<Value name="15">
<Value>CRBed</Value>
</Value>
<Value name="16">
<Value>CRAdmDate</Value>
</Value>
<Value name="17">
<Value>CRDiagnos</Value>
</Value>
<Value name="18">
<Value>CRIsInfection</Value>
</Value>
<Value name="19">
<Value>CRInfPos1</Value>
</Value>
<Value name="20">
<Value>CRInfDate1</Value>
</Value>
<Value name="21">
<Value>CRPathogen1</Value>
</Value>
<Value name="22">
<Value>CRInfPos2</Value>
</Value>
<Value name="23">
<Value>CRInfDate2</Value>
</Value>
<Value name="24">
<Value>CRPathogen2</Value>
</Value>
<Value name="25">
<Value>CRInfPos3</Value>
</Value>
<Value name="26">
<Value>CRInfDate3</Value>
</Value>
<Value name="27">
<Value>CRPathogen3</Value>
</Value>
<Value name="28">
<Value>CRAnti1</Value>
</Value>
<Value name="29">
<Value>CRAnti2</Value>
</Value>
<Value name="30">
<Value>CRAnti3</Value>
</Value>
<Value name="31">
<Value>CRAnti4</Value>
</Value>
<Value name="32">
<Value>CROper1</Value>
</Value>
<Value name="33">
<Value>CROper2</Value>
</Value>
<Value name="34">
<Value>CROper3</Value>
</Value>
<Value name="35">
<Value>CROper4</Value>
</Value>
<Value name="36">
<Value>CRAddOns1</Value>
</Value>
<Value name="37">
<Value>CRAddOns2</Value>
</Value>
<Value name="38">
<Value>CRAddOns3</Value>
</Value>
<Value name="39">
<Value>CRAddOns4</Value>
</Value>
<Value name="40">
<Value>CRUpdateDate</Value>
</Value>
<Value name="41">
<Value>CRUpdateTime</Value>
</Value>
<Value name="42">
<Value>CRUpdateLoc</Value>
</Value>
<Value name="43">
<Value>CRUpdateUser</Value>
</Value>
<Value name="44">
<Value>CRPatNo</Value>
</Value>
<Value name="45">
<Value>CRInfCategory</Value>
</Value>
<Value name="46">
<Value>CRComInfPos1</Value>
</Value>
<Value name="47">
<Value>CRComInfDate1</Value>
</Value>
<Value name="48">
<Value>CRComPathogen1</Value>
</Value>
<Value name="49">
<Value>CRComInfPos2</Value>
</Value>
<Value name="50">
<Value>CRComInfDate2</Value>
</Value>
<Value name="51">
<Value>CRComPathogen2</Value>
</Value>
<Value name="52">
<Value>CRComInfPos3</Value>
</Value>
<Value name="53">
<Value>CRComInfDate3</Value>
</Value>
<Value name="54">
<Value>CRComPathogen3</Value>
</Value>
<Value name="55">
<Value>CRAddOns5</Value>
</Value>
<Value name="56">
<Value>CRBugsAntiSen</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.CSS("REP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.CSS("REP")</IdLocation>
<IndexLocation>^DHCMed.NINF.CSSi("REP")</IndexLocation>
<StreamLocation>^DHCMed.NINF.CSS.ClinReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
