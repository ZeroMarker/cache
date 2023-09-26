Import SQLUser

Class web.DHCEQLifeFee Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 生命周期费用

Parameter SQLCODE = "LF_RowID";

Parameter SQLDESCRIPTION = "LF_RowID";

Parameter SQLROWID = "LF_RowID";

ClassMethod LifeFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LifeFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LifeFeeExecute(ByRef qHandle As %Binary, EquipDR As %String = "", Equip As %String = "", ManageLocDR As %String = "", UseLocDR As %String = "", FeeTypeDR As %String = "", FeeType As %String = "", Type As %String = "", StartDate As %String = "", EndDate As %String = "", Status As %String = "") As %Status
{
 new rowid
 s rowid=0
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
 	d BuildDataGetLifeFee
	Quit $$$OK
BuildDataGetLifeFee
  f  s rowid=$o(^DHCEQLifeFee(rowid))  quit:rowid=""  d
   .s RowID = rowid
   .s LFEquipDR=$p($g(^DHCEQLifeFee(rowid)),"^",1) //设备 
   .i LFEquipDR'="" s EQName=$p($g(^DHCEQEquip(LFEquipDR)),"^",1) //设备名称
   .s SLFFeeTypeidDR= $p($g(^DHCEQLifeFee(rowid)),"^",2) //产生费用源记录id
   .s LFUseFee=$p($g(^DHCEQLifeFee(rowid)),"^",4) //费用
   .s LFFeeDate=$p($g(^DHCEQLifeFee(rowid)),"^",5) //5费用日期
   .s LFFeeDate1=##class(web.DHCEQCommon).TransValueToPage(LFFeeDate,"date") ;Modified by QW20170302日期格式统一调整 原$zd(LFFeeDate,4)
   .s LFUseLocDR=$p($g(^DHCEQLifeFee(rowid)),"^",6) //2使用科室 
   .;i LFUseLocDR'="" s FUseLocDR=$p($g(^CTLOC(LFUseLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
   .i LFUseLocDR'="" s FUseLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",LFUseLocDR)   //modify by jyp 2019-10-18 CTLOC调整      
   .s LFManagerLocDR=$p($g(^DHCEQLifeFee(rowid)),"^",7) //3管理科室  
   .;i LFManagerLocDR'="" S FManagerLocDR=$p($g(^CTLOC(LFManagerLocDR)),"^",2)  //modify by jyp 2019-10-18 CTLOC调整
   .i LFManagerLocDR'="" S FManagerLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",LFManagerLocDR)   //modify by jyp 2019-10-18 CTLOC调整
   .s SLFFeeTypeDR=$p($g(^DHCEQLifeFee(rowid)),"^",8) //6费用类型
   .i SLFFeeTypeDR'="" d
   ..s LFFeeTypeDR=$p($g(^DHCEQCCode("DHCEQCFeeMode",SLFFeeTypeDR)),"^",2)
   .s LFInvoiceNo=$p($g(^DHCEQLifeFee(rowid)),"^",9) //7发票号 
   .s LFInvoiceDate=$p($g(^DHCEQLifeFee(rowid)),"^",10) //8发票日期 
   .s LFInvoiceDate1=##class(web.DHCEQCommon).TransValueToPage(LFInvoiceDate,"date") ;Modified by QW20170302日期格式统一调整 原i LFInvoiceDate'="" s LFInvoiceDate1=$zd(LFInvoiceDate,4)                
   .s LFInvoiceDept=$p($g(^DHCEQLifeFee(rowid)),"^",11) //9发票单位
   .s LFIsInputFlag=$p($g(^DHCEQLifeFee(rowid)),"^",12) //0是否人工录入 
   .s LFRemark=$p($g(^DHCEQLifeFee(rowid)),"^",13) //1备注               
   .s TAuditUserDR=$p($g(^DHCEQLifeFee(rowid)),"^",20) //审核人
   .s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)             
   .q:(EquipDR="")&(StartDate="")&(EndDate="")&(ManageLocDR="")&(UseLocDR="")&(FeeTypeDR="") 
   .q:(LFEquipDR'=EquipDR)&(EquipDR'="") //设备名称
   .q:(LFFeeDate<StartDate)&(StartDate'="")
   .q:(LFFeeDate>EndDate)&(EndDate'="")
   .;q:(LFFeeDate<StartDate)!(LFFeeDate>EndDate)&(StartDate'="")&(EndDate'="")
   .q:(LFManagerLocDR'=ManageLocDR)&(ManageLocDR'="") //管理科室，                   
   .q:(LFUseLocDR'=UseLocDR)&(UseLocDR'="") //使用科室，
   .q:(SLFFeeTypeDR'=FeeTypeDR)&(FeeTypeDR'="") //费用类型，
   
   .set Data=$lb(RowID,EQName,LFUseFee,LFFeeDate1,LFFeeTypeDR,LFInvoiceNo,LFInvoiceDate1,LFInvoiceDept,LFIsInputFlag,LFRemark,FUseLocDR,FManagerLocDR,SLFFeeTypeDR,LFEquipDR,SLFFeeTypeidDR,TAuditUser)
   .set (RowID,EQName,LFUseFee,LFFeeDate1,LFFeeTypeDR,LFInvoiceNo,LFInvoiceDate1,LFInvoiceDept,LFIsInputFlag,LFRemark,FUseLocDR,FManagerLocDR,LFFeeTypeDR,SLFFeeTypeDR,SLFFeeTypeidDR,TAuditUserDR,TAuditUser)=""
   .Set ^CacheTemp(repid,ind)=Data
   .Set ind=ind+1
	quit
}

ClassMethod LifeFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LifeFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LifeFee(EquipDR As %String = "", Equip As %String = "", ManageLocDR As %String = "", UseLocDR As %String = "", FeeTypeDR As %String = "", FeeType As %String = "", Type As %String = "", StartDate As %String = "", EndDate As %String = "", Status As %String = "") As %Query(ROWSPEC = "TRowID:%String,EQName:%String,LFUseFee:%String,LFFeeDate:%String,LFFeeTypeDR:%String,LFInvoiceNo:%String,LFInvoiceDate:%String,LFInvoiceDept:%String,LFIsInputFlag:%String,LFRemark:%String,LFUseLocDR:%String,LFManagerLocDR:%String,TFeeTypeDR:%String,TEquipDR:%String,TFeeTypeidDR:%String,TAuditUser:%String")
{
}

ClassMethod GetShortEQLifeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortEQLifeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetShortEQLifeExecute(ByRef qHandle As %Binary) As %Status
{
	new rowid
    s rowid=0
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//s id="0"
	d BuildDataGetShortEQLife
	Quit $$$OK
BuildDataGetShortEQLife
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
    .s RowID = rowid
    .s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
    .set Data=$lb(EQName)
    .Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	quit
}

ClassMethod GetShortEQLifeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortEQLifeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetShortEQLife() As %Query(ROWSPEC = "EQName:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 s LFAuditUserDR=""
 i rowid'=""
 {
 	&SQL(select LF_AuditUserDR into :LFAuditUserDR from SQLUSER.DHC_EQLifeFee where LF_RowID = :rowid) 
 	if (LFAuditUserDR'="") q -1002
 }
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQLifeFee where LF_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 // i $p(val,"^",1)'=""  s PLIST(1) = $p(val,"^",1)	;设备代码
  s PLIST(2) = $p(val,"^",2)	;设备名称
  s EquipDR=$p(val,"^",2)
  s PLIST(8) = $p(val,"^",3)	;管理科室
  s PLIST(7) = $p(val,"^",4)	;使用科室
   s UseLocDR= $p(val,"^",4)
 i $p(val,"^",5)'="" & $p(val,"^",5)'="0"
 {
  s tFeeDate=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")  ;Modified by QW20170302日期格式统一调整 原$zdh($p(val,"^",5),4) 
  s PLIST(6) = tFeeDate	;费用日期 
 }
 //i $p(val,"^",5)'=""  s PLIST(9) = tFeeDate	;费用日期
  s PLIST(9) = $p(val,"^",6)	;费用类型
  s PLIST(5) = $p(val,"^",7)	;费用
 i $p(val,"^",8)'="" 
 {
 s tInvoiceDate=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")  ;Modified by QW20170302日期格式统一调整 原$zdh($p(val,"^",8),4)
 s PLIST(11) = tInvoiceDate	;发票日期
 }
  s PLIST(12) = $p(val,"^",9)	;开票单位
 s PLIST(10) = $p(val,"^",10)	;发票号
  s PLIST(14) = $p(val,"^",11)	;备注11
 s PLIST(13) = "Y" //人工录入
 if (rowid'="") 
 {
 s PLIST(18)=$p(val,"^",12) //审核人
 s PLIST(19) = +$H ;审核日期
 s PLIST(20) = $P($H,",",2) ;审核时间 
 	 &SQL(Update SQLUSER.DHC_EQLifeFee Values :PLIST() where LF_RowID = :rowid) 	 
 }
 else
 {	 
 s PLIST(15)=$p(val,"^",12) //审核人
 s PLIST(16) = +$H ;审核日期
 s PLIST(17) = $P($H,",",2) ;审核时间 
	 &SQL(Insert Into SQLUSER.DHC_EQLifeFee Values :PLIST())
 	}
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/// /////////////////////////////////////////////////////
ClassMethod DHCEQMonthDepreID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
   new result
	s result=$p($g(^DHCEQMonthDepre(rowid)),"^",2)
	
    i result'="" d
    .s resultex=result
    s DepreMethodId=$p($g(^DHCEQDepreSet(result)),"^",2)
    i DepreMethodId="" q ""
    s resultex=resultex_"^"_DepreMethodId    
    s resultex=resultex_"^"_$p(^DHCEQDepreSet(result),"^",5)
    q resultex
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQLifeFee(rowid)
	s resultex=resultex_"^"	//设备名称
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p($g(^DHCEQLifeFee(rowid)),"^",1))),"^",1)
	s resultex=resultex_"^"	//管理科室2
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQLifeFee(rowid)),"^",7))
	s resultex=resultex_"^"	//使用科室3
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQLifeFee(rowid)),"^",6))
	s resultex=resultex_"^"	//费用类型4
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFeeMode",$p($g(^DHCEQLifeFee(rowid)),"^",8))),"^",2)
	s resultex=resultex_"^"	//发票日期5
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQLifeFee(rowid)),"^",10),"date") ;Modified by QW20170302日期格式统一调整 原$ZD($p($g(^DHCEQLifeFee(rowid)),"^",10),4)
	s resultex=resultex_"^"	//费用日期6
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQLifeFee(rowid)),"^",5),"date") ;Modified by QW20170302日期格式统一调整 原$ZD($p($g(^DHCEQLifeFee(rowid)),"^",5),4)
    s resultex=resultex_"^"	//开票单位7
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",11)
	s resultex=resultex_"^"	//发票号8
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",9)
	s resultex=resultex_"^"	//费用9
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",4)
	s resultex=resultex_"^"	//备注10
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",13)
	s resultex=resultex_"^"	//费用类型代码11
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",8)
	s resultex=resultex_"^"	//设备名称代码12
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",1)
	s resultex=resultex_"^"	//使用科室代码13
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",6)
	s resultex=resultex_"^"	//管理科室代码14
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",7)
	s resultex=resultex_"^"	//审核人15
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",20)
	s resultex=resultex_"^" //是否人工录入 16
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQLifeFee(rowid)),"^",12)
	q resultex
}

