
//名称	DHCPEIllnessStandard.hisui.js
//功能	疾病维护
//创建	2019.06.05
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitIllnessFindDataGrid();
   
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //别名维护
     $('#Alias_btn').click(function(){
    	Alias_Click();
    });
    
    //疾病与建议对照
     $('#ILLED_btn').click(function(){
    	ILLED_Click();
    });
    
    //疾病解释
     $('#IllExplain_btn').click(function(){
    	IllExplain_Click();
    });
    
    //运动指导
     $('#IllSportGuide_btn').click(function(){
    	IllSportGuide_Click();
    });
    
   //饮食指导
	$('#IllDietGuide_btn').click(function(){
    	IllDietGuide_Click();
    });
  
      
})



//疾病解释
function IllExplain_Click(){
	ILLEDSave_Click("1");
}

//运动指导
function IllSportGuide_Click(){
	ILLEDSave_Click("2");
}

//饮食指导
function IllDietGuide_Click(){
	ILLEDSave_Click("3");
}

function ILLEDSave_Click(Type){
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	$("#ILLSName").val(Desc);
	if(ID==""){
		$.messager.alert('提示','请选择待维护的记录',"info");
	     return false;
	}
	if(Type=="1"){ 
		var title="疾病解释-"+Desc;
		document.getElementById("TIllExplain").innerHTML="疾病解释";
	}
	if(Type=="2"){ 
		var title="运动指导-"+Desc;
		
		document.getElementById("TIllExplain").innerHTML="运动指导";
	}
	if(Type=="3"){ 
		var title="饮食指导-"+Desc;
		document.getElementById("TIllExplain").innerHTML="饮食指导";
	}
	
	
	var IllEStr=tkMakeServerCall("web.DHCPE.IllnessStandard","GetIllInfo",ID,Type);
		   var ILLEList=IllEStr.split("@@");
		   $("#IllExplain").val(ILLEList[0]);
		   
		   if(ILLEList[1]=="Y"){
			    $("#PrintFlag").checkbox('setValue',true);
		   }else{
			   $("#PrintFlag").checkbox('setValue',false);
		   }
		  
		   
	$("#IllExplainWin").show();
	 
		var myWin = $HUI.dialog("#IllExplainWin",{
			iconCls:'icon-w-save',
			resizable:true,
			title:title,
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'saveILLE_btn',
				handler:function(){
					SaveILLEForm(ID,Type)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
}
SaveILLEForm=function(ID,Type)
{ 
    
	var IllExplain=$("#IllExplain").val();
	var iPrintFlag="N"
  	var PrintFlag=$("#PrintFlag").checkbox('getValue');
	if(PrintFlag) {iPrintFlag="Y";}
    
    var Instring=ID+"^"+IllExplain+"^"+Type+"^"+iPrintFlag;
    //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","SaveIllExplain",Instring);
	 if(flag==0){
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    $("#IllnessFindGrid").datagrid('load',{
			   ClassName:"web.DHCPE.IllnessStandard",
				QueryName:"QueryED",
				Code:$("#Code").val(),
		   	 	DiagnoseConclusion:$("#DiagnoseConclusion").val(),
				Alias:$("#Alias").val(),
			    }); 
			$('#IllExplainWin').dialog('close'); 
	    }else{
		    $.messager.alert('提示',"保存失败:  "+flag,"error");
	    }
		
	}
	
//疾病与建议对照
function ILLED_Click(){
		var record = $("#IllnessFindGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var illDesc=record.ED_DiagnoseConclusion
				var illRowId=record.ED_RowId
				/*
				$("#myWinILLED").show();  
				var myWinGuideImage = $HUI.window("#myWinILLED",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"疾病与建议对照-"+illDesc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcpeilledrelate.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
				});	
				*/
				lnk="dhcpeilledrelate.hisui.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc;
					
				websys_lu(lnk,false,'iconCls=icon-w-edit,width=880,height=400,hisui=true,title=疾病与建议对照-'+illDesc);

			}
}

	
//别名维护
function Alias_Click(){
	
	var record = $("#IllnessFindGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var illDesc=record.ED_DiagnoseConclusion
				var illRowId=record.ED_RowId
				/*
				$("#myWinAlias").show();  
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"别名维护-"+illDesc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcpeillsalias.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
				});	
				*/
				lnk="dhcpeillsalias.hisui.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc;
					
				websys_lu(lnk,false,'iconCls=icon-w-edit,width=800,height=400,hisui=true,title=别名维护-'+illDesc);

				
			}
}

//新增
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
		var MaxCode=tkMakeServerCall("web.DHCPE.IllnessStandard","GetMaxCode");
	    $("#IllCode").val(MaxCode);
		//默认选中
		//$HUI.checkbox("#CommonIllness").setValue(true);	
	
}

SaveForm=function(id)
{
	 var UserId=session['LOGON.USERID'];
	
	var Code=$("#IllCode").val();
	 
	 if (""==Code){
		$("#IllCode").focus();
	
		 $.messager.alert('提示','疾病编号不能为空',"info");
		return false
  	} 
  	
  	var Illness="N";
  	var iCommonIllness="N"
  	var CommonIllness=$("#CommonIllness").checkbox('getValue');
	if(CommonIllness) {iCommonIllness="Y";}
  	
 	
  	var DiagnoseConclusion=$("#IllDesc").val();
	if (""==DiagnoseConclusion){
		$("#IllDesc").focus();
		
		$.messager.alert('提示','疾病名称不能为空',"info");
		return false
  	} 
  	
	var InsertType=""
	
  	var EDAlias=$("#IllAlias").val();
  	
  	
  	var Detail=$("#IllDetail").val()
	if (""==Detail){
		
		$.messager.alert('提示','疾病建议不能为空',"info");
		return false
  	} 
	  	
    var ToReport=0;
    var SexDR=$("#Sex").combobox('getValue');
    if (($('#Sex').combobox('getValue')==undefined)||($('#Sex').combobox('getValue')=="")){var SexDR="";}
	var Type=$("#Type").combobox('getValue');
	if (($('#Type').combobox('getValue')==undefined)||($('#Type').combobox('getValue')=="")){var Type="";}
	
		
	if(id==""){
		var Instring=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+iCommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+ToReport+"^"+SexDR+"^^"+Type;
		var ReturnStr=tkMakeServerCall("web.DHCPE.IllnessStandard","InsertED",Instring);
		var flag=ReturnStr.split("^")[0];
		
	}else{
		
		var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^^^"+Illness+"^"+iCommonIllness+"^"+ToReport+"^"+SexDR+"^^"+Type;  
		 //alert(InString)
		 var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateED",id,InString);
		   
	   }
	    if(flag==0){
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    $("#IllnessFindGrid").datagrid('load',{
			   ClassName:"web.DHCPE.IllnessStandard",
				QueryName:"QueryED",
				Code:$("#Code").val(),
		   	 	DiagnoseConclusion:$("#DiagnoseConclusion").val(),
				Alias:$("#Alias").val(),
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('提示',"保存失败","error");
	    }
		
	}
	
function UpdateData()
{
	var ID=$("#ILLSRowId").val();
	if(ID==""){
		$.messager.alert('提示',"请选择待修改的记录","info");
		return
	}
	if(ID!="")
	{	
	      var EDStr=tkMakeServerCall("web.DHCPE.IllnessStandard","InitED",ID);
		   var EDList=EDStr.split("^");
		   $("#IllCode").val(EDList[0]);
		   $("#IllDesc").val(EDList[1]);
		   $("#IllDetail").val(EDList[2]);
		 
		   if(EDList[6]=="Y"){
			    $("#CommonIllness").checkbox('setValue',true);
		   }else{
			   $("#CommonIllness").checkbox('setValue',false);
		   }
		   $("#Sex").combobox('setValue',EDList[8]);
		   $("#Type").combobox('setValue',EDList[10]);
		   
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
	}
}

//查询
function BFind_click(){
	$("#IllnessFindGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"QueryED",
			Code:$("#Code").val(),
		    DiagnoseConclusion:$("#DiagnoseConclusion").val(),
			Alias:$("#Alias").val(),
		});	

}

//清屏
function BClear_click(){
	$("#Code,#DiagnoseConclusion,#Alias").val("");
}


function InitIllnessFindDataGrid(){
	$HUI.datagrid("#IllnessFindGrid",{
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
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"QueryED",
			Code:$("#Code").val(),
		    DiagnoseConclusion:$("#DiagnoseConclusion").val(),
			Alias:$("#Alias").val(),
		    
		},
		frozenColumns:[[
			{field:'ED_Code',width:'100',title:'编号'},
			{field:'ED_DiagnoseConclusion',width:'150',title:'疾病名称'},
		]],
		columns:[[
		    {field:'ED_RowId',title:'ID',hidden: true},
			{field:'ED_CommonIllness',width:'80',title:'常见病'},
			{field:'TSex',width:'80',title:'性别'},
			{field:'TType',width:'100',title:'类型'},
			{field:'ED_Detail',width:'650',title:'建议'},	
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ILLSRowId").val(rowData.ED_RowId);
				$("#ILLSDesc").val(rowData.ED_DiagnoseConclusion);
				
					
		}
		
			
	})
}


function InitCombobox(){
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'M',text:'男'},
            {id:'F',text:'女'},
            {id:'N',text:'不限'},
           
        ]

		});
		
	//类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'团体报告'},
            {id:'2',text:'妇科统计'},
            {id:'3',text:'阳性统计'},
            
        ]

		});
}

