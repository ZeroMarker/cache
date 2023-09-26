/// Description: 配液小类维护
/// Creator:	 yunhaibao
/// Createdate:	 2019-04-02
Class web.DHCSTPIVAS.Cat Extends %RegisteredObject
{

Parameter AppTable [ Final ] = "DHC_PHCPivaCat";

Parameter LogSign [ Final ] = "配液中心 - 配液小类";

/// 代码在表记录中完全唯一
Parameter UniqueCode [ Final ] = {$$$YES};

/// Deccription:配液小类表格数据
/// Table:      User.DHCPHCPivaCat
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Cat","DHCPHCPivaCat")
Query DHCPHCPivaCat(HospId = "") As websys.Query(ROWSPEC = "catId,catCode,catDesc")
{
}

ClassMethod DHCPHCPivaCatExecute(ByRef qHandle As %Binary, HospId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCPivaCat_RowId as catId,PHCPivaCat_Code as catCode,PHCPivaCat_Desc as catDesc FROM SQLUSER.DHC_PHCPivaCat"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s Rowid=result.Data("catId")
	    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
        continue:flag="N"  
		s Data=$lb(result.Data("catId"),result.Data("catCode"),result.Data("catDesc"))
		s ^CacheTemp(repid,ind)=Data    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
}

/// Description: 保存配液小类
/// Input:		 inputStr^1:id,inputStr^2:代码,inputStr^4:名称
/// Return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.Cat).Save("1^热量2^热量2")
ClassMethod Save(inputStr, HospId = "")
{
	s id=$p(inputStr,"^",1)
	s code=$p(inputStr,"^",2)
	s desc=$p(inputStr,"^",3)
  	q:code="" "-1^代码不能为空"
  	q:desc="" "-1^名称不能为空"
  	s errCode=""
  	s errCode=..CheckExist(id, code, desc, HospId)
  	q:errCode'="" errCode
  	i id=""  d
  	.&sql(
  		insert into SQLUSER.DHC_PHCPivaCat 
  		(PHCPivaCat_Code,PHCPivaCat_Desc) 
  		values 
  		(:code,:desc)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_code_","_desc
  	.e  d
  	..s Rowid=$p(%ROWID,$c(1))
    ..i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
  	e   d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_PHCPivaCat", id)
	.&sql(
		update SQLUSER.DHC_PHCPivaCat 
		set PHCPivaCat_Code=:code,PHCPivaCat_Desc=:desc
		where PHCPivaCat_RowId=:id  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"_code_","_desc
	s rowID = $g(%ROWID)
	q:errCode'="" errCode
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_PHCPivaCat", rowID)
	s logType = $s(id = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHCPivaCat","User.DHCPHCPivaCat", ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0_"^保存成功"
}

/// Description: 批量保存
ClassMethod SaveMulti(inputData, HospId = "")
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..Save(iData, HospId)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 删除
/// w ##class(web.DHCSTPIVAS.Cat).Delete(1)
ClassMethod Delete(catId, HospId = "")
{
	q:catId="" "-1^Id为空" 
	&SQL(SELECT * FROM SQLUSER.PIVA_OrderLinkItm WHERE POLI_PHCPivaCat_Dr=:catId)  
	q:SQLCODE=0 "-1^该配液小类已维护于配液大类规则中,请核实"
	s logSignDesc=..GetDataLogSignDesc(catId)
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_PHCPivaCat", catId)
	&SQL(
		delete from SQLUSER.DHC_PHCPivaCat where PHCPivaCat_RowId=:catId
	)
	i SQLCODE=0 d
	.i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,catId,HospId)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHCPivaCat","User.DHCPHCPivaCat", ..#LogSign, catId, logSignDesc, "D", delJsonStr)
	q SQLCODE
}

ClassMethod CodeToID(code, HospId)
{
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
    q:(code="") ""
    q:(..#UniqueCode=$$$YES) $o(^PHCPIVACAT(0,"Code",code,""))
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^PHCPIVACAT(0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
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
	f  s Rowid=$o(^PHCPIVACAT(0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// description: 判断代码描述是否重复
/// return:      -1^验证信息
ClassMethod CheckExist(rowId, code, desc, HospId = "")
{
 	s errCode=""
 	s tmpId=..CodeToID(code,HospId)
 	i (tmpId'="")&&(tmpId'=rowId) s errCode="-1^代码已存在:"_code
	s tmpId=..DescToID(desc,HospId)
 	i (tmpId'="")&&(tmpId'=rowId) s errCode="-1^名称已存在:"_desc
	q errCode
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
		SELECT PHCPivaCat_Desc INTO :ret
		FROM SQLUSER.DHC_PHCPivaCat  
		WHERE %ID = :rowID
	)
	q $g(ret)
}

}
