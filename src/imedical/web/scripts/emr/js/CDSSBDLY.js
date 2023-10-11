var data="";
/// 调用CDSS函数
InvokeCDSS=function(cdss_data){
	data=cdss_data
	parent.getWebsysCDSS().refresh(data);
}		

//var cdssFlag = false;
function CDSSBDLY(){
	
	this.init=function(){
		    
		//如果基础平台对接后，仅在病历中使用，基础平台不初始化时放开注释代码
		//parent.initWebsysCDSS();
		
		//监听事件
		parent.getWebsysCDSS().on('cdss-evt', function(evt, response) {
		 	var newEMRData = updateEMRData(response);		
		});

	}
	
	
	
	this.getData=function(param,actionType){
		var _this=this;
		var action=actionType.toUpperCase();
		if(action==="DELETE") return
		var docId = param.emrDocId	
		var instanceID = param.id
		
		var param="AEpisodeID:"+episodeID+",AUserLocID:"+userLocID+",AUserID:"+userID+",AInstanceID:"+param.id+",ADocID:"+docId+",AAction:"+action+",AType:"+"I"+",ACdssTool:CDSSBD,AHospitalID:"+setting.hospitalID
		jQuery.ajax({
			type: "get",
			dataType: "json",
			url: '../EMRservice.BOCDSSService.cls',
			async: false,
			data: {
				"action":"GetCDSSData",
				"param":param
			},
			success: function(d) {
				if(d.success==1){
					
					var cdss_data=d.message;
					
					InvokeCDSS(cdss_data);
				}
			},
			error : function(d) { 
				console.log(d);
				alert("CDSSBD error");
			}
		});
	}
}




//数据回写
function receive(data)
{
  if(typeof data === "undefined") return
  if(typeof insertText != "undefined")
  {
      insertText(data);
  }else if(window.frames["framRecord"] !=undefined && window.frames["framRecord"].insertText != undefined)
  {              
    window.frames["framRecord"].insertText(data+" ");
  }            
}


function updateEMRData(response) {
	
	if (response.type=="detail")
	{
		var detailurl=response.data

		var iWidth = 960;                         //弹出窗口的宽度;
		var iHeight = 600;                        //弹出窗口的高度;
		 
		var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
		var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
		  
		window.open(detailurl,"明细信息",'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no');

	}
	
}

    
function diagnoses(icddesc,icdcode,type)
{
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLCDSSBDService",
				"Method":"InterfaceDiagnoses",			
				"p1":episodeID,
				"p2":icddesc,
				"p3":icdcode,
				"p4":type
			},
		success : function(d) {
	       		console.log(d)
		},
		error : function(d) { alert("BDCDSS error");}
	});	
}