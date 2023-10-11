/*
Creator:石萧伟
CreatDate:2017-05-02
Description:知识点映射注册注册
*/
/*************************************************添加/删除主列开始*********************************/
var mainrow=1;
function addMainColumn(obj,num)//num知识点的映射 1关联知识点1  2关联知识点2 
{  
	if(num==1)
	{
		var newmain="<div class='maindiv' id='Awhole"+mainrow+"'  style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input class='resizeA' type='text' id='A"+mainrow+"'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='B"+mainrow+"' class='source1'  style='width:257px;'></td><td class='sourceknow1'>（知识点1）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delMainColumn(Awhole"+mainrow+")' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
		$('#addMainCo').append(newmain);
		
		//将列的标签重新命名
		var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
			})
			var baseid=$('#MKBKMBKnowledge1').combobox('getValue');
			//判断知识点1下拉框有没有值，如果有则将括号展示替换
			var basedesc=$('#MKBKMBKnowledge1').combobox('getText');
			if(basedesc!="")
			{
				$('.sourceknow1').text("（"+basedesc+"）");
			}
		$('#B'+mainrow).combobox({
			url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+baseid,
	        valueField:'ID',
	        textField:'Desc',
	        onSelect:function(record)
	        {
				var sourcr1flag="N";
				$('#addMainCo').find('.source1,.source2').each(function(){
					var sourcejust=$(this).combobox('getText');
					//alert(sourcejust)
					if(sourcejust=="知识表达式" || sourcejust=="Exp")
					{
						sourcr1flag="Y";
					}
				});
				if(sourcr1flag=="Y")
				{
					$("#MKBKMBFlagF").checkbox('enable');
				}
				else
				{
					$("#MKBKMBFlagF").checkbox('disable');	
				}	        
		    }	        
		});
		$('#A'+mainrow).validatebox({});	
	}
	else
	{
		var newmain="<div class='maindiv' id='Bwhole"+mainrow+"' style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:3px 3px 3px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input class='resizeA' type='text' id='A"+mainrow+"' name=''  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='D"+mainrow+"' class='source2'  style='width:257px;'></td><td class='sourceknow2'>（知识点2）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delMainColumn(Bwhole"+mainrow+")' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
		$('#addMainCo').append(newmain);
		//将列的标签重新命名
		var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
			})
		var baseid=$('#MKBKMBKnowledge2').combobox('getValue');
		//判断知识点1下拉框有没有值，如果有则将括号展示替换
		var basedesc=$('#MKBKMBKnowledge2').combobox('getText');
		if(basedesc!="")
		{
			$('.sourceknow2').text("（"+basedesc+"）");
		}
		$('#D'+mainrow).combobox({
			url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+baseid,
	        valueField:'ID',
	        textField:'Desc',
	        onSelect:function(record)
	        {
				var sourcr1flag="N";
				$('#addMainCo').find('.source1,.source2').each(function(){
					var sourcejust=$(this).combobox('getText');
					//alert(sourcejust)
					if(sourcejust=="知识表达式" || sourcejust=="Exp")
					{
						sourcr1flag="Y";
					}
				});
				if(sourcr1flag=="Y")
				{
					$("#MKBKMBFlagF").checkbox('enable');
				}
				else
				{
					$("#MKBKMBFlagF").checkbox('disable');	
				}	        
		    }	        
		});
		$('#A'+mainrow).validatebox({});
	}
	
	mainrow++;
}

/*************************************************添加/删除主列结束*********************************/
/*************************************************选项上移下移开始*********************************/
// 上移 
function moveUp(obj) { 
	var current = $(obj).parent().parent(); //获取当前<tr>
	var prev = current.prev();  //获取当前<tr>前一个元素
	if (current.index() > 1) { 
		current.insertBefore(prev); //插入到当前<tr>前一个元素前
		current.find('input').each(function(){
			$(this).focus();//将光标默认到该行
		});
	} 
	else
		{
			$.messager.popover({msg: '不能越过列名！',type:'alert'});
		}
} 

// 下移 
function moveDown(obj) { 
  var current = $(obj).parent().parent(); //获取当前<tr>
  var next = current.next(); //获取当前<tr>后面一个元素
  if (next.length>0) 
  { 
    current.insertAfter(next);  //插入到当前<tr>后面一个元素后面
    current.find('input').each(function(){
    	$(this).focus();//将光标默认到该行
    });
  } 
  else
  {
        $.messager.popover({msg: '这已经是最后一个了！',type:'alert'}); 
  }
} 
//选项按钮隐藏和显示
function hoverTr()
{
	$(".hovertr").hover(function(){
		var newtd="<img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='padding-left:10px;border: 0px;cursor:pointer' onclick='moveDown(this)'><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delCombo(this)' style='padding-left:10px;border: 0px;cursor:pointer'>";
		//$(this).children('.hidetd').remove();
		$(this).children(".childhover").html("");
		$(this).children(".childhover").append(newtd);
		
	}, function() {
		$(this).children(".childhover").html("");
	})
}
function hoverTrForJust()
{
	$(".hovertr").hover(function(){
		var newtd="<img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='padding-left:10px;border: 0px;cursor:pointer' onclick='moveDown(this)'>";
		//$(this).children('.hidetd').remove();
		$(this).children(".childhover").html("");
		$(this).children(".childhover").append(newtd);
		
	}, function() {
		$(this).children(".childhover").html("");
	})
}
/*************************************************选项上移下移结束*********************************/
/*************************************************扩展列上移下移删除复制开始*********************************/
// 上移 
function moveUpAll(obj) { 
  var current = $(obj).parent().parent().parent(); //获取当前所在div
  var prev = current.prev();  //获取当前div前一个元素
  if (current.index() > 0) { 
    current.insertBefore(prev); //插入到当前div前一个元素前
    //将列的标签重新命名
	var num=1;
	$('#overshow').find('p').each(function(){
		$(this).text("列"+num);
		num++;
	})
  } 
  else
  	{
  		    /*$.messager.show
              ({ 
                  title: '提示消息', 
                  msg: '不能越过主列项！', 
                  showType: 'show', 
                  timeout: 1000, 
                  style: { 
                  right: '', 
                  bottom: ''
                  } 
             }); */
             $.messager.popover({msg: '不能越过主列项！',type:'alert'});
  	}
} 
// 下移 
function moveDownAll(obj) { 
  var current = $(obj).parent().parent().parent(); //获取当前所在div
  var next = current.next(); //获取当前div后面一个元素
  if (next.length>0) 
  { 
    current.insertAfter(next);  //插入到当前div后面一个元素后面
    //将列的标签重新命名
	var num=1;
	$('#overshow').find('p').each(function(){
		$(this).text("列"+num);
		num++;
	})
  } 
  else
  {
  	        /*$.messager.show
              ({ 
                  title: '提示消息', 
                  msg: '已经是最后一个了！', 
                  showType: 'show', 
                  timeout: 1000, 
                  style: { 
                  right: '', 
                  bottom: ''
                  } 
             });*/
             $.messager.popover({msg: '这已经是最后一个了！',type:'alert'}); 
  }
}
/*************************************************扩展列上移下移删除复制结束*********************************/
	//点击删除通用按钮方法
    function delCombo(obj)
    {
    	var current = $(obj).parent().parent(); //获取当前<tr>
    	//获取上一个
    	var prev = current.prev();  //获取当前div前一个元素
    	//获取下一个
    	var next = current.next(); //获取当前div后面一个元素
    	if(prev.length==1 && next.length<0)
    	{
    		/*$.messager.show
              ({ 
                  title: '提示消息', 
                  msg: '至少存在一个选项，不能再删了！', 
                  showType: 'show', 
                  timeout: 1000, 
                  style: { 
                  right: '', 
                  bottom: ''
                  } 
            }); */
            $.messager.popover({msg: '至少存在一个选项，不能再删了！',type:'alert'});
    	}
    	else
    	{
	    	//var delCom=current.attr('readonly');
	    	var delCom=current.find('.hisbox').attr('readonly');
	    	if(delCom==undefined)
	    	{
		    	current.remove();	
		    }
		    else
		    {
			    $.messager.alert('提示','该数据已经在知识点映射管理表中维护了信息，不能删除！',"error");
        		return;
			}	   	
    		//将列的标签重新命名
			var num=1;
			$('#overshow').find('p').each(function(){
				$(this).text("列"+num);
			num++;
			})
    	}
    	
    }
