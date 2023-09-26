Import sqluser

Class web.DHCADVSAFECOUNT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 获取报告表项目环节
/// Creator:     CongYue
/// CreateDate:  2015-12-31
/// Input:  	 报告表id  
/// Output:  	 此报告所选的项目环节信息   
/// Others:		 w ##class(web.DHCADVSAFECOUNT).getMedRepLink("18")
ClassMethod getMedRepLink(medsrID) As %String
{
	N (medsrID)
	S tmpStr=""
	S ID=""
	F  S ID=$o(^DHCADVMEDRLK(0,"RepDr",medsrID,ID)) Q:ID=""  D
	.S medsRepLinkDr=$p(^DHCADVMEDRLK(ID),"^",2) //项目环节（表DHC_MedReportLink）id
	.S medsrJob=$p(^DHCADVMEDRLK(ID),"^",3) //工作人（医生。。。）
	.S medsrCareProv=$p(^DHCADVMEDRLK(ID),"^",4) //职称
	.S medsrOtherDesc=$p(^DHCADVMEDRLK(ID),"^",5) //其他
	.S ListData=medsRepLinkDr_"^"_medsrJob_"^"_medsrCareProv_"^"_medsrOtherDesc
	.I tmpStr="" S tmpStr=ListData
	.E  S tmpStr=tmpStr_"&&"_ListData
	Q tmpStr
}

/// Description: 获取报告表结果
/// Creator:     CongYue
/// CreateDate:  2015-12-31
/// Input:  	 报告id  
/// Output:  	 此报告的报告结果   
/// Others:		 w ##class(web.DHCADVSAFECOUNT).getMedRepResult("18")
ClassMethod getMedRepResult(medsrID) As %String
{
	N (medsrID)

	S ID=""  ;^DHCADVMEDRRET(0,"RepDr",{MEDSR_RepDr},{MEDSR_RowID})
	F  S ID=$o(^DHCADVMEDRRET(0,"RepDr",medsrID,ID)) Q:ID=""  D
	.S ReslutDr=$p(^DHCADVMEDRRET(ID),"^",2) //结果
	S tmpStr=ReslutDr
	Q tmpStr
}

/// Description: k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{

	//K ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid)
	K ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedLinkDetail",pid)
}

/// Description: 计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCADV("DHCADVSAFECOUNT"))
}

/// Description: 导出用药环节明细
/// Creator:     yangyongtao
/// CreateDate:  2016-05-12
/// Input:  	 各环节的ID^数量
/// Output:  	 此报告中此项目环节所选的信息  
/// Others:		 w ##class(web.DHCADVSAFECOUNT).getMedLinkDetailCount("437^63^1^1-10")
ClassMethod getMedLinkDetailCount(params As %String) As %String
{
	n ( params)
	s pid=$p(params,"^",1)
	s InLocID=$p(params,"^",2) //科室Id
	s medULinkid=$p(params,"^",3) //环节ID
	S LinkItmCode=$p(params,"^",4) //Code
	//s total=$p(params,"^",4)   //总数
	
	S ListTitle="medULinkItmCode^medULinkItmDesc^medULinkItmNum"
	
	//w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(total) //输出json前缀串
	s LocID=""
	f  s LocID=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID)) Q:LocID=""  D
	.Q:(InLocID'="")&(InLocID'=LocID)
	.s index=""
	.S Data=""
	.f  s index=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,index)) q:index=""  d
	..s medULinkItmNum=$g(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,index))
	..s medULinkItmCode=$p(index,"^",1) //获取Code
	..Q:medULinkItmCode'=LinkItmCode
	..s medULinkItmDesc=$p(index,"^",2)   //获取描述
	..s ListData=medULinkItmCode_"^"_medULinkItmDesc_"^"_medULinkItmNum
   	..I Data'="" s Data=Data_"^"_ListData
   	..E  S Data=ListData
    Q Data
}

