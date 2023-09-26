//
//名称	DHCPEOrdStandardCom.hisui.js
//功能	细项选择维护
//创建	2019.05.31
//创建人  xy
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderDetailDataGrid();
	
	InitODStandardComDataGrid();

	//查询
	$("#BFind").click(function(e){
    	BFind_click();
    });
    
    
	$("#ODDesc").keydown(function(e) {
			
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
	
	 //默认性别为"不限"
	$("#Sex").combobox('setValue',"N"); 

})



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
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
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
			  		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderDetailTablist(rowData);
					
		}
		
			
	})

}

/**********************细项界面************************************/
 function BFind_click()
{
	
	$("#OrderDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ODDesc").val()
		
	});

}



function LoadOrderDetailTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	$("#ODRowID,#ODSRowID,#ChildSub,#ODType").val("");
	
	$("#OrderDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
		
	});
	
	
}
function InitOrderDetailDataGrid()
{
	
	$HUI.datagrid("#OrderDetailTab",{
		url:$URL,
		fit : true,
		border: false,
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
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
		},
		columns:[[

		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_Type',title:'ODType',hidden: true},
		    {field:'OD_Desc',width:'200',title:'名称'},
			{field:'OD_Code',width:'80',title:'编码'},			
		]],
		
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadODStandardComDatalist(rowData);
					
		}
		
			
	})
}

/**********************细项选择维护界面************************************/
function LoadODStandardComDatalist(rowData)
{
	
	$("#ODRowID").val(rowData.OD_RowId);
	$("#ODSDesc").val(rowData.OD_Desc);
	$("#ODType").val(rowData.OD_Type);
	BClear_click();
	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		
	});
	
	
}


