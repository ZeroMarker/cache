///add by ZY0223 ԭeasyui��������hisui����
var AccountFlag=0;
var mestring='��ȷ��Ҫ����ѡ��ⵥ���ˣ�';
var buttonstring='�������';
var SelectString='ȫ/��ѡ'	
var SelectFlag=0
var InStockIDs = "";
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 �������Ч��Ӱ�� bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
    //initLookUp("MRObjLocDR_LocDesc^MRExObjDR_ExObj^"); //��ʼ���Ŵ�
    initLookUp(); //��ʼ���Ŵ�
    defindTitleStyle(); 
    //initButton(); //��ť��ʼ��
	initEvent();
    initButtonWidth();
    //fillData(); //�������
    //setEnabled(); //��ť����/
    //initApproveButtonNew(); //��ʼ��������ť
	$HUI.datagrid("#DHCEQInStockAccount",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQAccountList",
	        	QueryName:"GetInStock",
				InStockNo:getElementValue("InStockNo"),
				ProviderDR:getElementValue("ProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				CurAccountFlag:AccountFlag,
				CurGroupID:curGroupID,
				BuyLocDR:getElementValue("BuyLocDR"),
				EquipName:getElementValue("EquipName")
		},
	    toolbar:[{
                iconCls: 'icon-ok', 
                text:SelectString,      
                handler: function(){
                       selectall();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-add', 
                text:buttonstring,      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
	    //modify by lmm 2020-06-02 �����п�
		fitColumns:true,
	    columns:[[
	    	{ field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
	    	{field:'TInStockNo',title:'��ⵥ��',width:150},   // modified by kdf 2018-02-08 ����ţ�548506  
	        {field:'TBuyLoc',title:'����',width:100},        
	        {field:'TISLRowID',title:'�����ϸID',width:50,hidden:true},
	        {field:'TQuantityNum',title:'����',align:'right'},  
			{field:'TOriginalFee',title:'����',align:'right'},
			{field:'TotalFee',title:'�ܽ��',width:100,align:'right'}, 
			{field:'TEquipName',title:'�豸����',width:150},    // modified by jyp 2019-03-11   modified by wy 2019-3-14�豸�����Ƹ�Ϊ�豸����
			{field:'TFunds',title:'�ʽ���Դ',width:150},
			{field:'TExpenditures',title:'������Դ',width:150},
			{field:'TRemark',title:'��ע',width:100}, 
			{field:'TProvider',title:'��Ӧ��'}, 
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},               
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
			creatToolbar();
	  	},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){creatToolbar();}
	});
};

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var combindata=$("input[name='ckId']").map(function () { 
			if($(this).prop("checked"))  return $(this).val();         
		}).get().join(",");
	var totalISLQuantityNum=0
	var totalISLTotalFee=0
	var data=tkMakeServerCall("web.DHCEQAccountList","CalculaTotal",combindata)
	if (data!="")
	{
		var result=data.split("^"); 
		var totalISLQuantityNum=parseFloat(result[0])
		var totalISLTotalFee=parseFloat(result[1])
	}
	var lable_innerText='������:'+totalISLQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalISLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}
function initEvent()
{
	var obj=document.getElementById("AccountFlag");
	if (obj)
	{
		jQuery("#AccountFlag").on("click", BAccountFlag_Clicked);
	}
}

/*****
*Add By QW20170602
*��Ӧ���˱�־��ť�����½��в�ѯ
*buttonstring:��ť�ı�
*mestring:������ʾ�ı�
*Modify By QW20170927 �����:456193
******/
function BAccountFlag_Clicked()
{
	SelectFlag=0
	//if(jQuery('#AccountFlag').is(':checked')==true)
	//var AccountFlag=getElementValue("AccountFlag")
	if (getElementValue("AccountFlag"))
	{
		mestring='��ȷ��Ҫ����ѡ��ⵥȡ�����ˣ�'
		buttonstring='����ȡ��'
		AccountFlag=1;
	}
	else 
	{ 
		AccountFlag=0;
		mestring='��ȷ��Ҫ����ѡ��ⵥ���ˣ�';
		buttonstring='�������';
	}
	findGridData();
}
/*****
*Add By QW20170602
*��ѯ����
*modify by QW0008 �޸�query����ȡֵ������
*modify by QW0008 ����ȫѡ/��ѡ��ť
******/   
function findGridData(){
	$HUI.datagrid("#DHCEQInStockAccount",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQAccountList",
	        	QueryName:"GetInStock",
				InStockNo:getElementValue("InStockNo"),
				ProviderDR:getElementValue("ProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				CurAccountFlag:AccountFlag,
				CurGroupID:curGroupID,
				BuyLocDR:getElementValue("BuyLocDR"),
				EquipName:getElementValue("EquipName")
		},
		border:false,
	    striped:'true',
	    fit: true,
	    toolbar:[{
                iconCls: 'icon-ok', 
                text:SelectString,      
                handler: function(){
                       selectall();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-add', 
                text:buttonstring,      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
	   });
}

/*****
*Add By QW20170602
*��˼�ȡ�����
*����ѡ�е���ⵥID������˼�ȡ���������
*modify by QW0008 �޸���ⵥID��ȡ��ʽ
*modify by QW0008 ����user������
*modify by QW0008 �޸ķ���ֵ�жϡ�
******/
function DeleteGridData(){
	InStockIDs=$("input[name='ckId']").map(function () { 
	if($(this).prop("checked"))  return $(this).val();         
	}).get().join(",");
	if (InStockIDs=="") return;
	messageShow("confirm","","",mestring,"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	var data=tkMakeServerCall("web.DHCEQAccountList","SaveDataByStockDR",InStockIDs,AccountFlag,curSSUserID);
	var errorcode=data.split("^"); 
	if (errorcode[0] ==0)
	{
		creatToolbar()
		$('#DHCEQInStockAccount').datagrid('reload');
		$.messager.show({title: '��ʾ',msg: '�����ɹ�'});
	}
	else
    {
		$.messager.popover({msg:"������Ϣ:"+errorcode[0],type:'error'});
		return
    }
    
}

/*****
*Add By QW0008 
*ȫѡ/��ѡ��ҳ����checkbox
*modify by QW0009 ������ȫѡ��ȡ��
******/
function selectall()
{
	 $("input[name='ckId']").each(function(rowIndex,rowData) {
		 if(SelectFlag==1)
	     {
		    
		    $(this).prop("checked", false);  
	     } 
    	 else
    	 {
	    	$('#DHCEQInStockAccount').datagrid('selectAll');
	    	$(this).prop("checked", true); 
	    	
	 	 }   
   });  
    if(SelectFlag==0) 
    {
	    $('#DHCEQInStockAccount').datagrid('selectAll');
	    SelectFlag=1	
    }      
   else 
   {
	   $('#DHCEQInStockAccount').datagrid('unselectAll');
	   SelectFlag=0
   }
   creatToolbar();
}

function setSelectValue(elementID,rowData)
{
	//add by ZY0226 2020-04-29
	if (elementID=="Provider") {
			setElement("ProviderDR",rowData.TRowID)
		}
	else {setDefaultElementValue(elementID,rowData)}
}

