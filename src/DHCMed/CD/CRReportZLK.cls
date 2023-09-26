/// 名称: DHCMed.CD.CRReportZLK
/// 描述: 肿瘤卡信息
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-19
Class DHCMed.CD.CRReportZLK Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildZLK ];

/// 卡片编号
Property CRKPBH As %String;

/// 病情已告知病人
Property CRBQYGZBR As DHCMed.SS.Dictionary;

/// 诊断
Property CRZD As %String;

/// 诊断ICD-10
Property CRZDICD As %String;

/// 诊断部位
Property CRZDBW As %String;

/// 原发部位
Property CRYFBW As DHCMed.SS.Dictionary;

/// 病理学类型
Property CRBLXLX As %String;

/// 病理号
Property CRBLH As %String;

/// 生物学行为
Property CRSWXXW As DHCMed.SS.Dictionary;

/// 分化程度
Property CRFHCD As DHCMed.SS.Dictionary;

/// TNM分期-T
Property CRTNMFQT As DHCMed.SS.Dictionary;

/// TNM分期-N
Property CRTNMFQN As DHCMed.SS.Dictionary;

/// TNM分期-M
Property CRTNMFQM As DHCMed.SS.Dictionary;

/// 诊断日期
Property CRZDRQ As %Date;

/// 首次诊断日期
Property CRSCZDRQ As %Date;

/// 诊断依据
Property CRZDYJ As list Of DHCMed.SS.Dictionary;

/// 最高诊断依据
Property CRZGZDYJ As DHCMed.SS.Dictionary;

/// 最高诊断单位
Property CRZGZDDW As DHCMed.SS.Dictionary;

/// 手术
Property CRSS As %String;

/// 手术ICD-CM3
Property CRSSICD As %String;

/// 形态学
Property CRXTX As %String;

/// 形态学ICD-10
Property CRXTXICD As %String;

/// 原诊断
Property CRYZD As %String;

/// 原诊断ICD-10
Property CRYZDICD As %String;

/// 原诊断日期
Property CRYZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// 死亡原因
Property CRSWYY As DHCMed.SS.Dictionary;

/// 死亡具体原因
Property CRJTSWYY As %String(MAXLEN = 200);

/// 死亡诊断
Property CRSWZD As %String;

/// 死因ICD-10
Property CRSYICD As %String;

/// 病史摘要
Property CRBSZY As %String(MAXLEN = 500);

/// add 2019-02-21诊断部位 DHCMed.CD.CRDiagnosPos.ID
Property CRZDBWDr As DHCMed.CD.CRDiagnosPos;

/// add 2019-02-21病理类型 DHCMed.CD.CRPathology.ID
Property CRBLXLXDr As DHCMed.CD.CRPathology;

/// add 2020-02-25 解剖学编码 DHCMed.CD.CRAnatomy.ID
Property CRJPXBMDr As DHCMed.CD.CRAnatomy;

/// add 2021-12-08
/// 证件类型
Property CRCardType As DHCMed.SS.Dictionary;

/// 联系人1
Property ContactOne As %String;

/// 与患者关系
Property RelationOne As DHCMed.SS.Dictionary;

/// 联系电话1
Property PhoneOne As %String;

/// 联系人2
Property ContactTwo As %String;

/// 与患者关系
Property RelationTwo As DHCMed.SS.Dictionary;

/// 联系电话2
Property PhoneTwo As %String;

/// 联系人3
Property ContactThr As %String;

/// 与患者关系
Property RelationThr As DHCMed.SS.Dictionary;

/// 联系电话3
Property PhoneThr As %String;

/// 发病日期
Property AttackDate As %Date;

