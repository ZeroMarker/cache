/// 修改：Mzy 2009-08-25
/// 新增方法：GetTreeNodeEquipDRs
/// 描述:获取父节点下的所有子节点
/// -------------------------------
/// 修改：Mzy 2009-08-25
/// 新增方法：GetTreeNode
/// 描述:建立子节点
/// -------------------------------
/// 修改：Mzy 2009-08-25
/// 新增方法：HasChild
/// 描述:一个节点是否有子节点
/// -------------------------------
/// 修改：Mzy 2009-08-25
/// 新增方法：ISEnd
/// 描述:是否同一级节点的最后一个节点
/// -------------------------------
/// 修改：Mzy 2009-08-25
/// 新增方法：GetEquipDRs
/// 根据分类得到该分类的直系父节点串，格式1^2^3^4^5
/// -------------------------------
/// 修改：Mzy 2009-08-24
/// 新增方法：GetRootEquipDR
/// 描述:查询设备主从关联记录根节点设备
/// -------------------------------
/// 修改：Mzy 2009-08-21
/// 新增方法：GetDocByID
/// 描述:查询设备主从关联记录
/// -------------------------------
/// 修改：Mzy 2009-08-20
/// 新增方法：SaveData
/// 描述:设备主从关联保存修改删除操作
/// -------------------------------
/// 修改：Mzy 2009-08-20
/// 新增方法：Associated
/// 描述:查询设备关联数据
/// -------------------------------
/// 修改：Mzy 2009-08-20
/// 新增类：web.DHCEQAssociated
/// 描述:设备主从关联表
/// -------------------------------
Class web.DHCEQAssociated Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 240;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EA_RowID";

Parameter SQLDESCRIPTION = "EA_RowID";

Parameter SQLROWID = "EA_RowID";

