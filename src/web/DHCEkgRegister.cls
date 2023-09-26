Class web.DHCEkgRegister Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetRegInfo(oeorditemdr As %String) As %String
{
	s MainDoc="",AssDoc="",EQGroupDesc="",EQGroupDr="",No="",BodyDr="",BodyInfo=""
	s regrowid="",StudyNo="",strRegDate="",strRegTime="",Index="",EQDesc="",RoomDesc="",RoomDr="",EQDescdr=""
	s ssuserdr="",Memoinfo="",RoomIndex="",ReportInfo="",CheckGroupIndex="",PaadMdr=""

	s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	i regrowid '="" d 
	.s ^DHCPACRegInfo(regrowid)=$g(^DHCPACRegInfo(regrowid))
	.s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	.s ReportInfo=$p(^DHCPACRegInfo(regrowid),"^",19)
	.s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	.s strRegDate=$zd(RegDate,3)
	.s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	.s strRegTime=$zt(RegTime,1)
	.s PaadMdr=$p(^DHCPACRegInfo(regrowid),"^",10) //add by sunyi 20091230
	.s MainDocDr=$p(^DHCPACRegInfo(regrowid),"^",5)
	.i MainDocDr'="" d 
	..s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
	..i $g(^DHCRisGetNameSet)="ID" s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",3)
	..s ssuserdr=$o(^SSU("SSUSR",0,"CTPCP",MainDocDr,0))
    .s assDocDr=$p(^DHCPACRegInfo(regrowid),"^",6)
	.i assDocDr'="" d
	..s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",2)
	..i $g(^DHCRisGetNameSet)="ID" s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",3)
    .s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	.s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	.i EQDescdr'="" s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	.s RoomDr=$p(^DHCPACRegInfo(regrowid),"^",16)
	.i RoomDr'="" s RoomDesc=$p(^DHCRBC("Room",RoomDr),"^",2)
	.s EQGroupDr=$p(^DHCPACRegInfo(regrowid),"^",17)
	.i EQGroupDr'="" s EQGroupDesc=$p($g(^RBC("GRP",EQGroupDr)),"^",2)
	.s Nodr=$p(^DHCPACRegInfo(regrowid),"^",3) 
	.i Nodr'="" s No=$p(^DHCPACRegInfoNO("NO",0,Nodr),"^",3)
	.s Memoinfo=$p(^DHCPACRegInfo(regrowid),"^",20)   //呼叫状态
	.s RoomIndex=$p(^DHCPACRegInfo(regrowid),"^",24)   //诊室流水号 20080611 qzg
	.s CheckGroupIndex=$p(^DHCPACRegInfo(regrowid),"^",28) //资源组流水号 20090323 sunyi
	.s BodyInfo="",Num=0
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	..i BodyDr'="" d
	...s Num=Num+1
	...s BodyDesc=$p($g(^MRC("BODP",BodyDr)),"^",2)
	...if BodyInfo="" s BodyInfo=BodyDesc
	...else  d
	....s BodyInfo=BodyInfo_"~"_BodyDesc
	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_BodyInfo_"^"_Memoinfo_"^"_RoomIndex_"^"_ReportInfo_"^"_CheckGroupIndex_"^"_BillFlag
	s ^DHCRis("0930")=Info
	q Info
}

}
