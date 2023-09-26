
//名称	DHCPEPreGBaseInfo.hisui.js
//功能	团体基本信息维护
//创建	2019.05.27
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitPreGBaseInfoDataGrid();  
     
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
    
   
    $("#PAPMINo").keydown(function(e) {
		if(e.keyCode==13){
			PAPMINoChange();
		}		
    }); 
    
     $("#CardNo").keydown(function(e) {
		if(e.keyCode==13){
			CardNo_Change();
		}		
    }); 
   
   
})

//输入编码 查找相应的信息
function PAPMINoChange() {
		
		var iPAPMINo=$("#PAPMINo").val();
		if(iPAPMINo==""){ return false; }
				
		iPAPMINo = RegNoMask(iPAPMINo);

		var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		if(flag=="I"){
			$.messager.popover({msg: "该人员属于个人,请在个人基本信息维护界面操作", type: "info"});
	
	    	return false;
		}
		if(flag=="N"){
			$.messager.popover({msg: "无此登记号对应的信息，不能新建", type: "info"});
	
	    	return false;
		}
		var iCardTypeID=$("#CardTypeRowID").val(); //卡类型
		
		var GCode=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGCodeByADM",iPAPMINo)
	
		if (GCode==""){
			var ID="^"+iPAPMINo+"^"+iCardTypeID; 
			var flag=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetHISInfo",'SetHISInfo_Sel','',ID)
			//alert(flag)
			var myCardType=""
			var myCardType=flag.split("^")[1]
			var myCardDesc=""
			myCardDesc=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",myCardType)
			myCardDesc=myCardDesc.split("^")[1]
			$("#CardTypeNew").val(myCardDesc)
			
			if (flag=='0') {return websys_cancel();}
			else if(flag==""){
				var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
				if ("FreeCreate"==Model) {}
				if ("FreeCreate"!=Model) {
					$.messager.alert('提示',"登记号不存在","info");
					Clear_click();
					}
		
				}
			websys_setfocus('Desc');
		}
		if (GCode!=""){
			$.messager.popover({msg: "该团体信息已存在,不能再新增", type: "info"})
			//var ID="^"+GCode; 
			//FindPatDetail(ID);
			}
			
	

}


function Clear_click()
{
	$("#Code,#Desc,#Address,#Postalcode,#Linkman1,#Bank,#Account,#Tel1,#Tel2,#Email,#Linkman2,#FAX,#PAPMINo,#Rebate,#CardNo").val("");
	
}

//清屏
function BClear_click()
{
	$("#GCode,#GLinkman,#GAddress,#ID").val("");
	$("#GName").combogrid('setValue',"");
	BFind_click();
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeRowID").val(myary[8]);
			PAPMINoChange();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeRowID").val(myary[8]);
			PAPMINoChange();
			event.keyCode=13;
			break;
		default:
	}
}


//读卡
function ReadCard_Click(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);	
}

function CardNo_Change()
{
	 var myCardNo=$("#CardNo").val();
	 if (myCardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
	return false;
}

//查询
function BFind_click()
{
	
    var GName=$("#GName").combogrid('getValue');
	if (($("#GName").combogrid('getValue')==undefined)||($("#GName").combogrid('getValue')=="")){var GName="";}
	var GName=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGDescByADM",GName);

	$("#PreGBaseInfoGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:GName,
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
	});	
}


function AddData()
{
	
	BCRequired();
	
	$("#PAPMINo").attr('disabled',false);
	$("#Code").attr('disabled',false);
		  		   		
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				iconCls:'icon-w-card',
				text:'读卡',
				id:'ReadCard',
				handler:function(){
					ReadCard_Click()
				}
			},{
				iconCls:'icon-w-save',
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				iconCls:'icon-w-close',
				text:'关闭',
				handler:function(){
					myWin.close();
				}
				
			}]
		});
		$('#form-save').form("clear");
		
	
}

