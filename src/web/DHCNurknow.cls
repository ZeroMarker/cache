Class web.DHCNurknow Extends %RegisteredObject
{

//input :科室id

//output:模板关键字|模板名称 （NurEmr.NurEmrSub表）

ClassMethod GetListKn(loc As %String) As %String
{
 //s a=##class(web.DHCNurknow).GetListKn()
   s ret=""
   s rw="" f  s rw=$O(^NurEmr.KnowledgeLocI("Loc"," "_loc,rw)) q:rw=""  d
   .s a=^NurEmr.KnowledgeLocD(rw)
   .s code=$list(a,3)
   .s id=##class(NurEmr.NurEmrSub).getId(code)
   .s b=##class(NurEmr.NurEmrSub).%OpenId(id)
   .q:b=""
   .s desc=b.EmrSubDesc
   .s flag=$listget(a,4)
   .s ret=ret_code_"|"_desc_"|"_flag_"^"
   q ret
}

//获取模板数据xml

//input:模板关键字

//output:流

ClassMethod GetKStream(Code As %String) As %Stream
{
  //##class(web.DHCNurknow).GetKStream
  s code=$ZConvert(Code,"U")
  s id=$O(^NurEmr.NurEmrSubI("EmrCode"," "_code,""))
  if id'=""
  {
  }else{
       s id=$O(^NurEmr.NurEmrSubI("KCode"," "_code,""))
	  }
   if id="" q ""
   s a=##class(NurEmr.NurEmrSub).%OpenId(id)
   q a.EmrSubData
}

//获取知识库模板数据流

//input:知识库id (NurEmr.NurEmrSubItm)

//output:流信息

ClassMethod GetZSKKStream(code As %String) As %Stream
{
  s code=$ZConvert(code,"U")
  s id=$O(^NurEmr.NurEmrSubItmI("EmrCode"," "_code,""))

   if id="" q ""
   s a=##class(NurEmr.NurEmrSubItm).%OpenId(id)
   q a.EmrData
}

}
