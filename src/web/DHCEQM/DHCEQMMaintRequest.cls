/// By ZX 2013-09-26
/// 设备维修申请
Class web.DHCEQM.DHCEQMMaintRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 70;

/// d ##class(web.DHCEQM.DHCEQMMaintRequest).UpdateMaintRequest("","","^^2^3^2^2^2^2")
/// add by zx 2014-03-26
/// 在更新数据时,生成维修表,维修明细,维修换件,维修评价信息表
ClassMethod UpdateMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String, Evaluate As %Library.String)
{
	Set $ZT="ERRORUpdateMMaintRequest"
	k PLIST,IRowID,RowID,PLI,LI,MTIRowID,CheckFlag,FacilityEquipType
	s IRowID=$p(val,"^",1)
	s PLIST(1) = $p(val,"^",1) //MR_RowID
	//s PLIST(2) =  $p(val,"^",2) //MR_RequestNO  //add by zx 2016-11-24 新增时才处理单号
	s PLIST(3) = $p(val,"^",3) //MR_ManageTypeDR
	s PLIST(4) = $p(val,"^",4) //MR_EquipTypeDR
	s PLIST(5) = $p(val,"^",5) //MR_ObjTypeDR
	s PLIST(6) = $p(val,"^",6) //MR_ExObjDR
	s PLIST(7) = $p(val,"^",7) //MR_ObjLocDR
	s PLIST(8) = $p(val,"^",8) //MR_RequestLocDR
	s PLIST(9) = $p(val,"^",9) //MR_StartDate
	i $p(val,"^",9)'=""  s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;StartDate
	s PLIST(10) = $p(val,"^",10) //MR_StartTime
	s PLIST(11) = $p(val,"^",11) //MR_FaultCaseDR
	s PLIST(12) = $p(val,"^",12) //MR_FaultCaseRemark
	s PLIST(13) = $p(val,"^",13) //MR_FaultReasonDR
	s PLIST(14) = $p(val,"^",14) //MR_FaultReasonRemark
	s PLIST(15) = $p(val,"^",15) //MR_DealMethodDR
	s PLIST(16) = $p(val,"^",16) //MR_DealMethodRemark
	s PLIST(17) = $p(val,"^",17) //MR_EndDate
	i $p(val,"^",17)'=""  s PLIST(17) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")
	s PLIST(18) = $p(val,"^",18) //MR_EndTime
	s PLIST(19) = $p(val,"^",19) //MR_RequestDate
	i $p(val,"^",19)'=""  s PLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")
	s PLIST(20) = $p(val,"^",20) //MR_RequestTime
	s PLIST(21) = $p(val,"^",21) //MR_RequestUserDR
	s PLIST(22) = $p(val,"^",22) //MR_RequestTel
	s PLIST(23) = $p(val,"^",23) //MR_Place
	s PLIST(24) = $p(val,"^",24) //MR_FaultTypeDR
	s PLIST(25) = $p(val,"^",25) //MR_AcceptDate
	i $p(val,"^",25)'=""  s PLIST(25) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")
	s PLIST(26) = $p(val,"^",26) //MR_AcceptTime
	i $p(val,"^",26)'=""  s PLIST(26) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",26),"time")
	s PLIST(27) = $p(val,"^",27) //MR_AcceptUserDR
	s PLIST(28) = $p(val,"^",28) //MR_AssignDR
	s PLIST(29) = $p(val,"^",29) //MR_MaintModeDR
	s PLIST(30) = $p(val,"^",30) //MR_MaintLocDR
	s PLIST(31) = $p(val,"^",31) //MR_ContractDR
	s PLIST(32) = $p(val,"^",32) //MR_ServiceDR
	s PLIST(33) = $p(val,"^",33) //MR_UserSignDR
	s PLIST(34) = $p(val,"^",34) //MR_UserOpinion
	s PLIST(35) = $p(val,"^",35) //MR_ManageLocDR
	s PLIST(36) = $p(val,"^",36) //MR_ReturnFlag
	s PLIST(37) = $p(val,"^",37) //MR_MaintRequestDR
	s PLIST(38) = $p(val,"^",38) //MR_MaintRemark
	s PLIST(39) = $p(val,"^",39) //MR_EstimateWorkHour
	s PLIST(40) = $p(val,"^",40) //MR_WorkHour
	s PLIST(41) = $p(val,"^",41) //MR_Remark
	s PLIST(42) = $p(val,"^",42) //MR_Status
	If PLIST(42)="" Set PLIST(42)=0
	/*s PLIST(43) = $p(val,"^",43) //MR_AddUserDR
	s PLIST(44) = $p(val,"^",44) //MR_AddDate
	i $p(val,"^",44)'=""  s PLIST(44) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",44),"date")
	s PLIST(45) = $p(val,"^",45) //MR_AddTime
	s PLIST(46) = $p(val,"^",46) //MR_UpdateUserDR
	s PLIST(47) = $p(val,"^",47) //MR_UpdateDate
	i $p(val,"^",47)'=""  s PLIST(47) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",47),"date")
	s PLIST(48) = $p(val,"^",48) //MR_UpdateTime
	s PLIST(49) = $p(val,"^",49) //MR_SubmitUserDR
	s PLIST(50) = $p(val,"^",50) //MR_SubmitDate
	i $p(val,"^",50)'=""  s PLIST(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",50),"date")
	s PLIST(51) = $p(val,"^",51) //MR_SubmitTime
	s PLIST(52) = $p(val,"^",52) //MR_AuditUserDR
	s PLIST(53) = $p(val,"^",53) //MR_AuditDate
	i $p(val,"^",53)'=""  s PLIST(53) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",53),"date")
	s PLIST(54) = $p(val,"^",54) //MR_AuditTime
	s PLIST(55) = $p(val,"^",55) //MR_CancelUser
	s PLIST(56) = $p(val,"^",56) //MR_CancelDate
	i $p(val,"^",56)'=""  s PLIST(56) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",56),"date")
	s PLIST(57) = $p(val,"^",57) //MR_CancelTime*/
	s PLIST(58) = "N"            //MR_InvalidFlag
	s PLIST(59) = $p(val,"^",45) //MR_MaintFee
	s PLIST(60) = $p(val,"^",46) //MR_OtherFee
	s PLIST(61) = $p(val,"^",47) //MR_TotalFee
	s PLIST(62) = $p(val,"^",48) //MR_EmergencyLevelDR
	s PLIST(63) = $p(val,"^",49) //MR_SeverityLevelDR
	s PLIST(64) = $p(val,"^",50) //MR_Hold3
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") //add by zx 2017-03-30 未在帐微信报修来源处理
	i ((","_FacilityEquipType_",")[(","_$p(val,"^",4)_",")) s PLIST(64) ="2"
	i $p(val,"^",51)'="" s PLIST(65) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",51),"date") //MR_Hold4
	s PLIST(66) = $p(val,"^",52) //MR_Hold5
	s PLIST(67) = "N"            //MR_InsurFlag			//Modify ZC 2015-03-06  begin
	s PLIST(68) = $p(val,"^",54) //MR_MaintResultsDR
	s PLIST(69) = $p(val,"^",55) //MR_EquipStatusDR
	s PLIST(70) = $p(val,"^",56) //MR_MaintProcess		//Modify ZC 2015-03-06  end
	s PLIST(71) = $p(val,"^",57) //MR_MaintGroupDR          //Modify by zx 2020-12-31 BUG ZX0126
	//If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ERowID")=1 Set LI(1) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ERowID")
	//If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ESourceType")=1 Set LI(2) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ESourceType")
	//If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ESourceID")=1 Set PLI(3) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ESourceID")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EEvaluateTypeDR")=1 Set LI(4) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EEvaluateTypeDR")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EScore")=1 Set LI(5) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EScore")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EContent")=1 Set LI(6) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EContent")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ERemark")=1 Set LI(7) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ERemark")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EUserDR")=1 Set LI(8) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EUserDR")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EDate")=1 Set LI(9) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EDate")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ETime")=1 Set LI(10) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ETime")
	k PLIST(1)
	
	i IRowID'="" 
	{
		s InvalidFlag=$p($g(^DHCEQMMaintRequest(IRowID)),"^",57)
		i InvalidFlag="Y" q -1015
	}
	
	TStart
	
	If IRowID'=""
	{
		If $Piece(val,"^",43)'="" Set PLIST(46) = $Piece(val,"^",43)
		Set PLIST(47)=+$H
		Set PLIST(48)=$Piece($H,",",2)
		&sql(Update sqluser.DHC_EQMMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		Set RowID=$Get(%ROWID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		/*		//Modify DJ 2014-09-25
		&sql(Update sqluser.DHC_EQMEvaluate Values :LI() where E_SourceID=:RowID and E_SourceType=1)   
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		*/    
	}
	Else
	{
		//if $p(val,"^",6)'="" s locdr=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",5)
		If $Piece(val,"^",43)'="" Set PLIST(43) = $Piece(val,"^",43)
		Set PLIST(44)=+$H
		Set PLIST(45)=$Piece($H,",",2)
		s EquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",PLIST(4))),"^",1)
		//If PLIST(2)=""    //add by zx 2016-11-24 申请单号处理 ZX0036
		Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMMaintRequest",+$H,PLIST(8),EquipTypeCode) //Modify DJ 2016-04-19
		&sql(Insert Into SQLUser.DHC_EQMMaintRequest Values :PLIST())
		
		Set RowID=$Get(%ROWID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		/*		//Modify DJ 2014-09-25
		Set LI(2)=1
		Set LI(3)=RowID
		&sql(Insert Into SQLUser.DHC_EQMEvaluate Values :LI())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		*/
 	}
 	//维修停用设备Add By DJ 2018-03-18
 	s MStartStopFlag=$p(val,"^",57)
 	if +MStartStopFlag>=1
 	{
		s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		If TExObjDR'=""
		{
			i (SourceTypeDR=1)||(SourceTypeDR=2)
			{
				new ChangeInfoDR   ;add by kdf 需求号573050
				s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
				;检测是否已存停用记录
				K PL
				s PL(2)=EQRowID
				s PL(4)=2
				s PL(5)=+$H
				s PL(6)=31
				s PL(7)=RowID
				s PL(8)=2
				s PL(9)=1
				s PL(10)=2
				s PL(14)="维修停用"
				s PL(16)="N"
				s PL(18)=+$H             ;add by kdf 2018-03-27 需求号573023
	            s PL(19)=$P($H,",",2)    ;add by kdf 2018-03-27 需求号573023
				s PL(23)=+$H
				s PL(24)=$P($H,",",2)
				s PL(25)=$Piece(val,"^",43)
				s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",EQRowID,2,31,RowID,0))
				i CIRowID=""
				{
					&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
					i SQLCODE
					{
						TROLLBACK
						q SQLCODE
					}
					//add by kdf 需求号573050 begin********
					s ChangeInfoDR=$G(%ROWID)
					k LI
					s LI(2)=EQRowID  //设备
					s LI(4)=$p($g(^DHCEQEquip(EQRowID)),"^",19)   	//原使用科室
					s LI(5)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//原管理科室
					s LI(6)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//原库房
					s LI(7)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//原值
					s LI(8)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//原净值
					s LI(9)=$p($g(^DHCEQEquip(EQRowID)),"^",19)  	//变动后使用科室
	 				s LI(10)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//变动后管理科室
	 				s LI(11)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//变动后库房
	 				s LI(12)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//变动后原值
	 				s LI(13)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//变动后净值
					s LI(14)="停用"
					s LI(16)=+$H	//变动日期
					s LI(17)=$P($H,",",2)	//变动时间
					;s LI(18)=depreFee //折旧费用
					s LI(19)="C"	//生命周期类型
					s LI(20)=41		//来源类型
					s LI(21)=ChangeInfoDR	//来源ID
					s LI(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//更新人
					s LI(28)=+$H	//更新日期
					s LI(29)=$P($H,",",2)	//更新时间
					&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
					//add by kdf 需求号573050 end ********
				}
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
				&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=2 where EQ_RowID=:EQRowID)
			}
		}
 	}
  	If SQLCODE
	{
		TRollBack
		Quit SQLCODE
	}
	
	TCOMMIT
	Quit RowID
ERRORUpdateMMaintRequest
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORUpdateMMaintRequest"_ErrorMsg     //返回错误消息
}

/// w ##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintRequest("","",307,"","WX_Maint","")  //Modify DJ 2016-04-05
ClassMethod GetOneMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String, ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	new result,resultex
	s (result,resultex,EQRowID)=""
	s result=^DHCEQMMaintRequest(rowid)
	s SourceTypeDR=$p(result,"^",63)		//MRHold3
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	//MR_ManageTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEMCManageType",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	//MR_EquipTypeDR
	i $p(result,"^",3)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	//MR_ObjTypeDR
	i $p(result,"^",4)'=""  d
	.i (SourceTypeDR=1)||(SourceTypeDR=2)  d	//设备类型		//add by zx 2017-03-20 BUG ZX0036
	..s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",4))),"^",2)
	.e  d
	..s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCObjType",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	//MR_ExObjDR  
	i $p(result,"^",5)'=""  d
	.i (SourceTypeDR=1)||(SourceTypeDR=2)  d	//设备名称		//add by zx 2017-03-20 BUG ZX0036
	..s EQRowID=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",5)		//Modify DJ 2015-08-14 DJ0156 begin
	..s resultex=resultex_$Piece($Get(^DHCEQEquip(EQRowID)),"^",1)		//Modify DJ 2015-08-14 DJ0156 end
	.e  d  
	..s resultex=resultex_$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",1)
	s resultex=resultex_"^"	//MR_ObjLocDR
	i $p(result,"^",6)'=""  d  
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",6))
	s resultex=resultex_"^"	//MR_RequestLocDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",7))
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date") //MR_StartDate
	s resultex=resultex_"^"	//MR_FaultCaseDR
	i $p(result,"^",10)'=""  d   
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",$p(result,"^",10))),"^",2)
	s resultex=resultex_"^"	//MR_FaultReasonDR
	i $p(result,"^",12)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",$p(result,"^",12))),"^",2)
	s resultex=resultex_"^"	//MR_DealMethodDR
	i $p(result,"^",14)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",$p(result,"^",14))),"^",2)
	s $p(result,"^",16)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")  //MR_EndDate
	s $p(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date" ) //MR_RequestDate
	s resultex=resultex_"^"	;RequestUserDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	s resultex=resultex_"^"	//MR_FaultTypeDR
	i $p(result,"^",23)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCFaultType",$p(result,"^",23))),"^",2)
	s $p(result,"^",24)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"date") //MR_AcceptDate
	s resultex=resultex_"^"	//MR_AcceptUserDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",26))
	s resultex=resultex_"^"	//MR_AssignDR
	i $p(result,"^",27)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",27))
	s resultex=resultex_"^" //MR_MaintModeDR
	i $p(result,"^",28)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCMaintMode",$p(result,"^",28))),"^",2)
	s resultex=resultex_"^"	//MR_MaintLocDR
	i $p(result,"^",29)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",29))
	s resultex=resultex_"^"	//MR_ContractDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQContract($p(result,"^",30))),"^",1)
	s resultex=resultex_"^" //MR_ServiceDR
	i $p(result,"^",31)'=""  d  
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cservice",$p(result,"^",31))		//CZF0093
	s resultex=resultex_"^"	//MR_UserSignDR
	i $p(result,"^",32)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",32))
	s resultex=resultex_"^"	//MR_ManageLocDR
	i $p(result,"^",34)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",34))
	s resultex=resultex_"^"	//MR_MaintRequestDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQMMaintRequest($p(result,"^",36))),"^",1)
	s resultex=resultex_"^"	//MR_AddUserDR
	i $p(result,"^",42)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",42))
	s $p(result,"^",43)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",43),"date") //MR_AddDate
	s resultex=resultex_"^"	//MR_UpdateUserDR
	i $p(result,"^",45)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",45))
	s $p(result,"^",46)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",46),"date") //MR_UpdateDate
	s resultex=resultex_"^"	//MR_SubmitUserDR
	i $p(result,"^",48)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",48))
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"date") //MR_SubmitDate
	s resultex=resultex_"^"	//MR_AuditUserDR
	i $p(result,"^",51)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",51))
	s $p(result,"^",52)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",52),"date") //MR_AuditDate
	s resultex=resultex_"^"	//MR_CancelUserDR
	i $p(result,"^",54)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",54))
	s $p(result,"^",55)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",55),"date") //MR_CancelDate
	s $p(result,"^",58)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",58),"")	//Modify DJ 2015-09-14 DJ0164
	s $p(result,"^",59)=##Class(web.DHCEQCommon).FormatNumber(..GetTotalFee(rowid,1),"")	//Add By DJ 2014-09-23
	s resultex=resultex_"^" //MR_EmergencyLevelDR
	i $p(result,"^",61)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCEmergencyLevel",$p(result,"^",61))),"^",2)
	s resultex=resultex_"^" //MR_SeverityLevelDR
	i $p(result,"^",62)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCSeverityLevel",$p(result,"^",62))),"^",2)		//Modify DJ 2014-09-21
	s $p(result,"^",64)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",64),"date" ) //AssignDate(Hold4)Add By DJ 2014-09-22
	s $p(result,"^",66)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",66),"bool" ) //InsurFlag
	s resultex=resultex_"^" //MR_MaintResults														//Modify ZC 2015-03-06  begin
	i $p(result,"^",67)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQMCMaintResults",$p(result,"^",67))),"^",2)
	s resultex=resultex_"^" //MR_EquipStatusDR
	i $p(result,"^",68)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQEquipStatus",$p(result,"^",68))),"^",2)		//Modify ZC 2015-03-06  end
	
	;Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("25",rowid)
	;s ^DHCEQMozy("AppInfo",rowid)=AppInfo
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("25",rowid,ApproveRoleDR)
	;s ^DHCEQMozy("AppInfo",rowid,+ApproveRoleDR)=AppInfo
	//Add By DJ 2014-09-21
	//modified by wy 2022-4-12 SourceTypeDR类型
	i $p(result,"^",5)'=""  d
	.i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)  d	//设备名称		//add by zx 2017-03-20 BUG ZX0036
	..s EQRowID=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",5)			//Modify DJ 2015-08-21 DJ0157 begin
	..s EQNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",71)
	..s Model=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	..i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	..s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"")		//Modify DJ 2015-08-21 DJ0157 end
	.e  d  
	..s EQNo=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",2)
	..s Model=""
	..s OriginalFee=""
	
	s Initials=""
	i $p(result,"^",26)'=""  s Initials=##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",26))
	s MaintGroup=""
	i $p(result,"^",70)'="" s MaintGroup=##Class(web.DHCEQCommon).GetTrakNameByID("maintgroup",$p(result,"^",70))	//Modify DJ 2016-04-21
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	s Request=result_resultex_"^"_AppInfo_"^"_EQNo_"^"_Model_"^"_OriginalFee_"^"_Initials_"^"_MaintGroup
	;设备启用日期 modified by wy 2022-4-12
	s Request=Request_"^"
	i EQRowID'="" d
	.s Request=Request_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EQRowID)),"^",44),"date" )
	.s Request=Request_"^"_$p($g(^DHCEQEquip(EQRowID)),"^",85)	;FileNo
	//add by zx 2016-12-28 ZX0036 维修进程解析
	s Request=Request_"^"	//MR_MaintProcess
	i $p(result,"^",69)'=""  d
	.s Request=Request_$Piece($Get(^DHCEQCCode("DHCEQMCMaintProcess",$p(result,"^",69))),"^",2)
	//Modify by zx 2021-01-29 BUG ZX0128
	s CurRoleInfo="^"
	//Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	//Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, $p(result,"^",3), "", "", "", "")
	s MaintType=$Piece($G(^DHCEQMMaintRequest(rowid)),"^",76)  	//维修类型 1:工程师申请 "":科室申请
	s ManageTypeDR =$Piece($G(^DHCEQMMaintRequest(rowid)),"^",2)  //add by wy 2022-4-7管理类型 1：设备维修2：软件问题3：软件需求4：信息设备
	s MaintModeDR=$Piece($G(^DHCEQMMaintRequest(rowid)),"^",28)   //add by wy 2022-5-5 维修方式1:自修；2:保修合同3:委外维修
	s ApproveCondition="MaintType,DHCEQMMaintRequest,"_MaintType_"^ManageType,DHCEQMMaintRequest,"_ManageTypeDR_"^MaintMode,DHCEQMMaintRequest,"_MaintModeDR
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, $p(result,"^",3), "", "", "", "",ApproveCondition)	//modified by CZF0075 2020-02-26 end
	
	i (action'="")&&(ApproveSet'="") s CurRoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,action)
	i (CurRoleInfo'="")&&(step="") s step=$p(CurRoleInfo,"^",2)
	
	Set Evaluate=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneEvaluate(1,rowid,"")		//Modify DJ 2014-09-25
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("25",action,rowid,2)  //add by zx 2016-03-14 BugZX0035
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.Set MultipleRoleFlag=1
	
	s PicNum=##class(web.DHCEQ.Process.DHCEQPictureList).GetPictureNumBySourceID(31,rowid,"")		//czf 2020-10-18
	s HistoryNum=0
	i EQRowID'="" s HistoryNum=##class(web.DHCEQM.DHCEQMMaintRequest).GetHistoryQuantity("31",EQRowID)
	//Modify by zx 2021-01-19 BUG ZX0127
	;s CurRoleInfo="^"
	;i action'="" s CurRoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction("37",action)
	s MediaInfo=##Class(web.DHCEQ.Lib.Common).GetVideoAndAudioInfo("31",rowid)
	Quit Request_"@"_Evaluate_"@"_MultipleRoleFlag_"@"_PicNum_"@"_HistoryNum_"@"_MediaInfo_"@"_CurRoleInfo
}

