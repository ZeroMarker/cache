
//名称	dhcpe/ct/dhcpeinpatienttohp.indoc.hisui.js
//功能	住院医生维护 多院区
//创建	2021.08.12
//创建人  sxt
var tableName = "DHC_PE_OthPatToHPBase";

var DetailtableName = "DHC_PE_OthPatToHPBaseCPT";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr);
		
	InitCombobox();
	
	InitIPToHPInDocDataGrid();
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
       });
    	
	 //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	       BClear_click();		 
       }
		
	});
})



//清屏
function BClear_click()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$("#UserName").combogrid('setValue',"");
	$("#ID").val("");
	var valbox = $HUI.combogrid("#UserName", {
				required: false,
	   	   });
	$("#IPToHPInDocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
			curLoc:locId
		});
}

 //新增
 function BAdd_click()
 {
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	//LocID=session['LOGON.CTLOCID'];
	
	var UserID=$("#ID").val();
	if($("#ID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    return false;
	}
	if(UserID==""){
		var UserID=$("#UserName").combogrid('getValue');
        if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
	}
	
	if (UserID!=""){
			var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(flag=="0"){
				$.messager.alert("提示","请选择医生","info");
				return false;
				}
			
	}else{
		    $("#UserName").focus();
		    $.messager.alert("提示","医生不能为空","info");
		 	var valbox = $HUI.combogrid("#UserName", {
				required: true,
	   	   });
			return false;
		}
	
	//alert(LocID+"^"+UserID)
	var ret=tkMakeServerCall("web.DHCPE.CT.OtherPatientToHPBaseSet","SetInDoc",LocID,UserID,"N");
	
	 BClear_click();
	 if(ret==0){
		$.messager.alert("提示","新增成功","success");
	  }
				
 
 }

 //删除
function BDelete_click()
{
	LocID=session['LOGON.CTLOCID'];
	var UserID=$("#ID").val();
	
	if (UserID==""){
		$.messager.alert("提示","请选择待删除的数据","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet", MethodName:"SetInDoc",LocID:LocID,UserID:UserID,DeleteFlag:"Y"},function(ReturnValue){
				if (ReturnValue!="0") {
					$.messager.alert("提示","删除失败","error");
				}else{
					BClear_click();
					$.messager.alert("提示","删除成功","success");
				}
				});
		}
	});
	
}


function InitCombobox()
{
	//操作员
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCTPCP",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:200}			
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',"")	
		}
		});
}

function InitIPToHPInDocDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$HUI.datagrid("#IPToHPInDocQueryTab",{
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
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
			curLoc:locId
		},
		columns:[[
	
		    {field:'UserID',title:'UserID',hidden: true},
			{field:'UserCode',width:'600',title:'工号'},
			{field:'UserName',width:'600',title:'医生'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.UserID);
				$("#UserName").combogrid('setValue',rowData.UserName);		
				
			
		}
		
			
	})

}


