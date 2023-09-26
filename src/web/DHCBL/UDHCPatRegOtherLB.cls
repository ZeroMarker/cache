Import SQLUser

/// 患者注册时，获取其他信息的类型库
Class web.DHCBL.UDHCPatRegOtherLB Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 52;

Query GetCTCityInfo(CITCode As %String = "", CTProvinceDR As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CTCIT_RowId, CTCIT_Desc FROM SQLUser.CT_City
	where UPPER(CTCIT_Desc) %STARTSWITH UPPER(:CITCode) and CTCIT_Province_DR = :CTProvinceDR
}

ClassMethod GetCTCityInfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", CITCode As %String = "", CTProvinceDR As %String)
{
	s myID=""
	&sql(SELECT CTCIT_RowId, CTCIT_Desc into :myID, :myDesc FROM SQLUser.CT_City
	where UPPER(CTCIT_Desc) = UPPER(:CITCode) and CTCIT_Province_DR = :CTProvinceDR)
	
	i +SQLCODE d
	.s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(CITCode,"O","JS")
	.s retval=""
	.if itmjsex'="""" set retval=itmjsex_"('"_myrtnvalue_"');"
	
	if SQLCODE'=0 quit 0
	
	s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(myDesc,"O","JS")
	s myDesc=$ZCVT(myDesc,"O","JS")
	
	set retval=itmjs_"('"_myDesc_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_myrtnvalue_"');"
	;&javascript<#(retval)#>
	q 1
}

/// /d ##class(%ResultSet).RunQuery("web.DHCBL.UDHCPatRegOtherLB","GetCTCountryInfo","")
/// /
Query GetCTCountryInfo(COUCode As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT CTCOU_RowID, CTCOU_Desc FROM SQLUser.CT_Country
	where CTCOU_Active="Y" and UPPER(CTCOU_Desc) %STARTSWITH UPPER(:COUCode)
		and CTCOU_DateActiveFrom<=CURRENT_DATE and (CTCOU_DateActiveTo>CURRENT_DATE or CTCOU_DateActiveTo is Null or CTCOU_DateActiveTo = "")
}

ClassMethod GetCTCountryInfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", COUCode As %Library.String = "")
{
	s myID=""
	&sql(SELECT CTCOU_RowID, CTCOU_Desc into :myID, :myDesc FROM SQLUser.CT_Country
		where CTCOU_Active="Y" and UPPER(CTCOU_Desc) = UPPER(:COUCode)
			and CTCOU_DateActiveFrom<=CURRENT_DATE and (CTCOU_DateActiveTo>CURRENT_DATE or CTCOU_DateActiveTo is Null or CTCOU_DateActiveTo = ""))
	
	i +SQLCODE d
	.s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(COUCode,"O","JS")
	.s retval=""
	.if itmjsex'="""" set retval=itmjsex_"('"_myrtnvalue_"');alert('Test');"
	.&javascript<#(retval)#>
	
	if SQLCODE'=0 quit 0
	
	s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(myDesc,"O","JS")
	s myDesc=$ZCVT(myDesc,"O","JS")
	
	set retval=itmjs_"('"_myDesc_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_myrtnvalue_"');"
	;&javascript<#(retval)#>
	q 1
}

/// /d ##class(%ResultSet).RunQuery("web.DHCBL.UDHCPatRegOtherLB","GetCTNationInfo","")
Query GetCTNationInfo(NATCode As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT CTNAT_RowId, CTNAT_Desc FROM SQLUser.CT_Nation 
	where UPPER(CTNAT_Desc) %STARTSWITH UPPER(:NATCode)
}

