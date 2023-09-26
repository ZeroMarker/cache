
//名称	DHCPEStationCom.hisui.js
//功能	站点维护
//创建	2019.05.23
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitStationDataGrid();
    
    InitStationLocDataGrid(); 
    
    InitStationLocDetailDataGrid();
    //查询
    $('#BFind').click(function(e){
    	BFind_click();
    });
    
     //清屏
    $('#BClear').click(function(e){
    	BClear_click();
    });
    
    
    //新增(站点)
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改(站点)
     $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //新增(站点对应科室)
     $('#STLadd_btn').click(function(e){
    	STLAdd_click();
    });
    
    //修改(站点对应科室)
     $('#STLupdate_btn').click(function(){
    	STLUpdate_click();
    });
    
    //删除(站点对应科室)
     $('#STLdel_btn').click(function(e){
    	STLDel_click();
    });
    
    
     //新增(科室对应项目)
     $('#STLDadd_btn').click(function(e){
    	STLDAdd_click();
    });
    
    //修改(科室对应项目)
     $('#STLDupdate_btn').click(function(){
    	STLDUpdate_click();
    });
    
    //删除(科室对应项目)
     $('#STLDdel_btn').click(function(e){
    	STLDDel_click();
    });
    
    //清屏(科室对应项目)
     $('#BSTDClear').click(function(){
    	BSTDClear_click();
    });
    
})



/**************************站点界面相关代码********************/
 //查询
function BFind_click()
{
	var iSTActive="N";
	var STActive=$("#STActive").checkbox('getValue');
	if(STActive) {iSTActive="Y";}
	
	$("#StationGrid").datagrid('load',{
			ClassName:"web.DHCPE.Station",
			QueryName:"FindStation",
			aCode:$.trim($("#STCode").val()),
			aDesc:$.trim($("#STDesc").val()),
		    aActive:iSTActive,
		});	
}

//清屏
function BClear_click()
{
	$("#STCode,#STDesc").val("");
	
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
		//默认选中
		$HUI.checkbox("#Active").setValue(true);	
}


