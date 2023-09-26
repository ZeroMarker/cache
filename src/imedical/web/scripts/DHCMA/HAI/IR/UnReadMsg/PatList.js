//页面Gui
var obj = new Object();
$(function () {
	obj.EpisodeID = "";
	gridPatList(); //加载患者明细
	InitPatList();
});

function InitPatList(){	
	var HsopID = $.LOGON.HOSPID;
	var UserID = $.LOGON.USERID;
	var User = $.LOGON.USERDESC;
	Common_ComboToSSHosp("cboHospital",HsopID);
	
	//医院表格联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(data){
			$('#divMain').empty();
			$('#aDateFrom').datebox('setValue',Common_GetCalDate(-31));
			$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
			gridPatListLoad();
		}
	});
	
	//日期改变事件
	$('#aDateFrom').datebox({
		onChange: function(newValue, oldValue){
			var aDateTo = $('#aDateTo').datebox('getValue');
			if (Common_CompareDate(newValue,aDateTo)>0) {
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于结束日期',
					position:'bottom'
				}).show();
				return;
			}
			if (Common_CompareDate(newValue,Common_GetDate(new Date()))>0) {
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于当前日期',
					position:'bottom'
				}).show();
				
				return;
			}
			$HUI.tooltip("#DateTip").destroy();
			$('#divNoResult').attr("style","display:block");		
			gridPatListLoad();        //重新加载患者明细		
		}
	});
	
	//日期改变事件
	$('#aDateTo').datebox({	
		onChange: function(newValue, oldValue){
			var aDateFrom = $('#aDateFrom').datebox('getValue');
			if (Common_CompareDate(aDateFrom,newValue)>0) {	
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于结束日期',
					position:'bottom',
					hideDelay: 1000
				}).show();
				return;
			}
			$HUI.tooltip("#DateTip").destroy();
			$('#divNoResult').attr("style","display:block");
			gridPatListLoad();        //重新加载患者明细			
		}
	});
}
 //加载表格
