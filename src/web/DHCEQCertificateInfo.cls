Import SQLUser

Class web.DHCEQCertificateInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:Mozy 2013-12-11
/// 描述:新增,更新,删除数据记录
/// w ##class(web.DHCEQCertificateInfo).SaveData("^机构名称1^代理资质1^地址1^电话1^传真1^联系人1^^","1^2^3^4^5","2")
ClassMethod SaveData(val As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,rowid,Rowid,No
	Set $ZT="ERRORSaveData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set rowid=$Piece(val,"^",1)
	If (+OperateType=1)
	{
		TStart
	 	&SQL(Update sqluser.DHC_EQCertificateInfo Set CI_InvalidFlag='Y' where CI_RowID=:rowid)
	 	If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	 	
	 	TCOMMIT
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
		
		TStart
	 	If (rowid="")  //新增按钮操作
	 	{
		 	&SQL(Insert Into SQLUSER.sqluser.DHC_EQCertificateInfo Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
			&SQL(Update SQLUSER.sqluser.DHC_EQCertificateInfo Values :PLIST() where CI_RowID = :rowid)
	 	}
	 	If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set rowid=$Get(%ROWID)
		
	 	TCOMMIT
	 	Quit rowid
 	}
 	
ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSaveData"_ErrorMsg     	//返回错误消息
}

/// modified by czf  需求号：325590
/// d ##class(%ResultSet).RunQuery("web.DHCEQCertificateInfo","GetCertificateInfoList")
/// modified by czf 20181101 下拉列表查询条件不起作用,修改Level为LevelID,SourceType为SourceTypeID
Query GetCertificateInfoList(SourceTypeID As %String = "", SourceDesc As %String = "", CertificateType As %String = "", No As %String = "", LevelID As %String = "", CertificateDept As %String = "", CertificateDate As %String = "", AvailableDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TSourceDesc:%String,TCertificateTypeDR:%String,TCertificateType:%String,TNo:%String,TLevel:%String,TCertificateDept:%String,TCertificateDate:%String,TAvailableDate:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetCertificateInfoListExecute(ByRef qHandle As %Binary, SourceTypeID As %String = "", SourceDesc As %String = "", CertificateType As %String = "", No As %String = "", LevelID As %String = "", CertificateDept As %String = "", CertificateDate As %String = "", AvailableDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	//hisui改造 add by lmm 2018-08-17 begin
	If CertificateDate '="" Set CertificateDate = ##class(web.DHCEQCommon).TransValueFromPage(CertificateDate,"date")
	If AvailableDate '="" Set AvailableDate = ##class(web.DHCEQCommon).TransValueFromPage(AvailableDate,"date")
	//hisui改造 add by lmm 2018-08-17 end
	
	s TRow=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCertificateInfo(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetCertificateInfoList
	.Set TInvalidFlag = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",10) //无效标志
	.Quit:(TInvalidFlag'="N") 
	.Set TRowID = rowid
	.Set TSourceType = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",1)
	.q:(SourceTypeID'="")&&(TSourceType'=SourceTypeID)
	.Set TSourceID = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",2)
	.q:TSourceID=""		//modified by czf 20181120
	.;过滤无效供应商,生产厂商 add by wy 2017-06-03
	.q:(((TSourceType=2)||(TSourceType=3)||(TSourceType=5))&&($P($g(^DHCEQCCode("DHCEQCVendor",TSourceID)),"^",19)="Y"))		// modified by CZF0093 2020-03-17 //modified by czf 20200404 begin
	.;q:((TSourceType=3)&&($P($g(^DHCEQCCode("DHCEQCManufacturer",TSourceID)),"^",10)="Y"))
	.If TSourceID'="" Do
	..If TSourceType=1 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceID)
	..If TSourceType=2 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)
	..If TSourceType=3 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TSourceID)		//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TSourceID)),"^",1) modified by CZF0093 2020-03-17
	..If TSourceType=5 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)	
	.q:(SourceDesc'="")&&(TSourceDesc'[SourceDesc)
	.Set TSourceType = $CASE(TSourceType,"1":"人员","2":"供应商","3":"生产厂商","4":"计量证书","5":"公司",:"没有定义")	// modified by czf 2020-12-16 1493492		//modified by czf 20201216
	.Set TCertificateTypeDR = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",3)
	.i TCertificateTypeDR'="" Set TCertificateType = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",TCertificateTypeDR)),"^",2)
	.q:(CertificateType'="")&&(TCertificateType'=CertificateType)
	.Set TNo = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",4)
	.q:(No'="")&&(TNo'=No)
	.Set TLevel = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",5)
	.q:(LevelID'="")&&(TLevel'=LevelID)
	.Set TLevel = $CASE(TLevel,"1":"初级","2":"中级","3":"高级","4":"其他",:"")
	.Set TCertificateDept = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",6)
	.q:(CertificateDept'="")&&(TCertificateDept'=CertificateDept)
	.Set TCertificateDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",7)
	.q:(CertificateDate'="")&&(CertificateDate'=TCertificateDate)
	.If TCertificateDate '="" Set TCertificateDate = ##class(web.DHCEQCommon).TransValueToPage(TCertificateDate,"date")
	.Set TAvailableDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",8)
	.q:(AvailableDate'="")&&(AvailableDate'=TAvailableDate)
	.If TAvailableDate '="" Set TAvailableDate = ##class(web.DHCEQCommon).TransValueToPage(TAvailableDate,"date")
	.Set TRemark = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",9)
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
	s TRow=TRow+1
	Quit
ResetVariablesGetCertificateInfoList
	Set (TRowID,TSourceType,TSourceID,TSourceDesc,TCertificateTypeDR,TCertificateType,TNo,TLevel,TCertificateDept,TCertificateDate,TAvailableDate,TRemark,THold1,THold2,THold3,THold4,THold5)=""
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
	;w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
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
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
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
	If $Piece(result,"^",2)'="" Do             //modified by czf 需求号：335257
	.If $Piece(result,"^",1)=1 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",2))
	.If $Piece(result,"^",1)=2 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))
	.If $Piece(result,"^",1)=3 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece(result,"^",2))	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",$Piece(result,"^",2))),"^",1) modified by CZF0093 2020-03-17
	.If $Piece(result,"^",1)=5 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))		//modified by czf 20200404
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQCCode("DHCEQCCertificateType",$Piece(result,"^",3))),"^",2)
	Set $Piece(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"date")
	Set $Piece(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",8),"date")
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

// Add by HHM 2016-04-07 移动端获取计量信息

// w ##class(web.DHCEQCertificateInfo).GetInfoByMobile(3)

ClassMethod GetInfoByMobile(SoureID)
{
	s result=""
	s rowid=$o(^DHCEQCertificateInfo(0,"Source",4,SoureID,""))
	i rowid="" s result="^^^^^^"
	e  d
	.q:$p($g(^DHCEQCertificateInfo(rowid)),"^",10)="Y"
	.s No=$p($g(^DHCEQCertificateInfo(rowid)),"^",4)
	.s AvailableDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCertificateInfo(rowid)),"^",8),"date")  ;
	.s MeasureDept=""
	.s MeasureDeptDR=$p($g(^DHCEQMaint(SoureID)),"^",31)
	.i MeasureDeptDR'="" s MeasureDept=$p($g(^DHCEQCCode("DHCEQCMeasureDept",MeasureDeptDR)),"^",1)
	.s MeasureMan=$p($g(^DHCEQMaint(SoureID)),"^",32)
	.s MeasureTe=$p($g(^DHCEQMaint(SoureID)),"^",33)
	.s MeasureUsers=$p($g(^DHCEQMaint(SoureID)),"^",34)
	.s result=No_"^"_AvailableDate_"^"_MeasureDept_"^"_MeasureMan_"^"_MeasureTe_"^"_MeasureUsers
	q result
}

Query GetCertificateType() As %Query(ROWSPEC = "CertificateType:%String:证件类型,HIDDEN:%String,Code:%String:编码")
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