/// w ##class(web.DHCEQM.DHCEQMMaintRequest).GetOneEvaluate(1,61)
/// Modify DJ 2014-09-25
/// Modify BY:GBX 2015-03-17 15:30:15 修改了表结构
/// DHC_EQMEvaluate->DHC_EQEvaluate ^DHCEQMEvaluate->^DHCEQEvaluate
ClassMethod GetOneEvaluate(SourceType, SourceID, vRole As %String = "")
{
	new (result,resultex,ERowID,SourceType,SourceID,vRole)
	Set (result,resultex,ERowID)=""
	
	Set ERowID=$Order(^DHCEQEvaluate(0,"SourceID",SourceType,SourceID,0))
	Quit:ERowID="" ""
	s ERowID=0
	f  s ERowID=$o(^DHCEQEvaluate(0,"SourceID",SourceType,SourceID,ERowID))  q:ERowID=""  d
	.s EApproveRole=$p($g(^DHCEQEvaluate(ERowID)),"^",6)
	.q:(vRole'="")&&(EApproveRole'=vRole)
	.s ETypeDR=$p($g(^DHCEQEvaluate(ERowID)),"^",3)
	.s ECode=""
	.i ETypeDR'="" s ECode=$p($g(^DHCEQCCode("DHCEQCEvaluateType",ETypeDR)),"^",1)
	.s EScore=$p($g(^DHCEQEvaluate(ERowID)),"^",4)
	.s EvaluateInfo=EApproveRole_","_ECode_","_EScore
	.s result=result_"^"_EvaluateInfo
	
	q result
}

/// w ##class(web.DHCEQM.DHCEQMMaintRequest).SubmitMaintRequest("","",1,1,1)
ClassMethod SubmitMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", MRRowID As %Library.String, MRStatus As %Library.String, User As %Library.String, GroupID As %Library.String = "")
{
	//midified by zy 2015-7-1 ZY0132 
	n UnusualStatus,UnusualRemark
	s UnusualStatus="3"
	s UnusualRemark="报修"
	
	Set $ZT="ERRORSubmit"
	i MRRowID'="" 
	{
		s InvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
		i InvalidFlag="Y" q -1015
	}
	s EquipTypeDR=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",3)
	s Status=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",41)
	
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	s MaintType=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",76)  	//维修类型 1:工程师申请 "":科室申请
	s ManageTypeDR =$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",2)  //add by wy 2022-4-7管理类型 1：设备维修2：软件问题3：软件需求4：信息设备
	s MaintModeDR=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",28)   //add by wy 2022-5-5 维修方式1:自修；2:保修合同3:委外维修
	s ApproveCondition="MaintType,DHCEQMMaintRequest,"_MaintType_"^ManageType,DHCEQMMaintRequest,"_ManageTypeDR_"^MaintMode,DHCEQMMaintRequest,"_MaintModeDR
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "", "",ApproveCondition)	//modified by CZF0075 2020-02-26 end
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, MRRowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="")
	{
		Set AuditFlag=1
		Set AppInfoStatus="2"			;AppInfoStatus
	}

	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))  //add by zx 2015-06-19
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")  //add by zx 2016-04-19 移动端session值问题
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,MRRowID,"25",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,MRRowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE

	{
		TROLLBACK
		Quit SQLCODE
	}
	Set SMDate=+$H
	Set SMTime=$Piece($H,",",2)
	&sql(Update sqluser.DHC_EQMMaintRequest set MR_Status=:MRStatus,MR_SubmitUserDR=:User,MR_SubmitDate=:SMDate,MR_SubmitTime=:SMTime  where MR_RowID=:MRRowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//维修部位登记	Add By DJ 2014-09-23
	s MIRowID=$o(^DHCEQMMaintItem(0,"MaintRequest",MRRowID,0))
	k MIPLIST
	i MIRowID=""
	{
		s MIPLIST(3)=1
		s MIPLIST(8)=MRRowID
		&SQL(insert into SQLUSER.DHC_EQMMaintItem values :MIPIST())
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	i AuditFlag=1
	{
		Set SQLCODE= ##Class(web.DHCEQM.DHCEQMMaintRequest).LastAuditAction(MRRowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		//midified by zy 2015-7-1 ZY0134
		s (UnusualStatus,UnusualRemark)=""
	}	
 	//midified by zy 2015-7-1 ZY0134
 	//修改设备显示状态信息
 	s EquipID=""
	s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",63)	//Add By DJ 2014-09-21
	i ObjSourceTypeDR=1    //add by zx 2016-06-15
	{
		s ObjDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",5)
		i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
 		s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^更新设备异常状态信息失败!"
		} 
	}
	//Modify by zx 2020-12-31 BUG ZX0126
	s (vLimitActions,vLimitUserDR)=""
	s CurAcceptUserDR=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",26)
	i (CurAcceptUserDR'="")
	{
		s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))
		s vLimitUserDR=CurAcceptUserDR
	}
	
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", MRRowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,GroupID,vLimitActions,vLimitUserDR,"","")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//end by zy 
 	/*s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", MRRowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,GroupID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}*/
	;Mozy		2020-1-19	设置共享资源设备故障状态
	s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(31,MRRowID,MRStatus)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	Tcommit
	Quit 0
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息
}

ClassMethod CancelSubmitData(val, CurRole, Action As %Library.String = "")
{
	;new (val,CurRole)
	//midified by zy 2015-7-1 ZY0134
	s UnusualFlag=0
	Set $ZT="ERRORCancel"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID=""

	Set User=$Piece(val,"^",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
		//midified by zy 2015-7-1 ZY0134 
		s ApproveSetDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",1)
		Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSetDR, Step, ApproveRoleDR)
		if Actions["UpdateUnusualStatus"
		{
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
		else
		{
			s UnusualStatus="3"
			s UnusualRemark="报修"
		}
		s UnusualFlag=1
	}
	//midified by zy 2015-7-1 ZY0134
	else
	{
		s (UnusualStatus,UnusualRemark)=""
		s UnusualFlag=1
	}

	TSTART
	;Set PLIST(4)=RejectReasonDR
	//Set PLIST(9)=User		;RejectUserDR
	//Set PLIST(10)=Date		;RejectDate
	Set PLIST(11)=Status
	;Set PLIST(12)=Remark
	

	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	i Action'="" d
	.s CurRole=$p(##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,Action),"^",1)
	.s RoleStep=$p(##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,Action),"^",2)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}

	&sql(Update sqluser.DHC_EQMMaintRequest set MR_Status=:Status,MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	else
	{
		s ApproveFlow="^^^^^^^^"_ApproveSet	//Add By DJ 2016-05-23
	}
	
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	s EquipID=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)	//Add By DJ 2014-09-21
		i ObjSourceTypeDR=1    //add by zx 2016-06-15
		{
			s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
			i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
		 	
	 		s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^更新设备异常状态信息失败!"
			} 
		}
		
	}
	//end by zy
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;Mozy		2020-1-19	设置共享资源设备故障状态
	s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(31,MRRowID,Status)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT

 	Quit RowID
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息
}

/// SubFlag	建单人
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetMaintRequest",2,"","","","",18,"on","")
Query GetMaintRequest(Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", LocFlag As %String = "", UserFlag As %String = "", GroupID As %String = "", CurUser As %String = "", vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TExObjDR:%String,TExObj:%String,TUseLoc:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TReturnFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TCancelUserDR:%String,TCancelDate:%String,TCancelTime:%String,TExObj:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TCancelUser:%String,TMaintLocDR:%String,TMaintRemark:%String,TService:%String,TServiceDR:%String,TOtherFee:%String,TRequestNO:%String,TObjTypeDR:%String,TObjType:%String,TManageTypeDR:%String,TManageType:%String,TServiceDR:%String,TService:%String,TWorkHour:%String,TEstimateWorkHour:%String,TContract:%String,TContractDR:%String,TObjType:%String,TObjTypeDR:%String,TManageType:%String,TManageTypeDR:%String,TService:%String,TServiceDR:%String,TPlace:%String,TRequestUserDR:%String,TRequestTel:%String,TRequestUser:%String,TEmergencyLevelDR:%String,TEmergencyLevel:%String,TSeverityLevelDR:%String,TSeverityLevel:%String,TPriprityLevel:%String,TPrescription:%String,TEquipNo:%String,TFileNo:%String,TRow:%String,TTransAssetDate:%String,TMaintType:%String")
{
}

ClassMethod GetMaintRequestExecute(ByRef qHandle As %Binary, Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", LocFlag As %String = "", UserFlag As %String = "", GroupID As %String = "", CurUser As %String = "", vData As %String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR,CurStep,NextAFDR,tmpNextFlowStep
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If CurUser="" Set CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	If GroupID="" Set GroupID=%session.Get("LOGON.GROUPID")
 	;s ^Temp("20181115",2)=Status_","_ExObjDR_","_RequestLocDR_","_StartDate_","_EndDate_","_ApproveRole_","_ WaitAD_","_QXType_","_ RequestNo_","_InvalidFlag_","_LocFlag_","_UserFlag_","_GroupID_","_CurUser_","_vData
 	s TRow=0
 	s TempID=$I(^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H))
 	d ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQMMaintRequest.DHCEQMMaintRequest",TempID)
 	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
 	Set Action=##Class(web.DHCEQCommon).GetDataByName(vData,"Action")
 	Set SubFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"SubFlag")
 	Set UserRequestFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestFlag")
 	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set vStatus=##Class(web.DHCEQCommon).GetDataByName(vData,"vStatus")
 	i vStatus'="" s Status=vStatus
 	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	Set index=1
	s indexnew=1
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQMMaintRequest(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQMMaintRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	
	..For  Set rowid=$Order(^DHCEQMMaintRequest(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetMMaintRequest
	e  d
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQMMaintRequest(rowid))  Quit:rowid=""  Do
	..d BuildDataGetMMaintRequest
	
	s Level=""
	f  s Level=$o(^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H,TempID,Level),-1)  q:Level=""  d
	.s rowid=0
	.f  s rowid=$o(^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H,TempID,Level,rowid))  q:rowid=""  d
	..s info=$g(^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H,TempID,Level,rowid))
	..s TRow=TRow+1
	..s ^CacheTemp(repid,indexnew)=$Li(info,1,98)_$lb(TRow)_$Li(info,99,$LL(info))
	..s indexnew=indexnew+1
	k ^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H,TempID)
	
	Quit $$$OK
	
