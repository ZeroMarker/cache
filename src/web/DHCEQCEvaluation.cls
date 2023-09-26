Class web.DHCEQCEvaluation Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by GBX  2015-03-21 GBX0035
Query Evaluation(EquipTypeDR As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TRole:%String,THospital:%String,TEquipType:%String,TEvaluationFlag:%String,TCheckClass:%String,TEvaluationOrder:%String,TMPEvaluationFlag:%String,TIndependentFlag:%String,TRow:%String")
{
}

ClassMethod EvaluationExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", HospitalDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s TRow=1
	s rowid=0
	f  s rowid=$o(^DHCEQCEvaluation(rowid)) quit:rowid=""  d
	.d ResetVariablesGetEvaluation
	.s TRowID=rowid
	.s TInvalidFlag=$p(^DHCEQCEvaluation(rowid),"^",15)
	.q:TInvalidFlag="Y"
	.s TSourceTypeDR=$p(^DHCEQCEvaluation(rowid),"^",1)
	.i TSourceTypeDR'="" s TSourceType=##class(web.DHCEQFind).GetBussTypeDesc(TSourceTypeDR)
	.s TRoleDR=$p(^DHCEQCEvaluation(rowid),"^",2)
	.i TRoleDR'="" Set TRole=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",TRoleDR)),"^",2)
	.s THospitalDR=$p(^DHCEQCEvaluation(rowid),"^",3)
	.i THospitalDR'="" s THospital=$P($g(^CT("HOSP",THospitalDR)),"^",2)
	.s TEquipTypeDR=$p(^DHCEQCEvaluation(rowid),"^",4)
	.i TEquipTypeDR'="" s TEquipType=$P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	.s TEvaluationFlag=$p(^DHCEQCEvaluation(rowid),"^",5)
	.;q:TEvaluationFlag="N"  //  263574  Add by BRB 2016-09-26
	.s TCheckClass=..CheckClassDetail($p(^DHCEQCEvaluation(rowid),"^",6))
	.s TEvaluationOrder=$p(^DHCEQCEvaluation(rowid),"^",7)
	.s TMPEvaluationFlag=$p(^DHCEQCEvaluation(rowid),"^",8)
	.s TIndependentFlag=$p(^DHCEQCEvaluation(rowid),"^",9)
	.d OutputRowGetEvaluation
	Quit $$$OK
OutputRowGetEvaluation
	s Data=$lb(TRowID,TSourceType,TRole,THospital,TEquipType,TEvaluationFlag,TCheckClass,TEvaluationOrder,TMPEvaluationFlag,TIndependentFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEvaluation
	s (TRowID,TSourceType,TRole,THospital,TEquipType,TEvaluationFlag,TCheckClass,TEvaluationOrder,TMPEvaluationFlag,TIndependentFlag)=""
	quit
}

ClassMethod EvaluationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluationExecute ]
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

ClassMethod EvaluationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by GBX  2015-03-21 GBX0035
/// d ##class(%ResultSet).RunQuery("web.DHCEQCEvaluation","EvaluationList","","")
Query EvaluationList(EvaluateTypeDR As %String = "", EvaluateGroupDR As %String = "", EvaluationDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEvaluateType:%String,TItemScore:%String,TEvaluateGroup:%String,TShowOrder:%String,TRow:%String")
{
}

ClassMethod EvaluationListExecute(ByRef qHandle As %Binary, EvaluateTypeDR As %String = "", EvaluateGroupDR As %String = "", EvaluationDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set TRow=0
 	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCEvaluationList(rowid)) quit:rowid=""  d
	.d ResetVariablesGetEvaluationList
	.s TRowID=rowid
	.s TEvaluationDR=$p($g(^DHCEQCEvaluationList(rowid)),"^",1)
	.q:(EvaluationDR'="")&(EvaluationDR'=TEvaluationDR)
	.s TEvaluateTypeDR=$p($g(^DHCEQCEvaluationList(rowid)),"^",2)
	.i TEvaluateTypeDR'="" s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
	.s TItemScore=$p($g(^DHCEQCEvaluationList(rowid)),"^",3)
	.s TEvaluateGroupDR=$p($g(^DHCEQCEvaluationList(rowid)),"^",4)
	.i TEvaluateGroupDR'="" s TEvaluateGroup=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",TEvaluateGroupDR)),"^",2)
	.s TShowOrder=$p($g(^DHCEQCEvaluationList(rowid)),"^",5)
	.d OutputRowGetEvaluationList
	Quit $$$OK
OutputRowGetEvaluationList
	Set TRow=TRow+1
	Set Data=$lb(TRowID,TEvaluateType,TItemScore,TEvaluateGroup,TShowOrder,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEvaluationList
	Set (TRowID,TEvaluateType,TItemScore,TEvaluateGroup,TShowOrder)=""
	quit
}

ClassMethod EvaluationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluationListExecute ]
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

