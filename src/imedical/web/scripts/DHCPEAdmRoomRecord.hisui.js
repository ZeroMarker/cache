
//名称	DHCPEAdmRoomRecord.hisui.js
//功能	体检诊室调整
//创建	2020.12.1
//创建人  xy
$(function(){
			
	InitCombobox();
	
	InitAdmRoomRecordGrid(); 
	
	
	//诊室信息
	$("#BFindRoomInfo").click(function() {	
		BFindRoomInfo_click();		
        }); 
       
	//调整
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });  
   
	//取消排队 
	$("#BStopRoom").click(function() {	
		BStopRoom_click();		
        });  
	
	//暂停排队
	$("#BPauseRoom").click(function() {	
		BPauseRoom_click();		
        });  

	//放弃选择诊室
	$("#BRefuseSelect").click(function() {	
		BRefuseSelect_click();		
        });  
	
	//恢复诊室
	$("#BResumeRoom").click(function() {	
		ResumeRoom_click();		
        });  
	
	 $("#Name").keydown(function(e) {	
		if(e.keyCode==13){
			FindDetail();
			}
	});
	
	 $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			RegNo_change();
			}
	});
	
    
})


//诊室信息
function BFindRoomInfo_click(){
	//alert($("#PAADM").val())
	$("#AdmRoomRecordGrid").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
	});
}

//放弃选择诊室
function BRefuseSelect_click()
{
	var PAADM=$("#PAADM").val();
	 if(PAADM==""){
	   $.messager.alert("提示","请先输入待操作的人员","info");
	    return false;
	   }
	   
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//获取的是数组，多行数据
    if(selectrow.length<1){
	    $.messager.alert("提示","请选择待操作记录","info");
		return false;
    }
	 
	
	var IfHadChecked=0;
	for (var i=0;i<selectrow.length;i++){
	
		    IfHadChecked=1
	
		    var RoomID=selectrow[i].TRoomID;
			var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Refuse",PAADM,RoomID)
     		$.messager.alert("提示",ret.split("^")[1],"info");	
     		if(ret.split("^")[0]==0)
     		{
	     		// 放弃的
	     		$("#RoomRecordID").val(ret.split("^")[2]);
	     		
	     		} 
    	     
	}
	if(IfHadChecked==1){
		//BFindRoomInfo_click();
		RegNo_change();
	}
	
}


//恢复诊室
function ResumeRoom_click()
{ 
	var PAADM=$("#PAADM").val();
	 if(PAADM==""){
	   $.messager.alert("提示","请先输入待操作的人员","info");
	    return false;
	   }
	
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//获取的是数组，多行数据
    if(selectrow.length<1){
	    $.messager.alert("提示","请选择待恢复诊室的记录","info");
		return false;
    }
   	var IfHadChecked=0;
	for(var i=0;i<selectrow.length;i++){
		 var RoomID=selectrow[i].TRoomID;
		 var RSID=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","GetResumeRoomButtonID",PAADM,RoomID);
		  if(RSID==""){
			     $.messager.alert("提示","已经恢复","info");
			     return false;
			}
			    
		   var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Resume",RSID);
		   $.messager.alert("提示",ret.split("^")[1],"info");
		   IfHadChecked=1;
		     
		 
		
	}
	
	if(IfHadChecked==1){
		
		RegNo_change();
	}
	
}
//暂停排队
function BPauseRoom_click()
{
	var ButtonText=$("#BPauseRoom").linkbutton("options").text;
	
	if(ButtonText=="恢复排队"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("提示","请先输入恢复排队的人员","info");
				return false;
		}
	}
	if(ButtonText=="排队"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("提示","请先输入暂停排队的人员","info");
				return false;
		}
	}
	if(ButtonText=="暂停排队"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("提示","请先输入暂停排队的人员","info");
				return false;
		}
	}

	var ID=$("#RoomRecordID").val();
	
	if (ID!=""){
		
		$.messager.confirm("操作提示", "是否需要把原来诊室，进行重新分配新诊室?", function (data) {
            		if (data) {
	          
	               var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
	        		
					var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
					if(rtn.split("^")[0]=="0"){
						$.messager.alert("提示","设置成功","info");
					}
					//$("#BPauseRoom").linkbutton({text:'恢复排队'})
				
					RegNo_change();
					
					
	        		}
            		else {
	            		
	            		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
						if(rtn.split("^")[0]=="0"){
							$.messager.alert("提示","设置成功","info");
						}
	
						RegNo_change();
                		
            		}
        			});	
		
	}else{
		
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
		if(rtn.split("^")[0]=="0"){
				$.messager.alert("提示","设置成功","info");
			}
			
		RegNo_change();
		
	}
	
	
	
	
	
		
	
}

//取消排队
function BStopRoom_click()
{
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("提示","请先输入待取消排队的人员","info");
		return false;
	}
	var ID=$("#RoomRecordID").val();
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能取消排队","info");
		return false;
	}

	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
	if (rtn.split("^")[0]=="-1"){
			$.messager.alert("提示","取消排队失败:"+rtn.split("^")[1],"info");
		
	}else{
		//BFindRoomInfo_click();
		$.messager.alert("提示","取消排队成功","info");
		RegNo_change();
	}
	
}