SaveForm=function(id)
	{
		
		var Code=$.trim($('#Code').val());
		if (Code=="")
		{
			var valbox = $HUI.validatebox("#Code", {
				required: true,
	   		});
			$.messager.alert('错误提示','站点编码不能为空!',"error");
			return;
		}
	     
	    var Desc=$.trim($('#Desc').val());
		if (Desc=="")
		{
			var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
			$.messager.alert('错误提示','站点描述不能为空!',"error");
			return;
		}
		
		var Place=$.trim($('#Place').val());
	
		var Sequence=$.trim($('#Sequence').val());
		
		var iActive="N";
		var Active=$("#Active").checkbox('getValue');
	    if(Active) {iActive="Y";}
	    
	    var iAutoAudit="N";
		var AutoAudit=$("#AutoAudit").checkbox('getValue');
	    if(AutoAudit) {iAutoAudit="Y";}
	  	
	  	var iAllResultShow="N";
		var AllResultShow=$("#AllResultShow").checkbox('getValue');
	    if(AllResultShow) {iAllResultShow="Y";}
	
	
		var LayoutType=$('#LayoutType').combobox('getValue');	
		if (($('#LayoutType').combobox('getValue')==undefined)||($('#LayoutType').combobox('getValue')=="")){var LayoutType="";}
		
		var ButtonType=$('#ButtonType').combobox('getValue');	
		if (($('#ButtonType').combobox('getValue')==undefined)||($('#ButtonType').combobox('getValue')=="")){var ButtonType="";}
	
		
		var ReportSequence=$.trim($('#ReportSequence').val());
		if (ReportSequence=="")
		{
			var valbox = $HUI.validatebox("#ReportSequence", {
				required: true,
	   		});
			$.messager.alert('错误提示','报告顺序不能为空!',"error");
			return;
		}
		
		var Instring=id+"^"+Code+"^"+Desc+"^"+Place+"^"+Sequence+"^"+iActive+"^"+iAutoAudit+"^"+LayoutType+"^"+ButtonType+"^"+ReportSequence+"^"+iAllResultShow;
	   
		var flag=tkMakeServerCall("web.DHCPE.Station","Save",'','',Instring);
 		if (""==id) { 
			var Data=flag.split("^");
			flag=Data[0];
		}
	    if(flag==0){
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    $("#StationGrid").datagrid('load',{
			    ClassName:"web.DHCPE.Station",
				QueryName:"FindStation",
			
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('操作提示',"保存失败","error");
	    }
		
	}
	
	
function UpdateData()
{
	var STID=$("#StationID").val();
	if(STID==""){
		$.messager.alert('操作提示',"请选择待修改的记录","info");
		return
	}
	if(STID!="")
	{	
	      var StaionInfoStr=tkMakeServerCall("web.DHCPE.Station","GetStaionInfoByID",STID);
		   var StaionInfo=StaionInfoStr.split("^");
		   
		   
		   $("#Code").val(StaionInfo[0]);
		   $("#Desc").val(StaionInfo[1]);
		   $("#Sequence").val(StaionInfo[3]);
		   $("#ReportSequence").val(StaionInfo[8]);
		   $("#Place").val(StaionInfo[9]);
		   
		   $('#LayoutType').combobox('setValue',StaionInfo[6]);
		   $('#ButtonType').combobox('setValue',StaionInfo[7]);
		   
		   if(StaionInfo[4]=="Y"){
			    $("#Active").checkbox('setValue',true);
		   }else{
			   $("#Active").checkbox('setValue',false);
		   }
		   
		    if(StaionInfo[5]=="Y"){
			    $("#AutoAudit").checkbox('setValue',true);
		   }else{
			   $("#AutoAudit").checkbox('setValue',false);
		   }
		   
		    if(StaionInfo[10]=="Y"){
			    $("#AllResultShow").checkbox('setValue',true);
		   }else{
			   $("#AllResultShow").checkbox('setValue',false);
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
						SaveForm(STID)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}


function InitStationDataGrid()
{
	$HUI.datagrid("#StationGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 100,
		pageList : [100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"FindStation",
			aCode:"",
			aDesc:"",
		},
		frozenColumns:[[
			{field:'ST_Code',width:'80',title:'站点编码'},
			{field:'ST_Desc',width:'100',title:'站点描述'},
		]],
		columns:[[
	
		    {field:'ST_RowId',title:'ID',hidden: true},
			{field:'ST_Active',width:'40',title:'激活'},
			{field:'ST_Sequence',width:'80',title:'总检顺序'},
			{field:'ST_ReportSequence',width:'80',title:'报告显示顺序'},
			{field:'ST_ButtonType',width:'100',title:'按钮类型'},
			{field:'ST_LayoutType',width:'100',title:'界面类型'},
			{field:'ST_AutoAudit',width:'100',title:'科室自动提交'},
			{field:'ST_AllResultShow',width:'100',title:'总检显示所有结果'},
			{field:'ST_Place',width:'150',title:'站点位置'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#StationID").val(rowData.ST_RowId);
				$('#StationLocGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadStationLoc(rowData);			
					
		}
		
			
	})

}


/**************************站点对应科室界面相关代码********************/

//删除(站点对应科室)
function STLDel_click()
{	
	var LocID=$("#LocID").val();
	if(LocID==""){
		$.messager.alert("提示","请选择待删除的记录","info");	
		return false;
		
		}
		
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationLoc", MethodName:"Delete",LocID:LocID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#LocID,#LocDesc,#LocSort,#ParRefLocID").val("");
					$('#StationLocGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLoc",
		   				 ParRef:$("#ParRef").val(),
					});	
					$('#StationLocDetailGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLocDetail",
		    			LocID:LocID,
		
					});

     
				}
			});	
		}
	});
	
}

//新增(站点对应科室)
function STLAdd_click()
{
	
	STLSave_click("0");
}

//修改(站点对应科室)
function STLUpdate_click()
{
	STLSave_click("1");
}

