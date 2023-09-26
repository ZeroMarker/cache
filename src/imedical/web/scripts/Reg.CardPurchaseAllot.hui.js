var PageLogicObj={
	m_CPARowid:""
}
$(function(){
	//��ʼ��
	Init()
	//�¼���ʼ��
	InitEvent()
	//�����ż�¼��ʼ��
	CardAllotListLoad()
})
function Init(){
	InitCardAllotListGrid();
	InitUserLookup()
	InitSearchUserLookup()
}
function InitEvent(){
	$("#Save").click(SaveClick);
	$("#BFind").click(CardAllotListLoad);
	$("#StartNum,#EndNum,#Amount").blur(CardManageMouseOver);
	$("#CardNo").keyup(function(){
        if(event.keyCode == 13){
            var CardNo=FormatCardNo($("#CardNo").val());
            $("#CardNo").val(CardNo);
            $("#Find").click();
        }
    });
}
function InitCardAllotListGrid(){
	var Columns=[[    
        { field : 'RowID',title : '',width : 1,hidden:true},
		{ field: 'StartNum', title: '��ʼ����', width: 120, sortable: true, resizable: true},
		{ field : 'Amount',title : '��������',width : 70 , sortable: true, resizable: true},
        { field : 'EndNum',title : '��������',width : 150 , sortable: true, resizable: true},
        { field : 'LeftNum',title : 'ʣ������',width : 70 , sortable: true, resizable: true},
        { field : 'Date',title : '��ȡ����',width : 100 , sortable: true, resizable: true},
        { field : 'UserName',title : '��ȡ��',width : 70 , sortable: true, resizable: true},
        { field : 'LocDesc',title : '���ſ���',width : 100 , sortable: true, resizable: true},
        { field : 'Active',title : '�Ƿ���Ч',width : 70 , sortable: true, resizable: true},
        { field : 'UpdateUser',title : '������',width : 100 , sortable: true, resizable: true},
        { field : 'UpdateDate',title : '��������',width : 100 , sortable: true, resizable: true},
        { field : 'CPMNote',title : '��ע',width : 100 , sortable: true, resizable: true},
        { field : 'HOSPName',title : '��ȡԺ��',width : 70 , sortable: true, resizable: true}	
        
	]];
	var dataGrid=$("#CardAllotList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		onSelect:function(index,rowData){
			PageLogicObj.m_CPARowid=rowData["RowID"]
		},toolbar: [
			{
				iconCls: 'icon-add ',
				text:'����',
				handler: function(){
					ClearWinValue()
					PageLogicObj.m_CPARowid=""
					$("#AllotWin").dialog("open")
					$("#AllotWin").dialog("center")
				}
			}]
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
function CardAllotListLoad(){
	if($("#SearchBuyer").val()==""){
		$("#SearchBuyerId").val("")
	}
	$.cm({
	    ClassName : "web.DHCCardPurchaseManage",
	    QueryName : "CardPurchaseAllotInfo",
		StartDate:$("#StartDate").datebox("getValue"),
		EndDate:$("#EndDate").datebox("getValue"),
		ReceUser:$("#SearchBuyerId").val(),
		CardNo:$("#SearchCardNo").val(),
	    rows:99999
	},function(GridData){
		$("#CardAllotList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function InitUserLookup(){
	$("#Buyer").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'SSUSR_RowId',
            textField:'SSUSR_Name',
            columns:[[  
                {field:'SSUSR_Name',title:'�û���',width:150}, 
				{field:'SSUSR_Initials',title:'����',width:200},					
                {field:'SSUSR_RowId',title:'',width:50} 
            ]],
			pagination:true,
			panelWidth:300,
			isCombo:true,
			minQueryLen:2,
			delay:'500',
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.DHCUserGroup',QueryName: 'Finduse1'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;
				param = $.extend(param,{Desc:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#BuyerId").val(rowData["SSUSR_RowId"])
            }
    });
}
function InitSearchUserLookup(){
	$("#SearchBuyer").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'SSUSR_RowId',
            textField:'SSUSR_Name',
            columns:[[  
                {field:'SSUSR_Name',title:'�û���',width:150}, 
				{field:'SSUSR_Initials',title:'����',width:200},					
                {field:'SSUSR_RowId',title:'',width:50} 
            ]],
			pagination:true,
			panelWidth:300,
			isCombo:true,
			minQueryLen:2,
			delay:'500',
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.DHCUserGroup',QueryName: 'Finduse1'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;
				param = $.extend(param,{Desc:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#SearchBuyerId").val(rowData["SSUSR_RowId"])
            }
    });
}
///���ӹ����¼
function SaveClick(){
	var StartNum=$("#StartNum").val();
	var Amount=$("#Amount").val();
	var EndNum=$("#EndNum").val();
	var Buyer=$('#BuyerId').val();
	if (StartNum==""){
		$.messager.alert('��ʾ',"��ʼ���벻��Ϊ��");
		return false;
	}
	if (Amount==""){
		$.messager.alert('��ʾ',"��Ƭ��������Ϊ��");
		return false;
	}
	if (EndNum==""){
		$.messager.alert('��ʾ',"�������벻��Ϊ��");
		return false;
	}
	if (Buyer==""){
		$.messager.alert('��ʾ',"�����˲���Ϊ��");
		return false;
	}
	if (EndNum<StartNum){
		$.messager.alert('��ʾ',"�������벻��С�ڿ�ʼ����");
		return false;
	}
	var LogonDept=session['LOGON.CTLOCID'];
	var Note=$("#Note").val();
	if (Note.length>100){
		$.messager.alert('��ʾ',"��ע��Ϣ����");
		return false;
	}
	var UpdateUser=session['LOGON.USERID'];
	var HOSPID=session['LOGON.HOSPID'];
	var CardAllotInfo=StartNum+"^"+Amount+"^"+EndNum+"^"+Buyer+"^"+LogonDept+"^"+Note+"^"+HOSPID+"^"+UpdateUser;
	$.cm({
		ClassName:"web.DHCCardPurchaseManage",
		MethodName:"SaveCardPurchaseAllot",
		PurchaseAllotInfo:CardAllotInfo
	},function(value){
		if(value.result=="0"){
				CardAllotListLoad();
				$("#AllotWin").dialog("close")
		}else{
				$.messager.alert('��ʾ',"���ʧ��:"+value.result);
		}
	});
	
}
function CardManageMouseOver(e){
	CalCardManage($("#StartNum").val(),$("#Amount").val(),$("#EndNum").val(),e);
}

function CalCardManage(StartNum,Amount,EndNum,e){
	//alert(e.target.id)
	if (StartNum!=""){
		$("#StartNum").val(FormatCardNo(StartNum));
	}
	if (EndNum!=""){
		$("#EndNum").val(FormatCardNo(EndNum));
	}
	
	if (e.target.id=="StartNum"){
		if (StartNum==""){
			if ((EndNum!="")&&(Amount!="")){
				StartNum=FormatCardNo(parseInt(EndNum)-parseInt(Amount)+1);
		        $("#StartNum").val(StartNum);
			}
		}else{
			if (EndNum!=""){
				var Num=parseInt(EndNum)-parseInt(StartNum)+1;
				if (Num<0){
					EndNum=FormatCardNo(parseInt(StartNum)+parseInt(Amount)-1);
			        $("#EndNum").val(EndNum);
				}else{
					$("#Amount").val(Num);
				}
			}
			if ((EndNum=="")&&(Amount!="")){
				EndNum=FormatCardNo(parseInt(StartNum)+parseInt(Amount)-1);
			    $("#EndNum").val(EndNum);
			}
		}
	}
	if (e.target.id=="Amount"){
		if (Amount==""){
			if ((EndNum!="")&&(StartNum!="")){
				var Num=parseInt(EndNum)-parseInt(StartNum)+1;
				if (Num<0){
					$("#EndNum").val("");
				}else{
					$("#Amount").val(Num);
				}
			}
		}else{
			if (StartNum!=""){
				EndNum=FormatCardNo(parseInt(StartNum)+parseInt(Amount)-1);
			    $("#EndNum").val(EndNum);
			}
			if ((StartNum=="")&&(EndNum!="")){
				StartNum=FormatCardNo(parseInt(EndNum)-parseInt(Amount)+1);
		        $("#StartNum").val(StartNum);
			}
		}
	}
	if (e.target.id=="EndNum"){
		if (EndNum==""){
			if ((StartNum!="")&&(Amount!="")){
				EndNum=FormatCardNo(parseInt(StartNum)+parseInt(Amount)-1);
				$("#EndNum").val(EndNum);
            }
		}else{
			if (Amount==""){
				var Num=parseInt(EndNum)-parseInt(StartNum)+1;
				if (Num<0){
					$("#StartNum").val("");
				}else{
					$("#Amount").val(Num);
				}
			}
			if (Amount!=""){
				var StartNum=parseInt(EndNum)-parseInt(Amount)+1;
				if (StartNum>0){
					StartNum=FormatCardNo(parseInt(EndNum)-parseInt(Amount)+1);
			        $("#StartNum").val(StartNum);
		        }else{
			        $("#StartNum").val('');
			    }
			}
		}
	}
	
	return true;

}
function ClearWinValue(){
	$("#StartNum").val("")
	$("#Amount").val("")
	$("#EndNum").val("")
	$("#Buyer").val("")
	$("#BuyerId").val("")
	$("#Note").val("")
}
function FormatCardNo(CardNo){
	CardNo=CardNo.toString();
	if (CardNo!='') {
		if ((CardNo.length<ServerObj.CardNoLength)&&(ServerObj.CardNoLength!=0)) {
			for (var i=(ServerObj.CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
