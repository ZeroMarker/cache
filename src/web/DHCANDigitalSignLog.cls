Import SQLUser

Class web.DHCANDigitalSignLog Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod InsertANSignLog(ANDSLSignDr, ANDSLUserDr, ANDSLOPADr, ANDSLDocumentCode, ANDSLContentHash, ANDSLIsValid) As %String
{
		q:ANDSLSignDr="" "签名不能为空"
	    q:ANDSLUserDr="" "用户ID不能为空"
		q:ANDSLOPADr="" "手术排班ID不能为空"
	    s ANDSLADMDr=$p(^DHCANOPArrange(ANDSLOPADr),"^",1)
	    q:ANDSLADMDr="" "就诊号不能为空"
	    
	    k PLIST
	    TSTART

        s PLIST(2)=ANDSLSignDr
	    s PLIST(3)=ANDSLUserDr
	    s PLIST(4)=ANDSLADMDr
	    s PLIST(5)=ANDSLOPADr
        s PLIST(6)=ANDSLDocumentCode 
	    s PLIST(7)=ANDSLContentHash
	    s PLIST(8)=ANDSLIsValid 
	    
		&SQL(insert into DHC_AN_DigitalSignLog values :PLIST())
	    i SQLCODE
	    {
		    TROLLBACK
		    q SQLCODE	
	    }
	
        TCOMMIT
	    q SQLCODE
}

}
