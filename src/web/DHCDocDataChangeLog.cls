/// 名称: 医生站码表数据日志管理
Class web.DHCDocDataChangeLog Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// Function：添加码表数据日志
/// Creator:  scl
/// CreatDate:2019-06-14
/// Table：   DHC_DocDataChangeLog
/// Note:	  增加：ChangeValue和NotParse字段，用于记录没有表结构的数据
/// Input：   ChangeValue:改变的数据、NotParse:不用解析数据
/// Other:    d ##class(web.DHCDocDataChangeLog).SaveLog("","","","","","U","")
/// ##class(web.DHCDocDataChangeLog).SaveLog("SS_User","User.SSUser","用户",eobj.SSUSRRowId,eobj.SSUSRName,"U",eobj,bobj)
ClassMethod SaveLog(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "", OperateUser As %String = "", ChangeValue As %String = "", NotParse As %String = "") As %String
{
	new (TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue,OperateUser,ChangeValue,NotParse,%session)
	if (OperateUser="")&&($D(%session)){
		s OperateUser=$Get(%session.Data("LOGON.USERID"))
	}
	s OperateUserName=""
	if OperateUser'=""{
		s OperateUserName=$p($G(^SSU("SSUSR",OperateUser)),"^",2)
	}else{
		s OperateUserName=$Get(%session.Data("LOGON.USERNAME"))	   	
	}
	s result=0
	if (TableName="") {
		s result="表名不能为空!"
	}elseif(ClassName=""){
		s result="类名不能为空!"
	}elseif(ObjectReference="") {
		s result="对象ID不能为空!"
	}elseif(OperateType="") {
		s result="修改类型不能为空!"
	}else {   
		//Ts
		s obj=##class(User.DHCDocDataChangeLog).%New()
		s obj.TableName = TableName
		s obj.ClassName = ClassName
		s obj.ClassNameDesc = ClassNameDesc    //类描述
		s obj.ObjectReference = ObjectReference
		if $l(ObjectDesc)>50 s ObjectDesc=$e(ObjectDesc,1,50)  //对象描述
		s obj.ObjectDesc = ObjectDesc  //对象描述
		s:$d(%session) IPAddress=$p(##class(User.DHCClientLogin).GetInfo(),"^",1) //$Get(%session.Data("REMOTE_ADDR"))
		s:$g(IPAddress)="" IPAddress=##class(DHCDoc.Util.System).GetOutLocalIP()
        s obj.IpAddress = IPAddress		
		d:(OperateUser'="") obj.UpdateUserDRSetObjectId(OperateUser)
		s obj.UpdateUserName = OperateUserName
		s obj.OperateType = OperateType  
		s:NewValue'="" obj.NewValue = NewValue //.JsonS()
		s:OldValue'="" obj.OldValue = OldValue //.JsonS()
      	s:ChangeValue'="" obj.ChangeValue = ChangeValue
      	s obj.NotParse =NotParse
		s sc=obj.%Save()
		s id=obj.%Id()
		d obj.%Close()
		If $$$ISOK(sc) {
			//Tc
		}else {
			//Trollback
			s result="-1"
		} 
	}
	q result
}

/// 在日志主表里插入一条本次更新的内容
/// Creator?      宋春莉
/// CreatDate?    2019-06-14
/// Description:? 取得每个表对应字段当前值的对象
/// Table?        
/// Input?        String
/// Output?       String
/// Return?       
/// Others?
/// w ##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_1_"^"_"User.PAPerson"_$c(2)_1)
/// w ##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_"318||100"_"^"_"User.DHCRBApptSchedule"_$c(2)_"318||100")
ClassMethod GetLogJsonData(UptClassNameStr As %String) As %Library.ListOfObjects
{
	n (UptClassNameStr)
	s ^tempscl("GetLogJsonData")=UptClassNameStr
	s JsonObj=[]
	q:UptClassNameStr="" JsonObj
	s len=$l(UptClassNameStr,"^")
	q:len=0 JsonObj
	s JsonData={}
	f count=1:1:len {
		s UptClassName=$p(UptClassNameStr,"^",count)
		s ClassName=$p(UptClassName,$c(2))
		s ClassRowId=$p(UptClassName,$c(2),2)
		if (ClassName="")||(ClassRowId="") continue
		s ClassObj=$ZOBJCLASSMETHOD(ClassName,"%OpenId",ClassRowId)
		if '$IsObject(ClassObj) continue
		s PropertyIndex=0
		for {
			s PropertyIndex = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex))
			q:(PropertyIndex="")
			s UPLSRowId = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex, ""))
			if UPLSRowId="" continue
			s LogSetObj = ##class(User.DHCDocUpLogSet).%OpenId(UPLSRowId)
			s SingleObj=##class(web.DHCBL.Patient.Log.DHCDocUpDateLogSet).%New()
			if $IsObject(LogSetObj){
				s SingleObj.ClassName = LogSetObj.UPLSClassName
				s SingleObj.ClassProperty = LogSetObj.UPLSClassProperty
				s UPLSClassProperty=$tr(LogSetObj.UPLSClassProperty,"_","")
				if (UPLSClassProperty="ASNoOverbookAllow") s UPLSClassProperty=UPLSClassProperty_"ed"
				set propertyId=LogSetObj.UPLSClassName_"||"_UPLSClassProperty
				set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
				
				if ('$IsObject(propObj)) {
					if (LogSetObj.UPLSClassName="User.DHCDocPilotProject")  {
						set tempLen=$l(UPLSClassProperty)
						set UPLSClassProperty=$e(UPLSClassProperty,3,tempLen)
						set propertyId=LogSetObj.UPLSClassName_"||"_UPLSClassProperty
						set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
					}
				}
				set propertyType=propObj.Type
				i $e(propertyType,1)'="%"{
					s SingleObj.ClassPropertyValue=$ZOBJMETHOD(ClassObj,UPLSClassProperty_"GetObjectId")
				}else{
					s getval=$ZOBJPROPERTY(ClassObj,UPLSClassProperty)
					//考虑list的数据结构做日志
					if (getval["ListOfDT"){
						s countnum=+getval.Count()
						if (countnum>0){
							s getval= getval.GetAt(countnum)
						}elseif (countnum=0){s getval=""}
					}
					s SingleObj.ClassPropertyValue=getval
					//s SingleObj.ClassPropertyValue=$ZOBJPROPERTY(ClassObj,UPLSClassProperty)
				}
				i UPLSClassProperty="PAPMIAllergy" {
					s SingleObj.ClassPropertyValue=$g(^PAPER(ClassRowId,"ALLERGY",1))
				}
				i UPLSClassProperty="PAPERStName" {
					s SingleObj.ClassPropertyValue=$g(^PAPER(ClassRowId,"PER","ADD",1))
				}
				if (UPLSClassProperty="ASClinicGroupDRStr") {
					s ClinicGroupStr=##class(web.DHCApptScheduleNew).GetClinicGroupDrStr(ClassRowId)
					s SingleObj.ClassPropertyValue=$p(ClinicGroupStr,"^",2)
				}
				if (UPLSClassProperty="OEORIBBExtCode") {
					s SingleObj.ClassPropertyValue=$p($g(^PAC("ADMREA",SingleObj.ClassPropertyValue)),"^",2)
				}
				s SingleObj.ClassPropertyIndex= LogSetObj.UPLSClassPropertyIndex		
				s SingleObj.ClassPropertyDescription= LogSetObj.UPLSClassPropertyDescription
				s SingleObj.ClassPropertyRowId=ClassRowId
				do JsonData.%Set(LogSetObj.UPLSClassProperty,SingleObj.ClassPropertyValue)
			}
			d SingleObj.%Close()
			d LogSetObj.%Close()					
		}
	}
	do JsonObj.%Push(JsonData,"")
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	//s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

