﻿var CardPurchaseDataGrid;
var SelUserRowid=""
var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
var editRow;
$(function(){
	InitCombo();
	InitTable();
	$("#Find").click(LoadCardPurchaseManage);
	$("#BClear").click(ClearClickHandle);
	$("#StartNum,#EndNum,#Amount").blur(CardManageMouseOver);
})
function DelHanldClick(){
	var rows = CardPurchaseDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        $.messager.confirm("提示", "你确定要置为无效吗?",
        function(r) {
            if (r) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].RowID);
                }
                var DPRowid=ids.join(',');
                var value=$.cm({ 
					ClassName:"web.DHCCardPurchaseManage", 
					MethodName:"delete",
					IDS:DPRowid, User:session['LOGON.USERID'],
					dataType:'text'
				},false)
				if(JSON.parse(value).result=="0"){
					LoadCardPurchaseManage();
					CardPurchaseDataGrid.datagrid('unselectAll');
					$.messager.show({title:"提示",msg:"成功"});
				}else{
					$.messager.alert('提示',"失败:"+JSON.parse(value).result);
				}
				editRow = undefined;
            }
        });
    } else {
        $.messager.alert("提示", "请选择要置为无效的行", "error");
    }
}
function AddHanldClick(){
	var StartNum=$("#StartNum").val();
	var Amount=$("#Amount").val();
	var EndNum=$("#EndNum").val();
	var Buyer=$('#Buyer').lookup('getText');
	if (Buyer==""){
		$.messager.alert('提示',"请选择正确的购入人员");
		return false;
	}
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
	//CardManageMouseOver();
	var LogonDept=session['LOGON.CTLOCID'];
	var Note=$("#Note").val();
	if (Note.length>100){
		$.messager.alert('提示',"备注信息过长");
		return false;
	}
	var HOSPID=session['LOGON.HOSPID'];
	var CardPurchaseInfo=StartNum+"^"+Amount+"^"+EndNum+"^"+SelUserRowid+"^"+LogonDept+"^"+Note+"^"+HOSPID;
	var value=$.cm({ 
		ClassName:"web.DHCCardPurchaseManage", 
		MethodName:"SaveCardPurchaseInfo",
		PurchaseInfo:CardPurchaseInfo,
		dataType:'text'
	},false)
	if(JSON.parse(value).result=="0"){
		//LoadCardPurchaseManage();
		$.messager.show({title:"提示",msg:"添加成功"});
		ClearClickHandle();
	}else{
		$.messager.alert('提示',"添加失败:"+JSON.parse(value).result);
	}
}
function CardManageMouseOver(e){
	CalCardManage($("#StartNum").val(),$("#Amount").val(),$("#EndNum").val(),e);
}
function CalCardManage(StartNum,Amount,EndNum,e){
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
function InitCombo(){
	$("#Buyer").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'SSUSR_RowId',
        textField:'SSUSR_Name',
        columns:[[  
            {field:'SSUSR_Name',title:'操作员姓名',width:400,sortable:true},
			{field:'SSUSR_Initials',title:'操作员工号',width:400,sortable:true},
			{field:'SSUSR_RowId',title:'ID',width:120,sortable:true}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCUserGroup',QueryName: 'Finduse1'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    SelUserRowid=rec['SSUSR_RowId'];
			});
		}
    });
}
function InitTable(){
	var toolbar= [{
		iconCls: 'icon-add',
		text:"新增",
		handler: function(){AddHanldClick()}
	},{
		iconCls: 'icon-cancel',
		text:"置为无效",
		handler: function(){DelHanldClick()}
	}]
    var TableColumns=[[    
        { field : 'RowID',title : '',width : 1,hidden:true  },
		{ field: 'StartNum', title: '起始卡号', width: 120},
		{ field : 'Amount',title : '卡号数量',width : 90 },
        { field : 'EndNum',title : '结束卡号',width : 120 },
        { field : 'Date',title : '购入日期',width : 100 },
        { field : 'UserName',title : '购入人',width : 70 },
        { field : 'LocDesc',title : '购入科室',width : 100 },
        { field : 'Active',title : '是否有效',width : 70 },
        { field : 'UpdateUser',title : '更新人',width : 100 },
        { field : 'UpdateDate',title : '更新日期',width : 100 },
        { field : 'CPMNote',title : '备注',width : 200 },
        { field : 'HOSPName',title : '购入院区',width : 180 }	
	 ]];
	CardPurchaseDataGrid=$("#tabCardPurchaseManage").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		rownumbers:true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: [15],
		pageList:[15,100,200],
		idField:'RowID',
		columns :TableColumns,
		toolbar:toolbar,
		onDblClickRow:function(rowIndex, rowData){
			/*if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			CardPurchaseDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex*/
		}
	});
	LoadCardPurchaseManage();
}
function LoadCardPurchaseManage()
{
	if ($("#Buyer").lookup('getText')==""){
		SelUserRowid="";
	}
	$.q({
	    ClassName : "web.DHCCardPurchaseManage",
	    QueryName : "CardPurchaseInfo",
	    StartDate:$("#StartDate").datebox("getValue"), EndDate:$("#EndDate").datebox("getValue"), User:SelUserRowid,HospID:session['LOGON.HOSPID'],
	    Pagerows:CardPurchaseDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CardPurchaseDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function FormatCardNo(CardNo){
	CardNo=CardNo.toString();
	if (CardNo!='') {
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
		//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}
			
}
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
			
}
function ClearClickHandle(){
	$("#StartNum,#Amount,#EndNum,#Note").val('');
	$("#StartDate,#EndDate").datebox('setValue','');
	$("#Buyer").lookup('setText','');
	$("#Buyer").lookup('grid').datagrid('unselectAll');
	SelUserRowid="";
	LoadCardPurchaseManage();
}