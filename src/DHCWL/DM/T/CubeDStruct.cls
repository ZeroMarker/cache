/// Created by lihaihong
/// Cube Data Struct: Deprected
/// Data:  ^DHCWL.DM.T.CubeDStructD(cubeMask,partIndex,rowid)=dimList
///        ^DHCWL.DM.T.CubeDStructD(cubeMask,partIndex,rowid,metricSN,0)=$lb(count,sum,max,min)
///        ^DHCWL.DM.T.CubeDStructD(cubeMask,partIndex,rowid,metricSN,1)=maxMetricListSegIndex
///        ^DHCWL.DM.T.CubeDStructD(cubeMask,partIndex,rowid,metricSN,2,metricListSegIndex)=currentMetricList
///        ^DHCWL.DM.T.CubeDStructD(cubeMask,partIndex,rowid,metricSN,2,metricListSegIndex,0)=segListMaxLenth
/// 
/// Index: ^DHCWL.DM.T.CubeDStructI(cubeMask,partIndex,serialNumber,dimValue,segIndex)=segBit
/// 
/// Computed Cube Data Struct:
/// Data:  ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId)=dimList
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,0)=$lb(count,sum,max,min)
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,1)=maxMetricListIndex
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,2,metricListSegIndex)=currentMetricList
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,2,metricListSegIndex,0)=segListMaxLenth
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,-1,windowMetricSN)=winDimsMask
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,-1,windowMetricSN,windowDimId)=""
/// 
/// Index:
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,1,partIndex,serialNumber,dimValue,segIndex)=segBit
/// temp:  ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,dimRowList)=computedCubeId
/// Window small cube
///        $I( ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0) )
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId)=partDimRowList
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,1)=maxMetricListSegIndex
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,2,metricListSegIndex)=metricList
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,2,metricListSegIndex,0)=currentsegListLenth
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,-1,partDimRowList)=partRowId
/// 
/// 
/// 新的数据结构：
/// New Cube Data Struct:
/// Data:  
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid)=dimList
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,0)=$lb(metricListLength,metricValueCount,metricDeleteCount)
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,metricSN,1)=$lb(lastMetricSeg,lastMetricSegListIndex)
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,metricSN,2,metricListSeg)=metricValueList
///        add@20171120
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,-relationDimSN)=$lb(rdimSegCount,rdimSetIndex)
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,-relationDimSN,segIndex)=relationDimValueList
/// 
/// Index: ^DHCWL.DM.T.CubeDStructI(partIndex,cubeMask,serialNumber,dimValue,segIndex)=segBit
///  add@20171120
///        ^DHCWL.DM.T.CubeDStructI(partIndex,cubeMask,-relationDimSN,relaDimValue,cubeRowId,metricSN,metricSeg,metricSegInde)=""
/// 
/// 
/// 新的数据结构1：
/// New Cube Data Struct:
/// Data:  
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid)=dimList
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,0)=$lb(metricListLength,metricValueCount,metricDeleteCount)
///        ^DHCWL.DM.T.CubeDStructV(partIndex,cubeMask,rowid,metricSN)=$lb(lastMetricSeg,lastMetricSegListIndex)
///        ^DHCWL.DM.T.CubeDStructV(partIndex,cubeMask,rowid,metricSN,metricListSeg)=metricValueList
///        add@20171120
///        ^DHCWL.DM.T.CubeDStructV(partIndex,cubeMask,rowid,-relationDimSN)=$lb(rdimSegCount,rdimSetIndex)
///        ^DHCWL.DM.T.CubeDStructV(partIndex,cubeMask,rowid,-relationDimSN,segIndex)=relationDimValueList
/// 
/// Index: ^DHCWL.DM.T.CubeDStructI(partIndex,cubeMask,dimSerialNumber,dimValue,segIndex)=segBit
///        $I(^DHCWL.DM.T.CubeDStructIR(partIndex,cubeMask,0))
///        ^DHCWL.DM.T.CubeDStructIR(partIndex,cubeMask,0,relationDimSN,relaDimValue,CubeDimRowId)=CubeRelationDimValueIdcrid
///        $bit(^DHCWL.DM.T.CubeDStructIR(partIndex,cubeMask,1,metricSN,CubeRelationDimValueIdcrid,metricListSeg),metricListSegIndex)=1
/// 
/// 
/// Computed Cube Data Struct:
/// single process partIndex is 0
/// Data:  ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId)=dimList
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,0)=$lb(count,sum,max,min)
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,metricSN,2,seg)=metricValueList
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,-1,windowMetricSN)=winDimsMask
///        ^||TEMPCMPDCUBEDD(computedcubeMask,partIndex,rowId,-1,windowMetricSN,windowDimId)=""
/// 
/// Index:
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,1,partIndex,serialNumber,dimValue,segIndex)=segBit
/// temp:  ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,dimRowList)=computedCubeId
/// Window small cube
///        $I( ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0) )
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId)=partDimRowList
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,1)=maxMetricListSegIndex
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,2,metricListSegIndex)=metricList
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,0,partRowId,2,metricListSegIndex,0)=currentsegListLenth
///        ^||TEMPCMPDCUBEDI(computedcubeMask,dimsMask,-1,partDimRowList)=partRowId
///        
/// Inner Join Parent join dim rowId struct:
///        $i( ^||TEMPCMPDCUBEDI(computedcubeMask,-joinComputedCubeMask,joinPostion)
///        ^||TEMPCMPDCUBEDI(computedcubeMask,-joinComputedCubeMask,joinPostion,joinDimRowList,computedcubeMaskRowId)="" //joinPostion=0 left ;1 right
/// 
/// 新的数据结构2：
/// New Cube Data Struct:
/// Data:  
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid)=dimList
///        ^DHCWL.DM.T.CubeDStructD(partIndex,cubeMask,rowid,0)=$lb(metricListLength,metricValueCount,metricDeleteCount)
/// 
///        ^DHCWL.DM.T.CubeDStructM(partIndex,cubeMask,rowid,metricSN)=$lb(lastMetricSeg,lastMetricSegListIndex)
///        ^DHCWL.DM.T.CubeDStructM(partIndex,cubeMask,rowid,metricSN,metricListSeg)=metricValueList
/// 
///        ^DHCWL.DM.T.CubeDStructR(partIndex,cubeMask,rowid,relationDimSN)=$lb(rdimSegCount,rdimSetIndex)
///        ^DHCWL.DM.T.CubeDStructR(partIndex,cubeMask,rowid,relationDimSN,segIndex)=relationDimValueList
/// 
/// Index: ^DHCWL.DM.T.CubeDStructI(partIndex,cubeMask,serialNumber,dimValue,segIndex)=segBit
/// 
///        ^DHCWL.DM.T.CubeDStructIR(partIndex,cubeMask,relationDimSN,relaDimValue,cubeRowId,metricSN,metricSeg,metricSegInde)=""
///        ^DHCWL.DM.T.CubeDStructIR(partIndex,cubeMask,relationDimSN,relaDimValue,cubeRowId,metricSN,metricSeg)=metricIndexSegBit
/// 
Class DHCWL.DM.T.CubeDStruct Extends %Persistent
{

// defined in DHCWL.DM.Core.PhysicalExecutor,DHCWL.DM.T.CubeDSPart

/// 单个节点的最大Bit长度 最大可设置为：262104;
Parameter MAXBITRANGE = 262104;

/// 分配的最大分区号，适用于数据和索引
Parameter MAXPARTIONNUM = 6;

/// 维度数据结构定义转换成List时多大长度为一个单元
Parameter DIMSTRUCTLISTUNIT = 4;

// Parameter SHEDULERPARTFACTOR = 100;

// d ##class(DHCWL.DM.T.CubeDStruct).Test()

ClassMethod Test()
{
	
	f i=1:1:9999 d
	.d ##class(DHCWL.DM.T.CubeDStruct).Upsert(1,$lb("2015-03-20","I",9,291),$lb("RecDep",4,4,4,"PatDep",3,3,4,"AdmType",2,2,12,"OrdDate",1,1,91),$lb(i),$lb("Price",1,1,8))
	q
	s list=$lb()
	f i=1:1:8255 d
	.s $list(list,i)=i
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	;f i=1:1:9999999 d
	;.d stream.WriteLine(i)
	d stream.WriteLine(976543210)
	d stream.WriteLine("hello")
	d stream.%Save()
	d stream.Rewind()
	w stream.ReadLine(),!
	w stream.ReadLine(),!
	w stream.ReadLine(),!
	s stream=""
	zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).Test2()

ClassMethod Test2()
{
	
	k ^lhh
	s dimStruct=$lb("RecDep",8,19,4,"PatDep",6,17,4,"AdmType",2,13,12,"OrdDate",1,12,91,"PatDoc",7,18,12,"RecDoc",9,20,12,"ResDoc",10,21,12,"TarACDr",11,22,4,"TarECDr",12,23,4,"TarICDr",13,24,4,"TarOutDr",15,26,4,"TarItemDr",14,25,4,"ItemCatDr",3,14,4,"ItemOrdDr",4,15,12,"OEORIDr",5,16,12)
	s metricStruct=$lb("Quantity",5,1,8,"Price",7,3,8,"UnitPrice",6,2,8)
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",9,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",9,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.%Save()
	d ..UpsertByStream(3,stream,dimStruct,metricStruct)
	;d stream.Clear()
	s stream=""
	zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).Test3()

ClassMethod Test3()
{
	k ^lhh
	s dimStruct=$lb("RecDep",8,19,4,"PatDep",6,17,4,"AdmType",2,13,12,"OrdDate",1,12,91,"PatDoc",7,18,12,"RecDoc",9,20,12,"ResDoc",10,21,12,"TarACDr",11,22,4,"TarECDr",12,23,4,"TarICDr",13,24,4,"TarOutDr",15,26,4,"TarItemDr",14,25,4,"ItemCatDr",3,14,4,"ItemOrdDr",4,15,12,"OEORIDr",5,16,12)
	s metricStruct=$lb("Quantity",1,5,8,"Price",3,7,8,"UnitPrice",2,6,8)
	s schedulerStruct=$lb("OrdDate",1,12,91)
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",9,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",9,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-20","O",466,"13762||1","159||1",9,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",10,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",11,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",12,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",13,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",14,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",15,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",16,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-20","I",466,"13762||1","159||1",17,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(1,1.133333,1.13))
	d stream.WriteLine($lb("2015-03-20","E",466,"13762||1","159||1",18,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-21","E",466,"13762||1","159||1",18,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.WriteLine($lb("2015-03-21","I",466,"13762||1","159||1",18,288,291,"" ,288,7,7,7,5541,6))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.%Save()
	d ..UpsertStreamByDay(3,stream,dimStruct,metricStruct,schedulerStruct)
	;d stream.Clear()
	s stream=""
	zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).Test4()

ClassMethod Test4()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("979924","37","外一科护理单元","外一科","外一科护理单元","16","I","2013-03-13","550", ,"550","23","52","29","27","2921","269","10058||1","54||93","1970-01-01"))
	d stream.WriteLine($lb(2,2.133333,2.13))
	d stream.%Save()
	d ..BuildThemeCubeByDay("/workload.t","2013-03-13",stream)
	;d stream.Clear()
	s stream=""
	zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).Test5()

ClassMethod Test5()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("2015-01-01","20150101","10:09", ,"145",22,"22||1",269,"24361||1",15006331,"2015-01-01","20150101", , ,"2016-02-24","20160224", , ,50000,"1970-01-01", , , ,"19842||81458","2015-01-01","20150101",7604,614,"10:09", , ,5,20091,4350516, ,7604,28,88, ,0, ,0, , , , , , , ,614,2,13, ,22,3,19511,13,6,12,"10:09", , , ,199122893))
	d stream.WriteLine($lb(20.0,20.0,0.0,0.0,1.0,20.0))
	d stream.WriteLine($lb("2015-01-01","20150101","10:09", ,"145",22,"22||1",269,"24361||1",15006331,"2015-01-01","20150101", , ,"2016-02-24","20160224", , ,50000,"1970-01-01", , , ,"19842||81458","2015-01-01","20150101",7604,614,"10:09", , ,5,20091,4350516, ,7604,28,88, ,0, ,0, , , , , , , ,614,2,13, ,22,3,19511,13,6,12,"10:09", , , ,199122893))
	d stream.WriteLine($lb(20.0,20.0,0.0,0.0,1.0,20.0))
	d stream.%Save()
	d ..InsertThemeCubeDaily("/WorkLoadAlll.t","2015-01-01",stream)
	;d stream.Clear()
	s stream=""
	zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).TestWorkload4()

ClassMethod TestWorkload4()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	;w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("601749","159","13760||1","67","E","2013-02-01","206","68","68||1","62","77","P","","1102","221319","48||21","5539","67","30","1102","YES","2015-03-27","","","","","","1970-01-01","23","24","27","23","34","33","","221319||48||1","1.0","1","","1","","","",""))
	d stream.WriteLine($lb(5,1,17.874883566112935,20.09130356764829,10.92940170940171,27.161458333333332))
	d stream.WriteLine($lb("601750","98","12812||1","6","I","2013-02-01","315","48","48||1","521","356","P","","688","221664","489||39","4767","6","27","688","","1970-01-01","","","","","","1970-01-01","7","46","6","7","12","7","","221664||51||1","1.0","","489||39||1","1","","1958||1","32","2"))
	d stream.WriteLine($lb(1.998,20,92.00845363461875,12.623297128488776,18.765917602996254,215.18073058541296))
	d stream.%Save()
	d ..InsertThemeCubeDaily("/WorkLoad4.t","2013-02-01",stream)
	d stream.Clear()
	s stream=""
	;zw ^lhh(2)
}

// d ##class(DHCWL.DM.T.CubeDStruct).TestMRInfo()

ClassMethod TestMRInfo()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	;w stream.%Location,!
	s stream.%Location="^lhh(2)"
	d stream.WriteLine($lb("2016-03-07","63","全自费","0000893688","曾凌","女","1980-07-02","32","中国","","0","0","武汉市","武汉市","汉族","420105198007020023","职员","已婚","武汉市汉阳区钟家村2号3楼3户","-","不详","武汉市汉阳区钟家村2号3楼3户","不详","武汉市绅威鞋业","-","不详","凌桂云","父母","15872406561","-","门诊","2016-03-07","97","9","","15","9","大于37整周的假临产[30099]","O47.100","","医嘱离院","不详","","","","","O47.100","大于37整周的假临产[30099]","有","好转","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2016-03-11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","无","O47.100","","","","无","无","-","B","2","贺漪","何啸兰","高雪梅","朱一麟","","","","","","高雪梅","","","2013-05-23","无","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0.00","0.00","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","001357","","47",""))
	d stream.WriteLine($lb(1,1,947.79,"",40,65.00,0.00,0.00,0.00,768.00,0.00,35.00,0.00,0.00,0,0.00,0.00,0.00,0,0,0.00,0,0.00,0.00,0.00,0.00,0.00,39.79,0.00,0.00,0,"","","","","","","","","","","","","",""))
	d stream.%Save()
	d ..InsertThemeCubeDaily("/DHCMRInfo.t","2016-03-07",stream)
	d stream.Clear()
	s stream=""
	;zw ^lhh(2)
}

ClassMethod GetThemeStream() As %Stream.GlobalBinary
{
  s stream=##class(%Stream.GlobalBinary).%New()
  s date=$p($h,",",1)
  s stream.%Location="^DHCWL.DM.T.ThemeFetchTGS("_date_","_$j_")"
  q stream
}

// 弃用

ClassMethod BuildThemeCubeByDay(themePath, day, stream As %Stream.GlobalBinary) As %Status
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  d ..DeleteByScheduleDate(cubeMask,day,day)
	  s dimSN=cube.GetDimStructMap()
	  s metricSN=cube.GetMetricStructMap()
	  s schedulerSN=cube.GetShedulerStruct()
	  s dimList=cube.GetDims()
	  s metricList=cube.GetMetrics()
	  ;s themeDimSN=$lb(),themeMetricSN=$lb()
	  k dimC2TSNMap,metricC2TSNMap
	  f j=1:1:dimList.Count() {
		s dim=dimList.GetAt(j)
		;s $list(themeDimSN,j)=dim.DimPro.SerialNumber
		s dimC2TSNMap(dim.SerialNumber)=dim.DimPro.SerialNumber
	  }
	  f j=1:1:metricList.Count() {
		s metric=metricList.GetAt(j)
		;s $list(themeMetricSN,j)=metric.MetricPro.SerialNumber
		s metricC2TSNMap(metric.SerialNumber)=metric.MetricPro.SerialNumber
	  }
	  ;s dimLen=$ll(themeDimSN),metricLen=$ll(themeMetricSN)
	  s dayi=$zdh(day,3)
	  s cubeDayPart=##class(CubeDSPart).TouchPart(cubeMask,dayi)
	  d stream.Rewind()
	  while('stream.AtEnd){
	    s themeDimRow=stream.ReadLine()
	    s themeMetricRow=stream.ReadLine()
	    if (($lv(themeDimRow))&&($lv(themeMetricRow))){
		  ;w "themeDimRow"_$lts(themeDimRow,","),!
		  ;w "themeMetricRow"_$lts(themeMetricRow,","),!
		  s dimRow=$lb(),metricRow=$lb()
		  s sn="" f{
			s sn=$o(dimC2TSNMap(sn))
			q:sn=""
		    s $list(dimRow,sn)=$lg(themeDimRow,dimC2TSNMap(sn))
		  }
		  s sn="" f{
			s sn=$o(metricC2TSNMap(sn))
			q:sn=""
		    s $list(metricRow,sn)=$lg(themeMetricRow,metricC2TSNMap(sn))
		  }
		  d ..Upsert3(dayi,cubeMask,cubeDayPart,dimRow,dimSN,metricRow,metricSN,schedulerSN)
	    }
	  }
	}
	d stream.Clear()
	q $$$OK
}

ClassMethod SchedulerFactor(schedulerDate) As %String
{
	q $zdh(schedulerDate,3)/100
}

// 弃用

ClassMethod UpsertByStream(cubeMask As %String, stream As %Stream.GlobalBinary, dimSN As %List, metricSN As %List) As %Status
{
	
	s cubeBase=##class(CubeBase).%OpenId(cubeMask)
	;b ;1
	s schedulerStruct=cubeBase.GetShedulerStruct()
	d stream.Rewind()
	while('stream.AtEnd){
	  s dimRow=stream.ReadLine()
	  s metricRow=stream.ReadLine()
	  if (($lv(dimRow))&&($lv(metricRow))){
		d ..Upsert2(cubeMask,dimRow,dimSN,metricRow,metricSN,schedulerStruct)
	  }
	}
	d stream.Clear()
	s stream=""
	q $$$OK
}

// 弃用

ClassMethod UpsertStreamByDay(cubeMask As %String, stream As %Stream.GlobalBinary, dimSN As %List, metricSN As %List, schedulerStruct As %List) As %Status
{
	d stream.Rewind()
	s rowCount=0
	s ssn=$lg(schedulerStruct,2)
	s cubeBase=##class(CubeBase).%OpenId(cubeMask)
	while('stream.AtEnd){
	  s dimRow=stream.ReadLine()
	  s metricRow=stream.ReadLine()
	  s rowCount=rowCount+1
	  s day=$lg(dimRow,ssn)
	  s dayi=$zdh(day,3)
	  s cubeDayPart=##class(CubeDSPart).TouchPart(cubeMask,dayi)
	  if (($lv(dimRow))&&($lv(metricRow))){
		d ..Upsert3(dayi,cubeMask,cubeDayPart,dimRow,dimSN,metricRow,metricSN,schedulerStruct)
	  }
	}
	w "rowCount="_rowCount,!
	d stream.Clear()
	s stream=""
	q $$$OK
}

// 弃用

ClassMethod Upsert3(convertedSDateInt As %Integer, cubeId, cubeDayPart As CubeDSPart, dimRow As %List, dimSN As %List, metricRow As %List, metricSN As %List, schedulerStruct As %List) As %Status [ Private ]
{
	s dimLen=$ll(dimSN),metricLen=$ll(metricSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s action=1,schedulePart=0
	k indAndBit,indBit,dimIndMatchMap
	s schedulePart=cubeDayPart.PartIndex
	s indAndBitFlag=1,scheduleSN=$lg(schedulerStruct,2)
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn),dimId=$lg(dimSN,i+2)
	  if sn=scheduleSN{
		s dimV=convertedSDateInt
	  }else{
		s:((dt=91)&&(dimV'="") &&(+dimV'=dimV)) dimV=$zdh(dimV,3)
	  }
	  s:dimV="" dimV=$c(0)
	  if ( ($d(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV))) ){
	    k indBit
	    s dimIndMatchMap(dimId)=1
	    m indBit=^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV)
	    i indAndBitFlag=1 {
	      m indAndBit=indBit
	      s indAndBitFlag=0
	    }else{
	      s segInd2="" f  {
		    s segInd2=$o(indBit(segInd2))
		    q:segInd2=""
		    s:'$d(indAndBit(segInd2)) indAndBit(segInd2)=""
		    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	      s segInd2="" f  {
		    s segInd2=$o(indAndBit(segInd2))
		    q:segInd2="" 
		    s:'$d(indBit(segInd2)) indBit(segInd2)=""
		    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	    }
	  }else{
		 q   
	  }
	}
	s oneNum=0,onePos=0,oneSeg=0,dimIndexMatchNum=0
	s dimId="" f{
      s dimId=$o(dimIndMatchMap(dimId))
	  q:dimId=""
	  s dimIndexMatchNum=dimIndexMatchNum+1
	}
	if dimIndexMatchNum=dimNum  {
	  s segInd="" f{
		s segInd=$o(indAndBit(segInd))
		q:segInd=""
	    s onePos2=$bitfind(indAndBit(segInd),1)
	    i onePos2>0 {
	      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	    }
	  }
	}
	i oneNum=1 {
	  s action=0
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  ;s partInd=crowid # ..#MAXPARTIONNUM
	  i $d(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid)) d metricStructBuild3
	}
	i action=1 { //insert
	  s crowid=$i(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart))
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  //update index
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1), dt=$lg(dimSN,i+3)
	    s dimV=$lg(dimRow,sn)
	    if sn=scheduleSN{
		  s dimV=convertedSDateInt
	      s:dimV="" dimV=$c(0)
		  s $list(dimRow,sn)=dimV
	    }else{
		  i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
	        s dimV=$zdh(dimV,3)
	        s $list(dimRow,sn)=dimV
	      }
	      s:dimV="" dimV=$c(0)
	    }
	    s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV,segNum),segInInd)=1
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid)=dimRow
	  d metricStructBuild3
	  d cubeDayPart.Increment()
	}
	q $$$OK
