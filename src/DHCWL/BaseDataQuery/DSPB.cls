Class DHCWL.BaseDataQuery.DSPB Extends DHCWL.BaseDataQuery.DS
{

/// 路径，用于获取主题对象
Property themePath As %String(COLLATION = "EXACT", MAXLEN = 150);

Property executor As %ObjectHandle;

Property parser As %ObjectHandle;

Property it As DHCWL.DM.Core.Iterator;

Property columnHeader As %Library.ListOfDataTypes;

Property col2ItemMap As %Library.ArrayOfDataTypes;

Property dimItemPosFromDS2Rpt As %Library.ArrayOfDataTypes;

Property metricsItemPosFromDS2Rpt As %Library.ArrayOfDataTypes;

/// 得到所有维度
Method GetDims() As %ListOfObjects
{
	
	s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(..themePath)
	//维度数据
	s lstFields=themeObj.GetDims()
	q lstFields
}

/// 得到所有度量
Method GetMetrics() As %ListOfObjects
{
	s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(..themePath)
	//度量数据
	s lstFields=themeObj.GetMetrics()
	q lstFields
}

Method GetPropertys(dimCode As %String) As %ListOfObjects
{
	//q ##class(QryItem).GetItems(..%Id(),fieldCode)
	s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(..themePath)
	//主题维度
	s themeDims=themeObj.GetDim(dimCode)
	//基础维度
	s dimBaseObj=themeDims.GetLinkDim()
	if '$ISOBJECT(dimBaseObj) q ##class(%ListOfObjects).%New()
	//基础维度属性
	s lstPro=dimBaseObj.GetProperties()
	if 0 {
		q lstPro
	}else{ //add by wz 2018-09
		s list=##class(%ListOfObjects).%New()
		
		s lstCnt=lstPro.Count()
		f inx=1:1:lstCnt {
			s dimProObj=lstPro.GetAt(inx)

			s udtObj=##class(DHCWL.BaseDataQuery.UtilDTServ).%New()
			d udtObj.SetValue("Name",dimProObj.Name)
			d udtObj.SetValue("Code",dimProObj.Code)
			d udtObj.SetValue("ID",dimProObj.%Id())
			
			d list.Insert(udtObj)			
		}
		q list
		
	}
}

/// 根据描述返回数据类型的ID
Method GetDataTypeCodeByDesc(desc As %String) As %String
{
	if desc="Date" q 91
}

/// ////////////////////////////////////////////////////////////////////
/// / 统计接口
/// //////////////////////////////////////
Method QryPrepare(ByRef aryCfgData) As %Status
{
	
	
	//d ..GetHeader(.aryCfgData)
	d ..MapItemPosFromDS2Rpt(.aryCfgData)
	s PCSortStr=..GetPCSortTxtStr(.aryCfgData)		//sort
	s PCFormStr=..GetPCFormStr(.aryCfgData)			//得到cql中的from
	s PCDimsStr=..GetPCDimsStr(.aryCfgData)			//dims
	s PCMetricsStr=..GetPCMetricsStr(.aryCfgData)	//metrics
	s PCFilterStr=..GetPCFilterStr(.aryCfgData)		//filter
	//s PCSortStr=..GetPCSortTxtStr(.aryCfgData)		//sort
	d ..LoadCellFormat(.aryCfgData)					//报表显示格式
		
	s cql="rs1:{"_
            "from: "_PCFormStr_","_
            "dims : "_PCDimsStr_","_ //
            "metrics: "_PCMetricsStr_","_
            "filter: "_PCFilterStr_"," 
            _"sort:"_PCSortStr_","_
            "print:true,"_
            "};"
    
	
    //w !,cql
	s ..parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s sc=..parser.Parse(cql)
	q sc
}

Method QryExecute(ByRef aryCfgData) As %Status
{
	s ..executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(..parser)
	s sc=..executor.Execute()
	
	If $$$ISERR(sc) {
		q sc
	}	
	s ..it=..executor.GetIterator("rs1")
	q $$$OK
}

Method QryGetColumnCount() As %Integer
{
	q ..columnHeader.Count()
}

Method QryNext() As %Integer
{
	k ^||TEMPDHCWLDSPB
	s ret=..it.HasNext()
	/*
	if ret=1 {
		//s dims=$lts(..it.CurDims(),"^")
		s ^||TEMPDHCWLDSPB("dims")=..it.CurDims()
		//s dimsCnt=$l(dims,"^")
		s metrics=$lts(..it.CurMetrics(),"^")
		s ^||TEMPDHCWLDSPB("metrics")=..it.CurMetrics()
		//s cnt=$l(metrics,"^")
		
	}
	*/
	q ret
}

Method QryGetColumnHeader(n As %Integer) As %String
{
	q ..columnHeader.GetAt(n)
}

Method QryGetAt(n As %Integer) As %String
{
	s type=$p(..col2ItemMap.GetAt(n),"^",1)
	s inx=$p(..col2ItemMap.GetAt(n),"^",2)
	q $LG(^||TEMPDHCWLDSPB(type),inx)
	
	/*
		s ^TEMPDHCWLDSPB("dims")=dims
		s ^TEMPDHCWLDSPB("metrics")=metrics
	
		if aryCfgData("qryItemcfg","Code",code,"Type")="维度" {
			d col2ItemMap.SetAt("dim^"_dimInx,columnHeader.Count())
			s dimInx=dimInx+1
		}elseif aryCfgData("qryItemcfg","Code",code,"Type")="度量" {
			d col2ItemMap.SetAt("metrics^"_metricsInx,columnHeader.Count())
			s metricsInx=metricsInx+1			
		}
		*/
}

// 

/// /////////////////////////////////////////////////////////////////////
Method GetPCFormStr(ByRef aryCfgData) As %String
{
	q ..themePath
}

/*
	s aryCfgData("rptcfg","Name")=rptName		//主题路径
	s aryCfgData("rptcfg","Code")=rptCode		//主题路径
	s aryCfgData("rptcfg","dateItemID")=dateItemID
	s aryCfgData("qrycfg","ID")=qryID	//查询对象名称
	s aryCfgData("DScfg","ID")=DSID			//报表类型
	
	///报表对象ITEM
	s aryCfgData("rptItemcfg","order",i,"Name")=name
	s aryCfgData("rptItemcfg","order",i,"Code")=code
	s aryCfgData("rptItemcfg","order",i,"Type")=type
	s aryCfgData("rptItemcfg","order",i,"Exp")=exp
	
	///查询对象ITEM
	s aryCfgData("qryItemcfg","Code",code,"Name")=name
	s aryCfgData("qryItemcfg","Code",code,"Type")=type
	s aryCfgData("qryItemcfg","Code",code,"Exp")=Exp
	s aryCfgData("qryItemcfg","Code",code,"CreateType")=createType
	s aryCfgData("qryItemcfg","Code",code,"DataType")=dataType	
*/
ClassMethod GetPCDimsStr(ByRef aryCfgData) As %String
{
	s dimStr=""
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		continue:(aryCfgData("rptItemcfg","order",i,"Type")'="col" && (aryCfgData("rptItemcfg","order",i,"Type")'="row") )
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		continue:aryCfgData("qryItemcfg","Code",$p(code,"->"),"Type")'="维度"
		s dimCode=code
		
		if $d(aryCfgData("rptItemcfg","排序编码",code)) s dimCode=code_" "_aryCfgData("rptItemcfg","排序编码",code)
		if aryCfgData("qryItemcfg","Code",$p(code,"->"),"CreateType")="自定义" {
			//自定义维度，暂不支持
			
		}else{
			//系统维度
			if dimStr'="" s dimStr=dimStr_","
			s dimStr=dimStr_dimCode
			
		}
	
	}

	q dimStr
}

