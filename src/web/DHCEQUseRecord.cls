Import SQLUser

Class web.DHCEQUseRecord Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/******************************************************************************************/
ClassMethod GetUseRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By QW20181112 需求号:746779 增加参数TotalFlag控制合计行的输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQUseRecord","GetUseRecordList","^Year=^Month=^EquipDR=^ServiceDR=^ModelDR=^PatientInfo=^UseLocDR=^ItemDR=","","01/10/2018","03/12/2018","1","1")
ClassMethod GetUseRecordListExecute(ByRef qHandle As %Binary, vData As %String = "", UserDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", TotalFlag As %String = "1") As %Status
{
	new repid, index,rowid,Start ;modified By QW20181030 需求号:725187
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	//Modify By zx 2020-02-18 BUG ZX0074
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("UseRecordListReport") 
 	Set PNum=1
 	Set TJob=$J
 	
	s index=2
	s TRow=1 //add by zx 2015-09-17
	s rowid=""
	s Amount=0
	s Quantity=0
	s AmountBGCS=0
	s AmountJCL=0
	s AmountJCRC=0
	 //modify by wl 2019-09-11   1025630 TPrice不需要合计,增加TWork合计
	s AmountTWorkLNum=0 //Add By QW20181030 需求号:686298 对此需求进行修正  
	d BuildDataGetUseRecordList
	Quit $$$OK
BuildDataGetUseRecordList
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
	Set ServiceDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	Set PatientInfo=##Class(web.DHCEQCommon).GetDataByName(vData,"PatientInfo")
	Set Year=##Class(web.DHCEQCommon).GetDataByName(vData,"Year")
	Set Month=##Class(web.DHCEQCommon).GetDataByName(vData,"Month")
	Set ItemDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ItemDR")
	//hisui改造 add by lmm 2018-08-17 begin
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")   
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")   
	//hisui改造 add by lmm 2018-08-17 begin
	i StartDate=""
	{
		s Start=0
	}
	else
	{
		s Start=StartDate-1
	}
	s StartDate=Start
	i EndDate="" s EndDate=+$H
	f  s StartDate=$o(^DHCEQUseRecord(0,"UseDate",StartDate))  q:(StartDate="")||(StartDate>EndDate)  d
	.s CancelFlag=0
	.s SourceType=0
	.f  s SourceType=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType))  q:SourceType=""  d
	..s SourceID=0
	..f  s SourceID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType, SourceID))  q:SourceID=""  d
	...q:(SourceType=1)&&(EquipDR'="")&&(SourceID'=EquipDR)
	...q:(SourceType=2)&&(ItemDR'="")&&(SourceID'=ItemDR)
	...s URRowID=""
	...f  s URRowID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType, SourceID,URRowID),-1)  q:(URRowID="")||(URRowID=0)  d
	....d ResetVariablesGetUseRecordList
	....d CheckUseRecord
	....q:passed=0
	....s TCancelDate=""
	....s TCancelUser=""
	....d OutputRowGetUseRecordList
	
	s StartDate=Start
	f  s StartDate=$o(^DHCEQUseRecord(0,"CancelDate",StartDate))  q:(StartDate="")||(StartDate>EndDate)  d		//Modify DJ 2015-09-29 DJ0169
	.s CancelFlag=1
	.s URRowID=""
	.f  s URRowID=$o(^DHCEQUseRecord(0,"CancelDate",StartDate,URRowID),-1)  q:(URRowID="")||(URRowID=0)  d
	..s SourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	..s SourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1) //add by zx 循环中会出现类型为空
	..q:(SourceType=1)&&(EquipDR'="")&&(SourceID'=EquipDR)
	..q:(SourceType=2)&&(ItemDR'="")&&(SourceID'=ItemDR)
	..d ResetVariablesGetUseRecordList
	..d CheckUseRecord
	..q:passed=0
	..s TTotalFee=0-TTotalFee
	..s Amount=Amount+TTotalFee+TTotalFee
	//modify by wl 2019-09-11   1025630 TPrice不需要合计,增加TWork合计
	..s TWorkLoadNum=0-TWorkLoadNum  //Add By QW20181030 需求号:686298 对此需求进行修正   
	..s AmountTWorkLNum=AmountTWorkLNum+TWorkLoadNum+TWorkLoadNum //Add By QW20181030 需求号:686298 对此需求进行修正
	..s Quantity=Quantity-2
	..d OutputRowGetUseRecordList
    d ResetVariablesGetUseRecordList
    s index=1
    s TRow="合计:"  //add by zx 2015-09-17
    //modify by wl 2019-09-11   1025630 TPrice不需要合计,增加TWork合计
    s TWorkLoadNum =AmountTWorkLNum //Add By QW20181030 需求号:686298 对此需求进行修正    
    s TTotalFee=Amount
    s TPatientInfo="检查人次:"_AmountJCRC
    s TBGCS="曝光次数:"_AmountBGCS
    s TBRYJLSH="检查量:"_AmountJCL
    k ^TempDHCEQ("UseRecord.JCL",$J)
    k ^TempDHCEQ("UseRecord.JCRC",$J)
    k ^TempDHCEQ("UseRecord_JS.JCL",$J)
    k ^TempDHCEQ("UseRecord_JS.JCRC",$J)
    k ^TempDHCEQ("UseRecord.BGCS",$J)
    k ^TempDHCEQ("UseRecord_JS.BGCS",$J)
    if TotalFlag=1 d OutputRowGetUseRecordList //Add By QW20181112 需求号:746779  增加参数TotalFlag控制合计行的输出
    
	quit
