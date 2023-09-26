Import sqluser

/// 查询知识库日志
Class web.DHCSTPHCMORDDATA Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询知识库日志
/// Creator:LiangQiang
/// CreateDate:2016-01-15
/// Input:开始日期^结束日期
/// w ##class(web.DHCSTPHCMORDDATA).QueryLibOrdData("100","1","2016-03-22^2016-03-22")
ClassMethod QueryLibOrdDataOld(rows, page, params) As %String
{
	n (rows,page,params)
	
	s stdate=$p(params,"^",1)
	q:stdate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s enddate=$p(params,"^",2)
	q:enddate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
		
	s stdate=$zdh(stdate,3)
	s enddate=$zdh(enddate,3)
    s num=0
    f date=stdate:1:enddate  d
    .s adm="" f  s adm=$o(^PUMCHDHCPHPASS("a",adm)) q:adm=""  d
    ..q:'$d(^PAADM(adm))
    ..s Papmidr=$p(^PAADM(adm),"^",1)  ///papmidr
    ..s PatNo=$P(^PAPER(Papmidr,"PAT",1),"^",1) //ID号
    ..s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)  //姓名
	..s PatBirth=$ZD($p($g(^PAPER(Papmidr,"ALL")),"^",6),3)  //生日
	..s PatDVANo=$p($g(^PAPER(Papmidr,"ALL")),"^",9)    //身份证号
	..s sexid=$p($g(^PAPER(Papmidr,"ALL")),"^",7)      //性别代码
	..s PatSex=$p($g(^CT("SEX",sexid)),"^",2)             //性别
    ..s Type=$p(^PAADM(adm),"^",2)  //就诊类型
    ..s dep=$p(^PAADM(adm),"^",4) //就诊科室
    ..i dep'="" s dep=$p(^CTLOC(dep),"^",2)
    ..s dep=$p(dep,"-",2)
    ..s AdmDate=$p(^PAADM(adm),"^",6) //就诊日期
    ..i AdmDate'="" s AdmDate=$zd(AdmDate,3)
    ..s genedesc="" f  s genedesc=$o(^PUMCHDHCPHPASS("a",adm,date,genedesc)) q:genedesc=""  d
    ...;q:((Generic'="")&&(genedesc'=Generic))
    ...s irowid="" f  s irowid=$o(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid)) q:irowid=""  d 
    ....s UserInfo="" f  s UserInfo=$o(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo)) q:UserInfo=""  d 
    .....s user=$p(UserInfo,"^",1)
    .....i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
    .....;i user'="" s user=$p(^CTPCP(user,1),"^",2)  ///userID?
    .....s logindep=$p(UserInfo,"^",2)
    .....;q:((LocID'="")&&(logindep'=LocID))
    .....i logindep'="" s logindep= ""  //$p(^CTLOC(logindep),"^",2)
    .....s time="" f  s time=$o(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time)) q:time=""  d 
    ......s pi="" f  s pi=$o(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi)) q:pi=""  d 
    .......;w adm_"^"_pid,!
    .......s num=num+1
    .......s arcitemdr=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",1) //药品名称DR
    .......s ARCIMDESC=$p(^ARCIM(+arcitemdr,$p(arcitemdr,"||",2),1),"^",2)  //医嘱名称
    .......s instid=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",2) //用法ID
    .......;w pid_"^"_instid,!
    .......i instid'="" s Instruc=$P(^PHCIN(instid),"^",3)    //用药途径
    .......s freqid=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",3) //频次DR
    .......i freqid'="" s FreqID=$P(^PHCFR(freqid),"^",3)   
    .......s dosqty=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",4)  //单次计量
    .......s dosuomid=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",5) //单次计量单位
    .......i dosuomid'="" s dosuomdesc=$P(^CT("UOM",dosuomid),"^",2)
    .......s OnceQty=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",6) //整包装数量
    .......s orduomid=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",7) //整包装单位
    .......;i orduomid'="" s orduomid=$P(^CT("UOM",orduomid),"^",2)
    .......s course=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",8) //疗程DR
    .......;i course'="" s DuraID=$p(^PHCDU(course),"^",3)
    .......s DuraID=""
    .......s seqno=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",9) //关联号
    .......;s instid=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pid),"^",10)
    .......s ReceiveDep=""
    .......s ReceiveDepDr=$p(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pi),"^",12) //接收科室
    .......;s OrdItem=$p($g(^PUMCHDHCPHPASS("a",adm,date,genedesc,irowid,UserInfo,time,pid)),"^",13) //oeori_rowid
    .......;q:OrdItem=""
    .......;s statusdr=$p($g(^OEORD(+OrdItem,"I",$p(OrdItem,"||",2),1)),"^",13)
    .......;i statusdr'="" s status=$p(^OEC("OSTAT",statusdr),"^",2)
    .......i ReceiveDepDr'="" s ReceiveDep=$p(^CTLOC(ReceiveDepDr),"^",2)
    .......s Prompt=""
    .......s PromptRowid="" f  s PromptRowid=$o(^PUMCHDHCPHPASS("b",pi,genedesc,PromptRowid)) q:PromptRowid=""  d
    ........s Prompt=$p(^PUMCHDHCPHPASS("b",pi,genedesc,PromptRowid),"^",1)
    .......i '$d(^PUMCHDHCPHPASS("b2",pi,genedesc))  d
    ........s ControlLevel="警示"
    .......e  d
    ........s ControlLevel="管控"
    .......s Flag=""
    .......i Flag="C" s Flag="管控"
    .......i Flag="W" s Flag="警示"
    .......;q:((Flag'="")&&(ControlLevel'=Flag))
    .......s Msg=""
    .......s data=PatNo_"^"_PatName_"^"_dep_"^"_AdmDate_"^"_ARCIMDESC_"^"_genedesc_"^"_Instruc_"^"_FreqID_"^"_dosqty_"^"_dosuomdesc_"^"_OnceQty_"^"_orduomid_"^"_DuraID_"^"_ReceiveDep_"^"_ControlLevel_"^"_Prompt_"^"_num_"^"_$zd(date,3)
    .......s ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,num)=data
    .......
    
    
    
	q:num=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=num
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,h)
    .s PatNo=$p(data,"^",1)
    .s PatName=$p(data,"^",2)
    .s AdmDep=$p(data,"^",3)
    .s AdmDate=$p(data,"^",4)
    .s ArcDesc=$p(data,"^",5)
    .s GeneDesc=$p(data,"^",6)
    .s Instr=$p(data,"^",7)
    .s PHFreq=$p(data,"^",8)
    .s DoseQty=$p(data,"^",9)
    .s Unit=$p(data,"^",10)
    .s Qty=$p(data,"^",11)
    .s QtyUom=$p(data,"^",12)
    .s Durat=$p(data,"^",13)
    .s Recloc=$p(data,"^",14)
    .s Level=$p(data,"^",15)
    .s Msg=$p(data,"^",16)
    .s rowid=$p(data,"^",17)
    .s LogDate=$p(data,"^",18)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s PatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatNo",PatNo)
    .s PatName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatName",PatName)
    .s AdmDep=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDep",AdmDep)
    .s AdmDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDate",AdmDate)
    .s ArcDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ArcDesc",ArcDesc)
    .s GeneDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("GeneDesc",GeneDesc)
    .s Instr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Instr",Instr)
    .s PHFreq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PHFreq",PHFreq)
    .s DoseQty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("DoseQty",DoseQty)
    .s Unit=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Unit",Unit)
    .s Qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Qty",Qty)
    .s QtyUom=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("QtyUom",QtyUom)
    .s Durat=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Durat",Durat)
    .s Recloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Recloc",Recloc)
    .s Level=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Level",Level)
    .s Msg=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Msg",Msg)
    .s LogDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("LogDate",LogDate)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PatNo_PatName_AdmDep_AdmDate_ArcDesc_GeneDesc_Instr_PHFreq_DoseQty_Unit_Qty_QtyUom_Durat_Recloc_Level_Msg_LogDate_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	k ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid)
    
    q ""
}

