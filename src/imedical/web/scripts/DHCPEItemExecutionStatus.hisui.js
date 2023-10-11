
//名称    DHCPEItemExecutionStatus.hisui.js
//功能    体检已检未检弃检项目查询
//日期  
//创建人  zhongricheng
$(function() {
	InitCombobox();
	
	$("#BFind").click(function() {  // 体征查询
		BFind_click();
    });
    
    $("#BClear").click(function() {  // 体征查询
		BClear_click();
    });
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatus.raq");
});

function InitCombobox() {
	// 性别
	$HUI.combobox("#Sex", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('不限')},
			{id:'1',text:$g('男')},
			{id:'2',text:$g('女')}
		]
	});
	
	/*
	// 站点
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationByType&Type=NLX&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record) {
			var StationId = record.id;
			var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=" + StationId;
			$("#ItemID").combobox('reload',url);
		},
		onChange:function(newValue, oldValue) {
			var ItemID = $("#ItemID").combobox('getValue');
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#ItemID").combobox('setValue',"");
			}
			if (newValue == "" || newValue == "undefined" || newValue == undefined) {
				var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=";
				$("#ItemID").combobox('reload',url);				
			}
		}
	});
	*/
	 // 站点-多院区
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationByType&ResultSetType=array&Type=NLX&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		onSelect:function(record) {
			 
			 /***切换站点体检项目重新加载***/
			 $("#ItemID").combogrid('setValue',"");
			
			 $HUI.combogrid("#ItemID",{
                onBeforeLoad:function(param){
                   	param.Desc = param.q;
                   	var StationId = record.id;
					param.Station = StationId;
					param.Type="F";
					param.LocID=session['LOGON.CTLOCID'];
					param.hospId = session['LOGON.HOSPID'];

                }
            });
			$('#ItemID').combogrid('grid').datagrid('reload'); 
			 /***切换站点体检项目重新加载***/
			 
        
		},
		onChange:function(newValue, oldValue) {
			var ItemID = $("#ItemID").combogrid('getValue');
			var Flag=tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationFlag",newValue,ItemID,session['LOGON.CTLOCID']);
			if (Flag==0) {
			    $("#ItemID").combogrid('setValue',"");    
			}
		
			
		}
	});
		

	// 总检状态
	$HUI.combobox("#AuditStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('不限')},
			{id:'NA',text:$g('未总检')},
			{id:'A',text:$g('已总检')}
		]
	});
	
	/*
	// 项目
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		}

	});
	*/
	/*
	//项目-多院区
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		}

	});
	*/
//体检项目-多院区
	var ItemObj=$HUI.combogrid("#ItemID", {
		panelWidth:450,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationOrder",
		idField:'id',
		textField:'desc',
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		onBeforeLoad:function(param){
			param.Desc = param.q;
			var StationId=$("#Station").combobox("getValue");
			param.Station = StationId;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
        onShowPanel:function()
		{
			$('#ItemID').combogrid('grid').datagrid('reload');
		},		
		columns:[[
			{field:'Code',title:'编码',width:80},
			{field:'desc',title:'名称',width:180},
			{field:'id',title:'ID',width:80}         		
		]]

	});
	/*
	// VIP等级
	$HUI.combobox("#VIPLevel", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});

	// 诊室位置
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	*/
	
	//VIP等级-多院区 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		 onSelect:function(record){
			VIPLevelOnChange(record.id);
		}
	});

   // 诊室位置(多院区)
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			var VIPID=$("#VIPLevel").combobox("getValue");
			param.VIPLevel =VIPID;
			param.GIType="";
			param.LocID=session['LOGON.CTLOCID'];

		}
	});


	
	// 检查状态
	$HUI.combobox("#ChcekStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('不限')},
			{id:'NC',text:$g('全部未检')},
			{id:'PC',text:$g('部分已检')},
			{id:'AC',text:$g('全部已检')}//,
			//{id:'RC',text:$g('谢绝检查')}
		]
	});
	
	// 项目状态
	$HUI.combobox("#ItemStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('不限')},
			{id:'V',text:$g('核实')},
			{id:'E',text:$g('执行')},
			{id:'R',text:$g('谢绝检查')}
		]
	});
	
	// 查询类型
	$HUI.combobox("#ShowType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'PAADM',text:$g('按人员查询'),selected:true},
			{id:'ITEM',text:$g('按项目查询')}
		]
	});
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}		
		]]
	})
}

function VIPLevelOnChange(){
	
	 var CTLocID=session['LOGON.CTLOCID'];
    
    /***********诊室重新加载********************/
	  $HUI.combobox("#PERoom",{
		onBeforeLoad:function(param){
            var VIPID=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIPID;
            param.GIType = "";
            param.LocID = CTLocID;
        }
	});
		        
    $('#RoomPlace').combobox('reload'); 
    /***********诊室重新加载********************/
}


// 查询
function BFind_click(){
	var BeginDate = "", EndDate = "", Sex = "", VIPLevel = "", Station = "", PERoom = "", AuditStatus = "", ChcekStatus = "", ItemID = "", ItemStatus = "", CurLoc = "", reportName="";
	var BeginDate = $("#BeginDate").datebox('getValue');	
	var EndDate = $("#EndDate").datebox('getValue');
	
	var Sex = $("#Sex").combobox('getValue');
	
	var VIPLevel = $("#VIPLevel").combobox('getValue');
	if (VIPLevel == "undefined" || VIPLevel == undefined) VIPLevel = "";
	
	var Station = $("#Station").combobox('getValue');
	if (Station == "undefined" || Station == undefined) Station = "";
	
	var PERoom = $("#PERoom").combobox('getValue');
	if (PERoom == "undefined" || PERoom == undefined) PERoom = "";
	
	var AuditStatus = $("#AuditStatus").combobox('getValue');
	var ChcekStatus = $("#ChcekStatus").combobox('getValue');
	
	//var ItemID = $("#ItemID").combobox('getValue');
	var ItemID = $("#ItemID").combogrid('getValue');
	if (ItemID == "undefined" || ItemID == undefined) ItemID = "";
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var ItemStatus = $("#ItemStatus").combobox('getValue');
	var ShowType = $("#ShowType").combobox('getValue');
		
	if (ShowType == "PAADM") {
		reportName="DHCPEItemExecutionStatus.raq"
	} else if (ShowType == "ITEM") {
		reportName="DHCPEItemExecutionStatusForItem.raq"		
	}
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Sex=" + Sex
			+ "&VIPLevel=" + VIPLevel
			+ "&Station=" + Station
			+ "&PERoom=" + PERoom
			+ "&AuditStatus=" + AuditStatus
			+ "&ChcekStatus=" + ChcekStatus
			+ "&ItemID=" + ItemID
			+ "&ItemStatus=" + ItemStatus
			+ "&ShowType=" + ShowType
			+ "&GroupDR=" + GroupDR
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + src);
	//$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatusForItem.raq" + src);
}

function BClear_click(){
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$(".hisui-combobox").combobox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
    $("#ItemID").combogrid('setValue',"");
	$("#ShowType").combobox('setValue',"PAADM");
	InitCombobox();
	BFind_click();
}
// 解决iframe中 润乾csp 跳动问题
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}