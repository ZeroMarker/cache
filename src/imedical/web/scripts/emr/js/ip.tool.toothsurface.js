///���õ�ǰ��������������Ϣ
function ResetSurface(flag,currentSelectToothID)
{
	//ÿ�����水ť����Ϊunchecked״̬
	var SurfaceItems = SurfaceItemStr.split(",");
	for (var i=0;i<SurfaceItems.length ;i++ )
	{
		var SurfaceItemCode = SurfaceItems[i];
		$("#Surface-"+SurfaceItemCode).attr("name","unchecked");
		$("#Surface-"+SurfaceItemCode).css("color","#666666");
		$("#Surface-"+SurfaceItemCode).css("background","#EFEFEF");  //:;color:
	}

	//��յ�ǰ���ݵ�����ȫ�ֱ�������
	currSelectSurfaceArray.splice(0,currSelectSurfaceArray.length);
	currSelectSurfaceIDArray.splice(0,currSelectSurfaceIDArray.length);
	currSelectSurfaceStr = "";
	currSelectSurfaceIDStr = "";

	//�����Ӧtext���е���������
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
		$.messager.alert("��ʾ","����ѡ����λ!");
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
	//ȡ��ѡ������
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

//��������Ϣ��ֵ
function setSurface(currentTextSurface,currSelectSurfaceStr,currSelectSurfaceIDStr)
{
	$('#'+currentTextSurface).val(currSelectSurfaceStr);
	$('#'+currentTextSurface).attr("text",currSelectSurfaceIDStr);
	document.getElementById(currentTextSurface).innerHTML = currSelectSurfaceStr;
}