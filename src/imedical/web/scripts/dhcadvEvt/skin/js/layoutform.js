$(document).ready(function(){
	//创建一个console对象
	textAreaListener(); //2018/1/10 textarea回车不换行
	window.console = window.console || (function () {  
    	var c = {}; 
    	c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile  = c.clear = c.exception = c.trace = c.assert = function () { };  
    	return c;  
	})();
	$.extend($.fn.validatebox.defaults.rules, {
			valDate: {
				validator: function(value){
					 
				     date = $.trim(value);
				     var year, month, day;
				     //yyyy-mm-dd
				     var reg = /^(\d{4})-(\d{2})-(\d{2})$/;
				     
				     var regDateTime=/^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;
				     //dd/mm/yyyy
				     var reg2 = /^(\d{2})([\/])(\d{2})([\/])(\d{4})/;
				     

				     if (!reg.test(date)) {
					     if(regDateTime.test(date)){
						     year = parseInt(date.split("-")[0], 10);
				     	  	 month = parseInt(date.split("-")[1], 10);
				     	  	 day = parseInt(date.split("-")[2], 10);
						  }else{
							  year = parseInt(date.split("/")[2], 10);
				     	  	  month = parseInt(date.split("/")[1], 10);
				     	  	  day = parseInt(date.split("/")[0], 10);
							  
						  }	

   
				     }else{
					   	  year = parseInt(date.split("-")[0], 10);
				     	  month = parseInt(date.split("-")[1], 10);
				     	  day = parseInt(date.split("-")[2], 10);
					 }
				     

				     console.log("year:"+year)
				     console.log("month:"+month)
				     console.log("day:"+day)

				     
				     if (! ((1 <= month) && (12 >= month) && (31 >= day) && (1 <= day))) {
				         return false;
				     }
				     if ((month <= 7) && ((month % 2) == 0) && (day >= 31)) {
				         return false;
				     }
				     if ((month >= 8) && ((month % 2) == 1) && (day >= 31)) {
				         return false;
				     }
				     if (month == 2) {
				         if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))) {
				             if (day > 29) {
				                 return false;
				             }
				         } else {
				             if (day > 28) {
				                 return false;
				             }
				         }
				     }
				     return true;
				},
				message: '日期格式不对.'
			}
	})
		
		
	$(".combo").each(function(){
		value=$(this).prev().attr("data-value-complex-select");
		if($(this).prev().attr("data-type-complex-select")=="complex-select"){
			if(value==""){
				$(this).hide();
			}
			
		}
	});

	$("#btn").on("click",function(){
		if(checkRequired()){
			runClassMethod(
			"web.DHCADVFormRecord",
			"SaveRecord",
			{'user':LgUserID,
			 'formId':$("#formId").val(),
			 'formVersion':$("#formVersion").val(),
			 'par':loopStr("#from"),
			 'recordId':$("#recordId").val()},
			function(data){ 
				 alert(data)
			},"text")
		};
	})
	
	//setTimeout(function(){
		$("#HPVPatHis > div:nth-child(2)").css("margin-top","10px")
	//},400);
	
	//hxy 09-14 不良事件的tooltip  2018-11-09 cy  修改panel 提示显示文字
	 $('.dhcc-panel-titleimg').tooltip({   
	   position: 'top',   
	   //content: '<span style="color:#fff;padding-left:5px">患者一般资料。</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({ 
	      color:'#fff', 
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 /*$('.dhcc-panel-titleimg:eq(1)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">事件资料记实。</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:eq(2)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">事件基本信息填写。</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:eq(3)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">事后处理记录。</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:last').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">事件发生情况。</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }}); */
	 
	 //不良事件四个级别 
	 $('#AdvLevel-label-center,#AdvLevel-rightlabel').css("cursor","pointer");
	 //$('#AdvLevel-label-center,#AdvLevel-rightlabel,#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-11 > div > div > span > span > span').tooltip({   
	 $('#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-11 > div > div > span > span > span,#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-2 > div > div > span > span > span').tooltip({   
	   position: 'right',   
	   content: '<div style="color:#fff;padding:5px;font-size:14px;width:666px"><span><span style="color:red">I级-警讯事件</span>&nbsp;&nbsp;是指在诊疗服务和医院工作过程中，'+
	          '患者或员工等非预期死亡，或是与疾病无关的四肢、器官等重要功能的永久性丧失。</span><div style="height:10px"></div>'+
	          '<span><span style="color:#FFB12A">II级-不良后果事件</span>&nbsp;&nbsp;是指在诊疗服务和医院工作过程中，'+
	          '是因诊疗活动和医院工作而非疾病本身造成的患者或员工等机体与功能的损害。</span><div style="height:10px"></div>'+
	          '<span><span style="color:#FBD085">III级-未造成后果事件</span>&nbsp;&nbsp;是指在诊疗服务和医院工作过程中，'+
	          '虽然发生了错误的事实，但未对机体与功能造成任何损害，或仅有轻微后果，不需要任何处理，可完全康复。</span><div style="height:10px"></div>'+
	          '<span><span style="color:#75CCFF">IV级-隐患事件</span>&nbsp;&nbsp;是指在诊疗服务和医院工作过程中，'+
	          '有错误，由于及时发现而杜绝，未形成事实或有潜在风险，但无损害的事实，未造成后果。</span>'+
	          '</div> ',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	    }//,
	    
	 });	 
	


	
	loadCssFile();//yuliping 根据浏览器版本，加载checkbox radio样式
 	closePanle();//yuliping 弹出层关闭按钮初始化。
 	closePanleS();//yuliping 弹出层关闭按钮初始化。    
    
	comboboxSelect();
	
	//ie 8 上传图片用此方法
 	/*$("#disIframe").load(function() {
        var body = $(window.frames['disIframe'].document.body);
        var ret=""
        if(window.addEventListener){ 
			ret=body[0].textContent;
		}
		if(window.attachEvent){ 
			ret=body[0].innerHTML
		}
		retArr=ret.split("^")
		if(retArr[0]==0){
			$("#picPath").val(retArr[1]);
			alert("上传成功!")
		}else{
			alert("上传失败!")
		}
    })
    
     $('#file_upload').uploadify({
   　　 swf:'../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
 　　　 uploader:'dhcadv.upload.csp?act=upload',
  		buttonText: '选择图片',
  		buttonClass:'dhcc-btn',
  		width:'130px',
  		onUploadSuccess: function(file,data,respone){
                retArr=data.split("^")
                if(retArr[0]==0){
	                $("#picPath").val(retArr[1]);
	                ip=retArr[2]
	                imgurl="http://"+ip+"/ftpsci/"+retArr[1];
	                html="<img src='"+imgurl+"'  onClick='viewPic(this)' data-id='"+imgurl+"' width='150px' height='150px' >"
	                html=html+"<a class='easyui-linkbutton l-btn l-btn-small l-btn-plain'  onclick='javascript:removePic()'><span class='l-btn-left l-btn-icon-left'><span class='l-btn-text'>删除</span><span class='l-btn-icon icon-remove'>&nbsp;</span></span></a>"
	            	$("#picViewDiv").html(html)    
	            }else{
		         	alert("上传失败!")   
		        }    
        }
    }) */
	
	//add_event();
	initLableInput();
});
function uploadPic(obj,id){
	  file=$(obj).val();
	  var filename=file.replace(/.*(\/|\\)/, ""); 
	  var fileExt=(/[.]/.exec(filename)) ? /[^.]+$/.exec(filename.toLowerCase()) : '';


      //image/gif,image/jpeg,image/jpg,image/png,image/svg  
      if(fileExt!='gif'&&fileExt!='jpeg'&&fileExt!='jpg'&&fileExt!='png'&&fileExt!='svg'&&fileExt!='bmp'){  
            $.messager.alert("提示","您上传的文件不符合图片格式，请上传图片(gif/jpeg/jpg/png/svg/bmp)。")    
            return;  
      }
      if($("#picViewDiv"+id).find("img").length>0){
	      $.messager.confirm('提示','已上传图片，是否要覆盖原图片?',function(r){
    			if (r){
					$(obj).parent().find("input[name='ext']").val(fileExt)
	  				$(obj).parent().submit();
    		    }
		  }); 
	  }else{
		    $(obj).parent().find("input[name='ext']").val(fileExt)
	  		$(obj).parent().submit(); 
	  }


}
function dbClickLegend(obj){
		$(obj).removeClass("legend-img-gotop"); 
		$(obj).addClass("legend-img-gobottom"); 
}
function showPre(obj){
	

	type=$(obj).attr('type')
	if(type=='radio'){
		
		var name=$(obj).attr('name');  //2018-01-02  每次点击radio后，点击菜单会弹出窗口，这个跨年还在困扰着的问题，根源是没有加 var   (??_??) (??_??) (??_??)    cy 修改
		//radio 删除其他未选中子元素html
		$("input[name='"+name+"'][type=radio]").each(function(){
			var id=$(this).attr("data-id")
			$("#"+id.replace(".","-")).html("");	
		})
		$("input[name='"+name+"'][type=radio]").next().next().hide();
		$(obj).next().next().show();
		/// radio移除其他元素子元素的勾选
		$("input[id^="+$(obj).parent().attr("data-parref")+"]").each(function(){
			if((this.id!=$(obj).attr('id'))&($('#'+this.id).is(':checked'))){
				$('#'+this.id).removeAttr("checked");
			}
		})
		
	}else{
		if($(obj).attr("checked")=="checked"){
			$(obj).next().next().show();    //如果元素为隐藏,则将它显现
		}else{
			$(obj).next().next().hide();     //如果元素为显现,则将其隐藏
		}
	}
	childCorrelParentCheck(obj);

	initLableInput()
}
function showPreDatebox(obj){
	
	type=$(obj).attr('type')
	
	if(type=='radio'){
		name=$(obj).attr('name')
		$("input[name='"+name+"'][type=radio]").next().next().next().hide();
		$(obj).parent().next().next().show();
	}else{
		//alert($(obj).attr("checked"))
		if($(obj).attr("checked")=="checked"){
			$(obj).parent().next().next().show();    //如果元素为隐藏,则将它显现
		}else{
			$(obj).parent().next().next().hide();     //如果元素为显现,则将其隐藏
		}
	}

}