/// 查询知识库日志
/// Creator:LiangQiang
/// CreateDate:2016-01-15
/// Input:开始日期^结束日期
/// w ##class(web.DHCSTPHCMORDDATA).QueryLibOrdData("100","1","2016-01-22^2016-03-25")
ClassMethod QueryLibOrdData(rows, page, params) As %String
{
	n (rows,page,params)
	
	s stdate=$p(params,"^",1)
	q:stdate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s enddate=$p(params,"^",2)
	q:enddate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
		
	s stdate=$zdh(stdate,3)
	s enddate=$zdh(enddate,3)
    s num=0
    f date=stdate:1:enddate  d
    .s time=""
    .f  s time=$o(^DHCPHLIBORDL(0,"DateTime",date,time)) q:time=""  d
    ..s logid=""
    ..f  s logid=$o(^DHCPHLIBORDL(0,"DateTime",date,time,logid)) q:logid=""  d
    ...s adm=$p(^DHCPHLIBORDL(logid),"^",6)
    ...q:'$d(^PAADM(adm))
    ...s Papmidr=$p(^PAADM(adm),"^",1)  ///papmidr
    ...s PatNo=$P(^PAPER(Papmidr,"PAT",1),"^",1) //ID号
    ...s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)  //姓名
	...s PatBirth=$ZD($p($g(^PAPER(Papmidr,"ALL")),"^",6),3)  //生日
	...s PatDVANo=$p($g(^PAPER(Papmidr,"ALL")),"^",9)    //身份证号
	...s sexid=$p($g(^PAPER(Papmidr,"ALL")),"^",7)      //性别代码
	...s PatSex=$p($g(^CT("SEX",sexid)),"^",2)             //性别
    ...s Type=$p(^PAADM(adm),"^",2)  //就诊类型
    ...s dep=$p(^PAADM(adm),"^",4) //就诊科室
    ...i dep'="" s dep=$p(^CTLOC(dep),"^",2)
    ...s dep=$p(dep,"-",2)
    ...s AdmDate=$p(^PAADM(adm),"^",6) //就诊日期
    ...i AdmDate'="" s AdmDate=$zd(AdmDate,3)
    ...s genedesc=$p(^DHCPHLIBORDL(logid),"^",7)
    ...s user=$p(^DHCPHLIBORDL(logid),"^",3)
    ...
    ...i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
    ...s logindep=$p(^DHCPHLIBORDL(logid),"^",4)
    ...s tmpdata=$p(^DHCPHLIBORDL(logid),"^",10)
    ...s tmpdata=$tr(tmpdata,"/","^")
    ...s num=num+1
    ...s arcitemdr=$p(tmpdata,"^",1) //药品名称DR
    ...s ARCIMDESC=$p(^ARCIM(+arcitemdr,$p(arcitemdr,"||",2),1),"^",2)  //医嘱名称
    ...s Instruc=""
    ...s instid=$p(tmpdata,"^",2) //用法ID
    ...i instid'="" s Instruc=$P(^PHCIN(instid),"^",3)    //用药途径
    ...s FreqID=""
    ...s freqid=$p(tmpdata,"^",3) //频次DR
    ...i freqid'="" s FreqID=$P(^PHCFR(freqid),"^",3)   
    ...s dosqty=$p(tmpdata,"^",4)  //单次计量
    ...s dosuomdesc=""
    ...s dosuomid=$p(tmpdata,"^",5) //单次计量单位
    ...i dosuomid'="" s dosuomdesc=$P(^CT("UOM",dosuomid),"^",2)
    ...s OnceQty=$p(tmpdata,"^",6) //整包装数量
    ...s orduomid=$p(tmpdata,"^",7) //整包装单位
    ...;i orduomid'="" s orduomid=$P(^CT("UOM",orduomid),"^",2)
    ...s course=$p(tmpdata,"^",8) //疗程DR
    ...;i course'="" s DuraID=$p(^PHCDU(course),"^",3)
    ...s DuraID=""
    ...s seqno=$p(tmpdata,"^",9) //关联号
    ...s ReceiveDep=""
    ...s ReceiveDepDr=$p(tmpdata,"^",12) //接收科室
    ...i ReceiveDepDr'="" s ReceiveDep=$p(^CTLOC(ReceiveDepDr),"^",2)
    ...s Prompt=$p(^DHCPHLIBORDL(logid),"^",9)
    ...s ControlLevel=$p(^DHCPHLIBORDL(logid),"^",8)
    ...s Flag=""
    ...i Flag="C" s Flag="管控"
    ...i Flag="W" s Flag="警示"
    ...
    ...s Msg=""
    ...s data=PatNo_"^"_PatName_"^"_dep_"^"_AdmDate_"^"_ARCIMDESC_"^"_genedesc_"^"_Instruc_"^"_FreqID_"^"_dosqty_"^"_dosuomdesc_"^"_OnceQty_"^"_orduomid_"^"_DuraID_"^"_ReceiveDep_"^"_ControlLevel_"^"_Prompt_"^"_num_"^"_$zd(date,3)
    ...s ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,num)=data
    ...
    
	q:num=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=num
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid,h)
    .s PatNo=$p(data,"^",1)
    .s PatName=$p(data,"^",2)
    .s AdmDep=$p(data,"^",3)
    .s AdmDate=$p(data,"^",4)
    .s ArcDesc=$p(data,"^",5)
    .s GeneDesc=$p(data,"^",6)
    .s Instr=$p(data,"^",7)
    .s PHFreq=$p(data,"^",8)
    .s DoseQty=$p(data,"^",9)
    .s Unit=$p(data,"^",10)
    .s Qty=$p(data,"^",11)
    .s QtyUom=$p(data,"^",12)
    .s Durat=$p(data,"^",13)
    .s Recloc=$p(data,"^",14)
    .s Level=$p(data,"^",15)
    .s Msg=$p(data,"^",16)
    .s rowid=$p(data,"^",17)
    .s LogDate=$p(data,"^",18)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s PatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatNo",PatNo)
    .s PatName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatName",PatName)
    .s AdmDep=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDep",AdmDep)
    .s AdmDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDate",AdmDate)
    .s ArcDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ArcDesc",ArcDesc)
    .s GeneDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("GeneDesc",GeneDesc)
    .s Instr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Instr",Instr)
    .s PHFreq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PHFreq",PHFreq)
    .s DoseQty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("DoseQty",DoseQty)
    .s Unit=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Unit",Unit)
    .s Qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Qty",Qty)
    .s QtyUom=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("QtyUom",QtyUom)
    .s Durat=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Durat",Durat)
    .s Recloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Recloc",Recloc)
    .s Level=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Level",Level)
    .s Msg=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Msg",Msg)
    .s LogDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("LogDate",LogDate)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PatNo_PatName_AdmDep_AdmDate_ArcDesc_GeneDesc_Instr_PHFreq_DoseQty_Unit_Qty_QtyUom_Durat_Recloc_Level_Msg_LogDate_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	k ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrdData",pid)
    
    q ""
}