/// 行为
Property Action As DHCMed.SS.Dictionary;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取肿瘤卡信息
/// Table：       DHCMed.CD.CRReportZLK
/// Input：       ID:    DHCMed.CD.CRReportZLK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportZLK).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportZLK
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"ZLK",0))
	Set obj=##class(DHCMed.CD.CRReportZLK).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CRKPBH_separete
	Set return=return_..GetDicByObj(..CRBQYGZBR,Languages)_separete  //1
	//Set return=return_..GetICDDescByID(..CRZD)_separete
	Set return=return_##class(DHCMed.CD.CRICDDx).GetDescByID(..CRZD)_separete  //update 2019-02-21
	Set return=return_..CRZDICD_separete	//3
	Set return=return_..CRZDBW_separete
	Set return=return_..GetDicByObj(..CRYFBW,Languages)_separete
	Set return=return_..CRBLXLX_separete	//6
	Set return=return_..CRBLH_separete
	Set return=return_..GetDicByObj(..CRSWXXW,Languages)_separete
	Set return=return_..GetDicByObj(..CRFHCD,Languages)_separete
	Set return=return_..GetDicByObj(..CRTNMFQT,Languages)_separete
	Set return=return_..GetDicByObj(..CRTNMFQN,Languages)_separete
	Set return=return_..GetDicByObj(..CRTNMFQM,Languages)_separete
	Set ZDRQ=..CRZDRQ	
	;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set return=return_ZDRQ_separete	//13
	Set SCZDRQ=..CRSCZDRQ
	;Set:SCZDRQ'="" SCZDRQ=$zd(SCZDRQ,3)
	Set:SCZDRQ'="" SCZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SCZDRQ)
	Set return=return_SCZDRQ_separete
	Set ZDYJ=..CRZDYJ
	Set ZDYJstr=""
	For ind=1:1:ZDYJ.Count() {
		Set objDic=ZDYJ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set ZDYJstr=ZDYJstr_","_objDic.%Id()
	}
	Set:ZDYJstr'="" ZDYJstr=$e(ZDYJstr,2,$l(ZDYJstr))
	Set return=return_ZDYJstr_separete	//15
	
	Set return=return_..GetDicByObj(..CRZGZDYJ,Languages)_separete
	Set return=return_..GetDicByObj(..CRZGZDDW,Languages)_separete
	Set return=return_..GetICDDescByID(..CRSS)_separete	//18
	Set return=return_..CRSSICD_separete
	Set return=return_..GetICDDescByID(..CRXTX)_separete
	Set return=return_..CRXTXICD_separete	//21
	//Set return=return_..GetICDDescByID(..CRYZD)_separete
	Set return=return_##class(DHCMed.CD.CRICDDx).GetDescByID(..CRYZD)_separete  //update 2019-02-21

	Set return=return_..CRYZDICD_separete
	Set YZDRQ=..CRYZDRQ	
	;Set:YZDRQ'="" YZDRQ=$zd(YZDRQ,3)
	Set:YZDRQ'="" YZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(YZDRQ)
	Set return=return_YZDRQ_separete	//24
	Set SWRQ=..CRSWRQ
	;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set return=return_SWRQ_separete
	Set return=return_..GetDicByObj(..CRSWYY,Languages)_separete	//26
	Set return=return_..CRJTSWYY_separete
	Set return=return_..CRSYICD_separete	//28
	Set return=return_..CRBSZY_separete
	Set return=return_..GetICDDescByID(..CRSWZD)_separete
	Set return=return_##class(DHCMed.CD.CRDiagnosPos).GetDescByObj(..CRZDBWDr)_separete  //31  //update 20200225 
	Set return=return_..GetCRPathByObj(..CRBLXLXDr)_separete  //32
	Set return=return_##class(DHCMed.CD.CRAnatomy).GetDescByObj(..CRJPXBMDr)_separete 
	
	Set return=return_..GetDicByObj(..CRCardType,Languages)_separete
	Set return=return_..ContactOne_separete
	Set return=return_..GetDicByObj(..RelationOne,Languages)_separete
	Set return=return_..PhoneOne_separete
	Set return=return_..ContactTwo_separete
	Set return=return_..GetDicByObj(..RelationTwo,Languages)_separete
	Set return=return_..PhoneTwo_separete
	Set return=return_..ContactThr_separete
	Set return=return_..GetDicByObj(..RelationThr,Languages)_separete
	Set return=return_..PhoneThr_separete
	Set AttackDate=..AttackDate
	Set:AttackDate'="" AttackDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AttackDate)
	Set return=return_AttackDate_separete
	Set return=return_..GetDicByObj(..Action,Languages)_separete
	
	quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