/// 修改：Mzy 2009-08-20
/// 修改方法：Associated
/// 描述:查询设备关联数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQAssociated","Associated","","")
/// modified by kdf 2018-12-19 增加输出列序号:TRow 需求号:783429
Query Associated(ParEquipDR As %String = "", ChildEquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TParEquipDR:%String,TParEquip:%String,TChildEquipDR:%String,TChildEquip:%String,TChildEQNo:%String,TChildEQLeaveFactoryNo:%String,TRemark:%String,TInvalidFlag:%String,TFromDate:%String,TToDate:%String,TRow:%String")
{
}

ClassMethod AssociatedExecute(ByRef qHandle As %Binary, ParEquipDR As %String = "", ChildEquipDR As %String = "") As %Status
{
	New repid, index,rowid
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataAssociated
	Quit $$$OK
BuildDataAssociated
	For  Set rowid=$Order(^DHCEQAssociated(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesAssociated
	.set TRow=index
	.Set TRowID = rowid
	.Set TParEquipDR=$Piece($Get(^DHCEQAssociated(rowid)),"^",1) 	//父设备
	.Quit:(ParEquipDR'="")&(ParEquipDR'=TParEquipDR)
	.Set TParEquip=$Piece($Get(^DHCEQEquip(TParEquipDR)),"^",1)
	.Set TChildEquipDR=$Piece($Get(^DHCEQAssociated(rowid)),"^",2) 	//子设备
	.Quit:(ChildEquipDR'="")&(ChildEquipDR'=TChildEquipDR)
	.Set TChildEquip=$Piece($Get(^DHCEQEquip(TChildEquipDR)),"^",1)
	.Set TChildEQNo=$Piece($Get(^DHCEQEquip(TChildEquipDR)),"^",71)
	.Set TChildEQLeaveFactoryNo=$Piece($Get(^DHCEQEquip(TChildEquipDR)),"^",10)
	.Set TRemark=$Piece($Get(^DHCEQAssociated(rowid)),"^",3) 		//备注
	.Set TInvalidFlag=$Piece($Get(^DHCEQAssociated(rowid)),"^",4)	//无效标志
	.Quit:TInvalidFlag'="N"
	.Set TFromDate=$Piece($Get(^DHCEQAssociated(rowid)),"^",5)
	.If TFromDate'="" Set TFromDate = ##Class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")
	.Set TToDate=$Piece($Get(^DHCEQAssociated(rowid)),"^",6)
	.If TToDate'="" Set TToDate = ##Class(web.DHCEQCommon).TransValueToPage(TToDate,"date")
	.Do OutputRowAssociated
	Quit
OutputRowAssociated
    Set Data=$ListBuild(TRowID,TParEquipDR,TParEquip,TChildEquipDR,TChildEquip,TChildEQNo,TChildEQLeaveFactoryNo,TRemark,TInvalidFlag,TFromDate,TToDate,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesAssociated
	Set (TRowID,TParEquipDR,TParEquip,TChildEquipDR,TChildEquip,TChildEQNo,TChildEQLeaveFactoryNo,TRemark,TInvalidFlag,TFromDate,TToDate,TRow)=""
	Quit
}

ClassMethod AssociatedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssociatedExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AssociatedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssociatedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 修改：Mzy 2009-08-20
/// 新增方法：SaveData
/// 描述:设备主从关联保存修改删除操作
/// w ##Class(web.DHCEQAssociated).SaveData("1^no1^no2^no3")
ClassMethod SaveData(val As %Library.String = "")
{
	Kill List,rowid,ParEquipDR
 	Set rowid = $Piece(val,"^",1)
 	Set Len = $LENGTH(val,"^")
	Kill List(1)

	TStart
	If (Len=1)
	{
		Set ID=$Piece($Get(^DHCEQAssociated(rowid)),"^",1)		;ParEquipDR
		Set List(5) = "Y"
		Set List(7) = ##Class(web.DHCEQCommon).TransValueFromPage(##Class(web.DHCEQCommon).GetCurDate(),"date")
		&SQL(Update SQLUSER.DHC_EQAssociated Values :List() where EA_RowID = :rowid)
		If ($Order(^DHCEQAssociated(0,"ParEquipDR",ID,"N",""),-1)="") Do
		.Set ID=0
		.Set EARowID = $Order(^DHCEQAssociated(0,"ChildEquipDR",ID,"N",""),-1)
		.If EARowID'="" Set ID=$Piece($Get(^DHCEQAssociated(EARowID)),"^",1)
	}
	else
	{
		Quit:($Piece(val,"^",2)="")||($Piece(val,"^",3)="") -1002		;父节点和子节点不能为空
		Set List(2) = $Piece(val,"^",2)		;ParEquipDR
	    Set List(3) = $Piece(val,"^",3)		;ChildEquipDR
	    Set List(4) = $Piece(val,"^",4)		;Remark
	 	;Set List(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")		;InvalidFlag
	 	Set List(6) = ##Class(web.DHCEQCommon).TransValueFromPage(##Class(web.DHCEQCommon).GetCurDate(),"date")		;FromDate
	 	;Set List(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")		;ToDate
	 	Set List(8) = $Piece(val,"^",8)		;EA_Hold1
	 	Set List(9) = $Piece(val,"^",9)		;EA_Hold2
	  	Set List(10) = $Piece(val,"^",10)	;EA_Hold3
	  	Set List(11) = $Piece(val,"^",11)	;EA_Hold4
	  	Set List(12) = $Piece(val,"^",12)	;EA_Hold5
	  	Set List(13) = $Piece(val,"^",13)	;EA_UserDR
		If (rowid'="")
		{
			&SQL(Update SQLUSER.DHC_EQAssociated Values :List() where EA_RowID = :rowid)
			Set ID=rowid
		}
		Else
		{
			Set List(5) = "N"
			Set EARowID = $Order(^DHCEQAssociated(0,"ChildEquipDR",$Piece(val,"^",3),"N",""),-1)
			Quit:EARowID'="" -1001
			Set RootEquipDR1 = ..GetRootEquipDR($Piece(val,"^",2))
			Set RootEquipDR2 = ..GetRootEquipDR($Piece(val,"^",3))
			Quit:RootEquipDR1=RootEquipDR2 -1001
			&SQL(Insert Into SQLUSER.DHC_EQAssociated Values :List())
			Set ID=$Get(%ROWID)
		}
	}
	If SQLCODE  
	{
		TRollBack
		Quit SQLCODE
	}
	
	TCommit
	Quit ID
}

/// 修改：Mzy 2009-08-21
/// 新增方法：GetDocByID
/// 描述:查询设备主从关联记录
/// w ##Class(web.DHCEQAssociated).GetDocByID("","","1")
ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	New result,resultex
	Set (result,resultex)=""
	Set result= ^DHCEQAssociated(rowid)
	Set resultex=result

	Set resultex=resultex_"^"	//InvalidFlag
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQAssociated(rowid)),"^",4),"bool")
	Set resultex=resultex_"^"	//FromDate
	If $Piece(result,"^",5)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQAssociated(rowid)),"^",5),"date")
	Set resultex=resultex_"^"	//ToDate
	If $Piece(result,"^",6)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQAssociated(rowid)),"^",6),"date")
	Set resultex=resultex_"^"	//UserDR
	If $Piece(result,"^",7)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",7))

	Quit resultex
}

