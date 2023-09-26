/// 名称:EMRservice.Tools.Tool
/// 描述:工具类
/// 编写者：Guozongtao
/// 编写日期: 2014-1-4
Class EMRservice.Tools.Tool Extends %RegisteredObject
{

/// d ##Class(EMRservice.Tools.Tool).InitPageSetting()
ClassMethod InitPageSetting()
{

	s obj=##Class(EMRmeta.TemplateStructure).%OpenId(51)
		
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename="1.txt"
	
	
	While 'stream.AtEnd {
		d obj.MetaTemplate.Write(stream.Read(1024))
	}		
	d obj.%Save()
	d stream.%Close()
}

/// Desc:将字符串返回list
/// Creator:Candy
/// Input:AValue 串 AChar 分割符
/// ouput: list串
/// debug: w 
ClassMethod GetListFromString(AValue As %String, AChar As %String, AFlag As %String = "Y") As %List
{
	s ret = ""
	s $zt="GetListFromStringErr"
	s:$g(AChar)="" AChar=","
	s tmpVal="",tmpRet=""
	for Ind=1:1:$length(AValue,AChar)
	{
		s tmpVal = $p(AValue,AChar,Ind)
		continue:($zcvt(AFlag,"U") = "Y")&&(tmpVal = "")
		s tmpRet = tmpRet_$lb(tmpVal)
	}
	s ret = tmpRet
	q ret
GetListFromStringErr
   	q ""
}

/// d ##Class(EMRservice.Tools.Tool).InitTemplateVersion()
ClassMethod InitTemplateVersion()
{
	s filenameMetaData = "c:\MetaData.xml"
	s isExisted = ##class(%File).Exists(filenameMetaData) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	}
 	
	s filenamePresentation = "c:\Presentation.xml"
	s isExisted = ##class(%File).Exists(filenamePresentation) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	}
 	
	s filenamescripts = "c:\scripts.xml"
	s isExisted = ##class(%File).Exists(filenamescripts) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	} 	
 	s StreamMetaData =##class(%FileCharacterStream).%New()
	s StreamMetaData.Filename = filenameMetaData
	d StreamMetaData.TranslateTableSet("UTF8")


 	s StreamPresentation =##class(%FileCharacterStream).%New()
	s StreamPresentation.Filename = filenamePresentation
	d StreamPresentation.TranslateTableSet("UTF8")
 	
 	s Streamscripts =##class(%FileCharacterStream).%New()
	s Streamscripts.Filename = filenamescripts
	d Streamscripts.TranslateTableSet("UTF8")


	s obj=##Class(EMRmeta.TemplateVersion).%OpenId(2)
	d obj.MetaData.Clear()
	d obj.PresentationData.Clear()
	d obj.ScriptData.Clear()
	
	While 'StreamMetaData.AtEnd {
		d obj.MetaData.Write(StreamMetaData.Read(1024))
	}
		
	While 'StreamPresentation.AtEnd {
		d obj.PresentationData.Write(StreamPresentation.Read(1024))
	}
	While 'Streamscripts.AtEnd {
		d obj.ScriptData.Write(Streamscripts.Read(1024))
	}
	
	
	//s obj.PublicationDate=+$h
	//s obj.PublicationTime=$p($h,",",2)
	//s obj.Status="2"
	
	d obj.%Save()
	d obj.%Close()
	s obj=""
	
	q
}

/// d ##Class(EMRservice.Tools.Tool).InitKBNode()
ClassMethod InitKBNode()
{
	s filenameMetaData = "C:\KBNode_M.xml"
	s isExisted = ##class(%File).Exists(filenameMetaData) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	}
 	
	s filenamePresentation = "C:\KBNode_P.xml"
	s isExisted = ##class(%File).Exists(filenamePresentation) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	}
 	
	s filenamescripts = "C:\KBNode_S.xml"
	s isExisted = ##class(%File).Exists(filenamescripts) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	} 	
 	s StreamMetaData =##class(%FileCharacterStream).%New()
	s StreamMetaData.Filename = filenameMetaData
	d StreamMetaData.TranslateTableSet("UTF8")


 	s StreamPresentation =##class(%FileCharacterStream).%New()
	s StreamPresentation.Filename = filenamePresentation
	d StreamPresentation.TranslateTableSet("UTF8")
 	
 	s Streamscripts =##class(%FileCharacterStream).%New()
	s Streamscripts.Filename = filenamescripts
	d Streamscripts.TranslateTableSet("UTF8")


	s obj=##Class(EMRmeta.KBNode).%OpenId(2)
	d obj.MetaData.Clear()
	d obj.PresentationData.Clear()
	d obj.ScriptData.Clear()

	While 'StreamMetaData.AtEnd {
		d obj.MetaData.Write(StreamMetaData.Read(1024))
	}	
	While 'StreamPresentation.AtEnd {
		d obj.PresentationData.Write(StreamPresentation.Read(1024))
	}
	While 'Streamscripts.AtEnd {
		d obj.ScriptData.Write(Streamscripts.Read(1024))
	}
	
	//s obj.PublicationDate=+$h
	//s obj.PublicationTime=$p($h,",",2)
	//s obj.Status="2"
	
	d obj.%Save()
	d obj.%Close()
	s obj=""
	
	q
}

/// d ##Class(EMRservice.Tools.Tool).InitKBNodeData()
ClassMethod InitKBNodeData()
{
 	s Stream =##class(%FileCharacterStream).%New()
 	d Stream.TranslateTableSet("UTF8")
	s Stream.Filename = "c:\模板-知识库模板EMR3-v0.1.xml"
	d ##Class(EMRservice.BL.BLKBNode).SaveComposite(Stream,"4")
}

/// d ##Class(EMRservice.Tools.Tool).InitTemplate()
ClassMethod InitTemplate()
{
 	s Stream =##class(%FileCharacterStream).%New()
 	d Stream.TranslateTableSet("UTF8")
	s Stream.Filename = "c:\模板-入院记录模板EMR3-v0.1.xml"
	d ##Class(EMRservice.BL.BLTemplateVersion).SaveTemplate(Stream,2)
}

