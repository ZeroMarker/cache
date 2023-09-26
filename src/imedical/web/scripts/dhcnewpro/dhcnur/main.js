var exeDate=new Date().Format("yyyy-MM-dd");
var exeStDate=new Date().Format("yyyy-MM-dd");
var exeEdDate=new Date().Format("yyyy-MM-dd");
var EpisodeID=""
data=serverCall("web.DHCEMCommonUtil","DateFormat",{})  //hxy 2017-03-08 日期格式走配置	
if(data==4){
    var exeDate=new Date().Format("dd/MM/yyyy");
    var exeStDate=new Date().Format("dd/MM/yyyy");
    var exeEdDate=new Date().Format("dd/MM/yyyy");
}
		
$(document).ready(function() {
	getTabHtByHidePanel();
		
    initMethod();   //初始化绑定方法
	
    initDatagrid();  //初始化table
    
    initShowPage();  //QQA 初始化显示界面
    
    initPatInfo();
    
    setInterval('checkPatTestTime()',5000);
   
});

function initPatInfo(){
	var paadm = $("#EpisodeID").val();	
	if(paadm!=""){
		selectTest(paadm);
	}
}

function initDatagrid(){
	$('#patTable').dhccTable({
	    height:tableHeight,
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
	    pagination:false,
		pageSize:20, 
		//url:'dhcapp.broker.csp?ClassName=web.DHCEMPat&MethodName=QueryPat&Loc='+$("#Loc").val()+'&adm='+$("#EpisodeID").val()+'&EmPatNo='+$("#MainRegno").val()+'&Level'+$("#Level").val(),
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPat&MethodName=QueryPat',
        columns: [
        {
            field: 'ff',
            formatter:'patFormatter'
        }],
        onLoadSuccess:function(data){
	        total=data.total;
			$("#patPanel .btn-group-justified .btn-mint").html(data.levelFour)
			$("#patPanel  .btn-group-justified .btn-warning").html(data.levelThree)
			$("#patPanel  .btn-group-justified .btn-danger").html(data.levelOne)
			title=data.locDesc
			$("#patListTitle").html(title+"("+total+")");
	    },
	    onClickRow:function(row, $element, field){
		    $("#nuraddorder-iframe").attr("src","dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE") //hxy 2017-03-27
		    $("#EpisodeID").val(row.EpisodeID)
		    setPatInfo(row);
			loadFrame(row);
		}
    });
    
    
	
	$('#patTestTable').dhccTable({
		height:tableHeight,
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:10,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
		clickToSelect:true,
		singleSelect:true,
        columns: [
        {
            field: 'select',
            checkbox:true,
            title:'选择',
            width:50
        },{
            field: 'ID',
            formatter:'testFormater',
			cellStyle:'testCellStyle'
        }],
        
        onLoadSuccess:function(data){
	        total=data.total
			$("#patTestTitle").html("皮试("+total+")")
			setTableHeightByPagination('#patTestTable');
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    
    serverName=GetComputerName();
    serverDesc = GetServerDesc(serverName);   //qqa 2017-09-08 获取数字媒体信息
    $('#patTreatTable').dhccTable({
	    height:tableHeight,
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:10,
		clickToSelect:true,
		singleSelect:true,
		url:'dhcapp.broker.csp?ClassName=web.DHCNurTreatQueue&MethodName=FindTreatPat&IsQuery=Y&seatFlag=2&serverIP='+serverName,
        columns: [
        {
            field: 'select',
            checkbox:true,
            title:'选择',
            width:50
        },
        {
            field: 'QueueNo',
            formatter:'treatFormater',
            width:200
        }],
        
        onLoadSuccess:function(data){
	        
	        total=data.total;
	        //$("#serverDesc").html(data.serverDesc)
	        $("#serverDesc").html(serverDesc.split("^")[0])
			$("#patTreatTitle").html("治疗("+total+")")
			if($("#EpisodeID").val()==""){
				if(total>0){
					
				}
			}
			setTableHeightByPagination('#patTreatTable');
			
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    $('#patSYTable').dhccTable({
	    height:tableHeight,
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:5,
		clickToSelect:true,
		singleSelect:true,
		url:'dhcapp.broker.csp?ClassName=web.DHCNurTreatQueue&MethodName=FindTreatPat&serverIP='+serverName+"&ifSYCall=1&IsQuery=Y&seatFlag=3",
        columns: [
        {
            field: 'select',
            checkbox:true,
            title:'选择',
            width:50
        },
        {
            field: 'QueueNo',
            formatter:'treatFormater',
            width:200
        }],
        
        onLoadSuccess:function(data){
	        
	        total=data.total;
			$("#patSyTitle").html("输液("+total+")")
			setTableHeightByPagination('#patSYTable');
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    //selectTest(row.EpisodeID)
		    		runClassMethod("web.DHCEMPat",
					"GetPatInfo",
					{'EpisodeID':row.EpisodeID},
					function(data){
							setPatInfo(data,1);
							$(".J_menuTab").each(function(){
								$(this).attr("data-regno",data.CardNo);
								$(this).attr("data-allergyflag",data.Allgryflag); //2016-10-27 congyue添加allergyflag
							})
							csp=$("iframe:visible").data("id")+"?RegNo="+data.CardNo+"&Allgryflag="+data.Allgryflag  //2016-10-27 congyue添加allergyflag
							$("iframe:visible").attr("src",csp)	
					},
					"json")	
		}
    });	
}

function initMethod(){
	$('#MainRegno').bind('keypress',GetCardPatInfoMain); //add by Ylp 
    
	$(".theadvice").on('click',function(){	
		theadvice();
	});
	$(".checkresult").on('click',function(){	
		checkresult();
	});
	$(".inspection").on('click',function(){	
		inspection();
	});	
	$("#showSelect").mouseenter(function(){
    	$("#selectFind").show();
    });
	$("#showSelect").on('click',function(){	
		$("#selectFind").show();	
	});	
  	$("#selectFind").mouseleave(function(){
        $("#selectFind").hide();
    });

	$("#patPanel .btn-group-justified .btn-mint").on('click',function(){
		$("#Level").val("4");
		$("#EpisodeID").val("");
		$("#MainRegno").val("");
		queryPatList();
	});
	$("#patPanel .btn-group-justified .btn-warning").on('click',function(){
		$("#Level").val("3");
		$("#EpisodeID").val("");
		$("#MainRegno").val("");
		queryPatList();
	})
	$("#patPanel .btn-group-justified .btn-danger").on('click',function(){
		$("#Level").val("1");
		$("#EpisodeID").val("");
		$("#MainRegno").val("");
		queryPatList();
	})		
	
	$("#main-push").click(function(){ //hxy 护士补录医嘱推出
	  $("#main-push-con").show();
	  $("#nuraddorder-iframe").attr("src","dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE") //hxy 2017-03-27
	  //$(window.frames["nuraddorder-iframe"].document).find("#nuraddorder-title").css("display","none"); //hxy 2017-03-30
	});
	  
	//hxy add 2016-09-20 
	$('#tooltip').mouseover(function() { 
 		$(this).tooltip('show'); 
 	 })
	$("#topclose").on('click',function(){	
		$("#showTop").hide();		
	});
	
	$("#refreshPat").on('click',function(){searchPat()});
}

//
function initShowPage(){
	csp=$("iframe:visible").data("id"); //hxy 2017-03-27	
    $("iframe:visible").attr("src",csp);	//hxy 2017-03-27   
}


function checkPatTestTime(){
	runClassMethod("web.DHCEMSkinTest",
					"GetSkinTestPat",
					{'limit':999,'offset':0},
					function(data){
						html="";
						count=0
						html=html+"<table class='table table-hover table-vcenter'>"
						html=html+"	<tbody>"
						$.each(data.rows,function(n,value){
							if((value.ToObserveTime=="0秒")||(value.ToObserveTime=="")){
								count=count+1;
								html=html+"<tr onClick='selectTest("+value.EpisodeID+")'><td>"+value.PatName+"</td></tr>"
							}
						})
						html=html+"	</tbody>"
						html=html+"</table>"

						if(count==0){
							return;
						}
						option={
							title:'皮试提醒',
					  		type: 1,
					  		shadeClose: true,
					  		shade: false,
					  		area: ['240px','185px'],
					  		offset:'rb',
					  		time:5000,
						    content: html

						}
						window.layer.open(option);	
						
					},
					"json",false)	 
 

}
function selectTest(EpisodeID){
	    
		runClassMethod("web.DHCEMPat",
			"GetPatInfo",
			{'EpisodeID':EpisodeID},
			function(data){
				setPatInfo(data);
				loadFrame(data);
			},
			"json")	
}
//hxy add 2017-02-22
function rightshow(){
	$("#goright").show();
}
//hxy add 2017-02-22
function righthidden(){
	$("#goright").hide();
}
//hxy add 2016-09-20 
function showTop(){
	$("#showTop").show();
}

//hxy add start
function theadvice(obj){
	option={
		title:'本次医嘱',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['1150px','100%'],
	    content: 'dhcem.onlyadvice.csp?EpisodeID='+$('#EpisodeID').val() //iframe的url

	}
	window.layer.open(option);	
}

function checkresult(){
	option={
		title:'检查结果',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['1150px','100%'],
	    //content: 'dhcem.check.csp?RegNo='+$('#RegNo').val() //iframe的url
	    content: 'dhcem.check.csp?EpisodeID='+$('#EpisodeID').val() 

	}
	window.layer.open(option);
}

function inspection(){
	option={
		title:'检验结果',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['1150px','100%'],
	    content: 'dhcem.patcheckout.CSP?EpisodeID='+$('#EpisodeID').val() //iframe的url

	}
	window.layer.open(option);
	
}
//hxy add end 

function patFormatter(value, rowData) {
		var Allgryflag="";//2016-10-25 congyue
		
    	var htmlstr =  '<div class="celllabels" onclick="add(this)"><span class="CardName">'+ rowData.PatName +'</span><span class="patInfo" ><span>'+ rowData.Sex +'/'+ rowData.Age +'</span></span><br>';
		
		htmlstr = htmlstr + '<div class="patID">ID:'+ rowData.CardNo +'</div><div style="float:right">';
		level="";
		levelflag="0"
		if(rowData.NurseLevel>0){
			levelflag="1"
			level=rowData.NurseLevel+"级";
			classstyle="color: #18bc9c";
			if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
			if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<div style="float:right;font-size:14px;margin-top: -1px;margin-right: 2px;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px;">'+level+'</span></div>';
		}
		if(rowData.Allgryflag==1)//2016-10-25 congyue 
		{
			if(levelflag=="1"){
				Allgryflag="敏";
				htmlstr = htmlstr+'<div style="float:left;margin: -3px 3px 0px 36px;"><span class="badge sensBar" ><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+Allgryflag+'</a></div></span></div></div>';
			}else{
				htmlstr = htmlstr+'<div style="float:left;margin: -3px 3px 0px 36px;"><span class="badge sensBar" style="margin-right: 26px"><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+"敏"+'</a></div></span></div></div>';
				}
		} 
		htmlstr = htmlstr+'</div></div>'
		return htmlstr;
}
function testFormater(value, rowData){
	    var htmlstr =  '<div class="celllabels"><span class="CardName " onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.TestStartTime +"/"+rowData.TestTime+'</span></span><br>';
		htmlstr = htmlstr + '<div class="patID" style="float:left">ID:'+ rowData.RegNo +'</div';
		classstyle="color: #18bc9c";
		level=rowData.ToObserveTime
		htmlstr = htmlstr +'<div style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
		return htmlstr;
	
}
function treatFormater(value,rowData){
		var htmlstr =  '<div class="celllabels"><span class="CardName " onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState +"/"+rowData.QueuePrior+'</span></span><br>';
		htmlstr = htmlstr + '<div class="patID" style="float:left">排队号:'+ rowData.QueueNo +'</div>';
		classstyle="color: #18bc9c";
		level=rowData.ClientName
		htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
		return htmlstr;
}
///查询全部病人列表
function searchPat(){
	$("#Loc").val('SEAT');
	$("#EpisodeID").val("");
	$("#Level").val("");
	$("#MainRegno").val("");
	queryPatList();
}
var htmlStrDivl=""
function setPatInfo(row,flag){
	$("#patInfo-diagnos a").html("");
	var str='<div style="float:left;padding-left: 12px;"><a style="padding-left: 10px;padding-right: 0px;color:#333;cursor:pointer" id="tooltip" class="tooltip-show"  data-placement="bottom" title="' +row.diagnos+'">'
	if(row.Sex=="男")
	{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;" src="../scripts/dhcnewpro/images/nursemano.png" />'
	}else if(row.Sex=="女")
	{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nursewomano.png" />'
	}else{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nurseunmano.png" />'
		}
	str=str+'</a></div><div style="padding-top:4px;font-size:16px;color:#000;margin-top:6px;float:left;margin-right:8px;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:65px;">'+row.PatName+'</div>'
	$("#patInfo-name ").html(str)
	var levelstr="",lev="未分"
	classstyle="color: #18bc9c";
	classtext="未分"
	if(row.NurseLevel==3) {classstyle="color: #ffb746";classtext="黄区";lev=3};
	if(row.NurseLevel==1) {classstyle="color: #ff6248";classtext="红区";lev=1};
	if(row.NurseLevel==2) {classstyle="color: #ff6248";classtext="红区";lev=2};
	if(row.NurseLevel==4) {classstyle="color: #2ab66a";classtext="绿区";lev=4};
	
	levelstr=levelstr+'<div class="badge " style="float:left;background-'+classstyle+';margin: 0px 0px 2px 2px; border-radius: 5px;height:20px;width:28px;padding-top:4px;"><span style="font-size: 12px;margin-left:-5px">'+classtext+'</span></div>'

	levelstr=levelstr+'<div style="margin-top:2px;margin-left:10px;float:left"><span style="'+classstyle+'">'+lev+"级 /"+row.SeatNo+'</span></div>'
	$("#patInfo-lev a").html(levelstr)
	htmlStrDiv='<div style="margin-top:4px;float:left; min-width: 300px;padding-bottom: 5px;font-size:12px;color:#333">'+row.Sex+'<span class="patother">|</span>'
	htmlStrDiv=htmlStrDiv+row.Age+'<span class="patother">|</span>'
	htmlStrDiv=htmlStrDiv+"ID:"+row.CardNo+'<span class="patother">|</span>'
	htmlStrDiv=htmlStrDiv+row.admreason+'<span class="patother">|</span>'
	htmlStrDiv=htmlStrDiv+row.UpdateDate+'<span class="patother">|</span>'
	htmlStrDiv=htmlStrDiv+row.UpdateTime+'</div>'
	var htmlStrDivDiagnos=""
	if(row.diagnos!=""){
	//htmlStrDivDiagnos='<div  id="diagnos"  style="float:left;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:150px;font-size:12px;color:#333"><span class="patother" >|</span>'+row.diagnos+'</div>'
	//htmlStrDivDiagnos='<div  onmouseover="overShow()" onmouseout="outHide()" style="float:left;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:150px;font-size:12px;color:#333"><span class="patother" >|</span>'+row.diagnos+'</div>'
	htmlStrDivDiagnos=htmlStrDivDiagnos+'<span class="patother" style="padding-left: 2px; margin-top: 0px; margin-bottom: -20px; float: left;">|</span><div style="margin-left: 5px;float:left;padding-left: 9px;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:90px;font-size:12px;;margin-top:2px;"><a id="tooltip" class="tooltip-show"  data-placement="bottom" title="'+row.diagnos+'" style="color:#333;cursor:pointer">'+row.diagnos+'</a></div>'
	//htmlStrDivl=""
	//$("#patInfo-diagnos a").html(htmlStrDivDiagnos);

	//htmlStrDivl=htmlStrDivl+'<div class="showdivText" >诊断 : '+row.diagnos+row.diagnos+row.diagnos+row.diagnos+'</div>';
	}
	
	$("#patInfo-other a").html(htmlStrDiv);
	$('#tooltip').mouseover(function() { 

 		$(this).tooltip('show'); 
		
 	 })
	//$("#tooltip").tooltip("");

	//showDiv.innerHTML = htmlStrDivl;   //QQA
	
	
	//setERPMenu();
	try{
		
		var frm=window.parent.document.forms["fEPRMENU"];
		if(frm.EpisodeID){
			frm.EpisodeID.value=row.EpisodeID;
			frm.PatientID.value=row.Papmidr
			if(($("#patListTitle").html()).indexOf("座位")>-1){
				frm.EpisodeID.value="";
				frm.PatientID.value=="";
			}
			if(flag==1){
				frm.EpisodeID.value="";
				frm.PatientID.value=="";
			}
		}
		
	}catch(e){
		//alert(e.message)
	}
	
}
function loadFrame(row){
	adm=row.EpisodeID
	if(($("#patListTitle").html()).indexOf("座位")>-1){
		adm="";
	}
	$(".J_menuTab").each(function(){
		$(this).attr("data-regno",row.CardNo);
		$(this).attr("data-episodeid",adm);
		$(this).attr("data-allergyflag",row.Allgryflag); //2016-10-27 congyue添加allergyflag
		$(this).attr("data-patdr",row.Papmidr);   //病人ID
	})
	csp=$("iframe:visible").data("id")+"?RegNo="+row.CardNo+"&EpisodeID="+adm+"&Allgryflag="+row.Allgryflag+"&PatientID="+row.Papmidr  //2016-10-27 congyue添加allergyflag
	//$("iframe:visible").attr("src",csp)	//hxy 2017-03-27
	$("iframe:visible").not("#nuraddorder-iframe").attr("src",csp)	//hxy 2017-03-27
	return ;
} 
function searchByType(obj){
	$("#Loc").val($(obj).attr("data-id"))
	$("#LocDesc").val($(obj).html())
	$("#EpisodeID").val('')
	queryPatList()
}

function changeWard(obj){
	ward=$(obj).attr("data-id");
	adm=$("#EpisodeID").val();
	var patName = $("#patInfo-name div:last").text();
	ret=serverCall("web.DHCEMTransfer","CheckBeforeTransfer",{AdmId:adm,PAAdmWard:ward})
	if(ret!=1){
		dhccBox.alert(ret)
		return;
	}
	xx=$(obj).find('span').html()
	str='确认把'
	str=str+'<span style="color:red">'+patName+'</span>';
	str=str+'转到';
	str=str+'<span style="color:red">'+xx+'</span>';
	str=str+'吗？';
	dhccBox.confirm("提示",str,"",function(result){
		if(result){
			runClassMethod("web.DHCEMTransfer","WardUpdateTransfer",{AdmIdStr:adm,PAAdmWard:ward},function(data){
				if(data==0){
					dhccBox.message({
							message : '修改成功!'
					})
					queryPatList()
				}else{
					dhccBox.alert("操作失败:"+data)
				}
			})
		}
	})
 }
 
function queryPatList(){
	/*
	$('#patTable').dhccQuery(
		{query:
			{
				ClassName:'web.DHCEMPat',
				MethodName:'QueryPat',
				Loc:$("#Loc").val(),
				adm:$("#EpisodeID").val(),
				EmPatNo:$("#MainRegno").val(),
				Level:$("#Level").val()
			}
		})
	
	*/
	$("#patTable").bootstrapTable('refresh',  
		{
			'query':{
				 Loc:$("#Loc").val(),
				 adm:$("#EpisodeID").val(),
				 EmPatNo:$("#MainRegno").val(),
				 Level:$("#Level").val()
			}
	}); 
	
	//$('#patTable').bootstrapTable('resetView',{ height: tableHeight-40} );
}
function searchPatTest(){
	$('#patTestTable').dhccQuery()
}
function searchPatTreat(){
	$('#patTreatTable').dhccQuery()
}
function searchPatSY(){
	$('#patSYTable').dhccQuery()
}
//2016-10-26 congyue 点击"敏"字加载过敏录入
function gotoAllery(CardNo,EpisodeID){
	$(".J_menuTab").each(function(){
		$(this).attr("data-regno",CardNo);
		$(this).attr("data-episodeid",EpisodeID);
		if ($(this).attr("data-id")=="dhcem.allergyenter.csp"){
			
			$(this).addClass("active");
		}else{
			$(this).removeClass("active");
		}
	})
	$(".J_iframe").each(function(){
		if ($(this).attr("data-id")=="dhcem.allergyenter.csp"){
			$(this).show().siblings(".J_iframe").hide();//("active");
			$(this).addClass("active").siblings(".J_menuTab").removeClass("active");
			csp=$("iframe:visible").data("id")+"?RegNo="+CardNo+"&EpisodeID="+EpisodeID;
			$("iframe:visible").attr("src",csp);
		}
	})
}
/*鼠标悬停 2016-12-01 add by Ylp*/ 
 function overShow() {
  var showDiv = document.getElementById('showDiv');
  showDiv.style.left = event.clientX;
  showDiv.style.top = event.clientY;
  showDiv.style.display = 'block';
 }
 
 function outHide() {
  var showDiv = document.getElementById('showDiv');
  showDiv.style.display = 'none';
 }

//病人列表登记号查询  add by Ylp
function GetCardPatInfoMain(e){
	 if(e.keyCode == 13){
		var Regno = $("#MainRegno").val();
		var MRegno = $("#MainRegno").val();
		var Regno = GetWholePatNo(Regno);      ///  登记号补0				
		$("#MainRegno").val(Regno);
		queryPatList();	
		return;
	}
}
//病人列表登记号查询 按钮 add by Ylp
function GetCardPatInfoOnMain(){
	 	
		var Regno = $("#MainRegno").val();
		var MRegno = $("#MainRegno").val();
		var Regno = GetWholePatNo(Regno);///  登记号补0
		if(Regno==""){
			//alert("清空！");
			//$("#MainRegno").val("");   //qqa 2017-10-11 登记号输入不对清空搜索栏
			//return ;
		}else{
			$("#MainRegno").val(Regno);
		}
		queryPatList(Regno);
		
}
///补0病人登记号 add by Ylp
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return "";    //qqa 改变原来不存在返回值
	}
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			dhccBox.alert("登记号输入错误,请重新输入！");
			EmPatNo="";
		}
		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)	
	return EmPatNo;
}

//治疗队列优先
function Prior(tableId){
	TreatId=checkTreatPat(tableId)

	if(TreatId==""){
		return;
	}
	dhccBox.confirm("提示","请再次确认是否将病人优先?","TreatPrior",function(){
		updateTreatQue(TreatId,1)
	})	
}

//治疗队列过号
function SkipNum(tableId)
{
	TreatId=checkTreatPat(tableId)
	if(TreatId==""){
		return;
	}
	dhccBox.confirm("提示","请再次确认是否将病人过号?","TreatSkipNum",function(){
		updateTreatQue(TreatId,3,"Skip")
	})
}

//皮试队列撤销
function revocation(){
	
	data=$("#patTestTable").dhccTableM("getSelections");
	if(data.length==0){
		parent.dhccBox.message({
			type: 'danger',
		    message : '请选择需要撤销的病人!'
		})
		return;
	}
	
	dhccBox.confirm("提示","请再次确认是否撤销记录?","main-revocation",function(result){
		ret=serverCall("User.DHCNurSkinTestList","Delete",{id:data[0].ID})
		if(ret){
			dhccBox.message({
					message : '撤销成功!'
			})
			
			searchPatTest();  //刷新皮试列表
		}
	})
	
	
}


//治疗队列到达
function Arrive(tableId){
	TreatId=checkTreatPat(tableId)
	if(TreatId==""){
		return;
	}
	dhccBox.confirm("提示","请再次确认是否将病人到达?","TreatSkipNum",function(){
		updateTreatQue(TreatId,2,"Finish")
	})
}
//下一个
function CallNext(tableId){
	
	datas=$("#"+tableId).dhccTableM("getData");
	
	for(var i=0;i<datas.length;i++){
		if(datas[i].QueueState!="呼叫"){
			DHCAMSCall(i,tableId);
			break;	
		}
	}
	
}
//叫号
function Call(tableId){
	select=$("#"+tableId).dhccTableM("getSelections")[0];
	if($("#"+tableId).dhccTableM("getSelections").length==0){
		dhccBox.message({ type: 'danger', message : '请选择病人!' })
		return ;
	}
	datas=$("#"+tableId) .dhccTableM("getData");
	for(var i=0;i<datas.length;i++){
		if(select.TreatId==datas[i].TreatId){
			DHCAMSCall(i)
			break;
		}
	}
	
}
function CallPat(obj){
	i=$(obj).parent().parent().parent().attr("data-index")
	tableId=$(obj).parent().parent().parent().parent().parent().attr("id")
	if("patTestTable"==tableId){
		CallTest(i,tableId)
	}else{
		DHCAMSCall(i,tableId)
	}
}
//皮试队列叫号
function CallTest(i,tableId){
	cn=GetComputerName();
	RowData=$("#"+tableId).dhccTableM("getData")[i];
	
	waitPatStr="^";
	ret=serverCall("web.DHCVISQueueManage","SendVoiceTestSkinQueue",{PatName:RowData.PatName,waitPatStr:waitPatStr,computerIP:cn})
	if(ret!="0")
	{
		dhccBox.alert(ret,"updateTreatQue");
	}
	else
	{	
		obj=new Object(); 
		obj.TestCallFlag="Y";
		obj.ID=RowData.ID;
		serverCall("web.DHCEMNurTreatQueue","saveOrUpdate",{tableName:"User.DHCNurSkinTestList",jsonStr:JSON.stringify(obj)})
	
	}
}
//治疗队列和输液队列叫号
function DHCAMSCall(i,tableId){
	cn=GetComputerName();
	RowData=$("#"+tableId).dhccTableM("getData")[i];

	var waitPatStr=GetWaitPat(i,tableId)
	var readyPatStr=""
	if(waitPatStr.split("^").length>1)
	{
		readyPatStr=waitPatStr.split("^")[1]
		waitPatStr=waitPatStr.split("^")[0]	
	}
	ret=serverCall("web.DHCVISQueueManage","SendVoiceCallTreatQueue",{QueNo:RowData.QueueNo,PatName:RowData.PatName,waitPatStr:waitPatStr,readyPatStr:readyPatStr,computerIP:cn})
	
	
	if(ret!="0")
	{	
		if(ret.indexOf("alert")!=-1){
			ret = ret.split("'")[1]	;
		}
		dhccBox.alert(ret,"updateTreatQue");
	}
	else
	{	
		
		updateTreatQue(RowData.TreatId,"","Call");
	}
}
function updateTreatQue(TreatId,Prior,State){
	
	obj=new Object();
	obj.TreatRecUser=LgUserID;
	obj.TreatQuePrior=Prior;
	obj.TreatQueState=State;
	obj.ID=TreatId;
	runClassMethod("web.DHCEMNurTreatQueue","saveOrUpdate",{tableName:"User.DHCNurTreatQueue",jsonStr:JSON.stringify(obj)},function(ret){
				if (ret != 0) {
					dhccBox.alert(ret,"updateTreatQue");
				}else{
					dhccBox.message({message : '操作成功!'})
					$("#patSYTable").dhccQuery();	
					$("#patTreatTable").dhccQuery();
				}
		
	},'text')
}
function checkTreatPat(tableId){
	data=$("#"+tableId).dhccTableM("getSelections");
	if(data.length==0){
		dhccBox.message({
				type: 'danger',
			    message : '请选择病人!'
		})
		return "";
	}
	return data[0].TreatId
}

function GetWaitPat(selrow,tableId)
{	

	cn=GetComputerName();
	datas=$("#"+tableId).dhccTableM("getData");
	var QueType=serverCall("web.DHCVISVoiceSet","GetServerQueType",{IPAddress:cn})
	if(QueType=="0") return "^"
	
	var WaitPat="",ReadyPat=""
	try
	{
		
		var startIndex=selrow+1
		var waitNum=2
		for(var i=startIndex;i<startIndex+waitNum;i++)
		{
			
			var Obj=datas[i];
			if(Obj)
			{
				var QueueState=Obj.QueueState
				
				if((QueueState!="完成")&&(QueueState!="呼叫"))
				{
					var PatName="",QueNo="",TreatId=""
					var TreatId=Obj.TreatId;
					PatName=Obj.PatName;
					QueNo=Obj.QueueNo;
					if(QueNo!="")
					{
						var State="Ready"
						if(QueueState=="等候")
						{
							var retStr=updateTreatQue(TreatId,"",State)
							if(ReadyPat=="") ReadyPat=QueNo+"号,"+PatName	
							else  ReadyPat=ReadyPat+"!"+QueNo+"号,"+PatName
						}
						if(WaitPat=="") WaitPat=QueNo+"号,"+PatName	
						else  WaitPat=WaitPat+"!"+QueNo+"号,"+PatName	
					}
				}
				else
				{
					waitNum=waitNum+1
				}
			}
			else
			{
				i=startIndex+waitNum
			}
		}
	}
	catch(e)
	{
		return "^"
	}
	return WaitPat+"^"+ReadyPat;
}
function add(e){
	$(".tdSelect").removeClass("tdSelect");
	$(e).parent().addClass("tdSelect");
	}

function GetComputerName() {
 	var computerName;
 	try {
 		var WshNetwork = new ActiveXObject("WScript.Network");
 		computerName = WshNetwork.ComputerName;
 		WshNetwork = null;
 	} catch (e) {
 		computerName = "";
 	}
 	//return "SCZX-03-PC";
 	return computerName;
}
function testCellStyle(value, row, index, field){
	opt={};
	if(row.CurStat=='Call'){
		opt={css: {"background-color":'green'}}
	}
	if((row.ToObserveTime=="0秒")||(row.ToObserveTime=="")){
		opt={css: {"background-color":'red'}}
	}
	return opt
}

function getTabHtByHidePanel(){
	var num=0;
	$('.panel-primary').each(function(){
		if(!$(this).is(":hidden")){
			num++;
		}
	})

	if(num=="1"){
		tableHeight = $(window).height()-87;
	}else if(num=="2"){
		tableHeight = $(window).height()-150;
	}else if(num=="3"){
		tableHeight = $(window).height()-155;;
	}
}

function setTableHeightByPagination(domIdStr){
	var pagIsHide = $(domIdStr).parents(".bootstrap-table").find(".fixed-table-pagination").find(".pagination").is(":hidden")
	if(!pagIsHide){
		$(domIdStr).bootstrapTable('resetView',{ height: tableHeight-40 } );	
	}
}

function GetServerDesc(serverName){
   return serverCall("web.DHCEMNurExe","GetClintServerNameByIP",{clientIP:serverName})
}