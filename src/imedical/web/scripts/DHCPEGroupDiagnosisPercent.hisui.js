//
//名称	DHCPEGroupDiagnosisPercent.hisui.js
//功能	团体历年疾病发病率维护界面
//创建	2022.12.06
//创建人  sunxintao
var editIndex=undefined;
var GroupID="";
var GType="";
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitDetailDataGrid();
	
	InitPercentGrid();

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
	$HUI.datagrid("#YearTab",{
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
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryYear",
		},
		columns:[[

		    
		    {field:'Year',width:'300',title:'年份'}
					
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
	GroupID="";
	GType="";
	var Type=""
	var CID=$("#Contract").combogrid('getText');
	var CID=$("#Contract").combogrid('getValue');
	var GID=$("#GADM").combogrid('getValue');
	var DID=$("#Depart").combogrid('getText');
	var ID="";
	//alert(CID)
	if (CID!=""){
		Type="C";
		ID=CID
	}else if(GID!=""){
		Type="G"
		ID=GID
	}else{
		Type="D"
		ID=DID
	}
	$("#GInfoTab").datagrid('load', {
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryGInfo",
			GType:Type,
			ID:ID
		
	});
	
	$('#PercentGrid').datagrid('loadData', {
				total: 0,
				rows: []
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
function InitDetailDataGrid()
{
	
	$HUI.datagrid("#GInfoTab",{
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
			GType:"",
			ID:"",
		},
		columns:[[

		    {field:'ID',title:'ID',hidden: true},
		    {field:'TypeDesc',width:'50',title:'类型'},
		    {field:'Name',width:'200',title:'名称'},
		    {field:'GType',hidden: true,title:'团体类型'}			
		]],
		
		onSelect: function (rowIndex, rowData) {
			  		
			  		GroupID=rowData.ID;
			  		GType=rowData.GType
			$('#PercentGrid').datagrid('loadData', {
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
	debugger; //
	
	var Year=$("#YearTab").datagrid("getSelected").Year;
	
	// Type// GID
	//BClear_click();
	$("#PercentGrid").datagrid('load', {
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryDiagnosis",
			Year:Year,
			Type:rowData.GType,
			GID:rowData.ID
		
	});
	
	
}


function InitPercentGrid()
{
	// DiagnosisDesc,DiagnosisType,Percent
	$HUI.datagrid("#PercentGrid",{
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
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
		//displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryDiagnosis",
			Year:'',
			Type:''
		},
		columns:[[
		    {field:'Year',title:'Year',hidden: true},
		    {field:'Type',title:'Type',hidden: true},
		    {field:'EDID',title:'EDID',hidden: true},
		    {field:'DiagnosisDesc',width:'160',title:'描述'},
		    {field:'DiagnosisType',width:'60',title:'类型'},
			{field:'Percent',width:'120',title:'百分比',editor:{type:'numberbox'}}
						
		]],
		onSelect: function (rowIndex, rowData) {
			
					
		
		},onAfterEdit:function(rowIndex,rowData,changes){
			
			//alert(rowIndex);
			//alert(rowData);
			//alert(changes);
			debugger; //
			SavePercent(rowData.EDID,rowData.Year,rowData.Percent)
			
		},onDblClickRow: onDblClickRow
		
			
	})
}
function onDblClickRow(index,value){
     
        NowRow=index;
        debugger; //
        if (editIndex!=index) {
            if (endEditing()){
                $('#PercentGrid').datagrid('selectRow',index).datagrid('beginEdit',index);
                
                var tt = $('#PercentGrid').datagrid('getEditor', { index: index, field: 'Percent' });
                //var IsMedical = $('#PreItemList').datagrid('getRows')[index]['TIsMedical'] 
                
                editIndex = index;
                
            } else {
                $('#PercentGrid').datagrid('selectRow',editIndex);
            }
        }
     
    }
function endEditing(){
            
            if (editIndex == undefined){return true}
            debugger; //  222
            if ($('#PercentGrid').datagrid('validateRow', editIndex)){
	            
               $('#PercentGrid').datagrid('endEdit',editIndex);
               
                //SavePercent(EDID,Year,Percent)
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
    }
function SavePercent(EDID,Year,Percent)
{
	//var GroupID=$("#GInfoTab").datagrid('')
	// GType  GroupID
	/// d ##Class(web.DHCPE.GroupDiagnosisPercent).SavePercent(GType, GID, Year, EDID, Percent)
	if((GroupID=="")||(GType=="")){
		alert("没有选择团体信息")
	}
	// d ##Class(web.DHCPE.GroupDiagnosisPercent).SavePercent(GType, GID, Year, EDID, Percent)
	var ret=tkMakeServerCall("web.DHCPE.GroupDiagnosisPercent","SavePercent",GType, GroupID, Year, EDID, Percent);
	debugger; // ret
	
	
	
	}
function InitCombobox()
{
	// 合同
	   var OPNameObj = $HUI.combogrid("#Contract",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TName',
		onBeforeLoad:function(param){
			param.Contract = param.q;
		},
		columns:[[
		    {field:'TNo',title:'编号',width:60},
			{field:'TName',title:'名称',width:100},
			{field:'TSignDate',title:'签订日期',width:110}
				
		]],
		onLoadSuccess:function(){
			//$("#OPName").combogrid('setValue',""); 
		},

		});
		
		// 团体
	   var OPNameObj = $HUI.combogrid("#GADM",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Name',
		onBeforeLoad:function(param){
			param.Code = param.q;
		},
		columns:[[
		    {field:'Name',title:'名称',width:100},
			{field:'Hidden',title:'ID',width:100},
			{field:'Begin',title:'开始日期',width:110},
			{field:'End',title:'截止日期',width:110}
				
		]],
		onLoadSuccess:function(){
			//$("#OPName").combogrid('setValue',""); 
		},

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