ClassMethod GetCTNationInfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", NATCode As %String = "")
{
	;验证数据是否完整
	;w ##class(web.DHCBL.UDHCPatRegOtherLB).GetCTNationInfoBroker("","","")
	&sql(SELECT CTNAT_RowId, CTNAT_Desc into :myID, :myDesc FROM SQLUser.CT_Nation 
	where UPPER(CTNAT_Desc) = UPPER(:NATCode))
	
	i +SQLCODE d
	.s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(NATCode,"O","JS")
	.s retval=""
	.if itmjsex'="""" set retval=itmjsex_"('"_myrtnvalue_"');"
	.&javascript<#(retval)#>
	
	if SQLCODE'=0 quit 0
	
	s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(myDesc,"O","JS")
	s myDesc=$ZCVT(myDesc,"O","JS")
	
	set retval=itmjs_"('"_myDesc_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_myrtnvalue_"');"
	;&javascript<#(retval)#>
	q 1
}

/// /d ##class(%ResultSet).RunQuery("web.DHCBL.UDHCPatRegOtherLB","GetCTProvinceInfo","","1")
Query GetCTProvinceInfo(PROVCode As %String, CTCountryDR As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT PROV_RowId, PROV_Desc FROM SQLUser.CT_Province
	where UPPER(PROV_Desc) %STARTSWITH UPPER(:PROVCode)
		and (PROV_Region_DR->CTRG_Country_DR = :CTCountryDR)
}

ClassMethod GetCTProvinceInfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", PROVCode As %String, CTCountryDR As %String)
{
	;验证数据是否完整
	&sql(SELECT PROV_RowId, PROV_Desc into :myID, :myDesc FROM SQLUser.CT_Province
			where UPPER(PROV_Desc) = UPPER(:PROVCode)
				and (PROV_Region_DR->CTRG_Country_DR = :CTCountryDR))
	
	i +SQLCODE d
	.s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(PROVCode,"O","JS")
	.s retval=""
	.if itmjsex'="""" set retval=itmjsex_"('"_myrtnvalue_"');"
	.&javascript<#(retval)#>
	
	if SQLCODE'=0 quit 0
	
	s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(myDesc,"O","JS")
	s myDesc=$ZCVT(myDesc,"O","JS")
	
	set retval=itmjs_"('"_myDesc_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_myrtnvalue_"');"
	;&javascript<#(retval)#>
	q 1
}

Query GetZipINfo(CTCountryDR As %String, CTProvinceDR As %String, CTCityDR As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CTZIP_RowID , CTZIP_Code  from CT_Zip 
	where  (CTZIP_Region_DR ->CTRG_Country_DR = :CTCountryDR) and (CTZIP_Province_DR =:CTProvinceDR) and (CTZIP_CITY_DR =:CTCityDR)
}

ClassMethod GetZipINfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", CTCountryDR As %String, CTProvinceDR As %String, CTCityDR As %String)
{
	;验证数据是否完整
	&sql(SELECT CTZIP_RowID , CTZIP_Code into :myID,:myDesc  from CT_Zip 
		where  (CTZIP_Region_DR ->CTRG_Country_DR = :CTCountryDR) 
			and (CTZIP_Province_DR =:CTProvinceDR) 
			and (CTZIP_CITY_DR =:CTCityDR))
	
	i +SQLCODE d
	
	if SQLCODE'=0 quit 0
	
	s myrtnvalue= $ZCVT(myID,"O","JS")_"^"_$ZCVT(myDesc,"O","JS")
	s myDesc=$ZCVT(myDesc,"O","JS")
	
	set retval=itmjs_"('"_myDesc_"');"
	if itmjsex'="""" set retval=retval_itmjsex_"('"_myrtnvalue_"');"
	;&javascript<#(retval)#>
	q 1
}

Query GetCTRelationInfo() As %SQLQuery(CONTAINID = 1)
{
	SELECT CTRLT_RowId, CTRLT_Desc from CT_Relation
}

Query GetEmployeeCompanyInfo(CODesc As %String) As %SQLQuery(CONTAINID = 1)
{
	select CTCO_RowID, CTCO_Desc from CT_Company
	where   UPPER(CTCO_Desc) %STARTSWITH UPPER(:CODesc) and CTCO_NotUseFlag="Yes"
}

}
