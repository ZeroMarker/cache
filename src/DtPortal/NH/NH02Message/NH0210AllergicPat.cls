/// 名称:DtPortal.NH.NH02AllergicPat
/// 描述:护士长患者提示过敏患者
/// 编写者：bmz
/// 编写日期: 2014-12-08
Class DtPortal.NH.NH02Message.NH0210AllergicPat Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：  bmz
/// CreatDate： 2014-12-08  ----20150513bmz修改了过敏接口类
/// Description: 查询护士长患者提示过敏患者
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.10.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0210AllergicPat","NH021001","2156","")
Query NH021001(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,Allergen:%String,Category:%String,OnsetDateText:%String,ALGItem:%String")
{
}

ClassMethod NH021001Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s PatientID=$P($g(^PAADM(EpisodeId)),"^",1)
	.q:PatientID=""
	.Set obj=##class(%ResultSet).%New("web.DHCPAAllergy:Allergies")    // web.PAAllergy改为web.DHCPAAllergy 20150513bmz
	.d obj.Execute(PatientID)
	.s Allergen="",Category="",OnsetDateText="",ALGItem=""
	.s flag=0
	.For  Quit:'obj.Next()  Do
	..s Allergen1=obj.Data("Allergen")   //过敏源   tag,OnsetDateText
	..;q:Allergen1="" //<br>
	
	..s Category1=obj.Data("Category")  			//过敏分类---改为过敏项目  Category-----ALGItem   20150513bmz
	..s ALGItem1=obj.Data("ALGItem")
	..q:(Allergen1="")&&(ALGItem1="")
	..s OnsetDateText1=obj.Data("OnsetDateText") //过敏日期
	..s dateformat=$lg(^websys.ConfigurationD(1),10)
	..i dateformat="DMY" d
	...i OnsetDateText1["/" s OnsetDateText1=$zd($zdh(OnsetDateText1,4),3)
	..if (dateformat="MDY") d
	...i OnsetDateText1["/" s OnsetDateText1=$zd($zdh(OnsetDateText1),3)
	..i (Allergen="")&&(Category="")&&(ALGItem="") d
	...s Allergen=Allergen1
	...s Category=Category1			//过敏分类
	...s ALGItem=ALGItem1			//过敏项目
	...s OnsetDateText=OnsetDateText1 //过敏日期
	..e  d
	...s Allergen=Allergen_"<br>"_Allergen1
	...s Category=Category_"<br>"_Category1
	...s ALGItem=ALGItem_"<br>"_ALGItem1			//过敏项目
	...s OnsetDateText=OnsetDateText_"<br>"_OnsetDateText1
	..s flag=1
	
 	.q:flag=0
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 	.s bedCode=$p(patInfoStr,"^",1)
 	.s name=$p(patInfoStr,"^",2)
 	.s sex=$p(patInfoStr,"^",3)
 	.s age=$p(patInfoStr,"^",4)
 	.s medicareNo=$p(patInfoStr,"^",5)   //病案号
	.s admReason=$p(patInfoStr,"^",6)    //费用类型
 	.s regNo=$p(patInfoStr,"^",7)    //登记号
 	.s docDesc=$p(patInfoStr,"^",11)
	.s nurseDesc=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
 	.d AllergicPat
 	
  	q $$$OK
AllergicPat
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,Allergen,Category,OnsetDateText,ALGItem)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2014-12-25-----20150513bmz
/// Description: 判断过敏标记
/// Input：  AdmId         
/// Return： flag   1-有异常 2-无
/// w ##class(DtPortal.NH.NH13AllergicPat).ifPatAlg()
ClassMethod ifPatAlg(EpisodeID As %String) As %String
{
	s flag=0
	q:EpisodeID="" 0
   	s papmiId=+$g(^PAADM(+EpisodeID))
	q:papmiId=0 0
	
	Set obj=##class(%ResultSet).%New("web.DHCPAAllergy:Allergies")
	d obj.Execute(papmiId)
	s Allergen=""	//过敏源
	For  Quit:'obj.Next()  Do
	.s Allergen1=obj.Data("Allergen")   //过敏源  
	.s ALGItem=obj.Data("ALGItem")     //过敏项目
	.q:((Allergen1="")&&(ALGItem=""))||(flag=1)
	.s flag=1
	
	
   	q flag
}

// 判断过敏标记---祁工

ClassMethod getPatAlg(EpisodeID As %String) As %String
{
   //过敏w ##class(Nur.Android.Common).getPatAlg(273460)
    s papmiId=+$g(^PAADM(+EpisodeID))
  	s ret=0
  	s algSub=0
	f  s algSub=$o(^PAPER(papmiId,"ALG",algSub)) q:algSub=""  d
    .s algStr=^PAPER(papmiId,"ALG",algSub) //注意,过敏按类别走时要更新
    .s ret=1
   q ret
}

}