metricStructBuild3
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
	  s sn=$lg(metricSN,i+1)
	  s mv=+$lg(metricRow,sn,"")
	  s mli=$g(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,1),0)
	  s mll=$g(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli,0),0)
	  s mll=mll+1
	  try{
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
	    s mll=1
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli),mll)=mv
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,1)=mli
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli,0)=mll
    }
    q
}

// 弃用

ClassMethod Upsert2(cubeId, dimRow As %List, dimSN As %List, metricRow As %List, metricSN As %List, schedulerStruct As %List) As %Status
{
	w $lts(dimRow),!
	w $lts(metricRow),!
	
	;q $$$OK
	s dimLen=$ll(dimSN),metricLen=$ll(metricSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s action=1,schedulePart=0
	k indAndBit,indBit,dimIndMatchMap
	s schedulePart=0
	if ($ll(schedulerStruct)>3){
	  s sheduleSN=$lg(schedulerStruct,2),scheduleDT=$lg(schedulerStruct,4)
	  if ((scheduleDT=91)&&(sheduleSN'="")){
	    s dimV=$lg(dimRow,sheduleSN,"")
	    q:dimV="" $$$ERROR("Scheduler date can't null!")
	    s dimV=$zdh(dimV,3)
	    s schedulePart=##class(CubeDSPart).Get(cubeId,dimV)
	    s:schedulePart="" schedulePart=##class(CubeDSPart).Add(cubeId,dimV)
	  }
	}
	
	/*if ((scheduleDT=91)&&(sheduleSN'="")){
	  s dimV=$lg(dimRow,sheduleSN,"")
	  q:dimV="" $$$ERROR("Scheduler date can't null!")
	  s dimV=$zdh(dimV,3)
	  s schedulePart=dimV \ ..#SHEDULERPARTFACTOR
	}else{
	  q $$$ERROR("Schedule date struct is wrong!")
	}*/
	s indAndBitFlag=1
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn),dimId=$lg(dimSN,i+2)
	  s:((dt=91)&&(dimV'="") &&(+dimV'=dimV)) dimV=$zdh(dimV,3)
	  s:dimV="" dimV=$c(0)
	  if ( ($d(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV))) ){
	    k indBit
	    s dimIndMatchMap(dimId)=1
	    m indBit=^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV)
	    i indAndBitFlag=1 {
	      m indAndBit=indBit
	      s indAndBitFlag=0
	    }else{
	      s segInd2="" f  {
		    s segInd2=$o(indBit(segInd2))
		    q:segInd2=""
		    s:'$d(indAndBit(segInd2)) indAndBit(segInd2)=""
		    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	      s segInd2="" f  {
		    s segInd2=$o(indAndBit(segInd2))
		    q:segInd2="" 
		    s:'$d(indBit(segInd2)) indBit(segInd2)=""
		    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	    }
	  }else{
		 q   
	  }
	}
	
	s oneNum=0,onePos=0,oneSeg=0,dimIndexMatchNum=0
	s dimId="" f{
      s dimId=$o(dimIndMatchMap(dimId))
	  q:dimId=""
	  s dimIndexMatchNum=dimIndexMatchNum+1
	}
	if dimIndexMatchNum=dimNum  {
	  s segInd="" f{
		s segInd=$o(indAndBit(segInd))
		q:segInd=""
	    s onePos2=$bitfind(indAndBit(segInd),1)
	    i onePos2>0 {
	      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	    }
	  }
	}
	i oneNum=1 {
	  s action=0
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  s partInd=crowid # ..#MAXPARTIONNUM
	  i $d(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid)) d metricStructBuild2
	}
	
	
	i action=1 { //insert
	  s crowid=$i(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart))
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  //update index
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1), dt=$lg(dimSN,i+3)
	    s dimV=$lg(dimRow,sn)
	    i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
	      s dimV=$zdh(dimV,3)
	      s $list(dimRow,sn)=dimV
	    }
	    s:dimV="" dimV=$c(0)
	    s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,schedulePart,sn,dimV,segNum),segInInd)=1
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid)=dimRow
	  d metricStructBuild2
	}
	q $$$OK
metricStructBuild2
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
	  s sn=$lg(metricSN,i+1)
	  s mv=$lg(metricRow,sn)
	  s mli=$g(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,1),0)
	  s:mli=0 ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,1)=mli
	  s mll=$g(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli,0),0)
	  s mll=mll+1
	  try{
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
		s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,1)=mli
	    s mll=1
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli),mll)=mv
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,schedulePart,crowid,sn,2,mli,0)=mll
    }
    q
}

// d ##class(DHCWL.DM.T.CubeDStruct).Upsert(1,$lb("2015-03-20","I",9,291),$lb("RecDep",4,4,4,"PatDep",3,3,4,"AdmType",2,2,12,"OrdDate",1,1,91),$lb(1.13),$lb("Price",1,1,8))

// 弃用

ClassMethod Upsert(cubeId, dimRow As %List, dimSN As %List, metricRow As %List, metricSN As %List) As %Status
{
	w $lts(dimRow),!
	w $lts(metricRow),!
	
	;q $$$OK
	s dimLen=$ll(dimSN),metricLen=$ll(metricSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s action=1
	k indAndBit,indBit,dimIndMatchMap
	
	s indPart="" 
	f  {
	  s indPart=$o(^DHCWL.DM.T.CubeDStructI(cubeId,indPart))
	  q:indPart="" 
	  s indAndBitFlag=1
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1),dimId=$lg(dimSN,i+2),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn)
	    s:((dt=91)&&(dimV'="") &&(+dimV'=dimV)) dimV=$zdh(dimV,3)
	    s:dimV="" dimV=$c(0)
	    if ( ($d(^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn,dimV))) ){
	      k indBit
	      s dimIndMatchMap(indPart,dimId)=1
	      m indBit=^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn,dimV)
	      i indAndBitFlag=1 {
	        m indAndBit(indPart)=indBit
	        s indAndBitFlag=0
	      }else{
	        s segInd2="" f  {
		      s segInd2=$o(indBit(segInd2))
		      q:segInd2=""
		      s:'$d(indAndBit(indPart,segInd2)) indAndBit(indPart,segInd2)="" ;indBit(segInd2)
		      s indAndBit(indPart,segInd2)=$bitlogic(indAndBit(indPart,segInd2) & indBit(segInd2) )
	        }
	        s segInd2="" f  {
		      s segInd2=$o(indAndBit(indPart,segInd2))
		      q:segInd2="" 
		      s:'$d(indBit(segInd2)) indBit(segInd2)=""
		      s indAndBit(indPart,segInd2)=$bitlogic(indAndBit(indPart,segInd2) & indBit(segInd2) )
	        }
	      }
	    }else{
		   q   
	    }
	  }
	}  
	s oneNum=0,onePos=0,oneSeg=0
	s indPart="" f {
	  s indPart=$o(dimIndMatchMap(indPart))
	  q:indPart="" 
	  s dimIndexMatchNum=0
	  s dimId="" f{
		s dimId=$o(dimIndMatchMap(indPart,dimId))
		q:dimId=""
	    s dimIndexMatchNum=dimIndexMatchNum+1
	  }
	  if dimIndexMatchNum=dimNum  {
	    s segInd="" f{
		  s segInd=$o(indAndBit(indPart,segInd))
		  q:segInd=""
	      s onePos2=$bitfind(indAndBit(indPart,segInd),1)
	      i onePos2>0 {
	        s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	      }
	    }
	  }
	}
	
	i oneNum=1 {
	  s action=0
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  s partInd=crowid # ..#MAXPARTIONNUM
	  i $d(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid)) d metricStructBuild
	}
	
	
	i action=1 { //insert
	  s crowid=$i(^DHCWL.DM.T.CubeDStructD(cubeId))
	  s partInd=crowid # ..#MAXPARTIONNUM
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  //update index
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1),dimId=$lg(dimSN,i+2), dt=$lg(dimSN,i+3)
	    s dimV=$lg(dimRow,sn)
	    i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
	      s dimV=$zdh(dimV,3)
	      s $list(dimRow,sn)=dimV
	    }
	    i dimV="" s dimV=$c(0)
	    s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segNum),segInInd)=1
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid)=dimRow
	  d metricStructBuild
	}
	q $$$OK
metricStructBuild
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
	  s sn=$lg(metricSN,i+1)
	  s mv=$lg(metricRow,sn)
	  s mli=$g(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,1),0)
	  s:mli=0 ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,1)=mli
	  s mll=$g(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,2,mli,0),0)
	  s mll=mll+1
	  try{
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,2,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
		s ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,1)=mli
	    s mll=1
	    s $list(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,2,mli),mll)=mv
	  }
	  s ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid,sn,2,mli,0)=mll
    }
    q
}

// s status =##class(DHCWL.DM.T.CubeDStruct).Delete(1,$lb("2015-03-20","I",9,291),$lb("RecDep",4,4,4,"PatDep",3,3,4,"AdmType",2,2,12,"OrdDate",1,1,91))

// 弃用

ClassMethod Delete(cubeId, dimRow As %List, dimSN As %List) As %Status [ Private ]
{
	s status=$$$OK
	s dimLen=$ll(dimSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT
	s action=1
	k indAndBit,indBit,dimIndMatchMap
	s indPart="" f  {
	  s indPart=$o(^DHCWL.DM.T.CubeDStructI(cubeId,indPart))
	  q:indPart="" 
	  s indAndBitFlag=1
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1),dimId=$lg(dimSN,i+2),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn)
	    i (dt=91)&&(dimV'="") &&(+dimV'=dimV) s dimV=$zdh(dimV,3)
	    i dimV="" s dimV=$c(0)
	    if ( ($d(^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn,dimV))) ){
	      k indBit
	      s dimIndMatchMap(indPart,dimId)=1
	      m indBit=^DHCWL.DM.T.CubeDStructI(cubeId,indPart,sn,dimV)
	      i indAndBitFlag=1 {
	        m indAndBit(indPart)=indBit
	        s indAndBitFlag=0
	      }else{
	        s segInd2="" f  {
		      s segInd2=$o(indBit(segInd2))
		      q:segInd2=""
		      s:'$d(indAndBit(indPart,segInd2)) indAndBit(indPart,segInd2)="" ;indBit(segInd2)
		      s indAndBit(indPart,segInd2)=$bitlogic(indAndBit(indPart,segInd2) & indBit(segInd2) )
	        }
	        s segInd2="" f  {
		      s segInd2=$o(indAndBit(indPart,segInd2))
		      q:segInd2="" 
		      s:'$d(indBit(segInd2)) indBit(segInd2)=""
		      s indAndBit(indPart,segInd2)=$bitlogic(indAndBit(indPart,segInd2) & indBit(segInd2) )
	        }
	      }
	    }else{
		   q   
	    }
	  }
	}  
	s oneNum=0,onePos=0,oneSeg=0
	s indPart="" f {
	  s indPart=$o(dimIndMatchMap(indPart))
	  q:indPart="" 
	  s dimIndexMatchNum=0
	  s dimId="" f{
		s dimId=$o(dimIndMatchMap(indPart,dimId))
		q:dimId=""
	    s dimIndexMatchNum=dimIndexMatchNum+1
	  }
	  if dimIndexMatchNum=dimNum  {
	    s segInd="" f{
		  s segInd=$o(indAndBit(indPart,segInd))
		  q:segInd=""
	      s onePos2=$bitfind(indAndBit(indPart,segInd),1)
	      i onePos2>0 {
	        s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	      }
	    }
	  }
	}
	i oneNum=1 {
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  s partInd=crowid # ..#MAXPARTIONNUM
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  i $d(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid)) {
		f i=1:..#DIMSTRUCTLISTUNIT:dimLen{
		  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn)
		  i (dt=91)&&(dimV'="") &&(+dimV'=dimV) s dimV=$zdh(dimV,3)
		  s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segNum),segInInd)=0
		  i $bitcount(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segNum),1)=0 {
			k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segNum)
			i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,""))=""{
			  k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV)
			  i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,""))=""{
				k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn)
				i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,""))=""{
			      k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd)
			      i $o(^DHCWL.DM.T.CubeDStructI(cubeId,""))=""{
				    k ^DHCWL.DM.T.CubeDStructI(cubeId)
			      }
				}
			  }
			}
		  }
		}
		k ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,crowid)
		i $o(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,""))=""{
		  k ^DHCWL.DM.T.CubeDStructD(cubeId,partInd)
		  k:$o(^DHCWL.DM.T.CubeDStructD(cubeId,""))="" ^DHCWL.DM.T.CubeDStructD(cubeId)
		}
	  }
	}else{
	  s status=$$$ERROR("No dimRow:"_$lts(dimRow))
	}
	q status
}

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteThemeCubeByDay("/workload.t","2013-03-13","2013-03-13")

/// 弃用
ClassMethod DeleteThemeCubeByDay(themePath, startDate, endDate) As %Status
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  d ..DeleteByScheduleDate(cubeMask,startDate,endDate)
	}
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteByScheduleDate(3,"2013-01-01","2013-01-06")

// 弃用

ClassMethod DeleteByScheduleDate(cubeId, startDate, endDate) As %Status
{
	;b ;DeleteByScheduleDate
	s cubeBase=##class(CubeBase).%OpenId(cubeId)
	q:cubeBase="" $$$ERROR("Can't find cube whith id:"_cubeId)
	q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId)) $$$OK
	s dimStructList=cubeBase.GetDimStructMap()
	s dimLen=$ll(dimStructList)
	s sd=$zdh(startDate,3),ed=$zdh(endDate,3)
	;b ;1
	f date=sd:1:ed d
	.;s dateStr=$zd(date1,3)
	.;s date=cubeBase.ConvertScheduleDate(dateStr)
	.;s dateInt=date1 ;cubeBase.ConvertScheduleDateInteger(date)
	.;s date=dateInt
	.s list=##class(CubeDSPart).Get(cubeId,date)
	.s listCount=list.Count()
	.f listI=1:1:listCount d
	..s cubeDayPart=list.GetAt(listI)
	..s partInd=cubeDayPart.PartIndex
	..;s date=cubeBase.ConvertScheduleDate(dateStr)
	..q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd))
	..q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date))
	..s segInd="" f  s segInd=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,segInd)) q:segInd=""  d
	...s bit=^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,segInd)
	...s bitInd=0 f  s bitInd=$bitfind(bit,1,bitInd+1) q:bitInd=0  d
	....s id=( ..#MAXBITRANGE * segInd ) + bitInd
	....q:'$d(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,id))
	....s row=^DHCWL.DM.T.CubeDStructD(cubeId,partInd,id)
	....f i=1:..#DIMSTRUCTLISTUNIT:dimLen d
	.....s sn=$lg(dimStructList,i+1)
	.....s dimV=$lg(row,sn)
	.....s:dimV="" dimV=$c(0)
	.....q:( ('$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn))) || ('$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV)))  || ('$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segInd))) )
	.....s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segInd),bitInd)=0
	.....i $bitcount(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segInd),1) =0 d
	......k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,segInd)
	......i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV,""))="" d
	.......k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dimV)
	.......i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,""))="" d
	........k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn)
	........i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,""))="" d
	.........k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd)
	.........i $o(^DHCWL.DM.T.CubeDStructI(cubeId,""))="" d
	..........k ^DHCWL.DM.T.CubeDStructI(cubeId)
	....s $bit(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,segInd),bitInd)=0
	....k ^DHCWL.DM.T.CubeDStructD(cubeId,partInd,id)
	....i $o(^DHCWL.DM.T.CubeDStructD(cubeId,partInd,""))="" d
	.....k ^DHCWL.DM.T.CubeDStructD(cubeId,partInd)
	.....i $o(^DHCWL.DM.T.CubeDStructD(cubeId,""))="" d
	......k ^DHCWL.DM.T.CubeDStructD(cubeId)
	...i $bitcount(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,segInd),1)=0 d
	....k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,segInd)
	....i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date,""))="" d
	.....k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,date)
	.....i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1,""))="" d
	......k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd,1)
	......i $o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,""))="" d
	.......k ^DHCWL.DM.T.CubeDStructI(cubeId,partInd)
	.......d ##class(CubeDSPart).Delete(cubeId,partInd)
	.......i $o(^DHCWL.DM.T.CubeDStructI(cubeId,""))="" d
	........k ^DHCWL.DM.T.CubeDStructI(cubeId)
	........d ##class(CubeDSPart).Clear(cubeId)
	q $$$OK
}

ClassMethod BacksteppingDimsFromeFilter(cubeId, partList As %List, dimStructList As %List, node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall) As %List
{
	s result=$lb()
	q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId)) result
	;s dimStructList=node.DimStruct
	s dimId=$lg(dimStructList,1)
	s sn=$lg(dimStructList,3)
	s funType=funCall.FunctionConfig.Type.GetPath()
	s fun=funCall.FunctionConfig.Name
	s partLen=$ll(partList)
	k resultMap
	if funType="FUNCTION:FILTERITERATOR" d
	.f i=1:1:partLen d
	..s partInd=$lg(partList,i,"")
	..q:partInd=""
	..s v="" f  s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v)) q:v=""  d
	...i funCall.Call($lb(v)) d
	....s resultMap(v)=""
	e  if funType="FUNCTION:MCALLDIR" d
	.s MF("!=")="'=",MF("'=")="'=",MF("[")="["
	.f i=1:1:partLen d
	..s partInd=$lg(partList,i,"")
	..q:partInd=""
	..q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn))
	..i fun="=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....i $d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,para)) d
	.....s resultMap(para)=""
	..e  i fun=">" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=para f  s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v)) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun=">=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,para),-1) f  s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v)) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun="<" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=para f  s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v),-1) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun="<=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,para)) f  s v=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v),-1) q:v=""  d
	.....s resultMap(v)=""
	e  if funType="FUNCTION:FILTERCHOICE" d
	.s ccl=funCall.Call()
	.s ccll=$ll(ccl)
	.f i=1:1:ccll d
	..s v=$lg(ccl,i,"")
	..q:v=""
	..f j=1:1:partLen d
	...s partInd=$lg(partList,j,"")
	...q:partInd=""
	...if $d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,v)) d
	....s resultMap(v)=""
	s v="",i=0 f  s v=$o(resultMap(v)) q:v=""  d
	.s i=i+1
	.s $list(result,i)=v
	q result
}

ClassMethod BacksteppingCCDimsFromeFilter(cubeId, partList As %List, dimMask, dimStructList As %List, node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall) As %List
{
	s result=$lb()
	q:'$d(^TEMPCMPDCUBEDI(cubeId)) result
	;s dimStructList=node.DimStruct
	s dimId=$lg(dimStructList,1)
	s sn=$lg(dimStructList,3)
	s funType=funCall.FunctionConfig.Type.GetPath()
	s fun=funCall.FunctionConfig.Name
	s partLen=$ll(partList)
	k resultMap
	if funType="FUNCTION:FILTERITERATOR" d
	.f i=1:1:partLen d
	..s partInd=$lg(partList,i,"")
	..q:partInd=""
	..s v="" f  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v)) q:v=""  d
	...i funCall.Call($lb(v)) d
	....s resultMap(v)=""
	e  if funType="FUNCTION:MCALLDIR" d
	.s MF("!=")="'=",MF("'=")="'=",MF("[")="["
	.f i=1:1:partLen d
	..s partInd=$lg(partList,i,"")
	..q:partInd=""
	..q:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn))
	..i fun="=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....i $d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para)) d
	.....s resultMap(para)=""
	..e  i fun=">" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=para f  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v)) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun=">=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para),-1) f  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v)) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun="<" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=para f  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v),-1) q:v=""  d
	.....s resultMap(v)=""
	..e  i fun="<=" d
	...s plen=$ll(node.Params)
	...f j=1:1:plen d
	....s para=$lg(node.Params,j)
	....s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para)) f  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v),-1) q:v=""  d
	.....s resultMap(v)=""
	e  if funType="FUNCTION:FILTERCHOICE" d
	.s ccl=funCall.Call()
	.s ccll=$ll(ccl)
	.f i=1:1:ccll d
	..s v=$lg(ccl,i,"")
	..q:v=""
	..f j=1:1:partLen d
	...s partInd=$lg(partList,j,"")
	...q:partInd=""
	...if $d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v)) d
	....s resultMap(v)=""
	s v="",i=0 f  s v=$o(resultMap(v)) q:v=""  d
	.s i=i+1
	.s $list(result,i)=v
	q result
}

ClassMethod FetchBitIndexFromDims(cubeId, partList As %List, dimStruct As %List, fromDimValue As %List, ByRef segBitIndex) As %Status
{
	k segBitIndex
	s dimId=$lg(dimStruct,1)
	s sn=$lg(dimStruct,3)
	s len=$ll(fromDimValue),partLen=$ll(partList)
	f i=1:1:len d
	.s dim=$lg(fromDimValue,i,"")
	.q:dim=""
	.f j=1:1:partLen d
	..s partInd=$lg(partList,j,"")
	..q:partInd=""
	..q:'$d(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dim))
	..s segInd="" f  s segInd=$o(^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dim,segInd)) q:segInd=""  d
	...s segBit=^DHCWL.DM.T.CubeDStructI(cubeId,partInd,sn,dim,segInd)
	...i $d(segBitIndex(partInd,segInd)) d
	....s segBitIndex(partInd,segInd)=$bitlogic(segBitIndex(partInd,segInd) | segBit)
	...e  d
	....s segBitIndex(partInd,segInd)=segBit
	...i $g(segBitIndex(partInd),-1)<segInd d
	....s segBitIndex(partInd)=segInd
	q $$$OK
}

