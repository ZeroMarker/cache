/// 
/// 
/// 包医二附院调科
Class web.MgNurTransComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:保存调科申请
/// Date:2019-06-19
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveNurseTrans(parr As %String) As %String
{
	s ^TMP("SaveNurseTrans")=parr
	//TransDate|2019-06-20^TransInDep|1^TransType|13__1^TransNurse|^TransReason|
	//^CreateUser|0^TransStatus|N^TransEndDate|2019-06-27^RowID|^TranSpecy|T^TransNum|4
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s nurseInfo=$P($P(parr,"^",4),"|",2)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgTransApp).%New()
	e  s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	i obj.TransAppNo="" s obj.TransAppNo=##class(web.NurMgPersonComm).GetAppNo()
	s obj.TransOutDep=""
	s obj.TransInDep=$g(tmp("TransInDep"))
	s obj.TransType=$P($p(parr,"^",3),"|",2)
	s obj.TransDate=$zdh($g(tmp("TransDate")),3)
	s obj.CreateDate=+$H
	s obj.CreateUser=$g(tmp("CreateUser"))
	s obj.TransReason=$g(tmp("TransReason"))
	s obj.TransStatus=$g(tmp("TransStatus"))
	s obj.TransCount=$g(tmp("TransNum"))
	q:(($g(tmp("TransStatus"))="Y")&&($g(tmp("TransDate")))&&($zdh($g(tmp("TransDate")),3)<=+$h)) "调科日期不能小于当天"
	i $g(tmp("TransEndDate"))'="" s obj.TransEndDate=$zdh($g(tmp("TransEndDate")),3)
	e  s obj.TransEndDate=""
	s obj.TranSpecy=$g(tmp("TranSpecy"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod AuditTransRec(id As %String, parr As %String, opinion As %String, status As %String, transRadio As %String) As %String
{
	s ^TMP("AuditTransRec")=id_"%"_parr_"%"_opinion_"%"_status_"%"_transRadio
	///8%25~4@31~15@17~17%%A%1
	q:id="" 0
	s flag=1
	
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.TransOpinion=$tr(opinion," ","")
	s obj.TransStatus=status
	s obj.TransRadio=transRadio
	d obj.TransNurse.Clear()
	s len=$l(parr,"@")
	f i=1:1:len
	{
		s itm=$p(parr,"@",i)
		i itm="" continue
		s dep=$p(itm,"~",1)
		s nurse=$P(itm,"~",2)
		d obj.TransNurse.Insert(dep_"|"_nurse)
	}
	TS
	s sc=obj.%Save()
	s flag=(flag&&$$$ISOK(sc))
	b ;01
	i status="A"
	{
		s l=obj.TransNurse.Count()
		f j=1:1:l
		{
			s item=obj.TransNurse.GetAt(j)
			s nurseid=$P(item,"|",2)
			s nursedep=obj.TransInDep
			s stdate=obj.TransDate
			s date=(stdate-1) f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurseid,date)) q:date=""  d
			.s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurseid,date,rw)) q:rw=""  d
			..s ArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
			..q:'$IsObject(ArgObj)
			..//需求要确认 审核删除之后的排班数据
			..;s argSc=ArgObj.%DeleteId(rw)
			..;s flag=(flag&&$$$ISOK(argSc))
			i flag=1
			{
				///添加调科记录信息
				i (obj.TransDate<=(+$H))
				{
					s transRw=$o(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_nurseid,""))
					i transRw=""
					{
						///某人调科记录不存在 则插入一条新的
						s TransObj=##class(DHCNMG.HR.MgTransDep).%New()
						s TransObj.PerDr=nurseid
						s TransObj.PerDepart=nursedep
						s TransObj.PerTranStDate=stdate
						s TransObj.PerTranStTime=$zth("00:00:00",1)
						s TransObj.PerTranCurrent="Y"
						s TransObj.PerTransType="L"
						s TransSc=TransObj.%Save()
						s flag=(flag&&$$$ISOK(TransSc))
						i flag=1
						{
							s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
							s PerObj.PerDepDR=nursedep
							s PerObj.PerDepDate=stdate
							s PerSc=PerObj.%Save()
							s flag=(flag&&$$$ISOK(PerSc))
						}
					}
					else
					{
						s TransObj=##class(DHCNMG.HR.MgTransDep).%OpenId(transRw)
						s TransObj.PerTranEndDate=stdate
						s TransObj.PerTranEndTime=$zth("00:00:00",1)
						s TransObj.PerTranCurrent="N"
						s TransObj.PerTransType="L"
						s TransObj.PerAppID=obj.%Id()
						s TransSc=TransObj.%Save()
						s flag=(flag&&$$$ISOK(TransSc))
						i flag=1
						{
							s NewTransObj=##class(DHCNMG.HR.MgTransDep).%New()
							s NewTransObj.PerDr=nurseid
							s NewTransObj.PerDepart=nursedep
							s NewTransObj.PerTranStDate=stdate
							s NewTransObj.PerTranStTime=$p($H,",",2)
							s NewTransObj.PerTranCurrent="Y"
							s NewTransObj.PerAppID=obj.%Id()
							s NewTransObj.PerTransType=obj.TranSpecy
							s NewTransObjSc=NewTransObj.%Save()
							s flag=(flag&&$$$ISOK(NewTransObjSc))
							i flag=1
							{
								s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
								s PerObj.PerDepDR=nursedep
								s PerObj.PerDepDate=stdate
								s PerSc=PerObj.%Save()
								s flag=(flag&&$$$ISOK(PerSc))
							}
						}
					}
				}
				else
				{
					s objNew=##class(DHCNMG.HR.MgTransDep).%New()
					s objNew.PerDr=nurseid
					s objNew.PerDepart=nursedep
					s objNew.PerTranStDate=stdate
					s objNew.PerTranStTime=$p($H,",",2)
					s objNew.PerTranCurrent="P"
					s objNew.PerAppID=obj.%Id()
					s objNew.PerTransType=obj.TranSpecy
					s objNewSc=objNew.%Save()
					s flag=(flag&&$$$ISOK(objNewSc))
				}
			}
		}
	}
	i flag=1 tc
	e  tro
	q flag
}

ClassMethod GetTransNurses(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) ""
	s len=obj.TransNurse.Count()
	;w "["
	f i=1:1:len
	{
		s itm=obj.TransNurse.GetAt(i)
		i itm="" continue
		s nurId=$p(itm,"|",2)
		s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurId)
		i '$IsObject(NurObj) continue
		i i=1 w NurObj.PerName
		e  w ","_NurObj.PerName
	}
	;w "]"
	q ""
}

}
