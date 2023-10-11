$(function () {
	var welcomeText = document.getElementById("welcome");
	var startText = document.getElementById("start");
	var frameObj = document.getElementById("frameBrowse");
	var timer = "";
	$("#startBtn").click(function(){
	 	$("#startBtn").linkbutton("disable");
	 	$("#stopBtn").linkbutton("enable");
		startText.setAttribute("style","display:inline");
		welcomeText.setAttribute("style","display:none");
		//启动
		setFrameContent();	
		});
 	$("#stopBtn").click(function(){
	 	$("#startBtn").linkbutton("enable");
	 	$("#stopBtn").linkbutton("disable");
	 	startText.setAttribute("style","display:none");
		welcomeText.setAttribute("style","display:inline");
	 	if(timer){
	 		clearTimeout(timer);
	 	}
	 	});
	function setFrameContent(){
		var instanceId,srcStr;
		instanceId = getInstanceId();
		srcStr = "";
		if (instanceId !== undefined && instanceId !== "" && instanceId !== "0") {
			//srcStr ="../service/browser/index.html?instanceId="+ instanceId +"&actType=server"+"&isExport=true";
			srcStr ="../form.htm?TPSID=APP0001&USERNAME=ys01&instanceId="+ instanceId +"&actType=server"+"&isExport=true";
			frameObj.setAttribute("src",srcStr);

			//判断上一次页面有没有加载完,加载完则调用清除上一次延时器，调用新的延时器
			if(frameObj.attachEvent){
			  	frameObj.attachEvent("onload",function(){	
					clearTimeout(timer);
					//递归调用
					timer = setTimeout(setFrameContent,1000);				  
				  });
			}else{
				frameObj.onload=function(){
					clearTimeout(timer);
					//递归调用
					timer = setTimeout(setFrameContent,1000);
				}	  
			}
		}else{
			clearTimeout(timer);
			//递归调用
			timer = setTimeout(setFrameContent,6000);
		}
	}
	//同步获取后台instanceId,后台获取instanceId，阻塞浏览器进程
	function getInstanceId() {
		var res = "";
		var strType= "Wait";
		if ($('#FailureRadios')[0].checked)
		{
			strType = "Failure"
		}
		$.ajax({
			type:'GET',
		    url:'EMRservice.Ajax.BLBrowseCommon.cls',
		    data:{
				Class:'EMRservice.BOExportQueue',
				Method:'GetExeInstanceID',
				p1:strType,
				p2:"ALL",
				p3:"HTML",
				p4:"",
				OutputType:''
			},
		    dataType:'text', 
		    async:false,
		    success:function(ret){
			    res = ret;
			    },
			error:function(ret){
				}
		});
		return res;
	}
	
});

