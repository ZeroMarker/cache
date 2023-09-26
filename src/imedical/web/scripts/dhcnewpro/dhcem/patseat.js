///Creator:huaxiaoying
///CreateDate:2016/07/14
var TypeDesc="",TypeDr=""; //类型 person=0;2016-12-14
var tab=null;//drop时td的ID
var isShowWindow=0;
//var ifHaveTable=0;//生成表格 按钮是否有效(是否已经维护过座位)
var Id="" //单击座位的ID
var TDId=""//单击单元格的ID
var LocDr=LgCtLocID;//默认科室id
var seatWidth="",seatHight="",patBodyH=""
$(function(){ 
	hospComp = GenHospComp("DHC_EmPatSeat");  //hxy 2020-05-24 st
	var HospDr=hospComp.getValue();
	hospComp.options().onSelect = function(){///选中事件
		var HospDr=hospComp.getValue();
		$("#ACPart").combobox( { 
			url:LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListLoc&HospDr="+HospDr
		})
		$('#PSCType').combobox({
			url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListType&HospDr="+HospDr
		})
	}//ed
	//科室下拉选择
	$('#ACPart').combobox({
		valueField:'id', 
        textField:'text',
        mode: 'remote',  // 2017-01-06
		url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListLoc&HospDr="+HospDr, //hxy 2020-05-24 &HospDr="+HospDr
		onSelect: function () {
				//获取选中的值
				var varSelect = $(this).combobox('getValue');
				LocDr=varSelect;
				$('#bed').html("");
				loadTable();//
				TDId=""; //2017-02-13								
		},
		onLoadSuccess:function (data) {
			TDId=""; //2017-02-13
			if($('#ACPart').combobox("getValue")==""){
				hideBtn();
			}
			//$('#ACPart').combobox('select', data[0].id);//默认科室 // 2017-01-06
		}	
			
	});
	
	///$('#ACPart').combobox('select', LgCtLocID);//默认科室 // 2017-01-06 注释放开
	//座位类型下拉选择 2016-12-14
	$('#PSCType').combobox({
		valueField:'id',    
        textField:'text',  
		url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListType&HospDr="+HospDr, //hxy 2020-05-24 &HospDr="+HospDr
		onSelect: function () {
				//获取选中的值
				TypeDr = $(this).combobox('getValue');
				TypeDesc = $(this).combobox('getText');									
		},
		onLoadSuccess:function () {
		}	
			
	});
   
   
	$("#bed").on("click",".dragitem",function(){
		isShowWindow=0//不弹出窗体
	    Id=$(this).parent().attr("id")
	    this.style.backgroundColor = "#06EBED";
	    $("#bed .dragitem").each(function(){
				if($(this).parent().attr("id")!=Id){
					this.style.backgroundColor = "#77AAFF";
				}
		})			
					
	})
	//单元格的id获取 用于加上下左右操作
	$("#bed").on('click',".drop",function(){
		if($(this).find(".bednum").text()==""){
			Id="";                        //QQA 2017-1-11       
		}
		TDId=$(this).attr("id");
		this.style.backgroundColor = "#9AF5FE"; 	
		$("#bed .drop").each(function(){
				if($(this).attr("id")!=TDId){
					this.style.backgroundColor = "#FFF";
				}
				})
				
		$("#bed .dragitem").each(function(){
				if($(this).parent().attr("id")!=TDId){
					this.style.backgroundColor = "#77AAFF";
				}
				})		
		
	})
	
});

