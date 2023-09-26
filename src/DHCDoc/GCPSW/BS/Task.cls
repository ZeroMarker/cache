/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 任务
Class DHCDoc.GCPSW.BS.Task Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-04-27
/// DESC: 是否为空项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).IsBlankPrj()
ClassMethod IsBlankPrj(ByRef kpiobj)
{
	s mRtn=0
	//先手动判断，不循环后台配置，之后优化
	s IsPersonBlank=1
	i kpiobj.sex'="" s IsPersonBlank=0
	i kpiobj.age'="" s IsPersonBlank=0
	i kpiobj.height'="" s IsPersonBlank=0
	i kpiobj.weight'="" s IsPersonBlank=0
	i kpiobj.BMI'="" s IsPersonBlank=0
	
	s IsDiagBlank=1
	i kpiobj.OutDiag'="" s IsDiagBlank=0
	i kpiobj.InDiag'="" s IsDiagBlank=0
	
	s IsLisBlank=1
	i kpiobj.InLis'="" s IsLisBlank=0
	i kpiobj.OutLis'="" s IsLisBlank=0
	
	i ((IsPersonBlank=1)&&(IsDiagBlank=1)&&(IsLisBlank=1)) s mRtn=1
	//b ;0033
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 自动/手工生成数据
/// IN  : InPID(重做哪个项目的数据), ReLoad(是否强制重新生成，只有在任务失败的情况下，才需要用到)
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData(2,1,1)
ClassMethod CreateData(InPID As %String = "", ReLoad = "", AllFlag = "")
{
	s CDate=+$h
	k ^BS.DOC.GCPSW.Temp($j)
	s PID=""
	f  s PID=$O(^CF.DOC.GCPSW.PrjD(PID)) Q:PID=""  d
	.q:(InPID'="")&&(PID'=InPID)
	.s startDate=$P(^CF.DOC.GCPSW.PrjD(PID),"^",3)
	.s endDate=$P(^CF.DOC.GCPSW.PrjD(PID),"^",4)
	.s gcp=$P(^CF.DOC.GCPSW.PrjD(PID),"^",5)
	.q:(endDate<startDate)||(startDate="")||(endDate="")||(gcp="")	//||(endDate<CDate)
	.i endDate>CDate s endDate=CDate
	.s logInfo=..FilterLog(PID,ReLoad,AllFlag)
	.s exit=$p(logInfo,"^",1)
	.s taskSDate=$p(logInfo,"^",2)
	.q:exit=1
	.i taskSDate'="" s startDate=taskSDate
	.q:endDate<startDate
	.;QP 固定测试日期
	.;s startDate=65067
	.;s endDate=startDate+3
	.;
	.s kpiobj=##class(DHCDoc.GCPSW.Model.BSKPI).GetInfo(PID)
	.;判断是否为空项目
	.s isBlakPrj=..IsBlankPrj(kpiobj)
	.q:isBlakPrj=1
	.s entry=..GetEntry(.kpiobj)
	.q:entry=""
	.k ^BS.DOC.GCPSW.Temp($j)
	.; 记录滚动日志表
	.s LID=##class(DHCDoc.GCPSW.BS.TaskLog).Save(PID,"","Task")
	.;获取各类数据
	.f date=startDate:1:endDate d
	..i entry="Person" d	;个人基本信息
	...d ..GetPersonData(date,.kpiobj,PID)
	..i entry["Diag" d		;诊断
	...d ..GetDiagData(date,.kpiobj,PID)
	..i entry["Lis" d		;检验
	...d ..GetLisData(date,.kpiobj,PID)
	.;汇总数据
	.d ..SummaryData()	;
	.;存储数据
	.;b ;storage
	.d ..StorageData()
	.;记录日志表完成日期
	.d ##class(DHCDoc.GCPSW.BS.TaskLog).Save(PID,LID)
	
	k ^BS.DOC.GCPSW.Temp($j)
	
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 得到个人基本信息数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetPersonData(date, ByRef kpiobj, PID)
{
	s admid=""
	f  s admid=$o(^PAADMi("PAADM_AdmDate",date,admid)) q:admid=""  d
	.s PatientID=$P(^PAADM(admid),"^",1)
	.s isExit=..FliterPerson(admid,PatientID,kpiobj)
	.q:isExit=1
	.s ^BS.DOC.GCPSW.Temp($j,"Save",PatientID)=PID
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-10-12
/// DESC: 得到诊断数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetDiagData(date, ByRef kpiobj, PID)
{
	s admid=""
	f  s admid=$o(^PAADMi("PAADM_AdmDate",date,admid)) q:admid=""  d
	.s PatientID=$P(^PAADM(admid),"^",1)
	.s isExit=..FliterPerson(admid,PatientID,kpiobj)
	.q:isExit=1
	.s mradm=$p(^PAADM(admid),"^",61)
	.q:mradm=""
	.q:'$d(^MR(mradm,"DIA"))
	.s hasItem=$o(^MR(mradm,"DIA",0))
	.q:hasItem=""
	.d ..GetDiagDataByMRAdm(mradm,admid,kpiobj,PID)
	
	w "GetDiagData--ok"
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 得到诊断数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetDiagDataByMRAdm(mradm, admid, ByRef kpiobj, PID)
{
	Q:(mradm="")||(admid="") 0
	
	s PatientID=$P($g(^PAADM(admid)),"^",1)
	q:PatientID="" 0
	s hasOut=..HasOut(PatientID,"Diag")
	q:hasOut=1 0
	s isExit=..FliterPerson(admid,PatientID,kpiobj)
	q:isExit=1 0
	
	s isExit=0
	s sub=0
	f  s sub=$o(^MR(mradm,"DIA",sub)) q:(sub="")||(isExit=1)  d
	.s diagDesc=""
	.s noicdDiagDesc=$g(^MR(mradm,"DIA",sub,"DES",1))
	.s icdDr=$p($G(^MR(mradm,"DIA",sub)),"^",1)
	.s mrdate=$p($G(^MR(mradm,"DIA",sub)),"^",7)
	.s isExit=0
	.i icdDr'="" d
	..s isExit=..FliterDiag(icdDr,kpiobj.InDiag,kpiobj.OutDiag,"ICD",PatientID,PID)
	.e  d 
	..i noicdDiagDesc'="" d
	...s isExit=..FliterDiag(noicdDiagDesc,kpiobj.InDiag,kpiobj.OutDiag,"NOICD",PatientID,PID)
	.q:isExit=1
	q:isExit=1 0
	
	s ^BS.DOC.GCPSW.Temp($j,"DiagIn",PatientID)=PID

	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 得到诊断数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetDiagData2(date, ByRef kpiobj, PID)
{
	Q 0
	
	s mradm=0
	f  s mradm=$o(^MR(mradm)) q:mradm=""  d
	.s admid=$p(^MR(mradm,"PRO",1),"^",9)
	.q:admid=""
	.s sub=""
	.s PatientID=$P($g(^PAADM(admid)),"^",1)
	.q:PatientID=""
	.s hasOut=..HasOut(PatientID,"Diag")
	.q:hasOut=1
	.s isExit=..FliterPerson(admid,PatientID,kpiobj)
	.q:isExit=1
	.s isExit=0
	.f  s sub=$o(^MR(mradm,"DIA",sub)) q:(sub="")||(isExit=1)  d
	..s diagDesc=""
	..s noicdDiagDesc=$g(^MR(mradm,"DIA",sub,"DES",1))
	..s icdDr=$p($G(^MR(mradm,"DIA",sub)),"^",1)
	..s mrdate=$p($G(^MR(mradm,"DIA",sub)),"^",7)
	..q:mrdate'=date
	..s isExit=0
	..i icdDr'="" s isExit=..FliterDiag(icdDr,kpiobj.InDiag,kpiobj.OutDiag,"ICD",PatientID,PID)
	..e  d 
	...i noicdDiagDesc'="" d
	....s isExit=..FliterDiag(noicdDiagDesc,kpiobj.InDiag,kpiobj.OutDiag,"NOICD",PatientID,PID)
	..q:isExit=1
	.q:isExit=1
	
	.s ^BS.DOC.GCPSW.Temp($j,"DiagIn",PatientID)=PID
	
	
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 得到诊断数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetDiagDataOld(date, ByRef kpiobj, PID)
{
	//悲剧，协和无诊断日期索引
	s mradm=""
	f  s mradm=$o(^MRi("Date",date,mradm)) q:mradm=""  d
	.s sub=""
	.s PatientID=$P($g(^PAADM(admid)),"^",1)
	.q:PatientID=""
	.s hasOut=..HasOut(PatientID,"Diag")
	.q:hasOut=1
	.s isExit=..FliterPerson(admid,PatientID,kpiobj)
	.q:isExit=1
	.s isExit=0
	.f  s sub=$o(^MRi("Date",date,admid,sub)) q:(sub="")||(isExit=1)  d
	..s diagDesc=""
	..s noicdDiagDesc=$g(^MR(admid,"DIA",sub,"DES",1))
	..s icdDr=$p($G(^MR(admid,"DIA",sub)),"^",1)
	..;q:(icdDr="")&&(noicdDiagDesc="")
	..;s diagDesc=$p(^MRC("ID",icdDr),"^",2)
	..s isExit=0
	..i icdDr'="" s isExit=..FliterDiag(icdDr,kpiobj.InDiag,kpiobj.OutDiag,"ICD",PatientID,PID)
	..e  d 
	...i noicdDiagDesc'="" d
	....s isExit=..FliterDiag(noicdDiagDesc,kpiobj.InDiag,kpiobj.OutDiag,"NOICD",PatientID,PID)
	..q:isExit=1
	.q:isExit=1
	
	.s sex=$p(^PAPER(PatientID,"ALL"),"^",7)
	.s ^BS.DOC.GCPSW.Temp($j,"DiagIn",PatientID)=PID
	
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 得到检查数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetLisData("")
ClassMethod GetLisData(date, ByRef kpiobj, PID)
{
	d ..CreateLisDataOneDay(kpiobj,date,date,PID)
	//b ;CreateLisDataOneDay OK! 
	d ..ForEachLisData(kpiobj,PID)
	;B ;"GetLisData....OK",!
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 汇总检验数据，做加减法，得到最终的入选检验的数据，并写进指定的Global
/// IN  : 
/// OUT :  ^BS.DOC.GCPSW.Temp($j,"Lis",PatientID)= LisIn - LisOut
ClassMethod SummaryLisData()
{
	//^BS.DOC.GCPSW.Temp($j,"LisPatOrder",PatientID,oeori)=PID
	Q:'$d(^BS.DOC.GCPSW.Temp($j,"LisIn")) 0
	s id=""
	f  s id=$o(^BS.DOC.GCPSW.Temp($j,"LisIn",id)) q:id=""  d
	.s PID=$g(^BS.DOC.GCPSW.Temp($j,"LisIn",id))
	.i '$d(^BS.DOC.GCPSW.Temp($j,"LisOut",id)) d
	..s ^BS.DOC.GCPSW.Temp($j,"Lis",id)=PID
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 汇总诊断数据，做加减法，得到最终的入选诊断的数据，并写进指定的Global
/// IN  : 
/// OUT :  ^BS.DOC.GCPSW.Temp($j,"Diag",PatientID)= DiagIn - DiagOut
ClassMethod SummaryDiagData()
{
	Q:'$d(^BS.DOC.GCPSW.Temp($j,"DiagIn")) 0
	s id=""
	f  s id=$o(^BS.DOC.GCPSW.Temp($j,"DiagIn",id)) q:id=""  d
	.s PID=$g(^BS.DOC.GCPSW.Temp($j,"DiagIn",id))
	.i '$d(^BS.DOC.GCPSW.Temp($j,"DiagOut",id)) d
	..s ^BS.DOC.GCPSW.Temp($j,"Diag",id)=PID
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 遍历检验Global数据，并根据过滤条件，写进指定的Glboal
/// IN  : 
/// OUT :  ^BS.DOC.GCPSW.Temp($j,"LisOut",PatientID)=PID   //排除
///        ^BS.DOC.GCPSW.Temp($j,"LisIn",PatientID)=PID    //入选
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetLisData("")
ClassMethod ForEachLisData(ByRef kpiobj, PID)
{
	s PatientID=""
	f  s PatientID=$O(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID)) Q:PatientID=""  d
	.s mRtn=..FliterLis(kpiobj,PID,PatientID)
	.;i PatientID="1656959" b ;0000ForEachLisData
	.i mRtn=0 s ^BS.DOC.GCPSW.Temp($j,"LisIn",PatientID)=PID
	.e  s ^BS.DOC.GCPSW.Temp($j,"LisOut",PatientID)=PID
	
	
	Q 0
	/*
	
	
	.s arcim=""
	
	.f  s arcim=$O(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim)) Q:arcim=""  d
	..s num=""
	..f  s num=$O(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim,num)) Q:num=""  d
	...s rec=$g(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim,num))
	*/
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 得到所查日期的检查数据,并按照指定的格式写进Global
/// IN  : 
/// OUT : ^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,InArcim,num,itemCode) 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetLisData("")
ClassMethod CreateLisDataOneDay(ByRef kpiobj, sdate, edate, PID)
{
	k ^BS.DOC.GCPSW.Temp($j,"LisPat")
	Q:(sdate="")||(edate="")||(PID="") 0
	s sdate=$zd(sdate,3)
	s edate=$zd(edate,3)
	;OrdRowID,OrdName,项目代码,项目名称,缩写,结果,单位,标志,参考范围
	
	s rset=##Class(%ResultSet).%New("LabService.TSResult:QryTCResultByAuthDate")
	i rset.QueryIsValid() { 
		s Status=rset.Execute(sdate,edate)
		i 'Status Quit 0
		While (rset.Next()) {
			s oeori=rset.GetDataByName("OrdName")
			continue:oeori=""
			s ord=+oeori,ch=$p(oeori,"||",2)
			s InArcim=$p(^OEORD(ord,"I",ch,1),"^",2)
			continue:InArcim=""
		    s itemCode=rset.GetDataByName("TCCode")
		    s itemVal=rset.GetDataByName("Result")
			s admid=$p(^OEORD(+oeori),"^",1)
			s PatientID=$P(^PAADM(admid),"^",1)
			//i (PatientID="1656959")&&(itemCode="D6001") w oeori_": "_admid_": "_itemCode_"^"_itemVal,!
			//continue:PatientID'=1656959	//26544800
			//W oeori_": "_admid_": "_itemCode_"^"_itemVal,!
			s hasOut=..HasOut(PatientID,"Lis")
			continue:hasOut=1	
			s isExit=..FliterPerson(admid,PatientID,kpiobj)
			continue:isExit=1
			s ^BS.DOC.GCPSW.Temp($j,"LisPatOrder",PatientID,oeori)=PID
			i '$d(^BS.DOC.GCPSW.Temp($j,"LisPat","oeori",oeori)) {
				s ^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","num",PatientID,InArcim)=$g(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","num",PatientID,InArcim))+1
				s num=$g(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","num",PatientID,InArcim))
				s ^BS.DOC.GCPSW.Temp($j,"LisPat","oeori",oeori)=num
				s ^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,InArcim,num,itemCode)=PID_"^"_itemVal_"^"_oeori_"^"_admid
				
			} else {
				s num=$g(^BS.DOC.GCPSW.Temp($j,"LisPat","oeori",oeori))
				s ^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,InArcim,num,itemCode)=PID_"^"_itemVal_"^"_oeori_"^"_admid
			}
		}
		d rset.Close()
	}
	;B ;0012
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 汇总数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).SummaryData("")
ClassMethod SummaryData()
{
	d ..SummaryLisData()
	d ..SummaryDiagData()
	
	i $d(^BS.DOC.GCPSW.Temp($j,"Diag")) {
		i $d(^BS.DOC.GCPSW.Temp($j,"Lis")) {
			s id=""
			f  s id=$o(^BS.DOC.GCPSW.Temp($j,"Diag",id)) q:id=""  d
			.q:'$d(^BS.DOC.GCPSW.Temp($j,"Lis",id))
			.s ^BS.DOC.GCPSW.Temp($j,"Save",id)=$g(^BS.DOC.GCPSW.Temp($j,"Diag",id))
		} else {
			s id=""
			f  s id=$o(^BS.DOC.GCPSW.Temp($j,"Diag",id)) q:id=""  d
			.s ^BS.DOC.GCPSW.Temp($j,"Save",id)=$g(^BS.DOC.GCPSW.Temp($j,"Diag",id))
		}
	} elseif ($d(^BS.DOC.GCPSW.Temp($j,"Lis"))) {
		s id=""
		f  s id=$o(^BS.DOC.GCPSW.Temp($j,"Lis",id)) q:id=""  d
		.s ^BS.DOC.GCPSW.Temp($j,"Save",id)=$g(^BS.DOC.GCPSW.Temp($j,"Lis",id))
		
	} else {
		//todo	
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 存储数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).StorageData("")
ClassMethod StorageData()
{
	q:'$d(^BS.DOC.GCPSW.Temp($j,"Save")) 0
	
	s result=0
	s id=""
	f  s id=$o(^BS.DOC.GCPSW.Temp($j,"Save",id)) q:(id="")||(result<0)  d
	.s PID=$g(^BS.DOC.GCPSW.Temp($j,"Save",id))
	.s mList=id_"^"_PID
	.s RID=##class(DHCDoc.GCPSW.BS.Result).Save(mList)
	.i $d(^BS.DOC.GCPSW.Temp($j,"LisPatOrder",id)) d
	..q:RID<=0
	..s result=..StorageAdmData(RID,id,PID)
	..s result=..StorageLisData(RID,id,PID)
	Q result
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 存储数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).StorageData("")
ClassMethod StorageAdmData(RID, PatientID, PID)
{
	s oeori=""
	f  s oeori=$o(^BS.DOC.GCPSW.Temp($j,"LisPatOrder",PatientID,oeori)) q:oeori=""  d
	.s ord=+oeori,ch=$p(oeori,"||",2)
	.s InArcim=$p(^OEORD(ord,"I",ch,1),"^",2)
	.s admid=$p(^OEORD(+oeori),"^",1)
	.s mList=PatientID_"^"_admid_"^"_oeori_"^"_InArcim
	.s mRtn=##class(DHCDoc.GCPSW.BS.ResultAdm).Save(RID,mList)
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-03-04
/// DESC: 存储Lis数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).StorageData("")
ClassMethod StorageLisData(RID, PatientID, PID)
{
	s code=""
	f  s code=$o(^BS.DOC.GCPSW.Temp($j,"LisPatItem",PatientID,code)) q:code=""  d
	.s rec=$g(^BS.DOC.GCPSW.Temp($j,"LisPatItem",PatientID,code))
	.s oeori=$P(rec,"^",3)
	.s itemVal=$P(rec,"^",2)
	.s ord=+oeori,ch=$p(oeori,"||",2)
	.s InArcim=$p(^OEORD(ord,"I",ch,1),"^",2)
	.s admid=$p(^OEORD(+oeori),"^",1)
	.s mList=oeori_"^"_code_"^"_itemVal_"^"_InArcim
	.s mRtn=##class(DHCDoc.GCPSW.BS.ResultLis).Save(RID,mList)
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 得到入口类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod GetEntry(ByRef kpiobj)
{
	s mRtn=""
	i (kpiobj.InLis="")&&(kpiobj.OutLis="")&&(kpiobj.InDiag="")&&(kpiobj.OutDiag="") {
		Q "Person"	
	} 
	i (kpiobj.InDiag'="")||(kpiobj.OutDiag'="") {
		s mRtn="Diag"	
	}
	i (kpiobj.InLis'="")||(kpiobj.OutLis'="") {
		i mRtn="" s mRtn="Lis"	
		e  s mRtn=mRtn_",Lis"
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 过滤检验信息
/// IN  : 
/// OUT : 1退出，0不退出
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).FliterLis(.kpiobj,32,1656959)
ClassMethod FliterLis(ByRef kpiobj, PID, PatientID)
{
	s mRtn=0
	
	k InLisArr,OutLisArr
	
	//InLisVal = "3||1#s-WhiteCell^1!e-WhiteCell^2!Hemochrome^2!Platelet^3/3||2#TE^12"
	// 3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
	//增加了匹配模式 3||1#D6001^阴性^LIKE
	//解析
	//s kpiobj=##class(DHCDoc.GCPSW.Model.BSKPI).GetInfo(32)
	i kpiobj.InLisVal'="" {
		s InLis=kpiobj.InLisVal
		d ..GetLisArr(InLis,.InLisArr)
	}
	
	i kpiobj.OutLisVal'="" {
		s OutLis=kpiobj.OutLisVal
		d ..GetLisArr(OutLis,.OutLisArr)
	}
	;w InLisArr
	;w ArrOutLis
	//排除
	//目前排除是或者的关系
	s OutFlag=0
	s InArcim=""
	f  s InArcim=$o(OutLisArr(InArcim)) Q:(InArcim="")||(OutFlag=1)  d
	.Q:'$d(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,InArcim)) 
	.i $o(OutLisArr(InArcim,""))="" d
	..s OutFlag=1	;在排除内，并且没有子项了，则需要退出
	..s ^BS.DOC.GCPSW.Temp($j,"LisOut",PatientID)=PID
	.Q:OutFlag=1
	.s ITID=$g(OutLisArr(InArcim))
	.s code=""
	.f  s code=$o(OutLisArr(InArcim,code)) q:(code="")||(OutFlag=1)  d
	..s val=$p($g(OutLisArr(InArcim,code)),"^",1)
	..s rule=$p($g(OutLisArr(InArcim,code)),"^",2)
	..;只要有一个条件满足,就符合退出的过滤条件了
	..s OutFlag=..HasItemCode(PatientID,InArcim,code,val,.OutLisArr,rule)
	..i OutFlag=1 s ^BS.DOC.GCPSW.Temp($j,"LisOut",PatientID)=PID
	
	Q:OutFlag=1 1
	
	;入选
	s OutFlag=0,tempFlag=""
	s InArcim=""
	f  s InArcim=$o(InLisArr(InArcim)) Q:(InArcim="")||(OutFlag=1)  d
	.Q:'$d(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,InArcim)) 
	.Q:$o(InLisArr(InArcim,""))=""	;
	.i $o(InLisArr(InArcim,""))="" d
	..s OutFlag=1	;在入选内，并且没有子项了，则退出，已经入选了
	..s ^BS.DOC.GCPSW.Temp($j,"LisIn",PatientID)=PID
	.Q:OutFlag=1
	.s ITID=$g(InLisArr(InArcim))
	.s tempFlag=0
	.s code=""
	.f  s code=$o(InLisArr(InArcim,code)) q:(code="")||(tempFlag=1)  d
	..s val=$p($g(InLisArr(InArcim,code)),"^",1)
	..s rule=$p($g(InLisArr(InArcim,code)),"^",2)
	..;只要有一个条件满足,就入选，取得是或关系
	..s tempFlag=..HasItemCode(PatientID,InArcim,code,val,.InLisArr,rule,PID)
	..i tempFlag=1  s ^BS.DOC.GCPSW.Temp($j,"LisIn",PatientID)=PID
	
	//i PatientID="1656959" b ;009888
	
	i tempFlag=1 s mRtn=0						;符合入选标准，不退出
	e  i (OutFlag=1)&&(tempFlag="") s mRtn=0	;符合入选标准，不退出
	e  s mRtn=1									;不符合入选标注，退出
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 子项是否满足
///       如果指标是区间的，则必然是数字类型的，无需判断
/// IN  : 
/// OUT : 1满足，0不满足
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod HasItemCode(PatientID, arcim, code, val, ByRef mList, rule = "", PID = "")
{
	s mRtn=0
	//PID_"^"_itemVal_"^"_oeori_"^"_admid
	s InSVal=$p(val,",",1)
	s InEVal=$p(val,",",2)
	s codeNew=code
	i code["-" s codeNew=$p(code,"-",2)
	s num="",rec=""
	f  s num=$O(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim,num)) Q:(num="")||(mRtn=1)  d
	.q:'$d(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim,num,codeNew))
	.s rec=$g(^BS.DOC.GCPSW.Temp($j,"LisPat","arcim","data",PatientID,arcim,num,codeNew))
	.s cVal=$p(rec,"^",2)
	.i code["s-" d
	..s codeEnd="e-"_codeNew
	..s endVal=$g(mList(arcim,codeEnd))
	..i cVal>=InSVal d
	...i endVal="" s mRtn=1
	...e  i cVal<=InEVal  s mRtn=1
	.e  i code["e-" d
	..s codeS="s-"_codeNew
	..s sVal=$g(mList(arcim,codeS))
	..i cVal<=InEVal d
	...i sVal="" s mRtn=1
	...e  i cVal>=InSVal  s mRtn=1
	.e  d
	..i rule="LIKE" d
	...i cVal[val  s mRtn=1
	..e  d
	...i cVal=val s mRtn=1
	
	i mRtn=1 {
		//^BS.DOC.GCPSW.Temp($j,"LisPatOrder",PatientID,oeori)
		//rec的格式为：PID_"^"_itemVal_"^"_oeori_"^"_admid
		s ^BS.DOC.GCPSW.Temp($j,"LisPatItem",PatientID,codeNew)=rec	
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 过滤诊断信息
/// IN  : 
/// OUT : 1退出，0不退出
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod FliterDiag(icd, InDiag, OutDiag, type = "ICD", PatientID, PID)
{
	Q:(InDiag="")&&(OutDiag="") 0
	
	;排除诊断
	s findFlag=0
	i OutDiag'="" {
		f i=1:1:$l(OutDiag,",") {
			Q:findFlag=1
			s CDiag=$p(OutDiag,",",i)
			continue:('$d(^MRC("ID",CDiag)))&&(type="ICD")
			continue:($d(^MRC("ID",CDiag)))&&(type="NOICD")
			i CDiag=icd {
				s findFlag=1
			}
		}
	}
	i findFlag=1 s ^BS.DOC.GCPSW.Temp($j,"DiagOut",PatientID)=PID 
	Q:findFlag=1 findFlag
	Q:InDiag="" 0	//当只存在排除诊断，直接退出
	;入选诊断
	s findFlag=1
	i InDiag'="" {
		f i=1:1:$l(InDiag,",") {
			Q:findFlag=0
			s CDiag=$p(InDiag,",",i)
			;continue:'$d(^MRC("ID",CDiag))
			continue:('$d(^MRC("ID",CDiag)))&&(type="ICD")
			continue:($d(^MRC("ID",CDiag)))&&(type="NOICD")
			//入选了
			i CDiag=icd s findFlag=0
		}
	}
	
	Q:findFlag=1 findFlag
	
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-14
/// DESC: 过滤个人基本信息
/// IN  : 
/// OUT : 1退出，0不退出
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod FliterPerson(admid = "", PatientID = "", ByRef kpiobj)
{
	Q:(admid="")&&(PatientID="") 1
	
	i PatientID="" s PatientID=$P(^PAADM(admid),"^",1)
	;性别
	s sex=$p(^PAPER(PatientID,"ALL"),"^",7)
	
	Q:(kpiobj.sex'="")&&(kpiobj.sex'=sex) 1
	
	;年龄
	s age=##class(DHCDoc.GCPSW.COM.Func).GetPapmiAge(PatientID,admid)
	s startAge="",endAge=""
	i kpiobj.age'="" d
	.s startAge=$p(kpiobj.age,",",1)
	.s endAge=$p(kpiobj.age,",",2)
	q:(startAge'="")&&(age<startAge) 1
	q:(endAge'="")&&(age>endAge) 1
	
	;身高
	s pHW=##class(DHCDoc.GCPSW.COM.Func).GetLastHeightAndWeigh(PatientID)
	s PH=$P(pHW,"^",1)
	
	s startH="",endH=""
	i kpiobj.height'="" d
	.s startH=$p(kpiobj.height,",",1)
	.s endH=$p(kpiobj.height,",",2)
	q:(startH'="")&&(PH<startH) 1
	q:(endH'="")&&(PH>endH) 1
	
	;体重
	s PW=$P(pHW,"^",2)
	s startW="",endW=""
	i kpiobj.weight'="" d
	.s startW=$p(kpiobj.weight,",",1)
	.s endW=$p(kpiobj.weight,",",2)
	q:(startW'="")&&(PW<startW) 1
	q:(endW'="")&&(PW>endW) 1
	
	;BMI
	s BMI=##class(DHCDoc.GCPSW.COM.Func).GetBMI(PH,PW)
	s startBMI="",endBMI=""
	i kpiobj.BMI'="" d
	.s startBMI=$p(kpiobj.BMI,",",1)
	.s endBMI=$p(kpiobj.BMI,",",2)
	Q:(kpiobj.BMI'="")&&(BMI="") 1
	q:(startBMI'="")&&(BMI<startBMI) 1
	q:(endBMI'="")&&(BMI>endBMI) 1
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-25
/// DESC: 根据日志记录过滤是否需要启动本次任务
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).SummaryData("")
ClassMethod FilterLog(PID, ReLoad, AllFlag)
{
	/*
	;记录完成时间
	;1、更新：最近项目跑完的完成日期和时间
	;2、判断当前项目是否该跑？
	; 启动标识，完成日期为空，过滤
	; 有完成日期，s startDate = LastCompeleteDate
	; i LastCompeleteDate<(+$h-1) 
	
	补全记录滚动日志的完成日期和时间。
	
	
	1. 超过1天，如何保证连续性滚动。
		日志表，最新的一条无完成日期
			说明正在滚动 --- 过滤掉
		
		日志表，最新的一条有完成日期
			滚动结束。
				按照结束日期为开始
		
	
	2. 如何重复滚动？【手工执行】
		日志表里最新的一条记录有：
			无完成日期- ---正在继续
					  -----任务失败（人工查看任务已失败） --- 需要重复滚动
		日志表最新的一条记录里无：
			肯定失败了---需要重复滚动
	
	3。
		项目配置不能超过今天往前推2年。
		
	4。加一个导出功能
		
	*/
	//w $o(^BS.DOC.GCPSW.TaskLogI("Prj",1,""),-1)
	s ok=0,no=1,taskDate=""
	s LID=$o(^BS.DOC.GCPSW.TaskLogI("Prj",PID,""),-1)
	i LID="" {
		i ReLoad=1 {	
			Q ok_"^"_taskDate	//重新生成数据，任务一开始就失败了
		} else {
			Q:LID="" ok_"^"_taskDate	//任务从没跑过
		}
	}
	
	s SID=$o(^BS.DOC.GCPSW.TaskLogI("Prj",PID,LID),-1)
	s endDate=$p(^BS.DOC.GCPSW.TaskLogD(LID),"^",4)
	s endTime=$p(^BS.DOC.GCPSW.TaskLogD(LID),"^",5)
	s startDate=$p(^BS.DOC.GCPSW.TaskLogD(LID),"^",2)
	s startTime=$p(^BS.DOC.GCPSW.TaskLogD(LID),"^",3)
	i endDate="" {
		i ReLoad=1 {	//任务失败
			i SID'="" s taskDate=startDate
			i AllFlag=1 s taskDate=""
			Q ok_"^"_taskDate	//重新生成数据
		} else {	
			Q no_"^"_taskDate	//说明正在滚动 --- 过滤掉
		}
		
	} else {
		i endDate-startDate>2 s taskDate=startDate+1
		e  s taskDate=endDate
		i AllFlag=1 s taskDate=""
		Q ok_"^"_taskDate
	}
}

/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 是否已经退出
/// IN  : 
/// OUT : 1是，0否
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).CreateData("")
ClassMethod HasOut(PatientID, type)
{
	s mRtn=0
	i type="Lis" {
		i $d(^BS.DOC.GCPSW.Temp($j,"LisOut",PatientID)) {
			Q 1	
		}
	}
	i type="Diag" {
		i $d(^BS.DOC.GCPSW.Temp($j,"DiagOut",PatientID)) {
			Q 1	
		}
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 解析
/// IN  : 
/// OUT : 1是，0否
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetArr("")
ClassMethod GetArr(arcims, itemDR, itemKPIStr, ByRef MArr)
{
	Q:arcims=""
	f i=1:1:$l(arcims,",") {
		s arcim=$P(arcims,",",i)
		s MArr(arcim)=itemDR
		f k=1:1:$L(itemKPIStr,"!") {
			s cr=$p(itemKPIStr,"!",k)
			s code=$p(cr,"^",1)
			s val=$p(cr,"^",2)
			s rule=$p(cr,"^",3)
			s MArr(arcim,code)=val_"^"_rule
		}	
		
	}
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 解析检验指标串
/// IN  : 3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
/// OUT : 1是，0否
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Task).GetLisArr("3||1^0013^1,2^FULL^1#D001^3950||1,3949||1!D002^3949||1!D003^11730||1/3||2^BloodChemical^23^FULL^0#TE^2737||1",.LisArr)
ClassMethod GetLisArr(InLis, ByRef LisArr)
{
	f j=1:1:$l(InLis,"/") {
		s rec=$p(InLis,"/",j)
		s ITInfo=$p(rec,"#",1)
		s IKInfo=$p(rec,"#",2)
		
		s itemDR=$P(ITInfo,"^",1)
		s val=$P(ITInfo,"^",3)
		s rule=$P(ITInfo,"^",4)
		s section=$P(ITInfo,"^",5)
		
		f k=1:1:$L(IKInfo,"!") {
			s cr=$p(IKInfo,"!",k)
			s code=$p(cr,"^",1)
			s arcim=$p(cr,"^",2)
			continue:arcim=""
			s sid="s-"_code
			s eid="e-"_code
			f h=1:1:$l(arcim,",") {
				s arcimid=$p(arcim,",",h)
				continue:arcimid=""
				i section=1 {
					s LisArr(arcimid,sid)=val_"^"_rule_"^"_section
					s LisArr(arcimid,eid)=val_"^"_rule_"^"_section
				} else {
					s LisArr(arcimid,code)=val_"^"_rule_"^"_section
				}
			
			}
			
		}
	}
	Q 1
}

}
