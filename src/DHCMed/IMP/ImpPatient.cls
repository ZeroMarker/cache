/// 名称：DHCMed.IMP.ImpPatient
/// 描述：重点患者记录
/// 创建者：李阳
/// 创建日期：2010-04-08
Class DHCMed.IMP.ImpPatient Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病人就诊ID
Property Paadm As %Integer;

/// 关联的病人ID
Property PatientID As %Integer;

/// 为了提供按姓名查找功能，设立了这个数据冗余字段。
Property SummaryInfo As %String(TRUNCATE = 1);

/// 重点病人类型
/// 指向DHCMed.IMP.PatientTypeSub
Property ImpType As %Integer;

/// 开始日期
Property FromDate As %Date;

/// 开始时间
Property FromTime As %Time;

/// 当前状态
Property Status As %Integer;

/// 更新用户
/// 指向DHCMed.Base.SSUser
Property UpdateUser As %Integer;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 负责人
/// Add By LiYang 2010-04-27
Property DutyUser As %Integer;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 结束日期
Property ToDate As %Date;

/// 结束时间
Property ToTime As %Time;

/// 临床上报ID
Property ClinRepID As %Integer;

/// 负责科室 CT_Loc
Property DutyLoc As %Integer;

/// 转归
Property Prognosis As %String(TRUNCATE = 1);

/// Add By LiYang 2011-12-21 预计结束日期
Property WillToDate As %Date;

Index PaadmIndex On Paadm;

Index PatientIDIndex On PatientID;

Index SummaryInfoIndex On SummaryInfo;

Index ImpTypeIndex On ImpType;

Index FromDateIndex On FromDate;

Index StatusIndex On Status;

Index UpdateUserIndex On UpdateUser;

Index UpdateDateIndex On UpdateDate;

Index DutyUserIndex On (DutyUser, Status);

Index IndexTypeSubClinRepID On (ImpType As SqlString, ClinRepID As SqlString);

Index TypePaadmIndex On (ImpType, Paadm);

/// 开始日期索引
Index IndexFromDate On (FromDate, FromTime, ImpType);

/// 结束日期索引
Index IndexToDate On (ToDate, ToTime, ImpType);

/// 预期结束日期索引
Index IndexWillToDate On WillToDate;

ClassMethod GetObjById(ID As %String) As DHCMed.IMP.ImpPatient
{
	New (ID)
	Set obj=##Class(DHCMed.IMP.ImpPatient).%OpenId(ID)
	Quit obj
}

