/// Creator:bianshuai
/// CreateDate:014-09-09
/// Descript:用药建议书写界面
var url='dhcpha.clinical.action.csp' ;
var AdmDr="";
var AppType="";
var orditm=""
$(function(){
	AdmDr=getParam("EpisodeID");
	AppType=getParam("AppType");
	ORditm=getParam("ORditm");
	InitPatInfo(); 			//初始化病人基本信息
	InitPatMedGrid();  		//初始化病人用药列表
	//AutoLoadMedInfo(AdmDr); //加载病人医嘱信息
	LoadPatAdviceList();
	InitMedAdvList();  		//初始化建议模板列表
	
	$('div[name=list]').live("click",function(){
		$('#'+this.id).css('background','#ADFAFC').siblings().css("background","");
		$('#AdvID').html(this.id);
	})
	
	$('#textarea').bind("focus",function(){
		if(this.value=="请输入建议信息..."){
			$('#textarea').val("");
		}
	});
	
	$('#textarea').bind("blur",function(){
		if(this.value==""){
			$('#textarea').val("请输入建议信息...");
		}
	});
	
	$('#Quote').bind("click",createSuggestWin);     //引用模板
	$('#Sure').bind("click",sureAddMedAdvDetail);   //确认
	$('#Del').bind("click",delMedAdvDetail);        //删除
	$('#Main').bind("click",medAdvTemp); //模板维护
	$("#Btn_Lab").bind("click", function(){  //引用检验
	 	 createLabDetailView(qouteLabResult);
	 });
	
	$('#textarea').css({width:'99%'})
});
function qouteLabResult(addTxt){
	 var text = $("#textarea").val();
	 $('#textarea').val("");
	 if(text=="请输入建议信息...") {
		 $("#textarea").val(addTxt);
	 }else{
		 $("#textarea").val(text +" "+ addTxt);
	 }
} 

//加载用药信息
function AutoLoadMedInfo(AdmDr)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOrdItmInfo',	
		queryParams:{
			params:AdmDr}
	});
}

//病人基本信息区
//加载患者信息
//nisijia 2016-09-22
function InitPatInfo()
{
	$.ajax({ 
        type: "POST", 
        url: 'dhcpha.clinical.action.csp', 
        data: "action=GetPatEssInfo&EpisodeID="+AdmDr, 
        error: function (XMLHttpRequest, textStatus, errorThrown){
        }, 
        success: function (data){
	        var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	        if(retVal!=""){
            	SetPatientInfo(retVal);
	        }
        } 
        
    });
}

//设置患者信息
//nisijia  2016-09-22
function SetPatientInfo(patientInfo) {
	var adrRepObj = jQuery.parseJSON(patientInfo);	
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spancolorleft">登记号:</span> <span class="spancolor">'
			+ adrRepObj.medicalNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">床号:</span><span class="spancolor">'
			+ adrRepObj.admbed + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">姓名:</span> <span class="spancolor">'
			+ adrRepObj.patname + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">性别:</span> <span class="spancolor">'
			+ adrRepObj.patsex + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">年龄:</span> <span class="spancolor">'
			+ adrRepObj.patage + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">付费方式:</span><span class="spancolor">'
			+ adrRepObj.paytype + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">入院日期:</span> <span class="spancolor">'
			+ adrRepObj.admdate + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">诊断:</span> <span class="spancolor">'
			+ adrRepObj.patdiag + '</span>';
	$('#patInfo').append(htmlStr);
	jQuery(".patInfo").css("display", "inline-block");
	jQuery(".tool-disease").css("display", "block");
}