ClassMethod GetCRPathByObj(obj As DHCMed.CD.CRPathology, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.CD.CRPathology","CRDesc",Languages,obj.CRDesc)
	quit return
}

ClassMethod GetICDDescByID(ICDRowID As %String, Languages As %String = "") As %String
{
	new (ICDRowID,Languages)
	set return=""
	Quit:ICDRowID="" return
	
	Set tmp=$g(^MRC("ID",ICDRowID))
	Quit:tmp="" return
	Set ICDDesc=$p(tmp,"^",2)
	Set ICDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,ICDDesc)
	
	set return=ICDRowID_$c(1)_ICDDesc
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取肿瘤卡信息
/// Table：       DHCMed.CD.CRReportZLK
/// Input：       ID:    DHCMed.CD.CRReportZLK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportZLK).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ID取肿瘤卡信息
/// Table：       DHCMed.CD.CRReportZLK
/// Input：       ID:    DHCMed.CD.CRReportZLK.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportZLK).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportZLK
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportZLK).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportZLK).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-21
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportZLK
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportZLK).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"ZLK",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportZLK).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportZLK).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("ZLK")
	}
	Set obj.CRKPBH=CardNo
	Set CRBQYGZBRID=$p(aInput,separete,3)
	Set obj.CRBQYGZBR=##class(DHCMed.SS.Dictionary).GetObjById(CRBQYGZBRID)
	Set obj.CRZD=$p(aInput,separete,4)
	Set obj.CRZDICD=$p(aInput,separete,5)
	Set obj.CRZDBW=$p(aInput,separete,6)
	Set CRYFBWID=$p(aInput,separete,7)
	Set obj.CRYFBW=##class(DHCMed.SS.Dictionary).GetObjById(CRYFBWID)
	Set obj.CRBLXLX=$p(aInput,separete,8)
	Set obj.CRBLH=$p(aInput,separete,9)
	Set CRSWXXWID=$p(aInput,separete,10)
	Set obj.CRSWXXW=##class(DHCMed.SS.Dictionary).GetObjById(CRSWXXWID)
	Set CRFHCDID=$p(aInput,separete,11)
	Set obj.CRFHCD=##class(DHCMed.SS.Dictionary).GetObjById(CRFHCDID)
	Set CRTNMFQTID=$p(aInput,separete,12)
	Set obj.CRTNMFQT=##class(DHCMed.SS.Dictionary).GetObjById(CRTNMFQTID)
	Set CRTNMFQNID=$p(aInput,separete,13)
	Set obj.CRTNMFQN=##class(DHCMed.SS.Dictionary).GetObjById(CRTNMFQNID)
	Set CRTNMFQMID=$p(aInput,separete,14)
	Set obj.CRTNMFQM=##class(DHCMed.SS.Dictionary).GetObjById(CRTNMFQMID)
	Set CRZDRQ=$p(aInput,separete,15)
	;Set:CRZDRQ["-" CRZDRQ=$zdh(CRZDRQ,3)
	Set:CRZDRQ'="" CRZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRZDRQ)
	Set obj.CRZDRQ=CRZDRQ
	Set CRSCZDRQ=$p(aInput,separete,16)
	;Set:CRSCZDRQ["-" CRSCZDRQ=$zdh(CRSCZDRQ,3)
	Set:CRSCZDRQ'="" CRSCZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRSCZDRQ)
	Set obj.CRSCZDRQ=CRSCZDRQ
	Set CRZDYJs=$p(aInput,separete,17)
	
	While (obj.CRZDYJ.Count()>0) {
		Do obj.CRZDYJ.RemoveAt(1)
	}
	Set CRZDYJLB=""
	For ind=1:1:$length(CRZDYJs,",") {
		Set CRZDYJ=$p(CRZDYJs,",",ind)
		Continue:($listfind(CRZDYJLB,CRZDYJ)>0)
		Set CRZDYJLB=CRZDYJLB_$lb(CRZDYJ)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(CRZDYJ)
		Continue:'$IsObject(objDic)
		Do obj.CRZDYJ.Insert(objDic)
	}
	
	Set CRZGZDYJID=$p(aInput,separete,18)
	Set obj.CRZGZDYJ=##class(DHCMed.SS.Dictionary).GetObjById(CRZGZDYJID)
	Set CRZGZDDWID=$p(aInput,separete,19)
	Set obj.CRZGZDDW=##class(DHCMed.SS.Dictionary).GetObjById(CRZGZDDWID)
	Set obj.CRSS=$p(aInput,separete,20)
	Set obj.CRSSICD=$p(aInput,separete,21)
	Set obj.CRXTX=$p(aInput,separete,22)
	Set obj.CRXTXICD=$p(aInput,separete,23)
	Set obj.CRYZD=$p(aInput,separete,24)
	Set obj.CRYZDICD=$p(aInput,separete,25)
	Set CRYZDRQ=$p(aInput,separete,26)
	;Set:CRYZDRQ["-" CRYZDRQ=$zdh(CRYZDRQ,3)
	Set:CRYZDRQ'="" CRYZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRYZDRQ)
	Set obj.CRYZDRQ=CRYZDRQ
	Set CRSWRQ=$p(aInput,separete,27)
	;Set:CRSWRQ["-" CRSWRQ=$zdh(CRSWRQ,3)
	Set:CRSWRQ'="" CRSWRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRSWRQ)
	Set obj.CRSWRQ=CRSWRQ
	Set CRSWYYID=$p(aInput,separete,28)
	Set obj.CRSWYY=##class(DHCMed.SS.Dictionary).GetObjById(CRSWYYID)
	Set obj.CRSYICD=$p(aInput,separete,30)
	Set obj.CRJTSWYY=$p(aInput,separete,29)
	Set obj.CRBSZY=$p(aInput,separete,31)
	Set obj.CRSWZD=$p(aInput,separete,32)
	//add 2019-02-21
	Set ZDBWDr=$p(aInput,separete,33)
	Set obj.CRZDBWDr=##class(DHCMed.CD.CRDiagnosPos).GetObjById(ZDBWDr)
	Set BLXLXDr=$p(aInput,separete,34)
	Set obj.CRBLXLXDr=##class(DHCMed.CD.CRPathology).GetObjById(BLXLXDr)
	Set JPXBMDr=$p(aInput,separete,35)
	Set obj.CRJPXBMDr=##class(DHCMed.CD.CRAnatomy).GetObjById(JPXBMDr)

	Set CRCardType=$p(aInput,separete,36)
	Set obj.CRCardType=##class(DHCMed.SS.Dictionary).GetObjById(CRCardType)
	Set obj.ContactOne=$p(aInput,separete,37)
	Set RelationOne=$p(aInput,separete,38)
	Set obj.RelationOne=##class(DHCMed.SS.Dictionary).GetObjById(RelationOne)
	Set obj.PhoneOne=$p(aInput,separete,39)

	Set obj.ContactTwo=$p(aInput,separete,40)
	Set RelationTwo=$p(aInput,separete,41)
	Set obj.RelationTwo=##class(DHCMed.SS.Dictionary).GetObjById(RelationTwo)
	Set obj.PhoneTwo=$p(aInput,separete,42)

	Set obj.ContactThr=$p(aInput,separete,43)
	Set RelationThr=$p(aInput,separete,44)
	Set obj.RelationThr=##class(DHCMed.SS.Dictionary).GetObjById(RelationThr)
	Set obj.PhoneThr=$p(aInput,separete,45)

	Set AttackDate=$p(aInput,separete,46)
	Set:AttackDate'="" AttackDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AttackDate)
	Set obj.AttackDate=AttackDate
	Set Action=$p(aInput,separete,47)
	Set obj.Action=##class(DHCMed.SS.Dictionary).GetObjById(Action)

	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-22
/// Description : 处理历史肿瘤报告诊断、原诊断(只需执行一次)
/// Table       : DHCMed.CD.CRReportZLK、DHCMed.CD.CRICDDx
/// Input       : ""
/// w ##class(DHCMed.CD.CRReportZLK).SyncZLKRepICD()
ClassMethod SyncZLKRepICD() As %String
{
	Set return=""
    Set Count=0
    Set xID=""
    For {
		Set xID=$o(^DHCMed.CD.CRReportD(xID))
	   	Quit:xID=""
	   	Set xSubID = ""
	   	For {
		   	Set xSubID=$o(^DHCMed.CD.CRReportD(xID,"ZLK",xSubID))
	  		Quit:xSubID=""
	  	  
	  	    Set ID = xID_"||"_xSubID
	  	    Set obj = ##class(DHCMed.CD.CRReportZLK).GetObjById(ID)
	  	    Continue:'$IsObject(obj)
	  	    Set (Code,Desc,FullName,Resume)=""
	  	    
	  	    Set ZDID = obj.CRZD
	  	    Continue:ZDID=""
	  	    Set ZDInfo = $g(^MRC("ID",ZDID))
	  	    Continue:ZDInfo=""
	  	    Set Code =$p(ZDInfo,"^",1)
	  	    Set Desc =$p(ZDInfo,"^",2)
	  	    Set FullName = $p(ZDInfo,"^",2)
	        Set IsActive = 0
	        //诊断
	  	    Set DxID=""
			Set objDx=##class(DHCMed.CD.CRICDDx).GetObjByCode(Code)
			If $IsObject(objDx){
				Set DxID=objDx.%Id()
				Set Code=objDx.CRCode
				Set Desc=objDx.CRDesc
				Set FullName=objDx.CRFullName
				Set IsActive=objDx.CRIsActive
				Set Resume=objDx.CRResume
			}
	  	    Set InputStr=DxID
	  	    Set InputStr=InputStr_"^"_Code
			Set InputStr=InputStr_"^"_Desc
			Set InputStr=InputStr_"^"_FullName
			Set InputStr=InputStr_"^"_IsActive
			Set InputStr=InputStr_"^"_""
			Set ICDDxDr=##class(DHCMed.CD.CRICDDx).Update(InputStr,"^")
		
			If (+ICDDxDr)>0{
				Set Count=Count+1
				//修改诊断
				Set objICD=##class(DHCMed.CD.CRICDDx).GetObjById(ICDDxDr)
				Set obj.CRZD = ICDDxDr
				Set obj.CRZDICD = objICD.CRCode
				Set sc=obj.%Save()
				If $System.Status.IsError(sc) {  
			   		Do $System.OBJ.DisplayError(sc)
			   		Set return=-1
				} Else {
					Set return=obj.%Id()
				}
				Do obj.%Close()
			}
			
			//原诊断
			Set YZDID = obj.CRYZD
			Continue:YZDID=""
	  	    Set YZDInfo = $g(^MRC("ID",YZDID))
	  	    Continue:YZDInfo=""
	  	    Set Code =$p(YZDInfo,"^",1)
	  	    Set Desc =$p(YZDInfo,"^",2)
	  	    Set FullName = $p(YZDInfo,"^",2)
	  	    Set IsActive = 0
	  	  
			Set DxID=""
			Set objDx=##class(DHCMed.CD.CRICDDx).GetObjByCode(Code)
			If $IsObject(objDx){
				Set DxID=objDx.%Id()
				Set Code=objDx.CRCode
				Set Desc=objDx.CRDesc
				Set FullName=objDx.CRFullName
				Set IsActive=objDx.CRIsActive
				Set Resume=objDx.CRResume
			}
	  	    Set InputStr=DxID
	  	    Set InputStr=InputStr_"^"_Code
			Set InputStr=InputStr_"^"_Desc
			Set InputStr=InputStr_"^"_FullName
			Set InputStr=InputStr_"^"_IsActive
			Set InputStr=InputStr_"^"_""
			Set ICDDxDr=##class(DHCMed.CD.CRICDDx).Update(InputStr,"^")
			
			If (+ICDDxDr)>0{
				Set Count=Count+1
				//修改原诊断
				Set objICD=##class(DHCMed.CD.CRICDDx).GetObjById(ICDDxDr)
				Set obj.CRYZD = ICDDxDr
				Set obj.CRYZDICD = objICD.CRCode
				Set sc=obj.%Save()
				If $System.Status.IsError(sc) {  
			   		Do $System.OBJ.DisplayError(sc)
			   		Set return=-1
				} Else {
					Set return=obj.%Id()
				}
				Do obj.%Close()
			}
	   }   
    }
    
    Set return=Count
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-12-06
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回obj
/// w ##class(DHCMed.CD.CRReportZLK).GetObjByTypeDesc("CRCardType","军官证")
ClassMethod GetObjByTypeDesc(argTypeCode As %String, argDesc As %String, argIsActive As %String = 1) As %String
{
	New (argTypeCode,argDesc,argIsActive)
	Set return=""
	Quit:(argTypeCode="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=objDic.Description
		Continue:Description'=argDesc
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(argIsActive'=IsActive)
		
		Set return=objDic.%Id()
	}
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRKPBH</Value>
</Value>
<Value name="3">
<Value>CRBQYGZBR</Value>
</Value>
<Value name="4">
<Value>CRZD</Value>
</Value>
<Value name="5">
<Value>CRZDICD</Value>
</Value>
<Value name="6">
<Value>CRZDBW</Value>
</Value>
<Value name="7">
<Value>CRYFBW</Value>
</Value>
<Value name="8">
<Value>CRBLXLX</Value>
</Value>
<Value name="9">
<Value>CRBLH</Value>
</Value>
<Value name="10">
<Value>CRSWXXW</Value>
</Value>
<Value name="11">
<Value>CRFHCD</Value>
</Value>
<Value name="12">
<Value>CRTNMFQT</Value>
</Value>
<Value name="13">
<Value>CRTNMFQN</Value>
</Value>
<Value name="14">
<Value>CRTNMFQM</Value>
</Value>
<Value name="15">
<Value>CRZDRQ</Value>
</Value>
<Value name="16">
<Value>CRSCZDRQ</Value>
</Value>
<Value name="17">
<Value>CRZDYJ</Value>
</Value>
<Value name="18">
<Value>CRZGZDYJ</Value>
</Value>
<Value name="19">
<Value>CRZGZDDW</Value>
</Value>
<Value name="20">
<Value>CRSS</Value>
</Value>
<Value name="21">
<Value>CRSSICD</Value>
</Value>
<Value name="22">
<Value>CRXTX</Value>
</Value>
<Value name="23">
<Value>CRXTXICD</Value>
</Value>
<Value name="24">
<Value>CRYZD</Value>
</Value>
<Value name="25">
<Value>CRYZDICD</Value>
</Value>
<Value name="26">
<Value>CRYZDRQ</Value>
</Value>
<Value name="27">
<Value>CRSWRQ</Value>
</Value>
<Value name="28">
<Value>CRSWYY</Value>
</Value>
<Value name="29">
<Value>CRJTSWYY</Value>
</Value>
<Value name="30">
<Value>CRSYICD</Value>
</Value>
<Value name="31">
<Value>CRBSZY</Value>
</Value>
<Value name="32">
<Value>CRSWZD</Value>
</Value>
<Value name="33">
<Value>CRZDBWDr</Value>
</Value>
<Value name="34">
<Value>CRBLXLXDr</Value>
</Value>
<Value name="35">
<Value>CRJPXBMDr</Value>
</Value>
<Value name="36">
<Value>CRCardType</Value>
</Value>
<Value name="37">
<Value>ContactOne</Value>
</Value>
<Value name="38">
<Value>RelationOne</Value>
</Value>
<Value name="39">
<Value>PhoneOne</Value>
</Value>
<Value name="40">
<Value>ContactTwo</Value>
</Value>
<Value name="41">
<Value>RelationTwo</Value>
</Value>
<Value name="42">
<Value>PhoneTwo</Value>
</Value>
<Value name="43">
<Value>ContactThr</Value>
</Value>
<Value name="44">
<Value>RelationThr</Value>
</Value>
<Value name="45">
<Value>PhoneThr</Value>
</Value>
<Value name="46">
<Value>AttackDate</Value>
</Value>
<Value name="47">
<Value>Action</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ZLK")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ZLK")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("ZLK")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportZLKS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