///删除该整行 2017-02-13
function cancelrow(){
	if(TDId==""){
		$.messager.alert("提示","请单击选择~"); 
		return;
		}
	$.messager.confirm('确认','您确认删除该整行吗？',function(r){    
		    if (r){
			        runClassMethod("web.DHCEMPatSeat","DeletePatSeatRow",
		        			{'Code':TDId,
		        			 'LocDr':LocDr},
							function(data){								
								if(data==0)
								{ //location.reload()
						 			$('#bed').html("");
									loadTable();//
									TDId=""; //2017-02-13 
								}else if(data==2){									
									$.messager.confirm('确认','该行已经有座位，您确认继续删除该整行吗？',function(r){ 
										if (r){
											runClassMethod("web.DHCEMPatSeat","DeletePatSeatRowYes",
								        			{'Code':TDId,
								        			 'LocDr':LocDr},
													function(data){
														if(data==0){
															$('#bed').html("");
															loadTable();
															TDId="";
														}else{
															$.messager.alert("提示","删除失败");
														}
														
													});
											}
									});
					 			}else{
						 			var mydata=data.split("^");
						 			$.messager.alert("提示","该行"+mydata[0]+"号座位已安排患者，不能删除！");
						 		}	
					        })
	
			      }
		    
		 });
		 
}
///删除该整列 2017-02-13
function cancelcol(){
	if(TDId==""){
		$.messager.alert("提示","请单击选择~"); 
		return;
		}
	$.messager.confirm('确认','您确认删除该整列吗？',function(r){    
		    if (r){
			        runClassMethod("web.DHCEMPatSeat","DeletePatSeatCol",
		        			{'Code':TDId,
		        			 'LocDr':LocDr},
							function(data){							
								if(data==0)
								{ //location.reload()
						 			$('#bed').html("");
									loadTable();//
									TDId=""; //2017-02-13 
								}else if(data==2){									
									$.messager.confirm('确认','该列已经有座位，您确认继续删除该整列吗？',function(r){ 
										if (r){
											runClassMethod("web.DHCEMPatSeat","DeletePatSeatColYes",
								        			{'Code':TDId,
								        			 'LocDr':LocDr},
													function(data){
														if(data==0){
															$('#bed').html("");
															loadTable();
															TDId="";
														}else{
															$.messager.alert("提示","删除失败");
														}
														
													});
											}
									});
					 			}else{
						 			var mydata=data.split("^");
						 			$.messager.alert("提示","该列"+mydata[0]+"号座位已安排患者，不能删除！");
						 		}	
					        })
	
			      }
		    
		 });
	
}

///添加上下行
function addrow(type){
	if(TDId==""){
		$.messager.alert("提示","请单击选择~");
	}else{
		if(type==1){
		$.messager.confirm('确认','您确认该行上方添加一行吗？',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","AddRowtop",
					        {'LocDr':LocDr,
					         'Code':TDId,
					         'type':type},
							function(data){
								if(data==0)
								{   //location.reload();
									$('#bed').html("");
									loadTable();//刷新
									TDId=""; //2017-02-13
					 			}else{
						 			$.messager.alert("提示","插入失败");
						 		}	
						
							})
		    }	
		    });//end
		}else{
			$.messager.confirm('确认','您确认该行下方添加一行吗？',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","AddRowtop",
					        {'LocDr':LocDr,
					         'Code':TDId,
					         'type':type},
							function(data){
								if(data==0)
								{   //location.reload();
									$('#bed').html("");
									loadTable();//刷新
									TDId=""; //2017-02-13
					 			}else{
						 			$.messager.alert("提示","插入失败");
						 		}	
						
							})
		    }	
		    });//end
			}
		
	}
}


