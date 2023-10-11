
// 提醒功能
// jquery.js,websys.jquery.js
$(function(){
	var rollTimes = 120*1000,DefaultPosition="bottom:10px;left:10px;";
	if ("undefined"!=typeof websysAlertCfg){
		if (websysAlertCfg.rollTime) rollTimes = websysAlertCfg.rollTime*1000;
		if (websysAlertCfg.DefaultPosition) DefaultPosition = websysAlertCfg.DefaultPosition;
	}
	
	var setTimeoutTimer = "";
    var colors = ['red','blue','yellow'];
    window.closeBSPAlert = function(t){
        $('.bsp-alert').hide();
        clearTimeout(setTimeoutTimer);
        setTimeoutTimer = "";
        setTimeoutTimer = setTimeout(alertShow,rollTimes);
    }
	window.reloadBSPAlert = function(t){
		clearTimeout(setTimeoutTimer);
		alertShow();	
	}
    var genSingleLiHtml = function(item){  // 一记录对应一提醒
        var htmlArr = [];
        for (var j=0;j<item.rows.length;j++) {
            htmlArr.push("<li class='"+item.bgcls+"'>");
            htmlArr.push("<span>【"+item.alertType+"】</span>");
            htmlArr.push("<span>");
            if (item.rows[j].link) {  //有链接才打开
            	htmlArr.push("<a class='bsp-alert-item-btn' href='javascript:void(0)' onclick='websys_lu(\""+item.rows[j].link+"\",0,\""+"width="+(item.oWidth||500)+"px,height="+(item.oHeight||600)+"\")'>");
	        }else{
            	htmlArr.push("<a class='bsp-alert-item-btn bsp-alert-item-btn-nolink' style='cursor: text;' href='javascript:void(0)' onclick='return false;'>");
		    }
            htmlArr.push(item.rows[j].desc+"</a>");
            htmlArr.push("</span>");
            if(item.isShowClose=='1') htmlArr.push('<a class="bsp-alert-item-close"></a>');  //关闭按钮
            htmlArr.push("</li>");
        }
        return htmlArr.join(""); 
    }
    var genMutilLiHtml = function(item){  //多记录合一提醒
        var htmlArr = [];
        htmlArr.push("<span>【"+item.alertType+"】"+item.alertTitle+"</span>"); 
        htmlArr.push("<div>");
        for (var j=0;j<item.rows.length;j++) {
            if (j!==0) htmlArr.push("、");
            if (j>4){
				htmlArr.push("...");
				break;
			}
			if (item.rows[j].link) { //有链接才打开
				htmlArr.push("<a class='bsp-alert-item-btn' href='javascript:void(0)' onclick='websys_lu(\""+item.rows[j].link+"\",0,\""+"width="+(item.oWidth||500)+"px,height="+(item.oHeight||600)+"\")'>");
			}else{
				htmlArr.push("<a class='bsp-alert-item-btn bsp-alert-item-btn-nolink' style='cursor: text;' href='javascript:void(0)' onclick='return false;'>");
			}
            htmlArr.push(item.rows[j].desc+"</a>");
        }
        htmlArr.push("</div>");
        return htmlArr.join("");
    }
    var alertShow = function(){
	    
        $cm({ClassName:"CF.BSP.MSG.SRV.AlertAction",MethodName:"GetAlert",UserId:"",GroupId:"",LocId:""},function(rtn){
			if ($('.bsp-alert').length==0){
				$('<div class="bsp-alert" style="'+DefaultPosition+'"></div>').appendTo('body');
			}
            if(rtn.success){
	            var htmlArr =[],audioFiles=[],rowCount=0; //提醒个数 当个数为0 提醒悬浮
	            htmlArr.push("<div class='bsp-alert-tool'><span class='bsp-alert-dd'>按住拖动</span><a href='javascript:void(0)' onclick='closeBSPAlert();'>关闭</a><a href='javascript:void(0)' onclick='reloadBSPAlert();'>刷新</a></div>");
				htmlArr.push("<lu class='bsp-alertlist'>");
	            htmlArr.push("<lu>");
				if ($(".bsp-alert lu.bsp-alertlist").length==0){
					$(".bsp-alert").html("").append(htmlArr.join(""));
					console.log("add tool list");
				}
				htmlArr = [];
				for (var i=0;i<rtn.rows.length;i++){
	                var item = rtn.rows[i];
	                if (item.rows &&item.rows.length>0) { //此类型有数据 才进行显示面板 2022-08-01
		                if (item.sshow=="S"){
		                    htmlArr.push(genSingleLiHtml(item));
		                }else{
		                    htmlArr.push("<li class='"+item.bgcls+"'>");
		                    htmlArr.push(genMutilLiHtml(item));
		                    if(item.isShowClose=='1') htmlArr.push('<a class="bsp-alert-item-close"></a>');  //关闭按钮
		                    htmlArr.push("</li>");
		                }     
		                rowCount=rowCount+item.rows.length ; //提醒个数累加      
	                }
	                if (item.audioName &&item.rows &&item.rows.length>0 && audioFiles.indexOf(item.audioName)==-1 ) {  // 音频文件名
		                audioFiles.push(item.audioName)
		                
		            }   
	            }
	            
	            if (typeof playAudioFiles=='function' && audioFiles.length>0 ) {
		            playAudioFiles(audioFiles);
		        }
	            
	            
	            $(".bsp-alert lu.bsp-alertlist").html("").append(htmlArr.join(""));
	            if (rowCount>0) {
		            $(".bsp-alert").show(2000);
		        }else{
			        $(".bsp-alert").hide();
			    }
				
				
				$(".bsp-alert").off('click.bspalert').on('click.bspalert','.bsp-alert-item-close',function(){  //列表项关闭按钮事件
					$(this).closest('li').remove();
					if ($('.bsp-alert lu.bsp-alertlist>li').length==0){
						$(".bsp-alert").hide();
					}
				}).on('click.bspalert','.bsp-alert-item-btn',function(){ //列表项显示按钮（xx床、xxx人）点击事件
					if($(this).hasClass('bsp-alert-item-btn-nolink')){ //如果没链接
						//$.messager.popover({msg:'没有相应链接',type:'info'})	
					}	
				})
				
				
	            $('.bsp-alert-dd').unbind('mousedown').mousedown(function(e) {
                    var positionDiv = $(this).offset();
                    var distenceX = e.pageX - positionDiv.left;
                    var distenceY = e.pageY - positionDiv.top;
					var maxX = $(document).width() - $('.bsp-alert').outerWidth(true);
					var maxY = $(document).height() - $('.bsp-alert').outerHeight(true);
					$('.bsp-alert').css('height',$('.bsp-alert').height() + 'px');
                    $(document).mousemove(function(e) {
                        var x = e.pageX - distenceX;
                        var y = e.pageY - distenceY;
                        if (x < 0) {
                            x = 0;
                        } else if (x > maxX) {
                            x = maxX;
                        }
						if (y < 20) {
                            y = 20;
                        } else if (y > maxY) {
                            y = maxY;
                        }
                        $('.bsp-alert').css({
                            'left': x + 'px',
                            'top': y + 'px'
                        });
                    });
                    $(document).mouseup(function() {
                        $(document).off('mousemove');
                    });
                });
            }else{
	            $(".bsp-alert").hide();
	        }
	        setTimeoutTimer = setTimeout(alertShow,rollTimes);
        });
    }
    setTimeoutTimer =setTimeout(alertShow,2000);
});