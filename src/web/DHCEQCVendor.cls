Import SQLUser

Class web.DHCEQCVendor Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod VendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod VendorExecute(ByRef qHandle As %Binary, Code As %String = "", Name As %String = "", ConPerson As %String = "", Tel As %String = "", ShName As %String = "", FirmTypeDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Name=##Class(web.DHCEQCommon).UnEscape(Name)
 	s ConPerson=##Class(web.DHCEQCommon).UnEscape(ConPerson)
 	s Code=$ZCONVERT(Code ,"U")
 	s Name=$ZCONVERT(Name ,"U")
 	s ConPerson=$ZCONVERT(ConPerson ,"U")
 	s Tel=$ZCONVERT(Tel ,"U")
 	s ShName=$ZCONVERT(ShName ,"U")
 	
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetVendor
	Quit $$$OK
BuildDataGetVendor
	f  s rowid=$o(^DHCEQCCode("DHCEQCVendor",rowid))  quit:rowid=""  d
	.d ResetVariablesGetVendor
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode ,"U")'[Code)
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.q:(Name'="")&&($ZCONVERT(TName ,"U")'[Name)
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	.q:(ConPerson'="")&&($ZCONVERT(TContPerson ,"U")'[ConPerson)
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.q:(Tel'="")&&($ZCONVERT(TTel ,"U")'[Tel)
	.s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
	.s TProvince=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",4)
	.s TCity=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",5)
	.s TState=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",6)
	.s TZipCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",7)
	.s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
	.s TShName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",11)
	.q:(ShName'="")&&($ZCONVERT(TShName ,"U")'[ShName)
	.s TGrading=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",12)    //modified by ZY 20220926  2826780
	.s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
	.s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
	.s TRegistrationNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",15)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",16)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",20)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",21)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)	//modified by czf 20200404 begin
	.s THold4=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",23)
	.s THold5=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",24)
	.s flag=0
	.s TFirmTypeDR=""		//modified by czf 20200404 begin
	.f  s TFirmTypeDR=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmDR",rowid,TFirmTypeDR)) q:(TFirmTypeDR="")  d
	..s TFCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmDR",rowid,TFirmTypeDR,""))
	..q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",TFCRowid)),"^",3)="Y"
	..i TFirmType'="" s TFirmType=TFirmType_","
	..s TFirmType=TFirmType_$case(TFirmTypeDR,"2":"供应商","3":"生产厂商","4":"服务商")	//modified by czf 20200404 end
	..i (FirmTypeDR'="")&&((","_FirmTypeDR_",")[(","_TFirmTypeDR_",")) s flag=1
	..s TFCRowid=""
	.q:(FirmTypeDR'="")&&(flag=0)
	.d OutputRowGetVendor
	quit
OutputRowGetVendor
   s Data=$lb(TRowID,TCode,TName,TAddress,TProvince,TCity,TState,TZipCode,TContPerson,TTel,TFax,TBank,TBankNo,TRegistrationNo,TRemark,THold1,THold2,THold3,THold4,THold5,TShName,TRow,TFirmType,TGrading)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetVendor
	s (TRowID,TCode,TName,TAddress,TProvince,TCity,TState,TZipCode,TContPerson,TTel,TFax,TBank,TBankNo,TRegistrationNo,TRemark,THold1,THold2,THold3,THold4,THold5,TShName,TFirmType,TGrading)=""
	quit
}

ClassMethod VendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VendorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
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

// modified by ZY 20220926  2826780   增加例输出

Query Vendor(Code As %String = "", Name As %String = "", ConPerson As %String = "", Tel As %String = "", ShName As %String = "", FirmTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TAddress:%String,TProvince:%String,TCity:%String,TState:%String,TZipCode:%String,TContPerson:%String,TTel:%String,TFax:%String,TBank:%String,TBankNo:%String,TRegistrationNo:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TShName:%String,TRow:%String,TFirmType:%String,TGrading:%String")
{
}

/**********************************************************************************/
ClassMethod GetVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modify by lmm 2019-08-22 增加入参 
ClassMethod GetVendorExecute(ByRef qHandle As %Binary, Provider As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Provider=##Class(web.DHCEQCommon).UnEscape(Provider)
 	s Provider=$ZCONVERT(Provider ,"U")
 	
 	s FirmType="2"	//add by CZF00093 2020-03-17 公司类型 2:供应商
	s index=1
	s rowid=0
	d BuildDataGetVendorInfo
	Quit $$$OK
BuildDataGetVendorInfo
	s rowid=""		//modified by czf 20200404 begin
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.d ResetVariablesGetVendorInfo
	.s TRowID = rowid	//rowid
	.q:(ProviderDR'="")&&(TRowID'=ProviderDR)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.s TShName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",11)
	.q:(Provider'="")&&($ZCONVERT(TCode ,"U")'[Provider)&&($ZCONVERT(TName ,"U")'[Provider)&&($ZCONVERT(TShName ,"U")'[Provider)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)			//modified by czf 20200404 end
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)	
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
	.s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
	.s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
	.s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
	.//modified by ZY 20220926  2826780
	.s THold5=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",24)
	.q:(THold5="Y")&&(##class(web.DHCEQCommon).GetSysInfo("990016")=2)
	.d OutputRowGetVendorInfo
	quit
OutputRowGetVendorInfo
   s Data=$lb(TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetVendorInfo
	s (TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName,THold5)=""
	quit
}

ClassMethod GetVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
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

// modified by ZY 20220926  2826780   增加例输出

Query GetVendor(Provider As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,Hidden:%String,TCode:%String:编码,TAddress:%String:地址,TContPerson:%String:联系人,TTel:%String:电话,TFax:%String:传真,TBank:%String:银行,TBankNo:%String:银行卡号,TShName:%String:简称,THold5:%String") [ SqlProc ]
{
}

/**********************************************************************************/
/// w ##Class(web.DHCEQCVendor).SaveData("365^WZGYGS^万照供应公司^^^^^^白冰^18735672380^3672312^WZGYGS^^招商Bank^^^^^111111^^^^^2","")
/// modified by sjh SJH0038 2020-11-10 增加数据修改日志记录
/// Add By QW2021 bug号:QW00 增加参数CurUser
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "", CurUser As %Library.String = "")
{
	k PLIST,rowid
	s $zt="ErrorSave"
	s rowid=$p(val,"^",1)
	s TableName="DHC_EQCVendor"
	s ClassName="User.DHCEQCVendor"
	if CurUser="" s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	// Add By QW2021 bug号:QW00 增加参数CurUser
	s BussID=rowid	
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New() 
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New() 
	s PLIST(2) = $ZCONVERT($p(val,"^",2),"U") ;Code //2011-10-26 DJ DJ0097
  	s PLIST(3) = $p(val,"^",3) ;Name
	s Name=$p(val,"^",3)
	s PLIST(4) = $p(val,"^",4) ;Address
	s PLIST(5) = $p(val,"^",5) ;Province
	s PLIST(6) = $p(val,"^",6) ;City
	s PLIST(7) = $p(val,"^",7) ;State
	s PLIST(8) = $p(val,"^",8) ;ZipCode
	s PLIST(9) = $p(val,"^",9) ;ConPerson
	s PLIST(10) = $p(val,"^",10) ;Tel
	s PLIST(11) = $p(val,"^",11) ;Fax
	s PLIST(12) = $p(val,"^",12) ;ShName
	s PLIST(13) = $p(val,"^",13) ;Grading
	s PLIST(14) = $p(val,"^",14) ;Bank
	s PLIST(15) = $p(val,"^",15) ;BankNo
	s PLIST(16) = $p(val,"^",16) ;RegistrationNo
	s PLIST(17) = $p(val,"^",17) ;Remark
	s PLIST(19) = $p(val,"^",23)	;ExDesc
	s PLIST(20) = "N"
	s PLIST(21) =$p(val,"^",18)	;Hold1
	s PLIST(22) =$p(val,"^",19)	;Hold2	
	//s PLIST(23) =$p(val,"^",20)	;Hold3
	s PLIST(24) =$p(val,"^",21)	;Hold4
    ///modified by ZY 20221107 2995582
    s PLIST(25) =##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool") ;Hold5

	s flag=0		//modified by czf 2020-04-01 1254647 begin
	s FirmTypes=$p(val,"^",24)
	s FirmLen=$l(FirmTypes,",")
	
	TStart
	
	i (+isDel=1)
	{
		s OldObject=##Class(User.DHCEQCVendor).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		s PLIST(20)="Y"
	 	&SQL(Update SQLUSER.DHC_EQCVendor set V_InvalidFlag='Y' where V_RowID = :rowid) 
	 	i SQLCODE
		{
			TRollBack
			q SQLCODE
		}
		s VRowID=rowid
		//add by wy 2021-5-31 三商删除时无效三商的联系人 1959094
		s SourceType=5
	 	&SQL(Update SQLUSER.DHC_EQPCContactPerson set CI_InvalidFlag='Y' where CI_SourceID = :rowid and CI_SourceType=:SourceType)
	 	i SQLCODE
		{
			TRollBack
			q SQLCODE
		}
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""VInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
		Q VRowID
	}
	else
	{
		s PLIST(23)=FirmTypes
		&SQL(select V_RowID into :Rowid from DHC_EQCVendor where V_Name=:Name and V_InvalidFlag='N')
		if (Rowid = "")
		{
			if (rowid="")
			{
				Set BussID="",OperateType="A"
				Set PLIST(20) ="N"
				&SQL(Insert Into SQLUSER.DHC_EQCVendor Values :PLIST())
			}
			else
			{
				Set BussID=rowid,OperateType="U"
				s OldObject=##Class(User.DHCEQCVendor).%OpenId(BussID)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(Update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID = :rowid)
			}
		}
		else
		{
			Set BussID=Rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCVendor).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)			
			q:rowid="" -3002
			if (rowid'="")&&(rowid'=Rowid) q -3001 //重复的记录
			&SQL(Update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID = :rowid)		
		}
		
		i SQLCODE
		{
			TRollBack
			q SQLCODE
		}
		s VRowID=$g(%ROWID)
		//Modified By QW20210702 BUG:QW0134 begin
		s PersonName=$p(val,"^",9)
		if (PersonName'="")
		{
			s CPRowid=""
	  		&SQL(select CI_RowID into :CPRowid from SQLUSER.DHC_EQPCContactPerson where CI_SourceType='5' and CI_SourceID=:VRowID  and CI_Name=:PersonName  and CI_InvalidFlag='N')
			s val=CPRowid_"^5^"_VRowID_"^1^"_PersonName_"^^^"_$p(val,"^",10)_"^^"_$p(val,"^",19)_"^"_PLIST(11)_"^^^^"_PLIST(4)_"^^^^^^^^^^"
	        s SQLCODE=##class(web.DHCEQPCContactPerson).SaveData(val,"0")
	        i SQLCODE>0 s SQLCODE=0
			i SQLCODE
			{
				TRollBack
				q SQLCODE
			}
		}
		//Modified By QW20210702 BUG:QW0134 end
	}
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCVendor).%OpenId(VRowID))
	
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=VRowID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	
	;保存至公司对照表
	s flag=..SaveFirmContrast(FirmTypes,VRowID,isDel)
	i flag
	{
		TRollBack
		q flag
	}
	
	TCommit
	q VRowID		//modified by CZF0093 2020-03-17 end
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;		//modified by CZF0070 2020-02-28 end
}

/// Creator:add by czf 20200403
/// Description:保存公司对照信息
/// Input:cFirmTypes:公司类型串
/// 		 cVrowid:供应商ID
/// OutPut:0:成功
/// w ##Class(web.DHCEQCVendor).SaveFirmContrast("2,3","1921","")
ClassMethod SaveFirmContrast(cFirmTypes, cVrowid, cIsDel)
{
	n FirmType,flag
	s FirmType=""
	s flag=0
	i cVrowid="" q -3003 			//rowid不能为空
	i (cIsDel=1)
	{
		&SQL(Update SQLUSER.DHC_EQCFirmContrast set FC_InvalidFlag = 'Y' where FC_FirmDR=:cVrowid)
		i SQLCODE q SQLCODE
		q 0
	}
	
	i cFirmTypes="" q -3002 	//公司类型不能为空
	s FirmTypeLen=$l(cFirmTypes,",")
	

	//本次更新对照表中多余的公司类型记录置为无效
	s FirmTypeID=""
	f  s FirmTypeID=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmDR",cVrowid,FirmTypeID)) q:FirmTypeID=""  d
	.s FCID=""
	.q:(","_cFirmTypes_",")[(","_FirmTypeID_",")
	.f  s FCID=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmDR",cVrowid,FirmTypeID,FCID)) q:FCID=""  d
	..&SQL(Update SQLUSER.DHC_EQCFirmContrast set FC_InvalidFlag = 'Y' where FC_RowID=:FCID)
	..i SQLCODE s flag=SQLCODE
	..i flag=100 s flag=0
	..q:flag'=0
	
	i flag q flag
	
	k FCPLIST
	f i=1:1:FirmTypeLen
	{
 		s FirmType=$p(cFirmTypes,",",i)
		s:FirmType="" flag=-3002		//公司类型不能为空
		q:flag'=0
		s FCPLIST(2)=FirmType 
		s FCPLIST(3)=cVrowid		// MZY0059	1571977		2020-10-26	修正引用参数
		s FCPLIST(4)= "N"
		i '$d(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,cVrowid))
		{
			&SQL(Insert Into SQLUSER.DHC_EQCFirmContrast Values :FCPLIST())
			i SQLCODE s flag=SQLCODE
		}
		else
		{
			s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,cVrowid,""))
			&SQL(update SQLUSER.DHC_EQCFirmContrast Values :FCPLIST() where FC_RowID=:FCRowid)
			i SQLCODE s flag=SQLCODE
		}
		q:flag'=0
	}
	
	q flag
}

ClassMethod GetVendorInfo(rowid As %Library.String = "")
{
	i rowid="" q ""
	new result
	s result= $g(^DHCEQCCode("DHCEQCVendor",rowid))
	q result
}

/// add by zy 2014-4-28 ZY0125
/// 判断当前供应商是否在其他院区中用到
/// w ##Class(web.DHCEQCVendor).CheckVendorUsed(1)
ClassMethod CheckVendorUsed(ProviderID)
{
	new EquipID,LocID,HospitalDR,CurHospitalDR,Flag
	i ProviderID="" quit 0
	s (LocID,HospitalDR,CurHospitalDR)=""
	s (EquipID,Flag)=0
	f  s EquipID=$o(^DHCEQEquip(0,"Provider",ProviderID,EquipID)) quit:(EquipID="")||(Flag'=0)  d
	.s LocID=$p($g(^DHCEQEquip(EquipID)),"^",67)
	.;i LocID'="" s HospitalDR=$p($g(^CTLOC(LocID)),"^",22)  //modify by jyp 2019-10-18 CTLOC调整
	.i LocID'="" s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocID)   //modify by jyp 2019-10-18 CTLOC调整
	.i CurHospitalDR="" s CurHospitalDR=HospitalDR
	.i CurHospitalDR'=HospitalDR s Flag=1
	quit Flag
}

/// 创建：add by CZF0093 2020-03-17 
/// 描述：公司类型列表
ClassMethod FirmTypeList(name, width As %String = "", promtinfo As %String = "") As %String
{
	//if (width="")||(width=0) s width=155
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;'>" 
    w ##class(web.DHCEQCommon).GetDefaultStyle(name,width,promtinfo)     //modified by myl  1805643  20210317
	w "</select>",!
}

}