function showCombox(obj){
	
	if($(obj).parent().next().next().is(":hidden")){
	      $(obj).parent().next().next().show();    //如果元素为隐藏,则将它显现
	}else{
	      $(obj).parent().next().next().hide();     //如果元素为显现,则将其隐藏
	}	
}


function addRow(obj,id,formId){
	
	runClassMethod(
		"User.DHCADVFormHelp",
		"getSubDatagrid",
		{'id':id,
		 'formId':formId},
		 function(data){
		  	$(obj).parent().parent().parent().parent().append(data)
		  	$.parser.parse($(obj).parent().parent().parent().next().children().last())
		  	$.parser.parse($(obj).parent().parent().parent().children().last())
			add_event();
		},"text",false);
}
function removeRow(obj){
	$.messager.confirm("提示", "是否进行删除操作", function (res) {//提示是否删除
		if (res) {
			$(obj).parent().parent().remove()	
		}
	})
		
	
}
function selec_change(obj,dicId,formId,parref){
		
		runClassMethod(
		"web.DHCADVFormDic",
		"writeSubDic",
		{'id':dicId,
		 'formid':formId},
		 function(data){
			id=formId+"-"+parref;
			$("#"+id).html(data);
			//comboboxSelLoc(); //qunianpeng 2018/1/10 感觉这个调用没什么用,注释了，否则这个方法里面里会清除掉url的地址
		  	//$(obj).next().next().next().remove();
		  	//$(obj).parent().append(data)
			//alert(data)
			//$.parser.parse($(obj).next().next().next().children().last())
			try{
						$.parser.parse($("#"+id));
			
						$("#"+id+" .combo").each(function(){
							value=$(this).prev().attr("data-value-complex-select");
							if($(this).prev().attr("data-type-complex-select")=="complex-select"){
								if(value==""){
									$(this).hide();
								}
								
							}
						});
			}catch(e){
				alert(e.message)
			}
			runClassMethod(
				"web.DHCADVFormDic",
				"getDicHiddenValue",
				{'dic':dicId},
				 function(data){
					id="#label"+formId+"-"+parref;
					$(id).html(data);
			 },"text");
		},"text");
		
}