///添加左右列
function addcol(type){
	if(TDId==""){
		$.messager.alert("提示","请单击选择~");
	}else{
		if(type==1){
			$.messager.confirm('确认','您确认该列左侧添加一列吗？',function(r){    
			    if (r){
					runClassMethod("web.DHCEMPatSeat","AddColleft",
						        {'LocDr':LocDr,
						         'Code':TDId,
						         'type':type},
								function(data){
									if(data==0)
										{   //location.reload();
											$('#bed').html("");
											loadTable();//刷新
											TDId=""; //2017-02-13
										}else if(data==2){
											$.messager.alert("提示","已达到最大列数6,不可再插入");
							 			}else{
								 			$.messager.alert("提示","插入失败");
								 		}	
						
								})
																
		 }	
		 });//end
		}else{
				$.messager.confirm('确认','您确认该列右侧添加一列吗？',function(r){    
			    if (r){
					runClassMethod("web.DHCEMPatSeat","AddColleft",
						        {'LocDr':LocDr,
						         'Code':TDId,
						         'type':type},
								function(data){
									if(data==0)
										{   //location.reload();
											$('#bed').html("");
											loadTable();//刷新
											TDId=""; //2017-02-13
										}else if(data==2){
											$.messager.alert("提示","已达到最大列数6,不可再插入");
							 			}else{
								 			$.messager.alert("提示","插入失败");
								 		}	
						
								})
																
		 }	
		 });//end
			}
		 					
		
	}
}
	

///删除单个座位
function cancelone(){
	
	if(Id==""){
		$.messager.alert("提示","请选择座位~"); 
		return;
	}
	var bedName = $("#"+Id+"").find(".bednum").html();
	$.messager.confirm('确认','您确认将'+bedName+'床删除吗？',function(r){    
		    if (r){
			        runClassMethod("web.DHCEMPatSeat","DeletePatSeatItm",
		        			{'Code':Id,
		        			 'LocDr':LocDr},
							function(data){
								if(data==0)
								{//document.execCommand('Refresh') 
						 			//location.reload()
						 			Id="";   //QQA 
						 			$('#bed').html("");
									loadTable();//
								}else if(data==2){
									$.messager.alert("提示","该座位有人,不能删除！"); 
					 			}else{}	
					        })
	
			      }
		    
		 });
	}

///清空所有
function cancel()
	{   $('#detail').dialog('close');
	    isShowWindow=0//不弹出窗体
		$.messager.confirm('确认','您确认将清空所有吗？您将需要重新维护所有座位，请慎重！',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","DeletePatSeat",
			        {'LocDr':LocDr},
					function(data){
						if(data==0)
						{
							location.reload();
						}else if(data==2){
							$.messager.alert("提示","某座位有人,请待无人时重建！"); 
			 			}else{}	
						
					})
		    }
		    //location.reload()
		});		
	}

//加载表格
function loadTable()
	{   
		runClassMethod("web.DHCEMPatSeat","ListPatSeat",
		        {'LocDr':LocDr},
				function(data){
					if(data=="-*") 
					{
						ifHaveTable=0;
						buttonIfUse(1); //2016-12-08	
						$("#hiddenImg").show(); //hxy 2018-10-29
                        $("#line").hide();//hxy 2018-10-29
                        $("#hiddenBtn").hide();//hxy 2018-10-29
					}else
					{   						
						$("#hiddenImg").hide(); //hxy 2018-10-29
						$("#line").show();//hxy 2018-10-29
						$("#hiddenBtn").show();//hxy 2018-10-29
						var dataStr=data;
						var strArray=dataStr.split("-");
						var strArrayRC=strArray[0];
						var strArrayWH=strArray[1];
						var strArray2=strArrayRC.split("*");
						var strArray3=strArrayWH.split("*");
						seatWidth=strArray3[0];
						seatHight=strArray3[1];
						patBodyH=seatHight-29;//23 hxy 2018-10-18 
						loadView(strArray2[0],strArray2[1]);
						loadTd();
						buttonIfUse(0); //2016-12-08
					 }	
				})

	}
	
