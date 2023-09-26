/// ClassName:    DHCMed.SPEService.PatType
/// Description:  特殊患者类型 相关操作
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPEService.PatType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  保存特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       
/// Return：      
/// w ##class(DHCMed.SPEService.PatType).SaveRec("^01^aa^1^测试","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set RowID  =$p(aInput,aSeparate,1)
	Set Code   =$p(aInput,aSeparate,2)
	Set Code   =$zcvt(Code,"U")
	Set $p(aInput,aSeparate,2)=Code
	Set Desc=$p(aInput,aSeparate,3)
	Quit:(Code="")||(Desc="") return
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.SPEDi("PatTp",0,"IndexCode"," "_Code,xRowID)) //如果Code不存在 就没有这条索引 xRowID="" 就跳出循环 IsError就不能等于1
		Quit:xRowID=""  
		Continue:(RowID'="")&&(RowID=xRowID)  //如果Code已存在且输入的RowID为空时【即直接输入已存在的Code点保存】，就不会进行下一次循环，程序向下执行，IsError就等于1，就会出现数据重复错误
		Set IsError=1                         //Quit是添加新数据，Continue是更新数据。什么时候会出现RowID!="" 但是RowID!=xRowID呢？
		                                      //客户端操作是不会出现的，所以RowID=xRowID这个条件是可以不要的
	}
	Quit:IsError=1 return   //-100 数据重复【没有选中Panel，输入的code重复会返回-100】
	//执行下面语句的条件是：RowID为空且Code不存在【添加】  或 RowID不为空Code存在【更新】
	Set return=##Class(DHCMed.SPE.PatType).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  查询特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatType","QryPatType")
Query QryPatType() As %Query(ROWSPEC = "PTID:%String,PTCode:%String,PTDesc:%String,PTIsActiveDesc:%String,PTResume:%String")
{
}

ClassMethod QryPatTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set RowID=""
 	
 	For
 	{
	 	Set RowID        = $o(^DHCMed.SPED("PatTp",RowID))
	 	Quit:RowID=""
	 	
	 	Set PTObj        = ##class(DHCMed.SPE.PatType).GetObjById(RowID)
	 	
	 	Set Code         = PTObj.PTCode
	 	Set Desc         = PTObj.PTDesc
	 	Set IsActiveDesc = $s(PTObj.PTIsActive=1:"是",1:"否")
	 	Set Resume       = PTObj.PTResume
	 	//Continue:PTObj.PTIsActive'=1        //update by pylian 20150619 此方法用来显示所有状态的类型，显示有效状态的类型方法使用QryPatTypeActive
		Set Data=$lb(RowID,Code,Desc,IsActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2015-04-11
/// Description:  查询有效状态的特殊患者类型
/// Table：       DHCMed.SPE.PatType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatType","QryPatTypeActive")
Query QryPatTypeActive() As %Query(ROWSPEC = "PTID:%String,PTCode:%String,PTDesc:%String,PTIsActiveDesc:%String,PTResume:%String")
{
}

ClassMethod QryPatTypeActiveExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set RowID=""
 	
 	For
 	{
	 	Set RowID        = $o(^DHCMed.SPED("PatTp",RowID))
	 	Quit:RowID=""
	 	
	 	Set PTObj        = ##class(DHCMed.SPE.PatType).GetObjById(RowID)
	 	
	 	Set Code         = PTObj.PTCode
	 	Set Desc         = PTObj.PTDesc
	 
	 	Set IsActiveDesc=PTObj.PTIsActive
		Continue:IsActiveDesc'=1
		Set IsActiveDesc=$s(IsActiveDesc=1:"是",1:"否")
	 	Set Resume       = PTObj.PTResume
	 	
		Set Data=$lb(RowID,Code,Desc,IsActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPatTypeActiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTypeActiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatTypeActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTypeActiveExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 导入重点患者子分类字典
/// w ##Class(DHCMed.SPEService.PatType).ImportPatType("A^需关注患者^1^")
ClassMethod ImportPatType(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set InputStr=""
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",1)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",2)
	Set InputStr=InputStr_"^"_+$p(aInputStr,"^",3)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",4)
	
	Set return=##class(DHCMed.SPE.PatType).Update(InputStr,"^")
	Quit return
}

}
