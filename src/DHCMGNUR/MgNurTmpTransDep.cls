/// 
/// ClassMethod Description:临时人员调科记录
/// Date:2015-04-13
Class DHCMGNUR.MgNurTmpTransDep Extends %Persistent
{

/// 姓名
Property PerName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 人员表ID
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
   s perid=$P(parm,"^",2)
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
   s rw=""  f  s rw=$O(^DHCMGNUR.MgNurTmpTransDepI("PerDr",per,rw)) q:rw=""  d
   .s loc=$List(^DHCMGNUR.MgNurTmpTransDepD(rw),4)
   .s enddate=$List(^DHCMGNUR.MgNurTmpTransDepD(rw),8)
   .if (loc=dep)&(enddate="") s id=rw
   .e  d
   ..s id="",upid=rw
   if id'="" s a=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(id)
   e  s a=##class(DHCMGNUR.MgNurTmpTransDep).%New()
   s a.PerDr=##class(DHCMGNUR.MgPersons).%OpenId(per)
   s a.PerDepart=dep
   s a.PerID=perid
   s a.PerName=pername
   s a.PerTranStDate=stdate
   s a.PerTranStTime=sttime
   s a.PerTranCurrent=curr
   s a.PerTranMem=mem
   s a.PerFlag=flag
   d a.%Save()
   if upid'="" 
   {
      s aa=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(upid)
      s aa.PerTranEndDate=stdate
      s aa.PerTranEndTime=sttime
      s aa.PerTranCurrent="N"
      d aa.%Save()      
  }
  q 0
}

Storage Default
{
<Data name="MgNurTmpTransDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerName</Value>
</Value>
<Value name="3">
<Value>PerID</Value>
</Value>
<Value name="4">
<Value>PerDr</Value>
</Value>
<Value name="5">
<Value>PerDepart</Value>
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
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurTmpTransDepD</DataLocation>
<DefaultData>MgNurTmpTransDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurTmpTransDepD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurTmpTransDepI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurTmpTransDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