//加载单元格数据
function loadTd()
{   
    isShowWindow=1;
    
    runClassMethod("web.DHCEMPatSeat","ListPatSeatItm",
		        {'LocDr':LocDr},
				function(data){
					var classStr2=data;
					var strArray=classStr2.split("*");
					for (var i=0;i<=strArray.length;i++)
					{
						var bedStr=strArray[i];
						if(bedStr==undefined){
							return;
						}
						var bedArray=bedStr.split("^");
						var html="";
						html+='<div class="dragitem" style="width:'+seatWidth+'px;max-height:'+seatHight+'px;" id="hidden">'; //若维护界面使用设置宽高，使用style
						html+='<div class="person" id="patientSex'+i+'">'+bedArray[2]+'</div>';
						html+='<div class="bednum" id="patientNum'+i+'"><span style="padding-left:4px">'+bedArray[1]+'</span></div>'; /*2018-10-18 左间距4px*/
						html+='<div class="patBody" style="height:'+patBodyH+'px;" id="patientBody'+i+'"></div>'; //若维护界面使用设置宽高，使用style
						html+='</div>';
		
						var bedXYArray=bedArray[0].split("-");
						var X=bedXYArray[0]-1;
						var Y=bedXYArray[1]-1;
						$('#bed tr').eq(X).find('td').eq(Y).empty().append(html);
					}	
	})
				
	
}
//初始化视图
function  loadView(m,n)
{
	for (var i=1;i<=m;i++)
		{
	
			var html=""
			html+='<tr>';
			for (var j=1;j<=n;j++){
				html+='<td class="drop" ondblclick="planSetSeat(this)" id="'+i+'-'+j+'"></td>';
			    }
	        html+='</tr>';
			$("#bed").append(html);
			droppable()

		}
}


//生成表格 按钮事件
function creatTable()
	   {
		    //if(ifHaveTable==1){
		 	//	$.messager.alert("提示","表格现在已有喔~");  
			//}else
			//{
		   		var m=$("#m").val();
		   		var n=$("#n").val();
		   		if(m==""||n==""){
		   	   		$.messager.alert("提示","请录入 行 和 列！"); 
		   	   		return;
			   	}//else if(n>6){
				   	//$.messager.alert("提示","请录入1至6"); 
				   	//return;
				//}   //2016-10-19
			   	str=m+"*"+n+"^"+LocDr+"^"
			   	runClassMethod("web.DHCEMPatSeat","SavePatSeat",
		        	{'str':str},
					function(data){
						if(data==1){
							$.messager.alert("提示","表格现在已有喔~"); 
						}else if(data==0){	
						    //$.messager.alert("提示","生成表格成功！");	
						    loadView(m,n);
						    //ifHaveTable=1;
						    $('#bed').html("");
				            loadTable();//刷新table	    
						    $("#m").val('');
			                $("#n").val('');
					    }else{
						    $.messager.alert("提示","本次表格成功失败！");
						}
				})
				//loadView(m,n);
			    //ifHaveTable=1;
			    //$('#bed').html("");
				//loadTable();//刷新table
			    //location.reload()
			}
			$('#detail').dialog('close');
			
	   //}

function droppable()
{
	$('.top .item').draggable({
				revert:true,
				proxy:'clone'
			});
			
	$('.right td.drop').droppable({
		onDragEnter:function(){
			$(this).addClass('over');
		},
		onDragLeave:function(){
			$(this).removeClass('over');
		},
		onDrop:function(e,source){
			
			planSetSeat($(this));
			
			$(source).clone().addClass('assigned');
		}
	});
	
			$('.top').droppable({
				accept:'.assigned',
				onDragEnter:function(e,source){
					$(source).addClass('trash');
				},
				onDragLeave:function(e,source){
					$(source).removeClass('trash');
				},
				onDrop:function(e,source){
					$(source).remove();
				}
			});
	
}	
 
