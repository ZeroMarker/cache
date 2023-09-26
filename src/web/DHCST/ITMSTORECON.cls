Import sqluser

/// Descript:药品存储条件相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
Class web.DHCST.ITMSTORECON Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:rowid,常温^干燥^密闭^避光^通风^防辐射^熔封^阴凉^凉暗^密封^冷藏
/// ^最低温^最高温^最低湿度^最高湿度.
/// Output:
/// Return：rowid,成功;
/// -11:保存失败; -12:关联库存附加表失败(insert时)
ClassMethod Save(Rowid As %String, ListData As %String, IncRowid As %String) As %Library.String
{
	//s ^zdm("web.DHCST.ITMSTORECON.Save")=Rowid_"^"_ListData
	n (Rowid,ListData,IncRowid)
	q:ListData="" 0
	i Rowid="" d
	.s ret=..Insert(ListData,IncRowid)
	.i +ret>0  d
	..s Rowid=ret
	e  d
	.s ret=..Update(Rowid,ListData)
	.
	q:+ret<0 ret
	q Rowid
}

/// Descript:	保存存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:常温^干燥^密闭^避光^通风^防辐射^熔封^阴凉^凉暗^密封^冷藏
/// ^最低温^最高温^最低湿度^最高湿度.
/// Output:
/// Return：0,成功;
/// -11:保存失败; -12:存储条件关联库存项失败
ClassMethod Insert(ListData As %String, IncRowid As %String) As %Library.String
{
	
	n (ListData,IncRowid)
	q:ListData="" 0
	q:IncRowid="" -12
	s CommonTemp=$p(ListData,"^",1)   	;是否常温保存
	s Dry=$p(ListData,"^",2)   			;是否干燥
	s AirTight=$p(ListData,"^",3)   	;是否密闭
	s Dark=$p(ListData,"^",4)   		;是否避光
	s Ventilate=$p(ListData,"^",5)   	;通风
	s Radiation=$p(ListData,"^",6)   	;防辐射
	s MeltPack=$p(ListData,"^",7)   	;熔封
	s GloomyCool=$p(ListData,"^",8)   	;阴凉
	s CoolGloomy=$p(ListData,"^",9)   	;凉暗
	s Seal=$p(ListData,"^",10)   		;密封
	s COLDST=$p(ListData,"^",11)   		;冷藏
	s MinTemp=$p(ListData,"^",12)   	;最低温
	s MaxTemp=$p(ListData,"^",13)   	;最高温
	s MinHumidity=$p(ListData,"^",14)   	;最低湿度
	s MaxHumidity=$p(ListData,"^",15)   	;最高湿度
	s Err=0
	tstart
	;保存存储条件
	&sql(INSERT INTO DHC_ItmStoreCond (ISC_CommonTemp,ISC_MinTemp,ISC_MaxTemp,ISC_Dry,
	ISC_MinHumidity,ISC_MaxHumidity,ISC_Airtight,ISC_Dark,ISC_Ventilate,ISC_Radiation,
	ISC_COLDST,ISC_MeltPack,ISC_GloomyCool,ISC_CoolGloomy,ISC_Seal) 
	VALUES (:CommonTemp,:MinTemp,:MaxTemp,:Dry,:MinHumidity,:MaxHumidity,:AirTight,
	:Dark,:Ventilate,:Radiation,:COLDST,:MeltPack,:GloomyCool,:CoolGloomy,:Seal))
	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_ItmStoreCond","",SQLCODE_":"_%msg)
 	.s Err=-11
 	.
 	q:Err'=0 Err
 	s conId=$p(%ROWID,$c(1))
 	s itmAddId=$o(^DHCITMINFO(0,"INCI",IncRowid,0))
 	//附加表记录不存在时的处理(zhwh 2013-06-27add)
 	i itmAddId="" d  //
 	.&sql(insert into dhc_itmaddioninfo(info_inci_dr) values (:IncRowid))
 	.i SQLCODE'=0 d
 	..s Err=-20
 	.e  d
 	..s itmAddId=$p(%ROWID,$c(1))
 	q:Err'=0 Err
 	// 	
 	&sql(UPDATE DHC_ItmAddionInfo SET INFO_ISC_DR=:conId where INFO_RowID=:itmAddId)
	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("UPDATE:DHC_ItmAddionInfo","",SQLCODE_":"_%msg)
 	.s Err=-12
 	q:Err'=0 Err
 	tcommit
 	
 	q conId
}