/// w ##Class(DHCMed.IMP.ImpPatient).GetStringById(11,"^")
ClassMethod GetStringById(ID As %String, separete As %String) As %String
{
	New (ID,separete)
	Set return=""
	Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(ID)
	If $IsObject(objIMP)
	{
		Set Status=objIMP.Status
		Set Paadm=objIMP.Paadm
		Set PatientID=objIMP.PatientID
		Set SummaryInfo=objIMP.SummaryInfo
		Set TypeSubID=objIMP.ImpType
		Set FromDate=objIMP.FromDate
		Set:FromDate'="" FromDate=$zd(FromDate,3)
		Set FromTime=objIMP.FromTime
		Set:FromTime'="" FromTime=$zt(FromTime,2)
		Set ToDate=objIMP.ToDate
		Set:ToDate'="" ToDate=$zd(ToDate,3)
		Set ToTime=objIMP.ToTime
		Set:ToTime'="" ToTime=$zt(ToTime,2)
		Set DutyUser=objIMP.DutyUser
		Set:DutyUser'="" DutyUserDesc=$p($g(^SSU("SSUSR",DutyUser)),"^",2)
		Set DutyLoc=objIMP.DutyLoc
		Set:DutyLoc'="" DutyLocDesc=$p($g(^CTLOC(DutyLoc)),"^",2)
		Set UpdateUser=objIMP.UpdateUser
		Set:UpdateUser'="" UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
		Set UpdateDate=objIMP.UpdateDate
		Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		Set UpdateTime=objIMP.UpdateTime
		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,2)
		Set ResumeText=objIMP.ResumeText
		Set Prognosis=objIMP.Prognosis
		Set WillToDate=objIMP.WillToDate //Add By LiYang 2011-12-21 增加预计结束日期
		Set:WillToDate'="" WillToDate=$zd(WillToDate,3)
		If Prognosis'="" {
			Set objPrognosis=##Class(DHCMed.SS.Dictionary).%OpenId(Prognosis)
			If $IsObject(objPrognosis) {
				Set PrognosisDesc=objPrognosis.Description
			}
			If objPrognosis'="" Do objPrognosis.%Close()
		}
		
		
		Set StatusID=$o(^DHCMed.IMP.ImpPatStatusI("IndexParent"," "_ID,""),-1)
		Set objStatusInfo=##Class(DHCMed.IMP.ImpPatStatus).%OpenId(StatusID)
		If $IsObject(objStatusInfo){
			Set Reason=objStatusInfo.ResumeText
		}
		If objStatusInfo'="" Do objStatusInfo.%Close()
		
		Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(TypeSubID)
		If $IsObject(objTypeSub)
		{
			Set TypeSubDesc=objTypeSub.Description
			Set TypeID=objTypeSub.ParentID
			Set objType=##Class(DHCMed.IMP.PatientType).%OpenId(TypeID)
			If $IsObject(objType)
			{
				Set TypeDesc=objType.Description
			}
			If objType'="" Do objType.%Close()
		}
		If objTypeSub'="" Do objTypeSub.%Close()
		
		Set:separete="" separete="^"
		Set return=ID
		Set return=return_separete_Status
		Set return=return_separete_Paadm
		Set return=return_separete_PatientID
		Set return=return_separete_SummaryInfo
		Set return=return_separete_$g(TypeID)
		Set return=return_separete_$g(TypeDesc)
		Set return=return_separete_TypeSubID
		Set return=return_separete_$g(TypeSubDesc)
		Set return=return_separete_FromDate
		Set return=return_separete_FromTime
		Set return=return_separete_ToDate
		Set return=return_separete_ToTime
		Set return=return_separete_DutyUser
		Set return=return_separete_$g(DutyUserDesc)
		Set return=return_separete_UpdateUser
		Set return=return_separete_$g(UpdateUserDesc)
		Set return=return_separete_UpdateDate
		Set return=return_separete_UpdateTime
		Set return=return_separete_ResumeText
		Set return=return_separete_DutyLoc
		Set return=return_separete_$g(DutyLocDesc)
		Set return=return_separete_$g(Reason)
		Set return=return_separete_Prognosis
		Set return=return_separete_$g(PrognosisDesc)
		Set return=return_separete_WillToDate //Add By LiYang 2011-12-21 
	}
	Quit return
}