function checkbox_change(obj,dicId,formId,parref){
		

	
		if($(obj).attr("checked")==undefined){
			id=formId+"-"+parref;
			$("#"+id).html("");
		}else{
			runClassMethod(
			"web.DHCADVFormDic",
			"writeSubDic",
			{'id':dicId,
			 'formid':formId},
			 function(data){
				id=formId+"-"+parref;
				$("#"+id).html(data);
				try{
				$.parser.parse($("#"+id));
				
						$("#"+id+" .combo").each(function(){
							value=$(this).prev().attr("data-value-complex-select");
							if($(this).prev().attr("data-type-complex-select")=="complex-select"){
								if(value==""){
									$(this).hide();
								}
							}
						});
				}catch(e){
					alert(e.message)
				}
			},"text");
		}
		
		setTimeout(function(){
			var str=formId+"-"+parref;
			if(str=="160137-91698"){
				$('#160137-91698 span[class="combo datebox"]').css("display","none");
			}else if(str=="160137-91703"){
				$('#160137-91703 span[class="combo datebox"]').css("display","none");
			}else if(str=="160137-91708"){
				$('#160137-91708 span[class="combo datebox"]').css("display","none");
			}else if(str=="160137-91713"){
				$('#160137-91713 span[class="combo datebox"]').css("display","none");
			}else if(str=="160137-91718"){
				$('#160137-91718 span[class="combo datebox"]').css("display","none");
			}
			//var str="'"+"#"+formId+"-"+parref+' span[class="combo datebox"]'+"'"
			//$(str).css("display","none");
			//$('#160137-91697 span[class="combo datebox"]').css("display","none");
  		},90);/*hxy 2017-11-07 checkbox-date的初始化未勾选显示日期框调整为不显示（药品不良事件）*/


		
}
function popModel(dic,formid,title){
	
	
	runClassMethod(
	"web.DHCADVFormDic",
	"writeSubDic",
	{'id':dic,
	 'recordId':$("#recordId").val(),
	 'formid':formId},
	 function(data){
		try{
			title="<i class='fa fa-file-text' style='margin-left:10px;'></i>"+title
			$("#popModalTitle").html(title)
			$("#popModalContent").html(data)
			$.parser.parse($("#popModalContent"));
		}catch(e){
			alert(e.message)
		}
	},"text");
	$("#fullbg").css({ 
		height:$("body").height(), 
		width:$("body").width(), 
		display:"block" 
	}); 
	$("#hiddenbox").css({
	      height:850,
	      width:$("body").width()-400,
	      display:"block" 
	    }); 

}
function closePanle(){
	$(".box-close").click(function(){
	   	$("#hiddenbox").animate({
	      height:'150px',
	      width:'150px',
	      display:''
	    });
	    $('#hiddenbox').hide();
	    $("#fullbg").hide();
	});

	}