ClassMethod EvaluationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluationListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// d ##Class(web.DHCEQCEvaluation).SaveData("^32^4^13^8^true^^^true^true^^^^^","0")
/// d ##Class(web.DHCEQCEvaluation).SaveData("2","1")
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=##Class(web.DHCEQCommon).TransValueToPage($p(val,"^",6),"bool")
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"bool")
	s PLIST(10)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"bool")
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	s PLIST(14)=$p(val,"^",14)
	s PLIST(15)=$p(val,"^",15)
	s PLIST(16)="N"
	s SourceType=$p(val,"^",2)
	s RoleDR=$p(val,"^",3)
	s HospitalDR=$p(val,"^",4)
	s EquipTypeDR=$p(val,"^",5)
	s Order=$p(val,"^",8)
	s SQLCODE=0
	i (+isDel=1)
	{
		&SQL(update sqluser.DHC_EQCEvaluation set  E_InvalidFlag='Y' where E_RowID = :rowid) //modified by HHM 20150906 HHM0014 ;删除时置无效
		;&SQL(delete from sqluser.DHC_EQCEvaluation where E_RowID = :rowid)
		if SQLCODE q SQLCODE

		q rowid
	} 
	//modified by HHM 20150907 HHM0014
	//修改，控制输入条件
	//条件：业务类型、角色、医院 、类组控制输入唯一
	s EFind=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,SourceType,+EquipTypeDR,RoleDR,0))
	;s EFindN=$o(^DHCEQCEvaluation(0,"Evaluation","N",+HospitalDR,SourceType,+EquipTypeDR,RoleDR,0))
	;i ((EFind="")&(EFindN'="")) s EFind=EFindN
	i (EFind'="")&(EFind'=rowid) q -1001  ;数据有重复,不能保存！
	i rowid=""
	{	
		s PLIST(10)="Y"
		&SQL(Insert Into sqluser.DHC_EQCEvaluation Values :PLIST())		
	} 
	else
	{
		
		&SQL(Update sqluser.DHC_EQCEvaluation Values :PLIST() where E_RowID=:rowid)		
	}
	if SQLCODE q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod CheckClassList(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add by kdf 2018-10-17
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;w "<option value=></option>"
	;w "<option value=0>"_..CheckClassDetail(0)_"</option>"
	w "<option value=1>"_..CheckClassDetail(1)_"</option>"
	w "<option value=2>"_..CheckClassDetail(2)_"</option>"
	;w "<option value=3>"_..GetInStockStatus(3)_"</option>"
	w "</select>",!
}

ClassMethod CheckClassDetail(num)
{
	q $CASE(num,"1":"查看全部","2":"查看自己和低权限","":"未定义")
}

ClassMethod GetEvaluationByID(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCEvaluation(rowid)
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##class(web.DHCEQFind).GetBussTypeDesc($p(result,"^",1))
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$P($g(^CT("HOSP",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$P(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",4)),"^",2)
	q rowid_"^"_result_"^"_resultex
}

/// add by GBX 2015-03-24 09:33:02
/// desc:获取评价类型  GBX0035
Query EvaluateType(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,TCode:%String:编码,HIDDEN:%String")
{
}

ClassMethod EvaluateTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEvaluateType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetEvaluateType
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCEvaluateType",rowid)),"^",1)
	.q:(Code'="")&(TCode'=Code)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCEvaluateType",rowid)),"^",2)
	.q:(Desc'="")&(TDesc'=Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCEvaluateType",rowid)),"^",3)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCEvaluateType",rowid)),"^",4)
	.q:(InvalidFlag="Y")
	.d OutputRowGetEvaluateType
	Quit $$$OK
OutputRowGetEvaluateType
	s Data=$lb(TDesc,TCode,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEvaluateType
	s (TRowID,TDesc,TCode,InvalidFlag)=""
	quit
}

ClassMethod EvaluateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateTypeExecute ]
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

ClassMethod EvaluateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by :GBX GBX00035
/// 存储评价明细
ClassMethod SaveEvaluationList(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s SQLCODE=0
	TStart
	i (+isDel=1)
	{
		&SQL(delete from sqluser.DHC_EQCEvaluationList where EL_RowID = :rowid)
		if SQLCODE  
		{
			TRollBack
			q SQLCODE
		}
		TCommit
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s EvaluationDR=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s EvaluateTypeDR=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s EvaluateGroupDR=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	
	//modified by HHM 201509010 HHM0014
	//修改保存数据时，控制输入数据
	//控制条件：EvaluationDR、评价类型、评价组确定唯一输入;当评价组为“N”时，只有一个评价组
	s tmpRowID=""
	&SQL(select EL_RowID into:tmpRowID from sqluser.DHC_EQCEvaluationList where EL_EvaluationDR=:EvaluationDR and EL_EvaluateTypeDR=:EvaluateTypeDR and EL_EvaluateGroupDR=:EvaluateGroupDR)
	if ((tmpRowID'="")&(tmpRowID'=rowid)) q -1001
	s TIndependentFlag=$p($g(^DHCEQCEvaluation(EvaluationDR)),"^",9)
	s tFlag=0
	i TIndependentFlag="N" d
	.s Eid=0
	.f  s Eid=$o(^DHCEQCEvaluationList(0,"Evaluation",EvaluationDR,Eid))  q:((Eid="")||(tFlag'=0))  d
	..i Eid'="" d
	...s TEvaluateGroupDR=$p($g(^DHCEQCEvaluationList(Eid)),"^",4)
	...i TEvaluateGroupDR'=EvaluateGroupDR d
	....i Eid'=rowid s tFlag=-1 ;评价组唯一!
	i tFlag'=0 q -1002
	//********************************
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCEvaluationList Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCEvaluationList Values :PLIST() where EL_RowID = :rowid)
	}
	if SQLCODE  
	{
		TRollBack
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	TCommit
	q ID
}

ClassMethod GetEvaluationListByID(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCEvaluationList(rowid)

	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$Piece($g(^DHCEQCCode("DHCEQCEvaluateType",$p(result,"^",2))),"^",2)

	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$P($g(^DHCEQCCode("DHCEQCEvaluateGroup",$p(result,"^",4))),"^",2)
	q rowid_"^"_result_"^"_resultex
}

/// add by GBX 2015-03-24 14:34:55  GBX0035
/// desc:判断显示顺序是否有重复
/// Modify DJ 2015-08-19 DJ0156
ClassMethod CheckShowOrder(ShowOrder, EvaluationDR, EvaluationListDR)
{
	s id=0
	s Flag=0
	i ShowOrder="" q "0"
	q:EvaluationDR="" "1"
	f  s id=$o(^DHCEQCEvaluationList(id)) q:(id="")||(Flag'=0)  d
	.s TEvaluationDR=$p($g(^DHCEQCEvaluationList(id)),"^",1)
	.s TShowOrder=$p($g(^DHCEQCEvaluationList(id)),"^",5)
	.i ((ShowOrder=TShowOrder)&&(TEvaluationDR=EvaluationDR))  d
	..i EvaluationListDR="" s Flag=1
	..i ((EvaluationListDR'="")&&(EvaluationListDR'=id)) s Flag=1
	q Flag
}

// add by HHM 20150908 HHM0014

// 判断评价顺序是否存在重复数据

ClassMethod CheckEvaluationOrder(SourceType, EvaluationOrder, rowid)
{
	s Flag=1
	s EOrderRowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",SourceType,EvaluationOrder,0))
	;s EOrderRowIDN=$o(^DHCEQCEvaluation(0,"SourceTypeSort","N",SourceType,EvaluationOrder,0))
	;i ((EOrderRowID="")&(EOrderRowIDN'="")) s EOrderRowID=EOrderRowIDN
	i EOrderRowID="" s Flag=0
	i ((EOrderRowID'="")&(EOrderRowID=rowid)) s Flag=0
	q Flag
}

// d ##Class(web.DHCEQCEvaluation).FindEvaluationGroup(35,1)

ClassMethod FindEvaluationGroup(EvaluationDR)
{
	s TIndependentFlag=""
	s TIndependentFlag=$p($g(^DHCEQCEvaluation(EvaluationDR)),"^",9)
	q TIndependentFlag
}

}
