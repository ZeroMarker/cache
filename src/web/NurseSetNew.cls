/// Creator:      EH
/// CreatDate:    2014-12-01
Class web.NurseSetNew Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getarr(parr = "", ByRef arr) As %String
{
	k arr
	s len1=$l(parr,"^")
	i (parr="") s len1=0
	f ind1=1:1:len1 d
	.s sub1=$p(parr,"^",ind1)
	.s sub11=$p(sub1,"|",1)
	.s sub12=$p(sub1,"|",2)
	.i (sub11'="") s arr(sub11)=sub12
	q ""
}

/// ##class(%ResultSet).RunQuery("web.NurseSetNew","find","parr$index1|durgauditnew^index2|west^HospID|95")
ClassMethod findExecute(ByRef qHandle As %Binary, parr = "") As %Status
{
	set repid=$increment(^CacheTemp)
 	set ind=1
 	i parr["$" s parr=$p(parr,"$",2)
 	d ..getarr(parr,.arr)
 	s i1=$zcvt($g(arr("index1")),"U")
 	s i2=$zcvt($g(arr("index2")),"U")
 	s hospID=$zcvt($g(arr("HospID")),"U")
 	i (i1'="")&(i2'="") d
 	.k seq
 	.s i3="" f  s i3=$replace($o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3))," ","") q:(i3="")  d
 	..s rw=$o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3," "_hospID,""))
 	..i (rw="") q
 	..s rec=##class(Nur.NurseSetNew).%OpenId(rw)
 	..;s recHospID=rec.HospID
 	..;q:recHospID'=hospID
 	..i ('$isobject(rec)) q
 	..s index1=rec.index1
 	..s index2=rec.index2
 	..s index3=rec.index3
 	..s field1=rec.field1
 	..s field2=rec.field2
 	..s field3=rec.field3
 	..s field4=rec.field4
 	..s field5=rec.field5
 	..s field6=rec.field6
 	..d rec.%Close()
 	..s rec=""
 	..s aa="rw"_"|"_rw
 	..s aa=aa_"^"_"index1"_"|"_index1_"^"_"index2"_"|"_index2_"^"_"index3"_"|"_index3
 	..s aa=aa_"^"_"field1"_"|"_field1_"^"_"field2"_"|"_field2_"^"_"field3"_"|"_field3_"^"_"field4"_"|"_field4_"^"_"field5"_"|"_field5_"^"_"field6"_"|"_field6
 	..s number=$s((field2=""):rw,1:field2)
 	..s seq(number,rw)=aa
 	.s number="" f  s number=$o(seq(number)) q:(number="")  d
 	..s rw="" f  s rw=$o(seq(number,rw)) q:(rw="")  d
 	...s aa=seq(number,rw)
 	...d output
    set qHandle=$listbuild(0,repid,0)
	quit $$$OK
output
	set data=$listbuild(aa)
 	set ^CacheTemp(repid,ind)=data
 	set ind=ind+1
	quit
}

ClassMethod findFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findExecute ]
{
	set AtEnd=$list(qHandle,1)
 	set repid=$list(qHandle,2)
 	set ind=$list(qHandle,3)
 	set ind=$order(^CacheTemp(repid,ind))
 	if (ind="") set AtEnd=1,Row=""
 	else  set Row=^CacheTemp(repid,ind)
 	set qHandle=$listbuild(AtEnd,repid,ind)
	quit $$$OK
}

ClassMethod findClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findExecute ]
{
	set repid=$list(qHandle,2)
 	kill ^CacheTemp(repid)
 	quit $$$OK
}

Query find(parr = "") As %Query(ROWSPEC = "aa")
{
}

