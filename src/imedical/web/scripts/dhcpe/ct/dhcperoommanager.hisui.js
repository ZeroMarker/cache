
//名称	dhcpe/ct/dhcperoommanager.hisui.js
//功能	体检诊室维护
//创建	2021.08.07
//创建人  sxt

var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_Area";
var RoomtableName = "DHC_PE_Room";
var RoomIPtableName = "DHC_PE_RoomIP";
var roomSpecialRoomtableName = "DHC_PE_RoomSpecialRoom";
var RoomRoomPlaceptableName = "DHCPERoomRoomPlace";
var RoomSpecimentableName = "DHC_PE_RoomSpecimen";
var RoomPlaceptableName = "DHC_PE_RoomSpecimen";  /// 新增诊室位置字典表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']


$(function(){
	
	//获取下拉列表
	//var otp={width:350};
	//获取下拉列表
	//var otp={width:350};
	
	//科室下拉列表
	GetLocComp(SessionStr)
	
	
	//科室change
	$("#LocList").combobox({
		
		onSelect: function(rowData)
		{
				
	    var LocID=session['LOGON.CTLOCID']
		var LocListID=$("#LocList").combobox('getValue');
		if(LocListID!=""){var LocID=LocListID; }
		var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		/***************站点重新加载*************************/
		var Stationurl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
		$('#Station').combobox('reload',Stationurl);
		/***************站点重新加载*************************/
		
		/***************单独排队站点重新加载*************************/
		$HUI.combobox("#SingleStation",{
			onLoadSuccess:function(){
			// 获取当前科室 单独排队的站点
   			var CurSessionSIngleStation=tkMakeServerCall("web.DHCPE.CT.RoomManager","GetSingleRoom",LocID);
   			$("#SingleStation").combobox('select',CurSessionSIngleStation);

				}
		 });
		var SingleStationurl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
		$('#SingleStation').combobox('reload',SingleStationurl);
		
		/***************单独排队站点重新加载*************************/
	
	 	/***************医生重新加载*************************/
	 	$HUI.combogrid("#DocName",{
			onBeforeLoad:function(param){
				param.Desc = param.q;
				param.LocID=LocID;
				param.hospId=hospId;

				}
		 });
		    
	  $('#DocName').combogrid('grid').datagrid('reload'); 
	 	/***************医生重新加载*************************/
			BClear_click();
				
			$("#AreaGrid").datagrid('load',{
				ClassName:"web.DHCPE.CT.RoomManager",
				QueryName:"FindArea",
				LocID: rowData.LocRowId
			});
			
			BRClear_click();
				
			$('#RoomGrid').datagrid('load', {
				ClassName:"web.DHCPE.CT.RoomManager",
				QueryName:"FindRoom",

			});
			
	
	}
			
	})
	
	
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
  
  // 诊室项目
  $("#BRoomItem").click(function() {	
		 BRoomItem_click();		
        });
  
  // 保存单独排队站点
  $("#BSaveSingleStation").click(function() {
	  	var LocID=$("#LocList").combobox('getValue');
	  	var SingleStation=$("#SingleStation").combobox('getValue');
	  	if(SingleStation==undefined) SingleStation="";
	  	if(SingleStation==""){
		  	$.messager.alert("提示","请选择单独排队站点！","info")
		  	return 
	  	}
	  	var ret=tkMakeServerCall("web.DHCPE.CT.RoomManager","SaveSingleRoom",LocID,SingleStation);
	  	if(ret=="0"){
		  	$.messager.popover({msg: '单独排队站点保存成功！',type:'success',timeout: 1000});
	  	}	  	
  	
  	})
  
   //设置默认值
   SetDefault();
   
   
})


/******************************诊室维护界面start********************/

function BRoomItem_click()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('提示','请选择待维护的记录!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="RI"
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
			lnk="dhcpe.ct.roomitem.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType+"&DefLoc="+LocID;	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室项目维护-'+Desc)
					
			}
	
	
	}

//前面诊室
function BRoomSR_click(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

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
			lnk="dhcpe.ct.roomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType+"&DefLoc="+LocID;	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=前面诊室维护-'+Desc)
					
			}
}

