Class web.DHCPE.CT.HM.BaseDataSet Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 生成用户唯一编码方法

ClassMethod GetUserCode() As %String
{
	n id,obj,tmp,propertieStr // 设置以上变量为局部变量（不设置会影响方法外同名变量）
 	// ^User.DHCHMCSettingI("SCodeIndex"," 90010001",146)
 	s id=$O(^User.DHCHMCSettingI("SCodeIndex"," 90010001",0))
 	q:id="" $H                //如果没有值 则返回时间做ID
 	lock ^User.DHCHMCSettingD(id)  //数据加锁
 	s obj=##class(User.DHCHMCSetting).GetObj(id)
 	s tmp=obj.SValue+1
 	s propertieStr="SValue"
 	d ##class(User.DHCHMCSetting).SaveData(id,tmp,propertieStr,"N")
 	lock -^User.DHCHMCSettingD(id) //数据解锁
 	q tmp
}

// 寻找编码默认值方法

ClassMethod GetDefault(typecode As %String) As %String
{
	//Ext.apply(obj.Sex,{value:Value})
	//Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010006"," Y",0))
 s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," "_typecode," Y",0))
 q Code
}

// 查找登记号是否重复

ClassMethod FindBIPAPMINo(BIPAPMINo As %String) As %String
{
   
    n (BIPAPMINo)
    
	s flag=0
	s str=""
	s id=""
	
	f  s id=$O(^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," "_BIPAPMINo,id)) q:id=""  d
	.s flag=id
	//w flag
	i flag=0 {quit ""}
	s str=##class(User.DHCHMOBaseInfo).GetJsonStrByID(flag)
	//w str
	
	/*
	s property ="BICode^BIPAPMINo^BICSexDR^BIDOB^BITel^BICOccupationDR^BICServiceClassDR^BIHMDR^BIName^BICCertificateTypeDR^BIInputCode^BICNationDR^BICity^BICEducationDR^BICUserGroupDR^BIDocDR^BIIDCard^BIPassWord^BIMobilePhone^BIPostCode^BICUserTypeDR^BIEmail^BICMaritalDR^BICompany^BIAddress^BIRemark"
	s obj=##class(User.DHCHMOBaseInfo).GetObj(flag)
	s i=$l(property,"^") //得到被^分割的项目数
	s str=""
	f j=1:1:i
	{
	  s str=str_obj.
	}
	*/
	q str
	//^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," 001",2)
}

// 对根据登记号取出的 串进行JSON转码

ClassMethod GetJSONbyBIPAPMINo(BIPAPMINo As %String) As %String
{
    n (BIPAPMINo)
    //s titleStr="ID^QOBaseInfoDR^BICode^BIName^BIMobilePhone^QCOccupationDR^QDocDR^BIPAPMINo^BICSexDR^BICUserTypeDR^QCEducationDR^QHMDR^BIIDCard^BIDOB^QCServiceClassDR^QCMaritalDR^QPostCode^QRemark"
	
    //端木娟^6^1990-03-12^^^8^^^2^9^4^^100010^ZG-中国^^
    //姓名:性别:出生日期:证件类型:证件号码:婚姻状况:电话:手机:职业:民族:
    s titleStr="BIName^BICSexDR^BIDOB^BICCertificateTypeDR^BIIDCard^BICMaritalDR^BITel^BIMobilePhone^QCOccupationDR^BICNationDR^BICEducationDR^BIEmail^BIPostCode^BICity^BICompany^BIAddress"
    s str=##class(web.DHCHM.Service.GetInfo).GetPatientInfo(BIPAPMINo)
	q ##class(web.DHCHM.Json.JsonObj).GetJsonStr(titleStr,str,"^")
}

// 拼音别名表DHCHMCAlias保存方法 	

ClassMethod CAliasSaveData(theID As %String = "", valueStr As %String, TheCode As %String, fID As %String) As %Integer
{
 n (theID,valueStr,TheCode,fID)	
 
 if TheCode="" {quit}
 if theID="" {quit} 
 if valueStr="" {quit}
 
 //首先判断fID 是新加还是修改 如是修改 先做删除
 if fID'="" {
 &sql(delete from sqlUser.DHCHMCAlias where AType=:TheCode and ASourceID=:theID)
  // i (SQLCODE = 0) d
  // .w {successtrue,info_%ROWID_}
  // e  d
  // .w {successfalse,info添加失败!_SQLCODE_}	  
 }
 s propertieStr="ASourceID^AType^AValue"	
 //先切分字串 然后循环保存
 s i=1
 
 s flag=1
 //TSTART
 n str,tmp,ret
 
 f  s str=$P(valueStr,";",i) q:str=""  d
 .s i=i+1
 .s tmp=theID_"^"_TheCode_"^"_str
 .s ret= ##class(User.DHCHMCAlias).SaveData("",tmp,propertieStr,"N")
 .if +ret<0 d   
 ..s flag=0
 
 //Tcommit  
 q flag
}

// 得到别名

ClassMethod GetCAlias(Type, FID As %String = "")
{
	n (Type,FID)
	
	s char1=""
	s str=""
	s id=0
	//w Type
	//w FID
	f  s id=$O(^User.DHCHMCAliasI("ASourceIDIndex"," "_Type," "_FID,id)) q:id=""  d
	.s obj=##class(User.DHCHMCAlias).GetObj(id)
	.s AValue=obj.AValue
	.s str=str_char1_AValue
	.s char1=";"
	//w str
	q str
}

// DHCHMCMedicalStandards保存方法

ClassMethod CMedicalStandardsSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
 n (ID,valueStr,propertieStr)
 set propertieStr="MSActive^MSCode^MSDesc^MSNatureValue^MSRemark"
 	
 q ##class(User.DHCHMCMedicalStandards).SaveData(ID,valueStr,propertieStr,"Y")
}