BuildDataGetMMaintRequest
    Do ResetVariablesGetMMaintRequest
	Set TRowID = rowid
	s MRFlag=$p($g(^DHCEQMMaintRequest(rowid)),"^",57)
	i MRFlag="" s MRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=MRFlag)
	s EquipTypeDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",3)		//Add By DJ 2014-09-21
	q:(EquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","2")=1)	//Add By ZX 2017-03-20 BUG ZX0036
	Set TExObjDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",5)
	;Quit:(ExObjDR'="")&&(TExObjDR'=ExObjDR)
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",63)
	s TItemDR=""
	If TExObjDR '=""  d 
	.i (SourceTypeDR=1)||(SourceTypeDR=2)  d  //add by zx 2017-03-20 BUG ZX0036
	..Set TExObjDR=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)	//Modify DJ 2015-08-14 DJ0156
	..i TExObjDR'=""  d
	...Set TExObj = $Piece($Get(^DHCEQEquip(TExObjDR)),"^",1)
	...Set TEquipNo=$Piece($Get(^DHCEQEquip(TExObjDR)),"^",71)
	...Set TFileNo=$Piece($Get(^DHCEQEquip(TExObjDR)),"^",85)
	...Set TSatatCatDR=$Piece($Get(^DHCEQEquip(TExObjDR)),"^",75) //add by zx 2015-08-20  权限参数
	...Set TEquipCatDR=$Piece($Get(^DHCEQEquip(TExObjDR)),"^",4)  //add by zx 2015-08-20
	...Set TItemDR=$Piece($Get(^DHCEQEquip(TExObjDR)),"^",7)
	...Set TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQEquip(TExObjDR)),"^",45),"date")
	.e  d
	..Set TExObj = $Piece($Get(^DHCEQMExObj(TExObjDR)),"^",1)
	Quit:(ExObjDR'="")&&(TExObjDR'=ExObjDR)
	Set TUseLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",6)	//Modify DJ 2014-09-21
	Quit:(UseLocDR'=TUseLocDR)&(UseLocDR'="")
	if TUseLocDR '="" set TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	Set TRequestLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",7)
	Quit:((RequestLocDR'="")&&(TRequestLocDR'=RequestLocDR)&&(TUseLocDR'=RequestLocDR))		//Modify DJ 2015-12-18
	q:((LocFlag'="")&&(TRequestLocDR'=LocFlag))		//Modify DJ 2014-09-22	
	;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR))) 
	If TRequestLocDR '=""  Do
	.Set TRequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLocDR)
	Set TFaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",10)
	If TFaultCaseDR '=""  Do
	.Set TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",TFaultCaseDR)),"^",2)
	Set TFaultCaseRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",11)
	Set TFaultReasonDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",12)
	If TFaultReasonDR '=""  Do
	.Set TFaultReason = $Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",TFaultReasonDR)),"^",2)
	Set TFaultReasonRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",13)
	Set TDealMethodDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",14)
	If TDealMethodDR '=""  Do
	.Set TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",TDealMethodDR)),"^",2)
	Set TDealMethodRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",15)
	Set TStartDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",8),"date")
	Set TStartTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",9)
	Set TEndDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16),"date")
	Set TEndTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",17)
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	Quit:($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18)<StartDate)!($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18)>EndDate)
	Set TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18),"date")
	Set TRequestTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",19)
	set TRequestUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",20)
	Quit:((UserRequestFlag'="")&&(TRequestUserDR'=CurUser))		//Add By DJ 2015-12-18
	Set TFaultTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",23)
	If TFaultTypeDR '=""  Do
	.Set TFaultType = $Piece($Get(^DHCEQCCode("DHCEQMCFaultType",TFaultTypeDR)),"^",2)
	Set TAcceptDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",24),"date")
	Set TAcceptTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",25)
	Set TAcceptUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",26)
	If CurUser="" s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//Add By zx 2015-06-25
	Quit:((TAcceptUserDR'="")&&(UserFlag'="")&&(TAcceptUserDR'=CurUser))	//Add By ZX 2015-09-09 BugZX0032
	s MaintGroupDR=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",70)		//Add By DJ 2015-12-18
	s MGFind=0
	i MaintGroupDR'=""  d
	.s MGRowID=0
	.f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"leader",1,CurUser,MGRowID))  q:(MGRowID="")||(MGFind'=0)  d
	..s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
	..q:MGInvalidFlag="Y"
	..q:MGRowID'=MaintGroupDR
	..s MGFind=1
	.s MGLRowID=0
	.f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",CurUser,MGLRowID))  q:(MGLRowID="")||(MGFind'=0)  d
	..s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
	..q:MGRowID'=MaintGroupDR
	..s MGType=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",1)
	..q:MGType'=1
	..s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
	..q:MGInvalidFlag="Y"
	..s MGFind=1
	q:((MaintGroupDR'="")&&(MGFind'=1)&&(Action'=""))  //add by zx 2016-12-12 科室确认配件等不参加维修组过滤 ZX0036
	If TAcceptUserDR '=""  Do
	.Set TAcceptUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAcceptUserDR) //add by zx 2018-08-13 $Piece($Get(^SSU("SSUSR",TAcceptUserDR)),"^",2)
	Set TAssignDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",27)
	If TAssignDR '=""  Do
	.Set TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	Set TMaintModeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",28)
	If TMaintModeDR '=""  Do
	.Set TMaintMode = $Piece($Get(^DHCEQCCode("DHCEQMCMaintMode",TMaintModeDR)),"^",2)
	Set TMaintFee = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",58)
	Set TUserSignDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",32)
	If TUserSignDR '=""  Do
	.Set TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	Set TUserOpinion = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",33)
	Set TManageLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",34)
	If TManageLocDR '=""  Do
	.Set TManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TManageLocDR)
	Set TReturnFlag = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",35)
	If (TReturnFlag = "Y")  DO
	.set TMaintRequestDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",36)
	.If TMaintRequestDR '=""  DO
	..set TMaintRequest = $Piece($Get(^DHCEQMMaintRequest(TMaintRequestDR)),"^",1)
	Set TRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",40)
	Set TStatus = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)
	Quit:(WaitAD="on")&&(TStatus="0")
	Quit:(Status'="")&&(TStatus'=Status)
	Quit:TStatus=3     //add by jyp 2020-03-12 JYP0023
	Set TAddUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",42)
	Quit:(SubFlag=1)&&(TAddUserDR'=CurUser)
	If TAddUserDR '=""  Do
	.Set TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	Set TAddDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",43),"date")
	Set TAddTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",44)
	Set TUpdateUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",45)
	If TUpdateUserDR '=""  Do
	.Set TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	Set TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",46),"date")
	Set TUpdateTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",47)
	Set TSubmitUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",48)
	If TSubmitUserDR '=""  Do
	.Set TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	Set TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",49),"date")
	Set TSubmitTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",50)
	Set TAuditUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",51)
	If TAuditUserDR '=""  Do
	.Set TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	Set TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",52),"date")
	Set TAuditTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",53)
	Set TCancelUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",54)
	If TCancelUserDR '=""  Do
	.Set TCancelUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUserDR)
	Set TCancelDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",55),"date")
	Set TCancelTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",56)
	Set TMaintLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",29)
	If TMaintLocDR '=""  DO
	.s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	Set TMaintRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",37)
	Set TOtherFee = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",59)
	Set TRequestNO = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",1)
	set TServiceDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",31)
	If TServiceDR '=""  DO
	.set TService = ##class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR) //CZF0093
	set TManageTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",2)
	If TManageTypeDR '=""  DO
	.s TManageType = $Piece($Get(^DHCEQCCode("DHCEQMCManageType",TManageTypeDR)),"^",2)
	set TObjTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",4)
	If TObjTypeDR '=""  DO
	.s TObjType = $Piece($Get(^DHCEQCCode("DHCEQMCObjType",TObjTypeDR)),"^",2)
	set TContractDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",30)
	If TContractDR '=""  DO
	.set TContract = $Piece($Get(^DHCEQContract(TContractDR)),"^",2)
	set TEstimateWorkHour = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",38)
	set TWorkHour = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",39)
	set TRequestUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",20)
	If TRequestUserDR '= ""  Do
	.set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	set TRequestTel = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",21)
	set TPlace = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",22)
	set TEmergencyLevelDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",61)
	If TEmergencyLevelDR '= ""  Do
	.set TEmergencyLevel = $Piece($Get(^DHCEQCCode("DHCEQMCEmergencyLevel",TEmergencyLevelDR)),"^",2)
	set TSeverityLevelDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",62)
	If TSeverityLevelDR '= ""  Do
	.set TSeverityLevel = $Piece($Get(^DHCEQCCode("DHCEQMCSeverityLevel",TSeverityLevelDR)),"^",2)
	s TMaintType=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",76)	//add by CZF0075 2020-02-25
	//add by zx 2016-02-29 审批权限处理 Bug ZX0039
	Set roleFlag=0
	If ApproveRole'="" 
	{
		Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	    Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	    Quit:ApproveInfoID=""
	    Set ApproveRoleDR = $Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",4)
	    If (ApproveRole'=ApproveRoleDR)&&(WaitAD="on") Set roleFlag=1
	    Set CurStep=$Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	    s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("25",rowid),ApproveRole,Action)
	    // 单据当前处在非必要步骤，紧接着的首次必要步奏可见
	    ;i (1=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("25",Action,rowid)) d
	    ;.Set TMultipleRoleFlag=1
	    ;.Set roleFlag=0
	    // 单据符合某一步骤中断条件时，中断角色可见
	    s TCanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("25",Action,rowid,2)
	    i (CurStep'=RoleStep)&&(WaitAD="on") Set roleFlag=1 //add by zx 2016-03-15 BugZX0035角色一致时 通过步骤过滤
	    i ($p(TCanChangeValue,"^",3)'="")&&((","_$p(TCanChangeValue,"^",3))[(","_RoleStep_",")) d
	    .Set roleFlag=0 
	}
	Quit:roleFlag'=0
	
	/*
	/// Mozy	2016-1-4
	Set roleFlag=0
	If ApproveRole'=""
	{
		If (ApproveRole=2)&('##class(web.DHCEQM.DHCEQMMaintPart).CheckMaintPartQuantity(rowid)) Set roleFlag=1		; 检测该维修单是否有待审核的配件
		Quit:roleFlag'=0
		Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
		Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "", "")
		Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
		If ApproveInfoID="" Set roleFlag=1
		Quit:roleFlag'=0
		
		;逆向取到本轮审批的开始步骤,是必要步骤则退出继续
		Set tmpNextFlowStep=$Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
		Set NextAFDR=""
		Set AFHold4Flag=""
		Do
		{
			Set tmpNextFlowStep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,tmpNextFlowStep),-1)
			If tmpNextFlowStep'="" Set NextAFDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,tmpNextFlowStep,""))
			If NextAFDR'="" Set AFHold4Flag=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",10)
		}While (AFHold4Flag="Y")&(tmpNextFlowStep'="")
		
		Set ApproveRoleDR=","
		Set AFHold4Flag = "Y"		;重置非必填项
		For  Set tmpNextFlowStep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,tmpNextFlowStep)) Quit:(tmpNextFlowStep="")||(AFHold4Flag '= "Y")  Do
		.Set NextAFDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,tmpNextFlowStep,""))
		.Set AFHold4Flag=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",10)
		.Set ApproveRoleDR = ApproveRoleDR_$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",2)_","
		
		If (ApproveRoleDR'[(","_ApproveRole_","))&&(WaitAD="on") Set roleFlag=1
	}
	*/
	Quit:(roleFlag'=0)&($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)=1)
	
	s CMLReturn=0		//Add By DJ 2016-05-25 begin
	s ActionDR=""
	i Action'="" s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
	i ((Action="WX_Assign")||(Action="WX_Evaluate"))  d		//派单，组长审核操作
	.i ((Status'="0")||(InvalidFlag="N"))  d		//查询有效单据
	..s MsgFind=0
	..s MRowID=""
	..f  s MRowID=$o(^DHCEQMessages(0,"MessageType",1,31,rowid,MRowID),-1)  q:(MRowID="")||(MsgFind'=0)  d
	...s MStatus=$p($g(^DHCEQMessages(MRowID)),"^",14)
	...q:((Status="1")&&(WaitAD="on")&&(MStatus'=1))
	...s MDealFlag=$p($g(^DHCEQMessages(MRowID)),"^",21)
	...q:((Status="1")&&(WaitAD="on")&&(MDealFlag="Y"))
	...s MRIRowID=0
	...f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",CurUser,0,MRowID,MRIRowID))  q:(MRIRowID="")||(MsgFind'=0)  d
	....s MRIRoles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
	....q:MRIRoles=""
	....s MRIAction=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
	....q:(","_MRIAction_",")'[(","_ActionDR_",")
	....s MsgFind=1
	..i MsgFind=0 s CMLReturn=1		//无消息不显示
	.e  d
	..s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(CurUser,GroupID,ApproveRole,EquipTypeDR,TSatatCatDR,TEquipCatDR,TUseLocDR,TExObjDR,TItemDR)
	e  d
	.s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(CurUser,GroupID,ApproveRole,EquipTypeDR,TSatatCatDR,TEquipCatDR,TUseLocDR,TExObjDR,TItemDR)
	
	//add by zx 2016-11-30 申请不为权限内设备时,申请人可见 ZX0036
	q:(CMLReturn'=0)&&((SubFlag'=1))			//Add By DJ 2016-05-25 end

	//add by zx 2016-11-30 申请不为权限内设备时,申请人可见
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(CurUser,GroupID,ApproveRole,EquipTypeDR,TSatatCatDR,TEquipCatDR,TUseLocDR,TExObjDR,TItemDR))&&(SubFlag'=1)
	s TPriprityLevel=##Class(web.DHCEQPriorityRule).GetPriorityLevel("25",rowid,ApproveRole)
	q:TPriprityLevel=""
	s TPrescription=##Class(web.DHCEQPriorityRule).GetPrescriptionAlarm("25",rowid,ApproveRole)
	q:TPrescription=""
	//新增状态不显示审批信息,工程师一次性补录单据填写完整信息时显示
	;i TStatus=0 s (TFaultReason,TFaultType,TAcceptDate,TAcceptUser,TEndDate,TDealMethod,TMaintMode,TEmergencyLevel,TSeverityLevel,TEstimateWorkHour,TWorkHour,TSubmitDate,TFaultReasonRemark,TDealMethodRemark)=""
	
	Set TStatus=..GetStatus(TStatus)
	
	Do OutputRowGetMMaintRequest
	Quit
OutputRowGetMMaintRequest
	Set Data=$lb(TRowID,TExObjDR,TExObj,TUseLoc,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TReturnFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TExObj,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TCancelUser,TMaintLocDR,TMaintRemark,TService,TServiceDR,TOtherFee,TRequestNO,TObjTypeDR,TObjType,TManageTypeDR,TManageType,TServiceDR,TService,TWorkHour,TEstimateWorkHour,TContract,TContractDR,TObjType,TObjTypeDR,TManageType,TManageTypeDR,TService,TServiceDR,TPlace,TRequestUserDR,TRequestTel,TRequestUser,TEmergencyLevelDR,TEmergencyLevel,TSeverityLevelDR,TSeverityLevel,TPriprityLevel,TPrescription,TEquipNo,TFileNo,TTransAssetDate,TMaintType)
	Set ^TempDHCEQ("web.DHCEQMMaintRequest.DHCEQMMaintRequest",+$H,TempID,TPriprityLevel,index)=Data
	;Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMMaintRequest
	Set (TRowID,TUseLocDR,TUseLoc,TExObjDR,TExObj,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TReturnFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TExObj,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TCancelUser,TMaintLocDR,TMaintRemark,TService,TServiceDR,TOtherFee,TRequestNO,TObjTypeDR,TObjType,TManageTypeDR,TManageType,TServiceDR,TService,TWorkHour,TEstimateWorkHour,TContract,TContractDR,TObjType,TObjTypeDR,TManageType,TManageTypeDR,TService,TServiceDR,TPlace,TRequestUserDR,TRequestTel,TRequestUser,TEmergencyLevelDR,TEmergencyLevel,TSeverityLevelDR,TSeverityLevel,TPriprityLevel,TPrescription,TEquipNo,TFileNo,TSatatCatDR, TEquipCatDR, TCanChangeValue,TTransAssetDate,TMaintType)=""
	Quit
}

ClassMethod GetMaintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 描述:审核

// modify by GBX 2015-12-21 GBX0037

// vNextRole：用户指定角色,vNextStep：用户指定步骤

ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, ApproveFlowID As %Library.String = "", ApproveOpinion As %Library.String = "", ActionCode As %Library.String = "", vEvaluatInfo As %Library.String = "")
{
	New EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	New User,Date,RowID,result,MaintDR,vStatus
	//midified by zy 2015-7-1 ZY0132 
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0
	s ApproveOpinion=$g(ApproveOpinion)
	Set $ZT="ERRORAudit"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s vStatus=$Piece($G(^DHCEQMMaintRequest(RowID)),"^",41)
	if vStatus'="1" q -2015   //该记录状态不符合,不能执行操作!
	
	Set User=$Piece(val,"^",2)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set GroupID=$Piece(val,"^",5)
	//Add By DJ 2015-08-28 DJ0159
	;Set EvaluateGroup=$Piece(val,"^",4)
	;Set CheckEvaluateFlag=##Class(web.DHCEQEvaluate).CheckEvaluateFlag("31",RowID,CurRole,EvaluateGroup,"Y",User)	//Modify DJ 2015-09-08 DJ0161
	;i $p(CheckEvaluateFlag,"^",1)="-1016" q CheckEvaluateFlag
	;i $p(CheckEvaluateFlag,"^",1)="-1017" q CheckEvaluateFlag
	
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	If ApproveSet="" Quit -4007
    	//add by zx 2017-06-20 BUG ZX0038 传动作时 根据动作获取角色和步骤
    	i ActionCode'="" d
    	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
    	.s CurRole=$p(RoleInfo,"^",1)
    	.s RoleStep=$p(RoleInfo,"^",2)
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole, ApproveFlowID)
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)

	Set AppInfoStatus="1"			;AppInfoStatus	

	s AuditFlag=0
	
	TSTART
	//评价信息	
	i vEvaluatInfo'=""
	{
		Set SQLCODE=##class(web.DHCEQEvaluate).SaveData($p(vEvaluatInfo,"@",2),$p(vEvaluatInfo,"@",3),"","N")
		If SQLCODE<0
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	If editFieldsInfo'=""
	{
		
		Set SQLCODE=##class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)	//编辑要修改的字段
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""					//执行当前角色要执行的动作
	{	
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		//midified by zy 2015-7-1 ZY0132
		if Actions["UpdateUnusualStatus"
		{
			s UnusualFlag=1
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
	}
	// 最终审核操作
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set SQLCODE= ##Class(web.DHCEQM.DHCEQMMaintRequest).LastAuditAction(RowID,User)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set AppInfoStatus="2"			;AppInfoStatus
		;Modified by jdl 2011-3-9  jdl0073
		Set AuditFlag=1
		//midified by zy 2015-7-1 ZY0132
		s UnusualFlag=1
		s (UnusualStatus,UnusualRemark)=""
	}
	//2015-10-08 ZY0146  表增加一个审批标记:统一/拒绝 
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,ApproveOpinion,"",CurRole,RoleStep,User,"0")  ;HHM
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
 	//midified by zy 2015-7-1 ZY0132 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	s EquipID=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)	//Add By DJ 2014-09-21
		i ObjSourceTypeDR=1  
		{
			s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
			i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
 	
	 		s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^更新设备异常状态信息失败!"
			} 
		}
		
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Maint",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))
	s vLimitUserDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",26)
	s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_LocAudit",0)) //add by zx 2017-01-09 科室最后一步审核 ZX0036
	s LimitLocDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",6)
	s RequestLocDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",7)
	s vLimitLocDR=LimitLocDR
	s MTPInputType=##class(web.DHCEQCommon).GetSysInfo("503006")
	;i MTPInputType="DHC-STM" s vLimitLocDR=LimitLocDR_","_RequestLocDR		//申请科室和使用科室都有权限modified by czf 2020-09-25 CZF0091 //czf 20201018

	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag,GroupID,vLimitActions,vLimitUserDR,vLimitLocActions,vLimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;;;;;;;;;特殊审批流设置:配件确认默认该步骤通过时确认全部配件数量	Mozy	2015-12-7
	/*
	s ContrastID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"SYSID",1,RequestLocDR,""))		//modified by czf 2020-09-25 科室确认配件时提交至被对照科室 CZF0091
	i ContrastID'=""
	{
		s ExID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",ContrastID)),"^",5)
		i ExID=LimitLocDR s LimitLocDR=RequestLocDR
	}
	*/
	s INRequestID=""
	if ((RoleStep=3)&&(ApproveSet=37)) s INRequestID=##class(web.DHCEQM.DHCEQMMaintPart).ConfirmMaintPart(RowID,1,User,LimitLocDR)
	i INRequestID<0
	{
		TROLLBACK
		q SQLCODE
	}
	//保存物资申领单ID至维修表 modified by czf 2020-09-25 CZF0091
	&SQL(Update SQLUSER.DHC_EQMMaintRequest set MR_Hold15=:INRequestID where MR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//维修完成启用设备Add By DJ 2018-03-18
 	s MStartStopFlag=$p(val,"^",5)
 	if +MStartStopFlag>=1
 	{
		s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		If TExObjDR'=""
		{
			i (SourceTypeDR=1)||(SourceTypeDR=2)
			{
				new ChangeInfoDR   ;add by kdf 需求号573050
				s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
				;检测是否已存停用记录
				K PL
				s PL(2)=EQRowID
				s PL(4)=1
				s PL(5)=+$H
				s PL(6)=31
				s PL(7)=RowID
				s PL(8)=2
				s PL(9)=2
				s PL(10)=1
				s PL(14)="维修启用"
				s PL(16)="N"
				s PL(23)=+$H
				s PL(24)=$P($H,",",2)
				s PL(25)=User
				s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",EQRowID,1,31,RowID,0))
				i CIRowID=""
				{
					&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
					i SQLCODE
					{
						TROLLBACK
						q SQLCODE
					}
					//add by kdf 需求号573050 begin********
					s ChangeInfoDR=$G(%ROWID)
					k LI
					s LI(2)=EQRowID  //设备
					s LI(4)=$p($g(^DHCEQEquip(EQRowID)),"^",19)   	//原使用科室
					s LI(5)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//原管理科室
					s LI(6)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//原库房
					s LI(7)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//原值
					s LI(8)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//原净值
					s LI(9)=$p($g(^DHCEQEquip(EQRowID)),"^",19)  	//变动后使用科室
	 				s LI(10)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//变动后管理科室
	 				s LI(11)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//变动后库房
	 				s LI(12)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//变动后原值
	 				s LI(13)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//变动后净值
					s LI(14)="启用"
					s LI(16)=+$H	//变动日期
					s LI(17)=$P($H,",",2)	//变动时间
					s LI(19)="C"	//生命周期类型
					s LI(20)=41		//来源类型
					s LI(21)=ChangeInfoDR	//来源ID
					s LI(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//更新人
					s LI(28)=+$H	//更新日期
					s LI(29)=$P($H,",",2)	//更新时间
					&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
					//add by kdf 需求号573050 end ********
				}
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
				&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=1 where EQ_RowID=:EQRowID)
			}
		}
 	}
	TCOMMIT
 	Quit 0
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE				//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg		//返回错误消息
}

/// 描述:审核最后一步操作
ClassMethod LastAuditAction(RowID, User)
{
	New MaintDR,Date,Time,result,UseLocDR
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set result= ^DHCEQMMaintRequest(RowID)
	Set ExObjDR = $Piece(result,"^",5)
	Set SourceTypeID = $Piece(result,"^",63)
	;i ExObjDR '= "" s UseLocDR = $Piece(^DHCEQMExObj(ExObjDR),"^",3)	//Modify DJ 2014-09-23
	Set PL(2)= ExObjDR 	            	//ExObjDR	
	Set PL(3)=3 						//Type
	set PL(4)=RowID		 				//SourceID
	Set PL(6)=$Piece(result,"^",24) 	//MaintDate
	Set PL(7)=$Piece(result,"^",29) 	//MaintLoc
	Set PL(8)=$Piece(result,"^",26) 	//MaintUser
	Set PL(9)=$Piece(result,"^",28) 	//MaintMode
	Set PL(11)="" 						//NormalFlag
	Set PL(12)=$Piece(result,"^",34)  	//ManageLoc
	Set PL(13)= $Piece(result,"^",6)    //UseLocDR		//Modify DJ 2014-09-23
	Set PL(14)=2
	Set PL(25)=$Piece(result,"^",58)	//MaintFee		//Modify DJ 2014-09-23
	Set PL(10)=..GetTotalFee(RowID,1)+PL(25)   //TotalFee
	Set PL(19)=User
	Set PL(20)=Date
	Set PL(21)=Time
	Set PL(26)=SourceTypeID
	
	Set MaintDR=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintDR(RowID)
	Set MaintItemDR=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintItemDR(RowID)
	Set MaintPartDR=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintPartDR(RowID)
	
	If MaintDR=""
	{
		&sql(Insert Into SQLUser.DHC_EQMMaint Values :PL())
		Set MaintDR=$Get(%ROWID)
		If SQLCODE
		{
			Quit SQLCODE
		}
		i MaintItemDR '="" &sql(Update SQLUser.DHC_EQMMaintItem set MTI_MaintDR=:MaintDR Where MTI_MaintRequestDR=:RowID)
		If SQLCODE
		{
			Quit SQLCODE
		}
		i MaintPartDR'="" &sql(Update SQLUser.DHC_EQMMaintPart set MTP_MaintDR=:MaintDR Where MTP_MaintRequestDR=:RowID)
		If SQLCODE
		{
			Quit SQLCODE
		}
   }
    Else
    	{
		&sql(Update sqluser.DHC_EQMMaint Values :PL() where MT_RowID=:MaintDR)
		If SQLCODE<0
		{
			Quit SQLCODE
		}
        i MaintItemDR '="" &sql(Update SQLUser.DHC_EQMMaintItem set MTI_MaintDR=:MaintDR Where MTI_MaintRequestDR=:RowID)
		If SQLCODE
		{
			Quit SQLCODE
		}
        i MaintPartDR'="" &sql(Update SQLUser.DHC_EQMMaintPart set MTP_MaintDR=:MaintDR Where MTP_MaintRequestDR=:RowID)
		If SQLCODE
		{
			Quit SQLCODE
		}
    }
    Set PLIT(60)=..GetTotalFee(RowID,1)			// MZY0080	1943263		2021-06-03		更新配件费
    Set PLIT(61)=+$Piece(result,"^",58)+..GetTotalFee(RowID,1)		//Modify DJ 2014-09-23
	Set PLIT(40)=$Piece(result,"^",39) //modify by mwz 20180320 需求号549861
	Set PLIT(42)=2			;审核
	//add by GR0004 2014-08-29 begin 添加审核人相关信息到表中
	Set PLIT(52)=User
	Set PLIT(53)=Date
	Set PLIT(54)=Time
	//add by GR0004 2014-08-29 end 
	&sql(Update sqluser.DHC_EQMMaintRequest Values :PLIT() where MR_RowID=:RowID)
	If SQLCODE
	{
		Quit SQLCODE
	}
	
	// 生命周期 
	s MEquipID=""  // Modefied by zc0129 2023-02-11 初始化MEquipID	
	i SourceTypeID=1 d //add by zx 2016-06-15 设备
	.s MEquipID=$p($Get(^DHCEQMExObj(ExObjDR)),"^",5)   // Modefied by zc0129 2023-02-11 给MEquipID赋值
	.Set LI(2) =  $p($Get(^DHCEQMExObj(ExObjDR)),"^",5)
	.Set LI(9)=$Piece($Get(^DHCEQEquip(LI(2))),"^",19)   	//变动后使用科室
	.Set LI(10)=$Piece($Get(^DHCEQEquip(LI(2))),"^",17) 		//变动后管理科室
	.Set LI(11)=$Piece($Get(^DHCEQEquip(LI(2))),"^",67)  	//变动后库房
	.Set LI(12)=$Piece($Get(^DHCEQEquip(LI(2))),"^",27)  	//变动后原值
	.Set LI(13)=$Piece($Get(^DHCEQEquip(LI(2))),"^",28)  	//变动后净值
	If $Piece(result,"^",10)'="" Set LI(14)=$Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",$Piece(result,"^",10))),"^",2)  //变动原因
	Set LI(15)=$Piece(result,"^",11)  	//变动描述
	Set LI(16)=Date						//变动日期
	Set LI(17)=Time						//变动时间
	Set LI(18)=+$Piece(result,"^",58)+..GetTotalFee(RowID,1)  	//总费用	MR_TotalFee	add by zx 测试组需求 791638 费用未在生命周期表生成
	Set LI(19)="P"						//生命周期类型
	Set LI(20)=31						//来源类型
	Set LI(21)=RowID					//来源ID
	Set LI(23)=$Piece(result,"^",40)  	//备注
	Set LI(27)=User						//更新人
	Set LI(28)=Date						//更新日期
	Set LI(29)=Time						//更新时间
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	;Mozy		2020-1-19	恢复共享资源设备状态
	If SQLCODE Quit SQLCODE
	s SQLCODE=##class(web.DHCEQM.DHCEQMMaintRequest).UpdateEQLocation(RowID,ExObjDR)  //add by zc 2022-6-23微信维修完成修改设备存放地点
	If SQLCODE Quit SQLCODE
	s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(31,RowID,0)
	// Modefied by zc0129 2023-02-11 维修质保修需要写入质保信息表里 begin
	If SQLCODE Quit SQLCODE
	if ((MEquipID'="")&&($ISVALIDNUM($p($g(^DHCEQMMaintRequest(RowID)),"^",73))'=0))
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSEquipGuaranteeInfo).SaveMaintGuaranteeInfo(1,RowID,MEquipID)
		
	}
	// Modefied by zc0129 2023-02-11 维修质保修需要写入质保信息表里 end
	Quit SQLCODE
}

/// add by zc 2022-6-23微信维修完成修改设备存放地点
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).UpdateEQLocation(1,1)
ClassMethod UpdateEQLocation(vMaintRequestDR, vExObjDR As %Library.String)
{
	i vExObjDR="" q 0
	s vEquipID=$p($Get(^DHCEQMExObj(vExObjDR)),"^",5)
	s vPlace=$p($g(^DHCEQMMaintRequest(vMaintRequestDR)),"^",22)
	i vPlace="" q 0
	s EQLocationDR=##Class(web.DHCEQCLocation).UpdLocation("^"_vPlace)
	i EQLocationDR<0 q 0
	s SQLCODE=0
	&sql(Update sqluser.DHC_EQEquip set EQ_LocationDR=:EQLocationDR where EQ_RowID=:vEquipID)
	Quit SQLCODE
}

ClassMethod GetOneMaintDR(RowID As %Library.String, Type As %Library.String = "3")
{
	Quit:RowID="" ""
	New MRowID,MRDR,Return
	Set Return=""
	Set MRowID=0
	For  Set MRowID=$Order(^DHCEQMMaint(MRowID))  Quit:MRowID=""  Do
	.q:$Piece($Get(^DHCEQMMaint(MRowID)),"^",2)'=Type
	.Set MRDR= $Piece($Get(^DHCEQMMaint(MRowID)),"^",3)
	.If MRDR=RowID Set Return=MRowID
	Quit Return
}

ClassMethod GetOneMaintItemDR(RowID As %Library.String)
{
	Quit:RowID="" ""
	New MTIRowID,MRDR,Return
	Set Return=""
	Set MTIRowID=0
	For  Set MTIRowID=$Order(^DHCEQMMaintItem(MTIRowID))  Quit:MTIRowID=""  Do
	.Set MRDR= $Piece($Get(^DHCEQMMaintItem(MTIRowID)),"^",7)
	.If MRDR=RowID Set Return=MTIRowID
	Quit Return
}

ClassMethod GetOneMaintPartDR(RowID As %Library.String)
{
	Quit:RowID="" ""
	New MTPRowID,MRDR,Return
	Set Return=""
	Set MTPRowID=0
	For  Set MTPRowID=$Order(^DHCEQMMaintPart(MTPRowID))  Quit:MTPRowID=""  Do
	.Set MRDR= $Piece($Get(^DHCEQMMaintPart(MTPRowID)),"^",9)
	.If MRDR=RowID Set Return=MTPRowID
	Quit Return
}

ClassMethod GetTotalFee(RowID, Type)
{
	Set (OtherFee,PartFee,ItemFee)=0
	If RowID'=""
	{
		Set OtherFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQMMaintRequest(RowID)),"^",59),"")		//Modify DJ 2014-09-25	begin
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMMaintPart where MTP_MaintRequestDR=:RowID)
		&sql(select sum(MTI_MaintFee) into :ItemFee from sqluser.DHC_EQMMaintItem where MTI_MaintRequestDR=:RowID)
	}
	/*
	If OtherFee="" Set OtherFee=0
	Set MaintDR=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintDR(RowID)
	If MaintDR=""
	{
		Set PartFee=0
		Set ItemFee=0
	}
	Else
	{
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMMaintPart where MTP_MaintDR=:MaintDR)
		&sql(select sum(MTI_MaintFee) into :ItemFee from sqluser.DHC_EQMMaintItem where MTI_MaintDR=:MaintDR)
	}
	IF PartFee="" Set PartFee=0
	IF ItemFee="" Set ItemFee=0
	*/
		//Modify DJ 2014-09-25 end
	IF Type=2 Quit ##Class(web.DHCEQCommon).FormatNumber(OtherFee+PartFee+ItemFee,"")        //modify by wl 2019-11-25 WL0015
	IF Type=1 Quit ##Class(web.DHCEQCommon).FormatNumber(PartFee+ItemFee,"")				 //modify by wl 2019-11-25 WL0015
}