/// Desc:查询知识库医嘱数据
/// Creator:LiangQiang
/// CreateDate:2016-01-15
/// Input:开始日期^结束日期
/// w ##class(web.DHCSTPHCMORDDATA).QueryLibOrditem("100","1","2017-02-28^2017-02-28")
ClassMethod QueryLibOrditemOld(rows, page, params) As %String
{
	n (rows, page, params)
	
	s stdate=$p(params,"^",1)
	q:stdate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s enddate=$p(params,"^",2)
	q:enddate="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
		
	s stdate=$zdh(stdate,3)
	s enddate=$zdh(enddate,3)
	
	s num=0
	s date=""   
    f date=stdate:1:enddate  d
    .s oeord="" f  s oeord=$o(^OEORDi(0,"ItemDate",date,oeord)) q:oeord=""  d
    ..s admdr=$p(^OEORD(oeord),"^",1)
    ..s Papmidr=$p(^PAADM(admdr),"^",1)
    ..s PatNo=$P(^PAPER(Papmidr,"PAT",1),"^",1) //ID号
    ..s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)  //姓名
	..s PatBirth=$ZD($p($g(^PAPER(Papmidr,"ALL")),"^",6),3)  //生日
	..s PatDVANo=$p($g(^PAPER(Papmidr,"ALL")),"^",9)    //身份证号
	..s sexid=$p($g(^PAPER(Papmidr,"ALL")),"^",7)      //性别代码
	..s PatSex=$p($g(^CT("SEX",sexid)),"^",2)             //性别
    ..s Type=$p(^PAADM(admdr),"^",2)  //就诊类型
    ..i Type="I" s Type="住院"
    ..i Type="O" s Type="门诊"
    ..i Type="E" s Type="急诊"
    ..s dep=$p(^PAADM(admdr),"^",4) //就诊科室
    ..i dep'="" s dep=$p(^CTLOC(dep),"^",2)
    ..s dep=$p(dep,"-",2)
    ..s AdmDate=$p(^PAADM(admdr),"^",6) //就诊日期
    ..i AdmDate'="" s AdmDate=$zd(AdmDate,3)
    ..s oeordsub="" f  s oeordsub=$o(^OEORDi(0,"ItemDate",date,oeord,oeordsub)) q:oeordsub=""  d
    ...s Rowid=oeord_"||"_oeordsub
    ...q:'$d(^OEORD(oeord,"I",oeordsub,3))
    ...s oerecdepdr=$p(^OEORD(oeord,"I",oeordsub,3),"^",6)
    ...q:oerecdepdr=""
    ...s oerecdep=$p(^CTLOC(oerecdepdr),"^",2)
    ...s oearcimdr=$p(^OEORD(oeord,"I",oeordsub,1),"^",2)
    ...s arcimdesc=$p(^ARCIM(+oearcimdr,1,1),"^",2)
    ...
    ...s ARCCATRowid=$p(^ARCIM(+oearcimdr,1,1),"^",10)		//取医嘱子分类  ARCItemCat
    ...;q:ARCCATRowid="299"           //中草药退出D0301
    ...q:ARCCATRowid=""														//退出子分类为空的医嘱项
    ...s ARCICOrderType=$p(^ARC("IC",ARCCATRowid),"^",7)						//取医嘱类型  R 为药品
    ...;q:ARCICOrderType'="R"													//退出不是药品的医嘱
    ...;判断药品通用名不存在退出
    ...s genedesc="",genecode=""
    ...i ARCICOrderType="R" d
	....s phcdf=$p($g(^ARCIM(+oearcimdr,1,1)),"^",12)
    ....s phcd=+phcdf
    ....s phcdsub=$p(phcdf,"||",2)
    ....s gene=$p($g(^PHCD(phcd,4)),"^",1) 
    ....q:gene=""    
    ....s genecode=$p($g(^PHCGE("GE",gene)),"^",1) 
    ....s genedesc=$p($g(^PHCGE("GE",gene)),"^",2) //通用名
    ...i ARCICOrderType="L" d
	....s genecode=$P(^ARCIM(+oearcimdr,$p(oearcimdr,"||",2),1),"^",1)
	....s genedesc=$P(^ARCIM(+oearcimdr,$p(oearcimdr,"||",2),1),"^",2)
	....s TestCode=##class(web.DHCSTPHCMPASS).GetTestCode(oearcimdr)
	....q:TestCode=""
	....s genecode=TestCode
	...
	...s ServerMaterial=$p($g(^ARCIM($p(oearcimdr,"||",1),$p(oearcimdr,"||",2),7)),"^",6)
	...i ServerMaterial="S" d
	....//检查
	....s genecode=$P(^ARCIM(+oearcimdr,$p(oearcimdr,"||",2),1),"^",1)
	....s genedesc=$P(^ARCIM(+oearcimdr,$p(oearcimdr,"||",2),1),"^",2)
	...q:genedesc=""
    ...;q:$d(^DHCPHEGENi(0,"Desc",$$ALPHAUP^SSUTIL4(genedesc)))=0
    ...q:$o(^DHCPHGENCON(0,"HisCode",genecode,""))="" //无对照
    ...
    ...s StatusDR=$p(^OEORD(oeord,"I",oeordsub,1),"^",13) //医嘱状态
    ...s FillNo=$p(^OEORD(oeord,"I",oeordsub,9),"^",12) // 首日医嘱
    ...q:FillNo'=""
    ...i StatusDR'="" s Status=$p(^OEC("OSTAT",StatusDR),"^",2)
    ...s DoseQty=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",1) //单次剂量
    ...s UnitDR=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",3) //单次剂量单位
    ...s PHFreqDR=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",4) //频次
    ...s DuratDR=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",6) //疗程
    ...s InstrDR=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",7) //用法
    ...;q:InstrDR=""
    ...s SeqNo=$p(^OEORD(oeord,"I",oeordsub,3),"^",4) //关联号
    ...s RecDepDR=$p(^OEORD(oeord,"I",oeordsub,3),"^",6) //接收科室
    ...s UserDR=$p(^OEORD(oeord,"I",oeordsub,1),"^",11) //下嘱用户OEORI_Doctor_DR
    ...w UserDR_"&&&&&&&&",!
    ...q:UserDR=""
    ...s User="" f  s User=$o(^SSU("SSUSR",0,"CTPCP",UserDR,User)) q:User=""  d
    ....s UserID=$p(^SSU("SSUSR",User),"^",2)
    ....s Group=$p(^SSU("SSUSR",User),"^",5)
    ...s LocIDOrdDept=$p(^OEORD(oeord,"I",oeordsub,1),"^",3) //下嘱科室 OEORI_OrdDept_DR
    ...;q:((LocID'="")&&(LocIDOrdDept'=LocID))
    ...s Billed=""
    ...s OrderType=""
    ...;s QtyPackUOM=$p(^OEORD(oeord,"I",oeordsub,9),"^",4) //整包装数量
    ...s QtyPackUOM="",PackUOMUnit=""
    ...s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeord_"||"_oeordsub,""))
    ...i dsp'="" s QtyPackUOM=$p(^DHCOEDISQTY(dsp),"^",2)
    ...s incl="" f  s incl=$o(^INCI(0,"ARCIM_DR",$p(oearcimdr,"||",1),incl)) q:incl=""  d
    ....s PackUOMUnitDr=$p(^INCI(incl,3),"^",6)
    ....s PackUOMUnitDr=$p(^INCI(incl,1),"^",10)
    ....i PackUOMUnitDr'="" s PackUOMUnit=$p(^CT("UOM",PackUOMUnitDr),"^",2) //整包装单位
    ...s OrdMesage=oearcimdr_"^"_InstrDR_"^"_PHFreqDR_"^"_DoseQty_"^"_UnitDR_"^"_QtyPackUOM_"^"_PackUOMUnit_"^"_DuratDR_"^"_SeqNo_"^"_Billed_"^"_OrderType_"^"_RecDepDR
    ...s OrdIDStr=""
    ...
    ...s LibLabel="C"
    ...s Input=admdr_"!"_OrdMesage_"!"_OrdIDStr
    ...;w Input,!
    ...;w User_"^^^^^"_UserID
	...s ReturnStr=""  ;返回信息
	...s str=""
	...s UserInfo=User_"^"_LocIDOrdDept_"^"_Group
	...d ##class(web.DHCSTPHCMPASS).CheckLibPha(.ReturnStr,LibLabel,Input,UserInfo)
	...s Rtn=$P(ReturnStr,"^",1)
	...
	...q:Rtn'=0
	...s level=""
	...s LevelCode=$P(ReturnStr,"^",2)
	...i LevelCode="1" s level="管控"
	...i LevelCode="0" s level="警示"
	...s num=num+1
	...s ControlLev=$P(ReturnStr,"^",2)
	...s Mesage=$P(ReturnStr,"^",3) 
	...s ReturnStr=Rtn_"^"_ControlLev_"^"_Mesage
	...i InstrDR'="" s InstrDR=$P(^PHCIN(InstrDR),"^",3)    //用药途径
	...i PHFreqDR'="" s PHFreqDR=$P(^PHCFR(PHFreqDR),"^",3)    //频次
    ...i UnitDR'="" s UnitDR=$P(^CT("UOM",UnitDR),"^",2) //单次剂量单位
    ...i DuratDR'="" s DuratDR=$p(^PHCDU(DuratDR),"^",3)     //疗程
    ...s data=PatNo_"^"_PatName_"^"_dep_"^"_AdmDate_"^"_Type_"^"_arcimdesc_"^"_DoseQty_"^"_UnitDR_"^"_PHFreqDR_"^"_DuratDR_"^"_InstrDR_"^"_QtyPackUOM_"^"_PackUOMUnit_"^"_Rowid_"^"_Status_"^"_level_"^"_Mesage
    ...s ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrditem",pid,num)=data
    ...
    
	q:num=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=num
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrditem",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrditem",pid,h)
    .s PatNo=$p(data,"^",1)
    .s PatName=$p(data,"^",2)
    .s AdmDep=$p(data,"^",3)
    .s AdmDate=$p(data,"^",4)
    .s ArcType=$p(data,"^",5)
    .s ArcDesc=$p(data,"^",6)
    .s DoseQty=$p(data,"^",7)
    .s Unit=$p(data,"^",8)
    .s PHFreq=$p(data,"^",9)
    .s Durat=$p(data,"^",10)
    .s Instr=$p(data,"^",11)
    .s Qty=$p(data,"^",12)
    .s QtyUom=$p(data,"^",13)
    .s rowid=$p(data,"^",14)
    .s Status=$p(data,"^",15)
    .s Level=$p(data,"^",16)
    .s Msg=$p(data,"^",17)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .
    .s PatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatNo",PatNo)
    .s PatName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatName",PatName)
    .s AdmDep=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDep",AdmDep)
    .s AdmDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDate",AdmDate)
    .s ArcType=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ArcType",ArcType)
    .s ArcDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ArcDesc",ArcDesc)
    .s DoseQty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("DoseQty",DoseQty)
    .s Unit=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Unit",Unit)
    .s PHFreq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PHFreq",PHFreq)
    .s Durat=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Durat",Durat)
    .s Instr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Instr",Instr)
    .s Qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Qty",Qty)
    .s QtyUom=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("QtyUom",QtyUom)
    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
    .s Status=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Status",Status)
    .s Level=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("Level",Level)
    .s Msg=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("Msg",Msg)
	.
	.s tmpstr=PatNo_PatName_AdmDep_AdmDate_ArcType_ArcDesc_DoseQty_Unit_PHFreq_Durat_Instr_Qty_QtyUom_rowid_Status_Level_Msg
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
 
	k ^TMP("DHCST","DHCSTPHCMORDDATA ","QueryLibOrditem",pid)
    
    q ""
}

