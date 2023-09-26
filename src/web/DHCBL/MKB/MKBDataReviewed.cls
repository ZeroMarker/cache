Class web.DHCBL.MKB.MKBDataReviewed Extends %RegisteredObject
{

/// Description：查询上报诊断
/// Table：User.MKBDataReviewed
/// Input：mradm,rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataReviewed","GetList","","","","","SD")
Query GetList(mradm As %String, desc As %String, reason As %String, status As %String, type As %String) As %Query(ROWSPEC = "MKBDRRowId,MKBDRDiagDr,MKBDRDiagDesc,MKBDRStructChild,MKBDRDiag,MKBDRTermDR,MKBDRStructResultID,MKBDRStructDesc,MKBDRSupplement,MKBDRMRCDr,MKBDRMRCCode,MKBDRMRCDesc,MKBDRICDDesc,MKBDRReson,MKBDRNote,MKBDRStatus,MKBDRResonValue,MKBDRMRADMDR,MKBDROtherDesc,MKBDRType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, mradm As %String, desc As %String, reason As %String, status As %String, type As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 s:desc'="" desc=$tr(desc," ","") //过滤空格
 
 if (mradm'=""){
	s MKBDRRowId=""
	for{
		s MKBDRRowId=$o(^User.MKBDataReviewedI("MRAdmIndex"," "_mradm,MKBDRRowId))
		q:MKBDRRowId=""	 
		s MKBDRDiagDesc=""
		s MKBDRStructChild=""
		s typeflag = ""
		s MKBDRDiagDr=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),2)
		if (type="SD")
		{
			//s typeflag = $d(^User.MKBStructuredDataD(MKBDRDiagDr))
			if ((MKBDRDiagDr'="") && $d(^User.MKBStructuredDataD(MKBDRDiagDr))){

				s MKBDRDiagDesc=$LISTGET($G(^User.MKBStructuredDataD(MKBDRDiagDr)),2)
				s MKBDRStructSub=""
				s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBDRDiagDr,0))
				if (sortindex'="")
				{
					s MKBDRStructSub=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBDRDiagDr,sortindex,0))	
				}


				s MKBDRStructChild=MKBDRDiagDr_"||"_MKBDRStructSub			
			}

		}
		else
		{
			//s typeflag = $d(^User.MKBICDContrastD(MKBDRDiagDr))
			if ((MKBDRDiagDr'="") && $d(^User.MKBICDContrastD(MKBDRDiagDr))){

			s MKBDRDiagDesc=$LISTGET($G(^User.MKBICDContrastD(MKBDRDiagDr)),3)
			s MKBDRStructSub=""
			s sortindex=$O(^User.MKBICDContrastResultI("SeqIndex",MKBDRDiagDr,0))
			if (sortindex'="")
			{
				s MKBDRStructSub=$O(^User.MKBICDContrastResultI("SeqIndex",MKBDRDiagDr,sortindex,0))	
			}

				

				s MKBDRStructChild=MKBDRDiagDr_"||"_MKBDRStructSub			
			}

		}
		s MKBDRDiag=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),3)
		s MKBDRStructDesc=""
		s MKBDRTermDR=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),5)
		s MKBDRStructResultID=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),6)
		s:MKBDRTermDR'="" MKBDRStructDesc=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBDRStructResultID,MKBDRTermDR)
		s MKBDRSupplement=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),7)
		s MKBDRMRCCode="",MKBDRMRCDesc=""
		s MKBDRMRCCode=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),8)
		//s:MKBDRMRCDr'="" MKBDRMRCCode=$p($g(^MRC("ID",MKBDRMRCDr)),"^",4)
		//s:MKBDRMRCDr'="" MKBDRMRCDesc=$p($g(^MRC("ID",MKBDRMRCDr)),"^",2)
		s MKBDRICDDesc=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),9)
		s MKBDRResonValue=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),10)
		s MKBDRMRADMDR=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),4)
		s Reason=""
		s MKBDRReson = ""
		if MKBDRResonValue'=""
		{
			s ReasonsLen=$l(MKBDRResonValue,",")
			for i=1:1:ReasonsLen
			{
				s OneReason=$p(MKBDRResonValue,",",i)
				s ReasonStr=$select(OneReason="A":"缺诊断短语",OneReason="B":"诊断短语不正确",OneReason="C":"缺诊断表达式",OneReason="D":"诊断表达式不正确",OneReason="E":"缺ICD",OneReason="F":"ICD不正确")
				s:Reason'="" Reason=Reason_","_ReasonStr
				s:Reason="" Reason=ReasonStr
			}
			
			s MKBDRReson = Reason
		}
		
		s MKBDRNote=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),11)
		s MKBDRStatus=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),12)
		s MKBDROtherDesc=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),13)
		s MKBDRType = $LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),14) 
		if ((($ZCONVERT(MKBDRDiagDesc,"U")[desc)||($ZCONVERT(MKBDRDiag,"U")[desc)))&((MKBDRResonValue[reason)||(reason=""))&((MKBDRStatus=status)||(status=""))&(MKBDRType = type){
			d OutputRow
		}
	}	  
 }
 else
 {
	s MKBDRRowId=""
	for{
		s MKBDRRowId=$o(^User.MKBDataReviewedD(MKBDRRowId))
		q:MKBDRRowId=""	 
		s MKBDRDiagDesc=""
		s MKBDRStructChild=""
		s typeflag = ""
		s MKBDRDiagDr=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),2)
		if (type="SD")
		{
			//s typeflag = $d(^User.MKBStructuredDataD(MKBDRDiagDr))
			if ((MKBDRDiagDr'="") && $d(^User.MKBStructuredDataD(MKBDRDiagDr))){

				s MKBDRDiagDesc=$LISTGET($G(^User.MKBStructuredDataD(MKBDRDiagDr)),2)
				s MKBDRStructSub=""
				s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBDRDiagDr,0))
				if (sortindex'="")
				{
					s MKBDRStructSub=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBDRDiagDr,sortindex,0))	
				}


				s MKBDRStructChild=MKBDRDiagDr_"||"_MKBDRStructSub			
			}

		}
		else
		{
			//s typeflag = $d(^User.MKBICDContrastD(MKBDRDiagDr))
			if ((MKBDRDiagDr'="") && $d(^User.MKBICDContrastD(MKBDRDiagDr))){

			s MKBDRDiagDesc=$LISTGET($G(^User.MKBICDContrastD(MKBDRDiagDr)),3)
			s MKBDRStructSub=""
			s sortindex=$O(^User.MKBICDContrastResultI("SeqIndex",MKBDRDiagDr,0))
			if (sortindex'="")
			{
				s MKBDRStructSub=$O(^User.MKBICDContrastResultI("SeqIndex",MKBDRDiagDr,sortindex,0))	
			}

				

				s MKBDRStructChild=MKBDRDiagDr_"||"_MKBDRStructSub			
			}

		}		s MKBDRDiag=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),3)
		s MKBDRTermDR=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),5)
		s MKBDRStructResultID=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),6)
		s MKBDRStructDesc=""
		s:MKBDRTermDR'="" MKBDRStructDesc=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBDRStructResultID,MKBDRTermDR)		
		s MKBDRSupplement=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),7)
		s MKBDRMRCCode="",MKBDRMRCDesc=""
		s MKBDRMRCCode=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),8)
		//s:MKBDRMRCDr'="" MKBDRMRCCode=$p($g(^MRC("ID",MKBDRMRCDr)),"^",4)
		//s:MKBDRMRCDr'="" MKBDRMRCDesc=$p($g(^MRC("ID",MKBDRMRCDr)),"^",2)
		s MKBDRICDDesc=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),9)
		s MKBDRResonValue=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),10)
		s MKBDRMRADMDR=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),4)
		s Reason=""
		s MKBDRReson = ""
		if MKBDRResonValue'=""
		{
			s ReasonsLen=$l(MKBDRResonValue,",")
			for i=1:1:ReasonsLen
			{
				s OneReason=$p(MKBDRResonValue,",",i)
				s ReasonStr=$select(OneReason="A":"缺诊断短语",OneReason="B":"诊断短语不正确",OneReason="C":"缺诊断表达式",OneReason="D":"诊断表达式不正确",OneReason="E":"缺ICD",OneReason="F":"ICD不正确")
				s:Reason'="" Reason=Reason_","_ReasonStr
				s:Reason="" Reason=ReasonStr
			}
			
			s MKBDRReson = Reason
		}
		s MKBDRNote=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),11)
		s MKBDRStatus=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),12)
		s MKBDROtherDesc=$LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),13)
		s MKBDRType = $LISTGET($G(^User.MKBDataReviewedD(MKBDRRowId)),14) 
		if ((($ZCONVERT(MKBDRDiagDesc,"U")[desc)||($ZCONVERT(MKBDRDiag,"U")[desc)))&((MKBDRResonValue[reason)||(reason=""))&((MKBDRStatus=status)||(status=""))&(MKBDRType = type){
			d OutputRow
		}
	}
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBDRRowId,MKBDRDiagDr,MKBDRDiagDesc,MKBDRStructChild,MKBDRDiag,MKBDRTermDR,MKBDRStructResultID,MKBDRStructDesc,MKBDRSupplement,MKBDRMRCDr,MKBDRMRCCode,MKBDRMRCDesc,MKBDRICDDesc,MKBDRReson,MKBDRNote,MKBDRStatus,MKBDRResonValue,MKBDRMRADMDR,MKBDROtherDesc,MKBDRType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
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

/// Creator:石萧伟
/// CreatDate:2019-06-20
/// Description:新增主表数据(上报)
/// Table: 
/// Input:str  字段值串
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBDataReviewed).SaveReviewedDia()
ClassMethod SaveReviewedDia(id As %String, str As %String) As %String
{
	q:str="" ""
	if (id '= "")
	{
		s obj=##class(User.MKBDataReviewed).%OpenId(id)
	}
	else
	{	
		s obj=##class(User.MKBDataReviewed).%New()	
	}
	
	s diadr = $p(str,"^",1)
	s obj.MKBDRDiagDr = diadr
		
	s obj.MKBDRDiag=$p(str,"^",2)
	
	s admdr = $p(str,"^",3)
	//d obj.MKBDRMRADMDRSetObjectId(admdr)
	s obj.MKBDRMRADMDR=admdr
	
	
	s termdr = $p(str,"^",4)
	d obj.MKBDRTermDRSetObjectId(termdr)
	
	s obj.MKBDRStructResultID=$p(str,"^",5)
	s obj.MKBDRSupplement=$p(str,"^",6)

	s icddr = $p(str,"^",7)
	s obj.MKBDRMRCDr=(icddr)
		
	s obj.MKBDRICDDesc=$p(str,"^",8)
	
	s obj.MKBDRReson=$p(str,"^",9)
	s obj.MKBDRNote=$p(str,"^",10)
	s obj.MKBDRStatus=$p(str,"^",11)
	s obj.MKBDROtherDesc=$p(str,"^",12)
	s obj.MKBDRType=$p(str,"^",13)
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}"
	}
	else
	{

		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
		s tip = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				
		Tro	

	}
	d obj.%Close()
	quit result
}

