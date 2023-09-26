///入库审核,转移出库审核,转移入库审核,库存调整审核,库存报损审核,退货审核

///检查明细部分高值材料条码问题
///Return: false 需进一步维护; true 满足审核条件
function CheckHighValueLabels(type,main){
	var url = "dhcstm.itmtrackaction.csp?actiontype=CheckLabelsByPointer&Type="+type+"&Main="+main;
	var result=ExecuteDBSynAccess(url);
	var info=Ext.util.JSON.decode(result).info;		//高值材料条码判断结果
	if(info!=""){
		Msg.info("error","高值材料 "+info+" 没有录入条码或录入的条码数与入库数量不符!")
		return false;
	}
	return true;
}
