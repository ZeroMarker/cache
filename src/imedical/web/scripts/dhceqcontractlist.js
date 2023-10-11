var preRowID=0
var GlobalObj = {
	ContractTypeDR : "",
	ProviderDR : "",
	//ModelDR : "",
	UseLocDR : "",
	SignLocDR : "",
	BuyTypeDR : "",
	ItemDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="Provider") {this.ProviderDR = "";}
		//if (vElementID=="Model") {this.ModelDR = "";}
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="SignLoc") {this.SignLocDR = "";}
		if (vElementID=="BuyTypeDR") {this.BuyTypeDR = "";}
	},
	ClearAll : function()
	{
		this.ContractTypeDR = "";
		this.ProviderDR = "";
		//this.ModelDR = "";
		this.UseLocDR = "";
		this.SignLocDR = "";
		this.ItemDR = "";
		this.BuyTypeDR = "";
	}
}
jQuery(document).ready(function()
{
	initDocument();
	var vData=GetData();
	// Mozy		770069	2018-12-11
	$('#DHCEQContractList').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQ.Con.BUSContract",
			QueryName:"ContractList",
			Arg1:vData,
			Arg2:"1",
			ArgCnt:2
		},
    	border:'true',
		rownumbers: true,  //���Ϊtrue����ʾһ���к���
		singleSelect:true,
		fit:true,
		//columns:GetCurColumnsInfo('CON.G.Contract.ContractDetail','','',''),
		columns:[[
	        {field:'Row',title:'���',width:40,align:'center',hidden:true},
	       	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TContractType',title:'��ͬ����',width:60},
	        {field:'TContractName',title:'��ͬ����',width:100},
	        {field:'TContractNo',title:'��ͬ��',width:100},
	        {field:'TSignDate',title:'ǩ������',width:80},
	        {field:'TSignLocDR',title:'TSignLocDR',width:50,hidden:true},
	        {field:'TSignLoc',title:'ǩ������',width:60},
	        {field:'TPreFeeFee',title:'Ԥ����',width:60},
	        //{field:'TPayedTotalFee',title:'�Ѹ���',width:60},
	        //{field:'TDeliveryDate',title:'��������',width:80},
	        {field:'TArriveDate',title:'��������',width:80},
	        {field:'TStartDate',title:'��Ч��ʼ����',width:80},
	        {field:'TEndDate',title:'��Ч��ֹ����',width:80},
	        {field:'TClaimPeriodNum',title:'TClaimPeriodNum',width:60,hidden:true},
	        {field:'TServiceDR',title:'TServiceDR',width:50,hidden:true},
	        {field:'TService',title:'������',width:80},
	        {field:'TCheckStandard',title:'����',width:80},
	        {field:'TProviderDR',title:'TProviderDR',width:50,hidden:true},
	        {field:'TProvider',title:'��Ӧ��',width:120},
	        {field:'TProviderTel',title:'TProviderTel',width:50,hidden:true},
	        {field:'TProviderHandler',title:'TProviderHandler',width:50,hidden:true},
	        {field:'TBreakItem',title:'TBreakItem',width:50,hidden:true},
	        {field:'TArriveMonthNum',title:'TArriveMonthNum',width:50,hidden:true},
	        {field:'TGuaranteePeriodNum',title:'������',width:50},
	        {field:'TStatus',title:'״̬',width:50},
	        {field:'TFileNo',title:'������',width:60},
	        {field:'TRowIDMX',title:'TRowIDMX',width:50,hidden:true},
			{field:'TName',title:'�豸����',width:80},
			{field:'TPrice',title:'����',width:50},
			{field:'TQuantityNum',title:'����',width:50},
			{field:'TTotal',title:'�ܽ��',width:60}
			//{field:'THold1',title:'���������',width:50},
			//{field:'TDetail',title:'�豸��ϸ',width:30}
	    ]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		onDblClickRow:function(rowIndex, rowData)
		{
			if (rowData.TRowID!="")
			{
				//Quit $CASE(ContractType,"0":"�ɹ���ͬ","1":"���޺�ͬ","2":"Э��ɹ�","3":"Ͷ�ź�ͬ",:"û�ж���")
				var url="";
				var Title="�ɹ���ͬ";
				if (rowData.TContractType=="�ɹ���ͬ")
				{
					url="dhceq.con.contract.csp?&ContractType=0&RowID="+rowData.TRowID;
				}
				else if (rowData.TContractType=="���޺�ͬ")
				{
					url="dhceq.con.contractformaint.csp?&ContractType=1&RowID="+rowData.TRowID;
					Title="���޺�ͬ";
				}
				else
				{
					url="dhceq.con.contract.csp?&ContractType=2&RowID="+rowData.TRowID;
					Title="Э��ɹ�";
				}
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
					url += "&MWToken="+websys_getMWToken()
				}
		    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=650')
			}
		},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
	}
)

