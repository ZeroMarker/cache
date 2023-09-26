Class web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：wangyaru
/// CreatDate：2018—10-30
/// Description：科室组织关联字典信息
/// Table：CT_DepartmentLocation
/// Input： 
/// Return：科室组织关联字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).GetCTDeptLinkOrg("1").Read()
ClassMethod GetCTDeptLinkOrg(Input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTDeptLinkOrgByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru	
/// CreatDate：2020-07-27
/// Description：查询HIS中科室组织关联字典信息
/// Table：CT_DepartmentLocation
/// Input： 科室组织关联字典
/// Return：科室组织关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).SendCTDeptLinkOrg("")
ClassMethod SendCTDeptLinkOrg(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	if Input'=""{
		if $d(^User.CTDepartmentLocationD(Input)){
			do plist.SetAt(Input,count)
		}
	}else{
		set rowid="0"  for  set rowid=$o(^User.CTDepartmentLocationD(rowid)) Quit:rowid=""  d
		.do plist.SetAt(rowid,count)
		.set count=count+1
	}
	
	set Instream=..GetCTDeptLinkOrgByID(plist)
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

/// Creator：wangyaru	
/// CreatDate：2020-07-27
/// Description：查询HIS中科室组织关联字典信息
/// Table：CT_DepartmentLocation
/// Input： 科室组织关联字典
/// Return：科室组织关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).GetCTDeptLinkOrgByID("")
ClassMethod GetCTDeptLinkOrgByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set linkInfo=$g(^User.CTDepartmentLocationD(rowid))
		set linkObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkOrg).%New()
		set linkObj.CTDLORowId=rowid
		
		set deptId=$lg(linkInfo,4)
		if deptId'=""{
			set deptCode=$p($g(^CTLOC(deptId)),"^",1)
			set linkObj.CTDLODeptCode=deptCode
		}
		set orgId=$lg(linkInfo,2)
		if orgId'=""{
			set orgCode=$lg(^User.CTDepartmentD(orgId),3)
			set linkObj.CTDLOOrgCode=orgCode
		}		
		set linkObj.CTDLOCodesystemCode="CT_DeptLinkOrg"
		set linkObj.CTDLORemarks="无"
		set linkObj.CTDLOStatus="1"
		set StartDate=$lg(linkInfo,11)
		set linkObj.CTDLOStartDate=StartDate
		set CTDLOEndDate=$lg(linkInfo,12)
		set linkObj.CTDLOEndDate=CTDLOEndDate
		set linkObj.CTDLOUpdateDate=+$h
		set linkObj.CTDLOUpdateTime=$zt($p($h,",",2),1)
		set linkObj.CTDLOUpdateUserCode="admin"
		d ListInfo.CTDeptLinkOrg.Insert(linkObj)
		b ;-9
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptLinkOrg",.Jsonobj)
	b ;00
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptLinkOrg",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou	
/// CreatDate：2018-06-04
/// Description：查询HIS中科室组织关联字典信息
/// Table：pac_bed
/// Input： 科室组织关联字典
/// Return：科室组织关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).CTDeptLinkOrg("")
ClassMethod CTDeptLinkOrg(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set linkInfo=$g(^User.CTDepartmentLocationD(input))
	set linkObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkOrg).%New()
	set linkObj.CTDLORowId=input		
	set deptId=$lg(linkInfo,4)
	if deptId'=""{
		set deptCode=$p($g(^CTLOC(deptId)),"^",1)
		set linkObj.CTDLODeptCode=deptCode
	}
	set orgId=$lg(linkInfo,2)
	if orgId'=""{
		set orgCode=$lg($g(^User.CTDepartmentD(orgId),3))
		set linkObj.CTDLOOrgCode=orgCode
	}
	set linkObj.CTDLOCodesystemCode="CT_DeptLinkOrg"
	set linkObj.CTDLORemarks="无"
	set linkObj.CTDLOStatus="1"
	set StartDate=$lg(linkInfo,11)
	set linkObj.CTDLOStartDate=StartDate
	
	set CTDLOEndDate=$lg(linkInfo,12)
	set linkObj.CTDLOEndDate=CTDLOEndDate
	
	set linkObj.CTDLOUpdateUserCode="admin"
	set linkObj.CTDLOUpdateDate=+$h
	set linkObj.CTDLOUpdateTime=$zt($p($h,",",2),1)
	d ListInfo.CTDeptLinkOrg.Insert(linkObj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptLinkOrg",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptLinkOrg",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
	
	
MsgErr
	quit "-1^"_$ze
}

}
