/// 创建者：pylian
/// 名称：DHCMed.SPEService.BaseInfoQry
/// 作用：病人诊断、手术、辅助检查、抗生素医嘱的查询 改自DHCMed.IMPService.PatBaseInfoQry
/// 创建时间：2015-04-02
Class DHCMed.SPEService.BaseInfoQry Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 查询病人疾病信息
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.BaseInfoQry","GetMRICDByAdm","539")
Query GetMRICDByAdm(paadm As %String) As %Query(ROWSPEC = "ICD:%String,DiseaseName:%String,Type:%String")
{
}

ClassMethod GetMRICDByAdmExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:+paadm="" return
	Set MRAdm=$p($g(^PAADM(+paadm)),"^",61)
	Quit:+MRAdm="" return
	Set xSubID=0
		For {
			Set xSubID=$o(^MR(+MRAdm,"DIA",xSubID))
			Quit:xSubID=""
			
			Set tmpDiagnos=$g(^MR(+MRAdm,"DIA",xSubID))
			Set ICDDES=$g(^MR(MRAdm,"DIA",xSubID,"DES",1))
			Set ICDDHC=$g(^MR(MRAdm,"DIA",xSubID,"DHC",1))
			
			Set ICDDxID=$p(tmpDiagnos,"^",1)
			Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
			Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",xSubID,1)),"^",26)    //诊断前缀 add 2020-09-17
			Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	
			Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
			Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
			Set ICDType=$g(^MR(+MRAdm,"DIA",xSubID,"TYP","1"))
			Set Type=$p($g(^MRC("DTYP",ICDType)),"^",2)
			Set ICD=$p($g(^MRC("ID",ICDDxID)),"^",4)
			
			Set Data=$lb(ICD,ICDDesc,Type)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	Quit $$$OK
}

ClassMethod GetMRICDByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRICDByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMRICDByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRICDByAdmExecute ]
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

/// 从手术系统中查询手术列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.BaseInfoQry","QryOperByAdm","9")
Query QryOperByAdm(paadm As %String) As %Query(ROWSPEC = "OrderID:%String,OperationName:%String,StartDate:%String,StartTime:%String,Status:%String")
{
}

ClassMethod QryOperByAdmExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set OperArr=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",paadm,OperArr))
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
		Continue:OperStatus="NotApp"
		//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部
		Set OperStatusDesc=$s(OperStatus="A":"申请",OperStatus="D":"拒绝",OperStatus="R":"安排",OperStatus="I":"术中",OperStatus="P":"恢复室",OperStatus="L":"离室",OperStatus="F":"完成")
		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
		Set Paadm=$p(AnaRowID,"||",1)
		Set AnaChild=$p(AnaRowID,"||",2)
		Continue:(AnaChild="")||(Paadm="")
		Set OperStartDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
		If OperStartDate'="" {
    		;Set OperStartDate=$zd(OperStartDate,3)
    		Set OperStartDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperStartDate)
    		Set OperStartTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
			Set OperStartTime=$zt(+OperStartTime,2)
    	} Else {
	    	Set OperStartTime=""
	    }
	    
		Set OPChild=0
		For {
    		Set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Quit:OPChild=""
    		
    		Set AnaOpRowID=Paadm_"||"_AnaChild_"||"_OPChild
    		Set tmpOper=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Continue:tmpOper=""
    		
    		Set (OperationID,OperationDesc,OperLevelID,OperLevelDesc,OperCategID,OperCategDesc,OperDocID,OperDocDesc)=""
    		
    		//取手术级别   DHC_ANC_OPLeve
    		Set OperLevelID=$p($g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"DHC")),"^",1)
    		Set:OperLevelID'="" OperLevelDesc=$p($g(^DHCANC("OPLevel",OperLevelID)),"^",2)
    		
    		Set OperationID=$p(tmpOper,"^",6)
    		If OperationID'="" {
	    		Set OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
	    		//手术等级
	    		Set OperCategID=$p($g(^ORC("OPER",OperationID)),"^",7)
	    		Set:OperCategID'="" OperCategDesc=$p($g(^ORC("CATEG",OperCategID)),"^",2)
    		} Else {
	    		Set RemSubID=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",""),-1)
	    		Set:(+RemSubID)>0 OperationDesc=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",RemSubID))
	    	}
			
    		Set OperDoc=$p(tmpOper,"^",8)
    		Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
			Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
			Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
			If $IsObject(objSSUser) {
				Set OperDocID=objSSUser.Rowid
				Set OperDocDesc=objSSUser.Name
			}
			Set:(OperDocDesc="")&&(tmpOperDocDesc'="") OperDocDesc="*"_tmpOperDocDesc
			
			Set data=$lb("")
			Set $li(data,1)=OperationID
			Set $li(data,2)=OperationDesc
			Set $li(data,3)=OperStartDate
			Set $li(data,4)=OperStartTime
			Set $li(data,5)=OperStatusDesc
		
  			s ^CacheTemp(repid,ind)=data
    		s ind=ind+1 
		}
	}  
	Quit $$$OK
}

