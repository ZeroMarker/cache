Import sqluser

/// Descript:   基地管理
/// Creator:    bianshuai
/// CreateDate: 2016-02-02
Class web.DHCSTPHCMBASEMANAGE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存(更新)药学咨询
/// w ##class(web.DHCSTPHCMBASEMANAGE).SaveBasManTeacher("","2507^2^3^3^2^2^HHH")
ClassMethod SaveBasManTeacher(bmTeacherID As %String, bmTDataList As %String) As %String
{
	n (bmTeacherID,bmTDataList)
	s bmTUserID=$p(bmTDataList,"^",1)  //用户ID
	s bmTSexID=$p(bmTDataList,"^",2)   //性别
	s bmTEdu=$p(bmTDataList,"^",3)     //学历
	s bmTLocID=$p(bmTDataList,"^",4)   //科室
	s bmTCareer=$p(bmTDataList,"^",5)  //带教专业
	s bmTCareProvID=$p(bmTDataList,"^",6)  //职称
	s bmTRemark=$p(bmTDataList,"^",7)  //备注
	s teacherAge=$p(bmTDataList,"^",8)  //年龄
	s ClinicalDate=$p(bmTDataList,"^",9)  //取得临床药师证书时间
	s TeacherDate=$p(bmTDataList,"^",10)  //取得临床药师师资证书时间
	s ClinicalDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(ClinicalDate) ;$zdh(StartDate,3)
	s TeacherDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(TeacherDate) ;
	s ret=0
	i bmTeacherID="" d
	.S ret=..InsertTeacher(bmTUserID,bmTSexID,bmTEdu,bmTLocID,bmTCareer,bmTCareProvID,bmTRemark,teacherAge,ClinicalDate,TeacherDate)
	e  d
	.S ret=..UpdateTeacher(bmTeacherID,bmTUserID,bmTSexID,bmTEdu,bmTLocID,bmTCareer,bmTCareProvID,bmTRemark,teacherAge,ClinicalDate,TeacherDate)
	q ret
}

/// Descript:插入教师信息
ClassMethod InsertTeacher(bmTUserID, bmTSexID, bmTEdu, bmTLocID, bmTCareer, bmTCareProvID, bmTRemark, teacherAge, ClinicalDate, TeacherDate) As %String
{
	N (bmTUserID, bmTSexID, bmTEdu, bmTLocID, bmTCareer, bmTCareProvID, bmTRemark,teacherAge,ClinicalDate,TeacherDate)
	S bmTAddDate=+$H                       //记录日期
	S bmTAddTime=$p($H,",",2)              //记录日期
	S phbmtID="",flag=0,ret=""             //hzg  2018-8-30 过滤相同工号，相同带教专业
	f  s phbmtID=$o(^DHCPHBMT(phbmtID+1)) q:phbmtID=""  d     	
	.s userID=$p(^DHCPHBMT(phbmtID),"^",1)
	.s caree=$p(^DHCPHBMT(phbmtID),"^",5)
	.i ((userID=bmTUserID)&&(bmTCareer=caree))  s flag=1
	i flag'=1 d
	.&SQL(Insert Into DHC_PHBasManTeacher(PHBMT_User_Dr,PHBMT_Sex_Dr,PHBMT_Education,PHBMT_Loc_Dr,PHBMT_Career,PHBMT_CarPrvTp,PHBMT_Remark,PHBMT_Date,PHBMT_Time,PHBMT_Age,PHBMT_ClinicalDate,PHBMT_CliTeaDate) 
		Values(:bmTUserID,:bmTSexID,:bmTEdu,:bmTLocID,:bmTCareer,:bmTCareProvID,:bmTRemark,:bmTAddDate,:bmTAddTime,:teacherAge,:ClinicalDate,:TeacherDate))
	.s ret=SQLCODE
	Q ret
}