//调整
function BUpdate_click()
{
	var ID=$("#RoomRecordID").val();
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	var RoomID=$("#RoomDesc").combogrid("getValue");
	if (($("#RoomDesc").combogrid("getValue")==undefined)||($("#RoomDesc").combogrid("getValue")=="")){var RoomID="";}
	if (RoomID==""){
		$.messager.alert("提示","调整为诊室不存在,不能调整","info");
		return false;
	}
	
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//获取的是数组，多行数据
    if(selectrow.length>1){
	    $.messager.alert("提示","调整诊室，只能选中一条记录","info");
		return false;
    }
    
	for(var i=0;i<selectrow.length;i++){
		var RefuseRoom=selectrow[i].TRefuseRoom;
		if (RefuseRoom=="放弃"){
			$.messager.alert("提示","该诊室已放弃,不能调整到该诊室","info");
			return false;
		}
	}

		//alert(ID+"^"+RoomID)
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateAdmRoomRecord",ID,RoomID,1);

	if (rtn.split("^")[0]=="-1"){
			$.messager.alert("提示","更新失败:"+rtn.split("^")[1],"info");
		
	}else{
		//BFindRoomInfo_click();
		RegNo_change();
		$("#AreaDesc").combogrid('setValue',"");
		$("#RoomDesc").combogrid('setValue',"");

	}
}



function RegNo_change()
{
	var iRegNo=$("#RegNo").val();
	if (iRegNo==""){
		var Info="0^^^^^^^^^^^^";
	}else if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo);
			var Info=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmRecordInfo",iRegNo);
	} 
	
	//alert(Info)
	var Char_1=String.fromCharCode(1);
	var Arr=Info.split(Char_1);
	var BaseInfo=Arr[0];
	var BaseArr=BaseInfo.split("^");
	var PAADM="";
	var PauseFlag=0;
	
	if (BaseArr[0]=="0"){
		var RoomInfo=Arr[1];
		var RoomArr=RoomInfo.split("^");
		$("#Name").val(BaseArr[1]);
		$("#RegNo").val(BaseArr[5]);
		$("#Sex").val(BaseArr[2]);
		$("#Dob").val(BaseArr[3]);
		$("#IDCard").val(BaseArr[4]);
		$("#PAADM").val(BaseArr[10]);
		$("#RoomRecordID").val(RoomArr[0]);
		$("#CurRoomInfo").val(RoomArr[1]);
		
		PAADM=BaseArr[10];
		PauseFlag=BaseArr[11];
	}else{
		
		 $.messager.popover({msg: BaseArr[1], type: "info"});
		 $("#Name,#Sex,#Dob,#IDCard,#PAADM").val("");
		$("#RoomRecordID").val("");
		$("#CurRoomInfo").val("");
		
	}
	
	if (PauseFlag!="0"){
		
		SetCElement("BPauseRoom","恢复排队");
		
	}else{
		SetCElement("BPauseRoom","暂停排队");
	
		
	}
	
	$("#AdmRoomRecordGrid").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
	});
	
}
function InitAdmRoomRecordGrid()
{

$HUI.datagrid("#AdmRoomRecordGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
		},
		
		columns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
			{field:'TRoomID',title:'RoomID',hidden: true},
			{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TAreaDesc',width:300,title:'分区'},
			{field:'TAreaID',title:'AreaID',hidden: true},
			{field:'TRoomDesc',width:300,title:'诊室'},
			{field:'TWaitNum',width:120,title:'等候人数'},
			{field:'TWaitMinute',width:120,title:'等到时间'},
			{field:'TRefuseRoom',width:100,title:'放弃'},	
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
			  	$("#AreaDesc").combogrid('setValue',rowData.TAreaID);
				//$("#RoomDesc").combogrid('setValue',rowData.TRoomID);
				$('#RoomDesc').combogrid('grid').datagrid('reload',{'q':rowData.TRoomID});
				$("#RoomDesc").combogrid('setValue',rowData.TRoomID);
							
		}
			
	});
}

function InitCombobox(){
	
	//分区信息
     var AreaDescObj = $HUI.combogrid("#AreaDesc",{    
        panelWidth:390,
        url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindArea",
        mode:'remote',
        delay:200,
          pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],

        idField:'TID',
        textField:'TDesc',
        onBeforeLoad:function(param){
            //param.Parref = param.q;
        },
         onChange:function()
        {
            RoomDescObj.clear();
           
        },
        columns:[[
            {field:'TID',title:'ID',width:40},
            {field:'TCode',title:'代码',width:80},
            {field:'TDesc',title:'描述',width:100},
            {field:'TSort',title:'序号',width:60},
            {field:'TAreaFlag',title:'分区排队',width:80}
        ]]
        })
	  
	
	//诊室
		 var RoomDescObj = $HUI.combogrid("#RoomDesc",{
        panelWidth:650,
        url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindRoomNew",
        mode:'remote',
        delay:200,
        pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
        idField:'TID',
        textField:'TDesc',
        onBeforeLoad:function(param){
	       
	        var AreaId=$("#AreaDesc").combogrid("getValue");
            param.Parref =AreaId;
           
        },
        onShowPanel:function()
        {
            $('#RoomDesc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'TID',title:'ID',width:60},
            {field:'TCode',title:'代码',width:60},
            {field:'TDesc',title:'描述',width:100},
            {field:'TSort',title:'序号',width:50},
            {field:'TSex',title:'性别',width:50},
            {field:'TActiveFlag',title:'激活',width:50},
            {field:'TVIPLevelDesc',title:'VIP等级',width:60},
            {field:'TShowNum',title:'显示人数',width:80},
            {field:'TDoctorDesc',title:'医生',width:100}
  

        ]]
        });
	
	
	
}
