 
var AccountFlag=0;
var mestring='��ȷ��Ҫ����ѡ��ⵥ���ˣ�';
var buttonstring='�������';
var SelectString='ȫ/��ѡ'	
var SelectIcon = 'icon-ok'
var SelectFlag=0
var SelectedRowID = "";
var PreSelectedRowID = "";
var InitItemGridFlag=0;

var curUserID ="" //Add By QW20181101 �����:735348
//�������:	442377		Mozy	20170903
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};

var GlobalObj = {
	UseLocDR : "",
	ProviderDR : "",
	ClearData : function(vElementID)
	{

		if (vElementID=="UseLoc") {this.UseLocDR = "";}

		if (vElementID=="Provider") {this.ProviderDR = "";}

	},
	ClearAll : function()
	{

		this.UseLocDR = "";

		this.ProviderDR = "";

	}
}
//modify by QW0009 �޸�checkbox�����Բ���ѡ����(attr->prop)��checkboxѡ�иı䱳��ɫ����
$(document).ready(function () {
	//modify by QW0008 ��ʼ����Ӧ��
	initProviderPanel();			//��Ӧ��
	initProviderData();			//��Ӧ��
	initUseLocPanel();			//����
	initUseLocData();			//����
	//end 
	//add by QW0008 �ܼ��ı�������Ϊֻ��
	setJQValue($("#TotalFee"),"")
	setJQValue($("#TotalNum"),"")
	$("#TotalFee").textbox('textbox').prop('disabled',true); 
	$("#TotalNum").textbox('textbox').prop('disabled',true); 
	//end
	initUserInfo(); //Add By QW20181101 �����:735348
	$('#DHCEQInStockAccount').datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQAccountList",
	        QueryName:"GetInStock",
	        //modify by QW0008 �޸�query����ȡֵ������
	        Arg1:getJQValue($("#InStockNo")),  
	        Arg2:GlobalObj.ProviderDR,
	        Arg3:getJQValue($("#StartDate")),  
	        Arg4:getJQValue($("#EndDate")),  
	        Arg5:AccountFlag,
	        Arg6:session['LOGON.GROUPID'],
	        Arg7:GlobalObj.UseLocDR,
	        Arg8:getJQValue($("#EquipName")),
	        ArgCnt:8
	    },
	    border:'true',
	    striped:'true', 
	    toolbar:[{   //modify by QW0008 ����ȫѡ��ť��ȫѡ����   
	                iconCls: SelectIcon, 
	                text:SelectString,      
	                handler: function(){
	                       selectall();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-cut', 
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
   		//modify by QW0008 �޸�query���;�Զ���grid�е�checkbox
   		//modify by QW0009 ��ֹcheckbox��ѡ
	    columns:[[
	    	{ field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
	    	{field:'TInStockNo',title:'��ⵥ��',width:150,align:'center'},   // modified by kdf 2018-02-08 ����ţ�548506  
	        {field:'TBuyLoc',title:'����',width:100,align:'center'},        
	        {field:'TISLRowID',title:'�����ϸID',width:50,hidden:true},
	        {field:'TQuantityNum',title:'����',width:150,align:'center'},  
			{field:'TOriginalFee',title:'����',width:150,align:'center'},
			{field:'TotalFee',title:'�ܽ��',width:100,align:'center'}, 
			{field:'TEquipName',title:'�豸����',width:150,align:'center'},    // modified by jyp 2019-03-11   modified by wy 2019-3-14�豸�����Ƹ�Ϊ�豸����
			{field:'TFunds',title:'�ʽ���Դ',width:150,align:'center'},
			{field:'TExpenditures',title:'������Դ',width:150,align:'center'},
			{field:'TRemark',title:'��ע',width:100,align:'center'}, 
			{field:'TProvider',title:'��Ӧ��',width:100,align:'center'}, 
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},               
	    ]],
	    //modify by QW0008 ����ѡ�п���
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
			Total_Change();
	  },
	    fit: true, 
	    singleSelect: false,
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36]   
	});

    /*****
	*Add By QW20170602
	*��ѯ����
	*modify by QW0008 �޸�query����ȡֵ������
	*modify by QW0008 ����ȫѡ/��ѡ��ť
	******/   
	function findGridData(){
		$('#DHCEQInStockAccount').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQAccountList",
	        QueryName:"GetInStock",
	        //modify by QW0008 �޸�query����ȡֵ������
	        Arg1:getJQValue($("#InStockNo")),  
	        Arg2:GlobalObj.ProviderDR,
	        Arg3:getJQValue($("#StartDate")),  
	        Arg4:getJQValue($("#EndDate")),  
	        Arg5:AccountFlag,
	        Arg6:session['LOGON.GROUPID'],
	        Arg7:GlobalObj.UseLocDR,
	        Arg8:getJQValue($("#EquipName")),
	        ArgCnt:8
	    },
	    border:'true',
	    striped:'true',
	    fit: true,
	    toolbar:[{        
	                iconCls: SelectIcon, 
	                text:SelectString,      
	                handler: function(){
	                       selectall();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-cut', 
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
	                 }] 
	   });
	    $("#TotalNum").textbox("setValue","");   //add by wy 2018-2-2
		$("#TotalFee").textbox("setValue","");
	   
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
		var combindata=$("input[name='ckId']").map(function () { 
		if($(this).prop("checked"))  return $(this).val();         
		}).get().join(",");
	    if (combindata!="") {
	        $.messager.confirm('��ȷ��', mestring, function (b) { 
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
	       
		        $.ajax({
		            url :"dhceq.jquery.method.csp",
		            type:"POST",
		            data:{
		                ClassName:"web.DHCEQAccountList",
		                MethodName:"SaveDataByStockDR",
		                Arg1:combindata,
		                Arg2:AccountFlag,
		                Arg3:curUserID,    
		                ArgCnt:3
		            },
		            success:function (data, response, status) {
		            $.messager.progress('close');
		            
		            var errorcode=data.split("^"); 
		            if (errorcode[0] ==0) {
			            setJQValue($("#TotalFee"),"")
						setJQValue($("#TotalNum"),"")
			            $('#DHCEQInStockAccount').datagrid('reload');
			            $.messager.show({
			                title: '��ʾ',
			                msg: '�����ɹ�'
			            });
		            }   
		            else {
		               $.messager.alert('����ʧ�ܣ�',errorcode[0], 'warning')
		               return;
		              }
		           }
            
		        })
		        }       
		        })
     
	    }
	    else
	    {
	        $.messager.alert("����","��ѡ��һ�У�",'err')
	    }
	}

	/*****
	*Add By QW20170602
	*��Ӧ���˱�־��ť�����½��в�ѯ
	*buttonstring:��ť�ı�
	*mestring:������ʾ�ı�
	*Modify By QW20170927 �����:456193
	******/
	$('#AccountFlag').click(function () {
		setJQValue($("#TotalFee"),"")
		setJQValue($("#TotalNum"),"")
		SelectFlag=0
		if(jQuery('#AccountFlag').is(':checked')==true)
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
	});
	/*****
	*Add By QW0008 
	*ȫѡ/��ѡ��ҳ����checkbox
	*modify by QW0009 ������ȫѡ��ȡ��
	******/
	function selectall(){
		
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
	   Total_Change();
	}
	/*****
	*Add By QW0008 
	*����ѡ�е��뵥idͳ���������������
	*���ý���ܼƺ������ܼ������ı����ֵ
	******/
	function Total_Change()
	{
		var combindata=$("input[name='ckId']").map(function () { 
				if($(this).prop("checked"))  return $(this).val();         
			}).get().join(",");
        $.ajax({
	        url :"dhceq.jquery.method.csp",
	        type:"POST",
	        data:{
	            ClassName:"web.DHCEQAccountList",
	            MethodName:"CalculaTotal",
	            Arg1:combindata,
	            ArgCnt:1
	        },
	        success:function (data, response, status) {
	        $.messager.progress('close');
	        var result=data.split("^"); 
	       $("#TotalNum").textbox("setValue",result[0]);
		   $("#TotalFee").textbox("setValue",result[1]);

       }

    })
	}
	
	

});
//�������:	442377		Mozy	20170903
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}

	if (vElementID=="Provider") {GlobalObj.ProviderDR = CurValue;}
}

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");

	if (vElementID=="UseLoc") {initUseLocData();}

	if (vElementID=="Provider") {initProviderData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}

function initUseLocPanel()
{
	initComboGrid("UseLoc","��������",400,true);
}

function initProviderPanel()
{
	initComboGrid("Provider","��Ӧ��",400,true);
}

//Add By QW20181101 �����:735348
function initUserInfo()
{
	 //modify by lmm 2018-10-24 �ض���ϵͳ�Ự��������curSS��ǰ׺
	var curSSUserID=session['LOGON.USERID']; 
	var curSSLocID=session['LOGON.CTLOCID'];      
    var curSSHospitalID=session['LOGON.GROUPID'];
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetMapIDBySource",curSSUserID,curSSLocID,curSSHospitalID);
    jsonData=jQuery.parseJSON(jsonData);
    curUserID=jsonData.Data["MapUserID"];
}