/// Description:	获取知识库医嘱数据
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
/// Input:			
/// return:			
/// other:			w ##class(web.DHCSTPHCMORDDATA).QueryLibOrditemNew(100,1,"01/02/2018^23/02/2018^^^全部^")
ClassMethod QueryLibOrditemNew(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page,params)
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()	
    d ..killTmpGlobal(pid) 				// k掉临时global
    s h=0
    s end = page*rows
	s start=(page-1)*rows+1
	/// 拆分查询条件
	s stDate=$p(params,"^",1)
	s endDate=$p(params,"^",2)	
	i stDate'="" s stDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(stDate)	// $zdh(stDate,3)
	i endDate'="" s endDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) // $zdh(endDate,3)
	s levelMan=$p(params,"^",3)			// 管理级别
	s queryLabel=$p(params,"^",4)		// 目录
	s queryLabelDesc=$p(params,"^",5)	// 目录描述
	//s queryErrFlag=$p(params,"^",5)	// 异常原因
	s queryAdmLoc=$p(params,"^",6)		// 就诊科室	2017/6/16 qunianpeng
	/// 开始查询
	s date=""
	f date=stDate:1:endDate  d
	.s num=0,mrRowId=""
	.f  s mrRowId=$o(^DHCPHMREC(0,"ExDate",date,mrRowId)) q:mrRowId=""  d
	..s adm=$p(^DHCPHMREC(mrRowId),"^",1) 
	..s oeori=$p(^DHCPHMREC(mrRowId),"^",2)				// 医嘱id
	..q:oeori=""
	..s admType=$p($g(^PAADM(adm)),"^",2)   			// I 住院 O 门诊  E急诊
	..q:$d(^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"mrRowId",mrRowId)) // 一条监测长嘱只显示一次 2017/6/15 qnp
	..s oeord=$p(oeori,"||",1)							// 获取医嘱基本信息
	..s oeordSub=$p(oeori,"||",2)
	..q:'$d(^OEORD(oeord,"I",oeordSub))
	..s patientId=+$p($g(^PAADM(adm)),"^",1) 
	..q:patientId=0
	..s patNo=$P($g(^PAPER(patientId,"PAT",1)),"^",1)	// 登记号
	..s patName=$p($g(^PAPER(patientId,"ALL")),"^",1)	// 姓名
	..s admLocDr=$p(^DHCPHMREC(mrRowId),"^",6) 		 	
	..i admLocDr'="" s admLocDesc=$p(^CTLOC(admLocDr),"^",2) // 就诊科室
    ..q:((queryAdmLoc'="")&&(queryAdmLoc'=admLocDr))		// 根据科室查询
	..
   	..s oeoriDate=date
    ..i oeoriDate'="" s oeoriDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(oeoriDate) // $zd(oeoriDate,3)
    ..s admDocDr=$p(^DHCPHMREC(mrRowId),"^",5)			// 就诊医生
    ..s admDocDesc=$p($g(^SSU("SSUSR",admDocDr)),"^",2)
    ..s medicalNo=$p(^PAPER(patientId,"PAT",1),"^",22)	// 病案号 
    ..//s medicalNo=##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(adm,"")  //qnp 2017/6/2 江苏省中医院 病案号=住院号 多次住院会有多个（第三方提供）
	..s arcdr=$p(^DHCPHMREC(mrRowId),"^",8)				// 医嘱名称
	..s arcDesc=$p($g(^ARCIM(+arcdr,1,1)),"^",2) 	
	..s ordItemIfo=..GetOrdItmInfo(oeori)		
	..s doseQty=$p(ordItemIfo,"^",1)					// 单次剂量
	..s unitDesc=$p(ordItemIfo,"^",2)					// 单次剂量单位
	..s totalQty=$p(ordItemIfo,"^",3)					// 数量
	..s phFreqDesc=$p(ordItemIfo,"^",4)					// 频率
	..s instrDesc=$p(ordItemIfo,"^",5)					// 用法
	..s course=""
	..s rmanf=$p(ordItemIfo,"^",6)						// 生产厂家
	..s speciFaction=$p(ordItemIfo,"^",7)				// 规格
	..s patDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")	// 诊断
	..
	../// 提示信息
	..s mrlSub=""
	..f  s mrlSub=$o(^DHCPHMREC(mrRowId,"Label",mrlSub)) q:mrlSub=""  d
	...s label=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",1)
	...q:label=""
	...s labelDesc=$p(^DHCPHPINL(label),"^",2)
	...//q:(queryLabel'="")&(label'=queryLabel)						// 根据目录查询
	...q:((queryLabelDesc'="全部")&(queryLabelDesc'=""))&&(labelDesc'=queryLabelDesc)	  	// 根据目录查询
	...s level=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",8)
	...q:(levelMan'="")&(level'=levelMan)				// 根据管理级别查询
	...s levelDesc=$select(level="S":"提示",level="W":"警示",level="C":"管制",1:"警示")
	...s errMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",3)
	...s trueMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",4)	
	...i trueMsg="" s trueMsg=errMsg
	
	...s tmpData=adm_"^"_patNo_"^"_patName_"^"_medicalNo_"^"_$g(admLocDesc)_"^"_admDocDesc_"^"_patDiag_"^"_arcDesc_"^"_doseQty_"^"_unitDesc_"^"_phFreqDesc_"^"_instrDesc
	...s tmpData=tmpData_"^"_course_"^"_rmanf_"^"_speciFaction_"^"_levelDesc_"^"_labelDesc_"^"_trueMsg_"^"_mrRowId_"||"_mrlSub
	...s h=h+1	
	...s ^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,h)=tmpData
	...
	..s ^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"mrRowId",mrRowId)="" // 一条监测长嘱只显示一次 2017/6/15 qnp
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h)	// 输出json结尾符
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) 		// 输出json前缀串
	
	s title="adm^patNo^patName^medicalNo^admLoc^admDocDesc^patDiag^arcDesc^doseQty^unitDesc^phFreqDesc^instrDesc^course^rmanf^speciFaction^levelDesc^labelDesc^trueMsg^rowId"
		
	//信息输出
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,index),-1) q:index=""  d
	.q:+index=0
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() // 输出json结尾符
	
	d ..killTmpGlobal(pid)							// k掉临时global	

 	q ""
}

