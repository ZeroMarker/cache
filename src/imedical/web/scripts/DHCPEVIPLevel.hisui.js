
//名称	DHCPEVIPLevel.hisui.js
//功能	客户VIP等级维护
//创建	2019.05.07
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitVIPLevelDataGrid();
        
    //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
    
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
   
})


//修改
function BUpdate_click()
{
	BSave_click("1");
}

 //新增
function BAdd_click()
{
	BSave_click("0");
}

function BSave_click(Type)
{
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
			return false;
		}
		var ID="";
	}
	
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("提示","VIP等级不能为空","info");
		return false;
	}
	var SetCode=""
	/*
	var SetCode=$("#SetCode").val();
	if (""==SetCode) {
		$("#SetCode").focus();
		var valbox = $HUI.validatebox("#SetCode", {
			required: true,
	    });
		$.messager.alert("提示","套餐编码不能为空","info");
		return false;
	}
	*/
	var HPCode=$("#HPCode").val();
	if (""==HPCode) {
		$("#HPCode").focus();
		var valbox = $HUI.validatebox("#HPCode", {
			required: true,
	    });
		$.messager.alert("提示","体检号编码不能为空","info");
		return false;
	}
	

    var HMService=$("#HMService").combobox('getValue');
    if (($("#HMService").combobox('getValue')==undefined)||($("#HMService").combobox('getValue')=="")){var HMService="";}
   
   	
    var OrdSetsDR=$("#OrdSetsDesc").combogrid('getValue');
    if (($("#OrdSetsDesc").combogrid('getValue')==undefined)||($("#OrdSetsDesc").combogrid('getValue')=="")){var OrdSetsDR="";}
    var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OrdSetsDR)))&&(OrdSetsDR!="")){var OrdSetsDR=$("#OrdSetsDR").val();}
	
    var FeeType=$("#PatFeeType").combogrid('getValue');
    if (($("#PatFeeType").combogrid('getValue')==undefined)||($("#PatFeeType").combogrid('getValue')=="")){var FeeType="";}
	
	var Level=$("#Level").val();
	var ZYDInfo=$("#ZYDInfo").val();
	var ZYDTemplate=$("#ZYDTemplate").val();
	var Template=$("#Template").val();
	
	var iIsSecret="N";
	var IsSecret=$("#IsSecret").checkbox('getValue');
	if(IsSecret) iIsSecret="Y";
	
	var iIsUse="N";
	var IsUse=$("#IsUse").checkbox('getValue');
	if(IsUse) iIsUse="Y"
	
	var iIsApprove="N";
	var IsApprove=$("#IsApprove").checkbox('getValue');
	if(IsApprove) iIsApprove="Y"
	
    var GeneralType=$("#GeneralType").combogrid('getValue');
	
	var IfInsert=$("#IfInsert").combobox('getValue');
    if (($("#IfInsert").combobox('getValue')==undefined)||($("#IfInsert").combobox('getValue')=="")){var IfInsert="";}
   
	
	var Instring=trim(Level)		
		    +"^"+trim(Desc)
		    +"^"+iIsSecret
		    +"^"+iIsUse 		
            +"^"+iIsApprove				
            +"^"+ID
            +"^"+trim(Template)
			+"^"+trim(FeeType)
			+"^"+trim(SetCode)
			+"^"+trim(HPCode)
			+"^"+""
			+"^"+OrdSetsDR
			+"^"+trim(ZYDInfo)
			+"^"+trim(ZYDTemplate)
			+"^"+HMService
			+"^"+GeneralType
			+"^"+IfInsert
			;
		
	
	var CurIsApprove=$("#CurIsApprove").val();
	var ret=tkMakeServerCall("web.DHCPE.VIPLevel","GetVipApprove");
	//alert(CurIsApprove+"^"+iIsApprove+"^"+ret) 
	if((CurIsApprove=="否")&&(iIsApprove=="Y")&&(ret=="1"))
	{
	    $.messager.alert("提示","默认值已设置,不能重复设置","info");
	    return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPE.VIPLevel","Insert",'','',Instring);
	if (flag==0){
		
		BClear_click();
		
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
	}else{
		$.messager.alert("提示","更新失败","error");	
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//清屏
function BClear_click()
{
	$("#ID,#Desc,#HPCode,#Level,#ZYDInfo,#ZYDTemplate,#Template").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#OrdSetsDesc").combogrid('setValue',"");
	$("#PatFeeType").combobox('setValue',"");
	$("#HMService").combobox('setValue',"");
	var valbox = $HUI.validatebox("#HPCode,#HPCode", {
			required: false,
	});
	$("#VIPLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.VIPLevel",
			QueryName:"FindVIPLevel",
	});	
	
	$("#GeneralType").combobox('setValue',"JKTJ");
} 



function InitCombobox()
{
	  //体检类别
	  var VIPObj = $HUI.combobox("#PatFeeType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'70',
		});
	//体检类别
	  var VIPObj = $HUI.combobox("#IfInsert",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIfInsert&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'90',
		});
		
	 //问卷等级
	  var HMSObj = $HUI.combobox("#HMService",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindHMService&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'105',
		});
		
	//默认套餐
	var OrdSeObj = $HUI.combogrid("#OrdSetsDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode:'remote',
		delay:200,
		idField:'OrderSetId',
		textField:'OrderSetDesc',
		onBeforeLoad:function(param){
			param.Set = param.q;
			param.Type = "ItemSet";
		},
		columns:[[
		    {field:'OrderSetId',title:'ID',width:80},
		    {field:'OrderSetDesc',title:'名称',width:200},
			{field:'IsBreakable',title:'是否拆分',width:80},
			{field:'OrderSetPrice',title:'价格',width:100},	
					
		]]
		});
		
	// 总检类型
	$HUI.combobox("#GeneralType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'JKTJ', text:'健康体检', selected:'true'},
			{id:'RZTJ', text:'入职体检'},
			{id:'GWY', text:'公务员'},
			{id:'ZYJK', text:'职业健康'},
			{id:'JKZ', text:'健康证'},
			{id:'OTHER', text:'其他'}
		]
	});
}

