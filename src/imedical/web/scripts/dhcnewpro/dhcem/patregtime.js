//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-11-01
// 描述:	   修改病人挂号时间 JS
//===========================================================================================

var EpisodeID = "1";     /// 就诊ID

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	initMethod();      /// hxy 2020-03-26 日期时间控制
	GetPatRegTime();   /// 取病人就诊时间
}

/// 初始化页面参数
function InitParams(){
	
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
}

/// 取病人就诊时间
function GetPatRegTime(){

	runClassMethod("web.DHCEMPatCheckLev","GetPatRegTime",{"EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$HUI.datebox("#admDate").setValue(jsonObject.admDate);       /// 就诊日期
			$HUI.timespinner("#admTime").setValue(jsonObject.admTime);   /// 就诊时间
		}else{
			$.messager.alert('错误提示',"取病人就诊时间错误,请重试！");
			return;	
		}
	},'json',false)
}

function initMethod(){
	//日期控制
	$('#admDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	var now = new Date();
    var MaxTime= now.getHours()+':'+(now.getMinutes()+1);
    $('#admTime').timespinner({
	    max: MaxTime
	});
}

/// 保存
function sure(){
	
	var admDate = $HUI.datebox("#admDate").getValue();       /// 就诊日期
	var admTime = $HUI.timespinner("#admTime").getValue();   /// 就诊时间
	if(admDate==""){
		window.parent.$.messager.alert("提示:","就诊日期不能为空！","warning");
		return;
	}
	
	if(admTime==""){
		window.parent.$.messager.alert("提示:","就诊时间不能为空！","warning");
		return;
	}
	
	var mParams = admDate +"^"+ admTime;
	runClassMethod("web.DHCEMPatCheckLev","modPatRegTime",{ "EpisodeID":EpisodeID , "mParams":mParams},function(jsonString){
		
		if (jsonString < 0){
			window.parent.$.messager.alert("提示:","修改失败！","warning");
		}else{
			window.parent.$.messager.alert("提示:","修改成功！","warning",function(){
				closewin();	/// 关闭
			});
		}
	},'',false)
}

/// 关闭
function closewin(){
	websys_showModal('close'); //hxy 2020-03-27 st
	//commonParentCloseWin(); //注释ed
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