SaveForm=function(id)
{
	 

	 var iPAPMINo=$("#PAPMINo").val();
	 if(iPAPMINo!=""){
		
	 	iPAPMINo = RegNoMask(iPAPMINo);
	 	
	 	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		 if(flag=="I"){
				$.messager.alert("提示","该人员属于个人,请在个人基本信息维护界面操作","info");
	    		return false;
			}
		 if(flag=="N"){
			    $.messager.popover({msg: "无此登记号对应的信息，不能新建", type: "info"});
	
	    	    return false;
		    }
	 }
     

	 var iCode=$("#Code").val();
	 var iDesc=$("#Desc").val();
	 if (""==iDesc) {
           	var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
			$.messager.alert('提示','团体名称不能为空!',"info");
		
		return false;

	}
	 var iAddress=$("#Address").val();
	 var iPostalcode=$("#Postalcode").val();
	if(!IsPostalcode(iPostalcode)){
		websys_setfocus(obj.id);
		return;
	}
	 var iLinkman1=$("#Linkman1").val();
	 if (""==iLinkman1) {
           	var valbox = $HUI.validatebox("#Linkman1", {
				required: true,
	   		});
			$.messager.alert('提示','联系人1不能为空!',"info");
		
		return false;

	}
	
	 var iLinkman2=$("#Linkman2").val();
	 var iBank=$("#Bank").val();
	 var iAccount=$("#Account").val();
	 var iTel1=$("#Tel1").val();
	 if (""==iTel1) {
           	var valbox = $HUI.validatebox("#Tel1", {
				required: true,
	   		});
			$.messager.alert('提示','联系电话1不能为空!',"info");
		
		return false;

	}
	
	if(!CheckTelOrMobile(iTel1,"Tel1","联系电话1")){	
		websys_setfocus(obj.id);
		return;
	}
	
	 var iTel2=$("#Tel2").val();
	 if(iTel2!=""){
		if(!CheckTelOrMobile(iTel2,"Tel2","联系电话2")){
		websys_setfocus(obj.id);
		return;
			}
		}
		
	 var iEmail=$("#Email").val();
	 if(!IsEMail(iEmail)){
			websys_setfocus(obj.id);
			return;
		}
		
	 var iFAX=$("#FAX").val();
	 
	
	 
	 var iRebate=$("#Rebate").val();
	 if((iRebate!="")&&((iRebate<=0)||(iRebate>=100))){
		   $.messager.alert('提示','输入的折扣率应大于0小于100',"info");
		  return false;
	 }

	  if(!IsFloat(iRebate)){
		  $.messager.alert('提示','输入的折扣率格式不正确',"info");
		  return false;
	  }

	 var iCardNo=$("#CardNo").val();

	var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
	if ("NoGen"==Model) {}

	if ("Gen"==Model) {
		// 登记号必须
		if (""==iPAPMINo) {
			$.messager.alert('提示','登记号不能为空!',"info");
			return false;
		} 
	}
	if ("FreeCreate"==Model)
	{
		if (""==iPAPMINo) {
			$.messager.alert('提示','登记号不能为空!',"info");
			return false;
		}
		if (isNaN(iPAPMINo)){
			$.messager.alert("提示","登记号不是数字","info");
			return false;
		}
	}
	
	var Instring= $.trim(id)			//			1
				+"^"+$.trim(iCode)		//单位编码	2
				+"^"+$.trim(iDesc)		//描    述	3
				+"^"+$.trim(iAddress)		//地    址	4
				+"^"+$.trim(iPostalcode)	//邮政编码	5
				+"^"+$.trim(iLinkman1)	//联系人	6
				+"^"+$.trim(iBank)		//业务银行	7
				+"^"+$.trim(iAccount)		//帐    号	8
				+"^"+$.trim(iTel1)		//联系电话1	9
				+"^"+$.trim(iTel2)		//联系电话2	10
				+"^"+$.trim(iEmail)		//电子邮件	11
				+"^"+$.trim(iLinkman2)		//联系人2	12
				+"^"+$.trim(iFAX)		//传真	13
				+"^"+$.trim(iPAPMINo)		//登记号	14
				+"^"+$.trim(iRebate)  //折扣率  15
				+"^"+$.trim(iCardNo)  //CardNo
				;
	
	var flag=tkMakeServerCall("web.DHCPE.PreGBaseInfo","Save",'','',Instring);
	var Data=flag.split("^");
		flag=Data[0];
	if (""==iCode) { //插入操作
		iRowId=Data[1];
		
	}
	if(flag==0){

		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$("#PreGBaseInfoGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:$("#GName").combogrid('getValue'),
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
		});	
			$('#myWin').dialog('close'); 
	    }else{
		    if('Err 01'==flag){
				$.messager.alert("操作提示","保存失败:编码已被使用,不能增加","error");
				return false;		
			}
			else if('Err 02'==flag){
				$.messager.alert("操作提示","保存失败:您所输入的编码已被使用,无法修改","error");
				return false;
			}else if('-119'==flag){
				$.messager.alert("操作提示","保存失败:该团体已经存在","error");
				return false;
			}else if('-120'==flag){
				$.messager.alert("操作提示","保存失败:团体名称和已有团体重复","error");
				return false;
			}else if('-119g'==flag){
				$.messager.alert("操作提示","保存失败:登记号对应的团体已存在，不能新建","error");
				return false;
			}
			else {
				$.messager.alert("操作提示","更新错误 错误号:"+flag,"error");
				return false;
			}
		    
	    }
}



	
function UpdateData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('提示',"请选择待修改的记录","info");
		return
	}

	   		
	if(ID!="")
	{	
	      	FindPatDetail(ID);
			
			var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
			if ("NoGen"==Model) {
				$("#Desc").focus();
		 		var iCode=$("#Code").val();
				if(iCode!=""){
					$("#PAPMINo").attr('disabled',true);
					$("#Code").attr('disabled',true);
				}
		
			}
			
			
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
				iconCls:'icon-w-card',
				text:'读卡',
				id:'ReadCard',
				handler:function(){
					ReadCard_Click()
				}
				},{
					iconCls:'icon-w-save',
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					iconCls:'icon-w-close',
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}


