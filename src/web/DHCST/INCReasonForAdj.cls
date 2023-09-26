Import sqluser

/// Descript:库存调整原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCST.INCReasonForAdj Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新调整原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForAdjustment
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCST.INCReasonForAdj).Save("^8^日常消耗")
ClassMethod Save(listData As %String, hosp) As %Library.String
{
	n (listData,hosp)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listData,rowDelim)
	s errInfo=""
	f i=1:1:len  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s dataMsg="代码:"_code_",名称:"_desc
	.s errCode=..CheckExist(rowid,code,desc,hosp)
 	.i errCode'="" d
 	..s errCode=$p(errCode,"^",2)_" "_dataMsg
 	..s errInfo=$s(errInfo="":errCode,1:errInfo_"</br>"_errCode)
 	.q:errCode'=""
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc)
	..i ret'=0 d 
	...s errCode="更新失败"_" "_dataMsg
	...s errInfo=$s(errInfo="":errCode,1:errInfo_"</br>"_errCode)
	.e  d
	..s ret=..Insert(code,desc)
	..i ret<0 d 
	...s errCode="插入失败"_" "_dataMsg
	...s errInfo=$s(errInfo="":errCode,1:errInfo_"</br>"_errCode)
	..e  d
	...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("INC_ReasonForAdjustment", ret, hosp)
	q:errInfo'="" errInfo
	q errInfo
}

/// Descript:	增加调整原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForAdjustment
/// Input:代码,描述
/// Output:		
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String) As %Library.String [ Private ]
{
	n (code,desc)
 	s type="G"
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	&sql(Insert into INC_ReasonForAdjustment(ADJ_Code,ADJ_Desc,ADJ_StkType)
 	values(:code,:desc,:type))
 	;b ;1
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:INC_ReasonForAdjustment",desc,SQLCODE_":"_%msg)
 	q:SQLCODE'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新调整原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForAdjustment
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc)
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	q:rowid="" ""
 	&sql(Update INC_ReasonForAdjustment set ADJ_Code=:code,ADJ_Desc=:desc
 	where ADJ_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:INC_ReasonForAdjustment",desc,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	删除调整原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForAdjustment
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
	n (rowid,hosp)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	&sql(Delete from INC_ReasonForAdjustment where ADJ_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:INC_ReasonForAdjustment",rowid,SQLCODE_":"_%msg)
 	e  d
 	.d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("INC_ReasonForAdjustment",rowid,hosp)
 	q SQLCODE
}

/// Descript:	查询调整原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForAdjustment
/// Input:
/// Output:		
/// Return：调整原因信息
ClassMethod SelectAll(hosp)
{
	n (hosp)
	s Type=..sssCode()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ADJ_Rowid as Rowid,ADJ_Code as Code,ADJ_Desc as Description,ADJ_StkType as StkType"_  
	" FROM INC_ReasonForAdjustment"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		s StkType = result.Data("StkType")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_ReasonForAdjustment",Rowid,hosp)="N"
		CONTINUE:(+Rowid=0)||((StkType'="")&(StkType'=Type))
		s Description = result.Data("Description")
		s tmp=Rowid_"^"_Code_"^"_Description
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc",count)
	k json
	Q resultString
}

/// creator:	 yunhaibao
/// createdate:  2017-12-31
/// description: 验证调整原因是否重复
ClassMethod CheckExist(rowId, code, desc, hosp)
{
	n (code,desc,rowId,hosp)
	s errCode=""
	s type=..sssCode()
	s sqlStr="SELECT ADJ_Rowid as rowID FROM INC_ReasonForAdjustment WHERE ADJ_StkType='"_type_"'"
	i rowId="" d
	.s newSqlStr=sqlStr_" AND ADJ_Code='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"INC_ReasonForAdjustment",hosp)
  	.i existFlag'="" s errCode="-1^代码已存在"
	.s newSqlStr=sqlStr_" AND ADJ_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"INC_ReasonForAdjustment",hosp)
  	.i existFlag'="" s errCode="-1^名称已存在"
	e  d
	.s newSqlStr=sqlStr_" AND ADJ_Code='"_code_"'"_" AND ADJ_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"INC_ReasonForAdjustment",hosp)
  	.i existFlag'="" s errCode="-1^代码已存在"
	.s newSqlStr=sqlStr_" AND ADJ_Desc='"_desc_"'"_" AND ADJ_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"INC_ReasonForAdjustment",hosp)
  	.i existFlag'="" s errCode="-1^名称已存在"
	q errCode
}

}