ClassMethod Update(arg As %String, Delimiter As %String = "^") As %Integer
{
	New (arg,Delimiter)
	Set return=0
	
	Set:$g(Delimiter)="" Delimiter=$c(1)
	Set ID=$p(arg,Delimiter,1)
	If ID="" {
		Set obj=##class(DHCMed.IMP.ImpPatient).%New()
	} Else {
		Set obj=##class(DHCMed.IMP.ImpPatient).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Paadm=$p(arg,Delimiter,2)
	Set obj.PatientID=$p(arg,Delimiter,3)
	Set obj.SummaryInfo=$p(arg,Delimiter,4)
	Set:$p(arg,Delimiter,5)'="" obj.FromDate=$zdh($p(arg,Delimiter,5),3)
	Set:$p(arg,Delimiter,6)'="" obj.FromTime=$zth($p(arg,Delimiter,6),1)
	Set obj.ImpType=$p(arg,Delimiter,7)
	Set obj.Status=$p(arg,Delimiter,8)
	Set obj.UpdateUser=$p(arg,Delimiter,9)
	Set obj.UpdateDate=+$h
	Set obj.UpdateTime=$p($h,",",2)
	Set obj.ResumeText=$p(arg,Delimiter,12)		
	Set obj.DutyUser=$p(arg,Delimiter,13)
	Set:$p(arg,Delimiter,14)'="" obj.ToDate=$zdh($p(arg,Delimiter,14),3)
	Set:$p(arg,Delimiter,15)'="" obj.ToTime=$zth($p(arg,Delimiter,15),1)
	Set obj.ClinRepID=$p(arg,Delimiter,16)
	Set obj.DutyLoc=$p(arg,Delimiter,17)
	Set obj.Prognosis=$p(arg,Delimiter,18)
	Set:$p(arg,Delimiter,19)'="" obj.WillToDate=$zdh($p(arg,Delimiter,19),3) //Add By LiYang 2011-12-21 
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set IMPID=obj.%Id()
		Set Status=obj.Status
		Set UpdateUser=obj.UpdateUser
		Set FromDate=obj.FromDate
		Set FromTime=obj.FromTime
		Set DutyUser=obj.DutyUser
		Set DutyLoc=obj.DutyLoc
		Set UpdateUser=obj.UpdateUser
		Set UpdateDate=obj.UpdateDate
		Set UpdateTime=obj.UpdateTime
		Set return=IMPID
		
		Set statusArg=""
		Set $p(statusArg,"^",2)=IMPID
		Set $p(statusArg,"^",3)=Status
		Set $p(statusArg,"^",4)=+$h
		Set $p(statusArg,"^",5)=$p($h,",",2)
		Set $p(statusArg,"^",6)=UpdateUser
		Set $p(statusArg,"^",7)=""
		Set flg=##class(DHCMed.IMP.ImpPatStatus).Update(statusArg,"^")
		
		//添加责任人日志
		If ID="" {
			Set DutyUserString=""
			Set DutyUserString=DutyUserString_$c(1)_IMPID
			Set DutyUserString=DutyUserString_$c(1)_FromDate
			Set DutyUserString=DutyUserString_$c(1)_FromTime
			Set DutyUserString=DutyUserString_$c(1)_DutyUser
			Set DutyUserString=DutyUserString_$c(1)_1
			Set DutyUserString=DutyUserString_$c(1)_"添加责任人,责任科室日志"
			Set DutyUserString=DutyUserString_$c(1)_UpdateUser
			Set DutyUserString=DutyUserString_$c(1)_UpdateDate
			Set DutyUserString=DutyUserString_$c(1)_UpdateTime
			Set DutyUserString=DutyUserString_$c(1)_DutyLoc
			Set flg=##class(DHCMed.IMP.DutyUser).Update(DutyUserString,$c(1))
		}
		
		/*//自动终结历史重点患者记录
		If ID="" {
			Set ImpTypeSub=obj.ImpType
			Set Paadm=obj.Paadm
			Set cIMPID=IMPID
			For {
				Set cIMPID=$o(^DHCMed.IMP.ImpPatientI("TypePaadmIndex",ImpTypeSub,Paadm,cIMPID),-1)
				Quit:(cIMPID="")||(cIMPID=0)
				Continue:cIMPID=IMPID
				
				Set cobjIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(cIMPID)
				If cobjIMP'="" Do cobjIMP.%Close()
				Set objStatus=##Class(DHCMed.SS.Dictionary).%OpenId(cobjIMP.Status)
				If objStatus'="" Do objStatus.%Close()
				Continue:objStatus.Code'="1"
				
				Set HisIMPString=cIMPID
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_UpdateDate
				Set HisIMPString=HisIMPString_"^"_UpdateTime
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_UpdateUser
				Set HisIMPString=HisIMPString_"^"_""
				Set HisIMPString=HisIMPString_"^"_""
				Set flg=..ModifyIMP(HisIMPString,"03")
			}
		}*/
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-08-12
/// Description:  修改重点患者数据
/// Table：       DHCMed.IMP.ImpPatient,DHCMed.IMP.ImpPatStatus
/// Input：       argInput 重点患者修改数据
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.IMP.ImpPatient).ModifyIMP("11^2^2010-08-10^00:30^2010-08-13^01:30^2221^备注测试^1^","1")
ClassMethod ModifyIMP(argInput As %String, argOperationCode) As %String
{
	New (argInput,argOperationCode)
	Set return=0
	
	Set ID=$p(argInput,"^",1)
	Set ImpType=$p(argInput,"^",2)
	Set FromDate=$p(argInput,"^",3)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate'="" FromDate=+FromDate
	Set FromTime=$p(argInput,"^",4)
	Set:FromTime[":" FromTime=$zth(FromTime,1)
	Set:FromTime'="" FromTime=+FromTime
	Set ToDate=$p(argInput,"^",5)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate'="" ToDate=+ToDate
	Set ToTime=$p(argInput,"^",6)
	Set:ToTime[":" ToTime=$zth(ToTime,1)
	Set:ToTime'="" ToTime=+ToTime
	Set DutyUser=$p(argInput,"^",7)
	Set ResumeText=$p(argInput,"^",8)
	Set UpdateUser=$p(argInput,"^",9)
	Set Reason=$p(argInput,"^",10)
	Set DutyLoc=$p(argInput,"^",11)
	Set Prognosis=$p(argInput,"^",12)
	Set WillToDate=$p(argInput,"^",13) //Add By LiYang 2011-12-21 
	Set:WillToDate'="" WillToDate=$zdh(WillToDate,3)
	Set objIMP=##class(DHCMed.IMP.ImpPatient).%OpenId(ID)
	If $IsObject(objIMP){
		 If argOperationCode="02" {  //修改标记信息
			Set objIMP.FromDate=FromDate
			Set objIMP.FromTime=FromTime
			Set objIMP.ToDate=ToDate
			Set objIMP.ToTime=ToTime
			Set objIMP.ImpType=ImpType
			Set objIMP.UpdateDate=+$h
			Set objIMP.UpdateTime=$p($h,",",2)
			Set objIMP.ResumeText=ResumeText
			Set objIMP.DutyUser=DutyUser
			Set objStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus",1,"") //Modified By LiYang 2012-07-04 将字典代码改为英文
			Set objIMP.Status=objStatus.%Id()
			Set objIMP.WillToDate=WillToDate
		} ElseIf argOperationCode="03" {  //终结标记
			Set objIMP.ToDate=ToDate
			Set objIMP.ToTime=ToTime
			Set objIMP.UpdateUser=UpdateUser
			Set objIMP.UpdateDate=+$h
			Set objIMP.UpdateTime=$p($h,",",2)
			Set objIMP.ResumeText=ResumeText
			Set objIMP.Prognosis=Prognosis
			Set objStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus",2,"") //Modified By LiYang 2012-07-04 将字典代码改为英文
			Set objIMP.Status=objStatus.%Id()
		} ElseIf argOperationCode="04" {  //退出标记
			Set objIMP.Status=3
			Set objIMP.UpdateUser=UpdateUser
			Set objIMP.UpdateDate=+$h
			Set objIMP.UpdateTime=$p($h,",",2)
			Set objIMP.ResumeText=ResumeText
			Set objStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus",3,"")
			Set objIMP.Status=objStatus.%Id()
		} ElseIf argOperationCode="05" {  //更换责任人
			Set objIMP.UpdateUser=UpdateUser
			Set objIMP.UpdateDate=+$h
			Set objIMP.UpdateTime=$p($h,",",2)
			Set objIMP.ResumeText=ResumeText
			Set objIMP.DutyUser=DutyUser
			
			Set DutyUserString=""
			Set DutyUserString=DutyUserString_$c(1)_objIMP.%Id()
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateDate
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateTime
			Set DutyUserString=DutyUserString_$c(1)_objIMP.DutyUser
			Set DutyUserString=DutyUserString_$c(1)_1
			Set DutyUserString=DutyUserString_$c(1)_"更换责任人"
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateUser
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateDate
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateTime
			Set DutyUserString=DutyUserString_$c(1)_""
			Set flg=##class(DHCMed.IMP.DutyUser).Update(DutyUserString,$c(1))
		} ElseIf argOperationCode="06" {  //更换责任科室
			Set objIMP.UpdateUser=UpdateUser
			Set objIMP.UpdateDate=+$h
			Set objIMP.UpdateTime=$p($h,",",2)
			Set objIMP.ResumeText=ResumeText
			Set objIMP.DutyUser=""
			Set objIMP.DutyLoc=DutyLoc
			
			Set DutyUserString=""
			Set DutyUserString=DutyUserString_$c(1)_objIMP.%Id()
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateDate
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateTime
			Set DutyUserString=DutyUserString_$c(1)_""
			Set DutyUserString=DutyUserString_$c(1)_1
			Set DutyUserString=DutyUserString_$c(1)_"更换责任科室"
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateUser
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateDate
			Set DutyUserString=DutyUserString_$c(1)_objIMP.UpdateTime
			Set DutyUserString=DutyUserString_$c(1)_objIMP.DutyLoc
			Set flg=##class(DHCMed.IMP.DutyUser).Update(DutyUserString,$c(1))
		} Else {
			Quit return
		}
	} Else {
		Quit return
	}
	Set sc=objIMP.%Save()
	Do objIMP.%Close()
	If $System.Status.IsError(sc) {       //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set InputSub=$c(1)_objIMP.%Id()_$c(1)_objIMP.Status_$c(1)_objIMP.UpdateDate_$c(1)_objIMP.UpdateTime_$c(1)_objIMP.UpdateUser_$c(1)_Reason
		Set flg=##class(DHCMed.IMP.ImpPatStatus).Update(InputSub,$c(1))
		
		Set return=objIMP.%Id()
	}
	
	Quit return
}

/*
/// ModifyStatus
/// ImpID:重点患者记录ID
/// NewStatusCode:新状态代码（DHCMed.SS.Dictionary）
/// OperateUser:操作员
/// ResumeText:备注（退回原因、删除原因）
/// 返回值：状态记录ID
ClassMethod ModifyStatus(ImpID As %String, NewStatusCode As %String, OperateUser As %String, ResumeText As %String, UpdateDate As %String, UpdateTime As %String) As %Integer
{
	n (ImpID , NewStatusCode , OperateUser, ResumeText , UpdateDate ,UpdateTime )
	s:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	s:UpdateTime["-" UpdateTime=$zth(UpdateTime,1)
	s:UpdateDate="" UpdateDate=+$h			// update by lyh 2010-6-3 取当前时间
	s:UpdateTime="" UpdateTime=$p($h,",",2)
	s objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(ImpID)
	q:$IsObject(objIMP)=0 -1
	s objStatusDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("重点病人状态",NewStatusCode,1)
	s flag=0
	s:$IsObject(objIMP)=0 flag=1
	d:flag=1 objIMP.%Close()
	i flag=1  d
	.k objIMP
	q:flag=1 -2
	
	s objIMP.Status=objStatusDic.%Id() //存储新状态
	d objIMP.%Save()
	d objIMP.%Close()
	k objIMP
	
	s objStatus=##class(DHCMed.IMP.ImpPatStatus).%New()
	s objStatus.ParentID=ImpID
	s objStatus.StatusID=objStatusDic.%Id()
	s objStatus.OperationDate=$s(UpdateDate="":+$h,1:UpdateDate)
	s objStatus.OperationTime=$s(UpdateTime="":$p($h,",",2),1:UpdateTime)
	s objStatus.OperationUser=OperateUser
	s objStatus.ResumeText=ResumeText
	s sc=objStatus.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=objStatus.%Id()
	}
	d objStatusDic.%Close()
	k objStatusDic
	q id
}

/// w ##class(DHCMed.IMP.ImpPatient).ModifyDutyUser(3,1,1,"Resume")
ClassMethod ModifyDutyUser(ImpID As %String, NewDutyUserID As %String, UpdateUser As %String, ResumeText As %String, UpdateDate As %String = "", UpdateTime As %String = "")
{
	New (ImpID,NewDutyUserID,UpdateUser,ResumeText,UpdateDate,UpdateTime)
	s:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	s:UpdateTime["-" UpdateTime=$zth(UpdateTime,1)
	s objImp=##Class(DHCMed.IMP.ImpPatient).%OpenId(ImpID)
	q:$IsObject(objImp)=0 -1
	s objImp.DutyUser=NewDutyUserID
	d objImp.%Save()
	d objImp.%Close()
	k objImp
	s arg=""
	s $p(arg,$c(1),1)=""
	s $p(arg,$c(1),2)=ImpID
	s $p(arg,$c(1),3)=+$h
	s $p(arg,$c(1),4)=NewDutyUserID
	s $p(arg,$c(1),5)=1
	s $p(arg,$c(1),6)=ResumeText
	s $p(arg,$c(1),7)=UpdateUser
	s $p(arg,$c(1),8)=$s(UpdateDate="":+$h,1:UpdateDate)
	s $p(arg,$c(1),9)=$s(UpdateTime="":+$p($h,",",2),1:UpdateTime)
	s ret=##class(DHCMed.IMP.DutyUser).Update(arg,$c(1))
	q ret
}

//w ##class(DHCMed.IMP.ImpPatient).%BuildIndices()

ClassMethod UpdateFields()
{
	New
	s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatientD(rowid)) q:rowid=""   d
	.s data=##class(DHCMed.IMP.ImpPatient).%OpenId(rowid)
	.s data.DutyUser=1
	.w data.%Save(),!
	q "OK"
}
*/
/// Creator：     zhufei
/// CreatDate：   2010-08-19
/// Description:  加标记前检查不同类型标记的互斥性
///               有互斥类型标记,不允许加新标记
/// Table：       
/// Input：       argEpisodeID 就诊号
///               argTypeSub   重患标记子类
/// Return：      return=0 允许加新标记,return>0 不允许加新标记
/// Test:         w ##class(DHCMed.IMP.ImpPatient).CheckNewIMPErr(argEpisodeID,argTypeSub)
ClassMethod CheckNewIMPErr(argEpisodeID As %String, argTypeSub As %String) As %String
{
	New (argEpisodeID,argTypeSub)
	Set return=0
	Quit:(argEpisodeID="")||(argTypeSub="") return
	
	Set $ZT="CheckNewIMPErrErr"
	
	Set objTmpTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(argTypeSub)
	If $IsObject(objTmpTypeSub)
	{
		Set TmpTypeSubCode=objTmpTypeSub.Code
	}
	If objTmpTypeSub'="" Do objTmpTypeSub.%Close()
	Set TmpTypeSubCode=$g(TmpTypeSubCode)
	Quit:TmpTypeSubCode="" return
	
	Set IMPID=0,Count=0
	For {
		Set IMPID=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",argEpisodeID,IMPID))
		Quit:IMPID=""
		Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(IMPID)
		If $IsObject(objIMP)
		{
			Set Status=objIMP.Status
			Set StatusCode=""
			Set StatusDesc=""
			Set objStatus=##Class(DHCMed.SS.Dictionary).%OpenId(Status)
			If $IsObject(objStatus)
			{
				Set StatusCode=objStatus.Code
				Set StatusDesc=objStatus.Description
			}
			If objStatus'="" Do objStatus.%Close()
			Continue:$g(StatusCode)'="1"  //初始状态
			
			Set TypeSub=objIMP.ImpType
			Set TypeSubCode=""
			Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(TypeSub)
			If $IsObject(objTypeSub)
			{
				Set TypeSubCode=objTypeSub.Code
			}
			If objTypeSub'="" Do objTypeSub.%Close()
			
			Set:TypeSubCode=TmpTypeSubCode Count=Count+1
			If (TmpTypeSubCode="01-01"){
				Set:$g(TypeSubCode)="01-02" Count=Count+1
			} ElseIf (TmpTypeSubCode="01-02") {
				Set:$g(TypeSubCode)="01-01" Count=Count+1
			} Else {
				//...
			}
		}
		If objIMP'="" Do objIMP.%Close()
	}
	
	Set:Count>0 return=1
	Quit return
	
CheckNewIMPErrErr
	Quit return
}

Storage Default
{
<Data name="ImpPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FromDate</Value>
</Value>
<Value name="3">
<Value>FromTime</Value>
</Value>
<Value name="4">
<Value>ImpType</Value>
</Value>
<Value name="5">
<Value>Paadm</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>SummaryInfo</Value>
</Value>
<Value name="10">
<Value>ToDate</Value>
</Value>
<Value name="11">
<Value>ToTime</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>DutyUser</Value>
</Value>
<Value name="16">
<Value>ClinRepID</Value>
</Value>
<Value name="17">
<Value>DutyLoc</Value>
</Value>
<Value name="18">
<Value>Prognosis</Value>
</Value>
<Value name="19">
<Value>WillToDate</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.ImpPatientD</DataLocation>
<DefaultData>ImpPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.ImpPatientD</IdLocation>
<IndexLocation>^DHCMed.IMP.ImpPatientI</IndexLocation>
<StreamLocation>^DHCMed.IMP.ImpPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
