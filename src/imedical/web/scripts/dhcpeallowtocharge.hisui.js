
/*
 * FileName:    dhcpeallowtocharge.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: 允许缴费管理
 */
 
 $(function(){
	 
	 //下拉列表框
	 InitCombobox();
	
	//初始化列表
	InitAllowToChargeGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
    
	 //清屏
	 $("#BClear").click(function() {	
		BClear_click();		
     });
     
    //允许缴费/撤销允许缴费
	$("#BSave").click(function() {	
		BSave_click();		
     });
     
})

 //允许缴费/撤销允许缴费
function BSave_click()
{ 
    var UserId=session['LOGON.USERID'];
	var selected = $('#AllowToChargeGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('提示', "请选择待允许缴费的记录", 'info');
		return;
	}
	var GADMID=selected.PEIAdmId;
	var AllowFlag=selected.TSelect;
	if(AllowFlag=="0"){
		var AllowFlag=1;
	}else{
		 AllowFlag=0;
	}
	var Type="Group";
	if(AllowFlag=="0"){
		$.messager.confirm("确认", "确定要撤销允许缴费吗？", function(r){
		if (r){
			var ret=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToCharge",GADMID+"^"+AllowFlag,Type,"ADM",UserId);
 			if(ret=="0"){	
   				$.messager.popover({msg: "撤销允许缴费成功！", type: "success",timeout: 1000});
   				BFind_click();
 			}
			
		}else{
			return;
		}
	});	
	}else{
		
 		var ret=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToCharge",GADMID+"^"+AllowFlag,Type,"ADM",UserId);
 		if(ret=="0"){	
   			$.messager.popover({msg: "允许缴费成功！", type: "success",timeout: 1000});
   			BFind_click();
 		}
	}
	
}


//查询
function BFind_click() {

	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	var iGroupID=$("#GroupName").combogrid('getValue');
	if (($("#GroupName").combogrid('getValue')==undefined)||($("#GroupName").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iHadAllowed="0";
	var HadAllowed=$("#HadAllowed").checkbox('getValue');
	if(HadAllowed){iHadAllowed="1";}  
	//alert($("#AdmDate").datebox('getValue')+"^"+$("#EndDate").datebox('getValue')+"^"+iGroupID+"^"+iRegNo+"^"+iHadAllowed+"^"+1)
	 //s ^dhcpe("AllowToCharge")=$lb(txtPatName,txtGroupId,txtAdmDate,txtAdmNo,txtItemId,EndDate,HadAllowed,ShowGroup)
	$("#AllowToChargeGrid").datagrid('load',{
		ClassName:"web.DHCPE.AllowToCharge",
		QueryName:"AllowToCharge",
		txtAdmDate:$("#AdmDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		txtGroupId:iGroupID,
		txtAdmNo:iRegNo,
		HadAllowed:iHadAllowed,
		ShowGroup:1,
	

	});
}

//清屏
function BClear_click()
{
	$("#RegNo").val("");
	$("#AdmDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BSave").linkbutton({text:'允许缴费'})
	BFind_click();
}


function InitAllowToChargeGrid(){

	$HUI.datagrid("#AllowToChargeGrid",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.AllowToCharge",
			QueryName:"AllowToCharge",
			txtAdmDate:$("#AdmDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},

		columns:[[ 
			
		    {field:'PEIAdmId',title:'PEIAdmId',hidden: true},
			{field:'AdmNo',width:140,title:'登记号'},
			{field:'PatName',width:400,title:'团体名称'},
			{field:'TSelect',title:'允许缴费',width:90,align:'center',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="1") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
			}},     	
			{field:'TGDesc',title:'是否团体',hidden: true},
			{field:'AdmDate',width:120,title:'登记日期'},
			{field:'AdmStatus',width:120,title:'状态'},
			{field:'AdmAccountAmount',width:260,title:'应收金额',align:'right'},
			{field:'AdmFactAmount',width:260,title:'已付金额',align:'right'}
	
		]],
		onSelect: function (rowIndex, rowData) {
			if(rowData.TSelect=="1"){
				$("#BSave").linkbutton({text:'撤销允许缴费'})
			}else{
				$("#BSave").linkbutton({text:'允许缴费'})
			}
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


function InitCombobox()
{
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName", {
		panelWidth: 450,
		url: $URL + "?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode: 'remote',
		delay: 200,
		idField: 'TRowId',
		textField: 'TGDesc',
		onBeforeLoad: function (param) {
			param.GBIDesc = param.q;
		},
		onChange: function () {	
		},
		columns: [[
			{ field: 'TRowId', title: '团体ID', width: 80 },
			{ field: 'TGDesc', title: '团体名称', width: 140 },
			{ field: 'TGStatus', title: '状态', width: 100 },
			{ field: 'TAdmDate', title: '日期', width: 100 }

		]]
	})

	
}
