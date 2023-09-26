//===========================================================================================
// 作者：      sufan
// 编写日期:   2018-07-31
// 描述:	   急诊转床
//===========================================================================================
var EpisodeID="";
var WardId="";
var CurrState="";
var PatAllStatus="";   //患者状态
var PAAdmWard="";    //患者当前所在病区
/// 页面初始化函数
function initPageDefault(){
    LoadEpisodeID();          /// 初始化就诊号
    CheckPatStatus();
	InitPageComponent(); 	  /// 初始化界面控件内容
	initCombogrid();
	GetPatBaseInfo();         /// 病人就诊信息
    InitPatBaseBar();         /// 病人就诊信息
	InitPageDataGrid();		  /// 初始化页面datagrid
}
function LoadEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	
}

///验证患者是否能进行转移
function CheckPatStatus(){
	if(PatIsDea()==1){
		$.messager.alert("提示","患者已故！不允许转移操作！","info",function(){
			websys_showModal("close");
		});
	}
}

///判断患者是否已经死亡
function PatIsDea(){
	var retData=0;
	runClassMethod("web.DHCEMNurExecImg","GetPatIsDeath",{"EpisodeID":EpisodeID},function(ret){
		retData=ret
	},'text',false)
	return parseInt(retData); 
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	$("#disPatWin-disStDate").datebox("setValue",formatDate(0));
	$('#disPatWin-disStTime').timespinner('setValue',curTime());
	///急诊病区
	$HUI.combobox("#EmWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	      	var WardId=option.value;
	      	$('#EmBed').combogrid('setValue',"");
	      	$("#EmBed").combogrid('grid').datagrid('load',{WardId:WardId,HospID:LgHospID})
	      	var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetStayStatus", EpisodeID)
			if(ret==-1){
				 $.messager.alert("提示","该病人为输液病人,不能转移！");
			     return false;
			 }
	      	
	    }	
	})
	
	///病人当前状态
	runClassMethod("web.DHCADMVisitStat","GetPatCurStat",{"EpisodeID":EpisodeID},function(jsonString){
		var stat=jsonString.split("^")
		CurrState=stat[1];
		if(stat[1]=="离院"){
			
		}
	},'',false)
	
	///病人所有状态
	runClassMethod("web.DHCEMRotatBed","getPatAllStatus",{"EpisodeID":EpisodeID},function(data){
		PatAllStatus=data;
	},'',false)
	
	///病人当前所在病区
	runClassMethod("web.DHCEMRotatBed","getPatCurWard",{"EpisodeID":EpisodeID},function(data){
		PAAdmWard=data;
	},'',false)
	
	///急诊等级
	runClassMethod("web.DHCEMInComUseMethod","GetEmPatLev",{"EpisodeID":EpisodeID},function(ret){
		$("#EmLevel").val(setCellLabel(ret)); //hxy 2020-02-20
	},'text',false)

}

