/// Created by lihaihong@20170611
/// 该表配合CubeDBDPPart使用，记录Cube数据生成日期下的ID，以备后续数据管理使用
/// 生成数据全部保存在^DHCWL.DM.T.CubeDCDIDLogI(0,CubeMask As EXACT, LogDate, Part, ID,MetricVID)
/// 删除数据保存在：^DHCWL.DM.T.CubeDCDIDLogI(1,CubeMask As EXACT,Par, ID)
Class DHCWL.DM.T.CubeDCDIDLog Extends %Persistent
{

// Property ActionType As %String(DISPLAYLIST = ",C,D", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",C,D") [ Required ];

// Property CubeMask As %String [ Private, Required ];

// Property LogDate As %Integer [ Required ];

// Property Part As %String [ Required ];

// Property ID As %Integer [ Required ];

// Property MetricVID As %Integer[Required];

ClassMethod Exist(cubeMask, date As %Integer) As %Boolean
{
  q $d(^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date))'=0
}

ClassMethod Exist2(cubeMask, date As %Integer) As %Boolean
{
  q $d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date))'=0
}

ClassMethod Create(date As %Integer, cubeMask, part As %Integer, id As %Integer, metricsn As %Integer, msegid As %Integer, mvid As %Integer)
{
  s ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn,msegid,mvid)=""
}

ClassMethod Insert(date As %Integer, cubeMask, part As %Integer, id As %Integer)
{
	s ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date,part,id)=""
}

ClassMethod DeleteRow(date As %Integer, cubeMask, part As %Integer, id As %Integer)
{
	s ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part,id)=""
	k ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date,part,id)
	if '$d(^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date,part)){
		k ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date,part)
		if '$d(^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date)){
			k ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date)
			if '$d(^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask)){
				k ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask)
			}	
		}	
	}
}

ClassMethod GetPart(date As %Integer, cubeMask)
{
	q $o(^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask,date,""))
}

ClassMethod Delete(isDeleteId As %Boolean, date As %Integer, cubeMask, part As %Integer, id As %Integer, metricsn As %Integer, msegid As %Integer, mvid As %Integer)
{
  if (isDeleteId'=0){
    s ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part,id)=""
    q
  }
  i $d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn,msegid,mvid)) {
	k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn,msegid,mvid)
	i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn,msegid)){
	  k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn,msegid)
	  i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn)){
		k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,metricsn)
		i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id)){
	      k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id)
	      i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part)){
		    k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part)
		    i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date)){
			  k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date)
			  i '$d(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask)){
				k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask)
			  }
		    }
	      }
		}
	  }
	}
  }
}

/// 使用者不要直接调用该方法，由CubeDBDPPart.GetId负责调用
ClassMethod ReuseID(cubeMask, part As %Integer) As %Integer
{
  s id=0
  if $d(^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part)){
    s id= $o(^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part,""))
    i id'="" {
	  k ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part,id)
	  i '$d(^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part)){
		k ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask,part)
		i '$d(^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask)){
	      k ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask)
		}
	  }
    }
  }
  q +id
}

ClassMethod GetCanDeleteInfo(date As %Integer, cubeMask)
{
  k ^tmp($j,"WLDM")
  m ^tmp($j,"WLDM")=^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date)
  q
  s part="" f{
    s part=$o(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part))
    q:part=""
    s id="" f{
	  s id=$o(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id))
	  q:id=""
	  s msn="" f
	    s msn=$o(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,msn))
	    q:msn=""
	    s mseg="" f{
		  s mseg=$o(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,msn,mseg))
		  q:mseg=""
		  s mvid="" f{
		    s mvid=$o(^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask,date,part,id,msn,mseg,mvid))
		    q:mvid=""
		    s ^tmp($j,"WLDM",part,id,msn,mseg,mvid)=""
		  }
	    }
    }
  }
}

Storage Default
{
<Data name="CubeDCDIDLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionType</Value>
</Value>
<Value name="3">
<Value>CubeMask</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>Part</Value>
</Value>
<Value name="6">
<Value>ID</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDCDIDLogD</DataLocation>
<DefaultData>CubeDCDIDLogDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDCDIDLogD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDCDIDLogI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDCDIDLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