/// w ##class(web.NurseSetNew).save("field1|11^index3|11^field3|Y^field4|Y^field2|8^rw|78^index1|durgauditnew^index2|west")
ClassMethod save(parr = "", HospID = "") As %String
{
	d ..getarr(parr,.arr)
	s rw=$g(arr("rw"))
	s index1=$g(arr("index1"))
	s index2=$g(arr("index2"))
	s index3=$g(arr("index3"))
	i (index1="")!(index2="")!(index3="") q "保存失败:请检查录入的数据是否正确!"
	s field1=$g(arr("field1"))
	s field2=$g(arr("field2"))
	s field3=$g(arr("field3"))
	s field4=$g(arr("field4"))
	s field5=$g(arr("field5"))
	s field6=$g(arr("field6"))
	i (field2'="") s field2=+field2
#;	s field2Flag=0
#;	s i3="" f  s i3=$replace($o(^Nur.NurseSetNewI("ll3s"," "_$$ALPHAUP^SSUTIL4(index1)," "_$$ALPHAUP^SSUTIL4(index2)," "_i3))," ","") q:(i3="")!(field2Flag'=0)  d
#;	.s rwid=$o(^Nur.NurseSetNewI("ll3s"," "_$$ALPHAUP^SSUTIL4(index1)," "_$$ALPHAUP^SSUTIL4(index2)," "_$$ALPHAUP^SSUTIL4(i3),""))
#;	.s rec=##class(Nur.NurseSetNew).%OpenId(rwid)
#; 	.q:('$isobject(rec))
#; 	.s f2 = +rec.field2
#; 	.i f2=field2 s field2Flag=1
 	;q:field2Flag=1 "该顺序号已存在，请核实!"
	s ret=##class(Nur.NurseSetNew).save(rw,index1,index2,index3,field1,field2,field3,field4,field5,field6,HospID)
	q ret
}

ClassMethod delete(rw = "") As %String
{
	s ret=##class(Nur.NurseSetNew).delete(rw)
	q ret
}

ClassMethod findsimple(i1 = "", i2 = "", i3 = "", HospID = "") As %String
{
	s defaultHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_NurseSetNew",HospID)
 	q:(+defaultHospID<0) defaultHospID
	s aa=""
	s i1=$zcvt(i1,"U")
 	s i2=$zcvt(i2,"U")
 	s i3=$zcvt(i3,"U")
 	s rw=$o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3," "_defaultHospID,""))
 	i (rw="") q aa
 	s rec=##class(Nur.NurseSetNew).%OpenId(rw)
 	i ('$isobject(rec)) q aa
 	s recHospID=rec.HospID
 	;q:recHospID'=HospID aa
 	s field1=rec.field1
 	s field2=rec.field2
 	s field3=rec.field3
 	s field4=rec.field4
 	s field5=rec.field5
 	s field6=rec.field6
 	s field7=rec.field7
 	s field8=rec.field8
 	s field9=rec.field9
 	s field10=rec.field10
 	s field11=rec.field11
 	s field12=rec.field12
 	s field13=rec.field13
 	s field14=rec.field14
 	s field15=rec.field15
 	s aa=rw
 	s aa=aa_"^"_field1_"^"_field2_"^"_field3_"^"_field4_"^"_field5_"^"_field6_"^"_field7_"^"_field8_"^"_field9_"^"_field10_"^"_field11_"^"_field12_"^"_field13_"^"_field14_"^"_field15
 	q aa
}

ClassMethod getset(i1 = "", i2 = "", HospID = "", ByRef arr) As %String
{
	k arr
 	s i1=$zcvt(i1,"U")
 	s i2=$zcvt(i2,"U")
 	s defaultHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_NurseSetNew",HospID)
 	q:(+defaultHospID<0) defaultHospID
 	i (i1'="")&(i2'="") d
 	.k seq
 	.s i3="" f  s i3=$replace($o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3))," ","") q:(i3="")  d
 	..s rw=$o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3," "_defaultHospID,""))
 	..i (rw="") q
 	..s rec=##class(Nur.NurseSetNew).%OpenId(rw)
 	..i ('$isobject(rec)) q
 	..s field2=rec.field2
 	..s number=$s((field2=""):rw,1:field2)
 	..s seq("index3",number,rw)=rec.index3
 	..s seq("field1",number,rw)=rec.field1
 	..s seq("field2",number,rw)=field2
 	..s seq("field3",number,rw)=rec.field3
 	..s seq("field4",number,rw)=rec.field4
 	..s seq("field5",number,rw)=rec.field5
 	..s seq("field6",number,rw)=rec.field6
 	..d rec.%Close()
 	..s rec=""
 	.s field="" f  s field=$o(seq(field)) q:(field="")  d
 	..s conut="0"
 	..s number="" f  s number=$o(seq(field,number)) q:(number="")  d
 	...s rw="" f  s rw=$o(seq(field,number,rw)) q:(rw="")  d
 	....i ($i(conut)="1") s arr(field)=""
 	....e  s arr(field)=arr(field)_"^"
 	....s arr(field)=arr(field)_seq(field,number,rw)
 	q ""
}

ClassMethod getvalue(i1 = "", i2 = "", f1 = "", HospID = "", ByRef arr) As %String
{
	k arr
	s defaultHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_NurseSetNew",HospID)
 	q:(+defaultHospID<0) defaultHospID
 	s i1=$zcvt(i1,"U")
 	s i2=$zcvt(i2,"U")
 	i (i1'="")&(i2'="")&(f1'="") d
 	.s i3="" f  s i3=$replace($o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3))," ","") q:(i3="")  d
 	..s rw=$o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3," "_defaultHospID,""))
 	..i (rw="") q
 	..s rec=##class(Nur.NurseSetNew).%OpenId(rw)
 	..i ('$isobject(rec)) q
 	..s arr(i3)=$property(rec,f1)
 	..d rec.%Close()
 	..s rec=""
 	q ""
}

