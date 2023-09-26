Class web.UDHCPrescriptQueryZTF Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Makestr(str1)
{
	set maxll=12
	set ret=str1
	set ll=$l(str1)
	set num=maxll-ll
	for i=1:1:num d
	.s ret=ret_" "
	q ret
}

ClassMethod getallinfo(PrescNo, presctypenum)
{
	i presctypenum="1" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getxyinfo(PrescNo)
 i presctypenum="2" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getxyinfo(PrescNo)
 i presctypenum="3" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getcyinfo(PrescNo)
 q allinfo
}

ClassMethod getcareprovider(AdmDocCode)
{
 s SSUSRRowId="" f  s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""  d
 .i $p(^SSU("SSUSR",SSUSRRowId),"^",2)=AdmDocCode s RowId=SSUSRRowId
 //s SSUSRCareProvDR=$p(^SSU("SSUSR",RowId),"^",14)
 q AdmDocCode
}

ClassMethod getcyinfo(PrescNo)
{
 s i=16,info1="",num=1,x=1,b(1)="",b(2)="",b(3)=""
 s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId)) q:OEORDRowId=""  d
 .s OEORIChildsub="" f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
 ..q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
 ..s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 ..s Subscript=$p(ItmMastrowid,"||",1)
 ..s Version=$p(ItmMastrowid,"||",2)
 ..s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 ..s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 ..s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 ..s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 ..s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12) //数量
 ..s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
 ..s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 ..s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",1) //用法
 ..s DurationFactor=1
 ..i DurationRowid'="" d
 ...s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
 ...s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 ..s CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2) //剂量单位
 ..s PHCFRDesc=$p(^PHCFR(FrequenceRowid),"^",1) //名称
 ..s DoseQty=DoseQty/DurationFactor
 ..q:ItmMastrowid="12558||1" 
 ..s a(i)=ARCIMDesc s i=i+1 s a(i)=DoseQty s i=i+1 s a(i)=CTUOMDesc s i=i+1 s a(i)="" s i=i+1
 ..s b(2)="用药副数 "_DurationDesc,b(3)=PHCINDesc_" "_PHCFRDesc
 .s n4=i#16 
 .if n4'=0 s m=i-n4/16 
 .i n4=0  s m=i/16-1
 .f y=1:1:m d
 ..f n=y*16:1:y+1*16-1 d
 ...i num>16 s num=1
 ...s c(num)=$g(a(n))
 ...s num=num+1
 ...s a(n)=""
 ..s x=x+1
 ..i $p(c(4),"!",4)'="" s bz="("_$p(c(4),"!",4)_")"
 ..s b1=$g(b(1)),c1=$g(c(1)),c2=$g(c(2))_$g(c(3))_" "_$g(bz),c3="",HiddenPara1=c(4),c5=c(5),c6=c(6)_c(7),c7="",HiddenPara2=c(8),c9=c(9),c10=c(10)_c(11),c11="",HiddenPara3=c(12),c13=c(13),c14=c(14)_c(15),c15="",HiddenPara4=c(16),b2=b(2)
 ..;s info=c1_c2_","_c5_c6_","_c9_c10_","_c13_c14
 ..s info=..Makestr(c1_c2)_..Makestr(c5_c6)_..Makestr(c9_c10)_..Makestr(c13_c14)
 ..s b1=""
 ..s info1=info1_"^"_info
 s info1=info1_"&"_b(2)_b(3)
 q info1
}

ClassMethod getpatinfo(EpisodeID)
{
 s papmi=$p(^PAADM(EpisodeID),"^",1)
 s info=##Class(web.DHCDocOrderEntry).GetPatientByRowid(papmi)
 q info
}

ClassMethod getxyinfo(PrescNo)
{
 s info1="",b(1)="",b(2)="",b(3)=""
 s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId)) q:OEORDRowId=""  d
 .s OEORIChildsub="" f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
 ..q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
 ..s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 ..s Subscript=$p(ItmMastrowid,"||",1)
 ..s Version=$p(ItmMastrowid,"||",2)
 ..s Phcdfdr=$p(^ARCIM(Subscript,Version,1),"^",12)
 ..s ARCIMDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ItmMastrowid)
 ..i ARCIMDesc="" s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",3)
 ..//s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 ..s BillingUOMdr=$p(^ARCIM(Subscript,Version,8),"^",14) //整包装单位
 ..s packuom=$p(^CT("UOM",BillingUOMdr),"^",2)
 ..s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 ..s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 ..s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 ..s QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,9)),"^",4) //整包装数量
 ..s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",1) //数量
 ..s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
 ..s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 ..s PHCFRDesc=$p(^PHCFR(FrequenceRowid),"^",1)
 ..s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 ..s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",1) //用法
 ..s DurationFactor=1
 ..i DurationRowid'="" d
 ...s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
 ...s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 ..s CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2) //剂量单位
 ..s PHCFRDesc=$p(^PHCFR(FrequenceRowid),"^",1) //名称
 ..s packuom=$p(packuom,"(",1)	
 ..s info=ARCIMDesc_" X "_QtyPackUOM_packuom_"/"_DoseQty_CTUOMDesc_" "_PHCINDesc_" "_PHCFRDesc
 ..s info1=info1_"^"_info
 s info1=info1_"&"_" "
 q info1
}

