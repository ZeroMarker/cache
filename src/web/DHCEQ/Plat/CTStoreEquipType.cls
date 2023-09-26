/// 名称: web.DHCEQ.Plat.CTStoreEquipType
/// 描述: DHC_EQStoreEquipType
/// 编写者：WY
/// 编写日期: 2020-10-16
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTStoreEquipType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      WY
/// CreatDate：    2020-10-16
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale  Type:操作类型：（1：删除）,（2：新增,保存）
/// Return：       ID或SQLCODE
/// d ##Class(web.DHCEQ.Plat.CTStoreEquipType).SaveData("{""LELStoreLocDR_CTLOCDesc"":""医疗设备科"",""LELEquipTypeDR_ETDesc"":""专用设备"",""LELStoreLocDR"":""202"",""LELEquipTypeDR"":""3""}",2)
ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORInStock"
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s RowID = JsonData.LELRowID
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQCStoreEquipType set LEL_InvalidFlag='Y' where LEL_RowID=:RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCStoreEquipType",JsonData,.PLIST)
	 	s PLIST(2) = JsonData.LELStoreLocDR					
	 	s PLIST(3) = JsonData.LELEquipTypeDR
	 	s PLIST(6)="N"
	 	s Flag=JsonData.LELFlag
		if (Flag="true")
		{
			s PLIST(7)="Y"	
		}else{
			s PLIST(7)="N"
		}
	 	s RowID = JsonData.LELRowID
    	if RowID'=""
    	{
	 		&SQL(select LEL_RowID into :tmpid from sqluser.DHC_EQCStoreEquipType where LEL_StoreLocDR=:PLIST(2) and LEL_EquipTypeDR=:PLIST(3) and LEL_InvalidFlag='N' and LEL_Flag=:PLIST(7) )    //add by wy 2021-5-31 1945609
			if tmpid=RowID Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该数据已存在!")	 		
	 		&SQL(select LEL_RowID into :tmpid from sqluser.DHC_EQCStoreEquipType where LEL_StoreLocDR=:PLIST(2) and LEL_Flag='Y' and LEL_InvalidFlag='N' )	 		
			if (tmpid'="")&&(tmpid'=RowID)&&(PLIST(7)="Y") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "已存在默认访问!")
			&SQL(Update SQLUSER.DHC_EQCStoreEquipType Values :PLIST() where LEL_RowID = :RowID)
		}
		else
		{
	 		&SQL(select LEL_RowID into :tmpid from sqluser.DHC_EQCStoreEquipType where LEL_StoreLocDR=:PLIST(2) and LEL_EquipTypeDR=:PLIST(3) and LEL_InvalidFlag='N' )
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该数据已存在!")
	 		&SQL(select LEL_RowID into :tmpid from sqluser.DHC_EQCStoreEquipType where LEL_StoreLocDR=:PLIST(2) and LEL_Flag='Y' and LEL_InvalidFlag='N' )	 		
			if (tmpid'="")&&(PLIST(7)="Y") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "已存在默认访问!")
		 	&SQL(insert into sqluser.DHC_EQCStoreEquipType values :PLIST())
		}
		s RowID=$Get(%ROWID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORInStock
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      WY
/// CreatDate：    2020-10-16
/// Description:   界面查询库房可访问类组
/// Input：        StoreLocDR库房ID，EquipTypeDR类组ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTStoreEquipType","GetStoreEquipType","","","")
Query GetStoreEquipType(StoreLocDR As %String = "", EquipTypeDR As %String = "", Flag As %String = "") As %Query(ROWSPEC = "TLELRowID:%String,TLELStoreLocDR:%String,TLELStoreLoc:%String,TLELEquipTypeDR:%String,TLELEquipType:%String,TLELStatCatDR:%String,TLELStatCat:%String,TLELRemark:%String,TLELFlagDR:%String,TLELFlag:%String,TLELHold1:%String,TLELHold2:%String,TLELHold3:%String,TLELHold4:%String,TLELHold5:%String")
{
}

ClassMethod GetStoreEquipTypeExecute(ByRef qHandle As %Binary, StoreLocDR As %String = "", EquipTypeDR As %String = "", Flag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCStoreEquipType",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",5)="Y")
	.d ResetVariablesGetStoreEquipType
	.s TLELRowID = rowid
	.s TLELStoreLocDR = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",1)
	.q:(StoreLocDR'="")&&(StoreLocDR'=TLELStoreLocDR)
	.i TLELStoreLocDR'="" s TLELStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLELStoreLocDR)
	.s TLELEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",2)
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TLELEquipTypeDR)
	.i TLELEquipTypeDR'="" s TLELEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TLELEquipTypeDR)
	.s TLELStatCatDR = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",3)
	.i TLELStatCatDR'="" s TLELStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TLELStatCatDR)
	.s TLELRemark = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",4)
	.s TLELFlagDR= $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",6)
	.q:(Flag'="")&&(Flag'=TLELFlagDR)
	.s TLELFlag =$CASE(TLELFlagDR,"N":"否", "Y":"是","":"不需处理")
	.s TLELHold1 = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",7)
	.s TLELHold2 = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",8)
	.s TLELHold3 = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",9)
	.s TLELHold4 = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",10)
	.s TLELHold5 = $p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",11)
	.d OutputRowGetStoreEquipType	
	Quit $$$OK
