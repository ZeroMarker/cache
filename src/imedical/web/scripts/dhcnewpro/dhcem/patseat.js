///Creator:huaxiaoying
///CreateDate:2016/07/14
var TypeDesc="",TypeDr=""; //���� person=0;2016-12-14
var tab=null;//dropʱtd��ID
var isShowWindow=0;
//var ifHaveTable=0;//���ɱ�� ��ť�Ƿ���Ч(�Ƿ��Ѿ�ά������λ)
var Id="" //������λ��ID
var TDId=""//������Ԫ���ID
var LocDr=LgCtLocID;//Ĭ�Ͽ���id
var seatWidth="",seatHight="",patBodyH=""
$(function(){ 
	hospComp = GenHospComp("DHC_EmPatSeat");  //hxy 2020-05-24 st
	var HospDr=hospComp.getValue();
	hospComp.options().onSelect = function(){///ѡ���¼�
		var HospDr=hospComp.getValue();
		$("#ACPart").combobox( { 
			url:LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListLoc&HospDr="+HospDr
		})
		$('#PSCType').combobox({
			url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListType&HospDr="+HospDr
		})
	}//ed
	//��������ѡ��
	$('#ACPart').combobox({
		valueField:'id', 
        textField:'text',
        mode: 'remote',  // 2017-01-06
		url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListLoc&HospDr="+HospDr, //hxy 2020-05-24 &HospDr="+HospDr
		onSelect: function () {
				//��ȡѡ�е�ֵ
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
			//$('#ACPart').combobox('select', data[0].id);//Ĭ�Ͽ��� // 2017-01-06
		}	
			
	});
	
	///$('#ACPart').combobox('select', LgCtLocID);//Ĭ�Ͽ��� // 2017-01-06 ע�ͷſ�
	//��λ��������ѡ�� 2016-12-14
	$('#PSCType').combobox({
		valueField:'id',    
        textField:'text',  
		url: LINK_CSP+"?ClassName=web.DHCEMPatSeat&MethodName=ListType&HospDr="+HospDr, //hxy 2020-05-24 &HospDr="+HospDr
		onSelect: function () {
				//��ȡѡ�е�ֵ
				TypeDr = $(this).combobox('getValue');
				TypeDesc = $(this).combobox('getText');									
		},
		onLoadSuccess:function () {
		}	
			
	});
   
   
	$("#bed").on("click",".dragitem",function(){
		isShowWindow=0//����������
	    Id=$(this).parent().attr("id")
	    this.style.backgroundColor = "#06EBED";
	    $("#bed .dragitem").each(function(){
				if($(this).parent().attr("id")!=Id){
					this.style.backgroundColor = "#77AAFF";
				}
		})			
					
	})
	//��Ԫ���id��ȡ ���ڼ��������Ҳ���
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

///ɾ�������� 2017-02-13
function cancelrow(){
	if(TDId==""){
		$.messager.alert("��ʾ","�뵥��ѡ��~"); 
		return;
		}
	$.messager.confirm('ȷ��','��ȷ��ɾ����������',function(r){    
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
									$.messager.confirm('ȷ��','�����Ѿ�����λ����ȷ�ϼ���ɾ����������',function(r){ 
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
															$.messager.alert("��ʾ","ɾ��ʧ��");
														}
														
													});
											}
									});
					 			}else{
						 			var mydata=data.split("^");
						 			$.messager.alert("��ʾ","����"+mydata[0]+"����λ�Ѱ��Ż��ߣ�����ɾ����");
						 		}	
					        })
	
			      }
		    
		 });
		 
}
///ɾ�������� 2017-02-13
function cancelcol(){
	if(TDId==""){
		$.messager.alert("��ʾ","�뵥��ѡ��~"); 
		return;
		}
	$.messager.confirm('ȷ��','��ȷ��ɾ����������',function(r){    
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
									$.messager.confirm('ȷ��','�����Ѿ�����λ����ȷ�ϼ���ɾ����������',function(r){ 
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
															$.messager.alert("��ʾ","ɾ��ʧ��");
														}
														
													});
											}
									});
					 			}else{
						 			var mydata=data.split("^");
						 			$.messager.alert("��ʾ","����"+mydata[0]+"����λ�Ѱ��Ż��ߣ�����ɾ����");
						 		}	
					        })
	
			      }
		    
		 });
	
}

