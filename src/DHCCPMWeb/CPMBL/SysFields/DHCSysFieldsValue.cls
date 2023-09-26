Class DHCCPMWeb.CPMBL.SysFields.DHCSysFieldsValue Extends DHCCPMWeb.CPMBL.SysFields.DHCSysFields [ ClassType = "", ProcedureBlock ]
{

//Parameter SCPMCTLocID = "SCPM.CTLocID";

//Parameter SCPMCTLocName = "SCPM.CTLocName";

//Parameter SCPMDate = "SCPM.Date";

//Parameter SCPMGroupID = "SCPM.GroupID";

//Parameter SCPMGroupName = "SCPM.GroupName";

//Parameter SCPMTime = "SCPM.Time";

//Parameter SCPMHospCode = "SCPM.HospCode";

//Parameter SCPMUserCode = "SCPM.UserCode";

//Parameter SCPMUserID = "SCPM.UserID";

//Parameter SCPMUserName = "SCPM.UserName";

ClassMethod GetSysFields() As %List
{
	s myList=##super()
	
	s myCount=myList.Count()
	for i=1:1:myCount
	{
		s mySysFieldObj=myList.GetAt(i)
		s myval=""
		if (..#SCPMCTLocID = mySysFieldObj.RFName){
			s myval=%session.Get("LOGON.CTLOCID")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(..#SCPMCTLocName = mySysFieldObj.RFName){
			s myLocRid=%session.Get("LOGON.CTLOCID")
			s myval=$p($g(^CTLOC(myLocRid)),"^",2)
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMDate){
			s myval=+$h
			s myval=$zd(+$h,3)
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMGroupID){
			s myval=%session.Get("LOGON.GROUPID")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMGroupName){
			s myval=%session.Get("LOGON.GROUPDESC")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMTime){
			s myval=$p($h,",",2)
			s myval=$zt($p($h,",",2))
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMHospCode){
			s myval=%session.Get("LOGON.SITECODE")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMUserCode){
			s myval=%session.Get("LOGON.USERCODE")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMUserID){
			s myval=%session.Get("LOGON.GROUPID")
			s mySysFieldObj.RFDefaultValue=myval
		}elseif(mySysFieldObj.RFName = ..#SCPMUserName){
			s myval=%session.Get("LOGON.USERNAME")
			s mySysFieldObj.RFDefaultValue=myval
		}
	}
	
	q myList
}

}