CheckUseRecord
	s passed=1
	s TRowID = URRowID
	s InvalidFlag=$p($g(^DHCEQUseRecord(URRowID)),"^",20)
	i InvalidFlag="Y"
	{
		s passed=0
		q
	}
	s TUseLoc=$p($g(^DHCEQUseRecord(URRowID)),"^",9)
	i (UseLocDR'="")&&(TUseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TUseLoc))) //2010-10-28 DJ
	{
		s passed=0
		q
	}
	//modified by cjt 20230129 需求号2888051 修改TPatientInfo处理逻辑
	s TPatientID=$p($g(^DHCEQUseRecord(URRowID)),"^",10)
	s TPatientSex=$p($g(^DHCEQUseRecord(URRowID)),"^",44)
	s TPatientAge=$p($g(^DHCEQUseRecord(URRowID)),"^",45)
	s TPatientName=$p($g(^DHCEQUseRecord(URRowID)),"^",46)
	s TPatientInfo=""
	i TPatientID'="" s TPatientInfo=+TPatientID_"&"_TPatientName_"&"_TPatientAge_"&"_TPatientSex
	i (PatientInfo'="")&&(TPatientInfo'[PatientInfo)
	{
		s passed=0
		q
	}
	s TYear=$p($g(^DHCEQUseRecord(URRowID)),"^",13)
	i (Year'="")&&(TYear'=Year)
	{
		s passed=0
		q
	}
	s TMonth=$p($g(^DHCEQUseRecord(URRowID)),"^",14)
	i (Month'="")&&(TMonth'=Month)
	{
		s passed=0
		q
	}
	s TServiceItem=$p($g(^DHCEQUseRecord(URRowID)),"^",15)
	i (ServiceDR'="")&&(TServiceItem'=ServiceDR)
	{
		s passed=0
		q
	}
	s TAddUser=$p($g(^DHCEQUseRecord(URRowID)),"^",22)
	i (UserDR'="")&&(TAddUser'=UserDR)
	{
		s passed=0
		q
	}
	s TModel=$p($g(^DHCEQUseRecord(URRowID)),"^",28)
	i (ModelDR'="")&&(TModel'=ModelDR)
	{
		s passed=0
		q
	}
	s TStatus=$p($g(^DHCEQUseRecord(URRowID)),"^",19)
	i (QXType=1)&&(TStatus<=1)
	{
		s passed=0
		q
	}
	s TSourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	s TSourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	i TSourceType=1 s Item=$p($g(^DHCEQEquip(TSourceID)),"^",7)
	i TSourceType=2 s Item=TSourceID
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	i EquipDR'=""
	{
		s EQItem=$p($g(^DHCEQEquip(EquipDR)),"^",7)
		i (TSourceType=2)&&(Item'=EQItem)
		{
			s passed=0
			q
		}
	}
	i TSourceID'=""  d
	.i TSourceType=1  d
	..s TEquipNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)
	..s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.i TSourceType=2  d
	..s TEquipNo=""
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	i TSourceType'="" s TSourceType=##Class(web.DHCEQEquipService).GetEditSourceType(TSourceType)
	s TUseDate=$p($g(^DHCEQUseRecord(URRowID)),"^",3)
	i TUseDate'=""  s TUseDate=##Class(web.DHCEQCommon).TransValueToPage(TUseDate,"date")
	s TStartTime=$p($g(^DHCEQUseRecord(URRowID)),"^",4)
	;i TStartTime'=""  s TStartTime=$zt(TStartTime,2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i TStartTime'=""  s TStartTime=##Class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TEndDate=$p($g(^DHCEQUseRecord(URRowID)),"^",5)
	i TEndDate'=""  s TEndDate=##Class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	s TEndTime=$p($g(^DHCEQUseRecord(URRowID)),"^",6)
	;i TEndTime'=""  s TEndTime=$zt(TEndTime,2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i TEndTime'=""  s TEndTime=##Class(web.DHCEQCommon).TransValueToPage(TEndTime,"time")
	s TWorkLoadNum=$p($g(^DHCEQUseRecord(URRowID)),"^",7)
	s TWorkLoadUnit=$p($g(^DHCEQUseRecord(URRowID)),"^",8)
	i TWorkLoadUnit'=""  s TWorkLoadUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnit)
	i TUseLoc'=""  s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	s TPrice=$p($g(^DHCEQUseRecord(URRowID)),"^",11)
	i TPrice'="" s TPrice=##class(web.DHCEQCommon).FormatNumber(TPrice,"")  //modify by wl 2019-9-11 1025630 
	s TTotalFee=$p($g(^DHCEQUseRecord(URRowID)),"^",12)
	i TServiceItem'=""  s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItem)),"^",1)
	s TExType=$p($g(^DHCEQUseRecord(URRowID)),"^",16)
	i TExType="" s TExType="_"
	s TExID=$p($g(^DHCEQUseRecord(URRowID)),"^",17)
	s TIsInputFlag=$p($g(^DHCEQUseRecord(URRowID)),"^",18)
	i TStatus'=""  s TStatus=..GetStatus(TStatus)
	s TRemark=$p($g(^DHCEQUseRecord(URRowID)),"^",21)
	i TAddUser'=""  s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUser)
	i TModel'=""  s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TCancelDate=$p($g(^DHCEQUseRecord(URRowID)),"^",29)
	i TCancelDate'=""  s TCancelDate=##Class(web.DHCEQCommon).TransValueToPage(TCancelDate,"date")
	s TCancelUser=$p($g(^DHCEQUseRecord(URRowID)),"^",31)
	i TCancelUser'=""  s TCancelUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUser)
	s Amount=Amount+TTotalFee
	s Quantity=Quantity+1
	//modify by wl 2019-09-11   1025630 TPrice不需要合计,增加TWork合计
	s AmountTWorkLNum =AmountTWorkLNum+TWorkLoadNum //Add By QW20181030 需求号:686298 对此需求进行修正
	
	;Add by JDL 2010-11-09  JDL0057
	s TStartDate=$p($g(^DHCEQUseRecord(URRowID)),"^",43)
	i TStartDate'=""  s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TBGCS=0			//Add By DJ 2015-09-29 DJ0169 begin
	s TBRYJLSH=$p($g(^DHCEQUseRecord(URRowID)),"^",41)
	i passed'=0 d	//Add By QW20181030 需求号:686298 对此需求进行修正 符合条件后统一在此处理,以免重复计算
	.i TBRYJLSH'=""  d
	..i ('$D(^TempDHCEQ("UseRecord.JCL",$J,TExType,TBRYJLSH))&&(CancelFlag=0))  d		//当病人医技流水号检查量的使用记录不存在时,则登记该流水号且检查量加1
	...s ^TempDHCEQ("UseRecord.JCL",$J,TExType,TBRYJLSH)=1
	...s AmountJCL=AmountJCL+1
	..i ('$D(^TempDHCEQ("UseRecord.BGCS",$J,TExType,TBRYJLSH))&&(CancelFlag=0))  d		//当病人医技流水号曝光的使用记录不存在时,则登记该流水号且增加曝光次数
	...s ^TempDHCEQ("UseRecord.BGCS",$J,TExType,TBRYJLSH)=1
	...s TBGCS=##Class(web.DHCEQUseRecord).GetExposureNum(TExType,TBRYJLSH)
	...s AmountBGCS=AmountBGCS+TBGCS
	.i TPatientInfo'=""  d		//当同一天同一台仪器同一个病人的使用记录不存在时,则登记该检查人次信息且检查人次加1
	..i ('$D(^TempDHCEQ("UseRecord.JCRC",$J,TExType,StartDate,TSourceType,TSourceID,TPatientInfo))&&(CancelFlag=0))  d
	...s ^TempDHCEQ("UseRecord.JCRC",$J,TExType,StartDate,TSourceType,TSourceID,TPatientInfo)=1
	...s AmountJCRC=AmountJCRC+1	
	..;Add By QW20180928 需求号:686298 改正检查人次统计错误
	..i ('$D(^TempDHCEQ("UseRecord_JS.JCRC",$J,TExType,StartDate,TSourceType,TSourceID,TPatientInfo))&&(CancelFlag=1))  d
	...s ^TempDHCEQ("UseRecord_JS.JCRC",$J,TExType,StartDate,TSourceType,TSourceID,TPatientInfo)=1
	...s AmountJCRC=AmountJCRC-1
	..;End By QW20180928
	
	quit
OutputRowGetUseRecordList
	s Data=$lb(TRowID,TSourceType,TSourceID,TUseDate,TStartTime,TEndDate,TEndTime,TWorkLoadNum,TWorkLoadUnit,TUseLoc,TPatientInfo,TPrice,TTotalFee,TYear,TMonth,TServiceItem,TExType,TExID,TIsInputFlag,TStatus,TRemark,TAddUser,TModel,TEquipNo,TCancelDate,TCancelUser,TStartDate,TRow,TBGCS,TBRYJLSH,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1 //add by zx 2015-09-17
	//Modify By zx 2020-02-18 BUG ZX0074
	Set ^DHCEQTemp("UseRecordListReport",+$H,TJob,PNum)=TRowID_"^"_TSourceType_"^"_TSourceID_"^"_TUseDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TWorkLoadNum_"^"_TWorkLoadUnit_"^"_TUseLoc_"^"_TPatientInfo_"^"_TPrice_"^"_TTotalFee_"^"_TYear_"^"_TMonth_"^"_TServiceItem_"^"_TExType_"^"_TExID_"^"_TIsInputFlag_"^"_TStatus_"^"_TRemark_"^"_TAddUser_"^"_TModel_"^"_TEquipNo_"^"_TCancelDate_"^"_TCancelUser_"^"_TStartDate_"^"_TRow_"^"_TBGCS_"^"_TBRYJLSH
	Set PNum=PNum+1
	quit
ResetVariablesGetUseRecordList
	s (TRowID,TSourceType,TSourceID,TUseDate,TStartTime,TEndDate,TEndTime,TWorkLoadNum,TWorkLoadUnit,TUseLoc,TPatientInfo,TPrice,TTotalFee,TYear,TMonth,TServiceItem,TExType,TExID,TIsInputFlag,TStatus,TRemark,TAddUser,TModel,TEquipNo,TCancelDate,TCancelUser,TStartDate,TBGCS,TBRYJLSH)=""
	quit
}

ClassMethod GetUseRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseRecordListExecute ]
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

/// Add By QW20181112 需求号:746779 增加参数TotalFlag控制合计行的输出
/// modified by sjh SJH0041 2020-12-02 输出列标题修改
Query GetUseRecordList(vData As %String = "", UserDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", TotalFlag As %String = "1") As %Query(ROWSPEC = "TRowID:%String:ID,TSourceType:%String:来源类型,TSourceID:%String:来源ID,TUseDate:%String:使用日期,TStartTime:%String:开始时间,TEndDate:%String:结束日期,TEndTime:%String:结束时间,TWorkLoadNum:%String:工作量,TWorkLoadUnit:%String:单位,TUseLoc:%String:使用科室,TPatientInfo:%String:检查人次,TPrice:%String:价格,TTotalFee:%String:总费用,TYear:%String:年份,TMonth:%String:月份,TServiceItem:%String:服务,TExType:%String:对照类型,TExID:%String:对照数据ID,TIsInputFlag:%String:手工录入标志,TStatus:%String:状态,TRemark:%String:备注,TAddUser:%String:新增人,TModel:%String:型号,TEquipNo:%String:设备编号,TCancelDate:%String:作废日期,TCancelUser:%String:作废人,TStartDate:%String:开始日期,TRow:%String:序号,TBGCS:%String:曝光次数,TBRYJLSH:%String:检查量,Hidden:%String")
{
}

/******************************************************************************************/
ClassMethod GetUseRecordInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQUseRecord(rowid))
	i $p(result,"^",3)'=""  s $p(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")
	;i $p(result,"^",4)'=""  s $p(result,"^",4)=$ZT($p(result,"^",4),2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i $p(result,"^",4)'=""  s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"time")
	i $p(result,"^",5)'=""  s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
	;i $p(result,"^",6)'=""  s $p(result,"^",6)=$ZT($p(result,"^",6),2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i $p(result,"^",6)'=""  s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"time")
	i $p(result,"^",18)'=""  s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"bool")
	
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",8))
	s resultex=resultex_"^"
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",9))
	s resultex=resultex_"^"
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCServiceItem",$p(result,"^",15))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",28)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",28))),"^",2)
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

/******************************************************************************************/
ClassMethod GetStatus(Type As %Library.String) As %Status
{
	i Type=""  q ""
	i +Type=0  q "新增"
	i +Type=1  q "提交"
	i +Type=2  q "审核"
	;i +Type=3  q "报废"
	;Add by JDL 2010-11-09  JDL0057
	i +Type=3  q "作废"
	q "未定义"
}

/******************************************************************************************/
/// Oper参数说明  1:提交,2:取消提交,3:作废,4:删除
ClassMethod OperUseRecord(RowID, Oper)
{
	//modified By zy 2011-02-15 zy0054
	n User
	k PLIST
	// end zy0054
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i +Oper=1
	{
		s PLIST(20)=1
		s PLIST(33)=+$H
		s PLIST(34)=$p($H,",",2)
		s PLIST(35)=User
	}
	i +Oper=2 s PLIST(20)=0
	i +Oper=3
	{
		s PLIST(20)=3
		s PLIST(30)=+$H
		s PLIST(31)=$p($H,",",2)
		s PLIST(32)=User
	}
	i +Oper=4 s PLIST(21)="Y"
	&SQL(Update SQLUSER.DHC_EQUseRecord Values :PLIST() where UR_RowID = :RowID)
	i SQLCODE q SQLCODE
	q RowID
}

/******************************************************************************************/
ClassMethod GetUseConsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseConsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQUseRecord","GetUseConsumable","^Year=^Month=^EquipDR=^ServiceDR=^ModelDR=^UseLocDR=^PatientInfo=^ConsumableItemDR=^ItemDR=","01/11/2017","03/12/2018","1")
ClassMethod GetUseConsumableExecute(ByRef qHandle As %Binary, vData As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "") As %Status
{
	new repid, index,rowid,Start //modified By QW20181203 需求号:760425
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s TRow=1
	s rowid=0
	s Amount=0
	s ConsumAmount=0
	d BuildDataGetUseConsumable
	Quit $$$OK
BuildDataGetUseConsumable
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
	Set ServiceDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
	Set UserDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UserDR")
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	Set PatientInfo=##Class(web.DHCEQCommon).GetDataByName(vData,"PatientInfo")
	Set Year=##Class(web.DHCEQCommon).GetDataByName(vData,"Year")
	Set Month=##Class(web.DHCEQCommon).GetDataByName(vData,"Month")
	Set ConsumableItemDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ConsumableItemDR")
	Set ItemDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ItemDR")
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")   
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")   
	i StartDate=""
	{
		s Start=0
	}
	else
	{
		s Start=StartDate-1
	}
	s StartDate=Start
	i EndDate="" s EndDate=+$H
	f  s StartDate=$o(^DHCEQUseRecord(0,"UseDate",StartDate))  q:(StartDate="")||(StartDate>EndDate)  d
	.s SourceType=0
	.f  s SourceType=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType))  q:SourceType=""  d
	..s SourceID=0
	..f  s SourceID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType, SourceID))  q:SourceID=""  d
	...q:(SourceType=1)&&(EquipDR'="")&&(SourceID'=EquipDR)
	...q:(SourceType=2)&&(ItemDR'="")&&(SourceID'=ItemDR)
	...s URRowID=0
	...f  s URRowID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType, SourceID,URRowID))  q:URRowID=""  d
	....s UCIRowID=0
	....f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID))  q:UCIRowID=""  d
	.....d ResetVariablesGetUseConsumable
	.....d OtherInfo
	.....q:passed=0
	.....s TCancelDate=""
	.....s TCancelUser=""
	.....d OutputRowGetUseConsumable
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"CancelDate",StartDate,URRowID))  q:URRowID=""  d
	..s SourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	..s SourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	..q:(SourceType=1)&&(EquipDR'="")&&(SourceID'=EquipDR)
	..q:(SourceType=2)&&(ItemDR'="")&&(SourceID'=ItemDR)
	..s UCIRowID=0
	..f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID))  q:UCIRowID=""  d
	...d ResetVariablesGetUseConsumable
	...d OtherInfo
	...q:passed=0
	...s TTotalFee=0-TTotalFee
	...s TConsumFee=0-TConsumFee
	...s Amount=Amount+TTotalFee+TTotalFee
	...s ConsumAmount=ConsumAmount+TConsumFee+TConsumFee
	...d OutputRowGetUseConsumable
    d ResetVariablesGetUseConsumable
    s index=1
    s TRow=""
    s TSourceID="合计:"
    s TTotalFee=Amount
    s TConsumFee=ConsumAmount
    d OutputRowGetUseConsumable
    quit
