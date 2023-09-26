/// Created by lihaihong@20170611
/// Cube数据以整天数为批量数据作为策略的分区配置表
/// 批量标志：CubeDStruct##MAXBITRANGE\3
/// 删除造成的空缺后续插入要填补上
/// d ##class(DHCWL.DM.T.CubeDBDPPart).%BuildIndices()
Class DHCWL.DM.T.CubeDBDPPart Extends %Persistent
{

// 262104

Parameter MAXBITRANGE = 262104;

/// 临界点大小，超过后循环写入下个分区  MAXBITRANGE/4 = 65526
Parameter NEARPOINT = 65526;

/// 一个分区上最大ID数，超过后自动分配新的分区  MAXBITRANGE * 3
Parameter MAXIDINONEPART = 786312;

Property CubeMask As %String [ Required, SqlColumnNumber = 2 ];

// 分区号，系统自动计算的

Property Part As %Integer [ Required, SqlColumnNumber = 3 ];

// 临界点分区个数

Property NPCount As %Integer [ Required, SqlColumnNumber = 4 ];

// 该分区总共分配的ID个数

Property PartTotalSize As %Integer [ Required, SqlColumnNumber = 5 ];

// 最近使用的分区以分配的ID个数

Property CurNearPointSize As %Integer [ Required, SqlColumnNumber = 6 ];

// 在该分区上删除的ID个数

Property DeleteCount As %Integer [ Required, SqlColumnNumber = 7 ];

// 统计日期索引字段

Property StatisticDate As %String [ SqlColumnNumber = 8 ];

Index MainI On (CubeMask As EXACT, Part);

// Index SDI On (CubeMask As EXACT, StatisticDate As EXACT, Part);

Trigger BefDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n part,cubeMask
	s cubeMask={CubeMask}
	s part={Part}
	s sd="" f{
		s sd=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part,sd))
		q:sd=""
		k ^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sd,part)
	}
	k ^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    s id=oid
    if $d(^DHCWL.DM.T.CubeDBDPPartD(id)){
	    s cubeMask=$lg(^DHCWL.DM.T.CubeDBDPPartD(id),2),part=$lg(^DHCWL.DM.T.CubeDBDPPartD(id),3)
	    if (cubeMask'="") && (part'=""){
		    s sd="" f{
					s sd=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part,sd))
					q:sd=""
					k ^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sd,part)
				}
				k ^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part)
	    }
    }
}

// d ##class(DHCWL.DM.T.CubeDBDPPart).TestData()

/// 索引 SDI 在程序代码中附加，完成，不是真正的索引
ClassMethod TestData()
{
	k ^DHCWL.DM.T.CubeDCDIDLogI
	k ^DHCWL.DM.T.CubeDStructD,^DHCWL.DM.T.CubeDStructI
	k ^DHCWL.DM.T.CubeDStructM,^DHCWL.DM.T.CubeDStructR,^DHCWL.DM.T.CubeDStructIR
	;&sql(update DHCWL_DM_T.CubeDBDPPart set CurNearPointSize=0,DeleteCount=0,PartTotalSize=0,NPCount=0)
	&sql(delete DHCWL_DM_T.CubeDBDPPart )
	k ^DHCWL.DM.T.CubeDBDPPartI,^DHCWL.DM.T.CubeDBDPPartD
	q
	//s part=##class(DHCWL.DM.T.CubeDBDPPart).AddPart(4)
	//s part=##class(DHCWL.DM.T.CubeDBDPPart).AddPart(4)
	//d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload.t")
	//d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload.t")
	d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload4.t")
	d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload4.t")
	d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload4.t")
	d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload4.t")
	
	//d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/workloadall.t")
    //d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/workloadall.t")
}

ClassMethod GetPart(cubeMask, partIndex As %Integer) As CubeDBDPPart
{
	if $d(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,partIndex)){
	  s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,partIndex,""))
	  q ##class(CubeDBDPPart).%OpenId(id)	
	}
	q ""
}

ClassMethod ChoicePart(cubeMask, sheduleDate = "") As CubeDBDPPart
{
	k map
	s:sheduleDate="" sheduleDate=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,""))
	if sheduleDate=""{
		s part="" f {
		  s part=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part))
		  q:part=""
		  s id="" f{
				s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part,id))
				q:((id="")||('$d(^DHCWL.DM.T.CubeDBDPPartD(id))))
				s lst=^DHCWL.DM.T.CubeDBDPPartD(id)
				s npc=$lg(lst,4,0) //NPCount
				s dc=$lg(lst,7,0) //DeleteCount
				s map(1,part,npc)=""
				s map(2,npc,part)=""
				s map(3,dc,part)=""
		  }
		}
	}else{
		s part="" f {
		  s part=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sheduleDate,part))
		  q:part=""
		  s id="" f{
				s id=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sheduleDate,part,id))
				q:((id="")||('$d(^DHCWL.DM.T.CubeDBDPPartD(id))))
				s lst=^DHCWL.DM.T.CubeDBDPPartD(id)
				s npc=$lg(lst,4,0) //NPCount
				s dc=$lg(lst,7,0) //DeleteCount
				s map(1,part,npc)=""
				s map(2,npc,part)=""
				s map(3,dc,part)=""
		  }
		}
	}
	
	s maxdc=$o(map(3,""),-1)
	if maxdc>= ..#NEARPOINT{ //首先要利用删除的空隙
	  s part=$o(map(3,maxdc,""))
	}else{
	  s npc=$o(map(2,""))
	  s part=$o(map(2,npc,""))
	}
	if sheduleDate=""{
		s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part,""))
	}else{
		s id=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sheduleDate,part,""))
	}
	
	s obj=##class(CubeDBDPPart).%OpenId(id)
	if obj.PartTotalSize>=..#MAXIDINONEPART{
		s obj=""
		s obj=..AddPart(cubeMask)
	}
	s obj.StatisticDate=sheduleDate
	q obj
}

