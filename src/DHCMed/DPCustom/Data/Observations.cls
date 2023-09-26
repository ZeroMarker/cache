/// 名称: DHCMed.DPCustom.Data.Observations
/// 描述: 与体温单相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-02-14
Class DHCMed.DPCustom.Data.Observations Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 项目代码
Property ItemCode As %String(TRUNCATE = 1);

/// 项目名称
Property ItemDesc As %String(TRUNCATE = 1);

/// 项目说明
Property Comments As %String(TRUNCATE = 1);

/// 项目结果
Property DataValue As %String(TRUNCATE = 1);

/// 记录日期
Property UpdateDate As %String(TRUNCATE = 1);

/// 记录时间
Property UpdateTime As %String(TRUNCATE = 1);

/// 记录人代码
Property UpdateUser As %String(TRUNCATE = 1);

/// 记录人名称
Property UpdateUserDesc As %String(TRUNCATE = 1);

/// 记录日期
Property ActDate As %String(TRUNCATE = 1);

/// 记录时间
Property ActTime As %String(TRUNCATE = 1);

/// 记录人代码
Property ActUser As %String(TRUNCATE = 1);

/// 记录人名称
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.Observations).GetDataByAdm("309530","","","OBS-SF")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aActWords As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aActWords)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-Observations","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS体温信息
		Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(aEpisodeID)
		Quit:MRAdm="" return
		
		Set SubID=0
	    For {
			Set SubID=$o(^MR(MRAdm,"OBS",SubID))
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
			
			If aActWords'="" {
				//常用短语筛查（包含）
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check1(aActWords,obj.ItemDesc)
				Continue:checkFlag=""
			}
			
	    	//Do $system.OBJ.Dump(obj)
			Do return.Insert(obj)
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.Observations).GetDataByID("309655||468")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.Observations
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-Observations","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS体温信息
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.Observations
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set MRAdm=$p(aId,"||",1)
	Set SubID=$p(aId,"||",2)
	
	Set ItemDR=$p($g(^MR(MRAdm,"OBS",SubID)),"^",1)
	Quit:'$d(^MRC("OBITM",+ItemDR)) return
	Set ItemDesc=$p($g(^MRC("OBITM",+ItemDR)),"^",2)
	Set Value=$p($g(^MR(MRAdm,"OBS",SubID)),"^",2)
	
	Set OBSDate=$p($g(^MR(MRAdm,"OBS",SubID)),"^",3)
	Set OBSTime=$p($g(^MR(MRAdm,"OBS",SubID)),"^",4)
	Quit:(OBSDate="")||(OBSTime="") return
	Quit:OBSDate<1 return
	Set:OBSDate'="" OBSDate=$zd(OBSDate,3)
	Set:OBSTime'="" OBSTime=$zt(OBSTime,1)
	Set OBSUser=$p($g(^MR(MRAdm,"OBS",SubID)),"^",5)
	Set OBSUserDesc=""
	Set:OBSUser'="" OBSUserDesc=$p($g(^SSU("SSUSR",OBSUser)),"^",2)
	
	Set obj=##Class(DHCMed.DPCustom.Data.Observations).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = MRAdm_"||"_SubID
	Set obj.ItemCode       = ItemDR
	Set obj.ItemDesc       = ItemDesc
	Set obj.Comments       = ItemDesc
	Set obj.DataValue      = Value
	Set obj.UpdateDate     = OBSDate
	Set obj.UpdateTime     = OBSTime
	Set obj.UpdateUser     = OBSUser
	Set obj.UpdateUserDesc = OBSUserDesc
	Set obj.ActDate        = OBSDate
	Set obj.ActTime        = OBSTime
	Set obj.ActUser        = OBSUser
	Set obj.ActUserDesc    = OBSUserDesc
	
	Set return=obj
	Quit return
}

}