ClassMethod StatusList(name, width, WaitAD) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (WaitAD="off") w "<option value=0>"_..GetStatus(0)_"</option>"
	w "<option value=1>"_..GetStatus(1)_"</option>"
	w "<option value=2>"_..GetStatus(2)_"</option>"
	w "</select>",!
}

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,0:"新增",1:"提交",2:"审核",4:"异常结束",:"未定义")  // Modefied by zc 2022-4-8
}

ClassMethod DeleteMaintRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String)
{
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	&sql(Update sqluser.DHC_EQMMaintRequest Set MR_InvalidFlag='Y',MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
 	s EquipID=""
	s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)	//Add By DJ 2014-09-21
	i ObjSourceTypeDR=1  //add by zx 2016-06-15
	{
		s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)

 		s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipID,"","")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^更新设备异常状态信息失败!"
		}	
	}
	 
	TCOMMIT
	Quit 0
ERRORDelete
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

ClassMethod SetContrat(ExObjDR)
{
	//add by zy 2015-12-01
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginData=##class(web.DHCEQCommon).GetSysInfo("990039")
	i ExObjDR="" q "0^^"
	s Flag="0"
	s SignDate=0
	s MaxDate=0
	s StartDate=""
	s EndDate=""
	s rowid=0
	s MaxContractDR=0
	s ExType = $p($g(^DHCEQMExObj(ExObjDR)),"^",4)		//Add By DJ 2015-07-14 DJ0147
	i ExType=1 d
	.s EquipDR=$p(^DHCEQMExObj(ExObjDR),"^",5)
	.s StartDate=$P($g(^DHCEQEquip(EquipDR)),"^",12)
	.//add by zy 2015-12-01
	.i BeginData=1 s StartDate=$P($g(^DHCEQEquip(EquipDR)),"^",45)
	.;i StartDate'="" s StartDate=$ZD(StartDate,4)
	.;日期格式统一调整
	.s StartDate=##Class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	.s MonthNum=$P(^DHCEQEquip(EquipDR),"^",73)
	.s EndDate=##class(web.DHCEQCommon).DateAdd("M",MonthNum,StartDate)
	.f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	..s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	..s SignDate=$P(^DHCEQContract(ContractDR),"^",7)
	..s Flag="1"
	..s StartDate=""
	..s EndDate=""
	..i SignDate>MaxDate d
	...s MaxContractDR=ContractDR
	...s MaxDate=SignDate
	
	i MaxContractDR>0 s StartDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",11),"date")
	i MaxContractDR>0 s EndDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",12),"date")
	q Flag_"^"_StartDate_"^"_EndDate
}

