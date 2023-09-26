/// 名称: DHCMed.NINF.Aim.SSI
/// 描述: 手术感染病例监测表
/// 编写者：LK
/// 编写日期: 2012-05-30
/// update by liuyh 2012-08-09 手术感染病例监测表 标准模板
Class DHCMed.NINF.Aim.SSI Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

//临床上报ID  指向CRReport

Property CRReportDR As %String [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

// 基础疾病

Property BaseDiag1 As %String;

// 基础疾病

Property BaseDiag2 As %String;

// 基础疾病

Property BaseDiag3 As %String;

//术前备皮

Property PrepareSkin As %String;

//备皮方式

Property PSMethod As %String;

//备皮时间

Property PSDate As %String;

//备皮地点

Property PSPlace As %String;

//术前擦浴

Property IFClean As %String;

//擦浴时间

Property CleanDate As %String;

//擦浴次数

Property CleanTimes As %String;

//擦浴用品

Property CleanDrug As %String;

//手术名称

Property surgeryName As %String;

//手术类型

Property surgeryClass As %String;

//手术医生

Property surgeryDoc As %String;

//手术日期

Property surgerySD As %String;

//手术持续时间

Property OperMinutes As %String;

//ASA评分

Property ASA As %String;

//切口等级

Property CutLevel As %String;

//手术类型

Property surgeryType As %String;

//麻醉类型

Property ASAType As %String;

//术中出血

Property LostBlood As %String;

//植入物

Property InThings As %String;

//内镜

Property InLook As %String;

//术后诊断

Property AfOperDiagnos As %String;

//是否入住ICU

Property IfICU As %String;

//术前用药

Property BSurgeryDrug As %String;

//术前用药时间类型

Property BSDrugType As %String;

//术中用药

Property InSurgeryDrug As %String;

//术后用药

Property ASurgeryDrug As %String;

//术后用药时间类型

Property ASDrugType As %String;

/// 术前用药名称
Property BSDrugName As %String;

/// 术中用药名称
Property ISDrugName As %String;

/// 术后用药名称
Property ASDrugName As %String;

///   Creator：     lk
///   CreatDate：   2012-05-30
///   Description:  将对象格式化为字符串
///   Table：        DHCMed.NINF.Aim.SSI
///   Input：       separete:指定的分隔符
///   Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..BaseDiag1_separete
	set return=return_..BaseDiag2_separete
	set return=return_..BaseDiag3_separete
	set return=return_..PrepareSkin_separete
	set return=return_..PSMethod_separete
	set return=return_..PSDate_separete
	set return=return_..PSPlace_separete
	set return=return_..IFClean_separete
	set return=return_..CleanDate_separete
	set return=return_..CleanTimes_separete
	set return=return_..CleanDrug_separete
	set return=return_..surgeryName_separete
	set return=return_..surgeryClass_separete
	set return=return_..surgeryDoc_separete
	set return=return_..surgerySD_separete
	set return=return_..ASA_separete
	set return=return_..OperMinutes_separete
	set return=return_..CutLevel_separete
	set return=return_..surgeryType_separete
	set return=return_..ASAType_separete
	set return=return_..LostBlood_separete
	set return=return_..InThings_separete
	set return=return_..InLook_separete
	set return=return_..AfOperDiagnos_separete
	set return=return_..IfICU_separete
	set return=return_..BSurgeryDrug_separete
	set return=return_..BSDrugType_separete
	set return=return_..InSurgeryDrug_separete
	set return=return_..ASurgeryDrug_separete
	set return=return_..ASDrugType_separete
	set return=return_..BSDrugName_separete
	set return=return_..ISDrugName_separete
	set return=return_..ASDrugName_separete

	
	quit return
}

///  Creator：     lk
///  CreatDate：   2012-05-30
///  Description:  根据ID取手术部位感染报告 
///  Table：       DHCMed.NINF.Aim.SSI
///  Input：       ID:    DHCMed.NINF.Aim.SSI.ID
///  Return：      返回obj
///  w ##class(DHCMed.NINF.Aim.SSI).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.SSI
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.SSI).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.SSI).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

