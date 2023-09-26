Class DHCLIS.DHCTakeRecord Extends %RegisteredObject
{

/// Creator：      sunzhiwen
/// CreatDate：    20160119
/// Description:： 保存取血单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:失败,1:成功
/// Others			w ##Class(DHCLIS.DHCTakeRecord).SaveTakeRecord("","82","哈哈哈哈哈","2@@11","1@@@@sec@@1##2@@@@10^9/L@@1","301^黄勇军^100303020101^ZZYK-卒中一科^BJLNYY^北京老年医院")
ClassMethod SaveTakeRecord(sTakeRecordDR, sReqFormDR, sTakeRecordData, sTakeRecordComponentsData, sTestItemResultData, Session)
{
	//获取登陆者者各种信息
	s UserCode = $p(Session,"^",1)
	s UserName = $p(Session,"^",2)
	s LocCode = $p(Session,"^",3)
	s LocName = $p(Session,"^",4)
	s HospitalCode = $P(Session,"^",5)
	s HospitalName = $p(Session,"^",6)
	s DoctorDR = ##Class(DHCLIS.DHCCommon).GetDoctorDR(UserCode, UserName, HospitalCode)
	s HospitalDR = ##Class(DHCLIS.DHCCommon).GetHospitalDR(HospitalCode, HospitalName)
	s ^SZW = $lb(sTakeRecordDR, sReqFormDR, sTakeRecordData, sTakeRecordComponentsData, sTestItemResultData, Session)
	s LocationDR = ##Class(DHCLIS.DHCCommon).GetLocationDR(LocCode, LocCode, LocName, HospitalDR)
	zn "dhc-lisdata"
	Set $ZTrap = "ErrorHandle"
	TSTART
	if '$l(sTakeRecordDR) {
		s objTakeRecord = ##Class(dbo.BDTakeRecord).%New()
	} else {
		s objTakeRecord = ##Class(dbo.BDTakeRecord).%OpenId(sTakeRecordDR)
	}
	
	s RetValue=1
	//保存取血单信息
	s RecordNo = ##Class(LISSP.DHCSYSRecordNumber).CreateNewNumber("TAK")  //生成单号
	s objTakeRecord.RecordNo = RecordNo
	s objTakeRecord.ReqFormDR = sReqFormDR
	if '$l(sTakeRecordDR) {
		s objTakeRecord.AddDate = $tr($zd($h,3),"-")
		s objTakeRecord.AddTime = $p($h,",",2)
		s objTakeRecord.AddUserDR = DoctorDR
		s objTakeRecord.LocationDR = LocationDR
		s objTakeRecord.Remark = sTakeRecordData
		s objTakeRecord.Status = 0
	}
	
	s sc=objTakeRecord.%Save()
 	If $system.Status.IsError(sc) TROLLBACK  s RetValue="-1^保存取血单信息失败"_$SYSTEM.Status.GetErrorText(sc) zn "dhc-app" Quit RetValue
 	s TakeRecordDR = objTakeRecord.RowID
 	
 	//保存取血单取血成分信息
 	s i =1
 	for {
	 	q:($l(sTakeRecordComponentsData,"##")<i)
	 	s TakeRecordComponents = $p(sTakeRecordComponentsData,"##",i)
	 	q:'$l(TakeRecordComponents)
	 	//TakeRecordComponentsData[i]["BloodComponentsDR"]+"@@"+TakeRecordComponentsData[i]["TakeVolumn"];
	 	s BloodComponentsDR = $p(TakeRecordComponents,"@@",1)
	 	s TakeVolumn = $p(TakeRecordComponents,"@@",2)
	 	s Units = $p(TakeRecordComponents,"@@",3)
	 	s i = i+1
	 	s objTakeRecordComponent = ##Class(dbo.BDTakeRecordComponents).%New()
	 	s objTakeRecordComponent.TakeRecordDR = TakeRecordDR
	 	s objTakeRecordComponent.BloodComponentsDR = BloodComponentsDR
	 	s objTakeRecordComponent.Volume = TakeVolumn
	 	s objTakeRecordComponent.Units = Units
	    s sc=objTakeRecordComponent.%Save()
 		If $system.Status.IsError(sc) {
	 		s RetValue="-1^保存取血单信息失败"_$SYSTEM.Status.GetErrorText(sc)
	 		q
 		}
 	}
 	i RetValue'=1{
	 	TROLLBACK
	 	zn "dhc-app"
	 	q RetValue
 	}
 	
 	//保存关注项目结果信息
 	s i = 1
 	for {
	 	q:($l(sTestItemResultData,"##")<i)
	 	s TestItemResult = $p(sTestItemResultData,"##",i)
	 	s i = i+1
	 	q:'$l(TestItemResult)
	 	//TakeRecordTestItemData[i]["TakeTestItemDR"]+"@@"+TakeRecordTestItemData[i]["Result"]+"@@"+TakeRecordTestItemData[i]["Unit"]+"@@"+TakeRecordTestItemData[i]["SeqNum"];
	 	s objTakeRecordTestItem = ##Class(dbo.BDTakeRecordTestItem).%New()
	 	s objTakeRecordTestItem.TakeRecordDR = TakeRecordDR
	 	s objTakeRecordTestItem.TakeTestItemDR = $p(TestItemResult,"@@",1)
	 	s objTakeRecordTestItem.Result = $p(TestItemResult,"@@",2)
	 	s objTakeRecordTestItem.Unit = $p(TestItemResult,"@@",3)
	 	s objTakeRecordTestItem.SeqNum = $p(TestItemResult,"@@",4)
	 	s sc=objTakeRecordTestItem.%Save()
 		If $system.Status.IsError(sc) {
	 		s RetValue="-1^保存关注项目信息失败"_$SYSTEM.Status.GetErrorText(sc)
	 		q
 		}
 	}
 	
 	i RetValue'=1{
	 	TROLLBACK
	 	zn "dhc-app"
	 	q RetValue
 	}
 	
 	TCOMMIT
 	
 	zn "dhc-app"
 	
 	q RetValue
 	
ErrorHandle
	TROLLBACK
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
	zn "dhc-app"
    Quit RetValue
}

}