ClassMethod GetPCMetricsStr(ByRef aryCfgData) As %String
{
	s metrics=""
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		
		
		s itemType=aryCfgData("rptItemcfg","order",i,"Type")
		continue:(itemType'="col" && (itemType'="cross")) 		
		
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		continue:aryCfgData("qryItemcfg","Code",$p(code,"->"),"Type")'="度量"
		if metrics'="" s metrics=metrics_","

		if aryCfgData("qryItemcfg","Code",code,"CreateType")="自定义" {
			//自定义度量
			//AggFun:sum^SysMetrics:WorkLoad_TotalPrice
			s qryItemExp=aryCfgData("qryItemcfg","Code",code,"Exp")
			s fun=$p($p(qryItemExp,"^",1),":",2)
			s opera=$p($p(qryItemExp,"^",2),":",2)
			s metrics=metrics_fun_"("_opera_") "_code 
		}else{
			//系统度量
			s metrics=metrics_code
		}
	
	}
	q metrics
}

ClassMethod ParseItemExp(exp As %String, ByRef aryExp) As %String
{
			//logical:^Relational:=^V1:I^V2:
	k aryExp
	if exp="" q ""
	s cnt=$l(exp,"^")
	f i=1:1:cnt {
		s k=$p($p(exp,"^",i),":",1)	
		s v=$p($p(exp,"^",i),":",2)
		s aryExp(k)=v	
	}
	q ""
}

