/// Creator:高姗姗
/// CreatDate:2020-12-21
/// Description：文献管理
Class web.CDSS.CMKB.DocuManage Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2020-12-21
/// Description:获得文献管理表内容
/// Table: CT.WDT.CDSS.DocuManage
/// Input: Desc名称, EngDesc英文名称, Disease诊断, Dept科室, StartDate开始日期, EndDate截止日期, KeyWords关键词, Institution机构, Month年月, Source出处, User操作人, Reviewer审核人, State状态
/// Return:返回所有文献管理表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetList","","","","","","","","","","","","","","","","2型糖尿病")
Query GetList(Id, Desc, EngDesc, Disease, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type, User, Reviewer, State, Words) As %Query(ROWSPEC = "RowId,DocuCode,DocuDesc,DocuEngDesc,DocuPath,DocuKeyWords,DocuType,DocuInstitution,DocuSource,DocuMonth,DocuState,DocuModifyDate,DocuModifyUser,DocuReviewer,JoinDisease,JoinDept,JoinWords,AgencyPriority")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id, Desc, EngDesc, Disease, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type, User, Reviewer, State, Words) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (Id'=""){
	 	s RowId=Id
	 	s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称 
		s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
		s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
		s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
		s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
		s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
		s:DocuInstitutionDr="" DocuInstitution=""
		s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)
		s AgencyPriority=""
		s:DocuInstitutionDr'="" AgencyPriority=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),4)	//机构优先级
		s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
		s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
		s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
		s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
		s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
		s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
		s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
		
		//关联诊断
		s JoinDisease=""
		s DiseaseDR=""
		for {
			s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
			s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
			if (JoinDisease=""){
				s JoinDisease=DiseaseDesc
			}else{
				s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
			}
		}
		//关联诊断条件
		s JoinWords=""
		s WordsDR=""
		for {			//取识别条件数据
			s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,WordsDR)) q:WordsDR=""
			
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			if (JoinWords=""){
				s JoinWords=WordsDesc
			}else{
				s JoinWords=JoinWords_",<br>"_WordsDesc
			}
			
		}
		s JoinWordsDR=""
		s WordsDR=""
		for {			//取识别条件为空，诊断条件不为空的数据
			s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			
			if (JoinWords=""){
				s JoinWords=WordsDesc
			}else{
				s JoinWords=JoinWords_",<br>"_WordsDesc
			}
		}
		
		//关联科室
		s JoinDept=""
		s DeptDR=""
		for{
			s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
			s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
			if (JoinDept=""){
				s JoinDept=DeptName
			}else{
				s JoinDept=JoinDept_",<br>"_DeptName
			}	
		}
		
		d OutputRow
	}
	else{
	 	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
	 	s:EngDesc'="" EngDesc=$ZCONVERT(EngDesc,"U") //转换成大写
	 	s:KeyWords'="" KeyWords=$ZCONVERT(KeyWords,"U") //转换成大写
	 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
	 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
	 	s:Disease'="" Disease="<"_Disease_">"
	 	s:Words'="" Words="<"_Words_">"
	 	s:Dept'="" Dept="<"_Dept_">"
	 	s:EndDate="" date=EndDate
		s:EndDate'="" date=EndDate_"00:00:00"
		for{
			s date=$o(^CT.WDT.CDSS.DocuManageI("DateIndex",date),-1) q:date=""
			q:((StartDate'="")&&($ZDH(date,3)<$ZDH(StartDate,3)))
			s RowId=""
			for
			{
				s RowId = $o(^CT.WDT.CDSS.DocuManageI("DateIndex",date,RowId),-1)
				q:RowId=""
				s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
				s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
				s PINYINDesc=""
				s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
				s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
				s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
				s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
				s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
				s:DocuInstitutionDr="" DocuInstitution=""
				s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)
				s AgencyPriority=""
				s:DocuInstitutionDr'="" AgencyPriority=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),4)	//机构优先级
				s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
				s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
				s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
				s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
				s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
				s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
				s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
				//关联诊断
				s JoinDisease="",DiseaseStr=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
					s DiseaseStr=DiseaseStr_"<"_DiseaseDR_">"
					
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//诊断条件
				s JoinWords="",WordsStr=""
				s WordsDR=""
				for {
					s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,WordsDR)) q:WordsDR=""
					s WordsStr=WordsStr_"<"_WordsDR_">"
					s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
					if (JoinWords=""){
						s JoinWords=WordsDesc
					}else{
						s JoinWords=JoinWords_",<br>"_WordsDesc
					}
				}
				s JoinWordsDR=""
				s WordsDR=""
				for {			//取识别条件为空，诊断条件不为空的数据
					s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
					s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
					s WordsStr=WordsStr_"<"_WordsDR_">"
					s WordsDesc=""
					s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
					
					if (JoinWords=""){
						s JoinWords=WordsDesc
					}else{
						s JoinWords=JoinWords_",<br>"_WordsDesc
					}
				}
				
				//关联科室
				s JoinDept="",DeptStr=""
				s DeptDR=""
				for{
					s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
					s DeptStr=DeptStr_"<"_DeptDR_">"	
					
					s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
					if (JoinDept=""){
						s JoinDept=DeptName
					}else{
						s JoinDept=JoinDept_",<br>"_DeptName
					}	
				}
				
				if (($ZCONVERT(DocuDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&(($ZCONVERT(DocuEngDesc,"U")[EngDesc)||(EngDesc=""))&&(($ZCONVERT(DocuKeyWords,"U")[KeyWords)||(KeyWords=""))&&((DocuType=Type)||(Type=""))&&((DocuInstitutionDr=Institution)||(Institution=""))&&((DocuMonth=Month)||(Month=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((DocuModifyUser=User)||(User=""))&&((DocuReviewer=Reviewer)||(Reviewer=""))&&((DocuState=State)||(State=""))&&((WordsStr[Words)||(Words=""))&&((DeptStr[Dept)||(Dept="")){
			  		d OutputRow
			  	}
			}
		}
	}    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DocuCode,DocuDesc,DocuEngDesc,DocuPath,DocuKeyWords,DocuType,DocuInstitution,DocuSource,DocuMonth,DocuState,DocuModifyDate,DocuModifyUser,DocuReviewer,JoinDisease,JoinDept,JoinWords,AgencyPriority)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2020-12-23
/// Description：查询文献
/// Table：CT.WDT.CDSS.DocuManage
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "RowId,DocuDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
	d OutputRowCmb
 }
 else
 {
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s RowId=""
	for{  
		s RowId=$o(^CT.WDT.CDSS.DocuManageD(RowId),-1) q:RowId=""  
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
		s PINYINDesc=""
		s:desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  

		if ((($ZCONVERT(DocuDesc,"U")[desc)||(PINYINDesc[desc))&(($ZCONVERT(DocuDesc,"U")[q)||(PINYINDesc[q))) {
			d OutputRowCmb
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,DocuDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：石萧伟
/// CreatDate: 2022-05-18
/// Description：查询已经存放pdf的文献
/// Table：CT.WDT.CDSS.DocuManage
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetExistDocForCmb1","","","")
Query GetExistDocForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "RowId,DocuDesc")
{
}

ClassMethod GetExistDocForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
	d OutputRowCmb
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s RowId=""
	for{  
		s RowId=$o(^CT.WDT.CDSS.DocuManageD(RowId),-1) q:RowId=""  
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
		s PINYINDesc=""
		s:desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
		s IsExistPDF = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\CDSS\\Doc\\"_DocuDesc_".pdf")
		if ((($ZCONVERT(DocuDesc,"U")[desc)||(PINYINDesc[desc))&(($ZCONVERT(DocuDesc,"U")[q)||(PINYINDesc[q))&(IsExistPDF=1)) {
			d OutputRowCmb
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,DocuDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetExistDocForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExistDocForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetExistDocForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExistDocForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2020-12-21
/// Description:获得文献源文件列表
/// Table: CT.WDT.CDSS.DocuManage
/// Input: Id  文献Id
/// Return:返回文献源文件内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetFileList","7315")
Query GetFileList(RowId) As %Query(ROWSPEC = "FileName,FileType")
{
}

ClassMethod GetFileListExecute(ByRef qHandle As %Binary, RowId) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
    if (RowId'=""){
	    s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
	    if (DocuPath'=""){
		    s Len=$Length(DocuPath,"^")
		    for i=1:1:Len{
				s FileName=$p(DocuPath,"^",i)
				s FileType=$p(FileName,".",*)
				d OutputRow   
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(FileName,FileType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFileListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFileListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFileListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFileListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2021-01-19
/// Description：查询编辑人
/// Table：CT.WDT.CDSS.DocuManage
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetModifyUserForCmb1","")
Query GetModifyUserForCmb1(q As %String) As %Query(ROWSPEC = "UserName")
{
}

ClassMethod GetModifyUserForCmb1Execute(ByRef qHandle As %Binary, q As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s UserName=""
	for{  
		s UserName=$o(^CT.WDT.CDSS.DocuManageI("ModifyUserIndex",UserName)) q:UserName=""  
		s PINYINDesc=""
		s:q'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserName)  

		if ((($ZCONVERT(UserName,"U")[q)||(PINYINDesc[q))) {
			d OutputModifyUserCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputModifyUserCmb
    set Data=$lb(UserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetModifyUserForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModifyUserForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetModifyUserForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModifyUserForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2021-01-19
/// Description：查询审核人
/// Table：CT.WDT.CDSS.DocuManage
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetReviewerForCmb1","")
Query GetReviewerForCmb1(q As %String) As %Query(ROWSPEC = "UserName")
{
}

ClassMethod GetReviewerForCmb1Execute(ByRef qHandle As %Binary, q As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s UserName=""
	for{  
		s UserName=$o(^CT.WDT.CDSS.DocuManageI("ReviewerIndex",UserName)) q:UserName=""  
		continue:(UserName=-100000000000000)
		s PINYINDesc=""
		s:q'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserName)  

		if ((($ZCONVERT(UserName,"U")[q)||(PINYINDesc[q))) {
			d OutputReviewerCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReviewerCmb
    set Data=$lb(UserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetReviewerForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReviewerForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReviewerForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReviewerForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:高姗姗
/// CreateDate:2020-12-25    
/// Table: CT.WDT.CDSS.DocuManage
/// w ##class(web.CDSS.CMKB.DocuManage).FormValidate("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	s flag="",flagc=""
	s:desc'="" flagc=$d(^CT.WDT.CDSS.DocuManageI("DescIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:desc'="" idc=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",desc,0))	
		if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:高姗姗
/// CreatDate:2020-12-25
/// Description:保存文献管理
/// Table: CT.WDT.CDSS.DocuManage
/// Input: eobj 文献管理实体对象
/// others:w ##class(web.CDSS.CMKB.DocuManage).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DocuManage)
{
	s $zt="ERROR"
	s result=""

	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.RowId,eobj.DocuDesc)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该文献已经存在'}"
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DocuManage).%New()
			s obj.DocuCode = ..GetLastCode()
			s obj.DocuState="编辑中"
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DocuManage).%OpenId(eobj.RowId)
			
			s bobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
			s bobj.DocuCode = obj.DocuCode
			s bobj.DocuDesc = obj.DocuDesc
			s bobj.DocuEngDesc = obj.DocuEngDesc
			s bobj.DocuPath = obj.DocuPath
			s bobj.DocuKeyWords = obj.DocuKeyWords
			s bobj.DocuType = obj.DocuType
			s:obj.DocuInstitution'="" bobj.DocuInstitution = obj.DocuInstitution.%Id()
			s:obj.DocuInstitution="" bobj.DocuInstitution = ""
			s bobj.DocuSource = obj.DocuSource
			s bobj.DocuMonth = obj.DocuMonth
			s bobj.DocuAssociation = obj.DocuAssociation
			s bobj.DocuState = obj.DocuState
			s bobj.DocuModifyDate = obj.DocuModifyDate
			s bobj.DocuModifyUser = obj.DocuModifyUser
			s bobj.DocuReviewer = obj.DocuReviewer
		}
		
		s obj.DocuDesc =##class(web.DHCBL.BDP.FunLib).Util(eobj.DocuDesc) 
		s obj.DocuEngDesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.DocuEngDesc)   
		s obj.DocuKeyWords = ##class(web.DHCBL.BDP.FunLib).Util(eobj.DocuKeyWords)
		s obj.DocuType = eobj.DocuType
		d:eobj.DocuInstitution'="" obj.DocuInstitutionSetObjectId(eobj.DocuInstitution)
		d:eobj.DocuInstitution="" obj.DocuInstitutionSetObjectId("")
		s obj.DocuSource = ##class(web.DHCBL.BDP.FunLib).Util(eobj.DocuSource)
		s obj.DocuMonth = eobj.DocuMonth
		s obj.DocuAssociation = eobj.DocuAssociation
		s obj.DocuModifyDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			
			d ##class(web.CDSS.CMKB.DocuJoinDisease).SaveData(id,eobj.Words) //关联诊断条件保存
			d ##class(web.CDSS.CMKB.DocuJoinDept).SaveData(id,eobj.Dept) //关联科室保存
			
			Tc
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuManage","CT.WDT.CDSS.DocuManage","文献管理",id,eobj.DocuDesc,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuManage","CT.WDT.CDSS.DocuManage","文献管理",eobj.RowId,eobj.DocuDesc,"U",eobj,bobj)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献管理","web.CDSS.CMKB.DocuManage","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献管理","web.CDSS.CMKB.DocuManage","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator：高姗姗
/// CreatDate: 2020-12-29
/// Description:状态修改
/// Input:state操作描述
/// Table：CT.WDT.CDSS.DocuManage
/// Other: w ##class(web.CDSS.CMKB.DocuManage).UpdateState()
ClassMethod UpdateState(id, state) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
	if (state="审核"){ //点击审核记录审核人
		s eobj.DocuReviewer = $Get(%session.Data("LOGON.USERNAME"))
	}
	s:state="提交" eobj.DocuState="审核中"
	s:state="审核" eobj.DocuState="审核中"
	s:state="不通过" eobj.DocuState="不通过"
	s:state="上线" eobj.DocuState="上线"
	s:state="下线" eobj.DocuState="已下线"
	
	s obj=##class(CT.WDT.CDSS.DocuManage).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
	s bobj.DocuState = obj.DocuState
	s bobj.DocuModifyDate = obj.DocuModifyDate
	s bobj.DocuModifyUser = obj.DocuModifyUser
	s bobj.DocuReviewer = obj.DocuReviewer
			
	s obj.DocuReviewer=eobj.DocuReviewer
	s obj.DocuState=eobj.DocuState
	s obj.DocuModifyDate = $zdt($h,3)
	s obj.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuManage","CT.WDT.CDSS.DocuManage","文献管理",id,obj.DocuDesc_"&&"_state,"U",eobj,bobj)
	}
	else{
		s result = "{success:'false'}" 
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2020-12-29
/// Description:修改路径
/// Table：CT.WDT.CDSS.DocuManage
/// Other: w ##class(web.CDSS.CMKB.DocuManage).UpdatePath()
ClassMethod UpdatePath(eobj As web.CDSSEntity.CMKB.DocuManage) As %String
{
	s result=""
	s path=##class(web.DHCBL.BDP.FunLib).Util(eobj.DocuPath)
	s obj=##class(CT.WDT.CDSS.DocuManage).%OpenId(eobj.RowId)
	s DocuPath = obj.DocuPath //文献路径
	if (eobj.PathFlag="A"){ //上传新增
		s Operation="文件上传"
		if (DocuPath=""){
			s eobj.DocuPath=path
		}	
		else{
			s eobj.DocuPath=DocuPath_"^"_path
		}
	}
	if (eobj.PathFlag="D"){ //删除
		s Operation="文件删除"
		s resPath=""
		s len=$Length(DocuPath,"^")
		for i=1:1:len{
			s DPath=$p(DocuPath,"^",i)
			continue:(DPath=path)
			if (resPath=""){
				s resPath=DPath	
			}
			else{
				s resPath=resPath_"^"_DPath	
			}
		}
		s eobj.DocuPath=resPath
		
	}
	s bobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
	s bobj.DocuPath = obj.DocuPath
	s bobj.DocuModifyDate = obj.DocuModifyDate
	s bobj.DocuModifyUser = obj.DocuModifyUser
	
	s obj.DocuPath=eobj.DocuPath
	s obj.DocuModifyDate = $zdt($h,3)
	s obj.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuManage","CT.WDT.CDSS.DocuManage","文献管理",eobj.RowId,obj.DocuDesc_"&&"_Operation,"U",eobj,bobj)
	}
	else{
		s result = "{success:'false'}" 
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2020-12-25
/// Description:代码自动生成  DM000000 代码最大值加1
/// Table：CT.WDT.CDSS.DocuManage
/// Other: w ##class(web.CDSS.CMKB.DocuManage).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=8    //代码长度
  	s StartCode="DM"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s MKBTBRowId=0, preCode=""    //寻找符合规则的最大的代码
	s preCode=$tr($o(^CT.WDT.CDSS.DocuManageI("CodeIndex",""),-1)," ","")
	if (preCode="")   //如果没有符合规则的代码，则生成第一个
	{
		s zeroLen=CodeLen-StartCodeLen
		s zeroStr=""
		s count=0
		for
		{
			s count=count+1
			q:count>zeroLen
			s zeroStr=zeroStr_"0"
		}
		s preCode=StartCode_zeroStr
	}
	s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
	s CodeNumLen=$Length(CodeNum)     //数字的长度
	s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合
	q code
}

/// Creator：高姗姗
/// CreatDate: 2020-12-25
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.DocuManage
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.DocuManage).OpenData("1")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
	s pobj = ##class(CT.WDT.CDSS.DocuManage).%OpenId(RowId)
	s eobj.RowId = RowId
	s eobj.DocuDesc = pobj.DocuDesc  
	s eobj.DocuEngDesc = pobj.DocuEngDesc  
	s eobj.DocuKeyWords = pobj.DocuKeyWords  
	s eobj.DocuType = pobj.DocuType  
	s:pobj.DocuInstitution'="" eobj.DocuInstitution = pobj.DocuInstitution.%Id() 
	s:pobj.DocuInstitution="" eobj.DocuInstitution = ""
	s eobj.DocuSource = pobj.DocuSource 
	s eobj.DocuMonth = pobj.DocuMonth  
	s eobj.DocuAssociation = pobj.DocuAssociation  
	s eobj.DocuState = pobj.DocuState

	d pobj.%Close()	
	k pobj	
	s str = eobj.JsonS()
		
	q str
}

/// Creator:高姗姗
/// CreatDate:2020-12-28
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.CDSS.CMKB.DocuManage).GetRefFlag(8)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
    
    s return="0^未被引用可删除！"
	s RowId=""
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DocuManageD(RowId))
		q:RowId=""
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
		s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
		continue:(DocuAssociation="")
		s len=$Length(DocuAssociation,",")
		for i=1:1:len{
			if (id=$p(DocuAssociation,",",i)){
				if (myInfo=""){
					s myInfo="<文献管理V2.0--"_DocuDesc	
				}else{
					s myInfo=myInfo_" & "_DocuDesc	
				}
			}
		}
	}
	s:myInfo'="" myInfo=myInfo_">"
	
	
	s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(id)),3) //中文文献名称  
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleResult).GetDocuRefFlag(DocuDesc)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2020-12-28
/// Description:删除文献管理内容
/// Table: CT.WDT.CDSS.DocuManage
/// Input:id
/// others:w ##class(web.CDSS.CMKB.DocuManage).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	//改为前台调用
#;	s re=##class(web.CDSS.CMKB.DocuManage).GetRefFlag(id)
#;    s RefFlag=$p(re,"^",1)
#;    if (RefFlag'=0){
#;        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
#;    }
#;    else
#;    {
		s obj=##class(CT.WDT.CDSS.DocuManage).%OpenId(id)	
		s bobj = ##class(web.CDSSEntity.CMKB.DocuManage).%New()
		s bobj.DocuCode = obj.DocuCode
		s bobj.DocuDesc = obj.DocuDesc
		s bobj.DocuEngDesc = obj.DocuEngDesc
		s bobj.DocuPath = obj.DocuPath
		s bobj.DocuKeyWords = obj.DocuKeyWords
		s bobj.DocuType = obj.DocuType
		s:obj.DocuInstitution'="" bobj.DocuInstitution = obj.DocuInstitution.%Id()
		s:obj.DocuInstitution="" bobj.DocuInstitution = ""
		s bobj.DocuSource = obj.DocuSource
		s bobj.DocuMonth = obj.DocuMonth
		s bobj.DocuAssociation = obj.DocuAssociation
		s bobj.DocuState = obj.DocuState
		s bobj.DocuModifyDate = obj.DocuModifyDate
		s bobj.DocuModifyUser = obj.DocuModifyUser
		s bobj.DocuReviewer = obj.DocuReviewer

		Ts
		s sc=##class(CT.WDT.CDSS.DocuManage).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s JDeptId=""
			for{
				s JDeptId=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuIndex",id,JDeptId)) q:JDeptId=""
				//关联科室删除
				s scDelJDept=##class(CT.WDT.CDSS.DocuJoinDept).%DeleteId(JDeptId)
				If $$$ISERR(scDelJDept)
				{	
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDelJDept)_"'}" 
					Trollback
				}
			}
			s JDisId=""
			for{
				s JDisId=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",id,JDisId)) q:JDisId=""
				//关联诊断删除
				s scDelJDis=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(JDisId)
				If $$$ISERR(scDelJDis)
				{	
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDelJDis)_"'}" 
					Trollback
				}
			}
			
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuManage","CT.WDT.CDSS.DocuManage","文献管理",id,bobj.DocuDesc,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
    //}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description:获得关键词列表
/// Table: CT.WDT.CDSS.DocuManage
/// Input: DocuDR 
/// Return:返回关键词列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetKeyWordsList","2")
Query GetKeyWordsList(DocuDR) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetKeyWordsListExecute(ByRef qHandle As %Binary, DocuDR) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DocuDR'=""){
		s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),6)
		s Len=$Length(DocuKeyWords,",")
		for i=1:1:Len{
			s Desc=$p(DocuKeyWords,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetKeyWordsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKeyWordsListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetKeyWordsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKeyWordsListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description:获得关联文献列表
/// Table: CT.WDT.CDSS.DocuManage
/// Input: DocuDR 
/// Return:返回关联文献列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetAssociationList","")
Query GetAssociationList(DocuDR) As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod GetAssociationListExecute(ByRef qHandle As %Binary, DocuDR) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DocuDR'=""){
		s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),11)
		s Len=$Length(DocuAssociation,",")
		for i=1:1:Len{
			s RowId=$p(DocuAssociation,",",i)
			continue:(RowId="")
			s Desc=$lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3)
			d OutputRowAssociation
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAssociation
	set Data=$lb(RowId,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAssociationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssociationListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAssociationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssociationListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 石萧伟
/// 取平台配置的ftp开启配置
/// w ##class(web.CDSS.CMKB.DocuManage).findFTPFlag()
ClassMethod findFTPFlag() As %String
{
	s flag="false"
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPPlatformConfig||FindStr")
    i ($IsObject(myobj)){
		//取index
		s id=""
		s id=$o(^User.BDPConfigI("ConfigDescI"," 是否开启FTP配置",0))
		s:id'="" flag=$LISTGET($G(^User.BDPConfigD(id)),3)
		q flag	    
     }
     else 
     {
	     q "false"
	 }
}

/// 石萧伟
/// 获取平台配置发图片用户名密码及端口号
/// "127.0.0.1^dhcbdp^1^21"   //固定配置：IP，User，pass，port
/// w ##class(web.CDSS.CMKB.DocuManage).findPortS()
ClassMethod findPortS()
{
	s ipDesc=""
	s userDesc=""
	s passDesc=""
	s portDesc=""
	s ipId=$o(^User.BDPConfigI("ConfigDescI"," 附件服务器IP",0))
	if (ipId'="")
	{
		s ipDesc=$LISTGET($G(^User.BDPConfigD(ipId)),3)
		
		s usertId=$o(^User.BDPConfigI("ConfigDescI"," 用户名",0))
		s:usertId'="" userDesc=$LISTGET($G(^User.BDPConfigD(usertId)),3)
		
		s passId=$o(^User.BDPConfigI("ConfigDescI"," 密码",0))
		s:passId'="" passDesc=$LISTGET($G(^User.BDPConfigD(passId)),3)
		
		s portId=$o(^User.BDPConfigI("ConfigDescI"," 端口",0))
		s:portId'="" portDesc=$LISTGET($G(^User.BDPConfigD(portId)),3)
		
		q ipDesc_"^"_userDesc_"^"_passDesc_"^"_portDesc	
	}
	else
	{
		q ""
	}
}

/// Creator:李得原
/// CreatDate:2019-04-29
/// Description:根据word文件名生成pdf文件
/// Table:
/// Input:
/// Return:
/// w ##class(web.CDSS.CMKB.DocuManage).Word2Pdf("医学知识库和结构化诊断部署说明.docx")
ClassMethod Word2Pdf(filename)
{
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s FilePath=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\Doc\"
	s cmd1="word2pdf.lnk /source "_FilePath_filename
	s cmd2="/target "_FilePath
	s cmd=cmd1_" "_cmd2
	s sc=$zf(-2,cmd)
	q ""
}

/// Creator:高姗姗
/// CreatDate:2020-12-30
/// Description：导出文献管理数据
/// Other:w ##class(web.CDSS.CMKB.DocuManage).ExportData("","","","","","","","","","","","")
ClassMethod ExportData(Desc, EngDesc, Words, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type, User, Reviewer, State)
{
	/*
	//csv导出
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("文献名称,"_"英文文献名称,"_"关键词,"_"关联诊断,"_"类型,"_"科室,"_"发布年月,"_"发布机构,"_"指南出处,"_"编辑人,"_"审核人,"_"操作时间,"_"状态")
	d file.WriteLine()
	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
 	s:KeyWords'="" KeyWords=$ZCONVERT(KeyWords,"U") //转换成大写
 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
 	s:Disease'="" Disease="<"_Disease_">"
 	s:Dept'="" Dept="<"_Dept_">"
	s:EndDate="" date=EndDate
	s:EndDate'="" date=EndDate_"00:00:00"
	for{
		s date=$o(^CT.WDT.CDSS.DocuManageI("DateIndex",date),-1) q:date=""
		q:((StartDate'="")&&($ZDH(date,3)<$ZDH(StartDate,3)))
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuManageI("DateIndex",date,RowId),-1)
			q:RowId=""
			s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
			s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
			s PINYINDesc=""
			s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
			s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
			s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
			s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
			s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
			s:DocuInstitutionDr="" DocuInstitution=""
			s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)
			s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
			s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
			s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
			s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
			s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
			//关联诊断
			s JoinDisease="",DiseaseStr=""
			s DiseaseDR=""
			for {
				s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
				s DiseaseStr=DiseaseStr_"<"_DiseaseDR_">"
				
				s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
				if (JoinDisease=""){
					s JoinDisease=DiseaseDesc
				}else{
					s JoinDisease=JoinDisease_"，"_DiseaseDesc
				}
			}
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptStr=DeptStr_"<"_DeptDR_">"
				
				s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_"，"_DeptName
				}		
			}
			
			if (($ZCONVERT(DocuDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&(($ZCONVERT(DocuEngDesc,"U")[EngDesc)||(EngDesc=""))&&(($ZCONVERT(DocuKeyWords,"U")[KeyWords)||(KeyWords=""))&&((DocuType=Type)||(Type=""))&&(($ZCONVERT(DocuInstitution,"U")[Institution)||(Institution=""))&&((DocuMonth=Month)||(Month=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((DocuModifyUser=User)||(User=""))&&((DocuReviewer=Reviewer)||(Reviewer=""))&&((DocuState=State)||(State=""))&&((DiseaseStr[Disease)||(Disease=""))&&((DeptStr[Dept)||(Dept="")){
		  		d file.Write($tr(DocuDesc,",","，")_",") //文献名称
		  		d file.Write($tr(DocuEngDesc,",","，")_",") //英文文献名称
		  		d file.Write($tr(DocuKeyWords,",","，")_",") //关键词
				d file.Write($tr(JoinDisease,",","，")_",") //关联诊断
				d file.Write($tr(DocuType,",","，")_",") //类型
				d file.Write($tr(JoinDept,",","，")_",") //科室
				d file.Write($tr(DocuMonth,",","，")_",") //发布年月
				d file.Write($tr(DocuInstitution,",","，")_",") //发布机构
				d file.Write($tr(DocuSource,",","，")_",") //指南出处
				d file.Write($tr(DocuModifyUser,",","，")_",") //编辑人
				d file.Write($tr(DocuReviewer,",","，")_",") //审核人
				d file.Write($tr(DocuModifyDate,",","，")_",") //操作时间
				d file.Write($tr(DocuState,",","，")) //状态
				d file.WriteLine()
		  	}
		}
	}

	d file.%Save()
	d file.%Close()
	q fileName
	*/
	//xls导出
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理数据.xls"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%Stream.FileCharacter).%New() 
	d file.LinkToFile(P)
	
	d file.WriteLine("文献名称"_$c(9)_"英文文献名称"_$c(9)_"关键词"_$c(9)_"关联诊断"_$c(9)_"类型"_$c(9)_"科室"_$c(9)_"发布年月"_$c(9)_"发布机构"_$c(9)_"指南出处"_$c(9)_"编辑人"_$c(9)_"审核人"_$c(9)_"操作时间"_$c(9)_"状态")
	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
 	s:KeyWords'="" KeyWords=$ZCONVERT(KeyWords,"U") //转换成大写
 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
 	s:Disease'="" Disease="<"_Disease_">"
 	s:Dept'="" Dept="<"_Dept_">"
	s:EndDate="" date=EndDate
	s:EndDate'="" date=EndDate_"00:00:00"
	for{
		s date=$o(^CT.WDT.CDSS.DocuManageI("DateIndex",date),-1) q:date=""
		q:((StartDate'="")&&($ZDH(date,3)<$ZDH(StartDate,3)))
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuManageI("DateIndex",date,RowId),-1)
			q:RowId=""
			s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
			s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
			s PINYINDesc=""
			s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
			s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
			s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
			s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
			s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
			s:DocuInstitutionDr="" DocuInstitution=""
			s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)
			s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
			s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
			s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
			s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
			s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
			//关联诊断
			s JoinDisease="",DiseaseStr=""
			s DiseaseDR=""
			for {
				s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
				s DiseaseStr=DiseaseStr_"<"_DiseaseDR_">"
				
				s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
				if (JoinDisease=""){
					s JoinDisease=DiseaseDesc
				}else{
					s JoinDisease=JoinDisease_"，"_DiseaseDesc
				}
			}
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptStr=DeptStr_"<"_DeptDR_">"
				
				s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_"，"_DeptName
				}		
			}
			
			if (($ZCONVERT(DocuDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&(($ZCONVERT(DocuEngDesc,"U")[EngDesc)||(EngDesc=""))&&(($ZCONVERT(DocuKeyWords,"U")[KeyWords)||(KeyWords=""))&&((DocuType=Type)||(Type=""))&&(($ZCONVERT(DocuInstitution,"U")[Institution)||(Institution=""))&&((DocuMonth=Month)||(Month=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((DocuModifyUser=User)||(User=""))&&((DocuReviewer=Reviewer)||(Reviewer=""))&&((DocuState=State)||(State=""))&&((DiseaseStr[Disease)||(Disease=""))&&((DeptStr[Dept)||(Dept="")){
		  		d file.Write(DocuDesc_$c(9)) //文献名称
		  		d file.Write(DocuEngDesc_$c(9)) //英文文献名称
		  		d file.Write(DocuKeyWords_$c(9)) //关键词
				d file.Write(JoinDisease_$c(9)) //关联诊断
				d file.Write(DocuType_$c(9)) //类型
				d file.Write(JoinDept_$c(9)) //科室
				d file.Write(DocuMonth_$c(9)) //发布年月
				d file.Write(DocuInstitution_$c(9)) //发布机构
				d file.Write(DocuSource_$c(9)) //指南出处
				d file.Write(DocuModifyUser_$c(9)) //编辑人
				d file.Write(DocuReviewer_$c(9)) //审核人
				d file.Write(DocuModifyDate_$c(9)) //操作时间
				d file.Write(DocuState_$c(9)) //状态
				d file.WriteLine()
		  	}
		}
	}

	d file.%Save()
	d file.%Close()
	q fileName*/
	//txt导出
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理数据.txt"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=P
	*/
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"文献管理数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
    u file
    w "文献名称	英文文献名称	关键词	关联诊断条件	类型	科室	发布年月	发布机构	指南出处	编辑人	审核人	操作时间	状态	文献路径	详情父级	详情标题	详情内容"   //注意此处是用tab隔开
	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
 	s:KeyWords'="" KeyWords=$ZCONVERT(KeyWords,"U") //转换成大写
 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
 	s:Words'="" Words="<"_Words_">"
 	s:Dept'="" Dept="<"_Dept_">"
	s:EndDate="" date=EndDate
	s:EndDate'="" date=EndDate_"00:00:00"
	for{
		s date=$o(^CT.WDT.CDSS.DocuManageI("DateIndex",date),-1) q:date=""
		q:((StartDate'="")&&($ZDH(date,3)<$ZDH(StartDate,3)))
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuManageI("DateIndex",date,RowId),-1)
			q:RowId=""
			s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
			s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
			s PINYINDesc=""
			s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
			s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
			s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
			s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
			s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
			s:DocuInstitutionDr="" DocuInstitution=""
			s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)
			s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
			s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
			s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
			s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
			s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
			//诊断条件
				s JoinWords="",WordsStr=""
				s WordsDR=""
				for {
					s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,WordsDR)) q:WordsDR=""
					s WordsStr=WordsStr_"<"_WordsDR_">"
					s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
					if (JoinWords=""){
						s JoinWords=WordsDesc
					}else{
						s JoinWords=JoinWords_","_WordsDesc
					}
				}
				s JoinWordsDR=""
				s WordsDR=""
				for {			//取识别条件为空，诊断条件不为空的数据
					s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
					s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
					s WordsStr=WordsStr_"<"_WordsDR_">"
					s WordsDesc=""
					s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
					
					if (JoinWords=""){
						s JoinWords=WordsDesc
					}else{
						s JoinWords=JoinWords_","_WordsDesc
					}
				}
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptStr=DeptStr_"<"_DeptDR_">"
				
				s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_","_DeptName
				}		
			}
			
			//详情
			s Parent="",Title="",Content=""
			if ($d(^CT.WDT.CDSS.DocuDetailI("DocuIndex",RowId))){
				s DetailId=$o(^CT.WDT.CDSS.DocuDetailI("DocuIndex",RowId,""))
				s ParentDR=$lg($g(^CT.WDT.CDSS.DocuDetailD(DetailId)),5)
				s:ParentDR'="" Parent=$lg($g(^CT.WDT.CDSS.DocuDetailD(ParentDR)),3)
				s Title=$lg($g(^CT.WDT.CDSS.DocuDetailD(DetailId)),3)
				s Content=$lg($g(^CT.WDT.CDSS.DocuDetailD(DetailId)),4)
			}
			
			if (($ZCONVERT(DocuDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&(($ZCONVERT(DocuEngDesc,"U")[EngDesc)||(EngDesc=""))&&(($ZCONVERT(DocuKeyWords,"U")[KeyWords)||(KeyWords=""))&&((DocuType=Type)||(Type=""))&&(($ZCONVERT(DocuInstitution,"U")[Institution)||(Institution=""))&&((DocuMonth=Month)||(Month=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((DocuModifyUser=User)||(User=""))&&((DocuReviewer=Reviewer)||(Reviewer=""))&&((DocuState=State)||(State=""))&&((WordsStr[Words)||(Words=""))&&((DeptStr[Dept)||(Dept="")){
				w !,DocuDesc_"	"_DocuEngDesc_"	"_DocuKeyWords_"	"_JoinWords_"	"_DocuType_"	"_JoinDept_"	"_DocuMonth_"	"_DocuInstitution_"	"_DocuSource_"	"_DocuModifyUser_"	"_DocuReviewer_"	"_DocuModifyDate_"	"_DocuState_"	"_DocuPath_"	"_Parent_"	"_Title_"	"_Content	 //注意此处连接符是tab
		  	}
		}
	}

	c file
	q fileName
}

/// Creator:高姗姗
/// CreatDate:2021-01-04
/// Description:清除文献数据
/// Table: CT.WDT.CDSS.DocuManage
/// others:w ##class(web.CDSS.CMKB.DocuManage).KillData()
ClassMethod KillData()
{
	k ^CT.WDT.CDSS.DocuManageD
	k ^CT.WDT.CDSS.DocuManageI
	k ^CT.WDT.CDSS.DocuDetailD
	k ^CT.WDT.CDSS.DocuDetailI
	k ^CT.WDT.CDSS.DocuJoinDiseaseD
	k ^CT.WDT.CDSS.DocuJoinDiseaseI
	k ^CT.WDT.CDSS.DocuJoinDeptD
	k ^CT.WDT.CDSS.DocuJoinDeptI
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-04
/// Description:导入文献数据
/// Table: CT.WDT.CDSS.DocuManage
/// others:w ##class(web.CDSS.CMKB.DocuManage).ImportTxt("文献导入")
/// others:w ##class(web.CDSS.CMKB.DocuManage).ImportTxt("文献关联疾病修正")
ClassMethod ImportTxt(filename)
{
	Ts
	s result="true"
	k ^TMPCDSSDOCUMANAGE("Docu")
	k ^TMPCDSSDOCUMANAGE("Disease")
	k ^TMPCDSSDOCUMANAGE("NoPath")
	Set path1 = ##Class(%File).NormalizeFilename("D:\"_filename_".txt") //获取当前路径 D
    if '##class(%File).Exists(path1) {
	    q "文件不存在"
    }
    Set file=##class(%File).%New("D:\"_filename_".txt")
	d file.Open("R")
	for i=1:1:file.Size {
		s datastr=file.Read()   
		continue:datastr=""
		//中文文献名称 关联诊断 (日期 操作人员)
		s DocuDesc=$p($p(datastr,"	",1),".pdf",1)
		s DocuDesc=##class(web.DHCBL.BDP.FunLib).Util(DocuDesc)
		s DocuDesc=$tr(DocuDesc,"?","")
		continue:(DocuDesc="")
		s DiseaseStr=$p(datastr,"	",2)
		/*s DocuModifyDate=$p(datastr,",",3)
		s date=$p(DocuModifyDate," ",1) //日期
		s time=$p(DocuModifyDate," ",2) //时间
		s y=$p(date,"/",1) //年
		s m=$p(date,"/",2) //月
		s:($Length(m)=1) m="0"_m
		s d=$p(date,"/",3) //日
		s:($Length(d)=1) d="0"_d
		s DocuModifyDate=y_"-"_m_"-"_d_" "_time_":00"
		s DocuModifyUser=$p(datastr,",",4)*/
		
		s DocuModifyDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s DocuModifyUser="dhcc"
		
		s ^TMPCDSSDOCUMANAGE("Docu",DocuDesc)=""
		s DescU=$ZCONVERT(DocuDesc,"U")
		if ($e(DescU,1)="_"){
			s DescU = $e(DescU,2,*)
		}
		s DocuId=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",DescU,"")) //文献id
		if (DocuId=""){ //文献新增
			s obj=##class(CT.WDT.CDSS.DocuManage).%New()
			s obj.DocuCode = ..GetLastCode()
			s obj.DocuState="编辑中"
			if ($e(DocuDesc,1)="_"){
				s obj.DocuDesc = $e(DocuDesc,2,*)
			}else{
				s obj.DocuDesc = DocuDesc
			}
			s obj.DocuModifyDate = DocuModifyDate
			s obj.DocuModifyUser = DocuModifyUser
			s IsExistDoc=##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\CDSS\Doc\"_DocuDesc_".docx")
			s IsExistPdf=##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\CDSS\Doc\"_DocuDesc_".pdf")
			if (IsExistPdf=1){
				s obj.DocuPath = DocuDesc_".pdf"
			}
			elseif (IsExistDoc=1){
				s obj.DocuPath = DocuDesc_".docx"
			}
			else{
				s obj.DocuPath = ""
				s ^TMPCDSSDOCUMANAGE("NoPath",DocuDesc)=""
			}
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s DocuId = obj.%Id()
			}else{
				s result="false"
				Trollback	
			}
		}
		s LenDisease=$Length(DiseaseStr,",")
		for i=1:1:LenDisease{
			s DiseaseName=$p(DiseaseStr,",",i) //诊断名称
			continue:(DiseaseName="")
			s DiseaseNameU=$ZCONVERT(DiseaseName,"U")
			s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseNameU,""))
			if (DiseaseDR=""){
				s ^TMPCDSSDOCUMANAGE("Disease",DocuDesc,DiseaseName)="" //记录不存在的诊断
				continue
			}
			s JoinRowId=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",DocuId,DiseaseDR,""))
			if (JoinRowId=""){ //文献关联诊断新增
				s objDisease=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
				d objDisease.DocuDRSetObjectId(DocuId)
				d:DiseaseDR'="" objDisease.DiseaseDRSetObjectId(DiseaseDR)
				d:DiseaseDR="" objDisease.DiseaseDRSetObjectId("")
				s objDisease.DocuModifyDate = DocuModifyDate
				s objDisease.DocuModifyUser = DocuModifyUser
				s scDisease=objDisease.%Save() 
				d objDisease.%Close()
				If $$$ISOK(scDisease) //新增数据存入数组
				{
					s arrExist(DocuId,objDisease.%Id())=""
				}else{
					s result="false"
					Trollback
				}
			}else{ //原有数据存入数组
				s arrExist(DocuId,JoinRowId)=""
			}	
		}
		/*s joinid=""
		for{
			s joinid=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",DocuId,joinid)) q:joinid=""
			continue:$d(arrExist(DocuId,joinid))	 //过滤现有数据
			//关联诊断删除
			s scDel=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(joinid)
			If $$$ISERR(scDel)
			{	
				s result="false"
				Trollback
			}
		}*/
	}
	if (result="true"){
		Tc	
	}
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-04
/// Description:导入文献数据
/// Table: CT.WDT.CDSS.DocuManage
/// others:w ##class(web.CDSS.CMKB.DocuManage).ImportData()
ClassMethod ImportData()
{
	Ts
	s result="true"
	k ^TMPCDSSDOCUMANAGE("Docu")
	k ^TMPCDSSDOCUMANAGE("Disease")
	s file=##class(%File).%New("D:\文献导入.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s datastr=file.Read()   
		continue:datastr=""
		//中文文献名称 关联诊断 (日期 操作人员)
		s DocuDesc=$p($p(datastr,",",1),".pdf",1)
		continue:(DocuDesc="文献名称")
		continue:(DocuDesc="")
		s DocuDesc=$tr(DocuDesc,"^",",")
		s DiseaseStr=$p(datastr,",",2)
		/*s DocuModifyDate=$p(datastr,",",3)
		s date=$p(DocuModifyDate," ",1) //日期
		s time=$p(DocuModifyDate," ",2) //时间
		s y=$p(date,"/",1) //年
		s m=$p(date,"/",2) //月
		s:($Length(m)=1) m="0"_m
		s d=$p(date,"/",3) //日
		s:($Length(d)=1) d="0"_d
		s DocuModifyDate=y_"-"_m_"-"_d_" "_time_":00"
		s DocuModifyUser=$p(datastr,",",4)*/
		
		s DocuModifyDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s DocuModifyUser="dhcc"
		
		s ^TMPCDSSDOCUMANAGE("Docu",DocuDesc)=""
		s DescU=$ZCONVERT(DocuDesc,"U")
		s DocuId=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",DescU,"")) //文献id
		if (DocuId=""){ //文献新增
			s obj=##class(CT.WDT.CDSS.DocuManage).%New()
			s obj.DocuCode = ..GetLastCode()
			s obj.DocuState="编辑中"
			if ($e(DocuDesc,1)="_"){
				s obj.DocuDesc = $e(DocuDesc,2,*)
			}else{
				s obj.DocuDesc = DocuDesc
			}
			s obj.DocuModifyDate = DocuModifyDate
			s obj.DocuModifyUser = DocuModifyUser
			s IsExistDoc=##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\CDSS\Doc\"_DocuDesc_".docx")
			s IsExistPdf=##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\CDSS\Doc\"_DocuDesc_".pdf")
			if (IsExistPdf=1){
				s obj.DocuPath = DocuDesc_".pdf"
			}
			elseif (IsExistDoc=1){
				s obj.DocuPath = DocuDesc_".docx"
			}
			else{
				s obj.DocuPath = ""
			}
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s DocuId = obj.%Id()
			}else{
				s result="false"
				Trollback	
			}
		}
		s LenDisease=$Length(DiseaseStr,"^")
		for i=1:1:LenDisease{
			s DiseaseName=$p(DiseaseStr,"^",i) //诊断名称
			continue:(DiseaseName="")
			s DiseaseNameU=$ZCONVERT(DiseaseName,"U")
			s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseNameU,""))
			if (DiseaseDR=""){
				s ^TMPCDSSDOCUMANAGE("Disease",DocuDesc,DiseaseName)="" //记录不存在的诊断
				continue
			}
			s JoinRowId=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",DocuId,DiseaseDR,""))
			if (JoinRowId=""){ //文献关联诊断新增
				s objDisease=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
				d objDisease.DocuDRSetObjectId(DocuId)
				d:DiseaseDR'="" objDisease.DiseaseDRSetObjectId(DiseaseDR)
				d:DiseaseDR="" objDisease.DiseaseDRSetObjectId("")
				s objDisease.DocuModifyDate = DocuModifyDate
				s objDisease.DocuModifyUser = DocuModifyUser
				s scDisease=objDisease.%Save() 
				d objDisease.%Close()
				If $$$ISOK(scDisease) //新增数据存入数组
				{
					s arrExist(DocuId,objDisease.%Id())=""
				}else{
					s result="false"
					Trollback
				}
			}else{ //原有数据存入数组
				s arrExist(DocuId,JoinRowId)=""
			}	
		}
		s joinid=""
		for{
			s joinid=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",DocuId,joinid)) q:joinid=""
			continue:$d(arrExist(DocuId,joinid))	 //过滤现有数据
			//关联诊断删除
			s scDel=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(joinid)
			If $$$ISERR(scDel)
			{	
				s result="false"
				Trollback
			}
		}
	}
	if (result="true"){
		Tc	
	}
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-06
/// Description：导出文献管理1.0中未被诊断决策关联的文献(剩余未被导入的文献)
/// Other:w ##class(web.CDSS.CMKB.DocuManage).ExportMissMKBDoc()
ClassMethod ExportMissMKBDoc()
{
	/*
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理剩余数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"文献管理剩余数据.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s P=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s P=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("文献Id,"_"文献名称")
	d file.WriteLine()
	
	s MKBDMRowId=0
    for{  
      	s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
      	s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
      	s MKBDMDesc=$tr(MKBDMDesc,",","，")
      	s MKBDMName=$tr(MKBDMDesc,".pdf","")
      	s MKBDMName=$tr(MKBDMName,".doc","")
      	s MKBDMName=$tr(MKBDMName,".docx","")
      	continue:$d(^TMPCDSSDOCUMANAGE("Docu",MKBDMName))
      	d file.Write(MKBDMRowId_",")
		d file.Write(MKBDMDesc) 
		d file.WriteLine()
    }
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:高姗姗
/// CreatDate:2021-09-26
/// Description：导出获取不到源文件的文献名
/// Other:w ##class(web.CDSS.CMKB.DocuManage).ExportNoPathData()
ClassMethod ExportNoPathData()
{
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理2无源文件.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"文献管理2无源文件.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s P=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s P=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("文献名称")
	d file.WriteLine()
	
	s MKBDMDesc=0
    for{  
      	s MKBDMDesc=$o(^TMPCDSSDOCUMANAGE("NoPath",MKBDMDesc)) q:MKBDMDesc=""   
		d file.Write(MKBDMDesc) 
		d file.WriteLine()
    }
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:高姗姗
/// CreatDate:2021-09-26
/// Description：导出获取不到关联诊断名
/// Other:w ##class(web.CDSS.CMKB.DocuManage).ExportNoDiseData()
ClassMethod ExportNoDiseData()
{
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="文献管理2无诊断名.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"文献管理2无诊断名.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s P=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s P=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("文献名称,"_"诊断名称")
	d file.WriteLine()
	
	s MKBDMDesc=0
    for{  
      	s MKBDMDesc=$o(^TMPCDSSDOCUMANAGE("Disease",MKBDMDesc)) q:MKBDMDesc=""   
      	s DiseaseName=0
      	for{
	      	s DiseaseName=$o(^TMPCDSSDOCUMANAGE("Disease",MKBDMDesc,DiseaseName)) q:DiseaseName=""
			d file.Write(MKBDMDesc_",")
			d file.Write(DiseaseName) 
			d file.WriteLine()
		}
    }
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:高姗姗
/// CreatDate:2021-09-29
/// Description：文献管理中已维护的发布机构导入发布机构字典，并修正发布机构指向数据
/// Other:w ##class(web.CDSS.CMKB.DocuManage).ImportAgency()
ClassMethod ImportAgency()
{
	s RowId=""
	for{
		s RowId=$o(^CT.WDT.CDSS.DocuManageD(RowId)) q:RowId=""
		s DocuInstitution = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构	
		continue:(DocuInstitution="")
		s eobj = ##class(web.CDSSEntity.CMKB.DocuAgency).%New()
		s eobj.RowId=""
		s eobj.AgencyDesc=DocuInstitution
		s res=##class(web.CDSS.CMKB.DocuAgency).SaveData(eobj)
		if (res["false"){
			
		}else{
			s AgencyId=$p($p(res,"id:'",2),"'}",1)
			s $list(^CT.WDT.CDSS.DocuManageD(RowId),8)=AgencyId
		}
	}
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-04
/// Description:清除未关联到文献的pdf源文件
/// others:w ##class(web.CDSS.CMKB.DocuManage).KillFile()
ClassMethod KillFile()
{
	Ts
	s result="true"
	s file=##class(%File).%New("D:\文献管理.csv")
	d file.Open("RS")
	s num=0
	while 'file.AtEnd
	{
		s datastr=file.Read()   
		continue:datastr=""
		s DocuDesc=$p(datastr,",",1)
		s resPdf=##class(web.DHCBL.BDP.BDPUploadFile).DeleteFile("scripts\bdp\CDSS\Doc\"_DocuDesc_".pdf")
		s num=num+1
		w num_" - "_DocuDesc_" : "_resPdf,!
	}
	q "over"
}

/// Creator:Xuwenhu
/// CreatDate:2022-02-10
/// Description:数据统计
/// Table:CT.WDT.CDSS.DocuManage
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Others:w ##class(web.CDSS.CMKB.DocuManage).CountData()
ClassMethod CountData() As %String
{
	s (EditNum,AuditNum,StayNum,AllNum)=0
	s SQL="SELECT DocuState AS state,Count(*) AS num FROM CT_WDT_CDSS.DocuManage GROUP BY DocuState"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		if ((rset.state="")||(rset.state="编辑中")||(rset.state="不通过")||(rset.state="已下线"))
		{
			s EditNum=EditNum+rset.num		
		}
		if ((rset.state="审核通过")||(rset.state="上线"))
		{
			s AuditNum=AuditNum+rset.num	
		}
		if rset.state="审核中"
		{
			s StayNum=StayNum+rset.num	
		}
		s AllNum=AllNum+rset.num
	}
	q AllNum_"^"_EditNum_"^"_AuditNum_"^"_StayNum
}

/// Creator:高姗姗
/// CreatDate:2022-05-07
/// Description:获得文献管理表的日志
/// Table: CT.WDT.CDSS.DocuManage
/// Input: RowId 文献表RowID
/// Return:返回文献表的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetDocuLogList","7320")
Query GetDocuLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetDocuLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DocuManage",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Opreation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Opreation="编辑"
         	}
         	d OutputRowLog
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocuLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocuLogListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocuLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocuLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2022-05-17
/// Description:获得源文件不存在的文献
/// Table: CT.WDT.CDSS.DocuManage
/// Return:返回源文件缺失列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuManage","GetDocuMisList")
Query GetDocuMisList() As %Query(ROWSPEC = "RowId,DocuDesc,FileDesc")
{
}

ClassMethod GetDocuMisListExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s RowId=""
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DocuManageD(RowId))
		q:RowId=""
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
		s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
		s FileDesc=""
		if (DocuPath=""){
			d OutputRowDocuMis
		}else{
			s FileLen=$Length(DocuPath,"^")
			for i=1:1:FileLen{
				s FileDesc=$p(DocuPath,"^",i)
				s IsExistsFile=##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\CDSS\Doc\"_FileDesc)
				continue:(IsExistsFile=1) //源文件存在则跳过
				d OutputRowDocuMis
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDocuMis
	set Data=$lb(RowId,DocuDesc,FileDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocuMisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocuMisListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocuMisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocuMisListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2022-05-20
/// Description:前台导入文献数据
/// Table: CT.WDT.CDSS.DocuManage
/// others:w ##class(web.CDSS.CMKB.DocuManage).ImportXLSData("[N][N][N]")
ClassMethod ImportXLSData(dataStr)
{
	s result="true"
	q:dataStr="[N][N][N]" "true" 	
	s DocuDesc=$p(dataStr,"[N]",1)
	q:DocuDesc="" ""
    s DiseaseStr=$p(dataStr,"[N]",2)
	s DeptStr=$p(dataStr,"[N]",3)
	
	s DocuId=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",DocuDesc,"")) //文献id
	if (DocuId=""){ //文献新增
		s obj=##class(CT.WDT.CDSS.DocuManage).%New()
		s obj.DocuCode = ..GetLastCode()
		s obj.DocuDesc = DocuDesc
		s obj.DocuState="编辑中"
	}else{ //文献修改
		s obj=##class(CT.WDT.CDSS.DocuManage).%OpenId(DocuId)
		s:(obj.DocuState="上线") obj.DocuState="审核中"
	}
	s obj.DocuModifyDate = $ZDATETIME($h,3)
	if ($d(%session)){
		s obj.DocuModifyUser=$Get(%session.Data("LOGON.USERNAME")) 
	}
	
   	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s DocuId = obj.%Id()
	}else{
		s result="false"
	}
	/*
	//文献关联诊断保存
   	s lenDis=$Length(DiseaseStr,"^")
	for i=1:1:lenDis{
		s Disease=$p(DiseaseStr,"^",i)
		continue:(Disease="")
		s DiseaseU=$ZCONVERT(Disease,"U")
		s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseU,""))
		continue:(DiseaseDR="")
		s JoinDisRowId=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",DocuId,DiseaseDR,""))
		if (JoinDisRowId=""){ //文献关联诊断新增
			s objDisease=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
			d objDisease.DocuDRSetObjectId(DocuId)
			d:DiseaseDR'="" objDisease.DiseaseDRSetObjectId(DiseaseDR)
			d:DiseaseDR="" objDisease.DiseaseDRSetObjectId("")
			s objDisease.DocuModifyDate = $ZDATETIME($h,3)
			s objDisease.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
			s scAddDis=objDisease.%Save() 
			d objDisease.%Close()
			If $$$ISOK(scAddDis) //新增数据存入数组
			{
				
			}else{
				s result="false"
			}	
		}	
	}*/
	//文献关联诊断条件保存
   	s lenDis=$Length(DiseaseStr,"^")
	for i=1:1:lenDis{
		s Disease=$p(DiseaseStr,"^",i)
		continue:(Disease="")
		s DiseaseU=$ZCONVERT(Disease,"U")
		//s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseU,""))
		s IWordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseU,"识别条件",""))
		s WordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseU,"诊断条件",""))
		continue:(IWordsDR="")
		s JoinDisRowId=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",DocuId,IWordsDR,""))
		if (JoinDisRowId=""){ //文献关联诊断新增
			s objDisease=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
			d objDisease.DocuDRSetObjectId(DocuId)
			d:IWordsDR'="" objDisease.IWordsDRSetObjectId(IWordsDR)
			d:IWordsDR="" objDisease.IWordsDRSetObjectId("")
			if (IWordsDR=""){
				d:WordsDR'="" objDisease.WordsDRSetObjectId(WordsDR)
				d:WordsDR="" objDisease.WordsDRSetObjectId("")
			}
			s objDisease.DocuModifyDate = $ZDATETIME($h,3)
			if ($d(%session)){
				s objDisease.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
			}
			
			s scAddDis=objDisease.%Save() 
			d objDisease.%Close()
			If $$$ISOK(scAddDis) //新增数据存入数组
			{
				
			}else{
				s result="false"
			}	
		}	
	}
	//文献关联科室保存
	s len=$Length(DeptStr,"^")
	for j=1:1:len{
		s Dept=$p(DeptStr,"^",j)
		continue:(Dept="")
		s DeptU=$ZCONVERT(Dept,"U")
		s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_DeptU,""))
		continue:(DeptDR="")
		s JoinDepRowId=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",DocuId,DeptDR,""))
		if (JoinDepRowId=""){ //文献关联科室新增
			s objDept=##class(CT.WDT.CDSS.DocuJoinDept).%New()
			d objDept.DocuDRSetObjectId(DocuId)
			d:DeptDR'="" objDept.DeptDRSetObjectId(DeptDR)
			d:DeptDR="" objDept.DeptDRSetObjectId("")
			s scAddDept=objDept.%Save() 
			d objDept.%Close()
			If $$$ISOK(scAddDept) 
			{
				
			}else{
				s result="false"
			}
			
		}
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-08-18
/// Description:前台导入测试数据【检索字段+目标指南】
/// Table: CT.WDT.CDSS.DocuManage
/// others:w ##class(web.CDSS.CMKB.DocuManage).ImportRetrieveXLSData()
ClassMethod ImportRetrieveXLSData(dataStr)
{
	s flag=0
	q:dataStr="[N][N][N]" "true" 
	//s Dept=	$p(dataStr,"[N]",1)
	s RetrieveDesc=$p(dataStr,"[N]",1)
	q:RetrieveDesc="" ""
	s DocuDesc=$p(dataStr,"[N]",2)
	s flagDesc=$p(dataStr,"[N]",3)
	
	s RetrieveRusult=##class(web.CDSS.TreatDecision.RatingScale).DocumentRetrieval(RetrieveDesc)
#;	s RetrieveRusultStr=(RetrieveRusult.Document).%ToJSON()
#;	s RetrieveRusult=RetrieveRusult.Document
#;	s len=$Length(RetrieveRusultStr,"},{")
#;	for j=1:1:len{
#;		
#;		
#;	}
	if (RetrieveRusult[DocuDesc){
		s flag=1
	}
	s flagDesc=$CASE(flag ,0:"否",1:"是",:"否")
	
	q flagDesc
}

}
