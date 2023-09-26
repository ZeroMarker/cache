/// 程序部署日志
Class web.DHCMedDeployLog Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

//Create By LiYang 2009-1-15

//字段说明： 程序名称^版本号^更新人^更新日期^更新时间^更新说明

ClassMethod SaveDeployInfo(Instr)
{
	
		n (Instr)
		set NewID = +$g(^DHCMedDeployLog) + 1
		set $p(Instr,"^",4) = $p($h,",",1)
		set $p(Instr,"^",5) = $p($h,",",2)		
		
		
		
	/*	set PLIST(2) = $p(Instr,"^",1)
		set PLIST(3) = $p(Instr,"^",2)
		set PLIST(4) = $p(Instr,"^",3)
		set PLIST(5) = $p(Instr,"^",4)
		set PLIST(6) = $p(Instr,"^",5)
		set PLIST(7) = $p(Instr,"^",6)


		&sql(insert into DHCMedDeployLog values :PLIST())*/
		set ^DHCMedDeployLog(NewID) = Instr
		set ^DHCMedDeployLog = NewID
		quit NewID
}

Parameter SQLDESCRIPTION = "ID";

//w ##class(web.DHCMedDeployLog).Fetch("","全部")

Parameter SQLROWID = "ID";

ClassMethod Fetch(FromID, AppName) As %String
{
		n (FromID, AppName)
		set intCounter = 0
		set NextID = FromID
		set Buffer = ""
		while 1
		{
			set NextID = $o(^DHCMedDeployLog(NextID),-1)
			quit:(NextID="")!(intCounter>20)
			set strData = $g(^DHCMedDeployLog(NextID)) 
			continue:($p(strData,"^",1)'=AppName)&&(AppName'="全部")
			set $p(strData,"^",4) = $zd($p(strData,"^",4),3)
			set $p(strData,"^",5) = $zt($p(strData,"^",5),1)
			set:Buffer'="" Buffer = Buffer _ $c(1)
			set Buffer = Buffer _ NextID _ "^" _ strData
			set intCounter = intCounter + 1
		}
		quit NextID_$c(1)_Buffer
}

}