ClassMethod GetPCFilterStr(ByRef aryCfgData) As %String
{
	s daterangeStart=aryCfgData("rptcfg","startDate")
	s daterangeEnd=aryCfgData("rptcfg","endDate")
	s filterStr=""
	s dateItemCode=##class(DHCWL.BaseDataQuery.QryItem).%OpenId(aryCfgData("rptcfg","dateItemID")).Code
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		continue:aryCfgData("rptItemcfg","order",i,"Type")'="filter"
		//if filterStr'="" s filterStr=filterStr_","
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		s exp=aryCfgData("rptItemcfg","order",i,"Exp")
		//logical:^Relational:=^V1:I^V2:
		d ..ParseItemExp(exp,.aryExp)
		
		s logical=""
		if aryExp("logical")="AND" {
			s logical="&&"
		}elseif aryExp("logical")="AND (" {
			s logical="&& ("
		}elseif aryExp("logical")="OR" {
			s logical="||"
		}elseif aryExp("logical")="OR (" {
			s logical="|| ("
		}elseif aryExp("logical")="(" {
			s logical="("
		}elseif aryExp("logical")=")" {
			s logical=")"
		}		
		
		if code="" {
			s filterStr=filterStr_logical
		}else{
			if aryExp("Relational")="between" {
				s fStr=	logical_" "_code_" between ( "_aryExp("V1")_","_aryExp("V2")_" )"
			}elseif aryExp("Relational")="in" {
				s fStr=	logical_" "_code_" contain(["_aryExp("V1")_"])"
			}elseif aryExp("Relational")="is null" {
				s fStr=	logical_" "_code_" isnull()"
			}elseif aryExp("Relational")="is not null" {
				s fStr=	logical_" "_code_" notnull()"
			}elseif aryExp("Relational")="<>" {
				s fStr=	logical_" "_code_" NE( "_aryExp("V1")_" )"
			}else{
				s fStr=	logical_" "_code_" "_aryExp("Relational")_" ("_aryExp("V1")_") "
			}			
			s filterStr=filterStr_fStr
		}
	}
	s dateRange=dateItemCode_" DateRange("_daterangeStart_","_daterangeEnd_")" 
	if filterStr="" s filterStr=dateRange
	else  s filterStr=dateRange_" && ("_filterStr_")"
	
	
	//////////////////////////////////////////////////////////////////////
	//查询条件处理
	s queryExp=aryCfgData("rptcfg","queryconf")
	if queryExp'="" {
		s qryCfg=""
		d ..ParseItemExp(queryExp,.aryExp)
		s code=""
		f {
			s code=$o(aryExp(code))
			q:code=""
			continue:aryExp(code)=""
			if qryCfg'="" {
				s qryCfg=qryCfg_" && "_code_" = ("_aryExp(code)_")"
			}else{
				
				s qryCfg=code_" = ("_aryExp(code)_")"
			}
			
		}
		if qryCfg'="" {
			s filterStr=filterStr_" && ("_qryCfg_")"
		} 
	}
	
	
	
	
	
	q filterStr
}

