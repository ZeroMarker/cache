/// 名称:  节假日维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-02-05
Class web.DHCBL.CT.BDPHoliday Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：数据重复验证方法,js调用
/// Table：User.BDPHoliday
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, hospid As %String = "") As %String
{
	s ^templkf(1)=id_"^"_code_"^"_hospid
	if (hospid="")	//8.3版本
	{
		s flag="",flagc="",flagd=""
		s:code'="" flagc=$d(^CT("BDPHD",0,"Date",code))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		
		else //如果不为空，修改时的重复判断
		{
			s idc=""
			s:code'="" idc=$o(^CT("BDPHD",0,"Date",code,0))
			if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		q flag
	}
	else	//8.4私有化
	{
		s flag=0
		s idc=0
		for
		{
			s idc=$o(^CT("BDPHD",0,"Date",code,idc)) q:idc=""
			s BDPHDHospitalDR=$p($g(^CT("BDPHD",idc)),"^",8)	//医院DR
			if (idc'=id)&&(BDPHDHospitalDR=hospid)
			{
				s flag=1
				q
			}
		}
		q flag
	}
}

/// Creator：陈莹
/// CreatDate:2018-02-05
/// Description：保存修改节假日的内容
/// Table：User.BDPHoliday
/// Input：web.Entity.CT.BDPHoliday 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.BDPHoliday).SaveData(id^YYYY-MM-DD^Type)
ClassMethod SaveData(DataStr) As %String
{
	s result = ""
	if ($tr(DataStr,"^","")'="")
	{
		s eobj=##class(web.Entity.CT.BDPHoliday).%New()	
		s eobj.BDPHDRowId =$p(DataStr,"^",1)
		s eobj.BDPHDDate = $p(DataStr,"^",2)
		s eobj.BDPHDType = $p(DataStr,"^",3)
		s eobj.BDPHDDesc = $p(DataStr,"^",4)   
		s eobj.LinkHospId = $p(DataStr,"^",5) 
		s result=##class(web.DHCBL.CT.BDPHoliday).SaveEntity(eobj)	
			
	}
	else
	{
		s result = "{success:'false',errorinfo:'数据为空！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate:2018-02-05
/// Description：保存修改节假日的内容
/// Table：User.BDPHoliday
/// Input：web.Entity.CT.BDPHoliday 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.BDPHoliday).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPHoliday) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.BDPHDDate'="" eobj.BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPHDDate)
		s flag=..FormValidate(eobj.BDPHDRowId,eobj.BDPHDDate,eobj.LinkHospId)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BDPHDRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPHoliday).%New()
				
				///2018-03-12  添加时，默认描述为周几
				if eobj.BDPHDDesc=""
				{
					s mon=$zd(eobj.BDPHDDate,10)
					if mon=0 s eobj.BDPHDDesc="周日"
					if mon=1 s eobj.BDPHDDesc="周一"
					if mon=2 s eobj.BDPHDDesc="周二"
					if mon=3 s eobj.BDPHDDesc="周三"
					if mon=4 s eobj.BDPHDDesc="周四"
					if mon=5 s eobj.BDPHDDesc="周五"
					if mon=6 s eobj.BDPHDDesc="周六"
				}	  
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPHoliday).%OpenId(eobj.BDPHDRowId)
				s bobj=##class(web.Entity.CT.BDPHoliday).%New()
				s bobj.BDPHDRowId = eobj.BDPHDRowId
				s bobj.BDPHDDate = obj.BDPHDDate          
				s bobj.BDPHDDesc = obj.BDPHDDesc          	
							
				s bobj.BDPHDType = obj.BDPHDType
				s:obj.BDPHDHospitalDR'="" bobj.BDPHDHospitalDR = obj.BDPHDHospitalDR.%Id()
			}
			Ts	        	
			      	
			s obj.BDPHDDate = eobj.BDPHDDate          //修改代码
			s obj.BDPHDDesc = eobj.BDPHDDesc          //修改描述			
			s obj.BDPHDType = eobj.BDPHDType
			d obj.BDPHDHospitalDRSetObjectId(eobj.LinkHospId)		//医院
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.BDPHDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Holiday","User.BDPHoliday","节假日",id,eobj.BDPHDDesc,"A",eobj)
				d:eobj.BDPHDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Holiday","User.BDPHoliday","节假日",eobj.BDPHDRowId,eobj.BDPHDDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("节假日","web.DHCBL.CT.BDPHoliday","SaveEntity",eobj)
    			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-02-27
/// Description：返回日期节假日标识
/// Table：User.BDPHoliday
/// Input：date:日期，格式与HIS系统配置里的日期格式保持一致 ，日期不能为空
///        serviceid：特殊业务id (在User.BDPSpecialService表中维护)，如果取公共节假日，特殊业务id传空即可。
///        timerangedr:时段id（在User. DHCTimeRange表中维护）
/// Return：节日2/假日1/非节假日0 /错误-1
/// W ##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate("2018-02-01","","")
ClassMethod IsHolidayDate(date As %String, servicedr As %String, timerangedr As %String, hospid As %String = "") As %String
{
	q:date="" "-1"
	if (servicedr'="")&&($g(^CT("BDPSS",servicedr))="") q "-1" //^特殊业务代码不存在"
	if (timerangedr'="")&&($g(^DHCTimeRange(timerangedr))="") q "-1" //^时段不存在"
	s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(date)
	q:date="" "-1"
	s holidayFlag=0
	if servicedr'=""
	{
		s BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",servicedr)),"^",4)
		//8.4多院区		2021-09-14
		s RowId=0
		for
		{
			s RowId=$o(^CT("BDPHS",0,"ServiceDate",servicedr,date,RowId)) q:RowId=""
			if (hospid="")
			{
				q	//不区分院区，直接结束循环
			}
			else
			{
				s BDPHSHospitalDR = $p($g(^CT("BDPHS",RowId)),"^",5)  //医院
				if (BDPHSHospitalDR=hospid)
				{
					q	//区分院区，仅该医院的数据结束循环返回RowId继续后续判断，否则跳过
				}
			}
		}
		
		if RowId'=""
		{
			S Type=$p($g(^CT("BDPHS",RowId)),"^",7)
			s BDPHSIEFlag = $p($g(^CT("BDPHS",RowId)),"^",3)
			if BDPSSTimeRangeFlag'="Y"   //特殊情况业务没开启时段标志时 
			{
				if BDPHSIEFlag="Exclude"
				{
					s holidayFlag= 0
				}
				else  //Include
				{
					if (Type="Holiday") s holidayFlag=2
					if (Type="Weekend") s holidayFlag=1
					
				}
			}
			else    //特殊情况业务开启时段标志时 
			{
				s BDPHSTimeRangeDR=$p($g(^CT("BDPHS",RowId)),"^",6)
				s BDPHSTimeRangeDRstr=","_BDPHSTimeRangeDR_","
				s timerangedrstr=","_timerangedr_","
				if BDPHSIEFlag="Exclude"
				{
					
					if (BDPHSTimeRangeDR="")
					{
						s holidayFlag= 0
					}
					elseif ((BDPHSTimeRangeDR'="")&&(timerangedr=""))
					{
						s holidayFlag= 0
					}
					elseif (BDPHSTimeRangeDR'="")&&(timerangedr'="")
					{
						if (BDPHSTimeRangeDRstr[timerangedrstr)
						{
							s holidayFlag= 0
						}
						if (BDPHSTimeRangeDRstr'[timerangedrstr)
						{
							if $p($g(^DHCTimeRange(timerangedr)),"^",2)="全天"  //update2020-01-07
							{
								s holidayFlag= 0
							}
							else
							{
								if (Type="Holiday") s holidayFlag= 2
								if (Type="Weekend") s holidayFlag= 1
							}
						}
					}
				
				}
				else{  //Include
					
					if (BDPHSTimeRangeDR="")
					{
						if (Type="Holiday") s holidayFlag= 2
						if (Type="Weekend") s holidayFlag= 1
					}
					elseif ((BDPHSTimeRangeDR'="")&&(timerangedr=""))
					{
						s holidayFlag= 0 
						///判断包不包含全天时段 update2020-01-07
						s length=$l(BDPHSTimeRangeDR,",")
						for lengthi=1:1:length
						{
							s BDPHSTimeRangeDR1=$p(BDPHSTimeRangeDR,",",lengthi)
							continue:BDPHSTimeRangeDR1=""
							if $p($g(^DHCTimeRange(BDPHSTimeRangeDR1)),"^",2)="全天"
							{
								if (Type="Holiday") s holidayFlag= 2
								if (Type="Weekend") s holidayFlag= 1
							}
						}
					}
					elseif (BDPHSTimeRangeDR'="")&&(timerangedr'="")
					{
						if (BDPHSTimeRangeDRstr[timerangedrstr)
						{
							if (Type="Holiday") s holidayFlag= 2
							if (Type="Weekend") s holidayFlag= 1
						}
						if (BDPHSTimeRangeDRstr'[timerangedrstr)
						{
							s holidayFlag= 0
						}
					}
				}
			}
		}
		else
		{
			if (hospid="")
			{
				s RowId=$o(^CT("BDPHD",0,"Date",date,0))
				if RowId'=""
				{
					S Type=$p($g(^CT("BDPHD",RowId)),"^",3)
					if Type="Holiday" s holidayFlag=2
					if Type="Weekend" s holidayFlag=1
				}
			}
			else	//8.4多院区	2021-09-14
			{
				s RowId=0
				for
				{
					s RowId=$o(^CT("BDPHD",0,"Date",date,RowId)) q:RowId=""
					s Type=$p($g(^CT("BDPHD",RowId)),"^",3)
					s BDPHDHospitalDR=$p($g(^CT("BDPHD",RowId)),"^",8)  //医院
					if (BDPHDHospitalDR=hospid)
					{
						if Type="Holiday" s holidayFlag=2
						if Type="Weekend" s holidayFlag=1
					}
				}
			}
		}
	}
	else
	{
		///公共节假日
		if (hospid="")
		{
			s RowId=$o(^CT("BDPHD",0,"Date",date,0))
			if RowId'=""
			{
				S Type=$p($g(^CT("BDPHD",RowId)),"^",3)
				if Type="Holiday" s holidayFlag=2
				if Type="Weekend" s holidayFlag=1
			}
		}
		else	//8.4多院区	2021-09-14
		{
			s RowId=0
			for
			{
				s RowId=$o(^CT("BDPHD",0,"Date",date,RowId)) q:RowId=""
				s Type=$p($g(^CT("BDPHD",RowId)),"^",3)
				s BDPHDHospitalDR=$p($g(^CT("BDPHD",RowId)),"^",8)  //医院
				if (BDPHDHospitalDR=hospid)
				{
					if Type="Holiday" s holidayFlag=2
					if Type="Weekend" s holidayFlag=1
				}
			}
		}
		
	}
	q holidayFlag
}

/// Creator：陈莹
/// CreatDate: 2018-02-27
/// Description：返回日期段每个日期的节假日标识，用^连接
/// Table：User.BDPHoliday
/// Input：Id
/// Return：节日2/假日1/非节假日0/错误 -1
/// W ##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateFlags("2018-01-01","2018-02-01","","")
ClassMethod GetHolidayDateFlags(datefrom As %String, dateto As %String, servicedr As %String, hospid As %String = "") As %String
{
	s holidayFlagStr=""
	q:datefrom="" -1
	q:dateto="" -1
	s datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
	s dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
	if datefrom>dateto q -1
	for datei=datefrom:1:dateto
	{
		s Hdatei=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(datei)
		s holidayFlag=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(Hdatei,servicedr,"",hospid)
		if holidayFlagStr="" s holidayFlagStr=holidayFlag
		else  s holidayFlagStr=holidayFlagStr_"^"_holidayFlag
	}
	q holidayFlagStr
}

/// Creator：陈莹
/// CreatDate: 2018-02-27
/// Description：返回日期段中总的节假日数量
/// Table：User.BDPHoliday
/// Input：Id
/// Return：Num
/// W ##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateNum("2018-01-01","2018-02-01","","")
ClassMethod GetHolidayDateNum(datefrom As %String, dateto As %String, servicedr As %String, hospid As %String = "") As %String
{
	s holidayNum=0
	q:datefrom="" 0
	q:dateto="" 0
	s datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
	s dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
	if datefrom>dateto q 0
	for datei=datefrom:1:dateto
	{
		s Hdatei=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(datei)
		s holidayFlag=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(Hdatei,servicedr,"",hospid)
		if holidayFlag>0 s holidayNum=holidayNum+1
	}
	q holidayNum
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：根据ID删除节假日的内容
/// Table：User.BDPHoliday
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// W ##class(web.DHCBL.CT.BDPHoliday).DeleteData(28)
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	
	s eobj = ##class(web.Entity.CT.BDPHoliday).%New()
	s eobj.BDPHDRowId = id
	s eobj.BDPHDDate = $p($g(^CT("BDPHD",id)),"^",1)
	s eobj.BDPHDDesc = $p($g(^CT("BDPHD",id)),"^",2)	
	s eobj.BDPHDType = $p($g(^CT("BDPHD",id)),"^",3)
	ts
	s sc = ##class(User.BDPHoliday).%DeleteId(id)
	if $$$ISOK(sc)
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Holiday","User.BDPHoliday","节假日",id,eobj.BDPHDDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("节假日","web.DHCBL.CT.BDPHoliday","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：杨帆
/// CreatDate: 2021-2-7
/// Description：多选删除方法
/// Table：User.BDPHolidayService
/// Input：str (选中行对应的BDPHDRowId拼串)
/// Return：
/// Other: w ##class(web.DHCBL.CT.BDPHoliday).DeleteAll("")
ClassMethod DeleteAll(str As %String) As %String
{
	s result=""
	s inputlen=$Length(str,"^")
	
	for j=1:1:inputlen
	{
	    s id=$p(str,"^",j)
		s:id'="" result=..DeleteData(id)
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：修改时打开的数据
/// Table：User.BDPHoliday
/// Input：id
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPHoliday).%New()
	s eobj.BDPHDRowId = id
	s eobj.BDPHDDate = $p($g(^CT("BDPHD",id)),"^",1)
	s:eobj.BDPHDDate'="" eobj.BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BDPHDDate)
	s eobj.BDPHDDesc = $p($g(^CT("BDPHD",id)),"^",2)	
	s eobj.BDPHDType = $p($g(^CT("BDPHD",id)),"^",3)
	
	if RetFlag=""
	{
		s:eobj.BDPHDType="Y" eobj.BDPHDType="true"
	}
	s str = eobj.JsonS()	
	d eobj.%Close()
	if RetFlag="" s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：查询节假日-节日/假日的内容
/// Table：User.BDPHoliday
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHoliday","GetHWList","2019-01-01","2019-12-31","Holiday",2)
Query GetHWList(datefrom As %String, dateto As %String, Type As %String, servicedr As %String, hospid As %String = "") As %Query(ROWSPEC = "BDPHDRowId:%String,BDPHDDate:%String,BDPHDDesc:%String,BDPHDType:%String,BDPHSRowId:%String,BDPHSIEFlag:%String,TimeRangeFlag:%String,BDPHSTimeRangeDR:%String,BDPHSTimeRangeDRID:%String")
{
}

ClassMethod GetHWListExecute(ByRef qHandle As %Binary, datefrom As %String, dateto As %String, Type As %String, servicedr As %String, hospid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	q:(datefrom="")||(dateto="")
	
	s datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
	s dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
	k myArray
	if Type'=""
	{
		if servicedr'=""
		{
			s BDPHSTimeRangeDR=""
			s BDPHSTimeRangeDRID=""
			s TimeRangeFlag=$p($g(^CT("BDPSS",servicedr)),"^",4)
			s FDate=0
			for 
			{
				s FDate=$o(^CT("BDPHD",0,"TypeDate",Type,FDate)) q:FDate=""
				s BDPHDRowId=0
				for 
				{
					s BDPHDRowId=$o(^CT("BDPHD",0,"TypeDate",Type,FDate,BDPHDRowId)) q:BDPHDRowId=""
					s BDPHDDate = $p($g(^CT("BDPHD",BDPHDRowId)),"^",1)  //FDate
					if (BDPHDDate>=datefrom)&&(BDPHDDate<=dateto)
					{
						s BDPHDDesc = $p($g(^CT("BDPHD",BDPHDRowId)),"^",2)
						s BDPHDType = $p($g(^CT("BDPHD",BDPHDRowId)),"^",3)
						
						s BDPHDHospitalDR = $p($g(^CT("BDPHD",BDPHDRowId)),"^",8)  //医院
						continue:(hospid'="")&&(hospid'=BDPHDHospitalDR)	//按院区过滤	2021-09-13
						
						s BDPHSIEFlag="",BDPHSDesc=""
						s BDPHSTimeRangeDR=""
						s BDPHSTimeRangeDRID=""
						s BDPHSRowId=$o(^CT("BDPHS",0,"ServiceDate",servicedr,BDPHDDate,0))
						if BDPHSRowId'=""
						{
							s BDPHSIEFlag=$p($g(^CT("BDPHS",BDPHSRowId)),"^",3)		
							S BDPHSDesc=$p($g(^CT("BDPHS",BDPHSRowId)),"^",4)
						
							s BDPHSTimeRangeDR=$p($g(^CT("BDPHS",BDPHSRowId)),"^",6)
							s BDPHSTimeRangeDRID=BDPHSTimeRangeDR
							if BDPHSTimeRangeDR'=""
							{
								s Descs=""
								s length=$l(BDPHSTimeRangeDR,",")
								for i=1:1:length
								{
									s BDPHSTimeRangeDRi=$p(BDPHSTimeRangeDR,",",i)
									continue:BDPHSTimeRangeDRi=""
									s Desc=$p($g(^DHCTimeRange(BDPHSTimeRangeDRi)),"^",2)
									if Descs="" s Descs=Desc
									else  s Descs=Descs_","_Desc
								}
								s BDPHSTimeRangeDR=Descs
							}
						}
						if BDPHSDesc'="" s BDPHDDesc=BDPHSDesc
						s myArray(BDPHDDate)=BDPHDRowId_"^"_BDPHDDate_"^"_BDPHDDesc_"^"_BDPHDType_"^"_BDPHSRowId_"^"_BDPHSIEFlag_"^"_TimeRangeFlag_"^"_BDPHSTimeRangeDR_"^"_BDPHSTimeRangeDRID
						
					}
			
				}
			}
			s BDPHSRowId=0
			for 
			{
				s BDPHSRowId=$o(^CT("BDPHS",0,"Service",servicedr,BDPHSRowId)) q:BDPHSRowId=""
				S BDPHSDate=$p($g(^CT("BDPHS",BDPHSRowId)),"^",1)
				if (BDPHSDate>=datefrom)&&(BDPHSDate<=dateto)
				{
					
					S BDPHSType=$p($g(^CT("BDPHS",BDPHSRowId)),"^",7)
					s BDPHSDesc=$p($g(^CT("BDPHS",BDPHSRowId)),"^",4)
					
					s BDPHSHospitalDR = $p($g(^CT("BDPHS",BDPHSRowId)),"^",5)  //医院
					continue:(hospid'="")&&(hospid'=BDPHSHospitalDR)	//按院区过滤	2021-09-13
					
					if BDPHSType=Type
					{
						continue:$d(myArray(BDPHSDate))>0
						s BDPHSTimeRangeDR=$p($g(^CT("BDPHS",BDPHSRowId)),"^",6)
						s BDPHSTimeRangeDRID=BDPHSTimeRangeDR
						if BDPHSTimeRangeDR'=""
						{
							s Descs=""
							s length=$l(BDPHSTimeRangeDR,",")
							for i=1:1:length
							{
								s BDPHSTimeRangeDRi=$p(BDPHSTimeRangeDR,",",i)
								continue:BDPHSTimeRangeDRi=""
								s Desc=$p($g(^DHCTimeRange(BDPHSTimeRangeDRi)),"^",2)
								if Descs="" s Descs=Desc
								else  s Descs=Descs_","_Desc
							}
							s BDPHSTimeRangeDR=Descs
						
						}
						s BDPHSIEFlag=$p($g(^CT("BDPHS",BDPHSRowId)),"^",3)
						s myArray(BDPHSDate)=""_"^"_BDPHSDate_"^"_BDPHSDesc_"^"_BDPHSType_"^"_BDPHSRowId_"^"_BDPHSIEFlag_"^"_TimeRangeFlag_"^"_BDPHSTimeRangeDR_"^"_BDPHSTimeRangeDRID
					}	
				}
			}
			s arrayn=0
			for 
			{
				s arrayn=$o(myArray(arrayn)) q:arrayn=""
				s BDPHDRowId=$p($g(myArray(arrayn)),"^",1)
				s BDPHDDate=$p($g(myArray(arrayn)),"^",2)
				s BDPHDDesc=$p($g(myArray(arrayn)),"^",3)
				s BDPHDType=$p($g(myArray(arrayn)),"^",4)
				s BDPHSRowId=$p($g(myArray(arrayn)),"^",5)
				s BDPHSIEFlag=$p($g(myArray(arrayn)),"^",6)
				s TimeRangeFlag=$p($g(myArray(arrayn)),"^",7)
				s BDPHSTimeRangeDR=$p($g(myArray(arrayn)),"^",8)
				s BDPHSTimeRangeDRID=$p($g(myArray(arrayn)),"^",9)
				s:BDPHDDate'="" BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPHDDate)
						
				d OutputRow
			}
		}
		else{
			s TimeRangeFlag="",BDPHSTimeRangeDR="",BDPHSTimeRangeDRID=""
			s FDate=0
			for 
			{
				s FDate=$o(^CT("BDPHD",0,"TypeDate",Type,FDate)) q:FDate=""
				s BDPHDRowId=0
				for 
				{
					s BDPHDRowId=$o(^CT("BDPHD",0,"TypeDate",Type,FDate,BDPHDRowId)) q:BDPHDRowId=""
					s BDPHDDate = $p($g(^CT("BDPHD",BDPHDRowId)),"^",1)  //FDate
					
					s BDPHDHospitalDR = $p($g(^CT("BDPHD",BDPHDRowId)),"^",8)  //医院
					continue:(hospid'="")&&(hospid'=BDPHDHospitalDR)	//按院区过滤	2021-09-13
					
					if (BDPHDDate>=datefrom)&&(BDPHDDate<=dateto)
					{
						s BDPHDDesc = $p($g(^CT("BDPHD",BDPHDRowId)),"^",2)
						s BDPHDType = $p($g(^CT("BDPHD",BDPHDRowId)),"^",3)
						s BDPHSRowId="",BDPHSIEFlag=""							
						s:BDPHDDate'="" BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPHDDate)
						d OutputRow
					}
				}
			}
		}
	}
		
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BDPHDRowId,BDPHDDate,BDPHDDesc,BDPHDType,BDPHSRowId,BDPHSIEFlag,TimeRangeFlag,BDPHSTimeRangeDR,BDPHSTimeRangeDRID)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHWListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHWListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHWListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHWListExecute ]
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
/// CreatDate: 2018-02-05
/// Description：查询节假日的内容
/// Table：User.BDPHoliday
/// Input：datefrom,dateto,onlyweekendflag,servicedr
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHoliday","GetAllDayList","2020-12-12","2021-12-12","","","2")
Query GetAllDayList(datefrom As %String, dateto As %String, onlyweekendflag As %String, servicedr As %String, hospid As %String = "") As %Query(ROWSPEC = "myDate:%String,Weekendflag:%String")
{
}

ClassMethod GetAllDayListExecute(ByRef qHandle As %Binary, datefrom As %String, dateto As %String, onlyweekendflag As %String, servicedr As %String, hospid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	q:(datefrom="")||(dateto="")
	s datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
	s dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
	if datefrom<=dateto
	{
		s ZDate=datefrom-1
		for
		{
			s ZDate=ZDate+1 q:ZDate>dateto
			///过滤节日和假日
			if (hospid="")
			{
				continue:$d(^CT("BDPHD",0,"TypeDate","Weekend",ZDate))>0
				continue:$d(^CT("BDPHD",0,"TypeDate","Holiday",ZDate))>0
			}
			else	//按院区过滤	2021-09-13
			{
				s continueflag=0	//过滤标识
				s BDPHDRowId=0
				for
				{
					s BDPHDRowId=$o(^CT("BDPHD",0,"TypeDate","Weekend",ZDate,BDPHDRowId)) q:BDPHDRowId=""
					s BDPHDHospitalDR = $p($g(^CT("BDPHD",BDPHDRowId)),"^",8)  //医院
					if (BDPHDHospitalDR=hospid)	//该节假日属于该医院，把该日期过滤
					{
						s continueflag=1
						q
					}
				}
				s BDPHDRowId=0
				for
				{
					s BDPHDRowId=$o(^CT("BDPHD",0,"TypeDate","Holiday",ZDate,BDPHDRowId)) q:BDPHDRowId=""
					s BDPHDHospitalDR = $p($g(^CT("BDPHD",BDPHDRowId)),"^",8)  //医院
					if (BDPHDHospitalDR=hospid)	//该节假日属于该医院，把该日期过滤
					{
						s continueflag=1
						q
					}
				}
				continue:continueflag=1
			}
			
			//如果选择了特殊业务，则过滤特别节假日情况关联记录表
			if servicedr'=""
			{
				if (hospid="")
				{
					continue:$d(^CT("BDPHS",0,"ServiceDate",servicedr,ZDate))>0 
				}
				else	//按院区过滤	2021-09-13
				{
					s continueflag=0	//过滤标识
					s BDPHSRowId=0
					for
					{
						s BDPHSRowId=$o(^CT("BDPHS",0,"ServiceDate",servicedr,ZDate,BDPHSRowId)) q:BDPHSRowId=""
						s BDPHSHospitalDR = $p($g(^CT("BDPHS",BDPHSRowId)),"^",5)  //医院
						if (BDPHSHospitalDR=hospid)	//该节假日属于该医院，把该日期过滤
						{
							s continueflag=1
							q
						}
					}
					continue:continueflag=1
				}
			}
			s tDate=$zd(ZDate,12)
			if (tDate="Saturday")||(tDate="Sunday") s Weekendflag="Y"
			else  s Weekendflag="N"
			s myDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ZDate)
			continue:(onlyweekendflag="Y")&&(Weekendflag'="Y")
		
			D OutputRowAllDay
		}
	}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAllDay
    set Data=$lb(myDate,Weekendflag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAllDayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDayListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllDayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDayListExecute ]
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
/// CreatDate: 2018-02-05
/// Description：节假日,为combobox查询取数据
/// Table：User.BDPHoliday
/// Input：rowid,code,desc
/// Return：BDPHDRowId,BDPHDDate,BDPHDDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHoliday","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDPHDRowId:%String,BDPHDDate:%String,BDPHDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BDPHDRowId = rowid
		s BDPHDDate = $p($g(^CT("BDPHD",BDPHDRowId)),"^",1)
		s:BDPHDDate'="" BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(BDPHDDate)
		s BDPHDDesc = $p($g(^CT("BDPHD",BDPHDRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		
		s BDPHDRowId=0
		f {
			s BDPHDRowId=$o(^CT("BDPHD",BDPHDRowId)) q:BDPHDRowId=""
			s BDPHDDate = $p($g(^CT("BDPHD",BDPHDRowId)),"^",1)
			s:BDPHDDate'="" BDPHDDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPHDDate)
			s BDPHDDesc = $p($g(^CT("BDPHD",BDPHDRowId)),"^",2)
			if (desc'="")
			{
				;需要对描述或者别名进行检索      
				s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("BDP_Holiday",BDPHDRowId,BDPHDDesc,desc)
			}
			else
			{
				s AliasFlag= 1   
			}
			i ($zcvt(BDPHDDate,"u")[code)&&(AliasFlag=1)
			{
				d OutputRowCmb
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BDPHDRowId,BDPHDDate,BDPHDDesc)
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
/// CreatDate: 2020-09-29
/// Description：返回日期节假日描述
/// Table：User.BDPHoliday
/// Input：date:日期，格式与HIS系统配置里的日期格式保持一致 ，日期不能为空；医院id
/// Return：国庆节
/// W ##class(web.DHCBL.CT.BDPHoliday).GetHolidayDesc("2018-02-01","2")
ClassMethod GetHolidayDesc(date As %String, hospid As %String = "") As %String
{
	q:date="" "-1"
	s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(date)
	q:date="" "-1"
	s BDPHDDesc=""
	///公共节假日
	s RowId=0
	for
	{
		s RowId=$o(^CT("BDPHD",0,"Date",date,RowId)) q:RowId=""
		s desc=$p($g(^CT("BDPHD",RowId)),"^",2)
		if (hospid="")
		{
			s BDPHDDesc=desc
			q
		}
		else
		{
			s BDPHDHospitalDR=$p($g(^CT("BDPHD",RowId)),"^",8)  //医院
			if (BDPHDHospitalDR=hospid)
			{
				s BDPHDDesc=desc
				q
			}
		}
	}
	q BDPHDDesc
}

/// 批量关联已有数据到指定医院
/// 基础数据平台-likefan
/// 2021-11-11
/// input: 医院id
/// w ##class(web.DHCBL.CT.BDPHoliday).UpdateAllDataToHosp("2")
ClassMethod UpdateAllDataToHosp(hospid) As %String
{
	q:hospid="" ""
	//关联节假日数据BDP_Holiday
	s BDPHDRowId=0
	for
	{
		s BDPHDRowId=$o(^CT("BDPHD",BDPHDRowId)) q:BDPHDRowId=""
		s BDPHDHospitalDR=$p($g(^CT("BDPHD",BDPHDRowId)),"^",8)  //医院
		if (BDPHDHospitalDR="")
		{
			s obj=##class(User.BDPHoliday).%OpenId(BDPHDRowId)	
			d obj.BDPHDHospitalDRSetObjectId(hospid)		//医院
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				w "errorHD^"_BDPHDRowId,!
			}
		}
	}
	//关联节假日特殊业务代码数据BDP_HolidayService
	s BDPHSRowId=0
	for
	{
		s BDPHSRowId=$o(^CT("BDPHS",BDPHSRowId)) q:BDPHSRowId=""
		s BDPHSHospitalDR=$p($g(^CT("BDPHS",BDPHSRowId)),"^",5)  //医院
		if (BDPHSHospitalDR="")
		{
			s obj=##class(User.BDPHolidayService).%OpenId(BDPHSRowId)	
			d obj.BDPHSHospitalDRSetObjectId(hospid)		//医院
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				w "errorHS^"_BDPHSRowId,!
			}
		}
	}
	q "ok"
}

}
