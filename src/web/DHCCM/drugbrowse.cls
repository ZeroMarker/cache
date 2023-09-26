Class web.DHCCM.drugbrowse Extends %Persistent [ Not ProcedureBlock ]
{

/// d ##class(web.DHCCM.drugbrowse).getAllEpisodeId("6534094")
ClassMethod getAllEpisodeId(APatientID)
{
	s pid=$I(^TMP("DHCDRUG"))
	k ^TMP("DHCDRUG","web.DHCCM.drugbrowse","getAllEpisodeId",pid)
	s Num=0,Count=0

	s typeRowID=""
	f  s typeRowID=$o(^PAPERdr(APatientID,"ADM",typeRowID)) q:typeRowID=""  d
	.s episodeID=""
	.f  s episodeID=$o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID)) q:episodeID=""  d
	..s episodeDate = $p($g(^PAADM(episodeID)),"^",6)		 	
	..s episodeDate = $ZD(episodeDate,3)  
	..s episodeTime = $p($g(^PAADM(episodeID)),"^",7)
	..s episodeTime = $zt(episodeTime,1)
	..s episodeDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)		
	..s episodeDeptID = $p(episodeDept,"^",1)
	..s episodeDeptDesc = $p(episodeDept,"^",3)
	..s mainDoc = ##Class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(episodeID)
	..s mainDocName = $P(mainDoc, "^", 3) 
	..s episodeType= $p(^PAADM(episodeID),"^",2)
	..i episodeType="I" s episodeType="住院"
	..i episodeType="O" s episodeType="门诊"
	..i episodeType="E" s episodeType="急诊"
	
	..s dischargeDate = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	..s dischargeDate = $P(dischargeDate, ",", 1)
	..i (dischargeDate '= "") s dischargeDate = $zd(dischargeDate,3)
		       
	..s diagnosis= ##Class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
	..i diagnosis '= "" d
	...s diagnosis = $P(diagnosis,"^",3)
	...s diagnosis = $tr(diagnosis,"'","\'")
			
	..s diagnosis = $tr(diagnosis,"\s","")
	..s jsonData=episodeDate_"^"_diagnosis_"^"_episodeType_"^"_episodeDeptDesc_"^"_mainDocName_"^"_dischargeDate_"^"_episodeID_"^"_episodeDeptID
	..s Num=Num+1
    ..s ^TMP("DHCDRUG","web.DHCCM.drugbrowse","getAllEpisodeId",pid,Num)=jsonData
    
    q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(Num) //输出空的json串
    
    s Title="EpisodeDate^Diagnosis^EpisodeType^EpisodeDeptDesc^MainDocName^DischargeDate^EpisodeID^EpisodeDeptID"
	w "[" //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDRUG","web.DHCCM.drugbrowse","getAllEpisodeId",pid,index)) q:index=""  d
	.S mdata=$g(^TMP("DHCDRUG","web.DHCCM.drugbrowse","getAllEpisodeId",pid,index))
	.S Count=Count+1
	.i Count=1  d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	w "]" //输出json结尾符
	k ^TMP("DHCDRUG","web.DHCCM.drugbrowse","getAllEpisodeId",pid)
	q ""
}

/// 当前就诊信息
/// d ##class(web.DHCCM.drugbrowse).nowEpisode("32595")
ClassMethod nowEpisode(EpisodeID)
{
	s pid=$I(^TMP("NOW"))
	k ^TMP("NOW","web.DHCCM.drugbrowse","nowEpisode",pid)
	s Num=0,Count=0
	
	s episodeDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	s episodeDeptID = $p(episodeDept,"^",1)
	s episodeType= $p(^PAADM(EpisodeID),"^",2)
	s jsonData=episodeDeptID_"^"_episodeType
	s Num=Num+1
    s ^TMP("NOW","web.DHCCM.drugbrowse","nowEpisode",pid,Num)=jsonData
    q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(Num) //输出空的json串
    
    s Title="episodeDeptID^episodeType"
	w "[" //输出json前缀串
	s index=""
	f  s index=$o(^TMP("NOW","web.DHCCM.drugbrowse","nowEpisode",pid,index)) q:index=""  d
	.S mdata=$g(^TMP("NOW","web.DHCCM.drugbrowse","nowEpisode",pid,index))
	.S Count=Count+1
	.i Count=1  d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	w "]" //输出json结尾符
	k ^TMP("NOW","web.DHCCM.drugbrowse","nowEpisode",pid)
	q ""
}

