/**1
	zhouxin
	2019-06-27
	֪ʶ����ҳ
*/
var version = ""	// ��ҳ�汾(Dev-������ -����Ҫ���˶���)
var condArray= [{ "value": "and", "text": "����" },{ "value": "or", "text": "����" }]; //�߼���ϵ
var curCondRow=1;
var stateBoxArray= [{ "val": "=", "text": "��ȷƥ��" },{ "val": ">=", "text": "ģ��ƥ��" }]; //����

$(function(){
	initDefault();
	initClick();
	initCombox();
	initTab();
})
/// ҩƷ����
function InitDrugType(){
	
	var drugType = getParam("DrugType");	
	return drugType;

}

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

	$("#keyword").combobox("textbox").keyup(function(e){
		if (e.keyCode == 13){
			search();
		}
	}); 
	
	addCondition(); //xww 2021-08-10
}

function initDefault(){
	//$('#searchTab').tabs('select', 'ȫ��ҩƷ����');
	version = getParam("Version");	
	selectSecondMenuFirst();
	resize();
}
function resize(){
	
	return;
	//var iframeHeight=$("iframe:visible").contents().find("body").height()+60
	var iframeHeight=$("iframe:visible").contents().find(".body-wrapper").height()+60
	var screenHeight=window.screen.availHeight;   //��Ļ���ø߶� 
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
	var code = $(".sort-2-list-title:visible").first().attr("code");
	selectSecondMenu(dic,code);
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
	    	 selectSecondMenu($(this).attr("dic"),$(this).attr("code"));
    });
     
	$(".search-tab-hd").find("li").on('click',function(){
		$(".search-tab-hd").find("li").removeClass("curr");
		$(this).addClass("curr");
		var selectTitle = $(this).attr("data-value");

		$("#searchInfo").hide();
		//kml
		if((selectTitle=="7")||(selectTitle=="5")||(selectTitle=="6")){
			$("#searchBox").hide();
			$("#checkBox").show();
			$("#checkTab").show();
			$("#searchText").hide();
			$("#condTd").hide();
		}else if ((selectTitle == "2")||(selectTitle == "3")||(selectTitle == "9")){	// ��Ӧ֢,����֢
			$("#searchBox").hide();
			$("#checkBox").hide();
			$("#checkTab").hide();
			$("#condTd").hide();
			$("#searchText").show();
		}else if ((selectTitle == "8")){	// ����ҩƷ������ʾ��Ϣ��ѯ
			$("#searchBox").hide();
			$("#checkBox").hide();
			$("#checkTab").hide();
			$("#searchText").hide();
			$("#searchInfo").show();			
		}
		else{
			$("#searchBox").show();
			$("#checkBox").hide();
			$("#checkTab").hide();
			$("#searchText").hide();
			$("#condTd").hide();
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
		
	$("#btQuotation").on('click',function(){		//��ѯȫ��ҩƷ
		if ($('#searchTab').tabs('exists', "�±�ҩ��ѧ����")){
			$('#searchTab').tabs('select', "�±�ҩ��ѧ����");
			return;
		}
		var NewDrugCatId=serverCall("web.DHCCKKBIndex","getDrugCatId");
		var url="dhcckb.index.table.csp?catId="+NewDrugCatId
		addTab("�±�ҩ��ѧ����",url);
	})
	
	$("#checkBtn").on('click',function(){
	    searchNew();
	})
	$("#checkTab").on('click',function(){
	    searchNew();
	})
	
	
	$("#searchInputInfo").keyup(function(event){  
          if(event.keyCode ==13){  
				search();
          }  
    });
   	$("#searchInfoText").on('click',function(){
	    search();
	})

}
function searchNew(){
     var keyword = $('#drugOne').combobox('getText'); //combogrodȡֵ
     var drugOther = $('#drugOther').combobox('getText'); //combogrodȡֵ
   	 if(keyword!=""){
			   	keywordNew=keyword.replace(/[%]/g,"%25") //�����ַ����� kml 2020-03-02
			   	DrugOtherNew=drugOther.replace(/[%]/g,"%25") //�����ַ����� wx 2020-11-24
			   	var queryType=$(".search-tab-hd .curr").attr("data-value");
		     addTab(keyword,"dhcckb.index.list.csp?input="+keywordNew+"&inputType="+queryType+"&drugOther="+DrugOtherNew+"&version="+version);	// ����versison qnp 2021/5/19	   
     }else{
	 	    $.messager.popover({msg: '���������ݣ�',type:'success',timeout: 1000});    
	    }
}


function search(){
	var keyword="";
	 var queryType=$(".search-tab-hd .curr").attr("data-value");
	 var ParStr="";
	 if ((queryType == 2)||(queryType == 3)||(queryType == 9)){
		keyword=$("#keywordText").val();
	}else if(queryType == 8){
		keyword = $("#searchInputInfo").val();
		ParStr=getParStr();
		ParStr=encodeURI(encodeURI(ParStr))
	}
	else{
		keyword = $('#keyword').combobox('getText'); //combogrodȡֵ
		
	}
	var gennamedr=$('#keyword').combobox('getValue');
	if((keyword.length<2)&&(queryType!= 8)){
		$.messager.alert("��ʾ","�������������ϵ����֣�")
		return;
		}
     //var keyword=$("#keyword").val();
     // var keyword = $('#keyword').combogrid('getValue'); //combogrodȡֵ
   	 if(keyword!=""){
	   	keywordNew=keyword.replace(/[%]/g,"%25") //�����ַ����� kml 2020-03-02
	   	//var queryType=$(".search-tab-hd .curr").attr("data-value");

     addTab(keywordNew,"dhcckb.index.list.csp?input="+keywordNew+"&inputType="+queryType+"&version="+version+"&drugType="+InitDrugType()+"&ParStr="+ParStr+"&gennamedr="+gennamedr);	   
     }else if((queryType == 8)&&(ParStr!="")){
		keywordNew=keyword.replace(/[%]/g,"%25") //�����ַ����� kml 2020-03-02
		addTab(keywordNew,"dhcckb.index.list.csp?input="+keywordNew+"&inputType="+queryType+"&version="+version+"&drugType="+InitDrugType()+"&ParStr="+ParStr);	   
	}
     else{
	 	$.messager.popover({msg: '���������ݣ�',type:'success',timeout: 1000});    
	 }
}
function selectSecondMenu(dic,code){
	var titleObj=$("div[dic="+dic+"]");
	$('.sort-2-list-title').removeClass('sort-2-list-title-selected')
    $(titleObj).addClass('sort-2-list-title-selected')
	$(titleObj).show();
	$.get(
	  "dhcapp.broker.csp",
	  {
	 		ClassName:"web.DHCCKKBIndex",
  			MethodName:"CatLev3ToHTML",
  			parref:dic,
  			code:code
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

function goTable(obj,code){
	var dic=$(obj).attr("data-id");
	var title=$(obj).attr("data-title");
	var url="dhcckb.index.table.csp?catId="+dic+"&code="+encodeURI(code)
	addTab(title,url);
}
///����tabs �� title
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
	$.messager.alert("��ʾ","δ������ҩƷ")
	$("#searchTab").tabs('close',title);
	}
function initCombox(){
	$("#keyword").combobox({
		valueField:'value',
	    textField:'text',
	    fit: true,//�Զ���С 
	    width:500, 
	    height:40,
		mode:'remote', 
		enterNullValueClear:false,	
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryContrastComgridNew&input='+"&drugType="+InitDrugType(),
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
	$("#drugOne").combobox({
		valueField:'value',
	    textField:'text',
	    fit: true,//�Զ���С 
	    width:240, 
	    height:40,
		mode:'remote', 	
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryContrastComgridNew&input=',
		onSelect:function(rowData) {
			var val = rowData.text.replace("<span style='color:#018EE8'>", '');
			val =val.replace("</span>", '');
			$("#drugOne").combobox("setText",val)
		},
		onBeforeLoad:function(param){
				var value = $('#drugOne').combobox("getText")
				if(value.length<2) {
					param.input=""
					
				}else{					
					param.input=value
					}
			}
		  }

	)
	$("#drugOther").combobox({
		valueField:'value',
	    textField:'text',
	    fit: true,//�Զ���С 
	    width:240, 
	    height:40,
		mode:'remote', 	
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryContrastComgridNew&input=',
		onSelect:function(rowData) {
			var val = rowData.text.replace("<span style='color:#018EE8'>", '');
			val =val.replace("</span>", '');
			$("#drugOther").combobox("setText",val)
		},
		onBeforeLoad:function(param){
				var value = $('#drugOther').combobox("getText")
				if(value.length<2) {
					param.input=""
					
				}else{					
					param.input=value
					}
			}
		  }

	)

}


//xww 2021-08-10 
// ������
function addCondition(){
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:5px;padding-right:5px;">��ѯ����</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	//html+='<span style="padding-left:10px;" ><b>����</b></span>'
	html+='<span style="padding-left:10px;" ><input id="QueCond'+curCondRow+"-"+1+'" style="width:120" type="text" class="textbox"/></span>';
	//html+='<span style="padding-left:10px;" id="condTd">�߼���ϵ<input id="condCombox'+curCondRow+"-"+1+'" style="width:70"/></span>'
	html+='</td><td style="padding-left:10px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>������</span></td>>';
	if(curCondRow==2){
		html+='</td><td style="padding-left:10px"><span style="cursor: pointer" onclick="clearCond('+curCondRow+')"><span  class="icon icon-clear" >&nbsp;&nbsp;&nbsp;&nbsp;</span>�������</span></td></tr>';
	}
	if(curCondRow>2){
		html+='</td><td style="padding-left:10px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>ɾ����</span></td></tr>';
	}
	$("#condTd").append(html);
	//����
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	//����ֵ
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryDrugLibaryData',
		valueField: 'value',
		textField: 'text',
		//blurValidValue:true,
		onSelect:function(option) {
			
		}
		
	})
	//�߼���ϵ
	$("input[id^=condCombox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//setHeight();
}
// ɾ����
function removeCond(row){
	$("#"+row+"Tr").remove();
}

// ��ѯ���� ��������
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span>'
	html+='<input id="LookUp'+key+'" style="width:120;" class="easyui-combobox" />'	
	html+='</span>'
	return html;
}

// �������
function clearCond(row){
	$("#LookUp2-1").combobox('setValue',"");
	$("#stateBox2-1").combobox('setValue',"")
	$("#QueCond2-1").val("")
	for(var i=3;i<=curCondRow;i++){
		$("#"+i+"Tr").remove();   // ɾ���������
	}
}
// �������
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}


function toggleExecInfo(obj){
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html($g("�����ѯ"));
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html($g("����"));
		$("#condTd").show();
	}
	//setHeight();
}


// ��ȡ��ѯ�����ַ���
function getParStr(){
	var retArr=[];
	var cond="";
	$("#condTd").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// ��������ֵ������ ���룩
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		// �ж����� ����ֵ�����ڣ�С�ڣ�
		var op=$(obj).children().eq(2).find("input")[2];
		if(op!=undefined){
			op=op.value;
		}else{
			op="";
		}
		// �����ж�ֵ ����������ݣ�
		var columnValue=$(obj).children().eq(3).find("input")[0].value;
		if(columnValue==""){
			return true;
		}
		//var cond=$(obj).children().eq(4).find("input")[0].value;  //$("#condCombox").combobox('getValue');
		// ��_$c(1)_ֵ_$c(1)_�ж�����_$c(1)_�߼���ϵ
		var par=column;
		par+="$$"+columnValue;
		par+="$$"+op;
		par+="$$"+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}