/// Description:	查询日志信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
/// Input:			
/// return:			
/// other:			w ##class(web.DHCSTPHCMORDDATA).QueryLibOrdDataNew(100,1,"01/02/2018^23/02/2018^^^全部^")
ClassMethod QueryLibOrdDataNew(rows, page, params) As %String
{
	n (rows, page,params)
	s pid=..NewPid()
    d ..killTmpGlobal(pid) // k掉临时global
    s h=0
    s end = page*rows
	s start=(page-1)*rows+1
	/// 拆分查询条件
	s stDate=$p(params,"^",1)
	s endDate=$p(params,"^",2)	
	i stDate'="" s stDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(stDate)	// $zdh(stDate,3)
	i endDate'="" s endDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) // $zdh(endDate,3)
	s levelMan=$p(params,"^",3)			// 管理级别
	s queryLabel=$p(params,"^",4)		// 目录
	s queryLabelDesc=$p(params,"^",5)	// 目录描述
	s queryAdmLoc=$p(params,"^",6)		// 就诊科室	
	/// 开始查询
	s date=""
	f date=stDate:1:endDate  d
	.s mrRowId=""
	.f  s mrRowId=$o(^DHCPHMREC(0,"CreateDate",date,mrRowId)) q:mrRowId=""  d
	..s adm=$p(^DHCPHMREC(mrRowId),"^",1) 
	..q:'$d(^PAADM(adm))
	..s admType=$p($g(^PAADM(adm)),"^",2)    			// I 住院 O 门诊  E急诊
	..s patientId=+$p($g(^PAADM(adm)),"^",1)  
	..s patNo=$P($g(^PAPER(patientId,"PAT",1)),"^",1)	// 登记号
	..s patName=$p($g(^PAPER(patientId,"ALL")),"^",1)	// 姓名
	..s admLocDr=$p(^PAADM(adm),"^",4) 					// 就诊科室
    ..i $g(admLocDr)'="" s admLocDesc=$p(^CTLOC(admLocDr),"^",2)
    ..i ($g(admLocDesc)'="")&($g(admLocDesc)["-") s admLocDesc=$p($g(admLocDesc),"-",2)
    ..q:((queryAdmLoc'="")&(queryAdmLoc'=admLocDr))	 	// 根据科室查询 qunianpeng 2017/6/16
    ..s admDate=$p(^PAADM(adm),"^",6)					// 就诊日期
    ..i admDate'="" s admDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(admDate) // $zd(admDate,3)
    ..s medicalNo=$p(^PAPER(patientId,"PAT",1),"^",22)	// 病案号 
    ..s arci=$p(^DHCPHMREC(mrRowId),"^",8)				// 医嘱名称
	..s arcDesc=$p($g(^ARCIM(+arci,1,1)),"^",2) 	
	..s tmpPara=$p(^DHCPHMREC(mrRowId),"^",16)			// 入参信息
	..s instrDr=$p(tmpPara,"@",2)						// 用法
 	..i instrDr'="" s instrDesc=$P(^PHCIN(instrDr),"^",2)  
	..s phFreqDr=$p(tmpPara,"@",3)						// 频率
	..i phFreqDr'="" s phFreqDesc=$P(^PHCFR(phFreqDr),"^",3) 	
	..s doseQty=$p(tmpPara,"@",4)						// 单次剂量
	..s unitDr=$p(tmpPara,"@",5)						// 单次剂量单位
	..i unitDr'="" s unitDesc=$P(^CT("UOM",unitDr),"^",2) 
    ..s course=$p(tmpPara,"@",8) 						// 疗程DR
    ..i course'="" s course=$p(^PHCDU(+course),"^",1)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arci,"||",1),""))  		// 库存项ID
	..s rmanf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 
	..i rmanf["-" s rmanf=$p(rmanf,"-",2)						// 生产厂家
	..s speciFaction=##class(web.DHCSTKUTIL).GetSpec(inci) 		// 规格
	..s mrlSub=""
	..f  s mrlSub=$o(^DHCPHMREC(mrRowId,"Label",mrlSub)) q:mrlSub=""  d
	...s level=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",8)
	...q:(levelMan'="")&&(level'=levelMan)						// 根据管理级别查询
	...s level=$select(level="S":"提示",level="W":"警示",level="C":"管制",1:"警示")
	...s label=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",1)
	...q:label=""
	...i $g(label)'="" s labelDesc=$p(^DHCPHPINL(label),"^",2)
	...q:(queryLabelDesc'="全部")&&(labelDesc'=queryLabelDesc)	// 根据目录描述查询
	...//q:(queryLabel'="")&(label'=queryLabel)					// 根据目录查询	
	...s errMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",3)
	...s trueMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",4)	
	...i trueMsg="" s trueMsg=errMsg
	...	
	...s tmpData=adm_"^"_patNo_"^"_patName_"^"_medicalNo_"^"_$g(admLocDesc)_"^"_$g(admDate)_"^"_arcDesc_"^"_$g(instrDesc)_"^"_$g(phFreqDesc)_"^"_doseQty_"^"_$g(unitDesc)_"^"_course_"^"_rmanf_"^"_speciFaction_"^"_level_"^"_$g(labelDesc)_"^"_trueMsg_"^"_mrRowId_"||"_mrlSub
	...s ^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrdDataNew",pid,admDate_h)=tmpData
	...s h=h+1	
	...

	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串	
	s title="adm^patNo^patName^medicalNo^admLocDesc^admDate^arcDesc^instrDesc^phFreqDesc^doseQty^unitDesc^course^rmanf^speciFaction^level^labelDesc^trueMsg^rowId"
	//信息输出
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrdDataNew",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrdDataNew",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global	

 	q ""
}

/// Description:	本医嘱是否关联医嘱 
/// Creator:		QuNianpeng
/// CreateDate:		2017-04-11
/// Input:			医嘱id
/// return:			1-是；0-否 
/// other:
ClassMethod GetOISeqFlag(oeori As %String) As %String
{
	Q:oeori="" 0
 	N (oeori)
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S glflag=0
 	S reploc=$P(^OEORD(ord,"I",chl,3),"^",6)
 	S linkorder=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:linkorder'="" 1
 	I linkorder="" D
 	.S tmpchl=""
 	.F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,oeori,tmpchl)) Q:(tmpchl="")!(glflag=1)  d
 	..Q:'$D(^OEORD(ord,"I",tmpchl,3))
 	..Q:'$D(^OEORD(ord,"I",tmpchl,1))
 	..Q:$P(^OEORD(ord,"I",tmpchl,3),"^",6)'=reploc
 	..s linksubord=ord_"||"_tmpchl
 	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",linksubord,""))
    ..q:dsp=""
 	..s glflag=1
 	q glflag
}

/// Description:	计算疗程 
/// Creator:		QuNianpeng
/// CreateDate:		2017-04-11
/// Input:			医嘱id
/// return:			1-是；0-否 
/// other:	计算方法：
///  1.医嘱是临嘱,直接取疗程
/// 	 2.医嘱是长嘱,并医嘱未停止：(1)若开医嘱日期<开始查询日期,则疗程=查询结束日期-开始查询日期 (2)若开医嘱日期>开始查询日期，则疗程=于查询结束日期-开医嘱日期
///  3.医嘱是长嘱，且医嘱停止:  A-(1)若停止日期<查询结束日期，且开医嘱日期<开始查询日期，则疗程=停止日期-开始查询日期;(2)若开医嘱日期>开始查询日期,则疗程=停止日期-开医嘱日期
/// 		B-(1)若停止日期>查询结束日期，且开医嘱日期<开始查询日期,则疗程=查询结束日期-开始查询日期 (2)若开医嘱日期>开始查询日期,则疗程=查询结束日期-开医嘱日期
/// w ##class(web.DHCSTPHCMORDDATA).GetCourse(oeord,sub,stDate,endDate)
ClassMethod GetCourse(oeord, oeordSub, stDate, endDate) As %String
{
	n (oeord,oeordSub,stDate,endDate)
	;s arcItmId=$p(^OEORD(oeord,"I",sub,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	;s itemCatDR=$p(^ARCIM($p(arcItmId,"||",1),$p(arcItmId,"||",2),1),"^",10)
    ;s ordertype=$P(^ARC("IC",itemCatDR),"^",7)
    ;s ordertype="R"	//药品医嘱   
    s course=""
    s courseDesc=""
	s priDr=+$p($g(^OEORD(oeord,"I",oeordSub,1)),"^",8) 
    q:priDr=0 
    s priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码
    i priorty'="S"  d 			  //临嘱和其他
    .s courseDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",6) 
    .i courseDr'="" s courseDesc=$p(^PHCDU(courseDr),"^",3)
	e  d	
	.s statDr=$p(^OEORD(oeord,"I",oeordSub,1),"^",13)
    .s oeFlag=$p(^OEC("OSTAT",statDr),"^",1) 	//医嘱状态
    .;s oeRowID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(oeFlag),""))
    .;s oeDesc=$p(^OEC("OSTAT",OeRowID),"^",2) 	
	.s oeoriStartDate=$p(^OEORD(oeord,"I",oeordSub,1),"^",9)  //开始日期(要求开始执行)
	.s oeoriEndDate=$p(^OEORD(oeord,"I",oeordSub,3),"^",34)     //停止日期
	.
	.i oeFlag'="D" d	//医嘱未停止
	..s:oeoriStartDate>=stDate course=endDate-oeoriStartDate
	..s:oeoriStartDate<stDate course=endDate-stDate
	..;s course=endDate-oeoriStartDate
	..s:course=0 course=1
	.e  d		//医嘱停止
	..i oeoriEndDate>=endDate d									//医嘱结束日期大于查询结束日期
	...s:oeoriStartDate>=stDate course=endDate-oeoriStartDate
	...s:oeoriStartDate<stDate course=endDate-stDate
	...;s course=endDate-oeoriStartDate
	...s:course=0 course=1	
	..i oeoriEndDate<endDate d									//医嘱结束日期小于查询结束日期
	...s:oeoriStartDate>=stDate course=oeoriEndDate-oeoriStartDate
	...s:oeoriStartDate<stDate course=oeoriEndDate-stDate
	...;s course=oeoriEndDate-oeoriStartDate
	...s:course=0 course=1	
	..
	.s courseDesc=course_"天"
	.
	
	q courseDesc
}