/// Creator:石萧伟
/// CreatDate:2019-06-20
/// Description:修改审核状态
/// Table: 
/// Input:
/// Return:
ClassMethod uptateStatus(rowid As %String, status As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBDataReviewed).%OpenId(rowid)        ;先备份再更新
		s obj.MKBDRStatus = status
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		d obj.%Close()
		quit result			
	}
}

/// Creator:石萧伟
/// CreatDate:2019-06-21
/// Description:审核
/// Table: 
/// Input:
/// Return:
ClassMethod UpdateDiag(rowid As %String, MKBSDDiag As %String, MKBSDStatus As %String, MKBSDICDTermDr As %String, MKBSDChildStructFlag As %String, pycode As %String, icddesc As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDDiag'="" bobj.MKBSDDiag=obj.MKBSDDiag
		/*if MKBSDICDTermDr'=""
		{
			s MKBTPICDRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBSDICDTermDr," ICD编码",0))
			s MKBTPDICDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPICDRowid,0))*/
			s obj.MKBSDICD=MKBSDICDTermDr //$lg($g(^User.MKBTermProDetailD(MKBTPDICDRowid)),3)			
			s obj.MKBSDICDDesc=icddesc //$lg($g(^User.MKBTermD(MKBSDICDTermDr)),3)

		//}
	
		s:MKBSDStatus'="" bobj.MKBSDStatus=obj.MKBSDStatus
		s:rowid'="" bobj.MKBSDRowid=rowid
		s:MKBSDChildStructFlag'="" bobj.MKBSDChildStructFlag=obj.MKBSDChildStructFlag
		
		s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDDiag'="" eobj.MKBSDDiag=MKBSDDiag
		//s:MKBSDICDTermDr'="" eobj.MKBSDICDTermDr=$g(MKBSDICDTermDr)
		s eobj.MKBSDICDTermDr=""
		s:MKBSDStatus'="" eobj.MKBSDStatus=MKBSDStatus
		s:rowid'="" eobj.MKBSDRowid=rowid
		s:MKBSDChildStructFlag'="" eobj.MKBSDChildStructFlag=MKBSDChildStructFlag

		s Diag=obj.MKBSDDiag
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
    	;Set UpdateUserDR=1
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate
		if (MKBSDDiag'="")
		{
			s obj.MKBSDDiag=MKBSDDiag
		}
		if (MKBSDStatus '= ""){
			s obj.MKBSDStatus=MKBSDStatus
		}
		
		/*if (MKBSDICDTermDr '= "")
		{
			d obj.MKBSDICDTermDrSetObjectId(MKBSDICDTermDr)
			s MKBTPICDRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBSDICDTermDr," ICD编码",0))
			s MKBTPDICDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPICDRowid,0))*/
			s obj.MKBSDICD=MKBSDICDTermDr //$lg($g(^User.MKBTermProDetailD(MKBTPDICDRowid)),3)			
			s obj.MKBSDICDDesc=icddesc //$lg($g(^User.MKBTermD(MKBSDICDTermDr)),3)
		//}
		if (MKBSDChildStructFlag '= "")
		{
			s obj.MKBSDChildStructFlag=MKBSDChildStructFlag
		}
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			//删除诊断名全文索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(bobj.MKBSDDiag,rowid)
			//s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(bobj.MKBSDDiag)
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(bobj.MKBSDDiagPYCode,rowid)
			//添加新的诊断名全文索引
			//s PINYINNewDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(pycode,rowid)
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(MKBSDDiag,rowid)

			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,Diag,"U",eobj,bobj)
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		d bobj.%Close()
		d eobj.%Close()
		d obj.%Close()
		quit result			
	}
}

