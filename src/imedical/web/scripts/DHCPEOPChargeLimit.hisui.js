
//����	DHCPEOPChargeLimit.hisui.js
//����	������Ȩ��ά��	
//����	2019.04.29
//������  xy

$(function(){
	
	InitCombobox();
	
	InitOPChargeLimitDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
      
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
          
    //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
        });

	$("#DFLimit").attr("disabled",true);
     //��ѡ��Ĵ����¼�
    $HUI.checkbox('#OPFlag',{
        onChecked:function(e,value)
        {
            $("#DFLimit").attr("disabled",false);
            
        },
        onUnchecked:function(e,value)
        {
            $("#DFLimit").attr("disabled",true);
			$("#DFLimit").val("");
            
        } 
    });


})

 //����
function BAdd_click()
{
	BSave_click("0");
}

//�޸�
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type)
{
	
	if(Type=="1"){
		var iUser=$("#UserId").val();
		if(iUser==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
		
		if($("#UserId").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var iUser=$("#OPName").combogrid('getValue');
        if (($("#OPName").combogrid('getValue')==undefined)||($("#OPName").combogrid('getValue')=="")){var iUser="";}
		
		if (iUser!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",iUser);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ�����Ա","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#OPName", {
				required: true,
	    	});
			$.messager.alert("��ʾ","����Ա����Ϊ��","info");
			return false;
		}

	
	}
	
	var iOPFlag="N";
	var OPFlag=$("#OPFlag").checkbox('getValue');
	if(OPFlag) iOPFlag="Y";
	
	var iDFLimit=$("#DFLimit").val();
	if(iOPFlag=="N"){
		if(iDFLimit!=""){ 
			$.messager.alert("��ʾ","�Żݴ��۲�����,����ۿ�ֵӦΪ��","info");
			return false;
		}
	}
	if(iOPFlag=="Y"){
		if(iDFLimit==""){ 
			$.messager.alert("��ʾ","�������ۿ�ֵ","info");
			return false;
		}
		
		if((iDFLimit<=0)||(iDFLimit>=100)){
			$.messager.alert("��ʾ","�ۿ�ֵӦ����0С��100","info");
			return false;
		}else{
			if (IsFloat(iDFLimit)){}
			else 
			{   
				$("#DFLimit").focus();
		    	$.messager.alert("��ʾ","�ۿ�ֵ����Ϊ0","info");
				return false;
			}
		}
		
		
	}
	
	var iASChargedFlag="N";
	var ASChargedFlag=$("#ASChargedFlag").checkbox('getValue');
	if(ASChargedFlag) iASChargedFlag="Y";
	var iRoundingFeeMode="0"
    var iRoundingFeeMode=$("#RoundingFeeMode").combobox('getValue'); 
    
  
	var Instring=trim(iUser)	
				+"^"+trim(iDFLimit)
				+"^"+iOPFlag
				+"^"+iASChargedFlag
				+"^"+iRoundingFeeMode
				; 
	var flag=tkMakeServerCall("web.DHCPE.ChargeLimit","OPChargeLimit",Instring);
	
    if (flag==0)
	{
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BClear_click();
		
	 }
	if (flag=="NoUser")
	{
		 $.messager.alert("��ʾ","û��ѡ������Ա","error");
		
	}
}

//ɾ��
function BDelete_click()
{
	
	
	
	var UserId=$("#UserId").val()
	if(UserId==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	else{
		
		$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ChargeLimit", MethodName:"DeleteOPChargeLimit", UserId:UserId},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success");	
					BClear_click();
			        
				}
			});	
		}
	});
	}
	
}



//��ѯ
function BFind_click()
{
   $("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:$("#OPName").combogrid('getValue')
			});

}

//����
function BClear_click()
{
	$("#RoundingFeeMode").combobox('setValue',"");
	$("#OPName").combogrid('setValue',"");
	$("#UserId,#DFLimit").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BAdd").linkbutton('enable');
	$("#OPName").combogrid('enable');

	$("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:""
			});
}

function InitCombobox()
{
	
	//����Ա
	 	 var OPNameObj = $HUI.combogrid("#OPName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//��� 
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190} 
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});

		
	//������
	var RFMObj = $HUI.combobox("#RoundingFeeMode",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:'������'},
            {id:'1',text:'��������'},
            {id:'2',text:'��������'},
            {id:'3',text:'���˺����������'}
        ]

		});
}


function InitOPChargeLimitDataGrid(){
		$HUI.datagrid("#OPChargeLimitQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ChargeLimit",
			QueryName:"FindChargeLimit",
		    UserId:$("#OPName").combogrid('getValue'),
		},
		columns:[[
	
		    {field:'TUserId',title:'TUserId',hidden: true},
		    {field:'TRoundingFeeModeID',title:'TRoundingFeeModeID',hidden: true},
			{field:'TOPNumber',width:'200',title:'����'},
			{field:'TName',width:'200',title:'����Ա'},
			{field:'TDFLimit',width:'200',title:'��������ۿ�'},
			{field:'TOPFlag',width:'200',title:'�Żݴ���'},
			{field:'TASChargedFlag',width:'200',title:'ȡ��/��ͬ�շ���Ȩ'},
			{field:'TRoundingFeeMode',width:'200',title:'������'}			
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#UserId").val(rowData.TUserId);
				$("#OPName").combogrid('setValue',rowData.TName);
				$("#DFLimit").val(rowData.TDFLimit.split("%")[0]);
				$("#RoundingFeeMode").combobox('setValue',rowData.TRoundingFeeModeID);
				if(rowData.TOPFlag=="��"){
					$("#OPFlag").checkbox('setValue',false);
				}if(rowData.TOPFlag=="��"){
					$("#OPFlag").checkbox('setValue',true);
				}
				if(rowData.TASChargedFlag=="��"){
					$("#ASChargedFlag").checkbox('setValue',false);
				}if(rowData.TASChargedFlag=="��"){
					$("#ASChargedFlag").checkbox('setValue',true);
				}
				 $("#BAdd").linkbutton('disable');
			     $("#OPName").combogrid('disable');


		}
			
	})

		
}



function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}


//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}


