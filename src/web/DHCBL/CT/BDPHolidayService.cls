/// 名称:  特别节假日情况关联记录维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-02-05
Class web.DHCBL.CT.BDPHolidayService Extends %RegisteredObject
{

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：数据重复验证方法,js调用
/// Table：User.BDPHoliday
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, servicedr) As %String
{
	s flag="",flagc="",flagd=""
	if (servicedr'="")
	{
		s:code'="" flagc=$d(^CT("BDPHS",0,"Service",servicedr,code))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else //如果不为空，修改时的重复判断
		{
			s idc=""
			s:code'="" idc=$o(^CT("BDPHS",0,"Service",servicedr,code,0))
			if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		
	}
	
	
	q flag
}

/// Creator：陈莹
/// CreatDate:2018-02-05
/// Description：保存修改特别节假日情况关联记录的内容
/// Table：User.BDPHoliday
/// Input：web.Entity.CT.BDPHolidayService 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.BDPHolidayService).SaveData(id^YYYY-MM-DD^Type)
ClassMethod SaveData(DataStr) As %String
{
	s result = ""
	if ($tr(DataStr,"^","")'="")
	{
		s eobj=##class(web.Entity.CT.BDPHolidayService).%New()	
		s eobj.BDPHSRowId =$p(DataStr,"^",1)
		s eobj.BDPHSDate = $p(DataStr,"^",2)
		s eobj.BDPHSType = $p(DataStr,"^",3)
		s eobj.BDPHSServiceDR = $p(DataStr,"^",4)
		s eobj.BDPHSIEFlag = $p(DataStr,"^",5)
		s eobj.BDPHSDesc = $p(DataStr,"^",6)
		s eobj.BDPHSTimeRangeDR = $p(DataStr,"^",7)
		s eobj.LinkHospId = $p(DataStr,"^",8)
		if $E(eobj.BDPHSTimeRangeDR,1)="," s eobj.BDPHSTimeRangeDR = $e(eobj.BDPHSTimeRangeDR,2,$l(eobj.BDPHSTimeRangeDR))
		
		s result=##class(web.DHCBL.CT.BDPHolidayService).SaveEntity(eobj)	
			
	}
	else
	{
		s result = "{success:'false',errorinfo:'数据为空！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate:2018-02-05
/// Description：保存修改特别节假日情况关联记录的内容
/// Table：User.BDPHoliday
/// Input：web.Entity.CT.BDPHolidayService 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.BDPHoliday).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPHoliday) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.BDPHSDate'="" eobj.BDPHSDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPHSDate)
		s flag=..FormValidate(eobj.BDPHSRowId,eobj.BDPHSDate,eobj.BDPHSServiceDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BDPHSRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPHolidayService).%New()
				///2018-03-12  添加时，默认描述为周几
				if eobj.BDPHSDesc=""
				{
					s mon=$zd(eobj.BDPHSDate,10)
					if mon=0 s eobj.BDPHSDesc="周日"
					if mon=1 s eobj.BDPHSDesc="周一"
					if mon=2 s eobj.BDPHSDesc="周二"
					if mon=3 s eobj.BDPHSDesc="周三"
					if mon=4 s eobj.BDPHSDesc="周四"
					if mon=5 s eobj.BDPHSDesc="周五"
					if mon=6 s eobj.BDPHSDesc="周六"
				}	  
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPHolidayService).%OpenId(eobj.BDPHSRowId)
				s bobj=##class(web.Entity.CT.BDPHolidayService).%New()
				s bobj.BDPHSRowId = eobj.BDPHSRowId
				s bobj.BDPHSDate = obj.BDPHSDate          
				        	
				if $IsObject(obj.BDPHSServiceDR){
					s bobj.BDPHSServiceDR = obj.BDPHSServiceDR.%Id() 
				}
								
				s bobj.BDPHSIEFlag = obj.BDPHSIEFlag
				s bobj.BDPHSDesc = obj.BDPHSDesc 
				s bobj.BDPHSTimeRangeDR = obj.BDPHSTimeRangeDR
				
				s bobj.BDPHSType = obj.BDPHSType
				s:obj.BDPHSHospitalDR'="" bobj.BDPHSHospitalDR = obj.BDPHSHospitalDR.%Id()
			}
			Ts	        		        	
			s obj.BDPHSDate = eobj.BDPHSDate
			d obj.BDPHSServiceDRSetObjectId(eobj.BDPHSServiceDR)
			s obj.BDPHSIEFlag = eobj.BDPHSIEFlag
			s obj.BDPHSDesc = eobj.BDPHSDesc		
			s obj.BDPHSTimeRangeDR=eobj.BDPHSTimeRangeDR
			s obj.BDPHSType = eobj.BDPHSType
			d obj.BDPHSHospitalDRSetObjectId(eobj.LinkHospId)		//医院
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.BDPHSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HolidayService","User.BDPHolidayService","特别节假日情况关联记录",id,eobj.BDPHSDate,"A",eobj)
				d:eobj.BDPHSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HolidayService","User.BDPHolidayService","特别节假日情况关联记录",eobj.BDPHSRowId,eobj.BDPHSDate,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特别节假日情况关联记录","web.DHCBL.CT.BDPHolidayService","SaveEntity",eobj)
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
/// CreatDate: 2018-02-05
/// Description：判断特殊业务是否显示时段标志
/// Table：User.BDPHolidayService
/// Input：Id（特殊业务id)
/// Other：w ##class(web.DHCBL.CT.BDPHolidayService).IsShowTimeRange()
ClassMethod IsShowTimeRange(serviceid As %String) As %String
{
	q:serviceid="" "N"
	s BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",serviceid)),"^",4)
	s:BDPSSTimeRangeFlag'="Y" BDPSSTimeRangeFlag="N"
	q BDPSSTimeRangeFlag
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：根据ID删除特别节假日情况关联记录的内容
/// Table：User.BDPHolidayService
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other：w ##class(web.DHCBL.CT.BDPHolidayService).IsShowTimeRange()
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//验证是否被引用
	
	s eobj = ##class(web.Entity.CT.BDPHolidayService).%New()
	s eobj.BDPHSRowId = id
	s eobj.BDPHSDate = $p($g(^CT("BDPHS",id)),"^",1)
	s eobj.BDPHSServiceDR =  $p($g(^CT("BDPHS",id)),"^",2)
	s eobj.BDPHSIEFlag = $p($g(^CT("BDPHS",id)),"^",3)
	s eobj.BDPHSDesc = $p($g(^CT("BDPHS",id)),"^",4)
	s eobj.BDPHSTimeRangeDR = $p($g(^CT("BDPHS",id)),"^",6)
	s eobj.BDPHSType =  $p($g(^CT("BDPHS",id)),"^",7)
	
	ts
	s sc = ##class(User.BDPHolidayService).%DeleteId(id)
	if $$$ISOK(sc)
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HolidayService","User.BDPHolidayService","特别节假日情况关联记录",id,eobj.BDPHSDate,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特别节假日情况关联记录","web.DHCBL.CT.BDPHoliday","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：杨帆
/// CreatDate: 2021-2-7
/// Description：多选删除方法
/// Table：User.BDPHolidayService
/// Input：inputstr (选中行对应的BDPHSRowId拼串)
/// Return：
/// Other: w ##class(web.DHCBL.CT.BDPHolidayService).DeleteAll("")
ClassMethod DeleteAll(inputstr As %String) As %String
{
	s result=""
	s inputlen=$Length(inputstr,"^")
	
	for j=1:1:inputlen
	{
	    s id=$p(inputstr,"^",j)
		s:id'="" result=..DeleteData(id)
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：修改时打开的数据/extjs//hisui
/// Table：User.BDPHolidayService
/// Input：id
/// Other：w ##class(web.DHCBL.CT.BDPHolidayService).OpenData(7)
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPHolidayService).%New()
	s eobj.BDPHSRowId = id
	s eobj.BDPHSDate = $p($g(^CT("BDPHS",id)),"^",1)
	s eobj.BDPHSServiceDR =  $p($g(^CT("BDPHS",id)),"^",2)
	s eobj.BDPHSIEFlag = $p($g(^CT("BDPHS",id)),"^",3)
	s eobj.BDPHSDesc = $p($g(^CT("BDPHS",id)),"^",4)
	s eobj.BDPHSTimeRangeDR = $p($g(^CT("BDPHS",id)),"^",6)
	s eobj.BDPHSType =  $p($g(^CT("BDPHS",id)),"^",7)
	
	if RetFlag=""
	{
		s:eobj.BDPHSIEFlag="Y" eobj.BDPHSIEFlag="true"
	}
	s:eobj.BDPHSDate'="" eobj.BDPHSDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BDPHSDate)
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	if RetFlag="" s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2018-2-5
/// Description：返回没有关联特殊业务的节假日信息，以便新增关联
/// Table：User.BDPHoliday
/// Input：id
/// 
ClassMethod NewOpenData2(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPHolidayService).%New()
	s eobj.BDPHSRowId =""
	s eobj.BDPHSDate = $p($g(^CT("BDPHD",id)),"^",1)
	s:eobj.BDPHSDate'="" eobj.BDPHSDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BDPHSDate)
	s eobj.BDPHSServiceDR = ""
	s eobj.BDPHSIEFlag = ""
	s eobj.BDPHSDesc = $p($g(^CT("BDPHD",id)),"^",2)
	s eobj.BDPHSTimeRangeDR = ""
	s eobj.BDPHSType = $p($g(^CT("BDPHD",id)),"^",3)
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：时段
/// Table：User.DHCTimeRange
/// Input：rowid,code,desc
/// Return：BDPHDRowId,BDPHDDate,BDPHDDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHolidayService","GetRangeDataForCmb","","","")
Query GetRangeDataForCmb(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TRRowId:%String,TRCode:%String,TRDesc:%String")
{
}

ClassMethod GetRangeDataForCmbExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TRRowId = rowid
		s TRCode = $p($g(^DHCTimeRange(TRRowId)),"^",1)
		s TRDesc = $p($g(^DHCTimeRange(TRRowId)),"^",2)
		
		d OutputRowRangeData
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		
		s TRRowId=0
		for
		{
			s TRRowId=$o(^DHCTimeRange(TRRowId)) q:TRRowId=""
			s TRCode = $p($g(^DHCTimeRange(TRRowId)),"^",1)
			s TRDesc = $p($g(^DHCTimeRange(TRRowId)),"^",2)
			s TRStartDate=$p($g(^DHCTimeRange(TRRowId)),"^",7)
			continue:(TRStartDate'="")&&(TRStartDate>+$h)
			s TREndDate=$p($g(^DHCTimeRange(TRRowId)),"^",8)
			continue:(TREndDate'="")&&(TREndDate<+$h)
			i ($zcvt(TRCode,"u")[code)&&($zcvt(TRDesc,"u")[desc)
			{
				d OutputRowRangeData
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowRangeData
    set Data=$lb(TRRowId,TRCode,TRDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRangeDataForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRangeDataForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRangeDataForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRangeDataForCmbExecute ]
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

}