function FindPatDetail(ID){
	       
			var value=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetPreGBaseInfo",ID)
		  	var Data=value.split("^");
		  	
			var iLLoop=0;

			var iRowId=Data[iLLoop];	

			iLLoop=iLLoop+1
			//单位编码	
			$("#Code").val(Data[iLLoop])
		
			if ("0"==iRowId) {return false;}
			else{$("#ID").val(iRowId);}
		

			iLLoop=iLLoop+1;
			//描    述	
			$("#Desc").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//地    址	
			$("#Address").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//邮政编码
			$("#Postalcode").val(Data[iLLoop])	
		
			iLLoop=iLLoop+1;
			//联系人	
			$("#Linkman1").val(Data[iLLoop])	
			
			iLLoop=iLLoop+1;
			//业务银行	
			$("#Bank").val(Data[iLLoop])	
		
			iLLoop=iLLoop+1;
			//帐    号	
			$("#Account").val(Data[iLLoop])

			iLLoop=iLLoop+1;
			//联系电话1	
			$("#Tel1").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//联系电话2	
			$("#Tel2").val(Data[iLLoop])	

			iLLoop=iLLoop+1;
			//电子邮件	
			$("#Email").val(Data[iLLoop])
		
			iLLoop=iLLoop+1;
			//联系人	
			$("#Linkman2").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//传真 
			$("#FAX").val(Data[iLLoop])
				
			iLLoop=iLLoop+1;
			// 就诊号 
			$("#PAPMINo").val(Data[iLLoop])
			var PAPMINo=""
			var PAPMINo=Data[iLLoop]			 
			iLLoop=iLLoop+1;
			// 折扣率 
			$("#Rebate").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			$("#CardNo").val(Data[iLLoop])
		    iLLoop=iLLoop+1;
		
			
			var myCardDesc=""
			myCardDesc=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",PAPMINo)
			myCardDesc=myCardDesc.split("^")[1]
			$("#CardTypeNew").val(myCardDesc)
}

function SetHISInfo_Sel(value) {
	
	Clear_click();
	var Data=value.split("^");
	
	var iLLoop=0;

	iLLoop=iLLoop+1;
	$("#PAPMINo").val(Data[iLLoop]);
	
	iLLoop=iLLoop+1;
	$("#Desc").val(Data[iLLoop]);
	
	iLLoop=iLLoop+1;
	$("#CardNo").val(Data[iLLoop]);
	
}

//必填项标记取消
function BCRequired()
{
	var valbox = $HUI.validatebox("#Tel1,#Linkman1,#Desc", {
				required: false,
	   		});
	
}

function InitCombobox()
{
	
		
	//团体
	var GroupNameObj = $HUI.combogrid("#GName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode:'remote',
		delay:200,
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},

		columns:[[
			{field:'GBI_RowId',title:'团体ID',width:80},
			{field:'GBI_Desc',title:'团体名称',width:140},
			{field:'GBI_Code',title:'团体编码',width:100}			
			
		]]
		});
}

function InitPreGBaseInfoDataGrid()
{
	
	$HUI.datagrid("#PreGBaseInfoGrid",{
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
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:$("#GName").combogrid('getValue'),
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
		   
		},
		frozenColumns:[[
			{field:'PGBI_Code',width:'150',title:'团体编码'},
			{field:'PGBI_Desc',width:'200',title:'团体名称'},
			{field:'PGBI_PAPMINo',width:'100',title:'登记号'},
		]],
		columns:[[
		    {field:'PGBI_RowId',title:'ID',hidden: true},
			{field:'PGBI_Address',width:'250',title:'地址'},
			{field:'PGBI_Linkman',width:'150',title:'联系人1'},
			{field:'PGBI_Tel1',width:'150',title:'联系电话1'},
			{field:'PGBI_Linkman2',width:'150',title:'联系人2'},
			{field:'PGBI_Tel2',width:'150',title:'联系电话2'},
			{field:'PGBI_Email',width:'150',title:'电子邮件'},
			{field:'PGBI_Postalcode',width:'150',title:'邮政编码'},
			{field:'PGBI_Bank',width:'150',title:'业务银行'},
			{field:'PGBI_Account',width:'150',title:'账号'},		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.PGBI_RowId);
				
					
		}
		
			
	})

}

//电子邮箱 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
	 $.messager.alert("提示","电子邮箱格式不正确","info");
  return false;
 }
}
//电话号码(移动和座机电话)
/* 
用途：检查输入是否正确的电话和手机号 
输入： 
value：字符串 
返回： 
如果通过验证返回true,否则返回false 
*/  
function IsTel(telephone){ 

	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
	
		return true; 
	} 
}

//功能：核对手机号和电话是否正确
//参数：telephone:电话号码 Name:元素名称 Type:元素描述
function CheckTelOrMobile(telephone,Name,Type){
	
	if (telephone.length==8) return true;
	if (IsTel(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+": 固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+": 固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+": 联系电话电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+": 不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}




//邮政编码
function  IsPostalcode(elem){
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("提示","邮政编码格式不正确","info");
   //alert("邮政编码格式不正确");
  return false;
 }
}


function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}


//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
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