OutputRowGetStoreEquipType
	Set TRow=TRow+1
	Set Data=$lb(TLELRowID,TLELStoreLocDR,TLELStoreLoc,TLELEquipTypeDR,TLELEquipType,TLELStatCatDR,TLELStatCat,TLELRemark,TLELFlagDR,TLELFlag,TLELHold1,TLELHold2,TLELHold3,TLELHold4,TLELHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetStoreEquipType
	Set (TLELRowID,TLELStoreLocDR,TLELEquipTypeDR,TLELStatCatDR,TLELRemark,TLELFlagDR,TLELFlag,TLELHold1,TLELHold2,TLELHold3,TLELHold4,TLELHold5)=""
	quit
}

ClassMethod GetStoreEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreEquipTypeExecute ]
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

ClassMethod GetStoreEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      WY
/// CreatDate：    2020-11-26
/// Description:   跟据类组返回可访问库房默认值
/// Input：        StoreLocDR库房ID，EquipTypeDR类组ID
/// w ##Class(web.DHCEQ.Plat.CTStoreEquipType).GetStoreLoc("1")
ClassMethod GetStoreLoc(EquipTypeDR As %Library.String = "")
{
	new StoreLoc
	s result=""
	s Defaultresult=""
	i EquipTypeDR="" q ""
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCStoreEquipType",0,"EquipType",EquipTypeDR,StoreLocDR)) quit:StoreLocDR=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCStoreEquipType",0,"EquipType",EquipTypeDR,StoreLocDR,rowid)) quit:rowid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",5)="Y")
    ..s Flag=$p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",6)
	..s StoreLocDR=$p($g(^DHCEQCCode("DHCEQCStoreEquipType",rowid)),"^",1)
	..i StoreLocDR'="" s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
    ..if (Flag="Y")  s Defaultresult=StoreLocDR_"^"_StoreLoc
    ..q:Flag="Y" 
	..i result'="" Set result=result_"^"
	..s result=result_StoreLocDR_"^"_StoreLoc
	if Defaultresult'="" q Defaultresult_"^"_result
	quit result
}

/// Creator：      WY
/// CreatDate：    2021-3-23
/// Description:   检测库房可访问类组
/// Input：        StoreLocDR库房ID，EquipTypeDR类组ID
/// output:        Flag 0相符 1不符
/// w ##Class(web.DHCEQ.Plat.CTStoreEquipType).CheckEquipTypeByStoreLocDR("202","")
ClassMethod CheckEquipTypeByStoreLocDR(StoreLocDR As %String = "", EquipTypeDR As %String = "")
{
	n LELRowID,FindFlag,Flag
	s Flag=0
	if (StoreLocDR="")||(EquipTypeDR="") q Flag
	s Info=##class(web.DHCEQCommon).GetSysInfo("309003")
	if (Info=1)
	{
		s FindFlag=0	//czf 2021-06-17 1969255 原方式未过滤无效数据
		s LELRowID=0
		f  s LELRowID=$o(^DHCEQCCode("DHCEQCStoreEquipType",0,"EquipType",EquipTypeDR,StoreLocDR,LELRowID)) q:(LELRowID="")||(FindFlag=1)  d
		.q:$p($g(^DHCEQCCode("DHCEQCStoreEquipType",LELRowID)),"^",5)="Y"
		.s FindFlag=1
		i FindFlag=0 s Flag=1
	}
	q Flag
}

}
