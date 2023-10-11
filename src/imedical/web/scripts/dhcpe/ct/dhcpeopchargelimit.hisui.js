
//����	dhcpe/ct/dhcpeopchargelimit.hisui.js
//����	������Ȩ��ά��-��Ժ��	
//����	2021.08.16
//������  sxt
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_ChargeLimit";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	GetLocComp(SessionStr)
	
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
    
    $("#LocList").combobox({
	     onSelect:function(data){
		    	
		    	var LocID=$("#LocList").combobox('getValue');
		   		if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
		   		var hospId=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		   		   
			    /*****************�û����¼���(combobox)*****************/
			    //$('#OPName').combogrid('grid').datagrid('reload'); //�ؼ���
			    $HUI.combogrid("#OPName",{
					onBeforeLoad:function(param){
							param.Desc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId=hospId;

					}
		       });
		    
	           $('#OPName').combogrid('grid').datagrid('reload'); 
			   /*****************�û����¼���(combobox)*****************/
		   		
		   		$("#OPChargeLimitQueryTab").datagrid('load',{
			   		ClassName:"web.DHCPE.CT.ChargeLimit",
					QueryName:"FindChargeLimit",
				    UserId:$("#OPName").combogrid('getValue'),
				    LocID:LocID
				});

		
		    
		 }
     })


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
		var iUser=$("#OPName").combogrid('getValue');
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
		if((iDFLimit!="")&&(iDFLimit>0)){ 
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
	
	var iASChargedFlag="0";
	//var iASChargedFlag=$("#AsChargMode").combobox('getValue');
	//if(iASChargedFlag=="") iASChargedFlag=0;
	
	var iRoundingFee="0"
    var iRoundingFee=$("#RoundingFeeMode").combobox('getValue');
    
    /// ��rowid
    var ChargeLimitID=$("#ChargeLimitID").val();
  
  	var iActive="N";
	if($("#Active").checkbox('getValue')) iActive="Y";
	
	var iASCharged="N";
	if($("#ASChargedFlag").checkbox('getValue')) iASCharged="Y";
  
	 //���֧��
    var iSetASCharged="N";
	var SetASCharged=$("#SetASCharged").checkbox('getValue');
	if(SetASCharged) iSetASCharged="Y";

	 //ȫ������
    var iALLRefund="N";
	var ALLRefund=$("#ALLRefund").checkbox('getValue');
	if(ALLRefund) iALLRefund="Y";

	var Instring=trim(iUser)	
				+"^"+trim(iDFLimit)
				+"^"+iOPFlag
				+"^"+iASCharged
				+"^"+iASChargedFlag
				+"^"+iRoundingFee
				+"^"+iSetASCharged
				+"^"+iALLRefund
				; 
	var flag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","OPChargeLimit",Instring,ChargeLimitID,$("#LocList").combobox("getValue"),session['LOGON.USERID'],iActive);
    if (flag.split("^")[0]<0)
	{
		 $.messager.alert("��ʾ",flag.split("^")[1],"error");
			
	}
	else
	{
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
		BClear_click();
		
	}
}

//ɾ��
function BDelete_click()
{
	
	var UserId=session['LOGON.USERID'];
	
    var ChargeLimitID=$("#ChargeLimitID").val();
    
	if(ChargeLimitID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	else{
		
		$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			var ID
			$.m({ ClassName:"web.DHCPE.CT.ChargeLimit", MethodName:"DeleteOPChargeLimit", ID:ChargeLimitID,UserId:UserId},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
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
	
	var LocID=$("#LocList").combobox('getValue');
    if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
    
   $("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.CT.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:$("#OPName").combogrid('getValue'),
				LocID:LocID
			});

}

//����
function BClear_click()
{
	$("#ChargeLimitID").val("");
	$("#RoundingFeeMode").combobox('setValue',"");
	$("#OPName").combogrid('setValue',"");
	$("#UserId,#DFLimit").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BAdd").linkbutton('enable');
	$("#OPName").combogrid('enable');
	//$("#AsChargMode").combobox('setValue',"");
	
	$("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.CT.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:"",
				LocID:$("#LocList").combobox('getValue'),
			});
}

function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	//����Ա
	 var OPNameObj = $HUI.combogrid("#OPName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
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
			param.LocID=LocID;
			param.hospId=hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190} 
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
			
		}

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
		
	/*	
	// ��ͬ�շ�
	var RFMObj = $HUI.combobox("#AsChargMode",{
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
		*/
}


function InitOPChargeLimitDataGrid(){
	
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
		
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
			ClassName:"web.DHCPE.CT.ChargeLimit",
			QueryName:"FindChargeLimit",
		    UserId:$("#OPName").combogrid('getValue'),
		    LocID:LocID
		},
		columns:[[
			
		    {field:'TUserId',title:'TUserId',hidden: true},
		    {field:'TRoundingFeeModeID',title:'TRoundingFeeModeID',hidden: true},
			{field:'TOPNumber',width:120,title:'����'},
			{field:'TName',width:170,title:'����Ա'},
			{field:'TDFLimit',width:120,title:'��������ۿ�'},
			{field:'TOPFlag',width:100,title:'�Żݴ���',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="��"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
			},
			{field:'CLOPChargeLimit',hidden:true},
			{field:'TAscharge',width:150,title:'ȡ��/��ͬ�շ���Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="��"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
			},
			{field:'CLOPChargeLimitDesc',title:'��ͬ�շ�ģʽ',hidden: true},
			{field:'CLRoundingFee',hidden:true},
			{field:'CLRoundingFeeDesc',width:180,title:'������'},
			{field:'CLNoActive',width:90,title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="��"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  },
		  {field:'CLSetASCharged',width:90,title:'���֧��',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  },
		  {field:'CLALLRefund',width:90,title:'ȫ������',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  }						
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#UserId").val(rowData.TUserId);
				$("#OPName").combogrid('setValue',rowData.TName);
				$("#DFLimit").val(rowData.TDFLimit.split("%")[0]);
				$("#RoundingFeeMode").combobox('setValue',rowData.CLRoundingFee);
				if(rowData.TOPFlag=="��"){
					$("#OPFlag").checkbox('setValue',false);
				}if(rowData.TOPFlag=="��"){
					$("#OPFlag").checkbox('setValue',true);
				}
				
				if(rowData.TAscharge=="��"){
					$("#ASChargedFlag").checkbox('setValue',false);
				}if(rowData.TAscharge=="��"){
					$("#ASChargedFlag").checkbox('setValue',true);
				}
				
				$("#ChargeLimitID").val(rowData.ID)
				//$("#AsChargMode").combobox('setValue',rowData.CLOPChargeLimit);
				
				if(rowData.CLNoActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.CLNoActive=="��"){
					$("#Active").checkbox('setValue',true);
				}
				
				if(rowData.CLSetASCharged=="Y"){
					$("#SetASCharged").checkbox('setValue',true);
				}else{
					$("#SetASCharged").checkbox('setValue',false);
				}
				
				if(rowData.CLALLRefund=="Y"){
					$("#ALLRefund").checkbox('setValue',true);
				}else{
					$("#ALLRefund").checkbox('setValue',false);
				}

				$("#OPName").combogrid("grid").datagrid("reload",{"q":rowData.TName});
				
				$("#OPName").combogrid('setValue',rowData.TUserId);
				
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


