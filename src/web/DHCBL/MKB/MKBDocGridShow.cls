Class web.DHCBL.MKB.MKBDocGridShow Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2021-08-18
/// Input:
/// Description：保存修改内容
/// return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(user, type, desc) As %String
{
    
    s result = ""


    s obj=##class(User.MKBDocGridShow).%New()
    s obj.MKBDGUser = user
    s obj.MKBDGOptType = type
    s obj.MKBDGContent = desc
    s obj.MKBDGDate =  $p($h,",",1)       //上传时间日期

    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc){
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }

    
    q result
}

/// Creator:石萧伟
/// CreatDate:2021-08-18
/// Description:获得文献管理表内容
/// Table: User.DHCDSSDocuManage
/// Input: Desc名称, EngDesc英文名称, Disease诊断, Dept科室, StartDate开始日期, EndDate截止日期, KeyWords关键词, Institution机构, Month年月, Source出处, User操作人, Reviewer审核人, State状态
/// Return:返回所有文献管理表内容
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDocGridShow","GetDocList","","淋巴","","","","","","","","","","","","","")
Query GetDocList(Id, Desc, EngDesc, Disease, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type, User, Reviewer, State) As %Query(ROWSPEC = "RowId,DocuCode,DocuDesc,DocuEngDesc,DocuPath,DocuKeyWords,DocuType,DocuInstitution,DocuSource,DocuMonth,DocuState,DocuModifyDate,DocuModifyUser,DocuReviewer,JoinDisease,JoinDept")
{
}

ClassMethod GetDocListExecute(ByRef qHandle As %Binary, Id, Desc, EngDesc, Disease, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type, User, Reviewer, State) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	if ((Desc="")&&(Disease="")){
		q ""
	}
 	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
 	s:EngDesc'="" EngDesc=$ZCONVERT(EngDesc,"U") //转换成大写
 	s:KeyWords'="" KeyWords=$ZCONVERT(KeyWords,"U") //转换成大写
 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
 	s:Disease'="" Disease="<"_Disease_">"
 	s:Dept'="" Dept="<"_Dept_">"
 	s:EndDate="" date=EndDate
	s:EndDate'="" date=EndDate_"00:00:00"
	for{
		s date=$o(^User.DHCDSSDocuManageI("DateIndex",date),-1) q:date=""
		q:((StartDate'="")&&($ZDH(date,3)<$ZDH(StartDate,3)))
		s RowId=""
		for
		{
			s RowId = $o(^User.DHCDSSDocuManageI("DateIndex",date,RowId),-1)
			q:RowId=""
			s DocuCode = $lg($g(^User.DHCDSSDocuManageD(RowId)),2) //文献代码
			s DocuDesc = $lg($g(^User.DHCDSSDocuManageD(RowId)),3) //中文文献名称
			s PINYINDesc=""
			s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDesc)  
			s DocuEngDesc = $lg($g(^User.DHCDSSDocuManageD(RowId)),4) //英文文献名称
			s DocuPath = $lg($g(^User.DHCDSSDocuManageD(RowId)),5) //文献路径
			s DocuKeyWords = $lg($g(^User.DHCDSSDocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^User.DHCDSSDocuManageD(RowId)),7) //类型
			s DocuInstitution = $lg($g(^User.DHCDSSDocuManageD(RowId)),8) //发布机构
			s DocuSource = $lg($g(^User.DHCDSSDocuManageD(RowId)),9) //指南出处
			s DocuMonth = $lg($g(^User.DHCDSSDocuManageD(RowId)),10) //发布年月
			s DocuAssociation = $lg($g(^User.DHCDSSDocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^User.DHCDSSDocuManageD(RowId)),12) //状态
			s DocuModifyDate = $lg($g(^User.DHCDSSDocuManageD(RowId)),13) //修改时间
			s DocuModifyUser = $lg($g(^User.DHCDSSDocuManageD(RowId)),14) //修改人
			s DocuReviewer = $lg($g(^User.DHCDSSDocuManageD(RowId)),15) //审核人
			//关联诊断
			s JoinDisease="",DiseaseStr=""
			s DiseaseDR=""
			for {
				s DiseaseDR=$o(^User.DHCDSSDocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
				s DiseaseStr=DiseaseStr_"<"_DiseaseDR_">"
				
				s DiseaseDesc=$lg($g(^User.DHCDSSDiseaseDictD(DiseaseDR)),3)
				if (JoinDisease=""){
					s JoinDisease=DiseaseDesc
				}else{
					s JoinDisease=JoinDisease_"，</br>"_DiseaseDesc
				}
			}
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^User.DHCDSSDocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptStr=DeptStr_"<"_DeptDR_">"	
				
				s DeptName=$lg($g(^User.DHCDSSDiseaseDeptDictD(DeptDR)),3)
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_"，</br>"_DeptName
				}	
			}
			
			if (($ZCONVERT(DocuDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&(($ZCONVERT(DocuEngDesc,"U")[EngDesc)||(EngDesc=""))&&(($ZCONVERT(DocuKeyWords,"U")[KeyWords)||(KeyWords=""))&&((DocuType=Type)||(Type=""))&&(($ZCONVERT(DocuInstitution,"U")[Institution)||(Institution=""))&&((DocuMonth=Month)||(Month=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((DocuModifyUser=User)||(User=""))&&((DocuReviewer=Reviewer)||(Reviewer=""))&&((DocuState=State)||(State=""))&&((DiseaseStr[Disease)||(Disease=""))&&((DeptStr[Dept)||(Dept="")){
		  		d OutputRow
		  	}
		}
	}
	   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DocuCode,DocuDesc,DocuEngDesc,DocuPath,DocuKeyWords,DocuType,DocuInstitution,DocuSource,DocuMonth,DocuState,DocuModifyDate,DocuModifyUser,DocuReviewer,JoinDisease,JoinDept)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocListExecute ]
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

ClassMethod GetDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