OtherInfo
	s passed=1
	s SourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	s UseDate=$p($g(^DHCEQUseRecord(URRowID)),"^",3)
	s UseLoc=$p($g(^DHCEQUseRecord(URRowID)),"^",9)
	i (UseLocDR'="")&&(UseLoc'=UseLocDR)
	{
		s passed=0
		q
	}
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc))) //2010-10-28 DJ
	{
		s passed=0
		q
	}
	s Patient=$p($g(^DHCEQUseRecord(URRowID)),"^",10)
	i (PatientInfo'="")&&(Patient'[PatientInfo)
	{
		s passed=0
		q
	}
	s Nian=$p($g(^DHCEQUseRecord(URRowID)),"^",13)
	i (Year'="")&&(Nian'=Year)
	{
		s passed=0
		q
	}
	s Yue=$p($g(^DHCEQUseRecord(URRowID)),"^",14)
	i (Month'="")&&(Yue'=Month)
	{
		s passed=0
		q
	}
	s ServiceItem=$p($g(^DHCEQUseRecord(URRowID)),"^",15)
	i (ServiceDR'="")&&(ServiceItem'=ServiceDR)
	{
		s passed=0
		q
	}
	s AddUser=$p($g(^DHCEQUseRecord(URRowID)),"^",22)
	i (UserDR'="")&&(AddUser'=UserDR)
	{
		s passed=0
		q
	}
	s Model=$p($g(^DHCEQUseRecord(URRowID)),"^",28)
	i (ModelDR'="")&&(Model'=ModelDR)
	{
		s passed=0
		q
	}
	s Status=$p($g(^DHCEQUseRecord(URRowID)),"^",19)
	i (QXType=1)&&(Status<=1)
	{
		s passed=0
		q
	}
	s CIRowID=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",2)
	i (ConsumableItemDR'="")&&(CIRowID'=ConsumableItemDR)
	{
		s passed=0
		q
	}
	i CIRowID'=""  s TConsumableItem=$p($g(^DHCEQCCode("DHCEQCConsumableItem",CIRowID)),"^",1)
	s TWorkLoadUnit=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",3)
	i TWorkLoadUnit'=""  s TWorkLoadUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnit)
	s TWorkLoadNum=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",4)
	s TPrice=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",5)
	s TTotalFee=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",19) //add by zx 2014-09-28
	s TConsumFee=$p($g(^DHCEQUseConsumableItem(UCIRowID)),"^",6)
	i SourceType=1 s Item=$p($g(^DHCEQEquip(SourceID)),"^",7)
	i SourceType=2 s Item=SourceID
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	i EquipDR'=""
	{
		s EQItem=$p($g(^DHCEQEquip(EquipDR)),"^",7)
		i (SourceType=2)&&(Item'=EQItem)
		{
			s passed=0
			q
		}
	}
	i SourceID'=""  d
	.i SourceType=1  d
	..s TEquipNo=$p($g(^DHCEQEquip(SourceID)),"^",71)
	..s TSourceID=$p($g(^DHCEQEquip(SourceID)),"^",1)
	.i SourceType=2  d
	..s TEquipNo=""
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",1)
	i SourceType'="" s TSourceType=##Class(web.DHCEQEquipService).GetEditSourceType(SourceType)
	i UseDate'=""  s TUseDate=##Class(web.DHCEQCommon).TransValueToPage(UseDate,"date")
	s TStartTime=$p($g(^DHCEQUseRecord(URRowID)),"^",4)
	;i TStartTime'=""  s TStartTime=$zt(TStartTime,2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i TStartTime'=""  s TStartTime=##Class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TEndDate=$p($g(^DHCEQUseRecord(URRowID)),"^",5)
	i TEndDate'=""  s TEndDate=##Class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	s TEndTime=$p($g(^DHCEQUseRecord(URRowID)),"^",6)
	;i TEndTime'=""  s TEndTime=$zt(TEndTime,2)
	;日期格式统一调整    Modify by CSY 2017-03-02
	i TEndTime'=""  s TEndTime=##Class(web.DHCEQCommon).TransValueToPage(TEndTime,"time")
	i UseLoc'=""  s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	i ServiceItem'=""  s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItem)),"^",1)
	s TExType=$p($g(^DHCEQUseRecord(URRowID)),"^",16)
	s TExID=$p($g(^DHCEQUseRecord(URRowID)),"^",17)
	s TRemark=$p($g(^DHCEQUseRecord(URRowID)),"^",21)
	i AddUser'=""  s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",AddUser)
	i Model'=""  s TModel=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	i Status'=""  s TStatus=..GetStatus(Status)
	s TIsInputFlag=$p($g(^DHCEQUseRecord(URRowID)),"^",18)
	s TPatientInfo=Patient
	s TYear=Nian
	s TMonth=Yue
	s TCancelDate=$p($g(^DHCEQUseRecord(URRowID)),"^",29)
	i TCancelDate'=""  s TCancelDate=##Class(web.DHCEQCommon).TransValueToPage(TCancelDate,"date")
	s TCancelUser=$p($g(^DHCEQUseRecord(URRowID)),"^",31)
	i TCancelUser'=""  s TCancelUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUser)
	s Amount=Amount+TTotalFee
	s ConsumAmount=ConsumAmount+TConsumFee
	
	;Add by JDL 2010-11-09  JDL0057
	s TStartDate=$p($g(^DHCEQUseRecord(URRowID)),"^",43)
	i TStartDate'=""  s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	quit