/// Creator: Candy
/// CreatDate: 2014-5-19
/// Desc: 处理cache中特殊字符
/// Input : str 处理字串
/// Output ：处理后字串
/// Others ：
/// w ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(^tempS1)
ClassMethod ReplaceCacheSpecialWord(str As %String) As %String
{
	s str = ..ReplaceWord(str,"""","'")
	s str = ..ReplaceWord(str,"\","/")
	q str
}

/// Creator: Candy
/// CreatDate: 2014-5-19
/// Desc: 替换字符     
/// Input : str 处理字串,oldStr 要替换的字符, newStr 替换成的字符
/// Output ：处理后字串
/// Others ：
/// w ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(^tempS1)
ClassMethod ReplaceWord(str As %String, oldStr As %String, newStr As %String) As %String
{
	s count = $Length(str, oldStr)
	if count > 1
	{
		s tmpRetVal = ""
		for I = 1:1:count
		{
			s tmpRetVal = tmpRetVal_$p(str,oldStr,I)_newStr
		}
		s str = $extract(tmpRetVal,1,$Length(tmpRetVal)-$l(newStr))
	}
	q str
}

/// Desc: 		通过格式化定义，得到标准日期时间
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      ADateTime 日期 时间
///            	AFormat 日期时间格式
/// Output:     result  标准日期时间 YYYY-MM-DD HH:mm:ss
/// Debug: 		w ##Class(EMRservice.Tools.Tool).DateTimeFormat("2014-09-05 16:53","yyyy-MM-dd HH:mm")
ClassMethod DateTimeFormat(ADateTime As %String, AFormat As %String) As %String
{
	s result = ""
	q:((ADateTime = "")||(AFormat = "")) result
	s format = $zcvt(AFormat,"U")
	s formatDate = $p(format," ",1),formatTime = $p(format," ",2)
	s date = $p(ADateTime," ",1),time = $p(ADateTime," ",2) 
	s number = "0123456789"
	s nowDate = $zd($p($h,",",1),3)
	s nowTime = $zt($p($h,",",2))
	s year = $p(nowDate,"-",1)
	s p = $f(formatDate,"YYYY")
	if (p > 0)
	{
		s year = $e(date,p-4,p-1)
	}
	else
	{
		s p = $f(formatDate,"YY")
		s:(p >0) year = $e(date,p-2,p-1)
	}
	q:(year = "") result
	s formatDate = $e(formatDate,p,$l(formatDate))
	s date = $e(date,p,$l(date))
	
	s month =  $p(nowDate,"-",2)
	s p = $f(formatDate,"MM")
	if (p > 0)
	{
		s month = $e(date,p-2,p-1)
		s formatDate = $e(formatDate,p,$l(formatDate))
		s date = $e(date,p,$l(date))	
	}
	else
	{
		s p = $f(formatDate,"M")
		q:(p<0) result 

		if (number [ $e(date,p,p)) 
		{
			s month = $e(date,p-1,p)
			s formatDate = $e(formatDate,p,$l(formatDate))
			s date = $e(date,p+1,$l(date))			
		}
		else
		{
			s month = $e(date,p-1,p-1)
			s formatDate = $e(formatDate,p,$l(formatDate))
			s date = $e(date,p,$l(date))	
		}
	}
	
	s day =  $p(nowDate,"-",3)
	s p = $f(formatDate,"DD")
	if (p > 0)
	{
		s day = $e(date,p-2,p-1)
		s formatDate = $e(formatDate,p,$l(formatDate))
		s date = $e(date,p,$l(date))	
	}
	else
	{
		s p = $f(formatDate,"D")
		q:(p<0) result 

		if (number [ $e(date,p,p)) 
		{
			s day = $e(date,p-1,p)
			s formatDate = $e(formatDate,p,$l(formatDate))
			s date = $e(date,p+1,$l(date))			
		}
		else
		{
			s day = $e(date,p-1,p-1)
			s formatDate = $e(formatDate,p,$l(formatDate))
			s date = $e(date,p,$l(date))	
		}
	}
	s result = year_"-"_month_"-"_day 
	
	q:(formatTime = "") result 
	s hour = $p(nowTime,":",1)
	s p = $f(formatTime,"HH")
	if (p > 0)
	{
		s hour = $e(time,p-2,p-1)
		s formatTime = $e(formatTime,p,$l(formatTime))
		s time = $e(time,p,$l(time))	
	}
	else
	{
		s p = $f(formatTime,"H")
		if (p > 0) 
		{
			if (number [ $e(time,p,p)) 
			{
				s hour = $e(time,p-1,p)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p+1,$l(time))			
			}
			else
			{
				s hour = $e(time,p-1,p-1)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p,$l(time))	
			}
		}
	}
	
	s minute = $p(nowTime,":",2)
	s p = $f(formatTime,"MM")
	if (p > 0)
	{
		s minute = $e(time,p-2,p-1)
		s formatTime = $e(formatTime,p,$l(formatTime))
		s time = $e(time,p,$l(time))	
	}
	else
	{
		s p = $f(formatTime,"M")
		if (p > 0) 
		{
			if (number [ $e(time,p,p)) 
			{
				s minute = $e(time,p-1,p)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p+1,$l(time))			
			}
			else
			{
				s minute = $e(time,p-1,p-1)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p,$l(time))	
			}
		}
	}	
	s second = $p(nowTime,":",3)
	s p = $f(formatTime,"SS")
	if (p > 0)
	{
		s second = $e(time,p-2,p-1)
		s formatTime = $e(formatTime,p,$l(formatTime))
		s time = $e(time,p,$l(time))	
	}
	else
	{
		s p = $f(formatTime,"S")
		if (p > 0) 
		{
			if (number [ $e(time,p,p)) 
			{
				s second = $e(time,p-1,p)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p+1,$l(time))			
			}
			else
			{
				s second = $e(time,p-1,p-1)
				s formatTime = $e(formatTime,p,$l(formatTime))
				s time = $e(time,p,$l(time))	
			}
		}
	}	
	s result = result_" "_hour_":"_minute_":"_second
	q result
}

/// Desc：解码非ASCII字符
/// CareateDate 2014-9-17
/// Input：InStr: 需要解码的字串
/// OutPut：成功－解码后的字串，失败－"Error"
/// Debug: w ##Class(CSM.DataInterface).UnEscape("insert into CSM.Project (Name,Description,Code,ChargeHospital,ChargeDept,Charger,PrjLevel,StartDate,EndDate,Status) values('%u533B%u9662%u4E34%u5E8A','%u6492%u6253%u7B97%u7684','1001','%u5237%u5237%u5237','%u5446%u5446%u5730','%u5237%u5237%u5237','%u9662%u7EA7','9/7/2010 12:00:00 AM','9/30/2010 12:00:00 AM',NULL)")
ClassMethod UnEscape(InStr As %String) As %String
{
	s $zt="errhandler"
	q:(InStr="") ""
	s num=1,tmpNum=1,retStr=""	
	for num=1:1:$l(InStr,"%") 
	{
		s char=$p(InStr,"%",num)
		if (num=1)
		{
			s retStr=$e(char,1,$l(char))
		}
		else
		{
			if ($zcvt($e(char,1,1),"U")'="U")
			{
				s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
			}
			else
			{
				s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
			}
		}
	}
	s retStr=$tr(retStr,"`","%")
	q retStr
errhandler
	q "Error"
}

ClassMethod InitUserLevePost()
{
	d ##Class(EMRservice.BL.BLUserPost).IniData()
	d ##Class(EMRservice.BL.BLUserLevel).IniData()
}

/// w ##Class(EMRservice.Ajax.ActionLog).getLoginIP("876")
/// 获取登录时候记录的IP地址
ClassMethod getLoginIP(LOGUserDR As %String) As %String
{
	q:(LOGUserDR="") ""
	//^SST("LOG",0,"User",{LOG_User_DR},{LOG_LogonDate},{LOG_LogonTime},{LOG_RowId})
	
	s LOGLogonDate = $O(^SST("LOG",0,"User",LOGUserDR,""),-1)
	q:(LOGLogonDate="") ""
	
	s LOGLogonTime = $O(^SST("LOG",0,"User",LOGUserDR,LOGLogonDate,""),-1)
	q:(LOGLogonTime="") ""
	
	s LOGRowId = $O(^SST("LOG",0,"User",LOGUserDR,LOGLogonDate,LOGLogonTime,""),-1)
	q:(LOGRowId="") ""
	
	s id = $O(^User.DHCClientLoginI("UserLoginIndex"," "_LOGRowId,""))
	q:(id="") ""
	
	s obj = ##Class(User.DHCClientLogin).%OpenId(id)
	q obj.DHCCLComputerIp
}

/// Desc:      初始化医生级别数据方法，按照文档要求整理好基础数据，做好的txt文件通过此方法导入到数据库中。
/// Creator:   lfb
/// Createdate:20150901
/// d ##Class(EMRservice.Tools.Tool).InitEMRmetaPowerUser("c:\EMRmetaPowerUser.txt")
ClassMethod InitEMRmetaPowerUser(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EMRmeta.PowerUser).%New()
		s obj.SSGroupID=$p(sRec, $c(9), 2)
 		s obj.UserID=$p(sRec, $c(9), 1)
		s obj.UserLevel = $p(sRec, $c(9), 3)
 		s obj.UserPos = $c(0)

		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""
		
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount:"_okCount_" failCount:"_failCount
	quit
}

/// Desc:     
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.Tool).CopyDataByOtherD()
ClassMethod CopyDataByOtherD()
{
	
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.MainRoleKBTreeD(rowID))
		q:(rowID="")
		S ^DHCEMRM.MainRoleKBTreeD(rowID) = ^EMRmeta.MainRoleKBTreeD(rowID)
	}
	w "Summary: "_rowID
	quit
}

/// d ##Class(EMRservice.Tools.Tool).CopyDataByEMRmeta()
ClassMethod CopyDataByEMRmeta()
{
	s count=0
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.DiseaseRelationD(rowID))
		q:(rowID="")
		s ^DHCEMRM.DiseaseRelationD(rowID) = ^EMRmeta.DiseaseRelationD(rowID)
		s count=count+1
	}
	w "Summary: "_count,!
	
	s count=0
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.DiseaseRelationI("IdxCTLocID",rowID))
		q:(rowID="")
		s subrowID=0
	    for {
		       s subrowID = $o(^EMRmeta.DiseaseRelationI("IdxCTLocID",rowID,subrowID))
		       q:(subrowID="")
		       s ^DHCEMRM.DiseaseRelationI("IdxCTLocID",rowID,subrowID) = ^EMRmeta.DiseaseRelationI("IdxCTLocID",rowID,subrowID)
		       s count=count+1
	        }
		
	    }
	w "Summary: "_count,!
	
	s count=0
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.DiseaseRelationI("IdxKBDiagnosID",rowID))
		q:(rowID="")
		s subrowID=0
	    for {
		       s subrowID = $o(^EMRmeta.DiseaseRelationI("IdxKBDiagnosID",rowID,subrowID))
		       q:(subrowID="")
		       s ^DHCEMRM.DiseaseRelationI("IdxKBDiagnosID",rowID,subrowID) = ^EMRmeta.DiseaseRelationI("IdxKBDiagnosID",rowID,subrowID)
		       s count=count+1
	        }
		
	    }
	w "Summary: "_count,!
	
	s count=0
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationCode",rowID))
		q:(rowID="")
		s subrowID=0
	    for {
		       s subrowID = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationCode",rowID,subrowID))
		       q:(subrowID="")
		       s code=""
		       for {
		              s code = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationCode",rowID,subrowID,code))
		              q:(code="")
		              s ^DHCEMRM.DiseaseRelationI("IdxDiagnosRelationCode",rowID,subrowID,code) ="" //^EMRmeta.DiseaseRelationI("IdxDiagnosRelationCode",rowID,subrowID,code)
		              s count=count+1
	              }		      
	        }
		
	    }
	w "Summary: "_count,!
	
	s count=0
	s rowID=0
	for {
		s rowID = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationID",rowID))
		q:(rowID="")
		s subrowID=0
	    for {
		       s subrowID = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationID",rowID,subrowID))
		       q:(subrowID="")
		       s code=0
		       for {
		             s code = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationID",rowID,subrowID,code))
		             q:(code="")
		             s subcode=0
		             for {
		                 s subcode = $o(^EMRmeta.DiseaseRelationI("IdxDiagnosRelationID",rowID,subrowID,code,subcode))
		                 q:(subcode="")
		                 s ^DHCEMRM.DiseaseRelationI("IdxDiagnosRelationID",rowID,subrowID,code,subcode) = ^EMRmeta.DiseaseRelationI("IdxDiagnosRelationID",rowID,subrowID,code,subcode)
		                 s count=count+1
	                    }
	               }
	        }
		
	    }
	w "Summary: "_count,!
	
	quit
}

/// d ##Class(EMRservice.Tools.Tool).InitTitleCategory()
ClassMethod InitTitleCategory()
{
	s Params=""
	&sql(update CHSS.EMRmeta.TitleCategory set PropertyParams=:Params)
	w "PropertyParams:Clear",!
	&sql(update CHSS.EMRmeta.TitleCategory set TitleCategoryType=:Params)
	w "TitleCategoryType:Clear",!
	d ##class(EMRmeta.TitleCategory).%BuildIndices()
	w "BuildIndices",!
}

/// Desc: 迁移方案，方案项，方案项的科室和安全组。
/// create :yejian
/// input : ^门诊方案ID^门诊方案ID2^急诊方案ID^急诊方案ID2^
/// d ##Class(EMRservice.Tools.Tool).OrganzationMoveToNavigation("^6^7^")
ClassMethod OrganzationMoveToNavigation(AOutpIDs As %String)
{
	k ^DHCEMRM.EMRNavSchemeI
	k ^DHCEMRM.EMRNavSchemeD
	k ^DHCEMRM.EMRNavSchemeItemI
	k ^DHCEMRM.EMRNavSchemeItemD
	k ^DHCEMRM.EMRNavItemLocI
	k ^DHCEMRM.EMRNavItemLocD
	k ^DHCEMRM.EMRNavItemSSGroupI
	k ^DHCEMRM.EMRNavItemSSGroupD
	s count=0
	s Itemcount=0
	s locCount=0
	s groupCount=0
	s objNavScheme = ""
	s objItem =""
	s rowSChemeID=0
	s subTypeId = ""
	for {
		s rowSChemeID = $o(^DHCEMRM.EMROrgSchemeD(rowSChemeID))
		q:(rowSChemeID="")
		s objScheme = ##Class(EMRmeta.EMROrganizationScheme).%OpenId(rowSChemeID)
		q:(objScheme ="")
		Set key = ""			
		do
		{ 			   
			S objSchemeType = objScheme.SchemType.GetNext(.key)
			q:(objSchemeType="")
			s strSchemeType = objSchemeType.SchemType
			s strRowSID = "^"_rowSChemeID_"^"
			// 如果入参有值，过滤出门诊类型，如果入参为空，通过门诊和急诊来过滤类型
			if (AOutpIDs = "")
			{
				if ((objScheme.SchemeName [ "门诊") ||(objScheme.SchemeName [ "急诊"))
				{
					s strSchemeType = "Outpatient"
				}
			}
			elseif (AOutpIDs [ strRowSID)
			{
				s strSchemeType = "Outpatient"
			}
			// 迁移方案
			s objNavScheme= ..MoveNavScheme(objScheme,strSchemeType)
			continue:(objNavScheme="")
			s itemKey = ""
			do
			{ 			   
				S objDetail = objSchemeType.Details.GetNext(.itemKey)
				q:(objDetail="")
				s strSchemeCode = objNavScheme.SchemeCode
				s strItemCode = objDetail.ItemCode
				// 迁移方案项目
				s objItem = ..MoveNavItem(objDetail,strSchemeCode,strItemCode)
				continue:(objItem="")
				s Itemcount = Itemcount+1
				d ##Class(EMRmeta.EMROrganizationSchemeLoc).%BuildIndices()
				d ##Class(EMRmeta.CTOrganizationSchemeItem).%BuildIndices()
				// 迁移方案项目的科室
				d ..MoveNavItemLoc(rowSChemeID,strSchemeCode,strItemCode,objDetail.ItemName,.locCount)
				// 迁移方案项目的安全组
				d ..MoveSSGroup(strSchemeCode,strItemCode,objDetail.ItemName,.groupCount)
			} 
			while (itemKey '="" )	
				
		} 
		while (key '="" )	
		s count=count+1
	}
	w "迁移方案总数:"_count_",迁移方案项目总数:"_Itemcount_",迁移方案项科室总数:"_locCount_",迁移方案项安全组总数:"_groupCount,!
}

// 迁移方案

ClassMethod MoveNavScheme(objScheme As EMRmeta.EMROrganizationScheme, strSchemeType As %String) As EMRmeta.EMRNavigationScheme
{
	s objNavScheme = ""
	s navRowId = $o(^DHCEMRM.EMRNavSchemeI("IdxSchemeCode"," "_strSchemeType,""))
	if (navRowId = "")
	{ 
		s objNavScheme=##class(EMRmeta.EMRNavigationScheme).%New()
		s objNavScheme.SchemeCode= strSchemeType
		s objNavScheme.SchemeName=objScheme.SchemeName
		s objNavScheme.CreateUserID=objScheme.CreateUserID
		s objNavScheme.CreateDate= objScheme.CreateDate
		s objNavScheme.CreateTime=objScheme.CreateTime
		s objNavScheme.modifyUser = objScheme.CreateUserID
		s objNavScheme.ModifyDate=objScheme.ModifyDate
		s objNavScheme.ModifyTime=objScheme.ModifyTime
		s objNavScheme.SchemSeq=objScheme.SchemSeq
		s sc = objNavScheme.%Save()
	}
	else 
	{
		s objNavScheme = ##Class(EMRmeta.EMRNavigationScheme).%OpenId(navRowId)
	}
	q objNavScheme
}

// 迁移方案项目

ClassMethod MoveNavItem(objDetail As EMRmeta.EMROrganizationSchemeDetails, strSchemeCode As %String, strItemCode As %String) As EMRmeta.EMRNavigationSchemeItem
{
	s objItem = ""
	s strItemCode = objDetail.ItemCode
	s ItemRowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxSchemeItemCode"," "_strSchemeCode," "_strItemCode,""))
	if (ItemRowId = "")
	{
		s objItem = ##Class(EMRmeta.EMRNavigationSchemeItem).%New()
		S objItem.SchemeCode =strSchemeCode
		s objItem.ItemCode = strItemCode
		s objItem.ItemDr = objDetail.ItemDr
		s objItem.ItemName = objDetail.ItemName
		s objItem.ItemSeq = objDetail.ItemSeq
		s sc = objItem.%Save()
	}
	else
	{
		s objItem = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(ItemRowId)
	}
	q objItem
}

// 迁移方案项目的科室

ClassMethod MoveNavItemLoc(rowSChemeID As %String, strSchemeCode As %String, strItemCode As %String, strItemName As %String, ByRef aLocCount As %Integer)
{
	S orgLocRowID = ""
	for {
		s orgLocRowID = $o(^DHCEMRM.EMROrgSchemeLocI("IdxSchemeID"," "_rowSChemeID,orgLocRowID))
		q:(orgLocRowID="")
		s objOrgLoc = ##Class(EMRmeta.EMROrganizationSchemeLoc).%OpenId(orgLocRowID)
		continue:(objOrgLoc ="")
		s strLocID = objOrgLoc.CTLocID
		s NavLocRowId = $o(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_strSchemeCode," "_strItemCode,strLocID,""))
		if (NavLocRowId = "")
		{
			s objItemLoc = ##Class(EMRmeta.EMRNavigationSchemeItemLoc).%New()
			S objItemLoc.SchemeCode =strSchemeCode
			s objItemLoc.ItemCode = strItemCode
			s objItemLoc.ItemName = strItemName
			s objItemLoc.CTLocID = strLocID
			s objItemLoc.CTLocDesc = objOrgLoc.CTLocDesc
			s sc = objItemLoc.%Save()
			s aLocCount = aLocCount+1
		}

	}
}

// 迁移方案项目的安全组

ClassMethod MoveSSGroup(strSchemeCode As %String, strItemCode As %String, strItemName As %String, ByRef aGroupcount As %Integer)
{
	s ctOrgItemRowID = $o(^DHCEMRM.CTOrgSchemeItemI("IdxItemCode"," "_strItemCode,""))
	q:(ctOrgItemRowID ="")
	s objCtOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(ctOrgItemRowID)
	s EmrDocID = objCtOrgItem.EMRTemplateCategoryID
	
	S SSGroupID = ""
	for {
		s SSGroupID = $o(^DHCEMRM.EMRDOC.EMRSSGroupI("IdxCatalogSSGroup"," "_EmrDocID,SSGroupID))
		q:(SSGroupID="")
		;s objSSGroup = ##Class(User.SSGroup).%OpenId(SSGroupID)
		;s SSGRPDesc = ""
		
		s NavSSGroupRowId = $o(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_strSchemeCode," "_strItemCode,SSGroupID,""))
		if (NavSSGroupRowId = "")
		{
			s objItemGroup = ##Class(EMRmeta.EMRNavigationSchemeItemSSGroup).%New()
			S objItemGroup.SchemeCode =strSchemeCode
			s objItemGroup.ItemCode = strItemCode
			s objItemGroup.ItemName = strItemName
			s objItemGroup.SSGroupID = $tr(SSGroupID," ","")
			;s objItemGroup.SSGroupName = SSGRPDesc
			s sc = objItemGroup.%Save()
			s aGroupcount = aGroupcount+1
		}
	}
}

/// Desc: 迁移病种，病种，方案项的科室和安全组。
/// create :yejian
/// input : 
/// d ##Class(EMRservice.Tools.Tool).DiagnosDatasMoveTo()
ClassMethod DiagnosDatasMoveTo()
{
	k ^DHCEMRM.DiagnosGroupI
	k ^DHCEMRM.DiagnosGroupD
	k ^DHCEMRM.DiagnosGroupDetailI
	k ^DHCEMRM.DiagnosGroupDetailD
	k ^DHCEMRM.DiagnosI
	k ^DHCEMRM.DiagnosD
	k ^DHCEMRM.DiagnosCTLocI
	k ^DHCEMRM.DiagnosCTLocD
	k ^DHCEMRM.DiagnosDiseaseI
	k ^DHCEMRM.DiagnosDiseaseD
	k ^DHCEMRM.DiagnosKBNodeI
	k ^DHCEMRM.DiagnosKBNodeD
	k ^DHCEMRM.DiagnosKBNodeRuleI
	k ^DHCEMRM.DiagnosKBNodeRuleD
	s adiaCount=0
	s agroupCount = 0
	s agroupDetailCount = 0
	s KBDiagnosCount=0
	s locCount=0
	s aDiseaseCount=0
	s aKBCount = 0
	s aKBRuleCount = 0
	s objDiagnos = ""
	s objDiagnosKBNode = ""
	s rowKBDiagnosID = ""
	s intRepeatCont = 0

	for {
		s rowKBDiagnosID = $o(^DHCEMRM.KBDiagnosD(rowKBDiagnosID))
		q:(rowKBDiagnosID="")
		s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowKBDiagnosID)
		q:(objKBDiagnos ="")
		s strDiagnosCode = objKBDiagnos.Name
		s strGroupCode = objKBDiagnos.GroupName
		
		if ((strGroupCode="")||(strGroupCode=$C(0)))
		{
			s strGroupCode = "GourpNull"
		}
		//迁移病种分组
		s objDiagnosGroup =..MoveDiagnosGroup(objKBDiagnos,strGroupCode,.agroupCount)
		
		//迁移病种
		s objDiagnos = ..MoveDiagnos(objKBDiagnos,strDiagnosCode,.adiaCount,.intRepeatCont)
		
		//迁移病种分组关联
		d ..MoveDiagnosGroupDetail(objDiagnos,objDiagnosGroup,.agroupDetailCount)
		
		s strLocID = objKBDiagnos.CTLocID
		//迁移病种科室
		d ..MoveDiagnosCTLoc(objKBDiagnos,objDiagnos,strLocID,.locCount)
		
		//迁移病种诊断
		d ..MoveDiagnosDisease(objDiagnos,rowKBDiagnosID,.aDiseaseCount)
		
		
		//迁移病种知识库
		s rowKBNodeDiagnosID = ""
		for {
			s rowKBNodeDiagnosID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBDiagnosID",rowKBDiagnosID,rowKBNodeDiagnosID))
			q:(rowKBNodeDiagnosID="")
			//迁移病种知识库节点
			s objDiagnosKBNode = ..MoveKBDiagnos(objDiagnos,rowKBNodeDiagnosID,.aKBCount)

			//迁移病种知识库规则
			d ..MoveKBRuleDiagnos(objDiagnosKBNode,objDiagnosKBNode,rowKBNodeDiagnosID,.aKBRuleCount)
		}
	}
	w "迁移病种总数:"_adiaCount_",迁移病种分组总数:"_agroupCount_",迁移病种分组关联总数:"_agroupDetailCount_",迁移病种科室总数:"_locCount_",迁移病种诊断总数:"_aDiseaseCount_",迁移病种知识库关联总数:"_aKBCount_",迁移病种知识库规则关联总数:"_aKBRuleCount,!
}

// 迁移病种

ClassMethod MoveDiagnosGroup(objKBDiagnos As EMRmeta.KBDiagnos, strGroupCode As %String, ByRef groupCount As %Integer) As EMRmeta.DiagnosGroup
{
	s rowGroupID = $o(^DHCEMRM.DiagnosGroupI("IdxCTLocGroupCode"," "_objKBDiagnos.CTLocID," "_$zcvt(strGroupCode,"U"),""))
	s objDiagnosGroup = ""
	if (rowGroupID="")
	{
		s objDiagnosGroup=##class(EMRmeta.DiagnosGroup).%New()
		s objDiagnosGroup.GroupCode= strGroupCode
		s strGroupDes = objKBDiagnos.GroupDescription
		if ((strGroupDes="")||(strGroupDes=$C(0)))
		{
			s strGroupDes = "未维护分组目录名称"
		}
		s objDiagnosGroup.GroupName=strGroupDes
		s objDiagnosGroup.CTLocID = objKBDiagnos.CTLocID
		s objDiagnosGroup.Sequence = groupCount+1
		s objDiagnosGroup.ParentID="0"
		s sc = objDiagnosGroup.%Save()
		
		s groupCount = groupCount +1 
	}
	else
	{
		s objDiagnosGroup = ##class(EMRmeta.DiagnosGroup).%OpenId(rowGroupID)
	}
	q objDiagnosGroup
}

// 迁移病种

ClassMethod MoveDiagnos(objKBDiagnos As EMRmeta.KBDiagnos, strDiagnosCode As %String, ByRef aDiaCount As %Integer, ByRef RepeatCont As %Integer) As EMRmeta.Diagnos
{
	s objDiagnos= ""
	
	s rowDiagnosID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(strDiagnosCode,"U"),""))
	if (rowDiagnosID="")
	{
		s objDiagnos=##class(EMRmeta.Diagnos).%New()
		s objDiagnos.DiagnosCode= objKBDiagnos.Name
		s objDiagnos.DiagnosName=objKBDiagnos.Description
		s objDiagnos.CreateDate=objKBDiagnos.CreateDate
		s objDiagnos.UserID = objKBDiagnos.UserID
		s objDiagnos.Status = objKBDiagnos.Status
		s objDiagnos.Sequence = objKBDiagnos.%Id()
		s sc = objDiagnos.%Save()		
		s aDiaCount = aDiaCount +1
	}
	else
	{
		
		s retRowID = ""
		s strDiagnosCode = ""
		do
		{	
			s RepeatCont =RepeatCont+1
			s strDiagnosCode = objKBDiagnos.Name_"_"_RepeatCont
			s retRowID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(strDiagnosCode,"U"),""))
		}
		while (retRowID'="")
		s objDiagnos=##class(EMRmeta.Diagnos).%New()
		s objDiagnos.DiagnosCode= strDiagnosCode
		s objDiagnos.DiagnosName=objKBDiagnos.Description
		s objDiagnos.CreateDate=objKBDiagnos.CreateDate
		s objDiagnos.UserID = objKBDiagnos.UserID
		s objDiagnos.Status = objKBDiagnos.Status
		s objDiagnos.Sequence = objKBDiagnos.%Id()
		s sc = objDiagnos.%Save()		
	}
	q objDiagnos
}

// 迁移病种分组关联

ClassMethod MoveDiagnosGroupDetail(objDiagnos As EMRmeta.Diagnos, objDiagnosGroup As EMRmeta.DiagnosGroup, ByRef groupDeiCount As %Integer)
{
	q:((objDiagnos="")||(objDiagnosGroup=""))
	s strGroupID = objDiagnosGroup.%Id()
	s strDiagnosCode = objDiagnos.DiagnosCode
	s rowGroupID = $o(^DHCEMRM.DiagnosGroupDetailI("IdxCode"," "_$zcvt(strGroupID,"U")," "_$zcvt(strDiagnosCode,"U"),""))
	if (rowGroupID="")
	{
		s objGroupDetail=##class(EMRmeta.DiagnosGroupDetail).%New()
		s objGroupDetail.GroupID= strGroupID
		s objGroupDetail.DiagnosCode = strDiagnosCode
		s objGroupDetail.Sequence = groupDeiCount+1
		s sc = objGroupDetail.%Save()
		s groupDeiCount = groupDeiCount +1 
	}
}

// 迁移病种科室

ClassMethod MoveDiagnosCTLoc(objKBDiagnos As EMRmeta.KBDiagnos, objDiagnos As EMRmeta.Diagnos, strLocID As %String, ByRef aLocCount As %Integer)
{
	s rowDiagnosCTLocID = $o(^DHCEMRM.DiagnosCTLocI("IdxCTLocIDAndDiagnosCode"," "_strLocID," "_$zcvt(objDiagnos.DiagnosCode,"U"),""))
	if (rowDiagnosCTLocID="")
	{
		s objDiagnosCTLoc=##class(EMRmeta.DiagnosCTLoc).%New()
		s objDiagnosCTLoc.DiagnosCode= objDiagnos.DiagnosCode
		s objDiagnosCTLoc.DiagnosName=objDiagnos.DiagnosName
		s objDiagnosCTLoc.CTLocID=objKBDiagnos.CTLocID
		s DeptDesc=$p($g(^CTLOC(objKBDiagnos.CTLocID)),"^",2)
		s objDiagnosCTLoc.CTLocName= DeptDesc
		s sc = objDiagnosCTLoc.%Save()
		s aLocCount = aLocCount+1
	}
}

// 迁移病种诊断

ClassMethod MoveDiagnosDisease(objDiagnos As EMRmeta.Diagnos, rowKBDiagnosID As %String, ByRef aDiseaseCount As %Integer)
{
	s rowDiseaseRelationID = ""
	for {
		s rowDiseaseRelationID = $o(^DHCEMRM.DiseaseRelationI("IdxKBDiagnosID",rowKBDiagnosID,rowDiseaseRelationID))
		q:(rowDiseaseRelationID="")
		
		s objDiseaseRelation = ##Class(EMRmeta.DiseaseRelation).%OpenId(rowDiseaseRelationID)
		S strICDID = objDiseaseRelation.ICDID
		s rowDiagnosDiseaseID = $o(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCodeAndICDID"," "_$zcvt(objDiagnos.DiagnosCode,"U")," "_strICDID,""))
		if (rowDiagnosDiseaseID="")
		{
			s objDiagnosDisease=##class(EMRmeta.DiagnosDisease).%New()
			s objDiagnosDisease.DiagnosCode= objDiagnos.DiagnosCode
			s objDiagnosDisease.DiagnosName=objDiagnos.DiagnosName
			s objDiagnosDisease.ICDID=objDiseaseRelation.ICDID
			s objDiagnosDisease.ICDCode=objDiseaseRelation.ICDCode
			s objDiagnosDisease.ICDName=objDiseaseRelation.ICDName
			s sc = objDiagnosDisease.%Save()
			s aDiseaseCount= aDiseaseCount+1		
		}
	}
}

// 迁移病种知识库

ClassMethod MoveKBDiagnos(objDiagnos As EMRmeta.Diagnos, rowKBNodeDiagnosID As %String, ByRef aKBCount As %Integer) As EMRmeta.DiagnosKBNode
{
	s objDiagnosKBNode= ""
	s objKBNodeDiagnos = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(rowKBNodeDiagnosID)
	S strKBNodeID = objKBNodeDiagnos.KBNodeID
	s rowDiagnosKBNodeID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeIDAndDiagnosCode"," "_strKBNodeID," "_$zcvt(objDiagnos.DiagnosCode,"U"),""))
	if (rowDiagnosKBNodeID="")
	{
		s objDiagnosKBNode=##class(EMRmeta.DiagnosKBNode).%New()
		s objDiagnosKBNode.DiagnosCode= objDiagnos.DiagnosCode
		s objDiagnosKBNode.KBNodeID=objKBNodeDiagnos.KBNodeID
		s objDiagnosKBNode.KBTreeID=objKBNodeDiagnos.KBTreeID
		s objDiagnosKBNode.ActiveFlag=objKBNodeDiagnos.ActiveFlag
		s sc = objDiagnosKBNode.%Save()	
		s aKBCount = aKBCount+1	
	}
	else
	{
		s objDiagnosKBNode=##class(EMRmeta.DiagnosKBNode).%OpenId(rowDiagnosKBNodeID)
	}
	q objDiagnosKBNode
}

// 迁移病种知识库

ClassMethod MoveKBRuleDiagnos(objKBDiagnosRule As EMRmeta.KBNodeDiagnosRule, objDiagnosKBNode As EMRmeta.DiagnosKBNode, rowKBNodeDiagnosID As %String, ByRef aKBRuleCount As %Integer)
{
	//迁移病种知识库规则
	s rowKBDiagnosRuleID = ""
	for {
		s rowKBDiagnosRuleID = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_rowKBNodeDiagnosID,rowKBDiagnosRuleID))
		q:(rowKBDiagnosRuleID="")
		s objKBDiagnosRule = ##Class(EMRmeta.KBNodeDiagnosRule).%OpenId(rowKBDiagnosRuleID)
		S strKBRuleID = objKBDiagnosRule.DiagnosRuleID
		S strKBRuleCode = objKBDiagnosRule.DiagnosRuleCode
		s rowDiagnosKBRuleID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxUnique"," "_rowKBDiagnosRuleID," "_strKBRuleID," "_$zcvt(strKBRuleCode,"U"),""))
		if (rowDiagnosKBRuleID="")
		{
			s objDiagnosKBRule=##class(EMRmeta.DiagnosKBNodeRule).%New()
			s objDiagnosKBRule.DiagnosKBNodeID= objDiagnosKBNode.%Id()
			s objDiagnosKBRule.DiagnosRuleID=objKBDiagnosRule.DiagnosRuleID
			s objDiagnosKBRule.DiagnosRuleCode=objKBDiagnosRule.DiagnosRuleCode
			s objDiagnosKBRule.DiagnosRuleDesc=objKBDiagnosRule.DiagnosRuleDesc
			s sc = objDiagnosKBRule.%Save()	
			s aKBRuleCount = aKBRuleCount+1	
		}
	}
}

/// 初始化EPRmeta.GlossaryTemplateItemGroup数据
/// d ##Class(EMRservice.Tools.Tool).InitTempItemGroup("/tmp/tempitemgroup.txt")
ClassMethod InitTempItemGroup(argFile As %String) As %String
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EPRmeta.GlossaryTemplateItemGroup).%New()
		s obj.GroupCode=$p(sRec,"|",1)
		s obj.Name=$p(sRec,"|",2)
		s obj.Sequence=$p(sRec,"|",3)
		s obj.TemplateID=$p(sRec,"|",4)
		s obj.TemplateName=$p(sRec,"|",5)
		s obj.Type=$p(sRec,"|",6)
		s obj.Value=$p(sRec,"|",7)
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

        s totCount = totCount + 1		
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// d ##Class(EMRservice.Tools.Tool).InitDiagnosCategory("d:\DiagnosCategory.txt")
ClassMethod InitDiagnosCategory(argFile As %String)
{
	k ^DHCEMRM.DiagnosCategoryI
	k ^DHCEMRM.DiagnosCategoryD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		if (Line["CategoryCode")
		{
			continue
		}
		s Line = $tr(Line,$char(13),"")
		s Line = $tr(Line,$char(10),"")
		s obj=##Class(EMRmeta.DiagnosCategory).%New()
		s obj.CategoryCode=$p(Line,",",2)
		s obj.CategoryName=$p(Line,",",3)
		s obj.ParentID=$p(Line,",",4)
		s obj.Sequence=$p(Line,",",5)
		
		s isOK = obj.%Save()
		if isOK '= "1"
		{	 s FailCount = FailCount + 1}
		
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w "Summary: "_FileCnt_" rows imported, fail count:"_FailCount,!
	quit
}

/// d ##Class(EMRservice.Tools.Tool).InitDiagnos("d:\Diagnos.txt")
ClassMethod InitDiagnos(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		if (Line["CategoryCode")
		{
			continue
		}
		w Line,!
		s strRowID = $p(Line,",",1)
		s strCatCode = $p(Line,",",2)
		s strCatName = ""
		s rowDiagnoCID = $o(^DHCEMRM.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(strCatCode,"U"),""))
		if (rowDiagnoCID'="")
		{
			s objCategory = ##Class(EMRmeta.DiagnosCategory).%OpenId(rowDiagnoCID)
			s strCatName = objCategory.CategoryName
		}
		s obj=##Class(EMRmeta.Diagnos).%OpenId(strRowID)
		s obj.CategoryCode=strCatCode
		s obj.CategoryName=strCatName
		
		s isOK = obj.%Save()
		if isOK '= "1"
		{	
			s FailCount = FailCount + 1
		}
		
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w "Summary: "_FileCnt_" rows imported, fail count:"_FailCount,!
	quit
}

/// EMRmeta.CategoryViewDisplay
/// Desc:     病历目录视图显示：EMRmeta.CategoryViewDisplay
/// Creator:   Lina
/// Createdate:2016-12-26
/// d ##Class(EMRservice.Tools.Tool).InitCategoryViewDisplay("d:\CategoryViewDisplay.txt")
ClassMethod InitCategoryViewDisplay(argFile As %String)
{
	k ^DHCEMRM.CategoryViewDisplayD,^DHCEMRM.CategoryViewDisplayI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.CategoryViewDisplay).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ViewDisplayId = $p(sRec, $c(9), 1)
 		s obj.ViewDisplayDesc = $p(sRec, $c(9), 2)
        s obj.ViewDisplayType = $p(sRec, $c(9), 3)

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 修改EMRinstance.InstanceData表中的数据，如果有上线前的测试数据上线后没有删掉，可以通过此方法屏蔽掉测试数据
/// d ##class(EMRservice.Tools.Tool).shieldTestInstanceData("2016-04-14","2017-01-13")
ClassMethod shieldTestInstanceData(AStartDate As %String, AEndDate As %String) As %String
{
	//此方法屏蔽，因EpisodeID和ChartItemID字段变更类型
	q "方法已经屏蔽，不可使用！"
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	
	for ModifyDate = StartDate:1:EndDate
	{
		s ECRecordID = ""
		for
		{
			s ECRecordID = $O(^DHCEMRI.InstanceDataI("IdxModifyDate",ModifyDate,ECRecordID))
			q:(ECRecordID = "")
			
			s ECRecordObj =  ##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
			q:(ECRecordObj = "")
			s ECRecordEpisodeID = ECRecordObj.RealEpisodeID
			//continue:(ECRecordEpisodeID < "101")   //根据实际情况进行修改，有的项目上线后把pa_amd表清掉，这样可以将已做过处理的冗余数据过滤掉，不再做处理
			s ECRecordChartItemID = ECRecordObj.RealChartItemID
			
			s ECRecordObj.EpisodeID = "TestData^"_ECRecordEpisodeID
			s ECRecordObj.ChartItemID = "TestData^"_ECRecordChartItemID
			
			s ECRecordsc=ECRecordObj.%Save()
			if $system.Status.IsError(ECRecordsc) {                      //检查Save是否成功
		   		do $system.OBJ.DisplayError(ECRecordsc) 
		   		s ^CacheTemp("ERROR","EMRservice.Tools.EPRorEMR.ECRecordData")=ECRecordID_"$"_ECRecordEpisodeID_"$"_ECRecordObj.EpisodeID_"$"_ECRecordChartItemID_"$"_ECRecordObj.ChartItemID
			}
			do ECRecordObj.%Close()
			
			s ListNO = ""
			for
			{
				s ListNO = $O(^DHCEMRI.InstanceDataI("IdxModifyDate",ModifyDate,ECRecordID,ListNO))
				q:(ListNO = "")
				
				s InstanceID = ECRecordID_"||"_ListNO
				
				s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
				q:(InstanceObj = "")
				s EpisodeID = InstanceObj.RealEpisodeID
				s GroupItemID = InstanceObj.GroupItemID
				
				s InstanceObj.EpisodeID = "TestData^"_EpisodeID
				s InstanceObj.GroupItemID = "TestData^"_GroupItemID
				
				s sc=InstanceObj.%Save()
				if $system.Status.IsError(sc) {                      //检查Save是否成功
			   		do $system.OBJ.DisplayError(sc) 
			   		s ^CacheTemp("ERROR","EMRservice.Tools.EPRorEMR.InstanceData")=InstanceID_"$"_EpisodeID_"$"_InstanceObj.EpisodeID_"$"_GroupItemID_"$"_InstanceObj.GroupItemID
				}
				do InstanceObj.%Close()
			}
		}
	}
}

/// Creator：      guozongtao
/// CreatDate：    2016-09-03
/// Description:   清除电子病历产品组业务数据 DHCEMRI* ,DHCEMRF*,DHCEMRT* 
/// Table：        
/// Input：        
/// Output         
/// Return：       
/// Others：       
/// Debug:         d ##Class(EMRservice.Tools.Tool).KillEMRInstanceData()	
ClassMethod KillEMRInstanceData()
{
	w "删除电子病历产品组业务数据 DHCEMRI* ,DHCEMRF*,DHCEMRT*",!
	w "注意:确认操作的数据库是否是 正式环境！",!
	r "是否继续: 是(y) 否(n) ",flag
	if ($zcvt(flag,"U")= "Y")
	{	
		//EMRinstance.Custom.SelfPrintLog 自助设备打印记录
		K ^DHCEMRI.SelfPrintLogD
		K ^DHCEMRI.SelfPrintLogI
		K ^DHCEMRI.SelfPrintLogS
	
		//EMRinstance.Events.ActionLog 动作日志
		K ^DHCEMRI.Events.ActionLogD
		K ^DHCEMRI.Events.ActionLogI
		K ^DHCEMRI.Events.ActionLogS
	
		//EMRinstance.Events.BloodTransfusion 实例数据-医疗活动事件-输血
		K ^DHCEMRI.Events.BloodD
		K ^DHCEMRI.Events.BloodI
		K ^DHCEMRI.Events.BloodS
	
		//EMRinstance.Events.CriticalValue 实例数据-医疗活动事件-检验结果危急值
		K ^DHCEMRI.Events.CriticalValueD
		K ^DHCEMRI.Events.CriticalValueI
		K ^DHCEMRI.Events.CriticalValueS
	
		//EMRinstance.Events.LinkDocumnents 实例数据-医疗活动事件-医疗活动记录链接表
		K ^DHCEMRI.Events.LinkDocumnentsD
		K ^DHCEMRI.Events.LinkDocumnentsI
		K ^DHCEMRI.Events.LinkDocumnentsS
	
		//EMRinstance.Events.Operation 实例数据-医疗活动事件-手术\操作信息
		K ^DHCEMRI.Events.OperationD
		K ^DHCEMRI.Events.OperationI
		K ^DHCEMRI.Events.OperationS
	
		//EMRinstance.Events.Rescue 实例数据-医疗活动事件-抢救信息
		K ^DHCEMRI.Events.RescueD
		K ^DHCEMRI.Events.RescueI
		K ^DHCEMRI.Events.RescueS
	
		//EMRinstance.Export.Succeed 病历导出对队表
		K ^DHCEMRI.Export.SucceedD
		K ^DHCEMRI.Export.SucceedI
		K ^DHCEMRI.Export.SucceedS
	
		//EMRinstance.Export.Failure 病历导出失败队列表
		K ^DHCEMRI.Export.FailureD
		K ^DHCEMRI.Export.FailureI
		K ^DHCEMRI.Export.FailureS
	
		//EMRinstance.Export.Exe 病历导出对队表
		K ^DHCEMRI.Export.ExeD
		K ^DHCEMRI.Export.ExeI
		K ^DHCEMRI.Export.ExeS
	
		//EMRinstance.Export.Queue 病历导出对队表
		K ^DHCEMRI.Export.QueueD
		K ^DHCEMRI.Export.QueueI
		K ^DHCEMRI.Export.QueueS
	
		//EMRinstance.Favorites.FavUser 用户收藏夹目录
		K ^DHCEMRF.FavUserD
		K ^DHCEMRF.FavUserI
		K ^DHCEMRF.FavUserS
	
		//EMRinstance.Favorites.FavTagInformation 病例标签表
		K ^DHCEMRF.FavTagInformationD
		K ^DHCEMRF.FavTagInformationI
		K ^DHCEMRF.FavTagInformationS
	
		//EMRinstance.Favorites.FavTag 收藏夹标签 
		K ^DHCEMRF.FavTagD
		K ^DHCEMRF.FavTagI
		K ^DHCEMRF.FavTagS
		
		//EMRinstance.Favorites.FavRecordComment 收藏病历评论 
		K ^DHCEMRF.FavRecordCommentD
		K ^DHCEMRF.FavRecordCommentI
		K ^DHCEMRF.FavRecordCommentS	

		//EMRinstance.Favorites.FavRecord 收藏病历 
		K ^DHCEMRF.FavRecordD
		K ^DHCEMRF.FavRecordI
		K ^DHCEMRF.FavRecordS	
	
		//EMRinstance.Favorites.FavInformation 收藏夹病历信息
		K ^DHCEMRF.FavInformationD
		K ^DHCEMRF.FavInformationI
		K ^DHCEMRF.FavInformationS
	
		//EMRinstance.Favorites.FavCommentReply 评论回复
		K ^DHCEMRF.FavCommentReplyD
		K ^DHCEMRF.FavCommentReplyI
		K ^DHCEMRF.FavCommentReplyS
	
		//EMRinstance.Favorites.FavCatalog 收藏夹目录
		//K ^DHCEMRF.FavCatalogD
		//K ^DHCEMRF.FavCatalogI
		//K ^DHCEMRF.FavCatalogS

		//EMRinstance.plugin.RefreshBindData 是否显示绑定数据提示框状态
		K ^DHCEMRI.plugin.RefreshBindDataD
		K ^DHCEMRI.plugin.RefreshBindDataI
		K ^DHCEMRI.plugin.RefreshBindDataS
	
		//EMRinstance.Trace.ActionLog 用户行为记录
		K ^DHCEMRT.ActionLogD
		K ^DHCEMRT.ActionLogI
		K ^DHCEMRT.ActionLogS

		//EMRinstance.Trace.Actions 用户收藏夹目录
		K ^DHCEMRT.ActionsD
		K ^DHCEMRT.ActionsI
		K ^DHCEMRT.ActionsS

		//EMRinstance.VersionHistory  
		K ^DHCEMRI.VersionHistoryD
		K ^DHCEMRI.VersionHistoryI
		K ^DHCEMRI.VersionHistoryS

		//EMRinstance.TextCollector 
		K ^DHCEMRI.TextCollectorD
		K ^DHCEMRI.TextCollectorI
		K ^DHCEMRI.TextCollectorS

		//EMRinstance.SubjectLog 电子病历订阅信息操作日志表
		K ^DHCEMRI.SubjectLogD
		K ^DHCEMRI.SubjectLogI
		K ^DHCEMRI.SubjectLogS
	
		//EMRinstance.Lock 电子病历锁表
		K ^DHCEMRI.LockD
		K ^DHCEMRI.LockI
		K ^DHCEMRI.LockS

		//EMRinstance.ISectionDesc 实例数据-章节打散表
		K ^DHCEMRI.ISectionDescD
		K ^DHCEMRI.ISectionDescI
		K ^DHCEMRI.ISectionDescS
	
		//EMRinstance.ICompositeDesc 实例数据-复合单元打散表
		K ^DHCEMRI.ICompositeDescD
		K ^DHCEMRI.ICompositeDescI
		K ^DHCEMRI.ICompositeDescS
		K ^DHCEMRI.ICompositeS
	
		//EMRinstance.ICompositeSimple 实例数据-简单单元打散表
		K ^DHCEMRI.ICompositeSimpleD
		K ^DHCEMRI.ICompositeSimpleI
		K ^DHCEMRI.ICompositeSimpleS
	
		//EMRinstance.ICompositeConcept 实例数据-医学元素打散表
		K ^DHCEMRI.ICompositeConceptD
		K ^DHCEMRI.ICompositeConceptI
		K ^DHCEMRI.ICompositeConceptS
		K ^DHCEMRI.IConceptS
		K ^DHCEMRI.IIConceptS
	
		//EMRinstance.ICompositeConceptSimple 实例数据-医学元素简单单元打散表
		K ^DHCEMRI.IConceptSimpleD
		K ^DHCEMRI.IConceptSimpleI
		K ^DHCEMRI.IConceptSimpleS
	
		//EMRinstance.ECRecord 实例数据-外部图表记录
		K ^DHCEMRI.ECRecordD
		K ^DHCEMRI.ECRecordI
		K ^DHCEMRI.ECRecordS

		//EMRinstance.ECRecordExtraInfo
		K ^DHCEMRI.ECRecordExtraInfoD
		K ^DHCEMRI.ECRecordExtraInfoI
		K ^DHCEMRI.ECRecordExtraInfoS

	
		//EMRinstance.InstanceData 实例数据-实例数据表
		K ^DHCEMRI.InstanceDataI
		K ^DHCEMRI.InstanceDataS
		
		//EMRinstance.InstanceCode 实例数据关联代码表
		k ^DHCEMRI.InstanceCodeD
		k ^DHCEMRI.InstanceCodeI
		k ^DHCEMRI.InstanceCodeS
	
		//EMRinstance.EMRLogs 存储病历操作日志和状态
		K ^DHCEMRI.EMRLogsD
		K ^DHCEMRI.EMRLogsI
		K ^DHCEMRI.EMRLogsS
	
		//EMRinstance.InstanceLog 实例数据-实例数据操作日志表
		K ^DHCEMRI.InstanceLogI 
		K ^DHCEMRI.InstanceLogS

		//EMRinstance.InstancePrintRecord 实例数据-病历打印记录子表
		K ^DHCEMRI.InstancePrintRecordD
		K ^DHCEMRI.InstancePrintRecordI
		K ^DHCEMRI.InstancePrintRecordS

		//EMRinstance.EpisodePrintRecord 实例数据-病历打印记录
		K ^DHCEMRI.EpisodePrintRecordD
		K ^DHCEMRI.EpisodePrintRecordI
		K ^DHCEMRI.EpisodePrintRecordS

		//EMRinstance.EMRActionAppoint 
		K ^DHCEMRI.EMRActionAppointD
		K ^DHCEMRI.EMRActionAppointI
		K ^DHCEMRI.EMRActionAppointS
	
		//EMRinstance.ActionAppointSub 会诊病历浏览授权,授权子表
		K ^DHCEMRI.ActionAppointSubD
		K ^DHCEMRI.ActionAppointSubI
		K ^DHCEMRI.ActionAppointSubS

		//EMRinstance.AdmPatType 
		K ^DHCEMRI.AdmPatTypeD
		K ^DHCEMRI.AdmPatTypeI
		K ^DHCEMRI.AdmPatTypeS
	
		//EMRinstance.DirectoryInformation 患者就诊病历目录信息
		K ^DHCEMRI.DirectoryInformationD
		K ^DHCEMRI.DirectoryInformationI
		K ^DHCEMRI.DirectoryInformationS
	
		//EMRinstance.EMRDept 
		K ^DHCEMRI.EMRDeptD
		K ^DHCEMRI.EMRDeptI
		K ^DHCEMRI.EMRDeptS
	
		//EMRinstance.EMRSign 签名表
		K ^DHCEMRI.EMRSignD
		K ^DHCEMRI.EMRSignI 
		K ^DHCEMRI.EMRSignS
	
		//EMRinstance.EMRSignLog 数字签名日志
		K ^DHCEMRCA.EMRSignLogD
		K ^DHCEMRCA.EMRSignLogI
		K ^DHCEMRCA.EMRSignLogS
		


		//EMRinstance.AuthAppoint 申请授权记录主表
		K ^DHCEMRI.AuthAppointD
		K ^DHCEMRI.AuthAppointI
		K ^DHCEMRI.AuthAppointS

		//EMRinstance.AuthAppointDetail 申请授权记录明细表
		K ^DHCEMRI.AuthAppointDetailD
		K ^DHCEMRI.AuthAppointDetailI
		K ^DHCEMRI.AuthAppointDetailS
		
		//EMRinstance.AuthRequest 权限申请记录表
		K ^DHCEMRI.AuthRequestD
		K ^DHCEMRI.AuthRequestI
		K ^DHCEMRI.AuthRequestS
		
		//清除病历查询方案业务数据
		//EPRmeta.Query.QueryCaseName
		K ^DHCEPRM.QueryCaseNameD
		K ^DHCEPRM.QueryCaseNameI
		K ^DHCEPRM.QueryCaseNameS
		
		//清除病历查询方案业务数据_查询结果
		//EPRmeta.Query.QueryCaseResultCols
		K ^DHCEPRM.QueryCaseResultColsD
		K ^DHCEPRM.QueryCaseResultColsI
		K ^DHCEPRM.QueryCaseResultColsS
		
		//清除病历查询方案业务数据_查询条件
		//EPRmeta.Query.QueryCaseCondition
		K ^DHCEPRM.QueryCaseConditionD
		K ^DHCEPRM.QueryCaseConditionI
		K ^DHCEPRM.QueryCaseConditionS
		
		
		//分式打散数据
		K ^DHCEMRI.ICompositeMacroD
		K ^DHCEMRI.ICompositeMacroI
		K ^DHCEMRI.ICompositeMacroS
		
		//EMRinstance.IMacroObjectItems
		K ^DHCEMRI.IMacroObjectItemsD
		K ^DHCEMRI.IMacroObjectItemsI
		K ^DHCEMRI.IMacroObjectItemsS
		
		//EMRinstance.SpecialLog
		K ^DHCEMRI.SpecialLogD
		K ^DHCEMRI.SpecialLogI
		K ^DHCEMRI.SpecialLogS
		
		//EMRinstance.ExtAuditLog 门办审核日志
		k ^DHCEMRI.ExtAuditLogD
		k ^DHCEMRI.ExtAuditLogI
		
		//EMRinstance.AdmRecordStatus 提交日志
		K ^DHCEMRI.AdmRecordStatusD
		K ^DHCEMRI.AdmRecordStatusI
		K ^DHCEMRI.AdmRecordStatusS
		
		//EMRinstance.AdmTaskExec
		K ^DHCEMRI.AdmTaskExecD
		K ^DHCEMRI.AdmTaskExecI
		K ^DHCEMRI.AdmTaskExecS
		
		//EMRinstance.AdmTaskQueue
		K ^DHCEMRI.AdmTaskQueueD
		K ^DHCEMRI.AdmTaskQueueS
		K ^DHCEMRI.AdmTaskQueueI
		
		//EMRinstance.AdmTaskSucceed
		K ^DHCEMRI.AdmTaskSucceedD
		K ^DHCEMRI.AdmTaskSucceedS
		K ^DHCEMRI.AdmTaskSucceedI
		
		
		//EMRinstance.EMRCustomLogs
		K ^DHCEMRI.EMRCustomLogsD
		K ^DHCEMRI.EMRCustomLogsI
		K ^DHCEMRI.EMRCustomLogsS
		
		//EMRinstance.MessageList
		K ^DHCEMRI.MessageListD
		K ^DHCEMRI.MessageListI
		K ^DHCEMRI.MessageListS
		
		//EMRinstance.ApplyEdit
		K ^DHCEMRI.ApplyEditD
		K ^DHCEMRI.ApplyEditS
		K ^DHCEMRI.ApplyEditI
		
		//EMRinstance.LockSpecial
		K ^DHCEMRI.LockSpecialD
		K ^DHCEMRI.LockSpecialI
		K ^DHCEMRI.LockSpecialS
		
		
		//EMRinstance.ICompSimpExpand
		K ^DHCEMRI.ICompSimpExpandD
		K ^DHCEMRI.ICompSimpExpandI
		K ^DHCEMRI.ICompSimpExpandS
		
		//EMRinstance.LisDataReference
		K ^DHCEMRI.LisDataReferenceD
		K ^DHCEMRI.LisDataReferenceI
		K ^DHCEMRI.LisDataReferenceS
		
		//EPRinstance.Query.MedicalQueryTaskList
		//病历查询后台任务表
		k ^DHCEPRI.MedicalQueryTD
		k ^DHCEPRI.MedicalQueryTI
		k ^DHCEPRI.MedicalQueryTS
		
		//病历查询后台任务结果（仅存在数据Global）
		k ^DHCEPRI.MedicalQueryTaskData
		
		//病历全部完成状态操作日志表
		//EMRinstance.AdmRecordStatusLog
		k ^DHCEMRI.AdmRecordStatusLogD
		k ^DHCEMRI.AdmRecordStatusLogI
		k ^DHCEMRI.AdmRecordStatusLogS
		
		//清除实例创建产生的实例与科室模板、个人模板关联数据
		k ^DHCEMRI.InstanceUserTemplateD
		k ^DHCEMRI.InstanceUserTemplateI
		k ^DHCEMRI.InstanceUserTemplateS
		
		k ^DHCEMRI.InstPersonTemplateD
		k ^DHCEMRI.InstPersonTemplateI
		k ^DHCEMRI.InstPersonTemplateS
		
		//遗漏清除global
		
		K ^DHCEMRI.AuthAppointSubD
		K ^DHCEMRI.AuthAppointSubI
		
		K ^DHCEMRI.CheckXMLStreamD
		K ^DHCEMRI.CheckXMLStreamS
		
		K ^DHCEMRI.DebuggerConfigD
		K ^DHCEMRI.DebuggerConfigI
		
		K ^DHCEMRI.EMRSignI
		
		K ^DHCEMRI.Events.ConsultD
		K ^DHCEMRI.Events.ConsultI
		
		K ^DHCEMRI.Events.MDTD
		K ^DHCEMRI.Events.MDTI
		
		K ^DHCEMRI.Events.OperationSubI
		
		K ^DHCEMRI.FileStoreAdmD
		K ^DHCEMRI.FileStoreAdmI
		
		K ^DHCEMRI.ICompositeToothD
		K ^DHCEMRI.ICompositeToothI
		
		K ^DHCEMRI.IToothAreaD
		K ^DHCEMRI.IToothAreaI
		
		K ^DHCEMRI.IToothItemsD
		K ^DHCEMRI.IToothItemsI
		
		K ^DHCEMRI.InstanceDataExtraInfoD
		K ^DHCEMRI.InstanceDataExtraInfoI
		
		K ^DHCEMRI.InstanceLogI
		
		K ^DHCEMRI.LinkProductD
		K ^DHCEMRI.LinkProductI
		
		K ^DHCEMRI.MedicalHistoryD
		K ^DHCEMRI.MedicalHistoryI
		
		K ^DHCEMRI.PastHistoryD
		K ^DHCEMRI.PastHistoryI
		
		K ^DHCEMRI.PersonalTemplateFreqD
		K ^DHCEMRI.PersonalTemplateFreqI
		
		K ^DHCEMRI.RecordTransferLogD
		K ^DHCEMRI.RecordTransferLogI
		
		K ^DHCEMRI.RevisionLogD
		K ^DHCEMRI.RevisionLogI
		K ^DHCEMRI.RevisionLogS
		
		K ^DHCEMRI.TemplateFrequencyD
		K ^DHCEMRI.TemplateFrequencyI
		
		K ^DHCEMRI.TitleDoctorD
		K ^DHCEMRI.TitleDoctorI
		
		K ^DHCEMRI.UserTemplateFreqD
		K ^DHCEMRI.UserTemplateFreqI
		
		K ^DHCEMRI.plugin.RefreshDataHD
		K ^DHCEMRI.plugin.RefreshDataHI
		
		W !, "数据 DHCEMRI* ,DHCEMRF*,DHCEMRT* 清除完成！"
		
		///用户操作习惯记录数据
		k ^DHCEMRM.UserPageConfigD
		k ^DHCEMRM.UserPageConfigI
		k ^DHCEMRM.UserPageConfigS
		
		//EMRinstance.InstanceDataCompressInfo
		K ^DHCEMRI.InstanceDataCompressD
		K ^DHCEMRI.InstanceDataCompressI
		K ^DHCEMRI.InstanceDataCompressS
		
		//EMRinstance.InstanceDataExtraInfo
		K ^DHCEMRI.InstanceDataExtraInfoD
		K ^DHCEMRI.InstanceDataExtraInfoI
		K ^DHCEMRI.InstanceDataExtraInfoS
		
		//EMRinstance.InstanceLinkProduct
		K ^DHCEMRI.LinkProductD
		K ^DHCEMRI.LinkProductI
		K ^DHCEMRI.LinkProductS
	
		//EMRinstance.AdmMRecordStaLog
		k ^DHCEMRI.AdmMRecordStaLogD
		k ^DHCEMRI.AdmMRecordStaLogI
		k ^DHCEMRI.AdmMRecordStaLogS
		
		//EMRinstance.AdmMRecordStatus
		k ^DHCEMRI.AdmMRecordStatusD
		k ^DHCEMRI.AdmMRecordStatusI
		k ^DHCEMRI.AdmMRecordStatusS
		
		//EMRinstance.AnySignLog
		k ^DHCEMRI.AnySignLogD
		k ^DHCEMRI.AnySignLogI
		k ^DHCEMRI.AnySignLogS
		
		//EMRinstance.AuthAppointSub
		k ^DHCEMRI.AuthAppointSubD
		k ^DHCEMRI.AuthAppointSubI
		k ^DHCEMRI.AuthAppointSubS
		
		//EMRinstance.BSEMRBrowseLogs
		k ^DHCEMRI.BSEMRBrowseLogsD
		k ^DHCEMRI.BSEMRBrowseLogsI
		k ^DHCEMRI.BSEMRBrowseLogsS
		
		//EMRinstance.CabinPrintRecord
		k ^DHCEMRI.CabinPrintRecordD
		k ^DHCEMRI.CabinPrintRecordI
		k ^DHCEMRI.CabinPrintRecordS
		
		//EMRinstance.CheckXMLStream
		k ^DHCEMRI.CheckXMLStreamD
		k ^DHCEMRI.CheckXMLStreamI
		k ^DHCEMRI.CheckXMLStreamS
		
		//EMRinstance.Custom.AppRecordInfo
		k ^DHCEMRI.Custom.AppRecordInfoD
		k ^DHCEMRI.Custom.AppRecordInfoI
		k ^DHCEMRI.Custom.AppRecordInfoS
		
		//EMRinstance.DischargedWaitingToSubmit
		k ^DHCEMRI.DisWaitToSubmitD
		k ^DHCEMRI.DisWaitToSubmitI
		k ^DHCEMRI.DisWaitToSubmitS
		
		//EMRinstance.Events.Manipulate
		k ^DHCEMRI.Events.ManipulateD
		k ^DHCEMRI.Events.ManipulateI
		k ^DHCEMRI.Events.ManipulateS
		
		//EMRinstance.Events.ModDiagnosis
		k ^DHCEMRI.Events.ModDiagnosisD
		k ^DHCEMRI.Events.ModDiagnosisI
		k ^DHCEMRI.Events.ModDiagnosisS
		
		//EMRinstance.FileStoreAdm
		k ^DHCEMRI.FileStoreAdmD
		k ^DHCEMRI.FileStoreAdmI
		k ^DHCEMRI.FileStoreAdmS
		
		//EMRinstance.FirstPage.InterfaceLog
		k ^DHCEMRI.FPageInterfaceLogD
		k ^DHCEMRI.FPageInterfaceLogI
		k ^DHCEMRI.FPageInterfaceLogS
		
		//EMRinstance.IEyeObjectItems
		k ^DHCEMRI.IEyeObjectItemsD
		k ^DHCEMRI.IEyeObjectItemsI
		k ^DHCEMRI.IEyeObjectItemsS
		
		//EMRinstance.InstanceLinkTool
		k ^DHCEMRI.InstanceLinkToolD
		k ^DHCEMRI.InstanceLinkToolS
		k ^DHCEMRI.InstanceLinkToolI
		
		//EMRinstance.InstanceLogSectionData
		k ^DHCEMRI.InstanceLogSectionDataD
		k ^DHCEMRI.InstanceLogSectionDataI
		k ^DHCEMRI.InstanceLogSectionDataS
		
		//EMRinstance.InstancePersonalTemplate
		k ^DHCEMRI.InstPersonTemplateD
		k ^DHCEMRI.InstPersonTemplateI
		k ^DHCEMRI.InstPersonTemplateS
		
		//EMRinstance.TemplateGroupDocument
		k ^DHCEMRI.TemplateGroupDocD
		k ^DHCEMRI.TemplateGroupDocI
		k ^DHCEMRI.TemplateGroupDocS
		
		//EMRinstance.TemplateFrequency
		k ^DHCEMRI.TemplateFrequencyD
		k ^DHCEMRI.TemplateFrequencyI
		k ^DHCEMRI.TemplateFrequencyS
		
		//EMRinstance.SDOPRecord
		k ^DHCEMRI.SDOPRecordD
		k ^DHCEMRI.SDOPRecordI
		k ^DHCEMRI.SDOPRecordS
		
		//EMRinstance.RevisionLog
		k ^DHCEMRI.RevisionLogD
		k ^DHCEMRI.RevisionLogI
		k ^DHCEMRI.RevisionLogS
		
		//EMRinstance.Repository.iBookLogs
		k ^DHCEMRI.iBookLogsD
		k ^DHCEMRI.iBookLogsI
		k ^DHCEMRI.iBookLogsS
		
		//EMRinstance.RecordTransferLog
		k ^DHCEMRI.RecordTransferLogD
		k ^DHCEMRI.RecordTransferLogI
		k ^DHCEMRI.RecordTransferLogS
		
		//EMRinstance.RecordTitleSuperiorDoctor
		k ^DHCEMRI.TitleDoctorD
		k ^DHCEMRI.TitleDoctorI
		k ^DHCEMRI.TitleDoctorS
		
		//EMRinstance.PrintToolRecord
		k ^DHCEMRI.PrintToolRecordD
		k ^DHCEMRI.PrintToolRecordI
		k ^DHCEMRI.PrintToolRecordS
		
		//EMRinstance.PrintTips
		k ^DHCEMRI.PrintTipsD
		k ^DHCEMRI.PrintTipsI
		k ^DHCEMRI.PrintTipsS
		
		//EMRinstance.plugin.RefreshDataHidden
		k ^DHCEMRI.plugin.RefreshDataHD
		k ^DHCEMRI.plugin.RefreshDataHI
		k ^DHCEMRI.plugin.RefreshDataHS
		
		//EMRinstance.PlantToothTreatmentInstanceId
		k ^DHCEMRI.PlantToothTInsD
		k ^DHCEMRI.PlantToothTInsI
		k ^DHCEMRI.PlantToothTInsS
		
		//EMRinstance.PlantToothTreatment
		k ^DHCEMRI.PlantToothTD
		k ^DHCEMRI.PlantToothTI
		k ^DHCEMRI.PlantToothTS
		
		//EMRinstance.pictureManage
		k ^DHCEMRI.pictureManageD
		k ^DHCEMRI.pictureManageI
		k ^DHCEMRI.pictureManageS
		
		//EMRinstance.PersonalTemplateFrequency
		k ^DHCEMRI.PersonalTemplateFreqD
		k ^DHCEMRI.PersonalTemplateFreqI
		k ^DHCEMRI.PersonalTemplateFreqS
		
		//EMRinstance.PacsDataReference
		k ^DHCEMRI.PacsDataReferenceD
		k ^DHCEMRI.PacsDataReferenceI
		k ^DHCEMRI.PacsDataReferenceS
		
		//EMRinstance.PastHistory
		k ^DHCEMRI.PastHistoryD
		k ^DHCEMRI.PastHistoryI
		k ^DHCEMRI.PastHistoryS
		
		//EMRinstance.PatientDoctor
		k ^DHCEMRI.PatientDoctorD
		k ^DHCEMRI.PatientDoctorI
		k ^DHCEMRI.PatientDoctorS
		
		//EMRinstance.PDF.AuditSignLog
		k ^DHCEMRCA.AuditSignLogD
		k ^DHCEMRCA.AuditSignLogI
		k ^DHCEMRCA.AuditSignLogS
		
		//EMRinstance.MedicalLog
		k ^DHCEMRI.MedicalLogD
		k ^DHCEMRI.MedicalLogI
		k ^DHCEMRI.MedicalLogS
		
		//EMRinstance.LockOp
		k ^DHCEMRI.LockOpD
		k ^DHCEMRI.LockOpI
		k ^DHCEMRI.LockOpS
		
		//EMRinstance.LisDataReference
		k ^DHCEMRI.LisDataReferenceD
		k ^DHCEMRI.LisDataReferenceI
		k ^DHCEMRI.LisDataReferenceS
		
		//EMRinstance.IToothItems
		k ^DHCEMRI.IToothItemsD
		k ^DHCEMRI.IToothItemsI
		k ^DHCEMRI.IToothItemsS
		
		//EMRinstance.IToothArea
		k ^DHCEMRI.IToothAreaD
		k ^DHCEMRI.IToothAreaI
		k ^DHCEMRI.IToothAreaS
		
		//EMRinstance.UserTemplateFrequency
		k ^DHCEMRI.UserTemplateFreqD
		k ^DHCEMRI.UserTemplateFreqI
		k ^DHCEMRI.UserTemplateFreqS
		
		
		//清除生成顺序递增的唯一编码的临时global
		K ^Tempc0
		K ^Tempc1
		W !, "数据 EMRmeta.UserPageConfig 清除完成！"
		
	}
	else
	{
		W !, "取消操作！"
	}
	quit
}

/// add by duan 2019.3.25
/// desc 获取系统日期时间配置
ClassMethod GetHISStandardDateTimeStyle(AType As %String)
{
	s ret = ""
	if (AType="Date")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||DateFormat")){
			s ret=##class(websys.Conversions).DateFormat()	
		}	
	}elseif(AType="Time")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||TimeFormat")){
			s ret=##class(websys.Conversions).TimeFormat()	
		}
	}
	q ret
}

/// 正常日期转cache格式
/// add by duan 2019.3.25
/// input 23:09	
/// output 83340
ClassMethod GetDateTimeHtmlToLogical(AType As %String, ArgDateTimeValue As %String)
{
	s ret = ArgDateTimeValue
	if (AType="Date")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||DateHtmlToLogical")){
			s ret = ##class(websys.Conversions).DateHtmlToLogical(ArgDateTimeValue)
		}	
	}elseif(AType="Time")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||TimeHtmlToLogical")){
			s ret = ##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)	
		}
	}
	q ret
}

/// cache日期格式转正常时间格式
/// add by duan 2019.3.25
/// input  83340
/// output 23:09
ClassMethod GetDateTimeLogicalToHtml(AType As %String, ArgDateTimeValue As %String)
{
	s ret = ArgDateTimeValue
	if (AType="Date")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||DateLogicalToHtml")){
			s ret = ##class(websys.Conversions).DateLogicalToHtml(ArgDateTimeValue)
		}	
	}elseif(AType="Time")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||TimeLogicalToHtml")){
			s ret = ##class(websys.Conversions).TimeLogicalToHtml(ArgDateTimeValue)	
		}
	}
	q ret
}

/// w ##class(EMRservice.Tools.Tool).GetHISStandardDataTimeFormat()
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("GetFormatExt","Date")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("GetFormatExt","Time")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("GetFormat","Date")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("GetFormat","Time")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date","2012-10-11")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time","12:01")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToSysFormat","DateTime","2012-10-11 11:00")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date","2012-01-11")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time","11:00")
/// w ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime","2012-01-11 11:00")
ClassMethod GetHISStandardDateTimeFormat(IsFormat As %String, IsDataOrTime As %String, ArgDateTimeValue As %String = "") As %String
{
	s retvalue=""
	//取extjs日期时间格式
	if (IsFormat="GetFormatExt")
	{
		if IsDataOrTime="Date" {
			//----取日期时间格式
			//3 YYYY-MM-DD
			//4 DD/MM/YYYY
			s retvalueType = ..GetHISStandardDateTimeStyle(IsDataOrTime)
			s retvalue=$s(retvalueType="3":"Y-m-d",retvalueType="4":"d/m/Y",retvalueType="":"")
			
		}
		elseif IsDataOrTime="Time"
		{
			/*
				1	HH:MM:SS		HMS 分割符 :   24小时格式
				2	HH:MM			HM 		分割符 :    24小时格式
				3	hh:mm:ssAM
					hh:mm:ssPM		hms 分割符 :    12小时格式
									AM为配置字符与PM配置字符
				4	hh:mmAM
					hh:mmPM			hm 分割符 :     12小时格式
									AM为配置字符与PM配置字符
			
			*/

			s retvalueType=..GetHISStandardDateTimeStyle(IsDataOrTime)
			
			s retvalue=$s(retvalueType="1":"H:i:s",retvalueType="2":"H:i",retvalueType=3:"hh:mm:ssAM",retvalueType=4:"hh:mmPM",retvalueType="":"")
		}
	}
	//取完整格式
	elseif (IsFormat="GetFormat")
	{
		if IsDataOrTime="Date" {
			//----取日期时间格式
			//3 YYYY-MM-DD
			//4 DD/MM/YYYY
			s retvalueType=..GetHISStandardDateTimeStyle(IsDataOrTime)
			s retvalue=$s(retvalueType="3":"YYYY-MM-DD",retvalueType="4":"DD/MM/YYYY",retvalueType="":"")
				
		}
		elseif IsDataOrTime="Time"
		{
			/*
				1	HH:MM:SS		HMS 分割符 :   24小时格式
				2	HH:MM			HM 		分割符 :    24小时格式
				3	hh:mm:ssAM
					hh:mm:ssPM		hms 分割符 :    12小时格式
									AM为配置字符与PM配置字符
				4	hh:mmAM
					hh:mmPM			hm 分割符 :     12小时格式
									AM为配置字符与PM配置字符
			
			*/
			s retvalueType=..GetHISStandardDateTimeStyle(IsDataOrTime)
			
			s retvalue=$s(retvalueType="1":"HH:MM:SS",retvalueType="2":"HH:MM",retvalueType=3:"HH:MM:SSAM",retvalueType=4:"HH:MMPM",retvalueType="":"")
		}
	}
	//取完整格式
	elseif (IsFormat="ChangeToSysFormat")
	{
		if IsDataOrTime="Date" 
		{
				//---日期转换
				
				/*normal to sys
				入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
				返回	M中日期数字	64338		64338		64338	ERROR
				*/
				s retvalue=..GetDateTimeHtmlToLogical(IsDataOrTime,ArgDateTimeValue)
				
		}
		elseif IsDataOrTime="Time" {
				//---时间转换
				
				/* normal to sys 
				入参	配置的时间格式	23:09	83340	25:67
				返回	M中时间数字		83340	83340	ERROR
				*/
				s retvalue=..GetDateTimeHtmlToLogical(IsDataOrTime,ArgDateTimeValue)
				
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
			
			s dateValue=..GetDateTimeHtmlToLogical("Date",beChangedDateValue)	
			
			s timeValue=..GetDateTimeHtmlToLogical("Time",beChangedTimeValue)
			
			
			
			s retvalue=dateValue_" "_timeValue
		}
	}
	elseif (IsFormat="ChangeToFormat")
	{
		if IsDataOrTime="Date" 
		{
				//---日期转换
				
				/*normal to sys
				入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
				返回	M中日期数字	64338		64338		64338	ERROR
				*/
				s dateHtmlToLogical=..GetDateTimeHtmlToLogical(IsDataOrTime,ArgDateTimeValue)
				/*
				入参	M中日期数字	64338		2017-2-24	9999999	
				返回	日期		2017-2-24	2017-2-24	ERROR
				*/
				s retvalue=..GetDateTimeLogicalToHtml(IsDataOrTime,dateHtmlToLogical)
		}
		elseif IsDataOrTime="Time" {
				//---时间转换

				
				/* normal to sys 
				入参	配置的时间格式	23:09	83340	25:67
				返回	M中时间数字		83340	83340	ERROR
				*/
				s timeHtmlToLogical=..GetDateTimeHtmlToLogical(IsDataOrTime,ArgDateTimeValue)
				
				/*
				入参	M中时间数字		83340	23:09	999999	
				返回	配置的时间格式	23:09	23:09	ERROR
				*/
				s retvalue=..GetDateTimeLogicalToHtml(IsDataOrTime,timeHtmlToLogical)
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
		
			s dateHtmlToLogical=..GetDateTimeHtmlToLogical("Date",beChangedDateValue)
			s dateValue=..GetDateTimeLogicalToHtml("Date",dateHtmlToLogical)
			s timeHtmlToLogical=..GetDateTimeHtmlToLogical("Time",beChangedTimeValue)
			s timeValue=..GetDateTimeLogicalToHtml("Time",timeHtmlToLogical)
			s retvalue=dateValue_" "_timeValue
		}
	}
	q retvalue
}

/// Desc:		 根据系统设置显示日期时间样式
/// Creator:     Candy 
/// CreateDate:  2018-10-16
/// Input:       ALogicalValue cache表格的日期或时间
///              AType:[date(日期),time(时间)]
/// Output:      result 转换后值
ClassMethod GetHisDateTimeFormat(ALogicalValue As %String, AType As %String) As %String
{
	s result = ""
	q:(ALogicalValue = "") result
	if (AType = "date")
	{
		s result = ##class(websys.Conversions).DateLogicalToHtml(ALogicalValue)
	}
	else
	{
		s result = ##class(websys.Conversions).TimeLogicalToHtml(ALogicalValue)
	}
	q result
}

ClassMethod GetALLEMRCLS(Afilepaht As %String = "D:\")
{
	
	
	s ListEMR=$lb("EMRinstance","EMRmeta","EMRservice","EMRview","EPRinstance","EPRmeta","EPRservice","EPRview")
	
	for i=1:1:$ll(ListEMR)
	{
		s packageName=$list(ListEMR,i)
		s tmpfilepath=Afilepaht_"\"_packageName
		s isExt=##Class(%Library.File).DirectoryExists(tmpfilepath)
		if ('isExt){
			w ##Class(%Library.File).CreateDirectoryChain(tmpfilepath)
			
			}
		Do $system.OBJ.ExportAllClassesIndividual(tmpfilepath,,,,packageName,"false")
	}
}

/// EMRmeta.ToothPosition
/// Desc:     牙位表：EMRmeta.ToothPosition
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.Tool).InitToothPosition("d:\ToothPosition.txt")
ClassMethod InitToothPosition(argFile As %String)
{
	k ^DHCEMRM.ToothPositionD,^DHCEMRM.ToothPositionI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothPosition).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothPCode = $p(sRec, $c(9), 1)
 		s obj.ToothPDes = $p(sRec, $c(9), 2)
        s obj.ToothPDefine = $p(sRec, $c(9), 3)
        s obj.ToothType = $p(sRec, $c(9), 4)
		continue:(obj.ToothPCode ="")
		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurface
/// Desc:     牙面表：EMRmeta.ToothSurface
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.Tool).InitToothSurface("d:\ToothSurface.txt")
ClassMethod InitToothSurface(argFile As %String)
{
	k ^DHCEMRM.ToothSurfaceD,^DHCEMRM.ToothSurfaceI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothSurface).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothSCode = $p(sRec, $c(9), 1)
 		s obj.ToothSDes = $p(sRec, $c(9), 2)
        s obj.ToothSDefine = $p(sRec, $c(9), 3)
		continue:(obj.ToothSCode ="")
		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurfaceItem
/// Desc:     牙面信息：EMRmeta.ToothSurfaceItem
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.Tool).InitToothSurfaceItem("d:\ToothSurfaceItem.txt")
ClassMethod InitToothSurfaceItem(argFile As %String)
{
	k ^DHCEMRM.ToothSurfaceItemD,^DHCEMRM.ToothSurfaceItemI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothSurfaceItem).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothPCode = $p(sRec, $c(9), 1)
		s obj.ToothSICode = $p(sRec, $c(9), 2)
 		s obj.ToothSIDes = $p(sRec, $c(9), 3)
        s obj.ToothSIDefine = $p(sRec, $c(9), 4)
        s obj.ScriptMode = $p(sRec, $c(9), 5)
        s obj.ToothType = $p(sRec, $c(9), 6)
		continue:(obj.ToothSICode ="")
		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurfaceItem
/// Desc:     专科知识库文本：EMRmeta.ToothSurfaceItem
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.Tool).InitOldKBTextData("d:\TextKBContent.txt")
ClassMethod InitOldKBTextData(argFile As %String)
{
	k ^DHCEMRM.TextKBCategoryD,^DHCEMRM.TextKBCategoryI
	k ^DHCEMRM.TextKBContentD,^DHCEMRM.TextKBContentI,^DHCEMRM.TextKBContentS
	k ^DHCEMRM.TextKBLocD,^DHCEMRM.TextKBLocI
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("并发症","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("操作记录","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("出院小结","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("辅助检查","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("鉴别诊断","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("日常病程","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("手术记录","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("诊断依据","folder",0)
	d ##Class(EMRservice.BL.BLTextKBCategory).AddData("诊疗计划","folder",0)
	s strType = ""	
	s stmContent = ##Class(%GlobalCharacterStream).%New()
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	s sRec =""
	s strMark =""
	s strFNum =""
	s strFID =""
	While 'Stream.AtEnd {
		if (strMark["####")
		{
			s sRec = strMark
		}
		else
		{
			s sRec = Stream.ReadLine()
		}
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")

		s strMark = Stream.ReadLine()
		s strMark = $tr(strMark,$c(13),"")
		
		while ((strMark'["####")&&('Stream.AtEnd))
		{
			if (stmContent.IsNull())
			{
				s strContent = $p(sRec, $c(9), 7)
				d stmContent.Write(strContent)
			}
			s soContent = $c(13)_$c(10)_strMark
			d stmContent.Write(soContent)
			s strMark = Stream.ReadLine()
			continue:(strMark = "")
		}
		if (stmContent.IsNull())
		{
			s strContent = $p(sRec, $c(9), 7)
			d stmContent.Write(strContent)
		}
		s objDep = ""
		s parName = $p(sRec, $c(9), 4)
		s ParentID = $o(^DHCEMRM.TextKBCategoryI("IdxName"," "_parName,""))
		s depName = $p(sRec, $c(9), 2)
		s depID = $o(^DHCEMRM.TextKBCategoryI("IdxParentIDName",ParentID," "_depName,""))
		//判断如果没有科室目录，添加科室目录，并关联科室
		if (depID ="")
		{
			s objDep = ##Class(EMRmeta.TextKBCategory).%New()
			s objDep.Name = depName
			s objDep.Type = "folder"
			s objDep.ParentID = ParentID
			s objDep.IsValid = "Y"
			s objDep.Sequence = $case($d(^DHCEMRM.TextKBCategoryD)>0,0:1,:^DHCEMRM.TextKBCategoryD+1)
			s sc = objDep.%Save()
			if ($$$ISOK(sc))
			{
				s objLoc = ##Class(EMRmeta.TextKBLoc).%New()
				s objLoc.CategoryID =objDep.%Id()
				s objLoc.LocID =$p(sRec, $c(9), 3)
				s sc =objLoc.%Save()
			}
			s depID = objDep.%Id()
		}
		else
		{
			s objDep = ##Class(EMRmeta.TextKBCategory).%OpenId(depID)
		}
		s obj = ##Class(EMRmeta.TextKBCategory).%New()
		s strType = $p(sRec, $c(9), 5)
		s obj.Name =  $p(sRec, $c(9), 6)
		if ((strFNum '="")&&(strFNum=((strType-1)_"F")))
		{
			s obj.ParentID = strFID
		}
		else
		{
			s strFNum = ""
			s strFID =""
			s obj.ParentID = depID
		}
		if (strType["F")
		{
			s obj.Type = "folder"
			s strFNum = strType
		}
		else
		{
			s obj.Type = "leaf"
		}
		s obj.IsValid = "Y"
		s obj.Sequence = $case($d(^DHCEMRM.TextKBCategoryD)>0,0:1,:^DHCEMRM.TextKBCategoryD+1)
		s sc = obj.%Save()
		if ($$$ISOK(sc))
	    {
		    if (obj.Type = "leaf")
		    {
			    s objCont = ##Class(EMRmeta.TextKBContent).%New()
			    s objCont.CategoryID = obj.%Id()
			    d objCont.Content.CopyFrom(stmContent)
			    d stmContent.Clear()
			    s sc = objCont.%Save()
		    }
		    else
		    {
			    s strFID =obj.%Id()
		    }
	    }
		s totCount = totCount + 1
		if (sc)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
		w " okCount"_okCount_" failCount"_failCount_$c(13)_$c(10)
	}
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       将日期时间转换成秒
/// Creator:    Candyxu
/// CreateDate: 2018-4-25
/// Input:      argDateTime 日期,时间 cache内部格式
ClassMethod GetAbsTime(argDateTime As %String) As %String
{
	s result = ""
	q:(argDateTime = "") result
	s date = $P(argDateTime,",",1)
	s time = $P(argDateTime,",",2)
	s result =  ((date*86400)+time)
	q result
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(EMRservice.Tools.Tool).GetCNCODE("单",4,"^")
/// w ##class(EMRservice.Tools.Tool).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..s:(HANZI="曾")&(i=1) tmpstr="Z"
	..s:(HANZI="单")&(i=1) tmpstr="S"
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

/// Desc:   第三方智能诊断工具 参数检索
/// Creator:    Duan
/// CreateDate: 2020-01-01
/// Input:      episodeID 就诊号
/// Debug: d ##Class(EMRservice.Tools.Tool).initParam(4,8,95,10209,2)
ClassMethod initParam(episodeID As %String, patientID As %String = "", userLocID As %String = "", userID As %String, hospitalID As %String)
{
	//s ^Temp("duan","initParam")=episodeID_","_patientID_","_userLocID_","_userID
	q:((episodeID="")||(userLocID="")||(userID="")) ""
	s:patientID="" patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	s patientNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
	s cdssType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("cdssType")
	s cdssLock = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("cdssLock")
	s cdssDoc = $P(cdssLock,"^",2)
	s cdssLock = $P(cdssLock,"^",1)
	s userLocName = $Case(userLocID,"":"",:$p(^CTLOC(userLocID),"^",2))	
	s hospitalName = $P(^CT("HOSP",hospitalID),"^",2)
	s userName = $p($G(^SSU("SSUSR",userID)),"^",1)
	//判断就诊类型
	s episodeType = $ZCVT($p(^PAADM(episodeID),"^",2),"U")
	//入院时间
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
	s admDateTime = $ZDateTime(admDateTime,3)
	//当前科室CurrentDept
	s currentDeptName=""
	s currentDeptId=""
	s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
	s:(currentDept '="") currentDeptName = $P(currentDept,"^",3)
	s:(currentDept '="") currentDeptId = $P(currentDept,"^",1)
	s mainDocCode = ""
	s mainDocName = ""
	//主管医师
	s mainDoc = ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(episodeID)
	s:mainDoc'="" mainDocCode=$P(mainDoc,"^",2)
	s:mainDoc'="" mainDocName=$P(mainDoc,"^",3)
	s cdssParam=##class(EMRservice.SystemParameter).getCDSSParam()
	s result = "{"
	s result = result_"""patientID"":"""_patientID_"""" 
	s result = result_",""patientNo"":"""_patientNo_""""
	s result = result_",""cdssType"":"""_cdssType_"""" 
	s result = result_",""cdssLock"":"""_cdssLock_""""
	s result = result_",""cdssDoc"":"""_cdssDoc_""""
	s result = result_",""userLocName"":"""_userLocName_"""" 
	s result = result_",""admDateTime"":"""_admDateTime_""""
	s result = result_",""currentDeptName"":"""_currentDeptName_""""
	s result = result_",""currentDeptId"":"""_currentDeptId_"""" 
	s result = result_",""mainDocCode"":"""_mainDocCode_""""
	s result = result_",""mainDocName"":"""_mainDocName_""""
	s result = result_",""cdssParam"":"_cdssParam_"" 
	s result = result_",""hospitalID"":"""_hospitalID_"""" 
	s result = result_",""hospitalName"":"""_hospitalName_"""" 
	s result = result_",""userName"":"""_userName_""""
	s result = result_",""episodeType"":"""_episodeType_""""
	s result = result_"}"
	q result
}

/// wangerpan
/// 2020-06-19
/// Desc:去掉姓名两端的空格。保证英文姓名可以正常显示。
/// debugger:
/// w ##class(EMRservice.Tools.Tool).Trim("  Code  And  Desc  ")
/// w ##class(EMRservice.Tools.Tool).Trim("  Code  And  Desc  ")
ClassMethod Trim(instr As %String, deli = " ") As %String
{
	Set rtn = ""
	Set start=0
	Set end=0
	Set len = $l(instr,deli)
	for i=1:1:len Quit:(start>0)  Set:($p(instr,deli,i)'="") start = i 
	for i=len:-1:1 Quit:end>0  Set:($p(instr,deli,i)'="") end = i
	Quit $p(instr,deli,start,end)
}

/// Creator:loo
/// CreatDate:2010-09-20
/// Description:根据起始日期、起始时间、时间间隔(以秒为单位)计算截止日期、截止时间
/// Table:EPRinstance.EPRActionAppoint
/// Input:startDate-起始日期,startTime-起始时间,timeSpan-时间间隔
/// Output:
/// Return:截止日期和截止时间,格式为:截止日期,截止时间
/// Others:
/// Debug: w ##class(EMRservice.Tools.Tool).GetEndDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetEndDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	//b "s"
	s curDate = (startTime+timeSpan)\86400
	if (curDate=0)
	{
		q startDate_","_(startTime+timeSpan)
	}
	else
	{
		s curTime = startTime+timeSpan-(curDate*86400)
		q startDate+curDate_","_curTime
	}
}

/// Creator:Donglulu
/// CreatDate:2020-08-26
/// Description:根据截止日期、截止时间、时间间隔(以秒为单位)计算起始日期、起始时间
/// Input:endDate-截止日期,endTime-截止时间,timeSpan-时间间隔
/// Output:
/// Return:起始日期和起始时间,格式为:起始日期,起始时间
/// Others:
/// Debug: w ##class(EMRservice.Tools.Tool).GetStartDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetStartDateTime(endDate As %Date, endTime As %Time, timeSpan As %Integer) As %String
{
	
	s result = ""
	q:(endDate = "")||(endTime = "")||(timeSpan = "") result
	
	s curDate = timeSpan\86400
	s value = endTime - (timeSpan - (curDate*86400)) 
	if (value < 0)
	{
		s startDate = endDate-curDate-1
		s startTime = 86400-(timeSpan - (curDate*86400) - endTime)
	}
	else
	{
		s startDate = endDate-curDate
		s startTime = endTime - (timeSpan - (curDate*86400))
	}
	
	s result = startDate_","_startTime
	q result
}

/// CreatDate:2021-07-1
/// Description:将HISUI系统日期或时间配置转为YYYY-MM-DD或HH:MM:SS格式
///             HISUI日期格式 1 MM/DD/YYYY、3 YYYY-MM-DD、4 DD/MM/YYYY
///             HISUI时间格式 1 HH:MM:SS、2 HH:MM、3 HH:MM:SSAM、4 HH:MMPM 
/// Input:   AType:[Date(日期),Time(时间)] 
///          ADateOrTimeValue:日期或时间     
/// Output:  result:转换YYYY-MM-DD或HH:MM:SS格式后日期或时间值
/// Debug:   w ##class(EMRservice.Tools.Tool).ChangeHISStandardDateTimeStyleToYMDorHMS("Date","09/06/2021")
///          w ##class(EMRservice.Tools.Tool).ChangeHISStandardDateTimeStyleToYMDorHMS("Time","23:09")
ClassMethod ChangeHISStandardDateTimeStyleToYMDorHMS(AType As %String, ADateOrTimeValue As %String) As %String
{
    s retvalue = ""
    q:(AType = "")||(ADateOrTimeValue = "") result
    s dateHtmlToLogical = ..GetDateTimeHtmlToLogical(AType,ADateOrTimeValue)
    if (AType = "Date"){
        s retvalue = $zd(dateHtmlToLogical,3)  
    }
    elseif(AType = "Time"){
        s retvalue = $zt(dateHtmlToLogical,1) 
    }
    q retvalue
}

/// Desc:      时间戳转换成日期时间
/// Creator:   Candyxu
/// CreateDate:2021-7-26
/// Input:     ATimestamp 时间戳
///           AType 时间戳类型  "ms" 毫秒   "s" 秒
/// Output:    cache日期时间
/// Debug:     w ##class(EMRservice.Tools.Tool).TimestampToDateTime(1621912296,"s")
ClassMethod TimestampToDateTime(ATimestamp, AType As %String = "")
{
	s timestamp = $g(ATimestamp)
	q:(timestamp = "") ""
	s:(AType = "ms") timestamp = timestamp \ 1000
	s datetime = timestamp + 4070937600
	s time = datetime # 86400
	s date = (datetime - time) / 86400
	s toDateTime = date _ "," _ time
	q toDateTime
}

/// Desc:      处理global错误的数据
/// Creator:   yejian
/// CreateDate:2022-3-30
/// Input:     
/// Output:    
/// Debug:     w ##class(EMRservice.Tools.Tool).mergeDatas()
ClassMethod mergeDatas()
{
	
	//转移日志
	MERGE ^DHCEMRI.RecordTransferLogD = ^EMRinstance.RecordTransferLogD
	MERGE ^DHCEMRI.RecordTransferLogD = ^EMRinstance.RecordTransferLogD
	//使用频率
	MERGE ^DHCEMRM.TemplateUseNumberD = ^EMRmeta.TemplateUseNumberD 
	MERGE ^DHCEMRM.TemplateUseNumberI = ^EMRmeta.TemplateUseNumberI 
	//权限脚本院区关联
	MERGE ^DHCEMRM.PrivRuleHospitalD = ^EMRmeta.PrivRuleHospitalD
	MERGE ^DHCEMRM.PrivRuleHospitalI = ^EMRmeta.PrivRuleHospitalI
	//病历展现配置日志
	MERGE ^DHCEMRM.EMRTemplateCLogD = ^EMRmeta.EMRTemplateCLogD
	MERGE ^DHCEMRM.EMRTemplateCLogI = ^EMRmeta.EMRTemplateCLogI
	//角色签名规则
	MERGE ^DHCEMRM.RoleSignRuleListI = ^EMRmeta.RoleSignRuleListI
	//牙面信息表
	MERGE ^DHCEMRM.ToothSurfaceItemI=^EMRmeta.ToothSurfaceItemI
}

}
