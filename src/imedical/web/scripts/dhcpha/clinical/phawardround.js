/*
* 药学查房
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var titleNotes='<span style="font-weight:bold;">'+$g("重点关注药物")+'</span>';
var titleNote='<span style="font-weight:bold;">'+$g("出院带药列表")+'</span>';
var EpisodeID=""
var tmp=""; 			/// 缓存点击每个分级菜单，显示界面时，取到的病人基本信息
$(document).ready(function(){	

	EpisodeID=getParam("EpisodeID")		/// 默认打开新入院患者界面 qunianpeng 2018/3/10
	PatientID=getParam("PatientID")
 	choseMenu($g("新入院患者"));
	$('.easyui-accordion ul li a:contains('+$g("新入院患者")+')').css({"background":"#87CEFA"});	
	
	//根据点击明细显示窗口panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //点击侧菜单的显示相应界面
		 choseMenu(panelTitle);
	});
	InitPageComInfo(EpisodeID); 		/// 初始化页面基础数据
	InitGuiScopeTable();        		/// 初始化指导范围  add by yuliping
	pageBasicControll();
	InitPageData();
	//getPatFirProNote(EpisodeID);  	/// 设置病人病程记录信息
	
})

function choseMenu(item){
	switch(item){
		case $g("新入院患者"):
			//防止重复点击，而此时Flag=1，导致不执行创建界面
			if(Flag1==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个$g("新入院患者")的panel
				createPanel();
				//设置mainPanel可见
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[红色*号标注的为必填项]')+"</span>"
				});
				$('input[name="ordFiter"][value=""]').attr("checked", true);
			}			
			break;
			
		case $g("住院期间患者"):
			if(Flag2==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个$g("住院期间患者")的panel
				createInHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[红色*号标注的为必填项]')+"</span>"
				});
				//加载数据
				//loadData();
				$('input[name="ordFiter"][value=""]').attr("checked", true);
			}
			break;			
		case $g("出院患者"):
			if(Flag3==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个$g("住院期间患者")的panel
				createOutHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[红色*号标注的为必填项]')+"</span>"
				});
				//加载数据
				//loadData();
				$('input[name="ordFiter"][value="OUT"]').attr("checked", true);
			}
			break;			
		default:
			break;	
	}
				 	
} 


//--创建$g("新入院患者")主界面--//
var Flag1=0;//防止重复点击，多次创建面板
function createPanel() {
	if(Flag1==0){
		//仅显示咨询主界面
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;
		InitPatientInfo(EpisodeID);		
	}
} 

//加载报表默认信息
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //获取病人基本信息
  $.ajax({type: "POST", url: url, data: "action=GetPatInfo&AdmDr="+EpisodeID,
	   success: function(val){
			tmp=val.split("^");
			//病人信息		
			$('#InHosdiag').val(tmp[8])  	/// 入院诊断     nisijia 2016-09-19			
	   }
   })
   
   //清空整个页面上的checkbox的选中状态
   /*$("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
   });*/
   
   var wardRoundID="";
   
   //获取新入院患者查房记录信息
   $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"New",
       dataType: "json",
       success: function(Data){
		 if(Data.RowId==""){						///没有查房记录则病人体征基本信息从电子病历中取  qunianpeng 2018/3/13
				$('#PreDisHis').val(Data.CurrentMed);			/// 现病史
			  	$('#PasDisHis').val(Data.PastHistory);			/// 既往病史
			  	$('#PasMedHis').val(Data.patPMDrgHisDesc);			/// 既往用药史
			  	$('#PerAndFamHis').val(Data.Personal);		/// 个人史及家族史
		        $('#DisAndTre').val(Data.Family);			/// 伴发疾病与用药情况
		      	$('#AllergicHis').val(Data.Allergy); 		/// 过敏史	      		      	
		   }
	      else{
		  	$('#RowId').val(Data.RowId);				/// 表ID		  	
		  	$('#patBloodType').val(Data.WRBloodType);	/// 血型
		  	$('#InHosdiag').val(Data.WRICDesc);		/// 诊断            
		  	$('#PreDisHis').val(Data.wrHisPreComList);			/// 现病史
		  	$('#PasDisHis').val(Data.wrPasDisHisList);			/// 既往病史
		  	$('#PasMedHis').val(Data.wrPasMedHisList);			/// 既往用药史
		  	$('#PerAndFamHis').val(Data.wrPerFamHisList);		/// 个人史及家族史
	      	$('#DisAndTre').val(Data.wrConDisTreList);			/// 伴发疾病与用药情况
	      	$('#AllergicHis').val(Data.wrAllergHisList); 		/// 过敏史
	      	$('#NewInPatGuideContent').val(Data.WRGuidance);		/// 指导意见
	      	$('#patWeight').val(Data.PatW);
		  

	         var maxlimit=800;
	      	  if ($('#NewInPatGuideContent').val().length >maxlimit){  
                   $('#NewInPatGuideContent').val(($('#NewInPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen"]').val(maxlimit-$('#NewInPatGuideContent').val().length);
		       }
	      	//设置勾选框的选中状态
	      	var checkList=Data.wrGuidanceList.substring(0,Data.wrGuidanceList.length).split("^");
	      	$("input[type='checkbox']").each(function(){
		       for(var i=0;i<checkList.length;i++){
		          /*if($(this).val()==checkList[i]&$(this).val()==1){
			           	//如果value=1，即是主条目，则需1.勾选当前框，2.让子条目显示
			       		$(this).attr("checked",true);
			       		$(this).parent().parent().next().css("display","block");	
			       }else if($(this).val()==checkList[i]&$(this).val()!=1){
				        //如果value!=1，即是子条目，则只需勾选当前框
				   		$(this).attr("checked",true);
				   }*/
				   if($(this).val()==checkList[i]){
				   $(this).attr("checked",true);
			       $(this).parent().parent().next().css("display","block");	
				   }
		       }
		  	});
		  	$('#otherGuiscopeN').val(Data.wrGuidanceOther);  	///其它  2017-09-13 yuliping
		  	
		  	//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  	wardRoundID=$('#RowId').val();
			if(wardRoundID!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#drugdg').datagrid('loadData',obj);
       				}
				})
			 } 				
          }
       }       
    });     
}

