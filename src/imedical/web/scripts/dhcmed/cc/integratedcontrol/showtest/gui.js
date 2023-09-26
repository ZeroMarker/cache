function ShowTestWin(PatientID, OrderID, LabTestNo)
{
	var obj = new Object();
	var strURL = "./dhclabdoctorreport.csp?PatientID=" + PatientID + 
			"&TestSetRow=" + LabTestNo +
			"&OrderID="+ OrderID;
	obj.objWin = new Ext.Window(
		{
			title:"辅助检查结果",
			html:"<iframe id='labWin' height='420' width='800' src='" + strURL + "'/>",
			height:500,
			width:800,
			modal:true,
			buttons:[
				{
					text : "关闭",
					handler: function()
					{
						obj.objWin.close();
					}
				}
			]
			
		}
	);
	
	
	obj.objWin.show();
	return obj;
}