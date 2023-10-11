//名称	DHCPEOrdDetailRelateCom.hisui.js
//功能	大项和细项组合关系对照
//创建	2019.06.03
//创建人  xy
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderTabDataGrid();
	
	InitODRelateComDataGrid();

	//查询
	$("#BFind").click(function(e){
    	BFind_click();
    });
	
	$("#ARCIMDesc").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
				}
		});

	
	//清屏
    $("#BClear").click(function(e){
    	BClear_click();
    });
	     
    //新增
    $("#BAdd").click(function(e){
    	BAdd_click();
    });
    
    //修改
    $("#BUpdate").click(function(){
    	BUpdate_click();
    });
    
    //删除
    $("#BDelete").click(function(e){
    	BDelete_click();
    }); 
    
    //导入LIS项目
     $("#BImport").click(function(e){
    	BImport_click();
    }); 
    
     $("#Cascade").change(function(){
  			Cascade_change();
		});
		
    iniForm();
   
})

 function BFind_click()
{
	
	$("#OrderTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ARCIMDesc").val(),
			hospId:session['LOGON.HOSPID']
		}); 

}  

function iniForm(){
	$("#BImport").css('display','none');
	 // 导入按钮显示
	var STType=tkMakeServerCall("web.DHCPE.Public.Setting","GetStationType",$("#ParRef").val());
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","GetLisInterface");
	if ("Lab"==STType&&"N"==flag) { $("#BImport").css('display','block');}
}

function InitCombobox()
{
	//细项名称
	var ODObj = $HUI.combogrid("#ODDRName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.OrderDetail&QueryName=FromDescOrderDetail",
		mode:'remote',
		delay:200,
		idField:'OD_RowId',
		textField:'OD_Desc',
		onBeforeLoad:function(param){
			param.ParRef = "";
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#ODDRName').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_Desc',title:'名称',width:150},
		    {field:'OD_Code',title:'编码',width:100},	    	
					
		]],
		onLoadSuccess:function(){
			//$("#ODDRName").combogrid('setValue',"")
			
		},

		});
		
	//父项
	var OrdObj = $HUI.combogrid("#Parent_DR_Name",{
		panelWidth:249,
		url:$URL+"?ClassName=web.DHCPE.OrderDetailRelate&QueryName=SearchParentOrderDetailRelate",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = $("#ARCIMDR").val();
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#Parent_DR_Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'ID',title:'ID',width:80},
		    {field:'Desc',title:'名称',width:140}, 
		
					
		]]
		});
	
}

/**********************站点界面************************************/
function InitStationDataGrid()
{
	
	$HUI.datagrid("#StationTab",{
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
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:'60',title:'站点编码'},
			{field:'ST_Desc',width:'170',title:'站点名称'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderTabTablist(rowData);
			$("#ARCIMDR,#ARCIMDesc").val("");
			BClear_click();
			iniForm();
					
		}
		
			
	})

}


/**********************项目界面************************************/
function LoadOrderTabTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	
	$("#OrderTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		
	});
	
	
}
function InitOrderTabDataGrid()
{
	
	$HUI.datagrid("#OrderTab",{
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
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		},
		columns:[[

		    {field:'ODR_ARCIM_DR:',title:'ID',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',width:'200',title:'项目名称'},
			{field:'ODR_ARCIM_Code',width:'70',title:'项目编码'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ODRelateComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadODRelateComDatalist(rowData);
					
		}
		
			
	})
}

/**********************项目组合维护界面************************************/
function LoadODRelateComDatalist(rowData)
{
	
	$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
	$("#ARCIMDesc").val(rowData.ODR_ARCIM_DR_Name);
	
	//BClear_click();
	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParARCIMDR:$("#ARCIMDR").val(),
		
	});
	
	
}


function InitODRelateComDataGrid()
{
	$HUI.datagrid("#ODRelateComGrid",{
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
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParRef:"",
			ParARCIMDR:"",
		},
		frozenColumns:[[
			{field:'ODR_OD_DR_Name',width:'150',title:'细项名称'},
		    {field:'ODR_OD_DR_Code',width:'100',title:'细项编码'},
			 
		]],
		columns:[[
		    {field:'ODR_RowId',title:'ODRRowId',hidden: true},
		    {field:'ODR_ARCIM_DR',title:'ARCIMDR',hidden: true},
		    {field:'ODR_OD_DR',title:'ODRowId',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',title:'ARCIMDesc',hidden: true},
			{field:'ODR_Sequence',width:'80',title:'顺序号'},
			{field:'ODR_Required',width:'120',title:'是否必填项'},
			{field:'THistoryFlag',width:'120',title:'报告中比对'},
			{field:'ODR_Cascade',width:'80',title:'层次'},
			{field:'ODR_Parent_DR_Name',width:'100',title:'父项'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#ODRRowId").val(rowData.ODR_RowId);
			$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
			$("#ODRowId").val(rowData.ODR_OD_DR);
			$("#ODDRName").combogrid('setValue',rowData.ODR_OD_DR_Name);
			$("#Sequence").val(rowData.ODR_Sequence);
			$("#Cascade").val(rowData.ODR_Cascade);
			$("#Parent_DR_Name").combogrid('setValue',rowData.ODR_Parent_DR_Name);
			
			if(rowData.THistoryFlag=="否"){
					$("#HistoryFlag").checkbox('setValue',false);
				}if(rowData.THistoryFlag=="是"){
					$("#HistoryFlag").checkbox('setValue',true);
				};
			if(rowData.ODR_Required=="否"){
					$("#Required").checkbox('setValue',false);
				}if(rowData.ODR_Required=="是"){
					$("#Required").checkbox('setValue',true);
				};

			if(rowData.ODR_Cascade=="1"){
			$("#Parent_DR_Name").combogrid("disable");
			}else{
			$("#Parent_DR_Name").combogrid("enable");
			}
		
		}
		
			
	})
}

// 输入层次时?判断是否是顶层,是则将父项变为不可用
function Cascade_change () {
	var Src=window.event.srcElement;
	
	var iCascade=$("#Cascade").val();
	if(iCascade=="1"){
		$("#Parent_DR_Name").combogrid("disable");
	}else{
		$("#Parent_DR_Name").combogrid("enable");
	}
	
}


//清屏
function BClear_click(){
	$("#ODRRowId,#ODRowId,#Sequence,#Cascade").val("");
	$("#ODDRName").combogrid('setValue',"");
	$("#Parent_DR_Name").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	
	var valbox = $HUI.combogrid("#ODDRName", {
			required: false,
	    });
	var valbox = $HUI.validatebox("#Sequence", {
			required: false,
	    });

	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParARCIMDR:$("#ARCIMDR").val(),
		
	});
}

