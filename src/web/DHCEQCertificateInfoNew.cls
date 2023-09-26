Import SQLUser

Class web.DHCEQCertificateInfoNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:Mozy 2013-12-11
/// 描述:新增,更新,删除数据记录
/// w ##class(web.DHCEQCertificateInfo).SaveData("^机构名称1^代理资质1^地址1^电话1^传真1^联系人1^^","1^2^3^4^5","2")
/// modified by czf 2021-11-05 可添加重复数据修改
ClassMethod SaveData(val As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,rowid,Rowid,No
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set rowid=$Piece(val,"^",1)
	If (+OperateType=1)
	{
	 	&SQL(Update sqluser.DHC_EQCertificateInfo Set CI_InvalidFlag='Y' where CI_RowID=:rowid)
	 	If SQLCODE
		{
			Quit SQLCODE
		}
	 	
	 	Quit rowid
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	Set PLIST(2)=	$Piece(val,"^",2)	// CI_SourceType		2
		Set PLIST(3)=	$Piece(val,"^",3)	// CI_SourceID			3
		Set PLIST(4)=	$Piece(val,"^",4)	// CI_CertificateTypeDR	4
		Set PLIST(5)=	$Piece(val,"^",5)	// CI_No				5
		Set PLIST(6)=	$Piece(val,"^",6)	// CI_Level				6
		Set PLIST(7)=	$Piece(val,"^",7)	// CI_CertificateDept	7
		Set PLIST(8)=	$Piece(val,"^",8)	// CI_CertificateDate	8
		If PLIST(8)'="" Set PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",8),"date")
		Set PLIST(9)=	$Piece(val,"^",9)	// CI_AvailableDate		9
		If PLIST(9)'="" Set PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",9),"date")
		Set PLIST(10)=	$Piece(val,"^",10)	// CI_Remark			10
		Set PLIST(11)=	"N"					// CI_InvalidFlag		11
		Set PLIST(12)=	User				// CI_UpdateUserDR		12
		Set PLIST(13)=	updDate				// CI_UpdateDate		13
		Set PLIST(14)=	updTime				// CI_UpdateTime		14
		Set PLIST(15)=	$Piece(val,"^",11)	// CI_Hold1
		Set PLIST(16)=	$Piece(val,"^",12)	// CI_Hold2
		Set PLIST(17)=	$Piece(val,"^",13)	// CI_Hold3
		Set PLIST(18)=	$Piece(val,"^",14)	// CI_Hold4
		Set PLIST(19)=	$Piece(val,"^",15)	// CI_Hold5
		
		s tmpid=""
		
		&SQL(Select CI_RowID into :tmpid From sqluser.DHC_EQCertificateInfo where CI_SourceType=:PLIST(2) and CI_SourceID=:PLIST(3) 
		and CI_CertificateTypeDR=:PLIST(4) and CI_No=:PLIST(5) and CI_InvalidFlag='N')
		i SQLCODE=100 s tmpid="",SQLCODE=0
	 	If (rowid="")  //新增按钮操作
	 	{
		 	i tmpid'="" q -3003
		 	&SQL(Insert Into sqluser.DHC_EQCertificateInfo Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
		 	i (tmpid'="")&&(tmpid'=rowid) q -3003
			&SQL(Update sqluser.DHC_EQCertificateInfo Values :PLIST() where CI_RowID = :rowid)
	 	}
	 	If SQLCODE
		{
			Quit SQLCODE
		}
		Set rowid=$Get(%ROWID)
		
	 	Quit rowid
 	}
}

/// modified by czf 需求号：335873
/// modified by czf 399195 入参中增加SourceType，修改query，增加出参TRow
/// modified by czf 20181101 下拉列表查询条件不起作用,修改Level为LevelID
/// d ##class(%ResultSet).RunQuery("web.DHCEQCertificateInfoNew","GetCertificateInfoList")
Query GetCertificateInfoList(SourceID, SourceDesc As %String = "", CertificateType As %String = "", No As %String = "", LevelID As %String = "", CertificateDept As %String = "", CertificateDate As %String = "", AvailableDate As %String = "", Remark As %String = "", SourceType) As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TSourceDesc:%String,TCertificateTypeDR:%String,TCertificateType:%String,TNo:%String,TLevel:%String,TCertificateDept:%String,TCertificateDate:%String,TAvailableDate:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetCertificateInfoListExecute(ByRef qHandle As %Binary, SourceID, SourceDesc As %String = "", CertificateType As %String = "", No As %String = "", LevelID As %String = "", CertificateDept As %String = "", CertificateDate As %String = "", AvailableDate As %String = "", Remark As %String = "", SourceType) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=1
	i (SourceType="")&&(SourceID="") Quit $$$OK
	//hisui改造 add by czf 20181027
	If CertificateDate '="" Set CertificateDate = ##class(web.DHCEQCommon).TransValueFromPage(CertificateDate,"date")
	If AvailableDate '="" Set AvailableDate = ##class(web.DHCEQCommon).TransValueFromPage(AvailableDate,"date")
	
	Set rowid=0
 	For  Set rowid=$O(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID,rowid)) Quit:(rowid="")  Do
	.Do ResetVariablesGetCertificateInfoList
	.Set TInvalidFlag = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",10) //无效标志
	.Quit:(TInvalidFlag'="N") 
	.Set TRowID = rowid
	.Set TSourceType = SourceType
	.Set TSourceID = SourceID
	.i TSourceType=2 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)
	.i TSourceType=3 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TSourceID)
	.i TSourceType=5 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)		// modified by czf 20200404 begin
	.q:(SourceDesc'="")&(TSourceDesc'[SourceDesc)
	.Set TSourceType = $CASE(TSourceType,"1":"人员","2":"供应商","3":"生产厂商","4":"计量证书","5":"公司",:"没有定义")	// modified by czf 2020-12-16 1493492
	.Set TCertificateTypeDR = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",3)
	.Set TCertificateType = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",TCertificateTypeDR)),"^",2)
	.q:(CertificateType'="")&(CertificateType'=TCertificateType)
	.Set TNo = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",4)
	.q:(No'="")&(No'=TNo)
	.Set TLevel = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",5)
	.q:(LevelID'="")&(LevelID'=TLevel)
	.Set TLevel = $CASE(TLevel,"1":"初级","2":"中级","3":"高级","4":"其他",:"")
	.Set TCertificateDept = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",6)
	.q:(CertificateDept'="")&(CertificateDept'=TCertificateDept)
	.Set TCertificateDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",7)
	.q:(CertificateDate'="")&(CertificateDate'=TCertificateDate)
	.If TCertificateDate '="" Set TCertificateDate = ##class(web.DHCEQCommon).TransValueToPage(TCertificateDate,"date")
	.Set TAvailableDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",8)
	.q:(AvailableDate'="")&(AvailableDate'=TAvailableDate)
	.If TAvailableDate '="" Set TAvailableDate = ##class(web.DHCEQCommon).TransValueToPage(TAvailableDate,"date")
	.Set TRemark = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",9)
	.q:(Remark'="")&(Remark'=TRemark)
	.Set THold1 = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",14)
	.Set THold2 = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",15)
	.Set THold3 = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",16)
	.Set THold4 = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",17)
	.Set THold5 = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",18)
	.Do OutputRowGetCertificateInfoList
	Quit $$$OK
OutputRowGetCertificateInfoList
	Set Data=$lb(TRowID,TSourceType,TSourceID,TSourceDesc,TCertificateTypeDR,TCertificateType,TNo,TLevel,TCertificateDept,TCertificateDate,TAvailableDate,TRemark,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesGetCertificateInfoList
	Set (TRowID,TSourceDesc,TCertificateTypeDR,TCertificateType,TNo,TLevel,TCertificateDept,TCertificateDate,TAvailableDate,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetCertificateInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCertificateInfoListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCertificateInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCertificateInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SourceTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;w "<option value=></option>"
	w "<option value=1>人员</option>"
	;w "<option value=2>供应商</option>"
	;w "<option value=3>生产厂商</option>"
	;w "<option value=4>计量证书</option>"	// modified by czf 2020-12-16 1493492
	w "<option value=5>公司</option>"		//modified by czf 20200404
	w "</select>",!
}

ClassMethod LevelList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>初级</option>"
	w "<option value=2>中级</option>"
	w "<option value=3>高级</option>"
	w "<option value=4>其他</option>"
	w "</select>",!
}

/// w ##Class(web.DHCEQCertificateInfo).GetOneCertificateInfo("1")
ClassMethod GetOneCertificateInfo(rowid)
{
	new (rowid)
	Set (result,resultex)=""
	Set result= ^DHCEQCertificateInfo(rowid)
	
	Set resultex=resultex_"^"	;SourceDesc
	If $Piece(result,"^",2)'="" Do
	.If $Piece(result,"^",1)=1 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",2))
	.If $Piece(result,"^",1)=2 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))
	.If $Piece(result,"^",1)=3 Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",$Piece(result,"^",2))),"^",1)		//modify by mwz 需求号396012 2017-07-17
	.If $Piece(result,"^",1)=5 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))		//modified by czf 20200404
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQCCode("DHCEQCCertificateType",$Piece(result,"^",3))),"^",2)
	Set $Piece(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"date")
	Set $Piece(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",8),"date")
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

Query GetCertificateType() As %Query(ROWSPEC = "CertificateType:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod GetCertificateTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCCertificateType",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetCertificateType
	.Set TInvalidFlag = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",rowid)),"^",4) //无效标志
	.Quit:(TInvalidFlag'="N") 
	.Set ID = rowid
	.Set Code = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",rowid)),"^",1)
	.Set CertificateType = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",rowid)),"^",2)
	.Do OutputRowGetCertificateType
	Quit $$$OK
OutputRowGetCertificateType
	Set Data=$lb(CertificateType,ID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetCertificateType
	Set (CertificateType,ID,Code)=""
	Quit
}

ClassMethod GetCertificateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCertificateTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCertificateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCertificateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
