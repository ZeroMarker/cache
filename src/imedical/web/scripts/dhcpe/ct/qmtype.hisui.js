
//名称	dhcpe/ct/qmtype.hisui.js
//功能	质量管理错误类型 dyq	
//创建	2021.08.15
//创建人  sxt
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_QMType";
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr);

	InitQMTypeDataGrid();
	
	//修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click(0);		
        });
    
    /// 关联数据
    $("#RelateLoc").click(function() {	
		BRelateLoc_click();		
        });
      
       
    /// 切换科室刷新数据
	$("#LocList").combobox({
	     onSelect:function(data){  
		   		var CurLoc=$("#LocList").combobox('getValue');
		   		if(CurLoc==undefined) CurLoc=session['LOGON.CTLOCID'];
		   		$("#QMTypeQueryTab").datagrid('load',{
						ClassName:"web.DHCPE.CT.QualityManager",
						QueryName:"SearchQMTypeNew",
						LocID:CurLoc
				});		    
		 }
     })
     
    
    
    //按钮操作权限（管控数据）
    DisableButton();
     
})


//按钮操作权限（管控数据）
function DisableButton(){
    var UserID=session['LOGON.USERID'];
    var GroupID=session['LOGON.GROUPID'];
    var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
    if(flag=="S"){
        $('#RelateLoc').linkbutton('enable');
        $("#BUpdate").linkbutton('enable');
        $("#BAdd").linkbutton('enable');    
    }else{
        $('#RelateLoc').linkbutton('disable');
        $("#BUpdate").linkbutton('disable');
        $("#BAdd").linkbutton('disable');
    }
}

//修改
function BUpdate_click()
{
	BSave_click("1");
}

 //新增
function BAdd_click()
{
	BSave_click("0");
}


//更新
function BSave_click(Type)
{
	
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var Remark=$("#Remark").val();
	var ExpStr=$("#ExpStr").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
		
		if($("#ID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请先清屏再新增","info");
			return false;
		}
		var ID="";
	}

	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
   
    if (""==Code) {
	    
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	  });
		$.messager.alert("错误提示","代码不能为空","error");
		return false;
	 }
	 
      if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   });
	   
		$.messager.alert("错误提示","错误类型不能为空","error");
		return false;
	 }

	if (""==ExpStr) {
		$("#ExpStr").focus();
		var valbox = $HUI.validatebox("#ExpStr", {
			required: true,
	    });
		$.messager.alert("错误提示","扩展信息不能为空","error");
		return false;
	 }

	var SaveInfo=Code+"^"+Desc+"^"+Remark+"^"+ExpStr+"^"+iActiveFlag;
	var Ret=tkMakeServerCall("web.DHCPE.CT.QualityManager","SaveQMType",ID,SaveInfo,session['LOGON.USERID']);
	var Arr=Ret.split("^");
	if (Arr[0]=="0"){
		$.messager.popover({msg: Arr[1],type:'success',timeout: 1000});
		BClear_click(1);
		$("#QMTypeQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew",
			LocID:$("#LocList").combobox('getValue')
			});
	
	}else{
		$.messager.alert("提示",Arr[1],"error");
		
	} 

}
//数据关联科室
function BRelateLoc_click()
{	
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}   

   var LocID=$("#LocList").combobox('getValue');
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitQMTypeDataGrid);
 }

//清屏
function BClear_click(Type)
{
	$("#Code,#Desc,#ExpStr,#Remark,#ID").val("");

	$("#ActiveFlag").checkbox('setValue',true);

	var valbox = $HUI.validatebox("#Code,#Desc,#ExpStr", {
		required: false,
	  });

	if(Type=="0"){
		$("#LocList").combobox('setValue',session["LOGON.CTLOCID"]);
	}
	
   
    var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$('#QMTypeQueryTab').datagrid('load', {
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew", 
			LocID:locId
		});
}


function InitQMTypeDataGrid(){

	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$HUI.datagrid("#QMTypeQueryTab",{
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
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew",
			LocID:locId
		},
		columns:[[
	
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'100',title:'代码'},
			{field:'Desc',width:'230',title:'错误类型'},
			{field:'ActiveFlag',width:'50',title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                   }
			},
			{field:'Remark',width:'150',title:'备注'},
			{field:'ExpStr',width:'200',title:'扩展信息'},
			{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var Remark=$("#Remark").val(rowData.Remark);
				var ExpStr=$("#ExpStr").val(rowData.ExpStr);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="否"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="是"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}