///  Creator：     lk
///  CreatDate：   2012-05-30
///  Description:  根据ID取手术部位感染报告
///  Table：       DHCMed.NINF.Aim.SSI
///  Input：       ID:    DHCMed.NINF.Aim.SSI.ID
///                separete: 指定的分隔符
///  Return：      返回obj.ToString()
///  w ##class(DHCMed.NINF.Aim.SSI).GetStringById(1)
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

///   Creator：     lk
///   CreatDate：   2012-05-30
///   Description:  根据ID取手术部位感染报告
///   Table：       DHCMed.NINF.Aim.SSI
///   Input：       各属性列表 ^分隔
///   Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.Aim.SSI).Update("^3^4^5^^^^^^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.SSI).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.SSI).%OpenId(ID)
		}
	    set obj.CRReportDR=$p(InStr,separete,2)
	    set obj.BaseDiag1=$p(InStr,separete,3)
	    set obj.BaseDiag2=$p(InStr,separete,4)
	    set obj.BaseDiag3=$p(InStr,separete,5)
	    set obj.PrepareSkin=$p(InStr,separete,6)
	    set obj.PSMethod=$p(InStr,separete,7)
	    set obj.PSDate=$p(InStr,separete,8)
	    set obj.PSPlace=$p(InStr,separete,9)
	    set obj.IFClean=$p(InStr,separete,10)
	    set obj.CleanDate=$p(InStr,separete,11)
	    set obj.CleanTimes=$p(InStr,separete,12)
	    set obj.CleanDrug=$p(InStr,separete,13)
	    set obj.surgeryName=$p(InStr,separete,14)
	    set obj.surgeryClass=$p(InStr,separete,15)
	    set obj.surgeryDoc=$p(InStr,separete,16)
	    set obj.surgerySD=$p(InStr,separete,17)
	    set obj.ASA=$p(InStr,separete,18)
	    set obj.OperMinutes=$p(InStr,separete,19)
	    set obj.CutLevel=$p(InStr,separete,20)
	    set obj.surgeryType=$p(InStr,separete,21)
	    set obj.ASAType=$p(InStr,separete,22)
	    set obj.LostBlood=$p(InStr,separete,23)
	    set obj.InThings=$p(InStr,separete,24)
	    set obj.InLook=$p(InStr,separete,25)
	    set obj.AfOperDiagnos=$p(InStr,separete,26)
	    set obj.IfICU=$p(InStr,separete,27)
	    set obj.BSurgeryDrug=$p(InStr,separete,28)
	    set obj.BSDrugType=$p(InStr,separete,29)
	    set obj.InSurgeryDrug=$p(InStr,separete,30)
	    set obj.ASurgeryDrug=$p(InStr,separete,31)
	    set obj.ASDrugType=$p(InStr,separete,32)
	    set obj.BSDrugName=$p(InStr,separete,33)
	    set obj.ISDrugName=$p(InStr,separete,34)
	    set obj.ASDrugName=$p(InStr,separete,35)
	
	
	
	
	
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