/// Description: 获取用药环节明细
/// Creator:     yangyongtao
/// CreateDate:  2016-04-20
/// Input:  	 各环节的ID^数量
/// Output:  	 此报告中此项目环节所选的信息  
/// Others:		 w ##class(web.DHCADVSAFECOUNT).getMedLinkDetail("12","1","1255^63^1")
ClassMethod getMedLinkDetail(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
    s Start = (page-1)*rows+1
    s count=0,h=0
	s pid=$p(params,"^",1)
	s InLocID=$p(params,"^",2) //科室Id
	s medULinkid=$p(params,"^",3) //环节ID
	s total=$p(params,"^",4)   //总数
	S ListTitle="medULinkItmCode^medULinkItmDesc^medULinkItmNum^pid^InLocID^medULinkid"
	
	
	//w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(total) //输出json前缀串
	
	s LocID=""
	f  s LocID=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID)) Q:LocID=""  D
	
	.Q:(InLocID'="")&(InLocID'=LocID)
	
	.s index=""
	.f  s index=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,index)) q:index=""  d
	..s medULinkItmNum=$g(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,index))
	..s medULinkItmCode=$p(index,"^",1) //获取Code
	..s medULinkItmDesc=$p(index,"^",2)  //获取描述
	..s ListData=medULinkItmCode_"^"_medULinkItmDesc_"^"_medULinkItmNum_"^"_pid_"^"_InLocID_"^"_medULinkid
	..S h=h+1
	..s ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedLinkDetail",pid,h)=ListData
	.
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedLinkDetail",pid,h))  q:h=""  d
	.s ListData=^TMP("DHCST","web.DHCADVSAFECOUNT","getMedLinkDetail",pid,h)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 查询用药差错信息
