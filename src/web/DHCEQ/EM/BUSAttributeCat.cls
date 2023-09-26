Class web.DHCEQ.EM.BUSAttributeCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      WL
/// CreatDate：    2020-2-11
/// Description:   根据类型串查询表中对应的设备类型
/// Table：        DHC_EQCInHospitalType
/// Input：        Code 代码,Desc 设备名称 TypeStr：要显示的设备类型串 51 显示甲乙类设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAttributeCat","GetAttributeCat","","","22","","")
/// czf 2022-04-13 修改TypeStr过滤逻辑，增加TypeIDStr过滤条件
Query GetAttributeCat(Code As %String = "", Desc As %String = "", TypeStr As %String = "", otherDesc As %String = "", TypeIDStr As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TOtherDesc:%String")
{
}

ClassMethod GetAttributeCatExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", TypeStr As %String = "", otherDesc As %String = "", TypeIDStr As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=1
	i (TypeStr="")&&(TypeIDStr="") Quit $$$OK
	//czf 2022-04-13
	s TypeCodes=""
	i TypeIDStr'="" d
	.s length=$l(TypeIDStr,"^")
	.f i=1:1:length d
	..s TypeID=$p(TypeIDStr,"^",i)
	..s TypeCode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",TypeID)),"^",1)
	..i TypeCodes'="" s TypeCodes=TypeCodes_"^"
	..s TypeCodes=TypeCodes_TypeCode
	
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCInHospitalType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetAttributeCat
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(Code ,"U")'[Code)		//modify by wl 2020-03-18 增加模糊查询 begin
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",2)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'[Desc)
	.s TType=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",3)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",5)
	.i TType="51" s TOtherDesc=$case(THold1,"1":"甲类","2":"乙类",:"")
	.e  i TType'="" s TOtherDesc=THold1
	.q:(otherDesc'="")&&(TOtherDesc'[otherDesc)&&((##class(web.DHCEQCHanZiEncoding).GetEncoding(TOtherDesc,4,"","U"))'[$zconvert(otherDesc,"U"))
	.s length=$l(TypeStr,"^")
	.q:(TypeStr'="")&&(("^"_TypeStr_"^")'[("^"_TType_"^"))		//czf 2022-04-13
	.q:(TypeCodes'="")&&(("^"_TypeCodes_"^")'[("^"_TType_"^"))
	.d OutputRowGetAttributeCat
	Quit $$$OK
OutputRowGetAttributeCat
	s Data=$lb(TDesc,TRowID,TCode,TOtherDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit 
ResetVariablesGetAttributeCat
	s (TRowID,TCode,TDesc,TType,TInvalidFlag,TOtherDesc)=""
	quit
}

ClassMethod GetAttributeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAttributeCatExecute ]
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

ClassMethod GetAttributeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAttributeCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 查询能够选择的所有设备
/// Creator:汪亮
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAttributeCat","GetAttributeCatChoose","")
/// 2020-02-09
Query GetAttributeCatChoose(Name As %String, Code As %String) As %Query(ROWSPEC = "EQABFlag:%String,EQRowID:%String,EQNo:%String,EQModel:%String,EQName:%String")
{
}

ClassMethod GetAttributeCatChooseExecute(ByRef qHandle As %Binary, Name As %String, Code As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s EquipAttributeDR= $o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",Code,0)) 
	Q:EquipAttributeDR=""
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d 
	.d ResetVariablesGetAttributeCatChoose		//czf 1730579 2021-01-22
	.i $d(^DHCEQEquipAttributeList(0,"AttributeSource",EquipAttributeDR,3,RowID))=10 q 
	.s EQName=$p($g(^DHCEQEquip(RowID)),"^",1)
	.;modify by wl 2020-06-22 begin 
	.s EQNo=$p($g(^DHCEQEquip(RowID)),"^",71)
	.q:(Name'="")&&(EQName'[Name)&&(EQNo'[Name)&&(##class(web.DHCEQCHanZiEncoding).GetEncoding(EQName,4,"","U")'[$zcvt(Name,"U"))
	.s EQModelDR=$p($g(^DHCEQEquip(RowID)),"^",3)
	.i EQModelDR'="" s EQModel=$p(^DHCEQCCode("DHCEQCModel",EQModelDR),"^",2)
	.s EQABFlag="N"
	.s EQInVaildFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
	.q:EQInVaildFlag="Y"
	.q:(##class(web.DHCEQCommon).FundsTypeIsIn(1,RowID)=1)
	.q:(##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(RowID)),"^",63))'=0)
	.;modify by wl 2020-06-22 end 
	.s EQStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
	.s EQStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
	.s EQInStockListDR=$p($g(^DHCEQEquip(RowID)),"^",70)
	.q:(EQStockStatus="3")||(EQStockStatus="0")||(EQStatus="3")  //Modefid by zc0106 2021-7-27去掉入库明细过滤(EQInStockListDR="")
	.d OutputRowGetAttributeCatChoose
	Quit $$$OK
OutputRowGetAttributeCatChoose
	s Data=$lb(EQABFlag,RowID,EQNo,EQModel,EQName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetAttributeCatChoose
	s (EQModelDR,EQModel,EQNo,EQName,EQABFlag)=""
	quit
}

ClassMethod GetAttributeCatChooseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAttributeCatChooseExecute ]
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

ClassMethod GetAttributeCatChooseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAttributeCatChooseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2020-2-11
/// Description:   查询当前某设备属性分类
/// Table：        DHC_EQEquip
/// Input：        Name 设备名称,TypeDR:设备属性的code
/// Debug: 		   d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAttributeCat","GetAttributeCatList","","","51","jl")
/// modify by wl 2020-06-22 增加参数,类组过滤
Query GetAttributeCatList(Name As %String, TypeDR As %String, Code As %String, CIHTTypeDesc As %String = "", CEALSubFlag As %String = "") As %Query(ROWSPEC = "EQRowID:%String,EQNo:%String,EQModel:%String,EQName:%String,IHTTypeDesc:%String,EALSubInfo:%String,EALSubInfo_IHTDesc:%String,EALSourceID:%String")
{
}

ClassMethod GetAttributeCatListExecute(ByRef qHandle As %Binary, Name As %String, TypeDR As %String, Code As %String, CIHTTypeDesc As %String = "", CEALSubFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	i Code="" Quit $$$OK
	s EquipAttributeDR= $o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",Code,0))  
	i EquipAttributeDR="" Quit $$$OK
	s EQRowID=0
	for  s EQRowID =$o(^DHCEQEquipAttributeList(0,"AttributeSource",EquipAttributeDR,3,EQRowID))  q:EQRowID=""   d 
	.d ResetVariablesGetData
	.s EQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.q:(Name'="")&&(EQName'[Name)&&((##class(web.DHCEQCHanZiEncoding).GetEncoding(EQName,4,"","U"))'[$zcvt(Name,"U"))
	.s EQModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	.s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.i EQModelDR'="" s EQModel=$p(^DHCEQCCode("DHCEQCModel",EQModelDR),"^",2)
	.s EALRowID=0 
	.s EQInVaildFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.q:EQInVaildFlag="Y"
	.q:(##class(web.DHCEQCommon).FundsTypeIsIn(1,EQRowID)=1)
	.q:(##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(EQRowID)),"^",63))'=0) 
	.s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.s EQInStockListDR=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.q:(EQStockStatus="3")||(EQStockStatus="0")||(EQStatus="3")		//||(EQInStockListDR="")  czf 2022-03-31
	.s EALSourceID=EQRowID
	.for  s EALRowID=$o(^DHCEQEquipAttributeList(0,"AttributeSource",EquipAttributeDR,3,EQRowID,EALRowID)) quit:EALRowID=""  d	
	..s EALSubInfo=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",4)
	..q:(TypeDR'="")&&(TypeDR'=EALSubInfo)
	..q:(CIHTTypeDesc'="")&&(EALSubInfo="")
	..i CEALSubFlag="Y" q:EALSubInfo'=""
	..i EALSubInfo'="" d 
	...s EALSubInfoIHTDesc=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",2)
	...;modify by wl 2020-06-12 WL0067
	...s IHTTypeDesc=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",5) //modified by sjh SJH0031 2020-08-03 begin
	...i (IHTTypeDesc'="")&&(Code="51")  s IHTTypeDesc=$case(IHTTypeDesc,"1":"甲类","2":"乙类",:"") //modified by sjh SJH0031 2020-08-03 end
	...q:(CIHTTypeDesc'="")&&(IHTTypeDesc'[CIHTTypeDesc)&&((##class(web.DHCEQCHanZiEncoding).GetEncoding(IHTTypeDesc,4,"","U"))'[$zcvt(CIHTTypeDesc,"U"))
	...d OutputRowGetData
	..e  d OutputRowGetData
	Quit $$$OK
OutputRowGetData
	s Data=$lb(EQRowID,EQNo,EQModel,EQName,IHTTypeDesc,EALSubInfo,EALSubInfoIHTDesc,EALSourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetData
	s (EQModelDR,EQModel,EQNo,EALSubInfo,EALSubInfoIHTDesc,IHTType,IHTTypeDesc,EQName,EALSubInfo)=""
	quit
}

ClassMethod GetAttributeCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAttributeCatListExecute ]
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

ClassMethod GetAttributeCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAttributeCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// ----------------------------------
/// 创建:WL  2020-02-24
/// 描述:通过JSON对象保存甲乙分类明细的信息
/// 	入参:Data：数据
/// 		 code: 设备属性的code
///   operateType: 操作类型
///    sourceType: 来源类型ID(1:设备项,2:验收单,3:设备)
/// ----------------------------------
ClassMethod SaveData(dataList, code, operateType, sourcetype)
{
	Set $ZT="ERRORList"
	TSTART
	s Length=$l(dataList,"&")
	f i=1:1:Length   
	{
	s val=$p(dataList,"&",i)
	s SQLCODE=..SaveDataList(val, code, operateType,sourcetype)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
		TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,Length)
ERRORList 
	TRollBack	
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// ----------------------------------
/// 创建:WL  2020-02-24
/// 描述:保存单条设备属性明细的信息
/// 	入参:Data：数据
/// 		 code: 设备属性的code
///   operateType: 操作类型 "1"更新 ,"2" 删除 ,其他 增加 
///    sourceType: 来源类型ID(1:设备项,2:验收单,3:设备)
/// ----------------------------------
ClassMethod SaveDataList(val, code, operateType, sourcetype)
{
	q:sourcetype=""
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEquipAttributeList",JsonData,.PLIST)
	s RowID=JsonData.%Get("EQRowID")
	s EquipAttributeDR= $o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",code,0))
	s EALRowID = $o(^DHCEQEquipAttributeList(0,"AttributeSource",EquipAttributeDR,sourcetype,RowID,0))
	
	if EALRowID'=""
	{
		if operateType="1"
		{
			s PLIST(7)="N"
			&SQL(update sqluser.DHC_EQEquipAttributeList values :PLIST() where EAL_RowID=:EALRowID  )
		}
		if operateType="2"
		{ 
			&SQL(delete from sqluser.DHC_EQEquipAttributeList where EAL_RowID = :EALRowID )
		}

	}
	else
	{ 
			s PLIST(2)=EquipAttributeDR
			s PLIST(3)=sourcetype
			s PLIST(4)=RowID
			s PLIST(7)="N"
			&SQL(insert into sqluser.DHC_EQEquipAttributeList values :PLIST())		
	}
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:WL  2020-02-09
/// 描述:根据台账的id获取对应的类描述
/// 	入参:EQRowID：台账的id
/// 		code:设备属性的code
/// w ##Class(web.DHCEQ.EM.BUSAttributeCat).GetSubInfo("1")
/// ----------------------------------
ClassMethod GetSubInfo(EQRowID, code)
{
	s (EALSubInfo,EALSubInfoDesc)=""
	i code'=""  d
	.s EquipAttributeDR = $o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",code,0))
	.s EALRowID = $o(^DHCEQEquipAttributeList(0,"AttributeSource",EquipAttributeDR,3,EQRowID,0)) 
	.i EALRowID '="" s EALSubInfo = $p($g(^DHCEQEquipAttributeList(EALRowID)),"^",4)
	.i EALSubInfo '=""  s EALSubInfoDesc= $p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",2)
	q EALSubInfoDesc_"^"_EALSubInfo //modify by wl 2020-03-13 WL0063
}

/// Creator：      WL
/// CreatDate：    2020-2-11
/// Description:   设备属性的放大镜
/// Table：        DHC_EQCEquipAttribute
/// Input：        Desc 设备属性名称,Code:设备属性的Code
/// Debug: 		   d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAttributeCat","GetAttributeList","","")
Query GetAttributeList(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String")
{
}

ClassMethod GetAttributeListExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	//s EquipAttributeList=##class(web.DHCEQCommon).GetSysInfo("990065")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.d ResetVariablesGetAttributeList
	.s EALGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.;q:((","_EquipAttributeList_",")'[(","_EALGroup_","))
	.s EARowID = rowid
	.s EACode = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",1)
	.s EAName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.q:(Desc'="")&&(EAName'[Desc)	//modified by csj 20200317
	.d OutputRowGetAttributeList
	Quit $$$OK
OutputRowGetAttributeList
	s Data=$lb(EARowID,EACode,EAName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetAttributeList
	s (EARowID,EACode,EAName)=""
	quit
}

ClassMethod GetAttributeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAttributeListExecute ]
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

ClassMethod GetAttributeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAttributeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##class(web.DHCEQ.EM.BUSAttributeCat).GetEAName("51")
ClassMethod GetEAName(Code)
{
	
	s EAName=""
	i Code'=""  d
	.s EARowID= $o(^DHCEQCCode("DHCEQCEquipAttribute","0","Code",Code,0))
	.i EARowID'="" s EAName=$p($Get(^DHCEQCCode("DHCEQCEquipAttribute",EARowID)),"^",2)
	q EAName
}

/// 创建:WL  2020-03-18
/// 描述:批量导入设备分类
/// d ##class(web.DHCEQ.EM.BUSAttributeCat).ImportAttributeCat("{""IHTCode"":""1"",""IHTDesc"":""小1"",""IHTType"":""11"",""IHTInvalidFlag"":""N""}&{""IHTCode"":""2"",""IHTDesc"":""小2"",""IHTType"":""11"",""IHTInvalidFlag"":""N""}&{""IHTCode"":""3"",""IHTDesc"":""小3"",""IHTType"":""11"",""IHTInvalidFlag"":""N""}")
ClassMethod ImportAttributeCat(DataList)
{
	Set $ZT="ERRORListImport"
	s Length=$l(DataList,"&")
	TSTART
	f i=1:1:Length   
	{
	s val=$p(DataList,"&",i)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInHospitalType",JsonData,.PLIST)
	&SQL(insert into sqluser.DHC_EQCInHospitalType values :PLIST())	
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,Length)
	}
		TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORListImport 
	TRollBack	
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// 创建:WL  2020-03-18
/// 描述:界面设备分类保存
/// opertype "" 新增或保存 "2"删除  DataList Json串
ClassMethod SaveAttributeCat(DataList, opertype)
{
	Set $ZT="ERRORSaveAttributeCat"
	K PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(DataList)
	s RowID=JsonData.IHTRowID
	s IHTDesc=$ZCONVERT(JsonData.IHTDesc,"U")
	s IHTCode=$ZCONVERT(JsonData.IHTCode,"U")
	s IHTType=$ZCONVERT(JsonData.IHTType,"U")
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInHospitalType",JsonData,.PLIST)
	s PLIST(3)=$ZCONVERT(PLIST(3),"U")
	s PLIST(2)=$ZCONVERT(PLIST(2),"U")
	s PLIST(5)="N"
	TSTART
	s tmp=""
	i opertype=""
	{  
		if RowID="" 
		{ 
			&SQL(select IHT_RowID into :tmp  from sqluser.DHC_EQCInHospitalType where (IHT_Desc =:IHTDesc or IHT_Code=:IHTCode) and IHT_InvalidFlag='N' and IHT_Type=:IHTType  )
			if tmp=""
			{ 
				&SQL(insert into sqluser.DHC_EQCInHospitalType values :PLIST())
			
			}
			else
			{ 
				s SQLCODE="-9210"
			}
		}
		else
		{
			&SQL(select IHT_RowID into :tmp  from sqluser.DHC_EQCInHospitalType where (IHT_Desc =:IHTDesc or IHT_Code=:IHTCode) and IHT_InvalidFlag='N' and IHT_Type=:IHTType and IHT_RowID<>:RowID )
			if tmp=""
			{ 
				&SQL(update sqluser.DHC_EQCInHospitalType values :PLIST() where IHT_RowID=:RowID  )
				
			}
			else
			{ 
				s SQLCODE="-9210"
			}
		}	
	}
	elseif (opertype="2"&&RowID'="")
	{ 
		&SQL(delete from sqluser.DHC_EQCInHospitalType where IHT_RowID = :RowID )
	}
	i SQLCODE
	{ 
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORSaveAttributeCat
	TRollBack	
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// ----------------------------------
/// 创建:czf 2022-4-14
/// 描述:保存设备属性分类信息
/// 入参:sourcetype：来源类型ID(1:设备项,2:验收单,3:设备)
/// 	 sourceid：来源ID
/// 		 attrcatids:设备属性风雷ID串，","分隔
/// 	 operateType: 操作类型 "1"删除
/// w ##class(web.DHCEQ.EM.BUSAttributeCat).SaveEQAttributeCat(3,1,"1,2")
/// ----------------------------------
ClassMethod SaveEQAttributeCat(sourcetype, sourceid, attrcatids, operateType As %String = "")
{
	//s ^tempczf("attrcat")=$lb(sourcetype,sourceid,attrcatids,operateType)
	s SQLCODE=0
	i attrcatids'=""
	{
		s attrlength=$l(attrcatids,",")
		for i=1:1:attrlength
		{
			q:SQLCODE'=0
			s attrcatid=$p(attrcatids,",",i)	//附属分类ID
			q:attrcatid=""
			
			s attrcode=$p(^DHCEQCCode("DHCEQCInHospitalType",attrcatid),"^",3)
			s attrid=""			//设备属性ID
			&SQL(select EA_RowID into :attrid from sqluser.DHC_EQCEquipAttribute where EA_Code=:attrcode and EA_InvalidFlag='N')
			q:attrid=""
			s EQAttrListID=""
			s EALRowID=$o(^DHCEQEquipAttributeList(0,"SourceAttribute",sourcetype,sourceid,attrid,""))
			i EALRowID'=""
			{
				i operateType="1"
				{
					&SQL(update sqluser.DHC_EQEquipAttributeList set EAL_InvalidFlag='Y' where EAL_RowID=:EALRowID  )
				}
				else
				{
					&SQL(update sqluser.DHC_EQEquipAttributeList set EAL_SubInfo=:attrcatid, EAL_InvalidFlag='N' where EAL_RowID=:EALRowID  )
				}
				i SQLCODE=100 s SQLCODE=0
			}
			else
			{
				
				s PLIST(2)=attrid
				s PLIST(3)=sourcetype
				s PLIST(4)=sourceid
				s PLIST(5)=attrcatid
				s PLIST(7)="N"
				&SQL(insert into sqluser.DHC_EQEquipAttributeList values :PLIST())
			}
			
			q:SQLCODE'=0
		}
	}
	else
	{
		//取消设置
		&SQL(update sqluser.DHC_EQEquipAttributeList set EAL_SubInfo=NULL where EAL_SourceType=:sourcetype and EAL_SourceID=:sourceid)
		i SQLCODE=100 s SQLCODE=0
	}
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:czf 2022-4-14
/// 描述:获取属性分类信息
/// 入参:sourcetype：来源类型ID(1:设备项,2:验收单,3:设备)
/// w ##class(web.DHCEQ.EM.BUSAttributeCat).GetOneEquipAttributeCat(1,484)
/// ----------------------------------
ClassMethod GetOneEquipAttributeCat(SourceType, SourceID)
{
	s IDString=""
	s Lrowid=0
	f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"SourceID",SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	.q:$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",6)="Y"
	.s SubInfo=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",4)
	.i IDString'="" s IDString=IDString_","
	.s IDString=IDString_SubInfo
	
	q IDString
}

/// ----------------------------------
/// 创建:czf 2022-4-14
/// 描述:根据验收单或设备项将属性分类保存至设备中
/// 入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同),常规为2
/// 	OpenCheckListID:验收单ID
/// 	EquipID:设备ID
/// W ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).SaveAttibuteCatByOCL(2,29,153)
/// ----------------------------------
ClassMethod SaveAttibuteCatByOCL(SourceType, SourceID, EquipID)
{
	s SQLCODE=0
	s Lrowid=0
	f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"SourceID",SourceType,SourceID,Lrowid)) quit:(Lrowid="")||(SQLCODE'=0)  d
	.q:$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",6)="Y"
	.k PLIST
	.s PLIST(2)=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",1)
	.s PLIST(3)=3
	.s PLIST(4)=EquipID
	.s PLIST(5)=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",4)
	.s PLIST(7)="N"
	.&SQL(insert into sqluser.DHC_EQEquipAttributeList values :PLIST())
	.q:SQLCODE'=0
	
	q SQLCODE
}

}