OutputRowGetUseConsumable
	s Data=$lb(TRowID,TSourceType,TSourceID,TUseDate,TStartTime,TEndDate,TEndTime,TWorkLoadNum,TWorkLoadUnit,TUseLoc,TPatientInfo,TPrice,TTotalFee,TYear,TMonth,TServiceItem,TExType,TExID,TIsInputFlag,TStatus,TRemark,TAddUser,TModel,TConsumableItem,TEquipNo,TCancelDate,TCancelUser,TStartDate,TConsumFee,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetUseConsumable
	s (TRowID,TSourceType,TSourceID,TUseDate,TStartTime,TEndDate,TEndTime,TWorkLoadNum,TWorkLoadUnit,TUseLoc,TPatientInfo,TPrice,TTotalFee,TYear,TMonth,TServiceItem,TExType,TExID,TIsInputFlag,TStatus,TRemark,TAddUser,TModel,TConsumableItem,TEquipNo,TCancelDate,TCancelUser,TStartDate,TConsumFee)=""
	quit
}

ClassMethod GetUseConsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseConsumableExecute ]
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

Query GetUseConsumable(vData As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TUseDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TWorkLoadNum:%String,TWorkLoadUnit:%String,TUseLoc:%String,TPatientInfo:%String,TPrice:%String,TTotalFee:%String,TYear:%String,TMonth:%String,TServiceItem:%String,TExType:%String,TExID:%String,TIsInputFlag:%String,TStatus:%String,TRemark:%String,TAddUser:%String,TModel:%String,TConsumableItem:%String,TEquipNo:%String,TCancelDate:%String,TCancelUser:%String,TStartDate:%String,TConsumFee:%String,TRow:%String")
{
}

/******************************************************************************************/
/// ********************************************************************
/// 
/// 保存使用记录
/// Add by：JDL 20100713
/// 入参：InputFlag：是否手工录入标志，非手工录入的，只能插入不能修改
/// 		 val：
/// 返回：成功返回RowID，失败返回值小于等于0
ClassMethod SaveUseRecord(RowID, InputFlag, User, val)
{
	n (RowID, InputFlag, User, val)
	///非手工录入，不能修改
	i (RowID'="")&&(InputFlag'="Y") q 0
	
	s CurUser = User
	s CurDate = +$H
 	s CurTime = $P($H,",",2)
	
	s PLIST(2)=$p(val,"^",1)	;SourceType
	s PLIST(3)=$p(val,"^",2)	;SourceID
	s PLIST(4)=""
	s PLIST(5)=""
	s PLIST(6)=""
	s PLIST(7)=""	
	i $p(val,"^",3)'="" s PLIST(4)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;UseDate
	//i $p(val,"^",4)'="" s PLIST(5)=$ZTH($p(val,"^",4),2)	;StartTime
	;日期格式统一调整    Modify by CSY 2017-03-02
	i $p(val,"^",4)'=""  s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"time") ;StartTime
	i $p(val,"^",5)'="" s PLIST(6)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;EndDate
	//i $p(val,"^",6)'="" s PLIST(7)=$ZTH($p(val,"^",6),2)	;EndTime
	;日期格式统一调整    Modify by CSY 2017-03-02
	i $p(val,"^",6)'=""  s PLIST(7)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"time") ;EndTime
	s PLIST(8)=$p(val,"^",7)	;WorkLoadNum
	s PLIST(9)=$p(val,"^",8)	;WorkLoadUnitDR
	s PLIST(10)=$p(val,"^",9)	;UseLocDR
	s PLIST(11)=$p(val,"^",10)	;PatientInfo
	s PLIST(12)=$p(val,"^",11)	;Price
	s PLIST(13)=$p(val,"^",12)	;TotalFee
	s PLIST(14)=$p(val,"^",13)	;Year
	s PLIST(15)=$p(val,"^",14)	;Month
	s PLIST(16)=$p(val,"^",15)	;ServiceItemDR
	s PLIST(17)=$p(val,"^",16)	;ExType
	s PLIST(18)=$p(val,"^",17)	;ExID
	s PLIST(19)=$p(val,"^",18)	;IsInputFlag
	
	;Add by JDL 2010-11-09  JDL0057
	i $p(val,"^",3)'="" s PLIST(44)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;StartDate
	 
	
	;如果是系统采集数据,检查是否已经采集过该记录，
	;如果采集过，返回不操作
	i (InputFlag'="Y")
	{
		s ExType=$p(val,"^",16)
		s ExID=$p(val,"^",17)
		i $o(^DHCEQUseRecord(0,"ExID",ExType,ExID,0))'="" q 0
	}
	
	;Status,系统采集时直接置为审核状态，否则置为新增
	i InputFlag="Y"
	{	s Status=0	}
	else
	{	s Status=2	}
	s PLIST(20)=Status
	s PLIST(21)="N"	;InvalidFlag
	s PLIST(22)=$p(val,"^",21)	;Remark
	
	i RowID=""
	{
		s PLIST(23)=CurUser	;AddUserDR
		s PLIST(24)=CurDate	;AddDate
		s PLIST(25)=CurTime	;AddTime
	}
	s PLIST(26)=CurUser	;UpdateUserDR
	s PLIST(27)=CurDate	;UpdateDate
	s PLIST(28)=CurTime	;UpdateTime
	
	s PLIST(29)=$p(val,"^",28)	;ModelDR
	s PLIST(39)=$p(val,"^",38)		//DoctorOrderID			//Add By DJ 2015-09-29 DJ0169 begin
	s PLIST(40)=$p(val,"^",39)		//Operator
	s PLIST(41)=$p(val,"^",40)		//PositiveFlag
	s PLIST(42)=$p(val,"^",41)		//SampleNo
	s PLIST(43)=$p(val,"^",42)		//ExposureNum
	s PLIST(45)=$p(val,"^",43)		//PatientSex
	s PLIST(46)=$p(val,"^",44)		//PatientAge
	s PLIST(47)=$p(val,"^",45)		//PatientName
	s PLIST(48)=$p(val,"^",46)		//OtherInfo
	s PLIST(49)=$p(val,"^",47)		//Hold1
	s PLIST(50)=$p(val,"^",48)		//Hold2
	s PLIST(51)=$p(val,"^",49)		//Hold3
	s PLIST(52)=$p(val,"^",50)		//Hold4
	s PLIST(53)=$p(val,"^",51)		//Hold5				//Add By DJ 2015-09-29 DJ0169 end
	
	Set $ZT="TrapSaveUseRecord"
	TStart
	
	i RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseRecord Values :PLIST())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQUseRecord Values :PLIST() where UR_RowID = :RowID)
	}
 	if SQLCODE 
 	{
	 	TRollBack
	 	q SQLCODE
 	}
 	i RowID="" Set RowID=$g(%ROWID)
 	i Status=2  s SQLCODE=..InsertUseConsumableItem(RowID)
 	if SQLCODE 
 	{
	 	TRollBack
	 	q SQLCODE
 	}
 	TCommit
 	q RowID
