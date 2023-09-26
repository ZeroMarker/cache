/// CTOR: QP
/// DATE: 2019-06-11
/// DESC: 医生站交班本功能扩展类
Class web.DHCDocPassWorkF1 Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-06-11
/// DESC: XML打印-获取元数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkF1).GetPWPrintData(95,"2019-06-06","M")
ClassMethod GetPWPrintData(LocId As %String, FindDate As %String, FindBCType As %String) As %String
{
	//n (LocId,FindDate,FindBCType)
	q:(FindDate="")||(FindBCType="")||(LocId="") ""
	s mDate=FindDate
	s FindDate = ..%ZDH(FindDate)
	q:'$d(^DDPW(0,"LocDateType",LocId,FindDate,FindBCType)) ""
	s printObj = ##class(ext.util.JsonObject).%New()
	s pwid = $o(^DDPW(0,"LocDateType",LocId,FindDate,FindBCType,""))
	s pwxml = $p(^DDPW(pwid),"^",5)
	s bcname = $p(^DDPW(pwid),"^",12)
	s mDate=mDate_" "_bcname_"交班明细"
	s PWObj=##class(web.DHCDocPassWork).%New()
	d PWObj.XMLNodeDeserialize(.PWObj,"PW",pwxml)
	//s elements=##class(web.DHCDocPassWorkC1).GetClassPropertyList("web.DHCDocPassWork",1)
	s elements=##class(web.DHCDocPassWorkC1).GetAllPatType()
	do printObj.Put("mDate",mDate)
	s Len = $l(elements,"^")
	f i=1:1:Len  {
		s cName=$p(elements,"^",i)
		s cDesc=$p(^CF.OPDoc.PW("WKType",cName),"^",1)
		s cValue=$ZOBJPROPERTY(PWObj, cName)
		s cContent=cDesc_": "_cValue
		do printObj.Put(cName,cContent)
	}
	s mRtn = printObj.GetPrintData()
	do printObj.%Close()
	set printObj = ""
	quit mRtn
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-06-11
/// DESC: XML打印-获取元数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkF1).SetPWColumsName("seqno,PatWorkType,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser,FindDate")
ClassMethod SetPWColumsName(mList) As %String
{
	s Len=$l(mList,",")
	s outList=$lb("")
	f i=1:1:Len {
		s column=$p(mList,",",i)
		i column="seqno" s column="序号"
		e  i column="PatWorkType" s column="类型"
		e  i column="PatName" s column="姓名"
		e  i column="PatSex" s column="性别"
		e  i column="PatAge" s column="年龄"
		e  i column="PatDiagnos" s column="诊断"
		e  i column="PatOperName" s column="手术"
		e  i column="PatMedicareNo" s column="住院号"
		e  i column="CurBedCode" s column="床号"
		e  i column="BCRemark" s column="交班信息"
		e  i column="BCRemarkUser" s column="交班人"
		e  i column="FindDate" s column="交班日期"
		e  s column=""
		s $list(outList,i)="<font style='font-weight:bold;'>"_column_"</font>"
	}	
	Q outList
}

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 打印列表
/// IN  : 
/// OUT : 
/// TABL: 
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWorkF1","QryPWList","95","2019-06-06","","","","M","","0")
Query QryPWList(LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", FindWard = "", PrevFlag = "") As %Library.Query(ROWSPEC = "seqno,PatWorkType,PatName,PatSex,PatAge,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser,FindDate")
{
}

ClassMethod QryPWListExecute(ByRef qHandle As %Library.Binary, LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", FindWard = "", PrevFlag = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TEMP("hsy",1)=$lb(LocId,FindDate,UserId,FindPatWorkType,FindPatNo,FindBCType,FindWard,PrevFlag)
	s rs=##class(%Library.ResultSet).%New("web.DHCDocPassWorkE2:FindPassWorkPatList")
	d rs.Execute(LocId,FindDate,UserId,FindPatWorkType,FindPatNo,FindBCType,FindWard,PrevFlag)
	s FindDate=..%ZD(FindDate)
	s mList="seqno,PatWorkType,PatName,PatSex,PatAge,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser,FindDate"
	s OutputList=..SetPWColumsName(mList)
	d OutputRow1
	if rs.QueryIsValid() {
		s seqno=0
		s columns=rs.GetColumnCount()
		while rs.Next() {
			s (PatWorkType,PatNo,PatName,PatSex,PatAge)=""
			for i=1:1:columns {
				s colName = rs.GetColumnHeader(i)
				i colName="PatWorkType" d
				.s PatWorkType=rs.GetData(i)
				.s PatWorkType=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",1)
				//i colName="PatNo" s PatNo=rs.GetData(i)
				i colName="PatName" s PatName=rs.GetData(i)
				i colName="PatSex" s PatSex=rs.GetData(i)
				i colName="PatAge" s PatAge=rs.GetData(i)
				i colName="PatDiagnos" s PatDiagnos=rs.GetData(i)
				i colName="PatOperName" s PatOperName=rs.GetData(i)
				
				i colName="PatMedicareNo" s PatMedicareNo=rs.GetData(i)
				i colName="CurBedCode" s CurBedCode=rs.GetData(i)
				i colName="BCRemark" {
					s BCRemark=rs.GetData(i)
					s BCRemark=##class(web.DHCDocPassWorkC1).PrintContentHtml(BCRemark)
					/*
					i BCRemark'="" d
					.s cLen=$l(BCRemark)
					.s mBCRemark=$Extract(BCRemark,1,15)
					.s BCRemark=mBCRemark_"\n"_$Extract(BCRemark,16,cLen)
					*/
				}
				
				i colName="BCRemarkUser" s BCRemarkUser=rs.GetData(i)
				
			}
			s seqno=seqno+1
			s OutputList=$lb(seqno,PatWorkType,PatName,PatSex,PatAge,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser,FindDate)
			d OutputRow1
		}
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryPWListFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryPWListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPWListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryPWListFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-01-07
/// DESC: 是否已经保存
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkF1).HasSave()
ClassMethod HasSave(LocId As %String, FindDate As %String, BCode As %String) As %String
{
	s mRtn=""
	s FindDate=..%ZDH(FindDate)
	s yesterday=..%SysDate()-1
	s FirstBCInfo=##class(web.DHCDocPassWorkE2).GetFirstBCInfo()
	s FirstSTime=$p(FirstBCInfo,"^",3)
	s bol=(FindDate=..%SysDate())
	s CBCInfo=##class(web.DHCDocPassWorkE2).GetCurrentBC()
	s CBCode=$p(CBCInfo,"^",1)
	//如果当前班次为昨天的夜班
	i ((FindDate=yesterday)&&(BCode=CBCode)) {
		s bol=1
	}
	i '$d(^DDPW(0,"LocDateType",LocId,FindDate,BCode)) s mRtn=0
	e  s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 删除测试数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkF1).DelTestData()
ClassMethod DelTestData() As %String
{
	;清楚班次测试数据
	&SQL(DELETE FROM SQLUser.DHC_DocPassWorkBcs WHERE BC_Code LIKE '%CS%')
	
	;清楚病人类型
	s node=""
	s type=""
	f  s type=$o(^CF.OPDoc.PW("WKType",type)) q:type=""  d
	.s typeU=$zcvt(type,"U")
	.q:(typeU'["CS")
	.i node="" s node=type
	.e  s node=node_$c(1)_type
	
	if (node'="") {
		f i=1:1:$L(node,$c(1)) d
		.s item=$p(node,$c(1),i)
		.k ^CF.OPDoc.PW("WKType",item)
		
	}
	
	;清楚规则配置
	s node=""
	s type=""
	f  s type=$o(^CF.OPDoc.PW("GZ",type)) q:type=""  d
	.s typeU=$zcvt(type,"U")
	.q:(typeU'["CS")
	.i node="" s node=type
	.e  s node=node_$c(1)_type
	
	if (node'="") {
		f i=1:1:$L(node,$c(1)) d
		.s item=$p(node,$c(1),i)
		.k ^CF.OPDoc.PW("GZ",item)
		
	}
	
	;清楚业务数据
	k ^DDPW
	k ^BS.OPDoc.PW
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 更新XML数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkF1).UpdatePWXML()
ClassMethod UpdatePWXML(Node, PWID, Action, OldNode) As %String
{
	S ^QP("UpdatePWXML")=$LB(Node,PWID,Action,OldNode)
	Q:(PWID="")||(Node="")||(Action="") -1
	s PWXML=$P(^DDPW(PWID),"^",5)
	
	i Action="Add" {
		s XML=##class(web.DHCDocPassWorkC1).PlusXML(Node,PWXML)
	} elseif Action="Edit" {
		s PWXML=##class(web.DHCDocPassWorkC1).SubXML(OldNode,PWXML)
		s XML=##class(web.DHCDocPassWorkC1).PlusXML(Node,PWXML)
	} else {
		s XML=PWXML
	}
	
	&SQL(
		UPDATE SQLUser.DHC_DocPassWork SET DDPW_XML=:XML WHERE DDPW_RowId=:PWID
	)
	
	Q SQLCODE
}

}
