
//名称	DHCPEOrderDetailCom.hisui.js
//功能	细项维护
//创建	2019.05.22
//创建人  xy
$(function(){
	
	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderDetailDataGrid();
	
	//查询
    $('#BFind').click(function(e){
    	BFind_click();
    });
	     
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //删除
    $('#del_btn').click(function(e){
    	DelData();
    });
   
	//类型
	$("#Type").combobox({
       onSelect:function(){
			Type_change();
	}
	});
    
})

function Type_change()
{
	
	var Type=$("#Type").combobox('getValue');
	if(Type=="C"){
		$("#EditExpression").attr('disabled',false);	
	}else{
		$("#EditExpression").attr('disabled',true);
	}
}

function IsValidExpression(aExpression) {
	
	var strExpression="";
	var strLine="";
	var iLoop=0;
	
	var iValue="",iOperator="",iCode="";	
	
	var ReadStatus=""; //读取类型   V 当前读取变量 O 当前读取到操作符 P 当前读取到括号
	
	strExpression=aExpression+';';
  
	for (iLoop=0;iLoop<strExpression.length;iLoop++) {
		switch (strExpression.charAt(iLoop)){
			case "+":{
				Operator="+";
				ReadStatus="O";	
				break;				
			}
			case "-":{
				Operator="-";
				ReadStatus="O";	
				break;				
			}
			case "*":{
				
				Operator="*"
				ReadStatus="O";	
				break;			
			}
			case "/":{
				Operator="/";
				ReadStatus="O";			
				break;
			}
			case "(":{
				Operator="(";
				ReadStatus="PB";			
				break;
			}
			case ")":{
				Operator=")";
				ReadStatus="PE";			
				break;
			}
			
			case ";":{
				ReadStatus="F";
				break;
			}
			
			default: {
				ReadStatus="V";		 
				iValue=iValue+strExpression.charAt(iLoop);
				break;
			}

		}
		//当前字符为操作符
		if ("O"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);				
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";	
			Operator="";	
		}
		
		//
		if ("PB"==ReadStatus) {
			strLine=strLine+Operator;
			iValue="";
			Operator="";
		}
		
		//
		if ("PE"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);	
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";
			Operator="";
		}
		//语句结束		
		if ("F"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);	
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode;	
			if (""==strLine) { return ""; }			
		}
	}

   $("#EditExpression").val(strLine);
	
	return strLine;
}

function BFind_click()
{
	$("#OrderDetailComTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$("#ParRef").val(),
			Desc:$("#ODDesc").val(),
			Code:"",
		});	
}

function AddData()
{
	
	$("#myWin").show();

		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
		$('#form-save').form("clear");
		var StaionDesc=$("#StaionDesc").val();
		$("#ODStaionDesc").val(StaionDesc);
		var valbox = $HUI.validatebox("#Code,#Desc", {
				required: false,
	   		});
	   	
		//默认选中
		$HUI.checkbox("#Summary").setValue(true);
		$HUI.checkbox("#NoPrint").setValue(true);	
	    //$HUI.checkbox("#HistoryFlag").setValue(true);
		 //默认性别为"不限"
	   $("#Sex").combobox('setValue',"N");

}

