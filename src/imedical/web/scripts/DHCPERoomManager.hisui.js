
//名称	DHCPERoomManager.hisui.js
//功能	体检诊室维护
//创建	2019.0.07
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitAreaGrid();
     
    InitRoomGrid();
       
    //修改(分区维护)
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增(分区维护)
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
    
    //清屏(分区维护)
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //诊室位置(分区维护)
     $("#BRoomPlace").click(function() {	
		BRoomPlace_click();		
        });  
     
      //修改(诊室维护)
	$("#BRUpdate").click(function() {	
		BRUpdate_click();		
        });
        
     //新增(诊室维护)
	$("#BRAdd").click(function() {	
		BRAdd_click();		
        });  
    
    
    //清屏(诊室维护)
	$("#BRClear").click(function() {	
		BRClear_click();		
        });
   
   //标本维护
   $("#BSpecimen").click(function() {	
		 BSpecimen_click();		
        });
        
   //电脑IP维护
   $("#BComIP").click(function() {	
		 BComIP_click();		
        });
  
  //前面诊室
  $("#BRoomSR").click(function() {	
		 BRoomSR_click();		
        });
   
  
  //诊室位置
  $("#BRoomRP").click(function() {	
		 BRoomRP_click();		
        });
  
   //设置默认值
   SetDefault()
})


/******************************诊室维护界面start********************/

//前面诊室
function BRoomSR_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="SR"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"前面诊室维护-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=前面诊室维护-'+Desc)
					
			}
}

//诊室位置
function BRoomRP_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="RP"
				/*
				$("#myWin").show(); 
				 
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"诊室位置维护-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室位置维护-'+Desc)
					
			}
}
//电脑IP维护
function BComIP_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="IP"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"诊室电脑IP维护-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomcomponent.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室电脑IP维护-'+Desc)
					
			}
}
//标本维护
function BSpecimen_click(){
		var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else { 
			
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="SP"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"诊室标本维护-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="100%" ></iframe>'
				});	
				*/
				lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
				websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室标本维护-'+Desc)
				
				
			}
}

//设置默认值
function SetDefault(){
	  $("#Sex").combobox('setValue',"N");
	  $("#Diet").combobox('setValue',"N");
	  $("#Emiction").combobox('setValue',"N");
  }
//修改(诊室维护)
function BRUpdate_click(){
	 BRSave_click("1");
}

//新增(诊室维护)
function BRAdd_click(){
	 BRSave_click("0");
}

