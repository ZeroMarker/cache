///   ^DHCWL.DM.T.DimDStructD(dimbaseId)=maxIdCount
///   ^DHCWL.DM.T.DimDStructD(dimbaseId,dimRowKey)=dimRowList
///   ^DHCWL.DM.T.DimDStructI(0,dimRowKey)=id
///   ^DHCWL.DM.T.DimDStructI(1,id)=dimRowKey
Class DHCWL.DM.T.DimDStruct Extends %Persistent
{

Parameter STRUCTLISTUNIT = 4;

Parameter STRUCTLISTUNIT2 = 5;

// d ##class(DHCWL.DM.T.DimDStruct).Upsert("1",$lb(1,2,3,4,5,6,7,8,9),$lb("1"),$lb("1","产科","CK-产科","ck",2,2, , ,"E"))

ClassMethod Upsert(dimBaseId, posProList As %List, rowKey As %List, list As %List) As %Status
{
	b ;1
	s rowKey=$lts(rowKey,"||")
	s uslist=$lb(dimBaseId,,,rowKey)
	s len=$listlength(posProList)
	s status=$$$OK
	i '$d(^DHCWL.DM.T.DimDStructD(dimBaseId)) s ^DHCWL.DM.T.DimDStructD(dimBaseId)=""

	i '$d(^DHCWL.DM.T.DimDStructD(dimBaseId,rowKey))  d
	.s rowkeyId=$i(^DHCWL.DM.T.DimDStructD(dimBaseId))
	.s ^DHCWL.DM.T.DimDStructD(dimBaseId,rowKey)=list
	.s status=$$InsertBuildIndex(list)
	.s ^DHCWL.DM.T.DimDStructI(dimBaseId,0,rowKey)=rowkeyId
	.s ^DHCWL.DM.T.DimDStructI(dimBaseId,1,rowkeyId)=rowKey
	.;d ##class(DimDataLog).Add(id,"U",st)
	e  d
	.s olist=^DHCWL.DM.T.DimDStructD(dimBaseId,rowKey)
	.s updateFlag=0
	.f i=1:1:len d
	..s proId=$lg(list,i,"")
	..q:((proId="") || (proId=$c(0)))
	..i ( ($lg(olist,i,"")'=$lg(list,i,"")) ) d
	...s updateFlag=1
	...s $list(uslist,2)=$lg(posProList,i)
	...s $list(uslist,3)=$lg(list,i)
	...s status= ##class(DimDataIndex).UpdateBuildIndex(uslist,$lg(olist,i,""))
	.s:updateFlag=1 ^DHCWL.DM.T.DimDStructD(dimBaseId,rowKey)=list
	.;d BuildIndex(olist)
	.;d ##class(DimDataLog).Add(id,"D",st)
	
	q status
	
InsertBuildIndex(ilist)
	f i=1:1:len d
	.s proId=$lg(posProList,i,"")
	.q:((proId="") || (proId=$c(0)))
	.s $list(uslist,2)=proId
	.s $list(uslist,3)=$lg(ilist,i)
	.i $lg(ilist,i,"")'="" d
	..s status= ##class(DimDataIndex).InsertBuildIndex(uslist)
	q status
}

ClassMethod GetRowKeyId(dimId, rowKey) As %Integer [ CodeMode = expression ]
{
$g(^DHCWL.DM.T.DimDStructI(dimId,0,rowKey),0)
}

ClassMethod GetRowKey(dimId, id) As %String [ CodeMode = expression ]
{
$g(^DHCWL.DM.T.DimDStructI(dimId,1,id),0)
}

// d ##class(DHCWL.DM.T.DimDStruct).Test()

ClassMethod Test()
{
	k ^lhh
	s dimBase=##class(DimBase).GetByPath("/CT_DIMDAY.d")
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("2020-12-30"))
	d stream.WriteLine($lb("2020-12-30","2020年12月30日"))
	d stream.WriteLine($lb("2020-12-31"))
	d stream.WriteLine($lb("2020-12-31","2020年12月31日"))
	d stream.%Save()
	d ..UpsertByStream(stream,dimBase.%Id())
	;d stream.Clear()
	s stream=""
	zw ^lhh(2)
}

ClassMethod UpsertByStream(stream As %Stream.GlobalBinary, dimBaseId, posProList As %List) As %Status
{
	s status=$$$OK
	i '$d(^DHCWL.DM.T.DimDStructD(dimBaseId)) s ^DHCWL.DM.T.DimDStructD(dimBaseId)=""
	s proStruct=##class(DimDStructMap).GetDimProStruct2(dimBaseId)
	s keyStruct=##class(DimDStructMap).GetKeyStruct(dimBaseId)
	s psLen=$ll(proStruct)
	s:psLen=1 psLen=0
	s ksLen=$ll(keyStruct)
	s:ksLen=1 ksLen=0
	k proFunCallMap
	;s proMFunList=##class(%ListOfObjects).%New()
	k proMFunList
	f i=1:..#STRUCTLISTUNIT2:psLen {
	  s dimProId=+$lg(proStruct,i)
	  s proFunCallMap(1,dimProId)=$lg(proStruct,i+3)
	  s proFunCallMap(2,$lg(proStruct,i+1))=dimProId
	  if $lg(proStruct,i+2)="DIM:STCPROFUN"{
			s proFunCallMap(3,dimProId)=""
			//TODO
			s dimProObj=##class(DimProperty).%OpenId(dimProId)
			s proFunCall=##class(DHCWL.DM.Util.FunctionCall).%New("STICDIMPRO:"_dimProObj.Expression)
			;d proMFunList.InsertAt(proFun,dimProId)
			s proFun=proFunCall.FunctionConfig
			s proMFunList(dimProId)=proFunCall
			s funParams=dimProObj.GetUsingParameters(proFun)  ;proFun.Parameters()
			s funParamLen=funParams.Count()
			f j=1:1:funParamLen{
			  s funParam=funParams.GetAt(j)
			  if funParam.ParamType.Code="EVALPASSBYVAR"{
				s proFunCallMap(3,dimProId,"EPSN",j)=proFunCallMap(1,proFunCallMap(2,funParam.Name)) ;eval param sn
			  }
			}
	  }
	}
	d stream.Rewind()
	while('stream.AtEnd){
    s key=stream.ReadLine()
	  s row=stream.ReadLine()
	  if (($lv(key))&&($lv(row))){
			/*w "rowKey="
			f i=1:1:$ll(key){
			  w:i>1 ","
			  w $lg(key,i,"")
			}
			w !,"row="
			f i=1:1:$ll(row){
			  w:i>1 ","
			  w $lg(row,i,"")
			}
			w !
			continue*/
			f i=1:..#STRUCTLISTUNIT2:ksLen {
				s dt=+$lg(keyStruct,i+4)
				s dp=$lg(keyStruct,i+3)
				if dt=91{
					s $list(key,dp)=##class(DHCWL.DM.T.CubeDStruct).FormatDateToCache($lg(key,dp))
				}
				
			}
			f i=1:..#STRUCTLISTUNIT2:psLen {
				s dt=+$lg(proStruct,i+4)
				s dp=$lg(proStruct,i+3)
				if dt=91{
					;w $lg(row,dp),":"
					s $list(row,dp)=##class(DHCWL.DM.T.CubeDStruct).FormatDateToCache($lg(row,dp))
					;w $lg(row,dp),!
				}
			}
			s keyStr=$lts(key,"||")
			s proFunId="" f{
			  s proFunId=$o(proFunCallMap(3,proFunId))
			  q:proFunId=""
			  s proFun=proMFunList(proFunId) ;proMFunList.GetAt(proFunId)
			  s proFunParams=""
			  if $d(proFunCallMap(3,proFunId,"EPSN")){
					s proFunParams=$lb()
					s evalParaIndex="" f{
					  s evalParaIndex=$o(proFunCallMap(3,proFunId,"EPSN",evalParaIndex))
					  q:evalParaIndex=""
					  s evalProSn=proFunCallMap(3,proFunId,"EPSN",evalParaIndex)
					  s $list(proFunParams,evalParaIndex)=$lg(row,evalProSn)
					}
			  }
			  s proFunV=proFun.Call(proFunParams)
			  s $list(row,proFunCallMap(1,proFunId))=proFunV
			}
			/*i '$d(^DHCWL.DM.T.DimDStructD(dimBaseId,keyStr)) {
		      s rowId=$i(^DHCWL.DM.T.DimDStructD(dimBaseId))
		      s ^DHCWL.DM.T.DimDStructD(dimBaseId,keyStr)=row
		      s status=$$InsertBuildIndex2(row)
			}*/
			d ..Upsert(dimBaseId,posProList,key,row)
	  }else{
		  
	  }
	}
	d stream.Clear()
	q status
}