/// Description:	获取知识库目录ID和描述（只查知识库标识是药品的）
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
/// Input:			医嘱id
/// return:			录id,目录描述
/// other:			w ##class(web.DHCSTPHCMORDDATA).GetLabel()
ClassMethod GetLabel() As %String
{
	;w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(0) //输出json前缀串
	w "["
	s count=""
	s title="value^text"
	s label=""
	f  s label=$o(^DHCPHPINL(label)) q:label=""  d
	.q:(label=0)||(label="")
	.s libaryDr=$p(^DHCPHPINL(label),"^",5)			// 知识库标识
	.s libaryDesc=$p(^DHCPHLIBL(libaryDr),"^",1)	// 知识库标识代码
	.q:libaryDesc'="DRUG"
	.s labelDesc=$p(^DHCPHPINL(label),"^",2)
	.q:(labelDesc="不良反应")||(labelDesc="注意事项")||(labelDesc="炮制作用")
	.s tmp=label_"^"_labelDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,"^全部")
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,tmp)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,tmp)
	w "]"
}

/// Description:	查询知识库医嘱数据(打印)
/// Creator:		QuNianpeng
/// CreateDate:		2017-5-26
/// Input:			
/// return:			
/// other:			d ##class(%ResultSet).RunQuery("web.DHCSTPHCMORDDATA","GetLibOidItemExp","2017-06-01^2017-06-30^^^^^")
ClassMethod GetLibOidItemExpExecute(ByRef qHandle As %Binary, params As %String) As %Status
{
	n (qHandle,params)
	s repid=$I(^CacheTemp)
	s ind=1
	;s qHandle=$lb(0,repid,0)
	
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0
   	
	s stDate=$p(params,"^",1)
	s endDate=$p(params,"^",2)	
	i stDate'="" s stDate=$zdh(stDate,3)
	i endDate'="" s endDate=$zdh(endDate,3)
	s levelMan=$p(params,"^",3)			// 管理级别
	s queryLabel=$p(params,"^",4)		// 目录
	s queryErrFlag=$p(params,"^",5)		// 异常原因
	s queryAdmLoc=$p(params,"^",6)		// 就诊科室	2017/6/16 qunianpeng
	/// 开始查询
	s date=""
	f date=stDate:1:endDate  d
	.s num=0
	.s mrRowId=""
	.f  s mrRowId=$o(^DHCPHMREC(0,"ExDate",date,mrRowId)) q:mrRowId=""  d
	..s adm=$p(^DHCPHMREC(mrRowId),"^",1) 
	..s oeori=$p(^DHCPHMREC(mrRowId),"^",2)	// 医嘱id
	..q:oeori=""
	..s admType=$p($g(^PAADM(adm)),"^",2)   // I 住院 O 门诊  E急诊
	..;q:$d(^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"adm",adm,oeori)) //长嘱只显示一次 2017/5/31 qnp
	..q:$d(^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"mrRowId",mrRowId)) //一条监测长嘱只显示一次 2017/6/15 qnp
	../// 获取医嘱基本信息
	..s oeord=$p(oeori,"||",1)
	..s oeordSub=$p(oeori,"||",2)
	..s patientID=$p(^PAADM(adm),"^",1)  	
	..s patNo=$P(^PAPER(patientID,"PAT",1),"^",1)      			// 登记号
	..s patName=$p($g(^PAPER(patientID,"ALL")),"^",1)  			// 姓名
	..s admLocDr=$p(^DHCPHMREC(mrRowId),"^",6) 		 	
	..i admLocDr'="" s admLocDesc=$p(^CTLOC(admLocDr),"^",2)	// 就诊科室
	..//根据科室查询 qunianpeng 2017/6/16
    ..q:((queryAdmLoc'="")&&(queryAdmLoc'=admLocDr))&&((queryAdmLoc'="")&&(queryAdmLoc'[admType))
	..
	..;s admDate=$p(^PAADM(adm),"^",6)				 			// 就诊日期
    ..;i admDate'="" s admDate=$zd(admDate,3)
    ..;s oeoriDate=$p(^OEORD(oeord,"I",oeordSub,3),"^",7) 		// 医嘱日期(开医嘱日期) QuNianpeng 2017/5/26
    ..;s oeorExSub=$o(^OEORD(oeord,"I",oeordSub,"X",""),-1) 
    ..s oeoriDate=date  //$p(^OEORD(oeord,"I",oeordSub,"X",oeorExSub),"^",1) //用药日期 QuNianpeng 2017/7/12
    ..i oeoriDate'="" s oeoriDate=$zd(oeoriDate,3)
	..
    ..s admDocDr=$p(^DHCPHMREC(mrRowId),"^",5) 					// 就诊医生
    ..s admDocDesc=$p(^SSU("SSUSR",admDocDr),"^",2)
    .. 
    ..;s medicalNo=$p(^PAPER(patientID,"PAT",1),"^",22) 		// 病案号
    ..s medicalNo=##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(adm,"")  //qnp 2017/6/2 江苏省中医院 病案号=住院号 多次住院会有多个（第三方提供）
	..s arcdr=$p(^DHCPHMREC(mrRowId),"^",8)
	..s arcDesc=$p($g(^ARCIM(+arcdr,1,1)),"^",2) 				// 医嘱名称
	..s doseQty=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",1)		// 单次剂量
	..s unitDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",3) 		// 单次剂量单位
	..i unitDr'="" s unitDesc=$P(^CT("UOM",unitDr),"^",2) 	
    ..s totalQty=""												// 数量  （门诊病人取） //2017/6/19 qunianpeng
    ..i admType="O" d
    ...i $d(^DHCOEDISQTY(0,"OEORI",oeori)) d					// 医嘱打包表
    ....s dspRowId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    ....s totalQty=$p(^DHCOEDISQTY(dspRowId),",",2)
    ....s qtyUom=$p(^DHCOEDISQTY(dspRowId),",",6)
    ....s qtyUomDesc=""
    ....i qtyUom'="" s qtyUomDesc=$p(^CT("UOM",qtyUom),"^",2)
    ....s totalQty=totalQty_qtyUomDesc
	...
	..s phFreqDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",4)		// 频率
	..i phFreqDr'="" s phFreqDesc=$P(^PHCFR(phFreqDr),"^",3)   
 	..s instrDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",7) 		// 用法
 	..i instrDr'="" s instrDesc=$P(^PHCIN(instrDr),"^",3)    
 	..;疗程(需要根据查询日期进行计算)
    ..;s courseDr=$p($g(^OEORD(oeord,"I",oeordsub,2)),"^",6) 
    ..;i courseDr'="" s courseDesc=$p(^PHCDU(courseDr),"^",3)  
    ..s courseDesc="" //..GetCourse(oeord,oeordSub,stDate,endDate) 
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcdr,"||",1),""))  		// 库存项ID
	..s rmanf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) // 生产厂家
	..i rmanf["-" s rmanf=$p(rmanf,"-",2)
	..;s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 
	..s speciFaction=##class(web.DHCSTKUTIL).GetSpec(inci) 		// 规格

	..s groupFlag=""											// 成组符号
	..s seqFlag=..GetOISeqFlag(oeori) 							// 判断医嘱是否关联
	..s mainOeori=""  											// 关联医嘱
	..i seqFlag=1 d   
	...s oeoriStartDate=$p(^OEORD(oeord,"I",oeordSub,1),"^",9)  // 开始日期(要求开始执行)	
	...s groupFlag=oeord_oeordSub								// 成组符号
	...s num=num+1 
	...;s mainOeori=..GetMainOeori(oeori) 						// 取关联溶媒医嘱
	...s mainOeori=$p(^DHCPHMREC(mrRowId),"^",14) 
	...i mainOeori'="" d
	....s mainOeord=$p(mainOeori,"||",1)
	....s mainOeordSub=$p(mainOeori,"||",2)	
	....;取出关联溶媒医嘱的医嘱名 剂量 单位 生产厂家 生产规格(因为是关联医嘱，其他项比如用法等是相同的)
	....s mainArcDr=$p(^OEORD(mainOeord,"I",mainOeordSub,1),"^",2)
    ....s mainArcDesc=$p(^ARCIM(+mainArcDr,1,1),"^",2) 
	....s mainDoseQty=$p($g(^OEORD(mainOeord,"I",mainOeordSub,2)),"^",1)	// 单次剂量
	....s mainUnitDr=$p($g(^OEORD(mainOeord,"I",mainOeordSub,2)),"^",3)		// 单次剂量单位
    ....i mainUnitDr'="" s mainUnitDesc=$P(^CT("UOM",mainUnitDr),"^",2) 
    ....//数量  （门诊病人取）//2017/6/19 qunianpeng
    ....s mainTotalQty=""
    ....i $d(^DHCOEDISQTY(0,"OEORI",mainOeori)) d							// 医嘱打包表
    .....s mainDspRowId=$o(^DHCOEDISQTY(0,"OEORI",mainOeori,""))
    .....s mainTotalQty=$p(^DHCOEDISQTY(mainDspRowId),",",2)
    .....s mainQtyUom=$p(^DHCOEDISQTY(mainDspRowId),",",6)
    .....s mainQtyUomDesc=""
    .....s:mainQtyUom'="" mainQtyUomDesc=$p(^CT("UOM",mainQtyUom),"^",2)
    .....s mainTotalQty=mainTotalQty_mainQtyUomDesc
	.....
	....s:admType'="O" mainTotalQty=""
	....
	....;主医嘱生产厂家
	....s mainInci=$o(^INCI(0,"ARCIM_DR",$p(mainArcDr,"||",1),""))  		// 库存项ID
	....s mainRmanf=##class(web.DHCSTITMDESC).GetManfNameByInci(mainInci) 
	....i mainRmanf["-" s mainRmanf=$p(mainRmanf,"-",2)
	....;s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 
	....s mainSpeciFaction=##class(web.DHCSTKUTIL).GetSpec(mainInci) 		// 主医嘱规格
	...
	..
	..;诊断
	..;s patDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(adm,",") //主要诊断;=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")	 //2017/5/26 QuNianpeng
	..s patDiag="" //..getMRDiagnosDesc(adm)	//2017/6/12 QuNianpeng	
	..
	..;管理级别
	..s level=$p(^DHCPHMREC(mrRowId),"^",9)  
	..s levelDesc=$Select(level="C":"管制",level="W":"警示",level="S":"提示",1:"")
	..q:(levelMan'="")&(level'=levelMan)									// 根据级别查询
	..
	..;提示信息
	..s mrlSub=""
	..f  s mrlSub=$o(^DHCPHMREC(mrRowId,"Label",mrlSub)) q:mrlSub=""  d
	...s groupFlag=oeord_oeordSub											// 成组符号
	...s label=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",1)
	...q:(queryLabel'="")&(label'=queryLabel)	  							// 根据目录查询
	...s labelDesc=$p(^DHCPHPINL(label),"^",2)	
	...i '(labelDesc["溶媒") s groupFlag="" 		 						// 只有溶媒量查询 会取出关联医嘱信息和成组符号 2017/6/16
	...s errFlag=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",2)
	...q:(queryErrFlag'="")&(errFlag'=queryErrFlag) 						// 根据异常原因查询
	...
	...s errMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",3)
	...s trueMsg=$p(^DHCPHMREC(mrRowId,"Label",mrlSub),"^",4)
	...s:errMsg="" errMsg=trueMsg	//qnp 2017/6/8
	...s unitDesc=""
	...S tmpData=adm_"^"_patNo_"^"_patName_"^"_medicalNo_"^"_admLocDesc_"^"_oeoriDate_"^"_groupFlag_"^"_patDiag_"^"_arcDesc_"^"_doseQty_"^"_unitDesc_"^"_phFreqDesc_"^"_instrDesc
	...s tmpData=tmpData_"^"_courseDesc_"^"_rmanf_"^"_speciFaction_"^"_levelDesc_"^"_labelDesc_"^"_errFlag_"^"_errMsg_"^"_admDocDesc_"^"_totalQty
	...s ^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,oeoriDate_h_oeord_oeordSub)=tmpData
	...;d OutputBldBodInfo
	...s h=h+1
	...i (labelDesc["溶媒")&(seqFlag=1)&(mainOeori'="") d   				// 是关联医嘱时，取关联主医嘱信息(针对溶媒)
	....s tmpData=adm_"^"_patNo_"^"_patName_"^"_medicalNo_"^"_admLocDesc_"^"_oeoriDate_"^"_groupFlag_"^"_patDiag_"^"_mainArcDesc_"^"_mainDoseQty_"^"_mainUnitDesc_"^"_phFreqDesc_"^"_instrDesc
	....s tmpData=tmpData_"^"_courseDesc_"^"_mainRmanf_"^"_mainSpeciFaction_"^"_levelDesc_"^"_labelDesc_"^"_""_"^"_""_"^"_admDocDesc_"^"_mainTotalQty
	....s ^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,oeoriDate_h_oeord_oeordSub)=tmpData
	....s h=h+1
	....;d OutputBldBodInfo
	....
	...
	..;s ^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"adm",adm,oeori)=""	//标记长嘱是否已经查询显示过 2017/5/31 qnp 
	..s ^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,"mrRowId",mrRowId)=""
	.
	
	d ..PrintOeorInfo(pid)
	s qHandle=$lb(0,repid,0)	
	q $$$OK
}

