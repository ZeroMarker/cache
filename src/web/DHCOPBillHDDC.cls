Import SQLUser

Class web.DHCOPBillHDDC Extends BILL.COM.Abstract
{

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","HDDCDetail",2)
Query HDDCDetail(LocSortingDR As %String, OrdType As %String) As websys.Query(ROWSPEC = "TLocSorting:%String,TBloodDis:%String,AddDate:%String,ModDate:%String,RowID:%String,TLocSortingDR")
{
}

ClassMethod HDDCDetailExecute(ByRef qHandle As %Binary, LocSortingDR As %String, OrdType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set HDDCROWID=0
	for  set HDDCROWID=$o(^DHCOPBillHDDC(HDDCROWID))  quit:(HDDCROWID="")  do
	.set HDDCData=$g(^DHCOPBillHDDC(HDDCROWID))
	.quit:(HDDCData="")
	.set HosDisid=$p(HDDCData,"^",1)
	.set locid=$p(HDDCData,"^",2)
	.//quit:(LOCDR'="")&&(LOCDR'=locid)
	.quit:'$d(^DHCLocSorting(locid))
	.set myOrderType=$p($g(^DHCLocSorting(locid)),"^",9)
	.quit:((OrdType'="")&&(myOrderType'=OrdType))
	.set loc=$s((locid'=""):$p($g(^DHCLocSorting(locid)),"^",2),1:"")
	.set Place=$p(HDDCData,"^",3)
	.set AddDate=$p(HDDCData,"^",4)
	.if (AddDate'="") set AddDate=##class(websys.Conversions).DateLogicalToHtml(AddDate)
	.set ModDate=$p(HDDCData,"^",5)
	.if (ModDate'="") s ModDate=##class(websys.Conversions).DateLogicalToHtml(ModDate)
	.do OutputRowHDDC
	
	quit $$$OK
OutputRowHDDC
	set Data=$lb(loc,Place,AddDate,ModDate,HDDCROWID,locid)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// w ##class(web.DHCOPBillHDDC).AddHDDCDetail(6,"242")
ClassMethod AddHDDCDetail(LocSortingDR, place)
{
	quit:$d(^DHCOPBillHDDC(0,"LocDR",LocSortingDR)) "-1005"	;一个科别分类只能维护一个地点
	set Date=+$h
	&sql(insert into DHC_OPBillHDDC(LOC_DR,Place,Add_Date)values(:LocSortingDR,:place,:Date))
	set HDDCRowID=%ROWID
	quit SQLCODE_"^"_HDDCRowID
}

ClassMethod ModFiyHDDCDetail(locid, place, id)
{
	set Date=+$h
	&sql(UPDATE DHC_OPBillHDDC SET Place=:place,Mod_Date=:Date WHERE HDDC_Rowid=:id)
	quit SQLCODE
}

/// w ##class(web.DHCOPBillHDDC).DelHDDCDetail(167)
ClassMethod DelHDDCDetail(id)
{
	&sql(DELETE FROM DHC_OPBillHDDC WHERE HDDC_Rowid=:id)
	quit SQLCODE
}

/// 2011-9-22
/// 根据传入的科室id查询采血地点
/// w ##class(web.DHCOPBillHDDC).findLOCBloodDis("255631||12")
ClassMethod findLOCBloodDis(OEORIDR, OrderType)
{
 	quit:(+OEORIDR=0) ""
	
	set UserDepartment=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),7)),"^",2) ;开单科室DR
	quit:(UserDepartment="") ""
	set ArcimDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",2)   ;OEORI_ItmMast_DR
	set Place=""
	set LSLRowID=""
	for  set LSLRowID=$o(^DHCLocSortingLinkLoc(0,"CTLoc",UserDepartment,LSLRowID),-1) quit:(LSLRowID="")  do
	.set LocSortingDR=$p(^DHCLocSortingLinkLoc(LSLRowID),"^",1)
	.set myOrderType=$p($g(^DHCLocSorting(LocSortingDR)),"^",9)
	.quit:((OrderType'="")&&(OrderType'=myOrderType))
	.set s=$g(^DHCLocSortingLinkLoc(LSLRowID))
	.set DLSDR=$p(s,"^",1)
	.set HDDCRowID=$o(^DHCOPBillHDDC(0,"LocDR",DLSDR,""),-1)
	.quit:(HDDCRowID="")
	.set Place=$p(^DHCOPBillHDDC(HDDCRowID),"^",3)
	.set Sub=0
	.for  set Sub=$o(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub)) quit:(Sub="")  do
	..set myArcimeDR=$p(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub),"^",1)
	..quit:(myArcimeDR'=ArcimDR)
	..set ArcimePlace=$p(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub),"^",2)   ;如果有特殊项目，则取特殊项目上维护的地点
	..if (ArcimePlace'="") do
	...set Place=ArcimePlace
	
	quit Place
}

/// 2011-9-26
/// 根据传入的医院id查询出科室为采血地点（只能有一条）
/// w ##class(web.DHCOPBillHDDC).findHOSBloodDis(3)
ClassMethod findHOSBloodDis(Hosid)
{
	set Place=""
	quit:(Hosid="") ""
	set HDDCROWID=0
	for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"HISDR",Hosid,HDDCROWID))  quit:((HDDCROWID="")||(Place'=""))  do
	.set locid=$p(^DHCOPBillHDDC(HDDCROWID),"^",2)
	.quit:(locid'="")
	.set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	quit Place
}

/// Creator: Lid
/// CreatDate: 2012-7-11
/// Description: 获取科室类别
/// Table： 
/// Input： 
/// Output： 科室列表   
/// Others： d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","FindCTLoc","FK")
Query FindCTLoc(HosDisDR As %String, CTLOC As %String = "") As websys.Query(ROWSPEC = "Desc:%String,HIDDEN:%String")
{
}

ClassMethod FindCTLocExecute(ByRef qHandle As %Binary, CTLOC As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
  	set CTLOC=$$ALPHAUP^SSUTIL4(CTLOC)

	set AdmType=""
	for  set AdmType=$o(^PAC("ADMLOC",0,"AdmType",AdmType)) quit:(AdmType="")  do
  	.quit:(" O E "'[(" "_AdmType_" "))
  	.set LocDR=0
  	.for  set LocDR=$o(^PAC("ADMLOC",0,"AdmType",AdmType,LocDR)) quit:(LocDR="")  do
  	..set Hisctid=$p(^CTLOC(LocDR),"^",22)
	..set Desc=$p(^CTLOC(LocDR),"^",2)
	..//quit:((HosDisDR'="")&&(HosDisDR'=Hisctid))
	..quit:(CTLOC'="")&&(Desc'[CTLOC)
	..set desc=$p(^CTLOC(LocDR),"^",2)
	..do OutputCTLoc
  	
	quit $$$OK

OutputCTLoc
	set Data=$lb(desc,LocDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: Lid
/// CreatDate: 2012-7-12
/// Description: 获取科室分类
/// Table：       
/// Input： 
/// Output：
/// Others: d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","FindLocSorting","")
Query FindLocSorting(LocSorting As %String = "", OrdType As %String = "") As websys.Query(ROWSPEC = "LocSortingDesc:%String,LocSortingCode:%String,LocSortingDR:%String")
{
}

ClassMethod FindLocSortingExecute(ByRef qHandle As %Binary, LocSorting As %String = "", OrdType As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
  	set LocSorting=$$ALPHAUP^SSUTIL4(LocSorting)

  	set LocSortingDR=0
  	for  set LocSortingDR=$o(^DHCLocSorting(LocSortingDR)) quit:(LocSortingDR="")  do
  	.set LocSortData=$g(^DHCLocSorting(LocSortingDR))
  	.quit:(LocSortData="")
	.set LocSortingCode=$p(LocSortData,"^",1)
	.set LocSortingDesc=$p(LocSortData,"^",2)
	.set myOrdType=$p(LocSortData,"^",9)
	.quit:(OrdType'="")&&(OrdType'=myOrdType)
	.quit:(LocSorting'="")&&(LocSortingDesc'[LocSorting)&(LocSortingCode'[LocSorting)
	.do OutputRow1
 	
	quit $$$OK

OutputRow1
	set Data=$lb(LocSortingDesc,LocSortingCode,LocSortingDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: Lid
/// CreatDate: 2012-07-11
/// Description: 获取科室列表
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillHDDC).ReadSelRecLocListBroker("DHCWeb_AddToListA","CTLocList","jz","17","N")
ClassMethod ReadSelRecLocListBroker(JSFunName, ListName, Condition, LocSortingDR, OrderType)
{
	//查询已经做过关联的科室列表
	set LinkLoc=..GetLocSortingLinkLocStr(LocSortingDR, OrderType)
	set myIdx=0
	Kill TMPLocAry($j)
	set Condition=$$ALPHAUP^SSUTIL4(Condition)
	set AdmType=""
	for  set AdmType=$o(^PAC("ADMLOC",0,"AdmType",AdmType)) quit:(AdmType="")  do
	.quit:(" O E "'[(" "_AdmType_" "))
	.set LocDR=0
  	.for  set LocDR=$o(^PAC("ADMLOC",0,"AdmType",AdmType,LocDR)) quit:(LocDR="")  do
  	..set Hisctid=$p(^CTLOC(LocDR),"^",22)
	..set Desc=$p(^CTLOC(LocDR),"^",2)
	..//quit:((HosDisDR'="")&&(HosDisDR'=Hisctid))
	..quit:((Condition'="")&&(Desc'[Condition))
	..//quit:("^"_LinkLoc_"^")[("^"_LocDR_"^")
	..set Flag=##class(web.DHCOPBillHDDC).CheckLocLinkFlag(LocDR, OrderType)
	..quit:(Flag=1)	;一个科室只能与一个医嘱分类中的一个科室分类相关联。
	..set mydes=$p(^CTLOC(LocDR),"^",2)
	..quit:$d(TMPLocAry($j,LocDR))	;一个科室只加一遍
	..set TMPLocAry($j,LocDR)=""
	..set myval=LocDR_"^"_mydes_"^"
	..set mySelFlag=0
	..set rtnval=JSFunName_"('"_ListName_"','"_$zcvt($g(mydes),"O","JS")_"','"_$zcvt($g(myval),"O","JS")_"','"_$zcvt($g(myIdx),"O","JS")
	..set rtnval=rtnval_"','"_$zcvt(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..set myIdx=myIdx+1
	kill TMPLocAry($j)
	
	q 0
}

/// Creator: Lid
/// CreatDate: 2013-01-23
/// Description: 判断一个科室是否在指定的医嘱分类中做过关联。
/// 		注：一个科室只能与一个医嘱分类中的一个科室分类相关联。
/// Input:
/// Return: 0：没有关联，1：已经关联
/// Debug: w ##class(web.DHCOPBillHDDC).CheckLocLinkFlag("","N")
ClassMethod CheckLocLinkFlag(LocDR, OrderType)
{
	set Flag=0
	
	set SLLDR=0
	for  set SLLDR=$o(^DHCLocSortingLinkLoc(0,"CTLoc",LocDR,SLLDR)) quit:((SLLDR="")||(Flag=1))  do
	.set LocSortData=$g(^DHCLocSortingLinkLoc(SLLDR))
  	.quit:(LocSortData="")
	.set LocSortingDR=$p(LocSortData,"^",1)
	.set myOrderType=$p($g(^DHCLocSorting(LocSortingDR)),"^",9)
	.quit:((OrderType'="")&&(OrderType'=myOrderType))
	.set Flag=1
	
	quit Flag
}

/// Creator: Lid
/// CreatDate: 2012-07-12
/// Description: 获取科室分类关联的科室列表
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillHDDC).ReadLocSortingLinkLocListBroker("DHCWeb_AddToListA","LocSortingLinkLocList","2")
ClassMethod ReadLocSortingLinkLocListBroker(JSFunName, ListName, LocSortingDR, OrderType)
{
	set myIdx=0
	set SLLRowID=0
	for  set SLLRowID=$o(^DHCLocSortingLinkLoc(0,"DLS",LocSortingDR,SLLRowID)) quit:(SLLRowID="")  do
	.set myOrderType=$p($g(^DHCLocSorting(LocSortingDR)),"^",9)
	.quit:((OrderType'="")&&(OrderType'=myOrderType))
	.set myCTLocDR=$p(^DHCLocSortingLinkLoc(SLLRowID),"^",2)
	.set myCTLocDesc=$p(^CTLOC(myCTLocDR),"^",2)
	.set myValue=myCTLocDR_"^"_myCTLocDesc_"^"_LocSortingDR
	.set mySelFlag=0
	.set rtnval=JSFunName_"('"_ListName_"','"_$zcvt($g(myCTLocDesc),"O","JS")_"','"_$zcvt($g(myValue),"O","JS")_"','"_$zcvt($g(myIdx),"O","JS")
	.set rtnval=rtnval_"','"_$zcvt(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.set myIdx=myIdx+1
	quit 0
}

/// Creator: Lid
/// CreatDate: 2012-07-12
/// Description: 根据科室分类指针获取科室分类关联的科室
/// Input: 
/// Return:
/// Debug:w ##class(web.DHCOPBillHDDC).GetLocSortingLinkLocStr(3)
ClassMethod GetLocSortingLinkLocStr(LocSortingDR, OrderType)
{
	set myrtn=""
	quit:(+LocSortingDR=0) myrtn
	
	set SLLRowID=0
	for  set SLLRowID=$o(^DHCLocSortingLinkLoc(0,"DLS",LocSortingDR,SLLRowID)) quit:(SLLRowID="")  do
	.set myOrderType=$p($g(^DHCLocSorting(LocSortingDR)),"^",9)
	.quit:(OrderType'="")&&(OrderType'=myOrderType)
	.set myCTLocDR=$p(^DHCLocSortingLinkLoc(SLLRowID),"^",2)
	.set myCTLocDesc=$p(^CTLOC(myCTLocDR),"^",2)
	.if (myrtn="") set myrtn=myCTLocDR
	.else  set myrtn=myrtn_"^"_myCTLocDR
	
	quit myrtn
}

/// Creator: Lid
/// CreatDate: 2012-07-12
/// Description: 插入科室分类关联科室表
/// Debug:w ##class(web.DHCOPBillHDDC).SaveLocSortingLinkLoc(17,"3881","","N")
ClassMethod SaveLocSortingLinkLoc(LocSortingDR, Guser, LocStr, OrderType)
{
	set rtn=0
	ts
	
	set AddDate=+$h, AddTime=$p($h,",",2)
	set LocStr=$tr(LocStr," ","")
	set LinkLocStr=##class(web.DHCOPBillHDDC).GetLocSortingLinkLocStr(LocSortingDR, OrderType)
	set LinkLocStr=$tr(LinkLocStr," ","")
	//保存以前没有的关联记录
	for i=1:1:$L(LocStr,$c(2)) quit:(+rtn'=0)  do
	.set myLocDR=+$p(LocStr,$c(2),i)
	.quit:(+myLocDR=0)
	.quit:("^"_LinkLocStr_"^")[("^"_myLocDR_"^")  //已存在关联则不再插入关联
	.&sql(INSERT INTO DHC_LocSortingLinkLoc(sll_dls_dr,sll_ctloc_dr,sll_adduser_dr,sll_adddate,sll_addtime) VALUES(:LocSortingDR,:myLocDR,:Guser,:AddDate,:AddTime))
	.set rtn=SQLCODE

	//删除关联记录
	for i=1:1:$l(LinkLocStr,"^") quit:(+rtn)  do
	.set LinkLocDR=$p(LinkLocStr,"^",i)
	.quit:(+LinkLocDR=0)
	.quit:(($c(2)_LocStr_$c(2))[($c(2)_+LinkLocDR_$c(2)))
	.set SLLRowID=0
	.for  set SLLRowID=$o(^DHCLocSortingLinkLoc(0,"CTLoc",LinkLocDR,SLLRowID)) quit:(SLLRowID="")  do
	..set LocSortingDR=$p(^DHCLocSortingLinkLoc(SLLRowID),"^",1)
	..set myOrderType=$p($g(^DHCLocSorting(LocSortingDR)),"^",9)
	..quit:((OrderType'="")&&(OrderType'=myOrderType))
	..&sql(DELETE FROM DHC_LocSortingLinkLoc WHERE SLL_RowID=:SLLRowID)
	..set rtn=SQLCODE

	if (+rtn=0) do
	.tc
	else  do
	.tro
	
	quit rtn
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","HDDCDetailNew","","")
Query HDDCDetailNew(OrdType As %String, HospId As %String) As websys.Query(ROWSPEC = "TLocSorting:%String,TBloodDis:%String,AddDate:%String,ModDate:%String,RowID:%String,TLocSortingDR,specDesc,myOrderType,TReCTLOCID,TReCTLOC,TCheckMR,THosDis,TLocgroupflagID,TORDReLoc,TORDReLocID")
{
}

ClassMethod HDDCDetailNewExecute(ByRef qHandle As %Binary, OrdType As %String, HospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("HDDCDetailNew")=$lb(OrdType,HospId)
	set HDDCROWID=0
	for  set HDDCROWID=$o(^DHCOPBillHDDC(HDDCROWID))  quit:(HDDCROWID="")  do
	.set HDDCData=$g(^DHCOPBillHDDC(HDDCROWID))
	.quit:(HDDCData="")
	.set myHospDR=$p(HDDCData,"^",10)
	.quit:(HospId'=myHospDR)
	.set HosDisid=$p(HDDCData,"^",1)
	.set locid=$p(HDDCData,"^",2)
	.set HosDis=$case(HosDisid,"G":"科室组","L":"科室",:"")
	.set TLocgroupflagID=HosDisid
	.//quit:(LOCDR'="")&&(LOCDR'=locid)
	.set loc=""
	.if (HosDisid="L") do
	..if (locid="ALL") set loc="默认科室"
	..else  do
	...set loc=$s((locid'=""):$p(^CTLOC(locid),"^",2),1:"")  //科室
	.if (HosDisid="G") do
	..if (locid="ALL") s loc="默认科室"
	..else  do
	...set loc=$s((locid'=""):$p($g(^RBC("DEP",locid)),"^",2),1:"")  //科室组
	.set Place=$p(HDDCData,"^",3)
	.set AddDate=$p(HDDCData,"^",4)
	.set AddDate=##class(websys.Conversions).DateLogicalToHtml(AddDate)
	.set ModDate=$p(HDDCData,"^",5)
	.set ModDate=##class(websys.Conversions).DateLogicalToHtml(ModDate)
	.set myOrderType=$p(HDDCData,"^",6)
	.quit:((OrdType'="")&&(myOrderType'=OrdType))
	.set:(myOrderType'="") specDesc=$p(##class(DHCLIS.DHCCommon).GetSpecimen(myOrderType,""),$c(2),2)
	.set Relocid=$p(HDDCData,"^",7)
	.set RelocDesc=$s((Relocid'=""):$p(^CTLOC(Relocid),"^",2),1:"")  //科室
	.set CheckFlag=$p(HDDCData,"^",8)
	.set ORDRelocid=$p(HDDCData,"^",9)
	.set ORDRelocDesc=$s((ORDRelocid'=""):$p(^CTLOC(ORDRelocid),"^",2),1:"")  //科室
	.do OutputHDDCNew
	
	quit $$$OK
OutputHDDCNew
	set Data=$lb(loc,Place,AddDate,ModDate,HDDCROWID,locid,specDesc,myOrderType,Relocid,RelocDesc,CheckFlag,HosDis,TLocgroupflagID,ORDRelocDesc,ORDRelocid)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","FindCTLoc","", "L","2")
Query FindCTLocNew(CTLOC As %String, Locgroupflag As %String, HospId As %String) As websys.Query(ROWSPEC = "Desc:%String,HIDDEN:%String")
{
}

ClassMethod FindCTLocNewExecute(ByRef qHandle As %Binary, CTLOC As %String, Locgroupflag As %String, HospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
  	set CTLOC=$$ALPHAUP^SSUTIL4(CTLOC)

  	if (Locgroupflag="L") do
  	.set desc="默认科室", LocDR="ALL"
  	.do OutputRow12
	.set AdmType=""
	.for  set AdmType=$o(^PAC("ADMLOC",0,"AdmType",AdmType)) quit:(AdmType="")  do
  	..quit:(" O E "'[(" "_AdmType_" "))
  	..set LocDR=""
  	..for  set LocDR=$o(^PAC("ADMLOC",0,"AdmType",AdmType,LocDR)) quit:(LocDR="")  do
  	...set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", LocDR, HospId)
	...quit:(showFlag="N")
	...set LocData=$g(^CTLOC(LocDR))
	...set ActiveFlag=$p(LocData,"^",14)
	...quit:(ActiveFlag="N")
	...set StartDate=$p(LocData,"^",24)
	...set EndDate=$p(LocData,"^",25)
	...quit:((StartDate'="")&&(StartDate>+$h))
	...quit:((EndDate'="")&&(EndDate<+$h))
	...set desc=$p(LocData,"^",2)
	...set ctContactName=$p(LocData,"^",43)   //科室检索码
	...set ctContactName=$$ALPHAUP^SSUTIL4(ctContactName)
	...quit:((CTLOC'="")&&(desc'[CTLOC)&&(ctContactName'[CTLOC))
	...do OutputRow12
	else  if (Locgroupflag="G") do
	.//科室组
	.set desc="默认科室", LocDR="ALL"
	.do OutputRow12
	.set locStr=""
	.if (CTLOC'="") set locStr=##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("RBC_DepartmentGroup", CTLOC, "F")
  	.set LocDR=""
  	.for  set LocDR=$o(^RBC("DEP",LocDR)) quit:(LocDR="")  do
	..set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("RBC_DepartmentGroup", LocDR, HospId)
	..quit:(showFlag="N")
	..set desc=$p(^RBC("DEP",LocDR),"^",2)
	..quit:(CTLOC'="")&&(desc'[CTLOC)&&(locStr'[LocDR)
	..quit:(desc="")
	..do OutputRow12
  	
	quit $$$OK

OutputRow12
	set Data=$lb(desc,LocDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","FindCTLocNew2","1")
Query FindCTLocNew2(HospId As %String, CTLOC As %String = "") As websys.Query(ROWSPEC = "Desc:%String,HIDDEN:%String")
{
}

ClassMethod FindCTLocNew2Execute(ByRef qHandle As %Binary, HospId As %String, CTLOC As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
  	set CTLOC=$$ALPHAUP^SSUTIL4(CTLOC)

  	set LocDR=0
  	for  set LocDR=$o(^CTLOC(LocDR)) quit:(LocDR="")  do
  	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", LocDR, HospId)
	.quit:(showFlag="N")
	.set LocData=$g(^CTLOC(LocDR))
	.set AdmType=$p(LocData,"^",13)
	.quit:(AdmType="W")
	.set ActiveFlag=$p(LocData,"^",14)
	.quit:(ActiveFlag="N")
	.set StartDate=$p(LocData,"^",24)
	.set EndDate=$p(LocData,"^",25)
	.quit:((StartDate'="")&&(StartDate>+$h))
	.quit:((EndDate'="")&&(EndDate<+$h))
	.set Desc=$p(LocData,"^",2)
	.//+2017-08-11 ZhYW
	.set ctContactName=$p(LocData,"^",43)   //科室检索码
	.set ctContactName=$$ALPHAUP^SSUTIL4(ctContactName)
	.quit:((CTLOC'="")&&(Desc'[CTLOC)&&(ctContactName'[CTLOC))
	.do OutputLocNew2
  	
	quit $$$OK

OutputLocNew2
	set Data=$lb(Desc,LocDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","OrderType",2)
Query OrderType(hospId As %String) As websys.Query(ROWSPEC = "TOrderTypeValue,TOrderTypeDesc")
{
}

ClassMethod OrderTypeExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set rowid=0
	for  set rowid=$o(^dbo.BTSpecimenD(rowid)) quit:(rowid="")  do
	.set specData=$g(^dbo.BTSpecimenD(rowid))
	.set myHospDR=$lg(specData,7)   
	.//quit:(myHospDR'=hospId)   //不是CT_Hospital指针，不能这样过滤
	.set specCode=$lg(specData,2)
	.set specDesc=$lg(specData,3)
	.do OutputOrderType
	
	quit $$$OK
OutputOrderType
	set Data=$lb(specCode,specDesc)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// w ##class(web.DHCOPBillHDDC).AddHDDCDetail("1","SP001","ddd","","0","G","1","2")
ClassMethod AddHDDCDetailNew(LocDR, OrdType, place, ReLOCDR, CheckFlag, Locgroupflag, ORDReLocID, HospId)
{
	set ^TMP("AddHDDCDetailNew")=$lb(LocDR, OrdType,place,ReLOCDR, CheckFlag, Locgroupflag, ORDReLocID, HospId)
	set Flag="N"
	set DataRowId=0
	for  set DataRowId=$o(^DHCOPBillHDDC(0,"TypeLoc",OrdType,LocDR,DataRowId)) quit:((DataRowId="")||(Flag="Y"))  do
	.set myData=$g(^DHCOPBillHDDC(DataRowId))
	.set myHospDR=$p(myData,"^",10)
	.quit:(myHospDR'=HospId)
	.set myOrdRecLocDR=$p(myData,"^",9)
	.quit:(myOrdRecLocDR'=ORDReLocID)
	.set Flag="Y"
	quit:(Flag="Y") "-1005"	 //一个科室分类只能维护一个地点
	
	ts
	set Date=+$h
	&sql(INSERT INTO DHC_OPBillHDDC(LOC_DR,Place,Add_Date,Order_Type,ReLOC_DR,Check_Flag,HIS_DR,ORDReLOC_DR,Hosp_DR) VALUES (:LocDR,:place,:Date,:OrdType,:ReLOCDR,:CheckFlag,:Locgroupflag,:ORDReLocID,:HospId))
	set HDDCRowID=%ROWID
	if (SQLCODE) tro  quit SQLCODE	
	tc
	quit SQLCODE_"^"_HDDCRowID
}

ClassMethod ModFiyHDDCDetailNew(locid, OrdType, place, id, ReLOCDR, CheckFlag, ORDReLocID)
{
	set Date=+$h
	&sql(UPDATE DHC_OPBillHDDC SET LOC_DR=:locid,Place=:place,Mod_Date=:Date,Order_Type=:OrdType,ReLOC_DR=:ReLOCDR,Check_Flag=:CheckFlag,ORDReLOC_DR=:ORDReLocID WHERE HDDC_Rowid=:id)
	quit SQLCODE
}

/// 2011-9-22
/// Description: 根据传入的科室id查询采血地点
/// Debug: w ##class(web.DHCOPBillHDDC).findLOCBloodDisNew("635||7","SP001")
ClassMethod findLOCBloodDisNew(OEORIDR, OrderType)
{
 	quit:(+OEORIDR=0) ""
	set Place="", Place1=""
	set cflag1=0, cflag2=0  //默认标志
	set UserDepartment=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),7)),"^",2) //开单科室Rowid
	set ORDRelocRowId=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3),"^",6)      //接受科室Rowid
	if (OrderType'="") do
	.//开单科室和医嘱接收科室
	.set HDDCROWID=""
	.for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"ORDReloc",OrderType,UserDepartment,ORDRelocRowId,HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	..quit:($p(^DHCOPBillHDDC(HDDCROWID),"^",1)'="L")
	..set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	..set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	..if (Place'="")&&(cflag1=0)  do
	...set cflag1=1
	...set Place1=Place
	..if (checkFlag=1)  do
	...set Place1=Place
	...set cflag2=1
	.set Place=Place1
	.//科室组和医嘱接收科室
	.if (Place="") do
	..set UserDepzu=$p($g(^CTLOC(UserDepartment)),"^",19)
	..set HDDCROWID=""
	..for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"ORDReloc",OrderType,UserDepzu,ORDRelocRowId,HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	...quit:($p(^DHCOPBillHDDC(HDDCROWID),"^",1)'="G")
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	...if ((Place'="")&&(cflag1=0))  do
	....set cflag1=1
	....set Place1=Place
	...if (checkFlag=1)  do
	....set Place1=Place
	....set cflag2=1
	..set Place=Place1
	.//开单科室组
	.if (Place="") do
	..set UserDepzu=$p($g(^CTLOC(UserDepartment)),"^",19)
	..set HDDCROWID=""
	..for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"TypeLoc",OrderType,UserDepzu,HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	...quit:($p(^DHCOPBillHDDC(HDDCROWID),"^",1)'="G")
	...set ORDRelocID=$p(^DHCOPBillHDDC(HDDCROWID),"^",9)
	...quit:(ORDRelocID'="")
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	...if ((Place'="")&&(cflag1=0))  do
	....set cflag1=1
	....set Place1=Place
	...if (checkFlag=1)  do
	....set Place1=Place
	....set cflag2=1
	..set Place=Place1
	.//默认开单科室和医嘱接收科室
	.if (Place="") do
	..set HDDCROWID=""
	..for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"ORDReloc",OrderType,"ALL",ORDRelocRowId,HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	...if ((Place'="")&&(cflag1=0))  do
	....set cflag1=1
	....set Place1=Place
	...if (checkFlag=1)  do
	....set Place1=Place
	....set cflag2=1
	..set Place=Place1
	.//没有开单科室和医嘱接收科室
	.//开单科室
	.if (Place="") do
	..set HDDCROWID=""
	..for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"TypeLoc",OrderType,UserDepartment,HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	...quit:$p(^DHCOPBillHDDC(HDDCROWID),"^",1)'="L"
	...set ORDRelocID=$p(^DHCOPBillHDDC(HDDCROWID),"^",9)
	...quit:(ORDRelocID'="")
	...set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...if ((Place'="")&&(cflag1=0))  do
	....set cflag1=1
	....set Place1=Place
	...if (checkFlag=1)  do
	....set Place1=Place
	....set cflag2=1
	..set Place=Place1
	.if (Place="") do
	..set HDDCROWID=""
	..for  set HDDCROWID=$o(^DHCOPBillHDDC(0,"TypeLoc",OrderType,"ALL",HDDCROWID),-1) quit:((HDDCROWID="")||(cflag2=1))  do
	...set ORDRelocID=$p(^DHCOPBillHDDC(HDDCROWID),"^",9)
	...quit:(ORDRelocID'="")
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...set checkFlag=$p(^DHCOPBillHDDC(HDDCROWID),"^",8)
	...set Place=$p(^DHCOPBillHDDC(HDDCROWID),"^",3)
	...if ((Place'="")&&(cflag1=0)) do
	....set cflag1=1
	....set Place1=Place
	...if (checkFlag=1)  do
	....set Place1=Place
	....set cflag2=1
	..set Place=Place1
	
	//没有维护的取接受科室物理地址
	if ((Place="")||(Place["请先在分诊台打印条码")) do
	.//set locRowId=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3),"^",6)   //接受科室Rowid
	.//set Place=$p($g(^CTLOC(locRowId,"ADDR","1")),"^",1)  	;接收科室的物理地址
	.set locRowId=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),7),"^",2)   //开单科室Rowid
	.set address=$p($g(^CTLOC(locRowId,"ADDR","1")),"^",1)  	;接收科室的物理地址
	.if (Place="") set Place=address
	.else  set Place="请到"_address_"分诊台打印条码,再到就诊科室医生采集"
	
	quit Place
}

/// 2017-08-28
/// zhli 
/// 根据配置的信息来判断是否有默认值,SP001,33,76,,false,
/// w ##class(web.DHCOPBillHDDC).CheckLOCBloodDis("SP001",266,"1","")
ClassMethod CheckLOCBloodDis(OrderType As %String, Loc As %String, CheckMR As %String, ORDReLocID As %String, RowId As %String, HospId As %String) As %String
{
	set flag=0
	quit:(+CheckMR=0)||(+RowId=0) flag
	
	set HDDCROWID=0
	for  set HDDCROWID=$o(^DHCOPBillHDDC(HDDCROWID)) quit:((HDDCROWID="")||(flag'=0))  do
	.set HDDCData=$g(^DHCOPBillHDDC(HDDCROWID))
	.quit:(HDDCData="")
	.quit:(RowId=HDDCROWID)     //传入的RowId不校验
	.set ordType=$p(HDDCData,"^",6)
	.quit:(ordType="")
	.set myHospDR=$p(HDDCData,"^",10)
	.quit:(myHospDR'=HospId)
	.set locdr=$p(HDDCData,"^",2)
	.set defFlag=$p(HDDCData,"^",8)
	.set ordRelocID=$p(HDDCData,"^",9)
	.if ((ordType=OrderType)&&(locdr=Loc)&&(defFlag=1))  do
	..set flag=1
	
	quit flag
}

/// Creator: ZhYW
/// CreatDate: 2020-02-10 
/// Description: 根据标本和开单科室取医生站使用的接收科室
/// Input: SpecCode:标本代码, Loc:开单科室RowId, HospId:医院Id
/// Return: RecLocDR:接收科室RowId
/// Debug: w ##class(web.DHCOPBillHDDC).GetHDDCRecLoc("SP007", 1, 2)
ClassMethod GetHDDCRecLoc(SpecCode As %String, Loc As %String, HospId As %String) As %String
{
	set RecLocDR=""
	quit:((SpecCode="")||(+Loc=0)) RecLocDR
		
	set HDDCRowID=""
	
	set RowId=""
	for  set RowId=$o(^DHCOPBillHDDC(0,"TypeLoc",SpecCode,Loc,RowId),-1)  quit:((RowId="")||(HDDCRowID'=""))  do
	.set Str=$g(^DHCOPBillHDDC(RowId))
	.quit:(Str="")
	.set HospDR=$p(Str,"^",10)
	.quit:(HospDR'=HospId)
	.set HISDR=$p(Str,"^",1)
	.quit:(HISDR="G")
	.set IsDefault=$p(Str,"^",8)
	.quit:(IsDefault'=1)
	.set HDDCRowID=RowId
	
	if (HDDCRowID="") do
	.set RowId=""
	.for  set RowId=$o(^DHCOPBillHDDC(0,"TypeLoc",SpecCode,Loc,RowId),-1)  quit:((RowId="")||(HDDCRowID'=""))  do
	..set Str=$g(^DHCOPBillHDDC(RowId))
	..quit:(Str="")
	..set HospDR=$p(Str,"^",10)
	..quit:(HospDR'=HospId)
	..set HISDR=$p(Str,"^",1)
	..quit:(HISDR="G")
	..set HDDCRowID=RowId
	
	//按科室取不到时按科室组取
	if (HDDCRowID="") do
	.set DeptGroupDR=$p($g(^CTLOC(Loc)),"^",19)   //CTLOC_Dep_DR->RBC_DepartmentGroup
	.quit:(DeptGroupDR="")
	.set RowId=""
	.for  set RowId=$o(^DHCOPBillHDDC(0,"TypeLoc",SpecCode,DeptGroupDR,RowId),-1)  quit:((RowId="")||(HDDCRowID'=""))  do
	..set Str=$g(^DHCOPBillHDDC(RowId))
	..quit:(Str="")
	..set HospDR=$p(Str,"^",10)
	..quit:(HospDR'=HospId)
	..set HISDR=$p(Str,"^",1)
	..quit:(HISDR'="G")
	..set IsDefault=$p(Str,"^",8)
	..quit:(IsDefault'=1)
	..set HDDCRowID=RowId
	.//
	.if (HDDCRowID="") do
	..set RowId=""
	..for  set RowId=$o(^DHCOPBillHDDC(0,"TypeLoc",SpecCode,DeptGroupDR,RowId),-1)  quit:((RowId="")||(HDDCRowID'=""))  do
	...set Str=$g(^DHCOPBillHDDC(RowId))
	...quit:(Str="")
	...set HospDR=$p(Str,"^",10)
	...quit:(HospDR'=HospId)
	...set HISDR=$p(Str,"^",1)
	...quit:(HISDR'="G")
	...set HDDCRowID=RowId
	
	if (HDDCRowID'="") do
	.set RecLocDR=$p($g(^DHCOPBillHDDC(HDDCRowID)),"^",7)

	quit RecLocDR
}

}