/// Descript:更新教师信息
ClassMethod UpdateTeacher(bmTeacherID, bmTUserID, bmTSexID, bmTEdu, bmTLocID, bmTCareer, bmTCareProvID, bmTRemark, teacherAge, ClinicalDate, TeacherDate) As %String
{
	N (bmTeacherID, bmTUserID, bmTSexID, bmTEdu, bmTLocID, bmTCareer, bmTCareProvID, bmTRemark,teacherAge,ClinicalDate,TeacherDate)
	S ID="",flag=0,ret=""             
	f  s ID=$o(^DHCPHBMT(ID)) q:ID=""  d
	.q:ID=0 
	.i bmTeacherID'=ID  d	
	..s userID=$p(^DHCPHBMT(ID),"^",1)
	..s caree=$p(^DHCPHBMT(ID),"^",5)
	..i ((userID=bmTUserID)&&(bmTCareer=caree))  s flag=1
	i flag'=1 d
	.&SQL(Update DHC_PHBasManTeacher Set PHBMT_User_Dr=:bmTUserID,PHBMT_Sex_Dr=:bmTSexID,PHBMT_Education=:bmTEdu,PHBMT_Loc_Dr=:bmTLocID,
		PHBMT_Career=:bmTCareer,PHBMT_CarPrvTp=:bmTCareProvID,PHBMT_Remark=:bmTRemark,PHBMT_Age=:teacherAge,PHBMT_ClinicalDate=:ClinicalDate,PHBMT_CliTeaDate=:TeacherDate  Where PHBMT_RowID=:bmTeacherID)
	.s ret=SQLCODE
	Q ret
}

/// Descript:保存(更新)基地学员信息
/// w ##class(web.DHCSTPHCMBASEMANAGE).SaveBasManStudent("","DDDD^2^12岁^2^2^安徽省立医院^2016-03-04^2016-03-04^2^1^的点点滴滴")
ClassMethod SaveBasManStudent(bmStudentID As %String, bmSDataList As %String) As %String
{
	n (bmStudentID,bmSDataList)
	s bmSName=$p(bmSDataList,"^",1)    //姓名
	s bmSSexID=$p(bmSDataList,"^",2)   //性别
	s bmSAge=$p(bmSDataList,"^",3)     //学历
	s bmSEdu=$p(bmSDataList,"^",4)     //科室
	s bmSCareProvID=$p(bmSDataList,"^",5)  //带教专业
	s bmSWorkUnit=$p(bmSDataList,"^",6)  //工作单位
	s bmSBegEduDate=$p(bmSDataList,"^",7)  //开学日期
	s:bmSBegEduDate'="" bmSBegEduDate= ##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(bmSBegEduDate) ;$zdh(bmSBegEduDate,3)
	s bmSEndEduDate=$p(bmSDataList,"^",8)  //毕业日期
	s:bmSEndEduDate'="" bmSEndEduDate= ##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(bmSEndEduDate) ;$zdh(bmSEndEduDate,3)
	s bmSCareer=$p(bmSDataList,"^",9)  //职称
	s bmSOutProFlag=$p(bmSDataList,"^",10)  //是否省外
	s bmSRemark=$p(bmSDataList,"^",11)  //备注
    s bmSProfession=$p(bmSDataList,"^",12)
    s bmSHigEdu=$p(bmSDataList,"^",13)
    s bmSTopProfession=$p(bmSDataList,"^",14)
    s bmSTeacher=$p(bmSDataList,"^",15)
    s bmSTrainDate=$p(bmSDataList,"^",16)
    s bmSTrainDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(bmSTrainDate)
    s bmSIsAssessment=$p(bmSDataList,"^",17)
	s ret=0
	i bmStudentID="" d
	.S ret=..InsertStudent(bmSName,bmSSexID,bmSAge,bmSEdu,bmSCareProvID,bmSCareer,bmSWorkUnit,bmSBegEduDate,bmSEndEduDate,bmSOutProFlag,bmSRemark,bmSProfession,bmSHigEdu,bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment)
	e  d
	.S ret=..UpdateStudent(bmStudentID,bmSName,bmSSexID,bmSAge,bmSEdu,bmSCareProvID,bmSCareer,bmSWorkUnit,bmSBegEduDate,bmSEndEduDate,bmSOutProFlag,bmSRemark,bmSProfession,bmSHigEdu,bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment)
	q ret
}