function BRSave_click(Type)
{

	 var Parref=$("#AreaID").val();
	 if(Parref==""){
		 $.messager.alert("提示","请先选择诊室分区","info");
			return false;
	 }

	var RoomID=$("#RoomID").val();
	if(Type=="1"){
		if(RoomID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if(RoomID!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var Code=$("#RoomCode").val();
	if (""==Code) {
		$("#RoomCode").focus();
		var valbox = $HUI.validatebox("#RoomCode", {
			required: true,
	    });
		$.messager.alert("提示","诊室代码不能为空","info");
		return false;
	}
	var Desc=$("#RoomDesc").val();
	if (""==Desc) {
		$("#RoomDesc").focus();
		var valbox = $HUI.validatebox("#RoomDesc", {
			required: true,
	    });
		$.messager.alert("提示","诊室描述不能为空","info");
		return false;
	}
	

	var Sort=$("#RoomSort").val();
	if (""==Sort) {
		$("#RoomSort").focus();
		var valbox = $HUI.validatebox("#RoomSort", {
			required: true,
	    });
		$.messager.alert("提示","序号不能为空","info");
		return false;
	}
	
	var Sex=$("#Sex").combobox('getValue');
	if (($("#Sex").combobox('getValue')==undefined)||($("#Sex").combobox('getValue')=="")){var Sex="";}

	var Diet=$("#Diet").combobox('getValue');
	if (($("#Diet").combobox('getValue')==undefined)||($("#Diet").combobox('getValue')=="")){var Diet="";}

	var Emiction=$("#Emiction").combobox('getValue');
	if (($("#Emiction").combobox('getValue')==undefined)||($("#Emiction").combobox('getValue')=="")){var Emiction="";}

	var Station=$("#Station").combobox('getValue');
	if (($("#Station").combobox('getValue')==undefined)||($("#Station").combobox('getValue')=="")){var Station="";}

	
	var Remark=$("#Remark").val();
	var Minute=$("#Minute").val();
	var ShowNum=$("#ShowNum").val();
	var Parref=$("#AreaID").val();
	var DoctorDR=$("#DocName").combogrid('getValue');
	if (($("#DocName").combogrid('getValue')==undefined)||($("#DocName").combogrid('getValue')=="")){var DoctorDR="";}

	
	var iActiveFlag="Y";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if (!ActiveFlag) iActiveFlag="N";
	var iBangdingFlag="N";
	var IFBangding=$("#IFBangding").checkbox('getValue');
	if (IFBangding) {iBangdingFlag="Y";}
	else{iBangdingFlag="N";}
	var VIPLevel="";
	
	var MainManager=$("#MainManager").combobox('getValue');
	
	var PriorNum=$("#PriorNum").val();
	
	if (($("#MainManager").combobox('getValue')==undefined)||($("#MainManager").combobox('getValue')=="")){var MainManager="";}
  
	var Str=Parref+"^"+Code+"^"+Desc+"^"+Sort+"^"+Sex+"^"+Diet+"^"+Emiction+"^"+Station+"^"+Remark+"^"+Minute+"^"+DoctorDR+"^"+iActiveFlag+"^"+ShowNum+"^"+iBangdingFlag+"^"+VIPLevel+"^"+MainManager+"^"+PriorNum;
	//debugger; // 2
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateRoom",RoomID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("提示","修改失败:"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("提示","新增失败:"+Arr[1],"error");}		
	}else{
		
		BRClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}	
	} 	
	
	
} 
//清屏(诊室维护)
function BRClear_click(){
	$("#RoomID,#RoomCode,#RoomDesc,#RoomSort,#ShowNum,#Minute").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	var valbox = $HUI.validatebox("#RoomCode,#RoomDesc,#RoomSort", {
			required: false,
	    });
	$("#RoomGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoom",
			Parref: $("#AreaID").val(),
		});	
	
  
   SetDefault();	
}


function InitRoomGrid(){
	$HUI.datagrid("#RoomGrid",{
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
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoom",
		},
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'80',title:'诊室代码'},
			{field:'TDesc',width:'150',title:'诊室描述'},
			{field:'TSort',width:'40',title:'序号'},
			{field:'TSex',width:'40',hidden:true},
			{field:'TSexDesc',width:'40',title:'性别'},
			{field:'TDiet',width:'50',title:'就餐'},
			{field:'TEmiction',width:'50',title:'憋尿'},
			{field:'TStation',width:'80',title:'站点'},
			{field:'TActiveFlag',width:'50',align:'center',title:'激活',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TShowNum',width:'80',title:'显示人数'},
			{field:'TIFBangding',width:'80',align:'center',title:'是否绑定',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TMinute',width:'80',title:'时间'},
			{field:'TDoctorDesc',width:'100',title:'医生'},
			{field:'TMainManagerRoom',hidden: true},
			{field:'TMainManagerRoomDesc',width:'100',title:'主队列'},
			{field:'TPriorNum',width:'100',title:'优先人数'},
			{field:'TRemark',width:'100',title:'备注'}
				
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RoomID").val(rowData.TID);
				$("#RoomCode").val(rowData.TCode);
				$("#RoomDesc").val(rowData.TDesc);
				$("#RoomSort").val(rowData.TSort);
				$("#Sex").combobox('setValue',rowData.TSex);
				$("#Diet").combobox('setValue',rowData.TDietFlag);
				$("#Emiction").combobox('setValue',rowData.TEmictionFlag);
				$("#Station").combobox('setValue',rowData.TStationID);
				$("#ShowNum").val(rowData.TShowNum);
				$("#Minute").val(rowData.TMinute);
				$("#DocName").combogrid('setValue',rowData.TDoctorID);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TIFBangding=="Y"){
					$("#IFBangding").checkbox('setValue',true);
				}else{
					$("#IFBangding").checkbox('setValue',false);
				}			
				if(rowData.TActiveFlag=="Y"){
					$("#ActiveFlag").checkbox('setValue',true);
				}else{
					$("#ActiveFlag").checkbox('setValue',false);
				}			
				//alert(rowData.TMainManagerRoom)
				$("#MainManager").combobox('setValue',rowData.TMainManagerRoom);
				$("#PriorNum").val(rowData.TPriorNum);				
					
		}

			
	})
}



