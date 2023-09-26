Class DHCEPRFS.BL.HISInfo.BLBasicPlatform Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:电子病历 接口
/// Input：用户id：SSUserID
/// Return:用户所在医疗单元信息:用户所在医疗组ID^名称^描述
/// Other:w ##class(DHCEPRFS.BL.HISInfo.BLBasicPlatform).GetMedUnitData("1192")
ClassMethod GetMedUnitData(SSUserID As %String) As %String
{
 
	s result=""
	s CareProvID=$p($g(^SSU("SSUSR",SSUserID)),"^",14)
	if (CareProvID'=""){
		s CTMUCTLOCParRef=0
	     for{
		 	s CTMUCTLOCParRef=$o(^CTLOC(0,"CTPCP",CareProvID,CTMUCTLOCParRef)) q:(CTMUCTLOCParRef="")
		 	s CTMUChildsub=0
		 	for {
			 	s CTMUChildsub=$o(^CTLOC(0,"CTPCP",CareProvID,CTMUCTLOCParRef,"MU",CTMUChildsub)) q:(CTMUChildsub="")
				s CTMUCode=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",1)
		 		s CTMUDesc=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",2)
		 		s CTMURowId=CTMUCTLOCParRef_"||"_CTMUChildsub
		 		if (result=""){
			 		s result=CTMURowId_"^"_CTMUCode_"^"_CTMUDesc
			 	}else{
				 	s result=result_"*"_CTMURowId_"^"_CTMUCode_"^"_CTMUDesc	
				}
			}
	     }
	}
	q result
}

}
