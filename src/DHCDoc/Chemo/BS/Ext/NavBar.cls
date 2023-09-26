/// CTOR: QP
/// DATE: 2020-08-22
/// DESC: 导航条
Class DHCDoc.Chemo.BS.Ext.NavBar Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-22
/// DESC: 生成导航条
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.NavBar).CreateNavBar("401||1","CUR")
ClassMethod CreateNavBar(TSID, InType)
{
	s ^QP("CreateNavBar")=$LB(TSID,InType)
	s mRtn=""
	s code=""
	s PLID=$p(TSID,"||",1)
	s SUB=$p(TSID,"||",2)
	i (InType="CUR")||(InType="HIS") {
		s code=""
		f  s code=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SUB,code)) q:code=""  d
		.s id=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SUB,code,""))
		.q:id=""
		.s descDR=$P(^BS.DOC.Chemo.PlanD(PLID,SUB,id),"^",2)
		.s descCode=##class(DHCDoc.Chemo.COM.Func2).GetChemoDicCode(descDR,1)
		.Q:descCode=""
		.s GROUP(descCode)="TPGDiv-"_code
	
	} else {
		s code=""
		f  s code=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",PLID,SUB,code)) q:code=""  d
		.s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",PLID,SUB,code,""))
		.q:id=""
		.s descDR=$P(^CF.DOC.Chemo.TemplateD(PLID,SUB,id),"^",2)
		.s descCode=##class(DHCDoc.Chemo.COM.Func2).GetChemoDicCode(descDR,1)
		.Q:descCode=""
		.s GROUP(descCode)="TPGDiv-"_code
	}
	
	d ..GetNavBar("CHEMONAVBAR",.VDATA)
	q:($o(VDATA(""),-1)="") mRtn
	s mRtn=			"<li style='height:13px'>"
	s mRtn=mRtn_		"<div class='anchor-circle'></div>"
	s mRtn=mRtn_		"<span class='anchor-txt'></span>"
	s mRtn=mRtn_	"</li>"
	s seqno=""
	f  s seqno=$o(VDATA(seqno)) q:seqno=""  d
	.s desc=$p(VDATA(seqno),",",1)
	.s desc=##class(websys.Translation).Get("chemo.bs.apply.csp",desc)
	.s isChemoGroup=$p(VDATA(seqno),",",2)
	.s domId=$p(VDATA(seqno),",",3)
	.s active=$p(VDATA(seqno),",",4)
	.q:active=0
	.s hasFlag=1
	.i isChemoGroup=1 d
	..i '$d(GROUP(domId)) s hasFlag=0
	..i hasFlag=1 s domId=GROUP(domId)
	.q:hasFlag=0
	.s id="nac-"_domId
	.s mRtn=mRtn_	"<li>"
	.s mRtn=mRtn_		"<div class='circle'></div>"
	.s mRtn=mRtn_		"<a data-taget='"_domId_"' id='"_id_"'>"_desc_"</a>"
	.s mRtn=mRtn_	"</li>"
			
	s mRtn=mRtn_	"<li>"
	s mRtn=mRtn_		"<i class='anchor-circle'></i>"
	s mRtn=mRtn_	"</li>"
		
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-22
/// DESC: 得到导航条
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.NavBar).GetNavBar("CHEMONAVBAR")
ClassMethod GetNavBar(code, ByRef VDATA)
{
	s mRtn=""
	
	Q:(code="") mRtn
	q:'$d(^DHCDocCTi(0,"Define","Code",code)) mRtn
	s par=$o(^DHCDocCTi(0,"Define","Code",code,""))
	q:par="" mRtn
	
	s id="",num=0
	f  s id=$o(^DHCDocCT("DefineData",par,"D",id)) q:id=""  d
	.s seqno=$p(^DHCDocCT("DefineData",par,"D",id),"^",1)
	.s cDesc=$p(^DHCDocCT("DefineData",par,"D",id),"^",2)
	.s StartDate=$p(^DHCDocCT("DefineData",par,"D",id),"^",3)
	.s EndDate=$p(^DHCDocCT("DefineData",par,"D",id),"^",4)
	.q:(StartDate'="")&&(StartDate>+$h)
	.q:(EndDate'="")&&(EndDate<+$h)
	.i seqno="" s seqno=999
	.s num=num+1
	.s VDATA(seqno)=cDesc
	
	Q:num="" mRtn
	
	Q 1
}

}
