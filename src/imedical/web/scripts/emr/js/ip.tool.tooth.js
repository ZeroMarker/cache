//页面初始化执行
$(function(){
	/*
	//var selectedTeeth = window.dialogArguments || "";
	alert("selectedToothObjStr:" + selectedToothObjStr);
	if (selectedToothObjStr != "")
	{
        if ((parent)&&(parent.getSelectedToothObj)){
            var selectedTeeth = parent.getSelectedToothObj();
        }else {
			//var selectedTeeth = JSON.parse(unescape(utf8to16(base64decode(selectedToothObjStr)))); 
			var selectedTeeth = JSON.parse(selectedToothObjStr); 
        }
	}else{
		var selectedTeeth = ""; 
	}
	*/
	getToothRepresentation();
	getToothPosition();
	getToothSurface();
	
	//var selectedToothObj = window.dialogArguments || "";
	/*
	var selectedToothObj = parent.selectedToothObj;
	if (selectedToothObj !== "")
	{
		InitOperedTooth(selectedToothObj);
	}
	*/
	//$("#ToothPermanent").click();
    $HUI.radio("[name='Radio']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "ToothPermanent")
            {
	            //恒牙全选按钮
	            $(".flagPermanent").css("display","");
			    $("#ToothPermanent").attr("checked",true);
				$("#ToothDeciduous").attr("checked",false);
				$(".Deciduous").hide();
				$("#toothDIV").css("padding-left","10px");
				
				$("#ToothAll").attr("checked",false);
				$("#toothDIV").css("padding-top","40px");
				$("#toothDIV").css("height","220px");
				$(".box").css("height","85px");
				$(".textSurface").css("height","60px");
				$(".textTP").css("padding-top","5px");
				$("#FlagRight").css("padding-top","85px");
				$("#FlagLeft").css("padding-top","85px");
				$("#addToRecord").css("margin-top","25px");
				
				$(".Permanent").show();
	        } 
	        else if (value === "ToothAll")
	        {
				$("#ToothPermanent").attr("checked",false);
				$("#ToothDeciduous").attr("checked",false);
		        $(".tdleftDeciduous").css("padding-left","182px");
	            $(".flagPermanent").css("display","none");
				$("#toothDIV").css("padding-left","10px");
				
				$("#ToothAll").attr("checked",true);
				$("#toothDIV").css("padding-top","5px");
				$("#toothDIV").css("height","310px");
				$(".box").css("height","55px");
				$(".textSurface").css("height","37px");
				$(".textTP").css("padding-top","0px");
				$("#FlagRight").css("padding-top","150px");
				$("#FlagLeft").css("padding-top","150px");
				$("#addToRecord").css("margin-top","0px");
				
				$(".Permanent").show();
				$(".Deciduous").show();
		    }
	        else
	        {
		        //恒牙全选按钮
	            $(".flagPermanent").css("display","none");
	            //去掉乳牙中的padding-left
	            $(".tdleftDeciduous").css("padding-left",0);
				$("#ToothPermanent").attr("checked",false);
				$("#ToothDeciduous").attr("checked",true);
				$(".Permanent").hide();
				$("#toothDIV").css("padding-left","190px");
				
				$("#ToothAll").attr("checked",false);
				$("#toothDIV").css("padding-top","40px");
				$("#toothDIV").css("height","220px");
				$(".box").css("height","85px");
				$(".textSurface").css("height","60px");
				$(".textTP").css("padding-top","5px");
				$("#FlagRight").css("padding-top","100px");
				$("#FlagLeft").css("padding-top","100px");
				$("#addToRecord").css("margin-top","25px");
				
				$(".Deciduous").show();
		    }
        }
    });
	if ((parent)&&(parent.getSelectedToothObj)){
        var selectedToothObj = parent.getSelectedToothObj();
		if (selectedToothObj !== "")
		{
			InitOperedTooth(selectedToothObj);
		}else{
			//选中恒牙
    		setDefaultRadio();
		}
    }else{
	    	//选中恒牙
    		setDefaultRadio();
	    }
},0);
    //根据科室配置选中对应的radio
function setDefaultRadio(){ 
	try{
		var defaultRadioObj = JSON.parse(defaultRadio);
		var allStr = defaultRadioObj.ToothAll;
		var PStr = defaultRadioObj.ToothP;
		var DStr = defaultRadioObj.ToothD;
		var reg = new RegExp("\\b"+userLocID+"\\b","g");
		if(PStr&&PStr.search(reg)!==-1){
			//选中恒牙
			$HUI.radio("#ToothPermanent").setValue(true);
		}else if(DStr&&DStr.search(reg)!==-1){
			//选中乳牙
			$HUI.radio("#ToothDeciduous").setValue(true);			
		}else if(allStr&&allStr.search(reg)!==-1){
			//选中混合牙
			$HUI.radio("#ToothAll").setValue(true);				
		}else{
			//选中恒牙
			$HUI.radio("#ToothPermanent").setValue(true);			
		}
		
	}catch(e){
			//选中恒牙
			$HUI.radio("#ToothPermanent").setValue(true);			
	}	
}
function getToothRepresentation()
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.Tooth.cls", 
        data: "Action=TR", 
        error: function(d)
		{
			alert("获取初始化牙位编码系统信息失败!");
        }, 
        success: function(d)
		{
			if (d == "-1")
			{
				alert("获取初始化牙位编码系统信息失败!");
			}
			else
			{
				var strJson = eval("("+d+")");
            	setToothRepresentation(strJson);
			}
        }
    });
}

