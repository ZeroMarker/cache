Class web.PMP.Ztgndz Extends %Persistent
{

Query Ztgnydzsj() As %Query(ROWSPEC = "Txh:%String,Tzt:%String,Tan:%String,Tjm:%String")
{
}

//张枕平  2015-01-14

//根据条件查询已对照的数据

//d ##class(%ResultSet).RunQuery("web.PMP.Ztgndz","Ztgnydzsj")

ClassMethod ZtgnydzsjExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s (Tzt,Tan,Tjm)=""
	s Txh=0
	S SBrowid="" f  s SBrowid=$o(^PMPStatusButton(SBrowid)) q:SBrowid=""   d
	.s (Tzt,Tan,Tjm)=""
	.s sbtype=$p(^PMPStatusButton(SBrowid),"^",3)
	.q:sbtype'="Y"
	.s SBStatus=$p(^PMPStatusButton(SBrowid),"^",1)
	.s SBbutton=$p(^PMPStatusButton(SBrowid),"^",2)
	.i SBStatus'="" s Tzt=$P(^PMPDictionary(SBStatus),"^",2)
	.i SBbutton'="" s Tan=..gnzh(SBbutton)
	.s SBBy1=$p(^PMPStatusButton(SBrowid),"^",7)
	.b ;22
	.i SBBy1'="" s Tjm=..jmlb(SBBy1)
	.s Txh=Txh+1
	.D OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1      
	set Data=$lb(Txh,Tzt,Tan,Tjm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ZtgnydzsjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZtgnydzsjExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ZtgnydzsjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZtgnydzsjExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod gnzh(input As %String) As %String
{
	s ret=""
	q:input="" ret
	i input="TONGYI" s ret="同意改进"
	i input="BUTONGYI" s ret="无需改进"
	i input="XQZhiPaiRenYuan" s ret="指派人员"
	i input="XQUpdate" s ret="更改需求"
	i input="Create" s ret="需求申请"
	i input="CRUpdate" s ret="重置需求"
	i input="CRdelete" s ret="删除需求"
	i input="CRTijiaoshenqing" s ret="提交申请"
	i input="YZceshitongguo" s ret="测试通过"
	i input="YZceshibutongguo" s ret="回执处理"
	i input="XGtongyi" s ret="同意修改"
	i input="XGbutongyi" s ret="拒绝修改"
	q ret
}

ClassMethod jmlb(input As %String) As %String
{
	s re=""
	q:input="" ret
	i input="PMPImprovementFindByHospital" s ret="审核界面"
	i input="PMPImprovementListNew" s ret="需求申请界面"
	q ret
}

//s aa=##Class(web.PMP.Ztgndz).SelectStatus()

//张枕平 20150114  获取需求状态字典列表

ClassMethod SelectStatus() As %String
{
	s ret=""
	s DTYRowid="" F  S DTYRowid=$O(^PMPDictionary(DTYRowid)) Q:DTYRowid=""  d
	.q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
	.S DTYStandby1=$p(^PMPDictionary(DTYRowid),"^",5)
	.Q:DTYStandby1'="Y"
	.s DTYFlag=$P(^PMPDictionary(DTYRowid),"^",3)
	.q:DTYFlag'="Improvement"
	.s DTYdesc=$P(^PMPDictionary(DTYRowid),"^",2)
	.q:DTYdesc=""
	.s str=DTYdesc_"^"_DTYRowid
	.i ret'="" s ret=ret_","_str
	.i ret="" s ret=str
	q ret
}

ClassMethod insertsjdz(DZzt As %String, DZan As %String, userId As %String, DZjm As %String) As %String
{
	s ret="0"
	s insertdate=+$H
	s inserttime=$p($h,",",2)
	q:(DZzt="")||(DZan="")||(userId="")||(DZjm="") ret="3"
	s type=0
	s sbbutton="" f  s sbbutton=$o(^PMPStatusButtoni("SB_Button",DZan,sbbutton)) q:sbbutton=""  d
	.s sbstatus=$p(^PMPStatusButton(sbbutton),"^",1)
	.s sbtype=$p(^PMPStatusButton(sbbutton),"^",3)
	.i (sbstatus=DZzt)&(sbtype="Y")  s type="1"
	.i (sbstatus=DZzt)&(sbtype="N")  s type="2"_"^"_sbbutton
	q:(DZzt'="")&(DZan'="")&(type="1") ret="2"
	i type["2"  d
	.s rowid=$p(type,"^",2)
	.s obj=##Class(User.PMPStatusButto).%OpenId(rowid)
	.s obj.SBDate=insertdate
	.s obj.SBTime=inserttime
	.s obj.SBType="Y"
	.s obj.SBBy1=DZjm
	.s obj3=##Class(User.SSUser).%OpenId(userId)
	.S obj.SBUser=obj3
	.s ret=obj.%Save()
	i type="0"  d
	.s obj1=##Class(User.PMPStatusButto).%New()
	.s obj1.SBButton=DZan
	.s obj2=##Class(User.PMPDictionary3).%OpenId(DZzt)
	.s obj1.SBStatus=obj2
	.s obj1.SBDate=insertdate
	.s obj1.SBTime=inserttime
	.S obj1.SBBy1=DZjm
	.s obj1.SBType="Y"
	.s obj4=##Class(User.SSUser).%OpenId(userId)
	.S obj1.SBUser=obj4
	.s ret=obj1.%Save()
	q ret
}

ClassMethod deletesjdz(DZzt As %String, DZan As %String, userId As %String, DZjm As %String) As %String
{
	s ^zhm("delete")=DZzt_","_DZan_","_userId_","_DZjm
	s ret="0"
	s insertdate=+$H
	s inserttime=$p($h,",",2)
	q:(DZzt="")||(DZan="")||(userId="") ret="3"
	s sbbutton=""
	f  s sbbutton=$o(^PMPStatusButtoni("SB_Button",DZan,sbbutton)) q:sbbutton=""  d	
	.b ;0000
	.s SBStatus=$p(^PMPStatusButton(sbbutton),"^",1)
	.b ;00
	.q:SBStatus'=DZzt 
	.b ;1
	.s SBBy1=$p(^PMPStatusButton(sbbutton),"^",7)
	.q:SBBy1'=DZjm
	.s obj=##Class(User.PMPStatusButto).%OpenId(sbbutton)
	.s obj.SBDate=insertdate
	.s obj.SBTime=inserttime
	.S obj.SBBy1=DZjm
	.s obj.SBType="N"
	.b ;3
	.s obj3=##Class(User.SSUser).%OpenId(userId)
	.S obj.SBUser=obj3
	.s ret=obj.%Save()
	b ;end
	q ret
}

//s aa=##Class(web.PMP.Ztgndz).SelectTypegn("91","PMPImprovementListNew")

//入参：需求状态ID，当前界面的组件名称

//张枕平 20150114  获取当前选中的需求的可用按钮

//返回可用按钮的name串，用^区分

ClassMethod SelectTypegn(zt As %String, jm As %String) As %String
{
	s ret="" 
	q:(zt="")||(jm="") ret
	s sbbutton="" f  s sbbutton=$o(^PMPStatusButtoni("SB_Status",zt,sbbutton)) q:sbbutton=""  d
	.s type=$p(^PMPStatusButton(sbbutton),"^",3)
	.q:type'="Y"
	.s SBby1=$p(^PMPStatusButton(sbbutton),"^",7)
	.q:SBby1'=jm
	.s SBButton=$p(^PMPStatusButton(sbbutton),"^",2)
	.i ret'="" s ret=ret_"^"_SBButton
	.i ret="" s ret=SBButton
	q ret
}

//modify by baoshi产品组有【测试】 原写法直接返回第一个id了,修改只返回需求状态id

//w ##Class(web.PMP.Ztgndz).SelectStatusid("测试")

ClassMethod SelectStatusid(Input As %String) As %String
{
	
	q:Input="" ret
	s id=""
	f  s id=$o(^PMPDictionary(0,"DTY_Desc",Input,id)) Q:(id="")  d
	.s flag=$p(^PMPDictionary(id),"^",3)
	.Q:flag'="Improvement"
	.s ret=id
	q ret
}

//

//w ##Class(web.PMP.Ztgndz).SelectMDStatus("")

/// 返回模块状态
ClassMethod SelectMDStatus(Input As %String) As %String
{
	
	s ret=""
	s DTYRowid="" F  S DTYRowid=$O(^PMPDictionary(DTYRowid)) Q:DTYRowid=""  d
	.q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
	.S DTYStandby1=$p(^PMPDictionary(DTYRowid),"^",5)
	.Q:DTYStandby1'="Y"
	.s DTYFlag=$P(^PMPDictionary(DTYRowid),"^",3)
	.q:DTYFlag'="Status"
	.s DTYdesc=$P(^PMPDictionary(DTYRowid),"^",2)
	.q:DTYdesc=""
	.s str=DTYdesc_"^"_DTYRowid
	.i ret'="" s ret=ret_","_str
	.i ret="" s ret=str
	q ret
}

//w ##Class(web.PMP.Ztgndz).ProductDR("临床科研数据管理")

ClassMethod ProductDR(Input As %String) As %String
{
	
	q:Input="" ret
	s id=""
	f  s id=$o(^PMPDictionary(0,"DTY_Desc",Input,id)) Q:(id="")  d
	.s flag=$p(^PMPDictionary(id),"^",3)
	.Q:flag'="Product"
	.s ret=id
	q ret
}

//w ##Class(web.PMP.Ztgndz).ProName("长春市儿童医院")

ClassMethod ProName(Input As %String) As %String
{
	
	q:Input="" ret
	s id=""
	f  s id=$o(^PMPProject(id)) Q:(id="")  d
	.s desc=$p(^PMPProject(id),"^",2)
	.q:desc'=Input
	.s ret=id
	q ret
}

Storage Default
{
<Data name="ZtgndzDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.ZtgndzD</DataLocation>
<DefaultData>ZtgndzDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.ZtgndzD</IdLocation>
<IndexLocation>^web.PMP.ZtgndzI</IndexLocation>
<StreamLocation>^web.PMP.ZtgndzS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