var init = function(){
	$("#MKBKMBFlagF").checkbox('disable');//刚进入页面时，生成右键菜单多选框设置为不可选
	//主列删除
	delMainColumn=function(obj)
	{
		var record = mygrid.getSelected();
		var rowid="";
		var ID=$(obj).attr("id");//Bwhole1
		$('#'+ID).find('.hiddenRowid').each(function(){
				rowid=$(this).text();
		});
		if (record && rowid!="")
		{
			var hasDataFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","hasDetail",record.MKBKMBRowId);
			if(hasDataFlag=="Y")
			{
				$.messager.alert('提示','该数据已经在知识点映射管理表中维护了信息，不能删除！',"error");
				return;
			}			
			$.messager.confirm('提示', '确定要删除所选数据吗?', function(r){
				if(r){
					$(obj).remove();
					//将列的标签重新命名
					var num=1;
					$('#overshow').find('p').each(function(){
						$(this).text("列"+num);
						num++;
					})
					$.ajax({
		                url:DELETE_CONM_URL,
		                data:{"id":rowid},
		                type:"POST",
		                success: function(data){
		                    var data=eval('('+data+')');
		                    if (data.success == 'true') {
		                        /*$.messager.show({
		                            title: '提示消息',
		                            msg: '删除列信息成功',
		                            showType: 'show',
		                            timeout: 1000,
		                            style: {
		                                right: '',
		                                bottom: ''
		                            }
		                        });*/
		                        $.messager.popover({msg: '删除列信息成功！',type:'success',timeout: 1000});
		                    }
		                    else
		                    {
		                        var errorMsg ="删除失败！"
		                        if (data.info)
		                        {
		                            errorMsg =errorMsg+ '<br/>错误信息:' + data.info
		                        }
		                        $.messager.alert('操作提示',errorMsg,"error");

		                    }
		                }
		            })
				}	
			})

		}
		else
		{
			$(obj).remove();
			//将列的标签重新命名
			var num=1;
			$('#overshow').find('p').each(function(){
				$(this).text("列"+num);
				num++;
			})
		}
		
	
	}
	
	/******************************************************左侧表单开始******************************************************/
	//映射关系下拉框
	$('#MKBKMBMappingRelation').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'1',text:'单向映射(从1到2)'},
			{id:'2',text:'单向映射(从2到1)'},
			{id:'3',text:'双向映射'}		
		],
		value:3 //默认单项1-2
	});
	//知识库标识下拉框
	$('#MKBKMBIdentify').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'SD',text:'同义诊断'},
			{id:'DD',text:'鉴别诊断'},
			{id:'LC',text:'文献对照'},
			{id:'RF',text:'推荐评估表'},	
			{id:'CD',text:'科室常用诊断'},
			{id:'PD',text:'科室专业诊断'},	
			{id:'CJ',text:'引用诊断'},
			{id:'DM',text:'诊断标记'},
			{id:'LL',text:'科室对照'}
		]
	});	
	//知识点1下拉框
	$('#MKBKMBKnowledge1').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
        valueField:'ID',
        textField:'Desc',
        //readonly:true,
        /*keyHandler:{
        query:function(){
	            var desc=$.trim($('#MKBKMBKnowledge1').combobox('getText'));
                $('#MKBKMBKnowledge1').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array&desc="+encodeURI(desc));
                $('#MKBKMBKnowledge1').combobox("setValue",desc);
             }  
         },*/
        mode:'remote', 
        onSelect:function(record){
	        var baseid=record.ID;
	        $('.source1').combobox('clear');
	        $('.source1').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+record.ID);
			var basedesc=record.Desc;
			$('.sourceknow1').text("（"+basedesc+"）");
			} 
    });
    //知识点2下拉框
	$('#MKBKMBKnowledge2').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
        valueField:'ID',
        textField:'Desc',
        /*keyHandler:{
        query:function(){
	            var desc=$.trim($('#MKBKMBKnowledge2').combobox('getText'));
                $('#MKBKMBKnowledge2').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array&desc="+encodeURI(desc));
                $('#MKBKMBKnowledge2').combobox("setValue",desc);
             }  
         },*/
        mode:'remote', 
        onSelect:function(record){
	        var baseid=record.ID;
	        $('.source2').combobox('clear');
	        $('.source2').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+record.ID);
	        var basedesc=record.Desc;
			$('.sourceknow2').text("（"+basedesc+"）")
			//var a1=$('#MKBKMBKnowledge1').val()
	        }
    });
   	//展示列1下拉框
	$('.source1').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array",
        valueField:'ID',
        textField:'Desc',
        onSelect:function(record)
        {
			var sourcr1flag="N";
			$('#addMainCo').find('.source1,.source2').each(function(){
				var sourcejust=$(this).combobox('getText');
				//alert(sourcejust)
				if(sourcejust=="知识表达式" || sourcejust=="Exp")
				{
					sourcr1flag="Y";
				}
			});
			if(sourcr1flag=="Y")
			{
				$("#MKBKMBFlagF").checkbox('enable');
			}
			else
			{
				$("#MKBKMBFlagF").checkbox('disable');	
			}	        
	    }      	
    });

    //展示列2下拉框
	$('.source2').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array",
        valueField:'ID',
        textField:'Desc',
        onSelect:function(record)
        {
			var sourcr2flag="N";
			$('#addMainCo').find('.source1,.source2').each(function(){
				var sourcejust=$(this).combobox('getText');
				//alert(sourcejust)
				if(sourcejust=="知识表达式" || sourcejust=="Exp")
				{
					sourcr2flag="Y";
				}
			});
			if(sourcr2flag=="Y")
			{
				$("#MKBKMBFlagF").checkbox('enable');
			}
			else
			{
				$("#MKBKMBFlagF").checkbox('disable');	
			}	        
	    }        
    });
    //菜单多选框tooltip
	var toti = $HUI.tooltip('#menu_save',{
        content:"勾选后将在知识管理界面的属性条目中生成对</br>应功能菜单，在知识构建过程中可以维护规则。",
        position: 'bottom' //top , right, bottom, left
    });    
	/********************************************************左侧表单结束******************************************/
    var rownumber=3;//记录条数
	var row=3;
    //整体效果按钮通用方法
    var DELETE_CONM_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingBaseField&pClassMethod=DeleteData";
    function moveAll()
    {
    	$(".movediv").hover(function(){
	    		//显示添加按钮
	    		$(this).find('.addhover').each(function(){
		    		$(this).show();
		    	})
  				var html_cz = "<div style='float:left;padding-left:30px' class='kzqy_czbut'><img class='sy' src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='padding-right:10px;border: 0px;cursor:pointer' onclick='moveUpAll(this)'></br><img class='xy' src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='padding-right:10px;padding-top:10px;border: 0px;cursor:pointer' onclick='moveDownAll(this)'></br><img class='fz' src='../scripts/bdp/Framework/icons/mkb/copyorder.png' style='padding-right:10px;padding-top:10px;border:0px;cursor:pointer' ></br><img class='sc' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' style='padding-right:10px;padding-top:10px;border:0px;cursor:pointer'></div>";
  				$(this).children(".allbarclass").children(".kzqy_czbut").remove();
  				//$(this).children(".classChild").after(html_cz);
  				$(this).children(".allbarclass").append(html_cz);
  				var whole=$(this).attr("id").split("whole")[1]//获取本块的顺序数字 
  				var flag=whole.split("A")[2];
  				var idNum=whole.split("A")[1];
  				//点击删除整体按钮
  				$('.sc').click(function(e){
	  				var record = mygrid.getSelected();
	  				var current = $(this).parent().parent().parent();
	  				var rowid="";
	  				current.find('.hiddenRowid').each(function(){
		  				rowid=$(this).text();
		  				})
					if (record && rowid!="")
					{
						var hasDataFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","hasDetail",record.MKBKMBRowId);
						if(hasDataFlag=="Y")
						{
							$.messager.alert('提示','该数据已经在知识点映射管理表中维护了信息，不能删除！',"error");
        					return;
						}
						/*var rowid="";
						$(this).parent().parent().parent().find('.hiddenRowid').each(function(){
							rowid=$(this).text();
							})*/
						$.messager.confirm('提示', '确定要删除所选数据吗?', function(r){
							if(r){
								current.remove();
			  					rownumber--;
			  					var num=1;
								$('#overshow').find('p').each(function(){
									$(this).text("列"+num);
									num++;
								})	
								$.ajax({
					                url:DELETE_CONM_URL,
					                data:{"id":rowid},
					                type:"POST",
					                success: function(data){
					                    var data=eval('('+data+')');
					                    if (data.success == 'true') {
					                        /*$.messager.show({
					                            title: '提示消息',
					                            msg: '删除列信息成功',
					                            showType: 'show',
					                            timeout: 1000,
					                            style: {
					                                right: '',
					                                bottom: ''
					                            }
					                        });*/
					                        $.messager.popover({msg: '删除列信息成功！',type:'success',timeout: 1000});
					                    }
					                    else
					                    {
					                        var errorMsg ="删除失败！"
					                        if (data.info)
					                        {
					                            errorMsg =errorMsg+ '<br/>错误信息:' + data.info
					                        }
					                        $.messager.alert('操作提示',errorMsg,"error");

					                    }
					                }
					            })
							}	
						})

					}
					else
					{
						var current = $(this).parent().parent().parent();
	  					current.remove();
	  					rownumber--;
	  					var num=1;
						$('#overshow').find('p').each(function(){
							$(this).text("列"+num);
							num++;
						})
					}

  				})
  				//点击复制按钮
  				$('.fz').click(function(e){
  					var insideNum=2;
    				var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    				var insidecount=1;//记录条数
  					//获取标题
	  				var num=1
  					$('#table'+idNum).find('input').each(function(){
  						//var text=$(this).text();
  						var text=$(this).val();
  						if(num==1){
	    					if(flag=="C")
	    					{
		    					var newDiv="<div class='movediv' id='wholeA"+row+"AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  align='center' style='float:left;padding:10px 10px 10px 1px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（下拉框）</td></tr></table></div></div>";
		  						$('#registerMain').append(newDiv);
		  						//添加新扩展列跳转
    							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AC").offset().top},500);
		  						//location.hash="#wholeA"+row+"AC"
		  						$('#positionId'+row).focus();
								//插入单条按钮
								var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td style='display:none' class='addhover'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
								$('#divID'+row).append(newbutton);
								//插入多条按钮
								var muchbutton="<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
								$('#toolstr'+row).append(muchbutton);
								//var insideNum1=insideNum-1;	
								addComSelect(row,otherrow,insideNum,insidecount);
						    	moveAll();
	    					}
	    					if(flag=="R")
	  						{
		  						var newDiv="<div class='movediv' id='wholeA"+row+"AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（单选框）</td></tr></table></div></div>";
		  						$('#registerMain').append(newDiv);
		  						//添加新扩展列跳转
    							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AR").offset().top},500);
		  						//window.location.hash="#wholeA"+row+"AR"
		  						$('#positionId'+row).focus();
								//插入单条按钮
								var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
								$('#divID'+row).append(newbutton);
								//插入多条按钮
								var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
								$('#toolstr'+row).append(muchbutton);
								addRadSelect(row,otherrow,insideNum,insidecount);	
						    	moveAll();

	  						}
	  						if(flag=="H")
	  						{
		  						var newDiv="<div class='movediv'  id='wholeA"+row+"AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（复选框）</td></tr></table></div></div>";
		  						$('#registerMain').append(newDiv);
		  						//添加新扩展列跳转
    							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AH").offset().top},500);
		  						//window.location.hash="#wholeA"+row+"AH"
		  						$('#positionId'+row).focus();
								//插入单条按钮
								var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
								$('#divID'+row).append(newbutton);
								//插入多条按钮
								var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
								$('#toolstr'+row).append(muchbutton);	
								addCheckSelected(row,otherrow,insideNum,insidecount);
						    	moveAll();
	  						}
	  						if(flag=="I")
	  						{
		  						var newDiv="<div class='movediv' id='wholeA"+row+"AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（单行文本）</td></tr></table></div></div>";
		  						$('#registerMain').append(newDiv);
		  						//添加新扩展列跳转
    							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AI").offset().top},500);
		  						//window.location.hash="#wholeA"+row+"AI"
		  						$('#positionId'+row).focus();	
		  							moveAll();
		  						$('.hisbox').validatebox({
								});
	  						}
	  						if(flag=="T")
	  						{
		  						var newDiv="<div class='movediv' id='wholeA"+row+"AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（多行文本）</td></tr></table></div></div>";
		  						$('#registerMain').append(newDiv);
		  						//添加新扩展列跳转
    							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AT").offset().top},500);
		  						//window.location.hash="#wholeA"+row+"AT"
		  						$('#positionId'+row).focus();
		  						moveAll();
		  						$('.hisbox').validatebox({
								});
							  }
							  if(flag == "P")
							  {
								//引用术语类型
								var newDiv="<div class='movediv' id='wholeA"+row+"AP' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+text+"'></td><td>（引用术语）</td></tr><tr><td align='right'>术语</td><td><input class='histermbox' style='width:257px;' id='TermNum"+row+"A1' type='text'></tr></table></div></div>";
								$('#registerMain').append(newDiv);

								$('#TermNum'+row+'A1').combobox({
									url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
									valueField:'ID',
									textField:'Desc',
									mode:'remote'
								});
								var value = $('#TermNum'+idNum+'A1').combobox('getValue');
								$('#TermNum'+row+'A1').combobox('setValue',value)
								$('#positionId'+row).focus();
								moveAll();
								$('.hisbox').validatebox({
							  	});
							  }
							
  						}
  						num++;
  					})
  					//获取选项
  					var num2=1;
  					$('#table'+idNum).find('input').each(function(){
	  					if(num2!=1){
	  						var values=$(this).val();
	  						if(flag=="C")
	  						{
	  							var addRow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'>选项"+(insideNum-1)+"</td><td><input class='hisbox' style='width:250px;' value='"+values+"' id='comboNum"+otherrow+"A"+insideNum+"' type='text'></td><td class='childhover'></td></tr>";
	  							$('#table'+otherrow).append(addRow);
	  							hoverTr()
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
	  							insideNum++;
	  							insidecount++;
	  						}
	  						if(flag=="R" && values!="")
	  						{

	  							var addRow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'><input name='radio"+otherrow+"' type='radio' class='allRadio' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text' value='"+values+"'></td> <td class='childhover'></td></tr>";
	  							$('#table'+otherrow).append(addRow);
	  							hoverTr();
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
	  							//将单选框渲染成hisui样式
	    						$HUI.radio('.allRadio',{
								});
	  							insideNum++;
	  							insidecount++;
	  						}
	  						if(flag=="H" && values!="")
	  						{
	  							var addRow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'><input name='checkbox"+otherrow+"' class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"'  value='"+values+"' type='text'></td> <td class='childhover'></td></tr>";
	  							$('#table'+otherrow).append(addRow);
	  							hoverTr();
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
	  							//将duo选框渲染成hisui样式
							    $HUI.checkbox('.allCheck',{
								});
	  							insideNum++;
	  							insidecount++;
	  						}
  						}
  						num2++;				
  					})
  					row++;
					var numN=1;
					$('#overshow').find('p').each(function(){
						$(this).text("列"+numN);
						numN++;
					})
  				})
			},function(){
  				$(this).children(".allbarclass").children(".kzqy_czbut").remove();
  				//$('.tableshow').hide();
  				//隐藏添加按钮
	    		$(this).find('.addhover').each(function(){
		    		$(this).hide();
		    	})
		});
    } 
    /*************************************************新增下拉框按钮点击事件开始*********************************/
    $('#addCombobox').click(function (e){
    	var insideNum=3;
    	var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    	var insidecount=3;//记录条数
    	var newDiv="<div class='movediv' id='wholeA"+row+"AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  align='center' style='float:left;padding:10px 10px 10px 1px;border-left:#40a2de solid 0px;'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td>（下拉框）</td></tr><tr class='hovertr' id='option"+row+"A2'><td align='right'>选项1</td><td><input class='hisbox' style='width:250px;' id='comboNum"+row+"A1' type='text'><td class='childhover'></td></td></tr><tr class='hovertr' id='option"+row+"A3'><td align='right'>选项2</td><td><input class='hisbox' style='width:250px;' id='comboNum"+row+"A2' type='text'></td><td class='childhover'></td></tr></table></div></div>";
    	$('#registerMain').append(newDiv);
    	//输入框变为hisui样式
		$('.hisbox').validatebox({
		});
		//添加新扩展列跳转
    	//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AC").offset().top},500);
    	//window.location.hash="#wholeA"+row+"AC";
    	$('#positionId'+row).focus();
    	//添加单条按钮
    	var newbutton="<table  align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td style='display:none' class='addhover'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></td></tr></table>";
    	$('#divID'+row).append(newbutton);
    	//插入多条按钮
    	var muchbutton="<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
    	$('#toolstr'+row).append(muchbutton);
    	moveAll();
		addComSelect(row,otherrow,insideNum,insidecount);
    	row++;
    	rownumber++;
    	hoverTr();
    	var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
		})
    })
    /*************************************************新增下拉框按钮点击事件结束*********************************/
    /*************************************************新增单选按钮点击事件开始*********************************/
    $('#addRadio').click(function (e){
    	var insideNum=3;
    	var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    	var insidecount=3;//记录条数
    	//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#F4F6F5'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='单选框' type='text'></td></tr></table><table style='padding-left:80px;' id='table"+row+"'><tr id='option"+row+"A2'><td  class='tdlabel'><input name='radio"+row+"' type='radio' value=''></td><td><input id='comboNum"+row+"A1' value='选项1' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr><tr><td class='tdlabel'><input name='radio"+row+"' type='radio' value=''></td><td><input id='comboNum"+row+"A2' value='选项2' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr></table></div></div>"
    	var newDiv="<div class='movediv' id='wholeA"+row+"AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px;'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td>（单选框）</td></tr><tr class='hovertr' id='option"+row+"A2'><td  align='right'><input name='radio"+row+"' class='allRadio' type='radio' value=''></td><td><input  class='hisbox' style='width:250px;' id='comboNum"+row+"A1' placeholder='选项1' type='text'></td><td class='childhover'></td></tr><tr class='hovertr'><td align='right'><input name='radio"+row+"' class='allRadio' type='radio' value=''></td><td><input  class='hisbox' style='width:250px;' id='comboNum"+row+"A2' placeholder='选项2' type='text'></td><td class='childhover'></td></tr></table></div></div>";
    	$('#registerMain').append(newDiv);
    	//添加新扩展列跳转
    	//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AR").offset().top},500);
    	//window.location.hash="#wholeA"+row+"AR";
    	$('#positionId'+row).focus();
    	hoverTr();
    	//输入框变为hisui样式
		$('.hisbox').validatebox({
		});
    	//将单选框渲染成hisui样式
    	$HUI.radio('.allRadio',{
		});
    	//添加单条按钮
    	var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></tr></table>";
    	$('#divID'+row).append(newbutton);
    	//插入多条按钮
    	var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
    	$('#toolstr'+row).append(muchbutton);
    	moveAll();
		addRadSelect(row,otherrow,insideNum,insidecount)
    	row++;
    	rownumber++;
    	var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num)
			num++;
		})
    })
    /*************************************************新增单选按钮点击事件结束*********************************/
    /*************************************************新增多选按钮点击事件开始*********************************/
    $('#addCheckbox').click(function (e){
    	var insideNum=3;
    	var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    	var insidecount=3;//记录条数
    	//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#F4F6F5'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='复选框' type='text'></td></tr></table><table style='padding-left:80px;' id='table"+row+"'><tr id='option"+row+"A2'><td  class='tdlabel'><input name='checkbox"+row+"' type='checkbox' value=''></td><td><input id='comboNum"+row+"A1' value='选项1' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr><tr><td class='tdlabel'><input name='checkbox"+row+"' type='checkbox' value=''></td><td><input id='comboNum"+row+"A2' value='选项2' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr></table></div></div>"
    	var newDiv="<div class='movediv'  id='wholeA"+row+"AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td align='left'>（复选框）</td></tr><tr class='hovertr' id='option"+row+"A2'><td  align='right'><input name='checkbox"+row+"' class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+row+"A1' placeholder='选项1' type='text'></td><td class='childhover'></td></tr><tr class='hovertr'><td align='right'><input name='checkbox"+row+"'  class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+row+"A2' placeholder='选项2' type='text'></td><td class='childhover'></td></tr></table></div></div>";
    	$('#registerMain').append(newDiv);
    	//添加新扩展列跳转
    	//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AH").offset().top},500);
    	//window.location.hash="#wholeA"+row+"AH"
    	$('#positionId'+row).focus();
    	hoverTr();
    	//输入框变为hisui样式
		$('.hisbox').validatebox({
		});
		//将duo选框渲染成hisui样式
    	$HUI.checkbox('.allCheck',{
		});
    	//添加单条按钮
    	var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></tr></table>";
    	$('#divID'+row).append(newbutton);
    	//插入多条按钮
    	var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
    	$('#toolstr'+row).append(muchbutton);
    	moveAll();
		addCheckSelected(row,otherrow,insideNum,insidecount);
    	row++;
    	rownumber++;
    	var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
		})
    })
    /*************************************************新增多选按钮点击事件结束*********************************/
    /*************************************************新增单行文本点击事件开始*********************************/
    $('#addText').click(function (e){
    	var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    	//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#F4F6F5'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='单行文本' type='text'></td></tr></table></div></div>"
    	var newDiv="<div class='movediv' id='wholeA"+row+"AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p class='allbarclass' style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td>（单行文本）</td></tr></table></div></div>";
    	$('#registerMain').append(newDiv);
    	//添加新扩展列跳转
    	//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AI").offset().top},500);
    	//window.location.hash="#wholeA"+row+"AI";
    	$('#positionId'+row).focus();
    	moveAll();
    	row++;
    	rownumber++;
    	var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
		})
		$('.hisbox').validatebox({
			});
    })
    /*************************************************新增多选按钮点击事件结束*********************************/
    /*************************************************新增多行文本点击事件开始*********************************/
    $('#addTexts').click(function (e){
    	var otherrow=row;//从新定义一个变量避免在添加选项时冲突
    	//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#F4F6F5'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='多行文本' type='text'></td></tr></table></div></div>"
    	var newDiv="<div class='movediv' id='wholeA"+row+"AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td>（多行文本）</td></tr></table></div></div>";
    	$('#registerMain').append(newDiv);
    	//添加新扩展列跳转
    	//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AT").offset().top},500);
    	//window.location.hash="#wholeA"+row+"AT";
    	$('#positionId'+row).focus();
    	moveAll();
    	row++;
    	rownumber++;
    	var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
		})
		$('.hisbox').validatebox({
			});
    })
	/*************************************************新增多行文本点击事件结束*********************************/
	/*************************************************新增引用术语点击事件开始*********************************/
	$('#addTerm').click(function (e){
		var otherrow=row;//从新定义一个变量避免在添加选项时冲突
		//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#F4F6F5'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='多行文本' type='text'></td></tr></table></div></div>"
		var newDiv="<div class='movediv' id='wholeA"+row+"AP' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text'></td><td>（引用术语）</td></tr><tr><td align='right'>术语</td><td><input class='histermbox' style='width:257px;' id='TermNum"+row+"A1' type='text'></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AT").offset().top},500);
		//window.location.hash="#wholeA"+row+"AT";
		$('#positionId'+row).focus();
		$('#TermNum'+row+'A1').combobox({
			url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
			valueField:'ID',
			textField:'Desc',
			mode:'remote'
		});
		moveAll();
		row++;
		rownumber++;
		var num=1;
		$('#overshow').find('p').each(function(){
			$(this).text("列"+num);
			num++;
		})
		$('.hisbox').validatebox({
			});
	})
	/*************************************************新增引用术语点击事件结束*********************************/
	
    //var SAVE_BASE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingBase&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBKLMappingBase";
    //点击保存按钮
   	$("#btnSave").click(function(e){
	   	saveLeftForm(1);
	   	})
	 function saveLeftForm(flag)
	 {
	 	var record = mygrid.getSelected();
	 	if(record)
	 	{
		 	var id=record.MKBKMBRowId;
		}
		else
		{
			var id="";
		}
		var desc=$('#MKBKMBDesc').val();
		if(desc=="")
		{
			$.messager.alert('错误提示','标题不能为空!',"error");
        	return;
		}
		/*var forreload1=$('#forreload1').val();
		var forreload2=$('#forreload2').val();
		if(forreload1==""||forreload2=="")
		{
			$.messager.alert('错误提示','主列名称不能为空!',"error");
        	return;
		}
		/*var forload1=$('#forload1').combobox('getText');
		var forload2=$('#forload2').combobox('getText');
		if(forload1==""||forload2=="")
		{
			$.messager.alert('错误提示','列源不能为空!',"error");
        	return;
		}*/
		//判断知识点1知识点2是否为空
		var knodesc1=$('#MKBKMBKnowledge1').combobox('getText');
		var knodesc2=$('#MKBKMBKnowledge2').combobox('getText');
		if(knodesc1==""||knodesc2=="")
		{
			$.messager.alert('错误提示','请选择知识点!',"error");
        	return;
		}
		//列源不能为空
		var sourceflag=""
		$('#addMainCo').find('.source1,.source2').each(function(){
			var sourcetext=$(this).combobox('getText');
			if(sourcetext=="")
			{
				sourceflag="N";
				return false;
			}
		});	
		if(sourceflag=="N")
		{
			$.messager.alert('错误提示','列源不能为空!',"error");
        	return;			
		}		
		//判断是否有相同的列名
		var nameFlag="";
		var nameArray=[];
		var nameIndex=0;
		$('#addMainCo').find('.resizeA').each(function(){
			var mainText=$(this).val();
			nameArray[nameIndex]=mainText;
			nameIndex++;
		});		
		$('#registerMain').find('.for-just').each(function(){
			var nameId=$(this).attr("id");
			var nameTex=$(this).val();
			if(nameId==undefined)
			{
				nameArray[nameIndex]=nameTex;
				nameIndex++;
			}
			else
			{
				nameArray[nameIndex]=nameTex;
				nameIndex++;				
			}
				
		});
		var namenary=nameArray.sort();
		for(i=0;i<namenary.length;i++)
		{
			if (namenary[i]==namenary[i+1])
			{ 
				nameFlag="N";
			} 
		}
		if(nameFlag=="N")
		{
			$.messager.alert('错误提示','列名不能重复，请检查！',"error");
			return;				
		}
		//判断是否有空的列名
		var nullflag=""
		var comFlag=""
		$('#addMainCo').find('.resizeA').each(function(){
			var mainText=$(this).val();
			if(mainText=="")
			{
				nullflag="N";
    			return false;				
			}
		});		
		$('#registerMain').find('.hisbox').each(function(){
			var nameId=$(this).attr("id");
			var nameTex=$(this).val();
			if(nameId==undefined)
			{
				if(nameTex=="")
				{
					nullflag="N";
        			return false;
				}	
			}
			else
			{
				if(nameTex=="")
				{
					comFlag="N"
					return false;
				}
			}	
		});
		if(nullflag=="N")
		{
			$.messager.alert('错误提示','列名不能为空，请检查！',"error");
			return;				
		}
		//判断是否有空的配置项
		if(comFlag=="N")
		{
			$.messager.alert('错误提示','配置项不能为空，请检查！',"error");
			return;				
		}
		var MflagVal=$('#MKBKMBFlagF').checkbox('getValue');
		var Mflag="N"
		if(MflagVal)
		{
			Mflag="Y"
		}
		else
		{
			Mflag="N"
		}
		/*****不同的生成注册界面 *******/	
		var source_get1=$('#forload1').combobox('getText');//获取列源1描述
		var source_get2=$('#forload2').combobox('getText');//获取列源2描述
		if((source_get1 == "中心词" && source_get2 == "知识表达式") || (source_get1 == "知识表达式" && source_get2 == "中心词")){
			var SAVE_BASE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingBase&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBKLMappingBase";

		}else{
			var SAVE_BASE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingBase&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBKLMappingBase";
		}
		//保存开始							
		$('#form-save').form('submit', {
	        url: SAVE_BASE_URL,
	        onSubmit: function(param){
		        //alert($('#MKBKMBFlagF').checkbox('getValue'))
	            param.MKBKMBRowId = id;
	            param.MKBKMBFlag =Mflag;
	        },
	        success: function (data) {
					var data=eval('('+data+')');
	                var newid=data.id;
	                if (data.success == 'true') {
		                readColomn(newid)//添加成功后，添加扩展列
		                /****************同步术语库开始**************/
		                var sourceO=$('#forload1').combobox('getText');//获取列源1描述
		                var sourceT=$('#forload2').combobox('getText');//获取列源2描述
		                var relationId=$('#MKBKMBMappingRelation').combobox('getValue');
		                var proName=$('#MKBKMBDesc').val();//属性名称为规则描述
		                var proPId=data.id;//配置项为知识点映射注册的id
		                var baseId1=$('#MKBKMBKnowledge1').combobox('getValue');
		                var baseId2=$('#MKBKMBKnowledge2').combobox('getValue');
		                //var conItem=proName+"^"+proPId;
		                /*if(relationId==3)//双向映射
		                {
							if(sourceO=="中心词" && sourceT=="中心词"){
								var data1=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId1);
								var data2=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId2);   	
							}else if(sourceO=="中心词" && sourceT != "中心词"){
								var data1=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId1);
							}else if(sourceO!="中心词" && sourceT == "中心词"){
								var data2=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId2);
							}
			            }
			            else if(relationId==1 && sourceO=="中心词")//单向映射(从1到2)
			            {
							var data=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId1);
				        }
				        else if(relationId==2 && sourceT=="中心词")//单向映射(从2到1)
				        {
					       	 var data=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","SaveBasePro",proName,proPId,baseId2);
					    }*/
		               	/****************同步术语库结束**************/ 
	                    /*$.messager.show({ 
	                      title: '提示消息', 
	                      msg: '保存成功', 
	                      showType: 'show', 
	                      timeout: 700, 
	                      style: { 
	                        right: '', 
	                        bottom: ''
	                      } 
	                    });*/
	                    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
	                $('#mappingbasegrid').datagrid('reload');  // 重新载入当前页面数据
	                if(flag==1)
	                {
		                setTimeout(function(){
			                $('#mappingbasegrid').datagrid('selectRecord',newid)
		                	viewAllData();	
		                },100);
		                
		            }
		            else if(flag==2)
		            {
			            ClearAllData(1)//点击知识点注册映射按钮
			        }
	                
	            }
	            else {
	                var errorMsg ="更新失败！";
	                if (data.errorinfo) {
						if((data.errorinfo).indexOf("键不唯一")>-1||(data.errorinfo).indexOf("unique")>-1){
							errorMsg =errorMsg+ '<br/>错误信息:已存在选中标识，请重新选择！';
						}else{
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo;
						}   
	                }
	                $.messager.alert('操作提示',errorMsg,"error");

	            }

	        }
	   });

	}
	//点击左侧重置按钮
	$('#btnLeftRefresh').click(function(e){
		 //解锁
		 $HUI.checkbox("#MKBKMBFlagF").setValue(false);
		 $("#MKBKMBFlagF").checkbox('disable');		 
		 $('#lockForm').unmask();
		 $('#mbedit').menubutton('enable');
	     $('#btnSave').linkbutton('enable');	
	     $('#btnRefresh').linkbutton('enable');
		ClearAllData(1);
	})
	 function ClearAllData(flag)
	 {
		 $("#TextDesc").combobox('setValue', '');
		 $('#registerMain').html("");//清掉扩展列
		 $('#addMainCo').html("");//清掉主列
		 var newmain1="<div class='maindiv' id='Awhole'  style='margin:20px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input type='text' id='forreload1' class='resizeA'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='forload1' class='source1'  style='width:257px;'></td><td class='sourceknow1'>（知识点1）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addMainColumn(this,1)' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
		 $('#addMainCo').append(newmain1);
		 var newmain2="<div class='maindiv' id='Bwhole'  style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列2</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input type='text' id='forreload2' class='resizeA'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='forload2'class='source2'  style='width:257px;'></td><td class='sourceknow2'>（知识点2）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addMainColumn(this,2)' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
		 $('#addMainCo').append(newmain2);
		 $('.resizeA').validatebox({});
	     //展示列1下拉框
		 $('.source1').combobox({
	        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array",
	        valueField:'ID',
	        textField:'Desc',
	        onSelect:function(record)
	        {
				var sourcr1flag="N";
				$('#addMainCo').find('.source1,.source2').each(function(){
					var sourcejust=$(this).combobox('getText');
					//alert(sourcejust)
					if(sourcejust=="知识表达式" || sourcejust=="Exp")
					{
						sourcr1flag="Y";
					}
				});
				if(sourcr1flag=="Y")
				{
					$("#MKBKMBFlagF").checkbox('enable');
				}
				else
				{
					$("#MKBKMBFlagF").checkbox('disable');	
				}	        
		    }	              	
	     });

	     //展示列2下拉框
		 $('.source2').combobox({
	        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array",
	        valueField:'ID',
	        textField:'Desc',
	        onSelect:function(record)
	        {
				var sourcr2flag="N";
				$('#addMainCo').find('.source1,.source2').each(function(){
					var sourcejust=$(this).combobox('getText');
					//alert(sourcejust)
					if(sourcejust=="知识表达式" || sourcejust=="Exp")
					{
						sourcr2flag="Y";
					}
				});
				if(sourcr2flag=="Y")
				{
					$("#MKBKMBFlagF").checkbox('enable');
				}
				else
				{
					$("#MKBKMBFlagF").checkbox('disable');	
				}	        
		    }	        
	     });
//	     $('#MKBKMBKnowledge1').combobox('reload')
//	     $('#MKBKMBKnowledge2').combobox('reload')
	     //左边重置和右边重置的区别
	     if(flag==1)
	     {
		    $('#form-save').form('clear');//刷新表格
		    $HUI.checkbox("#MKBKMBFlagF").setValue(false);
		    $("#MKBKMBFlagF").checkbox('disable');
		    $('#MKBKMBMappingRelation').combobox('setValue',3)
			$('#mappingbasegrid').datagrid('load',  {
            	ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
            	QueryName:"GetList"
        	});
        	$('#mappingbasegrid').datagrid('unselectAll');
        	$('.combobox-f').combobox('readonly',false); 
			$('#layoutcenter').find('.combo').each(function(){
    			$(this).find('input').each(function(){
	    			$(this).css({'background-color':'#FFFFFF'});
	    			})
    			});
    		//切换锁死图标和文字
		     var sp = $('#btnForbid span span:last'), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
    		 //sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-lockdata');
    		 if(!add)
    		 {
        		  $('#btnForbid span span:last').removeClass('icon-unlock');
		     	  $('#btnForbid span span:last').addClass('icon-lockdata'); 
        	 }	     
		     $('#btnForbid span span:first').text('锁死');	    			          	
		 }
		 else if(flag==2)
		 {
			//$('#MKBKMBKnowledge1').combobox('reload')
			$('#form-save').form('clear');//刷新表格
			$HUI.checkbox("#MKBKMBFlagF").setValue(false);
			$("#MKBKMBFlagF").checkbox('disable');
			 //$('.combo-panel').prop('scrollTop',0);
			 //$('#MKBKMBKnowledge1').combobox('setValue',0)
			$('#MKBKMBMappingRelation').combobox('setValue',3)
			$('#mappingbasegrid').datagrid('load',  {
            	ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
            	QueryName:"GetList"
        	});
			viewAllData();
		 }
	     
	 }
	 //重置按钮
	 $('#btnRefresh').click(function(e){
		 ClearAllData(2);
		
	})
	//点击添加按钮
	 $('#btnAddBase').click(function(e){
		 //解锁
		 $HUI.checkbox("#MKBKMBFlagF").setValue(false);
		 $("#MKBKMBFlagF").checkbox('disable');
		 $('#lockForm').unmask();
		 $('#mbedit').menubutton('enable');	
	     $('#btnSave').linkbutton('enable');	
	     $('#btnRefresh').linkbutton('enable');
	     $('.combobox-f').combobox('readonly',false);
	     $('#layoutcenter').find('.combo').each(function(){
	    	 $(this).find('input').each(function(){
		    	$(this).css({'background-color':'#FFFFFF'});
		    })
	     });   
		 //确认是否保存当前页面
		var record = mygrid.getSelected();
		if(record)
		{
			var lockFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","MappingReadLock",record.MKBKMBRowId);
			if (lockFlag=="N")
			{
				$.messager.confirm('提示', '当前数据可能已经修改，如需保存，请点击确定按钮！', function(r){
					if(r)
					{
						saveLeftForm(2);
					}
					else
					{
						ClearAllData(1);
					}		
				})

			}
			else
			{
				ClearAllData(1);
			}
		}
		else
		{
			/*$.messager.confirm('提示', '是否保存新添加的数据！', function(r){
				if(r)
				{
					saveLeftForm(2);
				}
				else
				{*/
					ClearAllData(1);
				//}		
			//})			
		}
		$("#MKBKMBFlagF").checkbox('disable');	 
	 })
	 /*var toti = $HUI.tooltip('#btnAddBase',{
        content:"<img src='../scripts/bdp/Framework/icons/mkb/mapping_know.png'>注册新知识点映射",
        position: 'bottom' //top , right, bottom, left
    });*/
	 function readColomn(newid){
	   	var id=newid;
	   	var sequence=1;//给每一列一个顺序
	   	//遍历主列
	   	$("#addMainCo").find('.maindiv').each(function(){
		   	var str=id;
		   	//获取id
		   	$(this).find('.hiddenRowid').each(function(){
			  		var rowid=$(this).text();
			  		//alert(rowid)
			  		str=str+"&^"+rowid;	
			 })	
		   	//获取code
		   	$(this).find('.hiddenCode').each(function(){
			   		var code=$(this).text();
			   		str=str+"&^"+code;	
			})
			//判断是知识点1还是知识点2的列
			var whole=$(this).attr("id").split("whole")[0];
			if(whole=="A")
			{
				var Anum=1;
				var type="K1"
			   	$(this).find('input').each(function(){
				 	if(Anum==1)
				 	{	//列名
					 	var title=$(this).val();
					 	str=str+"&^"+title+"&^"+type;	
					}
					else if(Anum==2)
					{
						//alert($(this).attr("class"))
						var sourceone=$(this).combobox('getValue');
						str=str+"&^"+sourceone;
					}
					Anum++;	
				 })
				 str=str+"&^"+sequence;
				 sequence++;
			}
			else if(whole=="B")
			{
				var Bnum=1;
				var type="K2"
				$(this).find('input').each(function(){
					if(Bnum==1)
					{
						//列名
						var title=$(this).val();
						str=str+"&^"+title+"&^"+type;
					}
					else if(Bnum==2)
					{
						var sourcetwo=$(this).combobox('getValue');
						str=str+"&^"+sourcetwo;
					}
					Bnum++;	
				})
				str=str+"&^"+sequence;
				sequence++;
			}
			//存储,调用子表存储方法
			var jsonobj1=eval('('+tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBaseField","SaveEntity",str)+')');
			//alert(jsonobj.errorinfo)
//			if(jsonobj1.success=="false")
//			{
//				var errorMsg ="更新失败！"
//				if(jsonobj1.errorinfo)
//				{
//					errorMsg =errorMsg+ '<br/>错误信息:' + jsonobj1.errorinfo
//				}
//				$.messager.alert('操作提示',errorMsg,"error");
//			}
		})
		//遍历扩展列
	   	$("#registerMain").find('.movediv').each(function(){
		   	//判断扩展列的类型
		   	var str=id
		   	var whole=$(this).attr("id").split("whole")[1]; 
		   	var flag=whole.split("A")[2];
		   	//获取id
		   	$(this).find('.hiddenRowid').each(function(){
			  		var rowid=$(this).text();
			  		//alert(rowid)
			  		//alert(rowid)
			  		str=str+"&^"+rowid;  	
			 })	
		   	//获取code
		   	$(this).find('.hiddenCode').each(function(){
			   		var code=$(this).text();
			   		str=str+"&^"+code;	
			})
		   	if(flag=="C")
		   	{
			   	var type="C";
			   	var Cnum=1;
			   	var length=$(this).find('.hisbox').length;
			   	$(this).find('input').each(function(){
				   	var text=$(this).val()
				   	//第一个为列名
				   	if(Cnum==1)
				   	{
					   	str=str+"&^"+text+"&^"+type+"&^";
					}
					else
					{
						if(Cnum!=length)
						{
							str=str+text+"&%";
						}
						else if(Cnum==length)
						{
							str=str+text;
						}
					}
				   	Cnum++;
				})
				str=str+"&^"+sequence;
				sequence++;
			}
			else if(flag=="R")
			{
				var type="R";
			   	var Rnum=1;
			   	var length=$(this).find('.hisbox').length;
			   	$(this).find('.hisbox').each(function(){
				   	var text=$(this).val();
				   	//第一个为列名
				   	if(Rnum==1)
				   	{
					   	str=str+"&^"+text+"&^"+type+"&^";
					}
					else
					{
						if(Rnum!=length)
						{
							str=str+text+"&%";
						}
						else if(Rnum==length)
						{
							str=str+text;
						}
					}
				   	Rnum++;
				})
				str=str+"&^"+sequence;
				sequence++;
			}
			else if(flag=="H")
			{
				var type="CB"
			   	var Hnum=1;
			   	//alert($(this).find('.hisbox').length)
			   	var length=$(this).find('.hisbox').length;
			   	$(this).find('.hisbox').each(function(){
				   	var text=$(this).val();
				   	//第一个为列名
				   	if(Hnum==1)
				   	{
					   		str=str+"&^"+text+"&^"+type+"&^";
					}
					else
					{
						if(Hnum!=length)
						{
							str=str+text+"&%";
						}
						else if(Hnum==length)
						{
							str=str+text;
						}
						
					}
				   	Hnum++;
				})
				str=str+"&^"+sequence;
				sequence++;
			}
		   	else if(flag=="I")
		   	{
			   	var type="TX";
			   	$(this).find('input').each(function(){
				   	var text=$(this).val();
				   	str=str+"&^"+text+"&^"+type+"&^";
			   	}) 
			   	str=str+"&^"+sequence;
			   	sequence++; 	  	
			}
			else if(flag=="T")
			{
				var type="TA"
				$(this).find('input').each(function(){
					var text=$(this).val();
				   	str=str+"&^"+text+"&^"+type+"&^";
				}) 
				str=str+"&^"+sequence;
				sequence++;  
			}
			else if(flag == "P")
			{
				var type = "TP";
				$(this).find('.hisbox').each(function(){
					var text=$(this).val();
					str=str+"&^"+text+"&^"+type+"&^";
				})
				$(this).find('.histermbox').each(function(){
					var termid=$(this).combobox('getValue');
					str = str + termid
				})
				str=str+"&^"+sequence;
				sequence++; 				
			}
			var jsonobj2=eval('('+tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBaseField","SaveEntity",str)+')');
//			if(jsonobj2.success=="false")
//			{
//				var errorMsg ="更新失败！"
//				if(jsonobj2.errorinfo)
//				{
//					errorMsg =errorMsg+ '<br/>错误信息:' + jsonobj2.errorinfo
//				}
//				$.messager.alert('操作提示',errorMsg,"error");
//			}
		})	   	
	  }

//右键删除按钮
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingBase&pClassMethod=DeleteData";
DelBaseData=function()
{
	var record = mygrid.getSelected();
	var rowid=record.MKBKMBRowId;
	var lockFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","MappingReadLock",rowid);
	var hasDataFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","hasDetail",rowid);
	if(lockFlag=="Y")
	{
		alert("该数据已经锁死，不能删除！")
	}
	else
	{
		var tooltipForDel="确定要删除所选数据吗?";
		if(hasDataFlag=="Y")
		{
			tooltipForDel="该条数据已经在知识点映射管理表中维护了数据，如果删除数据将丢失，确定要删除吗？";
		}
		$.messager.confirm('提示', tooltipForDel, function(r){
			if (r)
			{
				  RefreshSearchData("User.MKBKLMappingBase",rowid,"D","")
			      $.ajax({
	                url:DELETE_ACTION_URL,
	                data:{"id":rowid},
	                type:"POST",
	                success: function(data){
	                    var data=eval('('+data+')');
	                    if (data.success == 'true') {
		                    //删除与术语库注册同步的数据
		                    /*var relationFlagId=$('#MKBKMBMappingRelation').combobox('getValue');
		                    var descForDel=$('#MKBKMBDesc').val();
		                    var baseIdForDel1=$('#MKBKMBKnowledge1').combobox('getValue');
		                    var baseIdForDel2=$('#MKBKMBKnowledge2').combobox('getValue');
		                    var sourceOD=$('#forload1').combobox('getText');//获取列源1描述
		                	var sourceTD=$('#forload2').combobox('getText');//获取列源2描述
		                    if(relationFlagId==1 && sourceTD=="中新词")//从1到2
		                    {
			                    var proid=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","findProIdByDesc",baseIdForDel2,descForDel);
			                   	var resultdetail=tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","DeleteData",proid);
			                   	 
			                }
			                else if (relationFlagId==2 && sourceOD=="中心词")//从2到1
			                {
				                var proid=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","findProIdByDesc",baseIdForDel2,descForDel);
				                var resultdetail=tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","DeleteData",proid);
				            }
				            else if(relationFlagId==3 && sourceTD=="中心词" && sourceOD=="中心词")
				            {
					            var proid1=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","findProIdByDesc",baseIdForDel1,descForDel);
					            var proid2=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","findProIdByDesc",baseIdForDel2,descForDel);
					            var resultdetail1=tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","DeleteData",proid1);
					            var resultdetail2=tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","DeleteData",proid2);
					        }*/
	                        /*$.messager.show({
	                            title: '提示消息',
	                            msg: '删除成功',
	                            showType: 'show',
	                            timeout: 1000,
	                            style: {
	                                right: '',
	                                bottom: ''
	                            }
	                        });*/
	                        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
	                        $('#mappingbasegrid').datagrid('load',  {
	                            ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
	                            QueryName:"GetList"
	                        });
	                        $HUI.checkbox("#MKBKMBFlagF").setValue(false);
		   					$("#MKBKMBFlagF").checkbox('disable');
	                        ClearAllData(1);
	                        // 重新载入当前页面数据
	                        $('#mappingbasegrid').datagrid('unselectAll');  // 清空列表选中数据
	                    }
	                    else
	                    {
	                        var errorMsg ="删除失败！";
	                        if (data.info)
	                        {
	                            errorMsg =errorMsg+ '<br/>错误信息:' + data.info;
	                        }
	                        $.messager.alert('操作提示',errorMsg,"error");

	                    }
	                }
	            })	
			}	
		})
	}
}
/**************************************************左侧列表显示开始**************************************************************/
    var basecolumns =[[
        {field:'MKBKMBRowId',title:'RowId',width:100,hidden:true,sortable:true},
        {field:'MKBKMBCode',title:'代码',width:100,sortable:true,hidden:true},
        {field:'MKBKMBDesc',title:'标题',width:100,sortable:true},
        {field:'MKBKMBMappingRelation',title:'映射关系',width:100,sortable:true,hidden:true},
        {field:'MKBKMBKnowledge1',title:'知识点1',width:100,sortable:true,hidden:true},
        {field:'MKBKMBKnowledge2',title:'知识点2',width:100,sortable:true,hidden:true},
        {field:'MKBKMBFlag',title:'菜单标志',width:100,sortable:true,hidden:true},
        {field:'MKBKMBSequence',title:'顺序',width:100,sortable:true,hidden:true,
        		sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
				}        
        },
        {field:'MKBKMBNote',title:'备注',width:100,sortable:true,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mappingbasegrid",{
	    url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
            QueryName:"GetList"
        },
        width:'100%',
        height:'100%',
        autoRowHeight: true,
        columns: basecolumns,  //列信息
        pagination: true,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        sortName : 'MKBKMBSequence',
		sortOrder : 'asc',         
        idField:'MKBKMBRowId',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        scrollbarSize :0,
        onClickRow:function(index,row)
        {
            viewAllData();
        },
        onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            changeUpDownStatus(rowIndex);
        	$('#leftBarForMove').menu('show', {    
				  left:e.pageX,  
				  top:e.pageY
			})
            /*var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
            $(
                '<div onclick="DelBaseData()" iconCls="icon-cancel" data-options="">删除</div>'+
                '<div onclick="OrderRole(1)" iconCls="icon-shiftup">上移</div>'+
				'<div onclick="OrderRole(2)" iconCls="icon-shiftdown">下移</div>' 
            ).appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });*/
		},
		onDblClickRow:function(rowIndex, rowData){
			var baseid = rowData.MKBKMBRowId;
			var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.klm."+rowData.MKBKMBCode);//baseid;
			var parentid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.klm");
			var menuimg=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);

			//判断浏览器版本
			var Sys = {};
			var ua = navigator.userAgent.toLowerCase();
			var s;
			(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
			(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
			(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
			(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
			(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
			//双击时跳转到对应界面
			if(!Sys.ie){
				window.parent.closeNavTab(menuid)
				window.parent.showNavTab(menuid,rowData.MKBKMBDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&mappingBase="+baseid,parentid,menuimg)
			}else{
				parent.PopToTab(menuid,rowData.MKBKMBDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&mappingBase="+baseid,menuimg);
			}

		}
    });
    /*******************************************************左侧数据删除、上移下移开始************************************************/
    $('#btnDelForM').click(function(e){
	    DelBaseData();
	});
    $('#btnUpForM').click(function(e){
	    OrderRole(1)
	});
    $('#btnDownForM').click(function(e){
	    OrderRole(2)
	}); 	 	 
	OrderRole=function (type){  
		//更新
		var row = $("#mappingbasegrid").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mappingbasegrid").datagrid('getRowIndex', row);
		mysort(index, type, "mappingbasegrid")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mappingbasegrid').datagrid('getSelected');  
		var rowIndex=$('#mappingbasegrid').datagrid('getRowIndex',nowrow);
		changeUpDownStatus(rowIndex)
		//遍历列表
		var order=""
		var rows = $('#mappingbasegrid').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].MKBKMBRowId; //频率id
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}	
		}
		//获取级别默认值
		$.m({
			ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
			MethodName:"SaveDragOrder",
			order:order
			},function(txtData){
			//alert(order+txtData)
		});
	} 
	function mysort(index, type, gridname) {
		if (1 == type) {
			if (index != 0) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
				$('#' + gridname).datagrid('getData').rows[index] = todown;
				$('#' + gridname).datagrid('getData').rows[index - 1] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index - 1);
				$('#' + gridname).datagrid('selectRow', index - 1);
			}
		} 
		else if (2 == type) {
			var rows = $('#' + gridname).datagrid('getRows').length;
			if (index != rows - 1) {
				var todown = $('#' + gridname).datagrid('getData').rows[index];
				var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
				$('#' + gridname).datagrid('getData').rows[index + 1] = todown;
				$('#' + gridname).datagrid('getData').rows[index] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index + 1);
				$('#' + gridname).datagrid('selectRow', index + 1);
			}
		}
	}
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
			if(rowIndex==0){
				$('#btnUpForM').linkbutton('disable');
				//$('#btnFirst').linkbutton('disable');
			}else
			{
				$('#btnUpForM').linkbutton('enable');
				//$('#btnFirst').linkbutton('enable');
			}
			var rows = $('#mappingbasegrid').datagrid('getRows');
			if ((rowIndex+1)==rows.length){
				$('#btnDownForM').linkbutton('disable');
			}else
			{
				$('#btnDownForM').linkbutton('enable');
			}
	}
	/************************************************************上移下移结束********************************************************************/		         
	//单机左侧列表数据，右侧加载
	function viewAllData()
	{
		var record = mygrid.getSelected();
		if (record)
		{
			 var id = record.MKBKMBRowId;
			 var savedesc=record.MKBKMBDesc;
			 $.cm({
                ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
                QueryName:"GetList",
                rowid:id
            },function(jsonData){
	             var data=JSON.parse(JSON.stringify(jsonData.rows).substring(1,JSON.stringify(jsonData.rows).length-1));
	             $('#MKBKMBKnowledge1').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array");
				 $('#MKBKMBKnowledge2').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array");
                 $('#form-save').form("load",data);
                 //var sourceone=data.MKBKMBKnowledge1;
                 var sourceone=jsonData.rows[0].MKBKMBKnowledge1
                 //var sourcetwo=data.MKBKMBKnowledge2;
                 var sourcetwo=jsonData.rows[0].MKBKMBKnowledge2
                 //var id=jsonData.rows[0].MKBKMBRowId;
                 $('#registerMain').html("");//清掉扩展列
                 $('#addMainCo').html("");//清掉主列
				 var newmain1="<div class='maindiv' id='Awhole'  style='margin:20px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input type='text' id='forreload1' class='resizeA'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='forload1' class='source1'  style='width:257px;'></td><td class='sourceknow1'>（知识点1）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addMainColumn(this,1)' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
				 $('#addMainCo').append(newmain1);
				 var newmain2="<div class='maindiv' id='Bwhole'  style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列2</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input type='text' id='forreload2' class='resizeA'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='forload2'class='source2'  style='width:257px;'></td><td class='sourceknow2'>（知识点2）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addMainColumn(this,2)' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
				 $('#addMainCo').append(newmain2);
				 $('.resizeA').validatebox({});
			     //展示列1下拉框
				 $('#forload1').combobox({
			        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+sourceone,
			        valueField:'ID',
			        textField:'Desc',
			        onSelect:function(record)
			        {
						var sourcr1flag="N";
						$('#addMainCo').find('.source1,.source2').each(function(){
							var sourcejust=$(this).combobox('getText');
							//alert(sourcejust)
							if(sourcejust=="知识表达式" || sourcejust=="Exp")
							{
								sourcr1flag="Y";
							}
						});
						if(sourcr1flag=="Y")
						{
							$("#MKBKMBFlagF").checkbox('enable');
						}
						else
						{
							$("#MKBKMBFlagF").checkbox('disable');	
						}	        
				    }			              	
			     });

			     //展示列2下拉框
				 $('#forload2').combobox({
			        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+sourcetwo,
			        valueField:'ID',
			        textField:'Desc',
				    onSelect:function(record)
			        {
						var sourcr2flag="N";
						$('#addMainCo').find('.source1,.source2').each(function(){
							var sourcejust=$(this).combobox('getText');
							//alert(sourcejust)
							if(sourcejust=="知识表达式" || sourcejust=="Exp")
							{
								sourcr2flag="Y";
							}
						});
						if(sourcr2flag=="Y")
						{
							$("#MKBKMBFlagF").checkbox('enable');
						}
						else
						{
							$("#MKBKMBFlagF").checkbox('disable');	
						}	        
				    }		        
			     });
                 //$('#forload1').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+sourceone);
                 //$('#forload2').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+sourcetwo);
                 var basedesc1=$('#MKBKMBKnowledge1').combobox('getText');
				 $('.sourceknow1').text("（"+basedesc1+"）");
				 var basedesc2=$('#MKBKMBKnowledge2').combobox('getText');
				 $('.sourceknow2').text("（"+basedesc2+"）");	  
                 listAllColumn(id);
                 //解锁
				 $('#lockForm').unmask();
				 $('#mbedit').menubutton('enable');
		         $('#btnSave').linkbutton('enable');
		         $('#btnRefresh').linkbutton('enable');
			     //$('#btnForbid span span:last').removeClass('icon-lockdata');
			     //$('#btnForbid span span:last').addClass('icon-unlock');
			     var sp = $('#btnForbid span span:last'), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
        		 //sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-lockdata');
        		 if(!add)
        		 {
	        		  $('#btnForbid span span:last').removeClass('icon-unlock');
			     	  $('#btnForbid span span:last').addClass('icon-lockdata'); 
	        	 }	     
			     $('#btnForbid span span:first').text('锁死');		         
                 RefreshSearchData("User.MKBKLMappingBase",id,"A",savedesc);
           });
		}
	}
	//加载所有列选项
	function listAllColumn(id)
	{
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBKLMappingBaseField",
			QueryName:"GetList",
			base:id
		},function(jsonData){
			 //alert(jsonData.rows.length)
			 for(var j = 0,len=jsonData.rows.length; j < len; j++)
			 {
				 var MKBKMBFDesc=jsonData.rows[j].MKBKMBFDesc;
				 var MKBKMBFType=jsonData.rows[j].MKBKMBFType;
				 var MKBKMBFConfig=jsonData.rows[j].MKBKMBFConfig;
				 var MKBKMBFSequence=jsonData.rows[j].MKBKMBFSequence;
				 var MKBKMBFRowId=jsonData.rows[j].MKBKMBFRowId;
				 var MKBKMBFCode=jsonData.rows[j].MKBKMBFCode;
				 var MKBKMBFlag=jsonData.rows[j].MKBKMBFlag;
				 var insideNum=2;
				 var insidecount=1;//记录条数
				 var otherrow=row;
				 if(j==0)
				 {
					 //alert(MKBKMBFConfig)
					 $('#Awhole').find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);	 
					 })
					 $('#Awhole').find('.hiddenCode').each(function(){
						 $(this).text(MKBKMBFCode);
					 })
					 $('#forreload1').val(MKBKMBFDesc);
					 $('#forload1').combobox('setValue',MKBKMBFConfig);
				 }
				 else if(j==1)
				 {
					 $('#Bwhole').find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);	 
					 })
					 $('#Bwhole').find('.hiddenCode').each(function(){
						 $(this).text(MKBKMBFCode);
					 })
					 
					 $('#forreload2').val(MKBKMBFDesc);
					 
					 $('#forload2').combobox('setValue',MKBKMBFConfig);
				 }
				 else if(j>1 && MKBKMBFType=="K1")
				 {
					var newmain="<div class='maindiv' id='Awhole"+mainrow+"'  style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input class='resizeA' type='text' id='A"+mainrow+"'  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='B"+mainrow+"' class='source1'  style='width:257px;'></td><td class='sourceknow1'>（知识点1）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delMainColumn(Awhole"+mainrow+")' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
					$('#addMainCo').append(newmain);
					//将列的标签重新命名
					var num=1;
					$('#overshow').find('p').each(function(){
						$(this).text("列"+num);
						num++;
						})
						var baseid=$('#MKBKMBKnowledge1').combobox('getValue');
						//判断知识点1下拉框有没有值，如果有则将括号展示替换
						var basedesc=$('#MKBKMBKnowledge1').combobox('getText');
						if(basedesc!="")
						{
							$('.sourceknow1').text("（"+basedesc+"）");
						}
					$('#A'+mainrow).validatebox({});
					$('#A'+mainrow).val(MKBKMBFDesc);
					$('#B'+mainrow).combobox({
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+baseid,
				        valueField:'ID',
				        textField:'Desc',
				        onSelect:function(record)
				        {
							var sourcr1flag="N";
							$('#addMainCo').find('.source1,.source2').each(function(){
								var sourcejust=$(this).combobox('getText');
								//alert(sourcejust)
								if(sourcejust=="知识表达式" || sourcejust=="Exp")
								{
									sourcr1flag="Y";
								}
							});
							if(sourcr1flag=="Y")
							{
								$("#MKBKMBFlagF").checkbox('enable');
							}
							else
							{
								$("#MKBKMBFlagF").checkbox('disable');	
							}	        
					    }				        
					});
					$('#B'+mainrow).combobox('setValue',MKBKMBFConfig);
					$('#Awhole'+mainrow).find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						});
					$('#Awhole'+mainrow).find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						});	
					mainrow++;

				 }
				 else if(j>1 && MKBKMBFType=="K2")
				 {
					var newmain="<div class='maindiv' id='Bwhole"+mainrow+"' style='margin:10px 0px 10px 10px;width:98%;background-color:#F4F6F5;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:3px 3px 3px 5px;'>列1</p></div><div  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10'><tr><td align='right'><font color=red>*</font>列名</td><td><input class='resizeA' type='text' id='A"+mainrow+"' name=''  style='width:250px;'></td></tr><tr><td align='right'>列源</td><td><input id='D"+mainrow+"' class='source2'  style='width:257px;'></td><td class='sourceknow2'>（知识点2）</td></tr><tr><td ><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delMainColumn(Bwhole"+mainrow+")' style='border: 0px;cursor:pointer'></td></tr></table></div></div>";
					$('#addMainCo').append(newmain);
					//将列的标签重新命名
					var num=1;
					$('#overshow').find('p').each(function(){
						$(this).text("列"+num);
						num++;
						})
					var baseid=$('#MKBKMBKnowledge2').combobox('getValue');
					//判断知识点1下拉框有没有值，如果有则将括号展示替换
					var basedesc=$('#MKBKMBKnowledge2').combobox('getText');
					if(basedesc!="")
					{
						$('.sourceknow2').text("（"+basedesc+"）");
					}
					$('#D'+mainrow).combobox({
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+baseid,
				        valueField:'ID',
				        textField:'Desc',
				        onSelect:function(record)
				        {
							var sourcr1flag="N";
							$('#addMainCo').find('.source1,.source2').each(function(){
								var sourcejust=$(this).combobox('getText');
								//alert(sourcejust)
								if(sourcejust=="知识表达式" || sourcejust=="Exp")
								{
									sourcr1flag="Y";
								}
							});
							if(sourcr1flag=="Y")
							{
								$("#MKBKMBFlagF").checkbox('enable');
							}
							else
							{
								$("#MKBKMBFlagF").checkbox('disable');	
							}	        
					    }				        
					});
					$('#D'+mainrow).combobox('setValue',MKBKMBFConfig);
					$('#A'+mainrow).validatebox({});
					$('#A'+mainrow).val(MKBKMBFDesc);
					$('#Bwhole'+mainrow).find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#Bwhole'+mainrow).find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})
					mainrow++;
				 }
				 else if(j>1 && MKBKMBFType=="TX")
				 {
					//单行文本
				  	var newDiv="<div class='movediv' id='wholeA"+row+"AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（单行文本）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);	
					moveAll();
					$('.hisbox').validatebox({
					});
					$('#wholeA'+row+"AI").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#wholeA'+row+"AI").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})
					row++;
					sortP(); 
				 }
				 else if(j>1 && MKBKMBFType=="TA")
				 {
					 //多行文本
					var newDiv="<div class='movediv' id='wholeA"+row+"AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（多行文本）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//添加新扩展列跳转
					moveAll();
					$('.hisbox').validatebox({
					});
					$('#wholeA'+row+"AT").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#wholeA'+row+"AT").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})
					row++;
					sortP();
					 
				 }
				 else if(j>1 && MKBKMBFType=="TP")
				 {
					 //引用术语
					var newDiv="<div class='movediv' id='wholeA"+row+"AP' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td  align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（引用术语）</td></tr><tr><td align='right'>术语</td><td><input class='histermbox' style='width:257px;' id='TermNum"+row+"A1' type='text'></tr></table></div></div>";
					$('#registerMain').append(newDiv);

					$('#TermNum'+row+'A1').combobox({
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
						valueField:'ID',
						textField:'Desc',
						mode:'remote'
					});
					$('#TermNum'+row+'A1').combobox('setValue',MKBKMBFConfig)
					$('#positionId'+row).focus();
					moveAll();
					$('.hisbox').validatebox({
					});	
					$('#wholeA'+row+"AP").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#wholeA'+row+"AP").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})					
					row++;
					sortP();				 
				 }
				 else if(j>1 && MKBKMBFType=="R")
				 {
					 //danxuan
					var newDiv="<div class='movediv' id='wholeA"+row+"AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（单选框）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//插入单条按钮
					var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
					$('#divID'+row).append(newbutton);
					//插入多条按钮
					var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
					$('#toolstr'+row).append(muchbutton);
					//输入框变为hisui样式
						$('.hisbox').validatebox({
					});	
			    	moveAll();
					var newArray=MKBKMBFConfig.split("&%");
					for(var i=0;i<newArray.length;i++)
					{
						var condesc=newArray[i]
						//alert(newArray[i])
						var addRow="<tr class='hovertr'  id='option"+otherrow+"A"+insideNum+"'><td align='right'><input name='radio"+otherrow+"' class='allRadio' type='radio' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text' value='"+condesc+"'></td><td class='childhover'></td></tr>";
						$('#table'+otherrow).append(addRow);
						hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						//将单选框渲染成hisui样式
				    	$HUI.radio('.allRadio',{
						});
						insideNum++;
						insidecount++;
					}
					addRadSelect(row,otherrow,insideNum,insidecount);
					$('#wholeA'+row+"AR").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						});
					$('#wholeA'+row+"AR").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						});
					row++;
					sortP();
				 }
				 else if(j>1 && MKBKMBFType=="CB")
				 {
					//duoxuan
					var newDiv="<div class='movediv'  id='wholeA"+row+"AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（复选框）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					$('.hisbox').validatebox({
					});	
					//插入单条按钮
					var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td class='addhover' style='display:none'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
					$('#divID'+row).append(newbutton);
					//插入多条按钮
					var muchbutton="<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
					$('#toolstr'+row).append(muchbutton);	

			    	moveAll();
					var newArray=MKBKMBFConfig.split("&%");
					for(var i=0;i<newArray.length;i++)
					{
						var condesc=newArray[i];
						//alert(newArray[i])
						var addRow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'><input name='checkbox"+otherrow+"' class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"'  value='"+condesc+"' type='text'></td> <td class='childhover'></td></tr>";
						$('#table'+otherrow).append(addRow);
						hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						//将duo选框渲染成hisui样式
					    $HUI.checkbox('.allCheck',{
						});
						insideNum++;
						insidecount++;
					}
					addCheckSelected(row,otherrow,insideNum,insidecount);
					$('#wholeA'+row+"AH").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#wholeA'+row+"AH").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})
					row++
					sortP()
				 }
				 else if(j>1 && MKBKMBFType=="C")
				 {
					 //xiala
					var newDiv="<div class='movediv' id='wholeA"+row+"AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>列"+row+"</p></div><div class='classChild' id='divID"+row+"'  align='center' style='float:left;padding:10px 10px 10px 1px;;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table"+row+"'><tr id='option"+row+"A1'><td align='right'><font color=red>*</font>列名</td><td><input class='hisbox for-just' id='positionId"+row+"' style='width:250px;' type='text' value='"+MKBKMBFDesc+"'></td><td>（下拉框）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//输入框变为hisui样式
					$('.hisbox').validatebox({
						});
					//插入单条按钮
					var newbutton="<table align='left' style='padding-left:10px'><tr id='toolstr"+row+"'><td style='display:none' class='addhover'><img id='addbutton"+row+"' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
					$('#divID'+row).append(newbutton);
					//插入多条按钮
					var muchbutton="<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch"+row+"' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
					$('#toolstr'+row).append(muchbutton);	
			    	moveAll();
			    	var newArray=MKBKMBFConfig.split("&%");
					for(var i=0;i<newArray.length;i++)
					{
						var condesc=newArray[i];
						//alert(newArray[i])
				    	var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'>选项"+(insideNum-1)+"</td><td><input class='hisbox' value='"+condesc+"' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text'></td><td class='childhover'></td></tr>";
				    	$('#table'+otherrow).append(appendrow);
				    	hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						insideNum++;
						insidecount++;
					}
					insidenumbe=(insideNum-1);
					addComSelect(row,otherrow,insidenumbe,insidecount);
			    	$('#wholeA'+row+"AC").find('.hiddenRowid').each(function(){
						$(this).text(MKBKMBFRowId);
						})
					$('#wholeA'+row+"AC").find('.hiddenCode').each(function(){
						$(this).text(MKBKMBFCode);
						})
					row++;
					sortP();

				 }
			 } 
		 	 //遮罩
	 		 var lockFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","MappingReadLock",id);
		     if(lockFlag=="Y")
		     {
			     $('#btnForbid span span:last').removeClass('icon-lockdata');
			     $('#btnForbid span span:last').addClass('icon-unlock');
			     $('#btnForbid span span:first').text('解锁');
			     $('#lockForm').mask('').click(function(){
		            	  /*$.messager.show({ 
			              	title: '提示消息', 
			              	msg: '该条数据已经锁死，不允许进行任何操作！！', 
			             	showType: 'show', 
			             	timeout: 700, 
			              	style: { 
			                right: '', 
			                bottom: ''
			              	} 
			            }); */
			             $.messager.popover({msg: '该条数据已经锁死，不允许进行任何操作！',type:'alert'});
				 })
		         //setTimeout(lockMethod(),100)
		         //遮罩主列
		         $('#addMainCo').find('.maindiv').each(function(){
		         	$(this).mask('').click(function(){
		            	  /*$.messager.show({ 
			              	title: '提示消息', 
			              	msg: '该条数据已经锁死，不允许进行任何操作！！', 
			             	showType: 'show', 
			             	timeout: 700, 
			              	style: { 
			                right: '', 
			                bottom: ''
			              	} 
			            });*/
			            $.messager.popover({msg: '该条数据已经锁死，不允许进行任何操作！',type:'alert'}); 	
		            })    
		         })
		         //遮罩扩展列
		         $('#registerMain').find('.movediv').each(function(){
		         	$(this).mask('').click(function(){
			            $.messager.popover({msg: '该条数据已经锁死，不允许进行任何操作！',type:'alert'}); 	
		            })    
		         })
		         //禁用工具栏按钮
		         $('#mbedit').menubutton('disable')	
		         $('#btnSave').linkbutton('disable')	
		         $('#btnRefresh').linkbutton('disable')			             
		     }
		    //判断是否在映射管理表维护了数据
		    var hasDataFlag=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","hasDetail",id);
		    if(hasDataFlag=="Y")
		    {
    			$('.centerlayout .combobox-f').combobox('readonly',true);
    			//$('input').css({'background-color':'#D0D0D0'});
    			$('#layoutcenter').find('.combo').each(function(){
	    			$(this).find('input').each(function(){
						$(this).css({'background-color':'#E0E0E0'});	
		    		})
				}); 
				//解开标识
				$('#disable_id').find('.combo').each(function(){
	    			$(this).find('input').each(function(){
						$(this).css({'background-color':'#FFFFFF'});		
		    		})
				})
				$('#disable_id .combobox-f').combobox('readonly',false);

    			$('body').find('.hovertr').each(function(){
	    			$(this).find('.hisbox').each(function(){
		    			$(this).attr('readonly',true);
		    			//alert($(this).attr('readonly'))
		    			//$(this).css("background","#F4F6F5")
		    			$(this).css("background","#E0E0E0")
		    		});
	    		}); 			    
			}
			else
			{
    			$('.combobox-f').combobox('readonly',false);
    			$('#layoutcenter').find('.combo').each(function(){
	    			$(this).find('input').each(function(){
		    			$(this).css({'background-color':'#FFFFFF'});
		    			})
	    			});     			 
			}
			//判断列源是否有诊断表达式选项来禁用和启用多选框
			var sourcrtextFlag="N";
			$('#addMainCo').find('.source1,.source2').each(function(){
				var sourcejust=$(this).combobox('getText');
				//alert(sourcejust)
				if(sourcejust=="知识表达式" || sourcejust=="Exp")
				{
					sourcrtextFlag="Y";
				}
			});
			if(sourcrtextFlag=="Y")
			{
				$("#MKBKMBFlagF").checkbox('enable');
			}
			else
			{
				$("#MKBKMBFlagF").checkbox('disable');	
			}
			var flagrecord = mygrid.getSelected();
			var menuflag=flagrecord.MKBKMBFlag;
			//alert(menuflag=="")
			if(menuflag=="Y")
			{
				$HUI.checkbox("#MKBKMBFlagF").setValue(true);
			}
			else if(menuflag=="N")
			{
				$HUI.checkbox("#MKBKMBFlagF").setValue(false);
			}				
			var numF=1;
			$('#overshow').find('p').each(function(){
				$(this).text("列"+numF);
				numF++;
			});	 
		});
	}
	function addCheckSelected(row,otherrow,insideNum,insidecount)
	{
		//点击添加小按钮
    	$('#addbutton'+row).click(function(e){
    		//addcheck(insideNum,otherrow);
    		//var optionrow=insideNum+1;
	    	var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'><input name='checkbox"+otherrow+"' class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"'  placeholder='选项"+insideNum+"' type='text'></td> <td class='childhover'></td></tr>"
	    	$('#table'+otherrow).append(appendrow);
	    	$('.hisbox').validatebox({
			});	
	    	hoverTr();
	    	//输入框变为hisui样式
			$('.hisbox').validatebox({
			});
	    	//将duo选框渲染成hisui样式
	    	$HUI.checkbox('.allCheck',{
			});
    		insideNum++;
	    	insidecount++;
		})
		//点击添加多行按钮
    	$('#addmuch'+row).click(function(e){
    		$("#myWin").show();
    		var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-addlittle',
				resizable:true,
				title:'添加多条',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						//alert(($('#buttons').val()).split("\n")[1])
						var len=($('#buttons').val()).split("\n").length
						for(i=0;i<len;i++)
						{

							var str=($('#buttons').val()).split("\n")[i];
							if(str!="")
							{
								var optionrow=insideNum+1;	
								var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+optionrow+"'><td  align='right'><input name='checkbox"+otherrow+"' class='allCheck' type='checkbox' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"'  value='"+str+"' type='text'></td><td class='childhover'></td></tr>"
								$('#table'+otherrow).append(appendrow);
								hoverTr()
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
								//将duo选框渲染成hisui样式
						    	$HUI.checkbox('.allCheck',{
								});
								insideNum++;
    							insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});
    	})	
	}
	function addRadSelect(row,otherrow,insideNum,insidecount)
	{
		 //点击添加小按钮
    	$('#addbutton'+row).click(function(e){
    		//addcheck(insideNum,otherrow);
    		//var optionrow=insideNum+1;
	    	var appendrow="<tr class='hovertr'  id='option"+otherrow+"A"+insideNum+"'><td align='right'><input name='radio"+otherrow+"' class='allRadio' type='radio' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text' placeholder='选项"+insideNum+"'></td><td class='childhover'></td></tr>"
	    	$('#table'+otherrow).append(appendrow);
	    	$('#comboNum'+otherrow+'A'+insideNum).focus();//将光标默认到该行
	    	hoverTr()
	    	//输入框变为hisui样式
			$('.hisbox').validatebox({
			});
	    	//将单选框渲染成hisui样式
	    	$HUI.radio('.allRadio',{
			});
	    	insideNum++;
	    	insidecount++;
	    })
		//点击添加多行按钮
    	$('#addmuch'+row).click(function(e){
    		$("#myWin").show();
    		var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-addlittle',
				resizable:true,
				title:'添加多条',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						//alert(($('#buttons').val()).split("\n")[1])
						var len=($('#buttons').val()).split("\n").length
						for(i=0;i<len;i++)
						{
							
							var str=($('#buttons').val()).split("\n")[i];
							if(str!="")
							{
								var optionrow=insideNum+1;	
								var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+optionrow+"'><td  align='right'><input name='radio"+otherrow+"' class='allRadio' type='radio' value=''></td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text' value='"+str+"'></td><td class='childhover'></td></tr>"
								$('#table'+otherrow).append(appendrow);
								hoverTr()
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
								//将单选框渲染成hisui样式
						    	$HUI.radio('.allRadio',{
								});
								insideNum++;
    							insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});
    	})
	}
	function addComSelect(row,otherrow,insideNum,insidecount)
	{
		//点击添加小按钮
    	$('#addbutton'+row).click(function(e){
    		//var optionrow=insideNum+1;
	    	var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+insideNum+"'><td  align='right'>选项"+insideNum+"</td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' type='text'></td><td class='childhover'></td></tr>"
	    	$('#table'+otherrow).append(appendrow);
	    	$('#comboNum'+otherrow+'A'+insideNum).focus();//将光标默认到该行
	    	hoverTr()
			//输入框变为hisui样式
			$('.hisbox').validatebox({
			});
    		insideNum++;
    		insidecount++;
    	})
		//点击添加多行按钮
    	$('#addmuch'+row).click(function(e){
    		$("#myWin").show();
    		var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-addlittle',
				resizable:true,
				title:'添加多条',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						var len=($('#buttons').val()).split("\n").length
						for(i=0;i<len;i++)
						{

							var str=($('#buttons').val()).split("\n")[i];
							if(str!="")
							{
								var optionrow=insideNum+1;
								var appendrow="<tr class='hovertr' id='option"+otherrow+"A"+optionrow+"'><td  align='right'>选项"+insideNum+"</td><td><input class='hisbox' style='width:250px;' id='comboNum"+otherrow+"A"+insideNum+"' value='"+str+"' type='text'></td><td class='childhover'></td></tr>"
								$('#table'+otherrow).append(appendrow);
								hoverTr()
								//输入框变为hisui样式
								$('.hisbox').validatebox({
								});
								insideNum++;
    							insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});
    	})

	}
	function sortP()
	{
	    //将列的标签重新命名
		var num=1;
		$('#registerMain').find('p').each(function(){
			$(this).text("列"+num)
		num++;
		})
	}
	//查询按钮
	/*$("#TextDesc").searchbox({
        searcher:function(value,name){
            SearchMapBase();
        }
    })*/
    $('#TextDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBKLMappingBase",
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
			SearchMapBase()
			
		}
	});
	$('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
		if(e.keyCode==13){ 
			SearchMapBase() 
		}
	}); 
	$("#btnSearch").click(function (e) { 
		SearchMapBase();
	})
    //查询方法
    function SearchMapBase(){
        var desc=$('#TextDesc').combobox('getText');
        $('#mappingbasegrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBKLMappingBase",
            QueryName:"GetList",
            'desc': desc
        });

    }
