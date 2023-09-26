Class EMRservice.BL.BLUserLevel Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(EMRservice.BL.BLUserLevel).IniData()
ClassMethod IniData()
{
	&sql(delete from EMRmeta.UserLevel)
 
	s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Resident",obj.Description="住院医师",obj.IsValid="1"
    d obj.%Save()    	
   
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Attending",obj.Description="主治医师",obj.IsValid="1"
    d obj.%Save()  
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Chief",obj.Description="主任医师",obj.IsValid="1"
    d obj.%Save()  
    
     s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="ViceChief",obj.Description="副主任医师",obj.IsValid="1"
    d obj.%Save()  

    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Doctor",obj.Description="医生",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="intern",obj.Description="实习医师",obj.IsValid="1"
    d obj.%Save()  
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="PlanTrain",obj.Description="规培医师",obj.IsValid="1"
    d obj.%Save() 
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="TrainDoctor",obj.Description="规培医生",obj.IsValid="1"
    d obj.%Save() 
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="student",obj.Description="学生",obj.IsValid="1"
    d obj.%Save() 
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Refresher",obj.Description="进修医师",obj.IsValid="1"
    d obj.%Save() 
    
    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="Nurse",obj.Description="护士",obj.IsValid="1"
    d obj.%Save()  

    s obj=##Class(EMRmeta.UserLevel).%New()
	s obj.Name="",obj.Description="未分配",obj.IsValid="1"
    d obj.%Save()
}

Query SELECTALL() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_UserLevel_SELECTALL, SqlProc ]
{
	SELECT Name, Description
    FROM EMRmeta.UserLevel
    WHERE IsValid = '1'
}

/// Desc:       取级别描述
/// Creator:    Candy
/// CreateDate: 2015-12-18
/// Input:      AName 级别
/// Output:     result 级别描述
/// Debug:      w ##Class(EMRservice.BL.BLUserLevel).GetDesc("Chief")
ClassMethod GetDesc(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result 
	s id = $o(^DHCEMRM.UserLevelI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(id = "") result
	s obj = ##Class(EMRmeta.UserLevel).%OpenId(id)
	q:(obj = "") result
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s result = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.UserLevel","Description",obj.Description,langid)
	q result
}

/// Desc:       获取弹出签名框时，高级别医师可以选择的医师级别范围
/// Creator:    董璐璐
/// CreateDate: 2018-8-27
/// Input:      医师级别
/// Output:     医师级别范围json
/// Debug:      w ##Class(EMRservice.BL.BLUserLevel).GetUserLevelRangeJson("Chief")
ClassMethod GetUserLevelRangeJson(ALevel As %String) As %String
{
	s json = ""
	q:(ALevel = "") json 
	s range = ##Class(EMRservice.SystemParameter).GetUserLevelRange(ALevel)
	q:(range = "") json
	s count=$l(range, "^")
	f i=1:1:count 
	{
		s levelCode = $p(range, "^", i)
		q:(levelCode = "")
		s levelDesc = ##Class(EMRservice.BL.BLSignRole).GetSignDesc(levelCode)
		s:(json '= "") json =json_","
		s json = json_"{"
		s json = json_"""LevelCode"":"""_levelCode_""","
		s json = json_"""LevelDesc"":"""_levelDesc_""""
    	s json = json_"}"
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

}
