///重置当前操作牙的牙面信息
function ResetSurface(flag,currentSelectToothID)
{
	//每个牙面按钮重置为unchecked状态
	var SurfaceItems = SurfaceItemStr.split(",");
	for (var i=0;i<SurfaceItems.length ;i++ )
	{
		var SurfaceItemCode = SurfaceItems[i];
		$("#Surface-"+SurfaceItemCode).attr("name","unchecked");
		$("#Surface-"+SurfaceItemCode).css("color","#666666");
		$("#Surface-"+SurfaceItemCode).css("background","#EFEFEF");  //:;color:
	}

	//清空当前牙齿的牙面全局变量数据
	currSelectSurfaceArray.splice(0,currSelectSurfaceArray.length);
	currSelectSurfaceIDArray.splice(0,currSelectSurfaceIDArray.length);
	currSelectSurfaceStr = "";
	currSelectSurfaceIDStr = "";

	//清空相应text框中的牙面数据
	if (flag == "delete")
	{
		$('#text-Surface-'+currentSelectToothID).val("");
		$('#text-Surface-'+currentSelectToothID).attr("text","");
	}
}

function beforeSelectSurface(cuurSurfaceItemID)
{
	if (currentToothID == "")
	{
		$.messager.alert("提示","请先选择牙位!");
		return;
	}
	else
	{
		selectSurface(currentToothID,cuurSurfaceItemID);
	}
}

function selectSurface(ToothID,cuurSurfaceItemID){
	var currSurfaceItem = document.getElementById(cuurSurfaceItemID);
    if (JSON.stringify(currSurfaceItem) !== "null"){
		var Text = currSurfaceItem.innerText.replace(/\s/g,"");
	}else {
		var Text = ""
	}
	if ($("#"+cuurSurfaceItemID).attr("name") == "unchecked")
	{
		//currSelectSurfaceArray.push(currSurfaceItem.innerText.replace(/\s/g,""));
		currSelectSurfaceArray.push(Text);
		currSelectSurfaceIDArray.push(cuurSurfaceItemID);
		$("#"+cuurSurfaceItemID).attr("name","checked");
		$("#"+cuurSurfaceItemID).css("color","#FFFFFF");
		$("#"+cuurSurfaceItemID).css("background","#40A2DE");
	}
	//取消选中牙面
	else if ($("#"+cuurSurfaceItemID).attr("name") == "checked")
	{
		for (var i=currSelectSurfaceArray.length-1 ;i>=0 ;i-- )
		{
			if (currSelectSurfaceArray[i]== Text)
			{
				currSelectSurfaceArray.splice(i,1);
			}
		}
		for (var j=currSelectSurfaceIDArray.length-1 ;j>=0 ;j-- )
		{
			if (currSelectSurfaceIDArray[j]== cuurSurfaceItemID)
			{
				currSelectSurfaceIDArray.splice(j,1);
			}
		}
		$("#"+cuurSurfaceItemID).attr("name","unchecked");
		$("#"+cuurSurfaceItemID).css("color","#666666");
		$("#"+cuurSurfaceItemID).css("background","#EFEFEF");
	}
	
	currSelectSurfaceStr = currSelectSurfaceArray.toString();
	currSelectSurfaceIDStr = currSelectSurfaceIDArray.toString();
	setSurface("text-Surface-"+ToothID,currSelectSurfaceStr,currSelectSurfaceIDStr);
}

//给牙面信息框赋值
function setSurface(currentTextSurface,currSelectSurfaceStr,currSelectSurfaceIDStr)
{
	$('#'+currentTextSurface).val(currSelectSurfaceStr);
	$('#'+currentTextSurface).attr("text",currSelectSurfaceIDStr);
	document.getElementById(currentTextSurface).innerHTML = currSelectSurfaceStr;
}