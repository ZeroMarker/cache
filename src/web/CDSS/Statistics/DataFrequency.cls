/// 名称:用户使用频率 
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2017-06-20
Class web.CDSS.Statistics.DataFrequency Extends %RegisteredObject
{

/// Creator:陈莹
/// CreatDate:2018-06-19
/// Description:数据使用频次展示界面查询
/// Table:WDT.CDSS.DataFrequency
/// Input:tablename,desc  sort: BDPDAFFrequency，order: asc
/// d ##class(%ResultSet).RunQuery("web.CDSS.Statistics.DataFrequency","GetList","","","w","","","")
Query GetList(rowid As %String, tablename As %String, desc As %String, userdr As %String, sort, order) As %Query(ROWSPEC = "ID,BDPDAFTableName,BDPDAFDataReference,BDPDAFDesc,BDPDAFFrequency,BDPDAFUserID,BDPCTLocDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tablename As %String, desc As %String, userdr As %String, sort, order) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s BDPDAFTableName=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),2)
		s BDPDAFDesc=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),4)        /// 对应表数据描述 节点 4
		s BDPDAFDataReference=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),3)          /// 对应表数据ID 节点 3   
		s BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),5)
		s BDPDAFUserID=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),6)
		s:BDPDAFUserID'="" BDPDAFUserID=$p($g(^SSU("SSUSR",BDPDAFUserID)),"^",2)
		s BDPCTLocDR=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),8)
		s:BDPCTLocDR'="" BDPCTLocDR=$p($g(^CTLOC(BDPCTLocDR)),"^",2)
		d OutputRow
	}
	else
	{
		if (sort="BDPDAFFrequency")
		{
			if ($d(^WDT.CDSS.DataFrequencyI)=10)&&($d(^WDT.CDSS.DataFrequencyI("TableFrequencyIdx"))=0)
			{
				d ##class(WDT.CDSS.DataFrequency).%BuildIndices()
			}
			if order="asc"  //升序
			{
				s Freq=0,sdir=1
			}
			if (order="desc")   //倒序
			{
				s Freq="",sdir=-1
			}
			for
			{
				s Freq=$o(^WDT.CDSS.DataFrequencyI("TableFrequencyIdx",Freq),sdir) q:(Freq="")||(Freq=0)
				s ID=0
				for
				{
					s ID=$o(^WDT.CDSS.DataFrequencyI("TableFrequencyIdx",Freq,ID)) q:(ID="")
					s BDPDAFTableName=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),2)
					s BDPDAFDesc=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),4)
					s BDPDAFDataReference=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),3)
					s BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),5)
					s BDPDAFUserID=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),6)
					s BDPDAFUserIDDR=BDPDAFUserID
					s:BDPDAFUserID'="" BDPDAFUserID=$p($g(^SSU("SSUSR",BDPDAFUserID)),"^",2)
					s BDPCTLocDR=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),8)
					s:BDPCTLocDR'="" BDPCTLocDR=$p($g(^CTLOC(BDPCTLocDR)),"^",2)
					s PINYIN=""
					s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPDAFDesc)
					i (($ZCONVERT(BDPDAFDesc,"U")[$ZCONVERT(desc,"U"))||(PINYIN[$ZCONVERT(desc,"U")))&&($ZCONVERT(BDPDAFTableName,"U")[$ZCONVERT(tablename,"U"))&&((BDPDAFUserIDDR=userdr)||(userdr=""))
					{
						d OutputRow
					}
				}
			}
			
		
			
			
		}
		else
		{
			s ID=""
			for
			{
				s ID=$o(^WDT.CDSS.DataFrequencyD(ID)) q:(ID="")||(ID=0)
				s BDPDAFTableName=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),2)
				s BDPDAFDesc=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),4)
				s BDPDAFDataReference=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),3)
				s BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),5)
				s BDPDAFUserID=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),6)
				s BDPDAFUserIDDR=BDPDAFUserID
				s:BDPDAFUserID'="" BDPDAFUserID=$p($g(^SSU("SSUSR",BDPDAFUserID)),"^",2)
				s BDPCTLocDR=$listget($g(^WDT.CDSS.DataFrequencyD(ID)),8)
				s:BDPCTLocDR'="" BDPCTLocDR=$p($g(^CTLOC(BDPCTLocDR)),"^",2)
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPDAFDesc)
				b ;1
				i (($ZCONVERT(BDPDAFDesc,"U")[$ZCONVERT(desc,"U"))||(PINYIN[$ZCONVERT(desc,"U")))&&($ZCONVERT(BDPDAFTableName,"U")[$ZCONVERT(tablename,"U"))&&((BDPDAFUserIDDR=userdr)||(userdr=""))
				{
					d OutputRow
				}
			}
		}
	
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPDAFTableName,BDPDAFDataReference,BDPDAFDesc,BDPDAFFrequency,BDPDAFUserID,BDPCTLocDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2017-06-20
/// Description:增加/修改 
/// Table:WDT.CDSS.DataFrequency
/// Input:SaveDataStr
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.CDSS.Statistics.DataFrequency).SaveData("BDPDAFTableName^BDPDAFDataReference^BDPDAFDesc^BDPDAFFrequency^BDPDAFType")
ClassMethod SaveData(SaveDataStr) As %String
{
	s eobj=##class(web.CDSSEntity.Statistics.DataFrequency).%New()
	s eobj.BDPDAFTableName=$P(SaveDataStr,"^",1)  //表名
	s eobj.BDPDAFDataReference= $P(SaveDataStr,"^",2)  //rowid
	s eobj.BDPDAFDesc=$P(SaveDataStr,"^",3)   //中心词
	S rs=##class(web.CDSS.Statistics.DataFrequency).SaveEntity(eobj)
	Q rs
}

