///qqa

$(function(){
	initParam();
	
	initDateBox();
	
	initCombobox();
	
	initDatagrid();
	
	initMethod();
		
})
///获取参数
function initParam(){
	DateFormat="";   //后台时间配置
	UserDesc="";
	var params = UserId
	runClassMethod("web.DHCEmPatChkRList","GetParams",{Params:params},function (data){
		DateFormat = data.split("^")[0];
		UserDesc = data.split("^")[1];
		
	},'text',false)	
}

///初始化事件控件
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

///初始化下拉框
function initCombobox(){
	$HUI.combobox("#renterFlag",{
		data:[
			{"value":"1","text":"租"},
			{"value":"2","text":"还"}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    	if(option.value==="1"){
		    	clearReturnInfo();
		    }
	    }	
	})
	
	$HUI.combobox("#status",{
		data:[
			{"value":"1","text":"租"},
			{"value":"2","text":"还"}
		],
		valueField:'value',
		textField:'text'	
	})
	

	$HUI.combobox("#rentTool",{
		url:LINK_CSP+"?ClassName=web.DHCEmPatChkRList&MethodName=GetRentList&HospID="+HospID,
		valueField:'id',
		textField:'text',
		required:true,
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(){
			//selectFirstItm("#rentTool","id");    
		}	
	})
	
	$HUI.combobox("#cardType",{
		data:[{'id':'身份证','text':'身份证'},
	 	  {'id':'军官证','text':'军官证'},
	 	  {'id':'警官证','text':'警官证'},
	  	  {'id':'驾驶证','text':'驾驶证'},
	  	  {'id':'护照','text':'护照'}],
		valueField:'id',
		textField:'text',
	    onLoadSuccess:function(){
			selectFirstItm("#cardType","id");    
		}
	})
}

///初始化table
function initDatagrid(){
	var columns=[[{
               field: 'PCRDate',
               title: '租用日期'   
        	}, {
               field: 'PCRTime',
               title: '租用时间'
        	}, {
               field: 'PCROperator',
               title: '租用操作人'
        	}, 
        	{
               field: 'PCRRenter',
               title: '租用者姓名'
        	}, {
               field: 'PCRRenterTel',
               title: '联系方式'
        	}, {
               field: 'PCRCardType',
               title: '证件'  
        	}, {
               field: 'PCRCash',
               align: 'center',
               title: '现金'
           }, {
               field: 'PCRCashNo',
               title: '编号' 
        	}, {
               field: 'PCRRentDesc',  
               title: '租用工具'
        	}, {
               field: 'PCRGiveUser',
               title: '归还者姓名'
           }, {
                field: 'PCRGiveRelation',
                title: '关系'        
        	}, {
                field: 'PCRFlag',
                align: 'center',
                title: '状态'
        	},{
                field: 'PCRGiveDate',
                title: '归还日期'   
        	},{
                field: 'PCRGiveTime',
                title: '归还时间'
        	},{
				field: 'PCRGiveOpUser',
				title: '归还操作人'
        	},{
				field:'rentRowId',
				align:'center',
				title:'ID'
	        },{
				field:'PCRRentDr',
				align:'center',
				title:'RentId'
		    }]]
		    
	$HUI.datagrid('#rentTable',{
		url:LINK_CSP+'?ClassName=web.DHCEmPatChkRList&MethodName=JsonListSearchRent',  //JsonListSearchRent
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		bodyCls:'panel-header-gray',//hxy 2018-10-25
		//border:false,//hxy 2018-10-22
		queryParams:{
			 StartDate:$HUI.datebox("#startDate").getValue()+"^"+$HUI.timespinner('#startTime').getValue(), //开始时间
             EndDate:$HUI.datebox("#endDate").getValue()+"^"+$HUI.timespinner('#endTime').getValue(),  //截止时间
             Renter:$("#patName").val(),    //租赁者姓名
             RentStatus:($HUI.combobox("#status").getValue()==undefined?"":$HUI.combobox("#status").getValue()),
             Hosp:HospID
		}
	});
		    
	
}

///绑定方法
function initMethod(){
	$("#searchBtn").on("click",search);
	
	$("#insert").on("click",function(){op("A")});
	
	$("#update").on("click",function(){op("U")});
	
	$("#returnTool").on("click",function(){op("R")});
	
	$("#save").on("click",save);
}