function InitODStandardComDataGrid()
{
	$HUI.datagrid("#ODStandardComGrid",{
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
		//displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		},
		frozenColumns:[[
			{field:'TTextVal',width:'120',title:'文本值'},
		]],
		columns:[[
		    {field:'ODS_ParRef',title:'ParRef',hidden: true},
		    {field:'ODS_RowId',title:'RowId',hidden: true},
		    {field:'ODS_ChildSub',title:'ChildSub',hidden: true},
		    {field:'TSex',title:'Sex',hidden: true},
		    {field:'TSexDesc',width:'60',title:'性别'},
		    {field:'TSort',width:'60',title:'序号'},
			{field:'TNatureValue',width:'60',title:'正常值'},
			{field:'THDValue',width:'60',title:'荒诞值'},
			{field:'TNoPrint',width:'60',title:'不打印'},
			{field:'TSummary',width:'60',title:'进入小结'},
			{field:'TAgeMin',width:'80',title:'年龄下限'},
			{field:'TAgeMax',width:'80',title:'年龄上限'},
			{field:'TMin',width:'60',title:'下限'},
			{field:'TMax',width:'60',title:'上限'},
			{field:'TUnit',width:'60',title:'单位'},
			{field:'TEyeSee',width:'100',title:'所见'},	
						
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ODSRowID").val(rowData.ODS_RowId);
			$("#ChildSub").val(rowData.ODS_ChildSub);
			$("#Sex").combobox('setValue',rowData.TSex);
			$("#Sort").val(rowData.TSort);
			if(rowData.TNatureValue=="否"){
					$("#NatureValue").checkbox('setValue',false);
				}if(rowData.TNatureValue=="是"){
					$("#NatureValue").checkbox('setValue',true);
				};
			if(rowData.TSummary=="否"){
					$("#Summary").checkbox('setValue',false);
				}if(rowData.TSummary=="是"){
					$("#Summary").checkbox('setValue',true);
				};
			if(rowData.THDValue=="否"){
					$("#HDValue").checkbox('setValue',false);
				}if(rowData.THDValue=="是"){
					$("#HDValue").checkbox('setValue',true);
				};	
			if(rowData.TNatureValue=="否"){
					$("#NatureValue").checkbox('setValue',false);
				}if(rowData.TNatureValue=="是"){
					$("#NatureValue").checkbox('setValue',true);
				};
			$("#EyeSee").val(rowData.TEyeSee);
			$("#Unit").val(rowData.TUnit);
			$("#ReferenceMin").val(rowData.TMin);
			$("#ReferenceMax").val(rowData.TMax);
			$("#AgeMin").val(rowData.TAgeMin);
			$("#AgeMax").val(rowData.TAgeMax); 
			$("#TextVal").val(rowData.TTextVal); 
			$("#CurNatureValue").val(rowData.TNatureValue); 
					
		
		}
		
			
	})
}


function InitCombobox()
{
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
}


 //新增
function BAdd_click()
{
	BSave_click("0");
}

 //修改
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type)
{
	if(Type=="1"){
		var ID=$("#ODSRowID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ODRowID").val()==""){
		    	$.messager.alert("提示","请先选择细项","info");
		    	return false;
		    }
	    if($("#ODSRowID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	var OrderDetailType=$("#ODType").val();
	var iParRef=$("#ODRowID").val();
	var iChildSub=$("#ChildSub").val();
	var iRowId="";
		
	//性别
	var iSex=$("#Sex").combobox('getValue');
	if (($("#Sex").combobox('getValue')==undefined)||($("#Sex").combobox('getValue')=="")) {var iSex = "";}
	if(iSex==""){
		$.messager.alert("提示","性别不能为空","info"); 
			return false;
	}

	//年龄下限
	var iAgeMin=$("#AgeMin").val();
	if (IsValidAge(iAgeMin)){}
		else { 
			$.messager.alert("提示","年龄下限错误","info");		
			return false;
		}
			

	//年龄上限
	var iAgeMax=$("#AgeMax").val();
	if (IsValidAge(iAgeMax)){}
		else {
			$.messager.alert("提示","年龄上限错误","info");		
			return false;
		}
	
	if(iAgeMin>iAgeMax){
		$.messager.alert("提示","年龄下限不能大于年龄上限","info");
		return false;
	}
	
	//文本值
	var iTextVal=$.trim($("#TextVal").val());

	//单位
	var iUnit=$("#Unit").val();
	
	//下限
	var iMin=$("#ReferenceMin").val();
	if (!(IsFloat(iMin))) {
		$.messager.alert("提示","参考值下限错误","info");
		return false;
	}
	
	//上限
	var iMax=$("#ReferenceMax").val();
	if (!(IsFloat(iMax))) {
		$.messager.alert("提示","参考值上限错误","info");
		return false;
	}
	
	//alert(OrderDetailType)
	if (("T"==OrderDetailType)||("S"==OrderDetailType)){
	    //输入数据验证
		if (""==iTextVal) {
			$.messager.alert("提示","文本值不能为空","info");
			return false;
	 	}
	}
	else{
		
		if ((""==iMax)&&(""==iMin)&&(""==iUnit)) {
			$.messager.alert("提示","参考范围一栏不能为空","info");
			return false;
		}	
	}


	//序号
	var iSort=$("#Sort").val();
	
	//所见
	var iEyeSee=$("#EyeSee").val();
	
	//是否正常值 
	var iNatureValue="N";
	var NatureValue=$("#NatureValue").checkbox('getValue');
	if(NatureValue) iNatureValue="Y";
	
	
	//是否进入小结 
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) iSummary="Y";
	
	
	//荒诞值
	var iHDValue="N";
	var HDValue=$("#HDValue").checkbox('getValue');
	if(HDValue) iHDValue="Y";
	
	
	//不打印
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) iNoPrint="Y";
	
	var iHighRiskFlag="N";
	
	
	var CurNatureValue=$("#CurNatureValue").val();
	var ret=tkMakeServerCall("web.DHCPE.ODStandard","GetODSNatureValue",iParRef,iRowId);
	if((CurNatureValue=="否")&&(iNatureValue=="Y")&&(ret=="1"))
	 {
	   $.messager.alert("提示","正常值已设置,不能重复设置","info");
	    return false;
    
	}
	
	var Instring = iParRef	
				+"^"+iRowId		
				+"^"+iChildSub
				+"^"+$.trim(iTextVal)		
				+"^"+$.trim(iUnit)		
				+"^"+$.trim(iSex)			
				+"^"+$.trim(iMin)		
				+"^"+$.trim(iMax)					
				+"^"+""					
				+"^"+iNatureValue
				+"^"+$.trim(iAgeMin)		
				+"^"+$.trim(iAgeMax)		
				+"^"+$.trim(iSort)	
	      		+"^"+iSummary
				+"^"+iNoPrint
	      		+"^"+""
	      		+"^"+iHighRiskFlag   
	      		+"^"+$.trim(iEyeSee)
	      		+"^"+iHDValue
		;
	//alert(Instring)
 	var flag=tkMakeServerCall("web.DHCPE.ODStandard","Save",'','',Instring);
	if (flag==0){
		
		BClear_click();
		
		if(Type=="1"){$.messager.alert("操作提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("操作提示","新增成功","success");}
	}else{
		$.messager.alert("操作提示","更新失败","error");	
	} 	
}

//删除
function BDelete_click()
{
	var ID=$("#ODSRowID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待删除的记录","info");
		return
	}
	var ParRef=$("#ODRowID").val();
	var ChildSub=$("#ChildSub").val();
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ODStandard", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:ParRef,ChildSub:ChildSub },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#ODSRowID").val(""); 
					$("#ODStandardComGrid").datagrid('load', {
						ClassName:"web.DHCPE.ODStandard",
						QueryName:"SearchODStandardNew",
						ParRef:$("#ODRowID").val(),
		
					});
					BClear_click();
			       // $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}

//清屏
function BClear_click()
{
	
	$("#ODSRowID,#ChildSub,#TextVal,#EyeSee,#Sort,#Unit,#ReferenceMax,#ReferenceMin,#AgeMin,#AgeMax,#CurNatureValue").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
		//默认性别为"不限"
	$("#Sex").combobox('setValue',"N");

	  
	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		
	});
}


//验证是否为正确年龄
function IsValidAge(Value) {
	
	if(""==$.trim(Value) || "0"==Value) { 
		//允许为空
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==$.trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