// 

Query GetCMedicalStandards(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "") As %Query(ROWSPEC = "ID:%String:ID,MSActive:%String:MSActive,MSCode:%String:MSCode,MSDesc:%String:MSDesc,MSNatureValue:%String:MSNatureValue,MSRemark:%String:MSRemark")
{
}

ClassMethod GetCMedicalStandardsExecute(ByRef qHandle As %Binary, param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCMedicalStandardsD(ID))  quit:ID=""  d
	.d BuildDataGetDHCHMCMedicalStandards
	Quit $$$OK
BuildDataGetDHCHMCMedicalStandards
	d ResetVariablesGetDHCHMCMedicalStandards
	s obj=##class(User.DHCHMCMedicalStandards).%OpenId(ID)
	s MSActive = obj.MSActive
	//布尔值Y转换TRUE
     	if MSActive="Y" {s MSActive="true"} 
    	if MSActive="N" {s MSActive="false"} 
	//
	s MSCode = obj.MSCode
	s MSDesc = obj.MSDesc
	s MSNatureValue = obj.MSNatureValue
	//布尔值Y转换TRUE
     	if MSNatureValue="Y" {s MSNatureValue="true"} 
    	if MSNatureValue="N" {s MSNatureValue="false"} 
	//
	s MSRemark = obj.MSRemark
	
	//筛选
	if param1'="" {	q:(MSCode[param1'=1)}
	if param2'="" {	q:MSDesc[param2'=1}
	//if param3'="false" {	q:MSActive="false"}
	//if param4'="false" {	q:MSNatureValue="false"}
   
	if param5'="" {	q:MSRemark[param5'=1}

	//
	
	d OutputRowGetDHCHMCMedicalStandards
	quit
OutputRowGetDHCHMCMedicalStandards
	s Data=$lb(ID,MSActive,MSCode,MSDesc,MSNatureValue,MSRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDHCHMCMedicalStandards
	s (MSActive,MSCode,MSDesc,MSNatureValue,MSRemark)=""
	quit
}

ClassMethod GetCMedicalStandardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCMedicalStandardsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCMedicalStandardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCMedicalStandardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// DHCHMCMagazine保存方法

ClassMethod CMagazineSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
  n (ID,valueStr,propertieStr)	
 set pStr="MActive^MCode^MDesc^MLink^MPeriodical^MPublishDate^MRemark^MSummary"
 
  Tstart 	
  
 s ret=##class(User.DHCHMCMagazine).SaveData(ID,valueStr,pStr,"N")
	if +ret<0 {   
    TROLLBACK
    q ret
 }
 
 s ret1=0 
 if propertieStr'="" 
 { 
   s ret1=##class(web.DHCHM.BaseDataSet).CAliasSaveData(ret,propertieStr,"20011008",ID)
 }
 
 if +ret1<0 {   
    TROLLBACK
 }else{ 
    Tcommit}
    
	q ret
}

Query GetCMagazin(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", param7 As %String = "", param8 As %String = "") As %Query(ROWSPEC = "ID:%String:ID,MActive:%String:MActive,MCode:%String:MCode,MDesc:%String:MDesc,MLink:%String:MLink,MPeriodical:%String:MPeriodical,MRemark:%String:MRemark,MSummary:%String:MSummary,MAlias:%String:MAlias,MPublishDate:%String:MPublishDate")
{
}

ClassMethod GetCMagazinExecute(ByRef qHandle As %Binary, param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", param7 As %String = "", param8 As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCMagazineD(ID))  quit:ID=""  d
	.d BuildDataGetCMagazin
	Quit $$$OK
BuildDataGetCMagazin
	d ResetVariablesGetCMagazin
	s obj=##class(User.DHCHMCMagazine).%OpenId(ID)
	s MActive = obj.MActive
	//布尔值Y转换TRUE
     	if MActive="Y" {s MActive="true"} 
    	if MActive="N" {s MActive="false"} 
	//
	s MCode = obj.MCode
	s MDesc = obj.MDesc
	s MLink = obj.MLink
	s MPeriodical = obj.MPeriodical
	s MRemark = obj.MRemark
	s MSummary = obj.MSummary
	s MPublishDate=##class(websys.Conversions).DateLogicalToHtml(obj.MPublishDate)

	
	
	s MAlias=##class(web.DHCHM.BaseDataSet).GetCAlias("20011008",ID)
		
	//w MAlias
	
	//MActive 	MCode 	MDesc 	MLink 	MPeriodical 	MRemark 	MSummary
	//筛选
	if param1'="" {	q:(MCode[param1'=1)}
	if param2'="" {	q:MDesc[param2'=1}
	//if param3'="false" {	q:MActive="false"}

	if param5'="" {	q:MLink[param5'=1}
	if param6'="" {	q:MPeriodical[param6'=1}
	if param7'="" {	q:MRemark[param7'=1}
    if param8'="" {	q:MSummary[param8'=1}


	//
	d OutputRowGetCMagazin
	quit
OutputRowGetCMagazin
	s Data=$lb(ID,MActive,MCode,MDesc,MLink,MPeriodical,MRemark,MSummary,MAlias,MPublishDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCMagazin
	s (MActive,MCode,MDesc,MLink,MPeriodical,MRemark,MSummary,MAlias,MPublishDate)=""
	quit
}

ClassMethod GetCMagazinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCMagazinExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCMagazinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCMagazinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// DHC_HM_CMedicalTips///////////

