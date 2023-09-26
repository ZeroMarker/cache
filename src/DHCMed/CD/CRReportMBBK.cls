/// 名称: DHCMed.CD.CRReportMBBK
/// 描述: 苏州慢性病报病卡
/// 编写者：pylian
/// 编写日期: 2016-04-27
Class DHCMed.CD.CRReportMBBK Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主表ID
Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildMBBK ];

/// 卡片编号
Property CRKPBH As %String;

/// 报告卡类型CRMBReportType
Property CRBGKLX As DHCMed.SS.Dictionary;

/// 发病日期
Property CRFBRQ As %Date;

/// 是否发病日期为估计
Property CRSFFBRQGJ As DHCMed.SS.Dictionary;

/// 确诊日期
Property CRQZRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// 死亡原因
Property CRSWYY As DHCMed.SS.Dictionary;

/// 死亡具体原因
Property CRJTSWYY As %String(MAXLEN = 200);

/// 死亡诊断
Property CRSWZD As %String;

/// 死因ICD-10
Property CRSWICD As %String;

/// 诊断依据 List of DHCMed.SS.Dictionary
Property CRZDYJ As list Of DHCMed.SS.Dictionary;

/// 最高诊断单位
Property CRQZDW As DHCMed.SS.Dictionary;

/// 冠心病诊断
Property CRGXBZD As DHCMed.SS.Dictionary;

/// 脑卒中诊断
Property CRNCZZD As DHCMed.SS.Dictionary;

/// 糖尿病诊断
Property CRTNBZD As DHCMed.SS.Dictionary;

/// 诊断编码 ICD10
Property CRZDBM As %String;

/// 诊断名称 肿瘤病名
Property CRZDMC As %String;

/// 更正诊断
Property CRGZZD As %String;

/// 更正诊断ICD-10
Property CRGZZDICD As %String;

/// 更正诊断日期
Property CRGZZDRQ As %Date;

/// 原发部位
Property CRYFBW As %String;

/// 继发(转移)部位
Property CRJFBW As %String;

/// 病理学类型
Property CRBLXLX As %String;

/// 病理号
Property CRBLH As %String;

/// 上报位置
Property CRSBWZ As DHCMed.SS.Dictionary;

