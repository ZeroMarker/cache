/// Creator: 	 bianshuai
/// CreateDate:  2018-03-12
/// Descript:    新产品研发组病理申请对Pis系统接口服务类
Class web.DHCAPPPisToPisService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Descript:  测试方法
/// D ##class(web.DHCAPPPisToPisService).test("5430||428")
ClassMethod test() As %String
{
	s ret=..GetPisSysStream()
	d ret.OutputToDevice()
	q 0
}

/// Descript:  登记号^病人姓名^性别^年龄^病人科室^科室^病区^床号^联系电话^出生日期^地址^申请科室^费别^病案号^表单代码^表单名^申请人ID^申请人姓名^申请日期^申请时间^就诊ID^申请单号^手术所见^肿瘤信息^妇科信息^临床体征,病史等/临床病历^加急^冰冻^标本离体时间^开始固定时间^取材科室^取材医生^取材日期^传染病史^病人病历^首次发现人乳头瘤病毒时间^检测方法^临床诊断^治疗方式^大体标本检查所见^会诊要求^会诊专家^取材部位^取材类型^标本信息^自发病至死亡病程时日^病史及治疗过程^临床体格检查及化验检查^尸解目的或希望注意事项^标本信息^医嘱信息
/// 			   多个标本信息和医嘱信息之间通过@分隔
/// 			   标本信息和医嘱信息内部通过#分隔
/// w ##Class(web.DHCAPPPisToPisService).GetPisSysStream("115||35")
ClassMethod GetPisSysStream(RequestStr As %String) As %Stream.GlobalCharacter
{
	s CardNO=$p($p(RequestStr,"</CardNO>"),"<CardNO>",2)
	s CardType=$p($p(RequestStr,"</CardType>"),"<CardType>",2)
	s APPMainObj=##Class(web.DHCAPPPisReqModel).%New()
	i CardNO=""
	{
		s APPMainObj.ResultCode=-1
		s APPMainObj.ResultDesc="入参为空"
		s tmpXML=##class(%Stream.GlobalCharacter).%New()
		d APPMainObj.XMLExportToStream(.tmpXML)
		q tmpXML
	}
	i CardType=1
	{
		s APPID=CardNO
	}
	;s APPString=##Class(web.DHCAPPPisInterface).ToPisSystem(APPID)
	s APPString=##Class(web.DHCDocAPPBL).ToPisSystem(APPID)
	s APPMainObj.RegNo                         =$p(APPString,"^",1) 
	s APPMainObj.Name                          =$p(APPString,"^",2) 
	s APPMainObj.SexCode                       =$p(APPString,"^",3) 
	s APPMainObj.Age                           =$p(APPString,"^",4) 
	s APPMainObj.PatDeptCode                   =$p(APPString,"^",5) 
	s APPMainObj.PatWardCode                   =$p(APPString,"^",6) 
	s APPMainObj.PatBedNO                      =$p(APPString,"^",7) 
	s APPMainObj.Telephone                     =$p(APPString,"^",8) 
	s APPMainObj.BirthDay                      =$p(APPString,"^",9) 
	s APPMainObj.Address                       =$p(APPString,"^",10) 
	s APPMainObj.OrdDeptCode                   =$p(APPString,"^",11) 
	s APPMainObj.FeeType                       =$p(APPString,"^",12) 
	s APPMainObj.DocumentID                    =$p(APPString,"^",13) 
	s APPMainObj.AppCode                       =$p(APPString,"^",14) 
	s APPMainObj.AppName                       =$p(APPString,"^",15) 
	s APPMainObj.OrdDoctorCode                 =$p(APPString,"^",16) 
	s APPMainObj.OrdDoctorName                 =$p(APPString,"^",17) 
	s APPMainObj.OrdDate                       =$p(APPString,"^",18) 
	s APPMainObj.OrdTime                       =$p(APPString,"^",19) 
	s APPMainObj.AdmRowID                      =$p(APPString,"^",20) 
	s APPMainObj.AppID                         =$p(APPString,"^",21) 
	s APPMainObj.OperationInfo                 =$p(APPString,"^",22) 
	s APPMainObj.TumorInfo                     =$p(APPString,"^",23) 
	s APPMainObj.GynecologyInfo                =$p(APPString,"^",24) 
	s APPMainObj.ClinicInfo                    =$p(APPString,"^",25) 
	s APPMainObj.IsUrgent                      =$p(APPString,"^",26) 
	s APPMainObj.IsFrozen                      =$p(APPString,"^",27) 
	s APPMainObj.SpecOffDateTime               =$p(APPString,"^",28) 
	s APPMainObj.SpecFixedDateTime             =$p(APPString,"^",29) 
	s APPMainObj.SamplingDeptCode              =$p(APPString,"^",30) 
	s APPMainObj.SamplingDoctorCode            =$p(APPString,"^",31) 
	s APPMainObj.SamplingDateTime              =$p(APPString,"^",32) 
	s APPMainObj.InfectionInfo                 =$p(APPString,"^",33) 
	s APPMainObj.DocumentInfo                  =$p(APPString,"^",34) 
	s APPMainObj.HumanPapillomavirusDateTime   =$p(APPString,"^",35) 
	s APPMainObj.TestMethod                    =$p(APPString,"^",36) 
	s APPMainObj.ClinicalDiagnosis             =$p(APPString,"^",37) 
	s APPMainObj.Treatment                     =$p(APPString,"^",38) 
	s APPMainObj.GeneralSpecExamination        =$p(APPString,"^",39) 
	s APPMainObj.ConsultationRequirements      =$p(APPString,"^",40) 
	s APPMainObj.ConsultationDoctor            =$p(APPString,"^",41) 
	s APPMainObj.SamplingPosition              =$p(APPString,"^",42) 
	s APPMainObj.SamplingType                  =$p(APPString,"^",43) 
	s APPMainObj.DOTFOTD                       =$p(APPString,"^",44) 
	s APPMainObj.MedicalHistory                =$p(APPString,"^",45) 
	s APPMainObj.ClinicPhysicalExam            =$p(APPString,"^",46) 
	s APPMainObj.AutopsyInfo                   =$p(APPString,"^",47)
	s SpecInfoString                           =$p(APPString,"^",48)

	s SpecInfoCount=$l(SpecInfoString,$C(2))
	f tmpSpecNum=1:1:SpecInfoCount
	{
		s tmpSpecInfoString=""
		s SpecInfoObj=##class(web.DHCAPPPisSpecModel).%New()
		s tmpSpecInfoString=$p(SpecInfoString,$C(2),tmpSpecNum)
		q:tmpSpecInfoString=""
		s SpecInfoObj.SpecNO=$p(tmpSpecInfoString,$C(1),1)
		s SpecInfoObj.SpecPosition=$p(tmpSpecInfoString,$C(1),2)
		s SpecInfoObj.SpecQty=$p(tmpSpecInfoString,$C(1),4)
		;s SpecInfoObj.SpecSlide=$p(tmpSpecInfoString,$C(1),4)
		s SpecInfoObj.OriginalNO=$p(tmpSpecInfoString,$C(1),5)
		s SpecInfoObj.SepDate=$p(tmpSpecInfoString,$C(1),7)
		s SpecInfoObj.FixDate=$p(tmpSpecInfoString,$C(1),8)
		
		d APPMainObj.SpecInfo.Insert(SpecInfoObj)
	}
	s OrdInfoString                           =$p(APPString,"^",49)
	s OrdInfoCount=$l(OrdInfoString,"@")
	f tmpOrdNum=1:1:OrdInfoCount
	{
		s tmpOrdInfoString=""
		s OrdInfoObj=##class(web.DHCAPPPisOrderModel).%New()
		s tmpOrdInfoString=$p(OrdInfoString,"@",tmpOrdNum)
		q:tmpOrdInfoString=""
		s OrdInfoObj.OrdCode=$p(tmpOrdInfoString,"#",4)
		s OrdInfoObj.OrdRowID=$p(tmpOrdInfoString,"#",5)
		s OrdInfoObj.OrdDesc=$p(tmpOrdInfoString,"#",1)
		d APPMainObj.OrdInfo.Insert(OrdInfoObj)
	}
	s APPMainObj.OrdHospital                   =$p(APPString,"^",50) 
	s APPMainObj.TraDoctorCode                 =$p(APPString,"^",51) 
	s APPMainObj.ExamType                      =$p(APPString,"^",52)
	s APPMainObj.PisNoStatus                   =$p(APPString,"^",53) 

	s APPMainObj.ResultCode=0
	s APPMainObj.ResultDesc="成功"
	s tmpXML=##class(%Stream.GlobalCharacter).%New()
	d APPMainObj.XMLExportToStream(.tmpXML)
	q tmpXML
}

}