ClassMethod CMedicalTipsSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
	 n (ID,valueStr,propertieStr)
 //w ##class(User.DHCHMCMedicalTips).SaveData("","Y^22^33^11^44","MTActive^MTCode^MTDesc^MTDetail^MTRemark","N")
	s pStr="MTActive^MTCode^MTDesc^MTDetail^MTRemark"

   Tstart 
   
	s ret=##class(User.DHCHMCMedicalTips).SaveData(ID,valueStr,pStr,"N")
	if +ret<0 {   
     TROLLBACK
     q ret_"(主表保存失败)"
    }
   
   s ret1=0
   if propertieStr'="" 
   {	 
      s ret1=##class(web.DHCHM.BaseDataSet).CAliasSaveData(ret,propertieStr,"50011006",ID)
   } 
 
    if +ret1<0 {   
     TROLLBACK
     q ret1_"(别名保存失败)"
    }else{ 
     Tcommit}
    
	q ret
}

/// d ##class("%ResultSet").RunQuery("web.DHCHM.BaseDataSet","GetCMedicalTips","","","","","",6)
Query GetCMedicalTips(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "") As %Query(ROWSPEC = "ID:%String:ID,MTActive:%String:MTActive,MTCode:%String:MTCode,MTDesc:%String:MTDesc,MTDetail:%String:MTDetail,MTRemark:%String:MTRemark,MTAlias:%String:MTAlias")
{
}

ClassMethod GetCMedicalTipsExecute(ByRef qHandle As %Binary, param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCMedicalTipsD(ID))  quit:ID=""  d
	.d BuildDataGetCMedicalTips
	Quit $$$OK
BuildDataGetCMedicalTips
	d ResetVariablesGetCMedicalTips
	s obj=##class(User.DHCHMCMedicalTips).%OpenId(ID)
	s MTActive = obj.MTActive
	
	//布尔值Y转换TRUE
     	if MTActive="Y" {s MTActive="true"} 
    	if MTActive="N" {s MTActive="false"} 
	//
	
	s MTCode = obj.MTCode
	s MTDesc = obj.MTDesc
	s length=$G(^User.DHCHMCMedicalTipsS(ID,0))
	s MTDetail = obj.MTDetail.Read(length)
	s MTRemark = obj.MTRemark
	s MTAlias=##class(web.DHCHM.BaseDataSet).GetCAlias("50011006",ID)
	
	//筛选
	
	if param1'="" {	q:(MTCode[param1'=1)}
	if param2'="" {	q:MTDesc[param2'=1}
	//if param3'="false" {	q:MTActive="false"}

	//if param5'="" {	q:MTDetail[param5'=1}
	//if param6'="" {	q:MTRemark[param6'=1}
	
	 //
	
	d OutputRowGetCMedicalTips
	quit
OutputRowGetCMedicalTips
	s Data=$lb(ID,MTActive,MTCode,MTDesc,MTDetail,MTRemark,MTAlias)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCMedicalTips
	s (MTActive,MTCode,MTDesc,MTDetail,MTRemark,MTAlias)=""
	quit
}

ClassMethod GetCMedicalTipsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCMedicalTipsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCMedicalTipsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCMedicalTipsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// CExpression保存//////////////////////////////////////////////////////////

ClassMethod CExpressionSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
	 n (ID,valueStr,propertieStr)
 	s propertieStr="EAgeMax^EAgeMin^ECQuestionnaireDR^EExpression^EExpressionType^EParameters^ERemark^ESex^ESourceID^EType^EUnit"
	q ##class(User.DHCHMCExpression).SaveData(ID,valueStr,propertieStr,"Y")
}

ClassMethod CExpressionDelete(id, flag As %String = "N")
{
	set ret=##class(User.DHCHMCExpression).Delete(id, "N")
	q ret
}

Query GetCExpression() As %Query(ROWSPEC = "ID:%String:ID,EAgeMax:%String:EAgeMax,EAgeMin:%String:EAgeMin,ECQuestionnaireDR:%String:ECQuestionnaireDR,QDesc:%String:QDesc,EExpression:%String:EExpression,EExpressionType:%String:EExpressionType,EParameters:%String:EParameters,ERemark:%String:ERemark,ESex:%String:ESex,ESourceID:%String:ESourceID,EType:%String:EType,EUnit:%String:EUnit")
{
}

ClassMethod GetCExpressionExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCExpressionD(ID))  quit:ID=""  d
	.d BuildDataGetCExpression
	Quit $$$OK
BuildDataGetCExpression
	d ResetVariablesGetCExpression
	s obj=##class(User.DHCHMCExpression).%OpenId(ID)
	s EAgeMax = obj.EAgeMax
	s EAgeMin = obj.EAgeMin
	i $ISOBJECT(obj.ECQuestionnaireDR) d
	.s ECQuestionnaireDR = obj.ECQuestionnaireDR.%Id()
	.i ECQuestionnaireDR '= "" d
	..s QDesc=obj.ECQuestionnaireDR.QDesc
	s EExpression = obj.EExpression
	s EExpressionType = obj.EExpressionType
	s EParameters = obj.EParameters
	s ERemark = obj.ERemark
	s ESex = obj.ESex
	s ESourceID = obj.ESourceID
	s EType = obj.EType
	s EUnit = obj.EUnit
	d OutputRowGetCExpression
	quit
OutputRowGetCExpression
	s Data=$lb(ID,EAgeMax,EAgeMin,ECQuestionnaireDR,QDesc,EExpression,EExpressionType,EParameters,ERemark,ESex,ESourceID,EType,EUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCExpression
	s (EAgeMax,EAgeMin,ECQuestionnaireDR,QDesc,EExpression,EExpressionType,EParameters,ERemark,ESex,ESourceID,EType,EUnit)=""
	quit
}

ClassMethod GetCExpressionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCExpressionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCExpressionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCExpressionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// CServiceClass /////////////////////

ClassMethod CServiceClassSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
	 n (ID,valueStr,propertieStr)
 	s propertieStr="SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark"
	q ##class(User.DHCHMCServiceClass).SaveData(ID,valueStr,propertieStr,"Y")
}

