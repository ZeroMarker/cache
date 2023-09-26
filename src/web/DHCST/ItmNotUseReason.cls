Import sqluser

/// Descript:屏蔽库存项原因维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
Class web.DHCST.ItmNotUseReason Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新屏蔽库存项原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:数据串:rowid^描述,rowid^描述,
/// Output:		
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(listData As %String, hosp) As %Library.String
{
	n (listData,hosp)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=0
	s err=""
	f i=1:1:len  q:msg'=0  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.q:desc=""
	.s chkExist=..CheckExist(rowid,desc,hosp)
	.i chkExist'="" s msg=-2 q
 	.q:msg'=0
	.i rowid'=""  d
	..s ret=..Update(rowid,desc)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(desc)
	..i +ret>0 d
	...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHC_ItmNotUseReason", ret, hosp)
	..s:ret="" err=err_","_desc
	.
	q:msg'=0 msg
	q err
}

/// Descript:	增加屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:描述
/// Output:		
/// Return：rowid
ClassMethod Insert(Desc As %String) As %Library.String [ Private ]
{
	n (Desc)
 	;
 	;不能为空项
 	q:Desc="" ""
 	;
 	&sql(Insert into DHC_ItmNotUseReason(DIUR_Desc)
 	values(:Desc))
 	s Err=0
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Insert:DHC_ItmNotUseReason",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
 	q:Err'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:rowid,描述
/// Output:		
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Desc As %String) As %Library.String [ Private ]
{
	n (Rowid,Desc)
 	;
 	;不能为空项
 	q:Desc="" ""
 	q:Rowid="" ""
 	;
 	s Err=0
 	&sql(Update DHC_ItmNotUseReason set DIUR_Desc=:Desc where DIUR_Rowid=:Rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Update:DHC_ItmNotUseReason",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
 	q Err
}

/// Descript:	删除屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
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
 	s Err=0
 	&sql(Delete from DHC_ItmNotUseReason where DIUR_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Delete:DHC_ItmNotUseReason",rowid,SQLCODE_":"_%msg)
 	.s Err=-1
 	e  d
 	.d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_ItmNotUseReason",rowid,hosp)
 	q Err
}

/// Descript:	查询屏蔽原因信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmNotUseReason
/// Input:
/// Output:		
/// Return：屏蔽原因信息
ClassMethod SelectAll(hosp)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DIUR_Rowid as Rowid,DIUR_Desc"_  
	" FROM DHC_ItmNotUseReason"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_ItmNotUseReason",Rowid,hosp)="N"
		s Desc = result.Data("DIUR_Desc")
		s tmp=Rowid_"^"_Desc
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Desc",count)
	k json
	Q resultString
}

/// w ##class(web.DHCST.ItmNotUseReason).CheckExist(9,"ahhaha",3)
ClassMethod CheckExist(id, desc, hosp)
{
	n (id,desc,hosp)
	s errCode=""
	s type=..sssCode()
	s sqlStr="SELECT DIUR_RowID AS rowID FROM DHC_ItmNotUseReason WHERE 1=1"
	i id="" d
	.s newSqlStr=sqlStr_" AND DIUR_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_ItmNotUseReason",hosp)
  	.i existFlag'="" s errCode=-1
	e  d
	.s newSqlStr=sqlStr_" AND DIUR_Desc='"_desc_"'"_" AND DIUR_RowID!='"_id_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_ItmNotUseReason",hosp)
  	.i existFlag'="" s errCode=-1
	q errCode
}

}