/// 病人列表
/// w ##class(web.DHCCM.drugbrowse).GetAdmList("30","1","","36^")
ClassMethod GetAdmList(rows, page, PapmiNo, Input)
{
	n (rows, page, PapmiNo,Input)
	s LocID=$p(Input,"^")
	s wardID=$p(Input,"^",2)
	s empflag=""
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行 
    s pid=$I(^TMP("PATLIST"))  //调用计数器类并给其赋值
    k ^TMP("PATLIST","web.DHCCM.drugbrowse","GetAdmList",pid) //k掉临时global
    s h=0,count=0
    i LocID'=""  d
	.s wardID=""
	.f  s wardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,wardID)) q:wardID=""  d
	..s curRoomDr=""
	..f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
	....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ....q:patVisit'="A"
	....d getPatInfo
	E  D
	.s curRoomDr=""
	.f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	..s AdmDr=""
	..f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
	...s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ...q:patVisit'="A"
	...d getPatInfo
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	s h=""
	f  s h=$o(^TMP("PATLIST","web.DHCCM.drugbrowse","GetAdmList",pid,h)) q:h=""  d
	.s data=^TMP("PATLIST","web.DHCCM.drugbrowse","GetAdmList",pid,h)
	.s patward=$p(data,"^",1)
	.i $f(patward,"-") s patward=$p(patward,"-",2)
	.s patbed=$p(data,"^",2)
	.s patno=$p(data,"^",3)
	.s patname=$p(data,"^",4)
	.s patsex=$p(data,"^",5)
	.s patage=$p(data,"^",6)
	.s patheight=$p(data,"^",7)
	.s patweight=$p(data,"^",8)
	.s patindate=$p(data,"^",9)
	.s patdoctor=$p(data,"^",10)
	.s patempflag=$p(data,"^",11)
	.s patadm=$p(data,"^",12)
	.s patloc=$p(data,"^",13)
	.s patroom=$p(data,"^",14)
	.s patdiag=$p(data,"^",15)
	.s mLevel=$p(data,"^",16)     //qunianpeng 2016-08-04
	.s monLevel=$p(mLevel,"/",1)  //qunianpeng 2016-08-04
	.s monLevelDesc=$p(mLevel,"/",2)  //qunianpeng 2016-08-04
	.s PatientID=$p(data,"^",17)
	.s AdmLocId=$p(data,"^",18)
	.s SubClassId=$p(data,"^",19)
	.s WardID=$p(data,"^",20)
	.s monCount=$p(data,"^",21)
	.s count=count+1
	.q:count<stpage
	.q:count>endpage
	.
	.s patward=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patward",patward)
	.s patbed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patbed",patbed)
	.s patno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patno",patno)
	.s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
	.s patsex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patsex",patsex)
	.s patage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patage",patage)
	.s patheight=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patheight",patheight)
	.s patweight=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patweight",patweight)
	.s patindate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patindate",patindate)
	.s patdoctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patdoctor",patdoctor)
	.s patempflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patempflag",patempflag)
	.s patadm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patadm",patadm)
	.s patloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patloc",patloc)
	.s patroom=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patroom",patroom)
	.s monLevel=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monLevel",monLevel)
	.s monLevelDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monLevelDesc",monLevelDesc)  //qunianpeng 2016-08-04
	.s PatientID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatientID",PatientID)
	.s AdmLocID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmLocID",AdmLocId)
	.s monSubCId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monSubCId",SubClassId)
	.s WardID=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WardID",WardID)
	.s monCount=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("monCount",monCount)
	.s patdiag=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("patdiag",patdiag)
	.
	.s tmpstr=patward_patbed_patno_patname_patsex_patage_patheight_patweight_patindate_patdoctor_patempflag_patadm_patloc_patroom_monLevel_monLevelDesc_PatientID_AdmLocID_monSubCId_WardID_monCount_patdiag
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
	.i count=stpage w startString
	.i count<endpage w firstrow
	.i count=endpage w lastrow
	.
	 
	k ^TMP("PATLIST","web.DHCCM.drugbrowse","GetAdmList",pid)
	    
	q ""
