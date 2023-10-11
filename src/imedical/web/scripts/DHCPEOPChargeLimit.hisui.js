
//名称	DHCPEOPChargeLimit.hisui.js
//功能	体检打折权限维护	
//创建	2019.04.29
//创建人  xy

$(function(){
	
	InitCombobox();
	
	InitOPChargeLimitDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
      
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
          
    //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });

	$("#DFLimit").attr("disabled",true);
     //多选框的触发事件
    $HUI.checkbox('#OPFlag',{
        onChecked:function(e,value)
        {
            $("#DFLimit").attr("disabled",false);
            
        },
        onUnchecked:function(e,value)
        {
            $("#DFLimit").attr("disabled",true);
			$("#DFLimit").val("");
            
        } 
    });


})

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
		var iUser=$("#UserId").val();
		if(iUser==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		
		if($("#UserId").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var iUser=$("#OPName").combogrid('getValue');
        if (($("#OPName").combogrid('getValue')==undefined)||($("#OPName").combogrid('getValue')=="")){var iUser="";}
		
		if (iUser!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",iUser);
			if(ret=="0"){
				$.messager.alert("提示","请选择操作员","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#OPName", {
				required: true,
	    	});
			$.messager.alert("提示","操作员不能为空","info");
			return false;
		}

	
	}
	
	var iOPFlag="N";
	var OPFlag=$("#OPFlag").checkbox('getValue');
	if(OPFlag) iOPFlag="Y";
	
	var iDFLimit=$("#DFLimit").val();
	if(iOPFlag=="N"){
		if(iDFLimit!=""){ 
			$.messager.alert("提示","优惠打折不允许,最大折扣值应为空","info");
			return false;
		}
	}
	if(iOPFlag=="Y"){
		if(iDFLimit==""){ 
			$.messager.alert("提示","请输入折扣值","info");
			return false;
		}
		
		if((iDFLimit<=0)||(iDFLimit>=100)){
			$.messager.alert("提示","折扣值应大于0小于100","info");
			return false;
		}else{
			if (IsFloat(iDFLimit)){}
			else 
			{   
				$("#DFLimit").focus();
		    	$.messager.alert("提示","折扣值不能为0","info");
				return false;
			}
		}
		
		
	}
	
	var iASChargedFlag="N";
	var ASChargedFlag=$("#ASChargedFlag").checkbox('getValue');
	if(ASChargedFlag) iASChargedFlag="Y";
	var iRoundingFeeMode="0"
    var iRoundingFeeMode=$("#RoundingFeeMode").combobox('getValue'); 
    
  
	var Instring=trim(iUser)	
				+"^"+trim(iDFLimit)
				+"^"+iOPFlag
				+"^"+iASChargedFlag
				+"^"+iRoundingFeeMode
				; 
	var flag=tkMakeServerCall("web.DHCPE.ChargeLimit","OPChargeLimit",Instring);
	
    if (flag==0)
	{
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BClear_click();
		
	 }
	if (flag=="NoUser")
	{
		 $.messager.alert("提示","没有选定操作员","error");
		
	}
}

//删除
function BDelete_click()
{
	
	
	
	var UserId=$("#UserId").val()
	if(UserId==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	else{
		
		$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ChargeLimit", MethodName:"DeleteOPChargeLimit", UserId:UserId},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.alert("提示","删除成功","success");	
					BClear_click();
			        
				}
			});	
		}
	});
	}
	
}



//查询
function BFind_click()
{
   $("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:$("#OPName").combogrid('getValue')
			});

}

//清屏
function BClear_click()
{
	$("#RoundingFeeMode").combobox('setValue',"");
	$("#OPName").combogrid('setValue',"");
	$("#UserId,#DFLimit").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BAdd").linkbutton('enable');
	$("#OPName").combogrid('enable');

	$("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:""
			});
}

function InitCombobox()
{
	
	//操作员
	 	 var OPNameObj = $HUI.combogrid("#OPName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
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
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:190} 
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});

		
	//凑整费
	var RFMObj = $HUI.combobox("#RoundingFeeMode",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:'不允许'},
            {id:'1',text:'个人允许'},
            {id:'2',text:'团体允许'},
            {id:'3',text:'个人和团体均允许'}
        ]

		});
}


function InitOPChargeLimitDataGrid(){
		$HUI.datagrid("#OPChargeLimitQueryTab",{
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
			ClassName:"web.DHCPE.ChargeLimit",
			QueryName:"FindChargeLimit",
		    UserId:$("#OPName").combogrid('getValue'),
		},
		columns:[[
	
		    {field:'TUserId',title:'TUserId',hidden: true},
		    {field:'TRoundingFeeModeID',title:'TRoundingFeeModeID',hidden: true},
			{field:'TOPNumber',width:'200',title:'工号'},
			{field:'TName',width:'200',title:'操作员'},
			{field:'TDFLimit',width:'200',title:'允许最大折扣'},
			{field:'TOPFlag',width:'200',title:'优惠打折'},
			{field:'TASChargedFlag',width:'200',title:'取消/视同收费授权'},
			{field:'TRoundingFeeMode',width:'200',title:'凑整费'}			
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#UserId").val(rowData.TUserId);
				$("#OPName").combogrid('setValue',rowData.TName);
				$("#DFLimit").val(rowData.TDFLimit.split("%")[0]);
				$("#RoundingFeeMode").combobox('setValue',rowData.TRoundingFeeModeID);
				if(rowData.TOPFlag=="否"){
					$("#OPFlag").checkbox('setValue',false);
				}if(rowData.TOPFlag=="是"){
					$("#OPFlag").checkbox('setValue',true);
				}
				if(rowData.TASChargedFlag=="否"){
					$("#ASChargedFlag").checkbox('setValue',false);
				}if(rowData.TASChargedFlag=="是"){
					$("#ASChargedFlag").checkbox('setValue',true);
				}
				 $("#BAdd").linkbutton('disable');
			     $("#OPName").combogrid('disable');


		}
			
	})

		
}



function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}


//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}