function initCombogrid()
{
	
	var url = LINK_CSP+'?ClassName=web.DHCEMRotatBed&MethodName=jsonEmPatBed&WardId='+WardId+"&HospID="+LgHospID;
	
	///  定义columns
	var columns=[[
		{field:'BedId',title:'BedId',width:100,hidden:true},
		{field:'WardId',title:'WardId',width:100,hidden:true},
		{field:'BedCode',title:'床号',width:80},
		{field:'BedFlag',title:'状态',width:60,hidden:true,formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:red;font-weight:bold;">有人</font>'}
				else {return '<font style="color:green;font-weight:bold;"></font>'}
			}
		},
		{field:'WardDesc',title:'病区',width:150},
		{field:'RoomCode',title:'病房',width:100},
		{field:'BedType',title:'床位类型',width:80},
		{field:'RoomType',title:'病房类型',width:100,hidden:true}
	]];
	
	$('#EmBed').combogrid({
			url:url,
			editable:false,
			panelHeight:260,   
		    panelWidth:500,
		    idField:'BedId',
		    textField:'BedCode',
		    columns:columns,
		    pagination:true,
		   	pageSize:50,
		    pageList:[50,100,150],
	        onSelect: function (rowIndex, rowData) {
		        if (rowData.BedFlag == "Y"){
			        $.messager.alert("提示","该床位已有病人，请选择其他床位！");
		    		$('#EmBed').combogrid('setValue',"");
		        }
        	}
	});
}
///安排转床35000212---------------------------
function Update()
{
	var BedId=$('#EmBed').combogrid('getValue');    //床号
	var WardId=$HUI.combobox("#EmWard").getValue();    //病区ID
	if(BedId=="")
	{
		$.messager.alert("提示","请选择床位！");
		return false;
	}
	
	///控制离院患者，不能进行转床 2018-10-17  sufan
	if((CurrState=="离院")||(CurrState=="入院")||(CurrState=="转院")||(CurrState=="死亡"))    
	{
		$.messager.alert("提示","离院、入院、死亡状态的患者，不能进行此操作！")
		return false;
	}
	
	if(WardId=="")
	{
		$.messager.alert("提示","请选择急诊病区！");
		return false;
	}
	
	var WardDesc=$HUI.combobox("#EmWard").getText();    //病区
	var QuitFlag = serverCall("web.DHCEMVisitStat", "JudgePatCurRecord", { 'EpisodeID':EpisodeID});
	if(QuitFlag=="Y")
	{
		$.messager.alert("提示","患者正在急诊病区床位，不能再次入观察室或监护室！");
		return false;
	}
	//var param =LgUserID+"^"+BedId+"^"+WardId+"^"+EpisodeID+"^"+stDate+"^"+stTime+"^"+""+"^"+"";
	if((PAAdmWard=="")||((PAAdmWard!="")&&(PAAdmWard!=WardDesc)))
	{
		if(WardDesc=="急诊观察室")
		{
			var StatCode="InObservationRoom";
			changestatus(BedId,WardId,WardDesc,StatCode);    ///改变患者状态并安排床位
			insertGroupReceipt();//
		}else if(WardDesc=="急诊监护室")
			{
				var StatCode="InMonitoringRoom";
				changestatus(BedId,WardId,WardDesc,StatCode);    ///改变患者状态并安排床位
				insertGroupReceipt();//
			}
		if(WardDesc=="急诊初诊室(红区)")
		{
			changepatBed(BedId,WardId);      ///分配床位
		}
		
		///插入病案号
		//insertGroupReceipt();
	}
	if((PAAdmWard!="")&&(PAAdmWard==WardDesc))
	{
		 changepatBed(BedId,WardId);      ///分配床位
	}
}
///改变状态并安排床位
function changestatus(BedId,WardId,WardDesc,StatCode)
{
	var stDate = GetCurSysDate(0);
	var stTime = getCurTime();
	runClassMethod("web.DHCADMVisitStat","InsertVis",
		{"EpisodeID":EpisodeID,"visStatCode":StatCode,"avsDateStr":stDate,
		"avsTimeStr":stTime,"userId":LgUserID,"wardDesc":WardDesc,"cancelFlag":0},
		function(retStr){
			if (retStr != ""){
				if (retStr != 0) {
					alert(retStr); //alert("插入病人状态错误!");
					return;
				}else {
						runClassMethod("web.DHCEMObsRoomSeat","MoveAdm",{"EpisodeID":EpisodeID,"UserID":LgUserID,"WardID":WardId,"BedID":BedId,"EditPreTrans":"Y"},
						function(data){
							if (data==="0") {
								$.messager.alert("提示","安排成功！","",function()
								{
									window.close();
								});		
							}else{
									$.messager.alert("提示",data+"！");
									return;
								}
						},'text',false)
				}

			}
		},'',false)
}
///只切换床位
function changepatBed(BedId,WardId)
{
	runClassMethod("web.DHCADTTransaction","MoveAdm",{"EpisodeID":EpisodeID,"userId":LgUserID,"wardDescOrId":WardId,"bedId":BedId,"editPreTrans":"Y"},
		function(data){
			if (data==="0") {
				$.messager.alert("提示","安排成功！","",function()
				{
					window.close();
				});
			}else{
					$.messager.alert("提示",data+"！");
					return;
				}
		},'text',false)
}
/// 获取系统日期
function GetCurSysDate(offset){

	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate;
}
///获取当前时间
function getCurTime()
{
	///时间
	var myDate = new Date();
	//var mytime=myDate.toLocaleTimeString(); //获取当前时间
	var hh=myDate.getHours();
	if(hh<10){  hh = "0"+hh;}
	var mm=myDate.getMinutes()
	if(mm<10){  mm = "0"+mm;}
	var ss=myDate.getSeconds();
	if(ss<10){  ss = "0"+ss;} 
	return hh+":"+mm+":"+ss
	
}

