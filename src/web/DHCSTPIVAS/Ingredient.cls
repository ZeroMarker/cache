Import sqluser

/// creator:	 yunhaibao
/// createdate:	 2018-02-23
/// description: 药学成分维护
Class web.DHCSTPIVAS.Ingredient Extends %RegisteredObject
{

Parameter AppTable [ Final ] = "PHC_Ingredient";

Parameter TableName [ Final ] = "PHC_Ingredient";

Parameter TableClassName [ Final ] = "User.PHCIngredient";

Parameter LogSign [ Final ] = "配液中心 - 药学成分字典";

/// deccription:药学成分字典列表
/// table:      User.PHCIngredient
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Ingredient","PHCIngredient")
Query PHCIngredient(inputStr = "", HospId = "") As websys.Query(ROWSPEC = "ingredId,ingredCode,ingredDesc,ingredDupli,ingredUomDesc,ingredUomId")
{
}

ClassMethod PHCIngredientExecute(ByRef qHandle As %Binary, inputStr = "", HospId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT INGR_RowId as ingredId,INGR_Code as ingredCode,INGR_Desc as ingredDesc,INGR_AllowDuplicate as ingredDupli,INGR_Uom_Dr as ingredUomId FROM PHC_Ingredient"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s ingredId= result.Data("ingredId") 
	    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,ingredId,HospId) //医院级别授权
        continue:flag="N"
	    s ingredCode= result.Data("ingredCode") 
	    s ingredDesc= result.Data("ingredDesc") 
	    s ingredDupli= result.Data("ingredDupli") 
	    s ingredUomId=result.Data("ingredUomId") 
	    i ingredUomId'=""  s ingredUomDesc=$p($g(^CT("UOM",ingredUomId)),"^",2)
	    e  s ingredUomDesc=""
        d outputPHCIngredient
    }
    d result.Close()
	Quit $$$OK
outputPHCIngredient
	s Data=$lb(ingredId,ingredCode,ingredDesc,ingredDupli,ingredUomDesc,ingredUomId)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存成分字典
/// input:		 inputStr^1:代码,inputStr^2:名称
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.Ingredient).SavePHCIngredient("^总液体量^总液体量")
ClassMethod SavePHCIngredient(inputStr, HospId = "")
{
	s id=$p(inputStr,"^",1)
	s code=$p(inputStr,"^",2)
	s desc=$p(inputStr,"^",3)
	s uomId=$p(inputStr,"^",4)
  	q:code="" "-1^代码不能为空"
  	q:desc="" "-1^名称不能为空"
  	s errCode=""
  	s tmpId=..CodeToID(code,HospId)
  	s:(tmpId'="")&&(tmpId'=id) errCode="-1^代码已存在:"_code
  	s tmpId=..DescToID(desc,HospId)
  	s:(tmpId'="")&&(tmpId'=id) errCode="-1^名称已存在:"_desc
  	q:errCode'="" errCode
  	s chkRes =..CheckReserveField(desc)
  	q:(chkRes '= $$$OK) chkRes
  	i id=""  d
  	.&sql(
        INSERT INTO PHC_Ingredient 
                (INGR_Code, INGR_Desc, INGR_Uom_Dr)
        VALUES 
                (:code,:desc,:uomId)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_code_","_desc
  	.e  d
    ..s Rowid=$p(%ROWID,$c(1))
    ..i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
  	e   d
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, id)
	.&sql(
        UPDATE PHC_Ingredient
        SET
        INGR_Code =:code, INGR_Desc =:desc, INGR_Uom_Dr =:uomId
        WHERE INGR_RowId =:id
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"_code_","_desc q
	q:errCode'="" errCode
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(id = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0_"^保存成功"
}

/// description: 批量保存
ClassMethod Save(inputData, HospId = "")
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SavePHCIngredient(iData,HospId)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 删除药学成分
ClassMethod DeleteIngred(ingredId, HospId = "")
{
	q:ingredId="" "-1^Id为空"
    s logSignDesc=..GetDataLogSignDesc(ingredId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, ingredId)

	&sql(delete from PHC_Ingredient where INGR_RowId=:ingredId)
	i SQLCODE=0  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,ingredId,HospId)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, ingredId, logSignDesc, "D", delJsonStr)
	q SQLCODE
}

ClassMethod CodeToID(code, HospId)
{
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^PHC("INGR",0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod DescToID(desc, HospId)
{
	s RetRowID=""
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^PHC("INGR",0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// w ##class(web.DHCSTPIVAS.Ingredient).CheckReserveField("身高")
ClassMethod CheckReserveField(desc)
{
	s dataList = $lb("总液体量", "身高", "体重", "体表面积")
	q:($lf(dataList, desc)) "-1^【"_ desc _ "】为系统预留, 请使用其他名称"
	q $$$OK
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
		SELECT INGR_Desc INTO :ret
		FROM SQLUSER.PHC_Ingredient  
		WHERE %ID = :rowID
	)
	q $g(ret)
}

}