/// Description: 查询服务级别表(维护数据，显示所有数据)
/// Input:		
/// Return:
/// Creator:	xueying
/// CreateDate:	2021-11-26
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.BaseDataSet","GetCServiceClassNew","152")
Query GetCServiceClassNew(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", LocID As %String = "") As %Query(ROWSPEC = "ID:%String:ID,SCActive:%String:SCActive,SCCode:%String:SCCode,SCDesc:%String:SCDesc,SCMonths:%String:SCMonths,SCPrice:%String:SCPrice,SCRemark:%String:SCRemark,TEmpower,TEffPowerFlag")
{
}

ClassMethod GetCServiceClassNewExecute(ByRef qHandle As %Binary, param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", LocID As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCServiceClassD(ID))  quit:ID=""  d
	.d BuildDataGetCServiceClassNew
	Quit $$$OK
BuildDataGetCServiceClassNew
	d ResetVariablesGetCServiceClassNew
	s obj=##class(User.DHCHMCServiceClass).%OpenId(ID)
	s SCActive = obj.SCActive
	//布尔值Y转换TRUE
     	if SCActive="Y" {s SCActive="true"} 
    	if SCActive="N" {s SCActive="false"} 
	//
	s SCCode = obj.SCCode
	s SCDesc = obj.SCDesc
	s SCMonths = obj.SCMonths
	s SCPrice = obj.SCPrice
	i $F(SCPrice,".")=2 s SCPrice="0"_SCPrice
	s SCRemark = obj.SCRemark
	
	//筛选SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark
	if param1'="" {	q:(SCCode[param1'=1)}
	if param2'="" {	q:SCDesc[param2'=1}
	//if param3'="false" {	q:SCActive="false"}
	if param4'="" {	q:SCMonths<param4}
  
	if param5'="" {	q:SCPrice<param5}
	if param6'="" {	q:SCRemark[param6'=1}
	//
	s LocShowDFlag=##class(User.DHCHMCServiceClass).GetLocShowDataFlag(ID,LocID)
    q:LocShowDFlag="N"
    s EmpowerStr=##class(User.DHCHMCServiceClass).GetEmpowerFlag(ID,LocID)
    s Empower=$p(EmpowerStr,"^",2)
    s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
	d OutputRowGetCServiceClassNew
	quit
OutputRowGetCServiceClassNew
	s Data=$lb(ID,SCActive,SCCode,SCDesc,SCMonths,SCPrice,SCRemark,Empower,EffPowerFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCServiceClassNew
	s (SCActive,SCCode,SCDesc,SCMonths,SCPrice,SCRemark,Empower,EffPowerFlag)=""
	quit
}

ClassMethod GetCServiceClassNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCServiceClassNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCServiceClassNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCServiceClassNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description: 查询服务级别表(使用数据，显示科室授权过的数据)
/// Input:		
/// Return:
/// Creator:	wangguoying
/// CreateDate:	2020-11-26
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HM.BaseDataSet","GetCServiceClass","")
Query GetCServiceClass(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", LocID As %String = "") As %Query(ROWSPEC = "ID:%String:ID,SCActive:%String:SCActive,SCCode:%String:SCCode,SCDesc:%String:SCDesc,SCMonths:%String:SCMonths,SCPrice:%String:SCPrice,SCRemark:%String:SCRemark")
{
}

ClassMethod GetCServiceClassExecute(ByRef qHandle As %Binary, param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "", param6 As %String = "", LocID As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCServiceClassD(ID))  quit:ID=""  d
	.s powerFlg = ##class(User.DHCHMCServiceClass).GetLocShowDataFlag(ID , LocID)
	.q:powerFlg'="Y"
	.d BuildDataGetCServiceClass
	Quit $$$OK
BuildDataGetCServiceClass
	d ResetVariablesGetCServiceClass
	s obj=##class(User.DHCHMCServiceClass).%OpenId(ID)
	s SCActive = obj.SCActive
	//布尔值Y转换TRUE
     	if SCActive="Y" {s SCActive="true"} 
    	if SCActive="N" {s SCActive="false"} 
	//
	s SCCode = obj.SCCode
	s SCDesc = obj.SCDesc
	s SCMonths = obj.SCMonths
	s SCPrice = obj.SCPrice
	i $F(SCPrice,".")=2 s SCPrice="0"_SCPrice
	s SCRemark = obj.SCRemark
	
	//筛选SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark
	if param1'="" {	q:(SCCode[param1'=1)}
	if param2'="" {	q:SCDesc[param2'=1}
	//if param3'="false" {	q:SCActive="false"}
	if param4'="" {	q:SCMonths<param4}
  
	if param5'="" {	q:SCPrice<param5}
	if param6'="" {	q:SCRemark[param6'=1}
	//
	d OutputRowGetCServiceClass
	quit
OutputRowGetCServiceClass
	s Data=$lb(ID,SCActive,SCCode,SCDesc,SCMonths,SCPrice,SCRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCServiceClass
	s (SCActive,SCCode,SCDesc,SCMonths,SCPrice,SCRemark)=""
	quit
}

ClassMethod GetCServiceClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCServiceClassExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCServiceClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCServiceClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// CSCQLink ///////////////////////

ClassMethod CSCQLinkSaveData(ID As %String = "", valueStr As %String, propertieStr As %String) As %Integer
{
	 n (ID,valueStr,propertieStr)
 	//s propertieStr="SCQLParRef^ID^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark^childsub"
 	s propertieStr="SCQLParRef^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark"
	q ##class(User.DHCHMCSCQLink).SaveData(ID,valueStr,propertieStr,"Y")
}