function setToothRepresentation(strJson)
{
	var count = strJson.TotalCount;
	var TRData = strJson.Data;
	 
	for (var i=0;i<count ;i++ )
	{
		ToothCodeSystem = TRData[i].Code;
		ToothCodeSystemName = TRData[i].Name;
		ToothSurfaceCodeSystem = TRData[i].Code;
		ToothSurfaceCodeSystemName = TRData[i].Name;
		$("#BSFText").html(emrTrans("当前：" + ToothCodeSystemName));
	}
}

function getToothPosition(){
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.Tooth.cls", 
        data: "Action=TP", 
        error: function(d)
		{
			alert("获取初始化牙位信息失败!");
        }, 
        success: function(d)
		{
			var strJson = eval("("+d+")");
            setToothPosition(strJson);
        }
    });
}

function setToothPosition(strJson)
{
	var count = strJson.TotalCount;
	var TPData = strJson.Data;
	 
	for (var i=0;i<count ;i++ )
	{
		var TPCode = TPData[i].Code;
		var TPDesc = TPData[i].Desc;
		var TPDefine = TPData[i].Define;
		var TPAreaType = TPData[i].Quadrant;
		var ToothID = TPCode.replace('.','-');
		var ToothObj = document.getElementById(ToothID);

		$("#"+ToothID).attr("text",TPDefine);
		$("#"+ToothID).attr("areatype",TPAreaType);
		$("#tp-"+ToothID).html(TPDesc);
	}
}

function getToothSurface()
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.Tooth.cls", 
        data: "Action=TS", 
        error: function(d)
		{
			alert("获取初始化牙面信息失败!");
        }, 
        success: function(d)
		{
			var strJson = eval("("+d+")");
            setToothSurface(strJson);
        }
    });
}

function setToothSurface(strJson)
{
	var count = strJson.TotalCount;
	var TSData = strJson.Data;
	 
	for (var i=0;i<count ;i++ )
	{
		var SurfaceCode = TSData[i].SurfaceCode;
		var SurfaceDefine = TSData[i].SurfaceDefine;
		var SurfaceItemDesc = TSData[i].ToothSIDes;

		$("#Surface-"+SurfaceCode).attr("text",SurfaceDefine);
		//$("#Surface-"+SurfaceCode).linkbutton({ text:SurfaceItemDesc });
	}
}

//初始化有处置操作的牙位
function InitOperedTooth(selectedTeeth) {
	//双击病历中十字星牙位图片时,会有已选中的牙位数据,需要渲染到页面中;、
	//alert(selectedTeeth);
	//alert("ShowMode:" + selectedTeeth.ShowMode);
	//return;
	if (selectedTeeth !== "")
	{
		var ShowMode = selectedTeeth.ShowMode;
		if (ShowMode == "恒牙")
        {
		    $("#ToothPermanent").attr("checked",true);
			$("#ToothDeciduous").attr("checked",false);
			$("#ToothAll").attr("checked",false);
			$(".Deciduous").hide();
			$("#toothDIV").css("padding-left","10px");
			$("#toothDIV").css("padding-top","40px");
			$("#toothDIV").css("height","220px");
			$(".box").css("height","85px");
			$(".textSurface").css("height","60px");
			$(".textTP").css("padding-top","5px");
			$("#FlagRight").css("padding-top","85px");
			$("#FlagLeft").css("padding-top","85px");
			$("#addToRecord").css("margin-top","25px");
			
			$(".Permanent").show();
			//选中恒牙
    		$HUI.radio("#ToothPermanent").setValue(true);
        } 
        else if (ShowMode == "混合牙")
        {
	        $("#ToothPermanent").attr("checked",false);
			$("#ToothDeciduous").attr("checked",false);
			$("#ToothAll").attr("checked",true);
			$("#toothDIV").css("padding-left","10px");
			$(".tdleftDeciduous").css("padding-left","182px");
			$("#ToothAll").attr("checked",true);
			$("#toothDIV").css("padding-top","5px");
			$("#toothDIV").css("height","310px");
			$(".box").css("height","55px");
			$(".textSurface").css("height","37px");
			$(".textTP").css("padding-top","0px");
			$("#FlagRight").css("padding-top","150px");
			$("#FlagLeft").css("padding-top","150px");
			$("#addToRecord").css("margin-top","0px");
			
			$(".Permanent").show();
			$(".Deciduous").show();
			//选中恒牙
    		$HUI.radio("#ToothAll").setValue(true);
	    }
        else
        {
			$("#ToothPermanent").attr("checked",false);
			$("#ToothDeciduous").attr("checked",true);
			$("#ToothAll").attr("checked",false);
			$(".Permanent").hide();
			$("#toothDIV").css("padding-left","190px");
			
			
			$("#toothDIV").css("padding-top","40px");
			$("#toothDIV").css("height","220px");
			$(".box").css("height","85px");
			$(".textSurface").css("height","60px");
			$(".textTP").css("padding-top","5px");
			$("#FlagRight").css("padding-top","100px");
			$("#FlagLeft").css("padding-top","100px");
			$("#addToRecord").css("margin-top","25px");
			
			$(".Deciduous").show();
			//选中恒牙
    		$HUI.radio("#ToothDeciduous").setValue(true);
	    }
		//alert(JSON.stringify(selectedTeeth.UpLeftAreaTeeth));
		var UpLeftAreaTeethObj = selectedTeeth.UpLeftAreaTeeth;
		getToothInfo(UpLeftAreaTeethObj);

		var UpRightAreaTeethObj = selectedTeeth.UpRightAreaTeeth;
		getToothInfo(UpRightAreaTeethObj);

		var DownLeftAreaTeethObj = selectedTeeth.DownLeftAreaTeeth;
		getToothInfo(DownLeftAreaTeethObj);

		var DownRightAreaTeethObj = selectedTeeth.DownRightAreaTeeth;
		getToothInfo(DownRightAreaTeethObj);

		ResetSurface("push","");
		
	}
	
	if (currentToothID !== "")
	{
		$("#"+currentToothID).css("background-color","");
	}

	currentToothID = "";
	/*$("#ToothDSY").html("主牙");
	$("#ToothDSY1").attr("name","unchecked");
	$("#ToothDSY1").css("color","blue");
	$("#ToothDSY2").attr("name","unchecked");
	$("#ToothDSY2").css("color","blue");*/
}