// d ##class(DHCWL.DM.T.DimDStruct).Delete("/Department.d")

// d ##class(DHCWL.DM.T.DimDStruct).Delete("/Hospital.d")

// d ##class(DHCWL.DM.T.DimDStruct).Delete("/CT_ChargeItem.d")

// d ##class(DHCWL.DM.T.DimDStruct).Delete("/CT_DIMDAY.d")

ClassMethod Delete(dimPath) As %Status
{
	s id=##Class(DimBase).GetIdByPath(dimPath)
	s rowKey="" f  s rowKey=$o( ^DHCWL.DM.T.DimDStructD(id,rowKey) ) q:rowKey=""  d
	.k ^DHCWL.DM.T.DimDStructD(id,rowKey)
	k ^DHCWL.DM.T.DimDStructI(id)
	k ^DHCWL.DM.T.DimDStructD(id)
	s st= ##class(DimDataIndex).DeleteDimIndex(id)
	;d ##class(DimDataLog).Add(id,"D",st)
	q st
}

ClassMethod GetValue(rowId, structList As %List, dimIndex, ByRef structMap, type = "D") As %String
{
	s len=$ll(structList)
	s dr=rowId
	if type="D"{
	  f i=5:4:len {
	    s fdid=$lg(structList,i)
	    i i=5 s fdid=$lg(structList,i-3)
	    s proSn=$lg(structList,i+2)
	    s proType=$lg(structList,i+3)
	    if proType [ "#"{
		  ;b ;proType [ "#"
		  s proIndex=i\4
		  if (i#4>0) s proIndex=proIndex+1
		  s dr=..ResolveProFun(rowId,dimIndex,proIndex,.structMap,type)
	    }else{
	      i $d(^DHCWL.DM.T.DimDStructD(fdid,dr)) {
	        s dr=$lg(^DHCWL.DM.T.DimDStructD(fdid,dr),proSn)
	      }else{
	        s dr="NULL" ;"No dim data with("_fdid_","_dr_")"
	        s i=len+1
	      } 
	    }
	  }
	}elseif type="DQ"{
	  f i=1:4:len {
	    s fdid=$lg(structList,i)
	    s proSn=$lg(structList,i+2)
	    s proType=$lg(structList,i+3)
	    if proType [ "#"{
		  ;b ;proType [ "#"
		  s proIndex=i\4
		  if (i#4>0) s proIndex=proIndex+1
		  s dr=..ResolveProFun(rowId,dimIndex,proIndex,.structMap,type)
	    }else{
	      i $d(^DHCWL.DM.T.DimDStructD(fdid,dr)) {
	        s dr=$lg(^DHCWL.DM.T.DimDStructD(fdid,dr),proSn)
	      }else{
	        s dr="NULL" ;"No dim data with("_fdid_","_dr_")"
	        s i=len+1
	      } 
	    }
	  }
	}
	
	q $g(dr,"NULL")
}

ClassMethod ResolveProFun(rowId, dimIndex, proIndex, ByRef structMap, type = "D") As %String
{
	s funCall=structMap(type,dimIndex,proIndex,"F")
	s paramsV=structMap(type,dimIndex,proIndex,"P")
	s dimId=structMap(type,dimIndex,proIndex,"D")
	s dimRow=$g(^DHCWL.DM.T.DimDStructD(dimId,rowId),$lb())
	s parInd="" f{
	  s parInd=$o(structMap(type,dimIndex,proIndex,"DP",parInd))
	  q:parInd=""
	  s psn=structMap(type,dimIndex,proIndex,"DP",parInd)
	  s $list(paramsV,parInd)=$lg(dimRow,psn,$c(0))
	}
	s parInd="" f{
	  s parInd=$o(structMap(type,dimIndex,proIndex,"SP",parInd))
	  q:parInd=""
	  s $list(paramsV,parInd)=rowId
	}
	q funCall.Call(paramsV)
}

// 根据已有维度的ID反推最终被引用维度的ID

ClassMethod BacksteppingId(idList As %List, structList As %List, ByRef proFunStruct, proFunStruIndex, type, isDim As %Boolean = 0) As %List
{
	b ;1
	k map
	s len=$ll(idList),len2=$ll(structList)-(4*1)+1
	if isDim{
	  s len2=$ll(structList)-(4*1)+1
	}
	q:len2<0 idList
	s resultList=$lb()
	//f i=1:1:len {
	  //s id=$lg(idList,i)
	  f j=len2:-4:4 {
	  //f j=$ll(structList):-4:1 {
	    d ..OneBacksteppingId(idList,structList,j,.map,.proFunStruct,proFunStruIndex,type)
	  }
	//}
	s id="",i=1 f{
	  s id=$o(map(id))
	  q:id=""
	  s $list(resultList,i)=id
	  s i=i+1
	}
	q resultList
}

ClassMethod OneBacksteppingId(idList As %List, structList As %List, ind, ByRef backedIdMap, ByRef proFunStruct, proFunStruIndex, type) [ Private ]
{
	s len=$ll(idList),listInd=1
	s proIndex=ind\4
	if (ind # 4)>0 s proIndex=proIndex+1
	f i=1:1:len {
	  s id=$lg(idList,i)
	  continue:id=""
	  s refDimId=$lg(structList,ind)
	  s refProId=$lg(structList,ind+1)
	  s dtype=$lg(structList,ind+3)
	  if dtype [ "#"{
		//TODO 暂不支持过滤表达式中维度属性中间使用属性方法的用法
	    /*s ssid="" f{
		  s ssid=$o(^DHCWL.DM.T.DimDStructD(refDimId,ssid))
		  q:ssid=""
		  s v= ##class(DimDStruct).ResolveProFun(ssid,proFunStruIndex,proIndex,.proFunStruct,type)
	    }*/
	  }else{
	    continue:'$d(^DHCWL.DM.T.DimDataIndexI("MainI",refDimId,refProId,id))
	    s ddid="" f  {
	      s ddid=$o(^DHCWL.DM.T.DimDataIndexI("MainI",refDimId,refProId,id,ddid))
	      q:ddid=""
	      continue:'$d(^DHCWL.DM.T.DimDataIndexD(ddid))
	      s bid=$lg(^DHCWL.DM.T.DimDataIndexD(ddid),5)
	      continue:bid=""
	      s backedIdMap(bid)=""
	    } 
	  }
	  
	}
}

Storage Default
{
<Data name="DimDStructDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimDStructD</DataLocation>
<DefaultData>DimDStructDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimDStructD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimDStructI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimDStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
