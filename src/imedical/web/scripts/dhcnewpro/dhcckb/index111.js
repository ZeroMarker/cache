/**1
	zhouxin
	2019-06-27
	知识库首页
*/
var version = ""	// 首页版本(Dev-开发版 -不需要过滤对照)
$(function(){
	initDefault();
	initClick();
	initCombox();
	
	initTab();
})
function GetDrugDataListA(){
	var queryPar = $("#drugOne").val();
	$("#drugOnelist").empty();
	if(queryPar!=""){
		runClassMethod("web.DHCCKKBIndex","GetDrugDataList",{"queryPar":queryPar,"userInfo":"","queryType":"1"},function(data){
			if(data!=""){
				$("#drugOnelist").append(data)
			}	
		},"text")
	}	
}
function GetDrugDataListB(){
	var queryPar = $("#drugOther").val();
	$("#drugOtherlist").empty();
	if(queryPar!=""){
		runClassMethod("web.DHCCKKBIndex","GetDrugDataList",{"queryPar":queryPar,"userInfo":"","queryType":"1"},function(data){
			/*
			if(data!=undefined&&data!=null){
				var arr=data.rows;
				$.each(arr,function(i,n){
				$("#drugOtherlist").append("<option value='"+n.value+"'>")	
				})
			}	*/
			if(data!=""){
				$("#drugOtherlist").append(data)
			}	
		},"text")
	}	
}
function initTab(){
	

	$('#searchTab').tabs({
	    border:false,
	    onSelect:function(title){
		   
	    }
	});
	
	 $("#keyword").combobox("textbox").keydown(function(e){
		if (e.keyCode == 13){
			search();
		}
	}); 
}

function initDefault(){
	//$('#searchTab').tabs('select', '全部药品分类');
	version = getParam("Version");	
	selectSecondMenuFirst();
	resize();
}
function resize(){
	
	return;
	//var iframeHeight=$("iframe:visible").contents().find("body").height()+60
	var iframeHeight=$("iframe:visible").contents().find(".body-wrapper").height()+60
	var screenHeight=window.screen.availHeight;   //屏幕可用高度 
	var searchHeight=$(".i-head").height();
	var footerHeight=$(".footer").height()+10;
	var footerTop;
	var minTabHeight=screenHeight-searchHeight-footerHeight-35;
	
	//console.log("windowHeight:"+$(window).height())
	//console.log("screenHeight:"+screenHeight)
	//console.log("searchHeight:"+searchHeight)
	//console.log("footerHeight"+footerHeight)
	
	var sortSub=$(".sortsub").height();
	var sortGoodsList=$("#sortGoodsList").height();
	var tabHeight=sortGoodsList>sortSub?sortGoodsList:sortSub;
	if($("#sortGoodsList").is(":hidden")){tabHeight=0;}
	
	var tabHeight=tabHeight>iframeHeight?tabHeight:iframeHeight;

	tabHeight+=40;
	tabHeight=tabHeight>minTabHeight?tabHeight:minTabHeight


	$("#tabDiv").height(tabHeight);

	$('#searchTab').tabs('resize');
	


	footerTop=tabHeight+searchHeight;
	/**
	if(footerTop>windowHeight){
		footerTop=tabHeight+searchHeight;
	}else{
		if(footerTop<windowHeight){
			footerTop=windowHeight-footerHeight;
		}else{
			footerTop=tabHeight+searchHeight;
		}
	}
	*/
	$(".footer").css({
		top:footerTop	
	})
}
function selectSecondMenuFirst(){
	var dic=$(".sort-2-list-title:visible").first().attr("dic");
	selectSecondMenu(dic);
}

