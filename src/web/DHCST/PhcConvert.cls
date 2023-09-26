Import sqluser

/// creator:	yunhaibao
/// createdate:	2018-10-19
/// description:草药颗粒剂转换系数维护(药学项间转换)
Class web.DHCST.PhcConvert Extends %RegisteredObject
{

/// creator:	yunhaibao
/// createdate: 20170821
/// description:获取草药处方类型
/// w ##class(%ResultSet).RunQuery("web.DHCST.PhcConvert","GetCMPrescType")
Query GetCMPrescType(StrParams = "", HospId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetCMPrescTypeExecute(ByRef qHandle As %Binary, StrParams = "", HospId = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
	Set qHandle=$lb(0,repid,0)
	s hosp=$p(StrParams,"^",1)
	if ##class(PHA.FACE.IN.Com).GetHospAut()="Y" {
		s hospIndex="HospDr_"_hosp
		s Code=0
	    for {
			s Code=$O(^DHCDocConfig(hospIndex,"CMPrescTypeList",Code))
			q:Code=""
			s Data=^DHCDocConfig(hospIndex,"CMPrescTypeList",Code)
			s Desc=$p(Data,"^",1)
			s Active=$p(Data,"^",2)
			continue:Active="N"
			set Data=$lb(Code,Desc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}		
	}else{
		s Code=0
	    for {
			s Code=$O(^DHCDocConfig("CMPrescTypeList",Code))
			q:Code=""
			s Data=^DHCDocConfig("CMPrescTypeList",Code)
			s Desc=$p(Data,"^",1)
			s Active=$p(Data,"^",2)
			continue:Active="N"
			set Data=$lb(Code,Desc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}

	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCST.PhcConvert","QueryPHCDrgMast","q","CNMedItemCat","3")
/// input: prescTypeId(对应code:DHCDocConfig)
Query QueryPHCDrgMast(strParams, prescTypeId = "", hosp = "") As websys.Query(ROWSPEC = "phcId,phcCode,phcDesc")
{
}

ClassMethod QueryPHCDrgMastExecute(ByRef qHandle As %Binary, strParams, prescTypeId = "", hosp = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	q:(strParams="")&&(prescTypeId="") $$$OK
	s hospAuthFlag=##class(PHA.FACE.IN.Com).GetHospAut()
	s arcItmCatStr=""
	i prescTypeId'="" d
	.i hospAuthFlag="" s arcItmCatStr=$g(^DHCDocConfig(prescTypeId))
	.e  s arcItmCatStr=$g(^DHCDocConfig("HospDr_"_hosp, prescTypeId))
	s arcItmCatList=$lfs(arcItmCatStr,"^")
	q:(prescTypeId'="")&&(arcItmCatStr="") $$$OK
	s inputAlias=$zcvt($p(strParams,"^",1),"U")
	// 药学项别名以医嘱项别名为准
	s phcId=0
	f  s phcId=$o(^PHCD(phcId)) q:phcId=""  d
	.q:+phcId=0
	.s phcdfId=phcId_"||"_1
	.s arcItmSub=$o(^ARCIM(0,"PHCDF",phcdfId,""))
	.q:arcItmSub=""
	.s arcItmId=arcItmSub_"||1"
	.s arcItmCatId=$p(^ARCIM(arcItmSub,1,1),"^",10)
	.q:arcItmCatId=""
	.q:$p($g(^ARC("IC",arcItmCatId)),"^",7)'="R"
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItmMast",arcItmId,hosp)="N"
	.q:(prescTypeId'="")&&($lf(arcItmCatList,arcItmCatId)=0)
	.q:(inputAlias'="")&&(+##class(web.DHCST.ARCALIAS).CheckArcAliasExist(arcItmId,inputAlias)<0)
	.s allStop="Y"
	.s incId=""
	.f  s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,incId)) q:(incId="")||(allStop="N")  d
	..q:+incId=0
	..s notUseFlag=$p(^INCI(incId,2),"^",9)
	..i notUseFlag'="Y" s allStop="N"
	.q:allStop="Y"
	.s phcCode=$p(^ARCIM(arcItmSub,1,1),"^",1)
	.s phcDesc=$p(^ARCIM(arcItmSub,1,1),"^",2)
	.s Data=$lb(phcId,phcCode,phcDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// creator:    yunhaibao
/// createdate: 2018-00-19
/// description:保存转换
/// w ##class(web.DHCST.PhcConvert).SavePhcConvert("6","CNMedItemCat^2837^1^CNMedKLItemCat^6^4")
ClassMethod SavePhcConvert(pcId, inputStr)
{
	//s ^TMPDHCSTPARAMS("web.DHCST.PhcConvert","SavePhcConvert")=$lb(pcId, inputStr)
	s errCode=""
	s fromType=$p(inputStr,"^",1)
	s fromPhcId=$p(inputStr,"^",2)
	s fromQty=+$p(inputStr,"^",3)
	s toType=$p(inputStr,"^",4)
	s toPhcId=$p(inputStr,"^",5)
	s toQty=+$p(inputStr,"^",6)
	s hosp=+$p(inputStr,"^",7)
	q:fromQty'>0 "-1^"_..Trans("数量不能小于或等于0")
	q:toQty'>0 "-1^"_..Trans("转换不能小于或等于0")
	q:fromType=toType "-1^"_..Trans("类型相同")
	q:fromPhcId=toPhcId "-1^"_..Trans("药品相同")
	s existRet=..CheckExist(pcId,fromPhcId,toPhcId,hosp)
	q:existRet'="" existRet
	i pcId="" d
	.s convertObj=##class(User.DHCPhcConvert).%New()
	e  d
	.s convertObj=##class(User.DHCPhcConvert).%OpenId(pcId)
	.d convertObj.%Reload()
	s convertObj.PCFromType=fromType
	s convertObj.PCFromPhcDr=##class(User.PHCDrgMast).%OpenId(fromPhcId,0)
	s convertObj.PCFromNum=fromQty
	s convertObj.PCToType=toType
	s convertObj.PCToPhcDr=##class(User.PHCDrgMast).%OpenId(toPhcId,0)
	s convertObj.PCToNum=toQty
	s sc=convertObj.%Save()
	s errinfo=""
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR("","User.DHCPhcConvert",errinfo)
	.s errCode="-2^"_errinfo
	q:errCode'="" errCode
	s rowID=convertObj.%Id()
	d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHC_PhcConvert", rowID, hosp)
	q rowID
}

ClassMethod DeleteDHCPhcConvert(RowId, Hosp = "") As %String
{
	&SQL(Delete DHC_PhcConvert where PC_RowId=:RowId)
	q:SQLCODE'=0 SQLCODE
	d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_PhcConvert", RowId, Hosp)
	q SQLCODE
}

/// description: 查询转换关系表格数据
/// d ##class(%ResultSet).RunQuery("web.DHCST.PhcConvert","Query","^858")
Query Query(strParams As %String = "") As websys.Query(ROWSPEC = "pcId,fromTypeDesc,fromPhcDesc,fromNum,toTypeDesc,toPhcDesc,toNum")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, strParams As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s Type=$p(strParams,"^",1)
	s PhcId=$p(strParams,"^",2)
	s HospId=$p(strParams,"^",3)
	s hospDr = "HospDr_"_HospId
	s pcId=0
	f  s pcId=$o(^DHCPHCCONVERT(pcId)) q:pcId=""  d
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PhcConvert",pcId,HospId)="N"
	.s fromType=$p(^DHCPHCCONVERT(pcId),"^",1)
	.q:fromType=""
	.q:(Type'="")&&(fromType'=Type)
	.s fromPhcDr=$p(^DHCPHCCONVERT(pcId),"^",2)
	.q:(PhcId'="")&&(PhcId'=fromPhcDr)	
	.s toType=$p(^DHCPHCCONVERT(pcId),"^",4)
	.s toPhcDr=$p(^DHCPHCCONVERT(pcId),"^",5)
	.s fromTypeDesc=$p($g(^DHCDocConfig(hospDr,"CMPrescTypeList",fromType)),"^",1)
	.s fromPhcDesc=$p(^PHCD(fromPhcDr,1),"^",2)
	.s fromNum=$p(^DHCPHCCONVERT(pcId),"^",3)
	.s toTypeDesc=$p($g(^DHCDocConfig(hospDr,"CMPrescTypeList",toType)),"^",1)
	.s toPhcDesc=$p(^PHCD(toPhcDr,1),"^",2)
	.s toNum=$p(^DHCPHCCONVERT(pcId),"^",6)
	.d outputRow
	Quit $$$OK
outputRow
	s Data=$lb(pcId,fromTypeDesc,fromPhcDesc,fromNum,toTypeDesc,toPhcDesc,toNum)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:	dinghongying
/// createdate: 2017-08-11
/// description:根据Id获取维护信息
/// input:      strParams
/// return:     代码^描述
/// d ##class(%ResultSet).RunQuery("web.DHCST.PhcConvert","QueryByRowId",1)
Query QueryByRowId(strParams As %String) As websys.Query(ROWSPEC = "cmbFPrescType,cmbFPhcDrg,cmbFPhcDrg_text,txtFQty,cmbTPrescType,cmbTPhcDrg,cmbTPhcDrg_text,txtTQty")
{
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, strParams As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s rowId=+$p(strParams,"^",1)
	q:rowId=0 $$$OK
	s Data=$g(^DHCPHCCONVERT(rowId))
	s fType=$p(Data,"^",1)
	s fPhcId=$p(Data,"^",2)
	s fPhcDesc=$p(^PHCD(fPhcId,1),"^",2)
	s fNum=$p(Data,"^",3)
	s tType=$p(Data,"^",4)
	s tPhcId=$p(Data,"^",5)
	s tPhcDesc=$p(^PHCD(tPhcId,1),"^",2)
	s tNum=$p(Data,"^",6)
	s Data=$lb(fType,fPhcId,fPhcDesc,fNum,tType,tPhcId,tPhcDesc,tNum)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-08-22
/// description:判断颗粒剂转换系数关系是否存在
/// return:		空-不存在,其他存在
/// w ##class(web.DHCST.PhcConvert).CheckExist("","2971","2664","")
/// w ##class(web.DHCST.PhcConvert).CheckExist("","2664","2971","")
ClassMethod CheckExist(rowId, fromPhcId, toPhcId, hosp = "")
{
	s sqlStr="SELECT PC_RowId AS rowID FROM DHC_PhcConvert"_
			 " WHERE PC_FromPhc_Dr="_fromPhcId_" AND PC_ToPhc_Dr="_toPhcId
	i rowId'="" d
	.s newSqlStr=sqlStr_" AND PC_RowId!='"_rowId_"'"
	e  s newSqlStr=sqlStr
	s existID=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_PhcConvert",hosp)
	q:existID'="" -1_..Trans("^药品转换系数已存在")
	
	s sqlStr="SELECT PC_RowId AS rowID FROM DHC_PhcConvert"_
			 " WHERE PC_FromPhc_Dr="_toPhcId_" AND PC_ToPhc_Dr="_fromPhcId
	i rowId'="" d
	.s newSqlStr=sqlStr_" AND PC_RowId!='"_rowId_"'"
	e  s newSqlStr=sqlStr
	s existID=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_PhcConvert",hosp)
	q:existID'="" -1_..Trans("^药品转换系数已存在")
	q ""
}

/// creator:    yunhaibao
/// createdate: 2018-10-19
/// description:给医生站接口
/// 			根据医嘱项+数量返回转换后的医嘱项+数量
/// 			
/// input:      arcItmId(医嘱项ID),qty(数量),type(转换后的类型)
/// return:		$p(retVal,"^",1)<0转换失败,$p(retVal,"^",2)失败原因
/// 成功返回    医嘱项ID^转换后数量!!医嘱项ID^转换后数量		
/// w ##class(web.DHCST.PhcConvert).GetPhcConvertByArcim("4798||1","1","")
ClassMethod GetPhcConvertByArcim(arcItmId, qty, type = "", hosp = "")
{
	q:qty="" -1_..Trans("^数量为空")
	s arcSub=$p(arcItmId,"||",1)
	s arcVer=$p(arcItmId,"||",2)
	q:+arcSub=0 -1_..Trans("^医嘱项为空")
	s phcfId=$p(^ARCIM(arcSub,1,1),"^",12)
	q:+phcfId=0 "-1^"_..Trans("不存在药学项")
	//q:type="" -1_..Trans("^转换类型为空")
	s phcId=+phcfId
	s newPcId=""
	s changeFlag=""
	k NewPhcIdData
	s newPhcId=""
	f  s newPhcId=$o(^DHCPHCCONVERT(0,"FromTo",phcId,newPhcId)) q:(newPhcId="")  d // 正向转换
	.s pcId=""
	.f  s pcId=$o(^DHCPHCCONVERT(0,"FromTo",phcId,newPhcId,pcId)) q:(pcId="")  d
	..q:+pcId=0
	..q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PhcConvert",pcId,hosp)="N"
	..s toType=$p(^DHCPHCCONVERT(pcId),"^",4)
	..q:(type'="")&&(toType'=type)
	..s newPcId=pcId
	..s NewPhcIdData(newPcId)="+"_"^"_newPhcId
	i newPcId="" d
	.s newPhcId=""
	.f  s newPhcId=$o(^DHCPHCCONVERT(0,"ToFrom",phcId,newPhcId)) q:(newPhcId="")  d // 反向转换
	..s pcId=""
	..f  s pcId=$o(^DHCPHCCONVERT(0,"ToFrom",phcId,newPhcId,pcId)) q:(pcId="")  d
	...q:+pcId=0
	...q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PhcConvert",pcId,hosp)="N"
	...s fromType=$p(^DHCPHCCONVERT(pcId),"^",1)
	...q:(type'="")&&(fromType'=type)
	...s newPcId=pcId	
	...s NewPhcIdData(newPcId)="-"_"^"_newPhcId
	q:'$d(NewPhcIdData)="" -1_..Trans("^不存在转换关系")
	s retStr=""
	s newPcId=""
	f  s newPcId=$o(NewPhcIdData(newPcId)) q:newPcId=""  d
	.s fromQty=$p(^DHCPHCCONVERT(newPcId),"^",3)
	.s toQty=$p(^DHCPHCCONVERT(newPcId),"^",6)
	.s verFlag=$p(NewPhcIdData(newPcId),"^",1)
	.s newPhcId=$p(NewPhcIdData(newPcId),"^",2)
	.i verFlag="+" d // +
	..s newPhcId=$p(^DHCPHCCONVERT(newPcId),"^",5)
	..s newQty=qty/fromQty*toQty
	.e  d			 // - 
	..s newPhcId=$p(^DHCPHCCONVERT(newPcId),"^",2)
	..s newQty=qty/toQty*fromQty
	.s newArcSub=$o(^ARCIM(0,"PHCDF",newPhcId_"||1",""))
	.q:+newArcSub=0
	.s newArcItm=newArcSub_"||"_1_"^"_newQty
	.i retStr="" s retStr=newArcItm
	.e  s retStr=retStr_"!!"_newArcItm
	q:retStr="" "-1^"_..Trans("不存在转换后的医嘱项")
	q retStr
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.easyui.phcconvert.csp",Text)
}

}
