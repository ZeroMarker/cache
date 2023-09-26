Import SQLUser

Class web.RunQianQueryDHCWL3 Extends %RegisteredObject [ Not ProcedureBlock ]
{

//----------------协和医院关于医保分析的统计lxc2013-08-12----------------------------------

//门诊医保患者费用明细报表【依据打发票时间为入口统计】

//登记号:18364484

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetMZYBInsu","2013-8-8","2013-8-8","","","","","普通门诊","","")   ;普通门诊  急诊留观   门诊特病

ClassMethod GetMZYBInsuExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, dept As %Text, doc As %String, insutype As %Text, jstype As %String, djh As %String, jsflag As %String) As %Status
{
	
	n (qHandle,startDate,endDate,hospid,dept,doc,insutype,jstype,djh,jsflag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s admInfo="" 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData1(dept,,.deptData)
	d SplitMulitData1(hospid,,.hospidData) 
	d SplitMulitData1(doc,,.docData)
	d SplitMulitData1(insutype,,.insutypeData)
	d SplitMulitData1(jstype,,.jstypeData)
    d SplitMulitData1(djh,,.djhData)
    d SplitMulitData1(jsflag,,.jsflagData)
    
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate  d
	.s sftsbz="",djlsh="",jslx=""
	.s prtId="" f  s prtId=$o(^DHCINVPRT(0,"Date",date,prtId)) q:prtId=""  d
    ..;s InsuDivDr=$p($g(^DHCINVPRT(prtId)),"^",30)
	..;q:InsuDivDr="" 
	..;q:prtId'=4883738
    ..s admInfo=##class(DHCWL.InsuStat.MZYBInfo).%New(prtId)
    ..q:admInfo="null"
    ..q:admInfo=""
    ..s adm=admInfo.AdmId  ;q:adm'=2942996
    ..s Flag=admInfo.Flag 
    ..//判断科室是否为所选科室
	..s dep=admInfo.DeptId
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断分院是否为所选医院
	..s hosp=$P($G(^CTLOC(dep)),"^",22)
	..i hosp=""  s hospcode=1
	..i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	..q:(hospid'="")&&(hospcode="") 
	..q:(hospid'="")&&('$d(hospidData(hospcode)))
	..//判断医师是否为所选医师
	..s DoctorId=admInfo.DoctorId
	..q:(doc'="")&&(DoctorId="") 
	..q:(doc'="")&&('$d(docData(DoctorId)))
	..//判断费别是否为所选费别
	..s admRea=admInfo.InsuTypeId
	..q:(insutype'="")&&(admRea="")
	..q:(insutype'="")&&('$d(insutypeData(admRea)))
    ..//判断类型是否为所选类型
  	..s jslx=admInfo.Jslx
	..q:(jstype'="")&&(jslx="") 
	..q:(jstype'="")&&('$d(jstypeData(jslx))) 
	..//判断登记号是否为所选登记号
	..s djNo=admInfo.PatNo
	..q:(djh'="")&&(djNo="") 
	..q:(djh'="")&&('$d(djhData(djNo)))
	..//判断状态是否为所选结算状态
	..q:(jsflag'="")&&(Flag="") 
	..q:(jsflag'="")&&('$d(jsflagData(Flag))) 
	..d OutputRow1
	..s admInfo=""
	q $$$OK
	
OutputRow1
    s Data=$lb(admInfo.FBId,admInfo.Flag,admInfo.DeptId,admInfo.Dept,admInfo.DoctorId,admInfo.Doctor,admInfo.PrtDate,admInfo.FundType,admInfo.FundTypeDesc,admInfo.yllb,admInfo.yllbDesc,admInfo.InsuNo,admInfo.AdmId,admInfo.PatNo,admInfo.SfzH,admInfo.Name,admInfo.Sex,admInfo.Age,admInfo.InsuTypeId,admInfo.InsuType,admInfo.Jslx,admInfo.djlsh,admInfo.sftsbz,admInfo.TotalFee,admInfo.InsuFee,admInfo.PatFee,admInfo.XYFFee,admInfo.ZYFFee,admInfo.ZCYFee,admInfo.HYFee,admInfo.FSFee,admInfo.BCFee,admInfo.CTFee,admInfo.HCFee,admInfo.JCFee,admInfo.ZLFee,admInfo.CLFee,admInfo.SSFee,admInfo.SYFee,admInfo.SXFee,admInfo.ZJFee,admInfo.XYFee,admInfo.SFJDFee,admInfo.QTFee)  
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData1(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	q
}

ClassMethod GetMZYBInsuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZYBInsuExecute ]
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

ClassMethod GetMZYBInsuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZYBInsuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMZYBInsu(startDate As %String, endDate As %String, hospid As %String, dept As %Text, doc As %String, insutype As %Text, jstype As %String, djh As %String, jsflag As %String) As %Query(ROWSPEC = "FBId:%String,Flag:%String,DeptId:%String,Dept:%String,DoctorId:%String,Doctor:%String,PrtDate:%String,FundType:%String,FundTypeDesc:%String,yllb:%String,yllbDesc:%String,InsuNo:%String,AdmId:%String,PatNo:%String,SfzH:%String,Name:%String,Sex:%String,Age:%String,InsuTypeId:%String,InsuType:%String,Jslx:%String,djlsh:%String,sftsbz:%String,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,XYFFee:%Float,ZYFFee:%Float,ZCYFee:%Float,HYFee:%Float,FSFee:%Float,BCFee:%Float,CTFee:%Float,HCFee:%Float,JCFee:%Float,ZLFee:%Float,CLFee:%Float,SSFee:%Float,SYFee:%Float,SXFee:%Float,ZJFee:%Float,XYFee:%Float,SFJDFee:%Float,QTFee:%Float") [ SqlProc ]
{
}

//出院医保患者费用明细报表【依据打发票时间为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetDisPatInsuMx","2013-8-30","2013-8-30","","","","","","","")

ClassMethod GetDisPatInsuMxExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Status
{
	n (qHandle,startDate,endDate,hospid,dept,ward,insutype,shy,insudiafl,insudiadesc,djh)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	;k ^lxc2,^lxc1
 	;s ^lxc2=startDate_"^"_endDate_"^"_dept_"^"_ward_"^"_insutype_"^"_shy_"^"_insudiafl_"^"_insudiadesc
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData2(hospid,,.hospidData) 
	d SplitMulitData2(dept,,.deptData)
	d SplitMulitData2(ward,,.wardData)
	d SplitMulitData2(insutype,,.insuData)
	d SplitMulitData2(shy,,.shyData)
	d SplietDoubleDetmData2(insudiafl,,.diaflData)
	d SplitMulitData2(insudiadesc,,.diadescData)
	d SplitMulitData2(djh,,.djhData)
	;m ^lxc1=deptData
	s pbId=""
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate  d
	.s prtId=0
	.s prtId=0 f  s prtId=$o(^DHCINVPRTZY(0,"DATE",date,prtId)) q:prtId=""  d
	..s flag=$p(^DHCINVPRTZY(prtId),"^",8) q:((flag="A") ! (flag="I")) 
	..s adm=$p(^DHCINVPRTZY(prtId),"^",4) ;q:adm'=2970820
	..q:'$d(^DHCINDIV(0,"Paadm",adm))
	..s initinv=$p(^DHCINVPRTZY(prtId),"^",13)
	..s pbId1=$p(^DHCINVPRTZY(prtId),"^",5)
	..s pbIdSC=pbId1
	..i flag="S" d
	...s pbId2=$p(^DHCINVPRTZY(initinv),"^",5)
	...s pbId=pbId2
	..e  d 
	...s pbId=pbId1
	..;w pbId_"!"
	..;q:pbId'=5664328
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
    ..q:admInfo="null"
    ..q:admInfo=""
    ..s code=admInfo.NationCode  
	..q:code=""
	..s TotalFeeYb=admInfo.TotalFeeYb 
    ..s InsuFeeYb=admInfo.InsuFeeYb
    ..;w prtId_"^"_flag_"^"_pbId_"^"_TotalFeeYb_"^"_InsuFeeYb_";"
    ..i flag="S" s TotalFeeYb=TotalFeeYb *(-1),InsuFeeYb=InsuFeeYb *(-1)
   	..//判断科室是否为所选科室
	..s dep=admInfo.DeptId 
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断分院是否为所选医院
	..s hosp=$P($G(^CTLOC(dep)),"^",22)
	..i hosp=""  s hospcode=1
	..i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	..q:(hospid'="")&&(hospcode="") 
	..q:(hospid'="")&&('$d(hospidData(hospcode)))
	..//判断病区是否为所选病区
	..;i admWard=
	..s admWard=admInfo.WardId
	..;i admInfo.WardId
	..q:(ward'="")&&(admWard="")
	..q:(ward'="")&&('$d(wardData(admWard)))
	..//判断费别是否为所选费别
	..s admRea=admInfo.InsuTypeId
	..q:(admRea="")&&(insutype'="")
	..q:(insutype'="")&&('$d(insuData(admRea)))
    ..//判断审核员是否为所选审核员
	..s shyr=admInfo.Shy
	..q:(shy'="")&&(shyr="")
	..q:(shy'="")&&(shyr'="")&&('$d(shyData(shyr)))
	..//判断单病种分类是否为所选单病种分类
	..s diafl=admInfo.InsudiaId
	..q:(diafl="")&&(insudiafl'="")
	..q:(insudiafl'="")&&('$d(diaflData(diafl)))
	..//判断单病种是否为所选单病种
	..s diadesc=admInfo.InsudiaId
	..q:(diadesc="")&&(insudiadesc'="")
	..q:(insudiadesc'="")&&('$d(diadescData(diadesc)))
	..//判断登记号是否为所选登记号
	..s djNo=admInfo.PatNo
	..q:(djh'="")&&(djNo="") 
	..q:(djh'="")&&('$d(djhData(djNo))) 
	..d admInfo.SetPBFeeInfo()
	..s PBFee=admInfo.PBFee
	..i flag="S" d 
    ...s PBFee=PBFee *(-1)
	..s catId=0
	..f  s catId=$o(^DHCTarC("TIC",catId)) q:catId=""  d
	...s catCode=$p(^DHCTarC("TIC",catId),"^",1)
	...s catDesc=$p(^DHCTarC("TIC",catId),"^",2)
	...s TotalFee=+$g(admInfo.TotalFee.Data(catId))
    ...s InsuFee=+$g(admInfo.InsuFee.Data(catId))
    ...s PatFee=+$g(admInfo.PatFee.Data(catId))
	...i flag="S" d 
    ....s TotalFee=TotalFee *(-1)
    ....s InsuFee=InsuFee *(-1)
    ....s PatFee=PatFee *(-1)
	...d OutputRow2
	..s admInfo=""
	    
  	q $$$OK
OutputRow2
	s Data=$lb(pbIdSC,admInfo.AdmId,admInfo.MedNo,admInfo.PatNo,admInfo.Name,admInfo.Age,admInfo.AdmDATE,admInfo.DisDate,admInfo.Dept,admInfo.Ward,admInfo.InsuType,admInfo.Doctor,PBFee,TotalFeeYb,InsuFeeYb,TotalFee,InsuFee,PatFee,catCode,catDesc,admInfo.DiagCj,admInfo.InsudiaFl,admInfo.Insudiadesc,admInfo.Shy,admInfo.OutDiagDesc,admInfo.InsuStatus)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData2(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	
	q
SplietDoubleDetmData2(multiStr,detm=",^",multiData)
	n (multiStr,detm,multiData)
	k multiData
	s detmData(1)=$e(detm,1)
	s detmData(2)=$e(detm,2)
	
	s multiLen=$l(multiStr,detmData(1))
	f len=1:1:multiLen d
	.s data1=$p(multiStr,detmData(1),len)
	.s multiLen2=$l(data1,detmData(2))
	.f len2=1:1:multiLen2 d
	..s data2=$p(data1,detmData(2),len2)
	..q:data2=""
	..s multiData(data2)=""
	
	q
}

ClassMethod GetDisPatInsuMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisPatInsuMxExecute ]
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

ClassMethod GetDisPatInsuMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisPatInsuMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDisPatInsuMx(startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Query(ROWSPEC = "pbIdSC:%String,AdmId:%String,MedNo:%String,PatNo:%String,Name:%String,Age:%String,AdmDATE:%String,DisDate:%String,Dept:%String,Ward:%String,InsuType:%String,Doctor:%String,PBFee:%Float,TotalFeeYb:%Float,InsuFeeYb:%Float,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,catCode:%String,catDesc:%String,DiagCj:%Float,InsudiaFl:%String,Insudiadesc:%String,Shy:%String,OutDiagDesc:%String,InsuStatus:%String") [ SqlProc ]
{
}

//患者费用信息

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetPatFeeMx","3264953")	

ClassMethod GetPatFeeMxExecute(ByRef qHandle As %Binary, admId As %String) As %Status
{
	n (qHandle,admId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:admId=""
    s WLRowid=0 f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",admId,WLRowid)) q:WLRowid=""  d
	.s Resloc=$p(^DHCWorkLoad(WLRowid),"^",3)  ;病人科室
	.s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4)
	.s PatDocId=$p($g(^DHCWorkLoad(WLRowid)),"^",25)  ;病人医师
	.s papmi=$p(^DHCWorkLoad(WLRowid),"^",13)  ;PAPMI_RowId
	.s djh=$$GetPapmiNo^DHCWLCommon(papmi) //通过PA_PatMas.PAPMI_RowId得到病人登记号
	.s Ordate1=$p(^DHCWorkLoad(WLRowid),"^",5)  ;医嘱日期
	.s Ordate=$zd(Ordate1,3)
	.s Time=$p(^DHCWorkLoad(WLRowid),"^",6)    ;医嘱时间
	.s Time=$zt(Time,1)
	.s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    .s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .s itm=$p(^DHCWorkLoad(WLRowid),"^",22)    ;收费项目
    .s TarCate=$p(^DHCTARI(itm),"^",14)  ;住院子分类
    .s itmdesc=$p(^DHCTARI(itm),"^",2)
    .d OutputRow3
 	q $$$OK	

OutputRow3
    i $d(^CTLOC(Resloc)) d
    .s DepName1=$P($G(^CTLOC(Resloc)),"^",2)  
    .i DepName1 [ "-" s DepName=$p(DepName1,"-",2)
    .e  s DepName=DepName1
    i $d(^CTPCP(PatDocId)) s resdoccode=$p(^CTPCP(PatDocId,1),"^",1),resdocname=$p(^CTPCP(PatDocId,1),"^",2)
     
    s name=$$GetPapmiName^DHCWLCommon(papmi)   //通过PA_PatMas.PAPMI_RowId得到病人姓名
    s sex=$$GetSex^DHCWLCommon(papmi) //病人性别
    s jfdate=Ordate_" "_Time
    i $d(^DHCTarC("IC",TarCate)) s Subdesc=$p(^DHCTarC("IC",TarCate),"^",2) 
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
     
    s Data=$lb(Resloc,DepName,PatDocId,resdoccode,resdocname,djh,admId,name,sex,Ordate1,Ordate,jfdate,TarCate,Subdesc,itm,itmdesc,qty,Fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData3(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetPatFeeMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatFeeMxExecute ]
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

ClassMethod GetPatFeeMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatFeeMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatFeeMx(admId As %String) As %Query(ROWSPEC = "Resloc:%String,DepName:%String,PatDocId:%String,resdoccode:%String,resdocname:%String,djh:%String,admId:%String,name:%String,sex:%String,Ordate1:%Integer,Ordate:%String,jfdate:%String,TarCate:%String,Subdesc:%String,itm:%Integer,itmdesc:%String,qty:%Float,Fee:%Float") [ SqlProc ]
{
}

//门诊医保患者费用明细报表【依据数据上传时间为入口统计】

//登记号:18364484

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetMZYBInsu1","2013-8-8","2013-8-8","","","","","普通门诊","","")   ;普通门诊  急诊留观   门诊特病

ClassMethod GetMZYBInsu1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, dept As %Text, doc As %String, insutype As %Text, jstype As %String, djh As %String, jsflag As %String) As %Status
{
	n (qHandle,startDate,endDate,hospid,dept,doc,insutype,jstype,djh,jsflag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s admInfo="" 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData4(dept,,.deptData)
	d SplitMulitData4(hospid,,.hospidData) 
	d SplitMulitData4(doc,,.docData)
	d SplitMulitData4(insutype,,.insutypeData)
	d SplitMulitData4(jstype,,.jstypeData)
    d SplitMulitData4(djh,,.djhData)
    d SplitMulitData4(jsflag,,.jsflagData)
    
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
    for iDate=startDate:1:endDate d
	.;//挂号明细
	.s InsuDivDr=""
	.f  s InsuDivDr=$o(^DHCINADM("0","FunDate",iDate,InsuDivDr)) q:InsuDivDr=""  d
	..s Flag=$p($g(^DHCINADM(InsuDivDr)),"^",11)
	..q:(Flag="D")||(Flag="Card")
	..s adm=$p($g(^DHCINADM(InsuDivDr)),"^",1)
	..;q:adm=""
	..i adm="" d
	...s AdmId=""
	...s Name=$p($g(^DHCINADM(InsuDivDr)),"^",6)
	...s SfzH=""
	...s PatNo=""
    ...s Sex=""
 	...s Brithday=""
	...s Age=""
    ...s dep=""
	...s deptsc="Null"
	...s DeptId=dep ;科室ID
	...s Dept=deptsc ;科室
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dep="") 
	...q:(dept'="")&&('$d(deptData(dep)))
	...//判断分院是否为所选医院
	...s hosp=""
	...i hosp=""  s hospcode=1
	...q:(hospid'="")&&(hospcode="") 
	...q:(hospid'="")&&('$d(hospidData(hospcode)))
	...s DoctorId=""
    ...s DoctorId="999999"
    ...s Doctor="Null"
    ...//判断医师是否为所选医师
	...q:(doc'="")&&(DoctorId="") 
	...q:(doc'="")&&('$d(docData(DoctorId)))
    ...//判断费别是否为所选费别
	...s admRea=""
	...;s admRea=$p($g(^PAADM(adm,1)),"^",7) ;q:admRea'=""
	...q:(insutype'="")&&(admRea="")
	...q:(insutype'="")&&('$d(insutypeData(admRea)))
	...s InsuTypeId=admRea
	...s InsuType=$$GetReason^DHCWLCommon(adm)
    ...//判断类型是否为所选类型
    ...s jslx="普通门诊"
    ...q:(jstype'="")&&(jslx="") 
	...q:(jstype'="")&&('$d(jstypeData(jslx))) 
	...//判断登记号是否为所选登记号
	...s PatNo=""
	...q:(djh'="")&&(PatNo="") 
	...q:(djh'="")&&('$d(djhData(PatNo)))
	...//判断状态是否为所选结算状态
	...q:(jsflag'="")&&(Flag="") 
	...q:(jsflag'="")&&('$d(jsflagData(Flag))) 
	...s PrtDate1=$p($g(^DHCINADM(InsuDivDr)),"^",24)
	...s PrtTime1=$p($g(^DHCINADM(InsuDivDr)),"^",25)
	...s PrtDate1=$zd(PrtDate1,3)
	...s PrtTime1=$zt(PrtTime1,1)
	...s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	...s InsuNo=$p($g(^DHCINADM(InsuDivDr)),"^",18)  //医保号
	...s yllb=$p($g(^DHCINADM(InsuDivDr)),"^",4)    //医疗类别
    ...s FundType=$p($g(^DHCINADM(InsuDivDr)),"^",18) //险种类型
	...s outstr1=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	...s yllbDesc=$p(outstr1,"^",4)  //医疗人员类别名称
	...s outstr2=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	...s FundTypeDesc=$p(outstr2,"^",4)   //险种类型名称
 	...s bcbxf0=$p($g(^DHCINADM(InsuDivDr)),"^",26) q:bcbxf0=0 //总费用
    ...s jjzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",28)  //基金支付
	...s grzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",27)   //个人支付
	...s zhzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",29)   //账户支付
	...s TotalFee=bcbxf0,InsuFee=jjzfe0+zhzfe0,PatFee=grzfe0
	...s (XYFFee,ZYFFee,ZCYFee,HYFee,FSFee,BCFee,CTFee,HCFee,JCFee,ZLFee,CLFee,SSFee,SYFee,SXFee,ZJFee,XYFee,SFJDFee,QTFee)=0
	...d OutputRow4
	..i adm'="" d
	...s AdmId=adm
	...s paadmType=$p($g(^PAADM(adm)),"^",2) 
	...q:((paadmType'="O") && (paadmType'="E"))
    ...s papmi=$p($g(^PAADM(adm)),"^",1)
    ...s SfzH=$$GetPatId^DHCWLCommon(papmi) ;身份证号
	...s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	...s Name=$$GetPapmiName^DHCWLCommon(papmi) ;姓名
    ...s Sex=$$GetSex^DHCWLCommon(papmi) ;性别
 	...s Brithday=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	...s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    ...s dep=$p(^PAADM(adm),"^",4)
	...i dep="" d
	....s dep="999999"
	....s deptsc="Null"
	...e  d
	....s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	....s DeptId=dep ;科室ID
	....s Dept=deptsc ;科室
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dep="") 
	...q:(dept'="")&&('$d(deptData(dep)))
	...//判断分院是否为所选医院
	...s hosp=$P($G(^CTLOC(dep)),"^",22)
	...i hosp=""  s hospcode=1
	...i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	...q:(hospid'="")&&(hospcode="") 
	...q:(hospid'="")&&('$d(hospidData(hospcode)))
	...s DoctorId=$p(^PAADM(adm),"^",9)
    ...i DoctorId'=""  d 
    ....s Doctor=$p(^CTPCP(DoctorId,1),"^",2 )
    ...e  d
    ....s DoctorId="999999"
    ....s Doctor="Null"
    ...//判断医师是否为所选医师
	...q:(doc'="")&&(DoctorId="") 
	...q:(doc'="")&&('$d(docData(DoctorId)))
    ...//判断费别是否为所选费别
	...s admRea=$p($g(^PAADM(adm,1)),"^",7) ;q:admRea'=""
	...q:(insutype'="")&&(admRea="")
	...q:(insutype'="")&&('$d(insutypeData(admRea)))
	...s InsuTypeId=admRea
	...s InsuType=$$GetReason^DHCWLCommon(adm)
    ...//判断类型是否为所选类型
    ...s jslx="普通门诊"
    ...q:(jstype'="")&&(jslx="") 
	...q:(jstype'="")&&('$d(jstypeData(jslx))) 
	...//判断登记号是否为所选登记号
	...s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	...q:(djh'="")&&(PatNo="") 
	...q:(djh'="")&&('$d(djhData(PatNo)))
	...//判断状态是否为所选结算状态
	...q:(jsflag'="")&&(Flag="") 
	...q:(jsflag'="")&&('$d(jsflagData(Flag))) 
	...s PrtDate1=$p($g(^DHCINADM(InsuDivDr)),"^",24)
	...s PrtTime1=$p($g(^DHCINADM(InsuDivDr)),"^",25)
	...s PrtDate1=$zd(PrtDate1,3)
	...s PrtTime1=$zt(PrtTime1,1)
	...s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	...s InsuNo=$p($g(^DHCINADM(InsuDivDr)),"^",18)  //医保号
	...s yllb=$p($g(^DHCINADM(InsuDivDr)),"^",4)    //医疗类别
    ...s FundType=$p($g(^DHCINADM(InsuDivDr)),"^",18) //险种类型
	...s outstr1=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	...s yllbDesc=$p(outstr1,"^",4)  //医疗人员类别名称
	...s outstr2=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	...s FundTypeDesc=$p(outstr2,"^",4)   //险种类型名称
 	...s bcbxf0=$p($g(^DHCINADM(InsuDivDr)),"^",26) q:bcbxf0=0 //总费用
    ...s jjzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",28)  //基金支付
	...s grzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",27)   //个人支付
	...s zhzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",29)   //账户支付
	...s TotalFee=bcbxf0,InsuFee=jjzfe0+zhzfe0,PatFee=grzfe0
	...s (XYFFee,ZYFFee,ZCYFee,HYFee,FSFee,BCFee,CTFee,HCFee,JCFee,ZLFee,CLFee,SSFee,SYFee,SXFee,ZJFee,XYFee,SFJDFee,QTFee)=0
	...d OutputRow4
	.//----------------------结算明细----------------------
	.s InsuDivDr1=""
	.f  s InsuDivDr1=$o(^DHCINDIV("0","IDate",iDate,InsuDivDr1)) q:InsuDivDr1=""  d
	..s office=1,Jslx=""
	..S (bcbxf0,grzfe0,jjzfe0,zhzfe0,Xyf,Zyf,Cyf)=0
	..s Flag=$p($g(^DHCINDIV(InsuDivDr1)),"^",5)
	..q:Flag="divide"
	..s adm=$p($g(^DHCINDIV(InsuDivDr1)),"^",1)
	..q:adm=""
	..s AdmId=adm
	..s paadmType=$p($g(^PAADM(adm)),"^",2) 
	..q:((paadmType'="O") && (paadmType'="E"))
    ..s papmi=$p($g(^PAADM(adm)),"^",1)
    ..s SfzH=$$GetPatId^DHCWLCommon(papmi) ;身份证号
	..s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	..s Name=$$GetPapmiName^DHCWLCommon(papmi) ;姓名
	..s Sex=$$GetSex^DHCWLCommon(papmi) ;性别
 	..s Brithday=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	..s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    ..s dep=$p(^PAADM(adm),"^",4)
	..i dep="" d
	...s dep="999999"
	...s deptsc="Null"
	..e  d
	...s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	...s DeptId=dep ;科室ID
	...s Dept=deptsc ;科室
	..//判断科室是否为所选科室
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断分院是否为所选医院
	..s hosp=$P($G(^CTLOC(dep)),"^",22)
	..i hosp=""  s hospcode=1
	..i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	..q:(hospid'="")&&(hospcode="") 
	..q:(hospid'="")&&('$d(hospidData(hospcode)))
	..s DoctorId=$p(^PAADM(adm),"^",9)
    ..i DoctorId'=""  d 
    ...s Doctor=$p(^CTPCP(DoctorId,1),"^",2 )
    ..e  d
    ...s DoctorId="999999"
    ...s Doctor="Null"
    ..//判断医师是否为所选医师
	..q:(doc'="")&&(DoctorId="") 
	..q:(doc'="")&&('$d(docData(DoctorId)))
    ..//判断费别是否为所选费别
	..s admRea=$p($g(^PAADM(adm,1)),"^",7) ;q:admRea'=""
	..q:(insutype'="")&&(admRea="")
	..q:(insutype'="")&&('$d(insutypeData(admRea)))
	..s InsuTypeId=admRea
	..s InsuType=$$GetReason^DHCWLCommon(adm)
    ..//判断类型是否为所选类型
    ..s djlsh=$p($g(^DHCINDIV(InsuDivDr1)),"^",8)
	..s sftsbz=$p($g(^DHCINDIV(InsuDivDr1)),"^",25)
	..i (sftsbz'="Y")&&(djlsh'="") s jslx="普通门诊"
	..i sftsbz="Y"  s jslx="门诊特病"
	..i (sftsbz'="Y")&&(djlsh="") s jslx="急诊留观"
	..i (((Flag="strike") && (jslx="门诊特病")) ! ((Flag="strike") &&(jslx="急诊留观"))) s office=-1
   	..q:(jstype'="")&&(jslx="") 
	..q:(jstype'="")&&('$d(jstypeData(jslx))) 
	..//2013-09-18 lxc add 
	..s PrtInuFlag="Y"  
	..i ((jslx="门诊特病") ! (jslx="急诊留观"))  d
	...s mCorrDiv=$g(^DHCINDIV(InsuDivDr1))
	...s PrtInuFlag="N"
	...i Flag="strike" d
	....s INSUDivideDr=$p(mCorrDiv,"^",6)    ; add liusf 2012 11 14
	...e   d
	....s INSUDivideDr=InsuDivDr1
	...s PrtInvDr=""
	...f  s PrtInvDr=$o(^DHCINVPRT(0,"INSDIV",INSUDivideDr,PrtInvDr)) q:PrtInvDr=""  d
	....s FairType=$p($g(^DHCINVPRT(PrtInvDr)),"^",34)
	....s:FairType="F" PrtInuFlag="Y"
	..q:PrtInuFlag="N"
	..//2013-09-18 lxc add  
	..//判断登记号是否为所选登记号
	..s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	..q:(djh'="")&&(PatNo="") 
	..q:(djh'="")&&('$d(djhData(PatNo)))
	..//判断状态是否为所选结算状态
	..q:(jsflag'="")&&(Flag="") 
	..q:(jsflag'="")&&('$d(jsflagData(Flag))) 
	..s PrtDate1=$p($g(^DHCINDIV(InsuDivDr1)),"^",16)
	..s PrtTime1=$p($g(^DHCINDIV(InsuDivDr1)),"^",17)
	..s PrtDate1=$zd(PrtDate1,3)
	..s PrtTime1=$zt(PrtTime1,1)
	..s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	..s InsuAdmDr=$p($g(^DHCINDIV(InsuDivDr1)),"^",2)
	..i InsuAdmDr="" d
	...s yllb="",yllbDesc=""
	...s FundType="",FundTypeDesc=""
	..e     d
	...s yllb=$p($g(^DHCINADM(InsuAdmDr)),"^",4)    //医疗类别
	...s FundType=$p($g(^DHCINADM(InsuAdmDr)),"^",18) //险种类型
	...s outstr3=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	...s yllbDesc=$p(outstr3,"^",4)  //医疗人员类别名称
	...s outstr4=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	...s FundTypeDesc=$p(outstr4,"^",4)   //险种类型名称
 	..s bcbxf0=$p($g(^DHCINDIV(InsuDivDr1)),"^",7) * office   //总费用
	..s jjzfe0=$p($g(^DHCINDIV(InsuDivDr1)),"^",19)* office   //基金支付
	..s grzfe0=$p($g(^DHCINDIV(InsuDivDr1)),"^",15)* office   //个人支付
	..s zhzfe0=$p($g(^DHCINDIV(InsuDivDr1)),"^",28)* office  //账户支付
    ..s TotalFee=bcbxf0,InsuFee=jjzfe0+zhzfe0,PatFee=grzfe0
    ..//;西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
    ..i Flag'="strike" d
 	...s medicatalog=$p($g(^DHCINDIV(InsuDivDr1)),"^",45)  //费用分类      西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
	...s $p(medicatalog,"|",9)=bcbxf0-$p(medicatalog,"|",1)-$p(medicatalog,"|",2)-$p(medicatalog,"|",3)-$p(medicatalog,"|",4)-$p(medicatalog,"|",5)-$p(medicatalog,"|",6)-$p(medicatalog,"|",7)-$p(medicatalog,"|",8)-$p(medicatalog,"|",10)-$p(medicatalog,"|",11)-$p(medicatalog,"|",12)-$p(medicatalog,"|",13)-$p(medicatalog,"|",14)-$p(medicatalog,"|",15)-$p(medicatalog,"|",16)-$p(medicatalog,"|",17)-$p(medicatalog,"|",18)
	..i Flag="strike" d
	...s bestrikeDr=$p($g(^DHCINDIV(InsuDivDr1)),"^",6)
	...s medicatalog=$p($g(^DHCINDIV(bestrikeDr)),"^",45)  //费用分类      西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
	...s $p(medicatalog,"|",9)=bcbxf0+$p(medicatalog,"|",1)+$p(medicatalog,"|",2)+$p(medicatalog,"|",3)+$p(medicatalog,"|",4)+$p(medicatalog,"|",5)+$p(medicatalog,"|",6)+$p(medicatalog,"|",7)+$p(medicatalog,"|",8)+$p(medicatalog,"|",10)+$p(medicatalog,"|",11)+$p(medicatalog,"|",12)+$p(medicatalog,"|",13)+$p(medicatalog,"|",14)+$p(medicatalog,"|",15)+$p(medicatalog,"|",16)+$p(medicatalog,"|",17)+$p(medicatalog,"|",18) 
    ..s XYFFee=$p(medicatalog,"|",1)* office  ;西药
    ..s ZYFFee=$p(medicatalog,"|",2)* office  ;中成药
	..s ZCYFee=$p(medicatalog,"|",3)* office  ;中草药
	..s HYFee=$p(medicatalog,"|",4)* office ;化验
	..s FSFee=$p(medicatalog,"|",5)* office ;放射
	..s BCFee=$p(medicatalog,"|",6)* office ;B超
	..s CTFee=$p(medicatalog,"|",7)* office ;CT
	..s HCFee=$p(medicatalog,"|",8)* office ;核磁
	..s JCFee=$p(medicatalog,"|",9) ;检查费
	..s ZLFee=$p(medicatalog,"|",10)* office ;治疗费
	..s CLFee=$p(medicatalog,"|",11)* office ;材料费
	..s SSFee=$p(medicatalog,"|",12)* office ;手术费
	..s SYFee=$p(medicatalog,"|",13)* office  ;输氧费
	..s SXFee=$p(medicatalog,"|",14)* office ;输血费
	..s ZJFee=$p(medicatalog,"|",15)* office ;正畸费
	..s XYFee=$p(medicatalog,"|",16)* office ;镶牙费
	..s SFJDFee=$p(medicatalog,"|",17)* office ;司法鉴定
	..s QTFee=$p(medicatalog,"|",18)* office ;其他
	..d OutputRow4
	q $$$OK
OutputRow4
    s Data=$lb(Flag,DeptId,Dept,DoctorId,Doctor,PrtDate,FundType,FundTypeDesc,yllb,yllbDesc,InsuNo,AdmId,PatNo,SfzH,Name,Sex,Age,InsuTypeId,InsuType,jslx,djlsh,sftsbz,TotalFee,InsuFee,PatFee,XYFFee,ZYFFee,ZCYFee,HYFee,FSFee,BCFee,CTFee,HCFee,JCFee,ZLFee,CLFee,SSFee,SYFee,SXFee,ZJFee,XYFee,SFJDFee,QTFee)  
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData4(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	q
}

ClassMethod GetMZYBInsu1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZYBInsu1Execute ]
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

ClassMethod GetMZYBInsu1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZYBInsu1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMZYBInsu1(startDate As %String, endDate As %String, hospid As %String, dept As %Text, doc As %String, insutype As %Text, jstype As %String, djh As %String, jsflag As %String) As %Query(ROWSPEC = "Flag:%String,DeptId:%String,Dept:%String,DoctorId:%String,Doctor:%String,PrtDate:%String,FundType:%String,FundTypeDesc:%String,yllb:%String,yllbDesc:%String,InsuNo:%String,AdmId:%String,PatNo:%String,SfzH:%String,Name:%String,Sex:%String,Age:%String,InsuTypeId:%String,InsuType:%String,Jslx:%String,djlsh:%String,sftsbz:%String,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,XYFFee:%Float,ZYFFee:%Float,ZCYFee:%Float,HYFee:%Float,FSFee:%Float,BCFee:%Float,CTFee:%Float,HCFee:%Float,JCFee:%Float,ZLFee:%Float,CLFee:%Float,SSFee:%Float,SYFee:%Float,SXFee:%Float,ZJFee:%Float,XYFee:%Float,SFJDFee:%Float,QTFee:%Float") [ SqlProc ]
{
}

//出院医保患者费用明细报表【依据上传时间找发票为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetDisPatInsuMx1","2013-10-11","2013-10-11","","","","","","","","")

ClassMethod GetDisPatInsuMx1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Status
{
	n (qHandle,startDate,endDate,hospid,dept,ward,insutype,shy,insudiafl,insudiadesc,djh)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	;k ^lxc2,^lxc1
 	;s ^lxc2=startDate_"^"_endDate_"^"_dept_"^"_ward_"^"_insutype_"^"_shy_"^"_insudiafl_"^"_insudiadesc
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData5(hospid,,.hospidData) 
	d SplitMulitData5(dept,,.deptData)
	d SplitMulitData5(ward,,.wardData)
	d SplitMulitData5(insutype,,.insuData)
	d SplitMulitData5(shy,,.shyData)
	d SplietDoubleDetmData5(insudiafl,,.diaflData)
	d SplitMulitData5(insudiadesc,,.diadescData)
	d SplitMulitData5(djh,,.djhData)
	;m ^lxc1=deptData
	s pbId=""
    s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
    for iDate=startDate:1:endDate d
    .s InsuDivDr1=""
	.f  s InsuDivDr1=$o(^DHCINDIV("0","IDate",iDate,InsuDivDr1)) q:InsuDivDr1=""  d
	..s office=1,Jslx=""
	..S (bcbxf0,grzfe0,jjzfe0,zhzfe0,Xyf,Zyf,Cyf)=0
	..s Flag=$p($g(^DHCINDIV(InsuDivDr1)),"^",5)
	..q:Flag="divide"
	..s adm=$p($g(^DHCINDIV(InsuDivDr1)),"^",1)
	..q:'$d(^DHCINDIV(0,"Paadm",adm))
	..s paadmType=$p($g(^PAADM(adm)),"^",2) q:paadmType'="I"
	..s PrtDate1=$p($g(^DHCINDIV(InsuDivDr1)),"^",16)
	..s PrtTime1=$p($g(^DHCINDIV(InsuDivDr1)),"^",17)
	..s PrtDate1=$zd(PrtDate1,3)
	..s PrtTime1=$zt(PrtTime1,1)
	..s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	..s pbId1=$p($g(^DHCINDIV(InsuDivDr1)),"^",3) ;q:pbId1=""
    ..s pbIdSC=pbId1
	..s pbId=pbId1
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
    ..q:admInfo="null"
    ..q:admInfo=""
    ..s code=admInfo.NationCode  
	..q:code=""
	..s TotalFeeYb=admInfo.TotalFeeYb 
    ..s InsuFeeYb=admInfo.InsuFeeYb
    ..;w prtId_"^"_flag_"^"_pbId_"^"_TotalFeeYb_"^"_InsuFeeYb_";"
    ..i Flag="strike" s TotalFeeYb=TotalFeeYb *(-1),InsuFeeYb=InsuFeeYb *(-1)
   	..//判断科室是否为所选科室
	..s dep=admInfo.DeptId 
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断分院是否为所选医院
	..s hosp=$P($G(^CTLOC(dep)),"^",22)
	..i hosp=""  s hospcode=1
	..i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	..q:(hospid'="")&&(hospcode="") 
	..q:(hospid'="")&&('$d(hospidData(hospcode)))
	..//判断病区是否为所选病区
	..;i admWard=
	..s admWard=admInfo.WardId
	..;i admInfo.WardId
	..q:(ward'="")&&(admWard="")
	..q:(ward'="")&&('$d(wardData(admWard)))
	..//判断费别是否为所选费别
	..s admRea=admInfo.InsuTypeId
	..q:(admRea="")&&(insutype'="")
	..q:(insutype'="")&&('$d(insuData(admRea)))
    ..//判断审核员是否为所选审核员
	..s shyr=admInfo.Shy
	..q:(shy'="")&&(shyr="")
	..q:(shy'="")&&(shyr'="")&&('$d(shyData(shyr)))
	..//判断单病种分类是否为所选单病种分类
	..s diafl=admInfo.InsudiaId
	..q:(diafl="")&&(insudiafl'="")
	..q:(insudiafl'="")&&('$d(diaflData(diafl)))
	..//判断单病种是否为所选单病种
	..s diadesc=admInfo.InsudiaId
	..q:(diadesc="")&&(insudiadesc'="")
	..q:(insudiadesc'="")&&('$d(diadescData(diadesc)))
	..//判断登记号是否为所选登记号
	..s djNo=admInfo.PatNo
	..q:(djh'="")&&(djNo="") 
	..q:(djh'="")&&('$d(djhData(djNo))) 
	..d admInfo.SetPBFeeInfo()
	..s PBFee=admInfo.PBFee
	..i Flag="strike" d 
    ...s PBFee=PBFee *(-1)
	..s catId=0
	..f  s catId=$o(^DHCTarC("TIC",catId)) q:catId=""  d
	...s catCode=$p(^DHCTarC("TIC",catId),"^",1)
	...s catDesc=$p(^DHCTarC("TIC",catId),"^",2)
	...s TotalFee=+$g(admInfo.TotalFee.Data(catId))
    ...s InsuFee=+$g(admInfo.InsuFee.Data(catId))
    ...s PatFee=+$g(admInfo.PatFee.Data(catId))
	...i Flag="strike" d 
    ....s TotalFee=TotalFee *(-1)
    ....s InsuFee=InsuFee *(-1)
    ....s PatFee=PatFee *(-1)
	...d OutputRow5
	..s admInfo=""
	    
  	q $$$OK
OutputRow5
	s Data=$lb(pbIdSC,admInfo.AdmId,admInfo.MedNo,admInfo.PatNo,admInfo.Name,admInfo.Age,admInfo.AdmDATE,admInfo.DisDate,admInfo.Dept,admInfo.Ward,admInfo.InsuType,admInfo.Doctor,PBFee,TotalFeeYb,InsuFeeYb,TotalFee,InsuFee,PatFee,catCode,catDesc,admInfo.DiagCj,admInfo.InsudiaFl,admInfo.Insudiadesc,admInfo.Shy,admInfo.OutDiagDesc,admInfo.InsuStatus)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData5(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	
	q
SplietDoubleDetmData5(multiStr,detm=",^",multiData)
	n (multiStr,detm,multiData)
	k multiData
	s detmData(1)=$e(detm,1)
	s detmData(2)=$e(detm,2)
	
	s multiLen=$l(multiStr,detmData(1))
	f len=1:1:multiLen d
	.s data1=$p(multiStr,detmData(1),len)
	.s multiLen2=$l(data1,detmData(2))
	.f len2=1:1:multiLen2 d
	..s data2=$p(data1,detmData(2),len2)
	..q:data2=""
	..s multiData(data2)=""
	
	q
}

ClassMethod GetDisPatInsuMx1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisPatInsuMx1Execute ]
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

ClassMethod GetDisPatInsuMx1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisPatInsuMx1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDisPatInsuMx1(startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Query(ROWSPEC = "pbIdSC:%String,AdmId:%String,MedNo:%String,PatNo:%String,Name:%String,Age:%String,AdmDATE:%String,DisDate:%String,Dept:%String,Ward:%String,InsuType:%String,Doctor:%String,PBFee:%Float,TotalFeeYb:%Float,InsuFeeYb:%Float,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,catCode:%String,catDesc:%String,DiagCj:%Float,InsudiaFl:%String,Insudiadesc:%String,Shy:%String,OutDiagDesc:%String,InsuStatus:%String") [ SqlProc ]
{
}

//7日重复住院患者就诊信息【依据上传时间为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetPapmiMX","2013-09-23","2013-09-23","","","")	

ClassMethod GetPapmiMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String = "", ward As %String = "", insutype As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dept,ward,insutype)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	
    d SplitMulitData7(dept,,.deptData)
	d SplitMulitData7(ward,,.wardData)
	d SplitMulitData7(insutype,,.insuData)
	
    s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
    for iDate=startDate:1:endDate d
	.s InsuDivDr=""
	.f  s InsuDivDr=$o(^DHCINDIV("0","IDate",iDate,InsuDivDr)) q:InsuDivDr=""  d
	..s Flag=$p($g(^DHCINDIV(InsuDivDr)),"^",5) 
	..q:Flag="divide"
	..s admId=$p($g(^DHCINDIV(InsuDivDr)),"^",1)
	..q:admId=""
	..s papmidr=$p($g(^PAADM(admId)),"^",1)
	..s paadmType=$p($g(^PAADM(admId)),"^",2) q:paadmType'="I"
	..s papmi=$p($g(^PAADM(admId)),"^",1)
	
    ..s pbId1=$p($g(^DHCINDIV(InsuDivDr)),"^",3) ;q:pbId1=""
    ..s pbIdSC=pbId1
	..s pbId=pbId1
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
    ..q:admInfo="null"
    ..q:admInfo=""
	..;;q:((insutype'="")&&('$d(insuData(admInfo.InsuType))))
	
    ..s mAdmTpe2=$$GetZyJSAdm^DHCWLBuildKPIData0005(admId)
    ..q:iDate>mAdmTpe2 ;曾经结算过的不算人次
    ..q:$$GetReadmission^DHCWLBuildKPIData0005(admId,"7")=0
    ..s PAADMRowid=0 f  s PAADMRowid=$o(^PAPERdr(papmidr,"ADM","I",PAADMRowid)) q:PAADMRowid=""  d
    ...q:PAADMRowid=""   
    ...s admtype=$p(^PAADM(PAADMRowid),"^",2) q:admtype'="I"
    ...s admdate=$p(^PAADM(PAADMRowid),"^",6)
    ...s disdate=$p(^PAADM(PAADMRowid),"^",17)
    ...s dep=$p(^PAADM(admId),"^",4)
	...i dep="" d
	....s dep="999999"
	....s deptsc="Null"
    ...e  d
	....s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dep="") 
	...q:(dept'="")&&('$d(deptData(dep)))
	...s wardep=$p(^PAADM(PAADMRowid),"^",70)
	...s admWard=$p($g(^PAWARD(+wardep)),"^",5)
	...s wardna=$$GetDepDesc^DHCWLCommon(admWard)
    ...//判断病区是否为所选病区
	...q:(ward'="")&&(admWard="")
	...q:(ward'="")&&('$d(wardData(admWard)))
    ...//判断费别是否为所选费别
	...s admRea=admInfo.InsuTypeId
	...q:(admRea="")&&(insutype'="")
	...q:(insutype'="")&&('$d(insuData(admRea)))
    ...d OutputRow7
 	q $$$OK	

OutputRow7
    s SfzH=$$GetPatId^DHCWLCommon(papmidr) ;身份证号
	s DJH=$$GetPapmiNo^DHCWLCommon(papmidr) ;登记号
	s PatNo=$$GetPapmiMedtare^DHCWLCommon(papmidr) 
	s Name=$$GetPapmiName^DHCWLCommon(papmidr) ;姓名
	s Sex=$$GetSex^DHCWLCommon(papmidr) ;性别
 	s Brithday=$p(^PAPER(papmidr,"ALL"),"^",6)  ;生日
	s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    s ryrq=$zd(admdate,3)
    i disdate'="" s cyrq=$zd(disdate,3)
    i disdate="" s cyrq=""
    s Data=$lb(DJH,PatNo,Name,Sex,Age,SfzH,papmidr,PAADMRowid,ryrq,cyrq,dep,deptsc,admWard,wardna,admInfo.InsuType)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData7(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q
}

ClassMethod GetPapmiMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPapmiMXExecute ]
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

ClassMethod GetPapmiMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPapmiMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPapmiMX(startDate As %String, endDate As %String, dept As %String, ward As %String, insutype As %String = "") As %Query(ROWSPEC = "DJH:%String,PatNo:%String,Name:%String,Sex:%String,Age:%String,SfzH:%String,papmidr:%String,PAADMRowid:%String,ryrq:%String,cyrq:%String,dep:%String,deptsc:%String,admWard:%String,wardna:%String,insutype:%String") [ SqlProc ]
{
}

//7日重复住院患者就诊信息【依据发票时间为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetPapmiMX1","2013-09-23","2013-09-23","","")	

ClassMethod GetPapmiMX1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String, ward As %String, insutype As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,ward,insutype)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
    d SplitMulitData8(dept,,.deptData)
	d SplitMulitData8(ward,,.wardData)
	d SplitMulitData8(insutype,,.insuData)
	
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s prtId=0 f  s prtId=$o(^DHCINVPRTZY(0,"DATE",date,prtId)) q:prtId=""  d
	..s flag=$p(^DHCINVPRTZY(prtId),"^",8) q:((flag="A") ! (flag="I")) 
	..s adm=$p(^DHCINVPRTZY(prtId),"^",4) 
	..q:'$d(^DHCINDIV(0,"Paadm",adm))
	..s pbId=$p(^DHCINVPRTZY(prtId),"^",5)
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
    ..q:admInfo="null"
    ..q:admInfo=""
    ..s code=admInfo.NationCode  
	..q:code=""
    ..s admId=admInfo.AdmId 
    ..s papmidr=$p($g(^PAADM(admId)),"^",1)
    ..s mAdmTpe2=$$GetZyJSAdm^DHCWLBuildKPIData0005(admId)
    ..q:date>mAdmTpe2 ;曾经结算过的不算人次
    ..q:$$GetReadmission^DHCWLBuildKPIData0005(admId,"7")=0
	..s PAADMRowid=0 f  s PAADMRowid=$o(^PAPERdr(papmidr,"ADM","I",PAADMRowid)) q:PAADMRowid=""  d
    ...q:PAADMRowid=""   
    ...s admtype=$p(^PAADM(PAADMRowid),"^",2) q:admtype'="I"
    ...s admdate=$p(^PAADM(PAADMRowid),"^",6)
    ...s disdate=$p(^PAADM(PAADMRowid),"^",17)
    ...s dep=$p(^PAADM(admId),"^",4)
	...i dep="" d
	....s dep="999999"
	....s deptsc="Null"
    ...e  d
	....s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dep="") 
	...q:(dept'="")&&('$d(deptData(dep)))
	...s wardep=$p(^PAADM(PAADMRowid),"^",70)
	...s admWard=$p($g(^PAWARD(+wardep)),"^",5)
	...s wardna=$$GetDepDesc^DHCWLCommon(admWard)
    ...//判断病区是否为所选病区
	...q:(ward'="")&&(admWard="")
	...q:(ward'="")&&('$d(wardData(admWard)))
	...//判断费别是否为所选费别
	...s admRea=admInfo.InsuTypeId
	...q:(admRea="")&&(insutype'="")
	...q:(insutype'="")&&('$d(insuData(admRea)))
    ...d OutputRow8
 	q $$$OK	

OutputRow8
    s SfzH=$$GetPatId^DHCWLCommon(papmidr) ;身份证号
	s DJH=$$GetPapmiNo^DHCWLCommon(papmidr) ;登记号
	s PatNo=$$GetPapmiMedtare^DHCWLCommon(papmidr) 
	s Name=$$GetPapmiName^DHCWLCommon(papmidr) ;姓名
	s Sex=$$GetSex^DHCWLCommon(papmidr) ;性别
 	s Brithday=$p(^PAPER(papmidr,"ALL"),"^",6)  ;生日
	s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    s ryrq=$zd(admdate,3)
    i disdate'="" s cyrq=$zd(disdate,3)
    i disdate="" s cyrq=""
    s Data=$lb(DJH,PatNo,Name,Sex,Age,SfzH,papmidr,PAADMRowid,ryrq,cyrq,dep,deptsc,admWard,wardna,admInfo.InsuType)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData8(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q
}

ClassMethod GetPapmiMX1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPapmiMX1Execute ]
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

ClassMethod GetPapmiMX1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPapmiMX1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPapmiMX1(startDate As %String, endDate As %String, dept As %String, ward As %String, insutype As %String) As %Query(ROWSPEC = "DJH:%String,PatNo:%String,Name:%String,Sex:%String,Age:%String,SfzH:%String,papmidr:%String,PAADMRowid:%String,ryrq:%String,cyrq:%String,dep:%String,deptsc:%String,admWard:%String,wardna:%String,insutype:%String") [ SqlProc ]
{
}

//【暂不用,未完成】出院医保患者费用明细报表【暂不用,作为改造备用。依据上传时间为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetDisPatInsuMx2","2013-8-30","2013-8-30","","","","","","","")

ClassMethod GetDisPatInsuMx2Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Status
{
	n (qHandle,startDate,endDate,hospid,dept,ward,insutype,shy,insudiafl,insudiadesc,djh)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	d SplitMulitData6(hospid,,.hospidData) 
	d SplitMulitData6(dept,,.deptData)
	d SplitMulitData6(ward,,.wardData)
	d SplitMulitData6(insutype,,.insuData)
	d SplitMulitData6(shy,,.shyData)
	d SplietDoubleDetmData6(insudiafl,,.diaflData)
	d SplitMulitData6(insudiadesc,,.diadescData)
	d SplitMulitData6(djh,,.djhData)
    
    s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
    for iDate=startDate:1:endDate d
    .s InsuDivDr1=""
	.f  s InsuDivDr1=$o(^DHCINDIV("0","IDate",iDate,InsuDivDr1)) q:InsuDivDr1=""  d
	..s office=1,Jslx=""
	..S (bcbxf0,grzfe0,jjzfe0,zhzfe0,Xyf,Zyf,Cyf)=0
	..s Flag=$p($g(^DHCINDIV(InsuDivDr1)),"^",5)
	..q:Flag="divide"
	..s adm=$p($g(^DHCINDIV(InsuDivDr1)),"^",1)
	..q:adm=""
	
    ..s dep=$p(^PAADM(adm),"^",4)
	..i dep="" d
	...s dep="999999"
	...s deptsc="Null"
	..e  d
	...s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	...s DeptId=dep ;科室ID
	...s Dept=deptsc ;科室
	..//判断科室是否为所选科室
	..q:(dept'="")&&(dep="") 
	..q:(dept'="")&&('$d(deptData(dep)))
	..//判断分院是否为所选医院
	..s hosp=$P($G(^CTLOC(dep)),"^",22)
	..i hosp=""  s hospcode=1
	..i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
	..q:(hospid'="")&&(hospcode="") 
	..q:(hospid'="")&&('$d(hospidData(hospcode)))
	..//判断病区是否为所选病区
	..s wardep=$p(^PAADM(adm),"^",70)
	..s admWard=$p($g(^PAWARD(+wardep)),"^",5)
    ..i admWard="" s admWard="999999"
	..q:(ward'="")&&(admWard="")
	..q:(ward'="")&&('$d(wardData(admWard)))
	..//判断费别是否为所选费别
	..s admRea=$p(^PAADM(adm,1),"^",7)
	..q:(admRea="")&&(insutype'="")
	..q:(insutype'="")&&('$d(insuData(admRea)))
	..//判断登记号是否为所选登记号
	..s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	..q:(djh'="")&&(PatNo="") 
	..q:(djh'="")&&('$d(djhData(PatNo)))
	
 	..s PrtDate1=$p($g(^DHCINDIV(InsuDivDr1)),"^",16)
	..s PrtTime1=$p($g(^DHCINDIV(InsuDivDr1)),"^",17)
	..s PrtDate1=$zd(PrtDate1,3)
	..s PrtTime1=$zt(PrtTime1,1)
	..s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	..s InsuAdmDr=$p($g(^DHCINDIV(InsuDivDr1)),"^",2)
	..i InsuAdmDr="" d
	...s yllb="",yllbDesc=""
	...s FundType="",FundTypeDesc=""
	..e     d
	...s yllb=$p($g(^DHCINADM(InsuAdmDr)),"^",4)    //医疗类别
	...s FundType=$p($g(^DHCINADM(InsuAdmDr)),"^",18) //险种类型
	...s outstr3=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	...s yllbDesc=$p(outstr3,"^",4)  //医疗人员类别名称
	...s outstr4=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	...s FundTypeDesc=$p(outstr4,"^",4)   //险种类型名称
 	..s bcbxf0=$p($g(^DHCINDIV(InsuDivDr)),"^",7)   //总费用
	..s jjzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",19)   //基金支付
	..s grzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",15)   //个人支付
	..s zhzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",28)   //账户支付
    ..s PBFee1=$$GetHISFee^DHCWLBuildKPIData0005(admId)
    ..i Flag="strike" s PBFee1=PBFee1*(-1),bcbxf0=bcbxf0*(-1),jjzfe0=jjzfe0*(-1),zhzfe0=zhzfe0*(-1)
    ..s PBFee=PBFee1  //出院医保患者HIS总金额
    ..s TotalFee=bcbxf0 //出院医保总金额
    ..s InsuFee=jjzfe0+zhzfe0  //出院医保支付总金额
    ..s PatFee=grzfe0   //个人额支付总额
    ..s WLRowid=0 f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",adm,WLRowid)) q:WLRowid=""  d
	...s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ...s itm=$p(^DHCWorkLoad(WLRowid),"^",22)    ;收费项目
    ...s catId=$p(^DHCTARI(itm),"^",14)  ;住院子分类
    ...s ^TEMPDHCWLKPIDATA("S",$j,dep,ward,adm,yllbDesc,FundTypeDesc,catId,Flag)=$g(^TEMPDHCWLKPIDATA("S",$j,dep,ward,adm,catId,Flag))+Fee
    
    s locid=0 f  s locid=$o(^TEMPDHCWLKPIDATA("S",$j,locid))  q:locid=""  d
    .s warid=0 f  s warid=$o(^TEMPDHCWLKPIDATA("S",$j,locid,warid))  q:warid=""  d
    ..s adm=0 f  s adm=$o(^TEMPDHCWLKPIDATA("S",$j,locid,warid,adm))  q:adm=""  d
    ...s cat=0 f  s cat=$o(^TEMPDHCWLKPIDATA("S",$j,locid,warid,adm,cat))  q:cat=""  d
    ....s nod=locid_","_warid_","_adm_","_cat ;_","_flg
    ....s flg=0 f  s flg=$o(^TEMPDHCWLKPIDATA("S",$j,locid,warid,adm,cat,flg))  q:flg=""  d
    .....s TotalFee=$g(^TEMPDHCWLKPIDATA("S",$j,locid,warid,adm,cat,flg))
    .....i flg="strike" s TotalFee=TotalFee*(-1)
    .....s data(nod,"FlTotal")=$g(data(nod,"FlTotal"))+TotalFee //出院医保HIS分类费用金额




	..s catId=0
	..f  s catId=$o(^DHCTarC("TIC",catId)) q:catId=""  d
	...s catCode=$p(^DHCTarC("TIC",catId),"^",1)
	...s catDesc=$p(^DHCTarC("TIC",catId),"^",2)

	...d OutputRow6

	    
  	q $$$OK
OutputRow6
    s AdmId=adm
	..s paadmType=$p($g(^PAADM(adm)),"^",2) q:paadmType="I"
    ..s papmi=$p($g(^PAADM(adm)),"^",1)
    ..s SfzH=$$GetPatId^DHCWLCommon(papmi) ;身份证号
	..s PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	..s Name=$$GetPapmiName^DHCWLCommon(papmi) ;姓名
	..s Sex=$$GetSex^DHCWLCommon(papmi) ;性别
 	..s Brithday=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	..s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)



  
	s Data=$lb(pbIdSC,admInfo.AdmId,admInfo.MedNo,admInfo.PatNo,admInfo.Name,admInfo.Age,admInfo.AdmDATE,admInfo.DisDate,admInfo.Dept,admInfo.Ward,admInfo.InsuType,admInfo.Doctor,PBFee,TotalFeeYb,InsuFeeYb,TotalFee,InsuFee,PatFee,catCode,catDesc,admInfo.DiagCj,admInfo.InsudiaFl,admInfo.Insudiadesc,admInfo.Shy,admInfo.OutDiagDesc,admInfo.InsuStatus)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData6(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	
	q
SplietDoubleDetmData6(multiStr,detm=",^",multiData)
	n (multiStr,detm,multiData)
	k multiData
	s detmData(1)=$e(detm,1)
	s detmData(2)=$e(detm,2)
	
	s multiLen=$l(multiStr,detmData(1))
	f len=1:1:multiLen d
	.s data1=$p(multiStr,detmData(1),len)
	.s multiLen2=$l(data1,detmData(2))
	.f len2=1:1:multiLen2 d
	..s data2=$p(data1,detmData(2),len2)
	..q:data2=""
	..s multiData(data2)=""
	
	q
}

ClassMethod GetDisPatInsuMx2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisPatInsuMx2Execute ]
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

ClassMethod GetDisPatInsuMx2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisPatInsuMx2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDisPatInsuMx2(startDate As %String, endDate As %String, hospid As %String, dept As %Text, ward As %Text, insutype As %Text, shy As %Text, insudiafl As %Text, insudiadesc As %Text, djh As %String) As %Query(ROWSPEC = "pbIdSC:%String,AdmId:%String,MedNo:%String,PatNo:%String,Name:%String,Age:%String,AdmDATE:%String,DisDate:%String,Dept:%String,Ward:%String,InsuType:%String,Doctor:%String,PBFee:%Float,TotalFeeYb:%Float,InsuFeeYb:%Float,TotalFee:%Float,InsuFee:%Float,PatFee:%Float,catCode:%String,catDesc:%String,DiagCj:%Float,InsudiaFl:%String,Insudiadesc:%String,Shy:%String,OutDiagDesc:%String,InsuStatus:%String") [ SqlProc ]
{
}

/// Creator:楼丽娜 2011-02-23  【暂不用作为备用参考-卢晓春】
/// Description:按时间段输出门诊或住院医保信息:结算日期,科室代码,科室名称,医保类型,自付金额,报销金额--用于成本核算组
/// Input:startdate,enddate,type(0门诊1住院),admreason(多个时用!分割),expstr(备用参数)
/// Output:进程号|Num
/// w ##class(web.RunQianQueryDHCWL3).OutPutInsurance("2013-08-09","2013-08-09",0,"","")
ClassMethod OutPutInsurance(sdate As %String, edate As %String, type As %String, admreason As %String, expstr As %String) As %String
{
	n (sdate,edate,type,admreason,expstr)
	s Num=0
	s ybstr="1!2!3!6!7!8!9!10!12!13!14!15!102!103!104!105!119!120!121!122!123!124!125!128!129!130!131!132!133!134!135!136!137!138!139!140!141!142!143!144!145!146!147!148!149!150!151!152!153!154!155!156!157!158!159!160!161!162!163!164!165!166"
	s admreason=ybstr
	q:(sdate="")||(edate="") $j_"|"_Num
	q:type="" $j_"|"_Num
	q:admreason="" $j_"|"_Num
	s sdate=$zdh(sdate,3)
	s edate=$zdh(edate,3)
	f idate=sdate:1:edate  d
	.s INPAYRowid=""
	.f  s INPAYRowid=$o(^DHCINDIV("0","iDate",idate,INPAYRowid)) q:INPAYRowid=""  d
	..s mCorrDiv=$g(^DHCINDIV(INPAYRowid))
	..s LocCode="",LocDesc="",feetype="",grzf="",insupay=""
	..s BillDr=$p(mCorrDiv,"^",3)
	..s InvPrtDr=$p(mCorrDiv,"^",4)
	..q:(type=0)&&(InvPrtDr="") ;门诊
	..q:(type=1)&&(BillDr="")   ;住院
	..q:$g(^DHCINVPRT(InvPrtDr))=""
	..q:$g(^DHCPB(BillDr))=""
	..s Flag=$p(mCorrDiv,"^",5)
	..q:Flag="divide"
	..s x=1
	..s:(type=1)&&(Flag="strike") x=-1 ;如果是住院退费数据,需要补上负号
	..s AdmDr=$p(mCorrDiv,"^",1)
	..i type=0 d ;费别,门诊取发票表费别,住院取挂号费别
	...s feetype=$p($g(^DHCINVPRT(InvPrtDr)),"^",9)
	..i type=1 d
	...s feetype=$p($g(^PAADM(AdmDr)),"^",56)
	..q:admreason'[feetype ;不在所查询的费别当中
	..s grzf=$p(mCorrDiv,"^",15)
	..s insupay=$p(mCorrDiv,"^",19)+$p(mCorrDiv,"^",28) ;基金+账户
	..q:AdmDr=""
	..s Depdr=$p($g(^PAADM(AdmDr)),"^",4)
	..i Depdr'="" d
	...s LocCode=$p(^CTLOC(Depdr),"^",1)
	...s LocDesc=$p(^CTLOC(Depdr),"^",2)
	..s Num=Num+1
	..s ^TMPDHCALXY("dhc","ca","hisInsu",$j,Num)=$zd(idate,3)_"^"_LocCode_"^"_LocDesc_"^"_feetype_"^"_grzf_"^"_insupay
	i type=0 d ;北京如果查询门诊,需到insu_adminfo表中循环挂号数据
	.f idate=sdate:1:edate  d
	.s INADMRowid=""
	.f  s INADMRowid=$o(^DHCINADM("0","FunDate",idate,INADMRowid)) q:INADMRowid=""  d
	..s mCorrAdm=$g(^DHCINADM(INADMRowid))
	..s LocCode="",LocDesc="",feetype="",grzf="",insupay=""
	..s ActiveFlag=$p(mCorrAdm,"^",11)
	..q:ActiveFlag="Card"
	..s AdmDr=$p(mCorrAdm,"^",1)
	..q:AdmDr=""
	..s feetype=$p($g(^PAADM(AdmDr)),"^",56)
	..q:admreason'[feetype ;不在所查询的费别当中
	..s grzf=$p(mCorrAdm,"^",27)
	..s insupay=$p(mCorrAdm,"^",28)+$p(mCorrAdm,"^",29) ;基金+账户
	..s Depdr=$p($g(^PAADM(AdmDr)),"^",4)
	..i Depdr'="" d
	...s LocCode=$p(^CTLOC(Depdr),"^",1)
	...s LocDesc=$p(^CTLOC(Depdr),"^",2)
	..s Num=Num+1
	..s ^TMPDHCALXY("dhc","ca","hisInsu",$j,Num)=$zd(idate,3)_"^"_LocCode_"^"_LocDesc_"^"_feetype_"^"_grzf_"^"_insupay
	q $j_"|"_Num
}

//门诊特病  【医保查询。作为参考用-卢晓春】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","QueryInsuDivBJTB","2013-08-8","2013-08-8","门诊特病")

ClassMethod QueryInsuDivBJTBExecute(ByRef qHandle As %Binary, StrDate As %String, EndDate As %String, SeekFlag As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ConId="",InsuId="",InsuCode="",InsuDesc="",ConQty="",InsuGG=""
	s InsuDW="",InsuSeltPer="",InsuCate="",InsuClass="",conActDate="",InsuType=""
	s ind=1	
	Set qHandle=$lb(0,repid,0)                      ///句柄
	
	
	Quit:$g(StrDate)="" $$$OK
	Quit:$g(EndDate)="" $$$OK
	Quit:$g(SeekFlag)="" $$$OK
	;Quit:'$d(^DHCINTCT("0","DHCTID",TarId)) $$$OK	///组建返回值用$$$OK
	
	s i=0
	s:StrDate["-" StrDate=$zdh(StrDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	for iDate=StrDate:1:EndDate d
	.s INPAYRowid="",Str="",i=0
	.f  s INPAYRowid=$o(^DHCINDIV("0","IDate",iDate,INPAYRowid)) q:INPAYRowid=""  d
	..s Name="",Sex="",PatID=""
	..s mCorrDiv=$g(^DHCINDIV(INPAYRowid))
	..s Flag=$p(mCorrDiv,"^",5)
	..q:Flag="divide"
	..s tbbz=$p(mCorrDiv,"^",25)
	..s djlsh=$p(mCorrDiv,"^",8)
	..q:(SeekFlag="门诊特病")&&(tbbz'="Y")
	..q:(SeekFlag="急诊留观")&&((tbbz="Y")||(djlsh'=""))
	..s PrtInuFlag="N"
	..i Flag="strike" d
	...s INSUDivideDr=$p(mCorrDiv,"^",6)    ; add liusf 2012 11 14
	..e   d
	...s INSUDivideDr=INPAYRowid
	..s PrtInvDr=""
	..W INPAYRowid_";"
	..f  s PrtInvDr=$o(^DHCINVPRT(0,"INSDIV",INSUDivideDr,PrtInvDr)) q:PrtInvDr=""  d
	...s FairType=$p($g(^DHCINVPRT(PrtInvDr)),"^",34)
	...s:FairType="F" PrtInuFlag="Y"
	..q:PrtInuFlag="N"
	..s InsuAdmDr=$p(mCorrDiv,"^",2)
	..s AdmDr=$p(mCorrDiv,"^",1) Q:AdmDr'=2998287
	..s AdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(AdmDr)
	..s DepDesc=$p(AdmInfo,"^",5)        ;就诊科室  add liusf 2012 11 14
	..i InsuAdmDr'="" d
	...s InsuType=$p($g(^DHCINADM(InsuAdmDr)),"^",18)     ;险种类型
	...s PatType=$p($g(^DHCINADM(InsuAdmDr)),"^",4)       ;参保人员类别
	..e   d
	...s InsuType=""
	...s PatType=""
	..s PatInfo=##class(web.DHCINSUPatInfo).GetPatInfoByAdm(AdmDr)
	..i $p(PatInfo,"!",1)="1" d
	...s HisBusinessNo=$p(PatInfo,"^",2)                   ;收费流水号
	...s Name=$p(PatInfo,"^",3)                   ;姓名
	...s Sex=$p(PatInfo,"^",5)                    ;性别
	...s PatID=$p(PatInfo,"^",9)                    ;身份证号
	..s FunDate=$zd($p(mCorrDiv,"^",16),3)       
	..s FunTime=$zt($p(mCorrDiv,"^",17))    
	..s sfrq=$tr(FunDate,"-","")_$tr(FunTime,":","")                 ;交易日期时间
	
	..s mzfee=$p(mCorrDiv,"^",31)       ;费用总金额
	..s fund=$p(mCorrDiv,"^",19)        ;基金支付金额
	..s cash=$p(mCorrDiv,"^",15)        ;现金支付金额
	..s zhzf=$p(mCorrDiv,"^",28)        ;个人账户支付金额
	..s mzfeein=$p(mCorrDiv,"^",32)     ;医保内总金额
	..s mzfeeout=$p(mCorrDiv,"^",33)    ;医保外总金额
	..s mzpayfirst=$p(mCorrDiv,"^",34)  ;统筹支付金额
	..s mzselfpay2=$p(mCorrDiv,"^",35)  ;统筹自付金额
	..s mzbigpay=$p(mCorrDiv,"^",36)    ;大额/公务员支付金额
	..s mzbigselfpay=$p(mCorrDiv,"^",37) ;大额/公务员自付金额
	..s mzoutofbig=$p(mCorrDiv,"^",38)  ;个人应付总金额
	..s bcpay=$p(mCorrDiv,"^",39)       ;个人自付二金额
	..s jcbz=$p(mCorrDiv,"^",40)        ;本次交易统筹封顶后医保内金额
	..s Zstr08=$p(mCorrDiv,"^",43)      ;病种差额   add liusf 2012 11 14
	
	..i Flag="strike" d
	...s mzfee=mzfee*(-1)
	...s fund=fund*(-1)
	...s cash=cash*(-1)
	...s zhzf=zhzf*(-1)
	...s mzfeein=mzfeein*(-1)
	...s mzfeeout=mzfeeout*(-1)
	...s mzpayfirst=mzpayfirst*(-1)
	...s mzselfpay2=mzselfpay2*(-1)
	...s mzbigpay=mzbigpay*(-1)
	...s mzbigselfpay=mzbigselfpay*(-1)
	...s mzoutofbig=mzoutofbig*(-1)
	...s bcpay=bcpay*(-1)
	...s jcbz=jcbz*(-1)
	...s Zstr08=Zstr08*(-1)
	
	..s:Flag="insu" Flag="0"             ;退费标志
	..s:Flag="bestrike" Flag="1"
	..s:Flag="strike" Flag="-1"
	..s i=i+1
	..;b ;121
	..d BuildList1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildList1      
	set Data=$lb(i,HisBusinessNo,InsuType,Name,Sex,sfrq,PatID,mzfee,fund,zhzf,cash,mzfeein,mzfeeout,mzpayfirst,mzselfpay2,mzbigpay,mzbigselfpay,mzoutofbig,bcpay,jcbz,Flag,Zstr08,DepDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryInsuDivBJTBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuDivBJTBExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryInsuDivBJTB(StrDate As %String, EndDate As %String, SeekFlag As %String) As %Query(ROWSPEC = "i:%String,HisBusinessNo:%String,InsuType:%String,Name:%String,Sex:%String,sfrq:%String,PatID:%String,mzfee:%String,fund:%String,zhzf:%String,cash:%String,mzfeein:%String,mzfeeout:%String,mzpayfirst:%String,mzselfpay2:%String,mzbigpay:%String,mzbigselfpay:%String,mzoutofbig:%String,bcpay:%String,jcbz:%String,Flag:%String,Zstr08:%String,DepDesc:%String") [ SqlProc ]
{
}

//【医保查询。作为参考用-卢晓春】

//D ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","QueryInsuDivBJ","2013-8-8","2013-8-8")

ClassMethod QueryInsuDivBJExecute(ByRef qHandle As %Binary, StrDate As %String, EndDate As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ConId="",InsuId="",InsuCode="",InsuDesc="",ConQty="",InsuGG=""
	s InsuDW="",InsuSeltPer="",InsuCate="",InsuClass="",conActDate="",InsuType=""
	s ind=1	
	Set qHandle=$lb(0,repid,0)                      ///句柄
	
	;Quit:$g(TarId)="" $$$OK
	;Quit:'$d(^DHCINTCT("0","DHCTID",TarId)) $$$OK	///组建返回值用$$$OK
	
	s i=0
	s:StrDate["-" StrDate=$zdh(StrDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	for iDate=StrDate:1:EndDate d
	.s INPAYRowid="",Str="",i=0
	.f  s INPAYRowid=$o(^DHCINDIV("0","IDate",iDate,INPAYRowid)) q:INPAYRowid=""  d
	..s Name="",Sex="",Age="",Birthday="",PrtInv=""
	..s mCorrDiv=$g(^DHCINDIV(INPAYRowid))
	..s Flag=$p(mCorrDiv,"^",5)
	..q:Flag="divide"
	..s InvPrtDr=$p(mCorrDiv,"^",4)
	..;q:InvPrtDr=""                    ;发票rowid为空的不是普通门诊实时结算，退出
	..s tbbz=$p(mCorrDiv,"^",25)
	..q:tbbz="Y"
	..s AdmDr=$p(mCorrDiv,"^",1)
	..s HisBusinessNo=$p(mCorrDiv,"^",4)                     ;His交易流水号
	..s djlsh0=$p(mCorrDiv,"^",8)                 ;医保交易流水号 
	..q:djlsh0=""                           ;2012 11 14 liusf
	..s InsuAdmDr=$p(mCorrDiv,"^",2)
	..s AdmDr=$p(mCorrDiv,"^",1)
	..s Type=$p($g(^PAADM(AdmDr)),"^",2)
	..q:(Type'="O")&&(Type'="E")      
	..s:Type="O" AdmType="11"                  ;医疗类别
	..s:Type="E" AdmType="19"
	..i InsuAdmDr'="" d
	...s InsuType=$p($g(^DHCINADM(InsuAdmDr)),"^",18)     ;险种类型
	...s PatType=$p($g(^DHCINADM(InsuAdmDr)),"^",4)       ;参保人员类别
	..e   d
	...;b ;444
	...s InsuType=""
	...s PatType=""
	..s PatInfo=##class(web.DHCINSUPatInfo).GetPatInfoByAdm(AdmDr)
	..i $p(PatInfo,"!",1)="1" d
	...s Name=$p(PatInfo,"^",3)                   ;姓名
	...s Sex=$p(PatInfo,"^",5)                    ;性别
	...s Age=$p(PatInfo,"^",4)                    ;年龄
	...s Birthday=$p(PatInfo,"^",10)              ;出生日期
	..;i InvPrtDr'="" d
	..s PrtInv=$p(mCorrDiv,"^",10)    ;收据号
	..s sfrq=$p(mCorrDiv,"^",22)                  ;交易日期时间
	..i $p(mCorrDiv,"^",45)="" d
	...s CatFee="0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"
	..e  d
	...s CatFee=$p(mCorrDiv,"^",45) 
	
	..s mzfee=$p(mCorrDiv,"^",31)       ;费用总金额
	..s fund=$p(mCorrDiv,"^",19)        ;基金支付金额
	..s cash=$p(mCorrDiv,"^",15)        ;现金支付金额
	..s zhzf=$p(mCorrDiv,"^",28)        ;个人账户支付金额
	..s zhye=$p(mCorrDiv,"^",42)        ;个人帐户余额
	..s mzfeein=$p(mCorrDiv,"^",32)     ;医保内总金额
	..s mzfeeout=$p(mCorrDiv,"^",33)    ;医保外总金额
	..s mzpayfirst=$p(mCorrDiv,"^",34)  ;本次付起付线金额
	..s mzselfpay2=$p(mCorrDiv,"^",35)  ;个人自付2
	..s mzbigpay=$p(mCorrDiv,"^",36)    ;门诊大额支付金额
	..s mzbigselfpay=$p(mCorrDiv,"^",37) ;门诊大额自付金额
	..s mzoutofbig=$p(mCorrDiv,"^",38)  ;超大额自付金额
	..s bcpay=$p(mCorrDiv,"^",39)       ;补充保险支付金额
	..s jcbz=$p(mCorrDiv,"^",40)        ;军残补助保险金额
	
	..s xy=$p(CatFee,"|",1)             ;西药
	..s zy=$p(CatFee,"|",2)             ;中成药
	..s cy=$p(CatFee,"|",3)             ;中草药
	..s hy=$p(CatFee,"|",4)             ;化验
	..s fs=$p(CatFee,"|",5)             ;放射
	..s bc=$p(CatFee,"|",6)             ;B超
	..s ct=$p(CatFee,"|",7)             ;CT
	..s hc=$p(CatFee,"|",8)             ;核磁
	..s jcf=$p(CatFee,"|",9)             ;检查费
	..s zlf=$p(CatFee,"|",10)             ;治疗费
	..s clf=$p(CatFee,"|",11)             ;材料费
	..s ssf=$p(CatFee,"|",12)             ;手术费
	..s syf=$p(CatFee,"|",13)             ;输氧费
	..s sxf=$p(CatFee,"|",14)             ;输血费
	..s zjf=$p(CatFee,"|",15)             ;正畸费
	..s xyf=$p(CatFee,"|",16)             ;镶牙费
	..s sfjd=$p(CatFee,"|",17)             ;司法鉴定
	..s qt=$p(CatFee,"|",18)             ;其他
	
	..s:Flag="insu" Flag="0"             ;退费标志
	..s:Flag="bestrike" Flag="1"
	..s:Flag="strike" Flag="-1"
	..s i=i+1
	..d BuildList
	
	for iDate=StrDate:1:EndDate d
	.s InsuAdmDr="",Str=""
	.f  s InsuAdmDr=$o(^DHCINADM("0","FunDate",iDate,InsuAdmDr)) q:InsuAdmDr=""  d
	..s Name="",Sex="",Age="",Birthday=""
	..s mCorrDiv=$g(^DHCINADM(InsuAdmDr))
	..s Flag=$p(mCorrDiv,"^",11)
	..q:(Flag="D")||(Flag="Card")
	..s AdmCancleNo=$p(mCorrDiv,"^",19)
	..s AdmDr=$p(mCorrDiv,"^",1)
	..s HisBusinessNo=""                          ;His交易流水号
	..s djlsh0=$p(mCorrDiv,"^",10)                 ;医保交易流水号 
	..s AdmDr=$p(mCorrDiv,"^",1)
	..i AdmDr'="" d
	...s Type=$p($g(^PAADM(AdmDr)),"^",2)    
	...s:Type="O" AdmType="17"                  ;医疗类别
	...s:Type="E" AdmType="18"
	..e   d
	...s Name=$p(mCorrDiv,"^",6)
	...s Type="O"
	...s AdmType="17"
	..q:(Type'="O")&&(Type'="E")
	..s InsuType=$p(mCorrDiv,"^",18)     ;险种类型
	..s PatType=$p(mCorrDiv,"^",4)       ;参保人员类别
	..s PatInfo=##class(web.DHCINSUPatInfo).GetPatInfoByAdm(AdmDr)
	..i $p(PatInfo,"!",1)="1" d
	...s Name=$p(PatInfo,"^",3)                   ;姓名
	...s Sex=$p(PatInfo,"^",5)                    ;性别
	...s Age=$p(PatInfo,"^",4)                    ;年龄
	...s Birthday=$p(PatInfo,"^",10)              ;出生日期
	..;s HisBusinessNo=$o(^DHCINVPRT("0","INSDIV",InsuAdmDr,HisBusinessNo))
	..;i HisBusinessNo="" d
	..;.s PrtInv=""
	..;e  d
	..;.s PrtInv=$p(^DHCINVPRT(HisBusinessNo),"^",14)    ;收据号
	..s PrtInv=""
	..s FunDate=$zd($p(mCorrDiv,"^",24),3)       
	..s FunTime=$zt($p(mCorrDiv,"^",25))    
	..s sfrq=$tr(FunDate,"-","")_$tr(FunTime,":","")                 ;交易日期时间
	..s CatFee="0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"
	
	..s mzfee=$p(mCorrDiv,"^",30)       ;费用总金额
	..s fund=$p(mCorrDiv,"^",28)        ;基金支付金额
	..s cash=$p(mCorrDiv,"^",27)        ;现金支付金额
	..s zhzf=$p(mCorrDiv,"^",29)        ;个人账户支付金额
	..s xstring12=$p(mCorrDiv,"^",41)
	..s zhye=$p(mCorrDiv,"^",9)        ;个人帐户余额
	..s mzfeein=$p(mCorrDiv,"^",31)     ;医保内总金额
	..s mzfeeout=$p(mCorrDiv,"^",32)    ;医保外总金额
	..s mzpayfirst=$p(mCorrDiv,"^",33)  ;本次付起付线金额
	..s mzselfpay2=$p(mCorrDiv,"^",34)  ;个人自付2
	..s mzbigpay=$p(mCorrDiv,"^",35)    ;门诊大额支付金额
	..s mzbigselfpay=$p(mCorrDiv,"^",36) ;门诊大额自付金额
	..s mzoutofbig=$p(mCorrDiv,"^",37)  ;超大额自付金额
	..s bcpay=$p(mCorrDiv,"^",38)       ;补充保险支付金额
	..s jcbz=$p(mCorrDiv,"^",39)        ;军残补助保险金额
	
	..s xy=$p(CatFee,"|",1)             ;西药
	..s zy=$p(CatFee,"|",2)             ;中成药
	..s cy=$p(CatFee,"|",3)             ;中草药
	..s hy=$p(CatFee,"|",4)             ;化验
	..s fs=$p(CatFee,"|",5)             ;放射
	..s bc=$p(CatFee,"|",6)             ;B超
	..s ct=$p(CatFee,"|",7)             ;CT
	..s hc=$p(CatFee,"|",8)             ;核磁
	..s jcf=$p(CatFee,"|",9)             ;检查费
	..s zlf=$p(CatFee,"|",10)             ;治疗费
	..s clf=$p(CatFee,"|",11)             ;材料费
	..s ssf=$p(CatFee,"|",12)             ;手术费
	..s syf=$p(CatFee,"|",13)             ;输氧费
	..s sxf=$p(CatFee,"|",14)             ;输血费
	..s zjf=$p(CatFee,"|",15)             ;正畸费
	..s xyf=$p(CatFee,"|",16)             ;镶牙费
	..s sfjd=$p(CatFee,"|",17)             ;司法鉴定
	..s qt=$p(CatFee,"|",18)             ;其他
	
	..s:Flag="A" Flag="0" ;退费标志
	..s:(Flag="I")&&(AdmCancleNo'="") Flag="-1"      
	..s:(Flag="I")&&(AdmCancleNo="") Flag="1"
	..s i=i+1
	..d BuildList
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildList      
	set Data=$lb(i,HisBusinessNo,djlsh0,AdmType,InsuType,PatType,Name,Sex,Age,Birthday,PrtInv,sfrq,mzfee,fund,cash,zhzf,zhye,mzfeein,mzfeeout,mzpayfirst,mzselfpay2,mzbigpay,mzbigselfpay,mzoutofbig,bcpay,jcbz,xy,zy,cy,hy,fs,bc,ct,hc,jcf,zlf,clf,ssf,syf,sxf,zjf,xyf,sfjd,qt,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryInsuDivBJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuDivBJExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryInsuDivBJ(StrDate As %String, EndDate As %String) As %Query(ROWSPEC = "i:%String,HisBusinessNo:%String,djlsh0:%String,AdmType:%String,InsuType:%String,PatType:%String,Name:%String,Sex:%String,Age:%String,Birthday:%String,PrtInv:%String,sfrq:%String,mzfee:%String,fund:%String,cash:%String,zhzf:%String,zhye:%String,mzfeein:%String,mzfeeout:%String,mzpayfirst:%String,mzselfpay2:%String,mzbigpay:%String,mzbigselfpay:%String,mzoutofbig:%String,bcpay:%String,jcbz:%String,xy:%String,zy:%String,cy:%String,hy:%String,fs:%String,bc:%String,ct:%String,hc:%String,jcf:%String,zlf:%String,clf:%String,ssf:%String,syf:%String,sxf:%String,zjf:%String,xyf:%String,sfjd:%String,qt:%String,Flag:%String") [ SqlProc ]
{
}

ClassMethod QueryInsuDivBJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuDivBJExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryInsuDivBJTBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuDivBJTBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

//N日重复住院患者就诊信息【依据上传时间为入口统计】

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL3","GetPapmiMXN","2013-09-23","2013-09-23","","","")	

ClassMethod GetPapmiMXNExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String = "", ward As %String = "", insutype As %String = "", TimeLimite As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dept,ward,insutype,TimeLimite)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	
    d SplitMulitData71(dept,,.deptData)
	d SplitMulitData71(ward,,.wardData)
	d SplitMulitData71(insutype,,.insuData)
	
    s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
    for iDate=startDate:1:endDate d
	.s InsuDivDr=""
	.f  s InsuDivDr=$o(^DHCINDIV("0","IDate",iDate,InsuDivDr)) q:InsuDivDr=""  d
	..s Flag=$p($g(^DHCINDIV(InsuDivDr)),"^",5) 
	..q:Flag="divide"
	..s admId=$p($g(^DHCINDIV(InsuDivDr)),"^",1)
	..q:admId=""
	..s papmidr=$p($g(^PAADM(admId)),"^",1)
	..s paadmType=$p($g(^PAADM(admId)),"^",2) q:paadmType'="I"
	..s papmi=$p($g(^PAADM(admId)),"^",1)
	
    ..s pbId1=$p($g(^DHCINDIV(InsuDivDr)),"^",3) ;q:pbId1=""
    ..s pbIdSC=pbId1
	..s pbId=pbId1
	..s admInfo=##class(DHCWL.InsuStat.PBInfo).%New(pbId)
    ..q:admInfo="null"
    ..q:admInfo=""
	..;;q:((insutype'="")&&('$d(insuData(admInfo.InsuType))))
	
    ..s mAdmTpe2=$$GetZyJSAdm^DHCWLBuildKPIData0005(admId)
    ..q:iDate>mAdmTpe2 ;曾经结算过的不算人次
    ..q:$$GetReadmission^DHCWLBuildKPIData0005(admId,TimeLimite)=0
    ..w
    ..s PAADMRowid=0 f  s PAADMRowid=$o(^PAPERdr(papmidr,"ADM","I",PAADMRowid)) q:PAADMRowid=""  d
    ...q:PAADMRowid=""   
    ...s admtype=$p(^PAADM(PAADMRowid),"^",2) q:admtype'="I"
    ...s admdate=$p(^PAADM(PAADMRowid),"^",6)
    ...s disdate=$p(^PAADM(PAADMRowid),"^",17)
    ...s dep=$p(^PAADM(admId),"^",4)
	...i dep="" d
	....s dep="999999"
	....s deptsc="Null"
    ...e  d
	....s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dep="") 
	...q:(dept'="")&&('$d(deptData(dep)))
	...s wardep=$p(^PAADM(PAADMRowid),"^",70)
	...s admWard=$p($g(^PAWARD(+wardep)),"^",5)
	...s wardna=$$GetDepDesc^DHCWLCommon(admWard)
    ...//判断病区是否为所选病区
	...q:(ward'="")&&(admWard="")
	...q:(ward'="")&&('$d(wardData(admWard)))
    ...//判断费别是否为所选费别
	...s admRea=admInfo.InsuTypeId
	...q:(admRea="")&&(insutype'="")
	...q:(insutype'="")&&('$d(insuData(admRea)))
    ...d OutputRow71
 	q $$$OK	

OutputRow71
    s SfzH=$$GetPatId^DHCWLCommon(papmidr) ;身份证号
	s DJH=$$GetPapmiNo^DHCWLCommon(papmidr) ;登记号
	s PatNo=$$GetPapmiMedtare^DHCWLCommon(papmidr) 
	s Name=$$GetPapmiName^DHCWLCommon(papmidr) ;姓名
	s Sex=$$GetSex^DHCWLCommon(papmidr) ;性别
 	s Brithday=$p(^PAPER(papmidr,"ALL"),"^",6)  ;生日
	s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    s ryrq=$zd(admdate,3)
    i disdate'="" s cyrq=$zd(disdate,3)
    i disdate="" s cyrq=""
    s Data=$lb(DJH,PatNo,Name,Sex,Age,SfzH,papmidr,PAADMRowid,ryrq,cyrq,dep,deptsc,admWard,wardna,admInfo.InsuType)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData71(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q
}

ClassMethod GetPapmiMXNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPapmiMXExecute ]
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

ClassMethod GetPapmiMXNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPapmiMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPapmiMXN(startDate As %String, endDate As %String, dept As %String, ward As %String, insutype As %String = "", TimeLimite As %String = "") As %Query(ROWSPEC = "DJH:%String,PatNo:%String,Name:%String,Sex:%String,Age:%String,SfzH:%String,papmidr:%String,PAADMRowid:%String,ryrq:%String,cyrq:%String,dep:%String,deptsc:%String,admWard:%String,wardna:%String,insutype:%String") [ SqlProc ]
{
}

}
