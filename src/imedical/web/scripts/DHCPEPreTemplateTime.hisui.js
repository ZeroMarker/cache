//
//名称	DHCPEPreTemplateTime.hisui.js
//功能  时段信息
//创建	2019.01.29
//创建人  xy


$(function(){
	
	InitPreTemplateTimeDataGrid();
	
	//更新  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
    //删除
    $("#BDelete").click(function() {	
		 BDelete_click();		
   
        }); 
 
})

function BUpdate_click()
{
	
	var ID=getValueById("ID");
	var StartTime=getValueById("StartTime");
	if (StartTime==""){
		$.messager.alert("提示","开始时间不能为空","info");
		return false;
	}
	var EndTime=getValueById("EndTime");
	if (EndTime==""){
		$.messager.alert("提示","结束时间不能为空","info");
		return false;
	}
	var Num=getValueById("Num");
	if (Num=="" || Num=="-"){
		MaleNum = 0;
		FemaleNum = 0;
	} else {
		MaleNum = Num.split("-")[0];
		FemaleNum = Num.split("-")[1];	
	}
	if(Num.indexOf("-")<0){
		$.messager.alert("提示","数量维护格式不正确,格式应为：数量（男）-数量（女）,例如：10-20","info");
		return false;
		}
		 
   
 	if(Num.indexOf("-")>=0){

	MaleNum = Num.split("-")[0];
	FemaleNum = Num.split("-")[1];
	if((MaleNum=="")||(MaleNum==undefined)||(FemaleNum=="")||(FemaleNum==undefined))
	 {
		  $.messager.alert("提示","数量维护格式不正确,格式应为：数量（男）-数量（女）,例如：10-20");
         return false;
	 }
	 
	if (!isNumber(MaleNum))
	{ 
		 $.messager.alert("提示","数量维护格式不正确,格式应为：数量（男）-数量（女）,例如：10-20","info");
        return false;
	}

	if(!isNumber(FemaleNum)) {
         $.messager.alert("提示","数量维护格式不正确,格式应为：数量（男）-数量（女）,例如：10-20","info");
        return false;
      }
    
   }
    
	var currentMale = 0;  ///可以预约人数
	var currentFemale = 0;
	
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","SearchPeopleCount",ParRef,Type);
	currentMale = (ret.split("-"))[0];
	currentFemale = (ret.split("-"))[1];
	if(currentMale == null || currentMale == "" || currentMale == undefined){
		currentMale = 0;	
	}
	if(currentFemale == null || currentFemale == "" || currentFemale == undefined){
		currentFemale = 0;	
	}
	currentMale = parseInt(currentMale);
	currentFemale = parseInt(currentFemale);

	var totalMaleNum = 0; ///分时段总人数
	var totalFemaleNum = 0;
	
    var objtbl = $("#PreTemplateTimeQueryTab").datagrid('getRows');
	var rows=objtbl.length;
	

	for (var i=0;i<rows;i++){
			
		var TID=objtbl[i].TID;
		var tobjMale=objtbl[i].TNumMale;
		var tobjFemale=objtbl[i].TNumFemale;
		
		tobjMale = parseInt(tobjMale);
		tobjFemale = parseInt(tobjFemale);
		if(TID != ID){
			totalMaleNum = totalMaleNum + tobjMale;
			totalFemaleNum = totalFemaleNum + tobjFemale;
		}
	}

	MaleNum = parseInt(MaleNum);
	FemaleNum = parseInt(FemaleNum);
	
	totalMaleNum = totalMaleNum + MaleNum;
	totalFemaleNum = totalFemaleNum + FemaleNum;
	
	if(totalMaleNum > currentMale){
		var balance = totalMaleNum - currentMale;
		$.messager.alert("提示","男性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;		
	
	}
	
	if(totalFemaleNum > currentFemale){
		var balance = totalFemaleNum - currentFemale;
		$.messager.alert("提示","女性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;	
		
	
	}

	var Info=StartTime+"^"+EndTime+"^"+MaleNum+"^"+FemaleNum;
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","UpdateTimeInfo",Type,ParRef,ID,Info);
	
	if (ret=="1"){
		//window.location.reload();
		 $("#PreTemplateTimeQueryTab").datagrid('load',{
			    ClassName:"web.DHCPE.PreTemplate",
				QueryName:"SerchTimeInfo", 
				Type:Type,
				ParRef:ParRef,
		}); 
		
		window.parent.$("#PreGADMHomeGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PreGADM,
			Type:"G"
		}); 
		
		
	}else{
		$.messager.alert("提示",ret,"info");
	}
}
function BClear()
{
	$("#Num,#ID,#EndTime,#StartTime").val("") 
	
}

function BDelete_click()
{
	
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;	
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.PreTemplate", MethodName:"DeleteTimeInfo",Type:Type,ID:ID},function(ReturnValue){
					
				if (ReturnValue!="0") {
					$.messager.alert("提示","删除失败:"+ReturnValue,"error");
					
				}else{
					$.messager.alert("提示","删除成功","success");
					
					 BClear();
					 
					 $("#PreTemplateTimeQueryTab").datagrid('load',{
			    		ClassName:"web.DHCPE.PreTemplate",
						QueryName:"SerchTimeInfo", 
						Type:Type,
						ParRef:ParRef,
			    		}); 
			    		
					window.parent.$("#PreGADMHomeGrid").datagrid('load',{
						ClassName:"web.DHCPE.PreHome",
						QueryName:"SerchHomeInfo",
						PGADMDr:PreGADM,
						Type:"G"
					}); 
				}
				});
		}
	});

}

function ShowPreManagerInfo(e)
{
	var DateStr=e.id;
	//var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreManager'+"&DateStr="+DateStr;
	var lnk="dhcpepremanager.hisui.csp?DateStr="+DateStr;
	websys_lu(lnk,false,'width=950,height=545,hisui=true,title=预约管理信息')
}


//判断输入的字符串是否为非负整数
function isNumber(elem){
 var pattern= /^\d+$/;
 if(pattern.test(elem)){
  return true;
 }else{
  return false;
 }
}


function InitPreTemplateTimeDataGrid(){

	$HUI.datagrid("#PreTemplateTimeQueryTab",{
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreTemplate",
			QueryName:"SerchTimeInfo", 
			Type:Type,
			ParRef:ParRef,
		},columns:[[
			{field:'TParRef',hidden:true,title:'就诊id'},
			{field:'TID',hidden:true,title:'就诊id'},
			{field:'TStartTime',width:'150',title:'开始时间'},
			{field:'TEndTime',width:'150',title:'结束时间'},
			{field:'TNumMale',width:'120',title:'数量(男)'},
			{field:'TNumFemale',width:'120',title:'数量(女)'},		
		
				
		]],
		onSelect: function (rowIndex, rowData) {
			var ID=rowData.TID;
			var StartTime=rowData.TStartTime;
			var EndTime=rowData.TEndTime;
			var MaleNum=rowData.TNumMale;
			var FemaleNum=rowData.TNumFemale;
			
			setValueById("ID",ID);
	       setValueById("StartTime",StartTime);
		   setValueById("EndTime",EndTime);
		    var num=MaleNum+"-"+FemaleNum;
		    setValueById("Num",num);	
			
		}

	
	})
}