SaveForm=function(id)
{
	var iParRef="",iRowId="",iChildSub="",iAdvice="N",iSequence="";
	
	var iParRef=$.trim($("#ParRef").val());
	
	if(iParRef=="")
	{
		$.messager.alert('提示','请选择站点',"info");
		return;
		
	}
	
	
	if(id!==""){$("#ChildSub").val(id.split("||")[1])}
	var iChildSub=$.trim($("#ChildSub").val());
	
	var iCode=$.trim($("#Code").val());
	if(iCode=="")
	{	
		var valbox = $HUI.validatebox("#Code", {
				required: true,
	   		});
		$.messager.alert('提示','细项编码不能为空',"info");
		return;
		
	}
	
	var iDesc=$.trim($("#Desc").val());
	if(iDesc=="")
	{	
		var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
		$.messager.alert('提示','细项名称不能为空',"info");
		return;
		
	}
	
	var iType=$('#Type').combobox('getValue');
	if (($('#Type').combobox('getValue')==undefined)||($('#Type').combobox('getValue')=="")){var iType="";}
	if(iType=="")
	{ 
		var valbox = $HUI.combobox("#Type", {
				required: true,
	   		});
		$.messager.alert('提示','项目类型不能为空',"info");
		return;
		
	}

	var iExpression=$.trim($("#EditExpression").val());
	if(iType=="C"){
		var ExpressionFlag=IsValidExpression(iExpression);
		if (""==ExpressionFlag) {
		
			$.messager.alert('提示','表达式错误',"error");
			return false;
		}
  
	}
	var iUnit=$.trim($("#Unit").val());
	
	var iExplain=$.trim($("#Explain").val());
	
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) {iSummary="Y";}
	
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) {iNoPrint="Y";}
	
	var iHistoryFlag="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) {iHistoryFlag="Y";}
	
	var iSex=$('#Sex').combobox('getValue');
	if (($('#Sex').combobox('getValue')==undefined)||($('#Sex').combobox('getValue')=="")){var iSex="";}
	
	var iMarried=$('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")){var iMarried="";}
	
	var iZhToEng=$.trim($("#ZhToEng").val());
	
	var iSpecialNature=$.trim($("#SpecialNature").val());
	
	var Instring = iParRef
				+"^"+iRowId
				+"^"+iChildSub
				+"^"+iCode
				+"^"+iDesc
				+"^"+iType
				+"^"+iExpression
				+"^"+iUnit
				+"^"+iSummary
				+"^"+iAdvice
				+"^"+iExplain
				+"^"+iSequence
				+"^"+iSex
				+"^"+iNoPrint  
				+"^"+iZhToEng
				+"^"+iSpecialNature
				+"^"+iMarried
				+"^"+iHistoryFlag
				;
	
	 
	var flag=tkMakeServerCall("web.DHCPE.OrderDetail","Save",'','',Instring);

	if(flag==0){
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    $("#OrderDetailComTab").datagrid('load',{
			    ClassName:"web.DHCPE.OrderDetail",
				QueryName:"StationOrderDetailList",
				ParRef:iParRef,
			   
			    }); 
			   
			$('#myWin').dialog('close'); 
	    }else{
		     if(flag=="Err 03"){
			    if(id==""){$.messager.alert('操作提示',"保存失败:该编码已被其他项目使用","error");}
		     	if(id!=""){$.messager.alert('操作提示',"修改失败:该编码已被其他项目使用","error");}
		    }else{
		     if(id==""){$.messager.alert('操作提示',"保存失败","error");}
		     if(id!=""){$.messager.alert('操作提示',"修改失败","error");}
		    }

		     
	    }
	
	
		
}
	
function UpdateData()
{

	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待修改的记录","info");
		return
	}
	
	var StaionDesc=$("#StaionDesc").val();
	$("#ODStaionDesc").val(StaionDesc);
	
	
	
	if(ID!="")
	{	
	      var OrdDetailStr=tkMakeServerCall("web.DHCPE.OrderDetail","GetOrdDetailByID",ID);
	      
		   var OrdDetail=OrdDetailStr.split("^");
		   $('#Desc').val(OrdDetail[0]);
		   $('#Type').combobox('setValue',OrdDetail[1]);
		   if($('#Type').combobox('getValue')=="C"){
				$("#EditExpression").attr('disabled',false);	
			}else{
				$("#EditExpression").attr('disabled',true);
			}
		   $('#EditExpression').val(OrdDetail[2]);
		   $('#Unit').val(OrdDetail[3]);
		   if(OrdDetail[4]=="Y"){
			    $("#Summary").checkbox('setValue',true);
		   }else{
			   $("#Summary").checkbox('setValue',false);
		   }
		   
		    $('#Explain').val(OrdDetail[6]);
		    $('#LabtrakCode').val(OrdDetail[9]);
		    $('#Code').val(OrdDetail[10]);
		    $('#Sex').combobox('setValue',OrdDetail[8]);
		    
		    $('#ZhToEng').val(OrdDetail[11]);
		    $('#SpecialNature').val(OrdDetail[13]);
		    $('#Married_DR_Name').combobox('setValue',OrdDetail[14]);
		    if(OrdDetail[12]=="Y"){
			    $("#NoPrint").checkbox('setValue',true);
		   }else{
			   $("#NoPrint").checkbox('setValue',false);
		   }
		    if(OrdDetail[15]=="Y"){
			    $("#HistoryFlag").checkbox('setValue',true);
		   }else{
			   $("#HistoryFlag").checkbox('setValue',false);
		   }
		    
		    
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});	
			var valbox = $HUI.validatebox("#Code,#Desc", {
				required: false,
	   		});						
	}	
}