//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:'Pri',title:'优先级',width:60},
		{field:"orditm",title:'医嘱ID',width:90,hidden:true},
		{field:'MedName',title:'名称',width:200},
		{field:'StartDate',title:'开始日期',width:80},
		{field:'EndDate',title:'结束日期',width:80},
		{field:'Dosage',title:'剂量',width:80},
		{field:'Instance',title:'用法',width:80},
		{field:'freq',title:'频次',width:80},
		{field:'duration',title:'疗程',width:80},
		{field:'Doctor',title:'医生',width:80},
		{field:'OeFlag',title:'OeFlag',width:80,hidden:true},
		{field:'doctorID',title:'doctorID',width:80,hidden:true},
		{field:'execStat',title:'是否执行',width:80},		/// 增加执行和发药 qunianpeng 2018/3/12
		{field:'sendStat',title:'是否发药',width:80},
		{field:'orderbak',title:'医嘱备注',width:80}

	]];
	var allFlag = $("#chk-all").is(':checked');
	//定义datagrid
	$('#medInfo').datagrid({
		//title:'医嘱信息列表', 
		url:url+'?action=GetPatOrdItmInfoNew&AdmDr='+AdmDr+"&AppType=''&AllFlag="+allFlag,
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,           // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onLoadSuccess:function(){
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==ORditm){
					$('#medInfo').datagrid('selectRow',index);
				}
				else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				});
		},
		rowStyler:function(index,row){
			if ((row.OeFlag=="D")||(row.OeFlag=="C")){
				return 'background-color:pink;';
			}
		},
		onClickRow:function(rowIndex, rowData){
			var flag=0;
			///获取当前行是否选中
			if($('tr[datagrid-row-index='+rowIndex+']').hasClass('datagrid-row-checked')){
				var flag=1;
			}

			///一组医嘱同时选择
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==rowData.moeori){
					if(flag==1){
						$('#medInfo').datagrid('selectRow',index);
					}else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				}
			})
		}
	});
	
	initScroll();//初始化显示横向滚动条
	$('#medInfo').datagrid('loadData',{total:0,rows:[]});
}

// 加入TextArea
function addOrdInfo()
{
	var d=$('#medInfo').datagrid("getData");
	var detail=d.rows;
	var doctorID="";
	$('#ordstr').html("");	
	var ordstr=[];
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems=="")    //qunianpeng 2016-09-08
	{
		$.messager.alert('错误提示',"请选择医嘱！");
		return;		
	}
    $.each(checkedItems, function(index, item){
		ordstr.push(item.orditm);
		doctorID=item.doctorID;
    })
    $('#ordstr').html(ordstr.join(","));
    AddToAdviceList(ordstr.join(","),doctorID);
}

/// 默认显示横向滚动条
function initScroll(){
	var opts=$('#medInfo').datagrid('options');    
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
			if((typeof opts.columns[i][j].field)=='undefined')break;    
			text+="'"+opts.columns[i][j].field+"':''";    
			if(j!=inner_len-1){    
				text+=",";    
			}    
		}    
	}    
	text+="}";    
	text=eval("("+text+")");    
	var data={"total":1,"rows":[text]};    
	$('#medInfo').datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}