ClassMethod TFeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TFeeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod TFeeTypeExecute(ByRef qHandle As %Binary, FeeType As %String = "") As %Status
{
	 new rowid
     s rowid=0
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	s id="0"	
 	d BuildDataGetFeeType
	Quit $$$OK
BuildDataGetFeeType
  f  s rowid=$o(^DHCEQCCode("DHCEQCFeeMode",rowid))  quit:rowid=""  d
   .s RowID = rowid
   .s FMDesc=$p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",2) //类型名称
   .s FMCode=$p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",1) //代码
   .q:(FMDesc'[FeeType)
   .set Data=$lb(FMDesc,FMCode,RowID)
   .set (FMDesc,FMCode,RowID)=""
   .Set ^CacheTemp(repid,ind)=Data
   .Set ind=ind+1
	quit
}

ClassMethod TFeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TFeeTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 	Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query TFeeType(FeeType As %String = "") As %Query(ROWSPEC = "FMCode:%String,FMDesc:%String,RowID:%String")
{
}

ClassMethod SaveDataAudit(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 s DataAudit=$p($g(^DHCEQLifeFee(rowid)),"^",20)
 if (DataAudit) q -1003
 i $p(val,"^",2)'="" s PLIST(21) =$p(val,"^",2) ;审核人 
 s PLIST(22) = +$H ;审核日期
 s PLIST(23) = $P($H,",",2) ;审核时间
 &SQL(Update SQLUser.DHC_EQLifeFee Values :PLIST() where LF_RowID = :rowid)
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

}
