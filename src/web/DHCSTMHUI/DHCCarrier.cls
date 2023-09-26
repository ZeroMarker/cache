Import sqluser

/// Descript:	配送商信息相关
/// Creater:    tsr
/// CreateDate: 2018-10-19
Class web.DHCSTMHUI.DHCCarrier Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_Carrier";

/// Descript:	查询配送商信息
/// Creator: 	tsr
/// CreatDate: 	2018-10-19
/// Table: 		DHC_Carrier
/// Input: 		Params对象-代码,名称,手机号
Query DHCCarrier(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,Phone") [ SqlProc ]
{
}

ClassMethod DHCCarrierExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pDesc=PJObj.%Get("Desc")
	s pPhone=PJObj.%Get("Phone")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Type=..sssCode()
	
	s SqlStr="SELECT CA_Rowid RowId, CA_Code, CA_Desc, CA_Type, CA_Mobile"
		_" FROM SQLUser.DHC_Carrier"
		_" WHERE CA_Type = '"_Type_"'"
	i pDesc'="" d
	.s pDesc=$$ALPHAUP^SSUTIL4(pDesc)
	.s SqlStr=SqlStr_" AND (CA_Desc LIKE '%"_pDesc_"%'"_" OR CA_Code LIKE '%"_pDesc_"%')" 
	i pPhone'="" d
	.s SqlStr=SqlStr_" AND CA_Mobile LIKE '%"_pPhone_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Carrier",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Code = result.Data("CA_Code")
		s Description = result.Data("CA_Desc")
		s Phone=result.Data("CA_Mobile")
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description,Phone)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   保存配送商信息
/// Creater:    tsr
/// CreateDate: 2018-10-19
/// Table:		DHC_Carrier
/// Input:		
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s RtnObj=##class(RtnObj).%New()

	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1111,"","入参解析失败!").Json()

	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		s Phone=Obj.%Get("Phone")
		i (Code="")||(Description="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0

		//s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,..#AppTable,gHospId,RowId)
		s ret=$o(^DHCCARR(0,"Code",Code,0))	//不同院区之间也不能重复
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		q:RtnObj.success<0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,Phone)
		e  d
		.s RtnObj=..Insert(Code,Description,Phone,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加配送商
/// Creater:	tsr
/// CreateDate: 2018-10-19
/// Table:		DHC_Carrier
/// Input:		代码,描述,手机
/// Return:		RtnObj
ClassMethod Insert(Code As %String, Description As %String, Phone As %String, gHospId = "") As RtnObj [ Private ]
{
	n (Code,Description,Phone,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	&sql(Insert into DHC_Carrier
		(CA_Code, CA_Desc, CA_Type, CA_Mobile)
		values
		(:Code,:Description,:Type,:Phone))
	i SQLCODE'=0 d
	.d RtnObj.Err(-11,"","增加配送商失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_Carrier","User.DHCCarrier","配送商信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	.q:RtnObj.success'=0
	.//保存医院关联
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_Carrier",RowId,gHospId)
	.i ret'=0 d RtnObj.Err(-5,"","关联医院失败"_ret)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新配送商
/// Creater:	tsr
/// CreateDate: 2018-10-19
/// Table:		DHC_Carrier
/// Input:		Id,代码,描述,手机
/// Return:		RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String, Phone As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,Phone,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_Carrier",RowId)
	&sql(UPDATE SQLUser.DHC_Carrier
		SET CA_Code = :Code, CA_Desc = :Description, CA_Type = :Type, CA_Mobile = :Phone
		WHERE CA_Rowid =:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"","更新配送商失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_Carrier","User.DHCCarrier","配送商信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	获取配送商物资信息
/// Creater:	tsr
/// CreateDate: 2018-10-19
/// Table:		DHC_ItmAddionInfo
Query CarryItm(Carrier As %String) As Query(ROWSPEC = "Inci,InciCode,InciDesc,Spec,PurUomDesc,BuomDesc,StkCatDesc,Sp:%Float,Rp:%Float") [ SqlProc ]
{
}

ClassMethod CarryItmExecute(ByRef qHandle As %Binary, Carrier As %String) As %Status
{
	n (qHandle,Carrier)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Carrier="" $$$OK
	
	s SqlStr="select INFO_INCI_DR as Inci from DHC_ItmAddionInfo where INFO_PbCarrier_DR="_Carrier
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s Inci=result.Data("Inci")
		s InciCode=$p(^INCI(Inci,1),"^",1)
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s PurUomId=$p(^INCI(Inci,3),"^",6)
		s StkCatId=$p(^INCI(Inci,2),"^",2)
		s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
		s Spec=$s(Info'="":$p(^DHCITMINFO(Info),"^",27),1:"")
		s:BUomId'="" BuomDesc=$p($G(^CT("UOM",BUomId)),"^",2)
		s:PurUomId'="" PurUomDesc=$p($G(^CT("UOM",PurUomId)),"^",2)
		s:StkCatId'="" StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,PurUomId)
		s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,PurUomId)
		d OutPutItmRow
	}
	d result.Close()
	Quit $$$OK
OutPutItmRow
	s Data=$lb(Inci,InciCode,InciDesc,Spec,PurUomDesc,BuomDesc,StkCatDesc,Sp,Rp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:判断某配送商是否属于某医院
/// Creater:	lxt
/// CreateDate: 2020-04-8
/// Table:		DHC_Carrier
/// Input:		配送商Id,医院Id
/// Return:		0-属于;非零-不属于
ClassMethod CarrierOfHosp(RowId, HospId) As %String
{
	n (RowId,HospId,%session)
	q:RowId="" -1
	q:HospId="" -2
	;s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag(HospId)
	;q:(HospAutFlag'="Y") -3
	s TmpHospId=""
	&sql(select CA_Hospital_DR into :TmpHospId from DHC_Carrier where CA_Rowid=:RowId)
	q:(HospId'=TmpHospId)&&(TmpHospId'="") -4
	q 0
}

}