ClassMethod getvalues(i1 = "", i2 = "", f1 = "", HospID = "", ByRef arr) As %String
{
	k arr
 	s i1=$zcvt(i1,"U")
 	s i2=$zcvt(i2,"U")
 	s defaultHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_NurseSetNew",HospID)
 	q:(+defaultHospID<0) defaultHospID
 	i (i1'="")&(i2'="")&(f1'="") d
 	.s i3="" f  s i3=$replace($o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3))," ","") q:(i3="")  d
 	..s rw=$o(^Nur.NurseSetNewI("ll3s"," "_i1," "_i2," "_i3," "_defaultHospID,""))
 	..i (rw="") q
 	..s rec=##class(Nur.NurseSetNew).%OpenId(rw)
 	..i ('$isobject(rec)) q
 	..s len1=$l(f1,"^")
 	..s val1=""
 	..f ind1=1:1:len1 d
 	...s sub1=$p(f1,"^",ind1)
 	...i (sub1="") q
 	...i (val1'="") s val1=val1_"^"
 	...s val1=val1_$property(rec,sub1)
 	..s arr(i3)=val1
 	..d rec.%Close()
 	..s rec=""
 	q ""
}

ClassMethod initConfig(i1 = "") As %String
{
	i ($d(^Nur.NurseSetNewI("ll3s"," "_$zcvt(i1,"U")))) q ""
	i (i1="durgauditnew"){
		s config1="发药^已审^长期^临时^精神^毒麻^欠费^出院带药"
		s config2="typ^Audittyp^longOrdFlag^tempOrdFlag^JSFlag^DMFlag^UnPayFlage^CYDYFlag"
		s config3=$replace("^^checked^checked^^^^","checked","Y")
		s config4=$replace("^^^^^^^hidden","hidden","Y")
		s length=$l(config1,"^")
		f index=1:1:length{
			d ##class(Nur.NurseSetNew).save("",i1,"west",$p(config2,"^",index),$p(config1,"^",index),index,$p(config3,"^",index),$p(config4,"^",index),"","")
		}
		s config1="选择^药房^药品^数量^单位^ArRow^recLocId^Process^库存^在途^errcode^特殊标示"
		s config2="selection^LocDes^Arcim^Qty^Uom^ArRow^recLocId^Process^Stock^AaUnD^errcode^errcode1"
		s config3="40^200^350^75^75^75^75^75^75^75^0^160"
		s config4=$replace("^^^^^^^^^^hidden^","hidden","Y")
		s length=$l(config1,"^")
		f index=1:1:length{
			d ##class(Nur.NurseSetNew).save("",i1,"north",$p(config2,"^",index),$p(config1,"^",index),index,$p(config3,"^",index),$p(config4,"^",index),"","")
		}
		s config1="选择^审核^床号^患者^患者密级^患者级别^医生^时间^药品^数量^单位^优先级^剂量^频次^状态^发药时间^审核标志^Orw^dhcDspId^errcode^特殊标示"
		s config2="selection^Audit^BedCode^PatName^EncryptLevel^PatLevel^Doctor^OrdDate^Arcim^Qty^Uom^Prior^doseQtyUnit^phcfrCode^dspStat^DispDateTime^AuditFlag^Orw^dhcDspId^errcode^errcode1"
		s config3="40^100^75^100^90^90^75^100^275^75^75^100^70^70^75^100^100^100^80^0^160"
		s config4=$replace("^^^^^^^^^^^^^^^^^^^hidden^","hidden","Y")
		s length=$l(config1,"^")
		f index=1:1:length{
			d ##class(Nur.NurseSetNew).save("",i1,"south",$p(config2,"^",index),$p(config1,"^",index),index,$p(config3,"^",index),$p(config4,"^",index),"","")
		}
		s config1="皮试非阴性^医嘱项截止^非独立医嘱^药库加锁"
		s config2="A^D^S^L"
		s config3="red^green^blue^yellow"
		s config4=$replace("error^error^error^error","error","Y")
		s length=$l(config1,"^")
		f index=1:1:length{
			d ##class(Nur.NurseSetNew).save("",i1,"error",$p(config2,"^",index),$p(config1,"^",index),index,$p(config3,"^",index),$p(config4,"^",index),"","")
		}
		d ##class(Nur.NurseSetNew).save("",i1,"period","0","","","0","1",$zth("00:01",2),$zth("10:00",2))
		d ##class(Nur.NurseSetNew).save("",i1,"other","0","","","","","","")
		d ##class(Nur.NurseSetNew).save("",i1,"other","1","","","","","","")
	}
	q ""
}

}
