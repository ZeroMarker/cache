Import sqluser

/// Description:人员相关处理
/// CreateDate:	20201106
Class web.DHCSTMHUI.DHCPersonDetail Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询人员信息
/// Creator:	lxt
/// CreateDate:	2020-11-06
/// Table:		DHC_PersonDetail
/// Input:		类型，查询条件
/// Return：	人员信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPersonDetail","QueryPersonDetail",^templxt("QueryPersonDetail"))
Query QueryPersonDetail(Params As %String) As Query(ROWSPEC = "RowId,OrgId,OrgType,PersonType,PersonTypeDesc,PersonName,PersonCard,PersonCarrTel,PersonTel,PersonEmail,PersonFax,PersonStartDate,PersonEndDate,PersonShowFlag") [ SqlProc ]
{
}

ClassMethod QueryPersonDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pOrgType=PJObj.%Get("OrgType")	//Vendor,Manf
	s pOrgId=PJObj.%Get("OrgId")		//VendorId,ManfId
	q:pOrgType="" $$$OK
	q:pOrgId="" $$$OK

	s SqlStr = "SELECT ID AS RowId,PERD_OrgId As OrgId,PERD_OrgType As OrgType,PERD_Type As PersonType,"
		_"PERD_TypeDesc As PersonTypeDesc,PERD_Name As PersonName,PERD_Card As PersonCard,PERD_CarrTel As PersonCarrTel,PERD_Tel As PersonTel,"
		_"PERD_Email As PersonEmail,PERD_Fax As PersonFax,PERD_StartDate As PersonStartDate,PERD_EndDate As PersonEndDate,PERD_ShowFlag As PersonShowFlag "
 		_"FROM DHC_PersonDetail where PERD_OrgId="_pOrgId_" and PERD_OrgType='"_pOrgType_"' order by RowId desc"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s OrgId = Result.Data("OrgId")
		s OrgType = Result.Data("OrgType")
		s PersonType=Result.Data("PersonType")
		s PersonTypeDesc=Result.Data("PersonTypeDesc")
		s PersonName=Result.Data("PersonName")
		s PersonCard=Result.Data("PersonCard")
		s PersonCarrTel=Result.Data("PersonCarrTel")
		s PersonTel=Result.Data("PersonTel")
		s PersonEmail=Result.Data("PersonEmail")
		s PersonFax=Result.Data("PersonFax")
		s PersonStartDate=Result.Data("PersonStartDate")
		s PersonEndDate=Result.Data("PersonEndDate")
		s PersonShowFlag=Result.Data("PersonShowFlag")
		
		i PersonShowFlag="" s PersonShowFlag="N"
		s PersonStartDate=..DL2H(PersonStartDate)
		s PersonEndDate=..DL2H(PersonEndDate)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,OrgId,OrgType,PersonType,PersonTypeDesc,PersonName,PersonCard,PersonCarrTel,
	PersonTel,PersonEmail,PersonFax,PersonStartDate,PersonEndDate,PersonShowFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	新增资质
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCPersonDetail).jsSave(^templxt("save1"),^templxt("save2"))
ClassMethod jsSavePersonDetail(OrgType As %String, OrgId As %String, Params As %String) As %String
{
	n (OrgType,OrgId,Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SavePersonDetail(OrgType,OrgId,Params)
	q RtnObj.Json()
}

/// w ##class(web.DHCSTMHUI.DHCPersonDetail).SavePersonDetail()
ClassMethod SavePersonDetail(OrgType, OrgId, Params) As RtnObj
{
	n (OrgType,OrgId,Params)
	s ^templxt("1111111")=$lb(OrgType,OrgId,Params)
	s RtnObj=##class(RtnObj).%New()
	i (OrgType="")||(OrgId="") q RtnObj.Err(-1,"","入参必填项错误!","",0)
	
	s PERDObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PERDObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
	
	s PersonRowId=PERDObj.%Get("PersonRowId")
	s PersonType=PERDObj.%Get("PersonType")
	s PersonTypeDesc=PERDObj.%Get("PersonTypeDesc")
	s PersonName=PERDObj.%Get("PersonName")
	s PersonCard=PERDObj.%Get("PersonCard")
	s PersonCarrTel=PERDObj.%Get("PersonCarrTel")
	s PersonTel=PERDObj.%Get("PersonTel")
	s PersonEmail=PERDObj.%Get("PersonEmail")
	s PersonFax=PERDObj.%Get("PersonFax")
	s PersonStartDate=PERDObj.%Get("PersonStartDate")
	s PersonEndDate=PERDObj.%Get("PersonEndDate")
	s PersonShowFlag=PERDObj.%Get("PersonShowFlag")
	s PersonStartDate=..DH2L(PersonStartDate)
	s PersonEndDate=..DH2L(PersonEndDate)
	
	q:((PersonRowId="")&&(PersonType="")) RtnObj.Err(-3,"","缺少人员类型！","",0)
	
	i PersonRowId="" d
	.s Obj=##class(User.DHCPersonDetail).%New()
	.s Obj.PERDOrgType=OrgType
	.s Obj.PERDOrgId=OrgId
	.s Obj.PERDType=PersonType
	.s Obj.PERDTypeDesc=PersonTypeDesc
	e  d
	.s Obj=##class(User.DHCPersonDetail).%OpenId(PersonRowId)
	s Obj.PERDName=PersonName
	s Obj.PERDCard=PersonCard
	s Obj.PERDCarrTel=PersonCarrTel
	s Obj.PERDTel=PersonTel
	s Obj.PERDEmail=PersonEmail
	s Obj.PERDFax=PersonFax
	s Obj.PERDStartDate=PersonStartDate
	s Obj.PERDEndDate=PersonEndDate
	s Obj.PERDShowFlag=PersonShowFlag
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-10,"","人员信息保存失败!")
	s PersonRowId=Obj.%Id()
	s RtnObj.rowid=PersonRowId
	
	s FileData=OrgType_"^"_OrgId_"^"_"Person"_"^"_PersonType_"^"_PersonRowId_"^"_PersonShowFlag
	s FileTitle="OrgType^OrgId^GrpType^PointerType^Pointer^ActiveFlag"
	s FileObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(FileData,FileTitle)
	s RtnObj=##class(web.DHCSTMHUI.UpLoadPic).UpdateFileActiveFlag(FileObj)
		
	q RtnObj
}

