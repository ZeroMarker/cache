Class web.DHCUPBED Extends %RegisteredObject
{

ClassMethod UPBED()
{
 //画普通病区床位图
 //d ##class(web.DHCUPBED).UPBED()
 //update pac_wardroom set ROOM_PositionLeft=805,ROOM_PositionTop=5,ROOM_Positionwidth=155,ROOM_PositionHeight=455
 s WardId=0,del="^"
 s left=5,top=5,width=155,height=110,colnum=9
 s DateTmp=+$h
 f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
 .q:WardId'=7
 .//增加等代床
 .if '$d(^PAWARD(WardId,"ROOM"))=1 d
 ..&sql(insert into sqluser.pac_wardroom (ROOM_ParRef,ROOM_Room_DR,ROOM_PositionLeft,ROOM_PositionTop,ROOM_PositionWidth,ROOM_PositionHeight,ROOM_DateFrom) values(:WardId,1,1270,5,150,610,:DateTmp)) 
 .s BedId=0,colnumtmp=0,rownum=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..;q:$l(BedDesc,"加") >1
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..s id=WardId_"||"_BedId
 ..s lefttmp=left+(colnumtmp*(width+5)),toptmp=top+((height+5)*rownum)
 ..&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..s colnumtmp=colnumtmp+1
 ..if ((rownum<4)&((colnumtmp#(colnum-1))=0)) s rownum=rownum+1,colnumtmp=0
 ..else  if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
 .S BedId=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..q:$l(BedDesc,"加")<2
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..;s id=WardId_"||"_BedId
 ..;s lefttmp=left+(colnumtmp*(width+3)),toptmp=top+((height+3)*rownum)
 ..;&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..;s colnumtmp=colnumtmp+1
 ..;if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
}

ClassMethod UPCKBED()
{
 //画产科病区床位图	
 //d ##class(web.DHCUPBED).UPCKBED()
 //update pac_wardroom set ROOM_PositionLeft=795,ROOM_PositionTop=5,ROOM_Positionwidth=150,ROOM_PositionHeight=410
 s WardId=0,del="^"
 s left=5,top=5,width=155,height=100,colnum=4
 s DateTmp=+$h
 f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
 .q:WardId'=5   //------------------------------单独画产科床位
 .//增加等代床
 .if '$d(^PAWARD(WardId,"ROOM"))=1 d
 ..&sql(insert into sqluser.pac_wardroom (ROOM_ParRef,ROOM_Room_DR,ROOM_PositionLeft,ROOM_PositionTop,ROOM_PositionWidth,ROOM_PositionHeight,ROOM_DateFrom) values(:WardId,1,1270,5,150,610,:DateTmp)) 
 .s BedId=0,colnumtmp=0,rownum=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..;q:$l(BedDesc,"加") >1
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..s id=WardId_"||"_BedId
 ..s lefttmp=left+(colnumtmp*(width+150)),toptmp=top+((height+45)*rownum)
 ..&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..s colnumtmp=colnumtmp+1
 ..;if ((rownum<4)&((colnumtmp#(colnum-1))=0)) s rownum=rownum+1,colnumtmp=0
 ..;else  if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
 ..if ((colnumtmp#colnum)=0) s rownum=rownum+1,colnumtmp=0
 .S BedId=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..q:$l(BedDesc,"加")<2
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..s id=WardId_"||"_BedId
 ..;s lefttmp=left+(colnumtmp*(width+3)),toptmp=top+((height+3)*rownum)
 ..;&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..;s colnumtmp=colnumtmp+1
 ..;if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
}

ClassMethod UPBEDSingle()
{
 //画普通病区床位图
 //d ##class(web.DHCUPBED).UPBEDSingle()
 //update pac_wardroom set ROOM_PositionLeft=805,ROOM_PositionTop=5,ROOM_Positionwidth=155,ROOM_PositionHeight=455
 s WardId=0,del="^"
 s left=5,top=5,width=155,height=110,colnum=8
 s DateTmp=+$h
 f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
 .q:WardId'=2
 .//增加等代床
 .if '$d(^PAWARD(WardId,"ROOM"))=1 d
 ..&sql(insert into sqluser.pac_wardroom (ROOM_ParRef,ROOM_Room_DR,ROOM_PositionLeft,ROOM_PositionTop,ROOM_PositionWidth,ROOM_PositionHeight,ROOM_DateFrom) values(:WardId,1,1270,5,150,610,:DateTmp)) 
 .s BedId=0,colnumtmp=0,rownum=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..;q:$l(BedDesc,"加") >1
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..s id=WardId_"||"_BedId
 ..s lefttmp=left+(colnumtmp*(width+5)),toptmp=top+((height+5)*rownum)
 ..&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..s colnumtmp=colnumtmp+1
 ..;if ((rownum<4)&((colnumtmp#(colnum-1))=0)) s rownum=rownum+1,colnumtmp=0
 ..if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
 .S BedId=0
 .f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
 ..s BedDesc=$p(^PAWARD(WardId,"BED",BedId),del,1)
 ..q:$l(BedDesc,"加")<2
 ..q:BedDesc="无效床位"
 ..s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
 ..q:$g(BedFlag)="N"
 ..;W BedFlag,"^",BedDesc,!
 ..;s id=WardId_"||"_BedId
 ..;s lefttmp=left+(colnumtmp*(width+3)),toptmp=top+((height+3)*rownum)
 ..;&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
 ..;s colnumtmp=colnumtmp+1
 ..;if (colnumtmp#colnum)=0 s rownum=rownum+1,colnumtmp=0
}

}
