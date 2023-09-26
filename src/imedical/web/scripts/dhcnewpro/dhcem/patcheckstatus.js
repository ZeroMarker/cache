var EpisodeID="";         //医嘱ID
var UserId=LgUserID     //用户ID 
var columns= [
		{field: 'patVisitStat',title: '病人状态'},
		{field: 'statDate',title: '状态日期'},
		{field: 'statTime',title: '状态时间'},
		{field: 'admLocDesc',title: '病人科室'},
		{field: 'userDesc',title: '操作人'}, 
		{field: 'inWardDesc',title: '入院病区'},
		{field: 'patRegNo',title: '登记号'}, 
		{field: 'patientName',title: '姓名'}];
$(document).ready(function(){
		EpisodeID=51;
		initMe();
		$('#fromDate').dhccDate()	//开始日期样式
		$('#toDate').dhccDate()	//结束日期样式
		
		$('#Regno').bind('keypress',function(event){
        	if(event.keyCode == "13"){
            	RegNoBlur(); 
        	}
    	});
		
		//病人状态
		$('#visitStat').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatStatusQuery&MethodName=ListPsa"
		})
		
		//查找
		$('#find').click(function(){
			SearchClick();	
		})
		
		//清屏
		$('#clearScreen').click(function(){
			ClearScreen();	
		})
		
		$('#demo-editable').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:$(window).height()-120,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID=51'+'&fromDate='+""+'&toDate='+""+'&visitStat='+"",
        columns:columns,
        singleSelect:true
    }); 
})

//初始化数据
function initMe(){
		$('#EpisodeID').val(EpisodeID);	//就诊id
		var objRegNo=document.getElementById("Regno");	//登记号
		if (objRegNo){
			objRegNo.onblur=RegNoBlur;
	    	if ($('#EpisodeID').val()!=""){	//登记号
		  		var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':EpisodeID});
		   		if (retStr!=""){
			   		objRegNo.value=retStr;
			   		//preRegNo=retStr;
			   		BasPatinfo(retStr);
			   	}else {
			  		$('#EpisodeID').val("")
			  	}
	     }
	    var objSearch=document.getElementById("find");	//查找按钮
	    //if (objSearch){
		   // objSearch.onclick=SearchClick;
		 //}
    }   	 
}

//登记号失去焦点事件
function RegNoBlur()
{
    $('#patMainInfo').val("");
    var objRegNo=document.getElementById("Regno");
    var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':EpisodeID});
    if (objRegNo.value==retStr){
     	return;
    }
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    //for (i=0;i<8-oldLen;i++)
	    for (var i=0;i<10-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
    //preRegNo=objRegNo.value;
   	BasPatinfo(objRegNo.value);
    $("#EpisodeID").val("");
   	//Search(true);
}

//病人信息
function BasPatinfo(regNo)
{//    s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel
	//alert(regNo);
	if (regNo==""){
		return;
	}
 	var str=MyRunClassMethod("web.DHCEMPatStatusQuery","GetPatInfo",{'curId':regNo,'transLocNum':""});
   	if (str=="") return;
    var tem=str.split("^");
	$('#patMainInfo').val(tem[4]+","+tem[3]+","+tem[7])   //+t['val:yearsOld'] 
}

//查询事件
function SearchClick(){
	//var status=$("#visitStat option:selected").text();
	var status=$("#visitStat").val();
	var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':51});
		   if (retStr!=""){
			   	$('#Regno').val(retStr);
			   	//preRegNo=retStr;
			   	BasPatinfo(retStr);
			}
	$('#demo-editable').dhccQuery({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID=51'+'&fromDate='+""+'&toDate='+""+'&visitStat='+status
	})
	
}

//清屏事件
function ClearScreen()
{
	$('#Regno').val("");		//登记号
	//document.getElementById("CardNo").value="";
	$('#EpisodeID').val("");	//就诊id
	$('#patMainInfo').val("");	//病人信息
	$('#fromDate input').val("");	//开始日期
	$('#toDate input').val("");	//结束日期
	$('#visitStat').html("");	//病人状态
	$('#demo-editable').dhccQuery({
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID='+""+'&fromDate='+""+'&toDate='+""+'&visitStat='+""
    }); 
}
/// 直接执行方法返回回调函数返回的data值
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}