/// Creator:陈莹
/// CreatDate:2017-06-20
/// Description:增加/修改 
/// Table:WDT.CDSS.DataFrequency
/// Input:web.CDSSEntity.Statistics.DataFrequency
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.CDSSEntity.Statistics.DataFrequency) As %String
{
    s $ZT="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.BDPDAFUserID=$g(%session.Data("LOGON.USERID"))
		s eobj.BDPCTLocDR=$g(%session.Data("LOGON.CTLOCID"))
		q:(eobj.BDPDAFTableName="")||(eobj.BDPDAFDataReference="")||(eobj.BDPDAFDataReference="") "{success:'false',errorinfo:'没有获取到表名和术语ID！'}"
		
		s uptablename=" "_$ZCONVERT(eobj.BDPDAFTableName,"U")
		s dataReference=" "_eobj.BDPDAFDataReference
		s RowId=$o(^WDT.CDSS.DataFrequencyI("TableReferenceIdx",uptablename,dataReference,0))
		s eobj.ID=RowId

		if (eobj.ID="")      
		{
			s obj=##class(WDT.CDSS.DataFrequency).%New()
			s eobj.BDPDAFFrequency=1  //新增时，频率为1 
		}
		else                           
		{
			s obj=##class(WDT.CDSS.DataFrequency).%OpenId(eobj.ID)
			
			s eobj.BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(RowId)),5)+1  //修改时，频率加1
			
			s bobj=##class(web.CDSSEntity.Statistics.DataFrequency).%New()
			
			s bobj.ID = eobj.ID
			s bobj.BDPDAFTableName = obj.BDPDAFTableName
			s bobj.BDPDAFDataReference   = obj.BDPDAFDataReference
			s bobj.BDPDAFDesc = obj.BDPDAFDesc
			s bobj.BDPDAFFrequency = obj.BDPDAFFrequency
			if $IsObject(obj.BDPDAFUserID){
					s bobj.BDPDAFUserID = obj.BDPDAFUserID.%Id() 
				}
			if $IsObject(obj.BDPCTLocDR){
					s bobj.BDPCTLocDR = obj.BDPCTLocDR.%Id() 
				}
			s bobj.BDPDAFType = obj.BDPDAFType
			
			
		}
		s obj.BDPDAFTableName = eobj.BDPDAFTableName
		s obj.BDPDAFDataReference   = eobj.BDPDAFDataReference
		s obj.BDPDAFDesc = eobj.BDPDAFDesc
		s obj.BDPDAFFrequency = eobj.BDPDAFFrequency
		d obj.BDPDAFUserIDSetObjectId(eobj.BDPDAFUserID)
		d obj.BDPCTLocDRSetObjectId(eobj.BDPCTLocDR)
		s obj.BDPDAFType=eobj.BDPDAFType
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
		}else{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s result = "{success:'false',errorinfo:'"_$ze_"'}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2017-8-24
/// Description:删除数据
/// Table:WDT.CDSS.DataFrequency
/// Input:DeleteDataStr  表名^数据的rowid
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Statistics.DataFrequency).DeleteDataStr("1")
ClassMethod DeleteDataStr(DeleteDataStr) As %String
{
	s result=""
	s BDPDAFTableName=$P(DeleteDataStr,"^",1)  //表名
	s BDPDAFDataReference= $P(DeleteDataStr,"^",2)  //rowid
	s uptablename=" "_$ZCONVERT(BDPDAFTableName,"U")
	s dataReference=" "_BDPDAFDataReference
	s RowId=$o(^WDT.CDSS.DataFrequencyI("TableReferenceIdx",uptablename,dataReference,0))
	s:RowId'="" result=##class(web.CDSS.Statistics.DataFrequency).DeleteData(RowId)
	Q result
}

