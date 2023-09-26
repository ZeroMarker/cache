/// create by zhouli
/// 体检设置
/// DHCPESettingEdit
Class web.DHCPE.Public.SettingEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 从^DHCPESetting中获取所保存的信息

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Public.SettingEdit", "Querytest","tjs")
Query Querytest(ctlocdesc As %Library.String, hospId As %String = "") As %Query(ROWSPEC = "Desc:%String:名称,CTLOCID:%String:ID,CTLOCCODE:%String:编码")
{
}

ClassMethod QuerytestExecute(ByRef qHandle As %Binary, ctlocdesc As %Library.String, hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s curHospId=%session.Data("LOGON.HOSPID") ;当前登陆的医院Id
	;s curHospId=2
    i $g(ctlocdesc)'="" s ctlocdesc=$$ALPHAUP^SSUTIL4(ctlocdesc) //进行大小写转换 
 	s ctloccode="",desc=""
	s ctlocrowid=0
	f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
	.s ctloccode=$p(^CTLOC(ctlocrowid),"^",1)
	.s desc=$p(^CTLOC(ctlocrowid),"^",2)
	.s locHospId=$p(^CTLOC(ctlocrowid),"^",22)
	.;q:(locHospId'=curHospId)&(locHospId'="")&(curHospId'="")
	.;s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",ctlocrowid,hospId)
	.;q:(HOSPshowFlag="N")
	.s LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
	.s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
	.q:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
	.q:##class(web.DHCPE.Public.SettingEdit).CheckLocDesc(ctlocrowid,ctlocdesc)'=1
    .d QueryOut
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut     
	set Data=$lb(desc,ctlocrowid,ctloccode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QuerytestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerytestExecute ]
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

ClassMethod QuerytestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerytestExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 判断科室检索码是否在入参查询条件内

// 1在 0 不在

ClassMethod CheckLocDesc(LocId As %String, desc As %String) As %String
{
	s FindFlag=0
	q:(LocId="")||(desc="") "1"
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s CTLocContactName=$P(^CTLOC(LocId),"^",43)
	//科室检索码
	s CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
	Q:(CTLocContactName[desc) "1"
	//科室名称
	s CTLocDesc=$$ALPHAUP^SSUTIL4($P(^CTLOC(LocId),"^",2))
	Q:(CTLocDesc[desc) "1"
	
	Q FindFlag
}

ClassMethod ChooseTrakVerison(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="155"            
	w "<select name='TrakVerison' id='TrakVerison' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='TrakCare'>TrakCare</option>",!
	w "<option value='MedTrak'>MedTrak</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod ChooseBilledMode(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="290"            
	w "<select name='计费方式' id='BilledMode' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='New'>新计费</option>",!
	w "<option value='Old'>旧计费</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod PreBuildNum(ContrlWidth As %String = "") As %String
{
  
   s:(""=ContrlWidth) ContrlWidth="155"            
	w "<select name='是否预先生成号段' id='PAPMINoGenModel' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='Gen'>Gen</option>",!
	w "<option value='NoGen'>NoGen</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod LimitDate(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="155"            
	w "<select name='是否限制预约到达的日期' id='BookDateLimit' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='Yes'>Yes</option>",!
	w "<option value='No'>No</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod PrintList(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="290"            
	w "<select name='打印发票时是否打印明细' id='InvListFlag' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='0'>打印</option>",!
	w "<option value='1'>不打印</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod ListTpye(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="290"            
	w "<select name='打印发票的明细格式' id='InvColSortType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='1'>ItemName_"_"_ItemPrice_"_"_qty_"_"_FactAmount</option>",!
	w "<option value='2'>ItemName_"_"_Uom_"_"_qty_"_"_FactAmount</option>",!
	w "<option value='3'>ItemName_"_"_Uom_"_"_qty_"_"_ItemPrice_"_"_FactAmount</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod PayMode(ContrlWidth As %String = "") As %String
{
	
	s:(""=ContrlWidth) ContrlWidth="290"
	w "<select name='默认支付方式' id='InvDefaultPayMode' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s PMid=0
	f  s PMid=$o(^CT("CTPM",PMid)) q:PMid=""  d  
	.w "<option value='"_PMid_"'>"_$P($g(^CT("CTPM",PMid)),"^",2)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod InvFlag(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="290"            
	w "<select name='发票标志区别' id='InvFlag' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>复兴</option>",!
	w "<option value='N'>友谊</option>",!
	w "<option value='Y'>其他</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod RoundingFeeMode(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="290"            
	w "<select name='凑整费模式' id='RoundingFeeMode' style='width:"_ContrlWidth_"' HEIGHT=0>",!

	w "<option value='0'>不允许</option>",!
	w "<option value='1'>个人收费允许</option>",!
	w "<option value='2'>团体收费允许</option>",!
	w "<option value='3'>个人和团体收费均允许</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod QueryStationExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    
    s stDesc="",stCode="",stPlace=""
    s stRowid=0
    f  s stRowid=$o(^DHCPEST(stRowid)) q:stRowid=""  d
     .s stDesc=$p(^DHCPEST(stRowid),"^",2)
     .s stCode=$p(^DHCPEST(stRowid),"^",1)
     .s stPlace=$p(^DHCPEST(stRowid),"^",3)
     .d QueryOut
 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut     
	set Data=$lb(stDesc,stRowid,stCode,stPlace)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryStationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStationExecute ]
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

Query QueryStation() As %Query(ROWSPEC = "stDesc:%String,stRowid:%String,stCode:%String,stPlace:%String")
{
}

ClassMethod QueryStationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDoctorIDExecute(ByRef qHandle As %Binary, DocCode As %Library.String, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ""'=DocCode s DocCode=$$ALPHAUP^SSUTIL4(DocCode)
 
     
    s DocName=""
    s DocRowID=0
    f  s DocRowID=$o(^CTPCP(DocRowID))  q:DocRowID=""  d
    .s DocName=$p(^CTPCP(DocRowID,"1"),"^",2)
    .s RDocCode=$p(^CTPCP(DocRowID,"1"),"^",1)
    .s RDocCode=$$ALPHAUP^SSUTIL4(RDocCode)
    .q:(DocCode'="")&&(RDocCode'[DocCode)&&(DocName'[DocCode)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("CT_CareProv",DocRowID,Type,LocID)
    .q:DateShowFlag="Y"
    .s showflag =##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_CareProv",DocRowID,hospId)
    .Q:showflag="N"

    .d QueryOut
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut 
    s CarPrvTpDR=$p($g(^CTPCP(DocRowID,1)),"^",4) 
    s CTCPTType=$p($g(^CT("CPT",CarPrvTpDR)),"^",4)
    q:CTCPTType'="DOCTOR" 
	set Data=$lb(DocName,RDocCode,DocRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDoctorIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorIDExecute ]
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
	Quit $$$OK
}

Query QueryDoctorID(DocCode As %Library.String, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "DocName:%String,DocCode:%String,DocRowID:%String")
{
}

ClassMethod QueryDoctorIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorIDExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChooseSex(ContrlWidth As %String = "") As %String
{
	//下拉列表
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='DefSexType' id='DefSexType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s Sexid=0
	f  s Sexid=$o(^CT("SEX",Sexid)) q:Sexid=""  d           //遍历
	.w "<option value='"_Sexid_"'>"_$p($g(^CT("SEX",Sexid)),"^",2)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod ChooseFee(ContrlWidth As %String = "") As %String
{
   s:(""=ContrlWidth) ContrlWidth="155"
     w "<select name='DefFeeType' id='DefFeeType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
     w "<option value=''>  </option>",!
     s Feeid=0
     f  s Feeid=$o(^CT("SS",Feeid)) q:Feeid=""  d
    .w "<option value='"_Feeid_"'>"_$p($g(^CT("SS",Feeid)),"^",2)_"</option>",!
     w "</select>",!
	Quit $$$OK
}

Query QueryFeeID(FeeTest As %Library.String, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "Name:%String:名称,ID:%String:ID,Code:%String:编码")
{
}

ClassMethod QueryFeeIDExecute(ByRef qHandle As %Binary, FeeTest As %Library.String, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s:(hospId="") hospId=%session.Data("LOGON.HOSPID") ;当前登陆的医院Id	
 	s ind=1
 	s FeeTest=##class(web.DHCPE.DHCPECommon).UnEscape(FeeTest)
 	i ""'=FeeTest d
 	.s ARCIMDR=""
 	.s test=$ZCONVERT(FeeTest,"U")   
 	.s test=$o(^ARC("ALIAS",0,"Desc",test),-1)                  
    .f  s test=$o(^ARC("ALIAS",0,"Desc",test)) q:(test="")||(test'[$ZCONVERT(FeeTest,"U"))  d
    ..s ALIASDesc=0
    ..f  s ALIASDesc=$o(^ARC("ALIAS",0,"Desc",test,ALIASDesc)) q:ALIASDesc=""  d
    ...s ALIASRowid=0
    ...f  s ALIASRowid=$o(^ARC("ALIAS",0,"Desc",test,ALIASDesc,ALIASRowid)) q:ALIASRowid=""  d
    ....s CurData=$G(^ARC("ALIAS", 0, "Desc", test, ALIASDesc, ALIASRowid,1))
    ....s ALIASType=$P(CurData,"^",2)   
	....s ALIASRowCalc=$P(CurData,"^",1)    //医嘱项RowID
	....s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ALIASRowCalc,Type,LocID)
    ....q:DateShowFlag="Y"
    ....s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ALIASRowCalc,hospId)
	....q:(HOSPshowFlag="N")
    ....i ("ARCIM"=ALIASType) d
	.....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc,""))
   	.....Q:(""=STRowId)
    .....s ARCIMDR=ALIASRowCalc 
    .....s ARCSUB=$P($g(ARCIMDR),"||",1),ARCVER=$P($g(ARCIMDR),"||",2)
    .....q:$g(^ARCIM(ARCSUB,ARCVER,1))=""
    .....s ARCIMDESC=$p(^ARCIM(ARCSUB,ARCVER,1),"^",2)
    .....s ARCIMCode=$p(^ARCIM(ARCSUB,ARCVER,1),"^",1)
    .....d QueryOut
   
     i FeeTest=""  d  
     .s ARCIMDR=""
     .s ARCSUB=0 
     .f  s ARCSUB=$o(^ARCIM(ARCSUB)) q:ARCSUB=""  d
     ..s ARCVER=0
     ..f  s ARCVER=$o(^ARCIM(ARCSUB,ARCVER)) q:ARCVER=""  d 
     ...s ARCIMDR=ARCSUB_"||"_ARCVER
     ...q:$o(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))=""
     ...q:$g(^ARCIM(ARCSUB,ARCVER,1))=""
     ...s ARCIMDESC=$P(^ARCIM(ARCSUB,ARCVER,1),"^",2)
     ...s ARCIMCode=$p(^ARCIM(ARCSUB,ARCVER,1),"^",1)
     ...s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",ARCIMDR,Type,LocID)
     ...q:DateShowFlag="Y"
     ...s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ARCIMDR,hospId)
	 ...q:(HOSPshowFlag="N")
     ...d QueryOut
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut     
	set Data=$lb(ARCIMDESC,ARCIMDR,ARCIMCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryFeeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFeeIDExecute ]
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

ClassMethod QueryFeeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFeeIDExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s ^zhouli("1101")=InString
	//写死的系统参数
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	//需要调用CRMGateway的类名--"web.DHCPE.CRM.GatewayConstant" --"web.DHCPE.CRM.GatewayYZ"
	s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"  //可录入体检结果的IADM的状态列表
    //放后s ^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")=",201,"  //总检医生安全组，多个用逗号分隔。

    s ^DHCPESetting("DHCPE","TrakVerison")=$p(InString,"^",1)
	s ^DHCPESetting("DHCPE","PhyExamLocId")=$p(InString,"^",2)
    s ^DHCPESetting("DHCPE","PhyExamDrId")=$p(InString,"^",3)
    s ^DHCPESetting("DHCPE","HealthFile_StationIds")=$p(InString,"^",4)
    s ^DHCPESetting("DHCPE","StationId_Lab")=$p(InString,"^",5)
    s ^DHCPESetting("DHCPE","Group'sOEArcItemId")=$p(InString,"^",6)
    s ^DHCPESetting("DHCPE","PAPMINo_GenModel")=$p(InString,"^",7)
    s ^DHCPESetting("DHCPE","BookDateLimit")=$p(InString,"^",8)
    s $p(^DHCPESetting("DHCPE","DefPatientType"),"^",1)=$p(InString,"^",9) 
    s $p(^DHCPESetting("DHCPE","DefPatientType"),"^",2)=$p(InString,"^",10)
    s ^DHCPESetting("NAMESPACE","LABDATA")=$p(InString,"^",11)
    s ^DHCPESetting("NAMESPACE","MEDDATA")=$p(InString,"^",12)
    s ^DHCPESetting("DHCPE","HospitalName")=$p(InString,"^",13)
    s ^DHCPESetting("DHCPE","ReportTitle")=$p(InString,"^",14)
    s ^DHCPESetting("DHCPE","InvCol")=$p(InString,"^",15)		
	s ^DHCPESetting("DHCPE", "InvMaxListCount")=$p(InString,"^",16)	
	s ^DHCPESetting("DHCPE","InvColSortType")=$p(InString,"^",17)	

	s ^DHCPESetting("DHCPE","InvListFlag")=$p(InString,"^",18)  	
	s ^DHCPESetting("DHCPE","InvDefaulltFee")=$p(InString,"^",19)
	
    s ^DHCPESetting("DHCPE","InvDefaultPayMode")=$p(InString,"^",20)
      
    s ^DHCPESetting("DHCPE","InvFlag")=$p(InString,"^",21)		
	s ^DHCPESetting("DHCPE","RoundingFee")=$p(InString,"^",22)	
	s ^DHCPESetting("DHCPE","RoundingFeeMode")=$p(InString,"^",23)  
	s ^DHCPESetting("DHCPE","CashierMin")=$p(InString,"^",24)
	s ^DHCPESetting("DHCPE","HospitalCode")=$p(InString,"^",25)
	s ^DHCPESetting("DHCPE","BilledMode")=$p(InString,"^",26)		
    q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
  
   s hos=$g(^DHCPESetting("DHCPE","HospitalName"))                            //医院名称
   s report=$g(^DHCPESetting("DHCPE","ReportTitle"))                          //报表名称
   s hoscode=$g(^DHCPESetting("DHCPE","HospitalCode"))                        //医院代码
   s billedmode=$g(^DHCPESetting("DHCPE","BilledMode"))                       //支付方式 
   s itr=$g(^DHCPESetting("DHCPE","TrakVerison"))                             //Trak版本
  
  
   s locid=$g(^DHCPESetting("DHCPE","PhyExamLocId"))                          
   s locdesc=""
   i locid'=""  d
   .s locdesc=$p(^CTLOC(locid),"^",2)                                          //科室名称
   else  d
   .s locid=""
   
    
   s drid=$g(^DHCPESetting("DHCPE","PhyExamDrId"))
   s docName=""
   i drid'=""  d
   .s docName=$p($g(^CTPCP(drid,1)),"^",2)                                     //医生姓名
    else  d
   .s drid=""
  
   s stid=$g(^DHCPESetting("DHCPE","HealthFile_StationIds"))
   S stdesc=""
   i stid'=""  d
   .s stdesc=$p(^DHCPEST(stid),"^",2)                                          //站点名称


   s labid=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s labdesc=""
   i labid'=""  d
  .s labdesc=$p(^DHCPEST(labid),"^",2)                                         //检验科站点名称
    else  d
    .s labid=""
   
 
   
   s itemid=$g(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
   s SUB="",VER="",item=""
   i itemid'=""  d
   .s SUB=$P(itemid,"||",1)
   .s VER=$P(itemid,"||",2)
   .s item=$p(^ARCIM(SUB,VER,1),"^",2)                                         //体检费对应的医嘱
   else  d
    .s itemid=""
   
   s GenModel=$g(^DHCPESetting("DHCPE","PAPMINo_GenModel"))                     //是否预先生成号段
   s DateLimit=$g(^DHCPESetting("DHCPE","BookDateLimit"))                       //是否限制到达日期
   s feename=$p(^DHCPESetting("DHCPE","DefPatientType"),"^",1)                  //是否缺少费别    
   s sexname=$p(^DHCPESetting("DHCPE","DefPatientType"),"^",2)                  //是否缺少性别
   s lab=$g(^DHCPESetting("NAMESPACE","LABDATA"))                               //LABDATA的NameSpace
   s med=$g(^DHCPESetting("NAMESPACE","MEDDATA"))                               //MEDDATA的NameSpace
   s Col=$g(^DHCPESetting("DHCPE","InvCol"))                                    //发票打印列数
   s Count=$g(^DHCPESetting("DHCPE", "InvMaxListCount"))                        //打印明细的最大数量
   s Type=$g(^DHCPESetting("DHCPE","InvColSortType"))                           //打印发票的明细格式
   s InvListFlag=$g(^DHCPESetting("DHCPE","InvListFlag"))                       //打印发票是否打印明细
   s PayMode=$g(^DHCPESetting("DHCPE","InvDefaultPayMode"))                     //默认支付方式
   s InvFlag=$g(^DHCPESetting("DHCPE","InvFlag"))                               //发票标志区别
   s FeeMode=$g(^DHCPESetting("DHCPE","RoundingFeeMode"))                       //凑整费模式
   s CashierMin=$g(^DHCPESetting("DHCPE","CashierMin"))                         //收费时其他支付方式现金找零最大的金额
  
   s DefaulltFeeID=$g(^DHCPESetting("DHCPE","InvDefaulltFee"))                   //发票打印默认医瞩项
   s ARCSUB1="",ARCVER1="", DefaulltFee=""
   i DefaulltFeeID'=""  d
  .s ARCSUB1=$P(DefaulltFeeID,"||",1)
  .s ARCVER1=$P(DefaulltFeeID,"||",2)
  .s DefaulltFee=$p(^ARCIM(ARCSUB1,ARCVER1,1),"^",2) 
  else  d
    .s DefaulltFeeID=""
   
   
  s RoundingFeeID=$g(^DHCPESetting("DHCPE","RoundingFee"))                        //凑整费对应的医嘱项
   s arcsub="",arcver="",RoundingFee=""
  i RoundingFeeID'=""  d
  .s arcsub=$P(RoundingFeeID,"||",1)
  .s arcver=$P(RoundingFeeID,"||",2)
  .s RoundingFee=$p(^ARCIM(arcsub,arcver,1),"^",2)
   else  d
  .s RoundingFeeID="" 
    
  s str=hos_"^"_report_"^"_itr_"^"_locid_"^"_locdesc_"^"_drid_"^"_docName_"^"_stid_"^"_stdesc_"^"_labid
  s str=str_"^"_labdesc_"^"_itemid_"^"_item_"^"_GenModel_"^"_DateLimit
  s str=str_"^"_feename_"^"_sexname_"^"_lab_"^"_med _"^"_Col_"^"_Count_"^"_Type_"^"_InvListFlag_"^"_DefaulltFee
  s str=str_"^"_DefaulltFeeID_"^"_PayMode_"^"_InvFlag_"^"_RoundingFee_"^"_RoundingFeeID_"^"_FeeMode_"^"_CashierMin_"^"_hoscode_"^"_billedmode
     
  q str
}

/// Create by MLH 2008-06-18
/// d ##class(web.DHCPE.Public.Setting).InitOrdHasPhoto()
ClassMethod InitOrdHasPhoto()
{
	
	Set STORDChd=0
	For  Set STORDChd=$o(^DHCPEST(10,"O",STORDChd)) Quit:STORDChd=""  Do
	.Set STORDRowId=10_"||"_STORDChd
	.Set ^DHCPECTDataEx("DHCPEStationOrder","Photo",STORDRowId)="Y"
	
	Set STORDChd=0
	For  Set STORDChd=$o(^DHCPEST(13,"O",STORDChd)) Quit:STORDChd=""  Do
	.Set STORDRowId=13_"||"_STORDChd
	.Set ^DHCPECTDataEx("DHCPEStationOrder","Photo",STORDRowId)="Y"
	Quit
}

}