//将每个象限的已选择牙位信息json对象解析出来
function getToothInfo(selectedTeethJson)
{
	if ((selectedTeethJson !== "")&&(selectedTeethJson !== undefined)&&(selectedTeethJson.length !== 0))
	{
		var ToothCount = selectedTeethJson.length;
		for (var i=0;i<ToothCount ;i++ )
		{
			//获取牙位信息
			var selectToothItem = selectedTeethJson[i];
			//alert(selectToothItem);
			var ToothCode = selectToothItem.ToothInCode;
			//alert(ToothCode);
			var ToothValue = selectToothItem.ToothValue;
			//alert(ToothValue);
			var ToothSurfaceValue = selectToothItem.ToothSurfaceValue;
			//alert(ToothSurfaceValue);
			//选中相应的牙位
			var ToothID = ToothCode.replace('.','-');
			//alert(ToothID);
			selectTooth(ToothID);
			//alert(selectToothItem.ToothSurfaceItems.length);
			//获取牙面信息
			var ToothSurfaceItems = selectToothItem.ToothSurfaceItems;
			if ((ToothSurfaceItems.length !== "")||(ToothSurfaceItems.length !== 0))
			{
				var SurfaceCount = ToothSurfaceItems.length;
				for (var j=0;j<SurfaceCount ;j++ )
				{
					var SurfaceItem = ToothSurfaceItems[j];
					var SurfaceCode = SurfaceItem.InCode;
					var SurfaceID = "Surface-" + SurfaceCode.split(".")[2];
					//选中相应的牙位的牙面
					//alert(SurfaceID);
					selectSurface(ToothID,SurfaceID);
				}
			}
		}
	}
}

//显示所有
/*$("#ToothAll").click(function(){
	$(".Permanent td a").linkbutton('enable');
	$(".Deciduous td a").linkbutton('enable');
});*/

//显示恒牙
$("#ToothPermanent").click(function(){
	$("#ToothPermanent").attr("checked",true);
	$("#ToothDeciduous").attr("checked",false);
	//$(".Permanent td a").linkbutton('enable');
	//$(".Deciduous td a").linkbutton('disable');
	$(".Deciduous").hide();
	//$(".Deciduous").hide();
	$("#toothDIV").css("padding-left","10px");
	//$(".Permanent td a").show();
	$(".Permanent").show();
});

//显示乳牙
$("#ToothDeciduous").click(function(){
	$("#ToothPermanent").attr("checked",false);
	$("#ToothDeciduous").attr("checked",true);
	//$(".Permanent td a").linkbutton('disable');
	//$(".Deciduous td a").linkbutton('enable');		
	$(".Permanent").hide();
	//$(".Permanent td textarea").hide();
	$("#toothDIV").css("padding-left","196px");
	//$(".Deciduous td a").show();
	$(".Deciduous").show();
}); 