function loadRoomList(rowData){
	$('#RoomGrid').datagrid('load', {
		ClassName:"web.DHCPE.RoomManager",
		QueryName:"FindRoom",
		Parref: rowData.TID
		
	});
	//$('#InvPrtId').val(row.TRowId);
}
/******************************诊室维护界面end********************/

/******************************分区维护界面start********************/

//诊室位置
function BRoomPlace_click(){
	lnk="dhcperoomplace.hisui.csp";	
	websys_lu(lnk,false,'width=900,height=600,hisui=true,title=诊室位置');

	
}
 //修改(分区维护)
 function BUpdate_click(){
	 BSave_click("1");
 }
 
 //新增(分区维护)
function BAdd_click(){
	BSave_click("0");
}

function BSave_click(Type)
{
	var AreaID=$("#AreaID").val();
	if(Type=="1"){
		
		if(AreaID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if(AreaID!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var Code=$("#AreaCode").val();
	if (""==Code) {
		$("#AreaCode").focus();
		var valbox = $HUI.validatebox("#AreaCode", {
			required: true,
	    });
		$.messager.alert("提示","分区代码不能为空","info");
		return false;
	}
	var Desc=$("#AreaDesc").val();
	if (""==Desc) {
		$("#AreaDesc").focus();
		var valbox = $HUI.validatebox("#AreaDesc", {
			required: true,
	    });
		$.messager.alert("提示","分区描述不能为空","info");
		return false;
	}
	

	var Sort=$("#AreaSort").val();
	if (""==Sort) {
		$("#AreaSort").focus();
		var valbox = $HUI.validatebox("#AreaSort", {
			required: true,
	    });
		$.messager.alert("提示","序号不能为空","info");
		return false;
	}
	
	var LocID=session['LOGON.CTLOCID']
	var iAreaFlag="0";
	var AreaFlag=$("#AreaFlag").checkbox('getValue');
	if(AreaFlag) iAreaFlag="1";
	
	var Str=Code+"^"+Desc+"^"+Sort+"^"+LocID+"^"+""+"^"+iAreaFlag;
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateArea",AreaID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("提示","修改失败"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("提示","新增失败"+Arr[1],"error");}		
	}else{
		
		BClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}	
	} 	
	
	
}
//清屏(分区维护)
function BClear_click(){
	$("#AreaID,#AreaCode,#AreaDesc,#AreaSort").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#AreaCode,#AreaDesc,#AreaSort", {
			required: false,
	    });
	$("#AreaGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindArea",
		});	
}
function InitAreaGrid(){
	$HUI.datagrid("#AreaGrid",{
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
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindArea",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'100',title:'分区代码'},
			{field:'TDesc',width:'150',title:'分区描述'},
			{field:'TSort',width:'60',title:'序号'},
			{field:'TAreaFlag',width:'70',align:'center',title:'分区排队',
				formatter: function (value, rec, rowIndex) {
						if(value=="是"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			$("#AreaCode").val(rowData.TCode);
			$("#AreaDesc").val(rowData.TDesc);
			$("#AreaSort").val(rowData.TSort);
			$("#AreaID").val(rowData.TID);
			if(rowData.TAreaFlag=="是"){
					$("#AreaFlag").checkbox('setValue',true);
				}else{
					$("#AreaFlag").checkbox('setValue',false);
				}			
			
			$('#RoomGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadRoomList(rowData);
		}
		
			
	})
}

/******************************分区维护界面end********************/


function InitCombobox(){
	//憋尿
	var EmictionObj = $HUI.combobox("#Emiction",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'不限'},
            {id:'HE',text:'憋尿'},
            {id:'EE',text:'排尿'},
           
        ]

	});
	
	//就餐
	var DietObj = $HUI.combobox("#Diet",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'不限'},
            {id:'PRE',text:'餐前'},
            {id:'POST',text:'餐后'},
           
        ]

	});
	
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'不限'},
            {id:'M',text:'男'},
            {id:'F',text:'女'},
           
        ]

	});
	
		
	//站点
	var StationObj = $HUI.combobox("#Station",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	// 主队列
	var StationObj = $HUI.combobox("#MainManager",{
		url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindRoomNew&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc'
		})
			
	
	//医生
	   var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId=session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'姓名',width:200}
				
		]]
		})
	
	
}

