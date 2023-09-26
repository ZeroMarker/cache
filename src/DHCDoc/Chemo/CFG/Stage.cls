/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 周期维护
Class DHCDoc.Chemo.CFG.Stage Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 保存周期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Save("903||1")
ClassMethod Save(TPID As %String, mList As %String, importObj As DHCDoc.Chemo.Model.ImportTPL = "")
{
	i importObj="" {
		s id=$p(mList,"^",1)
		s stage=$p(mList,"^",2)
		s desc=$p(mList,"^",3)
		s startDate=$p(mList,"^",4)
		s endDate=$p(mList,"^",5)
		s nextNum=$p(mList,"^",6)
		s chemoDate=$p(mList,"^",7)
	} else {
		s id=""
		s stage=importObj.TSCode
		s desc=importObj.TSDesc
		s startDate=importObj.TSStartDate
		s endDate=importObj.TSEndDate
		s nextNum=importObj.TSNextNum
		s chemoDate=importObj.TSChemoDate
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage)) {
			s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage,""))
			s id=TPID_"||"_id
		}
		s mList=id_"^"_stage_"^"_desc_"^"_startDate_"^"_endDate
	}
	s hasFlag=..HasConfig(TPID,mList)
	q:hasFlag'=0 hasFlag
	
	i id="" {
		s a=##class(User.ChemoTemplateStage).%New(TPID)
		d a.TSParRefSetObjectId(TPID)
	} else {
		s a=##class(User.ChemoTemplateStage).%OpenId(id)
	}
	s a.TSStage=stage
	s a.TSDesc=desc
	s a.TSStartDate=startDate
	s a.TSEndDate=endDate
	s a.TSNextNum=nextNum
	s a.TSChemoDate=chemoDate
	s sc=a.%Save()
	If $$$ISERR(sc) {
		d $system.OBJ.DisplayError(sc) 
		Quit "-120"
	}
	Q a.%Id()
	Q 0
}

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).HasConfig()
ClassMethod HasConfig(TPID As %String, mList As %String)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s stage=$p(mList,"^",2)
	s desc=$p(mList,"^",3)
	s startDate=$p(mList,"^",4)
	s endDate=$p(mList,"^",5)
	
	i id="" {
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage)) {
			s mRtn="-121"
		}
	} else {
		s obj=##class(User.ChemoTemplateStage).%OpenId(id)
		s oldStage=obj.TSStage
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage)) {
			i (oldStage'=stage){
				s mRtn="-121"	
			}
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 删除周期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Delete("")
ClassMethod Delete(TSID As %String)
{
	Q:TSID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_TemplateStage WHERE TS_ID=:TSID)
	Q:SQLCODE'=0 "-122"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 查询周期
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Stage","QryStage","")
Query QryStage(TPID = "") As %Query(ROWSPEC = "id,stage,desc,startDate,endDate,nextNum,chemoDate")
{
}

ClassMethod QryStageExecute(ByRef qHandle As %Binary, TPID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s sub=0
 	if TPID="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k PLIST
	f  s sub=$o(^CF.DOC.Chemo.TemplateD(TPID,sub)) q:sub=""  d
	.s stage=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",1)
	.s desc=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",2)
	.s startDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",3)
	.s endDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",4)
	.s nextNum=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",5)
	.s chemoDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",6)
	.s id=TPID_"||"_sub
	.s Data=$lb(id,stage,desc,startDate,endDate,nextNum,chemoDate)
	.s PLIST(stage)=Data

	s stage=""
	f  s stage=$o(PLIST(stage)) q:stage=""  d
	.s outData=PLIST(stage)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=outData	//$lb(id,stage,desc,startDate,endDate,nextNum,chemoDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryStageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-12-15
/// DESC: 上调/下调
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Delete("")
ClassMethod UpStage(oldID, oldStage, preID, preStage)
{
	Q:(oldID="")||(oldStage="")||(preID="")||(preStage="") 0
	&SQL(UPDATE SQLUser.Chemo_TemplateStage SET TS_Stage=:preStage WHERE TS_ID=:oldID)
	Q:SQLCODE'=0 "-155"
	&SQL(UPDATE SQLUser.Chemo_TemplateStage SET TS_Stage=:oldStage WHERE TS_ID=:preID)
	Q:SQLCODE'=0 "-155"
	
	Q 0
}

}