/// Tree
/// 修改：Mzy 2009-08-25
/// 新增方法：GetTreeNodeEquipDRs
/// 描述:获取父节点下的所有子节点
/// w ##Class(web.DHCEQAssociated).GetTreeNodeEquipDRs(parEquipDR,childEquipDR)
ClassMethod GetTreeNodeEquipDRs(parEquipDR, childEquipDR)
{
	Set NodeDRs=""
	Set RowID=0
	For  Set RowID=$Order(^DHCEQAssociated(0,"ParEquipDR",parEquipDR,"N",RowID))  Quit:RowID=""  Do
	.Set childEquipDR=$Piece(^DHCEQAssociated(RowID),"^",2)
	.If NodeDRs'="" Set NodeDRs=NodeDRs_"^"
	.Set NodeDRs=NodeDRs_childEquipDR
	
	Quit:NodeDRs="" childEquipDR
	Quit NodeDRs
}

/// 修改：Mzy 2009-08-25
/// 新增方法：GetTreeNode
/// 描述:建立子节点
/// ##Class(web.DHCEQAssociated).GetTreeNode(parid,layer,preline,EquipDR)
ClassMethod GetTreeNode(parEquipDR, layer, preline, EquipDR)
{
	Set InvalidFlag="N"
	Set Equip=$Piece($Get(^DHCEQEquip(EquipDR)),"^",1)
	Set RowID=$Order(^DHCEQAssociated(0,"ChildEquipDR",EquipDR,"N",""),-1)
	If RowID'="" Set InvalidFlag=$Piece($Get(^DHCEQAssociated(RowID)),"^",4)
	Quit:InvalidFlag="Y" ""
	Set ISChildID=..HasChild(EquipDR)
	Set ISEndID=..ISEnd(parEquipDR,EquipDR)
	Quit ##class(web.DHCEQTree).CreateNode(EquipDR,Equip,ISChildID,ISEndID,layer,parEquipDR,preline)
}

/// 一个节点是否有子节点
ClassMethod HasChild(EquipDR)
{
	Set Total=0
	Set RowID=0
	For  Set RowID=$Order(^DHCEQAssociated(0,"ParEquipDR",EquipDR,"N",RowID))  Quit:RowID=""  Do
	.Set Total=Total+1
	
	Quit:Total>0 1
	Quit 0
}

/// 是否同一级节点的最后一个节点
ClassMethod ISEnd(parEquipDR, childEquipDR)
{
	Set ID=0
	Set EndRowID=$Order(^DHCEQAssociated(0,"ParEquipDR",parEquipDR,"N",""),-1)
	If EndRowID'="" Do
	.Set ID=$Piece(^DHCEQAssociated(EndRowID),"^",2)
	
	Quit:(childEquipDR=ID)||(EndRowID="") 1
	Quit 0
}

/// 修改：Mzy 2009-08-24
/// 新增方法：GetRootEquipDR
/// 描述:查询设备主从关联记录根节点设备
/// w ##Class(web.DHCEQAssociated).GetRootEquipDR("16")
ClassMethod GetRootEquipDR(EquipDR As %Library.String = "")
{
	Set RowID=""
	For  Set RowID=$Order(^DHCEQAssociated(0,"ChildEquipDR",EquipDR,"N",""),-1)  Quit:RowID=""  Do
	.Set EquipDR=$Piece(^DHCEQAssociated(RowID),"^",1)
	Quit EquipDR
}

/// 修改：Mzy 2009-08-25
/// 新增方法：GetEquipDRs
/// 根据分类得到该分类的直系父节点串，格式1^2^3^4^5
/// w ##Class(web.DHCEQAssociated).GetEquipDRs("86")
ClassMethod GetEquipDRs(parEquipDR)
{
	Set RowID=$Order(^DHCEQAssociated(0,"ChildEquipDR",parEquipDR,"N",""),-1)
	If RowID'="" Do
	.Set ID=$p($g(^DHCEQAssociated(RowID)),"^",1)
	.Set EquipDRs=..GetEquipDRs(ID)_"^"_parEquipDR
	Else  Do
	.Set EquipDRs="0^"_parEquipDR

	Quit EquipDRs
}

}
