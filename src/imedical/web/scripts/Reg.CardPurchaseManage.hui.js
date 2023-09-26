var PageLogicObj={
	m_CPMRowid:""
}
$(function(){
	//初始化
	Init()
	//事件初始化
	InitEvent()
	//硬件参数初始化
	CardPurchaseManageListLoad()
})
function Init(){
	InitCardPurchManageGrid()	
	InitUserLookup()
	InitSearchUserLookup()
}
function InitEvent(){
	$("#Save").click(SaveClick);
	$("#BFind").click(CardPurchaseManageListLoad);
	$("#Del").click(DeleteData);
	$("#StartNum,#EndNum,#Amount").blur(CardManageMouseOver);
}
function InitCardPurchManageGrid(){
	var Columns=[[ 
		{ field : 'RowID',title : '',width : 1,hidden:true},
		{ field: 'StartNum', title: '起始卡号', width: 120, sortable: true, resizable: true},
		{ field : 'Amount',title : '卡号数量',width : 80 , sortable: true, resizable: true},
        { field : 'EndNum',title : '结束卡号',width : 120 , sortable: true, resizable: true},
        { field : 'Date',title : '购入日期',width : 100 , sortable: true, resizable: true},
        { field : 'UserName',title : '购入人',width : 70 , sortable: true, resizable: true},
        { field : 'LocDesc',title : '购入科室',width : 100 , sortable: true, resizable: true},
        { field : 'Active',title : '是否有效',width : 70 , sortable: true, resizable: true},
        { field : 'UpdateUser',title : '更新人',width : 100 , sortable: true, resizable: true},
        { field : 'UpdateDate',title : '更新日期',width : 100 , sortable: true, resizable: true},
        { field : 'CPMNote',title : '备注',width : 200 , sortable: true, resizable: true},
        { field : 'HOSPName',title : '购入院区',width : 70 , sortable: true, resizable: true}
	]]
	var dataGrid=$("#CardPurchaseManageList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'EpisodeID',
		columns :Columns,
		onSelect:function(index,rowData){
			PageLogicObj.m_CPMRowid=rowData["RowID"]
		},toolbar: [
			{
				iconCls: 'icon-add ',
				text:'新增',
				handler: function(){
					ClearWinValue()
					PageLogicObj.m_CPMRowid=""
					$("#PurchaseManageWin").dialog("open")
					$("#PurchaseManageWin").dialog("center")
				}
			},{
				iconCls: 'icon-cancel',
				text:'删除',
				handler: function(){
					if(PageLogicObj.m_CPMRowid==""){
						$.messager.alert("提示", "请选择卡购入记录!", 'info');
						return 
					}
					DeleteData(PageLogicObj.m_CPMRowid)	
				}
			}]
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
///StartDate As %String, EndDate As %String, User
function CardPurchaseManageListLoad(){
	if($("#SearchBuyer").val()==""){
		$("#SearchBuyerId").val("")
	}
	$.cm({
	    ClassName : "web.DHCCardPurchaseManage",
	    QueryName : "CardPurchaseInfo",
		StartDate:$("#StartDate").datebox("getValue"),
		EndDate:$("#EndDate").datebox("getValue"),
		User:$("#SearchBuyerId").val(),
	    rows:99999
	},function(GridData){
		$("#CardPurchaseManageList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
                {field:'SSUSR_Name',title:'用户名',width:150}, 
				{field:'SSUSR_Initials',title:'工号',width:200},					
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
                {field:'SSUSR_Name',title:'用户名',width:150}, 
				{field:'SSUSR_Initials',title:'工号',width:200},					
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
///增加购入记录
function SaveClick(){
	var StartNum=$("#StartNum").val();
	var Amount=$("#Amount").val();
	var EndNum=$("#EndNum").val();
	var Buyer=$('#BuyerId').val();
	if (StartNum==""){
		$.messager.alert('提示',"起始号码不能为空");
		return false;
	}
	if (Amount==""){
		$.messager.alert('提示',"卡片数量不能为空");
		return false;
	}
	if (EndNum==""){
		$.messager.alert('提示',"结束号码不能为空");
		return false;
	}
	if (Buyer==""){
		$.messager.alert('提示',"购入人不能为空");
		return false;
	}
	if (EndNum<StartNum){
		$.messager.alert('提示',"结束号码不能小于开始号码");
		return false;
	}
	var LogonDept=session['LOGON.CTLOCID'];
	var Note=$("#Note").val();
	if (Note.length>100){
		$.messager.alert('提示',"备注信息过长");
		return false;
	}
	var HOSPID=session['LOGON.HOSPID'];
	var CardPurchaseInfo=StartNum+"^"+Amount+"^"+EndNum+"^"+Buyer+"^"+LogonDept+"^"+Note+"^"+HOSPID;
	$.cm({
		ClassName:"web.DHCCardPurchaseManage",
		MethodName:"SaveCardPurchaseInfo",
		PurchaseInfo:CardPurchaseInfo
	},function(value){
		if(value.result=="0"){
				CardPurchaseManageListLoad();
				$("#PurchaseManageWin").dialog("close")
		}else{
				$.messager.alert('提示',"添加失败:"+value.result);
		}
	});
	
}
//删除购入记录
function DeleteData(rowid){
	$.messager.confirm("删除", "确定删除该卡购入记录?", function (r) {
		if(r){
			$.cm({
				ClassName:"web.DHCCardPurchaseManage",
				MethodName:"delete",
				IDS:rowid,
				User:session["LOGON.USERID"]
			},function(value){
				if(value.result=="0"){
					CardPurchaseManageListLoad();
				}else{
					$.messager.alert('提示',"删除失败:"+value.result);
				}
			});
		}else{
			return
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
