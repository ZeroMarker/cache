/// Description: 库存项不可退药原因维护
/// Table:		 DHC_StkRefuseRetReason
Class web.DHCST.IncReasonForRefRet Extends %RegisteredObject
{

/// Description: 保存
/// w ##class(web.DHCST.IncReasonForRefRet).Save("^对对对","3")
ClassMethod Save(listData As %String, hosp) As %Library.String
{
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=0
	s err=""
	f i=1:1:len  q:err'=""  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=code
	.i rowid="" d
	..s sqlStr="SELECT RefRet_ROWID as rowID FROM SQLUSER.DHC_StkRefuseRetReason WHERE RefRet_Desc="_"'"_desc_"'"
	..s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"DHC_StkRefuseRetReason",hosp)
    ..i existFlag'="" s err="-2"
	.e  d
	..s sqlStr="SELECT RefRet_ROWID as rowID FROM SQLUSER.DHC_StkRefuseRetReason WHERE RefRet_Desc='"_desc_"' AND RefRet_ROWID!='"_rowid_"'"
	..s existFlag=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"DHC_StkRefuseRetReason",hosp)
    ..i existFlag'="" s err="-2"
	.q:err'=""
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(code,desc)
	..i ret="" s err=err_","_desc q
	..s rowid=ret
	.i rowid'="" d
	..d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHC_StkRefuseRetReason", rowid, hosp)
	q err
}

ClassMethod Insert(Code, Desc) As %String
{
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
	q:Code="" ""
    q:Desc="" ""
	&SQL(Insert Into SQLUSER.DHC_StkRefuseRetReason values :PLIST())
	s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkRefuseRetReason",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 0
    q $p(%ROWID,$c(1))
}

ClassMethod Update(RowId, Code, Desc) As %String
{
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
    q:Code="" ""
    q:Desc="" ""
    q:RowId="" ""
    s Err=0
	&SQL(Update SQLUSER.DHC_StkRefuseRetReason values :PLIST() where RefRet_ROWID=:RowId )
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkRefuseRetReason",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Description:	删除
ClassMethod Delete(rowid As %String, hosp As %String) As %Library.String
{
 	q:rowid="" ""
 	s Err=0
 	&SQL(SELECT INFO_RowId FROM SQLUSER.DHC_ItmAddionInfo WHERE INFO_RefRetReason_Dr=:rowid)
 	q:SQLCODE=0 -2
	&SQL(Delete SQLUSER.DHC_StkRefuseRetReason where RefRet_ROWID=:rowid )
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Delete:DHC_StkRefuseRetReason",rowid,SQLCODE_":"_%msg)
 	.s Err=-1
	e  d
	.d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_StkRefuseRetReason",rowid,hosp)
 	q Err
}

/// Descript:	查询
/// w ##class(web.DHCST.IncReasonForRefRet).SelectAll()
ClassMethod SelectAll(hosp = "")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "Select RefRet_ROWID As RowID,RefRet_Code As Code,RefRet_Desc As Name From SQLUSER.DHC_StkRefuseRetReason"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s RowId = result.Data("RowID")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkRefuseRetReason",RowId,hosp)="N"
		s Desc = result.Data("Name")
		s tmp=RowId_"^"_Desc
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Desc",count)
	k json
	Q resultString
}

}