/// Creator:     yangyongtao
/// CreateDate:  2016-03-10
/// Input:  	 开始日期^结束日期
/// Output:  	 此报告中此项目环节所选的信息  
/// Others:		 w ##class(web.DHCADVSAFECOUNT).getMedQuery("12","1","01/01/2016^07/07/2016^")
ClassMethod getMedQuery(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
    s Start = (page-1)*rows+1
    s pid=..NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    
    s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	s medRLinkID=""
	s ListData="^^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0" 
	s medrSub=""
	s h=0,count=0
	f dd=StDate:1:EndDate d
	.s medsrID="0"
	.f  s medsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,medsrID)) q:medsrID=""  d  //获取报告ID
	..S medsrRepLocCode=$p(^DHCADVMEDSAR(medsrID),"^",1)   //科室
	..S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(medsrRepLocCode),""))
	..S medsrRepLocDesc=""
	..S:LocID'="" medsrRepLocDesc=$p(^CTLOC(LocID),"^",2)
    ..s medsrDoctorsNum=0,medsrApothecaryNum=0,medsrDispNum=0,medsrNurseNum=0,medsrPatDrNum=0 //医生，药师，配送，护士，患者的总数初始值
	..f  s medRLinkID=$o(^DHCADVMEDRLK(0,"RepDr",medsrID,medRLinkID))  q:medRLinkID=""  d  //获取环节ID
	
	...f  s medrSub=$o(^DHCADVMEDRLK(medRLinkID,"MEDSRI",medrSub))  q:medrSub=""  d   //获取环节子表的ID
	
	....s medULinkItmid=$p(^DHCADVMEDRLK(medRLinkID,"MEDSRI",medrSub),"^",1)
	....;S childSub="0"
	....I medULinkItmid["||" S childSub=$P(medULinkItmid,"||",2) //以"-"截取字符
	....s medULinkid=+medULinkItmid
	
	....I medULinkid="1" d
	
	.....s medsrDoctorsNum=medsrDoctorsNum+1 ,$p(ListData,"^",19)=$p(ListData,"^",19)+1 //医生
	.....//w LocID,!  ///b  ////ffff
	
	....I medULinkid="2" d
	.....s medsrApothecaryNum=medsrApothecaryNum+1,$p(ListData,"^",20)=$p(ListData,"^",20)+1 //药师
	
	....I medULinkid="3" d 
	.....s medsrDispNum=medsrDispNum+1 ,$p(ListData,"^",21)=$p(ListData,"^",21)+1 //配送
	
	....I medULinkid="4" d
	.....s medsrNurseNum=medsrNurseNum+1 ,$p(ListData,"^",22)=$p(ListData,"^",22)+1 //护士
	
	....I medULinkid="5" d
	.....s medsrPatDrNum=medsrPatDrNum+1 ,$p(ListData,"^",23)=$p(ListData,"^",23)+1 //患者
	
	....s medULinkItmCode=$p(^DHCADVMUSELK(medULinkid,"MULI",childSub),"^",1) //获取Code
	....s medULinkItmDesc=$p(^DHCADVMUSELK(medULinkid,"MULI",childSub),"^",2) //获取描述
	....s Num=$g(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,medULinkItmCode_"^"_medULinkItmDesc))
	....s ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,LocID,medULinkid,medULinkItmCode_"^"_medULinkItmDesc)=Num+1
	....s Num2=$g(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,"COUNT",medULinkid,medULinkItmCode_"^"_medULinkItmDesc))
    ....s ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQueryDetail",pid,"COUNT",medULinkid,medULinkItmCode_"^"_medULinkItmDesc)=Num2+1
	..s medsrOccDate=$p(^DHCADVMEDSAR(medsrID),"^",4)    //用药差错发生 日期
	..s week="" ,workDayNum=0,restDayNum=0
	..s week=$zd(medsrOccDate,10) 
	..i (week=6)||(week=0) s restDayNum=restDayNum+1,$p(ListData,"^",17)=$p(ListData,"^",17)+1 //节假日
	
	..e  s workDayNum=workDayNum+1,$p(ListData,"^",18)=$p(ListData,"^",18)+1 //工作日

	..s:medsrOccDate'="" medsrOccDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medsrOccDate) //$zd(medsrOccDate,3)
	..s medsrOccTime=$p(^DHCADVMEDSAR(medsrID),"^",5)    //用药差错发生 时间
	..s:medsrOccTime'="" medsrOccTime=$zt(medsrOccTime,1)
	
	
    ..s medsrOccBatbNo=0,medsrOccBatyNo=0,medsrOccBatjNo=0 //白班初试数量,夜班初试数量,交接班初试数量
	..s medsrOccBatNo=$p(^DHCADVMEDSAR(medsrID),"^",6)     //班次
	
	..i medsrOccBatNo="白班" s medsrOccBatbNo=medsrOccBatbNo+1 , $p(ListData,"^",3)=$p(ListData,"^",3)+1  //白班数量
	..i medsrOccBatNo="夜班" s medsrOccBatyNo=medsrOccBatyNo+1 , $p(ListData,"^",4)=$p(ListData,"^",4)+1  //夜班数量
	..i medsrOccBatNo="交接班" s medsrOccBatjNo=medsrOccBatjNo+1  , $p(ListData,"^",5)=$p(ListData,"^",5)+1 //交接班数量
		
	..s medsrDoctorsMes=0, medsrDoctoryMes=0, medsrDoctorjMes=0 //正式医生初始数量,研究生初始数量,进修医生初始数量
	..s MedsRepLink=..getMedRepLink(medsrID)
	..s medsrDoc=$p(MedsRepLink,"&&",1) //当事医生信息
	
	..s medsrDoctorMes=$p(medsrDoc,"^",2)
	
	..i medsrDoctorMes="10" s medsrDoctorsMes=medsrDoctorsMes+1 ,$p(ListData,"^",6)=$p(ListData,"^",6)+1 //正式医生数量
	..i medsrDoctorMes="11" s medsrDoctoryMes=medsrDoctoryMes+1,$p(ListData,"^",7)=$p(ListData,"^",7)+1 //研究生数量
	..i medsrDoctorMes="12" s medsrDoctorjMes=medsrDoctorjMes+1 ,$p(ListData,"^",8)=$p(ListData,"^",8)+1 //进修医生数量
	

     	
	..s medsrApothecarysMes=0 ,medsrApothecaryxMes=0,medsrApothecaryjMes=0 //正式药师初始数量,研究生初始数量,进修药师初始数量
	..s medsrApo=$p(MedsRepLink,"&&",2) //当事药师信息
	..s medsrApothecaryMes=$p(medsrApo,"^",2)
	
	..i medsrApothecaryMes="20" s medsrApothecarysMes=medsrApothecarysMes+1,$p(ListData,"^",9)=$p(ListData,"^",9)+1 //正式药师数量
	..i medsrApothecaryMes="21" s medsrApothecaryxMes=medsrApothecaryxMes+1 ,$p(ListData,"^",10)=$p(ListData,"^",10)+1 //实习生数量
	..i medsrApothecaryMes="22" s medsrApothecaryjMes=medsrApothecaryjMes+1 ,$p(ListData,"^",11)=$p(ListData,"^",11)+1 //进修药师数量


	..s medsrDisp=$p(MedsRepLink,"&&",3) //配送环节信息
	..s medsrDispDr=$p(medsrDisp,"^",1)
	

	..s medsrNursesMes=0 ,medsrNursexMes=0 ,medsrNursejMes=0  //正式护士初始数量,实习生初始数量,进修护士初始数量
	..s medsrNus=$p(MedsRepLink,"&&",4) //当事护士信息
	..s medsrNurseMes=$p(medsrNus,"^",2)
	
	..i medsrNurseMes="30" s medsrNursesMes=medsrNursesMes+1 ,$p(ListData,"^",14)=$p(ListData,"^",14)+1 //正式护士数量
	..i medsrNurseMes="31" s medsrNursexMes=medsrNursexMes+1 ,$p(ListData,"^",15)=$p(ListData,"^",15)+1 //实习生数量
	..i medsrNurseMes="32" s medsrNursejMes=medsrNursejMes+1 ,$p(ListData,"^",16)=$p(ListData,"^",16)+1 //进修护士数量
	
	
	..s MedsRepResultwDr=0 ,MedsRepResultdDr=0  //差错未到达患者初始数量,差错到达患者初始数量
	..s medsrPatNum=0  //患者环节错误初始值
	..s medsrPat=$p(MedsRepLink,"&&",5) //患者信息
	..s medsrPatDr=$p(medsrPat,"^",1)
	..s MedsRepResult=..getMedRepResult(medsrID)
	..s MedsRepResultDr=$p(MedsRepResult,",",1)
	..;I MedsRepResultDr["," S MedsRepResultDr=$P(MedsRepResultDr,",",1) //以","截取字符                                                                
	..i MedsRepResultDr="1" s MedsRepResultwDr=MedsRepResultwDr+1 ,$p(ListData,"^",12)=$p(ListData,"^",12)+1 //差错未到达患者数量
	..i MedsRepResultDr="2" s MedsRepResultdDr=MedsRepResultdDr+1 ,$p(ListData,"^",13)=$p(ListData,"^",13)+1 //差错到达患者数量

	..s TempStr=medsrID_"^"_medsrRepLocDesc_"^"_medsrOccDate_"^"_medsrOccTime_"^"_medsrOccBatbNo_"^"_medsrOccBatyNo_"^"_medsrOccBatjNo_"^"_medsrDoctorsMes_"^"_medsrDoctoryMes_"^"_medsrDoctorjMes_"^"_medsrApothecarysMes_"^"_medsrApothecaryxMes_"^"_medsrApothecaryjMes_"^"_MedsRepResultwDr_"^"_MedsRepResultdDr_"^"_medsrNursesMes_"^"_medsrNursexMes_"^"_medsrNursejMes_"^"_restDayNum_"^"_workDayNum_"^"_medsrDoctorsNum_"^"_medsrApothecaryNum_"^"_medsrDispNum_"^"_medsrNurseNum_"^"_medsrPatDrNum
	..s TempStr=TempStr_"^"_pid_"^"_LocID
	
	
	..i '$d(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc))  d  //判断所在科室
	...s h=h+1
	...s ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc)=TempStr  
	..e  d
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",5)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",5)+medsrOccBatbNo  //白班数量 
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",6)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",6)+medsrOccBatyNo  //夜班数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",7)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",7)+medsrOccBatjNo  //交替班数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",8)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",8)+medsrDoctorsMes  //医生数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",9)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",9)+medsrDoctoryMes  //研究生数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",10)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",10)+medsrDoctorjMes  //进修医生数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",11)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",11)+medsrApothecarysMes  //正式药师数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",12)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",12)+medsrApothecaryxMes  //实习药师数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",13)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",13)+medsrApothecaryjMes  //进修药师数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",14)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",14)+MedsRepResultwDr  //差错未到达患者数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",15)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",15)+MedsRepResultdDr  //差错到达患者数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",16)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",16)+medsrNursesMes //正式护士数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",17)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",17)+medsrNursexMes  //实习生数量
	...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",18)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",18)+medsrNursejMes  //进修护士数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",19)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",19)+restDayNum  //节假日总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",20)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",20)+workDayNum  //工作日总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",21)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",21)+medsrDoctorsNum  //医生环节总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",22)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",22)+medsrApothecaryNum  //药师环节总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",23)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",23)+medsrDispNum  //配送环节总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",24)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",24)+medsrNurseNum  //护士环节总数量
    ...s $p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",25)=$p(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,medsrRepLocDesc),"^",25)+medsrPatDrNum  //患者环节总数量
    ..
    .
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	S tmp="",tmps=""
	s tmp=ListData
	//S tmp="^合计：^"_ListData_"^"_pid_"^"_"COUNT" //统计总数
	S workRest=0  
	S BatbNo=$p(tmp,"^",3) //白
	S BatyNo=$p(tmp,"^",4)  //夜 
	S BatjNo=$p(tmp,"^",5)  //交
	
	S DoctorsMes=$p(tmp,"^",6) 
	S DoctoryMes=$p(tmp,"^",7)
	S DoctorjMes=$p(tmp,"^",8)
	
	S ApothecarysMes=$p(tmp,"^",9)
	S ApothecaryxMes=$p(tmp,"^",10)
	S ApothecaryjMes=$p(tmp,"^",11)
	
	S ResultwDr=$p(tmp,"^",12)
	S ResultdDr=$p(tmp,"^",13)
	
	S NursesMes=$p(tmp,"^",14)
	S NursexMes=$p(tmp,"^",15)
	S NursejMes=$p(tmp,"^",16) 
	
	S restNum=$p(tmp,"^",17)
	S workNum=$p(tmp,"^",18)
	
	S DoctorsNum=$p(tmp,"^",19)
	S ApothecaryNum=$p(tmp,"^",20)
	S DispNum=$p(tmp,"^",21)
	S NurseNum=$p(tmp,"^",22)
	S PatDrNum=$p(tmp,"^",23)
	S workRest=restNum+workNum
	S dataLists=""
	S dataLists=BatbNo_"^"_BatyNo_"^"_BatjNo
	S dataLists=dataLists_"^"_DoctorsMes_"^"_DoctoryMes_"^"_DoctorjMes
	S dataLists=dataLists_"^"_ApothecarysMes_"^"_ApothecaryxMes_"^"_ApothecaryjMes
	S dataLists=dataLists_"^"_ResultwDr_"^"_ResultdDr
	S dataLists=dataLists_"^"_NursesMes_"^"_NursexMes_"^"_NursejMes
	S dataLists=dataLists_"^"_workRest_""_"^"_"^"_DoctorsNum_"^"_ApothecaryNum_"^"_DispNum_"^"_NurseNum_"^"_PatDrNum
	
	S tmps="^合计：^^^"_dataLists_"^"_pid_"^"_"COUNT" //统计总数
	s ^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,h)=tmps

	///转换数据为Json格式
	S Title="medsrID^medsrRepLocDesc^medsrOccDate^medsrOccTime^medsrOccBatbNo^medsrOccBatyNo^medsrOccBatjNo^medsrDoctorsMes^medsrDoctoryMes^medsrDoctorjMes^medsrApothecarysMes^medsrApothecaryxMes^medsrApothecaryjMes^MedsRepResultwDr^MedsRepResultdDr^medsrNursesMes^medsrNursexMes^medsrNursejMes^restDayNum^workDayNum^medsrDoctorsNum^medsrApothecaryNum^medsrDispNum^medsrNurseNum^medsrPatDrNum^pid^LocID"
	
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,index),-1) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCADVSAFECOUNT","getMedQuery",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

}
