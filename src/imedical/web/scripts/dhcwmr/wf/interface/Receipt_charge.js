//病案将挡收费程序
function FilingCharge(MrTypeID,MrNo,LogonLocID,LogonUserID)
{
	var flg = tkMakeServerCall("DHCWMR.MFService.FeeRecordSrv","ReceiptCharge",MrTypeID,MrNo,LogonLocID,LogonUserID);
	if (flg<1){
		alert("建档收费失败！")
		return;
	}
}

function Filingrefund(FeeRecordID,LogonLocID,LogonUserID)
{
    var flg = tkMakeServerCall("DHCWMR.MFService.FeeRecordSrv","Filingrefund",FeeRecordID,LogonLocID,LogonUserID);
	if (flg<1){
		alert("建档退费失败！")
		return;
	}
}