//诊室位置
function BRoomRP_click(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

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
			lnk="dhcpe.ct.roomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType+"&DefLoc="+LocID;	
			//alert(lnk)
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室位置维护-'+Desc)
					
			}
}

//电脑IP维护
function BComIP_click(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

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
			lnk="dhcpe.ct.roomcomponent.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType+"&DefLoc="+LocID;
			//alert(lnk+"")
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=诊室电脑IP维护-'+Desc)
					
			}
}
//标本维护
function BSpecimen_click(){

		var LocID=session['LOGON.CTLOCID']
		var LocListID=$("#LocList").combobox('getValue');
		if(LocListID!=""){var LocID=LocListID; }

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
				
				lnk="dhcpe.ct.roomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType+"&DefLoc="+LocID;	
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

	var Station=$("#Station").combobox('getValues');
	debugger; //
	if (($("#Station").combobox('getValues')==undefined)||($("#Station").combobox('getValues')=="")){var Station="";}
	
	var Remark=$("#Remark").val();
	
	var Minute=$("#Minute").val();
	
	var ShowNum=$("#ShowNum").val();
	
	var Parref=$("#AreaID").val();
	
	var DoctorDR=$("#DocName").combogrid('getValue');
	if (($("#DocName").combogrid('getValue')==undefined)||($("#DocName").combogrid('getValue')=="")){var DoctorDR="";}

	var iRoomActiveFlag="N";
	var RoomActiveFlag=$("#RoomActiveFlag").checkbox('getValue');
	if (RoomActiveFlag) iRoomActiveFlag="Y";
	
	var iBangdingFlag="N";
	var IFBangding=$("#IFBangding").checkbox('getValue');
	if (IFBangding) {iBangdingFlag="Y";}
	else{iBangdingFlag="N";}
	
	var VIPLevel="";
	
	var MainManager=$("#MainManager").combobox('getValue');
	
	var PriorNum=$("#PriorNum").val();
	
	var PriorTime=$("#PriorTime").val();
	
	if (($("#MainManager").combobox('getValue')==undefined)||($("#MainManager").combobox('getValue')=="")){var MainManager="";}
  
	var Str=Parref+"^"+Code+"^"+Desc+"^"+Sort+"^"+Sex+"^"+Diet+"^"+Emiction+"^"+Station+"^"+Remark+"^"+Minute+"^"+DoctorDR+"^"+iRoomActiveFlag+"^"+ShowNum+"^"+iBangdingFlag+"^"+VIPLevel+"^"+MainManager+"^"+PriorNum+"^"+PriorTime;
	
	var LocID=$("#LocList").combobox('getValue');
	
	var UserID=session['LOGON.USERID'];
	
	//alert("Str:"+Str)
	
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateRoom",RoomID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("提示","修改失败:"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("提示","新增失败:"+Arr[1],"error");}		
	}else{
		
		BRClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功',type:'success',timeout: 1000});}	
	} 	
	
	
} 
//清屏(诊室维护)
function BRClear_click(){
	var LocID=$("#LocList").combobox('getValue');
	$("#RoomID,#RoomCode,#RoomDesc,#RoomSort,#ShowNum,#Minute,#PriorNum,#PriorTime,#Remark").val("");
	$("#RoomActiveFlag,#IFBangding").checkbox('setValue',false);
	$(".hisui-combobox").not("#LocList").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	var valbox = $HUI.validatebox("#RoomCode,#RoomDesc,#RoomSort", {
			required: false,
	    });
	$("#RoomGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindRoom",
			Parref: $("#AreaID").val(),
		});	
	
  var CurSingleStation=tkMakeServerCall("web.DHCPE.CT.RoomManager","GetSingleRoom",LocID);
   $("#SingleStation").combobox('select',CurSingleStation);
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
			ClassName:"web.DHCPE.CT.RoomManager",
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
			{field:'TMainManagerRoomDesc',width:'100',title:'主队列'},
			{field:'TPriorNum',width:'100',title:'优先人数'},
			{field:'TPriorTime',width:'100',title:'优先时间'},
			{field:'TRemark',width:'100',title:'备注'},
				
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RoomID").val(rowData.TID);
				$("#RoomCode").val(rowData.TCode);
				$("#RoomDesc").val(rowData.TDesc);
				$("#RoomSort").val(rowData.TSort);
				$("#Sex").combobox('setValue',rowData.TSex);
				$("#Diet").combobox('setValue',rowData.TDietFlag);
				$("#Emiction").combobox('setValue',rowData.TEmictionFlag);
				$("#Station").combobox('setValues',rowData.TStationID.split(","));
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
					$("#RoomActiveFlag").checkbox('setValue',true);
				}else{
					$("#RoomActiveFlag").checkbox('setValue',false);
				}
				$("#MainManager").combobox('setValue',rowData.TMainManagerRoom);
				$("#PriorNum").val(rowData.TPriorNum);
				$("#PriorTime").val(rowData.TPriorTime);				
			
								
					
		}

			
	})
}



