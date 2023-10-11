//����	DHCPESendMessageNewHISUI.Doctor.js
//����	¼���Σ�ϱ�	
//����	2019.03.13
//������  xy

var init = function(){
	
	
	var Info=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetBaseInfo",PAADM);
	var Message=tkMakeServerCall("web.DHCPE.SendMessage","GetContent",PAADM,OrderItemID);
	$("#TContent").val(Message)
	
	$("#RegNo").val(Info.split("^")[4])
	$("#Name").val(Info.split("^")[0])
	$("#Tel").val(Info.split("^")[5])
	$("#Sex").val(Info.split("^")[1])
	
	var HighRiskObj = $HUI.combobox("#HighRisk",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindAdviceByOrder&ResultSetType=array",
		valueField:'AdviceInfo',
		textField:'AdviceInfo',
		onBeforeLoad:function(param){
			param.OrderItemID = OrderItemID;
			param.PAADM = PAADM;
		}
	});
	
	$("#BSave").click(function() {
			
			Save();	
			
        });
        
    $("#BSend").click(function() {
			
			Send();	
			
        }); 
      InitGWListDataGrid();    
	
}
function InitGWListDataGrid()
{
	var GWListObj = $HUI.datagrid("#GWList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"HighRiskByPAADM",
			PAADM:PAADM,
			OrderItemID:OrderItemID

		},
		columns:[[
			{field:'TID',hidden:true},
			{field:'TItem',title:'��Ŀ',width:250},
			{field:'TDetail',title:'��Σ����',width:450},
			{field:'TOrderItemID',hidden:true}
			
		]],
		
		onClickRow:function(rowIndex,rowData){
			
			setValueById("ID",rowData.TID)
			setValueById("HighRisk",rowData.TDetail)
		},
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		})		
}
function Save(AlertFlag)
{
	var Detail=$("#HighRisk").combobox("getValue")
	if (($("#HighRisk").combobox("getValue")==undefined)||($("#HighRisk").combobox('getText')=="")){var Detail="";}
	
	if(Detail=="")
	{
		$.messager.alert("��ʾ","��Σ��Ϣ����Ϊ�գ�","info");
		return false;
	}
	var Str=PAADM+"^"+OrderItemID+"^"+Detail;
	var ID=getValueById("ID")
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveHighRisk",ID,Str);
	
	if (ret>0){
		obj=document.getElementById("ID");
		if (obj) obj.value=ID;
		if (AlertFlag!=0){
			 InitGWListDataGrid();  
		}
	}else{
		$.messager.alert("��ʾ",ret,"info");
	}
	return ret;
		
}
function Send()
{
	var ID=Save(0);
	
	var RegNo=getValueById("RegNo");
	var TTel=getValueById("Tel");
	var MessageTemplate=$("#TContent").val();
	if(MessageTemplate==""){
			$.messager.alert("��ʾ","�������ݲ���Ϊ��!","info");
			return false;
       }
	var Arr=MessageTemplate.split("[");
	if (Arr.length>1){
		var Info1=Arr[0]
		var Content=Arr[1];
		var Arr=Content.split("]");
		var Info2=Arr[1];
	
		MessageTemplate=Info1+"["+Arr[0]+"]"+Info2;
	}
	
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var Type="HR";
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
	if (ret!=0){
		$.messager.alert("��ʾ","���ʹ���:"+ret,"info");
		return false;
	}else{
		var AllID=ID+"^HR";
		var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID);
	
	}
	 InitGWListDataGrid();  
	
}	
$(init);