/*
* 医学查房
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;">药学关注点<span style="color:red;">[双击行即可编辑]</span></span>';
var EpisodeID=""
//var PatientID="";
//var AdmLocID="";
//PatientID=getParam("PatientID");	
//AdmLocID=getParam("AdmLocID"); 
$(document).ready(function(){
	
	EpisodeID=getParam("EpisodeID");
	
	InitPatientInfo(EpisodeID);		
	var rowid=$('#RowId').val();		/// 首次查房ID  qunianepng 2018/3/10
	var  panelTitle = "";	
	if(rowid == ""){					/// 首次查房已经填写过，则默认打开日常查房。否则，默认打开首次查房
		 panelTitle = "首次查房记录";	
		 $('.easyui-accordion ul li a:contains("首次查房记录")').css({"background":"#87CEFA"});
	}
	else{
		 panelTitle = "日常查房记录";
		 $('.easyui-accordion ul li a:contains("日常查房记录")').css({"background":"#87CEFA"});	
		
	}
	choseMenu(panelTitle);
	//根据点击明细显示窗口panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //点击侧菜单的显示相应界面
		 choseMenu(panelTitle);
	});
	
	var arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
	EpisodeID=arrSource[1].split("=")[1];	
	pageBasicControll();	
	initDataDG();	
	getPatObserInfo(EpisodeID);  //自动设置病人生命体征
})


function choseMenu(item){
	switch(item){
		case "首次查房记录":
			//防止重复点击，而此时Flag=1，导致不执行创建界面
			if(Flag1==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"新入院患者"的panel
				createPanel();
				//设置mainPanel可见
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[红色*号标注的为必填项]</span>"
				});
			}
			
			break;
			
		case "日常查房记录":
			if(Flag2==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createInHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[红色*号标注的为必填项]</span>"
				});
				//加载数据
				//loadData();
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--创建"首次查房记录"主界面--//
var Flag1=0;//防止重复点击，多次创建面板
function createPanel() {
	if(Flag1==0){
		//仅显示咨询主界面
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		InitPatientInfo(EpisodeID);	
	}
	InitNewPagePatInfo(EpisodeID)
}
function InitNewPagePatInfo(EpisodeID)
{ 
    if(EpisodeID==""){return;}
    $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatInfo',AdmDr:EpisodeID}, 
	        	success: function(val){ 
	        	if(val!=""){
		  	     var tmps=val.split("^");
		   		 $('#PatSex').val(tmps[2]);    		/// 性别
     		     $('#PatName').val(tmps[1]);    	/// 姓名
     		     $('#PatBed').val(tmps[4]);    		/// 床号
     		     $('#PatMedRec').val(tmps[0]);    	/// 登记号
	   		     $('#PatAge').val(tmps[3]);        ///年龄 
	   		     $('#PatPayType').val(tmps[6]);        ///费别
	        	}			
   	  		}		
   		});

}
function InitPatientInfo(){
  if(EpisodeID==""){return;}
	
   var cliPatID="";
   
   //获取新入院患者查房记录信息
   $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getMedWardInf&AdmDr="+EpisodeID+"&Status="+"First",
       //dataType: "json",
	   async:false,
       success: function(val){
	       var obj = eval( "(" + val + ")" );
	       if(obj.total==0){
		      //如果没有首次查房记录
		      //1.获取病人基本信息，加载诊断信息
   			  $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatEssInfo',EpisodeID:EpisodeID}, //nisijia 2016-09-08
   				//dataType: "json",
   				 //dataType: "json",
	        	success: function(jsonString){ 
	     		var adrRepObj = jQuery.parseJSON(jsonString);
		   		 $('#AdmInf').val(adrRepObj.patdiag);    //诊断		
   	  			}		
   			  });
   			  
   			  //2. 首次查房界面，加载用药信息(如果新入院患者
              //   医学查房记录中有用药信息，则直接加载)
              var wardRoundID="";
   			  //获取新入院患者查房记录信息
   			  $.ajax({
   	   			type: "POST",
  	   			url: url,
   	   			data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"New",
       			//dataType: "json",
       			success: function(val){
	      
	      			if(val!=-999){
		  				var tmps=val.split("!");
		  				var listMain=tmps[0].split("^"); //主信息
		  
		  				//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  				wardRoundID=tmps[8];
						if(wardRoundID!=""){
							$.ajax({
   	   							type: "POST",
  	   							url: url,
   	   							data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 				//dataType: "json",
       							success: function(val){
	       							var obj = eval( "(" + val + ")" );
	       							//只有当返回值有数据，才加载
	       							if(obj.total!=0){
	       								$('#drugdg').datagrid('loadData',obj);
	       							}	       				
       							}
							});							
			 			  }			 
	      			  }	      
       			  }            
			  });
			//主诉
			//var ChiefComplaint=tkMakeServerCall("web.DHCSTPHCMCOMMON","getPatPriAct",EpisodeID); qunianpeng 主诉从电子病历取2018/3/13			
			var patInfo=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatInfoByEmr",EpisodeID);
			var ChiefComplaint=patInfo.split("@");
			$('#ChiefComplaint').val(ChiefComplaint[0]);
			  
		   }else{
		   	   //已经存在了首次医学查房记录
		   	   var arrayJson=obj.rows;
		   	   arrayJson=arrayJson[0];//因为只有一条记录
		   	   //------对界面相关内容赋值
	           $('#Temperature').val(arrayJson.Temperature);//体温
	           $('#Pulse').val(arrayJson.Pulse);//脉搏
	           $('#Breath').val(arrayJson.Breath);//呼吸
	           $('#Heartrate').val(arrayJson.Heartrate);//心率
	           $('#Bloodpre').val(arrayJson.Bloodpre);//血压
	           $('#Urineamt').val(arrayJson.Urineamt);//尿量
	           //1、双肺呼吸音
	           $("input[type='checkbox'][name='DouLunBrePho']").each(function(){
					if($(this).val()==arrayJson.DouLunBrePho && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);    //初始化复选框的选择状态)(1-8)  sufan  2016/09/18
						//$(this).toggleClass('cb_active');
			   		}
			   });
	                   
			   //2、啰音
    		   $("input[type='checkbox'][name='Rale']").each(function(){
					if($(this).val()==arrayJson.Rale && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			  //3、心律
			  $("input[type='checkbox'][name='Arrhythmia']").each(function(){
					if($(this).val()==arrayJson.Arrhythmia && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
	         //4、各瓣膜听诊区、病理性杂音
	         $("input[type='checkbox'][name='PathMurmur']").each(function(){
					if($(this).val()==arrayJson.PathMurmur && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			 //5、腹部
			 $("input[type='checkbox'][name='Belly']").each(function(){
					if($(this).val()==arrayJson.Belly && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			 //6、肝脾肋下
			 $("input[type='checkbox'][name='LivLieCos']").each(function(){
					if($(this).val()==arrayJson.LivLieCos && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
	         //7、双肾区叩击痛
	         $("input[type='checkbox'][name='PerPain']").each(function(){
					if($(this).val()==arrayJson.PerPain && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			  //8、双下肢水肿
			  $("input[type='checkbox'][name='Oedema']").each(function(){
					if($(this).val()==arrayJson.Oedema && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
			  
	          //9、指导内容
	          $('#FirstMedWardGuideContent').val(arrayJson.Guidance);
	           var maxlimit=800;
		       if ($('#FirstMedWardGuideContent').val().length >maxlimit){  
                   $('#FirstMedWardGuideContent').val(($('#FirstMedWardGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen"]').val(maxlimit-$('#FirstMedWardGuideContent').val().length);
		       }
			  
			  //10.首次查房记录ID
			  $('#RowId').val(arrayJson.PHCPRid);
			  
			  //11、诊断
			  $('#AdmInf').val(arrayJson.Icd);
			  
			  //12、药品列表
			  var cliPatID=$('#RowId').val();
			  $.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getMRDrgItm&cliPatID="+cliPatID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#drugdg').datagrid('loadData',obj);
       				}
			  });
			  
			  //13、主诉
			  $.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getChiefComtItm&cliPatID="+cliPatID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				var arrayJson=obj.rows;
	       				var ChiefComt="";
	       				for(var i=0;i<arrayJson.length;i++){
		       				
		       				ChiefComt+="||"+arrayJson[i].preComText
		       			}
		       			ChiefComt=ChiefComt.substring(2,ChiefComt.length);
		       			$('#ChiefComplaint').val(ChiefComt);
       				}
			  });	     
		   }		   
       }       
    });  
  
}

//--创建"查房记录"主界面--//
var Flag2=0;//防止重复点击，多次创建面板
function createInHopPanel(){
	if(Flag2==0){
		//仅显示咨询主界面
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
	}
	InitPagePatInfo(EpisodeID)
}
function InitPagePatInfo(EpisodeID)
{ 
    if(EpisodeID==""){return;}
    $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatInfo',AdmDr:EpisodeID}, 
	        	success: function(val){ 
	        	if(val!=""){
		  	     var tmps=val.split("^");
		   		 $('#InPatSex').val(tmps[2]);    		/// 性别
     		     $('#InPatName').val(tmps[1]);    	/// 姓名
     		     $('#InPatBed').val(tmps[4]);    		/// 床号
     		     $('#InPatMedRec').val(tmps[0]);    	/// 登记号
	   		     $('#InPatAge').val(tmps[3]);        ///年龄 
	   		     $('#InPatPayType').val(tmps[6]);        ///费别
	        	}			
   	  		}		
   			  });

}
/**
* 界面上基本内容的显示控制
* 
* 1.每个界面"编辑内容.."，获取焦点、失去焦点，内容控制
*/
function pageBasicControll(){
	
	//复选框按钮事件
	$("input[type='checkbox']").each(function(){
		$(this).click(function(){
			$(this).toggleClass('cb_active');
		});
	});
	
	//复选框分组
	InitUIStatus();
	
	/*首次查房*/
	$('#FirstMedWardGuideContent').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#FirstMedWardGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
	
	/*查房记录*/
	$('#MedWardGuideContent').focus(function(){
		if($(this).text()=="编辑内容.."){
			$(this).text("");
		}
	})
	$('#MedWardGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("编辑内容..");
		}
	})
}


