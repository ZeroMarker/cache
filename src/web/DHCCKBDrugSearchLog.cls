Import SQLUser

/// Author:Sunhuiyong
/// Desc:知识浏览器药品查询次数
/// Table：DHC_CKBDrugSearchLog
/// CreatDate:2021-06-16
Class web.DHCCKBDrugSearchLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description:	打开查询药品界面调用记录次数
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-6-16
/// Input:			DicID、"人员ID^科室^医院"
/// return:			0 成功 非0 失败
/// other:			
/// w ##class(web.DHCCKBDrugSearchLog).WriteDrugClick(11,"98^72^2")
ClassMethod WriteDrugClick(DicID, Loginfo) As %String
{
	n (DicID,Loginfo)
	s result=0
	q:(DicID="")||(Loginfo="") "-1"
	s WriteDate=+$h
	s WriteTime=$p($h,",",2)
	s PersonID=$p(Loginfo,"^",1)
	s LocID=$p(Loginfo,"^",2)
	s HospID=$p(Loginfo,"^",3)
	
	s obj=##class(CKB.PDSS.DrugSearchLog).%New()
	d obj.DSLDicIDSetObjectId(DicID)
	s obj.DSLDate=WriteDate
	s obj.DSLTime=WriteTime
	s obj.DSLOperator=PersonID
	s obj.DSLLoc=LocID
	s obj.DSLHospID=HospID
	s sc=obj.%Save()
	d obj.%Close()

	Q result
}

/// Description:	根据查询药品ID获取点击数量
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-6-16
/// Input:			DicID、HospID
/// return:			Count
/// other:			
/// w ##class(web.DHCCKBDrugSearchLog).GetDrugClick(175,2)
ClassMethod GetDrugClick(DicID, HospID) As %String
{
	n (DicID,HospID)
	s Count=0
	q:(DicID="")||(HospID="") "药品信息或医院信息为空！"
	i '$d(	^CKB.PDSS.DrugSearchLogI("IndexHosp",DicID,HospID))  d
	.s Count=0
	e  d
	.s DslID=""
	.f  s DslID=$o(	^CKB.PDSS.DrugSearchLogI("IndexHosp",DicID,HospID,DslID)) q:DslID=""  d
	..s Count=Count+1
	Q Count
}

}