ClassMethod GetPCSortTxtStr(ByRef aryCfgData) As %String
{
	s orderStr=""
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		continue:aryCfgData("rptItemcfg","order",i,"Type")'="order"
		if orderStr'="" s orderStr=orderStr_","
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		s exp=aryCfgData("rptItemcfg","order",i,"Exp")
		//Type:升序
		d ..ParseItemExp(exp,.aryExp)
		
		s orderCode=code
		if code["->" {
			s aryCfgData("rptItemcfg","排序序号")=$g(aryCfgData("rptItemcfg","排序序号"))+1
			s orderCode="myAS"_aryCfgData("rptItemcfg","排序序号")
			s aryCfgData("rptItemcfg","排序编码",code)=orderCode
		}

		if aryExp("Type")="升序" || (aryExp("Type")="")   {
			s orderStr=orderStr_orderCode_" asc "
		}elseif aryExp("Type")="降序" {
			s orderStr=orderStr_orderCode_" desc "
		}
	}
	
	q orderStr
}

Method GetHeader(ByRef aryCfgData)
{
	/*
	s dimInx=1
	s metricsInx=1
	s ..col2ItemMap=##class(%Library.ArrayOfDataTypes).%New()
	s ..columnHeader = ##class(%Library.ListOfDataTypes).%New()
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		continue:aryCfgData("rptItemcfg","order",i,"Type")'="col"
		s name=aryCfgData("rptItemcfg","order",i,"Name")
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		
		if name="" s name=code
		d ..columnHeader.Insert(name)
		
		//  add by wz.2018-09-25
		s code=$p(code,"->")
		if aryCfgData("qryItemcfg","Code",code,"Type")="维度" {
			d ..col2ItemMap.SetAt("dims^"_dimInx,..columnHeader.Count())
			s dimInx=dimInx+1
		}elseif aryCfgData("qryItemcfg","Code",code,"Type")="度量" {
			d ..col2ItemMap.SetAt("metrics^"_metricsInx,..columnHeader.Count())
			s metricsInx=metricsInx+1			
		}
		
	}
	*/
}

Method CheckFilterStr(filterStr As %String) As %String
{
	s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(..themePath)
	S obj=##class(DHCWL.DM.Core.InternalResolvedParser).%New()
	s len=$l(filterStr,$C(2))
	q:len=0 ""
	s fs=""
	f i=1:1:len {
		//if fs'="" s fs=fs_","
		//s code=aryCfgData("rptItemcfg","order",i,"Code")
		s exp=$p(filterStr,$C(2),i)
		//logical:^Relational:=^V1:I^V2:
		d ..ParseItemExp(exp,.aryExp)
		s code=aryExp("Code")
		
		
		s logical=""
		if aryExp("logical")="AND" {
			s logical="&&"
		}elseif aryExp("logical")="AND (" {
			s logical="&& ("
		}elseif aryExp("logical")="OR" {
			s logical="||"
		}elseif aryExp("logical")="OR (" {
			s logical="|| ("
		}elseif aryExp("logical")="(" {
			s logical="("
		}elseif aryExp("logical")=")" {
			s logical=")"
		}		
		
		if code="" {
			s fs=fs_logical
		}else{
			if aryExp("Relational")="between" {
				s fStr=	logical_" "_code_" between ( "_aryExp("V1")_","_aryExp("V2")_" )"
			}elseif aryExp("Relational")="in" {
				s fStr=	logical_" "_code_" contain(["_aryExp("V1")_"])"
			}elseif aryExp("Relational")="is null" {
				s fStr=	logical_" "_code_" isnull()"
			}elseif aryExp("Relational")="is not null" {
				s fStr=	logical_" "_code_" notnull()"
			}elseif aryExp("Relational")="<>" {
				s fStr=	logical_" "_code_" NE( "_aryExp("V1")_" )"
			}else{
				s fStr=	logical_" "_code_" "_aryExp("Relational")_" ("_aryExp("V1")_") "
			}			
			s fs=fs_fStr_" "
		}
	}
		
	s status=1
	//s filterStr="(WorkLoad_OrdDate between"_sd_","_ed_"))"
	d obj.ParseFilterRecursion(themeObj,fs,"",.status)
	if status'=1 q $System.Status.GetErrorText(status)
	else  q ""
}

