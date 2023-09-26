Import sqluser

/// Creator: 	yuliping
/// CreateDate: 2020-03-31
/// Descript: 	不良事件批注
Class web.DHCADVReportNote Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存批注
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 报告ID^类型ID^元素ID^批注内容^userId,NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).saveRepNotes("","")
ClassMethod saveRepNotes(ListData, NoteId) As %String
{
	n (ListData,NoteId)
	i NoteId="" d
	.s NoteId=..InsRepNotes(ListData)
	e  d
	.s NoteId=..UpdRepNotes(NoteId, ListData)
	q NoteId
}

/// Description: 插入批注
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 报告ID^类型ID^元素ID^批注内容^userId,NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).InsRepNotes("53^110^SecurityEventType^测试批注内容测试批注内容测试批注内容测试批注内容^10209")
ClassMethod InsRepNotes(ListData) As %String
{
	n (ListData)
	Ts
	//插入批注表
	s NoteId=..InsertNotes(ListData)
	i NoteId<0 Tro
	q:NoteId<0 NoteId
	
	Tc
	q NoteId
}

/// Description: 插入批注sql
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 报告ID^类型ID^元素ID^批注内容^userId,NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).InsertNotes("53^^^^","")
ClassMethod InsertNotes(ListData)
{
	n (ListData)

	s RecordId=$p(ListData,"^",1)							///表单记录 ID
	i $d(^DHCADVMASTER(0,"FormRec",RecordId))  d
	.s MasterId=$o(^DHCADVMASTER(0,"FormRec",RecordId,""))	///判断是不是新版，是新版用masterID
	e  s MasterId=RecordId 
	
	s TypeId=$p(ListData,"^",2)								///报告类型 ID
	s Field=$p(ListData,"^",3)								///元素ID
	s Notes=$p(ListData,"^",4)								///批注内容
	s NoteUserId=$p(ListData,"^",5)							///批注人
	s noteDate=+$H   		            					///批注日期
	s noteTime=$p($H,",",2)             					///批注时间
	&SQL(Insert Into DHC_MedAdvRepNotes(MEDARN_Pointer,MEDARN_Type,MEDARN_FormDicField,MEDARN_Notes,MEDARN_AuditDate,MEDARN_AuditTime,MEDARN_AntUser)
		values(:MasterId,:TypeId,:Field,:Notes,:noteDate,:noteTime,:NoteUserId))
	
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Description: 修改批注 
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 报告ID^类型ID^元素ID^批注内容^userId,NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).UpdRepNotes(1,"53^110^SecurityEventType^dddddd^10209")
ClassMethod UpdRepNotes(NoteId, ListData) As %String
{
	n (NoteId,ListData)
	Ts 
	//修改批注
	s NoteId=..updateNotes(NoteId,ListData)
	i NoteId<0 Tro
	q:NoteId<0 NoteId
	
	Tc
	q NoteId
}

/// Description: 修改批注sql ,只修改内容和时间
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 报告ID^类型ID^元素ID^批注内容^userId,NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).InsertNotes("53^^^^","")
ClassMethod updateNotes(NoteId, ListData) As %String
{
	
	n (NoteId,ListData)
	s UserId=$list(^User.DHCMedAdvRepNotesD(NoteId),8)
	s Notes=$p(ListData,"^",4)								///批注内容
	s NoteUserId=$p(ListData,"^",5)							///批注人
	q:UserId'=NoteUserId "-11"								///当前修改人和批注人不一致不允许修改
	s noteDate=+$H   		            					///批注日期
	s noteTime=$p($H,",",2)             					///批注时间

	&SQL(Update DHC_MedAdvRepNotes Set MEDARN_Notes=:Notes,MEDARN_AuditDate=:noteDate,MEDARN_AuditTime=:noteTime Where MEDARN_RowID=:NoteId)
	i SQLCODE'=0 q SQLCODE
	q +%ROWID
}

/// Description: 删除sql
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).deleNotes("1")
ClassMethod deleNotes(NoteId)
{
	n (NoteId)
	
	&SQL(delete from DHC_MedAdvRepNotes where MEDARN_RowID=:NoteId)
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	Q SQLCODE
}

/// Description: 删除
/// Creator:     yuliping
/// CreateDate:  2020-03-31  
/// Input:  	 NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).deleteNotes("1")
ClassMethod deleteNotes(NoteId)
{
	n (NoteId)
	Ts 
	//删除批注
	s Err=..deleNotes(NoteId)
	i Err'=0 Tro
	q:Err'=0 "-11"
	
	Tc
	q Err
}

/// Description: 取批注信息
/// Creator:     yuliping
/// CreateDate:  2020-04-01 
/// Input:  	 NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).jsonNotes("100","1","53","110","")
ClassMethod jsonNotes(rows = 100, page = 1, recordId, typeId, formDicId)
{
	n (rows,page,recordId,typeId,formDicId,%session)

	k TmpArr
	S End = page*rows
	S Start=(page-1)*rows+1

	d ..getNotesList(recordId,typeId,formDicId,.TmpArr)
	
	s allNum=$o(TmpArr(""),-1)
	q:allNum="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	;q:TmpArr="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	
	
	s title="NoteId^Pointer^Type^DicField^AuditDate^Notes^AntUser^userName"
	s count=0
    w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(allNum) //输出json前缀串

	s index=""
	f  s index=$o(TmpArr(index)) q:index=""  d
	.s count=count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(title,TmpArr(index))
	.e  w ","_##class(web.DHCADVJSONCOMMON).getJsonData(title,TmpArr(index))
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符	
	k TmpArr
	q ""
}

