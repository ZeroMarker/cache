Import sqluser

/// Descript:	药品配液分类维护
/// Creator:    hulihua
/// CreateDate: 2016-12-15
Class web.DHCST.PHCPivaCat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   查询药品配液分类
/// Creator:    hulihua
/// CreateDate: 2016-12-15
/// Table:		DHC_PHCPivaCat
/// Input:
/// Output:     
/// Return：	药品配液分类窗口信息
/// w ##class(web.DHCST.PHCPivaCat).SelectAll()
ClassMethod SelectAll()
{
	s result = ##class(%Library.ResultSet).%New()
 	s sqlStr="select PHCPivaCat_RowId as RowId, PHCPivaCat_Code as Code,PHCPivaCat_Desc as Description from DHC_PHCPivaCat order by PHCPivaCat_RowId DESC"
	d result.Prepare(sqlStr)
 	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(Code.JsonObj).%New()
	While(result.Next())
	 {
		 s Rowid=result.Data("RowId")
		 CONTINUE:+Rowid=0
	 	 s Code=result.Data("Code")
	 	 s Desc=result.Data("Description")
		 s tmp=Rowid_"^"_Code_"^"_Desc
		 s count=count+1
		 d json.InsertRowData(tmp)
       }
 	d result.Close()
 	s resultString=json.getJsonData("RowId^Code^Desc",count)
 	k json
 	q resultString
}

/// Descript:   保存/更新药品配液分类
/// Creator:    hulihua
/// CreateDate: 2016-12-15
/// Table:		DHC_PHCPivaCat
/// Input:		数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCST.PHCPivaCat).Save("^dd^jsdkjasd")
ClassMethod Save(listData As %String) As %Library.String
{
	n (listData)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listData,rowDelim)
	s err=""
	f i=1:1:len d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.
	.i rowid'="" d
	..s ret=..Update(rowid,code,desc)
	..s:ret'=0 err=err_","_ret
	.e  d
	..s ret=..Insert(code,desc)
	..s:ret="" err=err_","_desc
	..s:ret=-1 err=-1
	..s:ret=-2 err=-2
	.
	q err
}

/// Descript:   增加药品配液分类
/// Creator:    hulihua
/// CreateDate: 2016-12-15
/// Table:		DHC_PHCPivaCat
/// Input:		代码,描述
/// Output:     
/// Return：	rowid
/// w ##class(web.DHCST.PHCPivaCat).Insert("19900","输注")
ClassMethod Insert(code As %String, desc As %String) As %Library.String
{
	n (code,desc)
	q:code="" 
	q:desc="" 
	q:$D(^PHCPIVACAT(0,"Code",code)) -1
	q:$D(^PHCPIVACAT(0,"Desc",desc)) -2
	&sql(Insert into DHC_PHCPivaCat (PHCPivaCat_Code,PHCPivaCat_Desc) values (:code,:desc))
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHCPivaCat",desc,SQLCODE_":"_%msg)
	q:SQLCODE'=0 ""
	q $p(%ROWID,$c(1))
}

/// Descript:   更新药品配液分类
/// Creator:    hulihua
/// CreateDate: 2016-12-15
/// Table:		DHC_PHCPivaCat
/// Input:		rowid^代码^描述
/// Output:     
/// Return：	rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc)
	q:rowid="" ""
	q:code="" ""
	q:desc="" ""
	&sql(Update DHC_PHCPivaCat set PHCPivaCat_Code=:code,PHCPivaCat_Desc=:desc where PHCPivaCat_RowId=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHCPivaCat",desc,SQLCODE_":"_%msg)
	q SQLCODE
}

/// Descript:   删除药品配液分类
/// Creator:    hulihua
/// CreateDate: 2016-12-15
/// Table:		DHC_PHCPivaCat
/// Input:		rowid
/// Output:     
/// Return：	0 – 成功，非0 ：失败
/// w ##class(web.DHCST.PHCPivaCat).Delete(84)
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
	q:rowid="" ""
	&sql(Delete from DHC_PHCPivaCat where PHCPivaCat_RowId=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_PHCPivaCat",rowid,SQLCODE_":"_%msg)
	q SQLCODE
}

}
