Class web.DHCEQLand Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 77;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "L_RowID";

Parameter SQLDESCRIPTION = "L_RowID";

Parameter SQLROWID = "L_RowID";

ClassMethod Save(VAL As %Library.String = "", SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "", ISDEL As %Library.String = "")
{
	i (+ISDEL=1) q 0  //删除操作修改主表标志位就好了
	
	
	new PLIST,LRowID,SQLCODE,LEquipDR
	s SQLCODE=0
	Set LEquipDR = $Piece(VAL,"^",3)

	Set LSourceType = SOURCETYPE ;BDSourceType
	Set LSourceID = SOURCEID	;BDSourceID
	quit:""=LSourceType -1
	quit:""=LSourceID -1
	i LSourceType=0 Set LRowID = $Order(^DHCEQLand(0,"Source",LSourceType,LSourceID,-1))
	e  d
	.set LEquipDR=LSourceID
	.Set LRowID = $Order(^DHCEQLand(0,"Equip",LEquipDR,-1))

	
 	s PLIST(1) = LRowID	;LRowID
 	s PLIST(2) = LEquipDR	;LEquipDR
 	s PLIST(3) = $p(VAL,"^",4)	;LArea
 	s PLIST(4) = $p(VAL,"^",5)	;LandNo
 	s PLIST(5) = $p(VAL,"^",6)	;LOwnerFlag
	 //i $p(VAL,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(VAL,"^",5),"bool")	;LOwnerFlag
 	s PLIST(6) = $p(VAL,"^",7)	;LPlace
 	s PLIST(7) = $p(VAL,"^",8)	;LSelfUsedArea
	 s PLIST(8) = $p(VAL,"^",9)	;LIdleArea
	 s PLIST(9) = $p(VAL,"^",10)	;LendingArea
	 s PLIST(10) = $p(VAL,"^",11)	;LRentArea
 	s PLIST(11) = $p(VAL,"^",12)	;LWorkArea
 	s PLIST(12) = $p(VAL,"^",13)	;LOtherArea
	 s PLIST(13) = $p(VAL,"^",14)	;LLendCompany
 	s PLIST(14) = $p(VAL,"^",15)	;LRentCompany
 	s PLIST(15) = $p(VAL,"^",16)	;LOwnerCertificate
 	s PLIST(16) = $p(VAL,"^",17)	;LCertificateNo
 	//s PLIST(17) = $p(VAL,"^",18)	;LCertificateDate
	 i $p(VAL,"^",18)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(VAL,"^",18),"date")	;LCertificateDate
 	s PLIST(18) = $p(VAL,"^",19)	;LOwnerKind
	 s PLIST(19) = $p(VAL,"^",20)	;LCertificateArea
	 s PLIST(20) = $p(VAL,"^",21)	;LHold1
 	s PLIST(21) = $p(VAL,"^",22)	;LHold2
 	s PLIST(22) = $p(VAL,"^",23)	;LHold3
 	s PLIST(23) = $p(VAL,"^",24)	;LHold4
	 s PLIST(24) = $p(VAL,"^",25)	;LHold5
	 //GR0019 土地资产卡片 2014-12-08
	 s PLIST(25) = $p(VAL,"^",26)	;LSelfUsedFee
	 s PLIST(26) = $p(VAL,"^",27)	;LIdleFee
	 s PLIST(27) = $p(VAL,"^",28)	;LLendingFee
 	s PLIST(28) = $p(VAL,"^",29)	;LRentFee
 	s PLIST(29) = $p(VAL,"^",30)	;LWorkFee
	 s PLIST(30) = $p(VAL,"^",31)	;LOtherFee
 	s PLIST(31) = $p(VAL,"^",32)	;LSelfOwnFee
	 s PLIST(32) = $p(VAL,"^",33)	;LShareFee
 	s PLIST(33) = $p(VAL,"^",34)	;LSubjectsRecorded
 	s PLIST(34) = $p(VAL,"^",35)	;LUsersrightType
 	s PLIST(35) = $p(VAL,"^",36)	;LOwnershipYear
 	s PLIST(36) = $p(VAL,"^",37)	;LGetFee
 	s PLIST(37) = LSourceType	;LSourceType
 	s PLIST(38) = LSourceID	;LSourceID
 	s PLIST(39) = $p(VAL,"^",40) 	;LUserRightArea
 	s PLIST(40) = $p(VAL,"^",41)	;LRemark
 	//s PLIST(39) = 1
 	//GR0019 end
	 k PLIST(1)
 	 if (LRowID'="") 
 	{
		 &SQL(Update SQLUSER.DHC_EQLand Values :PLIST() where L_RowID = :LRowID) 	 
	 }
 	else
	 {	 
		 &SQL(Insert Into SQLUSER.DHC_EQLand Values :PLIST())
 	}
	 if SQLCODE  q SQLCODE
	 q 0
}

