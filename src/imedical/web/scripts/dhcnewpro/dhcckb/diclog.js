///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/18
//*	Description:	临床知识库（日志实现）
///****************************************
var DicName=""         //字典名称
var dataName=""        //记录名
var Operator=""        //操作人
var OperateDate=""     //操作日期
var OperateTime=""     //操作时间
var Scope=""           //作用域
var ScopeValue=""      //作用域值
var SetFlag=""         //标记 区分停用/标记
var HideFlag = ""	   //  隐藏按钮标志
var ClientIPAddress = ""
var type = ""
var CloseFlag="";	   //关闭窗口标识 sufna 2020-03-27 其他接麦你调用时不需要掉关闭和父界面方法
var TableName="";      //Sunhuiyong 20201110   表名   弃用
/// 页面初始化函数
$(function(){
	InitCombobox(); //初始化Combobox
	InitTime();     //初始化时间框
	InitGetData();  //初始化入参信息  字典名称/记录名/操作人
	InitTable();
	//alert(ClientIPAddress);

})

/// 初始化加载入参信息 /字典名称/记录名/操作人
function InitGetData(){
	DicName = getParam("DicName");				//
	dataid = getParam("dataid");				//记录id
	SetFlag = getParam("SetFlag");				//
	Operator = getParam("Operator");			//操作人
	HideFlag = getParam("HideFlag");			//隐藏按钮1，隐藏，0，不隐藏
	ClientIPAddress = getParam("ClientIP");		//ip
	CloseFlag = getParam("CloseFlag");			//窗口关闭标识 sufan 2020-03-27
	TableName = getParam("TableName");          //表名
	type=getParam("type");          
	if (HideFlag==1){
		HideButton();
	}
	$("#dicid").val(DicName);
	$("#dataid").val(dataid);
	$("#operator").val(Operator);
	$('#dicname').attr('disabled',true);  //设置输入框为禁用
	$('#dataname').attr('disabled',true); //设置输入框为禁用
	$('#operator').attr('disabled',true); //设置输入框为禁用
	//$HUI.validatebox("#dicname").isValid()
	//$HUI.validatebox("#dataname").isValid()
	//$HUI.validatebox("#operator").isValid()
	OperateDate=$("#operatedate").datebox('getValue');
	OperateTime=$("#operatetime").timespinner('getValue');
}

/// 根据父窗口调用的标志，隐藏按钮
function HideButton(){
	$("#SaveParrefData").hide();	
	$("#CloseWindow").hide();

}
//初始化Combobox
function InitCombobox()
{      
	var scopeurl = 'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeData'
	if ("undefined"!==typeof websys_getMWToken){
		scopeurl += "&MWToken="+websys_getMWToken(); 
	}
	//初始化作用域
	$('#scope').combobox({
		url:scopeurl,
	    valueField: 'id',//绑定字段ID
	    textField: 'text',//绑定字段Name
	    onLoadSuccess:function(){
		    $('#scope').combobox('setValue',"G");		//默认安全组类型sufan 20200314
		    Scope = "G";
		    var valueurl = 'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeValueDate&type=G'
		    if ("undefined"!==typeof websys_getMWToken){
				valueurl += "&MWToken="+websys_getMWToken(); 
			}
		    $("#scopevalue").combobox( { 
				 url:valueurl,
				 valueField: 'id',//绑定字段ID
	    		 textField: 'text',//绑定字段Name
	    		 onLoadSuccess:function(){
		    		 if($("#scope").combobox('getValue')=="G"){
			    		 $('#scopevalue').combobox('setValue',LgGroupID);	
			    		  ScopeValue = LgGroupID;
			    	 }
		    	 }
			})
	   },onSelect: function (option) {
		   	Scope = option.id;
			var varSelect = Scope;
			//获取选中的值
			//var varSelect = $(this).combobox('getValue');								
			SAtypeID=varSelect;
			//$("#scopevalue").combobox('clear');//清空类型值
			$("#scopevalue").combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeValueDate&type='+SAtypeID+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"")
		})
		//Scope=$("#scope").combobox('getValue');
	}
})

