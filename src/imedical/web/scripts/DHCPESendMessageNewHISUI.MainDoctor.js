//名称	DHCPESendMessageNewHISUI.MainDoctor.js
//功能	总检高危上报	
//创建	2019.03.13
//创建人  xy
var init = function(){
	
	
	var Info=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetBaseInfo",PAADM);
	var Message=tkMakeServerCall("web.DHCPE.SendMessage","GetContent",PAADM,OrderItemID);
	$("#Content").val(Message)
	
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
	
	//保存
	$("#BSave").click(function() {	
		Save();		
      });
      
     //保存并发送  
    $("#BSend").click(function() {		
		Send();			
      });
         
    //清屏
    $("#BClear").click(function() {	
		BClear();		
      });

    InitGWListDataGrid();  
			
}
function InitGWListDataGrid()
{
	var GWListObj = $HUI.datagrid("#GWList",{
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
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"HighRiskByPAADM",
			PAADM:PAADM,
			OrderItemID:OrderItemID

		},
		columns:[[
			{field:'TID',hidden:true},
			{field:'TItem',title:'项目',hidden:true},
			{field:'TDetail',title:'高危描述',width:400},
			{field:'TOrderItemID',hidden:true},
			{field:'Tcontent',hidden:true},
			{field:'TSendFlag',title:'发送短信',width:250},
			{field:'TSendDate',title:'发送日期',width:100},
			{field:'TCRMFlag',width:70,align:'center',title:'随访',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			
			
		]],
		
		onClickRow:function(rowIndex,rowData){
			
			setValueById("ID",rowData.TID)
			setValueById("HighRisk",rowData.TDetail)
			$("#Content").val(rowData.Tcontent)
			if(rowData.TCRMFlag=="Y"){
					$("#CRMFlag").checkbox('setValue',true);
				}else{
					$("#CRMFlag").checkbox('setValue',false);
				}		
		},
		
	
		})
}


function BClear()
{
	$("#ID").val("");
    $("#Content").val(""); 
    $(".hisui-checkbox").checkbox('setValue',false);
    $(".hisui-combobox").combobox('select','');
    InitGWListDataGrid();
}


function Save(AlertFlag)
{	
	var Detail=$("#HighRisk").combobox("getValue")
	if (($("#HighRisk").combobox("getValue")==undefined)||($("#HighRisk").combobox('getText')=="")){var Detail="";}
	if(Detail=="")
	{
		$.messager.alert("提示","高危信息不能为空！","info");
		return false;
		
	}
	var iCRMFlag="N";
	var CRMFlag=$("#CRMFlag").checkbox('getValue');
	if(CRMFlag) {iCRMFlag="Y";}
	
	var Str=PAADM+"^"+OrderItemID+"^"+Detail+"^"+iCRMFlag;
	var ID=$("#ID").val();
	
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveHighRisk",ID,Str);
	
	if (ret>0){
		
		//$("#ID").val(ret)
		if(AlertFlag!="0"){
			BClear();
		   // InitGWListDataGrid();
		}
	}else{
		
		alert(ret)
	}
	return ret;
	
	
}
function Send()
{
	var RegNo=getValueById("RegNo");
	var TTel=getValueById("Tel");
	var MessageTemplate=$("#Content").val();
	if(MessageTemplate==""){
		$.messager.alert("提示","短信内容不能为空！","info"); 
		return false;
       }
	
	var ID=Save(0); //保存
	
	var Arr=MessageTemplate.split("[");
	if (Arr.length>1){
		var Info1=Arr[0]
		var Content=Arr[1];
		var Arr=Content.split("]");
		var Info2=Arr[1];
	
		MessageTemplate=Info1+"["+Arr[0]+"]"+Info2;
	}
	
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var UserID=session['LOGON.USERID'];
	var Type="HR";
	//var ret=cspRunServerMethod(encmeth,Type,InfoStr);
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
	if (ret!=0){
		$.messager.alert("提示","发送错误"+ret,"info"); 
		return false;
	}else{
		var AllID=ID+"^HR";
		var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID,UserID);
	
	}
     BClear();
	 InitGWListDataGrid();
	
}	
$(init);