/// Creator:石萧伟
/// CreatDate:2019-04-18
/// Description:新增主表数据(上报)
/// Table: 
/// Input:MKBSDDiag 诊断名 state状态  pycode拼音码 termid术语id
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBDataReviewed).SaveNewParDia("疼痛","X","","")
ClassMethod SaveNewParDia(basedr As %String, MKBSDDiag As %String, state As %String, pycode As %String, icd As %String, termid As %String, supplement As %String, resultids As %String, icddesc As %String) As %String
{
	
	s obj=##class(User.MKBStructuredData).%New()
	s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()   
	s eobj.MKBSDDiag=MKBSDDiag
	s eobj.MKBSDStatus=state
	s eobj.MKBSDDiagPYCode=pycode
	s eobj.MKBSDTotalFreq=0
	s eobj.MKBSDBaseDr=basedr
	
	s obj.MKBSDDiag=MKBSDDiag
	s obj.MKBSDDiagPYCode=pycode
	s obj.MKBSDTotalFreq=0
	Set UpdateDate=$p($h,",",1)       //上传日期
	Set UpdateUserDR=%session.Get("LOGON.USERID")
	d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
	s obj.MKBSDDate=UpdateDate	
	s obj.MKBSDStatus=state
	//d obj.MKBSDMRCDrSetObjectId(icd)
	d obj.MKBSDBaseDrSetObjectId(basedr)
	/*if (icd '= "")
	{
		d obj.MKBSDICDTermDrSetObjectId(icd)
		s MKBTPICDRowid=$o(^User.MKBTermPropertyI("DescIndex",icd," ICD编码",0))
		s MKBTPDICDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPICDRowid,0))*/
		s obj.MKBSDICD=icd //$lg($g(^User.MKBTermProDetailD(MKBTPDICDRowid)),3)			
		s obj.MKBSDICDDesc=icddesc //$lg($g(^User.MKBTermD(icd)),3)

	//}	
	if (termid'=""){
		s obj.MKBSDChildStructFlag = 1
	}
	
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		if (termid'="")
		{	
			d ##class(web.DHCBL.MKB.MKBStructuredData).SaveData(id,"",resultids,"",termid,supplement)
		}
		//s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
		d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(pycode,id)
		d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(MKBSDDiag,id)
		set result = "{success:'true',id:'"_id_"'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,MKBSDDiag,"A",eobj)
	}
	else
	{
		s ^TMPSXW(1)=1
		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  				
		Tro	
				s tip = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		if (tip["键不唯一")
		{
			s oldid = $o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MKBSDDiag,0))
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"&&"_oldid_"'}" 		
		}
	}
	d eobj.%Close()
	d obj.%Close()
	quit result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataReviewed","GetSDList","","","糖尿病[Ⅰ型,酮症酸中毒]",15879)
