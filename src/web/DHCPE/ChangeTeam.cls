Import SQLUser

/// Create by zhouli
/// 组件:DHCPEChangeTeam.Edit
Class web.DHCPE.ChangeTeam Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SearchTeam(ContrlWidth As %String = "", RowID) As %String
{
    
     s:(""=ContrlWidth) ContrlWidth="155"
     w "<select name='换组' id='ChangeTeam' style='width:"_ContrlWidth_"' HEIGHT=0>",!
     s PGAdmID=$P(^DHCPEPreIADM(RowID),"^",2 )
	 q:$g(PGAdmID)=""
      s rowid=0
     f  s rowid=$O(^DHCPEPreGADM(PGAdmID,"Team",rowid) ) q:rowid=""  d
    .w "<option value='"_PGAdmID_"||"_rowid_"'>"_$P($G(^DHCPEPreGADM(PGAdmID,"Team",rowid)),"^",1)_"</option>",!
     w "</select>",!
	 Quit $$$OK
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "")
{
    s ^zhouli=Instring
	s PIAdmID=$p(Instring,"^",1)  
    s PGTeamID=$p(Instring,"^",2)
    s ret=..Update(PIAdmID,PGTeamID)
	
	q ret
}

//更新（预约）个人ADM表DHC_PE_PreIADM和体检人员表DHC_PE_IADM中的分组号

ClassMethod Update(PIAdmID As %Library.String = "", PGTeamID As %Library.String = "")
{
   TSTART 
     &sql(update DHC_PE_PreIADM    
	     set PIADM_PGTeam_DR =:PGTeamID
	     where PIADM_RowId= :PIAdmID )
	i SQLCODE'=0
	 {
		 TROLLBACK   //回滚
		 Q SQLCODE
	 }
	 
	 S id=""
	
	 S IADMRowId=0
	 s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PIAdmID,IADMRowId) )
	 i IADMRowId'=""
	 {  &sql(select GT_RowId into :id from DHC_PE_GTeam where GT_CRMTeam= :PGTeamID)

	  
	 
	 &sql(update DHC_PE_IADM
	         set IADM_GTeam_DR= :id
	         where  IADM_RowId= :IADMRowId)
	     i SQLCODE'=0
	        { 
	             TROLLBACK
		           Q SQLCODE
		                   } 
		             }       
	 TCOMMIT
	 Q SQLCODE
}

ClassMethod ShowInfo(Instring As %String = "") As %String
{
   S PIADM=$P(Instring,"^",1)
    s PIBIID=$P(^DHCPEPreIADM(PIADM),"^",1 )
	s PatName=$P(^DHCPEPreIBI(PIBIID),"^",2)
	s PGTeamID=$P(^DHCPEPreIADM(PIADM),"^",3 ) 
	q:$g(PGTeamID)=""
	s PGTPar=$p(PGTeamID,"||",1)
	s PGTSub=$p(PGTeamID,"||",2)
	s PGTName=$p(^DHCPEPreGADM(PGTPar,"Team",PGTSub),"^",1)
	s str=PatName_"^"_PGTName
    q str
}

}
