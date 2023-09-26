/*
Creator:pengzhikun
CreatDate:2014-08-20
Description:用药咨询-->可回复问题
*/
var url='dhcpha.clinical.action.csp' ;
var phrid="";
var phdelrid="";
function BodyLoadHandler()
{
	loadQuestioningData();
}
       
function loadQuestioningData(){
	
	$('#questioningGrid').datagrid({  
		border:false,
		url:url+'?actiontype=FindQuestioning',
		rownumbers:true,
		striped: true,
		pageList : [10, 20, 30],   // 可以设置每页记录条数的列表
		pageSize : 10 ,  // 每页显示的记录条数
		fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		fit: true,
		loadMsg: '正在加载信息...',
		singleSelect:true,
		columns:[[     
			{field:'askdate',title:'咨询日期',width:40},   
			{field:'questionkinds',title:'问题类型',width:60},
			{field:'drugs',title:'药品组合',width:160,formatter:function(value,data,index){
					//'showWin("+rowData.detailinfo+")'
					return format(value);
				}
			},
			{field:'role',title:'咨询人身份',width:40},
			{field:'personname',title:'咨询人姓名',width:40},  
			{field:'question',title:'咨询问题',width:80},
			{field:'detailinfo',title:'操作',width:40,formatter:function(value,data,index){
				     //'showWin("+rowData.detailinfo+")'
					return "<a href='#' style='text-decoration:none' onclick='showAnswerWin("+index+")'>"+value+"</a>";
				}
			} 
		]],
		 pagination: true
		
		//queryParams: {
			//action:'FindResults'
			//input:""
		//}

	});
	
	//设置分页控件   
	$('#questioningGrid').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '第',//页数文本框前显示的汉字 
		afterPageText: '页    共 {pages} 页',   
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
	
			
}

function format(value){
	var valueArr=value.split(",");
	var str="<div style='padding:5px'>";
	for(var i=0;i<valueArr.length-1;i++){
		str=str+"<span>"+value.split(",")[i]+"</span>"+"<br\>"
	}
	str=str+"<span>"+value.split(",")[valueArr.length-1]+"</span>"+"</div>";
	return str;
	
	
}

///回复
///显示窗口 formatter="SetCellUrl"
function showAnswerWin(index)
{	
	var id=$('#allAnswer2');
	removeAllAnswer(id);
	//获取datagrid加载的json数据
	var d = $('#questioningGrid').datagrid("getData");
	var detail=d.rows;
	
	phrid=detail[index].rowid;
	
	if(detail[index].role=="医生/护士"){
		$('#patname').html("");
		$('#patphoneNumber').html("");
		$('#gender').html("");
		$('#patage').html("");
		$('#specicalPop').html("");
		$('#chronicDiseases').html("");
		$('#patremarks').html("");
		
		$('#DetailWinDocName').html(detail[index].personname);
		$('#DetailWinCtlocName').html(detail[index].ctloc);
	}else if(detail[index].role=="患者/家属"){
		$('#DetailWinDocName').html("");
		$('#DetailWinCtlocName').html("");
		
		$('#patname').html(detail[index].personname);
		$('#patphoneNumber').html(detail[index].patTel);
		$('#gender').html(detail[index].patSex);
		var ages=calAges(detail[index].patDob);
		if(ages!=""){
				var year=ages.split("-")[0];
				var month=ages.split("-")[1];
				if(year!=""){
					$('#patage').html(year+"岁");
				}else{
					if(month=0){
						//不足一个月的按一个月显示
						$('#patage').html(1+"月");
					}else{
						$('#patage').html(month+"月");
					}
				}
			}
		$('#specicalPop').html(detail[index].speCrowd);
		$('#chronicDiseases').html(detail[index].chrDisease);
		$('#patremarks').html(detail[index].remark);
		
	}
	
	$('#ResWinQuestion').html(detail[index].questionkinds);
	$('#ResWinResRelativeDrugs').html(detail[index].drugs);
	$('#ResWinQuestionDesc').html(detail[index].question+"?")
	getResAnswer(phrid);
	//createPopResWin(); //调用窗体
}

//通过出生日期计算年龄 str="1989-08-08"
function calAges(str)   
  {   
        var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);     
        if(r==null)return   false;     
        var d = new Date(r[1],r[3]-1,r[4]);     
        if(d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4])   
        {   
             var Y =new Date().getFullYear();
	      	 var M =new Date().getMonth();  
	      	 //(Y-r[1])年   (M-r[3]+1)月
             return((Y-r[1])+"-"+(M-r[3]+1));   
        }   
        return "";   
  }

function getResAnswer(phrid){
	$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=getAllAnswer',//提交到那里 后他的服务  
			data: "input="+phrid,//提交的参数  
			success:function(msg){            
				//alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				//$('#ResWinAnswer').val("");
				//$('#popResWindow').window('close');
				//alert(msg)
				createPopResWin(msg);       
			},    
			error:function(){        
				alert("获取数据失败!");
			}
		}); 
}

