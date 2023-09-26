Import SQLUser

/// 名称:药学 3频次
/// 描述:频次维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCFreq Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 频次
/// Table：User.PHCFreq
/// Input：rowid, code, factor, desc1, desc2
/// Output：PHCFRRowId,PHCFRCode,PHCFRFactor,PHCFRDesc1,PHCFRDesc2(中文描述),PHCFRDays
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCFreq","GetList","","","","","","")
Query GetList(rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Query(ROWSPEC = "PHCFRRowId:%String,PHCFRCode:%String,PHCFRFactor:%String,PHCFRDesc1:%String,PHCFRDesc2:%String,PHCFRDays:%String,PHCFRWeekFlag:%String,PHCFRActiveFlag,PHCFRClinicType,PHCFRNoDelayExecute,PHCFRNoDelayExecute2,PHCFRWeekFactor,PHCFRIntervalTime,PHCFRIrregularDistributTimeFlag,PHCFRIntervalUom,PHCFRWeek,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCFRRowId=rowid
		s PHCFRCode= $p($g(^PHCFR(PHCFRRowId)),"^",1)
		s PHCFRFactor = $p($g(^PHCFR(PHCFRRowId)),"^",2)
		s PHCFRDesc1 = $p($g(^PHCFR(PHCFRRowId)),"^",3)
		s PHCFRDesc2 = $p($g(^PHCFR(PHCFRRowId)),"^",4)
		s PHCFRDays = $p($g(^PHCFR(PHCFRRowId)),"^",5)       //间隔天数
		
		s PHCFRActiveFlag = $p($g(^PHCFR(PHCFRRowId)),"^",6)         ;是否激活 20170612
		s:PHCFRActiveFlag="" PHCFRActiveFlag="Y"                     ;激活标志为空时默认为激活
		s PHCFRClinicType = $p($g(^PHCFR(PHCFRRowId)),"^",7)         ;就诊类型
		
		s PHCFRWeekFlag = $p($g(^PHCFR(PHCFRRowId)),"^",9)             ///周频次
		s:(PHCFRWeekFlag'="")&&(PHCFRWeekFlag'="Y") PHCFRWeekFlag="N"
		s PHCFRNoDelayExecute = $p($g(^PHCFR(PHCFRRowId)),"^",8)       //门诊默认按分发次数全执行
		s PHCFRNoDelayExecute2 = $p($g(^PHCFR(PHCFRRowId)),"^",10)     //住院默认按分发次数全执行
		s PHCFRWeekFactor = $p($g(^PHCFR(PHCFRRowId)),"^",11)          //周频次系数 2019-05-08
		
		s PHCFRIntervalTime = $p($g(^PHCFR(PHCFRRowId)),"^",12)       //间隔时间（小时）
		s PHCFRIrregularDistributTimeFlag = $p($g(^PHCFR(PHCFRRowId)),"^",13)          // 不规则分发时间标志
		s PHCFRIntervalUom = $p($g(^PHCFR(PHCFRRowId)),"^",14)       //间隔单位
		S:(PHCFRDays'="")&&(PHCFRIntervalUom="") PHCFRIntervalUom="D"
		s PHCFRIntervalUom=$case(PHCFRIntervalUom,"D":"天","H":"小时",:PHCFRIntervalUom)
		
		//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
		s PHCFRClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(PHCFRClinicType)
		s PHCFRWeek=$p($g(^PHCFR(PHCFRRowId)),"^",15) //星期
		s PHCFRWeek=..GetWeek(PHCFRWeek)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Freq",PHCFRRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:factor'="" factor=$ZCONVERT(factor,"U") //$$ALPHAUP^SSUTIL4(factor)
		s:desc1'="" desc1=$ZCONVERT(desc1,"U")
		s:desc2'="" desc2=$ZCONVERT(desc2,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCFreq).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCFRRowId=0
		for
		{
			s PHCFRRowId=$o(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""
			s strRowId="{ID:"_PHCFRRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCFRCode=$p($g(^PHCFR(PHCFRRowId)),"^",1)
				s PHCFRFactor = $p($g(^PHCFR(PHCFRRowId)),"^",2)
				s PHCFRDesc1 = $p($g(^PHCFR(PHCFRRowId)),"^",3)  //英文描述
				s PHCFRDesc2 = $p($g(^PHCFR(PHCFRRowId)),"^",4)
				s PHCFRDays = $p($g(^PHCFR(PHCFRRowId)),"^",5)
				
				s PHCFRActiveFlag = $p($g(^PHCFR(PHCFRRowId)),"^",6)         ;是否激活   20170612
				s:PHCFRActiveFlag="" PHCFRActiveFlag="Y"                     ;激活标志为空时默认为激活
				s PHCFRClinicType = $p($g(^PHCFR(PHCFRRowId)),"^",7)         ;就诊类型
				
				s PHCFRWeekFlag = $p($g(^PHCFR(PHCFRRowId)),"^",9)         //周频次
				s:(PHCFRWeekFlag'="")&&(PHCFRWeekFlag'="Y") PHCFRWeekFlag="N"
				s PHCFRNoDelayExecute = $p($g(^PHCFR(PHCFRRowId)),"^",8)
				s PHCFRNoDelayExecute2 = $p($g(^PHCFR(PHCFRRowId)),"^",10)
				s PHCFRWeekFactor = $p($g(^PHCFR(PHCFRRowId)),"^",11)     // 周频次系数
				s PHCFRIntervalTime = $p($g(^PHCFR(PHCFRRowId)),"^",12)       //间隔时间（小时）
				s PHCFRIrregularDistributTimeFlag = $p($g(^PHCFR(PHCFRRowId)),"^",13)          // 不规则分发时间标志
				s PHCFRIntervalUom = $p($g(^PHCFR(PHCFRRowId)),"^",14)       //间隔单位
				S:(PHCFRDays'="")&&(PHCFRIntervalUom="") PHCFRIntervalUom="D"
				s PHCFRIntervalUom=$case(PHCFRIntervalUom,"D":"天","H":"小时",:PHCFRIntervalUom)
				//就诊类型 (门诊,急诊,住院,体检) 20170612
				s PHCFRClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(PHCFRClinicType)
				s PHCFRWeek=$p($g(^PHCFR(PHCFRRowId)),"^",15) //星期
				s PHCFRWeek=..GetWeek(PHCFRWeek)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Freq",PHCFRRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc1'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Freq",PHCFRRowId,PHCFRDesc1,desc1)
				}
				else
				{
					s AliasFlag=1
				}
				s PINYIN2=""
				s:desc2'="" PINYIN2= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCFRDesc2)
				i ($ZCONVERT(PHCFRCode,"U")[code)&($ZCONVERT(PHCFRFactor,"U")[factor)&(AliasFlag=1)&(($ZCONVERT(PHCFRDesc2,"U")[desc2)||(PINYIN2[desc2))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCFRRowId,PHCFRCode,PHCFRFactor,PHCFRDesc1,PHCFRDesc2,PHCFRDays,PHCFRWeekFlag,PHCFRActiveFlag,PHCFRClinicType,PHCFRNoDelayExecute,PHCFRNoDelayExecute2,PHCFRWeekFactor,PHCFRIntervalTime,PHCFRIrregularDistributTimeFlag,PHCFRIntervalUom,PHCFRWeek,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 频次
/// Table：User.PHCFreq
/// Input：rowid, code,desc
/// Output：PHCFRRowId,PHCFRCode,PHCFRDesc1
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCFreq","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCFRRowId:%String,PHCFRCode:%String,PHCFRDesc1:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCFRRowId=rowid
		s PHCFRCode= $p($g(^PHCFR(PHCFRRowId)),"^",1)
		s PHCFRDesc1 = $p($g(^PHCFR(PHCFRRowId)),"^",3)  //英文描述
		d OutputRowCmb
	}
	else
	{

		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCFreq).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCFRRowId=0
		for
		{
			s PHCFRRowId=$o(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""
			s strRowId="{ID:"_PHCFRRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCFRCode=$p($g(^PHCFR(PHCFRRowId)),"^",1)
				s PHCFRDesc1 = $p($g(^PHCFR(PHCFRRowId)),"^",3)
				s PHCFRActiveFlag = $p($g(^PHCFR(PHCFRRowId)),"^",6)
				CONTINUE:PHCFRActiveFlag="N"
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Freq",PHCFRRowId,PHCFRDesc1,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCFRCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCFRRowId,PHCFRCode,PHCFRDesc1)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCFreq
/// w ##class(web.DHCBL.CT.PHCFreq).OpenData(1)
ClassMethod OpenData(PHCFRRowId As %String) As %String
{
	n (PHCFRRowId)
    s str = ""
	s pobj = ##class(User.PHCFreq).%OpenId(PHCFRRowId)
	s eobj = ##class(web.Entity.CT.PHCFreq).%New()
	s eobj.PHCFRRowId = PHCFRRowId
	s eobj.PHCFRCode  = pobj.PHCFRCode
	s eobj.PHCFRFactor = pobj.PHCFRFactor
	s eobj.PHCFRDesc1 = pobj.PHCFRDesc1
	s eobj.PHCFRDesc2 =pobj.PHCFRDesc2
	s eobj.PHCFRDays =pobj.PHCFRDays
	
	s eobj.PHCFRActiveFlag = pobj.PHCFRActiveFlag
	s eobj.PHCFRClinicType = pobj.PHCFRClinicType
	s:eobj.PHCFRActiveFlag="Y" eobj.PHCFRActiveFlag="true"
	s:eobj.PHCFRActiveFlag="" eobj.PHCFRActiveFlag="true"           //激活标志为空时默认为激活
	if eobj.PHCFRClinicType="" s eobj.PHCFRClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊。急诊。住院。体检都可以开
	if eobj.PHCFRClinicType["O" s eobj.PHCFRClinicTypeO="O"  // 就诊类型 门诊
	if eobj.PHCFRClinicType["E" s eobj.PHCFRClinicTypeE="E"  // 就诊类型 急诊
	if eobj.PHCFRClinicType["I" s eobj.PHCFRClinicTypeI="I"  // 就诊类型 住院
	if eobj.PHCFRClinicType["H" s eobj.PHCFRClinicTypeH="H"  // 就诊类型 体检
	if eobj.PHCFRClinicType["N" s eobj.PHCFRClinicTypeN="N"  // 就诊类型 新生儿
	s eobj.PHCFRNoDelayExecute =pobj.PHCFRNoDelayExecute
	s eobj.PHCFRNoDelayExecute2 =pobj.PHCFRNoDelayExecute2
	s:eobj.PHCFRNoDelayExecute="Y" eobj.PHCFRNoDelayExecute="true"
	s:eobj.PHCFRNoDelayExecute2="Y" eobj.PHCFRNoDelayExecute2="true"
	
	s eobj.PHCFRWeekFlag = $p($g(^PHCFR(PHCFRRowId)),"^",9)
	s eobj.PHCFRWeekFactor = $p($g(^PHCFR(PHCFRRowId)),"^",11)
	s eobj.PHCFRIntervalTime = $p($g(^PHCFR(PHCFRRowId)),"^",12)
	s eobj.PHCFRIrregularDistributTimeFlag = $p($g(^PHCFR(PHCFRRowId)),"^",13)
	s eobj.PHCFRIntervalUom = $p($g(^PHCFR(PHCFRRowId)),"^",14)  //间隔单位
	
	s eobj.PHCFRWeek=pobj.PHCFRWeek
	if eobj.PHCFRWeek["1" s eobj.PHCFRWeek1="true"  // 星期一
	if eobj.PHCFRWeek["2" s eobj.PHCFRWeek2="true"  // 星期二
	if eobj.PHCFRWeek["3" s eobj.PHCFRWeek3="true"  // 星期三
	if eobj.PHCFRWeek["4" s eobj.PHCFRWeek4="true"  // 星期四
	if eobj.PHCFRWeek["5" s eobj.PHCFRWeek5="true"  // 星期五
	if eobj.PHCFRWeek["6" s eobj.PHCFRWeek6="true"  // 星期六
	if eobj.PHCFRWeek["7" s eobj.PHCFRWeek7="true"  // 星期日
	
	S:(eobj.PHCFRDays'="")&&(eobj.PHCFRIntervalUom="") eobj.PHCFRIntervalUom="D"
	
	s:eobj.PHCFRWeekFlag="Y" eobj.PHCFRWeekFlag="true"
	s:eobj.PHCFRIrregularDistributTimeFlag="Y" eobj.PHCFRIrregularDistributTimeFlag="true"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 频次
/// Table：User.PHCFreq
/// Return:成功返回true，失败返回false
/// w ##class(web.DHCBL.CT.PHCFreq).SaveTest()
ClassMethod SaveTest() As %String
{
	s eobj=##class(web.Entity.CT.PHCFreq).%New()
	s eobj.PHCFRActiveFlag="Y"
	s eobj.PHCFRCode="CODE"
	s eobj.PHCFRDesc1="desc1"
	s eobj.PHCFRDesc2="desc2"
	w ##class(web.DHCBL.CT.PHCFreq).SaveEntity(eobj)
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 频次
/// Table：User.PHCFreq
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCFreq) As %String
{
	n (%session,eobj)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PHCFRWeekFlag'="Y" eobj.PHCFRWeekFlag="N"
		
		s:eobj.PHCFRActiveFlag="" eobj.PHCFRActiveFlag="N"
		s:eobj.PHCFRNoDelayExecute="" eobj.PHCFRNoDelayExecute="N"
		s:eobj.PHCFRNoDelayExecute2="" eobj.PHCFRNoDelayExecute2="N"	
		
		S:(eobj.PHCFRDays'="")&&(eobj.PHCFRIntervalUom="") eobj.PHCFRIntervalUom="D"  //间隔时间不为空，间隔单位为空时，单位默认为天
		
		
		//针对导入修改  20170812 
		if eobj.PHCFRWeek["星期一" s eobj.PHCFRWeek1="1"
		if eobj.PHCFRWeek["星期二" s eobj.PHCFRWeek2="2"
		if eobj.PHCFRWeek["星期三" s eobj.PHCFRWeek3="3"
		if eobj.PHCFRWeek["星期四" s eobj.PHCFRWeek4="4"
		if eobj.PHCFRWeek["星期五" s eobj.PHCFRWeek5="5"
		if eobj.PHCFRWeek["星期六" s eobj.PHCFRWeek6="6"
		if eobj.PHCFRWeek["星期日" s eobj.PHCFRWeek7="7"
		
		///将星期拼起来， 用,分隔  
		s eobj.PHCFRWeek=eobj.PHCFRWeek1_","_eobj.PHCFRWeek2_","_eobj.PHCFRWeek3_","_eobj.PHCFRWeek4_","_eobj.PHCFRWeek5_","_eobj.PHCFRWeek6_","_eobj.PHCFRWeek7
		///如果星期都勾选，将星期置为空
		//I (eobj.PHCFRWeek1'="")&&(eobj.PHCFRWeek2'="")&&(eobj.PHCFRWeek3'="")&&(eobj.PHCFRWeek4'="")&&(eobj.PHCFRWeek5'="")&&(eobj.PHCFRWeek6'="")&&(eobj.PHCFRWeek7'="") s eobj.PHCFRWeek=""
		///如果星期都没有勾选，将星期置为空
		I (eobj.PHCFRWeek1="")&&(eobj.PHCFRWeek2="")&&(eobj.PHCFRWeek3="")&&(eobj.PHCFRWeek4="")&&(eobj.PHCFRWeek5="")&&(eobj.PHCFRWeek6="")&&(eobj.PHCFRWeek7="") s eobj.PHCFRWeek=""
		
		if eobj.PHCFRClinicType["门诊" s eobj.PHCFRClinicTypeO="O"
		if eobj.PHCFRClinicType["急诊" s eobj.PHCFRClinicTypeE="E"
		if eobj.PHCFRClinicType["住院" s eobj.PHCFRClinicTypeI="I"
		if eobj.PHCFRClinicType["体检" s eobj.PHCFRClinicTypeH="H"
		if eobj.PHCFRClinicType["新生儿" s eobj.PHCFRClinicTypeN="N"
		
		///将就诊类型拼起来， 用,分隔  20170615
		s eobj.PHCFRClinicType=eobj.PHCFRClinicTypeO_","_eobj.PHCFRClinicTypeE_","_eobj.PHCFRClinicTypeI_","_eobj.PHCFRClinicTypeH_","_eobj.PHCFRClinicTypeN
		///如果就诊类型都没有勾选，将就诊类型置为空
		I (eobj.PHCFRClinicTypeO'="")&&(eobj.PHCFRClinicTypeE'="")&&(eobj.PHCFRClinicTypeI'="")&&(eobj.PHCFRClinicTypeH'="")&&(eobj.PHCFRClinicTypeN'="") s eobj.PHCFRClinicType=""
		///如果就诊类型勾选，将就诊类型置为空
		I (eobj.PHCFRClinicTypeO="")&&(eobj.PHCFRClinicTypeE="")&&(eobj.PHCFRClinicTypeI="")&&(eobj.PHCFRClinicTypeH="")&&(eobj.PHCFRClinicTypeN="") s eobj.PHCFRClinicType=""
		
		
		s flag=..FormValidate(eobj.PHCFRRowId,eobj.PHCFRCode,eobj.PHCFRDesc1)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		//逻辑限制 2021-12-27
		//1.ST/ONCE不要维护分发时间，除代码名称外，其他都不能维护，分发次数固定为1不能编辑
		if (($ZCVT(eobj.PHCFRCode,"U")="ONCE")||($ZCVT(eobj.PHCFRCode,"U")="ST"))
		{
			if (eobj.PHCFRFactor'=1) q "{success:'false',errorinfo:'【分发次数】要求为1'}"
			if (eobj.PHCFRDays'="") q "{success:'false',errorinfo:'【间隔长度】要求为空'}"
			if (eobj.PHCFRIntervalUom'="") q "{success:'false',errorinfo:'【间隔单位】要求为空'}"
			if (eobj.PHCFRWeekFlag="Y") q "{success:'false',errorinfo:'不允许勾选【周频次】'}"
			if (eobj.PHCFRWeekFactor'="") q "{success:'false',errorinfo:'【周频次系数】要求为空'}"
			if (eobj.PHCFRIrregularDistributTimeFlag="Y") q "{success:'false',errorinfo:'不允许勾选【不规则分发时间标志】'}"
		}
		//2.prn分发次数、分发时间、间隔天数都为空且不可编辑
		if ($ZCVT(eobj.PHCFRCode,"U")="PRN")
		{
			if (eobj.PHCFRFactor'="") q "{success:'false',errorinfo:'【分发次数】要求为空'}"
			if (eobj.PHCFRDays'="") q "{success:'false',errorinfo:'【间隔长度】要求为空'}"
			if (eobj.PHCFRIntervalUom'="") q "{success:'false',errorinfo:'【间隔单位】要求为空'}"
			if (eobj.PHCFRWeekFlag="Y") q "{success:'false',errorinfo:'不允许勾选【周频次】'}"
			if (eobj.PHCFRWeekFactor'="") q "{success:'false',errorinfo:'【周频次系数】要求为空'}"
			if (eobj.PHCFRIrregularDistributTimeFlag="Y") q "{success:'false',errorinfo:'不允许勾选【不规则分发时间标志】'}"
		}
		//3.间隔单位不为空，间隔长度不能为空
		if (eobj.PHCFRDays="")&&(eobj.PHCFRIntervalUom'="")
		{
			q "{success:'false',errorinfo:'间隔单位不为空时，【间隔长度】必填！'}"
		}
		if (eobj.PHCFRDays'="")&&(eobj.PHCFRIntervalUom'="")
		{
			if (eobj.PHCFRIrregularDistributTimeFlag="Y") q "{success:'false',errorinfo:'选了间隔长度/间隔时间，不允许勾选【不规则分发时间标志】！'}"
		}
		//4.间隔单位维护为小时的，分发次数 24/间隔小时 向上取整
		if (eobj.PHCFRDays'="")&&(eobj.PHCFRIntervalUom="H")
		{
			if eobj.PHCFRDays>0
			{
				s DAYS=eobj.PHCFRDays
				if ((24#DAYS)=0)
				{
					s eobj.PHCFRFactor=24\DAYS
				}
				else
				{
					s eobj.PHCFRFactor=(24\DAYS)+1
				}
			}
		}
		
		//6.维护周频次标记的，控制间隔长度7、单位为天且灰掉
		if (eobj.PHCFRWeekFlag="Y")
		{
			if (+eobj.PHCFRDays'=7) q "{success:'false',errorinfo:'对于周频次，【间隔长度】要求为7'}"
			if (eobj.PHCFRIntervalUom'="D") q "{success:'false',errorinfo:'对于周频次，【间隔单位】要求为天'}"
		}
		
		
		
		if (eobj.PHCFRRowId="")
		{	
	        s obj=##class(User.PHCFreq).%New()
		}
		else
		{
			s obj=##class(User.PHCFreq).%OpenId(eobj.PHCFRRowId)
			
			s bobj = ##class(web.Entity.CT.PHCFreq).%New()
			s bobj.PHCFRRowId = eobj.PHCFRRowId
			s bobj.PHCFRCode = obj.PHCFRCode
			s bobj.PHCFRFactor = obj.PHCFRFactor
			s bobj.PHCFRDesc1 = obj.PHCFRDesc1		        
			s bobj.PHCFRDesc2 = obj.PHCFRDesc2
			s bobj.PHCFRDays = obj.PHCFRDays
			
			s bobj.PHCFRActiveFlag = obj.PHCFRActiveFlag
			s bobj.PHCFRNoDelayExecute = obj.PHCFRNoDelayExecute
			s bobj.PHCFRNoDelayExecute2 = obj.PHCFRNoDelayExecute2
			s bobj.PHCFRClinicType = obj.PHCFRClinicType
			s bobj.PHCFRWeekFlag =obj.PHCFRWeekFlag
			s bobj.PHCFRWeekFactor =obj.PHCFRWeekFactor
			s bobj.PHCFRIntervalTime =obj.PHCFRIntervalTime
			s bobj.PHCFRIrregularDistributTimeFlag =obj.PHCFRIrregularDistributTimeFlag
			s bobj.PHCFRIntervalUom=obj.PHCFRIntervalUom
			s bobj.PHCFRWeek=obj.PHCFRWeek
			
		}
		s obj.PHCFRCode = eobj.PHCFRCode
		s obj.PHCFRFactor = eobj.PHCFRFactor //系数
		s obj.PHCFRDesc1 = eobj.PHCFRDesc1		        
		s obj.PHCFRDesc2 = eobj.PHCFRDesc2
		s obj.PHCFRDays = eobj.PHCFRDays
		s obj.PHCFRActiveFlag = eobj.PHCFRActiveFlag
		s obj.PHCFRClinicType = eobj.PHCFRClinicType
		s obj.PHCFRNoDelayExecute = eobj.PHCFRNoDelayExecute
		s obj.PHCFRNoDelayExecute2 = eobj.PHCFRNoDelayExecute2
		s obj.PHCFRWeekFlag =eobj.PHCFRWeekFlag
		s obj.PHCFRWeekFactor =eobj.PHCFRWeekFactor
		s obj.PHCFRIntervalTime =eobj.PHCFRIntervalTime
		s obj.PHCFRIrregularDistributTimeFlag =eobj.PHCFRIrregularDistributTimeFlag
		s obj.PHCFRIntervalUom=eobj.PHCFRIntervalUom
		s obj.PHCFRWeek=eobj.PHCFRWeek
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCFRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Freq","User.PHCFreq","频次",id,eobj.PHCFRDesc1,"A",eobj)
			d:eobj.PHCFRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Freq","User.PHCFreq","频次",id,eobj.PHCFRDesc1,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频次","web.DHCBL.CT.PHCFreq","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.PHCFreq
/// Input:id, code, desc1
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCFreq).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc1 As %String) As %String
{
	N (code,desc1,id)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s id1=0
		for
		{
			s id1=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(code),id1)) q:id1=""	
			s PHCFRCode=$p($g(^PHCFR(id1)),"^",1)
			if (PHCFRCode=code)&&((id="")||((id'="")&&(id'=id1)))
			{
				s flag=1
			}	
		}
	}
	if $$ALPHAUP^SSUTIL4(desc1)'=""
	{
		s id1=0
		for
		{
			s id1=$o(^PHCFR(0,"Desc",$$ALPHAUP^SSUTIL4(desc1),id1)) q:id1=""	
			s PHCFRDesc1=$p($g(^PHCFR(id1)),"^",3)
			if (PHCFRDesc1=desc1)&&((id="")||((id'="")&&(id'=id1)))
			{
				s flag=1
			}	
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	N (id)
	s return="",myInfo=""
	i ($d(^PHCD("Freq",id))'=0)	
	{
		s myInfo=myInfo_"<药学项-药物形态设定>"
	}
	s ARCIMSubscript=0,flag=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")||(flag=1)
		s ARCIMVersion=0
		for
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")||(flag=1)
			s ARCIMRMFrequencyDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",17)
			i ARCIMRMFrequencyDR=id
			{
				s flag=1
				s myInfo=myInfo_"<医嘱项>"
			}
		}
	}
	
	s PHCFRCode= $p($g(^PHCFR(id)),"^",1)
	i ($o(^DHCPHFRCON(0,"HisCode",PHCFRCode,"")))
	{
		s myInfo=myInfo_"<频率对照表>"
	}
	
	i ($o(^PHCINLF(0,"Freq",id,0))'="")	
	{
		s myInfo=myInfo_"<用法与频次关联表>"
	}
	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 频次
/// Table：User.PHCFreq
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// Other:d ##class(web.DHCBL.CT.PHCFreq).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
 	s re=##class(web.DHCBL.CT.PHCFreq).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
	 	s pobj = ##class(User.PHCFreq).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCFreq).%New()
		s eobj.PHCFRRowId = id
		s eobj.PHCFRCode  = pobj.PHCFRCode
		s eobj.PHCFRFactor = pobj.PHCFRFactor
		s eobj.PHCFRDesc1 = pobj.PHCFRDesc1
		s eobj.PHCFRDesc2 =pobj.PHCFRDesc2
		s eobj.PHCFRDays =pobj.PHCFRDays
		s eobj.PHCFRActiveFlag = pobj.PHCFRActiveFlag
		
		s eobj.PHCFRNoDelayExecute = pobj.PHCFRNoDelayExecute
		s eobj.PHCFRNoDelayExecute2 = pobj.PHCFRNoDelayExecute2
		s eobj.PHCFRClinicType = pobj.PHCFRClinicType
		s eobj.PHCFRWeekFlag =pobj.PHCFRWeekFlag
		s eobj.PHCFRWeekFactor =pobj.PHCFRWeekFactor
		s eobj.PHCFRIntervalTime =pobj.PHCFRIntervalTime
		s eobj.PHCFRIrregularDistributTimeFlag =pobj.PHCFRIrregularDistributTimeFlag
		s eobj.PHCFRIntervalUom=pobj.PHCFRIntervalUom
		s eobj.PHCFRWeek=pobj.PHCFRWeek
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.PHCFreq).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Freq","User.PHCFreq","频次",id,eobj.PHCFRDesc1,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频次","web.DHCBL.CT.PHCFreq","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
 	}
 	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2019-10-23
/// Description:获取诊断、药品用法，频次的就诊类型对应的中文
/// Other:w ##class(web.DHCBL.CT.PHCFreq).GetClinicType("")
ClassMethod GetClinicType(ClinicType)
{
  	n (ClinicType)
  	s value=""
	if ClinicType'=""
	{
		s ClinicTypeDesc=""
		if ClinicType["O"
		{
			s ClinicTypeDesc="门诊"
		}
		else
		{
			s ClinicTypeDesc=""
		}
		if ClinicType["E"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="急诊"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"急诊"
		
			}
		}
		if ClinicType["I"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="住院"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"住院"
		
			}
		}
		if ClinicType["H"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="体检"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"体检"
		
			}
		}
		if ClinicType["N"
		{
			if ClinicTypeDesc=""
			{
				s ClinicTypeDesc="新生儿"
			}
			else
			{
				s ClinicTypeDesc=ClinicTypeDesc_","_"新生儿"
		
			}
		}
		s value=ClinicTypeDesc
		
	}
	else
	{
		s value="门诊,急诊,住院,体检,新生儿"
	}
	q value
}

/// Creator:钟荣枫
/// CreatDate:2023-2-21
/// Description:获取星期对应的中文
/// Other:w ##class(web.DHCBL.CT.PHCFreq).GetWeek("1,,6")
ClassMethod GetWeek(Week)
{
  	n (Week)
  	s value=""
  	
	if Week'=""
	{
		s WeekDesc=""
		s le=$l(Week,",")
		for m=1:1:le
		{
			s num=$p(Week,",",m)
			continue:num=""
			s num=$case(num,"1":"一","2":"二","3":"三","4":"四","5":"五","6":"六","7":"日",:"")
			s name="星期"_num
			if WeekDesc=""
			{
				s WeekDesc=name
			}
			else
			{
				s WeekDesc=WeekDesc_","_name
		
			}
		}
		s value=WeekDesc
		
	}
	else
	{
		s value=""	//"星期一,星期二,星期三,星期四,星期五,星期六,星期日"
	}
	q value
}

}
