
//名称	DHCPEPreGADM.Home.hisui.js
//功能	主场团体
//创建	2020.12.29
//创建人  xy
$(function(){
	 
	InitPreGADMHomeDataGrid();
	
	//清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
   //删除
     $("#BDelete").click(function() {	
		BDelete_click();		
        });
     
      
     //更新
     $("#BUpdate").click(function() {	
		BUpdate_click();		
        });
       
})


function BUpdate_click(){
	if(PGADMDr==""){
		return false;
		}
	
	var DrId=PGADMDr+"^"+Type;
	var iRemark=$("#Remark").val();
	var RowId=$("#RowId").val();
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		$.messager.alert("提示","开始日期与结束日期为必填项！","info");
		return false;
	}
	var BeginDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",BeginDate);
	var EndDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate);
	if(Type=="C"){
		var value=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",PGADMDr);
		var SighDate=value.split("^")[3];
		 if(SighDate!=""){var SighDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",SighDate);}
		 if(BeginDateLogical<SighDate){
			$.messager.alert("提示","开始日期不能小于合同签订日期","info");
			return false;
		}
   }

    if(EndDateLogical<SighDate){
	   $.messager.alert("提示","结束日期不能小于合同签订日期","info");
	    return false;
   }
	var Num=$("#Num").val();
	if(Num.indexOf("-")<=-1){
		$.messager.alert("提示","每日人数格式应为“每日人数(男)-每日人数(女)”:例如“10-10”","info");
	    return false;
	    }

	if(Num.indexOf("-")>=0)
	   {
		   
		   var Data=Num.split("-");
			if((Data[0]=="")||(Data[1]=="")){
			    $.messager.alert("提示","每日人数-前后应为数字","info");
			    return false;
		   }
		   
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   $.messager.alert("提示","每日人数-前后应为数字","info");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		$.messager.alert("提示","人数不能为空！","info");
		return false;
	}
	
     
     //alert(DrId+"^"+RowId+"^"+BeginDate+"^"+EndDate+"^"+Num+"^"+iRemark)
	var rnt =tkMakeServerCall("web.DHCPE.PreHome","UpdateMethod",DrId,RowId,BeginDate,EndDate,Num,iRemark)
	if(rnt == "1"){	
		$.messager.alert("提示","与现有的主场日期有重叠，更新失败！","info");
	} else if(rnt == "2"){
		$.messager.alert("提示","服务器错误，更新失败！","info");
	} else if (rnt == "4"){
		$.messager.alert("提示","开始日期不能晚于结束日期，更新失败！","info");
	}else if (rnt == "5"){
		$.messager.alert("提示","结束日期不能大于团体的预约时间，更新失败！","info");
	}else if (rnt == "8"){
		$.messager.alert("提示","开始日期不能小于团体的预约时间，更新失败！","info");
	}else if (rnt == "6"){
		$.messager.alert("提示","主场男性数量小于团体男性成员数量，更新失败！","info");
	}else if (rnt == "7"){
		$.messager.alert("提示","主场女性数量小于团体女性成员数量，更新失败！","info");
	}else if (rnt == "3"){
		$.messager.alert("提示","更新成功","success");
		
		BClear_click();
		
		$("#PreGADMHomeGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PGADMDr,
			Type:"G"
		})
		
	} 
}

function BDelete_click(){
	var RowId=$("#RowId").val();
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("提示","请选择待删除的数据","info");
		return false;	
	}
	
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreHome", MethodName:"DeleteMethod",RowId:RowId},function(ReturnValue){
				if (ReturnValue=='1') {
					$.messager.alert("提示","数据不存在，删除失败","error");  
				}else if((ReturnValue=='2')){
					$.messager.alert("提示","服务器错误，删除失败","error"); 
				}else if((ReturnValue=='3')){
					$.messager.alert("提示","删除成功","success"); 
					 
					 $("#PreGADMHomeGrid").datagrid('load',{
						ClassName:"web.DHCPE.PreHome",
						QueryName:"SerchHomeInfo",
						PGADMDr:PGADMDr,
						Type:"G"
					})
					
					  BClear_click()
					
				}
			});	
		}
	});
	
}

function BClear_click()
{
	$("#RowId").val("");
	$("#BeginDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"");
	$("#Num,#Remark").val("");
}


//时段信息弹窗
function BTimeLink(rowIndex)
{
	 var rowobj=$('#PreGADMHomeGrid').datagrid('getRows')[rowIndex];
	 var HomeRowID=rowobj.THomeRowID;
	 var PreGADM=rowobj.TPADMDr;
	 
	$HUI.window("#PreTemplateTimeWin", {
        title: "预约时段",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: true,
        resizable: true,
        closable: true,
        modal: true,
        width: 600,
        height: 600,
        content: '<iframe src="dhcpepretemplatetime.hisui.csp?ParRef=' + HomeRowID + '&Type=H'+"&PreGADM="+PreGADM+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
	
}
function InitPreGADMHomeDataGrid()
{
	$HUI.datagrid("#PreGADMHomeGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PGADMDr,
			Type:"G"
				
		},
		columns:[[
			{field:'THomeRowID',title:'HomeRowID',hidden: true},
			{field:'TPADMDr',title:'PADMDr',hidden: true},
		    {field:'TMaleNum',width:'150',title:'每日人数(男)'},
			{field:'TFemaleNum',width:'150',title:'每日人数(女)'},
			{field:'TTimeLink',width:'180',title:'时段信息',align:'center',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.THomeRowID!=""){
			            return '<a><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="时段信息" border="0" onclick="BTimeLink('+rowIndex+'\)"></a>';
					}
					
			}},
			{field:'TDate',width:'150',title:'日期'},
			{field:'TRemark',width:'300',title:'备注'}			
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#RowId").val(rowData.THomeRowID);
			$("#BeginDate").datebox('setValue',rowData.TDate);
			$("#EndDate").datebox('setValue',rowData.TDate);
			$("#Num").val(rowData.TMaleNum+"-"+rowData.TFemaleNum);
			$("#Remark").val(rowData.TRemark)
	   	
					
		}
			
	})
}