function gridPatList() {
	$HUI.datagrid("#gridPatList",{
		fit: true,
		title: '患者列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		remoteSort:false,   //本地数据排序必须设置为false
		sortName:'LocDesc',
		sortOrder:'desc',
		loadMsg:'数据加载中...',
		columns:[[
			{field:'LocDesc',title:'科室名称',width:120},
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:60}, 
			{field:'CurrBed',title:'床号',width:50,align:'center',
				styler: function(value,row,index){
					if (row.IsNeedAtt==1) {  //需关注
						return 'background-color:#CCFFFF';	
					}
				}	
			},
			{field:'LocUnRead',title:'消息',width:40,align:'center',
				formatter: function(value,row,index){
					if ((row.LocUnRead=='1')&&(row.AdminUnRead=='0')) { //院感科消息，科室未阅读
						return "<a style='position: relative;' class='icon-have-message hisui-tooltip' title='临床科室未阅读院感科消息'>&nbsp;&nbsp;&nbsp;&nbsp;<span style='position: absolute;color:red;bottom:5px;font-size:8px;'>未</span></a>"   //院感科消息，科室未阅读
					} 
					if((row.LocUnRead=='0')&&(row.AdminUnRead=='1')) { //院感科消息，科室未阅读
						return "<a style='position: relative;' class='icon-send-msg hisui-tooltip' title='院感科未阅读科室消息'>&nbsp;&nbsp;&nbsp;&nbsp;<span style='position: absolute;color:red;bottom:5px;font-size:8px;'>未</span></a>" //科室消息，临床未阅读;							
					} 
					if((row.LocUnRead=='1')&&(row.AdminUnRead=='1')) { //院感科消息、科室消息未阅读
					   return "<a style='position: relative;' title='院感科、临床未阅读消息'><img src='../scripts/DHCMA/HAI/img/消息-选中.png'></a>"
					}
				}	
			},	
			{field:'NeedRepCnt',title:'需上报',width:55,align:'center'},
			{field:'VisitStatus',title:'状态',width:50,align:'center'}
		]]
		,onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
			if (rindex>-1) {
				var rData = $('#gridPatList').datagrid('getRows')[rindex];
				obj.EpisodeID = rData.EpisodeID;
				gridPatList_onSelect(obj.EpisodeID);
			}	
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
}
	
//加载患者明细
function gridPatListLoad(){
	$("#gridPatList").datagrid("loading");
	$cm ({
		ClassName:'DHCHAI.IRS.CCMessageSrv',
		QueryName:'QryUnReadMsg',
		aHospIDs:$('#cboHospital').combobox('getValue'),
		aDateFrom:$('#aDateFrom').datebox('getValue'), 
		aDateTo:$('#aDateTo').datebox('getValue'), 		
		page:1,      //可选项，页码，默认1			
		rows:999    //可选项，获取多少条数据，默认50
	},function(rs){
		$('#gridPatList').datagrid('loadData', rs);				
	});
}

//加载单个患者消息
 function gridPatList_onSelect(aEpisodeID){	
	if (!aEpisodeID) return;
	
	loadingWindow();
	$('#divNoResult').attr("style","display:none");
	$('#Message').attr("style","border:1px solid #ccc;border-radius:4px;");
	window.setTimeout(function () { 
		MsgLoad(aEpisodeID); //加载单个患者消息
		disLoadWindow(); 
	}, 100); 
	$.parser.parse('#divCenter');   //渲染本层不可以，只有渲染父层
}

//加载患者消息
function MsgLoad(aEpisodeID){		
	var Msghtml="";		
	obj.Msg = $cm({
		ClassName:'DHCHAI.IRS.CCMessageSrv',
		QueryName:'QryMsgByPaadm',
		aPaadm:aEpisodeID
	},false);
	
	if (obj.Msg.total>0) {
		$('#divMessage').empty();

		for (var i=0;i<obj.Msg.total;i++){
			var rd = obj.Msg.rows[i];	
			if ((rd.CSMsgType==1)||(rd.CSMsgType==3)) {
				Msghtml += ' <div id="patMsgType1" class="right_message">'
						+ ' 	<div class="MessTitle">'
						+ '     	<span>'+rd.MTitle+'</span>'
						+ '     </div>'
						+ '     <div class="MessDtl">'	
						+ '			<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
						+ ' 		<div class="message">'
						+ '     	    <div class="left message-green">'
						+ '					<div class="message-arrow"></div>'				
						+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
						+ '     		</div>'
						+ '     	</div>'	
						+ ' 		<div style="display: inline-block;">'
						+ ' 			<div class="icon-doctor-green-pen" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #16BBA2;border-radius: 15px;"></div>'
						+ '     	</div>'
						+ '     </div>'
						+ ' </div>'				
			}else {
				Msghtml += ' <div id="patMsgType2" class="left_message">'
						+ ' 	<div class="MessTitle">'
						+ '     	<span>'+rd.MTitle+'</span>'
						+ '     </div>'
						+ '     <div class="MessDtl">'
						+ ' 		<div style="display: inline-block;">'
						+ ' 			<div class="icon-person" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #509DE1;border-radius: 15px;"></div>'									
						+ '     	</div>'
						+ ' 		<div class="message">'
						+ '     	    <div class="right message-blue">'
						+ '					<div class="message-arrow"></div>'				
						+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
						+ '     		</div>'
						+ '     	</div>'	
						+ ' 		<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
						+ '     </div>'
						+ ' </div>'
			}
		}
	
		$('#divMessage').append(Msghtml);	
		return true;
	}			
}

//阅读消息
$('#btnRead').on('click', function(){
	btnRead_click(obj.EpisodeID);
});
 //发送消息
$('#btnSend').on('click', function(){
	btnSend_click(obj.EpisodeID);
});
//发送消息更多
$('#btnMSend').on('click', function(){
	btnMSend_click(obj.EpisodeID);
});
		
 //阅读消息
btnRead_click = function (EpisodeID) {
	// MsgType 1院感、2临床
	var MsgType=1;
	if (LocFlag==1) MsgType=2;
	
	var retval  = $m({
		ClassName:"DHCHAI.IRS.CCMessageSrv",
		MethodName:"ReadMessage",
		aEpisodeID:EpisodeID, 
		aUserID:$.LOGON.USERID, 
		aTypeCode:MsgType
	},false);

	if (parseInt(retval)>0){
		MsgLoad(EpisodeID); //刷新单个患者消息
		$.messager.popover({msg: '消息阅读成功！',type:'success',timeout: 2000});
	}else if(parseInt(retval)==0) {
		$.messager.popover({msg: '无未读消息需阅读！',type:'info',timeout: 2000});
	}else  {
		$.messager.popover({msg: '消息失败！',type:'error',timeout: 2000});
	}	
}

//发送消息
btnSend_click = function (EpisodeID) {
	// MsgType 1院感、2临床
	var MsgType=1;
	if (LocFlag==1) MsgType=2;
	
	var MsgTxt= $('#txtMessage').val().replace(/\^/g,"").replace(/\r?\n/g,"<br />");
	var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");	
	if (parseInt(retval)>0){
		MsgLoad(EpisodeID); //刷新单个患者消息
		$('#txtMessage').val('');
		$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
	} else {
		$.messager.alert("提示", "消息发送失败！", "info");
	}
}

//发送消息更多	
btnMSend_click = function (EpisodeID) {
	var MsgType=1;
	if (LocFlag==1) MsgType=2;
	
	obj.MMsg = $cm({
			ClassName:'DHCHAI.BTS.DictionarySrv',
			QueryName:'QryDic',
			aTypeCode:"CCScreenMessage",
			aActive:1
	},false);
	
	var htmlMMsg='<div id="ulqMsg" style="text-align:right;">';
	for (var j=0;j<obj.MMsg.total;j++){
		var rd = obj.MMsg.rows[j];	
		var message=rd["DicDesc"];
		htmlMMsg += '<li style="list-style:none;" text="'+message+'"><a href="#" style="color:blue">'+message+'</a></li>';
	}
	htmlMMsg +='</div>';
	$('#btnMSend').popover({
		width:'300px',
		height:'200px',
		content:htmlMMsg,
		trigger:'hover',
		placement:'left',
		type:'html'
	});
	$('#btnMSend').popover('show');  
	
	$('#ulqMsg').delegate("li","click",function(e) {
		e.preventDefault();
		var MsgTxt = $(this).attr("text");
		var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");
		if (parseInt(retval)>0){					
			MsgLoad(EpisodeID); //刷新单个患者消息
			$('#txtMessage').val('');
			$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
		} else {
			$.messager.alert("提示", "消息发送失败！", "info");
		}
	});
}	

//保存消息
obj.Msg_Save=function(ID,EpisodeID,MsgType,MsgTxt,IsRead){	
	var CSEpisodeDr = EpisodeID;
	var CSMsgType   = MsgType;  // 1院感、2临床
	var CSMsgDate   = "";
	var CSMsgTime   = "";  //时间
	var CSMsgUserDr = $.LOGON.USERID;
	var CSMsgLocDr  = $.LOGON.LOCID;  
	var CSMessage   = MsgTxt;
	var CSIsRead    = IsRead;
	var CSReadDate  = "";
	var CSReadTime  = "";
	var CSReadUserDr = $.LOGON.USERID;		
	
	if (CSMessage == '') {
		$.messager.alert("提示", "消息内容不允许为空！", "info");
		return -1;
	}
	
	var InputStr = ID;
	InputStr += "^" + CSEpisodeDr;
	InputStr += "^" + CSMsgType;
	InputStr += "^" + CSMsgDate;
	InputStr += "^" + CSMsgTime;
	InputStr += "^" + CSMsgUserDr;
	InputStr += "^" + CSMsgLocDr;
	InputStr += "^" + CSMessage;
	InputStr += "^" + CSIsRead;
	InputStr += "^" + CSReadDate;
	InputStr += "^" + CSReadTime;
	InputStr += "^" + CSReadUserDr;

	var retval  = $m({
		ClassName:"DHCHAI.IR.CCMessage",
		MethodName:"Update",
		aInputStr:InputStr,
		aSeparete:'^'
	},false);
	return retval;
}
 

//弹出加载层
function loadingWindow() {	
	var left = ($(window).outerWidth(true)) / 2; 
	var top = ($(window).height() - 35) / 2; 
	var height = $(window).height() * 2; 
	$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
	$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
}

//取消加载层  
function disLoadWindow() {
	$(".datagrid-mask").remove();
	$(".datagrid-mask-msg").remove();
}
