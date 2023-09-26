/// DtPortal.Doctor.D01PatList.D0107DeathPat
/// 描述:Portal医生角色 D01死亡患者服务
/// 创建者：  程鹏
/// 创建日期: 2018-11-05
Class DtPortal.Doctor.D01PatList.D0107DeathPat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 	程鹏
/// CreatDate： 2018-11-03
/// Description: 查询死亡患者列表
/// Input：		QueryType : 查询单位(P:本人  PG 本主诊组  loc:科室 ward:病区); 
/// 			QureyID :   本人,主诊组为空,科室,病区为为CT_LOC表id 
/// 		   	StartDate：查询开始日期;
/// 		  	EndDate：查询结束日期
///             UserCode：用户code
/// Return：	BedNo：床号
/// 			MedicareNo：病案号
/// 			Name：姓名
/// 			Sex：性别
/// 			Age：年龄
/// 			PAPMINO：登记号 
/// 			CareLevel：护理级别
/// 			VitalSign：生命体征
/// 			ManagerDoc：主管医师
/// 			ChargeDoc：主治医师
/// 			DirDoc：主任医师
/// 			DiagnoseDesc：诊断  
/// 			AdmNo：就诊号      
/// 服务号:		D01.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0107DeathPat","D010701DeathPat","P","","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0107DeathPat","D010701DeathPat","PG","","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0107DeathPat","D010701DeathPat","loc","104","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0107DeathPat","D010701DeathPat","ward","132","2020-06-01","2020-06-22","ys01")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0107DeathPat","D010701DeathPat","呼吸内科一二护理单元|193|2","2016-01-01","2018-11-06","4829")
Query D010701DeathPat(QueryType As %String, QureyID As %String, StartDate As %String, EndDate As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "ind,patname,sex,age,meNum,type,bednum,Ward,Dept,PAPMINO,inDate,inHospDay,Diagnosis,docname,DeathDate,AReason,IsReport,Disdiag,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010701DeathPatExecute(ByRef qHandle As %Binary, QueryType As %String, QureyID As %String, StartDate As %String, EndDate As %String, UserCode As %String) As %Status
{
	n (qHandle,QueryType,QureyID,StartDate,EndDate,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	quit:((QueryType="")&&(UserCode="")) $$$OK
	
	set:StartDate="" StartDate=+$h
	set:EndDate="" EndDate=+$h
	set:StartDate["-" StartDate=$zdh(StartDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)
	
	set rangeType=1,locID="",UserId="",wardID="",docID="",MUIDStr="",alocID=""
	//获得查询范围
	set rangeType=1,UserId=""
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	if ((QueryType="P")||(QueryType="PG"))
	{
		quit:UserId="" $$$OK
		set:QueryType="P" rangeType=1			//本人
		set:QueryType="PG" rangeType=2			//主诊组
		set docID=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
		set:rangeType=2 MUIDStr=##class(DtPortal.Common.PublicService).GetMUDocList(docID)
		set:MUIDStr'="" MUIDStr="^"_MUIDStr_"^"
		
	}else
	{
		set:QueryType="loc" rangeType=3,alocID=QureyID		//科室
		set:QueryType="ward" rangeType=4		//病区
		quit:QureyID="" $$$OK
		Set:((rangeType=4)&&(QureyID'="")) wardID=$o(^PAWARD(0,"WARD_LocationDR",QureyID,""))
		quit:QureyID="" $$$OK
	}

	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	
	for date=StartDate:1:EndDate
	{
		set papmi=""
		for
		{
			set papmi=$o(^PAPERi("DecDate",date,papmi)) 
			quit:papmi=""
			
			
			set deathTime=$p(^PAPER(papmi,"ALL"),"^",8)
			set:deathTime'="" deathTime=$zt(deathTime,2)
			set admid=""
			set admid=$o(^PAPERdr(papmi,"ADM","I",""),-1) 
			quit:admid=""
				
			set aloc=$p(^PAADM(admid),"^",4)  
			set adocID=$p(^PAADM(admid),"^",9)
			set aWardID=$p(^PAADM(admid),"^",70)
			set docIDstr="^"_adocID_"^"
			
			continue:(rangeType="1")&&(docID'=adocID)
			continue:(rangeType="2")&&(MUIDStr'[docIDstr)
			continue:(rangeType="3")&&(alocID'=aloc)
			continue:(rangeType="4")&&(wardID'=aWardID)
			
			
			set DeathDate = $zd(date,3)_"&nbsp;"_deathTime
			set PatientID=$p($g(^PAADM(admid)),"^",1)
			set docname=""
			set:docID'="" docname=$p(^CTPCP(docID,1),"^",2)
			set AReason="",Ward="",Dept=""
			
			set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(admid)
			
    		continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
			
			if reportStr'=""
			{
				set DthDate=$p(reportStr,"^",2)
				set DthTime=$p(reportStr,"^",3)
				set:DthDate'="" DthDate=$zd(DthDate,3)
				set:DthTime'="" DthTime=$zt(DthTime,2)
				set DeathDate=DthDate_"&nbsp;"_DthTime
				set AReason=$p(reportStr,"^",4)
			}
						
			set inDateStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admid)
			set inDate=$p(inDateStr,"^",1)
			set inDate = $zd(inDate,3)
	
			set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(admid) 
			set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(admid)
			Continue:PatInfo=""
			
			set patname=$p(PatInfo,"^",2)											//姓名
			set sex=$p(PatInfo,"^",3)												//性别
			set age=$p(PatInfo,"^",4)												//年龄
			set meNum=$p(PatInfo,"^",5)												//病案号
			set type=$p(PatInfo,"^",6)												//费用类别
			set bednum=$p(PatInfo,"^",1)											//床号
       		
       		s WardID=$p(^PAADM(admid),"^",70)
       		i WardID'="" s Ward=$p(^PAWARD(WardID),"^",2)
			i Ward["-" s Ward=$p(Ward,"-",2)

			s DeptDr=$p(^PAADM(admid),"^",4)
			s Dept=$p(^CTLOC(DeptDr),"^",2)
			i Dept["-" s Dept=$p(Dept,"-",2)
			Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
			
				//入院诊断
			set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admid) 
				//出院诊断
			s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(admid)
			
			//获取打开电子病历所需要的参数
			set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(admid)
			set EMRDocID=$p(EMRinfo,"^",1)
			set EMRInstanceID=$p(EMRinfo,"^",2)
			set locID=$p(EMRinfo,"^",3)
			set PatientID=$p(EMRinfo,"^",4)
			set EpisodeID=$p(EMRinfo,"^",5)
			Set ^||CacheTemp(repid,ind)=$lb(ind,patname,sex,age,meNum,type,bednum,Ward,Dept,PAPMINO,inDate,inHospDay,Diagnosis,docname,DeathDate,AReason,IsReport,Disdiag,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
			Set ind=ind+1
			
			
		}
	}
	
	quit $$$OK
}

}
