/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗组维护
Class DHCDoc.Chemo.CFG.Group Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 保存化疗组
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Group).Save("903||1")
ClassMethod Save(TSID As %String, mList As %String, importObj As DHCDoc.Chemo.Model.ImportTPL = "")
{
	i importObj="" {
		s id=$p(mList,"^",1)
		s code=$p(mList,"^",2)
		s desc=$p(mList,"^",3)
		s planDate=$p(mList,"^",4)
		s veinFlag=$p(mList,"^",5)
		s note=$p(mList,"^",6)
		s mainDrug=$p(mList,"^",7)
	} else {
		s TPID=$P(TSID,"||",1)
		s Sub=$P(TSID,"||",2)
		s id=$p(mList,"^",1)
		s code=importObj.TGCode
		s desc=importObj.TGDesc
		s planDate=importObj.TGPlanDate
		s veinFlag="N"
		s note=importObj.TGNote
		s mainDrug=importObj.TGMainDrug
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,Sub,code)) {
			s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,Sub,code,""))
			s id=TSID_"||"_id
		}
		s mList=id_"^"_code_"^"_desc_"^"_planDate_"^"_veinFlag_"^"_note_"^"_mainDrug
	}
	s hasFlag=..HasConfig(TSID,mList)
	q:hasFlag'=0 hasFlag
	
	i id="" {
		s a=##class(User.ChemoTemplateGroup).%New(TSID)
		d a.TPGParrefSetObjectId(TSID)
	} else {
		s a=##class(User.ChemoTemplateGroup).%OpenId(id)
	}
	s a.TPGCode=code
	//s a.TPGDesc=desc
	d a.TPGDescSetObjectId(desc)
	s a.TPGPlanDate=planDate
	s a.TPGVeinFlag=veinFlag
	s a.TPGNote=note
	s a.TPGMainDrug=mainDrug
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-103"
	}
	Q a.%Id()
	Q 0
}

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Group).HasConfig("1||2","^2")
ClassMethod HasConfig(TSID As %String, mList As %String)
{
	s mRtn=0
	s TPID=$p(TSID,"||",1)
	s TSID=$p(TSID,"||",2)
	
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s desc=$p(mList,"^",3)
	s planDate=$p(mList,"^",4)
	s veinFlag=$p(mList,"^",5)
	s note=$p(mList,"^",6)
	i id="" {
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,TSID,code)) {
			s mRtn="-104"
		}
	} else {
		s obj=##class(User.ChemoTemplateGroup).%OpenId(id)
		s oldCode=obj.TPGCode
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,TSID,code)) {
			i (oldCode'=code){
				s mRtn="-104"	
			}
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 删除化疗组
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Group).Delete("")
ClassMethod Delete(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_TemplateGroup WHERE TPG_ID=:ID)
	Q:SQLCODE'=0 "-105"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 查询化疗组
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Group","QryGroup","")
Query QryGroup(TSID = "") As %Query(ROWSPEC = "id,code,desc,planDate,note,veinFlag,mainDrug,descDR")
{
}

ClassMethod QryGroupExecute(ByRef qHandle As %Binary, TSID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s sub=0
 	if TSID="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s TPID=$p(TSID,"||",1)
	s SID=$p(TSID,"||",2)
	k PLIST
	f  s sub=$o(^CF.DOC.Chemo.TemplateD(TPID,SID,sub)) q:sub=""  d
	.s code=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",1)
	.s descDR=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",2)
	.s desc=##class(DHCDoc.Chemo.COM.Func2).GetChemoDicDesc(descDR)
	.s planDate=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",3)
	.s note=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",4)
	.s veinFlag=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",5)
	.s mainDrug=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,sub),"^",6)
	.s id=TSID_"||"_sub
	.s Data=$lb(id,code,desc,planDate,note,veinFlag,mainDrug,descDR)
	.s PLIST(code)=Data
 	
 	s code=""
 	f  s code=$o(PLIST(code)) q:code=""  d
 	.s outData=PLIST(code)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	//Set Data=$lb(id,code,desc,planDate,note,veinFlag,mainDrug,descDR)
	Set Data=outData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGroupExecute ]
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
/// DATE: 2020-12-16
/// DESC: 上调/下调
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Delete("")
ClassMethod UpGroup(oldID, oldCode, preID, preCode)
{
	Q:(oldID="")||(oldCode="")||(preID="")||(preCode="") 0
	&SQL(UPDATE SQLUser.Chemo_TemplateGroup SET TPG_Code=:preCode WHERE TPG_ID=:oldID)
	Q:SQLCODE'=0 "-156"
	&SQL(UPDATE SQLUser.Chemo_TemplateGroup SET TPG_Code=:oldCode WHERE TPG_ID=:preID)
	Q:SQLCODE'=0 "-156"
	
	Q 0
}

}
