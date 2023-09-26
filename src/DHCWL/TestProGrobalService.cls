/// DHCWL.TestProGrobalService
Class DHCWL.TestProGrobalService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "TestProGrobalService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// TestProGrobal
/// 
/// Creator：      王峥
/// CreatDate：    2015-4-16
/// Description:： 通过sql和访问索引这2种方式，统计某时间段内的病人费用，并把这2中方式得到的病人费用进行比较，比较结果
/// 					保存到：^TEMPDHCWL("TestProGrobal-LOG","QueryTotalPrice",执行操作日期,执行操作顺序号)   中
/// Table：       	dhc_workload
/// Input：          startDate:开始日期；endDate:结束日期。
/// Output：         
/// Return：         
/// Others：         如果病人费用相同，比较结果是1，否则是0
Method TestProGrobalQueryTotalPrice(startDate As %String, endDate As %String) [ WebMethod ]
{
	s $zt="ErrTotalPrice"

	s ret=-1
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	q:$g(sDate)=""
	q:$g(eDate)=""
	s sqlTotalPrice=0
	s actDate=$zd($h,3)
	&sql(SELECT sum(workload_totalPrice) into :sqlTotalPrice FROM SQLUser.DHC_WorkLoad WHERE WorkLoad_OrdDate BETWEEN :sDate and :eDate)
	
	for date=sDate:1:eDate {
		s WLRowid=""
		f { 
		//^DHCWorkLoad(0,"ORDDATE",{WorkLoad_OrdDate},{WorkLoad_Rowid})
			s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",date,WLRowid))
			q:WLRowid=""
			s TotalPrice=$p(^DHCWorkLoad(WLRowid),"^",16)	
			s ^||TEMPDHCWL("RESULT")=$g(^||TEMPDHCWL("RESULT"))+TotalPrice
		}
	}
	if $g(^||TEMPDHCWL("RESULT"))'=sqlTotalPrice s ret=0
	e  s ret=1

	s inx=$o(^TEMPDHCWL("TestProGrobal-LOG","QueryTotalPrice",actDate,""),-1)
	s inx=inx+1
	s ^TEMPDHCWL("TestProGrobal-LOG","QueryTotalPrice",actDate,inx)="startDate:"_startDate_"^"_ret
	q ret
ErrTotalPrice
	q $g(ret)
}

/// Creator：      王峥
/// CreatDate：    2015-4-16
/// Description:： 分别使用标准global和进程global参与统计病人费用，并比较这2种方式所花费的时间（单位为秒）
/// Table：       	DHC_WORKLOAD
/// Input：          startDate:开始日期；endDate:结束日期
/// Output：         
/// Return：         
/// Others：	测试进程global的时间        
/// 比较的结果保存到^TEMPDHCWL("TestProGrobal-LOG","TimeEff")中，global结果如下：
/// 					 ^TEMPDHCWL("TestProGrobal-LOG","TimeEff",执行操作日期,执行操作顺序号)= 标准global所花费时间-进程global所花费时间
Method TestProGrobalTimeEff(startDate As %String, endDate As %String) [ WebMethod ]
{
	s $zt="ErrTimeEff"
	s ret=-1
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	q:$g(sDate)=""
	q:$g(eDate)=""
	s actDate=$zd($h,3)
	
	k ^||TEMPDHCWL("RESULT")
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	s time1=$p($ZTIMESTAMP,",",2)
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s tarEC="9999"	
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	s time2=$p($ZTIMESTAMP,",",2)
	s stdGblsec=time2-time1
	;w !,"标准global耗时"_sec_"秒" 
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)

	s time1=$p($ZTIMESTAMP,",",2)
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s tarEC="9999"	
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	s time2=$p($ZTIMESTAMP ,",",2)
	s proGblsec=time2-time1
	k ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)
	;w !,"进程global耗时"_sec_"秒" 

	s inx=$o(^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,""),-1)
	s inx=inx+1
	s ^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,inx)="startDate:"_startDate_"^"_(stdGblsec-proGblsec)_"^STDG:"_stdGblsec_"^PPG:"_proGblsec
	q
	
ErrTimeEff
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	q
}

/// 测试进程global的时间
/// 
Method TestProGrobalTimeEffForPPG(startDate As %String, endDate As %String) [ WebMethod ]
{
	s $zt="ErrTimeEff1"
	s ret=-1
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	q:$g(sDate)=""
	q:$g(eDate)=""
	s actDate=$zd($h,3)
	
	k ^||TEMPDHCWL("RESULT")
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	s time1=$p($ZTIMESTAMP,",",2)
	/*
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s tarEC="9999"	
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	s time2=$p($ZTIMESTAMP,",",2)
	s stdGblsec=time2-time1
	;w !,"标准global耗时"_sec_"秒" 
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	
	s time1=$p($ZTIMESTAMP,",",2)
	*/
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s tarEC="9999"	
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	//s time2=$p($ZTIMESTAMP ,",",2)
	//s proGblsec=time2-time1
	//k ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)
	;w !,"进程global耗时"_sec_"秒" 

	//s inx=$o(^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,""),-1)
	//s inx=inx+1
	//s ^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,inx)=stdGblsec-proGblsec
	q
	
ErrTimeEff1
	;k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	q
}

/// 测试临时global的时间
/// 
Method TestProGrobalTimeEffForTMPG(startDate As %String, endDate As %String) [ WebMethod ]
{
	s $zt="ErrTimeEff2"
	s ret=-1
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	q:$g(sDate)=""
	q:$g(eDate)=""
	s actDate=$zd($h,3)
	
	k ^||TEMPDHCWL("RESULT")
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	s time1=$p($ZTIMESTAMP,",",2)
	
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s patDoc="9999"	
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	s time2=$p($ZTIMESTAMP,",",2)
	s stdGblsec=time2-time1
	;w !,"标准global耗时"_sec_"秒" 
	k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	/*
	s time1=$p($ZTIMESTAMP,",",2)
	
	s rowid=""
	f ordDate=startDate:1:endDate {
		s rowid=""
		f {
			s rowid=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,rowid))
			q:$g(rowid)=""
			s resDep=$p(^DHCWorkLoad(rowid),"^",3)
			s patDoc=$p(^DHCWorkLoad(rowid),"^",25)
			s tarEC=$p(^DHCWorkLoad(rowid),"^",41)
			s totalPrice=$p(^DHCWorkLoad(rowid),"^",16)
			if $g(resDep)="" s resDep="9999"
			if $g(patDoc)="" s patDoc="9999"	
			if $g(tarEC)="" s tarEC"9999"	
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j,ordDate,resDep,patDoc,tarEC))+totalPrice		
			s ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)=$g(^||TEMPDHCWL("TestProGrobal","TimeEff",$j))+totalPrice
		}
	}
	*/
	//s time2=$p($ZTIMESTAMP ,",",2)
	//s proGblsec=time2-time1
	//k ^||TEMPDHCWL("TestProGrobal","TimeEff",$j)
	;w !,"进程global耗时"_sec_"秒" 

	//s inx=$o(^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,""),-1)
	//s inx=inx+1
	//s ^TEMPDHCWL("TestProGrobal-LOG","TimeEff",actDate,inx)=stdGblsec-proGblsec
	q
	
ErrTimeEff2
	;k ^TEMPDHCWL("TestProGrobal","TimeEff",$j)
	q
}

}