getPatInfo
	s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s admtime=$p(^PAADM(AdmDr),"^",7) //就诊时间
	i admdate'="" s admdate=$zd(admdate,3)
	i admtime'="" s admtime=$zt(admtime,1)
	s admdate=admdate //_" "_admtime
	s admward=""
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s admbed=""
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    q:(PapmiNo'="")&(PapmiNo'=patno)
	s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
    s patsex=$p(^CT("SEX",sex),"^",2)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    s patage=##class(PHA.FACE.IN.Com).GetAge(papmi,AdmDr)  ;年龄
    s diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")
    s patW=##class(PHA.COM.Order).PatWeight(AdmDr)
    s patH=##class(PHA.COM.Order).PatHeight(AdmDr)
    s patempflag=..GetEmpFlagByAdm(AdmDr)
    q:(empflag="Y")&(patempflag'="Y")
    s AdmLoc=""
    s AdmLocId=$p(^PAADM(AdmDr),"^",4) //科室
	s:AdmLocId'="" AdmLoc=$p($p(^CTLOC(AdmLocId),"^",2),"-",2)
	s AdmCurrRoom=$p(^PAADM(AdmDr),"^",69) //房间号
	s:AdmCurrRoom'="" AdmCurrRoom=$p(^PAROOM(AdmCurrRoom),"^",2)
	s AdmDoctor=""
	s AdmDocCodeDR=$p(^PAADM(AdmDr),"^",9) //医生
	s:AdmDocCodeDR'="" AdmDoctor=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
	s mLevel=..getPatMonLevel(AdmDr) //获取患者监护级别 qunianpeng  2016-08-04
	s monSubClassId=##Class(web.DHCSTPHCMPHARCAREMAIN).getMonSubClass(AdmLocId)
	s monCount=##Class(web.DHCSTPHCMPHARMACYCARE).getPatMonCount("",AdmDr)
	s data=admward_"^"_AdmBed_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_patH_"^"_patW_"^"_admdate_"^"_AdmDoctor_"^"_patempflag_"^"_AdmDr_"^"_AdmLoc_"^"_AdmCurrRoom_"^"_diag_"^"_mLevel_"^"_papmi_"^"_AdmLocId_"^"_monSubClassId_"^"_admwarddr_"^"_monCount 
    
	s h=h+1
	s index=admward_"^"_AdmBed_"^"_admdate_"^"_patno_"^"_h
	s ^TMP("PATLIST","web.DHCCM.drugbrowse","GetAdmList",pid,index)=data
}

/// Descript:获取患者监护级别
ClassMethod getPatMonLevel(admDr As %String) As %String
{
	//n (admDr)
	s empPatID=$o(^DHCPHEP(0,"ADMDR",admDr,""),-1)
	q:empPatID="" ""
	q:$p(^DHCPHEP(empPatID),"^",7)'="" ""
	s mLevelID=$p(^DHCPHEP(empPatID),"^",6)   //监护级别ID
	s mLevelDesc=$p(^DHCPHML(mLevelID),"^",2) //监护级别desc  qunianpeng 2016-08-04
	s mLevel=mLevelID_"/"_mLevelDesc
	q mLevel
}

/// 通过adm获取是否重点关注标志
ClassMethod GetEmpFlagByAdm(adm) As %String
{
	s main=+..GetMFlagByAdm(adm,"EMP")
	q:main=0 ""
	s flag=$p(^DHCPHORDM(main),"^",2)
	q flag
}

/// 获取监控标志
ClassMethod GetMFlagByAdm(adm, app) As %String
{
	s ret=""
	s main=""
	f  s main=$o(^DHCPHORDM(0,"Adm",adm,main)) q:main=""  d
	.s apptype=$p(^DHCPHORDM(main),"^",9)
	.i apptype=app d
	..s ret=main
	
	q ret
}

/// 获取药剂科科室id
/// dws 2017-04-26
/// w ##class(web.DHCCM.drugbrowse).getKbLocId("药剂科")
ClassMethod getKbLocId(kbLocName)
{
	s locId=""
	s:kbLocName'="" locId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(kbLocName),""))
	q locId
}

/// 根据KnowledgeBaseID获取对应的所有KBTreeID
/// dws 2017-04-26
/// w ##class(web.DHCCM.drugbrowse).getKBTreeCTLoc("279")
ClassMethod getKBTreeCTLoc(kBaseId)
{
	s locIdAll=""
	s kbTreeId=""
	f  s kbTreeId=$o(^DHCEMRM.KBTreeI("IdxKnowledgeBaseID"," "_kBaseId,kbTreeId)) q:kbTreeId=""  d
	.s kbTreeLocId=""
	.f  s kbTreeLocId=$o(^DHCEMRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_kbTreeId,kbTreeLocId)) q:kbTreeLocId=""  d
	..s locIdAll=locIdAll_"^"_kbTreeLocId
	s locIdAll=$e(locIdAll,2,$l(locIdAll))
	q locIdAll
}

Storage Default
{
<Data name="drugbrowseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCM.drugbrowseD</DataLocation>
<DefaultData>drugbrowseDefaultData</DefaultData>
<IdLocation>^web.DHCCM.drugbrowseD</IdLocation>
<IndexLocation>^web.DHCCM.drugbrowseI</IndexLocation>
<StreamLocation>^web.DHCCM.drugbrowseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
