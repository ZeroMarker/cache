 
 /// 药学监护编辑
 var url="dhcpha.clinical.action.csp";
 var monLevId=""; //监护级别ID
 var monLevelDesc=""  //监护级别描述
 var monLocID=""; //病人科室ID
 var monAdmID=""; //就诊ID
 var monSubClassId=""; //学科分类ID
 var monWardID="";
 var monID="";

 $(function(){
	 
	 monLevId=getParam("monLevId");  /*csp参数*/
	 monLevelDesc=getParam("monLevelDesc");
	 monLevelDesc=unescape(monLevelDesc)
	 if(monLevelDesc.indexOf("@")){
		monLevelDesc = "<font color="+ monLevelDesc.split("@")[1] +">"+monLevelDesc.split("@")[0]+"</font>"; 
	 }
	 monLocID=getParam("monLocID");
	 monAdmID=getParam("monAdmID");
	 monWardID=getParam("monWardID");
	 monSubClassId=getParam("monSubCId");
	 setMonItem();
 	 InitUI();
 	 LoadMonScope();  /// 初始化监护标准列表
 	 LoadMonItem();   /// 初始化监护项目列表
 	 $("#btnAddEmp").bind("click",save);  //提交
 	 SpecControlInputShow(); ///特殊控制
 })
 
 function InitUI(){
	$('#ImpMonItems').bind("focus",function(){
		if(this.value=="编辑内容..."){
			$('#ImpMonItems').val("");
		}
	});
	
	$('#ImpMonItems').bind("blur",function(){
		if(this.value==""){
			$('#ImpMonItems').val("编辑内容...");
		}
	});
	
	$('#ImpMonContent').bind("focus",function(){
		if(this.value=="编辑内容..."){
			$('#ImpMonContent').val("");
		}
	});
	
	$('#ImpMonContent').bind("blur",function(){
		if(this.value==""){
			$('#ImpMonContent').val("编辑内容...");
		}
	});
 }

 /// 设置监护符合注释
 function setMonItem(){
	 var notes = "";	 
	 /* if(monLevId == "1"){
	 	notes="[符合一项即为一级监护]";
	 }else if(monLevId == "2"){
	 	notes="[符合一项即为二级监护]";
	 }else{
	 	notes="[符合一项即为三级监护]";
	 } */
	  notes="[符合一项即为"+monLevelDesc+"监护]";
	 $('span.ui-font12:contains("符合")').html(notes);
 }
 
 /// 加载监护范围
 function LoadMonScope(){
	 $.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getMonScopeList',//提交到那里 后他的服务  
		data: {monSubClassId:monSubClassId, monLevId:monLevId}, //提交的参数  
		success:function(jsonString){			
			createLevScope(jsonString);  
			pageBasicControll();    
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); 
 }
 
 /// 加载监护项目
 function LoadMonItem(){
	createLevClass(monSubClassId);  	//  重写加载监护项目 quniapeng 2018/3/17
	checkLevelControl();
	/* $.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getMonItemList',
		data: {monSubClassId:monSubClassId, monLevId:monLevId},
		success:function(jsonString){ 
			//createLevItm(jsonString); 
			createLevClass(monSubClassId);
			//pageBasicControll();      
			checkLevelControl();
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); */
 }
 
 /// 检验指标和病区转归情况
 function LoadMonImpLabsAndGuidCon(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getMonImpLabsAndGuidCon',
		data: {monId:monId},
		success:function(jsonString){
			var monImpLabsAndGuidConObj = jQuery.parseJSON(jsonString);
	     	$('#ImpMonItems').val(monImpLabsAndGuidConObj[0].ImpMonItems);
	     	$('#ImpMonContent').val(monImpLabsAndGuidConObj[0].ImpMonContent);
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
 }
 
 //控制name登录CheckBoxMain的选项的子选项被选中			qunianpeng  2016-09-18
 function pageBasicControll()
 {
 	$("input").bind('click',function(){
		$("input[name='CheckBoxMain']").each(function(){
			if($(this).attr("checked")){
				var CheckAllId=$(this).attr('id');
				$('.'+CheckAllId).css("display","block")
			}else{
				var CheckAllId=$(this).attr('id');
				$('.'+CheckAllId).css('display','none')
			}
		}) 
	})
 }
 
  //控制监护项目的选项的子选项被选中			qunianpeng  2018-03-17
 function checkLevelControl()
 {
 	$(".cblevel").bind('click',function(){
	 	$(".cblevel").each(function(){
			if($(this).attr("checked")){
				$(this).next().css("display","block");
			}else{
				$(this).next().css('display','none')
			}
		});		
	});
 }
  
 ///  动态加载监护范围数据列表     qunianpeng  2016-09-18
 function createLevScope(jsonString){
	 var mLevScopeListObj = jQuery.parseJSON(jsonString);
     var htmlls = '';
     for(var i=0;i<mLevScopeListObj.length;i++){
			htmlls = ' <tr> '			//加载学科分类
			htmlls = htmlls +'<td> <input id="'+mLevScopeListObj[i].PHMSCRowID+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevScopeListObj[i].PHMSCDesc+' </td> '     	
			htmlls =htmlls+' </tr>' 
			var temp = $('#'+mLevScopeListObj[i].PHMSCRowID);			
			if ((temp.length <= 0)) {	  //不重复加载相同的学科分类	
					$('#m_LevScope').append(htmlls);	
			}
				
			htmlls = ' <tr style="display:none" class="'+mLevScopeListObj[i].PHMSCRowID+'"> '				//加载纳入标准
			htmlls =htmlls +'<td> <input type="checkbox" class="cb" style="margin-left:40px" value="'+mLevScopeListObj[i].monScopeID+'" />'+mLevScopeListObj[i].monScopeDesc+' </td> '     	
			htmlls =htmlls+' </tr>'				
			$('#m_LevScope').append(htmlls);  
		     								 
	 }

     $("div[id='mainpanel']").css('overflow','auto');  //解决滚动条不能自动加载问题
     ///LoadPatMonScopeList();
     ///LoadPatMonItemList();
     ///LoadMonImpLabsAndGuidCon();
 }


 /// 动态创建监护项目  qunianepng 2018/3/16
 function createLevClass(monSubClassId){
	 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","GetScopeDescList",{"classId":monSubClassId},function(jsonString){	
	 	if (jsonString != ""){		
			$.each(jsonString,function(index,obj){
				var htmls = "";
				 htmls = htmls + '<div> <input id="'+obj.classDesc+'" class="cblevel" type="checkbox" name="CheckBoxClass" />'+obj.classDesc+' ';  
				 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","getMonItemListNew",{"classId":obj.classId,"monLevelId":monLevId},function(jsonObj){			
					if (jsonObj != ""){
						htmls = htmls + '<table style="margin-left:20px; display:none; ">';
						var $td = 'width:30%;';
						var spanleft  = 'margin-left:10px; margin-right:5px;';
	 					var spanright = 'margin-left:5px;  margin-right:100px;';
	 					var subhtmls = ""	 	 					
	 					$.each(jsonObj,function(subindex,subobj){	
	 						if((subindex+1)%3 == 1){  
						     	subhtmls = subhtmls + '<tr>';
					     	 }
					     	 subhtmls = subhtmls + '<td style="'+$td+'" ><span style="'+spanleft+'">'+subobj.monItemDesc+'</span><input type="text" name="'+subobj.monItemID+'" class="input-ui-width"/><span style="'+spanright+'" >'+subobj.monItemUom+'</span> </td>';						    
						     if((subindex+1)%3 == 0){
						     	subhtmls = subhtmls + '</tr>';
						     }						     
						});					
						htmls = htmls + subhtmls;
					}
					else{
						alert("获取数据失败!");
					}
				 },'json',false)					
				
				htmls = htmls + "</table></div>";
				$('#m_LevItem').append(htmls);									
			});
		}
		else{
			alert("获取数据失败!");
		}
	 },'json',false)
}
 
 ///动态加载监护项目数据列表    qunianepng 2016-09-19
 function createLevItm(jsonString){
	 
	 var mLevItmListObj = jQuery.parseJSON(jsonString);
     var htmlls = '';
     var subhtmls = '';
     var $td = 'width:30%;';
	 var spanleft  = 'margin-left:10px; margin-right:5px;';
	 var spanright = 'margin-left:5px;  margin-right:100px;';
     for(var i=0;i<mLevItmListObj.length;i++){
			htmlls = ' <div><tr> '			//加载学科分类
			htmlls = htmlls +'<td> <input id="'+mLevItmListObj[i].PHMSCDesc+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevItmListObj[i].PHMSCDesc+' </td> '     	
			htmlls = htmlls+' </tr></div>' 
			var temp = $('#'+mLevItmListObj[i].PHMSCDesc);	
			if ((temp.length <= 0)) {	  //不重复加载相同的学科分类	
					$('#m_LevItem').append(htmlls);	
			}		
			
			htmlls = '<tr  style="display:none;margin-left:40px;width:100%"  class="'+mLevItmListObj[i].PHMSCDesc+'"> '				//加载纳入标准
			htmlls =htmlls +'<td style="width:35%;align:right">'+mLevItmListObj[i].monItemDesc+'</td> ' 
			htmlls = htmlls +'<td style="width:50%">'+'<input  type="text" name="'+mLevItmListObj[i].monItemID+'" /> ' + '</td>'	
			htmlls =htmlls+' </tr>'			
			
			$('#m_LevItem').append(htmlls); 
	 }	 
	
     $("div[id='mainpanel']").css('overflow','auto');  //解决滚动条不能自动加载问题
}

