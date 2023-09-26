Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2019-11-28
/// Descript: 	会诊评分表格初始化
Class web.DHCEMConsAppTable Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMConsAppTable).GetColumn("SHP","2")
ClassMethod GetColumn(TypeCode, LgParams)
{
	n (TypeCode,LgParams)
	q:TypeCode="" "[]"
	s LgHosp = +LgParams
	s LgHosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",LgHosp) //hxy 2021-05-31 add
	s TypeID = $o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),LgHosp,""))
	q:+TypeID=0 "[]"
	
	s ColParID = ""
	s DicItmID = ""
	f  s DicItmID = $o(^DHCEMCDI(0,"Type",TypeID,DicItmID)) q:(DicItmID="")||(ColParID'="")  d
	.s Desc = $p(^DHCEMCDI(DicItmID),"^",2)
	.q:Desc'["column"
	.s ColParID = DicItmID
	q:+ColParID=0 "[]"
	
	w "["
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s Count=0
	s ID=""
	f  s ID = $o(^DHCEMCDI(0,"IndexPar",ColParID,ID)) q:ID=""  d
    .s Obj=##class(web.DHCEMColumn).%New()
    .s Obj.title=$p(^DHCEMCDI(ID),"^",2)
    .s Obj.field=$p(^DHCEMCDI(ID),"^",1)
	.s Obj.width="100"
	.s:Obj.title["评价项目" Obj.width="300"
	.s:Obj.title="是" Obj.width="50"
	.s:Obj.title="否" Obj.width="50"
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w jsonObj.ObjToJson(Obj) 
    w "]"
    q ""
}

/// w ##class(web.DHCEMConsAppTable).GetData("","SHP","2")
ClassMethod GetData(CstID, TypeCode, LgParams)
{
	n (CstID,TypeCode,LgParams)
	q:TypeCode="" "[]"
	s LgHosp = +LgParams
	s LgHosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",LgHosp) //hxy 2021-05-31 add
	s TypeID = $o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),LgHosp,""))
	q:+TypeID=0 "[]"
	
	s ListTitle="",Count=0,H=0
	s DicItmID = ""
	f  s DicItmID = $o(^DHCEMCDI(0,"Type",TypeID,DicItmID)) q:DicItmID=""  d
	.s Code = $p(^DHCEMCDI(DicItmID),"^",1)
	.s Desc = $p(^DHCEMCDI(DicItmID),"^",2)
	.s ParID = $p(^DHCEMCDI(DicItmID),"^",7)
	.s Flag = $p(^DHCEMCDI(DicItmID),"^",3) //启用标识 hxy 2021-04-14 st
	.q:Flag'="Y" //ed
	.q:+ParID'=0
	.s ID=""
	.s ItmData=""
	.f  s ID = $o(^DHCEMCDI(0,"IndexPar",+DicItmID,ID)) q:ID=""  d
	..s ItmCode = $p(^DHCEMCDI(ID),"^",1)
	..s ItmDesc = $p(^DHCEMCDI(ID),"^",2)
	..s ItmFlag = $p(^DHCEMCDI(ID),"^",3) //启用标识 hxy 2021-04-14 st
	..q:ItmFlag'="Y" //ed
	..i Desc["column" d
	...s:ListTitle'="" ListTitle=ListTitle_"^"_ItmCode
	...s:ListTitle="" ListTitle=ItmCode
	..i Desc["row" d
	...s Value = ##class(web.DHCEMConsAppTable).GetEvaValue(CstID,ID,"")
	...s:Value'="" ItmDesc = ID_"##"_Value
	...s:Value="" ItmDesc = ID_"##"_ItmDesc
	...s:ItmData'="" ItmData=ItmData_"^"_ItmDesc
	...s:ItmData="" ItmData=ItmDesc
	.q:ItmData=""
	.s H=H+1
	.s TMPData(H)=ItmData
	
	b ;err
	
	i H=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(H) //输出json结尾符
	Q:H=0 ""
	
	///转换数据为Json格式
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(H) //输出json前缀串
	s Index=""
	f  s Index=$o(TMPData(Index)) Q:Index=""  D
	.s ListData=$g(TMPData(Index))
	.s Count = Count+1
	.I Count=1 D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// w ##class(web.DHCEMConsAppTable).SaveAva("527||1","C","116##会诊申请是否合理^116##Y^116##N^116##10^121##会诊方式（急/普通会诊）选择是否合理^121##Y^121##N^121##30")
ClassMethod SaveAva(CstID, AvaType, SaveData)
{
	n (CstID,AvaType,SaveData)
	q:+CstID=0 "-1"
	q:AvaType="" "-2"
	
	s Len = $l(SaveData,"^")
	
	ts
	&sql(DELETE DHC_EmConsultEva WHERE EC_Cst_Ref=:CstID AND EC_EvaType=:AvaType)

	tro:SQLCODE<0
	q:SQLCODE<0 "-3"
	f i=1:1:Len q:SQLCODE<0  d
	.s ItmData=$p(SaveData,"^",i)
	.q:ItmData=""
	.s ItmDicID = $p(ItmData,"##",1)
	.s ItmDicValue = $p(ItmData,"##",2)
	.&sql(INSERT INTO DHC_EmConsultEva (EC_Cst_Ref, EC_DicItm_Dr, EC_EvaValue, EC_EvaType) VALUES (:CstID,:ItmDicID,:ItmDicValue,:AvaType))
	.
	tro:SQLCODE<0
	q:SQLCODE<0 "-4"
	tc
	q 0
}

/// w ##class(web.DHCEMConsAppTable).GetEvaValue("527||1","125","")
ClassMethod GetEvaValue(CstID, DicItmID, AvaType)
{
	n (CstID,DicItmID,AvaType)
	q:CstID="" ""
	q:DicItmID="" ""
	s Ret=""
	s AvaID = ""
	f  s AvaID = $o(^DHCEMCONE(0,"IndexCstAndDic",CstID,DicItmID,AvaID)) q:(AvaID="")||(Ret'="")  d
	.s ItmAvaType = $p(^DHCEMCONE(AvaID),"^",4)
	.q:(AvaType'="")&&(AvaType'=ItmAvaType)
	.s Ret = $p(^DHCEMCONE(AvaID),"^",3)
	q Ret
}

/// w ##class(web.DHCEMConsAppTable).GetAllSc("575||1","SHR","2")
ClassMethod GetAllSc(CstID, TypeCode, LgParams)
{
	n (CstID,TypeCode,LgParams)
	q:TypeCode="" "[]"
	s LgHosp = +LgParams
	s LgHosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",LgHosp) //hxy 2021-06-02 多院区 add
	s TypeID = $o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),LgHosp,""))
	q:+TypeID=0 "[]"
	
	s ListTitle="",Count=0,H=0
	s DicItmID = ""
	f  s DicItmID = $o(^DHCEMCDI(0,"Type",TypeID,DicItmID)) q:DicItmID=""  d
	.s Code = $p(^DHCEMCDI(DicItmID),"^",1)
	.s Desc = $p(^DHCEMCDI(DicItmID),"^",2)
	.s ParID = $p(^DHCEMCDI(DicItmID),"^",7)
	.q:+ParID'=0
	.s ID=""
	.s ItmData=""
	.f  s ID = $o(^DHCEMCDI(0,"IndexPar",+DicItmID,ID)) q:ID=""  d
	..s ItmCode = $p(^DHCEMCDI(ID),"^",1)
	..s ItmDesc = $p(^DHCEMCDI(ID),"^",2)
	..i Desc["column" d
	...s:ListTitle'="" ListTitle=ListTitle_"^"_ItmCode
	...s:ListTitle="" ListTitle=ItmCode
	..i Desc["row" d
	...s Value = ##class(web.DHCEMConsAppTable).GetEvaValue(CstID,ID,"")
	...s:Value'="" ItmDesc = ID_"##"_Value
	...s:Value="" ItmDesc = ID_"##"_ItmDesc
	...s:ItmData'="" ItmData=ItmData_"^"_ItmDesc
	...s:ItmData="" ItmData=ItmDesc
	.q:ItmData=""
	.s H=H+1
	.s TMPData(H)=ItmData
	Q:H=0 0
	
	s AllSc=0,IsHasNot=0
	s Index=""
	f  s Index=$o(TMPData(Index)) Q:Index=""  D
	.s ListData=$g(TMPData(Index))
	.s IsHasSc=$p(ListData,"^",2)
	.s:IsHasSc'="" IsHasSc=$p(IsHasSc,"##",2)
	.s Sc=$p(ListData,"^",4)
	.s:Sc'="" Sc=$p(Sc,"##",2)
	.s:IsHasSc="Y" AllSc=AllSc+Sc
	.s NotStr=$p(ListData,"^",3)
	.s:$p(NotStr,"##",2)="Y" IsHasNot=1
	s:(IsHasNot=0)&&(AllSc=0) AllSc=""
	Q AllSc
}

}
