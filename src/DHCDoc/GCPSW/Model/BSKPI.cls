/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 项目指标模型
Class DHCDoc.GCPSW.Model.BSKPI Extends %RegisteredObject
{

/// 1、==============基本信息====================
/// 性别
Property sex As %String;

/// 年龄
Property age As %String;

/// 身高
Property height As %String;

/// 体重
Property weight As %String;

/// BMI
Property BMI As %String;

/// 2、==============检验======================
/// 入选检验
Property InLis As %String;

/// 排查检验
Property OutLis As %String;

/// 3、==============诊断======================
/// 入选诊断
Property InDiag As %String;

/// 排查诊断
Property OutDiag As %String;

/// 4、==============UI======================
/// 入选诊断Html
Property InDiagHtml As %String;

/// 排除诊断Html
Property OutDiagHtml As %String;

/// 入选检验Html
Property InLisHtml As %String;

/// 排除检验Html
Property OutLisHtml As %String;

/// 5、==============Val======================
/// 入选检验Val
Property InLisVal As %String;

/// 排除检验Val
Property OutLisVal As %String;

/// 入选检验PKID
Property InLisPKID As %String;

/// 排除检验PKID
Property OutLisPKID As %String;

/// w ##class(DHCDoc.GCPSW.Model.BSKPI).GetInfo(32)
ClassMethod GetInfo(PID) As DHCDoc.GCPSW.Model.BSKPI
{
	S ^QP("KK")=PID
	S MObj=##class(DHCDoc.GCPSW.Model.BSKPI).%New()
	Q:PID="" MObj
	s sub=""
	f  s sub=$o(^CF.DOC.GCPSW.PrjD(PID,"K",sub)) q:sub=""  d
	.s kpi=$p(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",1)
	.s section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",2)
	.s val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",3)
	.q:val=""
	.s uom=$p(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",4)
	.s PKID=PID_"||"_sub
	.s KTID=+kpi,CH=$p(kpi,"||",2)
	.s code=$P(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",1)
	.;i code["Lis" s val=..FilterNoAvtive(PID,sub,val)
	.s $ZOBJPROPERTY(MObj, code)=val
	.i code="InDiag" s MObj.InDiagHtml=..GetDiagHtml(PKID,val,code)
	.i code="OutDiag" s MObj.OutDiagHtml=..GetDiagHtml(PKID,val,code)
	.i code="InLis" d
	..s MObj.InLisHtml=..GetLisHtmlNew(PKID,val,code)
	..S MObj.InLisPKID=PKID
	..s InLisVal=##class(DHCDoc.GCPSW.BS.Lis).GetLisValNew(val,PKID)
	..s MObj.InLisVal=InLisVal
	.i code="OutLis" d
	..s MObj.OutLisHtml=..GetLisHtmlNew(PKID,val,code)
	..S MObj.OutLisPKID=PKID
	..s OutLisVal=##class(DHCDoc.GCPSW.BS.Lis).GetLisValNew(val,PKID)
	..s MObj.OutLisVal=OutLisVal
	
	i MObj.InDiagHtml="" s MObj.InDiagHtml=..GetDiagHtml("","","InDiag")
	i MObj.OutDiagHtml="" s MObj.OutDiagHtml=..GetDiagHtml("","","OutDiag")
	i MObj.InLisHtml="" s MObj.InLisHtml=..GetLisHtmlNew("","","InLis")
	i MObj.OutLisHtml="" s MObj.OutLisHtml=..GetLisHtmlNew("","","OutLis")
	
	;b ;001
	Q MObj
}

/// w ##class(DHCDoc.GCPSW.Model.BSKPI).GetDiagHtml("15888,16625,16396,kk,哈哈")
ClassMethod GetDiagHtml(PKID = "", ids = "", code = "") As %String
{
							
	i code="InDiag" s mRtn="<label class='field'>入选诊断</label><br>"
	e  s mRtn="<label class='field'>排除诊断</label><br>"
	i ids="" {
		s mRtn=mRtn_"<label style='padding-left:20px;color:red;'>无</label>"
		Q mRtn
	} 
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		i '$d(^MRC("ID",cid)) {
			s desc=cid
			i code="InDiag" s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked value='"_desc_"' ><span class='c-span3'>"_desc_"</span>"
			e  s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked disabled value='"_desc_"' ><span class='c-span3'>"_desc_"</span>"
			
			//i code="InDiag" s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked label='"_desc_"' value='"_desc_"' >"
			//e  s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked disabled label='"_desc_"' value='"_desc_"' >"
			//i i#2=0 s html=html_"<br>"
			s mRtn=mRtn_html
		} else {
			s desc=$p(^MRC("ID",cid),"^",2)
			i code="InDiag" s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked value='"_cid_"' ><span class='c-span3'>"_desc_"</span>"
			e  s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked disabled value='"_cid_"' ><span class='c-span3'>"_desc_"</span>"
			
			//i code="InDiag" s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked label='"_desc_"' value='"_cid_"' >"
			//e  s html="<input class='hisui-checkbox c-checkbox' type='checkbox' checked disabled label='"_desc_"' value='"_cid_"' >"
			//i i#2=0 s html=html_"<br>"
			s mRtn=mRtn_html
		}
	}
	
	Q mRtn
}

/// w ##class(DHCDoc.GCPSW.Model.BSKPI).GetDiagHtml("15888,16625,16396,kk,哈哈")
ClassMethod GetLisHtml(PKID = "", ids = "", code = "") As %String
{
	i code="InLis" s mRtn="<label class='field'>入选项目</label><br>"
	e  s mRtn="<label class='field'>排除项目</label><br>"
	i ids="" {
		s mRtn=mRtn_"<label style='padding-left:20px;color:red;'>无</label>"
		Q mRtn
	} 
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		s KTID=+cid
		s SUB=$P(cid,"||",2)
		s Liscode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB),"^",1)
		s desc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB),"^",2)
		i code="InLis" {
			s idCheck="InLisChk-"_Liscode
			s idLabel="InLis-"_Liscode
			s html="<input id='"_idCheck_"' class='hisui-checkbox c-checkbox2' checked type='checkbox' value='"_cid_"'>"
			s html=html_"<label code='InLis' id='"_idLabel_"' PKID='"_PKID_"' value='"_cid_"' class='c-link'>"_desc_"</label>"
			s mRtn=mRtn_html
		} else {
			s idCheck="OutLisChk-"_Liscode
			s idLabel="OutLis-"_Liscode
			s html="<input id='"_idCheck_"' class='hisui-checkbox c-checkbox2' checked disabled type='checkbox' value='"_cid_"'>"
			s html=html_"<label code='OutLis' id='"_idLabel_"' PKID='"_PKID_"' value='"_cid_"' class='c-link'>"_desc_"</label>"
			s mRtn=mRtn_html
		}
	}
	
	Q mRtn
}