function closePopModal(){
	
		$("#hiddenbox").animate({
	      height:'150px',
	      width:'150px',
	      display:''
	    });
	    $('#hiddenbox').hide();
	    $("#fullbg").hide();
}	
function loadCssFile(){
	
	var rtn=serverCall("ext.util.String","GetIEVersion");

	if (rtn!="IE11"){	
	var link = document.createElement('link');
	link.type = 'text/css';
	link.rel = 'stylesheet';
	link.href = '../scripts/dhcadvEvt/skin/css/checkboxie8.css';
	document.getElementsByTagName("head")[0].appendChild(link);
		return;
	}else{
	var link = document.createElement('link');
	link.type = 'text/css';
	link.rel = 'stylesheet';
	link.href = '../scripts/dhcadvEvt/css/checkandradio.css';
	document.getElementsByTagName("head")[0].appendChild(link);
			
	}
}


function checkRequired(){
	
	ret =true;
	$("#from").find("em").html("*");
	var obj="",type="",newlinetype="",inlinetype="";//2019-03-01 cy 修改子元素与父元素同行显示时必填校验不好用的问题
	$("label[data-requried='Y']").each(function(){
		newlinetype=$(this).next().find("input").first().attr("type"); //子元素与父元素换行显示
		inlinetype=$(this).find("input").first().attr("type"); //子元素与父元素同行显示
		if((newlinetype!=undefined)&&(newlinetype!="")){
			obj=$(this).next();
			type=newlinetype;
		}
		if((inlinetype!=undefined)&&(inlinetype!="")){
			obj=$(this);
			type=inlinetype;
		}
		var id=$(this).attr("id")
		if(type=="checkbox"){
		  if($("input[type=checkbox]", obj).length>0){
			if($("input[type=checkbox]:checked", obj).length==0){
				
				$("#"+id).find("em").html("*该项为必填项");
				if(ret){
					$("html,body").stop(true);$("html,body,#mainpanel").animate({scrollTop: $("#"+id).offset().top}, 1000);	
				}
				ret=false;
			}
			
		  };	
		}
		if(type=="radio"){
			if($("input[type=radio]", obj).length>0){
				if($("input[type=radio]:checked", obj).length==0){
					$("#"+id).find("em").html("*该项为必填项");
					if(ret){
						$("html,body").stop(true);$("html,body,#mainpanel").animate({scrollTop: $("#"+id).offset().top}, 1000);	
					}
					ret=false;
				}
				
			};
		}	
		
	})
	if(!ret)return ret;
	ret=$("#from").form('validate');
	if(!ret)return ret;	
	
	ret=requiredHideInput();// yuliping 隐藏输入框必填验证

	if(!ret)return ret;
	//alert($(".validatebox-text.validatebox-invalid:first").parent().html())
	//alert(ret)
	return ret;
}
///回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
function comboboxSelect(){

	$('#PartyLoc').combobox({
	filter: function(q, row){
		var opts = $(this).combobox('options');
		return row[opts.textField].indexOf(q) >= 0;
	}
	});
	
	
}
function comboboxSelLoc(){

	$('#Loc').combobox({
	filter: function(q, row){
		var opts = $(this).combobox('options');
		return row[opts.textField].indexOf(q) >= 0;
	}
	});
}

function viewPic(obj){
	window.open($(obj).attr('data-id'))	
}

