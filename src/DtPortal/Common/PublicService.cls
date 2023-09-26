/// ClassName:    DtPortal.Common.PublicService
/// Description:  公共服务
/// Creator：     zhufei
/// CreatDate:    2014-07-23
Class DtPortal.Common.PublicService Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-07-23
/// Description:  用户代码转换为用户ID
/// Table：       SS_User
/// Input：       aUserCode     ：医生代码(SS_User.SSUSR_Initials)
/// Return：      UserID
/// w ##class(DtPortal.Common.PublicService).GetUserID(245)
ClassMethod GetUserID(aUserCode As %String) As %String
{
	Set $ZT="GetUserID"
	Set return=""
	Quit:aUserCode="" return
	Set aUserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	Quit:aUserCode="" return
	Set return=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
	Quit return
GetUserID
	q -1
}

/// Creator：     zhufei
/// CreatDate：   2014-07-23
/// Description:  科室代码转换为科室ID
/// Table：       CT_Loc
/// Input：       aLocCode     ：科室代码(CT_Loc.CTLOC_Code)
/// Return：      LocID
/// w ##class(DtPortal.Common.PublicService).GetLocID("产科")
ClassMethod GetLocID(aLocCode As %String) As %String
{
	Set return=""
	Quit:aLocCode="" return
	
	Set aLocCode=$$ALPHAUP^SSUTIL4(aLocCode)
	Quit:aLocCode="" return
	Set return=$o(^CTLOC(0,"Code",aLocCode,0))
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2014-09-1
/// Description:  查询院区
/// Table：       User.CTLOC
/// Return：      科室ID，院区描述
/// d ##Class(%ResultSet).RunQuery("DtPortal.Common.PublicService","getHosp")
Query getHosp() As DtPortal.Query(ROWSPEC = "hospID,hospDesc")
{
}

ClassMethod getHospExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    set hospID=0
    Set Data=$lb("","全院")
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
	for
	{
		set hospID=$o(^CT("HOSP",hospID))
		quit:hospID=""
		
		set hospDesc=$p(^CT("HOSP",hospID),"^",2)
		Set Data=$lb(hospID,hospDesc)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	
	
    Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-11-6
/// Description:  查询病区
/// Table：       PAC_Ward
/// Input：       inputStr     ：病区首字母或者汉字
/// Return：      病区ID，病区Code
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PublicService","FindWard","")
Query FindWard(inputStr As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "WardID:%String,WardLocId:%String,WardCode:%String")
{
}

ClassMethod FindWardExecute(ByRef qHandle As %Binary, inputStr As %String, hospitalId As %String = "") As %Status
{
    Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    set inputStr=$$ALPHAUP^SSUTIL4(inputStr)
	set LocID=""
	for
	{
		set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		set LocType=$P($g(^CTLOC(LocID)),"^",13)
		set hospID=$p($g(^CTLOC(LocID)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		continue:LocType'="W"
		
		set WardID=""
		for
		{
			set WardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,WardID))
			quit:WardID=""
			Set WardLocId=$p($g(^PAWARD(WardID)),"^",5)  //对应CT_Loc表中科室ID
			
			set WardDesc=$p(^PAWARD(WardID),"^",2)
			Continue:WardDesc'[inputStr
			Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
			Set Data=$lb(WardID,WardLocId,WardDesc)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
		
	}
	
	
    Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-09-1
/// Description:  查询科室
/// Table：       User.CTLOC
/// Input：       inputStr     ：科室首字母或者汉字
/// Return：      科室ID，科室描述
/// d ##Class(%ResultSet).RunQuery("DtPortal.Common.PublicService","FindLoc","w")
Query FindLoc(inputStr As %String) As DtPortal.Query(ROWSPEC = "LocRowID:%String,LocDesc:%String")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary, inputStr As %String) As %Status
{
    Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    set inputStr=$$ALPHAUP^SSUTIL4(inputStr)
	set LocRowID=""
	for
	{
		set LocRowID=$o(^CTLOC(LocRowID))
		q:LocRowID=""
		set LocDesc=$p(^CTLOC(LocRowID),"^",2)
		set LocType=$p(^CTLOC(LocRowID),"^",19)
		continue:LocType'="2"    						//取住院科室（临床科室）
		Continue:LocDesc'[inputStr
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Set Data=$lb(LocRowID,LocDesc)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	
	
    Quit $$$OK
}

/// 根据科室Code获取科室信息
/// w ##class(DtPortal.Common.PublicService).getLocInforByLocCode("4829")
ClassMethod getLocInforByLocCode(locCode)
{
	Set returnData=##Class(DtPortal.OutPut).%New()
	Set $ZT="LocInForErr"
	Set locRowId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(locCode),""))

	Set locDesc = $p(^CTLOC(locRowId),"^",2)	//科室描述
	Set locLevel = ""
	Set Super = ""
	Set State = "1"					//状态，1、新增；3、修改；2、删除
	Set isLast = ""					//
	Set Type = $p(^CTLOC(locRowId),"^",13)	//科室状态
	
	Set CTLOCDepDR = $p(^CTLOC(locRowId),"^",19)
	if CTLOCDepDR = ""{
		Set DGroup = ""	
	}else{
		Set DGroup = $p(^RBC("DEP",CTLOCDepDR),"^",1)
	}  
	Set Classify = ""		//
	Set Address = $g(^CTLOC(locRowId,"ADDR",1))	//地址
	Set Phone = $p(^CTLOC(locRowId),"^",40)
	Set Mnemonics = $p(^CTLOC(locRowId),"^",43)
	
	Set startDate = $p(^CTLOC(locRowId),"^",24)
	if startDate'="" Set startDate=$zd(startDate,3)
	
	Set endDate = $p(^CTLOC(locRowId),"^",25)
	if endDate'="" Set endDate=$zd(endDate,3)
	Set Storey = ""
	Set Catalogue = ""
	Set Dept = ""
	Set returnData.data=locCode_"^"_locDesc_"^"_locLevel_"^"_Super_"^"_State_"^"_isLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_startDate_"^"_endDate_"^"_Storey_"^"_Catalogue_"^"_Dept
	Set returnData.status = 1
	Set returnData.errMSG = ""
	
	Quit returnData
	
LocInForErr
	Set returnData.status = -1
	Set returnData.errMSG = $ZE
	Set returnData.data = ""
	
	Quit returnData
}

/// 获取数量方法捕获的封装，主要用于查询多个方法数量时，一个报错导致方法报错
/// Creator： bmz
/// CreatDate： 2018-11-04
/// Description: 查询某类医嘱总例数
/// Input：  Type- Query、ClassMethod    ClassName-类名称  ClassMethodName-方法名称 Params-参数串（用$c(9813)分割）      
/// Return：    ERR-代码异常或传参错误  数字-正常状态
/// w ##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0201CriticalValueService","D020101GetCVinfo","P"_$c(9813)_"ys01"_$c(9813)_"true")
/// w ##class(DtPortal.Common.PublicService).GetCommonMethodNum("ClassMethod","DtPortal.Doctor.ClinicPrompt.CommonService","GetUndoConsultationNum","P"_$c(9813)_"ys01"_$c(9813)_"true")
ClassMethod GetCommonMethodNum(Type, ClassName, ClassMethodName, Params) As %String [ ProcedureBlock = 0 ]
{
	new (Type,ClassName,ClassMethodName,Params)
	set retNum=0
	if (Type'="Query")&(Type'="ClassMethod") q "ERR"
	try {
		if (Type="Query") {
			set qdf=##class(%Dictionary.QueryDefinition).%OpenId(ClassName_"||"_ClassMethodName,0)
			if '$IsObject(qdf) s retNum="ERR" q //类或方法名不存在
			set paras=qdf.FormalSpec
			set:paras="" parasCount=0
			set:paras'="" parasCount=$l(paras,",")
			set rs=##class(%ResultSet).%New(ClassName_":"_ClassMethodName)
			if parasCount=0 {
				d rs.Execute()
			}
			else{
				set execute="set %sc=$zobjmethod(rs,""Execute"",",i=0
				while (i<(parasCount)){
					set i=i+1
					set execute=execute_"$s($p("""_Params_""","""_$C(9813)_""","_i_")=$c(0):"""",1:$p("""_Params_""","""_$C(9813)_""","_i_"))"
					if (i<parasCount) {set execute=execute_","}
				}
				set execute=execute_")"
				
				x execute
			} 
			While rs.Next() 
			{
				;b ;01
				set retNum=retNum+1
			}
		}
		elseif (Type="ClassMethod"){
			s mdf=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_ClassMethodName,0)
			if '$IsObject(mdf) s retNum="ERR" q //类或方法名不存在
			set paras=mdf.FormalSpec
			set:paras="" parasCount=0
			set:paras'="" parasCount=$l(paras,",")
			set ret=""
			set execute="s ret=$ZOBJCLASSMETHOD(ClassName,ClassMethodName"
			if parasCount=0 {
				set execute=execute_")"
				x execute
			} else {
				set i=0
				while (i<parasCount){
					set i=i+1
					//set execute=execute_",$s($p("""_parameters_""","","","_i_")=$c(0):"""",1:$p("""_parameters_""","","","_i_"))"
					set execute=execute_",$s($p("""_Params_""","""_$C(9813)_""","_i_")=$c(0):"""",1:$p("""_Params_""","""_$C(9813)_""","_i_"))"
					
					// set execute=execute_",$p("""_parameters_""","","","_i_")"
					//set execute=execute_",$g(p"_i_")"
				}
				set execute=execute_")"
				x execute
			}
			s retNum=ret
		}
		
	} catch exp{
		/*
		WRITE !,"This is the CATCH exception handler",!
      IF 1=exp.%IsA("%Exception.SystemException") {
         WRITE "System exception",!
         WRITE "Name: ",$ZCVT(exp.Name,"O","HTML"),!
         WRITE "Location: ",exp.Location,!
         WRITE "Code: ",exp.Code,!
         WRITE "Data: ",exp.Data,!!
      }
      ELSE { WRITE "not a system exception",!!}
      WRITE "$ZERROR: ",$ZERROR,!
      WRITE "$ECODE: ",$ECODE
      */
       WRITE "$ZERROR: ",$ZERROR,!
      set retNum="ERR"

	}
	
	q retNum
}

/// Creator：     bmz
/// CreatDate：   2018-11-05
/// Description:  用户代码转换为医护人员ID
/// Input：       aUserCode     ：医生代码(SS_User.SSUSR_Initials)
/// Return：      UserID
/// w ##class(DtPortal.Common.PublicService).GetDocIDByUserCode(245)
ClassMethod GetDocIDByUserCode(aUserCode As %String) As %String
{
	Set $ZT="GetDocIDByUserCode"
	Set return=""
	Quit:aUserCode="" return
	Set aUserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	Quit:aUserCode="" return
	Set userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
	Quit:userID="" return
	Set return=$P($g(^SSU("SSUSR",userID)),"^",14)    //当前医生医护人员表id
	Quit return
GetDocIDByUserCode
  	q -1
}

/// 取医疗单元医生列表 "^"分隔
/// Creator：     朱飞
/// CreatDate：   bmz2018-11-05迁移
/// Description:  通过医护人员ID获取医疗单元DocID串
/// Input：       aDocID     
/// Return：      UserID
/// w ##class(DtPortal.Common.PublicService).GetMUDocList(245)
ClassMethod GetMUDocList(aDocID As %String) As %String
{
	Set $ZT="GetMUDocList"
	Set return=""
	Quit:aDocID="" return
	
	Set tmpMedUnit=##class(web.DHCCTLocMedUnit).getMedUnit("",aDocID)
	Set MedUnitID=$p(tmpMedUnit,"^",1)
	Quit:MedUnitID="" return
	Set LocID=$p(MedUnitID,"||",1)
	Set MUSub=$p(MedUnitID,"||",2)
	Set xMUCPSub=""
	For {
		Set xMUCPSub=$O(^CTLOC(LocID,"MU",MUSub,"CP",xMUCPSub))
		Quit:xMUCPSub=""
		
		Set tmpMUCP=$g(^CTLOC(LocID,"MU",MUSub,"CP",xMUCPSub))
		Set DocID=$p(tmpMUCP,"^",1)
		Set DateFrom=$p(tmpMUCP,"^",5)
		Set DateTo=$p(tmpMUCP,"^",6)
		Continue:(DateFrom'="")&&(DateFrom>+$h)
		Continue:(DateTo'="")&&(DateTo<+$h)
		Continue:$LF($LISTFROMSTRING(return,"^"),DocID)
		Set return=return_"^"_DocID
	}
	Set:return'="" return=return_"^"
	Quit return
	
GetMUDocList
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-02
/// Description:  根据数据规则配置code查询配置值
/// Table：       DtPortal_Configure.DataRule
/// Input：       数据配置code
/// w ##Class(DtPortal.Common.PublicService).getValueByCode("ARREARSFLAG")
ClassMethod getValueByCode(code = "") As %String
{
	 Set $ZT="getValueByCode"
	 quit:code="" ""
	 set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleCodeIndex"," "_code,""))
	 quit:rowID="" ""
 	 set value=$Li(^DtPortal.Configure.DataRuleD(rowID),6)
	 set value=$tr(value,$c(9813),"^")
	 q value
getValueByCode
	 q -1
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-28
/// Description:  获取月的第一天
/// Input：       YearMonth   格式如 2018-01
/// 				  type  1:返回字符串(如 2018-01-01)  2 返回 cache  date格式(如 12345)
/// date     
/// w ##Class(DtPortal.Common.PublicService).getFirstDayOfMonth("2018-01",1)
ClassMethod getFirstDayOfMonth(YearMonth, type = 1) As %String
{
	 Set $ZT="getFirstDayOfMonth"
	 set return=""
	 quit:YearMonth="" return
	 set year=$p(YearMonth,"-",1)
	 set month=$p(YearMonth,"-",2)
	 quit:((year="")||(month="")) return
	 
	 set date=YearMonth_"-01"
	 
	 set:type=1 return=date
	 set:type=2 return=$zdh(date,3)
	 q return
getFirstDayOfMonth
	 q -1
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-28
/// Description:  获取月的最后一天
/// Input：       YearMonth   格式如 2018-01
/// 				  type  1:返回字符串(如 2018-01-31)  2 返回 cache  date格式(如 12345)
/// date     
/// w ##Class(DtPortal.Common.PublicService).getLastDayOfMonth("2018-01",1)
ClassMethod getLastDayOfMonth(YearMonth, type = 1) As %String
{
	 Set $ZT="getLastDayOfMonth"
	 
	 set return=""
	 quit:YearMonth="" return
	 set year=$p(YearMonth,"-",1)
	 set month=$p(YearMonth,"-",2)
	 quit:((year="")||(month="")) return
	 
	 //取下个月的第一天
	 set year1=year
	 set month1=month+1
	 set:month=12 year1=+year+1,month1=1
	 
	 set date1=$zdh(year1_"-"_month1_"-01",3)
	 set lastDay=date1-1
	 
	 set:type=1 return=$zd(lastDay,3)
	 set:type=2 return=lastDay
	 q return
getLastDayOfMonth
	 q -1
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-28
/// Description:  获取某月天数
/// Input：       YearMonth   格式如 2018-01
/// 				  天数
/// date     
/// w ##Class(DtPortal.Common.PublicService).getMonthDay("2018-01")
ClassMethod getMonthDay(YearMonth) As %String
{
	 Set $ZT="getMonthDay"
	 
	 set FirstDayOfMonth=##Class(DtPortal.Common.PublicService).getFirstDayOfMonth(YearMonth,2)
	 set LastDayOfMonth=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(YearMonth,2)
	 q LastDayOfMonth-FirstDayOfMonth+1
getMonthDay
	 q -1
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断床位是否包床
/// Input：	bedId
/// Return：
/// Debug：w ##class(DtPortal.Common.PublicService).ifBaoChuang("5||1")
ClassMethod ifBaoChuang(bedId As %String = "") As %String
{
	Set $ZT="ERRifBaoChuang"
	
	s baoFlag=0
	s baoFlag=0  //包床标记
	s StatSub=0  //循环包床记录
	f  s StatSub=$o(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)) q:StatSub=""  d
	.s startDate=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",1)
	.s startTime=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",2)
	.s endDate=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",5)
	.s endTime=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",6)
	.i (endDate'="")&&(endTime="") s endTime=86400
	.s startTotal=startDate*100000+startTime
	.s endTotal=endDate*100000+endTime
	.s nowTotal=+$h*100000+$p($h,",",2)
	.s StatusId=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",7)
	.i StatusId'="" s StatusDesc=$p($g(^PAC("RNAV",StatusId)),"^",2) 
	.e  s StatusDesc="" 
	.i (endDate'="")&&(nowTotal>=startTotal)&&(nowTotal<=endTotal)&&(StatusDesc["包床") s baoFlag=1
	.i (endDate="")&&(startTotal<=nowTotal)&&(StatusDesc["包床") s baoFlag=1
	.i (endDate'="")&&(nowTotal>=startTotal)&&(nowTotal<=endTotal)&&(StatusDesc'="")&&(StatusDesc'["包床") s baoFlag=2_"^"_StatusDesc
	.i (endDate="")&&(startTotal<=nowTotal)&&(StatusDesc'="")&&(StatusDesc'["包床") s baoFlag=2_"^"_StatusDesc
	q baoFlag
	
ERRifBaoChuang
	 q -1
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 转换日期格式，把his里面返回的日期格式转换为  YYYY-MM-DD
/// Input：	bedId
/// Return：
/// Debug：w ##class(DtPortal.Common.PublicService).dateFormat("10/11/2017")
ClassMethod dateFormat(date As %String = "") As %String
{
	q:date="" ""
	Set $ZT="ERRdateFormat"
	s retDate=date
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	i dateformat="DMY" d
	.i date["/" s retDate=$zd($zdh(date,4),3)
	if (dateformat="MDY") d
	.i date["/" s retDate=$zd($zdh(date),3)
	q retDate
	
ERRdateFormat
	 q -1
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 获取科室关联的病区串
/// Input：	科室ID串（使用"^"分割）
/// Return：科室病区ID串
/// Debug：w ##class(DtPortal.Common.PublicService).getWardLocStrByLocIDStr("110")
ClassMethod getWardLocStrByLocIDStr(LocIDStr As %String = "") As %String
{
	Set $ZT="ERRgetWardLocStrByLocIDStr"
	q:LocIDStr="" ""
	s retWardLocId=""
	
	s length=$l(LocIDStr,"^")
	for i=1:1:length{
		s locID=$p(LocIDStr,"^",i)
		continue:+locID=0
		s linkSub=0
		
		for {
			s linkSub=$o(^CTLOC(locID,"LINK",linkSub)) 
			q:linkSub=""
			s wardLocId=^CTLOC(locID,"LINK",linkSub)
			continue:+wardLocId=0
			s wardLocType=$P(^CTLOC(wardLocId),"^",13)
			continue:wardLocType'="W"
			if (retWardLocId=""){
				 set retWardLocId=wardLocId
			}else{
				
				//不取重复的和只取病区的
				if ('$LF($LISTFROMSTRING(retWardLocId,"^"),wardLocId)){
					set retWardLocId=retWardLocId_"^"_wardLocId
				}
			}
		}
	}
	
	
	q retWardLocId
	
ERRgetWardLocStrByLocIDStr
	q -1
}

// w ##class(DtPortal.Common.PublicService).GetSpec("110||1")

/// 获取医嘱项规格
ClassMethod GetSpec(ArcimRowid As %String)
{
	Set $ZT="ERRGetSpec"
 	s ARCIMsub=$p(+ArcimRowid,$c(1),1)
	s Inciid=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
    q:Inciid="" ""
    s info=$o(^DHCITMINFO(0,"INCI",Inciid,""))
    q:info="" ""
    s spec=$p(^DHCITMINFO(info),"^",27)
    i spec["[" d
    .s spec=$tr(spec,"[","")
    .s spec=$tr(spec,"]","")
   	q spec
   	
ERRGetSpec
	q -1
}

// 获取医嘱项描述

// w ##class(DtPortal.Common.PublicService).GetArcimDesc("110||1")

ClassMethod GetArcimDesc(ArcimRowid As %String)
{
	Set $ZT="ERRGetArcimDesc"
	s arcimDesc=""
    s mArcItemDrF=$p(ArcimRowid,"||",1)
 	s mArcItemDrS=$p(ArcimRowid,"||",2)
 	q:($G(mArcItemDrF)="")!($G(mArcItemDrS)="") ""
 	s arcimDesc=$p($G(^ARCIM(mArcItemDrF,mArcItemDrS,1)),"^",2)
 	q $g(arcimDesc)
 	
 	   	
ERRGetArcimDesc
	q -1
}

// w ##class(DtPortal.Common.PublicService).GetPatInfo("")

// 获取病人信息使用这个d ##class(DtPortal.Common.PaadmService).GetPatInfo(190)

ClassMethod GetPatInfo(PAAdm As %String)
{
	q ##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
}

// 根据病区ID获取床位ID串

// 过滤条件： 1、过滤未激活 2、过滤有效时间  3、过滤婴儿床

// sortType:排序  1-按正常输出（globalID）  2-按床位名称描述排序输出

// w ##class(DtPortal.Common.PublicService).getBedIDStrByWardID("44",2)

ClassMethod getBedIDStrByWardID(wardId As %String, sortType)
{
	q:+wardId=0 ""
	s retStr=""
	s bedChild=0  //
	k ^||sortTypePortalBed($j)
	f  s bedChild=$o(^PAWARD(wardId,"BED",bedChild)) q:bedChild=""  d
	.s bedId=wardId_"||"_bedChild
	.s isValid=..isValidBed(bedId)
	.q:isValid'="1"
	.i sortType="1" d
	..i retStr="" s retStr=bedId
	..e  s retStr=retStr_"^"_bedId
	.e  i sortType="2" d
	..s bedCode=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",1)
	..s bedCodeStr=bedCode_" "  //转成字符串再输出，不然又数字会乱
	..s ^||sortTypePortalBed($j,bedCodeStr,bedId)=""
	
	if (sortType="2"){
		s bedCodeTemp=""
		f  s bedCodeTemp=$o(^||sortTypePortalBed($j,bedCodeTemp)) q:bedCodeTemp=""  d
		.s bedId=""
		.f  s bedId=$o(^||sortTypePortalBed($j,bedCodeTemp,bedId)) q:bedId=""  d
		..i retStr="" s retStr=bedId
		..e  s retStr=retStr_"^"_bedId
		
	}
	
	q retStr
}

// 判断床位是否有效  1-有效   其他-无效

// w ##class(DtPortal.Common.PublicService).isValidBed(bedId)

ClassMethod isValidBed(bedId As %String)
{
	s bedTypeCode=""
	q:bedId'["||" "传参有问题"
	s wardId=$p(bedId,"||",1)
	s bedChild=$p(bedId,"||",2)
	
	q:$g(^PAWARD(wardId,"BED",bedChild))="" "床位不存在"
	
	//1--过滤未激活
	s rcFlag=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",4)
	q:rcFlag'="Y" "未激活"  
	//2-过滤不在有效时间
	s fromDate=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",21)
	q:(fromDate="")||(fromDate>+$h) "开始时间无效"
	s toDate=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",22)
	q:(toDate'="")&&(toDate<+$h) "结束时间无效"
	
	//3-过滤婴儿床
	s bedTypeCode=..getBedTypeCode(bedId)   //3-过滤婴儿床
	q:bedTypeCode="MATERNALBABY" "婴儿床"
	
	////过滤his里面床位图未设置高度宽度的(不能过滤，护理组不配置也有床位)
	/*
	s x=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",15)
	s y=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",16)
	s h=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",17)
	s w=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",18)
	;w !,x_" "_y_" "_h_" "_w_" "
	;q:(+h=0)&&(+w=0) "未画床位图"  
	*/
	
	
	q 1
}

// 获取床位类型

// w ##class(DtPortal.Common.PublicService).getBedTypeCode(bedId)

ClassMethod getBedTypeCode(bedId As %String)
{
	s bedTypeCode=""
	q:bedId'["||" ""
	s bedData=^PAWARD($p(bedId,"||",1),"BED",$p(bedId,"||",2))
	s bedTypeDR=$p(bedData,"^",2)
	i bedTypeDR'="" d
	.s bedTypeDesc=$p(^PAC("BEDTP",bedTypeDR),"^",2)   
	.s bedTypeCode=$p(^PAC("BEDTP",bedTypeDR),"^",1) 
	q bedTypeCode
}

// 获取科室描述

// w ##class(DtPortal.Common.PublicService).getLocDesc(1)

ClassMethod getLocDesc(locId As %String)
{
	q:+locId=0 ""
	s locDesc=$p($g(^CTLOC(locId)),"^",2)
	i locDesc["-" s locDesc=$p(locDesc,"-",2)
	q locDesc
}

/// Creator：      bmz
/// CreatDate：    20190712
/// Description:： 根据医嘱ID取医嘱申请时间
/// Table：        OE_OrdItem
/// Input：        医嘱ID
/// Output：       医嘱申请时间
/// Return：        
/// Others：       
/// w ##class(DtPortal.Common.PublicService).GetOrdItemDate("1568||126")
ClassMethod GetOrdItemDate(OEOrdId As %String) As %String
{
   i OEOrdId'["||" q ""
   s OeordDate="",OeordTime=""
   s oeordId=$p(OEOrdId,"||",1)
   s oeoriSub=$p(OEOrdId,"||",2)
   ;s OeordDate=$p(^OEORD(OrdId),"^",2)
   ;s OeordTime=$p(^OEORD(OrdId),"^",3)
   set OeordDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7) ;医嘱日期
   set OeordTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17) ;医嘱时间
   
   q OeordDate_"^"_OeordTime
}

/// Creator：      bmz
/// CreatDate：    20190712
/// Description:： 根据医嘱ID取医嘱频次
/// Table：        OE_OrdItem
/// Input：        医嘱ID
/// Output：       医嘱频次
/// Return：        
/// Others：       
/// w ##class(DtPortal.Common.PublicService).GetOeoriFreq("1568||126")
ClassMethod GetOeoriFreq(OEOrdId As %String) As %String
{
   i OEOrdId'["||" q ""
   s ret=##class(web.DHCSTCOMMONORDER).OeoriFreq(OEOrdId)
   set OEORIPHFreqDesc=$p(ret,"^",3)
   q OEORIPHFreqDesc
}

/// Creator： zhaoli
/// CreatDate： 2019-08-16
/// Description: 返回日期数据的详细信息，返回 当日、三日、一周，可以按照设置返回对应的数据
/// Input： UserCode ：用户工号
///         
///               NH00.00.01
/// Return： 日期的详细信息，包含id、text、startDate、endDate
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PublicService","getDateDetail","0^3^7","当日^三日^一周")
Query getDateDetail(type As %String, typeStr As %String) As DtPortal.Query(ROWSPEC = "type:%String,typeStr:%String,startDate:%String,endDate:%String")
{
}

ClassMethod getDateDetailExecute(ByRef qHandle As %Binary, type As %String, typeStr As %String) As %Status
{

    
 //New (qHandle,type,typeStr)
 Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:type="" $$$OK
    set num=$l(type,"^")
	for i=1:1:num{
	  set tempValue=$p(type,"^",i)
	  set tempValueStr=$p(typeStr,"^",i)
	  set endDate=$zd(+$h,3)
	  set startDate=$zd(+$h-tempValue,3)
	  s Data=$lb(tempValue,tempValueStr,startDate,endDate)
	  s ^||CacheTemp(repid,ind)=Data
	  s ind=ind+1
	  
	}
	   q $$$OK
}

/// Creator： zhaoli
/// CreatDate： 2019-08-16
/// Description: 根据开始日期和结束，以及日期段的类型，返回各个日期段的数据
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PublicService","getItemDateDetail","month","2019-01-03","2019-02-03")
Query getItemDateDetail(dateType As %String, startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "date:%String,dateStr:%String,startDateItem:%String,endDateItem:%String")
{
}

ClassMethod getItemDateDetailExecute(ByRef qHandle As %Binary, dateType As %String, startDate As %String, endDate As %String) As %Status
{
 
 	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:dateType="" $$$OK
	w dateType,startDate,endDate
    ////计算开始日期和结束日期的间隔年、间隔月、间隔的天数
	set numStart=$zdh(startDate,3)
	set numEnd=$zdh(endDate,3)
	///年份差
	set yearLength=0
	//月份差
	set monthLength=0
	///天数
	set dayLength=numEnd-numStart+1
	//季度的差值
	set quaLength=numEnd-numStart+1
	set yearStart=$p(startDate,"-",1)
	set yearEnd=$p(endDate,"-",1)
	set monthStart=$p(startDate,"-",2)
	set monthEnd=$p(endDate,"-",2)
	
	////根据开始日期和结束日期以及日期查询方式，生成日期段
	///按照天
	if (dateType="day"){
		
		set num1=$zdh(startDate,3)
		set num2=$zdh(endDate,3)
		
		for i=num1:1:num2{
			set date=$zd(i,3)
			s dateStr=$p(date,"-",1)_"年"_$p(date,"-",2)_"月"_$p(date,"-",3)_"日"
			s startDateItem=date
			s endDateItem=date
		   	d setDateDetail
		}
	}
	//按照月
	if (dateType="month"){
		set monthLength=(yearEnd-yearStart)*12+(monthEnd-monthStart)+1
		set date=$p(startDate,"-",1)_"-"_$p(startDate,"-",2)
		for i=1:1:monthLength{

			set tempMonth=$p(date,"-",2)
			if (i>1){
				if (tempMonth="12"){
					set date=($p(date,"-",1)+1)_"-01"
				}else{
					set nowM=tempMonth+1
					if (nowM<10) set nowM="0"_nowM
					set date=$p(date,"-",1)_"-"_nowM
				}
			}
			            
			s dateStr=$p(date,"-",1)_"年"_$p(date,"-",2)_"月"
			s startDateItem=date_"-01"
			s endDateItem=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(date,1)
			d setDateDetail
		

		}
	
	}

	if (dateType="year"){
	    set yearLength=yearEnd-yearStart+1
		set num1=$P(startDate,"-",1)
		set num2=$P(endDate,"-",1)
		for i=num1:1:num2{
			set date=i
			s dateStr=i_"年"
			s startDateItem=date_"-01-01"
			s endDateItem=date_"-12-31"
			d setDateDetail
			
		}
	}
	if (dateType="quarter"){
		///开始日期所在的季度
		set ys1=monthStart#3
		set currentQ1=1
		if (ys1=0){
			set currentQ1=monthStart\3
		}else{
			set currentQ1=(monthStart\3)+1
		}
		//结束日期所在的季度
		set ys2=monthEnd#3
		set currentQ2=1
		if (ys2=0){
			set currentQ2=monthEnd\3
		}else{
			set currentQ2=(monthEnd\3)+1
		}
		set date=yearStart_"-"_currentQ1
		set quaLength=(yearEnd-yearStart)*4+(currentQ2-currentQ1)+1
		for i=1:1:quaLength{

			set tempQ=$p(date,"-",2)
			if (i>1){
				if (tempQ="4"){
					set date=($p(date,"-",1)+1)_"-1"
				}else{
					set date=$p(date,"-",1)_"-"_(tempQ+1)
				}
			}
           	s dateStr=$p(date,"-",1)_"年"_$p(date,"-",2)_"季度"
			set year=$p(date,"-",1)
			set cQ1=$p(date,"-",2)
			set startDateItem=$CASE(cQ1,1:year_"-01-01",2:year_"-04-01",3:year_"-07-01",4:year_"-10-01")
			///取季度的最后一天
			set endDateItem=$CASE(cQ1,1:year_"-03-31",2:year_"-06-30",3:year_"-09-30",4:year_"-12-31")
            d setDateDetail
		}
	
	}
   
	   q $$$OK
setDateDetail
  s Data=$lb(date,dateStr,startDateItem,endDateItem)
	s ^||CacheTemp(repid,ind)=Data
	s ind=ind+1
}

/// Creator：      bmz
/// CreatDate：    20200309
/// Description:： 判断科室是否急诊--用于门诊办门急诊的区分
/// Table：        
/// Input：        locID
/// Output：       
/// Return：        
/// Others：       
/// w ##class(DtPortal.Common.PublicService).ifEmDept("1")
ClassMethod ifEmDept(locID As %String) As %String
{
	q:locID="" 0
	/*
    set deptType=$p($g(^CTLOC(locID)),"^",13) //科室类型
    q:deptType'="E" 0
	set rowIdE=$o(^PAC("ADMLOC",0,"AdmType","E",locID,0))
	*/
	set locType=##class(DtPortal.Common.PublicService).getDeptType(locID)
	q:(locType["E")&&(locType'["O") 1
	
	q 0
}

/// Creator：      bmz
/// CreatDate：    20200928
/// Description:： 获取科室类型
/// Table：        
/// Input：        locID
/// Output：       I、O、E、OIE组合、""
/// Return：        
/// Others：       
/// w ##class(DtPortal.Common.PublicService).getDeptType("1")
ClassMethod getDeptType(locID As %String) As %String
{
	s return=""
	q:locID="" return
    set deptType=$p($g(^CTLOC(locID)),"^",13) //科室类型
    set deptDesc=$p($g(^CTLOC(locID)),"^",2)
	//非执行科室过滤掉
    q:deptType'="E" ""
    //判断扩展的配置科室类型，获取的优先级是  门诊>住院>急诊
    set rowId=$o(^PAC("ADMLOC",0,"AdmType","O",locID,0))
    if rowId'="" set return=return_"O"
	set rowId=$o(^PAC("ADMLOC",0,"AdmType","I",locID,0))
	if rowId'="" set return=return_"I"
	set rowId=$o(^PAC("ADMLOC",0,"AdmType","E",locID,0))
	if rowId'="" set return=return_"E"
	set rowId=$o(^PAC("ADMLOC",0,"AdmType","H",locID,0))
	if rowId'="" set return=return_"H"
	q:return'="" return
	//-------
	
	//如果未维护，则根据科室组类型判断
	s CTLOCDefaultDepDR=$P(^CTLOC(locID),"^",19)  //科室组类型
	q:CTLOCDefaultDepDR="" return
	s depInfoDesc=$p($g(^RBC("DEP",CTLOCDefaultDepDR)),"^",2)
	if (depInfoDesc["门急诊") {
		set return="O"
		if (deptDesc["急"){
			set return="E"
		}
	}
	
	q return
}

// 根据用户获取急诊的登录科室信息

// w ##class(DtPortal.Common.PublicService).GetEmLoginInfoByUserCode("ys01")

ClassMethod GetEmLoginInfoByUserCode(aUserCode As %String) As %String
{
	s return=""
	s UserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	q:UserCode="" ""
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	q:UserId="" ""
	//取出默认登陆科室
	s depId=$p($g(^SSU("SSUSR",UserId)),"^",4) //增加默认登陆位置
	//获取默认登录科室是否是急诊
	s ifEmDept=##class(DtPortal.Common.PublicService).ifEmDept(depId)
	if ((depId'="")&&(ifEmDept=1)){
		s groupId=$p($g(^SSU("SSUSR",UserId)),"^",5) //默认登陆位置的安全组
		s hosId=$p($g(^SSU("SSUSR",UserId)),"^",98) //默认登陆位置的安全组
		if ((groupId'="")&&(hosId'="")){
			s return=depId_"^"_groupId_"^"_hosId
		}
	}
	
	s sub=0
	f  s sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub)) q:sub=""  d
	.s depId=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
	.q:depId=""
	.s ifEmDept=##class(DtPortal.Common.PublicService).ifEmDept(depId)
	.q:ifEmDept=0
	.s groupId=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2)
	.q:groupId=""
	.s hosId=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",3)
	.q:hosId=""
	.s currDate=+$h
	.s startDate=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",4)
	.q:currDate<currDate
	.s endDate=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",5)
	.q:endDate>currDate
	.i return="" s return=depId_"^"_groupId_"^"_hosId
	.e  s return=return_"#"_depId_"^"_groupId_"^"_hosId
	q return
}

// 根据用户获取急诊的登录科室信息

// w ##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo("ys01")

ClassMethod GetSingleEmLoginInfo(aUserCode As %String) As %String
{
	s EmLoginInfo=##class(DtPortal.Common.PublicService).GetEmLoginInfoByUserCode(aUserCode)
	q $p(EmLoginInfo,"#")
}

/// 获取用户所在主诊组的usercode串
/// w ##class(DtPortal.Common.PublicService).GetUserStrByUsercode(245)
ClassMethod GetUserStrByUsercode(aUserCode As %String) As %String
{
	set ret=""
	b ;01
	if (aUserCode=""){
		q ret
	}
	s UserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	q:UserId="" ""
	Set DocID=$p($g(^SSU("SSUSR",+UserId)),"^",14)
	Set MUDocList=##class(DtPortal.Common.PublicService).GetMUDocList(DocID)
	Set length=$l(MUDocList,"^")
	for i=1:1:length{
		s pgDocId=$p(MUDocList,"^",i)
		if +pgDocId=0 continue
		s docCode=$p($g(^CTPCP(pgDocId,1)),"^",1)
		if docCode="" continue
		if (ret="") {
			set ret=docCode
		}else{
			set ret=ret_";"_docCode
		}
	}
	q ret
}

}