TrapSaveUseRecord
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK
 	q -1
}

/// 生成使用记录相关的消耗项目
/// 入参：
/// 		UseRecordID：使用记录ID
/// 返回值：
/// 		成功返回0，失败返回SQLCODE
ClassMethod InsertUseConsumableItem(UseRecordID)
{
	n (UseRecordID)
	i UseRecordID="" q 0
	s SourceType=$p($g(^DHCEQUseRecord(UseRecordID)),"^",1)
	s SourceID=$p($g(^DHCEQUseRecord(UseRecordID)),"^",2)
	s ServiceItemDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",15)
	s ModelDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",28)
	s URNum=$p($g(^DHCEQUseRecord(UseRecordID)),"^",7)
	s StoreLocDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",9)	//czf 1915092 2021-05-22
	
	;Add by JDL 2010-11-09  JDL0057
	s UseLocDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",9)
	s AddDate=+$H
	s UseDate=$p($g(^DHCEQUseRecord(UseRecordID)),"^",3)	
	k UCIList
	s UCIList(2)=UseRecordID
	s UCIList(10)=UseLocDR
	s UCIList(13)=ServiceItemDR
	s UCIList(16)=AddDate
	s UCIList(17)=UseDate
	s Modulus=1
	s Node="Source"
	s ItemDR=ServiceItemDR
	
	s SQLCODE=0
	s FindFlag=0	
	d CheckUCI
	;出错返回错误码
	i SQLCODE q SQLCODE
	;当有相应的服务项目消耗定义，返回SQLCODE
	i FindFlag=1 q SQLCODE
	
	;Add by JDL 2010-11-09  JDL0057
	;根据服务项包含的明细项是否有定义消耗
	d CheckServiceDetail	
	i SQLCODE q SQLCODE
	i FindFlag=1 q SQLCODE
	
	;当没有设备服务消耗定义时，则检测对应设备项服务消耗定义
	i (FindFlag=0)&&(SourceType=1)
	{
		;Add by JDL 2010-11-09  JDL0057
		s Modulus=1
		s Node="Source"
		s ItemDR=ServiceItemDR
		
		s SourceType=2
		s SourceID=$p($g(^DHCEQEquip(SourceID)),"^",7)
		d CheckUCI
		
		;Add by JDL 2010-11-09  JDL0057
		;当设备项服务没有对应消耗定义
		;判断服务项包含的明细项是否有定义消耗
		i SQLCODE q SQLCODE
		i FindFlag=1 q SQLCODE		
		d CheckServiceDetail	
		i SQLCODE q SQLCODE
		i FindFlag=1 q SQLCODE
	}
	
	;当设备及设备项都没有服务消耗定义时，则检测服务消耗定义
	s ConsumableRowID=0
	f  s ConsumableRowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemDR,ConsumableRowID))  q:(ConsumableRowID="")||(SQLCODE'=0)  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemDR,ConsumableRowID,RowID))  q:((RowID="")||(SQLCODE'=0))  d
	..s SCSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",1)
	..q:SCSourceType'=""
	..s SCSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",2)
	..q:SCSourceID'=""
	..s FindFlag=1
	..d InsertUCI
	
	;Add by JDL 2010-11-09  JDL0057
	;当服务项没有对应消耗定义,判断服务项包含的明细项是否有定义消耗
	i SQLCODE q SQLCODE
	i FindFlag=1 q SQLCODE
	s ItemDR=0
	f  s ItemDR=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR))  q:(ItemDR="")||(SQLCODE'=0)  d 
	.s SDRowID=0
	.f  s SDRowID=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR,SDRowID))  q:(SDRowID="")||(SQLCODE'=0)  d 
	..q:$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",5)'="N"
	..s Modulus=$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",3)
	..i Modulus="" s Modulus=1
	..s RowID=0
	..f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServDetItem",ItemDR,RowID))  q:(RowID="")||(SQLCODE'=0)  d
	...s SCSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",1)
	...q:SCSourceType'=""
	...s SCSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",2)
	...q:SCSourceID'=""
	...d InsertUCI

	q SQLCODE
CheckServiceDetail
	;Add by JDL 2010-11-09  JDL0057
	;根据服务项包含的明细项是否有定义消耗
	s Node="SourceServDetItem"
	s ItemDR=0
	f  s ItemDR=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR))  q:(ItemDR="")||(SQLCODE'=0)  d 
	.s SDRowID=0
	.f  s SDRowID=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR,SDRowID))  q:(SDRowID="")||(SQLCODE'=0)  d 
	..q:$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",5)'="N"
	..s Modulus=$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",3)
	..i Modulus="" s Modulus=1
	..d CheckUCI
	q	
CheckUCI
	s ConsumableRowID=0
	q:(SourceType="")||(SourceID="")||(ItemDR="")
	f  s ConsumableRowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,Node,SourceType,SourceID,ItemDR,ConsumableRowID)) q:(ConsumableRowID="")||(SQLCODE'=0)  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,Node,SourceType,SourceID,ItemDR,ConsumableRowID,RowID))  quit:((RowID="")||(SQLCODE'=0))  d
	..;s FindFlag=1
	..;当SourceType为设备项时，需要判断机型是否一致
	..s CISModelDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",7)
	..q:((SourceType=2)&&(CISModelDR'="")&&(CISModelDR'=ModelDR))
	..;Add by JDL 2010-11-09  JDL0057
	..s CISStoreLocDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",16)	//czf 1915092 2021-05-22
	..q:((SourceType=2)&&(CISStoreLocDR'="")&&(CISStoreLocDR'=StoreLocDR))
	..s FindFlag=1
	..d InsertUCI
	q