ClassMethod FetchCCBitIndexFromDims(cubeId, partList As %List, dimMask, dimStruct As %List, fromDimValue As %List, ByRef segBitIndex) As %Status
{
	k segBitIndex
	s dimId=$lg(dimStruct,1)
	s sn=$lg(dimStruct,3)
	s len=$ll(fromDimValue),partLen=$ll(partList)
	f i=1:1:len d
	.s dim=$lg(fromDimValue,i,"")
	.q:dim=""
	.f j=1:1:partLen d
	..s partInd=$lg(partList,j,"")
	..q:partInd=""
	..q:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim))
	..s segInd="" f  s segInd=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim,segInd)) q:segInd=""  d
	...s segBit=^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim,segInd)
	...i $d(segBitIndex(partInd,segInd)) d
	....s segBitIndex(partInd,segInd)=$bitlogic(segBitIndex(partInd,segInd) | segBit)
	...e  d
	....s segBitIndex(partInd,segInd)=segBit
	...i $g(segBitIndex(partInd),-1)<segInd d
	....s segBitIndex(partInd)=segInd
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).InsertThemeCubeDailyTest()

ClassMethod InsertThemeCubeDailyTest()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	;w stream.%Location,!
	;s stream.%Location="^lhh(2)"
	/*
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","4764","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","64","2","264588","4||1","264588||2||1","4||1||6"))
	d stream.WriteLine($lb(122,1,122,0,0,122))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","65","2","264588","4||1","264588||3||1","4||1||1"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","4764","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","66","2","264588","4||1","264588||4||1","4||1||2"))
	d stream.WriteLine($lb(122,1,122,0,0,122))
	d stream.WriteLine($lb("2018-03-23","156","11592||1","156","I","15:06:00","2018-03-24","02:00:00","81","9","9||1","59","P","","1","7986","156","236","1","","","","","","","","","","","","","","","12","13","13","28","3","13","","BillIns","","","","1.0","3","1","","","","","5","44||4","125","22","264620","12||11","264620||2||1","12||11||1"))
	d stream.WriteLine($lb(1.34,-1,-1.34,0,0,-1.34))
	d stream.WriteLine($lb("2018-03-23","156","11592||1","156","I","15:08:53","2018-03-24","02:00:00","81","9","9||1","59","P","","1","7986","156","236","1","","","","","","","","","","","","","","","12","13","13","28","3","13","","BillIns","","","","1.0","3","1","","","","","5","44||4","127","22","264620","12||13","264620||4||1","12||13||1"))
	d stream.WriteLine($lb(1.34,-1,-1.34,0,0,-1.34))
	d stream.WriteLine($lb("2018-03-23","311","685||1","156","I","14:46:45","2018-03-24","02:00:00","1","1","1||1","59","P","","1","685","156","236","1","","","","","","","","","","","","","","","1","1","1","1","16","1","","BillIns","","","","1.0","16","1","185","685||1","20","12","5","44||4","134","22","264620","12||2","264620||10||1","12||2||2"))
	d stream.WriteLine($lb(.029,2,.06,0,0,.06))
	d stream.WriteLine($lb("2018-03-23","311","685||1","156","I","14:46:45","2018-03-24","02:00:00","1","1","1||1","59","P","","1","685","156","236","1","","","","","","","","","","","","","","","1","1","1","1","16","1","","BillIns","","","","1.0","16","1","185","685||1","20","12","5","44||4","135","22","264620","12||2","264620||11||1","12||2||3"))
	d stream.WriteLine($lb(.029,2,.06,0,0,.06))
	*/
	//*
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	//*/
	
	d stream.%Save()
	d ..InsertThemeCubeDaily("/WorkLoad.t","2018-03-23",stream)
	d stream.Clear()
	s stream=""
}

/// 以下实现均为依赖于CubeDBDPPart分区策略的各种操作
ClassMethod InsertThemeCubeDaily(themePath, day, stream As %Stream.GlobalBinary, rebuildFlag As %Boolean = 1) As %Status
{
	s t1=$p($zts,",",2)
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	s dayStr=day
	s day=$zdh(day,3)
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  if (rebuildFlag) && (##class(CubeDCDIDLog).Exist(cubeMask,day) ){
			;d ..DeleteCubeByCD(cube,day)
			w "delete previous data "_"themePath:"_themePath_" cubeMask:"_cubeMask_" day:"_dayStr
			s dt1=$p($zts,",",2)
			d ..DeleteThemeCube(themePath,dayStr,stream,cubeMask,0)
			w "  using time:"_($p($zts,",",2)-dt1),!
	  }else{
			;d ..DeleteCubeByCD(cube,day) 
	  }
	  s dimSN=cube.GetDimStructMap()
	  s metricSN=cube.GetMetricStructMap()
	  s dimRelaSN=cube.GetDimStructMap(1)
	  s dimList=cube.GetDims()
	  s metricList=cube.GetMetrics()
	  s dimC2TSNList=$lb(),metricC2TSNList=$lb(),dimRelC2TSNList=$lb()
	  s dimC2TSNListLen=0,metricC2TSNListLen=0,dimRelC2TSNListLen=0
	  f j=1:1:dimList.Count() {
			s dim=dimList.GetAt(j)
			continue:dim=""
			continue:dim.GetDimTypeCode()="R"
			;s $list(themeDimSN,j)=dim.DimPro.SerialNumber
			;s dimC2TSNMap(dim.SerialNumber)=dim.DimPro.SerialNumber
			s dimC2TSNListLen=dimC2TSNListLen+1
			s $list(dimC2TSNList,dimC2TSNListLen)=dim.SerialNumber
			s dimC2TSNListLen=dimC2TSNListLen+1
			s $list(dimC2TSNList,dimC2TSNListLen)=dim.DimPro.SerialNumber
	  }
	  f j=1:1:dimList.Count() {
			s dim=dimList.GetAt(j)
			continue:dim=""
			continue:dim.GetDimTypeCode()'="R"
			;s dimRelC2TSNMap(dim.SerialNumber)=dim.DimPro.SerialNumber
			s dimRelC2TSNListLen=dimRelC2TSNListLen+1
			s $list(dimRelC2TSNList,dimRelC2TSNListLen)=dim.SerialNumber
			s dimRelC2TSNListLen=dimRelC2TSNListLen+1
			s $list(dimRelC2TSNList,dimRelC2TSNListLen)=dim.DimPro.SerialNumber
	  }
	  f j=1:1:metricList.Count() {
			s metric=metricList.GetAt(j)
			;s metricC2TSNMap(metric.SerialNumber)=metric.MetricPro.SerialNumber
			s metricC2TSNListLen=metricC2TSNListLen+1
			s $list(metricC2TSNList,metricC2TSNListLen)=metric.SerialNumber
			s metricC2TSNListLen=metricC2TSNListLen+1
			s $list(metricC2TSNList,metricC2TSNListLen)=metric.MetricPro.SerialNumber
	  }
	  s partPolice=##class(CubeDBDPPart).ChoicePart(cubeMask)
	  d stream.Rewind()
	  s dataLog=##class(DataLog).StartLog("CUBEDSTRUCT",cubeMask)
	  k ^||tmp("PCSI",cubeMask)
	  //ts
	  while('stream.AtEnd){
	    s themeDimRow=stream.ReadLine()
	    s themeMetricRow=stream.ReadLine()
	    if (($lv(themeDimRow))&&($lv(themeMetricRow))){
			  s dimRow=$lb(),metricRow=$lb(),dimRelaRow=$lb()
			  f j=1:2:dimC2TSNListLen{
				  s sn=$lg(dimC2TSNList,j),sn2=$lg(dimC2TSNList,j+1)
				  s $list(dimRow,sn)=$lg(themeDimRow,sn2)
			  }
			  f j=1:2:dimRelC2TSNListLen{
				  s sn=$lg(dimRelC2TSNList,j),sn2=$lg(dimRelC2TSNList,j+1)
				  s $list(dimRelaRow,sn)=$lg(themeDimRow,sn2)
			  }
			  f j=1:2:metricC2TSNListLen{
				  s sn=$lg(metricC2TSNList,j),sn2=$lg(metricC2TSNList,j+1)
				  s $list(metricRow,sn)=$lg(themeMetricRow,sn2)
			  }
			  d ..InsertRow(day,cubeMask,partPolice,dimRow,dimSN,metricRow,metricSN,dimRelaRow,dimRelaSN,cubeMask,.dataLog)
	    }
	  }
	  d dataLog.Touch("Pre")
	  d ..BatchInsertRow(day,cubeMask,partPolice,dimSN,metricSN,dimRelaSN,cubeMask,.dataLog)
	  k ^||tmp("PCSI",cubeMask)
	  d dataLog.CommitLog("I",themePath_";"_$zd(day,3),partPolice.GetPartition())
	  //tc
	  d partPolice.Commit()
	}
	s t2=$p($zts,",",2)
	w "InsertThemeCubeDaily:"_(t2-t1),!
	d stream.Clear()
	s stream=""
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).InsertCubeFetchConfigTest()

ClassMethod InsertCubeFetchConfigTest()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	d stream.WriteLine($lb("2016-06-23","BFCode2||10","BFCode2||10","BFCode2||1","PAADMType||E","BFCode2||14","BFCode2||10366||1","BFCode2||288","BFCode2||68","BFCode2||68||2","BFCode2||67","BFCode2||2",""," ","","BFCode2||27","BFCode2||33","BFCode2||24","BFCode2||34","BFCode2||23","BFCode2||27","BFCode2||67","BFCode2||2",""," ","BFCode2||1102",""," ","BFCode2||67","BFCode2||2",""," ","","BFCode2||67","BFCode2||2","BFCode2||1102",""," ","BFCode2||16","BFCode2||3230","BFCode2||24","BFCode2||10","BFCode2||10","",""))
	d stream.WriteLine($lb(, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,))
	d stream.WriteLine($lb(1,1,0,0,1))
	//*/
	
	d stream.%Save()
	d ..InsertByCubeFetchConfig("DHCWorkLoad_FlagDate1","2016-06-23",stream)
	d stream.Clear()
	s stream=""
}

// 最新版本

/// 根据主题数据，生成Cube数据
ClassMethod InsertByCubeFetchConfig(cubeCode, day, stream As %Stream.GlobalBinary, rebuildFlag As %Boolean = 1) As %Status
{
	  b ;1
		s cube=##class(CubeBase).GetByCode(cubeCode)
		q:cube="" $$$ERROR("Can't get cube with code "_cubeCode)
		//禁用Jounal
  	DO DISABLE^%NOJRN
		s dayStr=day
		s day=$zdh(day,3)
		s dimSN=cube.GetDimStructMap()
	  s metricSN=cube.GetMetricStructMap()
	  s dimRelaSN=cube.GetDimStructMap(1)
		s cubeMask=cube.Mask()
		s partPolice=##class(CubeDBDPPart).ChoicePart(cubeMask)
		s dataLog=##class(DataLog).StartLog("CUBEDSTRUCT",cubeCode)
	  d stream.Rewind()
		if (rebuildFlag) && (##class(CubeDCDIDLog).Exist(cubeMask,day) ){
			w "delete previous data "_"cubeCode:"_cubeCode_" day:"_day
			s dt1=$p($zts,",",2)
			;d ..DeleteThemeCube(themePath,dayStr,stream,cubeMask,0)
			w "  using time:"_($p($zts,",",2)-dt1),!
	  }
		while('stream.AtEnd){
			s dimList=stream.ReadLine()
			s dimRList=stream.ReadLine()
	    s metricList=stream.ReadLine()
	    d ..InsertRow(day,cubeMask,partPolice,dimList,dimSN,metricList,metricSN,dimRList,dimRelaSN,cubeMask,.dataLog)
		}
		d dataLog.Touch("Pre")
	  d ..BatchInsertRow(day,cubeMask,partPolice,dimSN,metricSN,dimRelaSN,cubeMask,.dataLog)
	  k ^||tmp("PCSI",cubeMask)
	  d dataLog.CommitLog("I",cubeCode_";"_$zd(day,3),partPolice.GetPartition())
	  //tc
	  d partPolice.Commit()
	  d stream.Clear()
		s stream=""
		//重新启用Jounal
  	DO ENABLE^%NOJRN
		q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).InsertRowTest()

ClassMethod InsertRowTest()
{
	s day=$zdh("2018-03-23",3)
	s cubeId=5
	s cubePartPolice=##class(CubeDBDPPart).GetPart(cubeId,1)
	s dimRow=$lb(64730,"329","11502||1","110","I","14:22:26",64731,"02:00:00","22","3","3||3","35","P",$c(0),"1","7936","110","197","1",$c(0),0,$c(0),$c(0),$c(0),$c(0),$c(0),0,$c(0),$c(0),$c(0),$c(0),0,$c(0),"5","5","5","11","7","5",$c(0),"BillIns",$c(0),$c(0),$c(0),"1.0","7","1",$c(0),$c(0),$c(0),$c(0),"1","5||1")
	s dimSN=$lb("WorkLoad_OrdDate","1","447","91","WorkLoad_RecDep_DR","2","448","4","WorkLoad_ItemOrd_DR","3","449","12","WorkLoad_ResDep_DR","4","450","4","WorkLoad_Type","5","451","12","WorkLoad_OrdTime","6","452","92","WorkLoad_StatDate","7","453","91","WorkLoad_StatTime","8","454","92","WorkLoad_ItemCat_DR","9","455","4","WorkLoad_BillGrp_DR","10","456","4","WorkLoad_BillSub_DR","11","457","12","WorkLoad_PAPMI_DR","12","458","4","WorkLoad_OrdStatus","13","459","12","WorkLoad_RecDoc_DR","14","460","12","WorkLoad_ResDoc_DR","15","461","12","WorkLoad_TarItem_DR","16","462","4","WorkLoad_PatDep_DR","17","463","4","WorkLoad_PatWard_DR","18","464","4","WorkLoad_PatDoc_DR","19","465","12","WorkLoad_Flag","20","466","12","WorkLoad_FlagDate","21","467","91","WorkLoad_ReceiptI_DR","22","468","12","WorkLoad_CasherO_DR","23","469","4","WorkLoad_UserDep_DR","24","470","4","WorkLoad_User_DR","25","471","4","WorkLoad_HoldFlag","26","472","12","WorkLoad_HoldFlagDate","27","473","91","WorkLoad_HoldDep_DR","28","474","4","WorkLoad_HoldDoc_DR","29","475","12","WorkLoad_ReceiptO_DR","30","476","12","WorkLoad_CasherI_DR","31","477","4","WorkLoad_DisDate","32","478","91","WorkLoad_DisFlag","33","479","12","WorkLoad_TarAC_dr","34","480","4","WorkLoad_TarSC_Dr","35","481","4","WorkLoad_TarOut_Dr","36","482","4","WorkLoad_TarEC_Dr","37","483","4","WorkLoad_TarMC_Dr","38","484","4","WorkLoad_TarIC_Dr","39","485","4","WorkLoad_FlagTime","40","486","92","WorkLoad_DataType","41","487","12","WorkLoad_ResMedUnitCareProv_dr","42","488","12","WorkLoad_RecMedUnitCareProv_dr","43","489","12","WorkLoad_PatMedUnitCareProv_dr","44","490","12","WorkLoad_AdmReason_DR","45","491","8","WorkLoad_TarMCNew_Dr","46","492","12","WorkLoad_SocialStatus_DR","47","493","4","WorkLoad_PHCC_DR","48","494","12","WorkLoad_PHCD_DR","49","495","12","WorkLoad_PHCDF_DR","50","496","4","WorkLoad_PHCIN_DR","51","497","4","WorkLoad_PatRoom_DR","52","498","4","WorkLoad_PatBed_DR","53","499","12")
	d ..InsertRow(day,cubeId,cubePartPolice,dimRow,dimSN,"","","","","","")
}

// 适用于数据结构1

ClassMethod InsertRow(day As %Integer, cubeId, cubePartPolice As CubeDBDPPart, dimRow As %List, dimSN As %List, metricRow As %List, metricSN As %List, dimRelaRow As %List, dimRelaSN As %List, tmpSubscript As %Integer, ByRef dataLog As DHCWL.DM.T.DataLog) As %Status [ Private ]
{
	s dimLen=$ll(dimSN),metricLen=$ll(metricSN),dimRelaLen=$ll(dimRelaSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s action=1,part=cubePartPolice.GetPartition()
	k indAndBit,indBit,dimIndMatchMap
	s maxDimLenStore=32
	s indAndBitFlag=1,matchedAllDimFlag=1
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn),dimId=$lg(dimSN,i+2)
	  s:((dt=91)&&(dimV'="")&&(dimV'=$c(0))&&(+dimV'=dimV)) dimV=..FormatDateToCache(dimV)
	  s:dimV="" dimV=$c(0)
	  if ( ($d(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV))) ){
	    k indBit
	    m indBit=^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV)
	    i indAndBitFlag=1 {
	      m indAndBit=indBit
	      s indAndBitFlag=0
	    }else{
	      s segInd2="" f  {
			    s segInd2=$o(indBit(segInd2))
			    q:segInd2=""
			    s:'$d(indAndBit(segInd2)) indAndBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	      s segInd2="" f  {
			    s segInd2=$o(indAndBit(segInd2))
			    q:segInd2="" 
			    s:'$d(indBit(segInd2)) indBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	    }
	    /*s segBitFound=0,segInd="" f{
			  s segInd=$o(indAndBit(segInd))
			  q:segInd=""
	      s:$bitfind(indAndBit(segInd),1)>0 segBitFound=segBitFound+1
	    }
	    q:segBitFound=0*/
	  }else{
		  s matchedAllDimFlag=0
		  q   
	  }
	}
	s oneNum=0,onePos=0,oneSeg=0,dimIndexMatchNum=0
	if (matchedAllDimFlag=1)  {
	  s segInd="" f{
			s segInd=$o(indAndBit(segInd))
			q:segInd=""
		  s onePos2=$bitfind(indAndBit(segInd),1)
	    if onePos2>0 {
	      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	    }
	  }
	}
	;w oneNum
	;q $$$OK
	if oneNum=0 {
	  if dimNum<=maxDimLenStore{
			if ($d(^||tmp("PCSI",tmpSubscript,1,dimRow))){
			  s oneNum=2
			  s crowid=^||tmp("PCSI",tmpSubscript,1,dimRow)
	    }
	  }else{
			s crowid2="" f{
			  s crowid2=$o(^||tmp("PCSI",tmpSubscript,0,crowid2))
			  q:crowid2=""
			  s dimRow2=^||tmp("PCSI",tmpSubscript,0,crowid2,"D")
			  if $ls(dimRow,dimRow2){
				  s oneNum=2
					s crowid=crowid2
					q
			  }
			}
	  }
	}
	i oneNum=1 {// alreay dim and insert metrics
	  s action=0
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  ;s partInd=crowid # ..#MAXPARTIONNUM
	  i $d(^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid)) d metricStructBuildIns1
	}elseif oneNum=2{
	  s action=0
	  d metricStructBuildIns1
	}
	i action=1 { //insert
	  s crowid=cubePartPolice.GetId()
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  d ##class(CubeDCDIDLog).Insert(day,cubeId,part,crowid)
	  //update index
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1), dt=$lg(dimSN,i+3)
	    s dimV=$lg(dimRow,sn)
	    i (dt=91)&&(dimV'="")&&(dimV'=$c(0)) &&(+dimV'=dimV) {
	      s dimV=..FormatDateToCache(dimV)
	      s $list(dimRow,sn)=dimV
	    }
	    if dimV="" {
		  	s dimV=$c(0)
		  	;s $list(dimRow,sn)=dimV
	    }
	    s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV,segNum),segInInd)=1
	  }
	  s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid)=dimRow
	  s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0)=$lb(0,0,0)
	  d metricStructBuildIns1
	}
	q $$$OK
metricStructBuildIns1
    s ^||tmp("PCSI",tmpSubscript,0,crowid)=action
    s mrind=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)+1
    s ^||tmp("PCSI",tmpSubscript,0,crowid,"M",mrind)=metricRow
    s ^||tmp("PCSI",tmpSubscript,0,crowid,"R",mrind)=dimRelaRow
    s ^||tmp("PCSI",tmpSubscript,0,crowid,0)=mrind
    if (action=1) {
		  s ^||tmp("PCSI",tmpSubscript,0,crowid,"D")=dimRow
		  s:dimNum<=maxDimLenStore ^||tmp("PCSI",tmpSubscript,1,dimRow)=crowid
    }
    q
}