ClassMethod searchallClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = searchallExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod searchallExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1

 i EpisodeID="" Set qHandle=$lb(0,repid,0) quit $$$OK
 s info=""
 s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
 .//s PharmStatus=$p(^PAQUE1(QUE1RowID),"^",13) //处方状态
 .//q:PharmStatus="C"
 .s PrescNo=$p(^PAQUE1(QUE1RowID),"^",14) //处方号
 .s DepartmentLocId=$p(^PAQUE1(QUE1RowID),"^",4)
 .s DepartmentLoc=$p(^CTLOC(DepartmentLocId),"^",2) //接收科室
 .s TransDate=$p(^PAQUE1(QUE1RowID),"^",7)
 .s TransTime=$zt($p(^PAQUE1(QUE1RowID),"^",8),3) //时间
 .s CareProviderid=$p(^PAQUE1(QUE1RowID),"^",5)
 .s doctor=$p(^CTPCP(CareProviderid,1),"^",2) //医生
 .s info=PrescNo_$zd(TransDate,3)_$zt(TransTime,3)_doctor
 .s select=1,amount=0,presctype=""
 .//q:'$d(^PAQUE1(QUE1RowID,"DHC"))
 .//s presctype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2) //这个global有问题不是所有的处方都有数据
 .s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId)) q:OEORDRowId=""  d
 ..s Childsub="" f  s Childsub=$o(^OEORD(0,"PrescNo",PrescNo,OEORDRowId,Childsub)) q:Childsub=""  d
 ...s ItmMastdr=$p(^OEORD(OEORDRowId,"I",Childsub,1),"^",2)
 ...s Subscript=$p(ItmMastdr,"||",1),Version=$p(ItmMastdr,"||",2)
 ...s ItemCat=$p(^ARCIM(Subscript,Version,1),"^",10)
 ...s fl=##Class(web.DHCDocOrderCommon).GetPHPrescType(ItemCat)
 ...q
 ..I $D(^PAQUE1(QUE1RowID,"DHC")) D
 ...s fl=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
 ..if fl=3 s presctype="草药"
 ..if fl=2 s presctype="中成药"
 ..if fl=1 s presctype="西药"
 ..d OutputRow
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow
	set Data=$lb(select,PrescNo,TransTime,DepartmentLoc,presctype,fl,doctor,EpisodeID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod searchallFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = searchallExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

ClassMethod ztfmxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ztfmxExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ztfmxExecute(ByRef qHandle As %Binary, PrescNo As %String, presctypenum As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i presctypenum="" Set qHandle=$lb(0,repid,0) quit $$$OK
 ;i presctypenum="1" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getxyinfo(PrescNo)
 i presctypenum="1" s allinfo=..getxyinfo(PrescNo)
 b
 i presctypenum="2" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getxyinfo(PrescNo)
 i presctypenum="3" s allinfo=##Class(web.UDHCPrescriptQueryZTF).getcyinfo(PrescNo)
 b
 s Duration=$p(allinfo,"%",2)
 s use=$p(allinfo,"%",3)
 s info1=$p(allinfo,"%",1)
 s max=$LENGTH(info1,"^")
 f i=2:1:max d
 .s info=$p(info1,"^",i)
 .d OutputRow
 .s use="",Duration="",info=""
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow
	set Data=$lb(Duration,use,info)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod ztfmxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ztfmxExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

Query searchall(EpisodeID As %String) As %Query(ROWSPEC = "select:%String,PrescNo:%String,TransTime:%String,DepartmentLoc:%String,presctype:%String,fl:%String,doctor:%String,EpisodeID:%String")
{
}

Query ztfmx(PrescNo As %String, presctypenum As %String) As %Query(ROWSPEC = "Duration:%String,use:%String,info:%String")
{
}

}
