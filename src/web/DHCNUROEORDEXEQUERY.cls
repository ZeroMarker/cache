Class web.DHCNUROEORDEXEQUERY Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//s b=##class(web.DHCNUROEORDEXEQUERY).getDHCNUROEORDEXEQUERY("2012-09-01","2012-09-01","817","10730046","8878","","add")

ClassMethod getDHCNUROEORDEXEQUERY(StDate, EDate, ConLoc, person, nurse, hnurse, funname, DateType)
{
 s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)

	   //s ^fish2012=StDate_"^"_EDate_"^"_ConLoc_"^"_person_"^"_nurse_"^"_hnurse_"^"_funname_"^"_DateType
	   f CurDate=StDate:1:EDate
    {     
         //i DateType="" s DateType="Date" //如果日期类型为空按执行日期查询
         i DateType="" s DateType="PYDate" //如果日期类型为空按配药日期查询         
         s rowid="" f  s rowid=$O(^DHCOrdExec(0,DateType,CurDate,rowid)) q:rowid=""  d
         .S username1="",username=""
         .s a=^DHCOrdExec(rowid)
         .s oeoredr=$p(a,"^",1)
         .s type=$p(a,"^",6)
         .//q:type'="CQSY"
         .s oeordrowid=$p(oeoredr,"||",1)
         .s admid=$p(^OEORD(oeordrowid),"^",1)
         .//b ;14
         .q:(person'="")&(person'=admid)
         .s papmi=$p(^PAADM(admid),"^",1)
         .s regon=$p(^PAPER(papmi,"PAT",1),"^",1)
         .s patname=$P(^PAPER(papmi,"ALL"),"^",1)
	     .s sex=$P(^CT("SEX",$P(^PAPER(papmi,"ALL"),"^",7)),"^",2)
         .s BedCodeid=$P(^PAADM(admid),"^",73)
         .i BedCodeid'=""  d
         ..s WARDRowID=$p(BedCodeid,"||",1)
         ..s BEDChildsub=$p(BedCodeid,"||",2)
         ..s BedCode=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1) 
         .e  d
         ..s BedCode=""
         .s ctlocwardId=$p(^PAADM(admid),"^",70)
         .q:ctlocwardId=""
         .s ctlocId= $p(^PAWARD(ctlocwardId),"^",5)
     
         .q:(ConLoc'="")&(ConLoc'=ctlocId)
         .//b ;13
         .s ctloc=$p(^CTLOC(ctlocId),"^" ,2)
         .s par=$p(oeoredr,"||",1)
         .s sub=$p(oeoredr,"||",2)
         .s ItmMastid=$P(^OEORD(par,"I",sub,1),"^",2)
         .s ItmMastdesc=$P(^ARCIM($p(ItmMastid,"||",1),$p(ItmMastid,"||",2),1),"^",2)
         .s DHCORIPeiMedica=$p(a,"^",18)
         .i DHCORIPeiMedica="Y" d
         ..s DHCORIPeiMedica="是"
         .e  d
         ..s DHCORIPeiMedica="否"
         .s DHCORIPeiMedicalUserdr=$p(a,"^",19)
         .i DHCORIPeiMedicalUserdr'="" d
         ..S careprov=$p(^SSU("SSUSR",DHCORIPeiMedicalUserdr),"^",14)
	     ..//s ^fuckwwt(nurse)=careprov
	     ..//q:(nurse'="")&(nurse'=careprov)
	     ..//i (nurse'="")&(nurse'=careprov) break
         ..S username=$p(^SSU("SSUSR",DHCORIPeiMedicalUserdr),"^",2)
         .q:(nurse'="")&(nurse'=careprov)
         
         .s DHCORIPeiMedicalDate=$p(a,"^",20)
         .i DHCORIPeiMedicalDate'="" d
         ..s DHCORIPeiMedicalDate=$zd(DHCORIPeiMedicalDate,3)
         .s DHCORIPeiMedicalTime=$p(a,"^",21)
         .i DHCORIPeiMedicalTime'="" d
         ..s DHCORIPeiMedicalTime=$zt(DHCORIPeiMedicalTime,1)
         .s DHCORIHeSMedical=$p(a,"^",22)
         .i DHCORIHeSMedical="Y" d
         ..s DHCORIHeSMedical="是"
         .e  d
         ..s DHCORIHeSMedical="否"
         .s DHCORIHeSMedicalUserdr=$p(a,"^",23)
         .i DHCORIHeSMedicalUserdr'="" d
         ..S careprov=$p(^SSU("SSUSR",DHCORIHeSMedicalUserdr),"^",14)
         ..S username1=$p(^SSU("SSUSR",DHCORIHeSMedicalUserdr),"^",2)
         .q:(hnurse'="")&(hnurse'=careprov)
         .s DHCORIHeSMedicallDate=$p(a,"^",24)
         .i DHCORIHeSMedicallDate'="" d
         ..s DHCORIHeSMedicallDate=$zd(DHCORIHeSMedicallDate,3)
         .s DHCORIHeSMedicallTime=$p(a,"^",25)
         .i DHCORIHeSMedicallTime'="" d
         ..s DHCORIHeSMedicallTime=$zt(DHCORIHeSMedicallTime,1)
		 .s rtnval=funname_"('"_$ZCVT($g(admid),"O","JS")_"','"_$ZCVT($g(regon),"O","JS")_"','"_$ZCVT($g(BedCode),"O","JS")_"','"_$ZCVT($g(patname),"O","JS")_"','"_$ZCVT($g(sex),"O","JS")_"','"_$ZCVT($g(ItmMastdesc),"O","JS")_"','"_$ZCVT($g(DHCORIPeiMedica),"O","JS")_"','"_$ZCVT($g(username),"O","JS")_"','"_$ZCVT($g(DHCORIPeiMedicalDate),"O","JS")_"','"_$ZCVT($g(DHCORIPeiMedicalTime),"O","JS")_"','"_$ZCVT($g(DHCORIHeSMedical),"O","JS")_"','"_$ZCVT($g(username1),"O","JS")_"','"_$ZCVT($g(DHCORIHeSMedicallDate),"O","JS")_"','"_$ZCVT($g(DHCORIHeSMedicallTime),"O","JS")_"','"_$ZCVT($g(ctloc),"O","JS")_"','"_$ZCVT($g(rowid),"O","JS")_"');"
	   
	     .&javascript<#(rtnval)#>
	   
    }
     q 0
}