/// Creator：     lk
/// CreatDate：   2012-05-30
/// Description:  删除感染报告 
/// Table：       DHCMed.NINF.Aim.SSI
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.SSI).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// w ##class(DHCMed.NINF.Aim.SSI).UpdateDataFromEPR(1)
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	
	s ret=-1
	
	q:(CRReportDR="") ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_CRReportDR,""),-1)
	
	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport) ret
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	
	s TIDValue=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFSSITIDValue","")
	q:TIDValue="" $$$OK
	
	s tmp = RepID
	s tmp = tmp _ "^" _ CRReportDR
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"诊断1.S0068#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0068#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"诊断1.S0067#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0067#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"诊断1.S0066#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0066#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前备皮.O0048#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0048#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前备皮方式.M0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:M0014#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前备皮时间.M0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:M0015#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"地点.M0016#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:M0016#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前擦浴.O0017#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0017#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前擦浴时间.O0018#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0018#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"次数.O0019#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0019#VTYPE:V",InstanceDataID)	
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"用品.S0020#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0020#VTYPE:V",InstanceDataID)
    s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"手术名称.I0075#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0075#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"手术类型.O0073#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0073#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"主刀医师.S0023#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0023#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"手术日期.D0024#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0024#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"持续时间.S0025#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0025#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"ASA分级.O0026#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0026#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"切口等级.O0027#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0027#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"手术类型.O0073#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0073#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"麻醉类型.O0029#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0029#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术中出血.S0030#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0030#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"植入物.O0031#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0031#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"内镜.O0032#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0032#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术后诊断.S0069#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0069#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"是否入住ICU.O0034#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0034#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前.O0035#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0035#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前抗菌药物使用时间.O0041#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0041#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前.O0036#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0036#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前.O0037#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0037#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术后抗菌药物使用时间.O0042#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0042#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术前抗菌药物名称.I0038#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0038#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术中抗菌药物名称.I0039#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0039#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"术后抗菌药物名称.I0040#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0040#VTYPE:V",InstanceDataID)
	
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
<Data name="SSIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ASA</Value>
</Value>
<Value name="3">
<Value>ASAType</Value>
</Value>
<Value name="4">
<Value>ASDrugType</Value>
</Value>
<Value name="5">
<Value>ASurgeryDrug</Value>
</Value>
<Value name="6">
<Value>AfOperDiagnos</Value>
</Value>
<Value name="7">
<Value>BSDrugType</Value>
</Value>
<Value name="8">
<Value>BSurgeryDrug</Value>
</Value>
<Value name="9">
<Value>CRReportDR</Value>
</Value>
<Value name="10">
<Value>CleanDate</Value>
</Value>
<Value name="11">
<Value>CleanDrug</Value>
</Value>
<Value name="12">
<Value>CleanTimes</Value>
</Value>
<Value name="13">
<Value>CutLevel</Value>
</Value>
<Value name="14">
<Value>IFClean</Value>
</Value>
<Value name="15">
<Value>IfHosInf</Value>
</Value>
<Value name="16">
<Value>IfICU</Value>
</Value>
<Value name="17">
<Value>InLook</Value>
</Value>
<Value name="18">
<Value>InSurgeryDrug</Value>
</Value>
<Value name="19">
<Value>InThings</Value>
</Value>
<Value name="20">
<Value>InfPos1</Value>
</Value>
<Value name="21">
<Value>InfPos1Date</Value>
</Value>
<Value name="22">
<Value>InfPos1Flag1</Value>
</Value>
<Value name="23">
<Value>InfPos1Flag2</Value>
</Value>
<Value name="24">
<Value>InfPos1Flag3</Value>
</Value>
<Value name="25">
<Value>InfPos1Method1</Value>
</Value>
<Value name="26">
<Value>InfPos1Method2</Value>
</Value>
<Value name="27">
<Value>InfPos1Method3</Value>
</Value>
<Value name="28">
<Value>InfPos1Object1</Value>
</Value>
<Value name="29">
<Value>InfPos1Object2</Value>
</Value>
<Value name="30">
<Value>InfPos1Object3</Value>
</Value>
<Value name="31">
<Value>InfPos1PathDate1</Value>
</Value>
<Value name="32">
<Value>InfPos1PathDate2</Value>
</Value>
<Value name="33">
<Value>InfPos1PathDate3</Value>
</Value>
<Value name="34">
<Value>InfPos1Sample1</Value>
</Value>
<Value name="35">
<Value>InfPos1Sample2</Value>
</Value>
<Value name="36">
<Value>InfPos1Sample3</Value>
</Value>
<Value name="37">
<Value>InfPos2</Value>
</Value>
<Value name="38">
<Value>InfPos2Date</Value>
</Value>
<Value name="39">
<Value>InfPos2Flag1</Value>
</Value>
<Value name="40">
<Value>InfPos2Flag2</Value>
</Value>
<Value name="41">
<Value>InfPos2Flag3</Value>
</Value>
<Value name="42">
<Value>InfPos2Method1</Value>
</Value>
<Value name="43">
<Value>InfPos2Method2</Value>
</Value>
<Value name="44">
<Value>InfPos2Method3</Value>
</Value>
<Value name="45">
<Value>InfPos2Object1</Value>
</Value>
<Value name="46">
<Value>InfPos2Object2</Value>
</Value>
<Value name="47">
<Value>InfPos2Object3</Value>
</Value>
<Value name="48">
<Value>InfPos2PathDate1</Value>
</Value>
<Value name="49">
<Value>InfPos2PathDate2</Value>
</Value>
<Value name="50">
<Value>InfPos2PathDate3</Value>
</Value>
<Value name="51">
<Value>InfPos2Sample1</Value>
</Value>
<Value name="52">
<Value>InfPos2Sample2</Value>
</Value>
<Value name="53">
<Value>InfPos2Sample3</Value>
</Value>
<Value name="54">
<Value>InfPos3</Value>
</Value>
<Value name="55">
<Value>InfPos3Date</Value>
</Value>
<Value name="56">
<Value>InfPos3Flag1</Value>
</Value>
<Value name="57">
<Value>InfPos3Flag2</Value>
</Value>
<Value name="58">
<Value>InfPos3Flag3</Value>
</Value>
<Value name="59">
<Value>InfPos3Method1</Value>
</Value>
<Value name="60">
<Value>InfPos3Method2</Value>
</Value>
<Value name="61">
<Value>InfPos3Method3</Value>
</Value>
<Value name="62">
<Value>InfPos3Object1</Value>
</Value>
<Value name="63">
<Value>InfPos3Object2</Value>
</Value>
<Value name="64">
<Value>InfPos3Object3</Value>
</Value>
<Value name="65">
<Value>InfPos3PathDate1</Value>
</Value>
<Value name="66">
<Value>InfPos3PathDate2</Value>
</Value>
<Value name="67">
<Value>InfPos3PathDate3</Value>
</Value>
<Value name="68">
<Value>InfPos3Sample1</Value>
</Value>
<Value name="69">
<Value>InfPos3Sample2</Value>
</Value>
<Value name="70">
<Value>InfPos3Sample3</Value>
</Value>
<Value name="71">
<Value>LapseTo</Value>
</Value>
<Value name="72">
<Value>LapseToDate</Value>
</Value>
<Value name="73">
<Value>LostBlood</Value>
</Value>
<Value name="74">
<Value>OperMinutes</Value>
</Value>
<Value name="75">
<Value>PSDate</Value>
</Value>
<Value name="76">
<Value>PSMethod</Value>
</Value>
<Value name="77">
<Value>PSPlace</Value>
</Value>
<Value name="78">
<Value>PrepareSkin</Value>
</Value>
<Value name="79">
<Value>ReVisit</Value>
</Value>
<Value name="80">
<Value>RepNo</Value>
</Value>
<Value name="81">
<Value>RepUser</Value>
</Value>
<Value name="82">
<Value>surgeryClass</Value>
</Value>
<Value name="83">
<Value>surgeryDoc</Value>
</Value>
<Value name="84">
<Value>surgeryName</Value>
</Value>
<Value name="85">
<Value>surgerySD</Value>
</Value>
<Value name="86">
<Value>surgeryType</Value>
</Value>
<Value name="87">
<Value>BaseDiag1</Value>
</Value>
<Value name="88">
<Value>BaseDiag2</Value>
</Value>
<Value name="89">
<Value>BaseDiag3</Value>
</Value>
<Value name="90">
<Value>BSDrugName</Value>
</Value>
<Value name="91">
<Value>ISDrugName</Value>
</Value>
<Value name="92">
<Value>ASDrugName</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.SSID</DataLocation>
<DefaultData>SSIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.SSID</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.SSII</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.SSIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
