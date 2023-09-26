/// Created by ZY ZY0085 2012-11-11
Class web.DHCEQIUseRecordQueue Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(RowID, val, Type)
{
	n CurDate,CurTime,SQLCODE,BussID,StartDate,StartTime,EndDate,EndTime
	k PLIST
	s CurDate = +$H
 	s CurTime = $P($H,",",2)
	if +Type=0
	{
		//pacs系统中的BussID太长,自己做了个计数器
		s BussID=$g(^DHCEQIUseRecordQueue(0,"Ex"))
		s BussID=BussID+1
		s ^DHCEQIUseRecordQueue(0,"Ex")=BussID
	 	//OrderID_""_DeviceID_""_ItemID_""_BussID_""_UseLocID_""_UseDate_""_WorkLoadNum_""_Price_""_TotalFee_""_PatientInfo_""_StartDate_""_StartTime_""_EndDate_""_EndTime_""_Operator
		s PLIST(2)="Pacs"	;ExType
		s PLIST(3)=$p(val,"^",2)	;ExDeviceID
		s PLIST(4)=$p(val,"^",3)	;ExItemID
		s PLIST(5)=BussID			;ExBussID
		s PLIST(6)=$p(val,"^",5)	;ExUseLocID
		s PLIST(7)=+$ZDTh($p(val,"^",6),3)	;UseDate
		s PLIST(8)=$p(val,"^",7)	;WorkLoadNum
		s PLIST(9)=$p(val,"^",8)	;Price
		s PLIST(10)=$p(val,"^",9)	;TotalFee
		s PLIST(11)=$p(val,"^",10)	;PatientInfo
		s StartDate=$ZDTh($p(val,"^",11),3)
		s StartTime=$p(StartDate,",",2)
		s PLIST(12)=+StartDate		;StartDate
		s PLIST(13)=+StartTime		;StartTime
		s EndDate=$ZDTh($p(val,"^",13),3)
		s EndTime=$p(EndDate,",",2)
		s PLIST(14)=+EndDate		;EndDate
		s PLIST(15)=+EndTime			;EndTime
		s PLIST(16)=$p(val,"^",15)	;Operator
		s PLIST(17)=$p(val,"^",1)	;OtherInfo	//遗嘱号,可以到his中取费用
		s PLIST(18)="N"				;CancelFlag
		s PLIST(19)=BussID_","_$p(val,"^",4)	;Remark  自己的计数器和pacs中的id存在一起
		//s PLIST(20)=$p(val,"^",1)	;Hold1
		//s PLIST(21)=$p(val,"^",1)	;Hold2
		//s PLIST(22)=$p(val,"^",1)	;Hold3
		//s PLIST(23)=$p(val,"^",1)	;Hold4
		//s PLIST(24)=$p(val,"^",1)	;Hold5
		//s PLIST(25)=$p(val,"^",1)	;Hold6
		s PLIST(26)=CurDate			;AddDate
		s PLIST(27)=CurTime			;AddTime
		//s PLIST(28)=$p(val,"^",1)	;FinishDate
		//s PLIST(29)=$p(val,"^",1)	;FinishTime
		//s PLIST(30)=$p(val,"^",1)	;LastExecuteDate
		//s PLIST(31)=$p(val,"^",1)	;LastExecuteTime
		//s PLIST(32)=$p(val,"^",1)	;ExecuteTimes
		s PLIST(33)="0"				;Status
		
		if RowID=""
		{
			&SQL(Insert Into SQLUSER.DHC_EQIUseRecordQueue Values :PLIST())
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQIUseRecordQueue Values :PLIST() where URQ_RowID=:RowID)
		}
	}
	elseif +Type=1
	{
		s PLIST(33)=val				;Status
		&SQL(Update SQLUSER.DHC_EQIUseRecordQueue Values :PLIST() where URQ_RowID=:RowID)
	}
	q SQLCODE
}

}
