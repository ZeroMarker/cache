Import sqluser

Class web.DHCSTMHUI.InvInfo Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存发票信息
/// 对象类型数据
ClassMethod jsSave(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Params)
	q RtnObj.Json()
}

/// Descript:   保存发票信息
/// Creater:    tsr
/// CreateDate: 2019-10-10
/// Table:		DHC_InvInfo
/// Input:		发票信息
ClassMethod Save(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s RowId=PJObj.%Get("RowId")
	s Vendor=PJObj.%Get("Vendor")
	s InvCode=PJObj.%Get("InvCode")
	s InvNo=PJObj.%Get("InvNo")
	s InvAmt=PJObj.%Get("InvAmt")
	s InvDate=PJObj.%Get("InvDate")
	s CreateUser=PJObj.%Get("gUserId")
	i Vendor="" d RtnObj.Err(-2,"","供应商不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i InvCode="" d RtnObj.Err(-2,"","发票代码不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i InvNo="" d RtnObj.Err(-2,"","发票号不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i InvAmt="" d RtnObj.Err(-2,"","发票金额不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s InvDate=..DH2L(InvDate)
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)

	i RowId="" d
	.&sql(Insert into DHC_VendorInv(INV_InvCode,INV_InvNo,INV_APCVM_DR,INV_InvRpAmt,INV_InvDate,INV_CreateUser,INV_CreateDate,INV_CreateTime)
		values(:InvCode,:InvNo,:Vendor,:InvAmt,:InvDate,:CreateUser,:CreateDate,:CreateTime))
	.i SQLCODE'=0 d RtnObj.Err(-3,"",InvNo_"保存失败!"_SQLCODE)
	.q:RtnObj.success'=0
	.s RowId=$p(%ROWID,$c(1))
	e  d
	.&sql(update DHC_VendorInv set INV_InvCode=:InvCode,INV_InvNo=:InvNo,INV_APCVM_DR=:Vendor,INV_InvRpAmt=:InvAmt,
		INV_InvDate=:InvDate,INV_CreateUser=:CreateUser,INV_CreateDate=:CreateDate,INV_CreateTime=:CreateTime
		where INV_RowId=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-4,RowId,InvNo_"保存失败!"_SQLCODE)
	.q:RtnObj.success'=0
	i RtnObj.success'=0 q RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	查询发票信息
/// Creator: 	tsr
/// CreatDate: 	2019-10-10
/// Table: 		DHC_InvInfo
/// Input: 		Params对象
Query GetInvInfo(Params As %String) As Query(ROWSPEC = "RowId,InvCode,InvNo,VendorId,VendorDesc,InvAmt:%Float,InvDate,CreateUserId,CreateUserName,CreateDate,CreateTime,CheckFlag") [ SqlProc ]
{
}

ClassMethod GetInvInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pVendor=PJObj.%Get("Vendor")
	s pInvCode=PJObj.%Get("InvCode")
	s pInvNo=PJObj.%Get("InvNo")
	s SqlStr="SELECT INV_RowId, INV_InvCode, INV_InvNo, INV_APCVM_DR,"
		_"INV_InvRpAmt, INV_InvDate, INV_CreateUser, INV_CreateDate, INV_CreateTime,"
		_"INV_UserCompleted "
		_" FROM DHC_VendorInv"
		_" WHERE 1=1"
	i pVendor'="" d
	.s SqlStr=SqlStr_" AND INV_APCVM_DR ="_pVendor
	i pInvCode'="" d
	.s SqlStr=SqlStr_" AND INV_InvCode LIKE '%"_pInvCode_"%'"
	i pInvNo'="" d
	.s SqlStr=SqlStr_" AND INV_InvNo LIKE '%"_pInvNo_"%'"
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("INV_RowId")
		s InvCode = result.Data("INV_InvCode")
		s InvNo = result.Data("INV_InvNo")
		s VendorId = result.Data("INV_APCVM_DR")
		s InvAmt = result.Data("INV_InvRpAmt")
		s InvDate = result.Data("INV_InvDate")
		s CreateUserId = result.Data("INV_CreateUser")
		s CreateDate = result.Data("INV_CreateDate")
		s CreateTime = result.Data("INV_CreateTime")
		s CheckFlag = result.Data("INV_UserCompleted")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s (VendorDesc,CreateUserName)=""
		s:VendorId'="" VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
		s:CreateUserId'="" CreateUserName=$p(^SSU("SSUSR",CreateUserId),"^",2)
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,InvCode,InvNo,VendorId,VendorDesc,InvAmt,InvDate,CreateUserId,CreateUserName,CreateDate,CreateTime,CheckFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询发票明细
/// Creator:	tsr
/// CreatDate:	2019-10-10
/// Table:		DHC_InvInfo
/// Input:		发票RowId
ClassMethod Select(RowId As %String) As %Library.String
{
	n (RowId)
	q:RowId="" ""

	s InvCode=$p(^DHCVendorInv(RowId),"^",16)
	s InvNo=$p(^DHCVendorInv(RowId),"^",10)
	s VendorId=$p(^DHCVendorInv(RowId),"^",2)
	s VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	s Vendor=..sssComboStr(VendorId,VendorDesc)
	s InvAmt=$p(^DHCVendorInv(RowId),"^",13)
	s InvDate=$p(^DHCVendorInv(RowId),"^",15)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	s Data=RowId_"^"_InvCode_"^"_InvNo_"^"_Vendor_"^"_InvAmt_"^"_InvDate
	s Title="RowId^InvCode^InvNo^Vendor^InvAmt^InvDate"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Result
}

}
