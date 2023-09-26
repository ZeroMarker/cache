Import sqluser

/// Creat  zzp 2015-03-16  
Class web.PMP.Common Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creat  zzp
/// date:2015-03-16
/// description: 获取产品组数据
/// input:  type()
/// output: String "RowId^Description"
/// others:
ClassMethod SelectProduct(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("SelectProduct")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^PMPDictionary("FLAG","Product",id)) q:id=""  d
 .s desc=$p($G(^PMPDictionary(id)),"^",2)
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .q:desc=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc
 .q:(InPut'="")&(namedesc'[InPut)
 .s i=i+1
 .s tmp=id_"^"_desc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-21
/// description: 获取添加开发数据类型数据
/// input:  type()
/// output: String "RowId^Description"
/// others:
ClassMethod AddDevDetail(InPut As %Text)
{
 s i=0 
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^PMPDictionary("FLAG","AddDevDetail",id)) q:id=""  d
 .s desc=$p($g(^PMPDictionary(id)),"^",2)
 .q:desc=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc
 .q:(InPut'="")&(namedesc'[InPut)
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s i=i+1
 .s tmp=id_"^"_desc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-17
/// description: 新增开发数据
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).DevInsert("刘艳^18232112322^liuyan@dhcc.com.cn^区域综合卫生服务门户^2324456787897978789898898798988^2015-03-03^19:09:00^2015-03-26^18:09:00^工作要求")
ClassMethod DevInsert(InPut As %Text)
{
	;s ^CacheTemp("DevInsert")=InPut
	;DevNamec+"^"+DevTelc+"^"+DevEmailc+"^"+DevProductc+"^"+DevBusinessReasonc+"^"+DevInDatec+"^"+DevInTimec+"^"+DevOutDatec+"^"+DevOutTimec+"^"+DevDLBY1;
	s ret=-1
	q:InPut="" ret
	q:$l(InPut,"^")'=10 ret
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s DevName=$p(InPut,"^",1)
	s DevTel=$p(InPut,"^",2)
	s DevEmail=$p(InPut,"^",3)
	s DevProducti=$p(InPut,"^",4)
	s DevBusinessReason=$p(InPut,"^",5)
	s DevInDate=$p(InPut,"^",6)
	s DevInTime=$p(InPut,"^",7)
	s DevOutDate1=$p(InPut,"^",8)
	s DevOutTime1=$p(InPut,"^",9)
	s DevProduct=$o(^PMPDictionary("flagdesc","Product",DevProducti,""))
	s DevInDate=$zdh(DevInDate,3)
	s DevInTime=$zth(DevInTime)
	s DevDLBY1=$p(InPut,"^",10)
	i (DevOutDate1'="")&(DevOutDate1'="undefined") s DevOutDate=$zdh(DevOutDate1,3)
	i (DevOutTime1'="")&(DevOutTime1'="undefined") s DevOutTime=$zth(DevOutTime1)
	i DevDLBY1'="" s DevDLBY1id=$o(^PMPDictionary("flagdesc","AddDevDetail",DevDLBY1,""))
	q:$g(DevProduct)="" ret
	s object=##class(User.PMPDevelop).%New()
	s object.DLName=DevName
	s object.DLTel=DevTel
	s object.DLEmail=DevEmail
	s object1=##Class(User.PMPDictionary3).%OpenId(DevProduct)
	s object.DLProductDR=object1
	s object.DLInDate=DevInDate
	s object.DLInTime=DevInTime
	i $g(DevOutDate)'="" s object.DLOutDate=$g(DevOutDate)
	i $G(DevOutTime)'="" s object.DLOutTime=$g(DevOutTime)
	s object.DLBusinessReason=DevBusinessReason
	s object.DLRecordDate=Date
	s object.DLRecordTime=Time
	s object.DLUser=userId
	s object.DLStatus="Y"
	s object.DLNameSimplicty=##Class(web.DHCINSUPort).GetCNCODE(DevName,4,"")
	i DevDLBY1id'=""  d
	.s object6=##Class(User.PMPDictionary3).%OpenId(DevDLBY1id)
	.s object.DLBY1=object6
	s sc=object.%Save()
	S Rowid=$o(^PMPDevelop("InDate",DevInDate,""),-1)
	i sc="1" s ret=0
	i sc'="1" s ret="-1"
	i sc="1"  d
	
	.b ;2
	.;s object3=##Class(User.PMPDevelopImprovement).%New(Rowid)
	.;b ;3
	.;s object=##Class(User.PMPDevelopImprovement).%Open(
	.;s object5=##Class(User.PMPDevelop).%OpenId(Rowid)
	.;s object3.PMPDevelopImprovementParRef=object5
	.;s object3.DLDIDate=Date
	.;s object3.DLDITime=Time
	.;s object3.DLDIStatus="Y"
	.;s object3.DLDIMenu=DevBusinessReason
	.;s object4=##Class(User.SSUser).%OpenId(userId)
	.;s object3.DLDIUser=object4
	.;s object3.DLDIType="Y"
	.;s sd=object3.%Save()
	.&sql(insert INTO sqluser.PMP_DevelopImprovement (PMP_DevelopImprovement_ParRef,DLDI_Type,DLDI_User,DLDI_Status,DLDI_Date,DLDI_Time,DLDI_Menu) values (:Rowid,:DevDLBY1id,:userId,"Y",:Date,:Time,:DevBusinessReason))
	.i SQLCODE'="0" s ret=SQLCODE
	q ret
}

/// Creat  zzp
/// date:2015-03-18
/// description: 获取开发信息
/// input:  type()
/// output: String "Rowid"^"DevName"^"DevStatus"^"DevAppraisal"^"DevTel"^"DevEmail"^"DevProduct"^"DevInDate"^"DevInTime"^"DevOutDate"^"DevOutTime"^"DevBusine"
/// others: w ##Class(web.PMP.Common).DevDetailStore("")
ClassMethod DevDetailStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("DevDetailStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s Dname="",Tel="",Email="",Product="",OutDate=""
 s resultString = ""
 i InPut'="" d
 .s Name=$p(InPut,"^",1)
 .i Name'="请输入姓名" s Dname=Name
 .i $g(Dname)'="" s Dname=$$ALPHAUP^SSUTIL4(Dname)
 .s Tel=$p(InPut,"^",2)
 .s Email=$p(InPut,"^",3)
 .s Product=$p(InPut,"^",4)
 .s InDate=$p(InPut,"^",5)
 .s InTime=$p(InPut,"^",6)
 .i ((InTime="请选择时间")||(InTime="undefined")) s InTime=""
 .s OutDate=$p(InPut,"^",7)
 .i ((OutDate="请选择日期")||(OutDate="undefined")) s OutDate=""
 .s OutTime=$p(InPut,"^",8)
 .i ((OutTime="请选择时间")||(OutTime="undefined")) s OutTime=""
 s id=0 f  s id=$o(^PMPDevelop(id)) q:id=""  d
 .s (Rowid,DevName,DevStatus,DevAppraisal,DevTel,DevEmail,DevProduct,DevInDate,DevInTime,DevOutDate,DevOutTime,DevBusine)=""
 
 .s DevName=$p($g(^PMPDevelop(id)),"^",6)
 .q:$g(DevName)=""
 .S TYPE=$p(^PMPDevelop(id),"^",15)
 .Q:TYPE'="Y"
 .s DevName1=##Class(web.DHCINSUPort).GetCNCODE(DevName,4,"")_DevName_##Class(web.DHCINSUPort).GetCNCODE(DevName,3,"")
 .q:(Dname'="")&(DevName1'[Dname)
 .s DevTel=$p(^PMPDevelop(id),"^",16)
 .q:(Tel'="")&(DevTel'[Tel)
 .s DevEmail=$p(^PMPDevelop(id),"^",3)
 .q:(Email'="")&(DevEmail'[Email)
 .s DevProductid=$p(^PMPDevelop(id),"^",11)
 .i DevProductid'="" s DevProduct=$p(^PMPDictionary(DevProductid),"^",2)
 .q:(Product'="")&(DevProduct'[Product)
 .s DevInDateid=$p(^PMPDevelop(id),"^",4)
 .s DevInTimeid=$p(^PMPDevelop(id),"^",5)
 .i DevInDateid'="" s DevInDate=$zd(DevInDateid,3)
 .i DevInTimeid'="" s DevInTime=$zt(DevInTimeid)
 .s DevOutDateid=$p(^PMPDevelop(id),"^",9)
 .i DevOutDateid'="" s DevOutDate=$zd(DevOutDateid,3)
 .s DevOutTimeid=$p(^PMPDevelop(id),"^",10)
 .i DevOutTimeid'="" s DevOutTime=$zt(DevOutTimeid)
 .s DevBusine=$p(^PMPDevelop(id),"^",2)
 .;q:(InTime'="")&(DevInTime'=InTime)
 .q:(OutDate'="")&(DevOutDate'=OutDate)
 .s DevAppraisal=..DevAppraisal(id)
 .i DevOutDate'="" s DevStatus="离开项目组"
 .i DevOutDate="" s DevStatus="当前项目组"
 .s Rowid=id
 .s i=i+1
 .s tmp=Rowid_"^"_DevName_"^"_DevStatus_"^"_DevAppraisal_"^"_DevTel_"^"_DevEmail_"^"_DevProduct_"^"_DevInDate_"^"_DevInTime_"^"_DevOutDate_"^"_DevOutTime_"^"_DevBusine
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("Rowid^DevName^DevStatus^DevAppraisal^DevTel^DevEmail^DevProduct^DevInDate^DevInTime^DevOutDate^DevOutTime^DevBusine",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-19
/// description: 查询产品组ID
/// input:  type()
/// output: 
/// others:
ClassMethod SelectProductId(InPut)
{
	s ret="-1"
	q:InPut="" ret
	;s ^CacheTemp("SelectProductId")=InPut
	s ret=$o(^PMPDictionary("flagdesc","Product",InPut,""))
	i ret="" s ret="-1"
	q ret
}

/// Creat  zzp
/// date:2015-03-19
/// description: 更新开发数据
/// input:  type()
/// output: 
/// others:
ClassMethod UpdateDetail(InPut As %Text)
{
	;s ^CacheTemp("UpdateDetail",$zt($p($h,",",2)))=InPut
	;UpdateRowid+"^"+UpdateNamec+"^"+UpdateTelc+"^"+UpdateEmailc+"^"+UpdateProductc+"^"+UpdateInDatec+"^"+UpdateInTimec+"^"+UpdateOutDatec+"^"+UpdateOutTimec+"^"+UpdateBusinessReasonc
	;     1               2               3               4                5                  6                7                   8               9                      10
	s ret=-1
	q:InPut="" ret
	q:$l(InPut,"^")'="10" ret
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s Rowid=$p(InPut,"^",1)
	s DevName=$p(InPut,"^",2)
	s DevTel=$p(InPut,"^",3)
	s DevEmail=$p(InPut,"^",4)
	s DevProducti=$p(InPut,"^",5)
	s DevBusinessReason=$p(InPut,"^",10)
	s DevInDate=$p(InPut,"^",6)
	s DevInTime=$p(InPut,"^",7)
	s DevOutDate1=$p(InPut,"^",8)
	s DevOutTime1=$p(InPut,"^",9)
	s DevProduct=$o(^PMPDictionary("flagdesc","Product",DevProducti,""))
	s DevInDate=$zdh(DevInDate,3)
	s DevInTime=$zth(DevInTime)
	i (DevOutDate1'="")&(DevOutDate1'="undefined") s DevOutDate=$zdh(DevOutDate1,3)
	i (DevOutTime1'="")&(DevOutTime1'="undefined") s DevOutTime=$zth(DevOutTime1)
	q:$g(DevProduct)="" ret
	s object=##class(User.PMPDevelop).%OpenId(Rowid)
	s object.DLName=DevName
	s object.DLTel=DevTel
	s object.DLEmail=DevEmail
	s object1=##Class(User.PMPDictionary3).%OpenId(DevProduct)
	s object.DLProductDR=object1
	s object.DLInDate=DevInDate
	s object.DLInTime=DevInTime
	i $g(DevOutDate)'="" s object.DLOutDate=DevOutDate
	i $g(DevOutTime)'="" s object.DLOutTime=DevOutTime
	s object.DLBusinessReason=DevBusinessReason
	s object.DLRecordDate=Date
	s object.DLRecordTime=Time
	s object.DLUser=userId
	s object.DLStatus="Y"
	s object.DLNameSimplicty=##Class(web.DHCINSUPort).GetCNCODE(DevName,4,"")
	s sc=object.%Save()
	i sc="1" s ret=0
	i sc'="1" s ret="-1"
	q ret
}

/// Creat  zzp
/// date:2015-03-19
/// description: 删除开发数据
/// input:  type()
/// output: 
/// others:
ClassMethod DeleteDetail(InPut As %Text)
{
	s ret=-1
	q:InPut="" ret
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s object=##class(User.PMPDevelop).%OpenId(InPut)
	s object.DLStatus="N"
	s sc=object.%Save()
	i sc="1" s ret=0
	i sc'="1" s ret="-1"
	i sc="1"  d
	.s Rowid="" f  s Rowid=$o(^PMPDevelopImprovement(InPut,Rowid)) q:Rowid=""  d
	..s object1=##Class(User.PMPDevelopImprovement).%OpenId(InPut_"||"_Rowid)
	..s object1.DLDIStatus="N"
	..s sd=object1.%Save()
	..i sd'="1" s ret=ret_"^"_InPut_"||"_Rowid
	.s Rowid1="" f  s Rowid1=$o(^PMPDevelopAppraisal(InPut,Rowid1)) q:Rowid1=""  d
	..s object2=##Class(User.PMPDevelopAppraisal).%OpenId(InPut_"||"_Rowid1)
	..s object2.DLAPStatus="N"
	..S se=object2.%Save()
	..i se'="1" s ret=ret_"^"_InPut_"||"_Rowid1
	q ret
}

/// Creat  zzp
/// date:2015-03-21
/// description: 添加开发附件信息
/// input:  AddDevRowid,AddDevType,AddDevMenu,type,SubRowid
/// output: 
/// others:
ClassMethod AddDetailNenu(AddDevRowid, AddDevType, AddDevMenu As %Text, type, SubRowid)
{
	;s ^CacheTemp("AddDetailNenu",$zt($p($h,",",2)))=AddDevRowid_"^"_AddDevType_"^"_AddDevMenu_"^"_type_"^"_SubRowid
	s ret=-1
	q:AddDevRowid="" ret
	q:AddDevType="" ret
	q:AddDevMenu="" ret
	q:type="" ret
	s Date=+$h,Time=$p($h,",",2)
	s AddDevTypeId=$o(^PMPDictionary("flagdesc","AddDevDetail",AddDevType,""))
	s userId=%session.Data("LOGON.USERID")  ;
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	i type="Add"  d
	.&sql(insert INTO sqluser.PMP_DevelopImprovement (PMP_DevelopImprovement_ParRef,DLDI_Type,DLDI_User,DLDI_Status,DLDI_Date,DLDI_Time,DLDI_Menu) values (:AddDevRowid,:AddDevTypeId,:userId,"Y",:Date,:Time,:AddDevMenu))
	.;s object=##class(User.PMPDevelopImprovement).%New()
	.;S object1=##Class(User.PMPDevelop).%OpenId(AddDevRowid)
    .;S object.PMPDevelopImprovementParRef=object1
    .;s object.DLDIDate=Date
    .;s object.DLDIMenu=AddDevMenu
    .;s object2=##Class(User.PMPDictionary3).%OpenId(AddDevTypeId)
    .;s object.DLDIType=object2
    .;s object.DLDIStatus="Y"
    .;s object3=##Class(User.SSUser).%OpenId(userId)
    .;s object.DLDIUser=object3
    .;s object.DLDITime=Time
	.;s sc=object.%Save()
	.;i sc="1" s ret=0
	.;i sc'="1" s ret="-1"
	.s ret=SQLCODE
	s rowid=AddDevRowid_"||"_SubRowid
	i type="Update"  d
	.&sql(update  sqluser.PMP_DevelopImprovement set DLDI_Menu=:AddDevMenu,DLDI_Type=:AddDevTypeId where DLDI_Rowid=:rowid)
	.;s object4=##class(User.PMPDevelopImprovement).%OpenId(AddDevRowid_"||"_SubRowid)
	.;s object4.DLDIMenu=AddDevMenu
	.;s object5=##Class(User.PMPDictionary3).%OpenId(AddDevTypeId)
    .;s object4.DLDIType=object5
    .;s sc=object.%Save()
    .;i sc="1" s ret=0
	.;i sc'="1" s ret="-1"
	.s ret=SQLCODE
	.;b ;222
	q ret
}

/// Creat  zzp
/// date:2015-03-21
/// description: 获取开发其他附加信息
/// input:  type()
/// output: String DevRowiddetail_"^"_DevRowid_"^"_DevNamedetail_"^"_DevTeldetail_"^"_DevProductdetail_"^"_DevUpDatedetail_"^"_DevUpTimedetail_"^"_DevUpUserdetail_"^"_DevUpTypedetail_"^"_DevMenudetail
/// others:
ClassMethod DetailStore(InPut As %Text)
{
 s i=0
 q:InPut="" ""
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 ;s ^CacheTemp("DetailStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0 f  s id=$o(^PMPDevelopImprovement(InPut,id)) q:id=""  d
 .s (DevRowiddetail,DevRowid,DevNamedetail,DevTeldetail,DevProductdetail,DevUpDatedetail,DevUpTimedetail,DevUpUserdetail,DevUpTypedetail,DevMenudetail)=""
 .s DevRowid=InPut
 .s DevRowiddetail=InPut_"||"_id
 .s Status=$p($g(^PMPDevelopImprovement(InPut,id)),"^",5)
 .q:Status'="Y"
 .S DevNamedetail=$p(^PMPDevelop(InPut),"^",6)
 .s DevProductid=$p(^PMPDevelop(InPut),"^",11)
 .i DevProductid'="" s DevProductdetail=$p(^PMPDictionary(DevProductid),"^",2)
 .S DevUpDatedetail=$p(^PMPDevelopImprovement(InPut,id),"^",8)
 .i DevUpDatedetail'="" s DevUpDatedetail=$zd(DevUpDatedetail,3)
 .s DevUpTimedetail=$p(^PMPDevelopImprovement(InPut,id),"^",4)
 .i DevUpTimedetail'="" s DevUpTimedetail=$zt(DevUpTimedetail)
 .s DevUpUserdetailid=$p(^PMPDevelopImprovement(InPut,id),"^",2)
 .i DevUpUserdetailid'="" s DevUpUserdetail=##Class(web.PMP.Document).SSUSER(DevUpUserdetailid)
 .i IndependentUserRet'="Y" s DevUpUserdetailid=+DevUpUserdetailid
 .s DevUpTypedetailid=$p(^PMPDevelopImprovement(InPut,id),"^",3)
 .i DevUpTypedetailid'="" s DevUpTypedetail=$p(^PMPDictionary(DevUpTypedetailid),"^",2)
 .s DevMenudetail=$p(^PMPDevelopImprovement(InPut,id),"^",6)
 .s DevTeldetail=$p(^PMPDevelop(InPut),"^",16)
 .s i=i+1
 .s tmp=DevRowiddetail_"^"_DevRowid_"^"_DevNamedetail_"^"_DevTeldetail_"^"_DevProductdetail_"^"_DevUpDatedetail_"^"_DevUpTimedetail_"^"_DevUpUserdetail_"^"_DevUpTypedetail_"^"_DevMenudetail
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("DevRowiddetail^DevRowid^DevNamedetail^DevTeldetail^DevProductdetail^DevUpDatedetail^DevUpTimedetail^DevUpUserdetail^DevUpTypedetail^DevMenudetail",i)
 k json
 q resultString
}

/// Creat  zzp
/// 
/// 
///  Desc:查询现场工程师
/// Other: d ##class(%ResultSet).RunQuery("web.PMP.Common","MenuBySQL","")
Query MenuBySQL(XCGCS As %String) As websys.Query(ROWSPEC = "Caption,id,date")
{
}

ClassMethod MenuBySQLExecute(ByRef qHandle As %Binary, XCGCS As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i XCGCS'="" s XCGCS=$$ALPHAUP^SSUTIL4(XCGCS)
    i XCGCS'="" S XCGCS=$tr(XCGCS," ","")
	s id=0 f  s id=$o(^PMPDevelop(id)) q:id=""  d
    .s Caption=$p($g(^PMPDevelop(id)),"^",6)
    .q:$g(Caption)=""
    .S TYPE=$p(^PMPDevelop(id),"^",15)
    .Q:TYPE'="Y"
    .s DevInDateid=$p(^PMPDevelop(id),"^",4)
    .s DevInTimeid=$p(^PMPDevelop(id),"^",5)
    .i DevInDateid'="" s date=$zd(DevInDateid,3)
    .s str=##Class(web.DHCINSUPort).GetCNCODE(Caption,4,"")_Caption_id
    .q:(XCGCS'="")&(str'[XCGCS)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Caption,id,$g(date))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creat  zzp
/// date:2015-03-23
/// description: 获取指定开发已完成需求
/// input:  type()
/// output: String ImRowid_"^"_ImName_"^"_ImStatus_"^"_ImCreatDate_"^"_ImCreatUser_"^"_ImCreateLoc_"^"_ImCreateTel_"^"_ImMenu_"^"_ImSituation_"^"_ImStandby3_"^"_ImEmergency_"^"_ImCode_"^"_ImType_"^"_ImDegree
/// others:
ClassMethod ImListStore(InPut As %Text)
{
 s i=0
 q:InPut="" ""
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 s FinishTypeRet=##Class(web.PMP.Document).FinishType()
 ;s ^CacheTemp("DetailStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s IPMLDRowid="" f  s IPMLDRowid=$o(^PMPImpDevelopi("DevelopDR",InPut,IPMLDRowid)) q:IPMLDRowid=""  d
 .S IPMLRowid=$P(^PMPImpDevelop(IPMLDRowid),"^",1)
 .Q:IPMLRowid=""
 .s (ImCreatDated,ImCreatTime,ImRowid,ImName,ImStatus,ImCreatDate,ImCreatUser,ImCreateLoc,ImCreateTel,ImMenu,ImSituation,ImStandby3,ImEmergency,ImCode,ImType,ImDegree)=""
 .s ImRowid=IPMLRowid
 .s IPMLStatusDR=$p(^PMPImprovementList(IPMLRowid),"^",28)
 .s ImName=$p(^PMPImprovementList(IPMLRowid),"^",2)
 .s ImCode=$p(^PMPImprovementList(IPMLRowid),"^",1)
 .i IPMLStatusDR'="" s ImStatus=$P(^PMPDictionary(IPMLStatusDR),"^",2)
 .q:$g(IPMLStatusDR)'=FinishTypeRet
 .s ImCreatDateI=$p(^PMPImprovementList(IPMLRowid),"^",11)
 .i ImCreatDateI'="" s ImCreatDated=$zd(ImCreatDateI,3)
 .s ImCreatTimeI=$p(^PMPImprovementList(IPMLRowid),"^",14)
 .i ImCreatTimeI'="" s ImCreatTime=$zt(ImCreatTimeI)
 .s ImCreatDate=$g(ImCreatDated)_" "_$g(ImCreatTime)
 .s ImCreatUserd=$p(^PMPImprovementList(IPMLRowid),"^",15)
 .i ImCreatUserd'="" s ImCreatUser=##Class(web.PMP.Document).SSUSER(ImCreatUserd)
 .i IndependentUserRet'="Y" s ImCreatUserd=+ImCreatUserd
 .s ImCreateLocd=$p(^PMPImprovementList(IPMLRowid),"^",12)
 .i ImCreateLocd'="" s ImCreateLoc=$p(^CTLOC(ImCreateLocd),"^",1)
 .s ImCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
 .s ImMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
 .s ImSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
 .s ImStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
 .s ImEmergencyd=$p(^PMPImprovementList(IPMLRowid),"^",18)
 .i ImEmergencyd'="" s ImEmergency=$p($G(^PMPDictionary(ImEmergencyd)),"^",2)
 .s ImTyped=$p(^PMPImprovementList(IPMLRowid),"^",31)
 .i ImTyped'="" s ImType=$p($G(^PMPDictionary(ImTyped)),"^",2)
 .s ImDegreed=$p(^PMPImprovementList(IPMLRowid),"^",16)
 .i ImDegreed'="" s ImDegree=$p($G(^PMPDictionary(ImDegreed)),"^",2)
 .s i=i+1
 .s tmp=ImRowid_"^"_ImName_"^"_ImStatus_"^"_ImCreatDate_"^"_ImCreatUser_"^"_ImCreateLoc_"^"_ImCreateTel_"^"_ImMenu_"^"_ImSituation_"^"_ImStandby3_"^"_ImEmergency_"^"_ImCode_"^"_ImType_"^"_ImDegree
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("ImRowid^ImName^ImStatus^ImCreatDate^ImCreatUser^ImCreateLoc^ImCreateTel^ImMenu^ImSituation^ImStandby3^ImEmergency^ImCode^ImType^ImDegree",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-23
/// description: 获取指定开发未完成需求
/// input:  type()
/// output: String ImNRowid_"^"_ImNName_"^"_ImNStatus_"^"_ImNCreatDate_"^"_ImNCreatUser_"^"_ImNCreateLoc_"^"_ImNCreateTel_"^"_ImNMenu_"^"_ImNSituation_"^"_ImNStandby3_"^"_ImNEmergency_"^"_ImNCode_"^"_ImNType_"^"_ImNDegree
/// others:
ClassMethod ImListNStore(InPut As %Text)
{
 s i=0
 q:InPut="" ""
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 s FinishTypeRet=##Class(web.PMP.Document).FinishType()
 ;s ^CacheTemp("DetailStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s IPMLDRowid="" f  s IPMLDRowid=$o(^PMPImpDevelopi("DevelopDR",InPut,IPMLDRowid)) q:IPMLDRowid=""  d
 .S IPMLRowid=$P(^PMPImpDevelop(IPMLDRowid),"^",1)
 .Q:IPMLRowid=""
 .s (ImNCreatDated,ImNCreatTime,ImNRowid,ImNName,ImNStatus,ImNCreatDate,ImNCreatUser,ImNCreateLoc,ImNCreateTel,ImNMenu,ImNSituation,ImNStandby3,ImNEmergency,ImNCode,ImNType,ImNDegree)=""
 .s ImNRowid=IPMLRowid
 .s IPMLStatusDR=$p(^PMPImprovementList(IPMLRowid),"^",28)
 .s ImNName=$p(^PMPImprovementList(IPMLRowid),"^",2)
 .s ImNCode=$p(^PMPImprovementList(IPMLRowid),"^",1)
 .i IPMLStatusDR'="" s ImNStatus=$P(^PMPDictionary(IPMLStatusDR),"^",2)
 .q:$g(IPMLStatusDR)=FinishTypeRet
 .s ImNCreatDateI=$p(^PMPImprovementList(IPMLRowid),"^",11)
 .i ImNCreatDateI'="" s ImNCreatDated=$zd(ImNCreatDateI,3)
 .s ImNCreatTimeI=$p(^PMPImprovementList(IPMLRowid),"^",14)
 .i ImNCreatTimeI'="" s ImNCreatTime=$zt(ImNCreatTimeI)
 .s ImNCreatDate=$g(ImNCreatDated)_" "_$g(ImNCreatTime)
 .s ImNCreatUserd=$p(^PMPImprovementList(IPMLRowid),"^",15)
 .i ImNCreatUserd'="" s ImNCreatUser=##Class(web.PMP.Document).SSUSER(ImNCreatUserd)
 .i IndependentUserRet'="Y" s ImNCreatUserd=+ImNCreatUserd
 .s ImNCreateLocd=$p(^PMPImprovementList(IPMLRowid),"^",12)
 .i ImNCreateLocd'="" s ImNCreateLoc=$p(^CTLOC(ImNCreateLocd),"^",1)
 .s ImNCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
 .s ImNMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
 .s ImNSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
 .s ImNStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
 .s ImNEmergencyd=$p(^PMPImprovementList(IPMLRowid),"^",18)
 .i ImNEmergencyd'="" s ImNEmergency=$p($G(^PMPDictionary(ImNEmergencyd)),"^",2)
 .s ImNTyped=$p(^PMPImprovementList(IPMLRowid),"^",31)
 .i ImNTyped'="" s ImNType=$p($G(^PMPDictionary(ImNTyped)),"^",2)
 .s ImNDegreed=$p(^PMPImprovementList(IPMLRowid),"^",16)
 .i ImNDegreed'="" s ImNDegree=$p($G(^PMPDictionary(ImNDegreed)),"^",2)
 .s i=i+1
 .s tmp=ImNRowid_"^"_ImNName_"^"_ImNStatus_"^"_ImNCreatDate_"^"_ImNCreatUser_"^"_ImNCreateLoc_"^"_ImNCreateTel_"^"_ImNMenu_"^"_ImNSituation_"^"_ImNStandby3_"^"_ImNEmergency_"^"_ImNCode_"^"_ImNType_"^"_ImNDegree
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("ImNRowid^ImNName^ImNStatus^ImNCreatDate^ImNCreatUser^ImNCreateLoc^ImNCreateTel^ImNMenu^ImNSituation^ImNStandby3^ImNEmergency^ImNCode^ImNType^ImNDegree",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-23
/// description: 查询开发添加内容类型
/// input:  type()
/// output: 
/// others:
ClassMethod AddDetailTypeid(InPut As %Text)
{
	s ret="-1"
	q:InPut="" ret
	;s ^CacheTemp("AddDetailTypeid")=InPut
	s ret=$o(^PMPDictionary("flagdesc","AddDevDetail",InPut,""))
	i ret="" s ret="-1"
	q ret
}

/// date:2015-03-24
/// description: 添加联系方式
/// input:  type()
/// output: 
/// others:
ClassMethod AddTel(AddTel, userId)
{
	s ret="-1"
	;s ^CacheTemp("AddTel")=AddTel_"^"_userId
	q:AddTel="" ret
	q:userId="" ret
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s id=$o(^PMPUserTeli("USER",userId,""),-1)
	;s ^CacheTemp("AddDetailTypeid")=InPut
	i (($g(id)="")||($g(id)<"1"))  d
	.s object=##Class(User.PMPUserTel).%New()
	.s object.ULTel=AddTel
	.s object.ULYFlag="Y"
	.s object.ULuserid=userId
	.s sc=object.%Save()
	.i sc="1" s ret="0"
	e  d
	.s object2=##Class(User.PMPUserTel).%OpenId(type)
	.s object2.ULTel=AddTel
	.s sc=object2.%Save()
	.i sc="1" s ret="0"
	q ret
}

/// Creat  zzp
/// date:2015-03-24
/// description: 获取用户联系方式
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).SelectUserTel("1")
ClassMethod SelectUserTel(UserId)
{
	s ret=""
	;s ^CacheTemp("SelectUserTel")=UserId
	q:UserId="" ret
	s id=$o(^PMPUserTeli("USER",UserId,""),-1)
	q:id="" ret
	s ret=$p($g(^PMPUserTel(id)),"^",2)
	q ret
}

/// Creat  zzp
/// date:2015-03-30
/// description: 添加评价
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).AddAppraisal("1","")
/// InPut=Attendancevalue+"^"+WorkEfficiencyvalue+"^"+WorkAttitudevlaue+"^"+OtherStaisvlaue+"^"+AppMenuvlaue+"^"+AppProposalvlaue+"^"+Rowidvlaue;
ClassMethod AddAppraisal(InPut As %Text, Rowidvlaue As %String)
{
	;s ^CacheTemp("AddAppraisal")=InPut_"^"_Rowidvlaue
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s ret="-1"
	q:InPut="" ret
	q:Rowidvlaue="" ret
	q:$l(InPut,"^")'="7" ret
	s Attendancevalue=$p(InPut,"^",1)
	s WorkEfficiencyvalue=$p(InPut,"^",2)
	s WorkAttitudevlaue=$p(InPut,"^",3)
	s OtherStaisvlaue=$p(InPut,"^",4)
	s AppMenuvlaue=$p(InPut,"^",5)
	s AppProposalvlaue=$p(InPut,"^",6)
	s Date=+$h,Time=$p($h,",",2)
	S id="" f  s id=$o(^PMPProjectUseri("SSUSER",userId,id)) q:id=""  d
	.s Profession=$p(^PMPProjectUser(id),"^",2)
	.i Profession'="" s desc=$p(^PMPDictionary(Profession),"^",2)
	.s type="HA"   ;PA/项目评价；DA/实施总监评价；HA/甲方评价；LA/自己领导评价；SS/实施评价；Other/其他
	.i $g(desc)'=""  d
	..i desc["实施工程师" s type="SS" 
	..i desc["经理" s type="PA"
	..i desc["总监" s type="DA"
	i $d(^PMPDevelopAppraisal("User",Rowidvlaue,userId))
	.s Rowid="" f  s Rowid=$o(^PMPDevelopAppraisal("User",Rowidvlaue,userId,Rowid)) q:Rowid=""  d
	..s DLAPRowid=Rowidvlaue_"||"_Rowid
	..&sql(update sqluser.PMP_DevelopAppraisal set DLAP_Status='N' where DLAP_Rowid=:DLAPRowid)
	&SQL(insert into sqluser.PMP_DevelopAppraisal 
	(PMP_DevelopAppraisal_ParRef,DLAP_Type,DLAP_User,DLAP_Status,DLAP_Date,DLAP_Time,DLAP_Meau,DLAP_Adjunct,DLAP_BY1,DLAP_BY2,DLAP_BY3,DLAP_BY4,DLAP_BY5) values (:Rowidvlaue,:type,:userId,'Y',:Date,:Time,:AppMenuvlaue,'N',:Attendancevalue,:WorkEfficiencyvalue,:WorkAttitudevlaue,:OtherStaisvlaue,:AppProposalvlaue))
	s ret=SQLCODE
	q ret
}

/// Creat  zzp
/// date:2015-03-30
/// description: 获取评价得分
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).DevAppraisal("1")
ClassMethod DevAppraisal(InPut As %String)
{
	s ret="" 
	q:InPut="" ret
	s no=0
	s Rowid="0" f  s Rowid=$o(^PMPDevelopAppraisal(InPut,Rowid)) q:Rowid=""  d
	.s Status=$p($G(^PMPDevelopAppraisal(InPut,Rowid)),"^",5)
	.q:Status'="Y"
	.s Attendancevalue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",9)
	.s WorkEfficiencyvalue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",10)
	.s WorkAttitudevlaue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",11)
	.s OtherStaisvlaue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",12)
	.s ret=$g(ret)+Attendancevalue+WorkEfficiencyvalue+WorkAttitudevlaue+OtherStaisvlaue
	.s no=no+1
	i no="0" s ret="暂无评价"
	i no'="0" s ret=no_"个 "_ret_"分"
	q ret
}

/// Creat  zzp
/// date:2015-03-30
/// description: 获取开发详细评价记录
/// input:  type()
/// output: String AppraisalRowid_"^"_AppraisalName_"^"_AppraisalType_"^"_AppraisalSum_"^"_AppraisalAttendance_"^"_AppraisalWorkEff_"^"_AppraisalWorkAtt_"^"_AppraisalOtherStais_"^"_AppraisalMenu_"^"_AppraisalBY5_"^"_AppraisalUser_"^"_AppraisalDate
///                AppraisalRowid     AppraisalName     AppraisalType     AppraisalSum     AppraisalAttendance     AppraisalWorkEff     AppraisalWorkAtt     AppraisalOtherStais     AppraisalMenu     AppraisalBY5     AppraisalUser     AppraisalDate
/// others:
ClassMethod DetailAppraisalStore(InPut As %Text)
{
 s i=0
 q:InPut="" ""
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 ;s ^CacheTemp("DetailAppraisalStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0 f  s id=$o(^PMPDevelopAppraisal(InPut,id)) q:id=""  d
 .s (AppraisalRowid,AppraisalName,AppraisalType,AppraisalSum,AppraisalAttendance,AppraisalWorkEff,AppraisalWorkAtt,AppraisalOtherStais,AppraisalMenu,AppraisalBY5,AppraisalUser,AppraisalDate)=""
 .s Status=$p($g(^PMPDevelopAppraisal(InPut,id)),"^",5)
 .q:Status'="Y"
 .s AppraisalRowid=InPut_"||"_id
 .S AppraisalName=$p(^PMPDevelop(InPut),"^",6)
 .S AppraisalType=$p(^PMPDevelopAppraisal(InPut,id),"^",3)
 .I AppraisalType'="" S AppraisalType=..AppraisalType(AppraisalType)
 .s AppraisalAttendance=$p(^PMPDevelopAppraisal(InPut,id),"^",9)
 .s AppraisalWorkEff=$p(^PMPDevelopAppraisal(InPut,id),"^",10)
 .s AppraisalWorkAtt=$p(^PMPDevelopAppraisal(InPut,id),"^",11)
 .s AppraisalOtherStais=$p(^PMPDevelopAppraisal(InPut,id),"^",12)
 .s AppraisalSum=AppraisalAttendance+AppraisalWorkEff+AppraisalWorkAtt+AppraisalOtherStais
 .s AppraisalMenu=$p(^PMPDevelopAppraisal(InPut,id),"^",6)
 .s AppraisalBY5=$p(^PMPDevelopAppraisal(InPut,id),"^",13)
 .s AppraisalUserid=$p(^PMPDevelopAppraisal(InPut,id),"^",2)
 .i AppraisalUserid'="" s AppraisalUser=##Class(web.PMP.Document).SSUSER(AppraisalUserid)
 .i IndependentUserRet'="Y" s AppraisalUserid=+AppraisalUserid
 .s AppraisalDate1=$p(^PMPDevelopAppraisal(InPut,id),"^",7)
 .i AppraisalDate1'="" s AppraisalDate1=$zd(AppraisalDate1,3)
 .s AppraisalDate2=$p(^PMPDevelopAppraisal(InPut,id),"^",4)
 .i AppraisalDate2'="" s AppraisalDate2=$zt(AppraisalDate2)
 .s AppraisalDate=AppraisalDate1_" "_AppraisalDate2
 .s i=i+1
 .s tmp=AppraisalRowid_"^"_AppraisalName_"^"_AppraisalType_"^"_AppraisalSum_"^"_AppraisalAttendance_"^"_AppraisalWorkEff_"^"_AppraisalWorkAtt_"^"_AppraisalOtherStais_"^"_AppraisalMenu_"^"_AppraisalBY5_"^"_AppraisalUser_"^"_AppraisalDate
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("AppraisalRowid^AppraisalName^AppraisalType^AppraisalSum^AppraisalAttendance^AppraisalWorkEff^AppraisalWorkAtt^AppraisalOtherStais^AppraisalMenu^AppraisalBY5^AppraisalUser^AppraisalDate",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-03-30
/// description: 获取评价类型
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).AppraisalType("1")
ClassMethod AppraisalType(InPut As %String)
{
	s ret=""
	q:InPut="" ret
	i InPut="PA" S ret="项目经理评价"
	i InPut="DA" S ret="实施总监评价"
	i InPut="HA" S ret="医院评价"
	i InPut="SS" S ret="实施评价"
	i InPut="LA" S ret="产品组长评价"
	i InPut="Other" S ret="其他评价"
	q ret
}

/// Creat  zzp
/// date:2015-03-30
/// description: 获取评价总分
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).AppraisalSum("1","1")
ClassMethod AppraisalSum(InPut As %String, Rowid As %String)
{
	s ret=""
	q:InPut="" ret
	s Attendancevalue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",9)
	s WorkEfficiencyvalue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",10)
	s WorkAttitudevlaue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",11)
	s OtherStaisvlaue=$p(^PMPDevelopAppraisal(InPut,Rowid),"^",12)
	s sum=Attendancevalue+WorkEfficiencyvalue+WorkAttitudevlaue+OtherStaisvlaue
	s ret.Attendancevalue=Attendancevalue
	s ret.WorkEfficiencyvalue=WorkEfficiencyvalue
	s ret.WorkAttitudevlaue=WorkAttitudevlaue
	s ret.OtherStaisvlaue=OtherStaisvlaue
	s ret.sum=sum
	q ret
}

/// Creat  zzp
/// date:2015-03-31
/// description: 获取特定需求的附件列表
/// input:  type()
/// output: String AdjunctFlagRowid_"^"_AdjunctFlagName_"^"_AdjunctFlagTime_"^"_AdjunctFlagUser_"^"_AdjunctFlagType
/// others:
ClassMethod AdjunctFlagStore(InPut As %Text)
{
 s i=0
 q:InPut="" ""
 ;s ^CacheTemp("AdjunctFlagStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 S IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 s type=0 f  s type=$o(^PMPImproveAdjuncti("Improve",InPut,type)) q:type=""  d
 .Q:type'="Improvement"
 .s id="" f  s id=$o(^PMPImproveAdjuncti("Improve",InPut,type,id)) q:id=""  d
 ..s (AdjunctFlagRowid,AdjunctFlagName,AdjunctFlagTime,AdjunctFlagUser,AdjunctFlagType)=""
 ..s AdjunctFlagType=$p($g(^PMPImprovementAdjunct(id)),"^",1)
 ..q:AdjunctFlagType=""
 ..s AdjunctFlagRowid=id
 ..s AdjunctFlagName=$p(^PMPImprovementAdjunct(id),"^",4)
 ..s AdjunctFlagUserid=$p(^PMPImprovementAdjunct(id),"^",13)
 ..i AdjunctFlagUserid'="" s AdjunctFlagUser=##Class(web.PMP.Document).SSUSER(AdjunctFlagUserid)
 ..i IndependentUserRet'="Y" s AdjunctFlagUserid=+AdjunctFlagUserid
 ..s AdjunctFlagTime1=$p(^PMPImprovementAdjunct(id),"^",11)
 ..s AdjunctFlagTime2=$p(^PMPImprovementAdjunct(id),"^",12)
 ..i AdjunctFlagTime1'="" s AdjunctFlagTime1=$zd(AdjunctFlagTime1,3)
 ..i AdjunctFlagTime2'="" s AdjunctFlagTime2=$zt(AdjunctFlagTime2)
 ..s AdjunctFlagTime=AdjunctFlagTime1_" "_AdjunctFlagTime2
 ..s i=i+1
 ..s tmp=AdjunctFlagRowid_"^"_AdjunctFlagName_"^"_AdjunctFlagTime_"^"_AdjunctFlagUser_"^"_AdjunctFlagType
 ..d json.InsertRowData(tmp)
 s resultString = json.getJsonData("AdjunctFlagRowid^AdjunctFlagName^AdjunctFlagTime^AdjunctFlagUser^AdjunctFlagType",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-1
/// description: 获取登录人是否已经评价过
/// input:  type()
/// output: 
/// others:
/// w ##class(web.PMP.Common).SelectUser("1","1")
ClassMethod SelectUser(userId As %String, DevRowid As %String)
{
	;s ^CacheTemp("SelectUser",$zt($p($h,",",2)))=userId_"^"_DevRowid
	s ret="-1" 
	q:userId="" ret
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	q:DevRowid="" ret
	s ret="0"
	s Rowid="0" f  s Rowid=$o(^PMPDevelopAppraisal("User",DevRowid,userId,Rowid)) q:Rowid=""  d
	.s Status=$p($G(^PMPDevelopAppraisal(DevRowid,Rowid)),"^",5)
	.q:Status'="Y"
	.s ret="1"
	q ret
}

/// Creat  zzp
/// date:2015-04-01
/// description: 获取工作记录数据
/// input:  type()
/// output: String "title^forumtitle^forumtitle^forumid^author^ObRowid^ObDate^lastposter^ObMenu^ObSolution"
///  title^forumtitle^forumid^author^ObRowid^ObDate^lastposter^ObMenu^ObSolution
/// others:
ClassMethod ObStore(InPut As %Text, type As %Text = "", menu As %Text = "")
{
 s i=0 
 ;s ^CacheTemp("ObStore")=InPut_"^"_type_"^"_menu
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 i InPut'=""  d
 .s id=0 f  s id=$o(^PMPJobLogi("JLG_User",InPut,id)) q:id=""  d
 ..s ObRowid="",ObDate="",ObMenu="",ObDate1="",ObDate2="",ObSolution="",glipml="",gluser=""
 ..s ObMenu=$p($G(^PMPJobLogging(id)),"^",3)
 ..q:ObMenu=""
 ..s ObRowid=id
 ..s ObDate1=$p($G(^PMPJobLogging(id)),"^",2)
 ..s ObDate2=$p($G(^PMPJobLogging(id)),"^",14)
 ..i ObDate1'="" s ObDate1=$zd(ObDate1,3)
 ..i ObDate2'="" s ObDate2=$zt(ObDate2)
 ..s author=##class(web.PMP.Document).SSUSER(InPut)
 ..i IndependentUserRet'="Y" S InPut=+InPut
 ..s title=$p($G(^PMPJobLogging(id)),"^",1)
 ..s ObDate=ObDate1_" "_ObDate2 ;"1305856996"
 ..s forumtitle=$p($G(^PMPJobLogging(id)),"^",9)
 ..i forumtitle="" s forumtitle="暂无标签"
 ..s forumid="14"
 ..s lastposter=author
 ..s ObSolution=$p($G(^PMPJobLogging(id)),"^",7)
 ..S glipml=$p($G(^PMPJobLogging(id)),"^",21)
 ..S gluser=$p($G(^PMPJobLogging(id)),"^",27)
 ..;q:(type="MainTitle")&(title'[menu)
 ..s i=i+1
 ..s tmp=title_"^"_forumtitle_"^"_forumid_"^"_author_"^"_ObRowid_"^"_ObDate_"^"_lastposter_"^"_ObMenu_"^"_ObSolution_"^"_glipml_"^"_gluser
 ..d json.InsertRowData(tmp)
 i InPut=""  d
 .s id=0 f  s id=$o(^PMPJobLogging(id)) q:id=""  d
 ..s ObRowid="",ObDate="",ObMenu="",ObDate1="",ObDate2="",ObSolution="",nr="",author1="",author12="",glipml="",gluser=""
 ..s ObMenu=$p($G(^PMPJobLogging(id)),"^",3)
 ..q:ObMenu=""
 ..s ObRowid=id
 ..s ObDate1=$p($G(^PMPJobLogging(id)),"^",2)
 ..s ObDate2=$p($G(^PMPJobLogging(id)),"^",14)
 ..i ObDate1'="" s ObDate1=$zd(ObDate1,3)
 ..i ObDate2'="" s ObDate2=$zt(ObDate2)
 ..s useridd=$p($G(^PMPJobLogging(id)),"^",15)
 ..i useridd'=""  D
 ...s author=##class(web.PMP.Document).SSUSER(useridd)
 ...s author1=##class(web.PMP.Document).SSUSER1(useridd)
 ..s author12=author1_author
 ..s title=$p($G(^PMPJobLogging(id)),"^",1)
 ..s ObDate=ObDate1_" "_ObDate2 ;"1305856996"
 ..s forumtitle=$p($G(^PMPJobLogging(id)),"^",9)
 ..i forumtitle="" s forumtitle="暂无标签"
 ..s forumid="14"
 ..s lastposter=author
 ..s ObSolution=$p($G(^PMPJobLogging(id)),"^",7)
 ..s nr=ObSolution_ObMenu
 ..q:(type="MainTitle")&(title'[menu)&(menu'="")
 ..q:(type="Title")&(forumtitle'[menu)&(menu'="")
 ..q:(type="Date")&(ObDate'[menu)&(menu'="")
 ..q:(type="Menu")&(nr'[menu)&(menu'="")
 ..q:(type="User")&(author12'[menu)&(menu'="")
 ..S glipml=$p($G(^PMPJobLogging(id)),"^",21)
 ..S gluser=$p($G(^PMPJobLogging(id)),"^",27)
 ..;q:(type="WorkType")&(author12'[menu)&(menu'="")
 ..s i=i+1
 ..s tmp=title_"^"_forumtitle_"^"_forumid_"^"_author_"^"_ObRowid_"^"_ObDate_"^"_lastposter_"^"_ObMenu_"^"_ObSolution_"^"_glipml_"^"_gluser
 ..d json.InsertRowData(tmp)
 s resultString = json.getJsonData("title^forumtitle^forumid^author^ObRowid^ObDate^lastposter^ObMenu^ObSolution^glipml^gluser",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-02
/// description: 获取产品组数据
/// input:  type()
/// output: String "RowId^Description"
/// others:
ClassMethod ObUserstore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ObUserstore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^SSU("SSUSR",id)) q:id=""  d
 .s desc=$p($G(^SSU("SSUSR",id)),"^",2)
 .q:desc=""
 .s NO=$p($G(^SSU("SSUSR",id)),"^",1)
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc_NO_##Class(web.DHCINSUPort).GetCNCODE(desc,3,"")
 .q:(InPut'="")&(namedesc'[InPut)
 .s i=i+1
 .s tmp=id_"^"_desc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-02
/// description: 获取特定工作记录的附件
/// input:  type()
/// output: String AdjunctObRowid_"^"_AdjunctObName_"^"_AdjunctObTime_"^"_AdjunctObUser_"^"_AdjunctObType_"^"_AdjunctFTPObName
/// others:
ClassMethod AdjunctObStore(InPut As %Text, type As %Text = "")
{
 s i=0
 q:InPut="" ""
 q:type="new" ""
 ;s ^CacheTemp("AdjunctObStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 i (type="select")||(type="")  d
 .s id="" f  s id=$o(^PMPImproveAdjuncti("Improve",InPut,"Work",id)) q:id=""  d
 ..s (AdjunctObRowid,AdjunctObName,AdjunctObTime,AdjunctObUser,AdjunctObType,AdjunctFTPObName)=""
 ..s AdjunctObType=$p($g(^PMPImprovementAdjunct(id)),"^",1)
 ..q:AdjunctObType=""
 ..s AdjunctObRowid=id
 ..s AdjunctObName=$p(^PMPImprovementAdjunct(id),"^",4)
 ..s AdjunctObUser=$p(^PMPImprovementAdjunct(id),"^",13)
 ..i AdjunctObUser'="" s AdjunctObUser=##class(web.PMP.Document).SSUSER(AdjunctObUser)
 ..s AdjunctObTime1=$p(^PMPImprovementAdjunct(id),"^",11)
 ..s AdjunctObTime2=$p(^PMPImprovementAdjunct(id),"^",12)
 ..i AdjunctObTime1'="" s AdjunctObTime1=$zd(AdjunctObTime1,3)
 ..i AdjunctObTime2'="" s AdjunctObTime2=$zt(AdjunctObTime2)
 ..s AdjunctObTime=AdjunctObTime1_" "_AdjunctObTime2
 ..S AdjunctFTPObName=$p(^PMPImprovementAdjunct(id),"^",7)
 ..s i=i+1
 ..s tmp=AdjunctObRowid_"^"_AdjunctObName_"^"_AdjunctObTime_"^"_AdjunctObUser_"^"_AdjunctObType_"^"_AdjunctFTPObName
 ..d json.InsertRowData(tmp)
 s resultString = json.getJsonData("AdjunctObRowid^AdjunctObName^AdjunctObTime^AdjunctObUser^AdjunctObType^AdjunctFTPObName",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-02
/// description: 获取需求名称下拉
/// input:  type()
/// output: String "RowId^Description"
/// others:
ClassMethod ObIpmlboxstore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ObIpmlboxstore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^PMPImprovementList(id)) q:id=""  d
 .s desc=$p($G(^PMPImprovementList(id)),"^",2)
 .q:desc=""
 .s code=$p($G(^PMPImprovementList(id)),"^",1)
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc_code
 .q:(InPut'="")&(namedesc'[InPut)
 .s i=i+1
 .s tmp=id_"^"_desc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-27
/// description: 获取系统配置数据
/// input:  InPut1 As %Text,SysMenu As %Text,SysText As %Text
/// output: String SysGridRowid_"^"_SysGridCode_"^"_SysGridDesc_"^"_SysGridText_"^"_SysGridStdate_"^"_SysGridEndate
/// others:
ClassMethod SysGridStore(InPut1 As %Text = "", SysMenu As %Text = "", SysText As %Text = "")
{
 s i=0
 ;q:InPut="" ""
 ;s ^CacheTemp("SysGridStore",$zt($p($h,",",2)))=InPut1_"@"_SysMenu_"@"_SysText
 s type=$p(InPut1,"^",1)
 i type'="" s type=$$ALPHAUP^SSUTIL4(type)
 s stdate=$p(InPut1,"^",2)
 s endate=$p(InPut1,"^",3)
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s (SysGridRowid,SysGridCode,SysGridDesc,SysGridText,SysGridStdate,SysGridEndate)=""
 s SysRowid="" f  s SysRowid=$o(^PMPSysConfigure(0,SysRowid)) q:SysRowid=""  d
 .s SysGridCode=$p(^PMPSysConfigure(0,SysRowid),"^",1)
 .q:SysGridCode=""
 .s SysGridRowid=SysRowid
 .s SysGridDesc=$p(^PMPSysConfigure(0,SysRowid),"^",2)
 .s SysGridText=$p(^PMPSysConfigure(0,SysRowid),"^",3)
 .s SysGridStdate=$p(^PMPSysConfigure(0,SysRowid),"^",4)
 .i SysGridStdate'="" s SysGridStdate=$zd(SysGridStdate,3)
 .s SysGridEndate=$p(^PMPSysConfigure(0,SysRowid),"^",5)
 .i SysGridEndate'="" s SysGridEndate=$zd(SysGridEndate,3)
 .q:(type'="")&($$ALPHAUP^SSUTIL4(SysGridCode)'[type)
 .q:(stdate'="")&(SysGridStdate'[stdate)
 .q:(endate'="")&(SysGridEndate'[endate)
 .q:(SysMenu'="")&(SysGridDesc'[SysMenu)
 .q:(SysText'="")&(SysGridText'[SysText)
 .s i=i+1
 .s tmp=SysGridRowid_"^"_SysGridCode_"^"_SysGridDesc_"^"_SysGridText_"^"_SysGridStdate_"^"_SysGridEndate
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("SysGridRowid^SysGridCode^SysGridDesc^SysGridText^SysGridStdate^SysGridEndate",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-27
/// description: 删除配置数据
/// input:  Rowid
/// output: ret
/// others:
ClassMethod SysGridDelete(Rowid As %String) As %String
{
	s ret="-1"  
	q:Rowid="" -1
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	i $d(^PMPProjectUseri("SSUSER",userId))  d
	.s jectUser=$o(^PMPProjectUseri("SSUSER",userId,""))
	.i jectUser="" s ret="-2"
	.q:jectUser=""
	.s jecid=$p(^PMPProjectUser(jectUser),"^",2)
	.i jecid="" s ret="-3"
	.q:jecid=""
	.s dicdesc=$p(^PMPDictionary(jecid),"^",2)
	.i dicdesc="" s ret="-4"
	q:(userId'="1")&($g(dicdesc)'["经理") -5
	&sql(delete from sqluser.PMP_SysConfigure where sc_rowid=:Rowid)
	s ret=$g(SQLCODE)
	q ret
}

/// Creat  zzp
/// date:2015-04-27
/// description: 更新配置数据
/// input:  updaterowid(MenuRowid+"^"+MenuFlag+"^"+MenuToDate+"^"+MenuTypeName+"^"+MenuFromDate),MenuMenu,MenuText
/// output: ret
/// others: MenuFlag Add 为新增，Update 为更新
ClassMethod SysUpdate(updaterowid As %Text, MenuMenu As %Text, MenuText As %Text) As %String
{
	s ret="false"
	q:MenuMenu="" "MenuMenu"
	s MenuRowid=$p(updaterowid,"^",1)
	s MenuFlag=$p(updaterowid,"^",2)
	s MenuToDate=$p(updaterowid,"^",3)
	s MenuTypeName=$p(updaterowid,"^",4)
	s MenuFromDate=$p(updaterowid,"^",5)
	q:MenuTypeName="" "MenuTypeName"
	q:MenuFlag="" "MenuFlag"
	i (MenuFlag="Add")  d AddSys
	i (MenuFlag="Update") d Updatesys
	q ret
AddSys
   Ts
	i MenuFromDate["-" s MenuFromDate=$zdh(MenuFromDate,3)
	i MenuFromDate="" s MenuFromDate=+$h
	s object=##Class(User.PMPSysConfigure).%New()
	s object.SCType=MenuTypeName
	s object.SCMenu=MenuMenu
	i MenuText'="" s object.SCText=MenuText
	s object.SCStdate=MenuFromDate
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
Updatesys
    q:MenuRowid="" "MenuRowid"
    Ts
	i MenuFromDate["-" s MenuFromDate=$zdh(MenuFromDate,3)
	i MenuFromDate="" s MenuFromDate=+$h
	i MenuToDate["-" s MenuToDate=$zdh(MenuToDate,3)
	s object=##Class(User.PMPSysConfigure).%OpenId(MenuRowid)
	s object.SCType=MenuTypeName
	s object.SCMenu=MenuMenu
	i MenuText'="" s object.SCText=MenuText
	i MenuFromDate'="" s object.SCStdate=MenuFromDate
	i MenuToDate'="" s object.SCEndate=MenuToDate
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-04-27
/// description: 获取联系方式数据
/// input:  InPut As %Text   TelText+"^"+TelLoc+"^"+TelUser+"^"+TelEmail
/// output: String TelGridRowid_"^"_TelGridName_"^"_TelGridLoc_"^"_TelGridTel_"^"_TelGridEmail_"^"_TelGridbz
/// others:
ClassMethod TelGridStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("TelGridStore",$zt($p($h,",",2)))=InPut
 s tel=$p(InPut,"^",1)
 s TelLoc=$p(InPut,"^",2)
 s TelUser=$p(InPut,"^",3)
 s TelEmail=$p(InPut,"^",4)
 i tel'="" s tel=$$ALPHAUP^SSUTIL4($tr(tel," "))
 i TelLoc'="" s TelLoc=$$ALPHAUP^SSUTIL4($tr(TelLoc," "))
 i TelUser'="" s TelUser=$$ALPHAUP^SSUTIL4($tr(TelUser," "))
 i TelEmail'="" s TelEmail=$$ALPHAUP^SSUTIL4($tr(TelEmail," "))
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s TelRowid="" f  s TelRowid=$o(^PMPUserTel(TelRowid)) q:TelRowid=""  d
 .s (TelGridRowid,TelGridName,TelGridLoc,TelGridTel,TelGridEmail,TelGridbz)=""
 .s userid=$p(^PMPUserTel(TelRowid),"^",1)
 .i userid'="" s TelGridName=##class(web.PMP.Document).SSUSER(userid)
 .q:userid=""
 .s TelGridRowid=TelRowid
 .s locid=$p(^PMPUserTel(TelRowid),"^",7)
 .i locid'="" s TelGridLoc=$p(^CTLOC(locid),"^",2)
 .s TelGridTel=$p(^PMPUserTel(TelRowid),"^",2)
 .s TelGridEmail=$p(^PMPUserTel(TelRowid),"^",8)
 .s TelGridbz=$p(^PMPUserTel(TelRowid),"^",4)
 .s user=##class(web.DHCINSUPort).GetCNCODE(TelGridName,4,"")_##class(web.DHCINSUPort).GetCNCODE(TelGridName,3,"")_TelGridName
 .q:(tel'="")&(TelGridTel'[tel)
 .q:(TelLoc'="")&(TelGridLoc'[TelLoc)
 .q:(TelUser'="")&(user'[TelUser)
 .q:(TelEmail'="")&($$ALPHAUP^SSUTIL4(TelGridEmail)'[TelEmail)
 .s i=i+1
 .s tmp=TelGridRowid_"^"_TelGridName_"^"_TelGridLoc_"^"_TelGridTel_"^"_TelGridEmail_"^"_TelGridbz
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("TelGridRowid^TelGridName^TelGridLoc^TelGridTel^TelGridEmail^TelGridbz",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-27
/// description: 检查该用户是否存在联系方式
/// input:  
/// output: ret
/// others:
ClassMethod UserTelType() As %String
{
	s UserName=%session.Data("LOGON.USERNAME")
	s ret=""_"^"_UserName_"^"_""
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	i $d(^PMPUserTeli("USER",userId))  D
	.S rowid=$o(^PMPUserTeli("USER",userId,""))
	.s ret="1"_"^"_UserName_"^"_rowid
	q ret
}

/// Creat  zzp
/// date:2015-04-27
/// description: 数据更新、新建操作
/// input:  Input  TelRowid+"^"+TelFlag+"^"+TelMenuText+"^"+TelMenuEmail+"^"+TelMenubz
/// output: ret
/// others:
ClassMethod TelUpdate(Input As %Text) As %String
{
	s userId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s ret="-1"
	q:Input="" "Input"
	s Rowid=$p(Input,"^",1)
	s TelFlag=$p(Input,"^",2)
	s TelMenuText=$p(Input,"^",3)
	q:TelMenuText="" "TelMenuText"
	s TelMenuEmail=$p(Input,"^",4)
	s TelMenubz=$p(Input,"^",5)
	i TelFlag="Add"  d AddTel
	i TelFlag="Update" d Update
	q ret
Update
    i Rowid="" s ret="Rowid"
    q:Rowid="" ret
    Ts
	s object=##Class(User.PMPUserTel).%OpenId(Rowid)
	s object.ULTel=TelMenuText
	i TelMenuEmail'="" s object.ULEmail=TelMenuEmail
	i TelMenubz'="" s object.ULRemark=TelMenubz
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
AddTel
    Ts
	s object=##Class(User.PMPUserTel).%New()
	s objloc=##Class(User.CTLoc).%OpenId(locid)
	s object.ULLoc=objloc
	s object.ULuserid=userId
	s object.ULTel=TelMenuText
	i TelMenuEmail'="" s object.ULEmail=TelMenuEmail
	i TelMenubz'="" s object.ULRemark=TelMenubz
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-04-27
/// description: 获取联系方式数据
/// input:  InPut As %Text   JectName+"^"+JectHosp+"^"+JectCode+"^"+JectUser;
/// output: String JectGridRowid_"^"_JectGridName_"^"_JectGridHosName_"^"_JectGridUser_"^"_JectGridUserZL_"^"_JectGridCode_"^"_JectGridType_"^"_JectGridDel_"^"_JectGridDelDD_"^"_JectGridTel_"^"_JectGridDate_"^"_JectGridCreatUser_"^"_JectGridbz
/// others:
ClassMethod JectGridStore(InPut As %Text)
{
 s iI=0
 S IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 ;s ^CacheTemp("TelGridStore",$zt($p($h,",",2)))=InPut
 s JectName=$p(InPut,"^",1)
 s JectHosp=$p(InPut,"^",2)
 s JectCode=$p(InPut,"^",3)
 s JectUser=$p(InPut,"^",4)
 i JectName'="" s JectName=$$ALPHAUP^SSUTIL4($tr(JectName," "))
 i JectHosp'="" s JectHosp=$$ALPHAUP^SSUTIL4($tr(JectHosp," "))
 i JectCode'="" s JectCode=$$ALPHAUP^SSUTIL4($tr(JectCode," "))
 i JectUser'="" s JectUser=$$ALPHAUP^SSUTIL4($tr(JectUser," "))
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s ProRowid="" f  s ProRowid=$o(^PMPProject(ProRowid)) q:ProRowid=""  d
 .s (JectGridRowid,JectGridName,JectGridHosName,JectGridUser,JectGridUserZL,JectGridCode,JectGridType,JectGridDel,JectGridDelDD,JectGridTel,JectGridDate,JectGridCreatUser,JectGridbz)=""
 .s JectGridName=$p(^PMPProject(ProRowid),"^",2)
 .q:JectGridName=""
 .s JectGridRowid=ProRowid
 .s JectGridUserid=$p(^PMPProject(ProRowid),"^",9)
 .i JectGridUserid'="" s JectGridUser=##Class(web.PMP.Document).SSUSER(JectGridUserid)
 .i IndependentUserRet'="Y" s JectGridUserid=+JectGridUserid
 .s JectGridHosNameid=$p(^PMPProject(ProRowid),"^",3)
 .i JectGridHosNameid'="" s JectGridHosName=$p(^CT("HOSP",JectGridHosNameid),"^",2)
 .s JectGridUserZLid=$p(^PMPProject(ProRowid),"^",10)
 .i JectGridUserZLid'="" s JectGridUserZL=##Class(web.PMP.Document).SSUSER(JectGridUserZLid)
 .i IndependentUserRet'="Y" s JectGridUserZLid=+JectGridUserZLid
 .s JectGridCode=$p(^PMPProject(ProRowid),"^",1)
 .s JectGridTypeid=$p(^PMPProject(ProRowid),"^",7)
 .s JectGridType=$SELECT(JectGridTypeid="Y":"有效",JectGridTypeid="N":"无效")
 .s JectGridDel=$p(^PMPProject(ProRowid),"^",14)
 .s JectGridDelDD=$p(^PMPProject(ProRowid),"^",15)
 .s JectGridTel=$p(^PMPProject(ProRowid),"^",16)
 .s JectGridDateid=$p(^PMPProject(ProRowid),"^",5)
 .s JectGridTimeid=$p(^PMPProject(ProRowid),"^",6)
 .i JectGridDateid'="" s JectGridDate1=$zd(JectGridDateid,3)
 .i JectGridTimeid'="" s JectGridTime1=$zt(JectGridTimeid)
 .s JectGridDate=JectGridDate1_" "_JectGridTime1
 .s JectGridCreatUserid=$p(^PMPProject(ProRowid),"^",8)
 .i JectGridCreatUserid'="" s JectGridCreatUser=##Class(web.PMP.Document).SSUSER(JectGridCreatUserid)
 .i IndependentUserRet'="Y" s JectGridCreatUserid=+JectGridCreatUserid
 .s JectGridbz=$p(^PMPProject(ProRowid),"^",4)
 .s JectGridUser1=$$ALPHAUP^SSUTIL4($tr(JectGridUser," "))
 .i JectGridHosName'="" s HosName=##class(web.DHCINSUPort).GetCNCODE(JectGridHosName,4,"")_##class(web.DHCINSUPort).GetCNCODE(JectGridHosName,3,"")_JectGridHosName
 .i JectGridUser'="" s UserName=##class(web.DHCINSUPort).GetCNCODE(JectGridUser1,4,"")_##class(web.DHCINSUPort).GetCNCODE(JectGridUser1,3,"")_JectGridUser1
 .s NameStr=##class(web.DHCINSUPort).GetCNCODE(JectGridName,4,"")_##class(web.DHCINSUPort).GetCNCODE(JectGridName,3,"")_JectGridName
 .q:(JectName'="")&(NameStr'[JectName)
 .q:(JectHosp'="")&($g(HosName)'[JectHosp)
 .q:(JectCode'="")&($$ALPHAUP^SSUTIL4(JectGridCode)'[JectCode)
 .q:(JectUser'="")&($g(UserName)'[JectUser)
 .s iI=iI+1
 .s tmp=JectGridRowid_"^"_JectGridName_"^"_JectGridHosName_"^"_JectGridUser_"^"_JectGridUserZL_"^"_JectGridCode_"^"_JectGridType_"^"_JectGridDel_"^"_JectGridDelDD_"^"_JectGridTel_"^"_JectGridDate_"^"_JectGridCreatUser_"^"_JectGridbz
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("JectGridRowid^JectGridName^JectGridHosName^JectGridUser^JectGridUserZL^JectGridCode^JectGridType^JectGridDel^JectGridDelDD^JectGridTel^JectGridDate^JectGridCreatUser^JectGridbz",iI)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-29
/// description: 获取医院下拉列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod JectHosStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("JectHosStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s HosRowid="" f  s HosRowid=$o(^CT("HOSP",HosRowid)) q:HosRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p(^CT("HOSP",HosRowid),"^",2)
 .q:Description=""
 .s RowId=HosRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-29
/// description: 获取项目成员列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod JectUserStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("JectUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s (RowId,Description)=""
 s PerRowid="" f  s PerRowid=$o(^PMPProjectUser(PerRowid)) q:PerRowid=""  d
 .s (RowId,Description)=""
 .s uderid=$p(^PMPProjectUser(PerRowid),"^",1)
 .q:uderid=""
 .s Description=$p(^PMPProjectUser(PerRowid),"^",22)
 .q:Description=""
 .s RowId=uderid_"||"_PerRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-29
/// description: 获取项目状态信息
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod JectPerType(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("JectUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s (RowId,Description)=""
 f num=1:1:2  d
 .i num=1 s RowId="Y",Description="有效"
 .i num=2 s RowId="N",Description="无效"
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-29
/// description: 获取项目部分值的rowid
/// input:  InPut 
/// output: String  JectGridHosNameid_"^"_JectGridUserid_"^"_JectGridUserZLid_"^"_JectGridTypeid  医院id_"^"_项目经理id_"^"_项目助理id_"^"_项目状态id
/// others:                
ClassMethod SelectRetRowid(ProRowid As %String) As %String
{
	s ret="" 
	s HisVersions=##Class(web.PMP.Document).HisVersions()
	;s ^CacheTemp("SelectRetRowid",$zt($p($h,",",2)))=ProRowid
	i ProRowid'=""  d
	.q:'$d(^PMPProject(ProRowid)) 
	.s JectGridHosNameid=$p(^PMPProject(ProRowid),"^",3)
	.s JectGridUserid=$p(^PMPProject(ProRowid),"^",9)
	.s JectGridUserZLid=$p(^PMPProject(ProRowid),"^",10)
	.s JectGridTypeid=$p(^PMPProject(ProRowid),"^",7)
	.s ret="PRO"_"^"_JectGridHosNameid_"^"_JectGridUserid_"^"_JectGridUserZLid_"^"_JectGridTypeid
	i ProRowid=""  d
	.i HisVersions="1" s hosid=%session.Data("LOGON.HOSPID")
	.i HisVersions="0"  d
	..s locid=%session.Data("LOGON.CTLOCID")
	..s hosid=$p($g(^CTLOC(locid)),"^",22)
	.i hosid="" s hosid=$o(^CT("HOSP",""),-1)  //当各种条件都没有取到医院id的时候就取医院表的最后一条数据
	.s hosdesc=$p(^CT("HOSP",hosid),"^",2)
	.s hoscode=$p(^CT("HOSP",hosid),"^",1)
	.s ret="session"_"^"_hosid_"^"_hosdesc_"^"_hoscode
	q ret
}

/// Creat  zzp  
/// date:2015-04-29
/// description: 项目数据插入和更新
/// input:  Input As %Text(AUJectFlag+"^"+AUJectName+"^"+AUJectCode+"^"+AUJectHosName+"^"+AUJectUser+"^"+AUJectUserZL+"^"+AUJectType+"^"+AUJectDel+"^"+AUJectDD+"^"+AUJectTel+"^"+AUJectRowid;),Menu As %Text
/// output: String  
/// others: 
ClassMethod ProAddUpdate(Input As %Text, Menu As %Text) As %String
{
	s ret=""
	;s ^CacheTemp("ProAddUpdate",$zt($p($h,",",2)))=Input_"@"_Menu
	s userId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s Date=+$h,Time=$p($h,",",2)
	q:Input="" "-1"
	s AUJectFlag=$p(Input,"^",1)
	s AUJectName=$p(Input,"^",2)
	s AUJectCode=$p(Input,"^",3)
	s AUJectHosName=$p(Input,"^",4)
	s AUJectUser=$p(Input,"^",5)
	i (AUJectUser<1)||(AUJectUser>1000000) s AUJectUser=""
	s AUJectUserZL=$p(Input,"^",6)
	s AUJectType=$p(Input,"^",7)
	s AUJectDel=$p(Input,"^",8)
	s AUJectDD=$p(Input,"^",9)
	s AUJectTel=$p(Input,"^",10)
	s AUJectRowid=$p(Input,"^",11)
	i AUJectHosName="0" s AUJectHosName=""
	i AUJectUserZL="0" s AUJectUserZL=""
	i AUJectType="0" s AUJectType=""
	i AUJectUser="0" s AUJectUser=""
	i AUJectType["有效" s AUJectType="Y" e  s AUJectType="N" 
	d AddUpdatePro
	q ret
AddUpdatePro
    Ts
	i AUJectFlag="Add" s object=##Class(User.PMPProject).%New()
	i AUJectFlag="Update" s object=##Class(User.PMPProject).%OpenId(AUJectRowid)
    S object.PJTDesc=AUJectName
    s object.PJTCode=AUJectCode
    s objectHos=##Class(User.CTHospital).%OpenId(AUJectHosName)
    s object.PJTHospitalDR=objectHos
    i AUJectUser'=""  d
    .s object.PJTManagerDR=AUJectUser
    i AUJectUserZL'=""  d
    .s object.PJTAssistantDR=AUJectUserZL
    s object.PJTStatus=AUJectType
    i AUJectDel'="" s object.PJTStandby1=AUJectDel
    i AUJectDD'="" s object.PJTStandby2=AUJectDD
    i AUJectTel'="" s object.PJTStandby3=AUJectTel
    i AUJectFlag="Add" s object.PJTUserDR=userId
    i AUJectFlag="Add" s object.PJTDate=Date
    i AUJectFlag="Add" s object.PJTTime=Time
    s object.PJTUpdateDate=Date
    s object.PJTUpdateTime=Time
    i Menu'="" s object.PJTRemark=Menu
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-04-30
/// description: 获取模块状态
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModeuleStatusStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeuleStatusStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","Status",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-30
/// description: 获取模块数据
/// input:  InPut   ModeuleName+"^"+ModeuleStandby1+"^"+ModeuleCode+"^"+ModeuleStatus;
/// output: String ModeuleGridRowid_"^"_ModeuleGridName_"^"_ModeuleGridCode_"^"_ModeuleGridStandby1_"^"_ModeuleGridProduct_"^"_ModeuleGridStandby2_"^"_ModeuleGridProduct1_"^"_ModeuleGridStatus_"^"_ModeuleGridPlanDate_"^"_ModeuleGridActuclDate_"^"_ModeuleGridRemark
/// others:
ClassMethod ModeuleGridStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeuleGridStore",$zt($p($h,",",2)))=InPut
 s ModeuleName=$p(InPut,"^",1)
 S ModeuleStandby1=$P(InPut,"^",2)
 S ModeuleCode=$P(InPut,"^",3)
 S ModeuleStatus=$P(InPut,"^",4)
 I ModeuleName'="" S ModeuleName=##class(web.DHCINSUPort).GetCNCODE($$ALPHAUP^SSUTIL4(ModeuleName),4,"")
 I ModeuleStandby1'="" S ModeuleStandby1=##class(web.DHCINSUPort).GetCNCODE($$ALPHAUP^SSUTIL4(ModeuleStandby1),4,"")
 I ModeuleCode'="" S ModeuleCode=$$ALPHAUP^SSUTIL4(ModeuleCode)
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s MoudleId="0" f  s MoudleId = $o(^PMPModule(MoudleId))  q:MoudleId=""   d
 .s (ModeuleGridRowid,ModeuleGridName,ModeuleGridCode,ModeuleGridStandby1,ModeuleGridProduct,ModeuleGridStandby2,ModeuleGridProduct1,ModeuleGridStatus,ModeuleGridPlanDate,ModeuleGridActuclDate,ModeuleGridRemark,ModeuleGridCP,ModeuleGridCPid,ModeuleGridContract,ModeuleGridContractid,ModeuleGridGroup,ModeuleGridGroupid,ModeuleGridImpro)=""
 .s ModeuleGridCode=$p(^PMPModule(MoudleId),"^",1) ;模块编码Code
 .q:ModeuleGridCode=""
 .s ModeuleGridName=$p(^PMPModule(MoudleId),"^",2) ;模块描述
 .s ModeuleGridActuclDate=$p(^PMPModule(MoudleId),"^",4)    ;实际上线日期9	MODE_ActuclDate
 .i ModeuleGridActuclDate'="" s ModeuleGridActuclDate=$zd(ModeuleGridActuclDate,3)
 .s ModeuleGridPlanDate=$p(^PMPModule(MoudleId),"^",6) ;计划上线日期MODE_PlanDate
 .i ModeuleGridPlanDate'="" s ModeuleGridPlanDate=$zd(ModeuleGridPlanDate,3)
 .s tProductDR=$p(^PMPModule(MoudleId),"^",7) ;产品组MODE_Product_DR
 .I tProductDR'="" S ModeuleGridProduct=$P(^PMPDictionary(tProductDR),"^",2)
 .s ModeuleGridStandby2=$p(^PMPModule(MoudleId),"^",17) ;产品组负责人MODE_Standby2
 .s ModeuleGridStandby1=$p(^PMPModule(MoudleId),"^",16) ;版本号MODE_Standby1
 .s ModeuleGridRemark=$p(^PMPModule(MoudleId),"^",8) ;备注MODE_Remark
 .s tProNameid=$p(^PMPModule(MoudleId),"^",9) ;项目指针MODE_Project1_DR
 .i tProNameid'="" s ModeuleGridProduct1=$p(^PMPProject(tProNameid),"^",2)
 .s tStatusid=$p(^PMPModule(MoudleId),"^",10) ;项目状态MODE_Status_DR
 .I tStatusid'="" s ModeuleGridStatus=$p(^PMPDictionary(tStatusid),"^",2)
 .s ModeuleGridRowid=MoudleId
 .q:(ModeuleName'="")&(##class(web.DHCINSUPort).GetCNCODE(ModeuleGridName,4,"")'[ModeuleName)
 .q:(ModeuleCode'="")&($$ALPHAUP^SSUTIL4(ModeuleGridCode)'[ModeuleCode)
 .q:(ModeuleStandby1'="")&(ModeuleGridStandby1'[ModeuleStandby1)
 .q:(ModeuleStatus'="")&(tStatusid'=ModeuleStatus)
 .s ModeuleGridCPid=$p(^PMPModule(MoudleId),"^",18)
 .i ModeuleGridCPid'="" s ModeuleGridCP=$p(^PMPProduct(ModeuleGridCPid),"^",2)
 .s ModeuleGridContractid=$p(^PMPModule(MoudleId),"^",25)
 .i ModeuleGridContractid'="" s ModeuleGridContract=$p(^PMPContract(ModeuleGridContractid),"^",2)
 .s ModeuleGridGroupid=$p(^PMPModule(MoudleId),"^",26)
 .i ModeuleGridGroupid'="" s ModeuleGridGroup=$p(^PMPDictionary(ModeuleGridGroupid),"^",2)
 .i $d(^PMPImprovementListi("Module",MoudleId))  s ModeuleGridImpro="Y"
 .s i=i+1
 .s tmp=ModeuleGridRowid_"^"_ModeuleGridName_"^"_ModeuleGridCode_"^"_ModeuleGridCP_"^"_ModeuleGridCPid_"^"_ModeuleGridContract_"^"_ModeuleGridContractid_"^"_ModeuleGridGroup_"^"_ModeuleGridGroupid_"^"_ModeuleGridStandby1_"^"_ModeuleGridProduct_"^"_ModeuleGridStandby2_"^"_ModeuleGridProduct1_"^"_ModeuleGridStatus_"^"_ModeuleGridPlanDate_"^"_ModeuleGridActuclDate_"^"_ModeuleGridRemark_"^"_ModeuleGridImpro
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("ModeuleGridRowid^ModeuleGridName^ModeuleGridCode^ModeuleGridCP^ModeuleGridCPid^ModeuleGridContract^ModeuleGridContractid^ModeuleGridGroup^ModeuleGridGroupid^ModeuleGridStandby1^ModeuleGridProduct^ModeuleGridStandby2^ModeuleGridProduct1^ModeuleGridStatus^ModeuleGridPlanDate^ModeuleGridActuclDate^ModeuleGridRemark^ModeuleGridImpro",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-04-30
/// description: 获取项目数据数据
/// input:  InPut   
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModeuleProNameStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeuleProNameStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s (RowId,Description)=""
 s ProRowid="" f  s ProRowid=$o(^PMPProject(ProRowid)) q:ProRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p(^PMPProject(ProRowid),"^",2)
 .Q:$p(^PMPProject(ProRowid),"^",7)="N"
 .q:Description=""
 .s RowId=ProRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-04-30
/// description: 获产品组
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModPerJStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModPerJStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","Product",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s Description=##class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"-"_Description
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 改进速度
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ImAppPJ1Store(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ImAppPJ1Store",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f RowId=1:1:5  d
 .i RowId="1" s Description="很慢"
 .i RowId="2" s Description="较慢"
 .i RowId="3" s Description="正常"
 .i RowId="4" s Description="较快"
 .i RowId="5" s Description="很快"
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 改进质量
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ImAppPJ2Store(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ImAppPJ2Store",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f RowId=1:1:5  d
 .i RowId="1" s Description="很差"
 .i RowId="2" s Description="较差"
 .i RowId="3" s Description="一般"
 .i RowId="4" s Description="较好"
 .i RowId="5" s Description="很好"
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 服务态度
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ImAppPJ3Store(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ImAppPJ3Store",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f RowId=1:1:5  d
 .i RowId="1" s Description="很差"
 .i RowId="2" s Description="较差"
 .i RowId="3" s Description="一般"
 .i RowId="4" s Description="较好"
 .i RowId="5" s Description="很好"
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 查询该需求是否评价过
/// input:  Rowid 
/// output: String sub
/// others:
ClassMethod AppSelect(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ret
	s ret=$o(^PMPImprovementAppraisal(Rowid,""))
	q ret
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 查询评价记录
/// input:  Input (ImAppPJ1+"^"+ImAppPJ2+"^"+ImAppPJ3+"^"+ImAppRowid)  Menu
/// output: String sub
/// others:
ClassMethod insertApp(Input As %Text, Menu As %Text) As %String
{
	;s ^CacheTemp("insertApp",$zt($p($h,",",2)))=Input_"@"_Menu
	s ret="-1" 
	q:Input="" "-2"
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s Date=+$h,Time=$p($h,",",2)
	s ImAppPJ1=$p(Input,"^",1)
	s ImAppPJ2=$p(Input,"^",2)
	s ImAppPJ3=$p(Input,"^",3)
	S ImAppRowid=$P(Input,"^",4)
	Q:ImAppRowid="" "-3"
	TS
	&sql(insert into sqluser.PMP_ImprovementAppraisal (PMP_AppraisalPar_Ref,IPAP_Type,IPAP_User,IPAP_Status,IPAP_Date,IPAP_Time,IPAP_Meau,IPAP_PJ1,IPAP_PJ2,IPAP_PJ3) values (:ImAppRowid,"HA",:userId,"Y",:Date,:Time,:Menu,:ImAppPJ1,:ImAppPJ2,:ImAppPJ3))
	if ($g(SQLCODE))
	{
		Tro
	}
	else
	{
	 Tc 	
	}
	s ret=$g(SQLCODE)
	q ret
}

/// Creat  zzp  
/// date:2015-05-01
/// description: 检索开发姓名列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod SelectKF(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("SelectKF",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 S RowId="" f  s RowId=$o(^PMPDevelop(RowId)) q:RowId=""  d
 .q:$g(^PMPDevelop(RowId))=""
 .s Description=$p($g(^PMPDevelop(RowId)),"^",6)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 检索模块部分指针rowid
/// input:  InPut 
/// output: String tProductDR_"^"_tProNameid_"^"_tStatusid
/// others:  
ClassMethod SelectModRowid(MoudleId As %String) As %String
{
	s ret=""
	q:MoudleId="" ret
	s tProductDR=$p(^PMPModule(MoudleId),"^",7)    //产品组id
	s tProNameid=$p(^PMPModule(MoudleId),"^",9) ;项目指针MODE_Project1_DR
	s tStatusid=$p(^PMPModule(MoudleId),"^",10) ;项目状态MODE_Status_DR
	s ret=tProductDR_"^"_tProNameid_"^"_tStatusid
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 模块数据新增、更新操作
/// input:  Input (ModRowid+"^"+ModFlag+"^"+ModName+"^"+ModCode+"^"+ModProName+"^"+ModSdy1+"^"+ModPerJ+"^"+ModPerUser+"^"+ModStatus+"^"+ModPanDate+"^"+ModDate+"^"+ModProPC+"^"+ModProContract+"^"+ModProGroup),Menu  
/// output: String 
/// others: w ##class(web.PMP.Common).ModAddUpdate("^Add^123测试模块^CODE^1^HIS8.0^66^张枕平^2^2015-04-30^2015-05-08","测试系统功能")
ClassMethod ModAddUpdate(InPut As %Text, Menu As %String) As %String
{
	;s ^CacheTemp("ModAddUpdate",$zt($p($h,",",2)))=InPut_"@"_Menu
	s ret="-1"
	q:InPut="" "-2"
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	s ModRowid=$p(InPut,"^",1)
	s ModFlag=$p(InPut,"^",2)
	s ModName=$p(InPut,"^",3)
	s ModCode=$p(InPut,"^",4)
	s ModProName=$p(InPut,"^",5)
	s ModSdy1=$p(InPut,"^",6)
	s ModPerJ=$p(InPut,"^",7)
	s ModPerUser=$p(InPut,"^",8)
	s ModStatus=$p(InPut,"^",9)
	s ModPanDate=$p(InPut,"^",10)
	s ModDate=$p(InPut,"^",11)
	s ModProPC=$p(InPut,"^",12)
	s ModProContract=$p(InPut,"^",13)
	s ModProGroup=$p(InPut,"^",14)
	i ModPanDate'="" s ModPanDate=$zdh(ModPanDate,3)
	i ModDate'="" s ModDate=$zdh(ModDate,3)
	d AddUpdateMod
	q ret
AddUpdateMod
	Ts
	i ModFlag="Add" s object=##Class(User.PMPModule).%New()
	i ModFlag="Update" s object=##Class(User.PMPModule).%OpenId(ModRowid)
	s object.MODEDesc=ModName
	s object.MODECode=ModCode
	i ModProName'=""  d
	.s objectPro=##Class(User.PMPProject).%OpenId(ModProName)
	.s object.MODEProject1DR=objectPro
	i ModSdy1'="" s object.MODEStandby1=ModSdy1
	i ModPerJ'=""  d
	.s objPerJ=##Class(User.PMPDictionary3).%OpenId(ModPerJ)
	.s object.MODEProductDR=objPerJ
	i ModPerUser'="" s object.MODEStandby2=ModPerUser
	i ModStatus'=""  d
	.s objectStatus=##Class(User.PMPDictionary3).%OpenId(ModStatus)
	.s object.MODEStatusDR=objectStatus
	i ModPanDate'="" s object.MODEPlanDate=ModPanDate
	i ModDate'="" s object.MODEActuclDate=ModDate
	s object.MODEDate=Date
	s object.MODETime=Time
	i Menu'="" s object.MODERemark=Menu
	s object.MODEUserDR=userId
	s object.MODEUpdateUserDR=userId
	s object.MODEUpdateDate=Date
	s object.MODEUpdateTime=Time
	i ModProPC'=""  d
	.s objectpc=##Class(User.PMPProduct).%OpenId(ModProPC)
	.s object.MODEStandby3=objectpc
	i ModProContract'=""  d
	.s objectCon=##Class(User.PMPContract).%OpenId(ModProContract)
	.s object.MODEContract=objectCon
	i ModProGroup'=""  d
	.s objectGrop=##Class(User.PMPDictionary3).%OpenId(ModProGroup)
	.s object.MODEGroup=objectGrop
	s rc=object.%Save()
	i ModFlag="Add" s result = object.%Id()
	i ModFlag="Update" s result=ModRowid
	if (rc)
	{
		Tc
		&sql(insert into sqluser.PMP_ModuleDetail (PMP_Module_ParRef,MODT_Status_DR,MODT_Remark,MODT_Date,MODT_Time,MODT_User_DR) values (:result,:ModStatus,:Menu,:Date,:Time,:userId))	
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 工作记录的增加修改操作
/// input:  Input(ROWIDvalue+"^"+Obtitlevalue+"^"+ObMaintitlevalue+"^"+ObDatevalue+"^"+ObUpDatevalue+"^"+Typecomboboxvalue+"^"+JLGDR),ObContentivalue,Solutionivalue,demRowIDList1,IP,AddValue
/// output: String 
/// others: w ##class(web.PMP.Common).AddUpdateOb("^小知识^小知识测试系统^2015-05-02^2015-05-02^3^Y","阿萨德安德森爱的暗室逢灯撒的谎东华","说地方说地方东华带两个电话费规范化会更好的后果规划法规","小知识^E:\自己\毕业设计\[gbk]本科毕业论文.doc","192.168.1.3","1,2^3")
ClassMethod AddUpdateOb(InPut As %Text, ObContentivalue As %Text, Solutionivalue As %Text, demRowIDList1 As %Text, IP As %String, AddValue As %Text) As %String
{
	s ^CacheTemp("AddUpdateOb",$zt($p($h,",",2)))=InPut_"##"_ObContentivalue_"##"_Solutionivalue_"##"_demRowIDList1_"##"_IP_"##"_AddValue
	s ret="-1"
	q:InPut="" "-2"
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	S ROWIDvalue=$P(InPut,"^",1)
	S Obtitlevalue=$P(InPut,"^",2)
	S ObMaintitlevalue=$P(InPut,"^",3)
	S ObDatevalue=$P(InPut,"^",4)
	S ObUpDatevalue=$P(InPut,"^",5)
	S Typecomboboxvalue=$P(InPut,"^",6)
	s JLGDR=$p(InPut,"^",7)
	s newtype=$p(InPut,"^",8)
	i $G(JLGDR)'="Y" S JLGDR="N"
	i ObUpDatevalue'="" s ObUpDatevalue=$zdh(ObUpDatevalue,3)
	i ObDatevalue'="" s ObDatevalue=$zdh(ObDatevalue,3)
	s ipmlvalue=$P(AddValue,"^",1)
	S gluser=$p(AddValue,"^",2)
	d AddUpdate
	q ret
AddUpdate
    Ts
	i ROWIDvalue="" s object=##Class(User.PMPJobLogging).%New()
	i ROWIDvalue'="" s object=##Class(User.PMPJobLogging).%OpenId(ROWIDvalue)
	i Obtitlevalue'="" s object.JLGStandby2=Obtitlevalue
	i ObMaintitlevalue'="" s object.JLGContent=ObMaintitlevalue
	i ObDatevalue'="" s object.JLGDate=ObDatevalue
	i ObUpDatevalue'="" s object.JLGFinishDate=ObUpDatevalue
	s object.JLGFinishTime=Time
	s object.JLGTime=Time
	s object.JLGUser=userId
	i Typecomboboxvalue'="" s object.JLGStandby4=Typecomboboxvalue
	i ObContentivalue'="" s object.JLGDesc=ObContentivalue
	i Solutionivalue'="" s object.JLGSolution=Solutionivalue
	S object.JLGDR=JLGDR
	i ipmlvalue'=""  d
	.s oldipmlvalue=object.JLGImprovmentDR
	.i oldipmlvalue'="" s oldipmlvalue=oldipmlvalue_","_ipmlvalue
	.i oldipmlvalue="" s oldipmlvalue=ipmlvalue
	.s object.JLGImprovmentDR=oldipmlvalue
	i gluser'=""  d
	.s olduser=object.JLGUserDR
	.i olduser'="" s olduser=olduser_","_gluser
	.i olduser="" s olduser=gluser
	.s object.JLGUserDR=olduser
	s rc=object.%Save()
	if (rc)
	{
		Tc
		i (JLGDR="Y")&(ROWIDvalue="")  d
		.i ROWIDvalue="" s result = object.%Id()
	    .i ROWIDvalue'="" s result=ROWIDvalue
	    .f num=1:1:$l(demRowIDList1,"@@")  d
	    ..s list=$p(demRowIDList1,"@@",num)
	    ..s dz=$p(list,"^",2)
	    ..s newname=$p(list,"^",3)
	    ..s type=$p(list,"^",1)  //1,"工作记录"],[2,"问题解决"],[3,"小知识"],[4,"会议记录"
	    ..i type="" s type=newtype
	    ..s typeid=$SELECT(type="工作记录":"1",type="问题解决":"2",type="小知识":"3",type="会议记录":"4")
	    ..s name=$p(dz,"\",$l(dz,"\"))
	    ..s filetype=$p(name,".",$l(name,"."))
	    ..s objectfj=##Class(User.PMPImprovementAdjunct).%New()
	    ..s objectfj.IPAJDate=Date
	    ..s objectfj.IPAJImprove=result
	    ..s objectfj.IPAJLocation=dz
	    ..s objectfj.IPAJAffiliation="Work"
	    ..s objectfj.IPAJName=name
	    ..s objectfj.IPAJStandby2=typeid
	    ..s objectfj.IPAJTime=Time
	    ..s objectfj.IPAJStandby3=newname
	    ..s objectfj.IPAJStandby5=IP
	    ..s objectfj.IPAJStandby4=filetype
	    ..s objectfj.IPAJUserDR=userId
	    ..s rt=objectfj.%Save()
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 获取附件配置
/// input:  
/// output: String 
/// others: w ##class(web.PMP.Common).AdjunctIP()
ClassMethod AdjunctIP() As %String
{
	s rowid=$o(^PMPSysConfigure("Type","AdjunctIP",""))
	s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 检索科室列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod DepartLocStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("DepartLocStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 S RowId="" f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
 .S Description=$P($g(^CTLOC(RowId)),"^",2)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 检索用户列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod DepartUserStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("DepartUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
 .S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
 .q:Description=""
 .;s Description=##Class(web.DHCINSUPort).GetCNCODE($tr(Description," "),4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-06-24
/// description: 检索用户列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PermissionUserStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PermissionUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
 .S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
 .q:Description=""
 .;s Description=##Class(web.DHCINSUPort).GetCNCODE($tr(Description," "),4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 i IndependentUserRet="Y" d
 .S id="" f  s id=$o(^PMPProjectUser(id)) q:id=""  d
 ..s Description=$p(^PMPProjectUser(id),"^",22)
 ..q:Description=""
 ..s RowId=$p(^PMPProjectUser(id),"^",1)_"||"_id
 ..s tmp=RowId_"^"_Description
 ..s i=i+1
 ..d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 检索用户列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ProjectUserStore(InPut As %Text)
{
 s IndependentUserRet=##Class(web.PMP.Document).IndependentUser()
 s CommonUserRet=##Class(web.PMP.Document).CommonUser()
 s i=0
 ;s ^CacheTemp("DepartUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 i IndependentUserRet'="Y"  d 
 .S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
 ..S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
 ..q:Description=""
 ..;s Description=##Class(web.DHCINSUPort).GetCNCODE($tr(Description," "),4,"")_Description
 ..s i=i+1
 ..s tmp=RowId_"^"_Description
 ..d json.InsertRowData(tmp)
 i IndependentUserRet="Y"  d 
 .f id=1:1:$l(CommonUserRet,",")  d
 ..s RowId=$p(CommonUserRet,",",id)
 ..i $d(^SSU("SSUSR",RowId)) d
 ...s Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
 ...s i=i+1
 ...s tmp=RowId_"^"_Description
 ...d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 科主任更新修改
/// input:  InPut (DepartRowid+"^"+DepartFlag+"^"+DepartAddLoc+"^"+DepartAddUser+"^"+DepartAddType)
/// output: String 
/// others:
ClassMethod DepartUpdate(InPut As %Text) As %String
{
	s ret="-1"
	s DepartRowid=$p(InPut,"^",1)
	s DepartFlag=$p(InPut,"^",2)
	s DepartAddLoc=$p(InPut,"^",3)
	s DepartAddUser=$p(InPut,"^",4)
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(DepartAddUser)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s DepartAddUser=DepartAddUser_"||"_##Class(web.PMP.Document).ConvertUser(DepartAddUser,"")
	s DepartAddType=$p(InPut,"^",5)
	q:DepartFlag="" "-2"
	q:DepartAddLoc="" "-3"
	q:DepartAddUser="" "-4"
	q:DepartAddType="" "-5"
	q:(DepartRowid="")&(DepartFlag="Update") "-6"
	d AddUpdateDepart
	q ret
AddUpdateDepart
    Ts
    i DepartFlag="Add" s object=##Class(User.PMPDepartAudit).%New()
    i DepartFlag="Update" s object=##Class(User.PMPDepartAudit).%OpenId(DepartRowid)
    s object.AuditEffect="Y"
    i DepartAddUser'=""  d
    .s object.AuditUserDr=DepartAddUser
    i DepartAddLoc'=""  d
    .s objectloc=##Class(User.CTLoc).%OpenId(DepartAddLoc)
    .s object.AuditLocDr=objectloc
    s object.AuditSpare=DepartAddType
    s rc=object.%Save()
    if (rc){
	    Tc
    }
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 检索科主任配置的类型
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod DepartTypeStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("DepartTypeStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f id=1:1:2  d
 .i id="1" s Description="科室分配",RowId="L"
 .i id="2" s Description="需求分配",RowId="F"
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-04
/// description: 获取科室主任配置的数据分类
/// input:  AuditRowid
/// output: String 
/// others:
ClassMethod SelectTypeRowid(AuditRowid) As %String
{
	s ret=""
	q:AuditRowid="" ret
	s ret=$p(^DepartAudit(AuditRowid),"^",4)
	q ret
}

/// Creat  zzp  
/// date:2015-04-30
/// description: 获取职称
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PUUserZCStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PUUserZCStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","Profession",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s Description=##class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"-"_Description
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 新增，修改工程师信息
/// input:  InPut(PUUserAddRowid+"^"+PUUserAddFlag+"^"+PUUserAddPerName+"^"+PUUserName+"^"+PUUserAddUserTel+"^"+PUUserAddUserEmail+"^"+PUUserAddZC+"^"+PUUserAddInDate+"^"+PUUserAddInTime+"^"+PUUserAddOuDate+"^"+PUUserAddOuTime+"^"+PUUserNewName+"^"+PUUserNewNo+"^"+PUUserAddPassWord)    Menu
/// output: String 
/// others:w ##class(web.PMP.Common).AddUpdatePerUser("6^Update^1^1000^18230326251^zhangzhenping@dhcc.com.cn^73^2014-01-01^12:21:21^^","测试测试")
ClassMethod AddUpdatePerUser(InPut As %Text, Menu As %Text) As %String
{
	;s ^CacheTemp("AddUpdatePerUser",$zt($p($h,",",2)))=InPut_"@@@"_Menu
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	s ret="-1"
	q:InPut="" "-2"
	s PUUserAddRowid=$p(InPut,"^",1)
	s PUUserAddFlag=$p(InPut,"^",2)
	s PUUserAddPerName=$p(InPut,"^",3)
	s PUUserName=$p(InPut,"^",4)
	s PUUserAddUserTel=$p(InPut,"^",5)
	s PUUserAddUserEmail=$p(InPut,"^",6)
	s PUUserAddZC=$p(InPut,"^",7)
	s PUUserAddInDate=$p(InPut,"^",8)
	s PUUserAddInTime=$p(InPut,"^",9)
	s PUUserAddOuDate=$p(InPut,"^",10)
	s PUUserAddOuTime=$p(InPut,"^",11)
	s PUUserNewName=$p(InPut,"^",12)
	s PUUserNewNo=$p(InPut,"^",13)
	s PUUserAddPassWord=$p(InPut,"^",14)
	q:PUUserAddFlag="" "-3"
	q:PUUserAddPerName="" "-4"
	q:PUUserName="" "-5"
	q:(PUUserAddUserTel="")&(PUUserAddUserEmail="") "-6"
	q:PUUserAddInDate="" "-7"
	q:PUUserAddInTime="" "-8"
	q:PUUserNewName="" "-10"
	q:PUUserNewNo="" "-11"
	q:PUUserAddPassWord="" "-12"
	q:(PUUserAddFlag="Update")&(PUUserAddRowid="") "-9"
	i PUUserAddInDate'="" s PUUserAddInDate=$zdh(PUUserAddInDate,3)
	i PUUserAddOuDate'="" s PUUserAddOuDate=$zdh(PUUserAddOuDate,3)
	i PUUserAddInTime'="" s PUUserAddInTime=$zth(PUUserAddInTime)
	i PUUserAddOuTime'="" s PUUserAddOuTime=$zth(PUUserAddOuTime)
	d AddUpdaePerUser
	q ret
AddUpdaePerUser
    Ts
    i PUUserAddFlag="Add" s object=##Class(User.PMPProjectUser).%New()
    i PUUserAddFlag="Update" s object=##Class(User.PMPProjectUser).%OpenId(PUUserAddRowid)
    i PUUserAddPerName'=""  d
    .s objPerName=##Class(User.PMPProject).%OpenId(PUUserAddPerName)
    .s object.PJUProjectDR=objPerName
    i PUUserName'=""  d
    .s object.PJUUserDR=PUUserName
    s object.PJUNewUserName=PUUserNewName
    s object.PJUNewUserNo=PUUserNewNo
    i PUUserAddUserTel'="" s object.PJUTel=PUUserAddUserTel
    i PUUserAddUserEmail'="" s object.PJUEmail=PUUserAddUserEmail
    i PUUserAddZC'=""  d
    .s objectzc=##Class(User.PMPDictionary3).%OpenId(PUUserAddZC)
    .s object.PJUProfessionDR=objectzc
    i PUUserAddInDate'="" s object.PJUStDate=PUUserAddInDate
    i PUUserAddInTime'="" s object.PJUStTime=PUUserAddInTime
    i PUUserAddOuDate'="" s object.PJUEnDate=PUUserAddOuDate
    i PUUserAddOuTime'="" s object.PJUEnTime=PUUserAddOuTime
    i PUUserAddPassWord'="" s object.PJUNewPassWord=##Class(web.SSUser).Encrypt(PUUserAddPassWord)
    i Menu'="" s object.PJURemark=Menu
    s object.PJUDate=Date
    s object.PJUTime=Time
    s object.PJUStandby1=userId
    s rc=object.%Save()
    if (rc){
	    Tc
	    i PUUserAddUserTel'=""  d
	    .i $d(^PMPUserTeli("PeojectUser",object.%Id()))  d
	    ..s Telid=$o(^PMPUserTeli("PeojectUser",object.%Id(),""))
	    ..s objecttel=##Class(User.PMPUserTel).%OpenId(Telid)
	    ..s objecttel.ULProjectUser=object
	    ..s objecttel.ULTel=PUUserAddUserTel
	    ..s objecttel.ULuserid=userId
	    ..i PUUserAddUserEmail'="" s objecttel.ULEmail=PUUserAddUserEmail
	    ..s telc=objecttel.%Save()
	    .e  d
	    ..s objtel=##Class(User.PMPUserTel).%New()
	    ..s objtel.ULProjectUser=object
	    ..s objtel.ULTel=PUUserAddUserTel
	    ..s objtel.ULuserid=userId
	    ..i PUUserAddUserEmail'="" s objtel.ULEmail=PUUserAddUserEmail
	    ..s telc=objtel.%Save()
    }
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 检索模块列表
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod AddPuModeNameStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("AddPuModeNameStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="" f  s RowId=$o(^PMPModule(RowId)) q:RowId=""  d
 .s Description=$p(^PMPModule(RowId),"^",2)
 .q:Description=""
 .s Description=##class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"-"_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 新增，修改工程师负责的模块数据
/// input:  InPut(AddModeRowid+"^"+AddModeFlag+"^"+AddModeName+"^"+AddModeInDate+"^"+AddModeInTime+"^"+AddModeOuDate+"^"+AddModeOuTime)    Menu
/// output: String 
/// others:w ##class(web.PMP.Common).AddUpdateUserMode("","")
ClassMethod AddUpdateUserMode(InPut As %Text, Menu As %Text) As %String
{
	;s ^CacheTemp("AddUpdateUserMode",$zt($p($h,",",2)))=InPut_"@@@"_Menu
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	s ret="-1"
	q:InPut="" "-2"
	s AddModeRowid=$p(InPut,"^",1)
	s AddModeFlag=$p(InPut,"^",2)
	s AddModeName=$p(InPut,"^",3)
	s AddModeInDate=$p(InPut,"^",4)
	s AddModeInTime=$p(InPut,"^",5)
	s AddModeOuDate=$p(InPut,"^",6)
	s AddModeOuTime=$p(InPut,"^",7)
	Q:AddModeFlag="" "-3"
	Q:AddModeInDate="" "-4"
	Q:AddModeInTime="" "-5"
	q:AddModeRowid="" "-6"
	q:(AddModeFlag="Update")&($p(AddModeRowid,"||",2)="") "-7"
	i AddModeInDate'="" s AddModeInDate=$zdh(AddModeInDate,3)
	i AddModeOuDate'="" s AddModeOuDate=$zdh(AddModeOuDate,3)
	i AddModeInTime'="" s AddModeInTime=$zth(AddModeInTime)
	i AddModeOuTime'="" s AddModeOuTime=$zth(AddModeOuTime)
	d AddUpdateUserMode
	q ret
AddUpdateUserMode
    Ts
    i AddModeFlag="Add" s object=##Class(User.PMPModuleUser).%New()
    i AddModeFlag="Update"   d
    .s moderowid=$p(AddModeRowid,"||",2)
    .q:moderowid=""
    .s object=##Class(User.PMPModuleUser).%OpenId(moderowid)
    i +AddModeRowid'=""  d
    .s objectPer=##Class(User.PMPProjectUser).%OpenId(+AddModeRowid)
    .s object.MDUUserDR=objectPer
    i AddModeName'=""  d
    .s objectmode=##Class(User.PMPModule).%OpenId(AddModeName)
    .s object.MDUModuleDR=objectmode
    i AddModeInDate'="" s object.MDUStDate=AddModeInDate
    i AddModeInTime'="" s object.MDUStTime=AddModeInTime
    i AddModeOuDate'="" s object.MDUEnDate=AddModeOuDate
    i AddModeOuTime'="" s object.MDUEnTime=AddModeOuTime
    s object.MDUDate=Date
    s object.MDUTime=Time
    i Menu'="" s object.MDURemark=Menu
    S object.MDUUserDR1=userId
    s object.MDUFalg="Yes"
    s rc=object.%Save()
    if (rc){
	    Tc
    }
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 检索权限列表
/// input: 
/// output: String 
/// others:d ##class(%ResultSet).RunQuery("web.PMP.Common","PermisQuery","","","")
/// PermisRowid,PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId
/// 记录id,        级别名称       级别        项目名称   项目id          创建日期        创建时间         权限用户  审核结果     审核结果id    提醒审核       提醒审核id     必须审核    必须审核id
Query PermisQuery(PerName As %String, PerSName As %String, PerLive) As websys.Query(ROWSPEC = "PermisRowid:%String,PermisLiveName:%String,PermisLive:%String,PermisPerName:%String,PermisPerId:%String,PermisCreatDate:%String,PermisCreatTime:%String,PermisUserName:%String,PermisAudit:%String,PermisAuditId:%String,PermisTAudit:%String,PermisTAuditId:%String,PermisMustAu:%String,PermisMustAuId:%String,PermisType:%String,PermisTypeid:%String") [ SqlProc ]
{
}

ClassMethod PermisQueryExecute(ByRef qHandle As %Binary, PerName As %String, PerSName As %String, PerLive) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    k ^CacheTemp("PermisQueryUser",$j)
    i PerName'="" s PerName=##class(web.DHCINSUPort).GetCNCODE($tr(PerName," "),4,"")  //项目名称
    i PerSName'="" s PerSName=##class(web.DHCINSUPort).GetCNCODE($tr(PerSName," "),4,"")  //权限名称
    i PerLive'="" s PerLive=##class(web.DHCINSUPort).GetCNCODE($tr(PerLive," "),4,"")  //权限级别
    s PermisRowid=""  f  s PermisRowid=$o(^PMPPermission(PermisRowid)) q:(PermisRowid="")  d
    .s (PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisTypeid,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId,PermisType)=""
    .q:$p(^PMPPermission(PermisRowid),"^",5)'="Y" //删除操作的隐藏元素
    .s PermisLiveName=$p(^PMPPermission(PermisRowid),"^",2)
    .q:PermisLiveName=""
    .s PerDescStr=##class(web.DHCINSUPort).GetCNCODE($tr(PermisLiveName," "),4,"")_PermisLiveName
    .q:(PerSName'="")&(PerDescStr'[PerSName)
    .s PermisLive=$p(^PMPPermission(PermisRowid),"^",3)
    .q:(PerLive'="")&(PermisLive'[PerLive)
    .s PermisPerId=$p(^PMPPermission(PermisRowid),"^",4)
    .i PermisPerId'="" s PermisPerName=$p(^PMPProject(PermisPerId),"^",2) //项目描述
    .i PermisPerName'="" s PermisPerNamedesc=##class(web.DHCINSUPort).GetCNCODE($tr(PermisPerName," "),4,"")_PermisPerName
    .q:(PerName'="")&($g(PermisPerNamedesc)'[PerName)
    .s PermisCreatDate=$p(^PMPPermission(PermisRowid),"^",1)
    .i PermisCreatDate'="" s PermisCreatDate=$zd(PermisCreatDate,3)
    .s PermisCreatTime=$p(^PMPPermission(PermisRowid),"^",10)
    .i PermisCreatTime'="" s PermisCreatTime=$zt(PermisCreatTime)
    .s PermisTypeid=$p(^PMPPermission(PermisRowid),"^",9)
    .i PermisTypeid'="" s PermisType=$p(^PMPDictionary(PermisTypeid),"^",2)
    .s PerSub="0" f  s PerSub=$o(^PMPPermisBusiness(PermisRowid,"E",PerSub)) q:PerSub=""  d
    ..q:$p(^PMPPermisBusiness(PermisRowid,"E",PerSub),"^",3)'="Y"
    ..S UserId=$p(^PMPPermisBusiness(PermisRowid,"E",PerSub),"^",4)
    ..q:UserId=""
    ..i UserId["||" s UserName=$p(^PMPProjectUser($p(UserId,"||",2)),"^",22)
    ..i UserId'["||" s UserName=$p(^SSU("SSUSR",+UserId),"^",2)
    ..I IndependentUserRet'="Y" S UserId=+UserId
    ..i '$d(^CacheTemp("PermisQueryUser",$j,PermisRowid,UserName))   d
    ...s ^CacheTemp("PermisQueryUser",$j,PermisRowid,UserName)=""
    ...i PermisUserName'="" s PermisUserName=PermisUserName_","_UserName
    ...i PermisUserName="" s PermisUserName=UserName
    .s PermisAuditId=$p(^PMPPermission(PermisRowid),"^",6)
    .i PermisAuditId'="" s PermisAudit=$p(^PMPDictionary(PermisAuditId),"^",2)
    .s PermisTAuditId=$p(^PMPPermission(PermisRowid),"^",7)
    .i PermisTAuditId'="" s PermisTAudit=$p(^PMPPermission(PermisTAuditId),"^",2)
    .s PermisMustAuId=$p(^PMPPermission(PermisRowid),"^",8)
    .i PermisMustAuId'="" s PermisMustAu=$SELECT(PermisMustAuId="Y":"必须审核",PermisMustAuId="N":"非必须审核",PermisMustAuId="F":"需求分配",PermisMustAuId="E":"院长审核")
    
    .d OutputRowPermisQuery
    k ^CacheTemp("PermisQueryUser",$j)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowPermisQuery
    s Data=$lb(PermisRowid,PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId,PermisType,PermisTypeid)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 检索权限列表明细
/// input: 
/// output: String 
/// others:d ##class(%ResultSet).RunQuery("web.PMP.Common","PermisQueryDetail","6","","")
/// PermisSRowid,PermisSLiveName,PermisSLive,PermisSUserName,PermisSUserId,PermisSCreatDate,PermisSCreatTime,PermisSLoc,PermisSLocId
/// 记录id,       权限名称        权限级别      权限用户      权限用户Id        创建日期      创建时间        科室类型    科室类型id
Query PermisQueryDetail(PerRowid As %String, PerLoc As %String, PerUser) As websys.Query(ROWSPEC = "PermisSRowid:%String,PermisSLiveName:%String,PermisSLive:%String,PermisSUserName:%String,PermisSUserId:%String,PermisSCreatDate:%String,PermisSCreatTime:%String,PermisSLoc:%String,PermisSLocId:%String") [ SqlProc ]
{
}

ClassMethod PermisQueryDetailExecute(ByRef qHandle As %Binary, PerRowid As %String, PerLoc As %String, PerUser) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    ;s ^Temp("PermisQueryDetail")=PerRowid_"^"_PerLoc_"^"_PerUser
    q:PerRowid="" $$$OK
    i PerLoc'="" s PerLoc=##class(web.DHCINSUPort).GetCNCODE($tr(PerLoc," "),4,"")  //科室类型
    i PerUser'="" s PerUser=##class(web.DHCINSUPort).GetCNCODE($tr(PerUser," "),4,"")  //用户名称 
    s SubRowid="" f  s SubRowid=$o(^PMPPermisBusiness(PerRowid,"E",SubRowid)) q:SubRowid=""  d
    .s (PermisSLiveName,PermisSLive,PermisSUserName,PermisSUserId,PermisSCreatDate,PermisSCreatTime,PermisSLoc,PermisSLocId)=""
    .q:$p(^PMPPermisBusiness(PerRowid,"E",SubRowid),"^",3)'="Y"
    .s PermisSLiveName=$p(^PMPPermission(PerRowid),"^",2)
    .q:PermisSLiveName=""
    .s PermisSLive=$p(^PMPPermission(PerRowid),"^",3)
    .s PermisSUserId=$p(^PMPPermisBusiness(PerRowid,"E",SubRowid),"^",4)
    .q:PermisSUserId=""
    .i PermisSUserId["||" s PermisSUserName=$p(^PMPProjectUser($p(PermisSUserId,"||",2)),"^",22)
    .i PermisSUserId'["||" s PermisSUserName=$p(^SSU("SSUSR",+PermisSUserId),"^",2)
    .i IndependentUserRet'="Y" S PermisSUserId=+PermisSUserId
    .i $g(PermisSUserName)'="" s PermisSUserNamedesc=##class(web.DHCINSUPort).GetCNCODE($tr(PermisSUserName," "),4,"")_PermisSUserName
    .q:(PerUser'="")&($g(PermisSUserNamedesc)'[PerUser)
    .s PermisSCreatDate=$p(^PMPPermisBusiness(PerRowid,"E",SubRowid),"^",1)
    .i PermisSCreatDate'="" s PermisSCreatDate=$zd(PermisSCreatDate,3)
    .s PermisSCreatTime=$p(^PMPPermisBusiness(PerRowid,"E",SubRowid),"^",2)
    .i PermisSCreatTime'="" s PermisSCreatTime=$zt(PermisSCreatTime)
    .s PermisSLocId=$p(^PMPPermisBusiness(PerRowid,"E",SubRowid),"^",5)
    .i PermisSLocId'="" s PermisSLoc=$p(^RBC("DEP",PermisSLocId),"^",2)
    .i $g(PermisSLoc)'="" s PermisSLocdesc=##class(web.DHCINSUPort).GetCNCODE($tr(PermisSLoc," "),4,"")_PermisSLoc
    .q:(PerLoc'="")&($g(PermisSLocdesc)'[PerLoc)
    .s PermisSRowid=PerRowid_"||"_SubRowid
    .d OutputRowPermisDetail
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowPermisDetail
    s Data=$lb(PermisSRowid,PermisSLiveName,PermisSLive,PermisSUserName,PermisSUserId,PermisSCreatDate,PermisSCreatTime,PermisSLoc,PermisSLocId)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取需求状态
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PerStatusStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PerStatusStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","Improvement",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取必须审核类型
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PermisMustAuStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PermisMustAuStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f RowIdid=1:1:4  d
 .s Description=$SELECT(RowIdid="1":"必须审核",RowIdid="2":"非必须审核",RowIdid="3":"需求分配",RowIdid="4":"院长审核")
 .s RowId=$SELECT(RowIdid="1":"Y",RowIdid="2":"N",RowIdid="3":"F",RowIdid="4":"E")
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取提醒审核数据
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PermisTAuditStore(InPut As %Text)
{
 s i=0
 q:InPut="" $$$OK
 ;s ^CacheTemp("PermisTAuditStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=InPut  f  s RowId=$o(^PMPPermission(RowId)) q:RowId=""  d
 .q:$p(^PMPPermission(RowId),"^",5)'="Y" //删除操作的隐藏元素
 .s Description=$p(^PMPPermission(RowId),"^",2)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-06
/// description: 审核流程删除操作
/// input:  PermisRowid 
/// output: String
/// others: w ##class(web.PMP.Common).DeletePermission("")
ClassMethod DeletePermission(PermisRowid As %String) As %String
{
	s ret="-1"
	q:PermisRowid="" "-2"
	Ts
	s object=##Class(User.PMPPermission).%OpenId(PermisRowid)
	s object.PERSpare2="N"
	s rc=object.%Save()
	if (rc){
	    Tc
	    &sql(update sqluser.PMP_PermisBusiness set PERBus_IsEffect='N' WHERE PMP_Permission_ParRef=:PermisRowid)
    }
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-05-06
/// description: 新增、修改审核流程
/// input:  input(PermisSAddRowid+"^"+PermisSAddFlag+"^"+PermisSAddPerName+"^"+PermisSMustA+"^"+PermisSAddName+"^"+PermisSAddLive+"^"+PermisSAddACT+"^"+PermisSAddUser+"^"+PermisSAddACTT+"^"+PermisSAddType)
/// input(other)    Rowid                操作类型             项目名称          必须审核标识      权限名称            权限级别            审核结果         权限用户         提醒审核标志      审核类型
/// output: String
/// others: w ##class(web.PMP.Common).AddUpdatePermis("6^Add^1^Y^信息科审核^2^95^^^权限审核")
ClassMethod AddUpdatePermis(input As %Text) As %String
{
	;s ^CacheTemp("AddUpdatePermis",$zt($p($h,",",2)))=input
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s userId=%session.Data("LOGON.USERID")
	s IndependentTypeRet=##class(web.PMP.Document).IndependentType(userId)
	i (IndependentUserRet="Y")&(IndependentTypeRet="Y") s userId=userId_"||"_##class(web.PMP.Document).ConvertUser("1","")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	s ret="-1"
	q:input="" "-2"
	s PermisSAddRowid=$p(input,"^",1)
	s PermisSAddFlag=$p(input,"^",2)
	s PermisSAddPerName=$p(input,"^",3)
	s PermisSMustA=$p(input,"^",4)
	s PermisSAddName=$p(input,"^",5)
	s PermisSAddLive=$p(input,"^",6)
	s PermisSAddACT=$p(input,"^",7)
	s PermisSAddUser=$p(input,"^",8)
	s PermisSAddACTT=$p(input,"^",9)
	s PermisSAddType=$p(input,"^",10)
	q:PermisSAddFlag="" "-3"
	q:(PermisSAddRowid="")&(PermisSAddFlag="Update") "-4"
	q:PermisSAddPerName="" "-5"
	q:PermisSMustA="" "-6"
	q:PermisSAddName="" "-7"
	q:(PermisSAddLive="")&(PermisSAddFlag="Update") "-8"
	i PermisSAddFlag="Add" s PermisSAddLive=##Class(web.PMPPermission).getMaxLevel(PermisSAddPerName)
	q:PermisSAddACT="" "-9"
	q:PermisSAddType="" "-10"
	i (PermisSAddType'="")&(PermisSAddType<1) s PermisSAddType=$o(^PMPDictionary(0,"DTY_Desc",PermisSAddType,""))
	d AddUpdatePermission
	q ret
AddUpdatePermission
    Ts
    i PermisSAddFlag="Update" s object=##Class(User.PMPPermission).%OpenId(PermisSAddRowid)
    i PermisSAddFlag="Add" s object=##Class(User.PMPPermission).%New()
    i PermisSAddPerName'=""  d
    .s objectPer=##Class(User.PMPProject).%OpenId(PermisSAddPerName)
    .S object.PERProjectDR=objectPer
    i PermisSAddLive'="" s object.PERLevel=PermisSAddLive
    i PermisSAddACT'="" s object.PERSpare3=PermisSAddACT
    i PermisSAddName'="" s object.PERDesc=PermisSAddName
    i PermisSMustA'="" s object.PERSpare5=PermisSMustA
    s object.PERSpare4=PermisSAddACTT
    i PermisSAddType'=""  d
    .s objectType=##Class(User.PMPDictionary3).%OpenId(PermisSAddType)
    .s object.PERType=objectType
    i PermisSAddFlag="Add"  d
    .s object.PERDate=Date
    .s object.PERTime=Time
    s object.PERBY2=Date
    s object.PERBY3=Time
    s object.PERBY4=userId
	s object.PERSpare2="Y"
	s rc=object.%Save()
	if (rc){
	    Tc
	    i PermisSAddUser'=""  d
	    .i PermisSAddFlag="Add" s result = object.%Id()
	    .i PermisSAddFlag="Update" s result=PermisSAddRowid
	    .&sql(insert into sqluser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time) values (:result,:PermisSAddUser,'Y',:Date,:Time))
    }
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取需求审核类型
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod PerCATtypeStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PerCATtypeStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","IPMDFlag",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-06
/// description: 删除权限明细    
/// input:  InPut 
/// output: String 
/// others: w ##class(web.PMP.Common).DeletePermisDetail("9||1")
ClassMethod DeletePermisDetail(PermisSRowid) As %String
{
	s ret="-1"
	q:PermisSRowid="" "-2"
	Ts
	&sql(update sqluser.PMP_PermisBusiness set PERBus_IsEffect='N' where PERBus_rowid=:PermisSRowid)
	i ($G(SQLCODE)="0")
	{
		Tc
		}
	else
	{
	  Tro	
	}
	s ret=$G(SQLCODE)
	q ret
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取科室类型
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:  
ClassMethod PerDetailLocStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("PerDetailLocStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="0" f  s RowId=$o(^RBC("DEP",RowId)) q:RowId=""  d
 .s Description=$p($G(^RBC("DEP",RowId)),"^",2)
 .;s Description=##class(web.DHCINSUPort).GetCNCODE($tr(Description," "),4,"")_Description
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description 
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-05
/// description: 获取当前权限用户是否存在记录
/// input:  InPut 
/// output: String 
/// others: 
ClassMethod PerLocType(PerDetailAddRowid As %String, PerDetailAddUser As %String, PerDetailLocType As %String) As %String
{
	s ret="-1"
	q:PerDetailAddRowid="" "-2"
	q:PerDetailAddUser="" "-3"
	i PerDetailLocType=""  d
	.i $d(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser))  d
	..s sub=$o(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser,""))
	..q:$p(^PMPPermisBusiness(PerDetailAddRowid,"E",sub),"^",3)'="Y"
	..s ret="1"
	i PerDetailLocType'=""  d
	.i $d(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser))  d
	..s sub="" f  s sub=$o(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser,sub)) q:sub=""  q
	...q:$p(^PMPPermisBusiness(PerDetailAddRowid,"E",sub),"^",3)'="Y"
	...s loctype=$p(^PMPPermisBusiness(PerDetailAddRowid,"E",sub),"^",5)
	...q:loctype'=PerDetailLocType
	...s ret="1"
	q ret
}

/// Creat  zzp
/// date:2015-05-05
/// description:  权限明细更加、修改操作
/// input:  InPut (PerDetailAddRowid+"^"+PerDetailAddFlag+"^"+PerDetailAddUser+"^"+PerDetailLocType)
/// output: String 
/// others: 
ClassMethod AddUpdatePerDetail(input As %Text) As %String
{
	;s ^Temp("AddUpdatePerDetail")=input
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	s locid=%session.Data("LOGON.CTLOCID")
	s Date=+$h,Time=$p($h,",",2)
	s ret="-1"
	q:input="" "-2"
	s PerDetailAddRowid=$p(input,"^",1)
	s PerDetailAddFlag=$p(input,"^",2)
	s PerDetailAddUser=$p(input,"^",3)
	s PerDetailLocType=$p(input,"^",4)
	q:PerDetailAddUser="" "-3"
	i PerDetailAddFlag="Add" d AddPerDetail
	i PerDetailAddFlag="Update"  d UpdatePerDetail
	q ret
AddPerDetail
	i ($d(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser)))&&(PerDetailLocType'="")  d
	.s type=""
	.s sub="" f  s sub=$o(^PMPPermisBusinessi("PERBusUserDr",PerDetailAddRowid,PerDetailAddUser,sub)) q:sub=""  d
	..s flag=$p(^PMPPermisBusiness(PerDetailAddRowid,"E",sub),"^",3)
	..S loctype=$p(^PMPPermisBusiness(PerDetailAddRowid,"E",sub),"^",5)
	..i (flag'="Y")&(PerDetailLocType=loctype)  d
	...&SQL(update sqluser.PMP_PermisBusiness set PERBus_IsEffect="Y" WHERE PMP_Permission_ParRef=:PerDetailAddRowid and PERBus_Childsub=:sub)
	...i $g(SQLCODE)="0" s ret="1"
	...i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
	...s type="1"
	.i type=""  d
	..&sql(insert into sqluser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_IsEffect,PERBus_User_DR,PERBus_Spare1, PERBus_Date, PERBus_Time) values (:PerDetailAddRowid,'Y',:PerDetailAddUser,:PerDetailLocType,:Date,:Time))
	..i $g(SQLCODE)="0" s ret="1"
	..i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
	e  d
	.&sql(insert into sqluser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_IsEffect,PERBus_User_DR,PERBus_Spare1, PERBus_Date, PERBus_Time) values (:PerDetailAddRowid,'Y',:PerDetailAddUser,:PerDetailLocType,:Date,:Time))
	.i $g(SQLCODE)="0" s ret="1"
	.i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
	q ret
UpdatePerDetail	
	s PerRowid=+PerDetailAddRowid
	i ($d(^PMPPermisBusinessi("PERBusUserDr",PerRowid,PerDetailAddUser)))&&(PerDetailLocType'="")  d
	.i '$d(^PMPPermisBusinessi("LocType",PerRowid,PerDetailLocType))  d
	..&sql(update sqluser.PMP_PermisBusiness set PERBus_User_DR=:PerDetailAddUser, PERBus_Spare1=:PerDetailLocType where PERBus_rowid=:PerDetailAddRowid)
	..i $g(SQLCODE)="0" s ret="1"
	..i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
	i '$d(^PMPPermisBusinessi("PERBusUserDr",PerRowid,PerDetailAddUser)) d
	.&sql(update sqluser.PMP_PermisBusiness set PERBus_User_DR=:PerDetailAddUser, PERBus_Spare1=:PerDetailLocType where PERBus_rowid=:PerDetailAddRowid)
	.i $g(SQLCODE)="0" s ret="1"
	.i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
	q ret
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取模块状态
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModeulePerGroupStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeulePerGroupStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s DicRowid="" f  s DicRowid=$o(^PMPDictionary("FLAG","MODEGROUP",DicRowid)) q:DicRowid=""  d
 .s (RowId,Description)=""
 .s Description=$p($G(^PMPDictionary(DicRowid)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(DicRowid)),"^",5)="N"
 .s RowId=DicRowid
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModeulePerContractStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeulePerContractStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="" f  s RowId=$o(^PMPContract(RowId)) q:RowId=""  d
 .s Description=""
 .s Description=$p($G(^PMPContract(RowId)),"^",2)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取产品
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod ModeulePerPCStore(InPut As %Text)
{
 s i=0
 ;s ^CacheTemp("ModeulePerPCStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="" f  s RowId=$o(^PMPProduct(RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPProduct(RowId)),"^",2)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-20
/// description: 获取用户列表Query
/// input:  type()
/// output: 
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","DepartUserStoreNew","")
Query DepartUserStoreNew(InPut As %String) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DepartUserStoreNewExecute(ByRef qHandle As %Binary, InPut As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
    .S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
    .q:Description=""
	.d OutputRow7
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    i IndependentUserRet="Y" d
    .S id="" f  s id=$o(^PMPProjectUser(id)) q:id=""  d
    ..s Description=$p(^PMPProjectUser(id),"^",22)
    ..q:Description=""
    ..s RowId=$p(^PMPProjectUser(id),"^",1)_"||"_id
    ..d OutputRow7
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow7
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-20
/// description: 获取用户列表Query
/// input:  type()
/// output: 
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","PermissionUserStoreNew","")
Query PermissionUserStoreNew(InPut As %String) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PermissionUserStoreNewExecute(ByRef qHandle As %Binary, InPut As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
    .S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
    .q:Description=""
	.d OutputRow27
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    i IndependentUserRet="Y" d
    .S id="" f  s id=$o(^PMPProjectUser(id)) q:id=""  d
    ..s Description=$p(^PMPProjectUser(id),"^",22)
    ..q:Description=""
    ..s RowId=$p(^PMPProjectUser(id),"^",1)_"||"_id
    ..d OutputRow27
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow27
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-20
/// description: 获取用户列表Query
/// input:  type()
/// output: 
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","ProjectUserStoreNew","")
Query ProjectUserStoreNew(InPut As %String) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod ProjectUserStoreNewExecute(ByRef qHandle As %Binary, InPut As %String) As %Status
{
	
	s IndependentUserRet=##Class(web.PMP.Document).IndependentUser()
	s CommonUserRet=##Class(web.PMP.Document).CommonUser()
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i IndependentUserRet'="Y"  d 
    .S RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
    ..S Description=$P($g(^SSU("SSUSR",RowId)),"^",2)
    ..q:Description=""
	..d OutputRow17
	i IndependentUserRet="Y"  d
	.f id=1:1:$l(CommonUserRet,",")  d
	..s RowId=$p(CommonUserRet,",",id)
	..i $d(^SSU("SSUSR",RowId)) d
	...s Description=##class(web.PMP.Document).SSUSER(RowId)
	...d OutputRow17
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow17
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-28
/// description: 获取系统配置数据(替换原来的SysGridStore方法)
/// input:  InPut1 As %Text,SysMenu As %Text,SysText As %Text
/// output: String SysGridRowid_"^"_SysGridCode_"^"_SysGridDesc_"^"_SysGridText_"^"_SysGridStdate_"^"_SysGridEndate
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","SysGridStorequery","","","")
Query SysGridStorequery(InPut1 As %Text, SysMenu As %Text, SysText As %Text) As websys.Query(ROWSPEC = "SysGridRowid:%String,SysGridCode:%String,SysGridDesc:%String,SysGridText:%String,SysGridStdate:%String,SysGridEndate:%String")
{
}

ClassMethod SysGridStorequeryExecute(ByRef qHandle As %Binary, InPut1 As %Text, SysMenu As %Text, SysText As %Text) As %Status
{
    ;s ^Temp("SysGridStorequery")=InPut1_"^"_SysMenu_"^"_SysText
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s type=$p(InPut1,"^",1)
    i type'="" s type=$$ALPHAUP^SSUTIL4(type)
    s stdate=$p(InPut1,"^",2)
    s endate=$p(InPut1,"^",3)
    i stdate'="" s stdate=$zdh(stdate,3)
    i endate'="" s endate=$zdh(endate,3)
    s (SysGridRowid,SysGridCode,SysGridDesc,SysGridText,SysGridStdate,SysGridEndate)=""
    s SysRowid="" f  s SysRowid=$o(^PMPSysConfigure(0,SysRowid)) q:SysRowid=""  d
    .s SysGridCode=$p(^PMPSysConfigure(0,SysRowid),"^",1)
    .q:SysGridCode=""
    .s SysGridRowid=SysRowid
    .s SysGridDesc=$p(^PMPSysConfigure(0,SysRowid),"^",2)
    .s SysGridText=$p(^PMPSysConfigure(0,SysRowid),"^",3)
    .s SysGridStdate=$p(^PMPSysConfigure(0,SysRowid),"^",4)
    .q:(stdate'="")&(SysGridStdate<stdate)
    .i SysGridStdate'="" s SysGridStdate=$zd(SysGridStdate,3)
    .s SysGridEndate=$p(^PMPSysConfigure(0,SysRowid),"^",5)
    .q:(endate'="")&(SysGridEndate>endate)
    .i SysGridEndate'="" s SysGridEndate=$zd(SysGridEndate,3)
    .q:(type'="")&($$ALPHAUP^SSUTIL4(SysGridCode)'[type)
    .q:(SysMenu'="")&(SysGridDesc'[SysMenu)
    .q:(SysText'="")&(SysGridText'[SysText)
    .d OutputRow8
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow8
    s Data=$lb(SysGridRowid,SysGridCode,SysGridDesc,SysGridText,SysGridStdate,SysGridEndate)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-28
/// description: 获取联系方式数据(替换原来的TelGridStore方法)
/// input:  InPut As %Text   TelText+"^"+TelLoc+"^"+TelUser+"^"+TelEmail
/// output: String TelGridRowid_"^"_TelGridName_"^"_TelGridLoc_"^"_TelGridTel_"^"_TelGridEmail_"^"_TelGridbz
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","TelGridStoreQuery","^^^^")
Query TelGridStoreQuery(InPut As %Text) As websys.Query(ROWSPEC = "TelGridRowid:%String,TelGridName:%String,TelGridLoc:%String,TelGridTel:%String,TelGridEmail:%String,TelGridbz:%String")
{
}

ClassMethod TelGridStoreQueryExecute(ByRef qHandle As %Binary, InPut As %Text) As %Status
{
	;s ^Temp("TelGridStoreQuery")=InPut
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s tel=$p(InPut,"^",1)
    s TelLoc=$p(InPut,"^",2)
    s TelUser=$p(InPut,"^",3)
    s TelEmail=$p(InPut,"^",4)
    i tel'="" s tel=$$ALPHAUP^SSUTIL4($tr(tel," "))
    i TelLoc'="" s TelLoc=$$ALPHAUP^SSUTIL4($tr(TelLoc," "))
    i TelUser'="" s TelUser=$$ALPHAUP^SSUTIL4($tr(TelUser," "))
    i TelEmail'="" s TelEmail=$$ALPHAUP^SSUTIL4($tr(TelEmail," "))
    s TelRowid="" f  s TelRowid=$o(^PMPUserTel(TelRowid)) q:TelRowid=""  d
    .s (TelGridRowid,TelGridName,TelGridLoc,TelGridTel,TelGridEmail,TelGridbz)=""
    .s userid=$p(^PMPUserTel(TelRowid),"^",1)
    .i userid'="" s TelGridName=##class(web.PMP.Document).SSUSER(userid)
    .q:userid=""
    .s TelGridRowid=TelRowid
    .s locid=$p(^PMPUserTel(TelRowid),"^",7)
    .i locid'="" s TelGridLoc=$p(^CTLOC(locid),"^",2)
    .s TelGridTel=$p(^PMPUserTel(TelRowid),"^",2)
    .s TelGridEmail=$p(^PMPUserTel(TelRowid),"^",8)
    .s TelGridbz=$p(^PMPUserTel(TelRowid),"^",4)
    .s ProjectUser=$p(^PMPUserTel(TelRowid),"^",10)
    .i ProjectUser'="" s ProjectUsername=$p(^PMPProjectUser(ProjectUser),"^",22)
    .s user=##class(web.DHCINSUPort).GetCNCODE(TelGridName,4,"")_##class(web.DHCINSUPort).GetCNCODE(TelGridName,3,"")_TelGridName
    .i $g(ProjectUsername)'="" s user=$g(user)_##class(web.DHCINSUPort).GetCNCODE(ProjectUsername,4,"")_##class(web.DHCINSUPort).GetCNCODE(ProjectUsername,3,"")_ProjectUsername
    .i $g(ProjectUsername)'="" s TelGridName=ProjectUsername
    .q:(tel'="")&(TelGridTel'[tel)
    .q:(TelLoc'="")&(TelGridLoc'[TelLoc)
    .q:(TelUser'="")&(user'[TelUser)
    .q:(TelEmail'="")&($$ALPHAUP^SSUTIL4(TelGridEmail)'[TelEmail)
	.d OutputRow9
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow9
    s Data=$lb(TelGridRowid,TelGridName,TelGridLoc,TelGridTel,TelGridEmail,TelGridbz)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-28
/// description: 获取模块数据(替换原来的ModeuleGridStore方法)
/// input:  InPut   ModeuleName+"^"+ModeuleStandby1+"^"+ModeuleCode+"^"+ModeuleStatus;
/// output: String ModeuleGridRowid_"^"_ModeuleGridName_"^"_ModeuleGridCode_"^"_ModeuleGridStandby1_"^"_ModeuleGridProduct_"^"_ModeuleGridStandby2_"^"_ModeuleGridProduct1_"^"_ModeuleGridStatus_"^"_ModeuleGridPlanDate_"^"_ModeuleGridActuclDate_"^"_ModeuleGridRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Common","ModeuleGridStoreQuery","^2.5^^")
Query ModeuleGridStoreQuery(InPut As %Text) As websys.Query(ROWSPEC = "ModeuleGridRowid:%String,ModeuleGridName:%String,ModeuleGridCode:%String,ModeuleGridCP:%String,ModeuleGridCPid:%String,ModeuleGridContract:%String,ModeuleGridContractid:%String,ModeuleGridGroup:%String,ModeuleGridGroupid:%String,ModeuleGridStandby1:%String,ModeuleGridProduct:%String,ModeuleGridStandby2:%String,ModeuleGridProduct1:%String,ModeuleGridStatus:%String,ModeuleGridPlanDate:%String,ModeuleGridActuclDate:%String,ModeuleGridRemark:%String,ModeuleGridImpro:%String")
{
}

ClassMethod ModeuleGridStoreQueryExecute(ByRef qHandle As %Binary, InPut As %Text) As %Status
{
	;s ^Temp("ModeuleGridStoreQuery",$h)=InPut
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s ModeuleName=$p(InPut,"^",1)
    S ModeuleStandby1=$P(InPut,"^",2)
    S ModeuleCode=$P(InPut,"^",3)
    S ModeuleStatus=$P(InPut,"^",4)
    i ModeuleStandby1'="" s ModeuleStandby1=$tr(ModeuleStandby1,".")
    I ModeuleName'="" S ModeuleName=##class(web.DHCINSUPort).GetCNCODE($$ALPHAUP^SSUTIL4(ModeuleName),4,"")
    I ModeuleStandby1'="" S ModeuleStandby1=##class(web.DHCINSUPort).GetCNCODE($$ALPHAUP^SSUTIL4(ModeuleStandby1),4,"")
    I ModeuleCode'="" S ModeuleCode=$$ALPHAUP^SSUTIL4(ModeuleCode)
    s MoudleId="0" f  s MoudleId = $o(^PMPModule(MoudleId))  q:MoudleId=""   d
    .s (ModeuleGridRowid,ModeuleGridName,ModeuleGridCode,ModeuleGridStandby1,ModeuleGridProduct,ModeuleGridStandby2,ModeuleGridProduct1,ModeuleGridStatus,ModeuleGridPlanDate,ModeuleGridActuclDate,ModeuleGridRemark,ModeuleGridCP,ModeuleGridCPid,ModeuleGridContract,ModeuleGridContractid,ModeuleGridGroup,ModeuleGridGroupid,ModeuleGridImpro)=""
    .s ModeuleGridCode=$p(^PMPModule(MoudleId),"^",1) ;模块编码Code
    .q:ModeuleGridCode=""
    .s ModeuleGridName=$p(^PMPModule(MoudleId),"^",2) ;模块描述
    .s ModeuleGridActuclDate=$p(^PMPModule(MoudleId),"^",4)    ;实际上线日期9	MODE_ActuclDate
    .i ModeuleGridActuclDate'="" s ModeuleGridActuclDate=$zd(ModeuleGridActuclDate,3)
    .s ModeuleGridPlanDate=$p(^PMPModule(MoudleId),"^",6) ;计划上线日期MODE_PlanDate
    .i ModeuleGridPlanDate'="" s ModeuleGridPlanDate=$zd(ModeuleGridPlanDate,3)
    .s tProductDR=$p(^PMPModule(MoudleId),"^",7) ;产品组MODE_Product_DR
    .I tProductDR'="" S ModeuleGridProduct=$P(^PMPDictionary(tProductDR),"^",2)
    .s ModeuleGridStandby2=$p(^PMPModule(MoudleId),"^",17) ;产品组负责人MODE_Standby2
    .s ModeuleGridStandby1=$p(^PMPModule(MoudleId),"^",16) ;版本号MODE_Standby1
    .s ModeuleGridRemark=$p(^PMPModule(MoudleId),"^",8) ;备注MODE_Remark
    .s tProNameid=$p(^PMPModule(MoudleId),"^",9) ;项目指针MODE_Project1_DR
    .i tProNameid'="" s ModeuleGridProduct1=$p(^PMPProject(tProNameid),"^",2)
    .s tStatusid=$p(^PMPModule(MoudleId),"^",10) ;项目状态MODE_Status_DR
    .I tStatusid'="" s ModeuleGridStatus=$p(^PMPDictionary(tStatusid),"^",2)
    .s ModeuleGridRowid=MoudleId
    .q:(ModeuleName'="")&(##class(web.DHCINSUPort).GetCNCODE(ModeuleGridName,4,"")'[ModeuleName)
    .q:(ModeuleCode'="")&($$ALPHAUP^SSUTIL4(ModeuleGridCode)'[ModeuleCode)
    .s ModeuleStandby1desc=$tr(ModeuleGridStandby1,".")
    .q:(ModeuleStandby1'="")&&($g(ModeuleStandby1desc)'[ModeuleStandby1)
    .q:(ModeuleStatus'="")&(tStatusid'=ModeuleStatus)
    .s ModeuleGridCPid=$p(^PMPModule(MoudleId),"^",18)
    .i (ModeuleGridCPid'="")&&($D(^PMPProduct(ModeuleGridCPid))) s ModeuleGridCP=$p(^PMPProduct(ModeuleGridCPid),"^",2)
    .s ModeuleGridContractid=$p(^PMPModule(MoudleId),"^",25)
    .i (ModeuleGridContractid'="")&&($D(^PMPContract(ModeuleGridContractid))) s ModeuleGridContract=$p(^PMPContract(ModeuleGridContractid),"^",2)
    .s ModeuleGridGroupid=$p(^PMPModule(MoudleId),"^",26)
    .i ModeuleGridGroupid'="" s ModeuleGridGroup=$p(^PMPDictionary(ModeuleGridGroupid),"^",2)
    .i $d(^PMPImprovementListi("Module",MoudleId))  s ModeuleGridImpro="Y"
	.d OutputRow10
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow10
    s Data=$lb(ModeuleGridRowid,ModeuleGridName,ModeuleGridCode,ModeuleGridCP,ModeuleGridCPid,ModeuleGridContract,ModeuleGridContractid,ModeuleGridGroup,ModeuleGridGroupid,ModeuleGridStandby1,ModeuleGridProduct,ModeuleGridStandby2,ModeuleGridProduct1,ModeuleGridStatus,ModeuleGridPlanDate,ModeuleGridActuclDate,ModeuleGridRemark,ModeuleGridImpro)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-04-01
/// description: 获取工作记录数据(替换原来的ObStore方法)
/// input:  type()
/// output: 
///  title^forumtitle^forumid^author^ObRowid^ObDate^lastposter^ObMenu^ObSolution
/// others:  d ##class(%ResultSet).RunQuery("web.PMP.Common","ObStoreQuery","","","")
Query ObStoreQuery(InPut As %Text, type As %Text = "", menu As %Text = "") As websys.Query(ROWSPEC = "title:%String,forumtitle:%String,forumid:%String,author:%String,ObRowid:%String,ObDate:%String,lastposter:%String,ObMenu:%String,ObSolution:%String,glipml:%String,gluser:%String")
{
}

ClassMethod ObStoreQueryExecute(ByRef qHandle As %Binary, InPut As %Text, type As %Text = "", menu As %Text = "") As %Status
{
	;s ^Temp("ObStoreQuery",$h)=InPut
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
	i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
    i InPut'="" S InPut=$tr(InPut," ","")
    i InPut'=""  d
    .s id=0 f  s id=$o(^PMPJobLogi("JLG_User",InPut,id)) q:id=""  d
    ..s ObRowid="",ObDate="",ObMenu="",ObDate1="",ObDate2="",ObSolution="",glipml="",gluser=""
    ..s ObMenu=$p($G(^PMPJobLogging(id)),"^",3)
    ..q:ObMenu=""
    ..s ObRowid=id
    ..s ObDate1=$p($G(^PMPJobLogging(id)),"^",2)
    ..s ObDate2=$p($G(^PMPJobLogging(id)),"^",14)
    ..i ObDate1'="" s ObDate1=$zd(ObDate1,3)
    ..i ObDate2'="" s ObDate2=$zt(ObDate2)
    ..s author=##class(web.PMP.Document).SSUSER(InPut)
    ..s title=$p($G(^PMPJobLogging(id)),"^",1)
    ..s ObDate=ObDate1_" "_ObDate2 ;"1305856996"
    ..s forumtitle=$p($G(^PMPJobLogging(id)),"^",9)
    ..i forumtitle="" s forumtitle="暂无标签"
    ..s forumid="14"
    ..s lastposter=author
    ..s ObSolution=$p($G(^PMPJobLogging(id)),"^",7)
    ..S glipml=$p($G(^PMPJobLogging(id)),"^",21)
    ..S gluser=$p($G(^PMPJobLogging(id)),"^",27)
    ..;q:(type="MainTitle")&(title'[menu)
    ..d OutputRow11
    i InPut=""  d
    .s id=0 f  s id=$o(^PMPJobLogging(id)) q:id=""  d
    ..s ObRowid="",ObDate="",ObMenu="",ObDate1="",ObDate2="",ObSolution="",nr="",author1="",author12="",glipml="",gluser=""
    ..s ObMenu=$p($G(^PMPJobLogging(id)),"^",3)
    ..q:ObMenu=""
    ..s ObRowid=id
    ..s ObDate1=$p($G(^PMPJobLogging(id)),"^",2)
    ..s ObDate2=$p($G(^PMPJobLogging(id)),"^",14)
    ..i ObDate1'="" s ObDate1=$zd(ObDate1,3)
    ..i ObDate2'="" s ObDate2=$zt(ObDate2)
    ..s useridd=$p($G(^PMPJobLogging(id)),"^",15)
    ..i useridd'=""  D
    ...s author=##Class(web.PMP.Document).SSUSER(useridd)
    ...s author1=##Class(web.PMP.Document).SSUSER1(useridd)
    ..s author12=author1_author
    ..s title=$p($G(^PMPJobLogging(id)),"^",1)
    ..s ObDate=ObDate1_" "_ObDate2 ;"1305856996"
    ..s forumtitle=$p($G(^PMPJobLogging(id)),"^",9)
    ..i forumtitle="" s forumtitle="暂无标签"
    ..s forumid="14"
    ..s lastposter=author
    ..s ObSolution=$p($G(^PMPJobLogging(id)),"^",7)
    ..s nr=ObSolution_ObMenu
    ..q:(type="MainTitle")&(title'[menu)&(menu'="")
    ..q:(type="Title")&(forumtitle'[menu)&(menu'="")
    ..q:(type="Date")&(ObDate'[menu)&(menu'="")
    ..q:(type="Menu")&(nr'[menu)&(menu'="")
    ..q:(type="User")&(author12'[menu)&(menu'="")
    ..S glipml=$p($G(^PMPJobLogging(id)),"^",21)
    ..S gluser=$p($G(^PMPJobLogging(id)),"^",27)
    ..;q:(type="WorkType")&(author12'[menu)&(menu'="")
	..d OutputRow11
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow11
    s Data=$lb(title,forumtitle,forumid,author,ObRowid,ObDate,lastposter,ObMenu,ObSolution,glipml,gluser)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-06-23
/// description: 获取登录用户所关联的工程师
/// input:  InPut 
/// output: String RowId_"^"_Description
/// others:
ClassMethod NewUserStore(InPut As %String) As %String
{
 s i=0
 s userid=%session.Data("LOGON.USERID")
 ;s ^CacheTemp("NewUserStore",$zt($p($h,",",2)))=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="" f  s RowId=$o(^PMPProjectUseri("SSUSER",userid,RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPProjectUser(RowId)),"^",22)
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

Storage Default
{
<Data name="CommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.CommonD</DataLocation>
<DefaultData>CommonDefaultData</DefaultData>
<IdLocation>^web.PMP.CommonD</IdLocation>
<IndexLocation>^web.PMP.CommonI</IndexLocation>
<StreamLocation>^web.PMP.CommonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
