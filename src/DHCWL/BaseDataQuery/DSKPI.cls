Class DHCWL.BaseDataQuery.DSKPI Extends DHCWL.BaseDataQuery.DS
{

Property resultDim As %String;

Property dimItemPosFromDS2Rpt As %Library.ArrayOfDataTypes;

Property col2ItemMap As %Library.ArrayOfDataTypes;

/// 取数规则
Property KPIRulerStr As %String(COLLATION = "EXACT", MAXLEN = 3000);

/// 过滤规则
Property FilterStr As %String(COLLATION = "EXACT", MAXLEN = 3000);

Property rs As %ObjectHandle;

Property subGrpAry As %Library.ArrayOfObjects;

/// d ##class(DHCWL.BaseDataQuery.DSKPI).Init()
ClassMethod Init() As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s exist=##class(DS).GetByCode("allKPI")
	if $ISOBJECT(exist) {
		s ret="该编码已存在。编码不能重复，请修改编码后再试！"
		q ret
	}
	
	
	s newObj=##class(DSKPI).%New()
	s newObj.Code="allKPI"
	s newObj.Name="所有指标"
	s newObj.Descript="所有指标"
	s newObj.Type="指标"

	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建报表对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=newObj.%Id() 
 	d newObj.%Close()

	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

Method GetPropertys(kpiDimCode As %String) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:kpiDimCode="" list
	
	s kpiDimID=""
	f {
		s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID))
		q:kpiDimID=""
		
		
		s kpiDimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(kpiDimID)
		s dimCode=kpiDimObj.MKPIDimCode
		continue:(kpiDimCode'=dimCode)
		
		s baseDim=kpiDimObj.MKPIDimDimDr
		
		s propertyCode=""
		f {
			s propertyCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",baseDim.%Id(),propertyCode))
			q:propertyCode=""	
			
			s propertyID=""
			f {
				s propertyID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",baseDim.%Id(),propertyCode,propertyID))
				q:propertyID=""
				
				s propertyObj=##class(DHCWL.MKPI.DimProperty).%OpenId(propertyID)
				s Code=propertyObj.Code
				s Name=propertyObj.Name
				
				
				s udtObj=##class(DHCWL.BaseDataQuery.UtilDTServ).%New()
				d udtObj.SetValue("Name",Name)
				d udtObj.SetValue("Code",Code)
				d udtObj.SetValue("ID",propertyID)
				
				d list.Insert(udtObj)
			}
		}
		q
	}
	q list
}

/// ////////////////////////////////////////////////////////////////////
/// / 统计接口
/// //////////////////////////////////////
Method QryPrepare(ByRef aryCfgData) As %Status
{
	s ..KPIRulerStr=""
	s ..FilterStr=""
	
	d ..MapItemPosFromDS2Rpt(.aryCfgData)
	s metricsStr=..GetMetricsStr(.aryCfgData)
	s dimsStr=..GetKPIDimsStr(.aryCfgData)
	s filterStr=..GetFilterStr(.aryCfgData)		//filter
	//得到统计组或子组的数据，保存在成员变量中
	d ..GetSubGrpData(.aryCfgData)

	//s ..KPIRulerStr=..GetKPIRulerStr(.aryCfgData)			//得到cql中的from
	
	s rulerCnt=$l(metricsStr,",")
	f i=1:1:rulerCnt {
		s kpiCode=$p(metricsStr,",",i)
		if ..KPIRulerStr'="" {
			s ..KPIRulerStr=..KPIRulerStr_","_kpiCode_":"_dimsStr
		}else{
			s ..KPIRulerStr=kpiCode_":"_dimsStr
		}
		
		continue:(filterStr="")
		if ..FilterStr'="" {
			s ..FilterStr=..FilterStr_","_kpiCode_":("_filterStr_")"
		}else{
			s ..FilterStr=kpiCode_":("_filterStr_")"
		}		
	}
	
	s qryName="DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate"
	s ..rs=##class(%Library.ResultSet).%New(qryName)
	
	//s status=..rs.Prepare()//如果是执行query，可以省略Prepare
	
	//DO $SYSTEM.OBJ.DisplayError(rs.Prepare("SELECT Sample.Stored_Procedure_Test(?,?)"))
	
	//SET sc=rset.Close()
}

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
			s grpParam=aryCfgData("rptItemcfg","order",i,"GrpParam")
			
			if name="" s name=code
			s originalCode=code
			s code=$p(code,"->")
			if aryCfgData("qryItemcfg","Code",code,"Type")="维度" {
				s codeGrpParam=""
				if grpParam'="" s codeGrpParam=originalCode_"|"_grpParam
				//									报表列头，“行，列，或交叉”，“行，列，或交叉的位置“
				d ..dimItemPosFromDS2Rpt.SetAt($lb(name,itemType,itemCnt(itemType),codeGrpParam),dimInx)
				s dimInx=dimInx+1
				s itemCnt(itemType)=itemCnt(itemType)+1
			}elseif aryCfgData("qryItemcfg","Code",code,"Type")="度量" {
				//d ..dimItemPosFromDS2Rpt.SetAt($lb(name,itemType,itemCnt(itemType)),code)
				d ..dimItemPosFromDS2Rpt.SetAt($lb(name,itemType,itemCnt(itemType),format),code)
				s itemCnt(itemType)=itemCnt(itemType)+1
			}
		}
	}
}