/// Descript:插入基地学员信息
ClassMethod InsertStudent(bmSName, bmSSexID, bmSAge, bmSEdu, bmSCareProvID, bmSCareer, bmSWorkUnit, bmSBegEduDate, bmSEndEduDate, bmSOutProFlag, bmSRemark, bmSProfession, bmSHigEdu, bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment) As %String
{
	N (bmSName, bmSSexID, bmSAge, bmSEdu,  bmSCareProvID, bmSCareer, bmSWorkUnit, bmSBegEduDate, bmSEndEduDate, bmSOutProFlag, bmSRemark,bmSProfession, bmSHigEdu, bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment)
	S bmSAddDate=+$H                       //记录日期
	S bmSAddTime=$p($H,",",2)              //记录日期

	&SQL(Insert Into DHC_PHBasManStudent(PHBMS_Name,PHBMS_Sex_Dr,PHBMS_Age,PHBMS_Education,PHBMS_CarPrvTp,PHBMS_Career,PHBMS_WorkUnit,PHBMS_BegEduDate,PHBMS_EndEduDate,
		PHBMS_OutProFlag,PHBMS_Date,PHBMS_Time,PHBMS_Remark,PHBMS_Professional,PHBMS_HighestEducation,PHBMS_TopProfessional,PHBMS_Teacher,PHBMS_TrainDate,PHBMS_IsAssessment) 
		Values(:bmSName,:bmSSexID,:bmSAge,:bmSEdu,:bmSCareProvID,:bmSCareer,:bmSWorkUnit,:bmSBegEduDate,:bmSEndEduDate,
		:bmSOutProFlag,:bmSAddDate,:bmSAddTime,:bmSRemark,:bmSProfession,:bmSHigEdu,:bmSTopProfession,:bmSTeacher,:bmSTrainDate,:bmSIsAssessment))
	Q SQLCODE
}

/// Descript:更新基地学员信息
ClassMethod UpdateStudent(bmStudentID, bmSName, bmSSexID, bmSAge, bmSEdu, bmSCareProvID, bmSCareer, bmSWorkUnit, bmSBegEduDate, bmSEndEduDate, bmSOutProFlag, bmSRemark, bmSProfession, bmSHigEdu, bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment) As %String
{
	N (bmStudentID, bmSName, bmSSexID, bmSAge, bmSEdu, bmSCareProvID, bmSCareer, bmSWorkUnit, bmSBegEduDate, bmSEndEduDate, bmSOutProFlag, bmSRemark,bmSProfession, bmSHigEdu, bmSTopProfession, bmSTeacher, bmSTrainDate, bmSIsAssessment)
	
	&SQL(Update DHC_PHBasManStudent Set PHBMS_Name=:bmSName,PHBMS_Sex_Dr=:bmSSexID,PHBMS_Age=:bmSAge,PHBMS_Education=:bmSEdu,PHBMS_CarPrvTp=:bmSCareProvID,PHBMS_Career=:bmSCareer,
		PHBMS_WorkUnit=:bmSWorkUnit,PHBMS_BegEduDate=:bmSBegEduDate,PHBMS_EndEduDate=:bmSEndEduDate,PHBMS_OutProFlag=:bmSOutProFlag,PHBMS_Remark=:bmSRemark,PHBMS_Professional=:bmSProfession,PHBMS_HighestEducation=:bmSHigEdu,PHBMS_TopProfessional=:bmSTopProfession, PHBMS_Teacher=:bmSTeacher, PHBMS_TrainDate=:bmSTrainDate, PHBMS_IsAssessment=:bmSIsAssessment Where PHBMS_RowID=:bmStudentID)
	Q SQLCODE
}

/// Descript:保存[专业方向]
/// w ##class(web.DHCSTPHCMBASEMANAGE).saveProDirect("^SDFASDF^ASD")
ClassMethod saveProDirect(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..updProDirect(TmpStr)
	.e  d
	..s ret=..InsProDirect(TmpStr)
	q 0
}

/// Descript:更新[专业方向]
/// w ##class(web.DHCSTPHCMBASEMANAGE).updProDirect("^SDFASDF^ASD")
ClassMethod updProDirect(DataList As %String) As %String
{
	N (DataList)
	S proDirectID=$p(DataList,"^",1)
	S proDirectCode=$p(DataList,"^",2)
	S proDirectDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHProfDirection Set PHPD_Code=:proDirectCode,PHPD_Desc=:proDirectDesc WHERE PHPD_RowID=:proDirectID)
 	Q SQLCODE
}

/// Descript:增加[专业方向]
/// w ##class(web.DHCSTPHCMBASEMANAGE).InsProDirect("^SDFASDF^ASD")
ClassMethod InsProDirect(DataList As %String) As %String
{
	N (DataList)
	S proDirectCode=$p(DataList,"^",2)
	S proDirectDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHProfDirection(PHPD_Code,PHPD_Desc) VALUES(:proDirectCode,:proDirectDesc))
 	Q SQLCODE
}

/// Descript:删除[专业方向]
/// w ##class(web.DHCSTPHCMBASEMANAGE).DelAdrEvent("1")
ClassMethod delProDirect(proDirectID As %String) As %String
{
	N (proDirectID)
	&SQL(Delete From DHC_PHProfDirection Where PHPD_RowID=:proDirectID)
	Q SQLCODE
}

}
