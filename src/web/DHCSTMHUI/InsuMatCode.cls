Import sqluser

Class web.DHCSTMHUI.InsuMatCode Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InsuMatCode","MatRegCert",^tmphousc("fafdaf"))
Query MatRegCert(Params As %String) As Query(ROWSPEC = "rowid,InsuCode,scg1,scg2,scg3,GenericName,Quality,mSpec,ManfName,flag")
{
}

ClassMethod MatRegCertExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s MecialCode=PJObj.%Get("MecialCode")
	s tGenericName=PJObj.%Get("GenericName")
	s phmanf=PJObj.%Get("phmanf")
	s FScg=PJObj.%Get("FScg")
	s SScg=PJObj.%Get("SScg")
	s TScg=PJObj.%Get("TScg")
	s sql="select MATIC_RowId, MATIC_InsuCode,MATIC_Class1,MATIC_Class2,MATIC_Class3,MATIC_GenericName,MATIC_Quality,MATIC_Spec,MATIC_ManfName,MATIC_ActiveFlag from MAT_InsuCode where 1=1"
	i MecialCode'="" d
	.s sql=sql_" and MATIC_InsuCode like '%"_MecialCode_"%'"
	i tGenericName'="" d
	.s sql=sql_" and MATIC_GenericName like '%"_tGenericName_"%'"
	i phmanf'="" d
	.s sql=sql_" and MATIC_ManfName like '%"_phmanf_"%'"
	i FScg'="" d
	.s sql=sql_" and MATIC_Class1 like '%"_FScg_"%'"
	i SScg'="" d
	.s sql=sql_" and MATIC_Class2 like '%"_SScg_"%'"
	i TScg'="" d
	.s sql=sql_" and MATIC_Class3 like '%"_TScg_"%'"
	s sql=sql_" order by MATIC_RowId desc"
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	s count=0
	while (xrs.Next())
	{
		s InsuCode=xrs.Data("MATIC_InsuCode")
		s scg1=xrs.Data("MATIC_Class1")
		s scg2=xrs.Data("MATIC_Class2")
		s scg3=xrs.Data("MATIC_Class3")
		s GenericName=xrs.Data("MATIC_GenericName")
		s Quality=xrs.Data("MATIC_Quality")
		s mSpec=xrs.Data("MATIC_Spec")
		s ManfName=xrs.Data("MATIC_ManfName")
		s flag=xrs.Data("MATIC_ActiveFlag")
		s rowid=xrs.Data("MATIC_RowId")
		s Data=$lb(rowid,InsuCode,scg1,scg2,scg3,GenericName,Quality,mSpec,ManfName,flag)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod jsSave(ListData) As %String
{
	s RtnObj=##class(RtnObj).%New()
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Err=""
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		s Rowid=ItmObj.%Get("rowid")
		q:Rowid'=""
		s InsuCode=ItmObj.%Get("InsuCode")
		q:InsuCode=""
		s scg1=ItmObj.%Get("scg1")
		s scg2=ItmObj.%Get("scg2")
		s scg3=ItmObj.%Get("scg3")
		s GenericName=ItmObj.%Get("GenericName")
		s Quality=ItmObj.%Get("Quality")
		s mSpec=ItmObj.%Get("mSpec")
		s ManfName=ItmObj.%Get("ManfName")
		s stopflag=ItmObj.%Get("stopflag")
		s MatInsuId=$o(^User.MATInsuCodeI("MATICInsuCode",InsuCode,0))
		i MatInsuId="" d
		.&sql(insert into MAT_InsuCode (MATIC_InsuCode,MATIC_Class1,MATIC_Class2,MATIC_Class3,MATIC_GenericName,MATIC_Quality,MATIC_Spec,MATIC_ManfName,MATIC_ActiveFlag)
		values (:InsuCode,:scg1,:scg2,:scg3,:GenericName,:Quality,:mSpec,:ManfName,:stopflag))
		.i SQLCODE'=0 d
		..s Sc=RtnObj.Err(-1,"","保存失败!"_SQLCODE) 
		e  d
		.&sql(update MAT_InsuCode set MATIC_InsuCode=:InsuCode,MATIC_Class1=:scg1,MATIC_Class2=:scg2,MATIC_Class3=:scg3,MATIC_GenericName=:GenericName,
		MATIC_Quality=:Quality,MATIC_Spec=:mSpec,MATIC_ManfName=:ManfName,MATIC_ActiveFlag=:stopflag where MATIC_RowId=:MatInsuId )
		.i SQLCODE'=0 d
		..s Sc=RtnObj.Err(-1,"","修改失败!"_SQLCODE)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// /// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InsuMatCode","QueryDetail","11110")
Query QueryDetail(rowid As %String) As Query(ROWSPEC = "rowid,RegNo,agent,oneIncDesc,mSpec") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	n (qHandle,rowid)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:rowid="" $$$OK
	&sql(select MATIC_InsuCode into :InsuCode from MAT_InsuCode where  MATIC_RowId=:rowid)
	q:InsuCode="" $$$OK
	s rowid=""
	f  s rowid=$O(^DHCMRCT(0,"MATINSUCODE",InsuCode,rowid)) q:rowid=""  d
	.s regno=$P(^DHCMRCT(rowid),"^",12)
	.s agent=$P(^DHCMRCT(rowid),"^",8)
	.s incidesc=$P(^DHCMRCT(rowid),"^",16)
	.s spec=$P(^DHCMRCT(rowid),"^",24)
	.d OutPutRowDetail
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(rowid,regno,agent,incidesc,spec)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.InsuMatCode).selectInsuCode(3)
ClassMethod selectInsuCode(rowid As %String) As %String
{
	q:rowid="" ""
	s Title="Rowid^InsuCode^scg1^scg2^scg3^GenericName^Quality^mSpec^ManfName^stopflag"
	
	&sql(select MATIC_InsuCode,MATIC_Class1,MATIC_Class2,MATIC_Class3,MATIC_GenericName,MATIC_Quality,MATIC_Spec,MATIC_ManfName,MATIC_ActiveFlag into :insucode,:scg1,:scg2,:scg3,:GenericName,:quatity,:spec,:manf,:stopflag from MAT_InsuCode where MATIC_RowId=:rowid)
	s Data=rowid_"^"_insucode_"^"_scg1_"^"_scg2_"^"_scg3_"^"_GenericName_"^"_quatity_"^"_spec_"^"_manf_"^"_stopflag
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

ClassMethod upDataInsuCode(ListData As %String) As %String
{
	n (ListData)
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(ListData)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s Rowid=PJObj.%Get("Rowid")
	s scg1=PJObj.%Get("scg1")
	s scg2=PJObj.%Get("scg2")
	s scg3=PJObj.%Get("scg3")
	s GenericName=PJObj.%Get("GenericName")
	s Quality=PJObj.%Get("Quality")
	s mSpec=PJObj.%Get("mSpec")
	s ManfName=PJObj.%Get("ManfName")
	s stopflag=PJObj.%Get("stopflag")
	&sql(update MAT_InsuCode set MATIC_Class1=:scg1,MATIC_Class2=:scg2,MATIC_Class3=:scg3,MATIC_GenericName=:GenericName
		,MATIC_Quality=:Quality,MATIC_Spec=:mSpec,MATIC_ManfName=:ManfName,MATIC_ActiveFlag=:stopflag where MATIC_RowId=:Rowid)
	i SQLCODE'=0 d
	.d RtnObj.Err(-2,"","更新失败!")
	q RtnObj.Json()
}

/// Description:根据代码,获取医保分类相关信息
/// Creator:	wangjiabin
/// CreateDate:	2021-02-27
/// w ##class(web.DHCSTMHUI.InsuMatCode).GetInsuMatInfo("C0101010010100104937")
ClassMethod GetInsuMatInfo(InsuMatCode) As %String
{
	n (InsuMatCode)
	q:InsuMatCode="" "{}"
	s RowId15Flag=""
	s RowId=$o(^User.MATInsuCodeI("MATICInsuCode",InsuMatCode,""),-1)
	i (RowId="")&&($l(InsuMatCode)>=20) d
	.s Code20=$e(InsuMatCode,1,20)
	.s RowId=$o(^User.MATInsuCodeI("MATICInsuCode",Code20,""),-1)
	.i RowId="" d
	..s Code15=$e(InsuMatCode,1,15)
	..s RowId=$o(^User.MATInsuCodeI("Code15",Code15,""),-1)
	..s RowId15Flag="Y"
	q:RowId="" "{""MatInsuCode"":"""_InsuMatCode_"""}"
	
	s DataInfo=^User.MATInsuCodeD(RowId)
	s MatInsuClass1=$lg(DataInfo,3),MatInsuClass2=$lg(DataInfo,4),MatInsuClass3=$lg(DataInfo,5)
	s MatInsuGeneric=$lg(DataInfo,6)
	s MatInsuQuality=$lg(DataInfo,7)
	s MatInsuSpec=$lg(DataInfo,8)
	s MatInsuManfName=$lg(DataInfo,9)
	s MatInsuCode=InsuMatCode
	i RowId15Flag="Y" s MatInsuManfName=""
	s Data=MatInsuCode_"^"_MatInsuClass1_"^"_MatInsuClass2_"^"_MatInsuClass3_"^"_MatInsuGeneric_"^"_MatInsuQuality_"^"_MatInsuSpec_"^"_MatInsuManfName
	s Title="MatInsuCode^MatInsuClass1^MatInsuClass2^MatInsuClass3^MatInsuGeneric^MatInsuQuality^MatInsuSpec^MatInsuManfName"
	s Json=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Json
}

/// 导入"医保分类与代码"数据(根据后台global)
/// w ##class(web.DHCSTMHUI.InsuMatCode).ExportData("")
ClassMethod ExportData(Pid)
{
	n (Pid)
	
	;Pid后续考虑如何使用
	;^TMPDHCSTM("MATINSUCODE")		先放到这个global内
	s RtnObj=##class(RtnObj).%New()
	s Count=0
	ts
	s i=0
	f  s i=$o(^TMPDHCSTM("MATINSUCODE",i)) q:i=""  d
	.s Data=^(i)
	.
	.s InsuCode=$lg(Data,1)
	.s Class1=$lg(Data,2)
	.s Class2=$lg(Data,3)
	.s Class3=$lg(Data,4)
	.s Generic=$lg(Data,5)
	.s Quality=$lg(Data,6)
	.s Spec=$lg(Data,7)
	.s ManfName=$lg(Data,8)
	.s RegNo=$lg(Data,9)
	.s RegName=$lg(Data,10)
	.s RegItmDesc=$lg(Data,11)
	.s SpecNum=$lg(Data,12)
	.s InciCode=$lg(Data,13)
	.
	.s Inci=""
	.i InciCode'="" d
	..s Inci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z",0))
	..i Inci="" d RtnObj.Err(-1,"","第"_i_"行,物资代码错误:"_InciCode)
	.q:RtnObj.success<0
	.
	.s RowId=$o(^User.MATInsuCodeI("MATICInsuCode",InsuCode,""),-1)
	.i RowId="" d
	..s Obj=##class(User.MATInsuCode).%New()
	..s Obj.MATICInsuCode=InsuCode
	.e  d
	..s Obj=##class(User.MATInsuCode).%OpenId(RowId)
	.s Obj.MATICClass1=Class1
	.s Obj.MATICClass2=Class2
	.s Obj.MATICClass3=Class3
	.s Obj.MATICGenericName=Generic
	.s Obj.MATICQuality=Quality
	.s Obj.MATICSpec=Spec
	.s Obj.MATICManfName=ManfName
	.s Obj.MATICActiveFlag="Y"
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-1,"","第"_i_"行,医保编码记录失败:"_InsuCode) q
	.
	.s RegId=""
	.i RegNo'="" d
	..s RegId=$o(^DHCMRCT(0,"NO",RegNo,""),-1)
	..i RegId="" d
	...s RegObj=##class(User.DHCMatRegCert).%New()
	...s RegObj.MRCNo=RegNo
	..e   d
	...s RegObj=##class(User.DHCMatRegCert).%OpenId(RegId)
	..s RegObj.MRCRegName=RegName
	..s RegObj.MRCInciDesc=RegItmDesc
	..s RegObj.MRCSpecNum=SpecNum
	..s Sc=RegObj.%Save()
	..i $$$ISERR(Sc)'=0 d RtnObj.Err(-2,"","第"_i_"行,注册证保存失败:"_RegNo) q
	..s RegId=RegObj.%Id()
	.q:RtnObj.success<0
	.
	.i Inci'="" d
	..s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
	..i InfoId="" d
	...s InfoObj=##class(User.DHCItmAddionInfo).%New()
	...d InfoObj.INFOINCIDRSetObjectId(Inci)
	..e  d
	...s InfoObj=##class(User.DHCItmAddionInfo).%OpenId(InfoId)
	..s InfoObj.INFOInsuMatCode=InsuCode
	..s:RegId'="" InfoObj.INFOMatRegCertDR=RegId		;注册证Id, String类型字段
	..s Sc=InfoObj.%Save()
	..i $$$ISERR(Sc)'=0 d RtnObj.Err(-3,"","第"_i_"行,物资信息维护失败:"_InciCode) q
	.q:RtnObj.success<0
	.
	.s Count=Count+1
	
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	
	s RtnObj.msg="成功导入"_Count_"行"
	q RtnObj.Json()
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InsuMatCode","MatSpecDetail",^tmphousc("fdafdf"))
Query MatSpecDetail(Params As %String) As Query(ROWSPEC = "goodid,insumatCode,lsh,GenericName,sspec,regDesc")
{
}

ClassMethod MatSpecDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s MecialCode=PJObj.%Get("MecialCode")
	s tGenericName=PJObj.%Get("GenericName")
	s Spec=PJObj.%Get("InsuSpec")
	q:(MecialCode="")&&(tGenericName="")&&(Spec="") $$$OK
	s Num=0
	s count=0
	i (MecialCode'="")||(tGenericName'="") {
		s sql="select MATIC_InsuCode,MATIC_GenericName,MATIC_ProductId,MATIC_RegCardId from MAT_InsuCode where 1=1"
		i tGenericName'="" d
		.s sql=sql_" and MATIC_GenericName like '%"_tGenericName_"%'"
		i MecialCode'="" d
		.s sql=sql_" and MATIC_InsuCode like '%"_MecialCode_"%'"
		s xrs=##class(%Library.ResultSet).%New()
		s xrs.RuntimeMode=0
		d xrs.Prepare(sql)
		s sc=xrs.Execute()
		i $$$ISERR(sc) q $$$OK
		s count=0
		s Num=0
		while (xrs.Next())
		{
			s insumatCode=xrs.Data("MATIC_InsuCode")
			s productId=xrs.Data("MATIC_ProductId")
			s GenericName=xrs.Data("MATIC_GenericName")
			s regcardId=xrs.Data("MATIC_RegCardId")
			continue:productId=""
			s regid="",regDesc=""
			s:regcardId'="" regid=$O(^DHCMRCT(0,"Product",regcardId,""))
			s:regid'="" regDesc=$p(^DHCMRCT(regid),"^",16)
			s goodid=""
			f  s goodid=$o(^User.MATInsuSpecI("MATISProductId",productId,goodid)) q:goodid=""  d
			.s gooditm=##class(User.MATInsuSpec).%OpenId(goodid)
			.q:gooditm=""
			.s productId=gooditm.MATISProductId
			.s sspec=gooditm.MATISSpec
			.s lsh=gooditm.MATISSerialNo
			.q:(Spec'="")&&(sspec'[Spec)
			.s Data=goodid_"^"_insumatCode_"^"_lsh_"^"_GenericName_"^"_sspec_"^"_regDesc
			.s Data=$lb(goodid,insumatCode,lsh,GenericName,sspec,regDesc)
			.s ^CacheTemp(repid,ind)=Data
			.s ind=ind+1
		}
	}
	else{
		s goodid=""
		s flag=1
		s sqlstr="select MATIS_RowId,MATIS_Spec,MATIS_SerialNo,MATIS_ProductId from MAT_InsuSpec where MATIS_Spec like '%"_Spec_"%'"
		s xrs=##class(%Library.ResultSet).%New()
		s xrs.RuntimeMode=0
		d xrs.Prepare(sqlstr)
		s sc=xrs.Execute()
		i $$$ISERR(sc) q $$$OK
		while (xrs.Next())
		{
			s productId=xrs.Data("MATIS_ProductId")
			s lsh=xrs.Data("MATIS_SerialNo")
			s sspec=xrs.Data("MATIS_Spec")
			s goodid=xrs.Data("MATIS_RowId")
			s insumatCode="",GenericName="",regcardId="",regDesc="",regid=""
			&sql(select MATIC_InsuCode,MATIC_GenericName,MATIC_RegCardId into :insumatCode,:GenericName,:regcardId from MAT_InsuCode where MATIC_ProductId=:productId)
			s:regcardId'="" regid=$O(^DHCMRCT(0,"Product",regcardId,""))
			s:regid'="" regDesc=$p(^DHCMRCT(regid),"^",16)
			s Data=$lb(goodid,insumatCode,lsh,GenericName,sspec,regDesc)
			s ^CacheTemp(repid,ind)=Data
			s ind=ind+1
		}
	}
	Quit $$$OK
}

}
