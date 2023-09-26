Import sqluser

/// Descript:药品存储条件相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
Class web.DHCSTMHUI.ITMSTORECON Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
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
ClassMethod Save(Inci As %String, ListData As %String) As %Library.String
{
	n (Inci,ListData)
	s $ZT=..sssError()
	s ^tmpxu=ListData
	ts
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Rowid=PJObj.%Get("ISC")
	i Rowid="" d
	.s RtnObj=..Insert(ListData,Inci)
	e  d
	.s RtnObj=..Update(ListData)
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
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
ClassMethod Insert(ListData As %String, IncRowid As %String) As RtnObj
{
	
	n (ListData,IncRowid)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Rowid=PJObj.%Get("ISC")
	s CommonTemp=PJObj.%Get("CommonTemp")   	;是否常温保存
	s Dry=PJObj.%Get("Dry") 					;是否干燥
	s AirTight=PJObj.%Get("AirTight")    		;是否密闭
	s Dark=PJObj.%Get("Dark")  					;是否避光
	s Ventilate=PJObj.%Get("Ventilate")	    	;通风
	s Radiation=PJObj.%Get("Radiation")	    	;防辐射
	s MeltPack=PJObj.%Get("MeltPack")    		;熔封
	s GloomyCool=PJObj.%Get("GloomyCool")    	;阴凉
	s CoolGloomy=PJObj.%Get("CoolGloomy")    	;凉暗
	s Seal=PJObj.%Get("Seal")			  		;密封
	s COLDST=PJObj.%Get("ColDst")  		  		;冷藏
	s MinTemp=PJObj.%Get("MinTemp") 		   	;最低温
	s MaxTemp=PJObj.%Get("MaxTemp")		    	;最高温
	s MinHumidity=PJObj.%Get("MinHumidity")    	;最低湿度
	s MaxHumidity=PJObj.%Get("MaxHumidity")    	;最高湿度
	s Freeze=PJObj.%Get("Freeze")	    		;冷冻
	s DampProof=PJObj.%Get("DampProof")    		;防潮
	;保存存储条件
	&sql(INSERT INTO DHC_ItmStoreCond (ISC_CommonTemp,ISC_MinTemp,ISC_MaxTemp,ISC_Dry,
	ISC_MinHumidity,ISC_MaxHumidity,ISC_Airtight,ISC_Dark,ISC_Ventilate,ISC_Radiation,
	ISC_COLDST,ISC_MeltPack,ISC_GloomyCool,ISC_CoolGloomy,ISC_Seal,ISC_FREEZE,ISC_DAMPPROOF) 
	VALUES (:CommonTemp,:MinTemp,:MaxTemp,:Dry,:MinHumidity,:MaxHumidity,:AirTight,
	:Dark,:Ventilate,:Radiation,:COLDST,:MeltPack,:GloomyCool,:CoolGloomy,:Seal,:Freeze,:DampProof))
	i SQLCODE'=0  d
 	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	q:RtnObj.success'=0 RtnObj
 	s conId=$p(%ROWID,$c(1))
 	s itmAddId=$o(^DHCITMINFO(0,"INCI",IncRowid,0))
 	//附加表记录不存在时的处理(zhwh 2013-06-27add)
 	i itmAddId="" d  //
 	.&sql(insert into dhc_itmaddioninfo(info_inci_dr) values (:IncRowid))
 	.i SQLCODE'=0 d
 	..d RtnObj.Err(-1,"","插入失败!")
 	.e  d
 	..s itmAddId=$p(%ROWID,$c(1))
 	q:RtnObj.success'=0 RtnObj
 	&sql(UPDATE DHC_ItmAddionInfo SET INFO_ISC_DR=:conId where INFO_RowID=:itmAddId)
	i SQLCODE'=0  d
 	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	q:RtnObj.success'=0 RtnObj
 	
 	q RtnObj
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
ClassMethod Update(ListData As %String) As RtnObj
{
	
	n (ListData)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Rowid=PJObj.%Get("ISC")
	s CommonTemp=PJObj.%Get("CommonTemp")   	;是否常温保存
	s Dry=PJObj.%Get("Dry") 					;是否干燥
	s AirTight=PJObj.%Get("AirTight")    		;是否密闭
	s Dark=PJObj.%Get("Dark")  					;是否避光
	s Ventilate=PJObj.%Get("Ventilate")	    	;通风
	s Radiation=PJObj.%Get("Radiation")	    	;防辐射
	s MeltPack=PJObj.%Get("MeltPack")    		;熔封
	s GloomyCool=PJObj.%Get("GloomyCool")    	;阴凉
	s CoolGloomy=PJObj.%Get("CoolGloomy")    	;凉暗
	s Seal=PJObj.%Get("Seal")			  		;密封
	s COLDST=PJObj.%Get("ColDst")  		  		;冷藏
	s MinTemp=PJObj.%Get("MinTemp") 		   	;最低温
	s MaxTemp=PJObj.%Get("MaxTemp")		    	;最高温
	s MinHumidity=PJObj.%Get("MinHumidity")    	;最低湿度
	s MaxHumidity=PJObj.%Get("MaxHumidity")    	;最高湿度
	s Freeze=PJObj.%Get("Freeze")	    		;冷冻
	s DampProof=PJObj.%Get("DampProof")    		;防潮

	;更新存储条件
	&sql(Update DHC_ItmStoreCond set ISC_CommonTemp=:CommonTemp,ISC_MinTemp=:MinTemp,
	ISC_MaxTemp=:MaxTemp,ISC_Dry=:Dry,ISC_MinHumidity=:MinHumidity,	ISC_MaxHumidity=:MaxHumidity,
	ISC_Airtight=:AirTight,ISC_Dark=:Dark,	ISC_Ventilate=:Ventilate,ISC_Radiation=:Radiation,
	ISC_COLDST=:COLDST,	ISC_MeltPack=:MeltPack,ISC_GloomyCool=:GloomyCool,
	ISC_CoolGloomy=:CoolGloomy,ISC_Seal=:Seal,ISC_FREEZE=:Freeze,ISC_DAMPPROOF=:DampProof where ISC_Rowid=:Rowid) 
	i SQLCODE'=0  d
 	.d RtnObj.Err(-1,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	q:RtnObj.success'=0 RtnObj
 	
 	q RtnObj
}

/// Descript:	查询库存项存储条件
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-18
/// Table:DHC_ItmStoreCond
/// Input:库存项id
/// Output:
/// Return：rowid^常温^干燥^密闭^避光^通风^防辐射^熔封^阴凉^凉暗^密封^冷藏
/// ^最低温^最高温^最低湿度^最高湿度.
/// w ##class(web.DHCSTMHUI.ITMSTORECON).Select(2)
ClassMethod Select(Inci As %String) As %Library.String
{
	n (Inci)
	;s ^tmpzx(23)=Inci
	s Ret="{}"
	q:Inci="" Ret
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	q:Info="" Ret
	q:'$d(^DHCITMINFO(Info)) Ret
	s ISC=$p(^DHCITMINFO(Info),"^",28)
	q:ISC="" Ret
	q:'$d(^DHCItemSC(ISC)) Ret
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
	s Freeze=$p(^DHCItemSC(ISC),"^",16)			;冷冻
	s DampProof=$p(^DHCItemSC(ISC),"^",17)			;防潮

	s Data1=ISC_"^"_CommonTemp_"^"_Dry_"^"_Airtight_"^"_Dark_"^"_Ventilate_"^"_Radiation
	s Data2=MeltPack_"^"_GloomyCool_"^"_CoolGloomy_"^"_Seal_"^"_COLDST_"^"_MinTemp
	s Data3=MaxTemp_"^"_MinHumidity_"^"_MaxHumidity_"^"_Freeze_"^"_DampProof
	s Data=Data1_"^"_Data2_"^"_Data3
	s Title1="ISC^CommonTemp^Dry^AirTight^Dark^Ventilate^Radiation"
	s Title2="MeltPack^GloomyCool^CoolGloomy^Seal^ColDst^MinTemp"
	s Title3="MaxTemp^MinHumidity^MaxHumidity^Freeze^DampProof"
	s Title=Title1_"^"_Title2_"^"_Title3
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

// w ##class(web.DHCSTMHUI.ITMSTORECON).GetStoreCond(1)

ClassMethod GetStoreCond(Inci As %String) As %Library.String
{
	n (Inci)
	s Ret=""
	q:Inci="" Ret
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	q:Info="" Ret
	q:'$d(^DHCITMINFO(Info)) Ret
	s ISC=$p(^DHCITMINFO(Info),"^",28)
	q:ISC="" Ret
	q:'$d(^DHCItemSC(ISC)) Ret
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
	s Freeze=$p(^DHCItemSC(ISC),"^",16)			;冷冻
	s DampProof=$p(^DHCItemSC(ISC),"^",17)			;防潮
	s Ret=$$ForRtn(CommonTemp,"常温")
	s Ret=$$ForRtn(Dry,"干燥")
	s Ret=$$ForRtn(Airtight,"密闭")
	s Ret=$$ForRtn(Dark,"避光")
	s Ret=$$ForRtn(Ventilate,"通风")
	s Ret=$$ForRtn(Radiation,"防辐射")
	s Ret=$$ForRtn(MeltPack,"熔封")
	s Ret=$$ForRtn(GloomyCool,"阴凉")
	s Ret=$$ForRtn(CoolGloomy,"凉暗")
	s Ret=$$ForRtn(Seal,"密封")
	s Ret=$$ForRtn(COLDST,"冷藏")
	s Ret=$$ForRtn(MinTemp,"最低温度","T")
	s Ret=$$ForRtn(MaxTemp,"最高温度","T")
	s Ret=$$ForRtn(MinHumidity,"最低湿度","T")
	s Ret=$$ForRtn(MaxHumidity,"最高湿度","T")
	s Ret=$$ForRtn(Freeze,"冷冻")
	s Ret=$$ForRtn(DampProof,"防潮")

	q Ret
ForRtn(con,bar,t="")
	//温度
	i (t'="")&&(con'="") d
	.i Ret="" d
	..s Ret=bar_":"_con
	.e  d
	..s Ret=Ret_";"_bar_":"_con
	//非温度
	i (t="")&&(con="Y") d
	.i Ret="" d
	..s Ret=bar
	.e  d
	..s Ret=Ret_";"_bar
	q Ret
}

}
