/// 校正原来的用户登录界面
Class web.DT.SessionLogon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 用户登录，调用websys.SessionLogon.Logon
/// 本算法分析：
/// ValidUser      rtn
///  1             1        登录用户验证成功
///  1             0        页面用户跳转到框架中
///  0             1        返回登录，非验证用户提示
///  0             0        不可能发生
ClassMethod Logon() As %Boolean
{
	s rtn=##class(websys.SessionLogon).Logon()
	
	if (+rtn){
		// 检测出对应部门的医院ID
		// 如果科室id'="" 而医院ID=""
		
		// 合法用户验证数据是否正确
		// 根据获得的Loc与Hosp校正登陆信息就可以了
		i (ValidUser){
			;$g(%request.Data("Hospital",1))
			;$g(%request.Data("DEPARTMENT",1))
			;直接修改Hospital
			s mydtuserid=$g(%session.Data("LOGON.USERID"))
			
			s mydtctlocid=$p(^SSU("SSUSR",mydtuserid),"^",4)
			s mydthospid=""
			i (mydtctlocid'=""){
				s mydtlocdesc=$p(^CTLOC(mydtctlocid),"^",2)
				s mydthospid=$p(^CTLOC(mydtctlocid),"^",22)
			}
			s mydthospdesc=""
			i (mydthospid'=""){
				s mydthospdesc=$p(^CT("HOSP",mydthospid),"^",2)
			}
			s %request.Data("Hospital",1)=mydthospdesc
		}else{
			s %request.Data("Hospital",1)=""
		}
		
	}
	
	i STATUS'="" d
	
	q rtn
}

}
