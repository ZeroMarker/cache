/// 名称: DHCMed.SSService.ConfigSrv
/// 描述: DHCMed.SS.Config配置表的常用操作
/// 编写者：wuqk
/// 编写日期: 2010-04-07
Class DHCMed.SSService.ConfigSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据Key/HospId获取配置值
/// Table：       DHCMed.SS.Config
/// Input：       key：    键
///               hospId： 医院Id
/// Return：      返回配置值的字符串
/// 如果不区分医院，可不传医院Id
/// w ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalCode","")
ClassMethod GetValueByKeyHosp(aKeys As %String, aHospitalID As %String = "") As %String
{
	new (aKeys,aHospitalID,%session)
	set return=""
	quit:aKeys="" return
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set IsHaveCofig=0
	Set xHospID = ""
	For{
		Set xHospID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$zcvt(aKeys,"U"),xHospID))
		Quit:xHospID=""
		Continue:((aHospitalID'="")&&(aHospitalID'=xHospID))
		set ID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$zcvt(aKeys,"U"),+aHospitalID,""))
		if ID'="" {
			set objConfig=##class(DHCMed.SS.Config).GetObjById(ID)
			if $IsObject(objConfig) {
				set return=objConfig.Val
				set IsHaveCofig=1
				Quit
			}
		}
	}
	Set return = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Config","Val",Languages,return)
	quit:IsHaveCofig=1 return
	quit:+aHospitalID=0 return
	
	set ID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$zcvt(aKeys,"U"),0,""))
	if ID'="" {
		set objConfig=##class(DHCMed.SS.Config).GetObjById(ID)
		if $IsObject(objConfig) {
			set return=objConfig.Val
		}
	}
	Set return = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Config","Val",Languages,return)
	quit return
}

/// Creator：     李阳
/// CreatDate：   2010-04-11
/// Description:  根据Key/HospId获取Global中存储的配置值
/// Table：       DHCMed.SS.Config
/// Input：       key：    键
///               hospId： 医院Id
///               ID:     传入的RowID，比如病人RowID，Paadm RowID
/// Return：      返回Global中存储的配置值的字符串
/// 如果不区分医院，可不传医院Id
/// w ##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("CompanyLocation",2,121696)
ClassMethod GetGlobalValueByKeyHosp(key As %String, hospId As %String, ID As %String) As %String
{
	n (key,hospId,ID)
	s GlobalLoc=..GetValueByKeyHosp(key,hospId)
	s exp=""
	s:GlobalLoc'="" exp="s val="_GlobalLoc
	s:GlobalLoc="" val=""
	x exp
	q val
}

/// Creator：     wuwj
/// CreatDate：   2010-04-07
/// Description:  根据Key/HospId获取配置值
/// Table：       DHCMed.SS.Config
/// Input：       key：    键
///               hospId： 医院Id
/// Return：      返回配置值的Id
/// 如果不区分医院，可不传医院Id
/// w ##class(DHCMed.SSService.ConfigSrv).GetIdByKeyHosp("")
ClassMethod GetIdByKeyHosp(key As %String, hospId As %String) As %String
{
	new (key,hospId)
	set val=""
	quit:key="" val
	s hospId=+$g(hospId)
	s key1=" "_key
	s key1=$ZCVT(key1,"U") //转换为大写
	
	quit:'$d(^DHCMed.SS.ConfigI("IndexKeyHosp",key1,hospId)) val

	set id=$o(^DHCMed.SS.ConfigI("IndexKeyHosp",key1,hospId,""))
	quit id
}

/// Creator：     wuwj
/// CreatDate：   2010-04-12
/// Description: 通过id获取配置信息
/// Table：       DHCMed.SS.Config
/// Input：       id
/// Return：      返回配置值的字符串
/// w ##class(DHCMed.SSService.ConfigSrv).GetStringById("2")
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set ret=""
	set ProName="",HispsDescs=""
	if (separete="")
	{
    	s separete=..#SEPARATE
	}
	s myconfig=##class(DHCMed.SS.Config).%OpenId(id)
	if ($IsObject(myconfig))
	{    
		s ProductDr=myconfig.ProductDr
		s myproducts=##class(DHCMed.SS.Products).GetObjById(ProductDr)
		if ($IsObject(myproducts))
		{ 
		  s ProName=myproducts.ProName 
		 }
		    
		s HospitalDr=myconfig.HospitalDr
		s HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		
		//s Resume=myconfig.Resume
		//s Str=Keys_separete_Description_separete_Val_separete_ValueDesc_separete_ProName_separete_HispsDescs_separete_Resume
		//quit Str
		set ret=myconfig.ToString(separete)
		set ret=ret_separete_ProName_separete_HispsDescs
	}
	quit ret
}