//--创建住院期间患者主界面--//
var Flag2=0;//防止重复点击，多次创建面板
function createInHopPanel(){
	if(Flag2==0){
		//仅显示咨询主界面
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		//加载病人基本信息，供保存信息时，提取用
		/*
		$.ajax({
   			type: "POST",
   			url: url,
   			data: "action=getAdrRepPatInfo&AdmDr="+EpisodeID+"&LocID="+"",
   			//dataType: "json",
   			success: function(val){
				tmp=val.split("^");

   			}
    	});
    	*/
    	//清空整个页面上的checkbox的选中状态
    	/*$("input[type='checkbox']").each(function(){
	    	$(this).attr("checked",false);
	    });*/
	}
}

//--创建出院患者主界面--//
var Flag3=0;//防止重复点击，多次创建面板
function createOutHopPanel(){
	if(Flag3==0){
		//仅显示咨询主界面
		$("#content3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		InitOutPatientInfo(EpisodeID);			
	}
}

//加载出院病人报表默认信息
function InitOutPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //加载病人基本信息，供保存信息时，提取用
   /*
   $.ajax({
   	  type: "POST",
   	  url: url,
   	  data: "action=GetPatEssInfo&AdmDr="+EpisodeID+"&LocID="+"",
   	  //dataType: "json",
   	  success: function(val){
		  tmp=val.split("^");

   	  }
    });
    */
    //清空整个页面上的checkbox的选中状态
    /*$("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});*/
   	
    var wardRoundID="";
   
    //获取新入院患者查房记录信息
    $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"Out",
       dataType: "json",
      success: function(Data){
	      if(Data.RowId!=""){ 
		  	$('#OutRowId').val(Data.RowId);  				/// 表ID
	      	$('#OutPatGuideContent').val(Data.WRGuidance); /// 指导意见
	          var maxlimit=800;
		       if ($('#OutPatGuideContent').val().length >maxlimit){  
                   $('#OutPatGuideContent').val(($('#OutPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen3"]').val(maxlimit-$('#OutPatGuideContent').val().length);
		       }
	      	//设置勾选框的选中状态
	      	var checkList=Data.wrGuidanceList.substring(0,Data.wrGuidanceList.length).split("^");
	      	$("input[type='checkbox']").each(function(){
		       for(var i=0;i<checkList.length;i++){
		           /*if($(this).val()==checkList[i]&$(this).val()==1){
			           	//如果value=1，即是主条目，则需1.勾选当前框，2.让子条目显示
			       		$(this).attr("checked",true);
			       		$(this).parent().parent().next().css("display","block");	
			       }else if($(this).val()==checkList[i]&$(this).val()!=1){
				        //如果value!=1，即是子条目，则只需勾选当前框
				   		$(this).attr("checked",true);
				   }*/
				   if($(this).val()==checkList[i]){
				   $(this).attr("checked",true);
			       $(this).parent().parent().next().css("display","block");	
				   }
		       }
		  	});
		  	
		  	$('#otherGuiscopeO').val(Data.wrGuidanceOther);		/// 其它  2017-09-13 yuliping
		  	//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  	wardRoundID=$('#OutRowId').val();
			if(wardRoundID!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#outdrugdg').datagrid('loadData',obj);
       				}
				})
			 } 				
          }
       }       
    });
     
}