/// 得到统计组或子组的数据
/// add by wz.2020-5-13
Method GetSubGrpData(ByRef aryCfgData)
{
	s ..subGrpAry=##class(%Library.ArrayOfObjects).%New()

	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		s itemType=aryCfgData("rptItemcfg","order",i,"Type")
		if itemType="col" || (itemType="row"){
			s grpParam=aryCfgData("rptItemcfg","order",i,"GrpParam")
			continue:($g(grpParam)="")
			s name=aryCfgData("rptItemcfg","order",i,"Name")
			s code=aryCfgData("rptItemcfg","order",i,"Code")
			
			s grpType=""
			S qryName=""
			s groupRowid=""
			if ($F(code,"ItemBsGrpDesc")>0) {//统计大组
				if ($ISOBJECT(..subGrpAry.GetAt("ItemBsGrpDesc|"_grpParam))){
					continue
				}
				s qryName="web.DHCWL.V1.CodeCFG.FunModule:GetItemGrpDetail"
				s grpType="ItemBsGrpDesc"
				
				//保存大组成员的描述和序号
				s grpCode=$zcvt(grpParam,"U")
				if '$d(^DHCWL.CodeCfg.ItemGroupI("Code",grpCode)) {
					if '$d(^DHCWL.CodeCfg.ItemGroupI("Code"," "_grpCode)){
						q
					}else{
						s grpCode=" "_grpCode
					}
				}
				s groupRowid=$o(^DHCWL.CodeCfg.ItemGroupI("Code",grpCode,""))				
				
			}elseif ($F(code,"ItemSubGrpDesc")>0) {//统计子组
				//保存子组条目的描述和序号
				if ($ISOBJECT(..subGrpAry.GetAt("ItemSubGrpDesc|"_grpParam))){
					continue
				}
				s qryName="web.DHCWL.V1.CodeCFG.GrpFunModule:GetSubGrpTreeQuery"
				s grpType="ItemSubGrpDesc"	
				
				s groupRowid=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgGrpidByCode(grpParam)
							
			}else{
				continue
			}
			
			
				
				
			s rs=##class(%Library.ResultSet).%New(qryName)
			
			set sc=rs.Execute(groupRowid)  
			If $$$ISERR(sc) {
				//q $System.Status.GetErrorText(status)
			}
			
			s dataSet=##class(%Library.ListOfObjects).%New()
			While(rs.Next()){
				s rec=##class(%Library.ArrayOfDataTypes).%New()
				if (grpType="ItemBsGrpDesc") {//统计大组
					s desc=rs.Data("detailDesc")
					s sort=rs.Data("detailSort")
				}else{
					s desc=rs.Data("name")
					s sort=rs.Data("sort")
				}	
				d rec.SetAt(desc,"desc")
				d rec.SetAt(sort,"sort")
				d dataSet.Insert(rec)
			}
			
			d ..subGrpAry.SetAt(dataSet,code_"|"_grpParam)			
		}
	}
}

/// 需要建立一个 统计项在数据集位置与报表中位置（包括在col,row,metric中的位置）的映射关系
ClassMethod GetMetricsStr(ByRef aryCfgData) As %String
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

		s metrics=metrics_code

	
	}
	q metrics
}

