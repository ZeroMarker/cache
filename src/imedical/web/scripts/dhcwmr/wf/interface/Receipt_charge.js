//���������շѳ���
function FilingCharge(MrTypeID,MrNo,LogonLocID,LogonUserID)
{
	var flg = tkMakeServerCall("DHCWMR.MFService.FeeRecordSrv","ReceiptCharge",MrTypeID,MrNo,LogonLocID,LogonUserID);
	if (flg<1){
		alert("�����շ�ʧ�ܣ�")
		return;
	}
}

function Filingrefund(FeeRecordID,LogonLocID,LogonUserID)
{
    var flg = tkMakeServerCall("DHCWMR.MFService.FeeRecordSrv","Filingrefund",FeeRecordID,LogonLocID,LogonUserID);
	if (flg<1){
		alert("�����˷�ʧ�ܣ�")
		return;
	}
}