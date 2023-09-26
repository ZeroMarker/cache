Class web.DHCEQ.EM.BUSReduceInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.EM.BUSReduceInfo).SaveReduceInfo("1^1^66566^1511^66566")
ClassMethod SaveReduceInfo(val As %Library.String = "")
{
	n PLIST,rowid
	
	s User="1" //%session.Get("LOGON.USERID")
	s Date=+$H
	s PLIST(2) = $p(val,"^",1)	;处置类型
	s PLIST(3) = $p(val,"^",2)	;设备id
	s PLIST(4) = $p(val,"^",3)	;批文日期
	s PLIST(5) = $p(val,"^",4)	;批文号
	s PLIST(6) = User			;负责人
	s PLIST(7) = $p(val,"^",5)	;减少日期

	s PLIST(17)="N" ;
	&SQL(select ERI_RowID into :rowid from SQLUSER.DHC_EQReduceInfo where ERI_EquipDR=:PLIST(3))
	i rowid=""
 	{
 		&SQL(Insert Into SQLUSER.DHC_EQReduceInfo Values :PLIST())		
 	} 
 	else
 	{
 		&SQL(Update SQLUSER.DHC_EQReduceInfo Values :PLIST() where ERI_RowID = :rowid)  			
 	}
 	
	q SQLCODE
}

}