/// Descript:	更新存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:常温^干燥^密闭^避光^通风^防辐射^熔封^阴凉^凉暗^密封^冷藏
/// ^最低温^最高温^最低湿度^最高湿度.
/// Output:
/// Return：0,成功;
/// -11:保存失败
/// -1:id不能为空
/// 
ClassMethod Update(Rowid As %String, ListData As %String) As %Library.String
{
	
	n (Rowid,ListData)
	q:Rowid="" -1
	q:ListData="" 0
	s CommonTemp=$p(ListData,"^",1)   	;是否常温保存
	s Dry=$p(ListData,"^",2)   			;是否干燥
	s AirTight=$p(ListData,"^",3)   	;是否密闭
	s Dark=$p(ListData,"^",4)   		;是否避光
	s Ventilate=$p(ListData,"^",5)   	;通风
	s Radiation=$p(ListData,"^",6)   	;防辐射
	s MeltPack=$p(ListData,"^",7)   	;熔封
	s GloomyCool=$p(ListData,"^",8)   	;阴凉
	s CoolGloomy=$p(ListData,"^",9)   	;凉暗
	s Seal=$p(ListData,"^",10)   		;密封
	s COLDST=$p(ListData,"^",11)   		;冷藏
	s MinTemp=$p(ListData,"^",12)   	;最低温
	s MaxTemp=$p(ListData,"^",13)   	;最高温
	s MinHumidity=$p(ListData,"^",14)   	;最低湿度
	s MaxHumidity=$p(ListData,"^",15)   	;最高湿度
	s Err=0
	;更新存储条件
	&sql(Update DHC_ItmStoreCond set ISC_CommonTemp=:CommonTemp,ISC_MinTemp=:MinTemp,
	ISC_MaxTemp=:MaxTemp,ISC_Dry=:Dry,ISC_MinHumidity=:MinHumidity,	ISC_MaxHumidity=:MaxHumidity,
	ISC_Airtight=:AirTight,ISC_Dark=:Dark,	ISC_Ventilate=:Ventilate,ISC_Radiation=:Radiation,
	ISC_COLDST=:COLDST,	ISC_MeltPack=:MeltPack,ISC_GloomyCool=:GloomyCool,
	ISC_CoolGloomy=:CoolGloomy,ISC_Seal=:Seal where ISC_Rowid=:Rowid) 
	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_ItmStoreCond",Rowid,SQLCODE_":"_%msg)
 	.s Err=-11
 	.
 	q:Err'=0 Err
 	q 0
}

/*
ClassMethod Delete(Rowid As %String) As %Library.String
{
	
	n (Rowid)
	q:Rowid="" -1
	s Err=0
	;删除存储条件
	&sql(Delete from DHC_ItmStoreCond where ISC_Rowid=:Rowid) 
	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Delete:DHC_ItmStoreCond",Rowid,SQLCODE_":"_%msg)
 	.s Err=-11
 	.
 	q:Err'=0 Err
 	q 0
}
*/
/// Descript:	删除存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:rowid
/// Output:
/// Return：0,成功;
/// -11:删除失败
/// -1:id不能为空
/// 
/// Descript:	查询库存项存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:库存项id
/// Output:
/// Return：rowid^常温^干燥^密闭^避光^通风^防辐射^熔封^阴凉^凉暗^密封^冷藏
/// ^最低温^最高温^最低湿度^最高湿度.
ClassMethod Select(IncId As %String) As %Library.String
{
	n (IncId)
	q:IncId="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
	q:Info="" ""
	q:'$d(^DHCITMINFO(Info)) ""
	s ISC=$p(^DHCITMINFO(Info),"^",28)
	q:ISC="" ""
	q:'$d(^DHCItemSC(ISC)) ""
	s CommonTemp=$p(^DHCItemSC(ISC),"^",1)    	;常温
	s MinTemp=$p(^DHCItemSC(ISC),"^",2)			;最低温度
	s MaxTemp=$p(^DHCItemSC(ISC),"^",3)			;最高温度
	s Dry=$p(^DHCItemSC(ISC),"^",4)				;干燥
	s MinHumidity=$p(^DHCItemSC(ISC),"^",5)		;最低湿度
	s MaxHumidity=$p(^DHCItemSC(ISC),"^",6)		;最高湿度
	s Ventilate=$p(^DHCItemSC(ISC),"^",7)		;通风
	s Airtight=$p(^DHCItemSC(ISC),"^",8)		;密闭
	s Dark=$p(^DHCItemSC(ISC),"^",9)			;避光
	s Radiation=$p(^DHCItemSC(ISC),"^",10)		;防辐射
	s COLDST=$p(^DHCItemSC(ISC),"^",11)			;冷藏
	s MeltPack=$p(^DHCItemSC(ISC),"^",12)		;熔封
	s GloomyCool=$p(^DHCItemSC(ISC),"^",13)		;阴凉	
	s CoolGloomy=$p(^DHCItemSC(ISC),"^",14)		;凉暗
	s Seal=$p(^DHCItemSC(ISC),"^",15)			;密封
	;
	s Data1=ISC_"^"_CommonTemp_"^"_Dry_"^"_Airtight_"^"_Dark_"^"_Ventilate_"^"_Radiation
	s Data2=MeltPack_"^"_GloomyCool_"^"_CoolGloomy_"^"_Seal_"^"_COLDST_"^"_MinTemp
	s Data3=MaxTemp_"^"_MinHumidity_"^"_MaxHumidity
	s Data=Data1_"^"_Data2_"^"_Data3
	q Data
}

}