/// Descript:	查询人员信息
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_PersonDetail
/// Input:		人员id
/// Return：	人员信息
/// w ##class(web.DHCSTMHUI.DHCPersonDetail).Select(1)
ClassMethod Select(PersonId As %String) As %String
{
	n (PersonId)
	s ^templxt("PersonSelect")=PersonId
	q:+PersonId=0 ""
	b ;1
	s PersonDetail=^User.DHCPersonDetailD(PersonId)
	s PersonRowId=PersonId
	s PersonName=$lg(PersonDetail,6)
	s PersonCard=$lg(PersonDetail,7)
	s PersonCarrTel=$lg(PersonDetail,8)
	s PersonTel=$lg(PersonDetail,9)
	s PersonEmail=$lg(PersonDetail,10)
	s PersonFax=$lg(PersonDetail,11)
	s PersonStartDate=$lg(PersonDetail,12)
	s PersonEndDate=$lg(PersonDetail,13)
	s PersonShowFlag=$lg(PersonDetail,14)
	
	s PersonStartDate=..DL2H(PersonStartDate)
	s PersonEndDate=..DL2H(PersonEndDate)
	
	s Data=PersonRowId_"^"_PersonName_"^"_PersonCard_"^"_PersonCarrTel_"^"_PersonTel_"^"_PersonEmail
	_"^"_PersonFax_"^"_PersonStartDate_"^"_PersonEndDate_"^"_PersonShowFlag

	s Title="PersonRowId^PersonName^PersonCard^PersonCarrTel^PersonTel^PersonEmail"
	_"^PersonFax^PersonStartDate^PersonEndDate^PersonShowFlag"

	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

}