Method LoadCellFormat(ByRef aryCfgData)
{
}

/// 需要建立一个 统计项在数据集位置与报表中位置（包括在col,row,metric中的位置）的映射关系
Method MapItemPosFromDS2Rpt(ByRef aryCfgData)
{
	s itemCnt("col")=1
	s itemCnt("row")=1
	s itemCnt("cross")=1
	
	s dimInx=1
	s metricsInx=1
	s ..dimItemPosFromDS2Rpt=##class(%Library.ArrayOfDataTypes).%New()
	//s ..columnHeader = ##class(%Library.ListOfDataTypes).%New()
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		s itemType=aryCfgData("rptItemcfg","order",i,"Type")
		if itemType="col" || (itemType="row") || (itemType="cross") {
			s name=aryCfgData("rptItemcfg","order",i,"Name")
			s code=aryCfgData("rptItemcfg","order",i,"Code")
			s format=aryCfgData("rptItemcfg","order",i,"Format")
			if name="" s name=code
			s code=$p(code,"->")
			if aryCfgData("qryItemcfg","Code",code,"Type")="维度" {
				//name:报表列头，itemType:行，列，或交叉”，itemCnt(itemType):“行，列，或交叉的位置“
				d ..dimItemPosFromDS2Rpt.SetAt($lb(name,itemType,itemCnt(itemType),format),"DIM"_dimInx)
				s dimInx=dimInx+1
				s itemCnt(itemType)=itemCnt(itemType)+1
			}elseif aryCfgData("qryItemcfg","Code",code,"Type")="度量" {
				d ..dimItemPosFromDS2Rpt.SetAt($lb(name,itemType,itemCnt(itemType),format),"METRICS"_metricsInx)
				s metricsInx=metricsInx+1
				s itemCnt(itemType)=itemCnt(itemType)+1
			}
		}
	}	
	
	/*
	
	s dimPos=1
	s metrics=1
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		s itemType=aryCfgData("rptItemcfg","order",i,"Type")
		if itemType="col" || (itemType="row") || (itemType="cross") {
			s name=aryCfgData("rptItemcfg","order",i,"Name")
			s code=aryCfgData("rptItemcfg","order",i,"Code")
			if name="" s name=code
			s code=$p(code,"->")
			s posData=$lb(itemType,itemCnt(itemType),name)	//lb("col",1)
			if aryCfgData("qryItemcfg","Code",code,"Type")="维度" {
				
				d ..dimItemPosFromDS2Rpt.SetAt(posData,dimPos)
				s dimPos=dimPos+1
				
			}elseif aryCfgData("qryItemcfg","Code",code,"Type")="度量" {
				d ..metricsItemPosFromDS2Rpt.SetAt(posData,metrics)
				s metrics=metrics+1
			}
			s itemCnt(itemType)=itemCnt(itemType)+1
			
			//保存item的name
			s aryCfgData("rptItemcfg","posData2Name",posData)=name
		}
	}
	*/
}