/*function selectDSTooth(type, DSPosition)
{
	if ((currentToothCode == "")||(currentPositionFlag == ""))
	{
		alert("需要选择一颗恒牙或者乳牙,才可以选择多生牙!");
		return;
	}
	else
	{
		var DSToothCode = currentToothCode + DSPosition;
		
		if ($("#Tooth"+type+DSPosition).attr("name") == "unchecked")
		{
			var flag = "push";
			$("#Tooth"+type+DSPosition).attr("name","checked");
			$("#Tooth"+type+DSPosition).css("color","red");
		}
		else if ($("#Tooth"+type+DSPosition).attr("name") == "checked")
		{
			var flag = "delete";
			$("#Tooth"+type+DSPosition).attr("name","unchecked");
			$("#Tooth"+type+DSPosition).css("color","blue");
		}

		BuildCodeAndStr(currentPositionFlag,DSToothCode,flag);
	}
}*/
//象限点击全选
function quadrantTooth(areaClass){
	var toothMode = $("input[name='Radio']:checked").val();
	//默认为空
	var toothClass = "";
	if(toothMode==="ToothPermanent"){
		toothClass = "Permanent";
	}else if(toothMode==="ToothDeciduous"){
		toothClass = "Deciduous";
		}
	if(toothClass!==""){
		$("."+toothClass+" ."+areaClass).children("div.box").each(function(){
			//不选中8，智齿
			if(this.id&&this.id.indexOf("8")===-1){
				var checkFlag = $(event.target).prop("checked");
				if(checkFlag)
				{
					if ($("#"+this.id).attr("name") == "unchecked")
					{
						checkTooth(this.id);
					}	
				}else{
					if ($("#"+this.id).attr("name") == "checked")
					{
						uncheckTooth(this.id);
					}
				}				
			}
		});
	}
}
//选中一颗牙事件
function checkTooth(currentSelectToothID){
	var flag = "push";
	$("#"+currentSelectToothID).css("border","1px solid #017BCE");
	$("#"+currentSelectToothID).attr("name","checked");
	$("#"+currentSelectToothID).css("color","#017BCE");
	currentToothID = currentSelectToothID;
	BuildToothArray(flag,currentSelectToothID);
	//重置当前操作牙的牙面信息
	ResetSurface(flag,currentSelectToothID);
	resetCheckBox(currentSelectToothID);
}
//重置复选框
function resetCheckBox(currentSelectToothID){
	var parentItem = $("#"+currentSelectToothID).parent();
	var checkflag = false,unCheckflag=false;
	parentItem.children("div.box").each(function(){
		var name = $(this).attr("name");
		var id = $(this).attr("id");
		if(id.indexOf("8")===-1){
			if(name==="checked"){
				checkflag = true;
				}
			if(name==="unchecked"){
				unCheckflag = true;
				}
		}
		});
	var checkboxStatus = "";
	if(!(checkflag&&unCheckflag)){
		if(checkflag){
			checkboxStatus = true;
			}
		if(unCheckflag){
			checkboxStatus = false;
			}
		var areaClass = parentItem.attr("class");
		if(areaClass.indexOf("check-right-top")!==-1){
			//取消选中右上的复选框
			$("#flagRightTop").checkbox("setValue",checkboxStatus);
		}
		else if(areaClass.indexOf("check-right-bottom")!==-1){
			$("#flagRightBottom").checkbox("setValue",checkboxStatus);
		}
		else if(areaClass.indexOf("check-left-top")!==-1){
			$("#flagLeftTop").checkbox("setValue",checkboxStatus);
		}
		else if(areaClass.indexOf("check-left-bottom")!==-1){
			$("#flagLeftBottom").checkbox("setValue",checkboxStatus);
		}	
	}	
}
//取消选中一颗牙
function uncheckTooth(currentSelectToothID){		
	var flag = "delete";
	$("#"+currentSelectToothID).attr("name","unchecked");
	$("#"+currentSelectToothID).css("color","#666666");
	$("#"+currentSelectToothID).css("border","1px solid #CCCCCC");
	document.getElementById('text-Surface-'+currentSelectToothID).innerHTML = "";
	currentToothID = "";
	
	BuildToothArray(flag,currentSelectToothID);
	//重置当前操作牙的牙面信息
	ResetSurface(flag,currentSelectToothID);
	resetCheckBox(currentSelectToothID);
}
//选择一颗牙事件
function selectTooth(currentSelectToothID){
	var currentSelectTooth = document.getElementById(currentSelectToothID);
	if ($("#"+currentSelectToothID).attr("name") == "unchecked")
	{
		checkTooth(currentSelectToothID);
	}
	else if ($("#"+currentSelectToothID).attr("name") == "checked")
	{
		uncheckTooth(currentSelectToothID);
	}
}

//记录选中的牙位信息
function BuildToothArray(flag,currentSelectToothID)
{
	var PositionFlag = currentSelectToothID.split("-")[0];
	var ToothNum = currentSelectToothID.split("-")[1];
	if (flag == "push")
	{
		switch (PositionFlag) {
			case 'AUL':
				AULArray.push(ToothNum);
				AULArray.sort(sortNumberUp);
				break;
			case 'AUR':
				AURArray.push(ToothNum);
				AURArray.sort(sortNumberDown);
				break;
			case 'ALL':
				ALLArray.push(ToothNum);
				ALLArray.sort(sortNumberUp);
				break;
			case 'ALR':
				ALRArray.push(ToothNum);
				ALRArray.sort(sortNumberDown);
				break;
			case 'CUL':
				CULArray.push(ToothNum);
				CULArray.sort(sortNumberUp);
				break;
			case 'CUR':
				CURArray.push(ToothNum);
				CURArray.sort(sortNumberDown);
				break;
			case 'CLL':
				CLLArray.push(ToothNum);
				CLLArray.sort(sortNumberUp);
				break;
			case 'CLR':
				CLRArray.push(ToothNum);
				CLRArray.sort(sortNumberDown);
				break;
		}
	}
	else if (flag == "delete")
	{
		switch (PositionFlag) {
			case 'AUL':
				deleteToothFromArray(AULArray,ToothNum);
				break;
			case 'AUR':
				deleteToothFromArray(AURArray,ToothNum);
				break;
			case 'ALL':
				deleteToothFromArray(ALLArray,ToothNum);
				break;
			case 'ALR':
				deleteToothFromArray(ALRArray,ToothNum);
				break;
			case 'CUL':
				deleteToothFromArray(CULArray,ToothNum);
				break;
			case 'CUR':
				deleteToothFromArray(CURArray,ToothNum);
				break;
			case 'CLL':
				deleteToothFromArray(CLLArray,ToothNum);
				break;
			case 'CLR':
				deleteToothFromArray(CLRArray,ToothNum);
				break;
		}
	}
	
}

