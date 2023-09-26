Class User.DHCThreeBlankLabel Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Adm As %String(TRUNCATE = 1);

Property LabelCode As %String(TRUNCATE = 1);

Property LabelDesc As %String(TRUNCATE = 1);

Property LabelDate As %Library.Date(FORMAT = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Index labdate On (Adm, LabelDate, LabelCode);

ClassMethod save(parr) As %String
{
 //s a=##class(User.DHCThreeBlankLabel).save()
  // s parr="337862^Item34^身高^2010-07-20 0:00:00"
   s adm=$P(parr,"^",1)
   s labcode=$P(parr,"^",2)
   s labdesc=$P(parr,"^",3)
   s labdate=$P(parr,"^",4)
   s labdate=$P(labdate," ")
   s labdate=$ZDH(labdate,3)
   s rw=""
   s code=$ZConvert(labcode,"U")
   b
   s rw=$O(^User.DHCThreeBlankLabelI("labdate"," "_adm,labdate," "_code,""))
   b
   if rw="" s a=##class(User.DHCThreeBlankLabel).%New()
   e  s a=##class(User.DHCThreeBlankLabel).%OpenId(rw)
   s a.Adm=adm
   s a.LabelCode=labcode
   s a.LabelDesc=labdesc
   s a.LabelDate=labdate
   d a.%Save()
   q a.%Id()
}

ClassMethod getlabel(adm, code, date) As %String
{
 //s a=##class(User.DHCThreeBlankLabel).getlabel()
 //s adm=337862
  //s code="Item34"
 // s date="2010-11-9"
 i (date["/")&&(+$p(date,"/")>1900) d
 .s yyyy=$p(date,"/")
 .s mm = $p(date,"/",2)
 .s dd = $p(date,"/",3)
 .s date=dd_"/"_mm_"/"_yyyy
  s date=##class(websys.Conversions).DateHtmlToLogical(date) ;$ZDH(date,5)
  s code=$ZConvert(code,"U")
  s stdate=date+1
  s labdesc=""
  f  s stdate=$O(^User.DHCThreeBlankLabelI("labdate"," "_adm,stdate),-1) q:(stdate="")!(labdesc'="")  d
  .s rw=$O(^User.DHCThreeBlankLabelI("labdate"," "_adm,stdate," "_code,""))
  .q:rw=""
  .s labdesc=$listget(^User.DHCThreeBlankLabelD(rw),8)
  q labdesc
}

ClassMethod getBlankItm() As %String
{
  //空白项 ##class(User.DHCThreeBlankLabel).getBlankItm
   //q "Item34|Item21^Item26|Item27"
   q "Item34|Item21|项目1|值1^Item26|Item27|项目2|值2^Item36|Item37|项目3|值3^Item38|Item39|项目4|值4"
}

/// 取得当前日期在体温单预览界面中的首日日期
/// add by linyuxu
/// 2015-06-01
ClassMethod getFirstDateOfThisWeek(Adm, CurDate)
{
	s AdmDate=$p(^PAADM(Adm),"^",6)
	s Pos=(CurDate-AdmDate)#7
	s FirstDateOfThisWeek=CurDate-Pos
	q FirstDateOfThisWeek
}

/// 取得当前页的label
/// 没有时返回空 add by linyuxu 2015-06-01
ClassMethod getCurrLabel(Adm, Code, CurDate)
{
	s Code=$ZCVT(Code,"U")
	i '$ISVALIDNUM(CurDate) d
	.i CurDate["-" s CurDate=$ZDH(CurDate,3)
	.e  i CurDate["/" s CurDate=$ZDH(CurDate,4)
	b 
	s FirstDateOfThisWeek=..getFirstDateOfThisWeek(Adm,CurDate)
	b ;01
	;q:'$d(^User.DHCThreeBlankLabelI("labdate"," "_Adm,FirstDateOfThisWeek," "_Code)) ""
	s RW=$O(^User.DHCThreeBlankLabelI("labdate"," "_Adm,FirstDateOfThisWeek," "_Code,""))
	q:RW="" ""
	s Obj=##class(User.DHCThreeBlankLabel).%OpenId(RW)
	s Label=Obj.LabelDesc
	q Label
}

/// 判断当前Label在本周是否保存过MR_Observations数据，有数据是不允许修改
/// add by linyuxu 2015-06-01
ClassMethod ifThisLabelSaved(Adm, CurDate, Code)
{
	s MRCCode=""
	s HasSaveFlag=0
	s MRADMROWId=$P(^PAADM(Adm),"^",61)
	s BlankItm=..getBlankItm()
	s BlankItmLen=$l(BlankItm,"^")
	f i=1:1:BlankItmLen d
	.s Itm=$p(BlankItm,"^",i)
	.q:Itm=""
	.i $ZConvert($p(Itm,"|",1),"U")=Code s MRCCode=$ZConvert($p(Itm,"|",2),"U")
	i MRCCode'="" d
	.s MRCCodeDR=$O(^MRC("OBITM",0,"Code",MRCCode,""))
	.f Date=CurDate:1:CurDate+6 q:HasSaveFlag'=0  d
	..s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",Date,MRCCodeDR,""))
	..b 
	..i chl'="" s HasSaveFlag=1
	q HasSaveFlag
}

/// 网页保存标题调用方法
/// add by linyuxu 2015-06-04
ClassMethod SaveForWeb(Adm, LabelCode, LabelDesc, CurDate, User)
{
	s LabelCode=$zcvt(LabelCode,"U")
	s CurDate=##class(websys.Conversions).DateHtmlToLogical(CurDate)
	s stdate=CurDate+1
	s labdesc=""
	f  s stdate=$O(^User.DHCThreeBlankLabelI("labdate"," "_Adm,stdate),-1) q:(stdate="")!(labdesc'="")  d
    .s rw=$O(^User.DHCThreeBlankLabelI("labdate"," "_Adm,stdate," "_LabelCode,""))
    .q:rw=""
    .s labdesc=$listget(^User.DHCThreeBlankLabelD(rw),8)
    q:LabelDesc=labdesc -1  //未修改标题,返回
    s FirstDate=..getFirstDateOfThisWeek(Adm,CurDate)
    s isSaved=..ifThisLabelSaved(Adm,FirstDate,LabelCode)
    b ;01
    q:isSaved=1 -2 //本周该标题已保存过数据，不修改标题。
    s RW=$O(^User.DHCThreeBlankLabelI("labdate"," "_Adm,FirstDate," "_LabelCode,""))
    if RW="" s a=##class(User.DHCThreeBlankLabel).%New()
    e  s a=##class(User.DHCThreeBlankLabel).%OpenId(RW)
    s a.Adm=Adm
    s a.LabelCode=LabelCode
    s a.LabelDesc=LabelDesc
    s a.LabelDate=FirstDate
    s a.RecUser=User
    d a.%Save()
    q a.%Id()
}

Storage Default
{
<Data name="DHCThreeBlankLabelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Adm</Value>
</Value>
<Value name="3">
<Value>LabelCode</Value>
</Value>
<Value name="4">
<Value>LabelDate</Value>
</Value>
<Value name="5">
<Value>RecDate</Value>
</Value>
<Value name="6">
<Value>RecTime</Value>
</Value>
<Value name="7">
<Value>RecUser</Value>
</Value>
<Value name="8">
<Value>LabelDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCThreeBlankLabelD</DataLocation>
<DefaultData>DHCThreeBlankLabelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCThreeBlankLabelD</IdLocation>
<IndexLocation>^User.DHCThreeBlankLabelI</IndexLocation>
<StreamLocation>^User.DHCThreeBlankLabelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