/// 将数据生成算法改成批量方式以便提高效率，减少磁盘占用率（非空间）：先做簿记、然后根据簿记分别批量生成度量、关系、关系索引
ClassMethod InsertRow2(day As %Integer, cubeId, cubePartPolice As CubeDBDPPart, dimRow As %List, dimSN As %List, metricRow As %List, metricSN As %List, dimRelaRow As %List, dimRelaSN As %List, tmpSubscript As %Integer) As %Status [ Private ]
{
	s dimLen=$ll(dimSN),metricLen=$ll(metricSN),dimRelaLen=$ll(dimRelaSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s action=1,part=cubePartPolice.GetPartition()
	k indAndBit,indBit,dimIndMatchMap
	s indAndBitFlag=1,matchedAllDimFlag=1
	s t1=$p($zts,",",2)
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn),dimId=$lg(dimSN,i+2)
	  s:((dt=91)&&(dimV'="") && (+dimV'=dimV)) dimV=..FormatDateToCache(dimV)
	  s:dimV="" dimV=$c(0)
	  if ( ($d(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV))) ){
	    k indBit
	    m indBit=^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV)
	    i indAndBitFlag=1 {
	      m indAndBit=indBit
	      s indAndBitFlag=0
	    }else{
	      s segInd2="" f  {
			    s segInd2=$o(indBit(segInd2))
			    q:segInd2=""
			    s:'$d(indAndBit(segInd2)) indAndBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	      s segInd2="" f  {
			    s segInd2=$o(indAndBit(segInd2))
			    q:segInd2="" 
			    s:'$d(indBit(segInd2)) indBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	    }
	    s segBitFound=0,segInd="" f{
		  s segInd=$o(indAndBit(segInd))
		  q:segInd=""
	      s:$bitfind(indAndBit(segInd),1)>0 segBitFound=segBitFound+1
	    }
	    q:segBitFound=0
	  }else{
		  s matchedAllDimFlag=0
		  q   
	  }
	}
	s oneNum=0,onePos=0,oneSeg=0,dimIndexMatchNum=0
	if (matchedAllDimFlag=1)  {
	  s segInd="" f{
			s segInd=$o(indAndBit(segInd))
			q:segInd=""
		  s onePos2=$bitfind(indAndBit(segInd),1)
	    if onePos2>0 {
	      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	    }
	  }
	}
	;w oneNum
	;q $$$OK
	if oneNum=0 {
	  if dimNum<=80{
			if ($d(^||tmp("PCSI",tmpSubscript,1,dimRow))){
			  s oneNum=2
			  s crowid=^||tmp("PCSI",tmpSubscript,1,dimRow)
	    }
	  }else{
			s crowid2="" f{
			  s crowid2=$o(^||tmp("PCSI",tmpSubscript,0,crowid2))
			  q:crowid2=""
			  s dimRow2=^||tmp("PCSI",tmpSubscript,0,crowid2,"D")
			  if $ls(dimRow,dimRow2){
					s crowid=crowid2
					q
			  }
			}
	  }
	}
  s t2=$p($zts,",",2)
	i oneNum=1 {// alreay dim and insert metrics
	  s action=0
	  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
	  ;s partInd=crowid # ..#MAXPARTIONNUM
	  i $d(^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid)) d metricStructBuildIns2
	}elseif oneNum=2{
	  s action=0
	  d metricStructBuildIns2
	}
	i action=1 { //insert
	  s crowid=cubePartPolice.GetId()
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid#..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  //update index
	  f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	    s sn=$lg(dimSN,i+1), dt=$lg(dimSN,i+3)
	    s dimV=$lg(dimRow,sn)
	    i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
	      s dimV=..FormatDateToCache(dimV)
	      s $list(dimRow,sn)=dimV
	    }
	    if dimV="" {
		  	s dimV=$c(0)
		  	s $list(dimRow,sn)=dimV
	    }
	    s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeId,sn,dimV,segNum),segInInd)=1
	  }
	  s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid)=dimRow
	  s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0)=$lb(0,0,0)
	  d metricStructBuildIns2
	  //dimRelation for dim index build
      /*f i=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	    s sn=$lg(dimRelaSN,i+1),rdimV=$lg(dimRelaRow,sn)
	    s:rdimV="" rdimV=$c(0)
	    //s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeId,-sn,rdimV,"I",segNum),segInInd)=1
	    //s ^DHCWL.DM.T.CubeDStructI(part,cubeId,-sn,rdimV,crowid)=""
	    s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,-sn,rdimV)=""
      }*/
	}
	s t3=$p($zts,",",2)
	;w t2-t1,";",(t3-t2),!
	q $$$OK
metricStructBuildIns2
     
    s ^||tmp("PCSI",tmpSubscript,0,crowid)=action
    s mrind=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)+1
    s ^||tmp("PCSI",tmpSubscript,0,crowid,"M",mrind)=metricRow
    s ^||tmp("PCSI",tmpSubscript,0,crowid,"R",mrind)=dimRelaRow
    s ^||tmp("PCSI",tmpSubscript,0,crowid,0)=mrind
    if (action=1) {
	  s ^||tmp("PCSI",tmpSubscript,0,crowid,"D")=dimRow
	  s:dimNum<=80 ^||tmp("PCSI",tmpSubscript,1,dimRow)=crowid
    }
    q
    //dimRelation  index build 
    s segNum=crowid \ ..#MAXBITRANGE
	s segInInd=crowid # ..#MAXBITRANGE
	i segInInd=0 {
	  s segInInd=..#MAXBITRANGE
	  s segNum=segNum-1
	}
    s rowmopsl=$lg(^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0),$lb(0,0,0))
    s $list(rowmopsl,1)=$lg(rowmopsl,1,0)+1
    s $list(rowmopsl,2)=$lg(rowmopsl,2,0)+1
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
	  s sn=$lg(metricSN,i+1)
	  s mv=+$lg(metricRow,sn,"")
	  s rowmsl=$g(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,1),$lb(0,0))
	  s mli=$lg(rowmsl,1)
	  s mll=$lg(rowmsl,2)+1
	  try{
	    //s $list(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,2,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
	    s mll=1
	    //s $list(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,2,mli),mll)=mv
	  }
	  s $list(rowmsl,1)=mli
	  s $list(rowmsl,2)=mll
	  //s ^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,1)=rowmsl
	  //d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,sn,mli,mll)
	  //start dimRelation for metric index build
      f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	    s rsn=$lg(dimRelaSN,j+1)
	    s rdimV=$lg(dimRelaRow,rsn)
	    s:rdimV="" rdimV=$c(0)
	    //s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,rsn,rdimV,crowid,sn,mli,mll)=""
      }
      //end dimRelation for metric index build
    }
    
    f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	  s rsn=$lg(dimRelaSN,j+1)
	  s rdimV=$lg(dimRelaRow,rsn)
	  s:rdimV="" rdimV=$c(0)
	  s rowrsl=$g(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn),$lb(0,0))
	  s rseg=$lg(rowrsl,1)
	  s rsegInd=$lg(rowrsl,2)+1
	  try{
		//s $list(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn,rseg),rsegInd)=rdimV
	  }catch(e){
		s rseg=rseg+1
		s rsegInd=1
		//s $list(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn,rseg),rsegInd)=rdimV
	  }
	  //s ^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn)=$lb(rseg,rsegInd)
	  //d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,rsn,rseg,rsegInd)
    }
    
    /*s metricLength=$lg(rowmsl,1,0)
    s metSegNum=metricLength \ ..#MAXBITRANGE
	s metSegInInd=metricLength #..#MAXBITRANGE
	i metSegInInd=0 {
	  s metSegInInd=..#MAXBITRANGE
	  s metSegNum=metSegNum-1
	}*/
	//dimRelation metric value index build
	
    //s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0)=rowmopsl
    q
}

// 适用于数据结构1

ClassMethod BatchInsertRow(day As %Integer, cubeId, cubePartPolice As CubeDBDPPart, dimSN As %List, metricSN As %List, dimRelaSN As %List, tmpSubscript As %Integer, ByRef dataLog As DHCWL.DM.T.DataLog) [ Private ]
{
    q:'$d(^||tmp("PCSI",tmpSubscript))
    s dimLen=$ll(dimSN),metricLen=$ll(metricSN),dimRelaLen=$ll(dimRelaSN)
		s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
		s part=cubePartPolice.GetPartition()
    s crowid="" f {
		  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
		  q:crowid=""
		  s segNum=crowid \ ..#MAXBITRANGE
		  s segInInd=crowid # ..#MAXBITRANGE
		  i segInInd=0 {
		    s segInInd=..#MAXBITRANGE
		    s segNum=segNum-1
		  }
		  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
		  f batchInd=1:1:batchNum{
				s metricRow=^||tmp("PCSI",tmpSubscript,0,crowid,"M",batchInd)
				;s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
				d BatchMetricIns1
		  }
    }
    d dataLog.Touch("BM")
    s crowid="" f {
		  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
		  q:crowid=""
		  s segNum=crowid \ ..#MAXBITRANGE
		  s segInInd=crowid # ..#MAXBITRANGE
		  i segInInd=0 {
		    s segInInd=..#MAXBITRANGE
		    s segNum=segNum-1
		  }
		  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
		  f batchInd=1:1:batchNum{
				s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
				d BatchRelationIns1
		  }
    }
    d dataLog.Touch("BR")
    
    s crowid="" f {
		  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
		  q:crowid=""
		  s segNum=crowid \ ..#MAXBITRANGE
		  s segInInd=crowid # ..#MAXBITRANGE
		  i segInInd=0 {
		    s segInInd=..#MAXBITRANGE
		    s segNum=segNum-1
		  }
		  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
		  f batchInd=1:1:batchNum{
				s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
				;b:cubeId=5 ;1
				d BatchRelationIndIns1
		  }
    }
    //d BatchRelationIndIns12
    d dataLog.Touch("BRI")
    q
BatchMetricIns1
    s rowmopsl=$lg(^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0),$lb(0,0,0))
    s $list(rowmopsl,1)=$lg(rowmopsl,1,0)+1
    s $list(rowmopsl,2)=$lg(rowmopsl,2,0)+1
    s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0)=rowmopsl
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
		  s sn=$lg(metricSN,i+1)
		  s mv=+$lg(metricRow,sn,"")
		  s rowmsl=$g(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,sn),$lb(0,0))
		  s mli=$lg(rowmsl,1)
		  s mll=$lg(rowmsl,2)+1
		  try{
		    s $list(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,sn,mli),mll)=mv
		  }catch(e){
				;w "increate metric seg index",!,e,!
				s mli=mli+1
		    s mll=1
		    s $list(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,sn,mli),mll)=mv
		  }
		  s $list(rowmsl,1)=mli
		  s $list(rowmsl,2)=mll
		  s ^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,sn)=rowmsl
		  ;d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,sn,mli,mll)
		  s ^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,sn)=$lb(mli,mll)
      //end dimRelation for metric index build
    }
    q
BatchRelationIns1
    f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
		  //w "dimRelaSN:"_$ll(dimRelaSN),!
		  s rsn=$lg(dimRelaSN,j+1)
		  s rsn2=-rsn
		  continue:rsn=""
		  s rdimV=$lg(dimRelaRow,rsn)
		  s:rdimV="" rdimV=$c(0)
		  s rowrsl=$g(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,rsn2),$lb(0,0))
		  s rseg=$lg(rowrsl,1)
		  s rsegInd=$lg(rowrsl,2)+1
		  try{
				s $list(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,rsn2,rseg),rsegInd)=rdimV
		  }catch(e){
				s rseg=rseg+1
				s rsegInd=1
				s $list(^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,rsn2,rseg),rsegInd)=rdimV
		  }
		  s ^DHCWL.DM.T.CubeDStructV(part,cubeId,crowid,rsn2)=$lb(rseg,rsegInd)
		  ;d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,rsn2,rseg,rsegInd)
    }
    q
BatchRelationIndIns1
    f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	  	//w "dimRelaSN:"_$ll(dimRelaSN),!
	  	s rsn=$lg(dimRelaSN,j+1)
	  	s rsn2=-rsn
	  	continue:rsn=""
	  	s rdimV=$lg(dimRelaRow,rsn)
	  	s:rdimV="" rdimV=$c(0)
	  	s msn="" f{
	    	s msn=$o(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn))
	    	q:msn=""
	    	s mli=$lg(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn),1)
	    	s mll=$lg(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn),2)
	    	s crid=$g(^DHCWL.DM.T.CubeDStructIR(part,cubeId,0,rsn,rdimV,crowid),0)
	    	if crid=0{
		    	s crid=$i(^DHCWL.DM.T.CubeDStructIR(part,cubeId,0))
		    	;s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,0,rsn,rdimV,0)=crid
		    	;s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,0,rsn,rdimV,1)=crowid
		    	s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,0,rsn,rdimV,crowid)=crid
	    	}
	    	;s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,1,crid,msn,mli),mll)=1
				s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,1,msn,crid,mli),mll)=1
				//s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,rsn,rdimV,msn,crowid,mli),mll)=1
	    	//s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,msn,mli),mll)=1
	    	/*s rdseg=$g(^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid),0)
	    	s rdseglist=$g(^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg),$lb())
	    	s rdseglind=$ll(rdseglist)
	    	try{
		    	s $list(rdseglist,rdseglind)=msn
		    	s $list(rdseglist,rdseglind+1)=mli
		    	s $list(rdseglist,rdseglind+2)=mll
		    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg)=rdseglist
	    	}catch(e){
		    	s rdseg=rdseg+1
		    	s rdseglist=$lb()
		    	s rdseglind=1
		    	s $list(rdseglist,rdseglind)=msn
		    	s $list(rdseglist,rdseglind+1)=mli
		    	s $list(rdseglist,rdseglind+2)=mll
		    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg)=rdseglist
		    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid)=rdseg
	    	}
	    	*/
	  	}
    }
    q
BatchRelationIndIns12
		f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	  	//w "dimRelaSN:"_$ll(dimRelaSN),!
	  	s rsn=$lg(dimRelaSN,j+1)
	  	s rsn2=-rsn
	  	continue:rsn=""
	  	s crowid="" f {
			  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
			  q:crowid=""
			  s segNum=crowid \ ..#MAXBITRANGE
			  s segInInd=crowid # ..#MAXBITRANGE
			  i segInInd=0 {
			    s segInInd=..#MAXBITRANGE
			    s segNum=segNum-1
			  }
			  f batchInd=1:1:batchNum{
					s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
					s rdimV=$lg(dimRelaRow,rsn)
	  			s:rdimV="" rdimV=$c(0)
	  			s msn="" f{
			    	s msn=$o(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn))
			    	q:msn=""
			    	s ^||tmp("PCSI",tmpSubscript,3,rsn,rdimV,crowid,msn)=^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn)
	  			}
			  }
	  	}
		}
		s rsn="" f{
			s rsn=$o(^||tmp("PCSI",tmpSubscript,3,rsn))
			q:rsn=""
			s rsn2=-rsn
			s rdimV="" f{
				s rdimV=$o(^||tmp("PCSI",tmpSubscript,3,rsn,rdimV))
				q:rdimV=""
				s crowid="" f{
					s crowid=$o(^||tmp("PCSI",tmpSubscript,3,rsn,rdimV,crowid))
					q:crowid=""
					f batchInd=1:1:batchNum{
						s msn="" f{
							s msn=$o(^||tmp("PCSI",tmpSubscript,3,rsn,rdimV,crowid,msn))
							q:msn=""
							s mli=$lg(^||tmp("PCSI",tmpSubscript,3,rsn,rdimV,crowid,msn),1)
							s mll=$lg(^||tmp("PCSI",tmpSubscript,3,rsn,rdimV,crowid,msn),2)
							s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,0,rsn,rdimV)=crowid
							s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,1,msn,crowid,mli),mll)=1
							//s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,rsn,rdimV,crowid,msn,mli),mll)=1
							//s ^DHCWL.DM.T.CubeDStructIR(part,cubeId,rsn2,rdimV,crowid,msn,mli,mll)=""
							/*s rdseg=$g(^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid),0)
				    	s rdseglist=$g(^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg),$lb())
				    	s rdseglind=$ll(rdseglist)
				    	try{
					    	s $list(rdseglist,rdseglind)=msn
					    	s $list(rdseglist,rdseglind+1)=mli
					    	s $list(rdseglist,rdseglind+2)=mll
					    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg)=rdseglist
				    	}catch(e){
					    	s rdseg=rdseg+1
					    	s rdseglist=$lb()
					    	s rdseglind=1
					    	s $list(rdseglist,rdseglind)=msn
					    	s $list(rdseglist,rdseglind+1)=mli
					    	s $list(rdseglist,rdseglind+2)=mll
					    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid,rdseg)=rdseglist
					    	s ^DHCWL.DM.T.CubeDStructI(part,cubeId,rsn2,rdimV,crowid)=rdseg
				    	}
				    	*/
						}
					}
				}
			}
		}
		q
}

ClassMethod BatchInsertRow2(day As %Integer, cubeId, cubePartPolice As CubeDBDPPart, dimSN As %List, metricSN As %List, dimRelaSN As %List, tmpSubscript As %Integer) [ Private ]
{
    q:'$d(^||tmp("PCSI",tmpSubscript))
    s dimLen=$ll(dimSN),metricLen=$ll(metricSN),dimRelaLen=$ll(dimRelaSN)
	s dimNum=dimLen/..#DIMSTRUCTLISTUNIT,metricNum=metricLen /..#DIMSTRUCTLISTUNIT
	s part=cubePartPolice.GetPartition()
    s crowid="" f {
	  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
	  q:crowid=""
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid # ..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
	  f batchInd=1:1:batchNum{
		s metricRow=^||tmp("PCSI",tmpSubscript,0,crowid,"M",batchInd)
		;s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
		d BatchMetricIns
	  }
    }
    s crowid="" f {
	  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
	  q:crowid=""
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid # ..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
	  f batchInd=1:1:batchNum{
		s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
		d BatchRelationIns
	  }
    }
    s crowid="" f {
	  s crowid=$o(^||tmp("PCSI",tmpSubscript,0,crowid))
	  q:crowid=""
	  s segNum=crowid \ ..#MAXBITRANGE
	  s segInInd=crowid # ..#MAXBITRANGE
	  i segInInd=0 {
	    s segInInd=..#MAXBITRANGE
	    s segNum=segNum-1
	  }
	  s batchNum=$g(^||tmp("PCSI",tmpSubscript,0,crowid,0),0)
	  f batchInd=1:1:batchNum{
		s dimRelaRow=^||tmp("PCSI",tmpSubscript,0,crowid,"R",batchInd)
		d BatchRelationIndIns
	  }
    }
    q
BatchMetricIns
    s rowmopsl=$lg(^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0),$lb(0,0,0))
    s $list(rowmopsl,1)=$lg(rowmopsl,1,0)+1
    s $list(rowmopsl,2)=$lg(rowmopsl,2,0)+1
    s ^DHCWL.DM.T.CubeDStructD(part,cubeId,crowid,0)=rowmopsl
    f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
	  s sn=$lg(metricSN,i+1)
	  s mv=+$lg(metricRow,sn,"")
	  s rowmsl=$g(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn),$lb(0,0))
	  s mli=$lg(rowmsl,1)
	  s mll=$lg(rowmsl,2)+1
	  try{
	    s $list(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,mli),mll)=mv
	  }catch(e){
		;w "increate metric seg index",!,e,!
		s mli=mli+1
	    s mll=1
	    s $list(^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn,mli),mll)=mv
	  }
	  s $list(rowmsl,1)=mli
	  s $list(rowmsl,2)=mll
	  s ^DHCWL.DM.T.CubeDStructM(part,cubeId,crowid,sn)=rowmsl
	  d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,sn,mli,mll)
	  s ^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,sn)=$lb(mli,mll)
      //end dimRelation for metric index build
    }
    q
BatchRelationIns
    f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	  //w "dimRelaSN:"_$ll(dimRelaSN),!
	  s rsn=$lg(dimRelaSN,j+1)
	  continue:rsn=""
	  s rdimV=$lg(dimRelaRow,rsn)
	  s:rdimV="" rdimV=$c(0)
	  s rowrsl=$g(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn),$lb(0,0))
	  s rseg=$lg(rowrsl,1)
	  s rsegInd=$lg(rowrsl,2)+1
	  try{
		s $list(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn,rseg),rsegInd)=rdimV
	  }catch(e){
		s rseg=rseg+1
		s rsegInd=1
		s $list(^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn,rseg),rsegInd)=rdimV
	  }
	  s ^DHCWL.DM.T.CubeDStructR(part,cubeId,crowid,rsn)=$lb(rseg,rsegInd)
	  d ##class(CubeDCDIDLog).Create(day,cubeId,part,crowid,-rsn,rseg,rsegInd)
    }
    q
BatchRelationIndIns
    f j=1:..#DIMSTRUCTLISTUNIT:dimRelaLen{
	   //w "dimRelaSN:"_$ll(dimRelaSN),!
	   s rsn=$lg(dimRelaSN,j+1)
	   continue:rsn=""
	   s rdimV=$lg(dimRelaRow,rsn)
	   s:rdimV="" rdimV=$c(0)
	   s msn="" f{
	     s msn=$o(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn))
	     q:msn=""
	     s mli=$lg(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn),1)
	     s mll=$lg(^||tmp("PCSI",tmpSubscript,0,crowid,"MR",batchInd,msn),2)
	     s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeId,rsn,rdimV,crowid,msn,mli),mll)=1
	   }
    }
    q
}

// d ##class(DHCWL.DM.T.CubeDStruct).FormatDateToCache("2013-01-01")

ClassMethod FormatDateToCache(dateStr) As %Integer
{
	s ppe="",pe="",dele="-"
	s len=$l(dateStr),result=""
	f i=1:1:len {
	  s ppe=pe
	  s pe=$e(dateStr,i)
	  i ($ascii(pe)>47)&&($ascii(pe)<58) {
		s result=result_pe  ;保留数字字符
	  }else{
	    s:ppe'=pe result=result_dele
	  }
	}
    s y=$p(result,"-",1),m=$p(result,"-",2),d=$p(result,"-",3)
    
	s:$l(y)=2 y="20"_y
	s:$l(m)=1 m="0"_m
	s:$l(d)=1 d="0"_d
	s dh=0
	try{
	  s dh= $zdh(y_"-"_m_"-"_d,3)	
	}catch(e){
		
	}
	q dh
}

ClassMethod RealTimeThemeDataFetch(stream As %Stream.GlobalBinary, cubeMask As %Integer, dimMask, dimSN As %List, metricSN As %List) As %Status
{
	d stream.Rewind()
	s dimLen=$ll(dimSN)
	k dcvtmaps //date formate convert map struct
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1), dt=$lg(dimSN,i+3)
	  i (dt=91){
		s dcvtmaps(sn)=""
		;w "91",!
	  }
	}
	while('stream.AtEnd){
	  s dimRow=stream.ReadLine()
	  s metricRow=stream.ReadLine()
	  s sn="" f{
		s sn=$o(dcvtmaps(sn))
		q:sn=""
		s dimdv=$lg(dimRow,sn,"")
		i (dimdv'="") && (+dimdv'=dimdv) {
		  s $list(dimRow,sn)=$zdh(dimdv,3)
		}
	  }
	  if (($lv(dimRow))&&($lv(metricRow))){
		d ##class(DHCWL.DM.Core.PhysicalExecutor).UpsertRow(cubeMask,dimMask,0,dimRow,metricRow)
	  }
	}
	d stream.Clear()
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteThemeCubeTest()