/// Creator：     wuwj
/// CreatDate：   2010-04-09
/// Description:  查询所有的配置
/// Table：       DHCMed.SS.Config
/// Input：       
/// output:       所有的配置项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.ConfigSrv","QryConfig","")
Query QryConfig(aProCode As %String) As %Query(ROWSPEC = "myid:%String,Keys:%String,Description:%String,Val:%String,ValueDesc:%String,ProName:%String,HispsDescs:%String,Resume:%String,ProID:%String,HospID:%String")
{
}

ClassMethod QryConfigExecute(ByRef qHandle As %Binary, aProCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aProCode=$g(aProCode)
 	
 	set xID=0
 	for {
		set xID=$o(^DHCMed.SS.ConfigD(xID))
		quit:xID=""
		set objConfig=##class(DHCMed.SS.Config).GetObjById(xID)
		continue:'$IsObject(objConfig)
		
		set Keys=objConfig.Keys
		set Description=objConfig.Description
		set Val=objConfig.Val
		set ValueDesc=objConfig.ValueDesc
		set:ValueDesc="undefined" ValueDesc=""
		set ProductDr=objConfig.ProductDr
		set objProduct=##class(DHCMed.SS.Products).GetObjById(ProductDr)
		
		if $IsObject(objProduct) {
			Set ProID =objProduct.%Id()
			set ProCode=objProduct.ProCode
			set ProName=objProduct.ProName
		} else {
			set ProID="",ProCode="",ProName="无"
		}
		if (aProCode'="")&&(aProCode'="SYS") {
			continue:aProCode'=ProCode
		}
		set HospitalDr=objConfig.HospitalDr
		Set HospID=""
		if (HospitalDr'=""){
			set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			set HospID=HospitalDr
		}
		Set:HospID=0 HospID=""
		set Resume=objConfig.Resume
		set:Resume="undefined" Resume=""
		set Data=$lb(xID,Keys,Description,Val,ValueDesc,ProName,HispsDescs,Resume,ProID,HospID)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     wuwj
/// CreatDate：   2010-04-12
/// Description:  查询所有的 产品
/// Table：       DHCMed.SS.Products
/// Input：       
/// output:       所有的产品            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.ConfigSrv","QueryProInfo")
Query QueryProInfo() As %Query(ROWSPEC = "rowid:%String,ProName:%String")
{
}

ClassMethod QueryProInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.SS.ProductsD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Products).%OpenId(rowid)
	.q:obj.ProActive'=1
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ProName
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QueryProInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryProInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryProInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     wuwj
/// CreatDate：   2010-04-12
/// Description:  查询所有的医院
/// Table：       DHCMed.SS.Hosptial
/// Input：       
/// output:       所有的符合条件的医院           
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.ConfigSrv","QueryHosInfo")
Query QueryHosInfo() As %Query(ROWSPEC = "rowid:%String,hosName:%String")
{
}

ClassMethod QueryHosInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^CT("HOSP",+rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^CT("HOSP",+rowid)),"^",2)   	 // 医院描述 HOSP_Desc
	.//fix bug 135146 by pylian 加入医院有效判断 
	.s $li(data,3)=$p($g(^CT("HOSP",+rowid)),"^",9)   	 // 医院开始日期
	.s $li(data,4)=$p($g(^CT("HOSP",+rowid)),"^",10)   	 // 医院截止日期
	.set DateForm=$li(data,3)
	.set DateTo=$li(data,4)
	.set today=+$h
	.quit:(DateForm'="")&&(DateForm> today ) 
	.quit:(DateTo'="")&&(DateTo< today ) 
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryHosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHosInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjianbo
/// CreatDate：   2010-05-18
/// Description:  根据Key/HospId获取配置值
/// Table：       DHCMed.SS.Config
/// Input：       key：    键
///               hospId： 医院Id
/// Return：      返回配置值的字符串
/// 如果不区分医院，可不传医院Id
/// Index IndexKeyHosp On (Keys, HospitalDr);
/// w ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("")
ClassMethod GetValueByKeyHospN(key As %String, hospId As %String)
{
	new (key,hospId)
	set val=""
	quit:key="" val
	set key=" "_$ZCVT(key,"U")  
	set hospId=+$g(hospId)
	quit:'$d(^DHCMed.SS.ConfigI("IndexKeyHosp",key,hospId)) val 
	set rowid=$o(^DHCMed.SS.ConfigI("IndexKeyHosp",key,hospId,"")) 
	set objCls=##class(DHCMed.SS.Config).GetObjById(rowid)
	q:'$IsObject(objCls) val
	set val=objCls.Val
	quit val
}

/// w ##Class(DHCMed.SSService.ConfigSrv).ImportConfigs("","^")
ClassMethod ImportConfigs(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	医院ID	代码	描述	值	产品代码	值说明	备注
	Set HospitalDr=$p(aInputStr,aSeparate,2)
	Set Keys=$p(aInputStr,aSeparate,3)
	Set Description=$p(aInputStr,aSeparate,4)
	Set Val=$p(aInputStr,aSeparate,5)
	Set ProductCode=$p(aInputStr,aSeparate,6)
	Set ValueDesc=$p(aInputStr,aSeparate,7)
	Set Resume=$p(aInputStr,aSeparate,8)
	
	Set ProductDr=""
	If ProductCode'="" {
		Set ProductCode=$ZConvert(ProductCode,"T")
		Set ProductDr=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_ProductCode,0))
	}
	Quit:ProductDr="" return
	
	//^DHCMed.SS.ConfigI("IndexKeyHosp"," DHCMEDHOSPCODE",0,13)
	Set ConfigRowID=""
	Set ConfigID=0
	For {
		Set ConfigID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$ZConvert(Keys,"T"),ConfigID))
		Quit:ConfigID=""
		Set objConfig=##class(DHCMed.SS.Config).GetObjById(ConfigID)
		Continue:'$IsObject(objConfig)
		Continue:objConfig.ProductDr'=ProductDr
		Set ConfigRowID=ConfigID
	}
	
	Set InputStr=ConfigRowID_aSeparate_Keys_aSeparate_Description_aSeparate_Val_aSeparate_ValueDesc_aSeparate_ProductDr_aSeparate_HospitalDr_aSeparate_Resume
	Set return=##Class(DHCMed.SS.Config).Update(InputStr,aSeparate)
	
	Quit return
}