InsertUCI
	s ConsumableItemDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",4)
	s UOMDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",5)
	s Quantity=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",6)
	s Quantity=URNum*Quantity*Modulus
	s TPrice=##Class(web.DHCEQUseRecord).GetConsumableItemPrice(ConsumableItemDR,UOMDR)  //add by zx 2014-09-16 统计收费
	s Price=$P(TPrice,"^",1)  
	s PayPrice=$P(TPrice,"^",2)
	s Amount=Quantity*Price
	s PayAmount=Quantity*PayPrice
	;Add by JDL 2010-11-09  JDL0057
	s QuantityType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",8)
	s ServDetItem=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",9)
	s ExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",5)
	s ExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",6)
	s UCIList(3)=ConsumableItemDR
	;绝对量的时候，才保存数量及单价金额
	i QuantityType="1"
	{
		s UCIList(4)=UOMDR
		s UCIList(5)=Quantity
		s UCIList(6)=Price
		s UCIList(7)=Amount
		s UCIList(28)=PayPrice  //add  by zx 2014-09-16 
		s UCIList(29)=PayAmount
		k UCIList(9)
	}
	else
	{
		k UCIList(4)
		k UCIList(5)
		k UCIList(6)
		k UCIList(7)
		k UCIList(28)
		k UCIList(29)
		s UCIList(9)=Quantity	;RelativeQty
	}
	s UCIList(8)=QuantityType
	s UCIList(11)=ExType
	s UCIList(12)=ExID
	s UCIList(14)=ServDetItem
	s UCIList(15)=URNum*Modulus
	&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem values :UCIList())	
	
	;&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem (UCI_UseRecordDR,UCI_ConsumableItemDR,UCI_UOMDR,UCI_Quantity,UCI_Price,UCI_Amount) Values (:UseRecordID,:ConsumableItemDR,:UOMDR,:Quantity,:Price,:Amount))
	q
}

