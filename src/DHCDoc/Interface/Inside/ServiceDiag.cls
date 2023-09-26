Class DHCDoc.Interface.Inside.ServiceDiag Extends DHCDoc.Util.RegisteredObject
{

/// Creator:      郭荣勇
/// CreatDate:    2018.03.20
/// Description:  获取本次就诊诊断记录
/// Table:        
/// Input:        入参：MR_Adm表Rowid，
/// 					ICDType：是否获取中医诊断.空-获取所有诊断，1-仅获取中医诊断，2-仅获取西医诊断
/// 					DiagnosTypeCode：诊断类型代码.(空 获取全部,MRC_DiagnosType->DTYP_Code)
/// Return:       出参：ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断添加日期 发病日期 诊断状态描述 诊断级别(数字) 
/// 						主诊断标识 诊断前缀 诊断顺序 诊断添加科室ID 诊断添加医生代码 诊断添加医生描述 诊断添加时间 诊断类型 结构化诊断描述
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.ServiceDiag","DiagnosList","166","","") 
Query DiagnosList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %Query(ROWSPEC = "DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate:%String,DiagStat:%String,DiagnosLeavel:%String,MainDiagFlag:%String,DiagnosPrefix:%String,DiagnosNumber:%String,MRDIAAddLocDr:%String,MRDIADocCode:%String,MRDIADocDesc:%String,MRdiagnosTime:%String,DiagnosCat:%String,SDSDesc:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","35","","")
	Set repid1=$I(^CacheTemp)
	If $g(ind1)="" Set ind1=1
	if MRADMID="" {  
	    d ResetDiagnosListVar
		Set qHandle=$lb(0,repid1,0)
		Quit $$$OK
	}
	s DiagnosNumber=0
	Set rsObj=##Class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	If rsObj.QueryIsValid() { 
		 Set Status=rsObj.Execute(MRADMID,ICDType,DiagnosTypeCode)
		 If 'Status Quit
		 While rsObj.Next() {
			;ICD描述
			Set DiagnosDesc=rsObj.Data("DiagnosICDDesc")
			;诊断表ID
			Set DiagnosValue=rsObj.Data("MRDIARowId")
			;ICD诊断ID
			Set DiagnosCodeRowid=rsObj.Data("MRCIDRowId")
			;诊断注释
			Set DiagnosMRDesc=rsObj.Data("DiagnosNotes")
			;ICDCode
			Set DiagnosICDCode=rsObj.Data("MRCIDCode")
			;诊断类型
			Set DiagnosType=rsObj.Data("DiagnosType")
			;日期
			Set DiagnosDate=rsObj.Data("DiagnosDate")
			;发病日期
			Set DiagnosOnsetDate=rsObj.Data("DiagnosOnsetDate")
			;诊断状态
			Set DiagStat=rsObj.Data("DiagnosStatus")
			;诊断级别
			Set DiagnosLeavel=rsObj.Data("DiagnosLeavel")
			;主诊断标识(Y/N)
			Set MainDiagFlag=rsObj.Data("MainDiagFlag")
			s MainDiagFlag=$CASE(MainDiagFlag,"是":"Y","Y":"Y",:"N")
			;诊断前缀
			Set DiagnosPrefix=rsObj.Data("DiagnosPrefix")
			;----------以下为新增字段
			s DiagnosNumber=DiagnosNumber+1 ;rsObj.Data("DiagnosNumber")
			s MRDIAAddLocDr=rsObj.Data("MRDIAAddLocDr")
			s MRDIADocCode=rsObj.Data("DiagnosDoctorCode")
			;开立医生
			s MRDIADocDesc=rsObj.Data("DiagnosDoctor")		
			s MRdiagnosTime=rsObj.Data("DiagnosTime")
			s MRdiagnosTime=..%ZT(..%ZTH(MRdiagnosTime), 1)
			//分类：西医、中医、证型
			Set DiagnosCat=rsObj.Data("DiagnosCat")
			;结构化诊断描述
			Set SDSDesc=rsObj.Data("SDSDesc")
			d DiagnosListOutput
			
		 }
	}
	kill rsObj
	
	Set qHandle=$lb(0,repid1,0)
	Quit $$$OK
DiagnosListOutput
	set Data=$lb(DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,DiagnosNumber,MRDIAAddLocDr,MRDIADocCode,MRDIADocDesc,MRdiagnosTime,DiagnosCat,SDSDesc)  //
	Set ^CacheTemp(repid1,ind1)=Data
	Set ind1=ind1+1
	quit
