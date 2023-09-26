/// creat by zhouli
/// 体检细项选择项模板维护
Class web.DHCPE.TemplateSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//将保存在^DHCPEDataEx显示在Table中

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	//m ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate","52||2||1")=^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate","52||3||1")
	s rowid=$p(InString,"^",2)
    s num=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",rowid,""),-1)     //取最后一个num值（即最大值）
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	s num=num+1                                                                  //将当前记录保存到num+1     
	s ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",rowid,num)=$p(InString,"^",1)
   q
}

ClassMethod GetInfoExecute(ByRef qHandle As %Binary, TextValID) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s TextValID=%request.Get("TextValID")
 	i TextValID="" 
 	{
	 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	}                       //从组件传进来的参数
    s num=0
    f  s num=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID,num))  q:num=""  d 
    .s TValue=$g(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID,num))
    .d SearchOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchOut      
	set Data=$lb(num,TValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				
 	Set Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query GetInfo(TextValID) As %Query(ROWSPEC = "TRowid:%String,TValue:%String")
{
}

ClassMethod GetInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

 s ID=$p(InString,"^",1)
 s Num=$p(InString,"^",2)
 k ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ID,Num)
 q 0
}

ClassMethod SaveTemplate(OEOrdItemID, TemplateInfo)
{
	s ARCIM=$p($g(^OEORD(+OEOrdItemID,"I",$p(OEOrdItemID,"||",2),1)),"^",2)
	s ODDR=$o(^DHCPEODR(0,"ARCIM",ARCIM,0))
	s ODSRowId=""
	i ODDR'="" d
	.Set ODDR=$p(^DHCPEODR(ODDR),"^",2)
	.Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",0))
	.i ODSSub'="" d
	..Set ODSRowId=ODDR_"||"_ODSSub
	.e  d
	..s InString=ODDR_"^"_"^"_"^"_"模板维护标准"
	..s ret=##class(web.DHCPE.ODStandard).Save("","", InString)
	..i ret=0 d
	...Set ODSSub=$o(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2),"ODS",0))
	...s ODSRowId=ODDR_"||"_ODSSub
	q:ODSRowId="" "没有对应的细项选择"
	i ODSRowId'="" d
	.s InString=TemplateInfo_"^"_ODSRowId
	.d ##class(web.DHCPE.TemplateSet).Save("","",InString)
	q 0
}

ClassMethod DeleteTemplate(TemplateID)
{
	//ODSID,TemplateSub
	q:TemplateID="" ""
	s ODSID=$P(TemplateID,"^",1)
	s TemplateSub=$P(TemplateID,"^",2)
	k ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID,TemplateSub)
	q ""
}

ClassMethod OutDeleteButton(ButtonID)
{
	w "<input type='button' id='"_ButtonID_"' name='"_ButtonID_"' value='删除' onclick='BDeleteTemplate();'>"
	Quit $$$OK
}

}