ClassMethod CSCQLinkDelete(id, flag As %String = "N")
{
	set ret=##class(User.DHCHMCSCQLink).Delete(id, "N")
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.BaseDataSet","GetCSCQLink",3)
Query GetCSCQLink(theid As %String) As %Query(ROWSPEC = "ID:%String:ID,SCQLCQuestionnaireDR:%String:SCQLCQuestionnaireDR,QDesc:%String:QDesc,SCQLOrder:%String:SCQLOrder,SCQLRemark:%String:SCQLRemark")
{
}

ClassMethod GetCSCQLinkExecute(ByRef qHandle As %Binary, theid As %String) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID1=0
	s ID=""
    for  s ID1=$O(^User.DHCHMCSCQLinkI("SCQLOrderIndex",theid,ID1)) quit:ID1=""  do
    .s ID2=""
    .for  s ID2=$O(^User.DHCHMCSCQLinkI("SCQLOrderIndex",theid,ID1,ID2)) quit:ID2=""  do
    ..s ID=theid_"||"_ID2
    ..d BuildDataGetCSCQLink
	
	Quit $$$OK
BuildDataGetCSCQLink
	d ResetVariablesGetCSCQLink
	s obj=##class(User.DHCHMCSCQLink).%OpenId(ID)
	i $ISOBJECT(obj.SCQLCQuestionnaireDR) d
	.s SCQLCQuestionnaireDR = obj.SCQLCQuestionnaireDR.%Id()
	.i SCQLCQuestionnaireDR '= "" d
	..s QDesc=obj.SCQLCQuestionnaireDR.QDesc
	s SCQLOrder = obj.SCQLOrder
	s SCQLRemark = obj.SCQLRemark
	d OutputRowGetCSCQLink
	quit
OutputRowGetCSCQLink
	s Data=$lb(ID,SCQLCQuestionnaireDR,QDesc,SCQLOrder,SCQLRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCSCQLink
	s (SCQLCQuestionnaireDR,QDesc,SCQLOrder,SCQLRemark)=""
	quit
}

ClassMethod GetCSCQLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCSCQLinkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCSCQLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCSCQLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 得到问卷列表  ////////////////////////////////////////////////////

Query GetCQuestionnaire() As %Query(ROWSPEC = "ID:%String:ID,QActive:%String:QActive,QCode:%String:QCode,QDesc:%String:QDesc,QRemark:%String:QRemark,QType:%String:QType")
{
}

ClassMethod GetCQuestionnaireExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionnaireD(ID))  quit:ID=""  d
	.d BuildDataGetCQuestionnaire
	Quit $$$OK
BuildDataGetCQuestionnaire
	d ResetVariablesGetCQuestionnaire
	s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
	s QActive = obj.QActive
	q:QActive'="Y"
	s QCode = obj.QCode
	s QDesc = obj.QDesc
	s QRemark = obj.QRemark
	s QType = obj.QType
	d OutputRowGetCQuestionnaire
	quit
OutputRowGetCQuestionnaire
	s Data=$lb(ID,QActive,QCode,QDesc,QRemark,QType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCQuestionnaire
	s (QActive,QCode,QDesc,QRemark,QType)=""
	quit
}

ClassMethod GetCQuestionnaireFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCQuestionnaireExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCQuestionnaireClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCQuestionnaireExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 用户信息保存//////////////////////////////////////////////////////////////////////////

ClassMethod OBaseInfoSave(id, value, property, flag As %String = "N")
{
	n (id, value, property, flag)
   Tstart 
    s ret=""
    if id="" d
    .s ret=##class(web.DHCHM.BaseDataSet).GetUserCode()
    .s value=ret_value
	
    //.w value
        
	set ret1=##class(User.DHCHMOBaseInfo).SaveData(id,value,property,"N")
	//s:+rStr<0 Flag=1
	if +ret1<0 {   
    	TROLLBACK
	}
	else{ 
    	Tcommit
    }
    
	q ret1_"$"_ret
}

Query GetOBaseInfo(param1 As %String = "", param2 As %String = "", param3 As %String = "", param4 As %String = "", param5 As %String = "") As %Query(ROWSPEC = "ID:%String:ID,BIAddDate:%String:BIAddDate,BIAddTime:%String:BIAddTime,BIAddUserDR:%String:BIAddUserDR,SSUSRName:%String:SSUSRName,BIAddress:%String:BIAddress,BICCertificateTypeDR:%String:BICCertificateTypeDR,CTDesc:%String:CTDesc,BICEducationDR:%String:BICEducationDR,CTDesc:%String:CTDesc,BICMaritalDR:%String:BICMaritalDR,CTDesc:%String:CTDesc,BICNationDR:%String:BICNationDR,CTDesc:%String:CTDesc,BICOccupationDR:%String:BICOccupationDR,CTDesc:%String:CTDesc,BICServiceClassDR:%String:BICServiceClassDR,SCDesc:%String:SCDesc,BICSexDR:%String:BICSexDR,SexDesc:%String:SexDesc,BICUserGroupDR:%String:BICUserGroupDR,CTDesc:%String:CTDesc,BICUserTypeDR:%String:BICUserTypeDR,CTDesc:%String:CTDesc,BICity:%String:BICity,BICode:%String:BICode,BICompany:%String:BICompany,BIDOB:%String:BIDOB,BIDocDR:%String:BIDocDR,SSUSRName:%String:SSUSRName,BIEmail:%String:BIEmail,BIHMDR:%String:BIHMDR,SSUSRName:%String:SSUSRName,BIHospWebsite:%String:BIHospWebsite,HOSPDesc:%String:HOSPDesc,BIIDCard:%String:BIIDCard,BIInputCode:%String:BIInputCode,BILocDR:%String:BILocDR,CTLOCDesc:%String:CTLOCDesc,BIMobilePhone:%String:BIMobilePhone,BIName:%String:BIName,BIPAPMINo:%String:BIPAPMINo,BIPassWord:%String:BIPassWord,BIPostCode:%String:BIPostCode,BIRemark:%String:BIRemark,BITel:%String:BITel")
{
}

