
//名称	DHCPEEDItem.hisui.js
//功能	危害因素检查项目维护
//创建	2019.06.17
//创建人  xy

$(function(){
	InitCombobox();
	
	InitEDItemGrid();
	
	InitEDItemDetailGrid();  
	 
    //修改
	$("#update_btn").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#add_btn").click(function() {	
		BAdd_click();		
        }); 
    
    //删除
	$("#del_btn").click(function() {	
		BDel_click();		
        });   
   
    
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
 	//细项维护
 	$("#Detail_btn").click(function() {	
		BDetail_click();
				
        });
     //保存
     $("#BSave").click(function() {	
		BSave_Click();		
        });
     
 
   
})


 //修改
function BUpdate_click(){
	BSave_click("1");
}

//新增
function BAdd_click(){
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
	}
	
	var SetsFlag="N";
	
	var ArcimID=$("#ArcimDesc").combogrid('getValue');
	if (($("#ArcimDesc").combogrid('getValue')==undefined)||($("#ArcimDesc").combogrid('getValue')=="")){var ArcimID="";}
	if(Type=="1"){var ArcimID=$("#ArcimID").val();}
	if((ArcimID!="")&&(ArcimID.split("||").length<2)){
		$.messager.alert("提示","请选择检查项目","info");
		return false;
		  
		    }
	
	if (ArcimID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",ArcimID);
			if(ret=="0"){
				$.messager.alert("提示","请选择检查项目","info");
				return false;
				}
		}
   
	var SetsID=$("#SetsDesc").combogrid('getValue');
	if (($("#SetsDesc").combogrid('getValue')==undefined)||($("#SetsDesc").combogrid('getValue')=="")){var SetsID="";}
	if(Type=="1"){var SetsID=$("#SetsID").val();}
    if (SetsID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsSets",SetsID);
			if(ret=="0"){
				$.messager.alert("提示","请选择套餐","info");
				return false;
				}		
		}
	//alert(SetsID+"^"+ArcimID)
	if ((ArcimID=="")&&(SetsID=="")){
			$.messager.alert('提示','项目或套餐不能为空',"info");
			return false;
		}
	if (ArcimID==""){
			SetsFlag="Y";
			ArcimID=SetsID;
	}
	
	var ID=$("#ID").val();
	var Parref=$.trim(selectrow);
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	
	
	var iNeedFlag="N";
	var iNeedFlag="N";
	var NeedFlag=$("#NeedFlag").checkbox('getValue');
	if(NeedFlag) iNeedFlag="Y";
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}
	
	var flag=tkMakeServerCall("web.DHCPE.Endanger","IsExistItem",$.trim(selectrow),ArcimID)
	if((flag=="1")&&(Type=="0")){
		$.messager.alert("提示","检查项目或套餐已存在，不能重复维护","info");
		return false;
	}
	var Str=Parref+"^"+ArcimID+"^"+iNeedFlag+"^"+OMETypeDR+"^"+SetsFlag+"^"+iActive+"^"+ExpInfo+"^"+Remark;
    //alert(Str)
    
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDItemSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","更新失败","error");
		
	}else{
		BClear_click();
		
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
	}
	
	
	
}

//删除
function BDel_click(){
	var ID=$("#ID").val();
	if (ID=="")
	{
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDItemDelete",ID:ID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click();

				}
			});	
		}
	});
	
}

function BClear_click(){
	$("#ID,#ExpInfo,#Remark,#ArcimID").val("");
	$(".hisui-checkbox").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#EDItemGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDItem",
			Parref:$.trim(selectrow),
		});	
}


function InitCombobox(){
	
	//项目描述
	 var ArcObj = $HUI.combogrid("#ArcimDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=StationOrderList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Item = param.q;
		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',hidden: true},
			{field:'STORD_ARCIM_Code',title:'编码',width:80},
			{field:'STORD_ARCIM_Desc',title:'名称',width:180},	
			{field:'STORD_ARCIM_Price',title:'价格',width:100},	
			{field:'TUOM',title:'单价',hidden: true}, 
			{field:'TLocDesc',title:'科室',width:100},	
			
					
		]]
		});
		
	//套餐描述
	var SetsObj = $HUI.combogrid("#SetsDesc",{
		panelWidth:400,
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
		    {field:'OrderSetId',title:'ID',hidden: true},
			{field:'OrderSetDesc',title:'名称',width:150},
			{field:'IsBreakable',title:'是否拆分',width:100},	
			{field:'OrderSetPrice',title:'价格',width:100},	
					
		]]
		});
		
	//检查种类
	   var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'OMET_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'OMET_Code',title:'代码',width:80},
			{field:'OMET_Desc',title:'描述',width:180},	
			{field:'OMET_VIPLevel',title:'VIP等级',width:100},	
					
		]]
		});
}

