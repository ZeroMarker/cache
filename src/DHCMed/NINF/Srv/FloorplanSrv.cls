/// 名称: DHCMed.NINF.Srv.FloorplanSrv
/// 描述: 床位图初始化相关程序
/// 编写者：zhufei
/// 编写日期: 2013-06-16
Class DHCMed.NINF.Srv.FloorplanSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-06-16
/// Description:  自动生成床位图初始化数据
/// Table：       PAC_Bed(床位图)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.FloorplanSrv).ProcessDataToPACBed(269)
ClassMethod ProcessDataToPACBed(aWardID As %String) As %String
{
	New (aWardID)
	
	Set xWardID=0
	For {
		Set xWardID=$o(^PAWARD(xWardID))
		Quit:xWardID=""
		Continue:aWardID'=xWardID
		
		//按房间号、床位排序
		Set NIndex="ProcessDataToPACBed"
		Kill ^TMP($zn,$j,NIndex)
		Set xBedID=0
		For {
			Set xBedID=$o(^PAWARD(xWardID,"BED",xBedID))
			Quit:xBedID=""
			
			Set ActiveFlag=$p($g(^PAWARD(xWardID,"BED",xBedID)),"^",4)
			Continue:ActiveFlag'="Y"
			Set BedCode=$p($g(^PAWARD(xWardID,"BED",xBedID)),"^",1)
			Set:$p(BedCode,"-",2)'="" BedCode=+$p(BedCode,"-",2)
			Set RoomID=$p($g(^PAWARD(xWardID,"BED",xBedID)),"^",3)
			Set RoomDesc=$p($g(^PAROOM(+RoomID)),"^",2)
			Set:$p(RoomDesc,"-",2)'="" RoomDesc=+$p(RoomDesc,"-",2)
			
    		Set ^TMP($zn,$j,NIndex,RoomDesc,BedCode)=xWardID_"||"_xBedID
		}
		
		//取床位信息，生成床位图初始化数据
		Set Count=0
		Set xRoom=""
		For {
			Set xRoom=$o(^TMP($zn,$j,NIndex,xRoom))
			Quit:xRoom=""
			
			Set xBed=""
			For {
				Set xBed=$o(^TMP($zn,$j,NIndex,xRoom,xBed))
				Quit:xBed=""
				
				Set Count=Count+1
				
				//设定床位图一排四张床
				Set ColNum=5
				Set Row=(Count\ColNum)
				Set Col=(Count#ColNum)
				If Col=0 {
					Set Col=ColNum
				} Else {
					Set Row=Row+1
				}
				
				//设置坐标、宽度、高度
				Set Top=5+(125*(Row-1))
				Set Left=5+(165*(Col-1))
				Set Width=160
				Set Height=120
				
				//w xRoom_","_xBed_","_Left_","_Top_","_Width_","_Height,!
				
				//保存床位信息
				Set BedID=$g(^TMP($zn,$j,NIndex,xRoom,xBed))
				Set obj=##class(User.PACBed).%OpenId(BedID)
				Continue:'$IsObject(obj)
				Set obj.BEDPositionLeft=Left
				Set obj.BEDPositionTop=Top
				Set obj.BEDPositionWidth=Width
				Set obj.BEDPositionHeight=Height
				Set sc=obj.%Save()
				If $System.Status.IsError(sc) {
			   		Do $System.OBJ.DisplayError(sc)
				}
				Do obj.%Close()
			}
		}
		Kill ^TMP($zn,$j,NIndex)
	}
	
	Quit "OK"
}

}
