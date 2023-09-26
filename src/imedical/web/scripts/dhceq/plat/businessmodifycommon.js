/// add by zx 2019-08-30
/// 业务单据修改图标操作样式变化
$("i").hover(function(){
	$(this).css("background-color","#378ec4");
	$(this).removeClass("icon-blue-edit");
    $(this).addClass("icon-w-edit");
},function(){
    $(this).css("background-color","#fff");
    $(this).addClass("icon-blue-edit");
    $(this).removeClass("icon-w-edit");
});

/// add by zx 2019-08-30
/// 业务单据修改图标点击事件
$("i").click(function(){
	// 元素类型 数据属性 表明 字段名 
	var inputID=$(this).prev().attr("id");
	if (typeof inputID=="undefined") return;
	var oldValue=getElementValue(inputID);
	//取元素的信息
	var options=$("#"+inputID).attr("data-options");
	if ((options==undefined)&&(options=="")) return;
	//转json格式
	options='{'+options+'}';
	var options=eval('('+options+')');
	var inputType=options.itype;
	var inputProperty=options.property;
	inputType=(typeof inputType == 'undefined') ? "" : inputType;
	inputProperty=(typeof inputProperty == 'undefined') ? "" : inputProperty;
	
	if (inputType=="") return;
	var title=$("label[for='"+inputID+"']").text(); //通过文本描述生成对应弹窗标题
	inputID=inputID.split("_")[0]; //指向型id需要截取
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var equipTypeDR=""
	if (inputID=="ISLStatCatDR") equipTypeDR=getElementValue("ISEquipTypeDR");
	var url="dhceq.plat.businessmodifyedit.csp?OldValue="+oldValue+"&InputID="+inputID+"&BussType="+bussType+"&BussID="+bussID+"&MainFlag="+mainFlag+"&InputType="+inputType+"&InputProperty="+inputProperty+"&ComponentName="+title+"&EquipTypeDR="+equipTypeDR;
	showWindow(url,"入库单 ‘"+title+"’ 修改","","9row","icon-w-paper","modal","","","small",setValueByEdit);    //modify by lmm 2020-06-05
});