/// 获取操作日志
/// d ##class(%ResultSet).RunQuery("web.DHCDocDataChangeLog","GetOperateLogList","医嘱套信息", "", "","", "", "", "")
Query GetOperateLogList(ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD As %String) As %Query(ROWSPEC = "id:%String,ClassNameDesc:%String,ObjectReference:%String,ObjectDesc:%String,UpdateUserDR:%String,OperateType:%String,IPAddress:%String,UpdateDate:%String,UpdateTime:%String,ChangeDetail:%String")
{
}

ClassMethod GetOperateLogListExecute(ByRef qHandle As %Binary, ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	s:ClassN'="" ClassN=$$ALPHAUP^SSUTIL4(ClassN)
	s:OBJDESC'="" OBJDESC=$$ALPHAUP^SSUTIL4(OBJDESC) 
	s:dizzyDesc'="" dizzyDesc=$$ALPHAUP^SSUTIL4(dizzyDesc)
	s:UserDR'="" UserDR=$$ALPHAUP^SSUTIL4(UserDR)
	s:datefrom'="" datefrom=..%ZDH(datefrom)
	s:dateto'="" dateto=..%ZDH(dateto)
	if (datefrom'=""){
		s date=datefrom-1
		for {
			s date=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date)) Q:(date="")||((date>dateto)&&(dateto'=""))
			s id=0
			for {
				s id=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date,id)) Q:id=""
				d GetChangeLogData
			}
		}
	}else{
		s id=0
		for {
			s id=$o(^User.DHCDocDataChangeLogD(id)) Q:id=""
			d GetChangeLogData
		}
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow
	set Data=$lb(id,ClassNameDesc,ObjectReference,ObjectDesc,UpdateUser,OperateType,IPAddress,UpdateDate,UpdateTime,ChangeDetail)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	Q
GetChangeLogData
	s data=$g(^User.DHCDocDataChangeLogD(id))
	s ClassNameDesc=$lg(data,11) //功能描述
	s:'$D(^DHCDocLog("ClassNameDesc",ClassNameDesc)) ^DHCDocLog("ClassNameDesc",ClassNameDesc)=""
	s ObjectReferenceID=$lg(data,4) //对象ID
	i ObjectReferenceID["_" s ObjectReference=$p(ObjectReferenceID,"_",2)
	else  s ObjectReference=ObjectReferenceID
	s ObjectDesc=$lg(data,12) //对象描述
	s UpdateUserDR=$lg(data,5)
    i UpdateUserDR'="" s UpdateUser=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1)_"-"_$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2) //操作人
    else  s UpdateUser=""
    s OperateType=$lg(data,9) //操作类型
    s IPAddress=$lg(data,13) //操作人IP
    s ChangeValue=$lg(data,16) //改变值
    s NotParse=$lg(data,17) //解析标识
    Q:'$$CheckSearchPara(ClassNameDesc,ObjectDesc,UpdateUserDR,UpdateUser,OperateTypeD,$lg(data,7),ObjectReferenceID)
    s UpdateDate=..%ZD($lg(data,7)) //操作日期
    s UpdateTime=..%ZT($lg(data,8),1) //操作时间
    s ChangeDetail=..GetChangeDetail(id)
    s:(ChangeValue'="")&&(NotParse="Y") ChangeDetail=ChangeDetail_ChangeValue
    Q:(ChangeDetail="")
    d OutPutRow
    Q
CheckSearchPara(ClassNameDesc,ObjectDesc,UpdateUserDR,UpdateUser,OperateTypeD,update,ObjectReferenceID)
	Q:(dateto'="")&&(update>dateto) 0
	Q:(ClassN'="")&&(ClassNameDesc'[ClassN) 0
	Q:(OBJDESC'="")&&(($$ALPHAUP^SSUTIL4(ObjectDesc))'[OBJDESC)&&(($$ALPHAUP^SSUTIL4(ObjectReferenceID))'[OBJDESC) 0
	Q:(UserDR'="")&&($$ALPHAUP^SSUTIL4(UpdateUserDR)'[UserDR)&&($$ALPHAUP^SSUTIL4(UpdateUser)'[UserDR) 0
	Q:(OperateTypeD'="")&&(OperateType'=OperateTypeD) 0
	Q:(dizzyDesc'="")&&(ClassNameDesc'[dizzyDesc)&&($$ALPHAUP^SSUTIL4(ObjectDesc)'[dizzyDesc)&&($$ALPHAUP^SSUTIL4(UpdateUserDR)'[dizzyDesc)&&($$ALPHAUP^SSUTIL4(UpdateUser)'[dizzyDesc) 0
	Q 1
}

/// w ##class(web.DHCDocDataChangeLog).GetChangeDetail(59674)
ClassMethod GetChangeDetail(id As %String) As %String
{
	n (id)
	s ModifyContent=""
	Q:id="" ModifyContent
	s NewValue=$lg($g(^User.DHCDocDataChangeLogD(id)),10)
	s OldValue=$lg($g(^User.DHCDocDataChangeLogD(id)),14)
	s className=$lg($g(^User.DHCDocDataChangeLogD(id)),3)
	s OperateType=$lg($g(^User.DHCDocDataChangeLogD(id)),9)
	if (OldValue="")&&(className="User.RBApptSchedule#User.DHCRBApptSchedule"){
		s ObjectReference=$lg($g(^User.DHCDocDataChangeLogD(id)),4) //对象ID
		i ObjectReference["_" s ObjectReference=$p(ObjectReference,"_",2)
		Q ..GetScheduleAddInfo(ObjectReference)
	}elseif ((className="User.OEOrdExec")||(className="User.OEOrdItem"))&&(OperateType="U"){
		s ModifyContent="修改内容 "_OldValue_"→"_NewValue
	}else{
		k OldValueCongeriesArr,NewValueCongeriesArr,LoopValueCongeriesArr
		if (OldValue'="") {
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OldValue,.OldValueCongeriesArr)
			m LoopValueCongeriesArr=OldValueCongeriesArr
		}
		if (NewValue'="") {
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(NewValue,.NewValueCongeriesArr)
			m LoopValueCongeriesArr=NewValueCongeriesArr
		}
		//w NewValue,!
		s LoopProperty=""
		for {
			s LoopProperty=$O(LoopValueCongeriesArr(1,LoopProperty))
			q:(LoopProperty="")	
			s OldPropertyValue=..DelSingleQuotation($g(OldValueCongeriesArr(1,LoopProperty)))
			s NewPropertyValue=..DelSingleQuotation($g(NewValueCongeriesArr(1,LoopProperty)))
			if (NewPropertyValue'=OldPropertyValue){
				s OldPropertyInfo=..GetPropDescByCode(className,LoopProperty,OldPropertyValue)
				s OldPropertyValue=$p(OldPropertyInfo,"^",2,$l(OldPropertyInfo,"^"))
				s NewPropertyInfo=..GetPropDescByCode(className,LoopProperty,NewPropertyValue)
				s NewPropertyValue=$p(NewPropertyInfo,"^",2,$l(NewPropertyInfo,"^"))
				s Property=$p(NewPropertyInfo,"^",1)
				if (ModifyContent=""){
					s ModifyContent=Property_": "_OldPropertyValue_"-&gt;"_NewPropertyValue
				}else{
					s ModifyContent=ModifyContent_", "_Property_": "_OldPropertyValue_"-&gt;"_NewPropertyValue
				}
			}
		}
		if (OperateType="A"){
			s ModifyContent="新增数据,"_$replace(ModifyContent,": -&gt;",": ")
		}
	}
	Q ModifyContent
}

/// 根据类名称、字段Code、Value值获取字段描述、值
/// ser.PAPatMas^PAPMI_CardType_DR^证件类型^5^CARDDesc
/// w ##class(web.DHCDocDataChangeLog).GetPropDescByCode("User.DHCDocInstrArcimWard","AddItem_ExcludePrior","2^3^4")
ClassMethod GetPropDescByCode(classname As %String, code As %String, value As %String) As %String
{
	n (classname,code,value)
	s FieldDesc=""
	s code=..DelSingleQuotation($tr(code,"_",""))
	for i=1:1:$l(classname,"#"){
		s onename=$p(classname,"#",i)
		s PropertyIndex=0
		for {
			s PropertyIndex=$o(^User.DHCDOCUPDATELS(0,"Class",onename,PropertyIndex)) Q:PropertyIndex=""
			s UPLSRowId=0
			for {
				s UPLSRowId=$o(^User.DHCDOCUPDATELS(0,"Class",onename,PropertyIndex,UPLSRowId)) Q:UPLSRowId=""
				s propertyName=$p(^User.DHCDOCUPDATELS(UPLSRowId),"^",2)
				if ($tr(propertyName,"_","")=code){
					s FieldDesc=$p(^User.DHCDOCUPDATELS(UPLSRowId),"^",3)
					if (code="ASNoOverbookAllow") s code=code_"ed"
					set propertyId=onename_"||"_code
					set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
					if ('$IsObject(propObj)) {
						if (onename="User.DHCDocPilotProject")  {
							set tempLen=$l(code)
							set code=$e(code,3,tempLen)
							set propertyId=onename_"||"_code
							set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
						}
					}
					set propertyType=propObj.Type
					if propertyType["Date"{
						s value=..%ZD(value)
					}
					if propertyType["Time"{
						s value=..%ZT(value,1)
					}
					if ((propertyType["User."))||($l(propertyType,".")=1)&&($l(propertyType,"%")=1){
						Q:value=""
						if (propertyType'["User.") s UPDClassName="User."_propertyType
						else  s UPDClassName=propertyType
						s ClassObj=$ZOBJCLASSMETHOD(UPDClassName,"%OpenId",value)
						s LinkField=$p(^User.DHCDOCUPDATELS(UPLSRowId),"^",5)
						if $IsObject(ClassObj){
							s value=$ZOBJPROPERTY(ClassObj,LinkField)
						}
					}else{
						;非指针项目或者没有描述字段设定的返回原值
						Q
					}
				}
			}
		}
	}
	Q FieldDesc_"^"_value
}

/// 去掉左单引号和右单引号
ClassMethod DelSingleQuotation(value)
{
	Q:value="" ""
	if $e(value,1)="'" {
		s value=$p(value,"'",2)
	}
	if $e(value,$l(value))="'" {
		s value=$p(value,"'",1)
	}
	Q value
}

ClassMethod GetScheduleAddInfo(RBASRowId As %String) As %String
{
	//新增一条出诊日期为:2019-06-14的风湿免疫科门诊 孔维香,挂号职称为:主治医师
	if ($d(^RBAS(+RBASRowId,$p(RBASRowId,"||",2)))) {
		s ASDate=$p(^RBAS(+RBASRowId,$p(RBASRowId,"||",2)),"^",1)
		s ASDate=..%ZD(ASDate)
		s LocId=$p(^RB("RES",+RBASRowId),"^",1)
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		s DocDescDr=$p(^RB("RES",+RBASRowId),"^",2)
		s DocDesc=$p(^CTPCP(DocDescDr,1),"^",2)
		s ASSessionTypeDR=$p(^RBAS(+RBASRowId,$p(RBASRowId,"||",2),"DHC"),"^",6)
		s SessionType=""
		s:ASSessionTypeDR'="" SessionType=$p($g(^RBC("SESS",ASSessionTypeDR)),"^",2)
		Q "新增一条出诊记录:"_ASDate_" "_LocDesc_" "_SessionType
	}else{
		Q ""
	}
}

ClassMethod GetOperateLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperateLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperateLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperateLogListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
	 	Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// tanjishan
/// 将医嘱模板的原始数据转换成可以进行对比的数据
/// w ##Class(web.DHCDocDataChangeLog).GetDocPreTabs()
ClassMethod GetDocPreTabs(DataJson As %String)
{
	n (DataJson)
	k ValueCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(DataJson,.ValueCongeriesArr)
	s Data=$G(ValueCongeriesArr(1,"Data"))
	q:(Data="") DataJson
	s TabList = $lg(Data,3)
	s TabList=$LISTTOSTRING(TabList,"^")
	s TabList=$replace(TabList,$C(1),"$C(1)")
	s TabList=$replace(TabList,$C(4),"$C(4)")
	s TabList=$replace(TabList,$C(28),"$C(28)")
	s ValueCongeriesArr(1,"Data")=TabList
	
	s DataJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ValueCongeriesArr)
	q DataJson
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocDataChangeLog","GetClassNameList")
Query GetClassNameList() As websys.Query(ROWSPEC = "ClassName:%String,ClassName:%String")
{
}

ClassMethod GetClassNameListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	s ClassName=""
	for {
        s ClassName = $o(^DHCDocLog("ClassNameDesc", ClassName))
        q:(ClassName="")
        d OutputRowUPLSClassList
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUPLSClassList
	set Data=$lb($g(ClassName),$g(ClassName))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

}