/// Description: 取备注数据,存入数组
/// Creator:     yuliping
/// CreateDate:  2020-04-01 
ClassMethod getNotesList(recordId, typeId, formDicId, TmpArr)
{
	
	n (recordId,typeId,formDicId,TmpArr,%session)
	
	i $d(^DHCADVMASTER(0,"FormRec",recordId))  d
	.s masterId=$o(^DHCADVMASTER(0,"FormRec",recordId,""))	///判断是不是新版，是新版用masterID
	e  s masterId=RecordId 

	s num=0
	s NoteId=""
	f  s NoteId=$o(^User.DHCMedAdvRepNotesI("IndexParef"," "_masterId," "_typeId,NoteId)) q:NoteId=""  d
	.s dicId=$list(^User.DHCMedAdvRepNotesD(NoteId),4)
	.q:(dicId'=formDicId)&&(formDicId'="")
	.s num=num+1
	.s Pointer=$List(^User.DHCMedAdvRepNotesD(NoteId),2) 	 //masterID
	.s Type=$List(^User.DHCMedAdvRepNotesD(NoteId),3)		 //类型ID
	.s DicField=$List(^User.DHCMedAdvRepNotesD(NoteId),4)	 //元素id
	.s AuditDate=$List(^User.DHCMedAdvRepNotesD(NoteId),5)   //日期
	.s AuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AuditDate)
	.s AuditTime=$List(^User.DHCMedAdvRepNotesD(NoteId),6)	 //时间
	.s AuditTime=$zt(AuditTime,1)
	.s Notes=$List(^User.DHCMedAdvRepNotesD(NoteId),7)		 //批注内容
	.s AntUser=$List(^User.DHCMedAdvRepNotesD(NoteId),8)	 //批注人id
	.S userName=$p(^SSU("SSUSR",AntUser),"^",2)				 //批注人姓名
	.S userName=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",userName)
	.s TmpArr(num)=NoteId_"^"_Pointer_"^"_Type_"^"_DicField_"^"_AuditDate_" "_AuditTime_"^"_Notes_"^"_AntUser_"^"_userName

	q ""
}

/// Description: 取批注元素id,去重
/// Creator:     yuliping
/// CreateDate:  2020-04-01 
/// Input:  	 NoteId
/// Return:  	  
/// Others: 	 W ##class(web.DHCADVReportNote).jsonOnlyNotes("53","110")
ClassMethod jsonOnlyNotes(recordId, typeId)
{
	n (rows,page,recordId,typeId)

	k TmpOnlyArr
	d ..getNotesOnlyList(recordId,typeId,.TmpOnlyArr)
	w "["
	s title="NoteId^DicField"
	s count=0
	s index=""
	f  s index=$o(TmpOnlyArr(index)) q:index=""  d
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(title,TmpOnlyArr(index))
	.e  w ","_##class(web.DHCADVJSONCOMMON).getJsonData(title,TmpOnlyArr(index))
	
	w "]"   //输出json结尾符	
	k TmpOnlyArr
	q ""
}

/// Description: 取备注数据,存入数组 去重
/// Creator:     yuliping
/// CreateDate:  2020-04-01 
ClassMethod getNotesOnlyList(recordId, typeId, TmpOnlyArr)
{
	
	n (recordId,typeId,TmpOnlyArr)
	
	i $d(^DHCADVMASTER(0,"FormRec",recordId))  d
	.s masterId=$o(^DHCADVMASTER(0,"FormRec",recordId,""))	///判断是不是新版，是新版用masterID
	e  s masterId=RecordId 

	s num=0
	s NoteId=""
	f  s NoteId=$o(^User.DHCMedAdvRepNotesI("IndexParef"," "_masterId," "_typeId,NoteId)) q:NoteId=""  d
	.s dicId=$list(^User.DHCMedAdvRepNotesD(NoteId),4)
	.s num=num+1
	.s Pointer=$List(^User.DHCMedAdvRepNotesD(NoteId),2) 	 //masterID
	.s Type=$List(^User.DHCMedAdvRepNotesD(NoteId),3)		 //类型ID
	.s DicField=$List(^User.DHCMedAdvRepNotesD(NoteId),4)	 //元素id
	.s AuditDate=$List(^User.DHCMedAdvRepNotesD(NoteId),5)   //日期
	.s AuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AuditDate)
	.s AuditTime=$List(^User.DHCMedAdvRepNotesD(NoteId),6)	 //时间
	.s AuditTime=$zt(AuditTime,1)
	.s Notes=$List(^User.DHCMedAdvRepNotesD(NoteId),7)		 //批注内容
	.s AntUser=$List(^User.DHCMedAdvRepNotesD(NoteId),8)	 //批注人id
	.S userName=$p(^SSU("SSUSR",AntUser),"^",2)				 //批注人姓名
	.s TmpOnlyArr(DicField)=NoteId_"^"_DicField

	q ""
}

}
