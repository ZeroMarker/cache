/// 名称: dt.Deploy
/// 描述: DtHealth、iCare的发布
/// 编写者：wuqk
/// 编写日期: 2010-11-23
Class dt.Deploy Extends %RegisteredObject
{

/// Creator：     wuqk
/// CreatDate：   2010-11-23
/// Description:  导出所有iCare平台的类
/// Input：       path：导出文件路径
/// d ##class(dt.Deploy).ExportICareClass("d:\tmp\class\")
ClassMethod ExportICareClass(path)
{
	d ##class(web.Util.UtilService).ExportClassforSVN("dt",path)
	d ##class(web.Util.UtilService).ExportClassforSVN("dtepr",path)
	d ##class(web.Util.UtilService).ExportClassforSVN("dtweb",path)
	d ##class(web.Util.UtilService).ExportClassforSVN("dtwebsys",path)
	d ##class(web.Util.UtilService).ExportClassforSVN("ext",path)
	q
}

/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  导出某段时间内修改的iCare平台的类
/// Input：       path：    导出文件路径
///               dateFrom：起始日期
///               dateTo：  截止日期
/// d ##class(dt.Deploy).ExportICareClassOnDate("d:\tmp\class\","2010-11-01","2010-11-02")
ClassMethod ExportICareClassOnDate(path, dateFrom, dateTo)
{
	d ##class(web.Util.UtilService).ExportClsforSVNOnDate("dt",path,dateFrom,dateTo)
	d ##class(web.Util.UtilService).ExportClsforSVNOnDate("dtepr",path,dateFrom,dateTo)
	d ##class(web.Util.UtilService).ExportClsforSVNOnDate("dtweb",path,dateFrom,dateTo)
	d ##class(web.Util.UtilService).ExportClsforSVNOnDate("dtwebsys",path,dateFrom,dateTo)
	d ##class(web.Util.UtilService).ExportClsforSVNOnDate("ext",path,dateFrom,dateTo)
	q
}

/// Creator：     wuqk
/// CreatDate：   2010-11-23
/// Description:  发布产品。在^DHCVERSION中记录各产品版本号
/// Input：       productCode：  产品代码
///               versionNumber：版本号
/// d ##class(dt.Deploy).ReleaseProduct("DtHealth","DtHealth6.9")
ClassMethod ReleaseProduct(productCode, versionNumber)
{
	s ^DHCVERSION(productCode,0)=versionNumber
	s ^DHCVERSION(productCode,$i(^DHCVERSION(productCode)),$zd(+$h,3))=versionNumber
	q
}

/// Creator：     wuqk
/// CreatDate：   2010-11-23
/// Description:  取产品当前版本号
/// Input：       productCode：  产品代码
/// w ##class(dt.Deploy).GetProductVersion("DtHealth")
ClassMethod GetProductVersion(productCode)
{
	s version=""
	q:productCode="" version
	s:$d(^DHCVERSION(productCode,0)) version=$g(^DHCVERSION(productCode,0))
	q version
}

/// Creator：     wuqk
/// CreatDate：   2010-11-23
/// Description:  取产品版本号历史
/// Input：       productCode：  产品代码
/// Output：      $c(1)分割的
/// w ##class(dt.Deploy).GetProductVerList("DtHealth")
ClassMethod GetProductVerList(productCode)
{
	s version=""
	q:productCode="" version
	q:'$d(^DHCVERSION(productCode)) version
	s index=0
	f  s index=$o(^DHCVERSION(productCode,index)) q:index=""  d
	.s date=$o(^DHCVERSION(productCode,index,""))
	.s verNum=$g(^DHCVERSION(productCode,index,date))
	.s version=version_date_" "_verNum_$c(1)
	q version
}

/// d ##class(dt.Deploy).WriteClass()
ClassMethod WriteClass(path)
{
	s arrarylistcls=""
	d $system.OBJ.GetPackageList(.arrarylistcls,"dt")
	zw arrarylistcls
	d $system.OBJ.GetPackageList(.arrarylistcls,"dtepr")
	zw arrarylistcls
	d $system.OBJ.GetPackageList(.arrarylistcls,"dtweb")
	zw arrarylistcls
	d $system.OBJ.GetPackageList(.arrarylistcls,"dtwebsys")
	zw arrarylistcls
	d $system.OBJ.GetPackageList(.arrarylistcls,"ext")
	zw arrarylistcls
	q
}

}
