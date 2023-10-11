
/*
 * FileName: dhcpe/ct/itemextend.js
 * Author: xy
 * Date: 2021-08-16
 * Description: 体检医嘱扩展
 */
var tableName = "DHC_PE_ItemExtend";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	   		
	InitCombobox();
	
	//科室下拉列表change
	$("#LocList").combobox({
 	 	onSelect:function(){
	 	 	
	  		BFind_click();
	  		
	  		var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
		    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		     /********************项目重新加载****************************/
		    $("#ItemDesc").combogrid('setValue',"");
	  		$HUI.combogrid("#ItemDesc",{
				onBeforeLoad:function(param){
					param.ARCIMDesc= param.q;
					param.Type="B";
					param.LocID=LocID;
					param.hospId =hospId;
					param.tableName="DHC_PE_StationOrder" 

				}
		    });
		    
	       $('#ItemDesc').combogrid('grid').datagrid('reload'); 
	       /********************项目重新加载****************************/
	  			 
  		}
	})
	
	//初始化 医嘱扩展Grid
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
		
   //单独授权
	$("#BPower").click(function(){
    	BPower_click();
	})
    
	//授权科室
	$("#BRelateLoc").click(function(){
   		BRelateLoc_click();
 	})
	
})

//单独授权/取消授权
function BPower_click(){
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要单独授权的记录","info"); 
		return false;
	}
	var selected = $('#ItemExtendQueryTab').datagrid('getSelected');
	if(selected){
	
		//单独授权 
		var iEmpower="N";
	    if(selected.TEmpower=="Y"){var iEmpower="N";}
	    else{var iEmpower="Y";}
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("提示","授权失败","error");
		}else{
			$.messager.popover({msg:'授权成功',type:'success',timeout: 1000});
			 $("#ItemExtendQueryTab").datagrid('reload');
		}		
	}	
}
    

//授权科室
function BRelateLoc_click()
{
	var DateID=$("#ID").val();
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitItemExtendDataGrid)
   
   $("#ItemExtendQueryTab").datagrid('reload');
   
}


//新增
function BAdd_click()
{
	var OrderID=$("#ItemDesc").combogrid('getValue');
	if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var OrderID="";}
	if (OrderID=="")
	{
		$.messager.alert("提示","医嘱名称不能为空","info");
		return false;
	}
	if (OrderID.indexOf("||")<0){
			$.messager.alert("提示","请选择医嘱名称","info");
			return false
		}
	

	//单独授权 
	var iEmpower="N";
	var Empower=$("#Empower").checkbox('getValue');
	if(Empower) iEmpower="Y";
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];

	
	var rtn=tkMakeServerCall("web.DHCPE.CT.ItemExtend","InsertIE",OrderID,tableName,LocID,UserID,iEmpower);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){
		$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
	}else{
		$.messager.popover({msg:'新增成功',type:'success',timeout: 1000});
		$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"FindItemExtend",
			OrderID:OrderID,
			LocID:$("#LocList").combobox('getValue'), 
			tableName:tableName
		});


	}
	
}

//清屏
function BClear_click()
{
	var LocID=session['LOGON.CTLOCID']
	$("#LocList").combobox('setValue',LocID)

	$("#ItemDesc").combogrid('setValue',"");
	$("#Empower").checkbox('setValue',false);
	$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"FindItemExtend",
			OrderID:"",
			LocID:$("#LocList").combobox('getValue'), 
			tableName:tableName
		});
}

//查询
function BFind_click()
{
	var OrderID=$("#ItemDesc").combogrid('getValue');
	$("#ItemExtendQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"FindItemExtend",
			OrderID:OrderID,
			LocID:$("#LocList").combobox('getValue'), 
			tableName:tableName
		});
}
 


function InitCombobox()
{
	 
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	  
	//医嘱名称
	var ArcItemObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'TOrderID',
		textField:'TARCIMDesc',
		onBeforeLoad:function(param){
	  			
				param.ARCIMDesc= param.q;
				param.Type="B";
				param.LocID=LocID;
				param.hospId =hospId;
				param.tableName="DHC_PE_StationOrder"

		},
		columns:[[
		    {field:'TOrderID',title:'OrderID',hidden: true},
		    {field:'TARCIMDR',title:'ID',width:100},
			{field:'TARCIMDesc',title:'医嘱名称',width:200},
			{field:'TARCIMCode',title:'医嘱编码',width:150},
			
				
		]]
	});
}

function InitItemExtendDataGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	  			
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
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"FindItemExtend",
			OrderID:"",
			LocID:LocID, 
			tableName:tableName
		},
		columns:[[
	 
		    {field:'TID',title:'ID',hidden: true},
		    {field:'TOrderID',title:'OrderID',hidden: true},
		    {field:'TARCIMID',title:'ARCIMID',hidden: true},
			{field:'TARCIMDesc',width:350,title:'医嘱名称'},
			{field:'TUser',width:120,title:'创建人'},
			{field:'TUpdateDate',width:120,title:'创建日期'},
			{field:'TUpdateTime',width:120,title:'创建时间'},
			{field:'TEmpower',width:90,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
			{field:'TPrice',title:'价格维护',width:80,align:'center',
			
				formatter:function(value,rowData,rowIndex){
					if(rowData.TID!=""){
					
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/price_maint.png"  title="价格维护" border="0" onclick="openIEPriceWin('+rowData.TID+',1)"></a>';
			
					}
			}},
			{field:'TSendItem',title:'赠送维护',width:80,align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.TID!=""){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/ga_maint.png"  title="赠送维护" border="0" onclick="openIEPriceWin('+rowData.TID+',2)"></a>';
					}
			}},
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
			$("#ID").val(rowData.TID);
			if(rowData.TEmpower=="Y"){	
				$("#BRelateLoc").linkbutton('enable');
				$("#BPower").linkbutton({text:'取消授权'});
			}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#BPower").linkbutton({text:'单独授权'})
				
			}	
						
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
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];

	var ParRef=$("#ParRef").val();
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
		var OldtEndDateStr=tkMakeServerCall("web.DHCPE.CT.ItemExtend","GetNewPriceEndDate",ParRef,$("#IEType").val(),LocID);
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
		Strings=ParRef+"^"+Price+"^"+StartDate+"^"+EndDate+"^"+SetsFlag+"^"+LocID+"^"+UserID;
		var Flag=tkMakeServerCall("web.DHCPE.CT.ItemExtend","SaveIEPrice",ID,Strings);
	}
	if($("#IEType").val()=="2"){
		Strings=ParRef+"^"+Price+"^"+""+"^"+StartDate+"^"+EndDate+"^"+LocID+"^"+UserID;
		var Flag=tkMakeServerCall("web.DHCPE.CT.ItemExtend","SaveIESendItem",ID,Strings);

	}
	var FlagOne=Flag.split("^")
	if (FlagOne[0]=="-1")
	{
		$.messager.alert("提示",FlagOne[1],"error");
		return false;
	}
	else
	{
		if(Type=="0"){ $.messager.popover({msg:'新增成功',type:'success',timeout: 1000});}
		if(Type=="1"){ $.messager.popover({msg:'修改成功',type:'success',timeout: 1000});}
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
				ClassName:"web.DHCPE.CT.ItemExtend",
				QueryName:"SerchIEPrice",
				ParRef:$("#ParRef").val(),
				LocID:$("#LocList").combobox('getValue'),
				});
	 }
	 if($("#IEType").val()=="2"){
		$("#IEPriceQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.CT.ItemExtend",
			    QueryName:"SerchIESendItem",
				ParRef:$("#ParRef").val(),
				LocID:$("#LocList").combobox('getValue'),
				});
	 }
}
function FillARCInfo(ID)
{
	if(ID==""){
		return false;
	}
	var hospId=session['LOGON.HOSPID']
	$("#ParRef").val(ID);
	var Info=tkMakeServerCall("web.DHCPE.CT.ItemExtend","GetARCDesc",ID,hospId);
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

	document.getElementById('tPrice').innerHTML="<font color=red>*</font>价格";
	
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
	
	var IEPriceObj = $HUI.datagrid("#IEPriceQueryTab",{
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
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"SerchIEPrice",
			ParRef:ID,
			LocID:$("#LocList").combobox('getValue')
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

    document.getElementById('tPrice').innerHTML="<font color=red>*</font>最低消费"; 
	FillARCInfo(ID);
	
	$HUI.window("#IEPriceWin",{
		title:"赠送维护",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:1000,
		height:390
	});
	
	var IEPriceObj = $HUI.datagrid("#IEPriceQueryTab",{
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
			ClassName:"web.DHCPE.CT.ItemExtend",
			QueryName:"SerchIESendItem",
			ParRef:ID,
			LocID:$("#LocList").combobox('getValue')
			
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