ClassMethod QryOperByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperByAdmExecute ]
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

/// 查询辅助检查列表
Query QryLabByAdm(paadm As %String) As %Query(ROWSPEC = "OrderID:%String,OrderName:%String,StartDate:%String,LabTestNo:%String,OrderStatus:%String")
{
}

ClassMethod QryLabByAdmExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK   
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
    //  s aNum=$$BuildCurrDepArcim(paadm)
    s arcim="" f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .;w:Type="L" !,"arcimDesc="_arcimDesc_"   Type="_Type
    .q:Type'="L"
    .s flag=""
    .s:$d(^CacheTemp($zn,$j,"ARCIM",arcim)) flag="1"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,"    oeori="_oeord_"||"_oeoriSub_"  "_OrderStatus_"  "_OrderStatusDesc
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...;s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s labtestsetrow=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",35)
    ...;w !," oeori="_oeord_"||"_oeoriSub_"    labtestsetrow="_labtestsetrow
    ...s oeori=oeord_"||"_oeoriSub
    ...s data=$lb("")
    ...s $li(data,1)=oeori
    ...s $li(data,2)=arcimDesc
    ...;s $li(data,3)=$zd(sttDate,3)
    ...s $li(data,3)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(sttDate)
    ...s $li(data,4)=labtestsetrow
    ...s $li(data,5)=OrderStatusDesc
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...;s TMP=oeori_$c(2)_arcimDesc_$c(2)_$zd(sttDate,3)_$c(2)_flag_$c(2)_labtestsetrow_$c(2)_OrderStatusDesc
    ...;s s=s_TMP_$c(1)
    k ^CacheTemp($zn,$j,"ARCIM")
    q $$$OK
}

ClassMethod QryLabByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabByAdmExecute ]
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

Query QryOrderByAdm(paadm As %String) As %Query(ROWSPEC = "arcim:%String,arcimDesc:%String,startDate:%String,endDate:%String,days:%String")
{
}

ClassMethod QryOrderByAdmExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
       s num=0,s=""
       q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK
       s DrugFlag=1     //add by jiangpengpeng  过滤非抗菌药物 2015-06-16
       s oeord=$o(^OEORD(0,"Adm",+paadm,""))
       
       s arcim=""
       f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
       .;q:$$CheckOrderType(arcim,OrderType)=0
       .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
       .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
       .q:Type'="R"
       .s phccat=$$GetPhcCat(+arcim)
       .q:(DrugFlag'="")&((phccat'["抗感染")&(phccat'["抗生素")&(phccat'["抗微生物"))    ;by wuqk 2008-05-12
       .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
       .s sttDate="",endDate="",Days=0,TMP=""
       .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
       ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
       ...s oeori=oeord_"||"_oeoriSub
       ...;q:$$CheckOrderStatus(oeori)<0
       ...s TsttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
       ...s DuratDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",6),DuratDays=1
       ...s:DuratDR>0 DuratDays=+$p($g(^PHCDU(DuratDR)),"^",2)
       ...s TendDate=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",34)  //fix bug 113095 抗菌药物信息结束用药日期始终为开始用药日期
       ...s:TendDate="" TendDate=$p($h,",",1)    //若无截止日期取当前日期
       ...;s:TendDate="" TendDate=TsttDate+DuratDays-1
       ...s:sttDate="" sttDate=TsttDate
       ...s endDate=TendDate
       ...;q:$$CheckOrderStatus(oeori)<0
       ...s Days=Days+TendDate-TsttDate+1
       .;s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
       .s sttDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(sttDate)
       .s endDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(endDate)
       .;s:sttDate'="" sttDate=$zd(sttDate,3)
       .;s:endDate'="" endDate=$zd(endDate,3)
       .s data=$lb("")
       .s $li(data,1)=arcim
       .s $li(data,2)=arcimDesc
       .s $li(data,3)=sttDate
       .s $li(data,4)=endDate
       .s $li(data,5)=Days
       .s ^CacheTemp(repid,ind)=data
       .s ind=ind+1
       q $$$OK
       
GetPhcCat(arcim)
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

ClassMethod QryOrderByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrderByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderByAdmExecute ]
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

}
