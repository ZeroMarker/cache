Include webimport

IncludeGenerator webimport

/// 输血申请单和自体血采血申请单
Class web.DHCBldAppForm Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 查询历史输血申请单
/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 查询历史输血申请单
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       AppFormNumber:申请单编号,ReqDate:申请日期,ReqTime:申请时间,
/// 				   AuthDate:审核日期,AuthTime:时间,ReqDoctor:申请医生,AuthDoctor:审核医生
/// 				   IsAuthorised:是否审核,IsPrintA:是否打印输血单,IsPrintC:是否打印同意书,
/// Return：       函数返回值的说明
/// Others：       其它说明
Query QueryHistoryAppForm(admID As %String) As %Query(ROWSPEC = "AppFormNumber:%String,ReqDate:%String,ReqTime:%String,AuthDate:%String,AuthTime:%String,ReqDoctor:%String,AuthDoctor:%String,IsAuthorised:%String,IsPrintA:%String,IsPrintC:%String,OrderInfo:%String")
{
}

ClassMethod QueryHistoryAppFormExecute(ByRef qHandle As %Binary, admID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	S ind=1
 	if $l(admID) {
	 	S dhcdata=..GetDataNS()
		S curNS=$ZUTIL(5)
		zn dhcdata
		S retStr=$$GetPatAppFormHistory^DHCUtlBldAppForm(admID)
		I $l(retStr){
			F i=1:1:$L(retStr,"^")
			{
			
				S tRecord=$P(retStr,"^",i)
				Q:'$l(tRecord)
				S createDateTime=$P(tRecord,"#",1)
				S appFormNumber=$P(tRecord,"#",2)
				S formTypeDesc=$P(tRecord,"#",3)
				S IsAuthorised=$P(tRecord,"#",4)
				S IsPrinted=$P(tRecord,"#",5)
				S IsPrintConsent=$P(tRecord,"#",6)
				S reqDoctorStr=$P(tRecord,"#",7)
				S authorUserStr=$P(tRecord,"#",8)
				S dateTimeOfAuth=$P(tRecord,"#",9)
				S transDateTime=$P(tRecord,"#",10)
				S orderStr=$P(tRecord,"#",11)
				S orderInfo=""
	
				F j=1:1:$l(orderStr,"$") {
					S tData=$P(orderStr,"$",j)
					Q:'$L($g(tData))
					S ordName=$P(tData,"!",4)
					S ordAmount=$P(tData,"!",8)
					S ordUnit=$P(tData,"!",9)
					S orderInfo=orderInfo_ordName_" "_ordAmount_" "_ordUnit_","
					}
				
				S Data=$lb(appFormNumber,$P(createDateTime," ",1),$P(createDateTime," ",2),$P(dateTimeOfAuth," ",1),$P(dateTimeOfAuth," ",2),reqDoctorStr,authorUserStr,IsAuthorised,IsPrinted,IsPrintConsent,orderInfo)
				D OutputRow
				}
			}
				
		zn curNS
	 	}
	Quit $$$OK

OutputRow
	//set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryHistoryAppFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHistoryAppFormExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHistoryAppFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHistoryAppFormExecute ]
{
	// Restore QHandle
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

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取输血申请单
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatAppForm(itmjs As %String = "", itmjsex As %String = "", admID As %String, appFormNumber As %String = "") As %String
{
	S retStr=..BuildPatAppForm(admID,appFormNumber)
	//S ^DEBUG($zn,1)=itmjs_"|"_admID_"|"_appFormNumber
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取输血申请单
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckUser(itmjs As %String = "", itmjsex As %String = "", userCode As %String, userPwd As %String) As %String
{
	S retStr=$$select^MVBSSUSR(userCode,userPwd)
	S:retStr'=0 retStr=""
	I retStr=0 {
		S dhcdata=..GetDataNS()
		S curNS=$ZUTIL(5)
		zn dhcdata
		S retStr=$$GetDoctorNameByID^DHCUtlBldAppForm(userCode)	
		zn curNS
	}
	
	S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    &javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有输血类型
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllTransType(formType As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllTransType^DHCUtlBldAppForm()
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    2010-09-30
/// Description:： 保存申请单
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod SaveAppForm(appFormData As %String, UserLocID As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$SaveAppForm^DHCUtlBldAppForm(appFormData,UserLocID)
	zn curNS
	//调用平台组接口发送申请单 20130516 huhm
	s AppId=$p($p(appFormData,$c(3),4),$c(2),6)
	i $l(AppId),$p(retStr,"^",1)=0 d
	.s ^TMP("web.DHCBldAppForm",AppId)=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDBLOODAPPBILLINFO",AppId)
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有输血类型
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllTransTarget(appFormID As %String = "", formType As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllTransPurpose^DHCUtlBldAppForm(appFormID,formType)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有备血医嘱
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllOrders(appFormID As %String = "", admID As %String = "", formType As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllOrders^DHCUtlBldAppForm(appFormID,admID,formType)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有备血医嘱
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatAllTestItems(appFormID As %String = "", admID As %String = "", regNo As %String = "", formType As %String = "NORMAL") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetPatAllTestItems^DHCUtlBldAppForm(appFormID,admID,formType,regNo)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有既往史信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllAnamnesis(appFormID As %String = "", formType As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllAnamnesisResult^DHCUtlBldAppForm(appFormID,formType)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 构建输血申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod BuildPatAppForm(admID As %String, appFormNumber As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	Q:('$l(admID))&('$l(appFormNumber)) ret
	S patIdList=admID_"^"
	zn dhcdata
	S ret=$$BuildPatAppForm^DHCUtlBldAppForm(patIdList,appFormNumber,"NORMAL")
	zn curNS
	
    Q ret
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckPatAppForm(itmjs As %String = "", itmjsex As %String = "", appFormInfo As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="1^"
	Q:('$l(appFormInfo)) ret
	zn dhcdata
	S ret=$$SavePatAppFormByStr^DHCUtlBldAppForm(appFormInfo)
	zn curNS
	
    Q ret
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Meddata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetDataNS() As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S DataNS=Config.DataNamespace
	S:'$l(DataNS) DataNS="dhc-data"
 	Q DataNS
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Labdata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetLabDataNS() As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
	S LABDATA=Config.LabDataNamespace
	S:'$l(LABDATA) LABDATA="labdata"
 	Q LABDATA
}

Query QueryOrders(admId As %String, appFormNumber As %String = "") As %Query(ROWSPEC = "tNo:%String,tRowId:%String,tLabno:%String,tOrderItem:%String,tMemo:%String,tUnit:%String")
{
}

ClassMethod QueryOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdersExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdersExecute ]
{
 	// Restore QHandle
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

ClassMethod QueryOrdersExecute(ByRef qHandle As %Binary, admId As %String, appFormNumber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    d ..QueryPatOrders(repid,admId,appFormNumber)
	Quit $$$OK
}

ClassMethod QueryPatOrders(repid As %String, admId As %String, appFormNumber As %String)
{
  s admId=$g(admId)
  q:admId=""
  
  /*
  s ordRowid=$o(^OEORD(0,"Adm",admId,""))
  i ordRowid="" q 0
  s k=0
  s childsub="" f  s childsub=$o(^OEORD(ordRowid,"I",childsub)) q:childsub=""  d
  .i $d(^OEORD(ordRowid,"I",childsub,3)) d
  ..s labno=$p(^OEORD(ordRowid,"I",childsub,3),"^",20)
  ..q:labno=""
  ..s armRowid=$p(^OEORD(ordRowid,"I",childsub,1),"^",2)
  ..q:armRowid=""
  ..s armId=$p(armRowid,"||",1)
  ..s armchl=$p(armRowid,"||",2)
  ..q:'$d(^ARCIM(armId,armchl,"EXT",1))
  ..s ts=$p(^ARCIM(armId,armchl,"EXT",1),"^",4)
  ..;i $e(ts,1,1)'="E" q
  ..;i ts="K003" q
  ..i '$d(^TTAB("TS",ts,"XM")) q
  ..s labTS=labno_"||"_ts
  ..;i $$selEpisTS^DHCBldRqOrd(labTS)=0 q
  ..s debtor=$p(^OEORD(ordRowid,"I",childsub,3),"^",9)
  ..s b=0
  ..i $d(^DHCBldReqOrd(debtor)) d
  ...s id="" f  s id=$o(^DHCBldReqOrd(debtor,id)) q:id=""  d
  ....s no="" f  s no=$o(^DHCBldReqOrd(debtor,id,no)) q:no=""  d
  .....i $p(^DHCBldReqOrd(debtor,id,no),"^",2)=labTS s b=1
  .....q:b=1
  ..q:b=1  ;医嘱已打印不显示
  ..s itmDesc=$p(^ARCIM(armId,armchl,1),"^",2)
  ..s unit="",OrdItmRowId="",arcSub=""
  ..s unitcode=$p(^ARCIM(armId,armchl,8),"^",14)
  ..i unitcode'="" s unit=$p(^CT("UOM",unitcode),"^",2)
  ..s k=k+1
  ..s memo=""
  ..s rowid=ordRowid_"||"_childsub
  ..s ^CacheTemp(repid,k)=$lb($g(k),$g(rowid),$g(labTS),$g(itmDesc),$g(memo),$g(unit))
  */
  
  
  
  q 0
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAppFormInfo(formType As %String, appFormNumber As %String, admID As %String, regNo As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAppFormInfo^DHCUtlBldAppForm(formType,appFormNumber,admID,regNo)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatAllAppForm(regNo As %String, admID As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetPatAllAppForm^DHCUtlBldAppForm(regNo,admID)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllUncheckAppFormByLoc(locID As %String, userCode As %String, userGroupID As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllAppFormByLoc^DHCUtlBldAppForm(locID,"A",userCode,userGroupID)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckAppForm(appFormID As %String, checkUserCode As %String, checkUserPwd As %String, curUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CheckAppForm^DHCUtlBldAppForm(appFormID,checkUserCode,checkUserPwd,curUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 取消审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CancelCheckAppForm(appFormID As %String, checkUserCode As %String, checkUserPwd As %String, curUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CancelCheckAppForm^DHCUtlBldAppForm(appFormID,checkUserCode,checkUserPwd,curUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 取消申请
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CancelApplyAppForm(appFormID As %String, applyUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CancelApplyAppForm^DHCUtlBldAppForm(appFormID,applyUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有既往史信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetReportData(appFormID As %String = "", repType As %String = "", patAdmID As %String = "", userCode As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetReportData^DHCUtlBldAppFormReport(appFormID,repType,patAdmID,userCode)
	zn curNS
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20110425
/// Description:： 获取所有标准备注
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllStdComment(stdComType As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	K PLIST
	S PLIST=""
	S retStr=$$GetAllStdCommentStr^DHCUtlBldAppForm(stdComType)
	zn curNS

    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20110425
/// Description:： 获取所有其他报告
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllOtherReportStr() As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	K PLIST
	S PLIST=""
	S retStr=$$GetAllOtherReportStr^DHCUtlBldAppForm()
	zn curNS

    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20110524
/// Description:： 判断是否开来某医嘱
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       0-未开，1-开了
/// Others：       其它说明
ClassMethod IsReqOrder(admID As %String, ordRowID As %String, ordDesc As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$IsReqOrder^DHCUtlBldAppFormCore(admID,ordRowID,ordDesc)
	zn curNS
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20111022
/// Description:： 获取备选医嘱
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllTransOrdersStr(patAdmID As %String) As %String
{
	
	s patAdmID=$g(patAdmID)
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	K PLIST
	S PLIST=""
	S retStr=$$GetAllTransOrdersStr^DHCUtlBldAppForm(patAdmID)
	S retStr=$TR(retStr,$C(3),$C(5))
	S retStr=$TR(retStr,$C(2),$C(3))
	S retStr=$TR(retStr,$C(5),$C(2))
	zn curNS

    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20111022
/// Description:： 创建备血医嘱
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CreateTransOrders(admID As %String, docCode As %String, transOrders As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	S retStr=$$CreateTransOrders^DHCUtlBldAppForm(admID,docCode,transOrders)
	zn curNS
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20111103
/// Description:： 获取用户组权限
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetUserGroupGrant(userGrpID As %String, userCode As %String = "") As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetUserGroupGrant^DHCUtlBldAppForm(userGrpID,userCode)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20111103
/// Description:： 用户密码确认
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckUserPwdConfirm(checkUserCode As %String, checkUserPwd As %String, bldVolume As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CheckUserPwdConfirm^DHCUtlBldAppForm(checkUserCode,checkUserPwd,bldVolume)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20111103
/// Description:： 获取用户组权限
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetUserCPVolume(userCode As %String = "", orders As %String = "") As %String
{
	S ret="1^申请血量失败！"
	i '$l(orders) Q "1^获取医嘱错误！"
	s UsrRowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userCode,"U"),""))
	i '$l(UsrRowID) Q "1^取医生ID错误！"
    s chkUsrCareProv=$P($g(^SSU("SSUSR",UsrRowID)),"^",14)
    Q:'$l(chkUsrCareProv) "1^没有配置医生职称！"
    s chkUsrCPCode=$p($g(^CTPCP(chkUsrCareProv,1)),"^",4)
    Q:'$l(chkUsrCPCode) "1^没有配置医生职称！"
    //s chkUsrCPDesc=$p($g(^CT("CPT",chkUsrCPCode)),"^",2)
    //Q:'$l(chkUsrCPDesc) ret
    //i chkUsrCPDesc="主任医师" s ret=800
    //i chkUsrCPDesc="副主任医师" s ret=1200
    //i chkUsrCPDesc="科室主任" s ret=2000
	s retStr=""
	//s orders="1#27559||1##申请备A型RH阳性血浆#3200#ML####^"
	s bCheck=0  //更新申请单判断是否有审核权限
	f i=1:1:$l(orders,"^") d
	.s tList=$p(orders,"^",i)
	.i '$l(tList) Q
	.i $l(retStr) q
	.s ArcmID=$p(tList,"#",2)
	.i ArcmID["-" d
	..s ArcmID=$p($g(^OEORD(+ArcmID,"I",$p(ArcmID,"-",2),1)),"^",2)
	..s bCheck=1 
	.s OrdDesc=$p(tList,"#",4)
	.s Volume=$p(tList,"#",5)
	.i $l(ArcmID),$d(^DHCBLDAPPFORMc("USERCP",chkUsrCPCode,ArcmID)) d
	..s MaxVolume=+$p($g(^DHCBLDAPPFORMc("USERCP",chkUsrCPCode,ArcmID)),"\",1)
	..s isMax=$p($g(^DHCBLDAPPFORMc("USERCP",chkUsrCPCode,ArcmID)),"\",2)
	..s isCheck=$p($g(^DHCBLDAPPFORMc("USERCP",chkUsrCPCode,ArcmID)),"\",3)
	..i Volume>MaxVolume d
	...s retStr="1^【"_OrdDesc_"】超出最大申请血量！"
	...i isMax="Y" s retStr="2^【"_OrdDesc_"】超出最大申请血量！是否继续保存申请单！"
	..i (bCheck=1),(isCheck="N") s retStr="1^【"_OrdDesc_"】没有审核权限！"
	..e  S ret="0^0"
	.e  s retStr="1^医生申请血量没有配置！"
	i $l(retStr) s ret=retStr
	Q ret
}

}