/// 获取消耗项目的单价
/// add by zx 2014-09-16 同时获取收费
ClassMethod GetConsumableItemPrice(ConsumableItemDR, UOMDR)
{
	n (ConsumableItemDR,UOMDR)
	i ConsumableItemDR="" q ""
	;单位不一致，返回空
	i UOMDR'=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",4) q ""
	q $p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",3)_"^"_$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",9)
}

/// 审核设备的使用记录，仅用于审核手工录入的使用记录
/// 入参：UseRecordID：使用记录ID
/// 	  UserDR：操作员
/// 返回：成功返回UseRecordID，失败返回值小于等于0
/// 	
ClassMethod AuditUseRecord(UseRecordID, UserDR)
{
	n (UseRecordID, UserDR)
	i UseRecordID="" q 0
	
	;非手工录入的不能操作
	i $p($g(^DHCEQUseRecord(UseRecordID)),"^",18)'="Y" q 0
	
	;状态非新增或提交的不能审核
	i +$p($g(^DHCEQUseRecord(UseRecordID)),"^",19)>1 q 0
	
	;无效的不能审核
	i $p($g(^DHCEQUseRecord(UseRecordID)),"^",20)'="N" q 0
	
	s $ZT="TrapAuditUseRecord"
	s PLIST(26)=UserDR	;UpdateUserDR
	s PLIST(27)=+$H		;UpdateDate
	s PLIST(28)=$P($H,",",2)	;UpdateTime
	s PLIST(20)=2	;Status
	s PLIST(36)=+$H ;AuditDate
	s PLIST(37)=$P($H,",",2) ;AuditTime
	s PLIST(38)=UserDR ;AuditUser
	TSTART
	&SQL(Update SQLUSER.DHC_EQUseRecord Values :PLIST() where UR_RowID = :UseRecordID)
	if SQLCODE 
 	{
	 	TRollBack
	 	q SQLCODE
 	}
 	s SQLCODE=..InsertUseConsumableItem(UseRecordID)
 	if SQLCODE 
 	{
	 	TRollBack
	 	q SQLCODE
 	}
 	TCommit
 	q UseRecordID
TrapAuditUseRecord
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK
 	q -1
}

