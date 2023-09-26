Import sqluser

/// creator:	 QianHuanjuan
/// createdate:	 2018-03-01
/// description: 配置台维护
Class web.DHCSTPIVAS.ConfigTable Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter LogSign [ Final ] = "配液中心 - 配置台";

/// description:配置台列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.ConfigTable","PIVAConfigTable")
Query PIVAConfigTable(inputStr = "") As websys.Query(ROWSPEC = "configId,configCode,configDesc,configLoc,configLocId")
{
}

ClassMethod PIVAConfigTableExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	s HospId=$p(inputStr,"^",2)
	q:PivaLocId="" $$$OK
	q:(HospId="")&&(PivaLocId="") $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVACT_Rowid as configId,PIVACT_LOC_DR as configLoc,PIVACT_Code as configCode,PIVACT_Desc as configDesc FROM PIVA_ConfigTable"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s configId= result.Data("configId") 
	    s configLocId= result.Data("configLoc") 
	    continue:(PivaLocId'="")&&(PivaLocId'=configLocId)
	    continue:(HospId'="")&&(HospId'=$p(^CTLOC(configLocId),"^",22))
	    s configCode= result.Data("configCode") 
	    s configDesc= result.Data("configDesc")
        d outputConfigTable
    }
    d result.Close()
	Quit $$$OK
outputConfigTable
	s configLoc=##class(PHA.COM.Data.Base).LocDesc(configLocId)
	s Data=$lb(configId,configCode,configDesc,configLoc,configLocId)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存配置台信息
/// input:		 inputStr^1:id,inputStr^2:代码,inputStr^3:名称,inputStr^4:配置科室
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.ConfigTable).SaveConfigTable("^qhj^焕娟测试^101")
ClassMethod SaveConfigTable(inputStr)
{
	s id=$p(inputStr,"^",1)
	s code=$p(inputStr,"^",2)
	s desc=$p(inputStr,"^",3)
	s loc=$p(inputStr,"^",4)
  	q:code="" "-1^代码不能为空"
  	q:desc="" "-1^名称不能为空"
  	q:loc="" "-1^科室不能为空"
  	s errCode=""
  	i id="" d
  	.&SQL(SELECT PIVACT_Rowid FROM PIVA_ConfigTable WHERE PIVACT_Code=:code and PIVACT_LOC_DR=:loc)
  	.i SQLCODE=0 s errCode="-1^代码已存在:"_code
  	.q:errCode'=""
  	.&SQL(SELECT PIVACT_Rowid FROM PIVA_ConfigTable WHERE PIVACT_Desc=:desc and PIVACT_LOC_DR=:loc)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_desc
  	.q:errCode'=""
  	e  d 
  	.&SQL(SELECT PIVACT_Rowid FROM PIVA_ConfigTable WHERE PIVACT_Code=:code  and PIVACT_LOC_DR=:loc and PIVACT_Rowid!=:id)
  	.i SQLCODE=0 s errCode="-1^代码已存在:"_code
  	.q:errCode'=""
  	.&SQL(SELECT PIVACT_Rowid FROM PIVA_ConfigTable WHERE PIVACT_Desc=:desc  and PIVACT_LOC_DR=:loc and PIVACT_Rowid!=:id)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_desc
  	.q:errCode'=""
  	q:errCode'="" errCode
  	i id=""  d
  	.&sql(
  		insert into PIVA_ConfigTable 
  		(PIVACT_LOC_DR,PIVACT_Code,PIVACT_Desc) 
  		values 
  		(:loc,:code,:desc)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	e   d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_ConfigTable", id)
	.&sql(
		update PIVA_ConfigTable 
		set PIVACT_Code=:code,PIVACT_Desc=:desc ,PIVACT_LOC_DR=:loc
		where PIVACT_Rowid=:id  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"
	s rowID=%ROWID
	q:errCode'="" errCode
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_ConfigTable", rowID)
	s logType = $s(id = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_ConfigTable","User.PIVAConfigTable", ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	
	q 0_"^保存成功"
}

/// description: 删除配置台信息
/// w ##class(web.DHCSTPIVAS.ConfigTable).DeleteConfig("47")
ClassMethod DeleteConfig(configId)
{
	q:configId="" "-1^Id为空"
	s inst=$o(^PIVAWTi("PCTInst",configId,""))
	q:inst'="" "-2^该配置台已经和工作组关联,不可删除！"
	s logSignDesc=..GetDataLogSignDesc(configId)
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_ConfigTable", configId)
	&SQL(
		DELETE
		FROM PIVA_ConfigTable
		WHERE PIVACT_Rowid = :configId
	)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_ConfigTable","User.PIVAConfigTable", ..#LogSign, configId, logSignDesc, "D", delJsonStr)
	q SQLCODE
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
	.s saveRet=..SaveConfigTable(iData)
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
		SELECT PIVACT_LOC_DR->CTLOC_Desc || '-' || PIVACT_Desc INTO :ret
		FROM PIVA_ConfigTable 
		WHERE %ID = :rowID
	)
	q $g(ret)
}

}