/// 获取参数
function getParam(paramName)
{
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1)
    {
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound)
        {
            if (arrSource[i].indexOf("=") > 0)
            {
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase())
                 {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

///保存用药建议
function AddToAdviceList(medAdvDrgItmList,doctorID)
{
	var AdvID="";  //$('#AdvID').html();     	/// 用药建议ID
	var UserID=LgUserID;                     	/// 用户ID
	var dataList=AdmDr+"^"+UserID+"^"+doctorID; /// 主信息
	//var medAdvDetailList=$('#textarea').val();/// 用药建议
	//medAdvDetailList=UserID+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //去掉标示字符

	//dataList=dataList+"!"+medAdvDrgItmList+"!"+medAdvDetailList;
	dataList=dataList+"!"+medAdvDrgItmList;
	
	var data=jQuery.param({"action":"SaveMedAdvMaster","AdvID":AdvID,"dataList":dataList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (val) {
	        var AdvID=val;
	        $('#AdvID').html(AdvID);
	    	LoadAdviceList(AdvID);  //加载信息
	    }
    });
}

function LoadAdviceList(AdvID)
{
	//获取建议信息
 	 $.post(url,{action:"getPatMedAdvInfo",AdvID:AdvID},function(data,status){
	     var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	     if(retVal!=""){
			InitAdivisesPanel(retVal,AdvID);
	     }
     });
}
function LoadAdviceLists(AdvID)
{
	//获取建议信息
	$.ajax({
        type:"POST",
        url:url,
        async:false,
        data:{action:"getPatMedAdvInfo",AdvID:AdvID},
        dataType:"text",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (data) {
	         var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	         if(retVal!=""){
			InitAdivisesPanel(retVal,AdvID);
	     }
	    }
    });
 	var advises='<a name='+'"'+AdvID+'"'+'></a>';
	$('#Adivises').append(advises);
}

///加载建议信息
function InitAdivisesPanel(retVal,AdvIDrtn)
{
	var htmlstr="";
	var medAdvDataArr=retVal.split("!");
	var AdvID=medAdvDataArr[0];             //RwoID
	var medAdvMasDateStr=medAdvDataArr[1];  //用药建议主信息
	var medAdvDrgItmStr=medAdvDataArr[2];   //医嘱信息
	var medAdvContentStr=medAdvDataArr[3];  //建议信息
	
	//主信息
	var medAdvMasArr=medAdvMasDateStr.split("^");
	if(AdvID==AdvIDrtn)
	htmlstr=htmlstr+"<div style='border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #ADFAFC;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' name=list id="+AdvID+" >"
	else
	htmlstr=htmlstr+"<div style='border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #FFFFFF;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' name=list id="+AdvID+" >"	
	htmlstr=htmlstr+"<span style='font-weight:bold;'>有效期："+medAdvMasArr[0]+"</span><span style='font-weight:bold;'>至"+medAdvMasArr[1]+"</span><span style='font-weight:bold;margin-left:30px;color:red;'>"+medAdvMasArr[2]+"</span>"
	htmlstr=htmlstr+"<br>"
	//医嘱
	htmlstr=htmlstr+"<span style='font-weight:bold;'>原医嘱:</span>";
	htmlstr=htmlstr+"<br>"
	var medAdvDrgItmArr=medAdvDrgItmStr.split("||");
	for(var k=0;k<medAdvDrgItmArr.length;k++)
	{
		htmlstr=htmlstr+"<span style='margin-left:30px;'>"+medAdvDrgItmArr[k]+"</span>"
		htmlstr=htmlstr+"<br>"
	}
	//建议
	var medAdvContentArr=medAdvContentStr.split("||");
	htmlstr=htmlstr+"<span style='font-weight:bold;'>用药建议:</span>"
	htmlstr=htmlstr+"<br>"
	for(var k=0;k<medAdvContentArr.length;k++)
	{
		if(medAdvContentArr[k]!=""){
			htmlstr=htmlstr+"<span style='margin-left:30px;'>"+(k+1)+"、"+medAdvContentArr[k]+"</span>"
			htmlstr=htmlstr+"<br>";
		}
	}
	htmlstr=htmlstr+"<span style='margin-left:300px;font-weight:bold;'>药师："+medAdvMasArr[3]+"</span><span style='margin-left:20px;font-weight:bold;'>"+medAdvMasArr[0]+"</span>"
	htmlstr=htmlstr+"</div>";
	
	$('#Adivises').append(htmlstr);
}

///保存用药建议
function sureAddMedAdvDetail()
{
	var medAdvDetailList=$('#textarea').val(); //用药建议
	if((medAdvDetailList=="请输入建议信息...")||(medAdvDetailList=="")){  //wangxuejian 2016-09-27
		$.messager.alert("提示","请先输入意见,再进行提交！");
		return;
	}

	var AdvID=$('#AdvID').html();  //获取当前选择建议AdvID
        if (AdvID==""){
		$.messager.alert("提示","请选择药品！");  //赵武强   2016-09-07
		return;
		}
	$('#'+AdvID).remove();
	var UserID=LgUserID; //session['LOGON.USERID']; //用户ID

	var curStatus="10";  //提意状态   zhaowuqiang  2016/09/26 //cancel annotate by qnp
	//medAdvDetailList=UserID+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //去掉标示字符
	medAdvDetailList=UserID+"^"+curStatus+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //去掉标示字符
	var data=jQuery.param({"action":"SaveMedAdvDetail","AdvID":AdvID,"dataList":medAdvDetailList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (val) {
	        $('#AdvID').html(AdvID);
	    	LoadAdviceLists(AdvID);    //加载信息
	    	$('#textarea').val("");   //清空textarea内容
			location.hash=AdvID;
			$('#medAdvWin').css('display','none');	// 提交建议后 加载个人建议模板的div被显示  手动隐藏  qunianpeng 2018/3/21
	    }
    });
}

///加载病人用药建议列表
function LoadPatAdviceList()
{
	if (AdmDr==""){return;}
	$.ajax({ 
        type: "POST", 
        url: "dhcpha.clinical.action.csp",
        async:false,
        //新增评论人科室字段userLocCode 
        data:{action:"getPatAdviceList",AdmDr:AdmDr},
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
          var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		  if(retVal!=""){
			var medAdvPatAdvArr=retVal.split("#");
			for(var m=0;m<medAdvPatAdvArr.length;m++){
				InitAdivisesPanel(medAdvPatAdvArr[m]); //逐条加载
			}
		  var advises='<a name='+'"goend"'+'></a>';
	      $('#Adivises').append(advises);
	      location.hash="goend";
	        }
        } 
    });
}

/// 删除用药建议
function delMedAdvDetail()
{
	var AdvID=$('#AdvID').html();  //获取当前选择建议AdvID
	if (AdvID==""){
		$.messager.alert("提示","请选择要删除的记录！");
		return;
	}
	$.post("dhcpha.clinical.action.csp",{action:"delPatMedAdv",AdvID:AdvID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+AdvID).remove();
			$.messager.alert("提示","删除成功！","info");
		}else if(retVal=="-1"){
			$.messager.alert("提示","建议不存在！","error");
		}else if(retVal=="-2"){
			$.messager.alert("提示","医生已回复,不能删除！","error");
		}
	});
}