Method GetKPIDimsStr(ByRef aryCfgData) As %String
{
	s dimStr=""
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		
		s itemType=aryCfgData("rptItemcfg","order",i,"Type")
		continue:(itemType'="col" && (itemType'="row"))		
		
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		continue:aryCfgData("qryItemcfg","Code",$p(code,"->"),"Type")'="维度"

		s code=$REPLACE(code,"->",".")
		//统计组或子组参数2020-05-12
		s grpParam=aryCfgData("rptItemcfg","order",i,"GrpParam")
		if $g(grpParam)'="" s code=code_"("_grpParam_")"
		if dimStr'="" s dimStr=dimStr_"^"
		s dimStr=dimStr_code
	}

	q dimStr	
	q KPIRulerStr
}

Method GetFilterStr(ByRef aryCfgData) As %String
{
	s filterStr=""
	s i=0
	f {
		s i=$o(aryCfgData("rptItemcfg","order",i))
		q:i=""
		continue:aryCfgData("rptItemcfg","order",i,"Type")'="filter"
		//if filterStr'="" s filterStr=filterStr_","
		s code=aryCfgData("rptItemcfg","order",i,"Code")
		s code=$REPLACE(code,"->",".")
		
		//统计组或子组参数2020-05-12
		s grpParam=aryCfgData("rptItemcfg","order",i,"GrpParam")
		if $g(grpParam)'="" s code=code_"\("_grpParam_"\)"		
		
		
		s code="{"_code_"}"
		s exp=aryCfgData("rptItemcfg","order",i,"Exp")
		//logical:^Relational:=^V1:I^V2:
		d ..ParseItemExp(exp,.aryExp)
		
		s logical=""
		if aryExp("logical")="AND" {
			s logical="&&"
		}elseif aryExp("logical")="OR" {
			s logical="||"
		}elseif aryExp("logical")="AND (" {
			s logical="&& ["
		}elseif aryExp("logical")="OR (" {
			s logical="|| ["
		}elseif aryExp("logical")="(" {
			s logical="["
		}elseif aryExp("logical")=")" {
			s logical="]"
		}		
	
	
		if code="{}" {
			s filterStr=filterStr_logical
		}else{
			if aryExp("Relational")="in" {
				s fStr=	logical_" ["_code_" = "_aryExp("V1")_"] "
			}elseif aryExp("Relational")="<>" {
				s fStr=	logical_" ["_code_" '= "_aryExp("V1")_"]"
			}elseif aryExp("Relational")="like" {
				s fStr=	logical_" ["_code_" \[ "_aryExp("V1")_"]"
			}else{
				s fStr=	logical_" ["_code_" "_aryExp("Relational")_" "_aryExp("V1")_"]"
			}			
			s filterStr=filterStr_fStr
		}

	}
	
	
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
			//add by wz.2020-05-08
			s code1=$REPLACE(code,"->",".")	
			if qryCfg'="" {
				s qryCfg=qryCfg_" && [{"_code1_"} = "_aryExp(code)_"]"
			}else{
				
				s qryCfg="[{"_code1_"} = "_aryExp(code)_"]"
			}
			
		}
		//add by wz.2020-05-08
		if qryCfg'="" {
			if filterStr'="" {
				s filterStr=filterStr_" && "_qryCfg_""
			}else {
				s filterStr=qryCfg
			}
		} 
	}
	
	
	
	
	
	q filterStr	
	//q FilterStr
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

Method QryNext() As %Integer
{
	s ..resultDim=$o(^||TEMPDHCWL("DSKPIDATA",..resultDim))
	if ..resultDim'="" q 1
	else  q 0
}

