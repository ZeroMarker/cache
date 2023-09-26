
//����	DHCPEItemExtend.hisui.js
//����	���ҽ����չ
//����	2019.05.23
//������  xy

$(function(){
		
	InitCombobox();
	
	InitItemExtendDataGrid();
      
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
    
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });  
    
       
    //����(�۸�ά������)
	$("#IEBAdd").click(function() {	
		IEBAdd_click();		
        });
    
        
    //�޸�(�۸�ά������)
	$("#IEBUpdate").click(function() {	
		IEBUpdate_click();		
        }); 
   
   //����(�۸�ά������)
	$("#IEBClear").click(function() {	
		IEBClear_click();		
        }); 
   
})

//����
function BAdd_click()
{
	var ID=$("#ItemDesc").combogrid('getValue');
	if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ID="";}
    
	if (ID=="")
	{
		$.messager.alert("��ʾ","ҽ�����Ʋ���Ϊ��","info");
		return false;
	}
	if (ID.indexOf("||")<0){
			$.messager.alert("��ʾ","��ѡ��ҽ������","info");
			return false
		}

	var Flag=tkMakeServerCall("web.DHCPE.ItemExtend","InsertIE",ID);
	
	if (Flag!=0)
	{
		$.messager.alert("��ʾ",Flag,"error");
		return false;
	}
	else
	{
		$.messager.alert("��ʾ","�����ɹ�","success");
		$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchItemExtendNew",
			ArcItemID:"",
			});
	}
	
}

//����
function BClear_click()
{
	$("#ItemDesc").combogrid('setValue',"");
}

//��ѯ
function BFind_click()
{
	var ID=$("#ItemDesc").combogrid('getValue');
	$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchItemExtendNew",
			ArcItemID:ID,
			});
}
 


function InitCombobox()
{
	  
		 //ҽ������
	   var OPNameObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=QueryFeeID",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Name',
		onBeforeLoad:function(param){
			param.FeeTest = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',width:40},
			{field:'Name',title:'ҽ������',width:200},
			{field:'Code',title:'ҽ������',width:150},
			
				
		]]
		});
}

function InitItemExtendDataGrid()
{
	$HUI.datagrid("#ItemExtendQueryTab",{
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
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchItemExtendNew",
			ArcItemID:"",
		},
		columns:[[
	
		    {field:'TRowID',title:'ID',hidden: true},
		    {field:'ARCIMID',title:'ID',hidden: true},
		    {field:'Type',title:'Type',hidden: true},
			{field:'TARCDesc',width:350,title:'ҽ������'},
			{field:'TCreateUser',width:250,title:'������'},
			{field:'TCreateDate',width:300,title:'����ʱ��'},
			{field:'TPrice',title:'�۸�ά��',width:80,align:'center',
			
			formatter:function(value,rowData,rowIndex){
				if(rowData.TRowID!=""){
					
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/price_maint.png"  title="�۸�ά��" border="0" onclick="openIEPriceWin('+rowData.TRowID+',1)"></a>';
			
				}
				}},
			{field:'TSendItem',title:'����ά��',width:80,align:'center',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TRowID!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/ga_maint.png"  title="����ά��" border="0" onclick="openIEPriceWin('+rowData.TRowID+',2)"></a>';
				}
				}},
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.TRowID);
					
					
		}
		
			
	})
	


}

 //�޸�(�۸�ά������)
 function IEBUpdate_click()
 {
	 IESave_click("1");
 }
 
//����(�۸�ά������)
function IEBAdd_click()
{
	IESave_click("0");
} 