ClassMethod GetOBaseInfoExecute(ByRef qHandle As %Binary, param1, param2, param3, param4, param5) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=""
	f  s ID=$o(^User.DHCHMOBaseInfoD(ID),-1)  quit:ID=""  d
	.d BuildDataGetOBaseInfo
	Quit $$$OK
BuildDataGetOBaseInfo
	d ResetVariablesGetOBaseInfo
	s obj=##class(User.DHCHMOBaseInfo).%OpenId(ID)
	s BIAddDate = ##class(websys.Conversions).DateLogicalToHtml(obj.BIAddDate)
	s BIAddTime = obj.BIAddTime
	i $ISOBJECT(obj.BIAddUserDR) d
	.s BIAddUserDR = obj.BIAddUserDR.%Id()
	.i BIAddUserDR '= "" d
	..s SSUSRName=obj.BIAddUserDR.SSUSRName
	s BIAddress = obj.BIAddress
	i $ISOBJECT(obj.BICCertificateTypeDR) d
	.s BICCertificateTypeDR = obj.BICCertificateTypeDR.%Id()
	.i BICCertificateTypeDR '= "" d
	..s CTDesc=obj.BICCertificateTypeDR.CTDesc
	i $ISOBJECT(obj.BICEducationDR) d
	.s BICEducationDR = obj.BICEducationDR.%Id()
	.i BICEducationDR '= "" d
	..s CTDesc=obj.BICEducationDR.CTDesc
	i $ISOBJECT(obj.BICMaritalDR) d
	.s BICMaritalDR = obj.BICMaritalDR.%Id()
	.i BICMaritalDR '= "" d
	..s CTDesc=obj.BICMaritalDR.CTDesc
	i $ISOBJECT(obj.BICNationDR) d
	.s BICNationDR = obj.BICNationDR.%Id()
	.i BICNationDR '= "" d
	..s CTDesc=obj.BICNationDR.CTDesc
	i $ISOBJECT(obj.BICOccupationDR) d
	.s BICOccupationDR = obj.BICOccupationDR.%Id()
	.i BICOccupationDR '= "" d
	..s CTDesc=obj.BICOccupationDR.CTDesc
	i $ISOBJECT(obj.BICServiceClassDR) d
	.s BICServiceClassDR = obj.BICServiceClassDR.%Id()
	.i BICServiceClassDR '= "" d
	..s SCDesc=obj.BICServiceClassDR.SCDesc
	i $ISOBJECT(obj.BICSexDR) d
	.s BICSexDR = obj.BICSexDR.%Id()
	.i BICSexDR '= "" d
	..s SexDesc=obj.BICSexDR.CTDesc
	i $ISOBJECT(obj.BICUserGroupDR) d
	.s BICUserGroupDR = obj.BICUserGroupDR.%Id()
	.i BICUserGroupDR '= "" d
	..s CTDesc=obj.BICUserGroupDR.CTDesc
	i $ISOBJECT(obj.BICUserTypeDR) d
	.s BICUserTypeDR = obj.BICUserTypeDR.%Id()
	.i BICUserTypeDR '= "" d
	..s CTDesc=obj.BICUserTypeDR.CTDesc
	s BICity = obj.BICity
	s BICode = obj.BICode
	s BICompany = obj.BICompany
	s BIDOB = ##class(websys.Conversions).DateLogicalToHtml(obj.BIDOB)
	i $ISOBJECT(obj.BIDocDR) d
	.s BIDocDR = obj.BIDocDR.%Id()
	.i BIDocDR '= "" d
	..s SSUSRName=obj.BIDocDR.SSUSRName
	s BIEmail = obj.BIEmail
	i $ISOBJECT(obj.BIHMDR) d
	.s BIHMDR = obj.BIHMDR.%Id()
	.i BIHMDR '= "" d
	..s SSUSRName=obj.BIHMDR.SSUSRName
	i $ISOBJECT(obj.BIHospWebsite) d
	.s BIHospWebsite = obj.BIHospWebsite.%Id()
	.i BIHospWebsite '= "" d
	..s HOSPDesc=obj.BIHospWebsite.HOSPDesc
	s BIIDCard = obj.BIIDCard
	s BIInputCode = obj.BIInputCode
	i $ISOBJECT(obj.BILocDR) d
	.s BILocDR = obj.BILocDR.%Id()
	.i BILocDR '= "" d
	..s CTLOCDesc=obj.BILocDR.CTLOCDesc
	s BIMobilePhone = obj.BIMobilePhone
	s BIName = obj.BIName
	s BIPAPMINo = obj.BIPAPMINo
	s BIPassWord = obj.BIPassWord
	s BIPostCode = obj.BIPostCode
	s BIRemark = obj.BIRemark
	s BITel = obj.BITel
   //筛选
	if param1'="" {	q:BIPAPMINo[param1'=1}
	if param2'="" {	q:BIName[param2'=1}
	if param3'="" {	q:BICSexDR'=param3}
	if param4'="" {	q:BICServiceClassDR[param4'=1}
	if param5'="" {	q:BIHMDR[param5'=1}
	//筛选
	
	d OutputRowGetOBaseInfo
	quit