ClassMethod GetLandBySourceID(SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "")
{
	new result,LRowID,Si
	s (result,resultex)=""
	quit:""=SOURCETYPE ""
	quit:""=SOURCEID ""
	i SOURCETYPE=0 Set LRowID = $Order(^DHCEQLand(0,"Source",SOURCETYPE,SOURCEID,-1))
	e  Set LRowID = $Order(^DHCEQLand(0,"Equip",SOURCEID,-1))
	
	//--------------------------DHC_EQLand-------------------------------------------
	s SCount=40
	s result=^DHCEQLand(LRowID)
	s result=LRowID_"^"_result
	Set len=$L(result,"^")					//解决旧数据长度不足SCount大小的问题
	for Si=len:1:SCount-1
	{
		s result=result_"^"
	}
	s $p(result,"^",17)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date")	;CertificateDate
	
	//--------------------------DHC_EQEquip-------------------------------------------
	s EQCount=1
	Set result=result_"^"
	i SOURCETYPE=1	Set result=result_##Class(web.DHCEQCommon).TransValueToPage($p(^DHCEQEquip(SOURCEID),"^",53),"date")  //EQ_AddDate 入账日期
	q result
}

// GR0019 是否有产权

//##class(web.DHCEQLand).OwnerFlagList()

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

//w ##Class(web.DHCEQLand).test(0)

ClassMethod test(para)
{
	i para q para
	else  q -1
}

/*
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(delete from SQLUSER.DHC_EQLand where L_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;Area
 s PLIST(4) = $p(val,"^",4)	;LandNo
 s PLIST(5) = $p(val,"^",5)	;OwnerFlag
 i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")	;OwnerFlag
 s PLIST(6) = $p(val,"^",6)	;Place
 s PLIST(7) = $p(val,"^",7)	;SelfUsedArea
 s PLIST(8) = $p(val,"^",8)	;IdleArea
 s PLIST(9) = $p(val,"^",9)	;LendingArea
 s PLIST(10) = $p(val,"^",10)	;RentArea
 s PLIST(11) = $p(val,"^",11)	;WorkArea
 s PLIST(12) = $p(val,"^",12)	;OtherArea
 s PLIST(13) = $p(val,"^",13)	;LendCompany
 s PLIST(14) = $p(val,"^",14)	;RentCompany
 s PLIST(15) = $p(val,"^",15)	;OwnerCertificate
 s PLIST(16) = $p(val,"^",16)	;CertificateNo
 s PLIST(17) = $p(val,"^",17)	;CertificateDate
 i $p(val,"^",17)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;CertificateDate
 s PLIST(18) = $p(val,"^",18)	;OwnerKind
 s PLIST(19) = $p(val,"^",19)	;CertificateArea
 s PLIST(20) = $p(val,"^",20)	;Hold1
 s PLIST(21) = $p(val,"^",21)	;Hold2
 s PLIST(22) = $p(val,"^",22)	;Hold3
 s PLIST(23) = $p(val,"^",23)	;Hold4
 s PLIST(24) = $p(val,"^",24)	;Hold5
 k PLIST(1)
  if (rowid'="") 
 {
	 &SQL(Update SQLUSER.DHC_EQLand Values :PLIST() where L_RowID = :rowid) 	 
 }
 else
 {	 
	 &SQL(Insert Into SQLUSER.DHC_EQLand Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetLandByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", equipdr As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid="")
	{
		if (equipdr="") q ""
		s rowid=$o(^DHCEQLand(0,"Equip",equipdr,0))
		if rowid="" q ""
	}
	s result= ^DHCEQLand(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"bool")	;OwnerFlag
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;CertificateDate
	q result_resultex
}
*/
}