function search(){
	$HUI.datagrid('#rentTable').load({
		StartDate:$HUI.datebox("#startDate").getValue()+"^"+$HUI.timespinner('#startTime').getValue(), //开始时间
		EndDate:$HUI.datebox("#endDate").getValue()+"^"+$HUI.timespinner('#endTime').getValue(),  //截止时间
		Renter:$("#patName").val(),    //租赁者姓名
		RentStatus:($HUI.combobox("#status").getValue()==undefined?"":$HUI.combobox("#status").getValue()),
		Hosp:HospID
	})
}

function insert(){
	$("#nurse").val(UserDesc);
	$HUI.datebox("#rentDate").setValue(formatDate(0));
	$HUI.timespinner('#rentTime').setValue(curTime());
}

///Model:U为修改  R:归还 A:添加
function op(model){
	var rowData ="";
	
	if(model!=="A"){	
		var datas = $HUI.datagrid("#rentTable").getSelections();
		if(!datas.length){
			$.messager.alert("提示","未选择数据！");	
			return;
		}
		rowData=datas[0];
	}
	
	clearForm();   //清除面板不可编辑状态
	clearFormData();   //清除面板数据
	$HUI.window("#widow").open();  //打开面板
	///设置面板title
	if(model=="R"){
		$("#windowTitle").html("归还");
	}else if (model=="A"){
		$("#windowTitle").html("租借");
	}else if(model=="U"){
		$("#windowTitle").html("修改");
	}
	
	///设置面板中元素编辑状态
	if(model=="R"){
		setFormDisable("R");
	}else if (model=="A"){
		setFormDisable("A");
	}else if (model=="U"){
		setFormDisable("U");	
	}
	
	//面板加载数据
	if(rowData!="") load(rowData);
	
	//设置面板数据
	if(model=="R"){
		setFormData("R");
	}else if (model=="A"){
		setFormData("A");
	}
	
	
}

function setFormDisable(model){
	
	if(model==="A"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		$("#giveRelation").attr("disabled","disabled");
		$("#giveUser").attr("disabled","disabled");
		$HUI.datebox("#giveDate",{disabled:true});
		$HUI.timespinner('#giveTime',{disabled:true});
		$HUI.combobox("#renterFlag",{disabled:true});
	}
	
	if(model==="R"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		$("#renterTel").attr("disabled","disabled");
		$("#cardType").attr("disabled","disabled");
		$("#cash").attr("disabled","disabled");
		$("#cashNo").attr("disabled","disabled");
		$HUI.combobox("#cardType",{disabled:true});
		$HUI.combobox("#rentTool",{disabled:true});
		$HUI.combobox("#renterFlag",{disabled:true});
		$("#renter").attr("disabled","disabled");
		
	}
	
	if(model==="U"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		//$HUI.combobox("#renterFlag",{disabled:true});
	}
}

function setFormData(model){
	if(model==="R"){
		$("#giveNurse").val(UserDesc);
		$HUI.datebox("#giveDate").setValue(formatDate(0));
		$HUI.timespinner('#giveTime').setValue(curTime());
		$HUI.combobox("#renterFlag").setValue("2");
	}
	
	if(model==="A"){
		$("#nurse").val(UserDesc);
		$HUI.datebox("#rentDate").setValue(formatDate(0));
		$HUI.timespinner('#rentTime').setValue(curTime());
		$HUI.combobox("#renterFlag").setValue("1");
		selectFirstItm("#cardType","id");
	}
}

function save(){
	var rentid=$("#rentRowId").val();
	var Date=$HUI.datebox("#rentDate").getValue();          //租用日期
	var Time=$HUI.timespinner('#rentTime').getValue();      //租用时间  
	var renter=$("#renter").val();  	    			    //租用者姓名 
	var GiveDate=$HUI.datebox("#giveDate").getValue();      //归还日期
	var GiveTime=$HUI.timespinner('#giveTime').getValue();  //归还时间   	
	var GiveopUser=$("#giveNurse").val(); 				    //归还操作人 
    if(renter==""){
   		$.messager.alert("提示","租用者姓名不能为空");
   		return;
	}
    var renterTel=$("#renterTel").val();                    //联系方式 
    var cardType=($HUI.combobox("#cardType").getValue()==undefined?"":$HUI.combobox("#cardType").getValue());
    var cash=$("#cash").val();                              //现金 
    var cashNo=$("#cashNo").val();                          //现金编号 
    var rentTool=($HUI.combobox("#rentTool").getValue()==undefined?"":$HUI.combobox("#rentTool").getValue());
	if((rentTool==null)||(rentTool=="")){
	   $.messager.alert("提示","租用工具不能为空");
	   return;
	}
    var nurse=$("#nurse").val();          				//租用操作人
    var giverUser=$("#giveUser").val();   				//归还者姓名
    var giveRelation=$("#giveRelation").val();  		//关系
    
    if((renter!=giverUser)&&(giveRelation=="")&&(giverUser!="")&&(rentflag=="还")){
         $.messager.alert("提示","关系不能为空");
         return;
    }
  
    var renterFlag=($HUI.combobox("#renterFlag").getValue()==undefined?"":$HUI.combobox("#renterFlag").getValue());  //状态
  
    var RentList=rentTool+"^"+renterFlag+"^"+Date+"^"+Time+"^"+nurse+"^"+renter+"^"+renterTel+"^"+cardType+"^"+cash;
    RentList = RentList+"^"+cashNo+"^"+giverUser+"^"+giveRelation+"^"+rentid+"^"+GiveDate+"^"+GiveTime+"^"+GiveopUser;
    RentList = RentList+"^"+HospID;
    //保存出租物品信息
    runClassMethod("web.DHCEmPatChkRList","saveRentList",{"RentList":RentList},function(jsonString){ 
		var ret = jsonString;
		if(ret==0){	    
			$.messager.alert("提示","保存成功");
			$HUI.window("#widow").close();
	     	search(); 
		}else{
			if(ret==-100){
				$.messager.alert("提示","归还时间不能早于租借时间！");
			}else{
				$.messager.alert("提示","保存失败");
			}
		}
	});   
	    
}


