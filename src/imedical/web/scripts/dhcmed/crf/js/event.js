///作者：李阳
///日期：2014-11-22
///功能：用于在日期框、字典框失去焦点后隐藏选项列表


window.onload = function(){
	//debugger;
	var arry = document.getElementsByTagName("input");
	for(var i = 0; i < arry.length; i ++)
	{
	//alert(arry[i].id + "  " + arry[i].controltype);
		var objCtl = arry[i];
		objCtl.onfocus = Control_foucus;
	}


}

function Control_foucus()
{
	var e = window.event;
	var objCtl = e.srcElement;

	var arryCtl = document.getElementsByTagName("input");
	for(var i = 0; i < arryCtl.length; i ++)
	{
		var t = arryCtl[i];
		switch(t.controltype)
		{
			//用于在日期框失去焦点后隐藏选项框
			case "datetext":
				if(t.id != objCtl.id)
				{
					var objTbl = document.all("div_dtTable_" + t.id);
					if (objTbl != null)
					{
						if(objTbl.style.visibility == "visible")
							_dt2_closeDTTable(t.id);
					}
				}
				break;
			case "dictionary":
				if(t.id != objCtl.id)
				{
					if ($("#dicDiv").length != 0)
						$("#dicDiv").remove();
				}
				break;
		}
	}
	objCtl.focus();
}