/**
* 界面上基本内容的显示控制
* 1.控制子条目勾选框的显隐
* 2.每个界面$g("编辑内容..")，获取焦点、失去焦点，内容控制
*/
function pageBasicControll(){
	//控制name="checkboxMain"选择框下子条目的显示和隐藏
	
	$("input").bind('click',function(){
		$("input[name='checkboxMain']").each(function(){
			if($(this).attr("checked")){
				$(this).parent().parent().next().css("display","block");
			}else{
				$(this).parent().parent().next().css("display","none");
			}
		}) 
	})
	/*新入院*/
	$('#NewInPatGuideContent').focus(function(){
		if($(this).text()==$g("编辑内容..")){
			$(this).text("");
		}
	})
	$('#NewInPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("编辑内容.."));
		}
	})
	
	/*住院期间*/
	$('#InPatGuideContent').focus(function(){
		if($(this).text()==$g("编辑内容..")){
			$(this).text("");
		}
	})
	$('#InPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("编辑内容.."));
		}
	})
	
	/*出院*/
	$('#OutPatGuideContent').focus(function(){
		if($(this).text()==$g("编辑内容..")){
			$(this).text("");
		}
	})
	$('#OutPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("编辑内容.."));
		}
	})
		
}

//加载界面初始datagrid显示
function InitPageData(){
	//定义columns
	var columns=[[
		{field:"orditm",title:$g('orditm'),width:90,hidden:true},
	    {field:'incidesc',title:$g('名称'),width:300,align:'left'},
	    //{field:'genenic',title:'通用名',width:300,align:'left'},
	    //{field:'manf',title:'生产企业',width:300,align:'left'},
	    {field:'dosage',title:$g('剂量'),width:60,align:'left'}, 	/// 增加剂量-是否执行 qunianpeng 2018/3/12
		{field:'instru',title:$g('用法'),width:60,align:'left'},
		{field:'freq',title:$g('频次'),width:60,align:'left'},
		{field:'duration',title:$g('疗程'),width:40,align:'left'},
		{field:'execStat',title:$g('是否执行'),width:50,align:'left',hidden:true},
	    {field:'dgID',title:$g('dgID'),width:300,hidden:true},

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
		height:165, 			/// 大于四行生成滚动条 duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,		/// 行号 
	    remoteSort:false,		/// 界面排序
		fitColumns:true,    	/// duwensheng 2016-09-13 自适应大小，防止横向滑动
		loadMsg: $g('正在加载信息...'),
	    onDblClickRow: function (rowIndex, rowData) {	
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#drugdatagrid').datagrid({
		title:titleNotes,    
		url:'',
		height:165,				 /// 大于四行生成滚动条 duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,		/// 界面排序
		fitColumns:true,    	/// duwensheng 2016-09-13 自适应大小，防止横向滑动
	    rownumbers:true,		/// 行号 
		loadMsg: $g('正在加载信息...'),
	    onDblClickRow: function (rowIndex, rowData) {
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdatagrid").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//定义datagrid
	$('#outdrugdg').datagrid({
		title:titleNote,    
		url:'',
		height:165, 				/// 大于四行生成滚动条 duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,			/// 界面排序
		fitColumns:true,    		/// duwensheng 2016-09-13 自适应大小，防止横向滑动
	    rownumbers:true,			/// 行号 
		loadMsg: $g('正在加载信息...'),
	    onDblClickRow: function (rowIndex, rowData) {
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#outdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	InitdatagridRow();
}

//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			///row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'drugdg'}
			/// 增加药品信息相关列 qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		
		$("#drugdatagrid").datagrid('insertRow',{
			index: 0, 
			//row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'drugdatagrid'}
			/// 增加药品信息相关列 qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		$("#outdrugdg").datagrid('insertRow',{
			index: 0, 
			//row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'outdrugdg'}
			/// 增加药品信息相关列 qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
	}
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	//var dgID='"'+rowData.dgID+'"';
	if(Flag1==1){		 /// qunianpeng 2016/10/10 若数据是从后台加载时，则rowData.dgID不存在
		var dgID='"'+'drugdg'+'"';
	}
	if(Flag2==1){
		var dgID='"'+'drugdatagrid'+'"';
	}
	if(Flag3==1){
		var dgID='"'+'outdrugdg'+'"';
	}
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// 删除行
function delRow(datagID,rowIndex)
{
	var selItem=$('#'+datagID).datagrid('getSelected');
	//如果选择的行号和删除按钮所在的行号一致，才删除
	//duwensheng 2016-09-13
	if(($('#'+datagID).datagrid("getRowIndex",selItem)+1)==(rowIndex+1)){
		//行对象
    	var rowobj={
			//orditm:'', incidesc:'', genenic:'', manf:''	/// 增加药品信息相关列 qunianpeng 2018/3/12
			orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''
		};

		//当前行数大于4,则删除，否则清空
		//var selItem=$('#'+datagID).datagrid('getSelected');
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
	
		// 删除后,重新排序    duwensheng 2016-09-13 
		$('#'+datagID).datagrid('sort', {	        
			sortName: 'incidesc',
			sortOrder: 'desc'
		});
	}
	else{
		alert("请选择正确行进行删除!")
	}
}

/// 病人药品窗口
function patOeInfoWindow()
{
	$('#mwin').window({
		title:$g('病人用药列表'),
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520,
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true,						/// 最大化(qunianpeng 2018/3/12)

	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20,disabled:true},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:$g('优先级'),width:80},
		{field:'StartDate',title:$g('开始日期'),width:80},
		{field:'EndDate',title:$g('结束日期'),width:80},
		{field:'incidesc',title:$g('名称'),width:280},
		{field:'genenic',title:$g('处方通用名'),width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('剂量'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('用法'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('频次'),width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('疗程'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'form',title:$g('剂型'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'doctor',title:$g('医生'),width:80},
		{field:'execStat',title:$g('是否执行'),width:80},		/// 增加执行/发药 qunianpeng 2018/3/12
		{field:'sendStat',title:$g('是否发药'),width:80},
		{field:'apprdocu',title:$g('批准文号'),width:80},
		{field:'manf',title:$g('厂家'),width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true}

	]];
	
	//定义datagrid
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// 每页显示的记录条数
		pageList:[15,30,45],    /// 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
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
				if(item.moeori==rowData.orditm){
					if(flag==1){
						$('#medInfo').datagrid('selectRow',index);
					}else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				}
			})
		},
		queryParams:{
			params:EpisodeID,
			PriCode: $('input[name="ordFiter"]:checked').val()	
		},
		onLoadSuccess: function(data){
			if(Flag1 == 1){
				var selectedRows = $('#drugdg').datagrid('getRows');
			}else if(Flag2 == 1){
				var selectedRows = $('#drugdatagrid').datagrid('getRows');
			}else if(Flag3 == 1){
				var selectedRows = $('#outdrugdg').datagrid('getRows');	
			}else{
				return;	
			}
			$.each(data.rows, function (i, v) {
				for(var index in selectedRows){
					if(selectedRows[index].incidesc === v.incidesc){
						$('#medInfo').datagrid('selectRow', i);	
					}
				}
            });	
		}
	});
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});
}

function addWatchDrg(){
	var ItemFlag="";  	/// qunianpeng 2016/10/10
	if(Flag1==1){
		var phaWardRid=$('#RowId').val();
		//新入院患者界面
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
		if(checkedItems==""){
		 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
		/**
		*1.如果初始查房记录rowid不存在，则药品列表，显示为初始条目
		*2.如果查房记录rowid存在，则根据关注药品，在datagrid显示，通过reload方式
		*/
		$.each(checkedItems, function(index, item){
    		var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
	     		//manf:item.manf, dgID:'drugdg'
	     		/// 替换列的内容 qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'

			}
		for(var j=0;j<rows.length;j++){ /// qunianpeng 2016/10/10 增加药品的重复性判断
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("药品列表已存在'"+rows[j].genenic+"',请重新选择!");
				//alert("药品列表已存在'"+rows[j].incidesc+"',请重新选择!");
				return ;
			}
		}
    			if(k>3){
				$("#drugdg").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg").datagrid('updateRow',{	/// 在指定行添加数据，appendRow是在最后一行添加数据
					index: k, 						/// 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
			  
		})
		
	}else if(Flag2==1){		
		var phaWardRid=$('#InPatRowid').val();
		//新入院患者界面
		//用药列表
		var rows = $('#drugdatagrid').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++){
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		//获取医嘱列表被勾选的行
		var checkedItems = $('#medInfo').datagrid('getChecked');  /// qunianpeng 2016/10/10 update
		if(checkedItems==""){
			 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//	manf:item.manf, dgID:'drugdatagrid'
		     	/// 替换列的内容 qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdatagrid'

			}
		for(var j=0;j<rows.length;j++){ 						/// qunianpeng 2016/10/10 增加药品的重复性判断
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("药品列表已存在'"+rows[j].incidesc+"',请重新选择!");
				return ;

			}
		}
	    		if(k>3){
				$("#drugdatagrid").datagrid('appendRow',rowobj);
			}else{
				$("#drugdatagrid").datagrid('updateRow',{		/// 在指定行添加数据，appendRow是在最后一行添加数据
					index: k, 									/// 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
			
    	})
		
	}else if(Flag3==1){
		//查房界面
		//用药列表
		var rows = $('#outdrugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++){
			if(rows[i].orditm!=""){
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'outdrugdg'
		     	/// 替换列的内容 qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'outdrugdg'

		}
		for(var j=0;j<rows.length;j++){ 			/// qunianpeng 2016/10/10 增加药品的重复性判断
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("药品列表已存在'"+rows[j].incidesc+"',请重新选择!");
				return ;
			}
		}
	    		if(k>3){
				$("#outdrugdg").datagrid('appendRow',rowobj);
			}else{
				$("#outdrugdg").datagrid('updateRow',{	/// 在指定行添加数据，appendRow是在最后一行添加数据
					index: k, 							/// 行数从0开始计算
					row: rowobj
				});
			}
			k=k+1;
			 
    	})
		//$('#mwin').window('close');
	}
	$.messager.alert("提示:","添加成功");
	setTimeout(function(){
    	$(".messager-body").window('close');    
	},1000);
}
// 关闭用药列表窗口
function cancelWin()
{
	 $('#mwin').window('close');
}

///加载病人用药列表
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode}
	});
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