function InitEDItemGrid(){
	$HUI.datagrid("#EDItemGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDItem",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
		    {field:'TArcimID',title:'ArcimID',hidden: true},
			{field:'TArcimCode',width:120,title:'项目编码'},
			{field:'TArcimDesc',width:200,title:'项目描述'},
			{field:'TNeedFlag',width:60,title:'必填'},
			{field:'TSetsFlag',width:80,title:'是否套餐'},
			{field:'TOMEType',width:150,title:'检查种类'},
			{field:'TActive',width:60,title:'激活'},
			{field:'TExpInfo',width:130,title:'扩展信息'},
			{field:'TRemark',width:100,title:'备注'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#ID").val(rowData.TID);
				
				if(rowData.TSetsFlag=="是"){
					
				   // $("#SetsDesc").combogrid('setValue',rowData.TArcimID);
				   $("#SetsDesc").combogrid('setValue',rowData.TArcimDesc);
				    $("#ArcimDesc").combogrid('setValue',"");
				    $("#ArcimID").val("");
				    $("#SetsID").val(rowData.TArcimID);
			    }else{
					$("#ArcimDesc").combogrid('setValue',rowData.TArcimDesc);
					$("#ArcimID").val(rowData.TArcimID);
                    $("#SetsID").val("");
					$("#SetsDesc").combogrid('setValue',"");
			    }

			
				$("#OMEType").combogrid('setValue',rowData.TOMETypeDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				};
				if(rowData.TNeedFlag=="否"){
					$("#NeedFlag").checkbox('setValue',false);
				}if(rowData.TNeedFlag=="是"){
					$("#NeedFlag").checkbox('setValue',true);
				};
				$('#EDItemDetailGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadEDItemDetaill(rowData);	
												
		}
	})
}


/*****************************************细项维护界面*************************/

function loadEDItemDetaill(rowData) {
	
	$('#EDItemDetailGrid').datagrid('load', {
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SreachOrderDetailRelate",
		ParRef:rowData.TID,
		ParARCIMDR:rowData.TArcimID,
		
	});
	
	$("#ParRef").val(rowData.TID);
	$("#ParARCIMDR").val(rowData.TArcimID);
     
	
}

function InitEDItemDetailGrid(){

	$HUI.datagrid("#EDItemDetailGrid",{
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
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SreachOrderDetailRelate",
			ParRef:$("#ParRef").val(),
		    ParARCIMDR:$("#ParARCIMDR").val(),
		},
		columns:[[
			{title: '选择',field: 'Select',width: 70,checkbox:true},
		    {field:'ODR_RowId',title:'ID',hidden: true},
		    {field:'ODR_OD_DR',title:'ODDR',hidden: true},
		    {field:'ODR_Parent_DR',title:'ODPDR',hidden: true},
			{field:'EDItemDetailID',title:'EDItemDetailID',hidden: true},
			{field:'ODR_OD_DR_Code',width:100,title:'细项编码'},
			{field:'ODR_OD_DR_Name',width:180,title:'细项描述'},
			
			
		]],
		
		
	onLoadSuccess: function (rowData) { 
	   $('#EDItemDetailGrid').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	   //隐藏全选
	   //$("#SpecialItemContralDetailTab").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		
	    var objtbl = $("#EDItemDetailGrid").datagrid('getRows');
	              
		if (rowData) { 
		  
		  //遍历datagrid的行            
		 $.each(rowData.rows, function (index) {
			
			 	var flag=tkMakeServerCall("web.DHCPE.Endanger","GetItemDetailChecked",objtbl[index].ODR_OD_DR,$("#ParRef").val());
			 			//alert(flag)
			 			if(flag=="Y"){
				 			//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 		$('#EDItemDetailGrid').datagrid('checkRow',index);
				 		}
		 });
		 
		 
		 }
		}
		  
	})
}


//保存
 function BSave_Click()
 {
	
	 var ParRef=$("#ParRef").val();
	 var ParARCIMDR=$("#ParARCIMDR").val();
	  var str="";

	 var selectrow = $("#EDItemDetailGrid").datagrid("getChecked");//获取的是数组，多行数据
	   var rows = $("#EDItemDetailGrid").datagrid("getRows");
	for(var i=0;i<selectrow.length;i++){
		  	var Active="Y",ExpInfo="",Remark="";
			var ID=rows[i].EDItemDetailID;
			var Active=getColumnValue(i,"Select","EDItemDetailGrid")
			if(Active=="1"){Active="Y";}
			else{Active="N";}

			var DetailID=selectrow[i].ODR_OD_DR;
			var Str=ParRef+"^"+DetailID+"^"+Active+"^"+ExpInfo+"^"+Remark;
			//alert(Str)
			var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDItemDetailSave",ID,Str);
	}
 
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","保存失败","error");

	}
	else {
		$.messager.alert("提示","保存成功","success");
		$("#EDItemDetailGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SreachOrderDetailRelate",
			ParRef:ParRef,
			ParARCIMDR:ParARCIMDR,
				});
	}
	
 }
 