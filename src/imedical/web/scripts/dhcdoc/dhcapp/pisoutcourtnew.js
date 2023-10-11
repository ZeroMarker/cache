function Init(){
	GetIsWritePisFlag();      /// 是否可填写判断

}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
	ItemMastOn_Map.apply(null, arguments);
	
	}
function ItemMastOff(itmmast){
	ItemMastOff_Map.apply(null, arguments);
}
function SaveOtherInfo(){
	return "";
}
function LoadOtherInfo(itemReqJsonStr){
}

/// 是否允许填写申请单
function GetIsWritePisFlag(){
	
	GetIsWritePisFlag_Map.apply(null, arguments);
}
         