/**
* autor：   pengzhikun
* function: 保存新入院患者相关数据
*/
function saveNewInPatPhaWardInfo(){
	var rowid=$('#RowId').val();
	//患者类别
	var PatType="New";
	//患者科室Id
	var PatLoc=$('#AdmLoc').val();
	//患者病区Id
	var PatWard=$('#AdmWard').val();
	//记录人
	var UserDr=session['LOGON.USERID'];
	//血型
	var BloodType=$('#patBloodType').val();
	//入院诊断
	var AdmInf=$('#InHosdiag').val();    
	//指导意见
	var content=$('#NewInPatGuideContent').val();
	if(content==$g("编辑内容..")){
		content=""; 			/// qunianpeng 2017/11/22 防止未输入内容，保存了默认内容
	}
	//体重
	var patWeight=$('#patWeight').val();
	///注意事项
	var drugInstruction=""; 	/// $('#NewInPatInstruction').val();  qunianpeng 2017/11/23  根据项目需要再加
	
	//查房主表信息
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+BloodType+"||"+AdmInf+"||"+PatType+"||"+content+"||"+UserDr+"||"+patWeight+"||"+drugInstruction
	
	//现病史
	var PreDisHis= $('#PreDisHis').val();
	
	//既往病史
	var PasDisHis=$('#PasDisHis').val();
	
	//既往用药史
	var PasMedHis=$('#PasMedHis').val();
	
	//个人史及家族史
	var PerAndFamHis=$('#PerAndFamHis').val();
	
	//伴发疾病与用药情况
	var DisAndTre=$('#DisAndTre').val();
	
	//过敏史
	var AllergicHis=$('#AllergicHis').val();
	
	if ((PreDisHis=="")||(PasDisHis=="")||(PasMedHis=="")||(PerAndFamHis=="")||(DisAndTre=="")||(AllergicHis=="")){	/// sufan 2016/09/13
		$.messager.alert("提示","记录不完整，请重新输入！");
		return;
		}
	
	//初始治疗计划
	//保存选中的checkbox duwensheng 2016-09-18
	var ckList=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
			if($(this).attr('value')!="-100"){
          	ckList+=$(this).attr('value')+"||";
			}
		}		
	})
	var otherGuiscope=""				/// yuliping 2017-09-13 其它输入框的内容
	otherGuiscope=$("#otherGuiscopeN").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}


	//重点关注药物
	var tmpItmArr=[]
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	
	var input=wardMainInf+"^"+ckList+"^"+PreDisHis+"^"+PasDisHis+"^"+PasMedHis+"^"+PerAndFamHis
	     +"^"+DisAndTre+"^"+AllergicHis+"^"+tmpItmArr
	
	$.ajax({  
		type: 'POST',							/// 提交方式 post 或者get  
		url: url+'&action=SavePhaWardRoundInf',	/// 提交到那里  
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

/**
* autor：   pengzhikun
* function: 保存住院期间患者相关数据
*/
function saveInPatPhaWardInfo(){
	
	var rowid=$('#InPatRowid').val();
	//患者类别
	var PatType="In";
	//患者科室Id
	var PatLoc=$('#AdmLoc').val();
	//患者病区Id
	var PatWard=$('#AdmWard').val();
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	//指导意见
	var content=$('#InPatGuideContent').val();
	if ((content=="")||(content==$g("编辑内容.."))){
		$.messager.alert("提示","记录不完整，请重新输入！");    //sufan  2016/09/13
		return;
		}
	///注意事项
	var drugInstruction=""; 	/// $('#InPatInstruction').val(); qunianpeng 2017/11/23  根据项目需要再添加
	//查房主表信息
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+""+"||"+""+"||"+PatType+"||"+content+"||"+UserDr+"||"+""+"||"+drugInstruction
	
	//------------------
	//保存选中的checkbox duwensheng 2016-09-18
	var ckList=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
          	ckList+=$(this).attr('value')+"||";
		}		
	})
	var otherGuiscope=""
	otherGuiscope=$("#otherGuiscopeI").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}


	//重点关注药物
	var tmpItmArr=[]
	var drugItems = $('#drugdatagrid').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	if(tmpItmArr==""){
		$.messager.alert("提示","记录不完整，请重新输入！");    //sufan  2016/09/13
		return;
		}
	var input=wardMainInf+"^"+ckList+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+tmpItmArr
	$.ajax({  
		type: 'POST',							/// 提交方式 post 或者get  
		url: url+'&action=SavePhaWardRoundInf', /// 提交到那里  
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

/**
* autor：   pengzhikun
* function: 保存出院患者相关数据
*/
function saveOutPatPhaWardInfo(){
	
	var rowid=$('#OutRowId').val();
	//患者类别
	var PatType="Out";
	//患者科室Id
	var PatLoc=$('#AdmLoc').val();
	//患者病区Id
	var PatWard=$('#AdmWard').val();
	//记录人
	var UserDr=session['LOGON.USERID'];
	
	//指导意见
	var content=$('#OutPatGuideContent').val();
	if ((content=="")||(content==$g("编辑内容.."))){
		$.messager.alert("提示","记录不完整，请重新输入！");   //sufan 2016/09/13
		return;
		}
		///注意事项
	var drugInstruction=""; 	/// $('#OutPatInstruction').val(); qunianpeng 2017/11/23  根据项目需要再
	//查房主表信息
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+""+"||"+""+"||"+PatType+"||"+content+"||"+UserDr+"||"+""+"||"+drugInstruction
		
	//------------------
	//保存选中的checkbox duwensheng 2016-09-18
	var ckList=""
	var otherGuiscope=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
			if($(this).attr('value')!="-100"){
				ckList+=$(this).attr('value')+"||";
			}
		}		
	})
	var otherGuiscope=""
	otherGuiscope=$("#otherGuiscopeO").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}
	
	//重点关注药物
	var tmpItmArr=[]
	var drugItems = $('#outdrugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    tmpItmArr.push(tmp);
		}
	})
	if (tmpItmArr==""){
		$.messager.alert("提示","记录不完整，请重新输入！");   //sufan 2016/09/13
		return;
		}
	var input=wardMainInf+"^"+ckList+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',							/// 提交方式 post 或者get  
		url: url+'&action=SavePhaWardRoundInf', /// 提交到那里  
		data: "rowid="+rowid+"&"+"input="+input, /// 提交的参数  
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
	//window.parent.loadParWin();
}