OutputRowGetOBaseInfo
	s Data=$lb(ID,BIAddDate,BIAddTime,BIAddUserDR,SSUSRName,BIAddress,BICCertificateTypeDR,CTDesc,BICEducationDR,CTDesc,BICMaritalDR,CTDesc,BICNationDR,CTDesc,BICOccupationDR,CTDesc,BICServiceClassDR,SCDesc,BICSexDR,SexDesc,BICUserGroupDR,CTDesc,BICUserTypeDR,CTDesc,BICity,BICode,BICompany,BIDOB,BIDocDR,SSUSRName,BIEmail,BIHMDR,SSUSRName,BIHospWebsite,HOSPDesc,BIIDCard,BIInputCode,BILocDR,CTLOCDesc,BIMobilePhone,BIName,BIPAPMINo,BIPassWord,BIPostCode,BIRemark,BITel)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOBaseInfo
	s (BIAddDate,BIAddTime,BIAddUserDR,SSUSRName,BIAddress,BICCertificateTypeDR,CTDesc,BICEducationDR,CTDesc,BICMaritalDR,CTDesc,BICNationDR,CTDesc,BICOccupationDR,CTDesc,BICServiceClassDR,SCDesc,BICSexDR,SexDesc,BICUserGroupDR,CTDesc,BICUserTypeDR,CTDesc,BICity,BICode,BICompany,BIDOB,BIDocDR,SSUSRName,BIEmail,BIHMDR,SSUSRName,BIHospWebsite,HOSPDesc,BIIDCard,BIInputCode,BILocDR,CTLOCDesc,BIMobilePhone,BIName,BIPAPMINo,BIPassWord,BIPostCode,BIRemark,BITel)=""
	quit
}

ClassMethod GetOBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOBaseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 得到代码表信息------------------------------------

Query GetCCodeTable() As %Query(ROWSPEC = "ID:%String:ID,CTActive:%String:CTActive,CTCode:%String:CTCode,CTDefault:%String:CTDefault,CTDesc:%String:CTDesc,CTExpandCode:%String:CTExpandCode,CTRemark:%String:CTRemark,CTType:%String:CTType")
{
}

ClassMethod GetCCodeTableExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCCodeTableD(ID))  quit:ID=""  d
	.d BuildDataGetCCodeTable
	Quit $$$OK
BuildDataGetCCodeTable
	d ResetVariablesGetCCodeTable
	s obj=##class(User.DHCHMCCodeTable).%OpenId(ID)
	s CTActive = obj.CTActive
	s CTCode = obj.CTCode
	s CTDefault = obj.CTDefault
	s CTDesc = obj.CTDesc
	s CTExpandCode = obj.CTExpandCode
	s CTRemark = obj.CTRemark
	s CTType = obj.CTType
	d OutputRowGetCCodeTable
	quit
OutputRowGetCCodeTable
	s Data=$lb(ID,CTActive,CTCode,CTDefault,CTDesc,CTExpandCode,CTRemark,CTType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCCodeTable
	s (CTActive,CTCode,CTDefault,CTDesc,CTExpandCode,CTRemark,CTType)=""
	quit
}

ClassMethod GetCCodeTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCCodeTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// ///////////////////////////////////////////////////////////////////////////////

// 得到问卷某问题答案 参数 问卷ID 问题代码串

// w ##class(web.DHCHM.BaseDataSet).GetAnswer("5||5","zy04009")

// w ##class(web.DHCHM.BaseDataSet).GetAnswer("9||12","cdc01020")

ClassMethod GetAnswer(id, quecode)
{
	n (id,quecode)
	s Date=+$H
	s Time=$P($H,",",2)
	s rID=+id
	s qSub=$p(id,"||",2)
	
	//w id,!
	//w rID,!
	//w qSub,! 
	
	//取到结果表ID
	s answer=""
	s rsub=0
	f  s rsub=$o(^User.DHCHMOQEQuestionD(rID,qSub,"DHCHMOQResult",rsub)) q:rsub=""  d
	.s resultID=id_"||"_rsub //组成结果表ID
	.//w resultID_"  "
	.//得到结果表
	.s resultObj=##class(User.DHCHMOQResult).GetObj(resultID)
	.//得到问题指针
	.s cQusetionID=resultObj.QRCQuestionsDetailDR.%Id()
	.s QusetionObj=##class(User.DHCHMCQuestionsDetail).GetObj(cQusetionID)
	.i (QusetionObj.QDCode=quecode)||(quecode="") d
	
	..//w QusetionObj.QDCode_"  "_QusetionObj.QDDesc_"  "_QusetionObj.QDType_"   "
	
	..i (QusetionObj.QDType="M")||(QusetionObj.QDType="S") do
	...s OptionID=resultObj.QRCQDOptionsDR.%Id()
	...//w ##class(User.DHCHMCQDOptions).GetObj(OptionID).QDODesc_"  "
	
	..s QRResult=resultObj.QRResult
	..//w " / "_QRResult,!
	..i answer'="" do
	...s answer=answer_"$"
	
	..s answer=answer_QRResult 
	..//w answer,!
    Q answer
}

// ///////////////////////////////////////////////////////////////////////////////

// 得到问卷某评估项目 评估结果 参数 问卷ID 评估代码串

// w ##class(web.DHCHM.BaseDataSet).GetJudge("8||15","10030006","CDC03")

// w ##class(web.DHCHM.BaseDataSet).GetJudge("8||15","10040001","CDC07")

