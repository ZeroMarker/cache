function InitMe()
{
	var TblArr=document.getElementsByName('tDHCPEResultSum');
	var NormalFlag,ResultStr;
	for (var i=0; i<TblArr.length; i++)	{
		var TblObj=TblArr[i];
		for(var j=1;j<TblObj.rows.length;j++){
			var RowObj=TblObj.rows[j];
			for (k=0; k<RowObj.all.length; k++)	{
				var ItemObj=RowObj.all[k]
				if (ItemObj.id=='TNormalFlagz'+j) {NormalFlag=ItemObj.value;};
				if (ItemObj.id=='TOrderDetailz'+j) {
					if (NormalFlag=="0"){
						ItemObj.style.color="red";
					}
				}
			}
			
		}	
	}
}