ClassMethod DeleteThemeCubeTest()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	;w stream.%Location,!
	;s stream.%Location="^lhh(2)"
	/*
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","4764","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","64","2","264588","4||1","264588||2||1","4||1||6"))
	d stream.WriteLine($lb(122,1,122,0,0,122))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","65","2","264588","4||1","264588||3||1","4||1||1"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","4764","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","66","2","264588","4||1","264588||4||1","4||1||2"))
	d stream.WriteLine($lb(122,1,122,0,0,122))
	d stream.WriteLine($lb("2018-03-23","156","11592||1","156","I","15:06:00","2018-03-24","02:00:00","81","9","9||1","59","P","","1","7986","156","236","1","","","","","","","","","","","","","","","12","13","13","28","3","13","","BillIns","","","","1.0","3","1","","","","","5","44||4","125","22","264620","12||11","264620||2||1","12||11||1"))
	d stream.WriteLine($lb(1.34,-1,-1.34,0,0,-1.34))
	d stream.WriteLine($lb("2018-03-23","156","11592||1","156","I","15:08:53","2018-03-24","02:00:00","81","9","9||1","59","P","","1","7986","156","236","1","","","","","","","","","","","","","","","12","13","13","28","3","13","","BillIns","","","","1.0","3","1","","","","","5","44||4","127","22","264620","12||13","264620||4||1","12||13||1"))
	d stream.WriteLine($lb(1.34,-1,-1.34,0,0,-1.34))
	d stream.WriteLine($lb("2018-03-23","311","685||1","156","I","14:46:45","2018-03-24","02:00:00","1","1","1||1","59","P","","1","685","156","236","1","","","","","","","","","","","","","","","1","1","1","1","16","1","","BillIns","","","","1.0","16","1","185","685||1","20","12","5","44||4","134","22","264620","12||2","264620||10||1","12||2||2"))
	d stream.WriteLine($lb(.029,2,.06,0,0,.06))
	d stream.WriteLine($lb("2018-03-23","311","685||1","156","I","14:46:45","2018-03-24","02:00:00","1","1","1||1","59","P","","1","685","156","236","1","","","","","","","","","","","","","","","1","1","1","1","16","1","","BillIns","","","","1.0","16","1","185","685||1","20","12","5","44||4","135","22","264620","12||2","264620||11||1","12||2||3"))
	d stream.WriteLine($lb(.029,2,.06,0,0,.06))
	*/
	//*
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	d stream.WriteLine($lb("2018-03-23","329","11502||1","110","I","14:22:26","2018-03-24","02:00:00","22","3","3||3","35","P","","1","7936","110","197","1","","","","","","","","","","","","","","","5","5","5","11","7","5","","BillIns","","","","1.0","7","1","","","","","1","5||1","63","2","264588","4||1","264588||1||1","4||1||5"))
	d stream.WriteLine($lb(120,1,120,0,0,120))
	//*/
	d stream.%Save()
	d ..DeleteThemeCube("/WorkLoad.t","2018-03-23",stream)
	d stream.Clear()
	s stream=""
}

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteThemeCube("/WorkLoad.t","2013-01-01","2013-01-01")

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteThemeCube("/DHCMRInfo.t","2016-03-07","2016-03-08")

ClassMethod DeleteThemeCube(themePath, day, stream As %Stream.GlobalBinary, targetCubeMask = "", destroyResouceFlag As %Boolean = 1) As %Status
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	s day=$zdh(day,3)
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  continue:(targetCubeMask'="")&&(cubeMask'=targetCubeMask)
	  s dimSN=cube.GetDimStructMap()
	  s metricSN=cube.GetMetricStructMap()
	  s dimRelaSN=cube.GetDimStructMap(1)
	  s dimSNLen=$ll(dimSN),metricSNLen=$ll(metricSN),dimRelaSNLen=$ll(dimRelaSN)
	  s:dimSNLen=1 dimSNLen=0
	  s:metricSNLen=1 metricSNLen=0
	  s:dimRelaSNLen=1 dimRelaSNLen=0
	  s dimList=cube.GetDims()
	  s metricList=cube.GetMetrics()
	  ;k dimC2TSNMap,metricC2TSNMap,dimRelC2TSNMap
	  s dimC2TSNList=$lb(),metricC2TSNList=$lb(),dimRelC2TSNList=$lb()
	  s dimC2TSNListLen=0,metricC2TSNListLen=0,dimRelC2TSNListLen=0
	  f j=1:1:dimList.Count() {
			s dim=dimList.GetAt(j)
			continue:dim=""
			continue:dim.GetDimTypeCode()="R"
			s dimC2TSNListLen=dimC2TSNListLen+1
			s $list(dimC2TSNList,dimC2TSNListLen)=dim.SerialNumber
			s dimC2TSNListLen=dimC2TSNListLen+1
			s $list(dimC2TSNList,dimC2TSNListLen)=dim.DimPro.SerialNumber
	  }
	  f j=1:1:dimList.Count() {
			s dim=dimList.GetAt(j)
			continue:dim=""
			continue:dim.GetDimTypeCode()'="R"
			s dimRelC2TSNListLen=dimRelC2TSNListLen+1
			s $list(dimRelC2TSNList,dimRelC2TSNListLen)=dim.SerialNumber
			s dimRelC2TSNListLen=dimRelC2TSNListLen+1
			s $list(dimRelC2TSNList,dimRelC2TSNListLen)=dim.DimPro.SerialNumber
	  }
	  f j=1:1:metricList.Count() {
			s metric=metricList.GetAt(j)
			s metricC2TSNListLen=metricC2TSNListLen+1
			s $list(metricC2TSNList,metricC2TSNListLen)=metric.SerialNumber
			s metricC2TSNListLen=metricC2TSNListLen+1
			s $list(metricC2TSNList,metricC2TSNListLen)=metric.MetricPro.SerialNumber
	  }
	  ;w "dimRelaSN"_$lts(dimRelaSN,",",1),!
	  ;w "dimRelC2TSNList:"_$lts(dimRelC2TSNList,",",1),!
	  s partId=##class(CubeDCDIDLog).GetPart(day,cubeMask)
	  continue:partId=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,partId)
	  d stream.Rewind()
	  s dataLog=##class(DataLog).StartLog("CUBEDSTRUCTI",cubeMask)
	  while('stream.AtEnd){
	    s themeDimRow=stream.ReadLine()
	    s themeMetricRow=stream.ReadLine()
	    if (($lv(themeDimRow))&&($lv(themeMetricRow))){
			  s dimRow=$lb(),metricRow=$lb(),dimRelaRow=$lb()
			  f j=1:2:dimC2TSNListLen{
				  s sn=$lg(dimC2TSNList,j),sn2=$lg(dimC2TSNList,j+1)
				  s $list(dimRow,sn)=$lg(themeDimRow,sn2)
			  }
			  f j=1:2:dimRelC2TSNListLen{
				  s sn=$lg(dimRelC2TSNList,j),sn2=$lg(dimRelC2TSNList,j+1)
				  s $list(dimRelaRow,sn)=$lg(themeDimRow,sn2)
			  }
			  f j=1:2:metricC2TSNListLen{
				  s sn=$lg(metricC2TSNList,j),sn2=$lg(metricC2TSNList,j+1)
				  s $list(metricRow,sn)=$lg(themeMetricRow,sn2)
			  }
			  d ..DeleteRow(day,cubeMask,partPolice,dimSN,dimSNLen,metricSN,metricSNLen,dimRelaSN,dimRelaSNLen,dimRow,metricRow,dimRelaRow)
	    }
	  }
	  d dataLog.CommitLog("D",themePath_";"_$zd(day,3),partPolice.GetPartition())
	  //tc
	  d partPolice.Commit()
	}
	if (destroyResouceFlag){
		d stream.Clear()
		s stream=""
	}
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).DeleteCubeFetchConfigTest()

ClassMethod DeleteCubeFetchConfigTest()
{
	k ^lhh
	s stream=##class(%Stream.GlobalBinary).%New()
	d stream.WriteLine($lb("2016-06-29","BFCode||424","","BFCode||424","BFCode||52","BFCode||52","BFCode||52","BFCode||2","BFCode||2","BFCode||2","BFCode||10","BFCode||10","","2016-06-29","BFCode||1","10:32:16.000","O","","","BFCode||14","BFCode||10371||1","BFCode||288","","BFCode||68","BFCode||68||2","","2018-08-20","17:29:13.000","","","","BFCode||52","BFCode||2","","","","","","","2016-06","10:32:17.000","Y","239703||1||1","","Y","2016-06","06:09:02.000","BFCode||27","BFCode||33","","OutBillIns","BFCode||24","BFCode||34","","2016-06-29","124||1","10:32:16.000","BFCode||23","BFCode||27","","","2016-06","10:32:16.000","1","","239703","1","","","0000000139","","239703||1||1","","","","","","","","7","","","0","","BFCode||16","BFCode||3235","BFCode||24","BFCode||10","BFCode||10","2018-08-20","17:29:30.000","OutBillIns-239703||1||1-0"))
	d stream.WriteLine($lb("","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""))
	d stream.WriteLine($lb(3,3,3,0,0,1))
	//*/
	
	d stream.%Save()
	d ..DeleteByCubeFetchConfig("DHCWorkLoad_OrdDate","2016-06-29",stream)
	d stream.Clear()
	s stream=""
}

ClassMethod DeleteByCubeFetchConfig(cubeCode, day, stream As %Stream.GlobalBinary) As %Status
{
		s cube=##class(CubeBase).GetByCode(cubeCode)
		q:cube="" $$$ERROR("Can't get cube with code "_cubeCode)
		s dayStr=day
		s day=$zdh(day,3)
		s dimSN=cube.GetDimStructMap()
	  s metricSN=cube.GetMetricStructMap()
	  s dimRelaSN=cube.GetDimStructMap(1)
	  s dimSNLen=$ll(dimSN),metricSNLen=$ll(metricSN),dimRelaSNLen=$ll(dimRelaSN)
	  s:dimSNLen=1 dimSNLen=0
	  s:metricSNLen=1 metricSNLen=0
	  s:dimRelaSNLen=1 dimRelaSNLen=0
		s cubeMask=cube.Mask()
		s partPolice=##class(CubeDBDPPart).ChoicePart(cubeMask)
		s dataLog=##class(DataLog).StartLog("CUBEDSTRUCTD",cubeCode)
	  d stream.Rewind()
		while('stream.AtEnd){
			s dimList=stream.ReadLine()
			s dimRList=stream.ReadLine()
	    s metricList=stream.ReadLine()
	    d ..DeleteRow(day,cubeMask,partPolice,dimSN,dimSNLen,metricSN,metricSNLen,dimRelaSN,dimRelaSNLen,dimList,metricList,dimRList)
	    ;d ..InsertRow(day,cubeMask,partPolice,dimList,dimSN,metricList,metricSN,dimRList,dimRelaSN,cubeMask,.dataLog)
		}
		d dataLog.CommitLog("D",cubeCode_";"_$zd(day,3),partPolice.GetPartition())
	  //tc
	  d partPolice.Commit()
	  d stream.Clear()
		s stream=""
		q $$$OK
}

// 弃用

ClassMethod DeleteThemeCube2(themePath, startDate, endDate) As %Status
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	s sd=$zdh(startDate,3),ed=$zdh(endDate,3)
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  f j=sd:1:ed{
			d ..DeleteCubeByCD(cube,j)
	  }
	}
	q $$$OK
}

ClassMethod DeleteRow(day As %Integer, cubeMask, cubePartPolice As CubeDBDPPart, dimSN As %List, dimLen As %Integer, metricSN As %List, metricLen As %Integer, dimRelaSN As %List, dimRelaLen As %Integer, dimRow As %List, metricRow As %List, dimRelaRow As %List) As %Status [ Private ]
{
	s action=1,part=cubePartPolice.GetPartition()
	k indAndBit,indBit
	s indAndBitFlag=1,matchedAllDimFlag=1
	
	f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
	  s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3),dimV=$lg(dimRow,sn)
	  s:((dt=91)&&(dimV'="")&&(dimV'=$c(0))&&(+dimV'=dimV)) dimV=..FormatDateToCache(dimV)
	  s:dimV="" dimV=$c(0)
	  if ( ($d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn))) && ($d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV))) ){
	    k indBit
	    m indBit=^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
	    i indAndBitFlag=1 {
	      m indAndBit=indBit
	      s indAndBitFlag=0
	    }else{
	      s segInd2="" f  {
			    s segInd2=$o(indBit(segInd2))
			    q:segInd2=""
			    s:'$d(indAndBit(segInd2)) indAndBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	      s segInd2="" f  {
			    s segInd2=$o(indAndBit(segInd2))
			    q:segInd2="" 
			    s:'$d(indBit(segInd2)) indBit(segInd2)=""
			    s indAndBit(segInd2)=$bitlogic(indAndBit(segInd2) & indBit(segInd2) )
	      }
	    }
	    s segBitFound=0,segInd="" f{
			  s segInd=$o(indAndBit(segInd))
			  q:segInd=""
	      s:$bitfind(indAndBit(segInd),1)>0 segBitFound=segBitFound+1
	    }
	    q:segBitFound=0
	  }else{
		  s matchedAllDimFlag=0
		  q   
	  }
	}
	s oneNum=0,onePos=0,oneSeg=0
	if (matchedAllDimFlag=1)  {
	  s segInd="" f{
			s segInd=$o(indAndBit(segInd))
			q:segInd=""
		  s onePos2=$bitfind(indAndBit(segInd),1)
	    if onePos2>0 {
	      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
	    }
	  }
	}
	;b ;
	;b:cubeMask=5
	i oneNum=1 {
		s crowid=(oneSeg*..#MAXBITRANGE)+onePos
		i $d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,crowid)){
			s ciddeleteflag=0
			//delete metric values start
			if 1=0{  //dimRelaLen=0
				k delmetricmap
				f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
					s sn=$lg(metricSN,i+1)
					s mv=$lg(metricRow,sn)
					s delenum=0,valnum=0,deleflag=1
					s metricListSeg="" f{
						s metricListSeg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg))
						q:metricListSeg=""
						s segvalnum=0
						s mlist=^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg)
						f j=$ll(mlist):-1:1{
							if (deleflag)&&($lg(mlist,j)=mv){
								s $list(mlist,j)=$c(-1)
								s deleflag=0
								//mark deleted metrics info
								s delmetricmap(sn)=$lb(metricListSeg,j)
							}
							if $lg(mlist,j)=$c(-1){
								s delenum=delenum+1
							}else{
								s valnum=valnum+1,segvalnum=segvalnum+1
							}
						}
						if segvalnum=0{
							k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg)
						}else{
							s ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg)=mlist
						}
					}
					if valnum=0{
						s ciddeleteflag=1
						k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn)
					}
				}
			}else{
				//check relation dim can delete start
				if dimRelaLen=0{
					s ciddeleteflag=ciddeleteflag+1
				}
				k cssvt //column store struct vist trap
				f i=1:..#DIMSTRUCTLISTUNIT:dimRelaLen {
					s sn=$lg(dimRelaSN,i+1)
					s rseg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,-sn,""))
					s cssvt(sn)=$lb(rseg,0)
				}
				s runflag=dimRelaLen /..#DIMSTRUCTLISTUNIT
				while(runflag>0){
					s frlist=$lb()
					f i=1:..#DIMSTRUCTLISTUNIT:dimRelaLen {
						s sn=$lg(dimRelaSN,i+1)
						s rsn=-sn
						do{
							s seg=$lg(cssvt(sn),1)
							if seg=""{
								s runflag=runflag-1
								q
							}
							s segind=$lg(cssvt(sn),2)+1
							s seglist=^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg)
							s seglistlen=$ll(seglist)
							if segind>seglistlen{
								s seg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg))
								if seg=""{
									s runflag=runflag-1
									q
								}
								s $list(cssvt(sn),1)=seg
								s $list(cssvt(sn),2)=0
								continue
							}
							s v=$lg(seglist,segind)
							s $list(cssvt(sn),2)=segind
							continue:v=$c(-1)
							s $list(frlist,sn)=v
							q
						}while(1)
					}
					if $listsame(dimRelaRow,frlist){
						s ciddeleteflag=ciddeleteflag+1
						m usingreldseginfo=cssvt
						q
					}
				}
				//check relation dim can delete end
				//check metric can delete start
				if metricLen=0{
					s ciddeleteflag=ciddeleteflag+1
				}
				k cssvt //column store struct vist trap
				f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
					s sn=$lg(metricSN,i+1)
					s seg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,""))
					s cssvt(sn)=$lb(seg,0)
				}
				s runflag=metricLen /..#DIMSTRUCTLISTUNIT
				while(runflag>0){
					s frlist=$lb()
					f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
						s sn=$lg(metricSN,i+1)
						do{
							s seg=$lg(cssvt(sn),1)
							if seg=""{
								s runflag=runflag-1
								q
							}
							s segind=$lg(cssvt(sn),2)+1
							s seglist=^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,seg)
							s seglistlen=$ll(seglist)
							if segind>seglistlen{
								s seg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,seg))
								if seg=""{
									s runflag=runflag-1
									q
								}
								s $list(cssvt(sn),1)=seg
								s $list(cssvt(sn),2)=0
								continue
							}
							s v=$lg(seglist,segind)
							s $list(cssvt(sn),2)=segind
							continue:v=$c(-1)
							s $list(frlist,sn)=v
							q
						}while(1)
					}
					if $listsame(metricRow,frlist){
						s ciddeleteflag=ciddeleteflag+1
						m usingmetricseginfo=cssvt
						q
					}
				}
				//check metric can delete end
				;b:cubeMask=5
				q:ciddeleteflag<2
				f i=1:..#DIMSTRUCTLISTUNIT:metricLen {
					s sn=$lg(metricSN,i+1)
					s mv=$lg(metricRow,sn),tmsegind=$lg(usingmetricseginfo(sn),2,0),tmseg=$lg(usingmetricseginfo(sn),1,0),delenum=0,valnum=0
					s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,tmseg),tmsegind)=$c(-1)
					s metricListSeg="" f{
						s metricListSeg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg))
						q:metricListSeg=""
						s segvalnum=0
						s mlist=^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg)
						f j=$ll(mlist):-1:1{
							if $lg(mlist,j)=$c(-1) {
								s delenum=delenum+1
							}else{
								s valnum=valnum+1,segvalnum=segvalnum+1
							}
						}
						if segvalnum=0{
							k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,metricListSeg)
						}
					}
					if valnum=0{
						k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn)
						s ciddeleteflag=3
					}
				}
			}
			//delete metric values end
			//update cube relation dim start
			;b:cubeMask=5
			f i=1:..#DIMSTRUCTLISTUNIT:dimRelaLen {
				s sn=$lg(dimRelaSN,i+1)
				s dimRV=$lg(dimRelaRow,sn)
				s dimRV2=dimRV
				s:dimRV2="" dimRV2=$c(0)
				s rsn=-sn
				s delenum=0,valnum=0,deleflag=1
				//delete relation for metric index start
				s crdvid=$g(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn,dimRV2,crowid),"")
				if crdvid'=""{
					s rmvalnum=0
					s msn="" f{
						s msn=$o(usingmetricseginfo(msn))
						q:msn=""
						s mseg=$lg(usingmetricseginfo(msn),1),msegind=$lg(usingmetricseginfo(msn),2)
						s $bit(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdvid,mseg),msegind)=0
						s rmvalnum=rmvalnum+$bitcount(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdvid,mseg),1)
					}
					;b:cubeMask=5
					if rmvalnum=0{
						;s ciddeleteflag=2
						s msn="" f{
							s msn=$o(usingmetricseginfo(msn))
							q:msn=""
							k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdvid)
							k:'$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn)) ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn)
						}
						k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn,dimRV2,crowid)
						if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn,dimRV2)){
							k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn,dimRV2)
							if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn)){
								k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,sn)
								if $d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0))'="11"{
									k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0)
								}
							}
						}
						if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1)){
							k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1)
						}
						if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask)){
							k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask)
							if '$d(^DHCWL.DM.T.CubeDStructIR(part)){
								k ^DHCWL.DM.T.CubeDStructIR(part)
							}
						}
					}
				}
				//update relation for metric index end
				//delete relation value start
				s seg=$lg(usingreldseginfo(sn),1)
				s segInd=$lg(usingreldseginfo(sn),2)
				s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg),segInd)=$c(-1)
				s seg="" f{
					s seg=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg))
					q:seg=""
					s segvalnum=0
					s drlist=^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg)
					f j=$ll(drlist):-1:1{
						if $lg(drlist,j)=$c(-1){
							s delenum=delenum+1
						}else{
							s valnum=valnum+1,segvalnum=segvalnum+1
						}
					}
					if segvalnum=0{
						k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn,seg)
					}
				}
				;b:cubeMask=5
				if valnum=0{
					k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,rsn)
				}
				//delete relation value end
			}
			//delete cube relation dim end
			;b:cubeMask=5
			//delete cube row dim and dim index start
			if ciddeleteflag=3{
				f i=1:..#DIMSTRUCTLISTUNIT:dimLen {
			  	s sn=$lg(dimSN,i+1),dt=$lg(dimSN,i+3)
			  	s dimV=$lg(dimRow,sn)
			  	i ((dt=91)&&(dimV'="")&&(dimV'=$c(0))&&(+dimV'=dimV)) {
				  	s dimV=..FormatDateToCache(dimV)
			  	}
			  	s:dimV="" dimV=$c(0)
		      s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,oneSeg),onePos)=0
		      if $bitcount(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,oneSeg),1)=0{
				    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,oneSeg)
				    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)){
						  k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
						  if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)){
						    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)
						    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask)){
							  	k ^DHCWL.DM.T.CubeDStructI(part,cubeMask)
							  	if '$d(^DHCWL.DM.T.CubeDStructI(part)){
										k ^DHCWL.DM.T.CubeDStructI(part)  
							  	}   
						    }
						  }
				    }
		      }
				}
				k ^DHCWL.DM.T.CubeDStructD(part,cubeMask,crowid)
				if '$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask)){
				  k ^DHCWL.DM.T.CubeDStructD(part,cubeMask)
				  if '$d(^DHCWL.DM.T.CubeDStructD(part)){
				    k ^DHCWL.DM.T.CubeDStructD(part)  
				  }	
				}
				k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid)
				if '$d(^DHCWL.DM.T.CubeDStructV(part,cubeMask)){
				  k ^DHCWL.DM.T.CubeDStructV(part,cubeMask)
				  if '$d(^DHCWL.DM.T.CubeDStructV(part)){
				    k ^DHCWL.DM.T.CubeDStructV(part)  
				  }	
				}
				d ##class(CubeDCDIDLog).DeleteRow(day,cubeMask,part,crowid)
				d cubePartPolice.DeleteId()
			}
			//delete cube row dim end
			
		}
	}else{
		;w oneNum,",",oneSeg,",",onePos,!
		;w "dimRow:"_$lts(dimRow,",",1),!
		;w "dimRelaRow:"_$lts(dimRelaRow,",",1),!
		;w "metricRow:"_$lts(metricRow,",",1),!
		;w "dimSN:"_$lts(dimSN,","),!
		;w "dimRelaRow:"_$lts(dimRelaRow,",",1),!
		;w "dimRelaSN:"_$lts(dimRelaSN,","),!
		
	}
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).ClearThemeCube("/DHCMRInfo.t")