function InitVIPLevelDataGrid()
{
	$HUI.datagrid("#VIPLevelQueryTab",{
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
			ClassName:"web.DHCPE.VIPLevel",
			QueryName:"FindVIPLevel",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TDesc',title:'VIP等级'},
			{field:'TSetCode',title:'套餐编码',hidden: true},
			{field:'THPCode',title:'体检号编码'},
			{field:'TLevel',title:'级别',align:'center'},
			{field:'TFeeTypeName',title:'体检类别'},
			{field:'TFeeTypeDR',title:'TFeeTypeDR',hidden: true},
			{field:'THMService',title:'问卷级别'},
			{field:'THMServiceDR',title:'THMServiceDR',hidden: true},
			{field:'TIsSecret',width:'40',title:'保密',align:'center'},
			{field:'TIsUse',width:'40',title:'使用',align:'center'},
			{field:'TIsApprove',width:'40',title:'默认',align:'center'},
			{field:'TOrdSetsDR',title:'TOrdSetsDR',hidden: true},
			{field:'TOrdSetsDesc',title:'默认套餐'},
			{field:'TZYDInfo',title:'指引单提示'},
			{field:'TZYDTemplate',title:'指引单模板'},
			{field:'TGeneralType',title:'总检类型',
				formatter: function(value,rowData,rowIndex) {
					if (value == "JKTJ") return "健康体检";
					else if (value == "RZTJ") return "入职体检";
					else if (value == "GWY") return "公务员";
					else if (value == "ZYJK") return "职业健康";
					else if (value == "JKZ") return "健康证";
					else if (value == "OTHER") return "其他";
					else return "健康体检";
				}
			},
			{field:'TTemplate',title:'模板名称'}
			,
			{field:'TIfInsert',title:'是否插队',
			formatter: function(value,rowData,rowIndex) {
					if (value == "1") return "是";
					else return "否";
				}
				}
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#SetCode").val(rowData.TSetCode);
				$("#HPCode").val(rowData.THPCode);
				$("#Level").val(rowData.TLevel);
				$("#ZYDInfo").val(rowData.TZYDInfo);
				$("#ZYDTemplate").val(rowData.TZYDTemplate);
				$("#Template").val(rowData.TTemplate);
				$("#OrdSetsDesc").combogrid('setValue',rowData.TOrdSetsDesc);
				$("#OrdSetsDR").val(rowData.TOrdSetsDR);
				$("#HMService").combobox('setValue',rowData.THMServiceDR);
				$("#PatFeeType").combobox('setValue',rowData.TFeeTypeDR);
				
				if(rowData.TIsSecret=="否"){
					$("#IsSecret").checkbox('setValue',false);
				}if(rowData.TIsSecret=="是"){
					$("#IsSecret").checkbox('setValue',true);
				};
				if(rowData.TIsUse=="否"){
					$("#IsUse").checkbox('setValue',false);
				}if(rowData.TIsUse=="是"){
					$("#IsUse").checkbox('setValue',true);
				};
				if(rowData.TIsApprove=="否"){
					$("#IsApprove").checkbox('setValue',false);
				}if(rowData.TIsApprove=="是"){
					$("#IsApprove").checkbox('setValue',true);
				};	
						
				$("#CurIsApprove").val(rowData.TIsApprove);
				//$("#IfInsert").combobox('setValue',rowData.TIfInsert);
				
				if (rowData.TGeneralType == "") $("#GeneralType").combobox('setValue','JKTJ');
				else $("#GeneralType").combobox('setValue',rowData.TGeneralType);
				
				if (rowData.TIfInsert == "1") $("#IfInsert").combobox('setValue',rowData.TIfInsert);
				else $("#IfInsert").combobox('setValue',0);
		}
	});
}