function popSelect(obj,dic,formId){
	$("#currentPopSelect").val($(obj).attr("data-dic-field"))
	runClassMethod(
	"web.DHCADVFormDic",
	"writeSubDic",
	{'id':dic,
	 'recordId':$("#recordId").val(),
	 'formid':formId},
	 function(data){
		try{
			title="<i class='fa fa-file-text' style='margin-left:10px;'></i>"
			$("#popModalTitleSmall").html(title)
			$("#popModalContentSmall").html(data)
			$.parser.parse($("#popModalContentSmall"));
		}catch(e){
			alert(e.message)
		}
	},"text");
	$("#fullbg").css({ 
		height:$("body").height(), 
		width:$("body").width(), 
		display:"block" 
	}); 
	$("#hiddenboxSmall").css({
	      height:500,
	      width:$("body").width()-900,
	      display:"block" 
	    });
}
function closePanleS(){
	$(".box-closes").click(function(){
		closePanleSmall();
		});
	}
function closePanleSmall(){
		var ret=new Array()
		var target = $("#popModalContentSmall");
		// radio
		var ipts = jQuery("input[name][type=radio]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				if((jQuery(this).attr("data-type")==undefined)||("radio-input"==jQuery(this).attr("data-type"))){ 
					var name = jQuery(this).attr('name');
					if(jQuery(this).prop('checked')) {
							ret.push(jQuery(this).val());
							return false;
					}
				}
			});
		}
		id=$("#currentPopSelect").val()
		$("input[name='"+id+"']").val(ret.join("^"))
	
   	$("#hiddenboxSmall").animate({
      height:'150px',
      width:'150px',
      display:''
    });
    $('#hiddenboxSmall').hide();
    $("#fullbg").hide();
	
	
}

function checkbox_inline_change(obj,dicField,formId,parref){
		//lable93972
		id=dicField
		if($(obj).attr("checked")==undefined){
			$("label[data-parref='"+id+"']").hide()
		}else{
			$("label[data-parref='"+id+"']").css("display","inline-block");
			$("label[data-parref='"+id+"']").show()
		}	
		doOther(obj);
		
}

function removePic(){
	$("#picViewDiv").html("");
	$("#picPath").val("");
}
function removePic(formId,dicId){
	$.messager.confirm('提示','确定要删除图片吗？', function(r){
       if(r){
	         fileName=$("input[data-img-id='"+formId+"-"+dicId+"']").val()	
		   runClassMethod(
			"web.DHCADVFormUploadPic",
			"DelFile",
			{'FileName':fileName,},
			 function(data){
				$("#picViewDiv"+formId+"-"+dicId).html("");
				$("input[data-img-id='"+formId+"-"+dicId+"']").val("")
			},"text")
	   }
    });	
}

/********************************获取某一天是否为节假日 周末***************************************/

var CalendarData = new Array(20);
var madd = new Array(12);
var TheDate;
var weekString = "日一二三四五六";
var cYear;
var cMonth;
var cDay;
var cHour;
var cDateString;
var DateString;
function initCalendars() {
  CalendarData[0] = 0x41A95; //公元2001年;
  CalendarData[1] = 0xD4A;
  CalendarData[2] = 0xDA5;
  CalendarData[3] = 0x20B55;
  CalendarData[4] = 0x56A;
  CalendarData[5] = 0x7155B;
  CalendarData[6] = 0x25D;
  CalendarData[7] = 0x92D;
  CalendarData[8] = 0x5192B;
  CalendarData[9] = 0xA95;
  CalendarData[10] = 0xB4A;
  CalendarData[11] = 0x416AA;
  CalendarData[12] = 0xAD5;
  CalendarData[13] = 0x90AB5;
  CalendarData[14] = 0x4BA;
  CalendarData[15] = 0xA5B;
  CalendarData[16] = 0x60A57;
  CalendarData[17] = 0x52B;
  CalendarData[18] = 0xA93;
  CalendarData[19] = 0x40E95;
  madd[0] = 0;
  madd[1] = 31;
  madd[2] = 59;
  madd[3] = 90;
  madd[4] = 120;
  madd[5] = 151;
  madd[6] = 181;
  madd[7] = 212;
  madd[8] = 243;
  madd[9] = 273;
  madd[10] = 304;
  madd[11] = 334; //今年某月已过天数！
  
}
function GetBit(m, n) {
  return (m >> n) & 1;
} //n月是大月还是小月?