Method Outputs(rowNO, repid, ByRef ind, ByRef aryCfgData)
{
	if aryCfgData("rptcfg","ShowType")="网格报表" {
		
		s lstDimData=..it.CurDims()
		s lstMetrics=..it.CurMetrics()
		if 0 {
			s cnt=..dimItemPosFromDS2Rpt.Count()
			f i=1:1:cnt {
				s posData=..dimItemPosFromDS2Rpt.GetAt(i)
				s itemType=$lg(posData,1)
				s itemPos=$lg(posData,2)
				s value=$lg(lstDimData,itemPos)
				s name=$lg(posData,3)
				s Data=$lb(rowNO,name_"^"_itemPos,value)

				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1			
			}

			s cnt=..metricsItemPosFromDS2Rpt.Count()
			f i=1:1:cnt {
				s posData=..metricsItemPosFromDS2Rpt.GetAt(i)
				s itemType=$lg(posData,1)
				s itemPos=$lg(posData,2)
				s value=$lg(lstMetrics,i)
				s name=$lg(posData,3)
				s Data=$lb(rowNO,name_"^"_itemPos,value)

				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1			
			}
		}
		else {
			s dimCnt=$LL(lstDimData)
			if dimCnt>0 {
				f i=1:1:dimCnt {
					s dimCell=..dimItemPosFromDS2Rpt.GetAt("DIM"_i)
					s pos=$lg(dimCell,3)
					s name=$lg(dimCell,1)
					s value=$lg(lstDimData,i)
					
					continue:value=""

					s Data=$lb(rowNO,name_"^"_pos,value)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			
			s cnt=$LL(lstMetrics)
			if cnt>0 {
				f i=1:1:cnt {
					s metricsCell=..dimItemPosFromDS2Rpt.GetAt("METRICS"_i)
					s pos=$lg(metricsCell,3)
					s name=$lg(metricsCell,1)
					s value=$lg(lstMetrics,i)
					s format=$lg(metricsCell,4)

					s Data=$lb(rowNO,name_"^"_pos_"^"_format,value)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}						
		}

	}elseif aryCfgData("rptcfg","ShowType")="交叉报表" {
		s lstDimData=..it.CurDims()
		s lstMetrics=..it.CurMetrics()
		
		s dimCnt=$LL(lstDimData)
		s ary("col")="^^^^"
		s ary("row")="^^^^"
		s cross=""
		f i=1:1:dimCnt {
			s dimCell=..dimItemPosFromDS2Rpt.GetAt("DIM"_i)
			s pos=$lg(dimCell,3)
			s type=$lg(dimCell,2)
			s value=$lg(lstDimData,i)			
			s $p(ary(type),"^",pos)=value
		}

		s metricsCnt=$LL(lstMetrics)
		f i=1:1:metricsCnt {
			s metricsCell=..dimItemPosFromDS2Rpt.GetAt("METRICS"_i)
			s pos=$lg(metricsCell,3)
			s type=$lg(metricsCell,2)
			s value=$lg(lstMetrics,i)	
			s name=$lg(metricsCell,1)
			s format=$lg(metricsCell,4)
			
			s $p(cross,"^",1)=pos
			s $p(cross,"^",2)=name
			s $p(cross,"^",3)=value
			s $p(cross,"^",4)=format
			s Data=$lb(ary("row"),ary("col"),cross)			

			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
}

Storage Default
{
<Data name="DSPBDefaultData">
<Subscript>"DSPB"</Subscript>
<Value name="1">
<Value>themePath</Value>
</Value>
<Value name="2">
<Value>executor</Value>
</Value>
<Value name="3">
<Value>parser</Value>
</Value>
<Value name="4">
<Value>it</Value>
</Value>
<Value name="5">
<Value>columnHeader</Value>
</Value>
<Value name="6">
<Value>col2ItemMap</Value>
</Value>
<Value name="7">
<Value>ItemPosFromDS2Rpt</Value>
</Value>
<Value name="8">
<Value>dimItemPosFromDS2Rpt</Value>
</Value>
<Value name="9">
<Value>metricsItemPosFromDS2Rpt</Value>
</Value>
</Data>
<DefaultData>DSPBDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
