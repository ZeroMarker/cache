/*
Creator:石萧伟
CreatDate:2017-05-09
Description:引用知识属性内容
*/


//自定义全局替换函数
 /**g，表示全文匹配；
  *m，表示多行匹配(也就是正则表达式出现“^”、“$”，如果要匹配的字符串其中有换行符也没关系)；
  *i，表示忽略大小写
  */
 String.prototype.replaceAll = function (findText, repText){
	 var newRegExp = new RegExp(findText, 'gm');
	 return this.replace(newRegExp, repText);
 }; 
var rowid=2;
var init = function(){
	var div1="<div id='knoExe' style='display:none;position:absolute;background:#FFFFFF;border:1px solid #C0C0C0;width:850px;padding:10px 0 10px 0'></div>";
	var table1="<table id='contenttable'></table>";
	var table2='<table align="center"><tr><td><a href="#" class="course" id="read_btn">确定</a></td><td style="padding-left:30px"><a href="#"  id="cancel_btn">取消</a></td></tr></table>';
	var tr1="<tr class='trclass' id='noRemove'><td style='padding-left:10px'><img onclick='andorbtn(this)' class='imgclass' src='../scripts/bdp/Framework/icons/mkb/book.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId1'><input class='knowledgeclass hisui-combobox' id='knowledge1' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input class='propertyclass'  id='property1' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId1'><input class='contentclass hisui-combobox' id='content1' type='text' style='width:170px'></td><td style='padding-left:10px'><img  class='addnewtr'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr>";
	$('body').append(div1);
	$('#knoExe').append(table1);
	$('#knoExe').append(table2);
	$('#contenttable').append(tr1);
	$('#content1').combobox();
	$('#property1').combobox();
	$('#read_btn').linkbutton();
	$('#cancel_btn').linkbutton();
	function stopPropagation(e) { 
	　　if (e.stopPropagation) 
	　　　　e.stopPropagation(); 
	　　else 
	　　　　e.cancelBubble = true; 
	} 
	$('.datagrid-toolbar *').bind('click',function(){
		$('#knoExe').css('display','none'); 
	});
	/*$('#knoExe').click(function(e){
		var clickarr=clickflag.split('-');
		var clicktype=clickarr[0];
		var clickindex=clickarr[1];
		if(clicktype=='k'){
			if($('.knowledgeclass').next().find("input:first")[clickindex]!=undefined){
				$('.knowledgeclass').next().find("input:first")[clickindex].focus();
			}
			else{
				$('.knowledgeclass').next().find("input:first")[0].focus();
			}
		}
		if(clicktype=='p'){
			if($('.propertyclass').next().find("input:first")[clickindex]!=undefined){
				$('.propertyclass').next().find("input:first")[clickindex].focus()
			}
			else{
				$('.propertyclass').next().find("input:first")[0].focus();
			}
		}
		if(clicktype=='c'){
			if($('.contentclass').next().find("input:first")[clickindex]!=undefined){
				$('.contentclass').next().find("input:first")[clickindex].focus();
			}
			else{
				$('.contentclass').next().find("input:first")[0].focus();
			}
		}
	});*/
	loadData=function(str,base,colnumdesc,target)
	{
		//alert(str+"^"+base+"^"+colnumdesc+"^"+target)
		/*if(!$("#knoExe").is(":hidden")){
			return
		}*/
		//$('#content1').combo('clear')
		//$('#content1').combobox('loadData',"")
		$('#contentId1').html("");
		var newContendCom="<input class='contentclass' id='content1' type='text' style='width:170px'>";
		$('#contentId1').html(newContendCom);
		$('#content1').combobox({});
		$('#knowledgeId1').html("")
		var newKnoInput="<input class='knowledgeclass' id='knowledge1' type='text' style='width:170px'>"
		$('#knowledgeId1').append(newKnoInput)
		//loadDetailCombo("",rowid)
		var baseType=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetBaseType",base)
		removeAddTr();
		//加载数据
		if(str=="")
		{
			findData(base,1)//加载第一个下拉框
			$('#property1').combobox('clear');
			$('#property1').combobox('loadData',"");	
			$('#contentId1').html("");
			var newContendCom="<input class='contentclass' id='content1' type='text' style='width:170px'>";
			$('#contentId1').html(newContendCom);
			$('#content1').combobox({});
			//一开始灰化
			$('#property1').combobox('disable');
			$('#content1').combobox('disable');	
		}
		else
		{
			var strArray=str.split(";")
			//alert(strArray.length)
			var len=strArray.length
			for(i=0;i<len;i++)
			{
				if(i==0)
				{
					var termId=strArray[i].split("-")[0]
					if(strArray[i].indexOf("-")>0)
					{
						//alert(strArray[i].indexOf("-"))
						var proId=(strArray[i].split("-")[1]).split(":")[0]
						var detailId=strArray[i].split(":")[1]
						var detailIdArr=detailId.split("*")
						
					}
					findData(base,1)
					if(baseType=="L")
					{
						$('#knowledge1').combobox('setValue',termId)
					}
					else if(baseType=="T")
					{
						$('#knowledge1').combotree('setValue',termId)
					}
					loadTermCombo(termId,1)
					$('#property1').combobox('setValue',proId)
					var protype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetProType",proId)
					loadDetailCombo(proId,1)
					if(protype=="T")
					{
						$('#content1').combotree('setValues',detailIdArr)
					}
					else if(protype=="L")
					{
						$('#content1').combobox('setValues',detailIdArr)
					}
					else if(protype=="S")
					{
						var stype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetSProType",proId)
						if(stype=="L")
						{
							$('#content1').combobox('setValues',detailIdArr)
						}
						if(stype=="T")
						{
							$('#content1').combotree('setValues',detailIdArr)
						}
					}
					else if(protype=="SS")
					{
						$('#content1').combotree('setValues',detailIdArr)
					}
			    var emptyFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","EmptyDetail",termId);					
					if(emptyFlag=="Y")
					{
						$('#property1').combobox('disable');
						$('#content1').combobox('disable');							
					}
				}
				else
				{
					if (strArray[i].indexOf("&")>=0)
					{
						var newrow="<tr class='trclass'><td style='padding-left:10px'><img onclick='andorbtn(this)' class='imgclass'  src='../scripts/bdp/Framework/icons/mkb/re-and.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId"+rowid+"'><input id='knowledge"+rowid+"' class='knowledgeclass' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input id='property"+rowid+"' class='propertyclass' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId"+rowid+"'><input id='content"+rowid+"' class='contentclass' type='text' style='width:170px'></td><td style='padding-left:10px'><img  class='addnewtr' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  onclick='deltr(this)' src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' style='border: 0px;cursor:pointer'></td></tr>"					
						var findIdstr=strArray[i].split("&")[1]
					}
					else if(strArray[i].indexOf("|")>=0)
					{
						var newrow="<tr class='trclass'><td style='padding-left:10px'><img onclick='andorbtn(this)' class='imgclass'  src='../scripts/bdp/Framework/icons/mkb/re-or.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId"+rowid+"'><input id='knowledge"+rowid+"' class='knowledgeclass' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input id='property"+rowid+"' class='propertyclass' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId"+rowid+"'><input id='content"+rowid+"' class='contentclass' type='text' style='width:170px'></td><td style='padding-left:10px'><img  class='addnewtr'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  onclick='deltr(this)' src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' style='border: 0px;cursor:pointer'></td></tr>"
						var findIdstr=strArray[i].split("|")[1]
					}
					$('#contenttable').append(newrow);
					//给新的下拉框复制值
					//$('#knowledge'+rowid).combobox({});
					$('#property'+rowid).combobox({});
					var termId=findIdstr.split("-")[0]
					if((findIdstr.split("-")[1])!="")
					{
						if((findIdstr.split("-")[1])!=undefined)
						{
							var proId=(findIdstr.split("-")[1]).split(":")[0];
							var detailId=findIdstr.split(":")[1];
							//alert(detailId.split("*"))
							var detailIdArr=detailId.split("*");
						}
						else
						{
							proId="";
							var detailId="";
							var detailIdArr="";
						}	
					}
					findData(base,rowid)
					if(baseType=="L")
					{
						$('#knowledge'+rowid).combobox('setValue',termId)
					}
					else if(baseType=="T")
					{
						$('#knowledge'+rowid).combotree('setValue',termId)
					}
					loadTermCombo(termId,rowid)
					$('#property'+rowid).combobox('setValue',proId)
					var protype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetProType",proId);				
					loadDetailCombo(proId,rowid)
					if(protype=="T")
					{
						$('#content'+rowid).combotree('setValues',detailIdArr)
					}
					else if(protype=="L")
					{
						$('#content'+rowid).combobox('setValues',detailIdArr)
					}
					else if(protype=="S")
					{
						var stype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetSProType",proId)
						if(stype=="L")
						{
							$('#content'+rowid).combobox('setValues',detailIdArr)
						}
						if(stype=="T")
						{
							$('#content'+rowid).combotree('setValues',detailIdArr)
						}
					}
					else if(protype=="SS")
					{
						$('#content'+rowid).combotree('setValues',detailIdArr)
					}
			    var emptyFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","EmptyDetail",termId);					
					if(emptyFlag=="Y")
					{
						$('#property'+rowid).combobox('disable');
						$('#content'+rowid).combobox('disable');							
					}											
					rowid++	
				}
			}		
		}
		
		$('.addnewtr').each(function(){
			
			$(this).unbind('click').click(function(e){
				
				if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
					if($("#knoExe").height()+65>target.offset().top){
						$.messager.alert('提示信息','数据超长')
						return
					}
					$("#knoExe").css({
						"top": target.offset().top-$("#knoExe").height()-60
					});
				}
				addnewtr(this,base,target);
			})
		})
		$('.copynewtr').each(function(){
			$(this).unbind('click').click(function(e){
				if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
					if($("#knoExe").height()+65>target.offset().top){
						$.messager.alert('提示信息','数据超长')
						return
					}
					$("#knoExe").css({
						"top": target.offset().top-$("#knoExe").height()-60
					});
				}
				copynewtr(this,base,target);
			})
		})
		/*
		$("#knoExe").unbind('mouseleave').mouseleave(function(e){
			setTimeout(function(){
				leaveflag=0
			},700)
		});
		$("#knoExe").unbind('mouseenter').mousemove(function(e){
			leaveflag=1
		});
		
		/*$(".knowledgeclass").next().find("input").unbind('blur').blur(function(e){
			t=setTimeout(function(){
				if(leaveflag==0){
					//$("#knoExe").hide()	
				}
			},700)
		});
		$(".knowledgeclass").next().find("input").unbind('focus').focus(function(e){
			clearTimeout(t)
			//leaveflag=1
			clickflag='k-0';
		})
		$(".propertyclass").next().find("input").unbind('blur').blur(function(e){
			
			t=setTimeout(function(){
				if(leaveflag==0){
					$("#knoExe").hide()	
				}
			},700)
		});
		$(".propertyclass").next().find("input").unbind('focus').focus(function(e){
			clearTimeout(t)
			leaveflag=1;
			clickflag='p-0';
		})*/
		/*
		$(".contentclass").next().find("input").unbind('blur').blur(function(e){
			
			t=setTimeout(function(){
				if(leaveflag==0){
					$("#knoExe").hide()	
				}
			},700)
		});
		$(".contentclass").next().find("input").unbind('focus').focus(function(e){
			clearTimeout(t)
			leaveflag=1;
			clickflag='c-0';
		})*/
		/*
		$(".knowledgeclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				//leaveflag=1
				clickflag='k-'+index;
			});
		})
		$(".propertyclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				//leaveflag=1
				clickflag='p-'+index;
			});
		})
		$(".contentclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				//leaveflag=1
				clickflag='c-'+index;
			});
		})*/
		

		$(document).bind('click',function(){ 
		    $('#knoExe').css('display','none'); 
		}); 
		$('#knoExe').bind('click',function(e){ 
		    stopPropagation(e); 
		}); 
	}
	//点击添加按钮
	addnewtr=function (obj,base,target)
	{
		var newtr="<tr class='trclass'><td style='padding-left:10px'><img class='imgclass' onclick='andorbtn(this)' src='../scripts/bdp/Framework/icons/mkb/re-and.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId"+rowid+"'><input id='knowledge"+rowid+"' class='knowledgeclass' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input id='property"+rowid+"' class='propertyclass' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId"+rowid+"'><input id='content"+rowid+"' class='contentclass' type='text' style='width:170px'></td><td style='padding-left:10px'><img class='addnewtr'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='deltr'  onclick='deltr(this)' src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' style='border: 0px;cursor:pointer'></td></tr>"
		$('#contenttable').append(newtr);
		$('#knowledge'+rowid).combobox({});
		$('#property'+rowid).combobox({});
		$('#content'+rowid).combobox({});
		
		$('.addnewtr').each(function(){
			$(this).unbind('click').click(function(e){
				
				if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
					if($("#knoExe").height()+65>target.offset().top){
						$.messager.alert('提示信息','数据超长')
						return
					}
					$("#knoExe").css({
						"top": target.offset().top-$("#knoExe").height()-60
					});
				}
				addnewtr(this,base,target);
			})
		})
		$('.copynewtr').each(function(){
			$(this).unbind('click').click(function(e){
				
				if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
					if($("#knoExe").height()+65>target.offset().top){
						$.messager.alert('提示信息','数据超长')
						return
					}
					$("#knoExe").css({
						"top": target.offset().top-$("#knoExe").height()-60
					});
				}
				copynewtr(this,base,target);
			})
		})
		findData(base,rowid);
		$('#property'+rowid).combobox('disable');
		$('#content'+rowid).combobox('disable');									
		//焦点
		/*
		$(".knowledgeclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				leaveflag=1
				clickflag='k-'+index;
			})
		})
		$(".propertyclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				leaveflag=1
				clickflag='p-'+index;
			});
		})
		$(".contentclass").next().find("input:first").each(function(index){
			$(this).unbind('blur').blur(function(e){
				t=setTimeout(function(){
					if(leaveflag==0){
						$("#knoExe").hide()	
					}
				},700)
			});
			$(this).unbind('focus').focus(function(e){
				clearTimeout(t)
				leaveflag=1
				clickflag='c-'+index;
			})
		})
		*/
		rowid++;	
	}
	
	//点击复制按钮
	copynewtr=function(obj,base,target)
	{
		$(obj).parent().parent().find('.imgclass').each(function(){
			var imgsrc=$(this).attr("src")
			if(imgsrc=="../scripts/bdp/Framework/icons/mkb/re-or.png")
			{
				var newrow="<tr class='trclass'><td style='padding-left:10px'><img class='imgclass' onclick='andorbtn(this)' src='../scripts/bdp/Framework/icons/mkb/re-or.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId"+rowid+"'><input id='knowledge"+rowid+"' class='knowledgeclass' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input id='property"+rowid+"' class='propertyclass' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId"+rowid+"'><input id='content"+rowid+"' class='contentclass' type='text' style='width:170px'></td><td style='padding-left:10px'><img  class='addnewtr'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='deltr' onclick='deltr(this)' src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' style='border: 0px;cursor:pointer'></td></tr>"
				$('#contenttable').append(newrow);
			}
			else 
			{
				var newrow="<tr class='trclass'><td style='padding-left:10px'><img class='imgclass' onclick='andorbtn(this)' src='../scripts/bdp/Framework/icons/mkb/re-and.png' style='border:0px;cursor:pointer'></td><td style='padding-left:10px'>知识=</td><td style='padding-left:10px' id='knowledgeId"+rowid+"'><input id='knowledge"+rowid+"' class='knowledgeclass' type='text' style='width:170px'></td><td style='padding-left:10px'>属性=</td><td style='padding-left:10px'><input id='property"+rowid+"' class='propertyclass' type='text' style='width:170px'></td><td style='padding-left:10px'>内容=</td><td style='padding-left:10px' id='contentId"+rowid+"'><input id='content"+rowid+"' class='contentclass' type='text' style='width:170px'></td><td style='padding-left:10px'><img class='addnewtr' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img class='copynewtr'  src='../scripts/bdp/Framework/icons/mkb/add_paste.png' style='border: 0px;cursor:pointer'></td><td style='padding-left:10px'><img  class='deltr' onclick='deltr(this)' src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' style='border: 0px;cursor:pointer'></td></tr>"
				$('#contenttable').append(newrow);
			}
			//给新的下拉框复制值
			$('#knowledge'+rowid).combobox({});
			$('#property'+rowid).combobox({});
			$('#content'+rowid).combobox({});
			findData(base,rowid)
			//复制知识
			var knowledgeid="" 
			var propertyid=""
			$(this).parent().parent().find('.knowledgeclass').each(function(){
				var basetype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetBaseType",base)
				if(basetype=="L")
				{
					knowledgeid=$(this).combobox('getValue');
					$('#knowledge'+rowid).combobox('setValue',knowledgeid);
				}
				else if(basetype=="T")
				{
					knowledgeid=$(this).combotree('getValue');
					$('#knowledge'+rowid).combotree('setValue',knowledgeid);
				}
			})
			//复制属性
			$(this).parent().parent().find('.propertyclass').each(function(){
				//var knowledgeid=$(this).combobox('getValue');
				propertyid=$(this).combobox('getValue');
				loadTermCombo(knowledgeid,rowid)
				$('#property'+rowid).combobox('setValue',propertyid);
			})
			//复制内容
			$(this).parent().parent().find('.contentclass').each(function(){
				//var propertyid=$(this).combobox('getValue');
				var protype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetProType",propertyid)
				if(protype=="T")
				{
					var contentid=$(this).combotree('getValues');
					loadDetailCombo(propertyid,rowid)
					$('#content'+rowid).combotree('setValues',contentid);
				}
				else if(protype=="L")
				{
					//var values=($(this).combobox('getText')).split(',');
					//alert(propertyid+"*"+rowid)
					var contentid=$(this).combobox('getValues');
					loadDetailCombo(propertyid,rowid)
					$('#content'+rowid).combobox('setValues',contentid);
				}
				else if(protype=="S")
				{
					var stype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetSProType",propertyid);
					if(stype=="T")
					{
						var contentid=$(this).combotree('getValues');
						loadDetailCombo(propertyid,rowid)
						$('#content'+rowid).combotree('setValues',contentid);						
					}
					else
					{
						var contentid=$(this).combobox('getValues');
						loadDetailCombo(propertyid,rowid)
						$('#content'+rowid).combobox('setValues',contentid);
					}
				}

			})
         	var emptyFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","EmptyDetail",knowledgeid);					
			if(emptyFlag=="Y")
			{
				$('#property'+rowid).combobox('disable');
				$('#content'+rowid).combobox('disable');							
			}				
			//焦点
			/*
			$(".knowledgeclass").next().find("input:first").each(function(index){
				$(this).unbind('blur').blur(function(e){
					t=setTimeout(function(){
						if(leaveflag==0){
							$("#knoExe").hide()	
						}
					},700)
				});
				$(this).unbind('focus').focus(function(e){
					clearTimeout(t)
					leaveflag=1
					clickflag='k-'+index;
				})
			})
			$(".propertyclass").next().find("input:first").each(function(index){
				$(this).unbind('blur').blur(function(e){
					t=setTimeout(function(){
						if(leaveflag==0){
							$("#knoExe").hide()	
						}
					},700)
				});
				$(this).unbind('focus').focus(function(e){
					clearTimeout(t)
					leaveflag=1
					clickflag='p-'+index;
				})
			})
			
			$(".contentclass").next().find("input:first").each(function(index){
				$(this).unbind('blur').blur(function(e){
					t=setTimeout(function(){
						if(leaveflag==0){
							$("#knoExe").hide()	
						}
					},700)
				});
				$(this).unbind('focus').focus(function(e){
					clearTimeout(t)
					leaveflag=1
					clickflag='c-'+index;
				})
			})
			*/
			$('.addnewtr').each(function(){
				$(this).unbind('click').click(function(e){
					if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
						if($("#knoExe").height()+65>target.offset().top){
							$.messager.alert('提示信息','数据超长')
							return
						}
						$("#knoExe").css({
							"top": target.offset().top-$("#knoExe").height()-60
						});
					}
					addnewtr(this,base,target);
				})
			})
			$('.copynewtr').each(function(){
				$(this).unbind('click').click(function(e){
					if(target.offset().top+$("#knoExe").height()+100>$(window).height()){
						if($("#knoExe").height()+65>target.offset().top){
							$.messager.alert('提示信息','数据超长!')
							return
						}
						$("#knoExe").css({
							"top": target.offset().top-$("#knoExe").height()-60
						});
					}
					copynewtr(this,base,target);
				})
			})				
		});		
		rowid++;
	}
	//点击删除按钮
	deltr=function(obj)
	{
		var parenttr=$(obj).parent().parent()
		parenttr.remove()
	}
	//点击且或按钮
	andorbtn=function (obj)
	{
		//alert($(obj).attr("src"))
		var imgsrc=$(obj).attr("src");
		if(imgsrc=="../scripts/bdp/Framework/icons/mkb/re-and.png")
		{
			$(obj).attr("src","../scripts/bdp/Framework/icons/mkb/re-or.png")
		}
		else if(imgsrc=="../scripts/bdp/Framework/icons/mkb/re-or.png")
		{
			$(obj).attr("src","../scripts/bdp/Framework/icons/mkb/re-and.png")
		}
	}
	//alert(base)
	function findData(base,row)
	{
		var basetype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetBaseType",base)
		if(basetype=="L")
		{
			$('#knowledgeId'+row).html("")
			var newKnoInput="<input class='knowledgeclass hisui-combobox' id='knowledge"+row+"' type='text' style='width:170px'>"
			$('#knowledgeId'+row).append(newKnoInput)
			$('#knowledge'+row).combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetListTerm&ResultSetType=array&base="+base,
				valueField:'MKBTRowId',
	        	textField:'MKBTDesc',
	        	//panelWidth:200,
	        	/*keyHandler:{
	        		query:function(){
			            var desc=$.trim($(this).combobox('getText'));
		                $(this).combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetListTerm&ResultSetType=array&desc="+encodeURI(desc)+"&base="+base);
		                $(this).combobox("setValue",desc);
	             	}  
	         	},*/
	         	mode:'remote',
	         	onSelect:function(record){
		         	//选中之后，加载属性下拉框
		         	var termid=record.MKBTRowId;
							//判断是否有属性
							var emptyFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","EmptyDetail",termid);
							loadTermCombo(termid,row);
							$('#contentId'+row).html("");
							var newContendCom="<input class='contentclass' id='content"+row+"' type='text' style='width:170px'>";
							$('#contentId'+row).html(newContendCom)
							$('#content'+row).combobox({});									         					
							//$(".knowledgeclass").next().find("input").focus();
							if(emptyFlag=="Y")
							{
								$('#property'+row).combobox('disable');
								$('#content'+row).combobox('disable');							
							}
							else
							{
								$('#property'+row).combobox('textbox')[0].focus();;
							}
							//$('#knowledge'+row).combobox('textbox')[0].focus();
		        }
			});
		}
		else if(basetype=="T")
		{
			$('#knowledgeId'+row).html("")
			var newKnoInput="<input class='knowledgeclass hisui-combobox' id='knowledge"+row+"' type='text' style='width:170px'>"
			$('#knowledgeId'+row).append(newKnoInput)
			$('#knowledge'+row).combotree({
				url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetTreeTerm&base="+base,
				//panelWidth:200,
				onSelect:function(record){
					//选中之后，加载属性下拉框
					var termid=record.id
					loadTermCombo(termid,row);
					$('#contentId'+row).html("");
					var newContendCom="<input class='contentclass' id='content"+row+"' type='text' style='width:170px'>";
					$('#contentId'+row).html(newContendCom)
					$('#content'+row).combobox({});			         	
					//$(".knowledgeclass").next().find("input").focus();
							var emptyFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","EmptyDetail",termid);					
					if(emptyFlag=="Y")
					{
						$('#property'+row).combobox('disable');
						$('#content'+row).combobox('disable');							
					}
					else
					{
						$('#property'+row).combobox('textbox')[0].focus();;
					}		
					//$('#knowledge'+row).combotree('textbox')[0].focus();					
				}
			});
		}	
	}
	//加载属性
	function loadTermCombo(termid,row)
	{
    	$('#property'+row).combobox({
        	url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetProperty&ResultSetType=array&termdr="+termid,
        	valueField:'MKBTPRowId',
					textField:'MKBTPDesc',
					/*keyHandler:{
							query:function(){
										var termdesc=$.trim($(this).combobox('getText'));
											$(this).combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetProperty&ResultSetType=array&desc="+encodeURI(termdesc)+"&termdr="+termid);
											$(this).combobox("setValue",termdesc);
							}  
					},*/
					mode:'remote',
					onSelect:function(record){
						//$('#content'+row).combobox('clear')
						//$('#content'+row).combobox('loadData',"")
						//$('#content'+row).html("")
								//选中之后，加载neirong下拉框
						var proid=record.MKBTPRowId;
						loadDetailCombo(proid,row);
						//$(".propertyclass").next().find("input").focus();
						//$(this).combobox('textbox')[0].focus();
						$('#content'+row).combobox('textbox')[0].focus();
					}	
			})
	}
	
	//加载内容
	function loadDetailCombo(proid,row)
	{
		//alert(proid+"*"+row) //68027*1
		var rowforcom=row;
		$('#contentId'+row).html("");
		var newContendCom="<input class='contentclass' id='content"+row+"' type='text' style='width:170px'>";
		$('#contentId'+row).html(newContendCom)
		var protype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetProType",proid);
		if(protype=="L")
		{
			$('#content'+row).combobox({
	      url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetListDetail&ResultSetType=array&property="+proid,
	      valueField:'MKBTPDRowId',
				textField:'MKBTPDDesc',
				multiple:true,
				mode:'remote',
				rowStyle:'checkbox', //显示成勾选行形式
				selectOnNavigation:false //默认值true。当为false时，DOWN键不选中行记录
				/*formatter:function(row){   //谷雪萍-20200922-表达式控件多选框样式不对
					var opts;
					opts = "<input type='checkbox' class='allCheck' id='"+rowforcom+"r"+row.MKBTPDRowId+"' value='"+row.MKBTPDRowId+"'>"+row.MKBTPDDesc;
					return opts;
				},
				onSelect:function(record){
					//alert($("#"+rowforcom+"r"+record.MKBTPDRowId).attr("id"))
					$('#content'+row).combobox('textbox')[0].focus();
					$HUI.checkbox("#"+rowforcom+"r"+record.MKBTPDRowId).setValue(true);
				},
				onUnselect:function(record){
					$HUI.checkbox("#"+rowforcom+"r"+record.MKBTPDRowId).setValue(false);
				},
				onHidePanel:function(){
					//$('.allCheck').remove();					
				},
				onShowPanel:function(){
					var $target=$(this)
					//将duo选框渲染成hisui样式
			    	$HUI.checkbox('.allCheck',{
				    	onChecked:function(){//当点击复选框时，选中值
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('select',check_value);
					    },
				    	onUnchecked:function(){
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('unselect',check_value);					    	
					    }				    	
					});
					var arr=$(this).combobox('getValues');
					for(var j = 0; j < arr.length; j++) {
						//alert($("#"+rowforcom+"r"+arr[j]).attr("id"))
   						$HUI.checkbox("#"+rowforcom+"r"+arr[j]).setValue(true);
					}
				}				
				/*onLoadSuccess:function(){
					var $target=$(this)
					//将duo选框渲染成hisui样式
			    	$HUI.checkbox('.allCheck',{
				    	onChecked:function(){//当点击复选框时，选中值
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('select',check_value);
					    },
				    	onUnchecked:function(){
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('unselect',check_value);					    	
					    }				    	
					});
					var arr=$(this).combobox('getValues');
					for(var j = 0; j < arr.length; j++) {
   						$HUI.checkbox("#"+rowforcom+"r"+arr[j]).setValue(true);
					}
					
				}*/ 				 
        	})
		}
		else if(protype=="T")
		{
			$('#content'+row).combotree({
	      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetTreeDetail&property="+proid,
				multiple:true,
				cascadeCheck:false,
				panelWidth:230,
				onSelect:function(record){
					//$(".contentclass").next().find("input").focus();
					$('#content'+row).combotree('textbox')[0].focus();
				},
				onCheck:function(node, checked){
					$('#content'+row).combotree('textbox')[0].focus();
				},
				formatter: function(row){
					return '<span title="' + row.text + '"  class="hisui-tooltip" >' + row.text + '</span>'	
				} 				
								
      })
		}
		else if(protype=="S")
		{
			var stype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetSProType",proid)
			if(stype=="T")
			{
				$('#content'+row).combotree({
		      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetDocSourseTreeJson&property="+proid,
					panelWidth:230,
					multiple:true,
					cascadeCheck:false,
					onSelect:function(record){
						//$(".contentclass").next().find("input").focus();
						$('#content'+row).combotree('textbox')[0].focus();
						//alert($('#content'+row).attr("id"))
					},
					onCheck:function(node, checked){
						$('#content'+row).combotree('textbox')[0].focus();
					},
					formatter: function(row){
						return '<span title="' + row.text + '"  class="hisui-tooltip" >' + row.text + '</span>'
					
					}  
				})
			}
			else if(stype=="L")
			{
				$('#content'+row).combobox({
					url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetSListDetail&ResultSetType=array&property="+proid,
					valueField:'MKBTPDRowId',
					textField:'MKBTPDDesc',
					multiple:true,
					mode:'remote',
					selectOnNavigation:false  //默认值true。当为false时，DOWN键不选中行记录
					/*formatter:function(row){  //谷雪萍-20200922-表达式控件多选框样式不对
						var opts;
						opts = "<input type='checkbox' class='allCheck' id='"+rowforcom+"p"+row.MKBTPDRowId+"' value='"+row.MKBTPDRowId+"'>"+row.MKBTPDDesc;
						return opts;
					},					
					onSelect:function(record){
						//alert($("#"+rowforcom+"p"+record.MKBTPDRowId).attr("id"))
						//$(".contentclass").next().find("input").focus();
						$('#content'+row).combobox('textbox')[0].focus();
						$HUI.checkbox("#"+rowforcom+"p"+record.MKBTPDRowId).setValue(true);
					},
					onUnselect:function(record){
						$HUI.checkbox("#"+rowforcom+"p"+record.MKBTPDRowId).setValue(false);
					},
					onHidePanel:function(){
						//$('.allCheck').remove();					
					},
					onShowPanel:function(){
					var $target=$(this)
					//将duo选框渲染成hisui样式
			    	$HUI.checkbox('.allCheck',{
				    	onChecked:function(){//当点击复选框时，选中值
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('select',check_value);
					   	 },
				    	onUnchecked:function(){
					    	var check_id=$(this).attr("id");
					    	//alert(check_id)
					    	var check_value=document.getElementById(check_id).value;
							$target.combobox('unselect',check_value);					    	
					    }				    	
					});
						var arr=$(this).combobox('getValues');
						for(var j = 0; j < arr.length; j++) {
							//alert($("#"+rowforcom+"p"+arr[j]).attr("id"))
	   						$HUI.checkbox("#"+rowforcom+"p"+arr[j]).setValue(true);
						}					
					}					
					/*onLoadSuccess:function(){
						var $target=$(this)
						//将duo选框渲染成hisui样式
				    	$HUI.checkbox('.allCheck',{
					    	onChecked:function(){//当点击复选框时，选中值
						    	var check_id=$(this).attr("id");
						    	//alert(check_id)
						    	var check_value=document.getElementById(check_id).value;
								$target.combobox('select',check_value);
						   	 },
					    	onUnchecked:function(){
						    	var check_id=$(this).attr("id");
						    	//alert(check_id)
						    	var check_value=document.getElementById(check_id).value;
								$target.combobox('unselect',check_value);					    	
						    }				    	
						});
						var arr=$(this).combobox('getValues');
						for(var j = 0; j < arr.length; j++) {
	   						$HUI.checkbox("#"+rowforcom+"p"+arr[j]).setValue(true);
						}							
					}*/ 				 					 					
        		})
			}
		}
		else if(protype=="SS"){
			$('#content'+row).combotree({
	      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetSourseSingleTermJson&property="+proid,
				multiple:true,
				cascadeCheck:false,
				panelWidth:350,
				onSelect:function(record){
					//$(".contentclass").next().find("input").focus();
					$('#content'+row).combotree('textbox')[0].focus();
				},
				onCheck:function(node, checked){
					$('#content'+row).combotree('textbox')[0].focus();
				},
				formatter: function(row){
					return '<span title="' + row.text + '"  class="hisui-tooltip" >' + row.text + '</span>'	
				} 				
								
      })			
		}
		else
		{
			$('#content'+row).combobox({});	
		}
		/*
		$('#content'+row).combo('textbox').unbind('blur').blur(function(e){
			t=setTimeout(function(){
				if(leaveflag==0){
					$("#knoExe").hide()	
				}
			},700)
		});
		$('#content'+row).combo('textbox').unbind('focus').focus(function(e){
			clearTimeout(t)
			leaveflag=1
			clickflag='c-'+(row-1);
		})*/
	}
	addBase=function (base,colnumdesc)
	{

			//遍历行
			var str=""
			var basetype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetBaseType",base)
			//var detailflag=""
			$('#contenttable').find('.trclass').each(function(){
				//获取链接条件
				if(basetype=="L")
				{
					var jsukno=$(this).find('.knowledgeclass').combobox('getText');
				}
				else
				{
					var jsukno=$(this).find('.knowledgeclass').combotree('getText');
				}
				if(jsukno!="")
				{
					$(this).find('.imgclass').each(function(){
						var imgsrc=$(this).attr("src")
						if(imgsrc=="../scripts/bdp/Framework/icons/mkb/re-or.png")
						{
							str=str+";|"
						}
						else if(imgsrc=="../scripts/bdp/Framework/icons/mkb/re-and.png")
						{
							str=str+";&"
						}
						else
						{
							str=""
						}	
					})
					//获取知识id
					$(this).find('.knowledgeclass').each(function(){
						//alert($(this).is(":visible"))
						if(basetype=="L")
						{
							var termid=$(this).combobox('getValue')
							str=str+termid
						}
						else if(basetype=="T")
						{
							var termid=$(this).combotree('getValue')
							str=str+termid
						}	
					})
					//获取属性id
					var propertyid=""
					$(this).find('.propertyclass').each(function(){
						propertyid=$(this).combobox('getValue')
						if(propertyid!="")
						{
							str=str+"-"+propertyid
						}
						else
						{
							str=str	
						}
							
					})
					//获取内容id
					var protype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetProType",propertyid)
					$(this).find('.contentclass').each(function(){
						if(protype=="L")
						{
							var detailids=$(this).combobox('getValues')

						}
						if(protype=="T")
						{
							var detailids=$(this).combotree('getValues')
						}
						if(protype=="S")
						{
							var stype=tkMakeServerCall("web.DHCBL.MKB.MKBKnoExpression","GetSProType",propertyid)
							if(stype=="L")
							{
								var detailids=$(this).combobox('getValues')
							}
							if(stype=="T")
							{
								var detailids=$(this).combotree('getValues')
							}
						}
						if(protype=="SS"){
							var detailids=$(this).combotree('getValues')
						}
//						if(propertyid!="" && detailids=="")
//						{
//						    //$.messager.alert('提示','请选择属性内容！',"error");
//			        		//return;
//			        		detailflag="Y"							
//						}
						if (detailids!=undefined)
						{
							var detailid=detailids.toString()
							//替换里面的逗号
							var idstr=detailid.replaceAll(',','*');
							str=str+":"+idstr
						}		
					})					
				}
			})
//			if(detailflag=="Y")
//			{
//			    $.messager.alert('提示','请选择属性内容！',"error");
//        		return;				
//			}
			detailstr[colnumdesc]=str		
	}
	//关闭窗口	
	$('#cancel_btn').click(function(e){
		$('#knoExe').hide();
	})
	function removeAddTr()
	{
		//点击确定或者是取消按钮后
		$("#contenttable").find('.trclass').each(function(){
			var removeid=$(this).attr("id");
			if(removeid==undefined)
			{
				$(this).remove()
			}
		})
	}
	
}
$(init)
