
//名称	DHCPERoomManagerEdit.hisui.js
//功能	体检诊室调整
//创建	2020.10.16
//创建人  xy

$(function(){
			
	InitCombobox();
	

	$("#RoomPlace").combobox({
		
       onSelect:function(){
			BReload_click();
	}
	});

	$("#BActive").click(function() { 
	
		if($.trim($("#BActive").text())==$g("启用")){
			 ActiveRoom(); 
		}if($.trim($("#BActive").text())==$g("禁用")){
			 UnActiveRoom();
		}
     }); 
  

	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			SetButtonName(vaule);	
			BReload_click();	
			}
			
	});
	
	//刷新
	$("#BReload").click(function() {	
		BReload_click();		
        });  
   
   
     $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			RegNo_click();
			}
	});
  
	//诊室调整
	$("#BRoomAdjust").click(function() {	
		BRoomAdjust_click();		
        });  
   
	//诊室位置改变
	$("#BRoomPlace").click(function() {	
		BRoomPlace_click();		
        }); 
	
	websys_setfocus("RegNo")
	
	SetDefaultRoomPlace();  //默认诊室位置
	
	InitRoomManagerGrid(); 
	
    
})


function RegNo_click()
{ 
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
			"CTLocID":CTLocID
		}, false);
		
			$("#RegNo").val(iRegNo)
	} 
	if (iRegNo=="") {
			$.messager.popover({msg: "请输入登记号", type: "info"});
		   return false;
	}
	
	//是否存在未到达记录，选择到达操作
	var RegisterRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetRegisterRecordNew",iRegNo);
	if (RegisterRecord.split("^")[0]!="0"){
			$.messager.popover({msg: RegisterRecord.split("^")[1], type: "info"});
			return false;
		}
	RegisterRecord=RegisterRecord.split("^")[1];
	//alert(RegisterRecord)
	if (RegisterRecord!="")
	{
			var ArriveRecord="";
			var RecordArr=RegisterRecord.split("^");
			if (RecordArr.length>1){
					OpenRegisterRecord(iRegNo);	
			
			}else{
				
				ArriveRecord=RegisterRecord;
				if(ArriveRecord!=""){
					GetNextRoomInfo(ArriveRecord);
				}
				
			}
			
	}
	else{
			//是否存在未到达记录，选择到达操作
			var ArriveRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetArrivedRecord",iRegNo);
			//alert(ArriveRecord+"ArriveRecord")
			//var ArriveRecord="";
			var RecordArr=ArriveRecord.split("^");
			if (RecordArr.length>1){
					OpenArrivedRecord(iRegNo);	
			
			}else{
				
				//alert(ArriveRecord)
				if(ArriveRecord!=""){
					SetNextRoomInfo(ArriveRecord);
				}
				
			}
		
	}
		

}
var OpenArrivedRecord= function(RegNo){
    
    $HUI.window("#ArrivedRecordWin",{
        title:"就诊信息列表",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var ArrivedPIADMLisObj = $HUI.datagrid("#ArrivedRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.PreIADMEx",
            QueryName:"FindPIADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID'],
			ArrivedFlag:"Y"
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
        	{field:'PIADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'姓名'},
            {field:'RegNo',width:120,title:'登记号'},
            {field:'HPNo',width:120,title:'体检编号'},
            {field:'AdmDate',width:100,title:'日期'},
            {field:'StatusDesc',width:100,title:'状态'},
            {field:'GName',width:200,title:'团体名称'},
            {field:'TeamName',width:120,title:'分组名称'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	       GetNextRoomInfo(rowData.PIADM)
	           
  				}
        
        })
    
}

var OpenRegisterRecord= function(RegNo){
    
    $HUI.window("#RegisterRecordWin",{
        title:"就诊信息列表",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var PIADMLisObj = $HUI.datagrid("#RegisterRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.PreIADMEx",
            QueryName:"FindPIADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID']
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
        	{field:'PIADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'姓名'},
            {field:'RegNo',width:120,title:'登记号'},
            {field:'HPNo',width:120,title:'体检编号'},
            {field:'AdmDate',width:100,title:'日期'},
            {field:'StatusDesc',width:100,title:'状态'},
            {field:'GName',width:200,title:'团体名称'},
            {field:'TeamName',width:120,title:'分组名称'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	       GetNextRoomInfo(rowData.PIADM)
	           
  				}
        
        })
    
}

function GetNextRoomInfo(PIADM)
{
	   //判断是否未付费、是否存在另外未总检的记录
		var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","HadNoGenRecord",PIADM);
		if (ret!=""){
			$.messager.alert("提示",ret,"info"); 
			return false;
		}else{
			var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IAdmArrived",PIADM);
			}
		var ret=tkMakeServerCall("web.DHCPE.RoomManager","InsertRoomByPIADM",PIADM);
		var ret=ret.split("^");
		$("#NextRoomInfo").val(ret[1]);
		BReload_click();
		
}
function SetNextRoomInfo(PIADM)
{
	    
		var ret=tkMakeServerCall("web.DHCPE.RoomManager","InsertRoomByPIADM",PIADM);
		var ret=ret.split("^");
		$("#NextRoomInfo").val(ret[1]);
		BReload_click();
}

//诊室位置改变
function BRoomPlace_click()
{
	//var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEChangeRoomPlace";
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1300,height=640,hisui=true,title=诊室位置改变')
	var lnk="dhcpechangeroomplace.hisui.csp";
	 websys_lu(lnk,false,'width=1270,height=730,hisui=true,title='+$g("诊室位置改变"))

}

//诊室调整
function BRoomAdjust_click()
{
	//var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEAdmRoomRecord";
	var lnk="dhcpeadmroomrecord.hisui.csp"
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1027,height=630,hisui=true,title='+$g("诊室调整"))
	
}

function SetButtonName(vaule)
{
	//alert(vaule)
	if(vaule==true)
	{
		$("#BActive").linkbutton({text:$g("启用")});
	}else{
		$("#BActive").linkbutton({text:$g("禁用")});
	}
	
}


function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}

function Active(ActiveFlag)
{
	
	var ID=""
	 var objtbl = $("#RoomManagerGrid").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPERoomManager")
	    if (TSelect=="1"){
		     if(ID=="") {var ID=objtbl[i].TRoomID;}
		     else{var ID=ID+"^"+objtbl[i].TRoomID;}
		     	   
	    } 
	}

	
	if (ID==""){
		$.messager.alert("提示","请选择诊室","info");
		
		return false;
	}
	var encmeth=GetValue("ActiveRoomClass");
   	for (var j=0;j<ID.split("^").length;j++)
	{
		
		var rtn=cspRunServerMethod(encmeth,ID.split("^")[j],ActiveFlag);
		
		var Arr=rtn.split("^");
		if (Arr[0]=="-1"){
			alert(Arr[1]);
		}
	}
	BReload_click();

}

function BReload_click()
{
	var LocID=session['LOGON.CTLOCID'];
	var iRoomPlace=$("#RoomPlace").combobox('getValue');
	if (iRoomPlace==""){
		$.messager.alert("提示","请选择诊室位置","info")
		return false;
	}
	var iNoActive="Y";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive){iNoActive="N";}
	else{iNoActive="Y";}
	
	$("#RoomManagerGrid").datagrid('load', {
		ClassName: 'web.DHCPE.RoomManager',
		QueryName: 'FindRoomPerson',
		VIPLevel:iRoomPlace,
		NoActive:iNoActive,
		LocID:LocID	
	});
	
}


function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}
function Active(ActiveFlag)
{
	
	var ID=""
	var selectrow = $("#RoomManagerGrid").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		if(ID=="") {var ID=selectrow[i].TRoomID;}
		else{var ID=ID+"^"+selectrow[i].TRoomID;}
	}

	if (ID==""){
		$.messager.alert("提示","请选择诊室","info");	
		return false;
	}
	
   	for (var j=0;j<ID.split("^").length;j++)
	{
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ActiveRoom",ID.split("^")[j],ActiveFlag);
		
		var Arr=rtn.split("^");
		if (Arr[0]=="-1"){
			$.messager.alert("提示",Arr[1],"info");
		}
	}
	BReload_click();
}

function InitRoomManagerGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var iNoActive="Y";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive){iNoActive="N";}
	else{iNoActive="Y";}
	
	$HUI.datagrid("#RoomManagerGrid",{
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
			QueryName:"FindRoomPerson",
			VIPLevel:$("#RoomPlace").combobox("getValue"),
			NoActive:iNoActive,
			LocID:LocID
		},
		frozenColumns:[[
            {title: '选择',field: 'Select',width: 60,checkbox:true},
            {field:'TRoomName',width:300,title:'诊室'}]],
		columns:[[
			{field:'TRoomID',title:'TRoomID',hidden: true},
			{field:'TNewPerson',width:230,title:'等候人数'},
			{field:'TPassPerson',width:230,title:'过号人数'},
			{field:'TWaitMiniute',width:230,title:'等待时间(分钟)'},
			{field:'TDetail',width:220,title:'详情',
				formatter:function(value,rowData,rowIndex){	
					if(rowData.PA_ADMDR!=""){
						return "<a href='#'  class='grid-td-text' onclick=BWaitList("+rowIndex+"\)>"+$g("等候名单")+"</a>";
					}else{return value}
					
			}},
			{field:'TActive',width:100,title:'激活'},	
			
		]]
			
	});
}

function BWaitList(rowIndex)
{
    
    var objtbl = $("#RoomManagerGrid").datagrid('getRows');
    var RoomID=objtbl[rowIndex].TRoomID;
    var RoomDesc=tkMakeServerCall("web.DHCPE.HISUICommon","GetRoomPlaceByID",RoomID);
	var lnk="dhcperoomrecorddetail.hisui.csp"+"?RoomID="+RoomID
		+"&RoomDesc="+RoomDesc
	   ;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=880,height=660,hisui=true,title='+RoomDesc+'--'+$g("等候名单"))
}

function InitCombobox()
{
	//姓名
	   var NameObj = $HUI.combogrid("#Name",{
        panelWidth:690,
        url:$URL+"?ClassName=web.DHCPE.RoomManagerEx&QueryName=SearchRoomDetail",
        mode:'remote',
        delay:200,
        idField:'Hidden',
        textField:'Name',
        onBeforeLoad:function(param){
            param.Name = param.q;
        },
        columns:[[
            {field:'Hidden',hidden:true},
            {field:'RegNo',title:'登记号',width:100},
            {field:'Name',title:'姓名',width:80},
            {field:'Sex',title:'性别',width:60},
            {field:'Age',title:'年龄',width:60},
            {field:'IDCard',title:'证件号',width:100},
             {field:'GroupDesc',title:'单位',width:150},
            {field:'RoomName',title:'诊室名称',width:100},
            {field:'RoomStatus',title:'状态',width:60}

        ]]
        });
        
       //诊室位置
        var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
	        panelWidth:200,
	     	url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        	valueField:'id',
        	textField:'desc'
        })
      
           
        
}

function SetDefaultRoomPlace(){
	var LocID=session['LOGON.CTLOCID'];
    var UseID=session['LOGON.USERID'];
    
	var VIPNV="";
    var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP",UseID,LocID)
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"I");
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    $('#RoomPlace').combobox('reload');

}

