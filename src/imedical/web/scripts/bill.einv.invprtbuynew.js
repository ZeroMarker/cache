$(function(){
	setPageLayout();
	setElementEvent();	
});

function setElementEvent(){
	initStartno()	  	//开始号码赋值
	initNumber()	  	//结束号码赋值
	initCombobox()    	//获取下拉框信息
	initSearsh()		//根据页面返回参数查询电子发票信息
	initAdd()			//添加数据
	clearDialog()		//清除内容
	loadInvConfig()		//重新加载数据
	initDelete()		//删除数据
	initImport()		//导入发票发放信息
}
//开始号码赋值
function initStartno(){
	$("#Startno").blur(function(){
		var Startno = $.trim($('#Startno').val());
		if(Startno != ""){
			$('#Startno').val((Array(8).join("0") + (parseInt(Startno))).slice(-8)); 
		}
	});
}
//结束号码赋值
function initNumber(){
	$("#number").keyup(function(){
		var Startno = parseInt($.trim($('#Startno').val()));
		var number = parseInt($.trim($('#number').val()));
		var ednnn=number+Startno-1;
		if(Startno != ""){
			if(number != ""){
				ednnn=(Array(8).join(0) + ednnn).slice(-8);
				$('#endno').val(ednnn); 
			}
		}
	})
}
//获取下拉框信息
function initCombobox(){
	$HUI.combobox("#buyer",{
		valueField:'rowid',
		textField:'usrname',
		panelHeight:"auto",
		url:$URL,
		//editable:false,
    	//method:"GET",
		onBeforeLoad:function(param){
			param.ClassName="web.UDHCJFReceipt";
	    	param.QueryName="FindUser";
	   		param.ResultSetType="array";
	   		param.grp="A";  
	   		param.type="1";
	 		param.UserID="";
	 		param.username="";  
		}
	});
	//获取电子票据类型	
	$HUI.combobox("#type",{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array"
	 		param.Type="LogicIUDType"          
	    },
	    onLoadSuccess:function(){
		    //var ty = $('#type').combobox('getValue')
		   // if(ty==""){
		    $('#type').combobox('setValue','EO')
		   // }
	    },
	    onChange:function(){
		    var type = $('#type').combobox('getValue');
		    $cm({
						ClassName:"BILL.EINV.BL.COM.InvPrtBuyCtl",
						MethodName:"invprtgetStartNo",
						type:type,
						HospDr:HOSPID
				},function(value){
						if(value == ""){
							return "";
						}else{
							$('#Startno').val((Array(8).join("0") + (parseInt(value))).slice(-8));
						}
					});
		  	}  
	});
}	
//根据页面返回参数查询电子发票信息
function initSearsh(){
	$('#search').click(function(){
		var type = $('#type').combobox('getValue');
		var stdate = $('#stdate').datebox('getValue');
		var endate = $('#endate').datebox('getValue');
		var buyer = $('#buyer').datebox('getText');
		$('#invbuy').datagrid('load',{
			ClassName:'web.UDHCJFInvprt',
			QueryName:'InvprtBuyList',
			type:type,
			stdate:stdate,
			enddate:endate,
			buyer:buyer
		});	
		clearDialog()
	});
}
function initAdd(){
	$('#add').click(function(){
		var buyer = $('#buyer').combobox('getValue');
		var type = $('#type').combobox('getValue');
		if (buyer==""){
			alert('购入人员不能为空')
		}else if(type==""){
			alert("发票类型不能为空")
		}
		else{
			var Startno=$("#Startno").val();
			var endno=$("#endno").val();
			var Title=$("#Title").val();
			var useflag=""
			if((Startno=="")||(endno=="")){
				alert("开始号码或结束号码不能为空")
			}else{
				var userid=$("#buyer").combobox('getValue');
				var str = "^^" + type + "^" + buyer + "^^" + Startno + "^" + endno + "^^" + userid + "^^" + useflag + "^" + Title;
				if(confirm("您确认要购入从"+Startno+"到"+endno+"的发票吗？")){
					$cm({
						ClassName:"web.UDHCJFInvprt",
						MethodName:"dhcamtmaginsert",
						str:str,
						HospDr:HOSPID
					},function(value){
						if(value == 0){
							loadInvConfig();
							clearDialog()
							alert("购入成功");
							
						}else{
							alert("购入失败")
							return;
							}
					});
				}
			}
		}
	});
}
//清除内容
function clearDialog(){
	$('#Startno').val("");
	$('#Title').val("");
	$('#number').val("");
	$('#endno').val("");
	var type = $('#type').combobox('getValue');
	$('#type').combobox('setValue',type);
	$('#buyer').combobox('setValue','10207');	
}
//重新加载数据
function loadInvConfig(){
	var type = $('#type').combobox('getValue');
	var stdate = $('#stdate').datebox('getValue');
	var endate = $('#endate').datebox('getValue');
	var buyer = $('#buyer').datebox('getText');
	$('#invbuy').datagrid('load',{
			ClassName:"web.UDHCJFInvprt",
			QueryName:"InvprtBuyList",
			type:type,
			stdate:stdate,
			enddate:endate,
			buyer:buyer
		});
}	
//删除数据
function initDelete(){
	$('#delete').click(function(){
		var selectedRow = $('#invbuy').datagrid('getSelected');
		if(!selectedRow){
		$.messager.alert('消息','请选择需要删除的行');
		return;
		}
		$.messager.confirm('消息','您确定要删除该条记录吗?',function(r){
			if(!r){
				return;
			}else{
				var ID = selectedRow.TRowid;
				$m({
					ClassName:"web.UDHCJFInvprt",
					MethodName:"getdelete",
					rowid:ID
					},function(value){
						if(value.length != 0){
							if(value==0){
								$.messager.alert('消息','删除成功')	
							}
							if(value==-2){
								$.messager.alert('消息','当前号码与开始号码不一致')	
							}
							loadInvConfig();
							clearDialog()
						}else{
							$.messager.alert('消息','服务器错误')
							}
					});	
				}	
		});
		
	});
}
//导入发票发放信息
function initImport(){
	$('#import').click(function(){
	var UserDr=USERID;
	var GlobalDataFlg="0";                          	 //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
	var ClassName="BILL.EINV.BL.COM.InvPrtBuyCtl";    //导入处理类名
	var MethodName="ImportAmtmagByExcel";          //导入处理方法名
	var ExtStrPam="";                   			     //备用参数()
	ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);	
	});	
}
function setPageLayout(){	
	//获取结束日期
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//获取开始日期
	var StDate = (new Date().getFullYear()-1) + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#stdate').datebox('setValue', StDate);
	//设置结束日期值
	$('#endate').datebox('setValue', EdDate);
	$('#invbuy').datagrid({
		fit:true, 
		pagination:true,  
    	url:$URL, 
    	columns:[[    
        	{field:'TRowid',title:'TRowid',width:120},    
        	{field:'TDate',title:'日期',width:120},    
        	{field:'TStartno',title:'开始号码',width:120},
        	{field:'TEndno',title:'结束号码',width:120},    
        	{field:'TBuyer',title:'购入人',width:120},    
        	{field:'TCurrentno',title:'当前可用号码',width:120}, 
        	{field:'TFlag',title:'可用标记',width:120},    
        	{field:'TType',title:'发票类型',width:120},    
        	{field:'Ttitle',title:'开始字母',width:120},    
        	{field:'Tjob',title:'Tjob',width:200}
    	]]    
	}); 
	
}

