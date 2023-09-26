Class web.DHCEQPCContactPerson Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:yh 2019-11-20
/// 描述:新增,更新,删除数据记录
/// w ##class(web.DHCEQPCContactPerson).SaveData("^5^612^^高工^^^17878797656^^^^^^^^^^^^^^^^^","0")
/// modified by wy 2021-6-2 修改人员维护的保存方法 WY0094
ClassMethod SaveData(val As %Library.String = "", OperateType As %Library.String = "")
{
	Set rowid=$Piece(val,"^",1)
	s SQLCODE=0
	If (+OperateType=1)
	{	
	 	&SQL(Update SQLUSER.DHC_EQPCContactPerson Set CI_InvalidFlag='Y' where CI_RowID=:rowid)
	 	i SQLCODE q SQLCODE
	 	Quit rowid
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	Set PLIST(2)=$Piece(val,"^",2)	
		Set PLIST(3)=$Piece(val,"^",3)	
		Set PLIST(4)=$Piece(val,"^",4)	
		Set PLIST(5)=$Piece(val,"^",5)	
		Set PLIST(6)=$Piece(val,"^",6)	
		Set PLIST(7)=$Piece(val,"^",7)
		Set PLIST(8)=$Piece(val,"^",8)	
		Set PLIST(9)=$Piece(val,"^",9)	
		Set PLIST(10)=$Piece(val,"^",10)	
		Set PLIST(11)=$Piece(val,"^",11)
		Set PLIST(12)=$Piece(val,"^",12)	
		Set PLIST(13)=$Piece(val,"^",13)	
		Set PLIST(14)=$Piece(val,"^",14)	
		Set PLIST(15)=$Piece(val,"^",15)
		Set PLIST(16)=$Piece(val,"^",16)	
		Set PLIST(17)=$Piece(val,"^",17)	
		Set PLIST(18)=$Piece(val,"^",18)	
		If PLIST(18)'="" Set PLIST(18) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",18),"date")
		Set PLIST(19)=$Piece(val,"^",19)	
		If PLIST(19)'="" Set PLIST(19) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",19),"date")
		Set PLIST(20)="N"					
		Set PLIST(21)=$Piece(val,"^",21)	
		Set PLIST(22)=$Piece(val,"^",22)	
		Set PLIST(23)=$Piece(val,"^",23)	
		Set PLIST(24)=$Piece(val,"^",24)	
		Set PLIST(25)=$Piece(val,"^",25)
		//Modified By QW20210702 BUG:QW0134 begin
		s Rowid=""
	  	&SQL(select CI_RowID into :Rowid from SQLUSER.DHC_EQPCContactPerson where CI_SourceType=:PLIST(2) and CI_SourceID=:PLIST(3)  and CI_Name=:PLIST(5)  and CI_InvalidFlag='N')
		if (rowid="")
		{
		  	if (Rowid'="")  q -3003 //重复的记录
		  	&SQL(Insert Into SQLUSER.DHC_EQPCContactPerson Values :PLIST())
		}else{
			if (Rowid'=rowid)  q -3003 //重复的记录
			&SQL(Update SQLUSER.DHC_EQPCContactPerson Values :PLIST() where CI_RowID = :rowid)
		}
		//Modified By QW20210702 BUG:QW0134 end
		i SQLCODE q SQLCODE
		Set rowid=$Get(%ROWID)
		Quit rowid
   	}
}

/// 创建:yh 2019-11-20
/// 描述:遍历输出联系人
/// d ##class(%ResultSet).RunQuery("web.DHCEQPCContactPerson","GetPCContactPersonInfoList")
/// modified by CZF0095 增加入参SourceFlag,SourceID, 
/// modified by CZF 2020-04-26  增加入参OtherContact
Query GetPCContactPersonInfoList(SourceTypeID As %String = "", SourceDesc As %String = "", TypeID As %String = "", Name As %String = "", Role As %String = "", Sex As %String = "", MobilePhone As %String = "", OfficePhone As %String = "", Email As %String = "", Fax As %String = "", Address As %String = "", Area As %String = "", FromDate As %String = "", ToDate As %String = "", QQ As %String = "", WeChat As %String = "", Remark As %String = "", SourceFlag As %String = "", SourceID As %String = "", OtherContact As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TSourceType:%String ,TSourceID,TSourceDesc:%String ,TType:%String ,TName:%String ,TRole:%String ,TSex:%String ,TMobilePhone:%String ,TOfficePhone:%String ,TEmail:%String ,TFax:%String ,TQQ:%String ,TWeChat:%String ,TOtherContact:%String ,TAddress:%String ,TArea:%String ,TRemark:%String,TFromDate:%String ,TToDate:%String ,TInvalidFlag:%String ,THold1:%String ,THold2:%String ,THold3:%String ,THold4:%String ,THold5:%String")
{
}

ClassMethod GetPCContactPersonInfoListExecute(ByRef qHandle As %Binary, SourceTypeID As %String = "", SourceDesc As %String = "", TypeID As %String = "", Name As %String = "", Role As %String = "", Sex As %String = "", MobilePhone As %String = "", OfficePhone As %String = "", Email As %String = "", Fax As %String = "", Address As %String = "", Area As %String = "", FromDate As %String = "", ToDate As %String = "", QQ As %String = "", WeChat As %String = "", Remark As %String = "", SourceFlag As %String = "", SourceID As %String = "", OtherContact As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	If FromDate'="" Set FromDate = ##class(web.DHCEQCommon).TransValueFromPage(FromDate,"date")
	If ToDate'="" Set ToDate = ##class(web.DHCEQCommon).TransValueFromPage(ToDate,"date")
	s TRow=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQPCContactPerson",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPCContactPersonInfoList
	.Set TInvalidFlag = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",19) //无效标志
	.Quit:(TInvalidFlag'="N") 
	.Set TRowID = rowid
	.Set TSourceType = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",1)
	.q:(SourceTypeID'="")&&(TSourceType'=SourceTypeID)
	.Set TSourceID = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",2) 
	.q:(SourceID'="")&&(SourceID'=TSourceID)		//add by CZF0100
	.q:TSourceID=""
	.q:(((TSourceType=2)||(TSourceType=3)||(TSourceType=4)||(TSourceType=5))&&($P($g(^DHCEQCCode("DHCEQCVendor",TSourceID)),"^",19)="Y"))  //modified by CZF0095 与DHC_EQCVendor公司类型一致 begin
	.If TSourceID'="" Do	
	..If TSourceType=2 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)
	..If TSourceType=3 Set TSourceDesc=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TSourceID)  //CZF0093
	..If TSourceType=4 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("cservice",TSourceID)
	..If TSourceType=5 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)		// modified by czf 20200404 begin
	.Set TSourceType = $CASE(TSourceType,"2":"供应商","3":"生产厂商","4":"服务商","5":"公司",:"没有定义")		//modified by CZF0095 与DHC_EQCVendor公司类型一致 end
	.q:(SourceDesc'="")&&(TSourceDesc'[SourceDesc)
	.Set TType = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",3)
	.q:(TypeID'="")&&(TType'=TypeID)			//modified by czf 1231444 end
	.Set TType = $CASE(TType,"1":"法人","2":"销售/服务经理","3":"工程师","4":"其他",:"没有定义")
	.Set TName = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",4)
	.q:(TName'="")&&(TName'[Name)
	.Set TRole = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",5)
	.q:(TRole'="")&&(TRole'[Role)
	.Set TSex = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",6)
	.q:(TSex'="")&&(TSex'[Sex)
	.Set TMobilePhone = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",7)
	.q:(TMobilePhone'="")&&(TMobilePhone'[MobilePhone)
	.Set TOfficePhone = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",8)
	.q:(TOfficePhone'="")&&(TOfficePhone'[OfficePhone)
	.Set TEmail = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",9)
	.q:(TEmail'="")&&(TEmail'[Email)
	.Set TFax = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",10)
	.q:(TFax'="")&&(TFax'[Fax)	
	.Set TQQ = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",11)
	.q:(TQQ'="")&&(TQQ'[QQ)
	.Set TWeChat = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",12)
	.q:(TWeChat'="")&&(TWeChat'[WeChat)
	.Set TOtherContact = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",13)
	.q:(TOtherContact'="")&&(TOtherContact'[OtherContact)
	.Set TAddress = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",14)
	.q:(TAddress'="")&&(TAddress'[Address)
	.Set TArea = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",15)
	.q:(TArea'="")&&(TArea'[Area)
	.Set TRemark = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",16)
	.q:(TRemark'="")&&(TRemark'[Remark)		//modified by czf 20200426 begin
	.Set TFromDate = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",17)
	.q:(FromDate'="")&&(TFromDate<FromDate)
	.If TFromDate '="" Set TFromDate = ##class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")
	.Set TToDate = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",18)
	.q:(ToDate'="")&&(TToDate>ToDate)    
	.If TToDate '="" Set TToDate = ##class(web.DHCEQCommon).TransValueToPage(TToDate,"date")		//modified by czf 20200426 end
	.Set THold1 = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",20)
	.;q:(THold1'="")&&(THold1'[Hold1)
	.Set THold2 = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",21)
	.;q:(THold2'="")&&(THold2'[Hold2)
	.Set THold3 = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",22)
	.;q:(THold3'="")&&(THold3'[Hold3)
	.Set THold4 = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",23)
	.;q:(THold4'="")&&(THold4'[Hold4)
	.Set THold5 = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",24)
	.;q:(THold5'="")&&(THold5'[Hold5)
	.Do OutputRowGetPCContactPersonInfoList
	Quit $$$OK
OutputRowGetPCContactPersonInfoList
	Set Data=$lb(TRow,TRowID,TSourceType,TSourceID,TSourceDesc,TType,TName,TRole,TSex,TMobilePhone,TOfficePhone,TEmail,TFax,TQQ,TWeChat,TOtherContact,TAddress,TArea,TRemark,TFromDate,TToDate,TInvalidFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesGetPCContactPersonInfoList
	Set (TRowID,TSourceType,TSourceID,TSourceDesc,TType,TName,TRole,TSex,TMobilePhone,TOfficePhone,TEmail,TFax,TQQ,TWeChat,TOtherContact,TAddress,TArea,TRemark,TFromDate,TToDate,TInvalidFlag,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetPCContactPersonInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPCContactPersonInfoListExecute ]
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

ClassMethod GetPCContactPersonInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPCContactPersonInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SourceTypeList(name, width, Type) As %String
{
	;;下拉列表
	s width=155	
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	;w "<option value=2>供应商</option>"		//modified by CZF0095 与DHC_EQCVendor公司类型一致
	;w "<option value=3>生产厂商</option>"
	;w "<option value=4>服务商</option>"
	w "<option value=5>公司</option>"		//modified by czf 20200404
	w "</select>",!
}

ClassMethod TypeList(name, width, Type, promtinfo As %String = "") As %String
{
	;下拉列表
	//s width=155	
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,width,promtinfo)        //modified by myl   1805950   20210317
	w "<option value=></option>"
	w "<option value=1>法人</option>"
	w "<option value=2>销售/服务经理</option>"
	w "<option value=3>工程师</option>"
	w "<option value=4>其他</option>"
	w "</select>",!
}

/// w ##Class(web.DHCEQPCContactPerson).GetOnePCContactPerson("1")
ClassMethod GetOnePCContactPerson(Growid)
{
	;new (Growid)
	Set (result,resultex)=""
	Set result= $g(^DHCEQCCode("DHCEQPCContactPerson",Growid))
	Set resultex=resultex_"^"	
	If $Piece(result,"^",2)'="" Do  
	.If $Piece(result,"^",1)=2 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))   //modified by CZF0095 与DHC_EQCVendor公司类型一致 begin
	.If $Piece(result,"^",1)=3 Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece(result,"^",2))  //CZF0093
	.If $Piece(result,"^",1)=4 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cservice",$Piece(result,"^",2))  //modified by CZF0095 与DHC_EQCVendor公司类型一致 end
	.If $Piece(result,"^",1)=5 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))		//modified by czf 20200404
	s resultex=resultex_"^" //person
	i $p(result,"^",3)'=""  d  
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",$p(result,"^",3))),"^",2)
	;Set resultex=resultex_"^"_$Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",$Piece(result,"^",3))),"^",2)
	Set $Piece(result,"^",17)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",17),"date")
	Set $Piece(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",18),"date")
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

/// modified by CZF0095
/// 联系人放大镜
/// d ##class(%ResultSet).RunQuery("web.DHCEQPCContactPerson","GetPCContactPersonList","","2","1921","")
Query GetPCContactPersonList(Name As %String = "", SourceType As %String = "", SourceID As %String = "", Type As %String = "") As %Query(ROWSPEC = "TName:%String:姓名,Hidden:%String,TMobilePhone:%String:联系电话,TOfficeTel:%String:办公电话,TType:%String:联系人类型")
{
}

ClassMethod GetPCContactPersonListExecute(ByRef qHandle As %Binary, Name As %String = "", SourceType As %String = "", SourceID As %String = "", Type As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	s TRow=1
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQPCContactPerson",rowid)) Quit:rowid=""  Do
	.Do ResetPCContactPersonList
	.Set TInvalidFlag = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",19) //无效标志
	.Quit:(TInvalidFlag'="N") 
	.Set TRowID = rowid
	.Set TSourceType = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",1)
	.q:(SourceType'="")&&(TSourceType'=SourceType)
	.Set TSourceID = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",2)  
	.q:(SourceID'="")&&(TSourceID'=SourceID)
	.q:(((TSourceType=2)||(TSourceType=3)||(TSourceType=4)||(TSourceType=5))&&($P($g(^DHCEQCCode("DHCEQCVendor",TSourceID)),"^",19)="Y")) //modified by CZF0095 与DHC_EQCVendor公司类型一致 begin
	.If TSourceID'="" Do	
	..If TSourceType=2 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)
	..If TSourceType=3 Set TSourceDesc=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TSourceID)  //CZF0093
	..If TSourceType=4 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("cservice",TSourceID)		//modified by CZF0095 与DHC_EQCVendor公司类型一致 end
	..If TSourceType=5 Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",TSourceID)	//modified by czf 20200404
	.Set TType = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",3)
	.q:(Type'="")&&(TType'=Type)
	.Set TType = $CASE(TType,"1":"法人","2":"销售/服务经理","3":"工程师","4":"其他",:"没有定义")
	.Set TName = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",4)
	.q:(Name'="")&&(TName'[Name)
	.Set TMobilePhone = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",7)
	.Set TOfficeTel = $Piece($Get(^DHCEQCCode("DHCEQPCContactPerson",rowid)),"^",8)
	.Do OutputPCContactPersonList
	Quit $$$OK
OutputPCContactPersonList
	Set Data=$lb(TName,TRowID,TMobilePhone,TOfficeTel,TType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetPCContactPersonList
	Set (TRowID,TSourceType,TSourceID,TSourceDesc,TType,TName,TMobilePhone,TOfficeTel)=""
	Quit
}

ClassMethod GetPCContactPersonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPCContactPersonListExecute ]
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

ClassMethod GetPCContactPersonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPCContactPersonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 维修页面 联系(维修工程师)人专用
/// modified by CZF0095 CI_SourceType与DHC_EQCVendor公司类型一致 begin
Query LookUp(para, Service) As %SQLQuery(ROWSPEC = "Name:%String:姓名,TelPhone:%String:电话")
{
  SELECT CI_Name,CI_MobilePhone FROM SQLUSER.DHC_EQPCContactPerson where CI_InvalidFlag = 'N'  AND CI_Type=3 AND CI_SourceType=4 AND CI_SourceID=:Service AND CI_Name like nvl(:para,'')||'%'
}

}