function initClick(){
	
	$("#sortGoodsList").on('click',function(){
		$("#otherGoodsList").show();
	});

	$('.sort-list-title').mouseover(function() {
			 $('.sort-list-title').removeClass('sort-list-title-selected');
             $(this).addClass('sort-list-title-selected');
             $(".sortsub").hide();
             $(this).next().show();
             selectSecondMenuFirst();
         });
    
    $('.sort-2-list-title').mouseover(function() {
	    	 selectSecondMenu($(this).attr("dic"));
    });
     
	$(".search-tab-hd").find("li").on('click',function(){
		$(".search-tab-hd").find("li").removeClass("curr");
		$(this).addClass("curr");
		var selectTitle = $(this).attr("data-value");
		//kml
		if((selectTitle=="7")||(selectTitle=="5")||(selectTitle=="6")){
			$("#searchBox").hide();
			$("#checkBox").show();
			$("#checkTab").show();
			$("#searchText").hide();
		}else if ((selectTitle == "2")||(selectTitle == "3")){	// 适应症,禁忌症
			$("#searchBox").hide();
			$("#checkBox").hide();
			$("#checkTab").hide();
			$("#searchText").show();
		}
		else{
			$("#searchBox").show();
			$("#checkBox").hide();
			$("#checkTab").hide();
			$("#searchText").hide();
		}
	})
	
	$("#keyword").keyup(function(event){  
          if(event.keyCode ==13){  
				search();
          }  
    });
    
    $(".combo-text validatebox-text").keyup(function(event){  
          if(event.keyCode ==13){  
				search();
          }  
    });
    
    $("#keywordText").keyup(function(event){  
          if(event.keyCode ==13){  
				search();
          }  
    });
    
    $("#searchBtn").on('click',function(){
	    search();
	})
	 $("#searchBtnText").on('click',function(){
	    search();
	})
		
	$("#btQuotation").on('click',function(){		//查询全部药品
		if ($('#searchTab').tabs('exists', "新编药物学分类")){
			$('#searchTab').tabs('select', "新编药物学分类");
			return;
		}
		var NewDrugCatId=serverCall("web.DHCCKKBIndex","getDrugCatId");
		var url="dhcckb.index.table.csp?catId="+NewDrugCatId
		addTab("新编药物学分类",url);
	})
	
	$("#checkBtn").on('click',function(){
	    searchNew();
	})
	$("#checkTab").on('click',function(){
	    searchNew();
	})
	
	

}
function searchNew(){
     var keyword = $('#drugOne').combogrid('getValue'); //combogrod取值
     var drugOther = $('#drugOther').combogrid('getValue'); //combogrod取值
   	 if(keyword!=""){
			   	keywordNew=keyword.replace(/[%]/g,"%25") //特殊字符处理 kml 2020-03-02
			   	DrugOtherNew=drugOther.replace(/[%]/g,"%25") //特殊字符处理 wx 2020-11-24
			   	var queryType=$(".search-tab-hd .curr").attr("data-value");
		     addTab(keyword,"dhcckb.index.list.csp?input="+keywordNew+"&inputType="+queryType+"&drugOther="+DrugOtherNew+"&version="+version);	// 增加versison qnp 2021/5/19	   
     }else{
	 	    $.messager.popover({msg: '请输入内容！',type:'success',timeout: 1000});    
	    }
}


function search(){
	var keyword="";
	 var queryType=$(".search-tab-hd .curr").attr("data-value");
	 if ((queryType == 2)||(queryType == 3)){
		keyword=$("#keywordText").val();
	}else{
		keyword = $('#keyword').combobox('getText'); //combogrod取值
	}
     //var keyword=$("#keyword").val();
     // var keyword = $('#keyword').combogrid('getValue'); //combogrod取值
   	 if(keyword!=""){
	   	keywordNew=keyword.replace(/[%]/g,"%25") //特殊字符处理 kml 2020-03-02
	   	//var queryType=$(".search-tab-hd .curr").attr("data-value");

     addTab(keywordNew,"dhcckb.index.list.csp?input="+keywordNew+"&inputType="+queryType+"&version="+version);	   
     }else{
	 	$.messager.popover({msg: '请输入内容！',type:'success',timeout: 1000});    
	 }
}
function selectSecondMenu(dic){
	var titleObj=$("div[dic="+dic+"]");
	$('.sort-2-list-title').removeClass('sort-2-list-title-selected')
    $(titleObj).addClass('sort-2-list-title-selected')
	$(titleObj).show();
	$.get(
	  "dhcapp.broker.csp",
	  {
	 		ClassName:"web.DHCCKKBIndex",
  			MethodName:"CatLev3ToHTML",
  			parref:dic
	  },
	  function(data){
		   $(titleObj).parent().parent().parent().next().html(data);
		   resize();
	  }
	);


}

function addTab(title, url){
	var content = '<iframe  frameborder="0"  src="'+url+'" style="width:100%;height:100%"></iframe>';
	var selTab = $('#searchTab').tabs('getSelected');
	if ($('#searchTab').tabs('exists', title)){
		$('#searchTab').tabs('select', title);
		$('#searchTab').tabs('update', {
            tab: selTab,
            options: {
                content:content
            }
        })
	} else {
		//height=$("#tabDiv").height()-60;
		
		$('#searchTab').tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
}

function goTable(obj){
	var dic=$(obj).attr("data-id");
	var title=$(obj).attr("data-title");
	var url="dhcckb.index.table.csp?catId="+dic
	addTab(title,url);
}
///更新tabs 的 title
function updTabsTitle(id,title)
{
	
	if ($('#searchTab').tabs('exists', title)){
		$('#searchTab').tabs('select', title);
	} else{
		var seltabs=$("#searchTab").tabs('getSelected');
		var index=$("#searchTab").tabs("getTabIndex",seltabs);
		$("#searchTab").tabs('close',index);
		var url="dhcckb.index.table.csp?catId="+id;
		addTab(title,url)
	}
	
}
function closeTab(title){
	$.messager.alert("提示","未检索到药品")
	$("#searchTab").tabs('close',title);
	}
function initCombox(){
	$("#keyword").combobox({
		valueField:'value',
	    textField:'text',
	    fit: true,//自动大小 
	    width:500, 
	    height:40,
		mode:'remote', 	
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryContrastComgridNew&input=',
		onSelect:function(rowData) {
			var val = rowData.text.replace("<span style='color:#018EE8'>", '');
			val =val.replace("</span>", '');
			$("#keyword").combobox("setText",val)
		},
		onBeforeLoad:function(param){
				var value = $('#keyword').combobox("getText")
				if(value.length<2) {
					param.input=""
					
				}else{					
					param.input=value
					}
			}
		  }

	)

	}