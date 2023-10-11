/// Description: 药品质量报告单
/// Creator: yuliping
/// CreateDate: 2018-07-17
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期

$(document).ready(function(){
	InitCheckRadio();
	InitButton(); 				// 绑定保存提交按钮 包医
    ReportControl()  			//表单控制
    InitReport(recordId) 	//初始化报表
	
})
// 绑定保存提交按钮
function InitButton(){
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})

}
//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();
}

function InitCheckRadio(){
	//事件分级
	$("input[type=checkbox][id^='drugreportlevel']").click(function(){
		var id=this.id;
		$("input[type=checkbox][id^='drugreportlevel']").each(function(){
			if((this.id!=id)&($('#'+this.id).is(':checked'))){
				$('#'+this.id).removeAttr("checked");
				$("#"+this.id).nextAll(".lable-input").hide()
			}
		})
	})
	
	//是否能够提供药品标签、处方复印件等资料
	$("input[type=checkbox][id^='cancopyinfoma']").click(function(){
		var id=this.id;
		$("input[type=checkbox][id^='cancopyinfoma']").each(function(){
			if((this.id!=id)&($('#'+this.id).is(':checked'))){
				$('#'+this.id).removeAttr("checked");
				$("#"+this.id).nextAll(".lable-input").hide()
			}
		})
	})
	//死亡时间
	if($('#admheartlevel-94645').is(':checked')){
		var deathdate=$('#admheartlevel-94646').datebox("getValue");
		$('#admheartlevel-94646').datebox({disabled:false});
		$('#admheartlevel-94646').datebox("setValue",deathdate);
		$("input[type=checkbox][id^='admheartlevel-94652-']").removeAttr("checked");
		$("input[type=checkbox][id^='admheartlevel-94652-']").attr("disabled",true);
	}else{
		$('#admheartlevel-94646').datebox({disabled:'true'});
		$('#admheartlevel-94646').datebox("setValue","");
		$("input[type=checkbox][id^='admheartlevel-94652-']").attr("disabled",false) ;
	}
	//患者伤害情况
	$("input[type=checkbox][id^='admheartlevel']").click(function(){
		var id=this.id;
		if(id.split("-").length==2){
			$("input[type=checkbox][id^='admheartlevel']").each(function(){
				if((this.id!=id)&($('#'+this.id).is(':checked'))&&(this.id.split("-").length==2)){
					$('#'+this.id).removeAttr("checked");
					$("#"+this.id).nextAll(".lable-input").hide();
				}
			})
		}
		if(id.split("-").length==3){
			$("input[type=checkbox][id^='admheartlevel']").each(function(){
				if((this.id!=id)&($('#'+this.id).is(':checked'))&&(this.id.split("-").length==3)){
					$('#'+this.id).removeAttr("checked");
					$("#"+this.id).nextAll(".lable-input").hide();
				}
			})
		}
	})
}
function showDrugList(id){
	if(EpisodeID==""){
	   $.messager.alert('Warning',$g('请先选择患者就诊记录！'));
	   return;
	}
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('名称'),width:140},
		{field:'genenic',title:$g('通用名'),width:140},
	    {field:'batno',title:$g('生产批号'),width:60,hidden:true}, //,hidden:true
	    {field:'staDate',title:$g('开始日期'),width:60,hidden:true},//,hidden:true
	    {field:'endDate',title:$g('结束日期'),width:60,hidden:true},  //
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('剂量'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('用法'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('频次'),width:40},//priorty
		{field:'priorty',title:$g('优先级'),width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('疗程'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:$g('批准文号'),width:140},
		{field:'manf',title:$g('厂家'),width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:$g('剂型'),width:80},
		{field:'spec',title:$g('规格'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'vendor',title:$g('供应商'),width:80},
		{field:'OrderPackQty',title:$g('数量'),width:80}
		
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo'+'&params='+EpisodeID ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: '#admdsgridnew', //grid ID
		field:'Adm', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null, //上工具栏,空为null
	}
	var rownum=id.split(".")[1];
	var win=new CreatMyDiv(input,$("input[id^='quadruglist-'][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admdsgridnew",mycols,mydgs,"","",addDrgTest);	
	win.init();	
}

//添加药品
function addDrgTest(rowData)
{   
     var row = rowData;
    if(row==""){
	    return;
	    }
      var $td =$("input[name='"+drugname+"'][type=input]").parent().parent().children('td');
	if(checkSusAndBleIfRepApp(row.incidesc)){
		$td.eq(0).find("input").val(row.genenic);  // 通用名
		$td.eq(1).find("input").val(row.vendor); // 供应商
		$td.eq(2).find("input").val(row.manf); // 厂家 生产企业
		$td.eq(3).find("input").val(row.apprdocu);  // 批号  批准文号
		$td.eq(4).find("input").val(row.OrderPackQty);  // 数量
		$td.eq(5).find("input").val(row.form); // 剂型
		$td.eq(6).find("input").val(row.spec); // 规格
		$td.eq(7).find("input").val(row.PackUOMDesc); // 包装类型
		$td.eq(8).find("input").val(row.incidesc); // 商品名称
		//TableControl();
		
		/// 2021-02-09 cy 保存绑定医嘱id
		if(OrdList!=""){ 
			OrdList=OrdList+"$$"+row.orditm+"&&"+drugname;
		}
		if(OrdList==""){
			OrdList=row.orditm+"&&"+drugname;
		}
	}
  
}
function checkSusAndBleIfRepApp(incidesc){
	var flag=0
	$("#quadruglist").next().find("tbody tr").each(function(i){  // 药品列表
		//医嘱id
		var tdincidesc=$(this).children('td').eq(8).find("input").val()
		if(tdincidesc==incidesc){
			flag=1;
		}
	})
	if(flag!=0){
		$.messager.alert($g("提示:"),$g("该药品已添加,不能重复添加！"));
		return false;
	}
	return true;
}

function ReportControl(){
	$("input[id^='quadruglist-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name")
           showDrugList(this.id);
        }
    });
    //单选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//死亡时间
	chkdate("admheartlevel-94646")
}
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	} 
	///保存前,对页面必填项进行检查
	 if(!checkRequired()){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}	
	SaveReportCom(flag);
}
//加载报表信息
function InitReport(recordId){
	
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');			
	} 				
}
//检查table中的必填
//如果填写了长款高，后面的信息都为必填，除了气味
function checkTableRequired(){
	var errMsg=""
	
	$("#quadruglist").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// 商品名称
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+"商品名称,"
		}
		/*// 通用名
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+"通用名,"
		}
		 // 供应商
		var str2=$(this).children('td').eq(2).find("input").val();
		if(str2.length==0){
			rowMsg=rowMsg+"供应商,"
		}
		// 生产企业
		var str3=$(this).children('td').eq(3).find("input").val()
		if(str3.length==0){
			rowMsg=rowMsg+"生产企业,"
		}
		// 批号
		var str4=$(this).children('td').eq(4).find("input").val()
		if(str4.length==0){
			rowMsg=rowMsg+"批号,"
		} 
		// 数量
		var str5=$(this).children('td').eq(5).find("input").val()
		if(str5.length==0){
			rowMsg=rowMsg+"数量,"
		}
		// 剂型
		var str6=$(this).children('td').eq(6).find("input").val()
		if(str6.length==0){
			rowMsg=rowMsg+"剂型,"
		}
		// 规格
		var str7=$(this).children('td').eq(7).find("input").val()
		if(str7.length==0){
			rowMsg=rowMsg+"规格,"
		}
		// 包装类型
		var str8=$(this).children('td').eq(8).find("input").val()
		if(str8.length==0){
			rowMsg=rowMsg+"包装类型,"
		}*/
		
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"不能为空."
		}	
	
	})
	if(errMsg!=""){
		//$("html,body").stop(true);$("html,body").animate({scrollTop: $("#quadruglist").offset().top}, 1000);
		$.messager.alert($g("提示:"),errMsg);
	}
	return errMsg;
}
function add_event(){
	
}