function loadRoomList(rowData){
	$('#RoomGrid').datagrid('load', {
		ClassName:"web.DHCPE.CT.RoomManager",
		QueryName:"FindRoom",
		Parref: rowData.TID
		
	});
	//$('#InvPrtId').val(row.TRowId);
}
/******************************诊室维护界面end********************/

/******************************分区维护界面start********************/

//诊室位置
function BRoomPlace_click(){
	lnk="dhcpe.ct.roomplace.hisui.csp";	
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
	
	
	var iAreaFlag="0";
	var AreaFlag=$("#AreaFlag").checkbox('getValue');
	if(AreaFlag) iAreaFlag="1";
	
	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var Str=Code+"^"+Desc+"^"+Sort+"^"+LocID+"^"+""+"^"+iAreaFlag;
	//debugger; // 
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateArea",AreaID,Str,tableName,LocID,UserID,iActiveFlag);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("提示","修改失败"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("提示","新增失败"+Arr[1],"error");}		
	}else{
		
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});	}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000}); }	
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
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindArea",
			LocID: $("#LocList").combobox("getValue")
			
		});	
   	BRClear_click();
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
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindArea",
			LocID: session['LOGON.CTLOCID']
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:100,title:'分区代码'},
			{field:'TDesc',width:120,title:'分区描述'},
			{field:'TSort',width:40,title:'序号'},
			{field:'TAreaFlag',width:70,align:'center',title:'分区排队',
				formatter: function (value, rec, rowIndex) {
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TActive',width:40,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
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
			$("#MainManager").combobox('reload');
			if(rowData.TAreaFlag=="1"){
					$("#AreaFlag").checkbox('setValue',true);
				}else{
					$("#AreaFlag").checkbox('setValue',false);
				}
			if(rowData.TActive=="Y"){
					$("#ActiveFlag").checkbox('setValue',true);
				}else{
					$("#ActiveFlag").checkbox('setValue',false);
				}			
			
			
			$('#RoomGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			BRClear_click();
			loadRoomList(rowData);
		}
		
			
	})
}

/******************************分区维护界面end********************/


function InitCombobox(){
	
	 var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	  var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	  
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
	
	// 主队列
	var StationObj = $HUI.combobox("#MainManager",{
		url:$URL+"?ClassName=web.DHCPE.CT.RoomManager&QueryName=FindRoomNew&ResultSetType=array&Parref="+$("#AreaID").val(),
		valueField:'TID',
		textField:'TDesc',
		onBeforeLoad:function(param){
			
			param.Parref = $("#AreaID").val();
		},
		onShowPanel:function()
		{
			
			//$('#MainManager').combobox('grid').datagrid('reload');
		}
		}
		)
	
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
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
		multiple:true,
		rowStyle:'checkbox',
		})
	
	
	//单独排队站点
	var SingleStationObj = $HUI.combobox("#SingleStation",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
		onLoadSuccess:function(){
			/// 获取当前科室 单独排队的站点
   			var CurSessionSIngleStation=tkMakeServerCall("web.DHCPE.CT.RoomManager","GetSingleRoom",LocID);
   			$("#SingleStation").combobox('select',CurSessionSIngleStation);
			}
		})	
		

	
	//医生
	   var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=LocID;
			param.hospId=hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:200},
			{field:'DocName',title:'姓名',width:200}
				
		]]
		})
	
	
}

