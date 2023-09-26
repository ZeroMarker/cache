/// 名称: DHCMed.INFService.RepConfigSrv
/// 描述: 基于报告表的数据常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-25
Class DHCMed.INFService.RepConfigSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的感染相关模块
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.RepConfigSrv","QryTypeConfig","1")
Query QryTypeConfig(TypeCode As %String) As %Query(ROWSPEC = "name:%String,value:%String,rowid:%String")
{
}

ClassMethod QryTypeConfigExecute(ByRef qHandle As %Binary, TypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
    q:TypeCode="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s dicID=""
 	f i=1:1:1  d
	.s Data=$lb("文本字段","''",i)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    s ^CacheTemp(repid,ind)=$lb("转归","''",2)
    s ind=ind+1
    s ^CacheTemp(repid,ind)=$lb("日期","new Date()",3)
    s ind=ind+1
    s ^CacheTemp(repid,ind)=$lb("是否","true",4)
    s ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-06-03
/// Description:  查询某类报告是否包含该模块
/// Table：       DHCMed.INF.Report
/// Input：       Code ： 模块编码  TypeCode:报告类型code
/// output:       符合条件的ID            
/// Return：      0 不包含  1  包含
/// w ##class(DHCMed.INFService.RepConfigSrv).IsReportPart("Drugs","1")
ClassMethod IsReportPart(Code As %String = "", TypeCode As %String = "") As %String
{
	n (Code,TypeCode)
	s ret=0
	q:TypeCode="" ret
	q:Code="" ret
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s CodeIdx=" "_$ZCVT(Code,"U")
 	//^DHCMed.INF.ReportI("TypePaadm",{Type},{Paadm_DR}
    s:$d(^DHCMed.INF.RepConfigI("TypeCode",TypeCodeIdx,CodeIdx)) ret=1
    q ret
}

/// w ##class(DHCMed.INFService.RepConfigSrv).PatientHaveOpr(Paadm)
ClassMethod PatientHaveOpr(Paadm As %String = "") As %Integer
{
  n (Paadm)
  s flag=0
  q:+Paadm=0 flag
  d GetOrdsOper       //取手术医嘱信息
  q flag
GetOrdsOper
    q:'$d(^OEORD(0,"Adm",+Paadm))     
    s oeord=$o(^OEORD(0,"Adm",+Paadm,""))
    //s HospCode=$$GetHospitalCode^DHCMedBase02()
    s objOeord=##class(DHCMed.Base.OeOrder).GetObjById(oeord)
    q:'$IsObject(objOeord)
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:(arcim="")!(flag'=0)  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .//S OrdCatSubDesc=$p($g(^ARC("IC",+ItmCat)),"^",2) // ARCICDesc
    .q:objCls.ORCATDesc'["手术"
    .//q:(HospCode="ShangHai_HSDY")&&(objCls.ARCICDesc'["普通手术")  // objCls.ARCICDesc
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:(ordDate="")!(flag'=0)  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:(oeoriSub="")!(flag'=0)  d
    ...s oeori=oeord_"||"_oeoriSub
    ...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
    ...q:'$IsObject(objOeorICls)
    ...// OEORIItemStatDR
    ...s OrderStatusDesc=objOeorICls.OSTATDesc
    ...s OrderStatusCode=objOeorICls.OSTATCode
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...s flag=1
}

}
