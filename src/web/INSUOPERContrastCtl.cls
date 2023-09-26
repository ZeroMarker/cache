/// 名称: web.INSUOPERContrastCtl
/// 描述: 医保手术对照操作类
/// 编写者: Hanzh
/// 编写日期: 20210826
Class web.INSUOPERContrastCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: Hanzh
/// CreatDate: 2021-08-26
/// Description: 根据交易编号返回对应查询query 类方法和 query 名称
/// Return: 成功:className^queryName 或 失败:-1^错误描述
/// w ##class(web.INSUOPERContrastCtl).GetQueryNameBySource("1")
ClassMethod GetQueryNameBySource(Source)
{
	s rtn=$case(Source,  "1":"web.INSUOPERContrastCtl^HisOperInfo"            	    /*1 临床手术字典信息*/ ,
	                     "2":"web.INSUOPERContrastCtl^HisOperInfo"      			/*2 病案编目手术字典信息*/,
	                     "3":"web.INSUOPERContrastCtl^QueryOperInfo"         		/*3 手麻手术信息*/,
	                     :"-1^错误交易代码")                                                     
	q rtn
}

/// Creator: Hanzh
/// CreatDate: 2021-08-26
/// Description: 查询取数据
/// Table: User.ORCOperation
/// Input:	    rowid: 手术指针
///             OperSource:数据来源：1:临床手术字典，2:病案编目手术字典，3：第三方系统数据(例如，手术是第三方的数据)
/// 			ConType: 对照类型(A:所有,Y:已对照,N:未对照)
/// 			code: 手术代码
/// 			desc: 手术名称
/// 			insutype: 医保类型
/// 			HospDr: 院区Dr
///             SouceVer:来源版本号  +DingSH 20220215
/// Return: Rowid^手术表Dr^手术编码^手术名称^数据来源^ConID^医保手术Dr^医保手术代码^医保手术名称^生效日期^失效日期^对照人^系统对照标识^审核状态^审核人^审核日期^备注
/// Other:	d ##class(%ResultSet).RunQuery("web.INSUOPERContrastCtl","HisOperInfo","","1","Y","","","00A","2","")
Query HisOperInfo(rowid As %String, OperSource As %String, ConType As %String, code As %String, desc As %String, insutype As %String = "00A", HospDr As %String = "2", SouceVer As %String = "") As websys.Query(ROWSPEC = "Rowid,HisOperDr,HisOperCode,HisOperDesc,Source,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,HisNote,VerCode,VerDesc,InsuVer,InsuVerDesc")
{
}

ClassMethod HisOperInfoExecute(ByRef qHandle As %Binary, rowid As %String, OperSource As %String, ConType As %String, code As %String, desc As %String, insutype As %String = "00A", HospDr As %String = "2", SouceVer As %String = "") As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:$g(OperSource)="" $$$OK
	s ^tmp("QueryHisOper")=$lb(rowid,OperSource,ConType,code,desc,insutype,HospDr,SouceVer)
	s (INOPTOperDr,HisOperDr,HisOperCode,HisOperDesc)=""
	set Row=0
	if (OperSource="1"){
		s (VerID,VerCode,VerDesc)=""
		set rss=##Class(%ResultSet).%New("web.DHCBL.CT.Arcim:GetDataForCmbOper1")
		if rss.QueryIsValid() { 		;判断Query 是否有效
			;rowid^code^desc^versiondr	his手术Dr^his手术代码^his手术Dr名称^his版本号Dr
			Set Status=rss.Execute(rowid,code,desc,"")
			Set qHandle=$lb(0,repid,0)
			Set columns = rss.GetColumnCount()
			While rss.Next() {
				set Row=Row+1
				s INOPTOperDr=rss.GetDataByName("OPERRowId")	;通过列名获取对应数据
				s HisOperCode=rss.GetDataByName("OPERCode")	
				s HisOperDesc=rss.GetDataByName("OPERDesc")	
				;+20230118 HanZH 版本信息取值新增
				s VerID=rss.GetDataByName("OPERVersionDictDR")	
				s VerCode=rss.GetDataByName("VersionCode")	
				;s VerCode="SSLCB3.0"		;测试写死
				s VerDesc=rss.GetDataByName("VersionName")
				;s VerDesc="手术国家临床版3.0"	 ;测试写死
				d BuildConQuery
			}
		}
	}
	//if (OperSource="2")&(OperSource="3"){
	if (OperSource="2"){
		set rss=##Class(%ResultSet).%New("MA.IPMR.IOSrv.DirectConn.MR.ForInsurance:QryFPICD")
		if rss.QueryIsValid() { 		;判断Query 是否有效
			;OPERRowId^OPERCode^OPERDesc	his手术Dr^his手术代码^his手术Dr名称^版本号Id^
			Set Status=rss.Execute("O",SourceVer,code_desc)
			Set qHandle=$lb(0,repid,0)
			Set columns = rss.GetColumnCount()
			While rss.Next() {
				set Row=Row+1
				s INOPTOperDr=rss.GetDataByName("ICDID")	;通过列名获取对应数据
				s HisOperCode=rss.GetDataByName("ICD10")	
				s HisOperDesc=rss.GetDataByName("ICDDesc")
				s VerID=rss.GetDataByName("ICDVerID")	
				s VerCode=""
				s VerDesc=""	
				d BuildConQuery
			}
		}
	}
	//第三方导入数据
	if (OperSource="3"){
	   
	}
  
  Quit $$$OK
   
