$(function(){
	initDocument();
});

function initDocument()
{
	var url="dhceq.rm.rentlist.csp?";
	$('#RentList').attr('src', url);
	$HUI.tabs("#tRentStatTabs",{
		onSelect:function(title)
		{
			if (title=="���빲����Դͳ��")
			{
				var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQShareEquipStatA.raq";
				$('#RentStatistic').attr('src', url);
			}
			else if (title=="������Դ�ֲ���")
			{
				var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQShareStateA.raq";
				$('#RentState').attr('src', url);
			}
			else if (title=="������ϸ")
			{
				var url="dhceq.rm.rentlist.csp?";
				$('#RentList').attr('src', url);
			}
		}
	});
}