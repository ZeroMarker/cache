/// Description:药品不良事件
/// Creator:guoguomin
var RepDate=formatDate(0); //系统的当前日期
var EpisodeID="";
var drugid="";
$(function(){

	InitButton(); 			// 绑定保存提交按钮 包医
	ReportControl(); 		// 表单控制    包医
	CheckTimeorNum();		//时间校验
	InitCheckRadio();		//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	InitReport(recordId);  		//加载报表信息  包医
	
});

// 绑定保存提交按钮
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
//保存
function SaveReport(flag){
	if($('#PatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号/病案号回车选择记录录入患者信息！");	
		return false;
	}
	
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

//表单控制
function ReportControl(){
	
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	
	//入院时ADL得分
	$('#EventNewResult-label-97002-97013').live("keyup",function(){
		$("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
		$("input[type=radio][id='EventNewResult-label-97002']").click();	
		$("#EventNewResult-label-97014-97016").datebox("setValue","");  //并将值设置为空
		$("#EventNewResult-label-97014-97015").val("");  //并将值设置为空
	})
	$("#EventNewResult-label-97014-97015").live("keyup",function(){
		var EventNewResultdate=$('#EventNewResult-label-97014-97016').datebox('getValue');
		$("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
		$("input[type=radio][id='EventNewResult-label-97014']").click();	
		$("#EventNewResult-label-97002-97013").val("");  //并将值设置为空
		$('#EventNewResult-label-97014-97016').datebox("setValue",EventNewResultdate);
	})
	$('#EventNewResult-label-97014-97016').datebox({
	    onChange: function(){
		    if($('#EventNewResult-label-97014-97016').datebox('getValue')!=""){
		    $("input[type=radio][id^='EventNewResult-label-']").removeAttr("checked");
			$("input[type=radio][id='EventNewResult-label-97014']").click();
			$("#EventNewResult-label-97002-97013").val("");  //并将值设置为空
	    }}
	})
	 //怀疑药品开始日期控制
	if($("input[id^='SuspectNewDrug-96655']").length>0){
		$("input[id^='SuspectNewDrug-96655']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//怀疑药品结束日期控制
	if($("input[id^='SuspectNewDrug-96656']").length>0){
		$("input[id^='SuspectNewDrug-96656']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//并用药品开始日期控制
	if($("input[id^='BlendNewDrug-96681']").length>0){
		$("input[id^='BlendNewDrug-96681']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	//并用药品结束日期控制
	if($("input[id^='BlendNewDrug-96683']").length>0){
		$("input[id^='BlendNewDrug-96683']").datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
	}
	
	$("input[id^='SuspectNewDrug-96650']").live('keydown',function(event){	
	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name");
		   drugid="SuspectNewDrug";
		  
           showDrugList(this.id);
        }
    });
    $("input[id^='BlendNewDrug-96675']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   drugname=$(this).attr("name");
		   drugid="BlendNewDrug"; 
           showDrugList(this.id);
        }
    });
   TableControl(); 
    
}
//加载报表信息
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');				
	} 
}

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	$("input[type=radio][id^='EventNewResult-label-']").each(function(){
		if ($(this).is(':checked')){
			//是否后遗症
			if(this.id!="EventNewResult-label-97002"){
				$("#EventNewResult-label-97002-97013").val("");  //并将值设置为空
			}
			//死亡
			if((this.id!="EventNewResult-label-97014")){
				$("#EventNewResult-label-97014-97015").val("");  //并将值设置为空	
				$("#EventNewResult-label-97014-97016").datebox("setValue","");  //并将值设置为空
		        
			}
		}
	})
}

//加载药品列表
function showDrugList(id){
	if(EpisodeID==""){
		$.messager.alert("提示:","请先选择患者就诊记录！");
		return;
	}
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'名称',width:140},
		{field:'genenic',title:'通用名',width:140},
	    {field:'batno',title:'生产批号',width:60,hidden:true}, //,hidden:true
	    {field:'staDate',title:'开始日期',width:60,hidden:true},//,hidden:true
	    {field:'endDate',title:'结束日期',width:60,hidden:true},  //
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},//priorty
		{field:'priorty',title:'优先级',width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:140},
		{field:'manf',title:'厂家',width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
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
	var win=new CreatMyDiv(input,$("input[id^="+drugid+"-][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admdsgridnew",mycols,mydgs,"","",addDrgTest);	
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
		$td.eq(0).find("input").val(row.apprdocu);
		$td.eq(1).find("input").val(row.incidesc);
		$td.eq(2).find("input").val(row.genenic+"/["+row.form+"]");
		$td.eq(3).find("input").val(row.manf); 
		$td.eq(4).find("input").val(row.batno); 
		$td.eq(5).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq);
		$td.eq(6).find(".combo-value").val(row.staDate);
		$td.eq(6).find(".combo-text").val(row.staDate);
		$td.eq(7).find(".combo-value").val(row.endDate);
		$td.eq(7).find(".combo-text").val(row.endDate);
		TableControl();
	}
}
function checkSusAndBleIfRepApp(incidesc){
	var flag=0
	$("#SuspectNewDrug").next().find("tbody tr").each(function(i){//怀疑药品
		//医嘱id
		var tdincidesc=$(this).children('td').eq(1).find("input").val()
		if(tdincidesc==incidesc){
			flag=1;
		}
	})
	$("#BlendNewDrug").next().find("tbody tr").each(function(i){//并用药品
		//医嘱id
		var tdincidesc=$(this).children('td').eq(1).find("input").val()
		if(tdincidesc==incidesc){
			flag=2;
		}
	}) 
	if((drugid=="BlendNewDrug")&&(flag==1)){
		$.messager.alert("提示:","该药品已为怀疑药品,不可同时为并用药品！");
		return false;
	}
	if((drugid=="SuspectNewDrug")&&(flag==2)){
		$.messager.alert("提示:","该药品已为并用药品,不可同时为怀疑药品！");
		return false;
	}
	if(flag!=0){
		$.messager.alert("提示:","该药品已添加,不能重复添加！");
		return false;
	}
	return true;
}
//时间 数字校验
function CheckTimeorNum(){
	//时间输入校验
		
}
function doOther(){
}
function add_event(){
	//怀疑药品开始日期控制
	$("input[id^='SuspectNewDrug-96655']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	//怀疑药品结束日期控制
	$("input[id^='SuspectNewDrug-96656']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	})
	//并用药品开始日期控制
	$("input[id^='BlendNewDrug-96681']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	})
	//并用药品结束日期控制
	$("input[id^='BlendNewDrug-96683']").each(function(){
		if((this.id.split("-").length==2)){
			var DrugDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (DrugDate!=""){
				$("#"+this.id).datebox("setValue",DrugDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	TableControl();
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	//不良反应/事件的结果
	var EventNewResultFlag=0;
	$("input[type=radio][id^='EventNewResult-label-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="有后遗症")&&($("#EventNewResult-label-97002-97013").val()=="")){
				EventNewResultFlag=-1;
			}
			if ((this.value=="死亡")&&(($("#EventNewResult-label-97014-97015").val()=="")||($("#EventNewResult-label-97014-97016").datebox('getValue')==""))){
				EventNewResultFlag=-2;
			}
		}
	})
	if(EventNewResultFlag==-1){
		$.messager.alert("提示:","【不良反应/事件的结果】勾选'有后遗症'，请填写表现！");	
		return false;
	}
	if(EventNewResultFlag==-2){
		$.messager.alert("提示:","【不良反应/事件的结果】勾选'死亡'，请填写直接死因与死亡时间！");	
		return false;
	}
	
	///判断怀疑药品和并用药品不能同时为空
	if(!(getDgData("SuspectNewDrug"))&&(!getDgData("BlendNewDrug"))){
		if(MKIOrdFlag!="1"){
			$.messager.alert("提示:","怀疑药品和并用药品不能同时为空（列表手动输入药品无效，需回车选择医嘱）！");
		}else{
			$.messager.alert("提示:","怀疑药品和并用药品不能同时为空（列表输入药品信息少，需补充信息）！");
		}
		return false;
	}
	
	
	return true;
}
///取列表前三列数据 sufan 2019-12-09
function getDgData(dgkey)
{
	var retval=true;
	$("#"+dgkey).next().find("tbody tr").each(function(i){
		var rowMsg=""
		// 批准文号
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+"批准文号,"
		}
		// 商品名称
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+"商品名称,"
		}
		// 通用名称
		var str2=$(this).children('td').eq(2).find("input").val();
		if(str2.length==0){
			rowMsg=rowMsg+"通用名称,"
		}
		
		if(rowMsg!=""){
			retval=false;
			return false;
		}	
	
	})
	
	return retval;
}

function TableControl(){
	// 根据 是否允许手工输入医嘱 控制
	    $("[id^='SuspectNewDrug-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="SuspectNewDrug-96650")&&(rowid!="SuspectNewDrug-96653")&&(rowid!="SuspectNewDrug-96657")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				/* if((rowid=="SuspectNewDrug-96655")||(rowid=="SuspectNewDrug-96656")){
					$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				} */
			}
		})
		$("[id^='BlendNewDrug-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="BlendNewDrug-96675")&&(rowid!="BlendNewDrug-96678")&&(rowid!="BlendNewDrug-96685")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				/* if((rowid=="BlendNewDrug-96681")||(rowid=="BlendNewDrug-96683")){
					$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				} */
			}
		})
		
}