function createPopResWin(msg){
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	for(var i=0;i<arrayJson.length;i++){
		
		
		//
		var mydivWrap=$('<div></div>')
		mydivWrap.attr('id','wraper'+i);
		mydivWrap.css('border-style','solid solid none');
		mydivWrap.css('border-color','#CCC  #CCC');
		
		//header
		var mydivHeader=$('<div></div>');
		mydivHeader.css('background-color','#EFEFEF');
		mydivHeader.css('line-height','25px');
		mydivHeader.attr('id','answer'+i);
		$('<span />',{
			text:i+1+"楼",
			"class":"header"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:'回复人:',
			"class":"answerer"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].username,
			"class":"name"
		}).appendTo(mydivHeader);
		
		if(arrayJson[i].ansUsername !=""){
			$('<span />',{
				text:'被回复人:',
				"class":"answerer1"
			}).appendTo(mydivHeader);
		
			$('<span />',{
				text:arrayJson[i].ansUsername,
				"class":"name1"
			}).appendTo(mydivHeader);
		}
		
		$('<span />',{
			text:'回复于:',
			"class":"answered"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].answerDate,
			"class":"date"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].answerTime,
			"class":"time"
		}).appendTo(mydivHeader);
		
		
		
		//content
		var mydivContent=$('<div></div>');
		mydivContent.css('background-color','#F4F4F4');
		mydivContent.css('height','20px');
		
		$('<span />',{
			text:arrayJson[i].answer,
			"class":"content"
		}).appendTo(mydivContent);
		
		if(arrayJson[i].basList!=""){
			$('<span />',{
				text:"["+"参考："+arrayJson[i].basList+"]",
				style:'color:#CCCCCC'
			}).appendTo(mydivContent);
		}
		
		//footer
		var mydivFooter=$('<div></div>');
		mydivFooter.css('background-color','#F4F4F4');
		//mydivFooter.css('height','20px');
		mydivFooter.attr('id','foot');
			
		
		$('<a />',{
			text:arrayJson[i].detailRid,
			href:'#',
			"class":"rowid",
			click:function(){
				//alert(arrayJson[i].detailRid);
			}
			
		}).appendTo(mydivFooter);
		
		
		$('<a />',{
			text:'标答',
			href:'#',
			"class":"ah",
			click:function(){
				
				var DetailRowid=$(this).parent().children(".rowid").text();
				//标答
				setOkFlag(DetailRowid);
				
			}
			
		}).appendTo(mydivFooter);
		
		
		
		$('<span />',{
			text:'|'
		}).appendTo(mydivFooter);
		
		
		$('<a />',{
			text:'回复....',
			"class":"ah",
			href:'#',
			click:function(){
				$('#ResWinAnswer').focus();
				//alert($(this).parent().children(".rowid").text());
				phdelrid=$(this).parent().children(".rowid").text();
			}
			
		}).appendTo(mydivFooter);
		
		
		$(mydivHeader).appendTo(mydivWrap);
		$(mydivContent).appendTo(mydivWrap);
		$(mydivFooter).appendTo(mydivWrap);
		
		$(mydivWrap).appendTo('#allAnswer2');

	}
	
	//获取回复依据列表,并动态显示显示
	getConBas();
			
	$('#popResWindow').css("display","block");
	$('#popResWindow').window({
		width:900,
		height:600,
		modal:true
	})
	
}

function setOkFlag(DetailRowid){
	$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=SetOkFlag',//提交到那里 后他的服务  
			data: "input="+DetailRowid,//提交的参数  
			success:function(msg){            
				//alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				//showConBasList(msg);
				if(msg==-1){
					alert("已经有标准答案！！");
				}else if(msg==0){
					alert("生成标准答案！！");
				}else{
					alert("生成标准答案失败！！");
				}       
			},    
			error:function(){        
				alert("获取数据失败!");
			}
	}); 		
}


//获取回复依据列表,并动态显示显示
function getConBas(){
	$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=GetConBas',//提交到那里 后他的服务  
			//data: "input="+input,//提交的参数  
			success:function(msg){            
				//alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				showConBasList(msg);       
			},    
			error:function(){        
				alert("获取数据失败!");
			}
		}); 
}

function showConBasList(msg){
	var id=$('#footdiv');
	removeAllAnswer(id);
	var obj = eval( "(" + msg + ")" ); //转换后的JSON对象
	var arrayJson=obj.rows;
	$('<label />',{
		text:'回复依据：',
		style:"background-color:#CCCCFF"
	}).appendTo('#footdiv');
	
	for(var i=0;i<arrayJson.length;i++){
		$('<input />',{
			type:"checkbox",
			value:arrayJson[i].rowid
		}).insertBefore($('<label />',{text:arrayJson[i].PhContBDesc}).appendTo('#footdiv'));
	}
}


function removeAllAnswer(id){
	id.children().remove();
}

///提交回复
function submitAnswer(){
	var userId=session['LOGON.USERID'];
	var questionDesp=$('#ResWinAnswer').val().trim();
	var inputs=$("#footdiv input");
	var ckValueList="";
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].checked==true){
			//alert(inputs[i].value)
			ckValueList+=inputs[i].value+"||"
		}		
	}
	
	//ckValueList="1||2||",如果不为空，将其转化为"1,2"
	if(ckValueList!=""){
		var length=ckValueList.split("||").length;
		ckValueList=ckValueList.split("||",length-1);
	}
	//alert(ckValueList);
	if(questionDesp==""){
		alert("请输入回复");
	}else{
		var input=phrid+"^"+userId+"^"+questionDesp+"^"+phdelrid+"^"+ckValueList;
		$.ajax({  
			type: 'POST',//提交方式 post 或者get  
			url: url+'?actiontype=submitAnswer',//提交到那里 后他的服务  
			data: "input="+input,//提交的参数  
			success:function(){            
				alert("保存成功");//弹出窗口，这里的msg 参数 就是访问aaaa.action 后 后台给的参数
				$('#ResWinAnswer').val("");
				$('#popResWindow').window('close');         
			},    
			error:function(){        
				alert("保存失败");
			}
		}); 
	}
}

//过滤掉输入文本信息中空格
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}


					  