/// w ##Class(web.DHCCPW.MR.SysBaseSrv).Translate()
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="")||(associator="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-10-27
/// Description:  更新时判断key是否重复
/// Table：       DHCMed.SS.Config
/// Input：       akey：    键
/// 				  aHospID:	医院
/// Return：      重复：1，不重复：0
/// Index IndexKeyHosp On (Keys, HospitalDr);
/// w ##class(DHCMed.SSService.ConfigSrv).CheckKey("")
ClassMethod CheckKey(aKey As %String, aHospID As %String) As %String
{
	New (aKey,aHospID)
	Set return=""
	Quit:(aKey="") return
	
	s hospId=+$g(aHospID)
	s key1=" "_aKey
	s key1=$ZCVT(key1,"U") //转换为大写
	If ($d(^DHCMed.SS.ConfigI("IndexKeyHosp",key1,hospId)))
	{
		Set return=1
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-11-25
/// 判断是否存在报告(与公共卫生事件查询方法保持一致)
/// w ##Class(DHCMed.SSService.ConfigSrv).IsExistReport(57,"","EPD-2-传染病报告,HAI-1-医院感染报告,DTH-2-医学死亡证明书,SMD-1-严重精神疾患报告卡,FBD-1-食源性疾病,SPE-1-特殊患者,CD-1-慢病管理")
ClassMethod IsExistReport(aEpisodeID As %String, aHAIEpisodeDr As %String = "", aRepTypeList As %String) As %String
{
	New (aEpisodeID,aHAIEpisodeDr,aRepTypeList)
	Set return=0
	Quit:(aEpisodeID="")||(aRepTypeList="") return
	
	Set PatientID=$ZCVT($p($g(^PAADM(+aEpisodeID)),"^",1),"U")
	Set Flg =0
	For ind=1:1:$l(aRepTypeList,",") {
		Set RepTypeList = $p(aRepTypeList,",",ind)
		Quit:RepTypeList=""
		Set TypeCate =$p(RepTypeList,"-",1)
		
		If (TypeCate="EPD") {
			If $d(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID)) Set Flg =1 //传染病报告	
			Quit:Flg=1
			If $d(^DHCMed.EPD.CaseFollowI("IndexPatID"," "_PatientID)) Set Flg =1      //HIV随访
			Quit:Flg=1
			If $d(^DHCMed.EPD.ReferralRepI("EpisodeIDIndex"," "_aEpisodeID)) Set Flg =1   //肺结核转诊单
			Quit:Flg=1
			If $d(^DHCMed.EPD.ERReportILII("EREpisodeIDIndex"," "_aEpisodeID)) Set Flg =1   //流感样病例
			Quit:Flg=1
			If $d(^DHCMed.EPD.NCPInvestigationI("IndexPatientID"," "_PatientID)) Set Flg =1   //新冠肺炎个案调查
			Quit:Flg=1
			If $d(^DHCMed.EPD.HCVReportI("IndexEpisodeID"," "_aEpisodeID)) Set Flg =1		 //新诊断报告丙肝病例个案调查表
			Quit:Flg=1
			If $d(^DHCMed.EPD.STD.ReportI("IndexEpisodeID"," "_aEpisodeID)) Set Flg =1 
          	Quit:Flg=1
			Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 姓名
			Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
			Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6) 
			If ((IdentityCode'="")&&(Birthday'="")){
				If $d(^MA.EPD.ImportReportI("IndexPersonId"," "_$ZCVT(PatName,"U"),Birthday," "_$ZCVT(IdentityCode,"U"))) Set Flg=1  //历史数据
			}
			Quit:Flg=1
		}
		
		If (TypeCate="HAI") {  //院感报告、新生儿报告、多重耐药菌报告
			If (aHAIEpisodeDr'="")&&($d(^DHCHAI.IR.INFReportI("IndexPaadmType",aHAIEpisodeDr,1)))  Set Flg =1 
			Quit:Flg=1	
			If (aHAIEpisodeDr'="")&&($d(^DHCHAI.IR.INFReportI("IndexPaadmType",aHAIEpisodeDr,2)))  Set Flg =1 
			Quit:Flg=1
			If (aHAIEpisodeDr'="")&&($d(^DHCHAI.IR.INFReportI("IndexPaadmType",aHAIEpisodeDr,5)))  Set Flg =1 
			Quit:Flg=1
			If (aHAIEpisodeDr'="")&&($d(^DHCHAI.IR.INFReportI("IndexPaadmType",aHAIEpisodeDr,4)))  Set Flg =1 
			Quit:Flg=1
		}
		If (TypeCate="DTH") {  //死亡证明书
			If $d(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID)) Set Flg =1  
			Quit:Flg=1
		}
		If (TypeCate="SMD") {  //精神疾病
			If $d(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID)) Set Flg =1 
			Quit:Flg=1
		}
		If (TypeCate="FBD") {   //食源性疾病
			If $d(^DHCMed.FBD.ReportI("IndexPatientID"," "_PatientID)) Set Flg =1    //食源性疾病报告
			Quit:Flg=1
			If $d(^DHCMed.FBD.SusAbRepI("IndexPatientID"," "_PatientID)) Set Flg =1   //疑似食源性疾病报告
			Quit:Flg=1					
		}
		
		If (TypeCate="CD") { //慢病报告
			Set xAdmType=""
			For {
				Set xAdmType=$o(^PAPERdr(PatientID,"ADM",xAdmType))
				Quit:xAdmType=""
				Set xEpisodeID=""
				For {
					Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM",xAdmType,xEpisodeID))
					Quit:xEpisodeID=""
					Continue:'$d(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_aEpisodeID)) 
					Set Flg =1 
					Quit
				}
			}
			Quit:Flg=1
		}
		If (TypeCate="RDS") {    //罕见病登记
			If $d(^DHCMed.RD.ReportI("IdxOfPatientID"," "_$ZCVT(PatientID,"U"))) Set Flg =1 
			Quit:Flg=1
		}
		
		If (TypeCate="SPE") {
			Continue:'$d(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID))
			Set xPatTypeID=0
			For {
				Set xPatTypeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID))
				Quit:xPatTypeID=""
				
				Set xSpeID=0
				For {
					Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID,xSpeID))
					Quit:xSpeID=""
					
					Set SpeID=xSpeID
				    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(SpeID)
				    Continue:'$IsObject(objSpe)
				    Continue:'$IsObject(objSpe.PSPatTypeDr)
				    Continue:'$IsObject(objSpe.PSCurrStatus)
					Continue:objSpe.PSCurrStatus.Code="0"  //作废过滤
					Set Flg =1
					Quit
				}
			}
			Quit:Flg=1
		}
	}
	
	Set return=Flg
	Quit return
}

}