ClassMethod GetValue(User, Date, Time, MMaintRequestDR)
{
	s val=""
	s val=val_$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",5)_"^" //EquipDR 1
	s val=val_MMaintRequestDR_"^" //MMaintRequestDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",58)_"^" //UseFee 4
	s val=val_$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",24)_"^" //FeeDate 5
	s val=val_$Piece($Get(^DHCEQMExObj($g(^DHCEQMMaintRequest(MMaintRequestDR)),"^",5)),"^",3)_"^" //UseLocDR 6
	s val=val_$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",34)_"^" //ManageLocDR 7
	s val=val_##class(web.DHCEQM.DHCEQMMaint).GetFeeType(3)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"维修记录产生费用" //Remark 12	
	s Return=##class(web.DHCEQM.DHCEQMMaintRequest).InsertLifeFee(27,val)
	q Return
}

ClassMethod InsertLifeFeeOld(i, val)
{
	//i=3保养，i=4检查,27=维修，由于表结构改变i现在无用了
	k PUP
	s PUP(2)=$P(val,"^",1) //EquipDR
	s PUP(3)=$P(val,"^",2) //MaintDR,InsepectDR
	s PUP(4)="" //$P(val,"^",3) //CostallotDR
	s PUP(5)=$P(val,"^",4) //UseFee
	i (PUP(5)=0||PUP(5)="") q 0 //如果费用为0，退出
	s PUP(6)=$P(val,"^",5) //FeeDate
	s PUP(7)=$P(val,"^",6) //UseLocDR
	s PUP(8)=$P(val,"^",7) //ManageLocDR
	s PUP(9)=$P(val,"^",8) //FeeTypeDR	ss
	s PUP(13)="N" //InputFlag
	s PUP(15)=$P(val,"^",9) //AddUser
	s PUP(16)=$P(val,"^",10) //AddDate
	s PUP(17)=$P(val,"^",11) //AddTime
	s PUP(14)=$P(val,"^",12) //Remark
	s PUP(18)=PUP(15) //UpdateUser
	s PUP(19)=PUP(16) //UpdateDate
	s PUP(20)=PUP(17) //UpdateTime
	s PUP(21)=PUP(15) //AduitUser
	s PUP(22)=PUP(16) //AduitDate
	s PUP(23)=PUP(17) //AduitTime
	&sql(insert into sqluser.DHC_EQLifeFee values :PUP())
	q SQLCODE
}

ClassMethod GetMaintFee(itmjs As %Library.String = "", itmjsex As %Library.String = "", ArgList, ArgDR)
{
	if ArgList="1"
	{
		s MaintModeDR=##class(web.DHCEQM.DHCEQMMaintPlan).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQM.DHCEQMMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMMaintPlan(ArgDR)),"^",13)
		q FeeType_"^"_MaintFee
	}
	if ArgList="2"
	{
		//Maint ArgDR=MaintDR
		s MaintModeDR=##class(web.DHCEQM.DHCEQMMaint).GetMaintMode(ArgDR)
		s FeeType=##class(web.DHCEQM.DHCEQMMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMMaint(ArgDR)),"^",24)
		q FeeType_"^"_MaintFee
	}
	if ArgList="3"
	{
		//MMaintRequest ArgDR=MaintDR
		;s MMaintRequestDR=..GetMaintRequestDRByMtDR(ArgDR)^DHCEQMaint(rowid)
		s MMaintRequestDR=$Piece($Get(^DHCEQMMaint(ArgDR)),"^",2)
		s MaintModeDR=$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",28)
		s FeeType=##class(web.DHCEQM.DHCEQMMaintPlan).GetFeeType("","",MaintModeDR)
		s MaintFee=$Piece($Get(^DHCEQMMaintRequest(MMaintRequestDR)),"^",58)
		q FeeType_"^"_MaintFee
	}
}

Query GetService(Service) As %SQLQuery(ROWSPEC = "Code:%String,Hidden:%String,Name:%String")
{
	 SELECT SV_Code,
	        SV_RowID,
	        SV_Name
	 FROM sqluser.DHC_EQCService
     where SV_InvalidFlag = 'N' and SV_Name like nvl(:Service,'')||'%'
}

Query GetExObj(ExObj) As %SQLQuery(ROWSPEC = "No:%String,Hidden:%String,Name:%String,LocDR:%String")
{
	 SELECT EO_No,
	        EO_RowID,
	        EO_Name,
	        EO_LocDR
	 FROM sqluser.DHC_EQMExObj
     where EO_InvalidFlag = 'N' and EO_Name like nvl(:ExObj,'')||'%'
}

Query GetEmergencyLevel(EmergencyLevel) As %SQLQuery(ROWSPEC = "Desc:%String,RowID:%String,Code:%String")
{
	 SELECT EL_Desc,
	        EL_RowID,
	        EL_Code
	 FROM sqluser.DHC_EQMCEmergencyLevel
     where EL_InvalidFlag = 'N' and EL_Desc like nvl(:EmergencyLevel,'')||'%'
}

Query GetSeverityLevel(SeverityLevel) As %SQLQuery(ROWSPEC = "Desc:%String,RowID:%String,Code:%String")
{
	 SELECT SL_Desc,
	        SL_RowID,
	        SL_Code
	 FROM sqluser.DHC_EQMCSeverityLevel
     where SL_InvalidFlag = 'N' and SL_Desc like nvl(:SeverityLevel,'')||'%'
}

