Import sqluser

/// Creator :QQA
/// CreatDate:2017-03-27
Class web.DHCEMDocOrderCat Extends %Persistent [ Not ProcedureBlock ]
{

/// Creator : QQA
/// CreatDate:2017-03-27	
/// Input:医院ID
/// w ##class(web.DHCEMDocOrderCat).queryCatList("2")
ClassMethod queryCatList(hospDrID = "") As %String
{
	n (%session,hospDrID)
	s jsonObj=##class(web.DHCAPPJsonCommon).%New()
	s count = 0
	w "{""rows"":["
	s docId =""
	f  s docId = $o(^DHCEMDOCA(docId)) q:docId=""  d
	.s oecDr = $p($g(^DHCEMDOCA(docId)),"^",1)
	.s hospDr = $p($g(^DHCEMDOCA(docId)),"^",2)
	.q:oecDr=""
	.s oecDesc = ""
	.s oecDesc = $p($g(^OEC("ORCAT",oecDr)),"^",2)
	.s activeFlag = $p($g(^DHCEMDOCA(docId)),"^",4)
	.s hospDr = $p($g(^DHCEMDOCA(docId)),"^",3)
	.q:(hospDrID'="")&(hospDrID'=hospDr) //hxy 2019-07-18
	.s hospDesc = ""
	.s hospDesc = $p($g(^CT("HOSP",hospDr)),"^",2)
	.s data = oecDesc_"^"_activeFlag_"^"_hospDesc_"^"_docId_"^"_oecDr_"^"_hospDr
	.s count=count+1
	.w $case(count,1:"",:",")
	.w jsonObj.getJsonData("oecDesc^activeFlag^hospDesc^docId^oecDr^hospDr",data)
	w "],""total"":"_count_"}"
	q ""
}

/// Creator : QQA
/// CreatDate:2017-03-27	
/// Script: 获取医嘱大类
/// Input:
/// w ##class(web.DHCEMDocOrderCat).jsonListCat("2")
ClassMethod jsonListCat(hospId) As %String
{
	n (hospId,%session)
	s jsonObj=##class(web.DHCAPPJsonCommon).%New()
	s count = 0
	w "["
	s orcDr = ""
	f  s orcDr =  $o(^OEC("ORCAT",orcDr)) q:orcDr=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("OEC_OrderCategory",orcDr,hospId)'="Y" //hxy 2020-05-26
	.s orcDesc = ""
	.s orcDesc = $p($g(^OEC("ORCAT",orcDr)),"^",2)
	.s data = orcDr_"^"_orcDesc
	.s count=count+1
	.w $case(count,1:"",:",")
	.w jsonObj.getJsonData("value^text",data)
	w "]"
	q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-03-10
/// Description:： 删除医生评估护士分级表
/// Table：        DHC_EmDocOrderCat
/// Input：	      	Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveDocOrderCat(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmDocOrderCat).%DeleteId(Id)
	  q 0
}

/// Creator : QQA
/// CreatDate:2017-03-27	
/// Script: 获取医嘱大类
/// Input:
/// w ##class(web.DHCEMDocOrderCat).saveTable("10^否^3$$11^是^3$$6^是^3$$8^是^3$$7^否^3$$5^是^3$$4^是^3$$3^是^3$$1^是^3$$2^是^3$$9^是^2$$1^是^2$$3^是^2$$6^是^2$$4^是^2$$2^是^2$$11^是^2$$7^是^2$$10^是^2$$5^是^2$$12^是^2","2")
ClassMethod saveTable(listData, hospId)
{
	n (listData,hospId)
	;^12^Y^2
	ts
	
	;&sql(DELETE DHC_EmDocOrderCat WHERE DOC_RowID !=0) //hxy 2020-05-26 注释
	&sql(DELETE DHC_EmDocOrderCat WHERE DOC_Hosp_Dr =:hospId) //hxy 2020-05-26
	i (SQLCODE'=0)&&(SQLCODE'=100) tro
	q:(SQLCODE'=0)&&(SQLCODE'=100) SQLCODE

	s saveFlag=0
	s len = $l(listData,"$$")
	for i =1:1:len q:saveFlag'=0  d
	.s rowData = $p(listData,"$$",i)
	.;s IsExit = ##class(web.DHCEMDocOrderCat).IsExsit(rowData)
	.;s saveFlag=IsExit
	.;q:IsExit=1
	.s docID ="" ;$p(rowData,"^",1) 
	.s oecDr =$p(rowData,"^",1) 
	.s activeFlag =$p(rowData,"^",2)
	.i activeFlag="是" s activeFlag="Y" //hxy 2018-10-16
	.i activeFlag="否" s activeFlag="N" //hxy 2018-10-16
	.s hospDr =$p(rowData,"^",3)
	.i docID="" d
	..&sql(INSERT INTO DHC_EmDocOrderCat (DOC_Oec_Dr,DOC_ActiveFlag,DOC_Hosp_Dr) VALUES (:oecDr,:activeFlag,:hospDr))	
	.i docID'="" d
	..&sql(UPDATE DHC_EmDocOrderCat SET DOC_Oec_Dr=:oecDr,DOC_ActiveFlag=:activeFlag,DOC_Hosp_Dr=:hospDr WHERE DOC_RowID=:docID)	
	.s saveFlag = SQLCODE
	.
	i saveFlag'=0 tro
	q:saveFlag'=0 saveFlag
	tc
	q saveFlag
}

ClassMethod IsExsit(Data)
{
	
	n (Data)
	s ID=$p(Data,"^",1)
	s OecID=$p(Data,"^",2)
	s HospID=$p(Data,"^",4)
	s IsHasFlag=0
	s DOCRowID=""
	f  s DOCRowID=$o(^DHCEMDOCA(0,"IndexOec",OecID,DOCRowID)) q:DOCRowID=""  d
	.s HasHospID=$p(^DHCEMDOCA(DOCRowID),"^",3)
	.q:HospID'=HasHospID
	.q:(ID'="")&&(ID=DOCRowID)
	.s IsHasFlag=1
	q IsHasFlag
}

Storage Default
{
<Data name="DHCEMDocOrderCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMDocOrderCatD</DataLocation>
<DefaultData>DHCEMDocOrderCatDefaultData</DefaultData>
<IdLocation>^web.DHCEMDocOrderCatD</IdLocation>
<IndexLocation>^web.DHCEMDocOrderCatI</IndexLocation>
<StreamLocation>^web.DHCEMDocOrderCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
