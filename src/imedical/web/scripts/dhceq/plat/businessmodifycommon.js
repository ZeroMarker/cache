/// add by zx 2019-08-30
/// ҵ�񵥾��޸�ͼ�������ʽ�仯
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
/// ҵ�񵥾��޸�ͼ�����¼�
$("i").click(function(){
	// Ԫ������ �������� ���� �ֶ��� 
	var inputID=$(this).prev().attr("id");
	if (typeof inputID=="undefined") return;
	var oldValue=getElementValue(inputID);
	//ȡԪ�ص���Ϣ
	var options=$("#"+inputID).attr("data-options");
	if ((options==undefined)&&(options=="")) return;
	//תjson��ʽ
	options='{'+options+'}';
	var options=eval('('+options+')');
	var inputType=options.itype;
	var inputProperty=options.property;
	inputType=(typeof inputType == 'undefined') ? "" : inputType;
	inputProperty=(typeof inputProperty == 'undefined') ? "" : inputProperty;
	
	if (inputType=="") return;
	var title=$("label[for='"+inputID+"']").text(); //ͨ���ı��������ɶ�Ӧ��������
	inputID=inputID.split("_")[0]; //ָ����id��Ҫ��ȡ
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var equipTypeDR=""
	if (inputID=="ISLStatCatDR") equipTypeDR=getElementValue("ISEquipTypeDR");
	var url="dhceq.plat.businessmodifyedit.csp?OldValue="+oldValue+"&InputID="+inputID+"&BussType="+bussType+"&BussID="+bussID+"&MainFlag="+mainFlag+"&InputType="+inputType+"&InputProperty="+inputProperty+"&ComponentName="+title+"&EquipTypeDR="+equipTypeDR;
	showWindow(url,"��ⵥ ��"+title+"�� �޸�","","9row","icon-w-paper","modal","","","small",setValueByEdit);    //modify by lmm 2020-06-05
});