function DelData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待删除的记录","info");
		return
	}
	ParRef=ID.split("||")[0];
	ChildSub=ID.split("||")[1];
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OrderDetail", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:ParRef,ChildSub:ChildSub },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#ID").val(""); 
					
					$("#OrderDetailComTab").datagrid('load',{
			    		ClassName:"web.DHCPE.OrderDetail",
						QueryName:"StationOrderDetailList",
						ParRef:$("#ParRef").val(),
			   
			    	}); 
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
	
}

function InitCombobox()
{
	//项目类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'155',
		data:[
            {id:'T',text:'说明型'},
            {id:'N',text:'数值型'},
            {id:'C',text:'计算型'},
            {id:'S',text:'选择型'},
            {id:'A',text:'多行文本'},
        ]

	});
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'95',
		data:[
            {id:'M',text:'男'},
            {id:'F',text:'女'},
            {id:'N',text:'不限'},
           
        ]

	});
	
	//婚姻状况 
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'95',
	});

}


	
function InitOrderDetailDataGrid()
{
	$HUI.datagrid("#OrderDetailComTab",{
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
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$("#ParRef").val(),
			Desc:"",
			Code:"",
		},
		frozenColumns:[[
			{field:'OD_Desc',width:'150',title:'细项名称'},
			{field:'OD_Code',width:'100',title:'细项编码'},
		]],
		columns:[[
		    {field:'OD_ParRef',title:'ID',hidden: true},
		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_ChildSub',title:'ID',hidden: true},
			{field:'OD_Type',width:'80',title:'类型'},
			{field:'OD_Sequence',width:'100',hidden: true},
			{field:'OD_Sex',width:'60',title:'性别'},
			{field:'Married',title:'婚姻',hidden: true},
			{field:'MarriedDesc',width:'60',title:'婚姻'},
			{field:'OD_LabtrakCode',width:'100',title:'检验编码'},	
			{field:'OD_Summary',width:'80',title:'进入小结'},
			{field:'OD_Advice',width:'100',hidden: true},
			{field:'NoPrint',width:'70',title:'不打印'},
			{field:'SpecialNature',width:'100',title:'特殊范围'},
			{field:'ZhToEng',width:'90',title:'英文对照'},
			{field:'OD_Explain',width:'100',title:'说明'},
			{field:'OD_Expression',width:'250',title:'表达式'},
			{field:'OD_ParRef_Name',width:'100',title:'站点名称'},
			{field:'HistoryFlag',width:'70',title:'报告中对比'}
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#ID").val(rowData.OD_RowId)
			  		
						
				
					
					
		}
		
			
	})
}

function LoadOrderDetailComlist(rowData)
{
	
	$('#ParRef').val(rowData.ST_RowId);
	$('#StaionDesc').val(rowData.ST_Desc);
	$('#OrderDetailComTab').datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$('#ParRef').val(),
			Desc:"",
			Code:"",
		
	});
	
	
}
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
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:'50',title:'编码'},
			{field:'ST_Desc',width:'200',title:'名称'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderDetailComTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderDetailComlist(rowData);
			$("#ID").val("");		
		}
		
			
	})

}