Query GetAccessory(Accessory) As %SQLQuery(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Price:%String,Model:%String")
{
	 SELECT A_Desc,
	        A_Code,
	        A_RowID,
	        A_StdSPrice,
	        A_Model
	 FROM sqluser.DHC_EQCAccessory
     where A_InvalidFlag = 'N' and A_Desc like nvl(:Accessory,'')||'%'
}

// Modify by zc 2014-08-19 zc0002

// 选择返修后不能出现未审核的单据

Query GetRequest(Request) As %SQLQuery(ROWSPEC = "RequestNo:%String,Hidden:%String")
{
	 SELECT MR_RequestNo,
	        MR_RowID
	 FROM sqluser.DHC_EQMMaintRequest
     where  MR_InvalidFlag = 'N' and MR_Status=2 and MR_RequestNo like nvl(:Request,'')||'%'
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetContract","")
Query GetContract(Contract) As %SQLQuery(ROWSPEC = "ContractNo:%String,ContractName:%String,HIDDEN:%String")
{
	 SELECT CT_ContractNo,
	        CT_ContractName,
	        CT_RowID
	 FROM sqluser.DHC_EQContract
     where CT_ContractName like nvl(:Contract,'')||'%'
}

ClassMethod ExObjList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;w "<option value=0></option>"
	;w "<option value=1>设施</option>"
	;w "<option value=2>房屋</option>"
	w "<option value=1>设备</option>"
	w "<option value=2>未在帐</option>"
	;w "<option value=9>其他</option>"
	w "</select>",!
}

Query GetMaintMode(MaintMode) As %SQLQuery(ROWSPEC = "Desc:%String,RowID:%String,Code:%String")
{
	 SELECT MM_Desc,
	        MM_RowID,
	        MM_Code
	 FROM sqluser.DHC_EQMCMaintMode
     where MM_InvalidFlag = 'N' and MM_Desc like nvl(:MaintMode,'')||'%'
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetEvaluate","")
/// modify BY GBX 2015-03-17 15:43:03 DHC_EQMCEvaluateType->DHC_EQCEvaluateType
Query GetEvaluate(EvaluateType) As %SQLQuery(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String")
{
	 SELECT ET_Desc,
	        ET_RowID,
	        ET_Code
	 FROM sqluser.DHC_EQCEvaluateType
     where ET_InvalidFlag = 'N' and ET_Desc like nvl(:EvaluateType,'')||'%'
}

Query FaultType(FaultType) As %SQLQuery(ROWSPEC = "Desc:%String,RowID:%String,Code:%String")
{
SELECT FT_Desc,
	   FT_RowID,
	   FT_Code
FROM sqluser.DHC_EQMCFaultType
where FT_InvalidFlag = 'N' and FT_Desc like nvl(:FaultType,'')||'%'
}

Query MaintItem(MaintItem) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
	 SELECT MI_Desc,
	        MI_RowID,
	        MI_Code
	 FROM sqluser.DHC_EQMCMaintItem
     where MI_Type=3 and MI_InvalidFlag = 'N' and MI_Desc like nvl(:MaintItem,'')||'%'
}

// Modify by zc 2014-08-26 zc0003 添加TTotalFee

/// add by zx 2014-03-24
/// 维修明细查询及科室维修明细查询 通过QXType的值来进行区别 2表示查看登陆科室
/// modified By qw 20170309 新增参数CurLocID Android需要传入当前科室
/// modified By qw 20170929 需求号:458993 新增参数CurGroupID Android需要传入当前安全组
/// modified by csj 2020-05-28 参数超长处理并添加维修完成日期查询
/// modified by sjh 2020-09-29 参数超长处理,状态传值问题
/// modified by zyq 2022-12-09 添加 ObjLocDR 使用科室
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetMaintRequestDetail","","",66122,66273,"0","","N","","5313","","0","","","151","^CurGroupID=347^^^^^FinishStartDate=^FinishEndDate=")
/// MZY0152	3203616		2023-02-06	增加输出列:TBussType,TBussID,TNo,TName,TDate,TLastOperate
Query GetMaintRequestDetail(ExObjDR, RequestLocDR, StartDate, EndDate, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", AcceptUserDR As %String = "", CurUser As %String = "", ExObj As %String = "", FinishFlag As %String = "", LeaderFlag As %String = "", UserLocDR As %String = "", CurLocID As %String = "", ObjLocDR As %String = "", vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TExObjDR:%String,TExObj:%String,TUseLoc:%String,TRequestLocDR:%String,TFaultCaseDR:%String,TFaultCaseRemark:%String,TFaultReasonDR:%String,TFaultReasonRemark:%String,TDealMethodDR:%String,TDealMethodRemark:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TRequestDate:%String,TRequestTime:%String,TFaultTypeDR:%String,TAcceptDate:%String,TAcceptTime:%String,TAcceptUserDR:%String,TAssignDR:%String,TMaintModeDR:%String,TReturnFlag:%String,TMaintFee:%String,TUserSignDR:%String,TUserOpinion:%String,TManageLocDR:%String,TUseLocDR:%String,TIsInputFlag:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TCancelUserDR:%String,TCancelDate:%String,TCancelTime:%String,TExObj:%String,TRequestLoc:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TFaultType:%String,TAcceptUser:%String,TAssign:%String,TMaintMode:%String,TUserSign:%String,TManageLoc:%String,TUseLoc:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TCancelUser:%String,TMaintLocDR:%String,TMaintRemark:%String,TService:%String,TServiceDR:%String,TOtherFee:%String,TRequestNO:%String,TObjTypeDR:%String,TObjType:%String,TManageTypeDR:%String,TManageType:%String,TServiceDR:%String,TService:%String,TWorkHour:%String,TEstimateWorkHour:%String,TContract:%String,TContractDR:%String,TObjType:%String,TObjTypeDR:%String,TManageType:%String,TManageTypeDR:%String,TService:%String,TServiceDR:%String,TPlace:%String,TRequestUserDR:%String,TRequestTel:%String,TRequestUser:%String,TEmergencyLevelDR:%String,TEmergencyLevel:%String,TSeverityLevelDR:%String,TSeverityLevel:%String,TTotalFee:%String,TRow:%String,TEQNo:%String,TFileNo:%String,TApproveInfo:%String,TApproveDate:%String,TWaringFlag:%String,TCurRole:%String,TEvaluateGroup:%String,TJob:%String,TMaintType:%String,TEquipType:%String,TBussType:%String,TBussID:%String,TNo:%String,TName:%String,TDate:%String,TLastOperate:%String")
{
}

ClassMethod GetMaintRequestDetailExecute(ByRef qHandle As %Binary, ExObjDR, RequestLocDR, StartDate, EndDate, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", AcceptUserDR As %String = "", CurUser As %String = "", ExObj As %String = "", FinishFlag As %String = "", LeaderFlag As %String = "", UserLocDR As %String = "", CurLocID As %String = "", ObjLocDR As %String = "", vData As %String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	//start by csj 2020-05-28
	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	//Set CurGroupID=##class(web.DHCEQCommon).GetDataByName(vData,"CurGroupID")	//modified by wy 2022-5-5 WY0099 
 	Set FinishStartDate=##class(web.DHCEQCommon).GetDataByName(vData,"FinishStartDate")	
 	Set FinishEndDate=##class(web.DHCEQCommon).GetDataByName(vData,"FinishEndDate")
 	Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")	
 	i FinishStartDate'="" s FinishStartDate=##Class(web.DHCEQCommon).TransValueFromPage(FinishStartDate,"date")
 	e  s FinishStartDate=0
	i FinishEndDate'="" s FinishEndDate=##Class(web.DHCEQCommon).TransValueFromPage(FinishEndDate,"date")
	e  s FinishEndDate=+$h
	//Add By QW2021518 BUG:QW0111 Begin
	Set ActionItemString=##class(web.DHCEQCommon).GetDataByName(vData,"ActionItemString") 
	Set ApproveSDate=##class(web.DHCEQCommon).GetDataByName(vData,"ApproveSDate")
	i ApproveSDate'="" s ApproveSDate=##Class(web.DHCEQCommon).TransValueFromPage(ApproveSDate,"date")
	Set ApproveEDate=##class(web.DHCEQCommon).GetDataByName(vData,"ApproveEDate")
	i ApproveEDate'="" s ApproveEDate=##Class(web.DHCEQCommon).TransValueFromPage(ApproveEDate,"date")
	Set FeeType=##class(web.DHCEQCommon).GetDataByName(vData,"FeeType")   /// Modefied by zc0125 2022-11-18 增加费用类型查询条件
	Set RequestUserDR=##class(web.DHCEQCommon).GetDataByName(vData,"RequestUserDR")   /// Modefied by zc0125 2022-11-18 增加报修人查询条件
	//Add By QW2021518 BUG:QW0111 End
	//end by csj 2020-05-28
	//Set Status=##class(web.DHCEQCommon).GetDataByName(vData,"Status") //modified by wy 2022-5-5 WY0099 
	i CurLocID'="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	//modified by wy 2022-5-5 WY0099 维修明细查询参数取值
	s vCurGroupID=##class(web.DHCEQCommon).GetDataByName(vData,"vCurGroupID")
	s vCurRole=##class(web.DHCEQCommon).GetDataByName(vData,"vCurRole")
	s vEvaluateGroup=##class(web.DHCEQCommon).GetDataByName(vData,"vEvaluateGroup")
	s Status=##class(web.DHCEQCommon).GetDataByName(vData,"vStatus") //Modify by wy 2022-6-13 调用query参数调整 begin
	s WaitAD=##class(web.DHCEQCommon).GetDataByName(vData,"WaitAD")
	//i vStatus'="" s Status=vStatus  //Modify by wy 2022-6-13 调用query参数调整 end
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	// MZY0152	3203616		2023-02-06
	Set PreviousMonthFlag=##class(web.DHCEQCommon).GetDataByName(vData,"PreviousMonthFlag")
	i PreviousMonthFlag=1
	{
		s UserLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s tmpCurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
		s tmpPreYearMonth=##Class(web.DHCEQReport).GetPreMonth(tmpCurMonth)
		s FinishStartDate=$p(##Class(web.DHCEQReport).GetReportDate(tmpPreYearMonth,"",""),"^",1)
		s FinishEndDate=$p(##Class(web.DHCEQReport).GetReportDate(tmpPreYearMonth,"",""),"^",2)
	}
	s TRow=0  //add by zx 2015-09-15 BugZX0032
	s TJob=$j		//add by CZF0074 2020-02-24
	k ^TempDHCEQ("DHCEQMMaintRequestDetail")
	/*if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQMMaintRequest(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQMMaintRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	
	..For  Set rowid=$Order(^DHCEQMMaintRequest(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetMMaintRequestDetail
	e  d
	*/
	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintRequest(rowid))  Quit:rowid=""  Do
	.s tmpid=$p($g(^DHCEQMMaintRequest(rowid)),"^",5)
	.q:tmpid=""
	.s EOName=$p($g(^DHCEQMExObj(tmpid)),"^",1)
	.q:(ExObj'="")&&(EOName'[ExObj)
	.s ExObjDR=tmpid
	.d BuildDataGetMMaintRequestDetail
	Quit $$$OK
	
BuildDataGetMMaintRequestDetail		
    Do ResetVariablesGetMMaintRequestDetail
	Set TRowID = rowid
	//Add ByQW2021518 BUG:QW0111 begin
	s ActionInfo=##Class(web.DHCEQCommon).ActionFilter(rowid,"31","0")
	q:(+ActionItemString'=0)&&((","_$p(ActionInfo,",",1)_",")'[(","_ActionItemString_","))
	q:(ApproveSDate'="")&&(ApproveSDate>$p(ActionInfo,",",2))    //modified By myl 20210913 需求号:1979401
	q:(ApproveEDate'="")&&(ApproveEDate<$p(ActionInfo,",",2)) 
	//Add By QW2021518 BUG:QW0111 end
	//begin modify by jyp 20170505
	s TEquipTypeDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",3)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,vCurGroupID,"","2") //modified By qw 20170929 需求号:458993		//Modify DJ 2019-06-06
	q:+result'=0
	set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	//end modify by jyp 20170505
	s MRFlag=$p($g(^DHCEQMMaintRequest(rowid)),"^",57)
	i MRFlag="" s MRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=MRFlag)
	;Add By QW20160229 筛选个人单据
	i CurUser'=""  d
	.s CurUserID="^"_CurUser_"^"
	.s useid="^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",20)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",26)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",42)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",45)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",48)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",51)_"^"_$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",54)_"^" ;Add By QW20160229 筛选个人单据
	q:(CurUser'="")&&(useid'[CurUserID)
	;End By QW20160229 筛选个人单据	
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",63) //add by zx 2016-06-15 begin
	Set TExObjDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",5)
	Quit:(ExObjDR'="")&&(TExObjDR'=ExObjDR)  //add by zx 2017-03-20 BUG ZX0036
	If TExObjDR '="" Set TExObj = $Piece($Get(^DHCEQMExObj(TExObjDR)),"^",1) 
	Set TUseLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",6)
	Quit:(UserLocDR'="")&&(TUseLocDR'=UserLocDR) //add by zx 2016-12-08 本科室人员权限 ZX0036
	if TUseLocDR '="" set TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	Quit:(ObjLocDR'="")&&(TUseLocDR'=ObjLocDR) //add by zyq 2022-12-09
	Set TRequestLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",7)
	Quit:(RequestLocDR'="")&&(TRequestLocDR'=RequestLocDR)
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR,CurLocID)))&&((1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TUseLocDR,CurLocID)))) ;modified By qw 20170309 新增参数CurLocID Android需要传入当前科室 modified by csj 2020-09-27 增加使用科室判断 1540892
	If TRequestLocDR '=""  Do
	.Set TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	Set TFaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",10)
	If TFaultCaseDR '=""  Do
	.Set TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",TFaultCaseDR)),"^",2)
	Set TFaultCaseRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",11)
	Set TFaultReasonDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",12)
	If TFaultReasonDR '=""  Do
	.Set TFaultReason = $Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",TFaultReasonDR)),"^",2)
	Set TFaultReasonRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",13)
	Set TDealMethodDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",14)
	If TDealMethodDR '=""  Do
	.Set TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",TDealMethodDR)),"^",2)
	Set TDealMethodRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",15)
	Set TStartDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",8),"date")
	Set TStartTime =##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",9),"time") ; $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",9) //modified by sjh SJH0045 2021-02-20
	Set TEndDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16),"date")
	Set TEndTime =##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",17),"time") ;$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",17) //modified by sjh SJH0045 2021-02-20
	Quit:($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16)<FinishStartDate)!($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16)>FinishEndDate) //modified by csj 2020-06-08 完成日期过滤
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	Quit:($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18)<StartDate)!($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18)>EndDate)
	Set TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",18),"date")
	Set TRequestTime =##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",19),"time") ; $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",19) //modified by sjh SJH0045 2021-02-20
	Set TFaultTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",23)
	If TFaultTypeDR '=""  Do
	.Set TFaultType = $Piece($Get(^DHCEQCCode("DHCEQMCFaultType",TFaultTypeDR)),"^",2)
	Set TAcceptDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",24),"date")
	Set TAcceptTime =##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",25),"time") ; $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",25) //modified by sjh SJH0045 2021-02-20
	Set TAcceptUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",26)
	Quit:(AcceptUserDR'="")&&(TAcceptUserDR'=AcceptUserDR)
	Set TMaintGroupDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",70)
	Quit:(LeaderFlag'="")&&(##class(web.DHCEQM.DHCEQMMaintRequest).CheckMaintGroup(LeaderFlag)'=TMaintGroupDR) //add by zx 2016-12-08 判断是否为组内单据 ZX0036 
	If TAcceptUserDR '=""  Do
	.Set TAcceptUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAcceptUserDR) //add by zx 2018-08-13  $Piece($Get(^SSU("SSUSR",TAcceptUserDR)),"^",2)
	Set TAssignDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",27)
	If TAssignDR '=""  Do
	.Set TAssign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAssignDR)
	Set TMaintModeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",28)
	If TMaintModeDR '=""  Do
	.Set TMaintMode = $Piece($Get(^DHCEQCCode("DHCEQMCMaintMode",TMaintModeDR)),"^",2)
	Set TMaintFee = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",58)
	Set TUserSignDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",32)
	If TUserSignDR '=""  Do
	.Set TUserSign = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserSignDR)
	Set TUserOpinion = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",33)
	Set TManageLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",34)
	If TManageLocDR '=""  Do
	.Set TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	Set TReturnFlag = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",35)
	If (TReturnFlag = "Y")  DO
	.set TMaintRequestDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",36)
	.If TMaintRequestDR '=""  DO
	..set TMaintRequest = $Piece($Get(^DHCEQMMaintRequest(TMaintRequestDR)),"^",1)
	Set TRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",40)
	Set TStatus = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)
	Quit:(Status'="")&&(TStatus'=Status)
	Quit:TStatus=3     //add by jyp 2020-03-12 JYP0023
	Quit:(WaitAD'="off")&&(TStatus=0)		//Add By DJ 2019-09-09
	Quit:((FinishFlag="0")&&(TStatus="2"))||((FinishFlag="1")&&(TStatus'="2")) //2016-12-07 add by zx FinishFlag: 0,未完成 1, 完成 2,全部  是否完成标志查找 ZX0036
	set TWorkHour = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",39)
	i ((TStatus=2)&&(TWorkHour="")) s TWorkHour=##Class(web.DHCEQM.DHCEQMMaintStatisticsAnaly).GetComputerHour(rowid)	//$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16)-$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",24)
	Set TAddUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",42)
	If TAddUserDR '=""  Do
	.Set TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	Set TAddDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",43),"date")
	Set TAddTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",44)
	Set TUpdateUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",45)
	If TUpdateUserDR '=""  Do
	.Set TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	Set TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",46),"date")
	Set TUpdateTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",47)
	Set TSubmitUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",48)
	If TSubmitUserDR '=""  Do
	.Set TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	Set TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",49),"date")
	Set TSubmitTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",50)
	Set TAuditUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",51)
	If TAuditUserDR '=""  Do
	.Set TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	Set TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",52),"date")
	Set TAuditTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",53)
	Set TCancelUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",54)
	If TCancelUserDR '=""  Do
	.Set TCancelUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUserDR)
	Set TCancelDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",55),"date")
	Set TCancelTime = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",56)
	Set TMaintLocDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",29)
	If TMaintLocDR '=""  DO
	.s TMaintLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	Set TMaintRemark = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",37)
	Set TOtherFee = ##class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQM.DHCEQMMaintRequest).GetTotalFee(rowid,1),"")	//$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",59)
	Set TRequestNO = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",1)
	Quit:(RequestNo'="")&&(TRequestNO'[RequestNo)
	set TServiceDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",31)
	If TServiceDR '=""  DO
	.set TService = ##class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR) //CZF0093
	set TManageTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",2)
	If TManageTypeDR '=""  DO
	.s TManageType = $Piece($Get(^DHCEQCCode("DHCEQMCManageType",TManageTypeDR)),"^",2)
	set TObjTypeDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",4)
	If TObjTypeDR '=""  DO
	.s TObjType = $Piece($Get(^DHCEQCCode("DHCEQMCObjType",TObjTypeDR)),"^",2)
	set TContractDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",30)
	If TContractDR '=""  DO
	.set TContract = $Piece($Get(^DHCEQContract(TContractDR)),"^",2)
	set TEstimateWorkHour = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",38)
	set TRequestUserDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",20)
	q:(RequestUserDR'="")&&(TRequestUserDR'=RequestUserDR)     /// Modefied by zc0125 2022-11-18 增加报修人查询条件
	If TRequestUserDR '= ""  Do
	.set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	set TRequestTel = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",21)
	set TPlace = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",22)
	Set TMRSaveCostFee = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",71)   //add by zc0123 2022-10-17 添加维修总报价
	set TEmergencyLevelDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",61)
	If TEmergencyLevelDR '= ""  Do
	.set TEmergencyLevel = $Piece($Get(^DHCEQCCode("DHCEQMCEmergencyLevel",TEmergencyLevelDR)),"^",2)
	set TSeverityLevelDR = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",62)
	If TSeverityLevelDR '= ""  Do
	.set TSeverityLevel = $Piece($Get(^DHCEQCCode("DHCEQMCSeverityLevel",TSeverityLevelDR)),"^",2)
	set TTotalFee=TMaintFee+TOtherFee	//$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",60)	//Modify by zc 2014-08-26 zc0003
	/// Modefied by zc0125 2022-11-18 增加费用类型查询条件 begin
	q:(FeeType'="")&&(FeeType=1)&&(+TTotalFee=0)
	q:(FeeType'="")&&(FeeType=2)&&(+TTotalFee'=0)
	/// Modefied by zc0125 2022-11-18 增加费用类型查询条件 end
	s TMaintType=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",76)		//add by CZF0075 2020-02-25
	;Mozy	2016-11-23
	i (SourceTypeDR=1)||(SourceTypeDR=2) d //add by zx 2017-03-20 BUG ZX0036
	.s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
	.s TEQNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",71)
	.s TFileNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",85)
	
	s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion("25",rowid) //add by zx 2016-12-04 获取当前最后操作人 ZX0036
	s TApproveInfo=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)
	s TApproveDate=$p(LastOperate,"^",4)
	
	s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo("25",rowid) //add by zx 2016-12-28 获取预警状态 ZX0036
	//新增状态不显示审批信息
	i TStatus=0  d
	.s (TFaultReason,TFaultType,TAcceptDate,TAcceptUser,TEndDate,TDealMethod,TMaintMode,TEmergencyLevel,TSeverityLevel,TEstimateWorkHour,TWorkHour,TSubmitDate,TFaultReasonRemark,TDealMethodRemark)=""
	Set TStatus=##class(web.DHCEQM.DHCEQMMaintRequest).GetStatus(TStatus)
	
	s TRow=TRow+1
	s TCurRole=vCurRole
	s TEvaluateGroup=vEvaluateGroup
	Do OutputRowGetMMaintRequestDetail
	Quit
OutputRowGetMMaintRequestDetail
	s TBussTypeDR=31
	s TDetailDesc="详细"
	Set Data=$lb(TRowID,TExObjDR,TExObj,TUseLoc,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TReturnFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TExObj,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TCancelUser,TMaintLocDR,TMaintRemark,TService,TServiceDR,TOtherFee,TRequestNO,TObjTypeDR,TObjType,TManageTypeDR,TManageType,TServiceDR,TService,TWorkHour,TEstimateWorkHour,TContract,TContractDR,TObjType,TObjTypeDR,TManageType,TManageTypeDR,TService,TServiceDR,TPlace,TRequestUserDR,TRequestTel,TRequestUser,TEmergencyLevelDR,TEmergencyLevel,TSeverityLevelDR,TSeverityLevel,TTotalFee,TRow,TEQNo,TFileNo,TApproveInfo,TApproveDate,TWaringFlag,TCurRole,TEvaluateGroup,TJob,TMaintType,TEquipType,TBussTypeDR,TRowID,TRequestNO,TExObj,TRequestDate,TDetailDesc)	// MZY0152	3203616		2023-02-06
	Set ^CacheTemp(repid,index)=Data
	Set ^TempDHCEQ("DHCEQMMaintRequestDetail",+$h,TJob,index)=TRow_"^"_TExObj_"^"_TUseLoc_"^"_TFaultCaseRemark_"^"_TFaultReasonRemark_"^"_TDealMethodRemark_"^"_TStartDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TRequestDate_"^"_TRequestTime_"^"_TAcceptDate_"^"_TAcceptTime_"^"_TMaintFee_"^"_TUserOpinion_"^"_TRemark_"^"_TRequestLoc_"^"_TFaultCase_"^"_TFaultReason_"^"_TDealMethod_"^"_TFaultType_"^"_TAcceptUser_"^"_TAssign_"^"_TMaintMode_"^"_TUserSign_"^"_TManageLoc_"^"_TService_"^"_TOtherFee_"^"_TRequestNO_"^"_TManageType_"^"_TWorkHour_"^"_TEstimateWorkHour_"^"_TContract_"^"_TRequestTel_"^"_TRequestUser_"^"_TTotalFee_"^"_TEQNo_"^"_TFileNo_"^"_TAddUser_"^"_TMRSaveCostFee   //add by zc0123 2022-10-17 添加TAddUser和TMRSaveCostFee导出
	Set index=index+1
	Quit
ResetVariablesGetMMaintRequestDetail
	Set (TRowID,TUseLocDR,TUseLoc,TExObjDR,TExObj,TRequestLocDR,TFaultCaseDR,TFaultCaseRemark,TFaultReasonDR,TFaultReasonRemark,TDealMethodDR,TDealMethodRemark,TStartDate,TStartTime,TEndDate,TEndTime,TRequestDate,TRequestTime,TFaultTypeDR,TAcceptDate,TAcceptTime,TAcceptUserDR,TAssignDR,TMaintModeDR,TReturnFlag,TMaintFee,TUserSignDR,TUserOpinion,TManageLocDR,TUseLocDR,TIsInputFlag,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TExObj,TRequestLoc,TFaultCase,TFaultReason,TDealMethod,TFaultType,TAcceptUser,TAssign,TMaintMode,TUserSign,TManageLoc,TUseLoc,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TCancelUser,TMaintLocDR,TMaintRemark,TService,TServiceDR,TOtherFee,TRequestNO,TObjTypeDR,TObjType,TManageTypeDR,TManageType,TServiceDR,TService,TWorkHour,TEstimateWorkHour,TContract,TContractDR,TObjType,TObjTypeDR,TManageType,TManageTypeDR,TService,TServiceDR,TPlace,TRequestUserDR,TRequestTel,TRequestUser,TEmergencyLevelDR,TEmergencyLevel,TSeverityLevelDR,TSeverityLevel,TTotalFee,TEQNo,TFileNo,LastOperate,TApproveInfo,TApproveDate,TWaringFlag,TCurRole,TEvaluateGroup,TMaintType,TEquipType,TMRSaveCostFee)=""	//Modify by zc0123	2022-10-17 初始化TMRSaveCostFee
	Quit
}

ClassMethod GetMaintRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/****************************************************/
/// Add By DJ 2014-09-25
/// 描述:保存维修评价信息
/// Modify BY:GBX 2015-03-17 15:30:15  修改了表结构
/// DHC_EQMEvaluate->DHC_EQEvaluate ^DHCEQMEvaluate->^DHCEQEvaluate
ClassMethod SaveEvaluation(vSourceType, vSourceID, vCurRole, vEvaluationInfo)
{
	s Count=$l(vEvaluationInfo,"^")
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	s SQLCODE=0
	K EPLIST
	f i=1:1:Count
	{
		q:SQLCODE'=0
		s CurEvaluation=$p(vEvaluationInfo,"^",i)
		s ETypeDR=$p(CurEvaluation,"=",1)
		s EScore=$p(CurEvaluation,"=",2)
		s EPLIST(2)=vSourceType
		s EPLIST(3)=vSourceID
		s EPLIST(4)=ETypeDR
		s EPLIST(5)=EScore
		s EPLIST(7)=vCurRole
		s EPLIST(8)=User
		s EPLIST(9)=Date
		s EPLIST(10)=Time
		s ERowID=0
		s EFind=""
		f  s ERowID=$o(^DHCEQEvaluate(0,"SourceType",vSourceType,vSourceID,ETypeDR,ERowID))  q:(ERowID="")||(EFind'="")  d
		.s ERemark=$p($g(^DHCEQEvaluate(ERowID)),"^",6)
		.q:(ERemark'=vCurRole)
		.s EFind=ERowID
		i EFind=""
		{
			&sql(Insert Into SQLUser.DHC_EQEvaluate Values :EPLIST())
		}
		else
		{
			&sql(Update sqluser.DHC_EQEvaluate Values :EPLIST() where E_RowID=:EFind)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q vSourceID
}

/****************************************************/
/// Add By DJ 2014-09-26
/// 描述:派单未受理维修单自动退回重新派单
ClassMethod AutoReturn()
{
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	TSTART
	s SQLCODE=0
	s MMRowID=0
	f  s MMRowID=$o(^DHCEQMMaintRequest(0,"Status",1,MMRowID))  q:(MMRowID="")||(SQLCODE'=0)  d
	.s MRAssignDate=$p($g(^DHCEQMMaintRequest(MMRowID)),"^",64)		//派单日期
	.q:MRAssignDate=""
	.s MRApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("25",MMRowID)
	.s MRNextRole=$p(MRApproveInfo,"^",3)
	.q:MRNextRole=18		//等待派单
	.s MRAcceptDate=$p($g(^DHCEQMMaintRequest(MMRowID)),"^",24)		//受理日期
	.i ((MRNextRole=19)&&(MRAssignDate<=(+$H-2)))  d		//未受理单据重新派单
	..k AppInfo
	..s AppInfo(5)=18
	..s AppInfo(6)=1
	..s AppInfo(9)=1	;Status	
	..&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:MMRowID and AI_ApproveTypeDR=:ApproveType)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q 0
}

/// Modefied by zc 2015-03-06 ZC0019
ClassMethod UpdMaintProcess(RowID, MaintProcess)
{
	&SQL(update SQLUSER.DHC_EQMMaintRequest set MR_MaintProcessDR=:MaintProcess  where MR_RowID=:RowID)
}

/// Modefied by zc 2015-03-06 ZC0019
ClassMethod UpdInsurFlag(RowID, InsurFlag)
{
	&SQL(update SQLUSER.DHC_EQMMaintRequest set MR_InsurFlag=:InsurFlag  where MR_RowID=:RowID)
}

/// 维修进程
/// Modefied by zc 2015-03-06 ZC0019
ClassMethod GetMaintProcess(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintProcess",rowid))  quit:rowid=""  d
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",4) //无符号标志
	.q:TInvalidFlag="Y"	
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",2) //描述
	.w "<option value="_TRowID_">"_TDesc_"</option>"
	w "</select>",!
}

/// Mozy	2015-12-15
/// 更新存储受理人信息
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).UpdAcceptInfo(18)
/// Mofified by HHM 2016-04-20 处理移动端取session值，添加User参数
ClassMethod UpdAcceptInfo(RowID, User As %Library.String = "")
{
	Kill AcceptInfo
	Set AcceptInfo(25)=+$H				; MR_AcceptDate
	Set AcceptInfo(26)=$Piece($H,",",2)	; MR_AcceptTime
	/*If $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",26)=""
	{ 
		i User'=""
			{	Set AcceptInfo(27)=User  }
		else
			{	Set AcceptInfo(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	}	; MR_AcceptUserDR
	}*/
	i User'=""
	{	Set AcceptInfo(27)=User  }
	else
	{	Set AcceptInfo(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	}	; MR_AcceptUserDR
	//add by zx 2016-12-08 存放维修组用 ZX0036
	s MaintGroup=""
	if AcceptInfo(27)'="" d
	.&SQL(SELECT MGL_MaintGroupDR into :MaintGroup FROM SQLUSER.DHC_EQMCMaintGroupList WHERE MGL_MemberUserDR=:AcceptInfo(27) and MGL_InvalidFlag='N')  //modified by wy 2022-9-14 只查询有效维修组人员
	.i MaintGroup'="" d
	..s AcceptInfo(71)=MaintGroup
	.e  d
	..s AcceptInfo(71)=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader","1",AcceptInfo(27),0))
	&SQL(update SQLUSER.DHC_EQMMaintRequest values :AcceptInfo() where MR_RowID=:RowID)
	Quit SQLCODE
}

/// 审批进度
/// Created by HHM HHM0031 20151215
/// w ##Class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","ApproveProcess","25","2")
Query ApproveProcess(ApproveTypeDR As %Library.String = "", SourceID As %Library.String = "") As %Query(ROWSPEC = "TApproveType:%String,TOpinion:%String,TRemark:%String,TApproveRole:%String,TApproveUser:%String,TApproveDate:%String,TApproveTime:%String,TOperateType:%String,TInfoStatus:%String,RowID:%String,TAction:%String")
{
}

ClassMethod ApproveProcessExecute(ByRef qHandle As %Binary, ApproveTypeDR, SourceID) As %Status
{
	n repid, index,rowid,RowID
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	s RowID=1
	///获取审批意见
	i ApproveTypeDR="" q 
	i SourceID="" q
	;s TApproveInfo=##Class(web.DHCEQCommon).GetApproveInfo(ApproveTypeDR,SourceID)
	
	s rowid=0
	f   s rowid=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,SourceID,rowid)) q:rowid=""  d
	.d ResetVariablesApproveProcess
	.s ApproveTypeDR= $p($g(^DHCEQApproveList(rowid)),"^",1) 
	.i ApproveTypeDR'="" d
	..s TApproveType=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",2)
	.s TOpinion=$p($g(^DHCEQApproveList(rowid)),"^",3)
	.s TRemark=$p($g(^DHCEQApproveList(rowid)),"^",4)
	.s ApproveRoleDR=$p($g(^DHCEQApproveList(rowid)),"^",5)
	.i ApproveRoleDR'="" d
	..s TApproveRole=##Class(web.DHCEQCommon).GetTrakNameByID("role",ApproveRoleDR)
	.e  s TApproveRole="制单人"
	.s ApproveUserDR=$p($g(^DHCEQApproveList(rowid)),"^",6) 
	.i ApproveUserDR'="" d
	..s TApproveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ApproveUserDR)
	.s TApproveDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(rowid)),"^",7),"date")
	.s TApproveTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(rowid)),"^",8),"time")
	.s TOperateType= $p($g(^DHCEQApproveList(rowid)),"^",12)   ;当前状态
	.i TOperateType="1" s TOperateType="拒绝"
	.i TOperateType="0" s TOperateType="同意"
	.s FlowStep=$p($g(^DHCEQApproveList(rowid)),"^",9)    ;获取单子当前审批步骤，配合DHCEQApproveInfo获取下一审批步骤
	.s TActionDR=$p($g(^DHCEQApproveList(rowid)),"^",11)  //add by zx 2016-05-11 begin
	.i TActionDR'="" d
	..s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.i TActionDR=0 s TAction="提交"   //add by zx 2016-05-11 end
	.d GetApproveIinfo
	.d OutputRowApproveProcess	
	quit $$$OK
