
//名称  DHCPECardAmountMove.hisui.js
//功能	卡金额转移
//创建	2019.04.20
//创建人  xy

$(function(){
	 
	InitCombobox();
	
	//转移
	$("#BMove").click(function() {	
		BMove_click();		
        });
    
    //清屏
    $("#BClear").click(function() {	
		BClear_click();		
        });
        
     $("#SourceNo").keydown(function(e) {
			if(e.keyCode==13){
		    	No_keydown("Source")
			}
			
        }); 
        
     $("#ToNo").keydown(function(e) {
			if(e.keyCode==13){
				No_keydown("To");
			}
			
        }); 
   
     $("#ToNo2").keydown(function(e) {
			if(e.keyCode==13){
				ToNo2_keydown();
			}
			
        });
      
	 $("#MoveAmount").keydown(function(e) {
			if(e.keyCode==13){
				MoveAmount_keydown();
			}
			
        }); 
    $("#ToCardType").combobox({
			onSelect:function(){
			ToCardType_change();	
		}
	    });
		
	$("#SourceCardType").combobox({
			onSelect:function(){
			SourceCardType_change();	
		}
	    });
		
    $('#SourceCardType').combobox('setValue',"C");
    $('#ToCardType').combobox('setValue',"C");

})

//清屏
function BClear_click(){
	$("#SourceNo,#ToNo,#ToNo2,#SourceInfo,#ToInfo,#SourceStatus,#ToStatus,#SourceAmount,#ToAmount,#MoveAmount,#ToAmountNew,#SourceCardID,#ToCardID,#TotalNum,#TotalAmt").val("");
	  $('#SourceCardType').combobox('setValue',"C");
    $('#ToCardType').combobox('setValue',"C");

}


function SourceCardType_change()
{
	CardType_change("Source");
}

function ToCardType_change()
{
	CardType_change("To");
}

function CardType_change(Type)
{
	var CardType=getValueById(Type+"CardType");
	if(CardType=="C"){
		if(Type=="Source"){$("#SourceNoL").text("代金卡号");}
		if(Type=="To"){$("#ToNoL").text("代金卡号");}
		
		$("#ToNo2").css('display','block');//显示
		$("#toto").css('display','block');//显示
	
	}else{
		if(Type=="Source"){$("#SourceNoL").text("登记号");}
		if(Type=="To"){$("#ToNoL").text("登记号");}
		
		$("#TotalAmt").val("")
		
		$("#TotalNum").val("")
		
		$("#ToNo2").css('display','none');//隐藏
		$("#toto").css('display','none');//隐藏
		
			
	}

	setValueById(Type+"No","");
	setValueById(Type+"Info","");
	setValueById(Type+"Amount","");
	setValueById(Type+"Status","");
	setValueById(Type+"CardID","");
	setValueById("ToAmountNew","");
		
}
function ToNo2_keydown()
{
	var CardType=$("#ToCardType").combobox('getValue');	
	if(CardType=="C"){
		CalTotalAmt();
	}
}
function MoveAmount_keydown()
{
	var CardType=$("#SourceCardType").combobox('getValue');	
	if(CardType=="C"){
		CalTotalAmt();
	}
	
}
function No_keydown(Type)
{
	
	    var No=getValueById(Type+"No");
		if (No=="") 
		{   
		   $.messager.popover({msg: "请输入代金卡号", type: "info"});
			//alert("请输入代金卡");
			return false;
		}
		var DoType=getValueById(Type+"CardType");
		
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",No,DoType);
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			 $.messager.popover({msg: "输入信息系统中不存在", type: "info"});
			//alert("输入信息系统中不存在");
			return false
		}
		
		var CardType=getValueById(Type+"CardType");
		
		if(CardType=="C"){
			 setValueById(Type+"No",Arr[6]);	
		}else{
			 setValueById(Type+"No",Arr[1]);	
		}
		 setValueById(Type+"Info",Arr[2]);
		 setValueById(Type+"Amount",Arr[5]);
		 setValueById(Type+"Status",Arr[4]);
		 setValueById(Type+"CardID",Arr[3]);
		 if((Type=="To")&&(CardType=="C")){
			 CalTotalAmt();
		 }
	
}