function STLSave_click(Type)
{
	
  	var ParRef=$("#ParRef").val();
	if (ParRef==""){
		$.messager.alert("提示","请选择站点","info");
		return false;
	}
	if(Type=="0")
	{
		$("#LocID").val("");
	}
	var LocID=$("#LocID").val();
	
	if(Type=="1")
	{ 
		if(LocID==""){
			
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
			
		}
	}
	
	var LocDesc=$("#LocDesc").val();
	if (LocDesc==""){
		$.messager.alert("提示","科室描述不能为空","info",function(){
			var valbox = $HUI.validatebox("#LocDesc", {
			required: true,
	   	});
			$("#LocDesc").focus();
		});
		return false;

	}
	var LocSort=$("#LocSort").val();
	if (LocSort==""){
		$.messager.alert("提示","科室序号不能为空","info",function(){
			var valbox = $HUI.validatebox("#LocSort", {
			required: true,
	   	});
			$("#LocSort").focus();
		});
		return false;

	}else{
		   if((!(isInteger(LocSort)))||(LocSort<=0)) 
		   {
			   $.messager.alert("提示","科室序号只能是正整数","info");
			    return false; 
		   }

	}


	//alert(ParRef+"^"+LocID+"^"+LocDesc+"^"+LocSort)
	var flag=tkMakeServerCall("web.DHCPE.StationLoc","Update",ParRef,LocID,LocDesc,LocSort);
	if (flag=="0"){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		$("#LocID,#LocDesc,#LocSort").val("");
		$('#StationLocGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		    ParRef:ParRef,
		
		});
	}
	else{
		if(Type=="1"){$.messager.alert("提示","修改失败","error");}
		if(Type=="0"){$.messager.alert("提示","新增失败","error");}
	}	
}
function loadStationLoc(rowData) {
	
	$('#StationLocGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		    ParRef:rowData.ST_RowId,
		
	});
	$("#ParRef").val(rowData.ST_RowId);
	$("#LocID,#LocSort,#LocDesc").val("");
	$("#ARCID,#ARCSort,#ParRefLocID").val("");
	$("#ARCDesc").combogrid("setValue","");

	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:"",
		
	});
	
}
function InitStationLocDataGrid()
{
		$HUI.datagrid("#StationLocGrid",{
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
		queryParams:{
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		},
		
		columns:[[
		    {field:'STL_RowId',title:'ID',hidden: true},
			{field:'STL_Desc',width:'100',title:'科室名称'},
			{field:'STL_Sort',width:'80',title:'科室序号'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#LocID").val(rowData.STL_RowId);
				$("#LocSort").val(rowData.STL_Sort);
				$("#LocDesc").val(rowData.STL_Desc);
				$('#StationLocDetailGrid').datagrid('loadData', {
					total: 0,
					rows: []
				});
			  loadStationLocDetail(rowData);			
								
					
		}
		
			
	})
}
function loadStationLocDetail(rowData) {
	
	$("#ParRefLocID").val(rowData.STL_RowId)
	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:rowData.STL_RowId,
		
	});
	

	
}



/**************************科室对应项目界面相关代码********************/
//清屏(科室对应项目)
function BSTDClear_click()
{
	
	$("#ARCID,#ARCSort").val("");
	$("#ARCDesc").combogrid("setValue","");
	var valbox = $HUI.combobox("#ARCDesc", {
				required: false,
	    	});
	 InitCombobox();
	$("#STLDadd_btn").linkbutton('enable');
	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:$("#ParRefLocID").val(),
		
		});
}


//新增(科室对应项目)
function STLDAdd_click()
{
	STLDSave_click("0");
}
    
//修改(科室对应项目)
function STLDUpdate_click()
{
	STLDSave_click("1");
}

