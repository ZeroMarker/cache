Import sqluser

/// Descript:退货原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCST.INCReasonForRet Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新退货原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForReturn
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCST.INCReasonForRet).Save("")
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
	.s errCode=..CheckExist(rowid, code, desc, hosp)
	.i errCode'="" s errInfo=$s(errInfo="":$p(errCode,"^",2),1:errInfo_"</br>"_$p(errCode,"^",2))
	.q:errCode'=""
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc)
	.e  d
	..s ret=..Insert(code,desc)
	..i ret'="" d
	...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("INC_ReasonForReturn", ret, hosp)
	q errInfo
}

/// Descript:	增加退货原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForReturn
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
 	&sql(Insert into INC_ReasonForReturn(RET_Code,RET_Desc,RET_StkType)
 	values(:code,:desc,:type))
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:INC_ReasonForReturn",desc,SQLCODE_":"_%msg)
 	q:SQLCODE'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新退货原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForReturn
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
 	&sql(Update INC_ReasonForReturn set RET_Code=:code,RET_Desc=:desc
 	where RET_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:INC_ReasonForReturn",desc,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	删除退货原因
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForReturn
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
 	&sql(Delete from INC_ReasonForReturn where RET_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:INC_ReasonForReturn",rowid,SQLCODE_":"_%msg)
 	e  d
 	.d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("INC_ReasonForReturn",rowid,hosp)
 	q SQLCODE
}

/// Descript:	查询退货原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
/// Table:INC_ReasonForReturn
/// Input:
/// Output:		
/// Return：退货原因信息
ClassMethod SelectAll(hosp)
{
	n (hosp)
	s Type="G"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RET_Rowid as Rowid,RET_Code as Code,RET_Desc as Description,RET_StkType as StkType"_  
	" FROM INC_ReasonForReturn"
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
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_ReasonForReturn",Rowid,hosp)="N"
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

/// description:判断代码名称重复
/// return:		-11 代码重复,-12 名称重复
/// w ##class(web.DHCST.INCReasonForRet).CheckEixst("2","1","")
ClassMethod CheckExist(id, code, desc, hosp)
{
	n (id,code,desc,hosp)
	s errCode=""
	i id="" d
	.s sqlStr="SELECT Ret_RowId as rowID FROM INC_ReasonForReturn WHERE RET_StkType='G' AND RET_Code='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"INC_ReasonForReturn",hosp)
  	.i existFlag'="" s errCode="-1^代码:"_code_",已存在!" q
	.s sqlStr="SELECT Ret_RowId as rowID FROM INC_ReasonForReturn WHERE RET_StkType='G' AND RET_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"INC_ReasonForReturn",hosp)
  	.i existFlag'="" s errCode="-1^名称:"_desc_",已存在!" q
	e  d
	.s sqlStr="SELECT Ret_RowId as rowID FROM INC_ReasonForReturn WHERE RET_StkType='G' AND RET_Code='"_code_"'"_"AND RET_Rowid!='"_id_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"INC_ReasonForReturn",hosp)
  	.i existFlag'="" s errCode="-1^代码:"_code_",已存在!" q
	.s sqlStr="SELECT Ret_RowId as rowID FROM INC_ReasonForReturn WHERE RET_StkType='G' AND RET_Desc='"_desc_"'"_"AND RET_Rowid!='"_id_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"INC_ReasonForReturn",hosp)
  	.i existFlag'="" s errCode="-1^名称:"_desc_",已存在!" q
	q errCode
}

}
