/// Created by lihaihong@20170428
/// Cube数据根据调度日期因子以CubeDStruct##MAXBITRANGE为标准分区配置表
/// 废弃的类
Class DHCWL.DM.T.CubeDSPart Extends %Persistent
{

/// 单个节点的最大Bit长度 最大可设置为：262104  * 0.75 = 196578;
Parameter MAXBITRANGE = 262104;

Property CubeMask As %String [ Required ];

// scheduler date value

Property SDate As %Integer [ Required ];

Property PartIndex As %String [ Required ];

Property RowNum As %Integer [ Required ];

Index MainI On (CubeMask As EXACT, SDate);

Index PartIndexI On (CubeMask As EXACT, PartIndex As EXACT);

// s cubePart=##class(DHCWL.DM.T.CubeDSPart).TouchPart(1,62825)

/// 以日期线索实现的跳表，每个表格以尽可能的装满MAXBITRANGE个数为止
ClassMethod TouchPart(cubeMask, sdate As %Integer = 0) As CubeDSPart
{
	if sdate=0{
	  s matched="",nextDate=1
	  s date="" f{
	    s date=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,date))
	    q:date=""
	    s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,date,""))
	    continue:'$d(^DHCWL.DM.T.CubeDSPartD(id))
	    s obj=##class(CubeDSPart).%OpenId(id)
	    continue:(obj.RowNum > ..#MAXBITRANGE )
	    s matched=obj,nextDate=date+1
	    q
	  }
	  if matched=""{
		s matched=##class(CubeDSPart).%New()
		s matched.CubeMask=cubeMask,matched.SDate=nextDate,matched.RowNum=0,matched.PartIndex=$i(^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask))
		d matched.%Save()
	  }
	  q matched
	}
	if '$d(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate)){
	  s psd=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate),-1)
	  if psd="" {
	    s nsd=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate))
	    s obj=##class(CubeDSPart).%New()
		s obj.CubeMask=cubeMask,obj.SDate=sdate,obj.PartIndex=$i(^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask)),obj.RowNum=0
		d obj.%Save()
		q obj
	  }else{
		s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,psd,""))
		if '$d(^DHCWL.DM.T.CubeDSPartD(id)){
		  s obj=##class(CubeDSPart).%New()
		  s obj.CubeMask=cubeMask,obj.SDate=psd,obj.PartIndex=$i(^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask)),obj.RowNum=0
		  d obj.%Save()
		}else{
		  s obj=##class(CubeDSPart).%OpenId(id)
		}
		if (obj.RowNum > ..#MAXBITRANGE ){
		  s obj=""
		  s obj=##class(CubeDSPart).%New()
		  s obj.CubeMask=cubeMask,obj.SDate=sdate,obj.PartIndex=$i(^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask)),obj.RowNum=0
		  d obj.%Save()
		}
		q obj
	  }
    }else{
	  s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate,""))
	  if '$d(^DHCWL.DM.T.CubeDSPartD(id)){
		s obj=##class(CubeDSPart).%New()
		s obj.CubeMask=cubeMask,obj.SDate=sdate,obj.PartIndex=$i(^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask)),obj.RowNum=0
		d obj.%Save()
	  }else{
		s obj=##class(CubeDSPart).%OpenId(id)
	  }
	  q obj
    }
}

// s list=##class(DHCWL.DM.T.CubeDSPart).Get(3,63632)

ClassMethod Get(cubeMask, sdate As %Integer = 0) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	if sdate=0{
	  s matched="",nextDate=1
	  s date="" f{
	    s date=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,date))
	    q:date=""
	    s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,date,""))
	    continue:'$d(^DHCWL.DM.T.CubeDSPartD(id))
	    s obj=##class(CubeDSPart).%OpenId(id)
	    d list.Insert(obj)
	  }
	  q list
	}
	if '$d(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate)){
	  s psd=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate),-1)
	  if psd="" {
	    
	  }else{
		s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,psd,""))
		if '$d(^DHCWL.DM.T.CubeDSPartD(id)){
		 
		}else{
		  s obj=##class(CubeDSPart).%OpenId(id)
		  d list.Insert(obj)
		}
	  }
    }else{
	  s id=$o(^DHCWL.DM.T.CubeDSPartI("MainI",cubeMask,sdate,""))
	  if '$d(^DHCWL.DM.T.CubeDSPartD(id)){
		
	  }else{
		s obj=##class(CubeDSPart).%OpenId(id)
		d list.Insert(obj)
	  }
    }
    q list
}

ClassMethod Delete(cubeMask As %String, partInd As %String)
{
	&sql(DELETE DHCWL_DM_T.CubeDSPart where CubeMask=:cubeMask AND PartIndex=:partInd)
}

ClassMethod Clear(cubeMask As %String)
{
	k ^DHCWL.DM.T.CubeDSPartI("CUBESDSN",cubeMask)
}

Method Increment()
{
  s ..RowNum=..RowNum+1
  d ..%Save()
}

Storage Default
{
<Data name="CubeDSPartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeMask</Value>
</Value>
<Value name="3">
<Value>SDate</Value>
</Value>
<Value name="4">
<Value>PartIndex</Value>
</Value>
<Value name="5">
<Value>RowNum</Value>
</Value>
<Value name="6">
<Value>HasNext</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDSPartD</DataLocation>
<DefaultData>CubeDSPartDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDSPartD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDSPartI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDSPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