function initDocument()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", FindGridData);
	jQuery("#BColSet").linkbutton({iconCls: 'icon-config'}); 
	jQuery("#BColSet").on("click", BColSet_Click);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-redo'}); 
	jQuery("#BSaveExcel").on("click", BSaveExcel_Click);
	
	GlobalObj.ClearAll();
	initProviderPanel();		//��Ӧ��
	//initUseLocPanel();		//ʹ�ÿ���
	//initModelPanel();			//�ͺ�
	//initBuyTypePanel();		//�ɹ���ʽ
	initSignLocPanel();			//ǩ������
	
	initProviderData();			//��Ӧ��
	//initUseLocData();			//ʹ�ÿ���
	//initModelData();			//�ͺ�
	//initBuyTypeData();		//�ɹ���ʽ
	initSignLocData();
	
	if (jQuery("#ContractType").prop("type")!="hidden")
	{
		jQuery("#ContractType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: ''
			},{
				id: '0',
				text: '�ɹ���ͬ'
			},{
				id: '1',
				text: '���޺�ͬ'
			},{
				id: '2',
				text: 'Э��ɹ���ͬ'
			}/*,{
				id: '3',
				text: 'Ͷ�ź�ͬ'
			}*/],
			onSelect: function() {GlobalObj.ContractTypeDR=jQuery("#ContractType").combobox("getValue");}
		});
	}
}

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Provider") {initProviderData();}
	if (vElementID=="UseLoc") {initBrandData();}
	//if (vElementID=="Model") {initModelData();}
	if (vElementID=="BuyType") {initBuyTypeData();}
	if (vElementID=="SignLoc") {initSignLocData();}	// Mozy		770069	2018-12-11
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Provider") {GlobalObj.ProviderDR = CurValue;}
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
	//if (vElementID=="Model") {GlobalObj.ModelDR = CurValue;}
	if (vElementID=="BuyType") {GlobalObj.BuyTypeDR = CurValue;}
	if (vElementID=="SignLoc") {GlobalObj.SignLocDR = CurValue;}	// Mozy		770069	2018-12-11
}
/*
function OnclickRow()
{
	setJQValue($("#ReserveFlag"),false);
	var selected=$('#tDHCEQPCProduct').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			FillData(selectedRowID)
			preRowID=selectedRowID;
		}
		else
		{
			ClearElement();
			$('#tDHCEQPCProduct').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
function CompanyEdit(rowIndex, rowData)
{
	if(rowData.TRowID!="")
	{
		var url='dhceq.pc.process.company.csp?Rowid='+rowData.TCompanyDR;
		var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+rowData.TCompany+'</A>';
		return btn;
	}
}
function VendorList(rowIndex, rowData)
{
	if(rowData.TRowID!="")
	{
		var url="dhceq.pc.process.companylist.csp?&CompanyTypeDR=2&ProductDR="+rowData.TRowID;
		var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+rowData.TCompany+'</A>';
		return btn;
	}
}*/
// Mozy		770069	2018-12-11
function FindGridData()
{
	var vData=GetData();
	$('#DHCEQContractList').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQ.Con.BUSContract",
			QueryName:"ContractList",
			Arg1:vData,
			Arg2:"1",
			ArgCnt:2
		}
	});
}
function GetData()
{
	var val="&Data="
	val=val+"^ContractTypeDR="+GlobalObj.ContractTypeDR;
	val=val+"^Name="+$('#Name').val()	//document.getElementById("Name").value;
	val=val+"^ContractName="+$('#ContractName').val()	//document.getElementById("ContractName").value;
	val=val+"^ContractNo="+$('#ContractNo').val()	//document.getElementById("ContractNo").value;
	val=val+"^SignLocDR="+GlobalObj.SignLocDR;		// Mozy		770069	2018-12-11
	val=val+"^ProviderDR="+GlobalObj.ProviderDR;
	val=val+"^UseLocDR="+GlobalObj.UseLocDR;
	val=val+"^ModelDR="+GlobalObj.ModelDR;
	val=val+"^BuyTypeDR="+GlobalObj.BuyTypeDR;
	val=val+"^FileNo="+$('#FileNo').val()	//document.getElementById("FileNo").value;
	val=val+"^FromOriginalFee="+$('#FromOriginalFee').val()	//document.getElementById("FromOriginalFee").value;
	val=val+"^ToOriginalFee="+$('#ToOriginalFee').val()	//document.getElementById("ToOriginalFee").value;
	val=val+"^SignBeginDate="+$('#SignBeginDate').combogrid('getValue')	// Mozy		770069	2018-12-11
	val=val+"^SignEndDate="+$('#SignEndDate').combogrid('getValue')	// Mozy		770069	2018-12-11
	return val
}

function BSaveExcel_Click() //����
{	
	var vData=GetData()
	var Job=$('#Job').val()
	PrintDHCEQEquipNew("ContractList",1,"",vData,"",100);
	return
}
function BColSet_Click() //��������������
{
	var para="&TableName=ContractList&SetType=0&SetID=0"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	OpenNewWindow(url)
}
// Mozy		770069	2018-12-11
function initSignLocPanel()
{
	initComboGrid("SignLoc","ǩ������",400,true);
}
function initSignLocData()
{
	var vParams=","+jQuery("#SignLoc").combogrid("getText")+",,0102,"
	initComboData("SignLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