/// 加载病人监护列表
function LoadPatMonList(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getPatMonList',
		data: {monLevId:monLevId,AdmDr:AdmDr},
		success:function(jsonString){
			createPatMonList(jsonString);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
}

function createPatMonList(jsonString){
	 var mPatMonListObj = jQuery.parseJSON(jsonString);
     var htmlls1 = '';htmlls2 = '';htmlls3 = "";
     for(var i=0;i<mPatMonListObj.length;i++){
	     if(mPatMonListObj[i].monLeID=="1"){
     	 	htmlls1 = htmlls1 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
	     if(mPatMonListObj[i].monLeID=="2"){
     	 	htmlls2 = htmlls2 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
	     if(mPatMonListObj[i].monLeID=="3"){
     	 	htmlls3 = htmlls3 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
     }
     $('#m_PatMonList1').append(htmlls1);
     $('#m_PatMonList2').append(htmlls2);
     $('#m_PatMonList3').append(htmlls3);
     $("div.list").css('overflow','auto');  //解决滚动条不能自动加载问题
}

/// 加载病人监护范围[标准]
function LoadPatMonScopeList(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getPatMonScopeList',
		data: {monId:monId},
		success:function(jsonString){
			setPatMonScopeList(jsonString);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
}

/// 病人监护范围[标准]
function setPatMonScopeList(jsonString){
	 var mPatMonScopeListObj = jQuery.parseJSON(jsonString);
     for(var i=0;i<mPatMonScopeListObj.length;i++){
	     $('input[name='+mPatMonScopeListObj[i].monScopeID+']').attr("checked", true);
     }
}

/// 加载病人监护项目[标准]
function LoadPatMonItemList(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getPatMonItemList',
		data: {monId:monId},
		success:function(jsonString){
			setPatMonItemList(jsonString);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
}

/// 病人监护项目
function setPatMonItemList(jsonString){
	var mPatMonItemListObj = jQuery.parseJSON(jsonString);
    for(var i=0;i<mPatMonItemListObj.length;i++){
	    $('input[name='+mPatMonItemListObj[i].monItemID+']').val(mPatMonItemListObj[i].monItemVal);
    }
}

/// 提交保存
function save(){
	
	/// 监护范围列表
	var LevScopeArr=[];
	$("#m_LevScope input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
			if(this.value!="on"){
          		LevScopeArr.push(this.value);
			}
		}	
	}); 
	LevScopeList=LevScopeArr.join("||");
	if(LevScopeList == ""){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;">请填写相关纳入指标！</font>','warning');
		return;
	}

	///监护项目列表	
	var LevItemArr=[];
	$("#m_LevItem input").each(function(){
		if(($(this).val() != "")&&(this.name!="CheckBoxClass")){
			LevItemArr.push(this.name+"^"+$(this).val());
		}
	});

	LevItemList=LevItemArr.join("||");
	if(LevItemList == ""){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;">请填写病人生命体征！</font>','warning');
		return;
	}

	var ImpMonItems=$("#ImpMonItems").val();       ///重要化验结果
	if((ImpMonItems=="编辑内容...")||(ImpMonItems=="")){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;">请填写病人相关化验结果！</font>','warning');
		return;
		}
	var ImpMonContent=$("#ImpMonContent").val();   ///病情转归情况
	if((ImpMonContent=="编辑内容...")||(ImpMonContent=="")){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;">请填写病人病情转归情况！</font>','warning');
		return;
		}

	//药学监护主信息
	var monMainList=monLevId+"^"+monAdmID+"^"+monWardID+"^"+monLocID+"^"+LgUserID+"^"+ImpMonContent+"^"+ImpMonItems;
	var monMInfoList=monMainList+"!!"+LevScopeList+"!!"+LevItemList+"!!"+"";

	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=saveMedMonInfo',//提交到那里  
		data: "monID="+monID+"&param="+monMInfoList,//提交的参数  
		success:function(jsonString){
			var mjsonObj = jQuery.parseJSON(jsonString);
			if(mjsonObj[0].ErrCode == 0){
				alert("保存成功");
			}else{           
				alert("保存错误,错误代码:"+mjsonObj[0].ErrCode);
			} 
			window.parent.loadParWin();  //调用父框架的方法，进行刷新      
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
}


/*控制检查文本框textarea的长度*/
function textCounter(field, countfield, maxlimit) {  
   // 函数，3个参数，表单名字，表单域元素名，限制字符； 
   if (field.value.length > maxlimit){  
       //如果元素区字符数大于最大字符数，按照最大字符数截断；  
   	   field.value = field.value.substring(0, maxlimit); 
   }else{
       //在记数区文本框内显示剩余的字符数；  
       countfield.value = maxlimit - field.value.length;  
   }
}
function textCounterNew(){
	var maxlimit=800
	var guidecon=$("#ImpMonContent").val()
	var rem=0
	if (guidecon.length > maxlimit){  
       //如果元素区字符数大于最大字符数，按照最大字符数截断；  
   	   guidecon = guidecon.substring(0, maxlimit); 
   }else{
       //在记数区文本框内显示剩余的字符数；  
       rem = maxlimit - guidecon.length;  
   }
   $("#remLen2").val(rem)
	}
/// 特殊控制
function SpecControlInputShow(){
	if((monLevId == "1")&(monSubClassId == "8")){
		$('#ImpMonContent').val("营养方案：总液量：ml、总能量：kcal、NPC：kcal 、渗透压：mOsm/L、葡萄糖：g、脂肪：g、氨基酸：g、氯化钾：g、氯化钠：g、PN途径(PICC、外周静脉、CVC 、输液港)：");
	}
	if((monLevId == "2")&(monSubClassId == "8")){
		$('#ImpMonContent').val("营养方案：总液量：ml、总能量：kcal、葡萄糖： g、脂肪： g、氨基酸：g、EN途径(经口、鼻胃管、鼻空肠管、PEG/PEJ):、每日用量:ml/日、(供能:kcal/日)、速度:ml/小时、输注方式(经口饮入、重力滴注、泵入): ");
	}
}