///初始化建议模板列表
function InitMedAdvList()
{
	///定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:'代码',width:100},
		{field:'Desc',title:'描述',width:200},
	]];
	
	///定义datagrid
	$('#medAdvdg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if($('#textarea').val()=="请输入建议信息..."){
				$('#textarea').val("").val(tmpDesc);
			}else{
				$('#textarea').val($('#textarea').val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
		}
	});
	
	//initScroll();//初始化显示横向滚动条
}

// 建议引用窗口
function createSuggestWin()
{
	$('#medAdvWin').css('display','');  // 加载个人建议模板的div显示 qunianpeng 2018/3/21
	$('#medAdvWin').window({
		title:'建议列表',    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:400,
		minimizable:false						/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true						/// 最大化

	});

	$('#medAdvWin').window('open');
	
	///自动加载建议字典
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',
		queryParams:{
			params:LgCtLocID+"^"+LgUserID
		}
	});
}

/// 用药建议模板维护
function medAdvTemp()
{
	$('#medAdvTempWin').window({
		title:'用药建议模板维护',    
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:400,
		minimizable:false						/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true						/// 最大化
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}

///加载病人用药列表
function LoadPatMedInfo(priCode,AppTypeCode)
{
	if(AppTypeCode!=""){AppTypeCode=AppType;}
	var allFlag = $("#chk-all").is(':checked');
	var priCode = $("input[type=radio]:checked").val();
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOrdItmInfoNew',	
		queryParams:{
			AdmDr:AdmDr,
			priCode:priCode,
			AppType:AppTypeCode,
			AllFlag: allFlag
		}
	});
initScroll("#medInfo");//初始化显示横向滚动条
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});  //加入初始化  nisijia 2016-09-07
}

