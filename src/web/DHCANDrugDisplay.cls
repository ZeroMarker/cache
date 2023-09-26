Class web.DHCANDrugDisplay Extends %RegisteredObject
{

/// ParaStr="para_^_para_^_para"
ClassMethod InsertDrugDisplay(ParaStr As %String, Setting As %String, opaId As %String = "") As %String
{
	q:ParaStr="" "-1"

	f i=1:1:$l(ParaStr,"^") d
	.s Para=$p(ParaStr,"^",i)
	.q:Para=""
	.s retStr=##class(web.DHCANDrugDisplay).InsertSingleDrugDisplay(Para,Setting,opaId)
	q 0
}

/// Para="code_$c(3)_desc_$c(3)_opaId_$c(3)_UseFlag_$c(3)_Defult_$c(3)_DoseQty_$c(3)
///      _DoseUom_$c(3)_Speed_$c(3)_SpeedUom_$c(3)_Instructor_$c(3)_Density_$c(3)
///      _AdminSite_$c(3)_DrugReason_$c(3)_DisplayType"
/// Para="code_$c(3)_desc_$c(3)_DoseQty_$c(3)
///      _DoseUom_$c(3)_Speed_$c(3)_SpeedUom_$c(3)_Instructor_$c(3)_Density_$c(3)
///      _AdminSite_$c(3)_DrugReason
ClassMethod InsertSingleDrugDisplay(Para As %String, Setting As %String, opaId As %String = "") As %String
{
	;s Para="ANAnaesthetic"_$c(3)_"麻醉药"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"Y"_$c(3)_"N"_$c(3)
	q:Para="" "-1^Para"
	s RowId=""
	s DisplayType="S",Defult="Y"
	s Category=$P(Setting,"^",1)
	s SubCategory=$P(Setting,"^",2)
	s Drug=$P(Setting,"^",3)
	s General=$P(Setting,"^",4)
	s Personal=$P(Setting,"^",5)
	s UseFlag=$P(Setting,"^",6)
	
	i Category="Y" s DisplayType="C"
	i SubCategory="Y" s DisplayType="S"
	i Drug="Y" s DisplayType="D"
	i General="Y" s opaId="",Defult="Y"
	i Personal="Y" s Defult="N"
	
	s code=$p(Para,$c(3),1)
	q:code="" "-2^code is null"
	s desc=$p(Para,$c(3),2)
	s DoseQty=$p(Para,$c(3),3)
	s DoseUom=$p(Para,$c(3),4)
	s Speed=$p(Para,$c(3),5)
	s SpeedUom=$p(Para,$c(3),6)
	s Instructor=$p(Para,$c(3),7)
	s Density=$p(Para,$c(3),8)
	s AdminSite=$p(Para,$c(3),9)
	s DrugReason=$p(Para,$c(3),10)
	s DrugDesc=$p(Para,$c(3),11)
	
	s RowId=$o(^DHCANDrugDisplay(0,"Code",code,""))

	i RowId'="" s obj=##class(User.DHCANDrugDisplay).%OpenId(RowId)
	e  s obj=##class(User.DHCANDrugDisplay).%New()
	s obj.ANDGCode=code
	s obj.ANDGDesc=desc
	s obj.ANDGOPADr=##Class(User.DHCANOPArrange).%OpenId(opaId)
	s obj.ANDGUseFlag=UseFlag
	s obj.ANDGDefult=Defult
	s obj.ANDGDoseQty=DoseQty
	s obj.ANDGDoseUom=DoseUom
	s obj.ANDGSpeed=Speed
	s obj.ANDGSpeedUom=SpeedUom
	s obj.ANDGInstructor=Instructor
	s obj.ANDGDensity=Density
	s obj.ANDGAdminSite=AdminSite
	s obj.ANDGDrugReason=DrugReason
	s obj.ANDGDisplayType=DisplayType
	s obj.ANDGDrugDesc=DrugDesc
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()
	
	s result=##class(web.DHCANDrugDisplay).ChangeUseFlag(DisplayType)
	
	q RowId
}

//w ##class(web.DHCANDrugDisplay).FindAllDrugSetting()

ClassMethod FindAllDrugSetting() As %String
{
	s seqNo=1
	s RowId=0 f  s RowId=$o(^DHCANDrugDisplay(RowId)) q:RowId=""  d
	.q:$d(^DHCANDrugDisplay(RowId))<1
	.s useFlag=$li(^DHCANDrugDisplay(RowId),4)
	.s default=$li(^DHCANDrugDisplay(RowId),5)
	.s displayType=$li(^DHCANDrugDisplay(RowId),14)
	.;q:useFlag'="Y"
	.i displayType="C" s seqNo=3  //大类(优先级)
	.e  i displayType="S" s seqNo=2  //子类
	.e  i displayType="D" s seqNo=1  //药品
	.s ^temp("DrugSetting",$j,seqNo,RowId)=$g(^DHCANDrugDisplay(RowId))
	
	s count=0,retStr=""
	s no="" f  s no=$o(^temp("DrugSetting",$j,no)) q:no=""  d
	.;s count=count+1
	.;q:count>1
	.s dr="" f  s dr=$o(^temp("DrugSetting",$j,no,dr)) q:dr=""  d
	..s code=$li(^DHCANDrugDisplay(dr),1)
	..s desc=$li(^DHCANDrugDisplay(dr),2)
	..s opaId=$li(^DHCANDrugDisplay(dr),3)
	..s useFlag=$li(^DHCANDrugDisplay(dr),4)
	..s doseQty=$li(^DHCANDrugDisplay(dr),6)
	..s doseUom=$li(^DHCANDrugDisplay(dr),7)
	..s speed=$li(^DHCANDrugDisplay(dr),8)
	..s speedUom=$li(^DHCANDrugDisplay(dr),9)
	..s instructor=$li(^DHCANDrugDisplay(dr),10)
	..s density=$li(^DHCANDrugDisplay(dr),11)
	..s adminsite=$li(^DHCANDrugDisplay(dr),12)
	..s drugReason=$li(^DHCANDrugDisplay(dr),13)
	..s drugDesc=$li(^DHCANDrugDisplay(dr),15)
	..i retStr="" s retStr=code_$c(3)_desc_$c(3)_opaId_$c(3)_useFlag_$c(3)_doseQty_$c(3)_doseUom_$c(3)_speed_$c(3)_speedUom_$c(3)_instructor_$c(3)_density_$c(3)_adminsite_$c(3)_drugReason_$c(3)_drugDesc
	..e  s retStr=retStr_"^"_code_$c(3)_desc_$c(3)_opaId_$c(3)_useFlag_$c(3)_doseQty_$c(3)_doseUom_$c(3)_speed_$c(3)_speedUom_$c(3)_instructor_$c(3)_density_$c(3)_adminsite_$c(3)_drugReason_$c(3)_drugDesc
	k ^temp("DrugSetting",$j)
	q retStr
}

//w ##class(web.DHCANDrugDisplay).ChangeUseFlag("S")

ClassMethod ChangeUseFlag(DisplayType As %String) As %String
{
	s RowId=0 f  s RowId=$o(^DHCANDrugDisplay(RowId)) q:RowId=""  d
	.q:$d(^DHCANDrugDisplay(RowId))<1
	.s useFlag=$li(^DHCANDrugDisplay(RowId),4)
	.s opaId=$li(^DHCANDrugDisplay(RowId),3)
	.q:opaId'=""
	.q:useFlag'="Y"
	.s type=$li(^DHCANDrugDisplay(RowId),14)
	.i (DisplayType'=type) d
	..s obj=##class(User.DHCANDrugDisplay).%OpenId(RowId)
	..s obj.ANDGUseFlag="N"
	..s saveStatus=obj.%Save()
	..q:(+saveStatus=0)
	..d obj.%Close()
	q 0
}

}
