Class web.DHCPE.Interface.BaArea.Main Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(web.DHCPE.Interface.BaArea.Main).SetReportInfo(629,"XML")

ClassMethod SetReportInfo(PAADM, RetFormat As %String = "")
{
	//准备输出数据
	s recordno=PAADM
	s recordtime=$P(^PAADM(PAADM),"^",6)
	s:recordtime'="" recordtime=$ZD(recordtime,3)
	s recordstate=1
	s PatMasID=$P(^PAADM(PAADM),"^",1)
	s username=$P(^PAPER(PatMasID,"ALL"),"^",1)
	s userno=$P(^PAPER(PatMasID,"PAT",1),"^",1)
	s PreIBIID=$O(^DHCPEPreIBI(0,"PAPMINo",userno,0))	
	s gender=$P(^PAPER(PatMasID,"ALL"),"^",7)
	s:gender'="" gender=$P(^CT("SEX",gender),"^",2)
	i gender[("女") d
	.s gender=2
	e  d
	.s gender=1
	s age=""
	s birthday=$P(^PAPER(PatMasID,"ALL"),"^",6)
	s:birthday'="" birthday=$ZD(birthday,3)
	s cardno=$P(^PAPER(PatMasID,"PAT",3),"^",6)
	s phonenumber=$P(^PAPER(PatMasID,"PER",4),"^",21)
	s telephone=$P(^PAPER(PatMasID,"PER",4),"^",18)
	s email=$P(^DHCPEPreIBI(PreIBIID),"^",16)
	s nationalty=""
	s workunit=$P(^DHCPEPreIBI(PreIBIID),"^",12)
	s bloodtype=""
	s address=$P(^DHCPEPreIBI(PreIBIID),"^",14)
	s loginname=""
	s loginpwd=""
	s profession=""
	s matrimony=""
	s degreeeducation=""
	
	s:$D(%session) UserID=%session.Get("LOGON.USERID")
	s:'$D(%session) UserID=PAADM
	s:UserID="" UserID=PAADM
	k ^TMPReport(UserID)
	//s LocID=%session.Get("LOGON.CTLOCID")
	d ##Class(web.DHCPE.ReportOutToWeb).GetReportInfor(PAADM,UserID)
	//总检结论
	s summarize=""
	//总检建议
	s advice=$G(^TMPReport(UserID,"GeneralAdvice","Advice"))
	s isaccess=1
	//服务验证对象
	s serverLogin=##class(web.DHCPE.Interface.BaArea.Entity.WebServerLogin).%New()
	s organID=1
	s serverLogin.organID=organID
	s serverLogin.gradeID=$zobjclassmethod(..#ServiceClassName,"GetUserGradeList",organID)
	s serverLogin.loginUserID=$zobjclassmethod(..#ServiceClassName,"GetSystemUser",organID)
	s serverLogin.healthAdviser=$zobjclassmethod(..#ServiceClassName,"GetSystemUser",organID)
	s serverLogin.healthAssistant=$zobjclassmethod(..#ServiceClassName,"GetSystemUser",organID)
	s libraryID=1
	s serverLogin.libraryID=libraryID
	//体检异常集合对象
	s reportAbnormalS=##class(%ListOfObjects).%New()
	
	//体检小结集合对象
	s reportConclusionS=##class(%ListOfObjects).%New()
	s STRowId=""
	f  s STRowId=$O(^TMPReport(UserID,"Summarize", "Station", STRowId)) q:STRowId=""  d
	.s SDesc=$G(^TMPReport(UserID,"Summarize", "Station", STRowId))
	.s reportConclusion=##class(web.DHCPE.Interface.BaArea.Entity.TempReportConclusion).%New()
	.s reportConclusion.RecordNO=PAADM
	.s reportConclusion.Conclusion=$G(^TMPReport(UserID,"Summarize", "Content", SDesc))
	.s reportConclusion.SectionName=SDesc
	.s reportConclusion.CheckUser=$G(^TMPReport(UserID,"Summarize", "Content", SDesc, "AduitUser"))
	.s reportConclusion.CheckTime=$G(^TMPReport(UserID,"Summarize", "Content", SDesc, "AduitDate"))
	.d reportConclusionS.Insert(reportConclusion)
	
	//体检项目集合对象
	s reportItemS=##class(%ListOfObjects).%New()
	s NoReportStation="^"_$G(^DHCPESetting("DHCPE","NoReportStation"))_"^"
	s ItemSort=0
	s sStationSequence=""
	f  s sStationSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence)) q:sStationSequence=""  d
	.s StationId=""
	.f  s StationId=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId)) Q:(""=StationId)  d
	..q:NoReportStation[("^"_StationId_"^")
	..s sectionname=$P(^DHCPEST(StationId),"^",2)
	..s sARCSequence=""
	..f  s sARCSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence)) Q:(""=sARCSequence)  d
	
	...s iiiLLoop=0
	...f  s iiiLLoop=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop)) Q:(""=iiiLLoop)  d
	....s ARCIM=$G(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop))
	
	....s DetailSort=0
	....s ODID=""
	....f  s ODID=$O(^TMPReport(UserID,"Result", "Content",ARCIM,ODID)) q:ODID=""  d
	.....s CurData=$g(^TMPReport(UserID,"Result", "Content",ARCIM,ODID))
	.....;^DHCPENetReport("Result",PAADM,"OrdDetail",OrdItemID,"Detail",Sort,DetailID)=细项名称^英文缩写^检查结果^提示(上下箭头)^单位(10S9)^参考范围
	.....s itemname=$P(CurData,"^",1)
	.....s DetailSort=DetailSort+1
	.....s orderid=DetailSort
	.....s examdetail=$P(CurData,"^",2)
	.....s itemmemo=$P(CurData,"^",3)
	.....s unit=$P(CurData,"^",4)
	.....i (ReportFormat["LIS")||(ReportFormat["CAT") d
	......s refranger=$P(CurData,"^",5)
	......s Arrow=$P(CurData,"^",6)
	.....i (ReportFormat["NOR")||((ReportFormat["RIS")||(ReportFormat["PIS")||((ReportFormat["EKG"))) d
	......s refranger=$P(CurData,"^",7)
	......s Arrow=""
	.....w examdetail,!
	.....s reportItem=##class(web.DHCPE.Interface.BaArea.Entity.TempReportItem).%New()
	.....s reportItem.recordno=PAADM
	.....s reportItem.sectionname=sectionname
	.....s reportItem.itemname=itemname
	.....s reportItem.examdetail=examdetail
	.....s reportItem.refranger=refranger
	.....s reportItem.unit=unit
	.....s reportItem.itemmemo=itemmemo
	.....s reportItem.orderid=orderid
	.....d reportItemS.Insert(reportItem)
	k ^TMPReport(UserID)
	s isRepeat=2
	s isUpdate=2
	s isUpdateReport=2	
	//对对象赋值
	s obj=##class(web.DHCPE.Interface.BaArea.Entity.TempReportInfo).%New()
	s obj.recordno=recordno
	s obj.recordtime=recordtime
	s obj.recordstate=recordstate
	s obj.username=username
	s obj.userno=userno
	s obj.gender=gender
	s obj.age=age
	s obj.birthday=birthday
	s obj.cardno=cardno
	s obj.phonenumber=phonenumber
	s obj.telephone=telephone
	s obj.email=email
	s obj.nationalty=nationalty
	s obj.workunit=workunit
	s obj.bloodtype=bloodtype
	s obj.address=address
	s obj.loginname=loginname
	s obj.loginpwd=loginpwd
	s obj.profession=profession
	s obj.matrimony=matrimony
	s obj.degreeeducation=degreeeducation
	s obj.summarize=summarize
	s obj.advice=advice
	s obj.isaccess=1
	s obj.isRepeat=2
	s obj.isUpdate=2
	s obj.isUpdateReport=2
	s obj.serverLogin=serverLogin
	s obj.reportAbnormalS=reportAbnormalS
	s obj.reportConclusionS=reportConclusionS
	s obj.reportItemS=reportItemS
	q:RetFormat="" obj
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化小结站点对象失败^"
	}
	q XML
}

ClassMethod GetSystemUser(a)
{
	q "aa"
}

ClassMethod GetUserGradeList(a)
{
	q "bb"
}

ClassMethod Main(PAADM)
{
	s $ZT="MainErr"
	s obj=..SetReportInfo(PAADM)
	s ret=$zobjclassmethod(..#ServiceClassName,"UpReportCollectionData",obj,"")
MainErr
	s ^DHCPEInterface.BaArea("ERR",PAADM)=$ZERROR
	q 1
}

ClassMethod Task()
{
	s Date=+$H
	s Time=""
	f  s Time=$O(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:Time=""  d
	.s GSID=""
	.f  s GSID=$O(^DHCPEGS(0,"AuditDateTime",Date,Time,GSID)) q:GSID=""  d
	..s IADM=$P(^DHCPEGS(GSID,1),"^",1)
	..s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	..s ret=..Main(PAADM)
	..i ret'=1 d
	...s ^DHCPEInterface.BaArea("RET",PAADM)=ret
}

/// 引入web服务的类名
Parameter ServiceClassName = "web.DHCPE.Interface.BaArea.Main";

}
