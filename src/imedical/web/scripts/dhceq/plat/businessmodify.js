$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
    initButtonWidth();
	initBussType();
	setRequiredElements("BussType^BussNo");
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
        	loadData(bussType,bussNo);
        	loadInStockListData(bussNo);
        break;
        default:
        break;
	}
}

function loadData(bussType,bussNo)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",bussType,bussNo)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE==-9012) {messageShow('','','',"��ⵥ�Ų�����!",'',function(){reloadPage();});} // Modify by zx 2020-03-31BUG ZX0082
	else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}

function loadInStockListData(bussNo)
{
	$HUI.datagrid("#DHCEQBusinessList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBBusinessModify",
			QueryName:"GetInStockList",
			InStockNo:bussNo
		},
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:[[
	    	{field:'TRowID',title:'TRowID',hidden:true},
			{field:'TOpt',title:'����',width:80,align:'center',formatter:function(value,rec){
                	var btn = '<a href="#" class="hisui-linkbutton hover-dark" onclick="javascript:editBusinessList('+rec.TRowID+')">�޸�</a>';  
                	return btn;  
           		}
			} ,
	    	{field:'TEquipName',title:'�豸����',width:180,align:'center'},
	    	{field:'TModel',title:'����ͺ�',width:160,align:'center'},
			{field:'TQuantityNum',title:'����',width:100,align:'center'},
			{field:'TUnit',title:'��λ',width:100,align:'center'},
			{field:'TOriginalFee',title:'ԭֵ',tooltip:'a tooltip',width:100,align:'center'},
			{field:'TTotal',title:'�ܽ��',width:100,align:'center'},
			{field:'TManuFactory',title:'��������',width:160,align:'center'},
			{field:'TStatCat',title:'�豸����',width:120,align:'center'},
			{field:'TEquipCat',title:'�豸����',width:120,align:'center'},
			{field:'TInvoiceNos',title:'��Ʊ��',width:120,align:'center'},
			{field:'THold5',title:'������Դ',width:120,align:'center'},
			{field:'TLimitYearsNum',title:'ʹ������',width:100,align:'center'},
			{field:'TRemark',title:'��ע',width:100,align:'center'} 	       
	    ]]
	});
}

function editBusinessList(BussID)
{
	var bussType=getElementValue("BussType");
	var url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+BussID;
	showWindow(url,"ҵ����ϸ�޸�","","6row","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
}

/// add by zx 2019-08-30
/// ���水ť�ص��¼�
function setValueByEdit(id,value)
{
	//alertShow(value)
	//setElement("id",value);
	BFind_Clicked();
}

/// add by zx 2020-03-31 BUG ZX0082
/// ����: ����ˢ�´���
function reloadPage()
{
	url="dhceq.plat.businessmodify.csp?"
    window.location.href= url;
}