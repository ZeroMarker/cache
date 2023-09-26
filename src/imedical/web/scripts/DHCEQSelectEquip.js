function Init()
{
	var obj=document.getElementById("AllSelect");
	if (obj) obj.onclick=AllSelect_click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_click;
}
function BClose_click()
{
	window.close();
}
function BOK_click()
{
	var tbl=document.getElementById('tDHCEQSelectEquip');	//????????
	var row=tbl.rows.length;
	var ReturnStrs=""
		
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj&&obj.checked)
		{
			var EquipID=""
			var EquipName=""
			var obj=document.getElementById('TRowID'+'z'+iLLoop);
			if (obj) EquipID=obj.value;
			var obj=document.getElementById('TName'+'z'+iLLoop);
			if (obj) EquipName=obj.innerText;
			if (ReturnStrs==""){
				ReturnStrs=EquipName+"^"+EquipID;
			}
			else{
				ReturnStrs=ReturnStrs+"&&"+EquipName+"^"+EquipID;
			}
			
			//alertShow(EquipID)
		}
	}
	if (ReturnStrs==""){
		alertShow(t["NoSelect"])
		return;
	}
	if (opener){
		opener.InsertEquip(ReturnStrs);
	}
	window.close();
}
function AllSelect_click()
{
	var tbl=document.getElementById('tDHCEQSelectEquip');	//????????
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj) { obj.checked=!obj.checked; }
	}
}
document.body.onload = Init;