//����(�۸�ά������)
function IESave_click(Type)
{
	 ParRef=$("#ParRef").val();
	var ID=$("#IEPID").val();
	if((Type=="1")&&(ID==""))
	{
		$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
		return false;
		
	}
	if((Type=="0")&&(ID!=""))
	{
		$.messager.alert("��ʾ","��������ѡ���¼,��������������","info");
		return false;
	}
	var Price=$("#Price").numberbox('getValue');
	if (Price=="")
	{
		if($("#IEType").val()=="1"){$.messager.alert("��ʾ","�۸���Ϊ��","info");}
		if($("#IEType").val()=="2"){$.messager.alert("��ʾ","������Ѳ���Ϊ��","info");}
		var valbox = $HUI.validatebox("#Price", {
			required: true,
	  	});
		return false;
	}
		
	
	
	var StartDate=$.trim($("#StartDate").datebox('getValue'));
	if (StartDate=="")
	{
		$.messager.alert("��ʾ","��ʼ���ڲ���Ϊ��","info");
		var valbox = $HUI.datebox("#StartDate", {
			required: true,
	  	});
		return false;
	}
	
	var EndDate=$.trim($("#EndDate").datebox('getValue'));
	
  	var iStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",StartDate)
	if (EndDate!=""){
		var iEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate)
		if(iStartDate>=iEndDate){
			$.messager.alert("��ʾ","��ʼ����ӦС�ڽ�ֹ����","info");
			return false;
		}
	}
	
	if(Type=="0"){
		var OldtEndDateStr=tkMakeServerCall("web.DHCPE.ItemExtend","SearchNewPriceEndDate",ParRef,$("#IEType").val());
		var OldtEndDate=OldtEndDateStr.split("^")[0];
		var flag=OldtEndDateStr.split("^")[1];
		if(flag=="1")
		{
			if(OldtEndDate!=""){
				if(iStartDate<=OldtEndDate){
					$.messager.alert("��ʾ","��ʼ����Ӧ�����ϴμ�¼�Ľ�ֹ����","info");
					return false;
				}
			}else{
				$.messager.alert("��ʾ","�ϴμ�¼ûά����ֹ����,����������","info");
				return false;
			}
		
		
		}
	}




	var SetsFlag="";
	if($("#IEType").val()=="1"){
		Strings=ParRef+"^"+Price+"^"+StartDate+"^"+EndDate+"^"+SetsFlag;
		var Flag=tkMakeServerCall("web.DHCPE.ItemExtend","UpdateIEPrice",ID,Strings);
	}
	if($("#IEType").val()=="2"){
		Strings=ParRef+"^"+Price+"^"+""+"^"+StartDate+"^"+EndDate+"^"+""+"";
		var Flag=tkMakeServerCall("web.DHCPE.ItemExtend","UpdateIESendItem",ID,Strings);
	}
	if (Flag!=0)
	{
		$.messager.alert("��ʾ",Flag,"error");
		return false;
	}
	else
	{
		if(Type=="0"){ $.messager.alert("��ʾ","�����ɹ�","success");}
		if(Type=="1"){ $.messager.alert("��ʾ","�޸ĳɹ�","success");}
		IEBClear_click();
	}
}

function IEBClear_click()
{
	
	$("#IEPID").val("");
	$("#Price").numberbox('setValue',"")
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	var valbox = $HUI.datebox("#StartDate", {
			required: false,
	  	});
	var valbox = $HUI.validatebox("#Price", {
			required: false,
	  	});
	  
	if($("#IEType").val()=="1"){
		$("#IEPriceQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ItemExtend",
				QueryName:"SerchIEPrice",
				ParRef:$("#ParRef").val(),
				});
	 }
	 if($("#IEType").val()=="2"){
		$("#IEPriceQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ItemExtend",
			    QueryName:"SerchIESendItem",
				ParRef:$("#ParRef").val(),
				});
	 }
}
function FillARCInfo(ID)
{
	if(ID==""){
		return false;
	}
	$("#ParRef").val(ID);
	var Info=tkMakeServerCall("web.DHCPE.ItemExtend","GetARCDesc",ID);
	var InfoArr=Info.split("^");
	$("#ARCDesc").val(InfoArr[0]);
	$("#ARCPrice").val(InfoArr[1]);
	
}




