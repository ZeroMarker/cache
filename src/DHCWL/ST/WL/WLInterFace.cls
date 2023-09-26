Class DHCWL.ST.WL.WLInterFace Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ch
/// CreatDate：    2014-11-11
/// Description:： Insert	
/// Table：       DHCWL_ST_WL.DHCWLSTWLDataFromType
/// Input：       
/// Output：      
/// Return：      Err	OK
/// Others：	^DHCWLDFTypeD ; ^DHCWLDFTypeI
/// Others：w ##class(DHCWL.ST.WL.WLInterFace).InsDataFromType("a^b^c^d^e")
ClassMethod InsDataFromType(mDataStr) As %String
{
	
	n (mDataStr)
	s mReturn="Err"
	q:$G(mDataStr)="" $G(mReturn)
	s PLIST(2)=$P($G(mDataStr),"^",1)
	s PLIST(3)=$P($G(mDataStr),"^",2)
	s PLIST(4)=$P($G(mDataStr),"^",3)
	s PLIST(5)=$P($G(mDataStr),"^",4)
	s PLIST(6)=$P($G(mDataStr),"^",5)
	&sql(insert into DHCWL_ST_WL.DHCWLSTWLDataFromType values PLIST())
	i $G(SQLCODE)=0 s mReturn="OK"
	q $G(mReturn)
}

/// Creator：      ch
/// CreatDate：    2014-11-11
/// Description:： Delete	
/// Table：       DHCWL_ST_WL.DHCWLSTWLDataFromType
/// Input：       
/// Output：      
/// Return：      Err	OK
/// Others：	^DHCWLDFTypeD ; ^DHCWLDFTypeI
/// Others：w ##class(DHCWL.ST.WL.WLInterFace).DelDataFromType(1)
ClassMethod DelDataFromType(mId) As %String
{
	
	n (mId)
	s mReturn="Err"
	q:+$G(mId)="" $G(mReturn)
	q:'$D(^DHCWLDFTypeD(mId)) $G(mReturn)
	&sql(delete from DHCWL_ST_WL.DHCWLSTWLDataFromType where ID=:mId)
	i $G(SQLCODE)=0 s mReturn="OK"
	q $G(mReturn)
}

/// Creator：      ch
/// CreatDate：    2014-11-11
/// Description:： check	
/// Table：       DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom
/// Input：       
/// Output：      
/// Return：      Err	OK
/// Others：	^DHCWLWLFromD ; ^DHCWLWLFromI
/// Others：w ##class(DHCWL.ST.WL.WLInterFace).CheckDataFrom("1^b^6^d^e^f^g^h")
ClassMethod CheckDataFrom(mDataStr) As %String
{
	
	n (mDataStr)
	s mReturn="OK"
	q:+$G(mDataStr)="" $G(mReturn)
	s mStatDr=$P($G(mDataStr),"^",1)
	s mDataType=$P($G(mDataStr),"^",2)
	s mDataType=$zcvt(mDataType,"U")
	i $d(^DHCWLWLFromI("StatDrDataType"," "_mStatDr," "_mDataType)) s mReturn="Err"
	q $G(mReturn)
}

/// Creator：      ch
/// CreatDate：    2014-11-11
/// Description:： insert	
/// Table：       DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom
/// Input：       
/// Output：      
/// Return：      Err	OK
/// Others：	^DHCWLWLFromD ; ^DHCWLWLFromI
/// Others：w ##class(DHCWL.ST.WL.WLInterFace).InsDataFrom("1^b^6^d^e^f^g^h")
ClassMethod InsDataFrom(mDataStr) As %String
{
	
	n (mDataStr)
	s mReturn="Err"
	q:+$G(mDataStr)="" $G(mReturn)
	s PLIST(2)=$P($G(mDataStr),"^",1)
	s PLIST(3)=$P($G(mDataStr),"^",2)
	s PLIST(4)=$P($G(mDataStr),"^",3)
	s PLIST(5)=$P($G(mDataStr),"^",4)
	s PLIST(6)=$P($G(mDataStr),"^",5)
	s PLIST(7)=$P($G(mDataStr),"^",6)
	s PLIST(8)=$P($G(mDataStr),"^",7)
	q:+$G(PLIST(2))=0 $G(mReturn)_" - "_"WLFStatDr"		///	统计项目ID
	q:$G(PLIST(3))="" $G(mReturn)_" - "_"WLFDataType"	///	就诊类型
	q:'$D(^DHCWLDFTypeD(+$G(PLIST(4)))) $G(mReturn)_" - "_"WLFFromType"	///	统计口径ID
	i +$G(PLIST(6))=0 s PLIST(6)=+$h
	&sql(insert into DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom values PLIST())
	i $G(SQLCODE)=0 s mReturn="OK"
	q $G(mReturn)
}

/// Creator：      ch
/// CreatDate：    2014-11-11
/// Description:： Delete	
/// Table：       DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom
/// Input：       
/// Output：      
/// Return：      Err	OK
/// Others：	^DHCWLWLFromD ; ^DHCWLWLFromI
/// Others：w ##class(DHCWL.ST.WL.WLInterFace).DelDataFrom(1)
ClassMethod DelDataFrom(mId) As %String
{
	
	n (mId)
	s mReturn="Err"
	q:+$G(mId)="" $G(mReturn)
	q:'$D(^DHCWLWLFromD(mId)) $G(mReturn)
	&sql(delete from DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom where ID=:mId)
	i $G(SQLCODE)=0 s mReturn="OK"
	q $G(mReturn)
}

}