///���������
function addrow(type){
	if(TDId==""){
		$.messager.alert("��ʾ","�뵥��ѡ��~");
	}else{
		if(type==1){
		$.messager.confirm('ȷ��','��ȷ�ϸ����Ϸ����һ����',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","AddRowtop",
					        {'LocDr':LocDr,
					         'Code':TDId,
					         'type':type},
							function(data){
								if(data==0)
								{   //location.reload();
									$('#bed').html("");
									loadTable();//ˢ��
									TDId=""; //2017-02-13
					 			}else{
						 			$.messager.alert("��ʾ","����ʧ��");
						 		}	
						
							})
		    }	
		    });//end
		}else{
			$.messager.confirm('ȷ��','��ȷ�ϸ����·����һ����',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","AddRowtop",
					        {'LocDr':LocDr,
					         'Code':TDId,
					         'type':type},
							function(data){
								if(data==0)
								{   //location.reload();
									$('#bed').html("");
									loadTable();//ˢ��
									TDId=""; //2017-02-13
					 			}else{
						 			$.messager.alert("��ʾ","����ʧ��");
						 		}	
						
							})
		    }	
		    });//end
			}
		
	}
}


///���������
function addcol(type){
	if(TDId==""){
		$.messager.alert("��ʾ","�뵥��ѡ��~");
	}else{
		if(type==1){
			$.messager.confirm('ȷ��','��ȷ�ϸ���������һ����',function(r){    
			    if (r){
					runClassMethod("web.DHCEMPatSeat","AddColleft",
						        {'LocDr':LocDr,
						         'Code':TDId,
						         'type':type},
								function(data){
									if(data==0)
										{   //location.reload();
											$('#bed').html("");
											loadTable();//ˢ��
											TDId=""; //2017-02-13
										}else if(data==2){
											$.messager.alert("��ʾ","�Ѵﵽ�������6,�����ٲ���");
							 			}else{
								 			$.messager.alert("��ʾ","����ʧ��");
								 		}	
						
								})
																
		 }	
		 });//end
		}else{
				$.messager.confirm('ȷ��','��ȷ�ϸ����Ҳ����һ����',function(r){    
			    if (r){
					runClassMethod("web.DHCEMPatSeat","AddColleft",
						        {'LocDr':LocDr,
						         'Code':TDId,
						         'type':type},
								function(data){
									if(data==0)
										{   //location.reload();
											$('#bed').html("");
											loadTable();//ˢ��
											TDId=""; //2017-02-13
										}else if(data==2){
											$.messager.alert("��ʾ","�Ѵﵽ�������6,�����ٲ���");
							 			}else{
								 			$.messager.alert("��ʾ","����ʧ��");
								 		}	
						
								})
																
		 }	
		 });//end
			}
		 					
		
	}
}
	

///ɾ��������λ
function cancelone(){
	
	if(Id==""){
		$.messager.alert("��ʾ","��ѡ����λ~"); 
		return;
	}
	var bedName = $("#"+Id+"").find(".bednum").html();
	$.messager.confirm('ȷ��','��ȷ�Ͻ�'+bedName+'��ɾ����',function(r){    
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
									$.messager.alert("��ʾ","����λ����,����ɾ����"); 
					 			}else{}	
					        })
	
			      }
		    
		 });
	}

///�������
function cancel()
	{   $('#detail').dialog('close');
	    isShowWindow=0//����������
		$.messager.confirm('ȷ��','��ȷ�Ͻ����������������Ҫ����ά��������λ�������أ�',function(r){    
		    if (r){
				runClassMethod("web.DHCEMPatSeat","DeletePatSeat",
			        {'LocDr':LocDr},
					function(data){
						if(data==0)
						{
							location.reload();
						}else if(data==2){
							$.messager.alert("��ʾ","ĳ��λ����,�������ʱ�ؽ���"); 
			 			}else{}	
						
					})
		    }
		    //location.reload()
		});		
	}

//���ر��
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
	
//���ص�Ԫ������
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
						html+='<div class="dragitem" style="width:'+seatWidth+'px;max-height:'+seatHight+'px;" id="hidden">'; //��ά������ʹ�����ÿ�ߣ�ʹ��style
						html+='<div class="person" id="patientSex'+i+'">'+bedArray[2]+'</div>';
						html+='<div class="bednum" id="patientNum'+i+'"><span style="padding-left:4px">'+bedArray[1]+'</span></div>'; /*2018-10-18 ����4px*/
						html+='<div class="patBody" style="height:'+patBodyH+'px;" id="patientBody'+i+'"></div>'; //��ά������ʹ�����ÿ�ߣ�ʹ��style
						html+='</div>';
		
						var bedXYArray=bedArray[0].split("-");
						var X=bedXYArray[0]-1;
						var Y=bedXYArray[1]-1;
						$('#bed tr').eq(X).find('td').eq(Y).empty().append(html);
					}	
	})
				
	
}
//��ʼ����ͼ
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