Method QryExecute(ByRef aryCfgData) As %Status
{
	s kpi=..KPIRulerStr
	s startDate=aryCfgData("rptcfg","startDate")
	s endDate=aryCfgData("rptcfg","endDate")
	s choiceType=""
	s isRealData="O"
	s filterRule=..FilterStr
	s dynParam=""
	s execParam=""
	
	//判断哪个列是统计组或子组，把code+grpParam作为ID，建立一个全值域的global
	//在指标取得数后，遍历所有的结果，1、去掉组或子组为空的数据；2、找出补集
	//3、把补集添加到^||TEMPDHCWL("DSKPIDATA",中
	k ^||TEMPDHCWL("SUBGRPDATA")
	if ..subGrpAry.Count()>0{	//有统计组或子组
		s dimCnt=..dimItemPosFromDS2Rpt.Count()
		f i=1:1:dimCnt {
			s dimCell=..dimItemPosFromDS2Rpt.GetAt(i)
			s grpKey=$lg(dimCell,4)
			if grpKey'="" s ^||TEMPDHCWL("SUBGRPDATA","grpKeyPos",grpKey)=i

		}		
		
		s grpKey=""
		f {
			s grpKey=..subGrpAry.Next(grpKey)	
			q:grpKey=""
			s dataset=..subGrpAry.GetAt(grpKey)
			
			s recCnt=dataset.Count()
			f recInx=1:1:recCnt {
				s desc=dataset.GetAt(recInx).GetAt("desc")
				s sort=dataset.GetAt(recInx).GetAt("sort")
				S ^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",desc,"sort")=sort
			}			
			
		}
	}
	
	set sc=..rs.Execute(kpi, startDate, endDate, choiceType, isRealData, filterRule, dynParam, execParam)  
	If $$$ISERR(sc) {
		q $System.Status.GetErrorText(status)
	}
	
	k ^||TEMPDHCWL("DSKPIDATA")
	While(..rs.Next()){
		s dimVs=..rs.Data("dimDesc")
		
		if $d(^||TEMPDHCWL("SUBGRPDATA")){//统计组，子组的处理
			k ^||TEMPDHCWL("SUBGRPDATA","setedPos")	//++by wz.2020-05-22
			s grpKey=""
			s qFlag=0
			f {	//为组或子组的列或行设置序号
				s grpKey=$o(^||TEMPDHCWL("SUBGRPDATA","grpKeyPos",grpKey))
				q:grpKey=""
				q:qFlag=1
				s pos=^||TEMPDHCWL("SUBGRPDATA","grpKeyPos",grpKey)
				
				s value=$p(dimVs,",",pos)
				if (value="NULL") {	//值为空就跳过
					S qFlag=1
					Q		
				}
				
				S ^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",value,"exist")=1	//取到的所有值
				s sort=^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",value,"sort")
				s value=value_$c(2)_sort
				s $p(dimVs,",",pos)=value
				s ^||TEMPDHCWL("SUBGRPDATA","setedPos",pos)=""	//把已设置了序号的位置记录下来 ++by wz.2020-05-22
			}
			//if qFlag=1 continue //值为空就跳过 --by wz.2020-05-22
			////为非（组或子组）的列或行设置序号
			s dimId=..rs.Data("dimId")
			s len=$l(dimVs,",")
			f i=1:1:len {
				if $d(^||TEMPDHCWL("SUBGRPDATA","setedPos",i)) continue
				s desc=$p(dimVs,",",i)
				s sort=$p(dimId,",",i)	//把ID作为序号
				s $p(dimVs,",",i)=desc_$c(2)_sort
			}			

		}else{
			s dimId=..rs.Data("dimId")
			s len=$l(dimVs,",")
			f i=1:1:len {
				
				s desc=$p(dimVs,",",i)
				if aryCfgData("rptcfg","ShowType")="网格报表" {
					s $p(dimVs,",",i)=desc
				}else{
					s sort=$p(dimId,",",i)	//把ID作为序号
					s $p(dimVs,",",i)=desc_$c(2)_sort
				}
			}
		}
		
		
		s metricsCode=..rs.Data("kpiCode")	
		s ^||TEMPDHCWL("DSKPIDATA",dimVs,metricsCode)=$g(^||TEMPDHCWL("DSKPIDATA",dimVs,metricsCode))+..rs.Data("value")
	}
	
	//在此处补全统计组或子组的数据。
	//s ^||TEMPDHCWL("DSKPIDATA","NULL,超生,NULL","NULL")=0
	//s ^||TEMPDHCWL("DSKPIDATA","NULL,超生,NULL","InhosDrugFee")=0
	s grpKey=""
	f {
		s grpKey =$o(^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey))
		q:grpKey=""
		s desc=""
		f {
			s desc=$o(^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",desc))
			q:desc=""
			if $d(^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",desc,"exist")) continue
			
			s defaultV=""
			s dimCnt=..dimItemPosFromDS2Rpt.Count()
			f i=1:1:dimCnt {
				s $p(defaultV,",",i)="NULL"
			}
			s sort=^||TEMPDHCWL("SUBGRPDATA","grpKey",grpKey,"全集数据",desc,"sort")
			S pos=^||TEMPDHCWL("SUBGRPDATA","grpKeyPos",grpKey)
			s $p(defaultV,",",pos)=desc_$c(2)_sort
			s ^||TEMPDHCWL("DSKPIDATA",defaultV,"NULL")=0	
		}
	}
	s ..resultDim=""
	q ""
}

Method Outputs(rowNO, repid, ByRef ind, ByRef aryCfgData)
{
	if aryCfgData("rptcfg","ShowType")="网格报表" {
		s dimVs=..resultDim
		s dimCnt=$l(dimVs,",")
		f i=1:1:dimCnt {
			s dimCell=..dimItemPosFromDS2Rpt.GetAt(i)
			
			s colPos=$lg(dimCell,3)
			s name=$lg(dimCell,1)
			s value=$p(dimVs,",",i)

			//s Data=$lb(rowNO,name_"^"_colPos,value)
			s Data=$lb(rowNO,name_"^"_colPos_"^^D",value)	//名称^位置^格式^维度标志
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
			
		s metricsCode=""
		f {
			s metricsCode=$o(^||TEMPDHCWL("DSKPIDATA",..resultDim,metricsCode))
			q:metricsCode=""
			
			s metricsCell=..dimItemPosFromDS2Rpt.GetAt(metricsCode)
			s colPos=$lg(metricsCell,3)
			s name=$lg(metricsCell,1)
			s value=^||TEMPDHCWL("DSKPIDATA",..resultDim,metricsCode)


			s format=$lg(metricsCell,4)



			//s Data=$lb(rowNO,name_"^"_colPos_"^"_format,value)
			s Data=$lb(rowNO,name_"^"_colPos_"^"_format_"^M",value) //名称^位置^格式^度量标志
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}elseif aryCfgData("rptcfg","ShowType")="交叉报表" {
		s ary("col")=",^,^,^,^,"
		s ary("row")=",^,^,^,^,"
		s cross=""
				
		s dimVs=..resultDim
		s dimCnt=$l(dimVs,",")
		f i=1:1:dimCnt {
			s dimCell=..dimItemPosFromDS2Rpt.GetAt(i)
			s pos=$lg(dimCell,3)
			s name=$lg(dimCell,1)
			s type=$lg(dimCell,2)
			s value=$p(dimVs,",",i)
			s newV=$p(value,$c(2),1)
			s sort=+$p(value,$c(2),2)
			//s $p(ary(type),"^",pos)=value
			s $p(ary(type),"^",pos)=newV_","_sort
		}
		
			
		s metricsCode=""
		f {
			s metricsCode=$o(^||TEMPDHCWL("DSKPIDATA",..resultDim,metricsCode))
			q:metricsCode=""
			
			s metricsCell=..dimItemPosFromDS2Rpt.GetAt(metricsCode)
			//name,itemType,itemCnt(itemType)),code
			s pos=$lg(metricsCell,3)
			s name=$lg(metricsCell,1)
			s format=$lg(metricsCell,4)
			s value=^||TEMPDHCWL("DSKPIDATA",..resultDim,metricsCode)
			
			if name="" s name="NULL"

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
<Data name="DSKPIDefaultData">
<Subscript>"DSKPI"</Subscript>
<Value name="1">
<Value>KPIRulerStr</Value>
</Value>
<Value name="2">
<Value>FilterStr</Value>
</Value>
<Value name="3">
<Value>columnHeader</Value>
</Value>
<Value name="4">
<Value>col2ItemMap</Value>
</Value>
<Value name="5">
<Value>rs</Value>
</Value>
<Value name="6">
<Value>resultDim</Value>
</Value>
<Value name="7">
<Value>dimItemPosFromDS2Rpt</Value>
</Value>
<Value name="8">
<Value>subGrpAry</Value>
</Value>
</Data>
<DefaultData>DSKPIDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
