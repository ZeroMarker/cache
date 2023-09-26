
var EpisodeID=""
var RegNo="";
var map={};
var Papmidr=""//huaxy 2016/7/12
var startDate=(new Date()).Format("yyyy-MM-dd");
var endDate=(new Date()).Format("yyyy-MM-dd");
$(function(){

	   $('#tabs').tabs({   
                onSelect: function(){  
                    openTab();                                        
                }  
       }); 	
	   
	   var p = $('#datagrid').datagrid('getPager');
       $(p).pagination({
             displayMsg: '',
             beforePageText:'',
             afterPageText:'共	{pages} 页',
             showPageList:false

       });
        $('#datagrid').datagrid('getPager').pagination({ showRefresh: false});
       	$("#searcBTN").click(function(){
  		     
  			 search();

		});
		var txt = $(":input");

         
        txt.keyup(function(e){
        if(e.keyCode == 13)
            search();
  		});

});

function search(){
	
	EmPatNo=$.trim($("#EmPatNo").val());
	if(EmPatNo!=""){
			runClassMethod("web.DHCSTCNTSCOMMON","GetPatRegNoLen",{},function(jsonString){
					
					var patLen = jsonString;
					var plen = EmPatNo.length;
					if (EmPatNo.length > patLen){
						$.messager.alert('错误提示',"登记号输入错误！");
						return;
					}
					for (var i=1;i<=patLen-plen;i++){
							EmPatNo="0"+EmPatNo;  
					}
					$("#EmPatNo").val(EmPatNo)
					commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})	
			 })
	}else{
		commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})		
	}
	
}

/// 添加选项卡
function addTab(tabId,tabTitle){

    $('#tabs').tabs('add',{
	    id:tabId,
        title : tabTitle,
        content : createFrame(tabId)
    });
}

/// 创建框架
function createFrame(tbId){

	var content = '<iframe scrolling="auto" frameborder="0" src="' +getUrl(map[tbId])+'" style="width:100%;height:100%;"></iframe>';
	return content;
}
function selectPat(index,row){
	Papmidr=row.Papmidr//hxy 2016/7/12
	EpisodeID=row.EpisodeID
	RegNo=row.CardNo
	openTab()
	setPatInfo(row)	
}
/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){

	var htmlstr =  '<div class="celllabel"><h3 style="float:left">'+ rowData.PatName +'</h3><h3 style="float:right"><span>'+ rowData.Sex +'/'+ rowData.Age +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left">ID:'+ rowData.CardNo +'</h4>';
		classstyle="color: #18bc9c";
		if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
		if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
		level=""
		if(rowData.NurseLevel>0){
			level=rowData.NurseLevel+"级";
		}
		htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></h4></div>';
	return htmlstr;
}
function setPatInfo(row){
	$(".patInfo span:nth-child(1)").html(row.PatName)
	$(".patInfo span:nth-child(2)").html(row.NurseLevel+"级/"+row.SeatNo)
	htmlStr=row.Sex+"/"
	htmlStr=htmlStr+row.Age+"/"
	htmlStr=htmlStr+"ID:"+row.CardNo+"/"
	htmlStr=htmlStr+row.admreason+"/"
	htmlStr=htmlStr+row.diagnos+"/"
	htmlStr=htmlStr+row.UpdateDate+"/"
	htmlStr=htmlStr+row.UpdateTime
	$(".patInfo span:nth-child(3)").html(htmlStr)

} 
function openTab(){           
      var tab = $('#tabs').tabs('getSelected');
 
      var tbId = tab.attr("id");

      //获取tab的iframe对象  
      var tbIframe = $("#"+tbId+" iframe:first-child");  
      tbIframe.attr("src",getUrl(map[tbId]));  
 }
function getUrl(url){
	  if(url.indexOf("?")<0){
			url=url+"?EpisodeID="+EpisodeID+"&RegNo="+RegNo+"&startDate="+startDate+"&endDate="+endDate+"&PatientID="+Papmidr //huaxy 2016/7/12 add Papmidr
	  }else{
			url=url+"&EpisodeID="+EpisodeID+"&RegNo="+RegNo+"&startDate="+startDate+"&endDate="+endDate+"&PatientID="+Papmidr //huaxy 2016/7/12
	 } 
	 return url	
}
function onLoadSuccess(data){
	total=data.total
	$("#toolbar .btn-success").html(data.levelFour+"/"+total)
	$("#toolbar .btn-info").html(data.levelTwo+"/"+total)
	$("#toolbar .btn-warning").html(data.levelThree+"/"+total)
	$("#toolbar .btn-danger").html(data.levelOne+"/"+total)
	$(".panel-title").html("本科病人("+total+")")
	if(total<1){
		return;
	}
	$('#datagrid').datagrid('selectRow', 0);
	setPatInfo($('#datagrid').datagrid('getSelected'))
	$("#patList .btn").click(function(){
	    var Level;
		if($(this).hasClass("btn-success")){Level=4};
		//if($(this).hasClass("btn-info")){Level=2};
		if($(this).hasClass("btn-warning")){Level=3};
		if($(this).hasClass("btn-danger")){Level=1+"^"+2};
		$('#datagrid').datagrid('load',{'Level':Level});	
  	});
	if(EpisodeID!=""){
		EpisodeID=$('#datagrid').datagrid('getSelected').EpisodeID
		return;
	}
	EpisodeID=$('#datagrid').datagrid('getSelected').EpisodeID
	Papmidr=$('#datagrid').datagrid('getSelected').Papmidr//huaxy 2016/7/12
	runClassMethod( "web.DHCAPPChart", "ShowChartJson", {ChartBookID:ChartBookID},
	 				function(data){
		 				  $.each(data,function(i,value){
			 				    map[value.ChartID]=value.LinkUrl
								addTab(value.ChartID,value.ChartName,value.LinkUrl);
						  });
						  $("#tabs").tabs("select", 0);
						 
	});
}   


function setHeight(){
		var c = $('.easyui-layout');
		var p = c.layout('panel','west');	// get the center panel
		var oldHeight = p.panel('panel').outerHeight();
		p.panel('resize', {height:'auto'});
		var newHeight = p.panel('panel').outerHeight();
		c.layout('resize',{
				height: (c.height() + newHeight - oldHeight)
		});
}	