//计算总金额和总张数
function CalTotalAmt()
{
	var ToNo=$("#ToNo").val();
	var ToNo2=$("#ToNo2").val();
	var Amt=$("#MoveAmount").val();
	var ToID=$("#ToCardID").val();
	if ((ToID=="")&&(Amt=="")){	 
		$.messager.popover({msg: "转移金额不能为空", type: "info"});
	 	return false;
	}
	
	if((ToNo2=="")&&(ToNo=="")){
		$.messager.popover({msg: "到代金卡号不能为空", type: "info"})
		return false;
	}
	if(ToID==""){
		if((ToNo2!="")&&(ToNo!="")){
			var TotalNum=((+ToNo2)-(+ToNo)+1)
		}else{
			var TotalNum=1;
		}
		var TotalAmt=(TotalNum*(+Amt))
		$("#TotalAmt").val(TotalAmt);
		$("#TotalNum").val(TotalNum);
	}
	
}
function BMove_click()
{
	var SourceID=$("#SourceCardID").val();
	if (SourceID==""){
		$.messager.alert("提示","请输入源数据","info");
		return false;
	}
	var ToID=$("#ToCardID").val();
	if (ToID==""){
		//$.messager.alert("提示","请输入目标数据","info");
		//return false;
		var Type=$("#ToCardType").combobox('getValue');
		var MoveNo=$("#ToNo").val();
		if (MoveNo==""){
			$.messager.alert("提示","请输入目标数据","info");
			return false;
		}
		ToNo2=$("#ToNo2").val();
		if (ToNo2!=""){
			MoveNo=MoveNo+"-"+ToNo2
		}
	}
	
	var ToStatus=$("#ToStatus").val();
	var ToCardType=$("#ToCardType").combobox('getValue');
	if(ToCardType=="C"){var ToCardType="代金卡";}
	if(ToCardType=="R"){var ToCardType="预缴金";}
	var SourceCardType=$("#SourceCardType").combobox('getValue');
	if(SourceCardType=="C"){var SourceCardType="代金卡";}
	if(SourceCardType=="R"){var SourceCardType="预缴金";}
	
	if((ToCardType==SourceCardType)&&(SourceCardType=="代金卡")){
		if(SourceID==ToID){
			$.messager.alert("提示","源代金卡号和到代金卡号不能相同，请重新输入","info");
			return false;
		
		}
	}
	if((ToCardType==SourceCardType)&&(SourceCardType=="预缴金")){
		if(SourceID==ToID){
			$.messager.alert("提示","登记号不能相同，请重新输入","info");
			return false;
		
		}
	}
	if((SourceID!="")&&($("#SourceStatus").val()!="正常")){
		$.messager.alert("提示","源"+SourceCardType+"不是正常状态,不允许转移","info");
		return false;
	}
	if((ToID!="")&&(ToStatus!="正常")){
		$.messager.alert("提示","到"+ToCardType+"不是正常状态,不允许转移","info");
		return false;
	}
	var Amount=$("#MoveAmount").val();
	if ((isNaN(Amount))||(Amount=="")||(Amount==0)||(Amount<0)){
		$.messager.alert("提示","请输入正确的转移金额","info");
		return false;
	}
	if((Amount.indexOf(".")!="-1")&&(Amount.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","转移金额小数点后不能超过两位","info");
			return false;
		}

	if (ToID!=""){
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","MoveAmount",SourceID,ToID,Amount);
	}else{
		//alert(Type+"^"+MoveNo+"^"+Amount+"^"+SourceID)
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","InsertAPInfo",Type,MoveNo,Amount,SourceID);
	}
	var Arr=ret.split("^");
	if (Arr[0]!=0){
		$.messager.alert("提示",Arr[1],"info");
		return false;
	}else{
			
		if($("#SourceNo").val()!=""){
			var SourceInfoStr=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",$("#SourceNo").val(),getValueById("SourceCardType"));
			var SourceInfo=SourceInfoStr.split("^");
			$("#SourceAmount").val(SourceInfo[5]);
			
		}
		if($("#ToNo").val()!=""){
			var ToInfoStr=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",$("#ToNo").val(),getValueById("ToCardType"));
			var ToInfo=ToInfoStr.split("^");
			$("#ToAmountNew").val(ToInfo[5]);
			
		}
		$.messager.alert("提示","转移成功","success");
	    
	}
}
function InitCombobox()
{
	// 源卡类型
	var SourceCTypeObj = $HUI.combobox("#SourceCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'预缴金'},
            {id:'C',text:'代金卡'},
           
        ]
	});

	//到卡类型		
	var ToCTypeObj = $HUI.combobox("#ToCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'预缴金'},
            {id:'C',text:'代金卡'},     
        ]
	})
	
}
