Class DHCWL.APP.Data.DataPackage Extends %RegisteredObject
{

/// d ##class(DHCWL.APP.Data.DataPackage).Test()
ClassMethod Test()
{
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate","RegLocHpNums","2012-04-01","2012-04-30","byMonth","R")
	s dp=##class(DataPackage).SetResultSet(rs,"Test")
	s js=dp.GetReader()
	s dsm=dp.GetDataStorageManager()
	s cursor=dsm.GetCursor("Test")
	s js=dp.GetReader()
	s jo=js.GetJsonObject()
	s dsm=dp.GetDataStorageManager()
	s cursor=dsm.GetCursor("Test")
	d js.SetOnceDomain(1,2)
	s pivot=js.GetOnceDomainFrom()
	while((pivot'="")) {
		w jo.ToString()
		if 'js.IsOnceLast() w ","
		s pivot=js.OnceNext()
		w !
	}
	;s cursor2=cursor
	/*
	d js.SetOnceDomain(1,2)
	w js.GetDomainCount(),!
	w js.GetOnceDomainCount(),!
	s jo=js.GetJsonObject()
	d cursor.MoveTo(1)
	s pivot=js.GetOnceDomainFrom()
	while((pivot'="")) {
		w jo.ToString()
		if 'js.IsOnceLast() w ","
		s pivot=js.OnceNext()
		w !
	}*/
	w "---------------------",!
	s cursor=dsm.GetCursor("Test")
	s js=dp.GetReader()
	d js.SetOnceDomain(3,4)
	s jo=js.GetJsonObject()
	d cursor.MoveTo(3)
	while(cursor){
		w jo.ToArrayString()
		if 'cursor.IsLast() w ","
		w !
		s cursor=js.OnceNext()
	}
	w "---------------------",!
	s xml=dp.GetReader("XML")
	s cursor=dsm.GetCursor("Test")
	s cursor=cursor.MoveToFirst()
	d xml.SetOnceDomain(5,6)
	w xml.GetDomainCount(),!
	w xml.GetOnceDomainCount(),!
	s xo=xml.GetXMLObject()
	s pivot=js.GetOnceDomainFrom()
	while((pivot'="")) {
		w xo.ToString()
		if 'xml.IsOnceLast() w ","
		s pivot=xml.OnceNext()
		w !
	}
	/*
	s pivot=xml.GetOnceDomainFrom()
	f {
		q:cursor=""
		w xo.ToString()
		if 'cursor.IsLast() w ","
		w !
		q:pivot=xml.GetOnceDomainTo()
		s cursor=cursor.Next()
		q:cursor=""
		s pivot=cursor.GetPivot()
	}
	*/
	w "---------------------",!
	d xml.GetXMLStream(1,3,"TestList",.stream)
	s sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	;b ;000
}

Property dataManager As DataStorageManager;

Property reader As Reader;

ClassMethod DataPackage(metaStr = "", storageGlobalName = "^temp") As DataPackage
{
	s dp=##class(DHCWL.APP.Data.DataPackage).%New()
	q:metaStr="" dp
	s dp.dataManager=##class(DataStorageManager).DataStorageManager(##class(BaseMeta).BaseMeta(metaStr))
	q dp
}

ClassMethod SetResultSet(resultSet As %ResultSet, className) As DataPackage
{
	s typeMap(1)="%BINARY",typeMap(2)="%DATE",typeMap(3)="%DOUBLE",typeMap(4)="%HANDLE",typeMap(5)="%INTEGER",typeMap(6)="%LIST"
	s typeMap(7)="%LONGVARCHAR",typeMap(8)="%TIME",typeMap(9)="%TIMESTAMP",typeMap(10)="%String",typeMap(11)="%STATUS",typeMap(12)="%BINARYSTREAM"
	s colCnt=resultSet.GetColumnCount()
	s metaStr=""
	f i=1:1:colCnt {
		s proName=resultSet.GetColumnName(i)
		s head=resultSet.GetColumnHeader(i)
		s type=resultSet.GetColumnType(i)
		s type=typeMap(type)
		s proDef=proName_":"_type_":"_head
		if metaStr="" {
			s metaStr=proDef
		}else{
			s metaStr=metaStr_","_proDef
		}
	}
	s metaStr=className_":{"_metaStr_"}"
	s meta=##class(BaseMeta).BaseMeta(metaStr)
	s dpm=##class(DataStorageManager).DataStorageManager(meta)
	d dpm.GetCursor(className)
	while(resultSet.Next()){
		k array
		f i=1:1:colCnt {
			s array(i)=resultSet.GetData(i)
		}
		d dpm.Insert(.array)
	}
	d resultSet.Close()
	s dp=##class(DataPackage).DataPackage()
	s dp.dataManager=dpm
	q dp
}

Method GetCursor(name)
{
	q ..dataManager.GetCursor(name)
}

Method GetDataStorageManager() As DataStorageManager
{
	q ..dataManager
}

Method GetReader(readerType = "Json")
{
	if (readerType="Json"){
		s json=##class(Json).Json(..dataManager)
		s ..reader=json
	}elseif (readerType="XML"){
		s json=##class(XML).XML(..dataManager)
		s ..reader=json
	}
	
	q ..reader
}

}