function query(){
	 $('#recordWin').window({
		title:$g('药学查房记录'),
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:520,
		minimizable:false						/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true						/// 最大化
	}); 

	$('#recordWin').window('open');
	//起止时间
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_phaWardGrid(stDate,endDate);
}


//病人的住院期间查房记录列表
function find_phaWardGrid(stDate,endDate)
{
	
	//定义columns
	var columns=[[
		{field:"wardRoundID",title:$g('RowID'),width:100},
		{field:'WRDate',title:$g('记录日期'),width:200},
		{field:'WRUser',title:$g('记录人'),width:200}
	]];
	
	//定义datagrid
	$('#phaWardRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  				/// 每页显示的记录条数
		pageList:[15,30,45],  		/// 可以设置每页记录条数的列表
	    singleSelect:true,      /// nisijia   2016-09-23
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		onDblClickRow:function() { 
    		var selected = $('#phaWardRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*获取记录ID*/
				$('#InPatRowid').val(selected.wardRoundID)
				$('#InPatInstruction').val(selected.WRDrugInstruction);
				$('#InPatGuideContent').val(selected.WRGuidance)
					var maxlimit=800;
		       if ($('#InPatGuideContent').val().length >maxlimit){  
                   $('#InPatGuideContent').val(($('#InPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen2"]').val(maxlimit-$('#InPatGuideContent').val().length);
		       }
				//获取查房记录ID，如果id不存在，即无查房记录，则不加载药品信息列表
		  		var wardRoundID=$('#InPatRowid').val();
				if(wardRoundID!=""){
					/*加载指导列表*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getGuidList&wardRoundID="+wardRoundID,
      			 		//dataType: "json",
       					success: function(val){
	       					//设置勾选框的选中状态
	      					var checkList=val.split("^");
	      					$("input[type='checkbox']").each(function(){
		       					for(var i=0;i<checkList.length;i++){
		           					if(($(this).val()==checkList[i].trim())){
			           					//nisijia 2016-09-27 如果value=1，即是主条目，则需1.勾选当前框，2.让子条目显示
			       						$(this).attr("checked",true);
			       						$(this).parent().parent().next().css("display","block");	
			       					}
		       					}
		  					});	       					
       					}
					});
					
					/*加载用药信息*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
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
	
	$('#phaWardRecord').datagrid({
		url:url+'&action=getPatWardRecord',	
		queryParams:{
			AdmDr:EpisodeID,
			Status:"In",
			startDate:stDate,
			endDate:endDate	
		}
	});
}

function queryByDate(){
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_phaWardGrid(stDate,endDate);
}

/// 首次病程记录 bianshuai 2015-01-20
function getPatFirProNote(EpisodeID)
{
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getPatFirProNote&EpisodeID="+EpisodeID,
		//dataType: "json",
		success: function(str){
			var patFirProNoteObj = jQuery.parseJSON(str);
			//设置病程记录[首次查房]
			$("textarea[name=PatFirProNote]").each(function(){
				if(typeof patFirProNoteObj[this.id]!=undefined){
					$('#'+this.id).val(patFirProNoteObj[this.id]);
				}
			});
		}
	});
}

/// 初始化页面公共数据  bianshuai 2015-03-09
function InitPageComInfo(EpisodeID)
{
	var retval=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatEssInfo","",EpisodeID);
	if(retval==""){alert("获取病人基本信息出错！");return;}
	var retvalArr=retval.split("^");
	
	$('#patID').val(retvalArr[0]);   //病人ID
	$('#patName').val(retvalArr[3]); //患者姓名
	$('#patSex').val(retvalArr[5]);  //性别
	$('#patAge').val(retvalArr[6]);  //年龄
	$('#patNation').val(retvalArr[9]);  //民族
	$('#patContact').val(retvalArr[14]); //联系方式
	$('#AdmLoc').val(retvalArr[16]); //科室
	$('#AdmWard').val(retvalArr[18]);//病区
	$('#patNativePlace').val(retvalArr[11])//籍贯    //qunianpeng 2016-09-07 改到工作单位
	$('#patWeight').val(retvalArr[12])//体重
	$('#patHeight').val(retvalArr[13])//身高
	$('#patWorkPlace').val(retvalArr[15])//工作单位
}
/// 初始化指导范围 add  by yuliping
function InitGuiScopeTable(){
	
	var subModType=new Array("N","I","O")
	var patlen=0;      //记录父节点的个数，住院要添加其他
	for(var k=0;k<=2;k++){
	
	var tableId="#WAR"+subModType[k];
	var SubModType=subModType[k]
	//获取父节点
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","WAR",SubModType,"");
	/* var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"WAR",
			'SubModType':SubModType,
			'PatCode':""
	     }); */
	     
	var htmlStr=""
	if(rtn==""){
		//父节点为空，提示信息
		 htmlStr= htmlStr+"<tr><td style='color:red'>$g('请维护字典!')"
		}else{
		rtnArr=rtn.split("!")
		patlen=rtnArr.length+1;
		//获取子节点
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			var rtnChild=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","WAR",SubModType,rtnArrs[0]);
			/* var rtnChild=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
				{
					'ModType':"WAR",
					'SubModType':SubModType,
					'PatCode':rtnArrs[0]
		     	}); */
		     	

		     
		    if (rtnChild==""){
				htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkbox' value=\""+rtnArrs[2]+"\" class='GuiScope' />"+(i+1)+'、'+rtnArrs[1]+""
			
		    	}else{
			    	htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkboxMain' value=\""+rtnArrs[2]+"\" class='GuiScope' />"+(i+1)+'、'+rtnArrs[1]+"</td></tr>"
			   		ChildArr=rtnChild.split("!");
			   		var html="<tr style='display:none'><td>";
		   		
					for(var j=0;j<ChildArr.length;j++){
						Child=ChildArr[j].split("^")
					
						html=html+"<input type='checkbox' name='checkbox' value=\""+Child[2]+"\" style='margin-left:40px' class='GuiScope' />"+(i+1)+'.'+(j+1)+'、'+Child[1]+"<br />"
							
				
					}
					htmlStr=htmlStr+html;
			    }
				
			}

		}
		//qunianpeng 2017/11/28 注释 其它
		//var inputid="checkGui"+subModType[k]
		//var inputId="otherGuiscope"+subModType[k]
		//if(htmlStr!=""){htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkboxMain' value='-100' class='GuiScope' id='"+inputid+"'/>"+patlen+"、其它</td></tr><tr style='display:none'><td><input id='"+inputId+"' style='margin-left:40px;' ></input></td></tr>"}
		htmlStr=htmlStr+"</td></tr>"
		$(tableId).append(htmlStr)
	}
}

/// 打印新入院药学查房记录
function printNewInPatPhaWardInfo(){
	var PhawardNewID=$('#RowId').val();
	print_NewInPatPhaWardInfo(PhawardNewID);
}

/// 打印在院患者药学查房记录
function printInPatPhaWardInfo(){
	var PhawardID=$('#InPatRowid ').val();
	print_InPatPhaWardInfo(PhawardID);
}

/// 打印出院患者药学查房记录
function printOutPatPhaWardInfo(){
	var PhawardOutID=$('#OutRowId').val();
	print_OutPatPhaWardInfo(PhawardOutID);
}
/// 打印全部药学查房记录
function printPhaWardInfoAll(){
	var phawIdStr = tkMakeServerCall("web.DHCSTPHCMWARDROUND","GetPhaWardStr",EpisodeID)
	if(phawIdStr == ""){
		$.messager.alert("提示","没有药学查房记录！");
		return;
	}
	var phawIdArr = phawIdStr.split("#");
	var status,phawId;
	for(var i in phawIdArr){
		status = phawIdArr[i].split("^")[0];
		phawId = phawIdArr[i].split("^")[1];
		if((!phawId)||(!status)){
			continue;	
		}
		if(status == "N"){
			print_NewInPatPhaWardInfo(phawId);
		}else if(status == "I"){
			print_InPatPhaWardInfo(phawId);
		}else if(status == "O"){
			print_OutPatPhaWardInfo(phawId);
		}
	}
}