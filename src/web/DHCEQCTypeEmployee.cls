Import SQLUser

/// ***************************************
/// 修  改  人：ZY  2009-05-20   
/// 修改 目 的：ZY0003;增加了"设备类组"字段显示,查找
/// 修改类方法：TypeEmployee,GetDocByID,SaveData 
/// ***************************************
/// modified by GR 2014-09-24
/// 3453 代码维护-设备员工定义-员工姓名列显示的是员工ID号
/// 修改位置：TypeEmployeeExecute(),TypeEmployee()最后一个参数
/// 原因，输出参数名字混乱
/// ------------------------------------------------------------ 
Class web.DHCEQCTypeEmployee Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 243;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TE_RowID";

Parameter SQLDESCRIPTION = "TE_RowID";

Parameter SQLROWID = "TE_RowID";

ClassMethod TypeEmployeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TypeEmployeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified by ZY   2009-05-21  zy0003 增加参数EquipTypeDR，增加输出TEquipType
/// Modified by QW   2014-05-30  QW0006       将员工姓名的rowid(TEmployeeDR表示解析后员工姓名)保存在TUserDR中输出
ClassMethod TypeEmployeeExecute(ByRef qHandle As %Binary, EmployeeTypeDR As %String = "", EmployeeDR As %String = "", EquipTypeDR As %String = "", InvalidFlag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetTypeEmployee
	Quit $$$OK
BuildDataGetTypeEmployee
	f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",rowid))  quit:rowid=""  d
	.d ResetVariablesGetTypeEmployee
	.s TRowID = rowid	//rowid
	.s TEmployeeTypeDR = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",1)	//类型
	.s TEmployeeDR = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)	//姓名
	.s TInvalidFlag = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)	//无效标志   modified by czf begin 550173
	.s TRemark = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",4)	//备注	
	.s TEquipTypeDR= $p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",5)	//设备类组   
	.q:(InvalidFlag="")&&(TInvalidFlag="Y")             								//modified by czf end  550135
	.q:(InvalidFlag="on")&&(TInvalidFlag="N")
	.q:(EmployeeTypeDR'="")&&(EmployeeTypeDR'=TEmployeeTypeDR)
	.q:(EmployeeDR'="")&&(EmployeeDR'=TEmployeeDR)
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	.s TEmployeeTypeDR=$p($g(^DHCEQCCode("DHCEQCEmployeeType",TEmployeeTypeDR)),"^",2)  //根据类型编码解析类型名称
	.s TEmployee = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TEmployeeDR)  //根据员工号解析员工姓名
	.i ""'=TEquipTypeDR s TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^", 2)  ////设备类组名  ///2014-9-11 HZY0061
	.d OutputRowGetTypeEmployee
	quit
OutputRowGetTypeEmployee
	s Data=$lb(TRowID,TEmployeeTypeDR,TEmployeeDR,TRemark,TInvalidFlag,TEquipType,TEmployee,TRow) //modified by GR2014-09-24 缺陷号3453
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetTypeEmployee
	s (TRowID,TEmployeeTypeDR,TEmployeeDR,TRemark,TInvalidFlag,TEquipType,TEmployee)="" //modified by GR2014-09-24 缺陷号3453
	quit
}

ClassMethod TypeEmployeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TypeEmployeeExecute ]
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

/// Modified by ZY  2009-05-21  zy0003 增加参数EquipTypeDR 
Query TypeEmployee(EmployeeTypeDR As %String = "", EmployeeDR As %String = "", EquipTypeDR As %String = "", InvalidFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEmployeeTypeDR:%String,TEmployeeDR:%String,TRemark:%String,TInvalidFlag:%String,TEquipType:%String,TEmployee:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCTypeEmployee",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",1) //员工类型编码
	s resultex=resultex_"^"	//2
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEmployeeType",$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",1))),"^",2) //员工类型名称
	s resultex=resultex_"^"	//3
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2) //员工编码
	s resultex=resultex_"^"	//4
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2))  //员工姓名
	s resultex=resultex_"^"	//5
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",4) //备注
	s resultex=resultex_"^"	//6
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3) //使用标识
 	//add by ZY   2009-05-21  begin  zy0003
	s resultex=resultex_"^"	//7
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",5) ////设备类组DR                       
	s resultex=resultex_"^"	//8
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g( ^DHCEQCCode("DHCEQCEquipType",$p(result,"^",5))),"^", 2) //设备类组

 	//add by ZY   2009-05-21  end
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 i (+isDel=1)
	 {
	 	//删除按钮操作,更新InvalidFlag标识.
	 	s PLIST(4)="Y"
	 	&SQL(Update SQLUSER.DHC_EQCTypeEmployee Values :PLIST() where TE_RowID = :rowid) 
	 	if SQLCODE  q SQLCODE
	 	q rowid
	 }
	 s PLIST(2) = $p(val,"^",2)	//员工类型编码
	 s typeid = $p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)	//员工编码
	 s userid = $p(val,"^",3)
	 s PLIST(4) = $p(val,"^",4) //停用标识
	 s PLIST(5) = $p(val,"^",5) //备注 

	 //add by ZY   2009-05-21 zy0003
	 s PLIST(6) = $p(val,"^",6) //设备类组
	 s RowidFind=""
	 &SQL(select TE_RowID into :RowidFind from DHC_EQCTypeEmployee where TE_EmployeeTypeDR=:typeid and TE_EmployeeDR=:userid and TE_InvalidFlag='N') //modify hly 20190801         
	 i SQLCODE=100 s RowidFind="",SQLCODE=0
	 i (rowid="")  //新增按钮操作
	 {
		 //检测当前记录时候已经存在
		 i RowidFind'="" q -3001
		 &SQL(Insert Into SQLUSER.DHC_EQCTypeEmployee Values :PLIST()) 
	 }
	 else  //更新按钮操作
	 {
		 if (RowidFind'="")&&(RowidFind'=rowid) q -3001
		 &SQL(Update SQLUSER.DHC_EQCTypeEmployee Values :PLIST() where TE_RowID = :rowid) 	 	
	 }
	 
	 if SQLCODE  q SQLCODE
	 Set ID=$g(%ROWID)
	 q ID
}

/******************************************************************************/
ClassMethod EQEmployeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQEmployeeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EQEmployeeTypeExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEmployeeType",rowid)) q:rowid=""  d
	.s EmployeeType=$p(^DHCEQCCode("DHCEQCEmployeeType",rowid),"^",2)
	.q:EmployeeType'[code
	.s rowid0=rowid
 	.Do OutputRowEQEmployeeType	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowEQEmployeeType
	set Data=$lb(EmployeeType,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EQEmployeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQEmployeeTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query EQEmployeeType(code As %String) As %Query(ROWSPEC = "ET_Desc:%String:员工类型,Hidden:%String")
{
}

}