function e2c(TheDate) {
  
  var total, m, n, k;
  var isEnd = false;
  var tmp = TheDate.getYear();
  if (tmp < 1900) tmp += 1900; //无用！
  total = (tmp - 2001) * 365 + Math.floor((tmp - 2001) / 4) + madd[TheDate.getMonth()] + TheDate.getDate() - 23; //2001年1月23是除夕;该句计算到起始年正月初一的天数
  if (TheDate.getYear() % 4 == 0 && TheDate.getMonth() > 1) total++; //当年是闰年且已过2月再加一天！
  for (m = 0;; m++) {
    k = (CalendarData[m] < 0xfff) ? 11 : 12; //起始年+m闰月吗？
    for (n = k; n >= 0; n--) {
      if (total <= 29 + GetBit(CalendarData[m], n)) //已找到农历年!
      {
        isEnd = true;
        break;
      }
      total = total - 29 - GetBit(CalendarData[m], n); //寻找农历年！
    }
    if (isEnd) break;
  }
  cYear = 2001 + m; //农历年
  cMonth = k - n + 1; //农历月
  cDay = total; //农历日
  if (k == 12) //闰年！
  {
    if (cMonth == Math.floor(CalendarData[m] / 0x10000) + 1) //该月就是闰月！
    cMonth = 1 - cMonth;
    if (cMonth > Math.floor(CalendarData[m] / 0x10000) + 1) cMonth--; //该月是闰月后某个月！
  }
  cHour = Math.floor((TheDate.getHours() + 1) / 2);
}
function GetcDateString() {
  var tmp = "";
  
  tmp +=cMonth;
  tmp += "-";
  tmp += cDay;

  cDateString = tmp;
  return tmp;
}

function getWeeks(data){
	runClassMethod(
	"web.DHCADVAction",
	"GetHoliday",
	{'date':data},
	function(data){ 
 		if(data==0){
			$("#DateOccuType").combobox("setValue","工作日")
	 		$("#DateOccuType").combobox("setText","工作日")
	 	}	
	 	if(data==1){
			$("#DateOccuType").combobox("setValue","节假日")
		 	$("#DateOccuType").combobox("setText","节假日")
		}
		if(data==2){
			$("#DateOccuType").combobox("setValue","周末")
			$("#DateOccuType").combobox("setText","周末")
		}
	},"text")
	//zhouxin return
	return;
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		SelDateArr=data.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1])-1;
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		SelDateArr=data.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0])-1;
		SelDate=parseInt(SelDateArr[1]);
	}
	var month=parseInt(SelMonth)+1
	var monthday=month+"-"+SelDate;
	
	if((monthday=="10-1")||(monthday=="5-1")||(monthday=="1-1")||(monthday=="3-8")){
		$("#DateOccuType").combobox("setText","节日之一");
		return;
		}
	var TheDate = new Date(SelYear, SelMonth, SelDate);
	e2c(TheDate);
	var rtn= GetcDateString();
	
	if((rtn=="12-30")||(rtn=="8-15")||(rtn=="1-1")||(rtn=="5-5")){
		$("#DateOccuType").combobox("setText","节日之一");
		return;
		}

	var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
	a=weekDay[TheDate.getDay()];
	
	if((a=="星期六")||(a=="星期日")){
		$("#DateOccuType").combobox("setText","周末");
		}else{
			$("#DateOccuType").combobox("setText","工作日");
			}
	}
function getDaysByCalendar(){
	$('#DateOccu').datebox({
  		onChange:function(){
	  		var medsrOccDateTime=$('#DateOccu').datebox('getValue');   
			if(medsrOccDateTime!="")
			{
				getWeeks(medsrOccDateTime);
			}
   		}
	});
	}
//hxy 2018-01-02 
function getDaysByCalendarValue(){
	var medsrOccDateTime=$('#DateOccu').datebox('getValue');   
	if(medsrOccDateTime!="")
	{
		getWeeks(medsrOccDateTime);
	}
}
 //提交保存是判断器械几种日期是否符合逻辑判断 dws 2017-11-24
function JudgmentDate(){
	var effectDate=$("input[name='166167.89802']").val(); //有效日期
	var effectDate=new Date(Date.parse(effectDate));
	var productDate=$("input[name='166171.89811']").val(); //生产日期
	var productDate=new Date(Date.parse(productDate));
	var stopDate=$("input[name='166178.89813']").val(); //停用日期
	var stopDate=new Date(Date.parse(stopDate));
	var inDate=$("input[name='166182.89815']").val(); //植入日期
	var inDate=new Date(Date.parse(inDate));
	var ret=true;
	if(effectDate<productDate){
		$.messager.alert('Warning','器械有效日期不能小于生产日期!');
		
		return false;
	}
	if(stopDate<productDate){
		$.messager.alert('Warning','器械停用日期不能小于生产日期!');
		return false;
	}
	if((inDate!="Invalid Date")&&(inDate<productDate)){
		$.messager.alert('Warning','器械植入日期不能小于生产日期!');
		return false;
	}
	return ret;
}
function JudgeDeviceData(){
	var effectDate=$("input[name='163820.89985']").val(); //生产日期
	var effectDate=new Date(Date.parse(effectDate));
	var productDate=$("input[name='163824.89987']").val(); //有效期
	var productDate=new Date(Date.parse(productDate));
	var stopDate=$("input[name='163828.89989']").val(); //停用日期
	var stopDate=new Date(Date.parse(stopDate));
	var ret=true;
	if(effectDate>productDate){
		$.messager.alert('Warning','有效日期不能小于生产日期!');
		return false;
	}
	if(effectDate>stopDate){
		$.messager.alert('Warning','停用日期不能小于生产日期!');
		return false;
	}
	if(document.getElementById("MDDeviceCode")){ //hxy 2018-01-23 
		var MDDeviceCode=$("#MDDeviceCode").val()
		if((MDDeviceCode=="")||(MDDeviceCode==undefined)){
			$.messager.alert('Warning','器械编码不能为空!');
			return false;
		}
	}	
	var now = new Date(); 
	var dateNow = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1); 
	var findDate=$("input[name='173350.89913']").val(); //发现熟知日期
	var findDates=new Date(Date.parse(findDate));
	if(findDates>dateNow){
		$.messager.alert('Warning','发现或熟知日期不能大于当前日期!');
		return false;
		}
	var happenDate=$("input[name='171531.89030']").val(); //事件发生日期
	var happenDate=new Date(Date.parse(happenDate));
	if(findDate<happenDate){
		$.messager.alert('Warning','发现或熟知日期不能小于事件发生日期！');
		return false;
		}
	return ret;
	} 
//qunianpeng 2018-01-05 判断 治疗错误事件 治疗错误类型的input 是否填写
function checkTreatErrTypeInput(){

	if ($('#treatErrType-61333').attr('checked')) {	 //患者错误  41607.89804
		if($("input[name='41607.89804'][type=input]").val()==""){
	     	return 0;     
	   }	 
	}    
	if ($('#treatErrType-61334').attr('checked')) {	 //部位错误  41607.89805
		if($("input[name='41607.89805'][type=input]").val()==""){
	     	return 0;     
	   }	 
	}  
	if ($('#treatErrType-61335').attr('checked')) {	 //器材错误(含植入性材料)  41607.89806
		if($("input[name='41607.89806'][type=input]").val()==""){
	     	return 0;     
	   }	 
	}    
	if ($('#treatErrType-61338').attr('checked')) {	 //药物错误  41607.89807
		if($("input[name='41607.89807'][type=input]").val()==""){
	     	return 0;     
	   }	 
	}   
	if ($('#treatErrType-61340').attr('checked')) {	 //剂量错误  41607.89808
		if($("input[name='41607.89808'][type=input]").val()==""){
	     	return 0;     
	   }	 
	}   
	if ($('#treatErrType-61342').attr('checked')) {	 //其他  41607.89809
		if($("input[name='41607.89809'][type=input]").val()==""){
	     	return 0;     
	   }	 
	} 	
	
	return 1;	
}
///sufan 2018-01-10 控制事件的发生日期不能大于当前日期
function JudgeHapDate(){
	var now=new Date();			// 当前日期
	var y = now.getFullYear();	// 年
	var m = now.getMonth()+1;   // 月       
	var d = now.getDate(); 		// 日
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var hours = now.getHours();		// 时
	var minutes = now.getMinutes(); // 分
	var seconds	= now.getSeconds(); // 秒
	if (hours <= 9)
	{
		var hours="0" + hours;
		}
	if (minutes <= 9)
	{
		var minutes="0" + minutes;
		}
	if (seconds <= 9)
	{
		var seconds="0" + seconds;
		}
	var time = hours +":"+ minutes +":"+ seconds;
	var startdate = y + "-" + m + "-" + d;
	var startdate=new Date(startdate.replace(/-/g, "/"));
	var effectDate=$("#DateOccu").datebox("getValue"); //发产日期
	var effectDate=ChangeDate(effectDate)
	var effectDate=new Date(effectDate.replace(/-/g, "/"));
	
	var ret=true;
	if(effectDate>startdate){
		$.messager.alert('Warning','事件发生日期不能大于当前日期!');
		return false;
	}
	return ret;
}
///sufan 2018-01-10 控制通知时间不能大于当前日期
function JudgeNotDate(){

	var NotDate=$("#NotiDate").datetimebox("getValue"); //发产日期
	var NotDate=ChangeDate(NotDate)
	var NotDate=new Date(NotDate.replace(/-/g, "/").replace(/-/g, "/"));
	var now=new Date();			// 当前日期
	var y = now.getFullYear();	// 年
	var m = now.getMonth()+1;   // 月       
	var d = now.getDate(); 		// 日
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var hours = now.getHours();		// 时
	var minutes = now.getMinutes(); // 分
	var seconds	= now.getSeconds(); // 秒
	if (hours <= 9)
	{
		var hours="0" + hours;
		}
	if (minutes <= 9)
	{
		var minutes="0" + minutes;
		}
	if (seconds <= 9)
	{
		var seconds="0" + seconds;
		}
	var time = hours +":"+ minutes +":"+ seconds;
	var nowdate = y + "-" + m + "-" + d +" "+time;
	var nowdate=new Date(nowdate.replace(/-/g, "/").replace(/-/g, "/"));
	var ret=true;
	if(NotDate>nowdate){
		$.messager.alert('Warning','通知时间不能大于当前时间!');
		return false;
	}
	return ret;
}
function ChangeDate(date)
{
	var chdate=""
	runClassMethod("web.DHCADVCOMMON","JugeDate",{"chdate":date},function(data){
		 chdate=data
	},'text',false)
	return chdate
}

