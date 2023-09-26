Class web.DHCEQBenefitEquipList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQBenefitEquipList).SaveData(1,1)
ClassMethod SaveData(val As %Library.String = "", del As %String = "")
{
	n rowid,RowidFind,Find
	k PLIST,DMLIST
	s (RowidFind,Find)=""
	s rowid=$p(val,"^",1)
	Set $ZT="ERRORSave"
	TSTART	
	if +del=1
	{
		i (rowid'="")
		{
			s EquipDR=$p($g(^DHCEQBenefitEquipList(rowid)),"^",1)
			&SQL(delete sqluser.DHC_EQBenefitEquipList where BEL_RowID = :rowid)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			&SQL(delete sqluser.DHC_EQDeviceMap where DM_EquipDR = :EquipDR)
			i SQLCODE=100 s SQLCODE=0
		}
	}
	else
	{
		s PLIST(2)=$P(val,"^",2) //EquipDR
		s PLIST(3)=$P(val,"^",3)
		s PLIST(4)=$P(val,"^",4) 
		s PLIST(5)=$P(val,"^",5) 
		s PLIST(6)=$P(val,"^",6) 
		s PLIST(7)=$P(val,"^",7) 
		s PLIST(8)=$P(val,"^",8) 
		s PLIST(9)=$P(val,"^",9) 
		s PLIST(10)=$P(val,"^",10) 
		s PLIST(11)=$P(val,"^",11) 
		s PLIST(12)=$P(val,"^",12) 
		s PLIST(13)=$P(val,"^",13)
		s PLIST(14)=$P(val,"^",14)
		s PLIST(15)=$P(val,"^",15)
		i (rowid="")  //新增按钮操作
		{
			&SQL(Insert Into SQLUSER.DHC_EQBenefitEquipList Values :PLIST())
			Set rowid=$g(%ROWID)
		}
		else  //更新按钮操作
		{
			&SQL(Update SQLUSER.DHC_EQBenefitEquipList Values :PLIST() where BEL_RowID = :rowid) 	 
			i SQLCODE=100 s SQLCODE=0
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s EquipDR=PLIST(2)
		s DeviceSourceType=$P(val,"^",16)
		s DeviceSourceID=$P(val,"^",17)
		s DeviceSource=$P(val,"^",18)
		
		&SQL(select DM_RowID into :RowidFind from SQLUSER.DHC_EQDeviceMap where DM_InvalidFlag<>'Y' and DM_EquipDR=:EquipDR)
	 	&SQL(select DM_RowID into :Find from SQLUSER.DHC_EQDeviceMap where DM_InvalidFlag<>'Y' and DM_DeviceSource=:DeviceSourceType and DM_DeviceID=:DeviceSourceID)
		
		s DMLIST(2)=EquipDR //EquipDR
		s DMLIST(3)=DeviceSourceID //DeviceID
		s DMLIST(4)=DeviceSourceType //DeviceSource
		//s DMLIST(5)="" //Remark
		s DMLIST(12)="N"
		s DMLIST(13)=DeviceSource //DeviceDesc
		i (RowidFind="")&(Find="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQDeviceMap Values :DMLIST())
		}
		else
		{
			i (RowidFind'="")
			{
				&SQL(Update SQLUSER.DHC_EQDeviceMap Values :DMLIST() where DM_RowID = :RowidFind) 	 
			}
		}
		
	}
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE_"^"_rowid
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

ClassMethod DeleteData(RowID)
{
	i (RowID'="")
	{
		&SQL(delete sqluser.DHC_EQBenefitEquipList where BEL_RowID = :RowID)
	}
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitEquipList","GetBenefitEquipList","")
Query GetBenefitEquipList(vEquipDR As %String = "", QXType As %String = "", CLOCID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquip:%String,TInitYear:%String,TPreWorkLoad:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModel:%String,TLeaveFactoryNo:%String,TUseLoc:%String,TOriginalFee:%String,TLimitYearsNum:%String,TStartDate:%String,TTransAssetDate:%String,TNo:%String")
{
}

ClassMethod GetBenefitEquipListExecute(ByRef qHandle As %Binary, vEquipDR As %String = "", QXType As %String = "", CLOCID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	if vEquipDR'=""
	{
		f  s rowid=$o(^DHCEQBenefitEquipList(0,"Equip",vEquipDR,rowid))  quit:rowid=""  d
		.s Datalist=$g(^DHCEQBenefitEquipList(rowid))
		.d BuildBenefitEquipListDate
		
	}
	else
	{
		f  s rowid=$o(^DHCEQBenefitEquipList(rowid))  quit:rowid=""  d
		.s Datalist=$g(^DHCEQBenefitEquipList(rowid))
		.d BuildBenefitEquipListDate
	}
	quit $$$OK
BuildBenefitEquipListDate
    s (TRowID,TEquipDR,TEquip,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)=""
    s (TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo)=""
    s TRowID=rowid
    s TEquipDR=$p(Datalist,"^",1)
    //设备基本信息
    s EquipData=$g(^DHCEQEquip(TEquipDR))
    s TEquip=$p(EquipData,"^",1)
	s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",$p(EquipData,"^",3))
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(EquipData,"^",19))
	q:((QXType=2)&&($p(EquipData,"^",19)'=CLOCID))
	s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"1") 
	s TLimitYearsNum = $p(EquipData,"^",31)
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	s TNo = $p(EquipData,"^",71)
	//
    s TInitYear=$p(Datalist,"^",2)
    s TPreWorkLoad=$p(Datalist,"^",3)
    s TNewFunction=$p(Datalist,"^",4)
    s TSpecialService=$p(Datalist,"^",5)
    s TOtherSocial=$p(Datalist,"^",6)
    s TGraduateNum=$p(Datalist,"^",7)
    s TStaffNum=$p(Datalist,"^",8)
    s TOtherTasks=$p(Datalist,"^",9)
    s THold1=$p(Datalist,"^",10)
    s THold2=$p(Datalist,"^",11)
    s THold3=$p(Datalist,"^",12)
    s THold4=$p(Datalist,"^",13)
    s THold5=$p(Datalist,"^",14) 
	d OutputRowBenefitEquipList	
	quit
OutputRowBenefitEquipList
	s Data=$lb(TRowID,TEquipDR,TEquip,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5,TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipListExecute ]
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

ClassMethod GetBenefitEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQBenefitEquipList).GetOneBenefitEquipList(1)
ClassMethod GetOneBenefitEquipList(rowid As %Library.String = "")
{
	new result,resultex,EquipID,RowidFind
	s (result,resultex,RowidFind)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQBenefitEquipList(rowid))
	if result="" q ""
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1) //Equip
	
	s EquipID=$p(result,"^",1)
	&SQL(select DM_RowID into :RowidFind from SQLUSER.DHC_EQDeviceMap where DM_InvalidFlag<>'Y' and DM_EquipDR=:EquipID)
	s resultex=resultex_"^"	;SouceID
	i RowidFind'=""  d
	.s resultex=resultex_$p($g(^DHCEQDeviceMap(RowidFind)),"^",2) //SouceType
	s resultex=resultex_"^"	;SouceID
	i RowidFind'=""  d
	.s resultex=resultex_$p($g(^DHCEQDeviceMap(RowidFind)),"^",3) //SouceID
	s resultex=resultex_"^"	;SouceID
	i RowidFind'=""  d
	.s resultex=resultex_$p($g(^DHCEQDeviceMap(RowidFind)),"^",6) //Souce
		
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

}