Query GetLibOidItemExp(params As %String) As websys.Query(ROWSPEC = "adm:%String,patNo:%String,patName:%String,medicalNo:%String,admLocDesc:%String,oeoriDate:%String,groupFlag:%String,patDiag:%String,arcDesc:%String,doseQty:%String,unitDesc:%String,phFreqDesc:%String,instrDesc:%String,courseDesc:%String,rmanf:%String,speciFaction:%String,levelDesc:%String,labelDesc:%String,errFlag:%String,errMsg:%String,admDocDesc:%String,totalQty:%String") [ SqlProc ]
{
}

/// Description:	查询知识库医嘱数据(打印)query输出
/// Creator:		QuNianpeng
/// CreateDate:		2017-5-26
/// Input:			
/// return:			
/// other:
ClassMethod PrintOeorInfo(pid As %String) As %String
{
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid,index))
	.s adm=$p(mdata,"^",1)
	.s patNo=$p(mdata,"^",2)
	.s patName=$p(mdata,"^",3)
	.s medicalNo=$p(mdata,"^",4)
	.s admLocDesc=$p(mdata,"^",5)
	.s oeoriDate=$p(mdata,"^",6)
	.s groupFlag=$p(mdata,"^",7)
	.s patDiag=$p(mdata,"^",8)
	.s arcDesc=$p(mdata,"^",9)
	.s doseQty=$p(mdata,"^",10)
	.s unitDesc=$p(mdata,"^",11)
	.s phFreqDesc=$p(mdata,"^",12)
	.s instrDesc=$p(mdata,"^",13)
	.s courseDesc=$p(mdata,"^",14)
	.s rmanf=$p(mdata,"^",15)
	.s speciFaction=$p(mdata,"^",16)
	.s levelDesc=$p(mdata,"^",17)
	.s labelDesc=$p(mdata,"^",18)
	.s errFlag=$p(mdata,"^",19)
	.s errMsg=$p(mdata,"^",20)
	.s admDocDesc=$p(mdata,"^",21)
	.s totalQty=$p(mdata,"^",22)
	.d outPutOeorMRInfo
	.
	
	k ^TMP("DHCPH","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid)
	
outPutOeorMRInfo
	s data=$lb(adm,patNo,patName,medicalNo,admLocDesc,oeoriDate,groupFlag,patDiag,arcDesc,doseQty,unitDesc,phFreqDesc,instrDesc,courseDesc,rmanf,speciFaction,levelDesc,labelDesc,errFlag,errMsg,admDocDesc,totalQty)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
}