//新增
function BAdd_click(){
	BSave_click("0");
} 

//修改
function BUpdate_click(){
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ODRRowId").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ARCIMDR").val()==""){
		    	$.messager.alert("提示","请先选择项目","info");
		    	return false;
		    }
	    if($("#ODRRowId").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	
	 var iRowId=$("#ODRRowId").val(); 
	 
	var iARCIMDR=$("#ARCIMDR").val();  

   //细项名称
	var iODDR=$("#ODDRName").combogrid('getValue');
	if (($("#ODDRName").combogrid('getValue')==undefined)||($("#ODDRName").combogrid('getValue')=="")){var iODDR="";}
	if (""==iODDR) {
		$("#ODDRName").focus();
		var valbox = $HUI.combogrid("#ODDRName", {
			required: true,
	    });
		$.messager.alert("提示","请选择细项名称,细项名称不能为空","info");
		return false;
	}
	
	 if(iRowId!=""){var iODDR=$("#ODRowId").val();}
	 if(iODDR!="")
	 {
		 var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","IsOrderDetailFlag",iODDR);
		 if(flag=="0"){
			 $.messager.alert("提示","请下拉选择细项","info");
			return false;
		 }
	 }

	
	
	//顺序号
	var iSequence=$("#Sequence").val(); 
	if (""==iSequence) {
		$("#Sequence").focus();
		var valbox = $HUI.validatebox("#Sequence", {
			required: true,
	    });
		$.messager.alert("提示","顺序号不能为空","info");
		return false;
	}
	if((!(isInteger(iSequence)))||(iSequence<=0)) 
		   {
			   $.messager.alert("提示","顺序号只能是正整数","info");
			    return false; 
		   }


	//是否必填项
	var iRequired="N";
	var Required=$("#Required").checkbox('getValue');
	if(Required) iRequired="Y";
		
	// 父项
	var iParentDR=$("#Parent_DR_Name").combogrid('getValue');
	if (($("#Parent_DR_Name").combogrid('getValue')==undefined)||($("#Parent_DR_Name").combogrid('getValue')=="")){var iParentDR="";}
	 
	// 层次
	var iCascade=$("#Cascade").val();
	if ("1"==iCascade) { iParentDR=""; }

	if((iCascade!="1")&&(iCascade!="")&&(iParentDR=="")){
		$.messager.alert("提示","请选择父项","info");
		return false;
		
	}
	// 报告中比对
	var iHistory="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) iHistory="Y";
	
	var Instring=$.trim(iRowId)			
				+"^"+$.trim(iARCIMDR)		
				+"^"+$.trim(iODDR)		
				+"^"+$.trim(iSequence)	
				+"^"+$.trim(iRequired)	
				+"^"+$.trim(iParentDR)	
				+"^"+$.trim(iCascade)		
				+"^"+$.trim(iHistory)		
				;
	
	var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","Save",'','',Instring);
	//alert(flag)
	if (flag=='-104') {
		$.messager.alert("操作提示","所引用的父表记录不存在","info");
	}else{
		if (flag=='0') {
			
			if(Type=="1"){$.messager.alert("操作提示","修改成功","success");}
			if(Type=="0"){$.messager.alert("操作提示","新增成功","success");}
			BClear_click();	
				
		}else if (flag=='Err 01') {
			$.messager.alert("操作提示","此项目已增加","info");
			
		}else{
			if(Type=="1"){$.messager.alert("操作提示","修改失败","error");}
			if(Type=="0"){$.messager.alert("操作提示","新增失败","error");}	
		
		}
	} 
}
//删除
function BDelete_click(){
	var ID=$("#ODRRowId").val();
	if(ID==""){
			$.messager.alert("提示","请选择待删除的记录","info");
			return false;
		}
			
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OrderDetailRelate", MethodName:"Delete", itmjs:'',itmjsex:'',Rowid:ID },function(ReturnValue){
				if (ReturnValue!='0') {
					if(ReturnValue=="Err 07"){$.messager.alert("提示","删除失败:该细项已和大项关联","error")}
					else{$.messager.alert("提示","删除失败","error"); } 
  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click();
					
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}


//导入
function BImport_click()
{

	var ARCIMDr=$("#ARCIMDR").val(); 
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","Main",ARCIMDr);
	BClear_click();
	
}

 function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
}

