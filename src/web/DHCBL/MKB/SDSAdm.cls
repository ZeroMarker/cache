/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断就诊表
/// Table：User.SDSAdm
Class web.DHCBL.MKB.SDSAdm Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：保存修改结构化诊断就诊表
/// Table：User.SDSAdm
/// Input：患者id，就诊号
/// Return：就诊id
/// Other: w ##class(web.DHCBL.MKB.SDSAdm).SaveData("","")
ClassMethod SaveData(SDSADMPMIDR, SDSADMNo) As %String
{
	s result=""
	s rowid=$o(^User.SDSAdmI("ADMNoIndex",SDSADMNo,0))
	if (rowid'=""){
		s result=rowid
	}else{
		s obj=##class(User.SDSAdm).%New()
		s obj.SDSADMNo=SDSADMNo
		d:SDSADMPMIDR'="" obj.SDSADMPMIDRSetObjectId(SDSADMPMIDR)
		d:SDSADMPMIDR="" obj.SDSADMPMIDRSetObjectId("")
		s sc=obj.%Save()
		d obj.%Close()	
		If $$$ISOK(sc){
			s id = obj.%Id()
			s result = id 
		}else{
			s result = ""
		}
	}		
	q result
}

}