///初始化界面复选框事件
function InitUIStatus()
{
	var tmpid="";
	$("input[type='checkbox']").click(function(){   //sufan 2016/09/18
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}

//初始化界面datagrid显示
function initDataDG(){
	/*
	//定义columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
	    {field:'incidesc',title:'商品名称',width:300,align:'left'},
	    {field:'genenic',title:'通用名',width:300,align:'left'},
	    {field:'manf',title:'生产企业',width:300,align:'left'},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//定义datagrid
	$('#drugdg').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//行号 
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#drugdatagrid').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//行号 
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdatagrid").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	InitdatagridRow();
	*/
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// 删除行
function delRow(datagID,rowIndex)
{
	//行对象
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:''
	};
	
	//当前行数大于4,则删除，否则清空
	var selItem=$('#'+datagID).datagrid('getSelected');
	var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	var rows = $('#'+datagID).datagrid('getRows');
	if(rows.length>4){
		 $('#'+datagID).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+datagID).datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}
}

/// 病人药品窗口
function patOeInfoWindow()
{
	$('#mwin').window({
		title:'病人用药列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520
	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'名称',width:280},
		{field:'genenic',title:'通用名',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:80},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//定义datagrid
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		queryParams:{
			params:EpisodeID
		}
	});	
}

function addWatchDrg(){
	if(Flag1==1){
		var medWardRid=$('#RowId').val();
		//首次查房记录
		//用药列表
		var rows = $('#drugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//获取医嘱列表被勾选的行
		var checkedItems = $('#medInfo').datagrid('getChecked');
		/**
		*1.如果初始查房记录rowid不存在，则药品列表，显示为初始条目
		*2.如果查房记录rowid存在，则根据关注药品，在datagrid显示，通过reload方式
		*/
		if(medWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg'
				}
	    		if(k>3){
					$("#drugdg").datagrid('appendRow',rowobj);
				}else{
					$("#drugdg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
						index: k, // 行数从0开始计算
						row: rowobj
					});
				}
				k=k+1;
    		})
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg'
				}
				$("#drugdg").datagrid('appendRow',rowobj);
	   		});
	    }
    	//$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag2==1){
		//查房记录
		//用药列表
		var medWardRid=$('#MedPhaRid').val();
		var rows = $('#drugdatagrid').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//获取医嘱列表被勾选的行
		var checkedItems = $('#medInfo').datagrid('getChecked');
		/**
		*1.如果初始查房记录rowid不存在，则药品列表，显示为初始条目
		*2.如果查房记录rowid存在，则根据关注药品，在datagrid显示，通过reload方式
		*/
		if(medWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdatagrid'
				}
	    		if(k>3){
					$("#drugdatagrid").datagrid('appendRow',rowobj);
				}else{
					$("#drugdatagrid").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
						index: k, // 行数从0开始计算
						row: rowobj
					});
				}
				k=k+1;
    		})
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdatagrid'
				}
				$("#drugdatagrid").datagrid('appendRow',rowobj);
	   		});
	    }
    	//$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
		
	}
  $('#mwin').window('close');
}