//从某个牙位数组中删除需要取消选中的牙位
function deleteToothFromArray(currArray,currentSelectToothID)
{
	for (var i=currArray.length-1 ;i>=0 ;i-- )
	{
		if (currArray[i] == currentSelectToothID)
		{
			currArray.splice(i,1);
		}
	}
}

function BuildCodeAndStr(PositionFlag,toothCode,flag)
{
	switch (PositionFlag) {
		case '1':
			UpLeftSecond = BuildCode(UpLeftSecond,toothCode,flag,PositionFlag);
			UpLeftSecondStr = BuildStr(UpLeftSecond,PositionFlag);
			break;
		case '2':
			UpRightSecond = BuildCode(UpRightSecond,toothCode,flag,PositionFlag);
			UpRightSecondStr = BuildStr(UpRightSecond,PositionFlag);
			break;
		case '3':
			DownRightFisrt = BuildCode(DownRightFisrt,toothCode,flag,PositionFlag);
			DownRightFisrtStr = BuildStr(DownRightFisrt,PositionFlag);
			break;
		case '4':
			DownLeftFirst = BuildCode(DownLeftFirst,toothCode,flag,PositionFlag);
			DownLeftFirstStr = BuildStr(DownLeftFirst,PositionFlag);
			break;
		case '5':
			UpLeftFirst = BuildCode(UpLeftFirst,toothCode,flag,PositionFlag);
			UpLeftFirstStr = BuildStr(UpLeftFirst,PositionFlag);
			break;
		case '6':
			UpRightFirst = BuildCode(UpRightFirst,toothCode,flag,PositionFlag);
			UpRightFirstStr = BuildStr(UpRightFirst,PositionFlag);
			break;
		case '7':
			DownRightSecond = BuildCode(DownRightSecond,toothCode,flag,PositionFlag);
			DownRightSecondStr = BuildStr(DownRightSecond,PositionFlag);
			break;
		case '8':
			DownLeftSecond = BuildCode(DownLeftSecond,toothCode,flag,PositionFlag);
			DownLeftSecondStr = BuildStr(DownLeftSecond,PositionFlag);
			break;
    }

	layoutStrToWindow();
}

//根据选中的牙位图标数据，插入到数组中，并进行排序
function BuildCode(ArrayData,toothCode,flag,PositionFlag)
{
	if (flag == "push")
	{
		ArrayData.push(toothCode);
	}
	else if (flag == "delete")
	{
		for (var i=ArrayData.length-1 ;i>=0 ;i-- )
		{
			if (ArrayData[i].indexOf(toothCode) != -1 )
			{
				ArrayData.splice(i,1);
			}
		}
	}
	
	//倒序排列显示
	if ((PositionFlag == "1")||(PositionFlag == "4")||(PositionFlag == "5")||(PositionFlag == "8"))
	{
		ArrayData.sort(sortNumberDown);
	}
	//正序排序显示
	else
	{
		ArrayData.sort(sortNumberUp);
	}
	return ArrayData;
}
//升序排序
function sortNumberUp(a,b)
{
	return a - b
}
//降序排序
function sortNumberDown(a,b)
{
	return b - a
}

function BuildStr(ArrayData,PositionFlag)
{
	var returnStr = "";
	if ((PositionFlag == "1")||(PositionFlag == "2")||(PositionFlag == "3")||(PositionFlag == "4"))
	{
		for (var i=0 ;i<ArrayData.length ;i++ )
		{
			if (ArrayData[i].length == 2)
			{
				returnStr = returnStr + ArrayData[i].charAt(1);
			}
		}
		for (var i=0 ;i<ArrayData.length ;i++ )
		{
			if (ArrayData[i].length == 3)
			{
				if (ArrayData[i].charAt(2) == "1")
				{
					if (returnStr.indexOf(ArrayData[i].charAt(1)) >= 0)
					{
						returnStr = returnStr.replace(ArrayData[i].charAt(1),"S"+ArrayData[i].charAt(1));
					}
				}
				else if (ArrayData[i].charAt(2) == "2")
				{
					if (returnStr.indexOf(ArrayData[i].charAt(1)) >= 0)
					{
						returnStr = returnStr.replace(ArrayData[i].charAt(1),ArrayData[i].charAt(1)+"S");
					}
				}
			}
		}
	}
	else if ((PositionFlag == "5")||(PositionFlag == "6")||(PositionFlag == "7")||(PositionFlag == "8"))
	{
		for (var i=0 ;i<ArrayData.length ;i++ )
		{
			if (ArrayData[i].length == 2)
			{
				switch (ArrayData[i].charAt(1)) {
					case '1':
						returnStr = returnStr + "A";
						break;
					case '2':
						returnStr = returnStr + "B";
						break;
					case '3':
						returnStr = returnStr + "C";
						break;
					case '4':
						returnStr = returnStr + "D";
						break;
					case '5':
						returnStr = returnStr + "E";
						break;
				}
			}
		}
		for (var i=0 ;i<ArrayData.length ;i++ )
		{
			if (ArrayData[i].length == 3)
			{
				if (ArrayData[i].charAt(2) == "1")
				{
					switch (ArrayData[i].charAt(1)) {
						case '1':
							returnStr = returnStr.replace("A","SA");
							break;
						case '2':
							returnStr = returnStr.replace("B","SB");
							break;
						case '3':
							returnStr = returnStr.replace("C","SC");
							break;
						case '4':
							returnStr = returnStr.replace("D","SD");
							break;
						case '5':
							returnStr = returnStr.replace("E","SE");
							break;
					}
				}
				else if (ArrayData[i].charAt(2) == "2")
				{
					switch (ArrayData[i].charAt(1)) {
						case '1':
							returnStr = returnStr.replace("A","AS");
							break;
						case '2':
							returnStr = returnStr.replace("B","BS");
							break;
						case '3':
							returnStr = returnStr.replace("C","CS");
							break;
						case '4':
							returnStr = returnStr.replace("D","DS");
							break;
						case '5':
							returnStr = returnStr.replace("E","ES");
							break;
					}
				}
			}
		}
	}

	return returnStr;
}

