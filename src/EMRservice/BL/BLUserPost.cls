Class EMRservice.BL.BLUserPost Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(EMRservice.BL.BLUserPost).IniData()
ClassMethod IniData()
{
	&sql(delete from EMRmeta.UserPost)
 
	s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="Chairman",obj.Description="科主任",obj.OperAction="ChairmanCheck",obj.IsValid="1"
    d obj.%Save()    	
   
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="QCDoc",obj.Description="质控医师",obj.OperAction="QCDocCheck",obj.IsValid="1"
    d obj.%Save()  
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="QCNurse",obj.Description="质控护士",obj.OperAction="QCNurseCheck",obj.IsValid="1"
    d obj.%Save()   
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="ChargeNurse",obj.Description="责任护士",obj.OperAction="ChargeNurseCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="Anesthesiologist",obj.Description="麻醉医师",obj.OperAction="AnesthesiologistCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="AnesthesiaNurse",obj.Description="麻醉护士",obj.OperAction="AnesthesiaNurseCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="GroupLeader",obj.Description="诊疗组组长",obj.OperAction="GroupLeaderCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="Coder",obj.Description="编码员",obj.OperAction="coderCheck",obj.IsValid="1"
    d obj.%Save()
	
	s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="InCharge",obj.Description="主诊医师",obj.OperAction="inChargeCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EMRmeta.UserPost).%New()
	s obj.Name="",obj.Description="未分配",obj.OperAction="",obj.IsValid="1"
    d obj.%Save()
}

Query SELECTALL() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_UserPost_SELECTALL, SqlProc ]
{
	SELECT Name, Description
    FROM EMRmeta.UserPost
    WHERE IsValid = '1'
}

/// Desc:       医生职务
/// Creator:    Candy
/// CreateDate: 2015-12-18
/// Input:      AName 名称
/// Output:     result 描述
/// Debug:      w ##Class(EMRservice.BL.BLUserPost).GetDesc("Chairman")
ClassMethod GetDesc(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result 
	s id = $o(^DHCEMRM.UserPostI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(id = "") result
	s obj = ##Class(EMRmeta.UserPost).%OpenId(id)
	q:(obj = "") result
	s result = obj.Description
	q result
}

}
