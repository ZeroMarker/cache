Import sqluser

/// creator:	 QianHuanjuan
/// createdate:	 2018-03-06
/// description: 小字典维护
Class web.DHCSTPIVAS.StkComDictionary Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// description: 字典列表	
/// input:		 $p(inputStr,"^",1)字典类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.StkComDictionary","StkComDictionary","PivasLabelSign")
Query StkComDictionary(inputStr = "") As websys.Query(ROWSPEC = "SCDIId,SCDICode,SCDIDesc,SCDIType")
{
}

ClassMethod StkComDictionaryExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	n (qHandle,inputStr)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s SCDIType=$p(inputStr,"^",1)
	q:SCDIType="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SCDI_RowID as SCDIId,SCDI_Code as SCDICode,SCDI_Desc as SCDIDesc FROM DHC_StkComDictionary where SCDI_Type='"_SCDIType_"' order by SCDI_Code"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s SCDIId= result.Data("SCDIId") 
	    s SCDICode= result.Data("SCDICode") 
	    s SCDIDesc= result.Data("SCDIDesc") 
        d outputStkComDictionary
    }
    d result.Close()
	Quit $$$OK
outputStkComDictionary
	i SCDIType="PivasLabelSign"  s SCDIType="标签标识"
	e  i SCDIType="PivasStoreCon" s SCDIType="储存条件"
	s Data=$lb(SCDIId,SCDICode,SCDIDesc,SCDIType)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存小字典信息
/// input:		 inputStr^1:代码,inputStr^2:名称,inputStr^3:类型id
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.StkComDictionary).SaveStkComDict("^qhj^焕娟测试^101")
ClassMethod SaveStkComDict(inputStr)
{
	n (inputStr)
	s id=$p(inputStr,"^",1)
	s code=$p(inputStr,"^",2)
	s desc=$p(inputStr,"^",3)
	s type=$p(inputStr,"^",4)
  	q:code="" "-1^字典代码不能为空"
  	q:desc="" "-1^字典名称不能为空"
  	q:type="" "-1^字典类型不能为空"
  	s errCode=""
  	i id="" d
  	.&SQL(SELECT SCDI_RowId FROM DHC_StkComDictionary WHERE SCDI_Code=:code and SCDI_Type=:type)
  	.i SQLCODE=0 s errCode="-1^该字典类型此代码已存在"
  	.q:errCode'=""
  	.&SQL(SELECT SCDI_RowId FROM DHC_StkComDictionary WHERE SCDI_Desc=:desc and SCDI_Type=:type)
  	.i SQLCODE=0 s errCode="-1^该字典类型此名称已存在"
  	.q:errCode'=""
  	e  d 
  	.&SQL(SELECT SCDI_RowId FROM DHC_StkComDictionary WHERE SCDI_Code=:code and SCDI_RowID!=:id and SCDI_Type=:type)
  	.i SQLCODE=0 s errCode="-1^该字典类型此代码已存在"
  	.q:errCode'=""
  	.&SQL(SELECT SCDI_RowId FROM DHC_StkComDictionary WHERE SCDI_Desc=:desc and SCDI_RowID!=:id and SCDI_Type=:type)
  	.i SQLCODE=0 s errCode="-1^该字典类型此名称已存在"
  	.q:errCode'=""
  	q:errCode'="" errCode
  	i id=""  d
  	.&sql(
  		insert into DHC_StkComDictionary 
  		(SCDI_Code,SCDI_Desc,SCDI_Type) 
  		values 
  		(:code,:desc,:type)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	e   d
	.&sql(
		update DHC_StkComDictionary 
		set SCDI_Code=:code,SCDI_Desc=:desc 
		where SCDI_RowID=:id  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除字典信息
/// w ##class(web.DHCSTPIVAS.StkComDictionary).DeleteStkComDict("2")
ClassMethod DeleteStkComDict(SCDIId)
{
	n (SCDIId)
	q:SCDIId="" "-1^Id为空"
	&sql(delete from DHC_StkComDictionary where SCDI_RowID=:SCDIId)
	q SQLCODE
}

}