/// Add By DJ 2015-09-29 DJ0169
/// 描述:获取曝光次数
/// 相同的医技流水号多条记录曝光次数相同时取一条记录的曝光次数，不同时去每条记录的曝光次数总和
ClassMethod GetExposureNum(vExType, vBRYJLSH)
{
	n FindOne,FindTwo,BGCSNum,BGCSCount,URRowID
	i ((vExType="")||(vBRYJLSH="")) q 0
	
	s FindOne=$o(^DHCEQUseRecord(0,"ExposureNum",vExType,vBRYJLSH,0))
	i FindOne="" q 0
	s FindTwo=$o(^DHCEQUseRecord(0,"ExposureNum",vExType,vBRYJLSH,FindOne))
	i FindTwo=""  q FindOne
	
	s BGCSCount=0
	s BGCSNum=0
	f  s BGCSNum=$o(^DHCEQUseRecord(0,"ExposureNum",vExType,vBRYJLSH,BGCSNum))  q:BGCSNum=""  d
	..s URRowID=0
	..f  s URRowID=$o(^DHCEQUseRecord(0,"ExposureNum",vExType,vBRYJLSH,BGCSNum,URRowID))  q:URRowID=""  d
	...s BGCSCount=BGCSCount+BGCSNum
	
	q BGCSCount
}

Storage Default
{
<Data name="DHCEQUseRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQUseRecordD</DataLocation>
<DefaultData>DHCEQUseRecordDefaultData</DefaultData>
<IdLocation>^web.DHCEQUseRecordD</IdLocation>
<IndexLocation>^web.DHCEQUseRecordI</IndexLocation>
<StreamLocation>^web.DHCEQUseRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