//�۸�ά��
var openIEPriceWin = function(ID,IEType){
	if(IEType=="1"){
	$("#IEType").val(IEType);
	$("#IEPID").val("");
	$("#Price").numberbox('setValue',"")
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#StartDate").datebox("enable");
	$("#Price").attr('disabled',false);

	document.getElementById('tPrice').innerHTML="�۸�";	
	
	FillARCInfo(ID);
	//alert(ItemID)
	$HUI.window("#IEPriceWin",{
		title:"�۸�ά��",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:1000,
		height:390
	});
	
	var QryLisObj = $HUI.datagrid("#IEPriceQueryTab",{
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
		queryParams:{
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchIEPrice",
			ParRef:ID,
		},
		
		columns:[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TBeginDate',width:'150',title:'��ʼ����'},
			{field:'TEndDate',width:'150',title:'��ֹ����'},
			{field:'TPrice',width:'150',title:'�۸�',align:'right',type:'numberbox',options:{min:0,precision:2}},
			{field:'TCreateUser',width:'150',title:'������'},
			{field:'TCreateDate',width:'150',title:'����ʱ��'},	
			
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#IEPID").val(rowData.TRowID);
				$("#StartDate").datebox('setValue',rowData.TBeginDate);
				$("#EndDate").datebox('setValue',rowData.TEndDate);
				$("#Price").numberbox('setValue',rowData.TPrice);	
				//$("#Price").val(rowData.TPrice);	
				if(rowData.TRowID!=""){
					$("#StartDate").datebox("disable");
					$("#Price").attr('disabled',true);
				}else{
					$("#StartDate").datebox("enable");
					$("#Price").attr('disabled',false);
				}

					
		}
		})
	}
	
	if(IEType=="2"){
	$("#IEType").val(IEType);
	$("#IEPID").val("");
	$("#Price").numberbox('setValue',"");
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#StartDate").datebox("enable");
	$("#Price").attr('disabled',false);

    document.getElementById('tPrice').innerHTML="�������";	
	FillARCInfo(ID);
	
	$HUI.window("#IEPriceWin",{
		title:"����ά��",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:1000,
		height:390
	});
	
	var QryLisObj = $HUI.datagrid("#IEPriceQueryTab",{
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
		queryParams:{
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchIESendItem",
			ParRef:ID,
		},
		
		columns:[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TGroupFlag',title:'GroupFlag',hidden: true},
			{field:'TBeginDate',width:'150',title:'��ʼ����'},
			{field:'TEndDate',width:'150',title:'��ֹ����'},
			{field:'TCostFeeMin',width:'150',title:'�������',align:'right',type:'numberbox',options:{min:0,precision:2}},
			{field:'TCreateUser',width:'150',title:'������'},
			{field:'TCreateDate',width:'150',title:'����ʱ��'},	
			
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#IEPID").val(rowData.TRowID);
				$("#StartDate").datebox('setValue',rowData.TBeginDate);
				$("#EndDate").datebox('setValue',rowData.TEndDate);
				$("#Price").numberbox('setValue',rowData.TCostFeeMin);
				if(rowData.TRowID!=""){
					$("#StartDate").datebox("disable");
					$("#Price").attr('disabled',true);
				}else{
					$("#StartDate").datebox("enable");
					$("#Price").attr('disabled',false);
				} 
	
					
		}
		})
	}
	
	
};


/*
//�۸�ά��
function Price_Click(ItemID)
{
	var url="dhcpeieprice.hisui.csp"+"?ItemID="+ItemID;
	
	websys_lu(url,false,'width=1000,height=600,hisui=true,title=�۸�ά��')
}
	

//����ά��	
function SendItem_Click()
{
	var url="dhcpeieprice.hisui.csp?ItemID="+ItemID;
	websys_lu(url,false,'width=560,height=300,hisui=true,title=����ά��')
}



*/

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/;
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
}