/// w ##class(DHCDoc.GCPSW.Model.BSKPI).GetLisHtmlNew("2||4","3||1,3||2","InLis")
ClassMethod GetLisHtmlNew(PKID = "", ids = "", code = "") As %String
{
	i code="InLis" s mRtn="<label class='field'>入选项目</label><br>"
	e  s mRtn="<label class='field'>排除项目</label><br>"
	i ids="" {
		s mRtn=mRtn_"<label style='padding-left:20px;color:red;'>无</label>"
		Q mRtn
	} 
	s PID=+PKID
	s KID=$P(PKID,"||",2)
	s Active=0
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		s KTID=+cid
		s CH=$P(cid,"||",2)
		s Liscode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",CH),"^",1)
		s desc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",CH),"^",2)
		continue:'$d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,cid))
		s SUB=$O(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,cid,""))
		continue:SUB=""
		;指标值
		s val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",3)
		s section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",2)
		i section'=1 s section=0
		s stdVal=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",5)
		s rule=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",10)
		s Active=1
		i code="InLis" {
			s sid="InLisS-"_Liscode
			s eid="InLisE-"_Liscode
			s bid="InLis-"_Liscode
			s html="<div>"
			s html=html_"<label class='field'>"_desc_"</label>"
			i section=1 {
				s html=html_"<input id='"_sid_"' class='textbox fill' type='text'  style='width:30px;' value='"_$p(val,",",1)_"'>"
				s html=html_"<span class='c-span2'>~</span>"
		       	s html=html_"<input id='"_eid_"' class='textbox fill' type='text'  style='width:30px;' value='"_$p(val,",",2)_"'>" 					
			} else {
				s html=html_"<input id='"_bid_"' class='textbox fill' type='text'  style='width:30px;' value='"_val_"'>"
			}
			s html=html_"</div>"
			s mRtn=mRtn_html
		} else {
			s sid="OutLisS-"_Liscode
			s eid="OutLisE-"_Liscode
			s bid="OutLis-"_Liscode
			s html="<div>"
			s html=html_"<label class='field'>"_desc_"</label>"
			i section=1 {
				s html=html_"<input id='"_sid_"' class='textbox fill' disabled='disabled' type='text'  style='width:30px;' value='"_$p(val,",",1)_"'>"
				s html=html_"<span class='c-span2'>~</span>"
		       	s html=html_"<input id='"_eid_"' class='textbox fill' disabled='disabled'  type='text'  style='width:30px;' value='"_$p(val,",",2)_"'>" 					
			} else {
				s html=html_"<input id='"_bid_"' class='textbox fill' disabled='disabled'  type='text'  style='width:30px;' value='"_val_"'>"
			}
			s html=html_"</div>"
			s mRtn=mRtn_html
		}
	}
	
	i Active=0 {
		s mRtn=mRtn_"<label style='padding-left:20px;color:red;'>无</label>"
	} 
	
	Q mRtn
}

/// w ##class(DHCDoc.GCPSW.Model.BSKPI).FilterNoAvtive(2,4,"3||1,3||2")
ClassMethod FilterNoAvtive(PID, KID, ids) As %String
{
	b ;001
	s mRtn=""
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		s KTID=+cid
		s CH=$P(cid,"||",2)
		continue:'$d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,cid))
		s SUB=$O(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,cid,""))
		continue:SUB=""
		i mRtn="" s mRtn=cid
		e  s mRtn=mRtn_","_cid
	}
	Q mRtn
}

}
