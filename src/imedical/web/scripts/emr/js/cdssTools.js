///智能诊断工具   相关参数
var cdssTool;
var userName=userName||"";
var hospitalID=hospitalID || "";
var cdssLock="N";
var cdssType="";
var episodeType="";
var cdssEpisodeType="";
var loadEMR="Y";
var loadJSDKFlag = false;
if(typeof episodeID==undefined){
	var episodeID="";
	var patientID="";
	var userID="";
	var userLocID="";
}
(function(){
	if(typeof patInfo != "undefined"){
		userID = patInfo.UserID;
    	userLocID = patInfo.UserLocID;
		patientID = patInfo.PatientID;
		episodeID = patInfo.EpisodeID;
		userName = patInfo.UserName;
		hospitalID = patInfo.HospitalID;
		if(episodeID==""){
			var frm = top.document.forms['fEPRMENU'];
    			episodeID = frm.EpisodeID.value;
    			patientID = frm.PatientID.value;	
		}
	}
	if(typeof setting != "undefined"){
		userID = setting.userId;
		userLocID = setting.userLocId;
		patientID = setting.patientId;
		episodeID = setting.episodeId;
		hospitalID = setting.hospitalID;
	}
})();
window.onload=function(){
	initCDSSData(episodeID,patientID);
}
//初始化第三方CDSS
function initCDSSData(EpisodeID,PatientID){
	episodeID=EpisodeID;
	patientID=PatientID;
	if(episodeID=="") {
		cdssLock = "Y";
		return	
	}
	var paramter = "AEpisodeID:"+episodeID+",AUserLocID:"+userLocID+",AHospitalID:"+hospitalID+",AuserID:"+userID+",APatientID:"+patientID
	jQuery.ajax({
		type: "post",
		dataType: "json",
		url: '../EMRservice.BOCDSSService.cls',
		async: false,
		data: {
			"action":"GetOptions",
			"param":paramter
		},
		success: function(d){
			if(d.success==1){
				//初始化数据成功	
				cdssLock="Y";
				cdssType=d.args.cdssType;
				episodeType=d.args.episodeType;
				cdssEpisodeType=d.args.CDSSEpisodeType;
				loadCDSS(d);
			}else{
				cdssLock="N";	
			}
		},
		error: function(){
			console.log("初始化出错");
			cdssLock ="N";	
		}
	})
	
}
//匹配第三方CDSS 加载对应函数对象
function loadCDSS(data){
	if(cdssType=="HM"){
			if(typeof HMCDSS == "undefined"){
				cdssLock = "N";
			}else{
				cdssTool = new HMCDSS();
				loadType = data.args.loadType;	
				if(parent.HMObj == undefined){
					if(!loadJSDKFlag){
						//加载JSDK
						var cdssHMUrl=data.args.cdssHMUrl;
						loadScript(cdssHMUrl,function(){
								cdssTool.init(data);
								loadEMR = "Y";
								loadJSDKFlag=true;
						})
					}else{
						cdssTool.init(data);
						loadEMR = "Y";	
					}	
				}else{
					HMObj = parent.HMObj;
					if(HMObj.Hm_mayson == undefined){
						if(!loadJSDKFlag){
							var cdssHMUrl=data.args.cdssHMUrl;
							loadScript(cdssHMUrl,function(){
								cdssTool.init(data);
								loadEMR = "Y";
								loadJSDKFlag=true;
							})
						}else{
							cdssTool.init(data);
							loadEMR = "Y";	
						}
					}else{
						//惠每注册走医生站 医生站注册完了回调HMCDSSLoad()
						//loadEMR "Y" 病历初始化  "N" 其他方的初始化
						loadEMR = "N";
					}
				}
			}
	}
	else if(cdssType=="BD"){
		if(typeof BDCDSS == "undefined"){
				cdssLock = "N";
			}else{
				cdssTool = new BDCDSS();
				cdssTool.init();
			}
	}else if(cdssType=="DH"){
		if(typeof DHCDSS == "undefined"){
			cdssLock = "N";
		}else{
			cdssTool = new DHCDSS();
		}
	}else{
			cdssLock ="N";
	}
}
/*当前日期时间*/
function getCurrentDateTime()
{
	var date = new Date();
	var m = date.getMonth() + 1;
	var time = date.getFullYear() + "-" + m + "-"+ date.getDate() + " " + date.getHours() + ":"+ date.getMinutes() + ":" + date.getSeconds();
	return time;	
}
//动态脚本引入外部JS
function loadScript(url,callback){
    var script= document.createElement("script");
    script.type= "text/javascript";
    //绑定加载完毕的事件
    if(script.readyState){
        script.onreadystatechange= function(){
            if(script.readyState=== "loaded" ||script.readyState === "complete"){
                callback&&callback();
            }
        }
    }else{
        script.onload= function(){
            callback&&callback();
        }
    }
    script.src= url;
  	document.getElementsByTagName("head")[0].appendChild(script);
}