function STLDSave_click(Type)
{
	if(Type=="0")
	{
		if($("#ARCID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请先清屏再新增","info");
			return false;
			}
		var ARCRowID=$("#ARCDesc").combogrid("getValue");
		if (($("#ARCDesc").combogrid('getValue')==undefined)||($("#ARCDesc").combogrid('getValue')=="")){var ARCRowID="";}
		if (ARCRowID==""){
				var valbox = $HUI.combogrid("#ARCDesc", {
				required: true,
	   		});
			$.messager.alert("提示","项目不能为空","info");
			return false;
		}
	}
	
	if(Type=="1")
	{ 
	   var ARCRowID=$("#ARCID").val();
		if(ARCRowID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
			
		}
		
	}
	
	
	var Sort=$("#ARCSort").val();
	if (Sort==""){
		$.messager.alert("提示","序号不能为空","info",function(){
			var valbox = $HUI.validatebox("#ARCSort", {
			required: true,
	   	});
			$("#ARCSort").focus();
		});

		return false;
	}else{
		   if((!(isInteger(Sort)))||(Sort<=0)) 
		   {
			   $.messager.alert("提示","序号只能是正整数","info");
			    return false; 
		   }

	}
	var LocID=$("#ParRefLocID").val();
	if (LocID==""){	
		$.messager.alert("提示","没有选择科室","info");
		return false;
	}
	
	
	//alert(ARCRowID+"^"+Sort+"^"+LocID)
	var flag=tkMakeServerCall("web.DHCPE.StationLoc","UpdateDetail",ARCRowID,Sort,LocID);
	if (flag=="0"){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BSTDClear_click();
		
	}
	else{
		if(Type=="1"){$.messager.alert("提示","修改失败","error");}
		if(Type=="0"){$.messager.alert("提示","新增失败","error");}
	}	
}    
    
//删除(科室对应项目)
function STLDDel_click()
{

	var ID=$("#ARCID").val();
	if(ID==""){
		$.messager.alert("提示","请选择待删除的记录","info");	
		return false;
		
		}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationLoc", MethodName:"DeleteDetail", ARCIMID:ID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$('#StationLocDetailGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLocDetail",
		   				 LocID:$("#ParRefLocID").val(),
		
					});
					$("#ARCID,#ARCSort").val("");
					$("#ARCDesc").combogrid("setValue","");
	
			        
				}
			});	
		}
	});
	
}
 
 function InitStationLocDetailDataGrid()
{
		$HUI.datagrid("#StationLocDetailGrid",{
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
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:"",
		},
		
		columns:[[
		    {field:'ArcimID',title:'ID',hidden: true},
			{field:'ARCIMDesc',width:'250',title:'项目'},
			{field:'TSort',width:'80',title:'序号'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  $("#ARCID").val(rowData.ArcimID);
			  $("#ARCDesc").combogrid("setValue",rowData.ARCIMDesc);
			  $("#ARCSort").val(rowData.TSort);
			  $("#STLDadd_btn").linkbutton('disable');
				
					
		}
		
			
	})
}
   
function InitCombobox()
{ 
	 //界面类型
	var LayoutTypeObj = $HUI.combobox("#LayoutType",{
		valueField:'id',
		textField:'text',
		panelHeight:'123',
		data:[
            {id:'1',text:'简化'},
            {id:'2',text:'详细'},
            {id:'3',text:'普通化验'},
            {id:'4',text:'接口化验'},
            {id:'5',text:'普通检查'},
            {id:'6',text:'接口检查'},
            {id:'7',text:'其它'},
            {id:'8',text:'药品'},
        ]
		});
		
	 //按钮类型
	 	var ButtonTypeObj = $HUI.combobox("#ButtonType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'标准'},
            {id:'2',text:'妇科'},
            {id:'3',text:'超声'},
        ]

		});
		
	
	
	//项目
	var OrdObj = $HUI.combogrid("#ARCDesc",{
		panelWidth:320,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.ParRef = $("#ParRef").val();
			param.ARCIMDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#ARCDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'STORD_ParRef',title:'站点ID',hidden: true},
		    {field:'STORD_ParRef_Name',title:'站项目点名称',width:100},
			{field:'STORD_ARCIM_Desc',title:'医嘱名称',width:120},
			{field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
			{field:'STORD_ARCIM_DR',title:'医嘱ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			$("#ARCDesc").combogrid('setValue',"")
			
		},

		});
}


function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
	  }

