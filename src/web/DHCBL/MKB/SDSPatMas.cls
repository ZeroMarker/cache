/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：结构化诊断患者表
/// Table：User.SDSPatMas
Class web.DHCBL.MKB.SDSPatMas Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：保存修改结构化诊断患者表
/// Table：User.SDSPatMas
/// Input：登记号
/// Return：患者id
/// Other: w ##class(web.DHCBL.MKB.SDSPatMas).SaveData("")
ClassMethod SaveData(SDSPMINo) As %String
{
	s result=""
	s rowid=$o(^User.SDSPatMasI("PMINoIndex",SDSPMINo,0))
	if (rowid'=""){
		s result=rowid
	}else{
		s obj=##class(User.SDSPatMas).%New()
		s obj.SDSPMINo=SDSPMINo
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