/// Creator：     pylian
/// CreatDate：   2016-04-27
/// Description:  根据ID取报卡信息
/// Table：       DHCMed.CD.CRReportMBBK
/// Input：       ID:    DHCMed.CD.CRReportMBBK.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportMBBK).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportMBBK
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportMBBK).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportMBBK).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取心脑血管报卡信息
/// Table：       DHCMed.CD.CRReportMBBK
/// Input：       ID:    DHCMed.CD.CRReportMBBK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportMBBK
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"MBBK",0))
	Set obj=##class(DHCMed.CD.CRReportMBBK).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	
	new (separete,Languages)
	Set return=..CRKPBH_separete            //1
	Set return=return_..GetDicByObj(..CRBGKLX,Languages)_separete  //2  报告类型
	Set FBRQ=..CRFBRQ             //发病日期
	Set:FBRQ'="" FBRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FBRQ)

	Set return=return_FBRQ_separete	//3
	
	Set return=return_..GetDicByObj(..CRSFFBRQGJ,Languages)_separete  //4
	Set QZRQ=..CRQZRQ              //确诊日期
	Set:QZRQ'="" QZRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(QZRQ)

	Set return=return_QZRQ_separete //5
	
	Set SWRQ=..CRSWRQ                //死亡日期
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)

	Set return=return_SWRQ_separete  //6 
	Set return=return_..GetDicByObj(..CRSWYY,Languages)_separete // 7死亡原因
	Set return=return_..CRJTSWYY_separete              // 8死亡具体原因
	Set return=return_..GetICDDescByID(..CRSWZD,Languages)_separete  //9死亡诊断  
    Set return=return_..CRSWICD_separete	    //10死亡编码

	
    Set ZDYJ=..CRZDYJ
	Set ZDYJstr=""
	For ind=1:1:ZDYJ.Count() {
		Set objDic=ZDYJ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set ZDYJstr=ZDYJstr_","_objDic.%Id()
	}
	Set:ZDYJstr'="" ZDYJstr=$e(ZDYJstr,2,$l(ZDYJstr))
	Set return=return_ZDYJstr_separete                 //11诊断依据
	
	Set return=return_..GetDicByObj(..CRQZDW,Languages)_separete //12诊断单位
	Set return=return_..GetDicByObj(..CRGXBZD,Languages)_separete //13冠心病诊断
	Set return=return_..GetDicByObj(..CRNCZZD,Languages)_separete //14脑卒中诊断
	Set return=return_..GetDicByObj(..CRTNBZD,Languages)_separete //15糖尿病诊断
    
    Set return=return_..CRZDBM_separete	                  //16诊断编码ICD10
    Set return=return_..GetICDDescByID(..CRZDMC,Languages)_separete //17诊断名称
    
	Set return=return_..GetICDDescByID(..CRGZZD,Languages)_separete  //18更正诊断
	//Set return=return_..CRGZZD_separete                      //18更正诊断
	Set return=return_..CRGZZDICD_separete                   //19更正诊断ICD10
	Set GZZDRQ=..CRGZZDRQ	                                 //20更正诊断日期
	Set:GZZDRQ'="" GZZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(GZZDRQ)
	Set return=return_GZZDRQ_separete	
	
	Set return=return_..CRYFBW _separete	//21 原发部位
	Set return=return_..CRJFBW_separete     //22继发(转移)部位
	Set return=return_..CRBLXLX_separete    //23 病理学类型
	Set return=return_..CRBLH_separete	    //24病理号
	Set return=return_..GetDicByObj(..CRSBWZ,Languages)_separete	    //25上报位置
    
	Quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
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
    Set ICD10=$p(tmp,"^",4)
	Set ICDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,ICDDesc)
	set return=ICDRowID_$c(1)_ICDDesc_$c(1)_ICD10
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-04-27
/// Description:  根据ParRef取慢性病报病卡信息
/// Table：       DHCMed.CD.CRReportMBBK
/// Input：       ID:    DHCMed.CD.CRReportMBBK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportMBBK).GetStringByParRef(25)
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
	
	Set obj=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     pylian
