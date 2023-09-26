 
 /// 药学监护编辑
 var url="dhcpha.clinical.action.csp";
 var monLevId="";  //监护级别
 var monLevelDesc="" //监护级别描述
 var monAdmID="";
 var monSubClassId=""; //学科分类
 var monId="";         //监护ID
 var monIndex="";
 var NOW_TREE_SELECT_ID = "";
 $(function(){
	 monAdmID=getParam("monAdmID");
	 monSubClassId=getParam("monSubClassId");
	 monLevelDesc=getParam("monLevelDesc");
	 monLevelDesc=unescape(monLevelDesc)
	 if(monLevelDesc.indexOf("@")){
		monLevelDesc = "<font color="+ monLevelDesc.split("@")[1] +">"+monLevelDesc.split("@")[0]+"</font>"; 
	 }
	 LoadPatMonList();
 	 InitUI();
 	 $('a:contains("保存")').bind("click",save);  //提交
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
 function setMonItem(note){
     note = "[符合一项即为"+ note +"]";
	 $('span.ui-font12:contains("符合")').html(note);	 
 }
 /// 加载监护范围
 function LoadMonScope(){
	 $.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=getMonScopeList',//提交到那里 后他的服务  
		data: {monSubClassId:monSubClassId, monLevId:monLevId}, //提交的参数  
		success:function(jsonString){
			createLevScope(jsonString);      
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); 
 }
 
 /// 加载监护项目
 function LoadMonItem(){
	 createLevItm(monSubClassId); 
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
			textCounterNew();
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
 }
 
 ///  动态加载监护范围数据列表
 function createLevScope(jsonString){
	 var mLevScopeListObj = jQuery.parseJSON(jsonString);
	 var tmpArr=[];
     var htmlls = '<div><table>';
     for(var i=0;i<mLevScopeListObj.length;i++){
	    var extFlag=0;
	    for(var n = 0;n < tmpArr.length; n++){
		    if(tmpArr[n] == mLevScopeListObj[i].PHMSCRowID){
			    extFlag=1;
			}
		}
		if (extFlag==0) {	  //不重复加载相同的学科分类
			tmpArr.push(mLevScopeListObj[i].PHMSCRowID);	
			htmlls += '<tr>';		//加载学科分类
			htmlls += '<td><input id="'+mLevScopeListObj[i].PHMSCRowID+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevScopeListObj[i].PHMSCDesc+' </td>';     	
			htmlls += ' </tr>';
		} 
		htmlls += '<tr style=" class="'+mLevScopeListObj[i].PHMSCRowID+'">';				//加载纳入标准
		htmlls += '<td><input type="checkbox" class="cb" style="margin-left:40px" name="'+mLevScopeListObj[i].monScopeID+'" />'+mLevScopeListObj[i].monScopeDesc+'</td>';     	
		htmlls += '</tr>';	
	 }
	 htmlls += "</table></div>";
	 $('#m_LevScope').append(htmlls);  
     $("div[id='mainpanel']").css('overflow','auto');  //解决滚动条不能自动加载问题
     LoadPatMonScopeList();
     LoadPatMonItemList();
     LoadMonImpLabsAndGuidCon();
 }

 ///动态加载监护项目数据列表
  function createLevItm(monSubClassId){  
	   runClassMethod("web.DHCSTPHCMPHARCAREMAIN","GetScopeDescList",{"classId":monSubClassId},function(jsonString){	
	 	if (jsonString != ""){		
			$.each(jsonString,function(index,obj){
				var htmls = "";
				 htmls = htmls + '<div> <input id="'+obj.classDesc+'" class="cblevel" type="checkbox" name="CheckBoxClass" />'+obj.classDesc+' ';  
				 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","getMonItemListNew",{"classId":obj.classId,"monLevelId":monLevId},function(jsonObj){			
					if (jsonObj != ""){
						htmls = htmls + '<table style="margin-left:20px; ">';
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
  
/// 加载病人监护列表
function LoadPatMonList(){
	$('#m_PatMonList').treegrid({
		idField:'id', 
	    treeField:'text',
	    fit:true,
	    url: url+'?action=getPatMonList&monLevId='+monLevId+'&AdmDr='+monAdmID,
	    columns:[[    
	        {title:'id',field:'id',width:80,hidden:true},    
	        {field:'text',title:'监护级别',width:250},
	        {field:'monLevId',title:'monLevId',hidden:true},
	        {field:'monId',title:'monId',hidden:true},
	        {field:'_parentId',title:'parentId',hidden:true}
	    ]],
	    onSelect: function(row){
		    if(!(row.id>0)){
			    $(this).treegrid('select', NOW_TREE_SELECT_ID);
			    return;
			}
			if(NOW_TREE_SELECT_ID === row.id){
				return;
			}
		    NOW_TREE_SELECT_ID = row.id;
		    monLevId = row.monLevId;
		 	monId = row.monId;
		 	clrMonUI();
		 	LoadMonScope();
	 	 	LoadMonItem();
	 	 	var parentData = $(this).treegrid('getParent',row.id);
	 	 	var tmpNote = "<font color='" + parentData.color +"'>" + parentData.text +"</font>"
	 	 	setMonItem(tmpNote);
		},
		onLoadSuccess: function(row, data){
			$(this).treegrid('select', data.rows[1].id);
		},
		rowStyler: function(row){
			var color;
			if (row.color){
				color = row.color;
			}
			//else if (row._parentId){	//整体行变色
			//	color = $(this).treegrid('getParent',row.id).color;
			//}
			if (color){
				return 'color:' + color; 
			}
		}
	});	
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
	var LevScopeArr=[];LevScopeList="";
	$("#m_LevScope div input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	LevScopeArr.push(this.name);
		}	
	});
	LevScopeList=LevScopeArr.join("||");
	if(LevScopeList == ""){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;">请填写相关纳入指标！</font>','warning');
		return;
	}

	///监护项目列表	
	var LevItemArr=[];LevItemList="";
	$("#m_LevItem tr input").each(function(){
		if($(this).val() != ""){
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
	var monMainList="^^^^^"+ImpMonContent+"^"+ImpMonItems;
	var monMInfoList=monMainList+"!!"+LevScopeList+"!!"+LevItemList;

	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=saveMedMonInfo',//提交到那里  
		data: "monID="+monId+"&param="+monMInfoList,//提交的参数  
		success:function(jsonString){
			var mjsonObj = jQuery.parseJSON(jsonString);
			if(mjsonObj[0].ErrCode == 0){
				alert("保存成功");
			}else{           
				alert("保存错误,错误代码:"+mjsonObj[0].ErrCode);
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
}

function clrMonUI(){
	/// 监护范围列表
	$("#m_LevScope").html("");
	///监护项目列表	
	$("#m_LevItem").html("");
	$("#ImpMonItems").val(""); ///检验检查
	$("#ImpMonContent").val("");   ///重要化验结果
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