ClassMethod ClearThemeCube(themePath, type = "1") As %Status
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	s cubeList=theme.GetCubes()
	s len=cubeList.Count()
	f i=1:1:len{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s cubeMask=cube.Mask()
	  k ^DHCWL.DM.T.CubeDCDIDLogI(0,cubeMask)
	  k ^DHCWL.DM.T.CubeDCDIDLogI(1,cubeMask)
	  k ^DHCWL.DM.T.CubeDCDIDLogI(2,cubeMask)
	  s parts=##class(CubeDBDPPart).GetPartitions(cubeMask)
	  f j=1:1:$ll(parts){
			s part=$lg(parts,j,"")
			continue:part=""
			w "part:"_part_"  cubeMask:"_cubeMask,!
			k ^DHCWL.DM.T.CubeDStructD(part,cubeMask)
			k ^DHCWL.DM.T.CubeDStructV(part,cubeMask)
			k ^DHCWL.DM.T.CubeDStructI(part,cubeMask)
			;k ^DHCWL.DM.T.CubeDStructM(part,cubeMask)
			;k ^DHCWL.DM.T.CubeDStructR(part,cubeMask)
			k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask)
			d ##class(CubeDBDPPart).Reset(cubeMask,part)
	  }
	}
	q $$$OK
}

ClassMethod DeleteCubeByCD(cube As CubeBase, date As %Integer) As %Status [ Private ]
{
	s dimSN=cube.GetDimStructMap()
	s dimRelaSN=cube.GetDimStructMap(1)
	s metricSN=cube.GetMetricStructMap()
	d ##class(CubeDCDIDLog).GetCanDeleteInfo(date,cube.Mask())
	//s status= ..DeleteByInfo(date,cube.Mask(),dimSN,dimRelaSN,metricSN)
	s status= ..BatchDeleteByInfo(date,cube.Mask(),dimSN,dimRelaSN,metricSN)
	k ^tmp($j,"WLDM")
	q status
}

ClassMethod DeleteByInfo(date As %Integer, cubeMask, dimSN As %List, dimRelaSN As %List, metricSN As %List) As %Status [ Private ]
{
	s dimRelaSNLen=$ll(dimRelaSN)
	s dimSNLen=$ll(dimSN)
	k ^tmp($j,"WLMDRDV") //mask delete relation dim value
	s part="" f{
	  s part=$o(^tmp($j,"WLDM",part))
	  q:part=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,part)
	  s id="" f{
		s id=$o(^tmp($j,"WLDM",part,id))
		q:id=""
		continue:'$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id))
		s rowmsl=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,0)
		s deleteRowFlag=0
		//remove metric value start
		s msn=0 f{
		  s msn=$o(^tmp($j,"WLDM",part,id,msn))
		  q:msn=""
		  s mseg="" f{
			s mseg=$o(^tmp($j,"WLDM",part,id,msn,mseg))
			q:mseg=""
			if $d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,msn,2,mseg)){
			  s mvid="" f{
			    s mvid=$o(^tmp($j,"WLDM",part,id,msn,mseg,mvid))
			    q:mvid=""
			    // delete metric value
				s $list(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,msn,2,mseg),mvid)=""
				s $list(rowmsl,3)=$lg(rowmsl,3,0)+1
                s $list(rowmsl,2)=$lg(rowmsl,2,0)-1
                d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,msn,mseg,mvid)
			  }
			}
		  }
		}
		//remove metric value end
		//remove relation dim value start
		s rsn="" f{
		  s rsn=$o(^tmp($j,"WLDM",part,id,rsn))
		  q:rsn>0
		  s rseg="" f{
			s rseg=$o(^tmp($j,"WLDM",part,id,rsn,rseg))
			q:rseg=""
			if $d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,rsn,rseg)){
			  s rsegInd="" f{
			    s rsegInd=$o(^tmp($j,"WLDM",part,id,rsn,rseg,rsegInd))
			    q:rsegInd=""
			    s rdimv=$lg(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,rsn,rseg),rsegInd,$c(0))
			    s $list(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,rsn,rseg),rsegInd)=""
			    s ^tmp($j,"WLMDRDV",rsn,rdimv,id)=""
			    d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,rsn,rseg,rsegInd)
			  }
			}
		  }
		  
		}
		//remove relation dim value end
		//delete dim row id
		if $lg(rowmsl,2,0)<=0{
		  //update dim index start
		  s dimRow=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
		  f i=1:..#DIMSTRUCTLISTUNIT:dimSNLen {
			s sn=$lg(dimSN,i+1)
			s dimV=$lg(dimRow,sn,$c(0))
			s seg=id \ ..#MAXBITRANGE
	        s segInd=id#..#MAXBITRANGE
	        i segInd=0 {
	          s segInd=..#MAXBITRANGE
	          s seg=seg-1
	        }
	        s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),segInd)=0
	        if $bitcount(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),1)=0{
		      k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg)
		      if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)){
			    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
			     if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)){
				   k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)
			     }
		      }
	        }
		  }
		  //update dim index end
		  //update relation dim index start
		  s rsn="" f{
			s rsn=$o(^tmp($j,"WLMDRDV",rsn))
			q:rsn=""
			s rdimv="" f{
			  s rdimv=$o(^tmp($j,"WLMDRDV",rsn,rdimv))
			  q:rdimv=""
			  k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,rsn,rdimv,id)
			}
		  }
		  //update relation dim index end
		  k ^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
          d ##class(CubeDCDIDLog).Delete(1,date,cubeMask,part,id,"","","")
		  
		  d partPolice.DeleteId()
		}
	  }	
	  d partPolice.Commit()
	}
	k ^tmp($j,"WLMDRDV")
	q $$$OK
}

// 新的删除算法，适用与数据结构1

ClassMethod BatchDeleteByInfo(date As %Integer, cubeMask, dimSN As %List, dimRelaSN As %List, metricSN As %List) As %Status [ Private ]
{
	s dimRelaSNLen=$ll(dimRelaSN)
	s dimSNLen=$ll(dimSN),metricSNLen=$ll(metricSN)
	k snmap
	f i=1:..#DIMSTRUCTLISTUNIT:dimSNLen{
	  s sn=$lg(dimSN,i+1)
	  s snmap("D",sn)=""
	}
	f i=1:..#DIMSTRUCTLISTUNIT:metricSNLen{
	  s sn=$lg(dimSN,i+1)
	  s snmap("M",sn)=""
	}
	f i=1:..#DIMSTRUCTLISTUNIT:dimRelaSNLen{
	  s rsn=$lg(dimRelaSN,i+1)
	  continue:rsn=""
	  s snmap("R",rsn)=""
	}
	k ^tmp(cubeMask,"WLMDRDV") //mask delete relation dim value
	k ^tmp(cubeMask,"DDRI") //deleted dim rowid
	//remove metric value start
	s part="" f{
	  s part=$o(^tmp($j,"WLDM",part))
	  q:part=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,part)
	  s id="" f{
			s id=$o(^tmp($j,"WLDM",part,id))
			q:id=""
			continue:'$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id))
			s rowmsl=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,0)
			s deleteRowFlag=0
			s msn="" f{
			  s msn=$o(snmap("M",msn))
			  q:msn=""
			  continue:'$d(^tmp($j,"WLDM",part,id,msn))
			  s mseg="" f{
					s mseg=$o(^tmp($j,"WLDM",part,id,msn,mseg))
					q:mseg=""
					if $d(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,msn,mseg)){
					  s mvid="" f{
					    s mvid=$o(^tmp($j,"WLDM",part,id,msn,mseg,mvid))
					    q:mvid=""
					    // delete metric value
							s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,msn,mseg),mvid)=$c(-1)
							s $list(rowmsl,3)=$lg(rowmsl,3,0)+1
		          s $list(rowmsl,2)=$lg(rowmsl,2,0)-1
		          d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,msn,mseg,mvid)
					  }
					}
			  }
			}
			//mark need deleted dim row id
			if $lg(rowmsl,2,0)<=0{
			  /*k ^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
			  if '$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask)){
					k ^DHCWL.DM.T.CubeDStructD(part,cubeMask)
					if '$d(^DHCWL.DM.T.CubeDStructD(part)){
					  k ^DHCWL.DM.T.CubeDStructD(part)	
					}
			  }*/
			  s ^tmp(cubeMask,"DDRI",part,id)=""
			}
	  }	
	}
	//remove metric value end
	//remove relation dim value start
	s part="" f{
	  s part=$o(^tmp($j,"WLDM",part))
	  q:part=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,part)
	  s id="" f{
		s id=$o(^tmp($j,"WLDM",part,id))
		q:id=""
		s rsn="" f{
		  s rsn=$o(snmap("R",rsn))
		  q:rsn=""
		  s lrsn=-rsn
		  continue:'$d(^tmp($j,"WLDM",part,id,lrsn))	
		  s rseg="" f{
			s rseg=$o(^tmp($j,"WLDM",part,id,lrsn,rseg))
			q:rseg=""
			if $d(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,lrsn,rseg)){
			  s rsegInd="" f{
			    s rsegInd=$o(^tmp($j,"WLDM",part,id,lrsn,rseg,rsegInd))
			    q:rsegInd=""
			    s rdimv=$lg(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,lrsn,rseg),rsegInd,$c(0))
			    s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,lrsn,rseg),rsegInd)=$c(-1)
			    s ^tmp(cubeMask,"WLMDRDV",part,lrsn,rdimv,id)=""
			    d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,lrsn,rseg,rsegInd)
			  }
			}
		  }
		}
	  }
	}
	//remove relation dim value end
	//delete dim row and rowid start
	s part="" f{
	  s part=$o(^tmp(cubeMask,"DDRI",part))
	  q:part=""
	  s id="" f{
	    s id=$o(^tmp(cubeMask,"DDRI",part,id))
	    q:id=""
	    s seg=id \ ..#MAXBITRANGE
	    s segInd=id#..#MAXBITRANGE
	    i segInd=0 {
	      s segInd=..#MAXBITRANGE
	      s seg=seg-1
	    }
	    s dimRow=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
	    //update dim index start
	    f i=1:..#DIMSTRUCTLISTUNIT:dimSNLen {
		  	s sn=$lg(dimSN,i+1)
		  	s dimV=$lg(dimRow,sn,$c(0))
	      s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),segInd)=0
	      if $bitcount(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),1)=0{
			    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg)
			    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)){
					  k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
					  if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)){
					    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)
					    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask)){
						  	k ^DHCWL.DM.T.CubeDStructI(part,cubeMask)
						  	if '$d(^DHCWL.DM.T.CubeDStructI(part)){
									k ^DHCWL.DM.T.CubeDStructI(part)  
						  	}   
					    }
					  }
			    }
	      }
			}
			//update dim index end
			k ^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
			if '$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask)){
			  k ^DHCWL.DM.T.CubeDStructD(part,cubeMask)
			  if '$d(^DHCWL.DM.T.CubeDStructD(part)){
			    k ^DHCWL.DM.T.CubeDStructD(part)  
			  }	
			}
			k ^DHCWL.DM.T.CubeDStructV(part,cubeMask,id)
			if '$d(^DHCWL.DM.T.CubeDStructV(part,cubeMask)){
			  k ^DHCWL.DM.T.CubeDStructV(part,cubeMask)
			  if '$d(^DHCWL.DM.T.CubeDStructV(part)){
			    k ^DHCWL.DM.T.CubeDStructV(part)  
			  }	
			}
			d ##class(CubeDCDIDLog).Delete(1,date,cubeMask,part,id,"","","")
			d partPolice.DeleteId()
			/*k ^DHCWL.DM.T.CubeDStructR(part,cubeMask,id)
			if '$d(^DHCWL.DM.T.CubeDStructR(part,cubeMask)){
			  k ^DHCWL.DM.T.CubeDStructR(part,cubeMask)
			  if '$d(^DHCWL.DM.T.CubeDStructR(part)){
			    k ^DHCWL.DM.T.CubeDStructR(part)  
			  }	
			}*/
	  }
	}
	//delete dim row and rowid end
	
	//update relation dim index start
	s part="" f{
	  s part=$o(^tmp(cubeMask,"WLMDRDV",part))
	  q:part=""
	  s rsn="" f{
	    s rsn=$o(snmap("R",rsn))
	    q:rsn=""
	    s lrsn=-rsn
	    continue:'$d(^tmp(cubeMask,"WLMDRDV",part,lrsn))
	    s rdimv="" f{
		  	s rdimv=$o(^tmp(cubeMask,"WLMDRDV",part,lrsn,rdimv))
		  	q:rdimv=""
		  	s crdvcid=^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn,rdimv,0)
		  	k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn,rdimv)
		  	s msn="" f{
				  s msn=$o(snmap("M",msn))
				  q:msn=""
				  k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn,crdvcid)
				  if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn)){
						k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1,msn)
						if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1)){
							k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,1)	
						}
				  }
		  	}
		  	if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn)){
			  	k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0,rsn)
			  	if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0)){
				  	k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,0)
				  	if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask)){
					  	k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask)
					  	if '$d(^DHCWL.DM.T.CubeDStructIR(part)){
						  	k ^DHCWL.DM.T.CubeDStructIR(part)	
					  	}
				  	}	
			  	}	
		  	}
	      /*s id="" f{
	      	s id=$o(^tmp(cubeMask,"WLMDRDV",part,lrsn,rdimv,id))
	        q:id=""
					k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,lrsn,rdimv,id)
					if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,lrsn,rdimv)){
					  k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,lrsn,rdimv)
					  if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,lrsn)){
					    k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,lrsn)
					    if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask)){
							  k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask)
							  if '$d(^DHCWL.DM.T.CubeDStructIR(part)){
							    k ^DHCWL.DM.T.CubeDStructIR(part)  
							  }
					    }
					  }	
					}
		  	}*/
			}
	  }
	}
	//update relation dim index end
	
	k ^tmp($j,"WLMDRDV"),^tmp(cubeMask,"DDRI")
	q $$$OK
}

// 新的删除算法，适用与数据结构2

ClassMethod BatchDeleteByInfo2(date As %Integer, cubeMask, dimSN As %List, dimRelaSN As %List, metricSN As %List) As %Status [ Private ]
{
	s dimRelaSNLen=$ll(dimRelaSN)
	s dimSNLen=$ll(dimSN),metricSNLen=$ll(metricSN)
	k snmap
	f i=1:..#DIMSTRUCTLISTUNIT:dimSNLen{
	  s sn=$lg(dimSN,i+1)
	  s snmap("D",sn)=""
	}
	f i=1:..#DIMSTRUCTLISTUNIT:metricSNLen{
	  s sn=$lg(dimSN,i+1)
	  s snmap("M",sn)=""
	}
	f i=1:..#DIMSTRUCTLISTUNIT:dimRelaSNLen{
	  s rsn=$lg(dimRelaSN,i+1)
	  continue:rsn=""
	  s snmap("R",rsn)=""
	}
	k ^tmp(cubeMask,"WLMDRDV") //mask delete relation dim value
	k ^tmp(cubeMask,"DDRI") //deleted dim rowid
	//remove metric value start
	s part="" f{
	  s part=$o(^tmp($j,"WLDM",part))
	  q:part=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,part)
	  s id="" f{
		s id=$o(^tmp($j,"WLDM",part,id))
		q:id=""
		continue:'$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,id))
		s rowmsl=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id,0)
		s deleteRowFlag=0
		s msn="" f{
		  s msn=$o(snmap("M",msn))
		  q:msn=""
		  continue:'$d(^tmp($j,"WLDM",part,id,msn))
		  s mseg="" f{
			s mseg=$o(^tmp($j,"WLDM",part,id,msn,mseg))
			q:mseg=""
			if $d(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,msn,mseg)){
			  s mvid="" f{
			    s mvid=$o(^tmp($j,"WLDM",part,id,msn,mseg,mvid))
			    q:mvid=""
			    // delete metric value
				s $list(^DHCWL.DM.T.CubeDStructM(part,cubeMask,id,msn,mseg),mvid)=""
				s $list(rowmsl,3)=$lg(rowmsl,3,0)+1
                s $list(rowmsl,2)=$lg(rowmsl,2,0)-1
                d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,msn,mseg,mvid)
			  }
			}
		  }
		}
		//mark need deleted dim row id
		if $lg(rowmsl,2,0)<=0{
		  k ^DHCWL.DM.T.CubeDStructM(part,cubeMask,id)
		  if '$d(^DHCWL.DM.T.CubeDStructM(part,cubeMask)){
			k ^DHCWL.DM.T.CubeDStructM(part,cubeMask)
			if '$d(^DHCWL.DM.T.CubeDStructM(part)){
			  k ^DHCWL.DM.T.CubeDStructM(part)	
			}
		  }
		  s ^tmp(cubeMask,"DDRI",part,id)=""
		}
	  }	
	}
	//remove metric value end
	//remove relation dim value start
	s part="" f{
	  s part=$o(^tmp($j,"WLDM",part))
	  q:part=""
	  s partPolice=##class(CubeDBDPPart).GetPart(cubeMask,part)
	  s id="" f{
		s id=$o(^tmp($j,"WLDM",part,id))
		q:id=""
		s rsn="" f{
		  s rsn=$o(snmap("R",rsn))
		  q:rsn=""
		  s lrsn=-rsn
		  continue:'$d(^tmp($j,"WLDM",part,id,lrsn))	
		  s rseg="" f{
			s rseg=$o(^tmp($j,"WLDM",part,id,lrsn,rseg))
			q:rseg=""
			if $d(^DHCWL.DM.T.CubeDStructR(part,cubeMask,id,rsn,rseg)){
			  s rsegInd="" f{
			    s rsegInd=$o(^tmp($j,"WLDM",part,id,lrsn,rseg,rsegInd))
			    q:rsegInd=""
			    s rdimv=$lg(^DHCWL.DM.T.CubeDStructR(part,cubeMask,id,rsn,rseg),rsegInd,$c(0))
			    s $list(^DHCWL.DM.T.CubeDStructR(part,cubeMask,id,rsn,rseg),rsegInd)=""
			    s ^tmp(cubeMask,"WLMDRDV",part,rsn,rdimv,id)=""
			    d ##class(CubeDCDIDLog).Delete(0,date,cubeMask,part,id,rsn,rseg,rsegInd)
			  }
			}
		  }
		}
	  }
	}
	//remove relation dim value end
	//delete dim row and rowid start
	s part="" f{
	  s part=$o(^tmp(cubeMask,"DDRI",part))
	  q:part=""
	  s id="" f{
	    s id=$o(^tmp(cubeMask,"DDRI",part,id))
	    q:id=""
	    s seg=id \ ..#MAXBITRANGE
	    s segInd=id#..#MAXBITRANGE
	    i segInd=0 {
	      s segInd=..#MAXBITRANGE
	      s seg=seg-1
	    }
	    s dimRow=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
	    //update dim index start
	    f i=1:..#DIMSTRUCTLISTUNIT:dimSNLen {
		  s sn=$lg(dimSN,i+1)
		  s dimV=$lg(dimRow,sn,$c(0))
	      s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),segInd)=0
	      if $bitcount(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg),1)=0{
		    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,seg)
		    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)){
			  k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
			  if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)){
			    k ^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn)
			    if '$d(^DHCWL.DM.T.CubeDStructI(part,cubeMask)){
				  k ^DHCWL.DM.T.CubeDStructI(part,cubeMask)
				  if '$d(^DHCWL.DM.T.CubeDStructI(part)){
					k ^DHCWL.DM.T.CubeDStructI(part)  
				  }   
			    }
			  }
		    }
	      }
		}
		//update dim index end
		k ^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
		if '$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask)){
		  k ^DHCWL.DM.T.CubeDStructD(part,cubeMask)
		  if '$d(^DHCWL.DM.T.CubeDStructD(part)){
		    k ^DHCWL.DM.T.CubeDStructD(part)  
		  }	
		}
		d ##class(CubeDCDIDLog).Delete(1,date,cubeMask,part,id,"","","")
		d partPolice.DeleteId()
		k ^DHCWL.DM.T.CubeDStructR(part,cubeMask,id)
		if '$d(^DHCWL.DM.T.CubeDStructR(part,cubeMask)){
		  k ^DHCWL.DM.T.CubeDStructR(part,cubeMask)
		  if '$d(^DHCWL.DM.T.CubeDStructR(part)){
		    k ^DHCWL.DM.T.CubeDStructR(part)  
		  }	
		}
	  }
	}
	//delete dim row and rowid end
	
	//update relation dim index start
	s part="" f{
	  s part=$o(^tmp(cubeMask,"WLMDRDV",part))
	  q:part=""
	  s rsn="" f{
	    s rsn=$o(snmap("R",rsn))
	    q:rsn=""
	    continue:'$d(^tmp(cubeMask,"WLMDRDV",part,rsn))
	    s rdimv="" f{
		  s rdimv=$o(^tmp(cubeMask,"WLMDRDV",part,rsn,rdimv))
		  q:rdimv=""
	      s id="" f{
	      s id=$o(^tmp(cubeMask,"WLMDRDV",part,rsn,rdimv,id))
	        q:id=""
		    s lrsn=-rsn
			k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rdimv,id)
			if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rdimv)){
			  k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn,rdimv)
			  if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn)){
			    k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask,rsn)
			    if '$d(^DHCWL.DM.T.CubeDStructIR(part,cubeMask)){
				  k ^DHCWL.DM.T.CubeDStructIR(part,cubeMask)
				  if '$d(^DHCWL.DM.T.CubeDStructIR(part)){
				    k ^DHCWL.DM.T.CubeDStructIR(part)  
				  }
			    }
			  }	
			}
		  }
		}
	  }
	}
	//update relation dim index end
	
	k ^tmp($j,"WLMDRDV"),^tmp(cubeMask,"DDRI")
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeDStruct).UpdateTest()