// d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/Workload.t")

ClassMethod AddThemePart(themePath)
{
    s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  d ..AddPart(cubeMask)
	}
}

// s part=##class(DHCWL.DM.T.CubeDBDPPart).AddPart("1")

ClassMethod AddPart(cubeMask) As CubeDBDPPart
{
	s curMax=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,""),-1)
	s curMax=curMax+1
	s obj=##class(CubeDBDPPart).%New()
	s obj.CubeMask=cubeMask
	s obj.Part=curMax
	s obj.NPCount=0
	s obj.PartTotalSize=0
	s obj.CurNearPointSize=0
	s obj.DeleteCount=0
	q:obj.%Save()'=$$$OK ""
	q obj
}

ClassMethod GetPartitions(cubeMask, statisticDate = "") As %List
{
  s parts=$lb(),i=0
  if (statisticDate="")||('$d(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,statisticDate))){
	  s part="" f{
			s part=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part))
			q:part=""
			s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part,""))
			continue:'$d(^DHCWL.DM.T.CubeDBDPPartD(id))
			s i=i+1
			s $list(parts,i)=part
	  }
  }else{
	  s part="" f{
			s part=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,statisticDate,part))
			q:part=""
			s id=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,statisticDate,part,""))
			continue:'$d(^DHCWL.DM.T.CubeDBDPPartD(id))
			s i=i+1
			s $list(parts,i)=part
	  }
  }
  
  q parts
}

ClassMethod GetPartitionNums(cubeMask) As %Integer
{
  s i=0
  s part="" f{
		s part=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part))
		q:part=""
		s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part,""))
		continue:'$d(^DHCWL.DM.T.CubeDBDPPartD(id))
		s i=i+1
  }
  q i
}

ClassMethod Reset(cubeMask, part) As %Status
{
	s id=$o(^DHCWL.DM.T.CubeDBDPPartI("MainI",cubeMask,part,""))
	s obj=##class(CubeDBDPPart).%OpenId(id)
	if obj'=""{
		s obj.NPCount=0
		s obj.PartTotalSize=0
		s obj.CurNearPointSize=0
		s obj.DeleteCount=0
		s sd="" f{
			s sd=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part,sd))
			q:sd=""
			k ^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sd,part)
		}
		
		k ^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part)
		q obj.%Save()
	}
	q $$$OK
}

ClassMethod Clear(cubeMask, part)
{
	&sql(DELETE DHCWL_DM_T.CubeDBDPPart WHERE CubeMask=:cubeMask AND Part=:part)
	s sd="" f{
		s sd=$o(^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part,sd))
		q:sd=""
		k ^DHCWL.DM.T.CubeDBDPPartI("SDI",cubeMask,sd,part)
	}
	k ^DHCWL.DM.T.CubeDBDPPartI("SDI2",cubeMask,part)
}

Method GetId() As %Integer
{
  s id=##class(CubeDCDIDLog).ReuseID(..CubeMask,..Part)
  if +id>0{
		s ..DeleteCount=..DeleteCount-1
    q id
  }
  s id=$i(^DHCWL.DM.T.CubeDStructD(..Part,..CubeMask))
  s ..CurNearPointSize=..CurNearPointSize+1
  s ..PartTotalSize=..PartTotalSize+1
  q id
}

Method DeleteId()
{
  s ..DeleteCount=..DeleteCount+1
}

Method Commit() As %Status
{
	if ..CurNearPointSize>..#NEARPOINT{
	  s ..NPCount=..NPCount+1
	  s ..CurNearPointSize=0
	}
	s sd=..StatisticDate
	s:sd="" sd=$c(0)
	s st=..%Save()
	s ^DHCWL.DM.T.CubeDBDPPartI("SDI",..CubeMask,sd,..Part,..%Id())=""
	s ^DHCWL.DM.T.CubeDBDPPartI("SDI2",..CubeMask,..Part,sd,..%Id())=""
	q st
}

Method GetPartition() As %Integer [ CodeMode = expression ]
{
..Part
}

Storage Default
{
<Data name="CubeDBDPPartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeMask</Value>
</Value>
<Value name="3">
<Value>Part</Value>
</Value>
<Value name="4">
<Value>NPCount</Value>
</Value>
<Value name="5">
<Value>PartTotalSize</Value>
</Value>
<Value name="6">
<Value>CurNearPointSize</Value>
</Value>
<Value name="7">
<Value>DeleteCount</Value>
</Value>
<Value name="8">
<Value>StatisticDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDBDPPartD</DataLocation>
<DefaultData>CubeDBDPPartDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDBDPPartD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDBDPPartI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDBDPPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
