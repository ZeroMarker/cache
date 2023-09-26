/// Creator: CongYue
/// CreateDate: 2016-03-29
/// Description: 后台管理评价
var url="dhcadv.repaction.csp";
var armaID="",RepID="",RepTypeDr="",EpisodeID="",RepType="";
$(function(){
	
    RepID=getParam("RepID");
    RepTypeDr=getParam("RepTypeDr");
    armaID=getParam("armaID");
   	assessID=getParam("AssessID");
   	RepType=getParam("RepType");

    if(assessID!=""){
         var AssessSave=document.getElementById("AssessSave");
         AssessSave.style.display='none'; //隐藏评估保存按钮  
	}
	var titlehtml="<span>"+RepType+"评价</span>"
	$('#asstitle').html(titlehtml);
 	
 	/* //所发生不良事件类别
	$('#MainCat').combobox({
		//panelHeight:'auto',  //设置容器高度自动增长
		url:url+'?action=SelMainCat',
		onSelect: function(rec){    
           var armaCatDr=rec.value;  
			Combobox(armaCatDr);        
			}
	}); */
	//处理办法
	$('#DealMethod').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelDealMethod&LgHospID='+LgHospID //hxy 2019-07-04 LgHospID
	});
	//改进办法
	$('#ImpMethod').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelImpMethod&LgHospID='+LgHospID //hxy 2019-07-04 LgHospID
	}); 
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
		});
	});
	//复选框分组
	InitUIStatus();
	RepManageInfo(RepID,RepTypeDr);
	textAreaListener(); //qunianpeng 2018/1/10 textarea输入框增加回车
})
///初始化界面复选框事件
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
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
/// 保存管理评价信息
function saveRepManage()
{
	///保存前,对页面必填项进行检查
	if(!saveBeforeCheck()){
		return;
	}
	//1、不良事件等级
	var adrlevel="";
    $("input[type=checkbox][name=adrlevel]").each(function(){
		if($(this).is(':checked')){
			adrlevel=this.value;
		}
	})
	
	if(adrlevel==""){
		$.messager.alert("提示:","【不良事件等级】不能为空！");
		return false;
	}
	 //2、所发生不良事件类别
	var MainCat=$('#MainCat').combobox('getValue');
	if (MainCat==undefined){
		MainCat=""
	} 
	/* if(MainCat==""){
		$.messager.alert("提示:","【不良事件类别】不能为空！");
		return false;
	} */
	
	//3、二级类别
	var SubCat=$('#SubCat').combobox('getValue');
	if (SubCat==undefined){
		SubCat=""
	}
	/* if(SubCat==""){
		$.messager.alert("提示:","【不良事件二级类别】不能为空！");
		return false;
	} */
	//4、处理办法
	var DealMethod=$('#DealMethod').combobox('getValue');   
	
	//5、改进办法
	var ImpMethod=$('#ImpMethod').combobox('getValue');   
	
	//6、不良事件评价
	var adrAdvice=$('#adrAdvice').val();

	//7、持续改进措施
	var adrImprovie=$('#adrImprovie').val();
	if(SubCat!=""){
		MainCat=SubCat
		}
	var params=armaID+"^"+RepTypeDr+"^"+RepID+"^"+adrlevel+"^"+MainCat+"^"+DealMethod+"^"+ImpMethod+"^"+adrAdvice+"^"+adrImprovie;
	
	
	
	$.post(url+'?action=SaveRepManage',{"params":params},function(data){
		var armaArr=data.split("^");
		if (armaArr[1]>0) {
			
			$.messager.alert("提示","评估成功!");
            window.parent.closeRepWindow(armaArr[1]);        //wangxuejian 2016-10-09 关闭评估窗口	2017-06-12 回传评估id
            window.parent.parent.Query();  //2017-03-17 cy 查询审核界面数据	
            window.parent.parent.CloseWinUpdate();  //2017-03-28 cy 关闭审核界面弹出的报告界面
	    }else
	    {
		  	 $.messager.alert("提示:","评估失败!");
		}
	});
	
}
//加载后台管理信息
function RepManageInfo(RepID,RepTypeDr)
{
	if(RepID==""){return;}
		//获取报表信息
 	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetRepManageInfo&adrRepID="+RepID+"&RepType="+RepTypeDr,
       success: function(val){
	        var tmp=val.split("!");
	        armaID=tmp[1];   
                
	        if (armaID!=undefined)
			{
			$('#adrleve'+tmp[2]).attr("checked",true);   //不良事件等级
			/* $('#MainCat').combobox('setValue',tmp[3]);    //一级类别
			$('#MainCat').combobox('setText',tmp[10]);    //一级类别
			
			//Combobox(tmp[3]);
			$('#SubCat').combobox('setValue',tmp[4]);     //二级类别
			$('#SubCat').combobox('setText',tmp[9]);     //二级类别
			 */
			$('#DealMethod').combobox('setValue',tmp[5]);   //处理办法
			$('#DealMethod').combobox('setText',tmp[11]);   //处理办法
			
			$('#ImpMethod').combobox('setValue',tmp[6]);   //改进办法
			$('#ImpMethod').combobox('setText',tmp[12]);   //改进办法
			$('#adrAdvice').val(tmp[7]); //不良事件评价
			$('#adrImprovie').val(tmp[8]); //持续改进措施
			$('#AssessSave').hide();//隐藏保存按钮
			} 
			else {
				armaID=""
			}
	   } ,
       error: function(){
	       alert('链接出错');
	       return;
	   }
 
	});
    
}

function Combobox(dr){
            //二级类别  
            $('#SubCat').combobox({
				//panelHeight:"auto",  //设置容器高度自动增长
				url:url+'?action=SelSubCat&params='+dr
			});    
	
}
	
function saveBeforeCheck(){
	
	//主管部门意见陈述
	var adrAdvice=$('#adrAdvice').val();
	if(adrAdvice.length>300){
		var beyond=adrAdvice.length-300;
		$.messager.alert("提示","【主管部门意见陈述】超出"+beyond+"个字");
		return false;
	}
	
	//持续改进措施
	var adrImprovie=$('#adrImprovie').val();
	if(adrImprovie.length>300){
		var beyond=adrImprovie.length-300;
		$.messager.alert("提示","【持续改进措施】超出"+beyond+"个字");
		return false;
	}
	return true;	
}
/// qunianpeng 2018/1/10 rextarea回车不换行
function textAreaListener(){
    $('textarea').keydown(function(e){
		if(e.keyCode==13){
   			 //this.value += "\n";     
		}
	});     
}
