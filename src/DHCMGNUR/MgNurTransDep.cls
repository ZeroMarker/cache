Class DHCMGNUR.MgNurTransDep Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 姓名
Property PerName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 人员ID
Property PerDr As DHCMGNUR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Per_Dr ];

/// 科室
Property PerDepart As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Depart ];

/// 开始日期
Property PerTranStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_Tran_StDate ];

/// 开始时间
Property PerTranStTime As %Time [ SqlColumnNumber = 7, SqlFieldName = Per_Tran_StTime ];

/// 结束日期
Property PerTranEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Per_Tran_EndDate ];

/// 结束时间
Property PerTranEndTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Per_Tran_EndTime ];

///  当前状态
Property PerTranCurrent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Per_Tran_Current ];

/// 备注
Property PerTranMem As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Per_Tran_Mem ];

/// 标识位
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Per_Flag ];

Index PerDr On PerDr;

Index PerID On PerID;

Index Current On (PerTranCurrent, PerID);

Index Dep On PerDepart;

ClassMethod Save(parm As %String) As %String
{
  //parm="name^personid^^id^护理单元^2013-07-20^15:09^Y"
   s pername=$P(parm,"^",1)
   s perid=$ZConvert($P(parm,"^",2),"U")
   s id=$P(parm,"^",3)
   s per=$P(parm,"^",4)
   s dep=$P(parm,"^",5)
   s stdate=$P(parm,"^",6)
   s sttime=$P(parm,"^",7)
   s curr=$P(parm,"^",8)
   s flag=$P(parm,"^",9)
   s mem=$P(parm,"^",10)
   s stdate=$ZDH(stdate,3)
   s ^Tempstdate=stdate
   if sttime'="" s sttime=$ZTH(sttime)
   e  s sttime=$P($H,",",2)
   s id="",upid=""
   s rw=""  f  s rw=$O(^DHCMGNUR.MgNurTransDepI("PerDr",per,rw)) q:rw=""  d
   .s loc=$List(^DHCMGNUR.MgNurTransDepD(rw),4)
   .s enddate=$List(^DHCMGNUR.MgNurTransDepD(rw),8)
   .if (loc=dep)&(enddate="") s id=rw
   .e  d
   ..s id="",upid=rw
   if id'="" s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(id)
   e  s a=##class(DHCMGNUR.MgNurTransDep).%New()
   s a.PerDr=##class(DHCMGNUR.MgPersons).%OpenId(per)
   s a.PerDepart=dep
   s a.PerID=perid
   s a.PerName=$ZConvert(pername,"U")
   s a.PerTranStDate=stdate
   s a.PerTranStTime=sttime
   s a.PerTranCurrent=curr
   s a.PerTranMem=mem
   s a.PerFlag=flag
   d a.%Save()
   if upid'="" 
   {
      s aa=##class(DHCMGNUR.MgNurTransDep).%OpenId(upid)
      s aa.PerTranEndDate=stdate
      s aa.PerTranEndTime=sttime
      s aa.PerTranCurrent="N"
      d aa.%Save()      
  }
  q 0
}

ClassMethod SaveHis(parr As %String) As %String
{
	;s ^TMP009=parr
	b ;01
	;s 237^程恩荷^8033^780^2013-11-01^2013-11-12
	s id=$P(parr,"^",1)
	s PerName=$P(parr,"^",2)
	s PerID=$P(parr,"^",3)
	s PerDepart=$P(parr,"^",4)
	s PerTranStDate=$P(parr,"^",5)
	s PerTranEndDate=$P(parr,"^",6)
	s edit=$P(parr,"^",7)
	s rowid=$P(parr,"^",8)
	i edit="0" d
	.s a=##class(DHCMGNUR.MgNurTransDep).%New()
	e  i edit="1" d
	.s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(rowid)
	s a.PerDr=##class(DHCMGNUR.MgPersons).%OpenId(id) 
	s a.PerName=$ZConvert(PerName,"U")
	s a.PerID=$ZConvert(PerID,"U")
	s a.PerDepart=PerDepart
	s a.PerTranStDate=$ZDH(PerTranStDate,3)
	s a.PerTranEndDate=$ZDH(PerTranEndDate,3)
	;s ^TMP0091=a.PerTranEndDate
	s a.PerTranCurrent="N"
	s a.PerFlag="0"
	d a.%Save()
}

ClassMethod getValue(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'=""
	{
		s a=##class(DHCMGNUR.MgNurTransDep).%OpenId(id)
		s ^TPMID=id
		s PerName=a.PerName
		s PerID=a.PerID
		;s PerDepart=$P(^CTLOC(a.PerDepart),"^",1)
		s PerDepart=a.PerDepart 
		i a.PerTranStDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerTranStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerTranStDate)
		.e  s PerTranStDate=""
		e  s PerTranStDate=""
		i a.PerTranEndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerTranEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerTranEndDate)
		.e  s PerTranEndDate=""
		e  s PerTranEndDate=""
		s PerTranCurrent=a.PerTranCurrent
		s ret=ret_"PerName|"_PerName_"^PerID|"_PerID_"^PerDepart|"_PerDepart_"^PerTranStDate|"_PerTranStDate_"^PerTranEndDate|"_PerTranEndDate		
	}
	q ret
}

ClassMethod delete(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurTransDep).%OpenId(id)
	i object.PerTranCurrent="Y" 
	{q "当前记录不能删除！只能维护历史记录!"}
	else
	{
		s sc = object.%DeleteId(id)
		b ;01
		i $$$ISERR(sc)  
		{
			TRollBack
			Do $System.Status.DisplayError(sc)
   			q "删除失败"
		}
		else
		{
			TCommit
			q "删除成功"
		}
	}
}

Storage Default
{
<Data name="MgNurTransDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonDr</Value>
</Value>
<Value name="3">
<Value>PerDr</Value>
</Value>
<Value name="4">
<Value>PerDepart</Value>
</Value>
<Value name="5">
<Value>PerID</Value>
</Value>
<Value name="6">
<Value>PerTranStDate</Value>
</Value>
<Value name="7">
<Value>PerTranStTime</Value>
</Value>
<Value name="8">
<Value>PerTranEndDate</Value>
</Value>
<Value name="9">
<Value>PerTranEndTime</Value>
</Value>
<Value name="10">
<Value>PerTranCurrent</Value>
</Value>
<Value name="11">
<Value>PerTranMem</Value>
</Value>
<Value name="12">
<Value>PerName</Value>
</Value>
<Value name="13">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurTransDepD</DataLocation>
<DefaultData>MgNurTransDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurTransDepD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurTransDepI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurTransDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