ClassMethod GetJudge(id, quecode, judgecode)
{
	n (id,quecode,judgecode,answer)
	s Date=+$H
	s Time=$P($H,",",2)
	s rID=+id
	s qSub=$p(id,"||",2)
	
	//w id,!
	//w rID,!
	//w qSub,! 
	
	//取到结果表ID
	s answer=""
	s sub=0
	f  s sub=$O(^User.DHCHMOQEQuestionD(rID,qSub,"DHCHMOQEvaluation",sub)) q:sub=""  d
	.s reObj=##class(User.DHCHMOQEvaluation).GetObj(id_"||"_sub)
	.s eID=reObj.QECEvaluationDetailDR.%Id()
	.s EObj=##class(User.DHCHMCEvaluationDetail).GetObj(eID)
	.q:(EObj.EDCode'=judgecode)
	
	.//w EObj.EDDesc
	.//w reObj.QEResult
	
	.s desc=reObj.QEResult
	.i (reObj.QEResult'="")&&(EObj.EDType="C") d
	..//s desc=""
	..//f  s desc=$o(	^User.DHCHMCClassLevelI("TypeExpandCodeIndex"," "_quecode," "_reObj.QEResult,desc))  q:desc=""  d
	...//s answer=##class(User.DHCHMCClassLevel).GetObj(desc).CLDesc
	..s answer=##class(User.DHCHMCClassLevel).GetObj(desc).CLDesc
	..if (judgecode="CDC08") d
	...s answer=##class(User.DHCHMCHumanClass).GetObj(desc).HCDesc
	
	...//w answer,!
	
	Q answer
}

// d ##class(web.DHCHM.BaseDataSet).GetReport("5||5")

ClassMethod GetReport(id, user As %String = "")
{
	n (id,user)
	s rID=+id
	s qSub=$p(id,"||",2)
	
	//w id,!
	//w rID,!
	//w qSub,! //
	
	
	
	
	//得到问卷
	s qObj=##class(User.DHCHMOQEQuestion).GetObj(id)
	
	//得到问卷主表
	s cQusetionID=qObj.QEQCQuestionnaireDR.%Id()
	
	//得到人员评估记录表
	s rObj=##class(User.DHCHMOEvaluationRecord).GetObj(rID)
	
	//得到人员基本信息表
	s bID=rObj.QOBaseInfoDR.%Id()
	s bObj=##class(User.DHCHMOBaseInfo).GetObj(bID)
    
    
	s str=bObj.BIName_"^"

	s str=str_##class(User.DHCHMCCodeTable).GetObj(bObj.BICSexDR.%Id()).CTDesc_"^"
	s str=str_$ZDate(bObj.BIDOB,3)_"^"
	s str=str_bObj.BICode_"^"
	s str=str_bObj.BIAddress_"^"
	
   	q str
}

// 得到user信息------------------------------------

// d ##class(%ResultSet).RunQuery("web.DHCHM.BaseDataSet","GetUserBy","王丽")

Query GetUserBy(Filter As %String = "") As %Query(ROWSPEC = "ID:%String:ID,CName:%String:CName")
{
}

ClassMethod GetUserByExecute(ByRef qHandle As %Binary, Filter As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	
	//^SSU("SSUSR",0,"SSUSR_Name","李蕴铷",838)
	s Filter=$ZCVT(Filter,"U")
	s Name=$O(^SSU("SSUSR",0,"SSUSR_Name",Filter),-1)
	//s Name=val
	f  s Name=$O(^SSU("SSUSR",0,"SSUSR_Name",Name)) q:(Name="")||(Name'[Filter)  d
	.s ID=0
	.f  s ID=$O(^SSU("SSUSR",0,"SSUSR_Name",Name,ID)) q:ID=""  d
	..s CName=$P(^SSU("SSUSR",ID),"^",2)
	
	
	..d OutputRowGetUserBy
	Quit $$$OK

OutputRowGetUserBy
	s Data=$lb(ID,CName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUserBy
	s (Name)=""
	quit
}

ClassMethod GetUserByFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUserByClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(web.DHCHM.BaseDataSet).Test("王丽文")

ClassMethod Test(val)
{
	s Name=$O(^SSU("SSUSR",0,"SSUSR_Name",val),-1)
	//s Name=val
	f  s Name=$O(^SSU("SSUSR",0,"SSUSR_Name",Name)) q:(Name="")||(Name'[val)  d
	.w Name,!
}

// 保存健康管理师信息

ClassMethod DoctorSave(id, value, property, flag As %String = "N")
{
	n (id, value, property, flag)
   Tstart 
    s ret=""
    s property="DActive^DCode^DDesc^DRemark^Dtype"
        
	s ret1=##class(User.DHCHMDoctor).SaveData(id,value,property,"N")

	if +ret1<0 {   
    	TROLLBACK
	}
	else{ 
    	Tcommit
    }
    
	q ret1
}

// 得到doctor信息------------------------------------

// d ##class(%ResultSet).RunQuery("web.DHCHM.BaseDataSet","GetDoctor","")

Query GetDoctor(Code As %String = "", Type As %String = "", Active As %String = "") As %Query(ROWSPEC = "ID:%String:ID,DCode:%String:DCode,DShort,DDesc,Dtype,DActive:%String:DDesc")
{
}

ClassMethod GetDoctorExecute(ByRef qHandle As %Binary, Code As %String = "", Type As %String = "", Active As %String = "") As %Status
{
    new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMDoctorD(ID))  quit:ID=""  d
	
	.d BuildDataGetDoctor
	Quit $$$OK
BuildDataGetDoctor
	d ResetVariablesGetDoctor
	s obj=##class(User.DHCHMDoctor).%OpenId(ID)
	s DCode = obj.DCode.%Id()
	q:(Code'="")&&(DCode'=Code)
	s DShort=obj.DCode.SSUSRInitials
	s DDesc = obj.DCode.SSUSRName
	s Dtype = obj.Dtype
	q:(Type'="")&&(Dtype'=Type)
	s DActive = obj.DActive
	q:(Active'="")&&(DActive'=Active)
	d OutputRowGetDoctor
	quit
OutputRowGetDoctor
	s Data=$lb(ID,DCode,DShort,DDesc,Dtype,DActive)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDoctor
	s (Name)=""
	quit
}

ClassMethod GetDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCCodeTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
