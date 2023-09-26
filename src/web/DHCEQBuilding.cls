Class web.DHCEQBuilding Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(VAL As %Library.String = "", SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "", ISDEL As %Library.String = "")
{
	i (+ISDEL=1) q 0  //删除操作修改主表标志位就好了
	q:VAL="" -1
	New List,BDRowID,BDEquipDR,BDSourceType,BDSourceID
	Set BDEquipDR = $Piece(VAL,"^",3)
	/*
	if BDEquipDR'=""    
	{
		//兼容旧版本	
	 	Set BDRowID = $Order(^DHCEQBuilding(0,"EquipDR",BDEquipDR,-1))
	 	Set BDSourceType = 1 ;BDSourceType
	 	Set BDSourceID = BDRowID	;BDSourceID
	 	//Set BDEquipDR="" 还是不要改旧数据好
	}
	else
	{
	 	Set BDSourceType = SOURCETYPE ;BDSourceType
	 	Set BDSourceID = SOURCEID	;BDSourceID
	 	quit:""=BDSourceType -1
	 	quit:""=BDSourceID -1
	 	Set BDRowID = $Order(^DHCEQBuilding(0,"Source",BDSourceType,BDSourceID,-1))
	 	i BDSourceType=1 s BDEquipDR=BDSourceID
	}*/
	Set BDSourceType = SOURCETYPE ;BDSourceType
	Set BDSourceID = SOURCEID	;BDSourceID
	//quit:""=BDSourceType -1  //modify by lmm  2021-06-17 SOURCETYPE字段已改为备注
	quit:""=BDSourceID -1
	i BDSourceType=0 Set BDRowID = $Order(^DHCEQBuilding(0,"Source",BDSourceType,BDSourceID,-1))
	e  d
	.s BDEquipDR=SOURCEID
	.Set BDRowID = $Order(^DHCEQBuilding(0,"EquipDR",BDEquipDR,-1))
	
	Set List(2) = BDEquipDR		;BDEquipDR 旧版本字段，新版本置空不用，用BDSourceType，BDSourceID替代
 	Set List(3) = $Piece(VAL,"^",4)	;BDStructDR
    Set List(4) = $Piece(VAL,"^",5)		;BDBuildingArea
    Set List(5) = $Piece(VAL,"^",6)		;BDUtilizationArea
  	Set List(6) = $Piece(VAL,"^",7)		;BDSubArea
  	Set List(7) = $Piece(VAL,"^",8)		;BDPlace
  	Set List(8) = $Piece(VAL,"^",9)		;BDOwnerFlag
 	//If $Piece(VAL,"^",9)'="" Set List(8) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(VAL,"^",9),"bool")	;BDOwnerFlag
  	Set List(9) = $Piece(VAL,"^",10)		;BDSelfUseArea
   	Set List(10) = $Piece(VAL,"^",11)	;BDLendingArea
   	Set List(11) = $Piece(VAL,"^",12)	;BDRentArea
   	Set List(12) = $Piece(VAL,"^",13)	;BDWorkArea
 	Set List(13) = $Piece(VAL,"^",14)	;BDIdleArea
    Set List(14) = $Piece(VAL,"^",15)	;BDOtherArea
    Set List(15) = $Piece(VAL,"^",16)	;BDLendCompany
 	Set List(16) = $Piece(VAL,"^",17)	;BDRentCompany
 	Set List(17) = $Piece(VAL,"^",18)	;BDOwnerCertificat
 	Set List(18) = $Piece(VAL,"^",19)	;BDCertificateNo
  	If $Piece(VAL,"^",20)'="" Set List(19) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(VAL,"^",20),"date")	;BDCertificateDate
  	Set List(20) = $Piece(VAL,"^",21)	;BDFloorNum
  	Set List(21) = $Piece(VAL,"^",22)	;BDUnderFloorNum
  	Set List(22) = $Piece(VAL,"^",23)	;BDHold1
  	Set List(23) = $Piece(VAL,"^",24)	;BDHold2
  	Set List(24) = $Piece(VAL,"^",25)	;BDHold3
  	Set List(25) = $Piece(VAL,"^",26)	;BDHold4
  	Set List(26) = $Piece(VAL,"^",27)	;BDHold5
  	Set List(27) = $Piece(VAL,"^",28)  //BDSourceType	;BDSourceType   //modify by lmm 2021-06-16
  	Set List(28) = BDSourceID	;BDSourceID
  	Set List(29) = $Piece(VAL,"^",30)	;BDOwnerKind
  	Set List(30) = $Piece(VAL,"^",31)	;BDOwnershipYear
  	Set List(31) = $Piece(VAL,"^",32)	;BDOwner
  	//Set List(32) = $Piece(VAL,"^",33)	;BDCompletionDate
  	If $Piece(VAL,"^",33)'="" Set List(32) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(VAL,"^",33),"date")	;BDCertificateDate
  	Set List(33) = $Piece(VAL,"^",34)	;BDSelfUseFee
  	Set List(34) = $Piece(VAL,"^",35)	;BDLendingFee
  	Set List(35) = $Piece(VAL,"^",36)	;BDRentFee
  	Set List(36) = $Piece(VAL,"^",37)	;BDWorkFee
  	Set List(37) = $Piece(VAL,"^",38)	;BDIdleFee
  	Set List(38) = $Piece(VAL,"^",39)	;BDOtherFee
  	//Set List(39) = $Piece(VAL,"^",40)	;BDLandPurposeDR
  	
	
	Kill List(1)

	If (BDRowID'="") 
	{
		&SQL(Update SQLUSER.DHC_EQBuilding Values :List() where BD_RowID = :BDRowID)
	}
	Else
	{
		&SQL(Insert Into SQLUSER.DHC_EQBuilding Values :List())
	}

	Quit SQLCODE
}

/// w ##Class(web.DHCEQBuilding).GetDHCEQBuildingByID(0,380)
ClassMethod GetDHCEQBuildingByID(SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "")
{
	New BDRowID,result,BDi
	quit:""=SOURCETYPE -1
	quit:""=SourceID -1
	i SOURCETYPE=0 Set BDRowID = $Order(^DHCEQBuilding(0,"Source",SOURCETYPE,SOURCEID,-1))
	e  Set BDRowID = $Order(^DHCEQBuilding(0,"EquipDR",SOURCEID,-1))
	//------------------------------------DHCEQBuilding------------------------------------------
	s BDCount=38
	Set result= BDRowID_"^"_$Get(^DHCEQBuilding(BDRowID))
	Set len=$L(result,"^")					//解决旧数据长度不足BDCount大小的问题
	for BDi=len:1:BDCount-1
	{
		s result=result_"^"
	}
	If $Piece(result,"^",19)'="" Set $Piece(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",19),"date")		;BDCertificateDate
	If $Piece(result,"^",32)'="" Set $Piece(result,"^",32)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",32),"date")		;BDCompletionDate
	
	//------------------------------------DHCEQEquip---------------------------------------------
	s EQCount=1
	Set result=result_"^"
	i SOURCETYPE=1	Set result=result_##Class(web.DHCEQCommon).TransValueToPage($p(^DHCEQEquip(SOURCEID),"^",53),"date")  //EQ_AddDate 入账日期
	
	//------------------------------------DHCEQCBuildingStruct---------------------------------------------
	s ESCount=1
	Set result=result_"^"
	i $Piece(result,"^",3)'=""	Set result=result_$p(^DHCEQCCode("DHCEQCBuildingStruct",$Piece(result,"^",3)),"^",2)  //EQ_AddDate 入账日期
	Quit result
}

ClassMethod OwnerFlagList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;i type="" w "<option value=0></option>"
	w "<option value=''>产权待界定</option>"
	w "<option value='N'>无产权</option>"
	w "<option value='Y'>有产权</option>"
	w "</select>",!
}

ClassMethod OwnerKindList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;i type="" w "<option value=0></option>"
	w "<option value='1'>国有</option>"
	w "<option value='2'>集体</option>"
	w "</select>",!
}

ClassMethod test(num As %String = "1") As %String
{
	w num
	&SQL(Update SQLUSer.DHC_EQBuilding set BD_StructDR=1 where BD_StructDR=:num)
	w SQLCODE
}

}
