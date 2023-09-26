Import SQLUser

/// creator:dinghongying
/// createdate:20160614
/// descirpiton:门诊药房药房人员代码维护
Class web.DHCOUTPHA.Percode Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 药房人员代码列表
/// d ##class(web.DHCOUTPHA.Percode).jsGetPharmacyStaffList("2","30","100^^^0^0^0^0")
ClassMethod jsGetPharmacyStaffList(page, rows, params)
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsGetPharmacyStaffList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhCode:FindPhPer")
	s sc=result.Execute(params)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.s retvalue=result.%GetData(i)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Percode","jsGetPharmacyStaffList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Percode","jsGetPharmacyStaffList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Percode","jsGetPharmacyStaffList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Percode","jsGetPharmacyStaffList",pid)
	q ""
ErrorjsGetPharmacyStaffList
	k ^TMP("DHCST","web.DHCOUTPHA.Percode","jsGetPharmacyStaffList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.Percode"))
}

}
