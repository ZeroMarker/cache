Class web.DHCPE.DriverPrint [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPatInfo(PAADM)
{
	s LeftODDR="5||22"
	s RightODDR="5||23"
	s (LeftFlag,RightFlag)=0
	s RLTID=$o(^DHCPERLT(0,"PAADM_OD",PAADM,LeftODDR,0))
	i RLTID'="" d
	.s LeftResult=$P($G(^DHCPERLT(RLTID)),"^",4)
	.i LeftResult="是" s LeftFlag=1
	s RLTID=$o(^DHCPERLT(0,"PAADM_OD",PAADM,RightODDR,0))
	i RLTID'="" d
	.s RightResult=$P($G(^DHCPERLT(RLTID)),"^",4)
	.i RightResult="是" s RightFlag=1
	s ID=$P(^PAADM(PAADM),"^",1)
	s Name=$P(^PAPER(ID,"ALL"),"^",1)
	s DOB=$P(^PAPER(ID,"ALL"),"^",6)
	i DOB'="" s DOB=$ZD(DOB,3)
	//s DOB=$p(##class(web.DHCLCNUREXCUTE).CalAge(DOB,+$h),"Y",1)
	s Sex=$P(^PAPER(ID,"ALL"),"^",7)
	i Sex'="" s Sex=$p($g(^CT("SEX",Sex)),"^",2)
	s Date=$ZD(+$H,3)
	q LeftFlag_RightFlag_"^"_Name_"^"_Sex_"^"_DOB_"^"_Date
}

//w ##class(web.DHCPE.DriverPrint).GetResult("2563399","5||19")

ClassMethod GetResult(PAADM, ODDR)
{
	s result=""
	s RLTID=$o(^DHCPERLT(0,"PAADM_OD",PAADM,ODDR,0))
	i RLTID'="" d
	.s result=$P($G(^DHCPERLT(RLTID)),"^",4)
	q result
}

}