function selectFirstItm(name,field){
	var Datas = $HUI.combobox(name).getData();
	$HUI.combobox(name).select(Datas[0][field])
	return;
}


function clearForm(){
	$("#giveRelation").removeAttr("disabled");
	$("#giveUser").removeAttr("disabled");
	$HUI.datebox("#giveDate",{disabled:false});
	$HUI.timespinner('#giveTime',{disabled:false});
	$HUI.datebox("#rentDate",{disabled:false});
	$HUI.timespinner('#rentTime',{disabled:false});
	$("#renterTel").removeAttr("disabled");
	$("#cardType").removeAttr("disabled");
	$("#cash").removeAttr("disabled");
	$("#cashNo").removeAttr("disabled");
	$HUI.combobox("#cardType",{disabled:false});
	$HUI.combobox("#rentTool",{disabled:false});
	$("#renter").removeAttr("disabled");
	$HUI.combobox("#renterFlag",{disabled:false});

}

//清空所有数据
function clearFormData(){
	$("#renter").val("");
	$("#renterTel").val("");
	$HUI.combobox("#cardType").setValue("");
	$("#cash").val("");
	$("#cashNo").val("");
	$HUI.combobox("#rentTool").setValue("");
	$("#nurse").val("");
	$("#giveUser").val("");
	$("#giveRelation").val("");
	$HUI.combobox("#renterFlag").setValue("");
	$("#rentRowId").val("");
	$HUI.datebox("#rentDate").setValue("");
	$HUI.timespinner('#rentTime').setValue("");
	$HUI.datebox("#giveDate").setValue("");
	$HUI.timespinner('#giveTime').setValue("");
	$("#giveNurse").val("");	
	
	$(".hisui-validatebox").each(function(){
		$(this).validatebox("isValid");
	})
	return;
}

//清空归还人信息
function clearReturnInfo(){
	$HUI.datebox("#giveDate").setValue("");
	$HUI.timespinner('#giveTime').setValue("");
	$("#giveNurse").val("");
	$("#giveUser").val("");
	$("#giveRelation").val("");
}

//更新数据
function load(row){      	
	$("#renter").val(row.PCRRenter);
	$("#renterTel").val(row.PCRRenterTel);
	$HUI.combobox("#cardType").setValue(row.PCRCardType);
	$("#cash").val(row.PCRCash);
	$("#cashNo").val(row.PCRCashNo);
	$HUI.combobox("#rentTool").setValue(row.PCRRentDr);
	$("#nurse").val(row.PCROperator);
	$("#giveUser").val(row.PCRGiveUser);
	$("#giveRelation").val(row.PCRGiveRelation);
	if(row.PCRFlag=="租") row.PCRFlag=1;
	if(row.PCRFlag=="还") row.PCRFlag=2;
	$HUI.combobox("#renterFlag").setValue(row.PCRFlag);
	$("#rentRowId").val(row.rentRowId);
	$HUI.datebox("#rentDate").setValue(row.PCRDate);
	$HUI.timespinner('#rentTime').setValue(row.PCRTime);
	$HUI.datebox("#giveDate").setValue(row.PCRGiveDate);
	$HUI.timespinner('#giveTime').setValue(row.PCRGiveTime);
	$("#giveNurse").val(row.PCRGiveOpUser);
	
	$("#renter").validatebox('isValid')
	return;
}