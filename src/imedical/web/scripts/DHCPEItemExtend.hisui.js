
//名称	DHCPEItemExtend.hisui.js
//功能	体检医嘱扩展
//创建	2019.05.23
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitItemExtendDataGrid();
      
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
    
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });  
    
       
    //新增(价格维护弹窗)
	$("#IEBAdd").click(function() {	
		IEBAdd_click();		
        });
    
        
    //修改(价格维护弹窗)
	$("#IEBUpdate").click(function() {	
		IEBUpdate_click();		
        }); 
   
   //清屏(价格维护弹窗)
	$("#IEBClear").click(function() {	
		IEBClear_click();		
        }); 
   
})

//新增
function BAdd_click()
{
	var ID=$("#ItemDesc").combogrid('getValue');
	if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ID="";}
    
	if (ID=="")
	{
		$.messager.alert("提示","医嘱名称不能为空","info");
		return false;
	}
	if (ID.indexOf("||")<0){
			$.messager.alert("提示","请选择医嘱名称","info");
			return false
		}

	var Flag=tkMakeServerCall("web.DHCPE.ItemExtend","InsertIE",ID);
	
	if (Flag!=0)
	{
		$.messager.alert("提示",Flag,"error");
		return false;
	}
	else
	{
		$.messager.alert("提示","新增成功","success");
		$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ItemExtend",
			QueryName:"SerchItemExtendNew",
			ArcItemID:"",
			});
	}
	
}

//清屏
function BClear_click()
{
	$("#ItemDesc").combogrid('setValue',"");
}

//查询
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
	  
		 //医嘱名称
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
			{field:'Name',title:'医嘱名称',width:200},
			{field:'Code',title:'医嘱编码',width:150},
			
				
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
			{field:'TARCDesc',width:350,title:'医嘱名称'},
			{field:'TCreateUser',width:250,title:'创建人'},
			{field:'TCreateDate',width:300,title:'创建时间'},
			{field:'TPrice',title:'价格维护',width:80,align:'center',
			
			formatter:function(value,rowData,rowIndex){
				if(rowData.TRowID!=""){
					
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/price_maint.png"  title="价格维护" border="0" onclick="openIEPriceWin('+rowData.TRowID+',1)"></a>';
			
				}
				}},
			{field:'TSendItem',title:'赠送维护',width:80,align:'center',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TRowID!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/ga_maint.png"  title="赠送维护" border="0" onclick="openIEPriceWin('+rowData.TRowID+',2)"></a>';
				}
				}},
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.TRowID);
					
					
		}
		
			
	})
	


}

 //修改(价格维护弹窗)
 function IEBUpdate_click()
 {
	 IESave_click("1");
 }
 
//新增(价格维护弹窗)
function IEBAdd_click()
{
	IESave_click("0");
} 

//新增(价格维护弹窗)
function IESave_click(Type)
{
	 ParRef=$("#ParRef").val();
	var ID=$("#IEPID").val();
	if((Type=="1")&&(ID==""))
	{
		$.messager.alert("提示","请选择待修改的记录","info");
		return false;
		
	}
	if((Type=="0")&&(ID!=""))
	{
		$.messager.alert("提示","新增不能选择记录,请先清屏后新增","info");
		return false;
	}
	var Price=$("#Price").numberbox('getValue');
	if (Price=="")
	{
		if($("#IEType").val()=="1"){$.messager.alert("提示","价格不能为空","info");}
		if($("#IEType").val()=="2"){$.messager.alert("提示","最低消费不能为空","info");}
		var valbox = $HUI.validatebox("#Price", {
			required: true,
	  	});
		return false;
	}
		
	
	
	var StartDate=$.trim($("#StartDate").datebox('getValue'));
	if (StartDate=="")
	{
		$.messager.alert("提示","开始日期不能为空","info");
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
			$.messager.alert("提示","开始日期应小于截止日期","info");
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
					$.messager.alert("提示","开始日期应大于上次记录的截止日期","info");
					return false;
				}
			}else{
				$.messager.alert("提示","上次记录没维护截止日期,不能再新增","info");
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
		$.messager.alert("提示",Flag,"error");
		return false;
	}
	else
	{
		if(Type=="0"){ $.messager.alert("提示","新增成功","success");}
		if(Type=="1"){ $.messager.alert("提示","修改成功","success");}
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




//价格维护
var openIEPriceWin = function(ID,IEType){
	if(IEType=="1"){
	$("#IEType").val(IEType);
	$("#IEPID").val("");
	$("#Price").numberbox('setValue',"")
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#StartDate").datebox("enable");
	$("#Price").attr('disabled',false);

	document.getElementById('tPrice').innerHTML="价格";	
	
	FillARCInfo(ID);
	//alert(ItemID)
	$HUI.window("#IEPriceWin",{
		title:"价格维护",
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
			{field:'TBeginDate',width:'150',title:'开始日期'},
			{field:'TEndDate',width:'150',title:'截止日期'},
			{field:'TPrice',width:'150',title:'价格',align:'right',type:'numberbox',options:{min:0,precision:2}},
			{field:'TCreateUser',width:'150',title:'创建人'},
			{field:'TCreateDate',width:'150',title:'创建时间'},	
			
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

    document.getElementById('tPrice').innerHTML="最低消费";	
	FillARCInfo(ID);
	
	$HUI.window("#IEPriceWin",{
		title:"赠送维护",
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
			{field:'TBeginDate',width:'150',title:'开始日期'},
			{field:'TEndDate',width:'150',title:'截止日期'},
			{field:'TCostFeeMin',width:'150',title:'最低消费',align:'right',type:'numberbox',options:{min:0,precision:2}},
			{field:'TCreateUser',width:'150',title:'创建人'},
			{field:'TCreateDate',width:'150',title:'创建时间'},	
			
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
//价格维护
function Price_Click(ItemID)
{
	var url="dhcpeieprice.hisui.csp"+"?ItemID="+ItemID;
	
	websys_lu(url,false,'width=1000,height=600,hisui=true,title=价格维护')
}
	

//赠送维护	
function SendItem_Click()
{
	var url="dhcpeieprice.hisui.csp?ItemID="+ItemID;
	websys_lu(url,false,'width=560,height=300,hisui=true,title=赠送维护')
}



*/

//验证是否为浮点数
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