/**************************************************左侧列表显示结束**************************************************************/
	//锁死
	$('#btnForbid').click(function(e){
			//lockMethod();
		//var sp = $('span:last', this), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
        //sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-unlock');
		var locktext=$('#btnForbid span span:first').text();
		if(locktext=="锁死")
		{
			//$('#btnForbid span span:first').text('解锁');
			lockMethod();			
		}
		else
		{
			//$('#btnForbid span span:first').text('锁死');
			$("#lockWin").show();
			var lockWin = $HUI.dialog("#lockWin",{
				iconCls:'icon-unlock',
				resizable:true,
				title:'解锁',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'确定',
					id:'save_lock',
					handler:function(){
						justPassword();
						
					}
				},
				{
					text:'取消',
					handler:function(){
						$('#lockpassword').val('')
						lockWin.close();
					}
				}]				
			});
				
		}
		$('#lockpassword').focus();
	});
	//给密码框绑定回车事件
	$("#lockpassword").keypress(function(event){
	    if(event.which === 13) { 
	        //点击回车要执行的事件
	        justPassword();
	     }
	})
	//解锁方法
	function justPassword()
	{
		var password=$('#lockpassword').val();
		var record = mygrid.getSelected();
		if(record)
		{	
			//var pass=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","findPassWord");	
			if(password=="admin")
			{
				var id=record.MKBKMBRowId;
				tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","unLockMethod",id);
				$('#lockpassword').val('')
				$('#lockWin').dialog('close');
				viewAllData();
			}
			else
			{
				$.messager.alert('错误提示','输入正确的密码!',"error");
				return;	
			}
		}
	}
	//锁死方法
	function lockMethod()
	{
		var record = mygrid.getSelected();
		if(record)
		{
			var id=record.MKBKMBRowId;
			tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","MappingLock",id);
            /*$.messager.show({ 
              title: '提示消息', 
              msg: '操作成功！', 
              showType: 'show', 
              timeout: 700, 
              style: { 
                right: '', 
                bottom: ''
              } 
            });*/
            $.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});
            viewAllData();
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
	}
	/**
	*
	*锁死的遮罩层，引用网上封装的方法
	**/
	$.extend($.fn,{
      mask: function(msg,maskDivClass){
        this.unmask();
        // 参数
        var op = {
          opacity: 0.8,
          z: 10000,
          bgcolor: '#ffffff'
        };
        var original=$(document.body);
        var position={top:0,left:0};
              if(this[0] && this[0]!==window.document){
                original=this;
                position=original.position();
              }
        // 创建一个 Mask 层，追加到对象中
        var maskDiv=$('<div class="maskdivgen"> </div>');
        maskDiv.appendTo(original);
        var maskWidth=original.outerWidth();
        if(!maskWidth){
          maskWidth=original.width();
        }
        var maskHeight=original.outerHeight();
        if(!maskHeight){
          maskHeight=original.height();
        }
        maskDiv.css({
          position: 'absolute',
          top: position.top,
          left: position.left,
          'z-index': op.z,
          width: maskWidth,
          height:maskHeight,
          'background-color': '',
          opacity: 0
        });
        if(maskDivClass){
          maskDiv.addClass(maskDivClass);
        }
        if(msg){
          var msgDiv=$('<div style="position:absolute;border:#6593cf 1px solid; padding:2px;background:#ccca"><div style="line-height:24px;border:#a3bad9 1px solid;background:white;padding:2px 10px 2px 10px">'+msg+'</div></div>');
          msgDiv.appendTo(maskDiv);
          var widthspace=(maskDiv.width()-msgDiv.width());
          var heightspace=(maskDiv.height()-msgDiv.height());
          msgDiv.css({
                cursor:'wait',
                top:(heightspace/2-2),
                left:(widthspace/2-2)
           });
         }
         maskDiv.fadeIn('fast', function(){
          // 淡入淡出效果
          $(this).fadeTo('slow', op.opacity);
        })
        return maskDiv;
      },
     unmask: function(){
           var original=$(document.body);
             if(this[0] && this[0]!==window.document){
              original=$(this[0]);
           }
           original.find("> div.maskdivgen").fadeOut('slow',0,function(){
             $(this).remove();
           });
      }
    });
    ///disable和enable覆盖重写
	/**
	 * linkbutton方法扩展
	 * @param {Object} jq

	$.extend($.fn.linkbutton.methods, {
	    enable: function(jq){
	        return jq.each(function(){
	            var state = $.data(this, 'linkbutton');
	            if ($(this).hasClass('l-btn-disabled')) {
	                var itemData = state._eventsStore;
	                //恢复超链接
	                if (itemData.href) {
	                    $(this).attr("href", itemData.href);
	                }
	                //回复点击事件
	                if (itemData.onclicks) {
	                    for (var j = 0; j < itemData.onclicks.length; j++) {
	                        $(this).bind('click', itemData.onclicks[j]);
	                    }
	                }
	                //设置target为null，清空存储的事件处理程序
	                itemData.target = null;
	                itemData.onclicks = [];
	                $(this).removeClass('l-btn-disabled');
	            }
	        });
	    },
	    /**
	     * 禁用选项（覆盖重写）
	     * @param {Object} jq
	    disable: function(jq){
	        return jq.each(function(){
	            var state = $.data(this, 'linkbutton');
	            if (!state._eventsStore)
	                state._eventsStore = {};
	            if (!$(this).hasClass('l-btn-disabled')) {
	                var eventsStore = {};
	                eventsStore.target = this;
	                eventsStore.onclicks = [];
	                //处理超链接
	                var strHref = $(this).attr("href");
	                if (strHref) {
	                    eventsStore.href = strHref;
	                    $(this).attr("href", "javascript:void(0)");
	                }
	                //处理直接耦合绑定到onclick属性上的事件
	                var onclickStr = $(this).attr("onclick");
	                if (onclickStr && onclickStr != "") {
	                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
	                    $(this).attr("onclick", "");
	                }
	                //处理使用jquery绑定的事件
	                var eventDatas = $(this).data("events") || $._data(this, 'events');
	                if (eventDatas["click"]) {
	                    var eventData = eventDatas["click"];
	                    for (var i = 0; i < eventData.length; i++) {
	                        if (eventData[i].namespace != "menu") {
	                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
	                            $(this).unbind('click', eventData[i]["handler"]);
	                            i--;
	                        }
	                    }
	                }
	                state._eventsStore = eventsStore;
	                $(this).addClass('l-btn-disabled');
	            }
	        });
	    }
	});*/
}
$(init);
