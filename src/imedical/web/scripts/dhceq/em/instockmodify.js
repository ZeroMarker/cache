///add by ZY0264 20210517
var EquipInfos = "";
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
    //initButtonWidth();
	initBussType();
	setRequiredElements("BussType^BussNo");
	///modified by ZY02264 20210521
	jQuery("#BDepreCalculation").on("click", BSave_Clicked);
	jQuery("#BModify").on("click", BModify_Clicked);
}
function initBussType()
{
	$HUI.combobox('#BussType',{
		valueField:'busscode',
		textField:'text',
		panelHeight:"auto",
		data:[{
			busscode: '21',
			text: '���'
		}]
	});
}
function BFind_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	if (bussType=="")
	{
		messageShow('alert','error','��ʾ',"ҵ�����Ͳ���Ϊ��!")
		return
	}
	if (bussNo=="")
	{
		messageShow('alert','error','��ʾ',"ҵ�񵥺Ų���Ϊ��!")
		return
	}
	$('#BusinessContent').layout('remove','north');
	switch (bussType) {
        case "21":
        	$('#BusinessMain').hide();
        	$("#InStockInfo").show();
        	loadData(bussType,bussNo);
        	loadInStockListData(bussNo);
        	break;
        default:break;
	}
}

function loadData(bussType,bussNo)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","GetBusinessMain",bussType,bussNo)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE==-9012) {messageShow('','','',jsonData.Data,'',function(){reloadPage();});} // Modify by zx 2020-03-31BUG ZX0082
	else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	var NewISInDate=getElementValue("NewISInDate")
	jQuery("#BDepreCalculation").linkbutton({text:'�۾ɲ���'});
	if (NewISInDate!="")
	{
		$("#BModify").show();
		//jQuery("#BModify").linkbutton({text:'�޸�'});
	}
	else
	{
		$("#BModify").hide();
	}
}
function loadInStockListData(bussNo)
{
	$HUI.datagrid("#DHCEQBusinessList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSInStockModify",
			QueryName:"GetInStockList",
			InStockNo:bussNo
		},
		fit:true,
		fitColumns:true,
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,50],
	    columns:[[
	    	{field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" value="'+value+'" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},   
	    	{field:'TEquipName',title:'�豸����',width:150,align:'center'},
	    	{field:'TModel',title:'����ͺ�',width:100,align:'center'},
			{field:'TQuantityNum',title:'����',width:50,align:'center',hidden:true},
			{field:'TUnit',title:'��λ',width:60,align:'center'},
			{field:'EQOriginalFee',title:'ԭֵ',tooltip:'a tooltip',width:100,align:'center'},
			{field:'TManuFactory',title:'��������',width:160,align:'center'},
			//{field:'TStatCat',title:'�豸����',width:120,align:'center'},
			//{field:'TEquipCat',title:'�豸����',width:120,align:'center'},
			//{field:'TInvoiceNos',title:'��Ʊ��',width:120,align:'center'},
			//{field:'THold5',title:'������Դ',width:120,align:'center'},
			
			{field:'EQRowID',title:'�ʲ�ID',width:120,align:'center',hidden:true},
			{field:'EQNo',title:'�ʲ����',width:120,align:'center'},
			{field:'TStoreLoc',title:'����',width:80,align:'center'},
			{field:'TLimitYearsNum',title:'ʹ������',width:80,align:'center'},
			{field:'EQNetFee',title:'��ֵ',width:80,align:'center'},
			{field:'EQDepreTotalFee',title:'�ۼ��۾�',width:80,align:'center'},
			{field:'TNewDepreTotalFee',title:'���ۼ��۾�',width:80,align:'center',editor:'text'},
			
			{field:'EQTransAssetDate',title:'��������',width:100,align:'center'},
			{field:'TNewTransAssetDate',title:'����������',width:100,align:'center'},
			{field:'EQDepreMonths',title:'�۾�����',width:80,align:'center'},
			
			{field:'EQDepreSetID',title:'�۾�����ID',width:120,align:'center',hidden:true},
			//{field:'FundsDepreInfo',title:'�ʽ���Դ��Ϣ',width:120,align:'center'},
	    ]],
	    onClickRow:function(rowIndex,rowData){
	   
		    if(rowData.TEnableFlag != "Y")
			{
				if($("input[value='"+rowData.TRowID+"']").prop("checked"))
				{
					$("input[value='"+rowData.TRowID+"']").prop("checked",false);
				}
				else 
				{	
					$("input[value='"+rowData.TRowID+"']").prop("checked",true);
				}
			}
	  	},
	});
}

/// add by zx 2019-08-30
/// ���水ť�ص��¼�
function setValueByEdit(id,value)
{
	//alertShow(value)
	//setElement("id",value);
	BFind_Clicked();
}

function BSave_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	var NewISInDate=getElementValue("NewISInDate")
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","SaveBusinessMain",bussType,bussNo,NewISInDate)
	jsonData=jQuery.parseJSON(jsonData);
	if(jsonData.SQLCODE==0)
	{
		loadInStockListData(bussNo)
		///modified by ZY02264 20210521
		loadData(bussType,bussNo)
	}
	else
	{
		if (jsonData.SQLCODE==-9012) {messageShow('','','',jsonData.Data,'',function(){});} // Modify by zx 2020-03-31BUG ZX0082
	}
}
function BModify_Clicked()
{
	
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	InStockListIDs=$("input[name='ckId']").map(function () { 
	if($(this).prop("checked"))  return $(this).val();         
	}).get().join(",");
	if (InStockListIDs=="") {
		alertShow("δѡ�����ݣ�")
		return;
	}
	else
	{
		var rows = $('#DHCEQBusinessList').datagrid('getRows');
	    var InStockListIDs = ","+InStockListIDs+",";
	    var EquipInfos=""
	    for (var i = 0; i < rows.length; i++)
	    {
		    if (InStockListIDs.indexOf(","+rows[i].TRowID+",") != -1)
		    {
			    var oneListData=rows[i].EQRowID+getElementValue("SplitNumCode")+rows[i].TNewDepreTotalFee+getElementValue("SplitNumCode")+rows[i].EQDepreSetID+getElementValue("SplitNumCode")+rows[i].EQDepreMonths+getElementValue("SplitNumCode")+rows[i].FundsDepreInfo
			    if (EquipInfos=="") EquipInfos=oneListData
			    else EquipInfos=EquipInfos+getElementValue("SplitRowCode")+oneListData
	    	}
	    }
	}
	messageShow("confirm","","","�ò���ֱ���޸��ʲ����������ں��۾�����,�Ƿ����?","",function(){
		
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","ModifyEquipInfoByInStockDate",bussType,bussNo,EquipInfos);
			jsonData=jQuery.parseJSON(jsonData);
			if(jsonData.SQLCODE==0)
			{
				alertShow("��ʾ:�����ɹ�");
			}
			else
		    {
			    alertShow("����ʧ��:"+jsonData.Data);
		    }
		},"")
}
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
