
/*
 * FileName:    dhcpeinpatientlist.hisui.js
 * Author:      xueying
 * Date:        20220914
 * Description: 住院病人体检列表
 */
 
 $(function(){
	
	//初始化列表
	InitIPatientListGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
   
   	//删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
           
     //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
     //设置住院病人为体检病人 
    SetOtherPatientToHP();
         
})

//设置住院病人为体检病人 
function SetOtherPatientToHP(){
    
    var UserID=session['LOGON.USERID'];
   
	if (OtherPAADM!=""){
		var flag=tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",OtherPAADM);
		if(flag=="1"){
			return false;
		}
		var Info=tkMakeServerCall("web.DHCPE.DocPatientFind","GetInfoByPAADM",OtherPAADM);
		var Char_1=String.fromCharCode(1);
		var BaseInfoArr=Info.split(Char_1);
		//alert(BaseInfoArr)
		if (BaseInfoArr[0]!=""){
			var Arr=BaseInfoArr[0].split("^");	
			$.messager.confirm("确认",$g("确定要将")+Arr[1]+$g("设置为体检人员吗?"), function(r){
				if (r){
					$.m({ ClassName:"web.DHCPE.OtherPatientToHP", MethodName:"Save",PAADM:OtherPAADM,UserID:UserID},function(ReturnValue){
						if (ReturnValue.split("^")[0]=='-1') {
							$.messager.alert("提示",ReturnValue,"info"); 
							return false; 
						}else if (ReturnValue.split("^")[0]=='0') {
							BFind_click(); 
						}
					});	
				}
			});
		}
	}
}
function InitIPatientListGrid(){
	
	
	$HUI.datagrid("#IPatientListGrid",{
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
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindPatientList",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			EpisodeID:"",
			ShowDelete:"",
			hospid:session['LOGON.HOSPID'],
		    locid:session['LOGON.CTLOCID']
						
		},
		columns:[[       
		    {field:'TEpisodeID',title:'PAADM',hidden: true},
			{field:'TRegNo',width:140,title:'登记号'},
			{field:'TName',width:200,title:'姓名'},	
			{field:'TSex',width:100,title:'性别'},
			{field:'TAge',width:100,title:'年龄'},
			{field:'TIDCard',width:260,title:'证件号'},
			{field:'TIDCardDesc',width:180,title:'证件类型'},
			{field:'TInDate',width:130,title:'入院日期'},
			{field:'THPDate',width:130,title:'体检日期'},
			{field:'THStatusDesc',width:120,title:'体检状态'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$("#PAADM").val(rowData.TEpisodeID);
			
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


//删除
function BDelete_click(){
	
   var UserID=session['LOGON.USERID'];
   var PAADM=$("#PAADM").val();
   if (PAADM=="")
	{
		$.messager.alert("提示","请先选择待删除的记录!","info");	
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OtherPatientToHP", MethodName:"Delete",PAADM:PAADM,UserID:UserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示","删除失败！","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#IPatientListGrid").datagrid('reload');
					$("#PAADM").val("");
				}
			});	
		}
	});
   
   
}
	
//查询
function BFind_click() {
	
	var LocID=session['LOGON.CTLOCID'];
	var HospID=session['LOGON.HOSPID'];
	var iStartDate=$("#StartDate").datebox('getValue');
	var iEndDate=$("#EndDate").datebox('getValue');
	
	 $("#IPatientListGrid").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindPatientList",
			StartDate:iStartDate,
			EndDate:iEndDate,
			EpisodeID:"",
			ShowDelete:"",
			hospid:HospID,
		    locid:LocID
			
		})
		
}


//清屏
function BClear_click(){
	$("#StartDate,#EndDate").datebox('setValue','');
	$("#PAADM").val("");
	BFind_click();
}