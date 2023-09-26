/// 名称: DHCMed.CCService.Lib.Common
/// 描述: 公用函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.Common Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.CCService.Lib.Common).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(DHCMed.CCService.Lib.Common).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

/// w ##class(DHCMed.CCService.Lib.Common).GetAdmDays(4939742)
ClassMethod GetAdmDays(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=0
	Quit:argEpisodeID="" return
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(argEpisodeID)
    If $IsObject(objPaadm)
    {
		//Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
   	 	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argEpisodeID)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DischDate=objPaadm.PAADMDischgDate
	    //Set DischTime=objPaadm.PAADMDischgTime   
    	//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argEpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
	    If DischTime'="" {
		    Set return=DischDate-AdmitDate
	    } Else {
			Set return=+$h-AdmitDate
		}
    }
	
	Quit return
}

/// 日期比较
/// 参数:
/// Date1:第一个日期,格式:YYYY-MM-DD，或者DD/MM/YYYY，或者Cache内部格式
/// Date2:第二个日期,格式:YYYY-MM-DD，或者DD/MM/YYYY，或者Cache内部格式
/// 返回值：两个日期相差的天数（Date1-Date2）
ClassMethod Compare(Date1, Date2)
{
		n (Date1,Date2)
		s ret=0
		s:Date1["-" Date1=$zdh(Date1,3)
		s:Date1["/" Date1=$zdh(Date1,4)
		s:Date2["-" Date2=$zdh(Date2,3)
		s:Date2["/" Date2=$zdh(Date2,4)		
		s Date1=+Date1
		s Date2=+Date2
		q Date1-Date2
}

/// 获取日期的年份
/// 参数：日期
/// 返回值：日期的年份部分
ClassMethod GetYear(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",1)
}

/// 获取日期的月份
/// 参数：日期
/// 返回值：日期的月份部分
ClassMethod GetMonth(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",2)
}

/// 获取日期的天数部分
/// 参数：日期
/// 返回值：日期的天数部分
ClassMethod GetDay(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",3)
}

/// 与$ListFromString等价
/// w ##Class(DHCMed.CCService.Lib.Common).GetListFromString(Value,Char)
ClassMethod GetListFromString(Value As %String, Char As %String) As %List
{
	New (Value,Char)
	Set ret=""
	Set $ZT="GetListFromStringErr"
	Set:$g(Char)="" Char=","
	Set tmpVal="",tmpRet=""
	For Ind=1:1:$l(Value,Char)
	{
		Set tmpVal=$p(Value,Char,Ind)
		Set tmpRet=tmpRet_$listbuild(tmpVal)
	}
	Set ret=tmpRet
	Quit ret
GetListFromStringErr
   Quit ""
}

/// 与$ListToString等价
/// w ##Class(DHCMed.CCService.Lib.Common).GetListToString(Value,Char)
ClassMethod GetListToString(Value As %String, Char As %String) As %String
{
	New (Value,Char)
	Set ret=""
	Set $ZT="GetListToStringErr"
	Set:$g(Char)="" Char=","
	Set tmpVal="",tmpRet=""
	For Ind=1:1:$listlength(Value)
	{
		Set tmpVal=$listget(Value,Ind)
		Set tmpRet=tmpRet_Char_tmpVal
	}
	Set ret=$e(tmpRet,$l(Char)+1,$l(tmpRet))
	Quit ret
GetListToStringErr
   Quit ""
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMed.CCService.Lib.Common).CheckICDArea("D57 ","C00-D48,D98-E78,D57")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// 创建者：李阳
/// 创建日期：2013-03-08
/// 获取监控主题不同的显示子类设置
/// 参数：
/// 	SubjectCode:主题代码
/// ConfigCode:设置代码
/// 返回值：
///     %ListOfObjects---其中包含了设置中包含的【DHCMed.CC.ItemSubCat】对象
ClassMethod GetSubjectDisplayConfig(SubjectCode As %String, ConfigCode As %String) As %ListOfObjects
{
	n (SubjectCode, ConfigCode)
	Set objArry=##class(%ListOfObjects).%New()
	Do objArry.%Close()
	Set SubjectCode=" "_$ZConvert(SubjectCode,"U")
	Set ConfigCode=" "_$ZConvert(ConfigCode,"U")
	Set ConfigID=$o(^DHCMed.CC.SubjectConfigI("CodeIndex",SubjectCode,ConfigCode,""))
	Quit:ConfigID="" objArry
	Set ConfigSubID=""
	For {
		Set ConfigSubID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfig",ConfigID,ConfigSubID))
		Quit:ConfigSubID=""
		Set objSub=##class(DHCMed.CC.MapSubjectSubCat).GetObjById(ConfigSubID)
		Continue:'$IsObject(objSub)
		Continue:'$IsObject(objSub.MPItemSubCatDr)
		Do objArry.Insert(objSub.MPItemSubCatDr)
	}
	Quit objArry
}

ClassMethod PrepareSubjectItem(SubjectCode As %String, ConfigCode As %String)
{
	New (SubjectCode,ConfigCode,%ZIndex,%JIndex,%NIndex)
	Set return=0,Count=0
	Quit:(SubjectCode="")||(ConfigCode="") return
	Quit:(%ZIndex="")||(%JIndex="")||(%NIndex="") return
	
	If (SubjectCode'=+SubjectCode) {
		Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	} Else {
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectCode)
	}
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	Set SubjectCode=objSubject.Code
	
	Set objArry=..GetSubjectDisplayConfig(SubjectCode,ConfigCode)
	For ind=1:1:objArry.Count() {
		Set objSubCat=objArry.GetAt(ind)
		Continue:'$IsObject(objSubCat)
		
		Set SubCatID=objSubCat.%Id()
		Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(objSubCat.ISCCatDr)
		Continue:'$IsObject(objCat)
		
		Set ItemDicID=""
		For {
			Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			
			Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,""))
			Continue:SubjectItemID=""
			
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID)=SubCatID
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID,"Icon")=objCat.ICCode_"-"_objSubCat.ISCCode
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID)=objCat.ICCode_"-"_objSubCat.ISCCode
		}
		Set Count=Count+1
	}
	
	Set return=Count
	Quit return
}

/// 将子类下面的SubjectItemID写到临时Global中
ClassMethod PrepareSubjectItemBySubCatList(SubjectID As %String, SubCateIDList As %String) As %String
{
	New (SubjectID,SubCateIDList,%ZIndex,%JIndex,%NIndex)
	Set return=0,Count=0
	Quit:(SubjectID="")||(SubCateIDList="") return
	Quit:(%ZIndex="")||(%JIndex="")||(%NIndex="") return
	
	For ind=1:1:$l(SubCateIDList,"/") {
		Set SubCatID=$p(SubCateIDList,"/",ind)
		Continue:SubCatID=""
		
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
		Continue:'$IsObject(objSubCat)
		Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(objSubCat.ISCCatDr)
		Continue:'$IsObject(objCat)
		
		Set ItemDicID=""
		For {
			Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			Set SubjectItemID=""
			For {
				Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,SubjectItemID))
				Quit:SubjectItemID=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID)=SubCatID
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID,"Icon")=objCat.ICCode_"-"_objSubCat.ISCCode
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID)=objCat.ICCode_"-"_objSubCat.ISCCode
			}
		}
		Set Count=Count+1
	}
	
	Set return=Count
	Quit return
}

}
