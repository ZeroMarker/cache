Import SQLUser

/// Creator：      cjb
/// CreatDate：   2009-07-03
/// Description:  药品质量报告统计类
Class web.DHCMedPVMINCItmSta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

/// 名称: StaByRepPlaceOpinion
/// 描述: 
/// 查询：获得符合条件的药物警戒报告
/// 编写者：cjb 
/// 编写日期: 2009-07-03
ClassMethod StaByRepPlaceOpinion(DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key, cReportType, Opinion)
{
	n (DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key,cReportType,Opinion)
	s n=0
	//s count=+$$QueryA^DHCMedPVMCom(DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key,cReportType,Opinion)
	s count=+##Class(web.DHCMedPVMRepCtl).QueryA(DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key,cReportType,Opinion)
	i count<0 -101  //无符合条件记录
	//
   f IndexApp=0:1:count d
   .s s=##Class(web.DHCMedPVMRepCtl).GetDataByIndex($j,IndexApp)
   .s Rowid=$p(s,"^",1)
   .s tmpRepPlace=$p(s,"^",14)
   .s tmpOpinion=$p(s,"^",12)
   .s ^CacheTemp("StaPVMByOpinion",$j,tmpRepPlace,tmpOpinion,Rowid)=""
   .s n=n+1
   q n-1_"^"_$j
}

ClassMethod QueryStaReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStaReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryStaReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, INCItm As %String, Key As %String, ReportType As %String, Opinion As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    //s:DateFrom'="" DateFrom=$zd($zdh(DateFrom,4),3)
    //s:DateTo'="" DateTo=$zd($zdh(DateTo,4),3)
    
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    
	s:DateFrom'="" DateFrom=$zd(DateFrom,3)
	s:DateTo'="" DateTo=$zd(DateTo,3)
	
	q:(DateFrom="")!(DateTo="") $$$OK
	//s Ret=$$QueryA^DHCMedPVMCom(DateFrom, DateTo, CtLoc, Status, INCItm, Key,ReportType,Opinion)
	s Ret=..StaByRepPlaceOpinion(DateFrom, DateTo, CtLoc, Status, INCItm, Key,ReportType,Opinion)
	q:+Ret<0 $$$OK
	s iCount=+Ret
	//s ^CacheTemp("StaPVMByOpinion",$j,tmpRepPlace,tmpOpinion,Rowid)=""
	s JIndex=$p(Ret,"^",2)
	d BuildDataRep
	
    k ^CacheTemp("StaPVMByOpinion",$j)
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDataRep
    //组织统计显示数据
    s (Price,Qty,PriceSum,PriceSub,Sum)=0
    s PlaceCode=0
    f  s PlaceCode=$o(^CacheTemp("StaPVMByOpinion",$j,PlaceCode)) q:PlaceCode=""  d
    .s OpinionCode=0
    .s s=..QueryByTypeCode("RepPlace",PlaceCode)
    .s:s'="" PlaceDesc=$p(s,"^",3)   //PlaceDesc=PlaceCode
    .f  s OpinionCode=$o(^CacheTemp("StaPVMByOpinion",$j,PlaceCode,OpinionCode)) q:OpinionCode=""  d
    ..s sPVMRowid=0
    ..s PriceSum=0
    ..//s s=..QueryByTypeCode("PVMOpinion",OpinionCode)
    ..//s:s'="" OpinionDesc=$p(s,"^",3)  OpinionDesc=OpinionCode
    ..f  s sPVMRowid=$o(^CacheTemp("StaPVMByOpinion",$j,PlaceCode,OpinionCode,sPVMRowid)) q:sPVMRowid=""  d
    ...s RepDate=+$p($g(^DHCMedPVMRep(sPVMRowid)),"^",15)
    ...s INCItmDr=$p($g(^DHCMedPVMRep(sPVMRowid)),"^",4)
    ...s Qty=+$p($g(^DHCMedPVMRep(sPVMRowid)),"^",6)
    ...s DescriptionCode=$p($g(^DHCMedPVMRep(sPVMRowid)),"^",9)
    ...s Description=..QueryByTypeCode("PVMDescription",DescriptionCode)
    ...s Description=$p(Description,"^",3)
    ...s Price=+$fn(+##Class(web.DHCMedPVMRepCtl).GetPriceByIncItm(INCItmDr,RepDate),"+","3")  //价格
    ...s INCItmDets=##Class(web.DHCMedPVMRepCtl).GetItmDetsById(INCItmDr)
    ...s INCItmDesc=$p(INCItmDets,"^",3)
    ...s UOM=##Class(web.DHCMedPVMRepCtl).GetCTUom(INCItmDr,RepDate)
    ...s:UOM'="" UOM=$p($g(^CT("UOM",UOM)),"^",2)    //单位
    ...s PriceSum=Price*Qty          //金额
    ...s Data=$lb("")
    ...s $li(Data,1)=PlaceDesc
    ...s $li(Data,2)=INCItmDesc
    ...s $li(Data,3)=UOM
    ...s $li(Data,4)=Qty
    ...s $li(Data,5)=Price
    ...s $li(Data,6)=PriceSum       //金额
    ...s $li(Data,7)=Description
    ...s ^CacheTemp(repid,ind)=Data
    ...s ind=ind+1
    ...s PriceSub=PriceSub+PriceSum   //小计的值
    ...s PlaceDesc=""
    .q:PriceSum=0
    .s Data=$lb("")
    .s $li(Data,1)="小计"
    .s $li(Data,2)=""
    .s $li(Data,3)=""
    .s $li(Data,4)=""
    .s $li(Data,5)=""
    .s $li(Data,6)=PriceSub
    .s $li(Data,7)=""
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    .s Sum=Sum+PriceSub        //合计的值
    .s PriceSub=0
    s Data=$lb("")
    s $li(Data,1)="合计"
    s $li(Data,2)=""
    s $li(Data,3)=""
    s $li(Data,4)=""
    s $li(Data,5)=""
    s $li(Data,6)=Sum
    s $li(Data,7)=""
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 	q
}

ClassMethod QueryStaReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStaReportExecute ]
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

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据综合条件查询药物警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       时间段，报告科室 报告状态 药物Rowid 报告类型
/// Output：      模糊查询出的药物警戒报告集
/// Return：      
/// Others： 
Query QueryStaReport(DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, INCItm As %String, Key As %String, ReportType As %String, Opinion As %String) As %Query(ROWSPEC = "RepPlace:%String:报告位置,INCItmDesc:%String:药品名称,UOM:%String:单位,Qty:%String:数量,Price:%String:单价,PriceSum:%String:金额,Description:%String:原因")
{
}

/// 通过字典类型、代码查询字典项
ClassMethod QueryByTypeCode(Type, Code)
{
	n (Type,Code)
    k PLIST,MLIST
    q:(Type="")!(Code="") -1
    q:'$d(^DHCMDIC("0","TypeCode",Type,Code)) -100
    s MDICRowid=$o(^DHCMDIC("0","TypeCode",Type,Code,""),-1)
    s s=..GetDictDataById(MDICRowid)
    q s
}

/// 通过RowID获取字典项目
ClassMethod GetDictDataById(MDICRowid)
{
    n (MDICRowid)
    q:'$d(^DHCMDIC(MDICRowid)) ""
    s s=$g(^DHCMDIC(MDICRowid))
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
    s s=MDICRowid_"^"_s
    q s
}

}