function layoutStrToWindow(){

	var StrArray = new Array();
	StrArray.push(UpLeftSecondStr.length);
	StrArray.push(UpRightSecondStr.length)
	StrArray.push(DownRightFisrtStr.length)
	StrArray.push(DownLeftFirstStr.length)
	StrArray.push(UpLeftFirstStr.length)
	StrArray.push(UpRightFirstStr.length)
	StrArray.push(DownRightSecondStr.length)
	StrArray.push(DownLeftSecondStr.length)

	StrArray.sort(sortNumberDown);
	var MaxLength = StrArray[0];
	
	var TempUpLeftSecondStr = UpLeftSecondStr;
	var TempUpRightSecondStr = UpRightSecondStr;
	var TempDownRightFisrtStr = DownRightFisrtStr;
	var TempDownLeftFirstStr = DownLeftFirstStr;
	var TempUpLeftFirstStr = UpLeftFirstStr;
	var TempUpRightFirstStr = UpRightFirstStr;
	var TempDownRightSecondStr = DownRightSecondStr;
	var TempDownLeftSecondStr = DownLeftSecondStr;
	
	//Div1
	if (TempUpLeftSecondStr.length < MaxLength)
	{
		for (var i=(MaxLength-TempUpLeftSecondStr.length-1); i>=0; i--)
		{
			TempUpLeftSecondStr = "&nbsp;&nbsp;"+ TempUpLeftSecondStr;
		}
	}
	//Div2
	if (TempUpRightSecondStr.length < MaxLength)
	{
		for (var i=(MaxLength-TempUpRightSecondStr.length-1); i>=0; i--)
		{
			TempUpRightSecondStr = TempUpRightSecondStr + "&nbsp;&nbsp;";
		}
	}
	//Div3
	if (TempDownRightFisrtStr.length < MaxLength)
	{
		for (var i=(MaxLength-TempDownRightFisrtStr.length-1); i>=0; i--)
		{
			TempDownRightFisrtStr = TempDownRightFisrtStr + "&nbsp;&nbsp;";
		}
	}
	//Div4
	if (TempDownLeftFirstStr.length < MaxLength)
	{
		for (var i=(MaxLength-TempDownLeftFirstStr.length-1); i>=0; i--)
		{
			TempDownLeftFirstStr = "&nbsp;&nbsp;"+ TempDownLeftFirstStr;
		}
	}
	if ((TempUpLeftFirstStr != "")||(TempUpRightFirstStr != "")||(TempDownRightSecondStr != "")||(TempDownLeftSecondStr != ""))
	{
		//Div5
		if (TempUpLeftFirstStr.length < MaxLength)
		{
			for (var i=(MaxLength-TempUpLeftFirstStr.length-1); i>=0; i--)
			{
				TempUpLeftFirstStr = "&nbsp;&nbsp;"+ TempUpLeftFirstStr;
			}
		}
		//Div6
		if (TempUpRightFirstStr.length < MaxLength)
		{
			for (var i=(MaxLength-TempUpRightFirstStr.length-1); i>=0; i--)
			{
				TempUpRightFirstStr = TempUpRightFirstStr + "&nbsp;&nbsp;";
			}
		}
		//Div7
		if (TempDownRightSecondStr.length < MaxLength)
		{
			for (var i=(MaxLength-TempDownRightSecondStr.length-1); i>=0; i--)
			{
				TempDownRightSecondStr = TempDownRightSecondStr + "&nbsp;&nbsp;";
			}
		}
		//Div8
		if (TempDownLeftSecondStr.length < MaxLength)
		{
			for (var i=(MaxLength-TempDownLeftSecondStr.length-1); i>=0; i--)
			{
				TempDownLeftSecondStr = "&nbsp;&nbsp;"+ TempDownLeftSecondStr;
			}
		}
	}
	if ((TempUpLeftSecondStr == "")&&(TempUpRightSecondStr == "")&&(TempDownRightFisrtStr == "")&&(TempDownLeftFirstStr == "")&&(TempUpLeftFirstStr == "")&&(TempUpRightFirstStr == "")&&(TempDownRightSecondStr == "")&&(TempDownLeftSecondStr == ""))
	{
		TempUpLeftSecondStr = "&nbsp;&nbsp;";
		TempUpRightSecondStr = "&nbsp;&nbsp;";
		TempDownRightFisrtStr = "&nbsp;&nbsp;";
		TempDownLeftFirstStr = "&nbsp;&nbsp;";
	}
	/*$("#Div1").html(TempUpLeftSecondStr);
	$("#Div2").html(TempUpRightSecondStr);
	$("#Div3").html(TempDownRightFisrtStr);
	$("#Div4").html(TempDownLeftFirstStr);
	$("#Div5").html(TempUpLeftFirstStr);
	$("#Div6").html(TempUpRightFirstStr);
	$("#Div7").html(TempDownRightSecondStr);
	$("#Div8").html(TempDownLeftSecondStr);*/
}

