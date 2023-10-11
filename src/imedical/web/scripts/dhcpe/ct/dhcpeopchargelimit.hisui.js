
//名称	dhcpe/ct/dhcpeopchargelimit.hisui.js
//功能	体检打折权限维护-多院区	
//创建	2021.08.16
//创建人  sxt
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_ChargeLimit";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	GetLocComp(SessionStr)
	
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
    
    $("#LocList").combobox({
	     onSelect:function(data){
		    	
		    	var LocID=$("#LocList").combobox('getValue');
		   		if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
		   		var hospId=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		   		   
			    /*****************用户重新加载(combobox)*****************/
			    //$('#OPName').combogrid('grid').datagrid('reload'); //重加载
			    $HUI.combogrid("#OPName",{
					onBeforeLoad:function(param){
							param.Desc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId=hospId;

					}
		       });
		    
	           $('#OPName').combogrid('grid').datagrid('reload'); 
			   /*****************用户重新加载(combobox)*****************/
		   		
		   		$("#OPChargeLimitQueryTab").datagrid('load',{
			   		ClassName:"web.DHCPE.CT.ChargeLimit",
					QueryName:"FindChargeLimit",
				    UserId:$("#OPName").combogrid('getValue'),
				    LocID:LocID
				});

		
		    
		 }
     })


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
		var iUser=$("#OPName").combogrid('getValue');
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
		if((iDFLimit!="")&&(iDFLimit>0)){ 
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
	
	var iASChargedFlag="0";
	//var iASChargedFlag=$("#AsChargMode").combobox('getValue');
	//if(iASChargedFlag=="") iASChargedFlag=0;
	
	var iRoundingFee="0"
    var iRoundingFee=$("#RoundingFeeMode").combobox('getValue');
    
    /// 表rowid
    var ChargeLimitID=$("#ChargeLimitID").val();
  
  	var iActive="N";
	if($("#Active").checkbox('getValue')) iActive="Y";
	
	var iASCharged="N";
	if($("#ASChargedFlag").checkbox('getValue')) iASCharged="Y";
  
	 //定额卡支付
    var iSetASCharged="N";
	var SetASCharged=$("#SetASCharged").checkbox('getValue');
	if(SetASCharged) iSetASCharged="Y";

	 //全退申请
    var iALLRefund="N";
	var ALLRefund=$("#ALLRefund").checkbox('getValue');
	if(ALLRefund) iALLRefund="Y";

	var Instring=trim(iUser)	
				+"^"+trim(iDFLimit)
				+"^"+iOPFlag
				+"^"+iASCharged
				+"^"+iASChargedFlag
				+"^"+iRoundingFee
				+"^"+iSetASCharged
				+"^"+iALLRefund
				; 
	var flag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","OPChargeLimit",Instring,ChargeLimitID,$("#LocList").combobox("getValue"),session['LOGON.USERID'],iActive);
    if (flag.split("^")[0]<0)
	{
		 $.messager.alert("提示",flag.split("^")[1],"error");
			
	}
	else
	{
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
		BClear_click();
		
	}
}

//删除
function BDelete_click()
{
	
	var UserId=session['LOGON.USERID'];
	
    var ChargeLimitID=$("#ChargeLimitID").val();
    
	if(ChargeLimitID==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	else{
		
		$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			var ID
			$.m({ ClassName:"web.DHCPE.CT.ChargeLimit", MethodName:"DeleteOPChargeLimit", ID:ChargeLimitID,UserId:UserId},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
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
	
	var LocID=$("#LocList").combobox('getValue');
    if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
    
   $("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.CT.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:$("#OPName").combogrid('getValue'),
				LocID:LocID
			});

}

//清屏
function BClear_click()
{
	$("#ChargeLimitID").val("");
	$("#RoundingFeeMode").combobox('setValue',"");
	$("#OPName").combogrid('setValue',"");
	$("#UserId,#DFLimit").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BAdd").linkbutton('enable');
	$("#OPName").combogrid('enable');
	//$("#AsChargMode").combobox('setValue',"");
	
	$("#OPChargeLimitQueryTab").datagrid('load',{
				ClassName:"web.DHCPE.CT.ChargeLimit",
				QueryName:"FindChargeLimit",
				UserId:"",
				LocID:$("#LocList").combobox('getValue'),
			});
}

function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	//操作员
	 var OPNameObj = $HUI.combogrid("#OPName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
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
			param.LocID=LocID;
			param.hospId=hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:190} 
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
			
		}

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
		
	/*	
	// 视同收费
	var RFMObj = $HUI.combobox("#AsChargMode",{
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
		*/
}


function InitOPChargeLimitDataGrid(){
	
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
		
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
			ClassName:"web.DHCPE.CT.ChargeLimit",
			QueryName:"FindChargeLimit",
		    UserId:$("#OPName").combogrid('getValue'),
		    LocID:LocID
		},
		columns:[[
			
		    {field:'TUserId',title:'TUserId',hidden: true},
		    {field:'TRoundingFeeModeID',title:'TRoundingFeeModeID',hidden: true},
			{field:'TOPNumber',width:120,title:'工号'},
			{field:'TName',width:170,title:'操作员'},
			{field:'TDFLimit',width:120,title:'允许最大折扣'},
			{field:'TOPFlag',width:100,title:'优惠打折',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
			},
			{field:'CLOPChargeLimit',hidden:true},
			{field:'TAscharge',width:150,title:'取消/视同收费授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
			},
			{field:'CLOPChargeLimitDesc',title:'视同收费模式',hidden: true},
			{field:'CLRoundingFee',hidden:true},
			{field:'CLRoundingFeeDesc',width:180,title:'凑整费'},
			{field:'CLNoActive',width:90,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  },
		  {field:'CLSetASCharged',width:90,title:'定额卡支付',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  },
		  {field:'CLALLRefund',width:90,title:'全退申请',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                },
		  }						
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#UserId").val(rowData.TUserId);
				$("#OPName").combogrid('setValue',rowData.TName);
				$("#DFLimit").val(rowData.TDFLimit.split("%")[0]);
				$("#RoundingFeeMode").combobox('setValue',rowData.CLRoundingFee);
				if(rowData.TOPFlag=="否"){
					$("#OPFlag").checkbox('setValue',false);
				}if(rowData.TOPFlag=="是"){
					$("#OPFlag").checkbox('setValue',true);
				}
				
				if(rowData.TAscharge=="否"){
					$("#ASChargedFlag").checkbox('setValue',false);
				}if(rowData.TAscharge=="是"){
					$("#ASChargedFlag").checkbox('setValue',true);
				}
				
				$("#ChargeLimitID").val(rowData.ID)
				//$("#AsChargMode").combobox('setValue',rowData.CLOPChargeLimit);
				
				if(rowData.CLNoActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.CLNoActive=="是"){
					$("#Active").checkbox('setValue',true);
				}
				
				if(rowData.CLSetASCharged=="Y"){
					$("#SetASCharged").checkbox('setValue',true);
				}else{
					$("#SetASCharged").checkbox('setValue',false);
				}
				
				if(rowData.CLALLRefund=="Y"){
					$("#ALLRefund").checkbox('setValue',true);
				}else{
					$("#ALLRefund").checkbox('setValue',false);
				}

				$("#OPName").combogrid("grid").datagrid("reload",{"q":rowData.TName});
				
				$("#OPName").combogrid('setValue',rowData.TUserId);
				
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