/// CreatDate：   2016-04-27
/// Description:  更新慢性病报病卡信息
/// Table：       DHCMed.CD.CRReportMBBK
/// Input：       主卡ID以及各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportMBBK).Update("","^")
ClassMethod Update(InputStr As %String, Separete As %String) As %String
{
	New (InputStr,Separete)
	Set return=0
	Quit:InputStr="" return
	
	Set Parref=$p(InputStr,Separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"MBBK",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportMBBK).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportMBBK).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set CardNo=$p(InputStr,Separete,2)           //卡片编码
    Set obj.ParRef   = ##class(DHCMed.CD.CRReport).GetObjById(Parref)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("MBBK")
	}
	Set obj.CRKPBH=CardNo
	Set RepType    = $p(InputStr,Separete,3)	//报告卡类型
	Set obj.CRBGKLX  =##class(DHCMed.SS.Dictionary).GetObjById(RepType)
	Set InfDate    = $p(InputStr,Separete,4)	//发病日期
	Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InfDate)
	
	Set obj.CRFBRQ   = InfDate
	Set IsGuessInf = $p(InputStr,Separete,5)	//是否首次发病
    Set obj.CRSFFBRQGJ = ##class(DHCMed.SS.Dictionary).GetObjById(IsGuessInf)
    Set DisDate	   = $p(InputStr,Separete,6)	//确诊日期
	Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DisDate)

	Set obj.CRQZRQ =DisDate
	Set DeathDate  = $p(InputStr,Separete,7)	//死亡日期
	Set:DeathDate["-" DeathDate=$zdh(DeathDate,3)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
    Set obj.CRSWRQ   = DeathDate
    
	Set DeathReason= $p(InputStr,Separete,8)	//死亡原因
	Set DeathReasonID=$p(DeathReason,",",1)
	Set DeathReasonDesc=$p(DeathReason,",",2)
	Set obj.CRSWYY   = ##class(DHCMed.SS.Dictionary).GetObjById(+DeathReasonID)
	Set obj.CRJTSWYY = $p(InputStr,Separete,9)  //死亡具体原因
	Set obj.CRSWZD   = $p(InputStr,Separete,10)	    //死亡诊断
	Set obj.CRSWICD   = $p(InputStr,Separete,11)	//死亡ICD	
	
	Set CRZDYJs=$p(InputStr,Separete,12)	        //诊断依据
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
	Set DiagUnit   = $p(InputStr,Separete,13)	//诊断单位
	Set obj.CRQZDW   = ##class(DHCMed.SS.Dictionary).GetObjById(+DiagUnit)
	Set GXBZD  = $p(InputStr,Separete,14)	//冠心病诊断
	Set obj.CRGXBZD	 = ##class(DHCMed.SS.Dictionary).GetObjById(+GXBZD)
	Set NCZZD  = $p(InputStr,Separete,15)	//脑卒中诊断
	Set obj.CRNCZZD	 = ##class(DHCMed.SS.Dictionary).GetObjById(+NCZZD)
	Set TNBZD  = $p(InputStr,Separete,16)	//糖尿病诊断	
	Set obj.CRTNBZD	 = ##class(DHCMed.SS.Dictionary).GetObjById(+TNBZD)
	
	Set obj.CRZDBM   = $p(InputStr,Separete,17)	//诊断编码ICD
	Set obj.CRZDMC	 = $p(InputStr,Separete,18)   //诊断名称
	Set obj.CRGZZD=$p(InputStr,Separete,19)        //更正诊断
	Set obj.CRGZZDICD=$p(InputStr,Separete,20)     //更正诊断ICD
	Set CRGZZDRQ=$p(InputStr,Separete,21)          //更正诊断日期
	Set:CRGZZDRQ'="" CRGZZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRGZZDRQ)
	Set obj.CRGZZDRQ=CRGZZDRQ	
	Set obj.CRYFBW   = $p(InputStr,Separete,22)	//原发部位
	Set obj.CRJFBW   = $p(InputStr,Separete,23)	//继发(转移)部位
	Set obj.CRBLXLX= $p(InputStr,Separete,24)	//病理学类型
	//Set obj.CRBLH   = $p(InputStr,Separete,25)	//病理号
    Set SBWZ  = $p(InputStr,Separete,25)	//上报位置
	Set obj.CRSBWZ= ##class(DHCMed.SS.Dictionary).GetObjById(SBWZ)
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
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
<Value>CRBGKLX</Value>
</Value>
<Value name="4">
<Value>CRFBRQ</Value>
</Value>
<Value name="5">
<Value>CRSFFBRQGJ</Value>
</Value>
<Value name="6">
<Value>CRQZRQ</Value>
</Value>
<Value name="7">
<Value>CRSWRQ</Value>
</Value>
<Value name="8">
<Value>CRSWYY</Value>
</Value>
<Value name="9">
<Value>CRJTSWYY</Value>
</Value>
<Value name="10">
<Value>CRSWZD</Value>
</Value>
<Value name="11">
<Value>CRSWICD</Value>
</Value>
<Value name="12">
<Value>CRZDYJ</Value>
</Value>
<Value name="13">
<Value>CRQZDW</Value>
</Value>
<Value name="14">
<Value>CRGXBZD</Value>
</Value>
<Value name="15">
<Value>CRNCZZD</Value>
</Value>
<Value name="16">
<Value>CRTNBZD</Value>
</Value>
<Value name="17">
<Value>CRZDBM</Value>
</Value>
<Value name="18">
<Value>CRZDMC</Value>
</Value>
<Value name="19">
<Value>CRYZD</Value>
</Value>
<Value name="20">
<Value>CRYZDICD</Value>
</Value>
<Value name="21">
<Value>CRYZDRQ</Value>
</Value>
<Value name="22">
<Value>CRYFBW</Value>
</Value>
<Value name="23">
<Value>CRJFBW</Value>
</Value>
<Value name="24">
<Value>CRBLXLX</Value>
</Value>
<Value name="25">
<Value>CRBLH</Value>
</Value>
<Value name="26">
<Value>CRGZZD</Value>
</Value>
<Value name="27">
<Value>CRGZZDICD</Value>
</Value>
<Value name="28">
<Value>CRGZZDRQ</Value>
</Value>
<Value name="29">
<Value>CRSBWZ</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MBBK")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<Final>1</Final>
<IdLocation>{%%PARENT}("MBBK")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("MBBK")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportMBBKS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