/// Creator:谷雪萍
/// CreatDate:2017-8-24
/// Description:删除数据
/// Table:WDT.CDSS.DataFrequency
/// Input:id(rowID) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Statistics.DataFrequency).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s sc=##class(WDT.CDSS.DataFrequency).%DeleteId(id)
	if $$$ISOK(sc){
		s result="{success:'true',info:'删除成功！'}"
	}
	else{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}

	q result
}

/// Creator:fanwenkai
/// CreatDate:2021-09-16
/// Description:增加/修改 
/// Table:WDT.CDSS.DataFrequency
/// Input:SaveDataStr
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.CDSS.Statistics.DataFrequency).SaveDataForCDSS(^TMP("FWKSAVE1"),^TMP("FWKSAVE2"))
ClassMethod SaveDataForCDSS(paramItem As %String, PatientInfo As %String) As %String
{
	s IDNO = $p(PatientInfo,"^",1)
	s PatientDR = $p(PatientInfo,"^",2)
	s VisitID = $p(PatientInfo,"^",3)
	s VisitType = $p(PatientInfo,"^",4)
	s UserID=$p(PatientInfo,"^",5)
	s CTLocID=$p(PatientInfo,"^",7)
	s eobj=##class(web.CDSSEntity.Statistics.DataFrequency).%New()
	s eobj.BDPDAFTableName=$P(paramItem,"^",1)  //表名
	s eobj.BDPDAFDataReference= $P(paramItem,"^",2)  //rowid
	s eobj.BDPDAFDesc=$P(paramItem,"^",3)   //中心词
	s eobj.BDPDAFUserID=UserID
	s eobj.BDPCTLocDR=CTLocID
	q:(eobj.BDPDAFTableName="")||(eobj.BDPDAFDataReference="")||(eobj.BDPDAFDataReference="") "{success:'false',errorinfo:'没有获取到表名和术语ID！'}"		
	s uptablename=" "_$ZCONVERT(eobj.BDPDAFTableName,"U")
	s dataReference=" "_eobj.BDPDAFDataReference
	s RowId=$o(^WDT.CDSS.DataFrequencyI("TableReferenceIdx",uptablename,dataReference,0))
	s eobj.ID=RowId
	if (eobj.ID="")      
	{
		s obj=##class(WDT.CDSS.DataFrequency).%New()
		s eobj.BDPDAFFrequency=1  //新增时，频率为1 
	}
	else                           
	{
		s obj=##class(WDT.CDSS.DataFrequency).%OpenId(eobj.ID)
		
		s eobj.BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(RowId)),5)+1  //修改时，频率加1
		
		s bobj=##class(web.CDSSEntity.Statistics.DataFrequency).%New()
		
		s bobj.ID = eobj.ID
		s bobj.BDPDAFTableName = obj.BDPDAFTableName
		s bobj.BDPDAFDataReference   = obj.BDPDAFDataReference
		s bobj.BDPDAFDesc = obj.BDPDAFDesc
		s bobj.BDPDAFFrequency = obj.BDPDAFFrequency
		if $IsObject(obj.BDPDAFUserID){
				s bobj.BDPDAFUserID = obj.BDPDAFUserID.%Id() 
			}
		if $IsObject(obj.BDPCTLocDR){
				s bobj.BDPCTLocDR = obj.BDPCTLocDR.%Id() 
			}
		s bobj.BDPDAFType = obj.BDPDAFType
		
		
	}
	s obj.BDPDAFTableName = eobj.BDPDAFTableName
	s obj.BDPDAFDataReference   = eobj.BDPDAFDataReference
	s obj.BDPDAFDesc = eobj.BDPDAFDesc
	s obj.BDPDAFFrequency = eobj.BDPDAFFrequency
	d obj.BDPDAFUserIDSetObjectId(eobj.BDPDAFUserID)
	d obj.BDPCTLocDRSetObjectId(eobj.BDPCTLocDR)
	s obj.BDPDAFType=eobj.BDPDAFType
	s sc=obj.%Save()
	do obj.%Close()
	if $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		
	}
	q result
}

}
