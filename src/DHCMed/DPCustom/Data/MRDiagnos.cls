/// 名称: DHCMed.DPCustom.Data.MRDiagnos
/// 描述: 与临床诊断相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-04-13
Class DHCMed.DPCustom.Data.MRDiagnos Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// ICD10
Property ICD10 As %String(TRUNCATE = 1);

/// 诊断名称
Property ICDDesc As %String(TRUNCATE = 1);

/// 诊断备注
Property Comments As %String(TRUNCATE = 1);

/// 诊断类型代码
Property ICDType As %String(TRUNCATE = 1);

/// 诊断类型名称
Property ICDTypeDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property ICDDate As %String(TRUNCATE = 1);

/// 诊断时间
Property ICDTime As %String(TRUNCATE = 1);

/// 诊断医生代码
Property ICDDoc As %String(TRUNCATE = 1);

/// 诊断医生姓名
Property ICDDocDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property ActDate As %String(TRUNCATE = 1);

/// 诊断时间
Property ActTime As %String(TRUNCATE = 1);

/// 诊断医生代码
Property ActUser As %String(TRUNCATE = 1);

/// 诊断医生姓名
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm("3996218")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-MRDiagnos","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS诊断信息
		Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(aEpisodeID)
		Quit:MRAdm="" return
		
		Set SubID=0
	    For {
			Set SubID=$o(^MR(MRAdm,"DIA",SubID))
			Quit:SubID=""
			
			Set obj=..GetObjById0(MRAdm_"||"_SubID)
			Continue:'$IsObject(obj)
	    	
			Set ActDate=obj.ActDate
			Continue:ActDate=""
			Set tmpDate=ActDate
			Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
			Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
			Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
			Continue:(aDateTo'="")&&(tmpDate>aDateTo)
			
	    	//Do $system.OBJ.Dump(obj)
			Do return.Insert(obj)
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByID("309655||468")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.MRDiagnos
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-MRDiagnos","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS诊断信息
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.MRDiagnos
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set MRAdm=$p(aId,"||",1)
	Set SubID=$p(aId,"||",2)
	
	Set ICDDR=$p($g(^MR(MRAdm,"DIA",SubID)),"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDR)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDR)),"^",2)
	Set Comments=""
	Set ICDDES=$g(^MR(MRAdm,"DIA",SubID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",SubID,"DHC",1))
	Set:(ICDDES'="")&&(ICDDES'=ICDDesc) Comments=Comments_" "_ICDDES
	Set:(ICDDHC'="")&&(ICDDHC'=ICDDesc) Comments=Comments_" "_ICDDHC
	
	Set ChildID=$o(^MR(MRAdm,"DIA",SubID,"TYP",""),-1)
	If ChildID'="" {
		Set ICDTypeDR=$g(^MR(MRAdm,"DIA",SubID,"TYP",ChildID))
		Set ICDType=$p($g(^MRC("DTYP",+ICDTypeDR)),"^",1)
		Set ICDTypeDesc=$p($g(^MRC("DTYP",+ICDTypeDR)),"^",2)
	} Else {
		Set ICDTypeDR=""
		Set ICDType=""
		Set ICDTypeDesc=""
	}
	
	Set ICDDate=$p($g(^MR(MRAdm,"DIA",SubID)),"^",7)
	Set ICDTime=$p($g(^MR(MRAdm,"DIA",SubID)),"^",8)
	Quit:(ICDDate="")||(ICDTime="") return
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,1)
	Set DocCode="",DocDesc=""
	Set CareProvID=$p($g(^MR(MRAdm,"DIA",SubID)),"^",4)
	If CareProvID'="" {
		Set DocCode=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,0))
		Set:DocCode'="" DocDesc=$p($g(^SSU("SSUSR",DocCode)),"^",2)
	}
	
	Set obj=##Class(DHCMed.DPCustom.Data.MRDiagnos).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = MRAdm_"||"_SubID
	Set obj.ICD10          = ICD10
	Set obj.ICDDesc        = ICDDesc
	Set obj.Comments       = Comments
	Set obj.ICDType        = ICDType
	Set obj.ICDTypeDesc    = ICDTypeDesc
	Set obj.ICDDate        = ICDDate
	Set obj.ICDTime        = ICDTime
	Set obj.ICDDoc         = DocCode
	Set obj.ICDDocDesc     = DocDesc
	Set obj.ActDate        = ICDDate
	Set obj.ActTime        = ICDTime
	Set obj.ActUser        = DocCode
	Set obj.ActUserDesc    = DocDesc
	
	Set return=obj
	Quit return
}

}
