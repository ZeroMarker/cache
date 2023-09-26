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
			if (title=="借入共享资源统计")
			{
				var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQShareEquipStatA.raq";
				$('#RentStatistic').attr('src', url);
			}
			else if (title=="共享资源分布表")
			{
				var url="dhceq.rm.rentstatistics.csp?ReportFileName=DHCEQShareStateA.raq";
				$('#RentState').attr('src', url);
			}
			else if (title=="租赁明细")
			{
				var url="dhceq.rm.rentlist.csp?";
				$('#RentList').attr('src', url);
			}
		}
	});
}