//d ##class(web.DHCNUROEORDEXEQUERY).getDHCNURLABQUERY("2012-09-11","2012-09-11","814","","","add")

ClassMethod getDHCNURLABQUERY(StDate, EDate, ConLoc, person, nurse, funname)
{
 
     s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)
      f CurDate=StDate:1:EDate
    {     
          s rowid="" f  s rowid=$O(^DHCOrdExec(0,"Date",CurDate,rowid)) q:rowid=""  d
         .s exedate="",exetime="",LabReceiveDate="",LabReceivetime="",StatMin="",username=""
         .s a=^DHCOrdExec(rowid)
         .s oeoredr=$p(a,"^",1)
         .s oeordrowid=$p(oeoredr,"||",1)
         .s Childsub=$p(oeoredr,"||",2)
         .s ItmMastid=$P(^OEORD(oeordrowid,"I",Childsub,1),"^",2)
         .s Subscript=$p(ItmMastid,"||",1)
         .s Version=$p(ItmMastid,"||",2)
         .s ARCItemCat=$p(^ARCIM(Subscript,Version,1),"^",10)
         .s ordcat=$p(^ARC("IC",ARCItemCat),"^",8)
         .q:ordcat'=30   //去掉不是检验的
      	 .s OEORIItemStatDR=$p(^OEORD(oeordrowid,"I",Childsub,1),"^",13)
	     .q:OEORIItemStatDR=4 //去掉停止的
         .s admid=$p(^OEORD(oeordrowid),"^",1)
         .q:(person'="")&(person'=admid)  //不是这个病人
         .s papmi=$p(^PAADM(admid),"^",1)
         .s regon=$p(^PAPER(papmi,"PAT",1),"^",1)
         .s patname=$P(^PAPER(papmi,"ALL"),"^",1)
	     .s sex=$P(^CT("SEX",$P(^PAPER(papmi,"ALL"),"^",7)),"^",2)
         .s BedCodeid=$P(^PAADM(admid),"^",73)
         .i BedCodeid'=""  d
         ..s WARDRowID=$p(BedCodeid,"||",1)
         ..s BEDChildsub=$p(BedCodeid,"||",2)
         ..s BedCode=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1) 
         .e  d
         ..s BedCode="" 
	     .s ctlocwardId=$p(^PAADM(admid),"^",70)
         .q:ctlocwardId=""
         .s ctlocId= $p(^PAWARD(ctlocwardId),"^",5)
         .q:(ConLoc'="")&(ConLoc'=ctlocId) //不是这个病区的
	     .s ItmMastid=$P(^OEORD(oeordrowid,"I",Childsub,1),"^",2)
         .s ItmMastdesc=$P(^ARCIM($p(ItmMastid,"||",1),$p(ItmMastid,"||",2),1),"^",2)
         .s oeord=^OEORD(oeordrowid,"I",Childsub, "X",$p(oeoredr,"||",3))
         .s userid=$p(oeord,"^",15)
         .q:(nurse'="")&(nurse'=userid) //不是这个人执行的
         .s exedate=$p(a,"^",2)
         .s exetime=$p(a,"^",9)
         .s LabReceiveDate=$p(a,"^",13)
         .s LabReceivetime=$p(a,"^",14)
         .//s ^fish2012911(rowid)=exedate_"^"_exetime_"^"_LabReceiveDate_"^"_LabReceivetime
         .i (LabReceiveDate'="")&(LabReceivetime'="") d
         ..//b ;11
         ..s stdatetime=..GetAbsTime(exedate_","_exetime)
         ..s eddatetime=..GetAbsTime(LabReceiveDate_","_LabReceivetime)
         ..s ^fish2012911(rowid)=eddatetime_"^"_stdatetime
         ..s StatMin=(eddatetime-stdatetime)\60 
         .i LabReceiveDate'="" s LabReceiveDate=$zd(LabReceiveDate,3)
         .i LabReceivetime'="" s LabReceivetime=$zt(LabReceivetime,1)
         .i exedate'="" s exedate=$zd(exedate,3)
         .i exetime'="" s exetime=$zt(exetime,1)
         
         .s ctloc=$p(^CTLOC(ctlocId),"^" ,2)
         .i userid'="" s username=$p(^CTPCP(userid,1),"^",2) 
         .s rtnval=funname_"('"_$ZCVT($g(admid),"O","JS")_"','"_$ZCVT($g(regon),"O","JS")_"','"_$ZCVT($g(BedCode),"O","JS")_"','"_$ZCVT($g(patname),"O","JS")_"','"_$ZCVT($g(sex),"O","JS")_"','"_$ZCVT($g(ItmMastdesc),"O","JS")_"','"_$ZCVT($g(LabReceiveDate),"O","JS")_"','"_$ZCVT($g(LabReceivetime),"O","JS")_"','"_$ZCVT($g(exedate),"O","JS")_"','"_$ZCVT($g(exetime),"O","JS")_"','"_$ZCVT($g(username),"O","JS")_"','"_$ZCVT($g(StatMin),"O","JS")_"','"_$ZCVT($g(ctloc),"O","JS")_"');"
	     .&javascript<#(rtnval)#>
    }
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

Storage Default
{
<Data name="DHCNUROEORDEXEQUERYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNUROEORDEXEQUERYD</DataLocation>
<DefaultData>DHCNUROEORDEXEQUERYDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNUROEORDEXEQUERYD</IdLocation>
<IndexLocation>^web.DHCNUROEORDEXEQUERYI</IndexLocation>
<StreamLocation>^web.DHCNUROEORDEXEQUERYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