ResetDiagnosListVar
	set (DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,DiagnosNumber,MRDIAAddLocDr,MRDIADocCode,MRDIADocDesc,MRdiagnosTime,DiagnosCat,SDSDesc)=""
	quit
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      nikang
/// CreatDate:    2020.11.20
/// Description:  插入诊断
/// Table:        
/// Input:        EpisodeID:就诊RowId   DiagItemStr:诊断信息串	AdmPara：诊断相关信息	CTLocRowId:科室	UserRowId:用户ID
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).InsertMRDiagnos() 
ClassMethod InsertMRDiagnos(EpisodeID As %String, DiagItemStr As %String, AdmPara As %String, CTLocRowId As %String, UserRowId As %String)
{
	;n (EpisodeID,DiagItemStr,AdmPara,CTLocRowId,UserRowId)
	Set mradm=$p(^PAADM(EpisodeID),"^",61)
	if mradm=""{
		s Ret=-100
	}else{
		Set Ret=##class(web.DHCDocDiagnosEntryV8).InsertMRDiagnos(mradm,DiagItemStr,AdmPara,CTLocRowId,UserRowId)
	}
	q Ret
}

/// CreatDate:    2022.06.29
/// Description:  删除诊断
/// Table:        
/// Input:        MRDiagnosRowidStr:诊断RowId(多个以上箭头^分隔)   DiagItemStr:诊断信息串	UserRowId:用户ID	CTLocRowId:科室
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).InsertMRDiagnos() 
ClassMethod DeleteMRDiagnos(MRDiagnosRowidStr As %String, UserRowId As %String = "", CTLocRowId As %String = "")
{
	s Ret=##class(web.DHCDocDiagnosEntryV8).DeleteMRDiagnos(MRDiagnosRowidStr,UserRowId,CTLocRowId)
	q Ret
}

/// Creator:      王清雍
/// CreatDate:    2021.07.26
/// Description:  获取诊断类型描述(中医、西医、证型)
/// Table:        MR_Diagnos
/// Input:        DiagRowid:MR_Diagnos表RowId
/// Return:       该诊断的诊断类型(中医/西医/证型)
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagnosCat(DiagRowid) 
ClassMethod GetDiagnosCat(DiagRowid As %String)
{
	Q:DiagRowid="" ""
	Q ##class(DHCDoc.Diagnos.Common).GetDiagnosCat(DiagRowid)
}

/// Creator:      王清雍
/// CreatDate:    2021.07.26
/// Description:  获取单个诊断的描述
/// Table:        MR_Diagnos
/// Input:        DiagRowid:MR_Diagnos表RowId,NotLinkChildDiag:为Y时不显示该诊断的证型
/// Return:       诊断描述
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagDesc(DiagRowid[,NotLinkChildDiag]) 
ClassMethod GetDiagDesc(DiagRowid As %String, NotLinkChildDiag As %String = "")
{
	Q:DiagRowid="" ""
	Q ##class(DHCDoc.Diagnos.Common).GetDiagDesc(DiagRowid,NotLinkChildDiag)
}

/// Creator:      王清雍
/// CreatDate:    2021.07.26
/// Description:  获取患者就诊的诊断描述串
/// Table:        MR_Diagnos
/// Input:        DiagTypeCode:诊断类型代码,不为空只查询指定类型的诊断;MainFlag:Y只查询主诊断; OnlyICD为Y只查ICD诊断;DisplayNum为Y显示序号;Separator每个诊断直接的分割符(默认为分号)
/// Return:       诊断描述串
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(EpisodeID[,DiagTypeCode,MainFlag,OnlyICD,DisplayNum,Separator])
ClassMethod GetAdmDiagDesc(EpisodeID As %String, DiagTypeCode As %String = "", MainFlag As %String = "", OnlyICD As %String = "", DisplayNum As %String = "", Separator As %String = "")
{
	Q:EpisodeID="" ""
	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID,DiagTypeCode,MainFlag,OnlyICD,DisplayNum,Separator)
}

/// Creator:      nk
/// CreatDate:    2021.12.26
/// Description:  获取患者诊断录入过程中的其他诊断信息
/// Table:       
/// Input:        EpisodeID:就诊ID
/// Return:       诊断信息描述串：FirstAdm_$c(1)_ReAdmis_$c(1)_OutReAdm_$c(1)_TransAdm_$c(1)_ILIFlag_$c(1)_BPSystolic_$c(1)_BPDiastolic_$c(1)_Weight_$c(1)_SpecialStrCreat_$c(1)_PhysiologicalCycleId_$C(1)_Height
/// ReturnDesc:	  依次为： 是否初诊 是否复诊 是否出院复诊 是否转诊 流感样 血压收缩压 血压舒张压 体重 特殊人群 生理周期 身高
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagOtherInfo(5)
ClassMethod GetDiagOtherInfo(EpisodeID As %String)
{
	Q:EpisodeID="" ""
	Q ##class(web.DHCDocDiagnosEntryV8).GetDiagOtherInfo(EpisodeID)
}

}
