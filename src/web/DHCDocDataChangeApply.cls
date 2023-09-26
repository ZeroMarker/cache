/// 名称: 医生站业务数据修改申请
Class web.DHCDocDataChangeApply Extends DHCDoc.Util.RegisteredObject
{

/// Function：添加申请表数据
/// Creator:  宋春莉
/// CreatDate:2021-02-19
/// Table：   DHC_DocDataChangeApply
/// Other:    d ##class(web.DHCDocDataChangeApply).SaveApplyData("","","","","","U","")
/// w ##class(web.DHCDocDataChangeApply).SaveApplyData("User.OEOrdItem","医嘱信息","2996||1","[{""FieldName"":""OEORIDate"",""FieldValue"":""2020-11-18"",""FieldDesc"":""下医嘱日期""},{""FieldName"":""OEORITimeOrd"",""FieldValue"":""15:34:00"",""FieldDesc"":""下医嘱时间""},{""FieldName"":""OEORIItmMastDR"",""FieldValue"":""1||1"",""FieldDesc"":""医嘱项ID""}]",1)
ClassMethod SaveApplyData(ApplyTableName As %String, ApplyTableNameDesc As %String, ApplyObjectReference As %String, ApplyChangeValueJson As %String, ApplyUser As %String = "") As %String
{
	s result=0
	if (ApplyTableName="") {
		s result="表名不能为空!"
	}elseif(ApplyTableNameDesc=""){
		s result="类名不能为空!"
	}elseif(ApplyObjectReference="") {
		s result="对象ID不能为空!"
	}else {   
		s OldValueObj=[]
		k ApplyChangeValueArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyChangeValueJson,.ApplyChangeValueArr)
		for i=1:1:$l(ApplyTableName,"#"){
			s TableName=$p(ApplyTableName,"#",i)
			s ClassObj=$ZOBJCLASSMETHOD(TableName,"%OpenId",ApplyObjectReference)
			if '$IsObject(ClassObj) continue
			s Counter=""
			for {
				s Counter=$O(ApplyChangeValueArr(Counter))
				Q:(Counter="")
				s OldValueData={}
				s FieldName=$g(ApplyChangeValueArr(Counter,"FieldName"))
				d OldValueData.%Set("FieldName",FieldName)
				d OldValueData.%Set("FieldDesc",$g(ApplyChangeValueArr(Counter,"FieldDesc")))
				s propObj=##class(%Dictionary.PropertyDefinition).%OpenId(TableName_"||"_FieldName)
				if ('$IsObject(propObj)) continue
				s propertyType=propObj.Type
				i $e(propertyType,1)'="%"{
					s val=$ZOBJMETHOD(ClassObj,FieldName_"GetObjectId")
				}else{
					s val=$ZOBJPROPERTY(ClassObj,FieldName)
					//考虑list的数据结构
					if (val["ListOfDT"){
						s countnum=+getval.Count()
						if (countnum>0){
							s val= val.GetAt(countnum)
						}elseif (countnum=0){s val=""}
					}
					if (propertyType["%Date")&&(val) s val=..%ZD(val)
					if (propertyType["%Time")&&(val) s val=..%ZT(val,1)
				}
				d OldValueData.%Set("FieldValue",val)
				d OldValueObj.%Push(OldValueData)
			}
		}
		Ts
		s obj=##class(User.DHCDocDataChangeApply).%New()
		s obj.ApplyTableName = ApplyTableName
		s obj.ApplyTableNameDesc = ApplyTableNameDesc
		s obj.ApplyObjectReference = ApplyObjectReference
		d obj.ApplyUserDrSetObjectId(ApplyUser)
		s obj.ApplyOldValue = OldValueObj.%ToJSON()
		s obj.ApplyNewValue = ApplyChangeValueJson
		s obj.ApplyStatus="A"
		s sc=obj.%Save()
		s id=obj.%Id()
		d obj.%Close()
		If $$$ISOK(sc) {
			Tc
			d ##Class(web.DHCDocDataChangeApplyLog).OnTrigger(id,"TAfterIns")
		}else {
			Trollback
			s result="-1"
		} 
	}
	q result
}

/// Function：修改申请表状态
/// Creator:  宋春莉
/// CreatDate:2021-02-19
/// Table：   DHC_DocDataChangeApply
/// Other:    d ##class(web.DHCDocDataChangeApply).ChangeApplyStatus("","","","","","U","")
ClassMethod ChangeApplyStatus(Rowid As %String, NewStatus As %String, UserID As %String, Reason As %String = "")
{
	Q:Rowid="" ""
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	&sql(Update SQLUser.DHC_DocDataChangeApply set ApplyStatus=:NewStatus,UpdateDate=:NowDate,UpdateTime=:NowTime,UpdateUserDr=:UserID,RefuseReason=:Reason where ID=:Rowid)
	Q SQLCODE
}

/// 获取操作日志
/// d ##class(%ResultSet).RunQuery("web.DHCDocDataChangeLog","GetOperateLogList","医嘱套信息", "", "","", "", "", "")
/// Function：取消多条信息申请
/// Creator:  宋春莉
/// CreatDate:2021-02-20
/// Table：   DHC_DocDataChangeApply
ClassMethod CancelApplyMulti(ApplyIds As %String, UserId As %String)
{
	TS
	s rtn=0
	for i=1:1:$l(ApplyIds,"^") {
		s ApplyId=$p(ApplyIds,"^",i)
		s rtn=##class(web.DHCDocDataChangeApply).ChangeApplyStatus(ApplyId,"C", UserId)
		Q:rtn'=0
	}
	if ('rtn) TC
	else  Trollback
	Q rtn
}

/// Function：拒绝多条信息申请
/// Creator:  宋春莉
/// CreatDate:2021-02-20
/// Table：   DHC_DocDataChangeApply
ClassMethod RefuseApplyMulti(ApplyIds As %String, UserId As %String, Reason As %String)
{
	TS
	s rtn=0
	for i=1:1:$l(ApplyIds,"^") {
		s ApplyId=$p(ApplyIds,"^",i)
		s rtn=##class(web.DHCDocDataChangeApply).ChangeApplyStatus(ApplyId,"R", UserId,Reason)
		Q:rtn'=0
	}
	if ('rtn) TC
	else  Trollback
	Q rtn
}

ClassMethod CheckPassApplyMulti(ApplyIds As %String, UserId As %String) [ ProcedureBlock = 0 ]
{
	s OrderItemStr=""
	for i=1:1:$l(ApplyIds,"^") {
		s ApplyId=$p(ApplyIds,"^",i)
		s data=$g(^User.DHCDocDataChangeApplyD(ApplyId))
		s ApplyTableName=$lg(data,2)
		s ApplyObjectReference=$lg(data,4)
		s ApplyNewValue=$lg(data,9)
		k ApplyNewValueArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyNewValue,.ApplyNewValueArr)
		s HaveOEORIBBExtCode=""
		s Counter=""
		for {
			s Counter=$O(ApplyNewValueArr(Counter))
			Q:(Counter="")
			s FieldName=$g(ApplyNewValueArr(Counter,"FieldName"))
			i FieldName="OEORIBBExtCode" s HaveOEORIBBExtCode="Y"
		}
		continue:HaveOEORIBBExtCode=""
		s OrderItemStr=$Case(OrderItemStr,"":ApplyObjectReference,:OrderItemStr_"^"_ApplyObjectReference)
		
	}
	q:OrderItemStr="" ""
	s flag=##class(web.DHCDocOrderMedLeft).CheckBBExtCodeChg(OrderItemStr)
	q flag
}

/// Function：审核多条信息申请
/// Creator:  宋春莉
/// CreatDate:2021-02-20
/// Table：   DHC_DocDataChangeApply
/// w ##class(web.DHCDocDataChangeApply).PassOrdDateChgApply(15,1)
ClassMethod PassApplyMulti(ApplyIds As %String, UserId As %String) [ ProcedureBlock = 0 ]
{
	s falg=..CheckPassApplyMulti(ApplyIds,UserId)
	q:falg'="" falg
	TS
	s rtn=0
	for i=1:1:$l(ApplyIds,"^") {
		s ApplyId=$p(ApplyIds,"^",i)
		s rtn=##class(web.DHCDocDataChangeApply).ChangeApplyStatus(ApplyId,"P", UserId)
		Q:rtn'=0
		s data=$g(^User.DHCDocDataChangeApplyD(ApplyId))
		s ApplyTableName=$lg(data,2)
		s ApplyObjectReference=$lg(data,4)
		s ApplyNewValue=$lg(data,9)
		k ApplyNewValueArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyNewValue,.ApplyNewValueArr)
		s ObjectReferenceIds=ApplyObjectReference
		if (ApplyTableName="User.OEOrdItem") {
			s MainUserAdd=$p($g(^OEORD(+ApplyObjectReference,"I",$p(ApplyObjectReference,"||",2),7)),"^",1) ;下医嘱人
			s LinkSubItmRowIds=""
			s OEORIChildsub=0
			for {
				s OEORIChildsub=$o(^OEORDi(0,"OEORI",+ApplyObjectReference,ApplyObjectReference,OEORIChildsub)) Q:OEORIChildsub=""
				s SubUserAdd=$p($g(^OEORD(+ApplyObjectReference,"I",OEORIChildsub,7)),"^",1) ;下医嘱人
				continue:SubUserAdd'=MainUserAdd
				s SubRowId=+ApplyObjectReference_"||"_OEORIChildsub
				i LinkSubItmRowIds="" s LinkSubItmRowIds=SubRowId
				e  s LinkSubItmRowIds=LinkSubItmRowIds_"^"_SubRowId
			}
			i LinkSubItmRowIds'="" s ObjectReferenceIds=ApplyObjectReference_"^"_LinkSubItmRowIds
		}
		for IdCounter=1:1:$l(ObjectReferenceIds,"^") {
			s ObjectRowId=$p(ObjectReferenceIds,"^",IdCounter)
			s Obj=$ZOBJCLASSMETHOD(ApplyTableName,"%OpenId",ObjectRowId)
			if '$IsObject(Obj) continue
			s Counter=""
			for {
				s Counter=$O(ApplyNewValueArr(Counter))
				Q:(Counter="")
				s FieldName=$g(ApplyNewValueArr(Counter,"FieldName"))
				s FieldValue=$g(ApplyNewValueArr(Counter,"FieldValue"))
				s propObj=##class(%Dictionary.PropertyDefinition).%OpenId(ApplyTableName_"||"_FieldName)
				if ('$IsObject(propObj)) continue
				s propertyType=propObj.Type
				i $e(propertyType,1)'="%"{
					s exeStr="d Obj."_FieldName_"SetObjectId("_FieldValue_")"
					x exeStr
				}else{
					if (propertyType["%Date")&&(FieldValue) s FieldValue=..%ZDH(FieldValue)
					if (propertyType["%Time")&&(FieldValue)&&(FieldValue[":") s FieldValue=..%ZTH(FieldValue)
					s exeStr="Obj."_FieldName_"=FieldValue"
					s @exeStr
				}
			}
			s sc=Obj.%Save()
			d Obj.%Close()
			if '$$$ISOK(sc) {
				s rtn=-1
				Q
			}
			///如果修改医嘱医保标识需要同步修改医嘱执行记录医保标识
			if (FieldName="OEORICoverMainIns"){
				d ##class(web.DHCDocInPatPortalCommon).ChangeOrdCovMainInsuFlag("OE_OrdExec",ObjectRowId,FieldValue)
			}
		}
		Q:rtn'=0
	}
	if ('rtn) TC
	else  Trollback
	Q rtn
}

Query GetApplyInfoList(SearchTableName As %String, StartDate As %String, EndDate As %String, SearchPatNo As %String = "") As websys.Query(ROWSPEC = "ApplyId:%String,ApplyTableName:%String,ORORIRowId:%String,ApplyUser:%String,ApplyDate:%String,ApplyTime:%String,ApplyOldValue:%String,ApplyNewValue:%String,ApplyInfoDetail:%String,PatInfo:%String,ArcimDesc:%String,LimitOldOrdInfo,LimitNewOrdInfo")
{
}

/// Function：获取申请信息列表
/// Creator:  宋春莉
/// CreatDate:2021-02-20
/// d ##class(%ResultSet).RunQuery("web.DHCDocDataChangeApply","GetApplyInfoList","USER.OEORDITEM","")
ClassMethod GetApplyInfoListExecute(ByRef qHandle As %Binary, SearchTableName As %String, StartDate As %String, EndDate As %String, SearchPatNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s SearchTableName=$ZCVT(SearchTableName,"U")
	if (StartDate="") s StartDate=..%SysDate()
	e  s StartDate=..%ZDH(StartDate)
	if (EndDate="") s EndDate=..%SysDate()
	e  s EndDate=..%ZDH(EndDate)
	
	for SearDate=StartDate:1:EndDate {
		s ApplyId=0
		for {
			s ApplyId=$o(^User.DHCDocDataChangeApplyI("ApplyDateTableNameIndex",SearDate," "_SearchTableName,ApplyId)) Q:ApplyId=""
			d GetApplyData
		}
	}
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPutRow
	set Data=$lb(ApplyId,ApplyTableName,ORORIRowId,ApplyUser,ApplyDate,ApplyTime,ApplyOldValue,ApplyNewValue,ApplyInfoDetail,PatInfo,ArcimDesc,LimitOldOrdInfo,LimitNewOrdInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	Q
GetApplyData
	s data=$g(^User.DHCDocDataChangeApplyD(ApplyId))
	s ApplyTableName=$lg(data,2)
	s ApplyObjectReference=$lg(data,4)
	s ApplyUserDr=$lg(data,5)
	s ApplyUser=$p($g(^SSU("SSUSR",ApplyUserDr)),"^",2)
	s ApplyDate=..%ZD($lg(data,6))
	s ApplyTime=..%ZT($lg(data,7),1)
	s ApplyOldValue=$lg(data,8)
	s ApplyNewValue=$lg(data,9)
	s ApplyStatus=$lg(data,10)
	Q:(ApplyStatus'="A")
	s ApplyInfoDetail=..GetApplyInfo(ApplyTableName,ApplyObjectReference,ApplyOldValue,ApplyNewValue)
	s PatInfo=""
	s LimitOldOrdInfo=""
	s LimitNewOrdInfo=""
	if (SearchTableName="USER.OEORDITEM") {
		s EpisodeID=$p(^OEORD(+ApplyObjectReference),"^",1)
		s paperDr=$P(^PAADM(EpisodeID),"^",1)
		s PatNo=$p(^PAPER(paperDr,"PAT",1),"^",2)
		Q:(SearchPatNo'="")&&(SearchPatNo'=PatNo)
		s PatName=$p(^PAPER(paperDr,"ALL"),"^",1)   ;姓名
		s sex=$p(^PAPER(paperDr,"ALL"),"^",7)       ;性别
		i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
		s patNo=$p(^PAPER(paperDr,"PAT",1),"^",1)   ;病人ID
		s PatInfo="姓名："_PatName_"性别："_sex_"患者ID："_patNo
		Set Loc=$P($g(^PAADM(EpisodeID)),"^",4)
		s HospId=""
		If Loc'="" d
		.Set HospId=$P($g(^CTLOC(Loc)),"^",22)
		
		s ArcimId=$p($g(^OEORD(+ApplyObjectReference,"I",$p(ApplyObjectReference,"||",2),1)),"^",2)
		s LimitInfo=..GetApplyLimitDrugInfo(ArcimId,ApplyNewValue,ApplyOldValue,HospId)
		s LimitOldOrdInfo=$P(LimitInfo,"^",1)
		s LimitNewOrdInfo=$P(LimitInfo,"^",2)
		s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
		s OrdPrescNo=$p($g(^OEORD(+ApplyObjectReference,"I",$p(ApplyObjectReference,"||",2),1)),"^",14)
		s ApplyInfoDetail=ArcimDesc_" "_ApplyInfoDetail
		i OrdPrescNo'="" s ApplyInfoDetail=OrdPrescNo_" "_ApplyInfoDetail
	}
	//s ApplyStatus=$case(ApplyStatus,"A":"申请","P":"审核","R":"拒绝","C":"撤销")
    d OutPutRow
    Q
}

ClassMethod GetApplyInfo(ApplyTableName As %String, ApplyObjectReference As %String, ApplyOldValue As %String, ApplyNewValue As %String) As %String
{
	s ApplyInfoDetail=""
	k ApplyOldValueArr,ApplyNewValueArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyOldValue,.ApplyOldValueArr)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyNewValue,.ApplyNewValueArr)
	s Counter=""
	for {
		s Counter=$O(ApplyOldValueArr(Counter))
		Q:(Counter="")
		s FieldName=$g(ApplyOldValueArr(Counter,"FieldName"))
		s FieldDesc=$g(ApplyOldValueArr(Counter,"FieldDesc"))
		s OldFieldValue=$g(ApplyOldValueArr(Counter,"FieldValue"))
		s NewFieldValue=$g(ApplyNewValueArr(Counter,"FieldValue"))
		if (FieldName="OEORIBBExtCode") {
			s OldFieldValue=$p(^PAC("ADMREA",OldFieldValue),"^",2)
			s NewFieldValue=$p(^PAC("ADMREA",NewFieldValue),"^",2)
		}
		i ApplyInfoDetail="" s ApplyInfoDetail=FieldDesc_"："_OldFieldValue_" -> "_NewFieldValue
		else  s ApplyInfoDetail=ApplyInfoDetail_" ; "_FieldDesc_"："_OldFieldValue_" -> "_NewFieldValue
	}
	Q ApplyInfoDetail
}

ClassMethod GetApplyLimitDrugInfo(ArcimId, ApplyNewValue, ApplyOldValue, HospId)
{
	s Ret=""
	k ApplyOldValueArr,ApplyNewValueArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyOldValue,.ApplyOldValueArr)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ApplyNewValue,.ApplyNewValueArr)
	s Counter=""
	for {
		s Counter=$O(ApplyOldValueArr(Counter))
		Q:(Counter="")
		s FieldName=$g(ApplyOldValueArr(Counter,"FieldName"))
		s FieldDesc=$g(ApplyOldValueArr(Counter,"FieldDesc"))
		s OldFieldValue=$g(ApplyOldValueArr(Counter,"FieldValue"))
		s NewFieldValue=$g(ApplyNewValueArr(Counter,"FieldValue"))
		continue:FieldName'="OEORIBBExtCode"
		continue:(OldFieldValue="")&&(NewFieldValue="")
		s LimitOldOrdInfo=""
		s LimitNewOrdInfo=""
		s:ApplyNewValue'="" LimitNewOrdInfo=##class(web.DHCDocInPatPortalCommon).GetInsuLimitInfo(ArcimId,NewFieldValue,HospId)
		s:ApplyOldValue'="" LimitOldOrdInfo=##class(web.DHCDocInPatPortalCommon).GetInsuLimitInfo(ArcimId,OldFieldValue,HospId)
		
		s Ret=LimitOldOrdInfo_"^"_LimitNewOrdInfo
		
	}
	Q Ret
}

}