$("#addToRecord").click(function(){
	//returnValue = toothJson;
    returnValue = getToothData();
	
	closeWindow();
});

function getToothData()
{
    var Permanent = $("#ToothPermanent").attr("checked");
	var Deciduous = $("#ToothDeciduous").attr("checked");
	var ToothAll = $("#ToothAll").attr("checked");
	var ShowMode = "恒牙";
	if (Deciduous == "checked")
	{
		ShowMode = "乳牙";
	}else if (ToothAll == "checked"){
		ShowMode = "混合牙";
	}
	
	//非标准化
    //var toothJson = '{"InstanceID":"","ShowMode":"' + ShowMode + '","UpLeftAreaTeeth":' + getQuadrantJson("UR",ShowMode) + ',"UpRightAreaTeeth":' + getQuadrantJson("UL",ShowMode) + ',"DownLeftAreaTeeth":' + getQuadrantJson("LR",ShowMode) + ',"DownRightAreaTeeth":' + getQuadrantJson("LL",ShowMode) + '}';
    //标准化
    var toothJson = '{"InstanceID":"","ShowMode":"' + ShowMode + '","ToothCodeSystem":"' + ToothCodeSystem + '","ToothCodeSystemName":"' + ToothCodeSystemName + '","ToothSurfaceCodeSystem":"' + ToothSurfaceCodeSystem + '","ToothSurfaceCodeSystemName":"' + ToothSurfaceCodeSystemName + '","UpLeftAreaTeeth":' + getQuadrantJson("UR",ShowMode) + ',"UpRightAreaTeeth":' + getQuadrantJson("UL",ShowMode) + ',"DownLeftAreaTeeth":' + getQuadrantJson("LR",ShowMode) + ',"DownRightAreaTeeth":' + getQuadrantJson("LL",ShowMode) + '}';
	
    return toothJson;
}

function GetPageDataForOut()
{
    var dataForOut = getToothData();
    return dataForOut;
}

//获取象限Json数据
function getQuadrantJson (QuadrantPosition,ShowMode)
{
	var quadrantJson = "";
	var PositionFlag = "";
	if (ShowMode == "恒牙")
	{
		PositionFlag = "A" + QuadrantPosition;
	}
	else if (ShowMode == "乳牙")
	{
		PositionFlag = "C" + QuadrantPosition;
	}
	else if (ShowMode == "混合牙")
	{
		PositionFlag = "A" + QuadrantPosition + "&C" + QuadrantPosition;
	}
	
	switch (PositionFlag) {
		case 'AUL':
			quadrantJson = getToothJson(AULArray,PositionFlag);
			break;
		case 'AUR':
			quadrantJson = getToothJson(AURArray,PositionFlag);
			break;
		case 'ALL':
			quadrantJson = getToothJson(ALLArray,PositionFlag);
			break;
		case 'ALR':
			quadrantJson = getToothJson(ALRArray,PositionFlag);
			break;
		case 'CUL':
			quadrantJson = getToothJson(CULArray,PositionFlag);
			break;
		case 'CUR':
			quadrantJson = getToothJson(CURArray,PositionFlag);
			break;
		case 'CLL':
			quadrantJson = getToothJson(CLLArray,PositionFlag);
			break;
		case 'CLR':
			quadrantJson = getToothJson(CLRArray,PositionFlag);
			break;
		case 'AUL&CUL':
			quadrantJson = getToothJson(AULArray,PositionFlag.split('&')[0]);
			var CULJson = getToothJson(CULArray,PositionFlag.split('&')[1]);
			if (CULJson != "")
			{
				if (quadrantJson != ""){
					quadrantJson = quadrantJson + "," + CULJson;
				}else{
					quadrantJson = CULJson;
				}
			}
			break;
		case 'AUR&CUR':
			quadrantJson = getToothJson(AURArray,PositionFlag.split('&')[0]);
			var CURJson = getToothJson(CURArray,PositionFlag.split('&')[1]);
			if (CURJson != "")
			{
				if (quadrantJson != ""){
					quadrantJson = quadrantJson + "," + CURJson;
				}else{
					quadrantJson = CURJson;
				}
			}
			break;
		case 'ALL&CLL':
			quadrantJson = getToothJson(ALLArray,PositionFlag.split('&')[0]);
			var CULLJson = getToothJson(CLLArray,PositionFlag.split('&')[1]);
			if (CULLJson != "")
			{
				if (quadrantJson != ""){
					quadrantJson = quadrantJson + "," + CULLJson;
				}else{
					quadrantJson = CULLJson;
				}
			}
			break;
		case 'ALR&CLR':
			quadrantJson = getToothJson(ALRArray,PositionFlag.split('&')[0]);
			var CLRJson = getToothJson(CLRArray,PositionFlag.split('&')[1]);
			if (CLRJson != "")
			{
				if (quadrantJson != ""){
					quadrantJson = quadrantJson + "," + CLRJson;
				}else{
					quadrantJson = CLRJson;
				}
			};
			break;
	}
	quadrantJson =  "[" + quadrantJson + "]";
	
	return quadrantJson;
}