GetApproveIinfo	
	s infoid=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,SourceID,0))
	/*i FlowStep="0"  d       
	.s TNextApproveRoleDR=$p($g(^DHCEQApproveInfo(infoid)),"^",4)
	..i TNextApproveRoleDR'="" d
	...s TNextApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TNextApproveRoleDR)),"^",2)
	i FlowStep="1" d
	.s TNextApproveRole=""    ;判断为最后一步*/
	;s TInfoStatus= ##Class(web.DHCEQCommon).GetEditStatusDisplay($p($g(^DHCEQApproveInfo(infoid)),"^",8))    ;DHCEQApproveInfo 审批信息当前状态
	s TInfoStatus= ##Class(web.DHCEQCommon).GetEditStatusDisplay(FlowStep)
		
	quit
OutputRowApproveProcess
	s RowID=index
	s Data=$lb(TApproveType,TOpinion,TRemark,TApproveRole,TApproveUser,TApproveDate,TApproveTime,TOperateType,TInfoStatus,RowID,TAction)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetVariablesApproveProcess
	s (TApproveType,TOpinion,TRemark,TApproveRole,TApproveUser,TApproveDate,TApproveTime,TOperateType,TInfoStatus,RowID,TActionDR,TAction)=""
	quit
}

ClassMethod ApproveProcessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApproveProcessExecute ]
{
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ApproveProcessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApproveProcessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2016-7-5
/// 获取维修单设备附属附件在效期内维修的信息
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).GetMaintNumForAffix(88)
ClassMethod GetMaintNumForAffix(RowID As %Library.String = "")
{
	i RowID="" q ""
	s EquipDR=""
	s ExObjDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)			//ExObjDR
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)		//MRHold3
	i SourceTypeDR=1 s EquipDR=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
	i EquipDR="" q ""
	
	s strinfo=""
	s job=$j
	k ^TempDHCEQ("GetMaintNumForAffix",job)
	s MMRowID=0
	f  s MMRowID=$o(^DHCEQMMaintRequest(MMRowID)) q:(MMRowID="")  d
	.q:$p($g(^DHCEQMMaintRequest(MMRowID)),"^",57)'="N"		;无效单据
	.s MRAuditDate=$p($g(^DHCEQMMaintRequest(MMRowID)),"^",52)
	.q:MRAuditDate=""		;未完成业务
	.
	.;是否同一设备的维修业务单
	.s tmpEquipDR=""
	.s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(MMRowID)),"^",63)
	.i SourceTypeDR=1 s tmpEquipDR=$Piece($Get(^DHCEQMExObj($Piece($Get(^DHCEQMMaintRequest(MMRowID)),"^",5))),"^",5)
	.q:tmpEquipDR'=EquipDR
	.
	.s affixsInfo = ##Class(web.DHCEQAffix).GetAffixsInfoByEquip(EquipDR)
	.s len= $l(affixsInfo,"&")
	.for i=1:1:len d
	..s str= $Piece(affixsInfo,"&",i)
	..s BeginDate=$p(str,"^",25)
	..;i BeginDate'="" s BeginDate=$zdh(BeginDate)
	..;日期格式统一调整
	..s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	..q:MRAuditDate<BeginDate
	..s EndDate=$p(str,"^",26)
	..;i EndDate'="" s EndDate=$zdh(EndDate)
	..;日期格式统一调整
	..s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	..q:MRAuditDate>EndDate
	..
	..s ^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i)=1+$g(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i))
	..
	
	s i=""
	f  s i=$o(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i)) q:(i="")  d
	.s str= $Piece(affixsInfo,"&",i)
	.s affixname=$p(str,"^",4)
	.i strinfo'="" s strinfo=strinfo_","
	.s strinfo=strinfo_affixname_"^"_$g(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i))
	.
	k ^TempDHCEQ("GetMaintNumForAffix",job)
	q strinfo
}

/// 获取工程师组长所在组
/// add by zx 2016-12-08
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).CheckMaintGroup(3823)
ClassMethod CheckMaintGroup(Leader As %Library.String = "")
{
	i Leader="" q ""
	s MaintGroupID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader","1",Leader,0))
	
	q MaintGroupID
}

/// 控制在维修中的设备不可再进行提交
/// add by zx 2017-01-04
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).CheckMaintProcess(1,52)
ClassMethod CheckMaintProcess(SourceType, ExObjID, RowID As %String = "")
{
	n ReturnFlag,TRequestNo,TRequestUser,TRequestDate
	s (ReturnFlag,TRequestNo,TRequestUser,TRequestDate)=""
	s ReturnFlag=0
	i (SourceType="")||(ExObjID="") q ReturnFlag
	s MaintRequestID=0
	f  s MaintRequestID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,ExObjID,MaintRequestID)) q:(MaintRequestID="")||(ReturnFlag=1)  d
	.;是否同一设备的维修业务单  add by wy 2017-6-2
	.q:(RowID'="")&&(RowID=MaintRequestID)
	.s TInvalidFlag=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",57)
	.q:TInvalidFlag="Y"
	.s TStatus=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",41)
	.i TStatus'="2" s ReturnFlag=1
	.s TRequestNo=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",1)
	.s TRequestUserDR=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",20)
	.i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TRequestDate=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",18)
	.;i TRequestDate'="" s TRequestDate=$ZD(TRequestDate,3)
	.;日期格式统一调整
	.s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	
	q ReturnFlag_"^"_TRequestNo_"^"_TRequestUser_"^"_TRequestDate
}