//过滤掉输入文本信息中空格
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
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

//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:''}
		});
		
		$("#drugdatagrid").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:''}
		});
		
	}
}

//保存首次查房记录
function saveFirstMedRoundInf(){
	//0.检查基本信息
	var Temperature=$('#Temperature').val();/// 体温
	var Pulse=$('#Pulse').val();			/// 脉搏
	var Breath=$('#Breath').val();			/// 呼吸
	var Heartrate=$('#Heartrate').val();	/// 心率
	var Bloodpre=$('#Bloodpre').val();		/// 血压
	var Urineamt=$('#Urineamt').val();		/// 尿量
	if ((Temperature=="")||(Pulse=="")||(Breath=="")||(Heartrate=="")||(Bloodpre=="")||(Urineamt=="")){//sufan 2016/9/13
		$.messager.alert("提示","记录不完整，请重新输入!");
		return;
		}
	//1、双肺呼吸音
	var DouLunBrePho="";
    $("input[type='checkbox'][name='DouLunBrePho']").each(function(){
	    if($(this).is(':checked')){  		/// 首次查房界面,当复选框的值改变时,保存时的取值(1-8)  sufan 2016/09/18
		//if($(this).hasClass('cb_active')){
		DouLunBrePho=this.value;     		/// 取选择框的值  qunianpeng 2016-09-14 保存首次记录取值均改
		}
	})
	if(DouLunBrePho==""){
		$.messager.alert("提示:","双肺呼吸音不能为空！");
		return;
	}
	//2、啰音
	var Rale="";
    $("input[type='checkbox'][name='Rale']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Rale=this.value;		
		}
	})
	if(Rale==""){
		$.messager.alert("提示:","啰音不能为空！");
		return;
	}
	//3、心律
	var Arrhythmia="";
    $("input[type='checkbox'][name='Arrhythmia']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Arrhythmia=this.value; 
		}
	})
	if(Arrhythmia==""){
		$.messager.alert("提示:","心律不能为空！");
		return;
	}
	//4、各瓣膜听诊区、病理性杂音
	var PathMurmur="";
    $("input[type='checkbox'][name='PathMurmur']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			PathMurmur=this.value;		
		}
	})
	if(PathMurmur==""){
		$.messager.alert("提示:","各瓣膜听诊区、病理性杂音不能为空！");
		return;
	}
	//5、腹部
	var Belly="";
    $("input[type='checkbox'][name='Belly']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Belly=this.value;		
		}
	})
	if(Belly==""){
		$.messager.alert("提示:","腹部不能为空！");
		return;
	}
	//6、肝脾肋下
	var LivLieCos="";
    $("input[type='checkbox'][name='LivLieCos']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			LivLieCos=this.value;		
		}
	})
	if(LivLieCos==""){
		$.messager.alert("提示:","肝脾肋下不能为空！");
		return;
	}
	//7、双肾区叩击痛
	var PerPain="";
    $("input[type='checkbox'][name='PerPain']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			PerPain=this.value;		
		}
	})
	if(PerPain==""){
		$.messager.alert("提示:","双肾区叩击痛不能为空！");
		return;
	}
	//8、双下肢水肿
	var Oedema="";
    $("input[type='checkbox'][name='Oedema']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Oedema=this.value;		
		}
	})
	if(Oedema==""){
		$.messager.alert("提示:","双下肢水肿不能为空！");
		return;
	}
	
	//9.指导内容
	var Guidance=$('#FirstMedWardGuideContent').val();
	if(Guidance=="编辑内容.."){			/// qunianpeng 2017/11/22 防止未输入内容，保存了默认内容
		Guidance=""	
	}
	
	
	//10.首次查房记录ID
	var rowid=$('#RowId').val();
	
	
	//主要病情变化
	var ChaOfDisDesc="";
	
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	//诊断
	var Icd=$('#AdmInf').val();
	
	//---主要记录信息
	var cpMasDataList=EpisodeID+"^"+Temperature+"^"+Pulse+"^"+Breath+"^"+Heartrate+"^"+Bloodpre+"^"+Urineamt ;
	cpMasDataList=cpMasDataList+"^"+DouLunBrePho+"^"+Rale+"^"+Arrhythmia+"^"+PathMurmur+"^"+Belly+"^"+LivLieCos;
	cpMasDataList=cpMasDataList+"^"+PerPain+"^"+Oedema+"^"+ChaOfDisDesc+"^"+Guidance+"^"+UserDr+"^"+Icd;
	
	//----主诉
	var PreComList=$('#ChiefComplaint').val().trim();
		if(PreComList==""){
		$.messager.alert("提示:","主诉不能为空！");
		return;
	}
	
	//----关注药品列表
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	var input=cpMasDataList+"!"+PreComList+"!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: url+'?action=SaveMedWardRoundInf',//提交到那里  
		data: "rowid="+rowid+"&"+"input="+input,//提交的参数    //sufan 2016/09/18(修改rowid)
		success:function(msg){ 
			if(msg!=0){
				alert("保存失败,失败状态码为"+msg);
			}else{           
				alert("保存成功");
				clearData();
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
	
}

//保存查房记录
function saveMedRoundInf(){
        //liubeibei 20180626  填写首次查房记录后才可填写日常查房记录
        var firstRowid=tkMakeServerCall("web.DHCPHCLIPATHOGRAPHY","getMedWardRoundID",EpisodeID,"First");
        if(firstRowid==0)
        {
             $.messager.alert("提示","请先填写首次查房记录!");
             return;
        }
	//0.检查基本信息
	var Temperature=$('#Temperature1').val();/// 体温
	var Pulse=$('#Pulse1').val();			/// 脉搏
	var Breath=$('#Breath1').val();			/// 呼吸
	var Heartrate=$('#Heartrate1').val();	/// 心率
	var Bloodpre=$('#Bloodpre1').val();		/// 血压
	var Urineamt=$('#Urineamt1').val();		/// 尿量
	if ((Temperature=="")||(Pulse=="")||(Breath=="")||(Heartrate=="")||(Bloodpre=="")||(Urineamt=="")){//sufan 2016/9/13
		$.messager.alert("提示","记录不完整，请重新输入!");
		return;
		}
	//1、双肺呼吸音
	var DouLunBrePho="";
   
	//2、啰音
	var Rale="";
   
	//3、心律
	var Arrhythmia="";
   
	//4、各瓣膜听诊区、病理性杂音
	var PathMurmur="";
   
	//5、腹部
	var Belly="";
  
	//6、肝脾肋下
	var LivLieCos="";
   
	//7、双肾区叩击痛
	var PerPain="";
   
	//8、双下肢水肿
	var Oedema="";
  	
	//9.指导内容
	var Guidance=$('#MedWardGuideContent').val();
	if ((Guidance=="")||(Guidance=="编辑内容..")){   //sufan 2016/09/18
		$.messager.alert("提示","记录不完整,请重新输入！");
		return;
		}
	//10.首次查房记录ID
	var rowid=$('#MedPhaRid').val();

	//主要病情变化
	var ChaOfDisDesc=$('#ChaOfDisDesc').val();
	if(ChaOfDisDesc==""){
		$.messager.alert("提示","记录不完整，请重新输入！");   //sufan 2016/09/13
		return;
		}
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	//诊断
	var Icd="";
	
	//---主要记录信息
	var cpMasDataList=EpisodeID+"^"+Temperature+"^"+Pulse+"^"+Breath+"^"+Heartrate+"^"+Bloodpre+"^"+Urineamt ;
	cpMasDataList=cpMasDataList+"^"+DouLunBrePho+"^"+Rale+"^"+Arrhythmia+"^"+PathMurmur+"^"+Belly+"^"+LivLieCos;
	cpMasDataList=cpMasDataList+"^"+PerPain+"^"+Oedema+"^"+ChaOfDisDesc+"^"+Guidance+"^"+UserDr+"^"+Icd;
	
	//----主诉
	var PreComList="";
	
	//----关注药品列表
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdatagrid').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	var input=cpMasDataList+"!"+PreComList+"!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',							/// 提交方式 post 或者get  
		url: url+'?action=SaveMedWardRoundInf', /// 提交到那里  
		data: "rowid="+rowid+"&"+"input="+input,/// 提交的参数  
		success:function(msg){ 
			if(msg!=0){
				alert("保存失败,失败状态码为"+msg);
			}else{           
				alert("保存成功");
				clearData();
			}       
		},    
		error:function(){        
			alert("保存失败");        
		}
	});
	
}