///qunianpeng 2018/1/10 textarea输入框增加回车换行
function textAreaListener(){
    $('textarea').keydown(function(e){
		if(e.keyCode==13){
   			 //this.value += "\n";     
		}
	});     
}
// 初始化隐藏输入框位置 yuliping 2018-05-24
function initLableInput(){
	$(".lable-input").each(function(){
		var htmlLength=$(this).prev().html().length;
		var value=Number(20)+Number(15*htmlLength);
		
		$(this).css("margin-left",value);
		
	})
}
// 隐藏输入框必填验证 yuliping 2018-05-24 不需要单独调用
function requiredHideInput(){
	var rtn=true;
	var title=""
	$(".lable-input").each(function(){	
		
		if(!rtn){return;}		
		if($(this).prev().prev().attr("checked")=="checked"){
			if(($(this).val()=="")){
					var parentId=$(this).parent().attr("data-parref");	
					var parentTitle=$("#"+parentId).find("label").first().html();
					if(parentTitle==undefined){
						parentTitle=$("#"+parentId).html();
					}	
					title="请填写 "+parentTitle+$(this).prev().html();				
					rtn=false;
					
			}
		}
		
	})
	if(!rtn){
		$.messager.alert("提示",title);
	}
	return rtn;
	
}
//获取隐藏输入框值 yuliping 2018-05-24
function getHideInputValue(id){

	var value=$("#"+id).nextAll(".lable-input").val();
	return value;
}
//不良事件类别，子类选择关联父类选择  yuliping  2018-06-07
function childCorrelParentCheck(obj){
	
	parrentId=$(obj).parent().attr("data-parref")  //父ID
	id=$(obj).attr("id")						   //子ID
	parrentLable="#lable"+parrentId				   //父元素的label
	var num=0;									   //最内层计数器，选中子类的个数，1的时候，是最后一个
	var nextNum=0;								   //该元素的子元素个数，后面点击该元素的时候判断用
	$("input[id^='"+id+"']").each(function(i){
	if($(this).attr("checked")==undefined){
		}else{
			nextNum+=1;
		}
	})

	//var numPar=0;
	if($(obj).attr("checked")==undefined){
		$("input[id^="+parrentId+"]").each(function(i){
			if($(this).attr("checked")==undefined){
				}else{
					num+=1;
				}
			})
			//LQ   父类取消选择，子类全部取消
			$("input[id^="+id+"]").each(function(i){
				$(this).removeAttr("checked")
				$(this).nextAll(".lable-input").css("display","none")   //隐藏input
			})
		if(nextNum>0){
			num=num-nextNum												//去掉子类选中的个数
			}
		if(num==1){														
			$(parrentLable).children().removeAttr("checked")			//该元素上面直接第一层取消选择
			cancleParentPar(parrentLable)
			}
		}else{	
			$(parrentLable).children().attr("checked",'true')			//该元素上面直接第一层选中
			cancleParentPar(parrentLable)
		} 
	
	
}
//清除最高级
function cancleParentPar(parrentLable){
	var parParId=$(parrentLable).attr("data-parref")
	var parParLable="#lable"+$(parrentLable).attr("data-parref")
	var numPar=0;
	$("input[id^="+parParId+"]").each(function(i){
		if($(this).attr("checked")==undefined){
		}else{
			numPar+=1;
		}
	})
	//alert(numPar)
	if(numPar==1){
	//	alert(parParLable)
		$(parParLable).children().removeAttr("checked")				//该元素上面直接第二层取消选择
	}else{
		$(parParLable).children().attr("checked",'true')				//该元素上面直接第二层选中
	}
}