/// Description:	自动滚监测任务 长医嘱未停，则在监测日期子表中插入一条时间记录
/// Creator:		QuNianpeng
/// CreateDate:		2017-6-14
/// Input:			
/// return:			
/// other:			w ##class(web.DHCSTPHCMORDDATA).AutoExecuteMonitor()
ClassMethod AutoExecuteMonitor() As %String
{
	s date=$p($h-1,",",1)
	s ret=0
    s mrRowId=""
    f  s mrRowId=$o(^DHCPHMREC(mrRowId))  q:(mrRowId="")  d
    .q:mrRowId=0
    .s oeori=$p(^DHCPHMREC(mrRowId),"^",2)
    .q:oeori=""
    .s oeord=$p(oeori,"||",1)
    .s sub=$p(oeori,"||",2)
    .//医嘱优先级
    .s priorityDr=$p(^OEORD(oeord,"I",sub,1),"^",8)
    .s priorityCode=$p(^OECPR(priorityDr),"^",1)
    .q:priorityCode'="S"      //监测任务自动执行，只针对长嘱
    .//医嘱状态
    .s statusDr=$p(^OEORD(oeord,"I",sub,1),"^",13)
    .s statusCode=$p(^OEC("OSTAT",statusDr),"^",1)
    .q:statusCode="D"	//医嘱停止，则不继续监测    
    .q:'$d(^OEORDi(0,"OrdItem",oeord,sub,date))  //当日未执行医嘱  退出
 	.//判断医嘱是否被执行
 	.s exFlag=0
 	.s oeorExcSub=""
 	.f  s oeorExcSub=$o(^OEORDi(0,"OrdItem",oeord,sub,date,oeorExcSub)) q:oeorExcSub=""  d
    ..s exStatus=$p(^OEORD(oeord,"I",sub,"X",oeorExcSub),"^",16) //医嘱执行表OE_OrdExec 
    ..s exStatusCode=""
    ..s:(exStatus'="") exStatusCode=$p(^OEC("STAT",exStatus),"^",1)    
    ..i exStatusCode="F" s exFlag=1	//已经执行
    .
	.//若该条医嘱监测过,且是长嘱未停止,则只插入一个新日期
	.i '$d(^DHCPHMREC(0,"ExDate",date,mrRowId))&(exFlag=1) d 	
    ..d ..SaveMRitemDate(mrRowId,date)
    ..s ret=1
	.
	
	q ret
}

/// Description:	通过医嘱id获取医嘱相关信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
/// Input:			医嘱id
/// return:			单次剂量,单次剂量单位,数量,频率,用法,疗程,生产厂家,规格
/// other:
ClassMethod GetOrdItmInfo(oeori) As %String
{
	n (oeori)
	q:oeori="" ""
	s oeord=$p(oeori,"||",1)
	s oeordSub=$p(oeori,"||",2)
	s arci=$p(^OEORD(oeord,"I",oeordSub,1),"^",2) 
	
	s doseQty=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",1)	// 单次剂量
	s unitDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",3) 	// 单次剂量单位
	i unitDr'="" s unitDesc=$P(^CT("UOM",unitDr),"^",2) 
	s totalQty=""											// 数量 
    i $d(^DHCOEDISQTY(0,"OEORI",oeori)) d					// 医嘱打包表
    .s dspRowId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    .s totalQty=$p(^DHCOEDISQTY(dspRowId),"^",2)
    .s qtyUom=$p(^DHCOEDISQTY(dspRowId),"^",6)
    .s qtyUomDesc=""
    .i qtyUom'="" s qtyUomDesc=$p(^CT("UOM",qtyUom),"^",2)
    .s totalQty=totalQty_qtyUomDesc

	s phFreqDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",4)	// 频率
	i phFreqDr'="" s phFreqDesc=$P(^PHCFR(phFreqDr),"^",3)   
 	s instrDr=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",7)	// 用法
 	i instrDr'="" s instrDesc=$P(^PHCIN(instrDr),"^",2)  
    s courseDesc="" //..GetCourse(oeord,oeordSub,stDate,endDate)	// 疗程 
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arci,"||",1),""))  		// 库存项ID
	s rmanf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 
	i rmanf["-" s rmanf=$p(rmanf,"-",2)						// 生产厂家
	s speciFaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	// 规格
	
	q doseQty_"^"_$g(unitDesc)_"^"_totalQty_"^"_$g(phFreqDesc)_"^"_$g(instrDesc)_"^"_rmanf_"^"_speciFaction
}

/// Description:	获取异常医嘱的异常目录和级别
/// Creator:		QuNianpeng
/// CreateDate:		2017-6-15
/// Input:			医嘱ID串
/// return:			单次剂量,单次剂量单位,数量,频率,用法,疗程,生产厂家,规格
/// other:			w ##class(web.DHCSTPHCMORDDATA).GetLibErrType("1290||2")
ClassMethod GetLibErrTypeNotAlone(oeoriStr As %String) As %String
{
	n (oeoriStr)
	s lenth=$l(oeoriStr,"^")
	s retMsg=""
	f len=1:1:lenth d
	.s oeori=$p(oeoriStr,"^",lenth)
	.//判断医嘱是否存在
	.q:'$d(^DHCPHMREC(0,"Oeori",oeori))
	.//获取监测表ID
	.s mrRowId=$o(^DHCPHMREC(0,"Oeori",oeori,""))
	.//获取异常目录和级别
	.s level=$p(^DHCPHMREC(mrRowId),"^",9)	//管理级别
	.s retLabelStr=""
	.s labelSub=""
	.f  s labelSub=$o(^DHCPHMREC(mrRowId,"Label",labelSub)) q:labelSub=""  d
	..s labelDr=$p(^DHCPHMREC(mrRowId,"Label",labelSub),"^",1)
	..s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)
	..s labelDesc=labelDesc_"问题"
	..//问题目录拼串
	..i retLabelStr=""  d
	...s retLabelStr=labelDesc
	..e  d
	...s retLabelStr=retLabelStr_"&"_labelDesc
	..
	.//返回信息拼串
	.i retMsg="" d 
	..s retMsg=oeori_"@"_level_"^"_retLabelStr
	.e  d
	..s retMsg=retMsg_"!"_oeori_"@"_level_"^"_retLabelStr
	.

	q retMsg
}

/// Description:	获取异常医嘱的异常目录和级别
/// Creator:		QuNianpeng
/// CreateDate:		2017-6-15
/// Input:			医嘱ID
/// return:			单次剂量,单次剂量单位,数量,频率,用法,疗程,生产厂家,规格
/// other:			w ##class(web.DHCSTPHCMORDDATA).GetLibErrType("1290||2")
ClassMethod GetLibErrType(oeori As %String) As %String
{
	n (oeori)
	s retMsg=""
	//判断医嘱是否存在
	q:'$d(^DHCPHMREC(0,"Oeori",oeori)) -100
	//获取监测表ID
	s mrRowId=$o(^DHCPHMREC(0,"Oeori",oeori,""))
	//获取异常目录和级别
	s level=$p(^DHCPHMREC(mrRowId),"^",9)	//管理级别
	s level=$select(level="W":"警示",level="S":"提示",level="C":"管制")
	s retLabelStr=""
	s labelSub=""
	f  s labelSub=$o(^DHCPHMREC(mrRowId,"Label",labelSub)) q:labelSub=""  d
	.s labelDr=$p(^DHCPHMREC(mrRowId,"Label",labelSub),"^",1)
	.s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)
	.s labelDesc=labelDesc_"问题"
	.//问题目录拼串
	.i retLabelStr=""  d
	..s retLabelStr=labelDesc
	.e  d
	..;s retLabelStr=retLabelStr_"&"_labelDesc
	..s retLabelStr=retLabelStr_" "_labelDesc
	.
	//返回信息拼串
	;s retMsg=level_"^"_retLabelStr
	s retMsg=level_" "_retLabelStr
	
	q retMsg
}

/// Description:	存储医嘱的执行日期
/// Creator:		QuNianpeng
/// CreateDate:		2017-04-01
/// Input:			医嘱监控主表ID,执行日期
/// return:		
/// other：			存在执行日期的作用：一条异常长嘱只在监控记录表存一次.查询时,若时间大于医嘱的开始日期,则这条医嘱被漏查。存储执行日期,则长嘱相当于每天被记录一次
/// w ##class(web.DHCSTPHCMORDDATA).SaveMRitemDate()
ClassMethod SaveMRitemDate(phmrRowId, exDate) As %String
{
	n (phmrRowId, exDate)

	q:(phmrRowId="")||(phmrRowId=0) 0
	s PLIST(0)=phmrRowId
	s PLIST(2)=+$o(^DHCPHMREC(phmrRowId,"I",""),-1)+1
	s PLIST(3)=exDate
	ts
	&sql(INSERT INTO DHC_PHMonitorRecItm VALUES :PLIST())	
	i SQLCODE'=0  tro  Q SQLCODE
	tc
	Q +%ROWID
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("DHCSTPHCMORDDATA"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrditemNew",pid)
	k ^TMP("DHCST","web.DHCSTPHCMORDDATA","QueryLibOrdDataNew",pid)
}

}