//提交保存
function submit()
{   
	//var personDesc="成人"; //2016-12-14
	//if (person==1){personDesc="儿童";} //2016-12-14
	if($("#bedname").val()==""){
		 $.messager.alert("提示","请填写名称！"); 
	}else
	{
	var bednum=$("#bedname").val()
	//$(".bednum").html($("#bedname").val());
	
    var m=$("#m").val();
	var n=$("#n").val();
	SENum=m+"*"+n
	
	var str=""
	str=str+SENum+"^";
    str=str+"Y"+"^";w
	str=str+tab+"^";
	str=str+$("#bedname").val()+"^";
	str=str+TypeDr+"^";
	str=str+LocDr;

    $("#bedname").val('');//使下次打开窗体时值为空
	runClassMethod("web.DHCEMPatSeat","SavePatSeatItm",
					{'str':str},
					function(data){ 
						if(data==0){
		       				var html="";
							html+='<div class="dragitem" style="width:'+seatWidth+'px;max-height:'+seatHight+'px;" id="hidden">';
							html+='<div class="person" >'+TypeDesc+'</div>';
							html+='<div class="bednum" >'+bednum+'</div>';
							html+='<div class="patBody" style="height:'+patBodyH+'px;"></div>';
							//html+='<div>';
							//html+='<input type="button" class="ArrangeBtn" value="安排" />';
							//html+='<input type="button" class="Transfuse" value="输液" />';
							//html+='</div>';
							html+='</div>';
							$("#"+tab).empty().append(html);
							$('#detail').dialog('close');	  
						}else if(data==1){
							$.messager.alert("提示","该名称已存在,不可重复!"); 
							//$('#detail').dialog('close');
						}else if(data=="-3"){
							$.messager.alert("提示","请选择座位类型!"); 
						}else{	
							$('#detail').dialog('close');
							$.messager.alert('提示','保存失败:'+data)
						} 
					 });
	

	}
} 

///保存 座位图使用界面的 座位设置宽高 2016-10-19
function save(){
	var w=$("#w").val();
	var h=$("#h").val();
	if(w==""||h==""){
   		$.messager.alert("提示","请录入 宽 和 高！"); 
   		return;
   	}
   	str=w+"*"+h+"^"+LocDr+"^"
   	runClassMethod("web.DHCEMPatSeat","SavePatSeatStyle",
    	{'str':str},
		function(data){
			if(data==0){
			$.messager.alert("提示","保存成功！");
			$("#bed").html("")//2016-12-14
			loadTable();
			$("#w").val('');
			$("#h").val('');
			}
	})
}
///生成表格按钮是否可用 2016-12-08
function buttonIfUse(num){
    if (num=="1") {
	    //alert("OK")
		//$('a:contains("生成表格")').linkbutton('enable');
		$('.creat-btn').show();				//生成表格
		$('#m-n').show();					//行和列
		$('.clear-btn').hide();				//清空重建按钮
		$('.setSize-input').hide();			//宽和高
		$('.oper-btn').hide()				//功能按钮
	}else{
		//$('a:contains("生成表格")').linkbutton('disable');
		$('.creat-btn').hide();				//生成表格
		$('#m-n').hide();					//行和列
		$('.clear-btn').show();			 	//清空重建按钮
		$('.setSize-input').show();         //宽和高
		$('.oper-btn').show()				//功能按钮
	}
	return
}

function hideBtn(){
	$('.creat-btn').hide();				//生成表格
	$('#m-n').hide();					//行和列
	$('.clear-btn').hide();				//清空重建按钮
	$('.setSize-input').hide();			//宽和高
	$('.oper-btn').hide()				//功能按钮
}

///选择成人or儿童 不再使用 2016-12-14
function radio(type){
	person=type;
	}
$(function(){
	droppable()	
	//loadTable();
});

///增加座位
function planSetSeat(_this){
	$this = $(_this);
	isShowWindow==1;
	//修改背景颜色
	$this.css({"background":"#FBEC88"})
	tab=$this.attr("id");
	CODE=$this.attr("id");
	
	$("#bed .drop").each(function(){
		if($(this).attr("id")!=CODE){
			this.style.backgroundColor = "#FFF";
		}
	})
	
	runClassMethod("web.DHCEMPatSeat","IfHaveBed",
		{'CODE':CODE,
		 'LocDr':LocDr},
		function(data){
		if(data==1){
			$('#detail').dialog('close');
			$.messager.alert("提示","该座位已维护，勿重复保存!");
		}else{
			$('#detail').dialog('open');
			$('#detail').dialog('move',{
					left:400,
					top:200
			});			
	   }
	});				
}