BuildConQuery 	
	q:(SouceVer'="")&&(VerCode'=SouceVer)		;+20230118 HanZH 院内版本号过滤条件新增
	s Rowid=INOPTOperDr	//Rowid
	s (HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,EfDate,InsuVer,InsuVerDesc)=""
	;s OperConStrs=##class(web.INSUOPERContrastCtl).GetIOConInfo(OperSource,INOPTOperDr,insutype,"",HospDr,VerID) //+DingSH 20220215 增加VerID入参
	s OperConStrs=##class(web.INSUOPERContrastCtl).GetIOConInfo(OperSource,INOPTOperDr,insutype,"",HospDr,VerCode) //upt HanZH 20230203 增加VerCode入参
	s Source=##class(web.INSUDicDataCom).GetDicDataDescByCode("OPERSource",OperSource,HospDr)	//数据来源
	i OperConStrs'="" d
	.s CurDate=$p($h,",",1)
	.f OperConindex=1:1:$l(OperConStrs,"!") d
	..s OperConStr=$p(OperConStrs,"!",OperConindex)
	..s ActDateCon=$p(OperConStr,"^",11)	//生效日期
	..q:(ActDateCon="")||(ActDateCon>CurDate)  ;判断ActDate是否是空,且是否大于当前日期
	..q:ActDateCon<+EfDate	
	..s EfDate=ActDateCon
	..s:EfDate'="" ConActDate=$zdt(EfDate,3)
	..s HisOperDr=$p(OperConStr,"^",2)		//手术表Dr
	..s HisNote=$p(OperConStr,"^",6)		//备注
	..s ConId=$p(OperConStr,"^",7)			//对照指针
	..s INSUdigDr=$p(OperConStr,"^",8)
	..s INSUDigCode=$p(OperConStr,"^",9)	//医保手术代码
	..s INSUDigDesc=$p(OperConStr,"^",10)	//医保手术名称
	..s ConExpDate=$p(OperConStr,"^",12)	//失效日期
	..s ConUser=$p(OperConStr,"^",13)	    //操作员
	..s InsuVer=$p(OperConStr,"^",15)	    //医保版本号 +20230118 HanZH
	..s:InsuVer'="" InsuVerDesc=$p(##class(web.DHCINSUPortUse).GetDictInfoByCode(InsuVer),"^",4)	;根据版本号代码取名称(平台组接口)
	q:(ConType="Y")&(ConId="")   //查询已对照的手术
	q:(ConType="N")&(ConId'="")	//查询未对照的手术
	d Outputbld
	q
	
Outputbld
    set Data=$lb(Rowid,HisOperDr,HisOperCode,HisOperDesc,Source,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,HisNote,VerCode,VerDesc,InsuVer,InsuVerDesc)
 	set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Creator：     Hanzh
/// CreatDate：   2021-08-26
/// Description:  查询医保手术
/// Input：       
///          QryType:检索类型
///          HospDr:医院Id(CT_Hospital,不能为空)
///          HiType:医保类型(00A)
///          Ver:医保版本号Id	20230117
///          Code:目录编码(关键字)
///          Desc:目录编码(关键字)
Query QueryInsuOperList(QryType, KWords, HospDr = "2", HiType = "00A", Ver = "") As websys.Query(CONTAINID = 1, ROWSPEC = "Ind,INDISRowid:%String,ssbm:%String,ssmc:%String,HospDr:%String:%String,HiType:%String,OprnStdListId:%String,Cpr:%String,CprCodeScp:%String,Cprname:%String,CGyCode:%String,CgyName:%String,SorCode:%String,SorName:%String,DtlsCode:%String,DtlsName:%String,OprnOprtCode:%String,OprnOprtName:%String,UsedStd:%String,RtlOprnOprtCode:%String,RtlOprnOprtName:%String,ClncOprnOprtCode:%String,ClncOprnName:%String,Memo:%String,ValiFlag:%String,Rid:%String,CrteTime:%String,UpdtTime:%String,Ver:%String,VerName:%String,HisBatch:%String,HisCrterId:%String,HisCrteDate:%String,HisCrteTIme:%String,HisUpdtId:%String,HisUpdtDate:%String,HisupdtTime:%String,Ver:%String,VerDesc:%String")
{
}

/// d ##Class(%ResultSet).RunQuery("web.INSUOPERContrastCtl","QueryInsuOperList","1","KL","2","00A","")
ClassMethod QueryInsuOperListExecute(ByRef qHandle As %Binary, QryType, KWords, HospDr = "2", HiType = "00A", Ver = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s ^tmp("QueryInsuOperList")=$lb(QryType,KWords,HospDr,HiType,Ver)
	q:$g(HiType)="" $$$OK
	s Flag=0
	//根据代码模糊查询
	i (QryType="1")&&(KWords '="") d
	.s OprtCode=""
	.f  s OprtCode=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospDr,OprtCode)) q:OprtCode=""  d
	..q:(KWords'="")&&($zcvt(OprtCode,"U")'[$zcvt(KWords,"U"))
	..s RowId=""
	..f  s RowId=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospDr,OprtCode,RowId)) q:RowId=""  d
	...d BdLInfo
	...s Flag=1
	//根据描述模糊查询
	i (QryType="2")&&(Flag'=1) d
	.s OprtName=""
	.f  s OprtName=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtName",HospDr,OprtName)) q:OprtName=""  d
	..s tmpPYM=##class(web.DHCINSUPort).GetCNCODE(OprtName,4)
	..s PYM=$zcvt(KWords,"U")
	..q:(KWords'="")&&((OprtName'[KWords)&&(tmpPYM'[PYM))
	..s RowId=""
	..f  s RowId=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtName",HospDr,OprtName,RowId)) q:RowId=""  d
	...d BdLInfo
	Quit $$$OK
BdLInfo
	s TMPInfo=$g(^CT.INSU.MI.OPRNOPRTLISTD(RowId))
	s tHiType=$lg(TMPInfo,3)
	q:tHiType'=HiType
	//+20230117 HanZH 医保版本号过滤
	s tVer=$lg(TMPInfo,35)
	q:(Ver'="")&&(tVer'=Ver)
	s tVerDesc=""
	b ;01
	i tVer'="" d
	.s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(tVer)
	.s tVerDesc=$p(DictStr,"^",4)			 //医保版本号名称
	//st格式化数据
	 s (HiscrteDate,HiscrteTime,HisupdtDate,HisupdtTime)=""
	 i $lg(TMPInfo,30)'="" d
	 .s HiscrteDate=$zd($lg(TMPInfo,30),3)   //HIS创建日期 
	 i $lg(TMPInfo,31)'="" d
	 .s HiscrteTime=$zt($lg(TMPInfo,31))     //HIS创建时间
	 i $lg(TMPInfo,33)'="" d
	 .s HisupdtDate=$zd($lg(TMPInfo,33),3)   //HIS更新日期
	 i $lg(TMPInfo,34)'="" d
	 .s HisupdtTime=$zt($lg(TMPInfo,34))     //HIS创建时间
	//ed格式化数据
	d BuildQry
	set qHandle=$lb(0,repid,0)
	quit $$$OK
BuildQry 	
	set Data=$lb(ind,RowId,$lg(TMPInfo,14),$lg(TMPInfo,15),$lg(TMPInfo,2),$lg(TMPInfo,3),$lg(TMPInfo,4),$lg(TMPInfo,5),$lg(TMPInfo,6),$lg(TMPInfo,7),$lg(TMPInfo,8),$lg(TMPInfo,9),$lg(TMPInfo,10)
	,$lg(TMPInfo,11),$lg(TMPInfo,12),$lg(TMPInfo,13),$lg(TMPInfo,14),$lg(TMPInfo,15),$lg(TMPInfo,16),$lg(TMPInfo,17),$lg(TMPInfo,18),$lg(TMPInfo,19),$lg(TMPInfo,20)
	,$lg(TMPInfo,21),$lg(TMPInfo,22),$lg(TMPInfo,23),$lg(TMPInfo,24),$lg(TMPInfo,25),$lg(TMPInfo,26),$lg(TMPInfo,27),$lg(TMPInfo,28),$lg(TMPInfo,29)
	,HiscrteDate,HiscrteTime,$lg(TMPInfo,32),HisupdtDate,HisupdtTime,tVer,tVerDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Hanzh 20210831
/// 保存手术对照
/// 入参：Args   手术对照数据
/// 出参："-1"：失败     
/// w ##class(web.INSUOPERContrastCtl).SaveCont("^1^00.0100^头和颈部血管治疗性超声^22^00.0100^头和颈部血管治疗性超声^1^00A^2021-11-01^^1^^^^^^^^^^2^SSLCB3.0^SSGJYBB2.0")
/// 注意数据来源的版本号 
ClassMethod SaveCont(Args As %String) As %String
{
	s ^temp("SaveOperCon")=Args
	s RtnStr=""
	s (OperCode,Source,HospDr,InsuType,EfDate,ConDate,HisVer,InsuVer)=""
	s OperCode=$p(Args,"^",3)
	s Source=$p(Args,"^",8)
	s HospDr=$p(Args,"^",22)
	s InsuType=$p(Args,"^",9)
	s ConDate=$p(Args,"^",10)
	s SourceVer=$p(Args,"^",18) //+DingSH20220215
	s:$l(Args,"^")>22 HisVer=$p(Args,"^",23),InsuVer=$p(Args,"^",24)	;+HanZH 20230210 新增版本号
	q:$p(Args,"^",23)="" "-1!院内版本号为空"	//医保手术对照版本号必填控制	+20230518 HanZH 
	q:$p(Args,"^",24)="" "-1!医保版本号为空"	//医保手术对照版本号必填控制	+20230518 HanZH 
	s ConDate=##class(websys.Conversions).DateHtmlToLogical(ConDate)
	s IOConStr=##class(web.INSUOPERContrastCtl).GetInsuOperConInfo(OperCode,Source,HospDr,InsuType,HisVer,InsuVer)
	i IOConStr'="" d
	.s EfDate=$p(IOConStr,"^",10)
	s CurDate=$p($h,",",1)
	b ;000
	q:ConDate<=EfDate "-1!已存在该生效日期或之后的有效对照项目，不允许对照！"
	q:ConDate>CurDate "-1!生效日期在当前日期之后，不允许对照！"
	s RtnStr=##class(INSU.MI.BL.INSUOPERConTrast).SaveCont(Args)
	
	//+20230117 HanZH 推送对照信息到病案
	i (+RtnStr>0)&($l(Args,"^")>22) {
		s $p(Args,"^",1)=+RtnStr
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(Args,"oper")
		q:+sendRtn<0 sendRtn
	}
	q RtnStr
}

Query QueryOperCon(OperSource As %String, ExpStr As %String, HospDr As %String = "2", SourceVer As %String = "") As websys.Query(ROWSPEC = "Rowid,HisdigCode,HisOperCode,HisOperDesc,Soure,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,HisVer,Ver,HisVerDesc,VerDesc")
{
}

/// Creator：     Hanzh
/// CreatDate：   2021-08-26
/// Description:  查询医保手术对照
/// Input:	 ExpStr:	医保类型@医保手术对照指针(INSU_OPERContrast)@ 生效日期 
/// 		 HospDr:	院区Dr
/// 
/// Output:	Rowid^医院诊断码^手术编码^手术名称^数据来源^备注^ConID^医保手术Dr^医保手术代码^医保手术名称^生效日期^失效日期^对照人^系统对照标识^审核状态^审核人^审核日期	
/// d ##class(%ResultSet).RunQuery("web.INSUOPERContrastCtl","QueryOperCon","1","00A@240",2,"")
ClassMethod QueryOperConExecute(ByRef qHandle As %Binary, OperSource As %String, ExpStr As %String, HospDr = "2", SourceVer As %String = "") As %Status
{
	s ^CacheTemp("OperConQuery")=$lb(OperSource, ExpStr, HospDr, SourceVer)
	s (Rowid,HisdigCode,HisOperCode,HisOperDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,HisVeDesc,VerDesc)=""
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0) 
	q:$g(OperSource)="" $$$OK
	s insutype=$p($G(ExpStr),"@",1)
	s INSUDIid=$p($G(ExpStr),"@",2)
	s ActDate=$p($G(ExpStr),"@",3)
	s:ActDate'="" ActDate=##class(websys.Conversions).DateHtmlToLogical(ActDate)	
	s:ActDate="" ActDate=+$h
	if INSUDIid="" Set qHandle=$lb(0,repid,0) quit $$$OK
	s OperConStrs=##class(web.INSUOPERContrastCtl).GetIOConInfo(OperSource,INSUDIid,insutype,"",HospDr,SourceVer)
	s Source=##class(web.INSUDicDataCom).GetDicDataDescByCode("OPERSource",OperSource,HospDr)
	f OperConindex=1:1:$l(OperConStrs,"!") d
	.s OperConStr=$p(OperConStrs,"!",OperConindex)
	.q:OperConStr=""
	.s Rowid=$p(OperConStr,"^",1)
	.s HisdigCode=$p(OperConStr,"^",2)
	.s HisOperCode=$p(OperConStr,"^",3)
	.s HisOperDesc=$p(OperConStr,"^",4)
	.s HisNote=$p(OperConStr,"^",6)
	.s ConId=$p(OperConStr,"^",7)
	.s INSUdigDr=$p(OperConStr,"^",8)
	.s INSUDigCode=$p(OperConStr,"^",9)
	.s INSUDigDesc=$p(OperConStr,"^",10)
	.s ConActDate=$p(OperConStr,"^",11)
	.s:ConActDate'="" ConActDate=$zdt(ConActDate,3)
	.s ConExpDate=$p(OperConStr,"^",12)
	.s ConUser=$p(OperConStr,"^",13)
	.s HisVerDr=$p(^ORC("OPER",HisdigCode),"^",41) //+HanZH 20220215 院内版本号
	.s:HisVerDr'="" HisVerDesc=$p(##class(web.DHCINSUPortUse).GetDictInfoByRowId(HisVerDr),"^",3)	;根据版本号Rowid取名称
	.s Ver=$p(OperConStr,"^",15) 		 //+HanZH 20230203 医保版本号
	.s:Ver'="" VerDesc=$p(##class(web.DHCINSUPortUse).GetDictInfoByCode(Ver),"^",4)		;根据版本号代码取名称
	.d BuildconQuery
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildconQuery
	set Data=$lb(Rowid,HisdigCode,HisOperCode,HisOperDesc,Soure,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,HisVer,Ver,HisVerDesc,VerDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Hanzh 20210908
/// 导入手术对照
/// 入参：入参第46位=院区
/// 出参："-1"：失败     
/// w ##class(web.INSUOPERContrastCtl).Update("")
ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String) As %Library.String
{
	;w ##class(web.INSUTarItemsCom).Update("","","439812^0^QZA^15001336^立体定向脑深部核团毁损术^LTDXNSBHTHSS^#^1^^^^^^0^^0^0^0^40^1^保守治疗无效的以下疾病：①难治性帕金森氏病；②难治性舞蹈病；③难治性扭转痉挛；④难治性癫痫。^1^^^^")
	;s ^zmc("edit")=InString
	q:InString="" -100
	s:($p(InString,"^",46)="")&&($g(%session.Data("DHCBILLINSUCloud.Hospital"))'="") $p(InString,"^",46)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
    //s flag=##class(INSU.BL.INSUOPERConTrast).SaveCont(InString)
    s flag=##class(INSU.MI.BL.INSUOPERConTrast).SaveCont(InString)
	s Update=flag
	q Update
}

/// Hanzh 20210831
/// 删除手术对照
/// 入参：Args   手术对照Dr
/// 出参："-1"：失败     
/// w ##class(web.INSUOPERContrastCtl).DelCont("")
ClassMethod DelCont(Args As %String) As %String
{
	s RtnStr=""
	q:+Args<1 "-1"
	
	//st 删除对照前先推送同步到病案 +20230206 HanZH
	s IOConStr=##class(INSU.MI.BL.INSUOPERConTrast).GetInsuOperConInfoById(Args)
	if (+IOConStr>0) {
		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(IOConStr,"oper","0")
		q:+sendRtn<0 sendRtn
	}
	//ed
	
	//s RtnStr=##class(INSU.BL.INSUOPERConTrast).Delete(Args)
	s RtnStr=##class(INSU.MI.BL.INSUOPERConTrast).Delete(Args)

	//st 删除对照后需要把当前生效的对照关系推送到病案 +20230206 HanZH
	if (+RtnStr>=0) {
		s HisDr=$p(IOConStr,"^",2)
		s InsuType=$p(IOConStr,"^",9)
		s HospDr=$p(IOConStr,"^",22)
		s ActDate=+$h
		s ConString=##class(INSU.MI.BL.INSUOPERConTrast).CheckCon(HisDr,InsuType,ActDate,HospDr)
		s ConId=$p(ConString,"!",2) 
		q:ConId="" RtnStr_"!删除手术对照成功,同步病案系统成功"
		s IOConStrNew=##class(INSU.MI.BL.INSUOPERConTrast).GetInsuOperConInfoById(ConId)
		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(IOConStrNew,"oper")
		q:+sendRtn<0 RtnStr=+RtnStr_"!删除手术对照成功,同步病案系统成功"
	}
	//ed

	q RtnStr
}

/// Hanzh 20210903
/// 查询手术对照信息
/// 入参: 	Source:		数据来源
/// 		OperDr:		手术Dr
/// 		insutype: 	医保类型(可以是默认值不传 使用国家医保)
/// 		ActDate:	生效日期
/// 		HospDr：	医院Dr
/// 		SourceVer：	数据来源版本 +DingSH 20220215
/// 出参："-1"：失败信息
/// 			成功：Rowid^手术表Dr^手术编码^手术名称^数据来源^备注^ConID^医保手术Dr^医保手术代码^医保手术名称^生效日期^失效日期^对照人^系统对照标识^审核状态^审核人^审核日期^医保版本号
/// w ##class(web.INSUOPERContrastCtl).GetIOConInfo("2","8519","00A","","2","2")
ClassMethod GetIOConInfo(Source As %String, OperDr As %String, insutype As %String = "00A", ActDate As %String, HospDr As %String = "2", SourceVer As %String = "") As %String
{
	s OutStr=""
	
	//s ConString=##class(INSU.BL.INSUOPERConTrast).CheckCon(OperDr,insutype,ActDate,HospDr,Source,SourceVer)
	//i Source="1" d -DingSH 20220215 
	.//s OutStr=##class(web.INSUOPERContrastCtl).GetIOConInfoFromHis(OperDr,insutype,ActDate,HospDr)	;/*1 His手术信息*/
	s OutStr=##class(web.INSUOPERContrastCtl).GetIOConInfoFromHis(OperDr,insutype,ActDate,HospDr,Source,SourceVer)	    ;//取手术对照信息
	/* 注释掉 - DingSH 20220215 
	i (Source="2")&(Source="2") d  
	.s OutStr=##class(web.INSUOPERContrastCtl).GetIOConInfoFromInsuOper(OperDr,insutype,ActDate,HospDr)	;/2 病案手术信息//3 手麻手术信息/
	*/
	q OutStr
}

/// Hanzh 20210903
/// 查询手术对照信息
/// 入参: 	OperDr:		手术Dr
/// 		insutype: 	医保类型(可以是默认值不传 使用国家医保)
/// 		ActDate:	生效日期
/// 		HospDr：	医院Dr
/// 出参："-1"：失败信息
/// 			成功：Rowid^手术表Dr^手术编码^手术名称^数据来源^备注^ConID^医保手术Dr^医保手术代码^医保手术名称^生效日期^失效日期^对照人^系统对照标识^审核状态^审核人^审核日期^医保版本号
/// w ##class(web.INSUOPERContrastCtl).GetIOConInfoFromHis("3450","00A","","2","2","2")
ClassMethod GetIOConInfoFromHis(OperDr As %String, insutype As %String = "00A", ActDate As %String, HospDr As %String = "2", Source As %String = "", SourceVer As %String = "") As %String
{
	s OutStr=""
	//s ConString=##class(INSU.BL.INSUOPERConTrast).CheckCon(OperDr,insutype,ActDate,HospDr,Source,SourceVer)
	s ConString=##class(INSU.MI.BL.INSUOPERConTrast).CheckCon(OperDr,insutype,ActDate,HospDr,Source,SourceVer)
	f index=2:1:$l(ConString,"!") d
	.s ConId=$p(ConString,"!",index)	//对照ID
	.s (Rowid,HisOperDr,HisOperCode,HisOperDesc,Source,HisNote,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,DataSourceVer,InsuVer)=""
	.i ConId'="" d
	..s conList=$g(^User.INSUOPERContrastD(ConId))
	..s conStr=$LISTTOSTRING(conList,"^",1)
	..//s hisdigdr=$p(conStr,"^",2)
	..//s Downinfo=^ORC("OPER",hisdigdr)
	..s Rowid=OperDr	//Rowid
	..//s HisdigCode=$p(conStr,"^",2)		//HISICD诊断代码
	..s HisOperDr=$p(conStr,"^",2)			//手术表Dr
	..//s HisOperCode=$p(Downinfo,"^",1)	//HIS手术代码
	..//s HisOperDesc=$p(Downinfo,"^",2)	//HIS手术名称
	..s HisOperCode=$p(conStr,"^",3)	   //HIS手术代码
	..s HisOperDesc=$p(conStr,"^",4)	   //HIS手术名称
	..s Source=$p(conStr,"^",8)			//手术来源
	..s HisNote=$p(conStr,"^",17)		//备注
	..s DataSourceVer=$p(conStr,"^",18)	//数据源版本 DingSH 20220215 
	..s INSUdigDr=$p(conStr,"^",5)
	..i INSUdigDr'="" d 
	...s ConUserDr=$p(conStr,"^",12)	//对照人
	...s UserStr="^^^^^^^^^^^^"
	...s OutList=$g(^CT.INSU.MI.OPRNOPRTLISTD(INSUdigDr))
	...s ConActDate=$p(conStr,"^",10)	//生效日期
	...;s:ConActDate'="" ConActDate=##class(websys.Conversions).DateLogicalToHtml(ConActDate)
	...i $ll(OutList)>4 d
	....s:ConUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(ConUserDr)
	....s INSUDigCode=$list(OutList,14)		//医保手术
	....s INSUDigDesc=$list(OutList,15)		//医保手术名称
	....s ConExpDate=""	;$zd(+$h+3650,3)	//失效日期
	....s ConUser=$p(UserStr,"^",2)			//操作员
	....s InsuVer=$lg(OutList,35)	//医保版本号 HanZH 20230118
	.i OutStr="" s OutStr=Rowid_"^"_HisOperDr_"^"_HisOperCode_"^"_HisOperDesc_"^"_Source_"^"_HisNote_"^"_ConId_"^"_INSUdigDr_"^"_INSUDigCode_"^"_INSUDigDesc_"^"_ConActDate_"^"_ConExpDate_"^"_ConUser_"^"_DataSourceVer_"^"_InsuVer
	.e  s OutStr=OutStr_"!"_Rowid_"^"_HisOperDr_"^"_HisOperCode_"^"_HisOperDesc_"^"_Source_"^"_HisNote_"^"_ConId_"^"_INSUdigDr_"^"_INSUDigCode_"^"_INSUDigDesc_"^"_ConActDate_"^"_ConExpDate_"^"_ConUser_"^"_DataSourceVer_"^"_InsuVer
	q OutStr
}

/// Hanzh 20210831
/// 查询手术对照
/// 入参: 	OperCode:	手术编码
/// 		Source: 	数据来源
/// 		HospDr：	医院Dr
/// 		InsuType:	医保类型(可以是默认值不传 使用国家医保)，
/// 		SourceVer:	数据来源版本 ，+DingSH 20220215
/// 		Ver:		医保版本 ，+HanZH 20230117
/// 出参："-1"：失败信息
/// 			成功：对照Dr^手术Dr^手术代码^手术名称^医保手术表Dr^医保手术代码^医保手术名称^数据来源^医保字典类型^生效日期^失效日期^对照人^对照日期^对照时间^添加IP^唯一标识^备注^数据来源版本ID^预留串3^预留串4^预留串5^院区ID    
/// w ##class(web.INSUOPERContrastCtl).GetInsuOperConInfo("00.0100","1","2","00A","SSLCB3.0","SSGJYBB2.0")
ClassMethod GetInsuOperConInfo(OperCode As %String, Source As %String, HospDr As %String = "2", InsuType As %String = "00A", SourceVer As %String = "", Ver As %String = "") As %String
{
	s ^temp("GetInsuOperConInfo")=$lb(OperCode,Source,HospDr,InsuType,SourceVer,Ver)
	q:OperCode="" "-1!手术代码不能为空！"
	q:Source="" "-1!数据来源不能为空！"
	q:HospDr="" "-1!院区不能为空！"
	q:$d(^User.INSUOPERContrastI("IdxINOPTOperCode",OperCode))=0 "-1!该手术代码没有对照数据"
	s OutStr="-1"
	s (INOPTSource,ConActDate,INOPTDicType,INOPTHospDr,EfDate)=""
	s CurDate=$p($h,",",1)
	s INOPTId=""
	f  s INOPTId=$o(^User.INSUOPERContrastI("IdxINOPTOperCode",OperCode,INOPTId),-1) q:(INOPTId="")  d
	.s INOPTList=$g(^User.INSUOPERContrastD(INOPTId))
	.s INOPTSource=$list(INOPTList,8)
	.q:INOPTSource'=Source
	.s ConActDate=$list(INOPTList,10)
	.q:(ConActDate="")||(ConActDate>CurDate)  ;判断ActDate是否是空,且是否大于当前日期
	.q:ConActDate<+EfDate
	.s EfDate=ConActDate
	.s INOPTDicType=$list(INOPTList,9)
	.q:INOPTDicType'=InsuType
	.s INOPTHospDr=$list(INOPTList,22)
	.q:INOPTHospDr'=HospDr
	.;s INOPTSourceVer=$list(INOPTList,18) //+DingSH 20220215
	.;q:INOPTSourceVer'=SourceVer
	.;s INOPTVer=$list(INOPTList,19) //+HanZH 20230117
	.;q:INOPTVer'=Ver
	.s OutStr=INOPTId_"^"_$list(INOPTList,2)_"^"_$list(INOPTList,3)_"^"_$list(INOPTList,4)_"^"_$list(INOPTList,5)
	.s OutStr=OutStr_"^"_$list(INOPTList,6)_"^"_$list(INOPTList,7)_"^"_$list(INOPTList,8)_"^"_$list(INOPTList,9)_"^"_$list(INOPTList,10)
	.s OutStr=OutStr_"^"_$list(INOPTList,11)_"^"_$list(INOPTList,12)_"^"_$list(INOPTList,13)_"^"_$list(INOPTList,14)_"^"_$list(INOPTList,15)
	.s OutStr=OutStr_"^"_$list(INOPTList,16)_"^"_$list(INOPTList,17)_"^"_$list(INOPTList,18)_"^"_$list(INOPTList,19)_"^"_$list(INOPTList,20)
	.s OutStr=OutStr_"^"_$list(INOPTList,21)_"^"_$list(INOPTList,22)
	
	q OutStr
}

/// 导入手术对照
/// Hanzh 20211014
/// 入参：Args  手术对照数据
/// 出参："-1"：失败     
/// w ##class(web.INSUOPERContrastCtl).SaveInOperCon("^^00.0100^头和颈部血管治疗性超声^^00.0100^头和颈部血管治疗性超声^1^00A^2021-11-01^^1^^^^^^^^^^2^SSLCB3.0^SSGJYBB2.0")
ClassMethod SaveInOperCon(Args As %Library.String) As %Library.String
{
	s ^tmp("SaveInOperCon")=Args
	s RtnStr=""
	s (hiscode,Source,HospDr,InsuType,EfDate,ConDate,SourceVer)=""
	s hiscode=$p(Args,"^",3)
	s insucode=$p(Args,"^",6)
	s Source=$p(Args,"^",8)
	s HospDr=$p(Args,"^",22)
	s InsuType=$p(Args,"^",9)
	s ConDate=$p(Args,"^",10)
	s SourceVer=$p(Args,"^",18)
	q:hiscode="" -1011
	q:insucode="" -1021
	
	s hiscode2=$$ALPHAUP^SSUTIL4(hiscode)
	;q:(Source="1")&&($d(^ORC("OPER",0,"Code",hiscode2))=0) -1012
	q:(Source="1")&&($d(^ORC("OPER",0,"ICD10",hiscode))=0) -1012	;upt 20220402	有项目存在手术代码和ICD10不一致情况
	q:(Source="2")&&($d(^CT.IPMR.FP.ICDDxI("IndexICD10",SourceVer," "_$zcvt(hiscode,"U")))=0) -1012	;upt 20220330 Hanzh
	q:($d(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospDr,insucode))=0) -1022
	s Tarid="",TmpTarid=""
	//	临床手术字典
	i Source="1"  d
	.f  s TmpTarid=$o(^ORC("OPER",0,"ICD10",hiscode,TmpTarid)) q:TmpTarid=""  d
	..s OperDesc=$p($g(^ORC("OPER",TmpTarid)),"^",2)
	..s OperCode=$p($g(^ORC("OPER",TmpTarid)),"^",1)
	..i OperCode=hiscode d
	...s Tarid=TmpTarid
	//	病案编目手术字典
	i Source="2"  d
	.f  s TmpTarid=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",SourceVer," "_$zcvt(hiscode,"U"),TmpTarid)) q:TmpTarid=""  d
	..s FIICDInfo=$g(^CT.IPMR.FP.ICDDxD(TmpTarid))
	..s OperDesc=$list(FIICDInfo,3)
	..s OperCode=$list(FIICDInfo,5)
	..i OperCode=hiscode d
	...s Tarid=TmpTarid 
	
	//	第三方导入数据
	i Source="3"  d
	
	q:Tarid="" -1013
	s tempid="",Insuid=""
	f  s tempid=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospDr,insucode,tempid)) q:tempid=""  d
	.s InsuOperCode=$list(^CT.INSU.MI.OPRNOPRTLISTD(tempid),14)
	.s InsuOperDesc=$list(^CT.INSU.MI.OPRNOPRTLISTD(tempid),15)
	.i (InsuOperCode=insucode) d
	..s Insuid=tempid
	q:Insuid="" -1023
	s $p(Args,"^",2)=Tarid
	s $p(Args,"^",5)=Insuid
	s RtnStr=..SaveCont(Args)

	q RtnStr
}

}
