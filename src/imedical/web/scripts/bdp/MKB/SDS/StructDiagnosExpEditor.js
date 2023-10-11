document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
var flagLoadSmartTip=false;//是否加载医为智能提示标识:结构化诊断-true;其他-false
var flagSaveFreq=true; //是否保存频次标识:结构化诊断-true;其他-false
var base=""; //术语base
var init = function(){
	///结构化诊断深度融合医生站-可编辑表格中结构化诊断下拉框接口提供 
	///Type:ICDType^ClinicType
	///ICDType 0-西医 1-中医 2-证型
	///ClinicType O-门诊 E-急诊 I-住院 H-体检 N-新生儿
	InitDiagnosICDDescLookUp=function(DomID,Type){
		var ICDType=Type.split("^")[0]
		if ((ICDType==1)||(ICDType==2)){
			base=baseTCM; //中医疾病诊疗知识库
		}else{
			base=baseDIA; //临床实用诊断
		}
		var WordId="" //诊断短语Id
		var ExpId="" //诊断短语对照的结构化诊断属性内容id串
		$("#"+DomID+"").lookup({
		    url:$URL,
		    mode:'remote',
		    method:"Get",
		    idField:'MKBTRowId',
		    textField:'MKBTDesc',
		    columns: [[    
				//诊断表达式相关列  查中心词时不返回短语相关信息
				{field:'MKBTDesc',title:'诊断名称',width:450,sortable:true,
					formatter:function(value,rec){ 
					    var tooltipText=value.replace(/\ +/g,"")
				    	var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
				    	var matchCondition=""
						if ((findCondition!="")&&(findCondition!=undefined)){
							if(reg.test(findCondition)){   //包含中文情况
							    matchCondition=findCondition
							}else{ //不含中文情况
							 	var pinyin=Pinyin.GetJPU(value)
							 	
							 	/*var indexSign=value.indexOf("(")
							 	var respinyin=pinyin.substring(0,indexSign)+"("+pinyin.substring(indexSign,pinyin.length)+")" //中心词拼音拼上小括号
							 	if (indexSign<0){
							 		indexSign=value.indexOf("[")
							 		respinyin=pinyin.substring(0,indexSign)+"["+pinyin.substring(indexSign,pinyin.length)+"]" //短语拼音拼上中括号
							 	}*/
							 	var respinyin=pinyin
							 	var indexCondition=respinyin.indexOf(findCondition.toUpperCase())
							 	if (indexCondition>-1){
							 		var repValue=ReplaceSymbol(value)
							 		matchCondition=repValue.substr(indexCondition,findCondition.length) //根据英文检索条件，获取中文
								}
							}
						}
						
						 if (matchCondition!=""){ //检索条件不为空，匹配检索条件，作颜色区分
							 var len=value.split(matchCondition).length;
						     var value1="";
						     for (var i=0;i<len;i++){
							 	var otherStr=value.split(matchCondition)[i];
							    if (i==0){
								     if (otherStr!=""){
									    value1=otherStr
									}
								}else{
								    value1=value1+"<font color='red'>"+matchCondition+"</font>"+otherStr;
								}
							 }
					     }else{ //检索条件为空时直接取值
					     	var value1=value;
					     }
		                 return value1;     
		             } 
				},
				{field:'comDesc',title:'comDesc',width:80,sortable:true,hidden:true},
				{field:'MKBTCode',title:'诊断代码',width:80,sortable:true,hidden:true},
				{field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
				
				//诊断短语相关列  查短语时返回短语相关信息
				//"MKBSDRowId":"","MKBSDDesc":"","MKBSDRRowId":"||","MKBSDRTermDr":"","MKBSDRExpId":"","MKBSDRExp":"","MKBSDRSup":"","LinkIcdDesc":"","LinkIcdCode":""
				{field:'MKBSDRowId',title:'MKBSDRowId',width:20,sortable:true,hidden:true},
				{field:'MKBSDDesc',title:'诊断',width:100,sortable:true,hidden:true},
				{field:'MKBSDRRowId',title:'MKBSDRRowId',width:20,sortable:true,hidden:true},
				{field:'MKBSDRTermDr',title:'MKBSDRTermDr',width:20,sortable:true,hidden:true},
				{field:'MKBSDRExpId',title:'MKBSDRExpId',width:20,sortable:true,hidden:true},
				{field:'MKBSDRSup',title:'MKBSDRSup',width:20,sortable:true,hidden:true},
				{field:'MKBSDRExp',title:'结构化诊断',width:100,sortable:true,hidden:true},
				{field:'LinkIcdCode',title:'LinkIcdCode',width:20,sortable:true,hidden:true},
				{field:'LinkIcdDesc',title:'LinkIcdDesc',width:20,sortable:true,hidden:true}
			]],
		    pagination:true,
		    pageSize:8,
		    pageList:[8,10,20,30,40,50],
		    showHeader:false,
		    panelWidth:500,
		    panelHeight:305,
		    isCombo:true,
		    minQueryLen:2,
		    delay:'200',
		    queryOnSameQueryString:false,
		    queryParams:{ClassName: 'web.DHCBL.MKB.MKBTermProDetail',MethodName: 'GetTermListForDiaTemp',base:base, ICDType:Type},
		    onBeforeLoad:function(param){
		    	findCondition=param['q'];
		        var desc=param['q'];
		        param = $.extend(param,{desc:desc});
		    },
		    onSelect:function(index,rec){
		    	$("#SelSDSRowId").val("")
				$("#SelSDSSupplement").val("")
	    		SelPropertyData=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetDataByValue",rec.MKBSDRTermDr,rec.MKBSDRExpId)
	    		WordId=rec.MKBSDRowId
	    		ExpId=rec.MKBSDRExpId
	    		if (rec.MKBTRowId!=""){ //有中心词时弹出属性列表
			    	var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetPropertyIdByFlag",rec.MKBTRowId,"DT");
			    	var target=$("#"+DomID+""); //getStructDiagnosTarget();
			    	CreatPropertyDom(target,rec.MKBTRowId,"",indexTemplate,Type)
	    		}else{ //无中心词时直接保存
	    			var ICDRowId=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","GetHISICDRowId",rec.LinkIcdCode,rec.LinkIcdDesc,Type)
	    			var resWordICD="^^^^"+rec.MKBSDRowId+"^"+rec.MKBSDDesc+"^"+rec.LinkIcdCode+"^"+rec.LinkIcdDesc+"^"+ICDRowId
	    			
	    			//数据处理工厂性别、年龄限制
	    			if (typeof(ServerObj.EpisodeID)!="undefined"){
						var WordRowid=resWordICD.split("^")[4];
						var resRequire=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","CheckDiagRequire",ServerObj.EpisodeID,WordRowid)
						if (resRequire!=""){
							$.messager.alert('错误提示',resRequire,"error");
							return;
						}
	    			}
	    			
	    			// 调用医生站函数进行数据回传
					if (CDSSPropertyConfirmCallBack) CDSSPropertyConfirmCallBack(resWordICD,DomID);
	    		}

				//属性列表确定
				$("#confirm_btn_Property").unbind('click').on('click',function (e) { 
					var propertyValue=GetPropertyValue("1");
					var SDSTermDR=propertyValue.split("#")[0];
					var	SDSValue=propertyValue.split("#")[1];
					var SDSSupplement=propertyValue.split("#")[2];
					var resultRequired=propertyValue.split("#")[3]; //必填项未维护结果集 
					if ((resultRequired!="")&&(resultRequired!=undefined)){
						$.messager.alert('错误提示',$g(resultRequired)+" "+$g('不能为空!'),"error");
						return;
					}
					var WordDR=""
					if ((WordId!="")&&(ExpId==SDSValue)){
						WordDR=WordId  //直接选择诊断短语(系统对照好的结构化诊断)，未手动勾选其他属性时，确定短语作为ICD
					}
					var resWordICD=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetWordICD",SDSTermDR,SDSValue,SDSSupplement,WordDR,Type); //根据表达式获取短语及短语关联ICD
			    	//alert(resWordICD)
					$("#SelMKBRowId").val("");
					// 关闭属性列表
					$("#mypropertylist").hide();
					
					//数据处理工厂性别、年龄限制
					if (typeof(ServerObj.EpisodeID)!="undefined"){
						var WordRowid=resWordICD.split("^")[4];
						var resRequire=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","CheckDiagRequire",ServerObj.EpisodeID,WordRowid)
						if (resRequire!=""){
							$.messager.alert('错误提示',resRequire,"error");
							return;
						}
					}
					
						
					// 调用医生站函数进行数据回传
					if (CDSSPropertyConfirmCallBack) CDSSPropertyConfirmCallBack(resWordICD,DomID);
					
				}) 
				//属性列表取消
				$("#cancel_btn_Property").unbind('click').on('click',function (e) { 
					$("#SelMKBRowId").val("");
					$("#mypropertylist").hide();	
					if($("#SelSDSRowId").val()==""){ //新增弹框取消时需要调回调函数
		      			if (CDSSPropertyCcancelfirmCallBack) CDSSPropertyCcancelfirmCallBack(DomID);	
					}
				})
				
				autoHide(DomID);
		    },
		    onShowPanel:function(){
				//诊断列表弹出时隐藏属性列表
		   		if($("#mypropertylist").is(":hidden")==false){
		   			$("#mypropertylist").hide();
				}
			}
		});
 	}

	///结构化诊断深度融合医生站-诊断列表中结构化诊断双击修改时属性列表弹窗接口提供	
	///参数：SDSRowId结构化诊断RowId，TermDR结构化诊断中心词Id,Supplement备注,Value属性内容值串,WordDR短语Id,Type:ICDType^ClinicType
	InSDSExpProperty=function(SDSRowId,TermDR,Supplement,target,Value,WordId,Type){
		var ICDType=Type.split("^")[0]
		//未关联结构化诊断的老诊断修改时屏蔽结构化属性弹窗
		if (TermDR==""){
			//隐藏未关闭的属性列表
			if($("#mypropertylist").is(":hidden")==false){
	   			$("#mypropertylist").hide();
			}
			return;
		}
		$("#SelSDSRowId").val(SDSRowId)
		$("#SelSDSSupplement").val(Supplement)
		var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetPropertyIdByFlag",TermDR,"DT");
		if (!target) target=getStructDiagnosTarget();
		SelPropertyData=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetDataByValue",TermDR,Value)
		CreatPropertyDom(target,TermDR,SDSRowId,indexTemplate,Type);
		
		
		//属性列表确定
		$("#confirm_btn_Property").unbind('click').on('click',function (e) { 
			var propertyValue=GetPropertyValue("1");
			var SDSTermDR=propertyValue.split("#")[0];
			var	SDSValue=propertyValue.split("#")[1];
			var SDSSupplement=propertyValue.split("#")[2];
			var resultRequired=propertyValue.split("#")[3]; //必填项未维护结果集 
			if ((resultRequired!="")&&(resultRequired!=undefined)){
				$.messager.alert('错误提示',resultRequired+'不能为空!',"error");
				return;
			}
			var WordDR=""
			if (SDSValue==Value){
				WordDR=WordId //修改时，若属性无改动，则ICD保持不变
			}
			var resWordICD=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetWordICD",SDSTermDR,SDSValue,SDSSupplement,WordDR,Type); //根据表达式获取短语及短语关联ICD
	    	//alert(resWordICD)
			$("#SelMKBRowId").val("");
			// 关闭属性列表
			$("#mypropertylist").hide();	
			//数据处理工厂性别、年龄限制
			if (typeof(ServerObj.EpisodeID)!="undefined"){
				var WordRowid=resWordICD.split("^")[4];
				var resRequire=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","CheckDiagRequire",ServerObj.EpisodeID,WordRowid)
				if (resRequire!=""){
					$.messager.alert('错误提示',resRequire,"error");
					return;
				}
			}
			// 调用医生站函数进行数据回传
			if (CDSSPropertyConfirmCallBack) CDSSPropertyConfirmCallBack(resWordICD,$(target).attr("id"));
			
		}) 
		//属性列表取消
		$("#cancel_btn_Property").unbind('click').on('click',function (e) { 
			$("#SelMKBRowId").val("");
			$("#mypropertylist").hide();	
			if($("#SelSDSRowId").val()==""){ //新增弹框取消时需要调回调函数
      			if (CDSSPropertyCcancelfirmCallBack) CDSSPropertyCcancelfirmCallBack($(target).attr("id"));	
			}
		})
		autoHide($(target).attr("id"));
	}

    //创建可编辑属性列表控件
	function CreatPropertyDom(target,SDSTermDR,SDSRowId,indexTemplate,Type){
		DiagEditId=$(target).attr("id").split("_")[0] //全局变量-诊断录入列表正在编辑行Id赋值
		DiagEditType=Type //全局变量-诊断录入列表正在编辑行分类赋值
		$("#SelMKBRowId").val(SDSTermDR);
		
		$('#SearchProperty').searchbox('setValue','')
		$HUI.radio("#SearchModeA").uncheck(); 
		$HUI.radio("#SearchModeL").uncheck();
		$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
		$("#DiagForm").empty();
		LoadPropertyData(SDSTermDR,SDSRowId,indexTemplate);
		//再次打开时重新设置默认值，以防拖动后显示不下
		$("#mypropertylist").css("width",myProWidth+"px")
		$("#mypropertylist").css("height",myProHeight+"px")
		//$('#mypromplayout').layout('hidden','west')
		//$('#mypromplayout').layout('panel', 'west').panel('resize',{width:myProWidth*(1/4)});
	    $('#mypromplayout').layout('panel', 'east').panel('resize',{width:myProEastWidth}); //9/20
	    
		if(target.offset().top+$("#mypropertylist").height()+30>$(window).height()){
			//显示在上面
			$("#mypropertylist").css({
					"top": target.offset().top-$("#mypropertylist").height()-5,
					"left": target.offset().left 
				}).show();
		}
		else{
			//显示在下面
			$("#mypropertylist").css({
				"top": target.offset().top+30,
				"left": target.offset().left 
			}).show();
		}
		$("#mypropertylayout").layout("resize");
		
		//结构化诊断属性列表拖动改变大小
		 $('#mypropertylist').resizable({
		    onStopResize:function(e){
	            //$('#mypromplayout').layout('hidden','west')
	            //$('#mypromplayout').layout('panel', 'west').panel('resize',{width:$("#mypropertylist").width()*(1/4)});
	            $('#mypromplayout').layout('panel', 'east').panel('resize',{width:$("#mypropertylist").width()*(70/100)}); //9/20
	            $("#mypropertylayout").layout("resize");
		    }
		});	 
	}
	
	function autoHide(DomID){
		//属性列表隐藏(鼠标移除)
		$(document).unbind('click').on('click',function(e){ 
			var target  = $(e.target);
			if(target.closest("#"+DomID.split("_")[0]).length==1){ //影响诊断录入勾选框勾选
				if(target.closest("#jqg_tabDiagnosEntry_"+DomID.split("_")[0]).length==0){ //如果点击的是诊断录入的勾选框不做限制
					return false; //诊断录入诊断行跳过
				}
			}
			if(target.closest("#mypropertylist").length==1){
				return false; //结构化属性列表跳过
			}
			if(target.closest("#NodeMenu").length==1){
				return false; //右键智能提示跳过
			}
			if(target.closest("#selProMenu").length==1){
				return false; //已选列表右键跳过
			}
            // 判断有没有这个元素
			if(target.closest("#mypropertylist").length == 0){
				$("#SelMKBRowId").val("");
				$("#mypropertylist").hide();	
				if($("#SelSDSRowId").val()==""){ //新增弹框取消时需要调回调函数
		  			if (CDSSPropertyCcancelfirmCallBack) CDSSPropertyCcancelfirmCallBack(DomID);	
				}
 　　　　　 	}　　　　	
		}); 
	}
	
	//替换诊断名中的特殊符号
	ReplaceSymbol=function(str){
		var text=str.replace(/\-/g,"")
		text=text.replace(/\—/g,"")
		text=text.replace(/\\/g,"")
		text=text.replace(/\#/g,"")
		text=text.replace(/\%/g,"")
		text=text.replace(/\(/g,"")
		text=text.replace(/\)/g,"")
		text=text.replace(/\（/g,"")
		text=text.replace(/\）/g,"")
		text=text.replace(/\[/g,"")
		text=text.replace(/\]/g,"")
		text=text.replace(/\［/g,"")
		text=text.replace(/\］/g,"")
		text=text.replace(/\ */g,"")
		text=text.replace(/\,/g,"")
		text=text.replace(/\，/g,"")
		text=text.replace(/\、/g,"")
		text=text.replace(/\./g,"")
		text=text.replace(/\//g,"")
		text=text.replace(/\ \\/g,"")
		text=text.replace(/\：/g,"")
		text=text.replace(/\；/g,"")
		text=text.replace(/\`/g,"")
		text=text.replace(/\“/g,"")
		text=text.replace(/\”/g,"")
		text=text.replace(/\+/g,"")
		return text;
	}

	
	/**  
     * layout方法扩展  
     * @param {Object} jq  
     * @param {Object} region  
     */  
    $.extend($.fn.layout.methods, {   
        /**  
         * 面板是否存在和可见  
         * @param {Object} jq  
         * @param {Object} params  
         */  
        isVisible: function(jq, params) {   
            var panels = $.data(jq[0], 'layout').panels;   
            var pp = panels[params];   
            if(!pp) {   
                return false;   
            }   
            if(pp.length) {   
                return pp.panel('panel').is(':visible');   
            } else {   
                return false;   
            }   
        },   
        /**  
         * 隐藏除某个region，center除外。  
         * @param {Object} jq  
         * @param {Object} params  
         */  
        hidden: function(jq, params) {   
            return jq.each(function() {   
                var opts = $.data(this, 'layout').options;   
                var panels = $.data(this, 'layout').panels;   
                if(!opts.regionState){   
                    opts.regionState = {};   
                }   
                var region = params;   
                function hide(dom,region,doResize){   
                    var first = region.substring(0,1);   
                    var others = region.substring(1);   
                    var expand = 'expand' + first.toUpperCase() + others;   
                    if(panels[expand]) {   
                        if($(dom).layout('isVisible', expand)) {   
                            opts.regionState[region] = 1;   
                            panels[expand].panel('close');   
                        } else if($(dom).layout('isVisible', region)) {   
                            opts.regionState[region] = 0;   
                            panels[region].panel('close');   
                        }   
                    } else {   
                        panels[region].panel('close');   
                    }   
                    if(doResize){   
                        $(dom).layout('resize');   
                    }   
                };   
                if(region.toLowerCase() == 'all'){   
                    hide(this,'east',false);   
                    hide(this,'north',false);   
                    hide(this,'west',false);   
                    hide(this,'south',true);   
                }else{   
                    hide(this,region,true);   
                }   
            });   
        },   
        /**  
         * 显示某个region，center除外。  
         * @param {Object} jq  
         * @param {Object} params  
         */  
        show: function(jq, params) {   
            return jq.each(function() {   
                var opts = $.data(this, 'layout').options;   
                var panels = $.data(this, 'layout').panels;   
                var region = params;   

                function show(dom,region,doResize){   
                    var first = region.substring(0,1);   
                    var others = region.substring(1);   
                    var expand = 'expand' + first.toUpperCase() + others;   
                    if(panels[expand]) {   
                        if(!$(dom).layout('isVisible', expand)) {   
                            if(!$(dom).layout('isVisible', region)) {   
                                if(opts.regionState[region] == 1) {   
                                    panels[expand].panel('open');   
                                } else {   
                                    panels[region].panel('open');   
                                }   
                            }   
                        }   
                    } else {   
                        panels[region].panel('open');   
                    }   
                    if(doResize){   
                        $(dom).layout('resize');   
                    }   
                };   
                if(region.toLowerCase() == 'all'){   
                    show(this,'east',false);   
                    show(this,'north',false);   
                    show(this,'west',false);   
                    show(this,'south',true);   
                }else{   
                    show(this,region,true);   
                }   
            });   
        }   
    });  
	
}
$(init);

