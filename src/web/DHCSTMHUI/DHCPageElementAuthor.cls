Import sqluser

Class web.DHCSTMHUI.DHCPageElementAuthor Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:记录表单原始数据
/// Creator:	wangjiabin
/// Input:		
/// OutPut:		"":保存成功, 其他:失败信息
/// Return:
/// w ##class(web.DHCSTMHUI.DHCPageElementAuthor).InitSave()
ClassMethod InitSave(MainInfo As %String, PageInfo As %String) As %String
{
	n (MainInfo,PageInfo)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".Initial"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误").Json()
	s SaveFor=PJObj.%Get("SaveFor")
	s CspName=PJObj.%Get("CspName")
	s FormId=PJObj.%Get("FormId")
	
	i (SaveFor="")||(CspName="")||(FormId="") q RtnObj.Err(-1,"",MethodName_"参数错误!").Json()
	
	s Sc=PJObj.%FromJSON(PageInfo)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ElementId=Obj.%Get("ElementId")
		s ElementLabel=Obj.%Get("ElementLabel")
		i ElementId="" d RtnObj.Err(-1,"",MethodName_"参数错误") continue
		s TMPFieldArr(ElementId)=""		;记录临时global
		i RowId="" s RowId=$o(^DHCPEA(0,"CspForm",CspName,FormId,SaveFor,ElementId,0))
		i RowId="" d
		.s AuthorObj=##class(User.DHCPageElementAuthor).%New()
		.s AuthorObj.DHCPEACspName=CspName
		.s AuthorObj.DHCPEAFormID=FormId
		.s AuthorObj.DHCPEASaveFor=SaveFor
		.s AuthorObj.DHCPEAFieldID=ElementId
		e  d
		.s AuthorObj=##class(User.DHCPageElementAuthor).%OpenId(RowId)
		
		s AuthorObj.DHCPEAFieldLabel=ElementLabel
		s Sc=AuthorObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-2,"","保存失败") 
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	;删掉之前的垃圾数据
	s PEAId=0
	s TmpFieldId=""
	f  s TmpFieldId=$o(^DHCPEA(0,"CspForm",CspName,FormId,SaveFor,TmpFieldId)) q:(TmpFieldId="")||(RtnObj.success<0)  d
	.q:$d(TMPFieldArr(TmpFieldId))
	.s PEAId=$o(^DHCPEA(0,"CspForm",CspName,FormId,SaveFor,TmpFieldId,0))
	.q:PEAId=""
	.s TmpObj=##class(User.DHCPageElementAuthor).%OpenId(PEAId)
	.s sc=TmpObj.%DeleteId(PEAId)
	.i $$$ISERR(sc) d RtnObj.Err(-3,"","保存失败") q
	
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Description:获取表单授权数据
/// Creator:	wangjiabin
/// Input:		
/// OutPut:		json
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPageElementAuthor","GetAuthorDetail","{""SaveFor"":""1"",""CspName"":""dhcstmhui.druginfo.csp"",""FormId"":""#InciData""}")
Query GetAuthorDetail(Params As %String) As Query(ROWSPEC = "RowId,ElementId,ElementLabel,AuthorFlag") [ SqlProc ]
{
}

ClassMethod GetAuthorDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s SaveFor=PJObj.%Get("SaveFor")
	s CspName=PJObj.%Get("CspName")
	s FormId=PJObj.%Get("FormId")
	q:(CspName="")||(FormId="")||(SaveFor="") $$$OK
	
	s RowId=""
	f  s RowId=$o(^DHCPEA(0,"CspFormFor",CspName,FormId,SaveFor,RowId)) q:RowId=""  d
	.s ElementId=$p(^DHCPEA(RowId),"^",4)
	.s ElementLabel=$p(^DHCPEA(RowId),"^",5)
	.s AuthorFlag=$p(^DHCPEA(RowId),"^",6)
	.s DataStr=RowId_"^"_ElementId_"^"_ElementLabel_"^"_AuthorFlag
	.d OutPutAuthor
	q $$$OK
OutPutAuthor
	s Data=$lb(RowId,ElementId,ElementLabel,AuthorFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:保存表单授权数据
/// Creator:	wangjiabin
/// Input:		
/// OutPut:		json
ClassMethod SaveAuthorData(MainInfo As %String, DetailParams As %String) As %String
{
	n (MainInfo,DetailParams)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".SaveAuthorData"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()
	
	s SaveFor=PJObj.%Get("SaveFor")
	s CspName=PJObj.%Get("CspName")
	s FormId=PJObj.%Get("FormId")
	
	i (SaveFor="")||(CspName="")||(FormId="") q RtnObj.Err(-1,"",MethodName_"参数错误!").Json()
	
	s Sc=PJObj.%FromJSON(DetailParams)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数错误").Json()
	
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
	
		s ElementId=Obj.%Get("ElementId")
		s ElementLabel=Obj.%Get("ElementLabel")
		s AuthorFlag=Obj.%Get("AuthorFlag")
		
		s PEAId=$o(^DHCPEA(0,"CspForm",CspName,FormId,SaveFor,ElementId,0))
		i PEAId="" d
		.s obj=##class(User.DHCPageElementAuthor).%New()
		.s obj.DHCPEACspName=CspName
		.s obj.DHCPEAFormID=FormId
		.s obj.DHCPEASaveFor=SaveFor
		.s obj.DHCPEAFieldID=ElementId
		e  d
		.s obj=##class(User.DHCPageElementAuthor).%OpenId(PEAId)
		
		s obj.DHCPEAFieldLabel=ElementLabel
		s obj.DHCPEAEnable=AuthorFlag
		s sc=obj.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-2,"",MethodName_":"_ElementLabel_"维护错误!")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:删除表单授权数据
/// Creator:	wangjiabin
/// Input:		
/// OutPut:		json
/// w ##class(web.DHCSTMHUI.DHCPageElementAuthor).DeleteAuthorData(^tmpbin(174))
ClassMethod DeleteAuthorData(MainInfo As %String) As %String
{
	n (MainInfo)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".DeleteAuthorData"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()
	
	s SaveFor=PJObj.%Get("SaveFor")
	s CspName=PJObj.%Get("CspName")
	s FormId=PJObj.%Get("FormId")
	
	i (SaveFor="")||(CspName="")||(FormId="") q RtnObj.Err(-1,"",MethodName_"参数错误!").Json()
	
	&sql(DELETE FROM DHC_PageElementAuthor
		WHERE DHCPEA_CspName=:CspName AND DHCPEA_FormID=:FormId AND DHCPEA_SaveFor=:SaveFor
	)
	i SQLCODE<0 q RtnObj.Err(-1,"","删除失败!").Json()
	q RtnObj.Json()
}

}