///生成病案号接口
function insertGroupReceipt()
{
	runClassMethod("DHCWMR.SSService.ReceiptSrv","GroupReceipt",{"aEpisodeID":EpisodeID,"aMrNo":"","aLocID":LgCtLocID,"aUserID":LgUserID,"aNoTypeID":"101||1"},
	function(jsonString){

		if (jsonString != ""){
			//alert(jsonString)
		}
	},'',false)
	
}

/// 病人就诊信息  bianshuai 2019-01-24
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMRotatBed","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		
		var jsonObject = jsonString;
		$('input[name="PatInfo"]').each(function(){
			$(this).val(jsonObject[this.id]).attr("disabled","disabled");
		})
		
	},'json',false)
}

/// 转移病人  bianshuai 2019-01-24
function TransPatWardBed(BedId,WardId){

  var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetStayStatus", EpisodeID)
   if(ret==-1){
	   $.messager.alert("提示","该病人为输液病人,不能转移！");
		return false;
	  
    }
	runClassMethod("web.DHCADTTransaction","MoveAdm",{"EpisodeID":EpisodeID,"userId":LgUserID,"wardDescOrId":WardId,"bedId":BedId,"editPreTrans":"Y"},
		function(data){
			if (data==="0") {
				if (window.opener){
					//window.opener.postMessage("刷新急诊床位图","http://172.21.235.1");
					window.opener.postMessage("刷新急诊床位图","http://"+window.location.host);
				}
				$.messager.alert("提示","安排成功！","",function(){
					window.parent.top.frames[0].location.reload();
					window.parent.top.websys_showModal("close");
				});
			}else{
					$.messager.alert("提示",data+"！");
					return;
				}
		},'text',false)
}

/// 安排转床  bianshuai 2019-01-24
function TrsWardBed(){
	
	var WardId=$HUI.combobox("#EmWard").getValue();    //病区ID
	if (typeof WardId == "undefined") WardId = "";
	if(WardId==""){
		$.messager.alert("提示","请选择急诊病区！");
		return false;
	}
	
	/// 床位为空转移到对应病区的等候区 bianshuai 2019-01-25
	var BedId=$('#EmBed').combogrid('getValue');    //床号
//	if(BedId==""){
//		$.messager.alert("提示","请选择床位！");
//		return false;
//	}

	/// 控制离院患者，不能进行转床 2018-10-17  sufan
	if((CurrState=="离院")||(CurrState=="入院")||(CurrState=="转院")||(CurrState=="死亡")){
		$.messager.alert("提示","患者已离院，不能进行此操作！")
		return false;
	}

	/// 转移病区床位时，是否考虑特殊病区病人状态变更？？？？
	if((BedId||"") == ""){
		$.messager.confirm('确认对话框','您未选择床位，是否将病人转移至等候区？', function(r){
			if (r){
				TransPatWardBed(BedId,WardId);      /// 分配床位
			}
		});
	}else{
		TransPatWardBed(BedId,WardId);      /// 分配床位
	}
}


/// 病人就诊信息
function InitPatBaseBar(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
	},'json',false)
}

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'StartDate',title:'开始日期',width:100,align:'center'},
		{field:'StartTime',title:'开始时间',width:100,align:'center'},
		{field:'EndDate',title:'结束日期',width:100,align:'center'},
		{field:'EndTime',title:'结束时间',width:100,align:'center'},
		{field:'Ward',title:'入院病区',width:100,align:'center'},
		{field:'PatBed',title:'床号',width:100,align:'center'},
		{field:'User',title:'操作人',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //数据加载完毕事件
	    	
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMRotatBed&MethodName=JsonQryPatTrsHis&EpisodeID="+ EpisodeID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
}

//hxy 2020-02-20
function setCellLabel(value){
	if(value.indexOf("1级")>-1){value="Ⅰ级";}
	if(value.indexOf("2级")>-1){value="Ⅱ级";}
	if(value.indexOf("3级")>-1){value="Ⅲ级";}
	if(value.indexOf("4级")>-1){value="Ⅳa级";}
	if(value.indexOf("5级")>-1){value="Ⅳb级";}
	return value;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })