$(document).ready(function(){
	//����һ��console����

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
				message: '���ڸ�ʽ����.'
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
	
	//hxy 09-14 �����¼���tooltip
	$('.dhcc-panel-titleimg:first').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">����һ�����ϡ�</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:eq(1)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">�¼����ϼ�ʵ��</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:eq(2)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">�¼�������Ϣ��д��</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:eq(3)').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">�º����¼��</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 $('.dhcc-panel-titleimg:last').tooltip({   
	   position: 'top',   
	   content: '<span style="color:#fff;padding-left:5px">�¼����������</span>',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	 }});
	 //�����¼��ĸ����� 
	 $('#AdvLevel-label-center,#AdvLevel-rightlabel').css("cursor","pointer");
	 //$('#AdvLevel-label-center,#AdvLevel-rightlabel,#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-11 > div > div > span > span > span').tooltip({   
	 $('#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-11 > div > div > span > span > span,#EventInfopanel > div.dhcc-panel-body > div:nth-child(4) > div.col-md-2 > div > div > span > span > span').tooltip({   
	   position: 'right',   
	   content: '<div style="color:#fff;padding:5px;font-size:14px;width:666px"><span><span style="color:red">I��-��Ѷ�¼�</span>&nbsp;&nbsp;��ָ�����Ʒ����ҽԺ���������У�'+
	          '���߻�Ա���ȷ�Ԥ�������������뼲���޹ص���֫�����ٵ���Ҫ���ܵ�������ɥʧ��</span><div style="height:10px"></div>'+
	          '<span><span style="color:#FFB12A">II��-��������¼�</span>&nbsp;&nbsp;��ָ�����Ʒ����ҽԺ���������У�'+
	          '�������ƻ��ҽԺ�������Ǽ���������ɵĻ��߻�Ա���Ȼ����빦�ܵ��𺦡�</span><div style="height:10px"></div>'+
	          '<span><span style="color:#FBD085">III��-δ��ɺ���¼�</span>&nbsp;&nbsp;��ָ�����Ʒ����ҽԺ���������У�'+
	          '��Ȼ�����˴������ʵ����δ�Ի����빦������κ��𺦣��������΢���������Ҫ�κδ�������ȫ������</span><div style="height:10px"></div>'+
	          '<span><span style="color:#75CCFF">IV��-�����¼�</span>&nbsp;&nbsp;��ָ�����Ʒ����ҽԺ���������У�'+
	          '�д������ڼ�ʱ���ֶ��ž���δ�γ���ʵ����Ǳ�ڷ��գ������𺦵���ʵ��δ��ɺ����</span>'+
	          '</div> ',  
	   onShow: function(){       
	    $(this).tooltip('tip').css({           
	  	  backgroundColor: '#666',         
	      borderColor: '#666'       
	      }); 
	    }//,
	    
	 });	 
	


	
	loadCssFile();//yuliping ����������汾������checkbox radio��ʽ
 	closePanle();//yuliping ������رհ�ť��ʼ����
 	closePanleS();//yuliping ������رհ�ť��ʼ����    
    
	comboboxSelect();
	
	//ie 8 �ϴ�ͼƬ�ô˷���
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
			alert("�ϴ��ɹ�!")
		}else{
			alert("�ϴ�ʧ��!")
		}
    })
    
     $('#file_upload').uploadify({
   ���� swf:'../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
 ������ uploader:'dhcadv.upload.csp?act=upload',
  		buttonText: 'ѡ��ͼƬ',
  		buttonClass:'dhcc-btn',
  		width:'130px',
  		onUploadSuccess: function(file,data,respone){
                retArr=data.split("^")
                if(retArr[0]==0){
	                $("#picPath").val(retArr[1]);
	                ip=retArr[2]
	                imgurl="http://"+ip+"/ftpsci/"+retArr[1];
	                html="<img src='"+imgurl+"'  onClick='viewPic(this)' data-id='"+imgurl+"' width='150px' height='150px' >"
	                html=html+"<a class='easyui-linkbutton l-btn l-btn-small l-btn-plain'  onclick='javascript:removePic()'><span class='l-btn-left l-btn-icon-left'><span class='l-btn-text'>ɾ��</span><span class='l-btn-icon icon-remove'>&nbsp;</span></span></a>"
	            	$("#picViewDiv").html(html)    
	            }else{
		         	alert("�ϴ�ʧ��!")   
		        }    
        }
    }) */
	
	//add_event();
});
function dbClickLegend(obj){
		$(obj).removeClass("legend-img-gotop"); 
		$(obj).addClass("legend-img-gobottom"); 
}
function showPre(obj){
	

	type=$(obj).attr('type')
	if(type=='radio'){
		
		var name=$(obj).attr('name');  //2018-01-02  ÿ�ε��radio�󣬵���˵��ᵯ�����ڣ�������껹�������ŵ����⣬��Դ��û�м� var   (�6�3_�6�3) (�6�3_�6�3) (�6�3_�6�3)    cy �޸�
		//radio ɾ������δѡ����Ԫ��html
		$("input[name='"+name+"'][type=radio]").each(function(){
			var id=$(this).attr("data-id")
			$("#"+id.replace(".","-")).html("");	
		})
		$("input[name='"+name+"'][type=radio]").next().next().hide();
		$(obj).next().next().show();
	}else{
		if($(obj).attr("checked")=="checked"){
			$(obj).next().next().show();    //���Ԫ��Ϊ����,��������
		}else{
			$(obj).next().next().hide();     //���Ԫ��Ϊ����,��������
		}
	}

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
			$(obj).parent().next().next().show();    //���Ԫ��Ϊ����,��������
		}else{
			$(obj).parent().next().next().hide();     //���Ԫ��Ϊ����,��������
		}
	}

}

