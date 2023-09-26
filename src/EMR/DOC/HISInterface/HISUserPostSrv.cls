/// 名称:	EMR.DOC.HISInterface.HISUserPostSrv
/// 描述:	用户是否在HIS中是此职称
/// 编写者：yejian
/// 编写日期: 2022-9-14
/// 产品组：电子病历产品组
Class EMR.DOC.HISInterface.HISUserPostSrv Extends %RegisteredObject
{

///  Desc:       用户是否在HIS中是此职称
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserPost：职务code
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos("","","")
ClassMethod IsUserPos(AUserID As %String, AUserPost As %String, AUserLoc As %String) As %String
{
	s strRes = "0"
	q:(AUserID = "")||(AUserPost = "")||(AUserLoc = "") strRes
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EMR.DOC.HISInterface.HISUserPostSrv||"_AUserPost) = "0") strRes
	s execCode = "strRes=##class(EMR.DOC.HISInterface.HISUserPostSrv)."_AUserPost_"("""_AUserID_""","""_AUserLoc_""")"
    s @execCode
    s strRes = @"strRes" 
	q strRes
}

///  Desc:       用户是否在HIS中是诊疗组组长
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).GroupLeader("","","")
ClassMethod GroupLeader(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = "0"
	
	q strRes
}

///  Desc:       用户是否在HIS中是科主任
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Chairman("","","")
ClassMethod Chairman(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = "0"
	q:(AUserID = "")||(AUserLoc = "") strRes
	s ssuserId = $p(^CTLOC(AUserLoc),"^",54) 
	s:(ssuserId = AUserID) strRes = "1"
	q strRes
}

///  Desc:       用户是否在HIS中是质控医生
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).QCDoc("","","")
ClassMethod QCDoc(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否在HIS中是质控护士
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).QCNurse("","","")
ClassMethod QCNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否在HIS中是责任护士
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).ChargeNurse("","","")
ClassMethod ChargeNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否在HIS中是麻醉医师
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Anesthesiologist("","","")
ClassMethod Anesthesiologist(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否在HIS中是麻醉护士
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).AnesthesiaNurse("","","")
ClassMethod AnesthesiaNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否在HIS中是编码员
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Coder("","","")
ClassMethod Coder(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	
	q strRes
}

///  Desc:       用户是否为医生
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Doctor("","","")
ClassMethod Doctor(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	s strRes = ##Class(EMR.DOC.BL.PrivAssist).UserIsDoc(AUserID)
	q strRes
}

///  Desc:       用户是否为护士
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Nurse("","","")
ClassMethod Nurse(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	s strRes = ##Class(EMR.DOC.BL.PrivAssist).UserIsNur(AUserID)
	q strRes
}

///  Desc:       用户是否在HIS中是主诊医师
///  Creator:    yejian
///  CreateDate: 2022-07-06
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).InCharge("","")
ClassMethod InCharge(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	s strRes = ##Class(EMR.DOC.BL.PrivAssist).UserIsDoc(AUserID)
	q strRes
}

///  Desc:       用户是否是学生
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).student("","","")
ClassMethod student(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否实习医师
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).student("","","")
ClassMethod intern(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否进修医师
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Refresher("","","")
ClassMethod Refresher(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否规培医师
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).PlanTrain("","","")
ClassMethod PlanTrain(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否规培医生
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).TrainDoctor("","","")
ClassMethod TrainDoctor(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否患者
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Patient("","","")
ClassMethod Patient(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

///  Desc:       用户是否患者批注
///  Creator:    yejian
///  CreateDate: 2020-07-16
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     strRes 1:是/0:不是
///  Debug:      w ##Class(EMR.DOC.HISInterface.HISUserPostSrv).Notation("","","")
ClassMethod Notation(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""
	q:(AUserID = "") strRes
	q strRes
}

}