/****************************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetMaintEvalueList")
Query GetMaintEvalueList(vRequestNo As %String = "", CurRole As %String = "", QXType As %String = "", CurUser As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", EvaluateRange As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestNo:%String,TEquipName:%String,TEquipType:%String,TCheckEvaluateFlag:%String,TLookEvaluateFlag:%String")
{
}

ClassMethod GetMaintEvalueListExecute(ByRef qHandle As %Binary, vRequestNo As %String = "", CurRole As %String = "", QXType As %String = "", CurUser As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", EvaluateRange As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s MStatus=0
	f  s MStatus=$o(^DHCEQMMaintRequest(0,"Status",MStatus))  q:MStatus=""  d
	.q:MStatus>2	//只取提交和已审核单据
	.s MRowID=0
	.f  s MRowID=$o(^DHCEQMMaintRequest(0,"Status",MStatus,MRowID))  q:MRowID=""  d
	..d ResetVariablesGetMaintEvalueList
	..s MInvalidFlag=$p($g(^DHCEQMMaintRequest(MRowID)),"^",57)
	..q:MInvalidFlag="Y"
	..s TRowID=MRowID
	..s TRequestNo=$p($g(^DHCEQMMaintRequest(MRowID)),"^",1)
	..s TEquipTypeDR=$p($g(^DHCEQMMaintRequest(MRowID)),"^",3)
	..i TEquipTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	..s TCheckEvaluateFlag=##Class(web.DHCEQEvaluate).CheckEvaluateFlag(31,TRowID,CurRole,"","",CurUser,"")
	..q:+TCheckEvaluateFlag<0		//无需评价或未进入评价的单据则不显示
	..q:((EvaluateRange=0)&&($p(TCheckEvaluateFlag,"^",2)<0))			//个人评价
	..q:((EvaluateRange=1)&&($p(TCheckEvaluateFlag,"^",2)'=-2))			//他人评价
	..s TSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(MRowID)),"^",63)
	..s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(MRowID)),"^",5)
	..i TExObjDR '="" Set TEquipName = $Piece($Get(^DHCEQMExObj(TExObjDR)),"^",1) 
	..s TLookEvaluateFlag=##Class(web.DHCEQEvaluate).GetEvaluateLookByRole(31,TRowID,CurRole,CurUser)
	..d OutputRowGetMaintEvalueList
	
	Quit $$$OK
OutputRowGetMaintEvalueList
	Set Data=$lb(TRowID,TRequestNo,TEquipName,TEquipType,TCheckEvaluateFlag,TLookEvaluateFlag)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintEvalueList
	Set (TRowID,TRequestNo,TEquipName,TEquipType,TCheckEvaluateFlag,TLookEvaluateFlag)=""
	Quit
}

ClassMethod GetMaintEvalueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintEvalueListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintEvalueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintEvalueListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/****************************************************************************/
ClassMethod GetEQStatus(vEQNo As %String = "")
{
	i vEQNo="" q ""
	s EQRowID=$o(^DHCEQEquip(0,"No",vEQNo,0))
	i EQRowID="" q ""
	q $p($g(^DHCEQEquip(EQRowID)),"^",38)
}

/// w ##class(web.DHCEQM.DHCEQMMaintRequest).UpdFinishInfo(18)
/// Add By czf 579085 更新储存完成时间
ClassMethod UpdFinishInfo(RowID)
{
	Kill FinishInfo
	Set FinishInfo(17)=+$H				; MR_EndDate
	Set FinishInfo(18)=$Piece($H,",",2)	; MR_EndTime
	
	&SQL(update SQLUSER.DHC_EQMMaintRequest values :FinishInfo() where MR_RowID=:RowID)
	Quit SQLCODE
}

/// add by CZF0073 2020-02-24
/// 导入维修信息
/// d ##class(web.DHCEQM.DHCEQMMaintRequest).ImportData("","","^^2^3^2^2^2^2")
ClassMethod ImportData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String)
{
	Set $ZT="ERRORImportData"
	s User=%session.Get("LOGON.USERID")
	k PLIST,LI
	//s ^CZF("m")=val
	s PLIST(2) = $p(val,"^",1) //MR_RequestNo
	s PLIST(5) = $p(val,"^",2) //MR_ObjTypeDR 维修对象设备类型
	s PLIST(6) = $p(val,"^",3) //MR_ExObjDR
	i PLIST(6) = "" q -1001
	s PLIST(7) = $p(val,"^",4) //MR_ObjLocDR
	s PLIST(8) = $p(val,"^",5) //MR_RequestLocDR
	s PLIST(11) = $p(val,"^",6) //MR_FaultCaseDR
	s PLIST(12) = $p(val,"^",7) //MR_FaultCaseRemark	故障现象
	s PLIST(13) = $p(val,"^",8) //MR_FaultReasonDR
	s PLIST(14) = $p(val,"^",9) //MR_FaultReasonRemark	 故障原因
	s PLIST(15) = $p(val,"^",10) //MR_DealMethodDR
	s PLIST(16) = $p(val,"^",11) //MR_DealMethodRemark   解决方法
	s PLIST(17) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")
	s PLIST(18) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"time") //MR_EndTime
	s PLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")
	s PLIST(20) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",15),"time") //MR_RequestTime
	s PLIST(21) = $p(val,"^",16) //MR_RequestUserDR
	s PLIST(22) = $p(val,"^",17) //MR_RequestTel
	s PLIST(23) = $p(val,"^",18) //MR_Place
	s PLIST(24) = $p(val,"^",19) //MR_FaultTypeDR
	s PLIST(25) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")
	s PLIST(26) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",21),"time")
	s PLIST(27) = $p(val,"^",22) //MR_AcceptUserDR
	s PLIST(28) = $p(val,"^",23) //MR_AssignDR
	s PLIST(29) = $p(val,"^",24) //MR_MaintModeDR
	s PLIST(40) = $p(val,"^",25) //MR_WorkHour
	s PLIST(41) = $p(val,"^",26) //MR_Remark
	s PLIST(42) = $p(val,"^",27) //MR_Status
	If PLIST(42)="" Set PLIST(42)=0
	s PLIST(43)= User //MR_AddUser
	s PLIST(44)= +$H  //MR_AddDate
	s PLIST(45)= $Piece($H,",",2) //MR_AddTime
	s PLIST(58) = "N"            //MR_InvalidFlag
	s PLIST(59) = $p(val,"^",28) //MR_MaintFee
	s PLIST(60) = $p(val,"^",29) //MR_OtherFee
	s PLIST(61) = $p(val,"^",30) //MR_TotalFee
	s PLIST(64) = $p(val,"^",31) //MR_SourceType
	s PLIST(78) = $p(val,"^",32) //MR_InputFlag
	s PLIST(4) = $p(val,"^",33)  //MR_EquipTypeDR
	
	s EquipTypeDR=""
	s ExType=$p($g(^DHCEQMExObj(PLIST(6))),"^",4)
	s ExID=$p($g(^DHCEQMExObj(PLIST(6))),"^",5)
	i (ExType=1)&&(ExID'="") d
	.s EquipTypeDR=$p($g(^DHCEQEquip(ExID)),"^",63)
	.i PLIST(4)="" s PLIST(4)=EquipTypeDR
	.i PLIST(5)="" s PLIST(5)=$p($g(^DHCEQEquip(ExID)),"^",75)
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053")
	i ((","_FacilityEquipType_",")[(","_EquipTypeDR_",")) s PLIST(64) ="2"		//未在账
	
	TStart
	
	s EquipTypeCode=""
	i PLIST(4)'="" s EquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",PLIST(4))),"^",1)
	i PLIST(2)="" Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMMaintRequest",+$H,PLIST(8),EquipTypeCode)
	&sql(Insert Into SQLUser.DHC_EQMMaintRequest Values :PLIST())
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set RowID=$Get(%ROWID)
	
	//Modify by zx 2020-08-20 BUG ZX0102 生命周期信息插入
	i PLIST(42)="2"
	{
		q:ExType'=1 //设备
		// 生命周期 	
		Set LI(2)=ExID
		Set LI(9)=$Piece($Get(^DHCEQEquip(ExID)),"^",19)   	//变动后使用科室
		Set LI(10)=$Piece($Get(^DHCEQEquip(ExID)),"^",17) 		//变动后管理科室
		Set LI(11)=$Piece($Get(^DHCEQEquip(ExID)),"^",67)  	//变动后库房
		Set LI(12)=$Piece($Get(^DHCEQEquip(ExID)),"^",27)  	//变动后原值
		Set LI(13)=$Piece($Get(^DHCEQEquip(ExID)),"^",28)  	//变动后净值
		If $p(val,"^",6)'="" Set LI(14)=$Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",$p(val,"^",6))),"^",2)  //变动原因
		Set LI(15)=$p(val,"^",7)         	//变动描述
		Set LI(16)=+$H						//变动日期
		Set LI(17)=$Piece($H,",",2)			//变动时间
		Set LI(18)=+$p(val,"^",28)+..GetTotalFee(RowID,1)  	//总费用
		Set LI(19)="P"						//生命周期类型
		Set LI(20)=31						//来源类型
		Set LI(21)=RowID					//来源ID
		Set LI(23)=$p(val,"^",26)       	//备注
		Set LI(27)=User						//更新人
		Set LI(28)=Date						//更新日期
		Set LI(29)=Time						//更新时间
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	TCOMMIT
	Quit RowID
ERRORImportData
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORImportData"_ErrorMsg     //返回错误消息
}

/// add by csj 2020-05-29
ClassMethod GetList(node As %Library.String = "", job, gnum, rows As %Library.String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=$g(^TempDHCEQ(node,+$H,job,gnum))
	if rows'=""
	{
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^TempDHCEQ(node,+$h,job,gnum+i)
		}
	}
	q str
}

/// add by csj 2020-05-29
ClassMethod GetNum(node As %Library.String = "", job)
{
	s gnum=$o(^TempDHCEQ(node,+$h,job,""),-1)      
  	q gnum
}

/// Modify by zx 2020-11-24 维修历史记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetMaintRequestHiStory","26")
Query GetMaintRequestHiStory(vEQRowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestDate:%String,TRequestUser:%String,TRequestTel:%String,TFaultCaseDR:%String,TFaultCase:%String,TFaultCaseRemark:%String,TDealMethodDR:%String,TDealMethod:%String,TAcceptUser:%String,TModeInfo:%String,TRemark:%String")
{
}

ClassMethod GetMaintRequestHiStoryExecute(ByRef qHandle As %Binary, vEQRowID As %String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	i vEQRowID="" q $$$OK
	s vEQRowID=$o(^DHCEQMExObj(0,"ExID",1,vEQRowID,0))
	s SourceType=0
	f  s SourceType=$o(^DHCEQMMaintRequest(0,"Source",SourceType))  q:SourceType=""  d
	.q:((SourceType'=1)&&(SourceType'=2))
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,vEQRowID,MRRowID))  q:MRRowID=""  d
	..Do ResetVariablesGetMaintRequestHiStory
	..q:$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)="Y"
	..q:$p($g(^DHCEQMMaintRequest(MRRowID)),"^",41)'=2
	..s TRequestDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",18),"date")
	..s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",20))
	..s TRequestTel = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",21)
	..Set TFaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",10)
	..If TFaultCaseDR '=""  Do
	...Set TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",TFaultCaseDR)),"^",2)
	..Set TFaultReasonRemark = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",13)
	..i TFaultCase'="" s TFaultCase=TFaultCase_"("_TFaultReasonRemark_")" //add by csj 20190307
	..Set TDealMethodDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",14)
	..If TDealMethodDR '=""  Do
	...Set TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",TDealMethodDR)),"^",2)
	..s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",26))
	..//s TModeInfo=##Class(web.DHCEQM.DHCEQMMaintRequest).GetMaintModeInfo(MRRowID)
	..s TDealMethod=TDealMethod_""_TModeInfo
	..s TRowID=MRRowID
	..s TRemark=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",40)
	..d OutputRowGetMaintRequestHiStory
	Quit $$$OK
	

OutputRowGetMaintRequestHiStory
	Set Data=$lb(TRowID,TRequestDate,TRequestUser,TRequestTel,TFaultCaseDR,TFaultCase,TFaultCaseRemark,TDealMethodDR,TDealMethod,TAcceptUser,TModeInfo,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintRequestHiStory
	Set (TRowID,TRequestDate,TRequestUser,TRequestTel,TFaultCaseDR,TFaultCase,TFaultCaseRemark,TDealMethodDR,TDealMethod,TAcceptUser,TModeInfo,TRemark)=""	
	Quit
}

ClassMethod GetMaintRequestHiStoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestHiStoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestHiStoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestHiStoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 通过生命周期获取设备某业务历史发生数量
/// 入参: SourceType 业务类型, EquipID 设备ID
/// 返回值: TotalNum 业务历史发生数量
/// w ##class(web.DHCEQM.DHCEQMMaintRequest).GetHistoryQuantity("31","26")
ClassMethod GetHistoryQuantity(SourceType, EquipID)
{
	s TotalNum=0
	i (SourceType="")||(EquipID="") q TotalNum
	s SourceID=0
	f  s SourceID=$o(^DHCEQLifeInfo(0,"EquipSource",SourceType,EquipID,SourceID)) q:SourceID=""  d
	.s TotalNum=TotalNum+1
	
	q TotalNum
}

/// modified by ZY 20220822  2854248
/// Add By QW20210629 BUG:QW0129 维修信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintRequest","GetMaintRequestInfo","26")
Query GetMaintRequestInfo(vEQRowID As %String = "") As %Query(ROWSPEC = "TRequestNo:%String:维修单号,TRowID:%String,TRequestDate:%String:申请日期,TRequestUser:%String:申请人,TRequestTel:%String:申请电话,TFaultCase:%String:故障现象,TFaultReason:%String:故障原因,TDealMethod:%String:解决方法,TAcceptUser:%String:接受人")
{
}

ClassMethod GetMaintRequestInfoExecute(ByRef qHandle As %Binary, vEQRowID As %String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	i vEQRowID="" q $$$OK
	s vEQRowID=$o(^DHCEQMExObj(0,"ExID",1,vEQRowID,0))
	s SourceType=0
	f  s SourceType=$o(^DHCEQMMaintRequest(0,"Source",SourceType))  q:SourceType=""  d
	.q:((SourceType'=1)&&(SourceType'=2))
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,vEQRowID,MRRowID))  q:MRRowID=""  d
	..Do ResetVariablesGetMaintRequestInfo
	..q:$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)="Y"
	..q:$p($g(^DHCEQMMaintRequest(MRRowID)),"^",41)'=2
	..s TRequestNo = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",1)
	..s TRequestDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",18),"date")
	..s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",20))
	..s TRequestTel = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",21)
	..Set TFaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",10)
	..If TFaultCaseDR '=""  Do
	...Set TFaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",TFaultCaseDR)),"^",2)
	..Set TDealMethodDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",14)
	..If TDealMethodDR '=""  Do
	...Set TDealMethod = $Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",TDealMethodDR)),"^",2)
	..Set TFaultReasonDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",12)
	..If TFaultReasonDR '=""  Do
	...Set TFaultReason = $Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",TFaultReasonDR)),"^",2)
	..s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",26))
	..s TRowID=MRRowID
	..d OutputRowGetMaintRequestInfo
	Quit $$$OK
	

OutputRowGetMaintRequestInfo
	Set Data=$lb(TRequestNo,TRowID,TRequestDate,TRequestUser,TRequestTel,TFaultCase,TFaultReason,TDealMethod,TAcceptUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintRequestInfo
	Set (TRowID,TRequestNo,TRequestDate,TRequestUser,TRequestTel,TFaultCaseDR,TFaultCase,TFaultReasonDR,TFaultReason,TDealMethodDR,TDealMethod,TAcceptUser)=""	
	Quit
}

ClassMethod GetMaintRequestInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc0125 2022-11-18
/// w ##Class(web.DHCEQM.DHCEQMMaintRequest).FeeTypeList("FeeType")
ClassMethod FeeTypeList(name, width As %String = "", promptinfo As %String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name, width, promptinfo)
	w "<option value=>全部</option>"
	w "<option value=1>有费用维修</option>"
	w "<option value=2>无费用维修</option>"
	w "</select>",!
}

}