//���ɱ�� ��ť�¼�
function creatTable()
	   {
		    //if(ifHaveTable==1){
		 	//	$.messager.alert("��ʾ","������������~");  
			//}else
			//{
		   		var m=$("#m").val();
		   		var n=$("#n").val();
		   		if(m==""||n==""){
		   	   		$.messager.alert("��ʾ","��¼�� �� �� �У�"); 
		   	   		return;
			   	}//else if(n>6){
				   	//$.messager.alert("��ʾ","��¼��1��6"); 
				   	//return;
				//}   //2016-10-19
			   	str=m+"*"+n+"^"+LocDr+"^"
			   	runClassMethod("web.DHCEMPatSeat","SavePatSeat",
		        	{'str':str},
					function(data){
						if(data==1){
							$.messager.alert("��ʾ","������������~"); 
						}else if(data==0){	
						    //$.messager.alert("��ʾ","���ɱ��ɹ���");	
						    loadView(m,n);
						    //ifHaveTable=1;
						    $('#bed').html("");
				            loadTable();//ˢ��table	    
						    $("#m").val('');
			                $("#n").val('');
					    }else{
						    $.messager.alert("��ʾ","���α��ɹ�ʧ�ܣ�");
						}
				})
				//loadView(m,n);
			    //ifHaveTable=1;
			    //$('#bed').html("");
				//loadTable();//ˢ��table
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
 
//�ύ����
function submit()
{   
	//var personDesc="����"; //2016-12-14
	//if (person==1){personDesc="��ͯ";} //2016-12-14
	if($("#bedname").val()==""){
		 $.messager.alert("��ʾ","����д���ƣ�"); 
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

    $("#bedname").val('');//ʹ�´δ򿪴���ʱֵΪ��
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
							//html+='<input type="button" class="ArrangeBtn" value="����" />';
							//html+='<input type="button" class="Transfuse" value="��Һ" />';
							//html+='</div>';
							html+='</div>';
							$("#"+tab).empty().append(html);
							$('#detail').dialog('close');	  
						}else if(data==1){
							$.messager.alert("��ʾ","�������Ѵ���,�����ظ�!"); 
							//$('#detail').dialog('close');
						}else if(data=="-3"){
							$.messager.alert("��ʾ","��ѡ����λ����!"); 
						}else{	
							$('#detail').dialog('close');
							$.messager.alert('��ʾ','����ʧ��:'+data)
						} 
					 });
	

	}
} 

///���� ��λͼʹ�ý���� ��λ���ÿ�� 2016-10-19
function save(){
	var w=$("#w").val();
	var h=$("#h").val();
	if(w==""||h==""){
   		$.messager.alert("��ʾ","��¼�� �� �� �ߣ�"); 
   		return;
   	}
   	str=w+"*"+h+"^"+LocDr+"^"
   	runClassMethod("web.DHCEMPatSeat","SavePatSeatStyle",
    	{'str':str},
		function(data){
			if(data==0){
			$.messager.alert("��ʾ","����ɹ���");
			$("#bed").html("")//2016-12-14
			loadTable();
			$("#w").val('');
			$("#h").val('');
			}
	})
}
///���ɱ��ť�Ƿ���� 2016-12-08
function buttonIfUse(num){
    if (num=="1") {
	    //alert("OK")
		//$('a:contains("���ɱ��")').linkbutton('enable');
		$('.creat-btn').show();				//���ɱ��
		$('#m-n').show();					//�к���
		$('.clear-btn').hide();				//����ؽ���ť
		$('.setSize-input').hide();			//��͸�
		$('.oper-btn').hide()				//���ܰ�ť
	}else{
		//$('a:contains("���ɱ��")').linkbutton('disable');
		$('.creat-btn').hide();				//���ɱ��
		$('#m-n').hide();					//�к���
		$('.clear-btn').show();			 	//����ؽ���ť
		$('.setSize-input').show();         //��͸�
		$('.oper-btn').show()				//���ܰ�ť
	}
	return
}

function hideBtn(){
	$('.creat-btn').hide();				//���ɱ��
	$('#m-n').hide();					//�к���
	$('.clear-btn').hide();				//����ؽ���ť
	$('.setSize-input').hide();			//��͸�
	$('.oper-btn').hide()				//���ܰ�ť
}

///ѡ�����or��ͯ ����ʹ�� 2016-12-14
function radio(type){
	person=type;
	}
$(function(){
	droppable()	
	//loadTable();
});

///������λ
function planSetSeat(_this){
	$this = $(_this);
	isShowWindow==1;
	//�޸ı�����ɫ
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
			$.messager.alert("��ʾ","����λ��ά�������ظ�����!");
		}else{
			$('#detail').dialog('open');
			$('#detail').dialog('move',{
					left:400,
					top:200
			});			
	   }
	});				
}