function clearData(){
	window.location.reload();
}

function query(){
	 $('#recordWin').window({
		title:'医学查房记录',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:400,
		minimizable:false						/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true						/// 最大化

	}); 

	$('#recordWin').window('open');
	//起止时间
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medWardGrid(stDate,endDate);
}


//病人的住院期间查房记录列表
function find_medWardGrid(stDate,endDate)
{
	
	//定义columns
	var columns=[[
		{field:"PHCPRid",title:'RowID',width:100},
		{field:'recordDate',title:'记录日期',width:200},
		{field:'User',title:'记录人',width:200}
	]];
	
	//定义datagrid
	$('#medWardRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  				/// 每页显示的记录条数
		pageList:[15,30,45],   		/// 可以设置每页记录条数的列表
	    	singleSelect:true,     	/// nisijia 2016-09-23
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function() { 
    		var selected = $('#medWardRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*获取记录ID*/
				$('#MedPhaRid').val(selected.PHCPRid);
				//加载其它信息
				$('#Temperature1').val(selected.Temperature);	/// 体温
				$('#Pulse1').val(selected.Pulse);				/// 脉搏
				$('#Breath1').val(selected.Breath);				/// 呼吸
				$('#Heartrate1').val(selected.Heartrate);		/// 心率
				$('#Bloodpre1').val(selected.Bloodpre);			/// 血压
				$('#Urineamt1').val(selected.Urineamt);			/// 尿量
				$('#ChaOfDisDesc').val(selected.ChaOfDisDesc);  /// 主要病情变化情况
				$('#MedWardGuideContent').val(selected.Guidance);
					 var maxlimit=800;
		       if ($('#MedWardGuideContent').val().length >maxlimit){  
                   $('#MedWardGuideContent').val(($('#MedWardGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen1"]').val(maxlimit-$('#MedWardGuideContent').val().length);
		       }
				//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  		var cliPatID=$('#MedPhaRid').val();
				if(cliPatID!=""){	
					/*加载用药信息*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getMRDrgItm&cliPatID="+cliPatID,
      			 		//dataType: "json",
       					success: function(val){
	       					var obj = eval( "(" + val + ")" );
	       					$('#drugdatagrid').datagrid('loadData',obj);
       					}
					});
				 }					
      		}
		}
	});
	
	$('#medWardRecord').datagrid({
		url:url+'?action=GetMedWardRecord',	
		queryParams:{
			AdmDr:EpisodeID,
			startDate:stDate,
			endDate:endDate	
		}
	});
}

function queryByDate(){
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medWardGrid(stDate,endDate);
}

/// 体温单 bianshuai 2015-01-20
function getPatObserInfo(EpisodeID)
{
	$.ajax({
		type: "POST",
		url: url,
		data: "action=GetPatVitalSigns&EpisodeID="+EpisodeID,
		//dataType: "json",
		success: function(str){
			if(str.replace(/(^\s*)|(\s*$)/g,"")==""){return;}
			var vSObj = eval('('+str+')');
			//设置生命体征[首次查房]
			$("input[name=VitalSigns]").each(function(){
				var tempstr=$(this).parent().html().replace('<SPAN class=star>*</SPAN>',"");
				var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");					
				if(typeof vSObj[obserdesc]!="undefined"){
					$(this).val(vSObj[obserdesc]); //填值
				}
				/*
				if(typeof vitalSignsObj[this.id]!=undefined){
					$('#'+this.id).val(vitalSignsObj[this.id]);
				}
				*/
			});
			
			//设置生命体征[日常查房]
			$("input[name=VitalSigns1]").each(function(){
				var tempstr=$(this).parent().html().replace('<SPAN class=star>*</SPAN>',"");
				var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");
				if(typeof vSObj[obserdesc]!="undefined"){
					$(this).val(vSObj[obserdesc]); //填值
				}
				/*
				var property=this.id.substring(0,this.id.length-1)
				if(typeof vitalSignsObj[property]!=undefined){
					$('#'+this.id).val(vitalSignsObj[property]);
				}
				*/
			});
		}
	});

}

/// 打印医学首次查房记录
function printFirstMedRoundInf(){
	var medWardID=$('#RowId').val();
	print_FirstMedRoundInf(medWardID);
}


/// 打印医学日常查房记录
function printMedRoundInf(){
	var medWardID=$('#MedPhaRid').val();
	print_MedRoundInf(medWardID);
}

function printMedRoundInfAll(){
	var phchStr = tkMakeServerCall("web.DHCPHCLIPATHOGRAPHY","GetPhcpIdStr",EpisodeID)
	if(phchStr == ""){
		$.messager.alert("提示","没有医学查房记录！");
		return;
	}
	var phcpIdArr = phchStr.split("^");
	for(var i in phcpIdArr){
		if(!phcpIdArr[i]){
			continue;	
		}
		if(i == 0){
			print_FirstMedRoundInf(phcpIdArr[i]);
		}else{
			print_MedRoundInf(phcpIdArr[i]);
		}	
	}
}