//初始化作用域值
$('#scopevalue').combobox( {
    valueField: 'id',//绑定字段ID
    textField: 'text',//绑定字段Name
    onSelect: function (option) {
    	//ScopeValue=$("#scopevalue").combobox('getValue');
    	ScopeValue = option.id;
    }
   
})
}
function InitTable(){
	
	// 定义columns   
	var columns=[[   	 
			{field:'ID',title:'ID',width:200,align:'left',hidden:'true'},
			{field:'DataID',title:'名称',width:200,align:'left',hidden:'true'},
			{field:'Function',title:'功能',width:400,align:'left',formatter: function(value,row,index){
				if (value=="stop")
				{
					return "停用";
					
				} else if(value=="confirm")
				{
					return "核实";	
				}else if(value=="grantAuth")
				{
					return "医院授权";
						
				}else if(value=="businessAuth")
				{
					return "业务授权";
						
				}else if(value=="enable")
				{
					return "复用";	
				}else 
				{
					return value;	
				}
			}},
			{field:'DateTime',title:'日期',width:300,align:'left'},
			{field:'TimeTime',title:'时间',width:300,align:'left'},
			{field:'Scope',title:'作用域',width:300,align:'left',formatter: function(value,row,index){
				if (value=="U"){
					return "人员";
				} else if(value=="G")
				{
					return "安全组";
					
				}else if(value=="L")
				{
					return "科室"	
				}else if(value=="P")
				{
					return "职称"	
				}else
				{
					return "全院"	
				}
			}
		},
			{field:'ScopeValue',title:'作用域值',width:300,align:'left'},
			{field:'UserID',title:"操作人",width:200,align:'left',hidden:true},
			{field:'UserName',title:"操作人",width:200,align:'left'},
			{field:'Operating',title:'操作',width:200,align:'center',formatter:SetCellOperation} 	
		 ]]

	var option={
		bodyCls:'panel-header-gray',
		border:true,	
		height:"315",
		fit:false,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:10,
		pageList:[10,20,30],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            
        },
        onLoadSuccess:function(data){
           
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=GetStopDataList&DataID="+dataid+"&table="+DicName+"&FunctionInfo="+SetFlag;
	new ListComponent('stopdatainfo', columns, uniturl, option).Init();

}
//初始化时间框
function InitTime()
{	
	$("#operatedate").datebox("setValue",SetDateTime("date"));
	$("#operatetime").timespinner("setValue",SetDateTime("time"));
}
function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// 获取参数
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}
function SaveDatas(){
	if(!Stable()){
		return;
	}   //过滤条件；
	if(console.log(dataid.search("^") == -1)){
			SaveData(); 
		}else{
			SaveManyDatas();
		}
	
}
//保存多条数据
function SaveManyDatas()
{
	if(!Stable()){
		return false;
	}   
	var Result=""
	runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":Operator,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress,"Type":"acc"},function(getString){
	    if (getString == 0){
			Result = "操作成功！";
		}else
		{
			Result = "操作失败！";	
		}
	},'text',false);
	
	window.parent.$.messager.popover({msg: Result,type:'success',timeout: 1000});	
	
	if(CloseFlag==""){
		window.close();	
		window.opener.reloadDatagrid();

	}
	return Result;
		
}
function SaveData(){
	if(!Stable()){
		return;
	}               //过滤条件；
	var Result=""
	var Type="acc";
	runClassMethod("web.DHCCKBWriteLog","InsertLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":Operator,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress,"Type":Type},function(getString){
		if (getString == 0){
			Result = "操作成功！";
		}else
		{
			Result = "操作失败！";	
		}
	},'text',false);
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	window.close();
	window.opener.reloadDatagrid();
}

function Stable()
{
	var ScopeValueOther=$("#scopevalue").combobox('getValue');
	if((ScopeValueOther=="")||(ScopeValueOther==undefined))
	{
		$.messager.alert('提示','请选择作用域值后操作！',"info");	
		return false;
	}
	var ScopeOther=$("#scope").combobox('getValue');
	if((ScopeOther=="")||(ScopeOther==undefined))
	{
		$.messager.alert('提示','请选择作用域后操作！',"info")	;
		return false;
	}
	return true;
}
function CloseWindow()
{
	window.close();
}

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){	
	var btn = "";
	if ((rowData.Function == "businessAuth")||(rowData.Function == "grantAuth")){
			var btn = "<a  class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' title='取消授权' onclick=\"DeleteGrantAuth('"+rowData.ID+"')\" style='border:0px;cursor:pointer'></a>" 
	}
	return btn;  
}


// 取消授权
function DeleteGrantAuth(logID)
{
	$.messager.confirm("提示", "您确定要取消授权吗？", function (res) {	// 提示是否删除
		
		if (res){
			runClassMethod("web.DHCCKBWriteLog","DeleteGrantAuth",{"logID":logID},function(getString){
				if (getString == 0){
					Result = "操作成功！";
					$('#stopdatainfo').datagrid('reload'); //重新加载
				}else
				{
					Result = "操作失败！";	
				}
			},'text',false);
			$.messager.popover({msg: Result,type:'success',timeout: 1000});		
		}else{
			return;	
		}
		
	});

}
	