//获取牙位Json数据
function getToothJson(currArray,PositionFlag)
{
	var toothJson = "";
	for (var i=0;i<currArray.length ;i++ )
	{
		var ToothID = PositionFlag + "-" + currArray[i];
		var ToothItem =  document.getElementById(ToothID);
		var ToothInCode = ToothID.replace('-','.');
		var ToothValue = document.getElementById("tp-" + ToothID).innerText;
		/*
		if(isIE()){	
			var ToothValue = ToothItem.innerText.substr(ToothItem.innerText.length-1,1);    //----P,L8  应为8
		}else{
			var ToothValue = ToothItem.innerText.substr(ToothItem.innerText.length-2,1);
		}
		*/
		var ToothText = $("#"+ToothID).attr("text");     //undefined    应为上颌左侧第三磨牙
		var ToothAreaType = $("#"+ToothID).attr("areatype");     //undefined    应为上颌左侧第三磨牙
		var ToothSurfaceValue = $("#text-Surface-"+ToothID).val();
        //替换产生的回车换行符
        ToothSurfaceValue = ToothSurfaceValue.replace(/\r\n/g, '');
        ToothSurfaceValue = ToothSurfaceValue.replace(/,/g, '');
		var ToothSurfaceIDStr = $('#text-Surface-'+ToothID).attr("text");    //空   应为Surface-P,Surface-L
		
		//非标准化
        //var tempToothJson = '{"ToothCode":"' + ToothCode + '","ToothValue":"' + ToothValue + '","ToothSurfaceValue":"' + ToothSurfaceValue + '","ToothSurfaceItems":' + getToothSurfaceJson(ToothID,ToothText,ToothSurfaceIDStr) + '}';
        //标准化
        var tempToothJson = '{"ToothInCode":"' + ToothInCode + '","AreaType":"' + ToothAreaType + '","ToothCode":"' + ToothValue + '","ToothDisplayName":"' + ToothText +'","ToothValue":"' + ToothValue + '","ToothSurfaceValue":"' + ToothSurfaceValue + '","ToothSurfaceItems":' + getToothSurfaceJson(ToothID,ToothText,ToothSurfaceIDStr) + '}';
		
		if (toothJson == "")
		{
			toothJson = tempToothJson;
		}
		else
		{
			toothJson = toothJson + "," + tempToothJson;
		}
	}
	return toothJson;
}

//获取牙面Json数据       //AUL-8   //上颌左侧第三磨牙   ///Surface-P,Surface-L
function getToothSurfaceJson(ToothID,ToothText,ToothSurfaceIDStr)
{
	if (ToothSurfaceIDStr == "")
	{
		return "[]";
	}
	var toothSurfaceJson = "";
	var SurfaceItems = ToothSurfaceIDStr.split(",");
	for (var i=0;i<SurfaceItems.length ;i++ )
	{
		var SurfaceID = SurfaceItems[i];
		var SurfaceItem =  document.getElementById(SurfaceID);
		var SurfaceInCode = ToothID.replace('-','.') + "." + SurfaceID.split("-")[1];
        //非标准化
        //var SurfaceValue = ToothText + SurfaceItemObj[SurfaceID];
		//var tempSurfaceJson = '{"Code":"' + SurfaceCode + '","Value":"' + SurfaceValue + '","ScriptMode":"SuperScript"}';
		//标准化
        var SurfaceValue = SurfaceItemObj[SurfaceID];
		var tempSurfaceJson = '{"InCode":"' + SurfaceInCode + '","Code":"' + SurfaceID.split("-")[1] + '","Value":"' + SurfaceID.split("-")[1] + '","ToothSurfaceDisplayName":"' + SurfaceValue + '","ScriptMode":"SuperScript"}';
		
		if (toothSurfaceJson == "")
		{
			toothSurfaceJson = tempSurfaceJson;
		}
		else
		{
			toothSurfaceJson = toothSurfaceJson + "," + tempSurfaceJson;
		}
	}
	toothSurfaceJson = "[" + toothSurfaceJson + "]";
	return toothSurfaceJson;
}
function isIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}

//关闭窗口
function closeWindow() {
	//parent.$HUI.dialog('#toothDialog').destroy();
	
    if((parent)&&(parent.closeDialog)){
		parent.closeDialog("toothDialog");
	}
	else if ((window.parent)&&(window.parent.closeDialog)){
        window.parent.closeDialog("toothDialog");
    }
    
}