ClassMethod UpdateTest()
{
	s map("WorkLoad_FlagDate")="2013-01-03"
	d ##class(DHCWL.DM.T.CubeDStruct).Update("/WorkLoad.t","WorkLoad_OrdDate DateRange(2012-01-01,2012-01-03)&& WorkLoad_Type contain([I]) && WorkLoad_RecDep_DR->LocDesc [(内)",.map)
}

ClassMethod Update(themePath, filter, ByRef updateMap) As %Status
{
	s dims="",ind=0
	s dim="" f{
	  s dim=$o(updateMap(dim))
	  q:dim=""
	  if ind>0{
	    s dims=dims_","_dim  
	  }else{
	    s dims=dim  
	  }
	  s ind=ind+1	
	}
	s irp=##class(DHCWL.DM.Core.InternalResolvedParser).%New()
	s irp.RefTheme=##class(DHCWL.DM.T.ThemeBase).GetByPath(themePath)
	s status=irp.GenerateCommon("","update",,themePath,dims,"",filter,.jsonStruct)
	q:status'=$$$OK status
	s status=irp.ParseDims()
	q:status'=$$$OK status
	s status=irp.ParseFilter(.rootNode)
	q:status'=$$$OK status
	q:rootNode="" $$$ERROR("You should be set filter,when updating "_themePath_"!")
	s irp.FilterRootNode=rootNode
	m allUsingDimMetricMap=irp.allUsingDimMetricMap
	k dimMap
	i $d(allUsingDimMetricMap("D")) {
	  s code="" f {
			s code=$o(allUsingDimMetricMap("D",code)) 
			q:code=""
			s dimMap(code)=""
	  }
	}
	i $d(allUsingDimMetricMap("F")) {
	  s code="" f {
			s code=$o(allUsingDimMetricMap("F",code)) 
			q:code=""
			s dimMap(code)=""
	  }
	}
	s dimList=$lb(),ind=0
	s dim="" f{
	  s dim=$o(dimMap(dim))
	  q:dim=""
	  s ind=ind+1
	  s $list(dimList,ind)=dim
	}
	s cubeList=##class(CubeBase).GetAll(themePath,dimList,$lb())
	s cubeCount=cubeList.Count()
	q:cubeCount=0 $$$ERROR(themePath_" 's cubes not need update!")
	s rdimStructList=$lb(),allDimStructList=$lb(),dimStructList=$lb()
	s rdimStructListLen=0,allDimStructListLen=0,dimStructListLen=0
	s updateDimList=$lb()
	m showStruct=irp.dimsShowInd
	s pdsList=irp.parsedDimStuList
	s j="" f{
	  s j=$o(showStruct(j))
	  q:j=""
	  s dimExp=showStruct(j,"E")
	  s $list(updateDimList,j)=updateMap(dimExp)
	  s pdstu=pdsList.GetAt(j)
	  if (pdstu.IsRelationDim()=1){
			s rdimStructListLen=rdimStructListLen+1
			s $list(rdimStructList,rdimStructListLen)=j
		  s rdimStructListLen=rdimStructListLen+1
		  s $list(rdimStructList,rdimStructListLen)=pdstu.SN
			s allDimStructListLen=allDimStructListLen+1
			s $list(allDimStructList,allDimStructListLen)=j
			s allDimStructListLen=allDimStructListLen+1
			s $list(allDimStructList,allDimStructListLen)=pdstu.SN
	  }else{
			if (0)&&(pdstu.IsFunctionCall()=1){
		  	s showStruct2("DF",j)=""
			}else{
				s dst=showStruct(j,"S")
		  	s dimStructListLen=dimStructListLen+1
		  	s $list(dimStructList,dimStructListLen)=j
		  	s dimStructListLen=dimStructListLen+1
		  	s $list(dimStructList,dimStructListLen)=$list(dst,3)
		  	s allDimStructListLen=allDimStructListLen+1
				s $list(allDimStructList,allDimStructListLen)=j
				s allDimStructListLen=allDimStructListLen+1
				s $list(allDimStructList,allDimStructListLen)=$list(dst,3)
			}
	  }
	}
	f i=1:1:cubeCount{
	  s cube=cubeList.GetAt(i)
	  continue:cube=""
	  s irp.RefCube=cube
	  s irp.PartList=##class(DHCWL.DM.T.CubeDBDPPart).GetPartitions(cube.Mask())
	  k ^||tempurdfstu
	  s status=irp.FilterParse2(1)
	  continue:status'=$$$OK
	  d irp.GetFilterTargetBit()
	  m segBitMap= irp.FilterRootNode.SegBitIndexMap
	  s cubeMask=cube.Mask()
	  s dimSN=cube.GetDimStructMap()
	  s dimSNLen=$ll(dimSN)
	  s metricSN=cube.GetMetricStructMap()
	  s metricSNLen=$ll(metricSN)
	  s part="" f{
	    s part=$o(segBitMap(part))
	    q:part=""
	    s cubePartPolice=##class(DHCWL.DM.T.CubeDBDPPart).GetPart(cubeMask,part)
	    f j=0:1:$g(segBitMap(part),0){
	      continue:'$d(segBitMap(part,j))
	      s bit=segBitMap(part,j)
	      s m=$bitfind(bit,1,1)
	      while(m>0){
	        s id=(j*..#MAXBITRANGE)+m
	        s m=$bitfind(bit,1,m+1)
	        //dim resolve start
	        s odrow=^DHCWL.DM.T.CubeDStructD(part,cubeMask,id)
					s ndrow=odrow
					f ij=1:2:dimStructListLen{
						s j=$list(dimStructList,ij)
						s sn=$list(dimStructList,ij+1)
						s $list(ndrow,sn)=$lg(updateDimList,j)
					}
					q:status'=$$$OK
					//dim resolve end
					//check cubeid start
					k indAndBit
					s indAndBitFlag=1,matchedAllDimFlag=1
					f ij=1:..#DIMSTRUCTLISTUNIT:dimSNLen {
						s sn=$lg(dimSN,ij+1),dt=$lg(dimSN,i+3)
						s dimV=$lg(ndrow,sn)
						i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
				      s dimV=..FormatDateToCache(dimV)
				      s $list(dimRow,sn)=dimV
				    }
				    s:dimV="" dimV=$c(0)
						if ( ($d(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV))) ){
							k indBit
					    m indBit=^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV)
					    i indAndBitFlag=1 {
					      m indAndBit=indBit
					      s indAndBitFlag=0
					    }else{
					      s segInd="" f  {
							    s segInd=$o(indBit(segInd))
							    q:segInd=""
							    s:'$d(indAndBit(segInd)) indAndBit(segInd)=""
							    s indAndBit(segInd)=$bitlogic(indAndBit(segInd) & indBit(segInd) )
					      }
					      s segInd="" f  {
							    s segInd=$o(indAndBit(segInd))
							    q:segInd="" 
							    s:'$d(indBit(segInd)) indBit(segInd)=""
							    s indAndBit(segInd)=$bitlogic(indAndBit(segInd) & indBit(segInd) )
					      }
					    }
					    s segBitFound=0,segInd="" f{
							  s segInd=$o(indAndBit(segInd))
							  q:segInd=""
					      s:$bitfind(indAndBit(segInd),1)>0 segBitFound=segBitFound+1
					    }
					    q:segBitFound=0
						}else{
						  s matchedAllDimFlag=0
						  q   
					  }
					}
					s oneNum=0,onePos=0,oneSeg=0,crowid=0
					if (matchedAllDimFlag=1)  {
					  s segInd="" f{
							s segInd=$o(indAndBit(segInd))
							q:segInd=""
						  s onePos2=$bitfind(indAndBit(segInd),1)
					    if onePos2>0 {
					      s oneNum=oneNum+1,oneSeg=segInd,onePos=onePos2
					    }
					  }
					}
					i oneNum=1 {// alreay dim and insert metrics
					  s action=0
					  s crowid=(oneSeg*..#MAXBITRANGE)+onePos
					  s:'$d(^DHCWL.DM.T.CubeDStructD(part,cubeMask,crowid)) crowid=0
					}
					//check cubeid end
					//build new dim rowid and index start
					if crowid=0{
						s crowid=cubePartPolice.GetId()
					  s segNum=crowid \ ..#MAXBITRANGE
					  s segInInd=crowid#..#MAXBITRANGE
					  i segInInd=0 {
					    s segInInd=..#MAXBITRANGE
					    s segNum=segNum-1
					  }
					  f ij=1:..#DIMSTRUCTLISTUNIT:dimSNLen {
							s sn=$lg(dimSN,ij+1),dt=$lg(dimSN,i+3)
							s dimV=$lg(ndrow,sn)
							i (dt=91)&&(dimV'="") &&(+dimV'=dimV) {
					      s dimV=..FormatDateToCache(dimV)
					      s $list(ndrow,sn)=dimV
					    }
					    s:dimV="" dimV=$c(0)
					    s $bit(^DHCWL.DM.T.CubeDStructI(part,cubeMask,sn,dimV,segNum),segInInd)=1
					  }
					  s ^DHCWL.DM.T.CubeDStructD(part,cubeMask,crowid)=ndrow
					  s ^DHCWL.DM.T.CubeDStructD(part,cubeMask,crowid,0)=$lb(0,0,0)
					}
					//build new dim rowid and index end
					//move old metrics to new cid start
					if (rdimStructListLen=0){
						f ij=1:..#DIMSTRUCTLISTUNIT:metricSNLen{
							s sn=$lg(metricSN,ij+1)
							s mli="" f{
								s mli=$o(^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,sn,mli))
								q:mli=""
								s metricList=^DHCWL.DM.T.CubeDStructV(part,cubeMask,id,sn,mli)
								s rowmsl=$g(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn),$lb(0,0))
								s mli2=$lg(rowmsl,1)
								s mll=$lg(rowmsl,2)+1
								f mlind=1:1:$ll(metricList){
									try{
								    s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,mli2),mll)=mv
								    s mll=mll+1
								  }catch(e){
										s mli2=mli2+1
								    s mll=1
								    s $list(^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn,mli2),mll)=mv
								  }
								}
								s $list(rowmsl,1)=mli2
							  s $list(rowmsl,2)=mll
							  s ^DHCWL.DM.T.CubeDStructV(part,cubeMask,crowid,sn)=rowmsl
							  d ##class(CubeDCDIDLog).Create(day,cubeMask,part,crowid,sn,mli2,mll)
							}
						}
					}else{
						
					}
					//move old metrics to new cid end
					
					//relation dim resolve start
					f ij=1:2:rdimStructListLen{
						s j=$list(rdimStructList,ij)
						s sn=$list(rdimStructList,ij+1)
						
					}
					//relation dim resolve end
	      }
	      q:status'=$$$OK
	    }
	    q:status'=$$$OK
	    d cubePartPolice.Commit()
	  }
	  q:status'=$$$OK
	}
}

// 适用于数据结构1的倒退过滤算法

ClassMethod BacksteppingDimsFromeFilter1(cubeId, partList As %List, dimStructList As %List, node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall) As %List
{
	s result=$lb()
	;s dimStructList=node.DimStruct
	s dimId=$lg(dimStructList,1)
	s sn=$lg(dimStructList,3)
	s funType=funCall.FunctionConfig.SubType
	s fun=funCall.FunctionConfig.Name
	s partLen=$ll(partList)
	s dataType=12
	if (node.parsedDimStruct'="")&&(node.parsedDimStruct.jdbcType'=""){
	  s dataType=node.parsedDimStruct.jdbcType
	  ;s sn=node.parsedDimStruct.SN
	}
	k resultMap
	if (node.parsedDimStruct.IsRelationDim()=0){
		;s sn=-sn
		if funType="I" {
			f i=1:1:partLen {
				s partInd=$lg(partList,i,"")
				continue:partInd=""
				s v="" f {
					s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
					q:v=""
					i funCall.Call($lb(v)) {
						s resultMap(v)=""
					}
				}
			}
		}elseif funType="MO" {
			f i=1:1:partLen {
				s partInd=$lg(partList,i,"")
				continue:(partInd="")||( '$d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn)) )
				i fun="=" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s:dataType=91 para=$zdh(para,3)
						if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para)) s resultMap(para)=""
			    }
			  }elseif fun="NE" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v="" f {
						  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
						  q:v=""
						  if v'=para{
							  s resultMap(v)=""
							}
			      }
				  }
			  }elseif fun=">" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=para f {
						  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun=">=" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para),-1) f{
						  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="<"{
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j,3)
					  s:dataType=91 para=$zdh(para)
					  s v=para f {
						  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1)
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="<=" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para)) f{
						  s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1)
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="between" {
				  s stvalue=$lg(node.Params,1,"")
				  s edvalue=$lg(node.Params,2,"")
				  if (stvalue'="")&&(edvalue'=""){
					  if (dataType=91){
						  s stvalue=$zdh(stvalue,3)
						  s edvalue=$zdh(edvalue,3)
						}
						s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,stvalue),-1)
						s ved=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,edvalue)) f{
							s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
							q:(v="")||(v=ved)
							s resultMap(v)=""
						}
					}
				}elseif fun="[" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s:dataType=91 para=$zdh(para,3)
						s v="" f {
							s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
							q:v=""
							if (v [ para){
								s resultMap(v)=""
							}
						}
					}
				}elseif fun="notnull" {
					s nullv=$c(0)
					s v="" f {
						s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
						q:v=""
						if (v'=nullv){
							s resultMap(v)=""
						}
					}
				}elseif fun="isnull" {
					if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,$c(0))){
						s resultMap($c(0))=""
					}
				}elseif fun="like" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s pattern=##class(DHCWL.DM.Util.StringUtil).LikePatternConvert(para)
						s v="" f {
							s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
							q:v=""
							if (v ?@pattern){
								s resultMap(v)=""
							}
						}
					}
				}
			}
		}elseif funType="C" {
			s ccl=funCall.Call()
			s ccll=$ll(ccl)
			f i=1:1:ccll {
				s v=$lg(ccl,i,"")
				q:v=""
				f j=1:1:partLen {
					s partInd=$lg(partList,j,"")
					continue:partInd=""
					if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v)) s resultMap(v)=""
				}
			}
		}
	}else{
		if funType="I" {
			f i=1:1:partLen {
				s partInd=$lg(partList,i,"")
				continue:partInd=""
				s v="" f {
					s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
					q:v=""
					i funCall.Call($lb(v)) {
						s resultMap(v)=""
					}
				}
			}
		}elseif funType="MO" {
			f i=1:1:partLen {
				s partInd=$lg(partList,i,"")
				continue:(partInd="")||( '$d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn)) )
				i fun="=" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s:dataType=91 para=$zdh(para,3)
						if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,para)) s resultMap(para)=""
			    }
			  }elseif fun="NE" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v="" f {
						  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
						  q:v=""
						  if v'=para{
							  s resultMap(v)=""
							}
			      }
				  }
			  }elseif fun=">" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=para f {
						  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun=">=" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,para),-1) f{
						  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="<"{
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j,3)
					  s:dataType=91 para=$zdh(para)
					  s v=para f {
						  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v),-1)
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="<=" {
				  s plen=$ll(node.Params)
				  f j=1:1:plen {
					  s para=$lg(node.Params,j)
					  s:dataType=91 para=$zdh(para,3)
					  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,para)) f{
						  s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v),-1)
						  q:v=""
						  s resultMap(v)=""
			      }
			    }
			  }elseif fun="between" {
				  s stvalue=$lg(node.Params,1,"")
				  s edvalue=$lg(node.Params,2,"")
				  if (stvalue'="")&&(edvalue'=""){
					  if (dataType=91){
						  s stvalue=$zdh(stvalue,3)
						  s edvalue=$zdh(edvalue,3)
						}
						s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,stvalue),-1)
						s ved=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,edvalue)) f{
							s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
							q:(v="")||(v=ved)
							s resultMap(v)=""
						}
					}
				}elseif fun="[" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s:dataType=91 para=$zdh(para,3)
						s v="" f {
							s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
							q:v=""
							if (v [ para){
								s resultMap(v)=""
							}
						}
					}
				}elseif fun="notnull" {
					s nullv=$c(0)
					s v="" f {
						s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
						q:v=""
						if (v'=nullv){
							s resultMap(v)=""
						}
					}
				}elseif fun="isnull" {
					if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,$c(0))){
						s resultMap($c(0))=""
					}
				}elseif fun="like" {
					s plen=$ll(node.Params)
					f j=1:1:plen {
						s para=$lg(node.Params,j)
						s pattern=##class(DHCWL.DM.Util.StringUtil).LikePatternConvert(para)
						s v="" f {
							s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v))
							q:v=""
							if (v ?@pattern){
								s resultMap(v)=""
							}
						}
					}
				}
			}
		}elseif funType="C" {
			s ccl=funCall.Call()
			s ccll=$ll(ccl)
			f i=1:1:ccll {
				s v=$lg(ccl,i,"")
				q:v=""
				f j=1:1:partLen {
					s partInd=$lg(partList,j,"")
					continue:partInd=""
					if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,v)) s resultMap(v)=""
				}
			}
		}
	}
	
	s v="",i=0 f{
		s v=$o(resultMap(v))
		q:v=""
		s i=i+1
		s $list(result,i)=v
	}
	q result
}

// 适用于数据结构2的倒退过滤算法

ClassMethod BacksteppingDimsFromeFilter2(cubeId, partList As %List, dimStructList As %List, node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall) As %List
{
	s result=$lb()
	;s dimStructList=node.DimStruct
	s dimId=$lg(dimStructList,1)
	s sn=$lg(dimStructList,3)
	s funType=funCall.FunctionConfig.SubType
	s fun=funCall.FunctionConfig.Name
	s partLen=$ll(partList)
	s dataType=12
	if (node.parsedDimStruct'="")&&(node.parsedDimStruct.jdbcType'=""){
	  s dataType=node.parsedDimStruct.jdbcType
	  s sn=node.parsedDimStruct.SN
	}
	k resultMap
	if (node.parsedDimStruct.IsRelationDim()=0){
		if funType="I" {
		  f i=1:1:partLen {
		    s partInd=$lg(partList,i,"")
		    continue:partInd=""
		    s v="" f {
			    s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
			    q:v=""
		        i funCall.Call($lb(v)) {
			        s resultMap(v)=""
		        }
		      }
		    }
		}elseif funType="MO" {
		  s MF("!=")="'=",MF("'=")="'=",MF("[")="["
		  f i=1:1:partLen {
		    s partInd=$lg(partList,i,"")
		    continue:(partInd="")||( '$d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn)) )
		    i fun="=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para)) s resultMap(para)=""
		      }
		    }elseif fun="NE" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:v=""
				      if v'=para{
					      s resultMap(v)=""
				      }
		        }
		      }
		    }elseif fun=">" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=para f {
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun=">" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=para f {
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun=">=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para),-1)
		        f{
			      	s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
			      	q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="<"{
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j,3)
		        s:dataType=91 para=$zdh(para)
		        s v=para 
		        f {
		          s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1)
		          q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="<=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para))
		        f{
			      	s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1) q:v=""  d
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="between" {
				  s stvalue=$lg(node.Params,1,"")
				  s edvalue=$lg(node.Params,2,"")
				  if (stvalue'="")&&(edvalue'=""){
						if (dataType=91){
						  s stvalue=$zdh(stvalue,3)
						  s edvalue=$zdh(edvalue,3)
						}
						s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,stvalue),-1)
						s ved=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,edvalue))
			      f{
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:(v="")||(v=ved)
			        s resultMap(v)=""
			      }
				  }
		    }elseif fun="[" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:v=""
				      if (v [ para){
					      s resultMap(v)=""
				      }
		        }
		      }
		    }elseif fun="notnull" {
			    s nullv=$c(0)
			    s v="" f {
				    s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				    q:v=""
				    if (v'=nullv){
					    s resultMap(v)=""
				    }
			    }
		    }elseif fun="isnull" {
			    if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,$c(0))){
				    s resultMap($c(0))=""
			    }
		    }elseif fun="like" {
			    s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s pattern=##class(DHCWL.DM.Util.StringUtil).LikePatternConvert(para)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
				      q:v=""
				      if (v ?@pattern){
					      s resultMap(v)=""
				      }
		        }
		      }
		    }
		  }
		}elseif funType="C" {
		  s ccl=funCall.Call()
		  s ccll=$ll(ccl)
		  f i=1:1:ccll {
		    s v=$lg(ccl,i,"")
		    q:v=""
		    f j=1:1:partLen {
		      s partInd=$lg(partList,j,"")
		      continue:partInd=""
		      if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v)) s resultMap(v)=""
		    }
		  }
		}
	}else{
		if funType="I" {
		  f i=1:1:partLen {
		    s partInd=$lg(partList,i,"")
		    continue:partInd=""
		    s v="" f {
			  	s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
			  	q:v=""
		      i funCall.Call($lb(v)) {
			   		s resultMap(v)=""
		      }
		    }
		  }
		}elseif funType="MO" {
		  f i=1:1:partLen {
		    s partInd=$lg(partList,i,"")
		    continue:(partInd="")||( '$d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn)) )
		    i fun="=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para)) s resultMap(para)=""
		      }
		    }elseif fun="NE" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				      q:v=""
				      if (v'=para){
		          	s resultMap(v)=""
				      }
		        }
		      }
		    }elseif fun=">" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=para f {
				      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				      q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun=">=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para),-1)
		        f{
			      	s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
			      	q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="<"{
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j,3)
		        s:dataType=91 para=$zdh(para)
		        s v=para 
		        f {
		          s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v),-1)
		          q:v=""
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="<=" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para))
		        f{
			      	s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v),-1) q:v=""  d
		          s resultMap(v)=""
		        }
		      }
		    }elseif fun="between" {
				  s stvalue=$lg(node.Params,1,"")
				  s edvalue=$lg(node.Params,2,"")
				  if (stvalue'="")&&(edvalue'=""){
						if (dataType=91){
						  s stvalue=$zdh(stvalue,3)
						  s edvalue=$zdh(edvalue,3)
						}
						s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,stvalue),-1)
						s ved=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,edvalue))
			      f{
				      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				      q:(v="")||(v=ved)
			        s resultMap(v)=""
			      }
				  }
		    }elseif fun="[" {
		      s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s:dataType=91 para=$zdh(para,3)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				      q:v=""
				      if (v [ para){
					      s resultMap(v)=""
				      }
		        }
		      }
		    }elseif fun="notnull" {
			    s nullv=$c(0)
			    s v="" f {
				    s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				    q:v=""
				    if (v'=nullv){
					    s resultMap(v)=""
				    }
			    }
		    }elseif fun="isnull" {
			    if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,$c(0))){
				    s resultMap($c(0))=""
			    }
		    }elseif fun="like" {
			    s plen=$ll(node.Params)
		      f j=1:1:plen {
		        s para=$lg(node.Params,j)
		        s pattern=##class(DHCWL.DM.Util.StringUtil).LikePatternConvert(para)
		        s v="" f {
				      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
				      q:v=""
				      if (v ?@pattern){
					      s resultMap(v)=""
				      }
		        }
		      }
		    }
		  }
		}elseif funType="C" {
		  s ccl=funCall.Call()
		  s ccll=$ll(ccl)
		  f i=1:1:ccll {
		    s v=$lg(ccl,i,"")
		    q:v=""
		    f j=1:1:partLen {
		      s partInd=$lg(partList,j,"")
		      continue:partInd=""
		      if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v)) s resultMap(v)=""
		    }
		  }
		}
	}
	
	s v="",i=0 f{
	    s v=$o(resultMap(v))
	    q:v=""
	    s i=i+1
	    s $list(result,i)=v
	  }
	q result
}