/// w ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataReviewed","GetSDList","高血压性心脏病和肾脏病伴心力衰竭和肾衰竭[伴心肌损伤EF：35%]","高血压性心脏病和肾脏病伴心力衰竭和肾衰竭","高血压[肾病]",14679,"I13.201")
Query GetSDList(diag As %String, icd As %String, result As %String, termid As %String, icdcode As %String) As %Query(ROWSPEC = "Rowid,MKBSDDiag,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDInitialICD,MKBSDAlias,MKBSDNote,MKBSDLocStr,MKBSDLocs,MKBSDUpdateUser,MKBSDOAlias,MKBSDOOther,MKBSDSegmentation,sumloc,MKBSDMDr,MKBSDDiaSource,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc,Reason,MKBSDDiagPYCode,MKBSDResultTermdr,MergeFlag")
{
}

ClassMethod GetSDListExecute(ByRef qHandle As %Binary, diag As %String, icd As %String, result As %String, termid As %String, icdcode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	
	s Config= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")
	//if Config'["ICD"
	//{
	s BaseConfig=Config
	//}

	
	s Diag=$zstrip(diag,"<>W")
	s Icd=$zstrip(icd,"<>W")
	s Res=$zstrip(result,"<>W")
	s icdcode=$zstrip(icdcode,"<>W")
	s icdcode=$replace(icdcode,".","")
	if (Diag'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
			continue:MKBSDBase'=BaseConfig
			if MKBSDDesc=Diag
			{
				s dt(1,MKBSDRowid)=""	
			}
			else
			{
				s dt(2,MKBSDRowid)=""
			}
		}
	}
	merge arr=dt
	
	if (Icd'="")
	{
		s MKBICD=""
		for
		{
			s MKBICD=$o(^User.MKBStructuredDataI("ICDIndex",MKBICD))
			q:MKBICD=""
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("ICDIndex",MKBICD,MKBSDRowid))
				q:MKBSDRowid=""
				;s MRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
				;continue:MRC=""
				s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
				continue:MKBSDBase'=BaseConfig
				s MRCDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
				if MRCDesc[Icd
				{
					if MRCDesc=Icd
					{
						
						if $d(arr(2,MKBSDRowid))
						{
							s it(2,MKBSDRowid)=""
						}
						else
						{
							s it(1,MKBSDRowid)=""
						}
					}
					else
					{
						if $d(arr(1,MKBSDRowid))
						{
							continue
						}
						s it(2,MKBSDRowid)=""
					}
				}
			}
		}
	}
	merge arr=it
	if icdcode'=""
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_$zconvert(icdcode,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
			continue:MKBSDBase'=BaseConfig
		
			if MKBSDICD=icdcode
			{
				
				if $d(arr(2,MKBSDRowid))
				{
					s ct(2,MKBSDRowid)=""
				}
				else
				{
					s ct(1,MKBSDRowid)=""
				}
			}
			else
			{
				if $d(arr(1,MKBSDRowid))
				{
					continue
				}
				s ct(2,MKBSDRowid)=""
			}
		
		}
		
	}
	merge arr=ct
	if (Res'="")
	{
		if Res'["["
		{
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termid,MKBSDRowid))
				q:MKBSDRowid=""
				s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
				continue:MKBSDBase'=BaseConfig
				s rt(1,MKBSDRowid)=""
			}
		}
		else
		{
			
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termid,MKBSDRowid))
				q:MKBSDRowid=""
				s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
				continue:MKBSDBase'=BaseConfig
				s (Structresult,MKBSRResultId,MKBSDRRowid)=""
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
				continue:sequence=""
				if sequence'=""
				{
					
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
					s MKBSDRResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
					s Structresults=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBSDRResultId,termid)
	
				}
				continue:Structresults'["["
			
				s LengthOfResult=$l($p(Structresults,"[",2),",")
				s CountFlag=0
				s LengthOfRes=$l($p(Res,"[",2),",")
				s Structresult=$e($p(Structresults,"[",2),1,*-1)
				s Ress=$e($p(Res,"[",2),1,*-1)
				for i=1:1:LengthOfRes
				{
					s one=$p(Ress,",",i)
					continue:one=""
					if Structresult[one
					{
						s CountFlag=CountFlag+1
					}
				}
				if CountFlag=LengthOfRes
				{
					if LengthOfResult>LengthOfRes
					{
						
						s rt(2,MKBSDRowid)=""
					}
					else
					{
						if $d(arr(2,MKBSDRowid))
						{
							s rt(2,MKBSDRowid)=""
						}
						else
						{
							s rt(1,MKBSDRowid)=""
						}
					}
				}
			}
		}
		
	}


	merge arr=rt
	
	
	if $d(arr)
	{
		s n=0
		for
		{
			s n=$o(arr(n))
			q:n=""
		
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(arr(n,MKBSDRowid))
				q:MKBSDRowid=""
				;诊断名，数据处理工厂的id，icd描述，icd编码，icddr，结构化诊断描述，结构化诊断id串，补充诊断
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
				s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值

				s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)  //合并状态
				s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
				s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
				s MKBSDCenterWord=""                         ;通过中心词id获取描述
				if MKBSDCenterWordID'=""
				{
					s WordCount=$l(MKBSDCenterWordID,",")
					for i=1:1:WordCount
					{
						s WordEach=$p(MKBSDCenterWordID,",",i)
						s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
						s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_"、"_MKBSDWord
						s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
					}	
				}
				s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
				s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
				s:MKBSDDates="" MKBSDDate=""
				s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
				s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
				s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
				s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
				s sumloc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
				s Rowid=MKBSDRowid
				s Result=""
				
				continue:MergeFlag'=""
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
				if sequence'=""
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
					if MKBSDRRowid'=""
					{
						s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
						s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
						continue:MKBSDResultTermdr=""
						s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
						s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
						if MKBSDSupplement'=""
						{
							if Result["]"
							{
								s str=$e(Result,1,*-1)
								s Result=str_",("_MKBSDSupplement_")]"
							}
							else
							{
								s Result=Result_"[("_MKBSDSupplement_")]"
							}
						}					
					}
					else
					{
						s Result=""
					}
				}
				//s AliasStr=""
				s MKBSDOAlias=""
				if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
				{
					s MKBSDORowid=0
					for
					{
						s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
						q:MKBSDORowid=""
						s AliasStr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
						s:MKBSDOAlias'="" MKBSDOAlias=MKBSDOAlias_"、"_AliasStr
						s:MKBSDOAlias="" MKBSDOAlias=AliasStr
					}
				}
				//s OtherStr=""
				s MKBSDOOther=""
				if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
				{
					s MKBSDORowid=0
					
					for
					{
						s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
						q:MKBSDORowid=""
						s OtherStr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
						s:MKBSDOOther'="" MKBSDOOther=MKBSDOOther_"、"_OtherStr
						s:MKBSDOOther="" MKBSDOOther=OtherStr
					}
				}
				s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
				s MKBSDLocs=""
				s MKBSDLocStr=""
				s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
				if MKBSDLocs'=""
				{
					s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
					s loclen=$l(MKBSDLocs,",")
					for i=1:1:loclen
					{
						s Proid=$p(MKBSDLocs,",",i)
						continue:Proid=""
						s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
						s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_","_ProLocDesc
						s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
					}
				}
				s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)    //别名字段
				s MKBSDNote=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),16)    //备注  存上报理由
				s Reasons=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),17)  //上报理由
				s Reason=""
				if Reasons'=""
				{
					s ReasonsLen=$l(Reasons,",")
					for i=1:1:ReasonsLen
					{
						s OneReason=$p(Reasons,",",i)
						s ReasonStr=$select(OneReason="A":"缺诊断短语",OneReason="B":"诊断短语不正确",OneReason="C":"缺诊断表达式",OneReason="D":"诊断表达式不正确",OneReason="E":"缺ICD",OneReason="F":"ICD不正确")
						s:Reason'="" Reason=Reason_","_ReasonStr
						s:Reason="" Reason=ReasonStr
					}
				}
				s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),18)
				s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
				
				d getCTTitle
			}
		}	 
	}
		
	///""MKBSDDiagPYCode"":"""_MKBSDDiagPYCode_"""}"  
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBSDDiag,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDInitialICD,MKBSDAlias,MKBSDNote,MKBSDLocStr,MKBSDLocs,MKBSDUpdateUser,MKBSDOAlias,MKBSDOOther,MKBSDSegmentation,sumloc,MKBSDMDr,MKBSDDiaSource,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc,Reason,MKBSDDiagPYCode,MKBSDResultTermdr,MergeFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSDListExecute ]
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