function showCombox(obj){
	
	if($(obj).parent().next().next().is(":hidden")){
	      $(obj).parent().next().next().show();    //���Ԫ��Ϊ����,��������
	}else{
	      $(obj).parent().next().next().hide();     //���Ԫ��Ϊ����,��������
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
		},"text");
}
function removeRow(obj){
	$.messager.confirm("��ʾ", "�Ƿ����ɾ������", function (res) {//��ʾ�Ƿ�ɾ��
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
			comboboxSelLoc();
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
  		},90);/*hxy 2017-11-07 checkbox-date�ĳ�ʼ��δ��ѡ��ʾ���ڿ����Ϊ����ʾ��ҩƷ�����¼���*/


		
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
	link.href = '../scripts/dhcnewpro/skin/css/checkboxie8.css';
	document.getElementsByTagName("head")[0].appendChild(link);
		return;
	}else{
	var link = document.createElement('link');
	link.type = 'text/css';
	link.rel = 'stylesheet';
	link.href = '../scripts/dhcnewpro/css/checkandradio.css';
	document.getElementsByTagName("head")[0].appendChild(link);
			
	}
}


function checkRequired(){
	
	ret =true;
	$("#from").find("em").html("*");
	$("label[data-requried='Y']").each(function(){
		
		type=$(this).next().find("input").first().attr("type")
		var id=$(this).attr("id")
		if(type=="checkbox"){
		  if($("input[type=checkbox]", $(this).next()).length>0){
			if($("input[type=checkbox]:checked", $(this).next()).length==0){
				
				$("#"+id).find("em").html("*����Ϊ������");
				if(ret){
					$("html,body").stop(true);$("html,body").animate({scrollTop: $("#"+id).offset().top}, 1000);	
				}
				ret=false;
			}
			
		  };	
		}
		if(type=="radio"){
			if($("input[type=radio]", $(this).next()).length>0){
				if($("input[type=radio]:checked", $(this).next()).length==0){
					$("#"+id).find("em").html("*����Ϊ������");
					if(ret){
						$("html,body").stop(true);$("html,body").animate({scrollTop: $("#"+id).offset().top}, 1000);	
					}
					ret=false;
				}
				
			};
		}	
	})
	if(!ret)return ret;
	ret=$("#from").form('validate'); 
	//alert($(".validatebox-text.validatebox-invalid:first").parent().html())
	//alert(ret)
	return ret;
}
///����ҳ
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
		
}

function removePic(){
	$("#picViewDiv").html("");
	$("#picPath").val("");
}