ClassMethod BacksteppingThemeFromFilter(cubeId, partitionList As %List, parsedDimStu As DHCWL.DM.Core.ParsedDimStruct, filterNode As DHCWL.DM.Util.FilterTree, visitCount As %Integer, ByRef inputIdMap, ByRef outputIdMap)
{
	s sn=parsedDimStu.SN
	s partLen=$ll(partitionList)
	k resultMap
	s isRelation=parsedDimStu.IsRelationDim()
	if (visitCount=1){
	  s funCall=filterNode.FunCall
	  s funType=funCall.FunctionConfig.SubType
	  s fun=funCall.FunctionConfig.Name
	  if (funType="I") { //Iterator
	    f i=1:1:partLen {
	      s partInd=$lg(partitionList,i,"")
	      continue:partInd=""
	      if (isRelation'=1){
		    s v="" f {
		      s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
		      q:v=""
	          i funCall.Call($lb(v)) {
		        s resultMap(v)=""
	          }
	        }
	      }else{
		    s v="" f {
		      s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
		      q:v=""
	          i funCall.Call($lb(v)) {
		        s resultMap(v)=""
	          }
	        }
	      }
	    }
	  }elseif (funType="C") {
		s ccl=funCall.Call()
	    s ccll=$ll(ccl)
	    f i=1:1:ccll {
	      s v=$lg(ccl,i,"")
	      q:v=""
	      if (isRelation'=1){
		    f j=1:1:partLen {
	          s partInd=$lg(partitionList,j,"")
	          continue:partInd=""
	          if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v)) s resultMap(v)=""
	        }
	      }else{
		    f j=1:1:partLen {
	          s partInd=$lg(partitionList,j,"")
	          continue:partInd=""
	          if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v)) s resultMap(v)=""
	        }
	      }
	    }
	  }elseif (funType="MO") {
		f i=1:1:partLen {
	      s partInd=$lg(partitionList,i,"")
	      continue:(partInd="")||( '$d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn)) )
	      i fun="=" {
	        s plen=$ll(node.Params)
	        if (isRelation'=1){
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            if $d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para)) {
		          s resultMap(para)=""
	            }
	          }
	        }else{
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            if $d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para)) {
		          s resultMap(para)=""
	            }
	          }
	        }
	      }elseif fun=">" {
	        s plen=$ll(node.Params)
	        if (isRelation'=1){
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=para f {
		          s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
		          q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }else{
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=para f {
		          s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
		          q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }
	      }elseif fun=">=" {
	        s plen=$ll(node.Params)
	        if (isRelation'=1){
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para),-1)
	            f{
		          s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v))
		          q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }else{
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para),-1)
	            f{
		          s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v))
		          q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }
	      }elseif fun="<"{
	        s plen=$ll(node.Params)
	        if (isRelation'=1){
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=para 
	            f {
	              s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1)
	              q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }else{
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=para 
	            f {
	              s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v),-1)
	              q:v=""
	              s resultMap(v)=""
	            }
	          }
	        }
	      }elseif fun="<=" {
	        s plen=$ll(node.Params)
	        if (isRelation'=1){
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,para))
	            f{
		          s v=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,v),-1) q:v=""  d
	              s resultMap(v)=""
	            }
	          }
	        }else{
		      f j=1:1:plen {
	            s para=$lg(node.Params,j)
	            s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,para))
	            f{
		          s v=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,sn,v),-1) q:v=""  d
	              s resultMap(v)=""
	            }
	          }
	        }
	      }
	    }
	  }
	  s outputList=$lb(),outputIdMapSub=0
	  s v="",i=0 f{
	    s v=$o(resultMap(v))
	    q:v=""
	    s i=i+1
	    try{
		  s $list(outputList,i)=v
	    }catch(e){
		  s i=1
		  s outputIdMap(outputIdMapSub)=outputList
		  s outputList=$lb()
		  s $list(outputList,i)=v
		  s outputIdMapSub=outputIdMapSub+1
	    }
	  }
	  s outputIdMap(outputIdMapSub)=outputList
	}else{
	  s ind="" f{
	    s ind=$o(inputIdMap(ind))
	    q:ind=""
	    s idList=inputIdMap(ind)
	    s returnRKSN=parsedDimStu.returnBaseRowKey.SerialNumber
	    ;s return
	    
	  }
	}
}

ClassMethod BacksteppingCCDimsFromeFilter2(cubeId, partList As %List, dimMask, dimStructList As %List, node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall) As %List
{
	s result=$lb()
	q:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1)) result
	s dataType=12
	if (node.parsedDimStruct'="")&&(node.parsedDimStruct.jdbcType'=""){
	  s dataType=node.parsedDimStruct.jdbcType
	}
	;s dimStructList=node.DimStruct
	s dimId=$lg(dimStructList,1)
	s sn=$lg(dimStructList,3)
	s funType=funCall.FunctionConfig.SubType
	s fun=funCall.FunctionConfig.Name
	s partLen=$ll(partList)
	k resultMap
	if funType="I" {
	  f i=1:1:partLen {
	    s partInd=$lg(partList,i,"")
	    continue:partInd=""
	    s v="" f {
		  s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v))
		  q:v=""
	      i funCall.Call($lb(v)) {
		    s resultMap(v)=""
	      }
	    }
	  }
	}elseif funType="MO" {
	  s MF("!=")="'=",MF("'=")="'=",MF("[")="["
	  f i=1:1:partLen {
	    s partInd=$lg(partList,i,"")
	    continue:(partInd="")||( '$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn)) )
	    i fun="=" {
	      s plen=$ll(node.Params)
	      f j=1:1:plen {
	        s para=$lg(node.Params,j)
	        s:dataType=91 para=$zdh(para,3)
	        if $d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para)) s resultMap(para)=""
	      }
	    }elseif fun=">" {
	      s plen=$ll(node.Params)
	      f j=1:1:plen {
	        s para=$lg(node.Params,j)
	        s:dataType=91 para=$zdh(para,3)
	        s v=para f {
		      s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v))
		      q:v=""
	          s resultMap(v)=""
	        }
	      }
	    }elseif fun=">=" {
	      s plen=$ll(node.Params)
	      f j=1:1:plen {
	        s para=$lg(node.Params,j)
	        s:dataType=91 para=$zdh(para,3)
	        s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para),-1)
	        f{
		      s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v))
		      q:v=""
	          s resultMap(v)=""
	        }
	      }
	    }elseif fun="<"{
	      s plen=$ll(node.Params)
	      f j=1:1:plen {
	        s para=$lg(node.Params,j)
	        s:dataType=91 para=$zdh(para,3)
	        s v=para 
	        f {
	          s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v),-1)
	          q:v=""
	          s resultMap(v)=""
	        }
	      }
	    }elseif fun="<=" {
	      s plen=$ll(node.Params)
	      f j=1:1:plen {
	        s para=$lg(node.Params,j)
	        s:dataType=91 para=$zdh(para,3)
	        s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,para))
	        f{
		      s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v),-1) q:v=""  d
	          s resultMap(v)=""
	        }
	      }
	    }elseif fun="between" {
		  s stvalue=$lg(node.Params,1,"")
		  s edvalue=$lg(node.Params,2,"")
		  if (stvalue'="")&&(edvalue'=""){
			if (dataType=91){
			  s stvalue=$zdh(stvalue,3)
			  s edvalue=$zdh(edvalue,3)
			}
			s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,stvalue),-1)
	        f{
		      s v=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v))
		      q:v=""
	          s resultMap(v)=""
	          q:v=edvalue
	        }
		  }
	    }
	  }
	}elseif funType="C" {
	  s ccl=funCall.Call()
	  s ccll=$ll(ccl)
	  f i=1:1:ccll {
	    s v=$lg(ccl,i,"")
	    q:v=""
	    f j=1:1:partLen {
	      s partInd=$lg(partList,j,"")
	      continue:partInd=""
	      if $d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,v)) s resultMap(v)=""
	    }
	  }
	}
	s v="",i=0 f{
	  s v=$o(resultMap(v))
	  q:v=""  d
	  s i=i+1
	  s $list(result,i)=v
	}
	q result
}

ClassMethod FetchBitIndexFromDims2(cubeId, partList As %List, dimStruct As %List, node As DHCWL.DM.Util.FilterTree, fromDimValue As %List, isUpdateFilter As %Boolean = 0) As %Status
{
	k segBitIndex
	s dimId=$lg(dimStruct,1)
	s sn=$lg(dimStruct,3)
	s len=$ll(fromDimValue),partLen=$ll(partList)
	if (node.IsRelationDim()=0){
		f i=1:1:partLen{
			s partInd=$lg(partList,i,"")
			continue:partInd=""
			continue:'$d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn))
			f j=1:1:len {
				s dim=$lg(fromDimValue,j,"")
				continue:dim=""
				continue:'$d(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,dim))
				s segInd="" f{
					s segInd=$o(^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,dim,segInd))
					q:segInd=""
					s segBit=^DHCWL.DM.T.CubeDStructI(partInd,cubeId,sn,dim,segInd)
					i $d(segBitIndex(partInd,segInd)){
						s segBitIndex(partInd,segInd)=$bitlogic(segBitIndex(partInd,segInd) | segBit)
					}else{
						s segBitIndex(partInd,segInd)=segBit
					}
					i $g(segBitIndex(partInd),-1)<segInd{
						s segBitIndex(partInd)=segInd
					}
				}
			}
		}
		m node.SegBitIndexMap=segBitIndex
	}else{
		k rmBitIMap
		;s sn=node.parsedDimStruct.SN
		;s sn=-sn
		b ;1
		f i=1:1:partLen{
		  s partInd=$lg(partList,i,"")
		  continue:partInd=""
		  continue:'$d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn))
		  f j=1:1:len {
				s dim=$lg(fromDimValue,j,"")
				continue:dim=""
				continue:'$d(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,dim))
				s rowid="" f{
					s rowid=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,dim,rowid))
					q:rowid=""
					s crdid=^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,0,sn,dim,rowid)
					continue:crdid=""
					s bitseg=rowid \ ..#MAXBITRANGE
					s bitsegind=rowid # ..#MAXBITRANGE
					i bitsegind=0 {
						s bitsegind=..#MAXBITRANGE
						s bitseg=bitseg-1
					}
					s $bit(segBitIndex(partInd,bitseg),bitsegind)=1
					i $g(segBitIndex(partInd),-1)<bitsegind{
						s segBitIndex(partInd)=bitsegind
					}
					s ^||tempcfrdind(partInd,cubeId,rowid,dim)=""
					s msn="" f{
						s msn=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,1,msn))
						q:msn=""
						s msegind="" f{
							s msegind=$o(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,1,msn,crdid,msegind))
							q:msegind=""
							s rmetricbit=$g(^DHCWL.DM.T.CubeDStructIR(partInd,cubeId,1,msn,crdid,msegind),"")
							s prermetricbit=$g(rmBitIMap(partInd,rowid,msn,msegind),"")
							s rmBitIMap(partInd,rowid,msn,msegind)=$bitlogic(prermetricbit | rmetricbit)
						}
					}
				}
		  }
		}
		m node.SegBitIndexMap=segBitIndex
		m node.RMBitIMap=rmBitIMap
	}
	
	q $$$OK
}

ClassMethod FetchCCBitIndexFromDims2(cubeId, partList As %List, dimMask, dimStruct As %List, fromDimValue As %List, ByRef segBitIndex) As %Status
{
	k segBitIndex
	q:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1)) $$$OK
	s dimId=$lg(dimStruct,1)
	s sn=$lg(dimStruct,3)
	s len=$ll(fromDimValue),partLen=$ll(partList)
	f i=1:1:partLen{
	  s partInd=$lg(partList,i,"")
	  continue:partInd=""
	  continue:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn))
	  f j=1:1:len {
		s dim=$lg(fromDimValue,j,"")
		continue:dim=""
		continue:'$d(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim))
		s segInd=""
		f{
		  s segInd=$o(^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim,segInd))
		  q:segInd=""
		  s segBit=^TEMPCMPDCUBEDI(cubeId,dimMask,1,partInd,sn,dim,segInd)
		  i $d(segBitIndex(partInd,segInd)){
			s segBitIndex(partInd,segInd)=$bitlogic(segBitIndex(partInd,segInd) | segBit)
		  }else{
			s segBitIndex(partInd,segInd)=segBit
		  }
		  i $g(segBitIndex(partInd),-1)<segInd{
			s segBitIndex(partInd)=segInd
		  }
		}
	  }
	}
	q $$$OK
}

// 适用于数据结构1

ClassMethod FetchDimFromFunCall(cubeId, partId, rowId, computedMetricId, ByRef row As %List, ByRef parsedDimStu As DHCWL.DM.Core.ParsedDimStruct, ByRef returnListMap, ByRef refdMetricInfo, hasRelaDimFilter As %Boolean = 0)
{
	s returnListMapInd=0
	s returnListMap(returnListMapInd)=$lb()
	s listCnt=1
	s funCallStu=parsedDimStu.funCallStruct
	s parasSN=funCallStu.paramSNs
	s paravs=funCallStu.paramValues
	s funCall=funCallStu.funCall
	f i=1:1:$ll(parasSN){
	  s psn=$lg(parasSN,i,"")
	  if (psn [ "#R"){
	  }elseif (+psn>0){
			s $list(paravs,i)=$lg(row,psn)
	  }
	}
	f i=1:1:$ll(parasSN){
	  s psn=$lg(parasSN,i,"")
	  if (psn [ "#R"){
			s psn=+psn
			s psn2=-psn
			s rind="" f{
			  s rind=$o(^DHCWL.DM.T.CubeDStructV(partId,cubeId,rowId,psn2,rind))
			  q:rind=""
			  s rlist=^DHCWL.DM.T.CubeDStructV(partId,cubeId,rowId,psn2,rind)
			  s rlistlen=$ll(rlist)
			  f j=1:1:rlistlen{
					s rvalue=$lg(rlist,j)
					if hasRelaDimFilter{
						continue:'$d(^||tempcfrdind(partId,cubeId,rowId,rvalue))
					}
			    s $list(paravs,i)=rvalue
			    s ret= funCall.Call(paravs)
			    try{
					  s $list(returnListMap(returnListMapInd),listCnt)=ret
					  s listCnt=listCnt+1
			    }catch(e){
					  s returnListMapInd=returnListMapInd+1
					  s listCnt=1
					  s $list(returnListMap(returnListMapInd),listCnt)=ret
					  s listCnt=listCnt+1
			    }
			    d RelDimMetricIndex2
			  }
			}
	  }
	}
	q
RelDimMetricIndex
	if ($d(^DHCWL.DM.T.CubeDStructI(partId,cubeId,psn2,rvalue,rowId))){
		s msn="" f{
			s msn=$o(refdMetricInfo(msn))
			q:msn=""
			continue:'$d(^DHCWL.DM.T.CubeDStructI(partId,cubeId,psn2,rvalue,rowId,msn))
			s rseg="" f{
				s rseg=$o(^DHCWL.DM.T.CubeDStructI(partId,cubeId,psn2,rvalue,rowId,msn,rseg))
				q:rseg=""
				s rmetricbit=$g(^DHCWL.DM.T.CubeDStructI(partId,cubeId,psn2,rvalue,rowId,msn,rseg),"")
				continue:rmetricbit=""
				s prermetricbit=$g(^||temprmind(rvalue,msn,rseg),"")
				if (prermetricbit=""){
					s ^||temprmind(computedMetricId,ret,msn,rseg)=rmetricbit
				}else{
					s ^||temprmind(computedMetricId,ret,msn,rseg)=$bitlogic(prermetricbit | rmetricbit)
				}
			}
		}
	}
	q
RelDimMetricIndex2
	s crdid=^DHCWL.DM.T.CubeDStructIR(partId,cubeId,0,psn,rvalue,rowId)
	if (crdid'=""){
		s msn="" f{
			s msn=$o(refdMetricInfo(msn))
			q:msn=""
			continue:'$d(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,1,msn,crdid))
			s rseg="" f{
				s rseg=$o(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,1,msn,crdid,rseg))
				q:rseg=""
				s rmetricbit=$g(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,1,msn,crdid,rseg),"")
				continue:rmetricbit=""
				if (hasRelaDimFilter)&&($d(^||tempcfrmind(partId,rowId))){
					s filterMetBit=^||tempcfrmind(partId,rowId,msn,rseg)
					s:filterMetBit'="" rmetricbit=$bitlogic(filterMetBit & rmetricbit)
				}
				s prermetricbit=$g(^||temprmind(rvalue,msn,rseg),"")
				if (prermetricbit=""){
					s ^||temprmind(computedMetricId,ret,msn,rseg)=rmetricbit
				}else{
					s ^||temprmind(computedMetricId,ret,msn,rseg)=$bitlogic(prermetricbit | rmetricbit)
				}
			}
		}
	}
	q
}

// 适用于数据结构2

ClassMethod FetchDimFromFunCall2(cubeId, partId, rowId, computedMetricId, ByRef row As %List, ByRef parsedDimStu As DHCWL.DM.Core.ParsedDimStruct, ByRef returnListMap)
{
	k returnListMap
	s returnListMapInd=0
	s returnListMap(returnListMapInd)=$lb()
	s listCnt=1
	s funCallStu=parsedDimStu.funCallStruct
	s parasSN=funCallStu.paramSNs
	s paravs=funCallStu.paramValues
	s funCall=funCallStu.funCall
	f i=1:1:$ll(parasSN){
	  s psn=$lg(parasSN,i,"")
	  if (psn [ "#R"){
	  }elseif (+psn>0){
		s $list(paravs,i)=$lg(row,psn)
	  }
	}
	f i=1:1:$ll(parasSN){
	  s psn=$lg(parasSN,i,"")
	  if (psn [ "#R"){
		s psn=+psn
		s rind="" f{
		  s rind=$o(^DHCWL.DM.T.CubeDStructR(partId,cubeId,rowId,psn,rind))
		  q:rind=""
		  s rlist=^DHCWL.DM.T.CubeDStructR(partId,cubeId,rowId,psn,rind)
		  s rlistlen=$ll(rlist)
		  f j=1:1:rlistlen{
			s rvalue=$lg(rlist,j)
		    s $list(paravs,i)=rvalue
		    s ret= funCall.Call(paravs)
		    try{
			  s $list(returnListMap(returnListMapInd),listCnt)=ret
			  s listCnt=listCnt+1
		    }catch(e){
			  s returnListMapInd=returnListMapInd+1
			  s listCnt=1
			  s $list(returnListMap(returnListMapInd),listCnt)=ret
			  s listCnt=listCnt+1
		    }
		    if ($d(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,psn,rvalue,rowId))){
				  s msn="" f{
						s msn=$o(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,psn,rvalue,rowId,msn))
						q:msn=""
						s rseg="" f{
						  s rseg=$o(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,psn,rvalue,rowId,msn,rseg))
						  q:rseg=""
						  s rmetricbit=$g(^DHCWL.DM.T.CubeDStructIR(partId,cubeId,psn,rvalue,rowId,msn,rseg),"")
						  continue:rmetricbit=""
						  s prermetricbit=$g(^||temprmind(msn,rseg),"")
						  if (prermetricbit=""){
								s ^||temprmind(msn,rseg)=rmetricbit
						  }else{
								s ^||temprmind(msn,rseg)=$bitlogic(prermetricbit & rmetricbit)
						  }
						}
				  }
		    }
		  }
		}
	  }
	}
}

Storage Default
{
<Data name="CubeDStructDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDStructD</DataLocation>
<DefaultData>CubeDStructDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDStructD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDStructI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