/// 石萧伟
/// 获取工厂注册当前医院icd库的id
ClassMethod getICDTermId()
{
	s Rowid=0
	s id = ""
	for
	{
		s Rowid=$o(^User.MKBStructuredBaseI("FlagIndex"," Y",Rowid))
		q:Rowid=""
  		s id = Rowid		
	}
    s MKBSTBICDDr=$LISTGET($G(^User.MKBStructuredBaseD(id)),3)
	q MKBSTBICDDr
}

/// 李得原
/// 2019-08-29
/// 各版本icd对照类似诊断接口
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataReviewed","GetICDList","淋巴瘤","淋巴瘤",14870)
Query GetICDList(icd As %String, result As %String, termid As %String) As %Query(ROWSPEC = "Rowid,MKBSDDiag,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDInitialICD,MKBSDAlias,MKBSDNote,MKBSDLocStr,MKBSDLocs,MKBSDUpdateUser,MKBSDOAlias,MKBSDOOther,MKBSDSegmentation,sumloc,MKBSDMDr,MKBSDDiaSource,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc,Reason,MKBSDDiagPYCode,MKBSDResultTermdr,MergeFlag")
{
}

ClassMethod GetICDListExecute(ByRef qHandle As %Binary, icd As %String, result As %String, termid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Icd=$zstrip(icd,"<>W")
	s Res=$zstrip(result,"<>W")
	s Config= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")
		s Config=$e(Config,4,*)        //取配置数据来源
	
	if (Icd'="")                //判断icd是否为空
	{
		s MKBICDRowid=0
		for
		{
			s MKBICDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_Icd,MKBICDRowid))    //走全文索引查
			q:MKBICDRowid=""
			continue:MKBICDRowid'["ICD"                    //过滤不是各版本icd的数据
			s MKBICDrowid=$replace(MKBICDRowid,"ICD","")
			s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDrowid)),3)   //各版本icd中的中文描述
			s MKBICDBase=$lg($g(^User.MKBICDContrastD(MKBICDrowid)),6)   //各版本icd中的base
			continue:MKBICDBase'[Config
			if MKBICDDesc=Icd              //完全匹配
			{
				s it(1,MKBICDrowid)=""
			}
			else                           //不完全匹配
			{
				s it(3,MKBICDrowid)=""
			}
		}
	}
	merge arr=it 
	if (Res'="")              //判断结构化结果是否为空
	{
		
		if Res'["["    //只有中心词
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBICDContrastResultI("TermIndex",termid,MKBICDRowid))
				q:MKBICDRowid=""
				s MKBICDRRowid=0
				for
				{
					s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
					q:MKBICDRRowid=""
					s MKBICDIds=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2) //结构化结果串（属性）
					if MKBICDIds=""
					{
						s MKBICDBase=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
						continue:MKBICDBase'[Config
						s rt(2,MKBICDRowid)=""             //完全匹配
					}
				}

			}
			
		}
		else      //包含属性内容的
		{
			//"霍乱[古典型]"
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBICDContrastResultI("TermIndex",termid,MKBICDRowid))
				q:MKBICDRowid=""
				s MKBICDBase=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
				continue:MKBICDBase'[Config
				s (Structresult,MKBICDRResultId,MKBICDRRowid,sequence)=""         //初始化为空
				s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,0))
				if sequence'=""
				{
					s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,0))
					s MKBICDRResultId=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
					s Structresults=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDRResultId,termid)
				}
				continue:Structresults'["["    //过滤没有属性内容的
				s LengthOfResult=$l($p(Structresults,"[",2),",")  //表中取出来的结构化结果有几个属性内容
				s CountFlag=0
				s LengthOfRes=$l($p(Res,"[",2),"，")              //入参取出来的结构化结果有几个属性内容
				s Structresult=$e($p(Structresults,"[",2),1,*-1)     
				s Ress=$e($p(Res,"[",2),1,*-1)
				for i=1:1:LengthOfRes
				{
					s one=$p(Ress,"，",i)
					continue:one=""
					if Structresult[one
					{
						s CountFlag=CountFlag+1     //有几个相同的属性内容
					}
				}
				if CountFlag=LengthOfRes                  // 入参是：生物型  
				{
					if LengthOfResult>LengthOfRes 
					{         								//表中是：生物型 古典型
						if ('$d(arr(1,MKBICDRowid)))&('$d(arr(2,MKBICDRowid)))
						{
							s rt(3,MKBICDRowid)=""
						}
					}
					else
					{
						if $d(arr(3,MKBICDRowid))
						{
							k arr(3,MKBICDRowid)
							s rt(2,MKBICDRowid)=""
						}
						else
						{
							if '$d(arr(1,MKBICDRowid))
							{
								s rt(2,MKBICDRowid)=""
							}
						}
					}
				}
			}
		}
		
	}
	merge arr=rt    //arr(1,"rowid1")=""   arr(2,"rowid2")="" 
	
	if $d(arr)
	{
		s n=0
		for
		{
			s n=$o(arr(n))
			q:n=""
			
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(arr(n,MKBSDRowid))
				q:MKBSDRowid=""
				;诊断名，数据处理工厂的id，icd描述，icd编码，icddr，结构化诊断描述，结构化诊断id串，补充诊断
				s MKBSDDiag=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),3)
				s MKBSDMDr=""    //MRC指向
				s MKBSDICD=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),4) //在ICD字段取值
				continue:MKBSDICD=""
				s MKBSDMrc=MKBSDDiag  //在ICD描述字段取值

				s MergeFlag=""  //合并状态
				s MKBSDStatus=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),13)
				s MKBSDCenterWordID=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),9)
				s MKBSDCenterWord=""                         ;通过中心词id获取描述
				if MKBSDCenterWordID'=""
				{
					s WordCount=$l(MKBSDCenterWordID,",")
					for i=1:1:WordCount
					{
						s WordEach=$p(MKBSDCenterWordID,",",i)
						s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
						s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_"、"_MKBSDWord
						s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
					}	
				}
				s MKBSDDates=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),14)
				s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
				s:MKBSDDates="" MKBSDDate=""
				s MKBSDUpdateUsers=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),15)
				s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
				s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
				s MKBSDSegmentation=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),12)
				s sumloc=""
				s Rowid=MKBSDRowid
				s Result=""
				
				continue:MergeFlag'=""
				s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowid,0))
				if sequence'=""
				{
					s MKBSDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowid,sequence,0))
					if MKBSDRRowid'=""
					{
						s MKBSDResultID=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",MKBSDRRowid)),2)  //获取结构化结果串
						s MKBSDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",MKBSDRRowid)),4) //获取结构化结果Termdr
						continue:MKBSDResultTermdr=""
						s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
						s MKBSDSupplement=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",MKBSDRRowid)),5)
						if MKBSDSupplement'=""
						{
							if Result["]"
							{
								s str=$e(Result,1,*-1)
								s Result=str_",("_MKBSDSupplement_")]"
							}
							else
							{
								s Result=Result_"[("_MKBSDSupplement_")]"
							}
						}					
					}
					else
					{
						s Result=""
					}
				}
				//s AliasStr=""
				s MKBSDOAlias=""

				//s OtherStr=""
				s MKBSDOOther=""

				s MKBSDDiaSource=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),6)
				s MKBSDLocs=""
				s MKBSDLocStr=""
				s MKBSDLocs=""   //科室串

				s MKBSDAlias=""  //别名字段
				s MKBSDNote=""    //备注  存上报理由
				s Reasons=""  //上报理由
				s Reason=""

				s MKBSDInitialICD=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),17)
				s MKBSDDiagPYCode=""
				
				d getCTTitle
			}
		}	 
	}
		
	///""MKBSDDiagPYCode"":"""_MKBSDDiagPYCode_"""}"  
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBSDDiag,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDInitialICD,MKBSDAlias,MKBSDNote,MKBSDLocStr,MKBSDLocs,MKBSDUpdateUser,MKBSDOAlias,MKBSDOOther,MKBSDSegmentation,sumloc,MKBSDMDr,MKBSDDiaSource,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc,Reason,MKBSDDiagPYCode,MKBSDResultTermdr,MergeFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetICDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetICDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDListExecute ]
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

/// 石萧伟
/// 如果诊断名，icd和结构化诊断一样则重复
/// w ##class(web.DHCBL.MKB.MKBDataReviewed).SameValidate("2xtnb","糖糖","")
ClassMethod SameValidate(dia, icd, result)
{
	s flag=0
	//s:dia'="" dia=$ZCONVERT(dia,"U") //转换成大写
	//s:icd'="" icd=$ZCONVERT(icd,"U") //转换成大写
	//s:result'="" result=$ZCONVERT(result,"U") //转换成大写
	
	s:dia="" dia=-100000000000000
	s:icd="" icd=-100000000000000
	s:result="" result=-100000000000000
	s flag=$d(^User.MKBDataReviewedI("ICDDiaResultIndex",dia,icd,result))
	q flag
}

}
