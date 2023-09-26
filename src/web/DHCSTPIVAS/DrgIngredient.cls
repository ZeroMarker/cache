Import sqluser

/// creator:	 yunhaibao
/// createdate:	 2018-02-23
/// description: 药品药学成分维护
Class web.DHCSTPIVAS.DrgIngredient Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter TableName [ Final ] = "PHC_DrgIngredient";

Parameter TableClassName [ Final ] = "User.PHCDrgIngredient";

Parameter LogSign [ Final ] = "配液中心 - 药品成分字典";

/// deccription:药品列表
/// others:		
/// input:		inputStr^1:别名,inputStr^2:类组,inputStr^3:库存分类
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DrgIngredient","IncItm","^^")
Query IncItm(inputStr = "", HospId = "") As websys.Query(ROWSPEC = "phcdfId,incId,incDesc,incCode,incSpec")
{
}

ClassMethod IncItmExecute(ByRef qHandle As %Binary, inputStr = "", HospId = "") As %Status
{
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s locId=$s($d(%session):%session.Data("LOGON.CTLOCID"),1:"")
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s alias=$p(inputStr,"^",1)
    i alias'="" s alias="%"_$zcvt(alias,"U")_"%"
    s catGrpId=$p(inputStr,"^",2)
    s stkCatId=$p(inputStr,"^",3)  
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.;q:(locId'="")&&('$d(^INCI("IL_LOC",locId,inci)))
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",inci,HospId) //医院级别授权
	.q:flag="N"
	.d GetIncItm 
	Quit $$$OK
GetIncItm
	s incDesc=##class(PHA.COM.Data.Base).InciDesc(inci)
	q:$p(^INCI(inci,2),"^",9)="Y"
	s stkCat=$p(^INCI(inci,2),"^",2)
	q:(stkCatId'="")&&(stkCatId'=stkCat)
	s catGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s catGrp=$p(catGrpStr,"^",5)
	q:(catGrpId'="")&(catGrpId'=catGrp)
	s stkType=$p(catGrpStr,"^",3)
	q:stkType'="G"
	s arcItm=$p(^INCI(inci,1),"^",3)
	q:+arcItm=0
	s arcSub=+arcItm,arcVer=+$p(arcItm,"||",2)
	s phcdRowId=$p(^ARCIM(arcSub,arcVer,1),"^",12) // 药学Id
	q:+phcdRowId=0
	s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	s incCode=$p(^INCI(inci,1),"^",1)
	s exist=""
	i alias'="" d
	.&SQL(SELECT * FROM INC_ALIAS WHERE INCA_INCI_DR=:inci AND %ALPHAUP(INCA_TEXT) LIKE :alias )
	.i SQLCODE'=0 s exist=1
	q:exist'=""
	d outputIncItm
	q
outputIncItm
	s Data=$lb(phcdRowId,inci,incDesc,incCode,incSpec)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:药品成分列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DrgIngredient","PHCDrgIngredient","1")
Query PHCDrgIngredient(inputStr = "") As websys.Query(ROWSPEC = "drgIngredId,ingredId,ingredCode,ingredDesc,drgIngredQty,drgIngredUom,ingredUomDesc,eveFlag,drgIngredUomDesc")
{
}

ClassMethod PHCDrgIngredientExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s phcdRowId=$p(inputStr,"^",1)
    s phcdId=+phcdRowId
	s phcdIng=""
	f  s phcdIng=$o(^PHCDINGRED(phcdId,"DI",phcdIng)) q:phcdIng=""  d
	.s phcdIngRowId=phcdId_"||"_phcdIng
	.s ingredId=$p(^PHCDINGRED(phcdId,"DI",phcdIng),"^",1)
	.q:'$d(^PHC("INGR",ingredId))
	.s ingredCode=$p(^PHC("INGR",ingredId),"^",1)
	#; .s ingredDesc=$p(^PHC("INGR",ingredId),"^",2)
    .s ingredDesc=##class(PHA.COM.Data.Base).PHCIngredientDesc(ingredId)
	.s ingredUomId=$p(^PHC("INGR",ingredId),"^",4)
	.s ingredUomDesc=$p($g(^CT("UOM",+ingredUomId)),"^",2)
	.s drgIngredQty=$p(^PHCDINGRED(phcdId,"DI",phcdIng),"^",2)
	.s drgIngredUom=$p(^PHCDINGRED(phcdId,"DI",phcdIng),"^",3)	// 改存Id
	.s drgIngredUomDesc=##class(PHA.COM.Data.Base).UomDesc(drgIngredUom)
	.i drgIngredUomDesc="" s drgIngredUom=""
	.s drgIngredQty=$fn(drgIngredQty,"",$l($p(drgIngredQty,".",2)))
	.d outputPHCDrgIngredient 
	Quit $$$OK
outputPHCDrgIngredient
	s Data=$lb(phcdIngRowId,ingredId,ingredCode,ingredDesc,drgIngredQty,drgIngredUom,ingredUomDesc,"/",drgIngredUomDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 删除药品成分
ClassMethod DeleteDrgIngred(drgIngredId)
{
	q:drgIngredId="" "-1^Id为空"
    s logSignDesc=..GetDataLogSignDesc(drgIngredId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, drgIngredId)

	&SQL(
        DELETE
        FROM PHC_DrgIngredient
        WHERE PHCDI_RowID =:drgIngredId
    )
	
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, drgIngredId, logSignDesc, "D", delJsonStr)
	q SQLCODE
}

/// description: 保存药品成分
/// input:	     inputStr^1:药品成分Id,inputStr^2:药学项Id,inputStr^3:药学成分Id,inputStr^4:含量,inputStr^5:单位
/// w ##class(web.DHCSTPIVAS.DrgIngredient).SaveDrgIngred()
ClassMethod SaveDrgIngred(inputStr)
{
	s drgIngredId=$p(inputStr,"^",1)
	s phcdId=+$p(inputStr,"^",2)
	q:phcdId=0 "-1^药学项为空"
	s ingredId=+$p(inputStr,"^",3)
	q:ingredId=0 "-1^成分为空"
	s qty=+$p(inputStr,"^",4)
	q:qty="" "-1^含量为空"
	s uom=$p(inputStr,"^",5)
	//q:uom="" "-1^单位为空"
	s errCode=""
	i drgIngredId'=""  d //更新
	.&SQL(SELECT * FROM PHC_DrgIngredient WHERE PHCDI_Ingred_Dr=:ingredId and PHCDI_PHCD_ParRef=:phcdId and PHCDI_RowId!=:drgIngredId)
	.i SQLCODE=0 s errCode="-1^已维护该成分"
	.q:errCode'=""
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, drgIngredId)
    .&SQL(  
		Update PHC_DrgIngredient
		set PHCDI_Ingred_Dr=:ingredId,PHCDI_IngredQty=:qty,PHCDI_IngredUom=:uom
		where PHCDI_RowId=:drgIngredId
		)
	.i SQLCODE'=0 s errCode="-1^更新失败" 
	e  d
	.&SQL(SELECT * FROM PHC_DrgIngredient WHERE PHCDI_Ingred_Dr=:ingredId and PHCDI_PHCD_ParRef=:phcdId)
	.i SQLCODE=0 s errCode="-1^已维护该成分"
	.q:errCode'=""
	.s maxSub=$o(^PHCDINGRED(phcdId,"DI",""),-1)+1
	.&SQL(
		insert into PHC_DrgIngredient
		(PHCDI_PHCD_ParRef,PHCDI_ChildSub,PHCDI_Ingred_Dr,PHCDI_IngredQty,PHCDI_IngredUom)
		values
		(:phcdId,:maxSub,:ingredId,:qty,:uom)
		)
	.i SQLCODE'=0 s errCode="-1^插入失败" 
	q:errCode'="" errCode
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(drgIngredId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

	q 0_"^保存成功"
}

/// description: 批量保存
ClassMethod Save(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveDrgIngred(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
        SELECT PHCDI_PHCD_ParRef->PHCD_Name INTO :ret
        FROM PHC_DrgIngredient
        WHERE %ID = :rowID
	)
	q $g(ret)
}

}
