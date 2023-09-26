var HMmayson="";
var _globalCdssData = "";
var loadType="";
var _paramNow="";
function HMCDSS(){
	//初始化
	this.init=function(data){
		var _this = this;
		var cdssData=data.message;
		try{
			if(loadType==="m"){
				if(typeof HmCupid =="undefined")return
					//客户端对接
					HmCupid.connect(cdssData,function(conn){
						_this.receiveData(conn,cdssData.customEnv);
						if(_globalCdssData !="" && _globalCdssData !=undefined){
							HmCupid.send(_globalCdssData);
							_globalCdssData="";
						}
					})
			}else if(loadType==="c"){
				if(typeof HM =="undefined")return
				//浮窗对接方案
					HM.maysonLoader(cdssData, function (conn) {
						HMmayson=conn;
						//设置接入住院版浮窗对接方案
						conn.setDrMaysonConfig(cdssData.flag,cdssData.customEnv);

						// 回写监听
						conn.listenViewData = function (data) {
							_this.receiveData(data,loadType);
						};
						if(_globalCdssData !="" && _globalCdssData !=undefined){
							HMmayson.setMaysonBean(_globalCdssData);
							HMmayson.ai();
							_globalCdssData="";
						}
				});	
			}
		}catch(err){
			cdssLock="N";
		}	
		
	},
	//调用第三方接口传数据
	this.sendData=function(maysonData){
		try{
			if(loadType=="m"){
		    	if(typeof HmCupid == "undefined"){
					_globalCdssData = maysonData;
				}else{
					HmCupid.send(maysonData);
					_globalCdssData="";
				}
			}else if(loadType=="c"){
				if(HMmayson==""||typeof HMmayson=="undefined"){
					_globalCdssData = maysonData;
				}else{
					HMmayson.setMaysonBean(maysonData);
					HMmayson.ai();
					_globalCdssData="";
				}
			}	
		}catch(err){
			cdssLock ="N";
		}
	
	},
	//病历操作取数据
	this.getData=function(param,actionType){
		var _this=this;
		_paramNow=param;
		var action=actionType.toUpperCase();
		var instanceId = param.id;
		var paramter =  "AEpisodeID:"+episodeID+",AUserID:"+userID+",ADocID:"+param.emrDocId+",AInstanceID:"+instanceId+",AAction:"+action+",AType:"+cdssEpisodeType
		jQuery.ajax({
			type: "post",
			dataType: "json",
			url: '../EMRservice.BOCDSSService.cls',
			async: false,
			data: {
				"action":"GetCDSSData",
				"param":paramter
			},
			success: function(d){
				if(d.success==1){
					_this.sendData(d.message);
				}
			},
			error: function(d){console.log("取病历数据出错");}
		});
		
	},
	//回写数据
	this.receiveData=function(data,loadType){
		
		if(loadType=="m"){
			//客户端加载回写
			HmCupid.receive(function(data){
				var entity = data ;
				for(var i=0; i<entity.entity.length; i++){
					var str= "";
					if (entity.entity[i].items.length>0)
					{
						for(var j=0; j<entity.entity[i].items.length; j++)
						{
							str += entity.entity[i].items[j].text+",";
						}
					}
					if (entity.entity[i].type == '11')
					{

						window.open(str,'_blank','width=90%,height=90%');	
					}
					else
					{  
						if(typeof insertText != "undefined"){
							insertText(str);
						}else if(window.frames["framRecord"].insertText != undefined){
							window.frames["framRecord"].insertText(str+" ");
						}
					}
				}	
			})
		}else if(loadType=="c"){
			//浮窗回写
			for(var i=0;i<data.length;i++){
				var perData=data[i];
				var str= "";
				if(perData.type==11){//type=11:惠每文献，返回url路径
					if(perData.items){
						for(var j=0;j<perData.items.length;j++){
							window.open(perData.items[j].text,'_blank');
						}
					}
				}else{//文献外的其他类型，直接做回显处理
			
					if(perData.items){
						for(var j=0;j<perData.items.length;j++){
							str +=perData.items[j].text+",";
						}
					}
					if(typeof insertText != "undefined"){
						insertText(str);
					}else if(window.frames["framRecord"].insertText != undefined){
						window.frames["framRecord"].insertText(str+" ");
					}
				}
			}
		}
		
		
	}
}
//医生站初始化完成调用
function HMCDSSLoad(){
	cdssLock="Y";
	HMmayson = parent.HMObj.Hm_mayson;
	HMmayson.listenViewData=function(data){
		if(episodeType=="I"||episodeType=="E"){
			//住院走医生站回写
			var titleObj =parent.GetCurSelectedTab();
			if(titleObj.parentTitle=="病历文书"){
				cdssTool.receiveData(data,loadType);
			}
		}else{
			var titleName = parent.GetCurSelectedTab();
			//门诊走医生站回写
			if(titleName=="门诊病历"){
				cdssTool.receiveData(data,loadType);
			}
		}
	}
	if(typeof _paramNow !="undefined" && _paramNow !="" && typeof cdssTool != "undefined"){
		cdssTool.getData(_paramNow,"Save");
	}
		
}